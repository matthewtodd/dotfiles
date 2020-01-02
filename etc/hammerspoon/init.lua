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

function thread(...)
  local stages = table.pack(...)

  return function(seed)
    local result = seed

    for _,stage in ipairs(stages) do
      result = stage[1](result, table.unpack(stage, 2))
    end

    return result
  end
end

hs.window.animationDuration = 0

function move(position)
  return function()
    local window = hs.window.focusedWindow()
    local screen = window:screen()
    window:setFrame(position(screen:frame()))
  end
end

function position(frame, unit)
  return hs.geometry.new(unit):fromUnitRect(frame)
end

function margin(frame, size)
  return hs.geometry.new{
    x = frame.x + size,
    y = frame.y + size,
    w = frame.w - size * 2,
    h = frame.h - size * 2
  }
end

-- TODO modal hotkeys?
hs.hotkey.bind('⌃⌥⌘', 'L', move(thread({position, {0/3, 0, 1/3, 5/6}}, {margin, 6})))
hs.hotkey.bind('⌃⌥⌘', 'C', move(thread({position, {1/3, 0, 1/3, 11/12}}, {margin, 6})))
hs.hotkey.bind('⌃⌥⌘', 'M', move(thread({position, {1/4, 0, 1/2, 11/12}}, {margin, 6})))
hs.hotkey.bind('⌃⌥⌘', 'R', move(thread({position, {2/3, 0, 1/3, 5/6}}, {margin, 6})))
hs.hotkey.bind('⌃⌥⇧⌘', 'L', move(thread({position, {0/4, 0, 1/4, 3/4}}, {margin, 6})))
hs.hotkey.bind('⌃⌥⇧⌘', 'R', move(thread({position, {3/4, 0, 1/4, 3/4}}, {margin, 6})))
