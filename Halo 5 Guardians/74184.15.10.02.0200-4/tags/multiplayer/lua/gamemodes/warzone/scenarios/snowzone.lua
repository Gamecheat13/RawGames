--
-- Snowzone-Specific Warzone Intro
--

__OnWarzoneIntro = Delegate:new();

onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);

warzoneArcIntroResponse = onWarzoneIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_welcometowarzone2',
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_warzonemodeinstruction2',
	});
		
__OnWarzoneBaseIntro = Delegate:new();

onWarzoneBaseIntro = root:AddCallback(
	__OnWarzoneBaseIntro
	);

warzoneBaseIntroResponse = onWarzoneBaseIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultprometheans3',
	}):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultdescriptive',
	});
	
__OnWarzoneSpawned = Delegate:new();

onWarzoneSpawned = root:AddCallback(
	__OnWarzoneSpawned
	);

warzoneBaseIntroResponse = onWarzoneSpawned:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_supportmarinesgeneric',
	});

--
-- Snowzone Base Captured Events
--
	
onBaseCapturedSelect = onBaseCaptured:Select();

-- West Armory

onRedFieldbaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('defender midbase'));

onRedFieldbaseCapturedCapturing = onRedFieldbaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	});

onRedFieldbaseCapturedFriendly = onRedFieldbaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	});

onRedFieldbaseCapturedHostile = onRedFieldbaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_mid_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedhostile'
	});

-- East Armory

onBlueFieldbaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('attacker midbase'));

onBlueFieldbaseCapturedCapturing = onBlueFieldbaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	});

onBlueFieldbaseCapturedFriendly = onBlueFieldbaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	});

onBlueFieldbaseCapturedHostile = onBlueFieldbaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_mid_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedhostile'
	});

-- Fortress

onFortressCaptured = onBaseCapturedSelect:Add(BaseIsNamed('shared midbase'));

onFortressCapturedCapturing = onFortressCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_fortress_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedfriendly'
	});

onFortressCapturedFriendly = onFortressCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_fortress_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedfriendly'
	});

onFortressCapturedHostile = onFortressCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_fortress_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedhostile'
	});

--
-- Defend
--

defendResponses =
{

	-- objective_base_mid (test chamber)
	
	{
		name = "objective_base_mid",

		responses = 
		{
			beginResponse =
			{
			},

			successResponse =
			{
			},	
		},
	},
	
	-- Blue Home Base
	{
		name = "attacker_homebase",

		responses = 
		{
			beginResponse =
			{
			},

			successResponse =
			{
			},
		},
	},
	
	-- Red Home Base
	{
		name = "defender_homebase",

		responses = 
		{
			beginResponse =
			{
			},

			successResponse =
			{
			},
		},
	},
	
	-- Fortress
	{
		name = "shared midbase",

		responses = 
		{
			beginResponse =
			{
			},

			successResponse =
			{
			},
		},
	},

}
	
--
-- Snowzone Boss Definitions
--

