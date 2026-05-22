class Rusl < Formula
  desc "The Rusl schema package manager CLI."
  homepage "https://github.com/rusl-labs/rusl-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.0/rusl-aarch64-apple-darwin.tar.xz"
      sha256 "c540da719c1141b44560b747ba6bc8bb77b2dce2591b16af4734abbcd7ca26b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.0/rusl-x86_64-apple-darwin.tar.xz"
      sha256 "0dd62fcf0ae92574469e562ad5f1ab4dad635e6595f2958403d33cb519aaa925"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.0/rusl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "642226789ff1b2c746de572c5864a636b3860570eec36a44bcc14771d296b959"
    end
    if Hardware::CPU.intel?
      url "https://github.com/rusl-labs/rusl-cli/releases/download/v0.1.0/rusl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3da0f7921d436bba108ee8fb44f6cd6be4a0d9cd88d260ba53befcb61679081e"
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
