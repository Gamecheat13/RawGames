#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                       	     	                                                                                   

#namespace GibClientUtils;

function autoexec main()
{

	clientfield::register(
		"actor",
		"gib_state",
		1,
		(9),
		"int",
		&GibClientUtils::_GibHandler,
		!true,
		!true);

	clientfield::register(
		"playercorpse",
		"gib_state",
		1,
		(9+3+3),
		"int",
		&GibClientUtils::_GibHandler,
		!true,
		!true);

	gibDefinitions = struct::get_script_bundles("gibcharacterdef");
	
	gibPieceLookup = [];
	gibPieceLookup[2] = "annihilate";
	gibPieceLookup[8] = "head";
	gibPieceLookup[16] = "rightarm";
	gibPieceLookup[32] = "leftarm";
	gibPieceLookup[128] = "rightleg";
	gibPieceLookup[256] = "leftleg";
	
	processedBundles = [];
	
	// Process each gib bundle to allow quick access to information in the future.
	foreach ( definitionName, definition in gibDefinitions )
	{
		gibBundle = SpawnStruct();
		gibBundle.gibs = [];
		gibBundle.name = definitionName;
		
		foreach ( gibPieceFlag, gibPieceName in gibPieceLookup )
		{
			gibStruct = SpawnStruct();
			gibStruct.gibmodel = GetStructField( definition, gibPieceLookup[ gibPieceFlag ] + "_gibmodel" );
			gibStruct.gibtag = GetStructField( definition, gibPieceLookup[ gibPieceFlag ] + "_gibtag" );
			gibStruct.gibfx = GetStructField( definition, gibPieceLookup[ gibPieceFlag ] + "_gibfx" );
			gibStruct.gibfxtag = GetStructField( definition, gibPieceLookup[ gibPieceFlag ] + "_gibeffecttag" );
			gibStruct.gibdynentfx = GetStructField( definition, gibPieceLookup[ gibPieceFlag ] + "_gibdynentfx" );
			gibStruct.gibsound = GetStructField( definition, gibPieceLookup[ gibPieceFlag ] + "_gibsound" );
				
			gibBundle.gibs[ gibPieceFlag ] = gibStruct;
		}
		
		processedBundles[ definitionName ] = gibBundle;
	}
	
	// Replaces all gib character define bundles with their processed form to free unncessary script variables.
	level.scriptbundles[ "gibcharacterdef" ] = processedBundles;
	
	// Thread that handles any corpse annihilate request.
	level thread _AnnihilateCorpse();
}


function private _AnnihilateCorpse()
{
	while( true )
	{
		level waittill( "corpse_explode", localClientNum, body, origin );
		
		if ( !util::is_mature() || util::is_gib_restricted_build() )
		{
			continue;
		}
		
		// TODO(David Young 6-8-15): Human bodies are currently the only supported gibbable corpse.
		// Need to add support to the gib definition to flag if a corpse can be annihilated instead.
		if( IsDefined( body ) && _HasGibDef( body ) && body.archetype == "human" )
		{
			// Only allow human gibbing at a 50% rate.
			if ( RandomInt( 100 ) >= 50 )
			{
				continue;
			}
		
			if ( IsDefined( origin ) && DistanceSquared( body.origin, origin ) <= ( 120 * 120 ) )
			{
				// Toggle hiding the ragdoll.
				body.ignoreRagdoll = true;

				body _GibEntity(
					localClientNum,
					2 |
					16 |
					32 |
					(128+256),
					true );
			}
		}
	}
}

function private _GetGibDef( entity )
{
	if ( entity IsPlayer() || entity IsPlayerCorpse() )
	{
		return entity GetPlayerGibDef();
	}
	
	return entity.gibdef;
}

function private _GetGibbedState( localClientNum, entity )
{
	if ( IsDefined( entity.gib_state ) )
	{
		return entity.gib_state;
	}
	
	return 0;
}

function private _GibPieceTag( localClientNum, entity, gibFlag )
{
	if ( !_HasGibDef( self ) )
	{
		return;
	}
	
	gibBundle = struct::get_script_bundle("gibcharacterdef",_GetGibDef( entity ));
	gibPiece = gibBundle.gibs[ gibFlag ];
	
	if ( IsDefined( gibPiece ) )
	{
		return gibPiece.gibfxtag;
	}
}

