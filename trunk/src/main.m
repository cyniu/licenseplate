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

% Add folder holding functions for plate detection
addpath('detection');
addpath('segmentation');
addpath('patternreg');

% noOfImages = 0;
noOfPlatesFound = 0;
noOfPlatesRead = 0;
percentageOfPlatesFound = 0;
percentageOfPlatesRead = 0;
percentageOfCharsRead = 0;
noOfChar1sRead = 0;
noOfChar2sRead = 0;
noOfChar3sRead = 0;
noOfChar4sRead = 0;
noOfChar5sRead = 0;
noOfChar6sRead = 0;
noOfChar7sRead = 0;
percentageOfChar1sRead = 0;
percentageOfChar2sRead = 0;
percentageOfChar3sRead = 0;
percentageOfChar4sRead = 0;
percentageOfChar5sRead = 0;
percentageOfChar6sRead = 0;
percentageOfChar7sRead = 0;

% for saving char images
charImgNo = 1;

% Number of times there weas no candidate

% For getting avg plateness
platenessSum = 0;
plateWidthSum = 0;

% Number of times there was no candidate
noCandidate = 0;

% Analyzing lengths of white lines in plates
shortestWhiteLine = inf;

% Minimal difference between max and min intensity in plates
%minIntDiff = inf;

% echo time
datestr(now)

% Get filelist
fileList = dir([imagesFolder '*.JPG']);
noOfImages = length(fileList);


if noOfImages < 1 
  'No images found. Aborting.'
else
  ['Going to work on ' int2str(noOfImages) ' images.']
end

% for histogram method
%olympusFile = load('/Users/epb/Documents/datalogi/3aar/bachelor/licenseplate/src/detection/freqTableOlympus.mat');
%canonFile = load('/Users/epb/Documents/datalogi/3aar/bachelor/licenseplate/src/detection/freqTableCanon.mat');
%freqTable = olympusFile.freqTableOlympus;
%freqTable = canonFile.freqTableCanon;
%horizontalTable = canonFile.horizontalTable;
%verticalTable = canonFile.verticalTable;

