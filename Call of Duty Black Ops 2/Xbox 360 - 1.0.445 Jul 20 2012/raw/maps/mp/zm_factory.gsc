
/*
main()
{
	//needs to be first for create fx
	maps\mp\zm_factory_fx::main();

	maps\mp\_load::main();

	//maps\mp\zm_factory_amb::main();

	// used to modify the percentages of pulls of ray gun and tesla gun in magic box
	//level.pulls_since_last_ray_gun = 0;
	//level.pulls_since_last_tesla_gun = 0;
	//.player_drops_tesla_gun = false;

	//level.mixed_rounds_enabled = true;	// MM added support for mixed crawlers and dogs
	//level.burning_zombies = [];		//JV max number of zombies that can be on fire
	//level.zombie_rise_spawners = [];	// Zombie riser control
	//level.max_barrier_search_dist_override = 400;

	//level.door_dialog_function = maps\_zombiemode::play_door_dialog;
	//level.dog_spawn_func = maps\_zombiemode_ai_dogs::dog_spawn_factory_logic;

	// Animations needed for door initialization
	//script_anims_init();

	//level.zombie_anim_override = maps\mp\zm_factory::anim_override_func;

	// If the team nationalites change in this file, you must also update the level's csc file,
	// the level's csv file, and the share/raw/mp/mapsTable.csv
	//maps\mp\gametypes\_teamset_junglemarines::level_init();

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	level.giveCustomLoadout = ::giveCustomLoadout;
	level.precacheCustomCharacters = ::precacheCustomCharacters;
	level.giveCustomCharacters = ::giveCustomCharacters;
	initCharacterStartIndex();
	
	level._round_start_func = maps\mp\zombies\_zm::round_start;

	//precachestring(&"WAW_ZOMBIE_FLAMES_UNAVAILABLE");
	//precachestring(&"WAW_ZOMBIE_ELECTRIC_SWITCH");

	//precachestring(&"WAW_ZOMBIE_POWER_UP_TPAD");
	//precachestring(&"WAW_ZOMBIE_TELEPORT_TO_CORE");
	//precachestring(&"WAW_ZOMBIE_LINK_TPAD");
	//precachestring(&"WAW_ZOMBIE_LINK_ACTIVE");
	//precachestring(&"WAW_ZOMBIE_INACTIVE_TPAD");
	//precachestring(&"WAW_ZOMBIE_START_TPAD");

	//precacheshellshock("electrocution");
	//PreCacheModel("zombie_zapper_cagelight_red");
	//PreCacheModel("zombie_zapper_cagelight_green");
	//PreCacheModel("lights_indlight_on" );
	//precacheModel("lights_milit_lamp_single_int_on" );
	//precacheModel("lights_tinhatlamp_on" );
	//precacheModel("lights_berlin_subway_hat_0" );
	//precacheModel("lights_berlin_subway_hat_50" );
	//precacheModel("lights_berlin_subway_hat_100" );

	// DCS: not mature settings models without blood or gore.
	//PreCacheModel( "zombie_power_lever_handle" );

	//precachestring(&"WAW_ZOMBIE_BETTY_ALREADY_PURCHASED");
	//precachestring(&"WAW_ZOMBIE_BETTY_HOWTO");


	//ENABLE PACK-A-PUNCH
	level.zombiemode_using_pack_a_punch = true;

	//ENABLE PERKS
	level.zombiemode_using_doubletap_perk = true;
	level.zombiemode_using_juggernaut_perk = true;
	level.zombiemode_using_revive_perk = true;
	level.zombiemode_using_sleightofhand_perk = true;



	level._zombie_custom_add_weapons = ::custom_add_weapons;

	//Level specific stuff
	include_weapons();
	include_powerups();


	// Special zombie types, dogs.
	//level.dogs_enabled = true;	
	//level.custom_ai_type = [];
	//ARRAY_ADD( level.custom_ai_type, maps\_zombiemode_ai_dogs::init );
	//maps\_zombiemode_ai_dogs::enable_dog_rounds();

	//Init zombiemode scripts
	maps\mp\zombies\_zm::init();

	maps\mp\zombies\_zm_weap_tesla::init();
	maps\mp\zombies\_zm_weap_bowie::init();
	maps\mp\zombies\_zm_weap_cymbal_monkey::init();
	maps\mp\zombies\_zm_weap_claymore::init();
	maps\mp\zombies\_zm_weap_ballistic_knife::init();
	maps\mp\zombies\_zm_weap_crossbow::init();

	//init_achievement();
	level thread electric_switch();
	
	//DCS: need stop watch setup
	//maps\_zombiemode_timer::init();

	level.zones = [];
	level.zone_manager_init_func = ::factory_zone_init;
	init_zones[0] = "receiver_zone";
	level thread maps\mp\zombies\_zm_zonemgr::manage_zones( init_zones );

	teleporter_init();
	
	
	//level thread intro_screen();

	level thread jump_from_bridge();
	//level lock_additional_player_spawner();

	level thread bridge_init();
	
	//AUDIO EASTER EGGS
	level thread phono_egg_init( "phono_one", "phono_one_origin" );
	level thread phono_egg_init( "phono_two", "phono_two_origin" );
	level thread phono_egg_init( "phono_three", "phono_three_origin" );

	level.meteor_counter = 0;
	level thread meteor_egg( "meteor_one" );
	level thread meteor_egg( "meteor_two" );
	level thread meteor_egg( "meteor_three" );
	level thread radio_egg_init( "radio_one", "radio_one_origin" );
	level thread radio_egg_init( "radio_two", "radio_two_origin" );
	level thread radio_egg_init( "radio_three", "radio_three_origin" );
	level thread radio_egg_init( "radio_four", "radio_four_origin" );
	level thread radio_egg_init( "radio_five", "radio_five_origin" );
	//level thread radio_egg_hanging_init( "radio_five", "radio_five_origin" );
	level.monk_scream_trig = getent( "monk_scream_trig", "targetname" );
	level thread play_giant_mythos_lines();
	level thread play_level_easteregg_vox( "vox_corkboard_1" );
	level thread play_level_easteregg_vox( "vox_corkboard_2" );
	level thread play_level_easteregg_vox( "vox_corkboard_3" );
	level thread play_level_easteregg_vox( "vox_teddy" );
	level thread play_level_easteregg_vox( "vox_fieldop" );
	level thread play_level_easteregg_vox( "vox_telemap" );
	level thread play_level_easteregg_vox( "vox_maxis" );
	level thread play_level_easteregg_vox( "vox_illumi_1" );
	level thread play_level_easteregg_vox( "vox_illumi_2" );

	// DCS: mature and german safe settings.
	//level thread mature_settings_changes();

	// Check under the machines for change
	//trigs = GetEntArray( "audio_bump_trigger", "targetname" );
	//for ( i=0; i<trigs.size; i++ )
	//{
	//	if ( IsDefined(trigs[i].script_sound) && trigs[i].script_sound == "fly_bump_bottle" )
	//	{
	//		trigs[i] thread check_for_change();
	//	}
	//}

	//trigs = GetEntArray( "trig_ee", "targetname" );
	//array_thread( trigs, ::extra_events);

	//level thread flytrap();

	// Set the color vision set back
	//level.zombie_visionset = "zombie_factory";
	
	
	//VisionSetNaked( "zombie_factory", 0 );
	//SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	//SetSavedDvar( "r_lightGridIntensity", 1.45 );
	//SetSavedDvar( "r_lightGridContrast", 0.15 );

	//maps\mp\createart\zm_factory_art::main();
	
	//DCS: get betties working.
	//maps\_zombiemode_betty::init();	
	
}
*/

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zm_factory_teleporter;

#insert raw\common_scripts\utility.gsh;
//

