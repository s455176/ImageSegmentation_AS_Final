function [componentsOut, label, V, W, D] = NCutSegmentation(image, componentsIn, sigmaI, sigmaX, r)
	V = cell(0);
	componentsOut = componentsIn;
	label = zeros(size(image));
	
	% each superpixel is regarded as a vertex in graph G = (V, E)
	tic;
	for i = 1:size(componentsOut, 2)
		if(size(componentsOut{i}, 1) == 0)
			continue;
		else
			spatial_mean = zeros(1, 2); % (x, y)
			color_mean = zeros(1, 3); % (r, g, b)
			for j = 1:size(componentsOut{i}, 1)
				row = componentsOut{i}(j, 1);
				col = componentsOut{i}(j, 2);
				spatial_mean = spatial_mean + [row, col];
				color_mean = color_mean + double([image(row, col, 1), image(row, col, 2), image(row, col, 3)]);
			end
			V{end + 1}.spatial = spatial_mean / size(componentsOut{i}, 1);
			V{end}.color = color_mean / size(componentsOut{i}, 1);
			V{end}.index = i;
		end
	end
	disp('calculate V Finish!');
	toc;
	
	N = size(V, 2);
	
	% construct matrix W and D
	W = zeros(N, N);
	D = zeros(1, N);
	
	tic;
	for i = 1:N
		for j = i:N
			norm_X = norm(V{i}.spatial - V{j}.spatial);
			if(i ~= j & norm_X < r)
				norm_I = norm(V{i}.color - V{j}.color);
				W(i, j) = exp(-norm_I^2 / sigmaI^2) * exp(-norm_X^2 / sigmaX^2);
				W(j, i) = W(i, j);
			end
		end
	end
	
	for i = 1:N
		D(i) = sum(W(i, :));
	end
	disp('construct W and D matrix Finish!');
	toc;
end



















