class KanataTray < Formula
  desc "Tray Icon for Kanata"
  homepage "https://github.com/rszyma/kanata-tray"
  url "https://github.com/rszyma/kanata-tray/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "9ec2b82e2b9717b6a607f9f7d1b1082c352c85bd97ecec8c04f40725e4cf4d62"
  license "GPL"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end
end
