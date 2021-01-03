#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\teams\_teamset;




#precache( "material", "faction_axis" );
#precache( "material", "hudicon_spetsnaz_ctf_flag_carry" );
#precache( "string", "MP_PMC_WIN_MATCH" );
#precache( "string", "MP_PMC_WIN_ROUND" );
#precache( "string", "MP_PMC_MISSION_ACCOMPLISHED" );
#precache( "string", "MP_PMC_ELIMINATED" );
#precache( "string", "MP_PMC_FORFEITED" );
#precache( "string", "MP_PMC_NAME" );

function main()
{
	init( "axis" );

	_teamset::customteam_init();
	precache();
}

function init( team )
{
	_teamset::init();

	game[team] = "axis";
	game["defenders"] = team;

	// head icons
	game["entity_headicon_" + team] = "faction_axis";
	game["headicon_" + team] = "faction_axis";
	
	// battle chatter
	level.teamPrefix[team] = "vox_pm";
	level.teamPostfix[team] = "axis";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_AXIS_SHORT");
	SetDvar("g_TeamColor_" + team, "0.65 0.57 0.41");
	SetDvar("g_ScoresColor_" + team, "0.65 0.57 0.41");
	SetDvar("g_FactionName_" + team, "axis" );
	
	game["strings"][team + "_win"] = &"MP_PMC_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_PMC_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_PMC_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_PMC_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_PMC_FORFEITED";
	game["strings"][team + "_name"] = &"MP_PMC_NAME";
	
	game["music"]["spawn_" + team] = "SPAWN_PMC";
	game["music"]["spawn_short" + team] = "SPAWN_SHORT_PMC";
	game["music"]["victory_" + team] = "VICTORY_PMC";
	game["icons"][team] = "faction_axis";
	game["voice"][team] = "vox_pmc_";
	SetDvar( "scr_" + team, "ussr" );

	level.heli_vo[team]["hit"] = "vox_rus_0_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_axis_2";
	game["carry_flagmodels"][team] = "mp_flag_axis_2_carry";
	game["carry_icon"][team] = "hudicon_spetsnaz_ctf_flag_carry";
}

function precache()
{
	game["set_player_model"]["axis"] = &set_player_model;
}

function set_player_model( bodyType )
{
			self SetCharacterBodyType( 0 );
			self SetCharacterBodyStyle( 0 );
			self SetCharacterHelmetStyle( 0 );
}