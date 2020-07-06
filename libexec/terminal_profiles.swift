#!/usr/bin/swift

// ls libexec/terminal_profiles.swift | entr -c libexec/terminal_profiles.swift

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

  func asNSColor() -> NSColor {
    NSColor(
        calibratedRed: CGFloat((self.rawValue >> 16) & 0xff) / 255,
        green: CGFloat((self.rawValue >> 8) & 0xff) / 255,
        blue: CGFloat((self.rawValue >> 0) & 0xff) / 255,
        alpha: 1.0
    )
  }
}

protocol EncodableAsArchivedData: Encodable {}

extension EncodableAsArchivedData {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true))
  }
}

extension NSColor: EncodableAsArchivedData {}
extension NSFont: EncodableAsArchivedData {}

struct TerminalProfile: Encodable {
    var type = "Window Settings"

    var ANSIBrightBlackColor: NSColor
    var ANSIBlackColor: NSColor
    var ANSIBrightGreenColor: NSColor
    var ANSIBrightYellowColor: NSColor
    var ANSIBrightBlueColor: NSColor
    var ANSIBrightCyanColor: NSColor
    var ANSIWhiteColor: NSColor
    var ANSIBrightWhiteColor: NSColor
    var ANSIYellowColor = Solarized.yellow.asNSColor()
    var ANSIBrightRedColor = Solarized.orange.asNSColor()
    var ANSIRedColor = Solarized.red.asNSColor()
    var ANSIMagentaColor = Solarized.magenta.asNSColor()
    var ANSIBrightMagentaColor = Solarized.violet.asNSColor()
    var ANSIBlueColor = Solarized.blue.asNSColor()
    var ANSICyanColor = Solarized.cyan.asNSColor()
    var ANSIGreenColor = Solarized.green.asNSColor()

    var BackgroundColor: NSColor
    var BlinkText = false
    var CursorColor: NSColor
    var Font = NSFont(name: "Go Mono", size: 12)!
    var FontAntialias = true
    var SelectionColor: NSColor
    var ShowActiveProcessArgumentsInTitle = false
    var ShowActiveProcessInTabTitle = false
    var ShowActiveProcessInTitle = false
    var ShowActivityIndicatorInTab = true
    var ShowCommandKeyInTitle = false
    var ShowDimensionsInTitle = false
    var ShowRepresentedURLInTabTitle = true
    var ShowRepresentedURLInTitle = true
    var ShowRepresentedURLPathInTabTitle = false
    var ShowRepresentedURLPathInTitle = true
    var ShowShellCommandInTitle = false
    var ShowTTYNameInTitle = false
    var ShowWindowSettingsNameInTitle = false
    var ShouldRestoreContent = false
    var TerminalType = "xterm-256color"
    var TextBoldColor: NSColor
    var TextColor: NSColor
    var UseBoldFonts = true
    var UseBrightBold = false
    var VisualBellOnlyWhenMuted = true
    var WindowTitle = ""

    var columnCount = 80
    var rowCount = 24
    var shellExitAction = 1
}

let light = TerminalProfile(
  ANSIBrightBlackColor: Solarized.base03.asNSColor(),
  ANSIBlackColor: Solarized.base02.asNSColor(),
  ANSIBrightGreenColor: Solarized.base01.asNSColor(),
  ANSIBrightYellowColor: Solarized.base00.asNSColor(),
  ANSIBrightBlueColor: Solarized.base0.asNSColor(),
  ANSIBrightCyanColor: Solarized.base1.asNSColor(),
  ANSIWhiteColor: Solarized.base2.asNSColor(),
  ANSIBrightWhiteColor: Solarized.base3.asNSColor(),
  BackgroundColor: Solarized.base3.asNSColor(),
  CursorColor: Solarized.base1.asNSColor(),
  SelectionColor: Solarized.base02.asNSColor(),
  TextBoldColor: Solarized.base01.asNSColor(),
  TextColor: Solarized.base1.asNSColor()
)

let dark = TerminalProfile(
  ANSIBrightBlackColor: Solarized.base3.asNSColor(),
  ANSIBlackColor: Solarized.base2.asNSColor(),
  ANSIBrightGreenColor: Solarized.base1.asNSColor(),
  ANSIBrightYellowColor: Solarized.base0.asNSColor(),
  ANSIBrightBlueColor: Solarized.base00.asNSColor(),
  ANSIBrightCyanColor: Solarized.base01.asNSColor(),
  ANSIWhiteColor: Solarized.base02.asNSColor(),
  ANSIBrightWhiteColor: Solarized.base03.asNSColor(),
  BackgroundColor: Solarized.base03.asNSColor(),
  CursorColor: Solarized.base00.asNSColor(),
  SelectionColor: Solarized.base2.asNSColor(),
  TextBoldColor: Solarized.base1.asNSColor(),
  TextColor: Solarized.base0.asNSColor()
)


let encoder = PropertyListEncoder()
encoder.outputFormat = .xml
try! print(String(data: encoder.encode(light), encoding: .utf8)!)
try! encoder.encode(light).write(to: URL(fileURLWithPath: "share/Solarized Light.terminal"))
try! encoder.encode(dark).write(to: URL(fileURLWithPath: "share/Solarized Dark.terminal"))

