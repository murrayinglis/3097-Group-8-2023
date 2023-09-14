% Mic positions
mic1 = [0, 0];
mic2 = [80, 0];
mic3 = [0, 30];
mic4 = [80, 30];

% Source position
sp = [20, 40];

% Signal definitions
ts = 0.0001;
t = 0:ts:1;
ref = sin(2000 * pi * t);

d1 = sqrt((sp(1) - mic1(1))^2 + (sp(2) - mic1(2))^2);
d2 = sqrt((sp(1) - mic2(1))^2 + (sp(2) - mic2(2))^2);
d3 = sqrt((sp(1) - mic3(1))^2 + (sp(2) - mic3(2))^2);
d4 = sqrt((sp(1) - mic4(1))^2 + (sp(2) - mic4(2))^2);

t1 = d1 / 343;
t2 = d2 / 343;
t3 = d3 / 343;
t4 = d4 / 343;

sig1 = sin(2000 * pi * (t - t1));
sig2 = sin(2000 * pi * (t - t2));
sig3 = sin(2000 * pi * (t - t3));
sig4 = sin(2000 * pi * (t - t4));

% Time delay calculations
td12 = gcc(sig1, sig2)*ts;
td13 = gcc(sig1, sig3)*ts;
td14 = gcc(sig1, sig4)*ts;
td23 = gcc(sig2, sig3)*ts;
td24 = gcc(sig2, sig4)*ts;
td34 = gcc(sig3, sig4)*ts;

% Define the cost function
cost_function = @(xy) [
    (1 / 343) * (sqrt((xy(1) - mic1(1))^2 + (xy(2) - mic1(2))^2) - sqrt((xy(1) - mic2(1))^2 + (xy(2) - mic2(2))^2)) - td12;
    (1 / 343) * (sqrt((xy(1) - mic1(1))^2 + (xy(2) - mic1(2))^2) - sqrt((xy(1) - mic3(1))^2 + (xy(2) - mic3(2))^2)) - td13;
    (1 / 343) * (sqrt((xy(1) - mic1(1))^2 + (xy(2) - mic1(2))^2) - sqrt((xy(1) - mic4(1))^2 + (xy(2) - mic4(2))^2)) - td14;
    %(1 / 343) * (sqrt((xy(1) - mic2(1))^2 + (xy(2) - mic2(2))^2) - sqrt((xy(1) - mic3(1))^2 + (xy(2) - mic3(2))^2)) - td23;
    %(1 / 343) * (sqrt((xy(1) - mic2(1))^2 + (xy(2) - mic2(2))^2) - sqrt((xy(1) - mic4(1))^2 + (xy(2) - mic4(2))^2)) - td24;
    %(1 / 343) * (sqrt((xy(1) - mic3(1))^2 + (xy(2) - mic3(2))^2) - sqrt((xy(1) - mic4(1))^2 + (xy(2) - mic4(2))^2)) - td34;
];

% Provide an initial guess for the source coordinates (x, y)
initial_guess = [40, 15]; % Replace with your initial guess

% Use lsqnonlin to solve for x and y
options = optimoptions('lsqnonlin', 'Display', 'iter'); % You can customize options
result = lsqnonlin(cost_function, initial_guess, [], [], options);

% Extract the estimated source coordinates (x, y)
x_estimate = result(1);
y_estimate = result(2);

% Display the results
disp(['Estimated Source Coordinates (x, y): (' num2str(x_estimate) ', ' num2str(y_estimate) ')']);




function time_delay = gcc(sig1,sig2)
cross_corr = xcorr(sig1, sig2);
normalized_cross_corr = abs(cross_corr) / max(abs(cross_corr));

[max_corr_value, max_corr_index] = max(normalized_cross_corr);

time_delay = (max_corr_index - 1) - (numel(sig1) - 1);
end


