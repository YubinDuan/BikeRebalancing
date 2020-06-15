function clawList = findClawList(G);
%output: the center of each claw is not included in the output
n = size(G,1);
clawList = [];
% find 1-claw
for i = 1 : n
    clawList = [clawList; [i,0,0,0]];
end;
% find 2-claw
twoClawList = []; % used for find 3-claw
for i = 1 : n
    for j = i+1 : n
        if (G(i,j)==0)
            for k = 1 : n
                if (G(i,k)==1)&&(G(j,k)==1)
                    clawList = [clawList; [i,j,0,k]];
                    twoClawList = [twoClawList; [i,j,k]];
                end
            end
        end
    end
end
% find 3-claw
for i = 1 : size(twoClawList,1)
    for j = i+1 : size(twoClawList,1)
        twoClaw1 = twoClawList(i,1:2);
        center1 = twoClawList(i,3);
        twoClaw2 = twoClawList(j,1:2);
        center2 = twoClawList(j,3);
        temp = union(twoClaw1,twoClaw2);
        %independent = false;
        center = intersect(center1,center2);
        if (size(temp,2) == 3)&&(size(center,2)==1)
            if (G(temp(1),temp(2))==0) && (G(temp(1),temp(3))==0) && (G(temp(2),temp(3))==0)
                clawList = [clawList; [temp, center]];
            end     
        end
    end
end
clawList = clawList(:,1:3);
clawList = unique(clawList,'rows');
end