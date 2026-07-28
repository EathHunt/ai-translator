#!/bin/bash
# AI 翻译 - 后台服务安装脚本
# 运行方式: bash install-service.sh
# 功  能: 安装开机自启服务 + 启动一次

SERVE_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. Create launchd plist
mkdir -p "$HOME/Library/LaunchAgents"

cat > "$HOME/Library/LaunchAgents/com.translator.server.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.translator.server</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/python3</string>
        <string>-m</string>
        <string>http.server</string>
        <string>8822</string>
        <string>--directory</string>
        <string>${SERVE_DIR}</string>
    </array>
    <key>WorkingDirectory</key>
    <string>${SERVE_DIR}</string>
    <key>KeepAlive</key>
    <true/>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/tmp/translator-server.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/translator-server.log</string>
</dict>
</plist>
PLIST

# 2. Load the service
launchctl load "$HOME/Library/LaunchAgents/com.translator.server.plist"

# 3. Get local IP
IP=$(ifconfig | rg 'inet ' | rg -v '127.0.0.1' | awk '{print $2}' | head -1)

echo ""
echo "✅ 翻译服务已安装！"
echo ""
echo "📱 在 iPhone 上用 Safari 打开："
echo "   http://${IP}:8822"
echo ""
echo "💡 第一次打开后，点分享按钮 → 「添加到主屏幕」"
echo "   以后就能像 App 一样从桌面打开了"
echo ""
echo "🔄 服务器已设置为开机自启，不需要再管它了"
