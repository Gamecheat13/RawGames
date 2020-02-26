/*-----------------------------------------------------------------------------
pakistan_market.gsc

Events contained in this file:
- intro
- market
- car_smash
- market_exit
 ----------------------------------------------------------------------------*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\pakistan_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\pakistan.gsh;

/*----------------------------------------------------------------------------
Skipto section
----------------------------------------------------------------------------*/

skipto_intro() 
{
	skipto_teleport( "skipto_intro" );
	maps\pakistan_street::water_stops_create_cover( false );
}

skipto_market() 
{
	skipto_teleport( "skipto_market" );
	maps\pakistan_street::water_stops_create_cover( false );
	simple_spawn( "market_intro_spawners" );
}

skipto_market_dev_perk()
{
	level.player SetPerk( PERK_LOCK_BREAKER );
	skipto_market();
}

skipto_market_dev_no_perk()
{
	level.player UnsetPerk( PERK_LOCK_BREAKER );
	skipto_market();
}

skipto_car_smash()
{
	maps\pakistan_street::water_stops_create_cover( false );
	skipto_teleport( "skipto_car_smash", _get_friendly_array_market() );
	
	ai_claw_1 = init_hero( "claw_1" );

	if ( !IsDefined( ai_claw_1.ent_flag[ "ready_to_leave_market" ] ) )
	{
		ai_claw_1 ent_flag_init( "ready_to_leave_market" );
	}
	
	ai_claw_1 ent_flag_set( "ready_to_leave_market" );			
	
	ai_claw_1 ent_flag_set( "ready_to_leave_market" );
	
	market_vehicle_setup();
	market_fx_anim_setup();
}

skipto_market_exit()
{
	m_car = get_ent( "car_smash_car", "targetname", true );
	m_car Delete();
	
	m_bus = get_ent( "car_smash_bus", "targetname", true );
	m_bus Delete();	
	
	maps\pakistan_street::water_stops_create_cover( false );
	
	ai_claw_1 = init_hero( "claw_1" );
	
	if ( !IsDefined( ai_claw_1.ent_flag[ "ready_to_leave_market" ] ) )
	{
		ai_claw_1 ent_flag_init( "ready_to_leave_market" );
	}
	
	ai_claw_1 ent_flag_set( "ready_to_leave_market" );		
	
	maps\createart\pakistan_art::set_water_dvars_street();
	skipto_teleport( "skipto_market_exit", _get_friendly_array_market() );
	
	ai_salazar = get_ent( "salazar_ai", "targetname", true );
	if ( !ai_salazar ent_flag_exist( "playing_flooded_streets_idle" ) )
	{
		ai_salazar ent_flag_init( "playing_flooded_streets_idle" );
	}	
	
	level thread _flooded_streets_sequence_starts();
}

skipto_market_exit_perk()
{
	level.player SetPerk( PERK_BRUTE_FORCE );
	skipto_market_exit();
}

skipto_market_exit_no_perk()
{
	level.player UnsetPerk( PERK_BRUTE_FORCE );
	skipto_market_exit();
}

_get_friendly_array_market()
{
	a_friendlies = [];
	ARRAY_ADD( a_friendlies, init_hero( "harper" ) );
	ARRAY_ADD( a_friendlies, init_hero( "salazar" ) );
	ARRAY_ADD( a_friendlies, init_hero( "claw_1" ) );
	ARRAY_ADD( a_friendlies, init_hero( "claw_2" ) );
	
	return a_friendlies;
}

/*-----------------------------------------------------------------------------
Event functions
-----------------------------------------------------------------------------*/
intro()
{
	level.player screen_fade_to_alpha( 0.05, 1, "black" );  // immediately cut to black for single frame of image
	
	sp_freezer_guy_1 = get_ent( "claw_freezer_kill_guy_1", "targetname", true );
	sp_freezer_guy_1 add_spawn_function( ::ragdoll_me_when_scene_ends, "claw_freezer_kill" );

	sp_freezer_guy_2 = get_ent( "claw_freezer_kill_guy_2", "targetname", true );
	sp_freezer_guy_2 add_spawn_function( ::ragdoll_me_when_scene_ends, "claw_freezer_kill" );
	
	// make player invulnerable for intro cinematic
	level.player set_player_invulerability( true );
	
	level.player VisionSetNaked( "claw_base", 0 );
	//Set The global Futz for Static POV - CDC
	level clientnotify ("stfutz");
	
	level thread maps\pakistan_anim::vo_intro();
	maps\_scene::run_scene_first_frame( "intro_anim" );  // spawns/poses claws
	maps\_scene::run_scene_first_frame( "claw_freezer_kill" );
	level thread maps\_scene::run_scene( "intro_anim_loop" );
	
	ai_claw_1 = get_ent( "claw_1_ai", "targetname", true );
	ai_claw_1.turret maps\_turret::disable_turret();
	
	wait 0.5;
	level.player screen_fade_to_alpha( 0.1, 0, "black" );
	
	level thread _full_screen_static();
	level thread _intro_fake_gunshots();
		
	level waittill( "full_screen_static_done" );
	
	//set The global Futz to CLAW POV - CDC
	level clientnotify ("clawfutz");
	
	level thread maps\_scene::run_scene( "intro_anim" );
	level thread maps\_scene::run_scene( "claw_freezer_kill" );  // this scene runs at the same time as the intro, but runs longer, so it's separate
	
	maps\_scene::scene_wait( "intro_anim" );
	
	//set The global Futz to Default POV (SAFETY) The timed one is in the anim - CDC 
	level clientnotify ("nofutz");
			
	level.player thread set_player_invulerability( false, 1.5 );  // give player brief period of invulnerability as intro ends
	level.player SetStance( "crouch" );
}

set_player_invulerability( b_invulnerable, n_delay )
{
	Assert( IsPlayer( self ), "set_player_invulnerability can only be used on players!" );
	
	DEFAULT( n_delay, 0 );
	
	wait n_delay;
	
	if ( b_invulnerable )
	{
		self EnableInvulnerability();
	}
	else 
	{
		self DisableInvulnerability();
	}
}

