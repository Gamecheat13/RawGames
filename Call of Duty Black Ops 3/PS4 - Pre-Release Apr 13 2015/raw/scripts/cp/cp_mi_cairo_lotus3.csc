#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_load;
#using scripts\cp\cp_mi_cairo_lotus3_fx;
#using scripts\cp\cp_mi_cairo_lotus3_sound;

 	               	                    

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

function main()
{
	init_clientfields();
	
	cp_mi_cairo_lotus3_fx::main();
	cp_mi_cairo_lotus3_sound::main();
	
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

function init_clientfields()
{
	clientfield::register( "toplayer", "sand_fx", 1, 1, "int", &player_sand_fx_logic, !true, !true );
}

// self == player
function player_sand_fx_logic( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		self thread player_sand_fx_loop( localClientNum );
	}
	else
	{
		self notify( "sand_fx_stop" );
		
		if ( IsDefined( self.n_fx_id ) )
		{
			DeleteFX( localClientNum, self.n_fx_id, true );
		}
	}
}

// self == player
function player_sand_fx_loop( localClientNum )
{
	self endon( "disconnect" );
	self endon( "entityshutdown" );
	self endon( "sand_fx_stop" );

	while ( true )
	{	
		v_eye = self GetEye();
		self.n_fx_id = PlayFX( localClientNum, level._effect[ "player_sand" ], v_eye );
		
		wait 0.1;
	}
}
