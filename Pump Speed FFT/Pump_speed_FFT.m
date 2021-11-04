%{
Script to batch-process FFT profile plots from ImageJ
Marc Wasserman, 10-27-2021

Use notes:
- Only setup to do 10-second video clips (autodetect hz is a frame count)
- File import format = .csv
- Expect slice # in col 1 and pixel value in col 2
- Need to put all the csv's into a single folder, the select this folder
when prompted
- Kind of crappy 0hz rejection: basically just throw out first FFT point

%}

selpath = uigetdir;
fileList = dir(selpath+"/*.csv");
numFiles = length(fileList);

for k=1:numFiles
    %clear vars for next loop, avoid weird problems
    clear d s Fs T L t Y P2 P1 f max_num max_idx;
    
    fprintf('Processing File number %d \n', k);
    
    %FFT help script, basically copied line-for-line from Matlab help
    [d,s] = xlsread(selpath+"/"+fileList(k).name); 

    %Fs = 60;                % Sampling frequency (fixed), could toggle 
    if length(d > 400)      %Figure out roughly if 30 or 60hz based on number of frames in 10sec clip
        Fs = 60;
    else Fs = 30;
    end
        
    T = 1/Fs;               % Sampling period       
    L = size(d,1);          % Length of signal
    t = (0:L-1)*T;          % Time vector

    Y = fft(d(:,2));        % Output from ImageJ has data in column 2 (col 1 is slice n)
    P2 = abs(Y/L);          % 2-sided spectrum P2
    P1 = P2(1:L/2+1);       % 1-sided P1
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    
    [max_num, max_idx] = max(P1(2:length(P1)));
    
    pumpSpeed(k) = f(max_idx+1);
    
end

%I hate Matlab IO... gross brute-forced save results as a csv file:
names = {fileList.name};
resultsTab = [names',num2cell(pumpSpeed')];
writecell(resultsTab,'Pump_speed_outputs.csv');
fprintf('Processing completed');

   