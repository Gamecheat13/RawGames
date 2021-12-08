-- Copyright (c) Microsoft. All rights reserved.
-- ===============================================================================================================================================
-- GLOBAL SCRIPTS ================================================================================================================================
-- ===============================================================================================================================================

global NONE = -1;

global ObjectTypeMask =
{
	All = wholenum(-1),					-- everything
	Biped = wholenum(1),				-- bipeds only
	Vehicle = wholenum(2),				-- vehicles only
	BipedAndVehicle = wholenum(3),		-- bipeds and vehicles
	Weapon = wholenum(4),
	Unit = wholenum(8195),				-- units, i.e. bipeds, vehicles, and giants
}

global CollisionTestEnum = table.makeEnum
	{
		_collision_test_structure_bit = 0,
		_collision_test_water_bit = 1,
		_collision_test_soft_ceilings_bit = 2,
		_collision_test_instanced_geometry_bit = 3,
		_collision_test_render_only_bsps_bit = 4,
		_collision_test_ignore_child_objects_bit = 5,
		_collision_test_ignore_nonpathfindable_objects_bit = 6,
		_collision_test_ignore_non_flight_blocking_bit = 7,
		_collision_test_ignore_cinematic_objects_bit = 8,
		_collision_test_ignore_dead_bipeds_bit = 9,
		_collision_test_ignore_biped_holograms_bit = 10,
		_collision_test_ignore_geometry_that_ignores_aoe_bit = 11,
		_collision_test_front_facing_surfaces_bit = 12,
		_collision_test_back_facing_surfaces_bit = 13,
		_collision_test_ignore_two_sided_surfaces_bit = 14,
		_collision_test_ignore_invisible_surfaces_bit = 15,
		_collision_test_allow_early_out_bit = 16,
		_collision_test_try_to_keep_location_valid_bit = 17,
		_collision_test_ignore_non_prt_objects_bit = 18,
		_collision_test_ignore_non_collision_model_physics_bit = 19,
		_collision_test_ignore_non_camera_camera_collision_bit = 20,
		_collision_test_ignore_invisible_to_projectile_aiming_bit = 21,
		_collision_test_skip_collidable_bit = 22,
		_collision_test_render_only_bit = 23,
		_collision_test_query_against_havok_not_bsp = 24,
		_collision_test_query_against_havok_not_bsp_force = 25,
		_collision_test_fixed_objects_only = 26,
		_collision_test_force_invisible_walls = 27,
		_collision_test_ignore_weapon_attachments = 28,
		_collision_test_force_objects_only_collidable_in_forge = 29,
		_collision_test_force_smoke_screen = 30,
	};

global CollisionTestObjectsEnum = table.makeEnum
	{
		_collision_test_objects_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_bit), -- if this is set and no specific type bits (below) are set, all object types are tested.
		_collision_test_objects_bipeds_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_bipeds_bit),
		_collision_test_objects_vehicles_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_vehicles_bit),
		_collision_test_objects_weapons_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_weapons_bit),
		_collision_test_objects_equipment_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_equipment_bit),
		_collision_test_objects_terminals_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_terminals_bit),
		_collision_test_objects_projectiles_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_projectiles_bit),
		_collision_test_objects_scenery_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_scenery_bit),
		_collision_test_objects_machines_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_machines_bit),
		_collision_test_objects_controls_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_controls_bit),
		eCollisionTestObjects_dispensersBit = EnumToNumber(COLLISION_TEST_OBJECTS.eCollisionTestObjects_dispensersBit),
		_collision_test_objects_crates_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_crates_bit),
		_collision_test_objects_creatures_bit =	EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_creatures_bit),
		_collision_test_objects_giants_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_giants_bit),
		_collision_test_objects_effect_scenery_bit = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_effect_scenery_bit),
		_collision_test_objects_type_filters_at_leaves = EnumToNumber(COLLISION_TEST_OBJECTS._collision_test_objects_type_filters_at_leaves) -- If set, don't filter out child objects just because the parent is filtered (e.g. if we're set to ignore bipeds, test the children of bipeds anyway because they could be of a type we want to test against).
	};

