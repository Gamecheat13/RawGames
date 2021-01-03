#using scripts\codescripts\struct;

#using scripts\cp\_load;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\cp\cp_mi_zurich_newworld_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       





#precache( "client_fx", "light/fx_beam_friendly_flash_in_infection" );
#precache( "client_fx", "player/fx_plyr_rez_out" );
#precache( "client_fx", "weather/fx_snow_player_os_nworld" );

#namespace newworld_util;

function autoexec __init__sytem__() {     system::register("newworld_util",&__init__,undefined,undefined);    }

function __init__()
{
	init_clientfields();
}

function init_clientfields()
{
	clientfield::register( "actor", 		"derez_ai_deaths",	 	1, 1, "int", &callback_derez_fx,		 		!true, !true );
	clientfield::register( "actor", 		"ally_spawn_fx", 		1, 1, "int", &callback_ally_spawn_fx, 		!true, !true );
	clientfield::register( "allplayers", 	"player_spawn_fx", 		1, 1, "int", &callback_ally_spawn_fx, 		!true, !true );
	clientfield::register( "scriptmover",	"derez_model_deaths",	1, 1, "int", &callback_derez_fx,		 		!true, !true );
	clientfield::register( "toplayer", 		"player_snow_fx", 		1, 1, "int", &callback_player_snow_fx, 		!true, !true );
	clientfield::register( "toplayer", 		"rumble_loop", 			1, 1, "int", &callback_toggle_rumble_loop, 	!true, !true );
}

// Clientfield callbacks
function callback_derez_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = actor
{
	if ( newVal == 1 )
	{
//		PlayFx( localClientNum, FX_DEREZ, self GetTagOrigin( "j_spine4" ), self GetTagAngles( "j_spine4" ) );
		PlayFxOnTag( localClientNum, "player/fx_plyr_rez_out", self, "j_spine4" );
	}
}

function callback_player_snow_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = player
{
	if ( newVal )
	{
		self callback_player_snow_fx_logic( localClientNum );
	}
	else 
	{
		self notify( "stop_snow_fx" );
	}
}

function callback_player_snow_fx_logic( localClientNum )
{
	self endon( "stop_snow_fx" );
	
	while ( IsDefined( self ) )
	{
		self fx_play( localClientNum, "player_snow", "weather/fx_snow_player_os_nworld", true, self.origin, AnglesToForward( self.angles ) );

		wait 0.25; // This is from FX artist
	}
}

function callback_ally_spawn_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = player
{
	if ( newVal )
	{
		self fx_play_on_tag( localClientNum, "objective_light", "light/fx_beam_friendly_flash_in_infection" );
	}
	else 
	{
		self fx_clear( localClientNum, "objective_light", "light/fx_beam_friendly_flash_in_infection" );
	}
}

function callback_toggle_rumble_loop( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal )
    {
		self PlayRumbleLoopOnEntity( localClientNum, "tank_rumble" );
	}
    else
    {
    	self StopRumble( localClientNum, "tank_rumble" );
    }
}

// FX UTIL -- Borrowed from Infection
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
