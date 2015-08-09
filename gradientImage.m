function output = gradientImage(image)
	x_dir = [-1; 0; 1];
	y_dir = [-1, 0, 1];
	total = double(image(:, :, 1)) + double(image(:, :, 2)) + double(image(:, :, 3));
	X = conv2(total, x_dir);
	Y = conv2(total, y_dir);
	X = X(2:end - 1, :);
	Y = Y(:, 2:end - 1);
	output = sqrt(X.^2 + Y.^2);
end