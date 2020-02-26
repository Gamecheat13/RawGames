#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_game_module;

#include maps\mp\zm_transit_utility;

#insert raw\common_scripts\utility.gsh;

//*****************************************************************************
// Zombie Transit Main
//*****************************************************************************
main()
{
	if(getdvar("createfx") == "1")
	{
		ents = getentarray();
		for(i=0;i<ents.size;i++)
		{
			ents[i] delete();
		}
	}
	level.ignore_spawner_func 		= ::transit_ignore_spawner;

	level.default_game_mode = "zclassic";	
	level.default_start_location = "transit";	
	level._game_mode_start_classic = ::start_classic_game_mode;
	level._game_mode_start_turned = ::start_turned_game_mode;
	level._get_random_encounter_func = maps\mp\zm_transit_utility::get_random_encounter_match;
	setup_rex_starts();
	
	if( is_Classic() ) 
	{
		maps\mp\zm_transit_classic::main();
	}
	
	//needs to be first for create fx
	maps\mp\zm_transit_fx::main();
	maps\mp\zombies\_zm::init_fx();
	maps\mp\animscripts\zm_death::precache_gib_fx();//this really belongs in zm_load::main
	level.zombiemode = true;
	level._no_water_risers = 1;
	
	maps\mp\teams\_teamset_cdc::register();	

	maps\mp\_load::main();
	
	init_clientflags();
	
	if(getdvar("createfx") == "1")
	{
		return;
	}

	//maps\mp\zm_transit_amb::main();

	// If the team nationalites change in this file,
	// you must update the team nationality in the level's csc file as well!
	maps\mp\teams\_teamset_cdc::level_init();

	level.custom_ai_type = [];
	if( is_Classic() ) 
	{
		ARRAY_ADD( level.custom_ai_type, maps\mp\zombies\_zm_ai_screecher::init );
		ARRAY_ADD( level.custom_ai_type, maps\mp\zombies\_zm_ai_avogadro::init );
	}

	level.screecher_should_burrow = maps\mp\zm_transit_ai_screecher::screecher_should_burrow;
	level.is_player_in_screecher_zone = ::is_player_in_screecher_zone;
	level.revive_trigger_spawn_override_link = ::revive_trigger_spawn_override_link;
	level.allow_move_in_laststand = ::allow_move_in_laststand;

	precache_survival_barricade_assets();
	include_game_modules();
	
	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	level.giveCustomLoadout = ::giveCustomLoadout;
	level.precacheCustomCharacters = ::precacheCustomCharacters;
	level.giveCustomCharacters = ::giveCustomCharacters;
	initCharacterStartIndex();	

	level.custom_player_fake_death = ::transit_player_fake_death;
	level.custom_player_fake_death_cleanup = ::transit_player_fake_death_cleanup;

	level.initial_round_wait_func = ::initial_round_wait_func;
	
	level._round_start_func = ::start_game_modules;

	//ENABLE PACK-A-PUNCH
	level.zombiemode_using_pack_a_punch = true;

	//ENABLE PERKS
	//level.zombiemode_using_additionalprimaryweapon_perk = true;
	level.zombiemode_using_doubletap_perk = true;
	level.zombiemode_using_juggernaut_perk = true;
	level.zombiemode_using_marathon_perk = true;
	level.zombiemode_using_revive_perk = true;
	level.zombiemode_using_sleightofhand_perk = true;
	level.zombiemode_using_tombstone_perk = true;
	
	level.register_offhand_weapons_for_level_defaults_override = ::offhand_weapon_overrride;
	level.player_intersection_tracker_override = ::zombie_transit_player_intersection_tracker_override;
	level.player_too_many_weapons_monitor_callback = ::zombie_transit_player_too_many_weapons_monitor_callback;
	level._zmbVoxLevelSpecific = ::zombie_transit_audio_alias_override;

	level._zombie_custom_add_weapons = ::custom_add_weapons;
	level._allow_melee_weapon_switching = 1;

	//Level specific stuff
	include_weapons();
	include_powerups();
	include_equipment_for_level();

	if( is_Classic() ) 
	{
		include_buildables();

		maps\mp\zombies\_zm_equip_turbine::init();
		maps\mp\zombies\_zm_equip_turret::init();
		maps\mp\zombies\_zm_equip_electrictrap::init();

		// callback to make the zombies path to the bus better
		level.enemy_location_override_func = ::enemy_location_override;
		level.closest_player_override = ::closest_player_transit;
	}
	
	// max distance a zombie can drop a powerup from a moving bus
	level.powerup_bus_range = 500;
	//level.valid_powerup_location_callback = ::is_valid_powerup_location;

	level.pay_turret_cost = 300;
	level.auto_turret_cost = 500;

	setup_dvars();
	OnPlayerConnect_Callback(::setup_players);

	// Temp DCS: disable use triggers till used.
	level thread disable_triggers();

	if( (getdvar("ui_gametype") != "zmeat") && (getdvar("ui_gametype") != "zrace") ) //TEMP - don't enable lava damage in Meat for now
	{
		level thread maps\mp\zm_transit_lava::lava_damage_init();
	}
		
	maps\mp\zm_transit_upgrades::precache_upgrades();
	level thread maps\mp\zm_transit_power::precache_models();
	
	// add the spawn init function first, as the threads that do regular init startup pathing, for which we need variables
	setup_zombie_init();

	//Init zombiemode scripts
	maps\mp\zombies\_zm::init();

	maps\mp\zombies\_zm_ai_basic::init_inert_zombies();

	maps\mp\zombies\_zm_weap_riotshield::init();

	maps\mp\zombies\_zm_weap_jetgun::init();

	// set to 0 = not move.
	//SetDvar( "magic_chest_movable", "0" );

	maps\mp\zombies\_zm_weap_emp_bomb::init();
	zm_transit_emp_init();

	maps\mp\zombies\_zm_weap_cymbal_monkey::init();
	maps\mp\zombies\_zm_weap_tazer_knuckles::init();
	maps\mp\zombies\_zm_weap_bowie::init();
	maps\mp\zombies\_zm_weap_claymore::init();
	maps\mp\zombies\_zm_weap_ballistic_knife::init();
	//maps\mp\zombies\_zm_weap_crossbow::init();
	maps\mp\_sticky_grenade::init();
	
	PrecacheItem("death_throe_zm");

	if ( !Is_Encounter() )
	{
		level.playerSuicideAllowed = true;
		level.canPlayerSuicide = ::canPlayerSuicide;
		level.suicide_weapon = "death_self_zm";
		PrecacheItem("death_self_zm");
	}

	//maps\_zombiemode_timer::init();
	if( is_Classic() ) //do we need to do this in other modes? 
	{
		level thread maps\mp\zm_transit_power::initializePower();
		maps\mp\zm_transit_ambush::main();
	}
	//maps\mp\zm_transit_radio_turrets::initRadioTurrets();

	
	//Setup the levels Zombie Zone Volumes
	level.zones = [];
	level.zone_manager_init_func = ::transit_zone_init;
	init_zones[0] = "zone_pri";
	init_zones[1] = "zone_gas";
	init_zones[2] = "zone_tow";
	init_zones[3] = "zone_far";
	init_zones[4] = "zone_pow";

	init_zones[5] = "zone_trans_1";
	init_zones[6] = "zone_trans_2";
	init_zones[7] = "zone_trans_3";
	init_zones[8] = "zone_trans_4";
	init_zones[9] = "zone_trans_5";
	init_zones[10] = "zone_trans_6";
	init_zones[11] = "zone_trans_7";
	init_zones[12] = "zone_trans_8";
	init_zones[13] = "zone_trans_9";
	init_zones[14] = "zone_trans_10"; // town to forest.
	init_zones[15] = "zone_trans_11"; // town to bridge.

	init_zones[16] = "zone_amb_tunnel";
	init_zones[17] = "zone_amb_forest";
	init_zones[18] = "zone_amb_cornfield";
	init_zones[19] = "zone_amb_power2town";
	init_zones[20] = "zone_amb_bridge";
	
	level thread maps\mp\zombies\_zm_zonemgr::manage_zones( init_zones );

	level.zombie_ai_limit = 24;

	SetDvar( "zombiemode_path_minz_bias", 30 );
	
	precache_gamemode_assets();

	if( is_Classic()|| is_Standard() )
	{
		PreCacheModel("zm_collision_transit_farm_classic");
		PreCacheModel("zm_collision_transit_town_classic");
		PreCacheModel("zm_collision_transit_tunnel_classic");
		PreCacheModel("p_glo_tools_chest_tall");
	}
	
	//FinalizeClientFields();
	flag_wait( "start_zombie_round_logic" );
	// end threads that look for all players
	level notify("players_done_connecting");

	//DCS: Custom intermission selection. 
	level.custom_intermission = ::transit_intermission;	

	if( GetDvar( "ui_gametype" ) == "zgrief")
	{
		flag_set("door_can_close");
	}
	
	if( is_Classic() )
	{

		level.the_bus = getEnt( "the_bus", "targetname" );
		level.the_bus thread maps\mp\zm_transit_bus::busSetup();

		level thread classic_collision_spawning();

		level thread inert_zombies_init();
		level thread falling_death_init();

		
		level.check_valid_spawn_override = ::transit_respawn_override;
		level.zombie_check_suppress_gibs = ::shouldSuppressGibs;
		
		level thread transit_vault_breach_init();
		level thread maps\mp\zm_transit_distance_tracking::zombie_tracking_init();
		level thread solo_tombstone_removal();
		level thread collapsing_bridge_init();
		
		level thread turbineBuildable();
		level thread turretBuildable();
		level thread electricTrapBuildable();
		level thread jetgunBuildable();
		level thread busHatchBuildable();     
		
		level thread powerstation_outhouse_audio();
		
		level thread bank_deposit_box();
		
		level thread bus_roof_damage_init();
		
		level thread diner_hatch_access();
		
		//////rimlighting////////
    SetDvar( "r_rimIntensity_debug", 1 );
    SetDvar( "r_rimIntensity", 3.5 );            
		
	}
	
	/#
	execdevgui( "devgui_zombie_transit" );
	level.custom_devgui = ::zombie_transit_devgui;
	#/
}

diner_hatch_access()
{
	diner_hatch = GetEnt( "diner_hatch", "targetname" );
	diner_hatch_col = GetEnt( "diner_hatch_collision", "targetname" );
	diner_hatch_object = maps\mp\zombies\_zm_buildables::get_buildable_pickup( "bushatch", "p_rus_hatch_01_clsd" );
	
	if ( !IsDefined( diner_hatch ) || !IsDefined( diner_hatch_col ) )
	{
		return;
	}
	
	diner_hatch Hide();
	
	// Create A Use Object On Trigger
	//-------------------------------

	trigger = Spawn( "trigger_radius_use", ( -6294, -7950, 50 ), 0, 32, 32 );
	trigger SetCursorHint( "HINT_NOICON" );
	trigger SetHintString( "Press & Hold [{+activate}] to build Diner Roof Hatch" );
	trigger TriggerIgnoreTeam();

	visuals[ 0 ] = Spawn( "script_model", ( -6294, -7950, 50 ) );
	visuals[ 0 ] SetModel( "tag_origin" );

	buildableZone = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, ( 0, 0, 32 ) );
	buildableZone maps\mp\gametypes\_gameobjects::allowUse( "any" );
	buildableZone maps\mp\gametypes\_gameobjects::setUseTime( 3 );
	buildableZone maps\mp\gametypes\_gameobjects::setUseText( &"ZOMBIE_BUILDING" );
	buildableZone maps\mp\gametypes\_gameobjects::setUseHintText( "Press & Hold [{+activate}] to build Diner Roof Hatch" );
	buildableZone maps\mp\gametypes\_gameobjects::setKeyObject( diner_hatch_object );
	label = buildableZone maps\mp\gametypes\_gameobjects::getLabel();
	buildableZone.label = label;
	buildableZone.pieces = 1;
	buildableZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	buildableZone.onBeginUse = maps\mp\zombies\_zm_buildables::onBeginUse;
	buildableZone.onEndUse = maps\mp\zombies\_zm_buildables::onEndUse;
	buildableZone.onUse = maps\mp\zombies\_zm_buildables::onUsePlantObject;
	buildableZone.onCantUse = maps\mp\zombies\_zm_buildables::onCantUse;
	buildableZone.dontLinkPlayerToTrigger = true;
	
	buildableZone.buildableStruct = SpawnStruct();
	
	buildableZone waittill( "built", player );
	
	diner_hatch Show();
	diner_hatch_col Delete();
	
	trigger SetHintString( "Double Jump To Climb Up" );
}

bank_deposit_box()
{
	trig = Spawn( "trigger_radius_use", ( 576, 396, 16 ), 0, 32, 32 );
	trig SetHintString( &"ZOMBIE_BANK_DEPOSIT_PROMPT", 10000 );
	trig SetCursorHint( "HINT_NOICON" );
	trig TriggerIgnoreTeam();
	
	amount = 10000;
	
	bank_deposits = [];
	
	while ( true )
	{
		trig waittill( "trigger", player );
		
		if ( !is_player_valid( player ) )
		{
			continue;
		}
		
		if ( !IsDefined( bank_deposits[ player.characterIndex ] ) )
		{
			bank_deposits[ player.characterIndex ] = SpawnStruct();
		}
		
		account = bank_deposits[ player.characterIndex ];
		
//		account_val = player maps\mp\zombies\_zm_stats::get_map_stat( "depositBox" );
//		if ( !account_val )
//		{
//			player maps\mp\zombies\_zm_stats::set_map_stat( "depositBox", int(amount / 1000) );
//			iprintlnbold( "!@#$ ADDED Depositibox" );
//		}
//		else
//		{
//			player maps\mp\zombies\_zm_stats::set_map_stat( "depositBox", 0 );
//			iprintlnbold( "!@#$ EMPTIED Depositibox" );
//		}
		
		// Withdraw
		//---------
		if ( IsDefined( account.savings ) && account.savings > 0 )
		{
			player playsoundtoplayer( "zmb_vault_bank_withdraw", player );
			player.score += account.savings;
			account.savings = 0;
		}
		// Deposit
		//--------
		else if ( player.score >= amount )
		{
			player playsoundtoplayer( "zmb_vault_bank_deposit", player );
			player.score -= amount;
			account.savings = amount;
		}
		else
		{
			continue;
		}
		
		player maps\mp\zombies\_zm_score::set_player_score_hud(); 
	}
}

powerstation_outhouse_audio()
{
	trig = Spawn( "trigger_radius", ( 11200, 7580, -608 ), 0, 32, 52 );
	trig SetHintString( "" );
	trig SetCursorHint( "HINT_NOICON" );
	
	while ( true )
	{
		trig waittill( "trigger", player );
		
		if ( !IsPlayer( player ) )
		{
			continue;	
		}

		playsoundatposition( "zmb_toilet_flush", player.origin );
		
		while ( IsDefined( player ) && player IsTouching( trig ) )
		{
			wait ( 0.05 );
		}
		
		wait ( 0.05 );
	}
}

busHatchBuildable()
{
	trig = Spawn( "trigger_radius_use", level.the_bus GetTagOrigin( "tag_hatch_pristine" ) + ( 0, 0, -45 ) );
	trig SetCursorHint( "HINT_NOICON" );
	trig TriggerIgnoreTeam();
	trig EnableLinkTo();
	trig LinkTo( level.the_bus );
	trig UseTriggerRequireLookAt();

	level.bus_roof Hide();

	trig maps\mp\zombies\_zm_buildables::buildable_think( "bushatch" );

	level.bus_roof Show();

	trig Delete();

	level.the_bus notify( "hatch_mantle_allowed" );
}

turbineBuildable()
{
	trig = GetEnt( "turbine_buildable_trigger", "targetname" );
	
	if ( !IsDefined( trig ) )
	{
		return;
	}
	
	trig maps\mp\zombies\_zm_buildables::buildable_think( "turbine" );
	
	trig SetHintString( &"ZOMBIE_GRAB_TURBINE_PICKUP_HINT_STRING" );
	
	while ( true )
	{
		trig waittill( "trigger", player );
		
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}
		
		player maps\mp\zombies\_zm_equipment::equipment_give( "equip_turbine_zm" );
	}
}

turretBuildable()
{
	trig = GetEnt( "turret_buildable_trigger", "targetname" );
	
	if ( !IsDefined( trig ) )
	{
		return;
	}
	
	trig maps\mp\zombies\_zm_buildables::buildable_think( "turret" );
	
	trig SetHintString( &"ZOMBIE_GRAB_TURRET_PICKUP_HINT_STRING" );
	
	while ( true )
	{
		trig waittill( "trigger", player );
		
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}
		
		player maps\mp\zombies\_zm_equipment::equipment_give( "equip_turret_zm" );
	}
}

electricTrapBuildable()
{
	trig = GetEnt( "electric_trap_buildable_trigger", "targetname" );
	
	if ( !IsDefined( trig ) )
	{
		return;
	}
	
	trig maps\mp\zombies\_zm_buildables::buildable_think( "electric_trap" );
	
	trig SetHintString( &"ZOMBIE_EQUIP_ELECTRICTRAP" );
	
	while ( true )
	{
		trig waittill( "trigger", player );
		
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}
		
		player maps\mp\zombies\_zm_equipment::equipment_give( "equip_electrictrap_zm" );
	}
}

jetgunBuildable()
{
	trig = GetEnt( "jetgun_zm_buildable_trigger", "targetname" );
	
	if ( !IsDefined( trig ) )
	{
		return;
	}
	
	trig maps\mp\zombies\_zm_buildables::buildable_think( "jetgun_zm" );

	trig SetHintString( &"ZOMBIE_EQUIP_JETGUN" );
	
	while ( true )
	{
		trig waittill( "trigger", player );
		
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}
		
		if ( !maps\mp\zombies\_zm_equipment::is_limited_equipment("jetgun_zm") ||
			 !maps\mp\zombies\_zm_equipment::limited_equipment_in_use("jetgun_zm") )
		{
			player maps\mp\zombies\_zm_equipment::equipment_give( "jetgun_zm" );
			player GiveWeapon( "jetgun_zm" );
			player SwitchToWeapon( "jetgun_zm" );
			player setactionslot( 1, "weapon", "jetgun_zm" );
		}
	}
}

// only precache assets for the necessary areas
precache_gamemode_assets()
{
	gametype = getdvar("ui_gametype"); 
	location = getdvar("ui_zm_mapstartlocation");

	switch(gametype)
	{
		case "zturned":
			switch(location)
			{
				case "town":
					PreCacheModel( "zm_collision_transit_town_survival" );
					break;
			}
			break;
			
		case "zstandard":
			switch(location)
			{
				case "transit":
					PreCacheModel( "zm_collision_transit_busdepot_survival" );
					break;
				case "town":
					PreCacheModel( "zm_collision_transit_town_survival" );
					break;
				case "farm":
					PreCacheModel( "zm_collision_transit_farm_survival" );
					break;
			}
			break;
		
		case "zgrief":
			switch(location)
			{
				case "town":
					PreCacheModel( "zm_collision_transit_town_survival" );
					break;
				case "farm":
					PreCacheModel( "zm_collision_transit_farm_survival" );
					break;
				case "transit":
					PreCacheModel( "zm_collision_transit_busdepot_survival" );
					break;
			}
			break;
			
		case "znml":
			switch(location)
			{
				case "town":
					PreCacheModel( "zm_collision_transit_town_survival" );
					break;
				case "cornfield":
					PreCacheModel( "zm_collision_transit_cornfield_survival" );
					break;
			}
			break;
			
		case "zpitted":
			switch(location)
			{
				case "town":
					PreCacheModel( "zm_collision_transit_town_survival" );
					break;
				case "cornfield":
					PreCacheModel( "zm_collision_transit_cornfield_survival" );
					break;
			}
			break;
			
		case "zcleansed":
			switch(location)
			{
				case "town":
					PreCacheModel( "zm_collision_transit_town_survival" );
					break;
				case "farm":
					PreCacheModel( "zm_collision_transit_farm_survival" );
					break;
			}
			break;
			
		case "zrace":			
			switch(location)
			{
				case "town": 
					precachemodel("zm_collision_transit_town_race");
					precachemodel("zm_town_encounters_neon");
					break;
				
				case "farm": 
					precachemodel("zm_collision_transit_farm_race");
					precachemodel("zm_farm_encounters_neon");
					break;
				
				case "tunnel": 
					precachemodel("zm_collision_transit_tunnel_race");
					precachemodel("zm_tunnel_encounters_neon");
					break;
				
				case "power":
					precachemodel("zm_collision_transit_power_race");
					break;
			}
			break;
			
		case "zmeat":
			switch(location)
			{
				case "town":
					precachemodel("zm_collision_transit_town_meat");
					precachemodel("zm_town_encounters_neon");
					break;
				case "farm":
					precachemodel("zm_collision_transit_farm_meat");
					precachemodel("zm_farm_encounters_neon");
					break;	
				case "tunnel":
					precachemodel("zm_collision_transit_tunnel_meat");
					precachemodel("zm_tunnel_encounters_neon");
					break;		
					
			}						
			break;		
	}
}

setup_rex_starts()
{
	// populate the Gametype dropdown
	add_gametype( "zclassic", ::dummy, "zclassic", ::dummy );
	add_gametype( "zstandard", ::dummy, "zstandard", ::dummy );
	//dd_gametype( "zcontainment", ::dummy, "zcontainment", ::dummy );
	add_gametype( "zrace", ::dummy, "zrace", ::dummy );
	//dd_gametype( "zdeadpool", ::dummy, "zdeadpool", ::dummy );
	add_gametype( "zmeat", ::dummy, "zmeat", ::dummy );
	add_gametype( "znml", ::dummy, "znml", ::dummy );
	add_gametype( "zturned", ::dummy, "zturned", ::dummy );
	add_gametype( "zpitted", ::dummy, "zpitted", ::dummy );
	add_gametype( "zcleansed", ::dummy, "zcleansed", ::dummy );
	add_gametype( "zgrief", ::dummy, "zgrief", ::dummy );
	
	// populate the Location dropdown
	add_gameloc( "transit", ::dummy, "transit", ::dummy );
	add_gameloc( "town", ::dummy, "town", ::dummy );
	add_gameloc( "tunnel", ::dummy, "tunnel", ::dummy );
	add_gameloc( "farm", ::dummy, "farm", ::dummy );
	add_gameloc( "cornfield", ::dummy, "cornfield", ::dummy );
}

dummy()
{
}


classic_collision_spawning()
{
	wait(1);
	
	/*
	farm offset	(8000, -5800, 0)
	town offset	(1363, 471, 0)
	tunnel offset	(-9872, 1344, 0)
	bus station offset (-6896, 4744, 0)
	*/
		
	collision = Spawn( "script_model", (8000, -5800, 0), 1 );
	collision SetModel( "zm_collision_transit_farm_classic" );

	collision2 = Spawn( "script_model", (1363, 471, 0), 1 );
	collision2 SetModel( "zm_collision_transit_town_classic" );

	collision3 = Spawn( "script_model", (-9872, 1344, 0), 1 );
	collision3 SetModel( "zm_collision_transit_tunnel_classic" );
		
	collision3 DisconnectPaths();
	flag_wait("OnPriDoorYar");
	collision2 DisconnectPaths();
	// waittill entered farm to disconnect barn.
	flag_wait("OnFarm_enter");
	collision DisconnectPaths();
}	

init_clientflags()
{
	level._CLIENTFLAG_VEHICLE_BUS_FLASHING_LIGHTS = 0;
	level._CLIENTFLAG_VEHICLE_BUS_HEAD_LIGHTS = 1;
	level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS = 2;
	level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_LEFT_LIGHTS = 3;
	level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_RIGHT_LIGHTS = 4;
	
	if(getdvar("ui_gametype") == "zrace")
	{
		level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_GRIEF_1 = 11;
		level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_GRIEF_2 = 12;
		level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_1 = 13;
		level._CLIENTFLAG_ACTOR_ZOMBIE_DOOR_RELEASE_2 = 14;	
	}
	if(getdvar("ui_gametype") == "zmeat")
	{
		level._CLIENTFLAG_PLAYER_HOLDING_MEAT = 9;	
	}
}

transit_ignore_spawner( spawner )
{
	if( spawner.classname == "actor_zm_zombie_transit_screecher" )
	{
		// hodge :: TODO - add a debug only print line - there should be no smokers in the map
		return true;
	}

	return false;
}

allow_move_in_laststand( player_down )
{
	if( IsDefined(player_down.isOnBus) && player_down.isOnBus )
	{
		return false;
	}
	
	return true;
}

revive_trigger_spawn_override_link( player_down )
{
	if( IsDefined(player_down.isOnBus) && player_down.isOnBus )
	{
		player_down.revivetrigger LinkTo( level.the_bus );  
	}
	else
	{
		player_down.revivetrigger LinkTo( player_down ); 
	}
}

is_player_in_screecher_zone( player )
{
	if( IsDefined(player.isOnBus) && player.isOnBus )
	{
		return false;
	}
	if( player_entered_safety_zone( player ))
	{
		return false;
	}
	
	curr_zone = player get_current_zone();
	if( !IsDefined( curr_zone ) && IsDefined( self.zone_name ) )
	{
		curr_zone = self.zone_name;
	}
	
	if( IsDefined( curr_zone ) )
	{
		if( !IsSubStr( curr_zone, "_trans_" ) && !IsSubStr( curr_zone, "_amb_" ) )
		{
			if(IsDefined(player.ScreechTarget) && player.ScreechTarget > 0)
			{
				level thread player_escaped_screecher_zone(player);
				player.ScreechTarget = 2;
				return true;
			}
			return false;
		}
	}
	player.ScreechTarget = 1;
	return true;
}

player_escaped_screecher_zone( player )
{
	player endon("death");
	player endon("disconnect");

	if(player.ScreechTarget > 1)
	return;
	
	wait(RandomFloat(30));
	player.ScreechTarget = 0;
}
	
player_entered_safety_zone( player )
{

	//Check if near bus first.
	//spawn_groups = GetStructArray("player_respawn_point", "targetname");
	spawn_groups = maps\mp\gametypes\_zm_gametype::get_player_spawns_for_gametype();
	for( i = 0; i< spawn_groups.size; i++)
	{
		if (spawn_groups[i].script_noteworthy == "zone_bus")
		{
			// DCS: add respawn point of bus to array.
			spawn_groups[i].radius = 320;
			plyr_dist = DistanceSquared( player.origin, spawn_groups[i].origin );
			if( plyr_dist < ( spawn_groups[i].radius * spawn_groups[i].radius ) )
			{
				return true;
			}
		}	
	}		
	
	safety_volumes = GetEntArray("screecher_volume","targetname");
	if(IsDefined(safety_volumes))
	{
		for( i = 0 ; i < safety_volumes.size; i++ )
		{
			if(player IsTouching(safety_volumes[i]))
			{
				return true;
			}	
		}
	}	
	
	if(player_entered_safety_light(player))
	{
		return true;
	}
		
	return false;
}

player_entered_safety_light( player )
{
	// Check if near safety light or civilization point.
	safety = getstructarray("screecher_escape","targetname");
	
	if(!IsDefined(safety))
	return false;

	player.green_light = undefined;
	
	for( i = 0 ; i < safety.size; i++ )
	{
		if( !IsDefined(safety[i].radius) )
		{
			safety[i].radius = 256;
		}	
		plyr_dist = DistanceSquared( player.origin, safety[i].origin );
		if( plyr_dist < ( safety[i].radius * safety[i].radius ) )
		{
			player.green_light = safety[i];
			return true;
		}
	}
	
	return false;	
}
	
closest_player_transit( origin, players )
{
	// path calc will fail when players are on the bus...use distance instead
	if ( isdefined( level.the_bus ) && level.the_bus.numAlivePlayersRidingBus > 0 )
	{
		player = GetClosest( origin, players );
	}
	else
	{
		player = maps\mp\zombies\_zm_utility::get_closest_player_using_paths( origin, players );
	}

	return player;
}

zombie_transit_player_intersection_tracker_override( other_player )
{
	if ( is_true( self.isOnBus ) || is_true( self.isOnBus ) )
	{
		return true;
	}

	if ( is_true( other_player.isOnBus ) || is_true( other_player.isOnBus ) )
	{
		return true;
	}

	return false;
}

using_team_characters()
{
	if(is_Encounter() )
	{
		return true;
	}
	return false;
	//return GetDvar( "ui_gametype" )!="zclassic" && GetDvar( "ui_gametype" ) != "znml" && GetDvar( "ui_gametype" ) != "zcleansed";
}

//*****************************************************************************
precacheCustomCharacters()
{
	//Precache characters
	if ( using_team_characters() )
	{
		precacheModel("c_zom_player_cdc_fb");
		PrecacheModel( "c_usa_mp_pmc_assault_viewhands" );

		precacheModel("c_zom_player_cia_fb");
		PrecacheModel( "c_usa_mp_sealteam6_assault_viewhands" );

	}
	else
	{
		character\c_usa_dempsey_zm::precache();// Dempsy
		character\c_rus_nikolai_zm::precache();// Nikolai
		character\c_jap_takeo_zm::precache();// Takeo
		character\c_ger_richtofen_zm::precache();// Richtofen
	
		PrecacheModel( "viewmodel_usa_pow_arms" );
		PrecacheModel( "viewmodel_rus_prisoner_arms" );
		PrecacheModel( "viewmodel_vtn_nva_standard_arms" );
		PrecacheModel( "viewmodel_usa_hazmat_arms" );
	}

}
	
precache_survival_barricade_assets()
{
	survival_barricades = getstructarray("game_mode_object");
	for(i=0;i<survival_barricades.size;i++)
	{
		if(isDefined(survival_barricades[i].script_string) && survival_barricades[i].script_string == "survival")
		{
			if(IsDefined(survival_barricades[i].script_parameters))
			{
				precachemodel(survival_barricades[i].script_parameters);
			}	
		}
	}	
}
	
initCharacterStartIndex()
{
	// Ensure Someone Is Always At The Bus Station To Kick Off The Bus Schedule For Now
	//---------------------------------------------------------------------------------
	level.characterStartIndex = 0 ; //* RandomInt( 4 );
	
	/#
	forceCharacter = GetDvarInt( "zombie_transit_character_force" );
	
	if ( forceCharacter != 0 )
	{
		level.characterStartIndex = forceCharacter - 1;
	}
	#/
}

selectCharacterIndexToUse()
{
	if ( level.characterStartIndex >= 4 )
	{
		level.characterStartIndex = 0;
	}

	self.characterIndex = level.characterStartIndex;
	level.characterStartIndex++;
	
	if ( is_Classic() )
	{
		self thread startingLocationsCustomCharacters();
	}
	
	return self.characterIndex;
}	

giveCustomCharacters()
{
	self DetachAll();
	
	// Only Set Character Index If Not Defined, Since This Thread Gets Called Each Time Player Respawns
	//-------------------------------------------------------------------------------------------------
	if ( !IsDefined( self.characterIndex ) )
	{
		self selectCharacterIndexToUse();
	}
	
	if ( using_team_characters() )
	{
		switch( self.characterIndex )
		{
			case 0:
			case 2:
			{
				// "CIA"
				self setModel("c_zom_player_cia_fb");
				self.voice = "american";
				self.skeleton = "base";
				self SetViewModel( "c_usa_mp_pmc_assault_viewhands" );
				self.characterIndex = 0;
				break;
			}
			case 1:
			case 3:
			{
				// "CDC"
				self setModel("c_zom_player_cdc_fb");
				self.voice = "american";
				self.skeleton = "base";
				self SetViewModel( "c_usa_mp_pmc_assault_viewhands");//"c_usa_mp_sealteam6_assault_viewhands" );
				self.characterIndex = 1;
				break;
			}
		}
	}
	else
	{
		switch( self.characterIndex )
		{
			case 0:
			{
				// "The Douche" -- Temp As Dempsy
				self character\c_usa_dempsey_zm::main();
				self SetViewModel( "viewmodel_usa_pow_arms" );
				self.characterIndex = 0;
				level.vox maps\mp\zombies\_zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );
				break;
			}
			case 1:
			{
				// "The Conspiracy Theorist" -- Temp As Nikolai
				self character\c_rus_nikolai_zm::main();
				self SetViewModel( "viewmodel_rus_prisoner_arms" );
				self.characterIndex = 1;
				level.vox maps\mp\zombies\_zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );
				break;
			}
			case 2:
			{
				// "The Farmers Daughter" -- Temp As Takeo
				self character\c_jap_takeo_zm::main();
				self SetViewModel( "viewmodel_vtn_nva_standard_arms" );
				self.characterIndex = 2;
				level.vox maps\mp\zombies\_zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );
				break;
			}
			case 3:
			{	
				// "Electrical Engineer" -- Temp As Richtofen
				self character\c_ger_richtofen_zm::main();
				self SetViewModel( "viewmodel_usa_hazmat_arms" );
				self.characterIndex = 3;
				level.vox maps\mp\zombies\_zm_audio::zmbVoxInitSpeaker( "player", "vox_plr_", self );
				break;
			}
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

startingLocationsCustomCharacters()
{
	spawnPoint = undefined;
	introLine = undefined;
	
	if ( self is_TheDouche() )
	{
		spawnPoint = getstruct( "douche_initial_spawn_point", "targetname" );
		introLine = "^6Douche: ^7The Douche is here to clean this town out. Which way to the gym?";
	}
	else if ( self is_TheConspiracyTheorist() )
	{
		spawnPoint = getstruct( "theorist_initial_spawn_point", "targetname" );
		introLine = "^6Conspiracy Theorist: ^7Zombies!?!? Government controlled zombies!";
	}
	else if ( self is_TheFarmersDaughter() )
	{
		spawnPoint = getstruct( "daughter_initial_spawn_point", "targetname" );
		introLine = "^6Farmers Daughter: ^7A girl shouldn't have to get up this early. I need a bigger gun.";
	}
	else if ( self is_TheElectricalEngineer() )
	{
		spawnPoint = getstruct( "engineer_initial_spawn_point", "targetname" );
		introLine = "^6Electrical Engineer: ^7A power plant over run with zombies? Well this is shocking.";
	}
	//* self.characterRespawnPoint = spawnPoint;
	//* self thread meetUpWithOtherCharacters();
	self thread speakCustomCharacter( introLine, 10 );
	
	// Don't Move Player If Solo Game
	//-------------------------------
	if ( GET_PLAYERS().size < 2 )
	{
		forcedCharacter = false;
		
		/#
		if ( GetDvarInt( "zombie_transit_character_force" ) != 0 )
		{
			forcedCharacter = true;
		}
		#/
		
		if ( !forcedCharacter )
		{
			return;
		}
	}
	
	//* self SetOrigin( spawnPoint.origin );
	//* self SetPlayerAngles( spawnPoint.angles );
}

// ------------------------------------------------------------------------------------------------
// DCS: custom intermission , will choose closest to players.
// ------------------------------------------------------------------------------------------------
transit_intermission()
{
	self closeMenu();
	self closeInGameMenu();

	level endon( "stop_intermission" );
	self endon("disconnect");
	self endon("death");
	self notify( "_zombie_game_over" ); // ww: notify so hud elements know when to leave

	//Show total gained point for end scoreboard and lobby
	self.score = self.score_total;

	self.sessionstate = "intermission";
	self.spectatorclient = -1; 
	self.killcamentity = -1; 
	self.archivetime = 0; 
	self.psoffsettime = 0; 
	self.friendlydamage = undefined;

	self.game_over_bg = NewClientHudelem( self );
	self.game_over_bg.horzAlign = "fullscreen";
	self.game_over_bg.vertAlign = "fullscreen";
	self.game_over_bg SetShader( "black", 640, 480 );
	self.game_over_bg.alpha = 1;

	// DCS 031312: now attaching to bus
	if(!IsDefined(level.the_bus))
	{
		self.game_over_bg FadeOverTime( 1 );
		self.game_over_bg.alpha = 0;
		wait( 5 );
		self.game_over_bg thread maps\mp\zombies\_zm::fade_up_over_time(1);
	}
	else
	{	
		org = Spawn( "script_model", level.the_bus GetTagOrigin("tag_camera"));
		org SetModel("tag_origin");
		org.angles = level.the_bus GetTagAngles("tag_camera");
		org LinkTo(level.the_bus);

		if(!flag("OnPriDoorYar"))
		{
			flag_set("OnPriDoorYar");
			wait_network_frame();
		}

		//force bus to move
		if(!level.the_bus.isMoving)
		{
			level.the_bus.graceTimeAtDestination = 1;
			level.the_bus notify("depart_early");
		}

		players = GET_PLAYERS();
		for ( j = 0; j < players.size; j++ )
		{
			player = players[j];
			player CameraSetPosition( org );
			player CameraSetLookAt();
			player CameraActivate( true );	
		}

		self.game_over_bg FadeOverTime( 1 );
		self.game_over_bg.alpha = 0;

		wait( 6 );
		self.game_over_bg FadeOverTime( 1 );
		self.game_over_bg.alpha = 1;
		wait( 1 );
	}	
}

