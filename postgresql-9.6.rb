class Postgresql96 < Formula
  homepage "http://www.postgresql.org/"

  head do
    url "http://git.postgresql.org/git/postgresql.git", :branch => "master"

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
