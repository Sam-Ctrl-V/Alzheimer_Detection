%Project Title: Alzheimer Detection
%Author: TARUN
%Contact: tarun.techme@gmail.com

function varargout = Alzheimer_detection(varargin)
% ALZHEIMER_DETECTION MATLAB code for Alzheimer_detection.fig
%      ALZHEIMER_DETECTION, by itself, creates a new ALZHEIMER_DETECTION or raises the existing
%      singleton*.
%
%      H = ALZHEIMER_DETECTION returns the handle to a new ALZHEIMER_DETECTION or the handle to
%      the existing singleton*.
%
%      ALZHEIMER_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALZHEIMER_DETECTION.M with the given input arguments.
%
%      ALZHEIMER_DETECTION('Property','Value',...) creates a new ALZHEIMER_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Alzheimer_detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Alzheimer_detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Alzheimer_detection

% Last Modified by GUIDE v2.5 26-Sep-2021 11:28:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Alzheimer_detection_OpeningFcn, ...
                   'gui_OutputFcn',  @Alzheimer_detection_OutputFcn, ...
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


% --- Executes just before Alzheimer_detection is made visible.
function Alzheimer_detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Alzheimer_detection (see VARARGIN)

% Choose default command line output for Alzheimer_detection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Alzheimer_detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Alzheimer_detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1 img2

[path, nofile] = imgetfile();

if nofile
    msgbox(sprintf('image not found!!!'),'error','warning');
    return
end

img1 = imread(path);
img1 = im2double(img1);
img2 = img1;

axes(handles.axes1);
imshow(img1)

title('\fontsize{20}\color[rgb]{1,0,1} Brain MRI');

% --- Executes on button press in Filter2.
function Filter2_Callback(hObject, eventdata, handles)
% hObject    handle to Filter2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes2)
if size(img1,3)==3
    img1=rgb2gray(img1);
end
K = medfilt2(img1);
axes(handles.axes2);
imshow(K);title('\fontsize{20}\color[rgb]{1,0,1} filtered image');

% --- Executes on button press in detect_edge.
function detect_edge_Callback(hObject, eventdata, handles)
% hObject    handle to detect_edge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes3);

if size(img1,3)==3
    img1=rgb2gray(img1);
end
K = medfilt2(img1);
C = double(K);

for i=1:size(C,1)-2
    for j=1:size(C,2)-2
        %sobel mask for x-direction
        Gx=((2*C(i+2,j+1)+C(i+2,j)+C(i+2,j+2))-(2*C(i,j+1)+C(i,j)+C(i,j+2)));
        %sobel mask for y-direction
        Gy=((2*C(i+1,j+2)+C(i,j+2)+C(i+2,j+2))-(2*C(i+1,j)+C(i,j)+C(i+2,j)));
        
        %the gradient of the image
        %B(i,j)=ab(Gx)+abs(Gy);
        B(i,j)=sqrt(Gx.^2+Gy.^2);
        
    end
end
axes(handles.axes3)
imshow(B);title('\fontsize{20}\color[rgb]{1,0,1} edge detection');



% --- Executes on button press in detect_Alzheimer.
function detect_Alzheimer_Callback(hObject, eventdata, handles)
% hObject    handle to detect_Alzheimer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global img1
axes(handles.axes4);
K = medfilt2(img1);
bw=im2bw(k, 0.7);
label = bwlabel(bw);

stats=regionprops(label, 'solidity', 'Area');
density=[stats.solidity];
area=[stats.Area];
high_dense_area=density >0.5;
max_area=max(area(high_dense_area));
tumor_label=find(area==max_area);
tumor=ismember(label,tumor_label);

se=strel('square',5);
tumor=imopen(tumor,se)

Bound=bwboundaries(tumor,'noholes');

imshow(K);
hold on

for i=1:length(Bound)
    plot(Bound{i}(:,2),Bound{i}(:,1),'y','linewidth',1.75)
end

title('\fontsize{20}\color[rgb]{1,0,1} Detection !!!');

hold off
axes(handles.axes5)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox(sprintf('TARUN\Email : tarun.techme@gmail.com'),'Author','Help');


% --------------------------------------------------------------------
function Author_Callback(hObject, eventdata, handles)
% hObject    handle to Author (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
