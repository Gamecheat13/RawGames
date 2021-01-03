#using scripts\shared\clientfield_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                           

#precache( "client_fx", "animals/fx_bio_direwolf_eyes" );

#namespace ArchetypeDirewolf;

function autoexec precache()
{
	level._effect[ "fx_bio_direwolf_eyes" ] = "animals/fx_bio_direwolf_eyes";
}

function autoexec main()
{
	clientfield::register(
		"actor",
		"direwolf_eye_glow_fx",
		1,
		1,
		"int",
		&direwolfEyeGlowFxHandler,
		!true,
		true );
}

function private direwolfEyeGlowFxHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( IsDefined( entity.archetype ) && entity.archetype != "direwolf" )
	{
		return;
	}
	
	if ( IsDefined( entity.eyeGlowFx ) )
	{
		StopFx( localClientNum, entity.eyeGlowFx );
		entity.eyeGlowFx = undefined;
	}

	if ( newValue )
	{
		entity.eyeGlowFx = PlayFxOnTag( localClientNum, level._effect[ "fx_bio_direwolf_eyes" ], entity, "tag_eye" );
	}
}