global ObjectTypesEnum = table.makeEnum
	{
		_object_type_biped = EnumToNumber(OBJECT_TYPE._object_type_biped),
		_object_type_vehicle = EnumToNumber(OBJECT_TYPE._object_type_vehicle),
		_object_type_weapon = EnumToNumber(OBJECT_TYPE._object_type_weapon),
		_object_type_equipment = EnumToNumber(OBJECT_TYPE._object_type_equipment),
		_object_type_terminal = EnumToNumber(OBJECT_TYPE._object_type_terminal),
		_object_type_projectile = EnumToNumber(OBJECT_TYPE._object_type_projectile),
		_object_type_scenery = EnumToNumber(OBJECT_TYPE._object_type_scenery),
		_object_type_machine = EnumToNumber(OBJECT_TYPE._object_type_machine),
		_object_type_control = EnumToNumber(OBJECT_TYPE._object_type_control),
		_object_type_dispenser = EnumToNumber(OBJECT_TYPE._object_type_dispenser),
		_object_type_crate = EnumToNumber(OBJECT_TYPE._object_type_crate),
		_object_type_creature = EnumToNumber(OBJECT_TYPE._object_type_creature),
		_object_type_giant = EnumToNumber(OBJECT_TYPE._object_type_giant),
		_object_type_effect_scenery = EnumToNumber(OBJECT_TYPE._object_type_effect_scenery)
	};


function BuildMask(...):wholenum
	local mask:wholenum = wholenum(0);
	mask:setbits(unpack(arg));
	return mask;
end

global g_staticMasks = 
	{
		defaultStatic = BuildMask(CollisionTestEnum._collision_test_structure_bit,
			CollisionTestEnum._collision_test_instanced_geometry_bit,
			CollisionTestEnum._collision_test_front_facing_surfaces_bit),
		defaultDynamic = BuildMask(CollisionTestObjectsEnum._collision_test_objects_bit),
		bipedStatic = BuildMask(
			CollisionTestEnum._collision_test_ignore_two_sided_surfaces_bit,
			CollisionTestEnum._collision_test_ignore_invisible_surfaces_bit,
			CollisionTestEnum._collision_test_structure_bit,
			CollisionTestEnum._collision_test_instanced_geometry_bit,
			CollisionTestEnum._collision_test_front_facing_surfaces_bit
			),

		bipedDynamic = BuildMask(
			CollisionTestObjectsEnum._collision_test_objects_bit
			--CollisionTestObjectsEnum._collision_test_objects_bipeds_bit,
			--ObjectTypesEnum._object_type_vehicle,
			--ObjectTypesEnum._object_type_scenery,
			--ObjectTypesEnum._object_type_machine,
			--ObjectTypesEnum._object_type_crate,
			--ObjectTypesEnum._object_type_giant
			),

		NONE = wholenum(0),
	};

-- =================================================================================================
-- Global Helpers
-- =================================================================================================
-- === attempts to run a function by name if that function is defined
--	funcName:string = Name of the function
--	... = the args that are passed into the function
--	RETURNS:  void
function RunFunctionIfFunctionNameDefined(funcName:string, ...):void
	RunMethodIfObjectHasMethod(_G, funcName, ...);
end

-- === attempts to run a method on an object (scripted object or kit) by name if that function is defined on the object/kit
--	obj = the reference to the object or kit
--	funcName:string = Name of the function
--	... = the args that are passed into the function
--	RETURNS:  true if the method existed, false if not
function RunMethodIfObjectHasMethod(obj:any, methodName:string, ...):boolean
	local method = GetTableValue(obj, methodName);
	if type(method) == "function" then
		--print("running method");
		method(...);
		return true;
	else
		return false;
	end
end

-- === attempts to return the reference of a nested table
--	obj = the reference to the object or kit
--	funcName:string = Name of the function
--	... = the list of items that are the keys of the table structure
--	EXAMPLE:
	--	local exTable:table =
			--{
				--foo = 
					--{
						--goo = 5,
					--}
			--};
							

	--	GetTableValue(exTable, "foo", "goo") would return 5
	--	this is equivalent to:	exTable.foo.goo
