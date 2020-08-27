local obj={}

obj.__index = obj

function insertText()
  local message = os.date("(Wrote %I:%M%p, %a, %m/%d.)")
  message = string.gsub(message, " 0", " ")
  message = string.gsub(message, "AM", "am")
  message = string.gsub(message, "PM", "pm")
  hs.eventtap.keyStrokes(message)
end

function obj:bindHotkeys(mapping)
  local mods = mapping.insertText[1]
  local key = mapping.insertText[2]
  hs.hotkey.bind(mods, key, insertText)
end

return obj

