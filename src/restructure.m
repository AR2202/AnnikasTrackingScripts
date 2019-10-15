function [dirs]=restructure()
currentdir=pwd;
dirs=dir('*Courtship');


dirnames=arrayfun(@(f) f.name,dirs,'UniformOutput',false);
disp(dirnames)
for dirnum= 1:length(dirnames)
    if isdir(dirnames{dirnum})
        cd(dirnames{dirnum});
        videos=dir();
        videonames=arrayfun(@(f) f.name,videos,'UniformOutput',false);
        disp(videonames);
        for video=1:length(videonames)
            if isdir(videonames{dirnum})
               %movefile(videonames{dirnum}, '../pdfs_made');
               copyfile(videonames{dirnum},'../pdfs_made');
            end
        end
        cd(currentdir);
    end
end
    
