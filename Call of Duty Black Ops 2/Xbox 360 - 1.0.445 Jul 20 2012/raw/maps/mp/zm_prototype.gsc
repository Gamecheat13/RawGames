#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#insert raw\common_scripts\utility.gsh;

main()
{
	//needs to be first for create fx
	maps\mp\zm_prototype_fx::main();
	maps\mp\zombies\_zm::init_fx();
	maps\mp\animscripts\zm_death::precache_gib_fx();//this really belongs in zm_load::main
	level.zombiemode = true;

	maps\mp\_load::main();

	maps\mp\zm_prototype_amb::main();
	
	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	level._round_start_func = maps\mp\zombies\_zm::round_start;
	
	level.giveCustomLoadout = ::giveCustomLoadout;
	level.precacheCustomCharacters = ::precacheCustomCharacters;
	level.giveCustomCharacters = ::giveCustomCharacters;
	initCharacterStartIndex();
	
	level.zombiemode_using_tombstone_perk = true;
	
	level._zombie_custom_add_weapons = ::custom_add_weapons;

	//Level specific stuff
	include_weapons();
	include_powerups();
	include_buildables();
	include_equipment_for_level();
	include_game_modules();
	
	//Init zombiemode scripts
	maps\mp\zombies\_zm::init();
	
	maps\mp\zombies\_zm_weap_cymbal_monkey::init();
	maps\mp\zombies\_zm_weap_ballistic_knife::init();
	maps\mp\zombies\_zm_weap_crossbow::init();
	maps\mp\zombies\_zm_weap_thundergun::init();
	maps\mp\zombies\_zm_weap_riotshield::init();
	maps\mp\zombies\_zm_weap_jetgun::init();
	maps\mp\zombies\_zm_weap_tazer_knuckles::init();

	//Magic box must not move! (only 1 spot)
	SetDvar( "magic_chest_movable", "0" );
	
	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func = ::prototype_zone_init;
	init_zones[0] = "start_zone";
	level thread maps\mp\zombies\_zm_zonemgr::manage_zones( init_zones );

	level.zombie_ai_limit = 24;

	maps\mp\createart\zm_prototype_art::main();
	
	// Power On Perk Machines
	flag_wait( "start_zombie_round_logic" );
	level notify("tombstone_on");
}

precacheCustomCharacters()
{
	//Precache characters
	character\c_usa_dempsey_zm::precache();// Dempsy
	character\c_rus_nikolai_zm::precache();// Nikolai
	character\c_jap_takeo_zm::precache();// Takeo
	character\c_ger_richtofen_zm::precache();// Richtofen
	
	PrecacheModel( "viewmodel_usa_pow_arms" );
	PrecacheModel( "viewmodel_rus_prisoner_arms" );
	PrecacheModel( "viewmodel_vtn_nva_standard_arms" );
	PrecacheModel( "viewmodel_usa_hazmat_arms" );
}
	
	
initCharacterStartIndex()
{
	level.characterStartIndex = RandomInt( 4 );
}

selectCharacterIndexToUse()
{
	if( level.characterStartIndex>=4 )
		level.characterStartIndex = 0;

	self.characterIndex = level.characterStartIndex;
	level.characterStartIndex++;
	
	return self.characterIndex;
}	

giveCustomCharacters()
{
	self DetachAll();
	switch( self selectCharacterIndexToUse() )
	{
		case 0:
		{
			//Dempsy
			self character\c_usa_dempsey_zm::main();
			self SetViewModel( "viewmodel_usa_pow_arms" );
			self.characterIndex = 0;
			break;
		}
		case 1:
		{
			//Nikolai
			self character\c_rus_nikolai_zm::main();
			self SetViewModel( "viewmodel_rus_prisoner_arms" );
			self.characterIndex = 1;
			break;
		}
		case 2:
		{
			//Takeo
			self character\c_jap_takeo_zm::main();
			self SetViewModel( "viewmodel_vtn_nva_standard_arms" );
			self.characterIndex = 2;
			break;
		}
		case 3:
		{	
			//Richtofen
			self character\c_ger_richtofen_zm::main();
			self SetViewModel( "viewmodel_usa_hazmat_arms" );
			self.characterIndex = 3;
			break;
		}
	}
	
	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );
}

giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
 	self giveWeapon( "knife_zm" );
	self give_start_weapon( true );
}

//*****************************************************************************
// ZONE INIT
//*****************************************************************************
prototype_zone_init()
{
	flag_init( "always_on" );
	flag_set( "always_on" );

	// foyer_zone
	add_adjacent_zone( "start_zone", "box_zone", "start_2_box" );	
	add_adjacent_zone( "start_zone", "upstairs_zone", "start_2_upstairs" );	
	add_adjacent_zone( "box_zone", "upstairs_zone", "box_2_upstairs" );	
}	


include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
	include_powerup( "carpenter" );
}

include_weapons()
{
	//Weapons - Pistols	
	include_weapon( "knife_zm", false );
	include_weapon( "frag_grenade_zm", false );
	include_weapon( "claymore_zm", false );

	//	Weapons - Pistols
	include_weapon( "m1911_zm", false );
	include_weapon( "m1911_upgraded_zm", false );
	include_weapon( "python_zm" );
	include_weapon( "python_upgraded_zm", false );
  	include_weapon( "cz75_zm" );
  	include_weapon( "cz75_upgraded_zm", false );

	//	Weapons - Semi-Auto Rifles
	include_weapon( "m14_zm", false );
	include_weapon( "m14_upgraded_zm", false );

	//	Weapons - Burst Rifles
	include_weapon( "m16_zm", false );						
	include_weapon( "m16_gl_upgraded_zm", false );
	include_weapon( "g11_lps_zm" );
	include_weapon( "g11_lps_upgraded_zm", false );
	include_weapon( "famas_zm" );
	include_weapon( "famas_upgraded_zm", false );

	//	Weapons - SMGs
	include_weapon( "ak74u_zm", false );
	include_weapon( "ak74u_upgraded_zm", false );
	include_weapon( "mp5k_zm", false );
	include_weapon( "mp5k_upgraded_zm", false );
	include_weapon( "mp40_zm", false );						
	include_weapon( "mp40_upgraded_zm", false );			
	include_weapon( "mpl_zm", false );
	include_weapon( "mpl_upgraded_zm", false );
	include_weapon( "pm63_zm", false );
	include_weapon( "pm63_upgraded_zm", false );
	include_weapon( "spectre_zm" );
	include_weapon( "spectre_upgraded_zm", false );

	//	Weapons - Dual Wield
  	include_weapon( "cz75dw_zm" );
  	include_weapon( "cz75dw_upgraded_zm", false );

	//	Weapons - Shotguns
	include_weapon( "ithaca_zm", false );
	include_weapon( "ithaca_upgraded_zm", false );
	include_weapon( "rottweil72_zm", false );
	include_weapon( "rottweil72_upgraded_zm", false );
	include_weapon( "spas_zm" );
	include_weapon( "spas_upgraded_zm", false );
	include_weapon( "hs10_zm" );
	include_weapon( "hs10_upgraded_zm", false );

	//	Weapons - Assault Rifles
	include_weapon( "aug_acog_zm" );
	include_weapon( "aug_acog_mk_upgraded_zm", false );
	include_weapon( "galil_zm" );
	include_weapon( "galil_upgraded_zm", false );
	include_weapon( "commando_zm" );
	include_weapon( "commando_upgraded_zm", false );
	include_weapon( "fnfal_zm" );
	include_weapon( "fnfal_upgraded_zm", false );

	//	Weapons - Sniper Rifles
	include_weapon( "dragunov_zm" );
	include_weapon( "dragunov_upgraded_zm", false );
	include_weapon( "l96a1_zm" );
	include_weapon( "l96a1_upgraded_zm", false );

	//	Weapons - Machineguns
	include_weapon( "rpk_zm" );
	include_weapon( "rpk_upgraded_zm", false );
	include_weapon( "hk21_zm" );
	include_weapon( "hk21_upgraded_zm", false );

	//	Weapons - Misc
	include_weapon( "m72_law_zm" );
	include_weapon( "m72_law_upgraded_zm", false );
	include_weapon( "china_lake_zm" );
	include_weapon( "china_lake_upgraded_zm", false );
	

	////////////////////
	//Special grenades//
	////////////////////
	include_weapon( "zombie_cymbal_monkey" );
	include_weapon( "emp_grenade_zm" );

	///////////////////
	//Special weapons//
	///////////////////
	include_weapon( "ray_gun_zm" );
	include_weapon( "ray_gun_upgraded_zm", false );
	include_weapon( "crossbow_explosive_zm" );
	include_weapon( "crossbow_explosive_upgraded_zm", false );
	precacheItem( "explosive_bolt_zm" );
	precacheItem( "explosive_bolt_upgraded_zm" );
	include_weapon( "thundergun_zm" );
	include_weapon( "thundergun_upgraded_zm", false );
	include_weapon( "jetgun_zm" );
	include_weapon( "jetgun_upgraded_zm", false );

	include_weapon( "riotshield_zm", true ); 

	include_weapon( "tazer_knuckles_zm" );
	include_weapon( "knife_ballistic_no_melee_zm", false );
	include_weapon( "knife_ballistic_no_melee_upgraded_zm", false );
	include_weapon( "knife_ballistic_zm" );
	include_weapon( "knife_ballistic_upgraded_zm", false );
	level._uses_retrievable_ballisitic_knives = true;

	// limited weapons
	add_limited_weapon( "m1911_zm", 0 );
	add_limited_weapon( "thundergun_zm", 1 );
	add_limited_weapon( "crossbow_explosive_zm", 1 );
	add_limited_weapon( "knife_ballistic_zm", 1 );
	//add_limited_weapon( "riotshield_zm", 1 );
	add_limited_weapon( "jetgun_zm", 1 );
	add_limited_weapon( "tazer_knuckles_zm", 1 );


	// get the bowie into the collector achievement list
//	ARRAY_ADD( level.collector_achievement_weapons, "bowie_knife_zm" );
}


