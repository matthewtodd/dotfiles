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
  local window = hs.window.focusedWindow()
  local screen = hs.screen.primaryScreen()
  window:setFrame(position(screen:frame()))
end

function position(frame, unit)
  return hs.geometry.new(unit):fromUnitRect(frame)
end

function margin(frame, size)
  return hs.geometry{
    x = frame.x + size,
    y = frame.y + size,
    w = frame.w - size * 2,
    h = frame.h - size * 2
  }
end

divvy = hs.hotkey.modal:new()

hs.hotkey.bind('⌃⌥⌘', 'space', function() divvy:enter() end)

operations = {
  L = {{position, {0, 0, 1/4, 3/4}}, {margin, 6}},
  C = {{position, {1/4, 0, 5/12, 11/12}}, {margin, 6}},
  M = {{position, {1/4, 0, 1/2, 11/12}}, {margin, 6}},
  S = {{position, {2/3, 0, 1/3, 3/4}}, {margin, 6}},
  R = {{position, {3/4, 0, 1/4, 3/4}}, {margin, 6}}
}

ui = hs.canvas.new(hs.screen.primaryScreen():frame())

uiFrame = hs.geometry{
  x = 0,
  y = 0,
  w = ui:frame().w,
  h = ui:frame().h
}

for keycode, positioners in pairs(operations) do
  frame = thread(table.unpack(positioners))(uiFrame).table

  ui:appendElements({
    id = keycode,
    type = 'rectangle',
    frame = frame,
    fillColor = { alpha = 0.5, white = 0 },
    roundedRectRadii = { xRadius = 6, yRadius = 6 }
  }, {
    type = 'text',
    frame = margin(frame, 6).table,
    text = keycode,
    textSize = 18.0,
    textColor = { alpha = 0.75, white = 1 }
  })
end

local divvy_entered = false

function divvy:entered()
  if divvy_entered then return end
  divvy_entered = true
  ui:show()
end

function divvy:exited()
  divvy_entered = false
  ui:hide()
end

local divvy_selection = nil

divvy:bind({}, 'return', function()
  if divvy_selection then
    move(thread(table.unpack(operations[divvy_selection])))
    ui[divvy_selection].fillColor.green = 0
    divvy_selection = nil
  end
  divvy:exit()
end)

divvy:bind({}, 'escape', function()
  if divvy_selection then
    ui[divvy_selection].fillColor.green = 0
    divvy_selection = nil
  end
  divvy:exit()
end)

for keycode, positioners in pairs(operations) do
  divvy:bind({}, keycode, function()
    if divvy_selection then
      ui[divvy_selection].fillColor.green = 0
    end
    divvy_selection = keycode
    ui[divvy_selection].fillColor.green = 1
  end)
end
