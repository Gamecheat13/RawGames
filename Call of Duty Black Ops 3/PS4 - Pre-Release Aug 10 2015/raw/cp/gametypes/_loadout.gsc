#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\array_shared;

#using scripts\shared\killstreaks_shared;
#using scripts\shared\loadout_shared;
#using scripts\shared\system_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_util;

                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     

#using scripts\cp\gametypes\_dev;
#using scripts\cp\_challenges;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\teams\_teams;
#using scripts\cp\cybercom\_cybercom_util;


                              

#namespace loadout;

function autoexec __init__sytem__() {     system::register("loadout",&__init__,undefined,undefined);    }

function __init__()
{
	level.player_interactive_model = "c_usa_cia_masonjr_viewbody";
	
	callback::on_start_gametype( &init );
	callback::on_connect( &on_connect );
}

function on_connect()
{
}

function init()
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
	level.maxSpecialties = 6;
	level.maxBonuscards = 3;
	level.maxAllocation = GetGametypeSetting( "maxAllocation" );
	level.loadoutKillstreaksEnabled = GetGametypeSetting( "loadoutKillstreaksEnabled" );
	
	level.PrestigeNumber = 5;
	
	level.defaultClass = "CLASS_ASSAULT";
	
	if ( tweakables::getTweakableValue( "weapon", "allowfrag" ) )
	{
		level.weapons["frag"] = GetWeapon( "frag_grenade" );
	}
	else	
	{
		level.weapons["frag"] = "";
	}

	if ( tweakables::getTweakableValue( "weapon", "allowsmoke" ) )
	{
		level.weapons["smoke"] = GetWeapon( "smoke_grenade" );
	}
	else	
	{
		level.weapons["smoke"] = "";
	}

	if ( tweakables::getTweakableValue( "weapon", "allowflash" ) )
	{
		level.weapons["flash"] = GetWeapon( "flash_grenade" );
	}
	else	
	{
		level.weapons["flash"] = "";
	}

	level.weapons["concussion"] = GetWeapon( "concussion_grenade" );

	// SRS 11/28/2007: changed c4 to satchel
	if ( tweakables::getTweakableValue( "weapon", "allowsatchel" ) )
	{
		level.weapons["satchel_charge"] = GetWeapon( "satchel_charge" );
	}
	else	
	{
		level.weapons["satchel_charge"] = "";
	}

	if ( tweakables::getTweakableValue( "weapon", "allowbetty" ) )
	{
		level.weapons["betty"] = GetWeapon( "mine_bouncing_betty" );
	}
	else	
	{
		level.weapons["betty"] = "";
	}

	if ( tweakables::getTweakableValue( "weapon", "allowrpgs" ) )
	{
		level.weapons["rpg"] = GetWeapon( "rpg" );
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
		{
			continue;
		}
		if( !isdefined( level.tbl_weaponIDs[i] ) || level.tbl_weaponIDs[i]["reference"] == "" )
		{
			continue;
		}
	
		weapon_type = level.tbl_weaponIDs[i]["group"];
		weapon = level.tbl_weaponIDs[i]["reference"];
		attachment = level.tbl_weaponIDs[i]["attachment"];
	
		weapon_class_register( weapon, weapon_type );	
	
		if( isdefined( attachment ) && attachment != "" )
		{	
			attachment_tokens = strtok( attachment, " " );
			if( isdefined( attachment_tokens ) )
			{
				if( attachment_tokens.size == 0 )
					weapon_class_register( weapon+"_"+attachment, weapon_type );	
				else
				{
					// multiple attachment options
					for( k = 0; k < attachment_tokens.size; k++ )
						weapon_class_register( weapon+"_"+attachment_tokens[k], weapon_type );
				}
			}
		}
	}
	
	level thread onPlayerConnecting();
	
}

function create_class_exclusion_list()
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
	while( GetDvarString( "attachment_exclusion_" + currentDvar ) !="" )
	{
		level.attachmentExclusions[ currentDvar ] = GetDvarString( "attachment_exclusion_" + currentDvar );
		currentDvar++;
	}

}


function is_attachment_excluded( attachment )
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

