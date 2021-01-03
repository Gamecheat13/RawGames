#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

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
	level.current_team = 0;
	
	level.hardPoints = [];
	level.visuals = [];
	level.hardPointFX = [];

	clientfield::register( "world", "hardpoint", 1,  5, "int",&hardpoint, !true, !true );
	clientfield::register( "world", "hardpointteam", 1,  5, "int",&hardpoint_team, !true, !true );

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

function onPrecacheGameType()
{
}

function get_fx_state( local_client_num, team )
{
	// neutral
	if ( team == 0 )
		return team;
	// contested
	if ( team == 3 )
		return team;
	
	if ( team == 1  )
	{
		if ( util::friend_not_foe_team( local_client_num, "allies" ) )
			return 1;
		else
			return 2;
	}
	
	if ( util::friend_not_foe_team( local_client_num, "axis" ) )
		return 1;
	else
		return 2;
}

function get_fx( fx_name, fx_state )
{
	return level._effect[fx_name][fx_state];
}

function setup_hardpoint_fx( local_client_num, zone_index, team )
{
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
			fx_state = get_fx_state( local_client_num, team );
			
			foreach ( visual in level.visuals[zone_index] )
			{
				if ( !isdefined(visual.script_fxid ) )
					continue;
				
				fxid = get_fx( visual.script_fxid, fx_state );
				
				if ( isdefined(visual.angles) )
					forward = AnglesToForward( visual.angles );
				else
					forward = ( 0,0,0 );
				
				level.hardPointFX[local_client_num][level.hardPointFX[local_client_num].size] = PlayFX( local_client_num, fxid, visual.origin, forward );
			}
		}
	}
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
	level.current_team = 0;
	
	setup_hardpoint_fx( localClientNum, level.current_zone, level.current_team );
}

function hardpoint_team(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( newVal != level.current_team )
	{
		level.current_team = newVal;
		setup_hardpoint_fx( localClientNum, level.current_zone, level.current_team );
	}
}
