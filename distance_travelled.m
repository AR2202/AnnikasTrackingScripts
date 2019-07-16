%  vel=1;

%
%DEPENDENCIES: 

function distance_travelled(inputfilename,dur)




outputdir = 'distance_travelled';
columnnumber =1;  %for vel
framerate =25; %fps
%turn the inputfilename into the specific names for the feat.mat and the
%frames.csv file
inputfilename_full=strcat(inputfilename,'-feat.mat');


endframe = round(25*dur);
load(inputfilename_full);


indices=transpose(1:size(feat.data,1));
%concatenate all the data into a cell array with the right structure
ind_data=arrayfun(@(x) horzcat(transpose(feat.data(x,:,1)),transpose(feat.data(x,:,2)),transpose(feat.data(x,:,3)),transpose(feat.data(x,:,4)),transpose(feat.data(x,:,5)),transpose(feat.data(x,:,6)),transpose(feat.data(x,:,7)),transpose(feat.data(x,:,8)),transpose(feat.data(x,:,9)),transpose(feat.data(x,:,10)),transpose(feat.data(x,:,11)),transpose(feat.data(x,:,12)),transpose(feat.data(x,:,13))),indices,'UniformOutput',false);


    
%select only the frames that are specified in frames_e
frames=cellfun(@(indiv) indiv(1:endframe,:),ind_data,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, frames,num2cell(indices),'UniformOutput',false);





%make indices to remember the flyID if rows are removed from the matrix
indices=transpose(1:size(wing_ext_frames_indexed,1));
%remove NaNs
wing_ext_frames_indexed=cellfun(@(input)fillmissing(input{1,1},'linear'), wing_ext_frames_indexed,'UniformOutput',false);
%add indices
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
%remove empty cells
wing_ext_frames_nonempty=wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),wing_ext_frames_indexed));


%make the means
totaldists=cellfun(@(wing_ext_frames_ind) sumdfdx(wing_ext_frames_ind{1}(:,columnnumber),framerate), wing_ext_frames_nonempty,'UniformOutput',false);

data=cellfun(@(m) struct('dist',m),totaldists,'UniformOutput',false);
%save the structure into a seperate .mat file for each individual in a
%subdirectory called 'distance_travelled'
%this calls the savepdf function
cellfun(@(data,index)savedata(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_distance_travelled.mat'),data),data,wing_ext_frames_nonempty,'UniformOutput',false);
%close figure windows
close all;

 function dist = sumdfdx (data,framerate)
dist = sum (data)*(1/framerate);

function savedata(outputdir,filename,data)
currentdir=pwd;
 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'data');
  cd(currentdir);