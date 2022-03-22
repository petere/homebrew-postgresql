class PostgresqlAT12 < Formula
  desc "Relational database management system"
  homepage "https://www.postgresql.org/"
  version = "12.10"
  url "https://ftp.postgresql.org/pub/source/v#{version}/postgresql-#{version}.tar.bz2"
  sha256 "83dd192e6034951192b9a86dc19cf3717a8b82120e2f11a0a36723c820d2b257"
  license "PostgreSQL"

  livecheck do
    url "https://ftp.postgresql.org/pub/source/"
    regex(%r{href=["']?v?(12(?:\.\d+)*)/?["' >]}i)
  end

  head do
    url "https://git.postgresql.org/git/postgresql.git", branch: "REL_12_STABLE"

    depends_on "docbook-xsl" => :build
  end

  keg_only :versioned_formula

  option "with-cassert", "Enable assertion checks (for debugging)"
  deprecated_option "enable-cassert" => "with-cassert"

  # https://www.postgresql.org/support/versioning/
  deprecate! date: "2024-11-14", because: :unsupported

  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "icu4c"
  depends_on "openldap"
  depends_on "openssl@1.1"
  depends_on "python@3"
  depends_on "readline"
  depends_on "tcl-tk"
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
      --with-openssl
      --with-uuid=e2fs
      --with-pam
      --with-perl
      --with-python
      --with-tcl
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

  service do
    run [opt_bin/"postgres", "-D", var/"postgresql@12"]
    keep_alive true
    log_path var/"log/postgresql@12.log"
    error_log_path var/"log/postgresql@12.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/initdb", "pgdata"
  end
end
