class BdcCli < Formula
  desc "A tool between developers and complex backend infrastructure"
  homepage "https://github.com/sysintelligent/bdc-bridge"
  url "https://github.com/sysintelligent/bdc-bridge/archive/v1.0.4.tar.gz"
  sha256 "d9a1697aa4da768046e86a37263b4ee128a0b1939db57992be324088709e2ac9"

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "npm" => :build

  def install
    system "go", "build", "-o", "bdc-cli-bin", "./cmd/bdc-cli"
    libexec.install "bdc-cli-bin"
    
    # Create a wrapper script that sets up the user's home directory for UI files
    (bin/"bdc-cli").write <<~EOS
      #!/bin/bash
      
      # Create user home directory for bdc-cli if it doesn't exist
      USER_BDC_DIR="${HOME}/.bdc-cli"
      USER_UI_DIR="${USER_BDC_DIR}/ui"
      
      if [ ! -d "${USER_UI_DIR}" ]; then
        mkdir -p "${USER_UI_DIR}"
        echo "Setting up BDC CLI for first use..."
        
        # Copy all the UI files
        cp -R "#{libexec}/ui-files/"* "${USER_UI_DIR}/"
        
        # Copy hidden files and directories
        if [ -d "#{libexec}/ui-files/.next" ]; then
          mkdir -p "${USER_UI_DIR}/.next"
          cp -R "#{libexec}/ui-files/.next/"* "${USER_UI_DIR}/.next/"
        fi
        
        # Install dependencies
        echo "Installing Node.js dependencies..."
        cd "${USER_UI_DIR}"
        npm install --quiet
      fi
      
      # Set environment variable to point to user's UI directory
      export BDC_UI_PATH="${USER_UI_DIR}"
      
      # Execute the main binary
      exec "#{libexec}/bdc-cli-bin" "$@"
    EOS
    
    # Ensure the script is executable
    chmod 0755, bin/"bdc-cli"

    # Install UI files to a temporary location in libexec
    mkdir_p "#{libexec}/ui-files"
    
    cd "ui" do
      system "npm", "install"
      system "npm", "run", "build"
      
      # Copy all UI files to the temporary location
      cp_r ".next/.", "#{libexec}/ui-files/.next"
      cp_r "public/.", "#{libexec}/ui-files/public"
      cp_r "src/.", "#{libexec}/ui-files/src"
      cp "package.json", "#{libexec}/ui-files/"
      cp "next.config.js", "#{libexec}/ui-files/"
      cp "tsconfig.json", "#{libexec}/ui-files/"
      cp "tailwind.config.js", "#{libexec}/ui-files/"
      cp "postcss.config.js", "#{libexec}/ui-files/"
      cp "next-env.d.ts", "#{libexec}/ui-files/"
      cp "components.json", "#{libexec}/ui-files/"
    end
    
    # Create a default configuration file
    (etc/"bdc-cli.conf").write <<~EOS
      {
        "ui_path": "${HOME}/.bdc-cli/ui"
      }
    EOS
  end

  test do
    system "#{bin}/bdc-cli", "version"
  end
end 