function set_statstable_id()
{
	if ( !isdefined( level.statsTableID ) )
	{
		level.statsTableID = TableLookupFindCoreAsset( util::getStatsTableName() );
	}
}

function get_item_count( itemReference )
{
	set_statstable_id();
	
	itemCount = int( tableLookup( level.statsTableID, 4, itemReference, 5 ) );
	if ( itemCount < 1 )
	{
		itemCount = 1;
	} 
	
	return itemCount;
}
	
function getDefaultClassSlotWithExclusions( className, slotName )
{
	itemReference = GetDefaultClassSlot( className, slotName );
	
	set_statstable_id();
	
	itemIndex = int( tableLookup( level.statsTableID, 4, itemReference, 0 ) );
	
	if ( loadout::is_item_excluded( itemIndex ) )
	{
		itemReference = tableLookup( level.statsTableID, 0, 0, 4 );
	}
	
	return itemReference;
}
	
function load_default_loadout( weaponclass, classNum )
{
	level.classToClassNum[ weaponclass ] = classNum;
}
			
function weapon_class_register( weaponName, weapon_type )
{
	if( isSubstr( "weapon_smg weapon_cqb weapon_assault weapon_lmg weapon_sniper weapon_shotgun weapon_launcher weapon_special", weapon_type ) )
		level.primary_weapon_array[GetWeapon( weaponName )] = 1;	
	else if( isSubstr( "weapon_pistol", weapon_type ) )
		level.side_arm_array[GetWeapon( weaponName )] = 1;
	else if( weapon_type == "weapon_grenade" )
		level.grenade_array[GetWeapon( weaponName )] = 1;
	else if( weapon_type == "weapon_explosive" )
		level.inventory_array[GetWeapon( weaponName )] = 1;
	else if( weapon_type == "weapon_rifle" ) // COD5 WEAPON TEST
		level.inventory_array[GetWeapon( weaponName )] = 1;
	else
		assert( false, "Weapon group info is missing from statsTable for: " + weapon_type );
}

// create a class init
function cac_init()
{
	level.tbl_weaponIDs = [];
	
	set_statstable_id();

	for( i = 0; i < 256; i++ )
	{
		itemRow = tableLookupRowNum( level.statsTableID, 0, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( level.statsTableID, itemRow, 2 );
			
			if ( isSubStr( group_s, "weapon_" ) || group_s == "hero" )
			{
				reference_s = tableLookupColumnForRow( level.statsTableID, itemRow, 4 );
				if( reference_s != "" )
				{
					weapon = GetWeapon( reference_s );

					level.tbl_weaponIDs[i]["reference"] = reference_s;
					level.tbl_weaponIDs[i]["group"] = group_s;
					level.tbl_weaponIDs[i]["count"] = int( tableLookupColumnForRow( level.statsTableID, itemRow, 5 ) );
					level.tbl_weaponIDs[i]["attachment"] = tableLookupColumnForRow( level.statsTableID, itemRow, 8 );
				}				
			}
		}
	}
	
	level.perkNames = [];

	// generating perk data vars collected form statsTable.csv
	for( i = 0; i < 256; i++ )
	{
		itemRow = tableLookupRowNum( level.statsTableID, 0, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( level.statsTableID, itemRow, 2 );
		
			if ( group_s == "specialty" )
			{
				reference_s = tableLookupColumnForRow( level.statsTableID, itemRow, 4 );
				
				if( reference_s != "" )
				{
					perkIcon = tableLookupColumnForRow( level.statsTableID, itemRow, 6 );
					perkName  = tableLookupIString( level.statsTableID, 0, i, 3 );
				
					level.perkNames[ perkIcon ] = perkName;
				}
			}
		}
	}
	
	level.killStreakNames = [];
	level.killStreakIcons = [];
	level.KillStreakIndices = [];

	// generating kill streak data vars collected form statsTable.csv
	for( i = 0; i < 256; i++ )
	{
		itemRow = tableLookupRowNum( level.statsTableID, 0, i );
		
		if ( itemRow > -1 )
		{
			group_s = tableLookupColumnForRow( level.statsTableID, itemRow, 2 );
			
			if ( group_s == "killstreak" )
			{
				reference_s = tableLookupColumnForRow( level.statsTableID, itemRow, 4 );
				
				if( reference_s != "" )
				{
					level.tbl_KillStreakData[i] = reference_s;
					level.killStreakIndices[ reference_s ] = i;
					icon = tableLookupColumnForRow( level.statsTableID, itemRow, 6 );
					name = tableLookupIString( level.statsTableID, 0, i, 3 );
					
					level.killStreakNames[ reference_s ] = name;
					level.killStreakIcons[ reference_s ] = icon;
					level.killStreakIndices[ reference_s ] = i;
				}
			}
		}
	}
}

