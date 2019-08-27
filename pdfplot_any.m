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
%score: name of the score from JAABA (default WingGesture)
%windowsize: size of the moving average window (in frames) (default=13)
%cutofffrac: fraction of the frames that have to be positive for the event
%in the specified window (default 0.5)
%fromscores: if true, the data are taken from a JAABA scores file (default false)
%specificframes: if true, it expects a .csv file that contains the start
%and end frames of the frame ranges that should be analyzed. Several frame ranges can be
%specified, starting from column 3 in the .csv file. Each pair of 2 columns
%has to be a pair of start and endframes for the desired range.
%The flyID needs to be in column 2
%The file has to be located in
%the video directory and be called '<videoname>_frames.csv' where videoname
%is the name of the videodirectory it is in. (default false)
%filterby: column number (of the feat.mat file) which should be used for
%filtering frames. Must be a number between 1-13. Allows for additional
%filtering when the 'specificframes' option
%is set. (default: no additional filtering)
%cutoffval: if filterby is selected, this is the value above or below which
%the feature should be for the frames to be selected. (default:2)
%above: if filterby is selected, this specifies whether you want to use
%frames that are above or below cutoffval (default: true)
%
%if specificframes is set to false (default), copulationframes are removed
%
%
%DEPENDENCIES: depends on the following functions (which have to be in the
%current path or the MATLAB search path):
%handle_flytracker_outputs_var
%handle_flytracker_outputs_score
%remove_copulation_ind
%newfigplot
%savepdf

function pdfplot_any(inputfilename,outputdir,expname,columnnumber,varargin)


options = struct('scaling',1,'wingdur',13,'wingextonly',true,'minwingangle',30,'fromscores',false,'windowsize',13,'cutofffrac',0.5,'score','WingGesture','specificframes',false,'filterby',0,'cutoffval',2,'above',true);

%# read the acceptable names
optionNames = fieldnames(options);

%# count arguments - throw exception if the number is not divisible by 2
nArgs = length(varargin);
if round(nArgs/2)~=nArgs/2
    error('pdfplot_any called with wrong number of arguments: expected Name/Value pair arguments')
end

for pair = reshape(varargin,2,[]) %# pair is {propName;propValue}
    inpName = lower(pair{1}); %# make case insensitive
    %check if the entered key is a valid key. If yes, replace the default by
    %the caller specified value. Otherwise, throw and exception
    if any(strcmp(inpName,optionNames))
        
        options.(inpName) = pair{2};
    else
        error('%s is not a recognized parameter name',inpName)
    end
end
%turn the inputfilename into the specific names for the feat.mat and the
%frames.csv file
inputfilename_full=strcat(inputfilename,'-feat.mat');
inputfilename_frames=strcat('../',inputfilename,'_frames.csv');
%this block gets all the values from the optional function arguments
%for all arguments that were not specified, the default is used
wingdur=options.wingdur;
wingextonly=options.wingextonly;
scaling=options.scaling;
minwingangle=options.minwingangle*pi/180;

fromscores=options.fromscores;
windowsize=options.windowsize;
cutofffrac=options.cutofffrac;
score=options.score;
specificframes=options.specificframes;
filterby = options.filterby;
cutoffval = options.cutoffval;
above = options.above;
%array of the maximum expected values for the features;
maxs=[100;30;pi;pi;20;5;10;1;20;20;pi;pi;20];
max_=maxs(columnnumber)*scaling;
pts=(0:(max_/99):max_);


%check if the filterby option was set to a valid value and if so,
%set filter to true -otherwise set
%filter to false
filter =0;
if (0< filterby && filterby <14)
    filter =1;
    wingextonly= false;
    disp('filtering data by');
    disp(string(filterby));
end
%make the pathname for the scoresfile out of the inputfilename
scorename=strcat(inputfilename,'_JAABA/','scores_',score,'_id_corrected.mat');
%check which options were set and call the respective function
%for specificframes, call function: handle_flytracker_output_frame_filtered
%if filter is true, otherwise call:handle_flytracker_output_frame
%if fromscores is set, call:handle_flytracker_outputs_score (this option is
%discarded if specificframes is set to true)
%if wingextension only is set, call: handle_flytracker_outputs_var
%(this option is discarded if specificframes or fromscores is set to true)
%in all other cases, call: remove_copulation_ind
%all options other than specificframes remove copulation frames
%
%the functions return a the filtered data saved into a variable called
%wing_ext_frames_indexed
if specificframes
    if filter
        wing_ext_frames_indexed=handle_flytracker_output_frame_filtered(inputfilename_full,inputfilename_frames,filterby,cutoffval,above);
        
    else
        wing_ext_frames_indexed=handle_flytracker_output_frame(inputfilename_full,inputfilename_frames);
    end
elseif fromscores
    wing_ext_frames_indexed=handle_flytracker_outputs_score(inputfilename_full,scorename,windowsize,cutofffrac);
elseif wingextonly
    [wing_ext_frames_indexed]= handle_flytracker_outputs_var(inputfilename_full,wingdur,minwingangle);
else
    if filter
        wing_ext_frames_indexed=remove_copulation_ind_filtered(inputfilename_full,filterby, cutoffval, above);
    else
    wing_ext_frames_indexed=remove_copulation_ind(inputfilename_full);
    end
end
%make indices to remember the flyID if rows are removed from the matrix
indices=transpose(1:size(wing_ext_frames_indexed,1));
%remove NaNs
wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), wing_ext_frames_indexed,'UniformOutput',false);
%add indices
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
%remove empty cells
wing_ext_frames_nonempty=wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),wing_ext_frames_indexed));
%make the kernel density estimation for each individual
[f_data,xi_data]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,columnnumber))*scaling,pts), wing_ext_frames_nonempty,'UniformOutput',false);
%plot the data for each individual
%this calls the newfigplot function
cellfun(@(xi1,f1,index) newfigplot(xi1,f1,expname,num2str(index{1,2}),inputfilename,outputdir), xi_data,f_data,wing_ext_frames_nonempty,'UniformOutput',false);
%make a structure called 'pdfdata' which contains the data returned from
%the kde
pdfdata=cellfun(@(xi_data, f_data) struct(expname,{xi_data,f_data}),xi_data, f_data,'UniformOutput',false);
%save the structure into a seperate .mat file for each individual in a
%subdirectory called 'pdfs'
%this calls the savepdf function
cellfun(@(data,index)savepdf(outputdir,strcat(inputfilename,'_',num2str(index{1,2}),'_',expname,'_pdf.mat'),data),pdfdata,wing_ext_frames_nonempty,'UniformOutput',false);
%close figure windows
close all;