minibossDefinitions =
{
	--
	-- Snowzone: HUNTER BOSS -- Defender Side
	--
	
	{
		name = "hunterBrosBoss",

		label = 'def_boss_hunter_bros',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosssztransportcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_transport_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntertransportspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_hunters_def_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywinmultiple',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywinmultiple',
			},
	
			exploredPlayerResponse =
			{
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_def_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			progressAssistResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_def_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},

			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_def_kill_teamfeed_01'
				}
			},
	
			progressFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressfriendly',
			},

			progressEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_def_killed_enemymessage_01'
				}
			},
	
			progressEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressenemy',
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_def_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_def_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_def_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressfriendly'	
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_def_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressenemy'
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterteammateskilled'
			},
	
		},

		killedTeammatesCount = 1,

	},

	-- Snowzone: HUNTER BOSS -- Attacker Side
	{
		name = "hunterBrosBoss",

		label = 'att_boss_hunter_bros',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszshippingcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_shipping_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntershippingpawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_hunters_att_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywinmultiple',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywinmultiple',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			progressAssistResponse =
			{		
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},

			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_kill_teamfeed_01'
				}
			},
	
			progressFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressfriendly',
			},

			progressEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_killed_enemymessage_01'
				}
			},
	
			progressEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressenemy',
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressfriendly'	
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressenemy'
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterteammateskilled'
			},
	
		},

		killedTeammatesCount = 1,

	},

	--
	-- Snowzone: KNIGHT COMMANDER BOSS -- Defender Side
	--
	
	{
		name = "knightDefBoss",

		label = 'ice_def_clear_knight',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcaveprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_frozencave_prometheans'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcavespawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_knight_def_spawned'
					},
				},
			},
	
			appearedResponse =
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{						
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_def_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_def_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_def_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_def_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompletehostile',
			},
		
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},

	--
	-- Snowzone: KNIGHT COMMANDER BOSS -- Attacker Side -- Ice Cavern
	--
	
	{
		name = "knightAttBoss",

		label = 'ice_att_clear_knight',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcavernprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_icecavern_prometheans'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcavernspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_knight_att_spawned'
					},
				},
			},
	
			appearedResponse =
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_att_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_att_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_att_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_att_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompletehostile',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},

	--
	-- Snowzone: SOLDIER BOSS -- Defender Side
	--
	
	{
		name = "iceSoldierOfficerDefBoss",

		label = 'ice_boss_def_officer',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosssztransportprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_transport_prometheans'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiertransportspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_officer_def_spawned'
					},
				},
			},
	
			appearedResponse = 
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldierteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},

	--
	-- Snowzone: SOLDIER OFFICER BOSS -- Attacker Side
	--
	
	{
		name = "iceSoldierOfficerAttBoss",

		label = 'ice_boss_att_officer',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszshippingprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_shipping_prometheans'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiershippingspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_officer_att_spawned'
					},
				},
			},
	
			appearedResponse = 
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldierteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},
	
	--
	-- Snowzone: ELITE GENERAL BOSS -- Defender Side
	--
	
	{
		name = "iceEliteUltraDefBoss",

		label = 'ice_boss_def_ultra',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosssztransportcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_transport_covenant'
						
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultratransportspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_ultra_def_spawned'
					},
				},
			},
	
			appearedResponse = 
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{						
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_ultra_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_ultra_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_ultra_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultracompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_ultra_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultracompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultrateammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},

	--
	-- Snowzone: ELITE ULTRA BOSS-- Attacker Side
	--
	
	{
		name = "iceEliteUltraAttBoss",

		label = 'ice_boss_att_ultra',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszshippingcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_shipping_covenant'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultrashippingspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_ultra_att_spawned'
					},
				},
			},
	
			appearedResponse = 
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_ultra_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_ultra_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_ultra_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultracompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_ultra_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultracompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultrateammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},

	--
	-- Snowzone: KNIGHT BATTLEWAGON -- Neutral Area -- Cargo Dock
	--
	
	{
		name = "KnightNeutralBoss",

		label = 'ice_boss_stage_knights',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcargodockprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_cargodock_prometheans'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagonspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_stage_knight_spawned'
					},
				},
			},
	
			appearedResponse =
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagoncompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_knights_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagoncompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_knights_kill_fanfare_01'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_knights_kill_teamfeed_01'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagoncompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_knights_killed_enemymessage_01'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagoncompleteenemy',
			},	
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagonteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},

	--
	-- Snowzone: CAMOUFLAGED MAJOR -- Neutral Area -- Pit
	--
	
	{
		name = "CamouflagedMajorBoss",

		label = 'ice_boss_pit_camomajor',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszoutpostcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_outpost_covenant'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamospawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_camomajor_spawned'
					},
				},
			},
	
			appearedResponse =
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamocompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_camomajor_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamocompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_camomajor_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_camomajor_kill_teamfeed'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamocompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_camomajor_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamocompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamoteammateskilled',
			},
		},

		killedTeammatesCount = 1,

	},
	
	--
	-- Snowzone: WRAITH OFFICER -- Neutral Area -- Cargo Dock
	--
	
	{
		name = "WraithOfficerBoss",

		label = 'ice_boss_stage_wraith',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcargodockcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_cargodock_covenant'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwraithspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_wraith_spawned'
					},
				},
			},
	
			appearedResponse =
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwraithcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_wraith_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwraithcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_wraith_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_wraith_kill_teamfeed'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwraithcompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_wraith_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwraithcompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwraithteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},
	
	--
	-- Snowzone: PHANTOM PILOT -- Neutral Area -- Cargo Dock
	--
	
	{
		name = "PhantomPilotBoss",

		label = 'ice_boss_stage_phantom',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcargodockcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_cargodock_covenant'
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_phantom_spawned'
					},
				},
			},
	
			appearedResponse =
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedenemywin',
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
	
			exploredPlayerResponse =
			{			
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomwinrangefriendly',
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomwinrangehostile',
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomwinrangefriendly',
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_phantom_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_phantom_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_phantom_kill_teamfeed'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomcompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_phantom_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomcompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszphantomteammateskilled',
			},
	
		},

		killedTeammatesCount = 3,

	},
	
	--
	-- SNOWZONE: LOCHAGOS Boss Fortress
	--
	
	{
		name = "fortressKnightBoss",

		label = 'boss_fortress_knight',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszfortressprometheanappeared2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_fortress_prometheans'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagosspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_lochagos_spawned_message'
					},
				},
			},
	
			appearedResponse = 
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedenemywin',
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			exploredPlayerResponse =
			{
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagoswinrangefriendly',
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagoswinrangehostile',
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagoswinrangefriendly',
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagoscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_fort_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagoscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_fort_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_fort_kill_teamfeed'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagoscompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_knight_fort_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagoscompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszlochagosteammateskilled',
			},
	
		},

		killedTeammatesCount = 3,

	},

	--
	-- SNOWZONE: WARDEN Boss -- Pit
	--
	
	{
		name = "pitWardenBoss",

		label = 'ice_boss_pit_warden',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszoutpostprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_outpost_prometheans'
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric4',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_warden_spawned'
					},
				},
			},
	
			appearedResponse = 
			{
			},
			
			appearedVictoryAttainableOneTeamFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			appearedVictoryAttainableOneTeamEnemyResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedenemywin',
			},
			
			appearedVictoryAttainableBothTeamsResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossspawnedfriendlywin2',
			},
			
			exploredPlayerResponse =
			{
			},
	
			discoveredPlayerResponse =
			{			
			},
			
			discoveredFriendlyProximityResponse =
			{			
			},
	
			discoveredEnemyProximityResponse =
			{			
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenwinrangefriendly',
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenwinrangehostile',
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenwinrangefriendly',
			},
	
			progressPlayerResponse =
			{
			},
	
			progressAssistResponse =
			{		
			},

			progressFriendlyResponse = 
			{
			},
	
			progressFriendlyProximityResponse =
			{
			},

			progressEnemyResponse = 
			{
			},
	
			progressEnemyProximityResponse =
			{
			},
	
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_pit_warden_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_pit_warden_kill_fanfare'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
	
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_pit_warden_kill_teamfeed'
				}
			},
	
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompletefriendly',
			},
	
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_pit_warden_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenteammateskilled',
			},
	
		},

		killedTeammatesCount = 3,

	},
};


