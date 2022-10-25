function analyse_female_behaviour(genotypelists, genotypes, olddataformat, ...
    smaller_chamber)
run_distance_travelled(600)
run_fly_vel()
run_mean_velocity(900)

run_time_to_movement(4)


if smaller_chamber
    pausing_smaller_chamber()
else
    pausing()
end
find_videos_female_behaviour(genotypelists, genotypes, olddataformat)