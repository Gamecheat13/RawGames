#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_shg_common;


//===========================================
// 				tweakables
//===========================================

CONST_loot_model		  	= "com_office_book_blue_standing_phys";
CONST_loot_min_kills 		= 2;
CONST_loot_max_kills 		= 5;
CONST_loot_cheat			= false;

CONST_loot_church_number 	= 3;
CONST_loot_alley_number 	= 2;
CONST_loot_total_number		= CONST_loot_church_number + CONST_loot_alley_number;

CONST_dog_min_kills			= 2;
CONST_dog_max_kills			= 4;

CONST_laser_wait_time		= 10;

/#
CONST_check_point			= "none";
CONST_drop_debug			= false;
#/


//===========================================
// 					main
//===========================================
main()
{	
	// precache
	so_warlord_precache();
	maps\warlord_precache::main();
	maps\so_stealth_warlord_precache::main();
	
	// base map fx
	so_vfx_entity_fixup( "fx_zone" );
	maps\warlord_fx::main();

	maps\_load::main();
	
	// turrets
	common_scripts\_sentry::main();
	
	// base map audio
	so_mark_class( "trigger_multiple_audio" );
	maps\warlord_aud::main();
	
	maps\_compass::setupMiniMap( "compass_map_warlord" );
	
	setup();
	thread gameplay_logic();
	
	/#
	if( CONST_drop_debug )
	{
		level thread loot_drop_debug();
	}
	#/
}


/#
//===========================================
// 		 	loot_drop_debug
//===========================================
loot_drop_debug()
{
	level.player notifyOnPlayerCommand( "drop_loot", "+actionslot 4" );
	
	while( true )
	{
		level.player waittill( "drop_loot" );
		
		// spawn the loot
		warlord_loot = spawn( "script_model", level.player.origin + ( 0, 0, 32 ) );
		warlord_loot setModel( CONST_loot_model );
		warlord_loot PhysicsLaunchServer( (0,0,0), (0,0,0) );
	}
}
#/
	

//===========================================
// 		  so_warlord_preCache
//===========================================
so_warlord_precache()
{
	PrecacheMinimapSentryCodeAssets();
	
	// weapons
	level.so_warlord_primary 	= "m4_hybrid_grunt_optim";
	level.so_warlord_secondary 	= "fnfiveseven";
	
	PreCacheItem( level.so_warlord_primary );
	PreCacheItem( level.so_warlord_secondary );
	
	// models
	PreCacheModel( CONST_loot_model );
	
	// laser mechanic
	PreCacheShader( "dpad_laser_designator" );
	PreCacheItem( "stinger_speedy" );
	precacherumble( "stinger_lock_rumble" );
	
	level._effect[ "bridge_explode" ] 		= LoadFX( "explosions/bridge_explode" );
	level._effect[ "artillery" ] 			= LoadFX( "explosions/artilleryExp_dirt_brown" );
	level._effect[ "field_fire_distant2" ] 	= LoadFX( "fire/bigcity_destroyed_building_fire_smoke" );
	
	// hint strings
	add_hint_string( "laser_hint", &"SO_STEALTH_WARLORD_LASER_HINT", ::remove_laser_hint );
	add_hint_string( "lockon_hint", &"SO_STEALTH_WARLORD_LOCKON_HINT", ::remove_hint );
	add_hint_string( "fire_hint", &"SO_STEALTH_WARLORD_LASER_FIRE", ::remove_fire_hint );
	
	PreCacheString( &"SO_STEALTH_WARLORD_DOG_MELEE_MENU");
	PreCacheString( &"SO_STEALTH_WARLORD_TURRETS_ACTIVE");
}


//===========================================
// 			  remove_laser_hint
//===========================================
remove_laser_hint()
{
	if( !IsDefined( self.laserForceOn ) )
	{
		return false;
	}
	
	return self.laserForceOn;
}

//===========================================
// 			  remove_fire_hint
//===========================================
remove_fire_hint()
{
	if( !IsDefined( self.laserForceOn ) )
	{
		return false;
	}
	
	return !self.bHasLockOn;
}

//===========================================
// 				remove_hint
//===========================================
remove_hint()
{
	return false;
}


//===========================================
// 					setup
//===========================================
setup()
{
	save_base_map_ents();
	so_mark_class( "trigger_damage" );
		
	so_delete_all_triggers();
	so_delete_all_spawners();
	so_delete_breach_ents();

	remove_base_map_ents();
	open_warlord_path_blockers();
	
	setup_flags();
	setup_anims();
	setup_challenge();
	setup_difficulty_settings();
	setup_loot_settings();
	setup_enemy_spawn_settings();
	setup_player_settings();
	setup_turret_settings();
	setup_lasers();
	setup_vo();
}


//===========================================
// 			  	   setup_vo
//===========================================
setup_vo()
{
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_lowtech"] 		=  "so_ste_warlord_hqr_lowtech";   			// Hostiles have gone low tech to avoid detection. Intercept paper communications to locate the target.
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_safehouse"] 		=  "so_ste_warlord_hqr_safehouse";   		// Intel corroborates reports of a nearby safe house.
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_intelaquired"] 	=  "so_ste_warlord_hqr_intelaquired";   	// All intel acquired.  Get to an elevated position and hold for further orders.
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_targetgood"] 	=  "so_ste_warlord_hqr_targetgood";   		// Coordinates acquired, target is good.
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_goodeffect"] 	=  "so_ste_warlord_hqr_goodeffect";   		// Good effect on target!  Good job team, bring it in.  
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_dataenroute"] 	=  "so_ste_warlord_hqr_dataenroute";   		// Data en route, hold that position and await target designation.
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_painttarget"] 	=  "so_ste_warlord_hqr_painttarget";   		// Enemy safe house identified.  Use the laser to paint the target.
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_pickitup"] 		=  "so_ste_warlord_hqr_pickitup";   		// Intel in the field, pick it up. 
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_dropped"] 		=  "so_ste_warlord_hqr_dropped";   			// Intel dropped. Get on it.
	/* inuse*/ level.scr_radio["so_ste_warlord_hqr_ground"] 		=  "so_ste_warlord_hqr_ground";   			// Intel on the ground.
	
	level.loot_vo = [];
	
	level.loot_vo[0] = "so_ste_warlord_hqr_pickitup";
	level.loot_vo[1] = "so_ste_warlord_hqr_dropped";
	level.loot_vo[2] = "so_ste_warlord_hqr_ground";
	
	level.loot_vo = array_randomize( level.loot_vo );
	
	
	level.scr_radio["so_ste_warlord_hqr_fastmovers"] 	=  "so_ste_warlord_hqr_fastmovers";   		// Fast-movers are standing by, light up that safehouse!
	level.scr_radio["so_ste_warlord_hqr_notime"] 		=  "so_ste_warlord_hqr_notime";   			// We have no time, use your designator to paint the target!
}


//===========================================
// 			  	   run_vo
//===========================================
run_vo()
{
	level endon( "special_op_terminated" );
	
	// Hostiles have gone low tech to avoid detection. Intercept paper communications to locate the target.
	play_vo_line( "so_ste_warlord_hqr_lowtech" );
	
	flag_wait( "found_all_church_loot" );
	
	// Intel corroborates reports of a nearby safe house.
	play_vo_line( "so_ste_warlord_hqr_safehouse" );
	
	flag_wait( "found_all_loot" );

	// All intel acquired.  Get to an elevated position and hold for further orders.
	play_vo_line( "so_ste_warlord_hqr_intelaquired" );
	
	flag_wait( "tower_entrance" );
	
	// Data en route, hold that position and await target designation.
	play_vo_line( "so_ste_warlord_hqr_dataenroute" );
	
	wait( CONST_laser_wait_time );
	
	// Enemy safe house identified.  Use the laser to paint the target.
	level thread play_vo_line( "so_ste_warlord_hqr_painttarget" );
	
	// give players the laser
	wait( 0.5 );
	flag_set( "has_laser" );
	wait( 2.0 );
	level thread run_lasers();
	
	flag_wait( "target_destroyed" );
	wait( 2.0 );
	
	// Good effect on target!  Good job team, bring it in. 
	play_vo_line( "so_ste_warlord_hqr_goodeffect" );
}

//===========================================
// 			  	play_vo_line
//===========================================
play_vo_line( vo_line )
{
	level endon( "special_op_terminated" );
	
	radio_dialogue( vo_line );
}

//===========================================
// 			  save_base_map_ents
//==========================================
save_base_map_ents( )
{
	ent_array = GetEntArray();
	
	foreach( ent in ent_array )
	{
		if( isdefined( ent.script_noteworthy ) && ( ent.script_noteworthy == "mortar_rpg_guys_1" ) )
		{
			ent.script_specialops = 1;
		}
	}	
}

//===========================================
// 			  remove_base_map_ents
//===========================================
remove_base_map_ents()
{
	delete_by_key_value_pair( "player_mortar", "targetname" );	
	delete_by_key_value_pair( "weapon_rpg_player", "classname" );	
	delete_path_blockers();
}


//===========================================
// 			 delete_path_blockers
//===========================================
delete_path_blockers()
{
	delete_by_key_value_pair( "so_remove_model", "targetname" );
	delete_by_key_value_pair( "so_remove_brush_no_dyn", "targetname" );
	
	brush_models = GetEntArray( "so_remove_brush", "targetname" );
	
	for( i = 0; i < brush_models.size; i++)
	{
		brush_models[i] hide_entity();
	}
}


//===========================================
// 		  delete_by_key_value_pair
//===========================================
delete_by_key_value_pair( value, key )
{
	entity_array = GetEntArray( value, key );
	
	for( i = 0; i < entity_array.size; i++)
	{
		object = entity_array[i];
			
		if( IsDefined( object ) )
		{
			object delete();
		}
	}
}


//===========================================
// 		 open_warlord_path_blockers
//===========================================
open_warlord_path_blockers()
{
	level thread open_church_doors();
	open_compound_door();
	open_sewer_grate();
}


//===========================================
// 			open_church_doors
//===========================================
open_church_doors()
{
	breach_door_left = GetEnt( "breach_door_left", "targetname" );
	breach_door_right = GetEnt( "breach_door_right", "targetname" );
	
	breach_door_left ConnectPaths();
	breach_door_right ConnectPaths();
	
	breach_door_left RotateYaw( 90, 0.2, 0.1, 0.1 );
	breach_door_right RotateYaw( -90, 0.2, 0.1, 0.1 );
	
	wait( 0.5 );
	
	breach_door_left DisconnectPaths();
	breach_door_right DisconnectPaths();
}


//===========================================
// 			open_compound_door
//===========================================
open_compound_door()
{
	compound_door = GetEnt( "compound_door", "targetname" );
	compound_door RotateYaw( 110, 0.2, 0.1, 0.1 );
	compound_door ConnectPaths();
}


//===========================================
// 			open_sewer_grate
//===========================================
open_sewer_grate()
{
	sewer_grate_clip = GetEnt( "sewer_grate_clip", "targetname" );
	sewer_grate_clip NotSolid();
	sewer_grate_clip ConnectPaths();
}


//===========================================
// 				setup_flags
//===========================================
setup_flags()
{
	// objective flags
	flag_init( "so_stealth_warlord_start" );
	flag_init( "so_stealth_warlord_complete" );
	flag_init ("player_has_escaped");
	flag_init( "found_all_church_loot" );
	flag_init( "found_all_loot" );
	flag_init( "target_destroyed" );
	flag_init( "mission_end" );
	flag_init( "has_laser" );
}


//===========================================
// 				setup_anims
//===========================================
setup_anims()
{
	animscripts\dog\dog_init::initDogAnimations();
}


//===========================================
// 				setup_challenge
//===========================================
setup_challenge()
{
	level thread enable_challenge_timer( "so_stealth_warlord_start", "so_stealth_warlord_complete" );
	level thread fade_challenge_in( 1.0, false );
	level thread fade_challenge_out( "so_stealth_warlord_complete" );

	level thread enable_escape_warning();
	level thread enable_escape_failure();
}


//===========================================
// 		   setup_difficulty_settings
//===========================================
setup_difficulty_settings()
{
	assert( isdefined( level.gameskill ) );
	
	switch( level.gameSkill )
	{
		case 0:									// Easy
		case 1:	so_warlord_regular();	break;	// Regular
		case 2:	so_warlord_hardened();	break;	// Hardened
		case 3:	so_warlord_veteran();	break;	// Veteran
	}
}


//===========================================
// 			 setup_loot_settings
//===========================================
setup_loot_settings()
{
	level.loot = SpawnStruct();
	
	level.loot.maxLootCount 		= CONST_loot_total_number;
	level.loot.minKillsRequired 	= CONST_loot_min_kills;
	level.loot.maxKillsRequired 	= CONST_loot_max_kills;
	level.loot.requiredKillCount	= RandomIntRange( level.loot.minKillsRequired, level.loot.maxKillsRequired + 1 );
	level.loot.currentKillCount		= 0;
	level.loot.numLootDropped 		= 0;
	level.loot.numLootFound			= 0;
	
	for( i = 0; i < level.players.size; i++ )
	{
		create_loot_hud( level.players[i] );
	}
}


//===========================================
// 			create_loot_hud
//===========================================
create_loot_hud( player )
{
	if( !IsDefined( player) )
	{
		return;
	}
	
	line_number = -8;
	
	player.loot_hud_title = player maps\_shg_common::create_splitscreen_safe_hud_item( line_number, so_hud_ypos(), &"SO_STEALTH_WARLORD_LOOT_FOUND" );
	
	player.loot_hud_count = player maps\_shg_common::create_splitscreen_safe_hud_item( line_number, so_hud_ypos(), undefined );
	player.loot_hud_count.alignx = "left";
	
	set_loot_hud_counter( player );
	set_loot_hud_alpha( player, 0 );
}


//===========================================
// 			set_loot_hud_counter
//===========================================
set_loot_hud_counter( player,  update_menu )
{
	if( !IsDefined( player) )
	{
		return;
	}
		
	player.loot_hud_count.label = level.loot.numLootFound + "/" + level.loot.maxLootCount;
	
	if( IsDefined( update_menu ) && update_menu )
	{
		objective_string_nomessage( level.current_obj_number, &"SO_STEALTH_WARLORD_INTEL_COUNT", level.loot.numLootFound, level.loot.maxLootCount );
	}
}


//===========================================
// 			set_loot_hud_alpha
//===========================================
set_loot_hud_alpha( player, alpha )
{
	if( !IsDefined( player) )
	{
		return;
	}
		
	player.loot_hud_title.alpha = alpha;
	player.loot_hud_count.alpha = alpha;
}


//===========================================
// 			so_warlord_regular
//===========================================
so_warlord_regular()
{
	level.new_enemy_accuracy_scale 	= 1.0;
}


//===========================================
// 			so_warlord_hardened
//===========================================
so_warlord_hardened()
{
	level.new_enemy_accuracy_scale 	= 1.0;
}


//===========================================
// 			so_warlord_veteran
//===========================================
so_warlord_veteran()
{
	level.new_enemy_accuracy_scale	= 1.0;
}


//===========================================
// 		  setup_enemy_spawn_settings
//===========================================
setup_enemy_spawn_settings()
{
	add_global_spawn_function( "axis", ::override_enemy_settings_on_spawn );
}


//===========================================
// 		override_enemy_settings_on_spawn
//===========================================
override_enemy_settings_on_spawn()
{
	// no grenade drop, every axis resets this value when spawned
	level.nextGrenadeDrop	= 1000;
	
	if( self.type == "dog" )
	{
		self thread dog_monitor_death();
		return;
	}
	
	self.baseaccuracy = self.baseaccuracy * level.new_enemy_accuracy_scale;
	self add_death_function( ::kill_counter );
	
	if( !IsDefined(self.script_noteworthy) || ( self.script_noteworthy != "no_drop" ) )
	{
		self add_death_function( ::drop_loot_func );
	}
}


//===========================================
// 		   	 dog_monitor_death
//===========================================
dog_monitor_death()
{
	level endon( "special_op_terminated" );
	
	self waittill( "death", attacker, cause, weapon );
	
	if( issubstr( tolower( cause ), "melee" ) && IsPlayer( attacker ) )
	{
		attacker.bonus_2++;
		attacker notify( "dog_melee", attacker.bonus_2 );
	}
}

//===========================================
// 		   	 add_death_function
//===========================================
add_death_function( func, param1, param2, param3 )
{
	array = [];
	array[ "func" ] = func;
	array[ "params" ] = 0;

	if ( isdefined( param1 ) )
	{
		array[ "param1" ] = param1;
		array[ "params" ]++ ;
	}
	if ( isdefined( param2 ) )
	{
		array[ "param2" ] = param2;
		array[ "params" ]++ ;
	}
	if ( isdefined( param3 ) )
	{
		array[ "param3" ] = param3;
		array[ "params" ]++ ;
	}
	
	self.deathFuncs[ self.deathFuncs.size ] = array;
}


//===========================================
// 		   	 	kill_counter
//===========================================
kill_counter( attacker )
{
	if( !flag( "so_stealth_warlord_start" ) )
	{
		flag_set( "so_stealth_warlord_start" );
	}
	
	level.kill_count++;
}


//===========================================
// 		   	 drop_loot_func
//===========================================
drop_loot_func( attacker )
{
	// bail out, if all loot has been dropped
	if( level.loot.numLootDropped == level.loot.maxLootCount )
	{
		return;
	}
	
	// bail out, if we have dropped half of the loot and the player is only in the church area 
	if( (level.loot.numLootDropped == CONST_loot_church_number) && !flag( "trigger02_alley_ai" ) )
	{
		return;
	}
	
	level.loot.currentKillCount++;
	
	if( ( level.loot.currentKillCount == level.loot.requiredKillCount ) || CONST_loot_cheat )
	{
		// AI who drop loot should not drop weapons
		self.nodrop = true;
		self gun_remove();
		
		loot_drop_location = self.origin + ( 0, 0, 32 );
		
		no_drop_volume = GetEntArray( "no_drop_volume", "script_noteworthy" );
		
		// check for no drop locations
		for( i = 0; i < no_drop_volume.size; i++ )
		{
			if( self IsTouching( no_drop_volume[i] ) )
			{
				alt_drop_location 	= GetStruct( no_drop_volume[i].script_parameters, "targetname" );
				loot_drop_location 	= alt_drop_location.origin;
				break;
			}
		}

		// spawn the loot
		warlord_loot = spawn( "script_model", loot_drop_location );
		warlord_loot setModel( CONST_loot_model );
		warlord_loot PhysicsLaunchServer( (0,0,0), (0,0,0) );

		// update loot variables
		level.loot.numLootDropped++;
		level.loot.currentKillCount		= 0;
		level.loot.requiredKillCount	= RandomIntRange( level.loot.minKillsRequired, level.loot.maxKillsRequired + 1 );
		
		// monitor the loot
		warlord_loot thread monitor_loot_objective( level.loot.numLootDropped );
	}
}

//===========================================
// 		   	 monitor_loot_objective
//===========================================
monitor_loot_objective( loot_index )
{
	level endon( "special_op_terminated" );
	
	self waittill_notify_or_timeout( "physics_finished", 2.0 );
			
	level thread play_vo_line( level.loot_vo[ loot_index % 3 ] );

	objective_additionalposition( level.current_obj_number, loot_index, (0, 0, 0) );
	objective_additionalposition( level.current_obj_number, loot_index, self.origin + ( 0, 0, 16 ) );

	self MakeUsable();
	self SetHintString ( &"SO_STEALTH_WARLORD_LOOT" );			
	self waittill ( "trigger", player );
	
	objective_additionalposition( level.current_obj_number, loot_index, (0, 0, 0) );
	level.loot.numLootFound++;
	
	if( level.loot.numLootFound >= level.loot.maxLootCount )
	{
		flag_set( "found_all_loot" );
	}
	else if( level.loot.numLootFound == CONST_loot_church_number )
	{
		flag_set( "found_all_church_loot" );
	}
	else
	{
		level thread so_dialog_counter_update( level.loot.maxLootCount - level.loot.numLootFound, level.loot.maxLootCount );
	}

	self Delete();	
	
	player Playsound( "arcademode_2x", "sound_played", true );
	
	for( i = 0; i < level.players.size; i++ )
	{
		level thread display_loot_hud( level.players[i] );
	}
}


//===========================================
// 		 	display_loot_hud
//===========================================
display_loot_hud( player )
{
	if( !IsDefined( player) )
	{
		return;
	}
		
	level endon( "special_op_terminated" );

	set_loot_hud_counter( player, true );
	set_loot_hud_alpha( player, 1 );
	
	player.loot_hud_title thread so_hud_pulse_success();
	player.loot_hud_count thread so_hud_pulse_success();
	
	if( flag( "found_all_loot") )
	{
		wait( 2 );
		set_loot_hud_alpha( player, 0 );
	}
}


//===========================================
// 		 	setup_player_settings
//===========================================
setup_player_settings()
{
	maps\_load::set_player_viewhand_model( "viewhands_player_delta" );
	level.kill_count = 0;
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i].bonus_1 = 0;
		level.players[i].bonus_2 = 0;
			
		level.players[i] GiveWeapon( "semtex_grenade" );
		level.players[i] SetOffhandPrimaryClass( "other" );
		
		level.players[i] GiveMaxAmmo( "semtex_grenade" );
		level.players[i] GiveMaxAmmo( level.so_warlord_primary );
		level.players[i] GiveMaxAmmo( level.so_warlord_secondary );
		
		level.players[i] SwitchToWeapon( "alt_" + level.so_warlord_primary );
	}
}


//===========================================
// 		 	setup_turret_settings
//===========================================
setup_turret_settings()
{
	warlord_turrets = GetEntArray( "warlord_turret", "script_noteworthy" );
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i].bonus_1 = warlord_turrets.size;
	}
	
	for( i  = 0; i < warlord_turrets.size; i++)
	{
		turret 		= warlord_turrets[i];
		left_arc 	= 45;
		right_arc 	= 45;
		
		if ( IsDefined( turret.script_parameters ) )
		{
			param_array = StrTok( turret.script_parameters, "," );
		
			left_arc 	= int( param_array[0] );
			right_arc	= int( param_array[1] );
		}
		
		turret setLeftArc( left_arc );
		turret setRightArc( right_arc );
		
		turret SetTurretMinimapVisible( false );
		turret MakeUnusable();
		turret SetCanRadiusDamage( true );
		
		turret thread turret_monitor_damage();
		turret thread turret_monitor_flash();
		turret thread maps\_rank::giveXP_think();
		turret thread turret_monitor_death();
		
		turret.stay_solid_on_death 	= true;
		turret.keep_after_death 	= true;
	}
	
	level.sentry_settings[ "sentry_minigun" ].damage_smoke_time = 15;
}


//===========================================
// 			turret_monitor_damage
//===========================================
turret_monitor_death()
{
	level endon( "special_op_terminated" );
	
	self waittill( "death", attacker, cause, weapon );
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i].bonus_1--;
		level.players[i] notify( "turret_death", level.players[i].bonus_1 );
	}
}


//===========================================
// 			turret_monitor_damage
//===========================================
turret_monitor_damage()
{
	level 	endon( "special_op_terminated" );
	self 	endon( "death" );
	
	while( true )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		
		// multiply damage for explosives - GRENADES
		if( IsExplosiveDamageMOD( type ) )
		{
			self dodamage( (amount * 6 ), self.origin, attacker );
		}
		
		// instant kill
		if( type == "MOD_MELEE" )
		{
			self dodamage( (self.health + 1000 ), self.origin, attacker );
		}
	}
}


//===========================================
// 			turret_monitor_flash
//===========================================
turret_monitor_flash()
{
	level 	endon( "special_op_terminated" );
	self 	endon( "death" );
	
	turret_stun_time = 8.5;
	
	while( true )
	{
		self waittill( "flashbang", origin, amount_distance, amount_angle, attacker );

		// deactivate the turret
		self thread common_scripts\_sentry::sentry_burst_fire_stop();
		self thread common_scripts\_sentry::sentry_turn_laser_off();
		self common_scripts\_sentry::SentryPowerOff();
		playfxOnTag( getfx( "sentry_turret_explode" ), self, "tag_aim" );

		duration = turret_stun_time * amount_distance;
		wait( duration );

		// activate the turret
		self common_scripts\_sentry::SentryPowerOn();
	}
}


//===========================================
// 				gameplay_logic
//===========================================
gameplay_logic()
{
	level thread report_mission_challenges();
	
	level waittill( "challenge_fading_in");
	
	// settings and support scripting
	level thread run_objectives();
	level thread run_music();
	level thread run_vo();
	
	// combat threads
	run_church_ai();
	run_alley_ai();
	run_sewer_ai();
}


//===========================================
// 			report_mission_challenges
//===========================================
report_mission_challenges()
{
	CONVERT_MIN_TO_MILLI_SEC 	= 60 * 1000;
	
	level.so_mission_worst_time = 20 * CONVERT_MIN_TO_MILLI_SEC;
	level.so_mission_min_time	= 2 * CONVERT_MIN_TO_MILLI_SEC;	
	
	maps\_shg_common::so_eog_summary( "@SO_STEALTH_WARLORD_TURRETS_ALIVE", 175, undefined, "@SO_STEALTH_WARLORD_DOG_MELEE", 75, undefined );
	
	level.challenge_counter_start_immediately = true;
		
	array_thread( level.players, ::enable_challenge_counter, 3, &"SO_STEALTH_WARLORD_TURRETS_ACTIVE", "turret_death" );
	array_thread( level.players, ::enable_challenge_counter, 4, &"SO_STEALTH_WARLORD_DOG_MELEE_MENU", "dog_melee" );
	
	level waittill( "challenge_fading_in");
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i] notify( "turret_death", level.players[i].bonus_1 );
		level.players[i] notify( "dog_melee", level.players[i].bonus_2 );
	}
}


//===========================================
// 			  run_objectives
//===========================================
run_objectives()
{
	level endon( "special_op_terminated" );
	
	level.current_obj_number = 1;
	
	wait( 1.0 );
	
	// give the objective to find clues about the intended target
	Objective_Add( level.current_obj_number, "current", &"SO_STEALTH_WARLORD_OBJ_INTEL" );
	
	wait( 1.0 );
	objective_string_nomessage( level.current_obj_number, &"SO_STEALTH_WARLORD_INTEL_COUNT", level.loot.numLootFound, level.loot.maxLootCount );
	
	flag_wait( "found_all_church_loot" );
	
	// set the objective point to leave the church area
	targetname_show( "church_exit" );
	obj_position = GetEnt( "church_exit", "targetname");
	Objective_AdditionalPosition( level.current_obj_number, 1, (0, 0, 0) );
	Objective_AdditionalPosition( level.current_obj_number, 1, obj_position.origin );
	Objective_SetPointerTextOverride( level.current_obj_number, &"SO_STEALTH_WARLORD_EXIT_TEXT" );
	
	// clear the objective point
	flag_wait( "church_exit" );
	Objective_AdditionalPosition( level.current_obj_number, 1, (0, 0, 0) );
	Objective_SetPointerTextOverride( level.current_obj_number, "" );
	
	flag_wait( "found_all_loot" );
	Objective_Complete( level.current_obj_number );
	level.current_obj_number++;
	
	// give the objective to find the safe house
	Objective_Add( level.current_obj_number, "current", &"SO_STEALTH_WARLORD_OBJ_EXIT" );

	// sewer entrance
	targetname_show( "sewer_entrance" );
	sewer_entrance = GetEnt( "sewer_entrance", "targetname" );
	Objective_AdditionalPosition( level.current_obj_number, 1, (0, 0, 0) );
	Objective_AdditionalPosition( level.current_obj_number, 1, sewer_entrance.origin );
	
	flag_wait( "sewer_entrance" );
	
	// tower objective dot
	tower_entrance = GetStruct( "sewer_checkpoint", "targetname" );
	Objective_AdditionalPosition( level.current_obj_number, 1, (0, 0, 0) );
	Objective_AdditionalPosition( level.current_obj_number, 1, tower_entrance.origin );
	
	flag_wait( "tower_entrance" );
	Objective_AdditionalPosition( level.current_obj_number, 1, (0, 0, 0) );
	
	flag_wait( "has_laser" );
	
	Objective_Complete( level.current_obj_number );
	level.current_obj_number++;
	
	// give the objective to laser the safe house
	Objective_Add( level.current_obj_number, "current", &"SO_STEALTH_WARLORD_OBJ_SAFE_HOUSE" );
	
	// select target locations
	for( i = 0; i < level.players.size; i++ )
	{
		Objective_AdditionalPosition( level.current_obj_number, i + 1, (0, 0, 0) );
		Objective_AdditionalPosition( level.current_obj_number, i + 1, level.air_strike_targets[i].origin );
		Objective_SetPointerTextOverride( level.current_obj_number, &"SO_STEALTH_WARLORD_OBJ_TARGET" );
		
		target_volume = GetEnt( level.air_strike_targets[i].target, "targetname" );
		target_volume.obj_index = i + 1;
		Target_Set( target_volume );
		
		for( x = 0; x < level.players.size; x++ )
		{
			Target_HideFromPlayer( target_volume, level.players[x] );
		}
	}
	
	flag_wait( "target_destroyed" );
	
	Objective_Complete( level.current_obj_number );
	level.current_obj_number++;
	
	flag_wait( "mission_end" );
	flag_set( "so_stealth_warlord_complete" );
	
	// frezee players at the end of the mission
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i] EnableInvulnerability();
		level.players[i] FreezeControls( true );
		level.players[i].ignoreme = true;
	}
}


//===========================================
// 				run_music
//===========================================
run_music()
{
	level endon( "special_op_terminated" );
	
	maps\_audio_music::MUS_play( "so_warl_take_them_out" );
}


//===========================================
// 				setup_lasers
//===========================================
setup_lasers()
{
	level.air_strike_targets 		= GetStructArray( "air_strike_target", "targetname" );
	level.air_strike_targets 		= array_randomize( level.air_strike_targets );
	level.air_strike_pos 			= GetStructArray( "air_strike_origin", "targetname" );
	level.building_damage_triggers 	= GetEntArray( "trigger_damage", "classname" );
	
	laser_hit_locations = GetEntArray( "laser_hit_location", "targetname" );
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i].laser_hit_location = laser_hit_locations[i];
	}
}


//===========================================
// 				  run_lasers
//===========================================
run_lasers()
{
	level endon( "special_op_terminated" );
	
	// watch all the damage triggers for a missile hit
	for( i = 0; i < level.building_damage_triggers.size; i++ )
	{
		level.building_damage_triggers[i] thread monitor_damage_triggers();
	}
	
	for( i = 0; i < level.players.size; i++ )
	{
		level thread warlord_laser_targeting_device( level.players[i] );
		level.players[i] display_hint_timeout( "laser_hint", 60 );
	}
}


//===========================================
// 		warlord_laser_targeting_device
//===========================================
warlord_laser_targeting_device( player )
{
	level 	endon( "special_op_terminated" );
	player 	endon( "remove_laser_targeting_device" );
	player	endon( "death" );
	
	assert(!isdefined(player.laserForceOn));
	
	player.lastUsedWeapon 	= undefined;
	player.laserAllowed 	= true;
	player.laserForceOn 	= false;
	
	player setWeaponHudIconOverride( "actionslot4", "dpad_laser_designator" );
	player notifyOnPlayerCommand( "use_laser", "+actionslot 4" );
	player notifyOnPlayerCommand( "fire_air_strike", "+attack" );
	player notifyOnPlayerCommand( "fire_air_strike", "+attack_akimbo_accessible" );
	player thread CleanUpLaserTargetingDevice();
	player childthread monitor_weapon_change();
	player childthread monitor_alt_mode();
	player childthread monitorLaserOff();

	while( true )
	{
		player waittill( "use_laser" );
		
		if( player.laserForceOn || !player.laserAllowed || player ShouldForceDisableLaser())
		{
			turn_off_laser( player );
		}
		else
		{
			current_weapon = player GetCurrentWeapon();
			
			// alt mode weapons should not use the laser
			if( string_starts_with( current_weapon, "alt_") && ( current_weapon != "alt_" + level.so_warlord_primary ) )
			{
				primary_weapon = GetSubStr( current_weapon, 4 );
				player SwitchToWeapon( primary_weapon );
			}
	
			player laserForceOn();
			player allowFire( false );
			player.laserForceOn = true;		
			player AllowADS( true );
			player thread warlord_laser_designate_target();
			player thread monitor_laser_fire();
		}
	}
}


//===========================================
// 				turn_off_laser
//===========================================
turn_off_laser( player )
{
	player notify( "cancel_laser" );
	player laserForceOff();
	player.laserForceOn = false;
	player AllowADS( true );
	wait( 0.25 );
	player thread laser_monitor_enable_weapon();
	player ClearTarget();	
}


//===========================================
// 		laser_monitor_enable_weapon
//===========================================
laser_monitor_enable_weapon()
{
	level 	endon( "special_op_terminated" );
	self 	endon( "use_laser" );
	
	if( WeaponIsAuto( self GetCurrentWeapon() ) )
	{
		self waittill( "fire_air_strike" );
	}
	
	self allowFire( true );
}


//===========================================
// 			monitor_weapon_change
//===========================================
monitor_weapon_change( )
{
	self notifyOnPlayerCommand( "turn_off_laser", "weapnext" );
	
	while( true )
	{
		self waittill_any( "turn_off_laser", "weapon_taken" );
		turn_off_laser( self );
	}
}


//===========================================
// 			monitor_alt_mode
//===========================================
monitor_alt_mode()
{
	self notifyOnPlayerCommand( "alt_mode", "+actionslot 3" );
	
	while( true )
	{
		self waittill( "alt_mode" );
		
		weapons_list = self GetWeaponsListPrimaries();
		
		for( i = 0; i < weapons_list.size; i++ )
		{
			weapon = weapons_list[i];
			
			if( WeaponAltWeaponName( weapon ) != "none" )
			{
				turn_off_laser( self );
			}
		}
	}
}


//===========================================
// 			  monitor_laser_fire
//===========================================
monitor_laser_fire()
{
	level 	endon( "special_op_terminated" );
	self 	endon( "cancel_laser" );
	self 	endon( "death" );
		
	self waittill( "fire_air_strike" );
		
	if( self.bHasLockOn == true )
	{
		// Coordinates acquired, target is good.
		level thread play_vo_line( "so_ste_warlord_hqr_targetgood" );
		self thread warlord_laser_artillery( self.laserTarget );
	}
	else
	{
		self display_hint_timeout( "lockon_hint", 2 );
		self Playsound ( "so_sample_not_collected", "sound_played", true );
	}
	
	self notify( "use_laser" );
}


//===========================================
// 		warlord_laser_designate_target
//===========================================
warlord_laser_designate_target()
{
	level 	endon( "special_op_terminated" );
	self 	endon( "cancel_laser" );
	self 	endon( "death" );
	
	LOCK_LENGTH = 1125;
	self ClearTarget();
	
	while( true )
	{
		wait( 0.05 );
		
		if( self.bHasLockOn == true )
		{
			if ( !self IsStillValidTarget( self.laserTarget ) )
			{
				self ClearTarget();
				continue;
			}
				
			if( !self.laserLockOnSound )
			{
				self display_hint_timeout( "fire_hint", 3 );
				self thread LoopLocalLockSound( "javelin_clu_lock", 0.75 );
			}
		}
				
		if( self.laserLockStarted )
		{
			if ( !self IsStillValidTarget( self.laserTarget ) )
			{
				self ClearTarget();
				continue;
			}
			
			timePassed = getTime() - self.laserLockStartTime;
			
			if( timePassed < LOCK_LENGTH )
			{
				continue;
			}
			
			self notify( "stop_lockon_sound" );
			self.bHasLockOn = true;
			
			continue;
		}
		
		bestTarget = self GetLaserTarget();
		
		if( !isDefined( bestTarget ) )
		{
			continue;
		}

		self.laserLockStarted 	= true;
		self.laserLockStartTime = getTime();
		self.laserTarget 		= bestTarget;

		self thread LoopLocalSeekSound( "javelin_clu_aquiring_lock", 0.6 );
	}
}


//===========================================
// 				GetLaserTarget
//===========================================
GetLaserTarget()
{
	targetsAll 	= target_getArray();
	trace 		= self get_laser_designated_trace();
	
	// teleport a script orgin to the hit location
	self.laser_hit_location.origin = trace[ "position" ];

	for( i = 0; i < targetsAll.size; i++ )
	{
		if( targetsAll[ i ] IsTouching( self.laser_hit_location ) )
		{
			return targetsAll[ i ];
		}
	}
	
	return undefined;
}


//===========================================
// 			IsStillValidTarget
//===========================================
IsStillValidTarget( ent )
{
	if( !isDefined( ent ) )
	{
		return false;
	}
	
	if( !target_isTarget( ent ) )
	{
		return false;
	}
	
	target_ent = self GetLaserTarget();
	
	if( !IsDefined( target_ent ) )
	{
		return false;
	}
	
	return ( target_ent == ent );
}


