%PWM Volume Analysis Script
%Used on the Results_Output folder from ImageJ
clear all;

%***User-Entered Parameters Here:***
hpx = 97; %image height in pixels
wpx = 279; %image width in pixels
fps = 5; %ffmpeg fps exported
dt = 1/fps; %time between samples

%BEGIN SCRIPT:
%Select results folder via UI dialog popup
selpath = uigetdir;
fileList = dir(selpath+"/*.txt");
L = length(fileList);
mkdir(selpath, 'Plot_Images');

%Wedge parameters
hmm = 53; %mm
wmm = 150; %mm

hconvert = hmm/hpx;
wconvert = wmm/wpx;

%Outer Loop
for k = 1:L %step through each file in the list
    T = readtable(selpath+"/"+fileList(k).name);

    %Inner loop code:
    for i = 1:height(T)
        wdth(i) = T.X(i)*wconvert;
        sa(i) = WedgeArea(T.Y(i)*hconvert);
    end

    tstep(k) = dt*k - dt; % time step starting from 0, in seconds
    vol(k) = trapz(wdth,sa)/1000; %volume from area function, converted to mL

end

%Turn this section of to disable plot frame output:
for idx = 1:L
    fig = figure;
    plot(tstep(1:idx),vol(1:idx));
    xlim([0, tstep(end)]);
    ylim([0, 60]);
    frame = getframe(fig);
    img = frame2im(frame);
    imwrite(img, selpath+"/Plot_Images/plot_frame_"+idx+".tif");
    close(fig);
end

plot(tstep,vol);
ylabel('Volume (mL)')
xlabel('Time (s)')