
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
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultcovenantring', 
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
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_mid_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
onRingSpireCaptured = onBaseCapturedSelect:Add(BaseIsNamed('ring_spire'));
onRingSpireCapturedCapturing = onRingSpireCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'ring_spire_captured_player_feed',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_spirecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'ring_spire_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 	
	});
onRingSpireCapturedFriendly = onRingSpireCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'ring_spire_captured_teammate_feed',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_spirecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'ring_spire_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
	});
onRingSpireCapturedHostile = onRingSpireCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'ring_spire_captured_enemy_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_spirecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'ring_spire_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,	
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
		name = "ringHuntersFort",
		label = 'ring_boss_fortress_hunters',
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
						FanfareText = 'ring_boss_fort_hunters_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringhuntersspawned'					
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
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthunterscompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_fort_hunters_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			progressAssistResponse =
			{		
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthunterscompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_fort_hunters_kill_fanfare',
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
					FanfareText = 'ring_boss_fort_hunters_kill_teamfeed',
				},
			},
			progressFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersprogressfriendly',
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
					FanfareText = 'ring_boss_fort_hunters_killed_enemymessage'
				}
			},
			progressEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersprogressenemy',
			},
			completePlayerResponse =
			{	
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthunterscompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_fort_hunters_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{	
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthunterscompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_fort_hunters_kill_fanfare',
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
					FanfareText = 'ring_boss_fort_hunters_kill_teamfeed'
				},
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersprogressfriendly',					
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
					FanfareText = 'ring_boss_fort_hunters_killed_enemymessage'
				}
			},			
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersprogressenemy'				
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ring_boss_beach_knight_01",
		label = 'ring_boss_spire_knight',
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
						FanfareText = 'ring_boss_spire_prometheans',
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericincoming2',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_beach_knight_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightdiscoveredplayer',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_kill_fanfare',
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
					FanfareText = 'ring_boss_beach_knight_kill_teamfeed'
				}
			},		
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompletefriendly'					
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
					FanfareText = 'ring_boss_beach_knight_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "arc_boss_hunter_att_01",
		label = 'ring_boss_cross_hunter',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcrossroadscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_crossroads_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_hunters_crossroads_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare',
					ImpulseEvent = 'impulse_boss_takedown'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare'
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
					FanfareText = 'arc_boss_hunters_kill_teamfeed'
				}
			},
			progressFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressfriendly',
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
					FanfareText = 'arc_boss_hunters_killed_enemymessage'
				}
			},
			progressEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressenemy',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_hunters_kill_fanfare'
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
					FanfareText = 'arc_boss_hunters_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressfriendly',
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
					FanfareText = 'arc_boss_hunters_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattprogressenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ringWraithBeach",
		label = 'ring_boss_beach_wraith',
				responses = 
		{
			countdownResponse = 
			{
				[30] =
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbeachcovenantappeared',
					},
				},
				[10] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_beach_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_beach_wraith_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithspawned',
					},
				},
			},
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbeachcovenantappeared'
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
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_legendary_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_wraith_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_wraith_kill_fanfare',
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
					TeamDesignator = TargetPlayerDesignatorProperty,
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_wraith_kill_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithcompletefriendly',
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
					FanfareText = 'ring_boss_beach_wraith_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "ringDefCaveStealth",
		label = 'ring_boss_def_cave_stealth',
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
						FanfareText = 'ring_boss_caves_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_def_cave_stealth_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcavesspawned',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty,
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_def_cave_stealth_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_def_cave_stealth_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_def_cave_stealth_kill_teamfeed'
				},
				{
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned); 
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcompletefriendly',
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
					FanfareText = 'ring_boss_def_cave_stealth_killed_enemymessage'
				},
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ringAttCaveStealth",
		label = 'ring_boss_att_cave_stealth',
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
						FanfareText = 'ring_boss_passage_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringpassagecovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_att_cave_stealth_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotpassagespawned',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_att_cave_stealth_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_att_cave_stealth_kill_fanfare',
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
					FanfareText = 'ring_boss_def_cave_stealth_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcompletefriendly',
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
					FanfareText = 'ring_boss_att_cave_stealth_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotcompleteenemy',			
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "arcRangerAtt",
		label = 'ring_west_coast',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_covenantgenericbossspawned3',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_west_coast_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_west_coast_elite_spawned_message',
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
		name = "arcRangerDef",
		label = 'ring_east_coast',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_covenantgenericbossspawned3',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_east_coast_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_east_coast_elite_spawned_message',
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
		name = "att_soldier_officer",
		label = 'ring_boss_att_cave_soldier',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcavescovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_passage_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_soldierbossgenericspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_soldier_passage_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_kill_fanfare'
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
					FanfareText = 'arc_boss_soldier_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompletefriendly',
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
						return FormatText('arc_boss_soldier_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "def_soldier_officer",
		label = 'ring_boss_def_cave_soldier',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcavesprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_passage_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_soldierbossgenericspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_soldier_cave_spawned_message',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_kill_fanfare'
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
					FanfareText = 'arc_boss_soldier_killed_teammessage'
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompletefriendly',
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
						return FormatText('arc_boss_soldier_killed_enemymessage', context.VPEarned);
					end
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierteammateskilled',
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ringCenterBanshees",
		label = 'ring_boss_center_banshees',
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
						FanfareText = 'ring_boss_beach_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbeachcovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_banshee_beach_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredplayer',
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
					FanfareText = 'ring_boss_center_banshees_kill_fanfare',
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
					FanfareText = 'ring_boss_center_banshees_kill_fanfare',
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
					FanfareText = 'ring_boss_center_banshees_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheecompletefriendly',
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
					FanfareText = 'ring_boss_center_banshees_killed_enemymessage'
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
		name = "ringGeneral",
		label = 'ring_boss_beach_general',
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
						FanfareText = 'ring_boss_plateau_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringplateaucovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_beach_general_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralplateauspawned',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_general_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_general_kill_fanfare',
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
					FanfareText = 'ring_boss_beach_general_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompletefriendly',
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
					FanfareText = 'ring_boss_beach_general_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompleteenemy',				
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	}, -- end general
	{
		name = "ringCragsGeneral",
		label = 'ring_boss_crags_general',
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
						FanfareText = 'ring_boss_crags_covenant',	
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcragscovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_crags_general_spawned_message',	
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcragsspawned',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_crags_general_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_crags_general_kill_fanfare',
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
					FanfareText = 'ring_boss_crags_general_kill_teamfeed'
				}
			},		
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompletefriendly',				
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
					FanfareText = 'ring_boss_crags_general_killed_enemymessage'
				}
			},			
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompleteenemy',				
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ringBeachGhosts",
		label = 'ring_boss_plateau_ghost',
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
						FanfareText = 'ring_boss_plateau_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringplateaucovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_plateau_ghosts_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredplayer',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_ghosts_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_ghosts_kill_fanfare',
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
					FanfareText = 'ring_boss_beach_ghosts_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompletefriendly',
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
					FanfareText = 'ring_boss_beach_ghosts_killed_enemymessage'
				}
			},			
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	}, --end ghosts
	{
		name = "ringTunnelGhosts",
		label = 'ring_boss_crags_ghosts',
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
						FanfareText = 'ring_boss_crags_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcragscovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_crags_ghosts_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredplayer',
					},
				},
			},
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcoastlinecovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric'
			},
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_tunnel_ghosts_discovered_fanfare'
			},
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_tunnel_ghosts_discovered_teamfeed'
			},
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_tunnel_ghosts_discovered_enemyfeed'
			},
			completePlayerResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_tunnel_ghosts_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_tunnel_ghosts_kill_fanfare',
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
					FanfareText = 'ring_boss_tunnel_ghosts_kill_teamfeed'
				}
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompletefriendly',
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
					FanfareText = 'ring_boss_tunnel_ghosts_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompleteenemy',				
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ringNorthSoldier",
		label = 'ring_boss_north_soldier',
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
						FanfareText = 'ring_boss_tunnel_prometheans',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringtunnelprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_north_soldier_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiertunnelspawned',
					},
				},
			},
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringtunnelprometheansappeared'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_north_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_north_soldier_kill_fanfare',
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
					FanfareText = 'ring_boss_north_soldier_kill_teamfeed'
				}
			},			
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompletefriendly'					
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
					FanfareText = 'ring_boss_north_soldier_killed_enemymessage'
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteenemy'				
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "ringSouthSoldier",
		label = 'ring_boss_south_soldier',
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
						FanfareText = 'ring_boss_crossroads_prometheans',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcrossroadsprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_south_soldier_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierdiscoveredplayer',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_boss_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_south_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeAssistResponse =
			{
				{
					Medal = 'boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_south_soldier_kill_fanfare',
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
					FanfareText = 'ring_boss_south_soldier_kill_teamfeed'
				},
			},
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompletefriendly'					
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
					FanfareText = 'ring_boss_south_soldier_killed_enemymessage'
				},		
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteenemy'				
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierteammateskilled'
			},
		},
		killedTeammatesCount = 1,
	},
	{
		name = "meridian_boss_soldier_operative",
		label = 'ring_beach_pilot',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbeachprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_plateau_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridiansoldiercavespawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_soldier_operative_spawned_message',
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
		name = "ring_pve_boss_grunt_mech",
		label = 'ring_boss_cross_grunt',
		responses = 
		{
			countdownResponse = 
			{     
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcrossroadscovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_crossroads_covenant',
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
						FanfareText = 'boss_yimblap_spawned_message',
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
					FanfareText = 'boss_yimblap_kill_fanfare',
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_gruntmechbossgenerictakedown',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'boss_yimblap_kill_fanfare'
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
					FanfareText = 'boss_yimblap_kill_teamfeed',
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
					FanfareText = 'boss_yimblap_killed_enemymessage'
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
		name = "boss_commander_sever",
		label = 'ring_boss_cross_knight',
		responses = 
		{
			countdownResponse = 
			{     
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_bossprometheangenericincoming2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_crossroads_prometheans',
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
						FanfareText = 'boss_commander_sever_spawned_message',
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
					FanfareText = 'boss_commander_sever_kill_fanfare',
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
					FanfareText = 'boss_commander_sever_kill_fanfare'
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
					FanfareText = 'boss_commander_sever_kill_teamfeed',
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
					FanfareText = 'boss_commander_sever_killed_enemymessage'
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
		name = "arc_boss_kc_name",
		label = 'ring_chasm_knight',
		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringchasmprometheansappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_chasm_prometheans',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultradiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_knight_strategos_spawned_message',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultrawinrangefriendly'
			},
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultrawinrangehostile'
			},
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultrawinrangefriendly'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_kc_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultracompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_kc_kill_fanfare'
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
					FanfareText = 'arc_boss_kc_killed_teamfeed',
				}
			},
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultracompletefriendly',
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
					FanfareText = 'arc_boss_kc_killed_enemymessage',
				}
			},
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultracompleteenemy',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultrateammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
};
applyMinibossResponsesEmptyMetatable(minibossDefinitions);
k_RingHunterSpire1 	= ResolveString("ring_boss_fortress_hunter_01");
k_RingHunterSpire2	= ResolveString("ring_boss_fortress_hunter_02");
k_RingKnightSpire	= ResolveString("ring_boss_beach_knight_01");
k_RingZealotPass	= ResolveString("ring_boss_att_cave_stealth_01");
k_RingZealotCaves	= ResolveString("ring_boss_def_cave_stealth_01");
k_RingSoldierPass	= ResolveString("att_soldier_officer");
k_RingSoldierCaves	= ResolveString("def_soldier_officer");
k_RingWestCoast		= ResolveString("arc_boss_ranger_att_name");
k_RingEastCoast		= ResolveString("arc_boss_ranger_def_name");
k_RingElitePlat 	= ResolveString("ring_boss_beach_general_01");
k_RingEliteCrag 	= ResolveString("ring_boss_crags_general_01");
k_RingGhostPlateau	= ResolveString("ring_boss_tunnel_ghosts_01");
k_RingGhostCrags	= ResolveString("ring_boss_beach_ghosts_01");
k_RingSoldierPilot	= ResolveString("meridian_boss_soldier_operative");
k_RingBansheeBeach 	= ResolveString("ring_boss_center_banshees_01");
k_RingHunterCross1	= ResolveString("arc_boss_hunter_att_01");
k_RingHunterCross2	= ResolveString("arc_boss_hunter_att_02");
k_RingSoldierTunn	= ResolveString("ring_boss_north_soldier_01");
k_RingSoldierCross	= ResolveString("ring_boss_south_soldier_01");
k_RingStrategos		= ResolveString("arc_boss_kc_name");
k_RingWraithBeach	= ResolveString("ring_boss_beach_wraith_01");
k_RingGruntCross	= ResolveString("boss_yimblap");
k_RingKnightSever	= ResolveString("boss_commander_sever");
local WarzoneRingBossNamesAndIds = 
{
	{ "elder", 				k_RingHunterSpire1 },
	{ "elder", 				k_RingHunterSpire2 },
	{ "champion",			k_RingKnightSpire },
	{ "assassin", 			k_RingZealotPass },
	{ "assassin",	 		k_RingZealotCaves },
	{ "enforcer", 			k_RingSoldierPass },
	{ "enforcer",	 		k_RingSoldierCaves },
	{ "rangerCommander", 	k_RingWestCoast },
	{ "rangerCommander",	k_RingEastCoast },
	{ "ultra", 				k_RingElitePlat },
	{ "ultra", 				k_RingEliteCrag },
	{ "marauder", 			k_RingGhostPlateau },
	{ "marauder", 			k_RingGhostCrags },
	{ "soldierOperative",	k_RingSoldierPilot },
	{ "raider", 			k_RingBansheeBeach },
	{ "remnantHunter", 		k_RingHunterCross1 },
	{ "remnantHunter", 		k_RingHunterCross2 },
	{ "raider",				k_RingBansheeBeach },
	{ "guard",	 			k_RingSoldierTunn },
	{ "guard",				k_RingSoldierCross },
	{ "strategos", 			k_RingStrategos },
	{ "rok", 				k_RingWraithBeach },
	{ "yimblap", 			k_RingGruntCross },
	{ "sever", 				k_RingKnightSever }
}
local WarzoneRingBossNames = 
{
	k_RingHunterSpire1,
	k_RingHunterSpire2,
	k_RingKnightSpire,
	k_RingZealotPass,
	k_RingZealotCaves,
	k_RingSoldierPass,
	k_RingSoldierCaves,
	k_RingElitePlat,
	k_RingEliteCrag,
	k_RingGhostPlateau,
	k_RingGhostCrags,
	k_RingSoldierPilot,
	k_RingBansheeBeach,
	k_RingSoldierTunn,
	k_RingSoldierCross,
	k_RingWestCoast,
	k_RingEastCoast,
	k_RingHunterCross1,
	k_RingHunterCross2,
	k_RingStrategos,
	k_RingWraithBeach,
	k_RingGruntCross,
	k_RingKnightSever
}
onDeathByBoss = onKill:Filter(
	function(context)
		context.TargetPlayer = context.DeadPlayer;
		if context.KillingObject == nil or
			context.KillingObject:IsBossUnit() == false then
			return false;	
		end
		return table.any(WarzoneRingBossNames,
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
for index, allBosses in ipairs(WarzoneRingBossNamesAndIds) do
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