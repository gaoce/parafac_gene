function [tensor, geneNames, fileNames] = importData
% Import data
% Returns:
%   data:  3D data matrix, size(data) = [nTime, nGene, nSampleple]

% Get gene names and gene expression data
[fileNames, pathName, ~] = uigetfile([pwd, '/.gct'], ...
    'Select GCT Files', 'MultiSelect', 'on');

geneNames = {};
for i = 1:length(fileNames)
    path = [pathName, '/', fileNames{i}];
    [names, tensor(:, :, i)] = gctReader(path); %#ok<AGROW>
    
    % Test if gene names are consistent
    if ~isempty(geneNames)
        if ~all(strcmp(geneNames, names))
            errordlg('Gene Names are not consistent');
            tensor = [];
            geneNames = {};
            % Terminate the function
            return
        else
            continue
        end
    else
        geneNames = names;
    end
end

end


function [geneNames, exp] = gctReader(path)
% Read .gct file, get gene expression matrix (gene x time)
% Returns
%   mat: matrix,(time x gene)

fd = fopen(path);

% Skip version line
fgetl(fd);

% Get gene number and time point number
C = textscan(fd, '%d\t%d');
nGene = C{1};
nTime = C{2};

% gene expression matrix
exp = zeros(nGene, nTime);

% gene name cells
geneNames = cell(nGene, 1);

% Skip the header line of the table
fgetl(fd);

% Count the number of tabs in title line, numEx = numTab - 1 + 1
fmtStr = ['%s\t%s\t', repmat('%f\t', 1, nTime-1), '%f\n'];

for i = 1:nGene
    C = textscan(fd, fmtStr);
    
    % Assign gene name
    geneNames{i} = C{1}{1};
    
    % Assign expression values
    exp(i, :) = [C{3:end}];
end

% Transpose the matrix
exp = exp';

end
