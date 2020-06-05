% ������� �������
function [ ] = show_interface()
clear all
% ������� ��� ��������� ����������

% ������ ��� �������������� ������ � 
% �������������
global raw_data;
raw_data = [];

% �������� ������ ���� ����������
show_fw();

% ������� ��� ����������� �������

% h_e_rprd - handle_edit_ratio_plot_raw_data
h_e_rprd = findobj('Tag','t_e_rprd');
% ������ ��� ���������� ������� � ������� ��� 
t1 = timer('Name','plot_data',...
    'TimerFcn', @timer_plot_data,...
    'ExecutionMode','fixedRate',...
    'Period',1/str2double(h_e_rprd.String));

% h_e_rrd - handle_edit_ratio_receive_data
h_e_rrd = findobj('Tag','t_e_rrd');
% ������ ��� ��������� ����� ������ ���
t2 = timer('Name','receive_data',...
    'TimerFcn', @timer_receive_data,...
    'ExecutionMode','fixedRate',...
    'Period',1/str2double(h_e_rrd.String));

% h_e_rfb - handle_edit_ratio_feedback
h_e_rfb = findobj('Tag','t_e_rfb');
% ������ ��� ���������� ������� �������� �����
timer('Name','plot_feedback',...
    'TimerFcn', @timer_feedback,...
    'ExecutionMode','fixedRate',...
    'Period',1/str2double(h_e_rfb.String));

end

% ����� ������� ��� ������� ���� ����������
function show_fw(src,callbackdata)
% ������� ��������� ������� ���� ����������
% ����� ���������� ��������� ��������� ��� ������ ����
% h_fw - handle_first_window
% t_ifw - tag_interface_first_window
h_fw = figure('Name','Adaptive neurofeedback','NumberTitle','off','Tag','t_ifw','MenuBar','none');
%fwsz - first_window_size
fwsz = get(h_fw, 'Position');
% ������ ��������� � �������� ��� ����������� ����������� ��������� ��� ���������������
%fw_pos - first_window_positions
fw_pos = [fwsz(3) fwsz(4) fwsz(3) fwsz(4)];
set(h_fw,'SizeChangedFcn',@resize_fw,'CloseRequestFcn',@close_fw);


% ������� "������� �����������"
% t_t_cs - tag_text_choose_subject
uicontrol('Parent', h_fw, 'Style', 'text', 'String', 'Choose the subject', 'Position', [0.05 0.8 0.3 0.08].*fw_pos,'HorizontalAlignment','left','Tag','t_t_cs');
% ���������� ���� "������� �����������"
uicontrol('Parent', h_fw, 'Style', 'popup', 'String', {'New subject'}, 'Position', [0.35 0.8 0.3 0.08].*fw_pos,'Tag','t_p_cs');

% ������� "������� ���������� ������� ����� ������"
% t_t_rprd - tag_text_ratio_plot_raw_data
uicontrol('Parent', h_fw, 'Style', 'text', 'String', 'Frequency of plot update, Hz', 'Position', [0.05 0.7 0.3 0.08].*fw_pos,'HorizontalAlignment','left','Tag','t_t_rprd');
% ���� ��� ����� ��� ������� ��������� ������� 
uicontrol('Parent', h_fw, 'Style', 'edit', 'String', '250', 'Position', [0.35 0.7 0.1 0.08].*fw_pos,'Tag','t_e_rprd');

% ������� "������� ��������� ������"
% t_t_rrd - tag_text_ratio_receive_data
uicontrol('Parent', h_fw, 'Style', 'text', 'String', 'Data frequency, Hz', 'Position', [0.05 0.6 0.3 0.08].*fw_pos,'HorizontalAlignment','left','Tag','t_t_rrd');
% ���� ��� ����� ��� ������� ��������� ������ ������ 
uicontrol('Parent', h_fw, 'Style', 'edit', 'String', '250', 'Position', [0.35 0.6 0.1 0.08].*fw_pos,'Tag','t_e_rrd');

%-------------------------------------------------------
% ������� "������� ���������� �������� �����"
% t_t_rfb - tag_text_ratio_feedback
uicontrol('Parent', h_fw, 'Style', 'text', 'String',...
    'Feedback frequency, Hz',...
    'Position', [0.05 0.5 0.3 0.08].*fw_pos,...
    'HorizontalAlignment','left','Tag','t_t_rfb');
% ���� ��� ����� ��� ������� ����������
% �������� ����� 
uicontrol('Parent', h_fw, 'Style', 'edit',...
    'String', '250','Tag','t_e_rfb',...
    'Position', [0.35 0.5 0.1 0.08].*fw_pos);


%-------------------------------------------------------
% ������ "���������� ���" ��������� 
% ���� ������ ��� 
% t_b_starte - tag_button_start_experiment
uicontrol('Parent',h_fw,'Style','pushbutton',...
    'String', 'Connect to EEG','Position',...
    [0.7 0.8 0.2 0.08].*fw_pos,...
    'Callback',@cb_connect_eeg,...
    'Tag','t_b_connEEG');

%-------------------------------------------------------
% ������ "���������" 
% ��������� ������������ CSP ������� � ���������� ������
% t_b_saveall - tag_button_save_all
uicontrol('Parent',h_fw,'Style','pushbutton',...
    'String', 'Save ...','Position',...
    [0.7 0.6 0.2 0.08].*fw_pos,...
    'Callback',@cb_save_all,...
    'Tag','t_b_saveall');

