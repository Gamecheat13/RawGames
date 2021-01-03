#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                   

function autoexec main()
{
	clientfield::register(
		"actor",
		"gib_state",
		1,
		8,
		"int",
		&GibClientUtils::_GibHandler,
		!true,
		!true);

	gibDefinitions = struct::get_script_bundles( "gibcharacterdef" );
	
	// Process each gib bundle to allow quick access to information in the future.
	foreach ( definition in gibDefinitions )
	{
		// This is extremely hardcoded because scriptbundles return structs which can't be
		// indexed by a string.
		definition.gibs = [];

		flag = 1;

		for ( index = 0; index < 8; index++ )
		{
			definition.gibs[ flag ] = SpawnStruct();
			flag = flag << 1;
		}
		
		definition.gibs[4].gibmodel = definition.head_gibmodel;    definition.head_gibmodel = undefined;;
		definition.gibs[4].gibtag = definition.head_gibtag;    definition.head_gibtag = undefined;;
		definition.gibs[4].gibfx = definition.head_gibfx;    definition.head_gibfx = undefined;;
		definition.gibs[4].gibfxunderwater = definition.head_gibfxunderwater;    definition.head_gibfxunderwater = undefined;;
		definition.gibs[4].gibfxtag = definition.head_gibeffecttag;    definition.head_gibeffecttag = undefined;;
		definition.gibs[4].gibdynentfx = definition.head_gibdynentfx;    definition.head_gibdynentfx = undefined;;
		definition.gibs[4].gibdynentfxunderwater = definition.head_gibdynentfxunderwater;    definition.head_gibdynentfxunderwater = undefined;;
		definition.gibs[4].gibsound = definition.head_gibsound;    definition.head_gibsound = undefined;;
		definition.gibs[4].gibsoundunderwater = definition.head_gibsoundunderwater;    definition.head_gibsoundunderwater = undefined;;
		
		definition.gibs[8].gibmodel = definition.rightarm_gibmodel;    definition.rightarm_gibmodel = undefined;;
		definition.gibs[8].gibtag = definition.rightarm_gibtag;    definition.rightarm_gibtag = undefined;;
		definition.gibs[8].gibfx = definition.rightarm_gibfx;    definition.rightarm_gibfx = undefined;;
		definition.gibs[8].gibfxunderwater = definition.rightarm_gibfxunderwater;    definition.rightarm_gibfxunderwater = undefined;;
		definition.gibs[8].gibfxtag = definition.rightarm_gibeffecttag;    definition.rightarm_gibeffecttag = undefined;;
		definition.gibs[8].gibdynentfx = definition.rightarm_gibdynentfx;    definition.rightarm_gibdynentfx = undefined;;
		definition.gibs[8].gibdynentfxunderwater = definition.rightarm_gibdynentfxunderwater;    definition.rightarm_gibdynentfxunderwater = undefined;;
		definition.gibs[8].gibsound = definition.rightarm_gibsound;    definition.rightarm_gibsound = undefined;;
		definition.gibs[8].gibsoundunderwater = definition.rightarm_gibsoundunderwater;    definition.rightarm_gibsoundunderwater = undefined;;
		
		definition.gibs[16].gibmodel = definition.leftarm_gibmodel;    definition.leftarm_gibmodel = undefined;;
		definition.gibs[16].gibtag = definition.leftarm_gibtag;    definition.leftarm_gibtag = undefined;;
		definition.gibs[16].gibfx = definition.leftarm_gibfx;    definition.leftarm_gibfx = undefined;;
		definition.gibs[16].gibfxunderwater = definition.leftarm_gibfxunderwater;    definition.leftarm_gibfxunderwater = undefined;;
		definition.gibs[16].gibfxtag = definition.leftarm_gibeffecttag;    definition.leftarm_gibeffecttag = undefined;;
		definition.gibs[16].gibdynentfx = definition.leftarm_gibdynentfx;    definition.leftarm_gibdynentfx = undefined;;
		definition.gibs[16].gibdynentfxunderwater = definition.leftarm_gibdynentfxunderwater;    definition.leftarm_gibdynentfxunderwater = undefined;;
		definition.gibs[16].gibsound = definition.leftarm_gibsound;    definition.leftarm_gibsound = undefined;;
		definition.gibs[16].gibsoundunderwater = definition.leftarm_gibsoundunderwater;    definition.leftarm_gibsoundunderwater = undefined;;
		
		definition.gibs[64].gibmodel = definition.rightleg_gibmodel;    definition.rightleg_gibmodel = undefined;;
		definition.gibs[64].gibtag = definition.rightleg_gibtag;    definition.rightleg_gibtag = undefined;;
		definition.gibs[64].gibfx = definition.rightleg_gibfx;    definition.rightleg_gibfx = undefined;;
		definition.gibs[64].gibfxunderwater = definition.rightleg_gibfxunderwater;    definition.rightleg_gibfxunderwater = undefined;;
		definition.gibs[64].gibfxtag = definition.rightleg_gibeffecttag;    definition.rightleg_gibeffecttag = undefined;;
		definition.gibs[64].gibdynentfx = definition.rightleg_gibdynentfx;    definition.rightleg_gibdynentfx = undefined;;
		definition.gibs[64].gibdynentfxunderwater = definition.rightleg_gibdynentfxunderwater;    definition.rightleg_gibdynentfxunderwater = undefined;;
		definition.gibs[64].gibsound = definition.rightleg_gibsound;    definition.rightleg_gibsound = undefined;;
		definition.gibs[64].gibsoundunderwater = definition.rightleg_gibsoundunderwater;    definition.rightleg_gibsoundunderwater = undefined;;
		
		definition.gibs[128].gibmodel = definition.leftleg_gibmodel;    definition.leftleg_gibmodel = undefined;;
		definition.gibs[128].gibtag = definition.leftleg_gibtag;    definition.leftleg_gibtag = undefined;;
		definition.gibs[128].gibfx = definition.leftleg_gibfx;    definition.leftleg_gibfx = undefined;;
		definition.gibs[128].gibfxunderwater = definition.leftleg_gibfxunderwater;    definition.leftleg_gibfxunderwater = undefined;;
		definition.gibs[128].gibfxtag = definition.leftleg_gibeffecttag;    definition.leftleg_gibeffecttag = undefined;;
		definition.gibs[128].gibdynentfx = definition.leftleg_gibdynentfx;    definition.leftleg_gibdynentfx = undefined;;
		definition.gibs[128].gibdynentfxunderwater = definition.leftleg_gibdynentfxunderwater;    definition.leftleg_gibdynentfxunderwater = undefined;;
		definition.gibs[128].gibsound = definition.leftleg_gibsound;    definition.leftleg_gibsound = undefined;;
		definition.gibs[128].gibsoundunderwater = definition.leftleg_gibsoundunderwater;    definition.leftleg_gibsoundunderwater = undefined;;
	}	
}

