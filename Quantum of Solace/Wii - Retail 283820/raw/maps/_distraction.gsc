











#include maps\_utility;


distract_init()
{
	
	

	
	
	
	
	
}



distract_setup()
{
	
	

	
	

	
	

	
	
	
	

	
	

	
	
	
	
	
}



stop_distract()
{
	
	

	
	

	
	
	
	
	
	
	
	
	


	
	
}






phys_push_ondmg( strcObject )
{
	
	entAwarenessObject = strcObject.primaryEntity;

	
	fForce_mult = 10; 
	if ( IsDefined( entAwarenessObject.script_float ) )
	{
		fForce_mult = entAwarenessObject.script_float;
	}

	
	entAwarenessObject PhysicsLaunch( strcObject.damagePoint, vector_multiply( strcObject.damageDirection, (fForce_mult*strcObject.damageAmount) ) );

	
	fDelay = 1.5; 
	if ( IsDefined( entAwarenessObject.script_delay ) )
	{
		fDelay = entAwarenessObject.script_delay;
	}

	
	bAlert = "subtle"; 
	if ( IsDefined( entAwarenessObject.script_alert ) )
	{
		bAlert = entAwarenessObject.script_alert;
	}

	
	wait(fDelay);
	if( bAlert == "subtle" )
	{
		CreateDistraction( "subtle", "", 0, 60, "", "", entAwarenessObject.origin, 60, "" );
	}
	else if ( bAlert == "obvious" )
	{
		CreateDistraction( "obvious", "", 0, 60, "", "", entAwarenessObject.origin, 60, "" );
	}

	
	entAwarenessObject maps\_distract_object_small::distract_obj_setup( maps\_distraction::phys_push_ondmg, undefined );
}