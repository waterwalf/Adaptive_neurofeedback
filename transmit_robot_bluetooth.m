function [ ] = transmit_robot_bluetooth( left, right, l_const,r_const )
% ������� ��� �������� �������� �� ������
% � �������������� bluetooth, �� �� ����������
% ������ ���� ������� ������� ����������� 
% � ������.
%
% ��������� :
% left, right - ������� �������� ����� � �������
%       ������� ����������� ����������� 
%       ������� ��� ������ � ������� �����
%       ������ ��������������.
% l_const, r_const - ����������� �� ������� 
%       �������� left � right ��������������.
%       ��� ��������� ����� ����� ��������� 
%       �� ����� �������� csp-�������. 
%

% bt_o - bluetooth_robot_connect
global bt_robot_cnn

% �������� �� �����������
if ~strcmp(bt_robot_cnn.Status,'closed');

    % ���� �������� �������� ����� � ���������,
    % �� ����������� ������ ��� ������ ������ ch1=0.4
    if left > 0 && left < l_const
        ch1 = 0.4;
    else
        ch1 = 0;
    end
    % ��� ������� ����������
    if right > 0 && right < r_const
        ch2 = 0.4;
    else
        ch2 = 0;
    end
    
    % �������������� ������ � ������ 
    % ���������� ��� ������ nxt
    out1 = uint8((ch1+4)*32);
    out2 = uint8((ch2+4)*32);
    bytes = uint8([6 0 128 9 0 2 out1 out2]);
    
    % �������� ������ �� �������
    fwrite(bt_robot_cnn,bytes);
end

end

