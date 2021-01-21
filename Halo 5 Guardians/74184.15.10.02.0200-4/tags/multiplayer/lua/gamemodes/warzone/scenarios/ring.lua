--Ring Spawn Point Names
k_RingHunterFort01 = ResolveString("ring_boss_fortress_hunter_01");
k_RingHunterFort02 = ResolveString("ring_boss_fortress_hunter_02");

k_RingWraithCenter01 = ResolveString("ring_boss_center_wraith_01");
k_RingWraithCenter02 = ResolveString("ring_boss_center_wraith_02");

k_RingBansheeCenter01 = ResolveString("ring_boss_center_banshees_01");
k_RingBansheeCenter02 = ResolveString("ring_boss_center_banshees_02");
k_RingBansheeCenter03 = ResolveString("ring_boss_center_banshees_03");

k_RingBansheeOther01 = ResolveString("ring_boss_other_banshees_01");
k_RingBansheeOther02 = ResolveString("ring_boss_other_banshees_02");
k_RingBansheeOther03 = ResolveString("ring_boss_other_banshees_03");

k_RingGhostsBeach01 = ResolveString("ring_boss_beach_ghosts_01");
k_RingGhostsBeach02 = ResolveString("ring_boss_beach_ghosts_02");
k_RingGhostsBeach03 = ResolveString("ring_boss_beach_ghosts_03");

k_RingGhostsTunnel01 = ResolveString("ring_boss_tunnel_ghosts_01");
k_RingGhostsTunnel02 = ResolveString("ring_boss_tunnel_ghosts_02");

k_RingDefHunter01 = ResolveString("ring_boss_fortress_hunter_01");
k_RingDefHunter02 = ResolveString("ring_boss_fortress_hunter_02");

k_RingAttHunter01 = ResolveString("ring_boss_fortress_hunter_01");
k_RingAttHunter02 = ResolveString("ring_boss_fortress_hunter_02");

--
-- Ring-Specific Warzone Intro
--

__OnWarzoneIntro = Delegate:new();

onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);

warzoneUrbanIntroResponse = onWarzoneIntro:Target(TargetAllPlayers):Response(
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
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_initialassaultcovenantring',
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
-- Ring Base Captured Events
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

-- West Garage

onRedVehiclebaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('defender vehiclebase'));

onRedVehiclebaseCapturedCapturing = onRedVehiclebaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_vb_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_valleybasecapturedfriendly'
	});

onRedVehiclebaseCapturedFriendly = onRedVehiclebaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_vb_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_valleybasecapturedfriendly'
	});

onRedVehiclebaseCapturedHostile = onRedVehiclebaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_def_vb_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_valleybasecapturedhostile'
	});

-- East Garage

onBlueVehiclebaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('attacker vehiclebase'));

onBlueVehiclebaseCapturedCapturing = onBlueVehiclebaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_vb_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_cavebasecapturedfriendly'
	});

onBlueVehiclebaseCapturedFriendly = onBlueVehiclebaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_vb_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_cavebasecapturedfriendly'
	});

onBlueVehiclebaseCapturedHostile = onBlueVehiclebaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'iceworld_att_vb_captured_enemy_state',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_cavebasecapturedhostile'
	});

-- Arc West Armory

onArcDefArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_def_armory'));

onArcDefArmoryCapturedCapturing = onArcDefArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_westarmoryfirstcapture'
	});

onArcDefArmoryCapturedFriendly = onArcDefArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	});

onArcDefArmoryCapturedHostile = onArcDefArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedhostile'
	});

-- Arc East Armory

onArcAttArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_att_armory'));

onArcAttArmoryCapturedCapturing = onArcAttArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_easyarmoryfirstcapture'
	});

onArcAttArmoryCapturedFriendly = onArcAttArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	});

onArcAttArmoryCapturedHostile = onArcAttArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedhostile'
	});

-- Ring Spire

onRingSpireCaptured = onBaseCapturedSelect:Add(BaseIsNamed('ring_spire'));

onRingSpireCapturedCapturing = onRingSpireCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'ring_spire_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_spirecapturedfriendly'
	});

onRingSpireCapturedFriendly = onRingSpireCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'ring_spire_captured_friendly_fanfare', 
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_spirecapturedfriendly'
	});

onRingSpireCapturedHostile = onRingSpireCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'ring_spire_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_spirecapturedhostile'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase'
			},

			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedhomebase'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase'
			},

			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedhomebase'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackfortress'
			},

			successResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackdefendedfortress'
			},
		},
	},

}
	
--
-- Ring Boss Definitions
--

