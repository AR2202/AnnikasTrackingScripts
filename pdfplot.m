%function pdfplot has side effects
function pdfplot(inputfilename,outputdir)
inputfilename_full=strcat(inputfilename,'-feat_id_corrected.mat');
 [wing_ext_frames_indexed]= handle_flytracker_outputs(inputfilename_full);
indices=transpose(1:size(wing_ext_frames_indexed,1));
wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), wing_ext_frames_indexed,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
 wing_ext_frames_nonempty=wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),wing_ext_frames_indexed));
%[f_wing,xi_wing]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,4))*(360/(2*pi))), wing_ext_frames_nonempty,'UniformOutput',false);
%cellfun(@(xi1,f1,index) newfigplot(xi1,f1,'wing angle',num2str(index{1,2}),outputdir), xi_wing,f_wing,wing_ext_frames_nonempty,'UniformOutput',false);
%[f_facing,xi_facing]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,12))*(360/(2*pi))), wing_ext_frames_nonempty,'UniformOutput',false);
converted_angles=cellfun(@(facing_angle)arrayfun(@(angle)convert_angle(angle),facing_angle{1}(:,12)),wing_ext_frames_nonempty,'UniformOutput',false);
[f_facing,xi_facing]=cellfun(@(facing_angle_180) ksdensity(facing_angle_180*(360/(2*pi)),(0:180)), converted_angles,'UniformOutput',false);
cellfun(@(xi1,f1,index) newfigplot(xi1,f1,'facing_angle',num2str(index{1,2}),inputfilename,outputdir), xi_facing,f_facing,wing_ext_frames_nonempty,'UniformOutput',false);
[f_dist,xi_dist]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,10))), wing_ext_frames_nonempty,'UniformOutput',false);
cellfun(@(xi1,f1,index) newfigplot(xi1,f1,'distance_to_other',num2str(index{1,2}),inputfilename,outputdir), xi_dist,f_dist,wing_ext_frames_nonempty,'UniformOutput',false);
%[f_vel,xi_vel]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,1))), wing_ext_frames_nonempty,'UniformOutput',false);
%cellfun(@(xi1,f1,index) newfigplot(xi1,f1,'velocity',num2str(index{1,2}),outputdir), xi_vel,f_vel,wing_ext_frames_nonempty,'UniformOutput',false);

%pdfdata_all=cellfun(@(xi_wing,f_wing, xi_facing, f_facing,xi_dist,f_dist,xi_vel,f_vel) struct('wingangle',{xi_wing,f_wing},'facingangle',{xi_facing,f_facing},'distance',{xi_dist,f_dist},'velocity',{xi_vel,f_vel}),xi_wing,f_wing, xi_facing, f_facing,xi_dist,f_dist,xi_vel,f_vel,'UniformOutput',false);
pdfdata_all=cellfun(@(xi_facing, f_facing,xi_dist,f_dist) struct('facingangle',{xi_facing,f_facing},'distance',{xi_dist,f_dist}),xi_facing, f_facing,xi_dist,f_dist,'UniformOutput',false);
cellfun(@(data,index)savepdf(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_pdf.mat'),data),pdfdata_all,wing_ext_frames_nonempty,'UniformOutput',false);
close all;
function [angle_180]=convert_angle(angle)
if angle>pi
    angle_180=2*pi-angle;
else angle_180=angle;
end
%function savepdf has side effects

 
