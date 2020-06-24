local divvy = require 'divvy'

hs.hotkey.bind('⌃⌥⌘', 'space', function()
  local window = hs.window.focusedWindow()
  divvy.start(window:screen():frame(), function(frame)
    window:setFrame(frame)
  end)
end)

local showThingsQuickEntryPanel = hs.hotkey.new('⌃', 'space', function()
  hs.osascript.applescript('tell application "Things3" to show quick entry panel')
end)

-- TODO disable when entering IntelliJ, as in:
-- https://github.com/Hammerspoon/hammerspoon/issues/664#issuecomment-202829038
showThingsQuickEntryPanel:enable()

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

local function caffeineIcon(state)
  return state and 'caffeine/Active.png' or 'caffeine/Inactive.png'
end

local caffeine = hs.menubar.new()
caffeine:setIcon(caffeineIcon(hs.caffeinate.get('displayIdle')))
caffeine:setClickCallback(function()
  caffeine:setIcon(caffeineIcon(hs.caffeinate.toggle('displayIdle')))
end)

local function interfaceThemeChanged(notificationName)
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

  hs.execute("killall -USR1 vim")
end

hs.distributednotifications.new(interfaceThemeChanged, "AppleInterfaceThemeChangedNotification"):start()
