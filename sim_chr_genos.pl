#!/usr/local/bin/perl
srand(localtime);

####Arguments are frequency distribution file, population size, number of markers, pedigree file, and cross-over probability in that order

$FreqDistro = $ARGV[0];
open (INFILE,"$FreqDistro")|| die "Can't open file:$FreqDistro";
open (OUTFILE3, ">All_Diploid_genos.csv") || die;
open (OUTFILE4, ">All_Haploid_genos.csv") || die;
open (OUTFILE5, ">Haploid_geno_phase.csv") || die;
open (OUTFILE6, ">Diploid_phase_genotypes.csv") || die;

#Read simulated frequency distribution into an array of frequencies
while ($line=<INFILE>){
	chomp $line;
	push @frequencydistribution, $line;
}

open (INFILE_PED, $ARGV[3]) || die;
$header = <INFILE_PED>;
#Identify founders
while ($trioline = <INFILE_PED>){
	chomp $trioline;
	@triotoks = split(',', $trioline);
	push @maternal, @triotoks[2];
	push @paternal, @triotoks[1];
	push @offspr, @triotoks[0];
	push @sex, @triotoks[3];
	if(@triotoks[2] eq '0'){
		push @founders, @triotoks[0];
	}else{
		push @nonfounders, @triotoks[0];
	}
}
for ($i=0;$i<scalar(@offspr);$i++){
	$id=@offspr[$i];
	push @{$idsexhash{$id}}, @sex[$i];
}
close INFILE_PED;

####Create haploid genotypes according to the specified frequency distribution####
$pop_size = scalar(@founders);###used to be pop_size
$k_markers = $ARGV[2];
$n_chr=$pop_size*2;

for ($j=0;$j<$k_markers;$j++){
	$currmarkerfreq=@frequencydistribution[int(rand(scalar(@frequencydistribution)))];
	for ($i=0;$i<$n_chr;$i++){		
		$currentallelestate=rand(1);
		if($currentallelestate >= $currmarkerfreq){
			push @{$chr{$i}}, 0;
			
		}else{
			push @{$chr{$i}}, 1;
		}	
	}
}

####Drop data through pedigree####
#Assign founders genotypes
$i=0;
foreach $founder (@founders){
	@{$one{$founder}} = @{$chr{$i}};
	$i++;
	@{$two{$founder}} = @{$chr{$i}};
	$i++;
}

####Initiate founder phase####
foreach $founder (@founders){
	for ($j=0;$j<$k_markers;$j++){
		$nameone="$founder"."_1";
		$nametwo="$founder"."_2";
		push @{$phase1{$founder}}, $nameone;
		push @{$phase2{$founder}}, $nametwo;
	}
}

#Initiate dropping
$crossover_freq=$ARGV[4];
$numberofids=scalar(@offspr);
##@ready holds ids that are ready to be dropped
@ready=@founders;
foreach $id (@ready){
	@currfoundoffpring=();
	&find_kids($id);
	for $kid (@currfoundoffpring){
		#pick a random chromosome to start on
		$fiftyfifty=rand();
		if($fiftyfifty<0.5){
			$oneortwo=1;
		}else{
			$oneortwo=2;
		}
		for ($j=0;$j<$k_markers;$j++){
			if (@{$idsexhash{$id}}[0] == 1){
				if ($oneortwo == 1){
					push @{$one{$kid}}, @{$one{$id}}[$j];
					push @{$phase1{$kid}}, @{$phase1{$id}}[$j];
				}else{
					push @{$one{$kid}}, @{$two{$id}}[$j];
					push @{$phase1{$kid}}, @{$phase2{$id}}[$j];
				}
				$ready1{$kid}=1;
			}else{
				if ($oneortwo == 1){
					push @{$two{$kid}}, @{$one{$id}}[$j];
					push @{$phase2{$kid}}, @{$phase1{$id}}[$j];
				}else{
					push @{$two{$kid}}, @{$two{$id}}[$j];
					push @{$phase2{$kid}}, @{$phase2{$id}}[$j];
				}
				$ready2{$kid}=1;
			}
			if(rand()<$crossover_freq){
				if($oneortwo == 1){
					$oneortwo = 2;
				}else{
					$oneortwo = 1;
				}
			}	
		}
		if($ready1{$kid}==1 & $ready2{$kid}==1){
			push @ready, $kid;
		}		
	}
}

####Print out genotype files
print OUTFILE3 "Marker,Chr,Position,";
print OUTFILE3 join(',',@offspr);
print OUTFILE3 "\n";
print OUTFILE6 "Marker,Chr,Position,";
print OUTFILE6 join(',',@offspr);
print OUTFILE6 "\n";
for ($j=0;$j<$k_markers;$j++){
	print OUTFILE3 "Marker$j";
	print OUTFILE3 ",1,$j";
	print OUTFILE6 "Marker$j";
	print OUTFILE6 ",1,$j";
	foreach $id (@offspr){
		$diploid = @{$one{$id}}[$j] + @{$two{$id}}[$j];
		print OUTFILE3 ",$diploid";
		print OUTFILE6 ",@{$phase1{$id}}[$j]/@{$phase2{$id}}[$j]";
	}
	print OUTFILE3 "\n";
	print OUTFILE6 "\n";
}

print OUTFILE4 "Marker,Chr,Position";
print OUTFILE5 "Marker,Chr,Position";
foreach $id (@offspr){
	print OUTFILE4 ",$id";
	print OUTFILE4 "_one,$id";
	print OUTFILE4 "_two";
	print OUTFILE5 ",$id";
	print OUTFILE5 "_one,$id";
	print OUTFILE5 "_two";
}
print OUTFILE4 "\n";
print OUTFILE5 "\n";
for ($j=0;$j<$k_markers;$j++){
	print OUTFILE4 "Marker$j";
	print OUTFILE4 ",1,$j";
	print OUTFILE5 "Marker$j";
	print OUTFILE5 ",1,$j";	
	foreach $id (@offspr){
		print OUTFILE4 ",@{$one{$id}}[$j],@{$two{$id}}[$j]";
		print OUTFILE5 ",@{$phase1{$id}}[$j],@{$phase2{$id}}[$j]";
	}
	print OUTFILE4 "\n";
	print OUTFILE5 "\n";
}

######

sub find_kids{
	my $thisperson = $_[0];
	for(my $i = 0; $i < $numberofids;$i++){
		if (@paternal[$i] eq $thisperson || @maternal[$i] eq $thisperson){
			push @currfoundoffpring, @offspr[$i];			
		}
	}
}


