#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	

#namespace bonuszmdrops;

class BZMWeaponsEntry
{
	var	weaponName;
	var	minAttachments;
	var	maxAttachments;
	var	attachments;
	var magicboxOnly;
	
	constructor()
	{
		attachments = [];
	}
}
	
function autoexec BZM_InitWeapons()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	mapname = GetDvarString( "mapname" );	

	level.BZMWeaponsTable 	= [];
	level.BZMWeaponsTableHero 	= [];
	level.BZMHeroWeaponDispencedNum = 0;
	
	level.bonusZmData 		= struct::get_script_bundle( "bonuszmdata", mapname );	
	weaponsTableName 		= GetStructField( level.bonusZmData, "weaponsTable" );		
	
	assert( IsDefined( weaponsTableName ) );
	
	BZM_LoadWeaponsTable( "gamedata/tables/cpzm/" + weaponsTableName );	
}

function BZM_LoadWeaponsTable( weaponsTableName )
{	
	noneWeapon = GetWeapon("none" );
	
	// number of rows = number of weapons
	numWeapons = TableLookupRowCount( weaponsTableName );
		
	// lookup row one by one
	for( i = 0; i < numWeapons; i++ )
	{
		weaponsEntry = new BZMWeaponsEntry();
		
		weaponsEntry.weaponName 	= TableLookupColumnForRow( weaponsTableName, i, 0 );
		weaponsEntry.minAttachments = Int( TableLookupColumnForRow( weaponsTableName, i, 1 ) );
		weaponsEntry.maxAttachments = Int(TableLookupColumnForRow( weaponsTableName, i, 2 ) );
		weaponsEntry.attachments 	= StrTok( TableLookupColumnForRow( weaponsTableName, i, 3 ), " " );
		weaponsEntry.magicboxOnly 	= TableLookupColumnForRow( weaponsTableName, i, 4 );
		
		if( !IsDefined( weaponsEntry.weaponName ) || GetWeapon( weaponsEntry.weaponName ) == noneWeapon )
			continue;
					
		if( weaponsEntry.magicboxOnly == "" )
			weaponsEntry.magicboxOnly = 0;
		else
			weaponsEntry.magicboxOnly = Int( weaponsEntry.magicboxOnly );
		
		if( weaponsEntry.magicboxOnly )
			array::add( level.BZMWeaponsTableHero, weaponsEntry );
		else					
			array::add( level.BZMWeaponsTable, weaponsEntry );
	}
}

