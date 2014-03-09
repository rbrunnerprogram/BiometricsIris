%Code found at:
%http://www.mathworks.com/matlabcentral/answers/96242


function varargout = myCameraGUI(varargin)
% MYCAMERAGUI MATLAB code for myCameraGUI.fig
%      MYCAMERAGUI, by itself, creates a new MYCAMERAGUI or raises the existing
%      singleton*.
%
%      H = MYCAMERAGUI returns the handle to a new MYCAMERAGUI or the handle to
%      the existing singleton*.
%
%      MYCAMERAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYCAMERAGUI.M with the given input arguments.
%
%      MYCAMERAGUI('Property','Value',...) creates a new MYCAMERAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myCameraGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myCameraGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help myCameraGUI

% Last Modified by GUIDE v2.5 02-Mar-2014 23:49:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myCameraGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @myCameraGUI_OutputFcn, ...
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


% --- Executes just before myCameraGUI is made visible.
function myCameraGUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to myCameraGUI (see VARARGIN)

% Choose default command line output for myCameraGUI
handles.output = hObject;

% Create video object
%   Putting the object into manual trigger mode and then
%   starting the object will make GETSNAPSHOT return faster
%   since the connection to the camera will already have
%   been established.
handles.video = videoinput('winvideo', 1);
set(handles.video,'TimerPeriod', 0.05, ...
      'TimerFcn',['if(~isempty(gco)),'...
                      'handles=guidata(gcf);'...                                 % Update handles
                      'image(getsnapshot(handles.video));'...                    % Get picture using GETSNAPSHOT and put it into axes using IMAGE
                      'set(handles.cameraAxes,''ytick'',[],''xtick'',[]),'...    % Remove tickmarks and labels that are inserted when using IMAGE
                  'else '...
                      'delete(imaqfind);'...                                     % Clean up - delete any image acquisition objects
                  'end']);
triggerconfig(handles.video,'manual');
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually stop it

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes myCameraGUI wait for user response (see UIRESUME)
uiwait(handles.MyCameraGUI);


% --- Outputs from this function are returned to the command line.
function varargout = myCameraGUI_OutputFcn(hObject, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;


% --- Executes on button press in startStopCamera.
function startStopCamera_Callback(~, ~, handles)
% hObject    handle to startStopCamera (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Start/Stop Camera
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
      % Camera is off. Change button string and start camera.
      set(handles.startStopCamera,'String','Stop Camera')
      start(handles.video)
      set(handles.captureImage,'Enable','on');
else
      % Camera is on. Stop camera and change button string.
      set(handles.startStopCamera,'String','Start Camera')
      stop(handles.video)
      set(handles.captureImage,'Enable','off');
end


% --- Executes on button press in captureImage.
function captureImage_Callback(~, ~, handles)
% hObject    handle to captureImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% frame = getsnapshot(handles.video);
frame = get(get(handles.cameraAxes,'children'),'cdata'); % The current displayed frame
imwrite(frame, 'image.jpg');
%save('testframe.mat', 'frame');
disp('Frame saved to file ''testframe.mat''');


% --- Executes when user attempts to close MyCameraGUI.
%function myCameraGUI_CloseRequestFcn(hObject, ~, ~)
% hObject    handle to myCameraGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
%delete(hObject);
%delete(imaqfind);


% --- Executes when user attempts to close MyCameraGUI.
function MyCameraGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to MyCameraGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
set(handles.startStopCamera,'String','Start Camera')
stop(handles.video)
set(handles.captureImage,'Enable','off');
delete(hObject);
