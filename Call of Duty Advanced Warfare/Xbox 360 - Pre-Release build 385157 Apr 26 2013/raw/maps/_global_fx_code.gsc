#include common_scripts\utility;
#include maps\_utility;

/*
=============
///ScriptDocBegin
"Name: global_FX( <targetname> , <fxFile> , <delay> , <fxName> , <soundalias> )"
"Summary: Applies an Effect Globally to script_structs with specified targetname"
"Module: Entity"
"CallOn: Nothing"
"MandatoryArg: <targetname>: targetname on the script_struct to play the effect on"
"MandatoryArg: <fxFile>: location of the effect"
"OptionalArg: <delay>: this will offset the delay by this much, usually a negative time to prime the effect defaults to random per effect -20 to -15"
"OptionalArg: <fxName>: sets level._effect id, if unspecified it will just be the same as the effect name."
"OptionalArg: <soundalias>: set a sound to go with it."
"Example: global_FX( "me_streetlight_01_FX_origin"         , "fx/misc/lighthaze_bog_a" );"
"SPMP: both"
"NoteLine: This is read by the CSV repackager, so you simply Repackage Zone for the effect asset to be added to your level. "
///ScriptDocEnd
=============
*/
global_FX( targetname, fxFile, delay, fxName, soundalias )
{
	// I've wired this into "Repackage Zone" checkbox in the compile tab on IW_Launcher. If you want to change this you'll have to get the repackager updated too. - Nate
	if ( !IsDefined( level._effect ) )
		level._effect = [];
	
	level.global_FX[ targetname ] = fxName;
	
	ents = getstructarray_delete( targetname, "targetname" );
	if ( !IsDefined( ents ) )
		return;
	if ( !ents.size )
		return;
	
	if ( !IsDefined( fxName ) )
		fxName = fxFile;
	
	if ( !IsDefined( delay ) )
		delay = RandomFloatRange( -20, -15 );

	foreach ( fxEnt in ents )
	{
		if ( !IsDefined( level._effect[ fxName ] ) )
			level._effect[ fxName ]	 = LoadFX( fxFile );
	
		// default effect angles if they dont exist
		if ( !IsDefined( fxEnt.angles ) )
			fxEnt.angles = ( 0, 0, 0 );
	
		ent				  = createOneshotEffect( fxName );
		ent.v[ "origin" ] = fxEnt.origin;
		ent.v[ "angles" ] = fxEnt.angles;
		ent.v[ "fxid"	] = fxName;
		ent.v[ "delay"	] = delay;
		
		if ( IsDefined( soundalias ) )
			ent.v[ "soundalias" ] = soundalias;
		
		if ( !IsDefined( fxEnt.script_noteworthy ) )
			continue;

		note = fxEnt.script_noteworthy;
		if ( !IsDefined( level._global_fx_ents[ note ] ) )
			level._global_fx_ents[ note ] = [];
		level._global_fx_ents[ note ][ level._global_fx_ents[ note ].size ] = ent;
	}
}

init()
{
	if ( !IsDefined( level.global_FX ) )
		level.global_FX	  = [];
	level._global_fx_ents = [];
	
}