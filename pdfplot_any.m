%Annika Rings, April 2019
%a more generic version of the pdfplot function
%
%PDFPLOT_ANY is a function that creates probability density plots
%the input arguments are:
%
%INPUTFILENAME: name of the video
%OUTPUTDIR: path to the directory where the results should be stored
%EXPNAME: name of the parameter of which the pdf is to be plotted (only
%used for nameing the figure and the field in the output data structure)
%COLUMNNUMBER: number of the column in the -feat.mat file that the desired parameter is stored in 
%  vel=1;
%  ang_vel=2;
%  min_wing_ang=3;
%  max_wing_ang=4;
%  mean_wing_length=5;
%  axis_ratio=6;
%  fg_body_ratio=7;
%  contrast=8;
%  dist_to_wall=9;
%  dist_to_other=10;
%  angle_between=11;
%  facing_angle=12;
%  leg_dist=13;
%OPTIONAL name/value pair arguments:
%SCALING: scaling to be applied to the data (default = 1)
%WINGDUR: minimum number of contiguous frames of wing extension to be
%counted as wing extension bouts (default = 13, based on Ribeiro et al., 2018)
%WINGEXTONLY: use only wing extension frames (default = true)
%MINWINGANGLE: minimum angle of the wing to body axis to be counted as wing
%extension (default = 30)
%
%DEPENDENCIES: depends on the following functions (which have to be in the
%current path or the MATLAB search path):
%handle_flytracker_outputs_var
%remove_copulation_ind
%newfigplot
%savepdf

function pdfplot_any(inputfilename,outputdir,expname,columnnumber,varargin)


options = struct('scaling',1,'wingdur',13,'wingextonly',true,'minwingangle',30);

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments
nArgs = length(varargin);
if round(nArgs/2)~=nArgs/2
   error('pdfplot_any called with wrong number of arguments: expected Name/Value pair arguments')
end

for pair = reshape(varargin,2,[]) %# pair is {propName;propValue}
   inpName = lower(pair{1}); %# make case insensitive

   if any(strcmp(inpName,optionNames))
     
      options.(inpName) = pair{2};
   else
      error('%s is not a recognized parameter name',inpName)
   end
end
wingdur=options.wingdur;
wingextonly=options.wingextonly;
scaling=options.scaling;
minwingangle=options.minwingangle*pi/180;
inputfilename_full=strcat(inputfilename,'-feat.mat');
if wingextonly
 [wing_ext_frames_indexed]= handle_flytracker_outputs_var(inputfilename_full,wingdur,minwingangle);
else
    wing_ext_frames_indexed=remove_copulation_ind(inputfilename_full);
end
indices=transpose(1:size(wing_ext_frames_indexed,1));
wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), wing_ext_frames_indexed,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
wing_ext_frames_nonempty=wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),wing_ext_frames_indexed));
[f_data,xi_data]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,columnnumber))*scaling), wing_ext_frames_nonempty,'UniformOutput',false);
cellfun(@(xi1,f1,index) newfigplot(xi1,f1,expname,num2str(index{1,2}),inputfilename,outputdir), xi_data,f_data,wing_ext_frames_nonempty,'UniformOutput',false);
pdfdata=cellfun(@(xi_data, f_data) struct(expname,{xi_data,f_data}),xi_data, f_data,'UniformOutput',false);
cellfun(@(data,index)savepdf(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),expname,'_pdf.mat'),data),pdfdata,wing_ext_frames_nonempty,'UniformOutput',false);
close all;
    

 
