classdef cfg_class < matlab.System 
  properties
    %% class
    class       = 'cfg'
    note        = ''
    %% features
    sav_cfg_en  = true % sav cfg as txt file
    %% configs --->> write to other modules
    TID         = '_test_'
    brief       = '' % test brief 
    projDir     =  pwd 
    outDir      = [pwd '/out']   
    datDir      = '~/data'   
    ttag        % test tag [TID]_[btype]_[bnum]% dset
    toutDir     % outDir+ttag
    % dataset 
    btype       = 'dlo_shape_control'
    bnum        = nan % btype subset
    st_frame    = nan % start frame index
    end_frame   = nan % end frame index
    %% private
    dat  
  end
  methods  % constructor
    function obj = cfg_class(varargin)
      setProperties(obj,nargin,varargin{:}) % init obj w name-value args
      addpath(genpath('./'));
      init(obj);
    end
  end 
  methods (Access = private)
  
    function init(obj)
      if strcmp(obj.btype, "_no_btype_")              % get test tag and toutDir
        fprintf("[config]->> cfg.btype is empty: %s",obj.btype);
        error("_no_btype_");
      elseif isnan(obj.bnum) 
        obj.ttag  = strcat(obj.TID,'_',obj.btype);
      else
        obj.ttag  = strcat(obj.TID,'_',obj.btype,'_',num2str(obj.bnum,'%03.f'));
      end      
      obj.ttag = strrep(obj.ttag,' ','_');
      %obj.ttag = strrep(obj.ttag,'-','_');
      obj.toutDir = strcat(obj.outDir,'/',obj.ttag,'/');

      if not(isfolder(obj.toutDir))                          % create toutDir
        disp("[config]->> test_toutDir does NOT exist: ");
        disp(obj.toutDir);
        mkdir(obj.toutDir);
        disp("[config]->> directory was created!");
      else 
        disp("[config]->> test_toutDir exists and will be removed: ");
        disp(obj.toutDir);
        rmdir(obj.toutDir, 's');
        mkdir(obj.toutDir);
        disp("[config]->> directory is created!");
      end 
      
      obj.load_dat(); % load data
      obj.sav_cfg(); % sav cfg to file
    end

    function load_dat(obj)
      if strcmp(obj.btype, "dlo_shape_control") 
        obj.dat = dlo_dat(); obj.dat.load_cfg(obj); % ----------------------- dlo
      elseif strcmp(obj.btype, "dp")
        obj.dat = dp_dat(); obj.dat.load_cfg(obj); % ------------------------- dp
      elseif strcmp(obj.btype, "vtol") 
        obj.dat = vtol_dat(); obj.dat.load_cfg(obj); % --------------------- vtol
      end
      obj.st_frame = obj.dat.st_frame;
      obj.end_frame = obj.dat.end_frame;
    end

    function sav_cfg(obj)
      if ~isempty(obj.brief) || obj.sav_cfg_en
        fname = strcat(obj.toutDir,"cfg.txt"); 
        file = fopen(fname,"wt");
        fprintf(file, strcat("TID:      ", obj.TID, "\n"));
        fprintf(file, strcat("brief:    ", obj.brief, "\n"));
        fprintf(file, strcat("projDir:  ", obj.projDir, "\n"));
        fprintf(file, strcat("outDir:   ", obj.outDir, "\n"));
        fprintf(file, strcat("datDir:   ", obj.datDir, "\n"));
        fprintf(file, strcat("ttag:     ", obj.ttag, "\n"));
        fprintf(file, strcat("toutDir:  ", obj.toutDir, "\n"));
        fprintf(file, strcat("btype:    ", obj.btype, "\n"));
        fprintf(file, strcat("bnum:     ", num2str(obj.bnum), "\n"));
        fprintf(file, strcat("st_frame: ", num2str(obj.st_frame), "\n"));
        fprintf(file, strcat("end_frame:", num2str(obj.end_frame),"\n"));
        fclose(file);
      end
    end
  end % methods (Access = private)
end
