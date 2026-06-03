class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.1/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "833476541b39e342a09260c8fa286dcaccb265728d61330b6c8b0f5d520bff55"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.1/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "82ad11e6fa1112e237329615c0edcad4c33e3928ecd79d85165ec634e4a3a72f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.1/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9dc7f43400f39c94d43142ac1e8974b2199742c9c11a2f1be246185cffe9dc89"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.1/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4ac331028fb98cdff329d728a0c12e638f60c0c933a3c098805225e2498740b6"
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
