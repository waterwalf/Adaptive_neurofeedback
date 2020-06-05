function [ ] = two_bars_plot( left, right )
% ‘ункци€ дл€ показа испытуемому двух
% столбцов.
%
% јргументы :
% left, right - сигналы обратной св€зи с помощью
%       которых вычисл€ютс€ высоты столбцов.
%

% t_bar_fig - tag_bars_figure
% h_fig - hangle_figure
h_fig = findobj('Tag','t_bar_fig');

% делаем фигуру текущей 
h_l_bar = findobj('Tag','t_bar_left');
h_r_bar = findobj('Tag','t_bar_right');

% отрисовка двух столбцов высотой 0
bar1 = bar(h_l_bar,0);
bar2 = bar(h_r_bar,0);

% изменение высот стобцов
bar1.YData = left;
bar2.YData = right;
% добавление надписей показывающих 
% значение в соответствующих столбцах
text('Parent',bar1,'String',num2str(left),...
    'Tag','t_bar_l_text','Position', [ 1 -2]);
text('Parent',bar2,'String',num2str(right),...
    'Tag','t_bar_r_text','Position', [ 1 -2]);
end

