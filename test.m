image = imread('3096.jpg');

image = histogramEqualization(image);

disp('histogramEqualization Finish!');

imshow(image);