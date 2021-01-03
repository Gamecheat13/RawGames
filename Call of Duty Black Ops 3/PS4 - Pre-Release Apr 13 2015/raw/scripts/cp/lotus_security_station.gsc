#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\player_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_vehicle_platform;

#using scripts\cp\lotus_util;
#using scripts\cp\bonuszm\_weaponboxzm;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       






#precache( "objective", "cp_level_lotus_get_weapons" );
#precache( "objective", "cp_level_lotus_to_security_station" );
#precache( "objective", "cp_level_lotus_hack_the_system" );
#precache( "material", "t7_hud_prompt_pickup_64" );
#precache( "string", "COOP_AMMO_REFILL" );
#precache( "string", "cairotroops" );
#precache( "triggerstring", "CP_MI_CAIRO_LOTUS_HACK_SYSTEM" );
#precache( "triggerstring", "CP_MI_CAIRO_LOTUS_GRAB_SHOTGUN" );
#precache( "triggerstring", "CP_MI_CAIRO_LOTUS_OPEN_GRATE" );
#precache( "triggerstring", "CP_MI_CAIRO_LOTUS_GRAB_WEAPONS" );

function main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
		skipto::teleport_ai( str_objective );

		level scene::init( "cin_lot_04_01_security_vign_beaten" );
		level scene::init( "cin_lot_04_01_security_vign_holddown" );
		level scene::init( "cin_lot_04_01_security_vign_weapon" );
		level scene::init( "cin_lot_04_01_security_vign_weapon_khalil" );
		level scene::init( "cin_lot_04_01_security_vign_weaponcivs" );
		level scene::init( "p7_fxanim_cp_lotus_monitors_atrium_fall_bundle" );
		level thread scene::play( "assassination_bodies", "targetname" );
	}
	
	objectives::set( "cp_level_lotus_to_security_station" );
	level thread apartment_main();

	trigger::wait_till( "apartments_complete" );
	skipto::objective_completed( "apartments" );
}

function apartments_done( str_objective, b_starting, b_direct, player )
{
}

function atrium_battle( str_objective, b_starting )
{	
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		level.ai_khalil = util::get_hero( "khalil" );
		
		level scene::init( "p7_fxanim_cp_lotus_monitors_atrium_fall_bundle" );
		level scene::init( "cin_lot_04_03_security_vign_stairshot" );
		
		{wait(.05);};//give scenes time to initialize
		
		trigger::wait_till( "apartments_complete" );
		
		level scene::play( "cin_lot_04_03_security_vign_stairshot" );
		skipto::teleport_ai( str_objective );
		
		objectives::set( "cp_level_lotus_to_security_station" );
	}
	
	level scene::init( "cin_lot_04_06_security_vign_entermobile" );
	
	scene::add_scene_func( "cin_lot_04_06_security_vign_entermobile", &unload_mobile_1, "play" );
	
	level thread init_player_mobile_shop();
	level thread set_atrium_threat_bias();
	level thread transition_mobile_shop();
	
	level thread rear_enemy_support();
	level thread side_support();
	level thread atrium_mobile();
	
	level thread atrium_battle_vo();
	level thread sec_station_enter_mobile();
	level thread warp_hendricks_temp();//TODO - setup proper pathing/traversals to this point
	//level thread raise_security_windows( 0.1 );
	level thread mobile_shop_ride();
	level thread atrium_ambient_high();
	
	flag::wait_till( "start_atrium_battle" );
	
	spawn_manager::enable( "sm_tower1" );
	trigger::use( "atrium_ambient_battles" );
	
	trigger::wait_till( "atrium_done" );
	skipto::objective_completed( "atrium_battle" );
}

function atrium_battle_done( str_objective, b_starting, b_direct, player )
{
}

function to_security_station( str_objective, b_starting )
{	
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		//level.ai_khalil = util::get_hero( "khalil" );
		
		level thread scene::skipto_end( "p7_fxanim_cp_lotus_monitors_atrium_fall_bundle" );
		level scene::init( "cin_lot_04_09_security_vign_flee" );
		level scene::init( "cin_lot_04_07_security_vign_headshot" );
		level scene::init( "security_melee1", "targetname" );
		level scene::init( "security_melee2", "targetname" );
		level scene::init( "security_melee3", "targetname" );
		trigger::use( "security_spawner" );
		
		//level thread raise_security_windows( 0.1 );
		
		{wait(.05);};//give scenes time to initialize
		
		skipto::teleport_ai( str_objective );
		trigger::use( "atrium_done" );
		
		objectives::set( "cp_level_lotus_to_security_station" );
		
		//move shop into place
	}
	
	scene::add_scene_func( "p7_fxanim_cp_lotus_wall_hole_nrc_raps_bundle", &wall_breach );
	
	level thread security_station_vo();
	//level thread security_windows();
	
	trigger::wait_till( "to_security_station_done" );
	skipto::objective_completed( "to_security_station" );
}

