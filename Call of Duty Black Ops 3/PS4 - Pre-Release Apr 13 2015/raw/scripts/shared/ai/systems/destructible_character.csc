#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	

function autoexec main()
{
	clientfield::register(
		"actor",
		"destructible_character_state",
		1,
		21,
		"int" );
		
	destructibles = struct::get_script_bundles( "destructiblecharacterdef" );
	
	// Process each destructible bundle to allow quick access to information in the future.
	foreach ( destructible in destructibles )
	{
		// This is extremely hardcoded because scriptbundles return structs which can't be
		// indexed by a string.
		destructible.pieces = [];

		for ( index = 0; index < 20; index++ )
		{
			destructible.pieces[ destructible.pieces.size ] = SpawnStruct();
		}

		destructible.pieces[0].gibmodel = destructible.piece1_gibmodel;    destructible.piece1_gibmodel = undefined;;
		destructible.pieces[0].gibtag = destructible.piece1_gibtag;    destructible.piece1_gibtag = undefined;;
		destructible.pieces[0].gibfx = destructible.piece1_gibfx;    destructible.piece1_gibfx = undefined;;
		destructible.pieces[0].gibfxtag = destructible.piece1_gibeffecttag;    destructible.piece1_gibeffecttag = undefined;;
		destructible.pieces[0].gibsound = destructible.piece1_gibsound;    destructible.piece1_gibsound = undefined;;
		destructible.pieces[0].hitlocation = destructible.piece1_hitlocation;    destructible.piece1_hitlocation = undefined;;
		destructible.pieces[0].hidetag = destructible.piece1_hidetag;    destructible.piece1_hidetag = undefined;;
		destructible.pieces[0].detachmodel = destructible.piece1_detachmodel;    destructible.piece1_detachmodel = undefined;;
		
		destructible.pieces[1].gibmodel = destructible.piece2_gibmodel;    destructible.piece2_gibmodel = undefined;;
		destructible.pieces[1].gibtag = destructible.piece2_gibtag;    destructible.piece2_gibtag = undefined;;
		destructible.pieces[1].gibfx = destructible.piece2_gibfx;    destructible.piece2_gibfx = undefined;;
		destructible.pieces[1].gibfxtag = destructible.piece2_gibeffecttag;    destructible.piece2_gibeffecttag = undefined;;
		destructible.pieces[1].gibsound = destructible.piece2_gibsound;    destructible.piece2_gibsound = undefined;;
		destructible.pieces[1].hitlocation = destructible.piece2_hitlocation;    destructible.piece2_hitlocation = undefined;;
		destructible.pieces[1].hidetag = destructible.piece2_hidetag;    destructible.piece2_hidetag = undefined;;
		destructible.pieces[1].detachmodel = destructible.piece2_detachmodel;    destructible.piece2_detachmodel = undefined;;
		
		destructible.pieces[2].gibmodel = destructible.piece3_gibmodel;    destructible.piece3_gibmodel = undefined;;
		destructible.pieces[2].gibtag = destructible.piece3_gibtag;    destructible.piece3_gibtag = undefined;;
		destructible.pieces[2].gibfx = destructible.piece3_gibfx;    destructible.piece3_gibfx = undefined;;
		destructible.pieces[2].gibfxtag = destructible.piece3_gibeffecttag;    destructible.piece3_gibeffecttag = undefined;;
		destructible.pieces[2].gibsound = destructible.piece3_gibsound;    destructible.piece3_gibsound = undefined;;
		destructible.pieces[2].hitlocation = destructible.piece3_hitlocation;    destructible.piece3_hitlocation = undefined;;
		destructible.pieces[2].hidetag = destructible.piece3_hidetag;    destructible.piece3_hidetag = undefined;;
		destructible.pieces[2].detachmodel = destructible.piece3_detachmodel;    destructible.piece3_detachmodel = undefined;;
		
		destructible.pieces[3].gibmodel = destructible.piece4_gibmodel;    destructible.piece4_gibmodel = undefined;;
		destructible.pieces[3].gibtag = destructible.piece4_gibtag;    destructible.piece4_gibtag = undefined;;
		destructible.pieces[3].gibfx = destructible.piece4_gibfx;    destructible.piece4_gibfx = undefined;;
		destructible.pieces[3].gibfxtag = destructible.piece4_gibeffecttag;    destructible.piece4_gibeffecttag = undefined;;
		destructible.pieces[3].gibsound = destructible.piece4_gibsound;    destructible.piece4_gibsound = undefined;;
		destructible.pieces[3].hitlocation = destructible.piece4_hitlocation;    destructible.piece4_hitlocation = undefined;;
		destructible.pieces[3].hidetag = destructible.piece4_hidetag;    destructible.piece4_hidetag = undefined;;
		destructible.pieces[3].detachmodel = destructible.piece4_detachmodel;    destructible.piece4_detachmodel = undefined;;
		
		destructible.pieces[4].gibmodel = destructible.piece5_gibmodel;    destructible.piece5_gibmodel = undefined;;
		destructible.pieces[4].gibtag = destructible.piece5_gibtag;    destructible.piece5_gibtag = undefined;;
		destructible.pieces[4].gibfx = destructible.piece5_gibfx;    destructible.piece5_gibfx = undefined;;
		destructible.pieces[4].gibfxtag = destructible.piece5_gibeffecttag;    destructible.piece5_gibeffecttag = undefined;;
		destructible.pieces[4].gibsound = destructible.piece5_gibsound;    destructible.piece5_gibsound = undefined;;
		destructible.pieces[4].hitlocation = destructible.piece5_hitlocation;    destructible.piece5_hitlocation = undefined;;
		destructible.pieces[4].hidetag = destructible.piece5_hidetag;    destructible.piece5_hidetag = undefined;;
		destructible.pieces[4].detachmodel = destructible.piece5_detachmodel;    destructible.piece5_detachmodel = undefined;;
		
		destructible.pieces[5].gibmodel = destructible.piece6_gibmodel;    destructible.piece6_gibmodel = undefined;;
		destructible.pieces[5].gibtag = destructible.piece6_gibtag;    destructible.piece6_gibtag = undefined;;
		destructible.pieces[5].gibfx = destructible.piece6_gibfx;    destructible.piece6_gibfx = undefined;;
		destructible.pieces[5].gibfxtag = destructible.piece6_gibeffecttag;    destructible.piece6_gibeffecttag = undefined;;
		destructible.pieces[5].gibsound = destructible.piece6_gibsound;    destructible.piece6_gibsound = undefined;;
		destructible.pieces[5].hitlocation = destructible.piece6_hitlocation;    destructible.piece6_hitlocation = undefined;;
		destructible.pieces[5].hidetag = destructible.piece6_hidetag;    destructible.piece6_hidetag = undefined;;
		destructible.pieces[5].detachmodel = destructible.piece6_detachmodel;    destructible.piece6_detachmodel = undefined;;
		
		destructible.pieces[6].gibmodel = destructible.piece7_gibmodel;    destructible.piece7_gibmodel = undefined;;
		destructible.pieces[6].gibtag = destructible.piece7_gibtag;    destructible.piece7_gibtag = undefined;;
		destructible.pieces[6].gibfx = destructible.piece7_gibfx;    destructible.piece7_gibfx = undefined;;
		destructible.pieces[6].gibfxtag = destructible.piece7_gibeffecttag;    destructible.piece7_gibeffecttag = undefined;;
		destructible.pieces[6].gibsound = destructible.piece7_gibsound;    destructible.piece7_gibsound = undefined;;
		destructible.pieces[6].hitlocation = destructible.piece7_hitlocation;    destructible.piece7_hitlocation = undefined;;
		destructible.pieces[6].hidetag = destructible.piece7_hidetag;    destructible.piece7_hidetag = undefined;;
		destructible.pieces[6].detachmodel = destructible.piece7_detachmodel;    destructible.piece7_detachmodel = undefined;;
		
		destructible.pieces[7].gibmodel = destructible.piece8_gibmodel;    destructible.piece8_gibmodel = undefined;;
		destructible.pieces[7].gibtag = destructible.piece8_gibtag;    destructible.piece8_gibtag = undefined;;
		destructible.pieces[7].gibfx = destructible.piece8_gibfx;    destructible.piece8_gibfx = undefined;;
		destructible.pieces[7].gibfxtag = destructible.piece8_gibeffecttag;    destructible.piece8_gibeffecttag = undefined;;
		destructible.pieces[7].gibsound = destructible.piece8_gibsound;    destructible.piece8_gibsound = undefined;;
		destructible.pieces[7].hitlocation = destructible.piece8_hitlocation;    destructible.piece8_hitlocation = undefined;;
		destructible.pieces[7].hidetag = destructible.piece8_hidetag;    destructible.piece8_hidetag = undefined;;
		destructible.pieces[7].detachmodel = destructible.piece8_detachmodel;    destructible.piece8_detachmodel = undefined;;
		
		destructible.pieces[8].gibmodel = destructible.piece9_gibmodel;    destructible.piece9_gibmodel = undefined;;
		destructible.pieces[8].gibtag = destructible.piece9_gibtag;    destructible.piece9_gibtag = undefined;;
		destructible.pieces[8].gibfx = destructible.piece9_gibfx;    destructible.piece9_gibfx = undefined;;
		destructible.pieces[8].gibfxtag = destructible.piece9_gibeffecttag;    destructible.piece9_gibeffecttag = undefined;;
		destructible.pieces[8].gibsound = destructible.piece9_gibsound;    destructible.piece9_gibsound = undefined;;
		destructible.pieces[8].hitlocation = destructible.piece9_hitlocation;    destructible.piece9_hitlocation = undefined;;
		destructible.pieces[8].hidetag = destructible.piece9_hidetag;    destructible.piece9_hidetag = undefined;;
		destructible.pieces[8].detachmodel = destructible.piece9_detachmodel;    destructible.piece9_detachmodel = undefined;;
		
		destructible.pieces[9].gibmodel = destructible.piece10_gibmodel;    destructible.piece10_gibmodel = undefined;;
		destructible.pieces[9].gibtag = destructible.piece10_gibtag;    destructible.piece10_gibtag = undefined;;
		destructible.pieces[9].gibfx = destructible.piece10_gibfx;    destructible.piece10_gibfx = undefined;;
		destructible.pieces[9].gibfxtag = destructible.piece10_gibeffecttag;    destructible.piece10_gibeffecttag = undefined;;
		destructible.pieces[9].gibsound = destructible.piece10_gibsound;    destructible.piece10_gibsound = undefined;;
		destructible.pieces[9].hitlocation = destructible.piece10_hitlocation;    destructible.piece10_hitlocation = undefined;;
		destructible.pieces[9].hidetag = destructible.piece10_hidetag;    destructible.piece10_hidetag = undefined;;
		destructible.pieces[9].detachmodel = destructible.piece10_detachmodel;    destructible.piece10_detachmodel = undefined;;
		
		destructible.pieces[10].gibmodel = destructible.piece11_gibmodel;    destructible.piece11_gibmodel = undefined;;
		destructible.pieces[10].gibtag = destructible.piece11_gibtag;    destructible.piece11_gibtag = undefined;;
		destructible.pieces[10].gibfx = destructible.piece11_gibfx;    destructible.piece11_gibfx = undefined;;
		destructible.pieces[10].gibfxtag = destructible.piece11_gibeffecttag;    destructible.piece11_gibeffecttag = undefined;;
		destructible.pieces[10].gibsound = destructible.piece11_gibsound;    destructible.piece11_gibsound = undefined;;
		destructible.pieces[10].hitlocation = destructible.piece11_hitlocation;    destructible.piece11_hitlocation = undefined;;
		destructible.pieces[10].hidetag = destructible.piece11_hidetag;    destructible.piece11_hidetag = undefined;;
		destructible.pieces[10].detachmodel = destructible.piece11_detachmodel;    destructible.piece11_detachmodel = undefined;;
		
		destructible.pieces[11].gibmodel = destructible.piece12_gibmodel;    destructible.piece12_gibmodel = undefined;;
		destructible.pieces[11].gibtag = destructible.piece12_gibtag;    destructible.piece12_gibtag = undefined;;
		destructible.pieces[11].gibfx = destructible.piece12_gibfx;    destructible.piece12_gibfx = undefined;;
		destructible.pieces[11].gibfxtag = destructible.piece12_gibeffecttag;    destructible.piece12_gibeffecttag = undefined;;
		destructible.pieces[11].gibsound = destructible.piece12_gibsound;    destructible.piece12_gibsound = undefined;;
		destructible.pieces[11].hitlocation = destructible.piece12_hitlocation;    destructible.piece12_hitlocation = undefined;;
		destructible.pieces[11].hidetag = destructible.piece12_hidetag;    destructible.piece12_hidetag = undefined;;
		destructible.pieces[11].detachmodel = destructible.piece12_detachmodel;    destructible.piece12_detachmodel = undefined;;
		
		destructible.pieces[12].gibmodel = destructible.piece13_gibmodel;    destructible.piece13_gibmodel = undefined;;
		destructible.pieces[12].gibtag = destructible.piece13_gibtag;    destructible.piece13_gibtag = undefined;;
		destructible.pieces[12].gibfx = destructible.piece13_gibfx;    destructible.piece13_gibfx = undefined;;
		destructible.pieces[12].gibfxtag = destructible.piece13_gibeffecttag;    destructible.piece13_gibeffecttag = undefined;;
		destructible.pieces[12].gibsound = destructible.piece13_gibsound;    destructible.piece13_gibsound = undefined;;
		destructible.pieces[12].hitlocation = destructible.piece13_hitlocation;    destructible.piece13_hitlocation = undefined;;
		destructible.pieces[12].hidetag = destructible.piece13_hidetag;    destructible.piece13_hidetag = undefined;;
		destructible.pieces[12].detachmodel = destructible.piece13_detachmodel;    destructible.piece13_detachmodel = undefined;;
		
		destructible.pieces[13].gibmodel = destructible.piece14_gibmodel;    destructible.piece14_gibmodel = undefined;;
		destructible.pieces[13].gibtag = destructible.piece14_gibtag;    destructible.piece14_gibtag = undefined;;
		destructible.pieces[13].gibfx = destructible.piece14_gibfx;    destructible.piece14_gibfx = undefined;;
		destructible.pieces[13].gibfxtag = destructible.piece14_gibeffecttag;    destructible.piece14_gibeffecttag = undefined;;
		destructible.pieces[13].gibsound = destructible.piece14_gibsound;    destructible.piece14_gibsound = undefined;;
		destructible.pieces[13].hitlocation = destructible.piece14_hitlocation;    destructible.piece14_hitlocation = undefined;;
		destructible.pieces[13].hidetag = destructible.piece14_hidetag;    destructible.piece14_hidetag = undefined;;
		destructible.pieces[13].detachmodel = destructible.piece14_detachmodel;    destructible.piece14_detachmodel = undefined;;
		
		destructible.pieces[14].gibmodel = destructible.piece15_gibmodel;    destructible.piece15_gibmodel = undefined;;
		destructible.pieces[14].gibtag = destructible.piece15_gibtag;    destructible.piece15_gibtag = undefined;;
		destructible.pieces[14].gibfx = destructible.piece15_gibfx;    destructible.piece15_gibfx = undefined;;
		destructible.pieces[14].gibfxtag = destructible.piece15_gibeffecttag;    destructible.piece15_gibeffecttag = undefined;;
		destructible.pieces[14].gibsound = destructible.piece15_gibsound;    destructible.piece15_gibsound = undefined;;
		destructible.pieces[14].hitlocation = destructible.piece15_hitlocation;    destructible.piece15_hitlocation = undefined;;
		destructible.pieces[14].hidetag = destructible.piece15_hidetag;    destructible.piece15_hidetag = undefined;;
		destructible.pieces[14].detachmodel = destructible.piece15_detachmodel;    destructible.piece15_detachmodel = undefined;;
		
		destructible.pieces[15].gibmodel = destructible.piece16_gibmodel;    destructible.piece16_gibmodel = undefined;;
		destructible.pieces[15].gibtag = destructible.piece16_gibtag;    destructible.piece16_gibtag = undefined;;
		destructible.pieces[15].gibfx = destructible.piece16_gibfx;    destructible.piece16_gibfx = undefined;;
		destructible.pieces[15].gibfxtag = destructible.piece16_gibeffecttag;    destructible.piece16_gibeffecttag = undefined;;
		destructible.pieces[15].gibsound = destructible.piece16_gibsound;    destructible.piece16_gibsound = undefined;;
		destructible.pieces[15].hitlocation = destructible.piece16_hitlocation;    destructible.piece16_hitlocation = undefined;;
		destructible.pieces[15].hidetag = destructible.piece16_hidetag;    destructible.piece16_hidetag = undefined;;
		destructible.pieces[15].detachmodel = destructible.piece16_detachmodel;    destructible.piece16_detachmodel = undefined;;
		
		destructible.pieces[16].gibmodel = destructible.piece17_gibmodel;    destructible.piece17_gibmodel = undefined;;
		destructible.pieces[16].gibtag = destructible.piece17_gibtag;    destructible.piece17_gibtag = undefined;;
		destructible.pieces[16].gibfx = destructible.piece17_gibfx;    destructible.piece17_gibfx = undefined;;
		destructible.pieces[16].gibfxtag = destructible.piece17_gibeffecttag;    destructible.piece17_gibeffecttag = undefined;;
		destructible.pieces[16].gibsound = destructible.piece17_gibsound;    destructible.piece17_gibsound = undefined;;
		destructible.pieces[16].hitlocation = destructible.piece17_hitlocation;    destructible.piece17_hitlocation = undefined;;
		destructible.pieces[16].hidetag = destructible.piece17_hidetag;    destructible.piece17_hidetag = undefined;;
		destructible.pieces[16].detachmodel = destructible.piece17_detachmodel;    destructible.piece17_detachmodel = undefined;;
		
		destructible.pieces[17].gibmodel = destructible.piece18_gibmodel;    destructible.piece18_gibmodel = undefined;;
		destructible.pieces[17].gibtag = destructible.piece18_gibtag;    destructible.piece18_gibtag = undefined;;
		destructible.pieces[17].gibfx = destructible.piece18_gibfx;    destructible.piece18_gibfx = undefined;;
		destructible.pieces[17].gibfxtag = destructible.piece18_gibeffecttag;    destructible.piece18_gibeffecttag = undefined;;
		destructible.pieces[17].gibsound = destructible.piece18_gibsound;    destructible.piece18_gibsound = undefined;;
		destructible.pieces[17].hitlocation = destructible.piece18_hitlocation;    destructible.piece18_hitlocation = undefined;;
		destructible.pieces[17].hidetag = destructible.piece18_hidetag;    destructible.piece18_hidetag = undefined;;
		destructible.pieces[17].detachmodel = destructible.piece18_detachmodel;    destructible.piece18_detachmodel = undefined;;
		
		destructible.pieces[18].gibmodel = destructible.piece19_gibmodel;    destructible.piece19_gibmodel = undefined;;
		destructible.pieces[18].gibtag = destructible.piece19_gibtag;    destructible.piece19_gibtag = undefined;;
		destructible.pieces[18].gibfx = destructible.piece19_gibfx;    destructible.piece19_gibfx = undefined;;
		destructible.pieces[18].gibfxtag = destructible.piece19_gibeffecttag;    destructible.piece19_gibeffecttag = undefined;;
		destructible.pieces[18].gibsound = destructible.piece19_gibsound;    destructible.piece19_gibsound = undefined;;
		destructible.pieces[18].hitlocation = destructible.piece19_hitlocation;    destructible.piece19_hitlocation = undefined;;
		destructible.pieces[18].hidetag = destructible.piece19_hidetag;    destructible.piece19_hidetag = undefined;;
		destructible.pieces[18].detachmodel = destructible.piece19_detachmodel;    destructible.piece19_detachmodel = undefined;;
		
		destructible.pieces[19].gibmodel = destructible.piece20_gibmodel;    destructible.piece20_gibmodel = undefined;;
		destructible.pieces[19].gibtag = destructible.piece20_gibtag;    destructible.piece20_gibtag = undefined;;
		destructible.pieces[19].gibfx = destructible.piece20_gibfx;    destructible.piece20_gibfx = undefined;;
		destructible.pieces[19].gibfxtag = destructible.piece20_gibeffecttag;    destructible.piece20_gibeffecttag = undefined;;
		destructible.pieces[19].gibsound = destructible.piece20_gibsound;    destructible.piece20_gibsound = undefined;;
		destructible.pieces[19].hitlocation = destructible.piece20_hitlocation;    destructible.piece20_hitlocation = undefined;;
		destructible.pieces[19].hidetag = destructible.piece20_hidetag;    destructible.piece20_hidetag = undefined;;
		destructible.pieces[19].detachmodel = destructible.piece20_detachmodel;    destructible.piece20_detachmodel = undefined;;
	}
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

function DestructRandomPieces( entity )
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
