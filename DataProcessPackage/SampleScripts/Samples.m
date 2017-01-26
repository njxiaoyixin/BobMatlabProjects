% 1. Download data from remote FTP and translate data into the data type that
% we want
% 1) Download Bloomberg 1-minuete-bar Data from the other computer with BBG on it.
S_DownloadFTPData('DataProvider','Wind','InputType','Tick','OutputType','Tick','InputFileType','csv','OutputFileType','mat');
% 2) Download Wind-Tick-Data from the other computer with Wind on it.
S_DownloadFTPData('DataProvider','Bloomberg','InputType','Bar','OutputType','Bar','InputFileType','csv','OutputFileType','mat');

%% 2. Update Data from Data Provider
% 1) Update Tick Data from Wind with Folders by Day and overwrite current
% data
S_UpdateLocalData('DataProvider','Wind','InputType','Tick',...
    'OutputType','Tick','InputFileType','csv','OutputFileType','mat',...
    'TransformData',true,'ByDay',true,'Overwrite',true);
% 2) Update Daily Data from Wind with Folders by Day and overwrite current
% data
S_UpdateLocalData('DataProvider','Wind','InputType','Daily',...
    'OutputType','Daily','InputFileType','csv','OutputFileType','mat',...
    'TransformData',true,'ByDay',true,'Overwrite',false);
% 3) Update Daily Data from Wind with Folders in a single Day and do not 
% overwrite current data
S_UpdateLocalData('DataProvider','Wind','InputType','Daily',...
    'OutputType','Daily','InputFileType','csv','OutputFileType','mat',...
    'TransformData',true,'ByDay',false,'Overwrite',true);
% 4) Update Bar Data From Bloomberg with Folders in a Single Day and do not
% overwrite current data, and do not translate data from csv into mat
S_UpdateLocalData('DataProvider','Bloomberg','InputType','Bar',...
    'OutputType','Bar','InputFileType','csv','OutputFileType','csv',...
    'TransformData',false,'ByDay',true,'Overwrite',false);
% 5) Update Bar Data From Bloomberg with Folders in a Single Day and do not
% overwrite current data, and do not translate data from csv into mat, Do
% it at Night!
S_UpdateLocalData('DataProvider','Bloomberg','InputType','Bar',...
    'OutputType','Bar','InputFileType','csv','OutputFileType','csv',...
    'TransformData',false,'ByDay',true,'Overwrite',false,'isNight',true);
% 6) Update EDU Data from Wind with Folders by Day and overwrite current
% data
S_UpdateLocalData('DataProvider','Wind','InputType','EDB',...
    'OutputType','EDB','InputFileType','csv','OutputFileType','mat',...
    'TransformData',true,'ByDay',true,'Overwrite',false);
% 7) Update EDU Data from Wind with Folders in a single Day and do  
% overwrite current data
S_UpdateLocalData('DataProvider','Wind','InputType','EDB',...
    'OutputType','EDB','InputFileType','csv','OutputFileType','mat',...
    'TransformData',true,'ByDay',false,'Overwrite',false);

%% Retrieve Local Data of a Product to Desired Folder
% 1)Retrieve data to single folders(saved on a daily basis)

% 2)Concat the same contracts from Target Folder of the DIVIDED function
% Note: TargetFolder is the Data source of this function

%% Data Process
% 1) Retrieve Local Daily Data, Calculate the Active Contracts and
% Construct Px and ActivePx

% 2) Using Px to Retrieve Higher Frequency Local Data from 'HFDataSource'

%% Functions