for i = 1:noOfImages
%for i = 1:1

  %%%%%%%%%%%%%%
  % FIND PLATE %
  %%%%%%%%%%%%%%

  ['Looking at image ' int2str(i) ' of ' int2str(noOfImages) '.' ]


  % Get plate coordinates from filename
  % xMin, xMax, yMin, yMax
  % Real Plate Coordinates = RPC
  RPC = [str2num(fileList(i).name(1,3:6)), str2num(fileList(i).name(1,8:11)), ...
                     str2num(fileList(i).name(1,13:16)), str2num(fileList(i).name(1,18:21))];
 
  
  % Calculate plateness for this plate
  %image = imresize(rgb2gray(imread([imagesFolder fileList(i).name])),0.25);
  %RPC = RPC * 0.25;
  %platenessSum = platenessSum + GetPlateness(GetSignature(image(RPC(3):RPC(4), RPC(1):RPC(2)), 0));
  %plateWidthSum = plateWidthSum + (RPC(2)-RPC(1)); 
  %plateCoords = [ 0 0 0 0 ];
  

  % Show plate
  % Read image from file
  %image = rgb2gray(imread([imagesFolder fileList(i).name]));
  %image = log10(double(image));
  %image = image(RPC(3)-30:RPC(4)+30, RPC(1)-30:RPC(2)+30);
  %image = imresize(image, 0.25);
  %[ below, above ] = GetDistribution(image)
  
  % Find shortest white line in plate
  %linePerc = GetLongestLine(image);
  %if linePerc < shortestWhiteLine
  %  shortestWhiteLine = linePerc
  %  beep;
  %  pause;
  %end


  % For testing:
  plateCoords = [0 0 0 0];


  %image = image(1:16,1:16);
  %figure(100), imshow(image);
  %figure(101), hist(double(image(:)),256);

  %thisIntDiff = max(max(image)) - min(min(image));  
  %if thisIntDiff < minIntDiff
  %  minIntDiff = thisIntDiff;
  %end



  % Analyze image and get coordinates of plate
  %plateCoords = detect_lines([imagesFolder fileList(i).name]);
 
  %plateCoords = detect2([imagesFolder fileList(i).name])
  %plateCoords = detect3([imagesFolder fileList(i).name])
 
  % High contrast
  % plateCoords = detect4([imagesFolder fileList(i).name])
   
  % plateCoords = histo_detect([imagesFolder fileList(i).name], freqTable);


  % Filter avg. intensity for neighbourhood 
  % 62.7/85.0 -> 63.9/90.6
  %plateCoords = DetectContrastAvg([imagesFolder fileList(i).name])

  % Besed on sameness 56.8/95.5 -> whiteline 56.6/95.8
  % plateCoords = DetectSameness([imagesFolder fileList(i).name])

  
  % Frequency analysis 50.5/65.5 -> whiteline 52.8/72.0
  % plateCoords = DetectPlateness([imagesFolder fileList(i).name]);

  % Contrast stretch on blocks
  % plateCoords = DetectCStretch([imagesFolder fileList(i).name]);

  % Distribution of intensities
  %plateCoords = DetectIntDist([imagesFolder fileList(i).name]);

  % 67.8/75.4 -> whiteline 73.5/85.4
  % plateCoords = DetectQuant([imagesFolder fileList(i).name]);



  %plateCoords = DetectNAME([imagesFolder fileList(i).name]);


  % All methods together
  % plateCoords = DetectMain([imagesFolder fileList(i).name]);

  % Determine if plate is within found coordinates 
  if (RPC(1) >= plateCoords(1) && RPC(2) <= plateCoords(2) && ...
   RPC(3) >= plateCoords(3) && RPC(4) <= plateCoords(4))
    noOfPlatesFound = noOfPlatesFound + 1;
    plateFound = true;
  else
    % Echo name of image where plate was not found
    ['Plate not found in ' fileList(i).name]
    plateFound = false;
    %beep 
    %pause(); % Pause when plate was not found 

    % No candidate was found
    if sum(plateCoords) == 0
      noCandidate = noCandidate + 1;
    end
  end   

  % For testing
  plateFound = true;
  
  % only try to rotate, segment and read plate if candidate was correct
  if plateFound
    
    % For testing:
    plateCoords(1) = RPC(1) - 15;
    plateCoords(2) = RPC(2) + 15;
    plateCoords(3) = RPC(3) - 15;
    plateCoords(4) = RPC(4) + 15;

    %%%%%%%%%%
    % ROTATE %
    %%%%%%%%%%

    [rotatedPlateImg, newPlateCoords] = plate_rotate_radon([imagesFolder fileList(i).name],plateCoords,false);
    %newPlateCoords
    
    %%%%%%%%%%%%%%%%%
    % SEGMENT CHARS %
    %%%%%%%%%%%%%%%%%

    foundChars = 0;
    [chars, charCoords, foundChars] = char_segment_cc(rotatedPlateImg,newPlateCoords,false);
    %[chars, charCoords, foundChars] = char_segment_ptv(rotatedPlateImg,newPlateCoords,true);
    %charCoords
    %%%%%% Determine if found chars contains coordinates of real chars. %%%%%
    %figure(19), imshow(imread([imagesFolder fileList(i).name]));

    noCharCandidate = 0;
    
    
    
    if foundChars == 7
      
      %{

      % OLD METHOD: CALCULATE CHAR COORDS
      % find vertical middle of plate and its length plus the width of a char
      plateMiddle = realPlateCoords(4) - ...
        (realPlateCoords(4) - realPlateCoords(3))/2;
      plateLength = realPlateCoords(2) - realPlateCoords(1);

      % set approximate char width and space widths. TO-DO!!
      relativeCharWidth = 1/8;
      relativeSmallSpace = 1/55;
      relativeLargeSpace = 2 * relativeSmallSpace;
      charWidth = relativeCharWidth * plateLength;
      smallSpace = relativeSmallSpace * plateLength;
      largeSpace = relativeLargeSpace * plateLength;

      % find real char coordinates
      realCharCoords = zeros(7,1); % plateMiddle is second coordinate
      %realCharCoords(:,2) = plateMiddle;

      realCharCoords(1) = realPlateCoords(1) + smallSpace + charWidth/2;
      for c = 2:7
        if c ~= 3 && c ~=5
          realCharCoords(c) = realCharCoords(c-1) + smallSpace + charWidth;
        else
          realCharCoords(c) = realCharCoords(c-1) + largeSpace + charWidth;
        end
      end

      % calculate char coordinates relative to entire image
      for k = 1:7
        charCoords(k,1:2) = charCoords(k,1:2) + plateCoords(1);
        charCoords(k,3:4) = charCoords(k,3:4) + plateCoords(3);
      end
      
      % calculate no. of correctly read chars
      charsRead = 0;
      for j = 1:7
        %if charCoords(j,1) <= realCharCoords(j) && ...
        %    charCoords(j,2) >= realCharCoords(j) && ...
        %    charCoords(j,3) <= plateMiddle && ...
        %    charCoords(j,4) >= plateMiddle
        charMiddle = [(charCoords(j,1)+charCoords(j,2))/2 (charCoords(j,3)+charCoords(j,4))/2];
        if charMiddle(1) >= realPlateCoords(1) && ...
           charMiddle(1) <= realPlateCoords(2) && ...
           charMiddle(2) >= realPlateCoords(3) && ...
           charMiddle(2) <= realPlateCoords(4)
          charsRead = charsRead + 1;

        end
      end
      
      %}
      
      % NEW METHOD: CHAR MIDDLES ARE SIMPLY WITHIN PLATE
      
      % calculate newRealPlateCoords
      if plateCoords(1) ~= newPlateCoords(1) || ...
          plateCoords(2) ~= newPlateCoords(2) || ...
          plateCoords(3) ~= newPlateCoords(3) || ...
          plateCoords(4) ~= newPlateCoords(4)
        coordDif = newPlateCoords - plateCoords;
        newRealPlateCoords = RPC + coordDif;
      else
        newRealPlateCoords = RPC;
      end
      
      charsRead = 0;
      for c = 1:7
        charMiddle = [round((charCoords(c,1)+charCoords(c,2))/2), ...
          round((charCoords(c,3)+charCoords(c,4))/2)];
        if charMiddle(1) >= newRealPlateCoords(1) && ...
            charMiddle(1) <= newRealPlateCoords(2) && ...
            charMiddle(2) >= newRealPlateCoords(3) && ...
            charMiddle(2) <= newRealPlateCoords(4)
          charsRead = charsRead + 1;
          
          %if c < 7
          %  round((charCoords(c+1,1)+charCoords(c+1,2))/2) - ...
          %  charMiddle(1)
          %end
          
        end
      end

      % determine if the plate is correctly read
      if charsRead == 7
        noOfPlatesRead = noOfPlatesRead + 1;
        
        % for pattern recognition: save images
        %for n = 1:7
        %  charName = strcat('char',int2str(n));
        %  posFolderName = strcat('pos',int2str(n));
        %  imgName = strcat(imagesFolder, ...
        %    posFolderName,'/',int2str(charImgNo),'.PNG');
        %  imwrite (chars.(charName),imgName,'png','BitDepth',1);
        %  charImgNo = charImgNo + 1;
        %end
        
      else
        ['Plate not read in ' fileList(i).name]
        %pause();
      end
    else
      ['Plate not read in ' fileList(i).name]
      noCharCandidate = noCharCandidate + 1;
      %pause();
    end

    %%%%%%%%%%%%%%%%%%%%%%
    % RECOGNIZE PATTERNS %
    %%%%%%%%%%%%%%%%%%%%%%
    
    plateAsString = '';
    if foundChars == 7 && charsRead == 7
      [L1Chars, L2Chars, N1Chars, N2Chars, N3Chars, N4Chars, N5Chars] = ...
        ReadPlateFV(chars,5,3);
      plateAsString = [L1Chars(1) L2Chars(1) N1Chars(1) N2Chars(1) ...
        N3Chars(1) N4Chars(1) N5Chars(1)]
    end

    % stats on reading of chars: first, best guess without syntax analysis
    if ~strcmp(plateAsString,'')

      realChars = [fileList(i).name(1,23), fileList(i).name(1,24), ...
        fileList(i).name(1,25), fileList(i).name(1,26), ...
        fileList(i).name(1,27), fileList(i).name(1,28), ...
        fileList(i).name(1,29)]

      if strcmp(plateAsString(1),realChars(1))
        noOfChar1sRead = noOfChar1sRead + 1;
      else
        pause;
      end
      if strcmp(plateAsString(2),realChars(2))
        noOfChar2sRead = noOfChar2sRead + 1;
      else
        pause;
      end
      if strcmp(plateAsString(3),realChars(3))
        noOfChar3sRead = noOfChar3sRead + 1;
      else
        pause;
      end
      if strcmp(plateAsString(4),realChars(4))
        noOfChar4sRead = noOfChar4sRead + 1;
      else
        pause;
      end
      if strcmp(plateAsString(5),realChars(5))
        noOfChar5sRead = noOfChar5sRead + 1;
      else
        pause;
      end
      if strcmp(plateAsString(6),realChars(6))
        noOfChar6sRead = noOfChar6sRead + 1;
      else
        pause;
      end
      if strcmp(plateAsString(7),realChars(7))
        noOfChar7sRead = noOfChar7sRead + 1;
      else
        pause;
      end
    end

  end % plateFound
  
  % Wait for user to press a key after every image
  %pause();
  
