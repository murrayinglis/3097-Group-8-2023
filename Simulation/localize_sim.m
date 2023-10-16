function localize_sim(x,y) %#codegen

Fs = 64000;

% Mic positions
mic1 = [0, 0];
mic2 = [0, 0.5];
mic3 = [0.8, 0.5];
mic4 = [0.8, 0];

% Source position
sp = [x,y];


% Calculating distance from source to mics
d1 = sqrt((sp(1) - mic1(1))^2 + (sp(2) - mic1(2))^2);
d2 = sqrt((sp(1) - mic2(1))^2 + (sp(2) - mic2(2))^2);
d3 = sqrt((sp(1) - mic3(1))^2 + (sp(2) - mic3(2))^2);
d4 = sqrt((sp(1) - mic4(1))^2 + (sp(2) - mic4(2))^2);


% Calculating delays
t1 = (d1 / 343);
t2 = (d2 / 343);
t3 = (d3 / 343);
t4 = (d4 / 343);
delays = round([t1*Fs,t2*Fs,t3*Fs,t4*Fs]);

% Signal constants
t = 0:1/Fs:0.1;
f = 400; 
signal = sin(2 * pi * f * t);

% Adding delay to signals
signals = zeros(4,length(signal)+max(delays));
for i = 1:4
    signals(i, delays(i)+1:delays(i)+length(signal)) = signal;
end

% Adding noise to signals
signals = signals + 0.05*randn(size(signals));
sig1 = signals(1,:);
sig2 = signals(2,:);
sig3 = signals(3,:);
sig4 = signals(4,:);

% Plotting signals
t = 0:1/Fs:0.1+max(delays)/Fs;
figure(1);
plot(t,signals(1,:))
hold on
plot(t,signals(2,:))
plot(t,signals(3,:))
plot(t,signals(4,:))

% Calculating time delays from gcc
td12 = gcc(sig1,sig2,Fs)
td13 = gcc(sig1,sig3,Fs)
td14 = gcc(sig1,sig4,Fs)


% Hyperbolas to solve
eq1 = @(x, y) td12 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic2(1)).^2 + (y - mic2(2)).^2));
eq2 = @(x, y) td13 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic3(1)).^2 + (y - mic3(2)).^2));
eq3 = @(x, y) td14 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic4(1)).^2 + (y - mic4(2)).^2));


% Use a numerical solver to find the intersection points
initial_guess = [0, 0];  % Initial guess for the intersection point
options = optimset('Display', 'off');  % Suppress solver output

[x1, y1] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], initial_guess, options);
[x2, y2] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], [0, 0], options);
[x3, y3] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], [0, 0], options);

% Calculate the center of the triangle
center_x = (x1 + x2 + x3) / 3;
center_y = (y1 + y2 + y3) / 3;

% Display the results
disp(['Estimated coordinates: (', num2str(center_x), ')']);


% Define a range of x and y values
x_range = linspace(0, 0.8, 1000); % Adjust the range as needed
y_range = linspace(0, 0.5, 1000); % Adjust the range as needed

% Create a meshgrid for x and y
[X, Y] = meshgrid(x_range, y_range);

% Evaluate the equations for the entire grid
Z1 = eq1(X, Y);
Z2 = eq2(X, Y);
Z3 = eq3(X, Y);

% Create a new figure for plotting hyperbolas
figure(2);

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
title('Acoustic Triangulation');
legend('eq1', 'eq2', 'eq3', 'Microphones', 'Estimated Source', 'Actual Source');


hold off;

end

function time_delay = gcc(sig1, sig2, Fs)
[cross_corr, lags] = xcorr(sig1, sig2);
[~, val] = max(cross_corr);
time_delay = lags(val)/Fs;

end
