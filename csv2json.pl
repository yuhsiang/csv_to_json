#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib);
use Text::CSV;
use Data::Dumper;
use JSON;

use constant CSV_FILE => "conwiz.csv";

sub get_csv_hash{
	my $csv = Text::CSV->new({ sep_char => ',' });
	my ($file) = @_;

	my $sum = 0;
	open(my $data, '<', $file) or die "Can't open file $file \n";

	my $header = $csv->getline ($data);
	my %links;
	my @arrayLines;
	my $jsonKey = (split '\.',$file)[0];

	while (my $row = $csv->getline($data)) {
		my $size = 0+@$row;
		my %line;

		for(my $i = 0; $i < $size; $i++) {
			my $value = $row->[$i];
			my $key = $header->[$i];

			if ($value =~ /^\d+?$/) {
				$value = 0+$value;
			}

			if (index($value, "true") == 0 || index($value, "false") == 0) {
				$value = index($value, "true") == 0 ? \1 : \0;
			}

			$line{$key} = $value;
		}
		push @arrayLines, \%line;
	}
	$links{$jsonKey} = \@arrayLines;
	return %links;
}

sub usage
{
    print <<USAGE
$0 filename.csv
USAGE
;
    exit(1)
}


sub main {
	if (-1 == $#ARGV) {
		&usage();
	}
	my $file = $ARGV[0];
	my %links = &get_csv_hash($file);
	my $json = encode_json \%links;
	print $json;
}

&main();
