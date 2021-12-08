--## SERVER

-- DEATH PROPERTIES

global PlayerDeathMalleableProperties = {};

function MalleablePropertyUntilDeathTracking(thePlayer:player, malleablePropertyID)
	if(PlayerDeathMalleableProperties[thePlayer] == nil) then
		PlayerDeathMalleableProperties[thePlayer] = {};
		RegisterEvent(g_eventTypes.deathEvent, PlayerMalleablePropertyDeathWatcher, Player_GetUnit(thePlayer));
	end
	
	PlayerDeathMalleableProperties[thePlayer][malleablePropertyID] = malleablePropertyID;
	
	return malleablePropertyID;
end

function AddPlayerMalleablePropertyUntilDeathInt(thePlayer:player, name:string, value:number):number
	if(Player_GetUnit(thePlayer) == nil) then
		return nil;
	end
	
	local malleablePropertyID = AddPlayerTimedMalleablePropertyModifierInt(name, 0, value, thePlayer);
	
	return MalleablePropertyUntilDeathTracking(thePlayer, malleablePropertyID);
end


function AddPlayerMalleablePropertyUntilDeathBool(thePlayer:player, name:string, value:boolean):number
	if(Player_GetUnit(thePlayer) == nil) then
		return nil;
	end
	
	local malleablePropertyID = AddPlayerTimedMalleablePropertyModifierBool(name, 0, value, thePlayer);
	
	return MalleablePropertyUntilDeathTracking(thePlayer, malleablePropertyID);
end

function AddPlayerMalleablePropertyUntilDeath(thePlayer:player, name:string, value:number):number
	if(Player_GetUnit(thePlayer) == nil) then
		return nil;
	end
	
	local malleablePropertyID = AddPlayerTimedMalleablePropertyModifier(name, 0, value, thePlayer);
	
	return MalleablePropertyUntilDeathTracking(thePlayer, malleablePropertyID);
end

function RemovePlayerMalleablePropertyUntilDeath(thePlayer:player, malleablePropertyID:number)
	RemoveMalleablePropertyModifier(malleablePropertyID);
	if(thePlayer ~= nil and PlayerDeathMalleableProperties[thePlayer]) then
		PlayerDeathMalleableProperties[thePlayer][malleablePropertyID] = nil;
	end
end

function PlayerMalleablePropertyHeroChangedWatcher(thePlayer, theHero)
	CleanupMalleableDeathProperties(thePlayer);
end


function PlayerMalleablePropertyDeathWatcher(deathEvent)
	CleanupMalleableDeathProperties(deathEvent.deadPlayer);
	UnregisterEvent(g_eventTypes.deathEvent, PlayerMalleablePropertyDeathWatcher, deathEvent.deadObject);
end

function CleanupMalleableDeathProperties(thePlayer)
	if(PlayerDeathMalleableProperties == nil or PlayerDeathMalleableProperties[thePlayer] == nil) then
		return;
	end
	
	for key, value in pairs(PlayerDeathMalleableProperties[thePlayer]) do
		if(value ~= nil) then
			RemoveMalleablePropertyModifier(value);
		end
	end
	
	PlayerDeathMalleableProperties[thePlayer] = nil;
end


-- =================================================================================================
-- =================================================================================================
-- ABILITIES
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- ABILITY TIMER
-- -------------------------------------------------------------------------------------------------
-- variables
global l_ability_timer_thread:thread=nil;
global l_ability_timer_active_start:number=0;
global r_ability_timer_active_time:number=0.0;
global l_ability_timer_inactive_start:number=0;
global r_ability_timer_inactive_time:number=0.0;
global l_ability_timer_enabled_time:number=0;

-- functions
-- === f_ability_timer_start::: Starts the equipment watch
function f_ability_timer_start( b_reset:boolean ):void
	if l_ability_timer_thread == nil then
		dprint("::: f_ability_timer_start :::");
		l_ability_timer_thread = CreateThread(f_ability_timer_loop);
	end
	if b_reset then
		f_ability_timer_reset();
	end
	l_ability_timer_enabled_time = game_tick_get();
end

-- === f_ability_timer_loop::: Watches the amount of time the players have used the equipment
function f_ability_timer_loop():void
	dprint("::: f_ability_timer_loop :::");
	repeat
		Sleep(1);
		-- get what to watch for
		b_active_fc15025c = player_action_test_equipment();
		-- update all the timers to their current status
		f_ability_timer_update();
		if b_active_fc15025c then
			-- start the timer
			l_ability_timer_active_start = game_tick_get();
			-- reset the other timer
			l_ability_timer_inactive_start = 0;
		else
			-- start the timer
			l_ability_timer_inactive_start = game_tick_get();
			-- reset the other timer
			l_ability_timer_active_start = 0;
		end
		SleepUntil([| player_action_test_equipment()~=b_active_fc15025c ], 1);
	until false;
