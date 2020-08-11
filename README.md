# BikeRebalancing
Simulations of the paper entitled `Spatial-Temporal Inventory Rebalancing for Bike Sharing Systems with Worker Recruitment`

## Overview
Bike-sharing systems usually suffer from out-of-service events due to bike underflow or overflow. We propose to recruit workers to rebalance station loads. This repo contains the simulation of the rebalancing scheme proposed in the paper. 
To compare the performance of different algorithms proposed in the paper, please run `GvBvMvL.m`. 
To simulate the performance of our scheme on dockless systems, please run `GvMoverMobike.m` or `GvMoverSF.m`. It uses bike trace data obtained from Mobike and Kaggle. 
The simulation for cost-efficiency could be found at `GvMChangeWorkerSF.m`
