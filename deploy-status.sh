#!/bin/bash
# Deploy Network Status Page to GitHub

echo "🚀 Deploying serverstatus.tpl to GitHub..."

git add templates/snbdhost/serverstatus.tpl
git commit -m "feat: add network status page with UptimeRobot API integration

- Add serverstatus.tpl template with live uptime monitoring
- Fetch monitor data from UptimeRobot API v3
- Display real-time status banner (all up/down/paused)
- Show per-monitor cards with uptime %, response time, 60-day sparkline
- Add filter tabs (All/Up/Down/Paused)
- Auto-refresh every 60 seconds
- Light/dark mode support
- SNBD Host branding with custom SVG logo
- Accessible via /serverstatus.php in portal"

git push origin main

echo "✅ Deployed! Your network status page is now live at:"
echo "   https://portal.snbdhost.com/serverstatus.php"
