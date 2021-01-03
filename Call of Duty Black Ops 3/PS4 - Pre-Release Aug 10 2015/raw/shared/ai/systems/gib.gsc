#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                       	     	                                                                                   

function autoexec main()
{
	clientfield::register(
		"actor",
		"gib_state",
		1,
		(9),
		"int" );

	clientfield::register(
		"playercorpse",
		"gib_state",
		1,
		(9+3+3),
		"int" );
		
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
			gibStruct.gibhidetag = GetStructField( definition, gibPieceLookup[ gibPieceFlag ] + "_gibhidetag" );
				
			gibBundle.gibs[ gibPieceFlag ] = gibStruct;
		}
		
		processedBundles[ definitionName ] = gibBundle;
	}
	
	// Replaces all gib character define bundles with their processed form to free unncessary script variables.
	level.scriptbundles[ "gibcharacterdef" ] = processedBundles;
}

#namespace GibServerUtils;

function private _Annihilate( entity )
{
	if ( IsDefined( entity ) )
	{
		entity NotSolid();
	}
}

function private _GetGibExtraModel( entity, gibFlag )
{
	if ( gibFlag == 4 )
		return entity.hatmodel;
	else if ( gibFlag == 8 )
		return entity.head;
	else
		AssertMsg( "Unable to find gib model." );
}

// Used to solely gib equipment and the actor's head.
// Does not change the torso or leg models.
function private _GibExtra( entity, gibFlag )
{
	if ( IsGibbed( entity, gibFlag ) )
	{
		return false;
	}

	_SetGibbed( entity, gibFlag, undefined );

	gibModel = _GetGibExtraModel( entity, gibFlag );
	
	if ( IsDefined( gibModel ) )
	{
		DestructServerUtils::ShowDestructedPieces( entity );
		ShowHiddenGibPieces( entity );
		
		entity Detach( gibModel, "" );
		
		DestructServerUtils::ReapplyDestructedPieces( entity );
		ReapplyHiddenGibPieces( entity );
		
		return true;
	}
	
	return false;
}

// Used to gib torso or leg pieces, not including equipment or the actor's head.
// Changes the torso and leg models.
function private _GibEntity( entity, gibFlag )
{
	if ( IsGibbed( entity, gibFlag ) || !_HasGibPieces( entity, gibFlag ) )
	{
		return false;
	}
	
	DestructServerUtils::ShowDestructedPieces( entity );
	ShowHiddenGibPieces( entity );
	
	if ( !(_GetGibbedState( entity ) < 16) )
	{
		legModel = _GetGibbedLegModel( entity );
		entity Detach( legModel );
	}
	
	_SetGibbed( entity, gibFlag, undefined );
	
	entity SetModel( _GetGibbedTorsoModel( entity ) );
	entity Attach( _GetGibbedLegModel( entity ) );
	
	DestructServerUtils::ReapplyDestructedPieces( entity );
	ReapplyHiddenGibPieces( entity );
	
	return true;
}

function private _GetGibbedLegModel( entity )
{
	gibState = _GetGibbedState( entity );
	rightLegGibbed = (gibState & 128);
	leftLegGibbed = (gibState & 256);
	
	if ( rightLegGibbed && leftLegGibbed)
	{
		return entity.legDmg4;
	}
	else if ( rightLegGibbed )
	{
		return entity.legDmg2;
	}
	else if ( leftLegGibbed )
	{
		return entity.legDmg3;
	}
	
	return entity.legDmg1;
}

function private _GetGibbedState( entity )
{
	if ( IsDefined( entity.gib_state ) )
	{
		return entity.gib_state;
	}
	
	return 0;
}

function private _GetGibbedTorsoModel( entity )
{
	gibState = _GetGibbedState( entity );
	rightArmGibbed = (gibState & 16);
	leftArmGibbed = (gibState & 32);
	
	if ( rightArmGibbed && leftArmGibbed )
	{
		return entity.torsoDmg2;
		
		// TODO(David Young 5-14-14): Currently AI's don't support both arms getting blown off.
		// return GIB_TORSO_NO_ARMS_MODEL( entity );
	}
	else if ( rightArmGibbed )
	{
		return entity.torsoDmg2;
	}
	else if ( leftArmGibbed )
	{
		return entity.torsoDmg3;
	}
	
	return entity.torsoDmg1;
}

