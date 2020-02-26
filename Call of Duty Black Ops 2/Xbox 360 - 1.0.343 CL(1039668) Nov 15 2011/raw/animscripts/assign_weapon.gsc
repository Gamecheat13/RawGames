#include maps\_utility;
#include common_scripts\Utility;

/*----------------------------------------------------------------------------------

The system manages weapons by using two arrays, anim._assignable_weapons and anim._assignable_attachments.  Both of
these arrays are created and filled out at level start with all weapons loaded into the level.

anim._assignable_weapons
	This is a three-dimensional array that orders weapons by team, class, and then weapon name.  For example,
	anim._assignable_weapons["allies"]["assault"]["m16"];  A weapon will be selected for the AI based on the defined
	parameters, and randomly select anything that isn't defined.
	
anim._assignable_attachments
	This is also a three-dimensional array that is used to sort attachments for a particular weapon.  It is ordered by
	weapon name, attachment type, attachment.  For example, anim._assignable_attachments["ak47"]["sights"]["acog"].  The 
	array returns the string for the weapon, such as "ak47_acog_sp" from the example above.  Attachments will be selected
	based on the defined parameters, and randomly select options that are not yet defined.
	
			****************************	
			***** USING THE SYSTEM *****
			****************************
			
By default, the system is turned off.  To enable the system, call the following function:
	assign_weapon_allow_random_attachments( true );
	
Once that is set, you will need to define weights to the various attachment types for a given faction.  The faction 
name should match the faction used in the class name.  For example, Ally_US_SEALS_Assault_AK47, faction is US.
The function to use is the following:
	build_weight_array_by_faction( str_faction, is_override, n_base_weapon, n_scoped, n_ammo, n_barrel, n_alt_weapon );

	is_override will override the base values (set to true)
	n_base_weapon, n_scoped, n_ammo, etc... sets the probability weight for the attachment type.  The higher, the more
		likely it is that a weapon with that attachment type will be used.
		
			************************	
			***** TEAM WEAPONS *****
			************************

By default, each weapon is assigned a team.  If your level requires a certain weapon to be used by a team that doesn't
use it by default, you can use the following function to add that weapon to the team's array
	add_weapon_to_class_and_faction( "allies", "assault", "ak47" );
	

----------------------------------------------------------------------------------*/

