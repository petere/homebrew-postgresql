class Postgresql84 < Formula
  homepage "http://www.postgresql.org/"
  url "http://ftp.postgresql.org/pub/source/v8.4.22/postgresql-8.4.22.tar.bz2"
  sha256 "5c1d56ce77448706d9dd03b2896af19d9ab1b9b8dcdb96c39707c74675ca3826"
  head "http://git.postgresql.org/git/postgresql.git", :branch => "REL8_4_STABLE"

  bottle do
    root_url "https://github.com/petere/homebrew-postgresql/releases/download/bottles-201502270"
    sha1 "aae66b908d036de0cf017d805b230d6d9471a21e" => :yosemite
    sha1 "73a676e4b39c6a684679c039bff6140e69fc575e" => :mavericks
  end

  devel do
    url "https://github.com/credativ/postgresql-lts/releases/download/REL8_4_22LTS4/postgresql-8.4.22lts4.tar.bz2"
    version "8.4.22lts4"
    sha256 "e867d391cd2aeb083f4b98f384e433f1ba0e30cdb7cd0998f1112045da8361ae"
  end

  option "enable-cassert", "Enable assertion checks (for debugging)"

  keg_only "The different provided versions of PostgreSQL conflict with each other."

  env :std

  depends_on "gettext"
  depends_on "homebrew/dupes/openldap"
  depends_on "openssl"
  depends_on "ossp-uuid"
  depends_on "readline"
  depends_on "homebrew/dupes/tcl-tk"

  # Fix uuid-ossp build issues: http://archives.postgresql.org/pgsql-general/2012-07/msg00654.php
  patch :DATA

  def install
    ENV.enable_warnings

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
