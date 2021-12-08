-- Copyright (c) Microsoft. All rights reserved.

global PhysicsMaterialType:table = table.makeAutoEnum
{
	"None",
	"Default",
	"ShallowWater",
	"DeepWater",
	"Dirt",
	"Rock",
	"Gravel",
	"Mud",
	"Sand",
	"Vegetation",
	"Concrete",
	"Wood",
	"Metal",
};

global PhysicsMaterialLookupTable:table =
{
	[PhysicsMaterialType.ShallowWater] = { Engine_ResolveStringId("physical_water_shallow"), },
	[PhysicsMaterialType.DeepWater] = { Engine_ResolveStringId("physical_water_deep"), },
	[PhysicsMaterialType.Dirt] = { Engine_ResolveStringId("physical_dirt"), },
	[PhysicsMaterialType.Rock] = { Engine_ResolveStringId("physical_rock"), },
	[PhysicsMaterialType.Gravel] = { Engine_ResolveStringId("physical_rock_gravel"), },
	[PhysicsMaterialType.Mud] = { Engine_ResolveStringId("physical_mud"), },
	[PhysicsMaterialType.Sand] = { Engine_ResolveStringId("physical_sand"), },
	[PhysicsMaterialType.Vegetation] = { Engine_ResolveStringId("physical_vegetation"), Engine_ResolveStringId("physical_vegetation_grass"), },
	[PhysicsMaterialType.Concrete] = { Engine_ResolveStringId("physical_concrete"), },
	[PhysicsMaterialType.Wood] = { Engine_ResolveStringId("physical_wood"), },
	[PhysicsMaterialType.Metal] = { Engine_ResolveStringId("physical_metal"), Engine_ResolveStringId("physical_metal_forerunner"), },
};

--## SERVER

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- PHYSICS HELPERS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- SET VELOCITY
-- -------------------------------------------------------------------------------------------------
-- === objlist_setvelocity_rand: Sets a random X, Y, & Z velocity for each object in the object list
--			ol_list = object list to apply velocity to
--			r_x_min = x velocity minimum
--			r_x_max = x velocity maximum
--			r_y_min = y velocity minimum
--			r_y_max = y velocity maximum
--			r_z_min = z velocity minimum
--			r_z_max = z velocity maximum
--	RETURNS:  short; the number of objects velocity was applied to
function objlist_setvelocity_rand( ol_list:object_list, r_x_min:number, r_x_max:number, r_y_min:number, r_y_max:number, r_z_min:number, r_z_max:number ):number
	for _,obj in ipairs (ol_list) do
		object_wake_physics(obj);
		object_set_velocity(obj, real_random_range(r_x_min, r_x_max), real_random_range(r_y_min, r_y_max), real_random_range(r_z_min, r_z_max));
	end
	
	return #ol_list;
end

-- RETURN
-- === objlist_setvelocity: Sets a X, Y, & Z velocity for each object in the object list
--			ol_list = object list to apply velocity to
--			r_x = x velocity
--			r_y = y velocity
--			r_z = z velocity
--	RETURNS:  short; the number of objects velocity was applied to
function objlist_setvelocity( ol_list:object_list, r_x:number, r_y:number, r_z:number ):number
	return objlist_setvelocity_rand(ol_list, r_x, r_x, r_y, r_y, r_z, r_z);
end

-- === triggerobjs_setvelocity_rand: Sets a random X, Y, & Z velocity for each object inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--			r_x_min = x velocity minimum
--			r_x_max = x velocity maximum
--			r_y_min = y velocity minimum
--			r_y_max = y velocity maximum
--			r_z_min = z velocity minimum
--			r_z_max = z velocity maximum
--	RETURNS:  short; the number of objects velocity was applied to
function triggerobjs_setvelocity_rand( tv_volume:volume, i_objtypes:number, r_x_min:number, r_x_max:number, r_y_min:number, r_y_max:number, r_z_min:number, r_z_max:number ):number
	return objlist_setvelocity_rand(volume_return_objects_by_type(tv_volume, i_objtypes), r_x_min, r_x_max, r_y_min, r_y_max, r_z_min, r_z_max);
