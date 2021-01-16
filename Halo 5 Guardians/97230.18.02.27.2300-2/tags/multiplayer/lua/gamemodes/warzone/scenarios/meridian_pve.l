
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
     }):Response(
     {
           Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionintro2',
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
	name = "Knight Marshals",				
	label = 'wzlabel_colony_proboss_01',				
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
					FanfareText = 'meridian_pve_knight_marshals_spawned',
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
				FanfareText = 'meridian_pve_knight_marshals_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcKnightBatCompletePlayer',	
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
				FanfareText = 'meridian_pve_knight_marshals_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_knight_marshals_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcKnightBatCompleteFriendly',	
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
	name = "Serpent Hunters",				
	label = 'wzlabel_colony_covboss_01',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZHunterDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_serpent_hunters_spawned',
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
				FanfareText = 'meridian_pve_serpent_hunters_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZHunterCompletePlayer',	
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
				FanfareText = 'meridian_pve_serpent_hunters_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_serpent_hunters_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZHunterCompleteFriendly',	
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
	name = "Platoon Captain",				
	label = 'wzlabel_shed_wraith_01',				
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_covenantslipspacespawn',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_platoon_captain_spawned',
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
				FanfareText = 'meridian_pve_platoon_captain_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWraithCompletePlayer',	
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
				FanfareText = 'meridian_pve_platoon_captain_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_platoon_captain_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWraithCompletePlayer',	
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
	name = "Knght Champions",				
	label = 'wzlabel_caves_knights_01',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingKnightDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_knight_champions_spawned',
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
				FanfareText = 'meridian_pve_knight_champions_kill_fanfare',	
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
				FanfareText = 'meridian_pve_knight_champions_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_knight_champions_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingKnightCompleteFriendly',	
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
	name = "Soldier Guard",				
	label = 'wzlabel_glacier_soldier_01',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingSoldierDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_soldier_guard_spawned',
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
				FanfareText = 'meridian_pve_soldier_guard_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingSoldierCompletePlayer',	
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
				FanfareText = 'meridian_pve_soldier_guard_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_soldier_guard_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingSoldierCompleteFriendly',	
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
	name = "Remnant Hunters",				
	label = 'wzlabel_dock_hunters_01',				
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
					FanfareText = 'meridian_pve_remnant_hunter_spawned',
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
				FanfareText = 'meridian_pve_remnant_hunter_kill_fanfare',	
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
				FanfareText = 'meridian_pve_remnant_hunter_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_remnant_hunter_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcHuntersAttProgressFriendly',	
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
	name = "Soldier Commandos",				
	label = 'wzlabel_fortress_manti_01',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZSoldierDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_soldier_commandos_spawned',
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
				FanfareText = 'meridian_pve_soldier_commandos_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZSoldierCompletePlayer',	
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
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_soldier_commandos_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZSoldierCompleteFriendly',	
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
	name = "Phaeton Gunships",				
	label = 'wzlabel_phaeton_01',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossArcVtolExplored',
				},	
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_VehiclePurchasedPhaetonEnemy',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_phaeton_helmsmen_spawned',
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
				FanfareText = 'meridian_pve_phaeton_helmsmen_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_VehicleDestroyedVtol',	
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
				FanfareText = 'meridian_pve_phaeton_helmsmen_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_phaeton_helmsmen_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_PhaetonBossGenericTakedownFriendly',	
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
	name = "Legendary Warden Eternal (Base)",				
	label = 'wzlabel_base_proboss_warden',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1DiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_warden_eternal_spawned',
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
				FanfareText = 'meridian_pve_warden_eternal_kill_fanfare',	
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
				FanfareText = 'meridian_pve_warden_eternal_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_warden_eternal_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZWardenCompletePlayer',	
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
     name = "Tomp Fury of Blaho",                    
     label = 'wzlabel_base_covboss',                     
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
                           FanfareText = 'meridian_pve_grunt_mech_spawned',
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
                     FanfareText = 'meridian_pve_grunt_mech_kill_fanfare',     
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
                     FanfareText = 'meridian_pve_grunt_mech_killed_teammessage',     
                     Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'     
                },         
           },              
           completeFriendlyResponse =            
           {               
                {          
                     Fanfare = FanfareDefinitions.KillFeed, 
                     FanfareText = 'meridian_pve_grunt_mech_killed_teammessage',     
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
	name = "Mythic Warden Eternal (Colony)",				
	label = 'wzlabel_shed_proboss_warden',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden1DiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_mythic_warden_spawned',
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
				Score = GetScoreVal(4000),	
			},
			{
			Fanfare = FanfareDefinitions.PersonalScore,
			Score = GetScoreVal(4000),
			},
			{		
				Medal = 'mythic_boss_takedown',	
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_warden_eternal_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden2CompletePlayer',	
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
				FanfareText = 'meridian_pve_warden_eternal_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_warden_eternal_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanWarden2CompletePlayer',	
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
	name = "Knight Luminaries",				
	label = 'wzlabel_shed_proboss_knights',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZKnightDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_knight_luminary_spawned',
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
				FanfareText = 'meridian_pve_knight_luminary_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZKnightCompletePlayer',	
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
				FanfareText = 'meridian_pve_knight_luminary_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_knight_luminary_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossSZKnightCompleteFriendly',	
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
	name = "Ghost Squadron",				
	label = 'wzlabel_mythic_knight_ghosts',				
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossRingGhostDiscoveredPlayer',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_ghost_squad_spawned',
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
				FanfareText = 'meridian_pve_ghost_squad_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanGhostCompletePlayer',	
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
				FanfareText = 'meridian_pve_ghost_squad_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_ghost_squad_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanGhostCompleteFriendly',	
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
	name = "Mythic Knight Noble (Colony)",				
	label = 'wzlabel_mythic_knight',				
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
				{    
                    Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_knightspawn',
                },                        
			},     		
			[0] = 		
			{		
				{	
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionbossmythic1',
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'meridian_pve_knight_noble_spawned',
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
				FanfareText = 'meridian_pve_knight_noble_kill_fanfare',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanKnightCompletePlayer',	
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
				FanfareText = 'meridian_pve_knight_noble_killed_teammessage',	
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'	
			},		
		},			
		completeFriendlyResponse = 			
		{			
			{		
				Fanfare = FanfareDefinitions.KillFeed,	
				FanfareText = 'meridian_pve_knight_noble_killed_teammessage',	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_BossUrbanKnightCompleteFriendly',	
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
};
applyDefaultMinibossResponses(minibossDefinitions);
k_MerR1Wraith		= ResolveString("meridian_pve_boss_platcapt");
k_MerKnightMarhal		= ResolveString("meridian_pve_boss_kngmar");
k_MerSerpHunter		= ResolveString("meridian_pve_boss_serphunt");
k_MerElitePrime		= ResolveString("meridian_pve_boss_eliteprime");
k_MerKnightChamp		= ResolveString("meridian_pve_boss_kngcham");
k_MerSoldierGuard		= ResolveString("meridian_pve_boss_soldguard");
k_MerRemHunter		= ResolveString("meridian_pve_boss_remhunt");
k_MerSolComm		= ResolveString("meridian_pve_boss_soldcom");
k_MerVidKay		= ResolveString("meridian_pve_boss_vidkay");
k_MerPhaeGun		= ResolveString("meridian_pve_boss_phaegun");
k_MerWarden		= ResolveString("meridian_pve_boss_warden");
k_MerTomp		= ResolveString("meridian_pve_boss_tomp");
k_MerKngvis		= ResolveString("meridian_pve_boss_kngvis");
k_MerGhostJockey		= ResolveString("meridian_pve_boss_ghostsquad");
k_MerGruntJockey		= ResolveString("meridian_pve_boss_tomp_guard");
local WarzoneTempleBossNamesAndIds = 
{
	{ "platoonCapn", 			k_MerR1Wraith },
	{ "marshal", 		k_MerKnightMarhal },
	{ "serpentHunter", 		k_MerSerpHunter },
	{ "prime", 				k_MerElitePrime },
	{ "champion",	 		k_MerKnightChamp },
	{ "guard",	 			k_MerSoldierGuard },
	{ "remnantHunter",	 	k_MerRemHunter },
	{ "commando", 			k_MerSolComm },
	{ "vidame", 			k_MerVidKay },
	{ "phaetongunship", 	k_MerPhaeGun },
	{ "warden",				k_MerWarden },
	{ "tomp",			k_MerTomp },
	{ "kngvis",			k_MerKngvis },
	{ "jockey",			k_MerGhostJockey },
	{ "gruntJockey",			k_MerGruntJockey },
}
local WarzoneTempleBossNames = 
{
	k_MerR1Wraith,
	k_MerKnightMarhal,
	k_MerSerpHunter,
	k_MerElitePrime,
	k_MerKnightChamp,
	k_MerSoldierGuard,
	k_MerRemHunter,
	k_MerSolComm,
	k_MerVidKay,
	k_MerPhaeGun,
	k_MerWarden,
	k_TempVanguard2,
	k_MerTomp,
	k_MerGhostJockey,
	k_MerGruntJockey,
	k_MerKngvis	
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