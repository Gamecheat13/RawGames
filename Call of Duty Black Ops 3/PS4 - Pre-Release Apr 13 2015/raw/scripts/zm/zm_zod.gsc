#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\name_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                                                                    	                                                                                     	                                                                                                                                                                                                                                                                                             	                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                         	                                                   
                                                                                       	                                
                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                 	                                                                                                                                                                          	                                                                                         	                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                               	                                                                                                                                                                                                                                              	                                                                                                                                           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                       	   	                                                                                                                                                                                                                                                                                                                         	                                                                                                                                                                                                                                      

#using scripts\zm\_load;
#using scripts\zm\_zm;
#using scripts\zm\_zm_ai_dogs;
#using scripts\zm\_zm_ai_raps;
#using scripts\zm\_zm_ai_wasp;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox_zod;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_timer;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weap_bouncingbetty;
#using scripts\zm\_zm_weap_bowie;
#using scripts\zm\_zm_weap_claymore;
#using scripts\zm\_zm_weap_cymbal_monkey;
#using scripts\zm\_zm_weap_glaive;
#using scripts\zm\_zm_weap_octobomb;
#using scripts\zm\_zm_weap_tesla;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#using scripts\zm\craftables\_zm_craftables;
#using scripts\zm\craftables\_zm_craft_shield;

//Perks
#using scripts\zm\_zm_pack_a_punch;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_perk_doubletap2;
#using scripts\zm\_zm_perk_juggernaut;
#using scripts\zm\_zm_perk_quick_revive;
#using scripts\zm\_zm_perk_sleight_of_hand;
#using scripts\zm\_zm_perk_staminup;
#using scripts\zm\_zm_perk_widows_wine;

//Powerups
#using scripts\zm\_zm_powerup_bonus_points_team;
#using scripts\zm\_zm_powerup_carpenter;
#using scripts\zm\_zm_powerup_double_points;
#using scripts\zm\_zm_powerup_fire_sale;
#using scripts\zm\_zm_powerup_full_ammo;
#using scripts\zm\_zm_powerup_insta_kill;
#using scripts\zm\_zm_powerup_nuke;

#using scripts\zm\archetype_zod_companion;

//Features
#using scripts\zm\zm_zod_craftables;
#using scripts\zm\zm_zod_fx;
#using scripts\zm\zm_zod_gamemodes;
#using scripts\zm\zm_zod_idgun_quest;
#using scripts\zm\zm_zod_beastcode;
#using scripts\zm\zm_zod_cleanup_mgr;
#using scripts\zm\zm_zod_octobomb_quest;
#using scripts\zm\zm_zod_pods;
#using scripts\zm\zm_zod_portals;
#using scripts\zm\zm_zod_poweronswitch;
#using scripts\zm\zm_zod_quest;
#using scripts\zm\zm_zod_robot;
#using scripts\zm\zm_zod_smashables;
#using scripts\zm\zm_zod_stairs;
#using scripts\zm\zm_zod_sword_quest;
#using scripts\zm\zm_zod_traps;
#using scripts\zm\zm_zod_train;
#using scripts\zm\zm_zod_transformer;
#using scripts\zm\zm_zod_util;
#using scripts\zm\_zm_altbody;
#using scripts\zm\_zm_altbody_beast;


#using scripts\shared\ai\zombie_utility;

#precache( "fx", "zombie/fx_glow_eye_orange" );
#precache( "fx", "zombie/fx_bul_flesh_head_fatal_zmb" );
#precache( "fx", "zombie/fx_bul_flesh_head_nochunks_zmb" );
#precache( "fx", "zombie/fx_bul_flesh_neck_spurt_zmb" );
#precache( "fx", "zombie/fx_blood_torso_explo_zmb" );
#precache( "fx", "trail/fx_trail_blood_streak" );
#precache( "fx", "electric/fx_elec_sparks_directional_orange" );

#precache( "string", "ZOMBIE_NEED_POWER" );
#precache( "string", "ZOMBIE_ELECTRIC_SWITCH" );
#precache( "model", "p7_zm_perk_bottle_broken_specialty_armorvest" );
#precache( "model", "p7_zm_perk_bottle_broken_specialty_staminup" );
#precache( "model", "p7_zm_perk_bottle_broken_specialty_fastreload" );
#precache( "model", "p7_zm_perk_bottle_broken_specialty_doubletap2" );


function autoexec opt_in()
{
	level.aat_in_use = true;
	level.bgb_in_use = true;
	level.randomize_perk_machine_location = true;
}

function gamemode_callback_setup()
{
	zm_zod_gamemodes::init();	// Moved to it's own file - for your patching pleasure.
}

#using_animtree( "generic" );

function setup_rex_starts()
{
	// populate the Gametype dropdown 
	zm_utility::add_gametype( "zclassic", &dummy, "zclassic", &dummy );

	// populate the Location dropdown
	zm_utility::add_gameloc( "default", &dummy, "default", &dummy );
}

function dummy()
{
}

