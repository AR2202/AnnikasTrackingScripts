
function [f_r,xi_r]=pdfs_female_pos(inputfilename,outputdir)
[right_wing_ext_frames_indexed, left_wing_ext_frames_indexed]= handle_track_outputs(inputfilename)

indices=transpose(1:size(right_wing_ext_frames_indexed,1));
right_wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), right_wing_ext_frames_indexed,'UniformOutput',false);
right_wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, right_wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
right_wing_ext_frames_nonempty=right_wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),right_wing_ext_frames_indexed));



[f_r,xi_r]=cellfun(@(wing_ext_frames_ind) ksdensity([wing_ext_frames_ind{1}(:,1) wing_ext_frames_ind{1}(:,2)]), right_wing_ext_frames_nonempty,'UniformOutput',false);


left_wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), left_wing_ext_frames_indexed,'UniformOutput',false);
left_wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, left_wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
left_wing_ext_frames_nonempty=left_wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),left_wing_ext_frames_indexed));



[f_l,xi_l]=cellfun(@(wing_ext_frames_ind) ksdensity([wing_ext_frames_ind{1}(:,1) wing_ext_frames_ind{1}(:,2)]), left_wing_ext_frames_nonempty,'UniformOutput',false);
% 
 pdfdata_all=cellfun(@(xi_r, f_r,xi_l,f_l) struct('right',{xi_r,f_r},'left',{xi_l,f_l}),xi_r, f_r,xi_l,f_l,'UniformOutput',false);
% cellfun(@(data,index)savepdf(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_pdf.mat'),data),pdfdata_all,wing_ext_frames_nonempty,'UniformOutput',false);
% close all;

function [xrel,yrel]=female_pos(theta,dist,ori,xmale,xfemale)
yrel=calculate_yrel(theta,dist)
xrel=calculate_xrel(ori,xmale,xfemale,yrel)


function yrel=calculate_yrel(theta,dist)
yrel=dist*cos(theta);


function xrel=calculate_xrel(ori,xmale,xfemale,yrel)

xproject = sin(ori)*yrel+xmale;

xrel = (xfemale - xproject)/(cos(ori));


