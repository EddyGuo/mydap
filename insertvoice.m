function [data]=insertvoice(sample,fs)
% --- 声纹录入
addpath('voicerecog');
prompt={'录入说话人身份'};
name='';
numlines=1;
defaultanswer={''};
answer=inputdlg(prompt,name,numlines,defaultanswer);
if (~isempty(answer))
    hwait=waitbar(0,'正在录入声纹...');
    filt=melfilter(150,300,15);
    fr1=frm(sample,16,fs,1);
    waitbar(0.2,hwait);
    mc2=train(fr1,filt,20);
    waitbar(0.4,hwait);
    mc2=mc2(3:18,:);
    mc1=banshengsin(mc2);
    s1=pitch(sample);
    waitbar(0.6,hwait);
    a=length(s1);
    b=length(mc1(1,:));
    if a>b
        s1(b+1:a)=[];
    else
        s1(a+1:b)=0;
    end
    mc1=[mc1;s1];
    [im,is,ip]=init(mc1,16);
    waitbar(0.8,hwait);
    [nim1,nis1,nip1,times]=gmm(im,is,ip,mc1);
    if (exist('speech_database.mat','file')==2)
        load('speech_database.mat','-mat');
        speaker_number=speaker_number+1;
        
        data(speaker_number).name=answer{1,1};
        data(speaker_number).means=nim1;
        data(speaker_number).cov=readcov(nis1);
        data(speaker_number).prob=nip1;
        data(speaker_number).pitch=s1;
        save('speech_database.mat','data','speaker_number','-append');
        waitbar(1,hwait,['成功录入，说话人是：',answer{1,1}]);
        pause(2);
    else
        data=struct('name',{},'means',{},'cov',{},'prob',{},'pitch',{});
        speaker_number=1;
        data(speaker_number).name=answer{1,1};
        data(speaker_number).means=nim1;
        data(speaker_number).cov=readcov(nis1);
        data(speaker_number).prob=nip1;
        data(speaker_number).pitch=s1;
        save('speech_database.mat','data','speaker_number');
        waitbar(1,hwait,['成功录入，说话人是：',answer{1,1}]);
        pause(2);
    end
    close(hwait);
else
    if (exist('speech_database.mat','file')==2)
        load('speech_database.mat','-mat');
    else
        data=struct('name',{},'means',{},'cov',{},'prob',{},'pitch',{});
    end
end
end