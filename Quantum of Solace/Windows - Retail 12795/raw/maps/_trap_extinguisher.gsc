///////////////////////////////////////////////////////////////////
// _trap_extinguisher
//
// revision date: 10/23/07
// 
//	 Fire Extinguisher Trap/Distraction
//		- extinguisher creates a smoke grenade effect
//		- flashbang effect TBD
//
///////////////////////////////////////////////////////////////////

#include maps\_utility;

// init all fire extinguisher traps
init()
{
	// precache
	trap_extinguisher_cache();

	// init bond awareness
	maps\_playerawareness::init();

	// check to see if fire extinguishers exist
	entaTemp = GetEntArray( "trap_extinguisher", "targetname" );
	if( IsDefined( entaTemp[0] ) )
	{
		maps\_playerawareness::setupArrayDamageOnly(	"trap_extinguisher",
														::trap_extinguisher,
														false,
														maps\_playerawareness::awarenessFilter_NoMeleeDamage,
														level.awarenessMaterialNone,
														false,
														false );
	}

	entaTemp = GetEntArray( "trap_extinguisher_glow", "targetname" );
	if( IsDefined( entaTemp[0] ) )
	{
		maps\_playerawareness::setupArrayDamageOnly(	"trap_extinguisher_glow",
														::trap_extinguisher,
														false,
														maps\_playerawareness::awarenessFilter_NoMeleeDamage,
														level.awarenessMaterialNone,
														true,
														true );
	}
}

// call back functioni on being damaged
trap_extinguisher( strcObject )
{
	// get primary entity
	entExtinguisher = strcObject.primaryEntity;

	// call fx
	entExtinguisher thread extinguisher_fx();

	// launch model into physics
	entExtinguisher PhysicsLaunch( strcObject.damagePoint, vector_multiply( strcObject.damageDirection, 2000 ) );

	// change to damage model
	entExtinguisher SetModel( "fx_fire_extinguisher_d4" );
	
	// start distraction
	wait( 1.5 );
	CreateDistraction( "obvious", "", 0, 60, "", "", entExtinguisher.origin, 60, "" );

	// setup reuse
	entExtinguisher maps\_distract_object_small::distract_obj_setup( maps\_distraction::phys_push_ondmg, undefined );
}

// extinguisher fx
extinguisher_fx()
{
	// set up tag origin
	entOrigin = Spawn( "script_model", self.origin );
	entOrigin SetModel( "tag_origin" );
	entOrigin LinkTo( self );

	// play f/x
	wait( 0.05 );
	PlayfxOnTag( level._trap_fx["extinguisher"], entOrigin, "tag_origin" );
	wait( 15 );
	entOrigin Delete();
}

// cache extinguisher assets
trap_extinguisher_cache()
{
	// models
	PrecacheModel( "fx_fire_extinguisher_d4" );

	// fx
	level._trap_fx["extinguisher"] = Loadfx( "smoke/fire_extinguisher" );
}
