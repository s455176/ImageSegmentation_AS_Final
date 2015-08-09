function output = superpixelSegmentation(image, k1, k2, m, threshold)
	if(nargin < 4)
		m = 10;
		threshold = 10;
	end
	S_row = floor(size(image, 1) / k1)
	S_col = floor(size(image, 2) / k2)
	avg_S = sqrt(S_row * S_col);
	C = [];
	label = ones(size(image, 1), size(image, 2)) * (-1);
	distance = ones(size(image, 1), size(image, 2)) * inf;
	count = 0;
	
	output = image; %%
	
	% convert from rgb color space to lab space
	CT = makecform('srgb2lab');
	lab = applycform(image, CT);
	
	% put samples on the grid
	for i = 1:S_row:size(image, 1)
		for j = 1:S_col:size(image, 2)
			C = [C; double(lab(i, j, 1)), double(lab(i, j, 2)), double(lab(i, j, 3)), i, j];
			count = count + 1;
		end
	end
	
	% avoid put sample centers on the edges
	gradient = ones(size(image, 1) + 2, size(image, 2) + 2) * inf;
	gradient(2:end - 1, 2:end - 1) = gradientImage(image);
	
	% move the centers to the min gradient in the 3 * 3 patch 
	for i = 1:size(C, 1)
		index_x = C(i, 4) + 1;
		index_y = C(i, 5) + 1;
		patch = gradient(index_x - 1:index_x + 1, index_y - 1: index_y + 1);
		[temp, index] = min(reshape(patch, [1, 9]));
		t_x = (mod(index - 1, 3) + 1) - 2 + C(i, 4);
		t_y = (floor((index - 1) / 3) + 1) - 2 + C(i, 5);
		C(i, :) = [double(lab(t_x, t_y, 1)), double(lab(t_x, t_y, 2)), double(lab(t_x, t_y, 3)), t_x, t_y];
		output(C(i, 4), C(i, 5), 1) = 255; %%
		output(C(i, 4), C(i, 5), 2) = 255; %%
		output(C(i, 4), C(i, 5), 3) = 255; %%
	end
	
	% start Simple linear iterative clustering Algorithm
	E = inf;
	E_old = inf;
	tic;
	while(E > threshold)
		% find the nearest center and assign the pixel to its cluster
		for k = 1:size(C, 1)
			for row = floor(C(k, 4) - S_row):ceil(C(k, 4) + S_row)
				for col = floor(C(k, 5) - S_col):ceil(C(k, 5) + S_col)
					if(checkBound(lab, row, col) == 1)
						cur_pixel = [double(lab(row, col, 1)), double(lab(row, col, 2)), double(lab(row, col, 3)), row, col];
						D = calDistance(C(k, :), cur_pixel, avg_S, m);
						if(D < distance(row, col))
							distance(row, col) = D;
							label(row, col) = k;
						end
					end
				end
			end
		end
		% calculate the new centers among each cluster
		cluster_center = zeros(size(C));
		cluster_count = zeros(1, size(C, 1));
		for row = 1:size(label, 1)
			for col = 1:size(label, 2)
				cluster_center(label(row, col), :) = cluster_center(label(row, col), :) + [double(lab(row, col, 1)), double(lab(row, col, 2)), double(lab(row, col, 3)), row, col];
				cluster_count(label(row, col)) = cluster_count(label(row, col)) + 1;
			end
		end
		for k = 1:size(C, 1)
			C(k, :) = cluster_center(k, :) / cluster_count(k);
		end
		% calculate the error
		E_new = 0;
		for row = 1:size(label, 1)
			for col = 1:size(label, 2)
				cur_pixel = [double(lab(row, col, 1)), double(lab(row, col, 2)), double(lab(row, col, 3)), row, col];
				E_new = E_new + norm(C(label(row, col), :) - cur_pixel)^2 / 10;
			end
		end
		E_new = (E_new / (size(label, 1) * size(label, 2))) * 10;
		E = E_old - E_new
		E_old = E_new;
	end
	
	% some post processing to ensure connectivity
	
	
	figure(1);
	RGB = label2rgb(label, 'jet', 'w', 'shuffle');
	subplot(1, 2, 1);
	imshow(image);
	subplot(1, 2, 2);
	imshow(RGB);
	
	disp('superpixelSegmentation Finish!');
	toc;
end