function main()
{
	SetDvar( "zm_wasp_open_spawning", 1 );
	
	level.zod_character_names = [];
	array::add( level.zod_character_names, "boxer" );
	array::add( level.zod_character_names, "detective" );
	array::add( level.zod_character_names, "femme" );
	array::add( level.zod_character_names, "magician" );

	// flag used for making the idgun the next box pull	
	level flag::init( "idgun_up_for_grabs" );
	
	register_clientfields();

	// Callbacks
	callback::on_spawned( &on_player_spawned );

	level._uses_default_wallbuy_fx = 1;
	level._uses_sticky_grenades = 1;
	level._uses_taser_knuckles = 1;	
	level._no_vending_machine_auto_collision = 1;
	
	level.disable_kill_thread = true;
	
	zm::init_fx();
	zm_zod_fx::main();
	zm_ai_raps::init();
	zm_ai_wasp::init();
	
	level._effect["eye_glow"]				= "misc/fx_zombie_eye_single"; 
	level._effect["eye_glow"]				= "zombie/fx_glow_eye_orange";
	level._effect["headshot"]				= "zombie/fx_bul_flesh_head_fatal_zmb";
	level._effect["headshot_nochunks"]		= "zombie/fx_bul_flesh_head_nochunks_zmb";
	level._effect["bloodspurt"]				= "zombie/fx_bul_flesh_neck_spurt_zmb";

	level._effect["animscript_gib_fx"]		= "zombie/fx_blood_torso_explo_zmb"; 
	level._effect["animscript_gibtrail_fx"]	= "trail/fx_trail_blood_streak"; 	
	level._effect["switch_sparks"]			= "electric/fx_elec_sparks_directional_orange";

	//Setup game mode defaults
	level.default_start_location = "start_room";	
	level.default_game_mode = "zclassic";	

	level.zm_disable_recording_stats = true;

	level.giveCustomLoadout =&giveCustomLoadout;
	level.precacheCustomCharacters =&precacheCustomCharacters;
	level.giveCustomCharacters =&giveCustomCharacters;
	initCharacterStartIndex();

	//Weapons and Equipment
	level.register_offhand_weapons_for_level_defaults_override = &offhand_weapon_overrride;
	level.zombiemode_offhand_weapon_give_override = &offhand_weapon_give_override;


	level._zombie_custom_add_weapons =&custom_add_weapons;
	level thread custom_add_vox();
	level._allow_melee_weapon_switching = 1;
	level.zombiemode_reusing_pack_a_punch = true;


	level.closest_player_override = &closest_player_override;

	//Level specific stuff
	include_weapons();
	magic_box_init();

	level thread zm_zod_util::check_solo_status();

	level.using_solo_revive = false;
	level._custom_perks[ "specialty_quickrevive" ].cost = &revive_cost_override;

	
	// Craftables
	zm_craftables::init();
	zm_zod_craftables::randomize_craftable_spawns();
	zm_zod_craftables::include_craftables();
	zm_zod_craftables::init_craftables();
	
	load::main();

		
	//New movement
	SetDvar( "doublejump_enabled", 1 );
	SetDvar( "playerEnergy_enabled", 1 );
	SetDvar( "wallrun_enabled", 1 );
	
	//make target reacquisition faster on the robot companion
	SetDvar( "ai_threatUpdateInterval", 50);

	//_zm_weap_ballistic_knife::init();
	_zm_weap_bowie::init();
	//_zm_weap_crossbow::init();
	_zm_weap_cymbal_monkey::init();
	_zm_weap_octobomb::init();
	_zm_weap_tesla::init();

	// setup functions to let us add weapons to the magic box
	level.CustomRandomWeaponWeights = &zod_custom_weapon_weights; 
	level.special_weapon_magicbox_check = &zod_special_weapon_magicbox_check;

	level._round_start_func = &zm::round_start;

	init_sounds();
	
	zm_ai_raps::enable_raps_rounds();
	zm_ai_wasp::enable_wasp_rounds();

	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func =&zm_zod_zone_init;
	init_zones[0] = "zone_start";
	level thread zm_zonemgr::manage_zones( init_zones );
	
	level.zombie_ai_limit = 24;
	
	// TRAPS
	level thread zm_zod_traps::init_traps();
	// QUEST
	level thread zm_zod_quest::start_zod_quest();
	// OCTOBOMB QUEST
	level thread zm_zod_octobomb_quest::start_zod_octobomb_quest();
	
	level thread setupMusic();
	
	level._powerup_grab_check = &powerup_can_player_grab;
	zm_powerups::powerup_remove_from_regular_drops( "bonus_points_team" );

	// BEAST MODE
	level thread beast_mode();
	// POWER-UPS
	level thread placed_powerups();
	level thread wait_for_revive_machine_to_be_turned_on();

	weather_setup();

	level thread zm_zod_robot::init();
	level thread zm_zod_beastcode::init();
	level thread watch_for_world_transformation(); // handle transformation into the alien world when the time is right...
	// Initial lighting state
	level thread util::set_lighting_state( 0 );

}

function private FindClosest( origin, entities )
{
	closest = SpawnStruct();

	if ( entities.size > 0 )
	{
		closest.distanceSquared = DistanceSquared( origin, entities[0].origin );
		closest.entity = entities[0];
		
		for ( index = 1; index < entities.size; index++ )
		{
			distanceSquared = DistanceSquared( origin, entities[index].origin );
			
			if ( distanceSquared < closest.distanceSquared )
			{
				closest.distanceSquared = distanceSquared;
				closest.entity = entities[index];
			}
		}
	}
	
	return closest;
}

function closest_player_override( origin, players )
{
	//Ok return closest player - or AIplayer = array::get_closest( origin, players );	
	player = array::get_closest( origin, players );


	ai = GetActorTeamArray( "allies" );
	foreach( index, value in ai )
	{
		if( value.allow_zombie_to_target_ai === true )
		{
			dist2player = DistanceSquared( origin, player.origin );
			dist2robot = DistanceSquared( origin, value.origin );

			if ( dist2robot < dist2player )
				return value;
		}
	}

	return player;
		
	
	
	/*

	// Add AI's that are on different teams.	
	aiEnemies = [];
	ai = GetActorArray();
	foreach( index, value in ai )
	{
		// Throw out other AI's that are outside the entity's goalheight.
		// This prevents considering enemies on other floors.
		if ( value.team != level.zombie_team && value.allow_zombie_to_target_ai === true )//&& IsActor( value ) && !IsDefined( entity.favoriteenemy ) )
		{
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh( value.origin, 200 );
		
			if( IsDefined( enemyPositionOnNavMesh ) )
			{
				aiEnemies[aiEnemies.size] = value;
			}
		}
	}

	closestPlayer = FindClosest( origin, players );
	closestAI = FindClosest( origin, aiEnemies );

	if ( !IsDefined( closestPlayer.entity ) && !IsDefined( closestAI.entity ) )
	{
		// No player or actor to choose, bail out.
		return undefined;
	}
	else if ( !IsDefined( closestAI.entity ) )
	{
		// Only has a player to choose.
		return closestPlayer.entity;
	}
	else if ( !IsDefined( closestPlayer.entity ) )
	{
		// Only has an AI to choose.
		closestAI.entity.last_valid_position = closestAI.entity.origin;
		return closestAI.entity;
	}
	else if ( closestAI.distanceSquared < closestPlayer.distanceSquared )
	{
		// AI is closer than a player, time for additional checks.
		closestAI.entity.last_valid_position = closestAI.entity.origin;
		return closestAI.entity;
	}
	else
	{
		// Player is closer, choose them.
		return closestPlayer.entity;
	}*/
}

function wait_for_revive_machine_to_be_turned_on()
{
	level waittill( "specialty_quickrevive_power_on" );
	level flag::init( "solo_revive" );
	level.override_use_solo_revive = &zod_use_solo_revive;
}

function zod_use_solo_revive()
{
	players = GetPlayers();
	solo_mode = 0;
	if ( players.size == 1 || ( isdefined( level.force_solo_quick_revive ) && level.force_solo_quick_revive ) )
	{
		solo_mode = 1;
	}
	level.using_solo_revive = solo_mode;
	return solo_mode;
}


