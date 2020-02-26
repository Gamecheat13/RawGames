///////////////////////////////////////////////////////////////////
// _distraction
// revision date: 4/27/07
// 
//	  - sets up a repeatable distraction. temporary until an
//		automated distraction system comes online
//
//		distract_init() - initializes all distract triggers
//		stop_distract() - ai call back from the distraction system
//						  runs this function to stop the distraction
///////////////////////////////////////////////////////////////////

#include maps\_utility;

// grab and initialize all distract triggers
distract_init()
{
	// grab all distract triggers
	//entTrig = GetEntArray( "trig_distract", "targetname" );

	// setup distraction thinks
	//for( i = 0; i < entTrig.size; i++ )
	//{
	//	entTrig[i] thread distract_setup();
	//}
}

// distract module setup
// self == the distract trigger
distract_setup()
{
	//// setup the cursor hint
	////self sethintstring( self.cursorhint );

	//// get distraction node
	//nodDistract = GetNode( self.target, "targetname" );

	//// wait for trigger to trigger
	//self waittill( "trigger" );

	//// start distraction
	//iPrintLnBold( "Distraction Started" );
	////Playfx( level._effect["default_explosion"], nodDistract.origin );
	//StartDistraction( self.target, 3 );

	//// turn off trigger
	//self trigger_off();

	//// wait for deactivate and reactivate trigger and thread setup
	//level waittill( "stop_distraction" );
	//KillDistraction( self.target );
	//self trigger_on();
	//self thread distract_setup();
}

// wait for x seconds after an ai is distracted
// then stops distraction
stop_distract()
{
	//// endon conditions
	//level endon( "stop_distraction" );

	//// wait for x amount of time
	//wait( 10 );

	//// debug println text
	//if( IsDefined( self.targetname ) )
	//{
	//	iPrintLnBold( "Distraction stopped by " + self.targetname );
	//}
	//else
	//{
	//	iPrintLnBold( "Distraction stopped by AI" );
	//}


	//// notify end of distraction
	//level notify( "stop_distraction" );
}


///////////////////////////////////////////////////////////////////
// utility callback functions for mousetraps
///////////////////////////////////////////////////////////////////
// mousetrap damage callback for moving entities
phys_push_ondmg( strcObject )
{
	// get bottle
	entAwarenessObject = strcObject.primaryEntity;

	// set magnitude of physics launch
	fForce_mult = 10; 
	if ( IsDefined( entAwarenessObject.script_float ) )
	{
		fForce_mult = entAwarenessObject.script_float;
	}

	// launch model into physics
	entAwarenessObject PhysicsLaunch( strcObject.damagePoint, vector_multiply( strcObject.damageDirection, (fForce_mult*strcObject.damageAmount) ) );

	// get delay time before next interact
	fDelay = 1.5; 
	if ( IsDefined( entAwarenessObject.script_delay ) )
	{
		fDelay = entAwarenessObject.script_delay;
	}

	// get delay time before next interact
	bAlert = "subtle"; 
	if ( IsDefined( entAwarenessObject.script_alert ) )
	{
		bAlert = entAwarenessObject.script_alert;
	}

	// start distraction
	wait(fDelay);
	if( bAlert == "subtle" )
	{
		CreateDistraction( "subtle", "", 0, 60, "", "", entAwarenessObject.origin, 60, "" );
	}
	else if ( bAlert == "obvious" )
	{
		CreateDistraction( "obvious", "", 0, 60, "", "", entAwarenessObject.origin, 60, "" );
	}

	// setup interact
	entAwarenessObject maps\_distract_object_small::distract_obj_setup( maps\_distraction::phys_push_ondmg, undefined );
}