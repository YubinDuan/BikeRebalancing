function [positive, negative, feasible] = kGA(initialState, capacity, demands)
% Input: capacity should be colume vector; demands (return is positive) should be a matrix
% demands is a n by k matrix: n rows represent demand of n stations; k
% columes represent demand of following k timeslots.
% finalState: assume the rebalance is done as target configuration
n = size(demands, 1);
k = size(demands, 2);
feasible = 1;
storage = zeros(n,k+1);
storage(:,1) = initialState;
for t = 2 : k+1
    storage(:,t) = storage(:,t-1) + demands(:,t-1);
end

% docks = capacity - max(storage')';   % storing the minimal amount of docks available
% bikes = min(storage')';          % storing the minimal amount of bikes available

upperBound = capacity - max(storage')';   % the upper bound of bikes can be moved of each station
lowerBound = 0 - min(storage')';          % the lower bound 
% a upperbound > 0 means the station can cantain more bikes
% a upperbound < 0 means the station cannot cantain more bikes and need rebalance
% a lowerbound < 0 means the station has extra bikes to be removed
positive = upperBound;
positive(positive > 0) = 0;

negative = lowerBound;
negative(lowerBound < 0) = 0;

% positive and negative stores the number of bikes that has to be moved
% after setting positive and negative, the upperBound and lowerBound vector need update

upperBound = upperBound - positive - negative;
lowerBound = lowerBound - positive - negative;

diff = upperBound - lowerBound;
invalide = diff(diff < 0);
if (sum(invalide) < 0)
    feasible = 0;
    return;
    %error('cannot find proper target for following k slots, try to use smaller k.')
end

p_sum = sum(positive);
n_sum = sum(negative);

if (p_sum + n_sum > 0)  % sum of abs of negative is larger -> positive decrease
    while (p_sum + n_sum > 0)
        candidate = (lowerBound == min(lowerBound));
        if (sum(candidate) > 1)
            endState = storage(:, k+1) + positive + negative; % end state also need to be updated
            tieBreaker = endState.*candidate;
            candidate = find(tieBreaker == max(tieBreaker));
            if (size(candidate, 1) > 1)
                candidate = candidate(1);
            end
        else
            candidate = find(candidate == 1);
        end
        positive(candidate) = positive(candidate) - 1;
        % update the lowerBound and upperBound
        lowerBound(candidate) = lowerBound(candidate) + 1;
        upperBound(candidate) = upperBound(candidate) + 1;
        p_sum = sum(positive);
    end
elseif (p_sum + n_sum < 0)  %sum of abs of positive is larger -> negative increase
     while (p_sum + n_sum < 0)
        candidate = (upperBound == max(upperBound));
        if (sum(candidate) > 1)
            endState = storage(:, k+1) + positive + negative;
            tieBreaker = endState.*candidate;
            candidate = find(tieBreaker == min(tieBreaker));
            if (size(candidate, 1) > 1)
                candidate = candidate(1);
            end
        else
            candidate = find(candidate == 1);
        end
        negative(candidate) = negative(candidate) + 1;
        % update the lowerBound and upperBound
        lowerBound(candidate) = lowerBound(candidate) - 1;
        upperBound(candidate) = upperBound(candidate) - 1;
        n_sum = sum(negative);
     end
end
%finalState = initialState + sum(demands')' + positive + negative;
overall_target = positive + negative;
positive = zeros(size(positive));
negative = zeros(size(negative));
positive(overall_target<0) = overall_target(overall_target<0);
negative(overall_target>0) = overall_target(overall_target>0);
end