#define CLAW_INTRO_FIRE_TIME 2
#define CLAW_SPIN_UP_TIME 0.25
#define CLAW_INTRO_FIRE_OFFSET ( 0, 0, 0 )
_intro_claw_turret_fire( ai_claw )
{
	s_fire_point_start = get_struct( "claw_intro_shoot_struct", "targetname", true );
	s_fire_point_end = get_struct( s_fire_point_start.target, "targetname", true );
	
	// spawn origin, move it to end point over X seconds
	e_temp = Spawn( "script_origin", s_fire_point_start.origin );
	ai_claw thread _intro_claw_fire_turret( e_temp, CLAW_INTRO_FIRE_TIME );
	e_temp MoveTo( s_fire_point_end.origin, CLAW_INTRO_FIRE_TIME );
	
	wait CLAW_SPIN_UP_TIME + CLAW_INTRO_FIRE_TIME;
	
	e_temp Delete();
}

// _turret::shoot_turret_at_target doesn't track ent as desired, so fire turret manually
_intro_claw_fire_turret( e_target, n_time_to_fire )  // self = claw
{
	str_turret = self.turret.weaponinfo;
	
	n_fire_time = WeaponFireTime( str_turret );
	
	self.turret SetTurretSpinning( true );
	
	wait CLAW_SPIN_UP_TIME;  // turret now 'spun up'
	
	n_shots = Int( n_time_to_fire / n_fire_time );
	
	for ( i = 0; i < n_shots; i++ )
	{
		self.turret SetTargetEntity( e_target );
		self.turret ShootTurret();
		wait n_fire_time;
	}
	
	self.turret SetTurretSpinning( false );  // turret will keep spinning if it's not turned off
	self.turret maps\_turret::enable_turret();	// enable it now that we're done with it
}

_intro_claw_turret_fire_stop( ai_claw )
{
	// 
}

// make a guy invulnerable until his anim is over, then kill and ragdoll him
ragdoll_me_when_scene_ends( str_scene )  // self = AI
{
	self endon( "death" );  // in case death notify gets in somehow
 
	self.takedamage = false;
	maps\_scene::scene_wait( str_scene );
	self.a.nodeath = true;  // prevent AI from standing up and playing death anim
	
	self.takedamage = true;
	self StartRagdoll();
	wait 0.1;
	self DoDamage( self.health + 100, self.origin );
}

_intro_fake_gunshots()
{
	level waittill( "intro_image_comes_in" );
	wait 0.5; // fade in time
	
	s_gunfire_1 = get_struct( "intro_fake_fire_struct_1", "targetname", true );
	s_gunfire_1 thread _loop_fake_fire( "insas_sp", 12, 3, 1 );
	
	s_gunfire_2 = get_struct( "intro_fake_fire_struct_2", "targetname", true );
	s_gunfire_2 thread _loop_fake_fire( "qbb95_sp", 12, 3, 0.5 );
	
	s_gunfire_3 = get_struct( "intro_fake_fire_struct_3", "targetname", true );
	s_gunfire_3 thread _loop_fake_fire( "tar21_sp", 14, 1.5, 0.25 );
	
	level waittill( "intro_return_from_black" );
	wait 0.5; // fade in time
	
	s_gunfire_1 thread _loop_fake_fire( "insas_sp", 15, 3, 1 );
	s_gunfire_2 thread _loop_fake_fire( "qbb95_sp", 12, 3, 0.5 );
	s_gunfire_3 thread _loop_fake_fire( "tar21_sp", 15, 1.5, 2 );
}

_loop_fake_fire( str_weapon, n_bursts_total, n_burst_time, n_burst_wait )
{
	level endon( "intro_cut_to_black" );
	level endon( "intro_anim_done" );
	
	s_target = get_struct( self.target, "targetname", true );
	
	n_fire_time = WeaponFireTime( str_weapon );
	n_shots_in_burst = Int( n_burst_time / n_fire_time );
	
	for ( n_bursts = 0; n_bursts < n_bursts_total; n_bursts++ )
	{
		for ( n_shots = 0; n_shots < n_shots_in_burst; n_shots++ )
		{
			MagicBullet( str_weapon, self.origin, s_target.origin );		
			wait n_fire_time;
		}
		
		wait n_burst_wait;
	}
}

//screen_fade_to_alpha( n_alpha, n_fade_time, n_blur, str_shader )
_full_screen_static()
{	
	const n_filter_id = 0;
	
	level.player hide_hud();
	level.player thread maps\_vehicle_death::vehicle_damage_filter();
	
	rpc( "clientscripts/_vehicle", "init_damage_filter", n_filter_id );
	rpc( "clientscripts/_vehicle", "damage_filter_heavy" );
	
	wait 1.5;
	
	// full screen static for a few seconds
	level.player playloopsound( "evt_intro_static");
	level clientnotify( "sfx_on" );	
	rpc( "clientscripts/_vehicle", "damage_filter_heavy" );
	wait 2;  // wait at full opacity right now
	
	level notify( "intro_image_comes_in" );
	
	// tune intensity of static a few times
	rpc( "clientscripts/_vehicle", "damage_filter_heavy" );
	wait 0.5;	
	
	rpc( "clientscripts/_vehicle", "damage_filter_light" );
	wait 0.5;	
	
	rpc( "clientscripts/_vehicle", "damage_filter_heavy" );
	wait 0.5;
	level clientnotify( "intro_cut_to_black" );
	level.player screen_fade_to_alpha( 1, 0.5, INTRO_STATIC_SHADER );
	
	// cut to black
	level.player screen_fade_out( 0.1 );  // defaults to black shader when second parameter undefined
	level.player stoploopsound( .1 );
	level clientnotify( "sfx_off" );
	
	wait 3;  // dramatic pause
	
	LUINotifyEvent( &"hud_update_vehicle_custom" );
	level notify( "intro_return_from_black" );
	rpc( "clientscripts/_vehicle", "damage_filter_heavy" );
	// less dense static; can hear combat/voices now
	level.player playloopsound( "evt_intro_static_2" );
	level clientnotify( "sfx_on" );
	level.player screen_fade_in( 1, INTRO_STATIC_SHADER );  // fade to full screen static again
	wait 0.5;
	rpc( "clientscripts/_vehicle", "damage_filter_light" );
	wait 0.5;
	level.player stoploopsound( .5 );
	level notify( "sfx_off" );
	
	// can see image clearly
	rpc( "clientscripts/_vehicle", "damage_filter_off" );
	level notify( "full_screen_static_done" );

	wait 3;  // hold clear image for a bit
	
	// cut to full static again for a few seconds
	level.player playsound( "evt_intro_static_3");
	wait 3;  // dramatic pause
	
	// "I got it!" -> everything's clear now
	level.player playsound( "evt_claw_success");
	
	// taps claw head, scales extra cam
	//level notify( "change_extra_cam_window_size" );
}

