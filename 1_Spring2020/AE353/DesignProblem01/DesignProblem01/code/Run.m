% Run DesignProblem01 with paramters set
tStop = .5;      % Time stop
q1 = 2;         % Initial z location
q2 = 0;         % Initial x location
q3 = .5;        % Initial rotation in radians
qdot1 = 0;      % Initial z velocity
qdot2 = 0;      % Initial x velocity
qdot3 = 0;      % Initial rotational velocity
dataname = 'data.mat';
csvname = 'data.csv';

% Run design problem
DesignProblem01('Controller','tstop',tStop,'initial',[q1; q2; q3; qdot1; qdot2; qdot3],'datafile',dataname,'diagnostics',true)

% 'display' = false

% Save datafile to a csv file
FileData = load(dataname);
data_write = [FileData.controllerdata.sensors.t;
              FileData.controllerdata.sensors.q1;
              FileData.controllerdata.sensors.q2;
              FileData.controllerdata.sensors.q3;
              FileData.controllerdata.sensors.q1dot;
              FileData.controllerdata.sensors.q2dot;
              FileData.controllerdata.sensors.q3dot;
              FileData.controllerdata.actuators.fL;
              FileData.controllerdata.actuators.fR]';
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