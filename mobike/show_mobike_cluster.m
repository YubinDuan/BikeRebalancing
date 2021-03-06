% show mobike clusters
%function stationArray = build_mobike_stations(numStations,capacityRatio,fixedCapacity)
% % extract all pickup and dropoff locations
% mobike_trace = readtable('mobike_shanghai_sample_updated.csv');
% start_end_loc = [mobike_trace(:,5:6),mobike_trace(:,8:9)];
% all_loc = [table2array(start_end_loc(:,1:2));table2array(start_end_loc(:,3:4))];
% %plot(all_loc(1:1000,1),all_loc(1:1000,2),'x')
% % cut off outliers
% % mobike_trace = mobike_trace(mobike_trace(:,5)>121 & mobike_trace(:,8)>121 ...
% %     & mobike_trace(:,5)<121.8 & mobike_trace(:,8)<121.8 ...
% %     & mobike_trace(:,6)>30.98 & mobike_trace(:,9)>30.98 ...
% %     & mobike_trace(:,6)<31.46 & mobike_trace(:,9)<31.46,:);
% start_end_loc_array = table2array(start_end_loc);
% x_lim = [30.98,31.46];
% y_lim = [121, 121.8];
% mobike_trace = mobike_trace(start_end_loc_array(:,1)>y_lim(1) & start_end_loc_array(:,3)>y_lim(1) ...
%     & start_end_loc_array(:,1)<y_lim(2) & start_end_loc_array(:,3)<y_lim(2) ...
%     & start_end_loc_array(:,2)>x_lim(1) & start_end_loc_array(:,4)>x_lim(1) ...
%     & start_end_loc_array(:,2)<x_lim(2) & start_end_loc_array(:,4)<x_lim(2),:);
% save('mobike_remove_outlier','mobike_trace');
load('mobike_remove_outlier.mat','mobike_trace');
% extract traces in certain area
%x_lim = [31.216536, 31.234869];
%y_lim = [121.454473,121.485398];
% x_lim = [31.23, 31.27];
% y_lim = [121.415,121.455];
x_lim = [31.13, 31.20]
x_lim_map = [31.12, 31.21]
y_lim = [121.472, 121.558]
y_lim_map = [121.46, 121.57]
% x_lim = [0, 90];
% y_lim = [0,180];
cross_dis = distance([x_lim(1), y_lim(1)],[x_lim(2), y_lim(2)])/180*pi*6371;
start_end_loc = [mobike_trace(:,5:6),mobike_trace(:,8:9)];
start_end_loc_array = table2array(start_end_loc);
all_loc = [table2array(start_end_loc(:,1:2));table2array(start_end_loc(:,3:4))];
mobike_trace = mobike_trace(start_end_loc_array(:,1)>y_lim(1) & start_end_loc_array(:,3)>y_lim(1) ...
    & start_end_loc_array(:,1)<y_lim(2) & start_end_loc_array(:,3)<y_lim(2) ...
    & start_end_loc_array(:,2)>x_lim(1) & start_end_loc_array(:,4)>x_lim(1) ...
    & start_end_loc_array(:,2)<x_lim(2) & start_end_loc_array(:,4)<x_lim(2),:);

cutted_loc = [table2array(mobike_trace(:,5:6));table2array(mobike_trace(:,8:9))];
%plot(cutted_loc(:,1),cutted_loc(:,2),'rx')
%numStations = 50;

% extract all rent locations during 8-10AM
weekdayStartTable = mobike_trace(~isweekend(table2array(mobike_trace(:,4))),4:6);
weekdayEndTable = mobike_trace(~isweekend(table2array(mobike_trace(:,7))),7:9);
startDate = table2array(weekdayStartTable(:,1));
startDate.Format = 'MMM-dd-yyyy';
numStartDates = size(unique(cellstr(startDate)),1);
start_loc = table2array(weekdayStartTable(:,2:3));

chosen_loc = zeros(0,2);
% accumulate # of start events during 8-10AM
for i=1:size(start_loc,1)
    timeHour = hms(table2array(weekdayStartTable(i,1)));
    if (timeHour>=7 & timeHour<=12)
        chosen_loc  = [chosen_loc; start_loc(i,:)];
    end
end

numClusters = 12;
figure()
plot(chosen_loc(:,1),chosen_loc(:,2),'x')
[idx,c] = kmeans(chosen_loc,numClusters);

A = imread('Shanghai_[31.12 121.46]_[31.21 121.57].png');
imagesc(y_lim_map,x_lim_map,flip(A))
%figure;
hold on;
color = ['m','r','g','b','m','r','b'];
shape = ['d','p','h','v'];
% for i=1:numClusters
%     plot(chosen_loc(idx==i,1),chosen_loc(idx==i,2),strcat(color(randi(size(color,2))),shape(randi(size(shape,2)))),'MarkerSize',8,'LineWidth',1)
%     %plot(c(i,1),c(i,2),strcat(color(i),'x'),'MarkerSize',15,'LineWidth',3) 
% end
for i=1:numClusters
    plot(chosen_loc(idx==i,1),chosen_loc(idx==i,2),strcat(color(randi(size(color,2))),'p'),'MarkerSize',8,'LineWidth',1)
    %plot(c(i,1),c(i,2),strcat(color(i),'x'),'MarkerSize',15,'LineWidth',3) 
end
plot(c(:,1),c(:,2),strcat('k','x'),'MarkerSize',15,'LineWidth',3)
% [idx,c,sumd] = kmeans(cutted_loc,numStations);
% r = sumd/180*pi*6371;
% s = pi*(r*1000).^2
% if capacityRatio==0
%     capacity = ones(size(sumd))*fixedCapacity;
% else
%     capacity = max([round(s*capacityRatio),5*ones(size(s))]')';
% end
% 
% % find trip records in weekdays
% weekdayStartTable = mobike_trace(~isweekend(table2array(mobike_trace(:,4))),4:6);
% weekdayEndTable = mobike_trace(~isweekend(table2array(mobike_trace(:,7))),7:9);
% 
% startDate = table2array(weekdayStartTable(:,1));
% startDate.Format = 'MMM-dd-yyyy';
% numStartDates = size(unique(cellstr(startDate)),1);
% start_loc = table2array(weekdayStartTable(:,2:3));
% 
% endDate = table2array(weekdayEndTable(:,1));
% endDate.Format = 'MMM-dd-yyyy';
% numEndDates = size(unique(cellstr(endDate)),1);
% end_loc = table2array(weekdayEndTable(:,2:3));
% 
% start_id = kmeans(start_loc,numStations,'MaxIter',1,'Start',c);
% end_id = kmeans(end_loc,numStations,'MaxIter',1,'Start',c);
% 
% stationArray = [[1:numStations]',c,capacity,zeros(numStations,48)];
% bias = 4;
% % accumulate # of rent events
% for i=1:size(start_id,1)
%     station = start_id(i);
%     if size(station,1)~=0
%         timeHour = hms(table2array(weekdayStartTable(i,1)));
%         stationArray(station,bias+timeHour+1) = stationArray(station,bias+timeHour+1)+1;
%     end
% end
% % accumulate # of return events
% for i=1:size(end_id,1)
%     station = end_id(i);
%     if size(station,1)~=0
%         timeHour = hms(table2array(weekdayEndTable(i,1)));
%         stationArray(station,bias+timeHour+1+24) = stationArray(station,bias+timeHour+1+24)+1;
%     end
% end
