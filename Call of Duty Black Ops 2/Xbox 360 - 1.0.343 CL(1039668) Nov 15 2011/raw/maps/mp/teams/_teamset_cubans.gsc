register(teamset)
{
	game["allies_teamset"][teamset] = ::allies;
	game["axis_teamset"][teamset] = ::axis;

	cac_init();
}

level_init()
{
	game["allies"] = "rebels";
	game["axis"] = "tropas";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "cubans";
	game["axis_soldiertype"] = "cubans";

	// head icons
	game["entity_headicon_allies"] = "faction_128_op40";
	game["entity_headicon_axis"] = "faction_128_tropas";
	
	game["headicon_allies"] = "faction_128_op40";
	game["headicon_axis"] = "faction_128_tropas";

	// armor
	game["cac_faction_allies"] = "cub_rebels";
	game["cac_faction_axis"] = "cub_tropas";

	// battle chatter
	level.teamPrefix["allies"] = "vox_ops";
	level.teamPostfix["allies"] = "us";

	level.teamPrefix["axis"] = "vox_cub";
	level.teamPostfix["axis"] = "ja";

	// scoreboard
	SetDvar("g_TeamName_Allies", &"MPUI_REBELS_SHORT");
	SetDvar("g_TeamColor_Allies", "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_Allies", "0.6 0.64 0.69");
	SetDvar("g_FactionName_Allies", "cub_rebels" );

	SetDvar("g_TeamName_Axis", &"MPUI_TROPAS_SHORT");
	SetDvar("g_TeamColor_Axis", "0.52 0.28 0.28");		
	SetDvar("g_ScoresColor_Axis", "0.52 0.28 0.28");
	SetDvar("g_FactionName_Axis", "cub_tropas" );
	
	// game strings
	game["strings"]["allies_win"] = &"MP_REBELS_WIN_MATCH";
	game["strings"]["allies_win_round"] = &"MP_REBELS_WIN_ROUND";
	game["strings"]["allies_mission_accomplished"] = &"MP_REBELS_MISSION_ACCOMPLISHED";
	game["strings"]["allies_eliminated"] = &"MP_REBELS_ELIMINATED";
	game["strings"]["allies_forfeited"] = &"MP_REBELS_FORFEITED";
	game["strings"]["allies_name"] = &"MP_REBELS_NAME";
	
	game["music"]["spawn_allies"] = "SPAWN_OP4";
	game["music"]["victory_allies"] = "mus_victory_usa";
	game["icons"]["allies"] = "faction_128_op40";
	game["colors"]["allies"] = (0,0,0);
	game["voice"]["allies"] = "vox_op4_";
	SetDvar( "scr_allies", "marines" );

	game["strings"]["axis_win"] = &"MP_TROPAS_WIN_MATCH";
	game["strings"]["axis_win_round"] = &"MP_TROPAS_WIN_ROUND";
	game["strings"]["axis_mission_accomplished"] = &"MP_TROPAS_MISSION_ACCOMPLISHED";
	game["strings"]["axis_eliminated"] = &"MP_TROPAS_ELIMINATED";
	game["strings"]["axis_forfeited"] = &"MP_TROPAS_FORFEITED";
	game["strings"]["axis_name"] = &"MP_TROPAS_NAME";
	
	game["music"]["spawn_axis"] = "SPAWN_CUB";
	game["music"]["victory_axis"] = "mus_victory_tropas";
	game["icons"]["axis"] = "faction_128_tropas";
	game["colors"]["axis"] = (0.65,0.57,0.41);
	game["voice"]["axis"] = "vox_cub_";
	SetDvar( "scr_axis", "tropas" );

	PreCacheShader( "faction_128_op40" );
	PreCacheShader( "faction_128_tropas" );

	// helicopter related pilot chatter VO
	level.heli_vo["allies"]["approach"] = "vox_ops_2_kls_attackheli_approach";
	level.heli_vo["allies"]["door"] = "vox_ops_2_kls_attackheli_door";
	level.heli_vo["allies"]["down"] = "vox_ops_2_kls_attackheli_down";
	level.heli_vo["allies"]["hit"] = "vox_ops_2_kls_attackheli_hit";
	level.heli_vo["allies"]["kill"] = "vox_ops_2_kls_attackheli_kill";
	level.heli_vo["allies"]["ready"] = "vox_ops_2_kls_attackheli_ready";
	level.heli_vo["allies"]["shoot"] = "vox_ops_2_kls_attackheli_shoot";
	level.heli_vo["axis"]["approach"] = "vox_cub_0_kls_attackheli_approach";
	level.heli_vo["axis"]["door"] = "vox_cub_0_kls_attackheli_door";
	level.heli_vo["axis"]["down"] = "vox_cub_0_kls_attackheli_down";
	level.heli_vo["axis"]["hit"] = "vox_cub_0_kls_attackheli_hit";
	level.heli_vo["axis"]["kill"] = "vox_cub_0_kls_attackheli_kill";
	level.heli_vo["axis"]["ready"] = "vox_cub_0_kls_attackheli_ready";
	level.heli_vo["axis"]["shoot"] = "vox_cub_0_kls_attackheli_shoot";
}

cac_init()
{
	mpbody\ordnance_disposal_mp::main();
	mpbody\camo_mp::main();
	mpbody\hardened_mp::main();
	mpbody\standard_mp::main();
	mpbody\utility_mp::main();

	mphead\head_armor_mp::main();
	mphead\head_flak_mp::main();
	mphead\head_camo_mp::main();
	mphead\head_standard_mp::main();
	mphead\head_utility_mp::main();
}

allies()
{
	keys = GetArrayKeys( level.cac_functions[ "precache" ] );

	for( i = 0; i < keys.size; i++ )
	{
		content_type = keys[i];
		[[level.cac_functions[ "precache" ][content_type]]]( "cub_rebels" );
	}
}

axis()
{
	keys = GetArrayKeys( level.cac_functions[ "precache" ] );

	for( i = 0; i < keys.size; i++ )
	{
		content_type = keys[i];
		[[level.cac_functions[ "precache" ][content_type]]]( "cub_tropas" );
	}
}