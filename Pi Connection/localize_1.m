function localize_1(sig1,sig2,sig3,sig4,Fs)

% Mic positions
mic1 = [0, 0];
mic2 = [0, 0.5];
mic3 = [0.8, 0.5];
mic4 = [0.8, 0];

first = mic1;    % order that the microphones receive the sound
second = mic2;
third = mic3;
fourth = mic4;

fir = 1;

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
signal1=sig1(14*Fs:end);
signal2=sig2(14*Fs:end);
signal3=sig3(14*Fs:end);
signal4=sig4(14*Fs:end);
signal5=sig1(1:11*Fs);
signal6=sig2(1:11*Fs);
signal7=sig3(1:11*Fs);
signal8=sig4(1:11*Fs);

td56 = gcc(signal5,signal6,Fs);
td57 = gcc(signal5,signal7,Fs);
td58 = gcc(signal5,signal8,Fs);
td67 = gcc(signal6,signal7,Fs);
td68 = gcc(signal6,signal8,Fs);
td78 = gcc(signal7,signal8,Fs);

%figure
plot(t,sig1);
figure
plot(t,sig2);
figure
plot(t,sig3);
figure
plot(t,sig4);


% Calculating time delays from gcc
% Time delay calculations
td12 = gcc(signal1,signal2,Fs)-td56
td13 = gcc(signal1,signal3,Fs)-td57
td14 = gcc(signal1,signal4,Fs)-td58
td23 = gcc(signal2,signal3,Fs)-td67
td24 = gcc(signal2,signal4,Fs)-td68
td34 = gcc(signal3,signal4,Fs)-td78


% arranging the microphones

if td12 > 0
    first = mic2;
    fir = 2;
elseif td13 > 0
    first = mic3;
    fir = 3;
elseif td14 > 0
    first = mic4;
    fir = 4;
end
if first == mic2
    if td23 >0
        first = mic3;
        fir = 3;
    elseif td24 > 0
        first = mic4;
        fir = 4;
    end
end
if first == mic3
    if td34 > 0
        first = mic4;
        fir = 4;
    end
end


switch fir
    case 1
        td12_new = td12;
        td13_new = td13;
        td14_new = td14;
        if td23 >0 
            if td24 >0
                fourth = mic2;
                four = 2;
                if td34 >0
                    second = mic4;
                    sec = 4;

                    td12_new = td14;
                    td14_new = td12;
                    td13_new = td13;
                    
                end
            else 
                third = mic2;
                thir = 2;
                second = mic3;
                sec = 3;

                td12_new = td13;
                td13_new = td12;
                td14_new = td14;
            end
        elseif td24 >0
            second = mic4;
            sec = 4;
            third = mic2;
            thir = 2;
            fourth = mic3;
            four = 3;

            td12_new = td14;
            td13_new = td12;
            td14_new = td13;
        elseif td34 >0
            third = mic4;
            thir = 4;
            fourth =mic3;
            four = 3;

            td12_new = td12;
            td13_new = td14;
            td14_new = td13;

        end
        

        
    case 2
        second = mic1;
        sec = 1;
        td12_new = td12;
        td13_new = td23;
        td14_new = td24;
        if td13 >0 
            if td14 >0
                fourth = mic1;
                four = 1;
                if td34 >0
                    second = mic4;
                    sec = 4;

                    td12_new = td24;
                    td13_new = td23;
                    td14_new = td12;
                end
            else 
                third = mic1; 
                thir = 1;
                second = mic3;
                sec = 3;

                td12_new = td23;
                td13_new = td12;
                td14_new = td24;
            end
        elseif td14 >0
            second = mic4;
            sec = 4;
            third = mic1;
            thir = 1;
            fourth = mic3;
            four = 3;

            td12_new = td24;
            td13_new = td12;
            td14_new = td23;
        elseif td34 >0
            third = mic4;
            fourth = mic3;

            td12_new = td12;
            td13_new = td24;
            td14_new = td23;
        end
        
    case 3
        second = mic1;
        third = mic2;

        td12_new = td13;
        td13_new = td23;
        td14_new = td34;

        if td12 >0 
            if td14 >0
                fourth = mic1;

                td14_new = td13;
                if td24 >0
                    second = mic4;

                    td12_new = td34;
                end
            else 
                third = mic1;
                second = mic2;

                td13_new = td13;
                td12_new = td23;
            end
        elseif td14 >0
            second = mic4;
            third = mic1;
            fourth = mic2;

            td12_new = td34;
            td13_new = td13;
            td14_new = td23;
        elseif td24 >0
            third = mic4;
            fourth =mic2;

            td13_new = td34;
            td14_new = td23;
        end
        
    case 4
        second = mic1;
        third = mic2;
        fourth = mic3;

        td12_new = td14;
        td13_new = td24;
        td14_new = td34;

        if td12 >0 
            if td13 >0
                fourth = mic1;

                td14_new = td14;
                if td23 >0
                    second = mic3;

                    td12_new = td34;
                end
            else 
                third = mic1;
                second = mic2;

                td13_new = td14;
                td12_new = td24;
            end
        elseif td13 >0
            second = mic3;
            third = mic1;
            fourth = mic2;

            td12_new = td34;
            td13_new = td14;
            td14_new = td24;

        elseif td23 >0
            third = mic3;
            fourth = mic2;

            td13_new = td34;
            td14_new = td24;
        end
end



x0 = first(1);
y0 = first(2);
x1 = second(1);
y1 = second(2);
x2 = third(1);
y2 = third(2);
x3 = fourth(1);
y3 = fourth(2);

td12_new
td13_new
td14_new

% Step 1: Define symbolic variables and equations

eq1 = @(x, y) -abs(td12_new)*343 + sqrt((x-x1)^2 + (y-y1)^2) - sqrt((x-x0)^2 + (y-y0)^2);
eq2 = @(x, y) -abs(td13_new)*343 + sqrt((x-x2)^2 + (y-y2)^2) - sqrt((x-x0)^2 + (y-y0)^2);
eq3 = @(x, y) -abs(td14_new)*343 + sqrt((x-x3)^2 + (y-y3)^2) - sqrt((x-x0)^2 + (y-y0)^2);


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
x_range = linspace(-3, 3, 200); % Adjust the range as needed
y_range = linspace(-3, 3, 200); % Adjust the range as needed

% Create a meshgrid for x and y
[X, Y] = meshgrid(x_range, y_range);

% Evaluate the equations for the entire grid
Z1 = eq1(X, Y);
Z2 = eq2(X, Y);
Z3 = eq3(X, Y);

% Create a new figure for plotting hyperbolas
figure(2);

% Plot the equations eq1, eq2, and eq3
contour(abs(X), abs(Y), abs(Z1), [0, 0], 'g-', 'LineWidth', 1.5);
hold on;
contour(abs(X), abs(Y), abs(Z2), [0, 0], 'b-', 'LineWidth', 1.5);
contour(abs(X), abs(Y), abs(Z3), [0, 0], 'm-', 'LineWidth', 1.5);



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

function time_delay = gcc(sig1, sig2, Fs)
[cross_corr, lags] = xcorr(sig1, sig2);
[~, val] = max(cross_corr);
time_delay = lags(val)/Fs;

end