%-------------------------------------------------------
% ������ "���������" 
% ��������� ������������ CSP ������� 
% t_b_loadall - tag_button_load_all
uicontrol('Parent',h_fw,'Style','pushbutton',...
    'String', 'Load ...','Position',...
    [0.7 0.4 0.2 0.08].*fw_pos,...
    'Callback',@cb_load_all,...
    'Tag','t_b_loadall');

end

function resize_fw(src,callbackdata)
h_fw = findobj(gcbo,'Tag','t_ifw');
figsz = get(h_fw, 'Position');
pos_vect = [figsz(3) figsz(4) figsz(3) figsz(4)];

h_t_cs = findobj(gcbo,'Tag','t_t_cs');
h_p_cs = findobj(gcbo,'Tag','t_p_cs');  

h_t_rprd = findobj(gcbo,'Tag','t_t_rprd');
h_e_rprd = findobj(gcbo,'Tag','t_e_rprd');

h_t_rrd = findobj(gcbo,'Tag','t_t_rrd');
h_e_rrd = findobj(gcbo,'Tag','t_e_rrd');

h_t_rfb = findobj(gcbo,'Tag','t_t_rfb');
h_e_rfb = findobj(gcbo,'Tag','t_e_rfb');

h_b_se = findobj(gcbo,'Tag','t_b_se');

set(h_t_cs,'Position',[0.05 0.8 0.3 0.08].*pos_vect)
set(h_p_cs,'Position',[0.35 0.8 0.3 0.08].*pos_vect)

set(h_t_rprd,'Position',[0.05 0.7 0.3 0.08].*pos_vect)
set(h_e_rprd,'Position',[0.35 0.7 0.1 0.08].*pos_vect)

set(h_t_rrd,'Position',[0.05 0.6 0.3 0.08].*pos_vect)
set(h_e_rrd,'Position',[0.35 0.6 0.1 0.08].*pos_vect)

set(h_t_rfb,'Position',[0.05 0.5 0.3 0.08].*pos_vect)
set(h_e_rfb,'Position',[0.35 0.5 0.1 0.08].*pos_vect)

set(h_b_se,'Position',[0.1 0.01 0.2 0.08].*pos_vect)
end

function close_fw(src,callbackdata)
h_fw = findobj(gcbo,'Tag','t_ifw');
h_sw = findobj(gcbo,'Tag','t_isw');

stop(timerfind);

delete(h_fw)
delete(h_sw)
delete(timerfind)

end

function cb_connect_eeg(src,callbackdata)
% ������� callback ��� ������ "���������� ���" 

% ����������� ����������������
% % ����� ����� ����� �������� ������
% % ������ ����� ��������� �������� ���:
% % [vec,ts] = in_data_stream.pull_sample();
% global in_data_stream;
% 
% % ����������� ������������ instrhwinfo('Bluetooth');
% % ��� ����������� ������������� ����� Bluetooth
% 
% % ���� ���������� ����� lsl �����
% % ����� ����� ���� �� ReceiveData
% lib = lsl_loadlib();
% 
% result = {};
% while isempty(result)
%     result = lsl_resolve_byprop(lib,'type','EEG'); 
% end
% 
% in_data_stream = lsl_inlet(result{1});

% �������� ������ ���� ����������
show_sw(src,callbackdata)


end

function cb_save_all(src,callbackdata)
% ������� callback ��� ������ "���������"
% ��������� ������������ CSP-������� � ����� ������
% ����� ��������, ����� ��� �� ��� ���������

global right_CSP_coef
global left_CSP_coef
global raw_data

% ���� ������������ CSP - ������� �������� �� ��������� ��
if ~isempty(right_CSP_coef) && ~isempty(left_CSP_coef)
    coef = [right_CSP_coef left_CSP_coef];
    save CSP_coeffs.mat coef
end

% ���� ������ �������� �� ��������� ��
if ~isempty(raw_data)
    data = raw_data;
    save recived_data.mat data
end

end

function cb_load_all(src,callbackdata)
% ������� callback ��� ������ "���������"
% ��������� ������������ CSP-�������
% ����� �������� ����� ��� �� ��� ���������

global right_CSP_coef
global left_CSP_coef

% ���� ������������ CSP - ������� �������� �� ��������� ��
if exist('CSP_coeffs.mat','file')
    load CSP_coeffs.mat 
    right_CSP_coef = coef(:,1); 
    left_CSP_coef = coef(:,2);
end

end

% ����� ������� ��� ������� ���� ����������
function show_sw(src,callbackdata)
% ������� ��� ��������� ������� ���� ����������
% ����� �������� ������� ������ �������������
% ����� ����� ������� ��������� ��������� ��������� ������ (��������)


%h_sw = findobj('Tag','t_isw');
h_fw = findobj('Tag','t_ifw');

%set(h_sw,'Visible','on');
set(h_fw,'Visible','off');

% �������� ������� ���� ���������� �����-�������� �����
% h_sw - handle_second_window
% t_isw - tad_interface_second_window
h_sw = figure('Name','Experiment','NumberTitle','off','Tag','t_isw','MenuBar','none','Visible','on');
%swsz - second_window_size
swsz = get(h_sw, 'Position');
% ������ ��������� � �������� ��� ����������� ����������� ��������� ��� ���������������
%sw_pos - second_window_positions
sw_pos = [swsz(3) swsz(4) swsz(3) swsz(4)];
set(h_sw,'SizeChangedFcn',@resize_sw,'CloseRequestFcn',@close_sw);

