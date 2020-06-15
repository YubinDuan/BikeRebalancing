%% Simple Greedy
function [assignment, lowest] = branchBound(users, positive, negative)
[assignment, cost] = greedySearch(users, positive, negative);
distanceC = pi*6371/180; % a constant that map to real distance
lowest = cost/distanceC; % store the current optimal (lowest) value

%% Initialization
%   extend positive and negative matrix
%   assume the sum of positive and negative demands is 0
    extendedPositive = extend(positive);
    extendedNegative = extend(negative);
    
%% Convert the input to intersection graph
%   Construct intersection graph (node weight doesn't map to real distance)
n = size(users, 1);
nodeWeight = zeros(n^3,1);
for userIndex = 1 : n
    for negativeIndex = 1 : n
        for positiveIndex = 1 : n
            nodeWeight(convertC2I(userIndex,negativeIndex,positiveIndex,n)) = ...
                distance(users(userIndex,1:2), extendedPositive(positiveIndex,:)) ...
                + distance(extendedPositive(positiveIndex,:), extendedNegative(negativeIndex,:)) ...
                + distance(extendedNegative(negativeIndex,:), users(userIndex,3:4));
        end
    end
end

%nodeWeight = nodeWeight/180*pi*6371;

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

%% Use Branch-and-Bound on the intersection graph
import java.util.LinkedList
q = LinkedList(); %Initialize the queue
q.add([]);
while (~q.isEmpty()) % Loop untile the queue is empty
    pickedNodes = q.remove();
    if (size(pickedNodes,1) == n) ...
            && (sum(nodeWeight(pickedNodes))<lowest)
        lowest = sum(nodeWeight(pickedNodes));
    else
        % branch the node (need to calculate the overlap nodes)
        V = [1:1:n^3]';
        overlap = N(pickedNodes, V, IntersectionMap);
        availableNodes = setdiff(V, overlap);
        % branch
        for (i = 1 : size(availableNodes,1)) % for every node not overlap with the current state
            addedOverlap = N(availableNodes(i),V,IntersectionMap);
            newOverlap = union(overlap, addedOverlap);
            LB = lowerBound([pickedNodes; availableNodes(i)], newOverlap, nodeWeight); % include the overlap nodes?
            if (LB < lowest) % If the lower bound is less than the lowest value then
                q.add([pickedNodes; availableNodes(i)]);
            end
        end
    end
end
lowest = lowest*distanceC; %map to real distance
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
%% Compute the lower bound of a state
function LB = lowerBound(localState, overlapSet, nodeWeight)
    % localState has to be a column vector
    V = [1:1:size(nodeWeight,1)]';  % The compelete set
    n = nthroot(size(nodeWeight,1),3); % the number of nodes that need to be chose
    lackNodes = n - size(localState,1); % the number of remainder nodes
%     overlapSet = N(localState, V, map); 
    diffSet = setdiff(V, overlapSet);   % the set of nodes that still can be chose
    localStateWeight = sum(nodeWeight(localState));
%     if (size(diffSet, 1) < lackNodes)   % the nodes is not enough to choose
%         error('No enough candidate to choose.');
%     else
%         tempNodeWeight = nodeWeight(diffSet);
%         tempNodeWeight = sort(tempNodeWeight, 'ascend');
%         LB = sum(tempNodeWeight(1:lackNodes));
%     end
    try
        tempNodeWeight = nodeWeight(diffSet);
        tempNodeWeight = sort(tempNodeWeight, 'ascend');
        LB = localStateWeight + sum(tempNodeWeight(1:lackNodes));
    catch
        error('No enough candidate to choose.');
    end
        
end
function overlapSet = N(K,L,Map)
    overlapSet = [];
    L = L(L~=0);
    K = K(K~=0);
    for i = 1 : max(size(L,1),size(L,2))
        for j = 1 : max(size(K,1),size(K,2))
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