class PostgresqlCommon < Formula
  desc "PostgreSQL database-cluster manager"
  homepage "https://packages.qa.debian.org/p/postgresql-common.html"
  version = "179+hb1"
  url "https://github.com/petere/postgresql-common/archive/#{version}.tar.gz"
  version version
  sha256 "ccd1d2593be5687fb0e4d3260fc2382bb5e7c7af38c339386fc08bb8c69f1f8d"

  head "https://github.com/petere/postgresql-common.git", :branch => "homebrew"

  depends_on "coreutils"
  depends_on "gnu-sed" => :build

  conflicts_with "postgresql",
    :because => "both install the same binaries."

  def install
    %w[Makefile PgCommon.pm].each do |f|
      inreplace f, "/usr/local/opt", HOMEBREW_PREFIX/"opt"
    end
    system "make", "install", "prefix=#{prefix}", "sysconfdir=#{etc}", "localstatedir=#{var}"
    prefix.install "debian/README.Debian", "architecture.html"

    (var/"lib/postgresql").mkpath
    (var/"log/postgresql").mkpath
  end

  test do
    system bin/"pg_lsclusters"
  end
end