main()
{
//needs to be first for create fx
	maps\mp\zm_factory_fx::main();
	maps\mp\zombies\_zm::init_fx();
	maps\mp\animscripts\zm_death::precache_gib_fx();//this really belongs in zm_load::main
	level.zombiemode = true;

	maps\mp\_load::main();
	
	// viewmodel arms for the level
//t6todo	PreCacheModel( "viewmodel_usa_pow_arms" ); // Dempsey
//t6todo	PreCacheModel( "viewmodel_rus_prisoner_arms" ); // Nikolai
//t6todo	PreCacheModel( "viewmodel_vtn_nva_standard_arms" );// Takeo
//t6todo	PreCacheModel( "viewmodel_usa_hazmat_arms" );// Richtofen

	// used to modify the percentages of pulls of ray gun and tesla gun in magic box
	level.pulls_since_last_ray_gun = 0;
	level.pulls_since_last_tesla_gun = 0;
	level.player_drops_tesla_gun = false;

	level.mixed_rounds_enabled = true;	// MM added support for mixed crawlers and dogs
	level.burning_zombies = [];		//JV max number of zombies that can be on fire
	level.zombie_rise_spawners = [];	// Zombie riser control
	level.max_barrier_search_dist_override = 400;

	level.door_dialog_function = maps\mp\zombies\_zm::play_door_dialog;
//t6todo	level.dog_spawn_func = maps\mp\zombies\_zm_ai_dogs::dog_spawn_factory_logic;

	// Animations needed for door initialization
	script_anims_init();

//t6todo	level thread maps\_callbacksetup::SetupCallbacks();
	
	level.zombie_anim_override = maps\mp\zm_factory::anim_override_func;
	//level.exit_level_func = ::factory_exit_level;

	//level.custom_zombie_vox = ::setup_custom_vox;


		// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	level.giveCustomLoadout = ::giveCustomLoadout;
	level.precacheCustomCharacters = ::precacheCustomCharacters;
	level.giveCustomCharacters = ::giveCustomCharacters;
	initCharacterStartIndex();
	
	level._round_start_func = maps\mp\zombies\_zm::round_start;




	SetDvar( "perk_altMeleeDamage", 1000 ); // adjusts how much melee damage a player with the perk will do, needs only be set once

	precachestring(&"ZOMBIE_NEED_POWER");
	precachestring(&"ZOMBIE_ELECTRIC_SWITCH");

	precachestring(&"ZOMBIE_POWER_UP_TPAD");
	precachestring(&"ZOMBIE_TELEPORT_TO_CORE");
	precachestring(&"ZOMBIE_LINK_TPAD");
	precachestring(&"ZOMBIE_LINK_ACTIVE");
	precachestring(&"ZOMBIE_INACTIVE_TPAD");
	precachestring(&"ZOMBIE_START_TPAD");

	precacheshellshock("electrocution");
	precachemodel("zombie_zapper_cagelight_red");
	precachemodel("zombie_zapper_cagelight_green");
	precacheModel("lights_indlight_on" );
	precacheModel("lights_milit_lamp_single_int_on" );
	precacheModel("lights_tinhatlamp_on" );
	precacheModel("lights_berlin_subway_hat_0" );
	precacheModel("lights_berlin_subway_hat_50" );
	precacheModel("lights_berlin_subway_hat_100" );

	// DCS: not mature settings models without blood or gore.
	PreCacheModel( "zombie_power_lever_handle" );

	precachestring(&"ZOMBIE_BETTY_ALREADY_PURCHASED");
	precachestring(&"ZOMBIE_BETTY_HOWTO");


	//ENABLE PACK-A-PUNCH
	level.zombiemode_using_pack_a_punch = true;

	//ENABLE PERKS
	level.zombiemode_using_doubletap_perk = true;
	level.zombiemode_using_juggernaut_perk = true;
	level.zombiemode_using_revive_perk = true;
	level.zombiemode_using_sleightofhand_perk = true;

	level._zombie_custom_add_weapons = ::custom_add_weapons;

	include_weapons();
	include_powerups();


	level._effect["zombie_grain"]			= LoadFx( "misc/fx_zombie_grain_cloud" );

//t6todo	maps\_waw_zombiemode_radio::init();	

//t6todo	level.zombiemode_precache_player_model_override = ::precache_player_model_override;
//t6todo	level.zombiemode_give_player_model_override = ::give_player_model_override;
//t6todo	level.zombiemode_player_set_viewmodel_override = ::player_set_viewmodel_override;
//t6todo	level.register_offhand_weapons_for_level_defaults_override = ::register_offhand_weapons_for_level_defaults_override;

	// Special zombie types, dogs.
//t6todo	level.dogs_enabled = true;	
//t6todo	level.custom_ai_type = [];
//t6todo	level.custom_ai_type = array_add( level.custom_ai_type, maps\_zombiemode_ai_dogs::init );
//t6todo	maps\_zombiemode_ai_dogs::enable_dog_rounds();

	level.use_zombie_heroes = true;

	//Init zombiemode scripts
	maps\mp\zombies\_zm::init();

	maps\mp\zombies\_zm_weap_tesla::init();
	maps\mp\zombies\_zm_weap_bowie::init();
	maps\mp\zombies\_zm_weap_cymbal_monkey::init();
	maps\mp\zombies\_zm_weap_claymore::init();
	maps\mp\zombies\_zm_weap_ballistic_knife::init();
	maps\mp\zombies\_zm_weap_crossbow::init();


	
	init_sounds();
	init_achievement();
	level thread power_electric_switch();
	
	level thread magic_box_init();

	//DCS: need stop watch setup
//t6todo	maps\_zombiemode_timer::init();

	//ESM - time for electrocuting
	thread init_elec_trap_trigs();


	level.zones = [];
	level.zone_manager_init_func = ::factory_zone_init;
	init_zones[0] = "receiver_zone";
	level thread maps\mp\zombies\_zm_zonemgr::manage_zones( init_zones );

	level.zombie_ai_limit = 24;


	teleporter_init();
	
	level thread intro_screen();

	level thread jump_from_bridge();
	level lock_additional_player_spawner();

	level thread bridge_init();
	
	//AUDIO EASTER EGGS
	level thread phono_egg_init( "phono_one", "phono_one_origin" );
	level thread phono_egg_init( "phono_two", "phono_two_origin" );
	level thread phono_egg_init( "phono_three", "phono_three_origin" );

    level.meteor_counter = 0;
	level thread meteor_egg( "meteor_one" );
	level thread meteor_egg( "meteor_two" );
	level thread meteor_egg( "meteor_three" );
	level thread radio_egg_init( "radio_one", "radio_one_origin" );
	level thread radio_egg_init( "radio_two", "radio_two_origin" );
	level thread radio_egg_init( "radio_three", "radio_three_origin" );
	level thread radio_egg_init( "radio_four", "radio_four_origin" );
	level thread radio_egg_init( "radio_five", "radio_five_origin" );
	//level thread radio_egg_hanging_init( "radio_five", "radio_five_origin" );
	level.monk_scream_trig = getent( "monk_scream_trig", "targetname" );
	level thread play_giant_mythos_lines();
	level thread play_level_easteregg_vox( "vox_corkboard_1" );
	level thread play_level_easteregg_vox( "vox_corkboard_2" );
	level thread play_level_easteregg_vox( "vox_corkboard_3" );
	level thread play_level_easteregg_vox( "vox_teddy" );
	level thread play_level_easteregg_vox( "vox_fieldop" );
	level thread play_level_easteregg_vox( "vox_telemap" );
	level thread play_level_easteregg_vox( "vox_maxis" );
	level thread play_level_easteregg_vox( "vox_illumi_1" );
	level thread play_level_easteregg_vox( "vox_illumi_2" );
	level thread setup_custom_vox();

	// DCS: mature and german safe settings.
	level thread factory_german_safe();
	level thread mature_settings_changes();


	// Special level specific settings
	set_zombie_var( "zombie_powerup_drop_max_per_round", 3 );	// lower this to make drop happen more often

	// Check under the machines for change
	trigs = GetEntArray( "audio_bump_trigger", "targetname" );
	for ( i=0; i<trigs.size; i++ )
	{
		if ( IsDefined(trigs[i].script_sound) && trigs[i].script_sound == "fly_bump_bottle" )
		{
			trigs[i] thread check_for_change();
		}
	}

	trigs = GetEntArray( "trig_ee", "targetname" );
	array_thread( trigs, ::extra_events);

	level thread flytrap();

	// Set the color vision set back
	level.zombie_visionset = "zombie_factory";
	
	
	VisionSetNaked( "zombie_factory", 0 );
//t6todo	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
//t6todo	SetSavedDvar( "r_lightGridIntensity", 1.45 );
//t6todo	SetSavedDvar( "r_lightGridContrast", 0.15 );

//t6todo	maps\createart\zombie_cod5_factory_art::main();
	
	//DCS: get betties working.
//t6todo	maps\_zombiemode_betty::init();	
	
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



precache_player_model_override()
{
	//t6todo mptype\player_t5_zm_theater::precache();
}

/* t6todo give_player_model_override( entity_num )
{
	if( IsDefined( self.zm_random_char ) )
	{
		entity_num = self.zm_random_char;
	}

	switch( entity_num )
	{
		case 0:
			character\c_usa_dempsey_zt::main();// Dempsy
			break;
		case 1:
			character\c_rus_nikolai_zt::main();// Nikolai
			break;
		case 2:
			character\c_jap_takeo_zt::main();// Takeo
			break;
		case 3:
			character\c_ger_richtofen_zt::main();// Richtofen
			break;	
	}
}

player_set_viewmodel_override( entity_num )
{
	switch( self.entity_num )
	{
		case 0:
			// Dempsey
			self SetViewModel( "viewmodel_usa_pow_arms" );
			break;
		case 1:
			// Nikolai
			self SetViewModel( "viewmodel_rus_prisoner_arms" );
			break;
		case 2:
			// Takeo
			self SetViewModel( "viewmodel_vtn_nva_standard_arms" );
			break;
		case 3:
			// Richtofen
			self SetViewModel( "viewmodel_usa_hazmat_arms" );
			break;		
	}
}

register_offhand_weapons_for_level_defaults_override()
{
	register_lethal_grenade_for_level( "stielhandgranate" );
	level.zombie_lethal_grenade_player_init = "stielhandgranate";

	register_tactical_grenade_for_level( "zombie_cymbal_monkey" );
	level.zombie_tactical_grenade_player_init = undefined;

	register_placeable_mine_for_level( "mine_bouncing_betty" );
	level.zombie_placeable_mine_player_init = undefined;

	register_melee_weapon_for_level( "knife_zm" );
	register_melee_weapon_for_level( "bowie_knife_zm" );
	level.zombie_melee_weapon_player_init = "knife_zm";
}*/

init_achievement()
{
	//include_achievement( "achievement_shiny" );
	//include_achievement( "achievement_monkey_see" );
	//include_achievement( "achievement_frequent_flyer" );
	//include_achievement( "achievement_this_is_a_knife" );
	//include_achievement( "achievement_martian_weapon" );
	//include_achievement( "achievement_double_whammy" );
	//include_achievement( "achievement_perkaholic" );
	//include_achievement( "achievement_secret_weapon", "zombie_kar98k_upgraded" );
	//include_achievement( "achievement_no_more_door" );
	//include_achievement( "achievement_back_to_future" );

}

//-------------------------------------------------------------------------------
//	Create the zone information for zombie spawning
//-------------------------------------------------------------------------------
factory_zone_init()
{
	// Note this setup is based on a flag-centric view of setting up your zones.  A brief
	//	zone-centric example exists below in comments

	// Outside East Door
	add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );

	// Outside West Door
	add_adjacent_zone( "receiver_zone",		"outside_west_zone",	"enter_outside_west" );

	// Wnuen building ground floor
	add_adjacent_zone( "wnuen_zone",		"outside_east_zone",	"enter_wnuen_building" );

	// Wnuen stairway
	add_adjacent_zone( "wnuen_zone",		"wnuen_bridge_zone",	"enter_wnuen_loading_dock" );

	// Warehouse bottom 
	add_adjacent_zone( "warehouse_bottom_zone", "outside_west_zone",	"enter_warehouse_building" );

	// Warehosue top
	add_adjacent_zone( "warehouse_bottom_zone", "warehouse_top_zone",	"enter_warehouse_second_floor" );
	add_adjacent_zone( "warehouse_top_zone",	"bridge_zone",			"enter_warehouse_second_floor" );

	// TP East
	add_adjacent_zone( "tp_east_zone",			"wnuen_zone",			"enter_tp_east" );
	
	add_adjacent_zone( "tp_east_zone",			"outside_east_zone",	"enter_tp_east",			true );
	add_zone_flags(	"enter_tp_east",										"enter_wnuen_building" );

	// TP South
	add_adjacent_zone( "tp_south_zone",			"outside_south_zone",	"enter_tp_south" );

	// TP West
	add_adjacent_zone( "tp_west_zone",			"warehouse_top_zone",	"enter_tp_west" );
	
	//add_adjacent_zone( "tp_west_zone",			"warehouse_bottom_zone", "enter_tp_west",		true );
	//add_zone_flags(	"enter_tp_west",										"enter_warehouse_second_floor" );
}


