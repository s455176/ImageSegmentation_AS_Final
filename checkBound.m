function bool = checkBound(image, i, j)
	if(i < 1 | j < 1 | i > size(image, 1) | j > size(image, 2))
		bool = 0;
	else
		bool = 1;
	end
end