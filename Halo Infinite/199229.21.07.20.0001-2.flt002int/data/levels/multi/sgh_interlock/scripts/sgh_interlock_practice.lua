-- Copyright (c) Microsoft. All rights reserved.
--## SERVER
--[[

sgh_interlock_practice Practice
               
I am a: (pick one)
		[ ] GLOBAL PVE SCRIPT	
		[ ] GAMETYPE SCRIPT		
		[*] LOCAL SCRIPT		- I CONTAIN LEVEL-SPECIFIC DATA FOR A GAMETYPE

--	====================================================================================
--	==								Interlock:
--	==								AcademyPractice
--  ==
--  ==						see also: academy_Practice.lua
--	====================================================================================
--]] 

--[[
 ______     ______     ______   __  __     ______  
/\  ___\   /\  ___\   /\__  _\ /\ \/\ \   /\  == \ 
\ \___  \  \ \  __\   \/_/\ \/ \ \ \_\ \  \ \  _-/ 
 \/\_____\  \ \_____\    \ \_\  \ \_____\  \ \_\   
  \/_____/   \/_____/     \/_/   \/_____/   \/_/   
                                                   
--]]
function GetLocalAcademyPracticeInitArgs():AcademyPracticeInitArgs
	return hmake AcademyPracticeInitArgs
	{
		instanceName	= GetLocalAcademyPracticeName(),	
	}
end

function GetLocalAcademyPracticeName()
	return "sgh_interlock_practice_AcademyPractice";
end

global barrelTag:tag = TAG('levels\assets\shiva\lookdev\ryoun\environment_test\barrel_a\barrel_a.crate');
global generatorTag:tag = TAG('levels\assets\shiva\lookdev\ryoun\environment_test\generator_small_a\generator_small_a.crate');

function PlaceSomeObjectsRandomly(numObjects:number, objectTag:tag):number
	local athensRandomSpawnMinX:number = -16;
	local athensRandomSpawnMaxX:number = 21;
	local athensRandomSpawnMinY:number = -18;
	local athensRandomSpawnMaxY:number = 12;
	local athensRandomSpawnMinZ:number = -1;
	local athensRandomSpawnMaxZ:number = 10;
	
	local placedCount = 0;
	if (numObjects ~= nil and numObjects > 0 and objectTag ~= nil) then
		for i=0, numObjects, 1 do
			-- Choose a random location, fire a ray down from that, and palce the object there where we hit the environment.
			local randomLocation:vector = vector(0,0,0);
			randomLocation.x = random_range(athensRandomSpawnMinX, athensRandomSpawnMaxX);
			randomLocation.y = random_range(athensRandomSpawnMinY, athensRandomSpawnMaxY);
			randomLocation.z = random_range(athensRandomSpawnMinZ, athensRandomSpawnMaxZ);
			local randomDownLocation:vector = vector(randomLocation.x, randomLocation.y, randomLocation.z);
			randomDownLocation.z = randomDownLocation.z - (athensRandomSpawnMaxZ * 10);
			local raycastResult:table = Physics_RayCast(ToLocation(randomLocation), ToLocation(randomDownLocation), "environment_only");
			
			if (raycastResult ~= nil) then
				local theObject = Object_CreateFromTag(objectTag);
				object_teleport(theObject, raycastResult.position.vector);
				placedCount = placedCount + 1;
			end
		end
	end
	
	return placedCount;
end

--## CLIENT