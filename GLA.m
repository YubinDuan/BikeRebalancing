function [positive, negative, k] = GLA(initialState, capacity, demands)
% demands is a n by k matrix: n rows represent demand of n stations; k
% columes represent demand of following k timeslots.
k = size(demands, 2) + 1;
feasible = 0;
while (feasible  == 0)
    k = k-1;
    [positive, negative, feasible] = kGA(initialState, capacity, demands(:,1:k));
end