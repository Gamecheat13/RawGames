
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
		name = "urban_boss1",				
		label = 'wz_obj_urban_boss1',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_CovenantGenericBossSpawned3',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_eliteprimes_hill_spawned',
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
					FanfareText = 'urban_pve_eliteprime_kill_fanfare',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenerictakedown',	
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
					FanfareText = 'urban_pve_eliteprime_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzonepve_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_eliteprime_killed_teammessage',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericTakedownFriendly',	
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
		name = "urban_boss2",				
		label = 'wz_obj_urban_boss2',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_CovenantGenericBossSpawned3',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_eliteultras_armory_spawned',
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
					FanfareText = 'urban_pve_eliteultra_kill_fanfare',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenerictakedown',	
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
					FanfareText = 'urban_pve_eliteultra_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_eliteultra_killed_teammessage',	
					Sound = 'multiplayer\audio\wwzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericTakedownFriendly',	
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
		name = "urban_boss3",				
		label = 'wz_obj_urban_boss3',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric5',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_serpenthunters_southgate_spawned',
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
					FanfareText = 'urban_pve_serpenthunter_kill_fanfare',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
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
					FanfareText = 'urban_pve_serpenthunter_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_serpenthunter_killed_teammessage',	
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
		name = "urban_boss4",				
		label = 'wz_obj_urban_boss4',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric5',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_knightmarshals_lawn_spawned',
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
					FanfareText = 'urban_pve_knightmarshal_kill_fanfare',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',	
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
					FanfareText = 'urban_pve_knightmarshal_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_knightmarshal_killed_teammessage',	
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
		name = "urban_boss5",				
		label = 'wz_obj_urban_boss5',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericSpawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_hunterdevastators_garage_spawned',
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
					FanfareText = 'urban_pve_hunterdevastator_kill_fanfare',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
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
					FanfareText = 'urban_pve_hunterdevastator_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_hunterdevastator_killed_teammessage',	
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
		name = "urban_boss6",				
		label = 'wz_obj_urban_boss6',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric5',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_elites_garage_spawned',
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
					FanfareText = 'urban_pve_eliteprimeandultra_kill_fanfare',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericProgressPlayer',	
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
					FanfareText = 'urban_pve_eliteprimeandultra_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_eliteprimeandultra_killed_teammessage',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericProgressPlayer',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_NearingVictoryGeneric',		
			},			
		},				
		killedTeammatesCount = 3,				
	},					
	{					
		name = "urban_boss7",				
		label = 'wz_obj_urban_boss7',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_CovenantSlipspaceSpawn',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_ghostmarauders_highway_spawned',
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
					FanfareText = 'urban_pve_ghostmarauder_kill_fanfare',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedown',	
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
					FanfareText = 'urban_pve_ghostmarauder_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_ghostmarauder_killed_teammessage',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedownFriendly',	
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
		name = "urban_boss8",				
		label = 'wz_obj_urban_boss8',
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_CovenantSlipspaceSpawn',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BansheeBossGenericSpawnedPlural',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_bansheeraiders_armory_spawned',
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
					FanfareText = 'urban_pve_bansheeraider_kill_fanfare',	
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
					FanfareText = 'urban_pve_bansheeraider_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_bansheeraider_killed_teammessage',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BansheeBossGenericTakedownFriendly',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_IncursionEnemyBanshee2',		
			},			
		},				
		killedTeammatesCount = 3,				
	},					
	{					
		name = "urban_boss9",				
		label = 'wz_obj_urban_boss9',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_invadervaran_lawn_spawned',
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
					FanfareText = 'urban_pve_invader_killed_fanfare',	
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
					FanfareText = 'urban_pve_genericforerunner_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_invader_killed_teammessage',	
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
		name = "urban_boss9",				
		label = 'wz_obj_urban_boss9_phaetons',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericSpawned',
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
					FanfareText = 'urban_pve_helmsmen_killed_fanfare',	
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
					FanfareText = 'urban_pve_helmsmen_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_genericforerunner_killed_teammessage',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedownFriendly',	
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
		name = "urban_boss10",				
		label = 'wz_obj_urban_boss10',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric5',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_warden_westgate_spawned',
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
					FanfareText = 'urban_pve_warden_kill_fanfare',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1CompletePlayer',	
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
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1CompleteFriendly',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenTeammatesKilled',		
			},			
		},				
		killedTeammatesCount = 3,				
	},					
	{					
		name = "urban_boss11",				
		label = 'wz_obj_urban_boss11',				
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_CovenantLegGenericBossSpawned',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_covenantslipspacespawn',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_wraithtrio_highway_spawned',
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
					FanfareText = 'urban_pve_wraithtrio_kill_fanfare',	
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
					FanfareText = 'urban_pve_wraithtrio_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_wraithtrio_killed_teammessage',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericTakedownFriendly',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_IncursionEliminateWraith',		
			},			
		},				
		killedTeammatesCount = 3,				
	},					
	{					
		name = "urban_boss12",				
		label = 'wz_obj_urban_boss12',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_fourlords_hill_spawned',
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
					FanfareText = 'urban_pve_fourlords_kill_fanfare',	
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
					FanfareText = 'urban_pve_fourlords_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_fourlords_killed_teammessage',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedownFriendly',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_IncursionEliminateKnight',		
			},			
		},				
		killedTeammatesCount = 3,				
	},					
	{					
		name = "urban_boss13_legend",				
		label = 'wz_obj_urban_boss13_legend',				
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BossPrometheanGenericIncoming1',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericSpawnedPlural',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_soldier_enforcer_armory_spawned',
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
					FanfareText = 'arc_boss_soldier_kill_fanfare',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedown',	
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
					FanfareText = 'arc_boss_soldier_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'arc_boss_soldier_killed_teammessage',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedownFriendly',	
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
		name = "urban_boss13_mythic",				
		label = 'wz_obj_urban_boss13_mythic',				
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BossPrometheanGenericIncoming2',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_IncursionBossMythic1',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_warden_base_spawned01',
					},	
					{	
						Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_wardenspawn',
					},
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
					FanfareText = 'urban_pve_warden_kill_fanfare',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompletePlayer',	
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
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenTeammatesKilled',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenTeammatesKilled',		
			},			
		},				
		killedTeammatesCount = 3,				
	},
	{					
		name = "urban_boss13_legendary_warden",				
		label = 'wz_obj_urban_boss13_legendary',				
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
					{	
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
					FanfareText = 'urban_pve_warden_kill_fanfare',	
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
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompleteFriendly',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenTeammatesKilled',		
			},			
		},				
		killedTeammatesCount = 3,				
	},								
	{					
		name = "urban_boss14_legend",				
		label = 'wz_obj_urban_boss14_legend',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_Boss10sGeneric2',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericSpawnedPlural',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_soldier_guard_lawn_spawned',
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
					FanfareText = 'ring_boss_north_soldier_kill_fanfare',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedown',	
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
					FanfareText = 'ring_boss_north_soldier_kill_teamfeed',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'ring_boss_north_soldier_kill_teamfeed',	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedownFriendly',	
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
		name = "urban_boss14_mythic",				
		label = 'wz_obj_urban_boss14_mythic',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_IncursionBossMythic1',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_warden_base_spawned01',
					},
{						Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_wardenspawn',
					},					
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
					FanfareText = 'urban_pve_warden_kill_fanfare',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompletePlayer',	
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
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossGenericProgressPlayer',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenTeammatesKilled',		
			},			
		},				
		killedTeammatesCount = 3,				
	},					
	{					
		name = "urban_boss15_legend",				
		label = 'wz_obj_urban_boss15_legend',				
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
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BossUrbanSacredPrometheansAppeared',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_knight_champion_commons_spawned',
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
					FanfareText = 'meridian_pve_knight_champions_kill_fanfare',	
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
					FanfareText = 'meridian_pve_knight_champions_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'meridian_pve_knight_champions_killed_teammessage',	
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
		name = "urban_boss15_mythic",				
		label = 'wz_obj_urban_boss15_mythic',				
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric3',
					},	
				},     		
				[0] = 		
				{		
					{	
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1DiscoveredPlayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'urban_pve_boss_warden_hill_highway_spawned',
					},	
					{	
						Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_wardenspawn',
					},
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
					FanfareText = 'urban_pve_warden_kill_fanfare',	
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
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				},		
			},			
			completeFriendlyResponse = 			
			{			
				{		
					Fanfare = FanfareDefinitions.KillFeed,	
					FanfareText = 'urban_pve_warden_killed_teammessage',	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompleteFriendly',	
				},		
				{		
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
				}		
			},			
			killedTeammatesResponse =			
			{			
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenTeammatesKilled',		
			},			
		},				
		killedTeammatesCount = 3,				
	},					
};
applyDefaultMinibossResponses(minibossDefinitions);
k_UrbanFFElitePrime		= ResolveString("urban_pve_boss_elite01");
k_UrbanFFEliteUltra		= ResolveString("urban_pve_boss_elite02");
k_UrbanFFSerpenHunter		= ResolveString("urban_pve_boss_hunter01");
k_UrbanFFKnightMarshal		= ResolveString("urban_pve_boss_knight05");
k_UrbanFFHunterDev		= ResolveString("urban_pve_boss_hunter02");
k_UrbanFFGhostMaurader		= ResolveString("urban_pve_boss_ghost01");
k_UrbanFFBansheeRaid		= ResolveString("urban_pve_boss_banshee01");
k_UrbanFFKnightSublimis		= ResolveString("urban_pve_boss_knight06");
k_UrbanFFPhaetonHelmsman		= ResolveString("urban_pve_boss_phaeton01");
k_UrbanFFWarden		= ResolveString("urban_pve_boss_warden01");
k_UrbanFFWraith1		= ResolveString("urban_pve_boss_wraith01");
k_UrbanFFWraith2		= ResolveString("urban_pve_boss_wraith02");
k_UrbanFFWraith3		= ResolveString("urban_pve_boss_wraith03");
k_UrbanFFCommander1		= ResolveString("urban_pve_boss_knight01");
k_UrbanFFCommander2		= ResolveString("urban_pve_boss_knight02");
k_UrbanFFCommander3		= ResolveString("urban_pve_boss_knight03");
k_UrbanFFCommander4		= ResolveString("urban_pve_boss_knight04");
k_UrbanFFSolEnf		= ResolveString("urban_pve_boss_soldier02");
k_UrbanFFSolGuard		= ResolveString("urban_pve_boss_soldier01");
k_UrbanFFKnChamp		= ResolveString("urban_pve_boss_knight07");
local WarzoneArcBossNamesAndIds = 
{
	{ "prime", 				k_UrbanFFElitePrime },
	{ "ultra", 				k_UrbanFFEliteUltra },
	{ "serpentHunter", 		k_UrbanFFSerpenHunter },
	{ "marshal", 			k_UrbanFFKnightMarshal },
	{ "hunterDev",	 	k_UrbanFFHunterDev },
	{ "marauder", 			k_UrbanFFGhostMaurader },
	{ "raider", 			k_UrbanFFBansheeRaid },
	{ "sublimis",	 			k_UrbanFFKnightSublimis },
	{ "helmsman",				k_UrbanFFPhaetonHelmsman },
	{ "warden",				k_UrbanFFWarden },
	{ "wraith01",				k_UrbanFFWraith1 },
	{ "wraith02",				k_UrbanFFWraith2 },
	{ "wraith03",				k_UrbanFFWraith3 },
	{ "commander01",				k_UrbanFFCommander1 },
	{ "commander02",				k_UrbanFFCommander2 },
	{ "commander03",				k_UrbanFFCommander3 },
	{ "commander04",				k_UrbanFFCommander4 },
	{ "enforcer", 			k_UrbanFFSolEnf },
	{ "guard", 			k_UrbanFFSolGuard },
	{ "knightChamp", 			k_UrbanFFKnChamp },
}
local WarzoneArcBossNames = 
{
	k_UrbanFFElitePrime,
	k_UrbanFFEliteUltra,
	k_UrbanFFSerpenHunter,
	k_UrbanFFKnightMarshal,
	k_UrbanFFHunterDev,
	k_UrbanFFGhostMaurader,
	k_UrbanFFBansheeRaid,
	k_UrbanFFKnightSublimis,
	k_UrbanFFPhaetonHelmsman,
	k_UrbanFFWarden,
	k_UrbanFFWraith1,
	k_UrbanFFWraith2,
	k_UrbanFFWraith3,
	k_UrbanFFCommander1,
	k_UrbanFFCommander2,
	k_UrbanFFCommander3,
	k_UrbanFFCommander4,
	k_UrbanFFSolEnf,
	k_UrbanFFSolGuard	
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