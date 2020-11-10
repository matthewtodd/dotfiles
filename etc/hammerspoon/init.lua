local divvy = require 'divvy'

-- x, y, w, h
local options_macbook_air_display = {
  {1/8, 0, 3/4, 1},
  {1/4, 0, 1/2, 1},
  {1/2, 0, 1/2, 1},
  {2/3, 0, 1/3, 1},
  {0, 0, 1, 1},
  {0, 0, 1/2, 1},
  {0, 0, 2/3, 1},
  {0, 0, 3/4, 1},
}

local options_thunderbolt_display = {
  {1/4, 0, 1/2, 19/20},
  {1/3, 0, 1/3, 19/20},
  {1/2, 0, 1/3, 19/20},
  {3/4, 0, 1/4, 9/10},
  {0, 0, 1/4, 4/5},
  {1/6, 0, 1/3, 19/20},
  {1/4, 0, 5/12, 19/20},
}

hs.hotkey.bind('⌃⌥⌘', 'space', function()
  local window = hs.window.focusedWindow()
  local screen = window:screen():frame()
  local options = screen.w <= 1366 and options_macbook_air_display or options_thunderbolt_display
  divvy.start(screen, options, function(frame)
    window:setFrame(frame)
  end)
end)

showThingsQuickEntryPanel = hs.hotkey.new('⌃', 'space', function()
  hs.osascript.applescript('tell application "Things3" to show quick entry panel')
end)

showThingsQuickEntryPanel:enable()

hs.window.filter.new('IntelliJ IDEA')
  :subscribe(hs.window.filter.windowFocused, function() showThingsQuickEntryPanel:disable() end)
  :subscribe(hs.window.filter.windowUnfocused, function() showThingsQuickEntryPanel:enable() end)
  .setLogLevel('error')

addCurrentNetNewsWireArticleToSafariReadingList = hs.hotkey.new('⇧⌘', 'd', function()
  local status, output = hs.osascript.applescript([[
    tell application "NetNewsWire" to set theUrl to the url of the current article
    tell application "Safari" to add reading list item theUrl
  ]])

  if status then hs.alert('Added to Reading List') end
end)

hs.window.filter.new('NetNewsWire')
  :subscribe(hs.window.filter.windowFocused, function() addCurrentNetNewsWireArticleToSafariReadingList:enable() end)
  :subscribe(hs.window.filter.windowUnfocused, function() addCurrentNetNewsWireArticleToSafariReadingList:disable() end)
  .setLogLevel('error')

-- TODO can't just defaults write com.apple.keyboard.fnState to replace fluor
-- https://github.com/Pyroh/Fluor/blob/master/Fluor/utils.m
-- https://news.ycombinator.com/item?id=13372702
-- Maybe I could make and distribute a binary here using Fluor's utils.m?
-- Or there's the awkward AppleScript route, something like
-- https://github.com/jakubroztocil/macos-fn-toggle/blob/master/fn-toggle.app/Contents/document.wflow
-- tell application "System Preferences"
--   reveal anchor "keyboardTab" of pane "com.apple.preference.keyboard"
-- end tell
-- tell application "System Events" to tell process "System Preferences"
--   click checkbox 1 of tab group 1 of window 1
-- end tell
-- quit application "System Preferences"

-- TODO Use / rewrite something like bluetoothconnector to make a 1-click menu item for AirPods.
-- https://github.com/lapfelix/BluetoothConnector

hs.loadSpoon("Caffeine")
spoon.Caffeine:start()

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
