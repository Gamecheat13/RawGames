main()
{
	init( "axis" );
	
	maps\mp\teams\_teamset::customteam_init();
	precache();
}

init( team )
{
	maps\mp\teams\_teamset::init();

	game[team] = "cd";
	game["defenders"] = team;

	// head icons
	PreCacheShader( "faction_cd" );
	game["entity_headicon_" + team] = "faction_cd";
	game["headicon_" + team] = "faction_cd";

	// battle chatter
	level.teamPrefix[team] = "vox_pm";
	level.teamPostfix[team] = "pmc";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_CD_SHORT");
	SetDvar("g_TeamColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_FactionName_" + team, "cd" );

	game["strings"][team + "_win"] = &"MP_CD_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_CD_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_CD_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_CD_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_CD_FORFEITED";
	game["strings"][team + "_name"] = &"MP_CD_NAME";

	//Music
	game["music"]["spawn_" + team] = "SPAWN_PMC";
	game["music"]["victory_" + team] = "mus_victory_soviet";
	
	game["icons"][team] = "faction_cd";
	game["voice"][team] = "vox_pmc_";
	SetDvar( "scr_" + team, "ussr" );

	level.heli_vo[team]["hit"] = "vox_ops_2_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_axis_3";
	game["carry_flagmodels"][team] = "mp_flag_axis_3_carry";
	game["carry_icon"][team] = "hudicon_spetsnaz_ctf_flag_carry";
}

precache()
{
	mpbody\class_assault_cd::precache();
	mpbody\class_lmg_cd::precache();
	mpbody\class_shotgun_cd::precache();
	mpbody\class_smg_cd::precache();
	mpbody\class_sniper_cd::precache();
}