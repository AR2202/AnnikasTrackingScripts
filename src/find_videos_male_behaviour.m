function find_videos_male_behaviour(genotypelists, genotypes, olddataformat)

for i = 1:length(genotypelists)
    genotypelist = genotypelists{i};
    genotype = genotypes{i};
    find_videos_Indices(genotypelist, genotype, olddataformat)
    find_videos_bilateral(genotypelist, genotype, olddataformat)
    find_videos_dist_other(genotypelist, genotype, olddataformat)
    find_videos_dist(genotypelist, genotype, olddataformat)
    %find_videos_mean_velocity(genotypelist, genotype, olddataformat)
    find_videos_mean_dist_to_other(genotypelist, genotype, olddataformat)
end