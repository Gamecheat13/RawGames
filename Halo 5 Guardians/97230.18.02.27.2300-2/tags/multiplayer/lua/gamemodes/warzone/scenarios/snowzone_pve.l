
__OnWarzoneIntro = Delegate:new();
onWarzoneIntro = root:AddCallback(
	__OnWarzoneIntro
	);
__OnWarzoneBaseIntro = Delegate:new();
onWarzoneBaseIntro = root:AddCallback(
	__OnWarzoneBaseIntro
	);
warzoneBaseIntroResponse = onWarzoneBaseIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightintro2', 
		Sound2 = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionintro2',
	}):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionintro3',
	});
onBaseCapturedSelect = onBaseCaptured:Select();
onArcGarageBaseCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_neutral_garage'));
onArcGarageBaseCapturedCapturing = onArcGarageBaseCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_garagefirstcapture'
	});
onArcGarageBaseCapturedFriendly = onArcGarageBaseCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedfriendly'
	});
onArcGarageBaseCapturedHostile = onArcGarageBaseCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_garage_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_arcgaragecapturedhostile'
	});
onArcDefArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_def_armory'));
onArcDefArmoryCapturedCapturing = onArcDefArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_easyarmoryfirstcapture'
	});
onArcDefArmoryCapturedFriendly = onArcDefArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedfriendly'
	});
onArcDefArmoryCapturedHostile = onArcDefArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_def_armory_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_icebasecapturedhostile'
	});
onArcAttArmoryCaptured = onBaseCapturedSelect:Add(BaseIsNamed('arc_att_armory'));
onArcAttArmoryCapturedCapturing = onArcAttArmoryCaptured:Target(CapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_westarmoryfirstcapture'
	});
onArcAttArmoryCapturedFriendly = onArcAttArmoryCaptured:Target(FriendlyToCapturingPlayers):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_friendly_fanfare',
		TeamDesignator = DesignatorProperty, 
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedfriendly'
	});
onArcAttArmoryCapturedHostile = onArcAttArmoryCaptured:Target(PlayersWithoutDesignator):Response(
	{
		Fanfare = FanfareDefinitions.QuestFeed,
		FanfareText = 'arc_att_armory_captured_enemy_fanfare',
		TeamDesignator = DesignatorProperty,
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_forestbasecapturedhostile'
	});
