local function Workflow()
  local _visible = false
  local _selection = 1
  local _options = nil
  local _frame = nil
  local _data = function(data) end
  local _result = function(rect) end

  local function margin(rect, size)
    return hs.geometry({
      rect.x + size,
      rect.y + size,
      rect.w - 2 * size,
      rect.h - 3 * size,
    })
  end

  local function frame(unit)
    return margin(hs.geometry(unit):fromUnitRect(_frame), 6)
  end

  local function update()
    _data({
      visible = _visible,
      frame = frame(_options[_selection]),
    })
  end

  local function subscribe(data)
    _data = data
  end

  local function start(frame, options, result)
    if _visible then return end
    _frame = frame
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
    _result(frame(_options[_selection]))
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
    fillColor = { alpha = 0.25, green = 0.8 },
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

local workflow = Workflow()
local coordinator = Coordinator(View())
workflow.data.subscribe(coordinator.update)
coordinator.bind(workflow.events)
return workflow
