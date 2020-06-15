% stationTable = readtable('201710-citibike-tripdata.csv');
% stationTable = removevars(stationTable,{'tripduration','startStationName','endStationName','bikeid','usertype','birthYear','gender'});
% stationID = unique([table2array(stationTable(:,3));table2array(stationTable(:,6))]);
% station_loc = zeros(size(stationID,1),2);
% for i=1:size(stationID,1)
%     index = find(table2array(stationTable(:,3))==stationID(i),1);
%     if size(index,1)~=0
%         station_loc(i,:) = table2array(stationTable(index,4:5));
%     else
%         index = find(table2array(stationTable(:,6))==stationID(i),1);
%         station_loc(i,:) = table2array(stationTable(index,7:8));
%     end
% end
% station = [stationID, station_loc];
% % station_mah = station(1:279,:); old stations
% save('station_id_loc','station');
load('station_id_loc.mat');
weekdayStartTable = stationTable(~isweekend(table2array(stationTable(:,1))),[1,3]);
weekdayEndTable = stationTable(~isweekend(table2array(stationTable(:,2))),[2,6]);

bias = 3;
station = [station, zeros(size(station,1),48)];
% accumulate # of rent events
for i=1:size(weekdayStartTable,1)
    index = find(station(:,1)==table2array(weekdayStartTable(i,2)));
    if size(index,1)~=0
        timeHour = hms(table2array(weekdayStartTable(i,1)));
        station(index,bias+timeHour+1) = station(index,bias+timeHour+1)+1;
    end
end
% accumulate # of return events
for i=1:size(weekdayEndTable,1)
    index = find(station(:,1)==table2array(weekdayEndTable(i,2)));
    if size(index,1)~=0
        timeHour = hms(table2array(weekdayEndTable(i,1)));
        station(index,bias+timeHour+1+24) = station(index,bias+timeHour+1+24)+1;
    end
end
startDate = table2array(weekdayStartTable(:,1));
startDate.Format = 'MMM-dd-yyyy';
numStartDates = size(unique(cellstr(startDate)),1);
endDate = table2array(weekdayEndTable(:,1));
endDate.Format = 'MMM-dd-yyyy';
numEndDates = size(unique(cellstr(endDate)),1);
station(:,4:51) = round(station(:,4:51)/numStartDates);

save('nyc_station','station');