function private _HasGibDef( entity )
{
	return IsDefined( entity.gibdef );
}

function private _HasGibPieces( entity, gibFlag )
{
	hasGibPieces = false;
	gibState = _GetGibbedState( entity );
	entity.gib_state = (gibState | ( gibFlag & ( ( 1 << 9 ) - 1 ) ));
	
	if ( IsDefined( _GetGibbedTorsoModel( entity ) ) &&
		IsDefined( _GetGibbedLegModel( entity ) ) )
	{
		hasGibPieces = true;
	}
	
	entity.gib_state = gibState;
	
	return hasGibPieces;
}

function private _SetGibbed( entity, gibFlag, gibDir )
{
	if ( IsDefined( gibDir ) )
	{
		angles = VectortoAngles( gibDir );
		yaw = angles[1];
		yaw_bits = getbitsforangle( yaw, 3 );
		entity.gib_state = (( _GetGibbedState( entity )|gibFlag & ( ( 1 << 9 ) - 1 ) ) + ( yaw_bits << 9 ) );
	}
	else
	{
		entity.gib_state = (_GetGibbedState( entity ) | ( gibFlag & ( ( 1 << 9 ) - 1 ) ));	
	}

	entity.gibbed = true;
	
	entity clientfield::set( "gib_state", entity.gib_state );
}

function Annihilate( entity )
{
	if ( !_HasGibDef( entity ) )
	{
		return false;
	}

	gibBundle = struct::get_script_bundle("gibcharacterdef",entity.gibdef);
	
	if ( !IsDefined( gibBundle ) || !IsDefined( gibBundle.gibs ) )
	{
		return false;
	}
	
	gibPieceStruct = gibBundle.gibs[ 2 ];
	
	// Make sure there is some sort of FX to play if we're annihilating the AI.
	if ( IsDefined( gibPieceStruct ) )
	{
		if ( IsDefined( gibPieceStruct.gibfx ) )
		{
			_SetGibbed( entity, 2, undefined );

			entity thread _Annihilate( entity );
			return true;
		}
	}
	
	return false;
}

function CopyGibState( originalEntity, newEntity )
{
	newEntity.gib_state = _GetGibbedState( originalEntity );
	
	ToggleSpawnGibs( newEntity, false );
	
	ReapplyHiddenGibPieces( newEntity );
}

function IsGibbed( entity, gibFlag )
{
	return (_GetGibbedState( entity ) & gibFlag);
}

function GibHat( entity )
{
	return _GibExtra( entity, 4 );
}

function GibHead( entity )
{
	GibHat( entity );
	
	if ( _GibExtra( entity, 8 ) )
	{
		if ( IsDefined( entity.torsoDmg5 ) )
		{
			entity Attach( entity.torsoDmg5, "", true ); 
		}
		
		return true;
	}
	
	return false;
}

function GibLeftArm( entity )
{
	// TODO(David Young 5-14-14): Currently AI's don't support both arms getting blown off.
	if ( IsGibbed( entity, 16 ) )
	{
		return false;
	}
	
	if ( _GibEntity( entity, 32 ) )
	{
		DestructServerUtils::DestructLeftArmPieces( entity );
		return true;
	}
	
	return false;
}

function GibRightArm( entity )
{
	// TODO(David Young 5-14-14): Currently AI's don't support both arms getting blown off.
	if ( IsGibbed( entity, 32 ) )
	{
		return false;
	}

	if ( _GibEntity( entity, 16 ) )
	{
		DestructServerUtils::DestructRightArmPieces( entity );
		entity thread shared::DropAIWeapon();
		return true;
	}

	return false;
}

