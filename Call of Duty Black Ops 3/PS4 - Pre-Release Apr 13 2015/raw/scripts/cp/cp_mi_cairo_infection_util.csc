#using scripts\codescripts\struct;

#using scripts\cp\_load;

#using scripts\shared\clientfield_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\duplicaterender_mgr;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                               	                                                          	              	                                                                                           



















#precache( "client_fx", "light/fx_beam_sarah_marker_bright" );
#precache( "client_fx", "light/fx_beam_sarah_marker_bright" );
#precache( "client_fx", "weather/fx_snow_player_loop" );
#precache( "client_fx", "weather/fx_snow_player_loop_reverse" );
#precache( "client_fx", "weather/fx_snow_player_loop_reverse_sideways" );
#precache( "client_fx", "weather/fx_snow_impact_body_reverse_infection" );
#precache( "client_fx", "impacts/fx_bul_impact_blood_body_fatal_reverse" );
#precache( "client_fx", "explosions/fx_exp_torso_blood_infection" );
#precache( "client_fx", "explosions/fx_exp_mortar_snow" );
#precache( "client_fx", "light/fx_beam_friendly_flash_in_infection" );
#precache( "client_fx", "electric/fx_elec_sarah_spawn" );
#precache( "client_fx", "electric/fx_elec_ai_spawn" );

#namespace infection_util;

function autoexec __init__sytem__() {     system::register("infection_util",&__init__,undefined,undefined);    }

function __init__()
{
	init_clientfields();
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "toplayer",		"snow_fx", 						1, 2, 	"int", &callback_fx_snow_players, 			!true, !true );	
	clientfield::register( "actor",			"sarah_objective_light", 		1, 1, 				"int", &callback_sarah_light, 				!true, !true );
	clientfield::register( "actor", 		"sarah_light_dim", 				1, 1, 				"int", &callback_sarah_light_dim, 			!true, !true );
	clientfield::register( "actor", 		"reverse_arrival_snow_fx", 		1, 1, 				"int", &callback_time_snow_fx, 				!true, !true );
	clientfield::register( "actor", 		"reverse_arrival_dmg_fx", 		1, 1, 				"int", &callback_time_dmg_fx, 				!true, !true );
	clientfield::register( "actor", 		"exploding_ai_deaths", 			1, 1, 				"int", &callback_exploding_death_fx, 		!true, !true );
	clientfield::register( "actor", 		"reverse_arrival_explosion_fx", 1, 1, 				"int", &callback_reverse_time_explosion_fx, !true, !true );
	clientfield::register( "allplayers", 	"player_spawn_fx", 				1, 1, 				"int", &callback_ally_spawn_fx, 			!true, !true );
	clientfield::register( "toplayer", 		"stop_post_fx",					1, 1, 				"counter", &callback_stop_post_fx, 			!true, !true );
	clientfield::register( "actor", 		"sarah_spawn_fx",   			1, 1, 				"int", &callback_sarah_spawn_fx, 			!true, !true );

	clientfield::register( "toplayer", "postfx_dni_interrupt", 1, 1, "counter", &postfx_dni_interrupt, !true, !true );
	clientfield::register( "toplayer", "postfx_futz", 1, 1, "counter", &postfx_futz, !true, !true );

	//HACK copied from _gadget_camo, trying this out on Sarah
	clientfield::register( "actor", "sarah_camo_shader", 1, 3, "int", &ent_camo_material_callback, !true, true );
	duplicate_render::set_dr_filter_framebuffer( "active_camo", 90, "actor_camo_on", "", 0, "mc/hud_outline_predator_camo_active_inf" );
	duplicate_render::set_dr_filter_framebuffer( "active_camo_flicker", 80, "actor_camo_flicker", "", 0, "mc/hud_outline_predator_camo_disruption_inf" );
}

// Clientfield callbacks
function callback_time_snow_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	//if we need a snow effect for explosion can be added her with another bit added.
	if ( newVal == 1 )
	{
		self fx_play_on_tag( localClientNum, "reverse_snow_fx", "weather/fx_snow_impact_body_reverse_infection" );
	}
}