// ------------------------------------------------------------------------------------------------


meetUpWithOtherCharacters()
{	
	self endon( "disconnect" );
	
	isAlone = true;
	
	flag_wait( "begin_spawning" );
	
	while ( isAlone )
	{
		players = GET_PLAYERS();
		
		if ( flag( "solo_game" ) )
		{
			break;
		}
		
		foreach ( player in players )
		{
			if ( player == self )
			{
				continue;
			}
			
			if ( DistanceSquared( self.origin, player.origin ) < ( 1024 * 1024 ) )
			{				
			/#	PrintLn( "^2Transit Debug: " + self.name + " met up with " + player.name );	#/
				
				isAlone = false;
			}
		}
		
		wait ( 1 );
	}
	
	self.characterRespawnPoint = undefined;
}

transit_respawn_override( player )
{
	// Spawn Custom Characters Back At Their Designated Spot If They Haven't Met Up With The Group Yet
	//------------------------------------------------------------------------------------------------
	if ( IsDefined( player.characterRespawnPoint ) )
	{
	/#	PrintLn( "^2Transit Debug: Using character respawn point for " + player.name );	#/
		
		return player.characterRespawnPoint.origin;
	}

	return undefined;
}

speakCustomCharacter( text1, duration )
{	
	// TEMP PRINTS TO SCREEN TO FAKE SPEAKING
	self endon( "disconnect" );
	
	subtitle = NewClientHudelem( self );
	subtitle.x = 0;
	subtitle.y = -42;
	subtitle SetText( text1 );
	subtitle.fontScale = 1.46;
	subtitle.alignX = "center";
	subtitle.alignY = "middle";
	subtitle.horzAlign = "center";
	subtitle.vertAlign = "bottom";
	subtitle.sort = 1;

	wait ( duration );
	
	subtitle FadeOverTime( 1.5 );
	subtitle.alpha = 0;
	
	wait ( 1.5 );
	
	subtitle Destroy();
}

//*****************************************************************************
//*****************************************************************************
setup_classic_gametype()
{
	ents = getentarray();
	foreach(ent in ents)
	{
		if(isDefined(ent.script_parameters))
		{
			parameters = strtok(ent.script_parameters," ");
			should_remove = false;
			foreach(parm in parameters)
			{
				if(parm == "survival_remove")
				{
					should_remove = true;
				}
			}
			if(should_remove)
			{
				ent delete();
			}
/*			
			else
			{
				if ( IsDefined( ent.script_vector ) )
				{
					ent MoveTo( ent.origin + ent.script_vector, 0.05 );
					ent waittill( "movedone" );
		
					if ( IsDefined( ent.spawnflags ) && ent.spawnflags == 1 )
					{
						ent DisconnectPaths();
					}
				}
			}
*/			
		}
	}
                
	structs = getstructarray("game_mode_object");
	foreach(struct in structs)
	{
		if(!isDefined(struct.script_string))
		{
			continue;
		}
		tokens = strtok(struct.script_string," ");
		spawn_object = false;
		foreach(parm in tokens)
		{
			if(parm == "survival")
			{
				spawn_object = true;
			}
		}
		
		if( !spawn_object)
		{
			continue;
		}
		barricade = spawn("script_model",struct.origin);
		barricade.angles = struct.angles;
		barricade setmodel(struct.script_parameters);
	}
	unlink_meat_traversal_nodes();
             
}

unlink_meat_traversal_nodes()
{
	//unlink any encounters traversal nodes
	meat_town_nodes = getnodearray("meat_town_barrier_traversals","targetname");
	meat_tunnel_nodes = getnodearray("meat_tunnel_barrier_traversals","targetname");
	meat_farm_nodes = getnodearray("meat_farm_barrier_traversals","targetname");      
                
	nodes = ArrayCombine(meat_town_nodes,meat_tunnel_nodes, true, false);
	traversal_nodes = ArrayCombine(nodes,meat_farm_nodes, true, false);
	foreach(node in traversal_nodes)
	{
		end_node = getnode(node.target,"targetname");
		UnLinkNodes(node,end_node);
	}
}

	

//*****************************************************************************
// Temporarily disable unused use triggers
//*****************************************************************************
disable_triggers()
{
	// welcome center
	trig = GetEntArray("trigger_Keys", "targetname");
	for( i = 0; i< trig.size; i++)
	{
		trig[i] trigger_off();	
	}
			
}	
//*****************************************************************************
// ZONE INIT
//*****************************************************************************
transit_zone_init()
{
	flag_init( "always_on" );
	flag_init("init_classic_adjacencies");
	
	if (is_Classic() )
	{
		flag_set("init_classic_adjacencies");
	}
	flag_set( "always_on" );

	// Bus Station
	add_adjacent_zone( "zone_pri", "zone_station_ext", "OnPriDoorYar" );	

	//gas station / diner
	add_adjacent_zone("zone_roadside_west", "zone_din",	"OnGasDoorDin");
	add_adjacent_zone("zone_roadside_west", "zone_gas",	"always_on");

	add_adjacent_zone("zone_roadside_east", "zone_gas",	"always_on");
	add_adjacent_zone("zone_roadside_east", "zone_gar",	"OnGasDoorGar");

	add_adjacent_zone("zone_trans_diner", "zone_roadside_west",	"always_on", true);
	add_adjacent_zone("zone_trans_diner", "zone_gas",	"always_on", true);
	add_adjacent_zone("zone_trans_diner2", "zone_roadside_east",	"always_on", true);
	
	add_adjacent_zone("zone_gas", "zone_din",	"OnGasDoorDin");
	add_adjacent_zone("zone_gas", "zone_gar",	"OnGasDoorGar");
	add_adjacent_zone("zone_diner_roof", "zone_din",	"OnGasDoorDin", true);

	//cornfield
	add_adjacent_zone("zone_amb_cornfield", "zone_cornfield_prototype",	"always_on");
	
	//Town
	add_adjacent_zone("zone_tow", "zone_bar",	"always_on", true);	//OnTowDoorBar
	add_adjacent_zone("zone_tow", "zone_ban",	"OnTowDoorBan");
	add_adjacent_zone("zone_ban", "zone_ban_vault",	"OnTowBanVault");	

	add_adjacent_zone("zone_tow", "zone_town_north",	"always_on");
	add_adjacent_zone("zone_town_north", "zone_ban",	"OnTowDoorBan");
	
	add_adjacent_zone("zone_tow", "zone_town_west",	"always_on");

	add_adjacent_zone("zone_tow", "zone_town_south",	"always_on");	
	add_adjacent_zone("zone_town_south", "zone_town_barber",	"always_on", true);	
	add_adjacent_zone("zone_town_south", "zone_town_church",	"init_classic_adjacencies");	

	add_adjacent_zone("zone_tow", "zone_town_east",	"always_on");	
	add_adjacent_zone("zone_town_east", "zone_bar",	"OnTowDoorBar");	
	
	add_adjacent_zone("zone_tow", "zone_town_barber",	"always_on", true);	//OnTowDoorBarber
	add_adjacent_zone("zone_town_barber", "zone_town_west",	"OnTowDoorBarber");

	// farm
	add_adjacent_zone("zone_far", "zone_far_ext",	"OnFarm_enter");	
	add_adjacent_zone("zone_far_ext", "zone_brn",	"always_on");	
	add_adjacent_zone("zone_far_ext", "zone_farm_house",	"open_farmhouse");

	// power station.
	add_adjacent_zone("zone_prr", "zone_pow",	"OnPowDoorRR", true);
	add_adjacent_zone("zone_pcr", "zone_prr",	"OnPowDoorRR");
	add_adjacent_zone("zone_pcr", "zone_pow_warehouse",	"OnPowDoorWH");
	add_adjacent_zone("zone_pow", "zone_pow_warehouse",	"OnPowDoorWH");	

	add_adjacent_zone("zone_trans_pow_ext1", "zone_trans_7",	"always_on");

	// bunkers
	add_adjacent_zone("zone_tbu",		"zone_tow", "vault_opened"); //one way connection.

	//bus transitional zones.
	//zone_trans_1:  station to bridge
	//zone_trans_2:  station to tunnel
	//zone_trans_3:  tunnel to diner
	//zone_trans_4:  diner to forest
	//zone_trans_5:  forest to farm
	//zone_trans_6:  farm to cornfield
	//zone_trans_7:  cornfield to powerstation
	//zone_trans_8:  powerstation to powerstation forest ambush
	//zone_trans_9:  powerstation forest ambush to town
	//zone_trans_10:  town to bridge
}	


include_powerups()
{
	include_powerup( "nuke" );
	include_powerup( "insta_kill" );
	include_powerup( "double_points" );
	include_powerup( "full_ammo" );
	include_powerup( "carpenter" );

	if( is_Encounter() )
	{ 
		include_powerup( "minigun" );
	}
}

include_equipment_for_level()
{
	include_equipment( "jetgun_zm" );
	include_equipment( "riotshield_zm" );
	include_equipment( "equip_turbine_zm" );
	include_equipment( "equip_turret_zm" );
	include_equipment( "equip_electrictrap_zm" );
}


claymore_safe_to_plant()
{
	if ( self maps\mp\zm_transit_lava::object_touching_lava() )
		return false;
	if ( self.owner maps\mp\zm_transit_lava::object_touching_lava() )
		return false;
	return true;
}

grenade_safe_to_throw(player,weapname)
{
	return true;
}

grenade_safe_to_bounce(player,weapname)
{
	if (!is_offhand_weapon(weapname))
		return true;
	if ( self maps\mp\zm_transit_lava::object_touching_lava() )
		return false;
	return true;
}


offhand_weapon_overrride()
{
	register_lethal_grenade_for_level( "frag_grenade_zm" );
	level.zombie_lethal_grenade_player_init = "frag_grenade_zm";
	register_lethal_grenade_for_level( "sticky_grenade_zm" );

	register_tactical_grenade_for_level( "zombie_cymbal_monkey" );
	register_tactical_grenade_for_level( "emp_grenade_zm" );
	level.zombie_tactical_grenade_player_init = undefined;

	level.grenade_safe_to_throw = ::grenade_safe_to_throw;
	level.grenade_safe_to_bounce = ::grenade_safe_to_bounce;

	register_placeable_mine_for_level( "claymore_zm" );
	level.zombie_placeable_mine_player_init = undefined;
	level.claymore_safe_to_plant = ::claymore_safe_to_plant;

	register_melee_weapon_for_level( "knife_zm" );
	register_melee_weapon_for_level( "bowie_knife_zm" );
	register_melee_weapon_for_level( "tazer_knuckles_zm" );
	level.zombie_melee_weapon_player_init = "knife_zm";

	register_equipment_for_level( "jetgun_zm" );
	register_equipment_for_level( "riotshield_zm" );
	register_equipment_for_level( "equip_turbine_zm" );
	register_equipment_for_level( "equip_turret_zm" );
	register_equipment_for_level( "equip_electrictrap_zm" );
	level.zombie_equipment_player_init = undefined;
}

