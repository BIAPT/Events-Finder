function [width] = find_width(diff,zero_cross_pts)
%FIND_WIDTH % Find the width of a zero crossing point
% Input
% diff: array of first derivatives
% zero_cross_pts: index of the zero_crossing point
% 
% Output
% width: the width of this peak or through
%% Variables
left_border = zero_cross_pts - 1;
right_border = zero_cross_pts + 1;
width = 1; % default value

left_sign = sign(diff(left_border));
right_sign = sign(diff(right_border));

%% Algorithm

while(left_border > 0 && right_border < size(diff,1) ...
        && left_sign == sign(diff(left_border)) && right_sign == sign(diff(right_border)))
    
    width = width + 1;
    left_border = left_border - 1;
    right_border = right_border + 1;
end
