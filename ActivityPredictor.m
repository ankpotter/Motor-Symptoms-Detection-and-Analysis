tic;
filepath=fullfile('../NEWDATA/Control/');
list=dir('../NEWDATA/Control/');
parameter=loadparameter();
pnum=length(list);
addr=strcat(filepath,list(pnum).name);
%t_start = '05:00:00';
%t_end = '09:00:00';
sensordata=getdataHMM(addr,'rl','NO');
newsensordata=sensordata(:,2:4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('MuSigmaNormalSample.mat');
MU=MU';
for i=1:size(newsensordata,1)
    mdist1=sqrt((newsensordata(i,:)-MU(:,1)')*inv(SIGMA(:,:,1))*(newsensordata(i,:)'-MU(:,1)));
    mdist2=sqrt((newsensordata(i,:)-MU(:,2)')*inv(SIGMA(:,:,2))*(newsensordata(i,:)'-MU(:,2)));
    path(i) = (mdist1>mdist2)+1;
    len(i) = mdist1-mdist2;
end
toc;
figure;
theta=0:2*pi/size(sensordata,1):2*pi-1/size(sensordata,1);
polarplot(theta,path);
for j=1:12
     [~,pos]=min(abs(theta-((j-1)*pi/6)));
     newtime{j}=cellstr(unixtonormaltimeGMT(sensordata(pos,1))); 
end
ax=gca;
ax.ThetaTickLabel={char(newtime{1}),char(newtime{2}),char(newtime{3}),...
    char(newtime{4}),char(newtime{5}),char(newtime{6}),char(newtime{7}),...
    char(newtime{8}),char(newtime{9}),char(newtime{10}),char(newtime{11}),...
    char(newtime{12})};
windowSize=33;
[index,state,smoothpath] = smoothing(path,windowSize);
figure;
polarplot(theta,smoothpath);
for j=1:12
     [~,pos]=min(abs(theta-((j-1)*pi/6)));
     newtime{j}=cellstr(unixtonormaltimeGMT(sensordata(pos,1))); 
end
ax=gca;
ax.ThetaTickLabel={char(newtime{1}),char(newtime{2}),char(newtime{3}),...
    char(newtime{4}),char(newtime{5}),char(newtime{6}),char(newtime{7}),...
    char(newtime{8}),char(newtime{9}),char(newtime{10}),char(newtime{11}),...
    char(newtime{12})};