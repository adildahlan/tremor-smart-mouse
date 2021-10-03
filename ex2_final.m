% Define the number of samples to consider (iterations)
samples = 3000;

% Define the period between iterations
sampling_period = 0.001;

% assign output variable from callback function
C = [];

% crete a timer object and set its properties
t_obj = timer;
set(t_obj, 'Period', sampling_period);
set(t_obj, 'TasksToExecute', samples);
set(t_obj, 'ExecutionMode', 'fixedRate');
set(t_obj, 'UserData', C);
set(t_obj, 'TimerFcn',{@swap_fcn});

% start timer loop
start(t_obj);

% Pause for 10s to collect data
pause(10);

% Determine the collected cursor coordinates
C=t_obj.UserData;

% Define the sampling frequency
fs=1/sampling_period;

% Define Nyquest frequency
nyq=fs/2;

% Define cut off frequency to be 2Hz
fc=2;

% Define normalized cut off frequency
Wn=fc/nyq;

% Define the coefficients of the low pass 4th order filter of cut off
% frequency equal to 2Hz
[b,a] = butter(4,Wn,'low');

% Filter the x and y coordinates of the cursor
C1_filtered=filtfilt(b, a , C(:,1));
C2_filtered=filtfilt(b, a , C(:,2));

% Open a screen size figure whose x and y axis are the screen's pixels 
figure;
dim = get(0, 'Screensize')
set(gcf, 'Position', dim);
xlim([0 dim(3)]);
ylim([0 dim(4)]);
% Plot collected cursor position data
plot(C(:,1), C(:,2), '--x')
% Plot the filtered coordinates
hold on;
plot(C1_filtered, C2_filtered, '--x');
% Add legend to the figure
legend('Original Captured Cursor Position', 'Low-Pass Filtered Cursor Position', 'FontSize', 20);
% Add title
title('Cursor Trace Before and After Filtering', 'FontSize', 20);

% Define callback function
function [C] = swap_fcn(obj, event)
        % get current user data
        C = get(obj, 'UserData');
        c = get(0, 'PointerLocation')
        % update any changes
        C=[C;c];
        set(obj,'UserData',C);
end