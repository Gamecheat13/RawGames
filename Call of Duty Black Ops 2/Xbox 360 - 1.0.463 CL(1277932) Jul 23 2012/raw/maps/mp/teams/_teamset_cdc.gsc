register()
{
	game["teamset"] = [];

	game["teamset"]["cdc"] = ::cdc;
}

level_init()
{
	game["allies"] = "cdc";
	game["axis"] = "zombies";
	game["team3"] = "cia";
	
	//T6_TODO
	/*
	game["attackers"] = "allies";
	game["defenders"] = "axis";
	game["soldiertypeset"] = "seals";

	// head icons
	game["entity_headicon_allies"] = "faction_128_seals";
	game["entity_headicon_axis"] = "faction_128_pmc";
	game["entity_headicon_team3"] = "faction_128_pmc";

	game["headicon_allies"] = "faction_128_seals";
	game["headicon_axis"] = "faction_128_pmc";
	game["headicon_team3"] = "faction_128_pmc";

	// battle chatter
	level.teamPrefix["allies"] = "vox_st6";
	level.teamPostfix["allies"] = "st6";

	level.teamPrefix["axis"] = "vox_pmc";
	level.teamPostfix["axis"] = "pmc";

	level.teamPrefix["team3"] = "vox_pmc";
	level.teamPostfix["team3"] = "pmc";
	*/


	// scoreboard
	SetDvar("g_TeamName_Allies", &"ZMUI_CDC_SHORT");
	// T6_TODO:
	/*
	SetDvar("g_TeamColor_Allies", "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_Allies", "0.6 0.64 0.69");
	SetDvar("g_FactionName_Allies", "usa_seals" );
	*/

	SetDvar("g_TeamName_Three", &"ZMUI_CIA_SHORT");
	// T6_TODO:
	/*
	SetDvar("g_TeamColor_Axis", "0.65 0.57 0.41");		
	SetDvar("g_ScoresColor_Axis", "0.65 0.57 0.41");
	SetDvar("g_FactionName_Axis", "rus_pmc" );
	*/

	// game strings
	game["strings"]["allies_win"] = &"ZM_CDC_WIN_MATCH";
	game["strings"]["allies_win_round"] = &"ZM_CDC_WIN_ROUND";
	game["strings"]["allies_mission_accomplished"] = &"ZM_CDC_MISSION_ACCOMPLISHED";
	game["strings"]["allies_eliminated"] = &"ZM_CDC_ELIMINATED";
	game["strings"]["allies_forfeited"] = &"ZM_CDC_FORFEITED";
	game["strings"]["allies_name"] = &"ZM_CDC_NAME";
	
	game["music"]["spawn_allies"] = "SPAWN_OPS";
	game["music"]["victory_allies"] = "mus_victory_usa";
	game["icons"]["allies"] = "faction_cdc";
	game["colors"]["allies"] = (0,0,0);
	game["voice"]["allies"] = "vox_st6_";
	SetDvar( "scr_allies", "marines" );

	// T6_TODO:
	/*
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
	*/

	game["strings"]["team3_win"] = &"ZM_CIA_WIN_MATCH";
	game["strings"]["team3_win_round"] = &"ZM_CIA_WIN_ROUND";
	game["strings"]["team3_mission_accomplished"] = &"ZM_CIA_MISSION_ACCOMPLISHED";
	game["strings"]["team3_eliminated"] = &"ZM_CIA_ELIMINATED";
	game["strings"]["team3_forfeited"] = &"ZM_CIA_FORFEITED";
	game["strings"]["team3_name"] = &"ZM_CIA_NAME";
	
	game["music"]["spawn_team3"] = "SPAWN_RUS";
	game["music"]["victory_team3"] = "mus_victory_soviet";
	game["icons"]["team3"] = "faction_cia";
	game["colors"]["team3"] = (0.65,0.57,0.41);
	game["voice"]["team3"] = "vox_pmc_";

	// T6_TODO:
	/*
	maps\mp\teams\_teamset::customteam_init();
	

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
	level.heli_vo["team3"]["approach"] = "vox_rus_0_kls_attackheli_approach";
	level.heli_vo["team3"]["door"] = "vox_rus_0_kls_attackheli_door";
	level.heli_vo["team3"]["down"] = "vox_rus_0_kls_attackheli_down";
	level.heli_vo["team3"]["hit"] = "vox_rus_0_kls_attackheli_hit";
	level.heli_vo["team3"]["kill"] = "vox_rus_0_kls_attackheli_kill";
	level.heli_vo["team3"]["ready"] = "vox_rus_0_kls_attackheli_ready";
	level.heli_vo["team3"]["shoot"] = "vox_rus_0_kls_attackheli_shoot";

	// flag assets
	if ( !isdefined(game["flagmodels"]) )
		game["flagmodels"] = [];
	if ( !isdefined(game["carry_flagmodels"]) )
		game["carry_flagmodels"] = [];
	if ( !isdefined(game["carry_icon"]) )
		game["carry_icon"] = [];

	game["flagmodels"]["allies"] = "mp_flag_allies_1";
	game["carry_flagmodels"]["allies"] = "mp_flag_allies_1_carry";
	game["carry_icon"]["allies"] = "hudicon_marines_ctf_flag_carry";
	game["flagmodels"]["axis"] = "mp_flag_axis_1";
	game["carry_flagmodels"]["axis"] = "mp_flag_axis_1_carry";
	game["carry_icon"]["axis"] = "hudicon_spetsnaz_ctf_flag_carry";
	game["flagmodels"]["team3"] = "mp_flag_axis_1";
	game["carry_flagmodels"]["team3"] = "mp_flag_axis_1_carry";
	game["carry_icon"]["team3"] = "hudicon_spetsnaz_ctf_flag_carry";
	game["flagmodels"]["neutral"] = "mp_flag_neutral";

	*/
}

cdc()
{
	allies();
	three();
}

allies()
{
	//TODO: will see if there are some team assets need to be precached here
	/*
	mpbody\class_assault_usa_seals::precache();
	mpbody\class_lmg_usa_seals::precache();
	mpbody\class_shotgun_usa_seals::precache();
	mpbody\class_smg_usa_seals::precache();
	mpbody\class_sniper_usa_seals::precache();
	*/
}

three()
{
	
	//TODO: will see if there are some team assets need to be precached here
	/*
	mpbody\class_assault_rus_pmc::precache();
	mpbody\class_lmg_rus_pmc::precache();
	mpbody\class_shotgun_rus_pmc::precache();
	mpbody\class_smg_rus_pmc::precache();
	mpbody\class_sniper_rus_pmc::precache();
	*/
}