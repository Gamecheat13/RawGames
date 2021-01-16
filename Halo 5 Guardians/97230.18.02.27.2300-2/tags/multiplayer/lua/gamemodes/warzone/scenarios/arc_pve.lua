
__OnWarzoneIncursionIntro = Delegate:new();
onWarzoneIncursionIntro = root:AddCallback(
	__OnWarzoneIncursionIntro
	);
warzoneIncursionIntroResponse = onWarzoneIncursionIntro:Target(TargetAllPlayers):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_firefightintro2', 
		Sound2 = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionintro2',
	}):Response(
	{
		Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionintro3',
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
		name = "soldierCaveBoss",
		label = 'pve_att_caves_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_soldier_enforcers_mineshaft_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_killed_teammessage',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'arc_boss_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompleteplayer',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_soldier_killed_teammessage',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldiercompletefriendly',
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcsoldierteammateskilled',
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "elitesRoundOne",
		label = 'arc_right_meadow_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric2',
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric4',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_elite_primes_grotto_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'urban_boss_tunnel_elite_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompleteplayer',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_tunnel_elite_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanelitecompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbaneliteteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "elitesStealthRound1",
		label = 'pve_r1_invis_elites_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossgenericexplored',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_covert_majors_eastarmory_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_camomajor_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'ice_boss_camomajor_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamocompleteplayer',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_camomajor_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamocompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszcamoteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "soldiersRound2",
		label = 'boss_soldier_officer_beach',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric3',
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric5',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_soldier_guards_commtower_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_south_soldier_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'ring_boss_south_soldier_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompleteplayer',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_south_soldier_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldiercompletefriendly'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringsoldierteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "elitesSnipersRoundTwo",
		label = 'pve_r2_w1_elite_boss',
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
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionbossgeneric',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_elite_ultras_digsite_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_general_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'ring_boss_beach_general_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompleteplayer',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_general_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralcompletefriendly'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringgeneralteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "ghostsRound2",
		label = 'arc_boss_center_ghosts',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_ghost_marauders_midyard_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_tunnel_ghosts_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'ring_boss_tunnel_ghosts_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompleteplayer',
					ImpulseEvent = 'impulse_boss_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_tunnel_ghosts_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostcompletefriendly',
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringghostteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "huntersRound3",
		label = 'arc_dock_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_hunterbossgenericspawned',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_serpent_hunters_cranepit_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_kill_teamfeed_01',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'ice_boss_hunters_att_kill_fanfare_01',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhuntercompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_hunters_att_kill_teamfeed_01',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterprogressfriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszhunterteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "wraithRound3",
		label = 'pve_r3_wraith_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithdiscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_wraith_rok_blueyard_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_wraith_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'ring_boss_beach_wraith_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithcompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_beach_wraith_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithcompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringwraithteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "knightsRound3",
		label = 'boss_knight_duo',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric4',
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric5',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_knight_marshal_redyard_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_killed_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'arc_boss_knight_bw_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_knight_bw_killed_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatcompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightbatteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "bansheessRound4",
		label = 'pve_r4_banshee_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric',
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheediscoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_banshee_raiders_cranepit_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_center_banshees_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'ring_boss_center_banshees_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheecompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_center_banshees_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheecompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringbansheeteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "vtolRound4",
		label = 'pve_r4_vtol_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_recon_pilots_cranepit_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_vtol_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'urban_boss_highway_vtol_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_vtol_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolcompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanvtolteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "hbBossRound4",
		label = 'pve_r4_promethean_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric3',
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric2',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_knight_bannermen_homebase_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_knights_kill_teamfeed_01',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
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
					FanfareText = 'ice_boss_stage_knights_kill_fanfare_01',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagoncompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_stage_knights_kill_teamfeed_01',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagoncompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_proximityboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszbattlewagonteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
{
		name = "bossWaveCovR5W51Ghost",
		label = 'pve_r5_w1_ghost',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_covenant_wave1_redyard_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_ghosts_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
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
					FanfareText = 'urban_boss_highway_ghosts_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanghostcompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_highway_ghosts_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossgenericprogressfriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossgenericteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
{
		name = "bossWaveCov5R5W51Elites",
		label = 'pve_r5_w1_elite',
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
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_killed_teammessage',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
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
					FanfareText = 'arc_boss_ranger_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_ranger_killed_teammessage',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcrangerscompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossgenericteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},	
{
		name = "bossWaveCovR5W2Hunters",
		label = 'pve_r5_wave_2',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenants10sgeneric',
					},
					{
						Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_hunterspawn'
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosscovenant10sgeneric3',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_covenant_wave2_redbase_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_fort_hunters_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
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
					FanfareText = 'ring_boss_fort_hunters_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthunterscompleteplayer',
					ImpulseEvent = 'impulse_mythic_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ring_boss_fort_hunters_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossringulthuntersprogressfriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossgenericteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "bossR5Prom5W1",
		label = 'pve_r5_w1_knight_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric3',
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric5',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_promethean_wave1_digsite_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_knight_kill_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
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
					FanfareText = 'urban_boss_corrupt_knight_kill_fanfare_01',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'urban_boss_corrupt_knight_kill_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanknightcompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossgenericteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "bossR5Prom5Wave1",
		label = 'pve_r5_w2_warden',
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
			progressFriendlyResponse = 
			{	
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_warden_killed_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_warden_killed_teamfeed',
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwardenteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "bossWaveCovR5",
		label = 'pve_r5_w3_warden',
		responses = 
		{
			countdownResponse = 	
			{  
				[10] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric',
					},
					{
						Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_wardenspawn'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1discoveredplayer',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_promethean_wave2_blueyard_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_warden_killed_teamfeed',
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
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completeplayer',
					ImpulseEvent = 'impulse_mythic_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death',
				Fanfare = FanfareDefinitions.KillFeed,
				FanfareText = 'arc_boss_warden_killed_teamfeed',
			},
			{	
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwarden1completefriendly'
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossurbanwardenteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "bossR5AltProm1W1",
		label = 'pve_r5_alt_pro_w1_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric3',
					},
				},
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric5',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_promethean2_wave1_garage_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_teamfeed_01',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
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
					FanfareText = 'ice_boss_officer_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'ice_boss_officer_kill_teamfeed_01',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldiercompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszsoldierteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},	
{
		name = "bossR5AltProm5Wave2Knights",
		label = 'pve_r5_alt_pro_w2_knight_boss',
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
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_crates_knight_killed_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
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
					FanfareText = 'arc_boss_crates_knight_kill_fanfare',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompleteplayer',
					ImpulseEvent = 'impulse_legendary_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_crates_knight_killed_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossarcknightcomcompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossgenericteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
	{
		name = "bossR5AltProm5Wave2",
		label = 'pve_r5_alt_pro_w2_warden_boss',
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
						Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bosspromethean10sgeneric3',
					},
					{
						Sound = 'multiplayer\audio\music\130_mus_mp_sustain\music_mp_warzone_pve_mythicboss_wardenspawn'
					},
				},     
				[0] = 
				{
					{
						Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_incursionbossmythic1',
						Fanfare = FanfareDefinitions.KillFeed,
						FanfareText = 'arc_pve_boss_promethean2_wave2_cranepit_spawned',
					},
				},
			},
			progressFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_warden_killed_teamfeed',
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
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
					Sound = 'multiplayer\audio\wzcmndrsustain\wzcmndrsustain_warzonepve_MythicTakedownGeneric',
					ImpulseEvent = 'impulse_mythic_takedown'
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			completeFriendlyResponse = 
			{
				{
					Fanfare = FanfareDefinitions.KillFeed,
					FanfareText = 'arc_boss_warden_killed_teamfeed',
					Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossszwardencompletefriendly'	
				},
				{
					Sound = 'multiplayer\audio\music\130_mus_mp_warzone\music_mp_warzone_ultraboss_death'
				}
			},
			killedTeammatesResponse =
			{
				Sound = 'multiplayer\audio\warzonecommander\warzonecommander_warzone_bossgenericteammateskilled'
			},
		},
		killedTeammatesCount = 3,
	},
};
applyDefaultMinibossResponses(minibossDefinitions);
k_ArcOfficerAtt		= ResolveString("att_soldier_officer");
k_ArcOfficerDef		= ResolveString("def_soldier_officer");
k_UrbElitePrimeBlue 	= ResolveString("urban_boss_blue_elite_name");
k_UrbElitePrimeRed 		= ResolveString("urban_boss_red_elite_name");
k_SnowCovertMajor	= ResolveString("ice_pit_boss_camomajor");
k_RingGhostRidge	= ResolveString("ring_boss_tunnel_ghosts_01");
k_RingGhostWater	= ResolveString("ring_boss_beach_ghosts_01");
k_RingSoldierTunn	= ResolveString("ring_boss_north_soldier_01");
k_RingSoldierChasm	= ResolveString("ring_boss_south_soldier_01");
k_RingElitePlat 	= ResolveString("ring_boss_beach_general_01");
k_RingEliteCrag 	= ResolveString("ring_boss_crags_general_01");
k_SnowHunterAtt1	= ResolveString("ice_boss_hunter_att_01");
k_SnowHunterAtt2 	= ResolveString("ice_boss_hunter_att_02");
k_ArcKnightAttCave	= ResolveString("arc_boss_att_knight_01");
k_RingTankBeach		= ResolveString("ring_boss_beach_wraith_01");
k_RingBansheeRidge	= ResolveString("ring_boss_other_banshees_01");
k_RingBansheeWater 	= ResolveString("ring_boss_center_banshees_01");
k_SnowBannerman		= ResolveString("ice_boss_stage_knight_01");
k_SnowBannerman2		= ResolveString("ice_boss_stage_knights_name");
k_UrbReconPlaza			= ResolveString("urban_boss_vtol_greenbelt_1");
k_UrbReconComm			= ResolveString("urban_boss_vtol_highway_1")
k_SnowCommandoAtt	= ResolveString("ice_boss_officer_def_name");
k_SnowCommandoDef	= ResolveString("ice_boss_officer_att_name");
k_ArcKnightDigAtt01 = ResolveString("arc_boss_att_knight2_name");
k_ArcKnightDigDef01 = ResolveString("arc_boss_def_knight2_name");
k_ArcWarden			= ResolveString("arc_boss_warden");
k_ArcRangerAtt 		= ResolveString("arc_boss_ranger_att_name");
k_ArcRangerDef 		= ResolveString("arc_boss_ranger_att_name");
k_UrbGhostJockBlue		= ResolveString("urban_boss_hw_ghosts_1");
k_RingHunterSpire1 	= ResolveString("ring_boss_fortress_hunter_01");
k_RingHunterSpire2	= ResolveString("ring_boss_fortress_hunter_02");
k_UrbKnightPlaza		= ResolveString("urban_boss_knight_corrupt_1");
k_UrbKnightComm			= ResolveString("urban_boss_knight_hallowed_1");
local WarzoneArcBossNamesAndIds = 
{
	{ "enforcer", 			k_ArcOfficerAtt },
	{ "enforcer", 			k_ArcOfficerDef },
	{ "prime", 				k_UrbElitePrimeBlue },
	{ "prime", 				k_UrbElitePrimeRed },
	{ "covertMajor",	 	k_SnowCovertMajor },
	{ "marauder", 			k_RingGhostRidge },
	{ "marauder", 			k_RingGhostWater },
	{ "guard",	 			k_RingSoldierTunn },
	{ "guard",				k_RingSoldierChasm },
	{ "ultra", 				k_RingElitePlat },
	{ "ultra", 				k_RingEliteCrag },
	{ "marshal", 			k_ArcKnightAttCave },
	{ "serpentHunter", 		k_SnowHunterAtt1 },
	{ "serpentHunter",		k_SnowHunterAtt2 },
	{ "rok",			 	k_RingTankBeach },
	{ "raider", 			k_RingBansheeRidge },
	{ "raider", 			k_RingBansheeWater },
	{ "bannerman", 			k_SnowBannerman },
	{ "bannerman", 			k_SnowBannerman2 },
	{ "recon",				k_UrbReconPlaza },
	{ "recon",				k_UrbReconComm },
	{ "commando", 			k_SnowCommandoAtt },
	{ "commando",		 	k_SnowCommandoDef },
	{ "dignitary", 			k_ArcKnightDigAtt01 },
	{ "dignitary", 			k_ArcKnightDigDef01 },
	{ "warden",				k_ArcWarden },
	{ "rangerCommander", 	k_ArcRangerAtt },
	{ "rangerCommander", 	k_ArcRangerDef },	
	{ "jockey",		 		k_UrbGhostJockBlue },
	{ "elder", 				k_RingHunterSpire1 },
	{ "elder", 				k_RingHunterSpire2 },
	{ "noble",				k_UrbKnightPlaza },
	{ "noble", 				k_UrbKnightComm },
}
local WarzoneArcBossNames = 
{
	k_ArcOfficerAtt,
	k_ArcOfficerDef,
	k_UrbElitePrimeBlue,
	k_UrbElitePrimeRed,
	k_SnowCovertMajor,
	k_RingGhostRidge,
	k_RingGhostWater,
	k_RingSoldierTunn,
	k_RingSoldierChasm,
	k_RingElitePlat,
	k_RingEliteCrag,
	k_ArcKnightAttCave,
	k_SnowHunterAtt1,
	k_SnowHunterAtt2,
	k_RingTankBeach,
	k_RingBansheeRidge,
	k_RingBansheeWater,
	k_SnowBannerman,
	k_SnowBannerman2,
	k_UrbReconPlaza,	
	k_UrbReconComm,
	k_SnowCommandoAtt,
	k_SnowCommandoDef,
	k_ArcWarden,
	k_ArcKnightDigAtt01,
	k_ArcKnightDigDef01,	
	k_ArcRangerAtt,
	k_ArcRangerDef,
	k_UrbGhostJockBlue,
	k_RingHunterSpire1,
	k_RingHunterSpire2,
	k_UrbKnightPlaza,	
	k_UrbKnightComm
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