// intro extra cam is started by notetrack "persp_switch" from player body animation (set up in pakistan_anim.gsc)
#define CLAW_CAMERA_TAG "tag_eye"
_intro_extra_cam()
{
	level clientnotify ("nofutz"); //set The global Futz to Default POV - CDC 

	level.player screen_fade_in( 0.1, INTRO_STATIC_SHADER );  // static for perspective change coverup
	level.player show_hud();  // hud was turned off in _full_screen_static
	level.player notify( "end_damage_filter" ); // kill vehicle hud
	level.player VisionSetNaked( "sp_pakistan_default", 0 );
	delay_thread( 2.5, ::simple_spawn, "market_intro_spawners" );
	
	// wait a frame for scene to align correctly
	wait 0.05;  
	
	// set custom aspect ratio for extra cam
	SetSavedDvar( "r_extracam_custom_aspectratio", 16/9 );
	
	// spawn in claw_2 so it never pops into view during this anim
	ai_claw_2 = simple_spawn_single( "claw_2" );
	ai_claw_2 set_goalradius( 4 );  // match reach goal radius
	s_grenade_launch = get_struct( "pakistan_market", "targetname", true );
	n_claw_2_goal = GetStartOrigin( s_grenade_launch.origin, s_grenade_launch.angles, level.scr_anim[ "claw_2" ][ "claw_grenade_launch" ] );
	ai_claw_2 set_goal_pos( n_claw_2_goal );
	
	// turn on extra cam and get it in position
	ai_claw = get_ent( "claw_1_ai", "targetname", true );
	e_extra_cam = maps\_glasses::get_extracam();
	e_extra_cam.origin = ai_claw GetTagOrigin( CLAW_CAMERA_TAG );
	e_extra_cam.angles = ai_claw GetTagAngles( CLAW_CAMERA_TAG );
	e_extra_cam LinkTo( ai_claw, CLAW_CAMERA_TAG );

	// turn on extracam with pakistan specific fullscreen setting, and claw extracam material
	maps\_glasses::turn_on_extra_cam( undefined, &"pak_extracam_full" );
	LUINotifyEvent( &"hud_update_vehicle_custom" );
	
	// determine when to turn off extra cam
	wait 8;
	//level waittill( "turn_off_extra_cam" );
	
	// turn off extracam; has to reference claw material or it won't work
	maps\_glasses::turn_off_extra_cam( undefined );
}

claw_flamethrower_perk_setup()  // self = claw that can get flamethrower
{
	level endon( "remove_flamethrower_perk_option" );
	
	t_use = get_ent( "claw_flamethrower_perk_trigger", "targetname", true );
	t_use SetCursorHint( "HINT_NOICON" );
	t_use SetHintString( &"PAKISTAN_SHARED_PERK_GET_FLAMETHROWER" );
	
	if ( level.player HasPerk( PERK_LOCK_BREAKER ) )
	{
		t_use EnableLinkTo();  // allow link to claw
		t_use.origin = self GetTagOrigin( CLAW_FLAMETHROWER_TAG );
		t_use LinkTo( self, CLAW_FLAMETHROWER_TAG );
		wait 0.1;
		set_objective( level.OBJ_INTERACT_LOCK_BREAKER, self, "interact" );
		
		t_use waittill( "trigger" );
	    
		set_objective( level.OBJ_INTERACT_LOCK_BREAKER, undefined, "done" );
		flag_set( "lockbreaker_used" );
		self thread claw_give_flamethrower();
		level.player set_temp_stat( CLAW_HAS_FLAMETHROWER, 1 );
	}
	
	t_use Delete();
}

claw_remove_flamethrower_perk_option()
{
	level notify( "remove_flamethrower_perk_option" );  // kill watcher thread
	set_objective( level.OBJ_INTERACT_LOCK_BREAKER, undefined, "done" );  // remove 'INTERACT' icon on claw	
	
	// get rid of trigger on claw
	t_use = get_ent( "claw_flamethrower_perk_trigger", "targetname" );
	
	if ( IsDefined( t_use ) )
	{
		t_use Unlink();
		t_use Delete();
	}
}

claw_give_flamethrower()
{
	level.player set_player_invulerability( true );  // give player temp invulnerability during anim
	level thread maps\_scene::run_scene( "unlock_flamethrower" );
	attach_data_glove_texture( "unlock_flamethrower" );
	maps\_scene::scene_wait( "unlock_flamethrower" );
	level.player set_player_invulerability( false, 1 ); 

	// create new turret and put it on claw
	v_position = self.origin;
	v_angles = self.angles;
	
	self.turret_flamethrower = maps\_turret::create_turret( v_position, v_angles, self.team, CLAW_FLAMETHROWER_WEAPON, CLAW_FLAMETHROWER_MODEL, (0,0,50) );
	self.turret_flamethrower maps\_turret::set_turret_burst_parameters( 0.1, 0.15, .3, .4 );
	self.turret_flamethrower MakeTurretUnusable();		
	self.turret_flamethrower Linkto( self, "tag_turret" );
	self.turret_flamethrower.accuracy = 0.4;
}

