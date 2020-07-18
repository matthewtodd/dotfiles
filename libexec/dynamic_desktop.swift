#!/usr/bin/swift

// ls libexec/dynamic_desktop.swift | entr -c libexec/dynamic_desktop.swift
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

class SolidColorDynamicDesktopImage {
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
    context.setFillColor(color.cgColor)
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    return context.makeImage()!
  }
}


struct DynamicDesktop {
  struct Metadata: Encodable {
    struct Appearance: Encodable {
      let l: Int
      let d: Int
    }

    struct SolarInclination: Encodable {
      let i: Int
      let a: Double
      let z: Double
    }

    let ap: Appearance?
    let si: [SolarInclination]?
  }

  class Builder {
    enum Configuration {
      case light
      case dark

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
        }
      }
    }

    var images: [CGImage] = []
    var metadata: Metadata =  Metadata(ap: nil, si: nil)

    func add(_ image: CGImage, _ configuration: Configuration...) -> Builder {
      let index = images.count

      images.append(image)

      for option in configuration {
        metadata = option.apply(at: index, to: metadata)
      }

      return self
    }

    func build() -> DynamicDesktop {
      return DynamicDesktop(images: images, metadata: metadata)
    }
  }

  let images: [CGImage]
  let metadata: Metadata

  init(images: [CGImage], metadata: Metadata) {
    self.images = images
    self.metadata = metadata
  }

  func write(to path: String) {
    let result = CGImageDestinationCreateWithURL(
      URL(fileURLWithPath: path) as CFURL,
      AVFileType.heic as CFString,
      images.count,
      nil
    )!

    for (index, image) in images.enumerated() {
      if index == 0 {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary
        let tag = CGImageMetadataTagCreate(
          "http://ns.apple.com/namespace/1.0/" as CFString,
          "apple_desktop" as CFString,
          "solar" as CFString,
          .string,
          try! encoder.encode(metadata).base64EncodedString() as CFString
        )

        let metadata = CGImageMetadataCreateMutable()
        CGImageMetadataSetTagWithPath(metadata, nil, "xmp:solar" as CFString, tag!)
        CGImageDestinationAddImageAndMetadata(result, image, metadata, nil)
      } else {
        CGImageDestinationAddImage(result, image, nil)
      }
    }

    CGImageDestinationFinalize(result)
  }
}

DynamicDesktop.Builder()
  .add(SolidColorDynamicDesktopImage(.base00).cgImage, .light)
  .add(SolidColorDynamicDesktopImage(.base03).cgImage, .dark)
  .build()
  .write(to: "share/Solarized.heic")
