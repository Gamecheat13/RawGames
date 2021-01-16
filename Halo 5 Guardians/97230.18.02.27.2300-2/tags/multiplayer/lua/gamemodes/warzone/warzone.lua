
function PlayersOnAttackingTeam(context)
	context.Designator = 1;
	return table.filter(context:GetAllPlayers(),
		function(player)
			return context.Designator == player:GetTeamDesignator();
		end
		);
end
function PlayersOnDefendingTeam(context)
	context.Designator = 1;
	return table.filter(context:GetAllPlayers(),
		function(player)
			return context.Designator ~= player:GetTeamDesignator();
		end
		);
end
function QuestProgressEmit(context, player, currentTicks, totalTicks)
	context.TargetPlayer = player;
	context.CurrentTicks = currentTicks;
	context.TotalTicks = totalTicks;
	context.IsComplete = currentTicks >= totalTicks;
end
function IsQuestCompleteFilter(context)
	return context.IsComplete;
end
function IsQuestIncompleteFilter(context)
	return not context.IsComplete;
end
function PieEarnedEmit(context, player, pieEarned, totalPie, source)
	context.TargetPlayer = player;
	context.PieEarned = pieEarned;
	context.TotalPie = totalPie;
	context.Source = source;
end
function PieSourceIsDrip(context)
	return context.Source == ResolveString("Drip");
end
function BaseIsNamed(baseName)
	return function(context)
		return context.BaseName == ResolveString(baseName);
	end;
end
local baseCoreDamagedAccumulators = {};
baseCoreDamagedAccumulators[0] = root:CreateAccumulator(15);
baseCoreDamagedAccumulators[1] = root:CreateAccumulator(15);
function BaseCoreDamagedTimeoutFilter(context)
	local accumulator = baseCoreDamagedAccumulators[context.Designator];
	local oldValue = accumulator:GetValue();
	local fire = oldValue == 0;
	if fire then
		accumulator:SetValue(1);
	end
	return fire;
end
function PlayersWithDesignatorOrNeutralDesignator(context)
	return table.filter(context:GetAllPlayers(),
		function(player)
			return context.Designator == player:GetTeamDesignator() or context.Designator == TeamDesignator.Neutral;
		end
		);
end
function WithSquadId(squadId)
	return function(context)
		return context.SquadId == ResolveString(squadId);
	end;
end
function AssistingPlayers(context)
	return context.AssistingPlayers;
end
function PlayersKilledByMiniBossFilter(squadId, numberKilled)
	return function(context)
		return context.SquadId == ResolveString(squadId) and context.TotalPlayersKilled == numberKilled;
	end;
end
function LastKill(context)
	return context.BossesRemaining == 0;
end
function TargetPlayerDesignatorProperty(context)
	return context.TargetPlayer:GetTeamDesignator();
end
__OnMiniBossGroupAppeared = Delegate:new();
OnMiniBossGroupAppeared = root:AddCallback(
	__OnMiniBossGroupAppeared,
	function(context, squadId, proximityPlayers)
		context.SquadId = squadId;
		context.ProximityPlayers = proximityPlayers;
	end
	);
onMiniBossGroupAppearedSelect = OnMiniBossGroupAppeared:Select();
__OnMiniBossAppearedVictoryAttainableOneTeam = Delegate:new();
OnMiniBossAppearedVictoryAttainableOneTeam = root:AddCallback(
	__OnMiniBossAppearedVictoryAttainableOneTeam,
	function(context, squadId, proximityPlayers, teamDesignator)
		context.SquadId = squadId;
		context.ProximityPlayers = proximityPlayers;
		context.Designator = teamDesignator;
	end
	);
onMiniBossAppearedVictoryAttainableOneTeamSelect = OnMiniBossAppearedVictoryAttainableOneTeam:Select();
__OnMiniBossAppearedVictoryAttainableBothTeams = Delegate:new();
OnMiniBossAppearedVictoryAttainableBothTeams = root:AddCallback(
	__OnMiniBossAppearedVictoryAttainableBothTeams,
	function(context, squadId, proximityPlayers)
		context.SquadId = squadId;
		context.ProximityPlayers = proximityPlayers;
	end
	);
