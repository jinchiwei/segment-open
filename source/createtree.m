function [s,z,dirs] = createtree(pathname,ext)
%CREATETREE(PATHNAME,EXT) Finds all files in the input directory.
%
%Input: 
%- pathname
%- extention (for instance '.mat' '.dcm'). Optional argument.
%
%Output:
%- s list of fullfilenames as cell array
%- z list of size of each file [OPTIONAL]
%- dirs list of folders [OPTIONAL]

if nargin<2
  ext = [];
end

%Handle the case when called with empty extension
if isempty(ext)
  ext = '*';
else
  ext = ['*',ext];
end

%Extract the list using dir command
f = dir([pathname filesep '**' filesep ext]); %example f = dir('C:/DATA/**/*.dcm') returns dcm files

%Create full path. cat(1,{ffolder} converts to cell array and then use
%strcat to concatenate the strings
if isempty(f)
  s = {};
  z = [];
  return
end

%remove directory pointers
f = f(~[f.isdir]);
if isempty(f)
  s = {};
  z = [];
  return
end

s = strcat(cat(1,{f.folder}),repmat({filesep},1,length(f)),cat(1,{f.name}));

%Extract size
if nargout>1
  z = cat(1,f.bytes);
end

%Extract list of folders
if nargout>2
  dirs = union(cat(1,{f.folder}),{}); %union sorts and removes duplicates
end

%-----------OLD CODE ---------------
%function [s,z,dirs] = createtree(pathname,s,z,dirs,ext)
%CREATETREE Finds all files in the input directory.
%
%Input: 
%- pathname
%- extention (for instance '.mat' '.dcm'). Optional argument.

%Output:
%- cell array of full filenames to files
%- z size of the files.
%- dirs cell array of paths

%Creates a path tree (s), and sizes of files z

%Check for optional calling syntax

% if nargin<5
%   if nargin<2
%     ext = [];
%   else
%     ext = s; %Optional calling is createtree(pathname,ext)
%   end
% end
% 
% if nargin<3
%   s = {};
%   z = [];
%   dirs = {};
%   levelone = true;
% else
%   levelone = false;
% end
% 
% f=dir(pathname);
% 
% if levelone
%   h = waitbar(0,'Locating files.');
% end
% 
% for loop = 1:length(f)
%   if f(loop).isdir
%     switch f(loop).name
%       case '.'
%       case '..'
%       otherwise
%         %disp(sprintf('Parsed Directory %s%s%s.',pathname,filesep,f(loop).name))
%         [s,z,dirs] = createtree([pathname filesep f(loop).name],s,z,dirs,ext);
%         dirs = [dirs {[pathname filesep f(loop).name]}];
%     end
%   else
%     %disp(sprintf('add %s.',f(loop).name));    
%     if ~isempty(ext)
%       l = length(f(loop).name); 
%       p = find(f(loop).name=='.');
%       if (l>4) && (~isempty(p))
%         if isequal(f(loop).name(p(end):l),ext)
%           s = [s {[pathname filesep f(loop).name]}];
%           z = [z f(loop).bytes];
%         end
%       end
%     else
%       %extenstion is empty => add allways
%       s = [s {[pathname filesep f(loop).name]}];
%       z = [z f(loop).bytes];
%     end
%   end  
%   
%   if levelone
%     h = waitbar(loop/length(f),h);% Changed by Klas to waitbar instead of waitbarupdate.
%   end
% end
% 
% if levelone
%   close(h);
% end
% 