include_weapons()
{
	//Weapons - Pistols	
	include_weapon( "knife_zm", false );
	include_weapon( "frag_grenade_zm", false );
	include_weapon( "claymore_zm", false );
	include_weapon( "sticky_grenade_zm", false );

	//	Weapons - Pistols
	include_weapon( "m1911_zm", false );
	include_weapon( "m1911_upgraded_zm", false );
	include_weapon( "python_zm" );
	include_weapon( "python_upgraded_zm", false );
	include_weapon( "judge_zm" );
	include_weapon( "judge_upgraded_zm", false );
	include_weapon( "kard_zm" );
	include_weapon( "kard_upgraded_zm", false );
  	include_weapon( "fiveseven_zm" );
  	include_weapon( "fiveseven_upgraded_zm", false );
	include_weapon( "beretta93r_zm", false );
	include_weapon( "beretta93r_upgraded_zm", false );

	//	Weapons - Dual Wield
  	include_weapon( "fivesevendw_zm" );
  	include_weapon( "fivesevendw_upgraded_zm", false );

	//	Weapons - SMGs
	include_weapon( "ak74u_zm", false );
	include_weapon( "ak74u_upgraded_zm", false );
	include_weapon( "mp5k_zm", false );
	include_weapon( "mp5k_upgraded_zm", false );
	include_weapon( "qcw05_zm" );
	include_weapon( "qcw05_upgraded_zm", false );

	//	Weapons - Shotguns
	include_weapon( "870mcs_zm", false );
	include_weapon( "870mcs_upgraded_zm", false );
	include_weapon( "rottweil72_zm", false );
	include_weapon( "rottweil72_upgraded_zm", false );
	include_weapon( "saiga12_zm" );
	include_weapon( "saiga12_upgraded_zm", false );
	include_weapon( "srm1216_zm" );
	include_weapon( "srm1216_upgraded_zm", false );

	//	Weapons - Rifles
	include_weapon( "m14_zm", false );
	include_weapon( "m14_upgraded_zm", false );
	include_weapon( "saritch_zm" );
	include_weapon( "saritch_upgraded_zm", false );
	include_weapon( "m16_zm", false );						
	include_weapon( "m16_gl_upgraded_zm", false );
	include_weapon( "xm8_zm" );
	include_weapon( "xm8_upgraded_zm", false );
	include_weapon( "type95_zm" );
	include_weapon( "type95_upgraded_zm", false );
	include_weapon( "tar21_zm" );
	include_weapon( "tar21_upgraded_zm", false );
	include_weapon( "galil_zm" );
	include_weapon( "galil_upgraded_zm", false );
	include_weapon( "fnfal_zm" );
	include_weapon( "fnfal_upgraded_zm", false );

	//	Weapons - Sniper Rifles
	include_weapon( "dsr50_zm" );
	include_weapon( "dsr50_upgraded_zm", false );
	include_weapon( "barretm82_zm" );
	include_weapon( "barretm82_upgraded_zm", false );

	//	Weapons - Machineguns
	include_weapon( "rpd_zm" );
	include_weapon( "rpd_upgraded_zm", false );
	include_weapon( "hamr_zm" );
	include_weapon( "hamr_upgraded_zm", false );

	//	Weapons - Misc
	include_weapon( "usrpg_zm" );
	include_weapon( "usrpg_upgraded_zm", false );
	include_weapon( "m32_zm" );
	include_weapon( "m32_upgraded_zm", false );
	include_weapon( "xm25_zm" );
	include_weapon( "xm25_upgraded_zm", false );
	
	if( is_Encounter() )
		include_weapon( "minigun_zm" );

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
	//include_weapon( "crossbow_explosive_zm" );
	//include_weapon( "crossbow_explosive_upgraded_zm", false );
	//precacheItem( "explosive_bolt_zm" );
	//precacheItem( "explosive_bolt_upgraded_zm" );
	include_weapon( "jetgun_zm", false );
	//include_weapon( "jetgun_upgraded_zm", false );
	include_weapon( "riotshield_zm", false );

	include_weapon( "tazer_knuckles_zm", false );
	include_weapon( "knife_ballistic_no_melee_zm", false );
	include_weapon( "knife_ballistic_no_melee_upgraded_zm", false );
	include_weapon( "knife_ballistic_zm" );
	include_weapon( "knife_ballistic_upgraded_zm", false );
	include_weapon( "knife_ballistic_bowie_zm", false );
	include_weapon( "knife_ballistic_bowie_upgraded_zm", false );
	level._uses_retrievable_ballisitic_knives = true;

	if( is_Classic() )
		include_weapon( "screecher_arms_zm", false );

	// limited weapons
	add_limited_weapon( "m1911_zm", 0 );
	//add_limited_weapon( "crossbow_explosive_zm", 1 );
	add_limited_weapon( "knife_ballistic_zm", 1 );
	add_limited_weapon( "xm25_zm", 1 );
	add_limited_weapon( "jetgun_zm", 1 );
	//add_limited_weapon( "riotshield_zm", 1 );

	// get the bowie into the collector achievement list
//	ARRAY_ADD( level.collector_achievement_weapons, "bowie_knife_zm" );
}


custom_add_weapons()
{
	add_zombie_weapon( "m1911_zm",					"m1911_upgraded_zm",					&"ZOMBIE_WEAPON_M1911",					50,		"pistol",			"",		undefined );
	add_zombie_weapon( "python_zm",					"python_upgraded_zm",					&"ZOMBIE_WEAPON_PYTHON",				50,		"pistol",			"",		undefined );
	add_zombie_weapon( "judge_zm",					"judge_upgraded_zm",					&"ZOMBIE_WEAPON_JUDGE",					50,		"pistol",			"",		undefined );
	add_zombie_weapon( "kard_zm",					"kard_upgraded_zm",						&"ZOMBIE_WEAPON_KARD",					50,		"pistol",			"",		undefined );
	add_zombie_weapon( "fiveseven_zm",				"fiveseven_upgraded_zm",				&"ZOMBIE_WEAPON_FIVESEVEN",				50,		"pistol",			"",		undefined );
	add_zombie_weapon( "beretta93r_zm",				"beretta93r_upgraded_zm",				&"ZOMBIE_WEAPON_BERETTA93r",			1000,	"pistol",			"",		undefined );

	//Dual Wield
	add_zombie_weapon( "fivesevendw_zm",			"fivesevendw_upgraded_zm",				&"ZOMBIE_WEAPON_FIVESEVENDW",			50,		"dualwield",		"",		undefined );

	//SMGs
	add_zombie_weapon( "ak74u_zm",					"ak74u_upgraded_zm",					&"ZOMBIE_WEAPON_AK74U",					1200,	"smg",				"",		undefined );
	add_zombie_weapon( "mp5k_zm",					"mp5k_upgraded_zm",						&"ZOMBIE_WEAPON_MP5K",					1000,	"smg",				"",		undefined );
	add_zombie_weapon( "qcw05_zm",					"qcw05_upgraded_zm",					&"ZOMBIE_WEAPON_QCW05",					50,		"smg",				"",		undefined );

	//Shotguns
	add_zombie_weapon( "870mcs_zm",					"870mcs_upgraded_zm",					&"ZOMBIE_WEAPON_870MCS",				1500,	"shotgun",			"",		undefined );
	add_zombie_weapon( "rottweil72_zm",				"rottweil72_upgraded_zm",				&"ZOMBIE_WEAPON_ROTTWEIL72",			500,	"shotgun",			"",		undefined );
	add_zombie_weapon( "saiga12_zm",				"saiga12_upgraded_zm",					&"ZOMBIE_WEAPON_SAIGA12",				50,		"shotgun",			"",		undefined );
	add_zombie_weapon( "srm1216_zm",				"srm1216_upgraded_zm",					&"ZOMBIE_WEAPON_SRM1216",				50,		"shotgun",			"",		undefined );

	//Rifles
	add_zombie_weapon( "m14_zm",					"m14_upgraded_zm",						&"ZOMBIE_WEAPON_M14",					500,	"rifle",			"",		undefined );
	add_zombie_weapon( "saritch_zm",				"saritch_upgraded_zm",					&"ZOMBIE_WEAPON_SARITCH",				50,		"rifle",			"",		undefined );
	add_zombie_weapon( "m16_zm",					"m16_gl_upgraded_zm",					&"ZOMBIE_WEAPON_M16",					1200,	"burstrifle",		"",		undefined );
	add_zombie_weapon( "xm8_zm",					"xm8_upgraded_zm",						&"ZOMBIE_WEAPON_XM8",					50,		"burstrifle",		"",		undefined );
	add_zombie_weapon( "type95_zm",					"type95_upgraded_zm",					&"ZOMBIE_WEAPON_TYPE95",				50,		"assault",			"",		undefined );
	add_zombie_weapon( "tar21_zm",					"tar21_upgraded_zm",					&"ZOMBIE_WEAPON_TAR21",					50,		"assault",			"",		undefined );
	add_zombie_weapon( "galil_zm",					"galil_upgraded_zm",					&"ZOMBIE_WEAPON_GALIL",					50,		"assault",			"",		undefined );
	add_zombie_weapon( "fnfal_zm",					"fnfal_upgraded_zm",					&"ZOMBIE_WEAPON_FNFAL",					50,		"burstrifle",		"",		undefined );

	//Sniper Rifles
	add_zombie_weapon( "dsr50_zm",					"dsr50_upgraded_zm",					&"ZOMBIE_WEAPON_DR50",					50,		"sniper",			"",		undefined );
	add_zombie_weapon( "barretm82_zm",				"barretm82_upgraded_zm",				&"ZOMBIE_WEAPON_BARRETM82",				50,		"sniper",			"",		undefined );

	//Light Machineguns
	add_zombie_weapon( "rpd_zm",					"rpd_upgraded_zm",						&"ZOMBIE_WEAPON_RPD",					50,		"mg",				"",		undefined );
	add_zombie_weapon( "hamr_zm",					"hamr_upgraded_zm",						&"ZOMBIE_WEAPON_HAMR",					50,		"mg",				"",		undefined );

	//Grenades                                         		
	add_zombie_weapon( "frag_grenade_zm", 			undefined,								&"ZOMBIE_WEAPON_FRAG_GRENADE",			250,	"grenade",			"",		undefined );
	add_zombie_weapon( "sticky_grenade_zm", 		undefined,								&"ZOMBIE_WEAPON_STICKY_GRENADE",		250,	"grenade",			"",		undefined );
	add_zombie_weapon( "claymore_zm", 				undefined,								&"ZOMBIE_WEAPON_CLAYMORE",				1000,	"grenade",			"",		undefined );

	//Rocket Launchers
	add_zombie_weapon( "usrpg_zm", 					"usrpg_upgraded_zm",					&"ZOMBIE_WEAPON_USRPG",	 				50,		"launcher",			"",		undefined ); 
	add_zombie_weapon( "m32_zm", 					"m32_upgraded_zm",						&"ZOMBIE_WEAPON_M32", 					50,		"launcher",			"",		undefined ); 
	add_zombie_weapon( "xm25_zm", 					"xm25_upgraded_zm",						&"ZOMBIE_WEAPON_XM25", 					50,		"launcher",			"",		undefined ); 


	//Special                                          	
 	add_zombie_weapon( "zombie_cymbal_monkey",		undefined,								&"ZOMBIE_WEAPON_SATCHEL_2000", 			2000,	"monkey",			"",		undefined );
	add_zombie_weapon( "emp_grenade_zm", 			undefined,								&"ZOMBIE_WEAPON_EMP_GRENADE",			2000,	"grenade",			"",		undefined );

 	add_zombie_weapon( "ray_gun_zm", 				"ray_gun_upgraded_zm",					&"ZOMBIE_WEAPON_RAYGUN", 				10000,	"raygun",			"",		undefined );
 	//add_zombie_weapon( "crossbow_explosive_zm",		"crossbow_explosive_upgraded_zm",		&"ZOMBIE_WEAPON_CROSSBOW_EXPOLOSIVE",	10,		"crossbow",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_zm",		"knife_ballistic_upgraded_zm",			&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_bowie_zm",	"knife_ballistic_bowie_upgraded_zm",	&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );
 	add_zombie_weapon( "knife_ballistic_no_melee_zm","knife_ballistic_no_melee_upgraded_zm",&"ZOMBIE_WEAPON_KNIFE_BALLISTIC",		10,		"sickle",			"",		undefined );

	add_zombie_weapon( "riotshield_zm",				undefined,								&"ZOMBIE_WEAPON_RIOTSHIELD", 			2000,	"riot",				"",		undefined );
	add_zombie_weapon( "jetgun_zm",					undefined,								&"ZOMBIE_WEAPON_JETGUN", 				2000,	"jet",				"",		undefined );
 	add_zombie_weapon( "tazer_knuckles_zm",			undefined,								&"ZOMBIE_WEAPON_TAZER_KNUCKLES", 		100,	"tazerknuckles",	"",		undefined );
}


