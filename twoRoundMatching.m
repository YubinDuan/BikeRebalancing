%% Two Round Matching algorithm
%WARING: Positive and negative has different meaning in paper!
%positive in the program means the negative in the paper
function [assignment, cost] = twoRoundMatching(users, positive, negative)

%% Initialization
%   extend positive and negative matrix
    extendedPositive = extend(positive);
    extendedNegative = extend(negative);
%   check the sum of positive and negative demands
    sumPositive = size(extendedPositive,1); %sum(positive(:,3));
    sumNegative = size(extendedNegative,1); %sum(negative(:,3));
    if (sumPositive ~= sumNegative)
        disp('Sum of positive and negative not equal.')
        deleteStationStrategy(); % DELETE EXCEEDING POSITVE OR NEGATIVE STATION.
    end;
%   check if the # of users is large enough to cover all demands
    userAmount = size(users,1);
    if (userAmount < min(sumPositive, sumNegative))
        deleteStationStrategy(); % DELETE some staion, since # of users is not enough.
    elseif (userAmount > min(sumPositive, sumNegative))
        userAmount = min(sumPositive, sumNegative);
        deleteUserStrategy();
    end;
%% Two round matching (need to make sure size of extendedPositive, extendedNegative and users are the same.)
%   Construct geometric station matching graph
    % positive nodes marked from 1 to n
    % negative nodes marked from n+1 to 2n
    m = size(users, 1);
    n = size(extendedPositive,1);
    nextLine = 1;
    edges_stations = zeros(n^2,3);
    for (i = 1 : n)
        for (j = 1 : n)
            edges_stations(nextLine, :) = [i, n+j, distance(extendedPositive(i,:),extendedNegative(j,:))/180*pi*6371];
            nextLine = nextLine + 1;
        end;
    end; 
%   Minimum weighted matching
    stationPair = minWeightMatching(edges_stations);
%   Construct user-station matchin graph
    nextLine = 1;
    edges_user_stations = zeros(n*m, 3);
    for (i = 1 : m)
        for (j = 1 : n)
            edges_user_stations(nextLine, :) = [i, j+m, ...    % means user i rent bike at station j return at stationPair(j)
                distance(users(i,1:2),extendedPositive(j,:))/180*pi*6371 ...
                + distance(extendedPositive(j,:), extendedNegative(stationPair(j)-n,:))/180*pi*6371 ...
                + distance(extendedNegative(stationPair(j)-n,:), users(i,3:4))/180*pi*6371];
            nextLine = nextLine + 1;
        end;
    end;
    %   Minimum weighted matching
    user_station_Pair = minWeightMatching(edges_user_stations);
%% Generate Output
    assignment = zeros(n, 3);
    cost = 0;
    for i = 1 : m
        if user_station_Pair(i)==-1
            continue
        end
        correspondingPositiveStation = user_station_Pair(i)-m;
        correspondingNegativeStation = stationPair(correspondingPositiveStation) - n;
        assignment(i, :) = [i, correspondingPositiveStation, correspondingNegativeStation];
        cost = cost + distance(users(i,1:2), extendedPositive(correspondingPositiveStation,:)) ...
                + distance(extendedPositive(correspondingPositiveStation,:), extendedNegative(correspondingNegativeStation,:)) ...
                + distance(extendedNegative(correspondingNegativeStation,:), users(i,3:4));
    end;
    cost = cost/180*pi*6371;
end
%% Delete station strategy
function deleteStaionStrategy()
end
function deleteUserStrategy()
end
%% Extend ([x,y,n] -> n lines of [x,y,1])
function extendedMatrix = extend(matrix)
    extendedMatrix = zeros(sum(matrix(:,3)),2);
    nextRow = 1;
    for i = 1 : size(matrix,1)
        for j = 1 : matrix(i,3)
            extendedMatrix(nextRow,:) = matrix(i,1:2);
            nextRow = nextRow + 1; 
        end;
    end;
end
%% minWeightMatching
    % Using maxWeighredMatching algorithm, only change edge value x -> Inf-x
    % Input: #edges x 3 matrix, representing edges and weight
    % Output: Matched elements found by the algorithm
    function result = minWeightMatching(edges)
        LargeNumber = 10^4;
        edges(:,3) = LargeNumber - edges(:,3);
        result = maxWeightMatching(edges);
    end