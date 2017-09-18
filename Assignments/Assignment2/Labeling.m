function varargout = Labeling(varargin)
% LABELING MATLAB code for Labeling.fig
%      LABELING, by itself, creates a new LABELING or raises the existing
%      singleton*.
%
%      H = LABELING returns the handle to a new LABELING or the handle to
%      the existing singleton*.
%
%      LABELING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABELING.M with the given input arguments.
%
%      LABELING('Property','Value',...) creates a new LABELING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Labeling_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Labeling_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Labeling

% Last Modified by GUIDE v2.5 30-Aug-2017 10:26:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Labeling_OpeningFcn, ...
                   'gui_OutputFcn',  @Labeling_OutputFcn, ...
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


% --- Executes just before Labeling is made visible.
function Labeling_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Labeling (see VARARGIN)

% Choose default command line output for Labeling
handles.output = hObject;
handles.saveAvailable = false;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Labeling wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Labeling_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider_frame_Callback(hObject, eventdata, handles)

if isfloat(get(handles.slider_frame, 'Value')) %&& get(handles.slider_frame, 'Value') ~= 1.0
    set(handles.slider_frame, 'Value', floor(get(handles.slider_frame, 'Value')));
end

handles.nCurrentFrame = get(handles.slider_frame, 'Value') + 2;

previous_frame = imrotate( read(handles.video,handles.nCurrentFrame - 1) , -90);
current_frame = imrotate( read(handles.video, handles.nCurrentFrame) , -90);
axes(handles.axes_previousFrame), imshow(previous_frame);
axes(handles.axes_currentFrame), imshow( current_frame);
set(handles.edit_nPreviousFrame, 'String', handles.nCurrentFrame - 1);
set(handles.edit_nCurrentFrame, 'String', handles.nCurrentFrame);

set(handles.text_nPickTotal, 'String', size(handles.pickRangeList,1));
set(handles.text_nEatTotal, 'String', size(handles.eatRangeList,1));

switch  handles.labelData(handles.nCurrentFrame - 1)
    case 0
        set(handles.text_previousFrameLabel,'String', 'None');
        
    case 1
        set(handles.text_previousFrameLabel,'String', 'Pick Start');
        
    case 2
        set(handles.text_previousFrameLabel,'String', 'Pick End');
        
    case 3
        set(handles.text_previousFrameLabel,'String', 'Eat Start');
        
    case 4
        set(handles.text_previousFrameLabel,'String', 'Eat End');
    
end


switch  handles.labelData(handles.nCurrentFrame)
    case 0
        set(handles.text_currentFrameLabel,'String', 'None');
        set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_none) 
    case 1
        set(handles.text_currentFrameLabel,'String', 'Pick Start');
        set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickStart) 
    case 2
        set(handles.text_currentFrameLabel,'String', 'Pick End');
        set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickEnd) 
    case 3
        set(handles.text_currentFrameLabel,'String', 'Eat Start');
        set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatStart) 
    case 4
        set(handles.text_currentFrameLabel,'String', 'Eat End');
        set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatEnd) 
end

guidata(hObject, handles);





% hObject    handle to slider_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton_openFile.
function pushbutton_openFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[videofilename,videopath] = uigetfile('*.mp4','Open video');
set(handles.text_CurrentVideofilename, 'String', 'Loading for video');
 
