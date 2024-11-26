function varargout = Spherical_Harmonic_Analysis_And_Synthesis(varargin)
% SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS MATLAB code for Spherical_Harmonic_Analysis_And_Synthesis.fig
%      SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS, by itself, creates a new SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS or raises the existing
%      singleton*.
%
%      H = SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS returns the handle to a new SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS or the handle to
%      the existing singleton*.
%
%      SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS.M with the given input arguments.
%
%      SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS('Property','Value',...) creates a new SPHERICAL_HARMONIC_ANALYSIS_AND_SYNTHESIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Spherical_Harmonic_Analysis_And_Synthesis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Spherical_Harmonic_Analysis_And_Synthesis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Spherical_Harmonic_Analysis_And_Synthesis

% Last Modified by GUIDE v2.5 15-Nov-2024 15:41:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Spherical_Harmonic_Analysis_And_Synthesis_OpeningFcn, ...
                   'gui_OutputFcn',  @Spherical_Harmonic_Analysis_And_Synthesis_OutputFcn, ...
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


% --- Executes just before Spherical_Harmonic_Analysis_And_Synthesis is made visible.
function Spherical_Harmonic_Analysis_And_Synthesis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Spherical_Harmonic_Analysis_And_Synthesis (see VARARGIN)
global data
data=[];
% Choose default command line output for Spherical_Harmonic_Analysis_And_Synthesis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Spherical_Harmonic_Analysis_And_Synthesis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Spherical_Harmonic_Analysis_And_Synthesis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;global nlat;global nlon;
data=[];
[filename,pathname,c] = uigetfile('*.txt'); 
if c == 1
    file = [pathname, filename];
    try
        data = load(file);
    catch
        data = csvread(file);
    end
    % set(handles.uitable2, 'data', data);

    unique_longitudes = unique(data(:, 1));
    unique_latitudes = unique(data(:, 2));

    min_longitude = min(unique_longitudes);
    max_longitude = max(unique_longitudes);
    n_longitudes = length(unique_longitudes);
    longitude_interval = (max_longitude - min_longitude) / (n_longitudes - 1);

    min_latitude = min(unique_latitudes);
    max_latitude = max(unique_latitudes);
    n_latitudes = length(unique_latitudes);
    latitude_interval = (max_latitude - min_latitude) / (n_latitudes - 1);


if abs(longitude_interval - latitude_interval) > 1e-10  % 容差用于避免浮点误差
    helpdlg('经度与纬度间隔不一致', '警告');
    return;
end    
    set(handles.uitable2, 'data', data); 
    datainterval=latitude_interval;
    nmax = 180 / datainterval;
    set(handles.edit1, 'string', nmax);
    set(handles.edit2, 'string', datainterval);
    set(handles.edit3, 'string', datainterval);

    lonmax = max(data(:,1));
    lonmin = min(data(:,1));
    latmax = max(data(:,2));
    latmin = min(data(:,2));

    nlat = (latmax - latmin) / datainterval + 1;
    nlon = (lonmax - lonmin) / datainterval + 1;
    set(handles.edit4, 'string', nlat);
    set(handles.edit5, 'string', nlon);
else
    set(handles.edit1, 'string', '');
    set(handles.edit2, 'string', '');
    set(handles.edit3, 'string', '');
    set(handles.edit4, 'string', '');
    set(handles.edit5, 'string', '');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;
global Result_CSnm;
global sz
global m1 m2 m3 m4 m5
cla(handles.axes1, 'reset');
nmax=str2double(get(handles.edit1,'string'));
dlat=str2double(get(handles.edit2,'string'));
dlon=str2double(get(handles.edit3,'string'));
nlat=str2double(get(handles.edit4,'string'));
nlon=str2double(get(handles.edit5,'string'));
m1=get(handles.radiobutton1,"value");
m2=get(handles.radiobutton2,"value");
m3=get(handles.radiobutton3,"value");
m4=get(handles.radiobutton4,"value");
m5=get(handles.radiobutton5,"value");
sz=dlat*2;
[Anm,Bnm] = AB_matrix(data,nlat,nlon);
if m1==1   
   Result_CSnm = LS_SHA(Anm,Bnm,data,nlat,nmax);
elseif m2==1
   Result_CSnm = LWS_SHA(Anm,Bnm,data,nlat,nmax);
elseif m3==1
   Result_CSnm = AQ_SHA(Anm,Bnm,data,nlat,nmax);
elseif m4==1
   Result_CSnm =FNM_SHA(Anm,Bnm,data,nlat,nmax);
elseif m5==1
   Result_CSnm =FFT_SHA(data,nmax, dlat, dlon, nlat, nlon);
