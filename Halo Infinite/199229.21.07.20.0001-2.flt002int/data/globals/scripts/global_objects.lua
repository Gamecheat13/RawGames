-- Copyright (C) Microsoft. All rights reserved.

--This function converts something that can be described as a location and returns it as a pure location
--for example, game objects, the player or a location type
function ToLocation(loc):location
	if GetEngineType (loc) ~= "location" then
		return location(loc, "");
	end
	return loc;
end

--This function will test if an object is possibly one with object scripts, and if so, will call the specified object function if defined
function TryAndCallObjectScriptFunction(object, objectFunctionName:string):void
	if (object ~= nil) then
		local objectType:string = type(object);
		if (objectType == "struct" or objectType == "userdata") then
			local func = object[objectFunctionName];
			if (func ~= nil) then
				func(object);
			end
		end
	end
end

-- asynchronous object transform functions
function LuaAsyncOperation(operation, ...)
	local res = operation(false, unpack(arg));
	while res do
		coroutine.yield();
		res = operation(true, res);
	end
end

--## SERVER

-----------------------------------------------
--	Global Enumerations - Should be constants
-----------------------------------------------
--	Filter Types (Dynamic Tasks)
global ft_companion:number=0;
global ft_protector:number=1;
global ft_spawner:number=2;
global ft_birther:number=3;
--	Task Types (Dynamic Tasks)
global tt_interact:number=0;
global tt_protect:number=1;
global tt_shield:number=2;
global tt_resurrect:number=3;
global tt_spawn:number=4;
global tt_suppress:number=5;
global tt_shard_spawn:number=6;
--	Task Team Filters (Dynamic Tasks)
global tf_friendly:number=0;
global tf_hostile:number=1;
global tf_any:number=2;
--	Command Event Types
global cmd_interact:number=0;

--	For use as an invalid task callback.
function noop_callback( taskindex:number, tasktype:number, tasktarget:number ):void
	print("");
end
--------------------------------------
--	Per-Object variable unique IDs.
--------------------------------------
global var_move_amount:number=1;
global var_cover_status:number=2;
global var_move_time:number=3;
global var_shard_spawn_delay:number=4;
global var_turret_active:number=5;
global var_turret_hijacked:number=6;
--	These per-object variables automatically connect to object functions of the same names.
global var_obj_local_a:number=253;
global var_obj_local_b:number=254;
global var_obj_local_c:number=255;

----------------------------
--		Dynamic Cover
----------------------------
--	'Local' variables used inside functions.
global dynamiccoverevent_moveamount:number=0;
global dynamiccoverevent_movetime:number=0;
global dynamiccover_status:number=0;
--	Cover status
global cs_moving_up:number=0;
global cs_up:number=1;
global cs_moving_down:number=2;
global cs_down:number=3;

function initializedynamiccover( coverobject:object, moveamount:number, movetime:number ):void
	--	We want to know when we've been interacted with by the bishop beam.
	SetObjectRealVariable(coverobject, var_move_amount, moveamount);
	SetObjectRealVariable(coverobject, var_move_time, movetime);
	SetObjectLongVariable(coverobject, var_cover_status, cs_down);
	RegisterEvent(g_eventTypes.objectInteractEvent, ondynamiccoverevent, coverobject);
end

function requestinteractdynamiccover( coverobject:object ):void
	CreateDynamicTask(tt_interact, ft_companion, coverobject, "noop_callback", 0);
end

function setdynamiccoverstatus( coverobject:object, setraised:boolean ):void
	CreateThread(setdynamiccoverstatusblocking, coverobject, setraised);
end

function setdynamiccoverstatusblocking( coverobject:object, setraised:boolean ):void
	dynamiccover_status = GetObjectLongVariable(coverobject, var_cover_status);
	dynamiccoverevent_movetime = GetObjectRealVariable(coverobject, var_move_time);
	if dynamiccover_status == cs_down and setraised == true then
		--	Raise the cover.
		dynamiccoverevent_moveamount = GetObjectRealVariable(coverobject, var_move_amount);
		SetObjectLongVariable(coverobject, var_cover_status, cs_moving_up);
		object_move_by_offset(coverobject, dynamiccoverevent_movetime, 0, 0, dynamiccoverevent_moveamount);
		SetObjectLongVariable(coverobject, var_cover_status, cs_up);
	elseif dynamiccover_status == cs_up and setraised == false then
		--	Lower the cover
		dynamiccoverevent_moveamount = -1 * GetObjectRealVariable(coverobject, var_move_amount);
		SetObjectLongVariable(coverobject, var_cover_status, cs_moving_down);
		object_move_by_offset(coverobject, dynamiccoverevent_movetime, 0, 0, dynamiccoverevent_moveamount);
		SetObjectLongVariable(coverobject, var_cover_status, cs_down);
	end
end

function isdynamiccoverraised( coverobject:object ):boolean
	dynamiccover_status = GetObjectLongVariable(coverobject, var_cover_status);
	return dynamiccover_status == cs_moving_up or dynamiccover_status == cs_up;
end

function isdynamiccoverbusy( coverobject:object ):boolean
	dynamiccover_status = GetObjectLongVariable(coverobject, var_cover_status);
	return dynamiccover_status == cs_moving_up or dynamiccover_status == cs_moving_down;