minibossDefinitions =
{
	--
	-- Spire Hunters Boss
	--
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_covenantspawngeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_fort_hunters_discovered_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_fort_hunters_discovered_teamfeed'
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_fort_hunters_discovered_enemyfeed'
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
	
	--
	-- Beach Wraith Boss
	--
	
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
			
			exploredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_phantomsincominggeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_wraith_discovered_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_wraith_discovered_teamfeed',
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithdiscoveredEnemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_wraith_discovered_enemyfeed'
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

	--
	-- Defender Cave Stealth Elites Boss
	--
	
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcavescovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_def_cave_stealth_discovered_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_def_cave_stealth_discovered_teamfeed'
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_def_cave_stealth_discovered_enemyfeed'
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

	--
	-- Attacker Cave Stealth Elites Boss
	--
	
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringpassagecovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_att_cave_stealth_explore_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_att_cave_stealth_discovered_teamfeed'
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringzealotdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_att_cave_stealth_discovered_enemyfeed'
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

	--
	-- Center Banshees Boss
	--
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
						FanfareText = 'ring_boss_waterfront_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwaterfrontcovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_center_banshees_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheewaterfrontspawned',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwaterfrontcovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_covenantspawngeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_center_banshees_discovered_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_center_banshees_discovered_teamfeed'
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_center_banshees_discovered_enemyfeed'
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

	--
	-- Banshees Other
	--
	
	{
		name = "ringOtherBanshees",

		label = 'ring_boss_other_banshees',

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
						FanfareText = 'ring_boss_ridge_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcoastlinecovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_other_banshees_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheeridgespawned',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcoastlinecovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_covenantspawngeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_other_banshees_discovered_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_other_banshees_discovered_teamfeed'
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_other_banshees_discovered_enemyfeed'
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

	}, -- end banshees other

	--
	-- Beach Ghosts
	--
	
	{
		name = "ringBeachGhosts",

		label = 'ring_boss_beach_ghosts',

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
						FanfareText = 'ring_boss_waterfront_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwaterfrontcovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_beach_ghosts_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostwaterfrontspawned',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwaterfrontcovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_phantomsincominggeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_ghosts_discovered_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_ghosts_discovered_teamfeed'
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_ghosts_discovered_enemyfeed'
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

	--
	-- Beach General
	--
	
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringplateaucovenantappeared'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_phantomsincominggeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneraldiscoveredplayer',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_general_discovered_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneraldiscoveredfriendly',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_general_discovered_teamfeed'
			},
	
			discoveredEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneraldiscoveredenemy',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'ring_boss_beach_general_discovered_enemyfeed'
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

	--
	-- Tunnel Ghosts
	--
	
	{
		name = "ringTunnelGhosts",

		label = 'ring_boss_tunnel_ghosts',

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
						FanfareText = 'ring_boss_ridge_covenant',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcoastlinecovenantappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_tunnel_ghosts_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostridgespawned',
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

	}, -- end tunnel ghosts

	--
	-- Warden
	--
	
	{
		name = "ringWarden",

		label = 'ring_boss_warden',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcrossroadsprometheansappeared',
					},
				},       
				[10] = 
				{
                    {
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_crossroads_prometheans',						
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric2',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_warden_spawned_message',		
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1discoveredplayer',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1discoveredplayer'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric2'
			},
	
			discoveredPlayerResponse =
			{
				Fanfare = FanfareDefinitions.KillFeed,
				--TODO Need VO
				FanfareText = 'ring_boss_warden_discovered_fanfare'
			},
			
			discoveredFriendlyProximityResponse =
			{
			},
	
			discoveredEnemyProximityResponse =
			{
				Fanfare = FanfareDefinitions.KillFeed,
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwardendiscoveredenemy',
				FanfareText = 'ring_boss_warden_discovered_enemyfeed'					
			},
			
			aliveWithinScoreRangeWinningTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwardenwinrangefriendly',
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwardenwinrangehostile',
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwardenwinrangefriendly',
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
					Medal = 'legendary_boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompleteplayer',
					FanfareText = function (context)
							return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_legendary_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_warden_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},

			completeAssistResponse =
			{
				{
					Medal = 'legendary_boss_takedown',
					Fanfare = FanfareDefinitions.QuestFeed,
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompletefriendly',
					FanfareText = function (context)
							return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},			
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_warden_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				},
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
					FanfareText = 'ring_boss_warden_kill_teamfeed'
				},
			},
	
			completeFriendlyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompletefriendly'				
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
					FanfareText = 'ring_boss_warden_killed_enemymessage'
				},
			},
	
			completeEnemyProximityResponse =
			{				
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompleteenemy'			
			},
				
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardenteammateskilled'
			},
	
		},

		killedTeammatesCount = 3,

	}, -- end warden
	
	--
	-- Crags General Boss
	--
	
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcragscovenantappeared'
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
	
	--
	-- Center VTOL Boss - Formerly Phantom
	--
	
	{
		name = "ringCenterPhantom",

		label = 'ring_boss_center_phantom',

		responses = 
		{
			countdownResponse = 
			{
				[30] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbeachprometheansappeared'
					},
				},       
				[10] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_beach_prometheans',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric2'	
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_center_phantom_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtoldiscoveredplayer'
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtolwinrangefriendly',
			},
			
			aliveWithinScoreRangeWinningTeamEnemyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtolwinrangehostile',
			},
			
			aliveWithinScoreRangeLosingTeamFriendlyResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtolwinrangefriendly',
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
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtolcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					ImpulseEvent = 'impulse_legendary_takedown',
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_center_phantom_kill_fanfare',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
	
			completeAssistResponse =
			{
				{
					Medal = 'legendary_boss_takedown',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtolcompleteplayer',
					Fanfare = FanfareDefinitions.QuestFeed,
					FanfareText = function (context)
						return FormatText('legendary_boss_kill_shelfmsg', context.VPEarned);
					end,
					TeamDesignator = TargetPlayerDesignatorProperty
				},
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_center_phantom_kill_fanfare',
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
					FanfareText = 'ring_boss_center_phantom_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},			
				
			completeFriendlyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtolcompletefriendly',					
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
					FanfareText = 'ring_boss_center_phantom_killed_enemymessage'
				}
			},

			completeEnemyProximityResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtolcompleteenemy',				
			},
	
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringvtolteammateskilled'
			},
	
		},

		killedTeammatesCount = 3,

	},
	
	--
	-- North Soldier Boss
	--
	
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
	
	--
	-- South Soldier Boss
	--
	
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
						FanfareText = 'ring_boss_chasm_prometheans',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringchasmprometheansappeared',
					},
				},     
				[0] = 
				{
					{
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'ring_boss_south_soldier_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierchasmspawned',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringchasmprometheansappeared'
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
	
	--
	-- Beach Knight Boss
	--
	
	{
		name = "ringBeachKnight",

		label = 'ring_boss_beach_knight',

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
						FanfareText = 'ring_boss_beach_knight_spawned_message',
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringknightspawned',
					},
				},
			},
	
			appearedResponse = 
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringcrossroadsprometheansappeared'
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
	
};


