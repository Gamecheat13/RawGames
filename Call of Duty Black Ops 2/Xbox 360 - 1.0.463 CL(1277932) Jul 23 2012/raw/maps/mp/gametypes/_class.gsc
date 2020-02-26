#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\_statstable.gsh;

init()
{
	level.classMap["class_smg"] = "CLASS_SMG";
	level.classMap["class_cqb"] = "CLASS_CQB";	
	level.classMap["class_assault"] = "CLASS_ASSAULT";
	level.classMap["class_lmg"] = "CLASS_LMG";
	level.classMap["class_sniper"] = "CLASS_SNIPER";

	level.classMap["custom0"] = "CLASS_CUSTOM1";
	level.classMap["custom1"] = "CLASS_CUSTOM2";
	level.classMap["custom2"] = "CLASS_CUSTOM3";
	level.classMap["custom3"] = "CLASS_CUSTOM4";
	level.classMap["custom4"] = "CLASS_CUSTOM5";
	level.classMap["custom5"] = "CLASS_CUSTOM6";
	level.classMap["custom6"] = "CLASS_CUSTOM7";
	level.classMap["custom7"] = "CLASS_CUSTOM8";
	level.classMap["custom8"] = "CLASS_CUSTOM9";
	level.classMap["custom9"] = "CLASS_CUSTOM10";
	
	level.maxKillstreaks = 4;
	level.maxSpecialties = 12;
	level.maxBonuscards = 7;
	level.maxAllocation = GetGametypeSetting( "maxAllocation" );
	level.loadoutKillstreaksEnabled = GetGametypeSetting( "loadoutKillstreaksEnabled" );
	
	level.PrestigeNumber = 5;
	
	level.defaultClass = "CLASS_ASSAULT";
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowfrag" ) )
		level.weapons["frag"] = "frag_grenade_mp";
	else	
		level.weapons["frag"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowsmoke" ) )
		level.weapons["smoke"] = "smoke_grenade_mp";
	else	
		level.weapons["smoke"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowflash" ) )
		level.weapons["flash"] = "flash_grenade_mp";
	else	
		level.weapons["flash"] = "";

	level.weapons["concussion"] = "concussion_grenade_mp";

	// SRS 11/28/2007: changed c4 to satchel
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowsatchel" ) )
		level.weapons["satchel_charge"] = "satchel_charge_mp";
	else	
		level.weapons["satchel_charge"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowbetty" ) )
		level.weapons["betty"] = "mine_bouncing_betty_mp";
	else	
		level.weapons["betty"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowrpgs" ) )
	{
		level.weapons["rpg"] = "rpg_mp";
	}
	else	
	{
		level.weapons["rpg"] = "";
	}
	
	create_class_exclusion_list();
	
	// initializes create a class settings
	cac_init();	
	
	load_default_loadout( "CLASS_SMG", 10 );
	load_default_loadout( "CLASS_CQB", 11 );
	load_default_loadout( "CLASS_ASSAULT", 12 );	
	load_default_loadout( "CLASS_LMG", 13 );
	load_default_loadout( "CLASS_SNIPER", 14 );

	// generating weapon type arrays which classifies the weapon as primary (back stow), pistol, or inventory (side pack stow)
	// using mp/statstable.csv's weapon grouping data ( numbering 0 - 149 )
	level.primary_weapon_array = [];
	level.side_arm_array = [];
	level.grenade_array = [];
	level.inventory_array = [];
	max_weapon_num = 99;
	for( i = 0; i < max_weapon_num; i++ )
	{
		if( !isdefined( level.tbl_weaponIDs[i] ) || level.tbl_weaponIDs[i]["group"] == "" )
			continue;
		if( !isdefined( level.tbl_weaponIDs[i] ) || level.tbl_weaponIDs[i]["reference"] == "" )
			continue;		
	
		weapon_type = level.tbl_weaponIDs[i]["group"];
		weapon = level.tbl_weaponIDs[i]["reference"];
		attachment = level.tbl_weaponIDs[i]["attachment"];
	
		weapon_class_register( weapon+"_mp", weapon_type );	
	
		if( isdefined( attachment ) && attachment != "" )
		{	
			attachment_tokens = strtok( attachment, " " );
			if( isdefined( attachment_tokens ) )
			{
				if( attachment_tokens.size == 0 )
					weapon_class_register( weapon+"_"+attachment+"_mp", weapon_type );	
				else
				{
					// multiple attachment options
					for( k = 0; k < attachment_tokens.size; k++ )
						weapon_class_register( weapon+"_"+attachment_tokens[k]+"_mp", weapon_type );
				}
			}
		}
	}
	
	precacheShader( "waypoint_second_chance" );
	
	level thread onPlayerConnecting();
	
}

create_class_exclusion_list()
{
	currentDvar = 0;
	
	level.itemExclusions = [];
	
	while( GetDvarInt( "item_exclusion_" + currentDvar ) )
	{
		level.itemExclusions[ currentDvar ] = GetDvarInt( "item_exclusion_" + currentDvar );
		currentDvar++;
	}
	
	level.attachmentExclusions = [];
	
	currentDvar = 0;
	while( GetDvar( "attachment_exclusion_" + currentDvar ) !="" )
	{
		level.attachmentExclusions[ currentDvar ] = GetDvar( "attachment_exclusion_" + currentDvar );
		currentDvar++;
	}

}

is_item_excluded( itemIndex )
{
	if ( !level.onlineGame )
	{
		return false;
	}

	numExclusions = level.itemExclusions.size;
	
	for ( exclusionIndex = 0; exclusionIndex < numExclusions; exclusionIndex++ )
	{
		if ( itemIndex == level.itemExclusions[ exclusionIndex ] )
		{
			return true;
		}
	}
	
	return false;
}

is_attachment_excluded( attachment )
{
	numExclusions = level.attachmentExclusions.size;
	
	for ( exclusionIndex = 0; exclusionIndex < numExclusions; exclusionIndex++ )
	{
		if ( attachment == level.attachmentExclusions[ exclusionIndex ] )
		{
			return true;
		}
	}
	
	return false;
}

set_statstable_id()
{
	if ( !IsDefined( level.statsTableID ) )
	{
		level.statsTableID = TableLookupFindCoreAsset( "mp/statsTable.csv" );
	}
}

get_item_count( itemReference )
{
	set_statstable_id();
	
	itemCount = int( tableLookup( level.statsTableID, STATS_TABLE_COL_REFERENCE, itemReference, STATS_TABLE_COL_COUNT ) );
	if ( itemCount < 1 )
	{
		itemCount = 1;
	} 
	
	return itemCount;
}
	
getDefaultClassSlotWithExclusions( className, slotName )
{
	itemReference = GetDefaultClassSlot( className, slotName );
	
	set_statstable_id();
	
	itemIndex = int( tableLookup( level.statsTableID, STATS_TABLE_COL_REFERENCE, itemReference, STATS_TABLE_COL_NUMBERING ) );
	
	if ( is_item_excluded( itemIndex ) )
	{
		itemReference = tableLookup( level.statsTableID, STATS_TABLE_COL_NUMBERING, 0, STATS_TABLE_COL_REFERENCE );
	}
	
	return itemReference;
}
	
load_default_loadout( class, classNum )
{
	level.classToClassNum[ class ] = classNum;
}
			
weapon_class_register( weapon, weapon_type )
{
	if( isSubstr( "weapon_smg weapon_cqb weapon_assault weapon_lmg weapon_sniper weapon_shotgun weapon_launcher weapon_special", weapon_type ) )
		level.primary_weapon_array[weapon] = 1;	
	else if( isSubstr( "weapon_pistol", weapon_type ) )
		level.side_arm_array[weapon] = 1;
	else if( weapon_type == "weapon_grenade" )
		level.grenade_array[weapon] = 1;
	else if( weapon_type == "weapon_explosive" )
		level.inventory_array[weapon] = 1;
	else if( weapon_type == "weapon_rifle" ) // COD5 WEAPON TEST
		level.inventory_array[weapon] = 1;
	else
		assert( false, "Weapon group info is missing from statsTable for: " + weapon_type );
}


// create a class init
cac_init()
{
	level.tbl_weaponIDs = [];
	
	set_statstable_id();

	for( i = 0; i < STATS_TABLE_MAX_ITEMS; i++ )
	{
		itemRow = tableLookupRowNum( level.statsTableID, STATS_TABLE_COL_NUMBERING, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_GROUP );
			
			if ( isSubStr( group_s, "weapon_" ) )
			{
				reference_s = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_REFERENCE );
				if( reference_s != "" )
				{ 
					level.tbl_weaponIDs[i]["reference"] = reference_s;
					level.tbl_weaponIDs[i]["group"] = group_s;
					level.tbl_weaponIDs[i]["count"] = int( tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_COUNT ) );
					level.tbl_weaponIDs[i]["attachment"] = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_ATTACHMENTS );
				}
			}
		}
	}
	
	level.perkNames = [];

	// generating perk data vars collected form statsTable.csv
	for( i = 0; i < STATS_TABLE_MAX_ITEMS; i++ )
	{
		itemRow = tableLookupRowNum( level.statsTableID, STATS_TABLE_COL_NUMBERING, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_GROUP );
		
			if ( group_s == "specialty" )
			{
				reference_s = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_REFERENCE );
				
				if( reference_s != "" )
				{
					perkIcon = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_IMAGE );
					perkName  = tableLookupIString( level.statsTableID, STATS_TABLE_COL_NUMBERING, i, STATS_TABLE_COL_NAME );
					
					precacheString( perkName );
					precacheShader( perkIcon );
					
					level.perkNames[ perkIcon ] = perkName;
				}
			}
		}
	}
	
	level.killStreakNames = [];
	level.killStreakIcons = [];
	level.KillStreakIndices = [];

	// generating kill streak data vars collected form statsTable.csv
	for( i = 0; i < STATS_TABLE_MAX_ITEMS; i++ )
	{
		itemRow = tableLookupRowNum( level.statsTableID, STATS_TABLE_COL_NUMBERING, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_GROUP );
			
			if ( group_s == "killstreak" )
			{
				reference_s = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_REFERENCE );
				
				if( reference_s != "" )
				{
					level.tbl_KillStreakData[i] = reference_s;
					level.killStreakIndices[ reference_s ] = i;
					icon = tableLookupColumnForRow( level.statsTableID, itemRow, STATS_TABLE_COL_IMAGE );
					name = tableLookupIString( level.statsTableID, STATS_TABLE_COL_NUMBERING, i, STATS_TABLE_COL_NAME );
					precacheString( name );

					level.killStreakNames[ reference_s ] = name;
					level.killStreakIcons[ reference_s ] = icon;
					level.killStreakIndices[ reference_s ] = i;
					precacheShader( icon );
					precacheShader( icon + "_drop" );
				}
			}
		}
	}
}

