%DISTANCE_TRAVELLED calculates the distance the flies in 'inputfilename'
%have travelled over the total duration specified as the 'dur'
%input parameter
%does not remove copulation frames or filter by wingextension

function distance_travelled_frame(inputfilename,dur,framefilename)




outputdir = 'distance_travelled';
columnnumber =1;  %for vel
framerate =25; %fps
%turn the inputfilename into the specific names for the feat.mat and the

inputfilename_full=strcat(inputfilename,'-feat.mat');


maxframes = round(framerate*dur);
load(inputfilename_full);


indices=transpose(1:size(feat.data,1));
%concatenate all the data into a cell array with the right structure
featnumber = size(feat.data,3);
ind_data=arrayfun(@(x) concatenate_data(x,featnumber, feat),indices,'UniformOutput',false);


frametable=readtable(framefilename);
%remove NaNs
frametable=rmmissing(frametable);


num_animals = size(feat.data,1);
%initialize the frames_e cell array
frames_e = cell(num_animals,1);
%go through the frametable and add the data into the frames_e array
%the frames_e array should contain all the frame numbers of the frames to be
%analyzed. It will further be used to index into the data array
for i=1:height(frametable)
     
        start=frametable{i,3};
       
        %remove 0's
        start(isnan(start))=0;
        start=start(start>0);
        ending=frametable{i,4};
        
        %remove 0's
        ending(isnan(ending))=0;
        ending=ending(ending>0);
        if maxframes<(ending-start)
            ending = start + maxframes;
        end
       
        frames_e{frametable.Var2(i)}=[frames_e{frametable.Var2(i)},[start:ending]];
   
    
    
    

  
end
%select only the frames that are specified in frames_e
frames=cellfun(@(indiv,frames) indiv(frames,:),ind_data,frames_e,'UniformOutput',false);
frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, frames,num2cell(indices),'UniformOutput',false);





%remove NaNs
frames_indexed=cellfun(@(input)fillmissing(input{1,1},'linear'), frames_indexed,'UniformOutput',false);
%add indices
frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, frames_indexed,num2cell(indices),'UniformOutput',false);
%remove empty cells
frames_nonempty=frames_indexed(~cellfun(@(cells) isempty(cells{1}),frames_indexed));


%make the means
totaldists=cellfun(@(wing_ext_frames_ind) sumdfdx(wing_ext_frames_ind{1}(:,columnnumber),framerate), frames_nonempty,'UniformOutput',false);

data=cellfun(@(m) struct('dist',m),totaldists,'UniformOutput',false);
%save the structure into a seperate .mat file for each individual in a
%subdirectory called 'distance_travelled'
%this calls the savepdf function
cellfun(@(data,index)savedata(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_distance_travelled.mat'),data),data,frames_nonempty,'UniformOutput',false);
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