end

function ondynamiccoverevent(eventStruct) --InteractEventStruct
	local coverobject:object 				= eventStruct.interactee;
	local interacterObject:object 	= eventStruct.interacter;
	
	--	Don't want to initiate another interact call while we are busy with this one.
	UnregisterEvent(g_eventTypes.objectInteractEvent, ondynamiccoverevent, coverobject);
	dynamiccover_status = GetObjectLongVariable(coverobject, var_cover_status);
	dynamiccoverevent_movetime = GetObjectRealVariable(coverobject, var_move_time);
	--	Toggle position, but only if it currently isn't moving.
	if dynamiccover_status == cs_down then
		setdynamiccoverstatusblocking(coverobject, true);
	elseif dynamiccover_status == cs_up then
		setdynamiccoverstatusblocking(coverobject, false);
	end
	RegisterEvent(g_eventTypes.objectInteractEvent, ondynamiccoverevent, coverobject);
end

-----------------------
--		Shard Spawn
-----------------------
function InitializeShardSpawn( placeTarget:ai, spawnDelay:number ):void
	--	Wait and then place actor.
	Sleep(spawnDelay);
	--	Make sure we didn't die during the countdown.
	ai_place(placeTarget);
	object_dissolve_from_marker(ai_get_object(placeTarget), "resurrect", "phase_in");
	object_dissolve_from_marker(ai_vehicle_get(placeTarget), "resurrect", "phase_in");
	Sleep(5);
	ai_internal_query_clump_for_target(placeTarget);
end

-----------------------
--	Slip Space Spawn
-----------------------
function SlipSpaceSpawn( placeTarget:ai ):void
	CreateThread(SlipSpaceSpawnBlocking, placeTarget);
end

function SlipSpaceSpawnBlocking( placeTarget:ai ):void
	ai_play_slip_space_effect_at_squad_location(placeTarget);
	sleep_s(3);
	ai_place(placeTarget);
	local squadList:object_list = ai_actors(placeTarget);	
	local listIndex:number = list_count(squadList);
	if listIndex > 0 then
		repeat
			listIndex = listIndex - 1;
			object_dissolve_from_marker(list_get(squadList, listIndex), "resurrect", "phase_in");
			--object_dissolve_from_marker(ai_vehicle_get(placeTarget), "resurrect", "phase_in");
		until listIndex <= 0;
	end
	
	Sleep(5);
	ai_internal_query_clump_for_target(placeTarget);
	
end

--	Slip Space Spawn Group

function SlipSpaceSpawnGroup(group:ai, low_range:number, high_range:number)
	
	CreateThread(SlipSpaceSpawnGroupBlocking, group, low_range, high_range);

end

function SlipSpaceSpawnGroupBlocking(group:ai, lowRange:number, highRange:number)
	
	lowRange = lowRange or 0.1;
	highRange = highRange or 0.75;
	
	local squadCount = ai_squad_group_get_squad_count(group);
	local threadIds = {};
	
	for i = 0, (squadCount - 1) do
		threadIds[i] = CreateThread(SlipSpaceSpawnBlocking, ai_squad_group_get_squad(group, i));
		if i < squadCount - 1 then
			sleep_s(real_random_range(lowRange, highRange));
		end
	end

	for i = 0, (squadCount - 1) do
		SleepUntil([|not IsThreadValid(threadIds[i])], 1);
	end

	AISlipSpaceSpawnSquadGroupCompleted(group);

end

-------------------------------------------------------
--		CapturableAI
-- Interact on one of these objects
-- captures it's squad for the team of the captor
-------------------------------------------------------
function initializecapturableunit( captiveobject:object ):void
	RegisterEvent(g_eventTypes.objectInteractEvent, oncapturableobjectevent_callback, captiveobject);
end

function oncapturableobjectevent_callback( captiveobject:object, interacterObject:object ):void
	--	for interact events, the first argument is the interacting user
	ai_capture_allegiance(captiveobject, interacterObject);
end

-----------------------------
--		Automated Turret
-----------------------------
function initializeautomatedturret( turret:object, startsactive:boolean ):void
	--print("ERROR - Automated turrets are no longer supported.");
end

function automatedturretactivate( turret:object ):void
	print("Activating automated turret: OLD FUNCTION. Change to the correct placement of the turrets. MFindley");
end

function automatedturretswitchteams( turret:object, newteamobj:object ):void
	
end

function requestautomatedturretactivation( turret:object ):void
	--CreateDynamicTask(tt_interact, ft_companion, turret, "noop_callback", 0);
end


-- =================================================================================================
-- OBJECT TYPES
--	Add values together for combos
-- =================================================================================================
global s_objtype_biped:number=1;
global s_objtype_vehicle:number=2;
global s_objtype_weapon:number=4;
global s_objtype_equipment:number=8;
global s_objtype_crate:number=1024;



-- =================================================================================================
-- OBJECT VECTOR
-- =================================================================================================
function object_get_vector( obj )
	return vector( object_get_x(obj), object_get_y(obj), object_get_z(obj) );
end

