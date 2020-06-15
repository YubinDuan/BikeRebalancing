function constractLookup(n);
tic;
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
clawList = findClawList(IntersectionMap);
saveFile = ['n=',int2str(n)];
runningTime = toc;
save(saveFile,'clawList','IntersectionMap','runningTime');
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
    