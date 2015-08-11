image = imread('../3096.jpg');

image = histogramEqualization(image);

disp('histogramEqualization Finish!');

[image, components] = superpixelSegmentation(image, 20, 80, 30, 10);
