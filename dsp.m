function varargout = dsp(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @dsp_OpeningFcn, ...
    'gui_OutputFcn',  @dsp_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before dsp is made visible.
function dsp_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for dsp
handles.output = hObject;

% 设置坐标轴
set(gcf,'defaultAxesXGrid','on', ...
    'defaultAxesYGrid','on', ...
    'defaultAxesZGrid','on');

% 初始化
movegui(gcf,'center');
handles.Sample=[];
handles.index=0;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = dsp_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


function record_radiobutton_Callback(hObject, eventdata, handles)

function file_radiobutton_Callback(hObject, eventdata, handles)

% --- 显示文件路径
function filepath_edit_Callback(hObject, eventdata, handles)

function filepath_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fs_popupmenu_Callback(hObject, eventdata, handles)

function fs_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- 文件输入音频
function file_choose_pushbutton_Callback(hObject, eventdata, handles)
[filename,pathname]=uigetfile({'*.wav;*.mp3;*.flac', ...
    '音频文件(*.wav,*.mp3,*.flac)'},'选择文件');%弹出选择文件窗口
% 判断文件为空
% 不能使用if isempty(filename)||isempty(pathname)
% 取消窗口时会报错，取消时uigetfile返回filename为0
if filename==0
    return
else
    handles.Filepath=[pathname,filename];
    set(handles.filepath_edit,'string',handles.Filepath);% 显示文件名
    [handles.Sample,handles.Fs]=audioread(handles.Filepath);% 读取音频文件
    % 若输入音频为双声道，则使用一个通道
    samplesize=size(handles.Sample);
    if samplesize(2)>1
        handles.Sample=handles.Sample(:,1);
    end
    handles.player=audioplayer(handles.Sample,handles.Fs);
    setplayer(handles);
    
    set(handles.play_pushbutton,'enable','on');
    set(handles.play_stop_pushbutton,'enable','on');
    set(handles.putfile_pushbutton,'enable','on');
    
    guidata(hObject,handles);
end


% --- 录音按钮
function record_start_pushbutton_Callback(hObject, eventdata, handles)
fs_list=get(handles.fs_popupmenu,'string');% 获取列表
fs_value=get(handles.fs_popupmenu,'value');% 获取参数序号
fs=str2double(fs_list{fs_value});% 获取选定采样率
% list类型为cell必须转换
handles.Fs=fs;

handles.recObj=audiorecorder(fs,16,1);% 创建一个录音器

set(handles.recObj,'StartFcn',{@recordstart_Callback,handles}, ...
    'StopFcn',{@recordstop_Callback,handles}); % 录音回调

record(handles.recObj);% 开始录音

guidata(hObject,handles);

% --- 停止录音按钮
function record_stop_pushbutton_Callback(hObject, eventdata, handles)
stop(handles.recObj);% 停止录音
handles.Sample=getaudiodata(handles.recObj);% 获取录音
handles.index=handles.index+1;
handles.player=audioplayer(handles.Sample,handles.Fs);
setplayer(handles);

guidata(hObject,handles);

% --- 播放器设置
function setplayer(handles)
% 创建player回调函数
set(handles.player,'StartFcn',{@playstart_Callback,handles}, ...
    'StopFcn',{@playstop_Callback,handles});

% 音频信息
sample_length=length(handles.Sample);
t=sample_length/handles.Fs;
set(handles.timeinfo_text,'String',['时长：',num2str(t),'s']);
set(handles.fsinfo_text,'String',['采样率：',num2str(handles.Fs),'Hz']);

% plot wave
audio_analyze(handles.Sample,handles.Fs,handles.axes1,handles);

% --- 播放按钮
function play_pushbutton_Callback(hObject, eventdata, handles)
play(handles.player);% 开始播放

% --- 停止播放按钮
function play_stop_pushbutton_Callback(hObject, eventdata, handles)
stop(handles.player);% 停止播放

% --- 输入方式按钮组
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
switch get(hObject,'tag')
    case 'record_radiobutton'
        set(handles.fs_popupmenu,'enable','on');
        set(handles.record_start_pushbutton,'enable','on');
        set(handles.record_stop_pushbutton,'enable','off');
        set(handles.filepath_edit,'enable','off');
        set(handles.file_choose_pushbutton,'enable','off');
        set(handles.play_pushbutton,'enable','off');
        set(handles.play_stop_pushbutton,'enable','off');
    case 'file_radiobutton'
        set(handles.fs_popupmenu,'enable','off');
        set(handles.record_start_pushbutton,'enable','off');
        set(handles.record_stop_pushbutton,'enable','off');
        set(handles.filepath_edit,'enable','on');
        set(handles.file_choose_pushbutton,'enable','on');
        set(handles.play_pushbutton,'enable','off');
        set(handles.play_stop_pushbutton,'enable','off');
end

% --- 波形选择栏
function wave_select_listbox_Callback(hObject, eventdata, handles)
audio_analyze(handles.Sample,handles.Fs,handles.axes1,handles);

function wave_select_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end 

% --- 播放开始
function playstart_Callback(hObject,eventdata,handles)
set(handles.play_pushbutton,'enable','off');
set(handles.play_stop_pushbutton,'enable','on');
set(handles.playstate_text,'String','状态栏> 正在播放...');

% --- 播放结束
function playstop_Callback(hObject,eventdata,handles)
set(handles.play_pushbutton,'enable','on');
set(handles.play_stop_pushbutton,'enable','off');
set(handles.playstate_text,'String','状态栏>');

% --- 录音开始
function recordstart_Callback(hObject,eventdata,handles)
set(handles.record_start_pushbutton,'enable','off');
set(handles.record_stop_pushbutton,'enable','on');
set(handles.playstate_text,'String','状态栏> 正在录音...');

% --- 录音结束
function recordstop_Callback(hObject,eventdata,handles)
set(handles.play_pushbutton,'enable','on');
set(handles.play_stop_pushbutton,'enable','on');
set(handles.record_start_pushbutton,'enable','on');
set(handles.record_stop_pushbutton,'enable','off');
set(handles.putfile_pushbutton,'enable','on');
set(handles.playstate_text,'String','状态栏>');

function putfile_pushbutton_Callback(hObject, eventdata, handles)
putfile(handles.Sample); % 输出音频

function nmean_edit_Callback(hObject, eventdata, handles)

function nmean_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dmean_edit_Callback(hObject, eventdata, handles)

function dmean_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dvar_edit_Callback(hObject, eventdata, handles)

function dvar_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nvar_edit_Callback(hObject, eventdata, handles)

function nvar_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
