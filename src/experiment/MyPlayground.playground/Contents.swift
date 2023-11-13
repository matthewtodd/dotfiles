import Cocoa

let solarized = NSColorList(name: "Solarized")

//let bundle = Bundle(path: "/Users/matthewtodd/Desktop/Solarized/build/Release/Solarized.bundle")
let bundle = Bundle(identifier: "org.matthewtodd.Solarized")!
let background = NSColor(named: "background", bundle: bundle)!

solarized.setColor(background, forKey: background.colorNameComponent)

try! solarized.write(to: URL(filePath: "Colors/Solarized.clr", relativeTo: URL.libraryDirectory))
