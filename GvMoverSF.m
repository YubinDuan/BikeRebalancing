function GvMoverSF
% comparing Greedy and Matching at SF dataset

load('nyc_station.mat','station');
stationArray = station;
stationArray = [station(:,1:3),ones(size(station,1),1)*20,station(:,4:51)];
station_loc = stationArray(:,2:3);

MAXREPEAT = 20;
k = 3;
numStationsToTest = 5:5:35
costList_GLA_G = zeros(size(numStationsToTest));
costList_GLA_M = zeros(size(numStationsToTest));
timeList_GLA_G = zeros(size(numStationsToTest));
timeList_GLA_M = zeros(size(numStationsToTest));
totalWorkerNumber_GLA = zeros(size(numStationsToTest));

costList_1GA_G = zeros(size(numStationsToTest));
costList_1GA_M = zeros(size(numStationsToTest));
timeList_1GA_G = zeros(size(numStationsToTest));
timeList_1GA_M = zeros(size(numStationsToTest));
totalWorkerNumber_1GA = zeros(size(numStationsToTest));

costList_2GA_G = zeros(size(numStationsToTest));
costList_2GA_M = zeros(size(numStationsToTest));
timeList_2GA_G = zeros(size(numStationsToTest));
timeList_2GA_M = zeros(size(numStationsToTest));
totalWorkerNumber_2GA = zeros(size(numStationsToTest));

index = 1;
for i = numStationsToTest
    % i stands for number of stations  
    i
    [positive_gla_mul,negative_gla_mul] = GLA_multiRound(round(stationArray(1:i,4)*0.5),stationArray(1:i,4),-stationArray(1:i,5:28)+stationArray(1:i,29:52));
    [positive_1ga_mul, negative_1ga_mul, feasible] = kGA_multiRound(round(stationArray(1:i,4)*0.5),stationArray(1:i,4),-stationArray(1:i,5:28)+stationArray(1:i,29:52),1);
    [positive_2ga_mul, negative_2ga_mul, feasible] = kGA_multiRound(round(stationArray(1:i,4)*0.5),stationArray(1:i,4),-stationArray(1:i,5:28)+stationArray(1:i,29:52),2);
    totalWorkerNumber_GLA(index) = abs(sum(sum(positive_gla_mul)));
    totalWorkerNumber_1GA(index) = abs(sum(sum(positive_1ga_mul)));
    totalWorkerNumber_2GA(index) = abs(sum(sum(positive_2ga_mul)));
    % Experiment1 where targers are generated by GLA
    accumulate_G = 0;
    accumulate_M = 0;
    accumulateTime_G = 0;
    accumulateTime_M = 0;
    for gla_i = 1:size(positive_gla_mul,2)
        numWorkers = abs(sum(positive_gla_mul(:,gla_i)));
        if numWorkers==0
            continue;
        end
        positive = [station_loc(1:i,:), abs(positive_gla_mul(:,gla_i))];
        negative = [station_loc(1:i,:), abs(negative_gla_mul(:,gla_i))];
%         positive = positive(positive(:,3)~=0,:);
%         negative = negative(negative(:,3)~=0,:);
        cost_G = 0;
        cost_M = 0;
        time_G = 0;
        time_M = 0;
        for repeat = 1 : MAXREPEAT
            users = randomSetWorkers(station_loc(1:k,:), numWorkers, 1); % could test several times for the random user distribution
            tic;
            numWorkers;
            users;
            positive;
            negative;
            [assignment_G_one_round, cost_G_one_round] = greedySearch(users, positive, negative);
            time_G_one_round = toc;
            tic;
            [assignment_M_one_round, cost_M_one_round] = twoRoundMatching(users, positive, negative);
            time_M_one_round = toc;
            cost_G = cost_G + cost_G_one_round/MAXREPEAT;
            cost_M = cost_M + cost_M_one_round/MAXREPEAT;
            time_G = time_G + time_G_one_round/MAXREPEAT;
            time_M = time_M + time_M_one_round/MAXREPEAT;
        end
        accumulate_G = accumulate_G + cost_G; % no need to calculate average
        accumulate_M = accumulate_M + cost_M;
        accumulateTime_G = accumulateTime_G + time_G;
        accumulateTime_M = accumulateTime_M + time_M;
    end
    costList_GLA_G(index) = accumulate_G;
    costList_GLA_M(index) = accumulate_M;
    timeList_GLA_G(index) = accumulateTime_G;
    timeList_GLA_M(index) = accumulateTime_M;
    % Experiment 2 where targers are generated by 2GA
    accumulate_G = 0;
    accumulate_M = 0;
    accumulateTime_G = 0;
    accumulateTime_M = 0;
    for ga1_i = 1:size(positive_1ga_mul,2)
        numWorkers = abs(sum(positive_1ga_mul(:,ga1_i)));
        if numWorkers==0
            continue;
        end
        positive = [station_loc(1:i,:), abs(positive_1ga_mul(:,ga1_i))];
        negative = [station_loc(1:i,:), abs(negative_1ga_mul(:,ga1_i))];
