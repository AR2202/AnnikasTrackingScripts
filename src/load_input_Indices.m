function [outputtable, outputdir] = load_input_Indices(genotypelist, olddataformat)

outputdirname = 'Analysis';
pathname = pwd;


outputdir = fullfile(pathname, outputdirname);
    
if ~exist(outputdir, 'dir')
    disp('Results folder does not exist. Ceating folder:')
    disp(outputdir);
    mkdir(fullfile(outputdir));
end


   
outputtable = readtable(genotypelist, 'readvariablenames', false);
disp(outputtable);
