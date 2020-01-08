local divvy = require "divvy"

hs.hotkey.bind('⌃⌥⌘', 'space', function()
  local window = hs.window.focusedWindow()
  divvy.start(window:screen():frame(), function(frame)
    window:setFrame(frame)
  end)
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

function caffeineIcon(state)
  return state and "caffeine/Active.png" or "caffeine/Inactive.png"
end

caffeine = hs.menubar.new()
caffeine:setIcon(caffeineIcon(hs.caffeinate.get("displayIdle")))
caffeine:setClickCallback(function()
  caffeine:setIcon(caffeineIcon(hs.caffeinate.toggle("displayIdle")))
end)
