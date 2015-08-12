function [spatialMean, colorMean, neighbor] = findCompProp(labImage, components, labelImage, index, opt)
	if(nargin < 5)
		opt = 'all';
	end
	neighbor = [];
	cur_label = labelImage(components{index}(1, 1), components{index}(1, 2));
	spatialMean = zeros(1, 2);
	colorMean = zeros(1, 3);
	compSize = size(components{index}, 1);
	needMean = 0;
	needNeighbor = 0;
	
	if(strcmp('mean', opt) == 1)
		needMean = 1;
	elseif(strcmp('neighbor', opt) == 1)
		needNeighbor = 1;
	elseif(strcmp('all', opt) == 1)
		needMean = 1;
		needNeighbor = 1;
	else
		error(['ERROR: no option', ' "', opt, '" !']);
	end
	
	for i = 1:compSize
		row = components{index}(i, 1);
		col = components{index}(i, 2);
		
		if(needMean == 1)
			colorPt = [double(labImage(row, col, 1)), double(labImage(row, col, 2)), double(labImage(row, col, 3))];
			spatialPt = [row, col];
			
			spatialMean = spatialMean + spatialPt;
			colorMean = colorMean + colorPt;
		end
		
		if(needNeighbor == 1)
			if(checkBound(labelImage, row - 1, col) == 1 & labelImage(row - 1, col) ~= cur_label & sum(neighbor == labelImage(row - 1, col)) == 0)
				neighbor = [neighbor, labelImage(row - 1, col)];
			end
			if(checkBound(labelImage, row + 1, col) == 1 & labelImage(row + 1, col) ~= cur_label & sum(neighbor == labelImage(row + 1, col)) == 0)
				neighbor = [neighbor, labelImage(row + 1, col)];
			end
			if(checkBound(labelImage, row, col - 1) == 1 & labelImage(row, col - 1) ~= cur_label & sum(neighbor == labelImage(row, col - 1)) == 0)
				neighbor = [neighbor, labelImage(row, col - 1)];
			end
			if(checkBound(labelImage, row, col + 1) == 1 & labelImage(row, col + 1) ~= cur_label & sum(neighbor == labelImage(row, col + 1)) == 0)
				neighbor = [neighbor, labelImage(row, col + 1)];
			end
		end
	end
	
	if(needMean == 1)
		spatialMean = spatialMean / compSize;
		colorMean = colorMean / compSize;
	end
end



