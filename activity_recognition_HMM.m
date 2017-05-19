l=1;
filepath=fullfile('../NEWDATA/PD/');
list=dir('../NEWDATA/PD/');
parameter=loadparameter();
pnum=3;
addr=strcat(filepath,list(pnum).name);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sensordata=getdataHMM(addr,'rl','OFF');
%newsensordata=movingavgmeansub(sensordata(:,2:4),100);
newsensordata=sensordata(:,2:4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('HMMall/')
addpath('HMMall/HMM')
addpath('HMMall/KPMstats')
addpath('HMMall/KPMtools')
addpath('HMMall/netlab3.3')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
O = size(newsensordata,2);          %Number of coefficients in a vector 
T = size(newsensordata,1);            %Number of vectors in a sequence 
nex = 1;                           %Number of sequences 
M = 1;                             %Number of mixtures 
Q = 2;                             %Number of states 
cov_type = 'full';
prior0 = normalise(rand(Q,1));
transmat0 = mk_stochastic(rand(Q,Q));
[mu0, Sigma0] = mixgauss_init(Q*M, newsensordata', cov_type);
mu0 = reshape(mu0, [O Q M]);
Sigma0 = reshape(Sigma0, [O O Q M]);
mixmat0 = [];
%newsensordata=movingavgmeansub(sensordata(:,2:4),100);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
    mhmm_em(newsensordata', prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 100);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[B,B2]=mixgauss_prob(newsensordata', mu1, Sigma1);
obslik=B;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path = viterbi_path(prior1, transmat1, obslik);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rmpath('HMMall/')
rmpath('HMMall/HMM')
rmpath('HMMall/KPMstats')
rmpath('HMMall/KPMtools')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
theta=0:2*pi/size(sensordata,1):2*pi-1/size(sensordata,1);
polarplot(theta,path,'.');
%polarscatter(theta,path)
for j=1:12
     [~,pos]=min(abs(theta-((j-1)*pi/6)));
     newtime{j}=cellstr(unixtonormaltimeGMT(sensordata(pos,1))); 
end
ax=gca;
%newtime=cellstr(unixtonormaltimeGMT(sensordata(:,1)'));
ax.ThetaTickLabel={char(newtime{1}),char(newtime{2}),char(newtime{3}),...
    char(newtime{4}),char(newtime{5}),char(newtime{6}),char(newtime{7}),...
    char(newtime{8}),char(newtime{9}),char(newtime{10}),char(newtime{11}),...
    char(newtime{12})};

rmpath('HMMall/netlab3.3')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pnum=4;
addr=strcat(filepath,list(pnum).name);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear sensordata newsensordata
sensordata=getdataHMM(addr,'rl','ON');
newsensordata=sensordata(:,2:4);
for i=1:size(newsensordata,1)
    mdist1=sqrt((newsensordata(i,:)-mu1(:,1)')*inv(Sigma1(:,:,1))*(newsensordata(i,:)'-mu1(:,1)));
    mdist2=sqrt((newsensordata(i,:)-mu1(:,2)')*inv(Sigma1(:,:,2))*(newsensordata(i,:)'-mu1(:,2)));
    newpath(i)=(mdist1>mdist2) + 1;
end
figure;
theta=0:2*pi/size(sensordata,1):2*pi-1/size(sensordata,1);
polarplot(theta,newpath,'.');
for j=1:12
     [~,pos]=min(abs(theta-((j-1)*pi/6)));
     newtime{j}=cellstr(unixtonormaltimeGMT(sensordata(pos,1))); 
end
ax=gca;
%newtime=cellstr(unixtonormaltimeGMT(sensordata(:,1)'));
ax.ThetaTickLabel={char(newtime{1}),char(newtime{2}),char(newtime{3}),...
    char(newtime{4}),char(newtime{5}),char(newtime{6}),char(newtime{7}),...
    char(newtime{8}),char(newtime{9}),char(newtime{10}),char(newtime{11}),...
    char(newtime{12})};
% path1=path>1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sensordata=getdataHMM(addr,'ll','NO');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% addpath('HMMall/')
% addpath('HMMall/HMM')
% addpath('HMMall/KPMstats')
% addpath('HMMall/KPMtools')
% addpath('HMMall/netlab3.3')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% O = size(sensordata,2)-1;          %Number of coefficients in a vector 
% T = size(sensordata,1);            %Number of vectors in a sequence 
% nex = 1;                           %Number of sequences 
% M = 1;                             %Number of mixtures 
% Q = 2;                             %Number of states 
% cov_type = 'full';
% prior0 = normalise(rand(Q,1));
% transmat0 = mk_stochastic(rand(Q,Q));
% [mu0, Sigma0] = mixgauss_init(Q*M, sensordata(:,2:4)', cov_type);
% mu0 = reshape(mu0, [O Q M]);
% Sigma0 = reshape(Sigma0, [O O Q M]);
% mixmat0 = [];
% %newsensordata=movingavgmeansub(sensordata(:,2:4),100);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
%     mhmm_em(sensordata(:,2:4)', prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 100);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [B,B2]=mixgauss_prob(sensordata(:,2:4)', mu1, Sigma1);
% obslik=B;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% path = viterbi_path(prior1, transmat1, obslik);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rmpath('HMMall/')
% rmpath('HMMall/HMM')
% rmpath('HMMall/KPMstats')
% rmpath('HMMall/KPMtools')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta=0:2*pi/size(sensordata,1):2*pi-1/size(sensordata,1);
% polarplot(theta,path);
% for j=1:12
%      [~,pos]=min(abs(theta-((j-1)*pi/6)));
%      pp(j)=pos; 
% end
% ax=gca;
% newtime=cellstr(unixtonormaltimeGMT(sensordata(:,1)'));
% ax.ThetaTickLabel={char(newtime{pp(1)}),char(newtime{pp(2)}),char(newtime{pp(3)}),...
%     char(newtime{pp(4)}),char(newtime{pp(5)}),char(newtime{pp(6)}),char(newtime{pp(7)}),...
%     char(newtime{pp(8)}),char(newtime{pp(9)}),char(newtime{pp(10)}),char(newtime{pp(11)}),...
%     char(newtime{pp(12)})};
% 
% rmpath('HMMall/netlab3.3')
% path2=path>1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% diff=xor(path1,path2);
% disp(sum(diff==0)/length(diff))