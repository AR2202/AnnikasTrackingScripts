
function pdfs_female_pos_ipsi_contra(inputfilename,outputdir)
%Annika Rings, modified April 2019
%
%PDFS_FEMALE_POS_IPSI_CONTRA finds the position of the female relative to
%the male and of the male relative to the female during wing extension of
%the male
%the input arguments are:
%inputfilename: name of file to work on
%outputdir: name of directory for saving outputs

%calling data handling function
[wing_ext_frames_indexed]= handle_track_and_feat_outputs(inputfilename);
%loading calibration file to extract the scaling (PPM)
calibfilename=strcat(inputfilename,'-calibration.mat');
load(calibfilename);
ppm=calib.PPM;
%preprocessing data
indices=transpose(1:size(wing_ext_frames_indexed,1));
wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), wing_ext_frames_indexed,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
wing_ext_frames_nonempty=wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),wing_ext_frames_indexed));
%calculating female position relative to male
yrel=cellfun(@(indiv)arrayfun(@(theta,dist)calculate_yrel(theta,dist),indiv{1}(:,12),indiv{1}(:,10)),wing_ext_frames_nonempty,'uni',false);
xrel=cellfun(@(indiv,ind)arrayfun(@(ori,xmale,xfemale,right,left,y_rel)calculate_xrel(ori,xmale,xfemale,right,left,y_rel,ppm),indiv{1}(:,3),indiv{1}(:,1),indiv{1}(:,4),indiv{1}(:,16),indiv{1}(:,14),ind),wing_ext_frames_nonempty,yrel,'uni',false);
xrel_from_feat=cellfun(@(indiv)arrayfun(@(theta,dist)calculate_xrel_from_feat(theta,dist),indiv{1}(:,12),indiv{1}(:,10)),wing_ext_frames_nonempty,'uni',false);
%calculating male position relative to female

%in the case of the male, right and left wing angles were swapped, so in
%that case, the names of the arguments to the functions don't make sense.
%This is due to 'ipsi' and 'contra' having a different meaning when male
%position relative to female is examined.
yrel_male=cellfun(@(indiv)arrayfun(@(theta,dist)calculate_yrel(theta,dist),indiv{1}(:,13),indiv{1}(:,10)),wing_ext_frames_nonempty,'uni',false);
xrel_male=cellfun(@(indiv,ind)arrayfun(@(ori_f,xfemale,xmale,right,left,y_rel_male)calculate_xrel(ori_f,xmale,xfemale,left,right,y_rel_male,ppm),indiv{1}(:,9),indiv{1}(:,1),indiv{1}(:,4),indiv{1}(:,16),indiv{1}(:,14),ind),wing_ext_frames_nonempty,yrel_male,'uni',false);
xrel_from_feat_male=cellfun(@(indiv)arrayfun(@(theta,dist)calculate_xrel_from_feat(theta,dist),indiv{1}(:,13),indiv{1}(:,10)),wing_ext_frames_nonempty,'uni',false);





%saving data for female
  female_pos=cellfun(@(x, y,x2) struct('data',{x,y,x2}),xrel, yrel,xrel_from_feat,'UniformOutput',false);
  cellfun(@(data,index)savefemalepos(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_female_pos.mat'),data),female_pos,wing_ext_frames_nonempty,'UniformOutput',false);
%saving data for male  
  male_pos=cellfun(@(x, y,x2) struct('data',{x,y,x2}),xrel_male, yrel_male,xrel_from_feat_male,'UniformOutput',false);
  cellfun(@(data,index)savemalepos(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_male_pos.mat'),data),male_pos,wing_ext_frames_nonempty,'UniformOutput',false);



function [xrel,yrel]=female_pos(theta,dist,ori,xmale,xfemale)
    %added for testing purposes - function not used in actual code
yrel=calculate_yrel(theta,dist);
xrel=calculate_xrel(ori,xmale,xfemale,yrel);


function yrel=calculate_yrel(theta,dist)
    %calculates relative y value based on data from feat.mat
yrel=dist*cos(theta);



function xrel=calculate_xrel_from_feat(theta,dist)
    %calculates relative x value based on data from feat.mat - this does
    %not contain information about whether fly is on left or right side
    %relative to the other
xrel=dist*sin(theta);

function xrel=calculate_xrel(ori,xmale,xfemale,right_angle,left_angle,yrel,ppm)
    %function calculates xrel based on track.mat file
xmale_mm=xmale/ppm;
xfemale_mm=xfemale/ppm;
%in the case of the male, right and left wing angles were swapped, so in
%that case, the names of the arguments to the functions don't make sense.
%This is due to 'ipsi' and 'contra' having a different meaning when male
%position relative to female is examined.
%determining whether ipsi or contralateral wing is extended.
if abs(right_angle)>abs(left_angle)
    xrel = (xfemale_mm - (cos(ori)*yrel+xmale_mm))/(sin(ori));
else
    xrel = -(xfemale_mm - (cos(ori)*yrel+xmale_mm))/(sin(ori));
end 
if xrel >20||xrel<-20
    xrel=nan;
end
function savefemalepos(outputdir,filename,female_pos)
currentdir=pwd;
 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'female_pos');
 cd(currentdir);

 function savemalepos(outputdir,filename,male_pos)
currentdir=pwd;
 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'male_pos');
 cd(currentdir);

