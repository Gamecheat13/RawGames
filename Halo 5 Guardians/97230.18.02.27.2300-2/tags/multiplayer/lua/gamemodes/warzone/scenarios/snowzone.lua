
__OnWarzoneIntro = Delegate:new();
onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);
warzoneArcIntroResponse = onWarzoneIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_welcometowarzone2', 
		Sound2 = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_warzonemodeinstruction2',
	});
__OnWarzoneBaseIntro = Delegate:new();
onWarzoneBaseIntro = root:AddCallback(
	__OnWarzoneBaseIntro
	);
warzoneBaseIntroResponse = onWarzoneBaseIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultprometheans3', 
		Sound2 = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultdescriptive',
	});
__OnWarzoneSpawned = Delegate:new();
onWarzoneSpawned = root:AddCallback(
	__OnWarzoneSpawned
	);
warzoneBaseIntroResponse = onWarzoneSpawned:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_supportmarinesgeneric',
	});
onBaseCapturedSelect = onBaseCaptured:Select();
onRedFieldbaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('defender midbase'));
onRedFieldbaseCapturedCapturing = onRedFieldbaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_def_mid_captured_player_feed',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onRedFieldbaseCapturedFriendly = onRedFieldbaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_def_mid_captured_team_message',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onRedFieldbaseCapturedHostile = onRedFieldbaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_def_mid_captured_enemy_state',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onBlueFieldbaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('attacker midbase'));
onBlueFieldbaseCapturedCapturing = onBlueFieldbaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_att_mid_captured_player_feed',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onBlueFieldbaseCapturedFriendly = onBlueFieldbaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_att_mid_captured_team_message',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onBlueFieldbaseCapturedHostile = onBlueFieldbaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_att_mid_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onFortressCaptured = onBaseCapturedSelect:Add(BaseIsNamed('shared midbase'));
onFortressCapturedCapturing = onFortressCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_fortress_captured_player_feed',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_fortress_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onFortressCapturedFriendly = onFortressCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_fortress_captured_team_message',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_fortress_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onFortressCapturedHostile = onFortressCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'iceworld_fortress_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_fortresscapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_fortress_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
defendResponses =
{
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
minibossDefinitions =
{
	{
		name = "ice_boss_att_clearing_knight",
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszfortressprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_fortress_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_knight_luminary_spawned_message',
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
					FanfareText = 'ice_boss_knight_att_kill_fanfare_01',
					ImpulseEvent = 'impulse_boss_takedown'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszknightcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydrateammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_soldier_scout",
		label = 'boss_fortress_soldier',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszfortressprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_fortress_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_promethean_scout_spawned_message',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_scout_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_scout_kill_fanfare'
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
					FanfareText = 'meridian_boss_soldier_scout_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompletefriendly',
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
					FanfareText = function (context)
						return FormatText('meridian_boss_soldier_scout_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldierscoutteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntershippingspawned',
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
	{
		name = "arc_boss_att_ranger",
		label = 'ice_boss_cave_ultra',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_elite_ranger_att_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_kill_fanfare'
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
					FanfareText = 'arc_boss_ranger_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompletefriendly',
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
					FanfareText = 'arc_boss_ranger_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "arc_boss_def_ranger",
		label = 'ice_boss_def_cave',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosssztransportcovenantappeared2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_shipping_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_elite_ranger_def_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_kill_fanfare'
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
					FanfareText = 'arc_boss_ranger_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompletefriendly',
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
					FanfareText = 'arc_boss_ranger_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_soldier_specialist",
		label = 'boss_clear_def_soldier',
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
						FanfareText = 'ice_boss_frozencave_promethean',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydraspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'meridian_boss_soldier_specialist_spawned_message',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_specialist_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_specialist_kill_fanfare'
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
					FanfareText = 'meridian_boss_soldier_specialist_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydracompletefriendly',
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
					FanfareText = 'meridian_boss_soldier_specialist_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydracompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydrateammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_soldier_specialist",
		label = 'boss_clear_att_soldier',
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
						FanfareText = 'ice_boss_frozencave_promethean',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydraspawned01',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'meridian_boss_soldier_specialist_spawned_message',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_specialist_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_specialist_kill_fanfare'
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
					FanfareText = 'meridian_boss_soldier_specialist_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydracompletefriendly',
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
					FanfareText = 'meridian_boss_soldier_specialist_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydracompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianhydrateammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
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
	{
		name = "ice_boss_def_eliteultra",
		label = 'boss_def_clear_elite',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcavecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_frozencave_covenant'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultradiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_elite_general_frozen_spawned_message'
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
	{
		name = "ice_boss_def_eliteultra",
		label = 'boss_att_clear_elite',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcaverncovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_icecavern_covenant'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszultradiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_elite_general_ice_spawned_message'
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
	{
		name = "boss_att_ghost",
		label = 'ice_boss_ghost',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianghostspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_ghost_pit_spawned_message'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_ghost_patrol_kill_fanfare'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_ghost_patrol_kill_fanfare'
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
					FanfareText = 'boss_ghost_patrol_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianghostcompletefriendly',
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
					FanfareText = 'boss_ghost_patrol_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianghostcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianghostteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "boss_general_soest",
		label = 'boss_leg_elite',
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
						Sound = 'multiplayer\audio\\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric5',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_covenantleggenericbossspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'boss_general_soest_spawned_message'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_general_soest_kill_fanfare'
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
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_general_soest_kill_fanfare'
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
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_general_soest_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{			
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenerictakedownfriendly',
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
					FanfareText = 'boss_general_soest_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenerictakedownhostile',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bosscovenantgenericteammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "temple_boss_banshee",
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheespawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_banshee_dock_spawned_message'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_banshee_kill_fanfare'
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
					FanfareText = 'temple_boss_banshee_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompletefriendly',
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
					FanfareText = 'temple_boss_banshee_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bosstemplebansheeteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ice_boss_fortress_knight01",
		label = 'boss_lochagos',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_prometheanleggenericbossspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'sz_lochogos_spawned_message'
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
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericteammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
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
			completePlayerResponse =
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'mythic_boss_takedown',
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
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'mythic_boss_takedown',
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
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
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
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
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
	{
		name = "boss_swarmlord_nak",
		label = 'ice_boss_pit_hunter',
		responses = 
		{
			countdownResponse = 
			{      
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszoutpostcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ice_boss_outpost_covenant',
					},
				},
				[10] = 
				{
                    {
						Sound = 'multiplayer\audio\\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric5',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_covenantleggenericbossspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'boss_swarmlord_nak_spawned_message',
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
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'mythic_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_swarmlord_nak_kill_fanfare',
					ImpulseEvent = 'impulse_mythic_takedown'
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
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Medal = 'mythic_boss_takedown',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_swarmlord_nak_kill_fanfare'
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
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_swarmlord_nak_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedownfriendly',
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('mythic_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_swarmlord_nak_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedownhostile',
			},
			killedTeammatesResponse =
			{
			},
		},
		killedTeammatesCount = 1,
	},
};
applyMinibossResponsesEmptyMetatable(minibossDefinitions);
k_SnowLochagos	 	= ResolveString("ice_boss_fortress_knight01");
k_SnowWarden		= ResolveString("ice_pit_warden_01");
k_SnowSoest			= ResolveString("boss_general_soest");
k_SnowSwarmlord		= ResolveString("boss_swarmlord_nak");
k_SnowGeneralAtt	= ResolveString("ice_boss_att_eliteultra");
k_SnowGeneralDef	= ResolveString("ice_boss_def_eliteultra");
k_SnowRangerAtt		= ResolveString("arc_boss_att_ranger");
k_SnowRangerDef		= ResolveString("arc_boss_def_ranger");
k_SnowGhost			= ResolveString("boss_att_ghost");
k_SnowLuminary		= ResolveString("ice_boss_att_clearing_knight");
k_SnowScout			= ResolveString("meridian_boss_soldier_scout");
k_SnowCommandoAtt	= ResolveString("ice_boss_att_officer");
k_SnowCommandoDef	= ResolveString("ice_boss_def_officer");
k_SnowSpecialistAtt	= ResolveString("meridian_boss_soldier_specialist");
k_SnowSpecialistDef	= ResolveString("meridian_boss_soldier_specialist");
k_SnowBannerman		= ResolveString("ice_boss_stage_knight_01");
k_SnowHunterAtt1	= ResolveString("ice_boss_hunter_att_01");
k_SnowHunterAtt2 	= ResolveString("ice_boss_hunter_att_02");
k_SnowHunterDef1 	= ResolveString("ice_boss_hunter_def_01");
k_SnowHunterDef2	= ResolveString("ice_boss_hunter_def_02");
k_SnowBanshee		= ResolveString("temple_boss_banshee");
local WarzoneSnowBossNamesAndIds = 
{
	{ "lochagos", 			k_SnowLochagos },
	{ "warden", 			k_SnowWarden },
	{ "soest", 				k_SnowSoest },
	{ "swarmnak", 			k_SnowSwarmlord	 },
	{ "snowGeneral", 		k_SnowGeneralAtt },
	{ "snowGeneral", 		k_SnowGeneralDef },
	{ "rangerCommander", 	k_SnowRangerAtt	 },
	{ "rangerCommander", 	k_SnowRangerDef },
	{ "patrolCaptain",	 	k_SnowGhost	 },
	{ "luminary", 			k_SnowLuminary },
	{ "prometheanScout", 	k_SnowScout },
	{ "commando", 			k_SnowCommandoAtt },
	{ "commando",		 	k_SnowCommandoDef },
	{ "soldierSpecialist", 	k_SnowSpecialistAtt },
	{ "soldierSpecialist",	k_SnowSpecialistDef },
	{ "bannerman", 			k_SnowBannerman },
	{ "serpentHunter", 		k_SnowHunterAtt1 },
	{ "serpentHunter",		k_SnowHunterAtt2 },
	{ "serpentHunter",	 	k_SnowHunterDef1 },
	{ "serpentHunter",		k_SnowHunterDef2 },
	{ "bansheeScout", 		k_SnowBanshee }
}
local WarzoneSnowBossNames = 
{
	k_SnowLochagos,
	k_SnowSoest,
	k_SnowSwarmlord,
	k_SnowWarden,
	k_SnowGeneralAtt,
	k_SnowGeneralDef,
	k_SnowRangerAtt,
	k_SnowRangerDef,
	k_SnowGhost,
	k_SnowLuminary,
	k_SnowScout,
	k_SnowCommandoAtt,
	k_SnowSpecialistAtt,
	k_SnowSpecialistDef,
	k_SnowCommandoDef,
	k_SnowBannerman,
	k_SnowHunterAtt1,
	k_SnowHunterAtt2,
	k_SnowHunterDef1,
	k_SnowHunterDef2,
	k_SnowBanshee
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