% ��������� "�������" ��� ������ ����� ������ � �������������, �� ������� ���������������
% h_rdp - handle_raw_data_plot 
% t_rdp - tag_raw_data_plot 
h_rdp =findobj('Tag','t_rdp');
if isempty(h_rdp)
    h_rdp = subplot('Position', [0.1 0.5 0.8 0.39],'Tag','t_rdp');
else
    subplot(h_rdp)
end
% ��������� "�������" ��� ������ ������������ ������, �� ������� ���������������
% h_ddp - handle_derived_data_plot
% t_ddp - tag_derived_data_plot
h_ddp =findobj('Tag','t_ddp');
if isempty(h_ddp)
    h_ddp = subplot('Position', [0.1 0.1 0.8 0.39],'Tag','t_ddp');
else
    subplot(h_ddp)
end
% ������ "��������� CSP ������" �������� ���� ��������� CSP �������
% t_b_tcsp - tag_button_tune_csp
uicontrol('Parent',h_sw,'Style','pushbutton',...
    'String','CSP filtering',...
    'Position', [0.1 0.01 0.2 0.08].*sw_pos,...
    'Callback', @cb_b_tuneCSP,'Tag','t_b_tcsp');

% ������ "��������� ���������" �������� ���� ������������ ������� �������� �����
% t_b_cb - tag_button_control_bar
uicontrol('Parent',h_sw,'Style','pushbutton',...
    'String', 'Raw control',...
    'Position', [0.4 0.01 0.2 0.08].*sw_pos,...
    'Callback', @cb_b_control_bars,'Tag','t_b_cb');

% ������ "��������� �������" �������� ���� ������������ ����������� ������
% t_b_cr - tag_button_control_robot
uicontrol('Parent',h_sw,'Style','pushbutton',...
    'String', 'Robot control',...
    'Position', [0.7 0.01 0.2 0.08].*sw_pos,...
    'Callback', @cb_b_control_robot,'Tag','t_b_cr');

% ������ "���������� �����������" ���������� �� ������ ���� ���������� 
% �����-�������� �����, ����������� ���������� ������ 
% t_b_cr - tag_button_control_robot
uicontrol('Parent',h_sw,'Style','pushbutton',...
    'String', 'Stop experiment',...
    'Position', [0.7 0.901 0.2 0.08].*sw_pos,...
    'Callback', @cb_stop_experiment,'Tag','t_b_stope');

% ������ "������ �����������" ��������� 
% ������ ���� ����������
% t_b_starte - tag_button_start_experiment
uicontrol('Parent',h_sw,'Style','pushbutton',...
    'String', 'Start experiment',...
    'Position', [0.1 0.901 0.2 0.08].*sw_pos,...
    'Callback',@cb_start_experiment,...
    'Tag','t_b_starte','Enable','on');

% �������� ��� ��������� �������� ������� ����� ������
uicontrol('Parent', h_sw, 'Style', 'slider',...
    'Value', 1, 'Position', [0.901 0.5 0.03 0.39].*sw_pos,...
    'Max', 1000, 'Min',0.0001,'SliderStep',[0.001 0.01],...
    'Tag','t_sl_rawdata');

end

function resize_sw(src,callbackdata)
h_sw = findobj(gcbo,'Tag','t_isw');
figsz = get(h_sw, 'Position');
pos_vect = [figsz(3) figsz(4) figsz(3) figsz(4)];

h_b_tcsp = findobj(gcbo,'Tag','t_b_tcsp');
h_b_cb = findobj(gcbo,'Tag','t_b_cb');
h_b_cr = findobj(gcbo,'Tag','t_b_cr');
h_b_stope = findobj(gcbo,'Tag','t_b_stope');
h_b_starte = findobj(gcbo,'Tag','t_b_starte');
h_sl_rawdata = findobj(gcbo,'Tag','t_sl_rawdata');


set(h_b_tcsp,'Position',[0.1 0.01 0.2 0.08].*pos_vect)
set(h_b_cb,'Position',[0.4 0.01 0.2 0.08].*pos_vect)
set(h_b_cr,'Position',[0.7 0.01 0.2 0.08].*pos_vect)
set(h_b_stope,'Position',[0.7 0.9 0.2 0.08].*pos_vect)
set(h_b_starte,'Position',[0.1 0.9 0.2 0.08].*pos_vect)
set(h_sl_rawdata,'Position',[0.901 0.5 0.01 0.39].*pos_vect)
end

function close_sw(src,callbackdata)
cb_stop_experiment(src,callbackdata);
h_sw = findobj(gcbo,'Tag','t_isw');

delete(h_sw)
end

function cb_stop_experiment(src,callbackdata)
% ������� ���������� ��� ������� ������ "���������� ����������"
h_sw = findobj('Tag','t_isw');
h_fw = findobj('Tag','t_ifw');

timer_pd = timerfind('Name','plot_data');
timer_rd = timerfind('Name','receive_data');
timer_fb = timerfind('Name','plot_feedback');
if strcmp(timer_pd.Running, 'on')
    stop(timer_pd)
end
if strcmp(timer_rd.Running, 'on')
    stop(timer_rd)
end
if strcmp(timer_fb.Running, 'on')
    stop(timer_fb)
end

set(h_sw,'Visible','off');
set(h_fw,'Visible','on');

end

function cb_start_experiment(src,callbackdata)
% ������� ���������� ��� ������� ������ "������ ����������"
% ��������� ��� ������� � ���� �� ������� ���������� 
% ������������� ���������� �������, � ������� ��� ������������ ���� �����
% ������������� �� ������ ���������� CSP-������� ��������� ��� ���� �������
% ��������� �������� 

