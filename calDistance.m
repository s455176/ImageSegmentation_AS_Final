function result = calDistance(C, cur, avg_S, m)
	spatial = (C(4) - cur(4))^2 + (C(5) - cur(5))^2;
	color = (C(1) - cur(1))^2 + (C(2) - cur(2))^2 + (C(3) - cur(3))^2;
	S_squre = avg_S^2;
	m_squre = m^2;
	result = sqrt(color + (spatial / S_squre) * m_squre);
end