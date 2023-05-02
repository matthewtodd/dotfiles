#!/usr/bin/swift

// ls libexec/dynamic_desktop.swift | entr -c libexec/dynamic_desktop.swift
import AVFoundation
import CoreImage
import Foundation
import SwiftUI

// https://ethanschoonover.com/solarized/#the-values
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

    var color: Color {
        Color(red: red, green: green, blue: blue)
    }

    var red:   CGFloat { component(16) }
    var green: CGFloat { component(8) }
    var blue:  CGFloat { component(0) }

    private func component(_ shift: Int) -> CGFloat {
        CGFloat((self.rawValue >> shift) & 0xff) / 0xff
    }
}

// https://nshipster.com/macos-dynamic-desktop/
// https://harshil.net/blog/dynamic-wallpapers-in-macos-catalina
struct DynamicDesktop {
    let light: CGImage
    let dark: CGImage

    init(light: CGImage, dark: CGImage) {
        self.light = light
        self.dark = dark
    }

    func write(to url: URL) {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .binary

        let tag = CGImageMetadataTagCreate(
            "http://ns.apple.com/namespace/1.0/" as CFString,
            "apple_desktop" as CFString,
            "apr" as CFString,
            .string,
            try! encoder.encode(["l": 0, "d": 1]).base64EncodedString() as CFString
        )!

        let metadata = CGImageMetadataCreateMutable()
        CGImageMetadataSetTagWithPath(metadata, nil, "xmp:apr" as CFString, tag)

        let result = CGImageDestinationCreateWithURL(url as CFURL, AVFileType.heic as CFString, 2, nil)!
        CGImageDestinationAddImageAndMetadata(result, light, metadata, nil)
        CGImageDestinationAddImage(result, dark, nil)
        CGImageDestinationFinalize(result)
    }
}

func render<Content>(_ content: Content) async -> CGImage where Content: View  {
    return await MainActor.run {
        return ImageRenderer(content: content).cgImage!
    }
}

func rectangle(_ fill: any ShapeStyle) -> any View {
    return Rectangle()
        .fill(fill)
        .frame(width: 5120, height: 2880)
        .blur(radius: 800, opaque: true)
}

let file = URL(fileURLWithPath: NSString(string: "~/Pictures/Solarized.heic").expandingTildeInPath)

// https://www.raycast.com/blog/making-a-raycast-wallpaper
DynamicDesktop(
    light: await render(rectangle(.conicGradient(
        Gradient(stops: [
            Gradient.Stop(color: Solarized.base1.color, location: 0),
            Gradient.Stop(color: Solarized.base3.color, location: 0.75),
            Gradient.Stop(color: Solarized.magenta.color, location: 0.8),
            Gradient.Stop(color: Solarized.base1.color, location: 0.85),
        ]),
        center: UnitPoint(x: 0.5, y: 0.75)
    ))),
    dark: await render(rectangle(.conicGradient(
        Gradient(stops: [
            Gradient.Stop(color: Solarized.base03.color, location: 0),
            Gradient.Stop(color: Solarized.base01.color, location: 0.75),
            Gradient.Stop(color: Solarized.magenta.color, location: 0.8),
            Gradient.Stop(color: Solarized.base03.color, location: 0.85),
        ]),
        center: UnitPoint(x: 0.5, y: 0.75)
    )))
).write(
    to: file
)

// HACK switching to a known image then back to ours seems to pick up changes
let workspace = NSWorkspace.shared
let screen = NSScreen.main!
try! workspace.setDesktopImageURL(URL(fileURLWithPath: "/System/Library/Desktop Pictures/Solid Colors/Black.png"), for: screen)
sleep(1)
try! workspace.setDesktopImageURL(file, for: screen)
