function find_videos_female_behaviour(genotypelists, genotypes, olddataformat)

for i = 1:length(genotypelists)
    genotypelist = genotypelists{i};
    genotype = genotypes{i};
    find_videos_Indices_other(genotypelist, genotype, olddataformat)
    find_videos_pausing(genotypelist, genotype, olddataformat)
    find_videos_dist(genotypelist, genotype, olddataformat)
    find_videos_dist_other(genotypelist, genotype, olddataformat)
    find_videos_mean_velocity(genotypelist, genotype, olddataformat)
    find_videos_mean_velocity_other(genotypelist, genotype, olddataformat)
    find_videos_threshold(genotypelist, genotype, 'time_to_move', olddataformat)
    
    find_videos_filtered_velocity(genotypelist, genotype, olddataformat)
    
end