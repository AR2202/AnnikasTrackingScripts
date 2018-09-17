

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
        disp(['Now making pdfs for:' subdirname]);
        cd(subdirname);
        disp(['Now making pdfs for:' subdirname]);
        cd(subdirname);
        error_handling_wrapper('pdfplot_errors.log','pdfplot',subdirname,'pdfs');
        %pdfplot(string(subdirname),'pdfs');
    end
end
%cd (startdir);

