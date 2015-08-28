class Postgresql94 < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/source/v9.4.4/postgresql-9.4.4.tar.bz2"
  sha256 "538ed99688d6fdbec6fd166d1779cf4588bf2f16c52304e5ef29f904c43b0013"

  bottle do
    root_url "https://github.com/petere/homebrew-postgresql/releases/download/bottles-201506260"
    sha256 "c69237fb58e1dd54c2ae1749ac0dfb6df69955377f317d39e2e985c3ea0db572" => :yosemite
    sha256 "1a947bad02c37768951ef5f12405be8a5c65e7e0506d09aaede86f43981ad27d" => :mavericks
  end

  head do
    url "http://git.postgresql.org/git/postgresql.git", :branch => "REL9_4_STABLE"

    depends_on "open-sp" => :build
    depends_on "petere/sgml/docbook-dsssl" => :build
    depends_on "petere/sgml/docbook-sgml" => :build
    depends_on "petere/sgml/openjade" => :build
  end

  option "enable-cassert", "Enable assertion checks (for debugging)"

  keg_only "The different provided versions of PostgreSQL conflict with each other."

  env :std

  depends_on "e2fsprogs"
  depends_on "gettext"
  depends_on "homebrew/dupes/openldap"
  depends_on "openssl"
  depends_on "readline"
  depends_on "homebrew/dupes/tcl-tk"

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

    args << "--enable-cassert" if build.include? "enable-cassert"
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
