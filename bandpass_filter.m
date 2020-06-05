function [ out_data, coef_a, coef_b ] = bandpass_filter( in_data, f1, f2, sr, type )
%Частотный полосовой фильтр 
%
% Аргументы :
% in_data - данные которые надо отфильтровать 
% f1 - частота начала полосы выделения в Hz
% f2 - частота окончания полосы выделения в Hz
% sr - частота дискретизации
%
% Возвращаемые значения
% out_data - данные после фильтрации
% coef_a, coef_b - коэффициенты фильтра
%  

switch type
    case 'fft'
        % Реализовация через
        % быстрое переобразование Фурье.
        
        % считаем преобразование Фурье
        f = fft(in_data);
        len = length(f);
        % зануляем часть спектра лежащую вне полосы
        f(1:round(len * f1 / sr)) = 0;
        % поскольку сигнал был вещественен, 
        % то его спектр симетричен надо сохранить 
        % это свойство, чтобы востановленный
        % сигнал был вещественен. Поэтому в 
        % следующей строке есть добавка "+2"
        f(round(len*f2/sr):end-round(len*f2/sr)+2)=0;
        f(end - round(len * f1 / sr) + 2 : end) = 0;
        % обратное преобразование Фурье
        % возвращает отфильтрованные данные
        out_data = ifft(f);
    case 'cheb'
        % реализация через фильтр 
        % Чебышева первого рода
        des_filt = designfilt('bandpassiir',...
            'FilterOrder',6, ...
            'PassbandFrequency1',f1,...
            'PassbandFrequency2',f2, ...
            'PassbandRipple',4,...
            'SampleRate',sr);
         
         % Коэффициенты фильтра
         [coef_b, coef_a] = tf(des_filt);  
         
         % Отфильтрованный данные
         out_data = filter(des_filt, in_data);
end

end