//
//	Intro Chyron!
intro_screen()
{

	flag_wait( "start_zombie_round_logic" );
	wait(2);
	level.intro_hud = [];
	for(i = 0;  i < 3; i++)
	{
		level.intro_hud[i] = newHudElem();
		level.intro_hud[i].x = 0;
		level.intro_hud[i].y = 0;
		level.intro_hud[i].alignX = "left";
		level.intro_hud[i].alignY = "bottom";
		level.intro_hud[i].horzAlign = "left";
		level.intro_hud[i].vertAlign = "bottom";
		level.intro_hud[i].foreground = true;

		if ( level.splitscreen && !level.hidef )
		{
			level.intro_hud[i].fontScale = 2.75;
		}
		else
		{
			level.intro_hud[i].fontScale = 1.75;
		}
		level.intro_hud[i].alpha = 0.0;
		level.intro_hud[i].color = (1, 1, 1);
		level.intro_hud[i].inuse = false;
	}
	level.intro_hud[0].y = -110;
	level.intro_hud[1].y = -90;
	level.intro_hud[2].y = -70;


	level.intro_hud[0] settext(&"ZOMBIE_INTRO_FACTORY_LEVEL_PLACE");
	level.intro_hud[1] settext("");
	level.intro_hud[2] settext("");
//	level.intro_hud[1] settext(&"ZOMBIE_INTRO_FACTORY_LEVEL_TIME");
//	level.intro_hud[2] settext(&"ZOMBIE_INTRO_FACTORY_LEVEL_DATE");

	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 1;
		wait(1.5);
	}
	wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] FadeOverTime( 3.5 ); 
		level.intro_hud[i].alpha = 0;
		wait(1.5);
	}	
	//wait(1.5);
	for(i = 0 ; i < 3; i++)
	{
		level.intro_hud[i] destroy();
	}
}


//-------------------------------------------------------------------
//	Animation functions - need to be specified separately in order to use different animtrees
//-------------------------------------------------------------------
//t6todo #using_animtree( "waw_zombie_factory" );
script_anims_init()
{
	//t6todolevel.scr_anim[ "half_gate" ]			= %o_zombie_lattice_gate_half;
	//t6todolevel.scr_anim[ "full_gate" ]			= %o_zombie_lattice_gate_full;
	//t6todolevel.scr_anim[ "difference_engine" ]	= %o_zombie_difference_engine_ani;

	//t6todolevel.blocker_anim_func = ::factory_playanim;
}

factory_playanim( animname )
{
//t6todo	self UseAnimTree(#animtree);
//t6todo	self animscripted("door_anim", self.origin, self.angles, level.scr_anim[animname] );
}