% ����� �������� ������� �������������
h_e_rrd = findobj('Tag','t_e_rrd');

global bandpass_filt_coef

% ���� ����� ������� �������� ��������, ����� �������� 
% ��������� � ��������� ��� ������ � ����� �������
[~,A,B] = bandpass_filter( 0, 8, 12, str2double(h_e_rrd.String), 'cheb');

bandpass_filt_coef = [B;A];

% ��������� ������ ��� ��������� ����� ������ ���
% ������ ��� ������� ������� � ����
timer_rd = timerfind('Name','receive_data');
start(timer_rd);

% ��������� ������ ��� ���������� ������� ������ ���
%timer_pd = timerfind('Name','plot_data');
%start(timer_pd);

% ��������� ������ ��� ���������� ������� �������� �����
%timer_fb = timerfind('Name','plot_feedback');
%start(timer_fb);


end

function cb_b_tuneCSP(src,callbackdata)
% ������� callback ��� ������ "��������� CSP - ������"
% ������������ ���� ���������

% h_tCSPw - handle_tune_CSP_window
h_tCSPw = figure('Name','CSP filter','NumberTitle','off','Tag','t_itCSPw','MenuBar','none','Visible','on');

%tCSPwsz - tune_CSP_window_size
tCSPwsz = get(h_tCSPw, 'Position');
% ������ ��������� � �������� ��� ����������� ����������� ��������� ��� ���������������
%tCSPw_pos - tune_CSP_window_positions
tCSPw_pos = [tCSPwsz(3) tCSPwsz(4) tCSPwsz(3) tCSPwsz(4)];
set(h_tCSPw,'SizeChangedFcn',@resize_tCSPw,'CloseRequestFcn',@close_tCSPw);

% ������ ���������� ������ ��� ��� �������
% ������� ��� ������ ������ � ����������� ������ ����
% ������� ��� ������ ������ � ����������� ����� ����
% ������� ��� ������ ������ � ������������� ����������

% ������ ������ ������ ��� ��������� CSP �������
% t_b_drcsp - tag_button_data_record_csp
uicontrol('Parent',h_tCSPw,'Style','pushbutton','String', 'Data recording for resting state',...
    'Position', [0.1 0.01 0.8 0.08].*tCSPw_pos,'Callback', @cb_b_data_recordCSP,'Tag','t_b_drcsp','Enable','on');


% ������ "��������� CSP - ������ ��� ������ �������"
% t_b_trcsp - tag_button_tune_right_csp
uicontrol('Parent',h_tCSPw,'Style','pushbutton','String', 'Data recording for left hand movement',...
    'Position', [0.7 0.01 0.2 0.08].*tCSPw_pos,'Callback', @cb_b_tune_rCSP,'Tag','t_b_trcsp','Enable','off','Visible','off');


% ������ "��������� CSP - ������ ��� ����� �������"
% t_b_tlcsp - tag_button_tune_left_csp
uicontrol('Parent',h_tCSPw,'Style','pushbutton','String', 'Data recoridng for right hand movement',...
    'Position', [0.1 0.01 0.2 0.08].*tCSPw_pos,'Callback', @cb_b_tune_lCSP,'Tag','t_b_tlcsp','Enable','off','Visible','off');


% ��������� ������� ��� ��������� ����� ������ ���
timer_rd = timerfind('Name','receive_data');
stop(timer_rd);

% ��������� ������� ��� ���������� ������� ������ ���
timer_pd = timerfind('Name','plot_data');
stop(timer_pd);

end

function cb_b_control_bars(src,callbackdata)
% ������� callback ��� ������ "��������� ���������"
% ����� ������������ ���� ��� ����������� ���� �������� 

% t_bar_fig - tag_bars_figure
% h_fig - hangle_figure
h_fig = findobj('Tag','t_bar_fig');
% ���� ������ ���� ���, �� ���� ��� �������
if isempty(h_fig)
    h_fig = figure('Tag','t_bar_fig','NumberTitle',...
        'off','Name','Activity level');
    % h_l_bar - handle_left_bar
    h_l_bar = subplot('Position',[0.1 0.1 0.35 0.8],'Tag','t_bar_left','Parent',h_fig);
    % h_r_bar - handle_right_bar
    h_r_bar = subplot('Position',[0.55 0.1 0.35 0.8],'Tag','t_bar_right','Parent',h_fig);
    
    % ����������� ���� ��������
%     h_l_bar.YLim = [-3 3];
%     h_r_bar.YLim = [-3 3];
%     h_l_bar.YLimMode = 'manual';
%     h_r_bar.YLimMode = 'manual';    
end

end

function cb_b_control_robot(src,callbackdata)
% ������� callback ��� ������ "��������� �������"
% ������������� ���������� � ������� 

% ���� ����������� � ������� ������ ���� �� ���������� ������ �� ������
global is_robot_control
global bt_robot_cnn

bt_info = instrhwinfo('Bluetooth','Nerv');
if ~isempty(bt_info.RemoteName)
 bt_robot_cnn = Bluetooth('Nerv',1,'Tag','t_robot');
 
 fopen(bt_robot_cnn)
 
 is_robot_control = 1;
 
end
end

% ����� ������� ��� ��������� CSP �������
function resize_tCSPw(src, eventdata)

h_tCSPw = findobj(gcbo,'Tag','t_itCSPw');
figsz = get(h_tCSPw, 'Position');
pos_vect = [figsz(3) figsz(4) figsz(3) figsz(4)];


