function [positive_mul, negative_mul, feasible] = kGA_multiRound(initialState, capacity, demands, k)
% Input: capacity should be colume vector; demands should be a matrix
% demands is a n by m matrix: n rows represent demand of n stations; m
% columes represent demand of following m timeslots.
% finalState: assume the rebalance is done as target configuration
timeslots = size(demands,2);
timeslotIndex = 1;
demands_k = demands(:,timeslotIndex:timeslotIndex+k-1);
timeslotIndex = timeslotIndex+k;
[positive, negative, feasible] = kGA(initialState, capacity, demands_k);
% display(positive')
% display(negative')
% display(sum([zeros(size(demands_k,1),1),demands_k]'))
finalState = initialState + positive + negative + sum([zeros(size(demands_k,1),1),demands_k]')';
if feasible==0
        return
end
positive_mul = [positive];
negative_mul = [negative];
while timeslotIndex<=timeslots
    initialState = finalState;
    demands_k = demands(:,timeslotIndex:timeslotIndex+k-1);
    timeslotIndex = timeslotIndex+k;
    [positive, negative, feasible] = kGA(initialState, capacity, demands_k);
%      display(positive')
%      display(negative')
%      display(sum([zeros(size(demands_k,1),1),demands_k]'))
    finalState = initialState + positive + negative +  sum([zeros(size(demands_k,1),1),demands_k]')';
    if feasible==0
        demands_k
        timeslotIndex
        return 
    end
    positive_mul = [positive_mul, positive];
    negative_mul = [negative_mul, negative];
end
