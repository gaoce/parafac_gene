function main()

% Get data [time x gene x samples]
[data, geneNames, fileNames] = importData;

% Check data validity
if isempty(data)
    return
end

% Get pftest parameters
prompt = {'Number of Iterations:','Max Component Number:'};
dlg_title = 'Parameters';
num_lines = 1;
def = {'5', '5'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

maxIter = str2double(answer{1});  %#ok<NASGU>
maxComp = str2double(answer{2});  %#ok<NASGU>

% pftest, evalc is used to capture the screen output
evalc('pftest(maxIter, data, maxComp,[0 0 0 0 NaN])');

tHandle = gcf;
movegui(tHandle, 'center');

% Get a success signal
msg = sprintf('Test completed! Close Images?');
waitfor(msgbox(msg));
close(tHandle);

% Get real component number
answer = inputdlg({'Number of Components:'}, 'Input', 1, {'5'});
numComp = str2double(answer{1});

% Conduct Parafac
factsCP = parafac(data, numComp, [0 0 0 0 NaN]);


% Export data
% Get output dir
outPath = uigetdir(pwd, 'Selection Output Location');
if outPath == 0
    waitfor(msgbox('Invalid path!'));
    return
end

for i = 1:numComp
    % Create dir if not exists
    newDir = ['comp', num2str(i)];
    if exist([outPath,'/', newDir], 'dir') ~= 7
        mkdir(outPath, newDir);
    end
    
    % Get tensor data
    nFac = length(factsCP);  % num of experiment factors
    facs = cell(1, nFac);
    for j = 1:nFac
        facs{j} = factsCP{j}(:, i);
    end
    
    comp = nmodel(facs);
    exportComp(comp, geneNames, fileNames, [outPath,'/', newDir]);
end

% Export experimental factor levels
newDir = 'Factors';
if exist([outPath,'/', newDir], 'dir') ~= 7
    mkdir(outPath, newDir);
end

[nTime, ~, ~] = size(data);
time_strs = cell(1, nTime);
for i = 1:nTime
    time_strs{i} = num2str(i);
end
levels = {time_strs, geneNames, fileNames};


level_names = {'time', 'gene', 'sample'};
for j = 1:nFac
    comp = factsCP{j};
    exportFacs(comp, levels{j}, level_names{j}, [outPath,'/', newDir]);
end

waitfor(msgbox('Export Complete!'));

end