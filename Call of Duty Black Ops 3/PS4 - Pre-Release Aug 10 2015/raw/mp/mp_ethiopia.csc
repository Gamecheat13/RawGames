#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\water_surface;

#using scripts\mp\_load;
#using scripts\mp\_util;
#using scripts\mp\_waterfall;
#using scripts\mp\mp_ethiopia_fx;
#using scripts\mp\mp_ethiopia_sound;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "client_fx", "ui/fx_dom_cap_indicator_neutral_r120" );
#precache( "client_fx", "ui/fx_dom_cap_indicator_team_r120" );
#precache( "client_fx", "ui/fx_dom_marker_neutral_r120" );
#precache( "client_fx", "ui/fx_dom_marker_team_r120" );

function main()
{
	mp_ethiopia_fx::main();
	mp_ethiopia_sound::main();
	
	load::main();
		
	level.domFlagBaseFxOverride = &dom_flag_base_fx_override;
	level.domFlagCapFxOverride = &dom_flag_cap_fx_override;

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.

	level.endGameXCamName = "ui_cam_endgame_mp_ethiopia";
	
	callback::on_localclient_connect( &waterfall::waterfallOverlay );
	callback::on_localclient_connect( &waterfall::waterfallMistOverlay );
	callback::on_spawned( &waterfall::waterfallMistOverlayReset );
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
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
		case "c":
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
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
		case "c":
			break;
	};
}