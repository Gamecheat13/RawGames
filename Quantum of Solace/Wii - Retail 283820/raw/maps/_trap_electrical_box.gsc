










#include maps\_utility;


init()
{
	
	trap_electrical_box_cache();

	
	maps\_playerawareness::init();

	
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


trap_electrical_box( strcObject )
{
	
	entAwarenessObject = strcObject.primaryEntity;

	
	entTrap_d = GetEnt( entAwarenessObject.target, "targetname" );

	
	StartDistraction( entTrap_d.target, 0.0 );

	
	
	
	level notify("transformer_distraction");
	
	
	
	RadiusDamage( entAwarenessObject.origin, 120, 250, 200 );
	wait( 0.05 );

	
	entTrap_d Show();
	entAwarenessObject Hide();
	entTrap_d trigger_on();
}


trap_electrical_box_cache()
{
	
	
	
}


trap_electrical_box_spc( entaTrap_d )
{
	for( i = 0; i < entaTrap_d.size; i++)
	{
		
		entTrap_d = GetEnt( entaTrap_d[i].target, "targetname" );
		entTrap_d Hide();
		entTrap_d trigger_off();
	}
}
