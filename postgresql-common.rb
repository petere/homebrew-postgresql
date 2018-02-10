class PostgresqlCommon < Formula
  desc "PostgreSQL database-cluster manager"
  homepage "https://packages.qa.debian.org/p/postgresql-common.html"
  version = "189+hb1"
  url "https://github.com/petere/postgresql-common/archive/#{version}.tar.gz"
  version version
  sha256 "8db9347cdecee81507dcd92d61c9f20f72d5ed4fac9a1a8afe93e75e9398bc84"

  head "https://github.com/petere/postgresql-common.git", :branch => "homebrew"

  depends_on "coreutils"
  depends_on "gnu-sed" => :build

  conflicts_with "postgresql",
    :because => "both install the same binaries."

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_bin
    ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"

    %w[Makefile PgCommon.pm].each do |f|
      inreplace f, "/usr/local/opt", HOMEBREW_PREFIX/"opt"
    end
    system "make", "install", "GSED=sed", "prefix=#{prefix}", "sysconfdir=#{etc}", "localstatedir=#{var}"
    prefix.install "debian/README.Debian", "architecture.html"

    (var/"lib/postgresql").mkpath
    (var/"log/postgresql").mkpath
  end

  test do
    system bin/"pg_lsclusters"
  end
end