attach_data_glove_texture( str_scene )
{
	m_player_body = get_model_or_models_from_scene( str_scene, "player_body" );
	m_player_body Attach( DATA_GLOVE_TEXTURE, "J_WristTwist_LE" );	
}

market()
{
	market_ai_setup(); 
	level thread market_fx_anim_setup();
	level thread market_vehicle_setup();
	autosave_by_name( "pakistan_market" );
	
	// turn on claw fire direction feature
	enable_claw_fire_direction_feature();
	
	delay_thread( 5, maps\pakistan_anim::vo_market );
	
	// give claw flamethrower
	ai_claw_1 = get_ent( "claw_1_ai", "targetname", true );
	ai_claw_1 thread claw_flamethrower_perk_setup();
	
	add_trigger_function( "claw_grenade_launch_trigger", ::_claw_grenade_launch_internal );
	
	level thread _market_clear_logic();
	trigger_wait( "market_spawner_last" );
	spawn_manager_disable( "market_spawn_manager" );
}

// this function is used to get vehicles (car smash car, bus smash bus, car corner smash car) in position
// to NOT break pathing compilation, so they're kept under the map. position is only important pre-animations
market_vehicle_setup()
{
	const n_offset_z = 200;
	a_vehicles = get_ent_array( "market_vehicles", "script_noteworthy", true );
	foreach( vehicle in a_vehicles )
	{
		vehicle MoveZ( n_offset_z, 0.05 );
		vehicle waittill( "movedone" );
		vehicle.market_vehicle_in_place = true;
	}
}

market_fx_anim_setup()
{
	level thread bus_smash_wall_collision_think();
	
	// ceiling fall near market entrace
	level thread play_fx_anim_on_trigger( "market_ceiling_1_damage_trigger", "fxanim_market_ceiling_01_start" );	
	
	// ceiling fall near market exit
	level thread play_fx_anim_on_trigger( "market_ceiling_2_damage_trigger", "fxanim_market_ceiling_02_start" );
	
	// car corner crash at market exit; make sure it's in the right place first before looping, as it's unaligned (per fxanim guys)
	m_car_corner_vehicle = get_ent( "car_corner_crash_vehicle", "targetname", true );
	while ( !IsDefined( m_car_corner_vehicle.market_vehicle_in_place ) )
	{
		wait 0.05;
	}
	level thread maps\_scene::run_scene( "car_corner_crash_loop" );  // start loop before crash starts
	level thread play_fx_anim_on_trigger( "market_exit_car_corner_crash_trigger", "fxanim_car_corner_crash_start", ::car_corner_smash );
}

bus_smash_wall_collision_think()
{
	m_wall_pristine = get_ent( "market_wall_pristine", "targetname", true );
	m_wall_destroyed = get_ent( "market_wall_destroyed", "targetname", true );
	
	const n_offset = 1000;
	const n_move_time = 0.05;
	m_wall_destroyed MoveZ( -n_offset, n_move_time );
	
	flag_wait( "bus_smash_collateral_damage_started" );
	m_wall_pristine Delete();
	m_wall_destroyed MoveZ( n_offset, n_move_time );
}

car_corner_smash()
{
	debug_print_line( "playing car_corner_crash" );
	maps\_scene::run_scene( "car_corner_crash" );
}

market_ai_setup()
{
	add_spawn_function_ai_group( "market_spawners", ::lower_attacker_accuracy );
	
	// enemy AI
	e_market_volume = get_ent( "market_volume", "targetname", true );
	e_fallback_volume = get_ent( "market_fallback_volume", "targetname", true );
	a_fallback_nodes = GetNodeArray( "market_fallback_nodes", "script_noteworthy" );
	add_spawn_function_group( "market_sm_spawners", "targetname", ::market_sm_func, e_market_volume, e_fallback_volume, a_fallback_nodes );
	spawn_manager_enable( "market_spawn_manager" );
	
	// friendly AI
	// move AI to initial positions after intro scene finishes
	level.ai_harper = init_hero( "harper" );
	level.ai_harper set_goalradius( 64 );
	level.ai_harper change_movemode( "cqb_sprint" );	

	n_harper_goal = GetNode( "cover_exit_intro_room_left", "targetname" );
	level.ai_harper set_goal_node( n_harper_goal );
	
	ai_salazar = init_hero( "salazar" );
	ai_salazar set_goalradius( 64 );
	ai_salazar change_movemode( "cqb_sprint" );
	n_salazar_goal = GetNode( "cover_exit_intro_room_straight", "targetname" );
	ai_salazar set_goal_node( n_salazar_goal );
	
	ai_claw_1 = init_hero( "claw_1", ::claw_1_market_movement );
	ai_claw_2 = init_hero( "claw_2", ::claw_2_market_movement );
	
	ai_claw_1 thread claw_stop_close_rusher();
	ai_claw_2 thread claw_stop_close_rusher();
}

// this function exists to make the claws not be so deadly against normal AI
lower_attacker_accuracy()  // self = AI
{
	self endon( "death" );
	
	const n_accuracy = 0.2;
	
	self.attackerAccuracy = n_accuracy;
}

claw_stop_close_rusher()  // self = claw
{
	const TRIGGER_SPAWNFLAGS = 9;  // trigger by AI_AXIS and NOTPLAYER
	const n_radius = 128;
	const n_height = 64;
	t_radius = Spawn( "trigger_radius", self.origin, TRIGGER_SPAWNFLAGS, n_radius, n_height );
	t_radius EnableLinkTo();
	t_radius LinkTo( self );
	
	while ( is_alive( self ) )
	{
		t_radius waittill( "trigger", e_triggered );
		
		b_is_rusher = IS_TRUE( e_triggered.rusher );
		
		if ( b_is_rusher )
		{
			e_triggered notify( "too_close_to_claw" );  // endon for rusher behavior (set in rush() call)
		}
	}
	
	t_radius Delete();
}

