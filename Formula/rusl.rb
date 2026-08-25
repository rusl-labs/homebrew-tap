class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.6.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.4/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "a7ce0fdad400ed172136f224fa1e80f3e55d312589729a547a532ef718fdc900"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.4/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "31da3233c8e29fdfbfadac29be378c0f37bebe5752d37d0989f003ca0dfe7d51"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.4/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0e3857a7b833c32cafce86004c1d96c24c076ca6990dfa2d9f921bbb6833cc30"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.4/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "49c465760010385899eeec267be38fc630977294906e42a6c6fddb3421601c76"
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
