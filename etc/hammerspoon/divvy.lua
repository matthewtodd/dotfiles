local function workflow()
  local _visible = false
  local _selection = 3
  local _options = {
    {0, 0, 1/4, 3/4},
    {1/4, 0, 5/12, 11/12},
    {1/4, 0, 1/2, 11/12},
    {2/3, 0, 1/3, 3/4},
    {3/4, 0, 1/4, 3/4}
  }

  local _frame = nil
  local _data = function(data) end
  local _result = function(rect) end

  local function margin(rect, size)
    return hs.geometry({
      rect.x + size,
      rect.y + size,
      rect.w - 2 * size,
      rect.h - 2 * size,
    })
  end

  local function frame(unit)
    return margin(hs.geometry(unit):fromUnitRect(_frame), 6)
  end

  local function update()
    local options = {}

    for i,v in ipairs(_options) do
      options[i] = {
        frame = frame(_options[i]),
        selected = i == _selection,
      }
    end

    local data = {
      visible = _visible,
      options = options,
    }

    _data(data)
  end

  local function subscribe(data)
    _data = data
  end

  local function enter(frame, result)
    if _visible then return end
    _frame = frame
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
    _selection = 3
    update()
  end

  local function cancel()
    _visible = false
    _selection = 3
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

    enter = enter,
  }
end

local function view(ui)
  local _modal = hs.hotkey.modal:new()
  local _ui = ui

  local function bind(events)
    _modal:bind({}, 'return', events.commit)
    _modal:bind({}, 'escape', events.cancel)
    _modal:bind({}, 'left', events.previous)
    _modal:bind({}, 'right', events.next)
    _modal:bind({}, 'space', events.next)
  end

  local function update(data)
    if data.visible then
      _modal:enter()
      _ui.show(data.options)
    else
      _modal:exit()
      _ui.hide()
    end
  end

  return {
    bind = bind,
    update = update,
  }
end

local function ui()
  local _canvases = {}

  local function normalize(frame)
    return hs.geometry.new('0,0', frame.wh)
  end

  local function show(options)
    -- TODO remove stale _canvases? Execpt since we drive this loop from options, we'd never show them anyway!
    for _, option in ipairs(options) do
      local key = option.frame.string

      if not _canvases[key] then
        _canvases[key] = hs.canvas.new(option.frame):appendElements({
          type = 'rectangle',
          frame = normalize(option.frame).table,
          roundedRectRadii = { xRadius = 6, yRadius = 6 }
        })
      end

      local canvas = _canvases[key]

      if option.selected then
        canvas[1].fillColor = { alpha = 0.5, green = 1 }
        canvas:orderAbove()
      else
        canvas[1].fillColor = { alpha = 0.5, white = 0 }
      end

      canvas:show()
    end
  end

  local function hide()
    for k, canvas in pairs(_canvases) do
      canvas:hide()
    end
  end

  return {
    show = show,
    hide = hide
  }
end

local function divvy(workflow, view)
  workflow.data.subscribe(view.update)
  view.bind(workflow.events)

  local function enter(window)
    workflow.enter(window:screen():frame(), function(frame)
      window:setFrame(frame)
    end)
  end

  return {
    enter = enter
  }
end

return divvy(workflow(), view(ui()))
