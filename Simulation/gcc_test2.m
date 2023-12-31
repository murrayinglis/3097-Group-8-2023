function gcc_test2(x,y)

% Mic positions
mic1 = [0, 0];
mic2 = [80, 0];
mic3 = [0, 30];
mic4 = [80, 30];

% Source position
sp = [x,y];


% Calculating distance from source to mics
d1 = sqrt((sp(1) - mic1(1))^2 + (sp(2) - mic1(2))^2);
d2 = sqrt((sp(1) - mic2(1))^2 + (sp(2) - mic2(2))^2);
d3 = sqrt((sp(1) - mic3(1))^2 + (sp(2) - mic3(2))^2);
d4 = sqrt((sp(1) - mic4(1))^2 + (sp(2) - mic4(2))^2);


% Define time vector 't' and signal frequency
Fs = 100000;
t = linspace(0, 1, Fs); 
signal_frequency = 1000; 
%ref = sin(2 * pi * signal_frequency * t);

% Calculating delays
t1 = (d1 / 343);
t2 = (d2 / 343);
t3 = (d3 / 343);
t4 = (d4 / 343);


% Initialize the signals as zeros
sig1 = zeros(size(t));
sig2 = zeros(size(t));
sig3 = zeros(size(t));
sig4 = zeros(size(t));

% Define signals with delay
sig1(t >= t1) = sin(2 * pi * signal_frequency * (t(t >= t1) - t1));
sig2(t >= t2) = sin(2 * pi * signal_frequency * (t(t >= t2) - t2));
sig3(t >= t3) = sin(2 * pi * signal_frequency * (t(t >= t3) - t3));
sig4(t >= t4) = sin(2 * pi * signal_frequency * (t(t >= t4) - t4));


%plot(t,sig1)
%hold on
%plot(t,sig2)
%plot(t,sig3)
%plot(t,sig4)
%hold off

%sig1 = transpose(sig1);
%sig2 = transpose(sig2);
%sig3 = transpose(sig3);
%sig4 = transpose(sig4);


% Time delay calculations
td12 = gcc1(sig1,sig2,Fs)
td13 = gcc1(sig1,sig3,Fs)
td14 = gcc1(sig1,sig4,Fs)

td12_actual = t1-t2
td13_actual = t1-t3
td14_actual = t1-t4


% Equations to solve

% Test hyperbolas (gives real answer)
%eq1 = @(x, y) td12_actual * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic2(1)).^2 + (y - mic2(2)).^2));
%eq2 = @(x, y) td13_actual * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic3(1)).^2 + (y - mic3(2)).^2));
%eq3 = @(x, y) td14_actual * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic4(1)).^2 + (y - mic4(2)).^2));

% Actual hyperbolas to solve
eq1 = @(x, y) td12 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic2(1)).^2 + (y - mic2(2)).^2));
eq2 = @(x, y) td13 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic3(1)).^2 + (y - mic3(2)).^2));
eq3 = @(x, y) td14 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic4(1)).^2 + (y - mic4(2)).^2));


% Use a numerical solver to find the intersection points
initial_guess = [40, 15];  % Initial guess for the intersection point
options = optimset('Display', 'off');  % Suppress solver output

[x1, y1] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], initial_guess, options);
[x2, y2] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], [10, 10], options);
[x3, y3] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], [80, 10], options);

% Calculate the center of the triangle
center_x = (x1 + x2 + x3) / 3;
center_y = (y1 + y2 + y3) / 3;

% Display the results
disp(['Estimated coordinates: (', num2str(center_x), ')']);


% Define a range of x and y values
x_range = linspace(-100, 100, 200); % Adjust the range as needed
y_range = linspace(-100, 100, 200); % Adjust the range as needed

% Create a meshgrid for x and y
[X, Y] = meshgrid(x_range, y_range);

% Evaluate the equations for the entire grid
Z1 = eq1(X, Y);
Z2 = eq2(X, Y);
Z3 = eq3(X, Y);

% Create a new figure for plotting
figure;

% Plot the equations eq1, eq2, and eq3
contour(X, Y, Z1, [0, 0], 'g-', 'LineWidth', 1.5);
hold on;
contour(X, Y, Z2, [0, 0], 'b-', 'LineWidth', 1.5);
contour(X, Y, Z3, [0, 0], 'm-', 'LineWidth', 1.5);



% Plot microphone positions
plot([mic1(1), mic2(1), mic3(1), mic4(1)], [mic1(2), mic2(2), mic3(2), mic4(2)], 'ro', 'MarkerSize', 10, 'LineWidth', 2);

% Plot the estimated source point
plot(center_x(1),center_x(2),'rx', 'MarkerSize', 10, 'LineWidth', 2);

% Plot actual source position
plot(sp(1),sp(2),'rx', 'MarkerSize', 10, 'LineWidth', 2, 'Color', [0,0,0]);

% Add labels and legend
xlabel('X-coordinate');
ylabel('Y-coordinate');
title('Acoustic Triangualtion');
legend('eq1', 'eq2', 'eq3', 'Microphones', 'Estimated Source', 'Actual Source');


hold off;


end



function time_delay = gcc(sig1, sig2, Fs)
cross_corr = xcorr(sig1, sig2);
normalized_cross_corr = abs(cross_corr) / max(abs(cross_corr));

[max_corr_value, max_corr_index] = max(normalized_cross_corr);

time_delay = ((max_corr_index - 1) - (numel(sig1) - 1)) / Fs;

end

function time_delay = gcc1(sig1, sig2, Fs)
[cross_corr, lags] = xcorr(sig1, sig2);
[~, val] = max(cross_corr);
time_delay = lags(val)/Fs;

end
