class ExampleTool < Formula
  desc "Example internal tool for demonstration"
  homepage "https://github.com/organization/example-tool"
  url "https://github.com/organization/example-tool/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "YOUR_TARBALL_SHA256_HERE"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"example-tool"
  end

  test do
    system "#{bin}/example-tool", "--version"
  end
end 