function getClassChoice( response )
{
	assert( isdefined( level.classMap[ response ] ) );
	
	return ( level.classMap[ response ] );
}


// ============================================================================


function getAttachmentString( weaponNum, attachmentNum )
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

function getAttachmentsDisabled()
{
	if ( !isdefined( level.attachmentsDisabled ) )
	{
		return false;
	}
	
	return level.attachmentsDisabled;
	
}

function getKillStreakIndex( weaponclass, killstreakNum )
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
		return( self GetLoadoutItem( weaponclass, killstreakString ) );
	}
}

function giveKillstreaks( classNum )
{
		self.killstreak = [];
		
		if ( !level.loadoutKillstreaksEnabled )
			return;
		
		sortedKillstreaks = [];
		currentKillstreak = 0;
		
		for ( killstreakNum = 0; killstreakNum < level.maxKillstreaks; killstreakNum++ )
		{
			killstreakIndex = getKillStreakIndex( classNum, killstreakNum );
			
			if ( isdefined( killstreakIndex ) && ( killstreakIndex > 0 ) )
			{
				assert( isdefined( level.tbl_KillStreakData[ killstreakIndex ] ), "KillStreak #:" + killstreakIndex + "'s data is undefined" );
				
				if ( isdefined( level.tbl_KillStreakData[ killstreakIndex ] ) )
				{
					self.killstreak[ currentKillstreak ] = level.tbl_KillStreakData[ killstreakIndex ];
					if ( isdefined( level.usingMomentum ) && level.usingMomentum )
					{
						killstreakType = killstreaks::get_by_menu_name( self.killstreak[ currentKillstreak ] );
						if ( isdefined( killstreakType ) )
						{
							weapon = killstreaks::get_killstreak_weapon( killstreakType );
							
							/#	println( "^5Loadout " + self.name + " GiveWeapon( " + weapon.name + " ) -- killstreak" );	#/

							self GiveWeapon( weapon );

							if ( isdefined( level.usingScoreStreaks ) && level.usingScoreStreaks )
							{
								if( weapon.isCarriedKillstreak )
								{
									if( !isdefined( self.pers["held_killstreak_ammo_count"][weapon] ) )
										self.pers["held_killstreak_ammo_count"][weapon] = 0;

									if( !isDefined( self.pers["held_killstreak_clip_count"][weapon] ) )
										self.pers["held_killstreak_clip_count"][weapon] = 0;

									if( self.pers["held_killstreak_ammo_count"][weapon] > 0 )
									{
										self setWeaponAmmoClip( weapon, self.pers["held_killstreak_clip_count"][weapon] );
										self setWeaponAmmoStock( weapon, self.pers["held_killstreak_ammo_count"][weapon] - self.pers["held_killstreak_clip_count"][weapon] );
									}
									else
									{
										self setWeaponAmmoOverall( weapon, 0 );
									}
								}
								else
								{
									quantity = self.pers["killstreak_quantity"][weapon];
									if ( !isdefined( quantity ) )
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
		if ( isdefined( level.usingMomentum ) && level.usingMomentum )
		{
			for ( sortIndex = 0 ; (sortIndex < sortedKillstreaks.size && sortIndex < actionSlotOrder.size) ; sortIndex++ )
			{
				self SetActionSlot( actionSlotOrder[sortIndex], "weapon", sortedKillstreaks[sortIndex].weapon );
			}
		}
}


function isPerkGroup( perkName )
{
	return ( isdefined( perkName ) && IsString( perkName ) );
}

// clears all player's custom class variables, prepare for update with new stat data
function reset_specialty_slots( class_num )
{
	self.specialty = [];		// clear all specialties
}

//------------------------------------------------------------------------------
// self = player
//------------------------------------------------------------------------------

function initStaticWeaponsTime()
{
	self.staticWeaponsStartTime = getTime();
}


function isEquipmentAllowed( equipment_name )
{
	if ( equipment_name == level.weapontacticalInsertion.name && level.disableTacInsert )
		return false;

	return true;
}

function isLeagueItemRestricted( item )
{
	if ( level.leagueMatch )
	{
		return ( IsItemRestricted( item ) );
	}

	return false;
}
							  	
function giveLoadoutLevelSpecific( team, weaponclass )	  
{
	pixbeginevent("giveLoadoutLevelSpecific");

	if ( isdefined( level.giveCustomCharacters ) )
	{
		self [[level.giveCustomCharacters]]();
	}
	
	if ( isdefined( level.giveCustomLoadout ) )
	{
		self [[level.giveCustomLoadout]]();
	}
	
	pixendevent();
}

function giveLoadout( team, weaponclass, dontRestoreCybercom )	  
{
	pixbeginevent("giveLoadout");
	
	self takeAllWeapons();	  	
	
	primaryIndex = 0;
	
	// initialize specialty array
	self.specialty = [];
	self.killstreak = [];
	
	self notify( "give_map" );

	class_num_for_global_weapons = 0;
	primaryWeaponOptions = 0;
	secondaryWeaponOptions = 0;
	playerRenderOptions = 0;
	primaryGrenadeCount = 0;	
	isCustomClass = false;

	if( isSubstr( weaponclass, "CLASS_CUSTOM" ) )
	{	
		pixbeginevent("custom class");
		// ============= custom class selected ==============
		// gets custom class data from stat bytes
		// obtains the custom class number
		class_num = int( weaponclass[weaponclass.size-1] )-1;

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
		
		class_num_for_global_weapons = class_num;
		isCustomClass = true;

		pixendevent(); // "custom class"
	}
	else
	{			
		pixbeginevent("default class");
		// ============= selected one of the default classes ==============
			
		// load the selected default class's specialties
		assert( isdefined(self.pers["class"]), "Player during spawn and loadout got no class!" );
		
		class_num = level.classToClassNum[ weaponclass ];
		
		if ( !isDefined( class_num ) )
		{
			if ( self util::is_bot() )
				class_num = array::random( level.classToClassNum );
			else
				assert( 0, "Player during spawn and loadout got invalid class! '" + weaponclass + "'" );
		}
				
		self.class_num = class_num;
		
		pixendevent(); // "default class"
	}
	
	//TODO - add melee weapon selection to the CAC stuff and default loadouts	
	knifeWeaponOptions = self CalcWeaponOptions( class_num, 2 );
	
	/#	println( "^5Loadout " + self.name + " GiveWeapon( " + level.weaponBaseMelee.name + " ) -- level.weaponBaseMelee 0" );	#/

	self GiveWeapon( level.weaponBaseMelee, knifeWeaponOptions );
	
	self.specialty = self GetLoadoutPerks( class_num );

	if ( level.leagueMatch )
	{
		for ( i = 0; i < self.specialty.size; i++ )
		{
			if ( isLeagueItemRestricted( self.specialty[i] ) )
			{
				ArrayRemoveIndex( self.specialty, i );
				i--;
			}
		}
	}
	
	// re-registering perks to code since perks are cleared after respawn in case if players switch classes
	self register_perks();
	
	self SetActionSlot( 3, "altMode" );
	self SetActionSlot( 4, "" );
	
	giveKillStreaks( class_num_for_global_weapons );
	
	spawnWeapon = "";
	initialWeaponCount = 0;
	
	// weapon override for round based gametypes
	// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
	if ( isdefined( self.pers["weapon"] ) && self.pers["weapon"] != level.weaponNone && !self.pers["weapon"].isCarriedKillstreak )
		primaryWeapon = self.pers["weapon"];
	else
	{
		primaryWeapon = self GetLoadoutWeapon( class_num, "primary" );
	}

	if( primaryWeapon.isCarriedKillstreak )
		primaryWeapon = level.weaponNull;
	
	sidearm = self GetLoadoutWeapon( class_num, "secondary" );

	if( sidearm.isCarriedKillstreak )
			sidearm = level.weaponNull;

	self.primaryWeaponKill = false;
	self.secondaryWeaponKill = false;

	// give seconday weapon
	if ( sidearm != level.weaponNull )
	{
		secondaryWeaponOptions = self CalcWeaponOptions( class_num, 1 );
		
		/#	println( "^5Loadout " + self.name + " GiveWeapon( " + sidearm.name + " ) -- sidearm" );	#/
		
		acvi = self GetAttachmentCosmeticVariantForWeapon( class_num, "secondary" );
		self GiveWeapon( sidearm, secondaryWeaponOptions, acvi );
		self.secondaryLoadoutWeapon = sidearm;
		self.secondaryLoadoutAltWeapon = sidearm.altWeapon;
		self giveMaxAmmo( sidearm );

		spawnWeapon = sidearm;
		initialWeaponCount++;
	}
	
	self.pers["primaryWeapon"] = primaryWeapon;
		
	// give primary weapon
	if ( primaryWeapon != level.weaponNull )
	{
		primaryWeaponOptions = self CalcWeaponOptions( class_num, 0 );

		/#	println( "^5Loadout " + self.name + " GiveWeapon( " + primaryWeapon.name + " ) -- primary" );	#/

		acvi = self GetAttachmentCosmeticVariantForWeapon( class_num, "primary" );
		self GiveWeapon( primaryWeapon, primaryWeaponOptions, acvi );
		self.primaryLoadoutWeapon = primaryWeapon;
		self.primaryLoadoutAltWeapon = primaryWeapon.altWeapon;
		self giveMaxAmmo( primaryWeapon );
			
		spawnWeapon = primaryWeapon;
		initialWeaponCount++;
	}
	//give hero weapons
	if( isDefined( self.heroWeapons ) )
	{
		heroWeapons = strtok( self.heroWeapons, "," );
		foreach( weaponName in heroWeapons )
		{
			heroWeapon = GetWeapon( weaponName );
			self GiveWeapon( heroWeapon );
			self giveMaxAmmo( heroWeapon );
		}
	}
		
	if ( !self HasMaxPrimaryWeapons() )
	{
		if( !isUsingT7Melee() )
		{
			/#	println( "^5Loadout " + self.name + " GiveWeapon( " + level.weaponBaseMeleeHeld.name + " ) -- level.weaponBaseMeleeHeld 1" );	#/

			self GiveWeapon( level.weaponBaseMeleeHeld, knifeWeaponOptions );
		}

		if ( initialWeaponCount == 0 )
		{
			spawnWeapon = level.weaponBaseMeleeHeld;
		}
	}
	
	if ( !isdefined( self.spawnWeapon ) && isdefined( self.pers["spawnWeapon"] ) )
	{
		self.spawnWeapon = self.pers["spawnWeapon"];
	}
	
	if ( isdefined( self.spawnWeapon ) && DoesWeaponReplaceSpawnWeapon( self.spawnWeapon, spawnWeapon ) && !self.pers["changed_class"] )
	{
		spawnWeapon = self.spawnWeapon;
	}

	changedClass = self.pers["changed_class"];
	roundBased = !util::isOneRound();
	firstRound = util::isFirstRound();

	self.pers["changed_class"] = false;
	self.spawnWeapon = spawnWeapon;
	self.pers["spawnWeapon"] = self.spawnWeapon;
	self setSpawnWeapon( spawnWeapon );
	
	// reset offhand
	self.grenadeTypePrimary = level.weaponNone;
	self.grenadeTypePrimaryCount = 0;
	self.grenadeTypeSecondary = level.weaponNone;
	self.grenadeTypeSecondaryCount = 0;

	primaryOffhand = level.weaponNone;
	primaryOffhandCount = 0;
	secondaryOffhand = level.weaponNone;
	secondaryOffhandCount = 0;
	specialOffhand = level.weaponNone;
	specialOffhandCount = 0;

	// primary offhand start
	if ( GetDvarint( "gadgetEnabled") == 1 || GetDvarint( "equipmentAsGadgets") == 1 )
	{
		primaryOffhand = self GetLoadoutWeapon( class_num, "primaryGadget" );
		primaryOffhandCount = primaryOffhand.startammo;
	}
	else
	{
		primaryOffhandName = self GetLoadoutItemRef( class_num, "primarygrenade" );				

		if ( primaryOffhandName != "" && primaryOffhandName != "weapon_null" )
		{
			primaryOffhand = GetWeapon( primaryOffhand );
			primaryOffhandCount = self GetLoadoutItem( class_num, "primarygrenadecount" );
		}
	}

	if ( isLeagueItemRestricted( primaryOffhand.name ) || !isEquipmentAllowed( primaryOffhand.name ) )
	{
		primaryOffhand = level.weaponNone;
		primaryOffhandCount = 0;
	}

	if ( primaryOffhand == level.weaponNone )
	{
		// fills first offhand slot for the case that no primary offhand is on loadout
		primaryOffhand = level.weapons["frag"];
		primaryOffhandCount = 0;
	}	

	if ( primaryOffhand != level.weaponNull )
	{
		/#	println( "^5Loadout " + self.name + " GiveWeapon( " + primaryOffhand.name + " ) -- primaryOffhand" );	#/

		self GiveWeapon( primaryOffhand );
		
		self SetWeaponAmmoClip( primaryOffhand, primaryOffhandCount );
		self SwitchToOffhand( primaryOffhand );
		self.grenadeTypePrimary = primaryOffhand;
		self.grenadeTypePrimaryCount = primaryOffhandCount;

		self ability_util::gadget_reset( primaryOffhand, changedClass, roundBased, firstRound );
	}
	// primary offhand end

	// secondary offhand start
	if ( GetDvarint( "gadgetEnabled") == 1 || GetDvarint( "equipmentAsGadgets") == 1 )
	{
		secondaryOffhand = self GetLoadoutWeapon( class_num, "secondaryGadget" );
		secondaryOffhandCount = secondaryOffhand.startammo;
	}
	else
	{
		secondaryOffhandName = self GetLoadoutItemRef( class_num, "specialgrenade" );				

		if ( secondaryOffhandName != "" && secondaryOffhandName != "weapon_null" )
		{
			secondaryOffhand = GetWeapon( secondaryOffhand );
			secondaryOffhandCount = self GetLoadoutItem( class_num, "specialgrenadecount" );
		}
	}

	if ( isLeagueItemRestricted( secondaryOffhand.name ) || !isEquipmentAllowed( secondaryOffhand.name ) )
	{
		secondaryOffhand = level.weaponNone;
		secondaryOffhandCount = 0;
	}

	if ( secondaryOffhand == level.weaponNone )
	{
		// fills first offhand slot for the case that no secondary offhand is on loadout
		secondaryOffhand = level.weapons["flash"];
		secondaryOffhandCount = 0;
	}	

	if ( secondaryOffhand != level.weaponNull )
	{
		/#	println( "^5Loadout " + self.name + " GiveWeapon( " + secondaryOffhand.name + " ) -- secondaryOffhand" );	#/

		self GiveWeapon( secondaryOffhand );
		
		self SetWeaponAmmoClip( secondaryOffhand, secondaryOffhandCount );
		self SwitchToOffhand( secondaryOffhand );
		self.grenadeTypeSecondary = secondaryOffhand;
		self.grenadeTypeSecondaryCount = secondaryOffhandCount;

		self ability_util::gadget_reset( secondaryOffhand, changedClass, roundBased, firstRound );
	}
	// secondary offhand end
	
	// special offhand start
	if ( GetDvarint( "gadgetEnabled") == 1 || GetDvarint( "equipmentAsGadgets") == 1 )
	{
		specialOffhand = self GetLoadoutWeapon( class_num, "specialGadget" );
		specialOffhandCount = specialOffhand.startammo;
	}

	if ( isLeagueItemRestricted( specialOffhand.name ) || !isEquipmentAllowed( specialOffhand.name ) )
	{
		specialOffhand = level.weaponNone;
		specialOffhandCount = 0;
	}

	if ( specialOffhand == level.weaponNone )
	{
		specialOffhand = level.weaponNull;
		specialOffhandCount = 0;
	}

	if ( specialOffhand != level.weaponNull )
	{
		/#	println( "^5Loadout " + self.name + " GiveWeapon( " + specialOffhand.name + " ) -- specialOffhand" );	#/

		self GiveWeapon( specialOffhand );
		
		self SetWeaponAmmoClip( specialOffhand, specialOffhandCount );
		self SwitchToOffhand( specialOffhand );
		self.grenadeTypeSpecial = specialOffhand;
		self.grenadeTypeSpecialCount = specialOffhandCount;

		self ability_util::gadget_reset( specialOffhand, changedClass, roundBased, firstRound );
	}
	// special offhand end

	// cybercom start
	if ( ( level.gametype === "coop" ) )
	{
		cybercom::giveCyberComLoadout( class_num, class_num_for_global_weapons, !( isdefined( dontRestoreCybercom ) && dontRestoreCybercom ) );
	}
	// cybercom end

	self bbClassChoice( class_num, primaryWeapon, sidearm );

	for( i = 0; i < 3; i++ )
	{
		if( level.loadoutKillStreaksEnabled && isdefined( self.killstreak[i] ) && isdefined( level.killstreakindices[self.killstreak[i]] ) )
		{
			killstreaks[i] = level.killstreakindices[self.killstreak[i]];
		}
		else
		{
			killstreaks[i] = 0;
		}
	}
	self RecordLoadoutPerksAndKillstreaks( primaryWeapon, sidearm, self.grenadeTypePrimary, self.grenadeTypeSecondary, killstreaks[0], killstreaks[1], killstreaks[2] );

	self teams::set_player_model( team, primaryWeapon );
	
	self initStaticWeaponsTime();
	
	self thread loadout::initWeaponAttachments( spawnWeapon );
	
	self SetPlayerRenderOptions( playerRenderOptions );	

	if( isdefined( self.movementSpeedModifier ) )
	{
		self setMoveSpeedScale( self.movementSpeedModifier * self getMoveSpeedScale() );
	}

	if ( isdefined( level.giveCustomLoadout ) )
	{
		spawnWeapon = self [[level.giveCustomLoadout]]();
		if ( isdefined( spawnWeapon ) )
			self thread loadout::initWeaponAttachments( spawnWeapon );
	}
	
	// cac specialties that require loop threads
	self cac_selector();
	
	// tagTMR<NOTE>: force first raise anim on initial spawn of match
	if ( !isdefined( self.firstSpawn ) )
	{
		if ( isdefined( spawnWeapon ) )
			self InitialWeaponRaise( spawnWeapon );
		else
			self InitialWeaponRaise( primaryWeapon );
	}	
	else
	{
		// ... and eliminate first raise anim for all other spawns
		self SetEverHadWeaponAll( true );
	}
	
	
	self.firstSpawn = false;
	self.switchedTeamsResetGadgets = false;

	if (system::is_system_running("cybercom"))
	{
		self flagsys::wait_till( "cybercom_init" );
	}
	
	self flagsys::set( "loadout_given" );
	
	callback::callback( #"on_loadout" );

	pixendevent(); // "giveLoadout"
}

// sets the amount of ammo in the gun.
// if the clip maxs out, the rest goes into the stock.
function setWeaponAmmoOverall( weapon, amount )
{
	if ( weapon.isClipOnly )
	{
		self setWeaponAmmoClip( weapon, amount );
	}
	else
	{
		self setWeaponAmmoClip( weapon, amount );
		diff = amount - self getWeaponAmmoClip( weapon );
		assert( diff >= 0 );
		self setWeaponAmmoStock( weapon, diff );
	}
}

function onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !level.oldschool )
		{
		if ( !isdefined( player.pers["class"] ) )
		{
			player.pers["class"] = "";
	}
			player.curClass = player.pers["class"];
			player.lastClass = "";
		}
		player.detectExplosives = false;
		player.bombSquadIcons = [];
		player.bombSquadIds = [];	
		player.reviveIcons = [];
		player.reviveIds = [];
	}
}


function fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}


function setClass( newClass )
{
	self.curClass = newClass;
}

// ============================================================================================
// =======																				=======
// =======						 Create a Class Specialties 							=======
// =======																				=======
// ============================================================================================

function initPerkDvars()
{
	level.cac_armorpiercing_data = GetDvarInt( "perk_armorpiercing", 40 ) / 100;// increased bullet damage by this %
	level.cac_bulletdamage_data = GetDvarInt( "perk_bulletDamage", 35 );		// increased bullet damage by this %
	level.cac_fireproof_data = GetDvarInt( "perk_fireproof", 95 );				// reduced flame damage by this %
	level.cac_armorvest_data = GetDvarInt( "perk_armorVest", 80 );				// multipy damage by this %	
	level.cac_flakjacket_data = GetDvarInt( "perk_flakJacket", 35 );			// explosive damage is this % of original
	level.cac_flakjacket_hardcore_data = GetDvarInt( "perk_flakJacket_hardcore", 9 );	// explosive damage is this % of original for hardcore
}

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
function cac_selector()
{
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
	
function register_perks()
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
			
		/#	println( "^5Loadout " + self.name + " setPerk( " + perk + " ) -- perk" );	#/

		self setPerk( perk );
	}
	
	/#
	dev::giveExtraPerks();
	#/
}

function cac_modified_vehicle_damage( victim, attacker, damage, meansofdeath, weapon, inflictor )
{
	// skip conditions
	if ( !isdefined( victim) || !isdefined( attacker ) || !isplayer( attacker ) )
		return damage;
	if ( !isdefined( damage ) || !isdefined( meansofdeath ) || !isdefined( weapon ) )
		return damage;

	old_damage = damage;
	final_damage = damage;

	// Perk version
	
	if ( attacker HasPerk( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) )
	{
		final_damage = damage*(100+level.cac_bulletdamage_data)/100;
		/#
		if ( GetDvarint( "scr_perkdebug") )
		println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to vehicle" );
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

function cac_modified_damage( victim, attacker, damage, mod, weapon, inflictor, hitloc )
{
	assert( isdefined( victim ) );
	assert( isdefined( attacker ) );
	assert( IsPlayer( victim ) );






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
	
	if ( isPlayer(attacker) && attacker HasPerk( "specialty_bulletdamage" ) && isPrimaryDamage( mod ) )
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
	else if ( victim HasPerk( "specialty_flakjacket" ) && isExplosiveDamage( mod ) && !weapon.ignoresFlakJacket && !victim grenadeStuck( inflictor ) )
	{
		// put these back in to make FlakJacket a perk again (for easy tuning of system when not body type specfic)
		cac_data = ( level.hardcoreMode ? level.cac_flakjacket_hardcore_data : level.cac_flakjacket_data );

		if ( level.teambased && attacker.team != victim.team )
		{
			victim thread challenges::flakjacketProtected( weapon, attacker );
		}
		else if ( attacker != victim )
		{
			victim thread challenges::flakjacketProtected( weapon, attacker );
		}

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
	victim.cac_debug_weapon = tolower( weapon.name );
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
function isExplosiveDamage( meansofdeath )
{
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

function hasTacticalMask( player )
{
	return ( player HasPerk( "specialty_stunprotection" ) || player HasPerk( "specialty_flashprotection" ) || player HasPerk( "specialty_proximityprotection" ) );
}

// if primary weapon damage
function isPrimaryDamage( meansofdeath )
{
	return( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" );
}

function isFireDamage( weapon, meansofdeath )
{
	if ( weapon.doesFireDamage && (meansofdeath == "MOD_BURNED" || meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_GRENADE_SPLASH") )
		return true;

	return false;
}

function isHeadDamage( hitloc )
{
	return ( hitloc == "helmet" || hitloc == "head" || hitloc == "neck" );
}

function grenadeStuck( inflictor )
{
	return ( isdefined( inflictor ) && isdefined( inflictor.stucktoplayer ) && inflictor.stucktoplayer == self );
}

