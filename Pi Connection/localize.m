function localize(sig1,sig2,sig3,sig4,Fs)


% Filtering
% Define filter parameters
low_cutoff_frequency = 300;  % Adjust the lower cutoff frequency as needed
high_cutoff_frequency = 3000; % Adjust the upper cutoff frequency as needed
filter_order = 4;            % Adjust the filter order as needed

% Design a bandpass Butterworth filter
[b, a] = butter(filter_order, [low_cutoff_frequency, high_cutoff_frequency] / (Fs / 2), 'bandpass');

% Apply the filter to each signal
sig1 = filtfilt(b, a, sig1);
sig2 = filtfilt(b, a, sig2);
sig3 = filtfilt(b, a, sig3);
sig4 = filtfilt(b, a, sig4);


% Mic positions
mic1 = [0, 0];
mic2 = [0, 0.5];
mic3 = [0.8, 0.5];
mic4 = [0.8, 0];

t = linspace(0,length(sig1)/Fs,length(sig1));


% Cut off start trail
sig1(1:0.03*Fs)=0;
sig2(1:0.03*Fs)=0;
sig3(1:0.03*Fs)=0;
sig4(1:0.03*Fs)=0;

%t=t(15*Fs:end);
signal1=sig1(15*Fs:end);
signal2=sig2(15*Fs:end);
signal3=sig3(15*Fs:end);
signal4=sig4(15*Fs:end);
signal5=sig1(1:15*Fs);
signal6=sig2(1:15*Fs);
signal7=sig3(1:15*Fs);
signal8=sig4(1:15*Fs);

td56 = gcc(signal5,signal6,Fs)
td57 = gcc(signal5,signal7,Fs)
td58 = gcc(signal5,signal8,Fs)
td67 = gcc(signal6,signal7,Fs)
td68 = gcc(signal6,signal8,Fs)
td78 = gcc(signal7,signal8,Fs)

%figure
plot(t,sig1);
figure
plot(t,sig2);
figure
plot(t,sig3);
figure
plot(t,sig4);


% Calculating time delays from gcc
td12 = gcc(signal1,signal2,Fs)-td56
td13 = gcc(signal1,signal3,Fs)-td57
td14 = gcc(signal1,signal4,Fs)-td58


% Hyperbolas to solve
eq1 = @(x, y) td12 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic2(1)).^2 + (y - mic2(2)).^2));
eq2 = @(x, y) td13 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic3(1)).^2 + (y - mic3(2)).^2));
eq3 = @(x, y) td14 * 343 - (sqrt((x-mic1(1)).^2 + (y-mic1(2)).^2) - sqrt((x - mic4(1)).^2 + (y - mic4(2)).^2));

% Use a numerical solver to find the intersection points
initial_guess = [0.1, 0.3];  % Initial guess for the intersection point
options = optimset('Display', 'off');  % Suppress solver output

[x1, y1] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], initial_guess, options);
[x2, y2] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], [0.5, 0.8], options);
[x3, y3] = fsolve(@(xy) [eq1(xy(1), xy(2)), eq2(xy(1), xy(2)), eq3(xy(1), xy(2))], [0.4, 0.25], options);


% Calculate the center of the triangle
center_x = (x1 + x2 + x3) / 3;
center_y = (y1 + y2 + y3) / 3;

% Display the results
disp(['Estimated coordinates: (', num2str(center_x), ')']);


% Define a range of x and y values
x_range = linspace(-2, 2, 1000); % Adjust the range as needed
y_range = linspace(-2, 2, 1000); % Adjust the range as neede

% Create a meshgrid for x and y
[X, Y] = meshgrid(x_range, y_range);

% Evaluate the equations for the entire grid
Z1 = eq1(X, Y);
Z2 = eq2(X, Y);
Z3 = eq3(X, Y);

% Create a new figure for plotting hyperbolas
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

% Add labels and legend
xlabel('X-coordinate');
ylabel('Y-coordinate');
title('Acoustic Triangulation');
legend('eq1', 'eq2', 'eq3', 'Microphones', 'Estimated Source');


hold off;

end
