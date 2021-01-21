--
-- Arc-Specific Warzone Intro
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

warzoneBaseIntroSpawnedResponse = onWarzoneSpawned:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_supportmarinesgeneric',
	});

--
-- Arc Base Captured Events
--

onBaseCapturedSelect = onBaseCaptured:Select();

--
-- Garage
--

onArcGarageBaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_neutral_garage'));

--
-- Capture
--
	
onArcGarageBaseCapturedCapturing = onArcGarageBaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_garage_captured_player_feed', 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});

onArcGarageBaseCapturedFriendly = onArcGarageBaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare', 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});

onArcGarageBaseCapturedHostile = onArcGarageBaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_garage_captured_enemy_fanfare', 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});

--
-- West Armory
--

onArcDefArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_def_armory'));

--
-- Capture
--
	
onArcDefArmoryCapturedCapturing = onArcDefArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_eastarmory_captured_player_feed', 		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});

onArcDefArmoryCapturedFriendly = onArcDefArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,

		FanfareText = 'arc_def_armory_captured_friendly_fanfare',		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});

onArcDefArmoryCapturedHostile = onArcDefArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_def_armory_captured_enemy_fanfare',		
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});

--
-- East Armory
--

onArcAttArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_att_armory'));

--
-- Capture
--

onArcAttArmoryCapturedCapturing = onArcAttArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_shared_westarmory_captured_player_feed',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});

onArcAttArmoryCapturedFriendly = onArcAttArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});

onArcAttArmoryCapturedHostile = onArcAttArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.KillFeed,
		FanfareText = 'arc_att_armory_captured_enemy_fanfare',
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedhostile'
	}):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty
	});
	
--
-- Defend
--

defendResponses =
{	
}
	
--
-- Arc Boss Definitions
--

