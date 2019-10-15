
function [yrel_r,yrel_l,xrel_r,xrel_l]=pdfs_female_pos(inputfilename,outputdir)
[right_wing_ext_frames_indexed, left_wing_ext_frames_indexed]= handle_track_outputs(inputfilename);
calibfilename=strcat(inputfilename,'-calibration.mat');
load(calibfilename);
ppm=calib.PPM;
indices=transpose(1:size(right_wing_ext_frames_indexed,1));
right_wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), right_wing_ext_frames_indexed,'UniformOutput',false);
right_wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, right_wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
right_wing_ext_frames_nonempty=right_wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),right_wing_ext_frames_indexed));
yrel_r=cellfun(@(indiv)arrayfun(@(theta,dist)calculate_yrel(theta,dist),indiv{1}(:,12),indiv{1}(:,10)),right_wing_ext_frames_nonempty,'uni',false);
xrel_r=cellfun(@(indiv,ind)arrayfun(@(ori,xmale,xfemale,yrel)calculate_xrel(ori,xmale,xfemale,yrel,ppm),indiv{1}(:,3),indiv{1}(:,1),indiv{1}(:,4),ind),right_wing_ext_frames_nonempty,yrel_r,'uni',false);


left_wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), left_wing_ext_frames_indexed,'UniformOutput',false);
left_wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, left_wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
left_wing_ext_frames_nonempty=left_wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),left_wing_ext_frames_indexed));
yrel_l=cellfun(@(indiv)arrayfun(@(theta,dist)calculate_yrel(theta,dist),indiv{1}(:,12),indiv{1}(:,10)),left_wing_ext_frames_nonempty,'uni',false);
xrel_l=cellfun(@(indiv,ind)arrayfun(@(ori,xmale,xfemale,yrel)calculate_xrel(ori,xmale,xfemale,yrel,ppm),indiv{1}(:,3),indiv{1}(:,1),indiv{1}(:,4),ind),left_wing_ext_frames_nonempty,yrel_l,'uni',false);





  female_pos=cellfun(@(x_r, y_r,x_l,y_l) struct('right',{x_r,y_r},'left',{x_l,y_l}),xrel_r, yrel_r,xrel_l,yrel_l,'UniformOutput',false);
  cellfun(@(data,index)savefemalepos(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_female_pos.mat')),female_pos,right_wing_ext_frames_nonempty,'UniformOutput',false);
% close all;

function [xrel,yrel]=female_pos(theta,dist,ori,xmale,xfemale)
yrel=calculate_yrel(theta,dist);
xrel=calculate_xrel(ori,xmale,xfemale,yrel);


function yrel=calculate_yrel(theta,dist)
yrel=dist*cos(theta);



function xrel=calculate_xrel(ori,xmale,xfemale,yrel,ppm)
xmale_mm=xmale/ppm;
xfemale_mm=xfemale/ppm;


xrel = (xfemale_mm - (cos(ori)*yrel+xmale_mm))/(sin(ori));
function savefemalepos(outputdir,filename)
currentdir=pwd;
 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'female_pos');
  cd(currentdir);


