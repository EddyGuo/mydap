function recogvoice(sample,fs,data)
% --- 声纹识别
addpath('voicerecog');
hwait=waitbar(0,'正在识别声纹...');
filt=melfilter(150,300,15);
fr=frm(sample,16,fs,1);
waitbar(0.2,hwait);
l=length(fr(1,:));
nosp=length(data);
k=0;
r=nosp;
while(r~=1)
    r=floor(r/2);
    k=k+1;
end
waitbar(0.4,hwait);
p(2,nosp)=0;p(1,1)=0;
for i=1:nosp
    p(2,i)=i;
end
waitbar(0.6,hwait);
mc4=train(fr,filt,20);
mc4=mc4(3:18,:);
mc=banshengsin(mc4);
pitch2=pitch(sample);
a=length(pitch2);
b=length(mc(1,:));
if a>b
    pitch2(b+1:a)=[];
else
    pitch2(a+1:b)=0;
end
mc=[mc;pitch2];
coff=length(mc(:,1));
o=length(mc(1,:));
frameparts=struct('frame',{});
s=mod(l,k);
y=floor(l/k);
if s==0
    for i=1:k
        frameparts(i).frame(coff,y)=0;
    end
else
    for i=1:s
        frameparts(i).frame(coff,y+1)=0;
    end
    for i=s+1:k
        frameparts(i).frame(coff,y)=0;
    end
end
waitbar(0.8,hwait);
for r=1:k
    count=1;
    for i=r:k:l
        frameparts(r).frame(:,count)=mc(:,i);
        count=count+1;
    end
end
for  i=1:k
    % tic
    p1=ident2(frameparts(i).frame,filt,data,p);
    %  toc
    p=upd_pr(p,p1);
    p=nmax1(p);
end
p2=p(1)/o;
scores=zeros(nosp,1);
for i=1:nosp
    pitch1=data(i).pitch';
    % tic
    scores(i,1)=myDTW(pitch2,pitch1(1:length(pitch2)));
    % toc
end
[m,n]=sort(scores);

b=p(2,1);
if or((p2>-25),b==n)
    nm=data(b).name;
    waitbar(1,hwait,['识别成功，说话人是：',nm]);
    pause(4);
else
    waitbar(1,hwait,'识别成功，说话人是：陌生人');
    pause(4);
end
close(hwait);
end

