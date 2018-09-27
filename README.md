Homebrew PostgreSQL things
==========================

These formulae allow installing multiple versions of PostgreSQL in parallel.  This is similar to what you can do on certain Linux distributions, for example Debian.

When installing a formulae, specify the full name:

- `brew install petere/postgresql/postgresql@9.6`
- `brew install petere/postgresql/postgresql@10`
- `brew install petere/postgresql/postgresql-common`
- `brew install petere/postgresql/<formula>`

Or use `brew tap-pin petere/postgresql`.

[![Build Status](https://travis-ci.org/petere/homebrew-postgresql.svg?branch=master)](https://travis-ci.org/petere/homebrew-postgresql)

Details
-------

Since PostgreSQL major releases have incompatible data directories and other occasional incompatibilities, it is useful for many developers to keep several major versions installed in parallel for development, testing, and production.  So far, Homebrew had inconsistent support for that and did not provide the full range of supported major versions.  This tap provides versioned formulae named `postgresql@9.5`, `postgresql@9.6`, etc. that you can install in parallel.  Technically, these are "keg-only", which has the nice side effect that they are automatically installed in side-by-side directories `/usr/local/opt/postgresql@9.6/` etc.

To use the programs installed by these formulae, do one or more of the following, in increasing order of preference:

- Call all programs explicitly with `/usr/local/opt/postgresql@9.6/bin/...`.  This will be boring in the long run.
- Add your preferred `/usr/local/opt/postgresql@x.y/bin` etc. to your path.  Preferably to the front, to come before the operating system's PostgreSQL installation.  This will work alright, but depending on your setup, it might be difficult to get everything on the OS to see the same path.
- `brew link -f` the `postgresql@x.y` formula you prefer to use.
- Install the `postgresql-common` package (see below).

The versioned formulae can be installed alongside the main `postgresql` formula in Homebrew.  But there will be a conflict if you do `brew link -f` or install `postgresql-common`, so in those cases you have to uninstall the main `postgresql` package first.  This is not a problem, however, because the versioned packages provide the same functionality.

Build options
-------------

The standard `postgresql` formula in Homebrew is missing a number of build options and also has a number of build options that I find useless.  These formulae enable all `configure` options that macOS can support, but also remove a number of Homebrew-level build options, to reduce complexity.  I have also dropped supported for legacy macOS concerns, such as 32-bit Intel and PowerPC and really old macOS releases.  Mainly because I can't test that anymore, YMMV.

postgresql-common cluster manager
---------------------------------

`postgresql-common` is a port of the postgresql-common package from Debian, which contains programs that help manage these multiple versioned installations, and programs to manage multiple PostgreSQL instances (clusters).  The port a bit experimental, but it works.

See `/usr/local/opt/postgresql-common/README.Debian` to get started.  If you have used Debian or Ubuntu before, you'll feel right at home (I hope).

The general idea is that for server-side operations you use the special wrapper scripts `pg_createcluster`, `pg_dropcluster`, `pg_ctlcluster`, and `pg_lsclusters` instead of `initdb` and `pg_ctl`.  The scripts take version numbers and instance names (which map to directory names).  For example:

    pg_createcluster 9.6 test
    pg_ctlcluster 9.6 test start

See the respective man pages for details.

For client-side operations, to usual tools such as `psql` and `pg_dump` are wrapped to automatically use the right version for the instance they are connecting to, so you usually don't need to do anything special.  See the man page `pg_wrapper` for details.

Extensions
----------

To install extensions, I recommend
[Pex](https://github.com/petere/pex).  It has support for multiple
PostgreSQL installations and can easily support to the installation
scheme used by these packages.  Example:

    pex -g /usr/local/opt/postgresql@9.6 install ip4r
