function [frames_indexed] = handle_flytracker_output_frame(filename, framefilename)

load(filename);
frametable = readtable(framefilename);
%remove NaNs
frametable = rmmissing(frametable);
%  vel=feat.data(:,:,1);
%  ang_vel=feat.data(:,:,2);
%  min_wing_ang=feat.data(:,:,3);
%  max_wing_ang=feat.data(:,:,4);
%  mean_wing_length=feat.data(:,:,5);
%  axis_ratio=feat.data(:,:,6);
%  fg_body_ratio=feat.data(:,:,7);
%  contrast=feat.data(:,:,8);
%  dist_to_wall=feat.data(:,:,9);
%  dist_to_other=feat.data(:,:,10);
%  angle_between=feat.data(:,:,11);
%  facing_angle=feat.data(:,:,12);
%  leg_dist=feat.data(:,:,13);
indices = transpose(1:size(feat.data, 1));
%concatenate all the data into a cell array with the right structure
featnumber = size(feat.data, 3);
ind_data = arrayfun(@(x) concatenate_data(x, featnumber, feat), indices, 'UniformOutput', false);
num_animals = size(feat.data, 1);
%initialize the frames_e cell array
frames_e = cell(num_animals, 1);
%go through the frametable and add the data into the frames_e array
%the frames_e array should contain all the frame numbers of the frames to be
%analyzed. It will further be used to index into the data array
for i = 1:height(frametable)
    for j = 3:2:width(frametable)
        start = frametable{i, j};

        %remove 0's
        start(isnan(start)) = 0;
        start = start(start > 0);
        ending = frametable{i, (j + 1)};

        %remove 0's
        ending(isnan(ending)) = 0;
        ending = ending(ending > 0);

        frames_e{frametable.Var2(i)} = [frames_e{frametable.Var2(i)}, [start:ending]];


    end
end
%select only the frames that are specified in frames_e
frames = cellfun(@(indiv, frames) indiv(frames, :), ind_data, frames_e, 'UniformOutput', false);
frames_indexed = cellfun(@(cell1, cell2) {cell1, cell2}, frames, num2cell(indices), 'UniformOutput', false);
