# Written by scripts/packaging/render_formula.py (repository
# habhabhabs/inventag-aws) from the SHA256SUMS file of a release. Do not edit
# it by hand: the next release writes it again.
#
# It installs the executable that the release workflow builds, a directory made
# by PyInstaller that brings its own runtime. Nothing is compiled and nothing
# but the archive is downloaded.
#
# The executable bundles GNU libiconv inside lxml under LGPL-2.1. The notices
# file THIRD-PARTY-LICENSES.txt in the archive names where its source is.
class Inventag < Formula
  desc "Read-only AWS inventory, tag checks and BOM reports"
  homepage "https://habhabhabs.github.io/inventag-aws/"
  license "MIT"

  on_macos do
    # Only the Apple Silicon archive exists. brew style wants url and sha256
    # inside on_arm or on_intel. An Intel Mac gets the same archive declared so
    # that the formula loads; install then stops with a message on its first line.
    on_arm do
      url "https://github.com/habhabhabs/inventag-aws/releases/download/v1.4.0/inventag-1.4.0-darwin-arm64.tar.gz"
      sha256 "80be98fe23c72737fa4b8cbaa92bbe10d6564f9c2f1262782d9017b191cff9ca"
    end
    on_intel do
      url "https://github.com/habhabhabs/inventag-aws/releases/download/v1.4.0/inventag-1.4.0-darwin-arm64.tar.gz"
      sha256 "80be98fe23c72737fa4b8cbaa92bbe10d6564f9c2f1262782d9017b191cff9ca"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/habhabhabs/inventag-aws/releases/download/v1.4.0/inventag-1.4.0-linux-x86_64.tar.gz"
      sha256 "ccac5a93e66441228066dacf19687be1e45bacdefb942ad16165ad46b1e1147e"
    end
    on_arm do
      url "https://github.com/habhabhabs/inventag-aws/releases/download/v1.4.0/inventag-1.4.0-linux-arm64.tar.gz"
      sha256 "280e253cb7bb9585210f33efad8e3c26604bc26d2b60da066c8a4c760637b6b7"
    end
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      odie "There is no executable for Intel Macs: a library InvenTag needs " \
           "(cryptography, from version 50) publishes no ready-made build for them. " \
           "Other ways to install are on " \
           "https://habhabhabs.github.io/inventag-aws/docs/getting-started/installation"
    end

    libexec.install Dir["*"]
    bin.install_symlink libexec/"inventag"
    bash_completion.install libexec/"share/completions/inventag.bash" => "inventag"
    zsh_completion.install libexec/"share/completions/_inventag"
    fish_completion.install libexec/"share/completions/inventag.fish"
    man1.install libexec/"share/man/man1/inventag.1"
  end

  def caveats
    <<~EOS
      Third-party licences: see THIRD-PARTY-LICENSES.txt in the installation directory
    EOS
  end

  test do
    assert_match "inventag #{version}", shell_output("#{bin}/inventag --version")
    system bin/"inventag", "selftest"
  end
end
