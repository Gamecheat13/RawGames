#include common_scripts\utility;
// check if below includes are removable
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


// Sumeet/MikeD Note: How to add a weapon. "OFFLINE" mode only not, for now
// 1. string_assets\class.str: 
//		-Add/modify class.str for OFFLINE_CLASS# -- # being the desired number in the menu list.
// 2. maps\mp\gametypes\_class.gsc: 
//		-Add/modify level.classMap in init() to the corresponding CLASS#
//		-Add/modify a load_default_loadout() with the corresponding CLASS#
//		-If adding a new "weapon class" add to the if/else in weapon_class_register()
// 3. share\raw\mp\offline_classTable.csv:
//		-Add/modify the weapon and the appropiate attachments into this list
// 4. share\raw\mp\statsTable.csv
//		-Add/modify an entry in here with the corresponding weapon information.
// 5. share\raw\ui_mp\scriptmenus\changeclass_offline.menu
//		-Add/modify to the CHOICE_BUTTON_FOCUS section the appropiate CLASS#
// 6. share\zone_source\common_mp_weapons.csv
//		-Add the weapon
// -- You may need to add a icon material to ui_mp.csv, which is referred to from the statsTable.csv

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
	
	level.maxKillstreaks = 6;
	level.maxSpecialties = 16;

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
	
	load_default_loadout( "CLASS_SMG" );
	load_default_loadout( "CLASS_CQB" );
	load_default_loadout( "CLASS_ASSAULT" );	
	load_default_loadout( "CLASS_LMG" );
	load_default_loadout( "CLASS_SNIPER" );

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
	
		//statstablelookup( get_col, with_col, with_data )
		weapon_type = level.tbl_weaponIDs[i]["group"]; //statstablelookup( level.cac_cgroup, level.cac_cstat, i );
		weapon = level.tbl_weaponIDs[i]["reference"]; //statstablelookup( level.cac_creference, level.cac_cstat, i );
		attachment = level.tbl_weaponIDs[i]["attachment"]; //statstablelookup( level.cac_cstring, level.cac_cstat, i );
	
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

// assigns default class loadout to team from datatable
load_default_loadout( class )
{
		// do not thread, tablelookup is demanding
		load_default_loadout_raw( "allies", class );
		load_default_loadout_raw( "axis", class );
}

get_item_count( itemReference )
{
	itemCount = int( tableLookup( "mp/statsTable.csv", level.cac_creference, itemReference, level.cac_ccount ) );
	if ( itemCount < 1 )
	{
		itemCount = 1;
	} 
	
	return itemCount;
}
	
getDefaultClassSlotWithExclusions( className, slotName )
{
	itemReference = GetDefaultClassSlot( className, slotName );
	
	itemIndex = int( tableLookup( "mp/statsTable.csv", level.cac_creference, itemReference, level.cac_numbering ) );
	
	if ( is_item_excluded( itemIndex ) )
	{
		itemReference = tableLookup( "mp/statsTable.csv", level.cac_numbering, 0, level.cac_creference );
	}
	
	return itemReference;
}
	
