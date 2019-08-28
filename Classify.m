function class = Classify(ImageFile)
% Step 1: Read image Read in
RGB = imread(ImageFile);
figure,
imshow(RGB),
title('Original Image');
RGB = imresize(RGB,0.8);


% Step 2: Convert image from rgb to gray 
GRAY = rgb2gray(RGB);
figure,
imshow(GRAY),
title('Gray Image');

% Step 3: Threshold the black and white image
threshold = graythresh(GRAY); %mendapatkan level treshold
BW = im2bw(GRAY, threshold); %convert image ke binary berdasarkan treshold
BW2 = bwareaopen(BW, 64);

figure,
subplot(1,3,1),imshow(BW),
title(threshold);
subplot(1,3,2),imshow(BW2),
title('Binary Image');

% Step 4: Invert the Binary Image
BW = ~ BW2;
figure,
imshow(BW),
title('Inverted Binary Image');

% Step 5: Find the boundaries Concentrate only on the exterior boundaries.
% Option 'noholes' will accelerate the processing by preventing
% bwboundaries from searching for inner contours. 
[B,L,N] = bwboundaries(BW, 'noholes');

% Step 6: Determine objects properties
stats = regionprops(L, 'all'); % we need 'BoundingBox' and 'Extent'
Perimeter = cat(1,stats.Perimeter);
FilledArea = cat(1,stats.FilledArea);
CircleMetric = (Perimeter.^2)./(4*pi*FilledArea);
Circularities = (Perimeter).*(Perimeter);

% Step 7: Classify Shapes according to circle metric
figure,
imshow(RGB),impixelinfo,
title('Results');
hold on
%%Assign the shape
isCircle =   (CircleMetric < 1.2);
isSquare = ~isCircle & (CircleMetric < 1.5);
isRectangle = ~isCircle & ~isSquare;  %rectangle isn't any of these

%assign shape to each object
whichShape = cell(N,1);  
whichShape(isCircle) = {'Circle'};
whichShape(isSquare) = {'Square'};
whichShape(isRectangle)= {'Rectangle or Triangle'};


% Step 8: Calculate the color distance
%color distance
White = [255 255 255];
Black = [0 0 0];
Gray = [125 125 125];
Yellow = [255 255 0];
Blue = [0 0 255];
Red = [255 0 0];
Green = [0 255 0];
Pink = [186 85 211];

% Step 9 label the image with color and shape
for k = 1 :N    
    centroid = stats(k).Centroid;
    centroid(1) = ceil(centroid(1));
    centroid(2) = ceil(centroid(2));    
    
    R = RGB(centroid(2),centroid(1),1); 
    G = RGB(centroid(2),centroid(1),2); 
    B = RGB(centroid(2),centroid(1),3);
    
    distWhite = Euclidean(R,G,B,White(1),White(2),White(3));
    distBlack = Euclidean(R,G,B,Black(1),Black(2),Black(3));
    distGray = Euclidean(R,G,B,Gray(1),Gray(2),Gray(3));
    distYellow = Euclidean(R,G,B,Yellow(1),Yellow(2),Yellow(3));
    distBlue = Euclidean(R,G,B,Blue(1),Blue(2),Blue(3));
    distRed = Euclidean(R,G,B,Red(1),Red(2),Red(3));
    distGreen = Euclidean(R,G,B,Green(1),Green(2),Green(3));
    distPink = Euclidean(R,G,B,Pink(1),Pink(2),Pink(3));
    
    colorList = [distWhite, distBlack, distGray, distYellow, distBlue, distRed, distGreen, distPink];
    
    isWhite = (min(colorList) == distWhite);
    isBlack = (min(colorList) == distBlack);
    isGray = (min(colorList) == distGray);
    isYellow = (min(colorList) == distYellow);
    isBlue = (min(colorList) == distBlue);
    isRed = (min(colorList) == distRed);
    isGreen = (min(colorList) == distGreen);
    isPink = (min(colorList) == distPink);
    
    %Assign color to the each object
    whichColor = cell(N,1);
    whichColor(isWhite) = {'White'};
    whichColor(isBlack) = {'Black'};
    whichColor(isGray) = {'Gray'};
    whichColor(isYellow) = {'Yellow'};
    whichColor(isBlue) = {'Blue'};
    whichColor(isRed) = {'Red'};
    whichColor(isGreen) = {'Green'};
    whichColor(isPink) = {'Pink'};
    
    text( centroid(1)-45, centroid(2)-10, whichShape{k},'Color','m','FontSize',20);
    
    text( centroid(1)-25, centroid(2)+35, whichColor ,'Color','m','FontSize',20);
end
return