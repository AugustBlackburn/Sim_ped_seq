#!/usr/local/bin/perl

#$ARGV[0] is pedigree file
open (INFILE_PED, $ARGV[0]) || die;
open (OUTFILE, ">$ARGV[1]") || die;

$header = <INFILE_PED>;
while ($trioline = <INFILE_PED>){
	chomp $trioline;
	@triotoks = split(',', $trioline);
	$currid=@triotoks[0];
	push @maternal, @triotoks[2];
	push @{$matid{$currid}}, @triotoks[2];
	push @paternal, @triotoks[1];
	push @{$patid{$currid}}, @triotoks[1];
	push @offspr, @triotoks[0];
	push @sex, @triotoks[3];
	if(@triotoks[2] eq '0'){
		push @founders, @triotoks[0];
	}
}
close INFILE_PED;

print OUTFILE "ID,SEX,KID_COUNT\n";
$numberofids=scalar(@offspr);
for($i=0;$i<$numberofids;$i++){
	$id=@offspr[$i];
	$sex=@sex[$i];
	$kidcount=0;
	if($sex==1){
		#male
		for($j=0;$j<$numberofids;$j++){
			if(@paternal[$j] eq $id){
				$kidcount++;
			}
		}
	}elsif($sex==2){
		for($j=0;$j<$numberofids;$j++){
			if(@maternal[$j] eq $id){
				$kidcount++;
			}
		}
	}
	#push @kidcountarray, $kidcount;
	print OUTFILE "$id,$sex,$kidcount\n";
}

close OUTFILE;
