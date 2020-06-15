function GvBvM
% comparing Greedy, BranchBound and Matching
MAXREPEAT = 10;
costList_G = [];
costList_B = [];
costList_M = [];
timeList_G = [];
timeList_B = [];
timeList_M = [];
for i = 2 : 10
    accumulate_G = 0;
    accumulate_B = 0;
    accumulate_M = 0;
    accumulateTime_G = 0;
    accumulateTime_B = 0;
    accumulateTime_M = 0;
    for repeat = 1 : MAXREPEAT
        [users, positive, negative] = randomSetUp(i,i,'uniform','uniform','uniform');
        tic;
        [assignment_G, cost_G] = greedySearch(users, positive, negative);
        time_G = toc;
        tic;
        [assignment_B, cost_B] = branchBound(users, positive, negative);
        time_B = toc;
        tic;
        [assignment_M, cost_M] = twoRoundMatching(users, positive, negative);
        time_M = toc;
        accumulate_G = accumulate_G + cost_G;
        accumulate_B = accumulate_B + cost_B;
        accumulate_M = accumulate_M + cost_M;
        accumulateTime_G = accumulateTime_G + time_G;
        accumulateTime_B = accumulateTime_B + time_B;
        accumulateTime_M = accumulateTime_M + time_M;
    end;
    costList_G = [costList_G; accumulate_G/MAXREPEAT];
    costList_B = [costList_B; accumulate_B/MAXREPEAT];
    costList_M = [costList_M; accumulate_M/MAXREPEAT];
    timeList_G = [timeList_G; accumulateTime_G/MAXREPEAT];
    timeList_B = [timeList_B; accumulateTime_B/MAXREPEAT];
    timeList_M = [timeList_M; accumulateTime_M/MAXREPEAT];
    disp(i);
    save('GvBvM_test.mat');
end