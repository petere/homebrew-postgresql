Homebrew PostgreSQL things
==========================

These formulae allow installing multiple versions of PostgreSQL in parallel.  This is similar to what you can do on certain Linux distributions, for example Debian.

Just `brew tap petere/postgresql` and then `brew install <formula>`.

Details
-------

Since PostgreSQL major releases have incompatible data directories and other occasional incompatibilities, it is useful for many developers to keep several major versions installed in parallel for development, testing, and production.  So far, Homebrew did not support that (the bogus `postgresql8` and `postgresql9` formulae in `homebrew-versions` notwithstanding).  This tap provides versioned formulae named `postgresql-9.1`, `postgresql-9.2`, etc. that you can install in parallel.  Technically, these are "keg-only", which has the nice side effect that they are automatically installed in side-by-side directories `/usr/local/opt/postgresql-9.1/` etc.  You can just call the programs directly from those directories, or adjust your path to your liking.

The versioned formulae can be installed alongside the main `postgresql` formula in Homebrew.

Build options
-------------

The standard `postgresql` formula in Homebrew is missing a number of build options and also has a number of build options that I find useless.  These formulae enable all `configure` options that OS X can support, but also remove a number of Homebrew-level build options, to reduce complexity.  I have also dropped supported for legacy OS X concerns, such as 32-bit Intel and PowerPC and really old OS X releases.  Mainly because I can't test that anymore, YMMV.

postgresql-common cluster manager
---------------------------------

This is a port of the postgresql-common package from Debian, which contains programs that help manage these multiple versioned installations, and programs to manage multiple PostgreSQL instances (clusters).  This is highly experimental, but it works.

See `/usr/local/Cellar/postgresql-common/HEAD/README.Debian` to get started.  If you have used Debian or Ubuntu before, you'll feel right at home (I hope).  If you haven't, this will be really confusing, so good luck. :smirk:
