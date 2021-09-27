#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\prague_code;
#include maps\_util_carlos;
#include maps\_util_carlos_stealth;
#include maps\prague_courtyard_script_code;


main()
{
	flag_init( "church_shoot_through_door" );
	flag_init( "church_end_anim_talk" );
	flag_init( "church_player_in_main_hall" );
	flag_init( "on_scaffold" );
	flag_init( "off_scaffold" );
	flag_init( "player_rushed_ending" );
	flag_init( "church_sandman_checks_body" );
	flag_init( "soap_jump_back" );
	flag_init( "church_ambient_chopper_large" );
	flag_init( "pause_shakes_while_in_combat" );
	flag_init( "restart_shakes" );
	flag_init( "church_drop_hint" );
	flag_init( "shoot_at_player_and_soap_now" );
	flag_init( "flag_before_run_in_for_autosave" );
	flag_init( "ai_run_into_the_church_from_outside" );
	flag_init( "on_scaffold_endiing" );
	
	new_ending = GetDvarInt( "new_ending", 0 );
	
	
	array_thread( getentarray( "church_epic_spawner_trigger", "targetname" ), ::idle_spawner_trigger );
//	array_thread( getentarray( "extreme_church_epic_spawner_trigger", "targetname" ), ::idle_spawner_trigger );
	
	
	//array_thread( getentarray( "dead_body_spawner_trigger_ludes", "targetname" ), ::dead_body_spawner_trigger_ludes_think );
	//array_thread( getentarray( "dead_body_spawner_trigger", "targetname" ), ::dead_body_spawner_trigger_think );
	array_spawn_function_targetname( "church_flee_nondrone", ::church_flee_think );
	array_spawn_function_targetname( "church_flee_drone", ::church_flee_drone_think );
	array_spawn_function_targetname( "church_btr", ::church_btr_think );
	array_spawn_function_targetname( "church_patrols", ::church_patrols_think );
	array_spawn_function_targetname( "church_combat_one", ::church_combat_think );
	array_spawn_function_targetname( "church_combat_one", ::enemy_dead_add );
	array_spawn_function_targetname( "church_combat_two", ::church_combat_think );
	array_spawn_function_targetname( "church_combat_two", ::enemy_dead_add );
	array_spawn_function_targetname( "church_combat_three", ::church_combat_think_three );
	array_spawn_function_targetname( "church_combat_three", ::enemy_dead_add );
	array_spawn_function_targetname( "civs_that_hold_door", ::guys_who_run_in );
	array_spawn_function_targetname( "back_up_vehicle", ::church_vehciles_follow_through );
	array_spawn_function_targetname( "pre_church_flee_drone", ::church_flee_drone_think );
	array_spawn_function_targetname( "runner_one", ::top_runners_think );
	array_spawn_function_targetname( "runner_two", ::top_runners_think );
	array_spawn_function_targetname( "runner_three", ::top_runners_think );
	array_spawn_function_targetname( "runner_four", ::top_runners_think );
	array_spawn_function_targetname( "runner_five", ::top_runners_think );
	array_spawn_function_targetname( "jeer", ::jeer_think );
	
	
	
//	array_spawn_function_targetname( "church_drone_guns", ::church_drone_guns_think );
	
	precacherumble( "light_1s" );
	precacherumble( "light_2s" );
	precacherumble( "light_3s" );
	
	precachemodel( "weapon_binocular" );
}

start_church()
{
	spawn_sandman();
	level.player vision_set_fog_changes( "prague_redbuilding", 1 );
	set_start_positions( "start_church" );
	flag_set( "start_sewers" );
	flag_set( "player_out_of_water" );
	flag_set( "start_alcove" );
	flag_set( "start_alley" );
	flag_set( "start_long_convoy" );
	flag_set( "start_courtyard" );
	flag_set( "pre_courtyard_ally_clean_up" );
	flag_set( "start_apartments" );
	flag_set( "start_apartment_fight" );
	flag_set( "start_apartment_exit" );
	flag_set( "start_gallery" );
	flag_set( "gallery_exit" );
	
	
//	thread maps\_nightvision::nightvision_on();
//	level.player setactionslot( 1, "nightvision" );
	thread magic_smoke( "church_smoke" );
	
	door = link_door_to_clips( "white_building_door" );
	door thread kick_door_open();
//	level.sandman thread follow_path_waitforplayer( get_target_ent( "enter_church_path" ) );
}


pre_drone_runners()
{
	flag_wait( "start_church" );
	wait( 0.5 );
	drones = array_spawn_targetname( "pre_church_flee_drone" );
}

church_setup()
{
	flag_wait( "start_church" );
	//autosave_by_name( "start_church" );
	
	if ( !flag( "btr_spotted" ) )
	{
		ai = getaiarray( "axis" );
		foreach( a in ai )
		{
			a maps\_stealth_utility::disable_stealth_for_ai();
		}
		flag_clear( "_stealth_spotted" );
	}
	
	lights_flick = getentarray( "flickering_churchlight", "targetname" );
	
	foreach ( light in lights_flick )
	{
		thread flickering_light( light, 0.5, 0.6 );
		thread moving_light( light, 4 );
	}
		

	
	triggers = getentarray( "church_stealth_triggers", "script_noteworthy" );
	foreach ( t in triggers )
	{
		t trigger_on();
	}
	
	level.sandman disable_ai_color();
	level.sandman.goalradius = 128;
	level.sandman.goalheight = 16;
	level.sandman disable_cqbwalk();
		
	thread church_run_two(); // new alternate ending.
	thread church_drop();
	thread large_doors();
	thread church_combat_start();
	thread church_shoot_through_door();
	thread pre_drone_runners();
	thread church_car_health();
	thread player_climbs_slow();
	thread church_ambient_choppers();
	thread church_run_hint();
//	thread save_at_beg_of_church();
	thread epic_scene_tons_of_guys();
	thread kill_vehicles();
	thread top_runners_spawn();
	
	array_spawn_targetname( "civs_that_hold_door" );

	thread planks_that_fall_over_jump();
//	thread kick_boards_over();
	
	flag_wait( "church_street_clear" );
//	fake_fx = spawn( "script_origin", ( 21133, -6638, -72 ) ); 
//	PlayFX( getfx( "firelp_med_pm" ), fake_fx.origin ,( 10,0,0), (0,0,1) );	


	triggers = getentarray( "church_stealth_triggers", "script_noteworthy" );
	foreach ( t in triggers )
	{
		t trigger_off();
	}	
	
	//level.player blend_movespeedscale_percent( 80, 6 );
}

