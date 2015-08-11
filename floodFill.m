function [booleanMapOut, componentsOut] = floodFill(booleanMapIn, componentsIn, labelImage, row_start, col_start)
	booleanMapOut = booleanMapIn;
	componentsOut = componentsIn;
	stack = zeros(0, 2);
	target_label = labelImage(row_start, col_start);
	componentsOut{end + 1} = [];

	% push the initial pt
	stack(end + 1, :) = [row_start, col_start]; 
	booleanMapOut(row_start, col_start) = 1;
	
	while(size(stack, 1) ~= 0)
		% pop the top element
		cur_pt = stack(end, :);
		stack(end, :) = [];
		row = cur_pt(1);
		col = cur_pt(2);
		
		% put the pixel into component
		componentsOut{end} = [componentsOut{end}; row, col];
		
		% push the up, down, left, right unprocessed and same label pixels and then remark the pixel will be processed
		if(checkBound(labelImage, row - 1, col) == 1 & booleanMapOut(row - 1, col) == 0 & labelImage(row - 1, col) == target_label)
			stack(end + 1, :) = [row - 1, col];
			booleanMapOut(row - 1, col) = 1;
		end
		if(checkBound(labelImage, row + 1, col) == 1 & booleanMapOut(row + 1, col) == 0 & labelImage(row + 1, col) == target_label)
			stack(end + 1, :) = [row + 1, col];
			booleanMapOut(row + 1, col) = 1;
		end
		if(checkBound(labelImage, row, col - 1) == 1 & booleanMapOut(row, col - 1) == 0 & labelImage(row, col - 1) == target_label)
			stack(end + 1, :) = [row, col - 1];
			booleanMapOut(row, col - 1) = 1;
		end
		if(checkBound(labelImage, row, col + 1) == 1 & booleanMapOut(row, col + 1) == 0 & labelImage(row, col + 1) == target_label)
			stack(end + 1, :) = [row, col + 1];
			booleanMapOut(row, col + 1) = 1;
		end
	end
end