market_sm_func( e_market_volume, e_fallback_volume, a_fallback_nodes )
{
	self endon( "death" );
	
	const n_radius = 650;
	
	a_cover_nodes = GetCoverNodeArray( self.origin, n_radius );
	
	DEFAULT( level.rusher_time_last, 0 );
	
	b_found_node = false;
	
	while ( !b_found_node )
	{
		nd_goal = random( a_cover_nodes );
		
		// if goal is available and inside the market, go to it!
		b_found_node = ( !IsNodeOccupied( nd_goal ) && is_point_inside_volume( nd_goal.origin, e_market_volume ) );
		
		wait 0.05;
	}
	
	self set_goalradius( n_radius );
	self set_goal_node( nd_goal );
	
	if ( !flag( "market_fallback_start" ) )
	{
		self waittill( "goal" );
		self _market_sm_func_rusher();
	}
	self _market_sm_func_fallback( e_fallback_volume, a_fallback_nodes );
}

_market_sm_func_rusher()  // self = AI
{
	const n_rush_group_distance = 150;  // when close to another spawn manager guy within this distance, AI should rush
	const n_rush_far_distance = 1024;  // when at goal but this far from player, AI should rush
	const n_far_rush_chance = 20;  // percent
	const n_rush_time_max = 10;	
	
	// TODO: base this on difficulty
	n_rusher_cooldown_ms = 4000;  // ms
	
	b_rushing = false;
	
	while ( IsAlive( self ) && !b_rushing && !flag( "market_fallback_start" ) )
	{
		a_sm_guys = get_ent_array( "market_sm_spawners", "targetname" );
		a_close = get_within_range( self.origin, a_sm_guys, n_rush_group_distance );
		n_distance_to_player = Distance( self.origin, level.player.origin );
		
		n_time = GetTime();
		
		b_should_rush_from_group =  ( a_close.size > 2 );
		b_should_rush_from_distance = ( ( n_distance_to_player > n_rush_far_distance ) && ( RandomInt( 100 ) < n_far_rush_chance ) );
		b_rusher_cooldown_up = ( ( GetTime() - level.rusher_time_last ) > n_rusher_cooldown_ms );
		
		if ( b_rusher_cooldown_up && ( b_should_rush_from_group || b_should_rush_from_distance ) )
		{
			debug_print_line( "rusher activated" );
			self maps\_rusher::rush( "too_close_to_claw", n_rush_time_max );
			b_rushing = true;
		}
		
		wait RandomFloatRange( 5, 10 );
	}	
}

_market_sm_func_fallback( e_fallback_volume, a_fallback_nodes )  // self = AI
{
	const n_dot = 0.8;
	const n_distance_to_fallback = 600; // fallback if closer than this
	n_distance_to_fallback_sq = n_distance_to_fallback * n_distance_to_fallback;
	b_do_trace = true;
	
	b_found_fallback_node = false;
	while ( !b_found_fallback_node )
	{
		wait RandomFloatRange( 0.5, 5.0 ); // give a bit of time to 'react' to situation
		
		// wait for player to get sufficiently close to AI before he falls back
		while ( DistanceSquared( self.origin, level.player.origin ) > n_distance_to_fallback_sq )
		{
			wait 1;
		}
		
		// make sure he can see AI
	//	level.player waittill_player_looking_at( self.origin, n_dot, b_do_trace );
		
		// is guy in fallback volume?
		b_is_goal_inside_fallback_volume = ( is_point_inside_volume( self.goalpos, e_fallback_volume ) );
		
		// if not in fallback volume, find him an open node
		if ( !b_is_goal_inside_fallback_volume )
		{
			// once node is found, send him there
			b_found_node = false;
			nd_goal = undefined;
			a_fallback_nodes = array_randomize( a_fallback_nodes );
			for ( i = 0; i < a_fallback_nodes.size; i++ )
			{
				if ( !IsNodeOccupied( a_fallback_nodes[ i ] ) )
				{
					b_found_node = true;
					nd_goal = a_fallback_nodes[ i ];
				}
				
				wait 0.05;
			}	
	
			// if goal is available and inside the market, go to it!
			if ( IsDefined( nd_goal ) )
			{
				debug_print_line( "fallback activated" );
				b_found_fallback_node = true;
				self set_goal_node( nd_goal );
				self SetGoalVolume( e_fallback_volume );
			}
		}
	}
}

claw_1_init()
{
	sp_claw_1 = get_ent( "claw_1", "targetname", true );
	ai_claw_1 = get_ent( "claw_1_ai", "targetname" );
	
	if ( IsDefined( ai_claw_1 ) && !IsDefined( ai_claw_1.ent_flag[ "ready_to_leave_market" ] ) )
	{
		ai_claw_1 thread ent_flag_init( "ready_to_leave_market" );
	}
	else 
	{	
		sp_claw_1 add_spawn_function( ::ent_flag_init, "ready_to_leave_market" );
	}	
}

claw_1_market_movement()  // self = claw_1
{	
	self set_goalradius( 16 );
	n_claw_1_goal_initial = GetNode( "cover_exit_intro_room_right_claw", "targetname" );	
	n_claw_1_goal_2 = GetNode( "claw_1_moveup_market_mid", "targetname" );
	n_claw_1_goal_3 = GetNode( "claw_1_moveup_market_far", "targetname" );
	n_claw_1_goal_4 = GetNode( "claw_1_moveup_market_exit", "targetname" );
	
	self force_goal( n_claw_1_goal_initial );
	self waittill( "goal" );
	
	flag_wait( "claw_market_moveup_2" );
	
	self force_goal( n_claw_1_goal_2 );
	self waittill( "goal" );
	
	flag_wait( "claw_market_moveup_3" );
	
	self force_goal( n_claw_1_goal_3 );
	self waittill( "goal" );
	
	self force_goal( n_claw_1_goal_4 );
	
	if ( IsDefined( self ) )
	{
		self ent_flag_set( "ready_to_leave_market" );	
	}
}

claw_2_market_movement()
{
	level endon( "flooded_streets_started" );
	
	self.goalradius = 16;
	self.my_color = self get_force_color();
	self clear_force_color();  // temporarily disable color for grenade launch scene	
		
	flag_wait( "claw_grenade_launch_done" );
	
	self set_force_color( self.my_color );
}

