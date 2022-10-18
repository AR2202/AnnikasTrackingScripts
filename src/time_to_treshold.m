function time_to_treshold(inputfilename, column, threshold, above, outputdir, ...
    varargin)
inputfilename_full = strcat(inputfilename, '-feat.mat');
load(inputfilename_full);
numflies = size(feat.data, 1);
numframes = size(feat.data, 2);
framerate = 25; %needs to be changed if recording at different framerate
if above
    threshold_crosses = arrayfun(@(fly) ...
        minnonempty(numframes, find(feat.data(fly, :, column) > threshold, 1, 'first'))/framerate, ...
        [1:numflies], 'UniformOutput', false);
else
    threshold_crosses = arrayfun(@(fly) ...
        minnonempty(numframes, find(feat.data(fly, :, column) < threshold, 1, 'first'))/framerate, ...
        [1:numflies], 'UniformOutput', false);
end
data = cellfun(@(m) struct('threshold', m), threshold_crosses, 'UniformOutput', false);
%save the structure into a seperate .mat file for each individual in a
%subdirectory called 'outputdir'
%this calls the savedata function
cellfun(@(data, index) ...
    savedata(outputdir, ...
    strcat(inputfilename, '_', num2str(index), '_threshold.mat'), data), ...
    data, num2cell([1:numflies]), 'UniformOutput', false);
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