anim_override_func()
{
/*		level._zombie_melee[0] 				= %ai_zombie_attack_forward_v1; 
		level._zombie_melee[1] 				= %ai_zombie_attack_forward_v2; 
		level._zombie_melee[2] 				= %ai_zombie_attack_v1; 
		level._zombie_melee[3] 				= %ai_zombie_attack_v2;	
		level._zombie_melee[4]				= %ai_zombie_attack_v1;
		level._zombie_melee[5]				= %ai_zombie_attack_v4;
		level._zombie_melee[6]				= %ai_zombie_attack_v6;	

		level._zombie_run_melee[0]				=	%ai_zombie_run_attack_v1;
		level._zombie_run_melee[1]				=	%ai_zombie_run_attack_v2;
		level._zombie_run_melee[2]				=	%ai_zombie_run_attack_v3;

		level.scr_anim["zombie"]["run4"] 	= %ai_zombie_run_v2;
		level.scr_anim["zombie"]["run5"] 	= %ai_zombie_run_v4;
		level.scr_anim["zombie"]["run6"] 	= %ai_zombie_run_v3;

		level.scr_anim["zombie"]["walk5"] 	= %ai_zombie_walk_v6;
		level.scr_anim["zombie"]["walk6"] 	= %ai_zombie_walk_v7;
		level.scr_anim["zombie"]["walk7"] 	= %ai_zombie_walk_v8;
		level.scr_anim["zombie"]["walk8"] 	= %ai_zombie_walk_v9;
*/
}

lock_additional_player_spawner()
{
	
	spawn_points = getstructarray("player_respawn_point", "targetname");
	for( i = 0; i < spawn_points.size; i++ )
	{

			spawn_points[i].locked = true;

	}
}

//-------------------------------------------------------------------------------
// handles lowering the bridge when power is turned on
//-------------------------------------------------------------------------------
bridge_init()
{
	flag_init( "bridge_down" );
	// raise bridge
	wnuen_bridge = getent( "wnuen_bridge", "targetname" );
	wnuen_bridge_coils = GetEntArray( "wnuen_bridge_coils", "targetname" );
	for ( i=0; i<wnuen_bridge_coils.size; i++ )
	{
		wnuen_bridge_coils[i] LinkTo( wnuen_bridge );
	}
	wnuen_bridge rotatepitch( 90, 1, .5, .5 );

	warehouse_bridge = getent( "warehouse_bridge", "targetname" );
	warehouse_bridge_coils = GetEntArray( "warehouse_bridge_coils", "targetname" );
	for ( i=0; i<warehouse_bridge_coils.size; i++ )
	{
		warehouse_bridge_coils[i] LinkTo( warehouse_bridge );
	}
	warehouse_bridge rotatepitch( -90, 1, .5, .5 );
	
	bridge_audio = getstruct( "bridge_audio", "targetname" );

	// wait for power
	flag_wait( "power_on" );

	// lower bridge
	wnuen_bridge rotatepitch( -90, 4, .5, 1.5 );
	warehouse_bridge rotatepitch( 90, 4, .5, 1.5 );
	
	if(isdefined( bridge_audio ) )
		playsoundatposition( "bridge_lower", bridge_audio.origin );

	wnuen_bridge connectpaths();
	warehouse_bridge connectpaths();

	exploder( 500 );

	// wait until the bridges are down.
	wnuen_bridge waittill( "rotatedone" );
	
	flag_set( "bridge_down" );
	if(isdefined( bridge_audio ) )
		playsoundatposition( "bridge_hit", bridge_audio.origin );

	wnuen_bridge_clip = getent( "wnuen_bridge_clip", "targetname" );
	wnuen_bridge_clip delete();

	warehouse_bridge_clip = getent( "warehouse_bridge_clip", "targetname" );
	warehouse_bridge_clip delete();

	maps\mp\zombies\_zm_zonemgr::connect_zones( "wnuen_bridge_zone", "bridge_zone" );
	maps\mp\zombies\_zm_zonemgr::connect_zones( "warehouse_top_zone", "bridge_zone" );
}




jump_from_bridge()
{
	trig = GetEnt( "trig_outside_south_zone", "targetname" );
	trig waittill( "trigger" );

	maps\mp\zombies\_zm_zonemgr::connect_zones( "outside_south_zone", "bridge_zone", true );
	maps\mp\zombies\_zm_zonemgr::connect_zones( "outside_south_zone", "wnuen_bridge_zone", true );
}


init_sounds()
{
	maps\mp\zombies\_zm_utility::add_sound( "break_stone", "break_stone" );
	maps\mp\zombies\_zm_utility::add_sound( "gate_door",	"zmb_gate_slide_open" );
	maps\mp\zombies\_zm_utility::add_sound( "heavy_door",	"zmb_heavy_door_open" );

	// override the default slide with the buzz slide
	maps\mp\zombies\_zm_utility::add_sound("door_slide_open", "door_slide_open");
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

	///////////////////
	//Special weapons//
	///////////////////
	include_weapon( "ray_gun_zm" );
	include_weapon( "ray_gun_upgraded_zm", false );
	include_weapon( "crossbow_explosive_zm" );
	include_weapon( "crossbow_explosive_upgraded_zm", false );
	precacheItem( "explosive_bolt_zm" );
	precacheItem( "explosive_bolt_upgraded_zm" );
	include_weapon( "tesla_gun_zm" );
	include_weapon( "tesla_gun_upgraded_zm", false );

	include_weapon( "knife_ballistic_zm" );
	include_weapon( "knife_ballistic_upgraded_zm", false );
	include_weapon( "knife_ballistic_bowie_zm", false );
	include_weapon( "knife_ballistic_bowie_upgraded_zm", false );
	level._uses_retrievable_ballisitic_knives = true;

	// limited weapons
	add_limited_weapon( "m1911_zm", 0 );
	add_limited_weapon( "tesla_gun_zm", 1 );
	add_limited_weapon( "crossbow_explosive_zm", 1 );
	add_limited_weapon( "knife_ballistic_zm", 1 );

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

 	add_zombie_weapon( "ray_gun_zm", 				"ray_gun_upgraded_zm",					&"ZOMBIE_WEAPON_RAYGUN", 				10000,	"raygun",			"",		undefined );
 	add_zombie_weapon( "crossbow_explosive_zm",		"crossbow_explosive_upgraded_zm",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_zm",		"knife_ballistic_upgraded_zm",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_bowie_zm",	"knife_ballistic_bowie_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );

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

 	add_zombie_weapon( "tesla_gun_zm",				"tesla_gun_upgraded_zm",				&"ZOMBIE_WEAPON_TESLA", 				10,		"tesla",			"",		undefined );
}


factory_ray_gun_weighting_func()
{
	if( level.chest_moves > 0 )
	{	
		num_to_add = 1;
		// increase the percentage of ray gun
		if( isDefined( level.pulls_since_last_ray_gun ) )
		{
			// after 12 pulls the ray gun percentage increases to 15%
			if( level.pulls_since_last_ray_gun > 11 )
			{
				num_to_add += int(level.zombie_include_weapons.size*0.1);
			}			
			// after 8 pulls the Ray Gun percentage increases to 10%
			else if( level.pulls_since_last_ray_gun > 7 )
			{
				num_to_add += int(.05 * level.zombie_include_weapons.size);
			}		
		}
		return num_to_add;	
	}
	else
	{
		return 0;
	}
}


//
//	Slightly elevate the chance to get it until someone has it, then make it even
factory_cymbal_monkey_weighting_func()
{
	players = GET_PLAYERS();
	count = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] maps\mp\zombies\_zm_weapons::has_weapon_or_upgrade( "zombie_cymbal_monkey" ) )
		{
			count++;
		}
	}
	if ( count > 0 )
	{
		return 1;
	}
	else
	{
		if( level.round_number < 10 )
		{
			return 3;
		}
		else
		{
			return 5;
		}
	}
}


