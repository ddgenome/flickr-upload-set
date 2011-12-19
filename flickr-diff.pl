#! /usr/bin/perl
# find photos not uploaded to flickr

use warnings;
use strict;
use IO::File;

my $pkg = 'flickr-done';
my $version = '0.1';

my $done_fh = IO::File->new('<flickr-upload-set.done');
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

# loop through photos
my @photos = glob('~susan/Pictures/iPhoto\ Library/Originals/*/*/*');
foreach my $photo (@photos) {
    if (!exists($done{$photo})) {
        print "$photo\n";
    }
}
exit(0);
# find multiple uploads
foreach my $upload (sort(keys(%done))) {
    if ($done{$upload} > 1) {
        print("$upload $done{$upload}\n");
    }
}

exit(0);
