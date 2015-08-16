use 5.008000;

use strict;
use warnings;

use Cwd;
our $pwd;
use CPAN;
use Getopt::Long;

# TIP: use `dmake -P#jobs` on windows

my (@libs, @flags);
my $debugmode = 0;
my $force_preq = 0,
my $compiler = undef;

GetOptions(
        '--compiler:s' => \$compiler,
        '--build-debug' => \$debugmode,
        '--force-prereq' => \$force_preq,
);

# check for prerequisites
BEGIN
{
  $pwd = getcwd;
  sub check_preq ($)
  {
    my $flag = 0;
    my ($module) = @_;
    # eval "use $module;" && return;
    CPAN->has_usable($module) && return chdir $pwd;
    warn "Installing missing prerequisite: $module\n";
    unless ($force_preq) { CPAN::Shell->install($module); }
    else { CPAN::Shell->notest("install", $module); }
    # eval "use $module;" && return;
    CPAN->has_usable($module) && return chdir $pwd;
    warn "Missing prerequisite: $module\n";
    chdir $pwd; # change directory back
  }
  # install prerequisites
  check_preq("ExtUtils::XSpp");
  check_preq("ExtUtils::CppGuess");
  check_preq("ExtUtils::Typemaps::STL::String");
  check_preq("Panda::Install");
  check_preq("Panda::Lib");
  check_preq("Panda::XS");
}

use ExtUtils::CppGuess;
use ExtUtils::MakeMaker;
my $sourcemap_version = '[na]';

warn `ls -la`;
# Are we in our development tree?
# If so, create the MANIFEST file.
if (-d ".git") {
    my @modules = ('.');
    my $base = getcwd;
    my ($dir, $manifest);
    require File::Spec;
    print "Updating git submodules...\n";
    mkdir "deps" unless -d "deps";
    chdir 'deps';
    system "git submodule init";
    system "git submodule update";
    chdir '..';
    open $manifest, ">", "MANIFEST" or die "MANIFEST: $!";
    print $manifest "MANIFEST\n";
    print $manifest "deps/srcmap/VERSION\n";
    while (my $module = shift @modules)
    {
      my $cwd = getcwd;
      chdir ($module) or die "pushd: $!";
      my $files = `git ls-files` or die "Couldn't run git: $!";
      my @items = split(/\n+/, $files);
      my @files = grep { ! -d } @items;
      print $manifest
        map { tr/\\/\//; $_ . "\n" }
        map { File::Spec->abs2rel($_, $base) } @files;
      push @modules,
        map { File::Spec->catfile($module, $_) }
        grep { -d } @items;
      chdir ($cwd) or die "popd: $!";
    }
}

if (-e "deps/srcmap/.git" && ! -f "deps/srcmap/VERSION") {
  chdir "deps/srcmap";
  my $sourcemap_version = `git describe --abbrev=4 --dirty --always --tags`;
  chdir "../..";
  check_preq("File::Slurp");
  chomp $sourcemap_version;
  File::Slurp::write_file("deps/srcmap/VERSION", { 'binmode' => ':raw' }, $sourcemap_version);
}
if (-f "deps/srcmap/VERSION") {
  check_preq("File::Slurp");
  $sourcemap_version = File::Slurp::read_file("deps/srcmap/VERSION", { 'binmode' => ':raw' });
  print "Using sourcemap version $sourcemap_version\n";
}

my $guess = ExtUtils::CppGuess->new(
  (defined($compiler) ? (cc => $compiler) : ()),
);

if ($guess->is_gcc) { print "Detected gcc compiler...\n"; }
elsif ($guess->is_msvc) { print "Detected MSVC compiler...\n"; }
else { print "Unknown compiler, trying anyway...\n"; }
print "Prerequisites satisfied, working in ", getcwd, "\n";

# push @flags, '-xc++' if ($guess->is_gcc);
push @flags, '-std=c++0x' if ($guess->is_gcc);

# add libgomp for performance timings
push @libs, '-lgomp' if ($guess->is_gcc);

# not sure why this does not work otherwise
push @flags, '-o $*.o' if ($guess->is_gcc);

# now add our custom flags
$guess->add_extra_linker_flags(join(' ', @libs));
$guess->add_extra_compiler_flags(join(' ', @flags));

# fetch the original compiler flags
my %compiler_flags = $guess->makemaker_options();

# remove c++ flag (only needed for cpp files)
$compiler_flags{'CCFLAGS'} =~ s/\-xc\+\+//g;

# cleanup some unnecessary whitespace
$compiler_flags{'CCFLAGS'} =~ s/^\s+//g;
$compiler_flags{'CCFLAGS'} =~ s/\s+$//g;
$compiler_flags{'CCFLAGS'} =~ s/\s+/ /g;

use ExtUtils::Typemaps::STL::String;
# First, read my own type maps:
my $private_map = ExtUtils::Typemaps->new(file => 'xsh/sourcemap.map');
# Then, get the object map set and merge it into my maps
$private_map->merge(typemap => ExtUtils::Typemaps::STL::String->new);
# Now, write the combined map to an output file
$private_map->write(file => 'typemap');

# See lib/ExtUtils/MakeMaker.pm for details of how to
# influence content of the Makefile that is written.
# Also check lib/Panda/Install.pm for overloaded stuff.
use Panda::Install qw(makemaker_args);

WriteMakefile(makemaker_args(
    CPLUS              => 1,
    NAME               => 'OCBNET::SourceMap::XS',
    VERSION_FROM       => 'lib/OCBNET/SourceMap/XS.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    # runtime dependencies
    PREREQ_PM          => {
      # 'perl'                  => '5.008000',
      'Carp'                  => '1.01', # core as of 5.008
      'version'               => '0',
      'warnings'              => '0', # core as of 5.008
      'strict'                => '0', # core as of 5.008
    },
    # test dependencies (too new?)
    # TEST_REQUIRES      => {},
    # build dependencies
    BUILD_REQUIRES     => {
      'Panda::XS'            => '0.01',
      'File::Spec'           => '0.01',
      'File::Slurp'          => '0.01',
      'Getopt::Long'         => '0.01',
      'ExtUtils::XSpp'       => '0.01',
      'ExtUtils::CppGuess'   => '0.01',
    },
    # build dependencies
    # CONFIGURE_REQUIRES => {},
    MIN_PERL_VERSION   => '5.08.0', # required for GV_SUPER
    ABSTRACT_FROM      => 'lib/OCBNET/SourceMap/XS.pm', # retrieve abstract from module
    AUTHOR             => q{Marcel Greter <perl-libsass@ocbnet.ch>},
    LICENSE            => 'perl',
    # add options for CppGuess
    $guess->makemaker_options(),
    # maybe overwrite some stuff?
    # LIBS => [], CCFLAGS => '',
    # LDDLFLAGS => '',
    DEFINE => '-DHAS_PANDA -DPANDA_REFCNT',
    # Config Panda::Install
    BIN_DEPS  => ['Panda::XS'],
    # minum needed to install info
    BIN_SHARE => { CPLUS => 1 },
    SRC       => ['deps/srcmap/src', 'deps/srcmap/deps/json', 'deps/srcmap/deps/cencode'],
    H         => 'deps/srcmap/src/*.hpp deps/srcmap/deps/json/*.hpp deps/srcmap/deps/cencode/*.h',
    INC       => '-Ideps/srcmap/src -Ideps/srcmap/deps/json -Ideps/srcmap/deps/cencode',
    # XS        => '*.xs',
    # TYPEMAPS  => [],
));
