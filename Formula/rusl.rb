class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.3.0/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "1b5afa1a11f45180dddf3a21f27d921218e48b995b2e2912ccad4abc95dc6261"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.3.0/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "76a173910af14ebc8f9129e04e4dab9b00b6fb3e9396998711af8b5edfe79bcd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.3.0/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "03ccbe4bab634f6c5f0bb6da170a0adee67db53c2ee892fe7f812cf4daac9c1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.3.0/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4966b3e1c36106fbb1543a85ae49f635a747c4886dfe6a21e809af29e9544a5b"
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
