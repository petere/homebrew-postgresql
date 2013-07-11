require 'formula'
require 'tmpdir'

class Postgresql93 < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/source/v9.3beta2/postgresql-9.3beta2.tar.bz2'
  version '9.3beta2'
  sha256 '67b4f1e8be622ab2f32b2a7823b3185052c93eae11c961214d87be76978f35ae'
  head 'http://git.postgresql.org/git/postgresql.git', :branch => 'REL9_3_STABLE'

  keg_only 'The different provided versions of PostgreSQL conflict with each other.'

  env :std

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
