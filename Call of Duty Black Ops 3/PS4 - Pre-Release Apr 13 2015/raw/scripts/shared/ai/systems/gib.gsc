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
		8,
		"int" );
		
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
		
		definition.gibs[4].gibhidetag = definition.head_gibhidetag;    definition.head_gibhidetag = undefined;;
		
		definition.gibs[8].gibhidetag = definition.rightarm_gibhidetag;    definition.rightarm_gibhidetag = undefined;;
		
		definition.gibs[16].gibhidetag = definition.leftarm_gibhidetag;    definition.leftarm_gibhidetag = undefined;;
		
		definition.gibs[64].gibhidetag = definition.rightleg_gibhidetag;    definition.rightleg_gibhidetag = undefined;;
		
		definition.gibs[128].gibhidetag = definition.leftleg_gibhidetag;    definition.leftleg_gibhidetag = undefined;;
	}
}

#namespace GibServerUtils;

function private _GetGibExtraModel( entity, gibFlag )
{
	switch ( gibFlag )
	{
	case 2:
		return entity.hatmodel;
	case 4:
		return entity.head;
	default:
		AssertMsg( "Unable to find gib model." );
	}
}

// Used to solely gib equipment and the actor's head.
// Does not change the torso or leg models.
function private _GibExtra( entity, gibFlag )
{
	if ( IsGibbed( entity, gibFlag ) )
	{
		return false;
	}

	_SetGibbed( entity, gibFlag );

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
	
	if ( !(_GetGibbedState( entity ) < 8) )
	{
		legModel = _GetGibbedLegModel( entity );
		entity Detach( legModel );
	}
	
	_SetGibbed( entity, gibFlag );
	
	entity SetModel( _GetGibbedTorsoModel( entity ) );
	entity Attach( _GetGibbedLegModel( entity ) );
	
	DestructServerUtils::ReapplyDestructedPieces( entity );
	ReapplyHiddenGibPieces( entity );
	
	return true;
}

function private _GetGibbedLegModel( entity )
{
	gibState = _GetGibbedState( entity );
	rightLegGibbed = (gibState & 64);
	leftLegGibbed = (gibState & 128);
	
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
	rightArmGibbed = (gibState & 8);
	leftArmGibbed = (gibState & 16);
	
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

function private _HasGibPieces( entity, gibFlag )
{
	hasGibPieces = false;
	gibState = _GetGibbedState( entity );
	entity.gib_state = (gibState | gibFlag);
	
	if ( IsDefined( _GetGibbedTorsoModel( entity ) ) &&
		IsDefined( _GetGibbedLegModel( entity ) ) )
	{
		hasGibPieces = true;
	}
	
	entity.gib_state = gibState;
	
	return hasGibPieces;
}

function private _SetGibbed( entity, gibFlag )
{
	entity.gib_state = (_GetGibbedState( entity ) | gibFlag);
	entity clientfield::set( "gib_state", entity.gib_state );
}

function IsGibbed( entity, gibFlag )
{
	return (_GetGibbedState( entity ) & gibFlag);
}

function GibHat( entity )
{
	return _GibExtra( entity, 2 );
}

function GibHead( entity )
{
	GibHat( entity );
	
	if ( _GibExtra( entity, 4 ) )
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
	if ( IsGibbed( self, 8 ) )
	{
		return false;
	}
	
	if ( _GibEntity( entity, 16 ) )
	{
		DestructServerUtils::DestructLeftArmPieces( entity );
		return true;
	}
	
	return false;
}

function GibRightArm( entity )
{
	// TODO(David Young 5-14-14): Currently AI's don't support both arms getting blown off.
	if ( IsGibbed( self, 16 ) )
	{
		return false;
	}

	if ( _GibEntity( entity, 8 ) )
	{
		DestructServerUtils::DestructRightArmPieces( entity );
		entity thread shared::DropAIWeapon();
		return true;
	}

	return false;
}

function GibLeftLeg( entity )
{
	if ( _GibEntity( entity, 128 ) )
	{
		DestructServerUtils::DestructLeftLegPieces( entity );
		return true;
	}
	
	return false;
}

function GibRightLeg( entity )
{
	if ( _GibEntity( entity, 64 ) )
	{
		DestructServerUtils::DestructRightLegPieces( entity );
		return true;
	}
	
	return false;
}

function GibLegs( entity )
{
	if ( _GibEntity( entity, 192 ) )
	{
		DestructServerUtils::DestructRightLegPieces( entity );
		DestructServerUtils::DestructLeftLegPieces( entity );
		return true;
	}
	
	return false;
}

function ReapplyHiddenGibPieces( entity )
{
	if ( !IsDefined(entity.gibdef) )
	{
		return;
	}
	
	gibBundle = struct::get_script_bundle( "gibcharacterdef", entity.gibdef );
	
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
	if ( !IsDefined(entity.gibdef) )
	{
		return;
	}
	
	gibBundle = struct::get_script_bundle( "gibcharacterdef", entity.gibdef );
	
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