h_b_drcsp = findobj(gcbo,'Tag','t_b_drcsp');
h_b_trcsp = findobj(gcbo,'Tag','t_b_trcsp');
h_b_tlcsp = findobj(gcbo,'Tag','t_b_tlcsp');

set(h_b_drcsp,'Position',[0.1 0.01 0.8 0.08].*pos_vect)
set(h_b_trcsp,'Position',[0.7 0.01 0.2 0.08].*pos_vect)
set(h_b_tlcsp,'Position',[0.1 0.01 0.2 0.08].*pos_vect)


end

function close_tCSPw(src, eventdata)

h_tCSPw = findobj(gcbo,'Tag','t_itCSPw');

delete(h_tCSPw);

end

function cb_b_data_recordCSP(src,eventdata)
% ������� callback ��� ������ ������ ������,
% ����������� ��� ��������� CSP - �������

global data_relax
global data_right_movement
global data_left_movement
global start_time_data_record_CSP

global right_CSP_coef
global left_CSP_coef

timer_rd = timerfind('Name','receive_data');
% ���������� ������ � ����� �������:
% 1) ���������� ����������
% 2) ��������� ������ �����
% 3) ���������� ����� �����
% ���� ���-�� �� ��������, �� ���������� ������������


% ��������� ����� ������ ������ ��� ������ ����� 

if isempty(data_relax)
    start_time_data_record_CSP = get(timer_rd,'TasksExecuted')+1;% "+1" ������ ��� �� 0
    set(src, 'String', 'Recording','Enable','off');
    start(timer_rd)
else 
    if isempty(data_right_movement)
        start_time_data_record_CSP = get(timer_rd,'TasksExecuted')+1;
        set(src, 'String', 'Recording','Enable','off');
        start(timer_rd)
    else
        if isempty(data_left_movement)
            start_time_data_record_CSP = get(timer_rd,'TasksExecuted')+1;
            set(src, 'String', 'Recording','Enable','off');            
            start(timer_rd)
        end
    end
end

% ���� ��� ���������, �� ��������� ���� � ��������� 
% ������ ��� ���������� �������� �����
if ~isempty(right_CSP_coef) && ~isempty(left_CSP_coef)
    close_tCSPw();
    timer_fb = timerfind('Name','plot_feedback');
    start(timer_fb);
end

end

function cb_b_tune_rCSP(src, eventdata)
% ������� callback ��� ������ "��������� CSP - ������ ��� ������ �������"
% ����������� CSP - ������. 
% ��� ��������� ����������� ������ 
% ���������� ��� ������������� ��������� �����������
% � ��� �������� ������ �����

global data_relax
global data_right_movement

% handle_edit_ratio_recive_data
h_e_rrd = findobj('Tag','t_e_rrd');

% ������ ��� ��������
% ����� ��������� ��������� ��������� 

start_tune_CSP(data_relax, data_right_movement, str2double(h_e_rrd.String), 1);

% �������� ������� ���������� �������� �� ������ ������
accept_CSP()

end

function cb_b_tune_lCSP(src, eventdata)
% ������� callback ��� ������ "��������� CSP - ������ ��� ����� �������"
% ����������� CSP - ������. 
% ��� ��������� ����������� ������ 
% ���������� ��� ������������� ��������� �����������
% � ��� �������� ����� �����

global data_relax
global data_left_movement


% handle_edit_ratio_recive_data
h_e_rrd = findobj('Tag','t_e_rrd');

% ������ ��� ��������
% ����� ��������� ��������� ��������� 

start_tune_CSP(data_relax, data_left_movement, str2double(h_e_rrd.String), 2);

% �������� ������� ���������� �������� �� ������ ������
accept_CSP()

end

function control_tune_CSP(current_step)
% ������� ���������� � ������� ���������� ������ �� ���
% �� ���������� ��������� ���������� CSP �������
%
% ��������� :
% current_step -  ������� �������� �������

global raw_data
global data_relax
global data_right_movement
global data_left_movement
global start_time_data_record_CSP

timer_rd = timerfind('Name','receive_data');

% t_b_trcsp - tag_button_data_record_csp
h_b_drcsp = findobj('Tag','t_b_drcsp');

% t_b_trcsp - tag_button_tune_right_csp
h_b_trcsp = findobj('Tag','t_b_trcsp');

% t_b_tlcsp - tag_button_tune_left_csp
h_b_tlcsp = findobj('Tag','t_b_tlcsp');

% ���� ����� �������� ����������� ��������� ���� 
% �������� ����� 3 "�����" �� ���� ��������� CSP - �������
% ����� ���� ��� ���������
period_relax = 100;
period_right_movement = 100;
period_left_movement = 100;

% ���� ������ ��� ������������� ��������� ���, �� �������� ��
if isempty(data_relax)
    if start_time_data_record_CSP+period_relax <= current_step;
        data_relax = raw_data(:,start_time_data_record_CSP : current_step);
        set(h_b_drcsp, 'String', '�������� ������ ��� �������� ������ ����','Enable','on');
        stop(timer_rd)
    end
else 
    % ���� ������ ��� �������� ������ ����� ���, �� �������� ��
    if isempty(data_right_movement)
        if start_time_data_record_CSP+period_right_movement <= current_step;
            data_right_movement = raw_data(:,start_time_data_record_CSP : current_step);
            set(h_b_drcsp, 'String', '�������� ������ ��� �������� ����� ����','Enable','on');
            stop(timer_rd)
        end
    else
        % ���� ������ ��� �������� ����� ����� ���, �� �������� ��
        if isempty(data_left_movement)
             if start_time_data_record_CSP+period_left_movement <= current_step;
                data_left_movement = raw_data(:,start_time_data_record_CSP : current_step);
                set(h_b_drcsp, 'String', '������ ��������','Enable','off','Visible','off');
                set(h_b_trcsp,'Enable','on','Visible','on');
                set(h_b_tlcsp,'Enable','on','Visible','on');
                stop(timer_rd)
            end
        end
    end
