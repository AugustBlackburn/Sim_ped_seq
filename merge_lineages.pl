#!/usr/local/bin/perl

open(INFILE1,"$ARGV[0]")||die;
open(INFILE2,"$ARGV[1]")||die;

$headerline1=<INFILE1>;
$headerline2=<INFILE2>;

while($line1=<INFILE1>){
	chomp $line1;
	@toks1=split(',',$line1);
	push @ids, @toks1[0];
	push @FA, @toks1[1];
	push @MO, @toks1[2];
	push @SEX, @toks1[3];
	push @GEN, @toks1[4];
}
$curridcount=scalar(@ids);

while($line2=<INFILE2>){
	chomp $line2;
	@toks2=split(',',$line2);
	@stuff=split(undef,@toks2[0]);
	if(@stuff[0] eq 'A'){
		$digit=substr @toks2[0], 1;
		$digit2 = $digit + $curridcount;
		$newid = "A$digit2";
		push @ids2, $newid;
	}else{
		push @ids2, @toks2[0];
	}
	@stuff1=split(undef,@toks2[1]);
	if(@stuff1[0] eq 'A'){
		$digit=substr @toks2[1], 1;
		$digit2 = $digit + $curridcount;
		$newid = "A$digit2";
		push @FA2, $newid;
	}else{
		push @FA2, @toks2[1];
	}
	@stuff2=split(undef,@toks2[2]);
	if(@stuff2[0] eq 'A'){
		$digit=substr @toks2[2], 1;
		$digit2 = $digit + $curridcount;
		$newid = "A$digit2";
		push @MO2, $newid;
	}else{
		push @MO2, @toks2[2];
	}
	push @SEX2, @toks2[3];
	push @GEN2, @toks2[4];
}
$curridcount=$curridcount + scalar(@ids2);

for($i=0;$i<scalar(@ids);$i++){
	if(@FA[$i] eq '0' & @GEN[$i] ne '1'){
		push @marryinids,$i;
	}
}

for($i=0;$i<scalar(@ids2);$i++){
	if(@FA2[$i] ne '0'){
		push @dirlinids,$i;
	}
}

for($i=0;$i<scalar(@marryinids);$i++){
	$k=@marryinids[$i];
	for($j=0;$j<scalar(@dirlinids);$j++){
		$l=@dirlinids[$j];
		if(@SEX[$k]==@SEX2[$l] & @GEN[$k]==@GEN2[$l]){
			push @potential, "$k,$l";
		}
	}
}

$numberofpossibilities=scalar(@potential);
if($numberofpossibilities == 0){
	#print STDOUT "Marrying two kids and making another generation\n";
	$highestgen1=@GEN[-1];
	$highestgen2=@GEN2[-1];
	for($i=0;$i<scalar(@ids);$i++){
		if(@GEN[$i] eq $highestgen1){
			push @lastgenlist1,$i;
			push @lastgensex1,@SEX[$i];
		}
	}
	for($i=0;$i<scalar(@ids2);$i++){
		if(@GEN2[$i] eq $highestgen2){
			push @lastgenlist2,$i;
			push @lastgensex2,@SEX2[$i];
		}
	}
	my %seen1;
	my @unique1 = grep { ! $seen1{$_}++ } @lastgensex1;
	my %seen2;
	my @unique2 = grep { ! $seen2{$_}++ } @lastgensex2;
	$lenunique1=scalar(@unique1);
	$lenunique2=scalar(@unique2);
	if($lenunique1==2){
		$marriageswitch=1;
		$randint=int(rand(scalar(@lastgenlist2)));
		$randint2=@lastgenlist2[$randint];
		$secondpartner=$ids2[$randint2];
		if(@lastgensex2[$randint] == 1){
			$partnersex=2;
		}else{
			$partnersex=1;
		}
		for($i=0;$i<scalar(@lastgensex1);$i++){
			if(@lastgensex1[$i] eq $partnersex){
				push @potentialpartners,$i;
			}
		}
		$randint3=int(rand(scalar(@potentialpartners)));
		$randint4=@potentialpartners[$randint3];
		$randint5=@lastgenlist1[$randint4];
		$firstpartner=@ids[$randint5];
		$firstpartnersex=@SEX[$randint5];
	}elsif($lenunique2==2){
		$marriageswitch=1;
		$randint=int(rand(scalar(@lastgenlist1)));
		$firstpartner=$ids[@lastgenlist1[$randint]];
		$firstpartnersex=@SEX[@lastgenlist1[$randint]];
		if(@lastgensex1[$randint] == 1){
			$partnersex=2;
		}else{
			$partnersex=1;
		}
		for($i=0;$i<scalar(@lastgensex2);$i++){
			if(@lastgensex2[$i] eq $partnersex){
				push @potentialpartners,$i;
			}
		}
		$secondpartner=@ids2[@lastgenlist2[@potentialpartners[int(rand(scalar(@potentialpartners)))]]];
	}elsif(@unique1[0] ne @unique2[0]){
		$marriageswitch=1;
		$firstpartner=@ids[@lastgenlist1[int(rand(scalar(@lastgenlist1)))]];
		$firstpartnersex=@SEX[@lastgenlist1[int(rand(scalar(@lastgenlist1)))]];
		$secondpartner=@ids2[@lastgenlist2[int(rand(scalar(@lastgenlist2)))]];
	}else{
		print "Can't merge. You're out of luck buddy!";
		exit;
	}
}
$randomselection=@potential[int(rand($numberofpossibilities))];
@randomperson=split(',',$randomselection);
$person1=@ids[@randomperson[0]];
$person1sex=@SEX[@randomperson[0]];
$person2=@ids2[@randomperson[1]];

open(OUTFILE,">$ARGV[2]")||die;
print OUTFILE $headerline1;
if($marriageswitch == 1){
	for($i=0;$i<scalar(@ids);$i++){
		print OUTFILE "@ids[$i],@FA[$i],@MO[$i],@SEX[$i],@GEN[$i]\n";
	}
	for($i=0;$i<scalar(@ids2);$i++){
		print OUTFILE "@ids2[$i],@FA2[$i],@MO2[$i],@SEX2[$i],@GEN2[$i]\n";
	}
	$numkids=int(rand(5))+1;
	$cur_gen=$highestgen1+1;
	for($j=0;$j<$numkids;$j++){
		$id2="A$curridcount";
		$curridcount++;
		if(rand()>0.5){
			@{$gen{$id2}}[0]=1;
		}else{
			@{$gen{$id2}}[0]=2;
		}
		if($firstpartnersex eq '1'){
			print OUTFILE "$id2,$firstpartner,$secondpartner,@{$gen{$id2}}[0],$cur_gen\n";
		}else{
			print OUTFILE "$id2,$secondpartner,$firstpartner,@{$gen{$id2}}[0],$cur_gen\n";
		}
	}
}else{
	for($i=0;$i<scalar(@ids);$i++){
		if(@ids[$i] eq $person1){
			next;
		}else{
			@curray = (@ids[$i],@FA[$i],@MO[$i],@SEX[$i],@GEN[$i]);
			$curstring=join(',',@curray);
			$curstring=~ s/$person1,/$person2,/;
			print OUTFILE "$curstring\n";
		}
	}
	for($i=0;$i<scalar(@ids2);$i++){
		print OUTFILE "@ids2[$i],@FA2[$i],@MO2[$i],@SEX2[$i],@GEN2[$i]\n";
	}
}




