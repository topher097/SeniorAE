clc;
clear all;

load('GroupP-Lab5.mat')
FileData = load('GroupP-Lab5.mat');

list = FileData.data16;

freq = frequencydata(:,1);
var1 = list(:,1);
var2 = list(:,2);
var3 = list(:,3);
var4 = list(:,4);

vars = [freq var1 var2 var3 var4];
len = size(vars);
tmp_v = [];
for i = 1:len(2)
   tmp_a = vars(1:10,i);
   tmp_b = vars(end-9:end,i);
   tmp_v = [tmp_v vertcat(tmp_a, tmp_b)];   
end

% Save data to csv files
csvname = 'Lab5_Data16.csv';
data_write = tmp_v;
cHeader = {'freq' 'real' 'imag' 'amp' 'phase'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
% write header to file
fid = fopen(csvname,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data to end of file
dlmwrite(csvname, data_write, '-append');




