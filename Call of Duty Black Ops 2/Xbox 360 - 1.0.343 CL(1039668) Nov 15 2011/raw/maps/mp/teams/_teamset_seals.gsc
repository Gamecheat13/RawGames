register()
{
	game["allies_teamset"] = [];
	game["axis_teamset"] = [];

	game["allies_teamset"]["seals"] = ::allies;
	game["axis_teamset"]["seals"] = ::axis;
}

level_init()
{
	game["allies"] = "seals";
	game["axis"] = "pmc";
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["allies_soldiertype"] = "seals";
	game["axis_soldiertype"] = "seals";

	// head icons
	game["entity_headicon_allies"] = "faction_128_seals";
	game["entity_headicon_axis"] = "faction_128_pmc";

	game["headicon_allies"] = "faction_128_seals";
	game["headicon_axis"] = "faction_128_pmc";

	// battle chatter
	level.teamPrefix["allies"] = "vox_st6";
	level.teamPostfix["allies"] = "st6";

	level.teamPrefix["axis"] = "vox_pmc";
	level.teamPostfix["axis"] = "pmc";

	// scoreboard
	SetDvar("g_TeamName_Allies", &"MPUI_SEALS_SHORT");
	SetDvar("g_TeamColor_Allies", "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_Allies", "0.6 0.64 0.69");
	SetDvar("g_FactionName_Allies", "usa_seals" );

	SetDvar("g_TeamName_Axis", &"MPUI_PMC_SHORT");
	SetDvar("g_TeamColor_Axis", "0.65 0.57 0.41");		
	SetDvar("g_ScoresColor_Axis", "0.65 0.57 0.41");
	SetDvar("g_FactionName_Axis", "rus_pmc" );
	
	// game strings
	game["strings"]["allies_win"] = &"MP_SEALS_WIN_MATCH";
	game["strings"]["allies_win_round"] = &"MP_SEALS_WIN_ROUND";
	game["strings"]["allies_mission_accomplished"] = &"MP_SEALS_MISSION_ACCOMPLISHED";
	game["strings"]["allies_eliminated"] = &"MP_SEALS_ELIMINATED";
	game["strings"]["allies_forfeited"] = &"MP_SEALS_FORFEITED";
	game["strings"]["allies_name"] = &"MP_SEALS_NAME";
	
	game["music"]["spawn_allies"] = "SPAWN_OPS";
	game["music"]["victory_allies"] = "mus_victory_usa";
	game["icons"]["allies"] = "faction_128_seals";
	game["colors"]["allies"] = (0,0,0);
	game["voice"]["allies"] = "vox_st6_";
	SetDvar( "scr_allies", "marines" );

	game["strings"]["axis_win"] = &"MP_PMC_WIN_MATCH";
	game["strings"]["axis_win_round"] = &"MP_PMC_WIN_ROUND";
	game["strings"]["axis_mission_accomplished"] = &"MP_PMC_MISSION_ACCOMPLISHED";
	game["strings"]["axis_eliminated"] = &"MP_PMC_ELIMINATED";
	game["strings"]["axis_forfeited"] = &"MP_PMC_FORFEITED";
	game["strings"]["axis_name"] = &"MP_PMC_NAME";
	
	game["music"]["spawn_axis"] = "SPAWN_RUS";
	game["music"]["victory_axis"] = "mus_victory_soviet";
	game["icons"]["axis"] = "faction_128_pmc";
	game["colors"]["axis"] = (0.65,0.57,0.41);
	game["voice"]["axis"] = "vox_pmc_";
	SetDvar( "scr_axis", "ussr" );

	PreCacheShader( "faction_128_seals" );
	precacheShader( "faction_128_pmc" );
	
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

allies()
{
	mpbody\class_assault_usa_seals::precache();
	mpbody\class_lmg_usa_seals::precache();
	mpbody\class_shotgun_usa_seals::precache();
	mpbody\class_smg_usa_seals::precache();
	mpbody\class_sniper_usa_seals::precache();
}

axis()
{
	mpbody\class_assault_rus_pmc::precache();
	mpbody\class_lmg_rus_pmc::precache();
	mpbody\class_shotgun_rus_pmc::precache();
	mpbody\class_smg_rus_pmc::precache();
	mpbody\class_sniper_rus_pmc::precache();
}