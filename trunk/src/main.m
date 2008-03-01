% A program to process a folder of images of cars with
% visible license plates. Outputs statistics of the job
% On what percentage of the images were plates found?
% What percentage of plates were read correctly?
% What percentage of identified characters were read correctly?

% Last 7 characters before file extension must be correct license
% plate for image.   


% imagesFolder = Path to folder with images 
function [] = main(imagesFolder, numberOfImagesToProcess)


% Setup variables
% noOfImages = 0;
percentageOfPlatesFound = 0;
percentageOfPlatesRead = 0;
percentageOfCharsRead = 0;

% Get filelist
fileList = dir([imagesFolder '*.jpg']);
noOfImages = length(fileList);


if noOfImages < 1 
  'No images found. Aborting.'
else
  ['Going to work on' noOfImages ' images.']
end

for i = 1:noOfImages
  % FIND PLATE
  % [imagesFolder fileList(i).name]
  % SomeFunction([imagesFolder fileList(i).name]);
  % ROTATE
  % SEGMENT CHARS
  % RECOGNIZE PATTERNS
end


% PRINT STATS