minibossDefinitions =
{	
	--
	-- Warden Boss - Crane Pit
	--
	
	{
		name = "wardenBoss",

		label = 'arc_boss_warden',

		responses = 
		{
			countdownResponse = 	
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarccraneprometheansappeared2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_cranepit_prometheans',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1discoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_warden_spawned_message',
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
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_warden_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeplayer',
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
					FanfareText = 'arc_boss_warden_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeplayer'
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
					FanfareText = 'arc_boss_warden_killed_teamfeed',
				}
			},
	
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completefriendly'
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
					FanfareText = 'arc_boss_warden_killed_enemymessage',
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeenemy'
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwardenteammateskilled'
			},
	
		},

		killedTeammatesCount = 3,

	},
	
	--
	-- Vtol Boss - Crane Pit
	--
	
	{
		name = "vtolBoss",

		label = 'arc_boss_vtol',

		responses = 
		{
			countdownResponse = 	
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarccraneprometheansappeared2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_cranepit_prometheans',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_vtol_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolexplored',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtoldiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_vtol_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_vtol_discovered_teamfeed', context.TargetPlayer);
				end,
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtoldiscoveredfriendly'
			},
	
			discoveredEnemyProximityResponse =
			{
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_vtol_discovered_enemyfeed',
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtoldiscoveredenemy'
			},
	
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolwinrangefriendly'
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolwinrangehostile'
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolwinrangefriendly'
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
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_vtol_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolcompleteplayer',
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
					FanfareText = 'arc_boss_vtol_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolcompleteplayer'
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
					FanfareText = 'arc_boss_vtol_killed_teamfeed',
				}
			},
	
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolcompletefriendly'
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
					FanfareText = 'arc_boss_vtol_killed_enemymessage',
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolcompleteenemy'
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcvtolteammateskilled'
			},
	
		},

		killedTeammatesCount = 3,

	},
	
	--
	-- Knight Commander Boss - Crane Pit
	--
	
	{
		name = "commanderBoss",

		label = 'arc_boss_kc',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarccraneprometheansappeared2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_cranepit_prometheans',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultraspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_strategos_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultraappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_prometheanwarpgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultradiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_kc_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultradiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_kc_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightultradiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_kc_discovered_enemyfeed',
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
	
	--
	-- Banshee Boss
	--
	
	{
		name = "bansheeBoss",

		label = 'arc_boss_banshee',

		responses = 
		{
			countdownResponse = 
			{     
				[30] = 
				{
                    {
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarccranecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_cranepit_covenant',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheespawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_banshee_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheeappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheeexplored',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheediscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_banshee_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheediscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_banshee_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheediscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_banshee_discovered_enemyfeed',
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheewinrangefriendly',
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheewinrangehostile',
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheewinrangefriendly',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_banshee_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheecompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_banshee_kill_fanfare'
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
					FanfareText = 'arc_boss_banshee_killed_teamfeed',
				}
			},
	
			completeFriendlyProximityResponse =
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheecompletefriendly',
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
					FanfareText = 'arc_boss_banshee_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheecompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcbansheeteammateskilled',
			},
	
		},

		killedTeammatesCount = 3,

	},
	
	--
	-- Soldier Boss - Attacker
	--
	
	{
		name = "attSoldierBoss",

		label = 'arc_boss_att_soldier',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcloadingbayprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_loadingbay_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_soldier_att_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcloadingbayprometheanappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_prometheanwarpgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_soldier_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_soldier_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_soldier_discovered_enemyfeed',
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
	
	--
	-- Soldier Boss - Defender
	--
	
	{
		name = "defSoldierBoss",

		label = 'arc_boss_def_soldier',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcalcoveprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_grotto_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_soldier_def_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcalcoveprometheanappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_prometheanwarpgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_soldier_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_soldier_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_soldier_discovered_enemyfeed',
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
					FanfareText = 'arc_boss_soldier_killed_enemymessage'
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
	
	--
	-- Defender Hunters - Dig Site
	--
	
	{
		name = "huntersDef",

		label = 'arc_boss_hunters_def',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_mineshaft_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_hunters_def_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsitecovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_covenantspawngeneric'
			},
	
			discoveredPlayerResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_hunters_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_hunters_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_hunters_discovered_enemyfeed'
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
	
	--
	-- Attacker Hunters -- Mineshaft
	--
	
	{
		name = "huntersAtt",

		label = 'arc_boss_hunters_att',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsitecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_digsite_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_hunters_att_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftcovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_covenantspawngeneric'
			},
	
			discoveredPlayerResponse =
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_hunters_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_hunters_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarchuntersattdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_hunters_discovered_enemyfeed'
				
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
	
	--
	-- MINESHAFT - Knight Battlewagon
	--
	
	{
		name = "arcKnightsDef",

		label = 'arc_boss_knight_def',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_mineshaft_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_knight_def_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftprometheanappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_prometheanwarpgeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_knight_bw_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_knight_bw_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_knight_bw_discovered_enemyfeed'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_kill_fanfare'
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
					FanfareText = 'arc_boss_knight_bw_killed_teamfeed'
				}
			},
	
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompletefriendly',
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
					FanfareText = 'arc_boss_knight_bw_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},

	--
	-- DIG SITE - Knight Battlewagon
	--
	
	{
		name = "arcKnightsAtt",

		label = 'arc_boss_knight_att',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsiteprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_digsite_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_knight_att_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsiteprometheanappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_prometheanwarpgeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_knight_bw_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_knight_bw_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_knight_bw_discovered_enemyfeed'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_kill_fanfare'
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
					FanfareText = 'arc_boss_knight_bw_killed_teamfeed'
				}
			},
	
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompletefriendly',
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
					FanfareText = 'arc_boss_knight_bw_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	}, 

	--
	-- Att Ranger Squad Leader - Dig Site
	--
	
	{
		name = "arcRangerAtt",

		label = 'arc_boss_ranger_att',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsitecovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_digsite_covenant',
						
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_ranger_att_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdigsitecovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_covenantspawngeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_ranger_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_ranger_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_ranger_discovered_enemyfeed'
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
	
	--
	-- Def Rangers Boss
	--
	
	{
		name = "arcRangerDef",

		label = 'arc_boss_ranger_def',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftcovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_mineshaft_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_ranger_def_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcmineshaftcovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_covenantspawngeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_ranger_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_ranger_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangersdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_ranger_discovered_enemyfeed'
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

	--
	-- Arc Att General Boss
	--
	
	{
		name = "arcAttGeneral",

		label = 'arc_boss_att_general',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcatttowercovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_commtower_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_general_att_spawned_message',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_phantomdropgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_att_general_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_att_general_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_att_general_discovered_enemyfeed'
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

	--
	-- Arc Def General Boss
	--
	
	{
		name = "arcDefGeneral",

		label = 'arc_boss_def_general',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdeftowercovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_relaytower_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_general_def_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcatttowercovenantappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_phantomdropgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_def_general_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_def_general_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneraldiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_def_general_discovered_enemyfeed'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_def_general_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcgeneralcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_def_general_kill_fanfare'
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
					FanfareText = 'arc_boss_def_general_killed_teamfeed'
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
					FanfareText = 'arc_boss_def_general_killed_enemymessage'
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
	
	--
	-- Arc Def Ghost Boss
	--
	
	{
		name = "arcDefGhost",

		label = 'arc_boss_def_ghost',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdeftowercovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_relaytower_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_ghost_att_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcdeftowercovenantappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_phantomdropgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_ghost_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_ghost_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_ghost_discovered_enemyfeed'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ghost_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ghost_kill_fanfare'
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
					FanfareText = 'arc_boss_ghost_killed_teammessage'
				}
			},
	
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostcompletefriendly',
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
					FanfareText = 'arc_boss_ghost_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostcompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},
	
	--
	-- Arc Att Ghost Boss
	--
	
	{
		name = "arcAttGhost",

		label = 'arc_boss_att_ghost',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcatttowercovenantappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_commtower_covenant',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_ghost_def_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcatttowercovenantappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_phantomdropgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_ghost_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_ghost_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_ghost_discovered_enemyfeed'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ghost_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ghost_kill_fanfare'
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
					FanfareText = 'arc_boss_ghost_killed_teammessage'
				}
			},
	
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostcompletefriendly',
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
					FanfareText = 'arc_boss_ghost_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostcompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcghostteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},
	
	--
	-- KNIGHT DIGNITARY - DEFENDER - GROTTO
	--
	
	{
		name = "arcDefKnight2",

		label = 'arc_boss_def_knight2',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcalcoveprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_grotto_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomdefspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_crates_knight_def_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcalcoveprometheanappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_prometheanwarpgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_knight2_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_knight2_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_knight2_discovered_enemyfeed'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight2_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					Fanfare = 'arc_boss_knight2_kill_fanfare'
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
					FanfareText = 'arc_boss_knight2_killed_teammessage'
				}
			},
	
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompletefriendly',
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
					FanfareText = 'arc_boss_knight2_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},
	
	--
	-- KNIGHT DIGNITARY - ATTACKER - LOADING BAY
	--
	
	{
		name = "arcAttKnight2",

		label = 'arc_boss_att_knight2',

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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcloadingbayprometheanappeared',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_loadingbay_prometheans',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomattspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_boss_crates_knight_att_spawned_message',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcloadingbayprometheanappeared',
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_prometheanwarpgeneric',
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_knight2_discovered_fanfare',
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = function (context)
					return FormatText('arc_boss_knight2_discovered_teamfeed', context.TargetPlayer);
				end
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_knight2_discovered_enemyfeed'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight2_kill_fanfare',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight2_kill_fanfare'
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
					FanfareText = 'arc_boss_knight2_killed_teammessage'
				}
			},
	
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompletefriendly',
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
					FanfareText = 'arc_boss_knight2_killed_enemymessage'
				}
			},
	
			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteenemy',
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomteammateskilled',
			},
	
		},

		killedTeammatesCount = 1,

	},
};