onMiniBossAppearedVictoryAttainableBothTeamsSelect = OnMiniBossAppearedVictoryAttainableBothTeams:Select();
__OnMiniBossGroupExplored = Delegate:new();
OnMiniBossGroupExplored = root:AddCallback(
	__OnMiniBossGroupExplored,
	function(context, squadId, player, proximityPlayers)
		context.SquadId = squadId;
		context.TargetPlayer = player;
		context.ProximityPlayers = proximityPlayers;
	end
	);
onMiniBossGroupExploredSelect = OnMiniBossGroupExplored:Select();
__OnMiniBossGroupDiscovered = Delegate:new();
OnMiniBossGroupDiscovered = root:AddCallback(
	__OnMiniBossGroupDiscovered,
	function(context, squadId, player, discoveredVpReward, proximityPlayers)
		context.SquadId = squadId;
		context.TargetPlayer = player;
		context.DiscoveredVpReward = discoveredVpReward;
		context.ProximityPlayers = proximityPlayers;
	end
	);
onMiniBossGroupDiscoveredSelect = OnMiniBossGroupDiscovered:Select();
__OnMiniBossAliveWithinScoreRangeWinningTeam = Delegate:new();
OnMiniBossAliveWithinScoreRangeWinningTeam = root:AddCallback(
	__OnMiniBossAliveWithinScoreRangeWinningTeam,
	function(context, squadId, winningTeamDesignator)
		context.SquadId = squadId;
		context.Designator = winningTeamDesignator;
	end
	);
onMiniBossAliveWithinScoreRangeWinningTeamSelect = OnMiniBossAliveWithinScoreRangeWinningTeam:Select();
__OnMiniBossAliveWithinScoreRangeLosingTeam = Delegate:new();
OnMiniBossAliveWithinScoreRangeLosingTeam = root:AddCallback(
	__OnMiniBossAliveWithinScoreRangeLosingTeam,
	function(context, squadId, losingTeamDesignator)
		context.SquadId = squadId;
		context.Designator = losingTeamDesignator;
	end
	);
onMiniBossAliveWithinScoreRangeLosingTeamSelect = OnMiniBossAliveWithinScoreRangeLosingTeam:Select();
MinibossType = 
{
	Miniboss = 0,
	Ultraboss = 1,
	Mythicboss = 2
};
__OnMiniBossKilled = Delegate:new();
OnMiniBossKilled = root:AddCallback(
	__OnMiniBossKilled,
	function(context, squadId, bossId, player, assistingPlayers, friendlyPlayers, bossesRemaining, vpEarned, pieEarned, proximityPlayers, bossType)
		context.SquadId = squadId;
		context.BossId = bossId;
		context.TargetPlayer = player;
		context.AssistingPlayers = assistingPlayers;
		context.FriendlyPlayers = friendlyPlayers;
		context.BossesRemaining = bossesRemaining;
		context.VPEarned = vpEarned;
		context.PieEarned = pieEarned;
		context.ProximityPlayers = proximityPlayers;
		context.BossType = bossType;
	end
	);
onMiniBossKilledSelect = OnMiniBossKilled:Select();
__OnMiniBossKilledTeammate = Delegate:new();
OnMiniBossKilledTeammate = root:AddCallback(
	__OnMiniBossKilledTeammate,
	function(context, squadId, player, totalPlayersKilled, proximityPlayers)
		context.SquadId = squadId;
		context.TargetPlayer = player;
		context.TotalPlayersKilled = totalPlayersKilled;
		context.ProximityPlayers = proximityPlayers;
	end
	);