//===========================================
// 				ClearTarget
//===========================================
ClearTarget()
{
	self.laserLockStarted 	= false;
	self.laserLockStartTime = 0;
	self.laserTarget 		= undefined;
	self.bHasLockOn 		= false;
	self.laserLockOnSound	= false;
		
	self notify( "stop_lockon_sound" );
	self notify( "stop_locked_sound" );

	self StopLocalSound( "javelin_clu_lock" );
	self StopLocalSound( "javelin_clu_aquiring_lock" );
}


//===========================================
// 			LoopLocalSeekSound
//===========================================
LoopLocalSeekSound( alias, interval )
{
	assert( self.classname == "player" );

	self endon( "stop_lockon_sound" );

	while( true )
	{
		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );

		wait interval;
	}
}


//===========================================
// 			LoopLocalLockSound
//===========================================
LoopLocalLockSound( alias, interval )
{
	assert( self.classname == "player" );
	
	self endon( "stop_locked_sound" );

	self.laserLockOnSound  = true;
		
	while( true )
	{
		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval / 3;

		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval / 3;

		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval / 3;

		self StopRumble( "stinger_lock_rumble" );
	}
}


//===========================================
// 			warlord_laser_artillery
//===========================================
warlord_laser_artillery( target )
{
	end_locations = GetStructArray( target.target, "targetname" );
	missile	= undefined;
	
	assert( level.air_strike_pos.size == end_locations.size );
	
	wait( 3 );
	
	playfx( getfx( "field_fire_distant2" ), target.origin);
	
	for( i = 0; i < level.air_strike_pos.size; i++ )
	{
		missile = MagicBullet( "stinger_speedy", level.air_strike_pos[i].origin, end_locations[i].origin );
		missile.target_org = end_locations[i].origin;
		self thread play_massive_explosions( missile, target );
		wait( 0.1 );
	}
	
	if( IsDefined( missile ) )
	{
		missile waittill( "death" );
	}
	
	// remove the objective dot
	Objective_AdditionalPosition( level.current_obj_number, target.obj_index, (0, 0, 0) );
	
	if( Target_IsTarget( target ) )
	{
	Target_Remove( target );
	}
	
	targetsAll = target_getArray();
	
	if( targetsAll.size > 0 )
	{
		return;
	}
	
	flag_set( "target_destroyed" );
	
	wait( 6.5 );
	
	flag_set( "mission_end" );
}


//===========================================
// 			play_massive_explosions
//===========================================
play_massive_explosions( missile, target )
{
	target.splosion = 0;
	explosion_loc 	= missile.target_org;
	
	missile waittill( "death" );
	
	playfx( getfx( "mortarExp_debris" ), explosion_loc );
	thread play_sound_in_space( "npc_3d_mortar", explosion_loc );
	
	if( target.splosion < 2 )
	{
		playfx( getfx( "artillery" ), explosion_loc);

		if( cointoss() )
		{
			target.splosion++;
			thread play_sound_in_space( "npc_2d_mortar", self.origin );
		}
	}
}


//===========================================
// 			monitor_damage_triggers
//===========================================
monitor_damage_triggers()
{
	level endon( "special_op_terminated" );
	
	while( true )
	{
		// watch the damage triggers for a predator missile hit
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		
		if( amount > 2050 )
		{
			self DoDamage( 500, self.origin, attacker );
			break;
		}
	}
}


//===========================================
// 				run_church_ai
//===========================================
run_church_ai()
{
	level endon( "special_op_terminated" );
	
	/#
	if( CONST_check_point == "dog" )
	{
		warlord_turrets = GetEntArray( "warlord_turret", "script_noteworthy" );
	
		for( i  = 0; i < warlord_turrets.size; i++)
		{
			warlord_turrets[i] common_scripts\_sentry::SentryPowerOff();
		}
		
		level thread run_random_dog_spawner( "church_exit_ai", "dog_spawner_church" );
		wait( 1.0 );
		
		level.kill_count = 8;
		
		return;
	}
	
	if( CONST_check_point != "none" )
	{
		flag_set( "found_all_church_loot" );
		flag_set( "church_exit" );
		flag_set( "alley_entrance" );
		
		level.loot.numLootFound 	= CONST_loot_church_number;
		level.loot.numLootDropped 	= CONST_loot_church_number;
		
		level thread display_loot_hud( level.player );
		level thread run_church_escape_triggers();
		
		teleport_player( GetStruct( "alley_checkpoint", "targetname" ) );

		return;
	}
	#/
	
	level thread run_church_escape_triggers();
	level thread run_random_dog_spawner( "church_exit_ai", "dog_spawner_church" );
	level thread church_intial_ai();
	
	monitor_ai_trigger( "so_stealth_warlord_start", "trigger01_church_ai" );
	monitor_ai_trigger( "trigger02_church_ai", "trigger02_church_ai" );
	monitor_ai_trigger( "trigger03_church_ai", "trigger03_church_ai" );
	level thread monitor_ai_trigger( "church_exit_ai", "church_exit_ai_rush" );
}


//===========================================
// 			run_church_escape_triggers
//===========================================
run_church_escape_triggers()
{
	level endon( "special_op_terminated" );
	
	targetname_hide( "church_exit" );
	targetname_hide( "church_exit_ai" );
	targetname_hide( "alley_entrance" );
	
	flag_wait( "found_all_church_loot" );
	
	targetname_hide( "church_escape_trigger" );
	targetname_show( "church_exit" );
	targetname_show( "church_exit_ai" );
	targetname_show( "alley_entrance" );
	
	level thread obj_fail_safe();
}


//===========================================
// 				obj_fail_safe
//===========================================
obj_fail_safe()
{
	level endon( "special_op_terminated" );
	
	flag_wait( "alley_entrance" );
	flag_set( "church_exit" );
	
	// refill offhand ammo
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i] GiveMaxAmmo( "semtex_grenade" );
		level.players[i] GiveMaxAmmo( "flash_grenade" );
	}
	
	if( !flag( "church_exit_ai" ) )
	{
		targetname_hide( "church_exit_ai" );
		level notify( "stop_random_dog_spawner" );
	}
}


