function [split, best_val] = findEigSplitPoint(W, D_diag, EigVec, slot)
	min_point = min(EigVec);
	max_point = max(EigVec);
	diff_val = (max_point - min_point) / (slot + 1);
	D = diag(D_diag);
	
	split = -1;
	best_val = inf;
	
	for i = 1:slot
		cur_point = min_point + i * diff_val;
		x = (EigVec > cur_point) * 2 - 1;
		k = sum((x > 0) .* D_diag) / sum(D_diag);
		b = k / (1 - k);
		y = (1 + x) - b * (1 - x);
		cur_val = (y' * (D - W) * y) / (y' * D * y);
		if(best_val > cur_val)
			best_val = cur_val;
			split = cur_point;
		end
	end
	
end




