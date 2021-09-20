%function newfigplot has side effects
function newfigplot(x, f, figname, flynumber, inputfilename, outputdir)
fullfigname = strcat(figname, flynumber);
fignew = figure('Name', fullfigname);
plot(x, f)
imagename = strcat(inputfilename, '_', flynumber, '_', figname);
saveimage(outputdir, imagename, fignew);

%function saveimage has side effects
function saveimage(outputdir, fullfigname, fignew)
currentdir = pwd;
if ~exist(outputdir, 'dir')
    mkdir(outputdir);
end
cd(outputdir);
saveas(fignew, fullfigname, 'epsc');
cd(currentdir);
