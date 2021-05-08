function [constraints] = load_constraint_file(path)
    if isfile(path)
        % Load constraints.
        opts = detectImportOptions(path, 'FileType', 'text');
        opts.Delimiter = '\t';
        opts = setvartype(opts, {'Var_Index', 'Var_Coefficient', 'Constant'}, {'string', 'string', 'double'});
        constraints = readtable(path, opts); 
        constraints.Var_Index = cellfun(@(x) textscan(x, '%f', 'Delimiter', ','), constraints.Var_Index, 'UniformOutput', false);
        constraints.Var_Coefficient = cellfun(@(x) textscan(x, '%f', 'Delimiter', ','), constraints.Var_Coefficient, 'UniformOutput', false);
    else 
        constraints = table();
        constraints.Var_Index = zeros(0);
        constraints.Var_Coefficient = zeros(0);
        constraints.Constant = zeros(0);
    end
end

