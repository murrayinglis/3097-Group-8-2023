function gcc_test3(x,y)

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


% Time and frequency
Fs = 100000;
t = 0:1/Fs:0.1;
f = 10000; 
signal = sin(2 * pi * f * t);

% Calculating delays
t1 = (d1 / 343);
t2 = (d2 / 343);
t3 = (d3 / 343);
t4 = (d4 / 343);
delays = round([t1*Fs,t2*Fs,t3*Fs,t4*Fs]);

% Adding delay to signals
signals = zeros(4,length(signal)+max(delays));
for i = 1:4
    signals(i, delays(i)+1:delays(i)+length(signal)) = signal;
end

% Calculating time delays from xcorr
time_diffs = zeros(1,3);
for i = 2:4
    [cross_corr,lags]=xcorr(signals(1,:),signals(i,:));
    [~,idx]=max(cross_corr);
    time_diffs(i-1)=lags(idx)/Fs;
end

td12 = time_diffs(1);
td13 = time_diffs(2);
td14 = time_diffs(3);


% Actual hyperbolas to solve
eq1 = @(x, y) td12 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic2(1)).^2 + (y - mic2(2)).^2));
eq2 = @(x, y) td13 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic3(1)).^2 + (y - mic3(2)).^2));
eq3 = @(x, y) td14 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic4(1)).^2 + (y - mic4(2)).^2));


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
