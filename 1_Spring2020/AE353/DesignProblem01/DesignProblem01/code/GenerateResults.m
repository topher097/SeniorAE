clc;
clear;

% Run DesignProblem01 with paramters set
tStop = 10;      % Time stop
q1 = 2;         % Initial z location
q2 = 2;         % Initial x location
q3 = -.3;        % Initial rotation in radians
qdot1 = .5;      % Initial z velocity
qdot2 = -.1;      % Initial x velocity
qdot3 = -.1;      % Initial rotational velocity
dataname = 'data.mat';
dataname_ni = 'data_no_input.mat';
csvname = 'data.csv';
csvname_ni = 'data_no_input.csv';

% Run design problem (State Feedback)
DesignProblem01('Controller','tstop',tStop,'initial',[q1; q2; q3; qdot1; qdot2; qdot3],'datafile',dataname,'diagnostics',true)

% Get data from run
FileData = load(dataname);
t = FileData.controllerdata.sensors.t;
q1 = FileData.controllerdata.sensors.q1;
q2 = FileData.controllerdata.sensors.q2;
q3 = FileData.controllerdata.sensors.q3;
q1dot = FileData.controllerdata.sensors.q1dot;
q2dot = FileData.controllerdata.sensors.q2dot;
q3dot = FileData.controllerdata.sensors.q3dot;
fL = FileData.controllerdata.actuators.fL;
fR = FileData.controllerdata.actuators.fR;

% Run design problem (State Feedback)
DesignProblem01('Controller_NoInput','tstop',tStop,'initial',[q1; q2; q3; qdot1; qdot2; qdot3],'datafile',dataname_ni)

% Get data from run
FileData = load(dataname_ni);
t_ni = FileData.controllerdata.sensors.t;
q1_ni = FileData.controllerdata.sensors.q1;
q2_ni = FileData.controllerdata.sensors.q2;
q3_ni = FileData.controllerdata.sensors.q3;
q1dot_ni = FileData.controllerdata.sensors.q1dot;
q2dot_ni = FileData.controllerdata.sensors.q2dot;
q3dot_ni = FileData.controllerdata.sensors.q3dot;
fL_ni = FileData.controllerdata.actuators.fL;
fR_ni = FileData.controllerdata.actuators.fR;

% Plot the data from state-feedback and no-input runs
plt.figure(1)


% Save datafile to a csv file
data_write = [t; q1; q2 ; q3; q1dot; q2dot; q3dot; fL; fR]';
cHeader = {'time (s)' 'q1' 'q2' 'q3' 'q1dot' 'd2dot' 'q3dot' 'fL' 'fR'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
% write header to file
fid = fopen(csvname,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data to end of file
dlmwrite(csvname, data_write, '-append');
disp('Finished Iteration')