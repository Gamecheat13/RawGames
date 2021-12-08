-- Copyright (C) Microsoft. All rights reserved.
--## SERVER


--  _______  __        ______   .______        ___       __         .___  ___.  __    __   __      .___________.__  .______    __          ___   ____    ____  _______ .______      
-- /  _____||  |      /  __  \  |   _  \      /   \     |  |        |   \/   | |  |  |  | |  |     |           |  | |   _  \  |  |        /   \  \   \  /   / |   ____||   _  \     
--|  |  __  |  |     |  |  |  | |  |_)  |    /  ^  \    |  |        |  \  /  | |  |  |  | |  |     `---|  |----|  | |  |_)  | |  |       /  ^  \  \   \/   /  |  |__   |  |_)  |    
--|  | |_ | |  |     |  |  |  | |   _  <    /  /_\  \   |  |        |  |\/|  | |  |  |  | |  |         |  |    |  | |   ___/  |  |      /  /_\  \  \_    _/   |   __|  |      /     
--|  |__| | |  `----.|  `--'  | |  |_)  |  /  _____  \  |  `----.   |  |  |  | |  `--'  | |  `----.    |  |    |  | |  |      |  `----./  _____  \   |  |     |  |____ |  |\  \----.
-- \______| |_______| \______/  |______/  /__/     \__\ |_______|   |__|  |__|  \______/  |_______|    |__|    |__| | _|      |_______/__/     \__\  |__|     |_______|| _| `._____|
--           

-----------------------------
---- Global MP Constants ----
-----------------------------

global k_infiniteNavpointVisDistance:number = -1;
global k_neutralColorGrey:color_rgba = color_rgba(0.8, 0.8, 0.8, 1.0);

global MPTeam = table.makePermanent
	{
		MP_TEAM.mp_team_red,
		MP_TEAM.mp_team_blue,
		MP_TEAM.mp_team_green,
		MP_TEAM.mp_team_yellow,
		MP_TEAM.mp_team_purple,
		MP_TEAM.mp_team_orange,
		MP_TEAM.mp_team_brown,
		MP_TEAM.mp_team_grey,
	};

global TeamColor = table.makePermanent
	{
		red = MP_TEAM.mp_team_red,
		blue = MP_TEAM.mp_team_blue,
		green = MP_TEAM.mp_team_green,
		yellow = MP_TEAM.mp_team_yellow,
		purple = MP_TEAM.mp_team_purple,
		orange = MP_TEAM.mp_team_orange,
		brown = MP_TEAM.mp_team_brown,
		grey = MP_TEAM.mp_team_grey,
	};

global mpColor = table.makePermanent
	{
		[MP_TEAM.mp_team_red] = "teamRed",
		[MP_TEAM.mp_team_blue] = "teamBlue",
		[MP_TEAM.mp_team_green] = "teamGreen",
		[MP_TEAM.mp_team_yellow] = "teamYellow",
		[MP_TEAM.mp_team_purple] = "teamPurple",
		[MP_TEAM.mp_team_orange] = "teamOrange",
		[MP_TEAM.mp_team_brown] = "teamBrown",
		[MP_TEAM.mp_team_grey] = "teamGrey",
	};
	
global mpTeamDesignatorToNumber = table.makePermanent
	{
		[MP_TEAM_DESIGNATOR.First] = 1,
		[MP_TEAM_DESIGNATOR.Second] = 2,
		[MP_TEAM_DESIGNATOR.Third] = 3,
		[MP_TEAM_DESIGNATOR.Fourth] = 4,
		[MP_TEAM_DESIGNATOR.Fifth] = 5,
		[MP_TEAM_DESIGNATOR.Sixth] = 6,
		[MP_TEAM_DESIGNATOR.Seventh] = 7,
		[MP_TEAM_DESIGNATOR.Eighth] = 8,
		[MP_TEAM_DESIGNATOR.Neutral] = 9,
	};