onMiniBossKilledTeammateSelect = OnMiniBossKilledTeammate:Select();
GruntType = CampaignMetagameType.Grunt;
JackalType = CampaignMetagameType.Jackal;
EliteType = CampaignMetagameType.Elite;
HunterType = CampaignMetagameType.Hunter;
CrawlerType = CampaignMetagameType.Pawn;
SoldierType = CampaignMetagameType.Soldier;
KnightType = CampaignMetagameType.Knight;
WatcherType = CampaignMetagameType.Bishop;
WardenType = CampaignMetagameType.Cavalier;
MarineType = CampaignMetagameType.Marine;
BansheeType = CampaignMetagameType.Banshee;
GhostType = CampaignMetagameType.Ghost;
MantisType = CampaignMetagameType.Mantis;
MongooseType = CampaignMetagameType.Mongoose;
WaspType = CampaignMetagameType.Wasp;
PhaetonType = CampaignMetagameType.Phaeton;
ScorpionType = CampaignMetagameType.Scorpion;
WarthogType = CampaignMetagameType.Warthog;
WraithType = CampaignMetagameType.Wraith;
PhantomType = CampaignMetagameType.Phantom;
SpiritType = CampaignMetagameType.TuningFork;
local AllAiTypesAndNames = 
{
	{ "grunt", 		GruntType },
	{ "jackal", 	JackalType },
	{ "elite", 		EliteType },
	{ "hunter", 	HunterType },
	{ "crawler", 	CrawlerType },
	{ "soldier", 	SoldierType },
	{ "knight", 	KnightType },
	{ "watcher", 	WatcherType },
	{ "warden", 	WardenType },
	{ "marine", 	MarineType },
	{ "banshee", 	BansheeType },
	{ "ghost", 		GhostType },
	{ "mantis", 	MantisType },
	{ "mongoose", 	MongooseType },
	{ "wasp",		WaspType },
	{ "phaeton", 	PhaetonType },
	{ "scorpion", 	ScorpionType },
	{ "warthog", 	WarthogType },
	{ "wraith", 	WraithType },
	{ "phantom", 	PhantomType },
	{ "spirit",		SpiritType },
}
local AllAiTypes = 
{
	GruntType,
	JackalType,
	EliteType,
	HunterType,
	CrawlerType,
	SoldierType,
	KnightType,
	WatcherType,
	WardenType,
	MarineType,
	BansheeType,
	GhostType,
	MantisType,
	MongooseType,
	WaspType,
	PhaetonType,
	ScorpionType,
	WarthogType,
	WraithType,
	PhantomType,
	SpiritType
}
function GetUltimateCampaignMetagameTypeFromKill(context)
	local ultimateKillingUnit = context.KillingObject;
	if context.KillingObject.GetVehicle ~= nil then
		local vehicleParent = context.KillingObject:GetVehicle();
		if vehicleParent ~= nil then
			ultimateKillingUnit = vehicleParent;
		end
	end
	if ultimateKillingUnit.GetCampaignMetagameType ~= nil then
		return ultimateKillingUnit:GetCampaignMetagameType();
	else
		return nil;
	end
end
onDeathByAi = onKill:Filter(
	function(context)
		context.TargetPlayer = context.DeadPlayer;
		if context.KillingObject == nil or 
			(context.KillingObject.IsBossUnit ~= nil and context.KillingObject:IsBossUnit() == true) then
			return false;
		end
		context.KillingMetagameType = GetUltimateCampaignMetagameTypeFromKill(context);
		if context.KillingMetagameType == nil then
			return false;
		end
		return table.any(AllAiTypes,
			function(aiType)
				return context.KillingMetagameType == aiType;
			end
			);
	end
	);
onDeathByAiSelect = onDeathByAi:Select();
function BuildDeathByAiResponses(aiUnitName, source)
	local globals = _G;
	globals[aiUnitName .. "KilledYouResponse"] = source:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = aiUnitName .. "_killed_you"
	});
end
for index, allAi in ipairs(AllAiTypesAndNames) do
	local aiNameIndex = 1;
	local aiTypeIndex = 2;
	local aiUnitName = allAi[aiNameIndex];
	local sourceEvent = onDeathByAiSelect:Add(
		function(context)
			return context.KillingMetagameType == allAi[aiTypeIndex];
		end
		);
	BuildDeathByAiResponses(aiUnitName, sourceEvent);
end
__OnQuestProgress = Delegate:new();
onQuestProgress = root:AddCallback(
	__OnQuestProgress,
	QuestProgressEmit
	);
onQuestProgress:Filter(IsQuestIncompleteFilter):Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = function (context)
			return FormatText('quest_progress', context.CurrentTicks, context.TotalTicks);
		end
	});
