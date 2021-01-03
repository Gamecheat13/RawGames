    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\shared\system_shared;
	
#namespace zm_zod_portals;

function autoexec __init__sytem__() {     system::register("zm_zod_portals",&__init__,undefined,undefined);    }

#precache( "client_fx", "portal_3p" );
#precache( "client_fx", "portal_shortcut_closed" );
#precache( "client_fx", "portal_shortcut_open" );



function __init__()
{
	// third-person vfx played when the player or zombies pass through the portal
//	clientfield::register( "allplayers",	"portal_3p",				VERSION_SHIP, 1, "int", &portal_3p, 			!CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT ); // 3rd person portal bamf-through effect - play on player
//	clientfield::register( "actor",			"portal_3p_zmb",			VERSION_SHIP, 1, "int", &portal_3p, 			!CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT ); // 3rd person portal bamf-through effect - play on zombie
	
	// the portal shortcut itself
	clientfield::register( "world",		"portal_state_canal",		1, 1, "int", &portal_state_canal,	!true, true );
	clientfield::register( "world",		"portal_state_slums",		1, 1, "int", &portal_state_slums,	!true, true );
	clientfield::register( "world",		"portal_state_theater",		1, 1, "int", &portal_state_theater,	!true, true );
}

// play flash on actor as we run through the portal
function portal_3p( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "death" );
	
	if( newVal == 1 )
	{
		self.fx_portal_3p = PlayFX( localClientNum, level._effect[ "portal_3p" ], self.origin );
	}
	else
	{
		stop_fx_if_defined( localClientNum, self.fx_portal_3p );
	}
}

function portal_state_canal( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	portal_state_internal( localClientNum, "canal", newVal );
}

function portal_state_slums( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	portal_state_internal( localClientNum, "slums", newVal );
}

function portal_state_theater( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	portal_state_internal( localClientNum, "theater", newVal );
}

function portal_state_internal( localClientNum, str_areaname, newVal )
{
	s_loc_upper = get_portal_fx_loc( str_areaname, true );
	s_loc_lower = get_portal_fx_loc( str_areaname, false );

	switch( newVal )
	{
		case 0:
			// stop open-portal fx
			stop_fx_if_defined( localClientNum, s_loc_upper.fx_portal_open );
			stop_fx_if_defined( localClientNum, s_loc_lower.fx_portal_open );
			// play closed-portal fx
			v_fwd = AnglesToForward( s_loc_upper.angles );
			s_loc_upper.fx_portal_closed = PlayFX( localClientNum, level._effect[ "portal_shortcut_closed" ], s_loc_upper.origin, v_fwd );
			v_fwd = AnglesToForward( s_loc_lower.angles );
			s_loc_lower.fx_portal_closed = PlayFX( localClientNum, level._effect[ "portal_shortcut_closed" ], s_loc_lower.origin, v_fwd );
			break;
		case 1:
			// stop closed-portal fx
			stop_fx_if_defined( localClientNum, s_loc_upper.fx_portal_closed );
			stop_fx_if_defined( localClientNum, s_loc_lower.fx_portal_closed );
			// play open-portal fx
			v_fwd = AnglesToForward( s_loc_upper.angles );
			s_loc_upper.fx_portal_open = PlayFX( localClientNum, level._effect[ "portal_shortcut_open" ], s_loc_upper.origin, v_fwd );
			v_fwd = AnglesToForward( s_loc_lower.angles );
			s_loc_lower.fx_portal_open = PlayFX( localClientNum, level._effect[ "portal_shortcut_open" ], s_loc_lower.origin, v_fwd );
			break;
	}
}

function get_portal_fx_loc( str_areaname, b_is_top )
{
	a_s_portal_locs = struct::get_array( "teleport_effect_origin", "targetname" );
	s_return_loc = undefined;
	str_top_or_bottom = undefined;
	
	if( ( isdefined( b_is_top ) && b_is_top ) )
	{
		str_top_or_bottom = "top";
	}
	else
	{
		str_top_or_bottom = "bottom";
	}
	
	foreach( s_portal_loc in a_s_portal_locs )
	{
		if( s_portal_loc.script_noteworthy === str_areaname + "_portal_" + str_top_or_bottom )
		{
			s_return_loc = s_portal_loc;
		}
	}
	
	return s_return_loc;
}

function stop_fx_if_defined( localClientNum, fx_reference )
{
	if( isdefined( fx_reference ) )
	{
		StopFX( localClientNum, fx_reference );
	}
}