end
global b_active_fc15025c:boolean=false;

-- === f_ability_timer_update::: Updates the time equipment active/inactive
function f_ability_timer_update():void
	--	dprint( "::: f_ability_timer_update :::" );
	-- update the timers
	f_ability_timer_update_active();
	f_ability_timer_update_inactive();
end

-- === f_ability_timer_update_active::: Updates the time equipment active
function f_ability_timer_update_active():void
	--	dprint( "::: f_ability_timer_update_active :::" );
	-- check if time needs to be added to active
	if l_ability_timer_active_start > 0 then
		r_ability_timer_active_time = r_ability_timer_active_time + frames_to_seconds(game_tick_get() - l_ability_timer_active_start);
		l_ability_timer_active_start = game_tick_get();
	end
end

-- === f_ability_timer_update_inactive::: Updates the time equipment inactive
function f_ability_timer_update_inactive():void
	--	dprint( "::: f_ability_timer_update_inactive :::" );
	-- check if time needs to be added to inactive
	if l_ability_timer_inactive_start > 0 then
		r_ability_timer_inactive_time = r_ability_timer_inactive_time + frames_to_seconds(game_tick_get() - l_ability_timer_inactive_start);
		l_ability_timer_inactive_start = game_tick_get();
	end
end

-- === f_ability_timer_check_active::: Updates and returns the time equipment used
function f_ability_timer_check_active():number
	--	dprint( "::: f_ability_timer_check_active :::" );
	-- update the timer based on current time
	f_ability_timer_update_active();
	return r_ability_timer_active_time;
end

-- RETURN
-- === f_ability_timer_check_inactive::: Updates and returns the time equipment used
function f_ability_timer_check_inactive():number
	--	dprint( "::: f_ability_timer_check_inactive :::" );
	-- update the timer based on current time
	f_ability_timer_update_inactive();
	return r_ability_timer_inactive_time;
end

-- RETURN
-- === f_ability_timer_reset::: Reset the timer of the equipment watch
function f_ability_timer_reset():void
	dprint("::: f_ability_timer_reset :::");
	-- reset both
	f_ability_timer_reset_active();
	f_ability_timer_reset_inactive();
end

-- === f_ability_timer_reset::: Reset the timer of the equipment watch active
function f_ability_timer_reset_active():void
	dprint("::: f_ability_timer_reset :::");
	if l_ability_timer_active_start~=0 then
		l_ability_timer_active_start = game_tick_get();
	end
	r_ability_timer_active_time = 0.0;
end

-- === f_ability_timer_reset_inactive::: Reset the timer of the equipment watch inactive
function f_ability_timer_reset_inactive():void
	dprint("::: f_ability_timer_reset_inactive :::");
	if l_ability_timer_inactive_start~=0 then
		l_ability_timer_inactive_start = game_tick_get();
	end
	r_ability_timer_inactive_time = 0.0;
end

-- === f_ability_timer_stop::: Stops the equipment watch
function f_ability_timer_stop():void
	if l_ability_timer_thread~=nil then
		dprint("::: f_ability_timer_stop :::");
		-- kill the thread
		KillThread(l_ability_timer_thread);
		-- update timers
		f_ability_timer_update();
		-- set the watch variables to not watching
		r_ability_timer_active_time = 0;
		r_ability_timer_inactive_time = 0;
		-- since the thread was killed, reset the variable
		l_ability_timer_thread = nil;
		l_ability_timer_enabled_time = game_tick_get() - l_ability_timer_enabled_time;
	end
end

-- === f_ability_timer_enabled::: Returns if the activity timer is currently enabled
function f_ability_timer_enabled():boolean
	return l_ability_timer_thread~=nil;
end

-- === f_ability_timer_enabled_time::: Returns the amount of time in seconds the ability timer has been active, or was active if it's not enabled anymore
function f_ability_timer_enabled_time():number
	if f_ability_timer_enabled() then
		return frames_to_seconds(game_tick_get() - l_ability_timer_enabled_time);
	else
		return frames_to_seconds(l_ability_timer_enabled_time);
	end
end

-- -------------------------------------------------------------------------------------------------
-- ABILITY CHECK
-- -------------------------------------------------------------------------------------------------
function f_ability_check_players_all( od_equipment:tag ):boolean
	-- dead players are ignored
	return player_count() > 0 and (unit_get_health(PLAYERS.player0) <= 0.0 or unit_has_equipment(PLAYERS.player0, od_equipment)) and (unit_get_health(PLAYERS.player1) <= 0.0 or unit_has_equipment(PLAYERS.player1, od_equipment)) and (unit_get_health(PLAYERS.player2) <= 0.0 or unit_has_equipment(PLAYERS.player2, od_equipment)) and (unit_get_health(PLAYERS.player3) <= 0.0 or unit_has_equipment(PLAYERS.player3, od_equipment));
