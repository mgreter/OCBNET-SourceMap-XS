package OCBNET::SourceMap::XS;

use 5.008000;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use XS ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(

) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(

);

our $VERSION = '0.01';

require XSLoader;
# arguments needed for perl 5.14
XSLoader::load(__PACKAGE__, $VERSION);

package OCBNET::SourceMap::XS::LineMap;

# cannot get this to work directly in XS with the OVERLOAD keyword?
use overload fallback => 1, '==' => \&OCBNET::SourceMap::XS::LineMap::equals;

1;
__END__
###############################################################################
###############################################################################

=head1 NAME

OCBNET::SourceMap::XS - Perl extension for source-map manipulation

=head1 SYNOPSIS

  use OCBNET::SourceMap::XS;

  use File::Slurp qw(read_file);
  # read json file to create a sourcemap document
  my $json_file = 'deps/srcmap/test/output.js.map';
  my $json = read_file( $json_file, binmode => ':utf8' );
  my $srcmap = new OCBNET::SourceMap::XS::SrcMapDoc($json);

=head1 CLASSES

  my $srcmap = new OCBNET::SourceMap::XS::SrcMapDoc();
  my $mappings = new OCBNET::SourceMap::XS::Mappings(version);
  my $linemap = new OCBNET::SourceMap::XS::LineMap();
  # 0: col, 1: src_idx, 2: src_line, 3: src_col, 4: tkn_idx
  my $colmap = new OCBNET::SourceMap::XS::ColMap(0,1,2,3,4);

=head1 DESCRIPTION

API to load, create and manipulate SourceMaps as used by javascript
and css utilities and processors. The whole data is processed by a
C++ implementation, which is interfaced via XS for optimal performance.
Provides certain ultilities that might be usefull if you want to create
your own source-maps or need to alter or work with existing ones.
Currently we only support the most common L<V3 format|https://docs.google.com/document/d/1U1RGAehQwRypUTovF1KRlpiOFze0b-_2gc6fAH0KY0k/edit>, but so far I have
not seen anything using any other format.

=head2 EXPORT

None by default.

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

GitHub: L<https://github.com/mgreter/OCBNET-SourceMap-XS>

=head1 AUTHOR

Marcel Greter, E<lt>perl-libsass@ocbnet.chE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2015 by Marcel Greter

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.22.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
