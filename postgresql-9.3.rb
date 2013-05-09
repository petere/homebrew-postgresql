require 'formula'
require 'tmpdir'

class Postgresql93 < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.3beta1/postgresql-9.3beta1.tar.bz2'
  version '9.3beta1'
  sha256 '1e11099fe4a6cd3327c9c2bf4a9b903383195de330da27d322fc872d1d694df1'

  keg_only 'The different provided versions of PostgreSQL conflict with each other.'

  depends_on 'gettext'
  depends_on 'ossp-uuid'
  depends_on 'readline'

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
    system "make install-world"
  end

  def test
    Dir.mktmpdir do |dir|
      system "#{bin}/initdb", "#{dir}/pgdata"
    end
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