end

-- === triggerobjs_setvelocity: Sets a X, Y, & Z velocity for each object inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--			r_x = x velocity
--			r_y = y velocity
--			r_z = z velocity
--	RETURNS:  short; the number of objects velocity was applied to
function triggerobjs_setvelocity( tv_volume:volume, i_objtypes:number, r_x:number, r_y:number, r_z:number ):number
	return objlist_setvelocity(volume_return_objects_by_type(tv_volume, i_objtypes), r_x, r_y, r_z);
end

-- -------------------------------------------------------------------------------------------------
-- WAKE PHYSICS
-- -------------------------------------------------------------------------------------------------
-- === objlist_wakephysics: Wakes physics on all objects in an object list
--			ol_list = object list to wake physics
--	RETURNS:  short; the number of objects physics were woken up on
function objlist_wakephysics( ol_list:object_list ):number
	for _,obj in ipairs (ol_list) do
		object_wake_physics(obj);
	end
	
	return #ol_list;
end

-- RETURN
-- === triggerobjs_wakephysics: Wake physics for each object inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--	RETURNS:  short; the number of objects physics were woken up on
function triggerobjs_wakephysics( tv_volume:volume, i_objtypes:number ):number
	return objlist_wakephysics(volume_return_objects_by_type(tv_volume, i_objtypes));
end
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- GRAVITY
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------
-- TRANSITION GRAVITY
-- -------------------------------------------------------------------------------------------------
-- variables
global def_gravity_current:number=-666;

-- functions
-- === transition_gravity: Transitions gravity over time
--			r_gravity_start = starting gravity value; currently there is no way to get your current gravity value
--				[r_gravity_start == DEF_GRAVITY_CURRENT] Sets the starting gravity to the current gravity
--			r_gravity_end = final gravity value
--				[r_gravity_end == DEF_GRAVITY_CURRENT] Sets the ending gravity to the current gravity
--			r_seconds = number of seconds the gravity transition should take place
--			s_refresh = refresh rate of the gravity change; 0 will update as often as possible
--	RETURNS:  void
function transition_gravity( r_gravity_start:number, r_gravity_end:number, r_seconds:number, s_refresh:number ):void
	if l_sys_transition_gravity~=nil then
		KillThread(l_sys_transition_gravity);
	end
	l_sys_transition_gravity = CreateThread(sys_transition_gravity, r_gravity_start, r_gravity_end, r_seconds, s_refresh);
end
global l_sys_transition_gravity:thread=nil;

-- === sys_transition_gravity: System function for transition_gravity
--			NOTE: DO NOT USE THIS FUNCTION
function sys_transition_gravity( r_gravity_start:number, r_gravity_end:number, r_seconds:number, s_refresh:number ):void
	-- defaults
	if r_gravity_start == def_gravity_current then
		r_gravity_start = physics_get_gravity();
	end
	if r_gravity_end == def_gravity_current then
		r_gravity_end = physics_get_gravity();
	end
	-- get start time	
	l_time_start = game_tick_get();
	-- get end time	
	l_time_end = l_time_start + seconds_to_frames(r_seconds);
	-- setup variables
	r_gravity_range = r_gravity_end - r_gravity_start;
	r_time_range = l_time_end - l_time_start;
	if r_gravity_range > 0.001 and r_time_range > 0.001 then
		repeat
			Sleep(s_refresh);
			r_gravity_delta = (game_tick_get() - l_time_start) / r_time_range;
			-- set gravity to the current % of time progress
			physics_set_gravity(r_gravity_start + r_gravity_range * r_gravity_delta);
		until game_tick_get() >= l_time_end;
	end
	physics_set_gravity(r_gravity_end);
end
global l_time_start:number=0;
global l_time_end:number=0;
global r_gravity_range:number=0.0;
global r_gravity_delta:number=0.0;
global r_time_range:number=0.0;

