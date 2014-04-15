#!/usr/local/bin/perl

#$ARGV[0] is pedigree file
open (INFILE_PED, $ARGV[0]) || die;
open (OUTFILE, ">All_paths.csv") || die;
open (OUTFILE2, ">Founder_offspring_counts.csv") || die;
open (OUTFILE3, ">Founder_offspring.csv")|| die;
open (OUTFILE4, ">Offspring_founders.csv")|| die;

print OUTFILE2 "Founder,Potential_observations\n";

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

$numberofids=scalar(@offspr);
foreach $founder (@founders){
	@currfoundoffpring=();
	push @currfoundoffpring, $founder;
	$thisfoundercount = 0;
	&find_paths($founder,$founder);
	print OUTFILE2 "$founder,$thisfoundercount\n";
	print OUTFILE3 join(',',@currfoundoffpring);
	print OUTFILE3 "\n";
}

######
sub find_paths{
	$thisfoundercount++;
	my $thisperson = $_[0];
	print OUTFILE "$_[1]\n";
	for(my $i = 0; $i < $numberofids;$i++){
		if (@paternal[$i] eq $thisperson || @maternal[$i] eq $thisperson){
			my $path = $_[1]."_".@offspr[$i];
			push @currfoundoffpring, @offspr[$i];
			&find_paths(@offspr[$i],$path);
		}
	}	
}

close OUTFILE;
close OUTFILE2;
close OUTFILE3;

open (INFILE2, "All_paths.csv") || die;
while ($line=<INFILE2>){
	chomp $line;
	@toks=split('_',$line);
	$currlength=scalar(@toks);
	$currid=@toks[$currlength-1];
	if($currlength == 1){
		push @{$maternal{$currid}}, @toks[0];
		push @{$paternal{$currid}}, @toks[0];
	}else{
		$currparent=@toks[$currlength-2];
		if($currparent eq @{$matid{$currid}}[0]){
			push @{$maternal{$currid}}, @toks[0];
		}elsif($currparent eq @{$patid{$currid}}[0]){
			push @{$paternal{$currid}}, @toks[0];
		}
	}
}

print OUTFILE4 "ID,Maternal_founders,Paternal_founders\n";
foreach $id (@offspr){
	my %matseen;
	my %patseen;
	my @matunique = grep {!$matseen{$_}++} @{$maternal{$id}};
	my @patunique = grep {!$patseen{$_}++} @{$paternal{$id}};
	print OUTFILE4 "$id,";
	print OUTFILE4 join('/',@matunique);
	print OUTFILE4 ",";
	print OUTFILE4 join('/',@patunique);
	print OUTFILE4 "\n";
}
close INFILE2;
close OUTFILE4;