function TeleportObjectRelative(obj:object, loc1:location, loc2:location)
	--print ("Teleport Object Relative");
	local fl1:matrix = ToLocation(loc1).matrix;
	local fl2:matrix = ToLocation(loc2).matrix;
	local df:matrix = fl1.inverse * fl2;
	local obj1:matrix = location(obj,"").matrix;
	--print (obj1);
	local obj2:matrix = obj1*df;
	local obj_v:vector = object_get_vector(obj);
	--print("new position",obj2.pos,#(obj1.pos-fl1.pos),#(obj2.pos-fl2.pos));
	
	object_teleport (obj, obj2);
	object_set_facing (obj, obj2);
	print ("teleporting", GetEngineString(obj), "from", obj_v, "to", object_get_vector(obj));
end





-- =================================================================================================
-- =================================================================================================
-- OBJECT NEAREST/farthest
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- OBJECT NEAREST/farthest: POINT
-- -------------------------------------------------------------------------------------------------
-- === objlist_index_nearestfarthest_point: Get the object index nearest/farthest a point
--			ol_list = object list to cycle through
--			p_point = point to test against
--			b_nearest = TRUE = nearest, FALSE = farthest
-- 			b_check_health = if TRUE, checks the objects health is > 0
--	RETURNS:  index of the object nearest the point
function objlist_index_nearestfarthest_point( ol_list:object_list, p_point:point, b_nearest:boolean, b_check_health:boolean ):number
	local s_found:number=0;
	local s_index:number=0;
	-- initialize
	s_found = -1;
	s_index = list_count(ol_list);
	if s_index > 0 then
		repeat
			Sleep(0);
			s_index = s_index - 1;
			if  not b_check_health or object_get_health(list_get(ol_list, s_index)) > 0 then
				if s_found == -1 then
					s_found = s_index;
				elseif (b_nearest and objects_distance_to_point(list_get(ol_list, s_index), p_point) < objects_distance_to_point(list_get(ol_list, s_index), p_point)) or ( not b_nearest and objects_distance_to_point(list_get(ol_list, s_index), p_point) < objects_distance_to_point(list_get(ol_list, s_index), p_point)) then
					s_found = s_index;
				end
			end
		until s_index <= 0;
	end
	return s_found;
end

-- === objlist_index_nearest_point: Get the object index nearest a point
--			ol_list = object list to cycle through
--			p_point = point to test against
--	RETURNS:  index of the object nearest the point
function objlist_index_nearest_point( ol_list:object_list, p_point:point ):number
	return objlist_index_nearestfarthest_point(ol_list, p_point, true, false);
end

function objlist_living_index_nearest_point( ol_list:object_list, p_point:point ):number
	return objlist_index_nearestfarthest_point(ol_list, p_point, true, true);
end

-- === objlist_index_farthest_point: Get the object index farthest to a point
--			ol_list = object list to cycle through
--			p_point = point to test against
--	RETURNS:  index of the object nearest the point
function objlist_index_farthest_point( ol_list:object_list, p_point:point ):number
	return objlist_index_nearestfarthest_point(ol_list, p_point, false, false);
end

function objlist_living_index_farthest_point( ol_list:object_list, p_point:point ):number
	return objlist_index_nearestfarthest_point(ol_list, p_point, false, true);
end

-- === objlist_object_nearestfarthest_point: Get the object nearest/farthest a point
--			ol_list = object list to cycle through
--			p_point = point to test against
--			b_nearest = TRUE = nearest, FALSE = farthest
-- 			b_check_health = if TRUE, checks the objects health is > 0
--	RETURNS:  the object nearest the point
--		NOTE: Returns NONE if no object was found
function objlist_object_nearestfarthest_point( ol_list:object_list, p_point:point, b_nearest:boolean, b_check_health:boolean ):object
	local s_found:number=0;
	s_found = objlist_index_nearestfarthest_point(ol_list, p_point, b_nearest, b_check_health);
	if s_found~=-1 then
		return list_get(ol_list, s_found);
	else
		return nil;
	end
end

-- === objlist_object_nearest_point: Get the object nearest to a point
--			ol_list = object list to cycle through
--			p_point = point to test against
--	RETURNS:  the object nearest the point
--		NOTE: Returns NONE if no object was found
function objlist_object_nearest_point( ol_list:object_list, p_point:point ):object
	return objlist_object_nearestfarthest_point(ol_list, p_point, true, false);
end

function objlist_living_object_nearest_point( ol_list:object_list, p_point:point ):object
	return objlist_object_nearestfarthest_point(ol_list, p_point, true, true);
end

-- === objlist_object_farthest_point: Get the object farthest from a point
--			ol_list = object list to cycle through
--			p_point = point to test against
--	RETURNS:  the object nearest the point
--		NOTE: Returns NONE if no object was found
function objlist_object_farthest_point( ol_list:object_list, p_point:point ):object
	return objlist_object_nearestfarthest_point(ol_list, p_point, false, false);
end

function objlist_living_object_farthest_point( ol_list:object_list, p_point:point ):object
	return objlist_object_nearestfarthest_point(ol_list, p_point, false, true);
end

-- === player_index_nearest_point: Get the player index nearest a point
--			p_point = point to test against
--	RETURNS:  index of the player nearest the point
function player_index_nearest_point( p_point:point ):number
	return objlist_index_nearestfarthest_point(players(), p_point, true, false);
end

function player_living_index_nearest_point( p_point:point ):number
	return objlist_index_nearestfarthest_point(players(), p_point, true, true);
end

-- === player_index_farthest_point: Get the player object farthest from a point
--			p_point = point to test against
--	RETURNS:  index of the player nearest the point
function player_index_farthest_point( p_point:point ):number
	return objlist_index_nearestfarthest_point(players(), p_point, false, false);
end

function player_living_index_farthest_point( p_point:point ):number
	return objlist_index_nearestfarthest_point(players(), p_point, false, true);
end

-- === player_nearest_point: Get the player nearest a point
--			p_point = point to test against
--	RETURNS:  player object nearest the point
function player_nearest_point( p_point:point ):player
	return objlist_object_nearestfarthest_point(players(), p_point, true, false);
end

function player_living_nearest_point( p_point:point ):player
	return objlist_object_nearestfarthest_point(players(), p_point, true, true);
end

-- === player_farthest_point: Get the player farthest from a point
--			p_point = point to test against
--	RETURNS:  player object nearest the point
function player_farthest_point( p_point:point ):player
	return objlist_object_nearestfarthest_point(players(), p_point, false, false);
end

function player_living_farthest_point( p_point:point ):player
	return objlist_object_nearestfarthest_point(players(), p_point, false, true);
end

-- -------------------------------------------------------------------------------------------------
-- OBJECT NEAREST/farthest: POINT: IN TRIGGERS
-- -------------------------------------------------------------------------------------------------
-- === objlist_index_in_trigger_nearest_point: Get the object within the trigger index nearest a point
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			p_point = point to test against
--			b_nearest = TRUE = nearest, FALSE = farthest
-- 			b_check_health = if TRUE, checks the objects health is > 0
--	RETURNS:  index of the object nearest the point
function objlist_index_in_trigger_nearestfarthest_point( ol_list:object_list, tv_trigger:volume, p_point:point, b_nearest:boolean, b_check_health:boolean ):number
	local s_found:number=0;
	local s_index:number=0;
	-- initialize
	s_found = -1;
	s_index = list_count(ol_list);
	if s_index > 0 then
		repeat
			Sleep(0);
			s_index = s_index - 1;
			if (volume_test_object(tv_trigger, list_get(ol_list, s_index)) and  not b_check_health) or object_get_health(list_get(ol_list, s_index)) > 0 then
				if s_found == -1 then
					s_found = s_index;
				elseif (b_nearest and objects_distance_to_point(list_get(ol_list, s_index), p_point) < objects_distance_to_point(list_get(ol_list, s_found), p_point)) or ( not b_nearest and objects_distance_to_point(list_get(ol_list, s_index), p_point) > objects_distance_to_point(list_get(ol_list, s_found), p_point)) then
					s_found = s_index;
				end
			end
		until s_index <= 0;
	end
	return s_found;
end

-- === objlist_index_in_trigger_nearest_point: Get the object within the trigger index nearest to a point
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			p_point = point to test against
--	RETURNS:  index of the object nearest the point
function objlist_index_in_trigger_nearest_point( ol_list:object_list, tv_trigger:volume, p_point:point ):number
	return objlist_index_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, true, false);