-- -------------------------------------------------------------------------------------------------
-- OBJECT SET GRAVITY
-- -------------------------------------------------------------------------------------------------
-- === objlist_setgravity_rand: Applies random gravity on all objects in an object list
--			ol_list = object list to apply gravity
--			r_gravity_min = Minimum gravity to set on the object
--			r_gravity_max = Maximum gravity to set on the object
--			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
--	RETURNS:  short; the number of objects gravity was changed on
function objlist_setgravity_rand( ol_list:object_list, r_gravity_min:number, r_gravity_max:number, b_inherit:boolean ):number
	local s_index:number=0;
	local s_cnt:number=0;
	s_index = list_count(ol_list);
	if s_index > 0 then
		repeat
			Sleep(0);
			s_index = s_index - 1;
			if list_get(ol_list, s_index)~=nil then
				object_set_gravity(list_get(ol_list, s_index), real_random_range(r_gravity_min, r_gravity_max), b_inherit);
				s_cnt = s_cnt + 1;
			end
		until s_index <= 0;
	end
	return s_cnt;
end

-- RETURN
-- === objlist_setgravity: Applies gravity on all objects in an object list
--			ol_list = object list to apply gravity
--			r_gravity = Gravity to set on the objects
--			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
--	RETURNS:  short; the number of objects gravity was changed on
function objlist_setgravity( ol_list:object_list, r_gravity:number, b_inherit:boolean ):number
	return objlist_setgravity_rand(ol_list, r_gravity, r_gravity, b_inherit);
end

-- === triggerobjs_setgravity_rand: Applies random gravity on all objects inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--			r_gravity_min = Minimum gravity to set on the object
--			r_gravity_max = Maximum gravity to set on the object
--			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
--	RETURNS:  short; the number of objects gravity was changed on
function triggerobjs_setgravity_rand( tv_volume:volume, i_objtypes:number, r_gravity_min:number, r_gravity_max:number, b_inherit:boolean ):number
	return objlist_setgravity_rand(volume_return_objects_by_type(tv_volume, i_objtypes), r_gravity_min, r_gravity_max, b_inherit);
end

-- === triggerobjs_setgravity: Applies gravity on all objects inside the trigger volume of the specified type
--			tv_volume = Trigger volume to collect objects in
--			i_objtypes = Object types to collect from trigger volume; see OBJECT TYPES in global_scripts.hsc
--				[i_objtypes == 0] = All types
--			r_gravity = Gravity to set on the objects
--			b_inherit = TRUE; When the object is destroyed, the junk will inherit the gravity settings of the object, FALSE; junk will not inherit gravity
--	RETURNS:  short; the number of objects gravity was changed on
function triggerobjs_setgravity( tv_volume:volume, i_objtypes:number, r_gravity:number, b_inherit:boolean ):number
	return objlist_setgravity_rand(volume_return_objects_by_type(tv_volume, i_objtypes), r_gravity, r_gravity, b_inherit);
end


-- -------------------------------------------------------------------------------------------------
-- RAY CASTS
-- -------------------------------------------------------------------------------------------------

-- === RaycastToBiped: sends a raycast from a location to a location, but only looks for bipeds
--		startLocation = position where the ray will start
--		bipedLocation = the location of where to check for the biped
--	RETURNS:  location of ground
--	NOTE: return's nil if raycast doesn't hit biped, a table if it does
function RaycastToBiped(startLocation, bipedLocation)
	return Physics_RayCast(ToLocation(startLocation), ToLocation(bipedLocation), "biped", g_staticMasks.bipedStatic, g_staticMasks.bipedDynamic);
end