function callback_time_dmg_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal == 1 )
	{
		self fx_play_on_tag( localClientNum, "reverse_blood_fx", "impacts/fx_bul_impact_blood_body_fatal_reverse", "tag_eye" );
	}
	else 
	{
		self fx_play_on_tag( localClientNum, "reverse_blood_fx", "impacts/fx_bul_impact_blood_body_fatal_reverse", "j_spine4" );
	}
}

function callback_reverse_time_explosion_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal )
	{
		self fx_play( localClientNum, "reverse_explosion_arrival", "explosions/fx_exp_mortar_snow", true, self.origin );
	}
	else 
	{
		self fx_clear( localClientNum, "reverse_explosion_arrival", "explosions/fx_exp_mortar_snow" );
	}
}

function callback_exploding_death_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal == 1 )
	{
		pos = self gettagorigin( "j_spine4" );
		angles = self gettagangles("j_spine4");
		
		fxObj = util::spawn_model(localClientNum, "tag_origin", pos, angles);
		fxObj fx_play_on_tag( localClientNum, "exploding_death_fx", "explosions/fx_exp_torso_blood_infection", "tag_origin" );
		fxObj playsound( 0, "evt_ai_explode" );
		
		waitrealtime( 6 );
		fxobj delete();		
	}
}

function callback_sarah_light( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal )
	{
		if( self.team != "allies" )
		{
			return;
		}		
		
		self fx_play_on_tag( localClientNum, "objective_light", "light/fx_beam_sarah_marker_bright", "j_mainroot" );
	}
	else 
	{
		self fx_clear( localClientNum, "objective_light", "light/fx_beam_sarah_marker_bright" );
	}
}

function callback_sarah_light_dim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal )
	{
		self fx_play_on_tag( localClientNum, "light_flash", "light/fx_beam_sarah_marker_bright", "j_mainroot" );
	}
	else 
	{
		self fx_clear( localClientNum, "light_flash", "light/fx_beam_sarah_marker_bright" );
	}
}

