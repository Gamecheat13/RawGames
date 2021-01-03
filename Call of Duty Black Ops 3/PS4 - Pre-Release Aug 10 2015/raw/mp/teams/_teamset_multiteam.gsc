#using scripts\codescripts\struct;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\teams\_teamset;
#using scripts\mp\teams\_teamset_axis;
#using scripts\mp\teams\_teamset_allies;




#precache( "material", "faction_allies" );
#precache( "material", "faction_axis" );
#precache( "string", "MP_SEALS_WIN_MATCH" );
#precache( "string", "MP_SEALS_WIN_ROUND" );
#precache( "string", "MP_SEALS_MISSION_ACCOMPLISHED" );
#precache( "string", "MP_SEALS_ELIMINATED" );
#precache( "string", "MP_SEALS_FORFEITED" );
#precache( "string", "MP_SEALS_NAME" );
#precache( "string", "MP_PMC_WIN_MATCH" );
#precache( "string", "MP_PMC_WIN_ROUND" );
#precache( "string", "MP_PMC_MISSION_ACCOMPLISHED" );
#precache( "string", "MP_PMC_ELIMINATED" );
#precache( "string", "MP_PMC_FORFEITED" );
#precache( "string", "MP_PMC_NAME" );

function main()
{
	_teamset::init();
	
	toggle = 0;
	
	foreach ( team in level.teams )
	{
		if ( toggle % 2 )
		{
			init_axis( team );
		}
		else
		{
			init_allies( team );
		}
		toggle++;
	}
	
	precache();
}

function precache()
{
	_teamset_allies::precache();
	_teamset_axis::precache();
}

// MTEAM: TODO: instead of duplicating all of this data here, get it out of a table
function init_allies( team )
{
	game[team] = "allies";
	game["attackers"] = team;

	// head icons
	game["entity_headicon_" + team] = "faction_allies";
	game["headicon_" + team] = "faction_allies";

	// battle chatter
	level.teamPrefix[team] = "vox_st";
	level.teamPostfix[team] = "st6";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_ALLIES_SHORT");
	SetDvar("g_TeamColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_ScoresColor_" + team, "0.6 0.64 0.69");
	SetDvar("g_FactionName_" + team, game[team] );

	game["strings"][team + "_win"] = &"MP_SEALS_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_SEALS_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_SEALS_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_SEALS_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_SEALS_FORFEITED";
	game["strings"][team + "_name"] = &"MP_SEALS_NAME";

	//Music
	game["music"]["spawn_" + team] = "SPAWN_ST6";
	game["music"]["spawn_short" + team] = "SPAWN_SHORT_ST6";
	game["music"]["victory_" + team] = "VICTORY_ST6";
	
	game["icons"][team] = "faction_allies";
	game["voice"][team] = "vox_st6_";
	SetDvar( "scr_" + team, "marines" );

	level.heli_vo[team]["hit"] = "vox_ops_2_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_allies_1";
	game["carry_flagmodels"][team] = "mp_flag_allies_1_carry";
}

function init_axis( team )
{
	game[team] = "axis";
	game["defenders"] = team;

	// head icons
	game["entity_headicon_" + team] = "faction_axis";
	game["headicon_" + team] = "faction_axis";

	// battle chatter
	level.teamPrefix[team] = "vox_pm";
	level.teamPostfix[team] = "init_axis";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_AXIS_SHORT");
	SetDvar("g_TeamColor_" + team, "0.65 0.57 0.41");
	SetDvar("g_ScoresColor_" + team, "0.65 0.57 0.41");
	SetDvar("g_FactionName_" + team, game[team] );

	game["strings"][team + "_win"] = &"MP_PMC_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_PMC_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_PMC_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_PMC_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_PMC_FORFEITED";
	game["strings"][team + "_name"] = &"MP_PMC_NAME";

	// music
	game["music"]["spawn_" + team] = "SPAWN_PMC";
	game["music"]["spawn_short" + team] = "SPAWN_SHORT_PMC";
	game["music"]["victory_" + team] = "VICTORY_PMC";
	
	game["icons"][team] = "faction_axis";
	game["voice"][team] = "vox_pmc_";
	SetDvar( "scr_" + team, "ussr" );

	level.heli_vo[team]["hit"] = "vox_rus_0_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_axis_1";
	game["carry_flagmodels"][team] = "mp_flag_axis_1_carry";
}