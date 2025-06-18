#!/bin/bash

# Reset macOS System Settings when only General & Spotlight appear
killall -KILL "System Settings" 2>/dev/null && \
mv ~/Library/Preferences/com.apple.systempreferences.plist ~/Desktop/ && \
rm -rf ~/Library/Caches/com.apple.preferencepanes.usercache && \
killall cfprefsd

echo "✅ System Settings cache cleared. Please reboot your Mac."
echo "📁 Your old preferences were backed up to ~/Desktop/com.apple.systempreferences.plist" 