
















#include common_scripts\utility;
#include maps\_utility;


init()
{
	
	maps\_playerawareness::init();

	
	entaTemp = GetEntArray( "dstrc_obj_small", "targetname" );
	if( IsDefined( entaTemp[0] ) )
	{
		for( i=0; i<entaTemp.size; i++ )
		{
			
			entaTemp[i] thread dstrc_obj_small_coll();

			
			entaTemp[i] distract_obj_setup( ::dstrc_obj_small_dmg, ::dstrc_obj_small_use );
		}
	}

	entaTemp = GetEntArray( "dstrc_obj_small_glow", "targetname" );
	if( IsDefined( entaTemp[0] ) )
	{
		for( i=0; i<entaTemp.size; i++ )
		{
			
			entaTemp[i] thread dstrc_obj_small_coll();

			
			entaTemp[i] distract_obj_setup( ::dstrc_obj_small_dmg, ::dstrc_obj_small_use, true );
		}
	}
}


distract_obj_setup( ptDamage, ptUse, bAwareness )
{
	
	if(!IsDefined(self))
	{
		return;
	}

	
	if ( !IsDefined( bAwareness ) )
	{
		bAwareness = false;
	}

	
	strHint_string = "Press &&1 to use";
	if ( IsDefined( self.script_string ) )
	{
		strHint_string = self.script_string;
	}

	
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






dstrc_obj_small_dmg( strcObject )
{

	
	entAwarenessObject = strcObject.primaryEntity;

	/#
		if( GetDVarInt( "secr_camera_debug" ) == 1 )
		{	
			Print3d( entAwarenessObject.origin + (0, 0, 64), "DSTRCT OBJ DAMAGED", (0, 1, 0), 1, 1, 90 );
		}
	#/


	
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
	else
	{
		CreateDistraction( "obvious", "", 0, 60, "", "", entAwarenessObject.origin, 60, "" );
	}

	
	entAwarenessObject distract_obj_setup( ::dstrc_obj_small_dmg, ::dstrc_obj_small_use );
}


dstrc_obj_small_use( strcObject )
{

	
	entAwarenessObject = strcObject.primaryEntity;

	/#
		if( GetDVarInt( "secr_camera_debug" ) == 1 )
		{	
			Print3d( entAwarenessObject.origin + (0, 0, 64), "DSTRCT OBJ USED", (0, 1, 0), 1, 1, 90 );
		}
	#/

	
	vPlayer_to_object = AnglesToForward( VectortoAngles( entAwarenessObject.origin - level.player.origin ) );
	vPlayer_to_object = vPlayer_to_object + AnglesToUp( vPlayer_to_object );

	
	fForce_mult = 100; 
	if ( IsDefined( entAwarenessObject.script_int ) )
	{
		fForce_mult = entAwarenessObject.script_int;
	}

	
	entAwarenessObject PhysicsLaunch( entAwarenessObject.origin, vector_multiply( vPlayer_to_object, fForce_mult ) );

	
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
	else
	{
		CreateDistraction( "obvious", "", 0, 60, "", "", entAwarenessObject.origin, 60, "" );
	}

	
	entAwarenessObject distract_obj_setup( ::dstrc_obj_small_dmg, ::dstrc_obj_small_use );
}


dstrc_obj_small_coll()
{
	
	iRadius = 8;
	if ( IsDefined( self.script_radius ) )
	{
		iRadius = self.script_radius;
	}

	while( true )
	{
		
		if ( !sightTracePassed( self.origin, level.player GetEye(), false, undefined ) )
		{
			wait( 0.15 );
			continue;
		}

		
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