__OnQuestProgressKillPlayers = Delegate:new();
onQuestProgressKillPlayers = root:AddCallback(
	__OnQuestProgressKillPlayers,
	QuestProgressEmit
	);
killPlayersQuestProgress = onQuestProgressKillPlayers:Target(TargetPlayer):Response(
	{
		PersonalScore = 100,
	});	
__OnQuestProgressAssistKillPlayers = Delegate:new();
onQuestProgressAssistKillPlayers = root:AddCallback(
	__OnQuestProgressAssistKillPlayers,
	QuestProgressEmit
	);
assistPlayersQuestProgress = onQuestProgressAssistKillPlayers:Target(TargetPlayer):Response(
	{
		PersonalScore = 50,
	});	
__OnObjectiveBaseDefenseKill = Delegate:new();
onObjectiveBaseDefenseKill = root:AddCallback(
	__OnObjectiveBaseDefenseKill,
	function(context, killingPlayer)
		context.TargetPlayer = killingPlayer;
	end);
objectiveBaseDefenseKillResponse = onObjectiveBaseDefenseKill:Target(TargetPlayer):Response(
	{
		Medal = 'wz_base_defense',
		ImpulseEvent = 'impulse_base_defense',
		PersonalScore = 10,
	});		
__OnObjectiveBaseAssaultKill = Delegate:new();
onObjectiveBaseAssaultKill = root:AddCallback(
	__OnObjectiveBaseAssaultKill,
	function(context, killingPlayer)
		context.TargetPlayer = killingPlayer;
	end);	
objectiveBaseAssaultKillResponse = onObjectiveBaseAssaultKill:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'impulse_base_assault'
	})
__OnHomeBaseDefenseKill = Delegate:new();
onHomeBaseDefenseKill = root:AddCallback(
	__OnHomeBaseDefenseKill,
	function(context, killingPlayer)
		context.TargetPlayer = killingPlayer;
	end);
homeBaseDefenseKillResponse = onHomeBaseDefenseKill:Target(TargetPlayer):Response(
	{
		Medal = 'core_defense',
		ImpulseEvent = 'impulse_core_defense',
		PersonalScore = 10,
	});	
__OnHomeBaseAssaultKill = Delegate:new();
onHomeBaseAssaultKill = root:AddCallback(
	__OnHomeBaseAssaultKill,
	function(context, killingPlayer)
		context.TargetPlayer = killingPlayer;
	end);	
homeBaseAssaultKillResponse = onHomeBaseAssaultKill:Target(TargetPlayer):Response(
	{
		ImpulseEvent = 'impulse_core_assault'
	})	
__OnPieEarned = Delegate:new();
onPieEarned = root:AddCallback(
	__OnPieEarned,
	PieEarnedEmit
	);
onPieEarnedSelect = onPieEarned:Select();
onPieEarnedDrip = onPieEarnedSelect:Add(PieSourceIsDrip);
onPieEarnedDefault = onPieEarnedSelect:Add();
pieEarnedDefaultResponse = onPieEarnedDefault:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\sound_effects\sound_effects_warzone_pie'
	});
__OnPlayerLevelChanged = Delegate:new();
function PlayerLevelChangedEmit(context, player, level)
	context.TargetPlayer = player;
	context.Level = level;
end
onPlayerLevelChanged = root:AddCallback(
	__OnPlayerLevelChanged,
	PlayerLevelChangedEmit
	);
onPlayerLevelChangedSelect = onPlayerLevelChanged:Select();
local PlayerLevelResponses =
{
	{
		Level = 2,
		Response =
		{
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_leveluplevel2'
			},
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_levelup'
			}
		}
	},
	{
		Level = 3,
		Response =
		{
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_leveluplevel3'
			},
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_levelup'
			}
		}
	},
	{
		Level = 4,
		Response =
		{
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_leveluplevel4'
			},
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_levelup'
			}
		}
	},
	{	
		Level = 5,
		Response =
		{
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_leveluplevel5'
			},
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_levelup'
			}
		}
	},
	{
		Level = 6,
		Response =
		{
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_leveluplevel6'
			},
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_levelup'
			}
		}
	},
	{
		Level = 7,
		Response =
		{
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_leveluplevel7'
			},
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_levelup'
			}
		}
	},
	{
		Level = 8,
		Response =
		{
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_leveluplevel8'
			},
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_levelup'
			}
		}
	},
	{
		Level = 9,
		Response =
		{
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_leveluplevel9'
			},
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_levelup'
			}
		}
	}
};
function LevelIs(level)
	return function(context)
		return context.Level == level;
	end