end

function objlist_living_index_in_trigger_nearest_point( ol_list:object_list, tv_trigger:volume, p_point:point ):number
	return objlist_index_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, true, true);
end

-- === objlist_index_in_trigger_farthest_point: Get the object within the trigger index farthest from a point
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			p_point = point to test against
--	RETURNS:  index of the object nearest the point
function objlist_index_in_trigger_farthest_point( ol_list:object_list, tv_trigger:volume, p_point:point ):number
	return objlist_index_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, true, false);
end

function objlist_living_index_in_trigger_farthest_point( ol_list:object_list, tv_trigger:volume, p_point:point ):number
	return objlist_index_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, true, true);
end

-- === objlist_object_in_trigger_nearestfarthest_point: Get the object within the trigger index nearest/farthest a point
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			p_point = point to test against
--			b_nearest = TRUE = nearest, FALSE = farthest
--	RETURNS:  index of the object nearest the point
--		NOTE: Returns NONE if no object was found
function objlist_object_in_trigger_nearestfarthest_point( ol_list:object_list, tv_trigger:volume, p_point:point, b_nearest:boolean, b_check_health:boolean ):object
	local s_found:number=0;
	s_found = objlist_index_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, b_nearest, b_check_health);
	if s_found~=-1 then
		return list_get(ol_list, s_found);
	else
		return nil;
	end
end

-- === objlist_object_in_trigger_nearest_point: Get the object within the trigger index nearest to a point
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			p_point = point to test against
--	RETURNS:  index of the object nearest the point
--		NOTE: Returns NONE if no object was found
function objlist_object_in_trigger_nearest_point( ol_list:object_list, tv_trigger:volume, p_point:point ):object
	return objlist_object_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, true, false);
end

function objlist_living_object_in_trigger_nearest_point( ol_list:object_list, tv_trigger:volume, p_point:point ):object
	return objlist_object_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, true, true);
end

-- === objlist_object_in_trigger_farthest_point: Get the object within the trigger index farthest from a point
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			p_point = point to test against
--	RETURNS:  index of the object nearest the point
--		NOTE: Returns NONE if no object was found
function objlist_object_in_trigger_farthest_point( ol_list:object_list, tv_trigger:volume, p_point:point ):object
	return objlist_object_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, false, false);
