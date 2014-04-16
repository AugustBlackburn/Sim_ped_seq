##simulate_pedigree_structure.pl 
###This program can be used to simulate pedigrees of random structure
###Arguments are as follows: 
###$ARGV[0] is a '/' delimited emperical distribution of number of kids starting with 0 going up (ex. 0/5/3/1 would be a ratio of 0:5:3:1 of having 0,1,2, or 3 kids)
###$ARGV[1] is the number of generations to simulate
###$ARGV[2] is a '/' delimited emperical distribution of number of partners a person will have kids with starting with 1 and going up to 4 (ex.10/2/1/1 is a ratio of 10:2:1:1 of having 1,2,3, or 4 partners)

##sim_chr_genos.pl
###This program can be used to simulate genotypes according to a user defined emperical distribution, an example distribution is included
###Arguments are as follows:
###$ARGV[0] is the frequency distribution file
###$ARGV[1] is the effective populations size (does not matter in current version)
###$ARGV[2] is the number of markers to simulate
###$ARGV[3] is a pedigree file in the format generated by simulate_pedigree_structure.pl
###$ARGV[4] is the probability that a crossover happens between adjacent markers in a given meiosis