--	RETURNS:  any
function GetTableValue(baseTable, ...):any
	baseTable = baseTable or {};
	--baseTable isn't a table then return nil
	if GetEngineType(baseTable) ~= "table" and type(baseTable) ~= "struct" then
		return nil;
	end
	
	--loop through arg and attempt to get the value
	local value = baseTable;
	for _, argument in ipairs(arg) do
		value = value[argument];
		--if the value is ever nil then break the loop which will then return nil
		if value == nil then
			break;
		end
	end
	return value;
end

-- =================================================================================================
-- Time utilities
-- =================================================================================================

-- Sleep until for all element in array condition(element) returns true
function SleepUntilForAll(array:table, condition:ifunction, evalFrames:number, maxFrames:number):void
	SleepUntil([
			for _, element in ipairs(array) do
				if not condition(element) then
					return false;
				end
			end
			return true;
		], evalFrames, maxFrames);
end

-- Sleeps for a number of frames between min and max.
function SleepRandom( l_min:number, l_max:number ):void
	Sleep(random_range(l_min, l_max));
end

-- Sleeps for a number of seconds between min and max.
function SleepRandomSeconds( r_min:number, r_max:number ):void
	SleepSeconds(real_random_range(r_min, r_max));
end

-- Returns the evaluation of the SleepUntil function after the condition returns true or the max frames have passed. 
-- This is used when knowing whether the condition returned true or the max frames occured.
function SleepUntilReturn(condition:ifunction, evalFrames:number, maxFrames:number):boolean
	SleepUntil(condition, evalFrames, maxFrames);
	return condition();
end

-- Returns the evaluation of the SleepUntilSeconds function after the condition returns true or the max time has passed. 
-- This is used when knowing whether the condition returned true or max time occured.
function SleepUntilReturnSeconds(condition:ifunction, evalTime:number, maxTime:number):boolean
	SleepUntilSeconds(condition, evalTime, maxTime);
	return condition();
end

function SleepOneFrame():void
	Sleep(1);
end

-- DEPRECATED(use SleepSeconds() instead).
function sleep_s( r_time:number ):void
	SleepSeconds(r_time);
end

-- DEPRECATED(use SleepRandSeconds() instead).
function sleep_rand_s( r_min:number, r_max:number ):void
	SleepRandomSeconds(r_min, r_max);
end

