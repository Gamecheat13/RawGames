#include common_scripts\utility;

global_FX( targetname, fxFile, delay, fxName, soundalias )
{
	// script_structs
	ents = getstructarray( targetname, "targetname" );
	if ( ents.size <= 0 )
		return;
	
	if ( ! IsDefined( delay ) )
		delay = RandomFloatRange( -20, -15 );
	
	if ( !IsDefined( fxName ) )
		fxName = fxFile;
	
	foreach ( fxEnt in ents )
	{
		if ( !IsDefined( level._effect ) )
			level._effect = [];
		if ( !IsDefined( level._effect[ fxName ] ) )
			level._effect[ fxName ]	= LoadFX( fxFile );
		
		// default effect angles if they dont exist
		if ( !IsDefined( fxEnt.angles ) )
			fxEnt.angles = ( 0, 0, 0 );
		
		ent				  = createOneshotEffect( fxName );
		ent.v[ "origin" ] = ( fxEnt.origin );
		ent.v[ "angles" ] = ( fxEnt.angles );
		ent.v[ "fxid"  ]  = fxName;
		ent.v[ "delay" ]  = delay;
		if ( IsDefined( soundalias ) )
			ent.v[ "soundalias" ] = soundalias;
	}
}