image = imread('../3096.jpg');

image = histogramEqualization(image);

disp('histogramEqualization Finish!');

[image, superPixelComp, components, label1, label2] = superpixelSegmentation(image, 20, 80);

