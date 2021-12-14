hs.loadSpoon("Divvy")

spoon.Divvy:configure(function(screen)
  -- x, y, w, h
  if screen == hs.screen.primaryScreen() then
    return {
      {0, 0, 1/4, 4/5}, -- left quarter
      {1/4, 0, 5/12, 19/20}, -- center wide, tucked in
      {1/4, 0, 1/2, 19/20}, -- center wide
      {3/4, 0, 1/4, 9/10}, -- right quarter
    }
  else -- secondary screen
    return {
      {0, 0, 1, 1}, -- full
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

hs.window.filter.new({'Code', 'GoLand', 'IntelliJ IDEA'})
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