function callback_fx_snow_players( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = player
{
	if ( newVal == 1 )
	{
		self fx_play_on_tag( localClientNum, "snow_fx", "weather/fx_snow_player_loop", "none" );
	}
	else if ( newVal == 2 )
	{
		self fx_play_on_tag( localClientNum, "snow_fx", "weather/fx_snow_player_loop_reverse", "none" );
	}
	else if ( newVal == 3 )
	{
		self fx_play_on_tag( localClientNum, "snow_fx", "weather/fx_snow_player_loop_reverse_sideways", "none" );
	}
	else  // CF_FX_SNOW_DISABLED
	{
		self fx_delete_type( localClientNum, "snow_fx", false );
	}
}

// FX UTIL
function fx_clear( localClientNum, str_type, str_fx )
{
	if ( !IsDefined( self.a_fx ) )
	{
		self.a_fx = [];
	}
	
	if ( !IsDefined( self.a_fx[ localClientNum ] ) )
	{
		self.a_fx[ localClientNum ] = [];
	}
	
	if ( !IsDefined( self.a_fx[ localClientNum ][ str_type ] ) )
	{
		self.a_fx[ localClientNum ][ str_type ] = [];
	}
	
	if ( IsDefined( str_fx ) && IsDefined( self.a_fx[ localClientNum ][ str_type ][ str_fx ] ) )
	{
		n_fx_id = self.a_fx[ localClientNum ][ str_type ][ str_fx ];
			
		DeleteFx( localClientNum, n_fx_id, false );
		
		self.a_fx[ localClientNum ][ str_type ][ str_fx ] = undefined;
	}
}

function fx_delete_type( localClientNum, str_type, b_stop_immediately = true )
{
	if ( IsDefined( self.a_fx ) && IsDefined( self.a_fx[ localClientNum ] ) && IsDefined( self.a_fx[ localClientNum ][ str_type ] ) )
	{
		a_keys = GetArrayKeys( self.a_fx[ localClientNum ][ str_type ] );
		
		for ( i = 0; i < a_keys.size; i++ )
		{
			DeleteFX( localClientNum, self.a_fx[ localClientNum ][ str_type ][ a_keys[ i ] ], b_stop_immediately );
			
			self.a_fx[ localClientNum ][ str_type ][ a_keys[ i ] ] = undefined;
		}
	}
}

function fx_play_on_tag( localClientNum, str_type, str_fx, str_tag = "tag_origin", b_kill_fx_with_same_type = true )
{
	self fx_clear( localClientNum, str_type, str_fx );  // make sure only one effect of this type is playing at a time
	
	if ( b_kill_fx_with_same_type )
	{
		self fx_delete_type( localClientNum, str_type, false );
	}
	
	n_fx_id = PlayFxOnTag( localClientNum, str_fx, self, str_tag );
	
	self.a_fx[ localClientNum ][ str_type ][ str_fx ] = n_fx_id;
}

function fx_play( localClientNum, str_type, str_fx, b_kill_fx_with_same_type = true, v_pos, v_forward, v_up )
{
	self fx_clear( localClientNum, str_type, str_fx );  // make sure only one effect of this type is playing at a time
	
	if ( b_kill_fx_with_same_type )
	{
		self fx_delete_type( localClientNum, str_type, false );
	}
	
	// code will generate error if v_forward or v_up are passed into PlayFX as undefined
	if ( IsDefined( v_forward ) && IsDefined( v_up ) )
	{
		n_fx_id = PlayFx( localClientNum, str_fx, v_pos, v_forward, v_up );
	}
	else if ( IsDefined( v_forward ) )
	{
		n_fx_id = PlayFx( localClientNum, str_fx, v_pos, v_forward );
	}
	else 
	{
		n_fx_id = PlayFx( localClientNum, str_fx, v_pos );
	}
	
	self.a_fx[ localClientNum ][ str_type ][ str_fx ] = n_fx_id;
}

function callback_ally_spawn_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal )
	{
		self fx_play_on_tag( localClientNum, "objective_light", "light/fx_beam_friendly_flash_in_infection" );
		self playsound(0, "evt_ai_teleport");
	}
	else 
	{
		self fx_clear( localClientNum, "objective_light", "light/fx_beam_friendly_flash_in_infection" );
	}
}

function callback_sarah_spawn_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal == 1 )
	{
		if( IsSubStr( self.model, "sarah" ) ) //only thing that went to client that had character name.
		{
			self fx_play_on_tag( localClientNum, "spawn_fx", "electric/fx_elec_sarah_spawn", "j_spinelower" );
		}
		else
		{
			self fx_play_on_tag( localClientNum, "spawn_fx", "electric/fx_elec_ai_spawn", "j_spinelower" );
		}
	}
	else
	{
		if( IsSubStr( self.model, "sarah" ) )
		{
			self fx_clear( localClientNum, "spawn_fx", "electric/fx_elec_sarah_spawn" );
		}
		else
		{
			self fx_clear( localClientNum, "spawn_fx", "electric/fx_elec_ai_spawn" );
		}
	}	
}

function callback_stop_post_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	player = GetLocalPlayer( localClientNum );
	player postfx::StopPostfxBundle();
}

function postfx_dni_interrupt( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self postfx::playPostfxBundle( "pstfx_dni_interrupt" );
	}
}	

function postfx_futz( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self postfx::playPostfxBundle( "pstfx_dni_screen_futz" );
	}
}

//HACK copied from _gadget_camo, trying this out on Sarah
function ent_camo_material_callback( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self duplicate_render::set_dr_flag( "actor_camo_flicker", newVal == 2 );
	self duplicate_render::set_dr_flag( "actor_camo_on", newVal != 0 );
	self duplicate_render::change_dr_flags();
}	