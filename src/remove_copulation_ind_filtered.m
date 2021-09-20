function [filtered_frames_ind] = remove_copulation_ind_filtered(filename, filterby, cutoffval, above)

load(filename);
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
featnumber = size(feat.data, 3);
ind_data = arrayfun(@(x) concatenate_data(x, featnumber, feat), indices, 'UniformOutput', false);
%check if feature 10 exists, which is needed for copulation frame
%determination. If not, don't remove copulation frames
if featnumber < 10
    if above
        filtered_frames = cellfun(@(indiv) indiv(indiv(:, filterby) > cutoffval, :), ind_data, 'UniformOutput', false);
    else
        filtered_frames = cellfun(@(indiv) indiv(indiv(:, filterby) < cutoffval, :), ind_data, 'UniformOutput', false);

    end

else

    %removing copulation frames - depends on feature number 10 (distance
    %between)
    %if non-existent (for example, single fly) this part is not used
    contact_frames = cellfun(@(indiv) indiv(indiv(:, 10) < 2.5, :), ind_data, 'UniformOutput', false);
    contact = cellfun(@(indiv) (indiv(:, 10) < 2.5), ind_data, 'UniformOutput', false);
    contact = cellfun(@(above) [false; above; false], contact, 'uni', false);
    edges_contact = cellfun(@(above) diff(above), contact, 'UniformOutput', false);
    rising_contact = cellfun(@(edge) find(edge == 1), edges_contact, 'UniformOutput', false); %rising/falling edges
    falling_contact = cellfun(@(edge) find(edge == -1), edges_contact, 'UniformOutput', false); %rising/falling edges
    spanWidth_contact = cellfun(@(rise, fall) fall-rise, rising_contact, falling_contact, 'UniformOutput', false); %width of span of 1's (above threshold)
    wideEnough_contact = cellfun(@(span) span >= 1500, spanWidth_contact, 'UniformOutput', false);
    startPos_contact = cellfun(@(rise, wideenough) transpose(rise(wideenough)), rising_contact, wideEnough_contact, 'UniformOutput', false); %start of each span
    tf = cellfun('isempty', startPos_contact); % true for empty cells
    startPos_contact(tf) = {15000};

    frames_no_cop = cellfun(@(indiv, start_c) indiv(1:start_c, :), ind_data, startPos_contact, 'UniformOutput', false);


    if above
        filtered_frames = cellfun(@(indiv) indiv(indiv(:, filterby) > cutoffval, :), frames_no_cop, 'UniformOutput', false);
    else
        filtered_frames = cellfun(@(indiv) indiv(indiv(:, filterby) < cutoffval, :), frames_no_cop, 'UniformOutput', false);

    end
end
filtered_frames_ind = cellfun(@(cell1, cell2) {cell1, cell2}, filtered_frames, num2cell(indices), 'UniformOutput', false);
