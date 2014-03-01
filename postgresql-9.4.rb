require 'formula'
require 'tmpdir'

class Postgresql94 < Formula
  homepage 'http://www.postgresql.org/'
  head 'http://git.postgresql.org/git/postgresql.git'

  keg_only 'The different provided versions of PostgreSQL conflict with each other.'

  env :std

  depends_on 'gettext'
  depends_on 'ossp-uuid'
  depends_on 'readline'
  depends_on 'tcl-tk' if MacOS.version >= :mavericks

  def patches
    [
     # Fix uuid-ossp build issues
     DATA,  # http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
     'http://www.postgresql.org/message-id/attachment/32317/configure-uuid.patch',
    ]
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
    # XXX Can't build docs using Homebrew-provided software, so skip
    # it when building from Git.
    system "make install"
    system "make -C contrib install"
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
