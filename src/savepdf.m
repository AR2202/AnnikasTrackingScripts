function savepdf(outputdir,filename,pdfdata)
currentdir=pwd;
 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'pdfdata');
  cd(currentdir);