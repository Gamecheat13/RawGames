#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\math_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

//Fire

	
//Bubbles	

#precache( "client_fx", "player/fx_plyr_swim_bubbles_body" );

#namespace cp_player_cam;

function autoexec main()
{
	//bubbles
	clientfield::register( "toplayer", "player_cam_bubbles", 1, 1, "int", &player_cam_bubbles, !true, !true );

	//fire
	clientfield::register( "toplayer", "player_cam_fire_init", 1, 1, "int", &player_cam_fire_init, true, true);
	clientfield::register( "toplayer", "player_cam_fire", 1, 7, "float", &player_cam_fire, true, true);
}


function player_cam_bubbles( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( newVal == 1 )
	{
		if ( isdefined (self.n_fx_id))
		{
			DeleteFX( localClientNum, self.n_fx_id, true );
		}
		self.n_fx_id = PlayFXOnCamera( localClientNum, "player/fx_plyr_swim_bubbles_body", (0,0,0), (1,0,0), (0,0,1) );
		self PlayRumbleOnEntity( localClientNum, "damage_heavy" );
	}
	else
	{
		if ( isdefined( self.n_fx_id ) )
		{
			DeleteFX( localClientNum, self.n_fx_id, true );
		}
	}
}

function player_cam_fire_init( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	SetDvar( "r_radioactiveFX_enable", newVal );
	
	if ( newVal == 0 )
	{
		SetDvar( "r_radioactiveIntensity", 0 );
	}
}

function player_cam_fire( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	n_intensity_amount = math::linear_map( newVal, 0.00, 1.00, 0.00, 4.00 );
	
	SetDvar( "r_radioactiveIntensity", n_intensity_amount );
}