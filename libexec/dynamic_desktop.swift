#!/usr/bin/swift

// ls libexec/dynamic_desktop.swift | entr -c libexec/dynamic_desktop.swift
// https://nshipster.com/macos-dynamic-desktop/
// https://harshil.net/blog/dynamic-wallpapers-in-macos-catalina

import Foundation
import CoreGraphics
import AVFoundation
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

  var cgColor: CGColor {
    CGColor(red: red, green: green, blue: blue, alpha: 1.0)
  }

  var red:   CGFloat { component(16) }
  var green: CGFloat { component(8) }
  var blue:  CGFloat { component(0) }

  private func component(_ shift: Int) -> CGFloat {
    CGFloat((self.rawValue >> shift) & 0xff) / 0xff
  }
}

struct DynamicDesktop {
  enum Image {
    case solid(_ color: Solarized)
    case gradient(_ startColor: Solarized, _ endColor: Solarized)

    func cgImage(_ size: CGSize) -> CGImage {
      let space = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(
        data: nil,
        width: Int(size.width),
        height: Int(size.height),
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: space,
        bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
      )!

      switch self {
        case .solid(let color):
          context.setFillColor(color.cgColor)
          context.fill(CGRect(origin: .zero, size: size))

        case .gradient(let startColor, let endColor):
          context.drawLinearGradient(
            CGGradient(
              colorsSpace: space,
              colors: [startColor.cgColor, endColor.cgColor] as CFArray,
              locations: [0, 0.75 as CGFloat]
            )!,
            start: .zero,
            end: CGPoint(x:0, y:size.height),
            options: []
          )
      }

      return context.makeImage()!
    }
  }

  struct Metadata: Encodable {
    let ap: Appearance?
    let si: [SolarInclination]

    struct Appearance: Encodable {
      let l: Int
      let d: Int
    }

    struct SolarInclination: Encodable {
      let i: Int
      let a: Double
      let z: Double
    }

    enum Configuration {
      case light
      case dark
      case inclination(_ altitude: Double, _ azimuth: Double)

      func apply(at index: Int, to metadata: Metadata) -> Metadata {
        switch self {
          case .light:
            return Metadata(
              ap: Metadata.Appearance(l: index, d: metadata.ap?.d ?? index),
              si: metadata.si
            )
          case .dark:
            return Metadata(
              ap: Metadata.Appearance(l: metadata.ap?.l ?? index, d: index),
              si: metadata.si
            )
          case .inclination(let altitude, let azimuth):
            var si = metadata.si
            si.append(Metadata.SolarInclination(i: index, a: altitude, z: azimuth))
            return Metadata(
              ap: metadata.ap,
              si: si
            )
        }
      }
    }

    var cgImageMetadata: CGImageMetadata {
      let encoder = PropertyListEncoder()
      encoder.outputFormat = .binary
      let tag = CGImageMetadataTagCreate(
        "http://ns.apple.com/namespace/1.0/" as CFString,
        "apple_desktop" as CFString,
        "solar" as CFString,
        .string,
        try! encoder.encode(self).base64EncodedString() as CFString
      )

      let metadata = CGImageMetadataCreateMutable()
      CGImageMetadataSetTagWithPath(metadata, nil, "xmp:solar" as CFString, tag!)
      return metadata
    }
  }

  let size: CGSize
  let images: [Image]
  let metadata: Metadata

  init(size: CGSize, images: [Image] = [], metadata: Metadata = Metadata(ap: nil, si: [])) {
    self.size = size
    self.images = images
    self.metadata = metadata
  }

  func with(_ image: Image, _ configuration: Metadata.Configuration...) -> DynamicDesktop {
    var newImages = images
    var newMetadata = metadata

    let index = images.count

    newImages.append(image)

    for option in configuration {
      newMetadata = option.apply(at: index, to: newMetadata)
    }

    return DynamicDesktop(size: size, images: newImages, metadata: newMetadata)
  }

  func write(to url: URL) {
    let result = CGImageDestinationCreateWithURL(
      url as CFURL,
      AVFileType.heic as CFString,
      images.count,
      nil
    )!

    for (index, image) in images.enumerated() {
      if index == 0 {
        CGImageDestinationAddImageAndMetadata(result, image.cgImage(size), metadata.cgImageMetadata, nil)
      } else {
        CGImageDestinationAddImage(result, image.cgImage(size), nil)
      }
    }

    CGImageDestinationFinalize(result)
  }
}

let workspace = NSWorkspace.shared
let screen = NSScreen.main!
let file = URL(fileURLWithPath: "/Users/matthew/Pictures/Solarized.heic")

DynamicDesktop(size: screen.frame.size)
  .with(.gradient(.base3, .base1), .light, .inclination(0, 270))
  .with(.gradient(.base01, .base03), .dark, .inclination(-25, 180))
  .write(to: file)

// HACK switching to a known image then back to ours seems to pick up changes
try! workspace.setDesktopImageURL(URL(fileURLWithPath: "/System/Library/Desktop Pictures/Solid Colors/Black.png"), for: screen)
sleep(1)
try! workspace.setDesktopImageURL(file, for: screen)