load_default_loadout_raw( team, class, stat_num )
{
	// give primary weapon and attachment
	level.classWeapons[team][class][0] = getDefaultClassSlotWithExclusions( class, "primary" ) + "_mp";
	// TODO - Get default attachments working here MGORDON
	
	// give secondary weapon and attachment
	level.classSidearm[team][class] = getDefaultClassSlotWithExclusions( class, "secondary" ) + "_mp";
	// TODO - Get default attachments working here MGORDON
	
	primaryGrenadeRef = getDefaultClassSlotWithExclusions( class, "primarygrenade" );
	level.classGrenades[class]["primary"]["type"] = primaryGrenadeRef + "_mp";
	level.classGrenades[class]["primary"]["count"] = get_item_count( primaryGrenadeRef );
	
	secondaryGrenadeRef = getDefaultClassSlotWithExclusions( class, "specialgrenade" );
	level.classGrenades[class]["secondary"]["type"] = secondaryGrenadeRef + "_mp";
	level.classGrenades[class]["secondary"]["count"] = get_item_count( secondaryGrenadeRef );

	equipmentRef = getDefaultClassSlotWithExclusions( class, "equipment" );
	level.default_equipment[ class ][ "type" ] = equipmentRef + "_mp";
	level.default_equipment[ class ][ "count" ] = get_item_count( secondaryGrenadeRef );

	// give default class perks
	level.default_perk[class] = [];	
	if ( GetDvarint( "scr_game_perks" ) )
	{
		currentSpecialty = 0;
		for ( numSpecialties = 0; numSpecialties < level.maxSpecialties; numSpecialties++ )
		{
			// first get the specialty index
			perkRef = getDefaultClassSlotWithExclusions( class, "specialty" + ( numSpecialties + 1 ) );
			
			if ( perkRef == "weapon_null" )
			{	
				level.default_perk[class][currentSpecialty] = "specialty_null";
			}
			else
			{
				specialty = level.perkReferenceToIndex[ perkRef ];
			// validate and expand the specialty if it is a group
				specialties[currentSpecialty] = validatePerk( specialty, currentSpecialty );
				storeDefaultSpecialtyData( class, specialties[currentSpecialty] );
				level.default_perkIcon[class][ currentSpecialty ] = level.tbl_PerkData[ specialty ][ "reference_full" ];
				currentSpecialty++;
			}
		}
	}
	else
	{
		level.default_perk[class][0] = "specialty_null";
		level.default_perk[class][1] = "specialty_null";
	
		level.classGrenades[class]["primary"]["count"] = 1;
		level.classGrenades[class]["secondary"]["count"] = 1;
	}	
	
	level.classItem[team][class]["type"] = "";
	level.classItem[team][class]["count"] = 0;

	//default armor
	level.default_armor[class] = [];
	level.default_armor[class]["body"] = getDefaultClassSlotWithExclusions( class, "body" );
	level.default_armor[class]["head"] = getDefaultClassSlotWithExclusions( class, "head" );
	
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
	// max create a class "class" allowed
	level.cac_size = 5;
	
	level.cac_max_item = 256;
	
	// init cac data table column definitions
	level.cac_numbering = 0;	// unique unsigned int - general numbering of all items
	level.cac_cstat = 1;		// unique unsigned int - stat number assigned
	level.cac_cgroup = 2;		// string - item group name, "primary" "secondary" "inventory" "specialty" "grenades" "special grenades" "stow back" "stow side" "attachment"
	level.cac_cname = 3;		// string - name of the item, "Extreme Conditioning"
	level.cac_creference = 4;	// string - reference string of the item, "m203" "svt40" "bulletdamage" "c4"
	level.cac_ccount = 5;		// signed int - item count, if exists, -1 = has no count
	level.cac_cimage = 6;		// string - item's image file name
	level.cac_cdesc = 7;		// long string - item's description
	level.cac_cstring = 8;		// long string - item's other string data, reserved
	level.cac_cint = 9;			// signed int - item's other number data, used for attachment number representations
	level.cac_cunlock = 10;		// unsigned int - represents if item is unlocked by default
	level.cac_cint2 = 11;		// signed int - item's other number data, used for primary weapon camo skin number representations
	level.cac_allocation_cost = 12; // signed int - allocation cost of the item
	level.cac_slot = 13; // string - slot for the given item
	level.cac_classified = 15;	// signed int - number of items of the class purchased need to unlock this weapon
	level.cac_momentum = 16;	// signed int - momentum cost
	level.cac_cost = 17; // signed int - cost of the item
	
	level.tbl_weaponIDs = [];
	for( i = 0; i < level.cac_max_item; i++ )
	{
		itemRow = tableLookupRowNum( "mp/statsTable.csv", level.cac_numbering, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_cgroup );
			
			if ( isSubStr( group_s, "weapon_" ) )
			{
				reference_s = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_creference );
				if( reference_s != "" )
				{ 
					level.tbl_weaponIDs[i]["reference"] = reference_s;
					level.tbl_weaponIDs[i]["group"] = group_s;
					level.tbl_weaponIDs[i]["count"] = int( tableLookupColumnForRow( "mp/statstable.csv", itemRow, level.cac_ccount ) );
					level.tbl_weaponIDs[i]["attachment"] = tableLookupColumnForRow( "mp/statstable.csv", itemRow, level.cac_cstring );
					level.tbl_weaponIDs[i]["slot"] = tablelookup( "mp/statstable.csv", 0, i, level.cac_slot );	
					level.tbl_weaponIDs[i]["cost"] = tablelookup( "mp/statstable.csv", 0, i, level.cac_cost );	
					level.tbl_weaponIDs[i]["unlock_level"] = tablelookup( "mp/statstable.csv", 0, i, level.cac_cunlock );
					level.tbl_weaponIDs[i]["classified"] = int( tablelookup( "mp/statstable.csv", 0, i, level.cac_classified ) );
				}
			}
		}
	}
	
	for( i = 0; i < level.cac_max_item; i++ )
	{
		itemRow = tableLookupRowNum( "mp/statsTable.csv", level.cac_numbering, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_cgroup );
				
			if ( ( group_s == "body" ) || ( group_s == "head" ) )
			{
				if ( !isDefined( level.armor_index_start ) )
				{
					level.armor_index_start = i; 
					level.armor_index_end = i;
				}
				else if ( i > level.armor_index_end )
				{
					level.armor_index_end = i;
				}
				
				item = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_creference );
				if ( item != "" )
				{
					level.tbl_armor[i] = item;
				}
			}
		}
	}

	level.perkReferenceToIndex = [];
	
	level.perkNames = [];
	level.perkIcons = [];
	level.PerkData = [];

	// allowed perks in each slot, for validation.
	level.perkList = [];

	// generating perk data vars collected form statsTable.csv
	for( i = 0; i < level.cac_max_item; i++ )
	{
		itemRow = tableLookupRowNum( "mp/statsTable.csv", level.cac_numbering, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_cgroup );
		
			if ( group_s == "specialty" )
			{
				reference_s = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_creference );
				
				if( reference_s != "" )
				{
					level.tbl_PerkData[i]["reference"] = reference_s;
					level.tbl_PerkData[i]["reference_full"] = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_cimage );
					level.tbl_PerkData[i]["count"] = int( tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_ccount ) );
					level.tbl_PerkData[i]["cost"] = int( tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_cost ) );
					level.tbl_PerkData[i]["group"] = group_s;
					level.tbl_PerkData[i]["name"] = tableLookupIString( "mp/statsTable.csv", level.cac_numbering, i, level.cac_cname );
					level.tbl_PerkData[i]["slot"] = tablelookup( "mp/statstable.csv", 0, i, level.cac_slot );	
					precacheString( level.tbl_PerkData[i]["name"] );
					
					level.perkReferenceToIndex[ level.tbl_PerkData[i]["reference"] ] = i;
					
					cost = int( tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_cost ) );
		
					if( cost >= 0 )
					{
						level.perkList[ level.perkList.size ] = i;
					}
					
					level.perkNames[level.tbl_PerkData[i]["reference_full"]] = level.tbl_PerkData[i]["name"];
					level.perkIcons[level.tbl_PerkData[i]["reference_full"]] = level.tbl_PerkData[i]["reference_full"];
					precacheShader( level.perkIcons[level.tbl_PerkData[i]["reference_full"]] );
				}
			}
		}
	}
	

	level.killStreakNames = [];
	level.killStreakIcons = [];
	level.KillStreakIndices = [];

	// generating kill streak data vars collected form statsTable.csv
	for( i = 0; i < level.cac_max_item; i++ )
	{
		itemRow = tableLookupRowNum( "mp/statsTable.csv", level.cac_numbering, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_cgroup );
			
			if ( group_s == "killstreak" )
			{
				reference_s = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_creference );
				
				if( reference_s != "" )
				{
					level.tbl_KillStreakData[i] = reference_s;
					icon = tableLookupColumnForRow( "mp/statsTable.csv", itemRow, level.cac_cimage );
					name = tableLookupIString( "mp/statsTable.csv", level.cac_numbering, i, level.cac_cname );
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
// obtains custom class setup from stat values
cac_getdata( )
{
	if ( isDefined( self.cac_initialized ) )
		return;
	
	getCacDataGroup( 0, 5 );
	
	if( level.onlineGame )
		getCacDataGroup( 5, 10 );
}

getLoadoutItemFromDDLStats( customClassNum, loadoutSlot )
{
	itemIndex = self GetLoadoutItem( customClassNum, loadoutSlot );
	
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

getFullWeaponName( customClassNum, weaponSlot, attachmentsDisabled ) // weaponSlot should be 'primary' or 'secondary'
{
	assert( ( ( weaponSlot == "primary" ) || ( weaponSlot == "secondary" ) ), "weaponSlot should be primary or secondary" );
	
	weaponName = "weapon_null";
	
	if ( ( weaponSlot == "primary" ) || ( weaponSlot == "secondary" ) )
	{
		weaponNum = getLoadoutItemFromDDLStats ( customClassNum, weaponSlot );
		
		// Used to get m1911 as default if you didn't have a primary. No longer.
		/*if ( weaponSlot == "primary" )
		{
			weaponIndex = 3;
			assert( level.tbl_weaponIDs[weaponIndex]["reference"] == "m1911" );
			
			if ( weaponNum < 0 || !isDefined( level.tbl_weaponIDs[ weaponNum ] ) )
			{
					weaponNum = weaponIndex;
			}
		}*/
		
		if ( isDefined( level.tbl_weaponIDs[ weaponNum ] ) )
		{
			attachmenttop = getLoadoutItemFromDDLStats ( customClassNum, weaponSlot + "attachmenttop" );
			attachmentbottom = getLoadoutItemFromDDLStats ( customClassNum, weaponSlot + "attachmentbottom" );
			attachmenttrigger = getLoadoutItemFromDDLStats ( customClassNum, weaponSlot + "attachmenttrigger" );
			attachmentmuzzle = getLoadoutItemFromDDLStats ( customClassNum, weaponSlot + "attachmentmuzzle" );
			attachmentgunperk = getLoadoutItemFromDDLStats ( customClassNum, weaponSlot + "attachmentgunperk" );
			
			topName = getAttachmentString( weaponNum, attachmenttop );
			bottomName = getAttachmentString( weaponNum, attachmentbottom );
			triggerName = getAttachmentString( weaponNum, attachmenttrigger );
			muzzleName = getAttachmentString( weaponNum, attachmentmuzzle );
			gunPerkName = getAttachmentString( weaponNum, attachmentgunperk );
			
			weaponPrefix = level.tbl_weaponIDs[ weaponNum ][ "reference" ];
			
			if ( attachmentsDisabled )
			{
				weaponName = weaponPrefix + "_mp";
			}
			else if ( bottomName == "dw_" )
			{
				weaponName = weaponPrefix + bottomName + topName + triggerName + muzzleName + gunPerkName + "mp";
			}
			else
			{
				weaponName = weaponPrefix + "_" + topName +	bottomName + triggerName + muzzleName + gunPerkName + "mp";
			}
		}
	}
	
	return weaponName;
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
	else if ( IsString( class ) )
	{
		itemReference = GetDefaultClassSlot( class, killstreakString );
		
		return ( int( tableLookup( "mp/statsTable.csv", level.cac_creference, itemReference, level.cac_numbering ) ) );
	}
	else
	{
		return( self GetLoadoutItem( class, killstreakString ) );
	}
}

giveKillstreaks( classNum )
{
		sortedKillstreaks = [];
		self.killstreak = [];
		
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
								quantity = self.pers["killstreak_quantity"][weapon];
								if ( !IsDefined( quantity ) )
								{
									quantity = 0;
								}
								self setWeaponAmmoClip( weapon, quantity );
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
		actionSlotOrder[0] = 1;
		actionSlotOrder[1] = 4;
		actionSlotOrder[2] = 2;
		actionSlotOrder[3] = 3;
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

getCacDataGroup( cacRange, numClasses )
{
	for( i = cacRange; i < numClasses; i ++ )
	{
		primary_grenade = getLoadoutItemFromDDLStats ( i, "primarygrenade" );
		primary_num = getLoadoutItemFromDDLStats ( i, "primary" );

		specialty = [];
		
		for ( specialtyNum = 0; specialtyNum < level.maxSpecialties; specialtyNum++ )
		{
			specialty[ specialtyNum ] = getLoadoutItemFromDDLStats ( i, "specialty" + ( 1 + specialtyNum ) );
		}
		
		body = getLoadoutItemFromDDLStats( i, "body" );
		assert( body >= level.armor_index_start );
		assert( body <= level.armor_index_end );

		body = level.tbl_armor[ body ];
		assert( IsDefined( body ) );

		head = getLoadoutItemFromDDLStats( i, "head" );
		assert( head >= level.armor_index_start );
		assert( head <= level.armor_index_end );

		head = level.tbl_armor[ head ];
		assert( IsDefined( head ) );
		
		special_grenade = getLoadoutItemFromDDLStats ( i, "specialgrenade" );
		
		equipment = getLoadoutItemFromDDLStats ( i, "equipment" );
		
		// builds the full primary grenade reference string
		self.custom_class[i]["primary_grenades"] = level.tbl_weaponIDs[primary_grenade]["reference"]+"_mp";
		primaryGrenadeCount = level.tbl_weaponIDs[primary_grenade]["count"];
		primaryGrenadeCountFromStats = getLoadoutItemFromDDLStats ( i, "primarygrenadecount" );
	
		if ( primary_grenade && primaryGrenadeCountFromStats )
		{
			primaryGrenadeCount = primaryGrenadeCountFromStats;
		}
		self.custom_class[i]["primary_grenades_count"] = primaryGrenadeCount;
		
		self.custom_class[i]["equipment_slot"] = level.tbl_weaponIDs[equipment]["reference"]+"_mp";
		equipmentCount = level.tbl_weaponIDs[equipment]["count"];
		equipmentCountFromStats = getLoadoutItemFromDDLStats ( i, "equipmentCount" );
		if ( equipment && equipmentCountFromStats )
		{
			equipmentCount = equipmentCountFromStats;
		}
		self.custom_class[i]["equipment_slot_count"] = equipmentCount;
		
		self.custom_class[i]["special_grenade"] = level.tbl_weaponIDs[special_grenade]["reference"]+"_mp";
		specialGrenadeCount = level.tbl_weaponIDs[special_grenade]["count"];
		specialGrenadeCountFromStats = getLoadoutItemFromDDLStats ( i, "specialgrenadeCount" );
		if ( special_grenade && specialGrenadeCountFromStats )
		{
			specialGrenadeCount = specialGrenadeCountFromStats;
		}
		self.custom_class[i]["special_grenade_count"] = specialGrenadeCount;

		attachmentsDisabled = false;
		
		for ( j = 0; j < specialty.size; j++ )
		{
			if ( is_warlord_perk( specialty[ j ] ) && is_item_excluded( specialty[ j ] ) )
			{
				attachmentsDisabled = true;
				specialty[ j ] = 0;
			}
			specialty[j] = validatePerk( specialty[j], j, i );
		}
		
		// OVERKILL - is currently disabled. 
		// We have other weapons like Shotguns, Crossbows and Rocket launchers moved into the Side Arm category
		// for now.
		//
		// Vahn 10/9/09
		//
		// if specialty2 is not Overkill, disallow anything besides pistols for secondary weapon
//		if ( level.tbl_PerkData[specialty2]["reference_full"] != "specialty_twoprimaries" )
//		{
//			if ( level.tbl_weaponIDs[secondary_num]["group"] != "weapon_pistol" )
//			{
//				iprintln( "^1Warning: (" + self.name + ") secondary weapon is not a pistol but perk 2 is not Overkill. Setting secondary weapon to pistol." );
//				secondary_num = 0;
//				secondary_attachment_flag = 0;
//			}
//		}

		self.custom_class[i]["primary"] = getFullWeaponName( i, "primary", attachmentsDisabled );
		self.custom_class[i]["secondary"] = getFullWeaponName( i, "secondary", attachmentsDisabled );
		
		// obtaining specialties, getting specialty reference strings
		self.custom_class[i]["specialties"] = [];
		for ( j = 0; j < specialty.size; j++ )
		{
			storeSpecialtyData( self, i, specialty[j] );
		}
	
		// armor
		self.custom_class[i]["body"] = body;
		self.custom_class[i]["head"] = head;
		
		self.custom_class[i]["player_render_options"]    = self calcPlayerOptions( i );
		self.custom_class[i]["primary_weapon_options"]   = self calcWeaponOptions( i, 0 );
		self.custom_class[i]["secondary_weapon_options"] = self calcWeaponOptions( i, 1 );
		self.cac_initialized = true;

	}
}

storeDefaultSpecialtyData( className, specialty )
{
	if ( !IsArray( specialty ) )
	{
		t = specialty;
		specialty = [];
		specialty[0] = t;
	}
	
	for ( i = 0; i < specialty.size; i++ )
	{
		index = level.default_perk[className].size;
		
		if ( IsString( specialty[i] ) )
		{
			level.default_perk[className][index] = specialty[i];
		}
		else
		{
			level.default_perk[className][index] = level.tbl_PerkData[specialty[i]]["reference_full"];
		}
	}
}

storeSpecialtyData( player, class_index, specialty )
{
	if ( !IsArray( specialty ) )
	{
		t = specialty;
		specialty = [];
		specialty[0] = t;
	}
	
	for ( i = 0; i < specialty.size; i++ )
	{
		index = player.custom_class[class_index]["specialties"].size;
		
		player.custom_class[class_index]["specialties"][index] = SpawnStruct();

		if ( IsString( specialty[i] ) )
		{
			player.custom_class[class_index]["specialties"][index].name			= specialty[i];
			player.custom_class[class_index]["specialties"][index].weaponref	= undefined;
			player.custom_class[class_index]["specialties"][index].count		= 0;
			player.custom_class[class_index]["specialties"][index].group		= "specialty";
		}
		else
		{
			player.custom_class[class_index]["specialties"][index].name			= level.tbl_PerkData[specialty[i]]["reference_full"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_cimage );
			player.custom_class[class_index]["specialties"][index].weaponref	= level.tbl_PerkData[specialty[i]]["reference"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_creference );
			player.custom_class[class_index]["specialties"][index].count		= level.tbl_PerkData[specialty[i]]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_ccount ) );
			player.custom_class[class_index]["specialties"][index].group		= level.tbl_PerkData[specialty[i]]["group"]; //tablelookup( "mp/statstable.csv", level.cac_cstat, specialty1, level.cac_cgroup );
		}
	}
}

isPerkGroup( perkName )
{
	return ( IsDefined( perkName ) && IsString( perkName ) );
}

setPerkIcon( classNum, specialtyNumber, perkIndex )
{
	if ( classNum < 0 )
	{
		return;
	}
	
	// this array is read from when perk icons are displayed on the screen (_globallogic.gsc - getPerks())
	if ( !IsDefined( self.custom_class[classNum]["specialty" + specialtyNumber] ) )
	{
		self.custom_class[classNum]["specialty" + specialtyNumber] = level.tbl_PerkData[ perkIndex ][ "reference_full" ];
	}
}

validatePerkGroup( perkGroup, perkIndex, classNum )
{
	perks = StrTok( perkGroup, "|" );

	if ( !isdefined( level.specialtyToPerkIndex ) )
	{
		level.specialtyToPerkIndex = [];
	}
		
	// only count base perks - not perk pro - Perk Pros have a 'count' of 1
	if ( ( isDefined( level.tbl_PerkData[ perkIndex ]["count"] ) ) && ( level.tbl_PerkData[ perkIndex ]["count"] == 0 ) )
	{
		for ( i = 0; i < perks.size; i++ )
		{
			if ( !isDefined( level.specialtyToPerkIndex[ perks[ i ] ] ) )
			{
				level.specialtyToPerkIndex[ perks[ i ] ] = perkIndex;
			}
			else
			{
				assert( level.specialtyToPerkIndex[ perks[ i ] ] == perkIndex );
			}
		}
	}
	
	return perks;
}

validatePerk( perkIndex, perkSlotIndex, classNum )
{
	if ( !isDefined( classNum ) )
	{
		classnum = -1; // invalid
	}
	
	perkGroup = undefined;
	specialtyNumber = perkSlotIndex + 1;
	
	if ( IsDefined( level.tbl_PerkData[ perkIndex ] ) )
	{
		perkGroup = level.tbl_PerkData[ perkIndex ][ "reference" ];
	}
	
	if ( isPerkGroup( perkGroup ) )
	{
		setPerkIcon( classNum, specialtyNumber, perkIndex );
		return validatePerkGroup( perkGroup, perkIndex, classNum );
	}

	// Return specialty_null
	perkIndex = level.perkReferenceToIndex[ "specialty_null" ];
	perks = [];
	perks[0] = "specialty_null";
	setPerkIcon( classNum, specialtyNumber, perkIndex );
	return perks;
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


// distributes the specialties into the corrent slots; inventory, grenades, special grenades, generic specialties
get_specialtydata( class_num, specialty, specialty_num )
{
	cac_reference	= specialty.name;
	cac_weaponref	= specialty.weaponref;	// for inventory whos string ref is the weapon ref
	cac_group		= specialty.group;
	cac_count		= specialty.count;
		
	assert( isdefined( cac_group ), "Missing "+specialty.name+"'s group name" );
	
	// the new professional pro that gives +1 to lethal and tactical grenades
	if( cac_reference == "specialty_twogrenades" && GetDvarint( "scr_game_perks" ) )
	{
		self.custom_class[class_num]["grenades_count"] = 2;
		self.custom_class[class_num]["specialgrenades_count"] = 3;
	}


	
	if ( cac_group == "specialty" )
	{
		self.specialty[self.specialty.size] = cac_reference;
	}
}



// clears all player's custom class variables, prepare for update with new stat data
reset_specialty_slots( class_num )
{
	self.specialty = [];		// clear all specialties
	self.custom_class[class_num]["inventory"] = "";
	self.custom_class[class_num]["inventory_count"] = 0;
	self.custom_class[class_num]["inventory_group"] = "";
	self.custom_class[class_num]["grenades"] = ""; 
	self.custom_class[class_num]["grenades_count"] = 0;
	self.custom_class[class_num]["grenades_group"] = "";
	self.custom_class[class_num]["specialgrenades"] = "";
	self.custom_class[class_num]["specialgrenades_count"] = 0;
	self.custom_class[class_num]["specialgrenades_group"] = "";
}

blackboxClassChoice( primary, secondary, grenades, specialgrenades, equipment )
{
	spawnid = getplayerspawnid( self );

	bbPrint( "mploadouts", "spawnid %d body %s head %s primary %s secondary %s grenade %s special %s equipment %s",
			spawnid,
			self.cac_body_type,
			self.cac_head_type,
			primary,
			secondary,
			grenades,
			specialgrenades,
			equipment
		   );

	for ( i = 0; i < self.killstreak.size; i++ )
	{
		bbPrint( "mpkillstreaks", "spawnid %d name %s", spawnid, self.killstreak[i] );
	}

	perks = self GetPerks();
	for ( i = 0; i < perks.size; i++ )
	{
		bbPrint( "mpspecialties", "spawnid %d name %s", spawnid, perks[i] );
	}
}

getFullCustomWeaponName( customClassNum, weaponSlot ) // weaponSlot should be 'primary' or 'secondary'
{
	assert( ( ( weaponSlot == "primary" ) || ( weaponSlot == "secondary" ) ), "weaponSlot should be primary or secondary" );
	
	weaponName = "weapon_null";
	
	if ( ( weaponSlot == "primary" ) || ( weaponSlot == "secondary" ) )
	{
		weaponNum = getCustomClassLoadoutItem ( customClassNum, weaponSlot );
		
		// Used to get m1911 as default if you didn't have a primary. No longer.
		/*if ( weaponSlot == "primary" )
		{
			weaponIndex = 3;
			assert( level.tbl_weaponIDs[weaponIndex]["reference"] == "m1911" );
			
			if ( weaponNum < 0 || !isDefined( level.tbl_weaponIDs[ weaponNum ] ) )
			{
					weaponNum = weaponIndex;
			}
		}*/
		
		if ( isDefined( level.tbl_weaponIDs[ weaponNum ] ) )
		{
			attachmenttop = getCustomClassLoadoutItem ( customClassNum, weaponSlot + "attachmenttop" );
			attachmentbottom = getCustomClassLoadoutItem ( customClassNum, weaponSlot + "attachmentbottom" );
			attachmenttrigger = getCustomClassLoadoutItem ( customClassNum, weaponSlot + "attachmenttrigger" );
			attachmentmuzzle = getCustomClassLoadoutItem ( customClassNum, weaponSlot + "attachmentmuzzle" );
		
			topName = getAttachmentString( weaponNum, attachmenttop );
			bottomName = getAttachmentString( weaponNum, attachmentbottom );
			triggerName = getAttachmentString( weaponNum, attachmenttrigger );
			muzzleName = getAttachmentString( weaponNum, attachmentmuzzle );
			
			weaponPrefix = level.tbl_weaponIDs[ weaponNum ][ "reference" ];
			
			if ( bottomName == "dw_" )
			{
				weaponName = weaponPrefix + bottomName + topName + triggerName + muzzleName + "mp";
			}
			else
			{
				weaponName = weaponPrefix + "_" + topName +	bottomName + triggerName + muzzleName + "mp";
			}
		}
	}
	
	return weaponName;
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
loadCustomGameModeClasses( team, class )
{
	if ( isSubstr( class, "CLASS_CUSTOM" ) )
	{
		// obtains the custom class number
		class_num = int( class[class.size-1] )-1;
		if( -1 == class_num )
			class_num = 9;
	}
	else
	{
		switch( class )
		{
		case "CLASS_SMG":
			class_num = 0;
			break;
		case "CLASS_CQB":
			class_num = 1;
			break;
		case "CLASS_ASSAULT":
			class_num = 2;
			break;
		case "CLASS_LMG":
			class_num = 3;
			break;
		default:
			class_num = 4;
			break;
		}
	}
	

	assert( class_num >= 0 && class_num < 10 );

	for( i = 0; i < 10; i ++ )
	{
		primary_grenade = getCustomClassLoadoutItem ( i, "primarygrenade" );
		primary_num = getCustomClassLoadoutItem ( i, "primary" );

		specialty = [];
		specialty[0] = getCustomClassLoadoutItem ( i, "specialty1" );
		specialty[1] = getCustomClassLoadoutItem ( i, "specialty2" );
		specialty[2] = getCustomClassLoadoutItem ( i, "specialty3" );
		
		body = getCustomClassLoadoutItem( i, "body" );
		body = level.tbl_armor[ body ];
		assert( IsDefined( body ) );

		head = getCustomClassLoadoutItem( i, "head" );
		head = level.tbl_armor[ head ];
		assert( IsDefined( head ) );
		
		special_grenade = getCustomClassLoadoutItem ( i, "specialgrenade" );
		
		equipment = getCustomClassLoadoutItem ( i, "equipment" );
		
		self.custom_class[i]["player_render_options"]    = self calcPlayerOptions( i );
		self.custom_class[i]["primary_weapon_options"]   = self calcWeaponOptions( i, 0 );
		self.custom_class[i]["secondary_weapon_options"] = self calcWeaponOptions( i, 1 );

		// builds the full primary grenade reference string
		self.custom_class[i]["primary_grenades"] = level.tbl_weaponIDs[primary_grenade]["reference"]+"_mp"; //tablelookup( "mp/statstable.csv", level.cac_numbering, special_grenade, level.cac_creference ) + "_mp";
		self.custom_class[i]["primary_grenades_count"] = 1; //int( tablelookup( "mp/statstable.csv", level.cac_numbering, special_grenade, level.cac_ccount ) );
		
		self.custom_class[i]["equipment_slot"] = level.tbl_weaponIDs[equipment]["reference"]+"_mp";
		self.custom_class[i]["equipment_slot_count"] = level.tbl_weaponIDs[equipment]["count"];

		for ( j = 0; j < specialty.size; j++ )
		{
			specialty[j] = validatePerk( specialty[j], j, i );
		}
		
		specialIndex = 70;
		assert( level.tbl_weaponIDs[specialIndex]["reference"] == "concussion_grenade" ); // if this fails we need to change specialIndex
		if ( !isDefined( level.tbl_weaponIDs[special_grenade] ) )
			special_grenade = specialIndex;
		specialGrenadeType = level.tbl_weaponIDs[special_grenade]["reference"];
		
		if ( specialGrenadeType != "weapon_null" )
		{
			if ( specialGrenadeType != "willy_pete" && specialGrenadeType != "concussion_grenade" && specialGrenadeType != "flash_grenade" && specialGrenadeType != "nightingale" && specialGrenadeType != "tabun_gas" )
			{
				iprintln( "^1Warning: (" + self.name + ") special grenade " + special_grenade + " is invalid. Setting to concussion grenade." );
				special_grenade = specialIndex;
			}
			
			for( j = 0; j < specialty.size; j++ )
			{
				if ( specialGrenadeType == "smoke_grenade" && level.tbl_PerkData[specialty[j]]["reference_full"] == "specialty_specialgrenade" )
				{
					iprintln( "^1Warning: (" + self.name + ") smoke grenade may not be used with extra special grenades. Setting to concussion grenade." );
					special_grenade = specialIndex;
				}
			}
		}
		
		self.custom_class[i]["primary"] = getFullCustomWeaponName( i, "primary" );
		self.custom_class[i]["secondary"] = getFullCustomWeaponName( i, "secondary" );
		
		// obtaining specialties, getting specialty reference strings
		self.custom_class[i]["specialties"] = [];
		for ( j = 0; j < specialty.size; j++ )
		{
			storeSpecialtyData( self, i, specialty[j] );
		}

		// builds the full special grenade reference string
		self.custom_class[i]["special_grenade"] = level.tbl_weaponIDs[special_grenade]["reference"]+"_mp"; //tablelookup( "mp/statstable.csv", level.cac_numbering, special_grenade, level.cac_creference ) + "_mp";
		self.custom_class[i]["special_grenade_count"] = level.tbl_weaponIDs[special_grenade]["count"]; //int( tablelookup( "mp/statstable.csv", level.cac_numbering, special_grenade, level.cac_ccount ) );
		
		// armor
		self.custom_class[i]["body"] = body;
		self.custom_class[i]["head"] = head;
		
		self.cac_initialized = true;

		// custom game mode class modifiers
		self.custom_class[i]["health"] = getCustomClassModifier( i, "health" );
		self.custom_class[i]["healthRegeneration"] = getCustomClassModifier( i, "healthRegeneration" );
		self.custom_class[i]["healthVampirism"] = getCustomClassModifier( i, "healthVampirism" );

		self.custom_class[i]["movementSpeed"] = getCustomClassModifier( i, "movementSpeed" );
		self.custom_class[i]["movementSprintSpeed"] = getCustomClassModifier( i, "movementSprintSpeed" );

		self.custom_class[i]["damage"] = getCustomClassModifier( i, "damage" );
		self.custom_class[i]["damageExplosive"] = getCustomClassModifier( i, "damageExplosive" );
	}						  	
							  	
	return class_num;		  
}			

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------
applyCustomClassModifiers()
{
	self maps\mp\gametypes\_customClasses::setMovementSpeedModifier();
	newHealth = self maps\mp\gametypes\_customClasses::getModifiedHealth();
	if( newHealth != 100 )
	{
		self.maxhealth = newHealth;
		self.health = self.maxhealth;
	}
}

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
getRandomValidCustomClass( team, class )
{
	classList = [];
	for( i=0; i < 10; i++ )
	{
		classTeam = getcustomclassmodifier( i, "team" );
		active = getcustomclassmodifier( i, "active" );
		// add all valid (active and any or current team) classes to the classList array
		if( active > 0 && ( classTeam == 1 || ( classTeam == 2 && team == "axis" ) || ( classTeam == 3 && team == "allies" ) ) )
		{
			classList[ classList.size ] = "CLASS_CUSTOM" + (i+1);
		}
	}
	return array_randomize( classList )[0];
}

listWeaponAttachments( weaponName, player )
{
	if ( isSubStr( weaponName, "dw_mp" ) )
	{
		attachments = [];
		
		attachments[ 0 ] = [];
		attachments[ 0 ] [ "name" ] = "dw";
		attachments[ 0 ] [ "point" ] = "muzzle";
		
		if ( isDefined( player ) )
		{
			if ( player getDstat( "purchasedAttachments", "dw" ) )
			{
				attachments[ 0 ][ "owned" ] = true;
			}
		}		
		
		return attachments;
	}
	
	subStrings = strtok( weaponName, "_" );
	
	numSubStrings = subStrings.size;
	
	numAttachments = 0;
	
	attachments = [];
	
	for ( currString = 0; currString < numSubStrings; currString++ )
	{		
		attachPoint = tableLookup( "mp/attachmenttable.csv", 4, subStrings[ currString ], 1 );

		if ( attachPoint == "" )
		{
			continue;	
		}
		
		attachments[ numAttachments ] = [];
		attachments[ numAttachments ] [ "name" ] = subStrings[ currString ];
		attachments[ numAttachments ] [ "point" ] = attachPoint;
			
		if ( isDefined( player ) )
		{
			if ( player getDstat( "purchasedAttachments", subStrings[ currString ] ) )
			{
				attachments[ numAttachments ][ "owned" ] = true;
			}
		}
		
		numAttachments++;
	}
	
	return attachments;
}



initStaticWeaponsTime()
{
	self.staticWeaponsStartTime = getTime();
}

initWeaponAttachments( weaponName )
{
	if ( self is_bot() )
	{
		return;
	}
	
	self.currentWeaponStartTime = getTime();
	
	self.currentWeapon = weaponName;
	
	self.currWeaponItemIndex = getBaseWeaponItemIndex( weaponName );
	
	self.currentAttachments = listWeaponAttachments( weaponName, self );

}

isEquipmentAllowed( equipment )
{
	// Removed these as we are now treating the equipment like a grenade, the same generic filters don't apply
	//if ( GetDvarint( "scr_disable_equipment" ) )
	//	return false;
	
	//if( equipment == "" )
	//	return false;

	//if ( equipment == "weapon_null_mp" )
	//	return false;
		
	if ( equipment == "camera_spike_mp" && self IsSplitScreen() )
		return false;
		
	if ( equipment == level.tacticalInsertionWeapon && GetDvarint( "scr_disable_tacinsert" ) )
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

	if( ( isSubstr( class, "CLASS_CUSTOM" ) || maps\mp\gametypes\_customClasses::isUsingCustomGameModeClasses() ) )
	{	
		pixbeginevent("custom class");
		// ============= custom class selected ==============
		// gets custom class data from stat bytes
		if( !( maps\mp\gametypes\_customClasses::isUsingCustomGameModeClasses() ) )
		{
			self cac_getdata();
			// obtains the custom class number
			class_num = int( class[class.size-1] )-1;

			//hacky patch to the system since when it was written it was never thought of that there could be 10 custom slots
			if( -1 == class_num )
				class_num = 9;
		}
		else
		{
			if( self is_bot() )
			{
				class = getRandomValidCustomClass( team, class );
				self setClass( class );
			}
			class_num = self loadCustomGameModeClasses( team, class );
		}

		self.class_num = class_num;
		
		assert( isdefined( self.custom_class[class_num]["primary"] ), "Custom class "+class_num+": primary weapon setting missing" );
		assert( isdefined( self.custom_class[class_num]["secondary"] ), "Custom class "+class_num+": secondary weapon setting missing" );
		
		// clear of specialty slots, repopulate the current selected class' setup
		self reset_specialty_slots( class_num );
		
		// Reset the count of the primary and special grenades (may be changed by the specialties)
		self.custom_class[class_num]["grenades"] = self.custom_class[class_num]["primary_grenades"];
		self.custom_class[class_num]["grenades_count"] = self.custom_class[class_num]["primary_grenades_count"];
		self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
		self.custom_class[class_num]["specialgrenades_count"] = self.custom_class[class_num]["special_grenade_count"];
		self.custom_class[class_num]["equipment"] = self.custom_class[class_num]["equipment_slot"];
		self.custom_class[class_num]["equipment_count"] = self.custom_class[class_num]["equipment_slot_count"];

		for ( i = 0; i < self.custom_class[class_num]["specialties"].size; i++ )
		{
			self get_specialtydata( class_num, self.custom_class[class_num]["specialties"][i], i );
		}
		
		// set re-register perks to code
		self register_perks();
		
		self SetActionSlot( 3, "altMode" );
		self SetActionSlot( 4, "" );
		
		// at this stage, the specialties are loaded into the correct weapon slots, and special slots

		giveKillStreaks( class_num );

		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			weapon = self.pers["weapon"];
		else
			weapon = self.custom_class[class_num]["primary"];
		
		primaryAttachmentsAllowed = true;
		
		if ( GetDvarint( "scr_disable_attachments" ) ) 
		{
			primaryAttachmentsAllowed = false;
		}
		else if ( GetDvarint( "scr_game_perks" ) == false )
		{
			classPrimaryAttachments = listWeaponAttachments( weapon, self );
			if ( classPrimaryAttachments.size > 1 ) // warlord perk
			{
				primaryAttachmentsAllowed = false;			
			}
		}
			
		if ( primaryAttachmentsAllowed == false )
		{
			weaponNum = getLoadoutItemFromDDLStats( class_num, "primary" );
			weapon = level.tbl_weaponIDs[ weaponNum ][ "reference" ] + "_mp";
		}
		
		sidearm = self.custom_class[class_num]["secondary"];

		if ( GetDvarint( "scr_disable_attachments" ) )
		{
			weaponNum = getLoadoutItemFromDDLStats( class_num, "secondary" );
			sidearm = level.tbl_weaponIDs[ weaponNum ][ "reference" ] + "_mp";
		}
		
		initialWeaponCount = 0;
		spawnWeapon = "";

		if ( sidearm != "weapon_null_mp" )
		{
			self GiveWeapon( sidearm, 0, int( self.custom_class[class_num]["secondary_weapon_options"] ) );
			if ( self cac_hasSpecialty( "specialty_extraammo" ) )
				self giveMaxAmmo( sidearm );
	
			//If it is a pistol, don't play first raise anim
			//if( maps\mp\gametypes\_weapons::isPistol( sidearm ) )
			spawnWeapon = sidearm;
				
			initialWeaponCount++;
		}
					
		// give primary weapon
		primaryWeapon = weapon;
		
		if ( primaryWeapon != "weapon_null_mp" )
		{
			assert( isdefined( self.custom_class[class_num]["primary_weapon_options"] ), "Player's weapon options is not defined, it should be at least initialized to 0" );
	
			primaryTokens = strtok( primaryWeapon, "_" );
			self.pers["primaryWeapon"] = primaryTokens[0];
			
			self GiveWeapon( weapon, 0, int( self.custom_class[class_num]["primary_weapon_options"] ) );
			self SetPlayerRenderOptions( int( self.custom_class[class_num]["player_render_options"] ) );
			
			if ( self cac_hasSpecialty( "specialty_extraammo" ) )
				self giveMaxAmmo( weapon );
				
			spawnWeapon = weapon;
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

		secondaryWeapon = self.custom_class[class_num]["inventory"];
		if ( secondaryWeapon != "" )
		{
			self GiveWeapon( secondaryWeapon );
			
			self setWeaponAmmoOverall( secondaryWeapon, self.custom_class[class_num]["inventory_count"] );
			
			self SetActionSlot( 3, "weapon", secondaryWeapon );
			self SetActionSlot( 4, "" );
		}
		
		// give frag for all no matter what
		grenadeTypePrimary = self.custom_class[class_num]["grenades"]; 
		grenadeTypeSecondary = self.custom_class[class_num]["specialgrenades"]; 
		
		if ( grenadeTypePrimary != "" && grenadeTypePrimary != "weapon_null_mp" && isEquipmentAllowed( grenadeTypePrimary ) )
		{
			grenadeCount = self.custom_class[class_num]["grenades_count"]; 
	
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
			self setOffhandPrimaryClass( grenadeTypePrimary );
		}
		else
		{
			// we need to make this a blank slot. to do this we need to give a grenade,
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
			
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, 0 );
		}

		self.grenadeTypePrimary = grenadeTypePrimary;
		self.grenadeTypePrimaryCount = grenadeCount;

		// give secondary grenade
		if ( grenadeTypeSecondary != "" && grenadeTypeSecondary != "weapon_null_mp" && isEquipmentAllowed( grenadeTypeSecondary ) )
		{
			grenadeCount = self.custom_class[class_num]["specialgrenades_count"]; 
	
			self setOffhandSecondaryClass( grenadeTypeSecondary );
			
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
			self.grenadeTypeSecondary = grenadeTypeSecondary;
			self.grenadeTypeSecondaryCount = grenadeCount;
		}

		// TODO: remove this once design has settled on the new LB/RB plan
		//give equipment
		equipment_weapon = "";
		//equipment_weapon = self.custom_class[class_num]["equipment"];
		
		//if ( isEquipmentAllowed( equipment_weapon ) )
		//{
		//	self GiveWeapon( equipment_weapon );
			
		//	self setWeaponAmmoOverall( equipment_weapon, self.custom_class[class_num]["equipment_count"] );
			
			//self SetActionSlot( 1, "weapon", equipment_weapon );
		//}

		self maps\mp\teams\_teams::set_player_model( team, weapon );

		self initStaticWeaponsTime();
		
		self thread initWeaponAttachments( primaryWeapon );

		self thread blackboxClassChoice( primaryWeapon, sidearm, grenadeTypePrimary, grenadeTypeSecondary, equipment_weapon );
	}
	else if ( self is_bot() )
	{
		pixbeginevent("bot");
		self maps\mp\bots\_bot::bot_give_loadout();
		pixendevent(); // "bot"
	}
	else
	{			
		pixbeginevent("default class");
		// ============= selected one of the default classes ==============
				
		// load the selected default class's specialties
		assert( isdefined(self.pers["class"]), "Player during spawn and loadout got no class!" );
		selected_class = self.pers["class"];
		
		//println( "^5selected_class = " + selected_class );	
		
		specialty_size = level.default_perk[selected_class].size;
		
		//println( "^5level.default_perk[selected_class].size = " + level.default_perk[selected_class].size );
		//println( "^5specialty_size = " + specialty_size );	
		
		for( i = 0; i < specialty_size; i++ )
		{
			if( isdefined( level.default_perk[selected_class][i] ) && level.default_perk[selected_class][i] != "" )
				self.specialty[self.specialty.size] = level.default_perk[selected_class][i];
		}
		assert( isdefined( self.specialty ) && self.specialty.size > 0, "Default class: " + self.pers["class"] + " is missing specialties " );
		
		// re-registering perks to code since perks are cleared after respawn in case if players switch classes
		self register_perks();
		
		self SetActionSlot( 3, "altMode" );
		self SetActionSlot( 4, "" );

		giveKillStreaks( class );
		
		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
		{
			weapon = self.pers["weapon"];
		}
		else
		{
			weapon = level.classWeapons[team][class][primaryIndex];
		}
		
		// give sidearm
		sidearm = level.classSidearm[team][class];
		// AE 10-22-09: added the check to make sure the sidearm exists (did this for the larry's)
		if ( sidearm != "" && sidearm != "weapon_null_mp" )
		{
			println( "^5GiveWeapon( " + sidearm + " ) -- sidearm" );
			self GiveWeapon( sidearm );
			if ( self cac_hasSpecialty( "specialty_extraammo" ) )
				self giveMaxAmmo( sidearm );

			//If it is a pistol, don't play first raise anim
			if( maps\mp\gametypes\_weapons::isPistol( sidearm ) )
				self setSpawnWeapon( sidearm );
		}

		// give primary weapon
		primaryWeapon = weapon;

		primaryTokens = strtok( primaryWeapon, "_" );
		self.pers["primaryWeapon"] = primaryTokens[0];
		
		// TODO: what is this doing here?? why do we want to not take the m14??
		/*
		if ( self.pers["primaryWeapon"] == "m14" )
			self.pers["primaryWeapon"] = "m21";
		*/
	
		println( "^5GiveWeapon( " + weapon + " ) -- weapon" );
		self GiveWeapon( weapon );
		if( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( weapon );
			
		self setSpawnWeapon( weapon );

//		default classes do not support attachments currently
//		secondaryWeapon = level.classItem[team][class]["type"];	
//		// AE 10-22-09: added the check to make sure the secondaryWeapon exists (did this for the larry's)
//		if ( secondaryWeapon != "" && secondaryWeapon != "weapon_null_mp" )
//		{
//println( "^5GiveWeapon( " + secondaryWeapon + " ) -- secondaryWeapon" );
//			self GiveWeapon( secondaryWeapon );
//			
//			self setWeaponAmmoOverall( secondaryWeapon, level.classItem[team][class]["count"] );
//			
//			self SetActionSlot( 3, "weapon", secondaryWeapon );
//			self SetActionSlot( 4, "" );
//		}
		
		grenadeTypePrimary = level.classGrenades[class]["primary"]["type"];
		// AE 10-22-09: added the check to make sure the grenadeTypePrimary exists (did this for the larry's)
		if ( grenadeTypePrimary != "" && grenadeTypePrimary != "weapon_null_mp" )
		{
			grenadeCount = level.classGrenades[class]["primary"]["count"];
	
println( "^5GiveWeapon( " + grenadeTypePrimary + " ) -- grenadeTypePrimary" );
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
			self.grenadeTypePrimary = grenadeTypePrimary;
			self.grenadeTypePrimaryCount = grenadeCount;
		}
		
		grenadeTypeSecondary = level.classGrenades[class]["secondary"]["type"];
		// AE 10-22-09: added the check to make sure the grenadeTypePrimary exists (did this for the larry's)
		if ( grenadeTypeSecondary != "" && grenadeTypeSecondary != "weapon_null_mp" )
		{
			grenadeCount = level.classGrenades[class]["secondary"]["count"];
	
			self setOffhandSecondaryClass( grenadeTypeSecondary );

println( "^5GiveWeapon( " + grenadeTypeSecondary + " ) -- grneadeTypeSecondary" );
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
			self.grenadeTypeSecondary = grenadeTypeSecondary;
			self.grenadeTypeSecondaryCount = grenadeCount;
		}

		//give equipment
		equipment_weapon = level.default_equipment[ class ][ "type" ];
		if ( isEquipmentAllowed( equipment_weapon ) && ( equipment_weapon != "weapon_null_mp" ) )
		{
			self GiveWeapon( equipment_weapon );
			
			self setWeaponAmmoOverall( equipment_weapon, level.default_equipment[ class ][ "count" ] );
			
			self SetActionSlot( 1, "weapon", equipment_weapon );
		}

		self maps\mp\teams\_teams::set_player_model( team, weapon );

		self initStaticWeaponsTime();
		
		self thread initWeaponAttachments( primaryWeapon );

		self thread blackboxClassChoice( primaryWeapon, sidearm, grenadeTypePrimary, grenadeTypeSecondary, equipment_weapon );

		pixendevent(); // "default class"
	}


	if( maps\mp\gametypes\_customClasses::isUsingCustomGameModeClasses() )
	{
		self applyCustomClassModifiers();
	}

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
	
	pixendevent();
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
	
	// Last stand is cut, freeing up hudelems
	//self.canreviveothers = true;
	//if( !SessionModeIsZombiesGame() )
	//{
	//	maps\mp\_laststand::setupRevive();
	//}
}
	
register_perks()
{
	perks = self.specialty;
	self clearPerks();
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];

		// TO DO: ask code to register the inventory perks and null perk
		// not registering inventory and null perks to code
		if ( perk == "specialty_null" || isSubStr( perk, "specialty_weapon_" ) || perk == "weapon_null" )
			continue;
			
		if ( !GetDvarint( "scr_game_perks" ) )
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

// CAC: Selected feature check function, returns boolean if a specialty is selected by the current class
// Info: Called on "player" as self, "feature" parameter is a string reference of the specialty in question
cac_hasSpecialty( perk_reference )
{
	return_value = self hasPerk( perk_reference );
	return return_value;
	
	/*
	perks = self.specialty;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		if( perk == perk_reference )
			return true;
	}
	return false;
	*/
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
	
	if( attacker cac_hasSpecialty( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) )
	
	// if( issubstr( weapon, "_hp_" ) && isPrimaryDamage( meansofdeath ) )
	
	{
		final_damage = damage*(100+level.cac_bulletdamage_data)/100;
		/#
		if ( GetDvarint( "scr_perkdebug") )
		println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to vehicle" );
		#/
	}

	else if( attacker cac_hasSpecialty( "specialty_explosivedamage" ) && isPlayerExplosiveWeapon( weapon, meansofdeath )  )
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

// CAC: Weapon Specialty: Increased bullet damage feature
// CAC: Weapon Specialty: Armor Vest feature
// CAC: Weapon Specialty: Flak Jacket feature
// CAC: Ability: Increased explosive damage feature
cac_modified_damage( victim, attacker, damage, meansofdeath, weapon, inflictor, hitloc )
{
	// skip conditions
	if( !isdefined( victim) || !isdefined( attacker ) || !isplayer( attacker ) || !isplayer( victim ) )
		return damage;
	if( !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;
	if( !IsDefined(hitloc) || hitloc == "" )
		hitloc = "torso_upper";
		
	old_damage = damage;
	final_damage = damage;
	
	/* Cases =======================
	attacker - bullet damage
		victim - none
		victim - armor
	attacker - explosive damage
		victim - none
		victim - armor
	attacker - none
		victim - none
		victim - armor
	===============================*/
	
	// if attacker has bullet damage then increase bullet damage
	// Perk version
	
	
	// Attachment version
	//if( isplayer( attacker ) && issubstr( weapon, "_hp_" ) && isPrimaryDamage( meansofdeath ) )  
	
	if( ( isplayer( attacker ) && attacker cac_hasSpecialty( "specialty_bulletdamage" ) ) && isPrimaryDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) && !isHeadDamage( hitloc ) )
		{
			final_damage = old_damage;
			/#
			if ( GetDvarint( "scr_perkdebug") )
			println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased bullet damage" );
			#/
		}
		else
		{
			final_damage = damage*(100+level.cac_bulletdamage_data)/100;
			/#
			if ( GetDvarint( "scr_perkdebug") )
			println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to " + victim.name );
			#/
		}
	}
	else if( victim cac_hasSpecialty( "specialty_armorvest" ) && isPrimaryDamage( meansofdeath ) && !isHeadDamage( hitloc ) )
	{	
		//If victim has body armor, reduce the damage by the cac armor vest value as a percentage
		final_damage = damage*(level.cac_armorvest_data *.01);
		/#
			if ( GetDvarint( "scr_perkdebug") )
				println( "Perk/> " + attacker.name + "'s bullet damage did less damage to " + victim.name );
		#/

	}
	else if ( victim cac_hasSpecialty ("specialty_fireproof") && isFireDamage( weapon, meansofdeath ) )
	{
		level.cac_fireproof_data = cac_get_dvar_int( "perk_fireproof", level.cac_fireproof_data );
		
		final_damage = damage*((100-level.cac_fireproof_data)/100);
		/#
		if ( GetDvarint( "scr_perkdebug") )
		println( "Perk/> " + attacker.name + "'s flames did less damage to " + victim.name );
		#/
	}
	else if( attacker cac_hasSpecialty( "specialty_explosivedamage" ) && isPlayerExplosiveWeapon( weapon, meansofdeath ) )
	{
		final_damage = damage*(100+level.cac_explosivedamage_data)/100;
		/#
		if ( GetDvarint( "scr_perkdebug") )
		println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to " + victim.name );
		#/
	}
	else if (victim cac_hasSpecialty( "specialty_flakjacket" ) && ( !isdefined( inflictor.stucktoplayer ) || inflictor.stucktoplayer != victim ) && meansofdeath != "MOD_PROJECTILE"  && weapon != "briefcase_bomb_mp" && weapon != "tabun_gas_mp" && weapon != "concussion_grenade_mp" && weapon != "flash_grenade_mp" && weapon != "willy_pete_mp" )
	{
		if ( isExplosiveDamage( meansofdeath, weapon ) || isSubStr( weapon, "explodable_barrel" ) || isSubStr( weapon, "destructible_car" ))
		{
			// put these back in to make FlakJacket a perk again (for easy tuning of system when not body type specfic)
			level.cac_flakjacket_data = cac_get_dvar_int( "perk_flakJacket", level.cac_flakjacket_data );
			if( level.hardcoreMode )
			{
				level.cac_flakjacket_data = cac_get_dvar_int( "perk_flakJacket_hardcore", level.cac_flakjacket_hardcore_data );
			}
			
			if ( isdefined( attacker ) && isplayer( attacker) )
			{
				if ( level.teambased )
				{
					if ( attacker.team != victim.team )
					{
						victim thread maps\mp\_properks::flakjacketProtected();
					}
				}
				else
				{
					if ( attacker != victim )
					{
						victim thread maps\mp\_properks::flakjacketProtected();
					}
				}
			}

			final_damage = int( old_damage * ( level.cac_flakjacket_data / 100 ) );

			/#
			if ( GetDvarint("scr_perkdebug") )
			println( "Perk/> " + victim.name + "'s flak jacket decreased " + attacker.name + "'s grenade damage" );
			#/
		}		
	}
	else
	{	
		final_damage = old_damage;
	}

	/#
		victim.cac_debug_damage_type = tolower( meansofdeath );
		victim.cac_debug_original_damage = old_damage;
		victim.cac_debug_final_damage = final_damage;
		victim.cac_debug_location = tolower( hitloc );
		victim.cac_debug_weapon = tolower( weapon );
		victim.cac_debug_range = int( Distance( attacker.origin, victim.origin ) );
	#/
	
	// debug
	/#
	if ( GetDvarint( "scr_perkdebug") )
	println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
	#/
	
	// return unchanged damage
	return int( final_damage );
}

// including grenade launcher, grenade, bazooka, betty, satchel charge
isExplosiveDamage( meansofdeath, weapon )
{
	explosivedamage = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE";
			
	if( isSubstr( explosivedamage, meansofdeath ) )
		return true;
	return false;
}

// if primary weapon damage
isPrimaryDamage( meansofdeath )
{
	// including pistols as well since sometimes they share ammo
	if( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" )
		return true;
	return false;
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
	if ( !isExplosiveDamage( meansofdeath, weapon ) )
		return false;
		
	if ( weapon == "artillery_mp" || weapon == "airstrike_mp" || weapon == "napalm_mp" || weapon == "mortar_mp" || weapon == "hind_ffar_mp" || weapon == "cobra_ffar_mp" )
		return false;
	
	// no tank main guns
	if ( issubstr(weapon, "turret" ) )
		return false;
	
	return true;
}

isHeadDamage( hitloc )
{
	return ( hitloc == "helmet" || hitloc == "head" || hitloc == "neck" );
}
