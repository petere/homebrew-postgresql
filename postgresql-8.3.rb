class Postgresql83 < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/source/v8.3.23/postgresql-8.3.23.tar.bz2"
  sha256 "17a46617ddbeb16f37d79b43f4e72301b051e6ef888a2eac960375bf579018d9"
  head "http://git.postgresql.org/git/postgresql.git", :branch => "REL8_3_STABLE"

  bottle do
    root_url "https://github.com/petere/homebrew-postgresql/releases/download/bottles-201502270"
    sha1 "5e308ce85a83a0887b40036f4942debf9a7f313f" => :yosemite
    sha1 "b86d4a589ba32ac7872e27aae56c2f0d449352f1" => :mavericks
  end

  option "enable-cassert", "Enable assertion checks (for debugging)"

  keg_only "The different provided versions of PostgreSQL conflict with each other."

  env :std

  depends_on "homebrew/dupes/openldap"
  depends_on "openssl"
  depends_on "ossp-uuid"
  depends_on "readline"
  depends_on "homebrew/dupes/tcl-tk"

  # Fix PL/Python build: https://github.com/mxcl/homebrew/issues/11162
  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  patch :DATA

  def install
    ENV.enable_warnings

    args = ["--prefix=#{prefix}",
            "--mandir=#{man}",
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
            "--with-tcl"]

    args << "--enable-cassert" if build.include? "enable-cassert"

    system "./configure", *args
    system "make install"
    system "make -C contrib install"
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
