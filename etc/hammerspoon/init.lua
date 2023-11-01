local log = hs.logger.new("init.lua", "debug")

hs.console.clearConsole()

-- hs.loadSpoon("Caffeine")
-- spoon.Caffeine:start()

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
  Discord     = { center(1/2, 1/12) },
  Ivory       = { left(1/4), center(1/3) },
  Mail        = { left(1/4), center(1/2, 1/12), center(1/3), right(1/4) },
  Messages    = { left(1/4), center(1/3) },
  Mimestream  = { center(1/2, 1/12), center(1/3) },
  NetNewsWire = { center(1/2, 1/12) },
  Slack       = { left(1/4), center(1/3), right(1/4) },
  Things      = { left(1/4), center(1/2, 1/12) },
}

local defaultConfig = { left(1/4), center(1/2), right(1/4) }

local heights = {
  left = 4/5,
  center = 19/20,
  right = 4/5,
}

spoon.Divvy:configure(function(application, screen)
  local config = applicationConfig[application:title()] or
    defaultConfig
  return hs.fnutils.map(config, function(rect)
    local x, y, w, h, position = table.unpack(rect)
    return { x, y, w, heights[position] or h }
  end)
end)

spoon.Divvy:bindHotkeys({
  activate={{"cmd", "alt", "ctrl"}, "space"}
})

showThingsQuickEntryPanel = hs.hotkey.new('⌃', 'space', function()
  hs.osascript.applescript('tell application "Things3" to show quick entry panel')
end)

showThingsQuickEntryPanel:enable()

hs.window.filter.new({'GoLand', 'IntelliJ IDEA', 'Xcode'})
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
