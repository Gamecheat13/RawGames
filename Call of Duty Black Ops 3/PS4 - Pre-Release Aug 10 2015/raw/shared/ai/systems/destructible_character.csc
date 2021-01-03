#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                             	

function autoexec main()
{
	clientfield::register(
		"actor",
		"destructible_character_state",
		1,
		21,
		"int",
		&DestructClientUtils::_DestructHandler,
		!true,
		!true);

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

#namespace DestructClientUtils;

function private _DestructHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	destructFlags = (oldValue ^ newValue);
	shouldSpawnGibs = (newValue & 1);
	
	// Don't use the old clientfield value for new entities.
	if ( bNewEnt )
	{
		destructFlags = (0 ^ newValue);
	}
	
	if ( !IsDefined(entity.destructibledef) )
	{
		return;
	}
	
	// Only look at destructible pieces, skip toggle bit.
	currentDestructFlag = (1 << 1);
	pieceNumber = 1;
	
	// Handles any number of simultaneous gibbings.
	while ( destructFlags >= currentDestructFlag )
	{
		if ( destructFlags & currentDestructFlag )
		{
			_DestructPiece( localClientNum, entity, pieceNumber, shouldSpawnGibs );
		}
		
		currentDestructFlag = currentDestructFlag << 1;
		pieceNumber++;
	}
	
	entity._destruct_state = newValue;
}

function private _DestructPiece( localClientNum, entity, pieceNumber, shouldSpawnGibs )
{
	if ( !IsDefined(entity.destructibledef) )
	{
		return;
	}
	
	destructBundle = struct::get_script_bundle( "destructiblecharacterdef", entity.destructibledef );
	piece = destructBundle.pieces[ pieceNumber - 1 ];
	
	if ( IsDefined( piece ) )
	{
		if ( shouldSpawnGibs )
		{
			GibClientUtils::_PlayGibFX( localClientNum, entity, piece.gibfx, piece.gibfxtag );
			entity thread GibClientUtils::_GibPiece( localClientNum, entity, piece.gibmodel, piece.gibtag, piece.gibdynentfx );
			
			GibClientUtils::_PlayGibSound( localClientNum, entity, piece.gibsound );	
		}
		
		_HandleDestructCallbacks( localClientNum, entity, pieceNumber );
	}
}

function private _GetDestructState( localClientNum, entity )
{
	if ( IsDefined( entity._destruct_state ) )
	{
		return entity._destruct_state;
	}
	
	return 0;
}

function private _HandleDestructCallbacks( localClientNum, entity, pieceNumber )
{
	if ( IsDefined( entity._destructCallbacks ) &&
		IsDefined( entity._destructCallbacks[ pieceNumber ] ) )
	{
		foreach ( callback in entity._destructCallbacks[ pieceNumber ] )
		{
			[[callback]]( localClientNum, entity, pieceNumber );
		}
	}
}

function AddDestructPieceCallback( localClientNum, entity, pieceNumber, callbackFunction )
{
	assert( IsFunctionPtr( callbackFunction ) );

	if ( !IsDefined( entity._destructCallbacks ) )
	{
		entity._destructCallbacks = [];
	}

	if ( !IsDefined( entity._destructCallbacks[ pieceNumber ] ) )
	{
		entity._destructCallbacks[ pieceNumber ] = [];
	}
	
	destructCallbacks = entity._destructCallbacks[ pieceNumber ];
	destructCallbacks[ destructCallbacks.size ] = callbackFunction;
	entity._destructCallbacks[ pieceNumber ] = destructCallbacks;
}

function IsPieceDestructed( localClientNum, entity, pieceNumber )
{
	return (_GetDestructState( localClientNum, entity ) & (1 << pieceNumber));
}

// end #namespace DestructClientUtils;
