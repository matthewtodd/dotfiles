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

protocol DynamicDesktopImage {
  var cgImage: CGImage { get }
}

class SolidColorDynamicDesktopImage: DynamicDesktopImage {
  let color: Solarized
  let width = 128
  let height = 128

  init(_ color: Solarized) {
    self.color = color
  }

  var cgImage: CGImage {
    let context = CGContext(
      data: nil,
      width: width,
      height: height,
      bitsPerComponent: 8,
      bytesPerRow: 0,
      space: CGColorSpaceCreateDeviceRGB(),
      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
    )!
    context.setFillColor(red: color.red, green: color.green, blue: color.blue, alpha: 1.0)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    return context.makeImage()!
  }
}

class LightDarkDynamicDesktop {
  let light: DynamicDesktopImage
  let dark: DynamicDesktopImage

  init(light: DynamicDesktopImage, dark: DynamicDesktopImage) {
    self.light = light
    self.dark = dark
  }

  func write(to path: String) {
    let result = CGImageDestinationCreateWithURL(
      URL(fileURLWithPath: path) as CFURL,
      AVFileType.heic as CFString,
      2,
      nil
    )!

    CGImageDestinationAddImageAndMetadata(result, light.cgImage, imageMetadata, nil)
    CGImageDestinationAddImage(result, dark.cgImage, nil)
    CGImageDestinationFinalize(result)
  }

  private var imageMetadata: CGImageMetadata {
    let result = CGImageMetadataCreateMutable()

    let tag = CGImageMetadataTagCreate(
      "http://ns.apple.com/namespace/1.0/" as CFString,
      "apple_desktop" as CFString,
      "solar" as CFString,
      .string,
      Apr().encoded() as CFString
    )!

    CGImageMetadataSetTagWithPath(result, nil, "xmp:solar" as CFString, tag)

    return result
  }
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

LightDarkDynamicDesktop(light: SolidColorDynamicDesktopImage(.base0), dark: SolidColorDynamicDesktopImage(.base03)).write(to: "share/Solarized.heic")
