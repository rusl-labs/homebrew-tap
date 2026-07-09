class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.6.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.1/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "8b28025ec441344f17586a7997a3407187b9d78adb905a7011154e4ae33ead29"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.1/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "e50e1eef7794390253b23810d18433e390a76066d9373485d2f775d43e32a350"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.1/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f1c5b4016825ecfde0b9dd44f360e7ce1110264fd1ea14eb72a88a61812870bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.1/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ab1c80571319a1fa7911e8b0314f07f3712cc9712664b0b82416a7ed0c0f8f34"
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
