function [ ] = transmit_robot_bluetooth( left, right, l_const,r_const )
% ‘ункци€ дл€ передачи сигналов на робота
% с использованием bluetooth, до ее исполнени€
% должна быть вызвана функци€ подключени€ 
% к роботу.
%
% јргументы :
% left, right - сигналы обратной св€зи с помощью
%       которых вычисл€ютс€ управл€ющие 
%       сигналы дл€ левого и правого колес
%       робота соответственно.
% l_const, r_const - ограничени€ на уровень 
%       сигналов left и right соответственно.
%       Ёти константы лучше всего вычилс€ть 
%       во врем€ обучени€ csp-фильтра. 
%

% bt_o - bluetooth_robot_connect
global bt_robot_cnn

% проверка на подключение
if ~strcmp(bt_robot_cnn.Status,'closed');

    % если величина обратной св€зи в диапазоне,
    % то управл€ющий сигнал дл€ левого колеса ch1=0.4
    if left > 0 && left < l_const
        ch1 = 0.4;
    else
        ch1 = 0;
    end
    % дл€ правого аналогично
    if right > 0 && right < r_const
        ch2 = 0.4;
    else
        ch2 = 0;
    end
    
    % преобразование данных в формат 
    % подход€щий дл€ робота nxt
    out1 = uint8((ch1+4)*32);
    out2 = uint8((ch2+4)*32);
    bytes = uint8([6 0 128 9 0 2 out1 out2]);
    
    % отправка данных по блютусу
    fwrite(bt_robot_cnn,bytes);
end

end