end


end

function accept_CSP()
% ������� ��������� ������ ��� ���������� ��������� 
% CSP - ��������

global right_CSP_coef
global left_CSP_coef

if ~isempty(right_CSP_coef) && ~isempty(left_CSP_coef)
    h_b_drcsp = findobj('Tag','t_b_drcsp');
    set(h_b_drcsp,'String','��������� ���������','Enable','on')
end


end

% ����� ������� ��� ���������� ������ ������������� CSP - �������
function start_tune_CSP(data1, data2, Fs, side)
% ������� ����������� ��������� ������ ������������� CSP - �������

% ���������� ��� ������ ���������� �������
global num_CSP_coef
num_CSP_coef = 0;

% ������ � ������� �������� ��� ������������ ������ �������������
% CSP-������� ��� ���������� lambda
% ����� 32 ������� ���� ����� ��������� �������
global all_coef
all_coef = zeros(24,16);

% �������� ���� ���������� ��� ��� ������ ������������� CSP - �������
% h_tCSPsw - handle_tune_CSP_second_window
% t_itCSPsw - tag_interface_tune_CSP_second_window
h_tCSPsw = figure('Name','CSP filter','NumberTitle','off','Tag','t_itCSPsw','MenuBar','none','Visible','on');
%tCSPswsz - tune_CSP_second_window_size
tCSPswsz = get(h_tCSPsw, 'Position');
% ������ ��������� � �������� ��� ����������� ����������� ��������� ��� ���������������
%tCSPsw_pos - tune_CSP_second_window_positions
tCSPsw_pos = [tCSPswsz(3) tCSPswsz(4) tCSPswsz(3) tCSPswsz(4)];
% ������� ��� ��������� ������� � �������� ����
set(h_tCSPsw,'SizeChangedFcn',@resize_tCSPsw,'CloseRequestFcn',@close_tCSPsw);

% ������� ��� ����������� 16 ���� ���������� ������
heads_plot(data1, data2, 1, Fs);
% ������ ������������� ������
uicontrol('Parent',h_tCSPsw,'Style','pushbutton','String', 'Accept',...
    'Position', [0.7 0.01 0.2 0.08].*tCSPsw_pos,'Callback', {@cb_b_doneCSP, side},'Tag','t_b_doneCSP');
% ���� ��� ����� ������
uicontrol('Parent',h_tCSPsw,'Style','edit','String', '1','Position', [0.1 0.01 0.09 0.08].*tCSPsw_pos,'Tag','t_e_lambdaCSP');
% ������ "����������� �����������"
uicontrol('Parent',h_tCSPsw,'Style','pushbutton','String', 'Recalculate coefficients',...
    'Position', [0.2 0.01 0.3 0.08].*tCSPsw_pos,'Callback', {@cb_b_recalcCSP,data1,data2,Fs},'Tag','t_b_recalcCSP');

end

function resize_tCSPsw(src, callbackdata)
% ������� ��� ��������� ������� ���� ��������� CSP �������
tCSPsw_pos = get(src,'Position');

h_b_doneCSP = findobj('Tag','t_b_doneCSP');
h_e_lambdaCSP = findobj('Tag','t_e_lambdaCSP');
h_b_recalcCSP = findobj('Tag','t_b_recalcCSP');

set(h_b_doneCSP,'Position', [0.7 0.01 0.2 0.08].*tCSPsw_pos);
set(h_e_lambdaCSP,'Position', [0.1 0.01 0.09 0.08].*tCSPsw_pos);
set(h_b_recalcCSP,'Position', [0.2 0.01 0.3 0.08].*tCSPsw_pos);
end

function close_tCSPsw(src, callbackdata)
% ������� ��� �������� ���� ��������� CSP �������
%h_tCSPsw = findobj(gcbo,'Tag','t_itCSPsw');
%delete(h_tCSPsw);
delete(src)
end

function cb_b_doneCSP(src, callbackdata, side)
% ������� callback ��� ������ "�����������"
% ������������ ����� ������������� CSP - �������
%
% ��������� :
% side - ���������� ��� ������ ������� ������ (������ ��� �����)
%

global num_CSP_coef
global right_CSP_coef
global left_CSP_coef
global all_coef

if ~isempty(num_CSP_coef) && num_CSP_coef~=0

    if side == 1
        right_CSP_coef = all_coef(:,num_CSP_coef);
    end
    
    if side == 2
        left_CSP_coef = all_coef(:,num_CSP_coef);
    end
    % ���� ��������� ������ �������������
    % ���� ������� ����
    close_tCSPsw(src.Parent);

end

end

function heads_plot(data1, data2, lambda, Fs)
% ������� ��������� ���� ���������� ������
%
% ��������� :
% data1, data2 - ����������� �������, � ������� ������ ���������� ������� �
% ���������
% lambda - ����������� ��� ��������� CSP-�������
% Fs - ������� �������������
% 


global all_coef

