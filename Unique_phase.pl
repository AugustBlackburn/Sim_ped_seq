#!/usr/local/bin/perl

open (INFILE1, "Haploid_geno_phase.csv") || die;

$headerline = <INFILE1>;
@toks=split(',',$headerline);
$lengthtoks=scalar(@toks);
$tok=join(',',@toks[3..($lengthtoks-1)]);
while($line=<INFILE1>){
	chomp $line;
	@toks1=split(',',$line);
	$lengthtoks1=scalar(@toks1);
	$tok1=join(',',@toks1[3..($lengthtoks1-1)]);
	push @toks2, $tok1;
}

my %seen;
my @unique = grep {!$seen{$_}++} @toks2;

print STDOUT "$tok";
foreach $token (@unique){
	print STDOUT "$token\n";
}