end
for _, levelResponse in ipairs(PlayerLevelResponses) do
	local target = onPlayerLevelChangedSelect:Add(LevelIs(levelResponse.Level)):Target(TargetPlayer);
	if type(levelResponse.Response) == 'table' then
		for i, levelResponseItem in ipairs(levelResponse.Response) do
			target = target:Response(levelResponseItem);
			if i == 1 then
				_G['PlayerLevelChanged_' .. tostring(levelResponse.Level)] = target;
			else
				_G['PlayerLevelChanged_' .. tostring(levelResponse.Level) .. '_' .. tostring(i)] = target;
			end
		end
	else
		_G['PlayerLevelChanged_' .. tostring(levelResponse.Level)] = target:Response(levelResponse.Response);
	end
end
onPlayerLevelChangedDefault = onPlayerLevelChangedSelect:Add();
PlayerLevelResponse = onPlayerLevelChangedDefault:Target(TargetPlayer):Response(
	{
	});
__OnQuestProgressKillMarines = Delegate:new();
onQuestProgressKillMarines = root:AddCallback(
	__OnQuestProgressKillMarines,
	QuestProgressEmit
	);
killMarineQuestProgress = onQuestProgressKillMarines:Target(TargetPlayer):Response(
	{
		Medal = 'marine_kill',
		PersonalScore = 10,
	});
__OnQuestProgressAssistKillMarines = Delegate:new();
onQuestProgressAssistKillMarines = root:AddCallback(
	__OnQuestProgressAssistKillMarines,
	QuestProgressEmit
	);
assistMarineQuestProgress = onQuestProgressAssistKillMarines:Target(TargetPlayer):Response(
	{
		Medal = 'marine_assist',
		PersonalScore = 5,
	});
__OnQuestProgressKillMongooseVehicles = Delegate:new();
onQuestProgressKillMongooseVehicles = root:AddCallback(
	__OnQuestProgressKillMongooseVehicles,
	QuestProgressEmit
	);
killMongooseVehiclesQuestProgress = onQuestProgressKillMongooseVehicles:Target(TargetPlayer):Response(
	{
		PersonalScore = 50,
	});
-- 
__OnQuestProgressKillWarthogVehicles = Delegate:new();
onQuestProgressKillWarthogVehicles = root:AddCallback(
	__OnQuestProgressKillWarthogVehicles,
	QuestProgressEmit
	);
killWarthogVehiclesQuestProgress = onQuestProgressKillWarthogVehicles:Target(TargetPlayer):Response(
	{
		PersonalScore = 100,
	});
-- 
__OnQuestProgressKillScorpionVehicles = Delegate:new();
onQuestProgressKillScorpionVehicles = root:AddCallback(
	__OnQuestProgressKillScorpionVehicles,
	QuestProgressEmit
	);
killScorpionVehiclesQuestProgress = onQuestProgressKillScorpionVehicles:Target(TargetPlayer):Response(
	{
		PersonalScore = 250,
	});
-- 
__OnQuestProgressKillGhostVehicles = Delegate:new();
onQuestProgressKillGhostVehicles = root:AddCallback(
	__OnQuestProgressKillGhostVehicles,
	QuestProgressEmit
	);
killGhostVehiclesQuestProgress = onQuestProgressKillGhostVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(250),
		PersonalScore = 100,
	});
-- 
__OnQuestProgressKillBansheeVehicles = Delegate:new();
onQuestProgressKillBansheeVehicles = root:AddCallback(
	__OnQuestProgressKillBansheeVehicles,
	QuestProgressEmit
	);
