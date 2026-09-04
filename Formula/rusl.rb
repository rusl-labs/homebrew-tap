class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.6.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.6/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "62689296344f059011919060c9602bc7d67e9c14463cc0bb52240db05830cde9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.6/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "6e9eb590f51a9ae4a41df7a393fdd0be266fc2885573442f3e443a74cb3fa6a2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.6/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "85368b78282b6c93252c7f77c2a0d0eb9b28a523cc85f2ad53aaa9762eb66437"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.6.6/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ee79363edbf522987842327e25b01b66f78089b694584d8af40efc99e2efbebf"
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
