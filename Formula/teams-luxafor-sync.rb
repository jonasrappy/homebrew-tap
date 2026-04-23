class TeamsLuxaforSync < Formula
  desc "Sync Luxafor LED color with Microsoft Teams presence on macOS"
  homepage "https://github.com/jonasrappy/teams-luxafor-presence-sync"
  version "0.2.2"
  license "MIT"
  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/jonasrappy/teams-luxafor-presence-sync/releases/download/v0.2.2/teams-luxafor-sync_darwin_arm64.tar.gz"
    sha256 "a4aedde7e8051a9e5783fc959daabffd0d05b3311992da923ab98dafd101d858"
  else
    url "https://github.com/jonasrappy/teams-luxafor-presence-sync/releases/download/v0.2.2/teams-luxafor-sync_darwin_amd64.tar.gz"
    sha256 "6ea3a6e0f56dc1269af39e768789f53a15a0f058da05c1f18dbdbdfceb73bed8"
  end

  def install
    if Hardware::CPU.arm?
      bin.install "teams-luxafor-sync_arm64" => "teams-luxafor-sync"
    else
      bin.install "teams-luxafor-sync_amd64" => "teams-luxafor-sync"
    end
  end

  service do
    run [opt_bin/"teams-luxafor-sync"]
    keep_alive true
    log_path var/"log/teams-luxafor-sync.log"
    error_log_path var/"log/teams-luxafor-sync-error.log"
    environment_variables(
      POLL_MS:                 "3000",
      TAIL_BYTES:              "262144",
      FALLBACK_LOG_SCAN_COUNT: "5",
      REAPPLY_MS:              "15000",
    )
  end

  def caveats
    <<~EOS
      If Teams status does not sync, grant Full Disk Access to:
        #{opt_bin}/teams-luxafor-sync

      Then restart the service:
        brew services restart teams-luxafor-sync
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teams-luxafor-sync --version")
  end
end