//
//	This initialitze the box spawn locations
//	You can disable boxes from appearing by not adding their script_noteworthy ID to the list
//
magic_box_init()
{
	//MM - all locations are valid.  If it goes somewhere you haven't opened, you need to open it.
	level.open_chest_location = [];
	level.open_chest_location[0] = "chest1";	// TP East
	level.open_chest_location[1] = "chest2";	// TP West
	level.open_chest_location[2] = "chest3";	// TP South
	level.open_chest_location[3] = "chest4";	// WNUEN
	level.open_chest_location[4] = "chest5";	// Warehouse bottom
	level.open_chest_location[5] = "start_chest";
}


/*------------------------------------
the electric switch under the bridge
once this is used, it activates other objects in the map
and makes them available to use
------------------------------------*/
power_electric_switch()
{
	trig = getent("use_power_switch","targetname");
	master_switch = getent("power_switch","targetname");	
	master_switch notsolid();
	//master_switch rotatepitch(90,1);
	trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	trig SetCursorHint( "HINT_NOICON" ); 
		
	//turn off the buyable door triggers for electric doors
// 	door_trigs = getentarray("electric_door","script_noteworthy");
// 	array_thread(door_trigs,::set_door_unusable);
// 	array_thread(door_trigs,::play_door_dialog);

	cheat = false;
	
/# 
	if( GetDvarInt( "zombie_cheat" ) >= 3 )
	{
		wait( 5 );
		cheat = true;
	}
#/	

	user = undefined;
	if ( cheat != true )
	{
		trig waittill("trigger",user);
	}
	
	// MM - turning on the power powers the entire map
// 	if ( IsDefined(user) )	// only send a notify if we weren't originally triggered through script
// 	{
// 		other_trig = getent("use_warehouse_switch","targetname");
// 		other_trig notify( "trigger", undefined );
// 
// 		wuen_trig = getent("use_wuen_switch", "targetname" );
// 		wuen_trig notify( "trigger", undefined );
// 	}

	master_switch rotateroll(-90,.3);

	//TO DO (TUEY) - kick off a 'switch' on client script here that operates similiarly to Berlin2 subway.
	master_switch playsound("zmb_switch_flip");
	flag_set( "power_on" );
	wait_network_frame();
	level notify( "sleight_on" );
	wait_network_frame();
	level notify( "revive_on" );
	wait_network_frame();
	level notify( "doubletap_on" );
	wait_network_frame();
	level notify( "juggernog_on" );
	wait_network_frame();
	level notify( "Pack_A_Punch_on" );
	wait_network_frame();
	level notify( "specialty_armorvest_power_on" );
	wait_network_frame();
	level notify( "specialty_rof_power_on" );
	wait_network_frame();
	level notify( "specialty_quickrevive_power_on" );
	wait_network_frame();
	level notify( "specialty_fastreload_power_on" );
	wait_network_frame();

//	clientnotify( "power_on" );
	clientnotify("ZPO");	// Zombie Power On!
	wait_network_frame();
	exploder(600);

	trig delete();	
	
	playfx(level._effect["switch_sparks"] ,getstruct("power_switch_fx","targetname").origin);

	// Don't want east or west to spawn when in south zone, but vice versa is okay
	maps\mp\zombies\_zm_zonemgr::connect_zones( "outside_east_zone", "outside_south_zone" );
	maps\mp\zombies\_zm_zonemgr::connect_zones( "outside_west_zone", "outside_south_zone", true );
}


/**********************
Electrical trap
**********************/
init_elec_trap_trigs()
{
	//trap_trigs = getentarray("gas_access","targetname");
	//array_thread (trap_trigs,::electric_trap_think);
	//array_thread (trap_trigs,::electric_trap_dialog);
	if ( level.mutators["mutator_noTraps"] )
	{
		maps\mp\zombies\_zm_traps::disable_traps(getentarray("warehouse_electric_trap",	"targetname"));
		maps\mp\zombies\_zm_traps::disable_traps(getentarray("wuen_electric_trap",	"targetname"));
		maps\mp\zombies\_zm_traps::disable_traps(getentarray("bridge_electric_trap",	"targetname"));
	}
	else
	{
		// MM - traps disabled for now
		array_thread( getentarray("warehouse_electric_trap",	"targetname"), ::electric_trap_think, "enter_warehouse_building" );
		array_thread( getentarray("wuen_electric_trap",			"targetname"), ::electric_trap_think, "enter_wnuen_building" );
		array_thread( getentarray("bridge_electric_trap",		"targetname"), ::electric_trap_think, "bridge_down" );
	}

}

electric_trap_dialog()
{

	self endon ("warning_dialog");
	level endon("switch_flipped");
	timer =0;
	while(1)
	{
		wait(0.5);
		players = GET_PLAYERS();
		for(i = 0; i < players.size; i++)
		{		
			dist = distancesquared(players[i].origin, self.origin );
			if(dist > 70*70)
			{
				timer = 0;
				continue;
			}
			if(dist < 70*70 && timer < 3)
			{
				wait(0.5);
				timer ++;
			}
			if(dist < 70*70 && timer == 3)
			{
				players[i] maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "intro" );
				wait(3);				
				self notify ("warning_dialog");
				//iprintlnbold("warning_given");
			}
		}
	}
}


hint_string( string )
{
	self SetHintString( string );
	self SetCursorHint( "HINT_NOICON" ); 
	
}


/*------------------------------------
	This controls the electric traps in the level
		self = use trigger associated with the trap
------------------------------------*/
electric_trap_think( enable_flag )
{	
	self sethintstring(&"ZOMBIE_NEED_POWER");
	self SetCursorHint( "HINT_NOICON" ); 
	
	self.zombie_cost = 1000;
	
	self thread electric_trap_dialog();

	// get a list of all of the other triggers with the same name
	triggers = getentarray( self.targetname, "targetname" );
	flag_wait( "power_on" );

	// Get the damage trigger.  This is the unifying element to let us know it's been activated.
	self.zombie_dmg_trig = getent(self.target,"targetname");
	self.zombie_dmg_trig.in_use = 0;

	// Set buy string
	self sethintstring(&"ZOMBIE_BUTTON_ACTIVATE_ELECTRIC");
	self SetCursorHint( "HINT_NOICON" ); 

	// Getting the light that's related is a little esoteric, but there isn't
	// a better way at the moment.  It uses linknames, which are really dodgy.
/*t6todo 	light_name = "";	// scope declaration
	tswitch = getent(self.script_linkto,"script_linkname");
	switch ( tswitch.script_linkname )
	{
	case "10":	// wnuen
	case "11":
		light_name = "zapper_light_wuen";	
		break;

	case "20":	// warehouse
	case "21":
		light_name = "zapper_light_warehouse";
		break;

	case "30":	// Bridge
	case "31":
		light_name = "zapper_light_bridge";
		break;
	}
*/
	light_name = "zapper_light_wuen";

	// The power is now on, but keep it disabled until a certain condition is met
	//	such as opening the door it is blocking or waiting for the bridge to lower.
	if ( !flag( enable_flag ) )
	{
		self trigger_off();

		zapper_light_red( light_name );
		flag_wait( enable_flag );

		self trigger_on();
	}

	// Open for business!  
	zapper_light_green( light_name );

	while(1)
	{

		// Set buy string
		array_thread(triggers, ::hint_string, &"ZOMBIE_BUTTON_ACTIVATE_ELECTRIC");

		//valve_trigs = getentarray(self.script_noteworthy ,"script_noteworthy");		
	
		//wait until someone uses the valve
		self waittill("trigger",who);
		if( who in_revive_trigger() )
		{
			continue;
		}
		
		if( is_player_valid( who ) )
		{
			if( who.score >= self.zombie_cost )
			{				
				if(!self.zombie_dmg_trig.in_use)
				{
					self.zombie_dmg_trig.in_use = 1;

					//turn off the valve triggers associated with this trap until available again
					//array_thread (triggers, ::trigger_off);

					array_thread( triggers, ::hint_string, &"ZOMBIE_TRAP_ACTIVE");


					play_sound_at_pos( "purchase", who.origin );
					self thread electric_trap_move_switch(self);
					//need to play a 'woosh' sound here, like a gas furnace starting up
					self waittill("switch_activated");
					//set the score
					who maps\mp\zombies\_zm_score::minus_to_player_score( self.zombie_cost );

					//this trigger detects zombies walking thru the flames
					self.zombie_dmg_trig trigger_on();

					//play the flame FX and do the actual damage
					self thread activate_electric_trap();					

					//wait until done and then re-enable the valve for purchase again
					self waittill("elec_done");
					
					clientnotify(self.script_string +"off");
										
					//delete any FX ents
					if(isDefined(self.fx_org))
					{
						self.fx_org delete();
					}
					if(isDefined(self.zapper_fx_org))
					{
						self.zapper_fx_org delete();
					}
					if(isDefined(self.zapper_fx_switch_org))
					{
						self.zapper_fx_switch_org delete();
					}

					array_thread(triggers, ::hint_string, &"ZOMBIE_TRAP_COOLDOWN");

					//turn the damage detection trigger off until the flames are used again
			 		self.zombie_dmg_trig trigger_off();
					wait(25);

					//array_thread (triggers, ::trigger_on);

					//COLLIN: Play the 'alarm' sound to alert players that the traps are available again (playing on a temp ent in case the PA is already in use.
					//speakerA = getstruct("loudspeaker", "targetname");
					//playsoundatposition("warning", speakera.origin);
					self notify("available");

					self.zombie_dmg_trig.in_use = 0;
				}
			}
		}
	}
}

