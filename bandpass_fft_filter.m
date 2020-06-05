function [ out_data ] = bandpass_fft_filter( in_data, band, sr )
% Полосовой фильтр реализованный через fft
%
% Аргументы :
% in_data - данные которые надо отфильтровать 
% band - полоса выделения частот в Hz
% sr - частота дискретизации
%
% Возвращаемые значения
% out_data - данные после фильтрации
%


f = fft(in_data);
f(1:round(length(f) * band(1) / sr)) = 0; 
% поскольку сигнал был вещественен, то его спектр симетричен
% надо сохранить это свойство, чтобы востановленный сигнал
% был вещественен. Поэтому в следующей строке есть добавка "+2"
f(round(length(f) * band(2) / sr) : end - round(length(f) * band(2) / sr) + 2) = 0;
f(end - round(length(f) * band(1) / sr) + 2 : end) = 0;
out_data = ifft(f);

end