if (videofilename ~= 0)
    video=VideoReader(strcat(videopath,videofilename));
    handles.video = video;
    handles.videoPath = videopath;
    handles.saveAvailable = true;
    %  dataset read
    if exist(strcat(videopath, videofilename(1:end-4), '_EMG.txt' ), 'file') && exist(strcat(videopath, videofilename(1:end-4), '_IMU.txt' ), 'file') 
        
        handles.EMGData = csvread(strcat(videopath, videofilename(1:end-4), '_EMG.txt' ));
        handles.EMGTime = handles.EMGData(:,1);
        
        handles.IMUData = csvread(strcat(videopath, videofilename(1:end-4), '_IMU.txt' ));
        handles.IMUTime = handles.IMUData(:,1);
        
        handles.newTime = unique([handles.IMUTime; handles.EMGTime]);    
        
        
        handles.Ori1Data = handles.IMUData(:,2);
        handles.normOri1Data = ( handles.Ori1Data  - min( handles.Ori1Data  ) ) / ( max(handles.Ori1Data) - min(handles.Ori1Data) );
        handles.Interpolated_Ori1Data = interp1(handles.IMUTime , handles.Ori1Data, handles.newTime, 'spline');
        handles.Interpolated_normOri1Data = ( handles.Interpolated_Ori1Data  - min( handles.Interpolated_Ori1Data  ) ) / ( max(handles.Interpolated_Ori1Data) - min(handles.Interpolated_Ori1Data) );

        
        handles.Ori2Data = handles.IMUData(:,3);
        handles.normOri2Data = ( handles.Ori2Data  - min( handles.Ori2Data  ) ) / ( max(handles.Ori2Data) - min(handles.Ori2Data) );
        handles.Interpolated_Ori2Data = interp1(handles.IMUTime , handles.Ori2Data, handles.newTime, 'spline');
        handles.Interpolated_normOri2Data = ( handles.Interpolated_Ori2Data  - min( handles.Interpolated_Ori2Data  ) ) / ( max(handles.Interpolated_Ori2Data) - min(handles.Interpolated_Ori2Data) );
        
        
        handles.Ori3Data = handles.IMUData(:,4);
        handles.normOri3Data = ( handles.Ori3Data  - min( handles.Ori3Data  ) ) / ( max(handles.Ori3Data) - min(handles.Ori3Data) );
        handles.Interpolated_Ori3Data = interp1(handles.IMUTime , handles.Ori3Data, handles.newTime, 'spline');
        handles.Interpolated_normOri3Data = ( handles.Interpolated_Ori3Data  - min( handles.Interpolated_Ori3Data  ) ) / ( max(handles.Interpolated_Ori3Data) - min(handles.Interpolated_Ori3Data) );
        
        
        handles.Ori4Data = handles.IMUData(:,5);
        handles.normOri4Data = ( handles.Ori4Data  - min( handles.Ori4Data  ) ) / ( max(handles.Ori4Data) - min(handles.Ori4Data) );
        handles.Interpolated_Ori4Data = interp1(handles.IMUTime , handles.Ori4Data, handles.newTime, 'spline');
        handles.Interpolated_normOri4Data = ( handles.Interpolated_Ori4Data  - min( handles.Interpolated_Ori4Data  ) ) / ( max(handles.Interpolated_Ori4Data) - min(handles.Interpolated_Ori4Data) );
        
        
        handles.Acc1Data = handles.IMUData(:,6);
        handles.normAcc1Data = ( handles.Acc1Data  - min( handles.Acc1Data  ) ) / ( max(handles.Acc1Data) - min(handles.Acc1Data) );
        handles.Interpolated_Acc1Data = interp1(handles.IMUTime , handles.Acc1Data, handles.newTime, 'spline');
        handles.Interpolated_normAcc1Data = ( handles.Interpolated_Acc1Data  - min( handles.Interpolated_Acc1Data  ) ) / ( max(handles.Interpolated_Acc1Data) - min(handles.Interpolated_Acc1Data) );
        
        
        handles.Acc2Data = handles.IMUData(:,7);
        handles.normAcc2Data = ( handles.Acc2Data  - min( handles.Acc2Data  ) ) / ( max(handles.Acc2Data) - min(handles.Acc2Data) );
        handles.Interpolated_Acc2Data = interp1(handles.IMUTime , handles.Acc2Data, handles.newTime, 'spline');
        handles.Interpolated_normAcc2Data = ( handles.Interpolated_Acc2Data  - min( handles.Interpolated_Acc2Data  ) ) / ( max(handles.Interpolated_Acc2Data) - min(handles.Interpolated_Acc2Data) );
        
        
        handles.Acc3Data = handles.IMUData(:,8);
        handles.normAcc3Data = ( handles.Acc3Data  - min( handles.Acc3Data  ) ) / ( max(handles.Acc3Data) - min(handles.Acc3Data) );
        handles.Interpolated_Acc3Data = interp1(handles.IMUTime , handles.Acc3Data, handles.newTime, 'spline');
        handles.Interpolated_normAcc3Data = ( handles.Interpolated_Acc3Data  - min( handles.Interpolated_Acc3Data  ) ) / ( max(handles.Interpolated_Acc3Data) - min(handles.Interpolated_Acc3Data) );
        
        
        
        handles.Gyro1Data = handles.IMUData(:,9);
        handles.normGyro1Data = ( handles.Gyro1Data  - min( handles.Gyro1Data  ) ) / ( max(handles.Gyro1Data) - min(handles.Gyro1Data) );
        handles.Interpolated_Gyro1Data = interp1(handles.IMUTime , handles.Gyro1Data, handles.newTime, 'spline');
        handles.Interpolated_normGyro1Data = ( handles.Interpolated_Gyro1Data  - min( handles.Interpolated_Gyro1Data  ) ) / ( max(handles.Interpolated_Gyro1Data) - min(handles.Interpolated_Gyro1Data) );
        
        
        handles.Gyro2Data = handles.IMUData(:,10);
        handles.normGyro2Data = ( handles.Gyro2Data  - min( handles.Gyro2Data  ) ) / ( max(handles.Gyro2Data) - min(handles.Gyro2Data) );
        handles.Interpolated_Gyro2Data = interp1(handles.IMUTime , handles.Gyro2Data, handles.newTime, 'spline');
        handles.Interpolated_normGyro2Data = ( handles.Interpolated_Gyro2Data  - min( handles.Interpolated_Gyro2Data  ) ) / ( max(handles.Interpolated_Gyro2Data) - min(handles.Interpolated_Gyro2Data) );
        
        
        handles.Gyro3Data = handles.IMUData(:,11);
        handles.normGyro3Data = ( handles.Gyro3Data  - min( handles.Gyro3Data  ) ) / ( max(handles.Gyro3Data) - min(handles.Gyro3Data) );
        handles.Interpolated_Gyro3Data = interp1(handles.IMUTime , handles.Gyro3Data, handles.newTime, 'spline');
        handles.Interpolated_normGyro3Data = ( handles.Interpolated_Gyro3Data  - min( handles.Interpolated_Gyro3Data  ) ) / ( max(handles.Interpolated_Gyro3Data) - min(handles.Interpolated_Gyro3Data) );
        
        
       
        handles.EMG1Data = handles.EMGData(:,2);
        handles.normEMG1Data = ( handles.EMG1Data  - min( handles.EMG1Data  ) ) / ( max(handles.EMG1Data) - min(handles.EMG1Data) );       
        handles.Interpolated_EMG1Data = interp1(handles.EMGTime , handles.EMG1Data, handles.newTime, 'spline');
        handles.Interpolated_normEMG1Data = ( handles.Interpolated_EMG1Data  - min( handles.Interpolated_EMG1Data  ) ) / ( max(handles.Interpolated_EMG1Data) - min(handles.Interpolated_EMG1Data) );
      
        
        handles.EMG2Data = handles.EMGData(:,3);
        handles.normEMG2Data = ( handles.EMG2Data  - min( handles.EMG2Data  ) ) / ( max(handles.EMG2Data) - min(handles.EMG2Data) );
        handles.Interpolated_EMG2Data = interp1(handles.EMGTime , handles.EMG2Data, handles.newTime, 'spline');
        handles.Interpolated_normEMG2Data = ( handles.Interpolated_EMG2Data  - min( handles.Interpolated_EMG2Data  ) ) / ( max(handles.Interpolated_EMG2Data) - min(handles.Interpolated_EMG2Data) );

        
        handles.EMG3Data = handles.EMGData(:,4);
        handles.normEMG3Data = ( handles.EMG3Data  - min( handles.EMG3Data  ) ) / ( max(handles.EMG3Data) - min(handles.EMG3Data) );
        handles.Interpolated_EMG3Data = interp1(handles.EMGTime , handles.EMG3Data, handles.newTime, 'spline');
        handles.Interpolated_normEMG3Data = ( handles.Interpolated_EMG3Data  - min( handles.Interpolated_EMG3Data  ) ) / ( max(handles.Interpolated_EMG3Data) - min(handles.Interpolated_EMG3Data) );

        
        handles.EMG4Data= handles.EMGData(:,5);
        handles.normEMG4Data = ( handles.EMG4Data  - min( handles.EMG4Data  ) ) / ( max(handles.EMG4Data) - min(handles.EMG4Data) );
        handles.Interpolated_EMG4Data = interp1(handles.EMGTime , handles.EMG4Data, handles.newTime, 'spline');
        handles.Interpolated_normEMG4Data = ( handles.Interpolated_EMG4Data  - min( handles.Interpolated_EMG4Data  ) ) / ( max(handles.Interpolated_EMG4Data) - min(handles.Interpolated_EMG4Data) );

        
        handles.EMG5Data = handles.EMGData(:,6);
        handles.normEMG5Data = ( handles.EMG5Data  - min( handles.EMG5Data  ) ) / ( max(handles.EMG5Data) - min(handles.EMG5Data) );
        handles.Interpolated_EMG5Data = interp1(handles.EMGTime , handles.EMG5Data, handles.newTime, 'spline');
        handles.Interpolated_normEMG5Data = ( handles.Interpolated_EMG5Data  - min( handles.Interpolated_EMG5Data  ) ) / ( max(handles.Interpolated_EMG5Data) - min(handles.Interpolated_EMG5Data) );

        
        handles.EMG6Data = handles.EMGData(:,7);
        handles.normEMG6Data = ( handles.EMG6Data  - min( handles.EMG6Data  ) ) / ( max(handles.EMG6Data) - min(handles.EMG6Data) );
        handles.Interpolated_EMG6Data = interp1(handles.EMGTime , handles.EMG6Data, handles.newTime, 'spline');
        handles.Interpolated_normEMG6Data = ( handles.Interpolated_EMG6Data  - min( handles.Interpolated_EMG6Data  ) ) / ( max(handles.Interpolated_EMG6Data) - min(handles.Interpolated_EMG6Data) );

        
        handles.EMG7Data = handles.EMGData(:,8);
        handles.normEMG7Data = ( handles.EMG7Data  - min( handles.EMG7Data  ) ) / ( max(handles.EMG7Data) - min(handles.EMG7Data) );
        handles.Interpolated_EMG7Data = interp1(handles.EMGTime , handles.EMG7Data, handles.newTime, 'spline');
        handles.Interpolated_normEMG7Data = ( handles.Interpolated_EMG7Data  - min( handles.Interpolated_EMG7Data  ) ) / ( max(handles.Interpolated_EMG7Data) - min(handles.Interpolated_EMG7Data) );

        
        handles.EMG8Data = handles.EMGData(:,9);
        handles.normEMG8Data = ( handles.EMG8Data  - min( handles.EMG8Data  ) ) / ( max(handles.EMG8Data) - min(handles.EMG8Data) );
        handles.Interpolated_EMG8Data = interp1(handles.EMGTime , handles.EMG8Data, handles.newTime, 'spline');
        handles.Interpolated_normEMG8Data = ( handles.Interpolated_EMG8Data  - min( handles.Interpolated_EMG8Data  ) ) / ( max(handles.Interpolated_EMG8Data) - min(handles.Interpolated_EMG8Data) );

 
    else
       handles.saveAvailable = false;
       errordlg('There is no EMG or IMU file in terms of this video.');
    end

    handles.labelData = zeros(video.NumberOfFrames, 1);
    
%     if exist(strcat(videofilename(1:end-4), '_label.csv' ), 'file')
%         handles.labelData = csvread(strcat(videofilename(1:end-4), '_label.csv' ));
%     else
%         handles.labelData = zeros(video.NumberOfFrames, 1);
%     end
    
    handles.saveAvailable = true;
    handles.nCurrentFrame = 2;
    handles.pickRangeList = [[]];
    handles.eatRangeList = [[]];
    handles.pickState = false;
    handles.eatState = false;
    handles.nCurrentPickFrame =0;
    handles.nCurrentEatFrame = 0;
    
    firstFrame = read(video, 1);
    firstFrame = imrotate(firstFrame, -90);
    secondFrame = read(video, 2);
    secondFrame = imrotate(secondFrame, -90);
    
    axes(handles.axes_previousFrame), imshow(firstFrame);
    axes(handles.axes_currentFrame), imshow(secondFrame);
    set(handles.edit_nPick, 'String', 0);
    set(handles.edit_nEat, 'String', 0);
    set(handles.text_nTotalFrame, 'String', video.NumberOfFrames);
    set(handles.text_nTotalFrame2, 'String', video.NumberOfFrames);
    set(handles.edit_nPreviousFrame, 'String', '1');
    set(handles.edit_nCurrentFrame, 'String', '2');
    set(handles.slider_frame, 'Min',0);
    set(handles.slider_frame, 'Max',video.NumberOfFrames-2);
    1/(video.NumberOfFrames-2)
    set(handles.slider_frame, 'SliderStep', [1/(video.NumberOfFrames-2), 0.05]);
    set(handles.text_CurrentVideofilename, 'String', videofilename(1:end-4));
    set(handles.text_previousFrameLabel,'String', 'None');
    set(handles.text_currentFrameLabel,'String', 'None');
    set(handles.text_msg_pick_state, 'String', 'Select Pick Start frame');
    set(handles.text_msg_eat_state, 'String', 'Select Eat Start frame');
    

    
    
