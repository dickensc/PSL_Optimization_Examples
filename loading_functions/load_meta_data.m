function [meta_data] = load_meta_data(path)
    if isfile(path)
        % Load constraints.
        opts = detectImportOptions(path, 'FileType', 'text');
        opts.Delimiter = '\t';
        opts = setvartype(opts, {'Num_Variables'}, {'double'});
        meta_data = readtable(path, opts); 
    else 
        meta_data = table();
        meta_data.Num_Variables = zeros(0);
    end
end