--
-- Death By SNOWZONE Boss
--


k_SnowLochagos	 	= ResolveString("ice_boss_fortress_knight01");
k_SnowGeneralAtt	= ResolveString("ice_boss_att_eliteultra");
k_SnowGeneralDef	= ResolveString("ice_boss_def_eliteultra");
k_SnowCovertMajor	= ResolveString("ice_pit_boss_camomajor");
k_SnowLuminaryAtt	= ResolveString("ice_boss_att_clearing_knight");
k_SnowLuminaryDef 	= ResolveString("ice_boss_def_clearing_knight");
k_SnowWamik	 		= ResolveString("ice_boss_stage_phantom_driver");
k_SnowCommandoAtt	= ResolveString("ice_boss_att_officer");
k_SnowCommandoDef	= ResolveString("ice_boss_def_officer");
k_SnowBannerman		= ResolveString("ice_boss_stage_knight_01");
k_SnowHunterAtt1	= ResolveString("ice_boss_hunter_att_01");
k_SnowHunterAtt2 	= ResolveString("ice_boss_hunter_att_02");
k_SnowHunterDef1 	= ResolveString("ice_boss_hunter_def_01");
k_SnowHunterDef2	= ResolveString("ice_boss_hunter_def_02");
k_SnowWraithOfficer	= ResolveString("ice_boss_stage_wraith_driver");
k_SnowWarden		= ResolveString("ice_pit_warden_01");


