use 5.008008;
use strict;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

use Config;

open my $f, '>', 'config.h' or die "cannot write config.h";

my $inc='-I'.$Config{archlibexp}.'/CORE -I..';

warn <<'EOF';
=====================================================================
== checking if the compiler supports atomic operations on IV values.
== you may see some warnings or error messages.
==
EOF
if(system 'cd util && gcc '.$inc.' -o x check.c && ./x') {
  print $f <<'EOF';
# undef HAVE_ATOMICS
# undef atomic_add
# undef atomic_sub
# ifdef __GNUC__
#   pragma message "  but unusable long long atomics"
# endif
EOF
  warn <<'EOF';
==
== unavailable: your compiler does not support atomic IV operations
=====================================================================
EOF
} else {
  warn <<'EOF';
== success: your compiler supports atomic IV operations
=====================================================================
EOF
}
close $f;

WriteMakefile
  (
   NAME           => 'IPC::ScoreBoard',
   VERSION_FROM   => 'lib/IPC/ScoreBoard.pm', # finds $VERSION
   PREREQ_PM      => {
		      'File::Map' => 0.21,
		     }, # e.g., Module::Name => 1.1
   ABSTRACT_FROM  => 'lib/IPC/ScoreBoard.pm', # retrieve abstract from module
   AUTHOR         => 'Torsten Förtsch <torsten.foertsch@gmx.net>',
   dist           => {
		      COMPRESS => 'gzip -9f',
		      PREOP => './mk_README.sh',
		     },
   LIBS           => [''], # e.g., '-lm'
   DEFINE         => '', # e.g., '-DHAVE_SOMETHING'
   INC            => '-I.', # e.g., '-I. -I/usr/include/other'
   # Un-comment this if you add C files to link with later:
   # OBJECT       => '$(O_FILES)', # link all the C files too
  );

sub MY::postamble {
  return <<'EOF';
rpm: dist
	$(PERL) -i -pe 's/^(Version:\s*).*/$${1}$(VERSION)/' perl-IPC-ScoreBoard.spec
	rpmbuild -ba perl-IPC-ScoreBoard.spec
EOF
}
