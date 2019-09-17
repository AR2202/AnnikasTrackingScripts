

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
        %disp(['Now calculating wingindex for:' subdirname]);
        cd(subdirname);
        disp(['Now calculating wingindex for:' subdirname]);
        cd(subdirname);
        error_handling_wrapper('wingindex_allframes_errors.log','wing_index_tracking_allframes',subdirname);
        %pdfplot(string(subdirname),'pdfs');
        cd (startdir);
        cd(dirname);
    end
    cd (startdir);
end