save_at_beg_of_church()
{
	flag_wait( "flag_before_run_in_for_autosave" );
	autosave_by_name( "flag_before_run_in_for_autosave" );
	
	flag_wait( "player_at_top" );
	autosave_by_name( "player_at_top" );
}

church_run_hint()
{
	flag_wait( "church_drop_hint" );
	
	diff = getdifficulty();
	if ( (diff != "fu") )
		delaythread( 1, ::display_hint_timeout, "hint_prone", 4 );
}

church_run()
{
	node = get_target_ent( "church_run_drop" );
	node anim_reach_solo( level.sandman, "hunted_drop" );
	
	flag_set( "church_drop" );
	node anim_single_solo( level.sandman, "hunted_drop" );
	node thread anim_loop_solo( level.sandman, "hunted_drop_idle" );
	
	flag_wait( "soap_jump_back" );
	node notify( "stop_loop" );
	
//	node = get_target_ent( "church_run_drop_jumpback" );
	level.sandman anim_single_solo( level.sandman, "hunted_pronehide_jumpback" );
	delta = GetMoveDelta( level.sandman getanim( "hunted_pronehide_jumpback" ) );
	node = get_target_ent( "church_run_drop" );
	node.origin = node.origin + delta;
	node thread anim_loop_solo( level.sandman, "hunted_drop_idle" );
	flag_wait_either( "church_street_clear", "_stealth_spotted" );
	if ( !flag( "_stealth_spotted" ) )
	{
		wait( 2.0 );
		//Sandman: Move it!
		thread radio_dialogue( "prague_snd_moveit" );
	}
	thread music_play( "prague_danger_3" );
	node notify( "stop_loop" );
	path = get_target_ent( "pre_enter_church_path" );
	level.sandman thread follow_path_waitforplayer( path );
	node anim_generic_gravity( level.sandman, "hunted_drop_2_stand" );	
	
	thread sandman_upstairs_path();
	if ( !flag( "_stealth_spotted" ) )
	{
		level.sandman thread enable_sprint();
		path = path get_target_ent();
		path waittill( "trigger" );
		//level.sandman thread follow_path_waitforplayer( get_target_ent( "pre_enter_church_path" ) );
		//path = get_target_ent();
	}
	
	//level.sandman thread radio_dialogue( "prague_snd_grabcover" );
	//unarmed_cowercrouch_idle 
	level.sandman anim_single_solo( level.sandman, "exposed_crouch_idle_twitch" );
	// this was a wait for 2
	wait( 2 );
	
	
	
	level.sandman thread radio_dialogue( "prague_snd_moveit" );
	//	level.sandman waittill( "path_end_reached" );
	level.sandman.combatmode = "no_cover"; 
	//  level.sandman waittill( "path_end_reached" );
	//	node = get_target_ent( "enter_church_path" );
	//	level.sandman setgoalpos( node.origin );
	
	level.sandman.goalradius = 500;
	
	level.sandman thread follow_path_waitforplayer( get_target_ent( "enter_church_path" ) );
	path = get_target_ent( "enter_church_path" );
	path waittill( "trigger" );
	level.sandman thread disable_sprint();
	level.sandman waittill( "path_end_reached" );
	thread sandman_climb_scaffolding();
	path = get_target_ent( "enter_church_path" );
	level.sandman thread follow_path_waitforplayer( path );
}

church_run_two()
{
	node = get_target_ent( "church_run_drop" );
	node anim_reach_solo( level.sandman, "hunted_drop" );
	
	flag_set( "church_drop" );
	node anim_single_solo( level.sandman, "hunted_drop" );
	node thread anim_loop_solo( level.sandman, "hunted_drop_idle" );
	
	flag_wait( "soap_jump_back" );
	node notify( "stop_loop" );
	
	node = get_target_ent( "church_run_drop_jumpback" );
	level.sandman anim_single_solo( level.sandman, "hunted_pronehide_jumpback" );
	
	delta = GetMoveDelta( level.sandman getanim( "hunted_pronehide_jumpback" ) );
	a = node.angles;
	a2= VectorToAngles( delta );
	a3= a+a2;
	v = AnglesToForward( a3 );
	d = Distance( delta, (0,0,0) );
	delta = v*d;
	
	node = get_target_ent( "church_run_drop" );
	node.origin = node.origin + delta;	
	node = get_target_ent( "church_run_drop" );
	node thread anim_loop_solo( level.sandman, "hunted_drop_idle" );
	flag_wait_either( "church_street_clear", "_stealth_spotted" );
	if ( !flag( "_stealth_spotted" ) )
	{
		wait( 2.0 );
		//Sandman: Move it!
		thread radio_dialogue( "prague_snd_moveit" );
	}
	thread music_play( "prague_danger_3" );
	thread ai_run_into_the_church(); 
	thread new_alternet_ending();
	node notify( "stop_loop" );
	path = get_target_ent( "pre_enter_church_path" );
	level.sandman thread follow_path_waitforplayer( path );
	node anim_generic_gravity( level.sandman, "hunted_drop_2_stand" );	
	
	thread sandman_upstairs_path();
	if ( !flag( "_stealth_spotted" ) )
	{
		level.sandman thread enable_sprint();
		path = path get_target_ent();
		path waittill( "trigger" );
		//level.sandman thread follow_path_waitforplayer( get_target_ent( "pre_enter_church_path" ) );
		//path = get_target_ent();
	}
	
	flag_set( "ai_run_into_the_church_from_outside" );
	level.sandman anim_single_solo( level.sandman, "exposed_crouch_idle_twitch" );
	
	btrs = get_vehicle_array( "back_up_vehicle", "script_noteworthy" );
	foreach ( vehicle in btrs )
	{
		vehicle thread sandman_distance_check_fail();
	}
	
//	wait( 2 );
	level.sandman thread radio_dialogue( "prague_snd_moveit" );
//	delaythread( 1.6, :: radio_dialogue, "prague_mct_belltower"  );	
	//	level.sandman waittill( "path_end_reached" );
	level.sandman.combatmode = "no_cover"; 
	//  level.sandman waittill( "path_end_reached" );
	//	node = get_target_ent( "enter_church_path" );
	//	level.sandman setgoalpos( node.origin );
	
	// level.sandman.goalradius = 500;
	
	level.sandman thread follow_path_waitforplayer( get_target_ent( "enter_church_path_two" ), 200 );
	path = get_target_ent( "enter_church_path_two" );
	path waittill( "trigger" );
	level.sandman thread disable_sprint();
	level.sandman waittill( "path_end_reached" );
//	thread sandman_climb_scaffolding();
}

