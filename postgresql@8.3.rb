class PostgresqlAT83 < Formula
  desc "Relational database management system"
  homepage "https://www.postgresql.org/"
  url "https://ftp.postgresql.org/pub/source/v8.3.23/postgresql-8.3.23.tar.bz2"
  sha256 "17a46617ddbeb16f37d79b43f4e72301b051e6ef888a2eac960375bf579018d9"
  head "https://git.postgresql.org/git/postgresql.git", :branch => "REL8_3_STABLE"

  keg_only :versioned_formula

  option "with-cassert", "Enable assertion checks (for debugging)"
  deprecated_option "enable-cassert" => "with-cassert"

  depends_on "openldap"
  depends_on "ossp-uuid"
  depends_on "readline"
  depends_on "tcl-tk"

  # Fix PL/Python build: https://github.com/mxcl/homebrew/issues/11162
  # Fix uuid-ossp build issues: https://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-thread-safety
      --with-gssapi
      --with-krb5
      --with-ldap
      --with-libxml
      --with-libxslt
      --with-ossp-uuid
      --with-pam
      --with-perl
      --with-python
      --with-tcl
      XML2_CONFIG=:
    ]

    # Add include and library directories of dependencies, so that
    # they can be used for compiling extensions.  Superenv does this
    # when compiling this package, but won't record it for pg_config.
    deps = %w[openldap readline tcl-tk]
    with_includes = deps.map { |f| Formula[f].opt_include }.join(":")
    with_libraries = deps.map { |f| Formula[f].opt_lib }.join(":")
    args << "--with-includes=#{with_includes}"
    args << "--with-libraries=#{with_libraries}"

    args << "--enable-cassert" if build.with? "cassert"

    system "./configure", *args
    system "make", "install"
    system "make", "-C", "contrib", "install"
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


__END__
--- a/src/pl/plpython/Makefile  2011-09-23 08:03:52.000000000 +1000
+++ b/src/pl/plpython/Makefile  2011-10-26 21:43:40.000000000 +1100
@@ -24,8 +24,6 @@
 # Darwin (OS X) has its own ideas about how to do this.
 ifeq ($(PORTNAME), darwin)
 shared_libpython = yes
-override python_libspec = -framework Python
-override python_additional_libs =
 endif

 # If we don't have a shared library and the platform doesn't allow it
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
