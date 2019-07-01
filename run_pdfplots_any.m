%Annika Rings, April 2019
%
%RUN_PDFPLOTS_ANY is a function that calls the pdfplot_any function for
%all videos in all subdirectories with names ending in 'Courtship'
%the input arguments are:
%
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
%score: name of the score from JAABA
%windowsize: size of the moving average window (in frames)
%cutofffrac: fraction of the frames that have to be positive for the event
%in the specified window
%fromscores: if true, the data are taken from a JAABA scores file (default false)
%specificframes: if true, it expects a .csv file that contains the start
%and end frames that should be analyzed. The start needs to be in column 3
%and the end in column 4 of the .csv file. The file has to be located in
%the video directory and be called '<videoname>_frames.csv' where videoname
%is the name of the videodirectory it is in.
%
%
%DEPENDENCIES: depends on the following functions (which have to be in the
%current path or the MATLAB search path):
%pdfplot_any
%handle_flytracker_outputs_var
%handle_flytracker_outputs_score
%remove_copulation_ind
%newfigplot
%savepdf
%error_handling_wrapper

function run_pdfplots_any(expname,columnnumber,varargin)

options = struct('scaling',1,'wingdur',13,'wingextonly',true,'minwingangle',30,'fromscores',false,'windowsize',13,'cutofffrac',0.5,'score','WingGesture','specificframes',false);

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
fromscores=options.fromscores;
windowsize=options.windowsize;
cutofffrac=options.cutofffrac;
score=options.score;
specificframes=options.specificframes;

dirs = dir('*Courtship');

for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname,{'.','..'})
        continue;
    end
    startdir = pwd;
    cd(dirname);
    
    subdirs=dir();
    for q = 1:numel(subdirs)
        if ~subdirs(q).isdir
            continue;
        end
        subdirname=subdirs(q).name;
        if ismember(subdirname,{'.','..'})
            continue;
        end
       
        cd(subdirname);
        disp(['Now making pdfs for:' subdirname]);
        cd(subdirname);
        if specificframes
            error_handling_wrapper('pdfplot_errors.log','pdfplot_any',subdirname,'pdfs',expname,columnnumber,'scaling',scaling,'specificframes',true);
        
        elseif fromscores
            error_handling_wrapper('pdfplot_errors.log','pdfplot_any',subdirname,'pdfs',expname,columnnumber,'windowsize',windowsize,'cutofffrac',cutofffrac,'scaling',scaling,'fromscores',true,'score',score);
        
        else
            error_handling_wrapper('pdfplot_errors.log','pdfplot_any',subdirname,'pdfs',expname,columnnumber,'scaling',scaling,'wingdur',wingdur,'wingextonly',wingextonly,'minwingangle',minwingangle);
        end
        cd (startdir);
        cd(dirname);
    end
    cd (startdir);
end


