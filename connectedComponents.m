function components = connectedComponents(labelImage)
	booleanMap = zeros(size(labelImage));
	components = cell(0);
	
	% pass through each pixel in the image if it is not processed
	for i = 1:size(labelImage, 1)
		for j = 1:size(labelImage, 2)
			if(booleanMap(i, j) == 0)
				[booleanMap, components] = floodFill(booleanMap, components, labelImage, i, j);
			end
		end
	end
end