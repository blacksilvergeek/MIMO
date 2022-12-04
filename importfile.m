function importfile(fileToRead1)
%IMPORTFILE(FILETOREAD1)
%  import matrix from file
%  FILETOREAD1:  filename as a string


% import file
newData1 = load(fileToRead1,'-mat');

% create corresponding varible
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

