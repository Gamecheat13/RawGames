#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


	
#precache( "client_fx", "explosions/fx_exp_grenade_smoke" );

#namespace tiger_tank;

function autoexec __init__sytem__() {     system::register("tiger_tank",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "vehicle", "tiger_tank_retreat_fx",	1, 1, "int", &callback_retreat_fx,	!true, !true );
	clientfield::register( "vehicle", "tiger_tank_disable_sfx", 1, 1, "int", &callback_disable_sfx, 			!true, !true );
}

function callback_retreat_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = vehicle
{
	if ( newVal )
	{
		self fx_play( localClientNum, "retreat_fx", "explosions/fx_exp_grenade_smoke", true, self.origin );
	}
	else 
	{
		self fx_clear( localClientNum, "retreat_fx", "explosions/fx_exp_grenade_smoke" );
	}
}

// TODO: move these functions to utility script once milestone is finished
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

function callback_disable_sfx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  // self = vehicle
{
	if ( newVal == 1 )
	{
		self DisableVehicleSounds();
	}
	else
	{
		self EnableVehicleSounds();
	}
}