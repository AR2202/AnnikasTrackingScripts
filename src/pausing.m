function pausing()
%%%PAUSING()
%%%Annika Rings, 2021
%%%function determines fraction of frames showing
%%%pausing based on Voshall et al criteria for pausing
%%%the function uses the fraction_frames(varargin) function

run_fraction('pausing', 1, 'cutoff', 4, 'below', true, ...
    'wingextonly', false, 'additional', 14, ...
    'additional_cutoff', (pi / 12), 'additional_below', true, ...
    'additional2', 10, ...
    'additional2_cutoff', 10, 'additional2_below', true)