getClassChoice( response )
{
	assert( isDefined( level.classMap[ response ] ) );
	
	return ( level.classMap[ response ] );
}


// ============================================================================


getLoadoutItemFromDDLStats( customClassNum, loadoutSlot )
{
	player = self;
	
	if ( self is_bot() )
	{
		player = GetHostPlayer();
	}
	
	itemIndex = player GetLoadoutItem( customClassNum, loadoutSlot );
	
	if ( is_item_excluded( itemIndex ) && !is_warlord_perk( itemIndex ) )
	{
		return 0;
	}
	
	return itemIndex;
}

getAttachmentString( weaponNum, attachmentNum )
{
	attachmentString = GetItemAttachment( weaponNum, attachmentNum );
	
	if ( attachmentString != "none" && ( !is_attachment_excluded( attachmentString ) ) )
	{
		attachmentString = attachmentString + "_";
	}
	else
	{
		attachmentString = "";
	}
	
	return attachmentString;
}

getAttachmentsDisabled()
{
	if ( !isDefined( level.attachmentsDisabled ) )
	{
		return false;
	}
	
	return level.attachmentsDisabled;
	
}

getKillStreakIndex( class, killstreakNum )
{
	killstreakNum++;
	
	killstreakString = "killstreak" + killstreakNum;
	
	// custom game mode killstreaks
	if ( GetDvarInt( "custom_killstreak_mode" ) == 2 )
	{
		return GetDvarInt( "custom_" + killstreakString );
	}
	else
	{
		return( self GetLoadoutItem( class, killstreakString ) );
	}
}

