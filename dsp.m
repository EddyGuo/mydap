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

% 设置默认颜色
set(gcf,'defaultAxesColor','k',...
    'defaultAxesXColor','[0.5,0.5,0.5]', ...
    'defaultAxesYColor','[0.5,0.5,0.5]', ...
    'defaultAxesZColor','[0.5,0.5,0.5]', ...
    'defaultAxesGridColor','w');

% 初始化
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
[filename,pathname]=uigetfile({'*.wav;*.mp3;*.flac','音频文件(*.wav,*.mp3,*.flac)'},'选择文件');%弹出选择文件窗口
% 判断文件为空
if isempty(filename)||isempty(pathname)
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
    setplayer(eventdata,handles);
end
 guidata(hObject,handles);

% --- 录音按钮
function record_start_pushbutton_Callback(hObject, eventdata, handles)
fs_list=get(handles.fs_popupmenu,'string');% 获取列表
fs_value=get(handles.fs_popupmenu,'value');% 获取参数序号
fs=str2double(fs_list{fs_value});% 获取选定采样率
% list类型为cell必须转换
handles.Fs=fs;

handles.recObj=audiorecorder(fs,16,1);% 创建一个录音器
record(handles.recObj);% 开始录音

set(hObject,'enable','off');
set(handles.record_stop_pushbutton,'enable','on');

guidata(hObject,handles);

% --- 停止录音按钮
function record_stop_pushbutton_Callback(hObject, eventdata, handles)
stop(handles.recObj);% 停止录音
handles.Sample=getaudiodata(handles.recObj);% 获取录音
handles.index=handles.index+1;
handles.player=audioplayer(handles.Sample,handles.Fs);
setplayer(eventdata,handles);

set(handles.play_pushbutton,'enable','on');
set(handles.play_stop_pushbutton,'enable','on');
set(handles.record_start_pushbutton,'enable','on');
set(hObject,'enable','off');

guidata(hObject,handles);

% --- 播放器设置
function setplayer(eventdata,handles)
% 创建player回调函数
set(handles.player,'StartFcn',{@playstart_Callback,handles}, ...
        'StopFcn',{@playstop_Callback,handles});
% plot wave
feval(@wave_select_listbox_Callback,handles.wave_select_listbox,eventdata,handles);

% --- 播放按钮
function play_pushbutton_Callback(hObject, eventdata, handles)
play(handles.player);% 开始播放

% --- 停止播放按钮
function play_stop_pushbutton_Callback(hObject, eventdata, handles)
stop(handles.player);% 停止播放
set(handles.play_pushbutton,'enable','on');

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
wavetype=get(hObject,'value');
if ~isempty(handles.Sample)
    audio_analyze(wavetype,handles);
end

% --- Executes during object creation, after setting all properties.
function wave_select_listbox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- 播放开始
function playstart_Callback(hObject,eventdata,handles)
set(handles.play_pushbutton,'enable','off');
set(handles.play_stop_pushbutton,'enable','on');

% --- 播放结束
function playstop_Callback(hObject,eventdata,handles)
set(handles.play_pushbutton,'enable','on');
set(handles.play_stop_pushbutton,'enable','off');