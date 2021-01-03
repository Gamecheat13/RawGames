#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                             
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
 

#namespace destructible;

function autoexec __init__sytem__() {     system::register("destructible",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "start_destructible_explosion", 1, 11, "int", &doExplosion, !true, !true );
}

function playGrenadeRumble(  localClientNum, position )
{
	PlayRumbleOnPosition( localClientNum, "grenade_rumble", position );
	GetLocalPlayer( localClientNum ) Earthquake( 0.5, 0.5, position, 800 );
}

function doExplosion( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 0 )
	{
		return;
	}
	
	inner_is_half_outer = newVal & ( 1 << ( 11 - 1 ) );

	if( inner_is_half_outer )
	{
		newVal -= ( 1 << ( 11 - 1 ) );
	}

	physics_force = 0.3;
	
	is_lg_explosion = newVal & ( 1 << ( 11 - 2 ) );
	
	if( is_lg_explosion )
	{
		physics_force = 0.5;
		
		newVal -= ( 1 << ( 11 - 2 ) );
	}
	
	//if the inner_is_half_outer is set
	if( ( isdefined( inner_is_half_outer ) && inner_is_half_outer ) )
	{
		PhysicsExplosionSphere( localClientNum, self.origin, newVal, newVal / 2, physics_force, 25, 400 );
	}
	else
	{
		PhysicsExplosionSphere( localClientNum, self.origin, newVal, newVal - 1, physics_force, 25, 400 );
	}

	playGrenadeRumble( localClientNum, self.origin );
}