global mpTeamDesignatorToMPTeam = table.makePermanent
	{
		[MP_TEAM_DESIGNATOR.First] = MP_TEAM.mp_team_red,
		[MP_TEAM_DESIGNATOR.Second] = MP_TEAM.mp_team_blue,
		[MP_TEAM_DESIGNATOR.Third] = MP_TEAM.mp_team_green,
		[MP_TEAM_DESIGNATOR.Fourth] = MP_TEAM.mp_team_yellow,
		[MP_TEAM_DESIGNATOR.Fifth] = MP_TEAM.mp_team_purple,
		[MP_TEAM_DESIGNATOR.Sixth] = MP_TEAM.mp_team_orange,
		[MP_TEAM_DESIGNATOR.Seventh] = MP_TEAM.mp_team_brown,
		[MP_TEAM_DESIGNATOR.Eighth] = MP_TEAM.mp_team_grey,
	};

global mpTeamToTeamName = table.makePermanent
	{
		-- "Neutral" is a variant, but not sure what to map it to
		[MP_TEAM.mp_team_red] = "Eagle",
		[MP_TEAM.mp_team_blue] = "Cobra",
		[MP_TEAM.mp_team_green] = "Hades",
		[MP_TEAM.mp_team_yellow] = "Valkyrie",
		[MP_TEAM.mp_team_purple] = "Rampart",
		[MP_TEAM.mp_team_orange] = "Cutlass",
		[MP_TEAM.mp_team_brown] = "Valor",
		[MP_TEAM.mp_team_grey] = "Hazard",
	};

global mpTeamToBannerObjectFunctionValue = table.makePermanent
	{
		[MP_TEAM.mp_team_red] = 0,
		[MP_TEAM.mp_team_blue] = 0.15,
		[MP_TEAM.mp_team_green] = 0.25,
		[MP_TEAM.mp_team_yellow] = 0.4,
		[MP_TEAM.mp_team_purple] = 0.5,
		[MP_TEAM.mp_team_orange] = 0.65,
		[MP_TEAM.mp_team_brown] = 0.75,
		[MP_TEAM.mp_team_grey] = 0.88,
	};

-----------------------------
----- Global MP Helpers -----
-----------------------------

function GetAllPlayersInSquad(squad:mp_squad):table
	local result:table = {};
	for _, player in hpairs(PLAYERS.active) do
		if (Player_GetMultiplayerSquad(player) == squad) then
			table.insert(result, player);
		end
	end
	return result;
end
 
function Team_GetTeamIndex(team:mp_team):number
	if (team == nil) then
		return NONE;  -- (NONE == -1)
	end

	for idx = 0, #MP_TEAM - 1 do
		if (MP_TEAM[idx] == team) then
			return idx;
		end
	end

	assert(false, "mp_team was supplied that didn't have a matching entry in the MP_TEAM enum!");
	return NONE;
end

-- Returns whether or not this DeathEvent was a player-to-player, non-suicide, enemy kill
function DeathEventIsEnemyPlayerKill(eventStruct:DeathEventStruct):boolean
	if (eventStruct.deadPlayer ~= nil and
		eventStruct.killingPlayer ~= nil and
		eventStruct.deadPlayer ~= eventStruct.killingPlayer and
		Engine_GetPlayerDisposition(eventStruct.deadPlayer, eventStruct.killingPlayer) == DISPOSITION.Enemy) then

		return true;
	end

	return false;
end

---------------------------------
----- Global MP Round State -----
---------------------------------

global s_mpGlobalRoundState:table =
{
	roundIntroIsComplete = false,
};

function s_mpGlobalRoundState.HandlePreRoundStart(eventArgs:RoundStartEventStruct):void
	s_mpGlobalRoundState.roundIntroIsComplete = false;
end

function s_mpGlobalRoundState.HandleGameplayStart(eventArgs:RoundStartGameplayEventStruct):void
	s_mpGlobalRoundState.roundIntroIsComplete = true;
end

