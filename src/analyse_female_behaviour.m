function analyse_female_behaviour(genotypelists, genotypes, olddataformat)
run_distance_travelled(600)
run_fly_vel()
pausing()
for i = 1:length(genotypelists)
    genotypelist = genotypelists{i};
    genotype = genotypes{i};
    find_videos_Indices_other(genotypelist, genotype, olddataformat)
    find_videos_pausing(genotypelist, genotype, olddataformat)
    find_videos_dist(genotypelist, genotype, olddataformat)
end