custom_add_weapons()
{
	add_zombie_weapon( "m1911_zm",					"m1911_upgraded_zm",					&"ZOMBIE_WEAPON_M1911",					50,		"pistol",			"",		undefined );
	add_zombie_weapon( "python_zm",					"python_upgraded_zm",					&"ZOMBIE_WEAPON_PYTHON",				50,		"pistol",			"",		undefined );

	//SMGs
	add_zombie_weapon( "ak74u_zm",					"ak74u_upgraded_zm",					&"ZOMBIE_WEAPON_AK74U",					1200,	"smg",				"",		undefined );
	add_zombie_weapon( "mp5k_zm",					"mp5k_upgraded_zm",						&"ZOMBIE_WEAPON_MP5K",					1000,	"smg",				"",		undefined );

	//Shotguns
	add_zombie_weapon( "spas_zm",					"spas_upgraded_zm",						&"ZOMBIE_WEAPON_SPAS",					50,		"shotgun",			"",		undefined );
	add_zombie_weapon( "rottweil72_zm",				"rottweil72_upgraded_zm",				&"ZOMBIE_WEAPON_ROTTWEIL72",			500,	"shotgun",			"",		undefined );

	//Rifles
	add_zombie_weapon( "m14_zm",					"m14_upgraded_zm",						&"ZOMBIE_WEAPON_M14",					500,	"rifle",			"",		undefined );
	add_zombie_weapon( "m16_zm",					"m16_gl_upgraded_zm",					&"ZOMBIE_WEAPON_M16",					1200,	"burstrifle",		"",		undefined );
	add_zombie_weapon( "galil_zm",					"galil_upgraded_zm",					&"ZOMBIE_WEAPON_GALIL",					50,		"assault",			"",		undefined );
	add_zombie_weapon( "fnfal_zm",					"fnfal_upgraded_zm",					&"ZOMBIE_WEAPON_FNFAL",					50,		"burstrifle",		"",		undefined );

	//Grenades                                         		
	add_zombie_weapon( "frag_grenade_zm", 			undefined,								&"ZOMBIE_WEAPON_FRAG_GRENADE",			250,	"grenade",			"",		undefined );
	add_zombie_weapon( "sticky_grenade_zm", 		undefined,								&"ZOMBIE_WEAPON_STICKY_GRENADE",		250,	"grenade",			"",		undefined );
	add_zombie_weapon( "claymore_zm", 				undefined,								&"ZOMBIE_WEAPON_CLAYMORE",				1000,	"grenade",			"",		undefined );


	//Special                                          	
 	add_zombie_weapon( "zombie_cymbal_monkey",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"monkey",			"",		undefined );
	add_zombie_weapon( "emp_grenade_zm", 			undefined,								&"ZOMBIE_WEAPON_EMP_GRENADE",			2000,	"grenade",			"",		undefined );

 	add_zombie_weapon( "ray_gun_zm", 				"ray_gun_upgraded_zm",					&"ZOMBIE_WEAPON_RAYGUN", 				10000,	"raygun",			"",		undefined );
 	add_zombie_weapon( "crossbow_explosive_zm",		"crossbow_explosive_upgraded_zm",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_zm",		"knife_ballistic_upgraded_zm",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_bowie_zm",	"knife_ballistic_bowie_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_no_melee_zm","knife_ballistic_no_melee_upgraded_zm",&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );

	add_zombie_weapon( "riotshield_zm",				undefined,								&"ZOMBIE_WEAPON_RIOTSHIELD", 			2000,	"riot",				"",		undefined );

	add_zombie_weapon( "cz75_zm",					"cz75_upgraded_zm",						&"ZOMBIE_WEAPON_CZ75",					50,		"pistol",			"",		undefined );

	//SMGs
	add_zombie_weapon( "mp40_zm",					"mp40_upgraded_zm",						&"ZOMBIE_WEAPON_MP40",					1000,		"smg",				"",		undefined );
	add_zombie_weapon( "mpl_zm",					"mpl_upgraded_zm",						&"ZOMBIE_WEAPON_MPL",					1000,	"smg",				"",		undefined );
	add_zombie_weapon( "pm63_zm",					"pm63_upgraded_zm",						&"ZOMBIE_WEAPON_PM63",					1000,	"smg",				"",		undefined );
	add_zombie_weapon( "spectre_zm",				"spectre_upgraded_zm",					&"ZOMBIE_WEAPON_SPECTRE",				50,		"smg",				"",		undefined );

	//Dual Wield
	add_zombie_weapon( "cz75dw_zm",					"cz75dw_upgraded_zm",					&"ZOMBIE_WEAPON_CZ75DW",				50,		"dualwield",		"",		undefined );

	//Shotguns
	add_zombie_weapon( "ithaca_zm",					"ithaca_upgraded_zm",					&"ZOMBIE_WEAPON_ITHACA",				1500,	"shotgun",			"",		undefined );
	add_zombie_weapon( "hs10_zm",					"hs10_upgraded_zm",						&"ZOMBIE_WEAPON_HS10",					50,		"shotgun",			"",		undefined );

	//Burst Rifles
	add_zombie_weapon( "g11_lps_zm",				"g11_lps_upgraded_zm",					&"ZOMBIE_WEAPON_G11",					900,	"burstrifle",		"",		undefined );
	add_zombie_weapon( "famas_zm",					"famas_upgraded_zm",					&"ZOMBIE_WEAPON_FAMAS",					50,		"burstrifle",		"",		undefined );

	//Assault Rifles
	add_zombie_weapon( "aug_acog_zm",				"aug_acog_mk_upgraded_zm",				&"ZOMBIE_WEAPON_AUG",					1200,	"assault",			"",		undefined );
	add_zombie_weapon( "commando_zm",				"commando_upgraded_zm",					&"ZOMBIE_WEAPON_COMMANDO",				100,	"assault",			"",		undefined );

	//Sniper Rifles
	add_zombie_weapon( "dragunov_zm",				"dragunov_upgraded_zm",					&"ZOMBIE_WEAPON_DRAGUNOV",				2500,	"sniper",			"",		undefined );
	add_zombie_weapon( "l96a1_zm",					"l96a1_upgraded_zm",					&"ZOMBIE_WEAPON_L96A1",					50,		"sniper",			"",		undefined );

	//Machineguns
	add_zombie_weapon( "rpk_zm",					"rpk_upgraded_zm",						&"ZOMBIE_WEAPON_RPK",					4000,	"mg",				"",		undefined );
	add_zombie_weapon( "hk21_zm",					"hk21_upgraded_zm",						&"ZOMBIE_WEAPON_HK21",					50,		"mg",				"",		undefined );

	//Rocket Launchers
	add_zombie_weapon( "m72_law_zm", 				"m72_law_upgraded_zm",					&"ZOMBIE_WEAPON_M72_LAW",	 			2000,	"launcher",			"",		undefined ); 
	add_zombie_weapon( "china_lake_zm", 			"china_lake_upgraded_zm",				&"ZOMBIE_WEAPON_CHINA_LAKE", 			2000,	"launcher",			"",		undefined ); 

 	add_zombie_weapon( "thundergun_zm",				"thundergun_upgraded_zm",				&"ZOMBIE_WEAPON_THUNDERGUN", 			10,		"thunder",			"",		undefined );

	add_zombie_weapon( "jetgun_zm",					"jetgun_upgraded_zm",					&"ZOMBIE_WEAPON_JETGUN", 				2000,	"jet",				"",		undefined );

 	add_zombie_weapon( "tazer_knuckles_zm",			undefined,								&"ZOMBIE_WEAPON_TAZER_KNUCKLES", 		100,	"tazerknuckles",	"",		undefined );

}


