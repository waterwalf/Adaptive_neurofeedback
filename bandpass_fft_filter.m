function [ out_data ] = bandpass_fft_filter( in_data, band, sr )
% ��������� ������ ������������� ����� fft
%
% ��������� :
% in_data - ������ ������� ���� ������������� 
% band - ������ ��������� ������ � Hz
% sr - ������� �������������
%
% ������������ ��������
% out_data - ������ ����� ����������
%


f = fft(in_data);
f(1:round(length(f) * band(1) / sr)) = 0; 
% ��������� ������ ��� �����������, �� ��� ������ ����������
% ���� ��������� ��� ��������, ����� �������������� ������
% ��� �����������. ������� � ��������� ������ ���� ������� "+2"
f(round(length(f) * band(2) / sr) : end - round(length(f) * band(2) / sr) + 2) = 0;
f(end - round(length(f) * band(1) / sr) + 2 : end) = 0;
out_data = ifft(f);

end


