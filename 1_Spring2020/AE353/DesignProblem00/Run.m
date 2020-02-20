% Run DesignProblem00 with paramters set
tStop = 10;
z_0 = 2;
zdot_0 = 0;
dataname = 'data.mat';

DesignProblem00('Controller','tstop',tStop,'initial',[z_0; zdot_0],'datafile',dataname)