else
    errordlg('There is no video.');
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.saveAvailable
    if ~handles.eatState && ~handles.pickState
        
        saveTimeLine = 0:1: (str2num( get(handles.text_nTotalFrame, 'String') ) -1);
        saveTimeLine = floor( saveTimeLine * (1000/30) + str2num(get(handles.text_CurrentVideofilename, 'String')) );

        saveOri1Data = interp1(handles.newTime, handles.Interpolated_normOri1Data, saveTimeLine', 'spline');
        saveOri2Data = interp1(handles.newTime, handles.Interpolated_normOri2Data, saveTimeLine', 'spline');
        saveOri3Data = interp1(handles.newTime, handles.Interpolated_normOri3Data, saveTimeLine', 'spline');
        saveOri4Data = interp1(handles.newTime, handles.Interpolated_normOri4Data, saveTimeLine', 'spline');
        
        saveAcc1Data = interp1(handles.newTime, handles.Interpolated_normAcc1Data, saveTimeLine', 'spline');
        saveAcc2Data = interp1(handles.newTime, handles.Interpolated_normAcc2Data, saveTimeLine', 'spline');
        saveAcc3Data = interp1(handles.newTime, handles.Interpolated_normAcc3Data, saveTimeLine', 'spline');
        
        saveGyro1Data = interp1(handles.newTime, handles.Interpolated_normGyro1Data, saveTimeLine', 'spline');
        saveGyro2Data = interp1(handles.newTime, handles.Interpolated_normGyro2Data, saveTimeLine', 'spline');
        saveGyro3Data = interp1(handles.newTime, handles.Interpolated_normGyro3Data, saveTimeLine', 'spline');
        
        saveEMG1Data = interp1(handles.newTime, handles.Interpolated_normEMG1Data, saveTimeLine', 'spline');
        saveEMG2Data = interp1(handles.newTime, handles.Interpolated_normEMG2Data, saveTimeLine', 'spline');
        saveEMG3Data = interp1(handles.newTime, handles.Interpolated_normEMG3Data, saveTimeLine', 'spline');
        saveEMG4Data = interp1(handles.newTime, handles.Interpolated_normEMG4Data, saveTimeLine', 'spline');
        saveEMG5Data = interp1(handles.newTime, handles.Interpolated_normEMG5Data, saveTimeLine', 'spline');
        saveEMG6Data = interp1(handles.newTime, handles.Interpolated_normEMG6Data, saveTimeLine', 'spline');
        saveEMG7Data = interp1(handles.newTime, handles.Interpolated_normEMG7Data, saveTimeLine', 'spline');
        saveEMG8Data = interp1(handles.newTime, handles.Interpolated_normEMG8Data, saveTimeLine', 'spline');
        
        choice = questdlg( sprintf('Do you want to save labels? (if yes, %d Picking label(s) and %d Eating label(s) will be saved.)', size(handles.pickRangeList,1) ,size(handles.eatRangeList,1)) ,  'Save Label',   'Yes', 'No', 'Yes');
        
        if strcmp(choice, 'Yes')
            saveData=[ saveTimeLine', saveOri1Data, saveOri2Data, saveOri3Data, saveOri4Data, saveAcc1Data, saveAcc2Data, saveAcc3Data, saveGyro1Data, saveGyro2Data, saveGyro3Data, saveEMG1Data, saveEMG2Data, saveEMG3Data, saveEMG4Data, saveEMG5Data, saveEMG6Data, saveEMG7Data, saveEMG8Data, handles.labelData ];
            dlmwrite(strcat( handles.videoPath, get(handles.text_CurrentVideofilename, 'String'), '_label.csv' ), saveData, 'delimiter', ',','precision', 15 );
        end 
        
          
        
        
        
    else
        errordlg('Please complete "Choose Label" task at first.');
    end    
    
else
    errordlg('Error: input files (video, EMG, IMU) were not opened.');
    
    
        
end



function edit_nPreviousFrame_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nPreviousFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nPreviousFrame as text
%        str2double(get(hObject,'String')) returns contents of edit_nPreviousFrame as a double


% --- Executes during object creation, after setting all properties.
function edit_nPreviousFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nPreviousFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nCurrentFrame_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nCurrentFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nCurrentFrame as text
%        str2double(get(hObject,'String')) returns contents of edit_nCurrentFrame as a double


% --- Executes during object creation, after setting all properties.
function edit_nCurrentFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nCurrentFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_EMG4.
function checkbox_EMG4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG4
if get(handles.checkbox_EMG4, 'Value')
      axes(handles.axes_graph), handles.Graph_EMG4 = plot(handles.newTime,handles.Interpolated_normEMG4Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_EMG4);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_EMG3.
function checkbox_EMG3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG3
if get(handles.checkbox_EMG3, 'Value')
      axes(handles.axes_graph), handles.Graph_EMG3 = plot(handles.newTime,handles.Interpolated_normEMG3Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_EMG3);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_EMG2.
function checkbox_EMG2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG2
if get(handles.checkbox_EMG2, 'Value')
      axes(handles.axes_graph), handles.Graph_EMG2 = plot(handles.newTime,handles.Interpolated_normEMG2Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_EMG2);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_EMG1.
function checkbox_EMG1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG1

if get(handles.checkbox_EMG1, 'Value')
      axes(handles.axes_graph), handles.Graph_EMG1 = plot(handles.newTime,handles.Interpolated_normEMG1Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_EMG1);
end
guidata(hObject, handles);


% --- Executes on button press in checkbox_EMG5.
function checkbox_EMG5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG5
if get(handles.checkbox_EMG5, 'Value')
      axes(handles.axes_graph), handles.Graph_EMG5 = plot(handles.newTime,handles.Interpolated_normEMG5Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_EMG5);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_EMG6.
function checkbox_EMG6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG6
if get(handles.checkbox_EMG6, 'Value')
      axes(handles.axes_graph), handles.Graph_EMG6 = plot(handles.newTime,handles.Interpolated_normEMG6Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_EMG6);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_EMG7.
function checkbox_EMG7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG7
if get(handles.checkbox_EMG7, 'Value')
      axes(handles.axes_graph), handles.Graph_EMG7 = plot(handles.newTime,handles.Interpolated_normEMG7Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_EMG7);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_EMG8.
function checkbox_EMG8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG8
if get(handles.checkbox_EMG8, 'Value')
      axes(handles.axes_graph), handles.Graph_EMG8 = plot(handles.newTime,handles.Interpolated_normEMG8Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_EMG8);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_EMG_PF.
function checkbox_EMG_PF_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG_PF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG_PF


% --- Executes on button press in checkbox_EMG_PSD.
function checkbox_EMG_PSD_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_EMG_PSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_EMG_PSD


% --- Executes on button press in checkbox_gyroX.
function checkbox_gyroX_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_gyroX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_gyroX
if get(handles.checkbox_gyroX, 'Value')
      axes(handles.axes_graph), handles.Graph_gyroX = plot(handles.newTime,handles.Interpolated_normGyro1Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_gyroX);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_gyroY.
function checkbox_gyroY_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_gyroY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_gyroY
if get(handles.checkbox_gyroY, 'Value')
      axes(handles.axes_graph), handles.Graph_gyroY = plot(handles.newTime,handles.Interpolated_normGyro2Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_gyroY);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_gyroZ.
function checkbox_gyroZ_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_gyroZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_gyroZ
if get(handles.checkbox_gyroZ, 'Value')
      axes(handles.axes_graph), handles.Graph_gyroZ = plot(handles.newTime,handles.Interpolated_normGyro3Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_gyroZ);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_accX.
function checkbox_accX_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_accX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_accX
if get(handles.checkbox_accX, 'Value')
      axes(handles.axes_graph), handles.Graph_accX = plot(handles.newTime,handles.Interpolated_normAcc1Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_accX);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_accY.
function checkbox_accY_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_accY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_accY
if get(handles.checkbox_accY, 'Value')
      axes(handles.axes_graph), handles.Graph_accY = plot(handles.newTime,handles.Interpolated_normAcc2Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_accY);
end
guidata(hObject, handles);


% --- Executes on button press in checkbox_accZ.
function checkbox_accZ_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_accZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_accZ
if get(handles.checkbox_accZ, 'Value')
      axes(handles.axes_graph), handles.Graph_accZ = plot(handles.newTime,handles.Interpolated_normAcc3Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_accZ);
end
guidata(hObject, handles);


% --- Executes on button press in checkbox_oriW.
function checkbox_oriW_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_oriW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_oriW
if get(handles.checkbox_oriW, 'Value')
      axes(handles.axes_graph), handles.Graph_oriW = plot(handles.newTime, handles.Interpolated_normOri1Data);
      hold on;
else
     axes(handles.axes_graph),   delete(handles.Graph_oriW);       
end

guidata(hObject, handles);

% --- Executes on button press in checkbox_oriX.
function checkbox_oriX_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_oriX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_oriX

if get(handles.checkbox_oriX, 'Value')
      axes(handles.axes_graph), handles.Graph_oriX = plot(handles.newTime,handles.Interpolated_normOri2Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_oriX);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_oriY.
function checkbox_oriY_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_oriY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_oriY
if get(handles.checkbox_oriY, 'Value')
      axes(handles.axes_graph), handles.Graph_oriY = plot(handles.newTime,handles.Interpolated_normOri3Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_oriY);
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_oriZ.
function checkbox_oriZ_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_oriZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_oriZ
if get(handles.checkbox_oriZ, 'Value')
      axes(handles.axes_graph), handles.Graph_oriZ = plot(handles.newTime,handles.Interpolated_normOri4Data);
      hold on;
else
      axes(handles.axes_graph),  delete(handles.Graph_oriZ);
end
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_graphType.
function popupmenu_graphType_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_graphType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_graphType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_graphType
handles.graphTypeValue = get(handles.popupmenu_graphType, 'Value');
switch handles.graphTypeValue
    case 1
        set(handles.text_graphType, 'String', 'Raw Dataset Graph');
    case 2
        set(handles.text_graphType, 'String', 'Normalized Dataset Graph');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu_graphType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_graphType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_allchecker_EMG.
function checkbox_allchecker_EMG_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_allchecker_EMG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_allchecker_EMG
if get(handles.checkbox_allchecker_EMG, 'Value')
    set(handles.checkbox_EMG1, 'Value', 1);
    set(handles.checkbox_EMG2, 'Value', 1);
    set(handles.checkbox_EMG3, 'Value', 1);
    set(handles.checkbox_EMG4, 'Value', 1);
    set(handles.checkbox_EMG5, 'Value', 1);
    set(handles.checkbox_EMG6, 'Value', 1);
    set(handles.checkbox_EMG7, 'Value', 1);
    set(handles.checkbox_EMG8, 'Value', 1);
    set(handles.checkbox_EMG_PF, 'Value', 1);
    set(handles.checkbox_EMG_PSD, 'Value', 1);
    
    axes(handles.axes_graph), handles.Graph_EMG1 = plot(handles.newTime, handles.Interpolated_normEMG1Data);
    hold on;
    axes(handles.axes_graph), handles.Graph_EMG2 = plot(handles.newTime, handles.Interpolated_normEMG2Data);
    axes(handles.axes_graph), handles.Graph_EMG3 = plot(handles.newTime, handles.Interpolated_normEMG3Data);
    axes(handles.axes_graph), handles.Graph_EMG4 = plot(handles.newTime, handles.Interpolated_normEMG4Data);
    axes(handles.axes_graph), handles.Graph_EMG5 = plot(handles.newTime, handles.Interpolated_normEMG5Data);
    axes(handles.axes_graph), handles.Graph_EMG6 = plot(handles.newTime, handles.Interpolated_normEMG6Data);
    axes(handles.axes_graph), handles.Graph_EMG7 = plot(handles.newTime, handles.Interpolated_normEMG7Data);
    axes(handles.axes_graph), handles.Graph_EMG8 = plot(handles.newTime, handles.Interpolated_normEMG8Data);
    
    
    
else
    set(handles.checkbox_EMG1, 'Value', 0);
    set(handles.checkbox_EMG2, 'Value', 0);
    set(handles.checkbox_EMG3, 'Value', 0);
    set(handles.checkbox_EMG4, 'Value', 0);
    set(handles.checkbox_EMG5, 'Value', 0);
    set(handles.checkbox_EMG6, 'Value', 0);
    set(handles.checkbox_EMG7, 'Value', 0);
    set(handles.checkbox_EMG8, 'Value', 0);
    set(handles.checkbox_EMG_PF, 'Value', 0);
    set(handles.checkbox_EMG_PSD, 'Value', 0);

    axes(handles.axes_graph),   delete(handles.Graph_EMG1);       
    axes(handles.axes_graph),   delete(handles.Graph_EMG2);       
    axes(handles.axes_graph),   delete(handles.Graph_EMG3);     
    axes(handles.axes_graph),   delete(handles.Graph_EMG4);     
    axes(handles.axes_graph),   delete(handles.Graph_EMG5);     
    axes(handles.axes_graph),   delete(handles.Graph_EMG6);     
    axes(handles.axes_graph),   delete(handles.Graph_EMG7);     
    axes(handles.axes_graph),   delete(handles.Graph_EMG8);     
end
guidata(hObject, handles);



% --- Executes on button press in checkbox_allchecker_accelerometer.
function checkbox_allchecker_accelerometer_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_allchecker_accelerometer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_allchecker_accelerometer
if get(handles.checkbox_allchecker_accelerometer, 'Value')
    set(handles.checkbox_accX, 'Value', 1);
    set(handles.checkbox_accY, 'Value', 1);
    set(handles.checkbox_accZ, 'Value', 1);
    
    axes(handles.axes_graph), handles.Graph_accX = plot(handles.newTime, handles.Interpolated_normAcc1Data);
    hold on;
    axes(handles.axes_graph), handles.Graph_accY = plot(handles.newTime, handles.Interpolated_normAcc2Data);
    axes(handles.axes_graph), handles.Graph_accZ = plot(handles.newTime, handles.Interpolated_normAcc3Data);
    
else
    set(handles.checkbox_accX, 'Value', 0);
    set(handles.checkbox_accY, 'Value', 0);
    set(handles.checkbox_accZ, 'Value', 0);

    axes(handles.axes_graph),   delete(handles.Graph_accX);       
    axes(handles.axes_graph),   delete(handles.Graph_accY);       
    axes(handles.axes_graph),   delete(handles.Graph_accZ);     
end

guidata(hObject, handles);

% --- Executes on button press in checkbox_allchecker_gyroscope.
function checkbox_allchecker_gyroscope_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_allchecker_gyroscope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_allchecker_gyroscope
if get(handles.checkbox_allchecker_gyroscope, 'Value')
    set(handles.checkbox_gyroX, 'Value', 1);
    set(handles.checkbox_gyroY, 'Value', 1);
    set(handles.checkbox_gyroZ, 'Value', 1);
    
    axes(handles.axes_graph), handles.Graph_gyroX = plot(handles.newTime, handles.Interpolated_normGyro1Data);
    hold on;
    axes(handles.axes_graph), handles.Graph_gyroY = plot(handles.newTime, handles.Interpolated_normGyro2Data);
    axes(handles.axes_graph), handles.Graph_gyroZ = plot(handles.newTime, handles.Interpolated_normGyro3Data);
else
    set(handles.checkbox_gyroX, 'Value', 0);
    set(handles.checkbox_gyroY, 'Value', 0);
    set(handles.checkbox_gyroZ, 'Value', 0);

    axes(handles.axes_graph),   delete(handles.Graph_gyroX);       
    axes(handles.axes_graph),   delete(handles.Graph_gyroY);       
    axes(handles.axes_graph),   delete(handles.Graph_gyroZ);     

end
guidata(hObject, handles);

% --- Executes on button press in checkbox_allchecker_orientation.
function checkbox_allchecker_orientation_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_allchecker_orientation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_allchecker_orientation
if get(handles.checkbox_allchecker_orientation, 'Value')
    set(handles.checkbox_oriW, 'Value', 1);
    set(handles.checkbox_oriX, 'Value', 1);
    set(handles.checkbox_oriY, 'Value', 1);
    set(handles.checkbox_oriZ, 'Value', 1);
    axes(handles.axes_graph), handles.Graph_oriW = plot(handles.newTime, handles.Interpolated_normOri1Data);
    hold on;
    axes(handles.axes_graph), handles.Graph_oriX = plot(handles.newTime, handles.Interpolated_normOri2Data);
    axes(handles.axes_graph), handles.Graph_oriY = plot(handles.newTime, handles.Interpolated_normOri3Data);
    axes(handles.axes_graph), handles.Graph_oriZ = plot(handles.newTime, handles.Interpolated_normOri4Data);
    
else
    set(handles.checkbox_oriW, 'Value', 0);
    set(handles.checkbox_oriX, 'Value', 0);
    set(handles.checkbox_oriY, 'Value', 0);
    set(handles.checkbox_oriZ, 'Value', 0);
    axes(handles.axes_graph),   delete(handles.Graph_oriW);       
    axes(handles.axes_graph),   delete(handles.Graph_oriX);       
    axes(handles.axes_graph),   delete(handles.Graph_oriY);       
    axes(handles.axes_graph),   delete(handles.Graph_oriZ);       

end

guidata(hObject, handles);



% --- Executes on slider movement.
function slider_graph_Callback(hObject, eventdata, handles)
% hObject    handle to slider_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text_CurrentVideofilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_CurrentVideofilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in radiobutton_label_none.
function radiobutton_label_none_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_label_none (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_label_none


% --- Executes when selected object is changed in uibuttongroup_label.
function uibuttongroup_label_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_label 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch hObject
    
    case handles.radiobutton_label_none
        
        [row, col] = find(handles.pickRangeList == handles.nCurrentFrame);
        
        if size(row) ~=0
            
            choice = questdlg('Do you want to remove this pick label? (if yes, "Pick Start" and "Pick End" labels will be removed)',  'Remove Pick Label',   'Yes', 'No', 'No');
            
            % Handle response
            switch choice
                case 'Yes'
                    handles.labelData(handles.pickRangeList(row, 1)) = 0;
                    handles.labelData(handles.pickRangeList(row, 2)) = 0;
                    set(handles.text_msg_pick_state, 'String', sprintf('# %d Pick label (%d to %d) is removed.', row, handles.pickRangeList(row,1), handles.pickRangeList(row,2) ));
                    handles.pickRangeList(row, :) = [ ] ;
                    
                case 'No'
                    set(handles.text_msg_pick_state, 'String','Cancel to remove this Pick label.');
                    
                    switch get(handles.text_currentFrameLabel,'String')
                        case 'Pick Start'
                            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickStart) 
                        case 'Pick End'
                            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickEnd) 
                    end
            end
            
        end    
        [row, col] = find(handles.eatRangeList == handles.nCurrentFrame);
        if size(row) ~=0
            choice = questdlg('Do you want to remove this eat label? (if yes, "Eat Start" and "Eat End" labels will be removed)',  'Remove Pick Label',   'Yes', 'No', 'No');
            
            % Handle response
            switch choice
                case 'Yes'
                    handles.labelData(handles.eatRangeList(row, 1)) = 0;
                    handles.labelData(handles.eatRangeList(row, 2)) = 0;
                    set(handles.text_msg_eat_state, 'String', sprintf('# %d Eat label (%d to %d) is removed.', row, handles.eatRangeList(row,1), handles.eatRangeList(row,2) ));
                    handles.eatRangeList(row, :) = [ ] ;                    
                case 'No'
                    set(handles.text_msg_eat_state, 'String','Cancel to remove this Eat label.');
                    switch get(handles.text_currentFrameLabel,'String')
                        case 'Eat Start'
                            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatStart) 
                        case 'Eat End'
                            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatEnd) 
                    end
            end
            
        end
        
        
    case handles.radiobutton_label_pickStart  
        if (~handles.pickState)
            
            if (handles.eatState)
                errordlg('Please complete "Eat" labeling task');
            else
                trouble_Range = 0;

                if handles.nCurrentPickFrame == 0

                    for i=1:size(handles.pickRangeList, 1)
                        if handles.pickRangeList(i,1) <= handles.nCurrentFrame && handles.nCurrentFrame <= handles.pickRangeList(i,2)
                            trouble_Range = i;
                            break;
                        end
                    end

                    if  trouble_Range ==0
                        handles.nCurrentPickFrame = handles.nCurrentFrame;
                        handles.labelData(handles.nCurrentFrame) = 1;
                        handles.pickState = true;
                    else
                        errordlg(sprintf('Please check Pick Navigator # %d ', trouble_Range ));
                    end

                end
            end
            
        else
            errordlg('Please select previous "Pick End" label before select new "Pick Start" label');
            
        end
        
    case handles.radiobutton_label_pickEnd
        if (handles.pickState)
            
            if (handles.eatState)
                errordlg('Please complete "Eat" labeling task');
                
            else
                trouble_Range = 0;

                if handles.nCurrentPickFrame ~= 0

                    for i=1:size(handles.pickRangeList, 1)
                        if handles.pickRangeList(i,1) <= handles.nCurrentFrame && handles.nCurrentFrame <= handles.pickRangeList(i,2)
                            trouble_Range = i;
                            break;
                        end

                    end

                    if  trouble_Range ==0
                        handles.labelData(handles.nCurrentFrame) = 2;
                        handles.pickState = false;
                        handles.pickRangeList = [ handles.pickRangeList ; [ handles.nCurrentPickFrame, handles.nCurrentFrame] ];
                        handles.nCurrentPickFrame = 0;
                    else
                            errordlg(sprintf('Please check Eat Navigator # %d ', trouble_Range ));
                    end


                end
            end
        else
             errordlg('Please select "Pick Start" label at first');
        end
        
    case handles.radiobutton_label_eatStart
        
        if (~handles.eatState)
            
            if (handles.pickState)
                errordlg('Please complete "Pick" labeling task');
                
            else
                trouble_Range = 0;

                if handles.nCurrentEatFrame == 0

                    for i=1:size(handles.eatRangeList, 1)
                        if handles.eatRangeList(i,1) <= handles.nCurrentFrame && handles.nCurrentFrame <= handles.eatRangeList(i,2)
                            trouble_Range = i;
                            break;
                        end
                    end

                    if  trouble_Range ==0
                        handles.nCurrentEatFrame = handles.nCurrentFrame;
                        handles.labelData(handles.nCurrentFrame) = 3;
                        handles.eatState = true;
                    else
                        errordlg(sprintf('Please check Pick Navigator # %d ', trouble_Range ));
                    end

                end
                
            end
            
        else
            errordlg('Please select previous "Eat End" label before select new "Eat Start" label');
        end
        
    case handles.radiobutton_label_eatEnd
        if (handles.eatState)
            
            if (handles.pickState)
                errordlg('Please complete "Pick" labeling task');
                
            else
                trouble_Range = 0;

                 if handles.nCurrentEatFrame ~= 0

                    for i=1:size(handles.eatRangeList, 1)
                        if handles.eatRangeList(i,1) <= handles.nCurrentFrame && handles.nCurrentFrame <= handles.eatRangeList(i,2)
                            trouble_Range = i;
                            break;
                        end
                    end

                    if  trouble_Range ==0
                        handles.labelData(handles.nCurrentFrame) = 4;                   
                        handles.eatRangeList = [ handles.eatRangeList ; [ handles.nCurrentEatFrame, handles.nCurrentFrame] ];
                        handles.eatState = false;
                        handles.nCurrentEatFrame = 0;
                    else
                        errordlg(sprintf('Please check Pick Navigator # %d ', trouble_Range ));
                    end

                 end
            
             
            end
            
        else
             errordlg('Please select "Eat Start" label at first');
        end
        
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton_pickNaviBack.
function pushbutton_pickNaviBack_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pickNaviBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if str2num(get(handles.edit_nPick, 'String')) > str2num(get(handles.text_nPickTotal, 'String'))
    errordlg('The value in the pick navigator must not be over the total assigned picking');
    set(handles.text_msg_pick_state, 'String', 'Please insert the proper value in the pick navigator');
    
else
    
    if get(handles.edit_nPick, 'String') == '0'
        errordlg('Please insert the proper value in the pick navigator');
        set(handles.text_msg_pick_state, 'String', 'Please insert the proper value in the pick navigator');
    elseif get(handles.edit_nPick, 'String') =='1' 
        set(handles.text_msg_pick_state, 'String', sprintf('The %d st Pick label range is bwteen %d and %d', 1, handles.pickRangeList(1,1), handles.pickRangeList(1,2) ));
        previous_frame = imrotate( read(handles.video, handles.pickRangeList(1,1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.pickRangeList(1,1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(1,1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(1,1));
        set(handles.slider_frame, 'Value', handles.pickRangeList(1,1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Pick Start');
        
    else
        set(handles.edit_nPick, 'String', str2num( get(handles.edit_nPick, 'String') ) -1 )
        if get(handles.edit_nPick, 'String') =='1' 
            set(handles.text_msg_pick_state, 'String', sprintf('The %d st Pick label range is bwteen %d and %d', 1, handles.pickRangeList(1,1), handles.pickRangeList(1,2) ));
            previous_frame = imrotate( read(handles.video, handles.pickRangeList(1,1)  - 1) , -90);
            current_frame = imrotate( read(handles.video, handles.pickRangeList(1,1) ) , -90);
            axes(handles.axes_previousFrame), imshow(previous_frame);
            axes(handles.axes_currentFrame), imshow( current_frame);
            set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(1,1)-1);
            set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(1,1));
            set(handles.slider_frame, 'Value', handles.pickRangeList(1,1) - 2);
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
        
        elseif get(handles.edit_nPick, 'String') =='2' 
            set(handles.text_msg_pick_state, 'String', sprintf('The %d nd Pick label range is bwteen %d and %d', 2, handles.pickRangeList(2,1), handles.pickRangeList(2,2) ));
            previous_frame = imrotate( read(handles.video, handles.pickRangeList(2,1)  - 1) , -90);
            current_frame = imrotate( read(handles.video, handles.pickRangeList(2,1) ) , -90);
            axes(handles.axes_previousFrame), imshow(previous_frame);
            axes(handles.axes_currentFrame), imshow( current_frame);
            set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(2,1)-1);
            set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(2,1));
            set(handles.slider_frame, 'Value', handles.pickRangeList(2,1) - 2);
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            
        elseif get(handles.edit_nPick, 'String') =='3' 
            set(handles.text_msg_pick_state, 'String', sprintf('The %d rd Pick label range is bwteen %d and %d', 3, handles.pickRangeList(3,1), handles.pickRangeList(3,2) ));
            previous_frame = imrotate( read(handles.video, handles.pickRangeList(3,1)  - 1) , -90);
            current_frame = imrotate( read(handles.video, handles.pickRangeList(3,1) ) , -90);
            axes(handles.axes_previousFrame), imshow(previous_frame);
            axes(handles.axes_currentFrame), imshow( current_frame);
            set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(3,1)-1);
            set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(3,1));
            set(handles.slider_frame, 'Value', handles.pickRangeList(3,1) - 2);
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            
        else
            set(handles.text_msg_pick_state, 'String', sprintf('The %d th Pick label range is bwteen %d and %d', str2num(get(handles.edit_nPick, 'String')), handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1), handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),2) ));
            previous_frame = imrotate( read(handles.video, handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1)  - 1) , -90);
            current_frame = imrotate( read(handles.video, handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1) ) , -90);
            axes(handles.axes_previousFrame), imshow(previous_frame);
            axes(handles.axes_currentFrame), imshow( current_frame);
            set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1)-1);
            set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1));
            set(handles.slider_frame, 'Value', handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1) - 2);
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            
        end
        
    end

end    




% --- Executes on button press in pushbutton__eatNaviBack.
function pushbutton__eatNaviBack_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton__eatNaviBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2num(get(handles.edit_nEat, 'String')) > str2num(get(handles.text_nEatTotal, 'String'))
    errordlg('The value in the Eat navigator must not be over the total assigned eating');
    set(handles.text_msg_eat_state, 'String', 'Please insert the proper value in the Eat navigator');
    
else
    
    if get(handles.edit_nEat, 'String') == '0'
        errordlg('Please insert the proper value in the Eat navigator');
        set(handles.text_msg_eat_state, 'String', 'Please insert the proper value in the Eat navigator');
    elseif get(handles.edit_nEat, 'String') =='1' 
        set(handles.text_msg_eat_state, 'String', sprintf('The %d st Eat label range is bwteen %d and %d', 1, handles.eatRangeList(1,1), handles.eatRangeList(1,2) ));
        previous_frame = imrotate( read(handles.video, handles.eatRangeList(1,1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.eatRangeList(1,1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(1,1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(1,1));
        set(handles.slider_frame, 'Value', handles.eatRangeList(1,1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Eat Start');
        
    else
        set(handles.edit_nEat, 'String', str2num( get(handles.edit_nEat, 'String') ) -1 )
        if get(handles.edit_nEat, 'String') =='1' 
            set(handles.text_msg_eat_state, 'String', sprintf('The %d st Eat label range is bwteen %d and %d', 1, handles.eatRangeList(1,1), handles.eatRangeList(1,2) ));
            previous_frame = imrotate( read(handles.video, handles.eatRangeList(1,1)  - 1) , -90);
            current_frame = imrotate( read(handles.video, handles.eatRangeList(1,1) ) , -90);
            axes(handles.axes_previousFrame), imshow(previous_frame);
            axes(handles.axes_currentFrame), imshow( current_frame);
            set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(1,1)-1);
            set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(1,1));
            set(handles.slider_frame, 'Value', handles.eatRangeList(1,1) - 2);
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
        
        elseif get(handles.edit_nEat, 'String') =='2' 
            set(handles.text_msg_eat_state, 'String', sprintf('The %d nd Eat label range is bwteen %d and %d', 2, handles.eatRangeList(2,1), handles.eatRangeList(2,2) ));
            previous_frame = imrotate( read(handles.video, handles.eatRangeList(2,1)  - 1) , -90);
            current_frame = imrotate( read(handles.video, handles.eatRangeList(2,1) ) , -90);
            axes(handles.axes_previousFrame), imshow(previous_frame);
            axes(handles.axes_currentFrame), imshow( current_frame);
            set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(2,1)-1);
            set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(2,1));
            set(handles.slider_frame, 'Value', handles.eatRangeList(2,1) - 2);
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            
        elseif get(handles.edit_nEat, 'String') =='3' 
            set(handles.text_msg_eat_state, 'String', sprintf('The %d rd Eat label range is bwteen %d and %d', 3, handles.eatRangeList(3,1), handles.eatRangeList(3,2) ));
            previous_frame = imrotate( read(handles.video, handles.eatRangeList(3,1)  - 1) , -90);
            current_frame = imrotate( read(handles.video, handles.eatRangeList(3,1) ) , -90);
            axes(handles.axes_previousFrame), imshow(previous_frame);
            axes(handles.axes_currentFrame), imshow( current_frame);
            set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(3,1)-1);
            set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(3,1));
            set(handles.slider_frame, 'Value', handles.eatRangeList(3,1) - 2);
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            
        else
            set(handles.text_msg_eat_state, 'String', sprintf('The %d th Eat label range is bwteen %d and %d', str2num(get(handles.edit_nEat, 'String')), handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1), handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),2) ));
            previous_frame = imrotate( read(handles.video, handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1)  - 1) , -90);
            current_frame = imrotate( read(handles.video, handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1) ) , -90);
            axes(handles.axes_previousFrame), imshow(previous_frame);
            axes(handles.axes_currentFrame), imshow( current_frame);
            set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1)-1);
            set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1));
            set(handles.slider_frame, 'Value', handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1) - 2);
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            
        end
        
    end

