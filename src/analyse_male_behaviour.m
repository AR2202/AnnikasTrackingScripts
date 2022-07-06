function analyse_male_behaviour(genotypelists, genotypes, olddataformat)
run_distance_travelled(600)
for i = 1:length(genotypelists)
    genotypelist = genotypelists{i};
    genotype = genotypes{i};
    find_videos_Indices(genotypelist, genotype, olddataformat)
    find_videos_bilateral(genotypelist, genotype, olddataformat)
    find_videos_dist_other(genotypelist, genotype, olddataformat)
end