#namespace GibClientUtils;

function private _GetGibbedState( localClientNum, entity )
{
	if ( IsDefined( entity.gib_state ) )
	{
		return entity.gib_state;
	}
	
	return 0;
}

function private _GibHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	gibFlags = (oldValue ^ newValue);
	shouldSpawnGibs = (!(newValue & 1));
	
	// Don't use the old clientfield value for new entities.
	if ( bNewEnt )
	{
		gibFlags = (0 ^ newValue);
	}
	
	if ( !IsDefined(entity.gibdef) )
	{
		return;
	}
	
	// Skip the toggle flag, GIB_TOGGLE_GIB_MODEL_FLAG.
	currentGibFlag = 2;
	
	gibBundle = struct::get_script_bundle( "gibcharacterdef", entity.gibdef );
	
	underWater = entity UnderWater();
	
	// Handles any number of simultaneous gibbings.
	while ( gibFlags >= currentGibFlag )
	{
		if ( gibFlags & currentGibFlag )
		{
			gibPiece = gibBundle.gibs[ currentGibFlag ];
		
			if ( IsDefined( gibPiece ) )
			{
				if ( shouldSpawnGibs )
				{
					if ( !underWater )
					{
						entity thread _GibPiece(
							localClientNum, entity, gibPiece.gibmodel, gibPiece.gibtag, gibPiece.gibdynentfx );
					}
					else
					{
						entity thread _GibPiece(
							localClientNum, entity, gibPiece.gibmodel, gibPiece.gibtag, gibPiece.gibdynentfxunderwater );
					}
				}
				
				if ( !underWater )
				{
					_PlayGibFX( localClientNum, entity, gibPiece.gibfx, gibPiece.gibfxtag );
					_PlayGibSound( localClientNum, entity, gibPiece.gibsound );
				}
				else
				{
					_PlayGibFX( localClientNum, entity, gibPiece.gibfxunderwater, gibPiece.gibfxtag );
					_PlayGibSound( localClientNum, entity, gibPiece.gibsoundunderwater );
				}
			}
			
			_HandleGibCallbacks( localClientNum, entity, currentGibFlag );
		}
		
		currentGibFlag = currentGibFlag << 1;
	}
	
	entity.gib_state = newValue;
}

