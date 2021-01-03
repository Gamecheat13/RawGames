#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

//#precache( "string", "MP_CUSTOMTEAM_WIN_MATCH" );
//#precache( "string", "MP_CUSTOMTEAM_WIN_ROUND" );
//#precache( "string", "MP_CUSTOMTEAM_MISSION_ACCOMPLISHED" );
//#precache( "string", "MP_CUSTOMTEAM_ELIMINATED" );
//#precache( "string", "MP_CUSTOMTEAM_FORFEITED" );
//#precache( "string", "MP_CUSTOMTEAM_NAME" );

function init()
{
	if ( !isdefined( game["flagmodels"] ) )
		game["flagmodels"] = [];

	if ( !isdefined( game["carry_flagmodels"] ) )
		game["carry_flagmodels"] = [];

	if ( !isdefined( game["carry_icon"] ) )
		game["carry_icon"] = [];

	game["flagmodels"]["neutral"] = "p7_mp_flag_neutral";
}

function customteam_init()
{
	if( GetDvarString( "g_customTeamName_Allies") != "" )
	{
		SetDvar("g_TeamName_Allies", GetDvarString( "g_customTeamName_Allies") );
		
//		game["strings"]["allies_win"] = &"MP_CUSTOMTEAM_WIN_MATCH";
//		game["strings"]["allies_win_round"] = &"MP_CUSTOMTEAM_WIN_ROUND";
//		game["strings"]["allies_mission_accomplished"] = &"MP_CUSTOMTEAM_MISSION_ACCOMPLISHED";
//		game["strings"]["allies_eliminated"] = &"MP_CUSTOMTEAM_ELIMINATED";
//		game["strings"]["allies_forfeited"] = &"MP_CUSTOMTEAM_FORFEITED";
//		game["strings"]["allies_name"] = &"MP_CUSTOMTEAM_NAME";
	}
	
	if( GetDvarString( "g_customTeamName_Axis") != "" )
	{
		SetDvar("g_TeamName_Axis", GetDvarString( "g_customTeamName_Axis") );
		
//		game["strings"]["axis_win"] = &"MP_CUSTOMTEAM_WIN_MATCH";
//		game["strings"]["axis_win_round"] = &"MP_CUSTOMTEAM_WIN_ROUND";
//		game["strings"]["axis_mission_accomplished"] = &"MP_CUSTOMTEAM_MISSION_ACCOMPLISHED";
//		game["strings"]["axis_eliminated"] = &"MP_CUSTOMTEAM_ELIMINATED";
//		game["strings"]["axis_forfeited"] = &"MP_CUSTOMTEAM_FORFEITED";
//		game["strings"]["axis_name"] = &"MP_CUSTOMTEAM_NAME";
	}
}
