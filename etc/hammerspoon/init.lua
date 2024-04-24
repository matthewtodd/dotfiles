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
local CENTER_THIRD = center(1/3)
local SIDEBAR = center(1/2, 1/12)
local RIGHT = { 3/4, 0, 1/4, 1, "right" }

local applicationConfig = {
  Discord     = { SIDEBAR },
  Ivory       = { LEFT, CENTER_THIRD },
  Mail        = { LEFT, SIDEBAR, CENTER_THIRD, RIGHT },
  Messages    = { LEFT, CENTER_THIRD },
  Mimestream  = { SIDEBAR, CENTER_THIRD },
  NetNewsWire = { SIDEBAR },
  RubyMine    = { CENTER, center(3/4) },
  Slack       = { SIDEBAR, RIGHT },
  Things      = { LEFT, SIDEBAR },
}

applicationConfig["zoom.us"] = {
  { 0, 0, 3/4, 1 },
  CENTER,
}

local defaultConfig = { LEFT, CENTER, RIGHT }

local heights = {
  left = 4/5,
  center = 19/20,
  right = 4/5,
}

spoon.Divvy:configure(
  -- default mode: per-application presets
  function(application, screen)
    local config = applicationConfig[application:title()] or
      defaultConfig
    return hs.fnutils.map(config, function(rect)
      local x, y, w, h, position = table.unpack(rect)
      return { x, y, w, heights[position] or h }
    end)
  end,

  -- fullscreen mode
  function(application, screen)
    return {
      { 0, 0, 1/2, 1 },
      { 0, 0, 1, 1 },
      { 1/2, 0, 1/2, 1 }
    }
  end
)

spoon.Divvy:bindHotkeys({
  activate={{"cmd", "alt", "ctrl", "shift"}, "space"}
})

showThingsQuickEntryPanel = hs.hotkey.new('⌃', 'space', function()
  hs.osascript.applescript('tell application "Things3" to show quick entry panel')
end)

showThingsQuickEntryPanel:enable()

hs.window.filter.new({'GoLand', 'IntelliJ IDEA', 'RubyMine', 'Xcode'})
  :subscribe(hs.window.filter.windowFocused, function()
    showThingsQuickEntryPanel:disable()
  end)
  :subscribe(hs.window.filter.windowUnfocused, function()
    showThingsQuickEntryPanel:enable()
  end)
  .setLogLevel('error')

hs.loadSpoon("WaitingFor")
spoon.WaitingFor:bindHotkeys({
  insertText = {{"cmd", "alt", "ctrl", "shift"}, "w"}
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
        -- Somehow there's an additional ghost window at the end of the list,
        -- so `set current settings of tabs of windows` fails.
        -- This loop still fails on its last iteration, but that's good enough for now.
        repeat with theWindow in windows
          set current settings of tabs of theWindow to settings set theme
        end repeat
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
