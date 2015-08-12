function [labelImageOut, componentsOut] = connCompPostProcessing(labImage, labelImageIn, componentsIn, avg_S, m)
	labelImageOut = labelImageIn;
	componentsOut = componentsIn;
	
	% update the label image according to the new components list
	for i = 1:size(componentsOut, 2)
		for j = 1:size(componentsOut{i}, 1)
			labelImageOut(componentsOut{i}(j, 1), componentsOut{i}(j, 2)) = i;
		end
	end

	for i = 1:size(componentsOut, 2)
		% remove the single components
		removeCondition = size(componentsOut{i}, 1) > 0 & (size(componentsOut{i}, 1) / (avg_S * avg_S) < 0.25);
		if(removeCondition == 1)
			[spatialMean, colorMean, neighbor] = findCompProp(labImage, componentsOut, labelImageOut, i);
			
			merge_target = 0;
			min_distance = inf;
			for j = 1:size(neighbor)
				if(min_distance ~= inf & (size(componentsOut{neighbor(j)}, 1) / (avg_S * avg_S) < 0.25))
					continue;
				end
				[nSpatialMean, nColorMean, temp] = findCompProp(labImage, componentsOut, labelImageOut, neighbor(j), 'mean');
				d = calDistance([colorMean, spatialMean], [nColorMean, nSpatialMean], avg_S, m);
				if(min_distance > d)
					min_distance = d;
					merge_target = neighbor(j);
				end
			end
			
			% merge components "i" and "merge_target"
			for j = 1:size(componentsOut{i}, 1)
				labelImageOut(componentsOut{i}(j, 1), componentsOut{i}(j, 2)) = merge_target;
				componentsOut{merge_target} = [componentsOut{merge_target}; componentsOut{i}(j, :)];
			end
			componentsOut{i} = [];
		end 
	end
end




