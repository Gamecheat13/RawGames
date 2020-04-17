///////////////////////////////////////////////////////////////////
// _distract_object_small
//
// revision date: 10/26/07
// 
//	 small object distraction
//		- use or shoot small object to create a subtle distraction
//
//	Keys
//		script_string - use hint string (defaults to "Press &&1 to use")
//		script_float - magnitude of force to damage the object (default 100)
//		script_int - magnitude of force to use on object (default 100)
//		script_radius - distance to player before going into physics (default 8)
//		script_delay - time delay between being able to be used used/damaged/walked on (default 1.5)
//		script_alert - set the distraction for "subtle" or "obvious" (default "subtle")
//
///////////////////////////////////////////////////////////////////
#include common_scripts\utility;
#include maps\_utility;

// init all fire extinguisher traps
init()
{
	// init bond awareness
	maps\_playerawareness::init();

	// get distraction objects and init
	entaTemp = GetEntArray( "dstrc_obj_small", "targetname" );
	if( IsDefined( entaTemp[0] ) )
	{
		for( i=0; i<entaTemp.size; i++ )
		{
			// start coll check
			entaTemp[i] thread dstrc_obj_small_coll();

			// set interact
			entaTemp[i] distract_obj_setup( ::dstrc_obj_small_dmg, ::dstrc_obj_small_use );
		}
	}

	entaTemp = GetEntArray( "dstrc_obj_small_glow", "targetname" );
	if( IsDefined( entaTemp[0] ) )
	{
		for( i=0; i<entaTemp.size; i++ )
		{
			// start coll check
			entaTemp[i] thread dstrc_obj_small_coll();

			// set interact
			entaTemp[i] distract_obj_setup( ::dstrc_obj_small_dmg, ::dstrc_obj_small_use, true );
		}
	}
}

// setup the use of distract
distract_obj_setup( ptDamage, ptUse, bAwareness )
{
	// check for defined entity
	if(!IsDefined(self))
	{
		return;
	}

	// set default awareness to false
	if ( !IsDefined( bAwareness ) )
	{
		bAwareness = false;
	}

	// set hint string
	strHint_string = "Press &&1 to use";
	if ( IsDefined( self.script_string ) )
	{
		strHint_string = self.script_string;
	}

	// set interact
	maps\_playerawareness::setupEntSingle(	self,
											ptDamage,
											false,
											ptUse,
											strHint_string,
											undefined,
											undefined,
											true,
											true,
											undefined,
											level.awarenessMaterialNone,
											bAwareness,
											bAwareness,
											false );
}


///////////////////////////////////////////////////////////////////
// Call back functions for distract objects
///////////////////////////////////////////////////////////////////
// call back function on being damaged
dstrc_obj_small_dmg( strcObject )
{

	// get bottle
	entAwarenessObject = strcObject.primaryEntity;

	/#
		if( GetDVarInt( "secr_camera_debug" ) == 1 )
		{	
			Print3d( entAwarenessObject.origin + (0, 0, 64), "DSTRCT OBJ DAMAGED", (0, 1, 0), 1, 1, 90 );
		}
	#/


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
	else
	{
		CreateDistraction( "obvious", "", 0, 60, "", "", entAwarenessObject.origin, 60, "" );
	}

	// setup interact
	entAwarenessObject distract_obj_setup( ::dstrc_obj_small_dmg, ::dstrc_obj_small_use );
}

// call back function on being used
dstrc_obj_small_use( strcObject )
{

	// get bottle
	entAwarenessObject = strcObject.primaryEntity;

	/#
		if( GetDVarInt( "secr_camera_debug" ) == 1 )
		{	
			Print3d( entAwarenessObject.origin + (0, 0, 64), "DSTRCT OBJ USED", (0, 1, 0), 1, 1, 90 );
		}
	#/

	// get vector of player to object
	vPlayer_to_object = AnglesToForward( VectortoAngles( entAwarenessObject.origin - level.player.origin ) );
	vPlayer_to_object = vPlayer_to_object + AnglesToUp( vPlayer_to_object );

	// set magnitude of physics launch
	fForce_mult = 100; 
	if ( IsDefined( entAwarenessObject.script_int ) )
	{
		fForce_mult = entAwarenessObject.script_int;
	}

	// launch model into physics
	entAwarenessObject PhysicsLaunch( entAwarenessObject.origin, vector_multiply( vPlayer_to_object, fForce_mult ) );

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
	else
	{
		CreateDistraction( "obvious", "", 0, 60, "", "", entAwarenessObject.origin, 60, "" );
	}

	// setup interact
	entAwarenessObject distract_obj_setup( ::dstrc_obj_small_dmg, ::dstrc_obj_small_use );
}

// knock over object if player gets to close
dstrc_obj_small_coll()
{
	// set default distance
	iRadius = 8;
	if ( IsDefined( self.script_radius ) )
	{
		iRadius = self.script_radius;
	}

	while( true )
	{
		// check to see if Player is in LOS
		if ( !sightTracePassed( self.origin, level.player GetEye(), false, undefined ) )
		{
			wait( 0.15 );
			continue;
		}

		// check distance to players
		if( iRadius > Distance2D( self.origin, level.player.origin ) )
		{
			self DoDamage( 10, level.player.origin );
			/#
				if( GetDVarInt( "secr_camera_debug" ) == 1 )
				{	
					Print3d( self.origin + (0, 0, 64), "DSTRCT OBJ COLLISION", (0, 1, 0), 1, 1, 90 );
				}
			#/
		}
		
		wait( 0.15 );
	}
}
