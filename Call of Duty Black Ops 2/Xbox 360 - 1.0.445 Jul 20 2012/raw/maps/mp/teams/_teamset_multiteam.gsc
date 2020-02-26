main()
{
	maps\mp\teams\_teamset::init();
	
	init_seals( "allies" );
	init_pla( "axis" );
	init_fbi( "team3" );
	init_pmc( "team4" );

	init_isa( "team5" );
	init_cd( "team6" );
	init_seals( "team7" );
	init_seals( "team8" );

	precache();
}

precache()
{
	mpbody\class_assault_usa_seals::precache();
	mpbody\class_assault_usa_fbi::precache();
	mpbody\class_assault_rus_pmc::precache();
	mpbody\class_assault_chn_pla::precache();
	mpbody\class_assault_isa::precache();
	mpbody\class_assault_cd::precache();
}

// MTEAM: TODO: instead of duplicating all of this data here, get it out of a table
init_seals( team )
{
	game[team] = "seals";
	game["attackers"] = team;

	// head icons
	PreCacheShader( "faction_seals" );
	game["entity_headicon_" + team] = "faction_seals";
	game["headicon_" + team] = "faction_seals";

	// battle chatter
	level.teamPrefix[team] = "vox_st";
	level.teamPostfix[team] = "st6";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_SEALS_SHORT");
	SetDvar("g_TeamColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_FactionName_" + team, "usa_seals" );

	game["strings"][team + "_win"] = &"MP_SEALS_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_SEALS_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_SEALS_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_SEALS_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_SEALS_FORFEITED";
	game["strings"][team + "_name"] = &"MP_SEALS_NAME";

	//Music
	game["music"]["spawn_" + team] = "SPAWN_ST6";
	game["music"]["victory_" + team] = "mus_victory_usa";
	
	game["icons"][team] = "faction_seals";
	game["voice"][team] = "vox_st6_";
	SetDvar( "scr_" + team, "marines" );

	level.heli_vo[team]["hit"] = "vox_ops_2_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_allies_1";
	game["carry_flagmodels"][team] = "mp_flag_allies_1_carry";
	game["carry_icon"][team] = "hudicon_marines_ctf_flag_carry";
}

init_pmc( team )
{
	game[team] = "pmc";
	game["defenders"] = team;

	// head icons
	PrecacheShader( "faction_pmc" );
	game["entity_headicon_" + team] = "faction_pmc";
	game["headicon_" + team] = "faction_pmc";

	// battle chatter
	level.teamPrefix[team] = "vox_pm";
	level.teamPostfix[team] = "pmc";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_PMC_SHORT");
	SetDvar("g_TeamColor_" + team, "0.65 0.57 0.41");		
	SetDvar("g_ScoresColor_" + team, "0.65 0.57 0.41");
	SetDvar("g_FactionName_" + team, "rus_pmc" );

	game["strings"][team + "_win"] = &"MP_PMC_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_PMC_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_PMC_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_PMC_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_PMC_FORFEITED";
	game["strings"][team + "_name"] = &"MP_PMC_NAME";

	// music
	game["music"]["spawn_" + team] = "SPAWN_PMC";
	game["music"]["victory_" + team] = "mus_victory_soviet";
	
	game["icons"][team] = "faction_pmc";
	game["voice"][team] = "vox_pmc_";
	SetDvar( "scr_" + team, "ussr" );

	level.heli_vo[team]["hit"] = "vox_rus_0_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_axis_1";
	game["carry_flagmodels"][team] = "mp_flag_axis_1_carry";
	game["carry_icon"][team] = "hudicon_spetsnaz_ctf_flag_carry";
}

init_pla( team )
{
	game[team] = "pla";
	game["defenders"] = team;

	// head icons
	PrecacheShader( "faction_pla" );
	game["entity_headicon_" + team] = "faction_pla";
	game["headicon_" + team] = "faction_pla";

	// battle chatter
	level.teamPrefix[team] = "vox_ch";
	level.teamPostfix[team] = "pla";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_PLA_SHORT");
	SetDvar("g_TeamColor_" + team, "0.65 0.57 0.41");		
	SetDvar("g_ScoresColor_" + team, "0.65 0.57 0.41");
	SetDvar("g_FactionName_" + team, "chn_pla" );

	game["strings"][team + "_win"] = &"MP_PLA_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_PLA_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_PLA_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_PLA_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_PLA_FORFEITED";
	game["strings"][team + "_name"] = &"MP_PLA_NAME";

	// music
	game["music"]["spawn_" + team] = "SPAWN_PLA";
	game["music"]["victory_" + team] = "mus_victory_soviet";
	
	game["icons"][team] = "faction_pla";
	game["voice"][team] = "vox_pla_";
	SetDvar( "scr_" + team, "ussr" );

	level.heli_vo[team]["hit"] = "vox_rus_0_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_axis_1";
	game["carry_flagmodels"][team] = "mp_flag_axis_1_carry";
	game["carry_icon"][team] = "hudicon_spetsnaz_ctf_flag_carry";
}

init_fbi( team )
{
	game[team] = "fbi";
	game["attackers"] = team;

	// head icons
	PreCacheShader( "faction_fbi" );
	game["entity_headicon_" + team] = "faction_fbi";
	game["headicon_" + team] = "faction_fbi";

	// battle chatter
	level.teamPrefix[team] = "vox_fbi";
	level.teamPostfix[team] = "fbi";

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
	game["flagmodels"][team] = "mp_flag_allies_1";
	game["carry_flagmodels"][team] = "mp_flag_allies_1_carry";
	game["carry_icon"][team] = "hudicon_marines_ctf_flag_carry";
}

init_isa( team )
{
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
	game["flagmodels"][team] = "mp_flag_allies_1";
	game["carry_flagmodels"][team] = "mp_flag_allies_1_carry";
	game["carry_icon"][team] = "hudicon_marines_ctf_flag_carry";
}

init_cd( team )
{
	game[team] = "cd";
	game["attackers"] = team;

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
	game["flagmodels"][team] = "mp_flag_axis_1";
	game["carry_flagmodels"][team] = "mp_flag_axis_1_carry";
	game["carry_icon"][team] = "hudicon_spetsnaz_ctf_flag_carry";
}