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

local LEFT = left(1/4)
local CENTER = center(1/2)
local CENTER_SMALL = center(1/3)
local CENTER_LARGE = center(3/4)
local SIDEBAR = center(1/2, 1/12)
local RIGHT = right(1/4)

local applicationConfig = {
  ["Built-in Retina Display"] = {
    Mimestream  = { center(2/3, 2/15), center(2/5) },
    Slack       = { left(2/5), center(2/3, 2/15), right(2/5) },
    Things      = { left(2/5), center(2/3, 2/15) },

    __default__ = { left(2/5), center(2/3), right(2/5) },
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
    RubyMine    = { CENTER, CENTER_LARGE },
    Slack       = { LEFT, SIDEBAR, RIGHT },
    Terminal    = { LEFT, CENTER, RIGHT },
    Things      = { LEFT, SIDEBAR },

    __default__ = { LEFT, CENTER, RIGHT },
  },
}

local withDefault = { __index = function (t) return t.__default__ end }

setmetatable(applicationConfig, withDefault)
setmetatable(applicationConfig.__default__, withDefault)
setmetatable(applicationConfig["Built-in Retina Display"], withDefault)
setmetatable(applicationConfig["Sidecar Display (AirPlay)"], withDefault)

local heights = {
  left = 4/5,
  center = 19/20,
  right = 4/5,
}

spoon.Divvy:configure(
  -- default mode: per-application presets
  function(application, screen)
    local config = applicationConfig[screen:name()][application:title()]

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
  activate={{"cmd", "alt", "ctrl"}, "space"}
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

hs.loadSpoon("PullRequests")
local lastPrMenu = hs.menubar.new(true, "org.matthewtodd.hammerspoon.pull_requests")
local lastByMeOutput = ""
local lastToMeOutput = ""

local function refreshPullRequestMenu()
  log.d("checking pull request status")
  -- Unfortunately we make 2 calls, since I can't get the Github graphql api to accept an OR.
  local byMeOutput, byMeSuccess, _, _ = hs.execute("/opt/homebrew/bin/gh pr-statuses author:@me --cache 3m")
  local toMeOutput, toMeSuccess, _, _ = hs.execute("/opt/homebrew/bin/gh pr-statuses assignee:@me --cache 3m")

  if not byMeSuccess or not toMeSuccess then
    log.e(byMeOutput)
    log.e(toMeOutput)
    return
  end

  if lastByMeOutput == byMeOutput and lastToMeOutput == toMeOutput then
    log.d("pr info unchanged")
    return
  end

  log.d("pr info changed, rebuilding menu")
  lastByMeOutput = byMeOutput
  lastToMeOutput = toMeOutput
  local byMe = byMeOutput == "\n" and {} or hs.json.decode(byMeOutput)
  local toMe = toMeOutput == "\n" and {} or hs.json.decode(toMeOutput)

  if byMe == nil then
    log.df("could not parse response as json %s", byMeOutput)
    return
  end

  if toMe == nil then
    log.df("could not parse response as json %s", toMeOutput)
    return
  end

  local prMenu = hs.menubar.new(true, "org.matthewtodd.hammerspoon.pull_requests")
  lastPrMenu:delete()
  lastPrMenu = prMenu

  spoon.PullRequests:
    summary(hs.fnutils.concat(byMe, toMe), "Matthew Todd").
    accept(spoon.PullRequests:menuBuilder(prMenu)).
    render()
end

refreshPullRequestMenu()
timer = hs.timer.new(60, refreshPullRequestMenu, true)
timer:start()