function to_security_station_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_lotus_to_security_station" );
	if ( IsDefined( level.ai_khalil ) )
	{
		level.ai_khalil Delete();
	}
}

function hack_the_system_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		skipto::teleport_ai( str_objective );
		
		level scene::init( "cin_lot_04_09_security_1st_kickgrate" );

		//re-create security battle
		scene::skipto_end_noai( "cin_lot_04_09_security_vign_flee" );
		level thread scene::skipto_end( "p7_fxanim_cp_lotus_wall_hole_nrc_raps_bundle" );
		level thread scene::skipto_end( "p7_fxanim_cp_lotus_monitors_atrium_fall_bundle" );
	}
	
	level thread hack_the_system_vo();
	level thread hendricks_airduct();
	level thread setup_grate_trigger();
	
	trigger::wait_till( "security_station_start" );
	
	// close the path behind the players (we're fine with just clipping it off so they can't jump up into the hole while the fight plays out)
	e_security_station_cap = GetEnt( "security_station_cap", "targetname" );
	e_security_station_cap MoveTo( e_security_station_cap.origin - ( 0, 0, 128 ), 0.05 );
	
	spawn_manager::wait_till_cleared( "sm_security_station" );//Don't show next objective until room is cleared
	flag::set( "hack_the_system_ready" );//Activate trigger, play VO
	
	t_hack = GetEnt( "hack_the_system", "targetname" );
	t_hack SetHintString( &"CP_MI_CAIRO_LOTUS_HACK_SYSTEM" );
	objectives::set( "cp_level_lotus_hack_the_system", t_hack.origin );
	
	t_hack trigger::wait_till();
	skipto::objective_completed( "hack_the_system" );
}

function hack_the_system_done( str_objective, b_starting, b_direct, player )
{
	objectives::complete( "cp_level_lotus_hack_the_system" );
}

function prometheus_otr_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		skipto::teleport_ai( "prometheus_otr" );
		
		//re-create security battle & enter
		scene::skipto_end_noai( "cin_lot_04_09_security_vign_flee" );
		scene::skipto_end_noai( "cin_lot_04_09_security_1st_kickgrate" );

		a_weapon_trig = GetEntArray( "security_juiced_shotgun_trigger", "script_noteworthy" );
		array::run_all( a_weapon_trig, &TriggerEnable, false );		
		
		level flag::wait_till( "first_player_spawned" );
	}
	
	level scene::play( "p7_fxanim_cp_lotus_monitor_security_bundle" );
	level thread temp_assets_for_prometheus_otr();
	level scene::play( "cin_lot_06_01_prometheus_vign_approach" );
	
	level thread scene::play( "security_station_light", "targetname" );
	
	// TODO: temp until fx anim adjust the animation with the new doors
	a_doors = GetEntArray( "security_door_intact", "targetname" );
	array::run_all( a_doors, &Delete );
	
	level security_station_breach();
	
	skipto::objective_completed( "prometheus_otr" );

	// TODO: should we close the door behind the players once they leave the sec station?
}

function temp_assets_for_prometheus_otr()
{
	level.players[0] dialog::say( "kane_there_are_special_ju_0" );//There are special juiced ammo shotguns in the gun lockers. I've reprogrammed the weapon's biometric security to allow you to use it.
	level thread unlock_weapon_locker();
	
	level thread util::screen_message_create( "Prometheus is displayed on all monitors during this scene.", undefined, undefined, 0, 21 );
	lui::play_movie( "cairotroops", "pip" );
}
	
