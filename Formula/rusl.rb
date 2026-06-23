class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.3/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "096b6ca4d99227a6aa0c1036d4e1a976ffcacc05faf94b5a7f37cb858d70ba52"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.3/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "45e885be2e9dde866bdac1500f8b764c0d6b7e747166e3c7f0e197f8e7d44b5f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.3/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cdb486f8d971f86d28ce3e69a18eb6c1909818d7776172d58d8e5f960c6d84d4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.3/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fcb9180c97ad775b70d3674c56d34ff0c94003eb6780888c50631b67adcec649"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "rusl" if OS.mac? && Hardware::CPU.arm?
    bin.install "rusl" if OS.mac? && Hardware::CPU.intel?
    bin.install "rusl" if OS.linux? && Hardware::CPU.arm?
    bin.install "rusl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
