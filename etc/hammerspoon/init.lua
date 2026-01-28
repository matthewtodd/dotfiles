local canvas = require("hs.canvas")
local console = require("hs.console")
local fnutils = require("hs.fnutils")
local menubar = require("hs.menubar")
local spoons = require("hs.spoons")
local styledtext = require("hs.styledtext")
local timer = require("hs.timer")
local urlevent = require("hs.urlevent")

console.clearConsole()

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

spoons.use("WindowPlaces", {
  fn = function(divvy)
    divvy:addMode(
      function(application, screen)
        local config = applicationConfig[screen:name()][application:title()]

        return fnutils.map(config, function(rect)
          local x, y, w, h, position = table.unpack(rect)
          return { x, y, w, heights[screen:name()][position] or h }
        end)
      end
    )

    divvy:addMode(
      divvy.recipes.fullscreen
    )
  end,

  hotkeys = {
    activate = { { "cmd", "alt", "ctrl" }, "space" },
    commit = { {}, "return" },
    cancel = { {}, "escape" },
    mode = { {}, "f" },
    next = { {}, "i" },
    previous = { {}, "c" },
  },
})

spoons.use("WaitingFor", {
  hotkeys = {
    insertText = { "⌃⌥⌘", "w" }
  },
})

local function iconFromText(text)
  return canvas.new({ h = 16, w = 18 }):appendElements({
    text = styledtext.new(text, { font = styledtext.defaultFonts.menuBar }), type = "text"
  }):imageFromCanvas()
end

local notifications = menubar.new(true, "org.matthewtodd.hammerspoon.notifications")
local octopus = iconFromText("🐙")
local openNotifications = function()
  urlevent.openURL("https://github.com/notifications")
end

local function refreshNotifications()
  local handle = io.popen("${HOME}/.local/bin/github-notifications 2>&1")

  if handle then
    local result = handle:read("*n")

    handle:close()

    notifications:setIcon(octopus)
    notifications:setTitle(result)
    notifications:setClickCallback(openNotifications)

    if result == 0 and notifications:isInMenuBar() then
      notifications:removeFromMenuBar()
    elseif result ~= 0 and not notifications:isInMenuBar() then
      notifications:returnToMenuBar()
    end
  end
end

refreshNotifications()
NotificationsTimer = timer.new(60, refreshNotifications, true)
NotificationsTimer:start()
