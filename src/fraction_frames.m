function fraction_frames(inputfilename, outputdir, expname, columnnumber, varargin)
%FRACTION_FRAMES is a more generic version of the pdfplot function
%Annika Rings, April 2019
%
%
%the input arguments are:
%
%INPUTFILENAME: name of the video
%OUTPUTDIR: path to the directory where the results should be stored
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
%score: name of the score from JAABA (default WingGesture)
%windowsize: size of the moving average window (in frames) (default=13)
%cutofffrac: fraction of the frames that have to be positive for the event
%in the specified window (default 0.5)
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
%removecop: whether copulation frames should be removed before the analysis
%cutoff: value that should be used as a cutoff to determine the fraction of
%frames above this value. If set to negative number, the middle value is
%used.
%
%if specificframes is set to false (default), copulationframes are removed
%unless removecop is set to false
%
%
%DEPENDENCIES: depends on the following functions (which have to be in the
%current path or the MATLAB search path):
%handle_flytracker_outputs_var
%handle_flytracker_outputs_score
%remove_copulation_ind
%newfigplot
%savepdf
options = struct('scaling', 1, 'wingdur', 13, 'wingextonly', true, ...
    'minwingangle', 30, 'fromscores', false, 'windowsize', 13, ...
    'cutofffrac', 0.5, 'score', 'WingGesture', 'specificframes', false, ...
    'filterby', 0, 'cutoffval', 2, 'above', true, 'removecop', true, 'cutoff', -1, ...
    'below', false, 'additional', 0, 'additional_cutoff', -1, ...
    'additional_below', false, 'additional2', 0, 'additional2_cutoff', -1, ...
    'additional2_below', false);

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments - throw exception if the number is not divisible by 2
nArgs = length(varargin);
if round(nArgs/2) ~= nArgs / 2
    error('fraction_frames called with wrong number of arguments: expected Name/Value pair arguments')
end

for pair = reshape(varargin, 2, []) %# pair is {propName;propValue}
    inpName = lower(pair{1}); %# make case insensitive
    %check if the entered key is a valid key. If yes, replace the default by
    %the caller specified value. Otherwise, throw and exception
    if any(strcmp(inpName, optionNames))

        options.(inpName) = pair{2};
    else
        error('%s is not a recognized parameter name', inpName)
    end
end
%turn the inputfilename into the specific names for the feat.mat and the
%frames.csv file
inputfilename_full = strcat(inputfilename, '-feat.mat');
inputfilename_frames = strcat('../', inputfilename, '_frames.csv');
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
remove_copulation = options.removecop;
cutoff = options.cutoff;
below = options.below;
additional = options.additional;
additional_cutoff = options.additional_cutoff;
additional_below = options.additional_below;
additional2 = options.additional2;
additional2_cutoff = options.additional2_cutoff;
additional2_below = options.additional2_below;
%array of the maximum expected values for the features;
maxs = [20; 30; pi; pi; 20; 5; 10; 1; 20; 20; pi; pi; 20; pi];
max_ = maxs(columnnumber) * scaling;
pts = (0:(max_ / 99):max_);


%check if the filterby option was set to a valid value and if so,
%set filter to true -otherwise set
%filter to false
filter = 0;
if (0 < filterby && filterby < 15)
    filter = 1;
    wingextonly = false;
    disp('filtering data by');
    disp(string(filterby));
end

additional_column = 0;
if (0 < additional && additional < 15)
    additional_column = 1;

    if (additional_cutoff < 0)
        additional_cutoff = maxs(additional) / 2;
    end
    additional_cutoff = additional_cutoff / scaling;
end

additional2_column = 0;
if (0 < additional2 && additional2 < 15)
    additional2_column = 1;

    if (additional2_cutoff < 0)
        additional2_cutoff = maxs(additional2) / 2;
    end
    additional2_cutoff = additional2_cutoff / scaling;
end

%check if the cutoff was set
if (cutoff < 0)
    cutoff = maxs(columnnumber) / 2;
end
cutoff = cutoff / scaling;


%make the pathname for the scoresfile out of the inputfilename
scorename = strcat(inputfilename, '_JAABA/', 'scores_', score, '_id_corrected.mat');
%check which options were set and call the respective function
%for specificframes, call function: handle_flytracker_output_frame_filtered
%if filter is true, otherwise call:handle_flytracker_output_frame
%if fromscores is set, call:handle_flytracker_outputs_score (this option is
%discarded if specificframes is set to true)
%if wingextension only is set, call: handle_flytracker_outputs_var
%(this option is discarded if specificframes or fromscores is set to true)
%in all other cases, call: remove_copulation_ind
%all options other than specificframes remove copulation frames
%
%the functions return a the filtered data saved into a variable called
%wing_ext_frames_indexed
if specificframes
    if filter
        wing_ext_frames_indexed = handle_flytracker_output_frame_filtered(inputfilename_full, inputfilename_frames, filterby, cutoffval, above);

    else
        wing_ext_frames_indexed = handle_flytracker_output_frame(inputfilename_full, inputfilename_frames);
    end