end % iterate through images

%%%%%%%%%%%%%%%
% PRINT STATS %
%%%%%%%%%%%%%%%

percentageOfPlatesFound = noOfPlatesFound*(100/noOfImages)

% What percentage of the candidates were correct
correctnessOfCandidates = noOfPlatesFound*(100/(noOfImages-noCandidate))

%noOfPlatesNotFound = noOfImages - noOfPlatesFound
%percentageOfPlatesRead = noOfPlatesRead*(100/noOfPlatesFound)
percentageOfPlatesRead = noOfPlatesRead*(100/noOfImages)

%correctnessOfPlatesRead = noOfPlatesRead*(100/(noOfPlatesFound-noCharCandidate))
correctnessOfPlatesRead = noOfPlatesRead*(100/(noOfImages-noCharCandidate))

%avgPlateness = round(platenessSum/noOfImages)
%avgPlatenessPixel = platenessSum/plateWidthSum    

% What was the shortest white line in a plate in percent
%shortestWhiteLine

%minIntDiff

if noOfPlatesRead == 0
  noOfPlatesRead = noOfImages
end
percentageOfChar1sRead = noOfChar1sRead*(100/(noOfPlatesRead))
percentageOfChar2sRead = noOfChar2sRead*(100/(noOfPlatesRead))
percentageOfChar3sRead = noOfChar3sRead*(100/(noOfPlatesRead))
percentageOfChar4sRead = noOfChar4sRead*(100/(noOfPlatesRead))
percentageOfChar5sRead = noOfChar5sRead*(100/(noOfPlatesRead))
percentageOfChar6sRead = noOfChar6sRead*(100/(noOfPlatesRead))
percentageOfChar7sRead = noOfChar7sRead*(100/(noOfPlatesRead))


% echo time
datestr(now)