function BZM_GetRandomWeaponFromTable( forMagicBox = false )
{
	assert( IsDefined( level.BZMWeaponsTable ) );
	assert( IsDefined( level.BZMWeaponsTableHero ) );
	assert( IsDefined( level.bonusZMSkiptoData["magicboxonlyweaponchance"] ) );
	
	selectedRandomWeapon = undefined;
	selectedAttachments = [];
		
	// Get a random weapon entry
	if( forMagicBox && level.BZMHeroWeaponDispencedNum < level.bonusZMSkiptoData["maxmagicboxonlyweapons"] && RandomInt(100) < level.bonusZMSkiptoData["magicboxonlyweaponchance"] && level.BZMWeaponsTableHero.size )
	{		
		level.BZMHeroWeaponDispencedNum++;
		weaponsEntry = array::random( level.BZMWeaponsTableHero );
	}
	else
	{
		weaponsEntry = array::random( level.BZMWeaponsTable );
	}
	
	// Choose number of attachments
	numAttachments = 0;
	if( weaponsEntry.minAttachments >= 0 && weaponsEntry.maxAttachments > 0 )
	{
		numAttachments = RandomIntRange( weaponsEntry.minAttachments, weaponsEntry.maxAttachments );
	}
	
	if( numAttachments > 0  )
	{
		attachments =  weaponsEntry.attachments;
		
		for( i = 0; i < numAttachments; i++ )
		{
			if( !attachments.size )
			{
				break;
			}
			
			attachment = array::random( weaponsEntry.attachments );
			
			array::add( selectedAttachments, attachment );
			
			ArrayRemoveValue( attachments, attachment );
		}		
	}
		
	acvi = undefined;
	weaponSelected = false;
	
	if( IsDefined( selectedAttachments ) )
	{
		selectedRandomWeapon = GetWeapon( weaponsEntry.weaponName, selectedAttachments );	
				
		if( IsDefined( selectedRandomWeapon ) )
		{		
			weaponSelected = true;
			
			switch( selectedAttachments.size )
			{
				case 8:
					acvi = GetAttachmentCosmeticVariantIndexes( selectedRandomWeapon, 
					                                           selectedAttachments[0], math::cointoss(),
					                                           selectedAttachments[1], math::cointoss(),
					                                           selectedAttachments[2], math::cointoss(),
					                                           selectedAttachments[3], math::cointoss(),
					                                           selectedAttachments[4], math::cointoss(),
					                                           selectedAttachments[5], math::cointoss(),
															   selectedAttachments[6], math::cointoss(),
															   selectedAttachments[7], math::cointoss() );
															   
					break;
				case 7:
					acvi = GetAttachmentCosmeticVariantIndexes( selectedRandomWeapon, 
					                                           selectedAttachments[0], math::cointoss(),
					                                           selectedAttachments[1], math::cointoss(),
					                                           selectedAttachments[2], math::cointoss(),
					                                           selectedAttachments[3], math::cointoss(),
					                                           selectedAttachments[4], math::cointoss(), 
					                                           selectedAttachments[5], math::cointoss(),
					                                           selectedAttachments[6], math::cointoss() );
															   
					break;
				case 6:
					acvi = GetAttachmentCosmeticVariantIndexes( selectedRandomWeapon, 
					                                           selectedAttachments[0], math::cointoss(), 
					                                           selectedAttachments[1], math::cointoss(),
					                                           selectedAttachments[2], math::cointoss(), 
					                                           selectedAttachments[3], math::cointoss(), 
					                                           selectedAttachments[4], math::cointoss(), 
					                                           selectedAttachments[5], math::cointoss() );
															   
					break;
				case 5:
					acvi = GetAttachmentCosmeticVariantIndexes( selectedRandomWeapon, 
					                                           selectedAttachments[0], math::cointoss(), 
					                                           selectedAttachments[1], math::cointoss(),
					                                           selectedAttachments[2], math::cointoss(),
					                                           selectedAttachments[3], math::cointoss(), 
					                                           selectedAttachments[4], math::cointoss() );
															   
					break;
				case 4:
					acvi = GetAttachmentCosmeticVariantIndexes( selectedRandomWeapon, 
					                                           selectedAttachments[0], math::cointoss(), 
					                                           selectedAttachments[1], math::cointoss(), 
					                                           selectedAttachments[2], math::cointoss(),
					                                           selectedAttachments[3], math::cointoss() );
															   
					break;
				case 3:
					acvi = GetAttachmentCosmeticVariantIndexes( selectedRandomWeapon, 
					                                           selectedAttachments[0], math::cointoss(),
					                                           selectedAttachments[1], math::cointoss(), 
					                                           selectedAttachments[2], math::cointoss() );
															   
					break;
				case 2:
					acvi = GetAttachmentCosmeticVariantIndexes( selectedRandomWeapon, 
					                                           selectedAttachments[0], math::cointoss(), 
					                                           selectedAttachments[1], math::cointoss() );
															   
					break;
				case 1:
					acvi = GetAttachmentCosmeticVariantIndexes( selectedRandomWeapon, 
					                                           selectedAttachments[0], math::cointoss() );
															   
					break;
			}		
		}
	}
	
	if( !weaponSelected )
	{
		selectedRandomWeapon = GetWeapon( weaponsEntry.weaponName );
	}
		
	weaponInfo = [];
	weaponInfo[0] 	= selectedRandomWeapon;
	weaponInfo[1] 	= acvi;	
	weaponInfo[2] 		= RandomIntRange( 1, 15 );
		
	assert( weaponInfo[0] != level.weaponNone );
	
	return weaponInfo;
}


// ----------------------
// Random Weapon
//-----------------------
function BZM_GivePlayerWeapon( weaponInfo )
{
	assert( IsDefined( weaponInfo ) );
	
	randomWeapon = weaponInfo[0];
	randomWeaponAcvi = weaponInfo[1];
	randomWeaponCamoOptions = weaponInfo[2];
	
	if( !IsDefined( randomWeapon ) )
		return;
	
	if( randomWeapon == level.weaponNone )
	   return;
	
	//save off hero weapon
	a_weaponlist = self GetWeaponsList();
	
	a_heroweapons = [];
	foreach( weapon in a_weaponlist )
	{
		if( ( isdefined( weapon.isheroweapon ) && weapon.isheroweapon ) )
		{
			if ( !isdefined( a_heroweapons ) ) a_heroweapons = []; else if ( !IsArray( a_heroweapons ) ) a_heroweapons = array( a_heroweapons ); a_heroweapons[a_heroweapons.size]=weapon;;
		}
	}
	
	// Take away all other weapons			
	primaryHeldWeapons = self GetWeaponsListPrimaries();
		
	foreach( weapon in primaryHeldWeapons )
	{
		self TakeWeapon( weapon );			
	}		
	
	camoOptions = self CalcWeaponOptions( randomWeaponCamoOptions, 0, 0, 0 );
	
	if( IsDefined( randomWeaponAcvi ) )
		self GiveWeapon( randomWeapon, camoOptions, randomWeaponAcvi );
	else
		self GiveWeapon( randomWeapon, camoOptions );
	
	
	if( self HasWeapon( randomWeapon ) )
	{
		self SetWeaponAmmoClip( randomWeapon, randomWeapon.clipSize );
		self GiveMaxAmmo( randomWeapon );	
	}
		
	// Give back the hero weapons
	foreach( weapon in a_heroweapons )
	{
		self GiveWeapon( weapon );
		self SetWeaponAmmoClip( weapon, weapon.clipSize );
		self GiveMaxAmmo( weapon );
	}
	
	if( self HasWeapon( randomWeapon ) )
	{
		self SwitchToWeapon(randomWeapon);	
	}
	else
	{
		if( primaryHeldWeapons.size )
		{
			self SwitchToWeapon( primaryHeldWeapons[0] );
		}
	}		
}