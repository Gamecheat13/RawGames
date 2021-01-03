#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\array_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                             	

function autoexec main()
{
	clientfield::register(
		"actor",
		"destructible_character_state",
		1,
		21,
		"int" );
		
	destructibles = struct::get_script_bundles( "destructiblecharacterdef" );
	
	processedBundles = [];
	
	// Process each destructible bundle to allow quick access to information in the future.
	foreach ( destructibleName, destructible in destructibles )
	{
		destructBundle = SpawnStruct();
		destructBundle.pieceCount = destructible.pieceCount;
		destructBundle.pieces = [];
		destructBundle.name = destructibleName;
		
		for ( index = 1; index <= destructBundle.pieceCount; index++ )
		{
			pieceStruct = SpawnStruct();
			pieceStruct.gibmodel = GetStructField( destructible, "piece" + index + "_gibmodel" );
			pieceStruct.gibtag = GetStructField( destructible, "piece" + index + "_gibtag" );
			pieceStruct.gibfx = GetStructField( destructible, "piece" + index + "_gibfx" );
			pieceStruct.gibfxtag = GetStructField( destructible, "piece" + index + "_gibeffecttag" );
			pieceStruct.gibdynentfx = GetStructField( destructible, "piece" + index + "_gibdynentfx" );
			pieceStruct.gibsound = GetStructField( destructible, "piece" + index + "_gibsound" );
			pieceStruct.hitlocation = GetStructField( destructible, "piece" + index + "_hitlocation" );
			pieceStruct.hidetag = GetStructField( destructible, "piece" + index + "_hidetag" );
			pieceStruct.detachmodel = GetStructField( destructible, "piece" + index + "_detachmodel" );
			
			destructBundle.pieces[ destructBundle.pieces.size ] = pieceStruct;
		}
		
		processedBundles[ destructibleName ] = destructBundle;
	}
	
	// Replaces all destructible character define bundles with their processed form to free unncessary script variables.
	level.scriptbundles[ "destructiblecharacterdef" ] = processedBundles;
}

#namespace DestructServerUtils;

function private _GetDestructState( entity )
{
	if ( IsDefined( entity._destruct_state ) )
	{
		return entity._destruct_state;
	}
	
	return 0;
}

function private _SetDestructed( entity, destructFlag )
{
	entity._destruct_state = (_GetDestructState( entity ) | destructFlag);
	entity clientfield::set( "destructible_character_state", entity._destruct_state );
}

function CopyDestructState( originalEntity, newEntity )
{
	newEntity._destruct_state = _GetDestructState( originalEntity );
	
	ToggleSpawnGibs( newEntity, false );
	
	ReapplyDestructedPieces( newEntity );
}

function DestructHitLocPieces( entity, hitLoc )
{
	if ( IsDefined(entity.destructibledef) )
	{
		destructBundle = struct::get_script_bundle( "destructiblecharacterdef", entity.destructibledef );
	
		for ( index = 1; index <= destructBundle.pieces.size; index++ )
		{
			piece = destructBundle.pieces[ index - 1 ];
			
			if ( IsDefined( piece.hitlocation ) && piece.hitlocation == hitLoc )
			{
				DestructPiece( entity, index );
			}
		}
	}
}

function DestructLeftArmPieces( entity )
{
	DestructHitLocPieces( entity, "left_arm_upper" );
	DestructHitLocPieces( entity, "left_arm_lower" );
	DestructHitLocPieces( entity, "left_hand" );
}

function DestructLeftLegPieces( entity )
{
	DestructHitLocPieces( entity, "left_leg_upper" );
	DestructHitLocPieces( entity, "left_leg_lower" );
	DestructHitLocPieces( entity, "left_foot" );
}

function DestructPiece( entity, pieceNumber )
{
	/# assert( (1 <= pieceNumber && pieceNumber <= 20) ); #/

	if ( IsDestructed( entity, pieceNumber ) )
	{
		return;
	}
	
	_SetDestructed( entity, (1 << pieceNumber) );
	
	if ( !IsDefined(entity.destructibledef) )
	{
		return;
	}
	
	destructBundle = struct::get_script_bundle( "destructiblecharacterdef", entity.destructibledef );
	piece = destructBundle.pieces[ pieceNumber - 1 ];
	
	if ( IsDefined( piece.hidetag ) && entity HasPart( piece.hidetag ) )
	{
		entity HidePart( piece.hidetag );
	}
	
	if ( IsDefined( piece.detachmodel ) )
	{
		entity Detach( piece.detachmodel, "" );
	}
}