-- === RaycastFromPlayerVisorToDynamicObject: casts a ray from an approximate player sight to approximate body of a biped
--		player = the player where the ray will originate
--		object = the object and object location where the ray will test
--		offsets = numbers to offset from the root node of the object (use to try to point to a good spot on the object)
--	RETURNS:  return's nil if raycast doesn't hit object, a table if it does
--	NOTE: this casts the ray from just about the players head to approximately where the object (or bipeds body) will be.
--			z + 0.1 for objects and z + 0.4 for bipeds
--			Use the offsets to make it more accurate
function RaycastFromPlayerVisorToDynamicObject(player:player, object:object, locXOffset:number, locYOffset:number, locZOffset:number)
	if player == nil or object == nil then
		return nil;
	end

	local func = RayCastDynamicObject;
	local type, subType = GetEngineType(object, true);
	
	--get the type
	--if a biped then look for a biped
	if subType == "biped" then
		func = RaycastToBiped
		locZOffset = locZOffset or 0.4;
	else
		locZOffset = locZOffset or 0.1;
	end
	--print("player is", player)
	--print("object is", object)
	local playerVisionMarker = Object_GetMarkerWorldPosition(player, "player_vision_raycast");
	
	local vecObject = ToLocation(object).vector;
	if locXOffset then
		vecObject.x = vecObject.x + locXOffset
	end
	if locYOffset then
		vecObject.y = vecObject.y + locYOffset
	end
	if locZOffset then
		vecObject.z = vecObject.z + locZOffset
	end

	return func(playerVisionMarker, vecObject);
end

-- === Physics_FindGround: finds the nearest static geo location below or above location
--		position = position of thing whose nearest geo location is needed
--		(optional) range = the range down, then up to check for static geo
--	RETURNS:  location of ground
--	NOTE: return's nil if no static geo exists
function Physics_FindGround(position:location, range:number):location
	local rayCastEnd:location = ToLocation(position).vector;
	range = range or 100;
	range = math.abs(range);
	rayCastEnd.z = rayCastEnd.z - range;
	local rayCastResult:table = RayCastStaticGeometryBullet(position, rayCastEnd);

	if rayCastResult == nil then
		return nil;
	end

	return ToLocation(rayCastResult.position);
end

-- === Physics_FindGroundInBounds: finds static geo location using given point as a midpoint for raycast
--		position = midpoint for raycast
--		(optional) range = the distance from the midpoint for the start and end points
--	RETURNS:  location of ground
--	NOTE: return's nil if no static geo exists
function Physics_FindGroundInBounds(midpoint:location, range:number):location
	range = range or 50;
	range = math.abs(range);
	local midpointLoc:location = ToLocation(midpoint);

	local rayCastStart:vector = midpointLoc.vector;
	rayCastStart.z = rayCastStart.z + range;

	local rayCastEnd:vector = midpointLoc.vector;
	rayCastEnd.z = rayCastEnd.z - range;

	local rayCastResult:table = RayCastStaticGeometryBullet(ToLocation(rayCastStart), ToLocation(rayCastEnd));

	if rayCastResult == nil then
		return nil;
	end

	return ToLocation(rayCastResult.position);
end

-- === RayCastStaticGeometryBullet: casts a ray against bullet collision and returns a table of information about the first geo it finds
--		startLocation = position of the start of the ray
--		endLocation = position of the end of the ray
--	RETURNS:  table of information about the asset
--		{position, hitMaterial, hitFraction, normal}
--	NOTE: return's nil if no static geo is hit
function RayCastStaticGeometryBullet(startLocation:location, endLocation:location):table
	return Physics_RayCast(ToLocation(startLocation), ToLocation(endLocation), "zero_extent", g_staticMasks.defaultStatic, g_staticMasks.NONE);
end

-- === RayCastStaticGeometryMovement: casts a ray against biped collision and returns a table of information about the first geo it finds
--		startLocation = position of the start of the ray
--		endLocation = position of the end of the ray
--	RETURNS:  table of information about the asset
--		{position, hitMaterial, hitFraction, normal}
--	NOTE: return's nil if no static geo is hit
function RayCastStaticGeometryMovement(startLocation:location, endLocation:location):table
	return Physics_RayCast(ToLocation(startLocation), ToLocation(endLocation), "biped", g_staticMasks.defaultStatic, g_staticMasks.NONE);
end

-- === RayCastDynamicObject: casts a ray and returns a table of information about the first dynamic geo it hits
--		startLocation = position of the start of the ray
--		endLocation = position of the end of the ray
--	RETURNS:  table of information about the dynamic geo
--		{position, hitObject, hitMaterial, hitFraction, normal}
--	NOTE: return's nil if no dynamic object is hit
function RayCastDynamicObject(startLocation:location, endLocation:location):table
	return RayCastSimple(startLocation, endLocation, g_staticMasks.defaultDynamic.NONE, g_staticMasks.defaultDynamic);
