main()
{
	init( "allies" );
	
	maps\mp\teams\_teamset::customteam_init();
	precache();
}

init( team )
{
	maps\mp\teams\_teamset::init();

	game[team] = "fbi";
	game["attackers"] = team;

	// head icons
	PreCacheShader( "faction_fbi" );
	game["entity_headicon_" + team] = "faction_fbi";
	game["headicon_" + team] = "faction_fbi";

	// battle chatter
	level.teamPrefix[team] = "vox_hr";
	level.teamPostfix[team] = "hrt";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_FBI_SHORT");
	SetDvar("g_TeamColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_FactionName_" + team, "usa_fbi" );

	game["strings"][team + "_win"] = &"MP_FBI_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_FBI_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_FBI_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_FBI_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_FBI_FORFEITED";
	game["strings"][team + "_name"] = &"MP_FBI_NAME";

	//Music
	game["music"]["spawn_" + team] = "SPAWN_FBI";
	game["music"]["victory_" + team] = "mus_victory_usa";
	
	game["icons"][team] = "faction_fbi";
	game["voice"][team] = "vox_fbi_";
	SetDvar( "scr_" + team, "marines" );

	level.heli_vo[team]["hit"] = "vox_ops_2_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_allies_2";
	game["carry_flagmodels"][team] = "mp_flag_allies_2_carry";
	game["carry_icon"][team] = "hudicon_marines_ctf_flag_carry";
}

precache()
{
	mpbody\class_assault_usa_fbi::precache();
	mpbody\class_lmg_usa_fbi::precache();
	mpbody\class_shotgun_usa_fbi::precache();
	mpbody\class_smg_usa_fbi::precache();
	mpbody\class_sniper_usa_fbi::precache();
}