elseif fromscores
    wing_ext_frames_indexed = handle_flytracker_outputs_score(inputfilename_full, scorename, windowsize, cutofffrac);
elseif wingextonly
    if remove_copulation
        [wing_ext_frames_indexed] = handle_flytracker_outputs_var(inputfilename_full, wingdur, minwingangle);
    else
        [wing_ext_frames_indexed] = handle_flytracker_outputs_var_copulation_not_removed(inputfilename_full, wingdur, minwingangle);
    end
else
    if filter
        if remove_copulation
            wing_ext_frames_indexed = remove_copulation_ind_filtered(inputfilename_full, filterby, cutoffval, above);
        else
            wing_ext_frames_indexed = all_frames_ind_filtered(inputfilename_full, filterby, cutoffval, above);
        end
    else
        if remove_copulation
            wing_ext_frames_indexed = remove_copulation_ind(inputfilename_full);
        else
            wing_ext_frames_indexed = all_frames_ind(inputfilename_full);
        end
    end
end
%make indices to remember the flyID if rows are removed from the matrix
indices = transpose(1:size(wing_ext_frames_indexed, 1));
%add radial acceleration
wing_ext_frames_indexed = cellfun(@(indiv) [indiv{1}(:, :), ([diff(indiv{1}(:, 2)); 1] * 25)], wing_ext_frames_indexed, 'uni', false);

%remove NaNs
wing_ext_frames_indexed = cellfun(@(input)rmmissing(input), wing_ext_frames_indexed, 'UniformOutput', false);
%add indices
wing_ext_frames_indexed = cellfun(@(cell1, cell2) {cell1, cell2}, wing_ext_frames_indexed, num2cell(indices), 'UniformOutput', false);
%this is a bit of a mess - needs some refactoring
if below
    if additional_column
        if additional_below
            if additional2_column
                if additional2_below
                    numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) < cutoff) & (indiv{1}(:, additional2) < additional2_cutoff) & (indiv{1}(:, additional) < additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
                else
                    numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) < cutoff) & (indiv{1}(:, additional2) > additional2_cutoff) & (indiv{1}(:, additional) < additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
                end
            else
                numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) < cutoff) & (indiv{1}(:, additional) < additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
            end
        else
            if additional2_column
                if additional2_below
                    numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) < cutoff) & (indiv{1}(:, additional2) < additional2_cutoff) & (indiv{1}(:, additional) > additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
                else
                    numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) < cutoff) & (indiv{1}(:, additional2) > additional2_cutoff) & (indiv{1}(:, additional) > additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
                end
            else
                numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) < cutoff) & (indiv{1}(:, additional) > additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
            end
        end
    else
        numabove = cellfun(@(indiv) size(indiv{1}(indiv{1}(:, columnnumber) < cutoff), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
    end
else
    if additional_column
        if additional_below
            if additional2_column
                if additional2_below
                    numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) > cutoff) & (indiv{1}(:, additional2) < additional2_cutoff) & (indiv{1}(:, additional) < additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
                else
                    numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) > cutoff) & (indiv{1}(:, additional2) > additional2_cutoff) & (indiv{1}(:, additional) < additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
                end
            else
                numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) > cutoff) & (indiv{1}(:, additional) < additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
            end
        else
            if additional2_column
                if additional2_below
                    numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) > cutoff) & (indiv{1}(:, additional2) < additional2_cutoff) & (indiv{1}(:, additional) > additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
                else
                    numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) > cutoff) & (indiv{1}(:, additional2) > additional2_cutoff) & (indiv{1}(:, additional) > additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
                end

            else

                numabove = cellfun(@(indiv) size(indiv{1}((indiv{1}(:, columnnumber) > cutoff) & (indiv{1}(:, additional) > additional_cutoff)), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);
            end
        end
    else
        numabove = cellfun(@(indiv) size(indiv{1}(indiv{1}(:, columnnumber) > cutoff), 1)/size(indiv{1}, 1), wing_ext_frames_indexed, 'UniformOutput', false);

    end
end
frac_frames_indexed = cellfun(@(cell1, cell2) {cell1, cell2}, numabove, num2cell(indices), 'UniformOutput', false);
%remove empty cells
frac_frames_nonempty = frac_frames_indexed(~cellfun(@(cells) isnan(cells{1}), frac_frames_indexed));

if ~exist(outputdir, 'dir')
    mkdir(outputdir)
end

cellfun(@(data)save(fullfile(outputdir, strcat(inputfilename, '_', num2str(data{2}), '_', expname, '_fraction.mat')), 'data'), frac_frames_nonempty, 'UniformOutput', false);

close all;