load ChannelsNames1.mat
load StandardEEGChannelLocations.mat
% ��������� ������ ���������� ��� ����� ������ ��������� ��� ���������� 4
% ���� �� 1 Hz � ������� �� ������ 4 ������
init_band = [8 12];
% ������ � ���������� ������� ���
chan_labels = mat2cell(array_names,[ones(1,length(array_names))],3);
% �������� ������� �������� ������� ����������� � ����� ��� ������������
for k = 1 : length(chan_labels)
    if chan_labels{k}(3) == ' '
        chan_labels{k} = chan_labels{k}(1:2);
    end
end

% pli - plot_index
    pli = 1;
% � ���� ����� ����� ���� 16 ���� ����������
% ib - index_band
for ib = 1 : 4
    % ������������� ������ ��������� ������
    band = init_band + ib - 1;
    % ��������� ��� ����� ���� ������ ������ �� ���� �������
    data1_f = zeros(size(data1,1),size(data1,2));
    for k = 1:size(data1,1)
        data1_f(k,:) = bandpass_fft_filter(data1(k,:),band,Fs);
     end
    
    data2_f = zeros(size(data2,1),size(data2,2));
    for k = 1:size(data2,1)
        data2_f(k,:) = bandpass_fft_filter(data2(k,:),band,Fs);
    end
    
    % ������ ������� csp-�������
    V  = calculate_coeff_csp_filter(data1_f, data2_f, lambda);
    % �� ���������� ������� ������ ����������� ���������� 
    % ������ �����������
    
    % ������� ������, ������, ������������� � ��������� ������� �������
    % ������ ��-�� ����� �� ������ 4 �������
    V_cut = V(:,[ 1 2 end-1 end ]);
    
    % ��������� ������ �������, ��� ����� ������� ������� � ��� 
    % �������������� ��������� (��� ���������� ���� ����������)
    rV = rearrange_channels(V_cut,chan_labels,channels);
   
    
    % im - index_map
    for im = 1 : 4
        subplot(4,4,pli);
        plot(0)
        % ��������� ������� ������ ���������� ������ �� ������
        % �������������
        topoplot(rV(:,im), channels,  'chaninfo', chaninfo);
        % �������� ����� �������������
        % ����� �� ���� ����� "����������������"
        % �.�. ������ ���� ���������������
        all_coef(:,pli) = V_cut(:,im);
        pli = pli + 1;
    end
end

h_tCSPsw = findobj('Tag','t_itCSPsw');
h_children_axes = findobj(h_tCSPsw,'Type','line');
% ��� ������� ������� ��������������� ������� �������� �����
% � ������ �� ��� () �� ������� ������ �� �������� (���� ���� �������� �� ��� �����)
for k = 1 : length(h_children_axes)
    set(h_children_axes(k),'ButtonDownFcn',@(src,event)cb_select_CSP_coef(src,event),'Visible','on');
end
end

function cb_b_recalcCSP(src, callbackdata, data1,data2,Fs)
% ������� ��� ��������� ������������� CSP - ������� 
% ����� ��������� ������
% ��������� :
% data1, data2 - ����������� �������, � ������� ������ ���������� ������� �
% ���������
% Fs - ������� �������������
% 



h_e_lambdaCSP = findobj('Tag','t_e_lambdaCSP');
lambda = str2double(h_e_lambdaCSP.String);

heads_plot(data1,data2,lambda,Fs);

end

function cb_select_CSP_coef(src, callbackdata)
% ������� callback ��� ������ �������
% ������ ���� �� ��������� �������
% ���� �������� ������ ���� ������ ��� ������
% ���� ���� ������� ������ ������ ����� ����������� ������
%
% ����� ����������: ���� ���������� ������ ��� ��������� �� ������ ������
% ��������

% ���������� ��� ������ ���������� �������
global num_CSP_coef

if num_CSP_coef == 0
h_fig = src.Parent;
h_children_axes = findobj(h_fig.Parent,'Type','axes');

% ���������� ���������� �������
for k = 1 : length(h_children_axes)
    if h_fig.Position == h_children_axes(k).Position
        num_CSP_coef = 16-k+1;% ��� ������ k
    end
end

% ����� �������� ����
clear i
hold on
plot(0.55*exp(i*[0:0.1:2*pi]),'r','linewidth',2)
%plot([-0.5 -0.5 0.5 0.5 -0.5],[-0.5 0.5 0.5 -0.5 -0.5],'r','linewidth',2)
hold off
end

end

% ����� ����������� ��������� ������� 
function timer_receive_data(obj, event)
% ������� ������� ��� ��������� ������
% �� �������������. ������ ����������� 
% ����� ������� ������ "������ �����������"

global raw_data
global in_data_stream


% ����� new_data �������� �� �������
% [new_data,~] = in_data_stream.pull_sample();

 %%% ����� ����� ����� ������ 
 %���� ��� ������ ����� ������� ���
 new_data = rand(1,24);
 
