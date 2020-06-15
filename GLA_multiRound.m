function [positive_mul, negative_mul] = GLA_multiRound(initialState, capacity, demands)
% demands is a n by k matrix: n rows represent demand of n stations; k
% columes represent demand of following k timeslots.
k = size(demands, 2) + 1;
feasible = 0;
numSlots = size(demands,2);
slotIndex = 1;
while (feasible  == 0)
    k = k-1;
    [positive, negative, feasible] = kGA(initialState, capacity, demands(:,1:k));
end
positive_mul = positive;
negative_mul = negative;
demands_k = demands(:,1:k);
initialState = initialState + positive + negative + sum([zeros(size(demands_k,1),1),demands_k]')';
k
slotIndex = slotIndex + k;
while slotIndex<=numSlots
    k = numSlots-slotIndex+1+1;
    feasible = 0;
    while (feasible  == 0)
        k = k-1;
        if k==0
            feasible=0
            return
        end
        [positive, negative, feasible] = kGA(initialState, capacity, demands(:,slotIndex:slotIndex+k-1));
    end
    k
    positive_mul = [positive_mul, positive];
    negative_mul = [negative_mul, negative];
    demands_k = demands(:,slotIndex:slotIndex+k-1);
    initialState = initialState + positive + negative + sum([zeros(size(demands_k,1),1),demands_k]')';
    slotIndex = slotIndex + k;
end