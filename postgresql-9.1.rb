require 'formula'
require 'tmpdir'

class Postgresql91 < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.1.9/postgresql-9.1.9.tar.bz2'
  sha1 '4cbbfc5be9b8e6fe3d67c5075c212bcb057eac20'
  head 'http://git.postgresql.org/git/postgresql.git', :branch => 'REL9_1_STABLE'

  keg_only 'The different provided versions of PostgreSQL conflict with each other.'

  env :std

  depends_on 'gettext'
  depends_on 'ossp-uuid'
  depends_on 'readline'

  # Fix PL/Python build: https://github.com/mxcl/homebrew/issues/11162
  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  def patches
    DATA
  end

  def install
    args = ["--prefix=#{prefix}",
            "--enable-dtrace",
            "--enable-nls",
            "--with-bonjour",
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

    system "./configure", *args
    if build.head?
      # XXX Can't build docs using Homebrew-provided software, so skip
      # it when building from Git.
      system "make install"
      system "make -C contrib install"
    else
      system "make install-world"
    end
  end

  def caveats; <<-EOS.undent
    To use this PostgreSQL installation, do one or more of the following:

    - Call all programs explicitly with #{opt_prefix}/bin/...
    - Add #{opt_prefix}/bin to your PATH
    - brew link -f #{name}
    - Install the postgresql-common package
    EOS
  end

  def test
    Dir.mktmpdir do |dir|
      system "#{bin}/initdb", "#{dir}/pgdata"
    end
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
