function varargout = dsp(varargin)
% DSP MATLAB code for dsp.fig
%      DSP, by itself, creates a new DSP or raises the existing
%      singleton*.
%
%      H = DSP returns the handle to a new DSP or the handle to
%      the existing singleton*.
%
%      DSP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DSP.M with the given input arguments.
%
%      DSP('Property','Value',...) creates a new DSP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dsp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dsp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dsp

% Last Modified by GUIDE v2.5 12-Oct-2017 23:11:06

% Begin initialization code - DO NOT EDIT
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
% End initialization code - DO NOT EDIT


% --- Executes just before dsp is made visible.
function dsp_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for dsp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dsp wait for user response (see UIRESUME)
% uiwait(handles.dsp_figure);

% 设置默认颜色
set(gcf,'defaultAxesColor','k',...
    'defaultAxesXColor','[0.5,0.5,0.5]', ...
    'defaultAxesYColor','[0.5,0.5,0.5]', ...
    'defaultAxesZColor','[0.5,0.5,0.5]', ...
    'defaultAxesGridColor','w');

% 创建一个空Sample
handles.Sample=[];
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = dsp_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in record_radiobutton.
function record_radiobutton_Callback(hObject, eventdata, handles)


% --- Executes on button press in file_radiobutton.
function file_radiobutton_Callback(hObject, eventdata, handles)


% --- 显示文件路径
function filepath_edit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function filepath_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in fs_popupmenu.
function fs_popupmenu_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function fs_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in file_choose_pushbutton.
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
    handles.inputtype=2;% 输入方式为设为2
    handles.player=audioplayer(handles.Sample,handles.Fs);
    guidata(hObject,handles);% 储存handles
    set(handles.play_pushbutton,'enable','on');
    set(handles.play_stop_pushbutton,'enable','on');
    feval(@wave_select_listbox_Callback,handles.wave_select_listbox,eventdata,handles);
    % 调用wave_select_listbox_Callback,handles函数
end


% --- Executes on button press in record_start_pushbutton.
% --- 录音按钮
function record_start_pushbutton_Callback(hObject, eventdata, handles)
fs_list=get(handles.fs_popupmenu,'string');% 获取列表
fs_value=get(handles.fs_popupmenu,'value');% 获取参数序号
fs=str2double(fs_list{fs_value});% 获取选定采样率
% list类型为cell必须转换
handles.Fs=fs;
handles.recObj=audiorecorder(fs,16,1);% 创建一个录音器
record(handles.recObj);% 开始录音
handles.inputtype=1;% 输入音频方式设为1
guidata(hObject,handles);
set(hObject,'enable','off');
set(handles.record_stop_pushbutton,'enable','on');

% --- Executes on button press in play_pushbutton.
% --- 播放按钮
function play_pushbutton_Callback(hObject, eventdata, handles)
play(handles.player);% 开始播放

% --- Executes on button press in record_stop_pushbutton.
% --- 停止录音按钮
function record_stop_pushbutton_Callback(hObject, eventdata, handles)
stop(handles.recObj);% 停止录音
set(handles.play_pushbutton,'enable','on');
set(handles.play_stop_pushbutton,'enable','on');
set(handles.record_start_pushbutton,'enable','on');
set(hObject,'enable','off');
handles.Sample=getaudiodata(handles.recObj);% 获取录音
handles.player=audioplayer(handles.Sample,handles.Fs);% 创建一个播放器
guidata(hObject,handles);
feval(@wave_select_listbox_Callback,handles.wave_select_listbox,eventdata,handles);
%调用wave_select_listbox_Callback,handles函数
% --- Executes during object deletion, before destroying properties.


% --- Executes on button press in play_stop_pushbutton.
% --- 停止播放按钮
function play_stop_pushbutton_Callback(hObject, eventdata, handles)
stop(handles.player);% 停止播放
set(handles.play_pushbutton,'enable','on');


% --- Executes when selected object is changed in uibuttongroup1.
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


% --- Executes on selection change in wave_select_listbox.
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
