--## SERVER



function ReviveAll()

	for _, obj in ipairs (ai_actors(GetMusketeerSquad())) do
		ReviveUnit(obj);
	end

	for _, obj in ipairs (players()) do
		ReviveUnit(obj);
	end
end