//  it's a throw switch
electric_trap_move_switch(parent)
{
/* t6todo	light_name = "";	// scope declaration
	tswitch = getent(parent.script_linkto,"script_linkname");
	switch ( tswitch.script_linkname )
	{
	case "10":	// wnuen
	case "11":
		light_name = "zapper_light_wuen";	
		break;

	case "20":	// warehouse
	case "21":
		light_name = "zapper_light_warehouse";
		break;

	case "30":
	case "31":
		light_name = "zapper_light_bridge";
		break;
	}
*/
	light_name = "zapper_light_wuen";

	//turn the light above the door red
	zapper_light_red( light_name );
/* t6todo	tswitch rotatepitch(180,.5);
	tswitch playsound("amb_sparks_l_b");
	tswitch waittill("rotatedone");

	self notify("switch_activated");
	self waittill("available");
	tswitch rotatepitch(-180,.5);
*/
	//turn the light back green once the trap is available again
	zapper_light_green( light_name );
}

activate_electric_trap()
{
	if(isDefined(self.script_string) && self.script_string == "warehouse")
	{
		clientnotify("warehouse");
	}
	else if(isDefined(self.script_string) && self.script_string == "wuen")
	{
		clientnotify("wuen");
	}
	else
	{
		clientnotify("bridge");
	}	
		
	clientnotify(self.target);
	
	fire_points = getstructarray(self.target,"targetname");
	
	for(i=0;i<fire_points.size;i++)
	{
		wait_network_frame();
		fire_points[i] thread electric_trap_fx(self);		
	}
	
	//do the damage
	self.zombie_dmg_trig thread elec_barrier_damage();
	
	// reset the zapper model
	level waittill("arc_done");
}

electric_trap_fx(notify_ent)
{
	self.tag_origin = spawn("script_model",self.origin);
	//self.tag_origin setmodel("tag_origin");

	//playfxontag(level._effect["zapper"],self.tag_origin,"tag_origin");

	self.tag_origin playsound("zmb_elec_start");
	self.tag_origin playloopsound("zmb_elec_loop");
	self thread play_electrical_sound();
	
	wait(25);
		
	self.tag_origin stoploopsound();
		
	self.tag_origin delete(); 
	notify_ent notify("elec_done");
	level notify ("arc_done");	
}

play_electrical_sound()
{
	level endon ("arc_done");
	while(1)
	{	
		wait(randomfloatrange(0.1, 0.5));
		playsoundatposition("zmb_elec_arc", self.origin);
	}
	

}

elec_barrier_damage()
{	
	while(1)
	{
		self waittill("trigger",ent);
		
		//player is standing electricity, dumbass
		if(isplayer(ent) )
		{
			ent thread player_elec_damage();
		}
		else
		{
			if(!isDefined(ent.marked_for_death))
			{
				ent.marked_for_death = true;
				ent thread zombie_elec_death( randomint(100) );
			}
		}
	}
}
play_elec_vocals()
{
	if(IsDefined (self)) 
	{
		org = self.origin;
		wait(0.15);
		playsoundatposition("zmb_elec_vocals", org);
		playsoundatposition("zmb_zombie_arc", org);
		playsoundatposition("zmb_exp_jib_zombie", org);
	}
}
player_elec_damage()
{	
	self endon("death");
	self endon("disconnect");
	
	if(!IsDefined (level.elec_loop))
	{
		level.elec_loop = 0;
	}	
	
	if( !isDefined(self.is_burning) && !self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		self.is_burning = 1;		
		self setelectrified(1.25);	
		shocktime = 2.5;			
		//Changed Shellshock to Electrocution so we can have different bus volumes.
		self shellshock("electrocution", shocktime);
		
		if(level.elec_loop == 0)
		{	
			elec_loop = 1;
			//self playloopsound ("electrocution");
			self playsound("zmb_zombie_arc");
		}
		if(!self hasperk("specialty_armorvest") || self.health - 100 < 1)
		{
			
			radiusdamage(self.origin,10,self.health + 100,self.health + 100);
			self.is_burning = undefined;

		}
		else
		{
			self dodamage(50, self.origin);
			wait(.1);
			//self playsound("zombie_arc");
			self.is_burning = undefined;
		}


	}

}


zombie_elec_death(flame_chance)
{
	self endon("death");
	
	//10% chance the zombie will burn, a max of 6 burning zombs can be goign at once
	//otherwise the zombie just gibs and dies
	if(flame_chance > 90 && level.burning_zombies.size < 6)
	{
		level.burning_zombies[level.burning_zombies.size] = self;
		self thread zombie_flame_watch();
		self playsound("ignite");
		//t6todo self thread animscripts\zm_death::flame_death_fx();
		wait(randomfloat(1.25));		
	}
	else
	{
		
		refs[0] = "guts";
		refs[1] = "right_arm"; 
		refs[2] = "left_arm"; 
		refs[3] = "right_leg"; 
		refs[4] = "left_leg"; 
		refs[5] = "no_legs";
		refs[6] = "head";
		self.a.gib_ref = refs[randomint(refs.size)];

		playsoundatposition("zmb_zombie_arc", self.origin);
		if( !self.isdog && randomint(100) > 40 )
		{
			self thread electroctute_death_fx();
			self thread play_elec_vocals();
		}
		wait(randomfloat(1.25));
		self playsound("zmb_zombie_arc");
	}

	self dodamage(self.health + 666, self.origin);
	//iprintlnbold("should be damaged");
}

zombie_flame_watch()
{
	self waittill("death");
	self stoploopsound();
	level.burning_zombies = array_remove_nokeys(level.burning_zombies,self);
}


//
//	Swaps a cage light model to the red one.
zapper_light_red( lightname )
{
	zapper_lights = getentarray( lightname, "targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_red");	

		if(isDefined(zapper_lights[i].fx))
		{
			zapper_lights[i].fx delete();
		}

		zapper_lights[i].fx = maps\mp\zombies\_zm_net::network_safe_spawn( "trap_light_red", 2, "script_model", zapper_lights[i].origin );
		zapper_lights[i].fx setmodel("tag_origin");
		zapper_lights[i].fx.angles = zapper_lights[i].angles+(-90,0,0);
		playfxontag(level._effect["zapper_light_notready"],zapper_lights[i].fx,"tag_origin");
	}
}


