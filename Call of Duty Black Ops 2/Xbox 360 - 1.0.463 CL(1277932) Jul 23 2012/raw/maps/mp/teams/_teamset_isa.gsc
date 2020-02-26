main()
{
	init( "allies" );
	
	maps\mp\teams\_teamset::customteam_init();
	precache();
}

init( team )
{
	maps\mp\teams\_teamset::init();

	game[team] = "isa";
	game["attackers"] = team;

	// head icons
	PreCacheShader( "faction_isa" );
	game["entity_headicon_" + team] = "faction_isa";
	game["headicon_" + team] = "faction_isa";

	// battle chatter
	level.teamPrefix[team] = "vox_st";
	level.teamPostfix[team] = "st6";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_ISA_SHORT");
	SetDvar("g_TeamColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_FactionName_" + team, "isa" );

	game["strings"][team + "_win"] = &"MP_ISA_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_ISA_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_ISA_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_ISA_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_ISA_FORFEITED";
	game["strings"][team + "_name"] = &"MP_ISA_NAME";

	//Music
	game["music"]["spawn_" + team] = "SPAWN_ST6";
	game["music"]["victory_" + team] = "mus_victory_usa";
	
	game["icons"][team] = "faction_isa";
	game["voice"][team] = "vox_st6_";
	SetDvar( "scr_" + team, "marines" );

	level.heli_vo[team]["hit"] = "vox_ops_2_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_allies_3";
	game["carry_flagmodels"][team] = "mp_flag_allies_3_carry";
	game["carry_icon"][team] = "hudicon_marines_ctf_flag_carry";
}

precache()
{
	mpbody\class_assault_isa::precache();
	mpbody\class_lmg_isa::precache();
	mpbody\class_shotgun_isa::precache();
	mpbody\class_smg_isa::precache();
	mpbody\class_sniper_isa::precache();
}