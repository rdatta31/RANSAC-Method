% Reading laser line on images

% This script determines the average displacemnt of the laser beam
% during granular flow, by fitting a 2nd Order curve to the vertical beam
% using a RANSAC algorithm


clc;clear;close all;

%% Detecting Laser on Images
%Read test image(s)
flowImg = imread('flow.tif');%test image
controlImg = imread('control.tif');%control image

% Make image greyscale
flowImg = flowImg(:,:,1);
controlImg = controlImg(:,:,1);

%find points with high brightness
[row_t,column_t] = find(flowImg>30);%coordinates of the laser
[row_c,column_c] = find(controlImg>30);

%plot the laser points
figure %test
imagesc(flowImg);hold on;
colormap gray; 
axis image; hold on;
plot(column_t,row_t,'b.');hold on;
title('Flow Image');
legend('Laser position');
saveas(gcf,'flowLaser.png');

figure %control
imagesc(controlImg);hold on;
colormap gray; 
axis image; hold on;
plot(column_c,row_c,'b.');hold on;
title('Control Image');
legend('Laser position');
saveas(gcf,'controlLaser.png');

%% RANSAC Fitting
%isolate laser in y direction
data_t = [column_t';row_t']; %initialize data for RANSAC algorithm
data_c = [column_c';row_c'];
M_t = ransac(data_t,2,200,7);%fit a second order curve using RANSAC algorithm
M_c = ransac(data_c,2,200,7);%fit a second order curve using RANSAC algorithm

%Plot best fit curve on laser
figure %test
imagesc(flowImg);hold on;
colormap gray; 
axis image;
XX_t = linspace(min(row_t),max(row_t),100);
YY_t = polyval(M_t,XX_t);
plot(YY_t,XX_t,'g-','LineWidth',1.5);
title('Flow Image');
legend('Laser position - best fit curve');
saveas(gcf,'flowCurve.png');

figure %control
imagesc(controlImg);hold on;
colormap gray; 
axis image;
XX_c = linspace(min(row_c),max(row_c),100);
YY_c = polyval(M_c,XX_c);
plot(YY_c,XX_c,'g-','LineWidth',1.5);
title('Control Image');
legend('Laser position - best fit curve');
saveas(gcf,'controlCurve.png');

%% Calculating Average displacement

figure
img = ones(1024,1024);
imagesc(img);hold on;
colormap gray; 
axis image;
plot(YY_c,XX_c,'r-','LineWidth',1.5); hold on;%control
plot(YY_t,XX_t,'g-','LineWidth',1.5);%test
legend('Control','Test');
saveas(gcf,'laser positions.png');

%displacement calculation

d = abs(YY_c - YY_t);
figure
plot(XX_c,d,'-b','LineWidth',1.5);
title('Displacement of Laser due to Flow');
ylabel('Displacement, px');
xlabel('y');
xlim([0,1024]);
set(gca, 'Fontname','Times New Roman');
set(gca, 'Fontsize',10);
saveas(gcf,'displacement.png');

d_avg = mean(d);
fprintf('Average Displacement (px): ');
fprintf('%8.6f\n',d_avg);



