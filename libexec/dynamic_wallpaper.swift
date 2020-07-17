#!/usr/bin/swift

// ls libexec/dynamic_wallpaper.swift | entr -c libexec/dynamic_wallpaper.swift
// https://nshipster.com/macos-dynamic-desktop/
// https://harshil.net/blog/dynamic-wallpapers-in-macos-catalina

import Foundation
import CoreGraphics
import AVFoundation

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

  var red:   CGFloat { component(16) }
  var green: CGFloat { component(8) }
  var blue:  CGFloat { component(0) }

  private func component(_ shift: Int) -> CGFloat {
    CGFloat((self.rawValue >> shift) & 0xff) / 0xff
  }
}

func makeImage(_ color: Solarized) -> CGImage {
  let context = CGContext(data: nil, width: 128, height: 128, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)!
  context.setFillColor(red: color.red, green: color.green, blue: color.blue, alpha: 1.0)
  context.fill(CGRect(x: 0, y: 0, width: 128, height: 128))
  return context.makeImage()!
}

struct Apr: Encodable {
  let l = 0
  let d = 1

  func encoded() -> String {
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .binary
    return try! encoder.encode(self).base64EncodedString()
  }
}

let imageMetadata = CGImageMetadataCreateMutable()

let tag = CGImageMetadataTagCreate(
  "http://ns.apple.com/namespace/1.0/" as CFString,
  "apple_desktop" as CFString,
  "apr" as CFString,
  .string,
  Apr().encoded() as CFString
)!

CGImageMetadataSetTagWithPath(imageMetadata, nil, "xmp:apr" as CFString, tag)

let result = CGImageDestinationCreateWithURL(
  URL(fileURLWithPath: "share/Solarized.heic") as CFURL,
  AVFileType.heic as CFString,
  2,
  nil
)!

CGImageDestinationAddImageAndMetadata(result, makeImage(.base0), imageMetadata, nil)
CGImageDestinationAddImage(result, makeImage(.base03), nil)
CGImageDestinationFinalize(result)
