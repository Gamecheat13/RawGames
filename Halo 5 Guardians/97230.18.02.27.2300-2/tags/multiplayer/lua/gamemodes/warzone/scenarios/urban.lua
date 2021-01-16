
__OnWarzoneIntro = Delegate:new();
onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);
warzoneUrbanIntroResponse = onWarzoneIntro:Target(TargetAllPlayers):Response(
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
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultcovenant', 
		Sound2 = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultdescriptive',
	});
__OnWarzoneSpawned = Delegate:new();
onWarzoneSpawned = root:AddCallback(
	__OnWarzoneSpawned
	);
warzoneBaseIntroSpawnedResponse = onWarzoneSpawned:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_supportmarinesgeneric',
	});	
onBaseCapturedSelect = onBaseCaptured:Select();
onRedVehiclebaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('defender vehiclebase'));
onRedVehiclebaseCapturedCapturing = onRedVehiclebaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_def_vb_captured_player_feed',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbansouthgaragebasscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_def_vb_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onRedVehiclebaseCapturedFriendly = onRedVehiclebaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_def_vb_captured_team_message',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbansouthgaragebasscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_def_vb_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onRedVehiclebaseCapturedHostile = onRedVehiclebaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_def_vb_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbansouthgaragebasscapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_def_vb_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onBlueVehiclebaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('attacker vehiclebase'));
onBlueVehiclebaseCapturedCapturing = onBlueVehiclebaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_att_vb_captured_player_feed',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbannorthgaragebasscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_att_vb_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onBlueVehiclebaseCapturedFriendly = onBlueVehiclebaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_att_vb_captured_team_message',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbannorthgaragebasscapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_att_vb_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onBlueVehiclebaseCapturedHostile = onBlueVehiclebaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_att_vb_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_urbannorthgaragebasscapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_att_vb_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onMonumentCaptured = onBaseCapturedSelect:Add(BaseIsNamed('monument'));
onMonumentCapturedCapturing = onMonumentCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_monument_captured_player_feed',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_plazacapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_monument_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onMonumentCapturedFriendly = onMonumentCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_monument_captured_team_message',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_plazacapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_monument_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onMonumentCapturedHostile = onMonumentCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'urban_monument_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_plazacapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'urban_monument_captured_friendly_fanfare',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase'
			},
			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedhomebase'
			},
		},
	},
	{
		name = "defender_homebase",
		responses = 
		{
			beginResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase'
			},
			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedhomebase'
			},
		},
	},
	{
		name = "shared midbase",
		responses = 
		{
			beginResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackfortress'
			},
			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedfortress'
			},
		},
	},
}
minibossDefinitions =
{
	{
		name = "urbanHighwayGhosts",
		label = 'urban_boss_hw_ghosts',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwaycovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_ghosts_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostspawned',
					},
				},
			},
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwaycovenantappeared'
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
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_ghosts_kill_fanfare',
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
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_ghosts_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompleteplayer'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
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
					FanfareText = 'urban_boss_highway_ghosts_kill_teamfeed',
				},
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompletefriendly'
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
					FanfareText = 'urban_boss_highway_ghosts_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "urbanGreenbeltGhosts",
		label = 'urban_boss_gb_ghosts',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwaycovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_greenbelt_ghosts_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostspawned',
					},
				},
			},
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwaycovenantappeared'
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompleteplayer'
				},				
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_greenbelt_ghosts_kill_fanfare_01'
				},							
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompletplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_greenbelt_ghosts_kill_fanfare_01'
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
					FanfareText = 'urban_boss_greenbelt_ghosts_kill_teamfeed'
				},
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_greenbelt_ghosts_killed_enemymessage_01'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostteammateskilled'
			}	
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_forerunner_patrol",
		label = 'urban_boss_blue_oni_hog',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwayprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_soldier_bandit_att_spawned_message',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogspawned01',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare'
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
					FanfareText = 'meridian_boss_forerunner_patrol_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompletefriendly',
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
					FanfareText = 'meridian_boss_forerunner_patrol_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_forerunner_patrol",
		label = 'urban_boss_red_oni_hog',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwayprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_soldier_bandit_def_spawned_message',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogspawned01',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare'
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
					FanfareText = 'meridian_boss_forerunner_patrol_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompletefriendly',
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
					FanfareText = 'meridian_boss_forerunner_patrol_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_forerunner_patrol",
		label = 'urban_boss_red_rock_hog',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwayprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_soldier_bandit_def_spawned_message',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogspawned01',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare'
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
					FanfareText = 'meridian_boss_forerunner_patrol_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompletefriendly',
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
					FanfareText = 'meridian_boss_forerunner_patrol_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_forerunner_patrol",
		label = 'urban_boss_blue_rock_hog',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwayprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_soldier_bandit_att_spawned_message',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogspawned01',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_forerunner_patrol_kill_fanfare'
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
					FanfareText = 'meridian_boss_forerunner_patrol_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompletefriendly',
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
					FanfareText = 'meridian_boss_forerunner_patrol_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianwarthogteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_soldier_operative_att",
		label = 'urban_boss_blue_soldier',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_west_mall_promethean',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossurbanwestmallprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_soldier_operative_west_spawned_message',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavespawned',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_operative_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_operative_kill_fanfare'
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
					FanfareText = 'meridian_boss_soldier_operative_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavecompletefriendly',
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
						return FormatText('meridian_boss_soldier_operative_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercaveteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_soldier_operative_def",
		label = 'urban_boss_red_soldier',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_east_mall_promethean',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossurbaneastmallprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_soldier_operative_east_spawned_message',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavespawned',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_operative_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_boss_soldier_operative_kill_fanfare'
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
					FanfareText = 'meridian_boss_soldier_operative_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavecompletefriendly',
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
						return FormatText('meridian_boss_soldier_operative_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercaveteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "boss_lord_tyrik ",
		label = 'urban_boss_blue_mantis',
		responses = 
		{
			countdownResponse = 	
			{
				[30] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhighwayprometheansappeared',
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
						FanfareText = 'boss_lord_tyrik_spawned_message',
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
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossspawnedenemywinhim',
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
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_lord_tyrik_kill_fanfare',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_mantisbossgenerictakedown',
					ImpulseEvent = 'impulse_legendary_takedown'
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
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_lord_tyrik_kill_fanfare',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_mantisbossgenerictakedown'
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
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_lord_tyrik_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_mantisbossgenerictakedownfriendly'
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
					FanfareText = 'boss_lord_tyrik_killed_enemymessage',
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_mantisbossgenerictakedownhostile'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "boss_lord_venrex ",
		label = 'urban_boss_red_mantis',
		responses = 
		{
			countdownResponse = 	
			{
				[30] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_promethean',
					},
				},       
				[10] = 
				{
                    {
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'boss_lord_venrex_spawned_message',
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
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossspawnedenemywinhim',
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
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_lord_venrex_kill_fanfare',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_mantisbossgenerictakedown',
					ImpulseEvent = 'impulse_legendary_takedown'
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
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_lord_venrex_kill_fanfare',
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_mantisbossgenerictakedown'
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
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_lord_venrex_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_mantisbossgenerictakedownfriendly'
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
					FanfareText = 'boss_lord_venrex_killed_enemymessage',
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_mantisbossgenerictakedownhostile'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "boss_stimbab",
		label = 'urban_boss_mecha_grunt',
		responses = 
		{
			countdownResponse = 
			{     
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanmonumentcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_monument_covenant2',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenericspawnedplural',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'boss_stimbab_spawned_message',
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
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\wzcmndrsustain_warzonepve_bossspawnedenemywinhim',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_stimbab_kill_fanfare',
					ImpulseEvent = 'impulse_legendary_takedown'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_stimbab_kill_fanfare'
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
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_stimbab_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedownfriendly',
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
					FanfareText = 'boss_stimbab_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedownhostile',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bosscovenantgenericteammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "boss_knight_sublimis",
		label = 'urban_boss_mythic_knight',
		responses = 
		{
			countdownResponse = 
			{     
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericincoming2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_monument_promethean',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_prometheanleggenericbossspawned2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'boss_knight_sublimis_spawned_message ',
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
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\wzcmndrsustain_warzonepve_bossspawnedenemywinhim',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_knightbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_knight_sublimis_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_knightbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_knight_sublimis_kill_fanfare'
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
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_knight_sublimis_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_knightbossgenerictakedownfriendly',
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
					FanfareText = 'boss_knight_sublimis_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_knightbossgenerictakedownhostile',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericteammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "urbanHighwayVtol",
		label = 'urban_boss_vtol_highway',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbancrosswalkprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_vtol_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanphaetonspawned',
					},
				},
			},
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbancrosswalkprometheansappeared'
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_vtol_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}				
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_vtol_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
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
					FanfareText = 'urban_boss_highway_vtol_kill_teamfeed',
				},
			},
			completeFriendlyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_vtol_killed_enemymessage',
				}
			},			
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "urbanGreenbeltVtol",
		label = 'urban_boss_vtol_greenbelt',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_highway_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbancrosswalkprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_greenbelt_vtol_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanphaetonspawned',
					},
				},
			},
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbancrosswalkprometheansappeared'
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_greenbelt_vtol_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}			
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_greenbelt_vtol_kill_fanfare',
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
					FanfareText = 'urban_boss_greenbelt_vtol_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_greenbelt_vtol_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "urbanCorruptKnight",
		label = 'urban_boss_knight_corrupt_boss',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_plaza_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbancorruptprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_corrupt_knight_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossknightcorruptspawned',
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompleteplayer'	
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_knight_kill_fanfare_01',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}			
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_knight_kill_fanfare_01',
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
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_knight_kill_teamfeed'
				}
			},			
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompletefriendly'
			},
			completeEnemyResponse = 
			{
				{	
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_knight_killed_enemymessage_01'
				}
			},			
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "urbanOutskirtsKnight",
		label = 'urban_boss_knight_outskirts',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_commons_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansacredprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_outskirts_knight_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossknightsacredspawned',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_prometheanwarpgeneric'
			},
			completePlayerResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_outskirts_knight_kill_fanfare_01',			
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_outskirts_knight_kill_fanfare_01',			
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
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_outskirts_knight_kill_teamfeed'
				}
			},			
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_outskirts_knight_killed_enemymessage_01'
				}
			},			
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "urbanCorruptWraith",
		label = 'urban_boss_corrupt_wraith01',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_plaza_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbancorruptcovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_corrupt_wraith_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcorruptspawned',
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcompleteplayer'
				},	
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_wraith_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},			
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcompleteplayer'
				},	
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_wraith_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},		
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned); 
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_wraith_kill_teamfeed'
				},
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcompletefriendly'	
			},			
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},	
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_wraith_killed_enemymessage'
				},
			},		
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "urbanOutskirtsWraith",
		label = 'urban_boss_outskirt_wraith01',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_commons_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansacredcovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_outskirts_wraith_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithsacredspawned',
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_outskirts_wraith_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},			
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_outskirts_wraith_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
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
					FanfareText = 'urban_boss_outskirts_wraith_kill_teamfeed'
				},
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcompletefriendly'	
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_outskirts_wraith_killed_enemymessage'
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithcompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwraithteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	}, 
	{
		name = "ring_boss_other_banshees_01",
		label = 'urban_boss_phantom',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_monument_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanmonumentcovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_banshee_monument_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredplayer',
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
			completePlayerResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheecompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_other_banshees_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheecompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_other_banshees_kill_fanfare',
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
					FanfareText = 'ring_boss_other_banshees_kill_teamfeed'
				}
			},			
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheecompletefriendly'
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
					FanfareText = 'ring_boss_other_banshees_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheecompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheeteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "urbanBossDefElite",
		label = 'urban_boss_red_elite',
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
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_tunnel_elite_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanoverpasscovenantappeared',
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
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
					FanfareText = 'urban_boss_tunnel_elite_kill_teamfeed',
				},
			},
			completeFriendlyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_killed_enemymessage',
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbaneliteteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "urbanBossAttElite",
		label = 'urban_boss_blue_elite',
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
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_tunnel_elite_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanoverpasscovenantappeared',
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer'
				},	
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_teamfeed'
				},
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('urban_boss_tunnel_elite_killed_enemymessage', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_killed_enemymessage',
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbaneliteteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "urbanBossDefSoldier",
		label = 'urban_boss_redbridge_soldier',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_overpass_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanoverpassprometheanappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_soldier_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhydrasoldierspawned',
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldiercompleteplayer'
				},	
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldiercompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_soldier_kill_teamfeed',
				},
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldiercompletefriendly'
			},
			completeEnemyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_soldier_killed_enemymessage'
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldiercompleteenemy'
			},			
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldierteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "urbanBossAttSoldier",
		label = 'urban_boss_bluebridge_soldier',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_overpass_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanoverpassprometheanappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_soldier_spawned',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhydrasoldierspawned',
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
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldiercompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldiercompleteplayer'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_soldier_kill_teamfeed'
				},
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldiercompletefriendly'			
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
					FanfareText = 'urban_boss_soldier_killed_enemymessage',	
				}
			},
			completeEnemyProximityResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldiercompleteenemy'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbansoldierteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ice_boss_att_officer",
		label = 'boss_blue_tun_soldier',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_overpass_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanoverpassprometheanappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_soldier_commando_att_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldierdiscoveredplayer',
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
		name = "ice_boss_def_officer",
		label = 'boss_red_tun_soldier',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_overpass_promethean',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanoverpassprometheanappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_soldier_commando_def_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanhydrasoldierspawned',
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
		name = "boss_def_general_01",
		label = 'urban_redbridge_elite',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_overpass_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanoverpasscovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_elite_general_def_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldiscoveredplayer',
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
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_att_general_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_att_general_kill_fanfare',
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
					FanfareText = 'arc_boss_att_general_killed_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompletefriendly',
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
					FanfareText = 'arc_boss_att_general_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "boss_att_general_01",
		label = 'urban_bluebridge_elite',
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
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_boss_overpass_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanoverpasscovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_elite_general_att_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldiscoveredplayer',
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
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				},
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_att_general_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
				},
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_att_general_kill_fanfare',
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
					FanfareText = 'arc_boss_att_general_killed_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompletefriendly',
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
					FanfareText = 'arc_boss_att_general_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
};
applyMinibossResponsesEmptyMetatable(minibossDefinitions);
k_UrbElitePrimeBlue 	= ResolveString("blue_tunnel_elite_01");
k_UrbElitePrimeRed 		= ResolveString("red_tunnel_elite_01");
k_UrbSoldierCommandB	= ResolveString("ice_boss_att_officer");
k_UrbSoldierCommandR	= ResolveString("ice_boss_def_officer");
k_UrbHydraSoldierBlue	= ResolveString("blue_bridge_soldier_01");
k_UrbHydraSoldierRed 	= ResolveString("red_bridge_soldier_01");
k_UrbEliteGeneralBlue	= ResolveString("boss_att_general_01");
k_UrbEliteGeneralRed 	= ResolveString("boss_def_general_01");
k_UrbGhostJockBlue		= ResolveString("urban_boss_hw_ghosts_1");
k_UrbGhostJockRed		= ResolveString("urban_boss_gb_ghosts_1");
k_UrbSoldierBandit		= ResolveString("meridian_boss_forerunner_patrol");
k_UrbBansheeRaider		= ResolveString("ring_boss_other_banshees_01");
k_UrbKnightPlaza		= ResolveString("urban_boss_knight_corrupt_1");
k_UrbKnightComm			= ResolveString("urban_boss_knight_hallowed_1");
k_UrbElitePlaza			= ResolveString("meridian_boss_elite_spec_op_att");
k_UrbEliteComm			= ResolveString("meridian_boss_elite_spec_op_def");
k_UrbReconPlaza			= ResolveString("urban_boss_vtol_greenbelt_1");
k_UrbReconComm			= ResolveString("urban_boss_vtol_highway_1")
k_UrbPlatoonPlaza		= ResolveString("urban_boss_corrupt_wraith_1");
k_UrbPlatoonComm		= ResolveString("urban_outskirts_boss_wraith_1");
k_UrbSoldierOpWest		= ResolveString("meridian_boss_soldier_operative_att");
k_UrbSoldierOpEast		= ResolveString("meridian_boss_soldier_operative_def");
k_UrbLordTyrik			= ResolveString("boss_lord_tyrik");
k_UrbLordVenrex			= ResolveString("boss_lord_venrex");
k_UrbStimbab			= ResolveString("boss_stimbab");
k_UrbKnightSub			= ResolveString("boss_knight_sublimis");
local WarzoneUrbanBossNamesAndIds = 
{
	{ "prime", 				k_UrbElitePrimeBlue },
	{ "prime", 				k_UrbElitePrimeRed },
	{ "commando", 			k_UrbSoldierCommandB },
	{ "commando", 			k_UrbSoldierCommandR },
	{ "hydraSoldier", 		k_UrbHydraSoldierBlue },
	{ "hydraSoldier", 		k_UrbHydraSoldierRed },
	{ "general",		 	k_UrbEliteGeneralBlue },
	{ "general", 			k_UrbEliteGeneralRed },
	{ "jockey",		 		k_UrbGhostJockBlue },
	{ "jockey", 			k_UrbGhostJockRed },
	{ "soldierBandit", 		k_UrbSoldierBandit },
	{ "raider",	 			k_UrbBansheeRaider },
	{ "noble",				k_UrbKnightPlaza },
	{ "noble", 				k_UrbKnightComm },
	{ "eliteSpec",			k_UrbElitePlaza },
	{ "eliteSpec", 			k_UrbEliteComm },
	{ "recon",				k_UrbReconPlaza },
	{ "recon",				k_UrbReconComm },
	{ "soldierOperative",	k_UrbSoldierOpWest },
	{ "soldierOperative",	k_UrbSoldierOpEast },
	{ "platoonCapn", 		k_UrbPlatoonPlaza },
	{ "platoonCapn", 		k_UrbPlatoonComm },
	{ "tyrik", 				k_UrbLordTyrik },
	{ "venrex", 			k_UrbLordVenrex },
	{ "stimbab",			k_UrbStimbab },
	{ "knightSub", 			k_UrbKnightSub }
}
local WarzoneUrbanBossNames = 
{
	k_UrbElitePrimeBlue,
	k_UrbElitePrimeRed, 		
	k_UrbHydraSoldierBlue,
	k_UrbHydraSoldierRed, 
	k_UrbGhostJockBlue,	
	k_UrbGhostJockRed,	
	k_UrbKnightPlaza,	
	k_UrbKnightComm,	
	k_UrbReconPlaza,	
	k_UrbReconComm,		
	k_UrbPlatoonPlaza,	
	k_UrbPlatoonComm,
	k_UrbSoldierCommandB,
	k_UrbSoldierCommandR,
	k_UrbEliteGeneralBlue,
	k_UrbEliteGeneralRed,
	k_UrbSoldierBandit,
	k_UrbElitePlaza,
	k_UrbEliteComm,
	k_UrbSoldierOpWest,
	k_UrbSoldierOpEast,
	k_UrbLordTyrik,
	k_UrbLordVenrex,
	k_UrbStimbab,
	k_UrbKnightSub,
	k_UrbBansheeRaider
}
onDeathByBoss = onKill:Filter(
	function(context)
		context.TargetPlayer = context.DeadPlayer;
		if context.KillingObject == nil or
			context.KillingObject:IsBossUnit() == false then
			return false;	
		end
		return table.any(WarzoneUrbanBossNames,
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
for index, allBosses in ipairs(WarzoneUrbanBossNamesAndIds) do
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