
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
__OnPvEGruntpocalypseStart = Delegate:new();
onPvEGruntpocalypseStart = root:AddCallback(
	__OnPvEGruntpocalypseStart
	);
pveGruntpocalypseStartResponse = onPvEGruntpocalypseStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_Gruntpocalypse',
	});
__OnPvEDefendTempleStart = Delegate:new();
onPvEDefendTempleStart = root:AddCallback(
	__OnPvEDefendTempleStart
	);
pveDefendTempleStartResponse = onPvEDefendTempleStart:Target(TargetAllPlayers):Response(
	{	         
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzone_onebasenextcapturetempleatt',
	});
__OnPvETempleBaseDefenseEndSuccessful = Delegate:new();
onPvETempleBaseDefenseEndSuccessful = root:AddCallback(
	__OnPvETempleBaseDefenseEndSuccessful
	);
pveTempleBaseDefenseEndSuccessfulResponse = onPvETempleBaseDefenseEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrstustain\wzcmndrstustain_warzonepve_TempleDefenseSuccess',
	});
__OnPvETempleBaseDefenseEndFailure = Delegate:new();
onPvETempleBaseDefenseEndFailure = root:AddCallback(
	__OnPvETempleBaseDefenseEndFailure
	);
pveTempleBaseDefenseEndFailureResponse = onPvETempleBaseDefenseEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrstustain\wzcmndrstustain_warzonepve_OneBaseTempleLost',
	});
__OnPvEDefendRelicsStart = Delegate:new();
onPvEDefendRelicsStart = root:AddCallback(
	__OnPvEDefendRelicsStart
	);
pveDefendRelicsStart = onPvEDefendRelicsStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectStart1',
	});
__OnPvETempleDefendRelicsEndSuccessful = Delegate:new();
onPvETempleDefendRelicsEndSuccessful = root:AddCallback(
	__OnPvETempleDefendRelicsEndSuccessful
	);
pveTempleDefendRelicsEndSuccessfulResponse = onPvETempleDefendRelicsEndSuccessful:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrstustain\wzcmndrstustain_warzonepve_FirefightDefendObjectSuccess',
	});
__OnPvETempleDefendRelicsEndFailure = Delegate:new();
onPvETempleDefendRelicsEndFailure = root:AddCallback(
	__OnPvETempleDefendRelicsEndFailure
	);