// if the player gets to far away from soap failmission
sandman_distance_check_fail()
{
	while( 1 )
	{
		if ( Distance( level.player.origin, self.origin ) < 1000 )
		{
			thread player_constant_damage();
			break;
		}
		wait( 0.05 );
	}
}

church_drop()
{	
	flag_wait( "church_drop" );
	//Sandman: Get down now!!
	thread radio_dialogue( "prague_snd_downnow" );
	//Soap: Stayyyy down.
	delayThread( 2.5, ::radio_dialogue, "prague_mct_staydown" );
	array_spawn_targetname( "church_flee_nondrone" );
	drones = array_spawn_targetname( "church_flee_drone" );
	
	s = get_target_ent( "run_panic_walla" );
	sound_source = Spawn( "script_model", s.origin );
	sound_source thread play_sound_on_tag( "walla_prague_panic_run1" );
	s = s get_target_ent();
	sound_source MoveTo( s.origin, 7.0 );
	
	flag_wait_or_timeout( "_stealth_spotted", 4.0 );
	foreach ( d in drones )
	{
		d Solid();
	}
	btrs = spawn_vehicles_from_targetname_and_drive( "church_btr" );
	foreach( jeep in btrs )
	{
		jeep maps\_vehicle::godon();
	}
	
	thread church_tank_crush();
	if ( flag( "_stealth_spotted" ) )
	{
		wait( 0.05 );
		foreach ( btr in btrs )
		{
			btr ResumeSpeed( 3 );
			btr Vehicle_SetSpeedImmediate( 20.0, 5.0 );
			wait( 2.0 );
			btr Vehicle_SetSpeedImmediate( 0.0, 5.0 );
		}
	}
	else
	{
		foreach ( btr in btrs )
		{
			btr thread btr_randomly_fire( getstructarray( "church_btr_targets", "targetname" ) );
			btr.health = 10000;
		}
		thread check_for_player_prone();
	}
	
	wait( 6 ); 
	btrs = spawn_vehicles_from_targetname_and_drive( "back_up_vehicle" );
	foreach( jeep in btrs )
	{
		jeep maps\_vehicle::godon();
	}
}

church_tank_crush()
{
	truck = getent( "tankcrush", "targetname" );
	
	tank = spawn_vehicle_from_targetname_and_drive( "church_t90" );

	tank maps\_vehicle::godon();

	node = getVehicleNode( "tank_crush_node", "script_noteworthy" );
	node waittill( "trigger" );
	delayThread( 0.63, ::flag_set, "soap_jump_back" );
	tank Vehicle_SetSpeed( 0, 999999999, 999999999 );
	tank_path_2 = getVehicleNode( "church_t90_path_2", "targetname" );
	tank resumeSpeed( 5 );
	tank notify( "newpath" );// kill vehicle path stuff since everything is handled locally. - Nate
	exploder( 1 );
	tank maps\_vehicle::tank_crush( truck,
									tank_path_2,
									level.scr_anim[ "tank" ][ "tank_crush" ],
									level.scr_anim[ "truck" ][ "tank_crush" ],
									level.scr_animtree[ "tank_crush" ],
									level.scr_sound[ "tank_crush" ] );
	tank resumeSpeed( 5 );
	tank gopath();
}

church_flee_drone_think()
{
	self thread drone_assign_unique_death( level.drone_deaths_f );
	waittillframeend;
	if ( cointoss() )
	{
		self gun_remove();
		self.runAnim = level.civ_runs[ RandomIntRange( 0, level.civ_runs.size ) ];
	}
}

church_flee_think()
{
	self endon( "death" );
	self thread deletable_magic_bullet_shield();
	self delayThread( 1.0, ::stop_magic_bullet_shield );
	
	node = self get_target_ent();
	goal = node get_target_ent();
	anime = node.animation;
	
	org1 = self getEye();
	self.ignoreSuppression = true;	
	node anim_generic_reach( self, anime );
	
	node thread anim_generic_run( self, anime );
	waittillframeend;
	self.goalradius = 64;
	self setGoalPos( goal.origin );
	
	node thread interrupt_anim_on_alert_or_damage( self );
	wait( 3.0 );
	while( isAlive( self ) )
	{
		org2 = self getEye();
		MagicBullet( "pecheneg", org1 + ((org2-org1)*0.5), org2 );
		wait( 0.1 );
	}
}

check_for_player_prone()
{
	level endon( "_stealth_spotted" );
	level endon( "church_street_clear" );
	wait( 3.0 );
	volume = get_target_ent( "white_building_volume" );
	while ( 1 )
	{
		wait( 0.1 );
		if ( level.player IsTouching( volume ) )
			continue;
		if ( level.player GetStance() == "prone" )
			continue;
			
		level.sandman notify( "remove_bulletshield" );
		thread player_constant_damage();
		flag_set( "_stealth_spotted" );
	}
}

player_constant_damage()
{
	level.player endon( "death" );
	while( 1 )
	{
		level.player DoDamage( 70, level.player.origin + RandomVector( 1 ) );
		wait( 1 );
	}
}

sandman_climb_scaffolding()
{
	blocker = GetEnt ( "blocker_that_links_to_ai_when_climbing", "targetname" );
	blocker2 = GetEnt ( "block_player_if_he_tries_to_climb_ahead_of_soap", "targetname" );
	
	vehicles = get_vehicle_array( "script_vehicle_btr80", "classname" );
	foreach ( btr in vehicles )
		btr notify( "stop_random_fire"	);
	
	if ( !IsDefined( level.heli ) )
	{
		thread patrol_chopper( "church_heli" );
	}
	level.heli heli_wants_spotlight();
		
	node = get_Target_ent( "church_climb_node" );
	
	thread wait_for_player_to_climb_scaffold();
	
	node anim_generic_reach( level.sandman, node.animation );
	level.sandman enable_cqbwalk();
	
	level.sandman PushPlayer( false );
	level.sandman.dontavoidplayer = true;
	
	thread remove_scaffolding_blocker( blocker2 );
	blocker linkto( level.sandman, "tag_inhand", (0,0,0), (0,0,0) );
	display_hint( "hint_scaffold" );
	while ( isdefined( node ) )
	{
		node anim_generic( level.sandman, node.animation );
		if ( isdefined( node.target ) )
			node = node get_target_ent();
		else
			break;
	}
	
	blocker delete();
	level.sandman Unlink();
	level.sandman.fixednode = true;
	if ( !flag( "player_at_top" ) )
	{
		level.sandman.goalradius = 64;
		level.sandman SetGoalPos( level.sandman.origin );
	}
}

