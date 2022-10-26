%MEAN_VELOCITY_FiLTERED_BY_SCORE_OTHER calculates the mean velocity 
%of the flies in 'inputfilename'
%while the other fly has a positive score for score
%input parameter
%removes copulation frames based on the Copulation classifier
%copulation start is defined as the time when half the frames within a
%50s window are positive for the classifier

function mean_velocity_filtered_by_score_other(inputfilename, ...
    score, windowsize, cutofffrac, varargin)


outputdir = 'velocity_filtered';
columnnumber = 1; %for vel
framerate = 25;
endframe = 22500;
%turn the inputfilename into the specific names for the feat.mat and the

inputfilename_full = strcat(inputfilename, '-feat.mat');
JAABAdir = strcat(inputfilename, '_JAABA');

scorefilename_full = fullfile(JAABAdir, strcat('scores_', score, '_id_corrected.mat'));







ind_data = filter_by_other_fly_score(inputfilename_full,...
    scorefilename_full, windowsize, cutofffrac);







%remove empty cells
wing_ext_frames_nonempty = ind_data(~cellfun(@(cells) ...
    isempty(cells{1}), ...
   ind_data));


%calc the means
mean_vels = cellfun(@(wing_ext_frames_ind) ...
    mean(wing_ext_frames_ind{1}(:, columnnumber)), ...
    wing_ext_frames_nonempty, 'UniformOutput', false);

data = cellfun(@(m) struct('vel', m), mean_vels, 'UniformOutput', false);
%save the structure into a seperate .mat file for each individual in a
%subdirectory called 'distance_travelled'
%this calls the savepdf function
cellfun(@(data, index) ...
    savedata(outputdir, ...
    strcat(inputfilename, '_', num2str(index{1, 2}), '_mean_velocity.mat'), data), ...
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
