










#include maps\_utility;


init()
{
	
	trap_extinguisher_cache();

	
	maps\_playerawareness::init();

	
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


trap_extinguisher( strcObject )
{
	
	entExtinguisher = strcObject.primaryEntity;

	
	entExtinguisher thread extinguisher_fx();

	
	entExtinguisher PhysicsLaunch( strcObject.damagePoint, vector_multiply( strcObject.damageDirection, 2000 ) );

	
	entExtinguisher SetModel( "fx_fire_extinguisher_d4" );
	
	
	wait( 1.5 );
	CreateDistraction( "obvious", "", 0, 60, "", "", entExtinguisher.origin, 60, "" );

	
	entExtinguisher maps\_distract_object_small::distract_obj_setup( maps\_distraction::phys_push_ondmg, undefined );
}


extinguisher_fx()
{
	
	entOrigin = Spawn( "script_model", self.origin );
	entOrigin SetModel( "tag_origin" );
	entOrigin LinkTo( self );

	
	wait( 0.05 );
	PlayfxOnTag( level._trap_fx["extinguisher"], entOrigin, "tag_origin" );
	wait( 15 );
	entOrigin Delete();
}


trap_extinguisher_cache()
{
	
	PrecacheModel( "fx_fire_extinguisher_d4" );

	
	level._trap_fx["extinguisher"] = Loadfx( "smoke/fire_extinguisher" );
}
