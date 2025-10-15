local log = hs.logger.new("init.lua", "debug")

hs.console.clearConsole()

-- hs.loadSpoon("Caffeine")
-- spoon.Caffeine:start()

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

hs.spoons.use("Divvy", {
  config = {
    modes = {
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
    },
  },

  hotkeys = {
    activate = { { "cmd", "alt", "ctrl" }, "space" },
    commit = { {}, "return" },
    cancel = { {}, "escape" },
    mode = { {}, "f" },
    next = { {}, "o" },
    previous = { {}, "n" },
  },
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