end

-- === RayCastSimple: casts a ray and returns a table of information about the first anything it hits
--		startLocation = position of the start of the ray
--		endLocation = position of the end of the ray
--		(optional) staticMask = the optional mask for checking for static objects
--		(optional) dynamicMask = the optional mask for checking for dynamic objects
--	RETURNS:  table of information about the thing it hit
--		{position, hitObject, hitMaterial, hitFraction, normal}
--	NOTE: return's nil if nothing is hit
function RayCastSimple(startLocation:location, endLocation:location, staticMask:wholenum, dynamicMask:wholenum):table
	staticMask = staticMask or g_staticMasks.defaultStatic;
	dynamicMask = dynamicMask or g_staticMasks.defaultDynamic;
	return Physics_RayCast(ToLocation(startLocation), ToLocation(endLocation), "zero_extent", staticMask, dynamicMask);
end

-- -------------------------------------------------------------------------------------------------
-- PLAYER LOOK RAYCASTS
-- -------------------------------------------------------------------------------------------------

-- === RayCastPlayerLookStaticGeometry: casts a ray and returns a table of information about the first geo it finds
--		player = the player that the ray will cast from (defaults to player0)
--		
--	RETURNS:  table of information about the asset
--		{position, hitMaterial, hitFraction, normal}
--	NOTE: return's nil if no static geo is hit
function RayCastPlayerLookStaticGeometry(player:player):table
	return RayCastStaticGeometryBullet(GetPlayerLookAtLocations(player, 0));
end

-- === RayCastPlayerLookDynamicObject: casts a ray and returns a table of information about the first dynamic object it finds
--		player = the player that the ray will cast from (defaults to player0)
--		
--	RETURNS:  table of information about the dynamic asset
--		{position, hitObject, hitMaterial, hitFraction, normal}
--	NOTE: return's nil if no dynamic object is hit
function RayCastPlayerLookDynamicObject(player:player):table
	return RayCastDynamicObject(GetPlayerLookAtLocations(player));
end


-- === RayCastPlayerLookAll: casts a ray and returns a table of information about the first anything it hits
--		player = the player that the ray will cast from (defaults to player0)
--		
--	RETURNS:  table of information about the dynamic asset
--		{position, hitObject, hitMaterial, hitFraction, normal}
--	NOTE: return's nil if no dynamic object is hit
function RayCastPlayerLookAll(player:player):table
	return RayCastSimple(GetPlayerLookAtLocations(player));
end

function GetPlayerLookAtLocations(player:player, startOffset:number, endOffset:number)
	player = player or PLAYERS.player0;
	--the start offset default is to get around the raycast hitting the player
	--this is planned to be removed when we have the omit object function
	startOffset = startOffset or 0.5;
	endOffset = endOffset or 100;
	local startLocation:location = ToLocation(GetLookPosition(player, startOffset));
	local endLocation:location = ToLocation(GetLookPosition(player, endOffset));
	
	return startLocation, endLocation;
end

-- -------------------------------------------------------------------------------------------------
-- ACTIVATION VOLUME TESTING
-- -------------------------------------------------------------------------------------------------

-- takes a location and tries to find a point on static geo along a line to the center of the activation volume
function FindValidPlayerPointWithinActivationVolume(startPoint:location, volume:activation_volume, sampleRate:number):location
	if startPoint == nil or volume == nil then
		return nil;
	end

	-- first, get the center point of the volume
	local center:vector = ActivationVolume_GetCenter(volume);
	local start:vector = startPoint.vector;
	local delta:vector = center - start;

	-- we need to walk along the line between the points, and check every so often for a valid point
	sampleRate = sampleRate or 0.1;
	local t:number = sampleRate;

	while t <= 1 do
		local testPoint:vector = start + (delta * t);

		-- check if the point is within the volume
		if ActivationVolume_TestPoint(volume, testPoint) == true then
			local testLoc:location = ToLocation(testPoint);

			-- check if we can find some static geo near that point
			local geoLoc:location = Physics_FindGroundInBounds(testLoc);

			if geoLoc ~= nil then
				-- found a point in the volume and on static geo
				return geoLoc;
			end
		end
		
		t = t + sampleRate;
	end

	-- were unable to find a point
	return nil;
