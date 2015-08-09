function output = histogramEqualization(image)
	output = zeros(size(image));
	for channel = 1:3
		origin_image = image(:, :, channel);
		hist_num = zeros(1, 255 + 1);
		
		for row = 1:size(origin_image, 1)
			for col = 1:size(origin_image, 2)
				hist_num(origin_image(row, col) + 1) = hist_num(origin_image(row, col) + 1) + 1;
			end
		end
		
		% equalization
		map = zeros(1, 255 + 1);
		acc = 0;
		for i = 1:255 + 1
			acc = acc + hist_num(i);
			map(i) = round(255 * acc / (size(origin_image, 1) * size(origin_image, 2)));
		end

		for row = 1:size(origin_image, 1)
			for col = 1:size(origin_image, 2)
				result_image(row, col) = map(origin_image(row, col) + 1);
			end
		end
		output(:, :, channel) = result_image;
	end
	output = uint8(output);
end