defendResponses =
{	
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
}
minibossDefinitions =
{	
{					
	name = "elitespecialists",				
	label = 'r1_elite_specialists_boss',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWraithDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r1elitespecialists_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
				return FormatText('boss_kill_shelfmsg', GetScoreVal(100));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(100), 
			}, 	
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1elitespecialists_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_BossTempleEliteSpecialistCompletePlayer',
				ImpulseEvent = 'boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1elitespecialists_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1elitespecialists_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_BossTempleEliteSpecialCompleteFriendly',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcGhostTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},	
{					
	name = "soldier_commandos",				
	label = 'pve_r1_soldier_pair_boss',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r1soldierboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
				return FormatText('boss_kill_shelfmsg', GetScoreVal(100));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(100), 
			}, 	
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1soldierboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedown',
				ImpulseEvent = 'boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1soldierboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1soldierboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedownFriendly',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},					
{					
	name = "soldier_operatives",				
	label = 'r1_soldier_hog_boss',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_bossmeridianecaveprometheanappeared',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r1soldierwarthogboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
				return FormatText('boss_kill_shelfmsg', GetScoreVal(100));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(100), 
			}, 		
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1soldierwarthogboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedown',
				ImpulseEvent = 'boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1soldierwarthogboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r1soldierwarthogboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedownFriendly',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},	
{					
	name = "ghost_pathfinder1",				
	label = 'r2_ghost_boss_01',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingGhostDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r2ghostboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('boss_kill_shelfmsg', GetScoreVal(250));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(250), 
			}, 	
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2ghostboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedown',
				ImpulseEvent = 'boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2ghostboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2ghostboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedownFriendly',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericDiscoveredFriendly',		
		},			
	},				
	killedTeammatesCount = 3,				
},	
{					
	name = "ghost_pathfinder2",				
	label = 'r2_ghost_boss_02',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
			},     		
			[0] = 		
			{		
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('boss_kill_shelfmsg', GetScoreVal(250));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(250), 
			}, 	
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2ghostboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedown',
				ImpulseEvent = 'boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2ghostboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2ghostboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedownFriendly',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericDiscoveredFriendly',		
		},			
	},				
	killedTeammatesCount = 3,				
},	
{					
	name = "soldier_enforcer",				
	label = 'r2_soldier_boss_01',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r2soldierboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('boss_kill_shelfmsg', GetScoreVal(200));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(200), 
			}, 		
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2soldierboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedown',
				ImpulseEvent = 'boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2soldierboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2soldierboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedown',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcSoldierDiscoveredFriendly',		
		},			
	},				
	killedTeammatesCount = 3,				
},				
{					
	name = "recon_pilot",				
	label = 'r2_vtol_boss',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanVtolDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r2vtolboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('boss_kill_shelfmsg', GetScoreVal(500));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(500), 
			}, 	
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2vtolboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedown',
				ImpulseEvent = 'boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2vtolboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r2vtolboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedown',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanVtolTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},	
{					
	name = "knight_boss",				
	label = 'r3_knight_boss',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r3knightboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(500));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(500), 
			}, 		
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3knightboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3knightboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3knightboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_KnightBossGenericTakedownFriendly',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZBattlewagonTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},		
{					
	name = "wraith_Boss 1",				
	label = 'r3_wraith_boss1',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_BossTempleWraithSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r3wraithboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(250));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(500), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3wraithboss_ptakedown_w',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericTakedown',
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3wraithboss_ttakedown_w',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3wraithboss_ttakedown_w',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericTakedownFriendly',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},		
{					
	name = "wraith_Boss 2",				
	label = 'r3_wraith_boss2',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
			},     		
			[0] = 		
			{		
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('boss_kill_shelfmsg', GetScoreVal(250));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(250), 
			}, 	
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3wraithboss_ptakedown_g',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedown',
				ImpulseEvent = 'boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3wraithboss_ttakedown_g',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3wraithboss_ttakedown_g',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedownFriendly',
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
		},			
	},				
	killedTeammatesCount = 3,				
},		
{					
	name = "hunter_boss1",				
	label = 'r3_hunter_boss_01',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r3hunterboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(250));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(250), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_BossCovenantGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},		
{					
	name = "hunter_boss2",				
	label = 'r3_hunter_boss_02',				
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
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(250));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(250), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_BossCovenantGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},		
{					
	name = "hunter_boss3",				
	label = 'r3_hunter_boss_03',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
			},     		
			[0] = 		
			{		
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(250));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(250), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r3hunterboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_BossCovenantGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},		
{					
	name = "banshee_boss",				
	label = 'r4_banshee_boss_all',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BansheeBossGenericSpawnedPlural',	
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r4bansheeboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(500));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(500), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4bansheeboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BansheeBossGenericTakedown',	
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4bansheeboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4bansheeboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BansheeBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericDiscoveredFriendly',		
		},			
	},				
	killedTeammatesCount = 3,				
},		
{					
	name = "Vtol_boss_1",							
	label = 'r4_vtol_boss_all',							
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZFortressPrometheanAppeared',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericSpawnedPlural',     					
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r4vtolboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(300));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(300), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4vtolboss_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedown',     					
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4vtolboss_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4vtolboss_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedownFriendly',
				Fanfare = FanfareDefinitions.KillFeed,
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death',
				Fanfare = FanfareDefinitions.KillFeed,
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericDiscoveredFriendly',		
		},			
	},							
	killedTeammatesCount = 3,							
},	
{					
	name = "Lknight_boss1",							
	label = 'r4_l_knight_boss_01',							
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZFortressPrometheanAppeared',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',	
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r4lknightboss_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(500));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(500), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4lknightboss_ptakedown1',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',     					
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4lknightboss_ttakedown1',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4lknightboss_ttakedown1',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',     					
				Fanfare = FanfareDefinitions.KillFeed,
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericDiscoveredFriendly',		
			Fanfare = FanfareDefinitions.KillFeed,
		},			
	},				
	killedTeammatesCount = 3,				
},		
{					
	name = "grunt_mech1",				
	label = 'r4_g_mech_boss_all',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericSpawnedPlural',     					
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r4grunt_mech_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(1000));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(1000), 
			}, 		
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4grunt_mech_1_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericTakedown',     					
				ImpulseEvent = 'legendary_boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4grunt_mech_1_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r4grunt_mech_1_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericTakedown',     					
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericDiscoveredFriendly',		
		},			
	},				
	killedTeammatesCount = 3,				
},	
{					
	name = "cov_boss_w1_1",				
	label = 'r5_cov_boss_w1_all',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_IncursionEliminateCov',     					
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericSpawnedPlural',     					
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r5covboss1_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(200));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(200), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5covboss1_ptakedown',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanEliteCompletePlayer',	
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5covboss1_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5covboss1_ttakedown',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanEliteCompleteFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanEliteTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},	
{					
	name = "cov_boss_w2_1",				
	label = 'r5_cov_boss_w2_all',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric',
				},	
				{	
					Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_hunterspawn',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r5covboss2_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('mythic_boss_kill_shelfmsg', GetScoreVal(200));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(200), 
			}, 	
			{		
				Medal = 'mythic_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5covboss2_ptakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
				ImpulseEvent = 'impulse_mythic_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5covboss2_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5covboss2_ttakedown',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BossCovenantGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},	
{					
	name = "for_boss_w1_1",				
	label = 'r5_fore_boss_w1_all',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',	
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r5forboss1_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(1000));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(1000), 
			}, 
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss1_ptakedown1',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',     					
				ImpulseEvent = 'legendary_boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss1_ttakedown1',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss1_ttakedown1',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BossPrometheanGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},
{					
	name = "for_boss_w2",				
	label = 'r5_fore_boss_w2_12',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
				},	
				{	
					Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_wardenspawn',
				},
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden2DiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'sz_pve_r5forboss2_location',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(2000));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(2000), 
			}, 	
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss2_ptakedown',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompletePlayer',	
				ImpulseEvent = 'impulse_legendary_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss2_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss2_ttakedown',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1CompleteFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWardenTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},	
{					
	name = "for_boss_w2_2",				
	label = 'r5_fore_boss_w2_03',				
	responses = 				
	{				
		countdownResponse = 			
		{			
			[30] = 		
			{		
			},       		
			[10] = 		
			{	
			},     		
			[0] = 		
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_hunterspawn'
			},	
		},			
		completePlayerResponse =			
		{			
			{  
				Fanfare = FanfareDefinitions.QuestFeed, 
				FanfareText = function (context) 
				return FormatText('mythic_boss_kill_shelfmsg', GetScoreVal(4000));
				end, 
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(4000), 
			}, 	
			{		
				Medal = 'mythic_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss2_2_ptakedown',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1CompletePlayer',	
				ImpulseEvent = 'impulse_mythic_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss2_2_ttakedown',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'sz_pve_r5forboss2_2_ttakedown',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1CompleteFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWardenTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},
};
applyDefaultMinibossResponses(minibossDefinitions);
k_SnowCommandoAtt	= ResolveString("ice_boss_att_officer");
k_SnowCommandoDef	= ResolveString("ice_boss_def_officer");
k_ArcOfficerAtt		= ResolveString("att_soldier_officer");
k_ArcOfficerDef		= ResolveString("def_soldier_officer");
k_UrbReconPlaza			= ResolveString("urban_boss_vtol_greenbelt_1");
k_SnowHunterAtt1	= ResolveString("sz_pve_r3_hunter_boss_01");
k_SnowHunterAtt2 	= ResolveString("sz_pve_r3_hunter_boss_02");
k_SnowHunterAtt3	= ResolveString("sz_pve_r3_hunter_boss_03");
k_SnowHunterAtt4 	= ResolveString("sz_pve_r3_hunter_boss_04");
k_SnowHunterAtt5	= ResolveString("sz_pve_r3_hunter_boss_05");
k_SnowHunterAtt6 	= ResolveString("sz_pve_r3_hunter_boss_06");
k_SnowBannerman		= ResolveString("ice_boss_stage_knight_01");
k_SnowBannerman2		= ResolveString("ice_boss_stage_knight_02");
k_SnowBannerman3		= ResolveString("ice_boss_stage_knight_03");
k_UrbElitePrimeBlue 	= ResolveString("urban_boss_blue_elite_name");
k_UrbElitePrimeRed 		= ResolveString("urban_boss_red_elite_name");
k_UrbElitePrimeRed3 		= ResolveString("red_tunnel_elite_01");
k_RingBansheeRidge	= ResolveString("urban_pve_boss_banshee01");
k_RingBansheeWater 	= ResolveString("urban_pve_boss_banshee02");
k_RingBansheeRidge2	= ResolveString("urban_pve_boss_banshee03");
k_RingBansheeWater2 	= ResolveString("urban_pve_boss_banshee04");
k_ArcKnightAttCave	= ResolveString("sz_pve_r4_knight_boss_01");
k_ArcKnightAttCave2	= ResolveString("sz_pve_r4_knight_boss_02");
k_ArcKnightAttCave3	= ResolveString("sz_pve_r4_knight_boss_03");
k_SnowPvEKnightChamp	= ResolveString("sz_pve_r5_knight_boss_01");
k_SnowPvEKnightChamp2 	= ResolveString("sz_pve_r5_knight_boss_02");
k_ArcWarden			= ResolveString("arc_boss_warden_name");
k_ArcWarden2			= ResolveString("meridian_pve_boss_warden");
k_ArcWarden3			= ResolveString("urban_pve_boss_warden01");
k_SnowSpecialElite	= ResolveString("temple_boss_elite_specialist_att");
k_SnowSpecialElite2	= ResolveString("temple_boss_elite_specialist_def");
k_SnowSolOpp	= ResolveString("meridian_boss_soldier_operative_att");
k_SnowElitePath	= ResolveString("temple_pve_boss_skir_01");
k_SnowElitePath2	= ResolveString("temple_pve_boss_skir_02");
k_SnowElitePath3	= ResolveString("temple_pve_boss_skir_03");
k_SnowElitePath4	= ResolveString("temple_pve_boss_skir_04");
k_SnowReconLeader	= ResolveString("temple_boss_elite_recon_att");
k_SnowReconLeader2	= ResolveString("temple_boss_elite_recon_def");
k_SnowWraithOff 		= ResolveString("ice_boss_stage_wraith_driver");
k_SnowPhaetonGun	= ResolveString("sz_pve_r4_vtol_boss_01");
k_SnowPhaetonGun2	= ResolveString("sz_pve_r4_vtol_boss_02");
k_SnowPhaetonGun3	= ResolveString("sz_pve_r4_vtol_boss_03");
k_SnowGoblin1	= ResolveString("sz_pve_r4_grunt_mech1");
k_SnowGoblin2	= ResolveString("sz_pve_r4_grunt_mech2");
k_SnowSwarmlord1	= ResolveString("sz_pve_r5_hunter_boss_01");
k_SnowSwarmlord2	= ResolveString("sz_pve_r5_hunter_boss_02");
k_SnowSwarmlord3	= ResolveString("sz_pve_r5_hunter_boss_03");
k_SnowSwarmlord4	= ResolveString("sz_pve_r5_hunter_boss_04");
local WarzoneArcBossNamesAndIds = 
{
	{ "commando", 			k_SnowCommandoAtt },
	{ "commando",		 	k_SnowCommandoDef },	
	{ "enforcer", 			k_ArcOfficerAtt },
	{ "enforcer", 			k_ArcOfficerDef },
	{ "recon",				k_UrbReconPlaza },
	{ "serpentHunter", 		k_SnowHunterAtt1 },
	{ "serpentHunter",		k_SnowHunterAtt2 },
	{ "serpentHunter", 		k_SnowHunterAtt3 },
	{ "serpentHunter",		k_SnowHunterAtt4 },
	{ "serpentHunter", 		k_SnowHunterAtt5 },
	{ "serpentHunter",		k_SnowHunterAtt6 },
	{ "bannerman", 			k_SnowBannerman },
	{ "bannerman", 			k_SnowBannerman2 },
	{ "bannerman", 			k_SnowBannerman3 },
	{ "prime", 				k_UrbElitePrimeBlue },
	{ "prime", 				k_UrbElitePrimeRed },
	{ "prime", 				k_UrbElitePrimeRed3 },
	{ "raider", 			k_RingBansheeRidge },
	{ "raider", 			k_RingBansheeWater },
	{ "raider", 			k_RingBansheeRidge2 },
	{ "raider", 			k_RingBansheeWater2 },
	{ "marshal", 			k_ArcKnightAttCave },
	{ "marshal", 			k_ArcKnightAttCave2 },
	{ "marshal", 			k_ArcKnightAttCave3 },
	{ "knightChamp", 			k_SnowPvEKnightChamp },
	{ "knightChamp", 			k_SnowPvEKnightChamp2 },
	{ "warden",				k_ArcWarden },
	{ "warden",				k_ArcWarden2 },
	{ "warden",				k_ArcWarden3 },
	{ "specialist", 			k_SnowSpecialElite },
	{ "specialist", 			k_SnowSpecialElite2 },
	{ "soldierOperative",			 	k_SnowSolOpp },
	{ "path", 			k_SnowElitePath },
	{ "path", 			k_SnowElitePath2 },
	{ "path", 			k_SnowElitePath3 },
	{ "path", 			k_SnowElitePath4 },
	{ "reconLeader", 			k_SnowReconLeader },
	{ "reconLeader", 			k_SnowReconLeader2 },
	{ "wraithOfficer",		 		k_SnowWraithOff },
	{ "phaetongunship", 				k_SnowPhaetonGun },
	{ "phaetongunship", 				k_SnowPhaetonGun2 },
	{ "phaetongunship", 				k_SnowPhaetonGun3 },
	{ "goblinJockey", 				k_SnowGoblin1 },
	{ "goblinJockey", 				k_SnowGoblin2 },
	{ "swarmlord", 				k_SnowSwarmlord1 },
	{ "swarmlord", 				k_SnowSwarmlord2 },
	{ "swarmlord", 				k_SnowSwarmlord3 },
	{ "swarmlord", 				k_SnowSwarmlord4 },
}
local WarzoneArcBossNames = 
{
	k_SnowCommandoAtt,
	k_SnowCommandoDef,
	k_ArcOfficerAtt,
	k_ArcOfficerDef,
	k_UrbReconPlaza,
	k_SnowHunterAtt1,
	k_SnowHunterAtt2,
	k_SnowHunterAtt3,
	k_SnowHunterAtt4,
	k_SnowHunterAtt5,
	k_SnowHunterAtt6,
	k_SnowBannerman,
	k_SnowBannerman2,
	k_SnowBannerman3,
	k_UrbElitePrimeBlue,
	k_UrbElitePrimeRed,
	k_UrbElitePrimeRed3,
	k_RingBansheeRidge,
	k_RingBansheeWater,
	k_RingBansheeRidge2,
	k_RingBansheeWater2,
	k_ArcKnightAttCave,
	k_ArcKnightAttCave2,
	k_ArcKnightAttCave3,
	k_SnowPvEKnightChamp,
	k_SnowPvEKnightChamp2,
	k_ArcWarden,
	k_ArcWarden2,
	k_ArcWarden3,
	k_SnowSpecialElite,
	k_SnowSpecialElite2,
	k_SnowSolOpp,
	k_SnowElitePath,
	k_SnowElitePath2,
	k_SnowElitePath3,
	k_SnowElitePath4,
	k_SnowReconLeader,
	k_SnowReconLeader2,
	k_SnowWraithOff,
	k_SnowGoblin1,
	k_SnowGoblin2,
	k_SnowSwarmlord1,
	k_SnowSwarmlord2,
	k_SnowSwarmlord3,
	k_SnowSwarmlord4,
	k_SnowPhaetonGun,
	k_SnowPhaetonGun2,
	k_SnowPhaetonGun3
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