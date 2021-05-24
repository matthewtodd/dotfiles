local obj={}

obj.__index = obj

local function Workflow()
  local _visible = false
  local _selection = 1
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
      frame = margin(_options[_selection]),
    })
  end

  local function subscribe(data)
    _data = data
  end

  local function start(options, result)
    if _visible then return end
    _options = options
    _result = result
    _visible = true
    update()
  end

  local function previous()
    _selection = _selection - 1
    if _selection == 0 then _selection = #_options end
    update()
  end

  local function next()
    _selection = _selection + 1
    if _selection > #_options then _selection = 1 end
    update()
  end

  local function commit()
    _result(margin(_options[_selection]))
    _visible = false
    _selection = 1
    update()
  end

  local function cancel()
    _visible = false
    _selection = 1
    update()
  end

  return {
    data = {
      subscribe = subscribe
    },

    events = {
      previous = previous,
      next = next,
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
    _modal:bind({}, 'j', events.next)
    _modal:bind({}, 'k', events.previous)
  end

  local function update(data)
    if data.visible then
      _modal:enter()
      _view.show(data.frame)
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
  })

  local function show(frame)
    _canvas:frame(frame.table)
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

function obj:configure(optionsForFrame)
  self.optionsForFrame = optionsForFrame
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
  local screen = window:screen():frame()
  local options = hs.fnutils.imap(self.optionsForFrame(screen), function(unit)
    return hs.geometry(unit):fromUnitRect(screen)
  end)

  self.workflow.start(options, function(frame)
    window:setFrame(frame)
  end)
end

return obj
