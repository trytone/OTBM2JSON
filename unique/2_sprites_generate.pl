use File::Copy;

open(IN,'unique_items.csv');
my @items = <IN>;
close(IN);

open(IN2,'unique_tiles.csv');
my @tiles = <IN2>;
close(IN2);

open(DAT,'item2sprites.csv');
my @datalines = <DAT>;
close(DAT);

open(DAT2,'items.otb.csv');
my @datalines2 = <DAT2>;
close(DAT2);



my $crossTiles = {};
my $crossItems = {};

foreach my $dataline (@datalines){
	chomp $dataline;
	my @split = split /;/, $dataline;
	push(@{ $crossTiles->{$split[0]} }, $split[1]);
}

foreach my $dataline2 (@datalines2){
	chomp $dataline2;
	my @split2 = split /;/, $dataline2;
	$crossItems->{$split2[0]} = $split2[1];
}



mkdir('C:\\Users\\48737\\Documents\\OTBM2JSON\\unique\\tiles_sprites');

foreach my $tile (@tiles){
	chomp $tile;
	mkdir('C:\\Users\\48737\\Documents\\OTBM2JSON\\unique\\tiles_sprites\\'.$tile);
	my $c1 = 1;
	foreach my $object (@{$crossTiles->{$crossItems->{$tile}}}){
		copy('C:\\Users\\48737\\Documents\\OTBM2JSON\\sprites\\Sprites\\'.$object.'.bmp', 'C:\\Users\\48737\\Documents\\OTBM2JSON\\unique\\tiles_sprites\\'.$tile.'\\'.$tile.'_'.$c1.'.bmp');
		$c1++;
	}
}

mkdir('C:\\Users\\48737\\Documents\\OTBM2JSON\\unique\\items_sprites');

foreach my $item (@items){
	chomp $item;
	mkdir('C:\\Users\\48737\\Documents\\OTBM2JSON\\unique\\items_sprites\\'.$item);
	my $c2 = 1;
	foreach my $object (@{$crossTiles->{$crossItems->{$item}}}){
		copy('C:\\Users\\48737\\Documents\\OTBM2JSON\\sprites\\Sprites\\'.$object.'.bmp', 'C:\\Users\\48737\\Documents\\OTBM2JSON\\unique\\items_sprites\\'.$item.'\\'.$item.'_'.$c2.'.bmp');
		$c2++;
	}
}