// Creates the needed variables and fills in the basic info needed for the system
// Should only be called in animscripts\init.gsc
assign_weapon_init()
{
	anim._assignable_weapons = [];
	anim._assignable_attachments = [];
	anim._attachment_weights = [];	
	anim._assignable_alt_allowed = [];
	
	//-- vars for controlling the drops
	if ( !isdefined( anim.aw_enabled ) )
	{
		anim.aw_enabled = true;
	}
	
	if ( !isdefined( anim.aw_attachments_allowed ) )
	{
		anim.aw_attachments_allowed = false;
	}
	
	if ( !isdefined( anim._assignable_alt_allowed["gl"] ) )
	{
		anim._assignable_alt_allowed["gl"] = true;
	}
	
	if ( !isdefined( anim._assignable_alt_allowed["mk"] ) )
	{
		anim._assignable_alt_allowed["mk"] = true;
	}
	
	if ( !isdefined( anim._assignable_alt_allowed["ft"] ) )
	{
		anim._assignable_alt_allowed["ft"] = true;
	}
		
	switch ( level.script )
	{
		case "la_1":
		
			add_weapons_to_class_and_faction( "ally", "assault",	array( "scar", "hk416" ) );
			add_weapons_to_class_and_faction( "ally", "smg",		array( "mp7" ) );
			add_weapons_to_class_and_faction( "ally", "lmg",		array( "mk48" ) );
			add_weapons_to_class_and_faction( "ally", "sniper",		array( "dsr50" ) );
			add_weapons_to_class_and_faction( "ally", "shotgun",	array( "ksg" ) );
			add_weapons_to_class_and_faction( "ally", "pistol",		array( "m1911" ) );
			add_weapons_to_class_and_faction( "ally", "launcher",	array( "rpg" ) );
			
			add_weapons_to_class_and_faction( "manticore", "assault",	array( "xm8" ) );
			add_weapons_to_class_and_faction( "manticore", "smg",		array( "vector", "mp5k", "uzi" ) );
			add_weapons_to_class_and_faction( "manticore", "lmg",		array( "m60" ) );
			add_weapons_to_class_and_faction( "manticore", "sniper",	array( "dsr50" ) );
			add_weapons_to_class_and_faction( "manticore", "shotgun",	array( "ksg" ) );
			add_weapons_to_class_and_faction( "manticore", "pistol",	array( "fiveseven", "kard" ) );
			add_weapons_to_class_and_faction( "manticore", "launcher",	array( "rpg" ) );
			
			break;
			
		case "la_1b":
		
			add_weapons_to_class_and_faction( "ally", "assault",	array( "scar", "hk416" ) );
			add_weapons_to_class_and_faction( "ally", "smg",		array( "mp7" ) );
			add_weapons_to_class_and_faction( "ally", "lmg",		array( "mk48" ) );
			add_weapons_to_class_and_faction( "ally", "sniper",		array( "dsr50" ) );
			add_weapons_to_class_and_faction( "ally", "shotgun",	array( "ksg" ) );
			add_weapons_to_class_and_faction( "ally", "pistol",		array( "m1911" ) );
			add_weapons_to_class_and_faction( "ally", "launcher",	array( "rpg" ) );
			
			add_weapons_to_class_and_faction( "manticore", "assault",	array( "xm8" ) );
			add_weapons_to_class_and_faction( "manticore", "smg",		array( "vector", "mp5k", "uzi" ) );
			add_weapons_to_class_and_faction( "manticore", "lmg",		array( "m60" ) );
			add_weapons_to_class_and_faction( "manticore", "sniper",	array( "dsr50" ) );
			add_weapons_to_class_and_faction( "manticore", "shotgun",	array( "ksg" ) );
			add_weapons_to_class_and_faction( "manticore", "pistol",	array( "fiveseven", "kard" ) );
			add_weapons_to_class_and_faction( "manticore", "launcher",	array( "rpg" ) );
			
			break;
			
		case "karma":
		case "karma_2":
			// All teammates are heroes
			// Friendly security forces
			add_weapons_to_class_and_faction( "ally_security", "assault",	array( "rx4storm" ) );
			add_weapons_to_class_and_faction( "ally_security", "smg",		array( "insas" ) );
//			add_weapons_to_class_and_faction( "ally_security", "lmg",		array( "qbb95" ) );
			add_weapons_to_class_and_faction( "ally_security", "sniper",	array( "dsr50" ) );
			add_weapons_to_class_and_faction( "ally_security", "shotgun",	array( "ns2000" ) );
			add_weapons_to_class_and_faction( "ally_security", "pistol",	array( "fiveseven" ) );
//			add_weapons_to_class_and_faction( "ally_security", "launcher",	array( "rpg" ) );
			
			// Enemies (disguised security)
			add_weapons_to_class_and_faction( "manticore", "assault",	array( "rx4storm", "tar21" ) );
			add_weapons_to_class_and_faction( "manticore", "smg",		array( "insas", "qcw05" ) );
			add_weapons_to_class_and_faction( "manticore", "lmg",		array( "qbb95" ) );
			add_weapons_to_class_and_faction( "manticore", "sniper",	array( "dsr50", "svu" ) );
			add_weapons_to_class_and_faction( "manticore", "shotgun",	array( "ns2000", "saiga12" ) );
			add_weapons_to_class_and_faction( "manticore", "pistol",	array( "fiveseven", "beretta93r" ) );
			add_weapons_to_class_and_faction( "manticore", "launcher",	array( "rpg" ) );
			
			break;
			
		case "panama":
			
			add_weapons_to_class_and_faction( "ally", "assault",	array( "fnfal", "scar", "xm8" ) );
			add_weapons_to_class_and_faction( "ally", "smg",		array( "mp7", "vector", "ar57" ) );
			add_weapons_to_class_and_faction( "ally", "lmg",		array( "mk48" ) );
			add_weapons_to_class_and_faction( "ally", "sniper",		array( "psg1_vzoom", "l96a1" ) );
			add_weapons_to_class_and_faction( "ally", "shotgun",	array( "ksg" ) );
			add_weapons_to_class_and_faction( "ally", "pistol",		array( "asp" ) );
			add_weapons_to_class_and_faction( "ally", "launcher",	array( "rpg" ) );
			
			add_weapons_to_class_and_faction( "pdf", "assault",	array( "galil", "ak47", "fnfal" ) );
			add_weapons_to_class_and_faction( "pdf", "smg",		array( "uzi" ) );
			add_weapons_to_class_and_faction( "pdf", "lmg",		array( "rpk" ) );
			add_weapons_to_class_and_faction( "pdf", "sniper",	array( "dragunov" ) );
			add_weapons_to_class_and_faction( "pdf", "shotgun",	array( "spas", "rottweil72" ) );
			add_weapons_to_class_and_faction( "pdf", "pistol",	array( "makarov" ) );
			add_weapons_to_class_and_faction( "pdf", "launcher",	array( "rpg" ) );
			
			break;
			
		case "yemen":
			
			add_weapons_to_class_and_faction( "seal", "assault",	array( "xm8" ) );
			add_weapons_to_class_and_faction( "seal", "smg",		array( "mp7" ) );
			// add_weapons_to_class_and_faction( "seal", "lmg",		array( "mk48" ) );
			// add_weapons_to_class_and_faction( "seal", "sniper",		array( "psg1_vzoom", "l96a1" ) );
			// add_weapons_to_class_and_faction( "seal", "shotgun",	array( "ksg" ) );
			add_weapons_to_class_and_faction( "seal", "pistol",		array( "fiveseven" ) );
			add_weapons_to_class_and_faction( "seal", "launcher",	array( "rpg" ) );
			
			add_weapons_to_class_and_faction( "yemeni", "assault",	array( "m4a1" ) );
			add_weapons_to_class_and_faction( "yemeni", "smg",		array( "mp5" ) );
			// add_weapons_to_class_and_faction( "yemeni", "lmg",		array( "mk48" ) );
			// add_weapons_to_class_and_faction( "yemeni", "sniper",		array( "psg1_vzoom", "l96a1" ) );
			// add_weapons_to_class_and_faction( "yemeni", "shotgun",	array( "ksg" ) );
			add_weapons_to_class_and_faction( "yemeni", "pistol",		array( "fnp45" ) );
			add_weapons_to_class_and_faction( "yemeni", "launcher",	array( "rpg" ) );			
			
			add_weapons_to_class_and_faction( "terrorist", "assault",	array( "an94" ) );
			add_weapons_to_class_and_faction( "terrorist", "smg",		array( "evoskorpion" ) );
			// add_weapons_to_class_and_faction( "terrorist", "lmg",		array( "rpk" ) );
			// add_weapons_to_class_and_faction( "terrorist", "sniper",	array( "dragunov" ) );
			// add_weapons_to_class_and_faction( "terrorist", "shotgun",	array( "spas", "rottweil72" ) );
			add_weapons_to_class_and_faction( "terrorist", "pistol",	array( "pt638" ) );
			add_weapons_to_class_and_faction( "terrorist", "launcher",	array( "rpg" ) );
			
			break;
			
		case "afghanistan":
			
			add_weapons_to_class_and_faction( "ally", "assault", array( "ak47" ) );
			add_weapons_to_class_and_faction( "ally", "smg", array( "ak74u" ) );
			add_weapons_to_class_and_faction( "ally", "lmg",	 array( "rpd" ) );
			add_weapons_to_class_and_faction( "ally", "sniper", array( "dragunov" ) );
			add_weapons_to_class_and_faction( "ally", "shotgun", array( "ksg" ) );
			add_weapons_to_class_and_faction( "ally", "pistol", array( "makarov" ) );
			add_weapons_to_class_and_faction( "ally", "launcher", array( "rpg" ) );
			
			add_weapons_to_class_and_faction( "enemy", "assault", array( "ak47" ) );
			add_weapons_to_class_and_faction( "enemy", "smg", array( "ak74u" ) );
			add_weapons_to_class_and_faction( "enemy", "lmg", array( "rpd" ) );
			add_weapons_to_class_and_faction( "enemy", "sniper", array( "dragunov" ) );
			add_weapons_to_class_and_faction( "enemy", "shotgun", array( "spas" ) );
			add_weapons_to_class_and_faction( "enemy", "pistol", array( "makarov" ) );
			add_weapons_to_class_and_faction( "enemy", "launcher", array( "rpg" ) );
			
			break;
			
		case "pow":
			
			add_weapons_to_class_and_faction( "ally", "assault",	array( "ak47", "galil" ) );
			add_weapons_to_class_and_faction( "ally", "smg",		array( "uzi" ) );
			add_weapons_to_class_and_faction( "ally", "lmg",		array( "rpk" ) );
//			add_weapons_to_class_and_faction( "ally", "sniper",		array( "psg1_vzoom", "l96a1" ) );
//			add_weapons_to_class_and_faction( "ally", "shotgun",	array( "ksg" ) );
			add_weapons_to_class_and_faction( "ally", "pistol",		array( "cz75" ) );
			add_weapons_to_class_and_faction( "ally", "launcher",	array( "rpg" ) );
			
			add_weapons_to_class_and_faction( "enemy", "assault",	array( "ak47", "galil", "g11" ) );
			add_weapons_to_class_and_faction( "enemy", "smg",		array( "uzi" ) );
			add_weapons_to_class_and_faction( "enemy", "lmg",		array( "rpk" ) );
//			add_weapons_to_class_and_faction( "enemy", "sniper",	array( "dragunov" ) );
			add_weapons_to_class_and_faction( "enemy", "shotgun",	array( "rottweil72" ) );
			add_weapons_to_class_and_faction( "enemy", "pistol",	array( "cz75" ) );
			add_weapons_to_class_and_faction( "enemy", "launcher",	array( "rpg" ) );
			
			break;
	}
	
	//TEMP ( str_faction, is_override, n_base_weapon, n_scoped_attachment, n_ammo_attachment, n_barrel_attachment, n_alt_weapon )
	// build_weight_array_by_faction( "RU", 1, 10, 20, 20, 0, 0 );
	// build_weight_array_by_faction( "Spetsnaz", 1, 10, 10, 10, 10, 90 );
}

