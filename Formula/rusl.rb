class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.6.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.5/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "7066280f29c697d78a453b696781069e6fc27ceae9552cc71518fc86045a14d6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.5/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "f42f0b7172533c7f504d3721239fd05885e327d93f118056033c512871368f14"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.5/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "41fe16aa0b67d7898b2b1a58a6ec73357b0546b1eef03d22aac1c54e39df5c26"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.5/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66bb41f05077be008bfc02c60a3465a52b6e5411bcea336994977fbbc455e796"
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
