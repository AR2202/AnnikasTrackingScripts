%MEAN_DIST_TO_OTHER calculates the mean distance to other fly 
%of the flies in 'inputfilename'

%removes copulation frames based on the Copulation classifier
%copulation start is defined as the time when half the frames within a
%50s window are positive for the classifier

function mean_dist_to_other(inputfilename, varargin)


outputdir = 'distance_to_other';
columnnumber = 10; %for distance to other
framerate = 25;
dur = 900;
%turn the inputfilename into the specific names for the feat.mat and the

inputfilename_full = strcat(inputfilename, '-feat.mat');
JAABAdir = strcat(inputfilename, '_JAABA');
copulationfilename = fullfile(JAABAdir, 'scores_Copulation_id_corrected.mat');


endframe = round(framerate*dur);
load(inputfilename_full);
numflies = size(feat.data, 1);
Copstarts = cell(1, numflies);
%remove copulation frames
if isfile(copulationfilename)
    disp('copulationfile found');
    load(copulationfilename);
    isCopulationframe = allScores.postprocessed;

    isCopulationframe = cellfun(@(singleflydata) ...
        [transpose(singleflydata); ...
        zeros(22500-length(singleflydata), 1)], ...
        isCopulationframe, 'UniformOutput', false);


    for i = 1:numflies
        tmp_data = isCopulationframe{i};
        tmp_data = movmean(tmp_data, 1250) > 0.5;
        copstart = find(tmp_data, 1, 'first');
        if isempty(copstart)
            Copstarts{i} = endframe;
        else
            Copstarts{i} = copstart;
        end
    end


end
transposed_copstarts = transpose(Copstarts);
indices = transpose(1:size(feat.data, 1));
%concatenate all the data into a cell array with the right structure
featnumber = size(feat.data, 3);
ind_data = arrayfun(@(x) concatenate_data(x, featnumber, feat), ...
    indices, 'UniformOutput', false);


%select only the frames until endframe
frames = cellfun(@(indiv, copstart) ...
    indiv(1:minnonempty(endframe, copstart), :), ...
    ind_data, transposed_copstarts, 'UniformOutput', false);
wing_ext_frames_indexed = cellfun(@(cell1, cell2) {cell1, cell2}, ...
    frames, num2cell(indices), 'UniformOutput', false);


%make indices to remember the flyID if rows are removed from the matrix
indices = transpose(1:size(wing_ext_frames_indexed, 1));
%remove NaNs
wing_ext_frames_indexed = cellfun(@(input) ...
    fillmissing(input{1, 1}, 'linear'), ...
    wing_ext_frames_indexed, 'UniformOutput', false);
%add indices
wing_ext_frames_indexed = cellfun(@(cell1, cell2) ...
    {cell1, cell2}, wing_ext_frames_indexed, num2cell(indices), ...
    'UniformOutput', false);
%remove empty cells
wing_ext_frames_nonempty = wing_ext_frames_indexed(~cellfun(@(cells) ...
    isempty(cells{1}), ...
    wing_ext_frames_indexed));


%calc the means
mean_dist = cellfun(@(wing_ext_frames_ind) ...
    mean(wing_ext_frames_ind{1}(:, columnnumber)), ...
    wing_ext_frames_nonempty, 'UniformOutput', false);

data = cellfun(@(m) struct('dist', m), mean_dist, 'UniformOutput', false);
%save the structure into a seperate .mat file for each individual in a
%subdirectory called 'distance_travelled'
%this calls the savepdf function
cellfun(@(data, index) ...
    savedata(outputdir, ...
    strcat(inputfilename, '_', num2str(index{1, 2}), '_mean_distance_to_other.mat'), data), ...
    data, wing_ext_frames_nonempty, 'UniformOutput', false);
%close figure windows
close all;


function savedata(outputdir, filename, data)
currentdir = pwd;
if ~exist(outputdir, 'dir')
    mkdir(outputdir);
end
cd(outputdir);
save(filename, 'data');
cd(currentdir);

function m = minnonempty(num1, num2)
if isempty(num2)
    m = num1;

else
    m = min(num1, num2);
end