giveKillstreaks( classNum )
{
		self.killstreak = [];
		
		if ( !level.loadoutKillstreaksEnabled )
			return;
		
		sortedKillstreaks = [];
		currentKillstreak = 0;
		
		for ( killstreakNum = 0; killstreakNum < level.maxKillstreaks; killstreakNum++ )
		{
			killstreakIndex = getKillStreakIndex( classNum, killstreakNum );
			
			if ( isDefined( killstreakIndex ) && killstreakIndex )
			{
				assert( isdefined( level.tbl_KillStreakData[ killstreakIndex ] ), "KillStreak #:" + killstreakIndex + "'s data is undefined" );
				
				if ( isdefined( level.tbl_KillStreakData[ killstreakIndex ] ) )
				{
					self.killstreak[ currentKillstreak ] = level.tbl_KillStreakData[ killstreakIndex ];
					if ( IsDefined( level.usingMomentum ) && level.usingMomentum )
					{
						killstreakType = maps\mp\killstreaks\_killstreaks::getKillstreakByMenuName( self.killstreak[ currentKillstreak ] );
						if ( IsDefined( killstreakType ) )
						{
							weapon = maps\mp\killstreaks\_killstreaks::getKillstreakWeapon( killstreakType );
							self GiveWeapon( weapon );
							if ( IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks )
							{
								if( maps\mp\killstreaks\_killstreak_weapons::isHeldKillstreakWeapon( weapon ) )
								{
									if( !isDefined( self.pers["held_killstreak_ammo_count"][weapon] ) )
										self.pers["held_killstreak_ammo_count"][weapon] = 0;

									if( self.pers["held_killstreak_ammo_count"][weapon] > 0 )
									{
										self maps\mp\gametypes\_class::setWeaponAmmoOverall( weapon, self.pers["held_killstreak_ammo_count"][weapon] );
									}
									else
									{
										self maps\mp\gametypes\_class::setWeaponAmmoOverall( weapon, 0 );
									}
								}
								else
								{
									quantity = self.pers["killstreak_quantity"][weapon];
									if ( !IsDefined( quantity ) )
									{
										quantity = 0;
									}
									self setWeaponAmmoClip( weapon, quantity );
							
								}
							}
							// Put killstreak in sorted order from lowest to highest momentum cost
							sortData = spawnstruct();
							sortData.cost = level.killstreaks[killstreakType].momentumCost;
							sortData.weapon = weapon;
							sortIndex = 0;
							for ( sortIndex = 0 ; sortIndex < sortedKillstreaks.size ; sortIndex++ )
							{
								if ( sortedKillstreaks[sortIndex].cost > sortData.cost )
									break;
							}
							for ( i = sortedKillstreaks.size ; i > sortIndex ; i-- )
							{
								sortedKillstreaks[i] = sortedKillstreaks[i-1];
							}
							sortedKillstreaks[sortIndex] = sortData;
						}
					}
					currentKillstreak++;
				}
			}
		}
		
		actionSlotOrder = [];
		actionSlotOrder[0] = 4;
		actionSlotOrder[1] = 2;
		actionSlotOrder[2] = 1;
		// action slot 3 ( left ) is for alt weapons
		if ( IsDefined( level.usingMomentum ) && level.usingMomentum )
		{
			for ( sortIndex = 0 ; (sortIndex < sortedKillstreaks.size && sortIndex < actionSlotOrder.size) ; sortIndex++ )
			{
				self SetActionSlot( actionSlotOrder[sortIndex], "weapon", sortedKillstreaks[sortIndex].weapon );
			}
		}
}

