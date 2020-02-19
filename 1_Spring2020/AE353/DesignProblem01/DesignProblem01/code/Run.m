% Run DesignProblem00 with paramters set
tStop = 10;     % Time stop
q1 = 2;         % Initial x location
q2 = 0;         % Initial y location
q3 = .5;        % Initial rotation in radians
dataname = 'data.mat';
csvname = 'data.csv';

% Run design problem
DesignProblem01('Controller','tstop',tStop,'initial',[z_0; zdot_0],'datafile',dataname, 'diagnostics',true)

% 'display' = false

% Save datafile to a csv file
FileData = load(dataname);
csvwrite(csvname, FileData.M);