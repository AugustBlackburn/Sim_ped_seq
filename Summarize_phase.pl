#!/usr/local/bin/perl

#$ARGV[0] is the pedigree file
open (INFILE1, "Haploid_geno_phase.csv") || die;

$headerline=<INFILE1>;
chomp $headerline;
@toks=split(',',$headerline);
while($line=<INFILE1>){
	chomp $line;
	@toks2=split(',',$line);
	for ($i=0;$i<scalar(@toks);$i++){
		$id=@toks[$i];
		push @{$phase{$id}}, @toks2[$i];
	}
}

@chrs=@toks[3..(scalar(@toks)-1)];
foreach $chr (@chrs){
	$currentchr=@{$phase{$chr}}[0];
	print STDOUT "Current chromosome:$chr\n$currentchr:@{$phase{Position}}[0]-";
	for ($i=0;$i<scalar(@{$phase{$chr}});$i++){
		if($currentchr ne @{$phase{$chr}}[$i]){
			print STDOUT "@{$phase{Position}}[$i-1]\n";
			$currentchr=@{$phase{$chr}}[$i];
			print STDOUT "$currentchr:@{$phase{Position}}[$i]-";
		}
	}
	print STDOUT "@{$phase{Position}}[scalar(@{$phase{$chr}})-1]\n";	
}

