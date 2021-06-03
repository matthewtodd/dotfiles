hs.loadSpoon("Divvy")

spoon.Divvy:configure(function(screen)
  -- x, y, w, h
  if screen == hs.screen.primaryScreen() then
    if screen:frame().w <= 1366 then
      return {
        {0, 0, 1/2, 1}, -- left half
        {0, 0, 3/4, 1}, -- left 3/4
        {1/8, 0, 3/4, 1}, -- center
        {1/2, 0, 1/2, 1}, -- right half
      }
    else
      return {
        {0, 0, 1/4, 4/5}, -- left quarter
        {1/4, 0, 5/12, 19/20}, -- center wide, tucked in
        {1/4, 0, 1/2, 19/20}, -- center wide
        {1/3, 0, 1/3, 19/20}, -- center narrow
        {3/4, 0, 1/4, 9/10}, -- right quarter
      }
    end
  else -- secondary screen
    return {
      {0,   0, 1/2, 1}, -- left half
      {1/8, 0, 3/4, 1}, -- center 3/4
      {1/2, 0, 1/2, 1}, -- right half
    }
  end
end)

spoon.Divvy:bindHotkeys({
  activate={{"cmd", "alt", "ctrl"}, "space"}
})

showThingsQuickEntryPanel = hs.hotkey.new('⌃', 'space', function()
  hs.osascript.applescript('tell application "Things3" to show quick entry panel')
end)

showThingsQuickEntryPanel:enable()

local function setFnKeyMode(mode)
  -- TODO yuck, a hardcoded path!
  hs.execute("/Users/matthew/Code/matthewtodd/dotfiles/libexec/fn_key_mode.swift " .. mode)
end

hs.window.filter.new('IntelliJ IDEA')
  :subscribe(hs.window.filter.windowFocused, function()
    showThingsQuickEntryPanel:disable()
    setFnKeyMode("function")
  end)
  :subscribe(hs.window.filter.windowUnfocused, function()
    showThingsQuickEntryPanel:enable()
    setFnKeyMode("media")
  end)
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

-- TODO Use / rewrite something like bluetoothconnector to make a 1-click menu item for AirPods.
-- https://github.com/lapfelix/BluetoothConnector

-- Not really using for now, and I like a clean menu bar!
-- hs.loadSpoon("Caffeine")
-- spoon.Caffeine:start()

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