remove_scaffolding_blocker( blocker2 )
{
	wait( 3 );
	blocker2 delete(); // remove blocker so the player can now climb
}
	

sandman_upstairs_path()
{	
	battlechatter_off( "allies" );
	trigger_end_door = get_Target_ent( "church_open_top_door" );
	trigger_end_door trigger_off();
//	delayThread( 4.0, ::array_spawn_targetname, "church_patrols" );	
	
	flag_wait( "player_at_top" );
	level.sandman.ignoreall = 1;
//	level.sandman disable_cqbwalk();
	level.sandman thread follow_path_waitforplayer( get_target_ent( "fight_from_above" ), 500 );
	level.sandman waittill ( "path_end_reached" );
	flag_wait( "church_shoot_through_door" );
	flag_set( "pause_shakes_while_in_combat" );
	wait( 4 );
//	thread radio_dialogue(	"prague_mct_waitformygo" );
//	IPrintLnBold( " Hold on, some stragglers, they're by themselves " );
	wait( 5 );
//	thread radio_dialogue(	"prague_mct_getcloser" );	   
	wait( 6 );
	thread radio_dialogue(	"prague_mct_now" );
	level.sandman.ignoreall = 0;
	level.sandman.ignoreme = 0;
	flag_set( "shoot_at_player_and_soap_now" );
	level.sandman.accuracy = 0.1;
//	IPrintLnBold( " open fire " );
	// grab first guy and shoot em.
	
	while ( 1  ) // all three guys must be dead.
	{
		wait( 0.05 );	
		if ( level.counter_dead == 0 )
			break;
	}
	
	clip = getent( "top_of_stair_blocker", "targetname" );
	clip delete();
	
	flag_set( "restart_shakes" );
	autosave_by_name( "player_ready_to_jump" );
	//level.sandman thread radio_dialogue( "prague_mct_theyredone" );
	wait( 2.3 );
	
	node = get_Target_ent( "church_jump_top" );
	node anim_reach_solo( level.sandman, "jump_across" );
	node anim_single_solo( level.sandman, "jump_across" );
	
	level.sandman.goalradius = 156;
	level.sandman thread follow_path_waitforplayer( get_target_ent( "church_upstairs_path" ), 192 );
	level.sandman waittill ( "path_end_reached" );
	
//	level.sandman thread follow_path_waitforplayer( get_target_ent( "deadbody_check_church" ), 192 );
	
	trigger = getent( "sandman_church_clear_run_anim", "script_noteworthy" );
	trigger waittill( "trigger" );

//	flag_set ( "church_sandman_checks_body" );
//	level waittill( "body_checked" );
	
//	iprintlnbold( "Quick over here" );
	
	node = get_target_ent( "kick_boards" ); // go over and kick the boards over.
	level.sandman disable_cqbwalk();
	level.sandman enable_sprint();
	node anim_reach_solo( level.sandman, "kick_grenade" );
	thread kick_boards_over();
//	old_script = level.sandman.script;
//	level.sandman.script = "kicker";
	anim.fire_notetrack_functions[ "scripted" ] = ::Dont_Shoot;
	thread play_sound_in_space ( "door_wood_double_kick", level.sandman.origin );
	node anim_single_solo( level.sandman, "kick_grenade" );
	
	wait( 0.3 );
//	thread radio_dialogue(	"prague_mct_covertracks" );
	wait( 0.8 );
//	level.sandman.script = old_script;
	level.sandman enable_cqbwalk();
	flag_set ( "church_sandman_checks_body" );
	level waittill( "body_checked" );
//	wait( 0.3 );
	
	node = get_target_ent( "sandman_church_wait_end" );
	level.sandman setGoalNode( node );
	
	trigger_end_door trigger_on();
	trigger_end_door waittill( "trigger" );
	
	thread radio_dialogue("prague_mct_belltower" );
	
//	IPrintLnBold( "This takes us to the tower" );
	
	door = get_target_ent( "church_top_door_l" );
	node = get_target_ent( "sandman_open_church_door" );
	node anim_generic_reach( level.sandman, "door_slowopen_arrive" );
	node anim_generic( level.sandman, "door_slowopen_arrive" );
	door thread palm_style_door_open();
	node anim_generic_run( level.sandman, "door_slowopen" );
	level.sandman thread follow_path_waitforplayer( get_target_ent( "church_hallway" ), 192 );
	
	
}

kick_boards_over()
{
	org = spawn ( "script_origin", ( 21921, -5960, 363 ) );
//	soapDirection = vectornormalize(anglestoforward(level.bomb_truck.angles));
//	//set physics origin behind van
//	physicsOrigin = org.origin - (vanDirection * 250);
//	//set magnitude and add upward force
//	forceDirection = (vanDirection * magnitude) + (0,0,0.075);
	
	
	wait( 0.3 );
	PlayFX( level._effect[ "ball_bounce_dust" ], org.origin + ( 0, 0, 0 ), ( 0, 0, 1 ) );
	PlayFX( level._effect[ "ball_bounce_dust" ], org.origin + ( 0, 0, 5 ), ( 0, 0, 1 ) );
	PlayFX( level._effect[ "ball_bounce_dust" ], org.origin + ( 0, 0, 8 ), ( 0, 0, 1 ) );
	
	org2 = spawn ( "script_origin", ( 21796, -5933, 327 ) );
	org3 = spawn ( "script_origin", ( 21666, -5896, 352 ) );
//  (0,60,0 )
//	org physicslaunchserver
//	physicsjolt( org, 200, 150, (0,60,100) );
//	physicsexplosionsphere( org.origin, 300, 280, 4 );
//	wait( 0.1 );
	physicsexplosionsphere( org.origin, 300, 280, 10 );
	physicsexplosionsphere( org2.origin, 300, 280, 10 );
	physicsexplosionsphere( org3.origin, 300, 280, 10 );
//	wait( 0.1 );
//	physicsexplosionsphere( org3.origin, 300, 280, 4 );
//	wait( 0.1 );
//	physicsexplosionsphere( org.origin, 300, 280, 4 );
//	wait( 0.1 );
//	physicsexplosionsphere( org.origin, 300, 280, 4 );
//	wait( 0.1 );
//	physicsexplosionsphere( org.origin, 300, 280, 4 );
}

wait_for_player_to_climb_scaffold()
{
	level.sandman endon( "follow_path" );
	
	while( 1 )
	{
		if ( Distance( level.player.origin, level.sandman.origin ) < 128 )
			break;
		wait( 0.05 );
	}
	
	node = get_Target_ent( "church_climb_node" );
	while ( isdefined( node ) )
	{
		if ( issubstr( node.animation, "loop" ) )
			node.animation = node.animation ;
			//node.animation = node.animation + "_fast";
			
		if ( isdefined( node.target ) )
			node = node get_target_ent();
		else
			break;
	}
}

