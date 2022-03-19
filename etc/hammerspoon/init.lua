hs.console.clearConsole()

hs.loadSpoon("Divvy")

-- x, y, w, h, position
local function left(width)
  return { 0, 0, width, 1, "left" }
end

local function center(width, tuck)
  return { (1 - width) / 2, 0, width - (tuck or 0), 1, "center" }
end

local function right(width)
  return { 1 - width, 0, width, 1, "right" }
end

local applicationConfig = {
  GoLand      = { primaryLarge = { center(1/2), center(3/4) } },
  Hammerspoon = { primaryLarge = { left(1/4), right(1/4) },
                  primarySmall = { left(5/12), right(5/12) } },
  Mail        = { primaryLarge = { center(1/2, 1/12), center(1/3) },
                  primarySmall = { center(3/4, 1/8), center(1/2) } },
  Messages    = { primaryLarge = { left(1/4) },
                  primarySmall = { left(5/12) } },
  Mimestream  = { primaryLarge = { center(1/2, 1/12), center(1/3) },
                  primarySmall = { center(3/4, 1/8), center(1/2) } },
  NetNewsWire = { primaryLarge = { center(1/2, 1/12) },
                  primarySmall = { center(3/4, 1/8) } },
  Slack       = { primaryLarge = { center(1/2, 1/12) },
                  primarySmall = { left(5/12), center(1/2), right(5/12) } },
  Terminal    = { primaryLarge = { left(1/4), center(1/2), right(1/4) },
                  primarySmall = { left(5/12), center(3/4), right(5/12) },
                  secondary    = { left(1/2), right(1/2) } },
  Things      = { primaryLarge = { left(1/4), center(1/2, 1/12) },
                  primarySmall = { left(5/12), center(3/4, 1/8) } },
  Tot         = { primaryLarge = { left(1/4), right(1/4) },
                  primarySmall = { left(5/12), right(5/12) },
                  secondary    = { right(1/2) } },
  Warp        = { primaryLarge = { left(1/4), center(1/2), right(1/4) },
                  primarySmall = { left(5/12), center(3/4), right(5/12) },
                  secondary    = { left(1/2), right(1/2) } },
}

local defaultConfig = {
  primaryLarge = { center(1/2) },
  primarySmall = { center(3/4) },
  secondary    = { center(1) }
}

local heights = {
  primaryLarge = {
    left = 4/5,
    center = 19/20,
    right = 4/5,
  },
  primarySmall = {
    left = 19/20,
    right = 19/20,
  }
}

-- Make applicationConfig and heights return {} as their default value.
-- This hack makes for much smaller code below.
-- https://www.lua.org/pil/13.4.3.html
setmetatable(applicationConfig, {__index = function () return {} end})
setmetatable(heights, {__index = function () return {} end})

spoon.Divvy:configure(function(application, screen)
  local key = screen == hs.screen.primaryScreen() and
    (screen:frame().w > 1792 and "primaryLarge" or "primarySmall") or "secondary"
  local config = applicationConfig[application:title()][key] or
    defaultConfig[key]
  return hs.fnutils.map(config, function(rect)
    local x, y, w, h, position = table.unpack(rect)
    return { x, y, w, heights[key][position] or h }
  end)
end)

spoon.Divvy:bindHotkeys({
  activate={{"cmd", "alt", "ctrl"}, "space"}
})

showThingsQuickEntryPanel = hs.hotkey.new('⌃', 'space', function()
  hs.osascript.applescript('tell application "Things3" to show quick entry panel')
end)

showThingsQuickEntryPanel:enable()

hs.window.filter.new({'GoLand', 'IntelliJ IDEA'})
  :subscribe(hs.window.filter.windowFocused, function()
    showThingsQuickEntryPanel:disable()
  end)
  :subscribe(hs.window.filter.windowUnfocused, function()
    showThingsQuickEntryPanel:enable()
  end)
  .setLogLevel('error')

hs.loadSpoon("WaitingFor")
spoon.WaitingFor:bindHotkeys({
  insertText = {"⌃⌥⌘", "w"}
})

local function terminalMatchSystemDarkMode()
  local status, output = hs.osascript.applescript([[
    tell application "System Events"
      if dark mode of appearance preferences then
        set theme to "Solarized Dark"
      else
        set theme to "Solarized Light"
      end if
    end tell

    tell application "Terminal"
      set default settings to settings set theme
      set current settings of tabs of windows to settings set theme
    end tell
  ]])
end

local function onDistributedNotification(which)
  if which == "AppleInterfaceThemeChangedNotification" then
    terminalMatchSystemDarkMode()
  end
end

notifications = hs.distributednotifications.new(onDistributedNotification, "AppleInterfaceThemeChangedNotification")
notifications:start()
