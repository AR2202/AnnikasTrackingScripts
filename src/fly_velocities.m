function correlation_coef=fly_velocities(inputfilename,outputdir)
inputfilename_full=strcat(inputfilename,'-feat_id_corrected.mat');
load(inputfilename_full);
indices=transpose(1:size(feat.data,1));
veldata=feat.data(:,:,1);
ind_data=arrayfun(@(x) horzcat(transpose(feat.data(x,:,1)),transpose(feat.data(x,:,2)),transpose(feat.data(x,:,3)),transpose(feat.data(x,:,4)),transpose(feat.data(x,:,5)),transpose(feat.data(x,:,6)),transpose(feat.data(x,:,7)),transpose(feat.data(x,:,8)),transpose(feat.data(x,:,9)),transpose(feat.data(x,:,10)),transpose(feat.data(x,:,11)),transpose(feat.data(x,:,12)),transpose(feat.data(x,:,13))),indices,'UniformOutput',false);
contact_frames=cellfun(@(indiv) indiv(indiv(:,10)<2.5,:),ind_data,'UniformOutput',false);
contact=cellfun(@(indiv) (indiv(:,10)<2.5),ind_data,'UniformOutput',false);
contact=cellfun(@(above) [false;above;false],contact,'uni',false);
edges_contact = cellfun(@(above) diff(above),contact,'UniformOutput',false);
rising_contact = cellfun(@(edge) find(edge==1),edges_contact,'UniformOutput',false);    %rising/falling edges
falling_contact = cellfun(@(edge) find(edge==-1),edges_contact,'UniformOutput',false);    %rising/falling edges
spanWidth_contact = cellfun(@(rise,fall) fall-rise,rising_contact,falling_contact,'UniformOutput',false);  %width of span of 1's (above threshold)
wideEnough_contact = cellfun(@(span) span >= 1500,spanWidth_contact,'UniformOutput',false);    
startPos_contact = cellfun(@(rise,wideenough) transpose(rise(wideenough)),rising_contact,wideEnough_contact,'UniformOutput',false);    %start of each span
tf = cellfun('isempty',startPos_contact); % true for empty cells
startPos_contact(tf) = {15000} ; 
vel=arrayfun(@(x)transpose(feat.data(x,1:startPos_contact{x},1)),indices,'uni',false);

  vel_odd=veldata(isOdd(indices),:);
  vel_even=veldata(~isOdd(indices),:);
 %vel=cellfun(@(input)rmmissing(input{1,1}), vel,'UniformOutput',false);
vel_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, vel,num2cell(indices),'UniformOutput',false);
vel_nonempty=vel_indexed(~cellfun(@(cells) isempty(cells{1}),vel_indexed));
 [f_vel,xi_vel]=cellfun(@(vel_ind) ksdensity((vel_ind{1}(:,1))), vel_nonempty,'UniformOutput',false);
 cellfun(@(xi1,f1,index) newfigplot(xi1,f1,'velocity',num2str(index{1,2}),inputfilename,outputdir), xi_vel,f_vel,vel_nonempty,'UniformOutput',false);
% 
 correlation_coef=arrayfun(@(ind)correlate_vels(ind,vel_odd,vel_even,startPos_contact{ind}),indices,'uni',false);
 pdfdata_all=cellfun(@(xi_v, f_v,corr_coef) struct('velocity',{xi_v,f_v},'correlation',{corr_coef}),xi_vel, f_vel,correlation_coef,'UniformOutput',false);
 cellfun(@(data,index)savepdf(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_vel.mat'),data),pdfdata_all,vel_nonempty,'UniformOutput',false);
 close all;






