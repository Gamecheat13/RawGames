#include clientscripts\mp\_utility;

/*
This script sets up functionality in multiplayer where an object can be rotated. It must be given the "rotating_object" targetname.
It must also have a script_float, which determines how many seconds it take for the object to complete a full 360 degree rotation.
This script is called by the _load.csc
*/

//Start a rotation thread on each object with the appropriate targetname and set a rotation speed dvar.
init( localClientNum )
{
	rotating_objects = GetEntArray( localClientNum, "rotating_object", "targetname" );
	array_thread( rotating_objects, ::rotating_object_think );
}

//Set up rotation behvahior. 'Self' is the rotating object. 	
rotating_object_think()
{
	self endon ("entityshutdown");
	
	//I create this variable to manage what kind of rotate I want to use
	axis			= "yaw";
	direction		= 360;
	revolutions		= 1000;
	rotate_time		= GetDvarFloat( "scr_rotating_objects_secs" );
	
	if( IsDefined( self.script_noteworthy ) )
	{
		axis = self.script_noteworthy;
	}

	if( IsDefined( self.script_float ) ) 
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
	}
}
