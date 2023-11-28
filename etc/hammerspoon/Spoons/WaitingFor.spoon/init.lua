local obj={}

obj.__index = obj

function insertText(prefix)
  local when = os.date("%I:%M%p, %a, %m/%d")
  when = string.gsub(when, "^0", "")
  when = string.gsub(when, "AM", "am")
  when = string.gsub(when, "PM", "pm")
  local message = string.format("(%s %s.)", prefix or "Wrote", when)
  hs.eventtap.keyStrokes(message)
end

function obj:bindHotkeys(mapping)
  local mods = mapping.insertText[1]
  local key = mapping.insertText[2]
  hs.hotkey.bind(mods, key, insertText)
end

return obj

