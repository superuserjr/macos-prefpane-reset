# macos-prefpane-reset

When macOS Sequoia 15.x suddenly shows **only _General_ and _Spotlight_** in  
**System Settings**, the culprit is almost always a corrupted *per-user* cache or
preference file—not an MDM profile or a system-wide problem.  
This repo ships a tiny shell script (one carefully chained command) that:

1. Backs up the affected plist,
2. Deletes the sidebar-builder cache, and
3. Forces macOS to rebuild the pane list on next login.

---

## Why does the bug appear?

* A stale **`~/Library/Preferences/com.apple.systempreferences.plist`** or  
  **`~/Library/Caches/com.apple.preferencepanes.usercache`** crashes the sidebar generator.
* Safe Mode and OS reinstalls leave those files untouched, so the corruption
  survives until manually removed.

---

## Quick-fix script


### curl & run
```bash
curl -sL https://raw.githubusercontent.com/superuserjr/macos-prefpane-reset/main/reset.sh | bash
```
### …or copy/paste the one-liner directly:
```bash
killall -KILL "System Settings" 2>/dev/null && \
mv ~/Library/Preferences/com.apple.systempreferences.plist ~/Desktop/ && \
rm -rf ~/Library/Caches/com.apple.preferencepanes.usercache && \
killall cfprefsd
```

Then **reboot**.  
System Settings recreates both files automatically; the full sidebar should
re-appear on first launch.

## What the script does

| Step | Action | Reason |
|------|--------|--------|
| 1 | `killall -KILL "System Settings"` | Ensures prefs aren't locked in memory |
| 2 | `mv …com.apple.systempreferences.plist ~/Desktop/` | Backs up the plist (easy rollback) |
| 3 | `rm -rf …/Caches/com.apple.preferencepanes.usercache` | Deletes the corrupt sidebar cache |
| 4 | `killall cfprefsd` | Flushes the preference daemon so macOS forgets cached data |

**No system-wide files are touched**—only items inside your `~/Library/`.

## Revert (if you really need to)

```bash
mv ~/Desktop/com.apple.systempreferences.plist ~/Library/Preferences/
killall cfprefsd && killall -KILL "System Settings"
``` 