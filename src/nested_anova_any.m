function [p,p2,p3]= nested_anova_any(filenamelist,variablename)
data=readfiles(filenamelist,variablename);
outfilelist1=appendgroupvar1(data);
outfilelist=appendgroupvar2(outfilelist1);
flattened1=horzcat(outfilelist{:});
flattened2=horzcat(flattened1{:});
data=flattened2(1,:);
group=flattened2(2,:);
group2=flattened2(3,:);
p=anovan(data,{group,group2},'nested',[0 0; 1 0],'varnames',{'genotypes','chamber'},'alpha',0.005);
p2 = anova1(data,group);
p3 = anova1(data,group2);
function outfiles=readfiles(filenamelist,variablename)
raw=cell(numel(filenamelist),1);
for i=1:numel(filenamelist)
    load (char(filenamelist(i)),variablename);
    raw{i}=eval(variablename);
end
outfiles=raw;

function outfiles=appendgroupvar1(input)
disp(numel(input));
indices=(transpose(1:numel(input)));
indicescell=arrayfun(@(a) a,indices,'uni',false);
inputcell=arrayfun(@(a) a,input,'uni',false);
outfiles=cellfun(@(index,cellarr)cellfun(@(cell) [cell;arrayfun(@(numb) index,cell)],cellarr,'uni',false),indicescell,input,'uni',false);

function outfiles=appendgroupvar2(input)
indices=cellfun(@(row) (1:numel(row)),input,'uni',false);
indicescell=cellfun(@(cell)arrayfun(@(a) a,cell,'uni',false),indices,'uni',false);

outfiles=cellfun(@(index,cellarr)cellfun(@(cell,ind) [cell;arrayfun(@(numb) ind,cell(1,:))],cellarr,index,'uni',false),indicescell,input,'uni',false);






