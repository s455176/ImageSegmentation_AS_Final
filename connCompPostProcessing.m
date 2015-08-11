function [labelImageOut, componentsOut] = connCompPostProcessing(labelImageIn, componentsIn)
	labelImageOut = labelImageIn;
	componentsOut = componentsIn;
	
	for i = 1:size(componentsOut, 2)
		for j = 1:size(componentsOut{i}, 1)
			labelImageOut(componentsOut{i}(j, 1), componentsOut{i}(j, 2)) = i;
		end
	end
	
	%{
	for i = 1:size(componentsOut, 2)
		% remove the single components
		if(size(componentsOut{i}, 1) == 1)
		end
	end
	%}
end