//
//	Swaps a cage light model to the green one.
zapper_light_green( lightname )
{
	zapper_lights = getentarray( lightname, "targetname");
	for(i=0;i<zapper_lights.size;i++)
	{
		zapper_lights[i] setmodel("zombie_zapper_cagelight_green");	

		if(isDefined(zapper_lights[i].fx))
		{
			zapper_lights[i].fx delete();
		}

		zapper_lights[i].fx = maps\mp\zombies\_zm_net::network_safe_spawn( "trap_light_green", 2, "script_model", zapper_lights[i].origin );
		zapper_lights[i].fx setmodel("tag_origin");
		zapper_lights[i].fx.angles = zapper_lights[i].angles+(-90,0,0);
		playfxontag(level._effect["zapper_light_ready"],zapper_lights[i].fx,"tag_origin");
	}
}


//
//	
electroctute_death_fx()
{
	self endon( "death" );


	if (isdefined(self.is_electrocuted) && self.is_electrocuted )
	{
		return;
	}
	
	self.is_electrocuted = true;
	
	self thread electrocute_timeout();
		
	// JamesS - this will darken the burning body
	//self StartTanning(); 

	if(self.team == "axis")
	{
		level.bcOnFireTime = gettime();
		level.bcOnFireOrg = self.origin;
	}
	
	
	PlayFxOnTag( level._effect["elec_torso"], self, "J_SpineLower" ); 
	self playsound ("zmb_elec_jib_zombie");
	wait 1;

	tagArray = []; 
	tagArray[0] = "J_Elbow_LE"; 
	tagArray[1] = "J_Elbow_RI"; 
	tagArray[2] = "J_Knee_RI"; 
	tagArray[3] = "J_Knee_LE"; 
	tagArray = array_randomize( tagArray ); 

	PlayFxOnTag( level._effect["elec_md"], self, tagArray[0] ); 
	self playsound ("elec_jib_zombie");

	wait 1;
	self playsound ("zmb_elec_jib_zombie");

	tagArray[0] = "J_Wrist_RI"; 
	tagArray[1] = "J_Wrist_LE"; 
	if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
	{
		tagArray[2] = "J_Ankle_RI"; 
		tagArray[3] = "J_Ankle_LE"; 
	}
	tagArray = array_randomize( tagArray ); 

	PlayFxOnTag( level._effect["elec_sm"], self, tagArray[0] ); 
	PlayFxOnTag( level._effect["elec_sm"], self, tagArray[1] );

}

electrocute_timeout()
{
	self endon ("death");
	self playloopsound("amb_fire_manager_0");
	// about the length of the flame fx
	wait 12;
	self stoploopsound();
	if (isdefined(self) && isalive(self))
	{
		self.is_electrocuted = false;
		self notify ("stop_flame_damage");
	}
	
}

//*** AUDIO SECTION ***

check_for_change()
{
	while (1)
	{
		self waittill( "trigger", player );

		if ( player GetStance() == "prone" )
		{
			player maps\mp\zombies\_zm_score::add_to_player_score( 25 );
			play_sound_at_pos( "purchase", player.origin );
			break;
		}

		wait(0.1);
	}
}

extra_events()
{
	self UseTriggerRequireLookAt();
	self SetCursorHint( "HINT_NOICON" ); 
	self waittill( "trigger" );

	targ = GetEnt( self.target, "targetname" );
	if ( IsDefined(targ) )
	{
		targ MoveZ( -10, 5 );
	}
}


//
//	Activate the flytrap!
flytrap()
{
	flag_init( "hide_and_seek" );
	level.flytrap_counter = 0;

	// Hide Easter Eggs...
	// Explosive Monkey
	level thread hide_and_seek_target( "ee_exp_monkey" );
	wait_network_frame();
	level thread hide_and_seek_target( "ee_bowie_bear" );
	wait_network_frame();
	level thread hide_and_seek_target( "ee_perk_bear" );
	wait_network_frame();
	
	trig_control_panel = GetEnt( "trig_ee_flytrap", "targetname" );

	// Wait for it to be hit by an upgraded weapon
	upgrade_hit = false;
	while ( !upgrade_hit )
	{
		trig_control_panel waittill( "damage", amount, inflictor, direction, point, type );

		weapon = inflictor getcurrentweapon();
		if ( maps\mp\zombies\_zm_weapons::is_weapon_upgraded( weapon ) )
		{
			upgrade_hit = true;
		}
	}

	trig_control_panel playsound( "flytrap_hit" );
	playsoundatposition( "flytrap_creeper", trig_control_panel.origin );
	thread play_sound_2d( "sam_fly_laugh" );
	//iprintlnbold( "Samantha Sez: Hahahahahaha" );

	// Float the objects
//	level achievement_notify("DLC3_ZOMBIE_ANTI_GRAVITY");
	level ClientNotify( "ag1" );	// Anti Gravity ON
	wait(9.0);
	thread play_sound_2d( "sam_fly_act_0" );
	wait(6.0);
	
	thread play_sound_2d( "sam_fly_act_1" );
	//iprintlnbold( "Samantha Sez: Let's play Hide and Seek!" );

	//	Now find them!
	flag_set( "hide_and_seek" );

	flag_wait( "ee_exp_monkey" );
	flag_wait( "ee_bowie_bear" );
	flag_wait( "ee_perk_bear" );

	// Colin, play music here.
//	println( "Still Alive" );
}


//
//	Controls hide and seek object and trigger
hide_and_seek_target( target_name )
{
	flag_init( target_name );

	obj_array = GetEntArray( target_name, "targetname" );
	for ( i=0; i<obj_array.size; i++ )
	{
		obj_array[i] Hide();
	}

	trig = GetEnt( "trig_"+target_name, "targetname" );
	trig trigger_off();
	flag_wait( "hide_and_seek" );

	// Show yourself
	for ( i=0; i<obj_array.size; i++ )
	{
		obj_array[i] Show();
	}
	trig trigger_on();
	trig waittill( "trigger" );
	
	level.flytrap_counter = level.flytrap_counter +1;
	thread flytrap_samantha_vox();
	trig playsound( "object_hit" );

	for ( i=0; i<obj_array.size; i++ )
	{
		obj_array[i] Hide();
	}
	flag_set( target_name );
}

phono_egg_init( trigger_name, origin_name )
{
	if(!IsDefined (level.phono_counter))
	{
		level.phono_counter = 0;	
	}
	players = GET_PLAYERS();
	phono_trig = getent ( trigger_name, "targetname");
	phono_origin = getent( origin_name, "targetname");
	
	if( ( !isdefined( phono_trig ) ) || ( !isdefined( phono_origin ) ) )
	{
		return;
	}
	
	phono_trig UseTriggerRequireLookAt();
	phono_trig SetCursorHint( "HINT_NOICON" ); 
	
	for(i=0;i<players.size;i++)
	{			
		phono_trig waittill( "trigger", players);
		level.phono_counter = level.phono_counter + 1;
		phono_origin play_phono_egg();
	}	
}

play_phono_egg()
{
	if(!IsDefined (level.phono_counter))
	{
		level.phono_counter = 0;	
	}
	
	if( level.phono_counter == 1 )
	{
		//iprintlnbold( "Phono Egg One Activated!" );
		self playsound( "phono_one" );
	}
	if( level.phono_counter == 2 )
	{
		//iprintlnbold( "Phono Egg Two Activated!" );
		self playsound( "phono_two" );
	}
	if( level.phono_counter == 3 )
	{
		//iprintlnbold( "Phono Egg Three Activated!" );
		self playsound( "phono_three" );
	}
}

radio_egg_init( trigger_name, origin_name )
{
	players = GET_PLAYERS();
	radio_trig = getent( trigger_name, "targetname");
	radio_origin = getent( origin_name, "targetname");

	if( ( !isdefined( radio_trig ) ) || ( !isdefined( radio_origin ) ) )
	{
		return;
	}

	radio_trig UseTriggerRequireLookAt();
	radio_trig SetCursorHint( "HINT_NOICON" ); 
	radio_origin playloopsound( "radio_static" );

	for(i=0;i<players.size;i++)
	{			
		radio_trig waittill( "trigger", players);
		radio_origin stoploopsound( .1 );
		//iprintlnbold( "You activated " + trigger_name + ", playing off " + origin_name );
		radio_origin playsound( trigger_name );
	}	
}

