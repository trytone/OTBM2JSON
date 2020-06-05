#!/usr/bin/perl

# Configuration 
my $inputFilePath = "items.otb";
my $outputFilePath = "items.otb.csv";
my $binary = '';

open(INPUT, $inputFilePath) or die "ERROR : Cannot open items.otb. Place file in same folder as script\n";
open(OUTPUT,'>',$outputFilePath) or die "ERROR : Cannot open output file\n";

# Read items.otb to bytes array
while (<INPUT>) {
    $value = unpack  "H*", $_;
	$value =~ s/(..)/$1/g;
    $binary .= $value;
}
close(INPUT);

# split by delimiter bytes : 11 02 00 
while($binary =~ /(..)(..)110200(..)(..)/g){
	my $id = 256 * sprintf("%d", hex($2)) + sprintf("%d", hex($1));
	my $cid = 256 * sprintf("%d", hex($4)) + sprintf("%d", hex($3));
	print OUTPUT "$id;$cid\n";
}
close(OUTPUT);