%         positive = positive(positive(:,3)~=0,:);
%         negative = negative(negative(:,3)~=0,:);
        cost_G = 0;
        cost_M = 0;
        time_G = 0;
        time_M = 0;
        for repeat = 1 : MAXREPEAT
            users = randomSetWorkers(station_loc(1:k,:), numWorkers, 1); % could test several times for the random user distribution
            tic;
            [assignment_G_one_round, cost_G_one_round] = greedySearch(users, positive, negative);
            time_G_one_round = toc;
            tic;
            [assignment_M_one_round, cost_M_one_round] = twoRoundMatching(users, positive, negative);
            time_M_one_round = toc;
            cost_G = cost_G + cost_G_one_round/MAXREPEAT;
            cost_M = cost_M + cost_M_one_round/MAXREPEAT;
            time_G = time_G + time_G_one_round/MAXREPEAT;
            time_M = time_M + time_M_one_round/MAXREPEAT;
        end
        accumulate_G = accumulate_G + cost_G; % no need to calculate average
        accumulate_M = accumulate_M + cost_M;
        accumulateTime_G = accumulateTime_G + time_G;
        accumulateTime_M = accumulateTime_M + time_M;
    end
    costList_1GA_G(index) = accumulate_G;
    costList_1GA_M(index) = accumulate_M;
    timeList_1GA_G(index) = accumulateTime_G;
    timeList_1GA_M(index) = accumulateTime_M;
    % Experiment 3 where targers are generated by 2GA
    accumulate_G = 0;
    accumulate_M = 0;
    accumulateTime_G = 0;
    accumulateTime_M = 0;
    for ga2_i = 1:size(positive_2ga_mul,2)
        numWorkers = abs(sum(positive_2ga_mul(:,ga2_i)));
        if numWorkers==0
            continue;
        end
        positive = [station_loc(1:i,:), abs(positive_2ga_mul(:,ga2_i))];
        negative = [station_loc(1:i,:), abs(negative_2ga_mul(:,ga2_i))];
%         positive = positive(positive(:,3)~=0,:);
%         negative = negative(negative(:,3)~=0,:);        
        cost_G = 0;
        cost_M = 0;
        time_G = 0;
        time_M = 0;
        for repeat = 1 : MAXREPEAT
            users = randomSetWorkers(station_loc(1:k,:), numWorkers, 1); % could test several times for the random user distribution
            tic;
            [assignment_G_one_round, cost_G_one_round] = greedySearch(users, positive, negative);
            time_G_one_round = toc;
            tic;
            [assignment_M_one_round, cost_M_one_round] = twoRoundMatching(users, positive, negative);
            time_M_one_round = toc;
            cost_G = cost_G + cost_G_one_round/MAXREPEAT;
            cost_M = cost_M + cost_M_one_round/MAXREPEAT;
            time_G = time_G + time_G_one_round/MAXREPEAT;
            time_M = time_M + time_M_one_round/MAXREPEAT;
        end
        accumulate_G = accumulate_G + cost_G; % no need to calculate average
        accumulate_M = accumulate_M + cost_M;
        accumulateTime_G = accumulateTime_G + time_G;
        accumulateTime_M = accumulateTime_M + time_M;
    end
    costList_2GA_G(index) = accumulate_G;
    costList_2GA_M(index) = accumulate_M;
    timeList_2GA_G(index) = accumulateTime_G;
    timeList_2GA_M(index) = accumulateTime_M;
    index = index+1;
    %disp(i);
    save('GvMoverSF_800m_20_uniform.mat');
end
end

function workers = randomSetWorkers(station_loc, numWorkers, type)
    workers = zeros(numWorkers,4);
    if (type==0)
        for i = 1:numWorkers
            workers(i,1:2) = station_loc(randi([1 size(station_loc,1)]),:);
            workers(i,3:4) = station_loc(randi([1 size(station_loc,1)]),:);
        end
        workers = workers + normrnd(0,0.003133,size(workers));
    else
        min_loc = min(station_loc) - [0.009, 0.009];
        max_loc = max(station_loc) + [0.009, 0.009];
        workers = [unifrnd(min_loc(1),max_loc(1),size(workers,1),1),...
                    unifrnd(min_loc(2),max_loc(2),size(workers,1),1),...
                    unifrnd(min_loc(1),max_loc(1),size(workers,1),1),...
                    unifrnd(min_loc(2),max_loc(2),size(workers,1),1)];
    end
end


