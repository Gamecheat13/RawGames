register(teamset)
{
	game["allies_teamset"][teamset] = ::allies;
	game["axis_teamset"][teamset] = ::axis;

	cac_init();
}

level_init()
{
	game["allies"] = "specops";
	game["axis"] = "russian";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "winterspecops";
	game["axis_soldiertype"] = "winterspecops";

	// head icons
	game["entity_headicon_allies"] = "faction_128_specops";
	game["entity_headicon_axis"] = "faction_128_spetsnaz";

	game["headicon_allies"] = "faction_128_specops";
	game["headicon_axis"] = "faction_128_spetsnaz";

	// armor
	game["cac_faction_allies"] = "usa_ciawin";
	game["cac_faction_axis"] = "rus_spetwin";

	// battle chatter
	level.teamPrefix["allies"] = "vox_ops";
	level.teamPostfix["allies"] = "us";

	level.teamPrefix["axis"] = "vox_rus";
	level.teamPostfix["axis"] = "ru";

	// scoreboard
	SetDvar("g_TeamName_Allies", &"MPUI_SPECOPS_SHORT");
	SetDvar("g_TeamColor_Allies", "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_Allies", "0.6 0.64 0.69");
	SetDvar("g_FactionName_Allies", "usa_ciawin" );

	SetDvar("g_TeamName_Axis", &"MPUI_RUSSIAN_SHORT");
	SetDvar("g_TeamColor_Axis", "0.65 0.57 0.41");		
	SetDvar("g_ScoresColor_Axis", "0.65 0.57 0.41");
	SetDvar("g_FactionName_Axis", "rus_spetwin" );
	
	// game strings
	game["strings"]["allies_win"] = &"MP_SPECOPS_WIN_MATCH";
	game["strings"]["allies_win_round"] = &"MP_SPECOPS_WIN_ROUND";
	game["strings"]["allies_mission_accomplished"] = &"MP_SPECOPS_MISSION_ACCOMPLISHED";
	game["strings"]["allies_eliminated"] = &"MP_SPECOPS_ELIMINATED";
	game["strings"]["allies_forfeited"] = &"MP_SPECOPS_FORFEITED";
	game["strings"]["allies_name"] = &"MP_SPECOPS_NAME";
	
	game["music"]["spawn_allies"] = "SPAWN_OPS";
	game["music"]["victory_allies"] = "mus_victory_usa";
	game["icons"]["allies"] = "faction_128_specops";
	game["colors"]["allies"] = (0,0,0);
	game["voice"]["allies"] = "vox_ops_";
	SetDvar( "scr_allies", "marines" );

	game["strings"]["axis_win"] = &"MP_RUSSIAN_WIN_MATCH";
	game["strings"]["axis_win_round"] = &"MP_RUSSIAN_WIN_ROUND";
	game["strings"]["axis_mission_accomplished"] = &"MP_RUSSIAN_MISSION_ACCOMPLISHED";
	game["strings"]["axis_eliminated"] = &"MP_RUSSIAN_ELIMINATED";
	game["strings"]["axis_forfeited"] = &"MP_RUSSIAN_FORFEITED";
	game["strings"]["axis_name"] = &"MP_RUSSIAN_NAME";
	
	game["music"]["spawn_axis"] = "SPAWN_RUS";
	game["music"]["victory_axis"] = "mus_victory_soviet";
	game["icons"]["axis"] = "faction_128_spetsnaz";
	game["colors"]["axis"] = (0.65,0.57,0.41);
	game["voice"]["axis"] = "vox_rus_";
	SetDvar( "scr_axis", "ussr" );

	PreCacheShader( "faction_128_specops" );
	precacheShader( "faction_128_spetsnaz" );

	// helicopter related pilot chatter VO
	level.heli_vo["allies"]["approach"] = "vox_ops_2_kls_attackheli_approach";
	level.heli_vo["allies"]["door"] = "vox_ops_2_kls_attackheli_door";
	level.heli_vo["allies"]["down"] = "vox_ops_2_kls_attackheli_down";
	level.heli_vo["allies"]["hit"] = "vox_ops_2_kls_attackheli_hit";
	level.heli_vo["allies"]["kill"] = "vox_ops_2_kls_attackheli_kill";
	level.heli_vo["allies"]["ready"] = "vox_ops_2_kls_attackheli_ready";
	level.heli_vo["allies"]["shoot"] = "vox_ops_2_kls_attackheli_shoot";
	level.heli_vo["axis"]["approach"] = "vox_rus_0_kls_attackheli_approach";
	level.heli_vo["axis"]["door"] = "vox_rus_0_kls_attackheli_door";
	level.heli_vo["axis"]["down"] = "vox_rus_0_kls_attackheli_down";
	level.heli_vo["axis"]["hit"] = "vox_rus_0_kls_attackheli_hit";
	level.heli_vo["axis"]["kill"] = "vox_rus_0_kls_attackheli_kill";
	level.heli_vo["axis"]["ready"] = "vox_rus_0_kls_attackheli_ready";
	level.heli_vo["axis"]["shoot"] = "vox_rus_0_kls_attackheli_shoot";
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
		[[level.cac_functions[ "precache" ][content_type]]]( "usa_ciawin" );
	}
}

axis()
{
	keys = GetArrayKeys( level.cac_functions[ "precache" ] );

	for( i = 0; i < keys.size; i++ )
	{
		content_type = keys[i];
		[[level.cac_functions[ "precache" ][content_type]]]( "rus_spetwin" );
	}
}

