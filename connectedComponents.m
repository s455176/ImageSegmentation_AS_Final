function [superPixelComp, components] = connectedComponents(labelImage, superPixelNum)
	% ================================================================================
	% Pass through each pixel in the image if it is not processed. 
	% Reassign the unconnected cluster parts into a new component.
	% Also, the unassigned connected pixels will form a new component themselves.
	% Collect the components that belong to the same superpixel since there may be unconnected pixels
	% in the same superpixel.
	% ================================================================================
	
	booleanMap = zeros(size(labelImage));
	superPixelComp = cell(1, superPixelNum);
	components = cell(0);

	for i = 1:size(labelImage, 1)
		for j = 1:size(labelImage, 2)
			if(booleanMap(i, j) == 0)
				sp_label = labelImage(i, j);
				% handle the unassigned pixels (the pixels out of every blocks with size 2S * 2S)
				% such connected pixels form a new superpixel themselves
				if(sp_label == -1)
					superPixelComp{end + 1} = [];
					sp_label = size(superPixelComp, 2);
				end
				[booleanMap, components] = floodFill(booleanMap, components, labelImage, i, j);
				superPixelComp{sp_label} = [superPixelComp{sp_label}, size(components, 2)];
			end
		end
	end
end