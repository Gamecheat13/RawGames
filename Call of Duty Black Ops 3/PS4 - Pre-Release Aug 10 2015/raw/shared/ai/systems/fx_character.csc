#using scripts\codescripts\struct;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                                                                                                                                                             	
 
                                                                                                                                                                                                       	     	                                                                                   

function autoexec main()
{
	fxBundles = struct::get_script_bundles( "fxcharacterdef" );
	
	processedFxBundles = [];
	
	// Process all fx character script bundles into a direct lookup form for future access.
	foreach ( fxBundleName, fxBundle in fxBundles )
	{
		processedFxBundle = SpawnStruct();
		processedFxBundle.effectCount = fxBundle.effectCount;
		processedFxBundle.fx = [];
		processedFxBundle.name = fxBundleName;
		
		for ( index = 1; index <= fxBundle.effectCount; index++ )
		{
			fx = GetStructField( fxBundle, "effect" + index + "_fx" );
		
			if ( IsDefined( fx ) )
			{
				fxStruct = SpawnStruct();
				
				fxStruct.attachTag = GetStructField( fxBundle, "effect" + index + "_attachtag" );
				fxStruct.fx = GetStructField( fxBundle, "effect" + index + "_fx" );
				fxStruct.stopOnGib = FxClientUtils::_GibPartNameToGibFlag(
					GetStructField( fxBundle, "effect" + index + "_stopongib" ) );
				fxStruct.stopOnPieceDestroyed = GetStructField( fxBundle, "effect" + index + "_stoponpiecedestroyed" );
				
				processedFxBundle.fx[ processedFxBundle.fx.size ] = fxStruct;
			}
		}
		
		processedFxBundles[ fxBundleName ] = processedFxBundle;
	}
	
	// Replaces all fx character script bundles with their processed form to free unncessary script variables.
	level.scriptbundles[ "fxcharacterdef" ] = processedFxBundles;
}

#namespace FxClientUtils;

function private _ConfigEntity( localClientNum, entity )
{
	if ( !IsDefined( entity._fxCharacter ) )
	{
		entity._fxCharacter = [];
		
		handledGibs = array(
			8,
			16,
			32,
			128,
			256 );
		
		foreach ( gibFlag in handledGibs )
		{
			GibClientUtils::AddGibCallback( localClientNum, entity, gibFlag, &_GibHandler );
		}
		
		for ( index = 1; index <= 20; index++ )
		{
			DestructClientUtils::AddDestructPieceCallback( localClientNum, entity, index, &_DestructHandler );
		}
	}
}

function private _DestructHandler( localClientNum, entity, pieceNumber )
{
	if ( !IsDefined( entity._fxCharacter ) )
	{
		return;
	}
	
	foreach ( fxBundleName, fxBundleInst in entity._fxCharacter )
	{
		fxBundle = struct::get_script_bundle( "fxcharacterdef", fxBundleName );
		
		for ( index = 0; index < fxBundle.fx.size; index++ )
		{
			if ( IsDefined( fxBundleInst[ index ] ) &&
				fxBundle.fx[index].stopOnPieceDestroyed === pieceNumber )
			{
				StopFx( localClientNum, fxBundleInst[ index ] );
				fxBundleInst[ index ] = undefined;
			}
		}
	}
}

function private _GibHandler( localClientNum, entity, gibFlag )
{
	if ( !IsDefined( entity._fxCharacter ) )
	{
		return;
	}

	foreach ( fxBundleName, fxBundleInst in entity._fxCharacter )
	{
		fxBundle = struct::get_script_bundle( "fxcharacterdef", fxBundleName );
		
		for ( index = 0; index < fxBundle.fx.size; index++ )
		{
			if ( IsDefined( fxBundleInst[ index ] ) && fxBundle.fx[index].stopOnGib === gibFlag )
			{
				StopFx( localClientNum, fxBundleInst[ index ] );
				fxBundleInst[ index ] = undefined;
			}
		}
	}
}

function private _GibPartNameToGibFlag( gibPartName )
{
	if ( IsDefined( gibPartName ) )
	{
		switch ( gibPartName )
		{
		case "head":
			return 8;
		case "right arm":
			return 16;
		case "left arm":
			return 32;
		case "right leg":
			return 128;
		case "left leg":
			return 256;
		}
	}
}

function private _IsGibbed( localClientNum, entity, stopOnGibFlag )
{
	if ( !IsDefined( stopOnGibFlag ) )
	{
		return false;
	}

	return GibClientUtils::IsGibbed( localClientNum, entity, stopOnGibFlag );
}

function private _IsPieceDestructed( localClientNum, entity, stopOnPieceDestroyed )
{
	if ( !IsDefined( stopOnPieceDestroyed ) )
	{
		return false;
	}

	return DestructClientUtils::IsPieceDestructed( localClientNum, entity, stopOnPieceDestroyed );
}

function private _ShouldPlayFx( localClientNum, entity, fxStruct )
{
	if ( _IsGibbed( localClientNum, entity, fxStruct.stopOnGib ) )
	{
		return false;
	}
	
	if ( _IsPieceDestructed( localClientNum, entity, fxStruct.stopOnPieceDestroyed ) )
	{
		return false;
	}
	
	return true;
}

function PlayFxBundle( localClientNum, entity, fxScriptBundle )
{
	if ( !IsDefined( fxScriptBundle ) )
	{
		return;
	}

	_ConfigEntity( localClientNum, entity );

	fxBundle = struct::get_script_bundle( "fxcharacterdef", fxScriptBundle );

	if ( IsDefined( entity._fxCharacter[ fxBundle.name ] ) )
	{
		StopFxBundle( localClientNum, entity, fxBundle.name );
	}
	
	if ( IsDefined( fxBundle ) )
	{
		playingFx = [];
		
		for ( index = 0; index < fxBundle.fx.size; index++ )
		{
			fxStruct = fxBundle.fx[ index ];
		
			if ( _ShouldPlayFx( localClientNum, entity, fxStruct ) )
			{
				playingFx[ index ] =
					GibClientUtils::_PlayGibFX( localClientNum, entity, fxStruct.fx, fxStruct.attachTag );
			}
		}
		
		if ( playingFx.size > 0 )
		{
			entity._fxCharacter[ fxBundle.name ] = playingFx;
		}
	}
}

function StopAllFXBundles( localClientNum, entity )
{
	_ConfigEntity( localClientNum, entity );
	
	fxBundleNames = [];
	
	foreach ( fxBundleName, fxBundle in entity._fxCharacter )
	{
		fxBundleNames[ fxBundleNames.size ] = fxBundleName;
	}
	
	foreach ( fxBundleName in fxBundleNames )
	{
		StopFxBundle( localClientNum, entity, fxBundleName );
	}
}

function StopFxBundle( localClientNum, entity, fxScriptBundle )
{
	if ( !IsDefined( fxScriptBundle ) )
	{
		return;
	}

	_ConfigEntity( localClientNum, entity );
	
	fxBundle = struct::get_script_bundle( "fxcharacterdef", fxScriptBundle );
	
	if ( IsDefined( entity._fxCharacter[ fxBundle.name ] ) )
	{
		foreach ( fx in entity._fxCharacter[ fxBundle.name ] )
		{
			if ( IsDefined( fx ) )
			{
				StopFx( localClientNum, fx );
			}
		}
	
		entity._fxCharacter[ fxBundle.name ] = undefined;
	}
}