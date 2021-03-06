use 5.008000;
use Getopt::Long;
use ExtUtils::CppGuess;
use ExtUtils::MakeMaker;

# TIP: use `dmake -P#jobs` on windows

# See lib/ExtUtils/MakeMaker.pm for details of how to
# influence content of the Makefile that is written.

use strict;
use warnings;

my $debugmode = 0;
my $compiler = undef;

# arrays for various switches
my (@libs, @flags, @defs, @incs);

# start by adding the main incs
push @incs, 'deps/srcmap/src',
            'deps/srcmap/deps/json',
            'deps/srcmap/deps/cencode';

GetOptions(
	'--compiler:s' => \$compiler,
	'--build-debug' => \$debugmode,
);

warn "Use <$compiler> as compiler" if $compiler;
die "Debug is not yet implemented" if $debugmode;

my $guess = ExtUtils::CppGuess->new(
	(defined($compiler) ? (cc => $compiler) : ()),
);

if ($guess->is_gcc) { print "Detected gcc compiler...\n"; }
elsif ($guess->is_msvc) { print "Detected MSVC compiler...\n"; }
else { print "Unknown compiler, trying anyway...\n"; }

# set c++11 flags
if ($guess->is_gcc) {
	# push @flags, '-xc++'; # also from CppGuess
	# need version which is not given via CppGuess
	my $gcc_version = `$guess->{cc} --version`;
	if ($gcc_version =~m/([4-9]\d*)\.(\d+)\.(\d+)/) {
		if ($1 >= 4 && $2 >= 7) {
			push @defs, "USE_STD_SHARED_PTR";
			push @flags, '-std=c++0x';
		}
		elsif ($1 >= 4 && $2 >= 4) {
			push @defs, "USE_STD_SHARED_PTR";
			push @flags, '-std=c++0x';
		}
		elsif ($1 == 4 && $2 >= 2) {
			push @defs, "USE_STD_TR1_SHARED_PTR";
			push @flags, '-std=gnu++0x';
		}
	}
# probably MSVC
} else {
	# fallback to more common tr1 implementation
	# not sure if that works, but try it anyways
	push @defs, "USE_STD_TR1_SHARED_PTR";
}

# add libgomp for performance timings
push @libs, '-lgomp' if ($guess->is_gcc);

# not sure why this does not work otherwise
push @flags, '-o $*.o' if ($guess->is_gcc);

# add our custom compiler flags to CppGuess
$guess->add_extra_linker_flags(join(' ', @libs));
$guess->add_extra_compiler_flags(join(' ', @flags));

# get the compiler flags generated by CppGuess
my %compiler_flags = $guess->makemaker_options();

# remove c++ flag (only needed for cpp files)
# $compiler_flags{'CCFLAGS'} =~ s/\-xc\+\+//g;

# cleanup some unnecessary whitespace
$compiler_flags{'CCFLAGS'} =~ s/^\s+//g;
$compiler_flags{'CCFLAGS'} =~ s/\s+$//g;
$compiler_flags{'CCFLAGS'} =~ s/\s+/ /g;

WriteMakefile(
	LICENSE            => 'perl',
	NAME               => 'OCBNET::SourceMap::XS',
	VERSION_FROM       => 'lib/OCBNET/SourceMap/XS.pm',
	ABSTRACT_FROM      => 'lib/OCBNET/SourceMap/XS.pm',
	AUTHOR             => q{Marcel Greter <perl-libsass@ocbnet.ch>},
	# runtime dependencies
	PREREQ_PM          => {
		'perl'                  => 5.008000,
		'Carp'                  => 1.01,
		'version'               => 0,
		'warnings'              => 0,
		'strict'                => 0,
	},
	# build dependencies
	BUILD_REQUIRES     => {
		'Getopt::Long'         => 0.01,
		'ExtUtils::CppGuess'   => 0.09,
		'ExtUtils::MakeMaker'  => 6.52,
	},
	# test dependencies
	# TEST_REQUIRES      => { },
	# config dependencies (???)
	CONFIGURE_REQUIRES => {
		'Getopt::Long'         => 0.01,
		'ExtUtils::CppGuess'   => 0.09,
		'ExtUtils::MakeMaker'  => 6.52,
	},
	# options are set by CppGuess
	# LIBS               => [''],
	# CCFLAGS            => '',
	$guess->makemaker_options(),
	# LDDLFLAGS          => '',
	INC                => join(" ", map { sprintf '-I%s', $_ } @incs),
	DEFINE             => join(" ", map { sprintf '-D%s', $_ } @defs),
	OBJECT             => [
	                        'deps/srcmap/src/document.o',
	                        'deps/srcmap/src/mappings.o',
	                        'deps/srcmap/src/map_line.o',
	                        'deps/srcmap/src/map_col.o',
	                        'deps/srcmap/src/pos_idx.o',
	                        'deps/srcmap/src/pos_txt.o',
	                        'deps/srcmap/src/format/v3.o',
	                        'deps/srcmap/deps/json/json.o',
	                        'deps/srcmap/deps/cencode/cdecode.o',
	                        'deps/srcmap/deps/cencode/cencode.o',
	                        '$(O_FILES)'
	                      ],
	TYPEMAPS           => [
	                        'xsh/sourcemap.map'
	                      ],
);