church_patrols_think()
{
	self.ignoreMe = true;
	self LaserForceOn();
	wait( 0.05 );
	self clear_run_anim();
	self set_generic_run_anim( self.animation );
}

church_btr_think()
{
	self thread btr_attack_player_on_spotted();
	wait( 0.05 );
	self notify( "awake" );
	foreach ( mg in self.mgturret )
	{
		mg thread maps\_mgturret::burst_fire_unmanned();
		mg thread maps\_mgturret::mg42_target_drones( true, "axis" );
	}
}

the_end()
{
	flag_wait( "church_end_anim_talk" );
	thread player_runs_ahead();
//	level.sandman thread follow_path_waitforplayer( get_target_ent( "soap_final_msg_node" ) );
//	flag_wait( "the_end" );
//	node = get_target_ent( "soap_final_msg_node" );
//	node anim_generic_reach( level.sandman, "prague_soap_final_message" );
//	node thread anim_generic( level.sandman, "prague_soap_final_message" );
//	setSavedDvar( "ai_playerADS_LOSRange", level.oldADSRange );
//	wait( 3.0 );

//	iprintlnbold( "S: The bell tower's direclty above us." );
	flag_wait( "church_player_in_main_hall" );
	radio_dialogue( "prague_mct_inposition" );
	wait( 7.0 );
	//wait( 0.8 );
	radio_dialogue( "prague_pri_getcomfortable" );
	wait( 0.4 );
	thread fade_out( 5 );
	//Soap: You got it mate.  C'mon, Yuri - let's get set up.
	thread radio_dialogue( "prague_mct_yougotit" );
	wait( 2 );
	//Soap: Let's get set up.
	thread radio_dialogue(	"prague_mct_getsetup" );
	
	wait( 6 );	
//	if( !flag( "player_rushed_ending" ) )
//	{
		nextmission();
//	}
}

player_runs_ahead()
{
	ent = GetEnt( "end_level_if_player_runs_ahead", "targetname" );
	ent waittill  ( "trigger" );
	flag_set( "player_rushed_ending" );
	fade_out( 1 );
	nextmission();
}

large_doors()
{
	door_l = GetEnt( "church_door_left", "targetname" );
	door_r = GetEnt( "church_door_right", "targetname" );

	door_l connectpaths();
	door_l rotateyaw( -70, 0.5 );
	door_l waittill( "rotatedone" );
	door_l disconnectpaths();
/*
	flag_wait( "on_scaffold" );
	
	door_l rotateyaw( 70, 0.1 );
	door_l waittill ( "rotatedone" );
	door_l disconnectpaths();
	
	wait( 5 );
	
	flag_wait( "church_shoot_through_door" );
	
	door_l connectpaths();
	door_r connectpaths();
	
	wait( 3 );
	door_l rotateyaw( -55, 6 );
	door_r rotateyaw( 75, 6 );
	
	flag_wait( "shoot_at_player_and_soap_now" );
*/
}

church_shoot_through_door()
{
	flag_wait( "church_shoot_through_door" );
	
	ai  = get_living_ai ( "door_holder_three", "script_noteworthy" );
	ai waittill_player_lookat( 0.5, 0.5 );
	
	//  magicbullet stuff through the wall..
	//	MagicBullet( "pecheneg", source.origin, self getEye() );
	 
	magicbullet ( "ak47", ( 21985, -6181, 29 ), ( 21951, -5928, 29 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 21985, -6181, 29 ), ( 21951, -5928, 29 ) );
	wait( 0.005);	
	magicbullet ( "ak47", ( 21974, -6142, 30 ), ( 21901, -5806, 73 ) );
	wait( 0.005);
	magicbullet ( "ak47", ( 21974, -6142, 30 ), ( 21901, -5806, 73 ) );
	wait( 0.005);
	magicbullet ( "ak47", ( 22002, -6157, 37 ), ( 21968, -5891, 37 ) );
	wait( 0.005);
	magicbullet ( "ak47", ( 22002, -6157, 37 ), ( 21968, -5891, 37 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 22032, -6130, 59 ), ( 21962, -5753, 77 ) ); 
	wait( 0.005);
	magicbullet ( "ak47", ( 22032, -6130, 59 ), ( 21962, -5753, 77 ) ); 
	wait( 0.005);
	magicbullet ( "ak47", ( 22112, -6223, 29 ), ( 22011, -5768, 29 ) );  
	wait( 0.005);
	magicbullet ( "ak47", ( 22112, -6223, 29 ), ( 22011, -5768, 29 ) );  
	wait( 0.005); 
	magicbullet ( "ak47", ( 22042, -6118, 19 ), ( 21992, -5903, 19 ) );  
	wait( 0.005);
	magicbullet ( "ak47", ( 22042, -6118, 19 ), ( 21992, -5903, 19 ) );  
	wait( 0.005); 
	magicbullet ( "ak47", ( 22059, -6138, 19 ), ( 21955, -5769, 19 ) );   
	wait( 0.005);
	magicbullet ( "ak47", ( 22059, -6138, 19 ), ( 21955, -5769, 19 ) );   
	wait( 0.005); 
	magicbullet ( "ak47", ( 22074, -6136, 62 ), ( 22024, -5860, 62 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 22074, -6136, 62 ), ( 22024, -5860, 62 ) );
	wait( 0.005);	
	magicbullet ( "ak47", ( 22074, -6136, 62 ), ( 22024, -5860, 62 ) );
	wait( 0.005);
	magicbullet ( "ak47", ( 22147, -6253, 36 ), ( 22053, -5804, 36 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 22127, -6268, 29 ), ( 22060, -5838, 29 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 22127, -6268, 29 ), ( 22060, -5838, 29 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 22172, -6173, 28 ), ( 22110, -5857, 28 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 22172, -6173, 28 ), ( 22110, -5857, 28 ) );
	wait( 0.005);  
	magicbullet ( "ak47", ( 22121, -6200, 53 ), ( 22034, -5811, 53 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 22121, -6200, 53 ), ( 22034, -5811, 53 ) );
	wait( 0.005);
	magicbullet ( "ak47", ( 22164, -6258, 29 ), ( 22086, -5831, 29 ) );
	wait( 0.005);
	magicbullet ( "ak47", ( 22148, -6144, 79 ), ( 22082, -5832, 79 ) );
	wait( 0.005); 
	magicbullet ( "ak47", ( 22148, -6144, 79 ), ( 22082, -5832, 79 ) );
	wait( 0.005);
	magicbullet ( "ak47", ( 22148, -6144, 79 ), ( 22082, -5832, 79 ) );
}