end

function objlist_living_object_in_trigger_farthest_point( ol_list:object_list, tv_trigger:volume, p_point:point ):object
	return objlist_object_in_trigger_nearestfarthest_point(ol_list, tv_trigger, p_point, false, true);
end

-- === player_index_in_trigger_nearest_point: Get the player index inside a trigger nearest to a point
--			tv_trigger = trigger to check players inside of
--			p_point = point to test against
--	RETURNS:  index of the player inside the trigger nearest the point
function player_index_in_trigger_nearest_point( tv_trigger:volume, p_point:point ):number
	return objlist_index_in_trigger_nearestfarthest_point(players(), tv_trigger, p_point, true, false);
end

function player_living_index_in_trigger_nearest_point( tv_trigger:volume, p_point:point ):number
	return objlist_index_in_trigger_nearestfarthest_point(players(), tv_trigger, p_point, true, true);
end

-- === player_index_in_trigger_farthest_point: Get the player index inside a trigger farthest from a point
--			tv_trigger = trigger to check players inside of
--			p_point = point to test against
--	RETURNS:  index of the player inside the trigger nearest the point
function player_index_in_trigger_farthest_point( tv_trigger:volume, p_point:point ):number
	return objlist_index_in_trigger_nearestfarthest_point(players(), tv_trigger, p_point, false, false);
end

function player_living_index_in_trigger_farthest_point( tv_trigger:volume, p_point:point ):number
	return objlist_index_in_trigger_nearestfarthest_point(players(), tv_trigger, p_point, false, true);
end

-- === player_in_trigger_nearest_point: Get the player inside a trigger nearest a point
--			tv_trigger = trigger to check players inside of
--			p_point = point to test against
--	RETURNS:  player inside the trigger nearest the point
--		NOTE: Returns NONE if no object was found
function player_in_trigger_nearest_point( tv_trigger:volume, p_point:point ):player
	return objlist_object_in_trigger_nearestfarthest_point(players(), tv_trigger, p_point, true, false);
end

function player_living_in_trigger_nearest_point( tv_trigger:volume, p_point:point ):player
	return objlist_object_in_trigger_nearestfarthest_point(players(), tv_trigger, p_point, true, true);
end

-- === player_in_trigger_farthest_point: Get the player inside a trigger nearest a point
--			tv_trigger = trigger to check players inside of
--			p_point = point to test against
--	RETURNS:  player inside the trigger nearest the point
--		NOTE: Returns NONE if no object was found
function player_in_trigger_farthest_point( tv_trigger:volume, p_point:point ):player
	return objlist_object_in_trigger_nearestfarthest_point(players(), tv_trigger, p_point, false, false);
end

function player_living_in_trigger_farthest_point( tv_trigger:volume, p_point:point ):player
	return objlist_object_in_trigger_nearestfarthest_point(players(), tv_trigger, p_point, false, true);
end

-- -------------------------------------------------------------------------------------------------
-- OBJECT NEAREST/farthest: OBJECT
-- -------------------------------------------------------------------------------------------------
-- === objlist_index_nearestfarthest_object: Get the object index nearest/farthest a object
--			ol_list = object list to cycle through
--			o_object = object to test against
--			b_nearest = TRUE = nearest, FALSE = farthest
-- 			b_check_health = if TRUE, checks the objects health is > 0
--	RETURNS:  index of the object nearest the object
function objlist_index_nearestfarthest_object( ol_list:object_list, o_object:object, b_nearest:boolean, b_check_health:boolean ):number
	local s_found:number=0;
	local s_index:number=0;
	-- initialize
	s_found = -1;
	s_index = list_count(ol_list);
	if s_index > 0 then
		repeat
			Sleep(0);
			s_index = s_index - 1;
			if  not b_check_health or object_get_health(list_get(ol_list, s_index)) > 0 then
				if s_found == -1 then
					s_found = s_index;
				elseif (b_nearest and objects_distance_to_object(list_get(ol_list, s_index), o_object) < objects_distance_to_object(list_get(ol_list, s_found), o_object)) or ( not b_nearest and objects_distance_to_object(list_get(ol_list, s_index), o_object) > objects_distance_to_object(list_get(ol_list, s_found), o_object)) then
					s_found = s_index;
				end
			end
		until s_index <= 0;
	end
	return s_found;
end

-- === objlist_index_nearest_object: Get the object index nearest a object
--			ol_list = object list to cycle through
--			o_object = object to test against
--	RETURNS:  index of the object nearest the object
function objlist_index_nearest_object( ol_list:object_list, o_object:object ):number
	return objlist_index_nearestfarthest_object(ol_list, o_object, true, false);
end

function objlist_living_index_nearest_object( ol_list:object_list, o_object:object ):number
	return objlist_index_nearestfarthest_object(ol_list, o_object, true, true);
end

-- === objlist_index_farthest_object: Get the object index farthest to a object
--			ol_list = object list to cycle through
--			o_object = object to test against
--	RETURNS:  index of the object nearest the object
function objlist_index_farthest_object( ol_list:object_list, o_object:object ):number
	return objlist_index_nearestfarthest_object(ol_list, o_object, false, false);
end

