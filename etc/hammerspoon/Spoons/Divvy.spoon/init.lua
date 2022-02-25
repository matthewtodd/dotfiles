local obj={}

obj.__index = obj

local function Mode(frame, options)
  local _options = hs.fnutils.copy(options)

  -- sort _options so j/k make sense for moving right/left
  table.sort(_options, function(a, b)
    -- sort by left edge if centers are close (quantizing fractional unit rects
    -- onto screen pixels may result in small differences)
    if a:distance(b) < 5 then
      return a.x < b.x
    else
      return a.center.x < b.center.x
    end
  end)

  -- A trick! Invoke the first round of the iterator to get the closest.
  -- We return the index and the option; if caller assigns to 1 variable, they just get the index.
  local _selection = hs.fnutils.sortByKeyValues(_options, function(a, b)
    return frame:distance(a) < frame:distance(b)
  end)()

  local function previous()
    if _selection > 1 then
      _selection = _selection - 1
    end
  end

  local function next()
    if _selection < #_options then
      _selection = _selection + 1
    end
  end

  local function current()
    return _options[_selection]
  end

  local function index()
    return _selection
  end

  return {
    previous = previous,
    next = next,
    current = current,
    index = index,
  }
end

local function Workflow()
  local _visible = false
  local _modes = nil
  local _mode = nil
  local _margin = 10
  local _data = function(data) end
  local _result = function(rect) end

  local function margin(rect)
    return hs.geometry({
      rect.x + _margin,
      rect.y + _margin,
      rect.w - 2 * _margin,
      rect.h - 2 * _margin,
    })
  end

  local function update()
    _data({
      visible = _visible,
      frame = margin(_mode.current()),
      label = '', -- not sure about this yet; not liking the numbers -- _mode.index(),
    })
  end

  local function subscribe(data)
    _data = data
  end

  local function start(modes, result)
    if _visible then return end
    _modes = hs.fnutils.cycle(modes)
    _mode = _modes()
    _result = result
    _visible = true
    update()
  end

  local function previous()
    _mode.previous()
    update()
  end

  local function next()
    _mode.next()
    update()
  end

  local function mode()
    _mode = _modes()
    update()
  end

  local function commit()
    _result(margin(_mode.current()))
    _visible = false
    update()
  end

  local function cancel()
    _visible = false
    update()
  end

  return {
    data = {
      subscribe = subscribe
    },

    events = {
      previous = previous,
      next = next,
      mode = mode,
      commit = commit,
      cancel = cancel,
    },

    start = start,
  }
end

local function Coordinator(view)
  local _modal = hs.hotkey.modal:new()
  local _view = view

  local function bind(events)
    _modal:bind({}, 'return', events.commit)
    _modal:bind({}, 'escape', events.cancel)
    _modal:bind({}, 'space', events.next)
    _modal:bind({}, 'f', events.mode)
    _modal:bind({}, 'j', events.next)
    _modal:bind({}, 'k', events.previous)
  end

  local function update(data)
    if data.visible then
      _modal:enter()
      _view.show(data.frame, data.label)
    else
      _modal:exit()
      _view.hide()
    end
  end

  return {
    bind = bind,
    update = update,
  }
end

local function View()
  local _canvas = hs.canvas.new({ x=0, y=0, w=0, h=0 }):appendElements({
    type = 'rectangle',
    frame = { x='0%', y='0%', w='100%', h='100%' },
    roundedRectRadii = { xRadius = 6, yRadius = 6 },
    fillColor = { alpha = 0.5, red = 0.1647058824, green = 0.631372549, blue = 0.5960784314 },
  }, {
    type = 'text',
    frame = { x='0%', y='35%', w='100%', h='35%' }, -- HACK not exactly vertically centered, but ok
    text = '',
    textAlignment = 'center',
    textColor = { alpha = 0.75, white = 1.0 },
    textSize = 128,
  })

  local function show(frame, label)
    _canvas:frame(frame.table)
    _canvas:elementAttribute(2, 'text', label)
    _canvas:show()
  end

  local function hide()
    _canvas:hide()
  end

  return {
    show = show,
    hide = hide
  }
end

function obj:init()
  self.workflow = Workflow()
  self.coordinator = Coordinator(View())
  self.workflow.data.subscribe(self.coordinator.update)
  self.coordinator.bind(self.workflow.events)
end

function obj:configure(optionsForScreen)
  self.optionsForScreen = optionsForScreen
end

function obj:bindHotkeys(mappings)
  local mods = mappings.activate[1]
  local key = mappings.activate[2]
  hs.hotkey.bind(mods, key, function()
    obj:activate()
  end)
end

function obj:activate()
  local window = hs.window.focusedWindow()

  local configuredMode = Mode(window:frame(), hs.fnutils.mapCat(hs.screen.allScreens(), function(screen)
    return hs.fnutils.map(self.optionsForScreen(window:application(), screen), function(unit)
      return screen:fromUnitRect(unit)
    end)
  end))

  local fullscreenMode = Mode(window:frame(), hs.fnutils.map(hs.screen.allScreens(), function(screen)
    return screen:fromUnitRect({0, 0, 1, 1 })
  end))

  self.workflow.start({ configuredMode, fullscreenMode }, function(frame)
    window:setFrame(frame)
  end)
end

return obj
