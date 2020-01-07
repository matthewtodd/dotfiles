local divvy = require "divvy"

hs.hotkey.bind('⌃⌥⌘', 'space', function()
  divvy.enter(hs.window.focusedWindow())
end)

showThingsQuickEntryPanel = hs.hotkey.new({'ctrl'}, 'Space', function()
  hs.osascript.applescript('tell application "Things3" to show quick entry panel')
end)

-- TODO disable when entering IntelliJ, as in:
-- https://github.com/Hammerspoon/hammerspoon/issues/664#issuecomment-202829038
showThingsQuickEntryPanel:enable()

-- TODO can't just defaults write com.apple.keyboard.fnState to replace fluor
-- https://github.com/Pyroh/Fluor/blob/master/Fluor/utils.m
-- https://news.ycombinator.com/item?id=13372702
-- Maybe I could make and distribute a binary here using Fluor's utils.m?
-- Or there's the awkward AppleScript route, something like
-- https://github.com/jakubroztocil/macos-fn-toggle/blob/master/fn-toggle.app/Contents/document.wflow
-- tell application "System Preferences"
--   reveal anchor "keyboardTab" of pane "com.apple.preference.keyboard"
-- end tell
-- tell application "System Events" to tell process "System Preferences"
--   click checkbox 1 of tab group 1 of window 1
-- end tell
-- quit application "System Preferences"

function caffeineTitle(state)
  return state and "😎" or "🙂"
end

caffeine = hs.menubar.new()
caffeine:setTitle(caffeineTitle(hs.caffeinate.get("displayIdle")))
caffeine:setClickCallback(function()
  caffeine:setTitle(caffeineTitle(hs.caffeinate.toggle("displayIdle")))
end)