include_buildables()
{
	// RiotShield WallBuy
	//-------------------
	
	riotShield = SpawnStruct();
	riotShield.name = "riotshield_zm";
	riotShield create_zombie_buildable_piece( "t6_wpn_zmb_shield_dolly", 20, 64, "zm_hud_icon_dolly" );
	riotShield create_zombie_buildable_piece( "t6_wpn_zmb_shield_door", 32, 15, "zm_hud_icon_cardoor" );
	riotShield.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_RiotShield;
	riotShield.onCantUse = maps\mp\zm_transit_buildables::onCantUse_RiotShield;
	riotShield.onDrop = maps\mp\zm_transit_buildables::onDrop_RiotShield;
	riotShield.onEndUse = maps\mp\zm_transit_buildables::onEndUse_RiotShield;
	riotShield.onPickup = maps\mp\zm_transit_buildables::onPickup_RiotShield;
	riotShield.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_RiotShield;
	
	include_buildable( riotShield );
	
	// CattleCatcher Bus Upgrade
	//--------------------------
	
	cattleCatcher = SpawnStruct();
	cattleCatcher.name = "cattlecatcher";
	cattleCatcher create_zombie_buildable_piece( "zb_plow", 128, 100, "zm_hud_icon_plow" );
	cattleCatcher.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_CattleCatcher;
	cattleCatcher.onCantUse = maps\mp\zm_transit_buildables::onCantUse_CattleCatcher;
	cattleCatcher.onDrop = maps\mp\zm_transit_buildables::onDrop_CattleCatcher;
	cattleCatcher.onEndUse = maps\mp\zm_transit_buildables::onEndUse_CattleCatcher;
	cattleCatcher.onPickup = maps\mp\zm_transit_buildables::onPickup_CattleCatcher;
	cattleCatcher.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_CattleCatcher;
	
	include_buildable( cattleCatcher );
	
	// Power Switch
	//-------------
	
	powerSwitch = SpawnStruct();
	powerSwitch.name = "powerswitch";
	powerSwitch create_zombie_buildable_piece( "p_zom_pack_a_punch_battery", 20, 64, "zm_hud_icon_battery" );
	powerSwitch create_zombie_buildable_piece( "p_zom_moon_power_lever_short", 32, 64, "zm_hud_icon_panel" );
	powerSwitch create_zombie_buildable_piece( "p6_power_lever", 32, 15, "zm_hud_icon_lever" );
	powerSwitch.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_PowerSwitch;
	powerSwitch.onCantUse = maps\mp\zm_transit_buildables::onCantUse_PowerSwitch;
	powerSwitch.onDrop = maps\mp\zm_transit_buildables::onDrop_PowerSwitch;
	powerSwitch.onEndUse = maps\mp\zm_transit_buildables::onEndUse_PowerSwitch;
	powerSwitch.onPickup = maps\mp\zm_transit_buildables::onPickup_PowerSwitch;
	powerSwitch.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_PowerSwitch;
	
	include_buildable( powerSwitch );
	
	// Pack A Punch
	//-------------
	
	packAPunch = SpawnStruct();
	packAPunch.name = "pap";
	packAPunch create_zombie_buildable_piece( "p_zom_pack_a_punch_battery", 20, 64, "zm_hud_icon_battery" );
	packAPunch create_zombie_buildable_piece( "zombie_vending_packapunch", 32, 64, "zm_hud_icon_papbody" );
	packAPunch create_zombie_buildable_piece( "ap_table_leg_destroyed", 32, 15, "zm_hud_icon_chairleg" );
	packAPunch.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_PackAPunch;
	packAPunch.onCantUse = maps\mp\zm_transit_buildables::onCantUse_PackAPunch;
	packAPunch.onDrop = maps\mp\zm_transit_buildables::onDrop_PackAPunch;
	packAPunch.onEndUse = maps\mp\zm_transit_buildables::onEndUse_PackAPunch;
	packAPunch.onPickup = maps\mp\zm_transit_buildables::onPickup_PackAPunch;
	packAPunch.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_PackAPunch;
	
	include_buildable( packAPunch );
	
	// Turbine
	//--------
	turbine = SpawnStruct();
	turbine.name = "turbine";
	turbine create_zombie_buildable_piece( "p6_wind_turbine_small_fan", 20, 64, "zm_hud_icon_fan" );
	turbine create_zombie_buildable_piece( "zombie_machine_panel", 32, 64, "zm_hud_icon_rudder" );
	turbine create_zombie_buildable_piece( "static_zombie_mannequin", 32, 15, "zm_hud_icon_mannequin" );
	turbine.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_Turbine;
	turbine.onCantUse = maps\mp\zm_transit_buildables::onCantUse_Turbine;
	turbine.onDrop = maps\mp\zm_transit_buildables::onDrop_Turbine;
	turbine.onEndUse = maps\mp\zm_transit_buildables::onEndUse_Turbine;
	turbine.onPickup = maps\mp\zm_transit_buildables::onPickup_Turbine;
	turbine.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_Turbine;
	
	include_buildable( turbine );
	
	// Turret
	//--------
	turret = SpawnStruct();
	turret.name = "turret";
	turret create_zombie_buildable_piece( "veh_t6_drone_big_dog_turret", 20, 64, "zm_hud_icon_turrethead" );
	turret create_zombie_buildable_piece( "ch_lawnmower", 32, 64, "zm_hud_icon_lawnmower" );
	turret create_zombie_buildable_piece( "p_glo_ammo_box", 32, 15, "zm_hud_icon_ammobox" );
	turret.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_Turret;
	turret.onCantUse = maps\mp\zm_transit_buildables::onCantUse_Turret;
	turret.onDrop = maps\mp\zm_transit_buildables::onDrop_Turret;
	turret.onEndUse = maps\mp\zm_transit_buildables::onEndUse_Turret;
	turret.onPickup = maps\mp\zm_transit_buildables::onPickup_Turret;
	turret.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_Turret;
	
	include_buildable( turret );
	
	// ElectricTrap
	//--------
	electric_trap = SpawnStruct();
	electric_trap.name = "electric_trap";
	electric_trap create_zombie_buildable_piece( "machinery_cable_spool1", 20, 64, "zm_hud_icon_spool" );
	electric_trap create_zombie_buildable_piece( "zombie_zapper_tesla_coil", 32, 64, "zm_hud_icon_coil" );
	electric_trap create_zombie_buildable_piece( "p_zom_pack_a_punch_battery", 32, 15, "zm_hud_icon_battery" );
	electric_trap.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_ElectricTrap;
	electric_trap.onCantUse = maps\mp\zm_transit_buildables::onCantUse_ElectricTrap;
	electric_trap.onDrop = maps\mp\zm_transit_buildables::onDrop_ElectricTrap;
	electric_trap.onEndUse = maps\mp\zm_transit_buildables::onEndUse_ElectricTrap;
	electric_trap.onPickup = maps\mp\zm_transit_buildables::onPickup_ElectricTrap;
	electric_trap.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_ElectricTrap;
	
	include_buildable( electric_trap );
	
	// JetGun
	//--------
	jetgun = SpawnStruct();
	jetgun.name = "jetgun_zm";
	jetgun create_zombie_buildable_piece( "machinery_cable_spool1", 20, 64, "zm_hud_icon_spool" );
	jetgun create_zombie_buildable_piece( "zombie_zapper_tesla_coil", 32, 64, "zm_hud_icon_coil" );
	jetgun create_zombie_buildable_piece( "p6_wind_turbine_small_fan", 32, 15, "zm_hud_icon_fan" );
	jetgun create_zombie_buildable_piece( "ch_lawnmower", 32, 15, "zm_hud_icon_lawnmower" );
	jetgun.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_JetGun;
	jetgun.onCantUse = maps\mp\zm_transit_buildables::onCantUse_JetGun;
	jetgun.onDrop = maps\mp\zm_transit_buildables::onDrop_JetGun;
	jetgun.onEndUse = maps\mp\zm_transit_buildables::onEndUse_JetGun;
	jetgun.onPickup = maps\mp\zm_transit_buildables::onPickup_JetGun;
	jetgun.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_JetGun;
	
	include_buildable( jetgun );
	
	// BusHatch
	//--------- 
	bushatch = SpawnStruct();
	bushatch.name = "bushatch";
	bushatch create_zombie_buildable_piece( "p_rus_hatch_01_clsd", 20, 64, "zm_hud_icon_hatch" );
	bushatch.onBeginUse = maps\mp\zm_transit_buildables::onBeginUse_BusHatch;
	bushatch.onCantUse = maps\mp\zm_transit_buildables::onCantUse_BusHatch;
	bushatch.onDrop = maps\mp\zm_transit_buildables::onDrop_BusHatch;
	bushatch.onEndUse = maps\mp\zm_transit_buildables::onEndUse_BusHatch;
	bushatch.onPickup = maps\mp\zm_transit_buildables::onPickup_BusHatch;
	bushatch.onUsePlantObject = maps\mp\zm_transit_buildables::onUsePlantObject_BusHatch;
	
	include_buildable( bushatch );
}

include_game_modules()
{
	//RACE
	maps\mp\zombies\_zm_game_module_race::register_game_module();
	maps\mp\zombies\_zm_game_module_race::register_race(maps\mp\zm_transit_race_town::race_start,maps\mp\zm_transit_race_town::race_end,"zm_transit_town_zrace","town");
	maps\mp\zombies\_zm_game_module_race::register_race(maps\mp\zm_transit_race_tunnel::race_start,maps\mp\zm_transit_race_tunnel::race_end,"zm_transit_tunnel_zrace","tunnel");
	maps\mp\zombies\_zm_game_module_race::register_race(maps\mp\zm_transit_race_farm::race_start,maps\mp\zm_transit_race_farm::race_end,"zm_transit_farm_zrace","farm");
	maps\mp\zombies\_zm_game_module_race::register_race(maps\mp\zm_transit_race_power::race_start,maps\mp\zm_transit_race_power::race_end,"zm_transit_power_zrace","power");
	
	
	//MEAT
	maps\mp\zombies\_zm_game_module_meat::register_game_module();	
	maps\mp\zombies\_zm_game_module_meat::register_meat_match(maps\mp\zm_transit_meat_town::meat_start,maps\mp\zombies\_zm_game_module_meat::meat_end_match,"zm_transit_town_zmeat",undefined,"town");
	maps\mp\zombies\_zm_game_module_meat::register_meat_match(maps\mp\zm_transit_meat_tunnel::meat_start,maps\mp\zombies\_zm_game_module_meat::meat_end_match,"zm_transit_tunnel_zmeat",undefined,"tunnel");
	maps\mp\zombies\_zm_game_module_meat::register_meat_match(maps\mp\zm_transit_meat_farm::meat_start,maps\mp\zombies\_zm_game_module_meat::meat_end_match,"zm_transit_farm_zmeat",undefined,"farm");

	//TURNED
	maps\mp\zombies\_zm_game_module_turned::register_game_module();	
	maps\mp\zombies\_zm_game_module_turned::register_turned_match( maps\mp\zm_transit_turned_town::onStartGameType, maps\mp\zm_transit_turned_town::onEndGame, "zm_transit_town_zturned" );
	
	//NO MANS LAND
	maps\mp\zombies\_zm_game_module_nml::register_game_module();
	maps\mp\zombies\_zm_game_module_nml::register_nml_match( maps\mp\zm_transit_nml_town::onStartGameType, maps\mp\zm_transit_nml_town::onEndGame, "zm_transit_town_znml", "town" );
	maps\mp\zombies\_zm_game_module_nml::register_nml_match( maps\mp\zm_transit_nml_cornfield::onStartGameType, maps\mp\zm_transit_nml_cornfield::onEndGame, "zm_transit_cornfield_znml", "cornfield" );
	
	//PITTED  
	maps\mp\zombies\_zm_game_module_pitted::register_game_module();
	maps\mp\zombies\_zm_game_module_pitted::register_pitted_match( maps\mp\zm_transit_nml_town::onStartGameType, maps\mp\zm_transit_nml_town::onEndGame, "zm_transit_town_zpitted", "town" );
	
	//CLEANSED
	maps\mp\zombies\_zm_game_module_cleansed::register_game_module();	
	maps\mp\zombies\_zm_game_module_cleansed::register_cleansed_match( maps\mp\zm_transit_turned_town::onStartGameType, maps\mp\zm_transit_turned_town::onEndGame, "zm_transit_town_zcleansed" );
	maps\mp\zombies\_zm_game_module_cleansed::register_cleansed_match( maps\mp\zm_transit_turned_farm::onStartGameType, maps\mp\zm_transit_turned_farm::onEndGame, "zm_transit_farm_zcleansed" );
	
	//GRIEF
	maps\mp\zombies\_zm_game_module_grief::register_game_module();	
	maps\mp\zombies\_zm_game_module_grief::register_grief_match( maps\mp\zm_transit_grief_town::onStartGameType, maps\mp\zm_transit_grief_town::onEndGame, "zm_transit_town_zgrief" );
	maps\mp\zombies\_zm_game_module_grief::register_grief_match( maps\mp\zm_transit_grief_farm::onStartGameType, maps\mp\zm_transit_grief_farm::onEndGame, "zm_transit_farm_zgrief" );
	maps\mp\zombies\_zm_game_module_grief::register_grief_match( maps\mp\zm_transit_grief_station::onStartGameType, maps\mp\zm_transit_grief_station::onEndGame, "zm_transit_transit_zgrief" );

	//STANDARD (SURVIVAL)
	maps\mp\zombies\_zm_game_module_standard::register_game_module();
	maps\mp\zombies\_zm_game_module_standard::register_standard_match( maps\mp\zm_transit_standard_farm::standard_start, "zm_transit_farm_zstandard", "farm" );
	maps\mp\zombies\_zm_game_module_standard::register_standard_match( maps\mp\zm_transit_standard_town::standard_start, "zm_transit_town_zstandard", "town" );
	maps\mp\zombies\_zm_game_module_standard::register_standard_match( maps\mp\zm_transit_standard_station::standard_start, "zm_transit_transit_zstandard", "transit" );
}


