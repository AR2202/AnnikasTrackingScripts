function [dur, spanW] = eventdur(filename, index, windowsize, cutofffrac)
%Annika Rings, April 2019
%
%EVENTDUR is a function that calculates the average duration of the event from a JAABA output scores file
%The arguments are:
%filename: name of the scores file (should be id-corrected version)
%index: fly ID
%windowsize: size of the moving average window (in frames)
%cutofffrac: fraction of the frames that have to be positive for the event
%in the specified window
load(filename)

scores = allScores.postprocessed{1, index};
moving_avg = movmean(scores, windowsize);
event = (moving_avg >= cutofffrac);
dif = diff(event);
dif = [event(1), dif];
rising = find(dif == 1);
falling = find(dif == -1);
if rising(1) > falling(1)
    rising = [1, rising];
end
if rising(end) > falling(end)
    falling = [falling, (numel(scores))];
end
spanW = falling - rising;
dur = mean(spanW);
