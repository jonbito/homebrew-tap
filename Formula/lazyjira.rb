class Lazyjira < Formula
  desc "A terminal-based user interface for JIRA"
  homepage "https://github.com/jonbito/lazyjira"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jonbito/lazyjira/releases/download/v0.2.0/lazyjira-aarch64-apple-darwin.tar.xz"
      sha256 "2148f0015d0d7942cf08350e5096fa3a22a21ef6a2e093523bea6e0107f26bdc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jonbito/lazyjira/releases/download/v0.2.0/lazyjira-x86_64-apple-darwin.tar.xz"
      sha256 "fb420b5b39192c311df0cb5d1eee2303ae74f2cca8818cf25408d1ade2e21419"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jonbito/lazyjira/releases/download/v0.2.0/lazyjira-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "d7aa86803889b5bb01f62dd0768998124cc5759d6676e474cebb909c44bde4e1"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-pc-windows-gnu":    {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "lazyjira" if OS.mac? && Hardware::CPU.arm?
    bin.install "lazyjira" if OS.mac? && Hardware::CPU.intel?
    bin.install "lazyjira" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
