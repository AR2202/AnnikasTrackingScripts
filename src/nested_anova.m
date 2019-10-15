function p= nested_anova(filenamelist)
data=readfiles(filenamelist);
outfilelist1=appendgroupvar1(data);
outfilelist=appendgroupvar2(outfilelist1);
flattened1=vertcat(outfilelist{:});
flattened2=horzcat(flattened1{:});
data=flattened2(1,:);
group=flattened2(2,:);
group2=flattened2(3,:);
p=anovan(data,{group,group2},'nested',[0 0; 1 0],'varnames',{'genotypes','individual'},'alpha',0.005);

function outfiles=readfiles(filenamelist)
raw=cell(numel(filenamelist),1);
for i=1:numel(filenamelist)
    load (char(filenamelist(i)));
    raw{i}=figuredata.rawdata;
end
outfiles=raw;

function outfiles=appendgroupvar1(input)
indices=transpose(1:numel(input));
indicescell=arrayfun(@(a) a,indices,'uni',false);
outfiles=cellfun(@(index,cellarr)cellfun(@(cell) [cell;arrayfun(@(numb) index,cell)],cellarr,'uni',false),indicescell,input,'uni',false);

function outfiles=appendgroupvar2(input)
indices=cellfun(@(row) transpose(1:numel(row)),input,'uni',false);
indicescell=cellfun(@(cell)arrayfun(@(a) a,cell,'uni',false),indices,'uni',false);
outfiles=cellfun(@(index,cellarr)cellfun(@(cell,ind) [cell;arrayfun(@(numb) ind,cell(1,:))],cellarr,index,'uni',false),indicescell,input,'uni',false);