end
set(handles.uitable3,'data',Result_CSnm);
axes(handles.axes1);
grid on
scatter(-Result_CSnm(:,2),Result_CSnm(:,1),sz,log10((abs(Result_CSnm(:,4)))),'filled');
colormap(jet)
hold on
scatter(Result_CSnm(:,2),Result_CSnm(:,1),sz,log10((abs(Result_CSnm(:,3)))),'filled');
colormap(jet)
xlabel('Snm           Order           Cnm');
ylabel('Degree');
colorbar('peer',handles.axes1);
% set(get(h,'Title'),'string','log10');


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CSnm;
[filename,pathname,c]=uigetfile('*.txt');
if c==1
    file=[pathname,filename];
    try   
       CSnm =dlmread(file);  
    catch
       CSnm=csvread(file);
    end
    set(handles.uitable4,'data',CSnm);
end
% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
w1=get(handles.popupmenu2,'Value');
v1=get(handles.radiobutton6,'Value');
v2=get(handles.radiobutton7,'Value');
if v1==1
 if w1==1
  set(handles.edit6,'enable',"on");
  set(handles.edit7,'enable',"on");
  set(handles.edit8,'enable',"on");
  set(handles.edit10,'enable',"on");
  set(handles.edit11,'enable',"on");
  set(handles.edit12,'enable',"on");

 else
  set(handles.edit6,'enable',"off");
  set(handles.edit7,'enable',"off");
  set(handles.edit8,'enable',"off");
  set(handles.edit10,'enable',"off");
  set(handles.edit11,'enable',"off");
  set(handles.edit12,'enable',"off");

 end
end
if v2==1
   if w1==1
  set(handles.edit6,'enable',"on");
  set(handles.edit7,'enable',"on");
  set(handles.edit8,'enable',"on");
  set(handles.edit10,'enable',"on");
  set(handles.edit11,'enable',"on");
  set(handles.edit12,'enable',"on");
  set(handles.edit13,'enable',"on");
  set(handles.pushbutton17,'enable',"on");
  else
  helpdlg('基于FFT算法的球谐综合不能进行不规则格网计算，请换AI算法');
  set(handles.edit6,'enable',"off");
  set(handles.edit7,'enable',"off");
  set(handles.edit8,'enable',"off");
  set(handles.edit10,'enable',"off");
  set(handles.edit11,'enable',"off");
  set(handles.edit12,'enable',"off");
  set(handles.edit13,'enable',"off");
  set(handles.pushbutton17,'enable',"off");
  end 
end
 
% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global w1 data1
w1=get(handles.popupmenu2,'Value');
switch w1
   case 1
       % [file,path,indx] = uigetfile('*.txt');
       %  if isequal(file,0)
       %     disp('User selected Cancel')  
       %  else
       %     disp(['User selected ', fullfile(path, file), 'and filter index: ', num2str(indx)])
       %     d=csvread(file);
       %     set(handles.edit6,'String',num2str(d(1,1)));
       %     set(handles.edit7,'String',num2str(d(1,2)));
       %     set(handles.edit8,'String',num2str(d(1,3)));
       %     set(handles.edit10,'String',num2str(d(2,1)));
       %     set(handles.edit11,'String',num2str(d(2,2)));
       %     set(handles.edit12,'String',num2str(d(2,3)));
       %     set(handles.edit13,'String',num2str(d(3,1)));
        % end
[file, path, indx] = uigetfile('*.txt');
if isequal(file, 0)
    disp('User selected Cancel');
else
    disp(['User selected ', fullfile(path, file), ' and filter index: ', num2str(indx)]);
    fid = fopen(fullfile(path, file), 'r');
    data = textscan(fid, '%s %s %s', 'Delimiter', ','); 
    fclose(fid);
    row1 = str2double(data{1}{1});
    row2 = eval(data{2}{1});        
    row3 = str2double(data{3}{1});  
    row4 = str2double(data{1}{2});  
    row5 = eval(data{2}{2});     
    row6 = str2double(data{3}{2});  
    row7 = str2double(data{1}{3}); 
    set(handles.edit6, 'String', num2str(row1));
    set(handles.edit7, 'String', num2str(row2));
    set(handles.edit8, 'String', num2str(row3));
    set(handles.edit10, 'String', num2str(row4));
    set(handles.edit11, 'String', num2str(row5));
    set(handles.edit12, 'String', num2str(row6));
    set(handles.edit13, 'String', num2str(row7));