function startup.RegisterMPGlobalRoundStateHandlers()
	RegisterGlobalEvent(g_eventTypes.roundPreStartEvent, s_mpGlobalRoundState.HandlePreRoundStart);
	RegisterGlobalEvent(g_eventTypes.roundStartGameplayEvent, s_mpGlobalRoundState.HandleGameplayStart);
end

function Multiplayer_IsRoundIntroComplete():boolean
	return s_mpGlobalRoundState.roundIntroIsComplete;
end

-- BLOCKING function; used as a helper for mode parcels that commonly will need to sleep until the intro is over
function SleepUntilIntroComplete():void
	SleepUntil ([| Multiplayer_IsRoundIntroComplete() ], 1);
end

-- Returns if this is the final regulation (i.e. non-overtime) round. This is poorly named, should be renamed to ThisIsTheFinalRegulationRound
function ThisIsTheFinalRound():boolean
	if (Engine_GetCurrentRoundIsOvertimeRound() == true) then
		return false;
	end

	local roundLimit:number = Variant_GetRegulationRoundLimit();
	if (roundLimit == 0) then
		roundLimit = Variant_GetRoundLimit();
	end

	if (Engine_GetRoundIndex() + 1 >= roundLimit) then
		return true;
	end
	
	return false;	
end

-- Returns if this is the OT round, or is the final regulation round
function ThisIsTheFinalRoundOrOvertimeRound():boolean
	if (Engine_GetCurrentRoundIsOvertimeRound() == true) then
		return true;
	end

	local roundLimit:number = Variant_GetRegulationRoundLimit();
	if (roundLimit == 0) then
		roundLimit = Variant_GetRoundLimit();
	end

	if (Engine_GetRoundIndex() + 1 >= roundLimit) then
		return true;
	end
	
	return false;	
end

-- Returns if this might be (or is) the final regulation (i.e. non-overtime) round; also poorly named, should be called ThisMightBeTheFinalRegulationRound
function ThisMightBeTheFinalRound():boolean
	if (Engine_GetCurrentRoundIsOvertimeRound() == true) then
		return false;
	end
	
	if (ThisIsTheFinalRound()) then
		return true;
	end

	return AnyTeamIsOneRoundFromEarlyVictory();	
end

-- Returns if this is the OT round, or this might be (or is) the final regulation round
function ThisMightBeTheFinalRoundOrIsOvertimeRound():boolean
	if (ThisIsTheFinalRoundOrOvertimeRound()) then
		return true;
	end

	return AnyTeamIsOneRoundFromEarlyVictory();
end

-- Returns nil if tied
function GetTeamWithMostRoundWins():mp_team
	if (Engine_MatchIsTiedForRoundsWon()) then
		return nil;
	end

	local mostRoundsWon:number = 0;
	local leader:mp_team = nil;

	for _, team in hpairs(TEAMS.active) do
		local score:number = Team_GetRoundsWon(team);
		if (score > mostRoundsWon) then
			mostRoundsWon = score;
			leader = team;
		end
	end
	
	return leader;
end

-- Returns whether or not a team is one round win away from "early" match victory (i.e. RoundsToWin - 1)
function TeamIsOneRoundFromEarlyVictory(team:mp_team):boolean
	return (team ~= nil) and (Team_GetRoundsWon(team) == (Variant_GetEarlyVictoryRoundCount() - 1));
end

function AnyTeamIsOneRoundFromEarlyVictory():boolean
	local oneAwayFromVictoryRoundCount:number = Variant_GetEarlyVictoryRoundCount() - 1;
	for _, team in hpairs(TEAMS.active) do
		if (Team_GetRoundsWon(team) == oneAwayFromVictoryRoundCount) then
			return true;
		end
	end

	return false;
end

function AnyEnemyTeamIsOneRoundFromEarlyVictory(friendlyTeam:mp_team):boolean
	if (friendlyTeam == nil) then
		print("WARNING: AnyEnemyTeamIsOneRoundFromEarlyVictory called with a nil friendlyTeam arg, returning false!");
		return false;
	end

	local oneAwayFromVictoryRoundCount:number = Variant_GetEarlyVictoryRoundCount() - 1;
	for _, team in hpairs(TEAMS.active) do
		if (team ~= friendlyTeam and 
			Team_TeamsAreEnemies(team, friendlyTeam) and
			Team_GetRoundsWon(team) == oneAwayFromVictoryRoundCount) then

			return true;
		end
	end

	return false;
