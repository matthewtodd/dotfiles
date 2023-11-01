local log = hs.logger.new("init.lua", "debug")

hs.console.clearConsole()

-- hs.loadSpoon("Caffeine")
-- spoon.Caffeine:start()

hs.loadSpoon("Divvy")

-- x, y, w, h, position
local function center(width, tuck)
  return { (1 - width) / 2, 0, width - (tuck or 0), 1, "center" }
end

local LEFT = { 0, 0, 1/4, 1, "left" }
local CENTER = center(1/2)
local SIDEBAR = center(1/2, 1/12)
local SKINNY = center(1/3)
local RIGHT = { 3/4, 0, 1/4, 1, "right" }

local applicationConfig = {
  Discord     = { SIDEBAR },
  Ivory       = { LEFT, SKINNY },
  Mail        = { LEFT, SIDEBAR, SKINNY, RIGHT },
  Messages    = { LEFT, SKINNY },
  Mimestream  = { SIDEBAR, SKINNY },
  NetNewsWire = { SIDEBAR },
  Slack       = { SIDEBAR },
  Things      = { LEFT, SIDEBAR },
}

local defaultConfig = { LEFT, CENTER, RIGHT }

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

-- Not sure how I feel about this key choice, but I'm curious to play with
-- these window hints as a maybe-faster way to switch applications? First guess
-- is that using some part of the application title could make sense from a
-- mnemonic perspective, at which point it's really not any better than what
-- I'm doing with Raycast. (Especially since I'm not typically using multiple
-- windows of the same app.) But let's see!
hs.hotkey.bind({"cmd", "alt", "ctrl"}, "j", hs.hints.windowHints)

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
