class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.6.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.7/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "6e9032de6c201e016f597706b372bcfc9082c566c452c2a6afa0394c11556a04"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.7/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "f4710da30052685ef7e345dcefd311de6b6e5c09bfc1b73e3a105deea94e4d91"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.7/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ce86c04c8023ed1e29e749bbd031641e650c99949374c90702eb08adcf908de7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.7/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ddf73e2f70448ee2a4b02c8289190a464060d2bf1bbef8900d06cc2e27c6519f"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "rusl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "rusl"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "rusl"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "rusl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
