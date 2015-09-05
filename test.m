image = imread('../3096.jpg');
origin_image = image;

% image = histogramEqualization(image);
% disp('histogramEqualization Finish!');

[image, components, label] = superpixelSegmentation(image, 40, 60, 5, 5);

figure(1);
RGB = label2rgb(label, 'jet', 'w', 'shuffle');
subplot(1, 2, 1);
imshow(image);
subplot(1, 2, 2);
imshow(RGB);

[components, label, V, W, D] = NCutSegmentation(origin_image, components, 15, 10, 50);


%{
% show the segmentation 
superpixel_image = origin_image;
for i = 1:size(label2, 1)
	for j = 1:size(label2, 2)
		cur_label = label2(i, j);
		if(checkBound(label2, i - 1, j) == 1 & label2(i - 1, j) ~= cur_label)
			superpixel_image(i, j, 1) = 255;
			superpixel_image(i, j, 2) = 255;
			superpixel_image(i, j, 3) = 0;
		elseif(checkBound(label2, i + 1, j) == 1 & label2(i + 1, j) ~= cur_label)
			superpixel_image(i, j, 1) = 255;
			superpixel_image(i, j, 2) = 255;
			superpixel_image(i, j, 3) = 0;
		elseif(checkBound(label2, i, j - 1) == 1 & label2(i, j - 1) ~= cur_label)
			superpixel_image(i, j, 1) = 255;
			superpixel_image(i, j, 2) = 255;
			superpixel_image(i, j, 3) = 0;
		elseif(checkBound(label2, i, j + 1) == 1 & label2(i, j + 1) ~= cur_label)
			superpixel_image(i, j, 1) = 255;
			superpixel_image(i, j, 2) = 255;
			superpixel_image(i, j, 3) = 0;
		end
	end
end

tic;
b = [];
for i = 1:size(components, 2)
	if(size(components{i}, 1) > 0)
		b = [b; bwboundaries(label2 == i)];
	end
end
disp('find the boundaries of each label');
toc;

imshow(origin_image);
hold on;
for k = 1:numel(b)
    plot(b{k}(:,2), b{k}(:,1), 'r', 'Linewidth', 3)
end
%}