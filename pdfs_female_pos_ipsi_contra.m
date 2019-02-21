
function pdfs_female_pos_ipsi_contra(inputfilename,outputdir)
[wing_ext_frames_indexed]= handle_track_and_feat_outputs(inputfilename);
calibfilename=strcat(inputfilename,'-calibration.mat');
load(calibfilename);
ppm=calib.PPM;
indices=transpose(1:size(wing_ext_frames_indexed,1));
wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), wing_ext_frames_indexed,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
wing_ext_frames_nonempty=wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),wing_ext_frames_indexed));
yrel=cellfun(@(indiv)arrayfun(@(theta,dist)calculate_yrel(theta,dist),indiv{1}(:,12),indiv{1}(:,10)),wing_ext_frames_nonempty,'uni',false);
xrel=cellfun(@(indiv,ind)arrayfun(@(ori,xmale,xfemale,right,left,y_rel)calculate_xrel(ori,xmale,xfemale,right,left,y_rel,ppm),indiv{1}(:,3),indiv{1}(:,1),indiv{1}(:,4),indiv{1}(:,16),indiv{1}(:,14),ind),wing_ext_frames_nonempty,yrel,'uni',false);


  female_pos=cellfun(@(x, y) struct('data',{x,y}),xrel, yrel,'UniformOutput',false);
  cellfun(@(data,index)savefemalepos(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_female_pos.mat'),data),female_pos,wing_ext_frames_nonempty,'UniformOutput',false);
% close all;

function [xrel,yrel]=female_pos(theta,dist,ori,xmale,xfemale)
yrel=calculate_yrel(theta,dist);
xrel=calculate_xrel(ori,xmale,xfemale,yrel);


function yrel=calculate_yrel(theta,dist)
yrel=dist*cos(theta);



function xrel=calculate_xrel(ori,xmale,xfemale,right_angle,left_angle,yrel,ppm)
xmale_mm=xmale/ppm;
xfemale_mm=xfemale/ppm;

if abs(right_angle)>abs(left_angle)
    xrel = (xfemale_mm - (cos(ori)*yrel+xmale_mm))/(sin(ori));
else
    xrel = -(xfemale_mm - (cos(ori)*yrel+xmale_mm))/(sin(ori));
end  
function savefemalepos(outputdir,filename,female_pos)
currentdir=pwd;
 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'female_pos');
 cd(currentdir);