enable_claw_fire_direction_feature()
{
	level.player maps\_fire_direction::init_fire_direction();
	level.player maps\_fire_direction::add_fire_direction_func( ::claw_fire_direction_func );
	
	ai_claw_1 = get_ent( "claw_1_ai", "targetname", true );
	maps\_fire_direction::add_fire_direction_shooter( ai_claw_1 );
	
	ai_claw_2 = get_ent( "claw_2_ai", "targetname", true );
	maps\_fire_direction::add_fire_direction_shooter( ai_claw_2 );
	
	maps\pakistan_anim::claw_nag_vo_setup();
}

claw_fire_direction_func()
{
	// get firing point
	v_origin = self GetEye();
	v_angles = AnglesToForward( self GetPlayerAngles() );
	v_aim_pos = v_origin + ( v_angles * 8000 );
	
	a_trace = BulletTrace( v_origin, v_aim_pos, false, self );
	v_shoot_pos = a_trace[ "position" ];
	
	// get valid shooters for fire direction use
	a_shooters = _get_valid_shooters( v_shoot_pos );
	
	// fire grenades
	if ( a_shooters.size > 0 )
	{
		array_thread( a_shooters, ::_claw_fire_direction_grenades, v_shoot_pos );
	}
}


#define CLAW_GRENADE_WEAPON "claw_grenade_impact_explode_sp"
#define CLAW_GRENADE_TAG "tag_turret"
#define CLAW_GRENADE_SPEED_SCALE 2000
_claw_fire_direction_grenades( v_position )  // self = claw
{
	self endon( "death" );
	
	const n_volleys = 5;
	
	e_temp = Spawn( "script_origin", v_position );
	
	// start guns here
	self thread _claw_fire_guns_at_targets_in_range( v_position );
	
	for ( i = 0; i < n_volleys; i++ )
	{
		v_start_pos = self GetTagOrigin( CLAW_GRENADE_TAG );
		b_can_fire_safely = self _can_hit_target_safely( v_position, v_start_pos );
		
		if ( b_can_fire_safely )
		{
			v_grenade_velocity = VectorNormalize( v_position - v_start_pos ) * CLAW_GRENADE_SPEED_SCALE;
			self MagicGrenadeType( CLAW_GRENADE_WEAPON, v_start_pos, v_grenade_velocity );
		}
		
		wait 0.5;		
	}
	
	// end fire guns
	self.turret maps\_turret::clear_turret_target();
	
	e_temp Delete();
}

_claw_fire_guns_at_targets_in_range( v_position )
{	
	const n_targeting_range = 256;
	a_enemies = GetAIArray( "axis" );
	a_guys_within_range = get_within_range( v_position, a_enemies, n_targeting_range );
	
	n_time = GetTime();
	
	if ( a_guys_within_range.size == 0 )
	{
		e_temp = Spawn( "script_origin", v_position );
		self.turret maps\_turret::shoot_turret_at_target( e_temp, 5, ( 0, 0, 0 ) );
		e_temp Delete();
	}
	else
	{
		n_enemies_max = 3;
		n_cycles = 0;
		
		b_should_fire = true;
		
		while ( b_should_fire )
		{
			ai_enemy = random( a_enemies );
			self.turret thread maps\_turret::shoot_turret_at_target( ai_enemy, 2, ( 0, 0, 0 ) );
			ai_enemies = array_removeDead( a_enemies );
			n_cycles++;
			b_should_fire = ( a_enemies.size > 0 ) && ( n_cycles < n_enemies_max );
		}
	}
}

_get_valid_shooters( v_position )
{
	a_shooters = level._fire_direction.a_shooters;
	return a_shooters;
}

// TODO: add logic to check launch path for friendlies, not just impact point
_can_hit_target_safely( v_position, v_start_pos )
{
	Assert( IsDefined( v_position ), "v_position missing for _get_closest_unit_to_fire" );
	Assert( IsDefined( level._fire_direction.a_shooters.size > 0 ), "no valid shooters found to use in _get_closest_unit_to_fire. Add these with add_fire_direction_shooter( <ent_that_can_shoot> ) first." );
	
	const n_dot_max = 0.9;
	const n_grenade_impact_radius = 256;
	
	// will grenade hit anybody on our side?
	a_trace = BulletTrace( v_start_pos, v_position, false, self );
	b_can_hit_target = true;
	b_will_hit_player = ( Distance( a_trace[ "position" ], level.player.origin ) < n_grenade_impact_radius );
	b_will_hit_self = ( Distance( a_trace[ "position" ], v_start_pos ) < n_grenade_impact_radius );
	
	b_will_hit_friendly = false;
	
	a_friendlies = GetAIArray( "allies" );
	
	for ( j = 0; j < a_friendlies.size; j++ )
	{
		b_could_hit_friendly = ( Distance( a_trace[ "position" ], a_friendlies[ j ].origin ) < n_grenade_impact_radius );
		
		if ( b_could_hit_friendly )
		{
			b_will_hit_friendly = true;
		}
	}
	
	// is player in the way?
	v_to_player = VectorNormalize( level.player.origin - v_start_pos );
	v_to_target = VectorNormalize( v_position - v_start_pos );
	n_dot = VectorDot( v_to_player, v_to_target );
	b_player_in_grenade_path = ( n_dot > n_dot_max );
				
	b_should_fire_grenades = ( b_can_hit_target && !b_will_hit_player && !b_will_hit_self && !b_will_hit_friendly && !b_player_in_grenade_path );
	
	return b_should_fire_grenades;
}

_get_closest_unit_to_fire( v_position )
{
	Assert( IsDefined( v_position ), "v_position missing for _get_closest_unit_to_fire" );
	Assert( IsDefined( level._fire_direction.a_shooters.size > 0 ), "no valid shooters found to use in _get_closest_unit_to_fire. Add these with add_fire_direction_shooter( <ent_that_can_shoot> ) first." );
	
	e_closest_shooter = GetClosest( v_position, level._fire_direction.a_shooters );
	
	return e_closest_shooter;
}