is_warlord_perk( itemIndex )
{
	// Horrible hack for TU8 competition playlist - MGordon
	if ( ( itemIndex == 168 ) || ( itemIndex == 169 ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}



isPerkGroup( perkName )
{
	return ( IsDefined( perkName ) && IsString( perkName ) );
}

logClassChoice( class, primaryWeapon, specialType, perks )
{
	if ( class == self.lastClass )
		return;

	self logstring( "choseclass: " + class + " weapon: " + primaryWeapon + " special: " + specialType );		
	for( i=0; i<perks.size; i++ )
		self logstring( "perk" + i + ": " + perks[i] );
	
	self.lastClass = class;
}


// clears all player's custom class variables, prepare for update with new stat data
reset_specialty_slots( class_num )
{
	self.specialty = [];		// clear all specialties
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------

initStaticWeaponsTime()
{
	self.staticWeaponsStartTime = getTime();
}

initWeaponAttachments( weaponName )
{
	self.currentWeaponStartTime = getTime();
	
	self.currentWeapon = weaponName;
}

isEquipmentAllowed( equipment )
{
	if ( equipment == "camera_spike_mp" && self IsSplitScreen() )
		return false;
		
	if ( equipment == level.tacticalInsertionWeapon && level.disableTacInsert )
		return false;
	
	return true;
}
							  	
giveLoadoutLevelSpecific( team, class )	  
{
	pixbeginevent("giveLoadoutLevelSpecific");

	if ( isDefined( level.giveCustomCharacters ) )
	{
		self [[level.giveCustomCharacters]]();
	}
	
	if ( isDefined( level.giveCustomLoadout ) )
	{
		self [[level.giveCustomLoadout]]();
	}
	
	pixendevent();
}

giveLoadout( team, class )	  
{
	pixbeginevent("giveLoadout");
	
	self takeAllWeapons();	  	
	
	primaryIndex = 0;
	
	// initialize specialty array
	self.specialty = [];
	self.killstreak = [];
	
	primaryWeapon = undefined;
	
	self notify( "give_map" );

	//TODO - add melee weapon selection to the CAC stuff and default loadouts	
	self GiveWeapon( "knife_mp" );
	
	class_num_for_killstreaks = 0;
	primaryWeaponOptions = 0;
	secondaryWeaponOptions = 0;
	playerRenderOptions = 0;
	primaryGrenadeCount = 0;	
	isCustomClass = false;

	if( isSubstr( class, "CLASS_CUSTOM" ) )
	{	
		pixbeginevent("custom class");
		// ============= custom class selected ==============
		// gets custom class data from stat bytes
		// obtains the custom class number
		class_num = int( class[class.size-1] )-1;

		//hacky patch to the system since when it was written it was never thought of that there could be 10 custom slots
		if( -1 == class_num )
			class_num = 9;

		self.class_num = class_num;
		
		/* This can be uncommented once new EXEs go in
 		allocationSpent = self GetLoadoutAllocation( class_num );
		if ( allocationSpent > level.maxAllocation )
		{
			/#
				IPrintLnBold( "Kicking player for using an over-allocated custom class" );
			#/
			kick( self getEntityNumber() );
		}*/
		
		// clear of specialty slots, repopulate the current selected class' setup
		self reset_specialty_slots( class_num );

		playerRenderOptions = self CalcPlayerOptions( class_num );
		
		class_num_for_killstreaks = class_num;
		isCustomClass = true;

		pixendevent(); // "custom class"
	}
	else
	{			
		pixbeginevent("default class");
		// ============= selected one of the default classes ==============
			
		// load the selected default class's specialties
		assert( isdefined(self.pers["class"]), "Player during spawn and loadout got no class!" );
		
		class_num = level.classToClassNum[ class ];
		
		self.class_num = class_num;
		
		pixendevent(); // "default class"
	}
	
	self.specialty = self GetLoadoutPerks( class_num );
	
	// re-registering perks to code since perks are cleared after respawn in case if players switch classes
	self register_perks();
	
	self SetActionSlot( 3, "altMode" );
	self SetActionSlot( 4, "" );
	
	giveKillStreaks( class_num_for_killstreaks );
	
	spawnWeapon = "";
	initialWeaponCount = 0;
	
	// weapon override for round based gametypes
	// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
	if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
		weapon = self.pers["weapon"];
	else
	{
		weapon = self GetLoadoutWeapon( class_num, "primary" );

		if ( self is_bot() )
		{
			weapon = maps\mp\bots\_bot::bot_get_loadout_primary();
		}
	}
	
	sidearm = self GetLoadoutWeapon( class_num, "secondary" );

	if ( isCustomClass && sidearm != "weapon_null_mp" )
	{
		secondaryWeaponOptions = self CalcWeaponOptions( class_num, 1 );
	}
				
	// give primary weapon
	primaryWeapon = weapon;
	
	if ( isCustomClass && primaryWeapon != "weapon_null_mp" )
	{
		primaryWeaponOptions = self CalcWeaponOptions( class_num, 0 );
	}
			
	if ( sidearm != "" && sidearm != "weapon_null_mp" && sidearm != "weapon_null" )
	{
		self GiveWeapon( sidearm, 0, secondaryWeaponOptions );
		if ( self HasPerk( "specialty_extraammo" ) )
			self giveMaxAmmo( sidearm );

		spawnWeapon = sidearm;
		initialWeaponCount++;
	}
	
	// give primary weapon
	primaryWeapon = weapon;

	primaryTokens = strtok( primaryWeapon, "_" );
	self.pers["primaryWeapon"] = primaryTokens[0];
		
	/#	println( "^5GiveWeapon( " + weapon + " ) -- weapon" );	#/
	if ( primaryWeapon != "" && primaryWeapon != "weapon_null_mp" && primaryWeapon != "weapon_null" )
	{
		if( self HasPerk( "specialty_extraammo" ) )
			self giveMaxAmmo( primaryWeapon );			
			
		self GiveWeapon( primaryWeapon, 0, primaryWeaponOptions );
		spawnWeapon = primaryWeapon;
		initialWeaponCount++;
	}
		
	if ( initialWeaponCount < 2 )
	{
		self GiveWeapon( "knife_held_mp" );
		if ( initialWeaponCount == 0 )
		{
			spawnWeapon = "knife_held_mp";
		}
	}
		
	assert( spawnWeapon != "" );	
	self setSpawnWeapon( spawnWeapon );
	
	grenadeTypePrimary = self GetLoadoutItemRef( class_num, "primarygrenade" );
	grenadeTypeSecondary = self GetLoadoutItemRef( class_num, "specialgrenade" );
	
	if ( grenadeTypePrimary != "" && grenadeTypePrimary != "weapon_null_mp" && isEquipmentAllowed( grenadeTypePrimary ) )
	{
		grenadeTypePrimary = grenadeTypePrimary + "_mp";
		primaryGrenadeCount = self GetLoadoutItem( class_num, "primarygrenadecount" );
	}

	// give secondary grenade
	if ( grenadeTypeSecondary != "" && grenadeTypeSecondary != "weapon_null_mp" && isEquipmentAllowed( grenadeTypeSecondary ) )
	{
		grenadeTypeSecondary = grenadeTypeSecondary + "_mp";
		grenadeSecondaryCount = self GetLoadoutItem( class_num, "specialgrenadecount" );
	}
	
	if ( !( grenadeTypePrimary != "" && grenadeTypePrimary != "weapon_null_mp" && isEquipmentAllowed( grenadeTypePrimary ) ) )
	{
		// we need to make this a blank slot. to do this we need to give a grenade, to enable throwback
		// but with no ammo. we need to make sure then that we don't give us the
		// same grenade here as the secondary.
		if ( grenadeTypeSecondary != level.weapons["frag"] )
		{
			grenadeTypePrimary = level.weapons["frag"];
		}
		else
		{
			grenadeTypePrimary = level.weapons["flash"];
		}
	}
	
	/#	println( "^5GiveWeapon( " + grenadeTypePrimary + " ) -- grenadeTypePrimary" );	#/
	
	self GiveWeapon( grenadeTypePrimary );
	self SetWeaponAmmoClip( grenadeTypePrimary, primaryGrenadeCount );
	self SwitchToOffhand( grenadeTypePrimary );
	self.grenadeTypePrimary = grenadeTypePrimary;
	self.grenadeTypePrimaryCount = primaryGrenadeCount;

	//Set the perk bit so the client knows how many to show as retrieveable
	if( self.grenadeTypePrimaryCount > 1 )
	{
		self SetPerk( "specialty_twogrenades" );
	}
	
	if ( grenadeTypeSecondary != "" && grenadeTypeSecondary != "weapon_null_mp" && isEquipmentAllowed( grenadeTypeSecondary ) )
	{
		self setOffhandSecondaryClass( grenadeTypeSecondary );

		/#	println( "^5GiveWeapon( " + grenadeTypeSecondary + " ) -- grenadeTypeSecondary" );	#/
		self giveWeapon( grenadeTypeSecondary );
		self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeSecondaryCount );
		self.grenadeTypeSecondary = grenadeTypeSecondary;
		self.grenadeTypeSecondaryCount = grenadeSecondaryCount;
	}
	
	self bbClassChoice( class_num, primaryWeapon, sidearm );

	if( !SessionModeIsZombiesGame() )
		self recordLoadoutAndPerks( primaryWeapon, sidearm, grenadetypeprimary, grenadetypesecondary );

	self maps\mp\teams\_teams::set_player_model( team, weapon );
	
	self initStaticWeaponsTime();
		
	self thread initWeaponAttachments( primaryWeapon );
	
	self SetPlayerRenderOptions( playerRenderOptions );	

	if( isDefined( self.movementSpeedModifier ) )
	{
		self setMoveSpeedScale( self.movementSpeedModifier * self getMoveSpeedScale() );
	}

	if ( isDefined( level.giveCustomLoadout ) )
	{
		spawnWeapon = self [[level.giveCustomLoadout]]();
		if ( IsDefined( spawnWeapon ) )
			self thread initWeaponAttachments( spawnWeapon );
	}
	
	// cac specialties that require loop threads
	self cac_selector();
	
	// tagTMR<NOTE>: force first raise anim on initial spawn of match
	if ( !isDefined( self.firstSpawn ) && !self is_bot() )
	{
		self.firstSpawn = false;
		self InitialWeaponRaise( weapon );
	}	
	else
	{
		// ... and eliminate first raise anim for all other spawns
		self SetEverHadWeaponAll( true );
	}

	pixendevent(); // "giveLoadout"
}

// sets the amount of ammo in the gun.
// if the clip maxs out, the rest goes into the stock.
setWeaponAmmoOverall( weaponname, amount )
{
	if ( isWeaponClipOnly( weaponname ) )
	{
		self setWeaponAmmoClip( weaponname, amount );
	}
	else
	{
		self setWeaponAmmoClip( weaponname, amount );
		diff = amount - self getWeaponAmmoClip( weaponname );
		assert( diff >= 0 );
		self setWeaponAmmoStock( weaponname, diff );
	}
}

onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !level.oldschool )
		{
		if ( !isDefined( player.pers["class"] ) )
		{
			player.pers["class"] = "";
	}
			player.class = player.pers["class"];
			player.lastClass = "";
		}
		player.detectExplosives = false;
		player.bombSquadIcons = [];
		player.bombSquadIds = [];	
		player.reviveIcons = [];
		player.reviveIds = [];
	}
}


fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}


setClass( newClass )
{
	self.curClass = newClass;
}

// ============================================================================================
// =======																				=======
// =======						 Create a Class Specialties 							=======
// =======																				=======
// ============================================================================================

initPerkDvars()
{
	level.cac_armorpiercing_data = cac_get_dvar_int( "perk_armorpiercing", "40" ) / 100;// increased bullet damage by this %
	level.cac_bulletdamage_data = cac_get_dvar_int( "perk_bulletDamage", "35" );		// increased bullet damage by this %
	level.cac_fireproof_data = cac_get_dvar_int( "perk_fireproof", "95" );				// reduced flame damage by this %
	level.cac_armorvest_data = cac_get_dvar_int( "perk_armorVest", "80" );				// multipy damage by this %	
	level.cac_explosivedamage_data = cac_get_dvar_int( "perk_explosiveDamage", "25" );	// increased explosive damage by this %
	level.cac_flakjacket_data = cac_get_dvar_int( "perk_flakJacket", "35" );			// explosive damage is this % of original
	level.cac_flakjacket_hardcore_data = cac_get_dvar_int( "perk_flakJacket_hardcore", "9" );	// explosive damage is this % of original for hardcore
}

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
cac_selector()
{
	self thread maps\mp\_tacticalinsertion::postLoadout();
	
	perks = self.specialty;

	self.detectExplosives = false;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		// run scripted perk that thread loops
		if( perk == "specialty_detectexplosive" )
			self.detectExplosives = true;
	}
}
	