church_combat_start() // encounter with guys coming through the doorway.
{
	level.counter_dead = 0;
	flag_wait( "church_shoot_through_door" );
	wait( 5.3 ); 
	// be sure to have them mantle over stuff as they come into the room.
	dudes = array_spawn_targetname( "church_combat_one" );
	wait( 2 ); 
	dudes = array_spawn_targetname( "church_combat_two" );
	
	flag_wait( "shoot_at_player_and_soap_now" );
	dudes = array_spawn_targetname( "church_combat_three" );
	
//	hurt_guys = getstructarray( "church_bodies", "targetname" );
//	
//	foreach( ai in hurt_guys )
//	{
//	//	self setentitytarget ( aim_helper );	
//	}
}



// we just had a big batle upstairs...
church_combat_think() // encounter with guys coming through the doorway.
{
	self endon ( "death" );
	self thread if_damage_notify_all();
	self thread if_damage_clear_settings_and_attack();
	self.grenadeammo = 0;
	battlechatter_on( "axis" );

	self.disableLongDeath = true;
	self LaserForceOn(); // this will make the guys easier to see
	self.goalheight = 100;
	waitframe();
	self.moveplaybackrate = 0.6;
	waitframe();
	self enable_cqbwalk();

	node = getnode( "church_combat_target", "targetname" );
	
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_one" ) )
	{
		self.goalradius = 5;
		waitframe();
		self.goalradius = 50;
		
		// wait till he gets in and then play the stop anim
		// then stop everyone at once in here.
		//play anim walk_2_cqb_stop
	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_two" ) )
	{
		self.goalradius = 5;
		wait( 1 );
		self.goalradius = 50;
	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_three" ) )
	{
		self.goalradius = 5;
		wait( 2 );
		self.goalradius = 50;
	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_four" ) )
	{
		self.goalradius = 5;
		waitframe();
		self.goalradius = 50;
	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_five" ) )
	{
		self.goalradius = 5;
		wait( 1 );
		self.goalradius = 50;
	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_six" ) )
	{
		self.goalradius = 5;
		wait( 2 );
		self.goalradius = 50;
	}
	self setgoalnode( node );
}

if_damage_notify_all()
{
	self endon( "death" );
	waittill_either("death", "damage" );
	flag_set( "shoot_at_player_and_soap_now" );
}

if_damage_clear_settings_and_attack()
{
	self endon ( "death" );
	flag_wait( "shoot_at_player_and_soap_now" );
	
	self.goalradius = 1000;
	self disable_cqbwalk();
	self.moveplaybackrate = 1.0; 
	self getenemyinfo( level.player );
	self getenemyinfo( level.sandman );
//	self.favoriteenemy = level.sandman;
	
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_one" ) )
	{
		self.goalradius = 100;
		node = getnode( "combat_marker", "targetname" );
		self setgoalnode( node );
		self.ignoreall = 1;
		wait( 3 );
		self.ignoreall = 0;
	}
	else if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_two" ) )
	{
		self.goalradius = 100;
		node = getnode( "combat_marker", "targetname" );
		self setgoalnode( node );
		self.ignoreall = 1;
		wait( 3 );
		self.ignoreall = 0;
	}
	else if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "church_combat_three" ) )
	{
		self.goalradius = 100;
		node = getnode( "combat_marker", "targetname" );
		self setgoalnode( node );
		self.ignoreall = 1;
		wait( 3 );
		self.ignoreall = 0;
	}
}

church_combat_think_three()
{
	self.grenadeammo = 0;
	self.disableLongDeath = true;
	self LaserForceOn(); // this will make the guys easier to see
	self.goalheight = 1500;
}

dead_body_spawner_trigger_ludes_think()
{
	self waittill( "trigger" );
	t = self get_target_ent();
	structs = getstructarray( t.script_noteworthy, "script_noteworthy" );
	foreach ( s in structs )
	{
		guy = t spawn_ai();
		guy thread deletable_magic_bullet_shield();
		guy teleport_ai ( s.origin ) ;
		guy.origin = s.origin;
		guy.angles = s.angles;
		
		anime = level.scr_anim[ "generic" ][ s.animation ];
		if ( IsArray( anime ) )
			anime = anime[ 0 ];
			
		guy AnimScripted( "endanim", s.origin, s.angles, anime );
		if ( isdefined( s.script_parameters ) && s.script_parameters == "notsolid" )
		{
			guy NotSolid();
		}
		
		if ( issubstr( s.animation, "death" ) )
			guy delayCall( 0.05, ::setAnimTime, anime, 1.0 );
	}
}

church_vehciles_follow_through()
{
	self vehicle_lights_on( "running spotlight_turret" );
	self Vehicle_SetSpeedImmediate( 2.0, 2.0 );
	self thread btr_randomly_fire( getstructarray( "church_btr_targets", "targetname" ) );
	thread check_for_player_prone();
	self mgoff();
	self thread loop_scanning();
	
	if ( flag( "_stealth_spotted" ) )
	{
		wait( 0.05 );
		self ResumeSpeed( 3 );
		self Vehicle_SetSpeedImmediate( 20.0, 5.0 );
		wait( 2.0 );
		self Vehicle_SetSpeedImmediate( 0.0, 5.0 );
	}
	else
	{

		self thread btr_randomly_fire( getstructarray( "church_btr_targets", "targetname" ) );
		thread check_for_player_prone();
	}
	
	while( 1 )
	{
		if( flag( "flag_before_run_in_for_autosave" ) )
		{
			vehicles = get_vehicle_array( "script_vehicle_btr80", "classname" );
			foreach ( btr in vehicles )
				btr notify( "stop_random_fire"	);
			break;
		}
		wait( 0.05);
	}
	
	
}

church_car_health() // so the car never takes damage... that way soaps always slides across it.
{
	car = getent( "church_car","targetname");
	car.health = 50000;
}

loop_scanning()
{
	vec1 = spawn ( "script_origin", ( 23022, -12562, 32 ) );
	vec2 = spawn ( "script_origin", ( 18972, -11241, 649 ) );
	vec3 = spawn ( "script_origin", ( 19673, -8473 ,-17 ) );
	vec4 = spawn ( "script_origin", ( 23022, -12562, 32 ) );
	
	self.main_turret[ "aimspeed" ] = 5;
	while( !flag( "_stealth_spotted" ) )
	{
		self setturrettargetent( vec1 );
		self waittill( "turret_on_target" );
		wait( 5 );
		self setturrettargetent( vec2 );
		self waittill( "turret_on_target" );
		wait( 5 );
		self setturrettargetent( vec3 );
		self waittill( "turret_on_target" );
		wait( 5 );
		self setturrettargetent( vec4 );
		self waittill( "turret_on_target" );
		wait( 5 );
	}
//	self setturrettargetvec(  );
//	self setturrettargetvec(  );
}

#using_animtree( "generic_human" );

yell_to_get_inside()
{
	while( !flag ("church_player_in_main_hall") )
	{
		if ( Distance( level.player.origin, self.origin ) < 600 )
		{
//			self thread radio_dialogue( "prague_ru1_havearunner" );
			wait randomfloatrange( 2, 4 );
		}
		wait( 0.05 );
	}	
}

kill_myself()
{
//	flag_wait( "church_shoot_through_door" );
//	wait( 0.3 );
//	self kill();
}

church_fall_kill()
{	
	trigger = GetEnt( "church_fall_kill", "targetname");
	trigger trigger_off();
//	flag_wait( "church_shoot_through_door" );
	flag_wait( "on_scaffold" );
	
	trigger trigger_on();
	trigger waittill( "trigger" );
	level.player kill();
}

minor_earthquakes() // brought over code from gulag
{	
	
	min_eq = 0.15;
	max_eq = 0.25;
	
	dif_eq = max_eq - min_eq;
	
	min_phys = 0.20;
	max_phys = 0.30;
	
	dif_phys = max_phys - min_phys;
	first = true;
	
	
	while( !flag( "off_scaffold" ) )
	{
//	}
//	for ( ;; )
//	{
		scale = randomfloat( 1 );		
		if ( first )
		{
			first = false;
			scale = 1;
		}
		eq = min_eq + scale * dif_eq;
		phys = min_phys + scale * dif_phys;
		
		
		//if ( randomint( 100 ) < 35 )
		//	player_gets_hit_by_rock();
			
		//quake( eq, 3 + scale * 2, level.player.origin + randomvector( 1000 ), 5000 );
		angles = level.player getplayerangles();
		forward = anglestoforward( angles );
		org = level.player.origin + forward * 180;
		org = set_z( org, level.player.origin[2] + 64 );
		//PhysicsJitter( org, 350, 250, 0.05, 0.2 );
		vec = randomvector( phys );
		if ( vec[2] < 0 )
		{
			vec = set_z( vec, vec[2] * -1 );
		}
		PhysicsJolt( org, 350, 250, vec );
		//PhysicsExplosionSphere( org, 350, 250, 0.5 );
//		Print3d( org, ".", (1,0,0), 1, 1, 5 );
		
		wait( RandomFloatRange( 0.5, 2 ) );
	}
}

fake_jolts()
{
	flag_clear( "on_scaffold" );
	thread minor_earthquakes();
	wait( 4 );
	flag_set( "on_scaffold" );
	//church_open_top_door
}

Dont_Shoot()
{
}

church_sandman_checks_body()
{	
	node = get_Target_ent( "deadbody_check_church" );
	body = spawn_targetname( "deadbody_check_civ_church" );
	spawn_failed();
	body hero_head();
	node thread anim_generic( body, "deadbody_check_body_start" );
	
	flag_wait( "church_sandman_checks_body" ); // flag to do the check
//	wait( 1.5 );
	level thread body_dialogue();	
	node anim_generic_reach( level.sandman, "deadbody_check" );
	node thread anim_generic( body, "deadbody_check_body" );
	
	node anim_generic( level.sandman, "deadbody_check" );
	/*
	node anim_generic( level.sandman, "deadbody_check_end" );
	level.sandman anim_generic( level.sandman, "stand_2_run_f_2" );
	*/
	node anim_generic( level.sandman, "deadbody_check_end" );
	level notify( "body_checked" );
}

body_dialogue()
{
	wait( 7.7 );
	//iprintlnbold( "This wasn't a war..." );
	//thread radio_dialogue( "prague_mct_genocide" );
}

player_climbs_slow()
{
	// level endon
	trigger = GetEnt( "slow_ladder_movement", "targetname" );
	//assertex( if !IsDefined (trigger ) )
	
	while( 1 )
	{
		if( level.player Istouching ( trigger ) )		
			level.player player_speed_percent( 29 );
		else
			level.player player_speed_percent( 100 );
		wait( 0.005 );
	}
}

church_ambient_choppers()
{
	flag_wait( "start_church" );
	wait( 1 );
	heli_one = spawn_vehicle_from_targetname_and_drive( "church_ambient_one" );
	heli_one thread helicopter_searchlight_on();
	flag_wait( "church_ambient_chopper_large" );
	heli_two = spawn_vehicle_from_targetname_and_drive( "church_ambient_two" );
	heli_two = spawn_vehicle_from_targetname_and_drive( "church_ambient_three" );
//	heli_one thread helicopter_searchlight_on();
	wait( 1.7 );
	heli_two = spawn_vehicle_from_targetname_and_drive( "church_ambient_four" );
	wait( 0.3 );
	heli_two = spawn_vehicle_from_targetname_and_drive( "church_ambient_five" );
//	heli_one thread helicopter_searchlight_on();
	wait( 0.3 );
	heli_two = spawn_vehicle_from_targetname_and_drive( "church_ambient_six" );
	
}

planks_that_fall_over_jump()
{
	plank1 = getent( "plank_off_scaffolding", "targetname" );
	plank1 connectpaths();
	
//	planks = getentarray( "pre_plank_off_scaffolding", "targetname" );
//
//	foreach( plank in planks )
//	{
//		planks moveto ( planks.origin + ( 0,0,1000 ) );
//	}
//	plank1 moveto ( plank1.origin + ( 0,0,1000 ) );
	
//	wait( 10 );
//	foreach( plank in planks )
//	{
//		planks moveto ( planks.origin + ( 0,0, -1000 ) );
//	}
//	plank1 moveto ( plank1.origin + ( 0,0, -1000 ) );
}

// Soap runs through door, yells at price that they are in positin
// Soap spins around at the bottom and says banter with price..
// then level fade out.
// all you have to do is commment in church_run and comment out the new_alertnee_ending.

new_alternet_ending()
{
	level.player endon( "death" );	
	oldnode = undefined;
	node = get_target_ent( "enter_church_path_two" );
	while( isdefined( node.target ) )
	{
		oldnode = node;
		node = node get_target_ent();
		if ( isdefined( node.animation ) )
		{
			if ( node.animation == "prague_ending_soap_radiotalk" )
			{
				break;
			}
		}
	}
	oldnode waittill( "trigger" );
	level.sandman waittill( "starting_anim" );
	node waittill( "prague_ending_soap_radiotalk" );
	flag_set( "the_end" );
	fade_out( 3.3 );
	level.player FreezeControls( true );
	wait( 1 );
	nextmission();
}

epic_scene_tons_of_guys()
{
//	wait( 30 ); 
//	flag_wait( "flag_before_run_in_for_autosave" );
//	drones = getentarray( "church_drone_guns", "targetname" );
//	drones = array_spawn_targetname( "church_drone_guns" );
//	foreach( ai_drone in drones )
//	{
//		num = RandomIntRange( 0, 1 );
//		switch ( num )
//		{
//			case 0:
//				ai_drone thread maps\_drone::drone_play_looping_anim( level.drone_anims[ "allies" ][ "stand" ][ "idle" ], 1 );
//			case 1:
//				ai_drone thread maps\_drone::drone_play_looping_anim( level.drone_anims[ "allies" ][ "crouch" ][ "idle" ], 1 );
//		}	
//	}
}

church_drone_guns_think()
{
//	num = RandomIntRange( 0, 1 ); 
//	switch ( num )
//	{
//		case 0:
//			self thread maps\_drone::drone_play_looping_anim( level.drone_anims[ "allies" ][ "coverstand" ][ "fire" ], 1 );
//		case 1:
//			self thread maps\_drone::drone_play_looping_anim( level.drone_anims[ "allies" ][ "coverscrouch" ][ "fire" ], 1 );
//	}
}


kill_vehicles()
{
	flag_wait( "flag_before_run_in_for_autosave" );
	tank = get_vehicle_array( "back_up_vehicle", "script_noteworthy" );
	foreach ( vehicle in tank )
	{
	//	vehicle delete();
	}
}

ai_run_into_the_church()
{
	wait( 3 );
//	array_spawn_targetname( "civs_that_hold_door" );
}
// There positioning is cool... 
// Once he takes cover then make then run into the building...
// spawn guys outside
// make them run in just before soap..
// You follow them in and they get settled in...
// should they
guys_who_run_in()
{
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "door_holder_four" ) )
	{
		self.health = 10000;
		node = get_target_ent( "come_on" );
		node anim_reach_solo( self, "launchfacility_b_blast_door_seq_waveidle" );
		node thread anim_generic_loop( self, "launchfacility_b_blast_door_seq_waveidle" );
		self thread yell_to_get_inside();
		// flag_wait( "on_scaffold" );	
		flag_wait( "church_player_in_main_hall" );
		
		//new_ending = GetDvarInt( "new_ending", 0 );
		//if ( Dvar ( "new_ending" == 0 )
		//{
		//}
		
		
		
		wait( 3.4 );
		node notify( "stop_loop" );
		node = get_target_ent( "door_holder_four_spot" );
		self setgoalnode( node );
	}
	
	
	
	level waittill ( "ai_run_into_the_church_from_outside" );
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "outisde_one" ) )
	{
		node = get_target_ent( "inside_one" );
		self setgoalnode( node );
	}
	
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "outisde_two" ) )
	{
		wait( 2 );
		node = get_target_ent( "inside_two" );
		self setgoalnode( node );
	}
	
	flag_wait( "enter_first_room_of_church" );
	// I need to make them run to a location.
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "outisde_three" ) )
	{
		self kill();
	}
	
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "outisde_delete" )  )
	{
		self kill();
	}
	
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "door_holder_one" )  )
	{
		self kill();
	}
	
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "door_holder_two" )  )
	{
		self kill();
	}
	
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "door_holder_three" )  )
	{
		self kill();
	}
}