--
-- Death By RING Boss
--


k_RingHunterSpire1 	= ResolveString("ring_boss_fortress_hunter_01");
k_RingHunterSpire2	= ResolveString("ring_boss_fortress_hunter_02");
k_RingZealotPass	= ResolveString("ring_boss_att_cave_stealth_01");
k_RingZealotCaves	= ResolveString("ring_boss_def_cave_stealth_01");
k_RingElitePlat 	= ResolveString("ring_boss_beach_general_01");
k_RingEliteCrag 	= ResolveString("ring_boss_crags_general_01");
k_RingGhostRidge	= ResolveString("ring_boss_tunnel_ghosts_01");
k_RingGhostWater	= ResolveString("ring_boss_beach_ghosts_01");
k_RingTankBeach		= ResolveString("ring_boss_beach_wraith_01");
k_RingBansheeRidge	= ResolveString("ring_boss_other_banshees_01");
k_RingBansheeWater 	= ResolveString("ring_boss_center_banshees_01");
k_RingHestroBeach 	= ResolveString("ring_boss_center_phantom_01");
k_RingSoldierTunn	= ResolveString("ring_boss_north_soldier_01");
k_RingSoldierChasm	= ResolveString("ring_boss_south_soldier_01");
k_RingKnightCross	= ResolveString("ring_boss_beach_knight_01");
k_RingWarden		= ResolveString("ring_boss_warden_01");


local WarzoneRingBossNamesAndIds = 
{
	{ "elder", 				k_RingHunterSpire1 },
	{ "elder", 				k_RingHunterSpire2 },
	{ "assassin", 			k_RingZealotPass },
	{ "assassin",	 		k_RingZealotCaves },
	{ "ultra", 				k_RingElitePlat },
	{ "ultra", 				k_RingEliteCrag },
	{ "marauder", 			k_RingGhostRidge },
	{ "marauder", 			k_RingGhostWater },
	{ "rok",			 	k_RingTankBeach },
	{ "raider", 			k_RingBansheeRidge },
	{ "raider", 			k_RingBansheeWater },
	{ "hestro",				k_RingHestroBeach },
	{ "guard",	 			k_RingSoldierTunn },
	{ "guard",				k_RingSoldierChasm },
	{ "champion",			k_RingKnightCross },
	{ "warden", 			k_RingWarden }
}


local WarzoneRingBossNames = 
{
	k_RingHunterSpire1,
	k_RingHunterSpire2,
	k_RingZealotPass,
	k_RingZealotCaves,
	k_RingElitePlat,
	k_RingEliteCrag,
	k_RingGhostRidge,
	k_RingGhostWater,
	k_RingTankBeach,
	k_RingBansheeRidge,
	k_RingBansheeWater,
	k_RingHestroBeach,
	k_RingSoldierTunn,
	k_RingSoldierChasm,
	k_RingKnightCross,
	k_RingWarden
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