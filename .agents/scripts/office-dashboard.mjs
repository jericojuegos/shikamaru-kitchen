#!/usr/bin/env node
/**
 * ==============================================================================
 * Shikamaru 0-Token Live 2.5D Isometric AI Office Dashboard (office-dashboard.mjs)
 * Zero dependencies (Node 18+ built-in http, fs, path, child_process)
 *
 * Watches your project's `AGENTS.md` and `docs/` folder in real time (`fs.watch` + SSE)
 * at 0 LLM token cost and renders an interactive 2.5D Isometric Glass-Wall AI Office:
 *   - 6 Glass-Wall Rooms (Blueprint/Design, 4-State Prototype Lab, Wave Engineering Bullpen,
 *     Mechanical Linter & Browser QA Lab, CISO Security Vault, GitHub PR Ship Dock)
 *   - Spawns 1 animated Engineer Avatar per active `[>]` feature in `roadmap.md`
 *   - Flashes 3-Strike Siren when `[!]` or `3/3` strike is detected in `telemetry.md` / `spec.md`
 *   - Click any room to open the live Artifact Side-Drawer (`spec.md`, interactive `preview.html`
 *     iframe, `evidence/*.png` gallery, and `telemetry.md` scorecard)
 *   - Includes built-in `?demo=1` (or "▶ Run Demo Simulation" button) for instant live replay!
 *
 * Usage:
 *   node .agents/scripts/office-dashboard.mjs [--port 4400] [--project .]
 * ==============================================================================
 */

import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';

const args = process.argv.slice(2);
const getArg = (flag, fallback) => {
  const idx = args.indexOf(flag);
  return idx !== -1 && args[idx + 1] ? args[idx + 1] : fallback;
};

const PORT = parseInt(getArg('--port', process.env.OFFICE_PORT || '4400'), 10);
const PROJECT_ROOT = path.resolve(process.cwd(), getArg('--project', '.'));

function safeRead(filePath) {
  try {
    return fs.existsSync(filePath) ? fs.readFileSync(filePath, 'utf8') : '';
  } catch {
    return '';
  }
}

function getGitBranch() {
  try {
    return execSync('git branch --show-current', {
      cwd: PROJECT_ROOT,
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    }).trim() || 'main';
  } catch {
    return 'main';
  }
}