//*****************************************************************************
// RiotShield Buildable
//*****************************************************************************

onBeginUse_RiotShield( player )
{
}

onCantUse_RiotShield( player )
{
}

onDrop_RiotShield( player )
{
}

onEndUse_RiotShield( team, player, result )
{
}

onPickup_RiotShield( player )
{
}

onUsePlantObject_RiotShield( player )
{
}



include_buildables()
{
	// RiotShield WallBuy
	//-------------------
	
	riotShield = SpawnStruct();
	riotShield.name = "riotshield_zm";
	riotShield create_zombie_buildable_piece( "t6_wpn_zmb_shield_dolly", 20, 64 );
	riotShield create_zombie_buildable_piece( "t6_wpn_zmb_shield_door", 32, 15 );
	riotShield.onBeginUse = ::onBeginUse_RiotShield;
	riotShield.onCantUse = ::onCantUse_RiotShield;
	riotShield.onDrop = ::onDrop_RiotShield;
	riotShield.onEndUse = ::onEndUse_RiotShield;
	riotShield.onPickup = ::onPickup_RiotShield;
	riotShield.onUsePlantObject = ::onUsePlantObject_RiotShield;
	
	include_buildable( riotShield );
}

include_equipment_for_level()
{
	include_equipment( "riotshield_zm" );
}

include_game_modules()
{
	 maps\mp\zombies\_zm_containment::register_game_module();
}