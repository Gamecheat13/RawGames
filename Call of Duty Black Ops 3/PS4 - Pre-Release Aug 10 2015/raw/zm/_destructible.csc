#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                             
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
 

#namespace destructible;

function autoexec __init__sytem__() {     system::register("destructible",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "start_destructible_explosion", 1, 10, "int", &doExplosion, !true, !true );
}

function playGrenadeRumble(  localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	PlayRumbleOnPosition( localClientNum, "grenade_rumble", self.origin );
	GetLocalPlayer( localClientNum ) Earthquake( 0.5, 0.5, self.origin, 800 );
}

function doExplosion( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal == 0 )
	{
		return;
	}
	
	physics_explosion = false;
	
	if( newVal & ( 1 << ( 10 - 1 ) ) )
	{
		physics_explosion = true;
		
		newVal -= ( 1 << ( 10 - 1 ) ) ;
	}
	
	physics_force = 0.3;
		
	if( physics_explosion )
	{
		PhysicsExplosionSphere( localClientNum, self.origin, newVal, newVal - 1, physics_force, 25, 400 );
	}

	playGrenadeRumble( localClientNum, self.origin );
}