/*----------------------------------------------------------------------------------
			Functions to buid and manage anim._assignable_weapons
----------------------------------------------------------------------------------*/

// If there currently isn't an entry for the passed in faction, create it.
// str_class = the weapon class 
add_faction_to_weapon_array( str_faction )
{
	if ( !isdefined( anim._assignable_weapons[ str_faction ] ) )
	{
		anim._assignable_weapons[ str_faction ] = [];
	}
}

// If str_class is not part of the str_faction's array, add it
add_weapon_class_to_weapon_array( str_class, str_faction )
{
	add_faction_to_weapon_array( str_faction );
	
	if ( !isdefined( anim._assignable_weapons[ str_faction ][ str_class ] ) )
	{
		anim._assignable_weapons[ str_faction ][ str_class ] = [];
	}
}

// Add str_weapon to the array, under [str_faction][str_class]
add_weapon_to_class_and_faction( str_faction, str_class, str_weapon )
{
	add_weapon_class_to_weapon_array( str_class, str_faction );
	if( IsAssetLoaded( "weapon", str_weapon + "_sp" ) ) // don't create new keys in the array until we know the weapon is in the level for a smaller array
	{
		anim._assignable_weapons[ str_faction ][ str_class ][ str_weapon ] = str_weapon;
		set_attachments_for_weapon( str_weapon );
	}
}