function prometheus_otr_done( str_objective, b_starting, b_direct, player )
{
	
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

function init()
{
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
	{
		level thread init_weapon_crate();
	}
	else
	{
		level thread _weaponboxzm::init_weaponboxzm_crate_from_ammocrates_lotus( "weapon_crate" );

	}

	spawner::add_spawn_function_group( "apartments_civ", "targetname", &init_apartment_civs );
	spawner::add_spawn_function_group( "apartments_fodder", "targetname", &init_apartment_fodder );
	spawner::add_spawn_function_group( "apartment_ally", "targetname", &init_egyptians );	
	spawner::add_spawn_function_group( "apartment_wave1", "targetname", &init_wave1 );
	spawner::add_spawn_function_group( "apartments_runners", "targetname", &init_apartment_runners );	
	
	spawner::add_spawn_function_group( "atrium_battle_main", "script_noteworthy", &set_threat_bias_group, "atrium_main" );
	spawner::add_spawn_function_group( "mobile0_interior_soldiers", "script_noteworthy", &exit_elevator );
	spawner::add_spawn_function_group( "atrium_runners", "targetname", &init_atrium_runners );
	spawner::add_spawn_function_group( "lvl_one_ambient", "script_noteworthy", &init_lvl_one );
	spawner::add_spawn_function_group( "second_balcony_soldiers", "script_noteworthy", &set_threat_bias_group, "second_balcony_lower" );
	spawner::add_spawn_function_group( "balcony_one_chase", "script_noteworthy", &set_threat_bias_group, "second_balcony_upper" );	
	
	spawner::add_spawn_function_group( "balcony_one_chase", "script_noteworthy", &kill_at_goal );
	spawner::add_spawn_function_group( "atrium_19_soldiers", "targetname", &kill_at_goal );
	spawner::add_spawn_function_group( "atrium_19b_soldiers", "targetname", &kill_at_goal );
	
	spawner::add_spawn_function_group( "fleeing_civ", "script_noteworthy", &to_security_station_fleeing_civ );
	spawner::add_spawn_function_group( "security_station_first_wave", "targetname", &security_station_first_wave );
	
	spawner::add_spawn_function_group( "headshot_robots", "script_noteworthy", &initial_battle_sm );
	spawner::add_spawn_function_group( "ss_wave1_enemy", "targetname", &wave1_retreat );
}

function init_weapon_crate()
{
	e_visual = GetEnt( "weapon_crate", "targetname" );
	e_visual DisconnectPaths();

	e_trigger = GetEnt( "weapon_crate_trigger", "targetname" );
	e_trigger TriggerIgnoreTeam();
	e_trigger SetVisibleToAll();
	e_trigger SetTeamForTrigger( "none" );
	e_trigger UseTriggerRequireLookAt();
	e_trigger SetCursorHint( "HINT_NOICON" );
	e_trigger.a_players_cooldown = [];
	e_trigger.a_n_players_cooldown = [];

	s_ammo_cache_object = gameobjects::create_use_object( "any", e_trigger, Array( e_visual ), ( 0, 0, 32 ) );

	s_ammo_cache_object gameobjects::allow_use( "any" );
	s_ammo_cache_object gameobjects::set_use_time( 1 );
	s_ammo_cache_object gameobjects::set_use_text( &"COOP_AMMO_REFILL" );
	s_ammo_cache_object gameobjects::set_use_hint_text( &"CP_MI_CAIRO_LOTUS_GRAB_WEAPONS" );
	s_ammo_cache_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_pickup_64" );
	s_ammo_cache_object gameobjects::set_visible_team( "any" );
	s_ammo_cache_object.onUse = &give_back_weapons;
	s_ammo_cache_object.useWeapon = undefined;	
	
	level flag::wait_till( "all_players_connected" );
	s_ammo_cache_object thread gameobjects::hide_icon_distance_and_los( (1,1,1), 42*20, true );
	
	e_weapon_crate = GetEnt( "keyline_crate", "targetname" );
	e_weapon_crate thread oed::enable_keyline( true );		
}

function give_back_weapons( player )
{	
	//only give back if we've taken them for the riotshield
	if( isdefined( player._weapons ) )
	{
		player TakeAllWeapons();
		player player::give_back_weapons();
		
		player.laststandpistoloverride = undefined;//reset back to default
	}
	
	player ammo_refill();
}

//self = player
function ammo_refill()
{
	a_w_weapons = self GetWeaponsList();

	foreach ( w_weapon in a_w_weapons )
	{
		self GiveMaxAmmo( w_weapon );
		self SetWeaponAmmoClip( w_weapon, w_weapon.clipSize );
	}
}

function sec_station_enter_mobile()
{
	e_mobile_armory = lotus_util::mobile_shop_setup( "mobile_security_1_group", true, true, true, "veh_t7_turret_auto_sentry" );
	
	trigger::wait_till( "end_atrium_battle" );
	
	trigger::use( "mobile_security_1_trigger", "script_noteworthy" );
	
	foreach ( turret in e_mobile_armory.a_miniguns )
	{		
		turret thread turret_target_update();
	}
	
	level waittill( "fire_molotov" );
	
	s_molotov = struct::get( "security_molotov_origin" );
	foreach ( turret in e_mobile_armory.a_miniguns )
	{		
		v_velocity = VectorNormalize( turret.origin - s_molotov.origin ) * 3000;
		level.players[0] MagicGrenadeType( GetWeapon( "molotov_grenade" ), s_molotov.origin + ( 0, 0, 25 ), v_velocity );
		
		wait .5;//give a bit of time between molotov throws		
	}	
}

//TODO - add in proper positions/structs to cycle through once we decide how this sequence will go
//We don't want allies getting hit here, target other areas
//TODO replace with FX
function turret_target_update()
{
	level endon( "fire_molotov" );
	
	a_s_targets = struct::get_array( "security_platform_target" );
	
	while( true )
	{
		s_current_target = a_s_targets[ RandomIntRange( 0, a_s_targets.size ) ];
		for ( x = 0; x < 50; x++ )
		{
			MagicBullet( GetWeapon( "ar_standard" ), self GetTagOrigin( "tag_barrel" ) + ( 0, -40, 0 ), s_current_target.origin );
		}
		
		wait RandomFloatRange( .5, 1.5 );//Time between bursts
	}
}

function wall_breach( a_ents )
{
	spawn_manager::enable( "sm_wall_breech" );
	spawn_manager::enable( "sm_wall_breech_raps" );
}

function warp_hendricks_temp()
{
	level flag::wait_till( "warp_hendricks_ss" );
	s_warp = struct::get( "to_security_station_ai" );
	
	level.ai_hendricks ForceTeleport( s_warp.origin, s_warp.angles );
}

//////////////////////////////////////////////////////////
// APARTMENT BATTLE
//////////////////////////////////////////////////////////

function apartment_main()
{
	level thread apartment_battle_vo();
	level thread setup_axis();
	level thread open_fire();
	
	trigger::wait_till( "start_apartment_battle" );
	spawn_manager::wait_till_ai_remaining( "sm_apartment_e_wave1", 3 );
	spawn_manager::enable( "sm_apartment_wave2" );//Or enable by trigger
}

function init_egyptians()
{
	//protect certian allied soldiers
	if( IsDefined( self.script_noteworthy ) )
	{
		self util::magic_bullet_shield();
	}
}

function setup_axis()
{	
	trigger::wait_till( "enter_apartments" );
	level thread disable_enemy_bullet_shield();//player is close, disable shield
}

function init_wave1()
{
	if( !level flag::get( "apartment_clear_magic_bullet" ) )
	{
		//protect setup enemies until player is close
		self util::magic_bullet_shield();
		if( ( isdefined( self.script_int ) && self.script_int ) )
		{
			self.goalradius = 16;//keep specified enemies at their goal nodes for cover
		}
	}
}

function disable_enemy_bullet_shield()
{
	a_enemy = GetEntArray( "apartment_wave1_ai", "targetname" );
	foreach( enemy in a_enemy )
	{
		enemy util::stop_magic_bullet_shield();		
	}
}

function init_apartment_civs()
{
	self endon( "death" );
	
	self waittill( "goal" );
	
	nd_target = GetNode( self.target, "targetname" );
	s_scene = struct::get( nd_target.target );
	e_door = GetEnt( "event_4_2_door_0" + self.script_int, "targetname" );
	//e_door scene::play( s_scene.targetname, "targetname", Array( self, e_door ) );//TODO - talk to animation
}

function init_apartment_fodder()
{
	self endon( "death" );
	
	wait 2.5;//Give some time to flee
	
	self.ignoreme = false;
	
	wait 1;//Give time for AI to kill him
	self Kill();//Just in case AI are too slow, we don't want him to survive
}

function apartment_battle_vo()
{
	trigger::wait_till( "apartment_battle_moveto" );
	e_ally = GetEnt( "ally_wave", "script_string" );
	level.players[0] dialog::say( "egyp_help_us_out_we_re_p_0" );//Help us out, we're pinned down over here!//TODO - get this added to anim
	level scene::play( "cin_lot_04_02_security_vign_wave", e_ally );
	
	if ( IsAlive( e_ally ) )
	{
		e_ally util::stop_magic_bullet_shield();
	}
}

function init_apartment_runners()
{
	self endon( "death" );
	
	self waittill( "goal" );
	
	s_source = struct::get( "apartment_fire_source" );	
	self Kill( s_source.origin );
}

function open_fire()
{
	trigger::wait_till( "apartment_runners" );
	
	s_source = struct::get( "apartment_fire_source" );
	s_target = struct::get( "apartment_fire_target" );
	weapon = GetWeapon( "ar_standard" );
	
	for( x = 0; x < 50; x++ )
	{
		MagicBullet( weapon, s_source.origin, s_target.origin + ( RandomIntRange( -50, 50 ), RandomIntRange( -50, 50 ), RandomIntRange( -50, 50 ) ) );
		wait .1;
	}
}

/////////////////////////////////////////////////////////
//ATRIUM BATTLE
/////////////////////////////////////////////////////////

function atrium_mobile()
{
	level thread mobile_enemies();
	
	mobile_shop = GetEnt( "mobile_shop_0", "targetname" );
	mobile_clip = GetEnt( "mobile_0_clip", "targetname" );
	mobile_clip LinkTo( mobile_shop );
	
	nd_traversal_mobile1 = GetNode( "entermobile1_start", "targetname" );
	LinkTraversal( nd_traversal_mobile1 );	
	
	//trigger::wait_till( "mobile_0_start", "script_noteworthy" );//HACK - switch this back once elevator system supports trigger_once
	t_mobile_start = GetEnt( "mobile_0_start", "script_noteworthy" );
	t_mobile_start waittill( "trigger" );
	t_mobile_start TriggerEnable( false );
	trigger::use( "mobile_0_soldiers" );
	
	level waittill( "mobile_0_unload" );//Elevator has reached first stop
	
	nd_traversal_interior = GetNode( "start_mobile_0_interior_across_128", "targetname" );
	LinkTraversal( nd_traversal_interior );
	
	level waittill( "atrium_shop_unloaded" );//Soldiers have exited or have been killed
	
	UnlinkTraversal( nd_traversal_interior );
	
	level waittill( "mobile_0_stopped" );//Elevator has reached final stop
	
	nd_traversal_floor = GetNode( "start_mobile_0_top_across_128", "targetname" );
	LinkTraversal( nd_traversal_floor );
	nd_traversal_accross = GetNode( "start_mobile_0_across_128", "targetname" );
	LinkTraversal( nd_traversal_accross );
	nd_traversal_side = GetNode( "start_mobile_0_up_160", "targetname" );
	LinkTraversal( nd_traversal_side );
	
	flag::wait_till( "shop_1_elevator_up" );
	UnlinkTraversal( nd_traversal_mobile1 );
}

function mobile_enemies()
{
	level waittill( "mobile_0_unload" );//Elevator has reached first stop
	
	level flag::wait_till( "mobile_0_unloaded" );//TODO - setup failsafe if soldiers don't make it out for some reason
	level notify( "atrium_shop_unloaded" );//Start elevator moving again
}

//self = ai
function exit_elevator()
{	
	self endon( "death" );
	
	self SetThreatBiasGroup( "atrium_main" );
	
	level waittill( "mobile_0_unload" );
	
	nd_goal = GetNode( self.script_string, "targetname" );
	self SetGoal( nd_goal, true );
}

function rear_enemy_support()
{
	e_door = GetEnt( "hallway_gate_07", "targetname" );
	e_door MoveZ( 130, .5 );
	e_door ConnectPaths();
	
	trigger::wait_till( "close_atrium_door" );

	e_door MoveZ( -130, 2 );
	e_door DisconnectPaths();	
}

function side_support()
{
	e_door = GetEnt( "apartment_gate_03", "targetname" );
	e_door MoveZ( 130, .5 );
	
	level flag::wait_till( "close_runner_door" );

	e_door MoveZ( -130, 3 );
}

function unload_mobile_1( a_ents )
{	
	foreach( entity in a_ents )
	{
		entity thread unload_and_delete();
	}
	
	level waittill( "vehicle_platform_mobile_shop_1_stop" );//Elevator has reached end
	
	nd_traversal_mobile1 = GetNode( "start_mobile_1_interior_across_128", "targetname" );
	LinkTraversal( nd_traversal_mobile1 );
	nd_traversal2_mobile1 = GetNode( "start_mobile_1_roof_across_128", "targetname" );
	LinkTraversal( nd_traversal2_mobile1 );	
}

function unload_and_delete()
{
	self endon( "death" );
	
	level waittill( "vehicle_platform_mobile_shop_1_stop" );//Elevator has reached end
	
	self.goalradius = 16;
	self ai::set_goal( "mobile_1_goal" );
	self util::waittill_any_timeout( 10, "goal" );//Failsafe if they can't get out
	self Delete();
}

function atrium_battle_vo()
{
	trigger::wait_till( "atrium_battle_initial_moveto" );
	level.players[0] dialog::say( "kane_get_to_the_security_0" );//Get to the Security Station on level 25 to gain access and find Prometheus.
	level.ai_hendricks dialog::say( "hend_we_can_move_up_the_s_0" );//We can move up the stationary mobile shops to continue our way to the security station.
}

function set_atrium_threat_bias()
{
	CreateThreatBiasGroup( "lvl_one_ambient" );
	CreateThreatBiasGroup( "atrium_main" );
	SetIgnoreMeGroup( "lvl_one_ambient", "atrium_main" );
	SetIgnoreMeGroup( "atrium_main", "lvl_one_ambient" );
	
	CreateThreatBiasGroup( "second_balcony_upper" );
	CreateThreatBiasGroup( "second_balcony_lower" );
	SetIgnoreMeGroup( "second_balcony_upper", "second_balcony_lower" );
	SetIgnoreMeGroup( "second_balcony_lower", "second_balcony_upper" );	
}

//self = ai
function set_threat_bias_group( str_threat_bias )
{
	self SetThreatBiasGroup( str_threat_bias );
}

//self = ai
function init_atrium_runners()
{
	self endon( "death" );
	
	wait 1;//Give some time to flee
	
	self.ignoreme = false;
	
	self waittill( "goal" );
	
	self Kill();
}

//self = ai
function init_lvl_one()
{
	self SetThreatBiasGroup( "lvl_one_ambient" );
	self thread kill_at_goal();
}

//self = ai
function kill_at_goal()
{
	self endon( "death" );
	
	self waittill( "goal" );
	
	self Kill();
}

function mobile_shop_ride()
{
	level thread balcony_one();	
}

function balcony_one()
{
	level flag::wait_till( "shop_1_elevator_up" );
	spawn_manager::disable( "sm_atrium_ambient_floor_one_nrc" );
	spawn_manager::disable( "sm_atrium_ambient_floor_one_civ" );
	
	trigger::use( "balcony_one_chase" );
	
	wait 1;//Give a bit of time for elevator to start moving
	
	trigger::use( "balcony_one_chase" );
	trigger::use( "atrium_ambient_19" );
	trigger::use( "atrium_ambient_19b" );
	trigger::use( "atrium_ambient_20" );
	
	wait 4;//wait a bit for the elevator to go up more
	
	spawn_manager::enable( "mobile1_wasps" );
}

function atrium_ambient_high()
{
	//level thread ambient_wasps();//TODO - we might not be able to afford these
	
	//level thread ambient_tracer();//TODO - replace with FX
	//level thread its_raining_men();//TODO - replace with anims
	
	//TODO
	//mobile shop movement
	//lookat triggers for scenes
	
	flag::wait_till( "shop_1_elevator_up" );
	level notify( "raining_men" );//Stop lvl 1 rain man
}

function ambient_wasps()
{
	spawn_manager::enable( "sm_ambient_one" );
	level thread cleanup_ambient_wasps();
}

function cleanup_ambient_wasps()
{
	flag::wait_till( "security_system_hacked" );
	
	spawn_manager::kill( "sm_ambient_one", true );
}

//TODO - work with code to see if we can bump the ragdoll timeout
//TODO - hook up lvl 2,3
function its_raining_men( n_level = 1 )
{
	level notify( "raining_men" );
	level endon( "raining_men" );
	
	switch( n_level )
	{
		case 1:
			n_time_between = 2;
			b_fire = false;			
			break;
			
		case 2:
			n_time_between = 1;
			b_fire = false;			
			break;

		case 3:
			n_time_between = 1;
			b_fire = true;			
			break;				
	}
	
	while( true )
	{
		a_drops = struct::get_array( "corpse_drop" );
		s_drop = a_drops[ RandomInt( a_drops.size ) ];
		
		//TODO hook up other types
		//mdl_corpse = util::spawn_model( "c_test_scientist_t7", s_drop.origin );//TODO - talk to Snider about issues with non-ai
		mdl_corpse = spawner::simple_spawn_single( "rainman" );
		mdl_corpse ForceTeleport( s_drop.origin + ( RandomIntRange(-200, 200), RandomIntRange(-200, 200), 0 ), s_drop.angles );
		mdl_corpse StartRagdoll();
		mdl_corpse Kill();
		
		wait n_time_between * 60;
	}
}

function init_player_mobile_shop()
{
	flag::wait_till( "entermobile_done" ); // make sure the scene has also finished
	trigger::wait_till( "mobile_shop_1_start_trigger", "script_noteworthy" );
//	trigger::wait_till( "mobile_shop_1_start_trigger", "script_noteworthy", level.ai_hendricks ); // ensure Hendricks is also inside the allplayers trigger TODO: add the Hendricks check here when he's smart enough to follow the player instead of standing behind shooting at enemies a mile away
	
	level.ai_hendricks SetGoal( level.ai_hendricks.origin );
	
	level.o_player_platform = new cVehiclePlatform();
	[[ level.o_player_platform ]]->init( "mobile_shop_1", "mobile_shop_1_start_node" );	
}

function transition_mobile_shop()
{
	flag::wait_till( "entermobile_start" );
	
	//disable Khalil
	level.ai_khalil colors::disable();
	
	//wait for security platform to be clear
	level waittill(  "fxanim_safe" );
	
	scene::play( "p7_fxanim_cp_lotus_monitors_atrium_fall_bundle" );
}

//////////////////////////////////////////////////////////////////////////////
// TO THE SECURITY STATION
/////////////////////////////////////////////////////////////////////////////

function initial_battle_sm()
{
	level endon( "kill_headshot_watcher" );
	
	self waittill( "death" );
	
	spawn_manager::enable( "sm_after_mobile_shop1" );//Or enable by trigger
	level notify( "kill_headshot_watcher" );
}

function wave1_retreat()
{
	self endon( "death" );
	
	level flag::wait_till( "retreat_to_security_station" );
	
	self.script_goalvolume = "security_station_rear";
	self spawner::set_goal_volume();//Fall back to security doors
}

function setup_grate_trigger()
{
	t_security_station_grate = GetEnt( "security_station_grate", "targetname" );
	t_security_station_grate SetHintString( &"CP_MI_CAIRO_LOTUS_OPEN_GRATE" );
}

function security_windows()
{
	//level flag::wait_till( "security_station_lockdown" );
	
	level thread lower_security_windows();
	level thread raise_security_doors();
}

function raise_security_doors()
{
	level thread alarm_snd();

	PlaySoundAtPosition ("evt_bell_ring", ( -7833, 403, 4418 ));
	
	e_left_door = GetEnt( "robot_door_A", "targetname" );
	e_right_door = GetEnt( "robot_door_B", "targetname" );
	
	e_left_door MoveZ( 100, 1 );
	
	e_rollunder = spawner::simple_spawn_single( "security_station_rollunder_guy" );
	e_right_door MoveZ( 30, .25 );
	scene::play( "security_station_rollunder", "targetname", e_rollunder );
}

function raise_security_windows( n_speed )
{
	for( x = 2; x < 7; x++ )
	{
		e_window = GetEnt( "security_win_cover_0" + x, "targetname" );
		e_window MoveZ( 230, n_speed );
	}
}

function lower_security_windows()
{
	for( x = 2; x < 7; x++ )
	{
		e_window = GetEnt( "security_win_cover_0" + x, "targetname" );
		PlaySoundAtPosition ("evt_security_windows_1", ( -8076, 865, 4213 ));
		PlaySoundAtPosition ("evt_security_windows_2", ( -7575, 858, 4215 ));
		PlaySoundAtPosition ("evt_security_door", ( -8573, 824, 4189));
		e_window MoveZ( -230, 2 );
		wait .2;//Give a bit of time between each window
	}
}

function security_station_vo()
{
	trigger::wait_till( "air_duct_moveto" );
	level.players[0] dialog::say( "kane_there_is_an_air_duct_0" );//There is an air duct leading to the Security station just past the breech.
}

function to_security_station_fleeing_civ()
{
	self ai::set_ignoreall( true ); // keep blinders on the fleeing civs so they don't stop and cower
}

//////////////////////////////////////////////////////////////////////////////
// HACK THE SYSTEM
/////////////////////////////////////////////////////////////////////////////

function hendricks_airduct()
{
	trigger::wait_till( "to_security_station_done" );//Wait for player to be inside room
	
	level scene::play( "cin_lot_04_09_security_vign_airduct01" );
	level scene::init( "cin_lot_04_09_security_vign_airduct02" );
	flag::wait_till( "hendricks_duct_two" );
	level scene::play( "cin_lot_04_09_security_vign_airduct02" );
	level scene::init( "cin_lot_04_09_security_vign_airduct03" );
	flag::wait_till( "hendricks_duct_three" );
	level scene::play( "cin_lot_04_09_security_vign_airduct03" );
}

function hack_the_system_vo()
{
	flag::wait_till( "hack_the_system_ready" );
	level.players[0] dialog::say( "kane_go_to_the_main_conso_0" );//Go to the main console and hack into the security system.
}

function unlock_weapon_locker()
{
	level notify ("turn_off_alarm");
	
	a_locker_doors = GetEntArray( "weapon_locker_door", "targetname" );
	foreach( door in a_locker_doors )
	{
		if( door.script_noteworthy == "locker_door_left" )
		{
			door thread open_left_locker();
		}
		else
		{
			door thread open_right_locker();
		}
	}
	
	level thread security_juiced_shotgun();
}

function open_left_locker()
{
	self RotateYaw( -90, 1 );
}

function open_right_locker()
{
	self RotateYaw( 90, 1 );
}

function security_juiced_shotgun()
{
	a_security_juiced_shotgun_triggers = GetEntArray( "security_juiced_shotgun_trigger", "script_noteworthy" );
	
	foreach ( t_juiced_shotgun in a_security_juiced_shotgun_triggers )
	{
		t_juiced_shotgun TriggerEnable( true );
		t_juiced_shotgun SetHintString( &"CP_MI_CAIRO_LOTUS_GRAB_SHOTGUN" );
	}
	
	lotus_util::juiced_shotgun_trigger_setup();
}

function juiced_shotgun_watcher()
{
	self endon( "death" );
	
	w_juiced_shotgun = GetWeapon( "shotgun_pump_taser" );
	
	while( true )
	{
		self waittill( "trigger", e_player );
		
		//check if they already have one	
		if ( e_player HasWeapon( w_juiced_shotgun ) )
		{
			e_player SwitchToWeapon( w_juiced_shotgun );
			continue;
		}
		else
		{
			e_player GiveWeapon( w_juiced_shotgun );
			e_player SwitchToWeapon( w_juiced_shotgun );
		}
	}
}

// self == enemy AI
function security_station_first_wave()
{
	self endon( "death" );
	
	// wait a few seconds before engaging the players who have just entered the security station
	self ai::set_ignoreall( true );
	wait 5;
	self ai::set_ignoreall( false );
}

//////////////////////////////////////////////////////////////////////////////
// PROMETHEUS OTR
/////////////////////////////////////////////////////////////////////////////

function security_station_breach()
{	
	e_breacher = GetEnt( "breach_leader", "script_noteworthy" );
	
	a_s_breach = struct::get_array( "breach_origin" );
	foreach( struct in a_s_breach )
	{
		e_breacher MagicGrenadeType( GetWeapon( "willy_pete_nd" ), struct.origin, ( 0, 0, 1 ), .05 );//HACK - temp effect
	}
	
	level thread scene::play( "p7_fxanim_cp_lotus_security_station_door_bundle" );
	
	level waittill( "fx_door_explode" );
	
	e_blocker = GetEnt( "reverse_breach_coll", "targetname" );
	e_blocker Delete();
	
	// toss grenades in through breach
	s_grenade = struct::get( "breach_grenade_origin" );
	a_s_targets = struct::get_array( "breach_target" );
	
	// first set of grenades (flash)
	foreach( struct in a_s_targets )
	{
		v_velocity = VectorNormalize( struct.origin - s_grenade.origin ) * 500;
		e_breacher MagicGrenadeType( GetWeapon( "flash_grenade" ), s_grenade.origin, v_velocity, .5 );
	}
	
	// next set of grenades (smoke)
	foreach( struct in a_s_targets )
	{
		v_velocity = VectorNormalize( struct.origin - s_grenade.origin ) * 500;
		e_breacher MagicGrenadeType( GetWeapon( "willy_pete_nd" ), s_grenade.origin, v_velocity, .5 );
	}	

	// stun/shellshock players
	s_epicenter = struct::get( "reverse_breach_epicenter", "targetname" );
	foreach( e_player in level.players )
	{	
		e_player PlayRumbleOnEntity( "damage_heavy" );
		Earthquake( 0.2, 0.05, e_player.origin, 120 );
		e_player ShellShock( "default", 2.5 );
	}
	
	spawn_manager::enable( "sm_security_station_breach" );
	spawn_manager::enable( "sm_security_station_breach_raps" );
}
function alarm_snd()
{
	sndEnt = spawn( "script_origin", ( -7833, 403, 4418 ));
	sndEnt playloopsound( "evt_security_alarm" );
	level waittill ("turn_off_alarm");
	sndEnt stoploopsound ( 1 ); 
	sndEnt delete ();
}
