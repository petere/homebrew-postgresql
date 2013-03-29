require 'formula'

class PostgresqlCommon < Formula
  homepage 'http://packages.qa.debian.org/p/postgresql-common.html'
  head 'http://bzr.debian.org/bzr/pkg-postgresql/postgresql-common/trunk/', :using => :bzr

  conflicts_with 'postgresql',
    :because => 'both install the same binaries.'

  depends_on 'gnu-sed' => :build

  def patches
    "https://github.com/petere/postgresql-common/compare/master...homebrew.patch"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
    prefix.install 'debian/README.Debian', 'architecture.html'
  end
end
