%% Greedy Search Algorithm
%WARING: Positive and negative has different meaning in paper!
%positive in the program means the negative in the paper
%NOTE: the distance is mapped to the real distance in the map (i.e.
%/180*pi*6371)
function [assignment, cost] = greedySearch2(users, positive, negative)
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
    end
%   check if the # of users is large enough to cover all demands
    userAmount = size(users,1);
    if (userAmount < min(sumPositive, sumNegative))
        deleteStationStrategy(); % DELETE some staion, since # of users is not enough.
    elseif (userAmount > min(sumPositive, sumNegative))
        userAmount = min(sumPositive, sumNegative);
        deleteUserStrategy();
    end
    

%% Greedy
largeNumber = 10^4;
users=users(randperm(size(users,1)),:);
workerNeeded = size(extendedPositive,1);
cost = 0;
assignment = zeros(workerNeeded,8);
for i = 1 : workerNeeded
    user = users(i,:);
    [min_positive_dis, min_positive_id] = min(distance(user(1:2),extendedPositive));
    positive_station = extendedPositive(min_positive_id,:);
    extendedPositive = [extendedPositive(1:min_positive_id-1,:);extendedPositive(min_positive_id+1:end,:)];
    [min_negative_dis, min_negative_id] = min(distance(user(3:4),extendedNegative));
    negative_station = extendedNegative(min_negative_id,:);
    extendedNegative = [extendedNegative(1:min_negative_id-1,:);extendedNegative(min_negative_id+1:end,:)];
    cost = cost + min_positive_dis + min_negative_dis + distance(positive_station,negative_station);
    assignment(i,:) = [user, positive_station, negative_station];
end
cost = cost/180*pi*6371;
%nodeValue = largeNumber - nodeValue; %Change nodeValue, turn minimum find problem into maximum finding problem

end

%% Extend ([x,y,n] -> n lines of [x,y,1])
function extendedMatrix = extend(matrix)
    extendedMatrix = zeros(sum(matrix(:,3)),2);
    nextRow = 1;
    for i = 1 : size(matrix,1)
        for j = 1 : matrix(i,3)
            extendedMatrix(nextRow,:) = matrix(i,1:2);
            nextRow = nextRow + 1; 
        end
    end
end
%% Delete station strategy
function deleteStaionStrategy()
end
function deleteUserStrategy()
end

%% Convert combination to index (coding user-P-N conbination)
% UserIndex is the highest position
% UserIndex range from 1 to n
% Output index range from 1 to n^3
function index = convertC2I(uIndex, nIndex, pIndex, n)
    uIndex = uIndex - 1;
    nIndex = nIndex - 1;
    pIndex = pIndex - 1;
    index = uIndex*n^2 + nIndex*n + pIndex;
    index = index + 1; %adjust ouput index range
end
%% Covert index to user-P-N combination (decoding)
% Input: index (at most n^3)
function [uIndex, nIndex, pIndex] = covertI2C(index, n)
    index = index-1;
    pIndex = mod(index,n)+1;
    index = fix(index/n);
    nIndex = mod(index,n)+1;
    uIndex = fix(index/n)+1;
end
    
%% N funtion in paper "A d/2 approximation for maximum weight independent set in d-claw free graphs"
function overlapSet = N(K,L,Map)
    overlapSet = [];
    L = L(find(L~=0));
    K = K(find(K~=0));
    for i = 1 : size(L,1)
        for j = 1 : size(K,1)
            if (Map(L(i),K(j))==1)
                overlapSet = [overlapSet; L(i)];
                break;
            elseif (L(i)==K(j))
                overlapSet = [overlapSet; L(i)];
                break;
            end
        end
    end         
end