killBansheeVehiclesQuestProgress = onQuestProgressKillBansheeVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(500),
		PersonalScore = 250,
	});
-- 
__OnQuestProgressKillWaspVehicles = Delegate:new();
onQuestProgressKillWaspVehicles = root:AddCallback(
	__OnQuestProgressKillWaspVehicles,
	QuestProgressEmit
	);
killWaspVehiclesQuestProgress = onQuestProgressKillWaspVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(250),
		PersonalScore = 100,
	});
-- 
__OnQuestProgressKillWraithVehicles = Delegate:new();
onQuestProgressKillWraithVehicles = root:AddCallback(
	__OnQuestProgressKillWraithVehicles,
	QuestProgressEmit
	);
killWraithVehiclesQuestProgress = onQuestProgressKillWraithVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(500),
		PersonalScore = 250,
	});
-- 
__OnQuestProgressKillVtolVehicles = Delegate:new();
onQuestProgressKillVtolVehicles = root:AddCallback(
	__OnQuestProgressKillVtolVehicles,
	QuestProgressEmit
	);
killVtolVehiclesQuestProgress = onQuestProgressKillVtolVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(500),
		PersonalScore = 250,
	});
-- 
__OnQuestProgressKillMantisVehicles = Delegate:new();
onQuestProgressKillMantisVehicles = root:AddCallback(
	__OnQuestProgressKillMantisVehicles,
	QuestProgressEmit
	);
killMantisVehiclesQuestProgress = onQuestProgressKillMantisVehicles:Target(TargetPlayer):Response(
	{
		PersonalScore = 250,
	});
__OnQuestProgressAssistMongooseVehicles = Delegate:new();
onQuestProgressAssistMongooseVehicles = root:AddCallback(
	__OnQuestProgressAssistMongooseVehicles,
	QuestProgressEmit
	);
assistMongooseVehiclesQuestProgressResponse = onQuestProgressAssistMongooseVehicles:Target(TargetPlayer):Response(
	{
		PersonalScore = 25,
	});
__OnQuestProgressAssistWarthogVehicles = Delegate:new();
onQuestProgressAssistWarthogVehicles = root:AddCallback(
	__OnQuestProgressAssistWarthogVehicles,
	QuestProgressEmit
	);
assistWarthogVehiclesQuestProgressResponse = onQuestProgressAssistWarthogVehicles:Target(TargetPlayer):Response(
	{
		PersonalScore = 50,
	});	
__OnQuestProgressAssistScorpionVehicles = Delegate:new();
onQuestProgressAssistScorpionVehicles = root:AddCallback(
	__OnQuestProgressAssistScorpionVehicles,
	QuestProgressEmit
	);
assistScorpionVehiclesQuestProgressResponse = onQuestProgressAssistScorpionVehicles:Target(TargetPlayer):Response(
	{
		PersonalScore = 100,
	});
__OnQuestProgressAssistGhostVehicles = Delegate:new();
onQuestProgressAssistGhostVehicles = root:AddCallback(
	__OnQuestProgressAssistGhostVehicles,
	QuestProgressEmit
	);
assistGhostVehiclesQuestProgressResponse = onQuestProgressAssistGhostVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(100),
		PersonalScore = 50,
	});
__OnQuestProgressAssistBansheeVehicles = Delegate:new();
onQuestProgressAssistBansheeVehicles = root:AddCallback(
	__OnQuestProgressAssistBansheeVehicles,
	QuestProgressEmit
	);
assistBansheeVehiclesQuestProgressResponse = onQuestProgressAssistBansheeVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(250),
		PersonalScore = 100,
	});
__OnQuestProgressAssistWaspVehicles = Delegate:new();
onQuestProgressAssistWaspVehicles = root:AddCallback(
	__OnQuestProgressAssistWaspVehicles,
	QuestProgressEmit
	);
assistWaspVehiclesQuestProgressResponse = onQuestProgressAssistWaspVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(100),
		PersonalScore = 50,
	});
__OnQuestProgressAssistWraithVehicles = Delegate:new();
onQuestProgressAssistWraithVehicles = root:AddCallback(
	__OnQuestProgressAssistWraithVehicles,
	QuestProgressEmit
	);
