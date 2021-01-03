#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_sector_fx;
#using scripts\mp\mp_sector_sound;

#precache( "client_fx", "ui/fx_dom_cap_indicator_neutral_r120" );
#precache( "client_fx", "ui/fx_dom_cap_indicator_team_r120" );
#precache( "client_fx", "ui/fx_dom_marker_neutral_r120" );
#precache( "client_fx", "ui/fx_dom_marker_team_r120" );
#precache( "client_fx", "ui/fx_dom_cap_indicator_neutral_r90" );
#precache( "client_fx", "ui/fx_dom_cap_indicator_team_r90" );
#precache( "client_fx", "ui/fx_dom_marker_neutral_r90" );
#precache( "client_fx", "ui/fx_dom_marker_team_r90" );

function main()
{
	mp_sector_fx::main();
	mp_sector_sound::main();
	
	load::main();
	
	level.domFlagBaseFxOverride = &dom_flag_base_fx_override;
	level.domFlagCapFxOverride = &dom_flag_cap_fx_override;

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.

	level.endGameXCamName = "ui_cam_endgame_mp_sector";
}

function dom_flag_base_fx_override( flag, team )
{
	switch ( flag.name )
	{
		case "a":
			break;
		case "b":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_marker_neutral_r90";
			}
			else
			{
				return "ui/fx_dom_marker_team_r90";
			}
			break;
		case "c":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
	};
}

function dom_flag_cap_fx_override( flag, team )
{
	switch ( flag.name )
	{
		case "a":
			break;
		case "b":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_cap_indicator_neutral_r90";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r90";
			}
			break;
		case "c":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_cap_indicator_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r120";
			}
			break;
	};
}