end    

% --- Executes on button press in pushbutton_pickNaviForward.
function pushbutton_pickNaviForward_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_pickNaviForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_nPick, 'String', str2num( get(handles.edit_nPick, 'String') ) +1 )

if str2num(get(handles.edit_nPick, 'String')) <= 0
    errordlg('The value in the pick navigator must be over zero');
    set(handles.text_msg_pick_state, 'String', 'The value in the pick navigator must be over zero');
elseif str2num(get(handles.edit_nPick, 'String')) >  str2num(get(handles.text_nPickTotal, 'String'))
    errordlg('The value in the Pick navigator must not be over the total assigned picking');
    set(handles.text_msg_pick_state, 'String', 'The value in the Pick navigator must not be over the total assigned picking');
    set(handles.edit_nPick, 'String', str2num( get(handles.edit_nPick, 'String') ) -1 )
else
    if str2num(get(handles.edit_nPick, 'String')) == 1
        set(handles.text_msg_pick_state, 'String', sprintf('The %d st Pick label range is bwteen %d and %d', 1, handles.pickRangeList(1,1), handles.pickRangeList(1,2) ));
        previous_frame = imrotate( read(handles.video, handles.pickRangeList(1,1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.pickRangeList(1,1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(1,1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(1,1));
        set(handles.slider_frame, 'Value', handles.pickRangeList(1,1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Pick Start');
        
    elseif str2num(get(handles.edit_nPick, 'String')) == 2
        set(handles.text_msg_pick_state, 'String', sprintf('The %d nd Pick label range is bwteen %d and %d', 2, handles.pickRangeList(2,1), handles.pickRangeList(2,2) ));
        previous_frame = imrotate( read(handles.video, handles.pickRangeList(2,1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.pickRangeList(2,1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(2,1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(2,1));
        set(handles.slider_frame, 'Value', handles.pickRangeList(2,1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Pick Start');
        
    elseif str2num(get(handles.edit_nPick, 'String')) == 3
        set(handles.text_msg_pick_state, 'String', sprintf('The %d rd Pick label range is bwteen %d and %d', 3, handles.pickRangeList(3,1), handles.pickRangeList(3,2) ));
        previous_frame = imrotate( read(handles.video, handles.pickRangeList(3,1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.pickRangeList(3,1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(3,1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(3,1));
        set(handles.slider_frame, 'Value', handles.pickRangeList(3,1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Pick Start');
        
    else
        set(handles.text_msg_pick_state, 'String', sprintf('The %d st Pick label range is bwteen %d and %d', str2num(get(handles.edit_nPick, 'String')), handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1), handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),2) ));
        previous_frame = imrotate( read(handles.video, handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1));
        set(handles.slider_frame, 'Value', handles.pickRangeList(str2num(get(handles.edit_nPick, 'String')),1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Pick Start');
    end
        
end


% --- Executes on button press in pushbutton_eatNaviForward.
function pushbutton_eatNaviForward_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_eatNaviForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_nEat, 'String', str2num( get(handles.edit_nEat, 'String') ) +1 )

if str2num(get(handles.edit_nEat, 'String')) <= 0
    errordlg('The value in the Eat navigator must be over zero');
    set(handles.text_msg_eat_state, 'String', 'The value in the eat navigator must be over zero');
    
elseif str2num(get(handles.edit_nEat, 'String')) >  str2num(get(handles.text_nEatTotal, 'String'))
    errordlg('The value in the Eat navigator must not be over the total assigned eating');
    set(handles.text_msg_eat_state, 'String', 'The value in the Eat navigator must not be over the total assigned eating');
    set(handles.edit_nEat, 'String', str2num( get(handles.edit_nEat, 'String') ) -1 )
    
else
    if str2num(get(handles.edit_nEat, 'String')) == 1
        set(handles.text_msg_eat_state, 'String', sprintf('The %d st Eat label range is bwteen %d and %d', 1, handles.eatRangeList(1,1), handles.eatRangeList(1,2) ));
        previous_frame = imrotate( read(handles.video, handles.eatRangeList(1,1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.eatRangeList(1,1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(1,1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(1,1));
        set(handles.slider_frame, 'Value', handles.eatRangeList(1,1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Eat Start');
        
    elseif str2num(get(handles.edit_nEat, 'String')) == 2
        set(handles.text_msg_eat_state, 'String', sprintf('The %d nd Eat label range is bwteen %d and %d', 2, handles.eatRangeList(2,1), handles.eatRangeList(2,2) ));
        previous_frame = imrotate( read(handles.video, handles.eatRangeList(2,1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.eatRangeList(2,1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(2,1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(2,1));
        set(handles.slider_frame, 'Value', handles.eatRangeList(2,1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Eat Start');
        
   elseif str2num(get(handles.edit_nEat, 'String')) == 3
        set(handles.text_msg_eat_state, 'String', sprintf('The %d rd Eat label range is bwteen %d and %d', 3, handles.eatRangeList(3,1), handles.eatRangeList(3,2) ));
        previous_frame = imrotate( read(handles.video, handles.eatRangeList(3,1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.eatRangeList(3,1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(3,1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(3,1));
        set(handles.slider_frame, 'Value', handles.eatRangeList(3,1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Eat Start');
    else
        set(handles.text_msg_eat_state, 'String', sprintf('The %d st Eat label range is bwteen %d and %d', str2num(get(handles.edit_nEat, 'String')), handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1), handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),2) ));
        previous_frame = imrotate( read(handles.video, handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1)  - 1) , -90);
        current_frame = imrotate( read(handles.video, handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1) ) , -90);
        axes(handles.axes_previousFrame), imshow(previous_frame);
        axes(handles.axes_currentFrame), imshow( current_frame);
        set(handles.edit_nPreviousFrame, 'String', handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1)-1);
        set(handles.edit_nCurrentFrame, 'String', handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1));
        set(handles.slider_frame, 'Value', handles.eatRangeList(str2num(get(handles.edit_nEat, 'String')),1) - 2);
        set(handles.text_currentFrameLabel,'String', 'Eat Start');
            
    end
end

function edit_nPick_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nPick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nPick as text
%        str2double(get(hObject,'String')) returns contents of edit_nPick as a double


% --- Executes during object creation, after setting all properties.
function edit_nPick_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nPick (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nEat_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nEat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nEat as text
%        str2double(get(hObject,'String')) returns contents of edit_nEat as a double


% --- Executes during object creation, after setting all properties.
function edit_nEat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nEat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton_label_pickStart.
function radiobutton_label_pickStart_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_label_pickStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton_label_pickStart


% --- Executes when selected object is changed in uibuttongroup_allchecker.
function uibuttongroup_allchecker_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_allchecker 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hObject
switch hObject
    
    case checkbox_allchecker_orientation
        
end


% --- Executes when selected object is changed in uibuttongroup_orientation.
function uibuttongroup_orientation_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup_orientation 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text_nPickTotal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_nPickTotal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes_graph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_graph


% --- Executes on button press in pushbutton_forward10.
function pushbutton_forward10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_forward10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2num(get(handles.text_nTotalFrame2, 'String')) >= handles.nCurrentFrame+ 10
    handles.nCurrentFrame = handles.nCurrentFrame+ 10;
    previous_frame = imrotate( read(handles.video,handles.nCurrentFrame - 1) , -90);
    current_frame = imrotate( read(handles.video, handles.nCurrentFrame) , -90);
    axes(handles.axes_previousFrame), imshow(previous_frame);
    axes(handles.axes_currentFrame), imshow( current_frame);
    set(handles.edit_nPreviousFrame, 'String', handles.nCurrentFrame - 1);
    set(handles.edit_nCurrentFrame, 'String', handles.nCurrentFrame);

    set(handles.text_nPickTotal, 'String', size(handles.pickRangeList,1));
    set(handles.text_nEatTotal, 'String', size(handles.eatRangeList,1));
    
    set(handles.slider_frame, 'Value' , get(handles.slider_frame, 'Value') + 10);
    switch  handles.labelData(handles.nCurrentFrame - 1)
        case 0
            set(handles.text_previousFrameLabel,'String', 'None');

        case 1
            set(handles.text_previousFrameLabel,'String', 'Pick Start');

        case 2
            set(handles.text_previousFrameLabel,'String', 'Pick End');

        case 3
            set(handles.text_previousFrameLabel,'String', 'Eat Start');

        case 4
            set(handles.text_previousFrameLabel,'String', 'Eat End');

    end


    switch  handles.labelData(handles.nCurrentFrame)
        case 0
            set(handles.text_currentFrameLabel,'String', 'None');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_none) 
        case 1
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickStart) 
        case 2
            set(handles.text_currentFrameLabel,'String', 'Pick End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickEnd) 
        case 3
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatStart) 
        case 4
            set(handles.text_currentFrameLabel,'String', 'Eat End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatEnd) 
    end
else
    errordlg('The current frame number is over total frames');
end




guidata(hObject, handles);


% --- Executes on button press in pushbutton_forward50.
function pushbutton_forward50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_forward50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2num(get(handles.text_nTotalFrame2, 'String')) >= handles.nCurrentFrame+ 50
    handles.nCurrentFrame = handles.nCurrentFrame+ 50;
    previous_frame = imrotate( read(handles.video,handles.nCurrentFrame - 1) , -90);
    current_frame = imrotate( read(handles.video, handles.nCurrentFrame) , -90);
    axes(handles.axes_previousFrame), imshow(previous_frame);
    axes(handles.axes_currentFrame), imshow( current_frame);
    set(handles.edit_nPreviousFrame, 'String', handles.nCurrentFrame - 1);
    set(handles.edit_nCurrentFrame, 'String', handles.nCurrentFrame);

    set(handles.text_nPickTotal, 'String', size(handles.pickRangeList,1));
    set(handles.text_nEatTotal, 'String', size(handles.eatRangeList,1));
    
    set(handles.slider_frame, 'Value' , get(handles.slider_frame, 'Value') + 50);
    switch  handles.labelData(handles.nCurrentFrame - 1)
        case 0
            set(handles.text_previousFrameLabel,'String', 'None');

        case 1
            set(handles.text_previousFrameLabel,'String', 'Pick Start');

        case 2
            set(handles.text_previousFrameLabel,'String', 'Pick End');

        case 3
            set(handles.text_previousFrameLabel,'String', 'Eat Start');

        case 4
            set(handles.text_previousFrameLabel,'String', 'Eat End');

    end


    switch  handles.labelData(handles.nCurrentFrame)
        case 0
            set(handles.text_currentFrameLabel,'String', 'None');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_none) 
        case 1
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickStart) 
        case 2
            set(handles.text_currentFrameLabel,'String', 'Pick End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickEnd) 
        case 3
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatStart) 
        case 4
            set(handles.text_currentFrameLabel,'String', 'Eat End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatEnd) 
    end
else
    errordlg('The current frame number is over total frames');
end




guidata(hObject, handles);

% --- Executes on button press in pushbutton_back50.
function pushbutton_back50_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_back50 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 3 <= handles.nCurrentFrame- 50
    handles.nCurrentFrame = handles.nCurrentFrame- 50;
    previous_frame = imrotate( read(handles.video,handles.nCurrentFrame - 1) , -90);
    current_frame = imrotate( read(handles.video, handles.nCurrentFrame) , -90);
    axes(handles.axes_previousFrame), imshow(previous_frame);
    axes(handles.axes_currentFrame), imshow( current_frame);
    set(handles.edit_nPreviousFrame, 'String', handles.nCurrentFrame - 1);
    set(handles.edit_nCurrentFrame, 'String', handles.nCurrentFrame);

    set(handles.text_nPickTotal, 'String', size(handles.pickRangeList,1));
    set(handles.text_nEatTotal, 'String', size(handles.eatRangeList,1));
    
    set(handles.slider_frame, 'Value' , get(handles.slider_frame, 'Value') - 50);
    switch  handles.labelData(handles.nCurrentFrame - 1)
        case 0
            set(handles.text_previousFrameLabel,'String', 'None');

        case 1
            set(handles.text_previousFrameLabel,'String', 'Pick Start');

        case 2
            set(handles.text_previousFrameLabel,'String', 'Pick End');

        case 3
            set(handles.text_previousFrameLabel,'String', 'Eat Start');

        case 4
            set(handles.text_previousFrameLabel,'String', 'Eat End');

    end


    switch  handles.labelData(handles.nCurrentFrame)
        case 0
            set(handles.text_currentFrameLabel,'String', 'None');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_none) 
        case 1
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickStart) 
        case 2
            set(handles.text_currentFrameLabel,'String', 'Pick End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickEnd) 
        case 3
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatStart) 
        case 4
            set(handles.text_currentFrameLabel,'String', 'Eat End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatEnd) 
    end
else
    errordlg('The current frame number is less than zero');
end




guidata(hObject, handles);

% --- Executes on button press in pushbutton_back10.
function pushbutton_back10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_back10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 3 <= handles.nCurrentFrame- 10
    handles.nCurrentFrame = handles.nCurrentFrame- 10;
    previous_frame = imrotate( read(handles.video,handles.nCurrentFrame - 1) , -90);
    current_frame = imrotate( read(handles.video, handles.nCurrentFrame) , -90);
    axes(handles.axes_previousFrame), imshow(previous_frame);
    axes(handles.axes_currentFrame), imshow( current_frame);
    set(handles.edit_nPreviousFrame, 'String', handles.nCurrentFrame - 1);
    set(handles.edit_nCurrentFrame, 'String', handles.nCurrentFrame);

    set(handles.text_nPickTotal, 'String', size(handles.pickRangeList,1));
    set(handles.text_nEatTotal, 'String', size(handles.eatRangeList,1));
    
    set(handles.slider_frame, 'Value' , get(handles.slider_frame, 'Value') - 10);
    switch  handles.labelData(handles.nCurrentFrame - 1)
        case 0
            set(handles.text_previousFrameLabel,'String', 'None');

        case 1
            set(handles.text_previousFrameLabel,'String', 'Pick Start');

        case 2
            set(handles.text_previousFrameLabel,'String', 'Pick End');

        case 3
            set(handles.text_previousFrameLabel,'String', 'Eat Start');

        case 4
            set(handles.text_previousFrameLabel,'String', 'Eat End');

    end


    switch  handles.labelData(handles.nCurrentFrame)
        case 0
            set(handles.text_currentFrameLabel,'String', 'None');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_none) 
        case 1
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickStart) 
        case 2
            set(handles.text_currentFrameLabel,'String', 'Pick End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickEnd) 
        case 3
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatStart) 
        case 4
            set(handles.text_currentFrameLabel,'String', 'Eat End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatEnd) 
    end
else
    errordlg('The current frame number is less than zero');
end




guidata(hObject, handles);


% --- Executes on button press in pushbutton_forward1.
function pushbutton_forward1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_forward1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if str2num(get(handles.text_nTotalFrame2, 'String')) >= handles.nCurrentFrame+ 1
    handles.nCurrentFrame = handles.nCurrentFrame+ 1;
    previous_frame = imrotate( read(handles.video,handles.nCurrentFrame - 1) , -90);
    current_frame = imrotate( read(handles.video, handles.nCurrentFrame) , -90);
    axes(handles.axes_previousFrame), imshow(previous_frame);
    axes(handles.axes_currentFrame), imshow( current_frame);
    set(handles.edit_nPreviousFrame, 'String', handles.nCurrentFrame - 1);
    set(handles.edit_nCurrentFrame, 'String', handles.nCurrentFrame);

    set(handles.text_nPickTotal, 'String', size(handles.pickRangeList,1));
    set(handles.text_nEatTotal, 'String', size(handles.eatRangeList,1));
    
    set(handles.slider_frame, 'Value' , get(handles.slider_frame, 'Value') + 1);
    switch  handles.labelData(handles.nCurrentFrame - 1)
        case 0
            set(handles.text_previousFrameLabel,'String', 'None');

        case 1
            set(handles.text_previousFrameLabel,'String', 'Pick Start');

        case 2
            set(handles.text_previousFrameLabel,'String', 'Pick End');

        case 3
            set(handles.text_previousFrameLabel,'String', 'Eat Start');

        case 4
            set(handles.text_previousFrameLabel,'String', 'Eat End');

    end


    switch  handles.labelData(handles.nCurrentFrame)
        case 0
            set(handles.text_currentFrameLabel,'String', 'None');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_none) 
        case 1
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickStart) 
        case 2
            set(handles.text_currentFrameLabel,'String', 'Pick End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickEnd) 
        case 3
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatStart) 
        case 4
            set(handles.text_currentFrameLabel,'String', 'Eat End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatEnd) 
    end
else
    errordlg('The current frame number is over total frames');
end




guidata(hObject, handles);

% --- Executes on button press in pushbutton_back1.
function pushbutton_back1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_back1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if 3 <= handles.nCurrentFrame- 1
    handles.nCurrentFrame = handles.nCurrentFrame- 1;
    previous_frame = imrotate( read(handles.video,handles.nCurrentFrame - 1) , -90);
    current_frame = imrotate( read(handles.video, handles.nCurrentFrame) , -90);
    axes(handles.axes_previousFrame), imshow(previous_frame);
    axes(handles.axes_currentFrame), imshow( current_frame);
    set(handles.edit_nPreviousFrame, 'String', handles.nCurrentFrame - 1);
    set(handles.edit_nCurrentFrame, 'String', handles.nCurrentFrame);

    set(handles.text_nPickTotal, 'String', size(handles.pickRangeList,1));
    set(handles.text_nEatTotal, 'String', size(handles.eatRangeList,1));
    
    set(handles.slider_frame, 'Value' , get(handles.slider_frame, 'Value') - 1);
    switch  handles.labelData(handles.nCurrentFrame - 1)
        case 0
            set(handles.text_previousFrameLabel,'String', 'None');

        case 1
            set(handles.text_previousFrameLabel,'String', 'Pick Start');

        case 2
            set(handles.text_previousFrameLabel,'String', 'Pick End');

        case 3
            set(handles.text_previousFrameLabel,'String', 'Eat Start');

        case 4
            set(handles.text_previousFrameLabel,'String', 'Eat End');

    end


    switch  handles.labelData(handles.nCurrentFrame)
        case 0
            set(handles.text_currentFrameLabel,'String', 'None');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_none) 
        case 1
            set(handles.text_currentFrameLabel,'String', 'Pick Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickStart) 
        case 2
            set(handles.text_currentFrameLabel,'String', 'Pick End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_pickEnd) 
        case 3
            set(handles.text_currentFrameLabel,'String', 'Eat Start');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatStart) 
        case 4
            set(handles.text_currentFrameLabel,'String', 'Eat End');
            set(handles.uibuttongroup_label,'SelectedObject', handles.radiobutton_label_eatEnd) 
    end
else
    errordlg('The current frame number is less than zero');
end




guidata(hObject, handles);
