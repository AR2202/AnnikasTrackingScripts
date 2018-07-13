
function [wing_ext_frames_nonempty,pdfdata_all]= pdfplot(wing_ext_frames_indexed)
indices=transpose(1:size(wing_ext_frames_indexed,1));
wing_ext_frames_indexed=cellfun(@(input)rmmissing(input{1,1}), wing_ext_frames_indexed,'UniformOutput',false);
wing_ext_frames_indexed=cellfun(@(cell1,cell2) {cell1,cell2}, wing_ext_frames_indexed,num2cell(indices),'UniformOutput',false);
 wing_ext_frames_nonempty=wing_ext_frames_indexed(~cellfun(@(cells) isempty(cells{1}),wing_ext_frames_indexed));
[f_wing,xi_wing]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,4))*(360/(2*pi))), wing_ext_frames_nonempty,'UniformOutput',false);
cellfun(@(xi1,f1,index) newfigplot(xi1,f1,'wing angle',num2str(index{1,2})), xi_wing,f_wing,wing_ext_frames_nonempty,'UniformOutput',false);
[f_facing,xi_facing]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,12))*(360/(2*pi))), wing_ext_frames_nonempty,'UniformOutput',false);
cellfun(@(xi1,f1,index) newfigplot(xi1,f1,'facing angle',num2str(index{1,2})), xi_facing,f_facing,wing_ext_frames_nonempty,'UniformOutput',false);
[f_dist,xi_dist]=cellfun(@(wing_ext_frames_ind) ksdensity((wing_ext_frames_ind{1}(:,10))), wing_ext_frames_nonempty,'UniformOutput',false);
cellfun(@(xi1,f1,index) newfigplot(xi1,f1,'distance to other',num2str(index{1,2})), xi_dist,f_dist,wing_ext_frames_nonempty,'UniformOutput',false);
pdfdata_all=cellfun(@(xi_wing,f_wing, xi_facing, f_facing,xi_dist,f_dist) struct('wingangle',{xi_wing,f_wing},'facingangle',{xi_facing,f_facing},'distance',{xi_dist,f_dist}),xi_wing,f_wing, xi_facing, f_facing,xi_dist,f_dist,'UniformOutput',false);


function newfigplot(x,f,figname,flynumber)
fullfigname=strcat(figname,flynumber);
fignew=figure('Name',fullfigname);
plot(x,f)

function saveimage(outputdir,fullfigname,fignew)
 if ~exist(outputdir,dir)
     mkdir outputdir
 end
 cd(outputdir);
 saveas(fignew,fullfigname,'epsc');
 
 function savepdf(outputdir,filename,pdfdata)

 if ~exist(outputdir,'dir')
     mkdir (outputdir);
 end
 cd(outputdir);
 save(filename,'pdfdata');
 
