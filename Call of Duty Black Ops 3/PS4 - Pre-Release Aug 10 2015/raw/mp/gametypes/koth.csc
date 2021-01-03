#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using scripts\mp\_shoutcaster;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "ui/fx_koth_marker_blue" );
#precache( "client_fx", "ui/fx_koth_marker_orng" );
#precache( "client_fx", "ui/fx_koth_marker_neutral" );
#precache( "client_fx", "ui/fx_koth_marker_contested" );
#precache( "client_fx", "ui/fx_koth_marker_blue_window" );
#precache( "client_fx", "ui/fx_koth_marker_orng_window" );
#precache( "client_fx", "ui/fx_koth_marker_neutral_window" );
#precache( "client_fx", "ui/fx_koth_marker_contested_window" );





	



function main()
{
	level.current_zone = 0;
	level.current_state = 0;
	
	level.hardPoints = [];
	level.visuals = [];
	level.hardPointFX = [];

	clientfield::register( "world", "hardpoint", 1,  5, "int",&hardpoint, !true, !true );
	clientfield::register( "world", "hardpointteam", 1,  5, "int",&hardpoint_state, !true, !true );

	level.effect_scriptbundles = [];
	
	level.effect_scriptbundles["zoneEdgeMarker"] = struct::get_script_bundle( "teamcolorfx", "teamcolorfx_koth_edge_marker" );
	level.effect_scriptbundles["zoneEdgeMarkerWndw"] = struct::get_script_bundle( "teamcolorfx", "teamcolorfx_koth_edge_marker_window" );

	level._effect["zoneEdgeMarker"] = [];
	level._effect["zoneEdgeMarker"][0] = "ui/fx_koth_marker_neutral";
	level._effect["zoneEdgeMarker"][1] = "ui/fx_koth_marker_blue";
	level._effect["zoneEdgeMarker"][2] = "ui/fx_koth_marker_orng";
	level._effect["zoneEdgeMarker"][3] = "ui/fx_koth_marker_contested";
	
	level._effect["zoneEdgeMarkerWndw"] = [];
	level._effect["zoneEdgeMarkerWndw"][0] = "ui/fx_koth_marker_neutral_window";
	level._effect["zoneEdgeMarkerWndw"][1] = "ui/fx_koth_marker_blue_window";
	level._effect["zoneEdgeMarkerWndw"][2] = "ui/fx_koth_marker_orng_window";
	level._effect["zoneEdgeMarkerWndw"][3] = "ui/fx_koth_marker_contested_window";
}

function get_shoutcaster_fx(local_client_num)
{
	caster_effects = [];
	caster_effects["zoneEdgeMarker"]  = shoutcaster::get_color_fx( local_client_num, level.effect_scriptbundles["zoneEdgeMarker"] );
	caster_effects["zoneEdgeMarkerWndw"]  = shoutcaster::get_color_fx( local_client_num, level.effect_scriptbundles["zoneEdgeMarkerWndw"] );
	
	effects = [];
	effects["zoneEdgeMarker"] = level._effect["zoneEdgeMarker"];
	effects["zoneEdgeMarkerWndw"] = level._effect["zoneEdgeMarkerWndw"];	
	
	effects["zoneEdgeMarker"][1] = caster_effects["zoneEdgeMarker"]["allies"];
	effects["zoneEdgeMarker"][2] = caster_effects["zoneEdgeMarker"]["axis"];
	effects["zoneEdgeMarkerWndw"][1] = caster_effects["zoneEdgeMarkerWndw"]["allies"];
	effects["zoneEdgeMarkerWndw"][2] = caster_effects["zoneEdgeMarkerWndw"]["axis"];
	
	return effects;
}

function get_fx_state( local_client_num, state, is_shoutcaster )
{
	if ( is_shoutcaster )
		return state;
	
	if ( state == 1  )
	{
		if ( util::friend_not_foe_team( local_client_num, "allies" ) )
			return 1;
		else
			return 2;
	}
	else if ( state == 2 )
	{
		if ( util::friend_not_foe_team( local_client_num, "axis" ) )
			return 1;
		else
			return 2;
	}
	
	return state;
}

function get_fx( fx_name, fx_state, effects )
{
	return effects[fx_name][fx_state];
}

function setup_hardpoint_fx( local_client_num, zone_index, state )
{
	is_shoutcaster = shoutcaster::is_shoutcaster(local_client_num); 
	
	effects = [];
	
	if ( is_shoutcaster )
	{
		effects = get_shoutcaster_fx(local_client_num);
	}
	else
	{
		effects["zoneEdgeMarker"] = level._effect["zoneEdgeMarker"];
		effects["zoneEdgeMarkerWndw"] = level._effect["zoneEdgeMarkerWndw"];	
	}
	
	if ( isdefined( level.hardPointFX[local_client_num] ) )
	{
		foreach ( fx in level.hardPointFX[local_client_num] )
		{
			StopFx( local_client_num, fx );
		}
	}
	level.hardPointFX[local_client_num] = [];
	
	if ( zone_index )
	{
		if ( isdefined( level.visuals[zone_index] ) )
		{
			fx_state = get_fx_state( local_client_num, state, is_shoutcaster );
			
			foreach ( visual in level.visuals[zone_index] )
			{
				if ( !isdefined(visual.script_fxid ) )
					continue;
				
				fxid = get_fx( visual.script_fxid, fx_state, effects );
				
				if ( isdefined(visual.angles) )
					forward = AnglesToForward( visual.angles );
				else
					forward = ( 0,0,0 );
				
				level.hardPointFX[local_client_num][level.hardPointFX[local_client_num].size] = PlayFX( local_client_num, fxid, visual.origin, forward );
			}
		}
	}
	
	thread watch_for_team_change( local_client_num );
}

function hardpoint(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( level.hardPoints.size == 0 )
	{
		hardpoints = struct::get_array( "koth_zone_center", "targetname" );
		foreach( point in hardpoints )
		{
	   		level.hardPoints[point.script_index] = point;
		}
		
		foreach( point in level.hardPoints )
		{
			level.visuals[point.script_index] = struct::get_array( point.target, "targetname" );
		}
	}
	
	level.current_zone = newVal;
	level.current_state = 0;
	
	setup_hardpoint_fx( localClientNum, level.current_zone, level.current_state );
}

function hardpoint_state(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( newVal != level.current_state )
	{
		level.current_state = newVal;
		setup_hardpoint_fx( localClientNum, level.current_zone, level.current_state );
	}
}

function watch_for_team_change( localClientNum )
{
	level notify( "end_team_change_watch" );
	level endon( "end_team_change_watch" );

	level waittill( "team_changed" );
	
	// the local player might not be valid yet and will cause the team detection functionality not to work
	while ( !isdefined(	GetNonPredictedLocalPlayer( localClientNum ) ) )
   {
		wait(0.05);
   }

	setup_hardpoint_fx( localClientNum, level.current_zone, level.current_state );
}