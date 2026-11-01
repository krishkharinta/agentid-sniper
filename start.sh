cat > start.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

mkdir -p data/baw-profile

node <<'NODE'
const fs = require('fs');

if (!process.env.WALLET_NAME || !process.env.WALLET_ADDRESS) {
  throw new Error("Set WALLET_NAME and WALLET_ADDRESS in Render environment variables");
}

const config = {
  wallets: [{
    name: process.env.WALLET_NAME,
    address: process.env.WALLET_ADDRESS
  }],
  telegram: {
    botToken: "",
    chatId: "",
    groupChatId: ""
  },
  timeZone: "Asia/Kolkata",
  paid: {
    maxUsd: 1,
    keepBnb: 0.02
  },
  rules: {
    backX: 2,
    steps: [[10, 30], [20, 50]],
    crash: 0.4
  },
  tokens: [],
  watchVault: "",
  forceMint: [],
  rpcs: []
};

fs.writeFileSync("config.json", JSON.stringify(config, null, 2), {
  mode: 0o600
});
NODE

# Start in buy-paused mode for initial testing
touch data/pause_buy.txt

exec node watch.mjs
EOF

git add start.sh
git commit -m "Add Render worker startup script"
git push
