cask "karabiner-driverkit-virtualhiddevice" do
  version "3.1.0"
  sha256 "2008ffeb47b12dc76f156b125b54d4f449968b0cc1effb6e9f3557cfe03e1f9d"

  url "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v#{version}/Karabiner-DriverKit-VirtualHIDDevice-#{version}.pkg"
  name "karabiner-driverkit-virtualhiddevice"
  desc "Implements a virtual keyboard and virtual mouse using DriverKit on macOS."
  homepage "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice"

  pkg "Karabiner-DriverKit-VirtualHIDDevice-#{version}.pkg"

  postflight do
    system_command "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager",
      args: ["activate"]
  end

  uninstall_preflight do
    system_command "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager",
      args: ["deactivate"]
  end

  uninstall launchctl: "org.pqrs.Karabiner-DriverKit-VirtualHIDDeviceClient",
    pkgutil: "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice"
end
