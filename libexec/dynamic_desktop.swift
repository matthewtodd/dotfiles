#!/usr/bin/swift

// ls libexec/dynamic_desktop.swift | entr -c fish -c "swift libexec/dynamic_desktop.swift ~/Pictures/Solarized.heic && swift libexec/set_desktop_image.swift ~/Pictures/Solarized.heic"
import AVFoundation
import SwiftUI

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

        let destination = CGImageDestinationCreateWithURL(url as CFURL, AVFileType.heic as CFString, 2, nil)!
        CGImageDestinationAddImageAndMetadata(destination, light, metadata, nil)
        CGImageDestinationAddImage(destination, dark, nil)
        CGImageDestinationFinalize(destination)
    }
}

// We want to draw angular gradients, which only SwiftUI has. (CoreGraphics can
// only do linear and radial ones.) So we use this trick to turn a SwiftUI View
// into an image: https://stackoverflow.com/a/76083393
func render<Content>(_ content: Content) async -> CGImage where Content: View  {
    return await MainActor.run {
        return ImageRenderer(content: content).cgImage!
    }
}

// https://www.raycast.com/blog/making-a-raycast-wallpaper
func raycast(stops: [Gradient.Stop], center: UnitPoint, angle: Angle) -> any View {
    return Rectangle()
        .fill(.conicGradient(stops: stops, center: center, angle: angle))
        .frame(width: 5120, height: 2880)
        .blur(radius: 800, opaque: true)
}

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
        Color(red: component(16), green: component(8), blue: component(0))
    }

    func at(_ location: CGFloat) -> Gradient.Stop {
        Gradient.Stop(color: self.color, location: location)
    }

    private func component(_ shift: Int) -> CGFloat {
        CGFloat((self.rawValue >> shift) & 0xff) / 0xff
    }
}

let desktop = DynamicDesktop(
    light: await render(raycast(
        stops: [
            Solarized.base1.at(0),
            Solarized.base3.at(0.75),
            Solarized.green.at(0.8),
            Solarized.base1.at(0.85)
        ],
        center: UnitPoint(x: 0.5, y: 0.75),
        angle: .degrees(0)
    )),

    dark: await render(raycast(
        stops: [
            Solarized.base03.at(0),
            Solarized.base01.at(0.15),
            Solarized.green.at(0.2),
            Solarized.base03.at(0.25)
        ],
        center: UnitPoint(x: 0.5, y: 0.5),
        angle: .degrees(0)
    ))
)

desktop.write(to: URL(fileURLWithPath: CommandLine.arguments[1]))
