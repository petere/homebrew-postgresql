class Postgresql91 < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/source/v9.1.15/postgresql-9.1.15.tar.bz2"
  sha256 "67d6deaf15cdc35fcdff2c319234d0577a86bce6f363e4f0e4e987e419e0de5f"

  bottle do
    root_url "https://github.com/petere/homebrew-postgresql/releases/download/bottles-201502150"
    sha1 "52bff3967a898ba015fe8f26c62e039e5f58a1cf" => :yosemite
    sha1 "5626d9c69ec3a7573d57cd217c875893a245e3b1" => :mavericks
  end

  head do
    url "http://git.postgresql.org/git/postgresql.git", :branch => "REL9_1_STABLE"

    depends_on "petere/sgml/docbook-dsssl" => :build
    depends_on "petere/sgml/docbook-sgml" => :build
    depends_on "petere/sgml/openjade" => :build
  end

  option "enable-cassert", "Enable assertion checks (for debugging)"

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

    args << "--enable-cassert" if build.include? "enable-cassert"

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