function revive_cost_override()
{
	solo = use_solo_revive_price();
	
	if( solo )
	{
		return 500;
	}
	else
	{
		return 1500;
	}	
}


function use_solo_revive_price()
{
	// TODO: lock out games with potential hotjoins
	if (isdefined(level.using_solo_revive_price))
		return level.using_solo_revive_price;
		
	players = GetPlayers();
	solo_mode = 0;
	if ( players.size == 1 || ( isdefined( level.force_solo_quick_revive ) && level.force_solo_quick_revive ) )
	{
		solo_mode = 1;
	}
	level.using_solo_revive_price = solo_mode;
	return solo_mode;
}

function on_player_spawned()
{
	self thread player_rain_fx();
	
	self AllowWallRun( false );
}


function register_clientfields()
{
	// rain
	clientfield::register( "toplayer",	"fullscreen_rain_fx",		1, 1, "int" );
	
	// show or hide the red weeds in the world after the world-transformation (end of the Pack-a-Punch quest)
	clientfield::register( "world",		"show_hide_pap_weed",		1, 1, "int" );
	
	// apothicon god animation and show/hide states
	n_bits = GetMinBitCountForNum( 4 );
	clientfield::register( "world", 	"god_state",				1, n_bits, "int" );
	
	// player rumble and camera shake controller	
	n_bits = GetMinBitCountForNum( 6 );
	clientfield::register( "toplayer", "player_rumble_and_shake",	1, n_bits, "int" );
}


//	Play rain on the Player
//	self is a player
function player_rain_fx()
{
	self endon( "death" );
	wait( 0.5 );
	
	self.b_rain_on = true;
	self clientfield::set_to_player( "fullscreen_rain_fx", 1 );
	
	/*
	delay = 0.05;	// scope
	while( true )
	{
		if ( self.b_rain_on )
		{
//			PlayFX( level._effect[ "rain_light" ], self.origin );
//			PlayFX( level._effect[ "rain_medium" ], self.origin );
			PlayFX( level._effect[ "rain_heavy" ], self.origin );
			delay = 0.1;
		}
		else
		{
			delay = 0.05;
		}
		
		wait( delay );
	}
	*/
}


function weather_setup()
{
	//run through all of the doorway triggers 
	a_trig_rain_outdoor = GetEntArray( "trig_rain_indoor", "targetname" );
	foreach( e_trig in a_trig_rain_outdoor )
	{
		e_trig thread monitor_outdoor_rain_doorways();
	}
}


//	Turn off rain indoors
function monitor_outdoor_rain_doorways()
{
	while ( 1 )
	{
		self waittill( "trigger", e_player );
		
		if ( ( isdefined( e_player.b_rain_on ) && e_player.b_rain_on ) )
		{
			e_player thread pause_rain_overlay( self );
		}
	}
}

function pause_rain_overlay( e_trig )
{
	self endon( "disconnect" );
	
	self.b_rain_on = false;
	self clientfield::set_to_player( "fullscreen_rain_fx", 0 );	

	util::wait_till_not_touching( e_trig, self );
	
	self.b_rain_on = true;
	self clientfield::set_to_player( "fullscreen_rain_fx", 1 );	
}



// no powerups in beast mode
function powerup_can_player_grab( player )
{
	//if ( IS_TRUE(player.beastmode) )
	//	return false;
	
	return true;
}

function beast_mode()
{
	beast_mode_highlights();
}

function beast_mode_highlights()
{
	things = GetEntArray( "grapple_target", "targetname" );
	foreach( thing in things )
	{
		thing clientfield::set("bminteract",1);
	}
}

function placed_powerups()
{
	zm_powerups::powerup_round_start();
	
	a_bonus_types = [];
	array::add( a_bonus_types, "double_points" );
	array::add( a_bonus_types, "insta_kill" );
	array::add( a_bonus_types, "full_ammo" );
	
	a_bonus = struct::get_array( "placed_powerup", "targetname" );
	foreach( s_bonus in a_bonus )
	{
		str_type = array::random( a_bonus_types );
		spawn_infinite_powerup_drop( s_bonus.origin, str_type );
	}
}

function spawn_infinite_powerup_drop( v_origin, str_type )
{
	level._powerup_timeout_override = &powerup_infinite_time;
	if( IsDefined( str_type ) )
	{
		intro_powerup = zm_powerups::specific_powerup_drop( str_type, v_origin );
	}
	else
	{
		intro_powerup = zm_powerups::powerup_drop( v_origin );
	}
	level._powerup_timeout_override = undefined;
}

function powerup_infinite_time()
{
	// dummy override function
}

function init_sounds()
{
	zm_utility::add_sound( "break_stone", "evt_break_stone" );
	zm_utility::add_sound( "gate_door",	"zmb_gate_slide_open" );
	zm_utility::add_sound( "heavy_door",	"zmb_heavy_door_open" );

	// override the default slide with the buzz slide
	zm_utility::add_sound("zmb_heavy_door_open", "zmb_heavy_door_open");
}



//
//	This initialitze the box spawn locations
function magic_box_init()
{
	level.random_pandora_box_start = true;
	
	// custom magic box init
	zm_magicbox_zod::init();
}

function offhand_weapon_overrride()
{
	zm_utility::register_lethal_grenade_for_level( "frag_grenade" );
	level.zombie_lethal_grenade_player_init = GetWeapon( "frag_grenade" );

	//zm_utility::register_placeable_mine_for_level( "claymore" );
	zm_utility::register_tactical_grenade_for_level( "cymbal_monkey" );
	zm_utility::register_tactical_grenade_for_level( "emp_grenade" );
	zm_utility::register_tactical_grenade_for_level( "octobomb" );

	zm_utility::register_melee_weapon_for_level( level.weaponBaseMelee.name );
	zm_utility::register_melee_weapon_for_level( "bowie_knife" );
	zm_utility::register_melee_weapon_for_level( "tazer_knuckles" );
	level.zombie_melee_weapon_player_init = level.weaponBaseMelee;
	
	level.zombie_equipment_player_init = undefined;
}

function offhand_weapon_give_override( str_weapon )
{
	self endon( "death" );
	
	if( zm_utility::is_tactical_grenade( str_weapon ) && IsDefined( self zm_utility::get_player_tactical_grenade() ) && !self zm_utility::is_player_tactical_grenade( str_weapon )  )
	{
		self SetWeaponAmmoClip( self zm_utility::get_player_tactical_grenade(), 0 );
		self TakeWeapon( self zm_utility::get_player_tactical_grenade() );
	}
	return false;
}