function private _GibEntity( localClientNum, gibFlags, shouldSpawnGibs )
{
	entity = self;

	if ( !_HasGibDef( entity ) )
	{
		return;
	}
	
	// Skip the toggle flag, GIB_TOGGLE_GIB_MODEL_FLAG.
	currentGibFlag = 2;
	gibDir = undefined;
	
	if ( !(entity IsAI()) )
	{
		// TODO(David Young 6-8-15): Add support for yaw bits for AI as well.
		yaw_bits = ( ( gibFlags >> 9 ) & ( ( 1 << 3 ) - 1 ) );
		yaw = getanglefrombits( yaw_bits, 3 );
		gibDir = AnglesToForward( ( 0, yaw, 0 ) );
	}
	
	gibBundle = struct::get_script_bundle("gibcharacterdef",_GetGibDef( entity ));
	
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
					entity thread _GibPiece( localClientNum, entity, gibPiece.gibmodel, gibPiece.gibtag, gibPiece.gibdynentfx, gibDir );
				}
				
				_PlayGibFX( localClientNum, entity, gibPiece.gibfx, gibPiece.gibfxtag );
				_PlayGibSound( localClientNum, entity, gibPiece.gibsound );
				
				if ( currentGibFlag == 2 )
				{
					entity Hide();
					entity.ignoreRagdoll = true;
				}
			}
			
			_HandleGibCallbacks( localClientNum, entity, currentGibFlag );
		}
		
		currentGibFlag = currentGibFlag << 1;
	}
}

function private _GibHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( entity IsPlayer() || entity IsPlayerCorpse() )
	{
		if ( !util::is_mature() || util::is_gib_restricted_build() )
		{
			return;
		}
	}
	else if ( IsDefined( entity.maturegib ) && entity.maturegib )
	{
		if ( !util::is_mature() || util::is_gib_restricted_build() )
		{
			return;
		}
	}
	
	gibFlags = (oldValue ^ newValue);
	shouldSpawnGibs = (!(newValue & 1));
	
	// Don't use the old clientfield value for new entities.
	if ( bNewEnt )
	{
		gibFlags = (0 ^ newValue);
	}
	
	entity _GibEntity( localClientNum, gibFlags, shouldSpawnGibs );
	
	entity.gib_state = newValue;
}

function _GibPiece( localClientNum, entity, gibModel, gibTag, gibFx, gibDir )
{
	if ( !IsDefined( gibTag ) || !IsDefined( gibModel ) )
	{
		return;
	}

	startPosition = entity GetTagOrigin( gibTag );
	startAngles = entity GetTagAngles( gibTag );
	endPosition = startPosition;
	endAngles = startAngles;
	forwardVector = undefined;
	
	if ( !IsDefined( startPosition ) || !IsDefined( startAngles ) )
	{
		return false;
	}
	
	if ( IsDefined( gibDir ) )
	{
		startPosition = (0,0,0);
		forwardVector = gibDir;
		// TODO: define the scale on the server from the damage
		forwardVector *= RandomFloatRange( 100.0, 500.0 );
	}
	else
	{
		// Let a frame pass to approximate the linear and angular velocity of the tag.
		{wait(.016);};
		
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
		
		if ( !IsDefined( endPosition ) || !IsDefined( endAngles ) )
		{
			return false;
		}
		
		forwardVector = VectorNormalize( endPosition - startPosition );
		forwardVector *= RandomFloatRange( 0.6, 1.0 );
		forwardVector += ( RandomFloatRange( 0, 0.2 ), RandomFloatRange( 0, 0.2 ), RandomFloatRange( 0.2, 0.7 ) );
	}
	
	CreateDynEntAndLaunch(
		localClientNum, gibModel, endPosition, endAngles, startPosition, forwardVector, gibFx, true );
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

function private _HasGibDef( entity )
{
	return IsDefined(entity.gibdef) || ((entity GetPlayerGibDef()) != "unknown");
}

function _PlayGibFX( localClientNum, entity, fxFileName, fxTag )
{
	if ( IsDefined( fxFileName ) && IsDefined( fxTag ) )
	{
		fx = PlayFxOnTag( localClientNum, fxFileName, entity, fxTag );
		SetFxTeam( localClientNum, fx, entity.team );
		return fx;
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

function GibEntity( localClientNum, gibFlags )
{	
	self _GibEntity( localClientNum, gibFlags, true );
	
	self.gib_state = (_GetGibbedState( localClientNum, self ) | ( gibFlags & ( ( 1 << 9 ) - 1 ) ));
}

function PlayerGibLeftArm( localClientNum )
{	
	self GibEntity( localClientNum, 32 );
}

function PlayerGibRightArm( localClientNum )
{
	self GibEntity( localClientNum, 16 );
}

function PlayerGibLeftLeg( localClientNum )
{
	self GibEntity( localClientNum, 256 );
}

function PlayerGibRightLeg( localClientNum )
{
	self GibEntity( localClientNum, 128 );
}

function PlayerGibLegs( localClientNum )
{
	self GibEntity( localClientNum, 128 );
	self GibEntity( localClientNum, 256 );
}

function PlayerGibTag( localClientNum, gibFlag )
{	
	return _GibPieceTag( localClientNum, self, gibFlag );
}

