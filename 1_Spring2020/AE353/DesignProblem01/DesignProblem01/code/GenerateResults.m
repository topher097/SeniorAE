clc;
clear;

% Run 3 iterations
for i=1:3
    % Set paramters for simulation
    n = 8.*rand(1,1)-4;    % Random multiplication factor
    tStop = 8;             % Time stop
    q1 = .8*n;             % Initial z location
    q2 = -.8*n;            % Initial x location
    q3 = .1*n;             % Initial rotation in radians
    qdot1 = .1*n;          % Initial z velocity
    qdot2 = .2*n;          % Initial x velocity
    qdot3 = -.1*n;         % Initial rotational velocity
    initial = [round(q1,3); round(q2,3); round(q3,3); round(qdot1,3); round(qdot2,3); round(qdot3,3)];
    dataname = 'data.mat';
    dataname_ni = 'data_no_input.mat';
    csvname = 'data.csv';
    csvname_ni = 'data_no_input.csv';

    % Run design problem (State Feedback)
    DesignProblem01('Controller','tstop',tStop,'initial',initial,'datafile',dataname,'diagnostics',true,'display',false)

    % Run design problem (No Input)
    DesignProblem01('Controller_NoInput','tstop',tStop,'initial',initial,'datafile',dataname_ni,'display',false)

    % Get data from state feedback run
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
    %disp('Opened State Feedback data')

    % Get data from run (no input)
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
    %disp('Opened No Input data')

    % Plot the data from state-feedback and no-input runs
    %plt.figure(1)


    % Save state feedback data to a csv file
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

    % Save no input data to a csv file
    data_write = [t_ni; q1_ni; q2_ni ; q3_ni; q1dot_ni; q2dot_ni; q3dot_ni; fL_ni; fR_ni]';
    cHeader = {'time (s)' 'q1' 'q2' 'q3' 'q1dot' 'd2dot' 'q3dot' 'fL' 'fR'}; %dummy header
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    % write header to file
    fid = fopen(csvname_ni,'w'); 
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    % write data to end of file
    dlmwrite(csvname_ni, data_write, '-append');

    str = sprintf('Finished Iteration %.15g, Initial Conditions: %s', i, mat2str(initial));
    disp(str);
end