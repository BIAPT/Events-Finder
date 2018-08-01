%% Input (Example of inputs)
diff = 1:1000;
zero_cross_pts = 45;

%% Output (This is the output)
width = 0;

%% Variables
left_border = zero_cross_pts - 1;
right_border = zero_cross_pts + 1;

left_sign = sign(diff(left_border));
right_sign = sign(diff(right_border));

%% Algorithm

while(left_border > 0 && right_border < size(diff,1) ...
        && left_sign == sign(diff(left_border)) && right_sign == sign(diff(right_border)))
    
    width = width + 1;
    left_border = left_border - 1;
    right_border = right_border + 1;
end

disp(['Width of this zero crossing pts is of size : ', num2str(width)]);