function GibLeftLeg( entity )
{
	if ( _GibEntity( entity, 256 ) )
	{
		DestructServerUtils::DestructLeftLegPieces( entity );
		return true;
	}
	
	return false;
}

function GibRightLeg( entity )
{
	if ( _GibEntity( entity, 128 ) )
	{
		DestructServerUtils::DestructRightLegPieces( entity );
		return true;
	}
	
	return false;
}

function GibLegs( entity )
{
	if ( _GibEntity( entity, (128+256) ) )
	{
		DestructServerUtils::DestructRightLegPieces( entity );
		DestructServerUtils::DestructLeftLegPieces( entity );
		return true;
	}
	
	return false;
}

function PlayerGibLeftArm( entity )
{
	if ( IsDefined( entity.body ) )
	{
		dir = (1,0,0);
		_SetGibbed( entity.body, 32, dir );
	}
}

function PlayerGibRightArm( entity )
{
	if ( IsDefined( entity.body ) )
	{
		dir = (1,0,0);
		_SetGibbed( entity.body, 16, dir );
	}
}

function PlayerGibLeftLeg( entity )
{
	if ( IsDefined( entity.body ) )
	{
		dir = (1,0,0);
		_SetGibbed( entity.body, 256, dir );
	}
}

function PlayerGibRightLeg( entity )
{
	if ( IsDefined( entity.body ) )
	{
		dir = (1,0,0);
		_SetGibbed( entity.body, 128, dir );
	}
}

function PlayerGibLegs( entity )
{
	if ( IsDefined( entity.body ) )
	{
		dir = (1,0,0);
		_SetGibbed( entity.body, 128, dir );
		_SetGibbed( entity.body, 256, dir );
	}
}

function PlayerGibLeftArmVel( entity, dir )
{
	if ( IsDefined( entity.body ) )
	{
		_SetGibbed( entity.body, 32, dir );
	}
}

function PlayerGibRightArmVel( entity, dir )
{
	if ( IsDefined( entity.body ) )
	{
		_SetGibbed( entity.body, 16, dir );
	}
}

function PlayerGibLeftLegVel( entity, dir )
{
	if ( IsDefined( entity.body ) )
	{
		_SetGibbed( entity.body, 256, dir );
	}
}

function PlayerGibRightLegVel( entity, dir )
{
	if ( IsDefined( entity.body ) )
	{
		_SetGibbed( entity.body, 128, dir );
	}
}

function PlayerGibLegsVel( entity, dir )
{
	if ( IsDefined( entity.body ) )
	{
		_SetGibbed( entity.body, 128, dir );
		_SetGibbed( entity.body, 256, dir );
	}
}

function ReapplyHiddenGibPieces( entity )
{
	if ( !_HasGibDef( entity ) )
	{
		return;
	}
	
	gibBundle = struct::get_script_bundle("gibcharacterdef",entity.gibdef);
	
	foreach ( gibFlag, gib in gibBundle.gibs )
	{
		if ( !IsGibbed( entity, gibFlag ) )
		{
			continue;
		}
		
		if ( IsDefined( gib.gibhidetag ) && entity HasPart( gib.gibhidetag ) )
		{
			entity HidePart( gib.gibhidetag, "", true );
		}
	}
}

function ShowHiddenGibPieces( entity )
{
	if ( !_HasGibDef( entity ) )
	{
		return;
	}
	
	gibBundle = struct::get_script_bundle("gibcharacterdef",entity.gibdef);
	
	foreach ( gibFlag, gib in gibBundle.gibs )
	{
		if ( IsDefined( gib.gibhidetag ) && entity HasPart( gib.gibhidetag ) )
		{
			entity ShowPart( gib.gibhidetag, "", true );
		}
	}
}

function ToggleSpawnGibs( entity, shouldSpawnGibs )
{
	if ( !shouldSpawnGibs )
	{
		entity.gib_state = _GetGibbedState( entity ) | 1;
	}
	else
	{
		entity.gib_state = _GetGibbedState( entity ) & ~1;
	}
	
	entity clientfield::set( "gib_state", entity.gib_state );
}
