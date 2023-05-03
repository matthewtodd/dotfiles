#!/usr/bin/swift

import Foundation
import SwiftUI

// HACK switching to a known image then back to ours seems to pick up changes
let workspace = NSWorkspace.shared
let screen = NSScreen.main!
try! workspace.setDesktopImageURL(URL(fileURLWithPath: "/System/Library/Desktop Pictures/Solid Colors/Black.png"), for: screen)
try! await Task.sleep(nanoseconds: UInt64(0.25 * Double(NSEC_PER_SEC)))
try! workspace.setDesktopImageURL(URL(fileURLWithPath: CommandLine.arguments[1]), for: screen)