--
-- Death By ARC Boss
--


k_ArcBaronSroam 	= ResolveString("arc_boss_banshee");
k_ArcIntex 			= ResolveString("arc_boss_vtol");
k_ArcStrategos		= ResolveString("arc_boss_knight_commander");

k_ArcKnightDigAtt01 = ResolveString("att_knight_commander");
k_ArcKnightDigDef01 = ResolveString("def_knight_commander");
k_ArcHunterAtt01	= ResolveString("arc_boss_hunter_att_01");
k_ArcHunterAtt02	= ResolveString("arc_boss_hunter_att_02");
k_ArcHunterDef01	= ResolveString("arc_boss_hunter_def_01");
k_ArcHunterDef02	= ResolveString("arc_boss_hunter_def_02");

k_ArcRangerAtt 		= ResolveString("arc_boss_att_ranger");
k_ArcRangerDef 		= ResolveString("arc_boss_def_ranger");

k_ArcOfficerAtt		= ResolveString("att_soldier_officer");
k_ArcOfficerDef		= ResolveString("def_soldier_officer");

k_ArcGeneralAtt		= ResolveString("boss_att_general_01");
k_ArcGeneralDef		= ResolveString("boss_def_general_01");

k_ArcGhostAtt		= ResolveString("boss_att_ghost");
k_ArcGhostDef		= ResolveString("boss_def_ghost");