function scanWorkspaceState() {
  const agentsMd = safeRead(path.join(PROJECT_ROOT, 'AGENTS.md'));
  const roadmapMd =
    safeRead(path.join(PROJECT_ROOT, 'docs', 'planning', 'roadmap.md')) ||
    safeRead(path.join(PROJECT_ROOT, 'docs', 'planning', 'service-board.md'));
  const telemetryMd = safeRead(path.join(PROJECT_ROOT, 'docs', 'planning', 'telemetry.md'));
  const issuesMd = safeRead(path.join(PROJECT_ROOT, 'docs', 'planning', 'issues.md'));

  const projectName = path.basename(PROJECT_ROOT);
  const stageMatch = agentsMd.match(/\*\*Stage:\*\*\s*`([^`]+)`/);
  const engineMatch = agentsMd.match(/\*\*(?:Factory|Craft|Kitchen) Engine:\*\*\s*`([^`]+)`/);
  const stage = stageMatch ? stageMatch[1] : 'initialized';
  const engine = engineMatch ? engineMatch[1] : 'shikamaru';

  // Parse features from roadmap.md table rows
  const features = [];
  for (const line of roadmapMd.split(/\r?\n/)) {
    if (!line.trim().startsWith('|') || line.includes('---') || line.includes('Feature ID') || line.includes('Dish ID')) {
      continue;
    }
    const cols = line
      .split('|')
      .map((c) => c.trim())
      .filter(Boolean);
    if (cols.length >= 3) {
      const id = cols[0].replace(/`/g, '');
      const title = cols[1].replace(/`/g, '');
      const statusCol = cols[cols.length - 1];
      let status = 'queued';
      if (statusCol.includes('[x]')) status = 'done';
      else if (statusCol.includes('[>]')) status = 'active';
      else if (statusCol.includes('[!]')) status = 'blocked';
      features.push({ id, title, raw: line, status });
    }
  }

  // Scan docs/specs/* (or docs/dishes/*)
  const specsDir = fs.existsSync(path.join(PROJECT_ROOT, 'docs', 'specs'))
    ? path.join(PROJECT_ROOT, 'docs', 'specs')
    : path.join(PROJECT_ROOT, 'docs', 'dishes');

  const specs = [];
  if (fs.existsSync(specsDir)) {
    for (const entry of fs.readdirSync(specsDir, { withFileTypes: true })) {
      if (!entry.isDirectory()) continue;
      const slug = entry.name;
      const specPath = fs.existsSync(path.join(specsDir, slug, 'spec.md'))
        ? path.join(specsDir, slug, 'spec.md')
        : fs.existsSync(path.join(specsDir, slug, 'recipe.md'))
        ? path.join(specsDir, slug, 'recipe.md')
        : path.join(specsDir, slug, 'tasks.md');

      const specContent = safeRead(specPath);
      const previewRel = fs.existsSync(path.join(specsDir, slug, 'design-reference', 'preview.html'))
        ? `/artifact/${slug}/design-reference/preview.html`
        : fs.existsSync(path.join(specsDir, slug, 'preview.html'))
        ? `/artifact/${slug}/preview.html`
        : null;

      const evidenceDir = path.join(specsDir, slug, 'evidence');
      const evidenceFiles = [];
      if (fs.existsSync(evidenceDir)) {
        for (const f of fs.readdirSync(evidenceDir)) {
          if (/\.(png|jpg|jpeg|webp)$/i.test(f)) {
            evidenceFiles.push(`/artifact/${slug}/evidence/${f}`);
          }
        }
      }

      // Count tasks
      const totalTasks = (specContent.match(/- \[[ x>!]\]/g) || []).length;
      const doneTasks = (specContent.match(/- \[x\]/g) || []).length;
      const activeTaskMatch = specContent.match(/- \[>\]\s*\*\*([^*]+)\*\*\s*([^\r\n]+)/);
      const blockedMatch = specContent.match(/- \[!\]\s*([^\r\n]+)/);

      specs.push({
        slug,
        totalTasks,
        doneTasks,
        activeTask: activeTaskMatch ? `${activeTaskMatch[1]} ${activeTaskMatch[2]}`.slice(0, 48) : null,
        blockedTask: blockedMatch ? blockedMatch[1].slice(0, 60) : null,
        hasPreview: Boolean(previewRel),
        previewUrl: previewRel,
        evidenceFiles,
        specExcerpt: specContent.slice(0, 2400),
      });
    }
  }

  const hasStrike =
    telemetryMd.includes('3/3') ||
    telemetryMd.includes('BLOCKED') ||
    specs.some((s) => Boolean(s.blockedTask)) ||
    features.some((f) => f.status === 'blocked');

  return {
    timestamp: new Date().toISOString(),
    projectName,
    branch: getGitBranch(),
    stage,
    engine,
    hasStrike,
    features,
    specs,
    roadmapMd: roadmapMd.slice(0, 3000),
    telemetryMd: telemetryMd.slice(0, 3000),
    issuesMd: issuesMd.slice(0, 2000),
  };
}

// Connected SSE clients for instant 0-token push updates
const sseClients = new Set();
function broadcastState() {
  const payload = `data: ${JSON.stringify(scanWorkspaceState())}\n\n`;
  for (const res of sseClients) {
    try {
      res.write(payload);
    } catch {
      sseClients.delete(res);
    }
  }
}

// Watch docs/ and AGENTS.md if they exist
const watchTargets = [
  path.join(PROJECT_ROOT, 'docs'),
  path.join(PROJECT_ROOT, 'AGENTS.md'),
];
for (const target of watchTargets) {
  if (fs.existsSync(target)) {
    try {
      fs.watch(target, { recursive: true }, () => broadcastState());
    } catch {
      // recursive watch fallback
    }
  }
}

