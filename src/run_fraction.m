%Annika Rings, Jan 2021
%
%RUN_FRACTION is a function that calls the pdfplot_any function for
%all videos in all subdirectories with names ending in 'Courtship'
%the input arguments are:
%
%EXPNAME: name of the parameter of which the pdf is to be plotted (only
%used for nameing the figure and the field in the output data structure)
%COLUMNNUMBER: number of the column in the -feat.mat file that the desired parameter is stored in
%  vel=1;
%  ang_vel=2;
%  min_wing_ang=3;
%  max_wing_ang=4;
%  mean_wing_length=5;
%  axis_ratio=6;
%  fg_body_ratio=7;
%  contrast=8;
%  dist_to_wall=9;
%  dist_to_other=10;
%  angle_between=11;
%  facing_angle=12;
%  leg_dist=13;
%OPTIONAL name/value pair arguments:
%SCALING: scaling to be applied to the data (default = 1)
%WINGDUR: minimum number of contiguous frames of wing extension to be
%counted as wing extension bouts (default = 13, based on Ribeiro et al., 2018)
%WINGEXTONLY: use only wing extension frames (default = true)
%MINWINGANGLE: minimum angle of the wing to body axis to be counted as wing
%extension (default = 30)
%score: name of the score from JAABA
%windowsize: size of the moving average window (in frames)
%cutofffrac: fraction of the frames that have to be positive for the event
%in the specified window
%fromscores: if true, the data are taken from a JAABA scores file (default false)
%specificframes: if true, it expects a .csv file that contains the start
%and end frames of the frame ranges that should be analyzed. Several frame ranges can be
%specified, starting from column 3 in the .csv file. Each pair of 2 columns
%has to be a pair of start and endframes for the desired range.
%The flyID needs to be in column 2
%The file has to be located in
%the video directory and be called '<videoname>_frames.csv' where videoname
%is the name of the videodirectory it is in. (default false)
%filterby: column number (of the feat.mat file) which should be used for
%filtering frames. Must be a number between 1-13. Allows for additional
%filtering when the 'specificframes' option
%is set. (default: no additional filtering)
%cutoffval: if filterby is selected, this is the value above or below which
%the feature should be for the frames to be selected. (default:2)
%above: if filterby is selected, this specifies whether you want to use
%frames that are above or below cutoffval (default: true)
%
%if specificframes is set to false (default), copulationframes are removed
%
%DEPENDENCIES: depends on the following functions (which have to be in the
%current path or the MATLAB search path):
%pdfplot_any
%handle_flytracker_outputs_var
%handle_flytracker_outputs_score
%remove_copulation_ind
%newfigplot
%savepdf
%error_handling_wrapper

function run_fraction(expname, columnnumber, varargin)

options = struct('scaling', 1, 'wingdur', 13, 'wingextonly', true, ...
    'minwingangle', 30, 'fromscores', false, 'windowsize', 13, ...
    'cutofffrac', 0.5, 'score', 'WingGesture', 'specificframes', false, ...
    'filterby', 0, 'cutoffval', 2, 'above', true, 'removecop', true, 'cutoff', -1, ...
    'below', false, 'additional', 0, 'additional_cutoff', -1, ...
    'additional_below', false, 'additional2', 0, 'additional2_cutoff', -1, ...
    'additional2_below', false, 'outdirname', 'fraction');

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments - throw exception if the number is not divisible by 2
nArgs = length(varargin);
if round(nArgs/2) ~= nArgs / 2
    error('run_Fraction called with wrong number of arguments: expected Name/Value pair arguments')
end

for pair = reshape(varargin, 2, []) %# pair is {propName;propValue}
    inpName = lower(pair{1}); %# make case insensitive
    %check if the entered key is a valid key
    %check if the entered key is a valid key. If yes, replace the default by
    %the caller specified value. Otherwise, throw and exception
    if any(strcmp(inpName, optionNames))

        options.(inpName) = pair{2};
    else
        error('%s is not a recognized parameter name', inpName)
    end
end
%this block gets all the values from the optional function arguments
%for all arguments that were not specified, the default is used
wingdur = options.wingdur;
wingextonly = options.wingextonly;
scaling = options.scaling;
minwingangle = options.minwingangle * pi / 180;
fromscores = options.fromscores;
windowsize = options.windowsize;
cutofffrac = options.cutofffrac;
score = options.score;
specificframes = options.specificframes;
filterby = options.filterby;
cutoffval = options.cutoffval;
above = options.above;
removecop = options.removecop;
cutoff = options.cutoff;
below = options.below;
additional = options.additional;
additional_cutoff = options.additional_cutoff;
additional_below = options.additional_below;
additional2 = options.additional2;
additional2_cutoff = options.additional2_cutoff;
additional2_below = options.additional2_below;
outdirname = options.outdirname;

        if specificframes

            run_any('fraction_errors.log', ...
                                   'fraction_frames', ...
                                   outdirname, ...
                                   expname, ...
                                   columnnumber, ...
                                   'scaling', scaling, ...
                                   'specificframes', true, ...
                                   'filterby', filterby, ...
                                   'cutoffval', cutoffval, ...
                                   'above', above, ...
                                   'cutoff', cutoff, ...
                                   'below', below, ...
                                   'additional', additional, ...
                                   'additional_cutoff', additional_cutoff, ...
                                   'additional_below', additional_below, ...
                                   'additional2', additional2, ...
                                   'additional2_cutoff', additional2_cutoff, ...
                                   'additional2_below', additional2_below);

        elseif fromscores
            run_any('fraction_errors.log', ...
                                   'fraction_frames', ...
                                   outdirname, ...
                                   expname, ...
                                   columnnumber, ...
                                   'windowsize', windowsize, ...
                                   'cutofffrac', cutofffrac, ...
                                   'scaling', scaling, ...
                                   'fromscores', true, ...
                                   'score', score, ...
                                   'removecop', removecop, ...
                                   'cutoff', cutoff, ...
                                   'below', below, ...
                                   'additional', additional, ...
                                   'additional_cutoff', additional_cutoff, ...
                                   'additional_below', additional_below, ...
                                   'additional2', additional2, ...
                                   'additional2_cutoff', additional2_cutoff, ...
                                   'additional2_below', additional2_below);


        else
            run_any('fraction_errors.log', ...
                                   'fraction_frames', ...
                                   outdirname, ...
                                   expname, ...
                                   columnnumber, ...
                                   'scaling', scaling, ...
                                   'wingdur', wingdur, ...
                                   'wingextonly', wingextonly, ...
                                   'minwingangle', minwingangle, ...
                                   'filterby', filterby, ...
                                   'cutoffval', cutoffval, ...
                                   'above', above, ...
                                   'removecop', removecop, ...
                                   'cutoff', cutoff, ...
                                   'below', below, ...
                                   'additional', additional, ...
                                   'additional_cutoff', additional_cutoff, ...
                                   'additional_below', additional_below, ...
                                   'additional2', additional2, ...
                                   'additional2_cutoff', additional2_cutoff, ...
                                   'additional2_below', additional2_below);

        end
       