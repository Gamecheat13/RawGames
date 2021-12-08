REQUIRES('globals/scripts/callbacks/GlobalCallbacks.lua')
REQUIRES('globals/scripts/global_set.lua')

--## SERVER

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- AI HELPERS

--- == places AI and returns the ai that is spawned
-- RETURNS: the ai that is placed
function ai_place_return(ai_var:ai):ai
	ai_place (ai_var);
	return ai_var;
end
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
-- COMBAT STATUS
-- -------------------------------------------------------------------------------------------------

-- Here are the combat status variables declared in C
--[[
ACTOR_COMBAT_STATUS.Asleep		= 0;	asleep, braindead, etc.
ACTOR_COMBAT_STATUS.Idle		= 1;	no action
ACTOR_COMBAT_STATUS.Alert		= 2;	disregarded all orphans, or have none (postcombat)
ACTOR_COMBAT_STATUS.Active		= 3;	orphans in the area OR scripted to belive so
ACTOR_COMBAT_STATUS.Uninspected	= 4;	we have an orphan that we have not yet inspected
ACTOR_COMBAT_STATUS.Definite	= 5;	enemy whose location is definitely known (maybe not by us though)
ACTOR_COMBAT_STATUS.Certain		= 6;	enemy whose location we are certain about
ACTOR_COMBAT_STATUS.Visible		= 7;	enemy that we can see
ACTOR_COMBAT_STATUS.ClearLos	= 8;	enemy that we have a clear line-of-sight to
ACTOR_COMBAT_STATUS.Dangerous	= 9;	enemy who poses a threat to us
]]
-- === AI_IsIdle: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function AI_IsIdle(ai_test:ai):boolean
	return ai_combat_status_a_less_or_equal_b(ai_combat_status(ai_test), ACTOR_COMBAT_STATUS.Idle) and ai_spawn_count(ai_test) > 0;
end

-- === AI_IsNoncombat: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function AI_IsNoncombat( ai_test:ai ):boolean
	return ai_combat_status_a_less_or_equal_b(ai_combat_status(ai_test), ACTOR_COMBAT_STATUS.Alert) and ai_spawn_count(ai_test) > 0;
end

-- === AI_IsAggressive: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function AI_IsAggressive( ai_test:ai ):boolean
	return ai_combat_status_a_greater_than_b(ai_combat_status(ai_test), ACTOR_COMBAT_STATUS.Alert) and ai_spawn_count(ai_test) > 0;
end

-- === AI_IsDefinite: Checks if an ai has a definite combat status
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function AI_IsDefinite( ai_test:ai ):boolean
	return ai_combat_status_a_greater_or_equal_b(ai_combat_status(ai_test), ACTOR_COMBAT_STATUS.Definite) and ai_spawn_count(ai_test) > 0;
end

-- === AI_IsHunting: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function AI_IsHunting( ai_test:ai ):boolean
	return ai_combat_status_a_greater_or_equal_b(ai_combat_status(ai_test), ACTOR_COMBAT_STATUS.Active) and ai_combat_status_a_less_or_equal_b(ai_combat_status(ai_test), ACTOR_COMBAT_STATUS.Certain) and ai_spawn_count(ai_test) > 0;
end

-- === AI_SeesEnemy: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function AI_SeesEnemy( ai_test:ai ):boolean
	return ai_combat_status_a_greater_or_equal_b(ai_combat_status(ai_test), ACTOR_COMBAT_STATUS.Visible) and ai_spawn_count(ai_test) > 0;
end

-- === AI_IsDangerous: Checks if an AI is in a state
--			ai_test = AI to check
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function AI_IsDangerous( ai_test:ai ):boolean
	return ai_combat_status(ai_test) == ACTOR_COMBAT_STATUS.Dangerous and ai_spawn_count(ai_test) > 0;
end



-- -------------------------------------------------------------------------------------------------
-- ENCOUNTER COMBAT STATUS
-- -------------------------------------------------------------------------------------------------
-- === AreEncountersCombatStatusesActive: returns whether any squad in an array of encounter zones has an active combat status
--			arrayOfEncounters = array of encounters
--				example:
					--{
						--ENCOUNTER_ZONE.ez1,
						--ENCOUNTER_ZONE.ez2,
						--ENCOUNTER_ZONE.ez3,
					--}
--	RETURNS:  boolean; TRUE; if any squad is active, FALSE; if no squads are active
function AreEncountersCombatStatusesActive(arrayOfEncounters:table):boolean
	for _, encounterZone in ipairs(arrayOfEncounters) do
		if IsEncounterCombatStatusActive(encounterZone) == true then
			return true;
		end
	end
	return false;
end

-- === IsEncounterCombatStatusActive: returns whether any squad in an encounter zone an active combat status
--			encounterZone = an encounter_zone
--	RETURNS:  boolean; TRUE; if a squad in the encounter zone is active, FALSE; if no squads are active
function IsEncounterCombatStatusActive(encounterZone:encounter_zone):boolean
	return IsEncounterCombatStatusGreaterThanOrEqualTo(encounterZone, ACTOR_COMBAT_STATUS.Active);
end

