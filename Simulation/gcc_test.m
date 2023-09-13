% Mic positions
mic1 = [0,0];
mic2 = [80,0];
mic3 = [0,30];
mic4 = [80,30];

% Source position
sp = [50,50];

% Signal definitions
ts = 0.0001;
t = 0:ts:1;
ref = sin(2*pi*t);

d1 = sqrt((sp(1)-mic1(1))^2+(sp(2)-mic1(2))^2);
d2 = sqrt((sp(1)-mic2(1))^2+(sp(2)-mic2(2))^2);
d3 = sqrt((sp(1)-mic3(1))^2+(sp(2)-mic3(2))^2);
d4 = sqrt((sp(1)-mic4(1))^2+(sp(2)-mic4(2))^2);

t1 = d1/343;
t2 = d2/343;
t3 = d3/343;
t4 = d4/343;

sig1 = sin(2*pi*(t-t1));
sig2 = sin(2*pi*(t-t2));
sig3 = sin(2*pi*(t-t3));
sig4 = sin(2*pi*(t-t4));

hold on
plot(t,ref)
plot(t,sig1)
plot(t,sig2)
plot(t,sig3)
plot(t,sig4)

% Time delay calculations
td12 = gcc(sig1,sig2)*ts;
td13 = gcc(sig1,sig3)*ts;
td14 = gcc(sig1,sig4)*ts;
td23 = gcc(sig2,sig3)*ts;
td24 = gcc(sig2,sig4)*ts;
td34 = gcc(sig3,sig4)*ts;



% Given sensor positions (xi, yi)
xi = [0, 80, 0, 80];
yi = [0, 0, 30, 30];

% Given TDOA measurements (TDOAij_observed)
TDOAij_observed = [td12, td13, td14, td23, td24, td34];

% Initial estimate for source coordinates (x, y)
x_initial = 20;
y_initial = 20;

% Optimization function
fun = @(params) tdoa_objective(params, xi, yi, TDOAij_observed);

% Perform optimization
options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt');
params_initial = [x_initial, y_initial];
params_estimated = lsqnonlin(fun, params_initial, [], [], options);

% Extract estimated source coordinates
x_estimated = params_estimated(1);
y_estimated = params_estimated(2);

disp(['Estimated source coordinates: (x, y) = (', num2str(x_estimated), ', ', num2str(y_estimated), ')']);

% Objective function for optimization
function residuals = tdoa_objective(params, xi, yi, TDOAij_observed)
    x = params(1);
    y = params(2);
    s = 343; % Speed of sound
    
    residuals = [];
    for i = 1:length(xi)
        for j = i+1:length(xi)
            TDOAij_calculated = sqrt((x - xi(i))^2 + (y - yi(i))^2) / s - sqrt((x - xi(j))^2 + (y - yi(j))^2) / s;
            residuals = [residuals; TDOAij_observed(find_pair_index(i, j, length(xi))) - TDOAij_calculated];
        end
    end
end

% Helper function to find pair index
function index = find_pair_index(i, j, n)
    index = n * (i - 1) + j - i * (i + 1) / 2;
end


function time_delay = gcc(ref,sig1)
cross_corr = xcorr(ref, sig1);
normalized_cross_corr = abs(cross_corr) / max(abs(cross_corr));

[max_corr_value, max_corr_index] = max(normalized_cross_corr);

time_delay = (max_corr_index - 1) - (numel(ref) - 1);

%plot(normalized_cross_corr);
end


