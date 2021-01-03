                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

//#using scripts\zm\_zm_utility;

#namespace zm_zod_util;


///////////////////////////////////////
// RUMBLES
///////////////////////////////////////

function player_rumble_and_shake( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )  //self = player
{
	self endon( "disconnect" );

	// light rumble for when player is on generator platform
	if ( newVal == 4 )
	{
		self thread player_continuous_rumble( LocalClientNum, 1 );
	}
	else if ( newVal == 5 )
	{
		self notify( "stop_rumble_and_shake" ); // end the continuous rumble
		self Earthquake( 0.6, 1.5, self.origin, 100 );
		self PlayRumbleOnEntity( LocalClientNum, "artillery_rumble" );
	}
	else if ( newVal == 3 )
	{
		self Earthquake( 0.6, 1.5, self.origin, 100 );
		self PlayRumbleOnEntity( LocalClientNum, "artillery_rumble" );
	}
	else if ( newVal == 2 )
	{
		self Earthquake( 0.3, 1.5, self.origin, 100 );
		self PlayRumbleOnEntity( LocalClientNum, "shotgun_fire" );
	}
	else if ( newVal == 1 )
	{
		self Earthquake( 0.1, 1.0, self.origin, 100 );
		self PlayRumbleOnEntity( LocalClientNum, "damage_heavy" );
	}
	else if ( newVal == 6 )
	{
		self thread player_continuous_rumble( LocalClientNum, 1, false );
	}
	else	// RUMBLE_NONE
	{
		self notify( "stop_rumble_and_shake" );
	}
}

// Self == player
function player_continuous_rumble( LocalClientNum, rumble_level, shake_camera = true )
{
	self notify( "stop_rumble_and_shake" );
	self endon( "disconnect" );
	self endon( "stop_rumble_and_shake" );
			
	while( 1 )
	{
		if ( IsDefined( self ) && self IsLocalPlayer() && IsDefined( self ) )
		{
			if ( rumble_level == 1 )
			{
				if ( shake_camera )
				{
					self Earthquake( 0.2, 1.0, self.origin, 100 );
				}
				
				self PlayRumbleOnEntity( LocalClientNum, "reload_small" );
				
				// add a little more delay so it doesn't feel so strong.
				wait 0.05;
			}
			else // if ( rumble_level == 2 )
			{
				if ( shake_camera )
				{
					self Earthquake( 0.3, 1.0, self.origin, 100 );
				}
				
				self PlayRumbleOnEntity( LocalClientNum, "damage_light" );
			}
		}
		
		wait 0.1;
	}	
}
