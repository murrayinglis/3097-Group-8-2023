% Mic positions
mic1 = [0, 0];
mic2 = [80, 0];
mic3 = [0, 30];
mic4 = [80, 30];

% Source position
sp = [50, 38];


% Calculating distance from source to mics
d1 = sqrt((sp(1) - mic1(1))^2 + (sp(2) - mic1(2))^2);
d2 = sqrt((sp(1) - mic2(1))^2 + (sp(2) - mic2(2))^2);
d3 = sqrt((sp(1) - mic3(1))^2 + (sp(2) - mic3(2))^2);
d4 = sqrt((sp(1) - mic4(1))^2 + (sp(2) - mic4(2))^2);

t1 = d1 / 343;
t2 = d2 / 343;
t3 = d3 / 343;
t4 = d4 / 343;


% Define time vector 't' and signal frequency
Fs = 1000;
t = linspace(0, 1, 1000);  % Adjust the time span and number of samples as needed
signal_frequency = 5;  % Adjust the signal frequency as needed
ref = sin(2 * pi * signal_frequency * t);

% Initialize the signals as zeros
sig1 = zeros(size(t));
sig2 = zeros(size(t));
sig3 = zeros(size(t));
sig4 = zeros(size(t));

% Define signals using logical indexing
sig1(t >= t1) = sin(2 * pi * signal_frequency * (t(t >= t1) - t1));
sig2(t >= t2) = sin(2 * pi * signal_frequency * (t(t >= t2) - t2));
sig3(t >= t3) = sin(2 * pi * signal_frequency * (t(t >= t3) - t3));
sig4(t >= t4) = sin(2 * pi * signal_frequency * (t(t >= t4) - t4));


plot(t,sig1)
hold on
plot(t,sig2)
plot(t,sig3)
plot(t,sig4)

sig1 = transpose(sig1);
sig2 = transpose(sig2);
sig3 = transpose(sig3);
sig4 = transpose(sig4);


% Time delay calculations
%td12 = gccphat(sig1, sig2)
%td13 = gccphat(sig1, sig3)
%td14 = gccphat(sig1, sig4)
td12 = gcc(sig1,sig2,Fs)
td13 = gcc(sig1,sig3,Fs)
td14 = gcc(sig1,sig4,Fs)




% Define the equations
%eq1 = @(x, y) 0.01 * 343 - (sqrt(x.^2 + y.^2) - sqrt(x.^2 + (y - 30).^2));
%eq2 = @(x, y) 0.02 * 343 - (sqrt(x.^2 + y.^2) - sqrt((x - 80).^2 + (y - 30).^2));
%eq3 = @(x, y) 0.05 * 343 - (sqrt(x.^2 + y.^2) - sqrt((x - 80).^2 + y.^2));


eq1 = @(x, y) td12 * 343 - (sqrt(x.^2 + y.^2) - sqrt((x - 80).^2 + (y - 0).^2));
eq2 = @(x, y) td13 * 343 - (sqrt(x.^2 + y.^2) - sqrt((x - 0).^2 + (y - 30).^2));
eq3 = @(x, y) td14 * 343 - (sqrt(x.^2 + y.^2) - sqrt((x - 80).^2 + (y - 30).^2));



% Use a numerical solver to find the intersection points
initial_guess = [0, 0];  % Initial guess for the intersection point
options = optimset('Display', 'off');  % Suppress solver output

[x1, y1] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], initial_guess, options);
[x2, y2] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], [10, 10], options);
[x3, y3] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], [80, 10], options);

% Calculate the center of the triangle
center_x = (x1 + x2 + x3) / 3;
center_y = (y1 + y2 + y3) / 3;

% Display the results
disp(['Center of the triangle: (', num2str(center_x), ', ', num2str(center_y), ')']);





function time_delay = gcc(sig1, sig2, Fs)
cross_corr = xcorr(sig1, sig2);
normalized_cross_corr = abs(cross_corr) / max(abs(cross_corr));

[max_corr_value, max_corr_index] = max(normalized_cross_corr);

time_delay = ((max_corr_index - 1) - (numel(sig1) - 1)) / Fs;
end