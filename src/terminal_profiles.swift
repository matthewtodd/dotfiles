#!/usr/bin/swift

// ls libexec/terminal_profiles.swift | entr -c libexec/terminal_profiles.swift
// fswatch libexec/terminal_profiles.swift | xargs -n1 swift

import Foundation
import AppKit

enum Solarized: Int {
  case base03  = 0x002b36
  case base02  = 0x073642
  case base01  = 0x586e75
  case base00  = 0x657b83
  case base0   = 0x839496
  case base1   = 0x93a1a1
  case base2   = 0xeee8d5
  case base3   = 0xfdf6e3
  case yellow  = 0xb58900
  case orange  = 0xcb4b16
  case red     = 0xdc322f
  case magenta = 0xd33682
  case violet  = 0x6c71c4
  case blue    = 0x268bd2
  case cyan    = 0x2aa198
  case green   = 0x859900

  var color: NSColor {
    NSColor(calibratedRed: self.red, green: self.green, blue: self.blue, alpha: 1.0)
  }

  var red:   CGFloat { component(16) }
  var green: CGFloat { component(8) }
  var blue:  CGFloat { component(0) }

  private func component(_ shift: Int) -> CGFloat {
    CGFloat((self.rawValue >> shift) & 0xff) / 0xff
  }
}

struct WindowSettings {
    let type = "Window Settings"
    let name: String

    let ANSIBrightBlackColor: Solarized
    let ANSIBlackColor: Solarized
    let ANSIBrightGreenColor: Solarized
    let ANSIBrightYellowColor: Solarized
    let ANSIBrightBlueColor: Solarized
    let ANSIBrightCyanColor: Solarized
    let ANSIWhiteColor: Solarized
    let ANSIBrightWhiteColor: Solarized
    let ANSIYellowColor = Solarized.yellow
    let ANSIBrightRedColor = Solarized.orange
    let ANSIRedColor = Solarized.red
    let ANSIMagentaColor = Solarized.magenta
    let ANSIBrightMagentaColor = Solarized.violet
    let ANSIBlueColor = Solarized.blue
    let ANSICyanColor = Solarized.cyan
    let ANSIGreenColor = Solarized.green

    let BackgroundColor: Solarized
    let BlinkText = false
    let CursorColor: Solarized
    /* let Font = NSFont(name: "Fira Code", size: 12)! */
    /* let Font = NSFont(name: "Hack", size: 12)! */
    /* let Font = NSFont(name: "Inconsolata", size: 14)! */
    /* let Font = NSFont(name: "JetBrains Mono", size: 12)! */
    let Font = NSFont(name: "Menlo", size: 12)!
    let FontAntialias = true
    let FontHeightSpacing = 1.0
    let FontWidthSpacing = 1.0
    let SelectionColor: Solarized
    let ShowActiveProcessArgumentsInTitle = false
    let ShowActiveProcessInTabTitle = false
    let ShowActiveProcessInTitle = false
    let ShowActivityIndicatorInTab = true
    let ShowCommandKeyInTitle = false
    let ShowDimensionsInTitle = false
    let ShowRepresentedURLInTabTitle = true
    let ShowRepresentedURLInTitle = true
    let ShowRepresentedURLPathInTabTitle = false
    let ShowRepresentedURLPathInTitle = true
    let ShowShellCommandInTitle = false
    let ShowTTYNameInTitle = false
    let ShowWindowSettingsNameInTitle = false
    let ShouldRestoreContent = false
    let TerminalType = "xterm-256color"
    let TextBoldColor: Solarized
    let TextColor: Solarized
    let UseBoldFonts = true
    let UseBrightBold = false
    let VisualBellOnlyWhenMuted = true
    let WindowTitle = ""

    let columnCount = 80
    let rowCount = 24
    let shellExitAction = 1

    func asPropertyList() -> [String: Any] {
      let mirror = Mirror(reflecting: self)
      var result: [String: Any] = [:]

      for (label, value) in mirror.children {
        switch value {
        case let solarized as Solarized:
          result[label!] = try! NSKeyedArchiver.archivedData(withRootObject: solarized.color, requiringSecureCoding: true)
        case let font as NSFont:
          result[label!] = try! NSKeyedArchiver.archivedData(withRootObject: font, requiringSecureCoding: true)
        default:
          result[label!] = value
        }
      }

      return result
    }
}

let light = WindowSettings(
  name: "Solarized Light",
  ANSIBrightBlackColor: Solarized.base03,
  ANSIBlackColor: Solarized.base02,
  ANSIBrightGreenColor: Solarized.base01,
  ANSIBrightYellowColor: Solarized.base00,
  ANSIBrightBlueColor: Solarized.base0,
  ANSIBrightCyanColor: Solarized.base1,
  ANSIWhiteColor: Solarized.base2,
  ANSIBrightWhiteColor: Solarized.base3,
  BackgroundColor: Solarized.base3,
  CursorColor: Solarized.base1,
  SelectionColor: Solarized.base02,
  TextBoldColor: Solarized.base01,
  TextColor: Solarized.base1
)

let dark = WindowSettings(
  name: "Solarized Dark",
  ANSIBrightBlackColor: Solarized.base3,
  ANSIBlackColor: Solarized.base2,
  ANSIBrightGreenColor: Solarized.base1,
  ANSIBrightYellowColor: Solarized.base0,
  ANSIBrightBlueColor: Solarized.base00,
  ANSIBrightCyanColor: Solarized.base01,
  ANSIWhiteColor: Solarized.base02,
  ANSIBrightWhiteColor: Solarized.base03,
  BackgroundColor: Solarized.base03,
  CursorColor: Solarized.base00,
  SelectionColor: Solarized.base2,
  TextBoldColor: Solarized.base1,
  TextColor: Solarized.base0
)

let terminal = UserDefaults(suiteName: "com.apple.Terminal")!
terminal.set([light.name: light.asPropertyList(), dark.name: dark.asPropertyList()], forKey: "Window Settings")
terminal.set(light.name, forKey: "Default Window Settings")
terminal.set(light.name, forKey: "Startup Window Settings")
terminal.synchronize()