play_music_easter_egg(player)
{
	level.music_override = true;
	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "egg" );
	
	wait(4);
	
	if( IsDefined( player ) )
	{
	    player maps\mp\zombies\_zm_audio::create_and_play_dialog( "eggs", "music_activate" );
	}
	
	wait(236);	
	level.music_override = false;
	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "wave_loop" );
}

meteor_egg(trigger_name)
{
	meteor_trig = getent ( trigger_name, "targetname");
	
	meteor_trig UseTriggerRequireLookAt();
	meteor_trig SetCursorHint( "HINT_NOICON" ); 
	meteor_trig PlayLoopSound( "zmb_meteor_loop" );
		
	meteor_trig waittill( "trigger", player );
	
	meteor_trig StopLoopSound( 1 );
	player PlaySound( "zmb_meteor_activate" );
	
	// no meterors in this level
	//player maps\_wawmp\zombies\_zm_audio::create_and_play_dialog( "eggs", "meteors", undefined, level.meteor_counter );
		
	level.meteor_counter = level.meteor_counter + 1;
	
	if( level.meteor_counter == 3 )
	{ 
	    level thread play_music_easter_egg( player );
	}
}

flytrap_samantha_vox()
{
	if(!IsDefined (level.flytrap_counter))
	{
		level.flytrap_counter = 0;	
	}

	if( level.flytrap_counter == 1 )
	{
		//iprintlnbold( "Samantha Sez: Way to go!" );
		thread play_sound_2d( "sam_fly_first" );
	}
	if( level.flytrap_counter == 2 )
	{
		//iprintlnbold( "Samantha Sez: Two? WOW!" );
		thread play_sound_2d( "sam_fly_second" );
	}
	if( level.flytrap_counter == 3 )
	{
		//iprintlnbold( "Samantha Sez: And GAME OVER!" );		
		thread play_sound_2d( "sam_fly_last" );
		return;
	}
	wait(0.05);
}

play_giant_mythos_lines()
{
	round = 5; 
	
	wait(10);
	while(1)
	{
		vox_rand = randomintrange(1,100);
		
		if( level.round_number <= round )
		{
			if( vox_rand <= 2 )
			{
				players = GET_PLAYERS();
				p = randomint(players.size);
				players[p] thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "gen_giant" );
				//iprintlnbold( "Just played Gen Giant line off of player " + p );
			}
		}
		else if (level.round_number > round )
		{
			return;
		}
		wait(randomintrange(60,240));
	}
}

play_level_easteregg_vox( object )
{
	percent = 35;
	
	trig = getent( object, "targetname" );
//	iprintlnbold ("trig = " + trig.targetname);
	if(!isdefined( trig ) )
	{
		return;
	}
	
	trig UseTriggerRequireLookAt();
	trig SetCursorHint( "HINT_NOICON" ); 
	
	while(1)
	{
		trig waittill( "trigger", who );
		
		vox_rand = randomintrange(1,100);
			
		if( vox_rand <= percent )
		{
	
			index = maps\mp\zombies\_zm_weapons::get_player_index(who);
			
			switch( object )
			{
				case "vox_corkboard_1":
	//				iprintlnbold( "Inside trigger " + object );
					who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "corkboard_1" );
					break;
				case "vox_corkboard_2":
	//				iprintlnbold( "Inside trigger " + object );
					who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "corkboard_2" );
					break;
				case "vox_corkboard_3":
	//				iprintlnbold( "Inside trigger " + object );
					who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "corkboard_3" );
					break;
				case "vox_teddy":
					if( index != 2 )
					{
						//iprintlnbold( "Inside trigger " + object );
						who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "teddy" );
					}
					break;
				case "vox_fieldop":
					if( (index != 1) && (index != 3) )
					{
						//iprintlnbold( "Inside trigger " + object );
						who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "fieldop" );
					}
					break;
				case "vox_maxis":
					if( index == 3 )
					{
						//iprintlnbold( "Inside trigger " + object );
						who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "maxis" );
					}
					break;
				case "vox_illumi_1":
					if( index == 3 )
					{
						//iprintlnbold( "Inside trigger " + object );
						who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "maxis" );
					}
					break;
				case "vox_illumi_2":
					if( index == 3 )
					{
						//iprintlnbold( "Inside trigger " + object );
						who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "maxis" );
					}
					break;
				default:
					return;
			}
		}
		else
		{
			who thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "level", "gen_sigh" );
		}
		wait(15);
	}
}

setup_custom_vox()
{
	wait(1);
//	iprintlnbold ("setting up custom vox");
	
	level.plr_vox["level"]["corkboard_1"] = "resp_corkmap";
	level.plr_vox["level"]["corkboard_2"] = "resp_corkmap";
	level.plr_vox["level"]["corkboard_3"] = "resp_corkmap";
	level.plr_vox["level"]["teddy"] = "resp_teddy";
	level.plr_vox["level"]["fieldop"] = "resp_fieldop";
	level.plr_vox["level"]["maxis"] = "resp_maxis";
	level.plr_vox["level"]["illumi_1"] = "resp_maxis";
	level.plr_vox["level"]["illumi_2"] = "resp_maxis";
	level.plr_vox["level"]["gen_sigh"] = "gen_sigh";
	level.plr_vox["level"]["gen_giant"] = "gen_giant";
	//level.plr_vox["level"]["audio_secret"] = "audio_secret";
	level.plr_vox["level"]["tele_linkall"] = "tele_linkall";
	level.plr_vox["level"]["tele_count"] = "tele_count";
	level.plr_vox["level"]["tele_help"] = "tele_help";
	level.plr_vox["level"]["perk_packa_see"] = "perk_packa_see";
	level.plr_vox["prefix"]	=	"vox_plr_";
}

//-------------------------------------------------------------------------------
// Solo Revive zombie exit points.
//-------------------------------------------------------------------------------
factory_exit_level()
{
	zombies = GetAiArray( "axis" );
	for ( i = 0; i < zombies.size; i++ )
	{
		zombies[i] thread factory_find_exit_point();
	}
}
factory_find_exit_point()
{
	self endon( "death" );

	player = GET_PLAYERS()[0];

	dist_zombie = 0;
	dist_player = 0;
	dest = 0;

	away = VectorNormalize( self.origin - player.origin );
	endPos = self.origin + VectorScale( away, 600 );

	locs = array_randomize( level.enemy_dog_locations );

	for ( i = 0; i < locs.size; i++ )
	{
		dist_zombie = DistanceSquared( locs[i].origin, endPos );
		dist_player = DistanceSquared( locs[i].origin, player.origin );

		if ( dist_zombie < dist_player )
		{
			dest = i;
			break;
		}
	}

	self notify( "stop_find_flesh" );
	self notify( "zombie_acquire_enemy" );

	self setgoalpos( locs[dest].origin );

	while ( 1 )
	{
		if ( !flag( "wait_and_revive" ) )
		{
			break;
		}
		wait_network_frame();
	}
	
	self thread maps\mp\zombies\_zm_spawner::find_flesh();
}

//-------------------------------------------------------------------------------
//	DCS: necessary changes for mature blood settings.
//-------------------------------------------------------------------------------
mature_settings_changes()
{
	if(!is_mature())
	{	
		master_switch = getent("power_switch","targetname");	
		if(IsDefined(master_switch))
		{
			master_switch SetModel("zombie_power_lever_handle");
		}	
	}	
}	
factory_german_safe()
{
	if(is_german_build())
	{
		dead_guy = GetEnt("hanging_dead_guy","targetname");
		dead_guy Hide();
	}	
}	