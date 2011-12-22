#! /usr/bin/perl
# find photos not uploaded to flickr

use warnings;
use strict;
use Getopt::Long;
use IO::File;
use Pod::Usage;

my $pkg = 'flickr-diff';
my $version = '0.2';

# process command line
my $multiply;
if (!&GetOptions(help => sub { &pod2usage(-exitval => 0) },
                 multiply => \$multiply,
                 version => sub { print "$pkg $version\n"; exit 0 }))
{
    warn("Try ``$pkg --help'' for more information.\n");
    exit(1);
}

# read uploaded photos from flickr-upload-set log
my $fus = 'flickr-upload-set';
my $log = "$ENV{HOME}/$fus/$fus.done";
my $done_fh = IO::File->new("<$log");
if (!defined($done_fh)) {
    warn("$pkg: failed to open done file: $!");
    exit(1);
}
my %done;
while (defined(my $line = $done_fh->getline)) {
    chomp($line);
    ++$done{$line};
}
$done_fh->close;

if ($multiply) {
    # find multiple uploads
    foreach my $upload (sort(keys(%done))) {
        if ($done{$upload} > 1) {
            print("$upload\t$done{$upload}\n");
        }
    }
    exit(0);
}

# loop through photos
my @photos = glob("$ENV{HOME}/Pictures/iPhoto\\\ Library/Originals/*/*/*");
foreach my $photo (@photos) {
    if (!exists($done{$photo})) {
        print "$photo\n";
    }
}

exit(0);

__END__

=pod

=head1 NAME

flickr-diff - identify photos not uploaded and multiply uploaded

=head1 SYNOPSIS

B<flickr-diff> [OPTIONS]...

=head1 DESCRIPTION

This program compares the original files in a user's iPhoto library with
the list of files in the flickr-upload-set.done log.  It is also able to
identify photos that have been uploaded more than once.

=head1 OPTIONS

If an argument to a long option is mandatory, it is also mandatory for
the corresponding short option; the same is true for optional arguments.

=over 4

=item -h, --help

Display a brief description and listing of all available options.

=item -m, --multiply

Report photos uploaded more than once and the number of times uploaded
rather than the photos not yet uploaded.

=item -v, --version

Output version information and exit.

=item --

Terminate option processing.  This option is useful when file names
begin with a dash (-).

=back

=head1 BUGS

No known bugs.

=head1 SEE ALSO

flickr-upload-set(1)

=head1 AUTHOR

David Dooling <dooling@gmail.com>

=cut
