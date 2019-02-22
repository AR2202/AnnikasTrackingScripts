function survivalcurve3(datafile1,datafile2,datafile3,dataname)
load(datafile1);
data1=eval(dataname);
data1(isnan(data1))=900;
censored1=data1==900;

load(datafile2);
data2=eval(dataname);
data2(isnan(data2))=900;
censored2=data2==900;

load(datafile3);
data3=eval(dataname);
data3(isnan(data3))=900;
censored3=data3==900;

figure()
ecdf(data1,'censoring',censored1);
hold 'on';
ecdf(data2,'censoring',censored2);
ecdf(data3,'censoring',censored3);
xlim([0 900]);
ylim([0 1]);
xlabel('time(s)');
ylabel('fraction initiated');
set(gca, 'box','off');
set(gca, 'FontName','Arial');
set(gca, 'FontSize',16);

hold 'off';

