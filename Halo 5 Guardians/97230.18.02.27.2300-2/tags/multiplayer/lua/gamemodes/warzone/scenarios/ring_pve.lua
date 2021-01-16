
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
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_welcometowarzone', 
		Sound2 = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionintro2',
	}):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionintro3',
	});
__OnPatrolStart = Delegate:new();
onPatrolStart = root:AddCallback(
	__OnPatrolStart
	);
warzonePatrolStartResponse = onPatrolStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_basedefensecovwaveinbound', 
		Sound2 = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_minibossincominggeneric',
	});
__OnDefendStart = Delegate:new();
onDefendStart = root:AddCallback(
	__OnDefendStart
	);
warzoneDefendStartResponse = onDefendStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_powercorevulnerable', 
		Sound2 = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_baseunderattackhomebase',
	});
__OnEliminateStart = Delegate:new();
onEliminateStart = root:AddCallback(
	__OnEliminateStart,
	function (context, squad)
		context.Squad = squad;
	end
	);
__OnEliminateDelivery = Delegate:new();
onEliminateDelivery = root:AddCallback(
	__OnEliminateDelivery,
	function (context, squad)
		context.Squad = squad;
	end
	);
function IsSquad(label)
	local resolvedLabel = ResolveString(label);
	return function(context)
		return context.Squad == resolvedLabel;
	end
end
eliminateStartSelect = onEliminateStart:Select();
eliminateDeliverySelect = onEliminateDelivery:Select();
onDefW1ReservesStart = eliminateStartSelect:Add(IsSquad("def_w_1_reserves"));
onDefW1ReservesDelivery = eliminateDeliverySelect:Add(IsSquad("def_w_1_reserves"));
onDefW1ReservesStart:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3'
	});
onDefW2Start = eliminateStartSelect:Add(IsSquad("defend_wave_2"));
onDefW2Delivery = eliminateDeliverySelect:Add(IsSquad("defend_wave_2"));
onDefW2Start:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_minibossincominggeneric'
	});
onDefW3Start = eliminateStartSelect:Add(IsSquad("defend_wave_3"));
onDefW3Start = eliminateDeliverySelect:Add(IsSquad("defend_wave_3"));
onDefW3Start:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_minibossincominggeneric'
	});
onDefW4Start = eliminateStartSelect:Add(IsSquad("defend_wave_4_init"));
onDefW4Delivery = eliminateDeliverySelect:Add(IsSquad("defend_wave_4_init"));
onDefW4Start:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_nearingvictorynoscore'
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
__OnFirefightDefendPelican = Delegate:new();
OnFirefightDefendPelican = root:AddCallback(
	__OnFirefightDefendPelican
	);
firefightDefendPelican = OnFirefightDefendPelican:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendPelican2'
	});
__OnFirefightDefendObjectWinPelican = Delegate:new();
OnFirefightDefendObjectWinPelican = root:AddCallback(
	__OnFirefightDefendObjectWinPelican
	);
firefightDefendObjectWinPelican = OnFirefightDefendObjectWinPelican:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectWinPelican'
	});
__OnFirefightDefendObjectFailPelican = Delegate:new();
OnFirefightDefendObjectFailPelican = root:AddCallback(
	__OnFirefightDefendObjectFailPelican
	);
firefightDefendObjectFailPelican = OnFirefightDefendObjectFailPelican:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightDefendObjectFailPelican'
	});
