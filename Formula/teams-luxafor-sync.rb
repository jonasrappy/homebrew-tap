class TeamsLuxaforSync < Formula
  desc "Sync Luxafor LED color with Microsoft Teams presence on macOS"
  homepage "https://github.com/jonasrappy/teams-luxafor-presence-sync"
  url "https://github.com/jonasrappy/teams-luxafor-presence-sync/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b9bf8ac4f3d669c0d24a6a65a1a542828adefd9035f7e10813b5622c80a8575c"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/teams-luxafor-sync"
  end

  service do
    run [opt_bin/"teams-luxafor-sync"]
    keep_alive true
    log_path var/"log/teams-luxafor-sync.log"
    error_log_path var/"log/teams-luxafor-sync-error.log"
    environment_variables POLL_MS: "3000",
                          TAIL_BYTES: "262144",
                          FALLBACK_LOG_SCAN_COUNT: "5",
                          REAPPLY_MS: "15000"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teams-luxafor-sync --version")
  end
end