// adds each weapon in a_weapon_list and adds them to the array, under [str_faction][str_class]
add_weapons_to_class_and_faction( str_faction, str_class, a_weapon_list )
{
	foreach ( str_weapon in a_weapon_list )
	{
		add_weapon_to_class_and_faction( str_faction, str_class, str_weapon ); // error checks and adds the weapon to the array
	}
}

/*----------------------------------------------------------------------------------
			Functions to buid and manage anim._assignable_attachments
----------------------------------------------------------------------------------*/

// add a weapon to the anim._assignable_attachments array, as well as adding the base weapon to that array
add_weapon_to_attachment_array( str_weapon )
{
	str_base_weapon = str_weapon + "_sp";
	if ( IsAssetLoaded( "weapon", str_base_weapon ) && !isdefined( anim._assignable_attachments[ str_weapon ] ) )
	{
		anim._assignable_attachments[ str_weapon ] = [];
		anim._assignable_attachments[ str_weapon ][ "base" ] = str_base_weapon;	
		PreCacheItem( str_base_weapon );			
	}
}

// add an attachment categoy (such as sight, ammo, etc...) to the specificied weapon, as a key in the weapon's array
add_attachment_category_to_attachment_array( str_attachment_type, str_weapon )
{
	add_weapon_to_attachment_array( str_weapon );
	
	if( !isdefined( anim._assignable_attachments[ str_weapon ][ str_attachment_type ] ) )
	{
		anim._assignable_attachments[ str_weapon ][ str_attachment_type ] = [];
	}
}

// add the weapon with attachment to the array, storing it in an array of the attachment's category( ["sight"]["acog"] )
add_weapon_attachment_to_attachment_array( str_attachment, str_attachment_type, str_weapon )
{
	str_weapon_with_attachment = str_weapon + "_" + str_attachment + "_sp";
	
	if ( IsAssetLoaded( "weapon", str_weapon_with_attachment ) )
	{
		add_attachment_category_to_attachment_array( str_attachment_type, str_weapon ); // delay adding the category until we know there is a weapon in it
		anim._assignable_attachments[ str_weapon ][str_attachment_type][ str_attachment ] = str_weapon_with_attachment;
		
		PreCacheItem( str_weapon_with_attachment );
		
		if( str_attachment_type == "alt_weapon" )	// load both versions of the weapon if it is an alt
		{
			str_alt_weapon = str_attachment + "_" + str_weapon + "_sp";
			PreCacheItem( str_alt_weapon );
		}
	}
}

