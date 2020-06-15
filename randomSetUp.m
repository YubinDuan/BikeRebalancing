%% Generate Random User/Location/Demand Information
% n is the #users, m is #stations
function [users, positive, negative] = randomSetUp(n,m,randomType_u, randomType_s, randomType_d)
users = random(randomType_u,10,20,[n 4]);
% generate positive station locations
positive = random(randomType_s, 10, 20, [m 2]);
% generate positive demands (make sure demands sum up to n)
demands_p = zeros(m, 1);
lastDemand = -1;
while (lastDemand <= 0)
    demands_p(1:m-1, 1) = round(random(randomType_d, 0, 2*n/m, [m-1, 1]));
    lastDemand = n - sum(demands_p);
end;
demands_p(m, 1) = lastDemand;
positive = [positive, demands_p];
%% Negative locations
% generate negative station locations
negative = random(randomType_s, 10, 20, [m 2]);
% generate positive demands (make sure demands sum up to n)
demands = zeros(m, 1);
lastDemand = -1;
while (lastDemand <= 0)
    demands(1:m-1, 1) = round(random(randomType_d, 0, 2*n/m, [m-1, 1]));
    lastDemand = n - sum(demands);
end;
demands(m, 1) = lastDemand;
negative = [negative, demands];