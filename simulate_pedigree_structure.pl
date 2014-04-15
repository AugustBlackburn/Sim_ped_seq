#!/usr/local/bin/perl
##Arguments are as follows: $ARGV[0] is a '/' delimited distribution of number of kids, $ARGV[1] is the number of generations to simulate, $ARGV[2] is the number of pedigrees to simulate


$counts=$ARGV[0];
@distro_counts=split('/',$counts);
@distro=(("0") x @distro_counts[0],("1") x @distro_counts[1],("2") x @distro_counts[2],("3") x @distro_counts[3],("4") x @distro_counts[4],("5") x @distro_counts[5],("6") x @distro_counts[6],("7") x @distro_counts[7],("8") x @distro_counts[8],("9") x @distro_counts[9],("10") x @distro_counts[10],("11") x @distro_counts[11],("12") x @distro_counts[12],("13") x @distro_counts[13]);
$distrolength=scalar(@distro);
$num_gens=$ARGV[1];

#Initialize first generation founders
$num_primary_founders=$ARGV[2];
$cursex=2;
$curridnumber=0;
print STDOUT "ID,FA,MO,SEX,GEN\n";
for($i=0;$i<$num_primary_founders;$i++){
	push @genidarray2, "A$i";
	$id="A$i";
	$curridnumber++;
	print STDOUT @{$gen{id}}[$i];
	if(rand()>0.5){
		@{$gen{$id}}[0]=1;
	}else{
		@{$gen{$id}}[0]=2;
	}
	push @mat,0;
	push @pat,0;
	print STDOUT "$id,0,0,@{$gen{$id}}[0],1\n";
}

for($i=1;$i<$num_gens;$i++){
	$cur_gen=$i+1;
	$last_gen=$i;
	@genidarray=@genidarray2;
	@genidarray2=();
	foreach $id (@genidarray){
		$cursex=@{$gen{$id}}[0];
		#print STDOUT "$id, $cursex\n";
		$numkids=@distro[int(rand($distrolength))];
		if($numkids > 0){
			if($cursex==1){
				$parent2="A$curridnumber";
				$curridnumber++;
				$parent1=$id;
				print STDOUT "$parent2,0,0,2,$last_gen\n";
			}else{
				$parent1="A$curridnumber";
				$curridnumber++;
				$parent2=$id;
				print STDOUT "$parent1,0,0,1,$last_gen\n";
			}
			for($j=0;$j<$numkids;$j++){
				push @genidarray2, "A$curridnumber";
				$id2="A$curridnumber";
				$curridnumber++;
				if(rand()>0.5){
					@{$gen{$id2}}[0]=1;
				}else{
					@{$gen{$id2}}[0]=2;
				}
				print STDOUT "$id2,$parent1,$parent2,@{$gen{$id2}}[0],$cur_gen\n";
			}
		}
	}	
}