end

-- takes a group of objects and attempts to find a point on static geo among them
function FindValidPlayerPointAmongObjects(objects:table):location
	local result:location = nil;

	if objects ~= nil and #objects > 0 then
		local centroid:vector = vector(0, 0, 0);
		local count:number = 0;
		local highestZ:number = -1;
	
		for _, object in ipairs(objects) do
			local loc:location = Object_GetPosition(object);
	
			if loc ~= nil then
				local vec:vector = loc.vector;
				centroid = centroid + vec;
				highestZ = math.max(highestZ, vec.z);
				count = count + 1;
			end
		end

		centroid = centroid * (1 / count);
		centroid.z = highestZ;

		local pointRange:number = 0;
		local rangeIncrement:number = 1;
	

		while result == nil and pointRange <= 10 do
			local testPoint:vector = GetRandomPointInCircle(centroid, pointRange);
			local testLoc:location = ToLocation(testPoint);

			local geoLoc:location = Physics_FindGroundInBounds(testLoc);

			if geoLoc ~= nil then
				result = geoLoc;
			else
				pointRange = pointRange + rangeIncrement;
			end
		end
	end

	return result;
end

-- === SnapObjectToGround: casts a ray and snaps an object to that point, oriented properly with the normal of the ground at that point (Server Only)
--		object = the object to snap to the ground
--		fwdRefDirection = a general reference direction that the object should face (typically purely X-Y). this will be modified based on the topology of the ground
--		(optional) initialPosition = a starting position. if nil, will use the object's current position
--		(optional) range = the distance downwards to ray cast
--		(optional) maxSlope = the maximum angle the surface normal can be from straight up in order to orient the object to the ground topology. no rotation will take place if exceeded
--	RETURNS:  true if able to successfully snap to ground, otherwise false
function SnapObjectToGround(obj:object, fwdRefDirection:vector, initialPosition:location, range:number, maxSlope:number):boolean
	range = range or 50;
	maxSlope = maxSlope or 45;

	local worldUp:vector = vector(0, 0, 1);
	local objPos:location = initialPosition or Object_GetPosition(obj);
	local startPoint:location = ToLocation(objPos.vector + worldUp * 0.1);	-- bump up a tad in case we were already a bit below ground
	local endPoint:location = ToLocation(objPos.vector - worldUp * range);
	local rayCastResult:table = RayCastStaticGeometryBullet(startPoint, endPoint);

	if (rayCastResult ~= nil) then
		Object_SetPosition(obj, rayCastResult.position);

		local maxSlopeDot:number = math.cos(math.rad(maxSlope));
		local curDot:number = rayCastResult.normal ^ worldUp;

		if (curDot >= maxSlopeDot) then	-- seems counterintuitive, but if they were co-linear, the angle would be 0 and have a cosine of 1.0, so we want to be greater than the threshold here
			local up:vector = rayCastResult.normal;
			local left:vector = Vector_Normalize(up % fwdRefDirection);
			local forward:vector = Vector_Normalize(left % up);
			Object_SetRotation(obj, forward, up);
		else
			print("WARNING: Unable to orient object to ground. Max slope exceeded.");
		end

		return true;
	end

	return false;
end

function GetPhysicsMaterialTypeHit(startPos:location, endPos:location):number
	local result:table = RayCastStaticGeometryBullet(startPos, endPos);

	if (result == nil) then
		return PhysicsMaterialType.None;
	end

	for materialType, materials in hpairs(PhysicsMaterialLookupTable) do
		if (table.contains(materials, result.hitMaterialStringID)) then
			return materialType;
		end
	end
		
	return PhysicsMaterialType.Default;
end
