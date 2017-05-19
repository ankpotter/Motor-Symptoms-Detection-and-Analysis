function finaldata=getdataHMM_in_home(addr,bp,t_start,t_end)
filelist=getAllFiles(addr);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:size(filelist,1)
    metadata{i}=fetchmetadatautility(filelist{i});
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
field1='annotationdata';field2='sensor1';field3='sensor2';field4='sensor3';field5='sensor4';field6='sensor5';

value1={metadata{1,1}};value2={metadata{1,2}};value3={metadata{1,3}};value4={metadata{1,4}};
value5={metadata{1,5}};value6={metadata{1,6}};%value2={metadata{1,3},metadata{1,4}};%value2={metadata{1,3},metadata{1,4}};
subject=struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5,field6,value6);
clear metadata;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%position=strfind(subject.annotationdata(4).annotation);
%[idx11]=find(~cellfun(@isempty,position));
date = subject.annotationdata(2).annotation(1);
time_epoch = datenum('1970','yyyy');
time_final = time_epoch +(date)/8.64e7;
date_begin=datestr(time_final,'dd-mmm-yyyy');
tbeginactual = strcat(date_begin,{' '},t_start);
tendactual = strcat(date_begin,{' '},t_end);
%tendactual=subject.annotationdata(3).annotation(idx11(end));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data=fetchdatautility_timeinput(tbeginactual,tendactual,filelist);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
name1=strsplit(subject.sensor1.Sensor_ID,'_');
name2=strsplit(subject.sensor2.Sensor_ID,'_');
name3=strsplit(subject.sensor3.Sensor_ID,'_');
name4=strsplit(subject.sensor4.Sensor_ID,'_');
name5=strsplit(subject.sensor5.Sensor_ID,'_');
names={name1{2},name2{2},name3{2},name4{2},name5{2}};
for j=1:size(names,2)
    sensordata.(names{j})=data{j};
end
inclinicfinaldata=sensordata;
clear sensordata data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
percent=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(bp,'rh')
    finaldata=inclinicfinaldata.rh;
end
if strcmp(bp,'lh')
    finaldata=inclinicfinaldata.lh;
end
if strcmp(bp,'rl')
    finaldata=inclinicfinaldata.rl;
end
if strcmp(bp,'ll')
    finaldata=inclinicfinaldata.ll;
end
if strcmp(bp,'ch')
    finaldata=inclinicfinaldata.ch;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%