function objlist_living_index_farthest_object( ol_list:object_list, o_object:object ):number
	return objlist_index_nearestfarthest_object(ol_list, o_object, false, true);
end

-- === objlist_object_nearestfarthest_object: Get the object nearest/farthest a object
--			ol_list = object list to cycle through
--			o_object = object to test against
--			b_nearest = TRUE = nearest, FALSE = farthest
-- 			b_check_health = if TRUE, checks the objects health is > 0
--	RETURNS:  the object nearest the object
--		NOTE: Returns NONE if no object was found
function objlist_object_nearestfarthest_object( ol_list:object_list, o_object:object, b_nearest:boolean, b_check_health:boolean ):object
	local s_found:number=0;
	s_found = objlist_index_nearestfarthest_object(ol_list, o_object, b_nearest, b_check_health);
	if s_found~=-1 then
		return list_get(ol_list, s_found);
	else
		return nil;
	end
end

-- === objlist_object_nearest_object: Get the object nearest to a object
--			ol_list = object list to cycle through
--			o_object = object to test against
--	RETURNS:  the object nearest the object
--		NOTE: Returns NONE if no object was found
function objlist_object_nearest_object( ol_list:object_list, o_object:object ):object
	return objlist_object_nearestfarthest_object(ol_list, o_object, true, false);
end

function objlist_living_object_nearest_object( ol_list:object_list, o_object:object ):object
	return objlist_object_nearestfarthest_object(ol_list, o_object, true, true);
end

-- === objlist_object_farthest_object: Get the object farthest from a object
--			ol_list = object list to cycle through
--			o_object = object to test against
--	RETURNS:  the object nearest the object
--		NOTE: Returns NONE if no object was found
function objlist_object_farthest_object( ol_list:object_list, o_object:object ):object
	return objlist_object_nearestfarthest_object(ol_list, o_object, false, false);
end

function objlist_living_object_farthest_object( ol_list:object_list, o_object:object ):object
	return objlist_object_nearestfarthest_object(ol_list, o_object, false, true);
end

-- === player_index_nearest_object: Get the player index nearest a object
--			o_object = object to test against
--	RETURNS:  index of the player nearest the object
function player_index_nearest_object( o_object:object ):number
	return objlist_index_nearestfarthest_object(players(), o_object, true, false);
end

function player_living_index_nearest_object( o_object:object ):number
	return objlist_index_nearestfarthest_object(players(), o_object, true, true);
end

-- === player_index_farthest_object: Get the player object farthest from a object
--			o_object = object to test against
--	RETURNS:  index of the player nearest the object
function player_index_farthest_object( o_object:object ):number
	return objlist_index_nearestfarthest_object(players(), o_object, false, false);
end

function player_living_index_farthest_object( o_object:object ):number
	return objlist_index_nearestfarthest_object(players(), o_object, false, true);
end

-- === player_nearest_object: Get the player nearest a object
--			o_object = object to test against
--	RETURNS:  player object nearest the object
function player_nearest_object( o_object:object ):player
	return objlist_object_nearestfarthest_object(players(), o_object, true, false);
end

function player_living_nearest_object( o_object:object ):player
	return objlist_object_nearestfarthest_object(players(), o_object, true, true);
end

-- === player_farthest_object: Get the player farthest from a object
--			o_object = object to test against
--	RETURNS:  player object nearest the object
function player_farthest_object( o_object:object ):player
	return objlist_object_nearestfarthest_object(players(), o_object, false, false);
end

function player_living_farthest_object( o_object:object ):player
	return objlist_object_nearestfarthest_object(players(), o_object, false, true);
end

-- -------------------------------------------------------------------------------------------------
-- OBJECT NEAREST/farthest: object: IN TRIGGERS
-- -------------------------------------------------------------------------------------------------
-- === objlist_index_in_trigger_nearest_object: Get the object within the trigger index nearest a object
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			o_object = object to test against
--			b_nearest = TRUE = nearest, FALSE = farthest
-- 			b_check_health = if TRUE, checks the objects health is > 0
--	RETURNS:  index of the object nearest the object
function objlist_index_in_trigger_nearestfarthest_object( ol_list:object_list, tv_trigger:volume, o_object:object, b_nearest:boolean, b_check_health:boolean ):number
	local s_found:number=0;
	local s_index:number=0;
	-- initialize
	s_found = -1;
	s_index = list_count(ol_list);
	if s_index > 0 then
		repeat
			Sleep(0);
			s_index = s_index - 1;
			if (volume_test_object(tv_trigger, list_get(ol_list, s_index)) and  not b_check_health) or object_get_health(list_get(ol_list, s_index)) > 0 then
				if s_found == -1 then
					s_found = s_index;
				elseif (b_nearest and objects_distance_to_object(list_get(ol_list, s_index), o_object) < objects_distance_to_object(list_get(ol_list, s_index), o_object)) or ( not b_nearest and objects_distance_to_object(list_get(ol_list, s_index), o_object) < objects_distance_to_object(list_get(ol_list, s_index), o_object)) then
					s_found = s_index;
				end
			end
		until s_index <= 0;
	end
	return s_found;
end

-- === objlist_index_in_trigger_nearest_object: Get the object within the trigger index nearest to a object
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			o_object = object to test against
--	RETURNS:  index of the object nearest the object
function objlist_index_in_trigger_nearest_object( ol_list:object_list, tv_trigger:volume, o_object:object ):number
	return objlist_index_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, true, false);
