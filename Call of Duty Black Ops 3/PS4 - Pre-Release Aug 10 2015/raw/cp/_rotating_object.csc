#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace rotating_object;

function autoexec __init__sytem__() {     system::register("rotating_object",&__init__,undefined,undefined);    }

/*
This script sets up functionality in multiplayer where an object can be rotated. It must be given the "rotating_object" targetname.
It must also have a script_float, which determines how many seconds it take for the object to complete a full 360 degree rotation.
This script is called by the _load.csc
*/
	
function __init__()
{
	callback::on_localclient_connect( &main );
}	

//Start a rotation thread on each object with the appropriate targetname and set a rotation speed dvar.
function main( localClientNum )
{
	rotating_objects = GetEntArray( localClientNum, "rotating_object", "targetname" );
	array::thread_all( rotating_objects,&rotating_object_think );
}

//Set up rotation behvahior. 'Self' is the rotating object. 	
function rotating_object_think()
{
	self endon ("entityshutdown");
	
	//I create this variable to manage what kind of rotate I want to use
	axis			= "yaw";
	direction		= 360;
	revolutions		= 100;
	rotate_time		= 12;
	
	if( isdefined( self.script_noteworthy ) )
	{
		axis = self.script_noteworthy;
	}

	if( isdefined( self.script_float ) ) 
	{
		//The script_float on the object determines how fast it spins, if it is defined
		rotate_time = self.script_float;
	}

	//Prevent SRE if zero were to be passed as a time value in the rotate function
	if ( rotate_time == 0 )
	{
		//Default spin speed
		rotate_time = 12;
	}

	if ( rotate_time < 0 )
	{
		direction *= -1;
		rotate_time *= -1;
	}
	
	angles = self.angles;
	
	while( 1 )
	{
		switch( axis )
		{
			case "roll":
				self RotateRoll( direction * revolutions, rotate_time * revolutions );
			break;

			case "pitch":
				self RotatePitch( direction * revolutions, rotate_time * revolutions );
			break;

			case "yaw":
			default:
				self RotateYaw( direction * revolutions, rotate_time * revolutions );
			break;
		}
		
		self waittill( "rotatedone" );
		self.angles = angles;
	}
}