//===========================================
// 			run_random_dog_spawner
//===========================================
run_random_dog_spawner( end_on_flag, spawner_targetname )
{
	level endon( "special_op_terminated" );
	level endon( "stop_random_dog_spawner" );
	
	required_kills = RandomIntRange( CONST_dog_min_kills, CONST_dog_max_kills + 1 );
	level.kill_count = 0;
	
	while( !flag( end_on_flag ) )
	{
		wait( 0.5 );
		
		if( level.kill_count >= required_kills )
		{
			level spawn_so_warlord_dog( spawner_targetname, "church_dog_fail_safe" );
			
			level.kill_count = level.kill_count - required_kills;
			required_kills = RandomIntRange( CONST_dog_min_kills, CONST_dog_max_kills + 1 );
		}
	}
}


//===========================================
// 			spawn_so_warlord_dog
//===========================================
spawn_so_warlord_dog( spawner_targetname, exit_targetname )
{
	dog_spawners = GetEntArray( spawner_targetname, "targetname" );
	
	for( i = 0; i < dog_spawners.size; i++)
	{
		dog = dog_spawners[i] spawn_ai( true );
		
		if( !IsDefined( dog ) )
		{
			return;
		}
		
		victim = level.player;
		
		// chance to set coop player as the inital target
		if( is_coop() && cointoss() )
		{
			victim = level.player2;
		}
		
		dog SetGoalEntity( victim );
		dog set_favoriteenemy( victim );
		
		exit_point = GetEnt( exit_targetname, "targetname" );
		dog thread maps\ss_util::dog_monitor_goal_ent( victim, exit_point );
	}
}


//===========================================
// 			   church_intial_ai
//===========================================
church_intial_ai()
{
	enemies = GetEntArray( "initial_church_ai", "targetname" );
	ai		= [];
	
	for( i = 0; i < enemies.size; i++ )
	{
		ai[i] = enemies[i] spawn_ai();
		ai[i].oldmaxsightdistsqrd = ai[i].maxsightdistsqrd;
		ai[i].maxsightdistsqrd 	= 256 * 256;
		ai[i] disable_long_death();
		ai[i] thread monitor_shot_fired();
	}
	
	flag_wait( "so_stealth_warlord_start" );
	
	for( i = 0; i < ai.size; i++ )
	{
		if( IsDefined( ai[i] ) && IsAlive( ai[i] ) )
		{
			ai[i].maxsightdistsqrd = ai[i].oldmaxsightdistsqrd;
		}
	}
}


//===========================================
// 			   monitor_shot_fired
//===========================================
monitor_shot_fired()
{
	level 	endon( "special_op_terminated" );
	self 	endon( "death" );
	
	self addAIEventListener( "gunshot" );
	self addAIEventListener( "bulletwhizby" );
	self addAIEventListener( "projectile_impact" );
	self addAIEventListener( "explode" );
	
	while( IsAlive( self ) )
	{
		self waittill( "ai_event", eventtype );
		
		if ( ( eventtype == "damage" ) || ( eventtype == "gunshot" ) || ( eventtype == "bulletwhizby" ) || ( eventtype == "projectile_impact" ) || ( eventtype == "explode" ) )
		{
			break;
		}
	}
	
	flag_set( "so_stealth_warlord_start" );
}


//===========================================
// 				run_alley_ai
//===========================================
run_alley_ai()
{
	level endon( "special_op_terminated" );
	
	/#
	if( CONST_check_point == "sewer" )
	{
		flag_set( "found_all_loot" );
		flag_set( "sewer_entrance" );
		
		level.loot.numLootFound 	= CONST_loot_total_number;
		level.loot.numLootDropped 	= CONST_loot_total_number;
		
		level thread display_loot_hud( level.player );
		level thread run_alley_escape_triggers();
		
		teleport_player( GetStruct( "sewer_checkpoint_debug", "targetname" ) );

		if( is_coop() )
		{
			object = GetStruct( "sewer_checkpoint_debug2", "targetname" );
			level.player2 SetOrigin( object.origin );
    		level.player2 SetPlayerAngles( object.angles );
		}

		return;
	}
	#/
	
	level thread run_alley_escape_triggers();
	
	monitor_ai_trigger( "trigger01_alley_ai", "trigger01_alley_ai" );
	spawn_so_warlord_dog( "trigger01_alley_ai_dog", "alley_fail_safe" );
	
	monitor_ai_trigger( "trigger02_alley_ai", "trigger02_alley_ai" );
	spawn_so_warlord_dog( "trigger02_alley_ai_dog", "alley_fail_safe" );
	
	flag_wait( "trigger03_alley_ai" );
	spawn_so_warlord_dog( "trigger03_alley_ai_dog", "alley_fail_safe" );
}


//===========================================
// 			run_alley_escape_triggers
//===========================================
run_alley_escape_triggers()
{
	level endon( "special_op_terminated" );
	
	targetname_hide( "sewer_entrance" );
	
	flag_wait( "found_all_loot" );
	
	targetname_hide( "alley_escape_trigger" );
}


//===========================================
// 				run_alley_ai
//===========================================
run_sewer_ai()
{
	level endon( "special_op_terminated" );
	
	level thread monitor_ai_trigger( "trigger01_sewer_ai", "trigger01_sewer_ai" );
	level thread monitor_ai_trigger( "tower_entrance", "tower_ai" );
	
	flag_wait( "base_ai_spawn" );
	array_spawn_noteworthy( "mortar_rpg_guys_1" );
}


//===========================================
// 			monitor_ai_trigger
//===========================================
monitor_ai_trigger( flag_to_watch, spawner_targername )
{
	flag_wait( flag_to_watch );
	targetname_spawn( spawner_targername );
}
	
	
//===========================================
// 			targetname_spawn
//===========================================
targetname_spawn( targetname )
{
	enemies = GetEntArray( targetname, "targetname" );
	array_thread( enemies, ::spawn_ai );
}


//===========================================
// 			targetname_hide
//===========================================
targetname_hide( targetname )
{
	ent = GetEntArray( targetname, "targetname" );
	array_thread( ent, ::hide_entity );
}


//===========================================
// 			targetname_show
//===========================================
targetname_show( targetname )
{
	ent = GetEntArray( targetname, "targetname" );
	array_thread( ent, ::show_entity );
}