end

-- -------------------------------------------------------------------------------------------------
-- LIVING/HEALTH/SHIELD
-- -------------------------------------------------------------------------------------------------
-- === f_ability_player_cnt: Gets how many players have an equipment
--	RETURNS:  short; total number of players with the equipment
function f_ability_player_cnt( od_equipment:tag ):number
	local s_cnt:number=0;
	if unit_has_equipment(PLAYERS.player0, od_equipment) then
		s_cnt = s_cnt + 1;
	end
	if unit_has_equipment(PLAYERS.player1, od_equipment) then
		s_cnt = s_cnt + 1;
	end
	if unit_has_equipment(PLAYERS.player2, od_equipment) then
		s_cnt = s_cnt + 1;
	end
	if unit_has_equipment(PLAYERS.player3, od_equipment) then
		s_cnt = s_cnt + 1;
	end
	return s_cnt;
end

-- -------------------------------------------------------------------------------------------------
-- ROLES READABILITY - Please don't freak out, this is temporary and needed! If you have issues contact "Elan Gleiber" or "Tim Temmerman"
-- -------------------------------------------------------------------------------------------------

global Readability_RoleIconsOn = true;
global Readability_RandomFXOn = false;
global Readability_RandomGEOOn = false;

global Readability_RandomTable:table = nil;
global Readability_FXTable:table = {
	[0] = "no",
	[1] = "cosmetic_flame_suite",
	[2] = "mythic_unicorn_suite",
	[3] = "cosmetic_digital_suite" ,
	[4] = "cosmetic_ice_suite",
	[5] = "mythic_samurai_suite"
};
global Readability_GEOTable:table = {
	[0] = "no",
	[1] = "_01",
	[2] = "_02"
};

function SetRoleIcons_ON()
	Readability_RoleIconsOn = true;
end

function SetRoleIcons_OFF()
	Readability_RoleIconsOn = false;
end

function SetRoleRandomFX_ON()
	Readability_RandomFXOn = true;
end

function SetRoleRandomFX_OFF()
	Readability_RandomFXOn = false;
end

function SetRoleRandomGEO_ON()
	Readability_RandomGEOOn = true;
end

function SetRoleRandomGEO_OFF()
	Readability_RandomGEOOn = false;
end

function SetRoleRandomStuff()
	Readability_RandomTable = {};

	Readability_RandomTable[0] = {};
	Readability_RandomTable[0].fx = Readability_FXTable[random_range(1, 5)];
	Readability_RandomTable[0].geo = Readability_GEOTable[random_range(0, 2)];

	Readability_RandomTable[1] = {};
	Readability_RandomTable[1].fx = Readability_FXTable[random_range(1, 5)];
	Readability_RandomTable[1].geo = Readability_GEOTable[random_range(0, 2)];

	Readability_RandomTable[2] = {};
	Readability_RandomTable[2].fx = Readability_FXTable[random_range(1, 5)];
	Readability_RandomTable[2].geo = Readability_GEOTable[random_range(0, 2)];

	Readability_RandomTable[3] = {};
	Readability_RandomTable[3].fx = Readability_FXTable[random_range(1, 5)];
	Readability_RandomTable[3].geo = Readability_GEOTable[random_range(0, 2)];

	Readability_RandomTable[4] = {};
	Readability_RandomTable[4].fx = Readability_FXTable[random_range(1, 5)];
	Readability_RandomTable[4].geo = Readability_GEOTable[random_range(0, 2)];

	Readability_RandomTable[5] = {};
	Readability_RandomTable[5].fx = Readability_FXTable[random_range(1, 5)];
	Readability_RandomTable[5].geo = Readability_GEOTable[random_range(0, 2)];

	Readability_RandomTable[6] = {};
	Readability_RandomTable[6].fx = Readability_FXTable[random_range(1, 5)];
	Readability_RandomTable[6].geo = Readability_GEOTable[random_range(0, 2)];

	Readability_RandomTable[7] = {};
	Readability_RandomTable[7].fx = Readability_FXTable[random_range(1, 5)];
	Readability_RandomTable[7].geo = Readability_GEOTable[random_range(0, 2)];

	local prevFX = Readability_RandomFXOn;
	local prevGEO = Readability_RandomGEOOn;

	SetRoleRandomFX_OFF();
	SetRoleRandomGEO_OFF();

	SleepSeconds(1);

	if(prevFX) then
		SetRoleRandomFX_ON();
	end

	if(prevGEO) then
		SetRoleRandomGEO_ON();
	end
end

global TestHealthRegen_ON = false;

function SetTestHealthRegen_ON()
	TestHealthRegen_ON = true;
end

function SetTestHealthRegen_OFF()
	TestHealthRegen_ON = false;
end