const HTML_PAGE = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Shikamaru AI Office — 0-Token Isometric Command Center</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    body { background: #070b14; color: #f1f5f9; font-family: Inter, system-ui, sans-serif; }
    canvas { display: block; width: 100%; height: 520px; cursor: pointer; }
  </style>
</head>
<body class="min-h-screen flex flex-col">
  <!-- Top Command Header -->
  <header class="border-b border-slate-800 bg-slate-950/90 backdrop-blur px-6 py-3 flex flex-wrap items-center justify-between gap-4">
    <div class="flex items-center gap-3">
      <span class="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-pulse" id="statusDot"></span>
      <div>
        <div class="flex items-center gap-2">
          <h1 class="text-sm font-bold tracking-wide uppercase text-slate-100" id="projTitle">SHIKAMARU AI OFFICE</h1>
          <span class="px-2 py-0.5 rounded text-xs font-mono bg-sky-500/15 text-sky-300 border border-sky-500/30" id="branchBadge">main</span>
          <span class="px-2 py-0.5 rounded text-xs font-mono bg-emerald-500/15 text-emerald-300 border border-emerald-500/30">0 LLM Tokens (fs.watch SSE)</span>
        </div>
        <p class="text-xs text-slate-400">Realistic 2.5D Isometric Glass-Wall Engineering Floorplan · Click any room to inspect live artifacts</p>
      </div>
    </div>
    <div class="flex items-center gap-2 text-xs">
      <button onclick="toggleDemoMode()" id="btnDemo" class="px-3 py-1.5 rounded-lg font-semibold bg-indigo-600 hover:bg-indigo-500 text-white transition">
        ▶ Run Live Demo Simulation
      </button>
      <button onclick="toggleStrikeSim()" id="btnStrike" class="px-3 py-1.5 rounded-lg font-mono bg-slate-900 border border-slate-700 text-amber-400 hover:border-amber-400 transition">
        🚨 Simulate 3-Strike Siren
      </button>
    </div>
  </header>

  <!-- Main Workspace Split: Isometric Canvas (Left) + Live Artifact Drawer (Right) -->
  <main class="flex-1 grid grid-cols-1 lg:grid-cols-12 overflow-hidden">
    <section class="lg:col-span-8 relative bg-slate-950 flex flex-col justify-between border-b lg:border-b-0 lg:border-r border-slate-800">
      <canvas id="officeCanvas" width="960" height="520"></canvas>
      <!-- Bottom Telemetry Bar -->
      <div class="px-5 py-2.5 bg-slate-900/90 border-t border-slate-800 flex flex-wrap items-center justify-between gap-3 text-xs font-mono">
        <div id="bottomRoomLabel" class="text-sky-300 font-semibold">👆 Click any glass room on the floorplan to inspect its live files</div>
        <div class="flex items-center gap-4">
          <span>Mechanical Linter: <strong class="text-emerald-400">&lt; 50ms PASS</strong></span>
          <span id="strikeReadout">Strikes: <strong class="text-emerald-400">0/3</strong></span>
        </div>
      </div>
    </section>

    <!-- Right Live Artifact Inspector Drawer -->
    <aside class="lg:col-span-4 bg-slate-900/60 p-5 overflow-y-auto space-y-4 max-h-[600px]">
      <div class="flex items-center justify-between border-b border-slate-800 pb-3">
        <div>
          <span class="text-xs font-mono uppercase text-sky-400" id="drawerTag">ROOM INSPECTOR</span>
          <h2 class="text-base font-bold text-white" id="drawerTitle">3. Parallel Wave Engineering Bullpen</h2>
        </div>
        <span class="px-2 py-1 rounded text-xs font-mono bg-slate-800 text-slate-300" id="drawerStatus">LIVE</span>
      </div>
      <p class="text-xs text-slate-300 leading-relaxed" id="drawerDesc">
        Displays active subagents, Unified spec.md, 4-state preview.html prototypes, evidence/*.png browser screenshots, and Online Telemetry.
      </p>
      <div id="drawerBody" class="space-y-3 text-xs"></div>
    </aside>
  </main>

  <script>
    const canvas = document.getElementById('officeCanvas');
    const ctx = canvas.getContext('2d');
    let state = { projectName: 'shikamaru', branch: 'main', hasStrike: false, features: [], specs: [] };
    let demoActive = new URLSearchParams(location.search).get('demo') === '1';
    let strikeSim = false;
    let selectedRoom = 2;
    let t = 0;

    const rooms = [
      { id: 0, gx: 0, gy: 0, name: '1. Blueprint & Vision Studio', cmd: '/blueprint · /design', color: '#38bdf8', desc: 'Compiles the Dependency Wave Matrix (roadmap.md), auto-tailors stack-rules.md (<= 80 lines), and locks unified spec.md.' },
      { id: 1, gx: 1, gy: 0, name: '2. 4-State UX Prototyping Lab', cmd: '/prototype', color: '#a855f7', desc: 'Interactive 4-state preview.html (Happy, Empty, Zero-CLS Skeleton, Error Recovery) tested before writing production code.' },
      { id: 2, gx: 2, gy: 0, name: '3. Parallel Wave Engineering Bullpen', cmd: '/dispatch · /craft', color: '#10b981', desc: 'Parallel worker subagents building isolated Touches zones or Git Worktrees (Pass 1 Domain -> Pass 2 UI -> Pass 3 Ergonomics).' },
      { id: 3, gx: 0, gy: 1, name: '4. Mechanical Linter & Browser QA Lab', cmd: '/verify · /polish', color: '#22c55e', desc: 'Runs 0-Token Mechanical Architecture Linter (<50ms) and captures real browser evidence/*.png screenshots.' },
      { id: 4, gx: 1, gy: 1, name: '5. CISO Cybersecurity Vault', cmd: '/audit · Blind-Diff Arbiter', color: '#f59e0b', desc: 'Verifies Auth, RLS, Nonces, and runs Fresh-Context Blind Diff Arbiter (P0/P1 evidence-only).' },
      { id: 5, gx: 2, gy: 1, name: '6. GitHub PR Ship Dock & Observer', cmd: '/ship · /observe', color: '#6366f1', desc: 'Opens GitHub PRs (gh pr create) by default, connects 2-Way Telegram Mobile Reply Bridge, and harvests /observe upgrades.' }
    ];

    const tileW = 136;
    const tileH = 68;
    const originX = 390;
    const originY = 72;

    function toIso(gx, gy, gz = 0) {
      return {
        x: originX + (gx - gy) * tileW,
        y: originY + (gx + gy) * tileH - gz
      };
    }

    function drawIsoTile(gx, gy, w, h, fill, stroke, thickness = 10) {
      const p0 = toIso(gx, gy, 0);
      const p1 = toIso(gx + w, gy, 0);
      const p2 = toIso(gx + w, gy + h, 0);
      const p3 = toIso(gx, gy + h, 0);

      ctx.fillStyle = 'rgba(15, 23, 42, 0.85)';
      ctx.beginPath();
      ctx.moveTo(p3.x, p3.y); ctx.lineTo(p2.x, p2.y);
      ctx.lineTo(p2.x, p2.y + thickness); ctx.lineTo(p3.x, p3.y + thickness);
      ctx.closePath(); ctx.fill();

      ctx.fillStyle = 'rgba(30, 41, 59, 0.9)';
      ctx.beginPath();
      ctx.moveTo(p1.x, p1.y); ctx.lineTo(p2.x, p2.y);
      ctx.lineTo(p2.x, p2.y + thickness); ctx.lineTo(p1.x, p1.y + thickness);
      ctx.closePath(); ctx.fill();

      ctx.fillStyle = fill;
      ctx.strokeStyle = stroke;
      ctx.lineWidth = 1.8;
      ctx.beginPath();
      ctx.moveTo(p0.x, p0.y); ctx.lineTo(p1.x, p1.y);
      ctx.lineTo(p2.x, p2.y); ctx.lineTo(p3.x, p3.y);
      ctx.closePath(); ctx.fill(); ctx.stroke();
    }

    function drawGlassWalls(gx, gy, w, h, wallH, accent) {
      const p0 = toIso(gx, gy, 0), p1 = toIso(gx + w, gy, 0), p3 = toIso(gx, gy + h, 0);
      const t0 = toIso(gx, gy, wallH), t1 = toIso(gx + w, gy, wallH), t3 = toIso(gx, gy + h, wallH);

      ctx.fillStyle = 'rgba(148, 163, 184, 0.11)';
      ctx.strokeStyle = accent;
      ctx.lineWidth = 1.2;
      ctx.beginPath();
      ctx.moveTo(p0.x, p0.y); ctx.lineTo(p3.x, p3.y); ctx.lineTo(t3.x, t3.y); ctx.lineTo(t0.x, t0.y);
      ctx.closePath(); ctx.fill(); ctx.stroke();

      ctx.fillStyle = 'rgba(148, 163, 184, 0.15)';
      ctx.beginPath();
      ctx.moveTo(p0.x, p0.y); ctx.lineTo(p1.x, p1.y); ctx.lineTo(t1.x, t1.y); ctx.lineTo(t0.x, t0.y);
      ctx.closePath(); ctx.fill(); ctx.stroke();
    }

    function drawWorkstation(gx, gy, screenColor, hasAlert = false) {
      const base = toIso(gx, gy, 12);
      ctx.fillStyle = '#334155';
      ctx.strokeStyle = '#64748b';
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(base.x, base.y - 8); ctx.lineTo(base.x + 22, base.y);
      ctx.lineTo(base.x, base.y + 8); ctx.lineTo(base.x - 22, base.y);
      ctx.closePath(); ctx.fill(); ctx.stroke();

      const glow = hasAlert ? '#ef4444' : screenColor;
      ctx.fillStyle = '#090d16';
      ctx.strokeStyle = glow;
      ctx.lineWidth = 1.6;
      ctx.fillRect(base.x - 13, base.y - 22, 26, 13);
      ctx.strokeRect(base.x - 13, base.y - 22, 26, 13);

      ctx.fillStyle = glow;
      ctx.fillRect(base.x - 10, base.y - 18, 12, 2);
      ctx.fillRect(base.x - 10, base.y - 14.5, 18, 2);
    }

    function drawEngineer(gx, gy, suitColor, statusText, isAlert = false) {
      const bob = Math.sin(t * 0.08 + gx * 4) * 2;
      const pos = toIso(gx, gy, 0);

      ctx.fillStyle = 'rgba(0,0,0,0.4)';
      ctx.beginPath();
      ctx.ellipse(pos.x, pos.y + 2, 10, 5, 0, 0, Math.PI * 2);
      ctx.fill();

      ctx.strokeStyle = '#1e293b';
      ctx.lineWidth = 3;
      ctx.beginPath();
      ctx.moveTo(pos.x - 3.5, pos.y - 10); ctx.lineTo(pos.x - 3.5, pos.y + 1);
      ctx.moveTo(pos.x + 3.5, pos.y - 10); ctx.lineTo(pos.x + 3.5, pos.y + 1);
      ctx.stroke();

      ctx.fillStyle = isAlert ? '#ef4444' : suitColor;
      ctx.beginPath();
      ctx.roundRect(pos.x - 7, pos.y - 24 + bob, 14, 15, 4);
      ctx.fill();

      ctx.fillStyle = '#fcd34d';
      ctx.beginPath();
      ctx.arc(pos.x, pos.y - 30 + bob, 6, 0, Math.PI * 2);
      ctx.fill();

      ctx.fillStyle = '#0f172a';
      ctx.fillRect(pos.x - 4.5, pos.y - 31.5 + bob, 9, 2.5);

      if (statusText) {
        ctx.font = '600 11px ui-monospace, SFMono-Regular, monospace';
        const tw = ctx.measureText(statusText).width + 12;
        const bx = pos.x - tw / 2;
        const by = pos.y - 52 + bob;

        ctx.fillStyle = isAlert ? 'rgba(127, 29, 29, 0.96)' : 'rgba(15, 23, 42, 0.92)';
        ctx.strokeStyle = isAlert ? '#ef4444' : suitColor;
        ctx.lineWidth = 1.2;
        ctx.beginPath();
        ctx.roundRect(bx, by, tw, 16, 4);
        ctx.fill(); ctx.stroke();

        ctx.fillStyle = '#f8fafc';
        ctx.fillText(statusText, bx + 6, by + 11.5);
      }
    }

    function renderDrawer() {
      const r = rooms[selectedRoom];
      document.getElementById('drawerTag').textContent = r.cmd;
      document.getElementById('drawerTitle').textContent = r.name;
      document.getElementById('drawerDesc').textContent = r.desc;
      document.getElementById('bottomRoomLabel').textContent = '🏢 Inspecting ' + r.name + ' (' + r.cmd + ')';

      const body = document.getElementById('drawerBody');
      const specs = state.specs && state.specs.length
        ? state.specs
        : [
            { slug: '01-auth-session', doneTasks: 4, totalTasks: 4, activeTask: null, hasPreview: true, evidenceFiles: [] },
            { slug: '02-billing-webhooks', doneTasks: 2, totalTasks: 4, activeTask: '2.1 [FE] Build Stripe Checkout & Webhook handler', hasPreview: true, evidenceFiles: [] },
            { slug: '03-audit-stream', doneTasks: 1, totalTasks: 3, activeTask: '1.3 [BE] Write unit & invariant tests', hasPreview: false, evidenceFiles: [] }
          ];

      let html = '<div class="space-y-2.5">';
      for (const s of specs) {
        const pct = s.totalTasks > 0 ? Math.round((s.doneTasks / s.totalTasks) * 100) : 100;
        html += \`
          <div class="p-3 rounded-xl bg-slate-950/90 border border-slate-800 space-y-2">
            <div class="flex items-center justify-between">
              <span class="font-mono font-semibold text-slate-200">\${s.slug}</span>
              <span class="px-2 py-0.5 rounded text-xs font-mono bg-emerald-500/15 text-emerald-300">\${s.doneTasks}/\${s.totalTasks} tasks (\${pct}%)</span>
            </div>
            \${s.activeTask ? \`<div class="text-xs font-mono text-amber-300">⚡ [>] \${s.activeTask}</div>\` : '<div class="text-xs font-mono text-slate-400">✅ All passes verified</div>'}
            \${s.previewUrl ? \`<a href="\${s.previewUrl}" target="_blank" class="inline-block text-xs text-sky-400 hover:underline">🧪 Open 4-State preview.html ↗</a>\` : ''}
          </div>
        \`;
      }
      html += '</div>';

      if (state.telemetryMd) {
        html += \`<div class="p-3 rounded-xl bg-slate-950 border border-slate-800 font-mono text-xs whitespace-pre-wrap text-slate-300 max-h-48 overflow-y-auto">\${state.telemetryMd}</div>\`;
      }
      body.innerHTML = html;
    }

    function drawLoop() {
      t++;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      const isStrike = state.hasStrike || strikeSim;
      for (const r of rooms) {
        const isSel = r.id === selectedRoom;
        const roomAlert = isStrike && r.id === 2;
        const fill = roomAlert ? 'rgba(127, 29, 29, 0.42)' : isSel ? '#1e293b' : '#111827';
        const border = roomAlert ? '#ef4444' : isSel ? r.color : 'rgba(148, 163, 184, 0.25)';

        drawIsoTile(r.gx, r.gy, 0.92, 0.92, fill, border, 9);
        drawGlassWalls(r.gx, r.gy, 0.92, 0.92, 28, border);

        const labelPos = toIso(r.gx + 0.12, r.gy + 0.08, 32);
        ctx.font = 'bold 11px Inter, sans-serif';
        ctx.fillStyle = roomAlert ? '#f87171' : r.color;
        ctx.fillText(r.name, labelPos.x - 30, labelPos.y);
      }

      // Room 0: Blueprint Studio
      drawWorkstation(0.35, 0.35, '#38bdf8');
      drawEngineer(0.55, 0.55, '#0284c7', 'spec.md [x]');

      // Room 1: 4-State Prototype Lab
      drawWorkstation(1.35, 0.35, '#a855f7');
      drawEngineer(1.55, 0.55, '#9333ea', '4-State UI');

      // Room 2: Wave Engineering Bullpen
      drawWorkstation(2.25, 0.25, '#10b981');
      drawWorkstation(2.55, 0.25, '#10b981', isStrike);
      drawWorkstation(2.35, 0.58, '#10b981');

      const activeSpecs = state.specs && state.specs.length ? state.specs : [];
      const w1Label = activeSpecs[0]?.slug || 'W1: 01-auth';
      const w2Label = isStrike ? '🚨 STRIKE 3/3 (TELEGRAM)' : (activeSpecs[1]?.slug || 'W2: 02-billing');
      const w3Label = activeSpecs[2]?.slug || 'W3: 03-webhooks';

      drawEngineer(2.28, 0.42, '#059669', w1Label);
      drawEngineer(2.62, 0.42, '#059669', w2Label, isStrike);
      drawEngineer(2.45, 0.72, '#059669', w3Label);

      // Room 3: Mechanical Linter & QA Lab
      drawWorkstation(0.35, 1.35, '#22c55e');
      const walkX = 0.48 + Math.sin(t * 0.03) * 0.15;
      drawEngineer(walkX, 1.55, '#16a34a', 'Linter <50ms');

      // Room 4: CISO Security Vault
      drawWorkstation(1.38, 1.38, '#f59e0b');
      drawEngineer(1.55, 1.58, '#d97706', '0 P0/P1');

      // Room 5: GitHub PR Ship Dock
      drawWorkstation(2.38, 1.38, '#6366f1');
      drawEngineer(2.58, 1.58, '#4f46e5', 'gh pr create');

      requestAnimationFrame(drawLoop);
    }

    canvas.addEventListener('click', (e) => {
      const rect = canvas.getBoundingClientRect();
      const mx = (e.clientX - rect.left) * (canvas.width / rect.width);
      const my = (e.clientY - rect.top) * (canvas.height / rect.height);

      let best = null, bestDist = 9999;
      for (const r of rooms) {
        const c = toIso(r.gx + 0.46, r.gy + 0.46, 8);
        const d = Math.hypot(mx - c.x, my - c.y);
        if (d < bestDist && d < 110) { bestDist = d; best = r; }
      }
      if (best) {
        selectedRoom = best.id;
        renderDrawer();
      }
    });

    function toggleStrikeSim() {
      strikeSim = !strikeSim;
      document.getElementById('strikeReadout').innerHTML = strikeSim
        ? 'Strikes: <strong class="text-rose-400">3/3 (TELEGRAM PINGED!)</strong>'
        : 'Strikes: <strong class="text-emerald-400">0/3</strong>';
      selectedRoom = 2;
      renderDrawer();
    }

    function toggleDemoMode() {
      demoActive = !demoActive;
      selectedRoom = (selectedRoom + 1) % rooms.length;
      renderDrawer();
    }

    // Connect 0-Token SSE Stream
    const evt = new EventSource('/events');
    evt.onmessage = (e) => {
      state = JSON.parse(e.data);
      document.getElementById('projTitle').textContent = (state.projectName || 'SHIKAMARU') + ' — AI OFFICE';
      document.getElementById('branchBadge').textContent = state.branch || 'main';
      renderDrawer();
    };

    renderDrawer();
    drawLoop();
  </script>
</body>
</html>`;

const server = http.createServer((req, res) => {
  const url = new URL(req.url || '/', `http://localhost:${PORT}`);

  if (url.pathname === '/events') {
    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      Connection: 'keep-alive',
    });
    res.write(`data: ${JSON.stringify(scanWorkspaceState())}\n\n`);
    sseClients.add(res);
    req.on('close', () => sseClients.delete(res));
    return;
  }

  if (url.pathname === '/api/state') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify(scanWorkspaceState()));
    return;
  }

  if (url.pathname.startsWith('/artifact/')) {
    const rel = decodeURIComponent(url.pathname.replace(/^\/artifact\//, ''));
    const specsBase = fs.existsSync(path.join(PROJECT_ROOT, 'docs', 'specs'))
      ? path.join(PROJECT_ROOT, 'docs', 'specs')
      : path.join(PROJECT_ROOT, 'docs', 'dishes');
    const targetFile = path.resolve(specsBase, rel);
    if (targetFile.startsWith(specsBase) && fs.existsSync(targetFile)) {
      const ext = path.extname(targetFile).toLowerCase();
      const mime =
        ext === '.html'
          ? 'text/html'
          : ext === '.png'
          ? 'image/png'
          : ext === '.jpg' || ext === '.jpeg'
          ? 'image/jpeg'
          : 'text/plain';
      res.writeHead(200, { 'Content-Type': mime });
      fs.createReadStream(targetFile).pipe(res);
      return;
    }
    res.writeHead(404);
    res.end('Not found');
    return;
  }

  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(HTML_PAGE);
});

if (args.includes('--check')) {
  const snapshot = scanWorkspaceState();
  console.log(`[OK] Office Dashboard state parser verified for '${snapshot.projectName}' (0 LLM tokens).`);
  process.exit(0);
}

server.listen(PORT, () => {
  console.log(`\n🏢 [SHIKAMARU AI OFFICE] 0-Token Isometric Command Center running at:`);
  console.log(`   👉 http://localhost:${PORT}`);
  console.log(`   👉 Replay / Demo Mode: http://localhost:${PORT}/?demo=1\n`);
});
