class TeamsLuxaforSync < Formula
  desc "Sync Luxafor LED color with Microsoft Teams presence on macOS"
  homepage "https://github.com/jonasrappy/teams-luxafor-presence-sync"
  license "MIT"
  version "0.2.1"

  on_arm do
    url "https://github.com/jonasrappy/teams-luxafor-presence-sync/releases/download/v0.2.1/teams-luxafor-sync_darwin_arm64.tar.gz"
    sha256 "795c5d1e6b6b81f32beb9b810a5f621c7a6b69100122c5b7fd9aba92c850b244"
  end

  on_intel do
    url "https://github.com/jonasrappy/teams-luxafor-presence-sync/archive/refs/tags/v0.2.1.tar.gz"
    sha256 "c6317222bd2232fbdd24ff11e08108bcc4269247b21841e1c0d33d8fcc516bd5"
    depends_on "go" => :build
  end

  def install
    if Hardware::CPU.arm?
      bin.install "teams-luxafor-sync"
    else
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/teams-luxafor-sync"
    end
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
