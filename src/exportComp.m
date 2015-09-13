function exportComp(data, geneNames, fileNames, path)
%% Export data file

[nTime, nGene, nSample] = size(data);

for i = 1:nSample
    % file names are also sample names
    fileName = fileNames{i};
    fid = fopen([path, '/component_', fileName, '.gct'], 'w');
    
    % Print header line
    fprintf(fid, '#1.2\n');
    fprintf(fid, '%d\t%d\n', nGene, nTime);
    headerFmt = ['NAME\tDescription\t', repmat('%d\t', 1, nTime-1), '%d\n'];
    fprintf(fid, headerFmt, 1:nTime);
    
    mat = squeeze(data(:, :, i));
    
    contentFmt = ['%s\tna\t', repmat('%f\t', 1, nTime-1), '%f\n'];
    for k = 1:nGene
        fprintf(fid, contentFmt, geneNames{k}, mat(:, k));
    end
    
    fclose(fid);
end

end