end

function objlist_living_index_in_trigger_nearest_object( ol_list:object_list, tv_trigger:volume, o_object:object ):number
	return objlist_index_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, true, true);
end

-- === objlist_index_in_trigger_farthest_object: Get the object within the trigger index farthest from a object
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			o_object = object to test against
--	RETURNS:  index of the object nearest the object
function objlist_index_in_trigger_farthest_object( ol_list:object_list, tv_trigger:volume, o_object:object ):number
	return objlist_index_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, true, false);
end

function objlist_living_index_in_trigger_farthest_object( ol_list:object_list, tv_trigger:volume, o_object:object ):number
	return objlist_index_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, true, true);
end

-- === objlist_object_in_trigger_nearestfarthest_object: Get the object within the trigger index nearest/farthest a object
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			o_object = object to test against
--			b_nearest = TRUE = nearest, FALSE = farthest
--	RETURNS:  index of the object nearest the object
--		NOTE: Returns NONE if no object was found
function objlist_object_in_trigger_nearestfarthest_object( ol_list:object_list, tv_trigger:volume, o_object:object, b_nearest:boolean, b_check_health:boolean ):object
	local s_found:number=0;
	s_found = objlist_index_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, b_nearest, b_check_health);
	if s_found~=-1 then
		return list_get(ol_list, s_found);
	else
		return nil;
	end
end

-- === objlist_object_in_trigger_nearest_object: Get the object within the trigger index nearest to a object
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			o_object = object to test against
--	RETURNS:  index of the object nearest the object
--		NOTE: Returns NONE if no object was found
function objlist_object_in_trigger_nearest_object( ol_list:object_list, tv_trigger:volume, o_object:object ):object
	return objlist_object_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, true, false);
end

function objlist_living_object_in_trigger_nearest_object( ol_list:object_list, tv_trigger:volume, o_object:object ):object
	return objlist_object_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, true, true);
end

-- === objlist_object_in_trigger_farthest_object: Get the object within the trigger index farthest from a object
--			ol_list = object list to cycle through
--			tv_trigger = trigger to check if the object is inside of
--			o_object = object to test against
--	RETURNS:  index of the object nearest the object
--		NOTE: Returns NONE if no object was found
function objlist_object_in_trigger_farthest_object( ol_list:object_list, tv_trigger:volume, o_object:object ):object
	return objlist_object_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, false, false);
end

function objlist_living_object_in_trigger_farthest_object( ol_list:object_list, tv_trigger:volume, o_object:object ):object
	return objlist_object_in_trigger_nearestfarthest_object(ol_list, tv_trigger, o_object, false, true);
end

-- === player_index_in_trigger_nearest_object: Get the player index inside a trigger nearest to a object
--			tv_trigger = trigger to check players inside of
--			o_object = object to test against
--	RETURNS:  index of the player inside the trigger nearest the object
function player_index_in_trigger_nearest_object( tv_trigger:volume, o_object:object ):number
	return objlist_index_in_trigger_nearestfarthest_object(players(), tv_trigger, o_object, true, false);
end

function player_living_index_in_trigger_nearest_object( tv_trigger:volume, o_object:object ):number
	return objlist_index_in_trigger_nearestfarthest_object(players(), tv_trigger, o_object, true, true);
end

-- === player_index_in_trigger_farthest_object: Get the player index inside a trigger farthest from a object
--			tv_trigger = trigger to check players inside of
--			o_object = object to test against
--	RETURNS:  index of the player inside the trigger nearest the object
function player_index_in_trigger_farthest_object( tv_trigger:volume, o_object:object ):number
	return objlist_index_in_trigger_nearestfarthest_object(players(), tv_trigger, o_object, false, false);
end

function player_living_index_in_trigger_farthest_object( tv_trigger:volume, o_object:object ):number
	return objlist_index_in_trigger_nearestfarthest_object(players(), tv_trigger, o_object, false, true);
end

-- === player_in_trigger_nearest_object: Get the player inside a trigger nearest a object
--			tv_trigger = trigger to check players inside of
--			o_object = object to test against
--	RETURNS:  player inside the trigger nearest the object
--		NOTE: Returns NONE if no object was found
function player_in_trigger_nearest_object( tv_trigger:volume, o_object:object ):player
	return objlist_object_in_trigger_nearestfarthest_object(players(), tv_trigger, o_object, true, false);
end

function player_living_in_trigger_nearest_object( tv_trigger:volume, o_object:object ):player
	return objlist_object_in_trigger_nearestfarthest_object(players(), tv_trigger, o_object, true, true);
end

-- === player_in_trigger_farthest_object: Get the player inside a trigger nearest a object
--			tv_trigger = trigger to check players inside of
--			o_object = object to test against
--	RETURNS:  player inside the trigger nearest the object
--		NOTE: Returns NONE if no object was found
function player_in_trigger_farthest_object( tv_trigger:volume, o_object:object ):player
	return objlist_object_in_trigger_nearestfarthest_object(players(), tv_trigger, o_object, false, false);
end

function player_living_in_trigger_farthest_object( tv_trigger:volume, o_object:object ):player
	return objlist_object_in_trigger_nearestfarthest_object(players(), tv_trigger, o_object, false, true);
