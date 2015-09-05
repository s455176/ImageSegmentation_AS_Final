function [componentsOut, label, V] = NCutSegmentation(image, componentsIn, sigmaI, sigmaX, r)
	V = cell(0);
	componentsOut = componentsIn;
	label = zeros(size(image, 1), size(image, 2));
	
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
	D_diag = zeros(1, N);
	
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
		D_diag(i) = sum(W(i, :));
	end
	D = diag(D_diag);
	
	disp('construct W and D matrix Finish!');
	toc;
	
	[EigVec, EigVal] = eig(D - W, D);	
	EigVal = diag(EigVal);
	EigVec = EigVec(:, 2);
	
	splitPoint = findEigSplitPoint(EigVec);
	
	cluster = cell(2, 1);
	
	for i = 1:size(EigVec, 1)
		if(EigVec(i) > splitPoint)
			cluster{1} = [cluster{1}, i];
			cluster_index = 1;
		else
			cluster{2} = [cluster{2}, i];
			cluster_index = 2;
		end
		for j = 1:size(componentsOut{V{i}.index}, 1)
			row = componentsOut{V{i}.index}(j, 1);
			col = componentsOut{V{i}.index}(j, 2);
			label(row, col) = cluster_index;
		end
	end
	
end



















