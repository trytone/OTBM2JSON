#!/usr/bin/perl

# Configuration 
my $inputFilePath = "Tibia.dat";
my $outputFilePath = "item2sprites.csv";
my $id = 100;
my $maxId = 5384;

# Open read/write files
open(INPUT, $inputFilePath) or die "ERROR : Cannot open tibia.dat.\n";
open(OUTPUT,'>',$outputFilePath) or die "ERROR : Cannot open output file\n";

# Read Tibia.dat to bytes array
my $binary = '';
while (<INPUT>) {
    $value = unpack  "H*", $_;
	$value =~ s/(..)/$1 /g;
    $binary .= $value;
}
close(INPUT);
$binary =~ s/\s//g;
my @bytes = ( $binary =~ m/../g );	
my $offset = 12;

# Read bytes until end of file
while(1){
	syswrite(STDOUT,"[$id/$maxId]\n",255);
	my ($width,$height,$frame,$xRepeat,$yRepeat,$zRepeat,$animation,$headerOffset) = (0,0,0,0,0,0,0,7);
	if($bytes[$offset] ne 'ff'){ # next byte until start of object
		$offset++;
		next;
	}
	$offset++;
	
	# Read header of object 
	$width = sprintf("%d", hex($bytes[$offset+0]));
	$height = sprintf("%d", hex($bytes[$offset+1]));
	if($width > 1 || $height > 1){
			 $frame = sprintf("%d", hex($bytes[$offset+3]));
			 $xRepeat = sprintf("%d", hex($bytes[$offset+4]));
			 $yRepeat = sprintf("%d", hex($bytes[$offset+5]));
			 $zRepeat = sprintf("%d", hex($bytes[$offset+6]));
			 $animation = sprintf("%d", hex($bytes[$offset+7]));
	} else {
			$frame = sprintf("%d", hex($bytes[$offset+2]));
			$xRepeat = sprintf("%d", hex($bytes[$offset+3]));
			$yRepeat = sprintf("%d", hex($bytes[$offset+4]));
			$zRepeat = sprintf("%d", hex($bytes[$offset+5]));
			$animation = sprintf("%d", hex($bytes[$offset+6]));
			$headerOffset = 6;
	}
	
	# Calculate sprites count
	my $spritesCount = $width * $height * $frame * $xRepeat * $yRepeat * $zRepeat * $animation;
	$offset = $offset + $headerOffset;
	if($spritesCount > 0){
			for(0..$spritesCount-1){
				my $highByte = $bytes[$offset+1];
				my $lowByte = $bytes[$offset+2];
				
				my $fileId = 256 * sprintf("%d", hex($lowByte)) + sprintf("%d", hex($highByte)); # Convert hex into decimal
				if($fileId != 0){
					print OUTPUT "$id;$fileId\n"; # Save
				}
				$offset = $offset + 2;
			}
		}	

	if($id == $maxId){
		last;
	} else {
		$id++;
	}
}	
close(OUTPUT);