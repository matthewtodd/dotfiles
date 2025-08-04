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

local LEFT = left(1 / 4)
local CENTER = center(1 / 2)
local CENTER_SMALL = center(1 / 3)
local CENTER_LARGE = center(3 / 4)
local SIDEBAR = center(1 / 2, 1 / 12)
local RIGHT = right(1 / 4)

local applicationConfig = {
  ["Built-in Retina Display"] = {
    __default__ = { left(1 / 2), center(3 / 4), right(1 / 2) },
  },

  ["Sidecar Display (AirPlay)"] = {
    __default__ = { { 0, 0, 1, 1 } },
  },


  __default__ = {
    Discord     = { SIDEBAR },
    Ivory       = { LEFT, CENTER_SMALL },
    Mail        = { LEFT, SIDEBAR, CENTER_SMALL, RIGHT },
    Messages    = { LEFT, CENTER_SMALL },
    Mimestream  = { SIDEBAR, CENTER_SMALL },
    NetNewsWire = { SIDEBAR },
    Signal      = { LEFT, CENTER_SMALL },
    Slack       = { LEFT, SIDEBAR, RIGHT },
    Things      = { LEFT, SIDEBAR },

    __default__ = { LEFT, CENTER, RIGHT },
  },
}

local withDefault = { __index = function(t) return t.__default__ end }

setmetatable(applicationConfig, withDefault)
setmetatable(applicationConfig.__default__, withDefault)
setmetatable(applicationConfig["Built-in Retina Display"], withDefault)
setmetatable(applicationConfig["Sidecar Display (AirPlay)"], withDefault)

local heights = {
  ["Built-in Retina Display"] = {
    left = 19 / 20,
    center = 1,
    right = 19 / 20,
  },

  __default__ = {
    left = 4 / 5,
    center = 19 / 20,
    right = 4 / 5,
  }
}

setmetatable(heights, withDefault)
setmetatable(applicationConfig.__default__, withDefault)
setmetatable(heights["Built-in Retina Display"], withDefault)

spoon.Divvy:configure(
-- default mode: per-application presets
  function(application, screen)
    local config = applicationConfig[screen:name()][application:title()]

    return hs.fnutils.map(config, function(rect)
      local x, y, w, h, position = table.unpack(rect)
      return { x, y, w, heights[screen:name()][position] or h }
    end)
  end,

  -- fullscreen mode
  function(application, screen)
    return {
      { 0,     0, 1 / 2, 1 },
      { 0,     0, 1,     1 },
      { 1 / 2, 0, 1 / 2, 1 }
    }
  end
)

spoon.Divvy:bindHotkeys({
  activate = { { "cmd", "alt", "ctrl" }, "space" }
})

showThingsQuickEntryPanel = hs.hotkey.new('⌃', 'space', function()
  hs.osascript.applescript('tell application "Things3" to show quick entry panel')
end)

showThingsQuickEntryPanel:enable()

hs.window.filter.new({ 'GoLand', 'IntelliJ IDEA', 'RubyMine', 'Xcode' })
    :subscribe(hs.window.filter.windowFocused, function()
      showThingsQuickEntryPanel:disable()
    end)
    :subscribe(hs.window.filter.windowUnfocused, function()
      showThingsQuickEntryPanel:enable()
    end)
    .setLogLevel('error')

hs.loadSpoon("WaitingFor")
spoon.WaitingFor:bindHotkeys({
  insertText = { "⌃⌥⌘", "w" }
})

-- ================================================
-- Disabled generally while I'm trying out Ghostty!
-- ================================================
if hs.host.localizedName() == "st-mt2" then
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
end

-- ================================================
-- Only bother with this menu at work.
-- ================================================
if hs.host.localizedName() == "st-mt2" then
  hs.loadSpoon("PullRequests")
  local lastPrMenu = hs.menubar.new(true, "org.matthewtodd.hammerspoon.pull_requests")
  local lastByMeOutput = ""

  local function refreshPullRequestMenu()
    log.d("checking pull request status")
    local byMeOutput, byMeSuccess, _, _ = hs.execute("${HOME}/.local/bin/github-pull-requests", true)

    if not byMeSuccess then
      log.e(byMeOutput)
      return
    end

    if lastByMeOutput == byMeOutput then
      log.d("pr info unchanged")
      return
    end

    log.d("pr info changed, rebuilding menu")
    lastByMeOutput = byMeOutput
    local byMe = byMeOutput == "\n" and {} or hs.json.decode(byMeOutput)

    if byMe == nil then
      log.df("could not parse response as json %s", byMeOutput)
      return
    end

    local prMenu = hs.menubar.new(true, "org.matthewtodd.hammerspoon.pull_requests")
    lastPrMenu:delete()
    lastPrMenu = prMenu

    spoon.PullRequests:
        summary(byMe, "Matthew Todd").
        accept(spoon.PullRequests:menuBuilder(prMenu)).
        render()
  end

  refreshPullRequestMenu()
  timer = hs.timer.new(60, refreshPullRequestMenu, true)
  timer:start()
end
