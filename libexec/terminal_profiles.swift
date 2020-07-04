#!/usr/bin/swift

// ls libexec/terminal_profiles.swift | entr -c libexec/terminal_profiles.swift

import Foundation
import AppKit

// TODO make NSColor and NSFont Codable so we don't need this wrapper.
func archive(_ object: NSObject) -> Data {
    try! NSKeyedArchiver.archivedData(
        withRootObject: object,
        requiringSecureCoding: true
    )
}

func hsb(_ hue: UInt16, _ saturation: UInt8, _ brightness: UInt8) -> NSColor {
    NSColor(
        hue: CGFloat(hue) / 360.0,
        saturation: CGFloat(saturation) / 100.0,
        brightness: CGFloat(brightness) / 100.0,
        alpha: 1.0
    )
}

let base03  = archive(hsb(193, 100,  21))
let base02  = archive(hsb(192,  90,  26))
let base01  = archive(hsb(194,  25,  46))
let base00  = archive(hsb(195,  23,  51))
let base0   = archive(hsb(186,  13,  59))
let base1   = archive(hsb(180,   9,  63))
let base2   = archive(hsb( 44,  11,  93))
let base3   = archive(hsb( 44,  10,  99))
let yellow  = archive(hsb( 45, 100,  71))
let orange  = archive(hsb( 18,  89,  80))
let red     = archive(hsb(  1,  79,  86))
let magenta = archive(hsb(331,  74,  83))
let violet  = archive(hsb(237,  45,  77))
let blue    = archive(hsb(205,  82,  82))
let cyan    = archive(hsb(175,  74,  63))
let green   = archive(hsb( 68, 100,  60))

struct TerminalProfile: Codable {
    var type = "Window Settings"

    var ANSIBrightBlackColor: Data
    var ANSIBlackColor: Data
    var ANSIBrightGreenColor: Data
    var ANSIBrightYellowColor: Data
    var ANSIBrightBlueColor: Data
    var ANSIBrightCyanColor: Data
    var ANSIWhiteColor: Data
    var ANSIBrightWhiteColor: Data
    var ANSIYellowColor = yellow
    var ANSIBrightRedColor = orange
    var ANSIRedColor = red
    var ANSIMagentaColor = magenta
    var ANSIBrightMagentaColor = violet
    var ANSIBlueColor = blue
    var ANSICyanColor = cyan
    var ANSIGreenColor = green

    var BackgroundColor: Data
    var BlinkText = false
    var CursorColor: Data
    var Font = archive(NSFont(name: "Go Mono", size: 12)!)
    var FontAntialias = true
    var SelectionColor: Data
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
    var TextBoldColor: Data
    var TextColor: Data
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
try! encoder.encode(light).write(to: URL(fileURLWithPath: "share/Solarized Light.terminal"))
try! encoder.encode(dark).write(to: URL(fileURLWithPath: "share/Solarized Dark.terminal"))

