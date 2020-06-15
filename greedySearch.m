%% Greedy Search Algorithm
%WARING: Positive and negative has different meaning in paper!
%positive in the program means the negative in the paper
%NOTE: the distance is mapped to the real distance in the map (i.e.
%/180*pi*6371)
function [assignment, cost] = greedySearch(users, positive, negative)
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
    
%% Local Search (need to make sure size of extendedPositive, extendedNegative and users are the same.)
%   Construct intersection graph
n = size(users, 1);
nodeValue = zeros(n^3,1);
for userIndex = 1 : n
    for negativeIndex = 1 : n
        for positiveIndex = 1 : n
            nodeValue(convertC2I(userIndex,negativeIndex,positiveIndex,n)) = ...
                distance(users(userIndex,1:2), extendedPositive(positiveIndex,:)) ...
                + distance(extendedPositive(positiveIndex,:), extendedNegative(negativeIndex,:)) ...
                + distance(extendedNegative(negativeIndex,:), users(userIndex,3:4));
        end
    end
end
nodeValue = nodeValue/180*pi*6371;

IntersectionMap = zeros(n^3,n^3);
for i = 1 : n^3
    for j = i+1 : n^3
        [u_i,n_i,p_i] = covertI2C(i,n);
        [u_j,n_j,p_j] = covertI2C(j,n);
        if ((u_i==u_j) || (n_i==n_j) || (p_i==p_j))
            IntersectionMap(i,j) = 1;
            IntersectionMap(j,i) = 1;
        end
    end
end

%% Greedy
largeNumber = 10^4;
nodeValue = largeNumber - nodeValue; %Change nodeValue, turn minimum find problem into maximum finding problem
A = []; 
V = zeros(n^3,1);
for i = 1 : n^3
    V(i) = i;
end
while (size(setdiff(V, N(A,V,IntersectionMap)),1) ~= 0 && size(setdiff(V, N(A,V,IntersectionMap)),2) ~= 0)
    diffSet = setdiff(V, N(A,V,IntersectionMap));
    diffSetValue = nodeValue(diffSet);
    MaxU = diffSet(find(diffSetValue == max(diffSetValue)));
    A = [A; MaxU(1)];
end

% Decoding and find out assignment
assignment = zeros(size(A,1),3);
for i = 1 : size(A,1)
    [assignment(i,1),assignment(i,2),assignment(i,3)] = covertI2C(A(i),n);
end
nodeValue = largeNumber - nodeValue;
cost = sum(nodeValue(A));
%% Find claw in the graph

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