function zm_zod_beastpath( triggername, platformname)
{
	beast_connect_triggers = GetEntArray( triggername, "targetname" );
	array::thread_all( beast_connect_triggers, &activate_beast_platforms, platformname );
}

function activate_beast_platforms( platformname ) // self == fan from the array
{
	beast_connect_platforms = GetEntArray( platformname, "targetname" );

	for( i=0; i<beast_connect_platforms.size; i++ )
	{
		//Hide them all
		beast_connect_platforms[i] Hide();
	}

	self waittill( "trigger" );

	for( i=0; i<beast_connect_platforms.size; i++ )
	{
		//Show them all
		beast_connect_platforms[i] Show();
		beast_connect_platforms[i] ConnectPaths();
		beast_connect_platforms[i] SetMovingPlatformEnabled( true );
	}
}


//	ZOD zone specification.
//	NOTE: The zones are all setup using one-way connections.  While it may seem unnecessary and more maintenance,
//		it's actually a good way to understand exactly which zones are connected to any one particular zone.
function zm_zod_zone_init()
{
	level flag::init( "always_on" );
	level flag::set( "always_on" );

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	START ALLEY
	
	zm_zonemgr::add_adjacent_zone( "zone_start",				"zone_junction_start",		"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_start",				"zone_start_high",			"connect_start_to_magician",	true ); 		//this is activated when the power stairs are lowered
	
	//	zone_start_high
	zm_zonemgr::add_adjacent_zone( "zone_start_high",			"zone_start",				"connect_start_to_magician",	true ); 		//this is activated when the power stairs are lowered
	zm_zonemgr::add_adjacent_zone( "zone_start_high",			"zone_magician",			"connect_start_to_magician",	true ); 		//this is activated when the power stairs are lowered

	//	zone_magician - Magician ritual
	zm_zonemgr::add_adjacent_zone( "zone_magician",				"zone_start_high",			"connect_start_to_magician",	true );
	
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	JUNCTION

	//	zone_junction_start
	zm_zonemgr::add_adjacent_zone( "zone_junction_start",		"zone_junction_canal",		"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_start",		"zone_junction_slums",		"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_start",		"zone_junction_theater",	"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_start",		"zone_start",				"connect_start_to_junction",	true );
	
	// zone_junction_slums
	zm_zonemgr::add_adjacent_zone( "zone_junction_slums",		"zone_junction_start",		"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_slums",		"zone_junction_canal",		"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_slums",		"zone_junction_theater",	"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_slums",		"zone_slums_junction",		"connect_slums_to_junction",	true );
	
	// zone_junction_canal
	zm_zonemgr::add_adjacent_zone( "zone_junction_canal",		"zone_junction_start",		"connect_start_to_junction", 	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_canal",		"zone_junction_slums",		"connect_start_to_junction", 	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_canal",		"zone_junction_theater",	"connect_start_to_junction", 	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_canal",		"zone_canal_junction",		"connect_canal_to_junction", 	true );

	// zone_junction_theater
	zm_zonemgr::add_adjacent_zone( "zone_junction_theater",		"zone_junction_canal",		"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_theater",		"zone_junction_start",		"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_theater",		"zone_junction_slums",		"connect_start_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_junction_theater",		"zone_theater_junction",	"connect_theater_to_junction",	true );

	

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Canal District finger

	// zone_canal_junction - adj. to junction
	zm_zonemgr::add_adjacent_zone( "zone_canal_junction",			"zone_junction_canal",		"connect_canal_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_junction",			"zone_canal_A",				"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_junction",			"zone_canal_B",				"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_junction",			"zone_canal_high_A",		"connect_canal_high_to_low",	true );
	
	// zone_canal_A - southwest canal
	zm_zonemgr::add_adjacent_zone( "zone_canal_A",					"zone_canal_junction",		"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_A",					"zone_canal_B",				"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_A",					"zone_canal_C",				"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_A",					"zone_canal_water_A",		"activate_canal",				true );
	
	// zone_canal_B - central canal
	zm_zonemgr::add_adjacent_zone( "zone_canal_B",					"zone_canal_junction",		"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_B",					"zone_canal_A",				"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_B",					"zone_canal_water_A",		"activate_canal",				true );

	// zone_canal_C - northeast canal
	zm_zonemgr::add_adjacent_zone( "zone_canal_C",					"zone_canal_junction",		"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_C",					"zone_canal_B",				"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_C",					"zone_canal_D",				"connect_canal_to_train",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_C",					"zone_canal_E",				"connect_canal_to_train",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_C",					"zone_canal_water_B",		"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_C",					"zone_canal_water_C",		"activate_canal",				true );

	// zone_canal_D - west of Brothel
	zm_zonemgr::add_adjacent_zone( "zone_canal_D",					"zone_canal_C",				"connect_canal_to_train",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_D",					"zone_canal_E",				"activate_brothel_street",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_D",					"zone_canal_train",			"activate_brothel_street",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_D",					"zone_canal_high_C",		"connect_canal_high_to_train",	true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_D",					"zone_brothel",				"connect_canal_to_brothel",		true );

	// zone_canal_E - east of Brothel
	zm_zonemgr::add_adjacent_zone( "zone_canal_E",					"zone_canal_C",				"connect_canal_to_train",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_E",					"zone_canal_D",				"activate_brothel_street",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_E",					"zone_canal_train",			"activate_brothel_street",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_E",					"zone_canal_high_C",		"connect_canal_high_to_train",	true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_E",					"zone_brothel",				"connect_canal_to_brothel",		true );

	// zone_canal_train
	zm_zonemgr::add_adjacent_zone( "zone_canal_train",				"zone_canal_C",				"connect_canal_to_brothel",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_train",				"zone_canal_D",				"activate_brothel_street",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_train",				"zone_canal_E",				"activate_brothel_street",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_train",				"zone_canal_high_C",		"connect_canal_high_to_train",	true );

		
	// zone_canal_water_A - south canal water-level
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_A",			"zone_canal_water_B",		"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_A",			"zone_canal_water_C",		"activate_canal",				true );
		
	// zone_canal_water_B - central canal water-level
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_B",			"zone_canal_water_A",		"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_B",			"zone_canal_water_C",		"activate_canal",				true );
		
	// zone_canal_water_C - north canal water-level
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_C",			"zone_canal_water_A",		"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_C",			"zone_canal_water_B",		"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_C",			"zone_canal_C",				"activate_canal",				true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_C",			"zone_canal_D",				"connect_canal_to_train",		true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_water_C",			"zone_canal_E",				"connect_canal_to_train",		true );

	// zone_canal_high_A
	zm_zonemgr::add_adjacent_zone( "zone_canal_high_A",				"zone_canal_high_B",		"activate_canal_high",			true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_high_A",				"zone_canal_junction",		"connect_canal_high_to_low",	true );

	// zone_canal_high_B
	zm_zonemgr::add_adjacent_zone( "zone_canal_high_B",				"zone_canal_high_B",		"activate_canal_high",			true );
	zm_zonemgr::add_adjacent_zone( "zone_canal_high_B",				"zone_canal_high_C",		"activate_canal_high",			true );

	// zone_canal_high_C
	zm_zonemgr::add_adjacent_zone( "zone_canal_high_C",				"zone_canal_high_B",		"activate_canal_high",			true );


	// zone_brothel - Detective ritual
	zm_zonemgr::add_adjacent_zone( "zone_brothel",					"zone_canal_D",				"connect_canal_to_brothel",		true );

	
	// Connecting zone activation	(NOTE: Put after zone adjacencies so the connection flags are initialized
	
	// Door to canal from junction
	zm_zonemgr::add_zone_flags( "connect_canal_to_junction",		"activate_canal" );
	
	// Beast stair to canal high street
	zm_zonemgr::add_zone_flags( "connect_canal_high_to_low",		"activate_canal" );
	zm_zonemgr::add_zone_flags( "connect_canal_high_to_low",		"activate_canal_high" );

	// Door to train and brothel area
	zm_zonemgr::add_zone_flags( "connect_canal_to_train",			"activate_brothel_street" );
	zm_zonemgr::add_zone_flags( "connect_canal_to_train",			"activate_canal" );

	// Door to train from high street
	zm_zonemgr::add_zone_flags( "connect_canal_high_to_train",		"activate_brothel_street" );
	zm_zonemgr::add_zone_flags( "connect_canal_high_to_train",		"activate_canal_high" );


	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	SLUMS ( WATERFRONT DISTRICT )

	// zone_slums_junction - next to junction
	zm_zonemgr::add_adjacent_zone( "zone_slums_junction",		"zone_junction_slums",			"connect_slums_to_junction",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_junction",		"zone_slums_A",					"activate_slums_junction_alley",		true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_junction",		"zone_slums_high_A",			"connect_slums_high_to_low",			true );

	// zone_slums_A - alley after zone_slums_junction
	zm_zonemgr::add_adjacent_zone( "zone_slums_A",				"zone_slums_junction",			"activate_slums_junction_alley",		true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_A",				"zone_slums_B",					"activate_slums_junction_alley",		true );

	// zone_slums_B - open area with subway portal
	zm_zonemgr::add_adjacent_zone( "zone_slums_B",				"zone_slums_A",					"activate_slums_junction_alley",		true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_B",				"zone_slums_C",					"connect_slums_waterfront_to_alley",	true );

	// zone_slums_C - area with raised platform
	zm_zonemgr::add_adjacent_zone( "zone_slums_C",				"zone_slums_B",					"connect_slums_waterfront_to_alley",	true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_C",				"zone_slums_D",					"activate_slums_waterfront",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_C",				"zone_slums_train",				"activate_slums_waterfront",			true );

	// zone_slums_D - adjacent to train station
	zm_zonemgr::add_adjacent_zone( "zone_slums_D",				"zone_slums_C",					"activate_slums_waterfront",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_D",				"zone_slums_E",					"activate_slums_waterfront",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_D",				"zone_slums_train",				"activate_slums_waterfront",			true );
	
	// zone_slums_E - alongside Boxing Gym
	zm_zonemgr::add_adjacent_zone( "zone_slums_E",				"zone_slums_D",					"activate_slums_waterfront",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_E",				"zone_slums_gym",				"connect_slums_waterfront_to_gym",		true );

	// zone_slums_train - high path near train
	zm_zonemgr::add_adjacent_zone( "zone_slums_train",			"zone_slums_C",					"activate_slums_waterfront",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_train",			"zone_slums_D",					"activate_slums_waterfront",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_train",			"zone_slums_high_E",			"activate_slums_waterfront",			true );

	// zone_slums_gym - Boxer ritual
	zm_zonemgr::add_adjacent_zone( "zone_slums_gym",			"zone_slums_E",					"connect_slums_waterfront_to_gym",		true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_gym",			"zone_slums_gym_lockers",		"connect_slums_waterfront_to_gym",		true );

	// zone_slums_gym_locker - locker room inside gym
	zm_zonemgr::add_adjacent_zone( "zone_slums_gym_lockers",	"zone_slums_E",					"connect_slums_waterfront_to_gym",		true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_gym_lockers",	"zone_slums_gym",				"connect_slums_waterfront_to_gym",		true );

	// zone_slums_high_A - beast stairs area
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_A",			"zone_slums_junction",			"connect_slums_high_to_low",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_A",			"zone_slums_high_B",			"activate_slums_high",					true );
	
	// zone_slums_high_B - Perk machine area
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_B",			"zone_slums_high_A",			"activate_slums_high",					true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_B",			"zone_slums_high_C",			"activate_slums_high",					true );
	
	// zone_slums_high_C - catwalk above alley
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_C",			"zone_slums_high_B",			"activate_slums_high",					true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_C",			"zone_slums_high_D",			"connect_slums_high_to_train",			true );

	// zone_slums_high_D - rooftop shack
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_D",			"zone_slums_high_C",			"connect_slums_high_to_train",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_D",			"zone_slums_high_E",			"activate_slums_waterfront",			true );

	// zone_slums_high_E - high path between train and bridge
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_E",			"zone_slums_high_D",			"activate_slums_waterfront",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_E",			"zone_slums_high_F",			"activate_slums_waterfront",			true );

	// zone_slums_high_F - high path next to train
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_F",			"zone_slums_high_E",			"activate_slums_waterfront",			true );
	zm_zonemgr::add_adjacent_zone( "zone_slums_high_F",			"zone_slums_train",				"activate_slums_waterfront",			true );

	
	// Connecting zone activation	(NOTE: Put after zone adjacencies so the connection flags are initialized
	zm_zonemgr::add_zone_flags( "connect_slums_to_junction",			"activate_slums_junction_alley" );	// Door: Junction to Slums
	
	zm_zonemgr::add_zone_flags( "connect_slums_waterfront_to_alley",	"activate_slums_junction_alley" );	// Door: Slums mid area
	zm_zonemgr::add_zone_flags( "connect_slums_waterfront_to_alley",	"activate_slums_waterfront" );		// Door: Slums mid area
	
	zm_zonemgr::add_zone_flags( "connect_slums_high_to_low",			"activate_slums_junction_alley" );	// Beast stairs
	zm_zonemgr::add_zone_flags( "connect_slums_high_to_low",			"activate_slums_high" );			// Beast stairs
	
	zm_zonemgr::add_zone_flags( "connect_slums_high_to_train",			"activate_slums_waterfront" );		// Beast stairs
	zm_zonemgr::add_zone_flags( "connect_slums_high_to_train",			"activate_slums_high" );			// Beast stairs
	


	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	THEATER (FOOTLIGHT DISTRICT)	
	
	// zone_theater_junction - adj. to junction area
	zm_zonemgr::add_adjacent_zone( "zone_theater_junction",			"zone_junction_theater",			"connect_theater_to_junction",	true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_junction",			"zone_theater_A",					"activate_theater_alley", true );

	// zone_theater_A - alley, adj. to square
	zm_zonemgr::add_adjacent_zone( "zone_theater_A",				"zone_theater_junction",			"activate_theater_alley", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_A",				"zone_theater_B",					"connect_theater_alley_to_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_A",				"zone_theater_high_A",				"connect_theater_high_to_low", true );
	
	// zone_theater_B - western square, adj. to theater alley
	zm_zonemgr::add_adjacent_zone( "zone_theater_B",				"zone_theater_A",					"connect_theater_alley_to_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_B",				"zone_theater_C",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_B",				"zone_theater_D",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_B",				"zone_theater_E",					"activate_theater_square", true );

	// zone_theater_C - northern square, adj. to train
	zm_zonemgr::add_adjacent_zone( "zone_theater_C",				"zone_theater_B",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_C",				"zone_theater_E",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_C",				"zone_theater_train",				"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_C",				"zone_theater_high_D",				"connect_theater_high_to_square", true );
	
	// zone_theater_D - southern square
	zm_zonemgr::add_adjacent_zone( "zone_theater_D",				"zone_theater_B",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_D",				"zone_theater_E",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_D",				"zone_theater_F",					"activate_theater_square", true );

	// zone_theater_E - central square
	zm_zonemgr::add_adjacent_zone( "zone_theater_E",				"zone_theater_B",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_E",				"zone_theater_C",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_E",				"zone_theater_D",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_E",				"zone_theater_F",					"activate_theater_square", true );

	// zone_theater_F - eastern square, adj. to Burlesque
	zm_zonemgr::add_adjacent_zone( "zone_theater_F",				"zone_theater_D",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_F",				"zone_theater_E",					"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_F",				"zone_burlesque_entrance",			"connect_theater_to_burlesque", true );
	
	// zone_theater_high_A - outdoor dining, adj. theater_A
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_A",			"zone_theater_A",					"connect_theater_high_to_low", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_A",			"zone_theater_high_B",				"activate_theater_high", true );

	// zone_theater_high_B - southwest square
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_B",			"zone_theater_high_A",				"activate_theater_high", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_B",			"zone_theater_high_C",				"connect_theater_high_to_square", true );

	// zone_theater_high_C - west square
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_C",			"zone_theater_high_B",				"connect_theater_high_to_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_C",			"zone_theater_high_D",				"activate_theater_square", true );
	
	// zone_theater_high_D - north square
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_D",			"zone_theater_high_C",				"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_D",			"zone_theater_train",				"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_high_D",			"zone_theater_C",					"activate_theater_square", true );

	// 	zone_theater_train
	zm_zonemgr::add_adjacent_zone( "zone_theater_train",			"zone_theater_high_D",				"activate_theater_square", true );
	zm_zonemgr::add_adjacent_zone( "zone_theater_train",			"zone_theater_C",					"activate_theater_square", true );
	
	// zone_burlesque_entrance - entrance hallway of Burlesque
	zm_zonemgr::add_adjacent_zone( "zone_burlesque_entrance",		"zone_theater_F",					"connect_theater_to_burlesque", true );
	zm_zonemgr::add_adjacent_zone( "zone_burlesque_entrance",		"zone_burlesque",					"connect_theater_to_burlesque", true );

	// zone_burlesque - Femme ritual
	zm_zonemgr::add_adjacent_zone( "zone_burlesque",				"zone_burlesque_entrance",			"connect_theater_to_burlesque", true );
	zm_zonemgr::add_adjacent_zone( "zone_burlesque",				"zone_theater_F",					"connect_theater_to_burlesque", true );

	
	// Connecting zone activation	(NOTE: Put after zone adjacencies so the connection flags are initialized

	// Door junction to theater district
	zm_zonemgr::add_zone_flags( "connect_theater_to_junction",		"activate_theater_alley" );

	// Door theater alley to square
	zm_zonemgr::add_zone_flags( "connect_theater_alley_to_square",	"activate_theater_alley" );
	zm_zonemgr::add_zone_flags( "connect_theater_alley_to_square",	"activate_theater_square" );

	// Door theater high path to train
	zm_zonemgr::add_zone_flags( "connect_theater_high_to_square",	"activate_theater_square" );
	zm_zonemgr::add_zone_flags( "connect_theater_high_to_square",	"activate_theater_high" );

	// Powered door alley to high path
	zm_zonemgr::add_zone_flags( "connect_theater_high_to_low",		"activate_theater_alley" );
	zm_zonemgr::add_zone_flags( "connect_theater_high_to_low",		"activate_theater_high" );
	
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//	SUBWAY

	// zone_subway_pap_ritual - ritual side
	zm_zonemgr::add_adjacent_zone( "zone_subway_pap_ritual",			"zone_subway_pap",						"activate_underground", true );
	zm_zonemgr::add_adjacent_zone( "zone_subway_pap_ritual",			"zone_subway_north",					"activate_underground", true );
	
	// zone_subway_pap - PAP side
	zm_zonemgr::add_adjacent_zone( "zone_subway_pap",					"zone_subway_pap_ritual",				"activate_underground", true );

	// zone_subway_north - adj. to PAP room
	zm_zonemgr::add_adjacent_zone( "zone_subway_north",					"zone_subway_pap",						"activate_underground", true );
	zm_zonemgr::add_adjacent_zone( "zone_subway_north",					"zone_subway_central",					"activate_underground", true );
	zm_zonemgr::add_adjacent_zone( "zone_subway_north",					"zone_subway_keeper",					"connect_subway_to_keeper",	true );	// Beast door

	// zone_subway_central - central and south area
	zm_zonemgr::add_adjacent_zone( "zone_subway_central",				"zone_subway_north",					"activate_underground", true );
	zm_zonemgr::add_adjacent_zone( "zone_subway_central",				"zone_subway_junction",					"activate_underground", true );
	zm_zonemgr::add_adjacent_zone( "zone_subway_central",				"zone_subway_keeper",					"connect_subway_to_keeper",	true );	// Beast door

	// zone_subway_keeper - Keeper item room
	zm_zonemgr::add_adjacent_zone( "zone_subway_keeper",				"zone_subway_central",					"connect_subway_to_keeper", true );	// Beast door
	zm_zonemgr::add_adjacent_zone( "zone_subway_keeper",				"zone_subway_north",					"connect_subway_to_keeper", true ); // Beast door
	
	// zone_subway_junction - adj. to junction area
	zm_zonemgr::add_adjacent_zone( "zone_subway_junction",				"zone_subway_central",					"activate_underground", true );
	zm_zonemgr::add_adjacent_zone( "zone_subway_junction",				"zone_junction_theater",			"connect_subway_to_junction",	true );	// Powered door

	// Connecting zone activation	(NOTE: Put after zone adjacencies so the connection flags are initialized
	// NOTE: "activate_underground" is also set by beast doors that get smashed and open the portals to the area
	zm_zonemgr::add_zone_flags( "connect_subway_to_junction",			"activate_underground" );	// Door: Junction to Subway

}



function include_weapons()
{
	///////////////////
	//Special weapons//
	///////////////////

	zm_utility::include_weapon( "idgun", true );

}

function precacheCustomCharacters()
{
}

function initCharacterStartIndex()
{
	level.characterStartIndex = RandomInt( 4 );
}

function selectCharacterIndexToUse()
{
	if( level.characterStartIndex>=4 )
	level.characterStartIndex = 0;

	self.characterIndex = level.characterStartIndex;
	level.characterStartIndex++;

	return self.characterIndex;
}

function assign_lowest_unused_character_index()
{
	//get the lowest unused character index
	charindexarray = [];
	charindexarray[0] = 0;// -Russman )
	charindexarray[1] = 1;//  -Samuel )
	charindexarray[2] = 2;// - Misty )
	charindexarray[3] = 3;// - Marlton )
	
	players = GetPlayers();
	if(players.size == 1)
	{
		charindexarray = array::randomize(charindexarray);
		return charindexarray[0];
	}
	else if(players.size == 2)
	{
		foreach(player in players)
		{
			if(isdefined(player.characterIndex))
			{
				if(player.characterIndex == 2 || player.characterIndex == 0) //first player is Abigail or Russman, so make player 2 Marlton or Stuhlinger
				{
					if(randomint(100)> 50)
					{
						return 1;
					}
					return 3;
				}
				else if(player.characterIndex == 3 || player.characterIndex == 1) //first player is Marlton or Stuhlinger so player 2 should be Abigail or Russman
				{
					if(randomint(100)> 50)
					{
						return 0;
					}
					return 2;	
				}				
			}
			
		}
	}
	else //3 or more players just assign the lowest unused value
	{
		foreach(player in players)
		{
			if(isdefined(player.characterIndex))
			{
				ArrayRemoveValue(charindexarray,player.characterIndex,false);
			}
		}
		
		if(charindexarray.size  > 0 )
		{
			return charindexarray[0];
		}
	}
		
	
	//failsafe
	return 0;
}

function giveCustomCharacters()
{
	if( isdefined(level.hotjoin_player_setup) && [[level.hotjoin_player_setup]]("c_zom_farmgirl_viewhands") )
	{
		return;
	}
	
	self DetachAll();
	
	// Only Set Character Index If Not Defined, Since This Thread Gets Called Each Time Player Respawns
	//-------------------------------------------------------------------------------------------------
	if ( !isdefined( self.characterIndex ) )
	{
		self.characterIndex = assign_lowest_unused_character_index();
	}
	
	self.favorite_wall_weapons_list = [];
	self.talks_in_danger = false;	
	
	/#
		if(GetDvarString("force_char") != "")
		{
			self.characterIndex = getdvarint("force_char");
		}

	#/
	
	self SetCharacterBodyType( self.characterIndex );
	self SetCharacterBodyStyle( 0 );
	self SetCharacterHelmetStyle( 0 );

	switch( self.characterIndex )
	{
		case 0:
		{
				// Boxer
//				level.vox zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );				
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "frag_grenade" );
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "bouncingbetty" );
				break;
		}
		case 1:
		{	
				// Detective
//				level.vox zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );
				self.talks_in_danger = true;
				level.rich_sq_player = self;
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "pistol_standard" );
				break;
		}
		case 2:
		{
				// Femme
//				level.vox zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );				
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "870mcs" );
				break;
		}
		case 3:
		{
				// Magician
//				level.vox zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );
				self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = GetWeapon( "hk416" );
				break;
		}
	}

	self SetMoveSpeedScale( 1 );
	self SetSprintDuration( 4 );
	self SetSprintCooldown( 0 );	

	//self zm_utility::set_player_tombstone_index();	
	self thread set_exert_id();	
}

function set_exert_id()
{
	self endon("disconnect");
	
	util::wait_network_frame();
	util::wait_network_frame();
	
	self zm_audio::SetExertVoice(self.characterIndex + 1);
}

function setup_personality_character_exerts()
{
	// perk burp
	level.exert_sounds[1]["burp"][0] = "vox_plr_0_exert_burp_0";
	level.exert_sounds[1]["burp"][1] = "vox_plr_0_exert_burp_1";
	level.exert_sounds[1]["burp"][2] = "vox_plr_0_exert_burp_2";
	level.exert_sounds[1]["burp"][3] = "vox_plr_0_exert_burp_3";
	level.exert_sounds[1]["burp"][4] = "vox_plr_0_exert_burp_4";
	level.exert_sounds[1]["burp"][5] = "vox_plr_0_exert_burp_5";	
	level.exert_sounds[1]["burp"][6] = "vox_plr_0_exert_burp_6";

	level.exert_sounds[2]["burp"][0] = "vox_plr_1_exert_burp_0";
	level.exert_sounds[2]["burp"][1] = "vox_plr_1_exert_burp_1";
	level.exert_sounds[2]["burp"][2] = "vox_plr_1_exert_burp_2";
	level.exert_sounds[2]["burp"][3] = "vox_plr_1_exert_burp_3";

	level.exert_sounds[3]["burp"][0] = "vox_plr_2_exert_burp_0";
	level.exert_sounds[3]["burp"][1] = "vox_plr_2_exert_burp_1";
	level.exert_sounds[3]["burp"][2] = "vox_plr_2_exert_burp_2";
	level.exert_sounds[3]["burp"][3] = "vox_plr_2_exert_burp_3";
	level.exert_sounds[3]["burp"][4] = "vox_plr_2_exert_burp_4";
	level.exert_sounds[3]["burp"][5] = "vox_plr_2_exert_burp_5";	
	level.exert_sounds[3]["burp"][6] = "vox_plr_2_exert_burp_6";
	
	level.exert_sounds[4]["burp"][0] = "vox_plr_3_exert_burp_0";
	level.exert_sounds[4]["burp"][1] = "vox_plr_3_exert_burp_1";
	level.exert_sounds[4]["burp"][2] = "vox_plr_3_exert_burp_2";
	level.exert_sounds[4]["burp"][3] = "vox_plr_3_exert_burp_3";
	level.exert_sounds[4]["burp"][4] = "vox_plr_3_exert_burp_4";
	level.exert_sounds[4]["burp"][5] = "vox_plr_3_exert_burp_5";	
	level.exert_sounds[4]["burp"][6] = "vox_plr_3_exert_burp_6";

	// medium hit
	level.exert_sounds[1]["hitmed"][0] = "vox_plr_0_exert_pain_medium_0";
	level.exert_sounds[1]["hitmed"][1] = "vox_plr_0_exert_pain_medium_1";
	level.exert_sounds[1]["hitmed"][2] = "vox_plr_0_exert_pain_medium_2";
	level.exert_sounds[1]["hitmed"][3] = "vox_plr_0_exert_pain_medium_3";
	
	level.exert_sounds[2]["hitmed"][0] = "vox_plr_1_exert_pain_medium_0";
	level.exert_sounds[2]["hitmed"][1] = "vox_plr_1_exert_pain_medium_1";
	level.exert_sounds[2]["hitmed"][2] = "vox_plr_1_exert_pain_medium_2";
	level.exert_sounds[2]["hitmed"][3] = "vox_plr_1_exert_pain_medium_3";
	
	level.exert_sounds[3]["hitmed"][0] = "vox_plr_2_exert_pain_medium_0";
	level.exert_sounds[3]["hitmed"][1] = "vox_plr_2_exert_pain_medium_1";
	level.exert_sounds[3]["hitmed"][2] = "vox_plr_2_exert_pain_medium_2";
	level.exert_sounds[3]["hitmed"][3] = "vox_plr_2_exert_pain_medium_3";
	
	level.exert_sounds[4]["hitmed"][0] = "vox_plr_3_exert_pain_medium_0";
	level.exert_sounds[4]["hitmed"][1] = "vox_plr_3_exert_pain_medium_1";
	level.exert_sounds[4]["hitmed"][2] = "vox_plr_3_exert_pain_medium_2";
	level.exert_sounds[4]["hitmed"][3] = "vox_plr_3_exert_pain_medium_3";

	// large hit
	level.exert_sounds[1]["hitlrg"][0] = "vox_plr_0_exert_pain_high_0";
	level.exert_sounds[1]["hitlrg"][1] = "vox_plr_0_exert_pain_high_1";
	level.exert_sounds[1]["hitlrg"][2] = "vox_plr_0_exert_pain_high_2";
	level.exert_sounds[1]["hitlrg"][3] = "vox_plr_0_exert_pain_high_3";
	
	level.exert_sounds[2]["hitlrg"][0] = "vox_plr_1_exert_pain_high_0";
	level.exert_sounds[2]["hitlrg"][1] = "vox_plr_1_exert_pain_high_1";
	level.exert_sounds[2]["hitlrg"][2] = "vox_plr_1_exert_pain_high_2";
	level.exert_sounds[2]["hitlrg"][3] = "vox_plr_1_exert_pain_high_3";
	
	level.exert_sounds[3]["hitlrg"][0] = "vox_plr_2_exert_pain_high_0";
	level.exert_sounds[3]["hitlrg"][1] = "vox_plr_2_exert_pain_high_1";
	level.exert_sounds[3]["hitlrg"][2] = "vox_plr_2_exert_pain_high_2";
	level.exert_sounds[3]["hitlrg"][3] = "vox_plr_2_exert_pain_high_3";
	
	level.exert_sounds[4]["hitlrg"][0] = "vox_plr_3_exert_pain_high_0";
	level.exert_sounds[4]["hitlrg"][1] = "vox_plr_3_exert_pain_high_1";
	level.exert_sounds[4]["hitlrg"][2] = "vox_plr_3_exert_pain_high_2";
	level.exert_sounds[4]["hitlrg"][3] = "vox_plr_3_exert_pain_high_3";
}


function giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	self giveWeapon( level.weaponBaseMelee );
	self zm_utility::give_start_weapon( true );

	self AllowDoubleJump( 0 ); //no double jump!
}


