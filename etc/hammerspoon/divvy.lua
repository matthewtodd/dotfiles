local function thread(...)
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

local function move(position)
  local window = hs.window.focusedWindow()
  local screen = hs.screen.primaryScreen()
  window:setFrame(position(screen:frame()))
end

local function position(frame, unit)
  return hs.geometry.new(unit):fromUnitRect(frame)
end

local function margin(frame, size)
  return hs.geometry{
    x = frame.x + size,
    y = frame.y + size,
    w = frame.w - size * 2,
    h = frame.h - size * 2
  }
end

local divvy = hs.hotkey.modal:new()

local operations = {
  L = {{position, {0, 0, 1/4, 3/4}}, {margin, 6}},
  C = {{position, {1/4, 0, 5/12, 11/12}}, {margin, 6}},
  M = {{position, {1/4, 0, 1/2, 11/12}}, {margin, 6}},
  S = {{position, {2/3, 0, 1/3, 3/4}}, {margin, 6}},
  R = {{position, {3/4, 0, 1/4, 3/4}}, {margin, 6}}
}

local makeHud = function(frame, operations)
  local _visible = false
  local _previews = {}
  local _choice = nil

  local normalize = function(frame)
    return hs.geometry{
      x = 0,
      y = 0,
      w = frame.w,
      h = frame.h
    }
  end

  for keycode, positioners in pairs(operations) do
    local previewFrame = thread(table.unpack(positioners))(frame)

    _previews[keycode] = hs.canvas.new(previewFrame):appendElements({
      id = 'rectangle',
      type = 'rectangle',
      frame = normalize(previewFrame).table,
      fillColor = { alpha = 0.5, white = 0 },
      roundedRectRadii = { xRadius = 6, yRadius = 6 }
    }, {
      id = 'text',
      type = 'text',
      frame = margin(normalize(previewFrame), 6).table,
      text = keycode,
      textSize = 18.0,
      textColor = { alpha = 0.75, white = 1 }
    })
  end

  local show = function()
    if _visible then return end
    _visible = true
    _choice = nil
    for keycode, canvas in pairs(_previews) do
      canvas:show()
    end
  end

  local hide = function()
    _visible = false
    if _choice then _previews[_choice]['rectangle'].fillColor.green = 0 end
    for keycode, canvas in pairs(_previews) do
      canvas:hide()
    end
  end

  local choose = function(_, keycode)
    if _choice then _previews[_choice]['rectangle'].fillColor.green = 0 end
    _choice = keycode
    _previews[_choice]:orderAbove()
    _previews[_choice]['rectangle'].fillColor.green = 1
  end

  local choice = function()
    return _choice
  end

  return {
    show = show,
    hide = hide,
    choose = choose,
    choice = choice
  }
end

local hud = makeHud(hs.screen.primaryScreen():frame(), operations)

function divvy:entered()
  hud:show()
end

function divvy:exited()
  hud:hide()
end

divvy:bind({}, 'return', function()
  if hud:choice() then
    move(thread(table.unpack(operations[hud:choice()])))
  end
  divvy:exit()
end)

divvy:bind({}, 'escape', function()
  divvy:exit()
end)

for keycode, positioners in pairs(operations) do
  divvy:bind({}, keycode, function()
    hud:choose(keycode)
  end)
end

return divvy
