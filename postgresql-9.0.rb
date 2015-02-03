class Postgresql90 < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/source/v9.0.18/postgresql-9.0.18.tar.bz2"
  sha256 "7c8a07d0ab78fe39522c6bb268a7b357f456d9d4796f57d7b43a004e4a9d3003"

  head do
    url "http://git.postgresql.org/git/postgresql.git", :branch => "REL9_0_STABLE"

    depends_on "petere/sgml/docbook-dsssl" => :build
    depends_on "petere/sgml/docbook-sgml" => :build
    depends_on "petere/sgml/openjade" => :build
  end

  keg_only "The different provided versions of PostgreSQL conflict with each other."

  env :std

  depends_on "gettext"
  depends_on "openssl"
  depends_on "ossp-uuid"
  depends_on "readline"

  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  patch :DATA

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