minibossDefinitions =
{	
{					
	name = "ringr1HunterBoss",				
	label = 'sg_0101_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcHuntersAttDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_remnant_hunters_spawned',
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
				FanfareText = 'arc_boss_hunters_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcHuntersAttCompletePlayer',	
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
				FanfareText = 'arc_boss_hunters_kill_teamfeed',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcHuntersAttCompletePlayer',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'arc_boss_hunters_kill_teamfeed',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcHuntersAttCompleteFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcHuntersAttTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},
{					
	name = "soldierHBBoss",				
	label = 'sg_0103_boss',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_soldierbossgenericspawnedplural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_soldier_commandos_spawned',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('boss_kill_shelfmsg', GetScoreVal(300));
				end,	
				},
			{
				Fanfare = FanfareDefinitions.PersonalScore,
				Score = GetScoreVal(300),	
			},		
			{		
				Medal = 'boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ice_boss_officer_kill_fanfare',	
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
				FanfareText = 'ice_boss_officer_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ice_boss_officer_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZSoldierTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},
{					
	name = "elite3generals",				
	label = 'sg_0105_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_Boss10sGeneric',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_elite_generals_spawned',
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
				FanfareText = 'arc_boss_att_general_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcGeneralCompletePlayer',	
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
				FanfareText = 'arc_boss_att_general_killed_teamfeed',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcGeneralCompletePlayer',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'arc_boss_att_general_killed_teamfeed',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcGeneralCompleteFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcGeneralDiscoveredFriendly',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "bansheeRaiderPair",				
	label = 'sg_0201_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingCrossroadsCovenantAppeared',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingBansheeDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_banshee_raiders_spawned',
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
				FanfareText = 'ring_boss_center_banshees_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingBansheeCompletePlayer',	
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
				FanfareText = 'ring_boss_center_banshees_kill_teamfeed',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingBansheeCompleteFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_boss_center_banshees_kill_teamfeed',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingBansheeCompleteFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingPhantomTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "knightCampionPair",				
	label = 'sg_0203_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingCrossroadsPrometheansAppeared',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric5',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_knight_spawn_gneric',
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
				FanfareText = 'ring_boss_beach_knight_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingKnightCompletePlayer',	
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
				FanfareText = 'ring_boss_beach_knight_kill_teamfeed',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_boss_beach_knight_kill_teamfeed',	
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
	name = "ghostScouts",				
	label = 'sg_0205_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric5',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_ghost_scouts_spawned',
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
				FanfareText = 'temple_boss_ghost_scout_kill_fanfare',	
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
				FanfareText = 'temple_boss_ghost_scout_kill_teamfeed',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_boss_ghost_scout_kill_teamfeed',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GhostBossGenericTakedownFriendly',	
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
	name = "r3WardenBoss",				
	label = 'sg_0301_boss',				
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
					FanfareText = 'ring_pve_boss_warden_wcoast_spawned',
				},	
			},		
		},			
		completePlayerResponse =			
		{			
			{		
				Fanfare = FanfareDefinitions.QuestFeed,	
				FanfareText = function (context)	
					return FormatText('legendary_kill_shelfmsg', GetScoreVal(2000));
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
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompletePlayer',	
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
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWardenTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "r3HunterParticulars",				
	label = 'sg_0303_boss',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightCovProTeamUp',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_hunter_particulars_spawned',
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
				FanfareText = 'ring_pve_boss_hunter_particular_kill_fanfare_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
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
				FanfareText = 'ring_pve_boss_hunter_particular_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_pve_boss_hunter_particular_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanHunterTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "r3KnightDuo",				
	label = 'sg_0305_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossPromethean10sGeneric',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_knight_pair_generic_spawned',
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
				FanfareText = 'ring_pve_boss_knight_ascendos_kill_fanfare_01',	
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
				FanfareText = 'ring_pve_boss_knight_ascendos_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_pve_boss_knight_ascendos_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcKnightComTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "r4HunterPremiers",				
	label = 'sg_0401_boss',				
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
					FanfareText = 'ring_pve_boss_hunter_premiers_spawned',
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
				FanfareText = 'ring_pve_boss_hunter_premier_kill_fanfare_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
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
				FanfareText = 'ring_pve_boss_hunter_premier_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_pve_boss_hunter_premier_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanHunterTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "r4SoldierOfficers",				
	label = 'sg_0403_boss',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_soldier_bandits_spawned',
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
				FanfareText = 'meridian_pve_soldier_commandos_kill_fanfare',	
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
				FanfareText = 'meridian_pve_soldier_commandos_killed_teammessage',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_soldier_commandos_killed_teammessage',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_SoldierBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanSoldierTeammatesKilledAlt',		
		},			
	},				
	killedTeammatesCount = 3,				
	},
{					
	name = "r4PhaetonPilots",				
	label = 'sg_0404_boss',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericSpawnedPlural',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_phaetons_generic_spawned',
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
				FanfareText = 'ring_pve_boss_pilotbonodan_kill_fanfare_01',	
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
				FanfareText = 'ring_pve_boss_pilotbonodan_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_pve_boss_pilotbonodan_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_PhaetonBossGenericTakedownFriendly',	
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
	name = "r4SoldierEliteBosses",				
	label = '0501_01_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_Boss10sGeneric',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_FirefightCovProTeamUp',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_r5prow1_soldierelites_spawned',
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
				FanfareText = 'ring_boss_att_cave_stealth_kill_fanfare',	
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
				FanfareText = 'ring_boss_att_cave_stealth_kill_teamfeed',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_EliteBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_boss_att_cave_stealth_kill_teamfeed',	
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
	name = "r5MythicKnights",				
	label = 'sg_0501_02_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_Boss10sGeneric',
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
					FanfareText = 'ring_pve_boss_r5prow2_knight_executors_spawned',
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
				FanfareText = 'ring_pve_boss_knight_executor_kill_fanfare_01',	
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
				FanfareText = 'ring_pve_boss_knight_executor_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_pve_boss_knight_executor_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_KnightBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcKnightComTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "r5TankmasterLuk",				
	label = 'sg_0502_01_wraith_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric2',
				},	
				{	
					Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_phantomspawn',
				},
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_r5covw1_tankmasterluk_spawned',
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
				FanfareText = 'ring_pve_boss_tank_luk_kill_fanfare_01',	
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
				FanfareText = 'ring_pve_boss_tank_luk_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_pve_boss_tank_luk_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_WraithBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWraithTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "r5PhantomBosses",				
	label = 'sg_0502_02_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric2',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringphantomappeared',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_r5covw2_phantom_boss_spawned',
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
				FanfareText = 'ring_pve_boss_phantom_boss_kill_fanfare_01',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingPhantomCompletePlayer',	
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
				FanfareText = 'ring_pve_boss_phantom_boss_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingPhantomCompletePlayer',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_pve_boss_phantom_boss_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingPhantomCompleteFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingPhantomTeammatesKilled',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
{					
	name = "r5Grunt Mech",				
	label = '0503_01_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossCovenant10sGeneric5',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericSpawned',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_pve_boss_r5altcovw1_grunt_mech_spawned',
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
				FanfareText = 'temple_pve_boss_cov_01_kill_fanfare_03',	
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
				FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_03',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_GruntMechBossGenericTakedown',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'temple_pve_boss_cov_01_kill_teamfeed_03',	
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
	name = "r5HunterSupremes",				
	label = 'sg_0503_02_boss',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingUltHuntersAppeared',
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
					FanfareText = 'ring_pve_boss_r5altcovw2_hunter_supremes_spawned',
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
				FanfareText = 'ring_pve_boss_hunter_supreme_kill_fanfare_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedown',	
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
				FanfareText = 'ring_pve_boss_hunter_supreme_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'ring_pve_boss_hunter_supreme_kill_teamfeed_01',	
				Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_HunterBossGenericTakedownFriendly',	
			},		
			{		
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			}		
		},			
		killedTeammatesResponse =			
		{			
			Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcHuntersAttDiscoveredFriendly',		
		},			
	},				
	killedTeammatesCount = 3,				
	},					
};
applyDefaultMinibossResponses(minibossDefinitions);
k_RingR1Hunter01	= ResolveString("arc_boss_hunter_att_01");
k_RingR1Hunter02	= ResolveString("arc_boss_hunter_att_02");
k_RingR1SolOff01	= ResolveString("ice_boss_def_officer");
k_RingR1EliteGen	= ResolveString("arc_boss_def_general_name");
k_RingR2Banshee	= ResolveString("ring_boss_center_banshees_01");
k_RingR2Knight	= ResolveString("ring_boss_beach_knight_01");
k_RingR2Ghost01 	= ResolveString("temple_boss_ghost_scout_att_1");
k_RingR2Ghost02 	= ResolveString("temple_boss_ghost_scout_att_2");
k_RingR3Warden	= ResolveString("urban_pve_boss_warden01");
k_RingR3Hunter01	= ResolveString("ring_pve_boss_hunter_particular01");
k_RingR3Hunter02	= ResolveString("ring_pve_boss_hunter_particular02");
k_RingR3KnightAsc	= ResolveString("ring_pve_boss_knight_ascendos");
k_RingR3KnightPre	= ResolveString("ring_pve_boss_knight_prevalos");
k_RingR4Hunter01	= ResolveString("ring_pve_boss_hunter_premier01");
k_RingR4SolOff01	= ResolveString("meridian_pve_boss_soldcom");
k_RingR4Vtol01		= ResolveString("arc_boss_vtol");
k_RingR4Vtol02		= ResolveString("ring_pve_boss_pilotbonodan")
k_RingR5Elite01	= ResolveString("ring_boss_att_cave_stealth_01");
k_RingR5KnightExec = ResolveString("ring_pve_boss_knight_executor01");
k_RingR5Phantom01	= ResolveString("ring_pve_boss_phantom_boss");
k_RingR5Wraith01 	= ResolveString("ring_pve_boss_tank_luk");
k_RingR5GrMech01		= ResolveString("temple_pve_boss_cov_03");
k_RingR5MythHunt01			= ResolveString("ring_pve_boss_hunter_supreme01");
k_RingR5MythHunt02			= ResolveString("ring_pve_boss_hunter_supreme02");
local WarzoneRingBossNamesAndIds = 
{
	{ "remHunter01",		k_RingR1Hunter01 },
	{ "remHunter02",		k_RingR1Hunter02 },
	{ "solCommand", 		k_RingR1SolOff01 },
	{ "sangGen", 			k_RingR1EliteGen },
	{ "bansheeRaid",		k_RingR2Banshee },
	{ "knightChamp", 		k_RingR2Knight },
	{ "ghostScout", 		k_RingR2Ghost01 },
	{ "ghostScout",	 		k_RingR2Ghost02 },
	{ "warden", 			k_RingR3Warden },
	{ "huntPat01", 			k_RingR3Hunter01 },
	{ "huntPat02", 			k_RingR3Hunter02 },
	{ "knightAsc", 			k_RingR3KnightAsc },
	{ "knightPrev", 		k_RingR3KnightPre },
	{ "huntPrem01", 		k_RingR4Hunter01 },
	{ "solCom01", 			k_RingR4SolOff01 },
	{ "masterIndex",		k_RingR4Vtol01 },
	{ "pilBonodan", 		k_RingR4Vtol02 },
	{ "zealotAss", 			k_RingR5Elite01 },
	{ "knightExec", 		k_RingR5KnightExec },
	{ "glorAdvance", 		k_RingR5Phantom01 },
	{ "tankLuk",			k_RingR5Wraith01 },
	{ "deaconPip",			k_RingR5GrMech01 },
	{ "huntSup01", 			k_RingR5MythHunt01 },
	{ "huntSup02",		 	k_RingR5MythHunt02 },
}
local WarzoneRingBossNames = 
{
	k_RingR1Hunter01,
	k_RingR1Hunter02,
	k_RingR1SolOff01,
	k_RingR1EliteGen,
	k_RingR2Banshee,
	k_RingR2Knight,
	k_RingGhostWater,
	k_RingR2Ghost01,
	k_RingR2Ghost02,
	k_RingR3Warden,
	k_RingR3Hunter01,
	k_RingR3Hunter02,
	k_RingR3KnightAsc,
	k_RingR3KnightPre,
	k_RingR4Hunter01,
	k_RingR4SolOff01,
	k_RingR4Vtol01,
	k_RingR4Vtol02,
	k_RingR5Elite01,
	k_RingR5KnightExec,
	k_RingR5Phantom01,
	k_RingR5Wraith01,
	k_RingR5GrMech01,	
	k_RingR5MythHunt01,
	k_RingR5MythHunt02
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