-- DEPRECATED(use Game_TimeApproxSecondsToFrames instead, best to write your script so that it isn't dependent on the frame rate).
function seconds_to_frames( r_seconds:number ):number
	return Game_TimeApproxSecondsToFrames(r_seconds);
end

-- DEPRECATED(use Game_TimeApproxFramesToSeconds instead, best to write your script so that it isn't dependent on the frame rate).
function frames_to_seconds( l_frames:number ):number
	return Game_TimeApproxFramesToSeconds(l_frames);
end

-- DEPRECATED, do not use.
-- The target approximate framerate can be obtained as Game_TimeApproxSecondsToFrames(1), but the 
-- game might not be running at that rate (unlocked frame rate/hitches).
function n_fps( ):number
	return Game_TimeApproxSecondsToFrames(1.0);
end


-- =================================================================================================
-- Creates an ifunction wrapper for a cfunction, so that it can be used as an argument to functions
-- that expect an ifunction, such as RegisterEvent, RunCommandScript, ParcelCreateThread
function ToIfunction(cfunc):ifunction
	return function(...) cfunc(...) end;
end



-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- param_default
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- === param_default: allows the user to pass in a list of "default" values, the first non-nil value will be returned
-- RETURN: the first non nil value in the arguement list
function param_default(...)
	if type(arg) == "table" then
		for key, value in ipairs(arg) do
			return value;
		end
		for key, value in pairs(arg) do
			return value;
		end
	end
	return arg;
end



--********************************************
--probably SERVER from this point on UNTIL THE VERY BOTTOM


-- =================================================================================================
-- DPRINT
-- =================================================================================================
global b_dprint:boolean = false;

function dprint(...):void
	if b_dprint then
		print(unpack(arg));
	end
end

function dprint_if( b_if:boolean, s:string ):void
	if b_if then
		dprint(s);
	end
end

function dprint_if_else( b_if:boolean, s_true:string, s_false:string ):void
	if b_if then
		dprint(s_true);
	else
		dprint(s_false);
	end
end

function dprint_enable( b_enable:boolean ):void
	b_dprint = b_enable;
	dprint_if(b_enable, "dprint_enable");
end

-- === Shows temp text -- useful if there's not TTS or narrative
--			content = a string of text you want to show
--			n_time = the amount of time you want the text to show (nil is 2)
--			color = the color of the text:
--				red, blue, green, white, black - default is green
--	RETURNS:  void
function ShowTempText (content:string, n_time:number, color:string)
	n_time = n_time or 2;
	if color == "red" then
		sys_temp_text_defaults(1, 0, 0);
	elseif color == "blue" then
		sys_temp_text_defaults(0, 1, 0);
	elseif color == "green" then
		sys_temp_text_defaults(0, 0, 1);
	elseif color == "white" then
		sys_temp_text_defaults(1, 1, 1);
	elseif color == "black" then
		sys_temp_text_defaults(0, 0, 0);
	elseif color == nil then
		sys_temp_text_defaults();
	else
		sys_temp_text_defaults();
	end
	
	sys_temp_text (content, n_time);
end

function sys_temp_text_defaults(red:number, green:number, blue:number):void
	
	red = red or 0.22;
	green = green or 0.0;
	blue = blue or 0.77;
	set_text_defaults();
	-- color, scale, life, font
	set_text_color(1, red, blue, green);
	--set_text_color(1, 0.22, 0.77, 0.0);
	
	set_text_font(FONT_ID.terminal);
	set_text_scale(1.5);
	-- alignments
	set_text_alignment(TEXT_ALIGNMENT.bottom);
	set_text_margins(0.05, 0.0, 0.05, 0.1);
	set_text_indents(0, 0);
	set_text_justification(TEXT_JUSTIFICATION.center);
	set_text_wrap(true, true);
	-- shadow
	set_text_shadow_style(TEXT_DROP_SHADOW.drop);
	set_text_shadow_color(1, 0, 0, 0);
end

global temp_text_index:number = 0;
function sys_temp_text( content:string, r_time:number ):void
	Text_SetLifespan(r_time);
	--show_text(content);
	temp_text_index = show_text_index(temp_text_index, content);
end

global k_emptyStringId = get_string_id_from_string("");

function stringIdIsNullOrEmpty(stringId:string_id):boolean
	return stringId == nil or stringId == k_emptyStringId;
end

function stringIsNullOrEmpty(string:string):boolean
	return string == nil or string == "";
end
function stringExtractDigits(s)
    return tostring(s):gsub( "%D+", "" );
end
function stringRemoveDigits(s)
    return tostring(s):gsub( "%d+", "" );
end
function stringExtractChars(s)
    return tostring(s):gsub( "%A+", "" );
end
function stringRemoveChars(s)
    return tostring(s):gsub( "%a+", "" );
end
function stringRemoveWhiteSpace(s)
    return tostring(s):gsub( "%s+", "" );
end

-- FUNCTION: RatioToRange ---------------------------------------------------------------------------
--	Takes a ratio and binds it between min and max range
-- RETURN:  min & max = nil; return ratio
--          min = number & max = nil; return integer 1 to min
--          min & max = number; return the ratio between min & max range
-- NOTE:    Range integer values are "distributed integers" attempting to spread the ratio "relatively" evenly across the range
-- ----------------------------------------------------------------------------------------------------
function RatioToRange( ratio:number, min:number, max:number ):number

    -- nil  returns ratio
    if ( (min == nil) and (max == nil) ) then
        return ratio;
    end

    -- fix rangevalues
    if ( max == nil ) then
        max = min;
        min = 1;
    elseif ( min == nil ) then
        min = 1;
    end

    -- safely returns value if min/max inverted
    if ( min > max ) then
        return RatioToRange( ratio, max, min );
    end

    -- return the ratio of the range with integer distribution (min & max get same weight; roughly)
    --      There may be a better mathmatical way to do this but the long decimal is the precision of this functionality to help give the lower and upper range the same (well similar)
    --      chance as all numbers between, it's error of margin for the upper range is 0.000000000000001

    return math.floor( min + (ratio * (max - min + 0.999999999999999)) ); 

end

-- FUNCTION: random_ratio ---------------------------------------------------------------------------
--	Simple function to return a random ratio of 0.0 to 1.0
-- RETURN: ratio; 0.0 to 1.0
function random_ratio():number
    return real_random_range(0.0, 1.0);
end

--       _______. _______ .______     ____    ____  _______ .______      
--      /       ||   ____||   _  \    \   \  /   / |   ____||   _  \     
--     |   (----`|  |__   |  |_)  |    \   \/   /  |  |__   |  |_)  |    
--      \   \    |   __|  |      /      \      /   |   __|  |      /     
--  .----)   |   |  |____ |  |\  \----.  \    /    |  |____ |  |\  \----.
--  |_______/    |_______|| _| `._____|   \__/     |_______|| _| `._____|
--                                                                       


--## SERVER
global PauseBool = false;

function PauseGame(bool:boolean):void
	PauseBool = bool or not PauseBool;
	print ("PAUSING THE GAME", PauseBool);
	Game_TimeSetPaused(PauseBool);
end


--- == teleport all valid players to a location
function TeleportAllPlayers(warp_point:location):void
	for i, val in ipairs (PLAYERS.active) do
		object_teleport(val, warp_point);
	end
end


-- Globals 
global data_mine_mission_segment:string="";

-- Difficulty level scripts 
function IsDifficultyLegendary():boolean
	return game_difficulty_get_real() == DIFFICULTY.legendary;
end

function IsDifficultyHeroic():boolean
	return game_difficulty_get_real() == DIFFICULTY.heroic;
end

function IsDifficultyNormal():boolean
	return game_difficulty_get_real() <= DIFFICULTY.normal;
end

--fades the vehicle out over scaleTime or 5 seconds and then destroys it
function Vehicle_ScaleAndDestroy(vehicle:object, scaleTime:number):void
	scaleTime = scaleTime or 5;
	Object_SetScale(vehicle, 0.01, scaleTime);
	SleepSeconds(scaleTime);
	object_destroy(vehicle);
end


--to get the number of ai passengers in a vehicle
function Vehicle_GetRiderCount(vehicle:object):number
	return list_count(vehicle_riders(vehicle));
end

--return the driver of a vehicle assuming only one vehicle in squad
function AI_GetVehicleDriver(squad:ai):ai
	return object_get_ai(vehicle_driver(ai_vehicle_get_from_squad(squad, 0)));
end

-- =======================================================
-- =======================================================
function AreObjectsWithinDistanceOfObject(testObjects:object_list, distance:number, targetObject:object):boolean
	local actualDistance:number = objects_distance_to_point(testObjects, targetObject);

	return (actualDistance >= 0 and actualDistance < distance);
end

function Object_GetPositionVector(targetObject:object):vector
	local objectPosition:location = Object_GetPosition(targetObject);
	if (objectPosition ~= nil) then
		return objectPosition.vector;
	end
	return nil;
end
-- =================================================================================================
-- Time utilities (server)
-- =================================================================================================

-- Sleeps until an event of eventType is triggered on the onItem
-- eventType: The type of event to wait for. Must be a member of the g_eventTypes (see GlobalCallbackSystem.lua for the complete list)
-- onItem: The object to listen for events on
-- timeout: The maximum time to wait for the event (optional)
-- RETURNS: An object containing information from the event. The composition depends on the event type.
--    note: This function returns nil if the sleep times out. Remember to check for nil if you use the optional timeout parameter
function SleepUntilEvent(eventType:number, onItem, timeout:number):any
	local fired: boolean = false;
	local results = nil;
	local eventCallback = function(eventArgs): void
		results = eventArgs;
		fired = true;
	end
	RegisterEvent(eventType, eventCallback, onItem);

	-- We rely on an object gc callback to make sure UnregisterEvent is always called in case
	-- a lua thread calls this function. We can't call UnregisterEvent at the end of this function
	-- because the thread, which calls this function and waiting on sleep below, could be killed.
	local sentinel = newproxy(true);
	getmetatable(sentinel).__gc = function(): void
		-- The cleanup code has to be run in its own thread because the game crashes sometimes otherwise
		CreateThread(UnregisterEvent, eventType, eventCallback, onItem);
	end

	SleepUntilSeconds([|fired == true], 0.1, timeout);
	return results;
end

-- =====  SleepUntilVolume
-- will sleep until ANY player is inside an activation_volume.  A condition can also be passed.
-- aVolume = the volume to check.
-- condition = the condition that must also be true.  Defaults to just return true;  The table of players inside the volume is passed to this in case logic needs to be run against them.
-- frequency = the frequency in seconds to check the condition and volume.
-- timeout = it will return after this many seconds if this parameter is set.
-- RETURNS - true if there is a player in the volume and the condition is met if there is one.  false if the timeout is reached.
function SleepUntilVolume(aVolume:activation_volume, condition:ifunction, frequency:number, timeout:number):boolean
	frequency = frequency or 0.01;
	condition = condition or [|true];
	return SleepUntilReturnSeconds([local aVolumePlayers = ActivationVolume_GetPlayers(aVolume); | aVolumePlayers ~= nil and #aVolumePlayers > 0 and condition(aVolumePlayers)], frequency, timeout);
end

-- =====  SleepUntilVolumeAll
-- Will sleep until ALL players are inside a trigger volume.  A condition can also be passed.
-- aVolume = the volume to check.
-- condition = the condition that must also be true.  Defaults to just return true; 
-- frequency = the frequency in seconds to check the condition and volume.
-- timeout = it will return after this many seconds if this parameter is set.
-- RETURNS - true if ALL players are in the volume and the condition is met if there is one.  false if the timeout is reached.
function SleepUntilVolumeAll(aVolume:volume, condition:ifunction, frequency:number, timeout:number):boolean
	frequency = frequency or 0.01;
	condition = condition or [|true];
	return SleepUntilReturnSeconds([|volume_test_players_all(aVolume) and condition()], frequency, timeout);
end

-- =====  SleepUntilReturnAISquad
-- Will sleep until the squad for the handle returns successfully.
-- squadHandle = the handle to check for squad validity
-- frequency = the frequency in seconds to check the handle
-- timeout = it will return after this many seconds if this parameter is set.
-- RETURNS - the squad associated with the handle, will return nil if the timeout is met without succesfully finding a handle
function SleepUntilReturnAISquad(squadHandle:handle, frequency:number, timeout:number):ai
	frequency = frequency or 0.01;
	SleepUntilSeconds([| AI_GetAISquadFromSquadInstance(squadHandle)], frequency, timeout);
	return AI_GetAISquadFromSquadInstance(squadHandle);
end


-- =================================================================================================
-- =================================================================================================
-- RECENT DAMAGE
-- =================================================================================================
-- =================================================================================================
function Object_GetRecentDamageTotal(obj_object:object):number
	return object_get_recent_body_damage(obj_object) + object_get_recent_shield_damage(obj_object);
end



-- ===== DO NOT DELETE THIS EVER ===================
function startup.beginning_mission_segment()
	data_mine_set_mission_segment("mission_start");
end


-- =================================================================================================
-- CHAPTER TITLES
-- =================================================================================================

-- === Letterboxes the screen, hides HUD (optionally), shows chapter titles, un-hides HUD (optional), un-letterboxes the screen
--			title = chapter title to show
--			shouldHideHud = hide the hud during the letterbox
--			titleDisplayTime = how long the chapter title is up
--			titleFadeInTime = how long after hiding the HUD before showing the title
--			titleFadeOutTime = how long after the letterbox before showing the HUD
--	RETURNS:  void
function ShowChapterTitle(title:title, shouldHideHud:boolean, titleDisplayTime:number, titleFadeInTime:number, titleFadeOutTime:number ):void
	shouldHideHud = shouldHideHud or true;
	titleDisplayTime = titleDisplayTime or 6.5;
	titleFadeInTime = titleFadeInTime or 1.5;
	titleFadeOutTime = titleFadeOutTime or 1.5;
	-- show letterbox
	cinematic_show_letterbox(true);

	if shouldHideHud == true then
		RunClientScript("HudShowClient", false);
	end
	SleepSeconds(titleFadeInTime);

	cinematic_set_title(title);
	SleepSeconds(titleDisplayTime);
	-- hide letterbox	
	cinematic_show_letterbox(false);
	
	
	SleepSeconds(titleFadeOutTime);
	
	if shouldHideHud == true then
		RunClientScript ("HudShowClient", true);
	end
end

-- =================================================================================================
-- Client Print Functions
-- =================================================================================================

-- Prints whatever arguments are passed on all the clients
--	... = whatever you want to print on the client (note that tables and some other properties are not sent to the client)
--	example: ClientPrint("the object is:", OBJECTS.foo);
--	this will print on the client    the object is: object <some hex number> foo
-- RETURNS:  void
function ClientPrint(...):void
	RunClientScript("ClientPrint", ...);
end

-- Prints whatever arguments are passed on the specified player
--	... = whatever you want to print on the client (note that tables and some other properties are not sent to the client)
--	example: ClientPrint("the object is:", OBJECTS.foo);
--	this will print on the client    the object is: object <some hex number> foo
-- RETURNS:  void
function ClientPrintOnPlayer(player:player, ...):void
	RunClientScript("ClientPrintOnPlayer", player, ...);
end


-- =================================================================================================
-- NETWORKED PROPERTY UTILITIES
-- =================================================================================================

-- Global networked properties
function CreateBooleanNetworkProperty(name:string, value:boolean):networked_property
	local newProperty:networked_property = Engine_CreateNetworkedProperty(name);
	if (newProperty ~= nil) then
		NetworkedProperty_SetBooleanProperty(newProperty, value);
	end
	return newProperty;
end

function CreateFloatNetworkProperty(name:string, value:number):networked_property
	local newProperty:networked_property = Engine_CreateNetworkedProperty(name);
	if (newProperty ~= nil) then
		NetworkedProperty_SetFloatProperty(newProperty, value);
	end
	return newProperty;
end

function CreateIntNetworkProperty(name:string, value:number):networked_property
	local newProperty:networked_property = Engine_CreateNetworkedProperty(name);
	if (newProperty ~= nil) then
		NetworkedProperty_SetIntProperty(newProperty, value);
	end
	return newProperty;
end

function CreateStringIdNetworkProperty(name:string, value:string_id):networked_property
	local newProperty:networked_property = Engine_CreateNetworkedProperty(name);
	if (newProperty ~= nil) then
		NetworkedProperty_SetStringIdProperty(newProperty, value);
	end
	return newProperty;
end

-- Player-specific networked properties
function CreatePlayerBooleanNetworkProperty(name:string, initialValue:boolean):networked_property
	local newProperty:networked_property = Engine_CreateNetworkedProperty(name);
	if (newProperty ~= nil) then
		NetworkedProperty_SetPlayerBoolForAllPlayers(newProperty, initialValue);
	end
	return newProperty;
end

function CreatePlayerFloatNetworkProperty(name:string, initialValue:number):networked_property
	initialValue = initialValue or 0;
	local newProperty:networked_property = Engine_CreateNetworkedProperty(name);
	if (newProperty ~= nil) then
		NetworkedProperty_SetPlayerFloatForAllPlayers(newProperty, initialValue);
	end
	return newProperty;
end

function CreatePlayerIntNetworkProperty(name:string, initialValue:number):networked_property
	initialValue = initialValue or 0;
	local newProperty:networked_property = Engine_CreateNetworkedProperty(name);
	if (newProperty ~= nil) then
		NetworkedProperty_SetPlayerIntForAllPlayers(newProperty, initialValue);
	end
	return newProperty;
end

function CreatePlayerStringIdNetworkProperty(name:string, initialValue:string_id):networked_property
	initialValue = initialValue or NONE;
	local newProperty:networked_property = Engine_CreateNetworkedProperty(name);
	if (newProperty ~= nil) then
		NetworkedProperty_SetPlayerStringIdForAllPlayers(newProperty, initialValue);
	end
	return newProperty;
end


-- Deletion
function DeleteNetworkProperty(property:networked_property):void
	if (property ~= nil) then
		NetworkedProperty_Delete(property)
	end
end

-- =================================================================================================
-- CLIENT functions
-- =================================================================================================

--## CLIENT
function remoteClient.HudShowClient (bool:boolean)
	hud_show (bool);
end

function remoteClient.ClientPrint(...)
	print(...);
end

function remoteClient.ClientPrintOnPlayer(player, ...)
	if PlayerIsLocal(player) then
		print(...);
	end
end