% ���������� ������ ���������� � ����� �������
raw_data = [raw_data new_data'];

% ���������� ���������� CSP - �������
h_tCSPw = findobj('Tag','t_itCSPw');
if ishandle(h_tCSPw)
    control_tune_CSP(obj.TasksExecuted)
end

% ��������� ������� ��������� �������
% ������ ���� �������� ���� � ������� ��������
% ������� ��������� ��������
global right_CSP_coef
global left_CSP_coef

if ~isempty(right_CSP_coef) && ~isempty(left_CSP_coef)
    timer_plot_data(obj, event)

    timer_feedback(obj, event)
end

end

function timer_plot_data(obj, event)
% ������� ������� ��� ��������� ������� 
% ����� ������. ������ ����������� 
% ����� ������� ������ "������ �����������"

global raw_data

% ������������ �� ������ ���� ����������
% ���������� ������
plot_raw_data(raw_data)

end

function timer_feedback(obj, event)
% ������� ������� ��� ��������� �������
% �������� �����. ������ �����������
% ����� ���� ��� ������� ��������� ���������

global right_CSP_coef
global left_CSP_coef
global raw_data
global bandpass_filt_coef

buff_len = 1000;

% ����� ��������� buff_len �������� �������
st_ind = length(raw_data) - buff_len;
if st_ind < 1 
    st_ind = 1;
end
derived_data1 = raw_data(:,st_ind:end);

derived_data2 = zeros(size(derived_data1,1),size(derived_data1,2));
% ��������� ����������
for k = 1 : size(raw_data,1) 
    derived_data2(k,:) = filter(bandpass_filt_coef(1,:),bandpass_filt_coef(2,:),derived_data1(k,:));
end

% ���������������� ����������
derived_data3_r = right_CSP_coef' * derived_data2;
derived_data3_l = left_CSP_coef' * derived_data2;

% ���������� ���������
derived_data4_r = envelopes(derived_data3_r ,'hilbert');
derived_data4_l = envelopes(derived_data3_l ,'hilbert');



left = mean(derived_data4_l);
right = mean(derived_data4_r);

% ���������� �������
global is_robot_control
if is_robot_control == 1
    l_const = 0.7;
    r_const = 0.7;
    transmit_robot_bluetooth(left,right,l_const,r_const);
end

% ���������� ���������
h_bar_fig = findobj('Tag','t_bar_fig');
if ~isempty(h_bar_fig)
    two_bars_plot( left, right );
end

% ����� ��������� �� �����
plot_derived_data([derived_data4_r;derived_data4_l]);

end

% ����� ��������������� �������
function plot_raw_data(data)
% ������� ��� ��������� ����� ������
% � �������������
 
% h_rdp - handle_raw_data_plot
h_rdp = findobj('Tag','t_rdp');

h_sw = findobj('Tag','t_isw');
figure(h_sw)

if ~isempty(h_rdp)
    subplot(h_rdp)
    % �������� ����� ��� ���������� �� �������
    h_rdp_children=get(h_rdp,'children');
    delete(h_rdp_children);
    
    % ������� �������� ���� ���������,
    % ����� ��������� ����������� ���������
    % ���� ���������
    scale_x = 1000;
    h_sl_rawdata = findobj('Tag','t_sl_rawdata');
    scale_y = get(h_sl_rawdata,'Value');

    [x,data1] = prepare_data_plot(data,scale_x,scale_y);
    
    for k = 1 : size(data,1) 
        data1(k,:) = bandpass_filter(data1(k,:),1,40,250,'fft');
    end

    % ��������� ����� ������
    plot_data(x,data1)
end
end

function plot_derived_data(data)
% ������� ��� ��������� ������������ ������
% � �������������
 
% h_ddp - handle_derived_data_plot
h_ddp = findobj('Tag','t_ddp');

h_sw = findobj('Tag','t_isw');
figure(h_sw)

if ~isempty(h_ddp)
    subplot(h_ddp)
    % �������� ����� ��� ���������� �� �������
    h_ddp_children=get(h_ddp,'children');
    delete(h_ddp_children);
    
    
    % ������� �������� ���� ���������,
    % ����� ��������� ����������� ���������
    % ���� ���������
    scale_x = 1000;
    scale_y = 1;
    
    [x,data] = prepare_data_plot(data, scale_x, scale_y);
    
    % ��������� ����� ������
    plot_data(x,data);
end
end

function [x,data] = prepare_data_plot(data,scale_x,scale_y)

% ���������� ��� x 
st_x = size(data,2)-scale_x;
x = [st_x : size(data,2)];
% ���� ������� ������� �������, �� �������
% ���� �������� ����
if st_x < 1
    data = [zeros(size(data,1),-st_x+1) data];
end

data = data(:,end-size(x,2)+1:end).*scale_y;

end

function plot_data(x, data)
% ������� ��� ��������� ����������� ������ 
%
% ��������� :
% data - ������
% scale_x, scale_y - ���������� ������������
%       �� ��������������� ����

hold on
for k = 1 : size(data,1)
    plot(x,data(k,:)+k)
end
hold off
drawnow
end

function [ ] = two_bars_plot( left, right )
% ������� ��� ������ ����������� ����
% ��������.
%
% ��������� :
% left, right - ������� �������� ����� � �������
%       ������� ����������� ������ ��������.
%

% t_bar_fig - tag_bars_figure
% h_fig - hangle_figure
h_fig = findobj('Tag','t_bar_fig');
figure(h_fig)
h_l_bar = findobj('Tag','t_bar_left');
h_r_bar = findobj('Tag','t_bar_right');

h_children=get(h_l_bar,'children');
delete(h_children)

h_children=get(h_r_bar,'children');
delete(h_children)

% ��������� ���� �������� ������� 0
subplot(h_l_bar)
hold on
plot([0 1 1 0 0],[0 0 1 1 0].*left)
hold off

subplot(h_r_bar)
hold on
plot([0 1 1 0 0],[0 0 1 1 0].*right)
hold off
drawnow


% ���������� �������� ������������ 
% �������� � ��������������� ��������
text('Parent',h_l_bar,'String',num2str(left),...
    'Tag','t_bar_l_text','Position', [ 1 -2]);
text('Parent',h_r_bar,'String',num2str(right),...
    'Tag','t_bar_r_text','Position', [ 1 -2]);
end