end

function TeamCouldLoseMatchThisRound(team:mp_team):boolean
	-- Theoretically the round limit params could be configured such that this could be the final round and the match outcome is already decided,
	-- but we will ignore those cases and still consider all teams to potentially be facing a match loss in the final round
	if (ThisIsTheFinalRoundOrOvertimeRound()) then
		return true;
	end

	if (AnyEnemyTeamIsOneRoundFromEarlyVictory(team)) then
		return true;
	end

	return false;
end

function TeamCouldWinMatchThisRound(team:mp_team):boolean
	-- Theoretically the round limit params could be configured such that this could be the final round and the match outcome is already decided,
	-- but we will ignore those cases and still consider all teams to potentially be facing a match win in the final round
	if (ThisIsTheFinalRoundOrOvertimeRound()) then
		return true;
	end

	if (TeamIsOneRoundFromEarlyVictory(team)) then
		return true;
	end

	return false;
end

function AnyEnemyPlayerIsOneRoundFromEarlyVictory(friendlyPlayer:player):boolean
	if (friendlyPlayer == nil) then
		print("WARNING: AnyEnemyPlayerIsOneRoundFromEarlyVictory called with a nil friendlyPlayer arg, returning false!");
		return false;
	end

	if (Variant_GetTeamScoringEnabled()) then
		return AnyEnemyTeamIsOneRoundFromEarlyVictory(Player_GetMultiplayerTeam(friendlyPlayer));
	end

	local oneAwayFromVictoryRoundCount:number = Variant_GetEarlyVictoryRoundCount() - 1;
	for _, player in hpairs(PLAYERS.active) do
		if (player ~= friendlyPlayer and
			player:IsHostile(friendlyPlayer) and
			Player_GetRoundsWon(player) == oneAwayFromVictoryRoundCount) then
			return true;
		end
	end

	return false;
end

function PlayerCouldLoseMatchThisRound(targetPlayer:player):boolean
	-- Theoretically the round limit params could be configured such that this could be the final round and the match outcome is already decided,
	-- but we will ignore those cases and still consider all teams to potentially be facing a match loss in the final round
	if (ThisIsTheFinalRoundOrOvertimeRound()) then
		return true;
	end

	if (AnyEnemyPlayerIsOneRoundFromEarlyVictory(targetPlayer)) then
		return true;
	end

	return false;
end

function GetFinalRoundCleanupEventType():number
	if (Variant_GetTeamIntrosEnabled()) then
		return g_eventTypes.teamOutroStartEvent;
	else
		return g_eventTypes.roundEndEvent;
	end
end

-----------------------------
---- Global MP Messaging ----
-----------------------------

--// Push off banners
global k_pushOffBannerDisplayTimeSec:number = 4.0;

function PushOffBannerForAll(id:string, ignoreRound:boolean):void
	if ((Engine_GetRoundIndex() == 0) or ignoreRound) then
		local objectiveBanner:objective = Engine_CreateObjective("objective_message");
		Objective_SetFormattedText(objectiveBanner, id);

		local bannerThread:thread = CreateThread(KillBannerThread, objectiveBanner);
	end
end

function PushOffBannerForTeam(id:string, teamDesignator:mp_team_designator, ignoreRound:boolean):void
	if ((Engine_GetRoundIndex() == 0) or ignoreRound) then
		local objectiveBanner:objective = Engine_CreateObjective("objective_message");
		local objectiveBannerFilter:player_interaction_filter = Objective_Filter_CreateTeamDesignatorFilter(objectiveBanner);

		Objective_SetFormattedText(objectiveBanner, id);
		Objective_Filter_SetTeamDesignator(objectiveBanner, objectiveBannerFilter, teamDesignator);

		CreateThread(KillBannerThread, objectiveBanner);
	end
