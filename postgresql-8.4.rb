class Postgresql84 < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/source/v8.4.22/postgresql-8.4.22.tar.bz2"
  sha256 "5c1d56ce77448706d9dd03b2896af19d9ab1b9b8dcdb96c39707c74675ca3826"
  head "http://git.postgresql.org/git/postgresql.git", :branch => "REL8_4_STABLE"

  devel do
    url "https://github.com/credativ/postgresql-lts/releases/download/REL8_4_22LTS5/postgresql-8.4.22lts5.tar.bz2"
    version "8.4.22lts5"
    sha256 "18522d6911e10c76236500114c728e4e9e741222b1f20384b5a96f0f7fc3efe5"
  end

  keg_only "The different provided versions of PostgreSQL conflict with each other."

  option "enable-cassert", "Enable assertion checks (for debugging)"

  depends_on "gettext"
  depends_on "homebrew/dupes/openldap"
  depends_on "openssl"
  depends_on "ossp-uuid"
  depends_on "readline"
  depends_on "homebrew/dupes/tcl-tk"

  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  patch :DATA

  def install
    args = ["--prefix=#{prefix}",
            "--enable-dtrace",
            "--enable-nls",
            "--enable-thread-safety",
            "--with-gssapi",
            "--with-krb5",
            "--with-ldap",
            "--with-libxml",
            "--with-libxslt",
            "--with-openssl",
            "--with-ossp-uuid",
            "--with-pam",
            "--with-perl",
            "--with-python",
            "--with-tcl",
           ]

    # Add include and library directories of dependencies, so that
    # they can be used for compiling extensions.  Superenv does this
    # when compiling this package, but won't record it for pg_config.
    deps = %w[gettext openldap openssl readline tcl-tk]
    with_includes = deps.map { |f| Formula[f].opt_include }.join(":")
    with_libraries = deps.map { |f| Formula[f].opt_lib }.join(":")
    args << "--with-includes=#{with_includes}"
    args << "--with-libraries=#{with_libraries}"

    args << "--enable-cassert" if build.include? "enable-cassert"

    system "./configure", *args
    system "make", "install"
    system "make", "-C", "contrib", "install"
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


__END__
--- a/contrib/uuid-ossp/uuid-ossp.c     2012-07-30 18:34:53.000000000 -0700
+++ b/contrib/uuid-ossp/uuid-ossp.c     2012-07-30 18:35:03.000000000 -0700
@@ -9,6 +9,8 @@
  *-------------------------------------------------------------------------
  */

+#define _XOPEN_SOURCE
+
 #include "postgres.h"
 #include "fmgr.h"
 #include "utils/builtins.h"
