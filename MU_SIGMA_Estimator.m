clear all;
filepath=fullfile('../NEWDATA/HD/');
list=dir('../NEWDATA/HD/');
parameter=loadparameter();
MU=[];
SIGMA=zeros(3,3,1);
for pnum=3:length(list)
    if (pnum==6||pnum==9)
        continue;
    end;
    addr=strcat(filepath,list(pnum).name);
    sensordata=getdataHMM(addr,'rl','NO');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    addpath('HMMall\')
    addpath('HMMall\HMM')
    addpath('HMMall\KPMstats')
    addpath('HMMall\KPMtools')
    addpath('HMMall\netlab3.3')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    O = size(sensordata,2)-1;          %Number of coefficients in a vector 
    T = size(sensordata,1);            %Number of vectors in a sequence 
    nex = 1;                           %Number of sequences 
    M = 1;                             %Number of mixtures 
    Q = 2;                             %Number of states 
    cov_type = 'full';
    prior0 = normalise(rand(Q,1));
    transmat0 = mk_stochastic(rand(Q,Q));
    [mu0, Sigma0] = mixgauss_init(Q*M, sensordata(:,2:4)', cov_type);
    mu0 = reshape(mu0, [O Q M]);
    Sigma0 = reshape(Sigma0, [O O Q M]);
    mixmat0 = [];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [LL, prior1, transmat1, mu1, Sigma1, mixmat1] = ...
        mhmm_em(sensordata(:,2:4)', prior0, transmat0, mu0, Sigma0, mixmat0, 'max_iter', 100);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [B,B2]=mixgauss_prob(sensordata(:,2:4)', mu0, Sigma0);
    obslik=B;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    path = viterbi_path(prior0, transmat0, obslik);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    rmpath('HMMall\')
    rmpath('HMMall\HMM')
    rmpath('HMMall\KPMstats')
    rmpath('HMMall\KPMtools')
    rmpath('HMMall\netlab3.3')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     theta=0:2*pi/size(sensordata,1):2*pi-1/size(sensordata,1);
%     polarplot(theta,path);
%     for j=1:12
%          [~,pos]=min(abs(theta-((j-1)*pi/6)));
%          newtime{j}=cellstr(unixtonormaltimeGMT(sensordata(pos,1))); 
%     end
%     ax=gca;
%     %newtime=cellstr(unixtonormaltimeG+MT(sensordata(:,1)'));
%     ax.ThetaTickLabel={char(newtime{1}),char(newtime{2}),char(newtime{3}),...
%         char(newtime{4}),char(newtime{5}),char(newtime{6}),char(newtime{7}),...
%         char(newtime{8}),char(newtime{9}),char(newtime{10}),char(newtime{11}),...
%         char(newtime{12})};
    MU=[MU;mu1'];
    SIGMA(:,:,((pnum-3)*2+1))=Sigma1(:,:,1);
    SIGMA(:,:,((pnum-3)*2+2))=Sigma1(:,:,2);
end
[idx,C]=kmeans(MU,2);
scatter3(MU(:,1),MU(:,2),MU(:,3));
hold on;
scatter3(C(:,1),C(:,2),C(:,3),'*');
idx1=find(idx==1);
idx2=find(idx==2);
SIGMA1=zeros(3,3);
SIGMA2=zeros(3,3);
for i=1:length(idx1)
    SIGMA1=SIGMA1+SIGMA(:,:,idx1(i));
    SIGMA2=SIGMA2+SIGMA(:,:,idx2(i));
end
SIGMA1=SIGMA1/length(idx1);
SIGMA2=SIGMA2/length(idx2);
MU=C;
clear SIGMA;
SIGMA(:,:,1)=SIGMA1;
SIGMA(:,:,2)=SIGMA2;
%gscatter3(sensordata(:,2),sensordata(:,3),sensordata(:,4),path);