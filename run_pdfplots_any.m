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
%
%DEPENDENCIES: depends on the following functions (which have to be in the
%current path or the MATLAB search path):
%pdfplot_any
%handle_flytracker_outputs_var
%remove_copulation_ind
%newfigplot
%savepdf
%error_handling_wrapper

function run_pdfplots_any(expname,columnnumber,varargin)

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
        error_handling_wrapper('pdfplot_errors.log','pdfplot_any',subdirname,'pdfs',expname,columnnumber,'scaling',scaling,'wingdur',wingdur,'wingextonly',wingextonly,'minwingangle',minwingangle);
      
        cd (startdir);
        cd(dirname);
    end
    cd (startdir);
end


