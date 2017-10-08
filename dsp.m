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

% Last Modified by GUIDE v2.5 07-Oct-2017 22:48:27

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
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dsp (see VARARGIN)

% Choose default command line output for dsp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dsp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dsp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in record_radiobutton.
function record_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to record_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of record_radiobutton


% --- Executes on button press in file_radiobutton.
function file_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to file_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of file_radiobutton



function filepath_edit_Callback(hObject, eventdata, handles)
% hObject    handle to filepath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filepath_edit as text
%        str2double(get(hObject,'String')) returns contents of filepath_edit as a double


% --- Executes during object creation, after setting all properties.
function filepath_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filepath_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sample_frequency_popupmenu.
function sample_frequency_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to sample_frequency_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sample_frequency_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sample_frequency_popupmenu


% --- Executes during object creation, after setting all properties.
function sample_frequency_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sample_frequency_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in file_choose_pushbutton.
function file_choose_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to file_choose_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile({'*.wav;*.mp3;*.flac','音频文件(*.wav,*.mp3,*.flac)'},'选择文件');%弹出选择文件窗口
%判断文件为空
if isequal(filename,0)||isequal(pathname,0)
    return
else
    handles.Filepath=[pathname,filename];
    set(handles.filepath_edit,'string',handles.Filepath);%显示文件名
    [handles.Sample,handles.Fs]=audioread(handles.Filepath);%读取音频文件
    %若输入音频为双声道，则使用一个通道
    samplesize=size(handles.Sample);
    if samplesize(2)>1
        handles.Sample=handles.Sample(:,1);
    end
    handles.inputtype=2;%输入方式为设为2
    handles.player=audioplayer(handles.Sample,handles.Fs);
    guidata(hObject,handles);%储存handles
    set(handles.play_pushbutton,'enable','on');
    set(handles.play_stop_pushbutton,'enable','on');
    audio_analyze(handles); 
end


% --- Executes on button press in record_start_pushbutton.
function record_start_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to record_start_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sample_frequency_list=get(handles.sample_frequency_popupmenu,'string');%获取列表
sample_frequency_value=get(handles.sample_frequency_popupmenu,'value');%获取参数序号
sample_frequency=str2double(sample_frequency_list{sample_frequency_value});%获取选定采样率
%list类型为cell必须转换
handles.Fs=sample_frequency;
handles.recObj=audiorecorder(sample_frequency,16,1);%创建一个录音器
record(handles.recObj);%开始录音
handles.inputtype=1;%输入音频方式设为1
guidata(hObject,handles);

% --- Executes on button press in play_pushbutton.
function play_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to play_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
play(handles.player);%开始播放
playblocking(handles.player);%播放结束自动停止


% --- Executes on button press in record_stop_pushbutton.
function record_stop_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to record_stop_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.recObj);%停止录音
set(handles.play_pushbutton,'enable','on');
set(handles.play_stop_pushbutton,'enable','on');
handles.Sample=getaudiodata(handles.recObj);%获取录音
handles.player=audioplayer(handles.Sample,handles.Fs);%创建一个播放器
guidata(hObject,handles);
audio_analyze(handles);
% --- Executes during object deletion, before destroying properties.


% --- Executes on button press in play_stop_pushbutton.
function play_stop_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to play_stop_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(handles.player);%停止播放


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(hObject,'tag')
    case 'record_radiobutton'
        set(handles.sample_frequency_popupmenu,'enable','on');
        set(handles.record_start_pushbutton,'enable','on');
        set(handles.record_stop_pushbutton,'enable','on');
        set(handles.filepath_edit,'enable','off');
        set(handles.file_choose_pushbutton,'enable','off');
        set(handles.play_pushbutton,'enable','off');
        set(handles.play_stop_pushbutton,'enable','off');
    case 'file_radiobutton'
        set(handles.sample_frequency_popupmenu,'enable','off');
        set(handles.record_start_pushbutton,'enable','off');
        set(handles.record_stop_pushbutton,'enable','off');
        set(handles.filepath_edit,'enable','on');
        set(handles.file_choose_pushbutton,'enable','on');
        set(handles.play_pushbutton,'enable','off');
        set(handles.play_stop_pushbutton,'enable','off');
end
