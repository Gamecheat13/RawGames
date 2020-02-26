///////////////////////////////////////////////////////////////////
// _trap_electrical_box
//
// revision date: 10/23/07
// 
//	 Electrical Box Trap/Distraction
//		- creates damage effect
//		- flashbang effect TBD
//
///////////////////////////////////////////////////////////////////

#include maps\_utility;

// init electrical box traps
init()
{
	// precache
	trap_electrical_box_cache();

	// init bond awareness
	maps\_playerawareness::init();

	// check to see if fire extinguishers exist
	entaTemp = GetEntArray( "trap_electrical_box", "targetname" );
	if( IsDefined( entaTemp[0] ) )
	{
		trap_electrical_box_spc( entaTemp );
		maps\_playerawareness::setupArrayDamageOnly(	"trap_electrical_box",
														::trap_electrical_box,
														false,
														maps\_playerawareness::awarenessFilter_NoMeleeDamage,
														level.awarenessMaterialNone,
														false,
														false );
	}

	entaTemp = GetEntArray( "trap_electrical_box_glow", "targetname" );
	if( IsDefined( entaTemp[0] ) )
	{
		trap_electrical_box_spc( entaTemp );
		maps\_playerawareness::setupArrayDamageOnly(	"trap_electrical_box_glow",
														::trap_electrical_box,
														false,
														maps\_playerawareness::awarenessFilter_NoMeleeDamage,
														level.awarenessMaterialNone,
														true,
														true );
	}
}

// call back functioni on being damaged
trap_electrical_box( strcObject )
{
	// get primary entity
	entAwarenessObject = strcObject.primaryEntity;

	// get destroyed version
	entTrap_d = GetEnt( entAwarenessObject.target, "targetname" );

	// start distraction
	StartDistraction( entTrap_d.target, 0.0 );

	// ==== MM ====
	// play fx and do radius damage
	//Playfx( level._trap_fx["elec_box"], entAwarenessObject.origin );
	level notify("transformer_distraction");
	// ==== end MM ====
	
	
	RadiusDamage( entAwarenessObject.origin, 120, 250, 200 );
	wait( 0.05 );

	// switch models
	entTrap_d Show();
	entAwarenessObject Hide();
	entTrap_d trigger_on();
}

// cache electrical box assets
trap_electrical_box_cache()
{
	// ==== MM ==== don't need this, already precached in sciencecenter_a_fx.gsc - just need the notify to set it off
	// fx
	// level._trap_fx["elec_box"] = Loadfx( "maps/MiamiScienceCenter/science_transfrmr_shortcirc01" );
}

// special case function
trap_electrical_box_spc( entaTrap_d )
{
	for( i = 0; i < entaTrap_d.size; i++)
	{
		// hide destroyed version
		entTrap_d = GetEnt( entaTrap_d[i].target, "targetname" );
		entTrap_d Hide();
		entTrap_d trigger_off();
	}
}
