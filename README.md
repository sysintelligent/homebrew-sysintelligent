# Sysintelligent Homebrew Tap

This is an internal Homebrew tap for our organization's tools.

## Usage

First, add this tap to your Homebrew installation:

```bash
brew tap sysintelligent/sysintelligent
```

Then you can install any of our internal tools using:

```bash
brew install sysintelligent/sysintelligent/[tool-name]
```

## Available Tools

- `dopctl`: A tool for managing DevOps operations and infrastructure
  - Install with: `brew install sysintelligent/sysintelligent/dopctl`
  - Version: 1.0.2
  - Dependencies: go, node, npm

## Contributing

To add a new formula:

1. Create a new Ruby file in the `Formula` directory
2. Write the formula following Homebrew's guidelines
3. Test the formula locally
4. Submit a pull request

### Git Configuration

This repository includes a `.gitignore` file that excludes common system files:
- macOS system files (`.DS_Store`, `.Spotlight-V100`, etc.)
- Windows system files (`Thumbs.db`, `ehthumbs.db`)

These files are excluded to keep the repository clean and prevent unnecessary system-specific files from being committed.

## Formula Structure

Each formula is a Ruby file that describes how to install a package. Here's the basic structure:

```ruby
class ToolName < Formula
  desc "Short description of the tool"
  homepage "https://github.com/sysintelligent/tool-name"
  url "https://github.com/sysintelligent/tool-name/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "PACKAGE_SHA256_CHECKSUM"
  license "MIT"  # or appropriate license

  # Dependencies
  depends_on "dependency1"
  depends_on "dependency2" => :build  # Only needed at build time

  def install
    # Installation commands
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Test commands to verify installation
    system "#{bin}/tool-name", "--version"
  end
end
```

Key components:
- `desc`: A brief description of your tool
- `homepage`: URL to the tool's documentation or repository
- `url`: Download URL for the source code
- `sha256`: SHA-256 checksum of the source archive
- `depends_on`: List of dependencies
- `install`: Instructions for building and installing
- `test`: Commands to verify the installation

## Testing Formulae Locally

Before submitting a new formula or updating an existing one, test it locally:

### Testing a New Formula

```bash
# Test installation from the formula file
brew install --build-from-source ./Formula/tool-name.rb

# Verify the installation
brew test ./Formula/tool-name.rb

# Audit the formula for potential issues
brew audit --strict --online ./Formula/tool-name.rb
```

### Testing Formula Updates

```bash
# Remove existing installation
brew uninstall tool-name

# Install from the updated formula
brew install --build-from-source ./Formula/tool-name.rb

# Verify everything works
brew test ./Formula/tool-name.rb
```

### Getting SHA-256 for New Releases

When updating a formula to a new version, you'll need the SHA-256 of the new release:

```bash
curl -L <url> | shasum -a 256
```

## Maintenance

To update an existing formula:
1. Update the version and SHA in the formula file
2. Test the changes locally
3. Submit a pull request 