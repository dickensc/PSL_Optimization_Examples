function [potentials] = load_potential_file(path)
    if isfile(path) 
        % Load potentials.
        opts = detectImportOptions(path, 'FileType', 'text');
        opts.Delimiter = '\t';
        opts = setvartype(opts, {'Weight', 'Var_Index', 'Var_Coefficient', 'Constant'}, {'double', 'string', 'string', 'double'});
        potentials = readtable(path, opts); 
        potentials.Var_Index = cellfun(@(x) textscan(x, '%f', 'Delimiter', ','), potentials.Var_Index, 'UniformOutput', false);
        potentials.Var_Coefficient = cellfun(@(x) textscan(x, '%f', 'Delimiter', ','), potentials.Var_Coefficient, 'UniformOutput', false);
    else
        potentials = table();
        potentials.Weight = zeros(0);
        potentials.Var_Index = zeros(0);
        potentials.Var_Coefficient = zeros(0);
        potentials.Constant = zeros(0);
    end
end

