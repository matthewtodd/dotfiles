local obj={}

obj.__index = obj

function icon(state)
  return state and "Active.png" or "Inactive.png"
end

function obj:start()
  local menu = hs.menubar.new()
  menu:setIcon(self.spoonPath .. "/" .. icon(hs.caffeinate.get("displayIdle")))
  menu:setClickCallback(function()
    menu:setIcon(self.spoonPath .. "/" .. icon(hs.caffeinate.toggle("displayIdle")))
  end)
  return self
end

return obj
