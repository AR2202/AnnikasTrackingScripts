function dur=eventdur(filename,index)
load(filename)

scores = allScores.postprocessed{1,index};
dif= diff(scores);
rising=find(dif==1);
falling=find(dif==-1);
spanW=falling-rising;
dur=mean(spanW);

