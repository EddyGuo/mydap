function c=deletedata(data)
% --- 删除数据
button = questdlg('你想删除哪一个说话人',...
    '删除数据',...
    '所有','选定','取消','取消');
switch button
    case '所有'
        delete('speech_database.mat');
        c=cell(0,0);
        msgbox('成功删除数据','删除所有','help');
    case '选定'
        prompt={'输入你想要删除的说话人'};
        name='';
        numlines=1;
        defaultanswer={''};
        answer=inputdlg(prompt,name,numlines,defaultanswer);
        if (~isempty(answer))
            nspeaker=length(data);
            names=cell(1,nspeaker);
            for i=1:nspeaker
                names{1,i}=data(i).name;
            end
            [a,b]=ismember(answer{1,1},names);
            if a==0
                warndlg('说话人不存在','警告');
            else
                data(b)=[];
                speaker_number=length(data);
                save('speech_database.mat','data','speaker_number','-append');
                c=data2cell(data);
                message=strcat('成功删除说话人：',answer{1,1});
                msgbox(message,'','help');
            end
        end
    case '取消'
end
end

