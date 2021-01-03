
#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#using scripts\shared\visionset_mgr_shared;

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "light/fx_glow_robot_control_gen_2_head" );

//*****************************************************************************
//*****************************************************************************

function main()
{
	clientfields_init();

	cp_mi_eth_prologue_fx::main();
	cp_mi_eth_prologue_sound::main();

	visionset_mgr::fog_vol_to_visionset_set_info( 0, "cp_mi_eth_prologue", 0 );
	visionset_mgr::fog_vol_to_visionset_set_info( 1, "cp_mi_eth_prologue", 0 );
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
	
	//enables map switching
	SetDVAR( "sv_mapswitch", 1 );	
}


//*****************************************************************************
//*****************************************************************************

function clientfields_init()
{
	clientfield::register("actor", "robot_eye_fx", 1, 1, "int", &robot_eye_fx, true, true);
	clientfield::register( "world", "apc_rail_tower_collapse", 1, 1, "int", &apc_rail_tower_collapse, true, !true );

	clientfield::register( "toplayer", "turn_on_multicam", 1, 3, "int", &player_turn_on_extra_cam, !true, !true );
	clientfield::register( "world", "set_active_cam_index", 1, 3, "int", &set_active_cam_index, !true, !true );
	
	clientfield::register( "world", "set_cam_lookat_object", 1, 3, "int", &set_cam_lookat_object, !true, !true );
	
//	clientfield::register( "world", "light_lift_panel_red_on", VERSION_SHIP, 1, "int", &light_lift_panel_red_on, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
//	clientfield::register( "world", "light_lift_panel_green_on", VERSION_SHIP, 1, "int", &light_lift_panel_green_on, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}


//*****************************************************************************
//*****************************************************************************

function player_turn_on_extra_cam( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	client_cam_index = newVal - 1;

	// 1 = Left Camera, 2 = Right Camera
	if( newVal )
    {
		//SetDvar( "r_deferredPermuteTiles", 0);

		// Give the extra cam an object to look from
		e_ent = GetEnt( localClientNum, "s_security_cam_hallway", "targetname" );
		e_ent SetExtraCam( client_cam_index );
    }

	// Turn off the extra cams, deleting the lookat objects kills them
	else
	{
		//SetDvar( "r_deferredPermuteTiles", 1);

		get_cam_lookat_objects( localClientNum );
		for( i=1; i<level.a_cam_objects.size; i++ )
		{
			level.a_cam_objects[i] delete();
		}
	}

	level.active_extra_cam = client_cam_index;
}


//*****************************************************************************
// Set the index of the extra cam that is active
//*****************************************************************************

function set_active_cam_index( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	level.active_extra_cam = newVal - 1;
}


//*****************************************************************************
// newVal = the object index we want the active camera to look at
//*****************************************************************************

function set_cam_lookat_object( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( !IsDefined(level.active_extra_cam) )
	{
		return;
	}
	
	get_cam_lookat_objects( localClientNum );
	
	object_index = newVal;

	if( object_index < level.a_cam_objects.size )
	{
		e_ent = level.a_cam_objects[ object_index ];
		e_ent SetExtraCam( level.active_extra_cam );
	}
}


//*****************************************************************************
//*****************************************************************************

function get_cam_lookat_objects( localClientNum )
{
	level.a_cam_objects = [];
	level.a_cam_objects[ level.a_cam_objects.size ] = 0;
	level.a_cam_objects[ level.a_cam_objects.size ] = GetEnt( localClientNum, "s_security_cam_hallway", "targetname" );
	level.a_cam_objects[ level.a_cam_objects.size ] = GetEnt( localClientNum, "s_security_cam_2", "targetname" );
	level.a_cam_objects[ level.a_cam_objects.size ] = GetEnt( localClientNum, "s_security_cam_3_minister", "targetname" );
	level.a_cam_objects[ level.a_cam_objects.size ] = GetEnt( localClientNum, "s_security_cam_4", "targetname" );
	level.a_cam_objects[ level.a_cam_objects.size ] = GetEnt( localClientNum, "s_security_cam_5", "targetname" );
	level.a_cam_objects[ level.a_cam_objects.size ] = GetEnt( localClientNum, "s_security_cam_6", "targetname" );
}


//*****************************************************************************
//*****************************************************************************

function robot_eye_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal)
	{
		self.eye_fx = PlayFxOnTag( localClientNum, level._effect["eye_glow"], self, "tag_eye" );
		
	}
	else
	{
		if(isdefined( self.eye_fx ))
		{
			stopfx( localClientNum, self.eye_fx );
			self.eye_fx = undefined;
		}
	}
}


//*****************************************************************************
//*****************************************************************************

function apc_rail_tower_collapse( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	// Turn on the Extra Cam
    if ( newVal )
    {
		level thread scene::play( "rail_tower_collapse_start", "targetname" );
    }
}


// ----------------------------------------------------------------------------
// light_lift_panel_red_on
// ----------------------------------------------------------------------------
//function light_lift_panel_red_on( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
//{
//	if(newVal)
//	{
//		exploder::exploder( "light_lift_panel_red" );
//		
//	}
//	else
//	{
//		exploder::stop_exploder( "light_lift_panel_red" );
//	}	
//}


// ----------------------------------------------------------------------------
// light_lift_panel_green_on
// ----------------------------------------------------------------------------
//function light_lift_panel_green_on( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
//{
//	if(newVal)
//	{
//		exploder::exploder( "light_lift_panel_green" );		
//	}
//	else
//	{
//		exploder::stop_exploder( "light_lift_panel_green" );
//	}	
//}

