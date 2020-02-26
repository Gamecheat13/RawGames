--## SERVER

--[[
function MusketeerUtil_SetDefaultCombatParams()

	for _, obj in ipairs (ai_actors(GetMusketeerSquad())) do

		--MusketeerCombatSetAllowedPlayerOffset(obj, 3);
		MusketeerCombatSetDefault(obj);
	end
end


function MusketeerUtil_SetTightCombat()

	for _, obj in ipairs (ai_actors(GetMusketeerSquad())) do

		--MusketeerCombatSetAllowedPlayerOffset(obj, 3);
		MusketeerCombatSetMaxPlayerDistance(obj, 3);
	end
end


function MusketeerUtil_SetInteractionValues(musk1:object, musk2:object, avoid:number, prefer:number)

	MusketeerCombatSetAvoidRadius(musk1, musk2, avoid);
	MusketeerCombatSetAvoidRadius(musk2, musk1, avoid);

	MusketeerCombatSetPreferRadius(musk1, musk2, prefer);
	MusketeerCombatSetPreferRadius(musk2, musk1, prefer);
end


function MusketeerUtil_SetInteractionValuesOnAll(avoid:number, prefer:number)
	for _, obj in ipairs (ai_actors(GetMusketeerSquad())) do

		for _, obj2 in ipairs (ai_actors(GetMusketeerSquad())) do

			MusketeerUtil_SetInteractionValues(obj, obj2, avoid, prefer);
		end
	end
end


function MusketeerUtil_PairUp()

	MusketeerUtil_SetInteractionValuesOnAll(10, 0);
	MusketeerUtil_SetInteractionValues(SPARTANS.tanaka, SPARTANS.vale, 1.5, 4);
	MusketeerUtil_SetInteractionValues(SPARTANS.locke, SPARTANS.buck, 1.5, 4);
	MusketeerCombatSetMaxPlayerDistance(SPARTANS.buck, 3);
end

--]]

function MusketeerUtil_SetDestinationWhenDrivingPlayer(dest:location, waypoints:point_set)

	for _, obj in ipairs (ai_actors(GetMusketeerSquad())) do

		if(MusketeerIsDrivingPlayer(obj)) then
			MusketeerDestSetPoint(obj, dest, 5);

			for i = 1, #waypoints do
				MusketeerDestAddWayPoint(obj, waypoints[i]);
			end
		else
			MusketeerDestClear(obj);
		end
	end
end


function  MusketeerUtil_SetMusketeerGoal( dest:location , radius:number )

		local radius = radius or 3;
		for _, obj in ipairs ( ai_actors(GetMusketeerSquad()) ) do
				MusketeerDestSetPoint(obj, dest, radius);
		end

end

function MusketeerUtil_SetDestination_Clear_All()

	for _, obj in ipairs (ai_actors(GetMusketeerSquad())) do
			MusketeerDestClear(obj);
	end
end