_claw_grenade_launch_internal()
{	
	sp_grenade_guy = get_ent( "claw_grenade_guy", "targetname", true );
	sp_grenade_guy add_spawn_function( ::claw_grenade_launch_hack );
	
	ai_claw_2 = get_ent( "claw_2_ai", "targetname", true );
	ai_claw_2 endon( "death" );
		
	level thread run_scene( "claw_grenade_launch" );
	
	wait 0.1;  // wait until guy exists - _scene will spawn him in
	
	// force claw turret to aim at grenade launch guy
	ai_target = get_ent( "claw_grenade_guy_ai", "targetname", true );
	ai_claw_2 SetEntityTarget( ai_target );
	
	scene_wait( "claw_grenade_launch" );
	
	// restore claw ai parameters once scene is done
	ai_claw_2 ClearEntityTarget();
}

claw_grenade_launch_hack()
{
	wait 0.2;
	self set_goalradius( 8 );
}

_claw_launches_grenade_at_guy( ai_claw )
{
	//ai_claw animscripts\bigdog\bigdog_utility::fire_grenade_at_target( ai_target );  // how to fire a real grenade
	
	// figure out where grenade is being launched. Not using real grenade since AI firing will happen after aim is done (1/10/2012)
	ai_target = get_ent( "claw_grenade_guy_ai", "targetname", true );
	v_start_pos = ai_claw GetTagOrigin( CLAW_GRENADE_TAG );
	v_end_pos = ai_target.origin + ( 0, 0, 20 );  // aim at water level. this is a static scene, so using fixed offset
	v_grenade_velocity = VectorNormalize( v_end_pos - v_start_pos ) * CLAW_GRENADE_SPEED_SCALE;
	
	ai_claw MagicGrenadeType( CLAW_GRENADE_WEAPON, v_start_pos, v_grenade_velocity );
}

car_smash()
{
	// set up AI to die after bus smash before they spawn in
	sp_car_smash_guy1 = get_ent( "car_smash_guy_1", "targetname", true );
	sp_car_smash_guy1 add_spawn_function( ::ragdoll_me_when_scene_ends, "bus_smash" );
	
	sp_car_smash_guy2 = get_ent( "car_smash_guy_2", "targetname", true );
	sp_car_smash_guy2 add_spawn_function( ::ragdoll_me_when_scene_ends, "bus_smash" );
	
	t_car_smash = get_ent( "car_smash_trigger", "targetname", true );
	t_bus_smash = get_ent( "bus_smash_trigger", "targetname", true );
	t_car_smash_lookat = get_ent( "car_smash_lookat_trigger", "targetname", true );
	
	// wait for player to get in postion for car smash
	//flag_init( "car_smash_in_view" );
	//add_trigger_function( t_car_smash_lookat, ::flag_set, "car_smash_in_view" );
	t_car_smash waittill( "trigger" );
	level thread _flooded_streets_sequence_starts();
	//level thread _change_claw_moveplaybackrate( 1.5 );
	level thread water_surge_street();
	level thread _car_smash_internal();
	
	// wait for player to get in position for bus smash
	t_bus_smash waittill( "trigger" );
	level thread _bus_smash_internal();
}

_flooded_streets_sequence_starts()
{
	maps\_scene::run_scene( "flooded_streets_salazar_arrive" );
	maps\_scene::run_scene( "flooded_streets_salazar_loop" );
}

_market_clear_logic()
{
	waittill_spawn_manager_cleared( "market_spawn_manager" );
	debug_print_line( "SM cleared: market_spawn_manager" );
	maps\_fire_direction::_fire_direction_remove_hint();
	maps\pakistan_anim::vo_market_done();
}

water_surge_street()
{
	maps\createart\pakistan_art::set_water_dvars_street();
	ClientNotify( "frogger_water_surge" );
	level thread maps\pakistan_street::frogger_debris_start();
	delay_thread( 2, maps\pakistan_street::frogger_start_spawning_dyn_ents );
	delay_thread( 2, maps\pakistan_street::raise_water_level );
}


_car_smash_internal()
{
	level endon( "bus_smash_collateral_damage_started" ); 
	
	//iprintlnbold( "car_smash trigger hit" );	
	const n_time_to_impact_car = 3;	
	m_car = get_ent( "car_smash_car", "targetname", true );
	t_kill_car = get_ent( "car_kill_trigger", "targetname", true );
	t_kill_car thread trigger_kill_ai_on_contact( "car_smash_done", m_car );

	level thread maps\pakistan_anim::vo_car_smash();
	level thread maps\_scene::run_scene( "car_smash_guys" );
	maps\_scene::run_scene( "car_smash" );
	level thread maps\_scene::run_scene( "car_smash_dead_pose_not_guy1" );
	maps\_scene::run_scene( "car_smash_pain_guy1" );
	waittillframeend;  // HACK: wait here to get SetCanDamage toggled appropriately from _scene::_delete_ais clearing then re-running a scene on a single AI
	maps\_scene::run_scene( "car_smash_death_guy1" );
	maps\_scene::run_scene( "car_smash_dead_pose_guy1" );
}

_bus_smash_internal()
{
	//iprintlnbold( "bus_smash trigger hit" );
	const n_time_to_impact_bus = 3;
	m_bus = get_ent( "car_smash_bus", "targetname", true );
	t_kill_bus = get_ent( "bus_kill_trigger", "targetname", true );
	t_kill_bus thread trigger_kill_ai_on_contact( "bus_smash_done", m_bus );
	m_bus thread bus_crash_audio();
	
	level thread maps\pakistan_anim::vo_bus_smash();
	level thread maps\_scene::run_scene( "bus_smash" );
}

bus_crash_audio()
{
	wait (1);
	self Playsound("fxa_bus_rumble_lfe");
	wait (1.3);
	self PlaySound("fxa_bus_crash_main");
	wait (.9);
	self playsound("fxa_bus_crash_pre");
	wait (6);
	clientnotify ("bus_hit");
}


