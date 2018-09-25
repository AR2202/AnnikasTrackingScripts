function correlation_coef=correlate_vels(ind,vel_odd,vel_even,end_frame)
    transposed_odd1=transpose(vel_odd(ceil(ind/2),1:end_frame));
    transposed_even1=transpose(vel_even(ceil(ind/2),1:end_frame));
    corr_odd_even=corrcoef(transposed_odd1,transposed_even1);
    correlation_coef=corr_odd_even(1,2);
