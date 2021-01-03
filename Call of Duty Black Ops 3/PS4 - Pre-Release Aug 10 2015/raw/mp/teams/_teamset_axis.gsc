#using scripts\codescripts\struct;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\teams\_teamset;



#precache( "material", "faction_axis" );
#precache( "string", "MP_CDP_WIN_MATCH" );
#precache( "string", "MP_CDP_WIN_ROUND" );
#precache( "string", "MP_CDP_MISSION_ACCOMPLISHED" );
#precache( "string", "MP_CDP_ELIMINATED" );
#precache( "string", "MP_CDP_FORFEITED" );
#precache( "string", "MP_CDP_NAME" );

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
	//SetDvar("g_TeamColor_" + team, "0.65 0.57 0.41");
	//SetDvar("g_ScoresColor_" + team, "0.65 0.57 0.41");
	SetDvar("g_FactionName_" + team, "axis" );
	
	game["strings"][team + "_win"] = &"MP_CDP_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_CDP_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_CDP_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_CDP_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_CDP_FORFEITED";
	game["strings"][team + "_name"] = &"MP_CDP_NAME";
	
	game["music"]["spawn_" + team] = "SPAWN_PMC";
	game["music"]["spawn_short" + team] = "SPAWN_SHORT_PMC";
	game["music"]["victory_" + team] = "VICTORY_PMC";
	game["icons"][team] = "faction_axis";
	game["voice"][team] = "vox_pmc_";
	SetDvar( "scr_" + team, "ussr" );

	level.heli_vo[team]["hit"] = "vox_rus_0_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "p7_mp_flag_axis";
	game["carry_flagmodels"][team] = "p7_mp_flag_axis_carry";
	game["flagmodels"]["neutral"] = "p7_mp_flag_neutral";
}

function precache()
{
}