start_classic_game_mode()
{
	level thread setup_classic_gametype();
	level thread maps\mp\zombies\_zm::round_start();	
}

initial_round_wait_func()
{
	// wait for the end of _zm_game_module::module_hud_connecting(); above	
	flag_wait("initial_blackscreen_passed");
}

start_turned_game_mode()
{
	level thread maps\mp\zombies\_zm_game_module_cleansed::onStartGameType( "transit_town_zturned" );
}


setup_dvars()
{
	/#
	dvars = [];
	dvars[dvars.size] = "zombie_bus_debug_path";
	dvars[dvars.size] = "zombie_bus_debug_speed";
	dvars[dvars.size] = "zombie_bus_debug_near";
	dvars[dvars.size] = "zombie_bus_debug_attach";
	dvars[dvars.size] = "zombie_bus_skip_objectives";
	dvars[dvars.size] = "zombie_bus_debug_spawners";

	for ( i = 0; i < dvars.size; i++ )
	{
		if ( GetDvar(dvars[i]) == "" )
		{
			SetDvar(dvars[i], "0");
		}
	}
    #/
}

setup_zombie_init()
{
	zombies = getEntArray( "zombie_spawner", "script_noteworthy" ); 
	array_thread( zombies, ::add_spawn_function, ::custom_zombie_setup );
}

setup_players()
{
	self.isOnBus = false;
	self.isOnBusRoof = false;
	self.isInHub = true;
	self.inSafeArea = true;
}

canPlayerSuicide()
{
	return self HasPerk("specialty_scavenger");
}

transit_player_fake_death(vDir)
{
	level notify ("fake_death");
	self notify ("fake_death");

	self.ignoreme = true;
	self EnableInvulnerability();
	self TakeAllWeapons();
	if ( isdefined( self.isOnBus ) && self.isOnBus )
	{
		self AllowStand( false );
		self AllowCrouch( false );
		self AllowProne( true );
		wait 0.5;
		self FreezeControls( true );
		wait 0.5;
	}
	else
	{
		self FreezeControls( true );
		self thread fall_down(vDir);
		wait 1;
	}
}

fall_down(vDir)
{
	self endon("disconnect");
	level endon("game_module_ended");

	origin = self.origin;
	xyspeed = ( 0, 0, 0 );
	angles = self getplayerangles();
	angles = ( angles[0], angles[1], angles[2] + RandomFloatRange( -5, 5 ) );  

	if (isDefined(vDir) && Length(vDir) > 0)
	{
		XYSpeedMag = 40 + randomint(12) + randomint(12);
		xyspeed = XYSpeedMag * vectornormalize(( vDir[ 0 ], vDir[ 1 ], 0 ) );
	}

	linker = spawn( "script_origin", ( 0, 0, 0 ) );
	linker.origin = origin;
	linker.angles = angles;
	self._fall_down_anchor = linker;
	self playerlinkto( linker );
	self playsoundtoplayer( "zmb_player_death_fall", self );

	origin = PlayerPhysicsTrace( origin, origin + xyspeed );
	origin = origin + (0,0,-52); 

	lerptime = 0.5;

	linker moveto( origin, lerptime, lerptime );
	linker rotateto( angles, lerptime, lerptime );
	self FreezeControls( true );
	linker waittill( "movedone" );


	self GiveWeapon("death_throe_zm");
	self SwitchToWeapon("death_throe_zm");

	bounce = randomint(4) + 8; 
	origin = origin + (0,0,bounce) - ( xyspeed * 0.1 );
	lerptime = bounce / 50.0;

	linker moveto( origin, lerptime, 0, lerptime );
	linker waittill( "movedone" );

	origin = origin + (0,0,-bounce) + ( xyspeed * 0.1 );
	lerptime = lerptime / 2.0;

	linker moveto( origin, lerptime, lerptime );
	linker waittill( "movedone" );

	linker moveto( origin, 5, 0 );
	wait 5;
	linker delete();


}

transit_player_fake_death_cleanup()
{
	if(isDefined(self._fall_down_anchor))
	{
		self._fall_down_anchor delete();
		self._fall_down_anchor = undefined;
	}	
}

// initialize any vars we need on the zombies 
custom_zombie_setup()
{
	if ( is_Survival() && !is_Standard())
	{
		self.nearBus = false;
		self.isOnBus = false;
		self.isOnBusRoof = false;
		self.was_walking = false;
		self.canDropSafeKey 	= true;
		self.canDropBusKey 		= true;
		self.custom_points_on_turret_damage = 0;
	}
}


// ------------------------------------------------------------------------------------------------
// DCS 021712: Breachable Bank Vault.
// ------------------------------------------------------------------------------------------------
transit_vault_breach_init()
{
	vault_door = GetEntArray("town_bunker_door","targetname");
	//flag_init("vault_opened");

	if(IsDefined(vault_door))
	{
		for ( i = 0; i < vault_door.size; i++ )
		{
			if(Isdefined(vault_door[i].classname) && vault_door[i].classname == "script_brushmodel")
			{
				clip = vault_door[i];
			}
			else if(Isdefined(vault_door[i].classname) && vault_door[i].classname == "script_model")
			{
				level.vault =  vault_door[i];
				level.vault.damage_state = 0;
			}
		}
		
		if(IsDefined(clip) && IsDefined(level.vault))
		{
			clip LinkTo(level.vault);
			level.vault.clip = clip;	
		}
			
		if(IsDefined(level.vault))
		{
			level.vault thread vault_breach_think();
		}
	}
	else
	{
		return;
	}	
	
	OnPlayerConnect_Callback(::check_for_grenade_throw);		
}

vault_breach_think()
{
	level endon("intermission");

	self.health = 99999;
	self SetCanDamage( true );
	self.damage_state = 0;
	
	while(true)
	{
		self waittill( "damage", amount, attacker, direction, point, dmg_type);		
			
		if( isplayer( attacker ) && ( 	dmg_type == "MOD_PROJECTILE" || dmg_type == "MOD_PROJECTILE_SPLASH" 
																|| 	dmg_type == "MOD_EXPLOSIVE" || dmg_type == "MOD_EXPLOSIVE_SPLASH" 
																|| 	dmg_type == "MOD_GRENADE" || dmg_type == "MOD_GRENADE_SPLASH" ) )
		{
			//IPrintLnBold( "BANG GOES Vault" );
			if( self.damage_state == 0 ) //no damage yet
			{
				self.damage_state = 1;
			}
		
			PlayFXOnTag( level._effect["def_explosion"], self, "tag_origin" );
			
			self	bunkerDoorRotate(true);
			flag_set("vault_opened");
			if(IsDefined(level.vault.clip))
			{
				level.vault.clip connectpaths();
			}
			return;
		}
	}		
}

check_for_grenade_throw()
{
	self endon("disconnect");
	
	while(1)
	{
		self waittill("grenade_fire", grenade, weapname);
		
		//if ( weapname != "frag_grenade" )
		//	continue;

		grenade thread wait_for_grenade_explode( self );
		self thread wait_for_projectile_impact( grenade );
	}
}

// self is grenade
wait_for_grenade_explode( player )
{
	player endon( "projectile_impact" );
	player endon( "disconnect");
	
	self waittill( "explode", grenade_origin );
	self thread check_for_grenade_damage_on_vault( grenade_origin );
}


// self is player
wait_for_projectile_impact( grenade )
{
	grenade endon( "explode" );

	self waittill( "projectile_impact", weapon_name, position );
	self thread check_for_grenade_damage_on_vault( position );
}


check_for_grenade_damage_on_vault( grenade_origin )
{
	radiusSqToCheck = 64*64 + 200*200;

	if( level.vault.damage_state == 0 ) //no damage yet
	{	
		vault_destroyed = false;
		vault_origin = level.vault.origin;
				
		//Do distance check
		if( DistanceSquared( vault_origin, grenade_origin ) < radiusSqToCheck )
		{
			vault_destroyed = true;
			break;
		}
			
		if( vault_destroyed )
		{
			level.vault.damage_state = 1;
		}
	}
}

bunkerDoorRotate(open, time)
{
	if(!isDefined(self.script_float))
	{
		self.script_float = -110;
	}
	
	if(!isDefined(self.script_string))
	{
		self.script_string = "yaw";
	}
	if(!isDefined(time))
	{
		time = 0.2;
	}
	
	rotate = self.script_float;
	if(!open)
	{
		rotate *= -1;
	}

	if(IsDefined(self.script_angles))
	{
			self NotSolid();
			self RotateTo(self.script_angles, time, 0, 0);
			self thread maps\mp\zombies\_zm_blockers::door_solid_thread();
	}
	else
	{	
		switch(self.script_string)
		{
		case "pitch":
			self NotSolid();
			self RotatePitch(rotate, time, 0.1, 0.1);
			self thread maps\mp\zombies\_zm_blockers::door_solid_thread();
			break;
		case "roll":
			self NotSolid();
			self RotateRoll(rotate, time, 0.1, 0.1);
			self thread maps\mp\zombies\_zm_blockers::door_solid_thread();
			break;
		case "yaw":	//fall through
			self NotSolid();
			self RotateYaw(rotate, time, 0.1, 0.1);
			self thread maps\mp\zombies\_zm_blockers::door_solid_thread();
		default:
		}
	}
}

// ------------------------------------------------------------------------------------------------

zm_transit_emp_init()
{
	level.custom_emp_detonate = ::zm_transit_emp_detonate;

	//bus break range
	set_zombie_var( "emp_bus_off_range",		12*100 ); 
	set_zombie_var( "emp_bus_off_time",			45 ); 

}

zm_transit_emp_detonate( grenade_origin )
{
	// check for avogadro
	self emp_detonate_boss(grenade_origin);

	// check for the bus
	self emp_detonate_bus(grenade_origin);

	// check zone
	test_ent = spawn( "script_origin", grenade_origin );
	if ( test_ent maps\mp\zombies\_zm_zonemgr::entity_in_zone( "zone_prr" ) )
	{
		if ( flag( "power_on" ) )
		{
			trig = getent( "powerswitch_buildable_trigger_power", "targetname" );
			trig notify( "trigger" );
		}
	}
	test_ent Delete();
}

emp_detonate_boss(grenade_origin)
{
	
}