function _GibPiece( localClientNum, entity, gibModel, gibTag, gibFx )
{
	if ( !IsDefined( gibTag ) || !IsDefined( gibModel ) )
	{
		return;
	}

	startPosition = entity GetTagOrigin( gibTag );
	startAngles = entity GetTagAngles( gibTag );
	
	wait( 0.016 );
	
	if ( IsDefined( entity ) )
	{
		endPosition = entity GetTagOrigin( gibTag );
		endAngles = entity GetTagAngles( gibTag );
	}
	else
	{
		// Entity already removed.
		endPosition = startPosition + ( AnglesToForward( startAngles ) * 10 );
		endAngles = startAngles;
	}
	
	if ( !IsDefined( startPosition ) || !IsDefined( startAngles ) ||
		!IsDefined( endPosition ) || !IsDefined( endAngles ) )
	{
		return false;
	}
	
	forwardVector = VectorNormalize( endPosition - startPosition );
	forwardVector *= RandomFloatRange( 0.6, 1.0 );
	forwardVector += ( RandomFloatRange( 0, 0.2 ), RandomFloatRange( 0, 0.2 ), RandomFloatRange( 0.2, 0.7 ) );

	if ( IsDefined( gibFx ) )
	{
		CreateDynEntAndLaunch(
			localClientNum, gibModel, endPosition, endAngles, startPosition, forwardVector, gibFx );
	}
	else
	{
		CreateDynEntAndLaunch(
			localClientNum, gibModel, endPosition, endAngles, startPosition, forwardVector );
	}
}

function private _HandleGibCallbacks( localClientNum, entity, gibFlag )
{
	if ( IsDefined( entity._gibCallbacks ) &&
		IsDefined( entity._gibCallbacks[gibFlag] ) )
	{
		foreach ( callback in entity._gibCallbacks[gibFlag] )
		{
			[[callback]]( localClientNum, entity, gibFlag );
		}
	}
}

function _PlayGibFX( localClientNum, entity, fxFileName, fxTag )
{
	if ( IsDefined( fxFileName ) && IsDefined( fxTag ) )
	{
		return PlayFxOnTag( localClientNum, fxFileName, entity, fxTag );
	}
}

function _PlayGibSound( localClientNum, entity, soundAlias )
{
	if ( IsDefined( soundAlias ) )
	{
		PlaySound( localClientNum, soundAlias, entity.origin );
	}
}

/@
"Name: AddGibCallback( localClientNum, entity, gibFlag, callbackFunction )"
"Summary: Register a function callback that is called when the corresponding piece is gibbed."
"MandatoryArg: <num> : Client number."
"MandatoryArg: <entity> : Entity to add callbacks to."
"MandatoryArg: <num> : Gib piece to register for."
"MandatoryArg: <function> : Function to call, function is passed the localClientNum, entity, and gibFlag."
"Module: Gib"
@/
function AddGibCallback( localClientNum, entity, gibFlag, callbackFunction )
{
	assert( IsFunctionPtr( callbackFunction ) );

	if ( !IsDefined( entity._gibCallbacks ) )
	{
		entity._gibCallbacks = [];
	}

	if ( !IsDefined( entity._gibCallbacks[gibFlag] ) )
	{
		entity._gibCallbacks[gibFlag] = [];
	}
	
	gibCallbacks = entity._gibCallbacks[gibFlag];
	gibCallbacks[gibCallbacks.size] = callbackFunction;
	entity._gibCallbacks[gibFlag] = gibCallbacks;
}

function IsGibbed( localClientNum, entity, gibFlag )
{
	return (_GetGibbedState( localClientNum, entity ) & gibFlag);
}

function IsUndamaged( localClientNum, entity )
{
	return _GetGibbedState( localClientNum, entity ) == 0;
}