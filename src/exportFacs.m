function exportFacs(facs, levels, level_name, path)

fid = fopen([path, '/', level_name, '.tsv'], 'w');

[nLevels, nComps] = size(facs);

headerComp = cell(1, nComps);
for i = 1:nComps
    headerComp{i} = ['\tComp_', num2str(i)];
end
header = [level_name, headerComp{:}, '\n'];
fprintf(fid, header);

% Content
contentFmt = ['%s\t', repmat('%f\t', 1, nComps-1), '%f\n'];
for i = 1:nLevels
    fprintf(fid, contentFmt, levels{i}, facs(i, :));
end

fclose(fid);
end