-- === IsEncounterCombatStatusGreaterThanOrEqualTo: Checks to see if any squad in an encounter zone has a combat status
-- greater than the argument of the status
--			encounterZone = AI group to test
--			combatStatusArg = the combat status (of provider actor_combat_status
--	RETURNS:  boolean; TRUE; if a squad in the encounter zone has a combat status greater than the combatStatusArg
--					   FALSE; if combat status is less than the combatStatusArg
function IsEncounterCombatStatusGreaterThanOrEqualTo(encounterZone:encounter_zone, combatStatusArg:actor_combat_status):boolean
	assert(encounterZone ~= nil, "encounterZone argument is nil");
	assert(combatStatusArg ~= nil, "combatStatusArg is nil");

	local encounterInstance:handle = AI_GetEncounterInstanceFromEncounterZone(encounterZone);
	local virtualSquadArray:table = AI_GetVirtualSquadsInEncounter(encounterInstance);

	for _, virtualSquad in ipairs(virtualSquadArray) do
		local aiSquad:ai = AI_GetAISquadFromSquadInstance(virtualSquad);
		local combatStatusOfSquad:actor_combat_status = ai_combat_status(aiSquad);
		if ai_combat_status_a_greater_or_equal_b(combatStatusOfSquad, combatStatusArg) == true then
			return true;
		end
	end
	return false;
end

-- -------------------------------------------------------------------------------------------------
-- AI COUNTERS
-- -------------------------------------------------------------------------------------------------
function AI_GetActorCountsFromSpawnerTable(squadSpawners:table)
	local livingActors:number = 0;
	local virtualActors:number = 0;
	for _, spawner in ipairs(squadSpawners) do
		if GetEngineString(AI_GetEncounterInstanceFromSquadSpawner(spawner)) ~= "script handle: -1" then
			local virtualSquadList:table = AI_GetAllSquadInstancesFromSquadSpawner(spawner);
			for _, virtualSquad in ipairs(virtualSquadList) do
				local squad = AI_GetAISquadFromSquadInstance(virtualSquad);
				if squad ~= nil then
					livingActors = livingActors + ai_living_count(squad);
				else
					virtualActors = virtualActors + #AI_GetVirtualActorsInVirtualSquad(virtualSquad);
				end
			end
		end
	end
	return livingActors, virtualActors;
end

function AI_GetActorCountsFromSpawner(spawner:squad_spawner)
	return AI_GetActorCountsFromSpawnerTable({spawner});
end

-- === AI_LivingCountForSquadSpawners: returns the total count of all living actors spawned from a table of squad spawners
--	spawners = a table of squad_spawners
--	RETURNS: number of living actors
function AI_LivingCountForSquadSpawners(spawners:table):number
	local living,virtual = AI_GetActorCountsFromSpawnerTable(spawners); 
	return living;
end

-- -------------------------------------------------------------------------------------------------
-- Squad Spawners
-- -------------------------------------------------------------------------------------------------
-- === AI_GetLatestSquadFromSquadSpawner: returns the latest spawned squad from a squad spawner OR nil if the spawner CANNOT spawn
--			spawner = squad_spawner
--	RETURNS: AI squad
--  NOTE: this blocks until there is an ai squad OR the spawner CANNOT spawn, so it could block on this
--  EXAMPLE:  local gruntSquad:ai = AI_GetLatestSquadFromSquadSpawner(SQUAD_SPAWNERS.grunt_spawner)
function AI_GetLatestSquadFromSquadSpawner(spawner:squad_spawner):ai
	SleepUntil([| EncounterManager_IsWarmedUp() ], 1);
	SleepUntil([| AI_SpawnerFailedToSpawn(spawner) or AI_GetAISquadFromSquadSpawner(spawner) ~= nil ], 1);
	return AI_GetAISquadFromSquadSpawner(spawner);
end

-- === AI_SpawnSquadAndSleepUntilSpawned: tries to spawn a squad until a valid handle is returned returns the valid handle
--			spawner = squad_spawner
--	RETURNS: AI squad
--  NOTE: THIS FUNCTION IS FOR TESTING SPAWNERS. This blocks until there is valid handle
--  EXAMPLE:  local validHandle:handle = AI_SpawnSquadAndSleepUntilSpawned(SQUAD_SPAWNERS.grunt_spawner)
function AI_SpawnSquadAndSleepUntilSpawned(spawner:squad_spawner)
	SleepUntil([|EncounterManager_IsWarmedUp()], 1);
	local squadHandle:handle = nil;
	repeat
		squadHandle = Spawner_SpawnSquad(spawner);
		if not Handle_IsNotNone(squadHandle) then
			SleepOneFrame();
		end
	until Handle_IsNotNone(squadHandle);
	return squadHandle;
end


-- === AI_SpawnSpawner: tries to spawn a squad, returns squad and first unit.  Returns nil, nil if the squad is invalid somehow
--			spawner = squad_spawner
--			timeOut = number (in seconds)
--	RETURNS: AI squad, first unit in the squad
--  EXAMPLE:  local squad, firstUnit = AI_SpawnSpawner(SQUAD_SPAWNERS.grunt_spawner)
function AI_SpawnSpawner(spawner:squad_spawner, timeOut:number):ai
	SleepUntil([|EncounterManager_IsWarmedUp()], 1);
	local squadHandle = Spawner_SpawnSquad(spawner);

	SleepUntilSeconds([| AI_SpawnerFailedToSpawn(spawner) or AI_GetAISquadFromSquadInstance(squadHandle) ~= nil ], 0.001, timeOut);
	local squad:ai = AI_GetAISquadFromSquadInstance(squadHandle);
	local unit:object = squad and ai_actors(squad)[1] or nil;
	return squad, unit;
end

-- === AI_SpawnerFailedToSpawn: Returns whether a spawner has failed to spawn a squad
--  spawner = squad_spawner
-- RETURNS: boolean
-- EXAMPLE:  if AI_SpawnerFailedToSpawn(SQUAD_SPAWNERS.grunt_spawner) then
function AI_SpawnerFailedToSpawn(spawner:squad_spawner):boolean
	return EncounterManager_IsWarmedUp() == true and
		(AI_GetFailedActorSpawnCountFromSpawner(spawner) > 0 or
		#AI_GetVirtualActorsInVirtualSquad(AI_GetSquadInstanceFromSquadSpawner(spawner)) == 0 or
		AI_GetEncounterPresence(AI_GetEncounterInstanceFromSquadSpawner(spawner)) == ENCOUNTER_PRESENCE.Invalid or
		IsValidTag(Spawner_GetSquadSpec(spawner)) == false);
end

-- === AI_SpawnerIsDefeated: Returns whether a spawner has spawned and been defeated, returns true if CANNOT spawn
--  spawner = squad_spawner
--  RETURNS: boolean
--  EXAMPLE:  SleepUntil([| AI_SpawnerIsDefeated(SQUAD_SPAWNERS.grunt_spawner)], 1);
function AI_SpawnerIsDefeated(spawner:squad_spawner):boolean
	return (EncounterManager_IsWarmedUp() == true and
		AI_GetSquadInstanceFromSquadSpawner(spawner) ~= nil and 
		#AI_GetVirtualActorsInVirtualSquad(AI_GetSquadInstanceFromSquadSpawner(spawner)) == 0 and
		AI_GetActorSpawnedCountFromSpawner(spawner) > 0)
		or (AI_SpawnerFailedToSpawn(spawner) );
end

-- -------------------------------------------------------------------------------------------------
-- SQUAD STATUS
-- -------------------------------------------------------------------------------------------------
-- === AI_HasSpawned: Checks to see if an ai group has spawned
--			ai_test = AI group to test
--	RETURNS:  boolean; TRUE; if group has spawned, FALSE; if group has not spawned
function AI_HasSpawned( ai_test:ai ):boolean
	return ai_spawn_count(ai_test) > 0;
end

-- === AI_IsDefeated: Checks if a squad or group has ever spawned AND has no living members left
--			ai_test = AI group to test
--	RETURNS:  boolean; TRUE; if group is defeated, FALSE; if not defeated
function AI_IsDefeated( ai_test:ai ):boolean
	return ai_living_count(ai_test) <= 0 and ai_spawn_count(ai_test) > 0;
end

-- === AI_IsPartiallyDefeated: Checks if a squad or group has ever spawned AND has a specified number of living members
--			ai_test = AI to give magic sight to
--			s_count = Specific number of AI to test if still living
--	RETURNS:  boolean; TRUE; if group is partially defeated, FALSE; if not partially defeated
function AI_IsPartiallyDefeated( ai_test:ai, s_count:number ):boolean
	return ai_living_count(ai_test) <= s_count and ai_spawn_count(ai_test) >= s_count;
end

-- === AI_KilledCount: Gets the count of AI that has been killed in the task
--			ai_test = AI group to test
--	RETURNS:  boolean; TRUE; if group is defeated, FALSE; if not defeated
function AI_KilledCount( ai_test:ai ):number
	return ai_spawn_count(ai_test) - ai_living_count(ai_test);
end

-- -------------------------------------------------------------------------------------------------
-- TASK
-- -------------------------------------------------------------------------------------------------
-- === AI_TaskIsEmpty: Checks if if a task is empty or not
--			ai_task = task to check
--	RETURNS:  boolean; TRUE; if task is empty, FALSE; if the task is not
function AI_TaskIsEmpty( ai_task:ai ):boolean
	return ai_task_count(ai_task) <= 0;
end

-- === AU_TaskHasActors: Checks if a task has anyone in it
--			ai_task = task to check
--	RETURNS:  boolean; TRUE, if the task has actors, FALSE; task is empty
function AI_TaskHasActors( ai_task:ai ):boolean
	return ai_task_count(ai_task) > 0;
end

-- -------------------------------------------------------------------------------------------------
-- TYPE CONVERSION
-- -------------------------------------------------------------------------------------------------
-- === ObjectGetSquad: Gets the squad of an object
--			ai_obj = Object to get squad from
--	RETURNS:  ai; squad from the object
function Object_GetSquad( ai_obj:object ):ai
	return ai_get_squad(object_get_ai(ai_obj));
end

-- -------------------------------------------------------------------------------------------------
-- GARBAGE
-- -------------------------------------------------------------------------------------------------
-- TYPES

global aiGarbage =
	{
		distance_min_default = 22.5,
		see_degrees_default = 100.0,
		delay_squad_default = 30,
		delay_unit_default = 1,
	};
function aiGarbage.CleanupTypeErase():number
	return 00;
end

function aiGarbage.CleanupTypeKill():number
	return 01;
end

-- === aiGarbage.AI_Cleanup: "Cleans up" AI based on parameters provided and stops once there is no longer any living AI in the squad
--			ai_squad = Squad to cleanup
--			action_type = Type of action to perform on the AI
--				NOTE: SEE TYPE DEFINITIONS ABOVE
--			[optional] distance_min = Minimum distance the AI must be from a player
--				DEFAULT = -1.0
--				[ < 0; Default tuned distance ]
--			[optional] see_degrees = Number of degrees from player LOS to make sure the AI is not within 
--				DEFAULT = -1.0
--				[ < 0; Default tuned degrees ]
--			[optional] delay_squad = Delay (ticks) between looping back on the squad again
--				DEFAULT = -1
--				[ < 0; Default delay between squad loops ]
--			[optional] delay_unit = Delay (ticks) between each unit
--				DEFAULT = -1
--				[ < 0; Default delay between unit loops ]
--			[optional] garbage_squad = TRUE; will automatically garbage collect after each squad loop
--				DEFAULT = FALSE
--			[optional] check_player_los = TRUE; will check if the player has LOS on the ai and not garbage them if they do
--				DEFAULT = FALSE
--			[optional] check_ai_los = TRUE; will check if the ai has LOS on the player and not garbage them if they do
--				DEFAULT = FALSE
--	RETURNS:  long; thread id of the cleanup event
function aiGarbage.AI_Cleanup( ai_squad:ai, action_type:number, distance_min:number, see_degrees:number, delay_squad:number, delay_unit:number, garbage_squad:boolean, check_player_los:boolean, check_ai_los:boolean ):thread
	-- defaults
	distance_min = distance_min or aiGarbage.distance_min_default;
	see_degrees = see_degrees or aiGarbage.see_degrees_default;
	delay_squad = delay_squad or aiGarbage.delay_squad_default;
	delay_unit = delay_unit or aiGarbage.delay_unit_default;
	
	return CreateThread(aiGarbage.sys_ai_cleanup, ai_squad, action_type, distance_min, see_degrees, delay_squad, delay_unit, garbage_squad, check_player_los, check_ai_los);
end

function AI_GarbageErase( ai_squad:ai, distance_min:number, see_degrees:number, delay_squad:number, delay_unit:number, garbage_squad:boolean, check_player_los:boolean, check_ai_los:boolean ):thread
	return aiGarbage.AI_Cleanup(ai_squad, aiGarbage.CleanupTypeErase(), distance_min, see_degrees, delay_squad, delay_unit, garbage_squad, check_player_los, check_ai_los);
end


function AI_GarbageKill( ai_squad:ai, distance_min:number, see_degrees:number, delay_squad:number, delay_unit:number, garbage_squad:boolean, check_player_los:boolean, check_ai_los:boolean ):thread
	return aiGarbage.AI_Cleanup(ai_squad, aiGarbage.CleanupTypeKill(), distance_min, see_degrees, delay_squad, delay_unit, garbage_squad, check_player_los, check_ai_los);
end


-- === sys_ai_garbage: Manages f_ai_garbage
--			NOTE: DO NOT USE!!!
function aiGarbage.sys_ai_cleanup( ai_squad:ai, action_type:number, distance_min:number, see_degrees:number, delay_squad:number, delay_unit:number, garbage_squad:boolean, check_player_los:boolean, check_ai_los:boolean ):void
	repeat
		Sleep(delay_squad);
		if ai_living_count(ai_squad) > 0 then
			aiGarbage.sys_ai_cleanup_objlist(ai_actors(ai_squad), action_type, distance_min, see_degrees, delay_unit, check_player_los, check_ai_los);
		end
		if garbage_squad then
			garbage_collect_now();
		end
	until ai_living_count(ai_squad) <= 0;
end

-- === sys_ai_garbage_objlist: Manages list of actors from sys_ai_garbage
--			NOTE: DO NOT USE!!!
function aiGarbage.sys_ai_cleanup_objlist( ol_list:object_list, action_type:number, distance_min:number, see_degrees:number, delay_unit:number, check_player_los:boolean, check_ai_los:boolean ):void
	local s_index:number=list_count(ol_list);
	local obj_object:object=nil;
	repeat
		Sleep(delay_unit);
		-- loop through all the units in the squad
		s_index = s_index - 1;
		obj_object = list_get(ol_list, s_index);
		-- check to make sure the object meets the criteria
		if obj_object~=nil and object_get_health(obj_object) > 0.0 and objects_distance_to_object(players(), obj_object) >= distance_min and ( not check_player_los or  not objects_can_see_object(players(), obj_object, see_degrees)) and ( not check_ai_los or  not AnyUnitCanSeePlayers(obj_object, see_degrees)) then
			-- apply unit garbage type
			if action_type == aiGarbage.CleanupTypeErase() then
				--dprint( "sys_ai_garbage_objlist: ERASE" );
				ai_erase(object_get_ai(obj_object));
			elseif action_type == aiGarbage.CleanupTypeKill() then
				--dprint( "sys_ai_garbage_objlist: KILLED" );
				ai_kill_no_statistics(object_get_ai(obj_object));
			else
				Breakpoint("sys_ai_cleanup: TYPE UNKNOWN");
				print(action_type);
				Sleep(1);
			end
		end
	until s_index <= 0;
end


-- -------------------------------------------------------------------------------------------------
-- ObjList Kill AI
-- -------------------------------------------------------------------------------------------------
function Object_KillAI( ol_list:object_list, b_count_kill_stats:boolean ):number
	local s_index:number=list_count(ol_list);
	local obj_object:object=nil;
	local s_applied:number=0;
	if s_index > 0 then
		repeat
			Sleep(1);
			s_index = s_index - 1;
			obj_object = list_get(ol_list, s_index);
			if obj_object~=nil and object_get_health(obj_object) > 0.0 then
				if b_count_kill_stats then
					ai_kill(object_get_ai(obj_object));
				else
					ai_kill_no_statistics(object_get_ai(obj_object));
				end
				s_applied = s_applied + 1;
			end
		until s_index <= 0;
	end
	return s_applied;
end

-- return
function Object_KillAIVolume( tv_volume:volume, b_count_kill_stats:boolean ):number
	return Object_KillAI(volume_return_objects_by_type(tv_volume, s_objtype_biped), b_count_kill_stats);
end


-- -------------------------------------------------------------------------------------------------
-- MISC
-- -------------------------------------------------------------------------------------------------
-- === AI_MagicallySeePlayers: Gives a squad magic sight on ALL players (only current active players, will not work on JiP)
--			ai_test = AI to give magic sight to
--	RETURNS:  TRUE; if AI is in the state, FALSE; if not
function AI_MagicallySeePlayers( ai_test:ai ):void
	for _, player in hpairs (players()) do
		ai_magically_see_object(ai_test, player);
	end
end

-- === AI_DoesAISeeAnyPlayer: Checks if an AI can see any player
--			ai_test = AI to check
--			r_angle = Angle of sight check
--	RETURNS:  TRUE; if AI sees a player
function AI_DoesAISeeAnyPlayer( ai_test:ai, r_angle:number ):boolean
	for _, player in pairs (players) do
		if AnyUnitCanSeePoint(ai_test, player, r_angle) then
			return true;
		end
	end
	return false;
end

function AI_SpawnAtPositionWithLoadout ( ai_tag:tag, calling_player:player, position:location, weapon_tag:tag ):object
	local dropAi:table = SquadBuilder:BuildSimpleSquad(ai_tag, "debug_drop_ai", 1, {cells = {{upgrade="none"}}});
	local dropSquad:ai = SquadBuilder:PlaceSquad(dropAi, ToLocation(position), false);

	if (calling_player ~= nil) then
		set_ai_squad_campaign_and_mp_team( dropSquad, Player_GetCampaignTeam(calling_player), Player_GetMultiplayerTeam(calling_player));
	end
	if (weapon_tag ~= nil) then
		if (unit_has_weapon(dropSquad, weapon_tag) and unit_has_weapon_readied(dropSquad, weapon_tag) == false) then
			ai_swap_weapons(dropSquad);
		else
			local weapon = Object_CreateFromTag(weapon_tag);
			Unit_GiveWeapon(dropSquad, weapon, WEAPON_ADDITION_METHOD.PrimaryWeapon);
		end
	end
	return ai_get_object(dropSquad)
end

function AI_SpawnAtPosition( ai_tag:tag, position:location, weapon_tag:tag )
	local dropAi:table = SquadBuilder:BuildSimpleSquad(ai_tag, "debug_drop_ai", 1, {cells = {{upgrade="none"}}});
	local dropSquad:ai = SquadBuilder:PlaceSquad(dropAi, ToLocation(position), false);
end

function remoteServer.AI_SpawnAtPosition( ai_tag:tag, position:location, weapon_tag:tag )
	AI_SpawnAtPosition(ai_tag, position, weapon_tag);
end

function Bot_SpawnAtPlayerWithLoadout (calling_player:player, weapon_tag:tag)
	Bot_SpawnAtPositionWithLoadout(calling_player, ToLocation(GetLookPosition(PLAYERS.player0, 5)), weapon_tag)
end

function remoteServer.Bot_SpawnAtPlayerWithLoadout (calling_player:player, weapon_tag:tag)
	Bot_SpawnAtPlayerWithLoadout(calling_player, weapon_tag);
end

function Bot_SpawnAtPositionWithLoadout (calling_player:player, position:location, weapon_tag:tag)
	if weapon_tag ~= nil then
		LoadoutSetOverrideWeapon(RESPAWN_WEAPON_SLOT.Primary, weapon_tag);

		local botMPTeamId = 0;
		local botCampaignTeamId = 0;

		if calling_player ~= nil then
			botMPTeamId = Player_GetMultiplayerTeam(calling_player);
			botCampaignTeamId = Player_GetCampaignTeam(calling_player);
		else 
			local playerMPTeamId = Player_GetMultiplayerTeam(PLAYERS.player0);
			if playerMPTeamId == MP_TEAM.mp_team_red then
				botMPTeamId = MP_TEAM.mp_team_blue;
			else 
				botMPTeamId = MP_TEAM.mp_team_red;
			end

			botCampaignTeamId = TEAM.covenant;

		end

		local participant = Bot_AddWithTeam(botMPTeamId);

		Object_SetCampaignTeam(participant, botCampaignTeamId);

		Sleep(1);

		object_teleport(participant, ToLocation(position));

		LoadoutClearOverriddenWeapon(RESPAWN_WEAPON_SLOT.Primary);
	end
end

function remoteServer.Bot_SpawnAtPositionWithLoadout (calling_player:player, position:location, weapon_tag:tag)
	Bot_SpawnAtPositionWithLoadout(calling_player, position, weapon_tag);
end

--function f_ai_active_camo_manager( ai_actor:ai ):void
-- local l_timer:number = 0;
-- local obj_actor:object  = ai_get_object( ai_actor );
--	--print( "cs_active_camo_use: ENABLED" );
--
--	repeat
--	
--		-- activate camo
--		if ( unit_get_health(ai_actor) > 0.0 ) then
--			ai_set_active_camo( ai_actor, true );
--			--print( "f_active_camo_manager: ACTIVE" ); 
--		end
--		
--		-- disable camo
--		SleepUntil( [| (unit_get_health(ai_actor) <= 0.0) or   objects_distance_to_object(players(),obj_actor) <= 5.5  or ((object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) > 0.2) ], 3 );
--		if ( unit_get_health(ai_actor) > 0.0 ) then
--			ai_set_active_camo( ai_actor, false );
--			--print( "f_active_camo_manager: DISABLED" ); 
--		end
--		
--		-- manage resetting
--		if ( unit_get_health(ai_actor) > 0.0 ) then
--			l_timer = timer_stamp( 2.5, 5.0 ); -- unit_has_weapon_readied(ai_actor, TAG('objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon') )
--			SleepUntil( [| (unit_get_health(ai_actor) <= 0.0) or (timer_expired(l_timer) and ( objects_distance_to_object( players(),obj_actor) >= 4.0 ) and ( not objects_can_see_object( players(),obj_actor,25.0 ))) ], 1 );
--			
--			
--			if not unit_has_weapon_readied(ai_actor, TAG('objects\weapons\melee\energy_sword\energy_sword.weapon') ) then
--				--print("ai switching back to sword");
--				ai_swap_weapons( ai_current_actor);
--			end
--		
--		end
--		if ( unit_get_health(ai_actor) > 0.0 ) then
--			--print( "f_active_camo_manager: RESET" ); 
--			Sleep(1);
--		end
--		Sleep(1);
--	until ( unit_get_health(ai_actor) <= 0.0 );
--
--
--end

-- ------------------------------------------------------
-- Squad Descriptions
-- ------------------------------------------------------

global SquadIntensity = table.makeEnum
{
	Low = 0,
	Default = 1,
	Medium = 2,
	High = 3,
};

hstructure SquadDescription
	LowIntensity :table;
	DefaultIntensity :table;
	MediumIntensity :table;
	HighIntensity :table;
end

function GetSquadTableFromDescription(squadDesc:SquadDescription, intensity:number):table
	local selectedDesc:table = nil;
	if (intensity >= 3 and squadDesc.HighIntensity ~= nil) then
		selectedDesc = squadDesc.HighIntensity;
	elseif (intensity >= 2 and squadDesc.MediumIntensity ~= nil) then
		selectedDesc = squadDesc.MediumIntensity;
	elseif (intensity >= 1 and squadDesc.DefaultIntensity ~= nil) then
		selectedDesc = squadDesc.DefaultIntensity;
	else
		selectedDesc = squadDesc.LowIntensity;
	end
	return selectedDesc;
end

function BuildSquadDescriptorFromTemplate(squadName:string, templateName:string, campaignTeam:team, mpTeam:mp_team, taskKeyword:string_id):table
	assert(_G["chars"] ~= nil, "Must include Enc2Definitions.lua to use template squad building");
	
	local unitSquad = {};
	unitSquad.name = squadName;
	unitSquad.team = campaignTeam;
	unitSquad.mpteam = mpTeam;
	unitSquad.taskkeyword = taskKeyword;
	unitSquad.spawnkeyword = ObjectiveSpawnKeywords.Default;
	unitSquad.cells = _G["chars"].getTemplate(templateName).cells;
	return unitSquad;
end

function BuildBanishedSquadDescriptorFromTemplate(squadName:string, templateName:string, taskKeyword:string_id):table
	return BuildSquadDescriptorFromTemplate(squadName, templateName, TEAM.covenant, MP_TEAM.mp_team_yellow, taskKeyword);
end

function BuildUnscSquadDescriptorFromTemplate(squadName:string, templateName:string, taskKeyword:string_id):table
	return BuildSquadDescriptorFromTemplate(squadName, templateName, TEAM.player, MP_TEAM.mp_team_red, taskKeyword);
end

function BuildSentinelSquadDescriptorFromTemplate(squadName:string, templateName:string, taskKeyword:string_id):table
	return BuildSquadDescriptorFromTemplate(squadName, templateName, TEAM.forerunner, MP_TEAM.mp_team_orange, taskKeyword);
end

function BuildWildlifeSquadDescriptorFromTemplate(squadName:string, templateName:string, taskKeyword:string_id):table
	return BuildSquadDescriptorFromTemplate(squadName, templateName, TEAM.neutral, MP_TEAM.mp_team_green, taskKeyword);
end

function TryAddDescriptorsToIntensity(intensityBlock:table, addBlock:table):void
	if (nil ~= addBlock) then
		for _, descriptor:table in ipairs(addBlock) do
			table.insert(intensityBlock, descriptor);
		end
	end
end

function CombineSquadDescriptions(...):SquadDescription
	local squadMaker:SquadDescription = hmake SquadDescription
	{
		LowIntensity = {},
		DefaultIntensity = {},
		MediumIntensity = {},
		HighIntensity = {},
	}
	
	for _,squadDescFunc in ipairs(arg) do
		if (_G["SquadBuilderTable"].dataTable[squadDescFunc] == nil) then
			local squadBuildData:SquadDescription = squadDescFunc();
			assert(type(squadBuildData) == "struct", "Expected a SquadDescription return value");
			_G["SquadBuilderTable"]:Register(squadDescFunc);
		end
			
		local subSquad:SquadDescription = _G["SquadBuilderTable"]:Request(squadDescFunc);
		TryAddDescriptorsToIntensity(squadMaker.LowIntensity, subSquad.LowIntensity);
		TryAddDescriptorsToIntensity(squadMaker.DefaultIntensity, subSquad.DefaultIntensity);
		TryAddDescriptorsToIntensity(squadMaker.MediumIntensity, subSquad.MediumIntensity);
		TryAddDescriptorsToIntensity(squadMaker.HighIntensity, subSquad.HighIntensity);
	end
	
	assert(table.countKeys(squadMaker.LowIntensity) > 0, "CombineSquadDescriptions must have descriptors for LowIntensity");
	
	if (table.countKeys(squadMaker.DefaultIntensity) < 1) then
		squadMaker.DefaultIntensity = nil;
	end
	if (table.countKeys(squadMaker.MediumIntensity) < 1) then
		squadMaker.MediumIntensity = nil;
	end
	if (table.countKeys(squadMaker.HighIntensity) < 1) then
		squadMaker.HighIntensity = nil;
	end

	return squadMaker;
end

-- ------------------------------------------------------
-- Simple Encounter spawning
-- ------------------------------------------------------

global g_simpleSpawnEncounterRegistered:table = SetClass:New();

--One line function to faciliate and seperate dynamic squad spawning and encounter setup.
--Also allows for mixing the static and dynamic systems.
function SimpleSpawnEncounter(squadBuilder, encounterBuilder, spawnAt:location, deploymentInfo:table, intensity:number, encounterInstance:table, objectiveLocation:location, params):EncounterSpawnStruct
	local enc:EncounterSpawnStruct = nil;
	--if there are different spawnAt and objective locations then spawn with HoldArea, then change to objective
	if (objectiveLocation ~= nil and objectiveLocation ~= spawnAt) or type(encounterBuilder) == "string" then 
		enc = SpawnSquad(squadBuilder, CreateObjective_HoldAreaXXSmall, spawnAt, deploymentInfo, intensity, encounterInstance);
		if enc ~= nil then
			--store the encounter to table and only register the callback if the encounter is new
			--(because we don't allow duplicate callback functions on the same item)
			if g_simpleSpawnEncounterRegistered:Insert(enc.encounter) == true then
				local activeSquad:ai = AI_GetAISquadFromSquadInstance(enc.squad);
				if activeSquad ~= nil then
					--make sure to add the enc.objective (check to see that it really stuck and isn't local)
					enc.objective = ChangeSquadObjective(enc, activeSquad, encounterBuilder, objectiveLocation, params);
				else
					--set an activate event to ChangeSquadObjective
					--set a release event to remove the activate and release event
					RegisterEvent(g_eventTypes.encounterPostActivate, OnSimpleSpawnEncounterActivate, enc.encounter.m_instanceIndex, enc, encounterBuilder, objectiveLocation, params);
					RegisterEvent(g_eventTypes.encounterPreRelease, OnSimpleSpawnEncounterPreRelease, enc.encounter.m_instanceIndex, enc.encounter);
				end
			end
		end
	else
		--if there is no specific objectiveLocation then create the objective at the spawnAt
		enc = SpawnSquad(squadBuilder, encounterBuilder, spawnAt, deploymentInfo, intensity, encounterInstance, params);
		if enc ~= nil and enc.objective == nil then
			if g_simpleSpawnEncounterRegistered:Insert(enc.encounter) == true then
				local activeSquad:ai = AI_GetAISquadFromSquadInstance(enc.squad);
				if activeSquad ~= nil then
					--make sure to add the enc.objective (check to see that it really stuck and isn't local)
					enc.objective = ChangeSquadObjective(enc, activeSquad, encounterBuilder, spawnAt, params);
				else
					--set an activate event to ChangeSquadObjective
					--set a release event to remove the activate and release event
					RegisterEvent(g_eventTypes.encounterPostActivate, OnSimpleSpawnEncounterActivate, enc.encounter.m_instanceIndex, enc, encounterBuilder, spawnAt, params);
					RegisterEvent(g_eventTypes.encounterPreRelease, OnSimpleSpawnEncounterPreRelease, enc.encounter.m_instanceIndex, enc.encounter);
				end
			end
		end
	end
	return enc;
end

function OnSimpleSpawnEncounterActivate(encStruct:EncounterEventCallbackStruct, encounterSpawnStruct:EncounterSpawnStruct, objective, objectiveLocation:location, params)
	UnregisterEvent(g_eventTypes.encounterPostActivate, OnSimpleSpawnEncounterActivate, encStruct.encounterInstanceHandle);
	encounterSpawnStruct.objective = ChangeSquadObjective(encounterSpawnStruct, AI_GetAISquadFromSquadInstance(encounterSpawnStruct.squad),  objective, objectiveLocation, params);
	UnregisterEvent(g_eventTypes.encounterPreRelease, OnSimpleSpawnEncounterPreRelease, encStruct.encounterInstanceHandle);
	g_simpleSpawnEncounterRegistered:Remove(encounterSpawnStruct.encounter);
end

function OnSimpleSpawnEncounterPreRelease(encStruct:EncounterEventCallbackStruct, encounterInstance:table)
	UnregisterEvent(g_eventTypes.encounterPostActivate, OnSimpleSpawnEncounterActivate, encStruct.encounterInstanceHandle)
	UnregisterEvent(g_eventTypes.encounterPreRelease, OnSimpleSpawnEncounterPreRelease, encStruct.encounterInstanceHandle)
	g_simpleSpawnEncounterRegistered:Remove(encounterInstance);
end

function SpawnSquad(squadBuilder, encounterBuilder, spawnAt:location, deploymentInfo:table, intensity:number, encounterInstance:table, params):EncounterSpawnStruct

	local squadBuilt:ai = nil;
	local encounterInst = encounterInstance or AIEncounterInstance.New();
	local objectiveHandle = nil;
	-- This block is intended for the new way of creating encounters. The function will early out here if successful.
	if nil ~= encounterBuilder and
		type(encounterBuilder) == "function" and
		type(squadBuilder) == "function" then
		
		objectiveHandle = encounterInst:AddObjective(encounterBuilder, spawnAt, params);
		
		local squadBuildData = nil;
		if (_G["EB"].armyTable[squadBuilder] ~= nil) then
			squadBuildData = _G["EB"].RequestArmy(squadBuilder);
		elseif (_G["SquadBuilderTable"].dataTable[squadBuilder] ~= nil) then
			squadBuildData = _G["SquadBuilderTable"]:Request(squadBuilder);
		else
			squadBuildData = squadBuilder();
			if (GetEngineType(squadBuildData) == "node_graph_node") then
				_G["EB"].armyTable[squadBuilder] = squadBuildData;
			else
				_G["SquadBuilderTable"]:Register(squadBuilder);
			end
		end
		
		if (GetEngineType(squadBuildData) == "node_graph_node") then
			squadBuilt = encounterInst:SpawnSquadToObjectiveLegacy(objectiveHandle, squadBuildData, {});
		else
			local squadInstance:handle = encounterInst:ReserveSquadBuilderToObjective(objectiveHandle, squadBuilder, intensity);

			--if the encounter got garbage collected most likely because of debug killing AI then return nil
			if encounterInst:GetPresence() == ENCOUNTER_PRESENCE.Invalid then
				return nil;
			else
				return	hmake EncounterSpawnStruct {
						squad = squadInstance,
						objective = objectiveHandle,
						encounter = encounterInst,
					};
			end
		end
	end

	--If the given builder is a node creation function such as those in Enc2_defs, request and build the graph,
	--get deployment info, set spawn, and build the squad
	if type(squadBuilder) == "function" then
		local squadBuildData = nil;
		if (_G["EB"].armyTable[squadBuilder] ~= nil) then
			squadBuildData = _G["EB"].RequestArmy(squadBuilder);
		elseif (_G["SquadBuilderTable"].dataTable[squadBuilder] ~= nil) then
			squadBuildData = _G["SquadBuilderTable"]:Request(squadBuilder);
		else
			squadBuildData = squadBuilder();
			if (GetEngineType(squadBuildData) == "node_graph_node") then
				_G["EB"].armyTable[squadBuilder] = squadBuildData;
			else
				_G["SquadBuilderTable"]:Register(squadBuilder);
			end
		end
		
		if (GetEngineType(squadBuildData) == "node_graph_node") then
			local deploy:table = deploymentInfo or AIDeploymentInfo.New();
			if (nil ~= spawnAt) then
				deploy:SetDeploymentDefaultPosition(spawnAt);
			end
			squadBuilt = sg_build_squads(squadBuildData, 0, {intensity = intensity or SquadIntensity.Default}, deploy);
		else
			squadBuilt = SquadBuilder:PlaceSquadDescFunc(squadBuilder, spawnAt, intensity or SquadIntensity.Default);
		end

	--If the builder is a faber aisquad, place it 
	elseif GetEngineType(squadBuilder) == "ai" then
		squadBuilt = ai_place(squadBuilder);
		SleepUntilSeconds([|ai_living_count(squadBuilt) > 0], 0.001, 1);
	--If the builder is a squad create table, place it
	elseif GetEngineType(squadBuilder) == "table" and _G["PlaceSquads"] ~= nil then
		squadBuilt = _G["PlaceSquads"](squadBuilder, spawnAt);
	end

	--If the squad builder is not an accepted type or failed to work, throw an error
	assert(squadBuilt ~= nil, "SimpleSpawnEncounter: failed to create a squad");
	
	local squadInst = AI_GetSquadInstanceFromAISquad(squadBuilt);

	if type(encounterBuilder) == "string" then
		ai_set_objective(squadBuilt, encounterBuilder);
		objectiveHandle = AI_GetObjectiveInstanceFromSquadInstance(squadInst);
		encounterInst = AIEncounterInstance.FromExisting(AI_GetEncounterInstanceFromSquadInstance(squadInst));
	end
		
	return	hmake EncounterSpawnStruct{
				squad = squadInst,
				objective = objectiveHandle,
				encounter = encounterInst,
			};
end

function ChangeSquadObjective(encounterSpawnStruct:EncounterSpawnStruct, squadBuilt, objective, objectiveLocation:location, params)
	local objectiveHandle = nil; -- not typing this because it could be a string or a handle
	local encounterInst:table = encounterSpawnStruct.encounter;
	--If the objective is an objective name, set the ai objective and set the objective and encounter to that encounters struct
	if type(objective) == "string" then
		ai_set_objective(squadBuilt, objective);
		objectiveHandle = objective;
		local squadInst:handle = AI_GetSquadInstanceFromAISquad(squadBuilt);
		
		encounterSpawnStruct.encounter = AIEncounterInstance.FromExisting(AI_GetEncounterInstanceFromSquadInstance(squadInst));
		local objInstIndex:handle = AI_GetObjectiveInstanceFromSquadInstance(squadInst);
		local objectiveInst:table = encounterSpawnStruct.encounter:TryToAddFaberObjective(objInstIndex);
		AI_SetSquadInstanceParent(squadInst, objectiveInst.m_rootSquadInstance);

	--If the encounter builder is a objective definition, create an instance and
	--set the squad encounter objective
	elseif type(objective) == "table" then
		objectiveHandle = encounterInst:AddObjectiveLegacy(objective, objectiveLocation);
		encounterInst:AssignSquadObjective(objectiveHandle, squadBuilt);
	elseif type(objective) == "function" and params then
		objectiveHandle = encounterInst:AddObjective(objective, objectiveLocation, params);
		encounterInst:AssignSquadObjective(objectiveHandle, squadBuilt);
	elseif type(objective) == "function" then
		local request:table = EC.RequestEncounter(objective);
		objectiveHandle = encounterInst:AddObjectiveLegacy(request, objectiveLocation);
		encounterInst:AssignSquadObjective(objectiveHandle, squadBuilt);
	elseif GetEngineType(objective) == "handle" then
		objectiveHandle = objective;
		encounterInst:AssignSquadObjective(objectiveHandle, squadBuilt);
	--If the encounter is not an accepted type and not specifically ignored, throw an error
	elseif objective ~= nil then
		assert(false, "SimpleSpawnEncounter: Not given a valid encounter builder");
	end
	
	return objectiveHandle;
end



function SimpleSpawnEncounterAndProps(squadBuilder, encounterBuilder, spawnAt:location, deploymentInfo:table, intensity:number, propKit:tag, kitLocation:location):table
	return {
		squad = SimpleSpawnEncounter(squadBuilder, encounterBuilder, spawnAt, deploymentInfo, intensity),
		propKit = EnginePlacePropTemplate(propKit, ToLocation(kitLocation).vector, ToLocation(kitLocation).matrix.angles.yaw);
	};
end

---------------------------------------------------------------------------------------------------
-- Placement scripts
---------------------------------------------------------------------------------------------------

--phantoms using this should set spawn method to "Limbo" and set the flag "Disable Spawn Effect"
function placement_script_immediately_enable_phantom_camo()
	local numVehicles:number = ai_vehicle_get_squad_count(ai_current_squad);
	for i = 0, numVehicles - 1 do
		local vehicle:object = ai_vehicle_get_from_squad(ai_current_squad, i);
		object_set_limbo(vehicle, false);

		-- Get all actors out of limbo with the vehicle, otherwise gunners may try to de-limbo before the vehicle.
		-- Also, the chin gunner will not get this callback at all, so needs this to activate them.
		ai_exit_limbo(ai_current_squad);
		
		UnitImmediatelySetActiveCamo(vehicle, true, -1);
	end
end

function placement_script_grunt_kamikaze()
	ai_grunt_kamikaze(ai_current_squad);
end

---------------------------------------------------------------------------------------------------
-- Below are special functions that use private engine functions (exposed by lua_register)
-- and coroutines.  Functions whose name has "Internal" at the end are lua_registered ones.
--
-- PLEASE DO NOT CHANGE UNLESS YOU ARE SURE ABOUT HOW ALL FUNCTIONS WORKS.
-- Removing may be OK if you are sure function is obsolete.
---------------------------------------------------------------------------------------------------

-- Builds squads and assigns them to the given objective instance. Expects: (objective instance index, squad builder node, output index, user data, deploy info).
function AI_BuildObjectiveInstanceSquads(objInstance, nodeIndex, nodeOutput, intensity, deployInfo)
	local reqResult = RequestBuildSquadsInternal(nodeIndex, nodeOutput, intensity, deployInfo, objInstance);
	if (reqResult[3] == false) then
		return reqResult[2];
	end
	while CheckBuildSquadsStateInternal(reqResult[1]) == false do
		coroutine.yield();
	end
	return reqResult[2];
end

function sg_build_squads(nodeIndex, nodeOutput, intensity, deployInfo, objInstance)
	local reqResult = RequestBuildSquadsInternal(nodeIndex, nodeOutput, intensity, deployInfo, objInstance);
	if (reqResult[3] == false) then
		return reqResult[2];
	end
	while CheckBuildSquadsStateInternal(reqResult[1]) == false do
		coroutine.yield();
	end
	return reqResult[2];
end

---------------------------------------------------------------------------------------------------
-- End of Special Functions
---------------------------------------------------------------------------------------------------
