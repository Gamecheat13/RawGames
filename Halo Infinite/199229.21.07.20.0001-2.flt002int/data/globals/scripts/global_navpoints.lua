--## SERVER

REQUIRES('globals/scripts/callbacks/GlobalCallbacks.lua')
REQUIRES('globals/scripts/global_parcels.lua')

--  _______  __        ______   .______        ___       __         .__   __.      ___   ____    ____ .______     ______    __  .__   __. .___________.    _______.
-- /  _____||  |      /  __  \  |   _  \      /   \     |  |        |  \ |  |     /   \  \   \  /   / |   _  \   /  __  \  |  | |  \ |  | |           |   /       |
--|  |  __  |  |     |  |  |  | |  |_)  |    /  ^  \    |  |        |   \|  |    /  ^  \  \   \/   /  |  |_)  | |  |  |  | |  | |   \|  | `---|  |----`  |   (----`
--|  | |_ | |  |     |  |  |  | |   _  <    /  /_\  \   |  |        |  . `  |   /  /_\  \  \      /   |   ___/  |  |  |  | |  | |  . `  |     |  |        \   \    
--|  |__| | |  `----.|  `--'  | |  |_)  |  /  _____  \  |  `----.   |  |\   |  /  _____  \  \    /    |  |      |  `--'  | |  | |  |\   |     |  |    .----)   |   
-- \______| |_______| \______/  |______/  /__/     \__\ |_______|   |__| \__| /__/     \__\  \__/     | _|       \______/  |__| |__| \__|     |__|    |_______/    
--                                                                                                                                                                 
--                                                                                                                                                                 
-- =================================================================================================
-- Navpoints (SERVER)
-- =================================================================================================

--ENUM to be reference by any parcel that uses an object that is carried by a player. Used to set different type of Navpoint Visibility Functionality.
global carrierNavVisTypeEnum = table.makeEnum
{
	onSpotted = 0,
	alwaysVisible = 1,
	neverVisible = 2,
	alwaysVisibleInHand = 3
}

function Navpoint_FindFriendlyColorForTeam(team:mp_team):color_rgba
	-- Find a player on the supplied team, and use that player to get the friendly color
	for _, player in hpairs(PLAYERS.active) do
		if (Player_GetMultiplayerTeam(player) == team) then
			return UI_GetBitmapColorForTeam(player, team);
		end
	end

	return nil;
end

function Navpoint_FindHostileColorForTeam(team:mp_team):color_rgba
	-- Find a player NOT on the supplied team, and use that player to get the hostile color
	for _, player in hpairs(PLAYERS.active) do
		if (Player_GetMultiplayerTeam(player) ~= team) then
			return UI_GetBitmapColorForTeam(player, team);
		end
	end

	return nil;
end

-- === Tells an object to "ping" itself.  Shows the navmarker, outline, etc that shows when the object is pinged
--			objectArg = the object that is told to ping
--	RETURNS:  void
function ActivateSpartanTrackingForObject(objectArg:object):void
	for _, player in ipairs(PLAYERS.active) do
		--simulate a ping for all players because activate spartan tracking custom only pings 1 object at a time
		Player_ActivateSpartanTracking(player);
		--not sure if we want to keep this for later
		--Player_ActivateSpartanTrackingMark(player, TAG('globals\globals\defaultcustomping.spartantrackingpingdefinition'), objectArg);
	end
end

-- === creates anew an object name, puts a navpoint on that object and leaves the visibility default.  Default type is white "generic_subobjective"
--			obj_name = object name
--			type = blip type (see ui\hud_globals.user_interface_hud_globals_definition for nav types)
--			text = the text that is displayed by the navpoint (this should be a valid string_ID)
--			colors = a table of RGB references where each color is from 0-1.  Example: {1,0,0}
--	RETURNS:  navpoint
function NavpointCreateObjectCreate(obj_name:object_name, type:string_id, text:string_id, colors:color_rgba):navpoint
	local obj = object_create_anew(obj_name);
	if obj ~= nil then
		return NavpointCreateObject(obj, type, text, colors);
	else
		error ("incorrect object name passed into NavpointCreateObjectCreate");
	end
end
-- 
-- === put a navpoint on an object and leave the visibility default.  Default type is white "generic_subobjective"
--			obj = object
--			type = blip type (see ui\hud_globals.user_interface_hud_globals_definition for nav types)
--			text = the text that is displayed by the navpoint (this should be a valid string_ID)
--			colors = a table of RGB references where each color is from 0-1.  Example: {1,0,0}
--	RETURNS:  navpoint
function NavpointCreateObject(obj:object, type:string_id, text:string_id, colors:color_rgba):navpoint
	return NavpointCreateHelper(obj, type, text, colors);
end

-- === creates anew an object name, puts a navpoint on that object and shows it to all players, living or dead.  Default type is white "generic_subobjective"
--			obj_name = object name
--			type = blip type (see ui\hud_globals.user_interface_hud_globals_definition for nav types)
--			text = the text that is displayed by the navpoint (this should be a valid string_ID)
--			colors = a table of RGB references where each color is from 0-1.  Example: {1,0,0}
--	RETURNS:  navpoint
function NavpointShowObjectCreate(obj_name:object_name, type:string_id, text:string_id, colors:color_rgba):navpoint
	local obj = object_create_anew(obj_name);
	if obj ~= nil then
		return NavpointShowObject(obj, type, text, colors);
	else
		error ("incorrect object name passed into NavpointShowObjectCreate");
	end
end

function NavpointCreateHelper(item, type:string_id, text:string_id, colors:color_rgba):navpoint
	if item == nil then
		print("NavpointCreate: no valid item passed into NavpointCreateHelper");
		return nil;
	end
	type = type or "generic_subobjective";
	local id = Navpoint_Create (type);
	
	if GetEngineType(item) == "object" then
		Navpoint_SetObjectParent(id, item);
	else
		Navpoint_SetAbsolutePosition(id, ToLocation(item).vector);
	end
	
	if text then
		Navpoint_SetDisplayText(id, text);
	end
	
	--color is deprecated, but there are several calls that use it, so removing it is tricky
	--if colors then
		--Navpoint_SetColor (id, colors);
	--end
	
	--print(id);
	return id;
end

-- === put a navpoint on an object and show it to all players, living or dead.  Default type is white "generic_subobjective"
--			obj = object
--			type = blip type (see ui\hud_globals.user_interface_hud_globals_definition for nav types)
--			text = the text that is displayed by the navpoint (this should be a valid string_ID)
--			colors = a table of RGB references where each color is from 0-1.  Example: {1,0,0}
--	RETURNS:  navpoint
function NavpointShowObject(obj:object, type:string_id, text:string_id, colors:color_rgba):navpoint
	local id = NavpointCreateObject(obj, type, text, colors);

	--set player visiblity on all points
	NavpointShowAllPlayers(id);
	
	return id;
end

-- === put a navpoint on an object and DONT show it to players.  Default type is white "generic_subobjective"
--			obj = object
--			type = blip type (see ui\hud_globals.user_interface_hud_globals_definition for nav types)
--			text = the text that is displayed by the navpoint (this should be a valid string_ID)
--			colors = a table of RGB references where each color is from 0-1.  Example: {1,0,0}
--	RETURNS:  navpoint
function NavpointCreateAtLocation(loc, type:string_id, text:string_id, colors:color_rgba):navpoint
	return NavpointCreateHelper(loc, type, text, colors);
end

-- === put a navpoint on a location and show it to all players, living or dead.  Default type is white "generic_subobjective"
--			loc = any location type (object, location, cutscene_flag)
--			type = blip type (see ui\hud_globals.user_interface_hud_globals_definition for nav types)
--			text = the text that is displayed by the navpoint (this should be a valid string_ID)
--			colors = a table of RGB references where each color is from 0-1.  Example: {1,0,0}
--	RETURNS:  navpoint
function NavpointShowAtLocation(loc, type:string_id, text:string_id, colors:color_rgba):navpoint
	local id = NavpointCreateAtLocation(loc, type, text, colors);

	--set player visiblity on all points
	NavpointShowAllPlayers(id);
	
	return id;
end

-- === shows a navpoint to all players, living or dead
--			id = a navpoint id
function NavpointShowAllPlayers(id:navpoint)
	if id ~= nil then
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(id, true);
	end
end

-- === hides a navpoint from all players, living or dead
--			id = a navpoint id
function NavpointHideAllPlayers(id:navpoint)
	if id ~= nil then
		Navpoint_VisibilityFilter_SetPlayersAllDefaultFilter(id, false);
	end
end

--clear AI navpoints
function NavpointClear(nav:navpoint)

end

--function testnav()
--	local foo = ai_place_return(AI.sq_vent_1);
--	local sq = NavpointShowAllySquad(foo);
--	sleep_s(2);
--	ai_kill_all();
--	sleep_s(1);
--	NavpointShowAI(foo,"enemy", {1,0,0}, "ctf_flag_deliver");
--end

-- === put an "enemy" navpoint on all actors in a squad, show it to all players, living or dead
--	squad = ai squad
--	RETURNS:  table (object list) of navpoint ID's
function NavpointShowEnemySquad(squad:ai)
	local id_list = NavpointShowAI(squad, "enemy", color_rgba(1,0,0,1));
	return id_list;
end

-- === put an "ally" navpoint on all actors in a squad, show it to all players, living or dead
--	squad = ai squad
--	RETURNS:  table (object list) of navpoint ID's
function NavpointShowAllySquad(squad:ai)
	local id_list = NavpointShowAI(squad, "ally", color_rgba(0,0,1,1));
	return id_list;
end


-- === put a navpoint on all actors in a squad and show it to all players, living or dead.  Default type is "enemy"
--			squad = ai squad
--			blip_type = blip type (see ui\hud_globals.user_interface_hud_globals_definition for nav types)
--			text = the text that is displayed by the navpoint (this should be a valid string_ID)
--			colors = a color_rgba where each color is from 0-1.  Example: color_rgba(1,0,0,1)
--	RETURNS:  table (object list) of navpoint ID's
function NavpointShowAI(squad:ai, blip_type:string_id, colors:color_rgba, text:string_id)
	local id = nil;
	local id_list = {};
	local squad_list = ai_actors(squad);
	blip_type = blip_type or "enemy";
	for _, actor in pairs (squad_list) do
		id = NavpointShowObject (actor, blip_type, text, colors);
		
		RegisterEvent(g_eventTypes.deathEvent, NavpointDeathEvent, actor, id);
		id_list[#id_list + 1] = id;
	end
	
	return id_list;
end

--change from id_list when we have the group of objects
function NavpointClearAI(id_list)
	if id_list then
		for _, id in hpairs(id_list) do
			Navpoint_Delete(id);
		end
	end
end

function NavpointDeathEvent(deathEvent, id)
	Navpoint_Delete(id);
end

-- =================================================================================================
-- Flash object
-- =================================================================================================
function f_hud_flash_object_fov( hud_object_highlight:object ):void
	SleepUntil([| objects_can_see_object(PLAYERS.player0, hud_object_highlight, 25)
						or objects_can_see_object(PLAYERS.player1, hud_object_highlight, 25)
						or objects_can_see_object(PLAYERS.player2, hud_object_highlight, 25)
						or objects_can_see_object(PLAYERS.player3, hud_object_highlight, 25) ], 1);
	chud_debug_highlight_object_color_red = 1;
	chud_debug_highlight_object_color_green = 1;
	chud_debug_highlight_object_color_blue = 0;
	f_hud_flash_single(hud_object_highlight);
	f_hud_flash_single(hud_object_highlight);
	f_hud_flash_single(hud_object_highlight);
	object_destroy(hud_object_highlight);
end

function f_hud_flash_object( hud_object_highlight:object ):void
	chud_debug_highlight_object_color_red = 1;
	chud_debug_highlight_object_color_green = 1;
	chud_debug_highlight_object_color_blue = 0;
	f_hud_flash_single(hud_object_highlight);
	f_hud_flash_single(hud_object_highlight);
	f_hud_flash_single(hud_object_highlight);
	object_destroy(hud_object_highlight);
end

function f_hud_flash_single( hud_object_highlight:object ):void
	object_hide(hud_object_highlight, false);
	chud_debug_highlight_object = hud_object_highlight;
	Sleep(4);
	object_hide(hud_object_highlight, true);
	Sleep(5);
end

function f_hud_flash_single_nodestroy( hud_object_highlight:object ):void
	chud_debug_highlight_object = hud_object_highlight;
	Sleep(4);
	chud_debug_highlight_object = nil;
	Sleep(5);
end
-- =================================================================================================
-- BLIPS and DOTS
-- =================================================================================================

function f_blip_flag( f:flag, type:string_id, offset:number, title:string_id ):void
	-- DEPRECATED
end

function f_unblip_flag( f:flag ):void
	-- DEPRECATED
end

-- =================================================================================================
-- CALLOUT SCRIPTS
-- =================================================================================================

--## SERVER

global ObjectTrackerNavMarkerParcel = Parcel.MakeParcel{};

function ObjectTrackerNavMarkerParcel:New(obj:object, navMarkerType:string, navMarkerColor:color_rgba)
	local newParcel:table = ParcelParent(self);
	newParcel.obj = obj;
	newParcel.navMarkerColor = navMarkerColor;
	newParcel.navMarkerType = navMarkerType;

	return newParcel;
end

function ObjectTrackerNavMarkerParcel:shouldEnd()
	return self.isComplete;
end

function ObjectTrackerNavMarkerParcel:Run()	
	self.navPoint = NavpointShowObject(self.obj, self.navMarkerType, "", self.navMarkerColor);
	self:RegisterEventOnSelf(g_eventTypes.objectDeletedEvent, self.ObjectDestroyed, self.obj);
end

function ObjectTrackerNavMarkerParcel:ObjectDestroyed(eventArgs:ObjectDeletedStruct)
	self.isComplete = true;
end

function ObjectTrackerNavMarkerParcel:Shutdown()
	Navpoint_Delete(self.navPoint)
end

function ObjectTrackerNavMarkerParcel:MakeSubClass():table
	local class = ParcelParent(self);
	return class;
end

global VehicleInteractNavMarkerParcel = ObjectTrackerNavMarkerParcel:MakeSubClass();

function VehicleInteractNavMarkerParcel:Run()	
	ObjectTrackerNavMarkerParcel.Run(self);
	self:RegisterEventOnSelf(g_eventTypes.seatEnteredEvent, self.SeatEntered, self.obj);
end

function VehicleInteractNavMarkerParcel:SeatEntered(eventArgs:SeatEnteredEventStruct)
	if Object_IsPlayer(eventArgs.instigator) then 
		self.isComplete = true;
	end
end
