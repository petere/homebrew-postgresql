require 'formula'

class PostgresqlCommon < Formula
  homepage 'http://packages.qa.debian.org/p/postgresql-common.html'
  #head 'https://github.com/petere/postgresql-common.git', :branch => 'homebrew'
  head '/Users/peisentraut/devel/github/postgresql-common/postgresql-common', :branch => 'homebrew', :using => :git

  conflicts_with 'postgresql',
    :because => 'both install the same binaries.'

  depends_on 'gnu-sed' => :build

  def install
    system "make", "install", "prefix=#{prefix}", "sysconfdir=#{etc}", "localstatedir=#{var}"
    prefix.install 'debian/README.Debian', 'architecture.html'
  end
end