end

function KillBannerThread(objective:objective):void
	SleepSeconds(k_pushOffBannerDisplayTimeSec);
	Objective_Delete(objective);
end

--// Banner messaging helpers
function ShowGlobalTeamObjectiveForTime(objective:objective, teamDesignatorMaskFilter:player_interaction_filter, timeSec:number):thread
	return CreateThread(ShowGlobalTeamBannerThread, objective, teamDesignatorMaskFilter, timeSec);
end

function ShowGlobalTeamBannerThread(objective:objective, teamDesignatorMaskFilter:player_interaction_filter, timeSec:number):void
	Objective_Filter_SetTeamDesignatorMaskAll(objective, teamDesignatorMaskFilter, true);
	SleepSeconds(timeSec);
	Objective_Filter_SetTeamDesignatorMaskAll(objective, teamDesignatorMaskFilter, false);
end

function ShowGlobalPlayerObjectiveForTime(objective:objective, playerMaskFilter:player_interaction_filter, timeSec:number):thread
	return CreateThread(ShowGlobalPlayerBannerThread, objective, playerMaskFilter, timeSec);
end

function ShowGlobalPlayerBannerThread(objective:objective, playerMaskFilter:player_interaction_filter, timeSec:number):void
	Objective_Filter_SetPlayersAll(objective, playerMaskFilter, true);
	SleepSeconds(timeSec);
	Objective_Filter_SetPlayersAll(objective, playerMaskFilter, false);
end

function ShowTeamObjectiveForTime(objective:objective, teamDesignatorMaskFilter:player_interaction_filter, team:mp_team, timeSec:number):thread
	return CreateThread(ShowTeamBannerThread, objective, teamDesignatorMaskFilter, Team_GetTeamDesignator(team), timeSec);
end

function ShowAllObjectiveForTime(objective:objective, timeSec:number):thread
	return CreateThread(ShowAllBannerThread, objective, timeSec);
end

function ShowAllBannerThread(objective:objective, timeSec:number):void
	Objective_SetEnabled(objective, true);
	SleepSeconds(timeSec);
	Objective_SetEnabled(objective, false);
end

function ShowTeamBannerThread(objective:objective, teamDesignatorMaskFilter:player_interaction_filter, teamDesignator:mp_team_designator, timeSec:number):void
	Objective_Filter_AddToTeamDesignatorMask(objective, teamDesignatorMaskFilter, teamDesignator);
	SleepSeconds(timeSec);
	Objective_Filter_RemoveFromTeamDesignatorMask(objective, teamDesignatorMaskFilter, teamDesignator);
end

function ShowPlayerObjectiveForTime(objective:objective, playerMaskFilter:player_interaction_filter, player:player, timeSec:number):void
	CreateThread(ShowPlayerBannerThread, objective, playerMaskFilter, player, timeSec);
end

function ShowPlayerBannerThread(objective:objective, playerMaskFilter:player_interaction_filter, player:player, timeSec:number)
	Objective_Filter_SetPlayer(objective, playerMaskFilter, player, true);
	SleepSeconds(timeSec);
	Objective_Filter_SetPlayer(objective, playerMaskFilter, player, false);
end

function ShowSquadObjectiveForTime(objective:objective, squadMaskFilter:player_interaction_filter, squad:mp_squad, timeSec:number):void
	CreateThread(ShowSquadBannerThread, objective, squadMaskFilter, squad, timeSec);
end

function ShowSquadBannerThread(objective:objective, squadMaskFilter:player_interaction_filter, squad:mp_squad, timeSec:number)
	Objective_Filter_SetMultiplayerSquadMask(objective, squadMaskFilter, squad, true);
	SleepSeconds(timeSec);
	Objective_Filter_SetMultiplayerSquadMask(objective, squadMaskFilter, squad, false);
end

-----------------------------------------------------------------------------------------------------------------------------
--## CLIENT
-----------------------------------------------------------------------------------------------------------------------------