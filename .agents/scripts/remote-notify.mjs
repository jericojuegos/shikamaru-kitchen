#!/usr/bin/env node
/**
 * ==============================================================================
 * 2-Way Remote Notification & Mobile Reply Bridge (remote-notify.mjs)
 * Zero dependencies (Node 18+ built-in fetch & child_process)
 *
 * Supports:
 *   1. Telegram 2-Way Bot (`TELEGRAM_BOT_TOKEN` + `TELEGRAM_CHAT_ID`):
 *      Sends alert to your phone and long-polls `getUpdates` for your reply
 *      (e.g., "proceed", "ship", or custom fix instructions) with zero webhooks/ngrok!
 *   2. GitHub PR/Issue 2-Way Comment (`--gh-pr <number>` or current branch PR via `gh`):
 *      Posts a comment to the GitHub PR and polls `gh pr view --json comments`
 *      for your reply from the GitHub Mobile App.
 *   3. Discord / Slack 1-Way Push (`NOTIFY_WEBHOOK_URL`):
 *      Sends rich alert cards to Discord or Slack webhooks.
 *
 * Usage:
 *   node .agents/scripts/remote-notify.mjs --message "⚠️ 3-Strike Blocker on 02-billing..." [--wait-reply] [--timeout 1800]
 * ==============================================================================
 */

import { execSync } from 'node:child_process';

const args = process.argv.slice(2);
const getArg = (flag, fallback = '') => {
  const idx = args.indexOf(flag);
  return idx !== -1 && args[idx + 1] ? args[idx + 1] : fallback;
};

const message = getArg('--message', '🔔 Agent Notification');
const waitReply = args.includes('--wait-reply');
const timeoutSec = parseInt(getArg('--timeout', '1800'), 10); // default 30 min wait

const tgToken = process.env.TELEGRAM_BOT_TOKEN || '';
const tgChatId = process.env.TELEGRAM_CHAT_ID || '';
const webhookUrl = process.env.NOTIFY_WEBHOOK_URL || '';

async function sendTelegram(text) {
  if (!tgToken || !tgChatId) return null;
  const res = await fetch(`https://api.telegram.org/bot${tgToken}/sendMessage`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ chat_id: tgChatId, text }),
  });
  const data = await res.json();
  return data?.result?.message_id ?? null;
}

async function pollTelegramReply(sinceDateUnix, deadlineMs) {
  let offset = 0;
  while (Date.now() < deadlineMs) {
    try {
      const res = await fetch(
        `https://api.telegram.org/bot${tgToken}/getUpdates?offset=${offset}&timeout=15`
      );
      const data = await res.json();
      if (data.ok && Array.isArray(data.result)) {
        for (const update of data.result) {
          offset = update.update_id + 1;
          const msg = update.message;
          if (
            msg &&
            String(msg.chat?.id) === String(tgChatId) &&
            msg.date >= sinceDateUnix &&
            msg.text
          ) {
            return msg.text.trim();
          }
        }
      }
    } catch {
      // transient network retry
    }
    await new Promise((r) => setTimeout(r, 3000));
  }
  return null;
}

async function sendWebhook(text) {
  if (!webhookUrl) return;
  try {
    await fetch(webhookUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ content: text, text }),
    });
  } catch {
    // ignore webhook error
  }
}

function tryPostAndPollGitHubPR(text, wait, deadlineMs) {
  try {
    // Check if an open PR exists for current branch
    const prJson = execSync('gh pr view --json number,comments', {
      encoding: 'utf8',
      stdio: ['ignore', 'pipe', 'ignore'],
    });
    const pr = JSON.parse(prJson);
    const initialCount = Array.isArray(pr.comments) ? pr.comments.length : 0;

    execSync(`gh pr comment ${pr.number} --body ${JSON.stringify(text)}`, {
      stdio: 'ignore',
    });

    if (!wait) return null;

    return (async () => {
      const postedCount = initialCount + 1;
      while (Date.now() < deadlineMs) {
        await new Promise((r) => setTimeout(r, 8000));
        const latestRaw = execSync('gh pr view --json comments', {
          encoding: 'utf8',
          stdio: ['ignore', 'pipe', 'ignore'],
        });
        const latest = JSON.parse(latestRaw);
        if (Array.isArray(latest.comments) && latest.comments.length > postedCount) {
          const newest = latest.comments[latest.comments.length - 1];
          if (newest?.body) return newest.body.trim();
        }
      }
      return null;
    })();
  } catch {
    return null;
  }
}

async function main() {
  const startUnix = Math.floor(Date.now() / 1000);
  const deadlineMs = Date.now() + timeoutSec * 1000;

  // 1. Send notifications across configured channels
  await sendWebhook(message);
  const tgSent = await sendTelegram(
    waitReply ? `${message}\n\n💬 Reply to this message to instruct the agent (e.g., "proceed", "ship", or custom instructions).` : message
  );

  // 2. If --wait-reply is requested, wait for Telegram reply or GitHub PR comment reply
  if (waitReply) {
    if (tgToken && tgChatId && tgSent) {
      const reply = await pollTelegramReply(startUnix, deadlineMs);
      if (reply) {
        console.log(`REMOTE_REPLY: ${reply}`);
        process.exit(0);
      }
    }

    const ghReplyPromise = tryPostAndPollGitHubPR(
      `${message}\n\n💬 *Reply with a comment on this PR from GitHub Mobile/Web to resume the agent.*`,
      true,
      deadlineMs
    );
    if (ghReplyPromise) {
      const ghReply = await ghReplyPromise;
      if (ghReply) {
        console.log(`REMOTE_REPLY: ${ghReply}`);
        process.exit(0);
      }
    }
  }
}

main();
