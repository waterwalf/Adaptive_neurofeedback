function [ out_data, coef_a, coef_b ] = bandpass_filter( in_data, f1, f2, sr, type )
%��������� ��������� ������ 
%
% ��������� :
% in_data - ������ ������� ���� ������������� 
% f1 - ������� ������ ������ ��������� � Hz
% f2 - ������� ��������� ������ ��������� � Hz
% sr - ������� �������������
%
% ������������ ��������
% out_data - ������ ����� ����������
% coef_a, coef_b - ������������ �������
%  

switch type
    case 'fft'
        % ������������ �����
        % ������� ��������������� �����.
        
        % ������� �������������� �����
        f = fft(in_data);
        len = length(f);
        % �������� ����� ������� ������� ��� ������
        f(1:round(len * f1 / sr)) = 0;
        % ��������� ������ ��� �����������, 
        % �� ��� ������ ���������� ���� ��������� 
        % ��� ��������, ����� ��������������
        % ������ ��� �����������. ������� � 
        % ��������� ������ ���� ������� "+2"
        f(round(len*f2/sr):end-round(len*f2/sr)+2)=0;
        f(end - round(len * f1 / sr) + 2 : end) = 0;
        % �������� �������������� �����
        % ���������� ��������������� ������
        out_data = ifft(f);
    case 'cheb'
        % ���������� ����� ������ 
        % �������� ������� ����
        des_filt = designfilt('bandpassiir',...
            'FilterOrder',6, ...
            'PassbandFrequency1',f1,...
            'PassbandFrequency2',f2, ...
            'PassbandRipple',4,...
            'SampleRate',sr);
         
         % ������������ �������
         [coef_b, coef_a] = tf(des_filt);  
         
         % ��������������� ������
         out_data = filter(des_filt, in_data);
end

end


