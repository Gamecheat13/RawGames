#include common_scripts\utility;
// check if below includes are removable
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	precacheString(&"CLASS_CLOSEQUARTERS");
	precacheString(&"CLASS_ASSAULT");
	precacheString(&"CLASS_SNIPER");
	precacheString(&"CLASS_ENGINEER");
	precacheString(&"CLASS_ANTIARMOR");
	precacheString(&"CLASS_SUPPORT");
	precacheString(&"CLASS_NEWPROF");
	precacheString(&"CLASS_PROFICIENCY_MARKSMAN");
	precacheString(&"CLASS_PROFICIENCY_SHARPSHOOTER");
	precacheString(&"CLASS_PROFICIENCY_EXPERT");
	precacheString(&"CLASS_CUSTOM1");
	precacheString(&"CLASS_CUSTOM2");
	precacheString(&"CLASS_CUSTOM3");

	level.classList = [];
	level.classList[level.classList.size] = "CLASS_CLOSEQUARTERS";
	level.classList[level.classList.size] = "CLASS_ASSAULT";
	level.classList[level.classList.size] = "CLASS_SNIPER";
	level.classList[level.classList.size] = "CLASS_ENGINEER";
	level.classList[level.classList.size] = "CLASS_ANTIARMOR";
	level.classList[level.classList.size] = "CLASS_SUPPORT";
	
	// custom classes added to the list
	level.classList[level.classList.size] = "CLASS_CUSTOM1";
	level.classList[level.classList.size] = "CLASS_CUSTOM2";
	level.classList[level.classList.size] = "CLASS_CUSTOM3";

	level.classes["CLASS_CLOSEQUARTERS"] = &"CLASS_CLOSEQUARTERS";
	level.classes["CLASS_ASSAULT"] = &"CLASS_ASSAULT";
	level.classes["CLASS_SNIPER"] = &"CLASS_SNIPER";
	level.classes["CLASS_ENGINEER"] = &"CLASS_ENGINEER";
	level.classes["CLASS_ANTIARMOR"] = &"CLASS_ANTIARMOR";
	level.classes["CLASS_SUPPORT"] = &"CLASS_SUPPORT";
	
	level.classes["CLASS_CUSTOM1"] = &"CLASS_CUSTOM1";
	level.classes["CLASS_CUSTOM2"] = &"CLASS_CUSTOM2";
	level.classes["CLASS_CUSTOM3"] = &"CLASS_CUSTOM3";
	
	level.classMap["demolition_mp"] = "CLASS_CLOSEQUARTERS";		
	level.classMap["stealth_mp"] = "CLASS_ASSAULT";
	level.classMap["recon_mp"] = "CLASS_SNIPER";
	level.classMap["survivalist_mp"] = "CLASS_ENGINEER";
	level.classMap["antiarmor_mp"] = "CLASS_ANTIARMOR";
	level.classMap["warfighter_mp"] = "CLASS_SUPPORT";
	
	level.classMap["custom1"] = "CLASS_CUSTOM1";
	level.classMap["custom2"] = "CLASS_CUSTOM2";
	level.classMap["custom3"] = "CLASS_CUSTOM3";
	
	// default classes' specialties
	level.default_class[level.classMap["demolition_mp"]] = [];
	level.default_class[level.classMap["stealth_mp"]] = [];
	level.default_class[level.classMap["recon_mp"]] = [];
	level.default_class[level.classMap["survivalist_mp"]] = [];
	level.default_class[level.classMap["warfighter_mp"]] = [];

	level.default_class[level.classMap["demolition_mp"]][0] = "specialty_armorvest";
	level.default_class[level.classMap["demolition_mp"]][1] = "specialty_explosivedamage";
	
	level.default_class[level.classMap["stealth_mp"]][0] = "specialty_gpsjammer";
	level.default_class[level.classMap["stealth_mp"]][1] = "specialty_bulletaccuracy";
	level.default_class[level.classMap["stealth_mp"]][2] = "specialty_quieter";
	
	level.default_class[level.classMap["recon_mp"]][0] = "specialty_fastreload";
	level.default_class[level.classMap["recon_mp"]][1] = "specialty_longersprint";
	
	level.default_class[level.classMap["survivalist_mp"]][0] = "specialty_bulletpenetration";
	level.default_class[level.classMap["survivalist_mp"]][1] = "specialty_pistoldeath";
	
	level.default_class[level.classMap["warfighter_mp"]][0] = "specialty_bulletdamage";
	level.default_class[level.classMap["warfighter_mp"]][1] = "specialty_grenadepulldeath";
	
	level.proficiencies["PROFICIENCY_MARKSMAN"] = &"CLASS_PROFICIENCY_MARKSMAN";
	level.proficiencies["PROFICIENCY_SHARPSHOOTER"] = &"CLASS_PROFICIENCY_SHARPSHOOTER";
	level.proficiencies["PROFICIENCY_EXPERT"] = &"CLASS_PROFICIENCY_EXPERT";
	
	
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

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowc4" ) )
		level.weapons["c4"] = "c4_mp";
	else	
		level.weapons["c4"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowclaymores" ) )
		level.weapons["claymore"] = "claymore_mp";
	else	
		level.weapons["claymore"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowrpgs" ) )
	{
		level.weapons["rpg"] = "rpg_mp";
		level.weapons["at4"] = "at4_mp";
	}
	else	
	{
		level.weapons["rpg"] = "";
		level.weapons["at4"] = "";
	}
	
	
	level.classWeapons["allies"]["CLASS_CLOSEQUARTERS"][0] = "winchester1200_mp";
	level.classWeapons["allies"]["CLASS_ASSAULT"][0] = "m14_scoped_mp";
	level.classWeapons["allies"]["CLASS_SNIPER"][0] = "mp5_mp";
	level.classWeapons["allies"]["CLASS_ENGINEER"][0] = "saw_mp";
	level.classWeapons["allies"]["CLASS_ANTIARMOR"][0] = "m4_mp";
	level.classWeapons["allies"]["CLASS_SUPPORT"][0] = "m16_m203_mp";
	
	level.classWeapons["axis"]["CLASS_CLOSEQUARTERS"][0] = "winchester1200_mp";
	level.classWeapons["axis"]["CLASS_ASSAULT"][0] = "m14_scoped_mp";
	level.classWeapons["axis"]["CLASS_SNIPER"][0] = "mp5_mp";
	level.classWeapons["axis"]["CLASS_ENGINEER"][0] = "saw_mp";
	level.classWeapons["axis"]["CLASS_ANTIARMOR"][0] = "m4_mp";
	level.classWeapons["axis"]["CLASS_SUPPORT"][0] = "m16_m203_mp";

	level.classSidearm["allies"]["CLASS_CLOSEQUARTERS"]	= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ASSAULT"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_SNIPER"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ENGINEER"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ANTIARMOR"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_SUPPORT"]		= "beretta_mp";
	
	level.classSidearm["axis"]["CLASS_CLOSEQUARTERS"]	= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ASSAULT"]			= "beretta_mp";
	level.classSidearm["axis"]["CLASS_SNIPER"]			= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ENGINEER"]		= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ANTIARMOR"]		= "beretta_mp";
	level.classSidearm["axis"]["CLASS_SUPPORT"]			= "beretta_mp";
	
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["secondary"]	["type"]	= level.weapons["flash"];
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_ASSAULT"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ASSAULT"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ASSAULT"]		["secondary"]	["type"]	= level.weapons["smoke"];
	level.classGrenades["CLASS_ASSAULT"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_SNIPER"]			["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_SNIPER"]			["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_SNIPER"]			["secondary"]	["type"]	= level.weapons["flash"];
	level.classGrenades["CLASS_SNIPER"]			["secondary"]	["count"]	= 3;
	level.classGrenades["CLASS_ENGINEER"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ENGINEER"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ENGINEER"]		["secondary"]	["type"]	= level.weapons["concussion"];
	level.classGrenades["CLASS_ENGINEER"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_ANTIARMOR"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ANTIARMOR"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ANTIARMOR"]		["secondary"]	["type"]	= level.weapons["flash"];
	level.classGrenades["CLASS_ANTIARMOR"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_SUPPORT"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_SUPPORT"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_SUPPORT"]		["secondary"]	["type"]	= level.weapons["concussion"];
	level.classGrenades["CLASS_SUPPORT"]		["secondary"]	["count"]	= 1;
	
	// TODO: allow more than 1 C4 when it's harder to throw & detonate immediately?
	level.classItem["allies"]	["CLASS_CLOSEQUARTERS"]["type"]		= level.weapons["c4"];
	level.classItem["allies"]	["CLASS_CLOSEQUARTERS"]["count"]	= 2;
	level.classItem["allies"]	["CLASS_ASSAULT"]["type"]			= "";
	level.classItem["allies"]	["CLASS_ASSAULT"]["count"]			= 0;
	level.classItem["allies"]	["CLASS_SNIPER"]["type"]			= "";
	level.classItem["allies"]	["CLASS_SNIPER"]["count"]			= 0;
	level.classItem["allies"]	["CLASS_ENGINEER"]["type"]			= level.weapons["rpg"];
	level.classItem["allies"]	["CLASS_ENGINEER"]["count"]			= 2;
	//level.classItem["allies"]	["CLASS_ANTIARMOR"]["type"]			= level.weapons["at4"];
	//level.classItem["allies"]	["CLASS_ANTIARMOR"]["count"]		= 1;
	level.classItem["allies"]	["CLASS_SUPPORT"]["type"]			= "";
	level.classItem["allies"]	["CLASS_SUPPORT"]["count"]			= 0;
	
	level.classItem["axis"]		["CLASS_CLOSEQUARTERS"]["type"]		= level.weapons["c4"];
	level.classItem["axis"]		["CLASS_CLOSEQUARTERS"]["count"]	= 2;
	level.classItem["axis"]		["CLASS_ASSAULT"]["type"]			= "";
	level.classItem["axis"]		["CLASS_ASSAULT"]["count"]			= 0;
	level.classItem["axis"]		["CLASS_SNIPER"]["type"]			= "";
	level.classItem["axis"]		["CLASS_SNIPER"]["count"]			= 0;
	level.classItem["axis"]		["CLASS_ENGINEER"]["type"]			= level.weapons["rpg"];
	level.classItem["axis"]		["CLASS_ENGINEER"]["count"]			= 2;
	//level.classItem["axis"]		["CLASS_ANTIARMOR"]["type"]			= level.weapons["at4"];
	//level.classItem["axis"]		["CLASS_ANTIARMOR"]["count"]		= 1;
	level.classItem["axis"]		["CLASS_SUPPORT"]["type"]			= "";
	level.classItem["axis"]		["CLASS_SUPPORT"]["count"]			= 0;
	
	level.initc4ammo = 2; // initial ammo for c4 and claymore
	level.initclaymoreammo = 2;
	
	// initializes create a class settings
	cac_init();
	
	// generating weapon type arrays which classifies the weapon as primary (back stow), pistol, or inventory (side pack stow)
	// using mp/statstable.csv's weapon grouping data ( numbering 0 - 149 )
	level.primary_weapon_array = [];
	level.side_arm_array = [];
	level.grenade_array = [];
	level.inventory_array = [];
	max_weapon_num = 149;
	for( i = 0; i < max_weapon_num; i++ )
	{
		//statstablelookup( get_col, with_col, with_data )
		weapon_type = statstablelookup( level.cac_cgroup, level.cac_numbering, i );
		weapon = statstablelookup( level.cac_creference, level.cac_numbering, i );
		if( !isdefined( weapon_type ) || weapon_type == "" )
			continue;
		if( !isdefined( weapon ) || weapon == "" )
			continue;
		
		weapon = weapon+"_mp";
			
		if( isSubstr( "weapon_smg weapon_assault weapon_projectile weapon_sniper weapon_shotgun weapon_lmg", weapon_type ) )
			level.primary_weapon_array[weapon] = 1;	
		else if( weapon_type == "weapon_pistol" )
			level.side_arm_array[weapon] = 1;
		else if( weapon_type == "weapon_grenade" )
			level.grenade_array[weapon] = 1;
		else if( weapon_type == "weapon_explosive" )
			level.inventory_array[weapon] = 1;
		else
			assertex( false, "Weapon group info is missing from statsTable for: " + weapon_type );
	}
	
	level thread onPlayerConnecting();
}

// create a class init
cac_init()
{
	// max create a class "class" allowed
	level.cac_size = 3;
	
	// init cac data table column definitions
	level.cac_numbering = 0;	// unique unsigned int - general numbering of all items
	level.cac_cstat = 1;		// unique unsigned int - stat number assigned
	level.cac_cgroup = 2;		// string - item group name, "primary" "secondary" "inventory" "specialty" "grenades" "special grenades" "stow back" "stow side" "attachment"
	level.cac_cname = 3;		// string - name of the item, "Extreme Conditioning"
	level.cac_creference = 4;	// string - reference string of the item, "m203" "m16" "bulletdamage" "c4"
	level.cac_ccount = 5;		// signed int - item count, if exists, -1 = has no count
	level.cac_cimage = 6;		// string - item's image file name
	level.cac_cdesc = 7;		// long string - item's description
	level.cac_cstring = 8;		// long string - item's other string data, reserved
	level.cac_cint = 9;			// signed int - item's other number data, used for attachment number representations
}

getClassChoice( response )
{
	tokens = strtok( response, "," );
	return ( level.classMap[tokens[0]] );
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int(tokens[1]);
	else
		return 0;
}

// ============================================================================
// obtains custom class setup from stat values
cac_getdata()
{
	/* custom class stat allocation order, example of custom class slot 1
	201  weapon_primary    
	202  weapon_primary attachment    
	203  weapon_secondary    
	204  weapon_secondary attachment    
	205  weapon_specialty1    
	206  weapon_specialty2    
	207  weapon_specialty3  
	208  weapon_special_grenade_type
	*/
	
	self.cac_size = 0; // lol ...
	for( k = 0; k < level.cac_size; k ++ )
	{
		if ( self getstat ( k*10+200 ) > 0 )
			self.cac_size++;
	}

	for( i = 0; i < self.cac_size; i ++ )
	{
		assertex( self getstat ( i*10+200 ) == 1, "This cac class is undefined, but cac size suggests it is!" );
			
		// do not change the allocation and assignment of 0-299 stat bytes, or data will be misinterpreted by this function!
		primary_num = self getstat ( 200+(i*10)+1 );				// returns weapon number (also the unlock stat number from data table)
		primary_attachment_flag = self getstat ( 200+(i*10)+2 ); 	// returns attachment number (from data table)
		secondary_num = self getstat ( 200+(i*10)+3 );				// returns weapon number (also the unlock stat number from data table)
		secondary_attachment_flag = self getstat ( 200+(i*10)+4 ); 	// returns attachment number (from data table)
		specialty1 = self getstat ( 200+(i*10)+5 ); 				// returns specialty number (from data table)
		specialty2 = self getstat ( 200+(i*10)+6 ); 				// returns specialty number (from data table)
		specialty3 = self getstat ( 200+(i*10)+7 ); 				// returns specialty number (from data table)
		special_grenade = self getstat ( 200+(i*10)+8 );				// returns special grenade type as single special grenade items (from data table)
		
		// apply attachment to primary weapon, getting weapon reference strings
		if( primary_attachment_flag != 0 && statstablelookup( level.cac_creference, level.cac_cint, primary_attachment_flag ) != "" )
			self.custom_class[i]["primary"] = statstablelookup( level.cac_creference, level.cac_cstat, primary_num ) + "_" + statstablelookup( level.cac_creference, level.cac_cint, primary_attachment_flag ) + "_mp";
		else
			self.custom_class[i]["primary"] = statstablelookup( level.cac_creference, level.cac_cstat, primary_num ) + "_mp";
		
		// apply attachment to secondary weapon, getting weapon reference strings
		if( secondary_attachment_flag != 0 && statstablelookup( level.cac_creference, level.cac_cint, secondary_attachment_flag ) != "" )
			self.custom_class[i]["secondary"] = statstablelookup( level.cac_creference, level.cac_cstat, secondary_num ) + "_" + statstablelookup( level.cac_creference, level.cac_cint, secondary_attachment_flag ) + "_mp";
		else
			self.custom_class[i]["secondary"] = statstablelookup( level.cac_creference, level.cac_cstat, secondary_num ) + "_mp";	
		
		// obtaining specialties, getting specialty reference strings
		self.custom_class[i]["specialty1"] = statstablelookup( level.cac_creference, level.cac_cstat, specialty1 );
		self.custom_class[i]["specialty1_count"] = int( statstablelookup( level.cac_ccount, level.cac_cstat, specialty1 ) );
		self.custom_class[i]["specialty1_group"] = statstablelookup( level.cac_cgroup, level.cac_cstat, specialty1 );
		
		self.custom_class[i]["specialty2"] = statstablelookup( level.cac_creference, level.cac_cstat, specialty2 );
		self.custom_class[i]["specialty2_count"] = int( statstablelookup( level.cac_ccount, level.cac_cstat, specialty2 ) );
		self.custom_class[i]["specialty2_group"] = statstablelookup( level.cac_cgroup, level.cac_cstat, specialty2 );
		
		self.custom_class[i]["specialty3"] = statstablelookup( level.cac_creference, level.cac_cstat, specialty3 );
		self.custom_class[i]["specialty3_count"] = int( statstablelookup( level.cac_ccount, level.cac_cstat, specialty3 ) );
		self.custom_class[i]["specialty3_group"] = statstablelookup( level.cac_cgroup, level.cac_cstat, specialty3 );
		
		// builds the full special grenade reference string
		self.custom_class[i]["special_grenade"] = statstablelookup( level.cac_creference, level.cac_cstat, special_grenade ) + "_mp";
		self.custom_class[i]["special_grenade_count"] = int( statstablelookup( level.cac_ccount, level.cac_cstat, special_grenade ) );
		
		// debug
		println( "\n ========== CUSTOM CLASS DEBUG INFO ========== \n" );
		println( "Primary: "+self.custom_class[i]["primary"] );
		println( "Secondary: "+self.custom_class[i]["secondary"] );
		println( "Specialty1: "+self.custom_class[i]["specialty1"]+" - Group: "+self.custom_class[i]["specialty1_group"]+" - Count: "+self.custom_class[i]["specialty1_count"] );
		println( "Specialty2: "+self.custom_class[i]["specialty2"]+" - Group: "+self.custom_class[i]["specialty2_group"]+" - Count: "+self.custom_class[i]["specialty2_count"] );
		println( "Specialty3: "+self.custom_class[i]["specialty3"]+" - Group: "+self.custom_class[i]["specialty3_group"]+" - Count: "+self.custom_class[i]["specialty3_count"] );
		println( "Special Grenade: "+self.custom_class[i]["special_grenade"]+" - Count: "+self.custom_class[i]["special_grenade_count"] );
	}
}

// distributes the specialties into the corrent slots; inventory, grenades, special grenades, generic specialties
get_specialtydata( class_num, specialty )
{
	cac_reference = self.custom_class[class_num][specialty];
	cac_group = self.custom_class[class_num][specialty+"_group"];
	cac_count = self.custom_class[class_num][specialty+"_count"];
		
	assertex( isdefined( cac_group ), "Missing "+specialty+"'s group name" );
	
	// grenade classification and distribution ==================
	if( specialty == "specialty1" )
	{
		if( isSubstr( cac_group, "grenade" ) )
		{
			// if user selected 3 frags, then give 3 count, else always give 1
			if( cac_reference == "specialty_fraggrenade" )
			{
				self.custom_class[class_num]["grenades"] = level.weapons["frag"];
				self.custom_class[class_num]["grenades_count"] = cac_count;
			}
			else
			{
				self.custom_class[class_num]["grenades"] = level.weapons["frag"];
				self.custom_class[class_num]["grenades_count"] = 1;
			}
			
			// if user selected 3 special grenades, then give 3 count to the selected special grenade type, else always give 1
			assertex( isdefined( self.custom_class[class_num]["special_grenade"] ) && isdefined( self.custom_class[class_num]["special_grenade_count"] ), "Special grenade missing from custom class loadout" );
			if( cac_reference == "specialty_specialgrenade" )
			{
				self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				self.custom_class[class_num]["specialgrenades_count"] = cac_count;
			}
			else
			{
				self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				self.custom_class[class_num]["specialgrenades_count"] = 1;
			}
			return;
		}
		else
		{
			assertex( isdefined( self.custom_class[class_num]["special_grenade"] ), "Special grenade missing from custom class loadout" );
			self.custom_class[class_num]["grenades"] = level.weapons["frag"];
			self.custom_class[class_num]["grenades_count"] = 1;
			self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
			self.custom_class[class_num]["specialgrenades_count"] = 1;
		}
	}
			
	// if user selected inventory items
	if( cac_group == "inventory" )
	{
		// inventory distribution to action slot 3 - unique per class
		assertex( isdefined( cac_count ) && isdefined( cac_reference ), "Missing "+specialty+"'s reference or count data" );
		self.custom_class[class_num]["inventory"] = cac_reference;		// loads inventory into action slot 3
		self.custom_class[class_num]["inventory_count"] = cac_count;	// loads ammo count
	}
	else if( cac_group == "specialty" )
	{
		// building player's specialty, variable size array with size 3 max
		if( self.custom_class[class_num][specialty] != "" )
			self.specialty[self.specialty.size] = self.custom_class[class_num][specialty];
	}
}

// interface function for code table lookup function
statstablelookup( get_col, with_col, with_data )
{
	// with_data = the data from the table
	// with_col = look in this column for the data
	// get_col = once data found, return the value of get_col in the same row	
	return_value = tablelookup( "mp/statstable.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;
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

giveLoadout( team, class )
{
	self takeAllWeapons();
	
	/*
	if ( level.splitscreen )
		primaryIndex = 0;
	else
		primaryIndex = self.pers["primary"];
	*/
	
	primaryIndex = 0;
	
	// initialize specialty array
	self.specialty = [];
	
	primaryWeapon = undefined;
	
	// ============= custom class selected ==============
	if( isSubstr( class, "CLASS_CUSTOM" ) )
	{	
		// gets custom class data from stat bytes
		self cac_getdata();
	
		// obtains the custom class number
		class_token = strtok( class, "CUSTOM" );
		class_num = int( class_token[1] );
		
		assertex( isdefined( self.custom_class[class_num]["primary"] ), "Custom class "+class_num+": primary weapon setting missing" );
		assertex( isdefined( self.custom_class[class_num]["secondary"] ), "Custom class "+class_num+": secondary weapon setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty1"] ), "Custom class "+class_num+": specialty1 setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty2"] ), "Custom class "+class_num+": specialty2 setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty3"] ), "Custom class "+class_num+": specialty3 setting missing" );
		
		// clear of specialty slots, repopulate the current selected class' setup
		self reset_specialty_slots( class_num );
		self get_specialtydata( class_num, "specialty1" );
		self get_specialtydata( class_num, "specialty2" );
		self get_specialtydata( class_num, "specialty3" );
		// at this stage, the specialties are loaded into the correct weapon slots, and special slots
		
		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			weapon = self.pers["weapon"];
		else
			weapon = self.custom_class[class_num]["primary"];
		
		sidearm = self.custom_class[class_num]["secondary"];
		
		// give primary weapon
		primaryWeapon = weapon;
		
		self GiveWeapon( weapon );
		if( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( weapon );
		else
			self givestartAmmo( weapon );
		self setSpawnWeapon( weapon );
		
		// give secondary weapon
		self GiveWeapon( sidearm );
		self giveMaxAmmo( sidearm );
	
		self SetActionSlot( 1, "nightvision" );
		self SetActionSlot( 2, "altMode" );

		secondaryWeapon = self.custom_class[class_num]["inventory"];
		if ( secondaryWeapon != "" )
		{
			self GiveWeapon( secondaryWeapon );
			
			self setWeaponAmmoOverall( secondaryWeapon, self.custom_class[class_num]["inventory_count"] );
			
			self SetActionSlot( 3, "weapon", secondaryWeapon );
			self SetActionSlot( 4, "" );
		}
		else
		{
			self SetActionSlot( 3, "" );
			self SetActionSlot( 4, "" );
		}
		
		// give frag for all no matter what
		grenadeTypePrimary = self.custom_class[class_num]["grenades"]; 
		if ( grenadeTypePrimary != "" )
		{
			grenadeCount = self.custom_class[class_num]["grenades_count"]; 
	
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
		}
		
		// give special grenade
		grenadeTypeSecondary = self.custom_class[class_num]["specialgrenades"]; 
		if ( grenadeTypeSecondary != "" )
		{
			grenadeCount = self.custom_class[class_num]["specialgrenades_count"]; 
	
			if ( grenadeTypeSecondary == level.weapons["flash"])
				self setOffhandSecondaryClass("flash");
			else
				self setOffhandSecondaryClass("smoke");
			
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
		}
	}
	else
	{	
		// ============= selected one of the default classes ==============
				
		// load the selected default class's specialties
		assertex( isdefined(self.pers["class"]), "Player during spawn and loadout got no class!" );
		selected_class = self.pers["class"];
		specialty_size = level.default_class[selected_class].size;
		
		for( i = 0; i < specialty_size; i++ )
		{
			if( isdefined( level.default_class[selected_class][i] ) && level.default_class[selected_class][i] != "" )
				self.specialty[self.specialty.size] = level.default_class[selected_class][i];
		}
		assertex( isdefined( self.specialty ) && self.specialty.size > 0, "Default class: " + self.pers["class"] + " is missing specialties " );
		
		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			weapon = self.pers["weapon"];
		else
			weapon = level.classWeapons[team][class][primaryIndex];
		
		sidearm = level.classSidearm[team][class];
		
		// give primary weapon
		primaryWeapon = weapon;

		self GiveWeapon( weapon );
		if( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( weapon );
		else
			self givestartAmmo( weapon );
		self setSpawnWeapon( weapon );
		
		// give secondary weapon
		self GiveWeapon( sidearm );
		self giveMaxAmmo( sidearm );
	
		self SetActionSlot( 1, "nightvision" );
		self SetActionSlot( 2, "altMode" );
	
		secondaryWeapon = level.classItem[team][class]["type"];	
		if ( secondaryWeapon != "" )
		{
			self GiveWeapon( secondaryWeapon );
			
			self setWeaponAmmoOverall( secondaryWeapon, level.classItem[team][class]["count"] );
			
			self SetActionSlot( 3, "weapon", secondaryWeapon );
			self SetActionSlot( 4, "" );
		}
		else
		{
			self SetActionSlot( 3, "" );
			self SetActionSlot( 4, "" );
		}
		
		grenadeTypePrimary = level.classGrenades[class]["primary"]["type"];
		if ( grenadeTypePrimary != "" )
		{
			grenadeCount = level.classGrenades[class]["primary"]["count"];
	
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
		}
		
		grenadeTypeSecondary = level.classGrenades[class]["secondary"]["type"];
		if ( grenadeTypeSecondary != "" )
		{
			grenadeCount = level.classGrenades[class]["secondary"]["count"];
	
			if ( grenadeTypeSecondary == level.weapons["flash"])
				self setOffhandSecondaryClass("flash");
			else
				self setOffhandSecondaryClass("smoke");
			
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
		}
	}
	
	switch ( weaponClass( primaryWeapon ) )
	{
		case "rifle":
			self setMoveSpeedScale( 0.9 );
			break;
		case "pistol":
			self setMoveSpeedScale( 1.0 );
			break;
		case "mg":
			self setMoveSpeedScale( 0.8 );
			break;
		case "smg":
			self setMoveSpeedScale( 1.0 );
			break;
		case "spread":
			self setMoveSpeedScale( 1.0 );
			break;
		default:
			self setMoveSpeedScale( 1.0 );
			break;
	}
	
	// initializes cac specialties that require loop threads
	self cac_selector();
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

replenishLoadout() // used by ammo hardpoint.
{
	team = self.pers["team"];
	class = self getClass();

    weaponsList = self GetWeaponsList();
    for( idx = 0; idx < weaponsList.size; idx++ )
    {
		weapon = weaponsList[idx];

		self giveMaxAmmo( weapon );
		self SetWeaponAmmoClip( weapon, 9999 );

		if ( weapon == "claymore_mp" || weapon == "claymore_detonator_mp" )
			self setWeaponAmmoStock( weapon, level.initclaymoreammo );
    }
	
	if ( self getAmmoCount( level.classGrenades[class]["primary"]["type"] ) < level.classGrenades[class]["primary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["primary"]["type"], level.classGrenades[class]["primary"]["count"] );

	if ( self getAmmoCount( level.classGrenades[class]["secondary"]["type"] ) < level.classGrenades[class]["secondary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["secondary"]["type"], level.classGrenades[class]["secondary"]["count"] );	
}

onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !isDefined( player.pers["class"] ) )
		{
			player initClassXP(); //temp
			player.pers["class"] = "";
			player.pers["proficiency"] = 0;
		}

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}


onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self thread removeClassHUD();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeClassHUD();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if(!isdefined(self.hud_class))
		{
		    self.hud_class = newClientHudElem(self);
		    self.hud_class.horzAlign = "right";
		    self.hud_class.vertAlign = "top";
			self.hud_class.alignX = "right";
 			self.hud_class.x = -16;
			self.hud_class.y = 44;
		    self.hud_class.font = "default";
		    self.hud_class.fontscale = 2;
		    self.hud_class.archived = false;
		    self.hud_class.alpha = 0; // hide class display for now...
		}

		if(!isdefined(self.hud_profannounce))
		{
			self.hud_profannounce = newClientHudElem(self);
			self.hud_profannounce.x = 0;
			self.hud_profannounce.y = 40;
			self.hud_profannounce.alignX = "center";
			self.hud_profannounce.alignY = "top";
			self.hud_profannounce.horzAlign = "center_safearea";
			self.hud_profannounce.vertAlign = "top";
			self.hud_profannounce.archived = false;
			self.hud_profannounce.font = "default";
			self.hud_profannounce.fontscale = 2;
		}

		if(!isdefined(self.hud_newprof))
		{
			self.hud_newprof = newClientHudElem(self);
			self.hud_newprof.x = 0;
			self.hud_newprof.y = 64;
			self.hud_newprof.alignX = "center";
			self.hud_newprof.alignY = "top";
			self.hud_newprof.horzAlign = "center_safearea";
			self.hud_newprof.vertAlign = "top";
			self.hud_newprof.archived = false;
			self.hud_newprof.font = "default";
			self.hud_newprof.fontscale = 2;
		}

		self updateClassHUD();
	}
}


giveClassXP( amount )
{
	xp = self getClassXP( self getClass() );
	self setClassXP( self getClass(), xp + amount );

	self thread updateProfAnnounceHUD();
}


updateProfAnnounceHUD()
{
	self endon("disconnect");

	self notify("update_prof");
	self endon("update_prof");

	if ( self getProficiency( self getClass() ) != self.pers["proficiency"] )
	{
		if ( isDefined( self.hud_newprof ) && isDefined( self.hud_rankannounce ) )
		{
			self.pers["proficiency"] = self getProficiency( self getClass() );
			self.hud_profannounce.alpha = 1;
			self.hud_profannounce setText( &"CLASS_NEWPROF" );
			self.hud_newprof.alpha = 1;
			self.hud_newprof setText( level.proficiencies[self.pers["proficiency"]] );

			self.hud_profannounce thread fadeAway( 3.0, 1.0 );
			self.hud_newprof thread fadeAway( 3.0, 2.0 );
		}
	}
}

fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}

updateClassHUD()
{
	if(isDefined(self.hud_class))
		self.hud_class setText( level.classes[self getClass()] );
}


removeClassHUD()
{
	if(isDefined(self.hud_class))
		self.hud_class destroy();
}


getProficiency( class )
{
	xp = self getClassXP( class );
	
	if ( xp < 1000 )
		return ("PROFICIENCY_MARKSMAN");
	else if ( xp < 5000 )
		return ("PROFICIENCY_SHARPSHOOTER");
	else
		return ("PROFICIENCY_EXPERT");
}


setClass( newClass )
{
	if ( !isDefined( self.pers["code"] ) )
		self.pers["code"] = [];

	switch( newClass )
	{
	case "CLASS_CLOSEQUARTERS":
	case "CLASS_ASSAULT":
	case "CLASS_SNIPER":
	case "CLASS_ENGINEER":
	case "CLASS_ANTIARMOR":
	case "CLASS_SUPPORT":
		self.pers["code"]["class"] = newClass;
		break;
	default:
		self.pers["code"]["class"] = "CLASS_CLOSEQUARTERS";
		break;
	}
	
	self.curClass = self.pers["code"]["class"];
	self notify ( "set_class", self.curClass );
}

getClass()
{
	return ( self.pers["code"]["class"] );
}

getClassXP( className )
{
	return( self.pers["code"][self.pers["code"]["class"]] );
}

setClassXP( className, amount )
{
	self.pers["code"][className] = amount;
}

initClassXP()
{
	if ( !isDefined( self.pers["code"] ) )
		self.pers["code"] = [];

	self.pers["code"]["CLASS_CLOSEQUARTERS"] = 999;
	self.pers["code"]["CLASS_ASSAULT"] = 999;
	self.pers["code"]["CLASS_SNIPER"] = 999;
	self.pers["code"]["CLASS_ENGINEER"] = 999;
	self.pers["code"]["CLASS_ANTIARMOR"] = 999;
	self.pers["code"]["CLASS_SUPPORT"] = 999;
}

// ============================================================================================
// =======																				=======
// =======						 Create a Class Specialties 							=======
// =======																				=======
// ============================================================================================

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
cac_selector()
{
	level.cac_bulletdamage_data = cac_get_dvar_int( "perk_bulletDamage", "25" );		// increased bullet damage by this %
	level.cac_armorvest_data = cac_get_dvar_int( "perk_armorVest", "75" );				// increased health by this %
	level.cac_explosivedamage_data = cac_get_dvar_int( "perk_explosiveDamage", "25" );	// increased explosive damage by this %
	
	perks = self.specialty;
	
	// register perks to code for 32bit player perk info exchange (Max unique perks is 32)
	self clearPerks();	// reset and re-register
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		if ( !isdefined( perk ) )
			continue;
			
		self setPerk( perk );
		//waittillframeend;
		//if( self hasPerk( perk ) )
		//	continue;
			//println( "Perk/> " + self.name + " :: " + perk + " = " + self hasPerk( perk ) );
		//else
		//	assertex( false, "Perk ERROR/> " + perk + " was added to the player, but player hasPerk(perk) returned false" );
		// calls the loop threads if exists
	}
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
		return getdvarfloat( dvar );
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

// CAC: Weapon Specialty: Increased bullet damage feature
// CAC: Weapon Specialty: Armor Vest feature
// CAC: Ability: Increased explosive damage feature
cac_modified_damage( victim, attacker, damage, meansofdeath )
{
	// skip conditions
	if( !isdefined( victim) || !isdefined( attacker ) || !isplayer( attacker ) || !isplayer( victim ) )
		return damage;
	if( attacker.sessionstate != "playing" || !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;
		
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
	if( attacker cac_hasSpecialty( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased bullet damage" );
		}
		else
		{
			final_damage = damage*(100+level.cac_bulletdamage_data)/100;
			println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to " + victim.name );
		}
	}
	else if( attacker cac_hasSpecialty( "specialty_explosivedamage" ) && isExplosiveDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased explosive damage" );
		}
		else
		{
			final_damage = damage*(100+level.cac_explosivedamage_data)/100;
			println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to " + victim.name );
		}
	}
	else
	{	
		// if attacker has no bullet damage then check if victim has armor
		// if victim has armor then less damage is taken, else damage unchanged
		
		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage*(level.cac_armorvest_data/100);
			println( "Perk/> " + victim.name + "'s armor decreased " + attacker.name + "'s damage" );
		}
		else
		{
			final_damage = old_damage;
		}	
	}
	
	// debug
	println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
	
	// return unchanged damage
	return int( final_damage );
}

// including grenade launcher, grenade, RPG, C4, claymore
isExplosiveDamage( meansofdeath )
{
	explosivedamage = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE";
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