// Destruct a specified number of pieces
// Use 0 to destruct all pieces
function DestructNumberRandomPieces( entity, num_pieces_to_destruct=0 )
{
	// Array containing our desctructible pieces.
	destructible_pieces_list = [];
	
	// Get the total number of breakable pieces we have
	destructablePieces = GetPieceCount( entity );
	
	if (num_pieces_to_destruct == 0)
	{
		num_pieces_to_destruct = destructablePieces;
	}
	
	// Build the list of pieces
	for ( i = 0; i < destructablePieces; i++ )
	{
		destructible_pieces_list[i] = i + 1;
	}
	
	// Shuffle the list of pieces so we break off pieces at random
	destructible_pieces_list = array::randomize(destructible_pieces_list);
	
	// Go through the randomized list breaking off pieces until we either run out of pieces or broke off all the pieces we needed to.
	foreach(piece in destructible_pieces_list)
	{
		if(!IsDestructed(entity,piece))
		{
		   DestructPiece(entity,piece);
			num_pieces_to_destruct--;
			if(num_pieces_to_destruct == 0 )
			break;
		}
	}
}
	

function DestructRandomPieces( entity)
{
	destructPieces = GetPieceCount( entity );
	
	for ( index = 0; index < destructPieces; index++ )
	{
		if ( math::cointoss() )
		{
			DestructPiece( entity, index + 1 );
		}
	}
}

function DestructRightArmPieces( entity )
{
	DestructHitLocPieces( entity, "right_arm_upper" );
	DestructHitLocPieces( entity, "right_arm_lower" );
	DestructHitLocPieces( entity, "right_hand" );
}

function DestructRightLegPieces( entity )
{
	DestructHitLocPieces( entity, "right_leg_upper" );
	DestructHitLocPieces( entity, "right_leg_lower" );
	DestructHitLocPieces( entity, "right_foot" );
}

function GetPieceCount( entity )
{
	if ( IsDefined(entity.destructibledef) )
	{
		destructBundle = struct::get_script_bundle( "destructiblecharacterdef", entity.destructibledef );
	
		if ( IsDefined( destructBundle ) )
		{
			return destructBundle.piececount;
		}
	}
	
	return 0;
}

function HandleDamage(
	eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex )
{
	entity = self;
	
	ToggleSpawnGibs( entity, true );
	
	DestructHitLocPieces( entity, sHitLoc );
	
	return iDamage;
}

function IsDestructed( entity, pieceNumber )
{
	/# assert( (1 <= pieceNumber && pieceNumber <= 20) ); #/

	return (_GetDestructState( entity ) & (1 << pieceNumber));
}

function ReapplyDestructedPieces( entity )
{
	if ( !IsDefined(entity.destructibledef) )
	{
		return;
	}
	
	destructBundle = struct::get_script_bundle( "destructiblecharacterdef", entity.destructibledef );
	
	for ( index = 1; index <= destructBundle.pieces.size; index++ )
	{
		if ( !IsDestructed( entity, index ) )
		{
			continue;
		}
		
		piece = destructBundle.pieces[ index - 1];
		
		if ( IsDefined( piece.hidetag ) && entity HasPart( piece.hidetag ) )
		{
			entity HidePart( piece.hidetag );
		}
	}
}

function ShowDestructedPieces( entity )
{
	if ( !IsDefined(entity.destructibledef) )
	{
		return;
	}
	
	destructBundle = struct::get_script_bundle( "destructiblecharacterdef", entity.destructibledef );
	
	for ( index = 1; index <= destructBundle.pieces.size; index++ )
	{
		piece = destructBundle.pieces[ index - 1];
	
		if ( IsDefined( piece.hidetag ) && entity HasPart( piece.hidetag ) )
		{
			entity ShowPart( piece.hidetag );
		}
	}
}

function ToggleSpawnGibs( entity, shouldSpawnGibs )
{
	if ( shouldSpawnGibs )
	{
		entity._destruct_state = _GetDestructState( entity ) | 1;
	}
	else
	{
		entity._destruct_state = _GetDestructState( entity ) & ~1;
	}
	
	entity clientfield::set( "destructible_character_state", entity._destruct_state );
}

// end #namespace DestructServerUtils;
