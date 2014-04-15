#!/usr/local/bin/perl
#srand(localtime);
open(INFILE1,"All_Diploid_genos.csv")||die;
$headerline=<INFILE1>;
chomp $headerline;
@toks=split(',',$headerline);
$numcol=scalar(@toks);
for ($i=3;$i<$numcol;$i++){
	$randnum=rand(1);
	if($randnum > $ARGV[0]){
		$doiprint{$i}=1;
	}else{
		$doiprint{$i}=0;
	}
}
print STDOUT "@toks[0],@toks[1],@toks[2]";
for ($i=3;$i<$numcol;$i++){
	if($doiprint{$i}==1){
		print STDOUT ",@toks[$i]";
	}
}
print STDOUT "\n";
while ($line=<INFILE1>){
	chomp $line;
	@toks1=split(',',$line);
	print STDOUT "@toks1[0],@toks1[1],@toks1[2]";
	for ($i=3;$i<$numcol;$i++){
		if($doiprint{$i}==1){
			print STDOUT ",@toks1[$i]";
		}
	}
	print STDOUT "\n";	
}