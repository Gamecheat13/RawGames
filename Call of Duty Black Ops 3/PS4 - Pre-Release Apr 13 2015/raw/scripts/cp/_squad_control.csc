#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\audio_shared;

    	   	                                                                                                                                                                                                                                                                                                                                                                                                                                               
                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                                                     






	






#namespace squad_control;

function autoexec __init__sytem__() {     system::register("squad_control",&__init__,undefined,undefined);    }
	
#precache( "client_fx", "ui/fx_ui_flagbase_blue" );

function __init__()
{
	//for keylines and squad indicators, set it up so that each player can only see their own robots' keylines and indicators
	level.keyline_outline_indices = [];
	for ( i = 0; i < 4; i++ )
	{
		str_name = "keyline_outline_p" + i;
		clientfield::register( "actor",			str_name, 		1, 2, "int",		&ent_material_callback,	!true, !true );
		clientfield::register( "vehicle",		str_name,		1, 2, "int",		&ent_material_callback,	!true, !true );
		clientfield::register( "scriptmover",	str_name,		1, 3, "int",		&ent_material_callback,	!true, !true );
		level.keyline_outline_indices[str_name] = i;
	}
	
	level._effect[ "squad_waypoint_base_client" ] = "ui/fx_ui_flagbase_blue";
	
	//handles the squad indicators only being drawn on the person who owns the robots
	level.squad_indicator_indices = [];
	for ( i = 0; i < 4; i++ )
	{
		str_name = "squad_indicator_p" + i;
		clientfield::register( "actor", str_name, 1, 1, "int", &squad_indicator_callback, !true, !true );
		level.squad_indicator_indices[str_name] = i;
	}
	
	duplicate_render::set_dr_filter_offscreen( "sitrep_keyline_white", 25, "keyline_active_white", "keyfill_active_white", 2, "mc/hud_outline_model_z_white" );
	duplicate_render::set_dr_filter_offscreen( "sitrep_keyline_red", 25, "keyline_active_red", "keyfill_active_red", 2, "mc/hud_outline_model_red" );
	duplicate_render::set_dr_filter_offscreen( "sitrep_keyline_green", 25, "keyline_active_green", "keyfill_active_green", 2, "mc/hud_outline_model_green" );
	duplicate_render::set_dr_filter_offscreen( "sitrep_keyline_white_through_walls", 25, "keyline_active_white_through_walls", "keyfill_active_white_through_walls", 2, "mc/hud_outline_model_white" );
	
	//HACK copied from _gadget_camo, trying this out on friendly robots
	clientfield::register( "actor", "robot_camo_shader", 1, 3, "int", &ent_camo_material_callback, !true, true );
	duplicate_render::set_dr_filter_framebuffer( "camo_fr", 90, "gadget_camo_on,gadget_camo_friend", "gadget_camo_flicker,gadget_camo_break", 0, "mc/hud_outline_predator_camo_active_ally" );
	duplicate_render::set_dr_filter_framebuffer( "camo_fr_fl", 80, "gadget_camo_on,gadget_camo_flicker,gadget_camo_friend", "gadget_camo_break", 0, "mc/hud_outline_predator_camo_disruption_ally" );
	duplicate_render::set_dr_filter_framebuffer( "camo_brk", 70, "gadget_camo_on,gadget_camo_break", undefined, 0, "mc/hud_outline_predator_break" );
}

function ent_material_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon( "entityshutdown" );
	
	//this makes sure material only shows up for the player who "owns" the robots
	n_index = level.keyline_outline_indices[ fieldName ];
	e_player = GetLocalPlayer( localClientNum );
	if ( !isdefined( e_player ) || n_index != e_player GetEntityNumber() )
	{
		return;
	}
	
	Assert( isdefined(self), "Entity trying to keyline is not valid" );
	
	level flagsys::wait_till( "duplicaterender_registry_ready" );//Wait for materials to get registered by manager
	
	Assert( isdefined(self), "Entity trying to keyline was deleted before the system was ready" );
	
	if ( newVal == 1 )
	{
		self duplicate_render::change_dr_flags( "keyline_active_white", "keyfill_active_white" );
	}
	else if ( newVal == 2 )
	{
		self duplicate_render::change_dr_flags( "keyline_active_red", "keyfill_active_red" );
	}
	else if ( newVal == 3 )
	{
		self duplicate_render::change_dr_flags( "keyline_active_green", "keyfill_active_green" );
	}
	else if ( newVal == 4 )
	{
		self duplicate_render::change_dr_flags( "keyline_active_white_through_walls", "keyfill_active_white_through_walls" );
	}
	else
	{
		self duplicate_render::change_dr_flags( undefined, "keyline_active_white,keyfill_active_white" );
		self duplicate_render::change_dr_flags( undefined, "keyline_active_red,keyfill_active_red" );
		self duplicate_render::change_dr_flags( undefined, "keyline_active_green,keyfill_active_green" );
		self duplicate_render::change_dr_flags( undefined, "keyline_active_white_through_walls,keyfill_active_white_through_walls" );
	}
}

//HACK copied from _gadget_camo, trying this out on friendly robots
function ent_camo_material_callback( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self duplicate_render::set_dr_flag( "gadget_camo_flicker", newVal == 2 );
	self duplicate_render::set_dr_flag( "gadget_camo_break", newVal == 3 );
	self duplicate_render::set_dr_flag( "gadget_camo_on", newVal != 0 );
	self duplicate_render::change_dr_flags();
}

//draws the indicator for the client's robots so that only they see it
//self is a robot
function squad_indicator_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	//this makes sure squad indicator only shows up for the player who "owns" the robots, similar to the keyline
	n_index = level.squad_indicator_indices[ fieldName ];
	e_player = GetLocalPlayer( localClientNum );
	
	if ( !isdefined( e_player ) || n_index != e_player GetEntityNumber() )
	{
		return;
	}
	
	if ( newVal === true )
	{
		self thread draw_squad_indicator( localClientNum );
	}
	else if ( newVal === false )
	{
		self thread delete_squad_indicator( localClientNum );
	}
}

//self is a robot
function draw_squad_indicator( localClientNum )
{
	//HACK until I get a new effect that's rotated correctly
	self.fx_indicator = util::spawn_model( localClientNum, "tag_origin", self.origin, self.angles + (-90, 0, 0) );
	self.fx_indicator LinkTo( self );
	
	self.fx_indicator_handle = PlayFXOnTag( localClientNum, level._effect[ "squad_waypoint_base_client" ], self.fx_indicator, "tag_origin" );	
}

//self is a robot
function delete_squad_indicator( localClientNum )
{
	if ( isdefined ( self.fx_indicator_handle ) )
	{
		DeleteFX( localClientNum, self.fx_indicator_handle, true );
	}
	
	if ( isdefined( self.fx_indicator ) )
	{
		self.fx_indicator Delete();
	}
}