local WarzoneSnowBossNamesAndIds = 
{
	{ "lochagos", 			k_SnowLochagos },
	{ "snowGeneral", 		k_SnowGeneralAtt },
	{ "snowGeneral", 		k_SnowGeneralDef },
	{ "covertMajor",	 	k_SnowCovertMajor },
	{ "luminary", 			k_SnowLuminaryAtt },
	{ "luminary", 			k_SnowLuminaryDef },
	{ "wamik", 				k_SnowWamik },
	{ "commando", 			k_SnowCommandoAtt },
	{ "commando",		 	k_SnowCommandoDef },
	{ "bannerman", 			k_SnowBannerman },
	{ "serpentHunter", 		k_SnowHunterAtt1 },
	{ "serpentHunter",		k_SnowHunterAtt2 },
	{ "serpentHunter",	 	k_SnowHunterDef1 },
	{ "serpentHunter",		k_SnowHunterDef2 },
	{ "wraithOfficer",		k_SnowWraithOfficer },
	{ "warden", 			k_SnowWarden }
}


local WarzoneSnowBossNames = 
{
	k_SnowLochagos,
	k_SnowGeneralAtt,
	k_SnowGeneralDef,
	k_SnowCovertMajor,
	k_SnowLuminaryAtt,
	k_SnowLuminaryDef,
	k_SnowWamik,
	k_SnowCommandoAtt,
	k_SnowCommandoDef,
	k_SnowBannerman,
	k_SnowHunterAtt1,
	k_SnowHunterAtt2,
	k_SnowHunterDef1,
	k_SnowHunterDef2,
	k_SnowWraithOfficer,
	k_SnowWarden,
}


onDeathByBoss = onKill:Filter(
	function(context)
		context.TargetPlayer = context.DeadPlayer;
		if context.KillingObject == nil or
			context.KillingObject:IsBossUnit() == false then

			return false;	
		end

		return table.any(WarzoneSnowBossNames,
			function(resolvedBossString)
				local bossId = context.KillingObject:GetStringIdNetworkedProperty(ResolveString("BossName"));
				context.BossId = bossId;

				return bossId:IsValid() and bossId == resolvedBossString;
			end
			);
	end
	);

onDeathByBossSelect = onDeathByBoss:Select();


function BuildDeathByBossResponses(bossName, source)
	local globals = _G;

	globals[bossName .. "KilledYouResponse"] = source:Target(TargetPlayer):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = bossName .. "_killed_you"
	});
end

for index, allBosses in ipairs(WarzoneSnowBossNamesAndIds) do
	local bossNameIndex = 1;
	local bossIdIndex = 2;

	local bossName = allBosses[bossNameIndex];

	local sourceEvent = onDeathByBossSelect:Add(
		function(context)
			return context.BossId == allBosses[bossIdIndex];
		end
		);

	BuildDeathByBossResponses(bossName, sourceEvent);
end