//-- Add an entry to anim._attachment_weights[ str_ai_class ] that holds the weights for the different attachment types
build_weight_array_by_faction( str_faction, is_overwrite, n_base_weapon, n_scoped_attachment, n_ammo_attachment, n_barrel_attachment, n_alt_weapon )
{
	str_faction = ToLower( str_faction );
	if ( !isdefined( anim._attachment_weights[ str_faction ] ) || is_overwrite )
	{	
		anim._attachment_weights[ str_faction ] = [];
		anim._attachment_weights[ str_faction ][ "base" ] = n_base_weapon;
		anim._attachment_weights[ str_faction ][ "sights" ] = n_scoped_attachment;
		anim._attachment_weights[ str_faction ][ "ammo" ] = n_ammo_attachment;
		anim._attachment_weights[ str_faction ][ "barrel" ] = n_ammo_attachment;
		anim._attachment_weights[ str_faction ][ "alt_weapon" ] = n_alt_weapon;
	}
}

// Checks each weapon attachment and, if loaded, adds them to anim._assignable_attachments
set_attachments_for_weapon( str_weapon )
{
	// TODO: Can these be done without hardcoding the values?
	attachment_categories = array("sights", "ammo", "barrel", "auto", "alt_weapon");
	
	primary_weapon_attachments = [];
	primary_weapon_attachments["sights"] = array( "acog", "elbit", "ir", "reflex");	
	primary_weapon_attachments["ammo"] = array( "extclip", "dualclip" );						
	primary_weapon_attachments["barrel"] = array( "silencer" );											
	primary_weapon_attachments["auto"] = array( "auto" );														
	primary_weapon_attachments["alt_weapon"] = array( "ft", "gl", "mk" );																
	
	_sp = "_sp";	
	
	add_weapon_to_attachment_array( str_weapon );
	
	// check to see if each attachment variant is loaded.  If so, add to array
	for( n_type = 0; n_type < attachment_categories.size; n_type++ )
	{				
		for( n_attachment = 0; n_attachment < primary_weapon_attachments[ attachment_categories[n_type] ].size; n_attachment++ )
		{
			str_attachment_type = attachment_categories[n_type];
			str_attachment = primary_weapon_attachments[ attachment_categories[n_type] ][n_attachment];
			
			add_weapon_attachment_to_attachment_array( str_attachment, str_attachment_type, str_weapon );
		}
	}	
}

/*----------------------------------------------------------------------------------
			Functions to get weapons/classes based on parameters
----------------------------------------------------------------------------------*/

// self = the ai we need to get a weapon for
// TODO: add asserts and error checking
get_random_weapon_by_class( str_faction, str_class )
{
	if( isdefined( anim._assignable_weapons[ str_faction ] ) && isdefined( anim._assignable_weapons[ str_faction ][ str_class ] ) )
	{
		if ( anim._assignable_weapons[ str_faction ][ str_class ].size > 0 )
		{
			a_weapon_keys = GetArrayKeys( anim._assignable_weapons[ str_faction ][ str_class ] );
			n_weapon_index = RandomInt( anim._assignable_weapons[ str_faction ][ str_class ].size );
			str_weapon = a_weapon_keys[ n_weapon_index ];
		}
	}
	
	return str_weapon;
}

// Returns the base weapon with the possibility of attachments added, based on the weights for the weapon/faction
// TODO: add asserts and error checking
get_weapon_with_attachments( str_weapon )
{
	if( !isdefined(anim.aw_attachments_allowed) || !anim.aw_attachments_allowed )
	{
		return str_weapon + "_sp";
	}
	
	a_attachments = anim._assignable_attachments[ str_weapon ];
	a_attachment_keys = GetArrayKeys( a_attachments );
	
	str_faction = get_faction_for_attachments( self.classname );
	if ( !isdefined( str_faction ) )
	{
		return str_weapon + "_sp";
	}	

	str_current_key = select_attachment_at_random( a_attachment_keys, str_faction );
	str_weapon_with_attachment = "";
	
	if ( str_current_key == "alt_weapon" )
	{
		// only select the alt weapon if it is allowed
		a_attachments = GetArrayKeys( anim._assignable_attachments[ str_weapon ][ str_current_key ] );
		a_allowed_attachments = [];
		for ( i = 0; i < a_attachments.size; i++ )
		{
			if( isdefined( anim._assignable_alt_allowed[ a_attachments[i] ] ) && anim._assignable_alt_allowed[ a_attachments[i] ] )
			{
				a_allowed_attachments[ a_allowed_attachments.size ] = a_attachments[i];
			}
		}
		
		// If no attachments are allowed, reselect a weighted attachment 
		if ( a_allowed_attachments.size == 0 )
		{
			a_attachment_keys = array_remove( a_attachment_keys, "alt_weapon" );
			str_current_key = select_attachment_at_random( a_attachment_keys, str_faction );
		}
		else 
		{
			str_attachment = a_allowed_attachments[ RandomInt( a_allowed_attachments.size ) ];
			str_weapon_with_attachment = anim._assignable_attachments[ str_weapon ][ str_current_key ][ str_attachment ];
		}
	}		
	
	if ( str_weapon_with_attachment == "" && str_current_key == "base" )
	{
		str_weapon_with_attachment = anim._assignable_attachments[ str_weapon ][ str_current_key ];
	}
	else
	{
		a_attachments = GetArrayKeys( anim._assignable_attachments[ str_weapon ][ str_current_key ] );
		str_attachment = a_attachments[ RandomInt( a_attachments.size ) ];
		str_weapon_with_attachment = anim._assignable_attachments[ str_weapon ][ str_current_key ][ str_attachment ];
	}
	
	return str_weapon_with_attachment;
}

