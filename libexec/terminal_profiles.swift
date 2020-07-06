#!/usr/bin/swift

// ls libexec/terminal_profiles.swift | entr -c libexec/terminal_profiles.swift

import Foundation
import AppKit

extension NSColor {
  convenience init(hex: Int) {
    self.init(
        calibratedRed: CGFloat((hex >> 16) & 0xff) / 255,
        green: CGFloat((hex >> 8) & 0xff) / 255,
        blue: CGFloat((hex >> 0) & 0xff) / 255,
        alpha: 1.0
    )
  }
}

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
}

let base03  = NSColor(hex: 0x002b36)
let base02  = NSColor(hex: 0x073642)
let base01  = NSColor(hex: 0x586e75)
let base00  = NSColor(hex: 0x657b83)
let base0   = NSColor(hex: 0x839496)
let base1   = NSColor(hex: 0x93a1a1)
let base2   = NSColor(hex: 0xeee8d5)
let base3   = NSColor(hex: 0xfdf6e3)
let yellow  = NSColor(hex: 0xb58900)
let orange  = NSColor(hex: 0xcb4b16)
let red     = NSColor(hex: 0xdc322f)
let magenta = NSColor(hex: 0xd33682)
let violet  = NSColor(hex: 0x6c71c4)
let blue    = NSColor(hex: 0x268bd2)
let cyan    = NSColor(hex: 0x2aa198)
let green   = NSColor(hex: 0x859900)

extension NSColor: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true))
  }
}

extension NSFont: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true))
  }
}

extension Solarized: Encodable {
  public func encode(to encoder: Encoder) throws {
    let color = NSColor(hex: self.rawValue)
    let data = try! NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
    var container = encoder.singleValueContainer()
    try container.encode(data)
  }
}

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
    var ANSIYellowColor = Solarized.yellow
    var ANSIBrightRedColor = orange
    var ANSIRedColor = red
    var ANSIMagentaColor = magenta
    var ANSIBrightMagentaColor = violet
    var ANSIBlueColor = blue
    var ANSICyanColor = cyan
    var ANSIGreenColor = green

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
  ANSIBrightBlackColor: base03,
  ANSIBlackColor: base02,
  ANSIBrightGreenColor: base01,
  ANSIBrightYellowColor: base00,
  ANSIBrightBlueColor: base0,
  ANSIBrightCyanColor: base1,
  ANSIWhiteColor: base2,
  ANSIBrightWhiteColor: base3,
  BackgroundColor: base3,
  CursorColor: base1,
  SelectionColor: base02,
  TextBoldColor: base01,
  TextColor: base1
)

let dark = TerminalProfile(
  ANSIBrightBlackColor: base3,
  ANSIBlackColor: base2,
  ANSIBrightGreenColor: base1,
  ANSIBrightYellowColor: base0,
  ANSIBrightBlueColor: base00,
  ANSIBrightCyanColor: base01,
  ANSIWhiteColor: base02,
  ANSIBrightWhiteColor: base03,
  BackgroundColor: base03,
  CursorColor: base00,
  SelectionColor: base2,
  TextBoldColor: base1,
  TextColor: base0
)


let encoder = PropertyListEncoder()
encoder.outputFormat = .xml
try! print(String(data: encoder.encode(light), encoding: .utf8)!)
try! encoder.encode(light).write(to: URL(fileURLWithPath: "share/Solarized Light.terminal"))
try! encoder.encode(dark).write(to: URL(fileURLWithPath: "share/Solarized Dark.terminal"))