pveTempleDefendRelicsEndFailureResponse = onPvETempleDefendRelicsEndFailure:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrstustain\wzcmndrstustain_warzonepve_FirefightDefendObjectFail',
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
	name = "red cov garage",				
	label = 'wz_temp_pve_gen_redgar',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenericspawnedplural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_redgar_elites',					
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
				FanfareText = 'temple_pve_boss_sapper_kill_fanfare',	
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
				FanfareText = 'temple_pve_boss_sapper_kill_teamfeed',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_sapper_kill_teamfeed',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericTakedown',	
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
	name = "red cov pathfinder",				
	label = 'wz_temp_red_elite_boss',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenericspawnedplural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_cov_plains',
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
				FanfareText = 'temple_pve_boss_pathfinder_kill_fanfare',	
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
				FanfareText = 'temple_pve_boss_pathfinder_kill_teamfeed',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_pathfinder_kill_teamfeed',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericTakedown',	
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
	name = "red hunter aggravator",				
	label = 'wo_pve_hunter_start_boss',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenericspawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_plains_covenant',
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
				FanfareText = 'temple_pve_boss_hunter_01_fanfare',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenerictakedown',	
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
				FanfareText = 'temple_pve_boss_hunter_01_teamfeed',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_hunter_01_teamfeed',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
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
	name = "knight marshals",				
	label = 'wz_temp_pve_rednook_com',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_pro_plains',
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
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_knightbossgenerictakedown',	
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
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',	
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
	name = "phantom menace",				
	label = 'wz_pve_red_phantom_01',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric2',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_worn_ruins_covenant',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('boss_kill_shelfmsg', GetScoreVal(1000));
				end,	
			},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(1000),
			},			
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_cov_01_kill_fanfare_02',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhantomBossGenericTakedown',	
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
				FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_02',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_02',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhantomBossGenericTakedown',	
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
	name = "red mech stimbab",				
	label = 'wz_temp_pve_grunt_mech',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_redgrunt_plains',
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
				FanfareText = 'tr_pve_r4grunt_mech_2_ptakedown',	
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
				FanfareText = 'tr_pve_r4grunt_mech_2_ttakedown ',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'tr_pve_r4grunt_mech_2_ttakedown ',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericTakedown',	
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
	name = "temple vanguard",				
	label = 'wo_sg_temp_pve_elite_van',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_elitebossgenericspawnedplural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_temple_overwatch_covenant',
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
				FanfareText = 'temple_pve_boss_cov_01_kill_fanfare_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericTakedown',	
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
				FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericTakedown',	
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
	name = "promo hog",				
	label = 'wz_temp_pve_boss_hog_01',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BossMeridianWarthogSpawned01',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_pro_plains',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_boss_kill_shelfmsg', GetScoreVal(750));
				end,	
			},	
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(750),
			},		
			{		
				Medal = 'legendary_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_prom_kill_fanfare_02',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedown',	
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
				FanfareText = 'temple_pve_boss_prom_kill_teamfeed_02',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_prom_kill_teamfeed_02',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedown',	
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
	name = "twin wardens",				
	label = 'wz_pve_temple_top_for_wards',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BossTempleWardenSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_temple_overwatch_prometheans',
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
				FanfareText = 'arc_boss_warden_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompletePlayer',	
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
				FanfareText = 'arc_boss_warden_killed_teamfeed',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'arc_boss_warden_killed_teamfeed',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1CompleteFriendly',	
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
	name = "mantis enemy",				
	label = 'wz_temp_pve_boss_mantii',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_prometheanleggenericbossspawned2',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_pro_oasis',
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
				FanfareText = 'temple_pve_boss_prom_kill_fanfare_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_MantisBossGenericTakedown',	
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
				FanfareText = 'temple_pve_boss_prom_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_prom_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_MantisBossGenericTakedown',	
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
	name = "phaeton",				
	label = 'wz_temp_pve_boss_phaeton_01',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_pro_oasis',
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
				FanfareText = 'temple_pve_phat_prom_01_fanfare',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedown',	
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
				FanfareText = 'temple_pve_phat_prom_01_teamfeed',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_phat_prom_01_teamfeed',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedown',	
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
	name = "green mech",				
	label = 'wz_temp_pve_green_mech_boss',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_greengrunt_ruins',
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
				FanfareText = 'meridian_r_pve_r5grunt_fanfare_p',	
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
				FanfareText = 'meridian_r_pve_r5grunt_fanfare_t',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_r_pve_r5grunt_fanfare_t',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericTakedown',	
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
	name = "3wraithsIntro",				
	label = 'wz_pve_temp_ban_boss_01',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BansheeBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_oasis_covenant',
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
				FanfareText = 'urban_pve_bansheeraider_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'urban_pve_bansheeraider_killed_teammessage',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BansheeBossGenericTakedown',	
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
	name = "3wraiths",				
	label = 'wz_pve_temp_wraith_boss',				
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
				{	
					Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_phantomspawn',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_boss_oasis_covenant',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('mythic_boss_kill_shelfmsg', GetScoreVal(1000));
				end,	
			},	
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(1000),
			},		
			{		
				Medal = 'mythic_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_cov_01_kill_fanfare_05',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericTakedown',	
				ImpulseEvent = 'mythic_boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_05',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_05',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericTakedown',	
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
	name = "mythic knight",				
	label = 'wz_pve_mythic_boss_knight_all',				
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
				{	
					Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_knightspawn',
				},				
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_pro_oasis',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('mythic_boss_kill_shelfmsg', GetScoreVal(2000));
				end,	
			},	
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(2000),
			},		
			{		
				Medal = 'mythic_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_prom_kill_fanfare_03',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',	
				ImpulseEvent = 'mythic_boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_prom_kill_teamfeed_03',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_prom_kill_teamfeed_03',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',	
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
	name = "legendary knight",				
	label = 'wz_temp_pve_oasis_command_boss',				
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
				{	
				},				
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_pro_oasis',
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
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedown',	
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
	name = "oasis warden",				
	label = 'wz_temp_pve_oasis_warden',				
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
				{	
					Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_wardenspawn',
				},
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden2DiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'temple_pve_boss_pro_oasis',
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
				FanfareText = 'arc_boss_warden_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompletePlayer',	
				ImpulseEvent = 'mythic_boss_takedown',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		progressFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'arc_boss_warden_killed_teamfeed',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'arc_boss_warden_killed_teamfeed',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1CompleteFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'mmultiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_BossPrometheanGenericTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
},					
};
applyDefaultMinibossResponses(minibossDefinitions);
k_TempleElitePahtfinder		= ResolveString("temple_pve_boss_skir_01");
k_TempleElitePahtfinder2	= ResolveString("temple_pve_boss_skir_02");
k_TempleElitePahtfinder3	= ResolveString("temple_pve_boss_skir_03");
k_TempleElitePahtfinder4	= ResolveString("temple_pve_boss_skir_04");
k_TempleEliteSap	= ResolveString("temple_pve_boss_sapp_01");
k_TempleEliteSap2	= ResolveString("temple_pve_boss_sapp_02");
k_TempleEliteSap3	= ResolveString("temple_pve_boss_sapp_03");
k_TempKnightMarhal	= ResolveString("arc_boss_knights_def_name");
k_TempPhantom	= ResolveString("temple_pve_boss_cov_02");
k_TempSword	= ResolveString("temple_pve_boss_prom_02");
k_TempVanguard	= ResolveString("temple_pve_boss_cov_01");
k_TempVanguard2	= ResolveString("temple_pve_boss_cov_01b");
k_TempWarden	= ResolveString("arc_boss_warden_name");
k_TempTomp	= ResolveString("temple_pve_boss_cov_04");
k_TempMantii	= ResolveString("temple_pve_boss_prom_01");
k_TempPhaeton	= ResolveString("temple_pve_phat_prom_01");
k_TempDeac	= ResolveString("temple_pve_boss_cov_03");
k_TempKnight	= ResolveString("temple_pve_boss_prom_03");
k_TempKnight2	= ResolveString("temple_pve_boss_prom_04");
k_TempKnight3	= ResolveString("temple_pve_boss_prom_05");
k_TempKnight4	= ResolveString("temple_pve_boss_prom_06");
k_TempWraith	= ResolveString("temple_pve_boss_cov_05");
k_TempHAggra = ResolveString("temple_pve_boss_hunter_01");
k_TempChampion = ResolveString("meridian_pve_boss_kngcham");
k_TempRaider = ResolveString("ring_boss_center_banshees_01");
k_TempPveYimblap	=	ResolveString("boss_yimblap");
k_TempPveStimbab	=	ResolveString("temple_r_pve_mech_stimbab");
local WarzoneTempleBossNamesAndIds = 
{
	{ "path", 			k_TempleElitePathfinder },
	{ "path", 			k_TempleElitePathfinder2 },
	{ "path", 			k_TempleElitePathfinder3 },
	{ "path", 			k_TempleElitePathfinder4 },
	{ "sap", 			k_TempleEliteSap },
	{ "sap", 			k_TempleEliteSap2 },
	{ "sap", 			k_TempleEliteSap3 },
	{ "marshal", 		k_TempKnightMarhal },
	{ "cap", 			k_TempPhantom },
	{ "sword", 			k_TempSword },
	{ "aggro", 			k_TempHAggra },
	{ "vang", 			k_TempVanguard },
	{ "vang", 			k_TempVanguard2 },
	{ "warden",			k_TempWarden },
	{ "tomp",			k_TempTomp },
	{ "phyrric",		k_TempMantii },
	{ "fist",			k_TempPhaeton },
	{ "deac",			k_TempDeac },
	{ "knecl",			k_TempKnight },
	{ "knasp",			k_TempKnight2 },
	{ "knsil",			k_TempKnight3 },
	{ "knaby",			k_TempKnight4 },
	{ "champion",		k_TempChampion },
	{ "raider",			k_TempRaider },
	{ "daz",			k_TempWraith },
	{ "yimblap",		k_TempPveYimblap },
	{ "stimbab",		k_TempPveStimbab },
}
local WarzoneTempleBossNames = 
{
	k_TempleElitePathfinder,
	k_TempleElitePathfinder2,
	k_TempleElitePathfinder3,
	k_TempleElitePathfinder4,
	k_TempleEliteSap,
	k_TempleEliteSap2,
	k_TempleEliteSap3,
	k_TempKnightMarhal,
	k_TempPhantom,
	k_TempHAggra,
	k_TempSword,
	k_TempVanguard,
	k_TempVanguard2,
	k_TempTomp,
	k_TempMantii,
	k_TempPhaeton,
	k_TempDeac,
	k_TempKnight,
	k_TempKnight2,
	k_TempKnight3,
	k_TempKnight4,
	k_TempChampion,
	k_TempRaider,
	k_TempWraith,
	k_TempWarden,
	k_TempPveYimblap,
	k_TempPveStimbab
}
onDeathByBoss = onKill:Filter(
	function(context)
		context.TargetPlayer = context.DeadPlayer;
		if context.KillingObject == nil or
			context.KillingObject:IsBossUnit() == false then
			return false;	
		end
		return table.any(WarzoneTempleBossNames,
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
for index, allBosses in ipairs(WarzoneTempleBossNamesAndIds) do
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