end
    case 2
        [file,path,indx] = uigetfile('*.txt');
        if isequal(file,0)
           disp('User selected Cancel')
        else
           disp(['User selected ', fullfile(path, file), 'and filter index: ', num2str(indx)])
           data1=dlmread(file);
           set(handles.uitable5,'data',data1);
           set(handles.edit6,'enable',"off");
           set(handles.edit7,'enable',"off");
           set(handles.edit8,'enable',"off");
           set(handles.edit10,'enable',"off");
           set(handles.edit11,'enable',"off");
           set(handles.edit12,'enable',"off");
           
        end
    otherwise
        errorMessage = 'An error occurred';
        errordlg(errorMessage, 'error', 'modal');     
end

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global w1 lon_begin lon_interval lon_end lat_begin lat_interval lat_end 
w1=get(handles.popupmenu2,'Value');
if w1==1
lon_begin=str2double(get(handles.edit6,'String'));  
lon_interval=str2double(get(handles.edit7,'String'));
lon_end=str2double(get(handles.edit8,'String'));
lat_begin=str2double(get(handles.edit10,'String'));  
lat_interval=str2double(get(handles.edit11,'String'));
lat_end=str2double(get(handles.edit12,'String'));
Q1=lon_begin:lon_interval:lon_end;
Q2=lat_begin:lat_interval:lat_end;
output1 = zeros(length(Q1) * length(Q2), 2); 
[qGrid, wGrid] = meshgrid(Q1, Q2);          
output1(:, 1) = qGrid(:);                    
output1(:, 2) = wGrid(:);                   
set(handles.uitable5,'data',output1);
set(handles.edit6,'Enable','off');
set(handles.edit7,'Enable','off');
set(handles.edit8,'Enable','off');
set(handles.edit10,'Enable','off');
set(handles.edit11,'Enable','off');
set(handles.edit12,'Enable','off');
set(handles.edit13,'Enable','off');
set(handles.pushbutton17,'Enable','off');
else
set(handles.edit6,'Enable','off');
set(handles.edit7,'Enable','off');
set(handles.edit8,'Enable','off');
set(handles.edit10,'Enable','off');
set(handles.edit11,'Enable','off');
set(handles.edit12,'Enable','off');
set(handles.edit13,'Enable','off');
set(handles.pushbutton17,'Enable','off');
end

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit6,'String','');
set(handles.edit7,'String','');
set(handles.edit8,'String','');
set(handles.edit10,'String','');
set(handles.edit11,'String','');
set(handles.edit12,'String','');
set(handles.edit13,'String','');
set(handles.edit6,'Enable','on');
set(handles.edit7,'Enable','on');
set(handles.edit8,'Enable','on');
set(handles.edit10,'Enable','on');
set(handles.edit11,'Enable','on');
set(handles.edit12,'Enable','on');
set(handles.edit13,'Enable','on');
set(handles.uitable5,'Enable','on');
set(handles.uitable5, 'Data', '');
set(handles.pushbutton17,'Enable','on');





% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% h = figure('visible','off');
% new_axes = copyobj(handles.axes2,h);
% set(new_axes,'Units','default','Position','default');
%     [filename, pathname] = uiputfile({'*.png';'*.bmp';'*.jpg'},'The picture is saved as');
% if filename ~= 0
%         file = strcat(pathname,filename);
%         saveas(h,file);
%         msgbox('The image has been successfully saved','Attention','help');
% else
%         msgbox('The operation has been canceled','Attention','warn');
% end

new_f_handle=figure('visible','off');
new_axes=copyobj(handles.axes2,new_f_handle);
set(new_axes,'units','default','Position','default');
colorbar;
colormap(jet)
[filename,pathname]=uiputfile({'*.png'},'save picture as');
if ~filename
    return
else
    file=strcat(pathname,filename);
    print(new_f_handle,'-djpeg',file);
end
delete(new_f_handle);
h=dialog('Name','Save data','Position',[200 200 200 70]);
uicontrol('Style','text','Units','pixels','Position',[50 40 120 20],'FontSize',10,...
    'Parent',h,'String','save done'); 
uicontrol('Units','pixels','Position',[80 10 50 20],'FontSize',10,...
    'Parent',h,'String','OK','Callback','delete(gcf)');


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes2, 'reset');

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fresult
[filename, pathname, c] = uiputfile('*.txt', 'save');
if c == 1
    file = fullfile(pathname, filename);
    writematrix(fresult, file, 'Delimiter', '\t');
    helpdlg('Successfully saved!');
end

% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable7, 'Data', '');


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% h = figure('visible','off');
% new_axes = copyobj(handles.axes1,h);
% set(new_axes,'Units','default','Position','default');
%     [filename, pathname] = uiputfile({'*.png';'*.bmp';'*.jpg'},'The picture is saved as');
% if filename ~= 0
%         file = strcat(pathname,filename);
%         saveas(h,file);
%         msgbox('The image has been successfully saved','Attention','help');
% else
%         msgbox('The operation has been canceled','Attention','warn');
% end
% 创建一个不可见的图形对象
% 如果 handles.axes1 是属于 figure 对象的，可以直接保存该 figure
global sz
h = figure('visible','off');
new_axes = copyobj(handles.axes1,h);
set(new_axes,'Units','default','Position','default');
hScatter = findobj(new_axes, 'Type', 'Scatter');
    p=2*sz;
    set(hScatter, 'SizeData',p );
    colorbar;
    % c.Title.String='log10';
    colormap(jet)
    [filename, pathname] = uiputfile({'*.png';'*.bmp';'*.jpg'},'The picture is saved as');
if filename ~= 0
        file = strcat(pathname,filename);
        saveas(h,file);
        msgbox('The image has been successfully saved','Attention','help');
else
        msgbox('The operation has been canceled','Attention','warn');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1, 'reset');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Result_CSnm
[filename,pathname,c]=uiputfile('*.txt','save');
if c==1
file=[pathname,filename];
dlmwrite(file,Result_CSnm);
helpdlg('Successfully saved!')
end

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable3, 'Data', '');

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Result_CSnm  CSnm  
u=Result_CSnm;
CSnm=u;
set(handles.uitable4,'data', CSnm);


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global CSnm;
global fresult;
global data1;
global nlat;
global nlon;
axes(handles.axes2);
v1=get(handles.radiobutton6,"value");
v2=get(handles.radiobutton7,"value");
if handles.popupmenu2.Value == 1
nmax=str2double(get(handles.edit13,'string'));
dlat=abs(str2double(get(handles.edit11,'string')));
dlon=abs(str2double(get(handles.edit7,'string')));
lat_min=str2double(get(handles.edit10,'string'));
lat_max=str2double(get(handles.edit12,'string'));
lon_min=str2double(get(handles.edit6,'string'));
lon_max=str2double(get(handles.edit8,'string'));
lat=lat_max:-dlat:lat_min;
lon=lon_min:dlon:lon_max;
nlat=size(lat,2);
nlon=size(lon,2);
if v1==1
f=SHS_regular(CSnm,nmax,lat,lon);
else
[f]=FFT_SHS(CSnm,nmax,lat_max,lat_min,lon_max,lon_min,dlat,dlon);
end
fresult=zeros(nlat*nlon,3);
for i=1:nlat
     for j=1:nlon
      fresult((i-1)*nlon+j,1)=lon(j);
      fresult((i-1)*nlon+j,2)=lat(i);
      fresult((i-1)*nlon+j,3)=f(i,j);
     end
end 
latmax=max(fresult(:,2));
latmin=min(fresult(:,2));
lonmax=max(fresult(:,1));
lonmin=min(fresult(:,1));
data1=reshape(fresult(:,3),nlon,nlat);
datap=data1';
datap=flipud(datap);
imagesc([lonmin lonmax],[latmin latmax],datap);
set(gca, 'YDir', 'normal');
colormap(jet)
colorbar;
xlim([lonmin lonmax]);
ylim([latmin latmax]); 
xlabel('经度/度','FontSize', 12);
ylabel('纬度/度','FontSize', 12);
axes(handles.axes2)
elseif handles.popupmenu2.Value == 2
nmax=str2double(get(handles.edit13,'string'));
f=SHS_irregular(data1,CSnm,nmax);
fresult=zeros(size(data1,1),3);
fresult(:,[1,2])=data1;
fresult(:,3)=f;
data1=zeros(size(fresult));
data1(:,[1,2])=ceil(fresult(:,[1,2]));
data1(:,3)=fresult(:,3);
scatter(data1(:, 1), data1(:, 2), 1, data1(:, 3));
colormap('jet');
colorbar;
xlabel('经度/度','FontSize', 12);
ylabel('纬度/度','FontSize', 12);
end
set(handles.uitable7,'data',fresult);








function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data;global nlon;global nlat;
if isempty(data)
   helpdlg('未加载数据，请先点击读取文件按钮', '警告');
    return; 
end
latmax=max(data(:,2));
latmin=min(data(:,2));
lonmax=max(data(:,1));
lonmin=min(data(:,1));
data1=reshape(data(:,3),nlon,nlat);
datap=data1';
datap=flipud(datap);
figure();  
imagesc([lonmin lonmax],[latmin latmax],datap);
set(gca, 'YDir', 'normal');
colormap(jet)
colorbar;
xlim([lonmin lonmax]);
ylim([latmin latmax]); 
xlabel('经度/度','FontSize', 12);
ylabel('纬度/度','FontSize', 12);
