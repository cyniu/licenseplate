% Function to pick out the chars of a cut-out and rotated licenseplate.
% 
function [chars] = char_segment (img) 

  % transform image to binary and show the binary image, WHAT IS LEVEL 
  %level = graythresh(img);
  %level = 0.6;
  %bw_img = im2bw(img,level);
  bw_img = im2bw(img);
  
  % display binary image
  figure(100);
  subplot(2,1,1);
  imshow(bw_img);

  % calculate no. of scanlines
  h_scanlines = size(bw_img,1);
  
  % find the vertical middle of the image
  v_middle = floor(h_scanlines/2)

  % calculate the sums of all horizontal scanlines
  h_scanlines_sums = sum(bw_img,2);

  % find top- and bottom sums, NOT WORKING
  top_sums = h_scanlines_sums(1:v_middle,:);
  bottom_sums = h_scanlines_sums(v_middle:h_scanlines,:);
  [max_top,top_line] = max(top_sums);
  [max_bottom,bottom_line] = max(bottom_sums);
  bottom_line = bottom_line + v_middle;

  % fill out horizontal lines outside plate with 1's (white)
  for l = 1:top_line
    bw_img(l,:) = 1;
  end

  for l = bottom_line:size(bw_img,1)
    bw_img(l,:) = 1;
  end

  % display 'cut' image, everything above and below the plate should
  % now be white
  figure(100);
  subplot(2,1,2);
  imshow(bw_img);

  % calculate total no. of vertical scanlines and the pixel-sum of each line
  v_scanlines = size(bw_img,2);
  v_scanlines_sums = sum(bw_img,1);

  % there are 14 vertical cuts to be made, two for each of the seven chars
  cuts = zeros(14,1);

  % whether we are going towards a char
  to_char = true;

  cut = 1;
  char_width = 0;
  firstchar_met = false;
  min_char_width = 5;
  s = 1;

  % iterate through vertical scanlines
  while s < v_scanlines
    % if the vertical line is all white
    if v_scanlines_sums(s) == size(bw_img,1)
      firstchar_met = true;
      % position: in front of a char
      if to_char && v_scanlines_sums(s+1) < size(bw_img,1)
        cuts(cut) = s;
        cut = cut + 1;
      % position: at the end of a char
      elseif v_scanlines_sums(s+1) == size(bw_img,1) && char_width > min_char_width
        cuts(cut) = s;
        cut = cut + 1;
        char_width = 0;
      end
    % position: in a char
    elseif firstchar_met
      char_width = char_width + 1;
    end
    % iterate
    s = s + 1;
  end

  % ONLY RETURNING ONE CHAR
  %c = 1;
  %for c = 1:7
  chars = img(top_line:bottom_line,cuts(1):cuts(1+1));
  %end
  
return;
