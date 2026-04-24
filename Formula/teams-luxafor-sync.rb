class TeamsLuxaforSync < Formula
  desc "Sync Luxafor LED color with Microsoft Teams presence on macOS"
  homepage "https://github.com/jonasrappy/teams-luxafor-presence-sync"
  version "0.2.5"
  license "MIT"
  depends_on :macos

  if Hardware::CPU.arm?
    url "https://github.com/jonasrappy/teams-luxafor-presence-sync/releases/download/v0.2.5/teams-luxafor-sync_darwin_arm64.tar.gz"
    sha256 "ff59523ac3d147521a561d9b1223dc5f7f18016d401fe660c0d4716d5513ac60"
  else
    url "https://github.com/jonasrappy/teams-luxafor-presence-sync/releases/download/v0.2.5/teams-luxafor-sync_darwin_amd64.tar.gz"
    sha256 "cdf402c0d8a26f5dd956b563818498e5d215822ee31b1bcaf10c1853084eb01e"
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
      POLL_MS:                 "300",
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