assistWraithVehiclesQuestProgressResponse = onQuestProgressAssistWraithVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(250),
		PersonalScore = 100,
	});
__OnQuestProgressAssistVtolVehicles = Delegate:new();
onQuestProgressAssistVtolVehicles = root:AddCallback(
	__OnQuestProgressAssistVtolVehicles,
	QuestProgressEmit
	);
assistVtolVehiclesQuestProgressResponse = onQuestProgressAssistVtolVehicles:Target(TargetPlayer):Response(
	{
		Score = GetScoreVal(250),
		PersonalScore = 100,
	});
__OnQuestProgressAssistMantisVehicles = Delegate:new();
onQuestProgressAssistMantisVehicles = root:AddCallback(
	__OnQuestProgressAssistMantisVehicles,
	QuestProgressEmit
	);
assistMantisVehiclesQuestProgressResponse = onQuestProgressAssistMantisVehicles:Target(TargetPlayer):Response(
	{
		PersonalScore = 100,
	});
__OnQuestProgressKillDeliveryVehicles = Delegate:new();
onQuestProgressKillDeliveryVehicles = root:AddCallback(
	__OnQuestProgressKillDeliveryVehicles,
	QuestProgressEmit
	);
destroyDeliveryVehiclesQuestProgressResponse = onQuestProgressKillDeliveryVehicles:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_vehicledestroyedphantom',
		PersonalScore = 500,
	});
__OnQuestProgressWheelmanAssist = Delegate:new();
onQuestProgressWheelmanAssist = root:AddCallback(
	__OnQuestProgressWheelmanAssist,
	QuestProgressEmit
	);
wheelmanAssistQuestProgressResponse = onQuestProgressWheelmanAssist:Target(TargetPlayer):Response(
	{
		PersonalScore = 50,
	});
__OnBaseCoreDamaged = Delegate:new();
onBaseCoreDamaged = root:AddCallback(
	__OnBaseCoreDamaged,
	function(context, coreTeamDesignator, coreHealth)
		context.Designator = coreTeamDesignator;
		context.CoreHealth = coreHealth;
	end
	):Changed(
		1.0,
		function(context)
			return context.CoreHealth;
		end
	);
baseCoreDamagedFiltered = onBaseCoreDamaged:Filter(BaseCoreDamagedTimeoutFilter);
baseCoreDamagedFriendly = baseCoreDamagedFiltered:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_coresunderattack'
	});
baseCoreDamagedHostile = baseCoreDamagedFiltered:Target(PlayersWithoutDesignator):Response(
	{
	});
onCore75Vitality = onBaseCoreDamaged:Changed(
	false,
	function(context)
		return (context.CoreHealth <= 0.75);
	end
	);
friendlyCoreDamaged75 = onCore75Vitality:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_friendlycorewarning75percent'
	});
hostileCoreDamaged75 = onCore75Vitality:Target(PlayersWithoutDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_enemycorewarning75percent'
	});
onCore50Vitality = onBaseCoreDamaged:Changed(
	false,
	function(context)
		return (context.CoreHealth <= 0.50);
	end
	);
friendlyCoreDamaged50 = onCore50Vitality:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_friendlycorewarninghalf'
	});
hostileCoreDamaged50 = onCore50Vitality:Target(PlayersWithoutDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_enemycorewarninghalf'
	});
onCore25Vitality = onBaseCoreDamaged:Changed(
	false,
	function(context)
		return (context.CoreHealth <= 0.25);
	end
	);		
friendlyCoreDamaged25 = onCore25Vitality:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_friendlycorewarning25percent'
	});
hostileCoreDamaged25 = onCore25Vitality:Target(PlayersWithoutDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_enemycorewarning25percent'
	});
onCore10Vitality = onBaseCoreDamaged:Changed(
	false,
	function(context)
		return (context.CoreHealth <= 0.10);
	end
	);
friendlyCoreDamaged10 = onCore10Vitality:Target(PlayersWithDesignator):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_friendlycorewarningimminent'	
	});
hostileCoreDamaged10 = onCore10Vitality:Target(PlayersWithoutDesignator):Response(
	{	
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_enemycorewarningimminent'
	});