// trigger will kill anything that touches it until endon stops it
trigger_kill_ai_on_contact( str_endon, e_linkto )  // self = trigger
{
	Assert( IsDefined( str_endon ), "str_endon is a required argument for trigger_kill_on_contact" );
	
	level endon( str_endon );
	
	b_use_linkto = false;
	
	if ( IsDefined( e_linkto ) )
	{
		b_use_linkto = true;
	}
	
	if ( b_use_linkto )
	{
		self EnableLinkTo();
		self LinkTo( e_linkto);
	}
	
	while ( true )
	{
		self waittill( "trigger", e_triggered );
		
		if ( IsDefined( e_triggered.ignoreme ) && e_triggered.ignoreme )
		{
			continue;
		}
		
		e_triggered DoDamage( e_triggered.health + 100, self.origin );
	}
}

market_exit()
{
	claw_toggle_firing( false );
	level thread _market_exit_internal();  // thread this so frogger event isn't held up
}

_market_exit_internal()
{
	claw_remove_flamethrower_perk_option();
	level thread _brute_force_setup();
	
	ai_salazar = get_ent( "salazar_ai", "targetname" );
	ai_salazar ent_flag_wait( "playing_flooded_streets_idle" );
	level thread maps\pakistan_anim::vo_market_exit();
	maps\_scene::run_scene( "flooded_streets" );
	trigger_use( "frogger_colors_initial_positions_trigger", "targetname", level.player );	
	flag_set( "frogger_combat_started" );
	flag_set( "market_done" );
}

claw_toggle_firing( b_should_fire = false )
{
	ai_claw_1 = get_ent( "claw_1_ai", "targetname", true );
	ai_claw_2 = get_ent( "claw_2_ai", "targetname", true );
	
	ai_claw_1 set_ignoreall( !b_should_fire );
	ai_claw_2 set_ignoreall( !b_should_fire );
	
	ai_claw_1 set_ignoreme( !b_should_fire );
	ai_claw_1 set_ignoreme( !b_should_fire );
	
	if ( b_should_fire )
	{
		ai_claw_1.turret maps\_turret::pause_turret( 0 );
		ai_claw_2.turret maps\_turret::pause_turret( 0 );
		
		if ( IsDefined( ai_claw_1.turret_flamethrower ) )
		{
			ai_claw_1.turret_flamethrower maps\_turret::pause_turret( 0 );
		}			
	}
	else 
	{
		ai_claw_1.turret maps\_turret::unpause_turret( 0 );
		ai_claw_2.turret maps\_turret::unpause_turret( 0 );
		
		if ( IsDefined( ai_claw_1.turret_flamethrower ) )
		{
			ai_claw_1.turret_flamethrower maps\_turret::unpause_turret( 0 );
		}			
	}
	

}

_change_claw_moveplaybackrate( n_speed_multiplier )
{
	ai_claw_1 = get_ent( "claw_1_ai", "targetname", true );
	ai_claw_2 = get_ent( "claw_2_ai", "targetname", true );
	
	ai_claw_1.moveplaybackrate = n_speed_multiplier;
	ai_claw_2.moveplaybackrate = n_speed_multiplier;
}

_brute_force_setup()
{
	flag_wait( "market_done" );
	
	t_perk = get_ent( "brute_force_perk_trigger", "targetname", true );
	t_perk SetCursorHint( "HINT_NOICON" );
	t_perk SetHintString( &"PAKISTAN_SHARED_PERK_CLAW_SUPPORT" );	
	
	t_perk thread _brute_force_anim_sequence();
	
	b_player_has_perk = level.player HasPerk( PERK_BRUTE_FORCE );
	
	if ( b_player_has_perk )
	{
		debug_print_line( "player has brute force" );
		level thread maps\pakistan_anim::vo_brute_force_usable();
		t_perk _wait_until_player_uses_brute_force_perk_or_leaves_area();
	}
	else
	{
		debug_print_line( "player does NOT have brute force perk" );
	}
	
	if ( IsDefined( t_perk ) ) 
	{
		t_perk Delete();
	}
}

_wait_until_player_uses_brute_force_perk_or_leaves_area()
{
	level endon( "brute_force_kill" );
	
	set_objective( level.OBJ_INTERACT_BRUTE_FORCE, self, "interact" );
	
	self waittill( "trigger" );
    
	set_objective( level.OBJ_INTERACT_BRUTE_FORCE, undefined, "done" );
	
	flag_set( "brute_force_logic_done" );
	
	end_scene( "brute_force_idle" );
	level thread maps\pakistan_anim::vo_brute_force_used();
	flag_set( "brute_force_perk_used" );
	level thread run_scene( "brute_force_unlock_player" );
	run_scene( "brute_force_unlock" );
}

_brute_force_anim_sequence()
{
	level endon( "brute_force_unlock_started" );
	
	run_scene( "brute_force_arrive" );
	level thread run_scene( "brute_force_idle" );

	if ( !level.player HasPerk( PERK_BRUTE_FORCE ) )
	{
		level thread delay_thread( 4, ::flag_set, "brute_force_logic_done" );
	}
	
	flag_wait( "brute_force_logic_done" );  // this will be set when either the player leaves the area OR uses the perk OR doesn't have the perk at all
		
	wait 0.1;  // avoid race
	
	if ( !flag( "frogger_perk_active" ) )
	{
		// kill off trigger and its objective
		set_objective( level.OBJ_INTERACT_BRUTE_FORCE, undefined, "done" );
		level notify( "brute_force_kill" );
		
		if ( IsDefined( self ) )
		{
			self Delete();
		}
		
		debug_print_line( "brute_force_exit" );
		end_scene( "brute_force_idle" );
		run_scene( "brute_force_exit" );
	}
	
	if ( maps\_fire_direction::is_fire_direction_active() )
	{
		level.player maps\_fire_direction::_fire_direction_kill();  // if we're here, no claw support for the player
	}
	
	debug_print_line( "street_exit" );
	level thread maps\pakistan_anim::vo_brute_force_not_used();
	claw_toggle_firing( false );
	run_scene( "street_exit" );
	level notify( "frogger_perk_not_used" );
}