class PostgresqlAT15 < Formula
  desc "Relational database management system"
  homepage "https://www.postgresql.org/"
  version = "15.13"
  url "https://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2"
  version version
  sha256 "4f62e133d22ea08a0401b0840920e26698644d01a80c34341fb732dd0a90ca5d"
  license "PostgreSQL"

  head do
    url "https://git.postgresql.org/git/postgresql.git", branch: "REL_15_STABLE"

    depends_on "docbook-xsl" => :build
  end

  keg_only :versioned_formula

  option "with-cassert", "Enable assertion checks (for debugging)"
  deprecated_option "enable-cassert" => "with-cassert"

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2027-11-11", because: :unsupported

  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "icu4c"
  depends_on "lz4"
  depends_on "openldap"
  depends_on "openssl"
  depends_on "python@3"
  depends_on "readline"
  depends_on "tcl-tk"
  depends_on "zstd"
  depends_on "llvm" => :optional

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
      --with-lz4
      --with-openssl
      --with-uuid=e2fs
      --with-pam
      --with-perl
      --with-python
      --with-tcl
      --with-zstd
      PYTHON=python3
      XML2_CONFIG=:
    ]

    # Add include and library directories of dependencies, so that
    # they can be used for compiling extensions.  Superenv does this
    # when compiling this package, but won't record it for pg_config.
    deps = %w[gettext icu4c openldap openssl@1.1 readline tcl-tk]
    with_includes = deps.map { |f| Formula[f].opt_include }.join(":")
    with_libraries = deps.map { |f| Formula[f].opt_lib }.join(":")
    args << "--with-includes=#{with_includes}"
    args << "--with-libraries=#{with_libraries}"

    args << "--enable-cassert" if build.with? "cassert"
    args << "--with-llvm" if build.with? "llvm"

    extra_version = ""
    extra_version += "+git" if build.head?
    extra_version += " (Homebrew petere/postgresql)"
    args << "--with-extra-version=#{extra_version}"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", *args
    system "make", "install-world"
  end

  def caveats
    <<~EOS
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