__OnBaseCaptured = Delegate:new();
onBaseCaptured = root:AddCallback(
	__OnBaseCaptured,
	function(context, controllingTeamDesignator, capturingPlayers, baseName, baseVpReward)
		context.Designator = controllingTeamDesignator;
		context.CapturingPlayers = capturingPlayers;
		context.BaseName = baseName;
		context.BaseVpReward = baseVpReward;
	end
	);
onBaseCapturedMedal = onBaseCaptured:Target(CapturingPlayers):Response(
	{
		Medal = 'wz_base_capture',
		PersonalScore = 200,
	}):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_basecaptured_pos',
		ImpulseEvent = 'impulse_base_captured'
	});
onGenericBaseLost = onBaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_basecaptured_neg'
	});
__OnTerminalCooldownFinished = Delegate:new();
onTerminalCooldownFinished = root:AddCallback(
	__OnTerminalCooldownFinished,
	function(context, player)
		context.TargetPlayer = player;
	end
	);
onTerminalCoolDownFinishedResponse = onTerminalCooldownFinished:Target(TargetPlayer):Response(
	{
	});
function CardIsConsumable(context)
	return context.CardIsConsumable;
end
__OnRequisitionCardEquipped = Delegate:new();
onRequisitionCardEquipped = root:AddCallback(
	__OnRequisitionCardEquipped,
	function(context, player, isConsumable)
		context.TargetPlayer = player;
		context.CardIsConsumable = isConsumable;
	end
	);
onRequisitionCardEquipped:Filter(CardIsConsumable):Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_terminalgenericpurchase'
	});
__OnRequisitionCardDispensed = Delegate:new();
onRequisitionCardDispensed = root:AddCallback(
	__OnRequisitionCardDispensed,
	function(context, player, isConsumable)
		context.TargetPlayer = player;
		context.CardIsConsumable = isConsumable;
	end
	);
onRequisitionCardDispensedResponse = onRequisitionCardDispensed:Target(TargetPlayer):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_terminalgenericpurchase'
	});
__OnWarzoneRoundTimeout = Delegate:new();
onWarzoneRoundTimeout = root:AddCallback(
	__OnWarzoneRoundTimeout,
	function (context, winningPlayer)
		context.TargetPlayer = winningPlayer;
	end
	);
warzoneRoundTimeoutWinResponse = onWarzoneRoundTimeout:Target(TargetPlayer):Response(
	{
	});
warzoneRoundTimeoutWinTeamResponse = onWarzoneRoundTimeout:Target(FriendlyToTargetPlayer):Response(
	{
	});
warzoneRoundTimeoutLoseResponse = onWarzoneRoundTimeout:Target(HostileToTargetPlayer):Response(
	{
	});
minibossDefaultExtraDefinitions = 
{
	exploredPlayerResponse =
	{
		Medal = 'explore',
	},
};
warzoneServerShutdownWarningResponse = onServerShutdown:Target(TargetAllPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'server_shutdown_warning_warzone',
	});
function ContributingPlayersTarget(context)
	local contributingPlayers = table.copy(context.AssistingPlayers);
	table.insert(contributingPlayers, context.TargetPlayer);
	return contributingPlayers;
end
miniBossKilledStatsSelect = OnMiniBossKilled:Select();
mythicBossKillsStatResponse = miniBossKilledStatsSelect:Add(
	function (context)
		return context.BossType == MinibossType.Mythicboss;
	end
	):Target(ContributingPlayersTarget):Response(
	{
		PlatformImpulse = 'MythicKill',
		PersonalScore = 1500,
	});
legendaryBossKillsStatResponse = miniBossKilledStatsSelect:Add(
	function (context)
		return context.BossType == MinibossType.Ultraboss;
	end
	):Target(ContributingPlayersTarget):Response(
	{
		PlatformImpulse = 'LegendaryKill',
		PersonalScore = 1000,
	});
bossKillsStatResponse = miniBossKilledStatsSelect:Add():Target(ContributingPlayersTarget):Response(
	{
		PlatformImpulse = 'BossKill',
		PersonalScore = 500,
	});