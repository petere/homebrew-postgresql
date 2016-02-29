class PostgresqlCommon < Formula
  desc "PostgreSQL database-cluster manager"
  homepage "http://packages.qa.debian.org/p/postgresql-common.html"
  head "https://github.com/petere/postgresql-common.git", :branch => "homebrew"

  conflicts_with "postgresql",
    :because => "both install the same binaries."

  depends_on "gnu-sed" => :build

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