select_attachment_at_random( a_attachment_keys, str_faction )
{
	n_total_weight = 0;
	for ( i = 0; i < a_attachment_keys.size; i++ )
	{
		n_total_weight += anim._attachment_weights[ str_faction ][ a_attachment_keys[i] ];
	}		
	
	n_choice = RandomInt( n_total_weight );
	str_current_key = "base";
	n_current_weight = 0;
	
	for(i = 0; i < a_attachment_keys.size; i++)
	{
		str_current_key = a_attachment_keys[i];
		n_current_weight += anim._attachment_weights[ str_faction ][ a_attachment_keys[i] ];
		if( n_choice < n_current_weight )
		{
			break;
		}
	}
	
	return str_current_key;
}

// Randomly select a weapon based on the desired class ( assault, smg, etc ).
get_random_weapon_with_attachments_by_class( str_faction, str_class )
{	
	str_weapon_with_attachment = self.primaryweapon;
	
	str_weapon = self get_random_weapon_by_class( str_faction, str_class );
	if( isdefined( str_weapon ) )
	{
		str_weapon_with_attachment = self get_weapon_with_attachments( str_weapon );
	}
	
	return str_weapon_with_attachment;
}

// Find which faction the current AI belongs to, used for finding the weights
// Self = the AI 
get_faction_for_attachments( str_classname )
{
	str_classname = ToLower( str_classname );
	a_string_tokens = StrTok( str_classname, "_" );
		
	// Loop through the classname and find the most specific faction
	a_factions = GetArrayKeys( anim._attachment_weights );
	foreach ( str_token in a_string_tokens )
	{
		if ( is_in_array( a_factions, str_token ) )
		{
			str_faction = str_token;
		}
	}
	
	return str_faction;
}

/*----------------------------------------------------------------------------------
			Camo Assignment
----------------------------------------------------------------------------------*/

// TODO: clean this up.