function custom_add_weapons()
{
	zm_weapons::load_weapon_spec_from_table("gamedata/weapons/zm/zm_zod_weapons.csv", 1);
	zm_weapons::autofill_wallbuys_init();
}

function custom_add_vox()
{
	zm_audio::loadPlayerVoiceCategories("gamedata/audio/zm/zm_zod_vox.csv");
}

// handle transformation into the alien world when the time is right...
function watch_for_world_transformation()
{
	level clientfield::set( "show_hide_pap_weed", 0 ); // hide the world-transformation red weeds
	level clientfield::set( "god_state", 0 );
		
	level flag::wait_till( "ritual_pap_complete" );
	
	// lighting change to alien sky
	level thread util::set_lighting_state( 3 );
	
	level clientfield::set( "show_hide_pap_weed", 1 ); // show the world-transformation red weeds
	level clientfield::set( "god_state", 2 );
}






function setupMusic()
{
	//Special Round
	zm_audio::sndMusicSystem_CreateState( "parasite_start", "mus_zombie_round_parasite_start", 3 );
	zm_audio::sndMusicSystem_CreateState( "parasite_over", "mus_zombie_round_parasite_over", 3 );
	zm_audio::sndMusicSystem_CreateState( "meatball_start", "mus_zombie_round_meatball_start", 3 );
	zm_audio::sndMusicSystem_CreateState( "meatball_over", "mus_zombie_round_meatball_over", 3 );
}

// self = player
// should the weapon be able to come up next in the box?
function zod_custom_weapon_weights( keys )
{
//	weapon_idgun = GetWeapon( ZOD_IDGUN_WEAPON );
//
//	n_idguns = level clientfield::get( "idguns_in_box" );
//	if( n_idguns > 0 )
//	{
//		ArrayInsert( keys, weapon_idgun, 0 );
//	}

	return keys;
}

// self = player
// should the player be permitted to receive the weapon?
function zod_special_weapon_magicbox_check( weapon )
{
	return true;
}
