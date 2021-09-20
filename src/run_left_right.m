dirs = dir('*Courtship');

for p = 1:numel(dirs)
    if ~dirs(p).isdir
        continue;
    end
    dirname = dirs(p).name;
    if ismember(dirname, {'.', '..'})
        continue;
    end
    startdir = pwd;
    cd(dirname);

    subdirs = dir();
    for q = 1:numel(subdirs)
        if ~subdirs(q).isdir
            continue;
        end
        subdirname = subdirs(q).name;
        if ismember(subdirname, {'.', '..'})
            continue;
        end
        disp(['Now printing left-right for:', subdirname]);

        error_handling_wrapper('left_right_table_errors.log', 'left_right_table', subdirname);

        cd(startdir);
        cd(dirname);
    end
    cd(startdir);
end
