local obj={}

obj.__index = obj

function insertText(prefix)
  local when = os.date("%I:%M%p, %a, %m/%d")
  when = string.gsub(when, "^0", "")
  when = string.gsub(when, "AM", "am")
  when = string.gsub(when, "PM", "pm")
  local message = string.format("(%s %s.)", prefix, when)
  hs.eventtap.keyStrokes(message)
end

function waitingFor(modal, prefix)
  return function()
    insertText(prefix)
    modal:exit()
  end
end

function obj:bindHotkeys(mapping)
  local mods = mapping.insertText[1]
  local key = mapping.insertText[2]
  obj.modal = hs.hotkey.modal.new(mods, key)
  obj.modal:bind("", "escape", function() obj.modal:exit() end)
  obj.modal:bind("", "o", waitingFor(obj.modal, "Ordered"))
  obj.modal:bind("", "s", waitingFor(obj.modal, "Spoke"))
  obj.modal:bind("", "t", waitingFor(obj.modal, "Texted"))
  obj.modal:bind("", "v", waitingFor(obj.modal, "Left voicemail"))
  obj.modal:bind("", "w", waitingFor(obj.modal, "Wrote"))
end

return obj

