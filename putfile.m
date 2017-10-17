function varargout = putfile(varargin)
% PUTFILE MATLAB code for putfile.fig
%      PUTFILE, by itself, creates a new PUTFILE or raises the existing
%      singleton*.
%
%      H = PUTFILE returns the handle to a new PUTFILE or the handle to
%      the existing singleton*.
%
%      PUTFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUTFILE.M with the given input arguments.
%
%      PUTFILE('Property','Value',...) creates a new PUTFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before putfile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to putfile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help putfile

% Last Modified by GUIDE v2.5 17-Oct-2017 01:51:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @putfile_OpeningFcn, ...
                   'gui_OutputFcn',  @putfile_OutputFcn, ...
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


% --- Executes just before putfile is made visible.
function putfile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to putfile (see VARARGIN)
movegui(gcf,'center');
% Choose default command line output for putfile
handles.putSample=varargin{1};

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes putfile wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = putfile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function position_pushbutton_Callback(hObject, eventdata, handles)
handles.foldername=uigetdir();
set(handles.position_edit,'String',handles.foldername);

guidata(hObject, handles);

function position_edit_Callback(hObject, eventdata, handles)


function position_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function filename_edit_Callback(hObject, eventdata, handles)


function filename_edit_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function format_popupmenu_Callback(hObject, eventdata, handles)


function format_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Fs_popupmenu_Callback(hObject, eventdata, handles)


function Fs_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function bps_popupmenu_Callback(hObject, eventdata, handles)


function bps_popupmenu_CreateFcn(hObject, eventdata, handles)

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function reset_pushbutton_Callback(hObject, eventdata, handles)


function generate_pushbutton_Callback(hObject, eventdata, handles)
set(handles.position_edit,'String',handles.foldername);
filename=get(handles.filename_edit,'String');
format_str=get(handles.format_popupmenu,'String');
format_val=get(handles.format_popupmenu,'Value');
format=format_str{format_val};
Fs_str=get(handles.Fs_popupmenu,'String');
Fs_val=get(handles.Fs_popupmenu,'Value');
Fs=str2double(Fs_str{Fs_val});
bps_str=get(handles.bps_popupmenu,'String');
bps_val=get(handles.bps_popupmenu,'Value');
bps=str2double(bps_str{bps_val});
audiowrite([handles.foldername,'\',filename,format], ...
    handles.putSample, ...
    Fs, ...
    'BitsPerSample',bps);
msgbox('生成完成');
handles.output=1;

guidata(hObject, handles);
uiresume(handles.figure1);
