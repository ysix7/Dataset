function [curr_dat_sz, curr_lab_sz] = store2hdf5(filename, data1, data2, data3, label1, label2, create, startloc, chunksz)

  % verify that format is right
  dat_dims=size(data1);
  lab_dims=size(label1);
  num_samples=dat_dims(end);

  assert(lab_dims(end)==num_samples, 'Number of samples should be matched between data and labels');
  
  if ~exist('create','var')
    create=true;
  end

  
  if create
    %fprintf('Creating dataset with %d samples\n', num_samples);
    if ~exist('chunksz', 'var')
      chunksz=1000;
    end
    if exist(filename, 'file')
      fprintf('Warning: replacing existing file %s \n', filename);
      delete(filename);
    end      
    h5create(filename, '/data_15', [dat_dims(1:end-1) Inf], 'Datatype', 'single', 'ChunkSize', [dat_dims(1:end-1) chunksz]); % width, height, channels, number 
    h5create(filename, '/data_35', [dat_dims(1:end-1) Inf], 'Datatype', 'single', 'ChunkSize', [dat_dims(1:end-1) chunksz]); % width, height, channels, number  
    h5create(filename, '/data_50', [dat_dims(1:end-1) Inf], 'Datatype', 'single', 'ChunkSize', [dat_dims(1:end-1) chunksz]); % width, height, channels, number
    h5create(filename, '/label_edge', [lab_dims(1:end-1) Inf], 'Datatype', 'single', 'ChunkSize', [lab_dims(1:end-1) chunksz]); % width, height, channels, number
    h5create(filename, '/label_strong', [lab_dims(1:end-1) Inf], 'Datatype', 'single', 'ChunkSize', [lab_dims(1:end-1) chunksz]); % width, height, channels, number
    
    if ~exist('startloc','var') 
      startloc.dat=[ones(1,length(dat_dims)-1), 1];
      startloc.lab=[ones(1,length(lab_dims)-1), 1];
    end 
  else  % append mode
    if ~exist('startloc','var')
      info=h5info(filename);
      prev_dat_sz=info.Datasets(1).Dataspace.Size;
      prev_lab_sz=info.Datasets(2).Dataspace.Size;
      assert(prev_dat_sz(1:end-1)==dat_dims(1:end-1), 'Data dimensions must match existing dimensions in dataset');
      assert(prev_lab_sz(1:end-1)==lab_dims(1:end-1), 'Data dimensions must match existing dimensions in dataset');
      startloc.dat=[ones(1,length(dat_dims)-1), prev_dat_sz(end)+1];
      startloc.lab=[ones(1,length(lab_dims)-1), prev_lab_sz(end)+1];
    end
  end

  if ~isempty(data1)
    h5write(filename, '/data_15', single(data1), startloc.dat, size(data1));
    h5write(filename, '/data_35', single(data2), startloc.dat, size(data2));
    h5write(filename, '/data_50', single(data3), startloc.dat, size(data3));
    h5write(filename, '/label_edge', single(label1), startloc.lab, size(label1));
    h5write(filename, '/label_strong', single(label2), startloc.lab, size(label2));
    
  end

  if nargout
    info=h5info(filename);
    curr_dat_sz=info.Datasets(1).Dataspace.Size;
    curr_lab_sz=info.Datasets(2).Dataspace.Size;
  end
end
