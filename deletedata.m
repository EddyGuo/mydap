function deletedata(data)
% --- 删除数据
button = questdlg('你想删除哪一个说话人',...
    '删除数据',...
    '所有','选定','所有');
if strcmp(button,'所有')
    delete('speech_database.dat');
    msgbox('成功删除数据','删除所有','help');
else
    prompt={'输入你想要删除的说话人'};
    name='选定删除身份';
    numlines=1;
    defaultanswer={''};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
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
        save('speech_database.dat','data','speaker_number','-append');
        message=strcat('成功删除说话人：',answer{1,1});
        msgbox(message,'选定删除身份','help');
    end
end
end

