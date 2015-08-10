image = imread('../3096.jpg');

image = histogramEqualization(image);

disp('histogramEqualization Finish!');

image = superpixelSegmentation(image, 20, 80, 30, 10);