end


--==== Applies a function to each object in a list
function forEach( list:object_list, func)
	--get the objects in the list
	local listIndex:number = list_count( list )
	--Do function for each object
	for i = 0, (listIndex - 1) do
		func(list_get( list, i));
	end
end

---------------------------------------------------------------------------------------------------
-- Below are special functions that use private engine functions (exposed by lua_register)
-- and coroutines.  ObjectRequestPlacementCheckCompletion and functions whose name has "Internal"
-- at the end are lua_registered ones.
--
-- PLEASE DO NOT CHANGE UNLESS YOU ARE SURE ABOUT HOW ALL FUNCTIONS WORKS.
-- Removing may be OK if you are sure function is obsolete.
---------------------------------------------------------------------------------------------------

-- Create an object for the given tag through the object queue.
function ObjectCreateFromTagAsync(objectDefTag, placeLocation)
	local placeHandle = ObjectRequestPlacementInternal(objectDefTag, placeLocation);
	local result = ObjectRequestPlacementCheckCompletion(placeHandle);
	while result[2] == false do
		coroutine.yield();
		result = ObjectRequestPlacementCheckCompletion(placeHandle);
	end
	return result[1];
end

-- DEPRECATED: use Object_TranslateToPoint
function object_move_to_flag(object, time, flag)
	LuaAsyncOperation(Object_TranslateToFlagInternal, object, time, flag, CURVE_BUILT_IN.Linear);
end

-- DEPRECATED: use Object_TranslateToPoint
function object_move_to_point(object, time, point)
	LuaAsyncOperation(Object_TranslateToPointInternal, object, time, point, CURVE_BUILT_IN.Linear);
end

-- DEPRECATED: use Object_TranslateByOffset
function object_move_by_offset(object, time, x, y, z)
	LuaAsyncOperation(Object_TranslateByOffsetInternal, object, time, x, y, z, CURVE_BUILT_IN.Linear);
end

-- DEPRECATED: use Object_RotateToPoint
function object_rotate_to_flag(object, time, flag)
	LuaAsyncOperation(Object_RotateToFlagInternal, object, time, flag, CURVE_BUILT_IN.Linear);
end

-- DEPRECATED: use Object_RotateToPoint
function object_rotate_to_point(object, time, point)
	LuaAsyncOperation(Object_RotateToPointInternal, object, time, point, CURVE_BUILT_IN.Linear);
end

-- DEPRECATED: use Object_RotateByOffset
function object_rotate_by_offset(object, time, yaw, pitch, roll)
	LuaAsyncOperation(Object_RotateByOffsetInternal, object, time, yaw, pitch, roll, CURVE_BUILT_IN.Linear);
end

-- Translates the specified object to the specified point over the specified timespan. An optional curve can be specified to control acceleration and/or deceleration,  defaults to linear.
-- NOTE: If your distance over time is greater than Physics_MaxLinearVelocity the object will move at maximum velocity
function Object_TranslateToPoint(object, time, point, curve)
	curve = curve or CURVE_BUILT_IN.Linear;
	LuaAsyncOperation(Object_TranslateToPointInternal, object, time, point, curve);
end

-- Translates the specified object by the specified vector over the specified timespan. An optional curve can be specified to control acceleration and/or deceleration,  defaults to linear.
-- NOTE: If your distance/time is greater than Physics_MaxLinearVelocity the object will move at maximum velocity
function Object_TranslateByOffset(object, time, x, y, z, curve)
	curve = curve or CURVE_BUILT_IN.Linear;
	LuaAsyncOperation(Object_TranslateByOffsetInternal, object, time, x, y, z, curve);
end

-- Rotates the specified object to aim at the specified point over the specified timespan. An optional curve can be specified to control acceleration and/or deceleration,  defaults to linear.
function Object_RotateToPoint(object, time, point, curve)
	curve = curve or CURVE_BUILT_IN.Linear;
	LuaAsyncOperation(Object_RotateToPointInternal, object, time, point, curve);
end

-- Rotates the specified object by the specified yaw,  pitch,  roll over the specified timespan. An optional curve can be specified to control acceleration and/or deceleration,  defaults to linear.
function Object_RotateByOffset(object, time, yaw, pitch, roll, curve)
	curve = curve or CURVE_BUILT_IN.Linear;
	LuaAsyncOperation(Object_RotateByOffsetInternal, object, time, yaw, pitch, roll, curve);
end

-- Translates and rotates the specified object to match the provided transform,  over the specified timespan. An optional curve can be specified to control acceleration and/or deceleration,  defaults to linear.
function Object_MoveToTransform(object, time, matrix, curve)
	curve = curve or CURVE_BUILT_IN.Linear;
	LuaAsyncOperation(Object_MoveToTransformInternal, object, time, matrix, curve);
end

---------------------------------------------------------------------------------------------------
-- End of Special Functions
---------------------------------------------------------------------------------------------------

--## CLIENT

-- Client version of Object_TranslateToPoint. Used specifically for FOB holograms.
function Object_TranslateToPoint_ClientOnly(object, time, point, curve)
	curve = curve or CURVE_BUILT_IN.Linear;
	LuaAsyncOperation(Object_TranslateToPointInternal, object, time, point, curve);
end