//cammo types ( 0-14 )
//0,camo,cammo_gunmetal,cammo_gunplastic,cammo_wood_tile_red,od_green_aug,cammo_tan_enfield,,,
//1,camo,solid_camo_dusty,solid_camo_dusty,solid_camo_dusty,solid_camo_dusty,solid_camo_dusty,,,
//2,camo,solid_camo_ice,solid_camo_ice,solid_camo_ice,solid_camo_ice,solid_camo_ice,,,
//3,camo,cammo_red,cammo_red,cammo_red,cammo_red,cammo_red,,,
//4,camo,solid_camo_od,solid_camo_od,solid_camo_od,solid_camo_od,solid_camo_od,,,
//5,camo,camo_desert_nevada,solid_camo_desert_nevada,solid_camo_desert_nevada,camo_desert_nevada,camo_desert_nevada,,,
//6,camo,camo_desert_sahara,solid_camo_desert_sahara,solid_camo_desert_sahara,camo_desert_sahara,camo_desert_sahara,,,
//7,camo,camo_jungle_erdl,solid_camo_jungle_erdl,solid_camo_jungle_erdl,camo_jungle_erdl,camo_jungle_erdl,,,
//8,camo,camo_jungle_tiger,solid_camo_jungle_tiger,solid_camo_jungle_tiger,camo_jungle_tiger,camo_jungle_tiger,,,
//9,camo,camo_urban_german,solid_camo_urban_german,solid_camo_urban_german,camo_urban_german,camo_urban_german,,,
//10,camo,camo_urban_warsaw,solid_camo_urban_warsaw,solid_camo_urban_warsaw,camo_urban_warsaw,camo_urban_warsaw,,,
//11,camo,camo_winter_siberia,solid_camo_winter_siberia,solid_camo_winter_siberia,camo_winter_siberia,camo_winter_siberia,,,
//12,camo,camo_winter_yukon,solid_camo_winter_yukon,solid_camo_winter_yukon,camo_winter_yukon,camo_winter_yukon,,,
//13,camo,camo_woodland,solid_camo_woodland,solid_camo_woodland,camo_woodland,camo_woodland,,,
//14,camo,camo_woodland_flora,solid_camo_woodland_flora,solid_camo_woodland_flora,camo_woodland_flora,camo_woodland_flora,,,
/*------------------------------------
when an AI dies and drops their weapon they now have a chance to drop cammo based on level and weapon specific percentages
------------------------------------*/
set_random_camo_drop()
{
	while( isdefined(self) )
	{
		self waittill( "dropweapon", weapon );
		
		if (!isdefined( weapon ) || !isdefined( weapon.classname ) )
		{
			continue;
		}
		
		weapon_class = get_weapon_type(weapon.classname);
		
		if(!isdefined(weapon_class))
		{
			return;
		}
		
		name = tolower( weapon.classname );
		
		switch(level.script)
		{		

	//------------------------------------------------------------------				
			case "khe_sanh":
			
				if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"m16") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(1);
						}
					}
					else if( IsSubstr( name ,"m14") )
					{
						if(randomint(100) > 56)
						{
							weapon ItemWeaponSetOptions(1);
						}
					}
					else if( IsSubstr( name ,"ak74") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(7);
						}
					}			
				}
	
				else if(weapon_class == "launcher")
				{
					if( IsSubstr( name ,"china") )
					{
						if(randomint(100) > 49)
						{
							weapon ItemWeaponSetOptions(6);
						}
					}
					else if( IsSubstr( name ,"tow") )
					{
						weapon ItemWeaponSetOptions(6);
					}
					else if( IsSubstr( name ,"law") )
					{
						weapon ItemWeaponSetOptions(1);
					}
					else if( IsSubstr( name ,"rpg") )
					{
						weapon ItemWeaponSetOptions(7);
					}		
				}
				
				else if(weapon_class == "shotgun")
				{
					if(randomint(100) > 74)
					{
						weapon ItemWeaponSetOptions(1);
					}
				}
				else if(weapon_class == "lmg")
				{
					if( IsSubstr( name ,"rpk") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(7);
						}
					}
					else if( isSubstr(name,"m60"))
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(1);
						}
					}
				}
				break;
	//------------------------------------------------------------------	
			case "pow": 

				if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"ak47") || IsSubstr( name ,"galil") )
					{
						if(randomint(100) > 39)
						{
							weapon ItemWeaponSetOptions(14);
						}
					}
				}					
				else if(weapon_class == "smg")
				{
					if(randomint(100) > 49)
					{
						weapon ItemWeaponSetOptions(14);
					}
				}	
				else if(weapon_class == "shotgun")
				{
					if(randomint(100) > 39)
					{
						weapon ItemWeaponSetOptions(9);
					}
				}
				else if(weapon_class == "lmg")
				{
					if(randomint(100) > 39)
					{
						weapon ItemWeaponSetOptions(13);
					}
				}	
	
				break;
	//------------------------------------------------------------------			
			case "default":
				break;						
		}

	}
}

get_weapon_type(weapon_name)
{	
	//shotgun
	_classname = tolower(weapon_name);	
	
	if( IsSubstr( _classname,"ks23") || IsSubstr( _classname,"rottweil") || IsSubstr( _classname,"ithaca") || isSubstr(_classname,"spas"))
	{
		return "shotgun";
	}
		
	//assault rifle
	else if( IsSubstr( _classname,"m16") || IsSubstr( _classname,"fnfal") || IsSubstr( _classname,"ak47") ||IsSubstr( _classname,"ak74")|| isSubstr(_classname,"mp5k") || isSubstr(_classname,"m14") || IsSubstr( _classname,"commando") || IsSubstr( _classname,"g11") || IsSubstr( _classname,"aug")|| IsSubstr( _classname,"famas") || IsSubstr( _classname,"galil") || IsSubstr( _classname,"enfield") || IsSubstr( _classname,"scar") )
	{
		return "assault";
	}
	
	//smg
	else if( IsSubstr( _classname,"skorpion") || IsSubstr( _classname,"pm63") || IsSubstr( _classname,"kiparis") ||IsSubstr( _classname,"spectre")|| isSubstr(_classname,"uzi") || isSubstr(_classname,"ppsh") || IsSubstr( _classname,"mp40") || IsSubstr( _classname,"sten") || IsSubstr( _classname,"mp44")|| IsSubstr( _classname,"mac11") || IsSubstr( _classname,"kriss") || IsSubstr( _classname,"ar57") )
	{
		return "smg";
	}
	
	//lmg
	else if( IsSubstr( _classname,"rpk") || IsSubstr( _classname,"m60") || IsSubstr( _classname,"hk21") ||IsSubstr( _classname,"mg42")|| isSubstr(_classname,"stoner") )
	{
		return "lmg";
	}
	
	//sniper
	else if( IsSubstr( _classname,"dragon") || IsSubstr( _classname,"wa2000") || IsSubstr( _classname,"psg") || IsSubstr( _classname,"l96") )
	{
		return "sniper";
	}
		
	//launcher
	else if( IsSubstr( _classname,"tow") || IsSubstr( _classname,"rpg") || IsSubstr( _classname,"strela") ||IsSubstr( _classname,"panzer")|| isSubstr(_classname,"china") || IsSubstr( _classname,"m202") || IsSubstr( _classname,"law"))
	{
		return "launcher";
	}	
	
	
}