top_runners_spawn()
{
	flag_wait( "flag_before_run_in_for_autosave" );
	array_spawn_targetname( "jeer" );
	spawn_targetname( "runner_one" );
	wait( 1.7 );
	spawn_targetname( "runner_two" );
	wait( 1.3 );
	spawn_targetname( "runner_three" );
	wait( 0.9 );
	spawn_targetname( "runner_four" );
	wait( 1 );
	spawn_targetname( "runner_five" );
	
}

jeer_think()
{
	self endon( "death" );
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "jeer_one" ) )
	{
	//	node = get_target_ent( "inside_one" );
	//	self setgoalnode( node );
		while( 1 )
		{
			self anim_single_solo( self, "coup_guard2_jeerA" );
			wait( 0.4 );
		}
		//self thread anim_generic_loop( self, "coup_guard2_jeerA" );
	}	
	
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "jeer_two" ) )
	{
		while( 1 )
		{
			self anim_single_solo( self, "coup_guard2_jeerA" );
			wait( 0.4 );
		}
	}	
}

top_runners_think()
{
//	wait( 1.6 );
	self.animname = "generic";
	PlayFxOnTag( getfx( "flashlight" ), self, "TAG_FLASH" );
	self thread kill_light();
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "runner_one" ) )
	{
		node = get_target_ent( "runner_spot_one" );
		node anim_reach_solo( self, "crouch_cover_stand_aim_straight" );
		node thread anim_generic_loop( self, "crouch_cover_stand_aim_straight" );

	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "runner_two" ) )
	{
		node = get_target_ent( "runner_spot_two" );
		node anim_reach_solo( self, "casual_crouch_v2_idle" );
		node thread anim_generic_loop( self, "casual_crouch_v2_idle" );
//		wait( 11 );
	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "runner_three" ) )
	{
		node = get_target_ent( "runner_spot_three" );
		node anim_reach_solo( self, "casual_crouch_v2_idle" );
		node thread anim_generic_loop( self, "casual_crouch_v2_idle" );
//		wait( 12 );
	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "runner_four" ) )
	{
		node = get_target_ent( "runner_spot_four" );
		node anim_reach_solo( self, "readystand_idle" );
		node thread anim_generic_loop( self, "readystand_idle" );
//		wait( 13 );
	}
	if( IsDefined (self.script_noteworthy) && (self.script_noteworthy == "runner_five" ) )
	{
		node = get_target_ent( "runner_spot_five" );
		node anim_reach_solo( self, "casual_crouch_idle" );
		node thread anim_generic_loop( self, "casual_crouch_idle" );
//		wait( 14 );
	}
}

kill_light()
{	
	wait( 2.3 );
	stopFxOnTag( getfx( "flashlight" ), self, "TAG_FLASH" );
//	self notify( "remove_flashlight" );
}
