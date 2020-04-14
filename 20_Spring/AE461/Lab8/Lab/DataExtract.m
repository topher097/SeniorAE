clc;
clear all;
load('GroupP.mat')
FileData = load('GroupP.mat');

theta_list = FileData.freq_750;
theta1_list = FileData.freq_1000;
theta2_list = FileData.initialpidresponse;
theta3_list = FileData.integralwindupresponse;

theta_t = theta_list(:,1)';
theta_a = theta_list(:,2)';
theta_r = theta_list(:,3)';
theta1_t = theta1_list(:,1)';
theta1_a = theta1_list(:,2)';
theta1_r = theta_list(:,3)';
theta2_t = theta2_list(:,1)';
theta2_a = theta2_list(:,2)';
theta3_t = theta3_list(:,1)';
theta3_a = theta3_list(:,2)';

% Create lists for csv files
b_theta_t = theta_t(1:10);
b_theta_a = theta_a(1:10);
e_theta_t = theta_t(end-9:end);
e_theta_a = theta_a(end-9:end);
b_theta_r = theta_r(1:10);
e_theta_r = theta_r(end-9:end);
b_theta1_t = theta1_t(1:10);
b_theta1_a = theta1_a(1:10);
e_theta1_t = theta1_t(end-9:end);
e_theta1_a = theta1_a(end-9:end);
b_theta1_r = theta1_r(1:10);
e_theta1_r = theta1_r(end-9:end);
e_theta_a = theta_a(end-9:end);
b_theta2_t = theta2_t(1:10);
b_theta2_a = theta2_a(1:10);
e_theta2_t = theta2_t(end-9:end);
e_theta2_a = theta2_a(end-9:end);
e_theta_a = theta_a(end-9:end);
b_theta3_t = theta3_t(1:10);
b_theta3_a = theta3_a(1:10);
e_theta3_t = theta3_t(end-9:end);
e_theta3_a = theta3_a(end-9:end);

% Combine the lits
w_theta_t = [b_theta_t e_theta_t];
w_theta_a = [b_theta_a e_theta_a];
w_theta_r = [b_theta_r e_theta_r];
w_theta1_t = [b_theta1_t e_theta1_t];
w_theta1_a = [b_theta1_a e_theta1_a];
w_theta1_r = [b_theta1_r e_theta1_r];
w_theta2_t = [b_theta2_t e_theta2_t];
w_theta2_a = [b_theta2_a e_theta2_a];
w_theta3_t = [b_theta3_t e_theta3_t];
w_theta3_a = [b_theta3_a e_theta3_a];


% Save data to csv files
csvname = 'Lab7_Data_nostep.csv';
data_write = [w_theta_t; w_theta_a; w_theta_r]';
cHeader = {'Time (s)' 'Radian' 'Radian'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
% write header to file
fid = fopen(csvname,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data to end of file
dlmwrite(csvname, data_write, '-append');

csvname = 'Lab7_Data_step1.csv';
data_write = [w_theta1_t; w_theta1_a; w_theta1_r]';
cHeader = {'Time (s)' 'Radian' 'Radian'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
% write header to file
fid = fopen(csvname,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data to end of file
dlmwrite(csvname, data_write, '-append');

csvname = 'Lab7_Data_step2.csv';
data_write = [w_theta2_t; w_theta2_a]';
cHeader = {'time (s)' 'theta (rad)'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
% write header to file
fid = fopen(csvname,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data to end of file
dlmwrite(csvname, data_write, '-append');

csvname = 'Lab7_Data_step3.csv';
data_write = [w_theta3_t; w_theta3_a]';
cHeader = {'time (s)' 'theta (rad)'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
% write header to file
fid = fopen(csvname,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data to end of file
dlmwrite(csvname, data_write, '-append');




