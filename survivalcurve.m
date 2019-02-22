function survivalcurve(datafile,dataname)
load(datafile);
data=eval(dataname);
data(isnan(data))=900;
censored=data==900;
figure()
ecdf(data,'censoring',censored);