assign_random_weapon()
{
	str_final_weapon = self.primaryweapon;
	
	if ( isdefined( anim._assignable_weapons ) )
	{
		str_classname = ToLower( self.classname );
		a_string_tokens = StrTok( str_classname, "_" );
		
		// Only assign random weapon if "base" is in the classname
		if ( is_in_array( a_string_tokens, "base" ) )
		{		
			// Loop through the classname and find the most specific team
			str_factions = GetArrayKeys( anim._assignable_weapons );
			foreach ( str_token in a_string_tokens )
			{
				if ( is_in_array( str_factions, str_token ) )
				{
					str_faction = str_token;
				}
			}
			
			if ( isdefined( str_faction ) )
			{
				// Loop through the classname and find the most specific class
				a_classes = GetArrayKeys( anim._assignable_weapons[ str_faction ] );
				foreach ( str_token in a_string_tokens )
				{
					if ( is_in_array( a_classes, str_token ) )
					{
						str_class = str_token;
					}
				}			
			}
			
			if ( isdefined( str_class ) )
			{
				// Loop through the classname and find the first specified weapon. This will be used as the primary weapon if specified.
				a_weapons = GetArrayKeys( anim._assignable_weapons[ str_faction ][ str_class ] );
				foreach ( str_token in a_string_tokens )
				{
					if ( is_in_array( a_weapons, str_token ) )
					{
						str_weapon = str_token;
						break;
					}
				}
			}
			
			if( isdefined( str_weapon ) )
			{
				str_final_weapon = get_weapon_with_attachments( str_weapon );
			}
			else if ( isdefined( str_faction ) && isdefined( str_class ) )
			{
				str_final_weapon = get_random_weapon_with_attachments_by_class( str_faction, str_class );
			}
		}
	}
	
	return str_final_weapon;
}

/*----------------------------------------------------------------------------------
			Script Functions
----------------------------------------------------------------------------------*/

// add the weapon with attachment to the array, storing it in an array of the attachment's category( ["sight"]["acog"] )
// TODO: error checking
remove_weapon_attachment_from_attachment_array( str_weapon, str_attachment_type, str_attachment )
{
	anim._assignable_attachments[ str_weapon ][ str_attachment_type ] = array_remove_index( anim._assignable_attachments[ str_weapon ][ str_attachment_type ], str_attachment );
	
	if( anim._assignable_attachments[ str_weapon ][ str_attachment_type ].size == 0 )
	{
		anim._assignable_attachments[ str_weapon ] = array_remove_index( anim._assignable_attachments[ str_weapon ], str_attachment_type, true );
	}
	
	if( anim._assignable_attachments[ str_weapon ].size == 0 )
	{
		anim._assignable_attachments = array_remove_index( anim._assignable_attachments, str_weapon, true );
	}
}

// Wrapper functions to toggle various drop preferences
assign_weapon_allow_random_weapons( is_allowed )
{
	anim.aw_enabled = is_allowed;
}

assign_weapon_allow_random_attachments( is_allowed )
{
	anim.aw_attachments_allowed = is_allowed;
}

assign_weapon_allow_grenade_launcher( is_allowed )
{
	anim._assignable_alt_allowed["gl"] = is_allowed;
}

assign_weapon_allow_master_key( is_allowed )
{
	anim._assignable_alt_allowed["mk"] = is_allowed;
}

assign_weapon_allow_flamethrower( is_allowed )
{
	anim._assignable_alt_allowed["ft"] = is_allowed;
}
