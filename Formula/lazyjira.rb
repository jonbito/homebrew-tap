class Lazyjira < Formula
  desc "A terminal-based user interface for JIRA"
  homepage "https://github.com/jonbito/lazyjira"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jonbito/lazyjira/releases/download/v0.1.0/lazyjira-aarch64-apple-darwin.tar.xz"
      sha256 "6055bc1d279b4658d9edb456cc1906a0d7cfc46bd1b450761168145af79683c0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jonbito/lazyjira/releases/download/v0.1.0/lazyjira-x86_64-apple-darwin.tar.xz"
      sha256 "2f2185075a072a4ad733b42d8bf043fda7f978604f8588d742421a5f6170e020"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/jonbito/lazyjira/releases/download/v0.1.0/lazyjira-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "f9fdd8dd82b925b0a4addf2187db791653abec490f8ded009ba39c03015ccecb"
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