register_perks()
{
	perks = self.specialty;
	self ClearPerks();
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];

		// TO DO: ask code to register the inventory perks and null perk
		// not registering inventory and null perks to code
		if ( perk == "specialty_null" || isSubStr( perk, "specialty_weapon_" ) || perk == "weapon_null" )
			continue;
			
		if ( !level.perksEnabled )
			continue;
			
		self setPerk( perk );
	}
	
	/#
	maps\mp\gametypes\_dev::giveExtraPerks();
	#/
}

// returns dvar value in int
cac_get_dvar_int( dvar, def )
{
	return int( cac_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
cac_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

cac_modified_vehicle_damage( victim, attacker, damage, meansofdeath, weapon, inflictor )
{
	// skip conditions
	if( !isdefined( victim) || !isdefined( attacker ) || !isplayer( attacker ) )
		return damage;
	if( !isdefined( damage ) || !isdefined( meansofdeath ) || !isdefined( weapon ) )
		return damage;

	old_damage = damage;
	final_damage = damage;

	// Perk version
	
	if( attacker HasPerk( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) )
	
	// if( issubstr( weapon, "_hp_" ) && isPrimaryDamage( meansofdeath ) )
	
	{
		final_damage = damage*(100+level.cac_bulletdamage_data)/100;
		/#
		if ( GetDvarint( "scr_perkdebug") )
		println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to vehicle" );
		#/
	}

	else if( attacker HasPerk( "specialty_explosivedamage" ) && isPlayerExplosiveWeapon( weapon, meansofdeath )  )
	{
		final_damage = damage*(100+level.cac_explosivedamage_data)/100;
		/#
		if ( GetDvarint( "scr_perkdebug") )
		println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to vehicle" );
		#/
	}
	else
	{
		final_damage = old_damage;
	}	
	
	// debug
	/#
	if ( GetDvarint( "scr_perkdebug") )
	println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
	#/
	
	// return unchanged damage
	return int( final_damage );
}

cac_modified_damage( victim, attacker, damage, mod, weapon, inflictor, hitloc )
{
	assert( IsDefined( victim ) );
	assert( IsDefined( attacker ) );
	assert( IsPlayer( victim ) );

	if ( victim == attacker )
	{
		return damage;
	}

	if ( !IsPlayer( attacker ) )
	{
		return damage;
	}

	if ( damage <= 0 )
	{
		return damage;
	}

/#
	debug = false;

	if ( GetDvarint( "scr_perkdebug" ) )
	{
		debug = true;
	}
#/
	final_damage = damage;
	
	if ( attacker HasPerk( "specialty_bulletdamage" ) && isPrimaryDamage( mod ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased
		if( victim HasPerk( "specialty_armorvest" ) && !isHeadDamage( hitloc ) )
		{
		/#
			if ( debug )
			{
				println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased bullet damage" );
			}
		#/
		}
		else
		{
			final_damage = damage * ( 100 + level.cac_bulletdamage_data ) / 100;

		/#
			if ( debug )
			{
				println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to " + victim.name );
			}
		#/
		}
	}
	else if ( victim HasPerk( "specialty_armorvest" ) && isPrimaryDamage( mod ) && !isHeadDamage( hitloc ) )
	{	
		//If victim has body armor, reduce the damage by the cac armor vest value as a percentage
		final_damage = damage * ( level.cac_armorvest_data * .01 );

	/#
		if ( debug )
		{
			println( "Perk/> " + attacker.name + "'s bullet damage did less damage to " + victim.name );
		}
	#/
	}
	else if ( victim HasPerk( "specialty_fireproof" ) && isFireDamage( weapon, mod ) )
	{
		final_damage = damage * ( ( 100 - level.cac_fireproof_data ) / 100 );

	/#
		if ( debug )
		{
			println( "Perk/> " + attacker.name + "'s flames did less damage to " + victim.name );
		}
	#/
	}
	else if ( attacker HasPerk( "specialty_explosivedamage" ) && isPlayerExplosiveWeapon( weapon, mod ) )
	{
		final_damage = damage * ( 100 + level.cac_explosivedamage_data ) / 100;

	/#
		if ( debug )
		{
			println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to " + victim.name );
		}
	#/
	}
	else if ( victim HasPerk( "specialty_flakjacket" ) && isExplosiveDamage( weapon, mod ) && !victim grenadeStuck( inflictor ) )
	{
		// put these back in to make FlakJacket a perk again (for easy tuning of system when not body type specfic)
		cac_data = ( level.hardcoreMode ? level.cac_flakjacket_hardcore_data : level.cac_flakjacket_data );

		//if ( level.teambased && attacker.team != victim.team )
		//{
		//	victim thread maps\mp\_properks::flakjacketProtected();
		//}
		//else if ( attacker != victim )
		//{
		//	victim thread maps\mp\_properks::flakjacketProtected();
		//}

		final_damage = int( damage * ( cac_data / 100 ) );

	/#
		if ( debug )
		{
			println( "Perk/> " + victim.name + "'s flak jacket decreased " + attacker.name + "'s grenade damage" );
		}
	#/
	}

/#
	victim.cac_debug_damage_type = tolower( mod );
	victim.cac_debug_original_damage = damage;
	victim.cac_debug_final_damage = final_damage;
	victim.cac_debug_location = tolower( hitloc );
	victim.cac_debug_weapon = tolower( weapon );
	victim.cac_debug_range = int( Distance( attacker.origin, victim.origin ) );
	
	if ( debug )
	{
		println( "Perk/> Damage Factor: " + final_damage / damage + " - Pre Damage: " + damage + " - Post Damage: " + final_damage );
	}
#/

	final_damage = int( final_damage );

	if ( final_damage < 1 )
	{
		final_damage = 1;
	}

	return ( final_damage );
}

// including grenade launcher, grenade, bazooka, betty, satchel charge
isExplosiveDamage( weapon, meansofdeath )
{
	if ( IsDefined( weapon ) )
	{
		switch( weapon )
		{
			case "briefcase_bomb_mp":
			case "tabun_gas_mp":
			case "concussion_grenade_mp":
			case "flash_grenade_mp":
			case "emp_grenade_mp":
			case "willy_pete_mp":
				return false;
		}
	}
	
	switch( meansofdeath )
	{
		case "MOD_GRENADE":
		case "MOD_GRENADE_SPLASH":
		case "MOD_PROJECTILE_SPLASH":
		case "MOD_EXPLOSIVE":
			return true;
	}

	return false;
}

hasTacticalMask( player )
{
	return ( player HasPerk( "specialty_stunprotection" ) || player HasPerk( "specialty_flashprotection" ) || player HasPerk( "specialty_proximityprotection" ) );
}

// if primary weapon damage
isPrimaryDamage( meansofdeath )
{
	return( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" );
}

isFireDamage( weapon, meansofdeath )
{
	if ( ( isSubStr( weapon, "flame" ) || isSubStr( weapon, "napalmblob_" ) || isSubStr( weapon, "napalm_" ) ) && ( meansofdeath == "MOD_BURNED" || meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_GRENADE_SPLASH" ) )
		return true;

	if( GetSubStr( weapon, 0, 3 ) == "ft_" )
		return true;

	return false;
}

isPlayerExplosiveWeapon( weapon, meansofdeath )
{
	if ( !isExplosiveDamage( weapon, meansofdeath ) )
		return false;

	switch ( weapon )
	{
		case "artillery_mp":
		case "airstrike_mp":
		case "napalm_mp":
		case "mortar_mp":
		case "hind_ffar_mp":
		case "cobra_ffar_mp":
			return true;
	}
		
	return true;
}

isHeadDamage( hitloc )
{
	return ( hitloc == "helmet" || hitloc == "head" || hitloc == "neck" );
}

grenadeStuck( inflictor )
{
	return ( IsDefined( inflictor ) && IsDefined( inflictor.stucktoplayer ) && inflictor.stucktoplayer == self );
}