k_ArcKnightDefCave	= ResolveString("arc_boss_def_knight_01");
k_ArcKnightAttCave	= ResolveString("arc_boss_att_knight_01");

k_ArcWarden			= ResolveString("arc_boss_warden");

local WarzoneArcBossNamesAndIds = 
{
	{ "sroam", 				k_ArcBaronSroam },
	{ "intex", 				k_ArcIntex },
	{ "strategos", 			k_ArcStrategos },
	{ "remnantHunter", 		k_ArcHunterAtt01 },
	{ "remnantHunter", 		k_ArcHunterAtt02 },
	{ "remnantHunter", 		k_ArcHunterDef01 },
	{ "remnantHunter", 		k_ArcHunterDef02 },
	{ "rangerCommander", 	k_ArcRangerAtt },
	{ "rangerCommander", 	k_ArcRangerDef },
	{ "enforcer", 			k_ArcOfficerAtt },
	{ "enforcer", 			k_ArcOfficerDef },
	{ "general",			k_ArcGeneralAtt },
	{ "general", 			k_ArcGeneralDef },
	{ "ghostBoss",			k_ArcGhostAtt },
	{ "ghostBoss",			k_ArcGhostDef },
	{ "marshal", 			k_ArcKnightAttCave },
	{ "marshal", 			k_ArcKnightDefCave },
	{ "warden",				k_ArcWarden },
	{ "dignitary", 			k_ArcKnightDigAtt01 },
	{ "dignitary", 			k_ArcKnightDigDef01 }
}


local WarzoneArcBossNames = 
{
	k_ArcBaronSroam,
	k_ArcIntex,
	k_ArcStrategos,
	k_ArcHunterAtt01,
	k_ArcHunterAtt02,
	k_ArcHunterDef01,
	k_ArcHunterDef02,
	k_ArcRangerAtt,
	k_ArcRangerDef,
	k_ArcOfficerAtt,
	k_ArcOfficerDef,
	k_ArcGeneralAtt,
	k_ArcGeneralDef,
	k_ArcGhostAtt,
	k_ArcGhostDef,
	k_ArcKnightAttCave,
	k_ArcKnightDefCave,
	k_ArcWarden,
	k_ArcKnightDigAtt01,
	k_ArcKnightDigDef01
}


onDeathByBoss = onKill:Filter(
	function(context)
		context.TargetPlayer = context.DeadPlayer;
		if context.KillingObject == nil or
			context.KillingObject:IsBossUnit() == false then

			return false;	
		end

		return table.any(WarzoneArcBossNames,
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

for index, allBosses in ipairs(WarzoneArcBossNamesAndIds) do
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