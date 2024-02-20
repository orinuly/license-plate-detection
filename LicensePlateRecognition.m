close all;

% Read the image
[file, path] = uigetfile({'*.jpg;*.bmp;*.png;*.tif'}, 'Choose an image');
s = [path, file];
img = imread(s);

% Convert the image to grayscale (if not already)
gray_img = rgb2gray(img);

% Adaptive thresholding
binary_mask = imbinarize(gray_img, adaptthresh(gray_img, 0.7));

% Display the original image and segmented regions
figure;
imshow(binary_mask)

% Interactively select a region of interest (ROI)
h = drawrectangle;
position = h.Position;
roi = round([position(1), position(2), position(3), position(4)]);

% Crop the binary mask based on the selected ROI
x = imcrop(binary_mask, roi);

% Convert the binary image to double for insertObjectAnnotation
x_double = double(x);

% Set the character set to include both letters and numbers
ocrOutput = ocr(x_double, 'TextLayout', 'Line', 'CharacterSet', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');

% Display the recognized text
disp('Recognized License Plate:');
disp(ocrOutput.Text);

% Display the annotated image
ocrImage = insertObjectAnnotation(x_double, 'rectangle', ocrOutput.WordBoundingBoxes, ...
    ocrOutput.WordConfidences);

figure;
imshow(ocrImage);
title('Recognized License Plate');
