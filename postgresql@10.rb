class PostgresqlAT10 < Formula
  desc "Relational database management system"
  homepage "https://www.postgresql.org/"

  devel do
    version = "10beta3"
    version version
    url "https://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2"
    sha256 "6722546739f8e2dd379e8031784e86c5c588638df6c477046ebdd479586bcb3e"
  end

  head do
    url "https://git.postgresql.org/git/postgresql.git", :branch => "REL_10_STABLE"

    depends_on "open-sp" => :build
    depends_on "petere/sgml/docbook-sgml" => :build
  end

  keg_only :versioned_formula

  deprecated_option "enable-cassert" => "with-cassert"
  option "with-cassert", "Enable assertion checks (for debugging)"

  depends_on "pkg-config" => :build

  depends_on "e2fsprogs"
  depends_on "gettext"
  depends_on "openldap"
  depends_on "icu4c"
  depends_on "openssl"
  depends_on "readline"
  depends_on "tcl-tk"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-dtrace
      --enable-nls
      --with-bonjour
      --with-gssapi
      --with-icu
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-openssl
      --with-uuid=e2fs
      --with-pam
      --with-perl
      --with-python
      --with-tcl
      XML2_CONFIG=:
    ]

    # Add include and library directories of dependencies, so that
    # they can be used for compiling extensions.  Superenv does this
    # when compiling this package, but won't record it for pg_config.
    deps = %w[gettext icu4c openldap openssl readline tcl-tk]
    with_includes = deps.map { |f| Formula[f].opt_include }.join(":")
    with_libraries = deps.map { |f| Formula[f].opt_lib }.join(":")
    args << "--with-includes=#{with_includes}"
    args << "--with-libraries=#{with_libraries}"

    args << "--enable-cassert" if build.with? "cassert"
    args << "--with-extra-version=+git" if build.head?

    system "./configure", *args
    system "make", "install-world"
  end

  def caveats; <<-EOS.undent
    To use this PostgreSQL installation, do one or more of the following:

    - Call all programs explicitly with #{opt_prefix}/bin/...
    - Add #{opt_bin} to your PATH
    - brew link -f #{name}
    - Install the postgresql-common package

    To access the man pages, do one or more of the following:
    - Refer to them by their full path, like `man #{opt_share}/man/man1/psql.1`
    - Add #{opt_share}/man to your MANPATH
    - brew link -f #{name}
    EOS
  end

  test do
    system "#{bin}/initdb", "pgdata"
  end
end