emp_detonate_bus(grenade_origin)
{
	if (IsDefined(level.the_bus))
	{
		rangesq = level.zombie_vars["emp_bus_off_range"] * level.zombie_vars["emp_bus_off_range"];
		if ( DistanceSquared( grenade_origin, level.the_bus.origin ) < rangesq )
		{
			disable_time = level.zombie_vars["emp_bus_off_time"];
			level.the_bus maps\mp\zm_transit_bus::bus_disabled_by_emp(disable_time);
		}
	}
}



// ------------------------------------------------------------------------------------------------
solo_tombstone_removal()
{
	players = GET_PLAYERS();
	if(players.size > 1)
	{
		return;
	}
		
	level thread maps\mp\zombies\_zm_perks::perk_machine_removal("specialty_scavenger");
}	
// ------------------------------------------------------------------------------------------------

zombie_transit_devgui( cmd )
{
/#
	cmd_strings = strTok(cmd, " ");
	switch( cmd_strings[0] )
	{
		case "pickup":
 			if ( !level.the_bus.upgrades[cmd_strings[1]].pickedup )
			{
				level.the_bus.upgrades[cmd_strings[1]].trigger notify("trigger", GET_PLAYERS()[0]);
			}
			break;
		case "spawn":
			player = GET_PLAYERS()[0];
			
			//Pick Spawner
			//------------
			spawnerName = undefined;
			if (cmd_strings[1] == "regular")
			{
				spawnerName = "zombie_spawner";	
			}
			else if ( cmd_strings[ 1 ] == "screecher" )
			{
			}
			else
			{
				return;
			}
			
			//Trace to find where the player is looking
			//-----------------------------------------
			direction = player GetPlayerAngles();
			direction_vec = AnglesToForward( direction );
			eye = player GetEye();

			scale = 8000;
			direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);
			trace = bullettrace( eye, eye + direction_vec, 0, undefined );
			
			//Spawn ai and teleport to where the player is looking
			//----------------------------------------------------
			guy = undefined;
			if ( cmd_strings[1] == "screecher" )
			{
				spawner = level.screecher_spawners[ 0 ];
				guy = maps\mp\zombies\_zm_utility::spawn_zombie( spawner );
			}
			else if ( cmd_strings[1] == "regular" )
			{
				spawners = GetEntArray( spawnerName, "script_noteworthy" );
				spawner = spawners[ 0 ];
			
				//guy = spawner CodespawnerForceSpawn();

				guy = maps\mp\zombies\_zm_utility::spawn_zombie( spawner );	
				guy.favoriteEnemy = player;
				guy.script_string = "zombie_chaser";
				guy thread maps\mp\zombies\_zm_spawner::zombie_spawn_init();
				guy custom_zombie_setup();
			}
			guy forceteleport(trace["position"], player.angles + (0,180,0));
			break;
		case "test_attach":
			attach_name = GetDvar("zombie_bus_debug_attach");
			opening = level.the_bus maps\mp\zm_transit_openings::busGetOpeningForTag(attach_name);
			if ( IsDefined(opening) )
			{
				if ( IsDefined(opening.zombie) )
				{
					iprintln("Zombie already attached to opening: " + attach_name);
				}
				else
				{
					origin = level.the_bus GetTagOrigin(attach_name);
					zombie_spawners = getEntArray( "zombie_spawner", "script_noteworthy" ); 

					zombie = spawn_zombie(zombie_spawners[0]);
					zombie.cannotAttachToBus = true;
				//	zombie thread maps\mp\zm_transit_openings::zombieAttachToBus(level.the_bus, opening, true);
					zombie thread maps\mp\zm_transit_openings::zombieAttachToBus(level.the_bus, opening, false);
				}
			}
			else
			{
				iprintln("Couldn't find opening for tag: " + attach_name);
			}
			break;

		case "attach_tag":
			SetDvar("zombie_bus_debug_attach", cmd_strings[1]);
			break;

		case "hatch_available":
			if (isdefined(level.the_bus))
				level.the_bus notify("hatch_mantle_allowed");
			break;
			
		case "ambush_round":
			if ( IsDefined(level.ambushPercentagePerStop) )
			{
				if (cmd_strings[1] == "always")
				{
					level.ambushPercentagePerStop = 100;	
				}
				else if (cmd_strings[1] == "never")
				{
					level.ambushPercentagePerStop = 0;
				}
			}
			break;
		
			
		/*case "tires":
			if (cmd_strings[1] == "fix")
			{
				level.the_bus maps\mp\zm_transit_upgrades::fixAllTires();	
			}
			else if (cmd_strings[1] == "flatten")
			{
				//level.the_bus maps\mp\zm_transit_upgrades::flattenAllTires( level.the_bus maps\mp\zm_transit_zones::busGetCurZoneName() );
			}
			else if( cmd_strings[1] == "flat_always" )
			{
				level.the_bus.flatTireChance = 100;
			}
			else if( cmd_strings[1] == "flat_never" )
			{
				level.the_bus.flatTireChance = 0;
				level.the_bus.flatTireChanceAccumulation = 0;
			}
			break;*/
		
		case "gas":
			if ( cmd_strings[1] == "add" )
			{
				level.the_bus maps\mp\zm_transit_bus::busGasAdd( GetDvarInt( "zombie_bus_gas_amount" ) );
			}
			else if ( cmd_strings[1] == "remove" )
			{
				level.the_bus maps\mp\zm_transit_bus::busGasRemove( GetDvarInt( "zombie_bus_gas_amount" ) );
			}
			break;
		
		case "force_bus_to_leave":
			level.the_bus notify( "depart_early" );
			/#
			if ( IsDefined( level.bus_leave_hud ) )
			{
				level.bus_leave_hud.alpha = 0;
			}
			#/
			break;
			
		case "teleport_to_bus":
			GET_PLAYERS()[0] SetOrigin( level.the_bus LocalToWorldCoords( ( 0, 0, 25 ) ) );

		default:
			break;

	}
#/
}

is_valid_powerup_location( powerup )
{
	// first check if the zombie is near a moving bus
	valid = false;

	// check our cache first
	if ( !IsDefined(level.powerup_areas) )
	{
		level.powerup_areas = GetEntArray("powerup_area", "script_noteworthy");
	}

	if ( !IsDefined( level.playable_areas ) ) 
	{
		level.playable_areas = GetEntArray("player_volume", "script_noteworthy" );
	}

	for ( i = 0; i < level.powerup_areas.size && !valid; i++ )
	{
		area = level.powerup_areas[i];
		valid = powerup IsTouching(area);
	}

	for ( i = 0; i < level.playable_areas.size && !valid; i++ )
	{
		area = level.playable_areas[i];
		valid = powerup IsTouching(area);
	}

	return valid;
}

zombie_transit_player_too_many_weapons_monitor_callback( weapon )
{
	if ( self maps\mp\zm_transit_cling::playerIsClingingToBus() )
	{
		return false;
	}
	
	return true;
}

zombie_transit_audio_alias_override()
{
	// Automaton NPC Aliases
	//----------------------
	maps\mp\zm_transit_automaton::initAudioAliases();
}

// ===============================================================================
//	Collapsing bridge event
// ===============================================================================
collapsing_bridge_init()
{
	time = 1.5;
	
	trig = GetEnt("bridge_trig","targetname");
	bridge = GetEntArray(trig.target, "targetname");
	
	if(!IsDefined(bridge))
	{
		return;
	}
	
	trig waittill("trigger", who);
	
	trig playsound( "evt_bridge_collapse_start" );
	trig thread play_delayed_sound( time );
	
	for ( i = 0; i < bridge.size; i++ )
	{
		if(IsDefined(bridge[i].script_angles))
		{
			rot_angle = bridge[i].script_angles;
		}
		else
		{
			rot_angle = (0, 0, 0);
		}
		EarthQuake( RandomFloatRange( 0.5, 1 ), 1.5, bridge[i].origin, 1000 ); 
		//PlayFX( level._effect["def_explosion"], bridge[i].origin );
		exploder(150);
				
		bridge[i] RotateTo( rot_angle, time, 0, 0 ); 
	}
}	
play_delayed_sound( time )
{
	wait(time);
	self playsound( "evt_bridge_collapse_end" );
}


bus_roof_damage_init()
{
	trigs = GetEntArray("bus_knock_off","targetname");
	array_thread(trigs, ::bus_roof_damage);	
}	
bus_roof_damage()
{
	while(true)
	{
		self waittill("trigger", who);
		
		if( isplayer(who))
		{
			who dodamage(10, who.origin);
		}
		else
		{
			who dodamage(who.health + 100, who.origin);
		}
		wait(0.5);
	}
}	

//=================================================================================
falling_death_init()
{
	trig = GetEnt("transit_falling_death","targetname");
	if(IsDefined(trig))
	{
		while(true)
		{
			trig waittill("trigger", who);	
			if(!is_true(who.insta_killed))
			{		
				who thread insta_kill_player();
			}
		}
	}	
}	

insta_kill_player()
{
	self endon("disconnect");
	
	if(is_true(self.insta_killed))
	{
		return;
	}	
	
	if(is_player_killable(self))
	{
		self.insta_killed = true;
		in_last_stand = false;
		if( self maps\mp\zombies\_zm_laststand::player_is_in_laststand()  )
		{
			in_last_stand = true;
		}
		
		//if solo then the player dies if jumps off while alive and no quick revive
		if(flag("solo_game")) 
		{			
			if(isDefined(self.lives) && self.lives > 0)
			{
				self.waiting_to_revive = true; //to bypass the normal respawn logic
			
				points = getstruct("zone_pcr","script_noteworthy");
				spawn_points = getstructarray(points.target,"targetname");
				point = spawn_points[0];

				self dodamage(self.health + 1000,(0,0,0));
				wait(1.5); //enough time to give the player some feedback about the death
				self setorigin(point.origin + (0,0,20));
				self.angles = point.angles;	
				if(in_last_stand)
				{
					flag_set("instant_revive");
					wait_network_frame();
					flag_clear("instant_revive");
				}
				else
				{
					self thread maps\mp\zombies\_zm_laststand::auto_revive( self );
					self.waiting_to_revive = false;
					self.solo_respawn = 0;
					self.lives = 0;
				}				
			}
			else
			{
				self dodamage(self.health + 1000,(0,0,0)); //just kill him in solo mode
			}
		}
		else //in a coop match the player will die and go to spectate and then respawn on hacker side
 		{
 			self dodamage(self.health + 1000,(0,0,0));
 			wait_network_frame();
 			self.bleedout_time = 0;
 		}
		self.insta_killed = false;				
	}	
}

is_player_killable( player, checkIgnoreMeFlag )
{
	if( !IsDefined( player ) ) 
	{
		return false; 
	}

	if( !IsAlive( player ) )
	{
		return false; 
	} 

	if( !IsPlayer( player ) )
	{
		return false;
	}

	if( player.sessionstate == "spectator" )
	{
		return false; 
	}

	if( player.sessionstate == "intermission" )
	{
		return false; 
	}

	//We only want to check this from the zombie attack script
	if( isdefined(checkIgnoreMeFlag) && player.ignoreme )
	{
		//IPrintLnBold(" ignore me ");
		return false;
	}
	
	return true; 
}
//=================================================================================
//
//Spawn zombies and set to inert state using start_inert() in _zm_ai_basic.gsc.
//Wait til all inert zombies are killed, switch back to normal round spawning
//
//=================================================================================
inert_zombies_init()
{
	inert_spawn_location = getstructarray("inert_location","script_noteworthy");

	if(IsDefined(inert_spawn_location))
	{
		array_thread(inert_spawn_location,::spawn_inert_zombies); 
	}	
}

spawn_inert_zombies()
{
	if( !isdefined(self.angles) )
	{
		self.angles = ( 0.0, 0.0, 0.0 );
	}		
	
	//flag_wait( "spawn_zombies" );
	//flag_wait("start_zombie_round_logic");
	//level waittill( "start_of_round" );

	if(IsDefined(level.zombie_spawners))
	{
		spawner = random(level.zombie_spawners);		
		ai = spawn_zombie( spawner);
		
		//ai = spawn_zombie( spawner, spawner.targetname, self);
		//level.zombie_total--;
	}
 		
	if( IsDefined( ai ) )
	{
		ai forceteleport(self.origin, self.angles);
		ai.start_inert = true;
	}
}	
	