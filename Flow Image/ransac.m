function M = ransac(data,order,maxIter,distMax)
clc;
%% 
% data - image data to be fitted
% order - order of fit
% maxIter - maximum number of iterations
% distMax - tolerance for determining outliers
%%
%Initialize
columns = data(1,:);
rows = data(2,:);
img = ones(1024,1024);
n = length(rows);
count = 0; %counter for number of inliers
M = []; %regression model
% Plot the data
figure 
imagesc(img); colormap gray;
axis image;hold on;
plot(columns,rows,'*');hold on;

%% Find best model iteratively
for i = 1:maxIter
    idx = randperm(n,order+1); 
    %select random sample of m+1 points for fit of order m
    sample = data(:,idx); 
    P = polyfit(sample(2,:),sample(1,:),order);% fit a linear regression model
    YY = polyval(P,data(2,:));
    distance = YY - data(1,:);%calculate distance between model and actual points
    
    %determine inliers
    inliers_where = find(abs(distance)<=distMax);
    inliers_num = length(inliers_where);
    
    %Update the best regression model
    if inliers_num > count
        count = inliers_num;
        %M = P;
        %Calculate regression model with only inliers
        inliers = data(:,inliers_where);
        M = polyfit(inliers(2,:),inliers(1,:),order);
        
    end
end

%%Plot the best model
plot(inliers(1,:),inliers(2,:),'r*');hold on; %plot inliers
XX = linspace(min(rows),max(rows),100);
YY = polyval(M,XX);
plot(YY,XX,'g-','LineWidth',1.5);
legend('data','inliers','regression model');
end


