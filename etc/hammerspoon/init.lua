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

hs.window.animationDuration = 0

function move(x, w, h)
  return function()
    local window = hs.window.focusedWindow()
    local screen = window:screen():frame()
    local frame = window:frame()
    frame.x = x(screen, w) + 6
    frame.y = screen.y + 6
    frame.w = (screen.w * w) - 12
    frame.h = (screen.h * h) - 12
    window:setFrame(frame)
  end
end

function left(screen, w)
  return screen.x
end

function center(screen, w)
  return screen.x + screen.w * (1 - w) / 2
end

function right(screen, w)
  return screen.x + screen.w * (1 - w)
end

-- TODO modal hotkeys?
hs.hotkey.bind('⌃⌥⌘', 'L', move(left, 1/3, 5/6))
hs.hotkey.bind('⌃⌥⌘', 'C', move(center, 1/3, 11/12))
hs.hotkey.bind('⌃⌥⌘', 'M', move(center, 1/2, 11/12))
hs.hotkey.bind('⌃⌥⌘', 'R', move(right, 1/3, 5/6))
hs.hotkey.bind('⌃⌥⇧⌘', 'L', move(left, 1/4, 3/4))
hs.hotkey.bind('⌃⌥⇧⌘', 'M', move(center, 5/6, 1))
hs.hotkey.bind('⌃⌥⇧⌘', 'R', move(right, 1/4, 3/4))
