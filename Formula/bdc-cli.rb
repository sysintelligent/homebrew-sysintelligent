class BdcCli < Formula
  desc "A tool between developers and complex backend infrastructure"
  homepage "https://github.com/sysintelligent/bdc-bridge"
  url "https://github.com/sysintelligent/bdc-bridge/archive/v1.0.2.tar.gz"
  sha256 "7269fbd7148dfd5daef88365122662162018548472776cd2d348b63397a8d3ab"

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "npm" => :build

  def install
    system "go", "build", "-o", "bdc-cli", "./cmd/bdc-cli"
    bin.install "bdc-cli"

    # Install UI files
    cd "ui" do
      system "npm", "install"
      system "npm", "run", "build"
      
      # Create the share directory
      share_dir = share/"bdc-cli"
      share_dir.mkpath
      
      # Install UI files
      ui_dir = share_dir/"ui"
      ui_dir.mkpath
      
      # Copy all files from the build directory
      system "cp", "-R", ".next", ui_dir
      system "cp", "-R", "public", ui_dir
      system "cp", "package.json", ui_dir
      system "cp", "next.config.js", ui_dir
    end
  end

  test do
    system "#{bin}/bdc-cli", "version"
  end
end 