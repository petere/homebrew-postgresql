require 'formula'

class Postgresql94 < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.4.0/postgresql-9.4.0.tar.bz2'
  sha256 '7a35c3cb77532f7b15702e474d7ef02f0f419527ee80a4ca6036fffb551625a5'

  head do
    url 'http://git.postgresql.org/git/postgresql.git', :branch => 'REL9_4_STABLE'

    depends_on 'petere/sgml/docbook-dsssl' => :build
    depends_on 'petere/sgml/docbook-sgml' => :build
    depends_on 'petere/sgml/openjade' => :build
  end

  option 'disable-assertions', 'Speeds up PostgreSQL but skips tests valuable during development'

  keg_only 'The different provided versions of PostgreSQL conflict with each other.'

  env :std

  depends_on 'e2fsprogs'
  depends_on 'gettext'
  depends_on 'openssl'
  depends_on 'readline'

  def install
    args = ["--prefix=#{prefix}",
            "--enable-dtrace",
            "--enable-nls",
            "--with-bonjour",
            "--with-gssapi",
            "--with-ldap",
            "--with-libxml",
            "--with-libxslt",
            "--with-openssl",
            "--with-uuid=e2fs",
            "--with-pam",
            "--with-perl",
            "--with-python",
            "--with-tcl"]

    args << "--enable-cassert" unless build.include? "disable-assertions"
    args << "--with-extra-version=+git" if build.head?

    system "./configure", *args
    system "make install-world"
  end

  def caveats; <<-EOS.undent
    To use this PostgreSQL installation, do one or more of the following:

    - Call all programs explicitly with #{opt_prefix}/bin/...
    - Add #{opt_prefix}/bin to your PATH
    - brew link -f #{name}
    - Install the postgresql-common package
    EOS
  end

  test do
    system "#{bin}/initdb", "pgdata"
  end
end
