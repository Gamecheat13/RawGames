#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_util_carlos;
#include maps\_hud_util;

cavern_setup()
{
	flag_wait( "cavern_door_open" );
	flag_set( "hard_targets_dead" );
	// thread ai_delete_when_out_of_sight( ai, 256 );
	array_spawn_targetname( "cavern_dying_guys" );

	thread cavern_dust();	
	thread cavern_start_dialogue();
	
	fx_volume_restart_noteworthy( "fireroom_fx_trigger" );
	fire = get_target_ent( "cave_entrance_fire" );
	fire setLightIntensity( fire.old );
	fire notify( "stop_movement" );
	fire notify( "stop_flicker" );
	fire thread fire_light();
	
	thread radio_dialogue( "rescue_snd_getinside" );
		
	wait( 0.1 );
	friendly = getaiarray( "allies" );
	array_thread( friendly, ::disable_ai_color );
	wait( 0.1 );
	
	//Find and rescue President Gurevich.
	
	if ( !isdefined( level.obj_array[ "open" ] ) )
		Objective_Add( obj( "open" ), "current", &"RESCUE_2_OBJ_110" );
	
	level.obj_array[ "rescue_prez" ] = level.obj_array[ "open" ];
	objective_onentity( obj( "rescue_prez" ), level.price );
	
	thread music_play( "rescue_2_cave_entry", 0.0 );
	
	maps\_remotemissile::disable_uav( false );

	
	heroes = get_heroes();
	array_thread( heroes, ::disable_cqbwalk );
	//array_thread( heroes, ::enable_sprint );
	array_thread( heroes, ::disable_bulletwhizbyreaction );
	array_thread( heroes, ::disable_pain );
	array_thread( heroes, ::set_ignoresuppression, true );
	delayThread( 5, ::array_thread, heroes, ::disable_sprint );
	array_thread( heroes, ::set_force_color, "r" );
	array_thread( heroes, ::set_baseaccuracy, 999 );
	wait( 0.1 );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );
	activate_trigger_with_noteworthy( "friendlies_enter_cavern" );	
	battlechatter_off( "allies" );
	
	wait( 0.1 );
	array_thread( heroes, ::set_ignoreall, false );
	ai = getaiarray( "axis" );
	
	flag_wait( "cavern_drop_down" );
	ai = array_removedead( ai );
	ai = array_removeundefined( ai );
	array_call( ai, ::delete );
	waitframe();
	ai = getaiarray( "allies" );
	ai = array_remove_array( ai, heroes );
	waitframe();
	array_call( ai, ::delete );
	array_thread( heroes, ::enable_bulletwhizbyreaction );
	array_thread( heroes, ::enable_pain );
	array_thread( heroes, ::set_ignoresuppression, false );
}

cavern_breach_setup()
{
	flag_wait( "start_cavern" );
	maps\_slowmo_breach::objective_breach( obj( "rescue_prez" ), 1 );
	
	thread breach_room_dialogue();
	thread chase_timer();
	
	level.slomobreachduration = 0.9;
	level.breachignoreEnemy_count = true;
	level notify( "stop_snow" );
	
	heroes = get_heroes();
	array_thread( heroes, ::set_baseaccuracy, 0.6 );
	array_thread( heroes, ::enable_cqbwalk );
	
	level waittill( "breaching" );
	music_play( "rescue_2_breach", 1.5 );
	
	level waittill( "breach_explosion" );
	level.player.participation = 0;
	Objective_position( obj( "rescue_prez" ), (0,0,0) );
	level.daughter = spawn_targetname( "dead_daughter", true );

	level.player thread lerp_fov_overtime( 2, 60 );
	breach = level.breach_groups[ 1 ]; // 1 is the daughter room breach number
	
	rig = breach.left_post.scene_models[ "active_breacher_rig" ];
	org = level.player spawn_tag_origin();
	org linkTo( rig, "tag_player" );
	level.player PlayerLinkTo( org, "tag_origin", 1, 10, 30, 30, 30 );
	
	level waittill( "sp_slowmo_breachanim_done" );
	level.player thread lerp_fov_overtime( 6, 65 );
/*	level.player PlayerLinkTo( org, "tag_origin", 1, 10, 30, 30, 30 );
	flag_waitopen( "breaching_on" );
	wait( 0.2 );
	level.player unlink(); */
	wait( 0.1 );
	org delete();
//	delayThread( 2, ::activate_trigger_with_noteworthy, "heroes_breach" );
//	delayThread( 3, ::music_play, "arcadia_panicroom" );
}

cavern_top_fight_setup()
{
	flag_wait( "start_president_chase" );
	
//	thread kick_upper_door();
//	thread helicopter_crash_into_bridge();
	thread cavern_top_fight_dialogue();
	thread president_and_crew_escape();
}

cavern_top_rappel_setup()
{
	flag_wait( "cavern_elevator_going_down_with_prez" );
	wait( 2 );
	flag_wait( "start_cavern_rappel" );

	level.sandman thread dialogue_queue( "rescue_snd_hookup" );
	thread rappel_down_cavern();
	thread president_and_crew_escape_bottom();
	wait( 1.5 );
}

cavern_bottom_fight_one_setup()
{
	flag_wait( "start_bottom_fight" );

	thread base_alarm();

	delayThread( 3, ::flag_set, "start_base_alarm" );

	trigger = get_Target_ent( "cavern_president_breach_player_trigger" );
	trigger trigger_off();
	
	heroes = get_heroes();
	array_thread( heroes, ::set_force_color, "r" );
	level.price set_force_color( "p" );
	level.sandman set_force_color( "b" );
	array_thread( heroes, ::disable_cqbwalk );
	
	thread kick_double_door_open( get_Target_ent( "cavern_bottom_enemy_door_l" ), get_Target_ent( "cavern_bottom_enemy_door_r" ) );
	array_spawn_targetname( "cavern_bottom_1", true );
	
	thread bottom_fight_dialogue();
	thread bang_on_door();
	
	wait( 1.7 );
	node = get_target_ent( "cavern_bottom_rpg_node" );
	r = MagicBullet( "rpg",  node.origin, level.player.origin - (0,0,768));
	a = Missile_CreateAttractorEnt( level.player, 1200, 2048 );
	wait( 5 );
	Missile_DeleteAttractor( a );
	
	battlechatter_on( "allies" );
}

cavern_bottom_fight_two_setup()
{
}

cavern_bottom_breach_setup()
{
	flag_wait( "price_bang_on_door" );
	wait( 0.5 );
	array_thread( get_heroes(), ::disable_cqbwalk );
	
	trigger_wait_targetname( "cavern_bottom_player_upstairs" );
	
	autosave_if_safe( "before_bottom_breach" );
	
	level.price enable_sprint();
	node = get_target_ent( "price_bottom_breach_node" );
	thread plant_charges( node, level.price );
		
	guys = [ level.sandman, level.truck, level.grinch ];
	nodes = getstructarray( "bottom_breach_plant_nodes", "targetname" );
	
	thread bottom_breach_dialogue();
	wait( 3 );
	level.price disable_sprint();
	foreach ( g in guys )
	{
		wait( 1 );
		nodes = SortByDistance( nodes, g.origin );
		n = nodes[ 0 ];
		thread plant_charges( n, g );
		nodes = array_remove( nodes, n );
	}
	
	floor_breach_setup();
	
	thread cavern_pres_breach();
	thread cavern_post_pres_breach();
}

bottom_breach_dialogue()
{
	level endon( "breach_explosion" );
	level.price waittill( "starting_anim" );
	wait( 7 );
	level.sandman dialogue_queue( "rescue_snd_stackup2" );
}

#using_animtree( "script_model" );

plant_charges( node, guy )
{
	level endon( "breach_explosion" );
	guy disable_ai_color();
	guy.charge = guy spawn_tag_origin();
	guy.charge Hide();
	node thread anim_generic_reach_and_animate( guy, node.animation );
	guy waittill( "starting_anim" );
	guy.charge setModel( "mil_semtex_belt" );
	guy.charge.animname = "semtex";
	guy.charge useAnimTree( #animtree );
	node thread anim_single_solo( guy.charge, node.animation );
	node waittill( node.animation );
	nodes = GetNodesInRadiusSorted( guy.origin, 96, 0, 32 );
	guy.a.pose = "crouch";
	guy setGoalNode( nodes[0] );
}

cavern_bottom_pres_defend_setup()
{
	flag_wait( "start_bottom_defend" );
	
	exploder( "bridge_break" );
	disable_trigger_with_noteworthy( "cavern_vision_trigger" );
	
	battlechatter_on( "allies" );
	enable_defend_triggers();
	
	thread cavern_defend_wave_1();
	thread cavern_defend_wave_2();
	thread cavern_defend_dialogue();
	thread cavern_heli_arrives();
	thread cavern_defend_bumrush();
	thread cavern_defend_stay_close();
	thread player_damage_trigger();
}

cavern_bottom_pres_heli_setup()
{
	flag_wait( "cavern_run_to_heli" );
		
	array_thread( get_heroes(), ::disable_BulletWhizbyReaction );
	array_thread( get_heroes(), ::set_baseaccuracy, 6 );
	array_thread( get_heroes(), ::disable_cqbwalk );
	
	enable_heli_run_triggers();
	wait( 0.1 );
	activate_trigger_with_noteworthy( "cavern_run_friendlies_lead" );
	thread maps\_spawner::flood_spawner_scripted( getentarray( "cavern_run_chaser_2", "targetname" ) );
	
	thread kill_rescue_heli();
	thread bottom_player_shellshock();
	thread begin_player_shellshock();
	thread cavern_helicopter_scene();
}

cavern_heli_fly_out_setup()
{
	flag_wait( "cavern_player_gets_on_heli" );
	thread heli_leave_dialogue();
	thread pipes_fall();
	flag_wait( "start_delta_last_stand" );
	level.player delayCall( 0, ::FadeOutShellShock );
	battlechatter_off( "allies" );
	
	level.sandman disable_ai_color();
	level.sandman disable_bulletwhizbyreaction();
	level.sandman set_ignoreSuppression( true );
	level.sandman set_ignoreall( true );

	// time to go
	heroes = get_heroes();
	heroes = array_remove( heroes, level.price );
	array_thread( heroes, ::disable_pain );
	array_thread( heroes, ::disable_bulletwhizbyreaction );
	array_thread( heroes, ::set_baseaccuracy, 200 );
	array_thread( heroes, ::enable_cqbwalk );
	array_thread( heroes, ::set_force_color, "o" );
	level.truck set_force_color( "y" );
	activate_trigger_with_noteworthy( "flyout_delta_pushup" );
	
	node = get_target_ent( "delta_ending_last_stand" );
	
	level.grinch forceUseWeapon( "deserteagle", "sidearm" );
	level.sandman forceUseWeapon( "deserteagle", "sidearm" );
	level.sandman animscripts\shared::placeWeaponOn( level.sandman.weapon, "left" );
	
	node thread anim_single( [ level.sandman, level.grinch, level.truck ], "ending_last_stand" );
	
	flag_wait( "cavern_player_in_heli" );
	level.player DisableSlowAim();
	level.rescue_heli godon();
	level.rescue_heli SetTurningAbility( 1 );
	level.rescue_heli setHoverParams( 128, 20, 20 );
	level.rescue_heli Vehicle_SetSpeedImmediate( 1, 30, 60 );
	level.rescue_heli vehicle_paths( get_target_ent( "cavern_heli_leave" ) );
	wait( 3 );
	thread Magic_rpg( "heli_near_miss_1", "rpg_dirt_impact" );
	delayThread( 0.8, ::Magic_rpg, "heli_near_miss_2", "rpg_dirt_impact" );
	delayThread( 1.8, ::Magic_rpg, "heli_near_miss_3" );
	delayThread( 2.8, ::Magic_rpg, "heli_near_miss_4" );
	
	level.player notify( "stop_breathing" );
	thread fade_in( 2 );
	level.player setBlurForPlayer( 0, 3 );
	wait( 0.4 );
	
	level.rescue_heli setHoverParams( 0, 0, 0 );
	dummy = level.rescue_heli vehicle_to_dummy();
	PlayFXOnTag( getfx( "lights_strobe_red_dist_max" ), dummy, "tag_light_cargo01" );
	dummy thread play_loop_sound_on_entity( "scn_missile_warning" );
	
	dummy.animname = "blackhawk";
	dummynode = get_rescue_heli_node();
	dummynode linkTo( dummy, "tag_ground" );
//	put_player_on_heli( dummy );
	level.player disableWeapons();
	dummy thread anim_single_solo( dummy, "dodge" );
	Earthquake( 0.3, 4, level.player.origin, 1024 );
	wait( 2 );
	guys = array_spawn_targetname( "cavern_end_drone_flood" );
	delayThread( 0, ::array_thread, guys, ::send_notify, "move" );
	delayThread( 2.5, ::exploder, 200 );
	delayThread( 2.5, ::exploder, 199 );
	ground_ref_ent = spawn( "script_origin", (0,0,0) );
	level.player PlayerSetGroundReferenceEnt( ground_ref_ent );
	ground_ref_ent rotateTo( (20,0,0), 2 );
	wait( 2 );
//	ground_ref_ent rotateTo( (0,0,0), 4 );
	StopFXOnTag( getfx( "lights_strobe_red_dist_max" ), dummy, "tag_light_cargo01" );
	dummy stop_loop_sound_on_entity( "scn_missile_warning" );
	level.player delayCall( 2, ::enableWeapons );
	
	dummy waittill( "dodge" );
	
	org = dummy getTagOrigin( "origin_animate_jnt" );
	ang = dummy getTagAngles( "origin_animate_jnt" );
	level.rescue_heli Vehicle_teleport( org, ang );
	wait( 0.05 );
	level.rescue_heli dummy_to_vehicle();
	dummynode linkTo( level.rescue_heli, "tag_ground" );	
//	put_player_on_heli( level.rescue_heli );
	wait( 1.5 );
	repulsor = Missile_CreateRepulsorEnt( level.rescue_heli, 3000, 5000 );
	level.rescue_heli setHoverParams( 128, 20, 20 );
	wait( 0.1 );
	level.rescue_heli SetTurningAbility( 0.2 );
	level.rescue_heli thread vehicle_paths( get_target_ent( "cavern_heli_fly_out" ) );
	level.rescue_heli Vehicle_SetSpeedImmediate( 15, 5, 60 );
	a = getentarray( "cavern_bottom_barriers", "targetname" );
	array_call( a, ::delete );
	array_spawn_targetname( "cavern_end_drone_flood_3" );
	array_spawn_targetname( "cavern_run_chaser_3" );
	level.rescue_heli SetYawSpeedByName( "fast" );
	delaythread( 0.2, ::heli_falling_rocks );
	delaythread( 0.2, ::heli_spark_blast );
	delaythread( 3.2, ::heli_rock_blast );
	delaythread( 6.2, ::heli_rock_blast );
	wait( 2 );
	array_spawn_targetname( "prez_heli_ambush" );
	array_spawn_targetname( "cavern_end_drone_flood_2" );
	exploder( 201 );
	level.rescue_heli Vehicle_SetSpeedImmediate( 15, 5, 60 );
	low_earthquake_intensify();
	delaythread( 2, ::exploder, 202 );
	level.player delaythread( 5, ::vision_set_fog_changes, "mine_exterior", 4 );
	flag_wait( "cavern_restart_snow" );
	exploder( "heli_exit_final" );
	spawn_vehicles_from_targetname_and_drive( "heli_flyout_lb1" );
	level notify( "stop_earthquakes" );
	level.snow_offset = ( 0, 0, 0 );
	level.snow_delay = 0.2;
	level.snow_effect = getfx( "snow_flurry" );
	thread maps\rescue_2_code::snow();
	delayThread( 1.7, ::exploder, 500 );
	
	Objective_State( obj( "escape" ), "done" );
	
	news = getDvarInt( "newscast_slow", 0 );
	fadetime = 8;
	array_thread( [level.sandman, level.grinch, level.truck], ::stop_magic_bullet_shield );	
	if ( news )
	{
		thread newscast_slow();
	}
	wait( 1.5 );
	array_call( [level.sandman, level.grinch, level.truck], ::delete );
	level.player AllowFire( false );
	level.player thread vision_set_fog_changes( "rescue_2_sunblind", fadetime );
	wait( 3.5 );
	overlay = create_client_overlay( "white", 0, level.player );
	overlay.sort = -1;
	overlay.foreground = false;
	overlay FadeOverTime( 1 );
	overlay.alpha = 1;
	wait( 2 );
	if ( !news )
	{
		thread newscast_fast();
	}
	//end
//	flag_wait( "the_end" );
//	wait( 4 );
}

// ----------------------------------------------EVENTS----------------------------------------------------------


newscast_slow()
{
	delaythread( 0, ::player_lerp_eq );
	wait( 1.5 );
	setTimeScale( 0.2 );
	wait( 1 );
	radio_dialogue( "rescue_nws_gatheredtoday" );
	level.rescue_heli Vehicle_TurnEngineOff();
	wait( 0.2 );
	radio_dialogue( "rescue_nws_reportsconfirm" );
	wait( 0.5 );
	radio_dialogue( "rescue_nws_othernews" );
	wait( 0.5 );
	nextmission();
}

newscast_fast()
{
	delaythread( 0, ::player_lerp_eq );
	radio_dialogue( "rescue_nws_gatheredtoday" );
//	level.rescue_heli Vehicle_TurnEngineOff();
	wait( 0.4 );
	radio_dialogue( "rescue_nws_reportsconfirm" );
	wait( 1 );
	radio_dialogue( "rescue_nws_othernews" );
	wait( 1 );
	nextmission();
}

heli_falling_rocks()
{
	level endon( "cavern_restart_snow" );

	while( 1 )
	{
		fwd = AnglesToRight( level.rescue_heli.angles ) * (-1);
		thread play_sound_in_space( "scn_prague_tank_alley_exp", level.player.origin + (0,0,256) );
		PlayFX( getfx( "falling_fire_debris_rescue" ), level.rescue_heli.origin + ( fwd * 400 ) + ( 0, 0, 512 ) );
		PlayFX( getfx( "ceiling_rock_collapse_big_spread" ), level.rescue_heli.origin + ( fwd * 400 ) + ( 128, 128, 512 ), (0,0,-1) );
		PlayFX( getfx( "ceiling_rock_collapse_big_spread" ), level.rescue_heli.origin + ( fwd * 400 ) + ( -128, -128, 512 ), (0,0,-1) );
		wait( 1 );
	}
}

heli_spark_blast()
{
	level endon( "cavern_restart_snow" );
	
	while( 1 )
	{
		fwd = AnglesToRight( level.rescue_heli.angles ) * (-1);
		org = level.rescue_heli.origin + (fwd*200);
		rgt = AnglesToForward( level.rescue_heli.angles );
		
		org1 = org + rgt*150;
		org2 = org - rgt*150;
		
		PlayFX( getfx( "cave_mouth_wall_spark_blast_rescue" ), org1, -1*rgt );
		wait( 0.1 );
		PlayFX( getfx( "cave_mouth_wall_spark_blast_rescue" ), org2, rgt );
		wait( 3 );
	}
}

heli_rock_blast()
{
	fwd = AnglesToRight( level.rescue_heli.angles ) * (-1);
	org = level.rescue_heli.origin + (fwd*200);
	rgt = AnglesToForward( level.rescue_heli.angles );
	
	org1 = org + rgt*150;
	org2 = org - rgt*150;
	
	PlayFX( getfx( "ambient_debris_blasts_rescue" ), org1, -1*rgt );
}

bottom_fight_dialogue()
{
	level.grinch thread dialogue_queue( "rescue_rno_theretheyare" );
	level.truck delayThread( 1.3, ::dialogue_queue, "rescue_rno_thereitis" );
	
	trigger_wait_targetname( "bottom_fight_approach" );
	
	autosave_if_safe( "cavern_bottom" );
	
	flag_wait( "player_can_see_cavern_door" );
	wait( 2 );
	level.truck thread dialogue_queue( "rescue_trk_blastdoors" );
}

cavern_bottom_clear()
{
	level endon( "cavern_bottom_search" );
	volume_waittill_no_axis( "bottom_fight_volume" );
	level.grinch dialogue_queue( "rescue_rno_clear2" );
	flag_set( "cavern_bottom_search" );
}

bang_on_door()
{
	flag_wait( "cavern_bottom_friendlies_goto_door" );
	array_thread( get_heroes(), ::set_baseaccuracy, 999 );
	thread cavern_bottom_clear();
	flag_clear( "start_base_alarm" );	
	flag_wait( "cavern_bottom_search" );
	
	autosave_if_safe( "cavern_search" );
	
	node = get_Target_ent( "price_bang_door" );
	level.price.ignoreAll = true;
	level.price enable_sprint();
	level.truck delaythread( 0.5, ::dialogue_queue, "rescue_trk_throughdoor" );
	
	node anim_generic_reach( level.price, "rescue_blocked_door" );
	node thread anim_generic( level.price, "rescue_blocked_door" );
	array_thread( get_heroes(), ::disable_ai_color );
	wait( 0.5 );
	level.price enable_ai_color();
	wait( 0.5 );
	activate_trigger_with_noteworthy( "cavern_bottom_breach_stack" );
	level.price dialogue_queue( "rescue_pri_cantbreak" );
	level.price disable_sprint();
	level.price.ignoreAll = false;
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	level.price PushPlayer( true );
	level.grinch dialogue_queue( "rescue_rno_brightideas" );
	level.price dialogue_queue( "rescue_pri_breachuptop" );
	
	objective_onentity( obj( "rescue_prez" ), level.price );
	
	delayThread( 0.5, ::array_thread, get_heroes(), ::enable_ai_color );
	activate_trigger_with_noteworthy( "cavern_bottom_breach_stack" );

	flag_set( "price_bang_on_door" );
	
	flag_wait( "start_bottom_defend" );
	setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
	array_thread( get_heroes(), ::set_baseaccuracy, 0.5 );
}

floor_breach_setup()
{	
	trigger = get_Target_ent( "cavern_president_breach_player_trigger" );
	
	trigger trigger_on();
	objective_position( obj( "rescue_prez" ), level.floor_breach_charge.origin );
	objective_setpointertextoverride( obj( "rescue_prez" ), &"SCRIPT_WAYPOINT_BREACH" );
	level.floor_breach_charge.o_model Show();
	level.floor_breach_charge Hide();
}

chase_timer()
{
	flag_wait( "start_chase" );
	countdown( 60, "start_president_chase", 40 );
	countdown( 60, "start_cavern_rappel", 25 );
	countdown( 30, "player_mount_rappel", 6, "rescue_snd_stopwasting" );
	countdown( 90, "start_bottom_fight", 50 );
	countdown( 90, "player_can_see_cavern_door", 40 );
	countdown( 90, "cavern_bottom_friendlies_goto_door", 40 );
	countdown( 25, "cavern_bottom_search", 0 );
	countdown( 45, "bottom_breach_started", 25 );
}

countdown( time, endon_flag, nagtime, special_nag )
{
	if ( flag( endon_flag ) )
		return;
		
	level endon( endon_flag );
	childthread chase_nags( nagtime, special_nag );
	flag_set( "lots_of_time" );
	wait( time/2 );
	flag_clear( "lots_of_time" );
	wait( time/2 );
	quote = &"RESCUE_2_PRESIDENT_GOT_AWAY";
	SetDvar( "ui_deadquote", quote );
	missionFailedWrapper();
}

chase_nags( time, special_nag )
{
	wait( time );
		
	while( 1 )
	{
		if ( isdefined( special_nag ) )
		{
			wait( 9 );
			radio_dialogue( special_nag );
		}
		wait( 9 );
		level.sandman dialogue_queue( "rescue_snd_thisway" );
		wait( 9 );
		level.sandman dialogue_queue( "rescue_snd_losinghim" );
	}
}

president_and_crew_escape()
{
	flag_wait( "start_president_chase" );
	
	level.crew_in_elevator = 0;
	
	crew = array_spawn_targetname( "president_crew" );
	array_thread( crew, ::prez_crew_think );
	
	flag_wait( "cavehole_reveal" );
	
	while ( level.crew_in_elevator < crew.size )
		wait( 0.05 );
	
	flag_set( "cavern_elevator_going_down_with_prez" );
	
	level notify( "close_cavern_elevator" );
	wait( 0.6 );
	level.cavern_elevator moveZ( -4000, 15, 5 );
	level.cavern_elevator waittill( "movedone" );
	array_call( crew, ::delete );
	level.crew_in_elevator = undefined;
	if ( !flag( "start_cavern_rappel" ) )
	{
		objective_onentity( obj( "rescue_prez" ), level.price );
		objective_setpointertextoverride( obj( "rescue_prez" ), "" );
	}
}

president_and_crew_escape_bottom()
{
//	flag_wait( "start_bottom_pres" );
	flag_wait( "player_starts_rappel" );
	org = get_target_ent( "president_objective_node" );
	org thread player_slowdown_trigger();
	pres = undefined;
	crew = array_spawn_targetname( "president_crew_bottom" );
	foreach ( guy in crew )
	{
		if ( issubstr( guy.model, "president" ) )
		{
			pres = guy;
			objective_onentity( obj( "rescue_prez" ), guy );
			objective_setpointertextoverride( obj( "rescue_prez" ), &"RESCUE_2_ICON_RESCUE" );
			
		}
	}
	
	pres waittill( "death" );
	objective_position( obj( "rescue_prez" ), org.origin );
	objective_setpointertextoverride( obj( "rescue_prez" ), "" );
	
	flag_wait( "player_can_see_cavern_door" );
	
	door_l = get_target_ent( "cavern_big_door_l" );
	link = door_l get_linked_ent();
	link linkTo( door_l );
	door_r = get_target_ent( "cavern_big_door_r" );
	link = door_r get_linked_ent();
	link linkTo( door_r );
	
	door_l rotateYaw( 90, 9, 0, 1 );
	door_r rotateYaw( -90, 9, 0, 1 );
	
	wait( 4 );
	org notify( "doors_closed" );
	wait( 7 );
	light = getentarray( "redlight", "targetname" );
	array_call( light, ::SetLightIntensity, 0 );
}

player_slowdown_trigger()
{
	self endon( "doors_closed" );
	trace = BulletTrace( self.origin, self.origin - ( 0, 0, 256 ), false );
	self.trigger = Spawn( "trigger_radius", trace[ "position" ], 0, 700, 128 );
	self.trigger waittill( "trigger" );
	
	fwd = AnglesToForward( level.player.angles );
	level.player DoDamage( 60, level.player.origin + fwd );
	wait( 0.3 );
	fwd = AnglesToForward( level.player.angles );
	maps\_fx::GrenadeExplosionfx( level.player.origin + (fwd*128) );
	wait( 0.3 );
	maps\_fx::GrenadeExplosionfx( level.player.origin + (fwd*128) );
	level.player setStance( "prone" );
	level.player ShellShock( "rescue_chopper_drag", 5 );
}

prez_crew_think()
{
	if ( issubstr( self.model, "president" ) )
	{
		objective_onentity( obj( "rescue_prez" ), self );
		objective_setpointertextoverride( obj( "rescue_prez" ), &"RESCUE_2_ICON_RESCUE" );
		
	}
	self NotSolid();
	self waittill( "goal" );
	level.crew_in_elevator += 1;
	self linkTo( level.cavern_elevator );
}

kick_upper_door()
{
//	flag_wait( "cavern_kick_upper_door" );
	trigger_wait( "cavern_moving_to_rappel", "script_noteworthy" );
	
	array_thread( get_heroes(), ::set_baseaccuracy, 999 );
	
	door = get_target_ent( "cavern_kick_upper_door" );
	node = get_target_ent( "cavern_kick_upper_door_node" );
	
	level.grinch disable_ai_color();
	node anim_generic_reach( level.grinch, "doorkick_2_cqbrun" );
	door thread kick_door_open_reversehinge( undefined, 0.5 );
	node anim_generic_gravity( level.grinch, "doorkick_2_cqbrun" );
	level.grinch enable_ai_color();
	
	flag_wait( "start_bottom_fight" );
	
	array_thread( get_heroes(), ::set_baseaccuracy, 0.5 );
}

helicopter_crash_into_bridge()
{
	blocker = get_target_Ent( "bridge_blocker" );
	blocker NotSolid();
	blocker Connectpaths();
	chopper = get_target_ent( "heli_crash_heli" );
	
	flag_wait( "cavern_elevator_going_down_with_prez" );

	node = get_target_ent( "chopper_crash_node" );
	ent = spawn_tag_origin();
	ent.origin = node.origin;
	ent waittill_player_lookat( 0.6, 4, true, 8 );
	ent delete();
	
	// random exlposions
	exploder( 100 );
	
	mb_node = get_target_ent( "heli_crash_rpg_node" );
	mb_node2 = mb_node get_target_ent();
	MagicBullet( "rpg", mb_node.origin + ( RandomFloatRange(0,200),RandomFloatRange(0,200),RandomFloatRange(0,200) ), mb_node2.origin + ( RandomFloatRange(0,200),RandomFloatRange(0,200),RandomFloatRange(0,200) ) );
	wait( 0.3 );
	MagicBullet( "rpg", mb_node.origin + ( RandomFloatRange(0,200),RandomFloatRange(0,200),RandomFloatRange(0,200) ), mb_node2.origin + ( RandomFloatRange(0,200),RandomFloatRange(0,200),RandomFloatRange(0,200) ) );
	wait( 0.4 );
	MagicBullet( "rpg", mb_node.origin + ( RandomFloatRange(0,200),RandomFloatRange(0,200),RandomFloatRange(0,200) ), mb_node2.origin + ( RandomFloatRange(0,200),RandomFloatRange(0,200),RandomFloatRange(0,200) ) );
	wait( 0.4 );
	
	activate_trigger_with_targetname( "spawn_cavern_3" );
		
	chopper Show();
	chopper PlayLoopSound( "hind_helicopter_dying_loop" );
	chopper thread crazy_rotate();
	chopper moveTo( node.origin, 1.5, 1 );
	chopper waittill( "movedone" );
	PlayFX( getfx( "heli_crash" ), node.origin );
	exploder( "bridge_break" );
	thread play_sound_in_space( "hind_helicopter_crash_dist", chopper.origin );
	blocker Solid();
	blocker Disconnectpaths();
	ai = getaiarray( "axis" );
	foreach( a in ai )
	{
		if ( Distance( a.origin, node.origin ) < 512 )
		{
			a.deathanim = random( level.explosion_deaths );
			a kill();
		}
	}
	
	Earthquake( 0.6, 0.5, node.origin, 10000 );
	node = node get_target_ent();
	chopper moveTo( node.origin, 0.5, 0 );
	chopper waittill( "movedone" );
	chopper StopLoopSound( "hind_helicopter_dying_loop" );
	thread play_sound_in_space( "hind_helicopter_crash_close", chopper.origin );
	Earthquake( 0.9, 0.8, node.origin, 10000 );
	PlayFX( getfx( "heli_explosion" ), node.origin );
	chopper delete();
	autosave_if_safe( "chopper_crash" );
	wait( 2 );
	corpse = GetCorpseArray();
	foreach ( c in corpse )
	{
		if ( Distance2d( c.origin, node.origin ) < 1024 )
		{
			c delete();
		}
	}
}

cavern_top_fight_dialogue()
{
	flag_wait( "cavehole_reveal" );
	battlechatter_off( "allies" );
	level.price dialogue_queue( "rescue_pri_onthecatwalk" );
	wait( 0.2 );
	level.grinch dialogue_queue( "rescue_rno_thereheis" );
	wait( 0.2 );
	level.price dialogue_queue( "rescue_pri_nottoolate" );

	battlechatter_on( "allies" );
}

stop_door_open()
{
	self moveTo( self.origin, 0.05 );
}

start_elevator_sparks()
{
	level endon( "stop_elevator_sparks" );
	
	orgs = getstructarray_delete( "cavern_elevator_spark", "targetname" );
	while ( 1 )
	{
		org = random( orgs );
		PlayFX( getfx( "electrical_transformer_sparks_a" ), org.origin );
		thread play_sound_in_space( "scn_spark_explosion", org.origin );
		wait( RandomFloatRange( 0.1, 0.6 ) );
	}
}

rappel_down_cavern()
{	
	level.rappel_ready = 0;
	thread cavern_player_rappel();
	heroes = get_heroes();
	nodes = getstructarray_delete( "cavern_rappel_nodes", "targetname" );
	nodes = SortbyDistance( nodes, level.cavern_elevator.origin );
	level.rappel_anims[ "left" ] = [ "rappel", "rappel_2" ];
	level.rappel_anims[ "right" ] = [ "rappel", "rappel_2" ];
	
	array_thread( nodes, ::rappel_node_setup );
	
	delay = 0;
	heroes = SortByDistance( heroes, nodes[0].origin );
	for ( i=0; i<heroes.size; i++ )
	{
		heroes[i] thread cavern_rappel_down( nodes[ nodes.size - i - 1 ], delay );
		delay += 0.5;
	}
}

rappel_node_setup()
{
	self.rope = spawn_anim_model( "rappelrope" );
	self thread anim_first_frame_solo( self.rope, "rappel_" + self.script_noteworthy + "_mount" );
	self.rope Hide();
}

cavern_player_rappel()
{
	node = get_target_ent( "player_rappel_node" );
	
	obj_rope = get_target_ent( "player_rappel_bar" ); // it's a bar now
	obj_rope Show();
	bar = get_target_ent( "player_rappel_bar_normal" ); // it's a bar now
	bar Hide();
	n = level.player_rope_trigger get_target_ent();
	objective_setpointertextoverride( obj( "rescue_prez" ), "" );
	objective_position( obj( "rescue_prez" ), n.origin );
	
	level.player_rope_trigger trigger_on();
	level.player_rope_trigger SetHintString( &"PLATFORM_HOLD_TO_USE" );
	level.player_rope_trigger waittill( "trigger" );
	flag_set( "player_mount_rappel" );
	objective_onentity( obj( "rescue_prez" ), level.price );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player SetStance( "stand" );
	level.player_rope_trigger delete();
	
	level.player DisableWeapons();
	obj_rope delete();
	bar Show();
	
	rope = spawn_anim_model( "rope" );
	carabiner = spawn_anim_model( "carabiner" );
	legs = spawn_anim_model( "player_legs" );
	rope Show();
	rig = get_player_rig();
	group = [ rig, rope, carabiner, legs ];
	level.player PlayerLinkToBlend( rig, "tag_player", 0.3 );
	heroes = get_heroes();
	foreach ( h in heroes )
	{
		h delayCall( 1, ::Hide );
		h delayCall( 1.5, ::Show );
		h delayThread( 1 + RandomFloatRange( 0,0.5 ), ::send_notify, "start_rappel" );
	}
	
	node anim_single( group, "rappel_1" );

	level.player PlayerLinkToDelta( rig, "tag_player", 1, 20, 20, 40, 40 );
	
	ai = getaiarray( "axis" );
	array_call( ai, ::delete );
	
	flag_set( "player_starts_rappel" );
	
	node script_delay();
	delaythread( 3, maps\_utility::set_ambient, "rescue_2_cavern", 4 );	
	node thread anim_single( group, "rappel_2" );
	
	while ( rig getAnimTime( rig getanim( "rappel_2" ) ) < 0.865 )
		wait( 0.05 );
		
	level.player unlink();
	level.player EnableWeapons();
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	
	rig delete();
	legs delete();
	
	group = array_removeUndefined( group );

	autosave_if_safe( "cavern_bottom" );
	
	wait( 10 );
	
	foreach ( g in group )
		g delete();
}

cavern_rappel_down( node, delay )
{
	self endon( "start_rappel" );
	self thread rappel( node );
	wait( delay );
	anime = "rappel_" + node.script_noteworthy + "_mount";
	node anim_generic_reach( self, anime );
	node.rope delayCall( 1.5, ::Show );
	node thread anim_single_solo( node.rope, anime );
	node anim_generic( self, anime );
	self notify( "start_rappel" );
}

rappel( node )
{
	self waittill( "start_rappel" );
	node.rope Show();
	node thread anim_loop_solo( node.rope, "rappel_idle_" + node.script_noteworthy );
	node thread anim_generic_loop( self, "rappel_idle_" + node.script_noteworthy );	
	level.rappel_ready += 1;
	flag_wait( "player_starts_rappel" );
	node script_delay();
	node notify( "stop_first_frame" );
	node notify( "stop_loop" );
	node thread anim_single_solo( node.rope, "rappel" );
	rappelanim = level.rappel_anims[ node.script_noteworthy ][ 0 ];
	level.rappel_anims[ node.script_noteworthy ] = array_remove( level.rappel_anims[ node.script_noteworthy ], rappelanim );
	self anim_generic( self, rappelanim );
	
	if ( node.script_noteworthy == "right" )
		self anim_generic( self, "readystand_trans_2_run_2" );
	else
		self anim_generic_run( self, "readystand_trans_2_run_8" );
	
	wait( 20 );
	
	node.rope delete(); 
}

cavern_pres_breach()
{	
	level.slomobreachduration = 8.5;
	level.breachignoreEnemy_count = false;
	
	trigger = get_target_ent( "cavern_president_breach_player_trigger" );
	trigger setHintString( &"SCRIPT_PLATFORM_BREACH_ACTIVATE" );
	trigger waittill( "trigger" );
	
	level.floor_breach_charge.o_model delete();
	objective_position( obj( "rescue_prez" ), (0,0,0) );
	objective_setpointertextoverride( obj( "rescue_prez" ), "" );
	
	flag_set( "bottom_breach_started" );
	
	level.player disableWeapons();
	
	array_thread( get_heroes(), ::set_ignoreall, true );
	
	trigger trigger_off();

	node = level.floor_breach_charge spawn_tag_origin();

	mover = get_player_rig();
	mover Hide();
	node thread anim_first_frame_solo( mover, "floor_breach" );

	level notify( "breach_explosion" );

	heroes = get_heroes();
	foreach ( h in heroes )
	{
		if ( isdefined( h.charge ) )
			h.charge delete();
	}

	array_call( get_heroes(), ::stopanimscripted );
	
	battlechatter_off( "allies" );	
	
	level.slowmo_breach_start_delay = 0.33;
	breach_sound_delay = 0.5;
	
	level.player AllowStand( true );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player setStance( "stand" );
	level.player PlayerLinkToBlend( mover, "tag_player", 0.5 );
	mover delayCall( 0.5, ::show );
	level.floor_breach_charge delayCall( 0.5, ::show );
	
	node anim_single( [ level.floor_breach_charge, mover ], "floor_breach" );
	mover Hide();
	
	wait( 0.2 );
	flag_set( "no_mercy" );
	array_spawn_function_targetname( "president_breach_spawners", ::president_breach_spawners_think );
	array_spawn_targetname( "president_breach_spawners" );

	thread maps\_slowmo_breach::slowmo_begins();
	thread music_stop( 2 );
	
	thread breach_floor_explosion();
	wait( 0.5 );
	// cleaning up old vehicles
	vehicles = getvehiclearray();
	array_call( vehicles, ::delete );	
	level.player delayCall( 0.3, ::enableWeapons );	

	node delete();
	node = get_target_Ent( "cavern_president_breach_player_node" );
	node = node get_target_ent();
	falltime = 1.5;
	
	level.player delayCall( 0.3, ::PlayerLinkToDelta, mover, "tag_player", 1, 30, 30, 30, 30 );
	mover moveTo( (mover.origin[0], mover.origin[1], node.origin[2]), falltime, falltime );
	
	wait( 0.4 );
	level.player AllowStand( true );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	
	mover waittill( "movedone" );
	level.player setStance( "crouch" );
		
	array_thread( [ level.grinch, level.truck ], ::enable_ai_color );
	activate_trigger_with_noteworthy( "cavern_bottom_breach_stack" );
	
	wait( 0.05 );
	
	node = get_target_Ent( "price_breach_teleport" );
	level.price ForceTeleport( node.origin, node.angles );
	level.price setGoalPos( node.origin );
	level.price AllowedStances( "stand" );
	node = get_target_Ent( "sandman_breach_teleport" );
	level.sandman ForceTeleport( node.origin, node.angles );
	level.sandman setGoalPos( node.origin );
	level.sandman AllowedStances( "stand" );
	
	array_thread( get_heroes(), ::set_ignoresuppression, true );
	array_thread( get_heroes(), ::set_ignoreall, false );
	array_thread( get_heroes(), ::disable_pain );

	level.player unlink();
	
	ai = getaiarray( "axis" );
	foreach ( a in ai )
	{
		level.price getenemyinfo( a );
		level.sandman getenemyinfo( a );
	}
	
	volume_waittill_no_axis( "president_breach_volume" );

	array_thread( get_heroes(), ::enable_pain );
	array_thread( get_heroes(), ::set_ignoresuppression, false );
	
	flag_set( "start_bottom_defend" );
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	level.price animscripts\weaponList::RefillClip();
	level.sandman animscripts\weaponList::RefillClip();

	wait( 1 );

	if ( !isAlive( level.president ) )
		return;
	
	level.president endon( "death" );
	
	node = get_target_ent( "president_rescue_node" );
	node.origin = level.president.origin;
	node thread anim_generic_reach_and_animate( level.price, "pres_getup_price" );
	node thread anim_generic_reach_and_animate( level.sandman, "pres_getup_sandman" );
	level.price waittill( "starting_anim" );
	level.president notify( "stop_breach_behavior" );
	level.president.animnode notify( "stop_loop" );
//	level.president set_generic_run_anim( "rescue_pres_run" );
	node thread anim_generic_run( level.president, "pres_getup_president" );
	level.president.a.pose = "stand";
	level.president thread keep_president_in_combat();
}

breach_floor_explosion()
{
	exploder( 250 );
	
	i = 0;
	slab = undefined;
	frontslab = undefined;
	pack = undefined;
//	slab.origin -= (0,0,22);

	wait( 0.1 );
	exploder( "prez_breach" );
	activate_trigger_with_targetname( "floor_exploder" );
	level.floor_breach_charge delete();
	for ( i=0; i<level.slabs.size; i++ )
	{
		if ( isdefined( slab ) ) 
		{
			slab NotSolid();
			slab Delete();
			frontslab Delete();
			pack Delete();
		}
		pack = level.packs[i];
		slab = level.slabs[i];
		frontslab = level.front_slabs[i];
		slab Show();
		frontslab Show();
		if ( i == level.slabs.size-1 )
			pack Delete();
		else
			pack Show();
		wait( 0.2 );
	}
	
	
//	pack delete();
	org = slab.origin;
	dist = 0;
	while ( dist < 2000 )
	{
		dist += 4;
		slab.origin = org - ( 0,0,dist );
		wait ( 0.05 );
	}
}

cavern_post_pres_breach()
{
	flag_wait( "start_bottom_defend" );
	enable_trigger_with_noteworthy( "cavern_breach_exit" );
	
	level.price waittill( "starting_anim" );
	thread cavern_post_pres_breach_2();
	array_call( get_heroes(), ::allowedStances, "stand", "crouch", "prone" );
	radio_dialogue( "rescue_snd_jackpot" );
	thread radio_dialogue( "rescue_hqr_extractionpoint" );
	objective_state( obj( "rescue_prez" ), "done" );
	objective_add( obj( "escape" ), "current", &"RESCUE_2_OBJ_111" );
	objective_onentity( obj( "escape" ), level.president );
	objective_setpointertextoverride( obj( "escape" ), &"RESCUE_2_ICON_PROTECT" );
	level.president set_force_color( "c" );
	level.president thread magic_bullet_shield();
	wait( 0.5 );	
	array_thread( get_heroes(), ::set_ignoresuppression, true );
	array_thread( get_heroes(), ::disable_pain );
	
	level.president dialogue_queue( "rescue_prs_daughter" );
}

cavern_post_pres_breach_2()
{
	wait( 6.25 );
	pres_breach_earthquake();
	
	wait( 0.4 );
	array_call( [ level.price, level.sandman, level.president ], ::pushplayer, true );
	array_thread( get_heroes(), ::enable_ai_color );
	activate_trigger_with_noteworthy( "cavern_breach_exit" );
	trigger = getent( "cavern_breach_exit", "script_noteworthy" );
	trigger trigger_off();
	
	music_play( "rescue_2_defend" );		
	wait( 0.1 );
	level.price dialogue_queue( "rescue_pri_movemove" );
	
	battlechatter_off( "allies" );
	setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
	flag_set( "cavern_defend_wave_1" );
	autosave_if_safe( "cavern_defend" );
	radio_dialogue( "rescue_snd_bringbirdtous" );
	wait( 0.2 );
	radio_dialogue( "rescue_hqr_twobirds" );
	wait( 1 );
	level.sandman dialogue_queue( "rescue_snd_holdposition" );
	wait( 1 );
	level.truck dialogue_queue( "rescue_trk_badguys" );
	battlechatter_on( "allies" );
}

pres_breach_earthquake()
{
	thread play_sound_in_space( "scn_prague_tank_alley_exp", level.player.origin + (0,0,96) );
	Earthquake( 0.5, .65, level.player.origin, 1024 );
	org = spawn_tag_origin();
	level.player PlayerSetGroundReferenceEnt( org );
	org rotateTo( ( -8, 0, -6 ), 0.15, 0, 0.15 );
	org waittill( "rotatedone" );
	org rotateTo( ( 0, 0, 0 ), 0.5, 0.5, 0 );
	org waittill( "rotatedone" );
	level.player PlayerSetGroundReferenceEnt( undefined );
	waittillframeend;
	org delete();
	
	level.truck thread dialogue_queue( "rescue_trk_whatthe" );
	wait( 0.75 );
	
	Earthquake( 0.8, 1.5, level.player.origin, 1024 );
//	level.sandman delayThread( 0.1, ::anim_generic, level.sandman, "hijack_generic_stumble_stand1" );
//	level.price delayThread( 0.2, ::anim_generic, level.price, "hijack_generic_stumble_stand2" );
	
	thread player_stumble();
	
	n = spawnstruct();
	node = get_Target_ent( "president_rescue_node" );
	n.origin = node.origin + (0,0,256);
	n thread node_explode();
	
	thread play_sound_in_space( "scn_prague_tank_alley_exp", level.player.origin + (0,0,32) );
	thread cavern_bottom_dust();
	thread low_earthquakes();
	
	lights = getentarray( "prez_cell_light", "targetname" );
	foreach ( l in lights )
	{
		l thread flicker_die();
	}
	
	damage = getstructarray_delete( "prez_breach_shake", "targetname" );
	foreach ( d in damage )
	{
		delayThread( RandomFloatRange( 0.4, 1.5 ), ::_Radiusdamage, d.origin, d.radius, 500, 500 );
	}
	
	phys = getstructarray_delete( "prez_breach_physics", "targetname" );
	foreach ( p in phys )
	{
		PhysicsExplosionSphere( p.origin, 64, 32, 5 );
		wait( 0.2 );
	}	
}

player_stumble()
{
	wait( 0.1 );
	level.player disableWeapons();
//	level.player ShellShock( "rescue_chopper_drag", 2 );
//	if ( level.player getStance() == "stand" )
//		level.player setStance( "crouch" );
	org = spawn_tag_origin();
	level.player PlayerSetGroundReferenceEnt( org );
	org rotateTo( ( 13, 0, 6 ), 0.5, 0, 0.5 );
	org waittill( "rotatedone" );
	org rotateTo( ( 0, 0, 0 ), 1, 0.5, 0 );
	org waittill( "rotatedone" );
	level.player PlayerSetGroundReferenceEnt( undefined );
	waittillframeend;
	org delete();
	wait( 0.6 );
	level.player enableWeapons();
}

flicker_die()
{
	thread flickering_light( self, 0.3, 1 );
	wait( RandomFloatRange( 0.1, 1.6 ) );
	self notify( "stop_flicker" );
	self setLightintensity( 0 );
	Radiusdamage( self.origin, 32, 500, 500 );
}

cavern_defend_wave_1()
{
	trigger_wait( "cavern_breach_exit", "script_noteworthy" );
	
	array_spawn_Targetname( "cavern_defend_0" );
	magic_smoke_src = [];
	nodes = getstructarray_delete( "cavern_defend_smoke", "targetname" );
	foreach ( n in nodes )
	{
		n2 = n get_target_ent();
		e = spawn_Tag_origin();
		e.origin = n2.origin;
		magic_smoke_src = array_add( magic_smoke_src, e );
		MagicGrenade( "smoke_grenade_american", n.origin, n2.origin, 1 );
		wait( 0.3 );
	}
	
	wait( 8 );
	
	maps\_spawner::flood_spawner_scripted( getentarray( "cavern_defend_1", "targetname" ) );
	
	delayThread( 10, ::array_thread, magic_smoke_src, ::magic_smoke_individual, "kill_smoke", 40 );
	
	flag_wait( "cavern_player_is_defending" );
	
	wait( 20 );
	
	flag_set( "cavern_defend_wave_2" );
}

cavern_defend_wave_2()
{
	level endon( "cavern_rescue_arrives" );
	
	flag_wait( "cavern_defend_wave_2" );
	
	lr = [ "l", "r" ];
	
	while( 1 )
	{
		array_spawn_targetname( "cavern_defend_l" );
		wait( 5 );
		array_spawn_targetname( "cavern_defend_r" );
		wait( 13 );
	}
}

cavern_defend_dialogue()
{
	flag_wait( "cavern_defend_wave_2" );
	battlechatter_off( "allies" );
	wait( 2 );
	level.grinch dialogue_queue( "rescue_rno_enemiesonflank" );
	wait( 2 );
	radio_dialogue( "rescue_snd_bailusout" );
	wait( 0.2 );
	radio_dialogue( "rescue_hp1_almostthere" );
	battlechatter_on( "allies" );
	
	flag_wait( "cavern_rescue_arrives" );
	wait( 15 );
	battlechatter_off( "allies" );
	radio_dialogue( "rescue_snd_ourride" );
	wait( 0.3 );
	radio_dialogue( "rescue_hp1_getouttahere" );
	wait( 0.3 );
	radio_dialogue( "rescue_snd_soundsgood" );
	
	flag_wait( "cavern_run_to_heli" );
	level.sandman dialogue_queue( "rescue_snd_letsmove2" );
	setsaveddvar( "ai_friendlyFireBlockDuration", 0 );

	autosave_if_safe( "run_to_heli" );
}

cavern_heli_arrives()
{
	flag_wait( "cavern_defend_wave_2" );
	
	ents = getentarray( "broken_bridge", "script_noteworthy" );
	array_call( ents, ::delete );
	
	wait( 8 );	
	flag_set( "cavern_rescue_arrives" );
	level notify( "kill_smoke" );
	wait( 1 );
	cavern_heli_spawn();
}
	
cavern_heli_spawn()
{
	level.rescue_heli = spawn_vehicle_from_targetname_and_drive( "rescue_heli" );
	level.rescue_heli_backup = spawn_vehicle_from_targetname_and_drive( "rescue_heli_backup" );
	
	wait( 0.1 );
	level.rescue_heli chopper_spawn_pilot();
	wait( 0.1 );
	level.rescue_heli_backup chopper_spawn_pilot();
	
	level.rescue_heli_backup waittill( "reached_dynamic_path_end" );
	maps\_spawner::killspawner( 550 );
	flag_set( "cavern_run_to_heli" );

	level.president disable_pain();
	level.president.ignoreme = true;
	delayThread( 4, ::music_stop, 8 );
}

low_earthquake_intensify()
{
	level.low_earthquake_min = 0.3;
	level.low_earthquake_max = 0.4;
	level.low_earthquake_delay_min = 0.5;
	level.low_earthquake_delay_max = 0.9;
	level.low_earthquake_pause_min = 0.1;
	level.low_earthquake_pause_max = 0.2;
}

low_earthquake_tone_down()
{
	level.low_earthquake_min = 0.1;
	level.low_earthquake_max = 0.2;
	level.low_earthquake_delay_min = 0.5;
	level.low_earthquake_delay_max = 0.9;
	level.low_earthquake_pause_min = 0.1;
	level.low_earthquake_pause_max = 0.2;
}

rescue_heli_think()
{
	self MakeEntitySentient( "allies" );
	
	 if ( issubstr( self.classname, "littlebird" ) )
	{
		PlayFXOnTag( getfx( "lights_strobe_red_dist_maxb" ), self, "tag_light_belly" );
	}
	else
	{
		PlayFXOnTag( getfx( "dlight_blue" ), self, "tag_light_cockpit01" );
	}

	self.turret = SpawnTurret( "misc_turret", self getTagOrigin( "tag_turret" ), "heli_minigun_noai" );
	self.turret SetModel( "weapon_minigun" );
	self.turret LinkTo( self, "tag_turret", (0,0,-5), (0,0,180) );
	self.turret.ownerVehicle = self;
	self.turret SetLeftArc( 85 );
	self.turret SetRightArc( 85 );
	self.turret SetBottomArc( 55 );
	self.turret SetTopArc( 85 );
	self.turret SetMode( "manual" );
	self.turret.script_team = "allies";
	self.turret thread maps\_mgturret::burst_fire_unmanned();
	self.turret MakeUnusable();
	self.turret SetTurretTeam( "allies" );
	self.turret SetDefaultDropPitch( 0 );
	self.turret thread track_targets();
	
	self waittill( "death" );
	self.turret delete();
}

track_targets( org )
{
	self endon( "stop_shooting" );
	self.ownerVehicle endon( "death" );
	self endon( "death" );
	self StartFiring();
	while( 1 )
	{
		if ( !isdefined( org ) )
			org = self.origin;
			
		targets = getaiarray( "axis" );
		
		if ( targets.size == 0 )
		{
			self StopFiring();
			wait( 2 );
			self StartFiring();
			org = self.origin;
			continue;
		}
		
		targets = sortbydistance( targets, org );
		
		t = targets[0];
		self setTargetEntity( t );
		if ( !isdefined( self.ownerVehicle.dontfacetarget ) )
			self.ownerVehicle SetLookAtEnt( t );
		t waittill_notify_or_timeout( "death", 5 );
		org = t.origin;
		wait( 0.5 );
	}
}

kill_rescue_heli()
{
	flag_wait( "kill_rescue_heli" );
	
	turret = getent( "cavern_turret", "script_noteworthy" );
	turret thread maps\_dshk_player_rescue::dshk_turret_disable();
	thread player_kill_trigger( "cavern_bottom_player_upstairs" );
	
	music_play( "rescue_2_dark", 5 );
	
	array_spawn_targetname( "prez_heli_ambush" );
	array_spawn_targetname( "prez_heli_ambush_2" );
	node = get_target_ent( "rescue_heli_rpg" );
	
	thread rescue_heli_backup_death();
	level.rescue_heli_backup flag_on_death( "rescue_backup_heli_dead" );
	
	level.rescue_heli.turret notify( "stop_shooting" );
	level.rescue_heli.turret StopFiring();
	level.rescue_heli godon();
	level.rescue_heli Vehicle_SetSpeedImmediate( 15, 60, 60 );
	level.rescue_heli thread vehicle_paths( get_Target_ent( "cavern_heli_breakaway" ) );
	wait( 1 );
	low_earthquake_intensify();
	e = Missile_createRepulsorEnt( level.rescue_heli, 2500, 1024 );
	r = MagicBullet( "rpg", node.origin, level.rescue_heli.origin - (0,0,600) );
	
	level.rescue_heli.turret setAISpread( 0.1 );
	node = get_Target_ent( "heli_target_after_breakaway" );
	level.rescue_heli.turret thread track_targets( node.origin );
	
	flag_wait( "cavern_heli_force_land" );

	level.rescue_heli.dontfacetarget = true;
	level.rescue_heli.turret delaythread( 5, ::send_notify, "stop_shooting" );
	level.rescue_heli.turret delayCall( 6, ::StopFiring );
	level.rescue_heli ClearLookAtEnt();
	level.rescue_heli Vehicle_SetSpeedImmediate( 5, 30, 30 );
	level.rescue_heli setHoverParams( 0, 0, 0 );
	level.rescue_heli SetTurningAbility( 1 );
	level.rescue_heli thread vehicle_paths( get_Target_ent( "cavern_heli_land" ) );

	flag_set( "cavern_heli_landing" );
}

rescue_heli_backup_death()
{
	node = get_target_ent( "rescue_heli_rpg" );
	e = Missile_createAttractorEnt( level.rescue_heli_backup, 9000, 9000 );
	wait( 0.05 );
	r = MagicBullet( "rpg", node.origin, level.rescue_heli_backup.origin );	
	wait( 0.5 );
	thread bottom_ambush_dialogue();
	level.rescue_heli_backup Vehicle_SetSpeedImmediate( 15, 60, 60 );
	level.rescue_heli_backup delaythread( 0.5, ::vehicle_paths, get_Target_ent( "cavern_backup_breakaway" ) );
	wait( 1 );
	Missile_deleteAttractor( e );
	if ( isdefined( r ) )
	{
		r waittill( "death" );
		if ( isdefined( level.rescue_heli_backup ) )
		{
			level.rescue_heli_backup Kill();
		}
	}
}

bottom_ambush_dialogue()
{
	thread radio_dialogue( "rescue_hp2_rpgmove" );
	flag_wait( "rescue_backup_heli_dead" );
	radio_dialogue_overlap( "rescue_lbp_imhit" );
	wait( 0.2 );
	radio_dialogue( "rescue_lbp_goindown" );
}


bottom_player_shellshock()
{
	level.player endon( "death" );
	flag_wait( "rescue_backup_heli_dead" );
	
	wait( 4 );
	
	node = spawnstruct();
	fwd = AnglesToForward( level.player.angles )*75;
	node.origin = level.player.origin + fwd + (0,0,64);
	node delaythread( 0.2, ::node_explode );
	node = spawnstruct();
	fwd = AnglesToForward( level.player.angles )*128;
	node.origin = level.player.origin + fwd + (0,0,64);
	node thread node_explode();
	level.player FreezeControls( true );
	level.player DisableWeapons();
	level.player thread vision_set_fog_changes( "rescue_2_sunblind", 1 );
	wait( 0.5 );
	flag_set( "begin_player_shellshock" );
	wait( 0.1 );
	level.player FreezeControls( false );
	level.player thread vision_set_fog_changes( "rescue2_ending", 0.2 );
}

begin_player_shellshock()
{	
	flag_init( "ending_next_stop" );
	animation_debug = GetDvarInt( "animation_debug", 0 );
	level.player_shock_delta = (0,0,-50);
	
	flag_wait( "begin_player_shellshock" );
	animnode = get_target_ent( "ending_delta_vignette" );
//	animnode = get_target_ent( "player_shellshock_teleport" );
	
	array_thread( get_heroes(), ::kill_nearby_enemies );
	
	battlechatter_off( "allies" );
//	level.player EnableSlowAim();
	array_thread( get_heroes(), ::disable_pain );
	heroes = get_heroes();
	foreach ( h in heroes )
	{
		h.disableDamageShieldPain = true;
	}
	level.president disable_pain();
	level.president.disableDamageShieldPain = true;
	
	level.player.ignoreme = true;
	setSavedDvar( "hud_showStance", "0" );
	setSavedDvar( "compass", "0" );
	SetSavedDvar( "ammoCounterHide", "1" );
	setsaveddvar( "g_friendlyNameDist", 0 );
	SetSavedDvar( "actionSlotsHide", "1" );
	SetSavedDvar( "cg_drawCrosshair", "0" );
	SetSavedDvar( "aim_AutoAimRangeScale", 0 );
	SetSavedDvar( "aim_aimAssistRangeScale", "1" );
	setBlur( 6, 0 );
	level.player DisableWeapons();
	level.player EnableInvulnerability();
	level.player Shellshock( "rescue_chopper_drag", 120 );
	fade_out( 0.1 );

	node = get_target_ent( "player_shellshock_teleport" );
	level.player allowstand( true );
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player setStance( "stand" );
	
	array_thread( getaiarray(), ::set_grenadeammo, 0 );
//	array_call( getaiarray( "axis" ), ::disableaimassist );
	array_thread( get_heroes(), ::disable_ai_color );

	wait( 0.3 );
	level.player setOrigin( node.origin );
	level.player setPlayerAngles( node.angles );
	
	rig = get_player_rig();		
	rig Show();
	
	animnode thread anim_generic_first_frame( rig, "rescue_ending_pres_heli_getin_player" );
	holder = rig spawn_tag_origin();
	holder.origin = rig getTAgOrigin( "tag_player" );
	holder.angles = rig getTAgAngles( "tag_player" );
	holder linkTo( rig, "tag_player", (0,0,0), (0,0,0) );
	
	ground_ref_ent = spawn_tag_origin();
	ground_ref_ent.angles = ( holder.angles[0], 0, -1* holder.angles[2] );
	
	if ( !animation_debug )
	{
		level.player PlayerLinkToDelta( rig, "tag_player", 1, 20, 30, 30, 0 );
		level.player PlayerSetGroundReferenceEnt( ground_ref_ent );
	}
	else
	{
		level.player PlayerLinkToDelta( rig, "tag_player", 1, 0, 0, 0, 0 );
		level.player PlayerSetGroundReferenceEnt( ground_ref_ent );
	}
		
	thread radio_dialogue( "rescue_pri_yurisdown" );
	level.low_earthquake_min = 0.3;
	level.low_earthquake_max = 0.4;
	level.low_earthquake_delay_min = 0.7;
	level.low_earthquake_delay_max = 1.5;
	level.low_earthquake_pause_min = 0.5;
	level.low_earthquake_pause_max = 0.8;

	wait( 1 );
	
	corpse = getCorpseArray();
	array_call( corpse, ::delete );
	
	weapons = getWeaponArray();
	array_call( weapons, ::delete );
	
	flag_set( "cavern_heli_force_land" );
	volume = get_target_ent( "cavern_bottom_back_volume" );
	ai = getaiarray( "axis" );
	foreach ( a in ai )
	{
		if ( a isTouching( volume ) )
			a delete();
	}
	animnode thread anim_generic_first_frame( level.truck, "BH_getin" );
	
	nodes = getnodearray( "cavern_heroes_shellshock_1", "targetname" );
	foreach ( n in nodes )
	{
		if ( n.script_noteworthy == "grinch" )
		{
			level.grinch ForceTeleport( n.origin, n.angles );
			level.grinch setGoalNode( n );
		}
	}
	
	wait( 0.05 );
	
	// tone down shakes
	level.cave_shake_strength_min = 0.2;
	level.cave_shake_strength_max = 0.4;
	level.cave_shake_delay_min = 4;
	level.cave_shake_delay_max = 8;
	low_earthquake_tone_down();
	
	level.truck setGoalPos( level.truck.origin );
	level.truck.goalradius = 8;
	level.truck notify( "stop_first_frame" );	
	// ********** see helicopter landing ****************
	setBlur( 0, 4 );
	fade_in( 3 );
	delaythread( 0.6, ::radio_dialogue, "rescue_hp2_presidenton" );
	thread player_shellshock_breathing();
	setBlur( 5, 3 );
	wait( 1.7 );
	fade_out( 1.5 );
	// ********** heli landed, see pres get in ****************
	level.rescue_heli notify( "newpath" );
	wait( 3 );

	
	level.president.animname = "president";
	
	level.rescue_heli SetYawSpeed( 0, 60, 60, 0 );
	level.rescue_heli Vehicle_setspeedimmediate( 0, 60, 60 );
	dummy = level.rescue_heli vehicle_to_dummy();
	dummy.animname = "blackhawk";
	animnode thread anim_single_solo( dummy, "rescue_ending_pres_heli_getin_blackhawk" );
	
	array_thread( get_heroes(), ::disable_pain );
	dummynode = get_rescue_heli_node();
	animnode thread anim_single( [ level.grinch, level.president ], "BH_getin" );
	animnode thread anim_generic( level.truck, "BH_getin" );
	animnode thread anim_generic( rig, "rescue_ending_pres_heli_getin_player" );
	
	animtime = getAnimLength( getgenericanim( "BH_getin" ) );
	delayThread( animtime*0.66, ::flag_set, "ending_next_stop" ); // president on chopper
	delayThread( animtime*0.8, ::flag_set, "ending_next_stop" ); // argue start
	animtime = getAnimLength( getgenericanim( "rescue_ending_pres_heli_getin_player" ) );
	delayThread( animtime, ::flag_set, "ending_next_stop" );
	
	setBlur( 0, 4 );
	fade_in( 2 );
	
	thread player_shellshock_heartbeat();
	level.grinch delaythread( 1.6, ::dialogue_queue, "rescue_rno_pressecure" );
	level.truck delaythread( 3, ::dialogue_queue, "rescue_trk_igotyou" );
	delaythread( 4, ::music_stop, 3 );
	
	flag_wait( "ending_next_stop" ); 
	flag_clear( "ending_next_stop" ); 
	n = get_target_ent( "cavern_heli_land" );
	n = n get_last_ent_in_chain( "struct" );
	level.rescue_heli dummy_to_vehicle();
	level.rescue_heli Vehicle_Teleport( n.origin, n.angles );
	dummynode thread anim_first_frame_solo( level.president, "BH_anim" );
	level.president linkTo( dummynode, "tag_origin" );
	maps\_spawner::killspawner( 700 );
	activate_trigger_with_noteworthy( "spawn_end_guys" );	
	animnode thread anim_generic_first_frame( level.sandman, "rescue_ending_player_drag_handoff_sandman" );
	animnode thread anim_generic_first_frame( level.price, "rescue_ending_player_drag_handoff_price" );
	ground_ref_ent rotateto( (0,0,0), 0.5 );

	flag_wait( "ending_next_stop" ); 
	flag_clear( "ending_next_stop" ); 
	
	// ************* player turns, sees price & sandman *************
	delayThread( 1, ::music_play, "rescue_2_ending" );
	level.rescue_heli notify( "stop_kicking_up_dust" ); //reducing fx count
	thread argue_dialogue();
	thread argue_rpgs();
	animnode thread anim_generic( level.sandman, "rescue_ending_player_drag_handoff_sandman" );
	animnode thread anim_generic( level.price, "rescue_ending_player_drag_handoff_price" );
	animnode thread anim_generic( level.truck, "rescue_ending_player_drag_handoff_truck" );
	
	animtime = getAnimLength( getgenericanim( "rescue_ending_player_drag_handoff_truck" ) );
	delayThread( animtime*0.66, ::flag_set, "ending_next_stop" ); 
//	delayThread( animtime-0.1, ::flag_set, "ending_next_stop" );
	
	// need to spawn a new rig since the old one is still animating... sooooo hacky
	rig2 = spawn_anim_model( "player_rig" );
	rig2 hide();
	animnode thread anim_generic( rig2, "rescue_ending_player_drag_handoff_player" );
	
	flag_wait( "ending_next_stop" ); 
	flag_clear( "ending_next_stop" ); 
	rig hide();
	level.player thread playerBloodSmear();
	level.player PlayerLinkToBlend( rig2, "tag_player", 1 );
	level.player delayCall( 1.1, ::PlayerLinkToDelta, rig2, "tag_player", 1, 80, 80, 60, 60 );
	level.player delayCall( 9, ::PlayerLinkToBlend, rig2, "tag_player", 1 );
	
	flag_wait( "ending_next_stop" ); 
	flag_clear( "ending_next_stop" ); 
	
	weapons = getWeaponArray();
	array_call( weapons, ::delete );
		
	rig2 delayCall( 1.5, ::show );
	// ************* player dropped, price picks up, cool delta vignettes *************	
	
	flag_wait( "start_delta_retreat" );
	
	level.grinch.nodrop = true;
	
	animnode = get_target_ent( "ending_delta_vignette" );
	array_thread( get_heroes(), ::disable_pain );
	animnode thread anim_generic( level.sandman, "rescue_ending_delta_retreat_sandman" );
	animnode thread anim_generic( level.truck, "rescue_ending_delta_retreat_truck" );
	animnode thread anim_generic( level.grinch, "rescue_ending_delta_retreat_grinch_v2" );
	animnode thread anim_generic( rig, "rescue_ending_delta_retreat_player" );
	animtime = getAnimLength( getgenericanim( "rescue_ending_delta_retreat_player" ) );
	delayThread( animtime-0.1, ::flag_set, "ending_next_stop" );
	
	dummynode thread anim_first_frame_solo( level.price, "BH_anim" );
	level.price linkTo( dummynode, "tag_origin" );
	level.price Hide();
	level.player PlayerLinkToBlend( rig, "tag_player", 1 );
	level.player delayCall( 1.1, ::PlayerLinkToDelta, rig, "tag_player", 1, 80, 80, 60, 60 );
	
	player_weapon = "deserteagle";
	player_weapon = level.price.primaryweapon;
	level.player TakeAllWeapons();
	level.player GiveWeapon( player_weapon );
	level.player GiveMaxAmmo( player_weapon );
	level.player EnableWeapons();
	level.player delayCall( 0.2, ::SwitchToWeapon, player_weapon );
		
	flag_wait( "old_retreat_start" );
	thread retreat_rpgs();
	thread retreat_drones();
	rig2 hide();
	slowmo_setspeed_slow( 0.5 );
	slowmo_setlerptime_in( 0.4 );
	thread slowmo_lerp_in();
	
	wait( 1 );
	level.player PlayerSetGroundReferenceEnt( undefined );	
	level.player ShellShock( "rescue_chopper_drag_2", 120 );

	level.player thread play_sound_on_entity( "slomo_whoosh" );	
	
	// this is useless now... but i'm keeping it because it spawns bad guys too... hacky, i know
	holder.origin = rig2 getTagOrigin( "tag_player" );	
	thread vignette_look( holder );
	// end useless bit

	delayThread( 3, ::exploder, 200 );
	array_thread( getaiarray(), ::set_grenadeammo, 0 );

	
	flag_wait( "ending_next_stop" ); 
	flag_clear( "ending_next_stop" );
	
	level.rescue_heli thread aircraft_dust_kickup();
	dummynode anim_generic_first_frame( rig2, "rescue_ending_player_into_bh_player", "tag_origin" );
	rig2 linkTo( dummynode, "tag_origin" );	
	level.player PlayerLinkToBlend( rig2, "tag_player", 1 );
	
	level.sandman.lastweapon = level.sandman.primaryweapon;
	level.grinch.lastweapon = level.grinch.primaryweapon;
	
	flag_set( "cavern_player_gets_on_heli" );
	level.player disableWeapons();
	level.price delayCall( 1, ::Show );
	rig2 delayCall( 0.5, ::show );
	rig2 delayCall( 5.2, ::Hide );
	level.player delayCall( 6, ::enableWeapons );
	slowmo_setlerptime_out( 1 );
	thread slowmo_lerp_out();
	thread maps\_utility::set_ambient( "rescue_2_chopper", 1 );
	dummynode thread anim_single( [ level.price, level.president ], "BH_anim" );
	dummynode anim_generic( rig2, "rescue_ending_player_into_bh_player", "tag_origin" );
	flag_set( "cavern_player_in_heli" );
	level.player PlayerLinkToDelta( rig2, "tag_player", 1, 25, 25, 80, 80 );	
	
	
//	level.player AllowADS( true );
//	level.player FadeOutShellshock();	
}

vignette_look( holder )
{
//	delaythread( 1, ::lerp_fov_overtime, 16, 50 );
//	delaythread( 18, ::lerp_fov_overtime, 8, 65 );
//	level.player delayCall( 0.5, ::PlayerLinkToBlend, holder, "tag_origin", 1 );	
//	level.player delayCall( 1, ::PlayerLinkToDelta, holder, "tag_origin", 1, 25, 25, 40, 40 );	
	wait( 2 );
	point = get_midpoint( level.sandman.origin, level.truck.origin );
	ang = VectorToAngles( point - holder.origin );
	holder rotateTo( ang, 4, 1.5, 1.5 );
	s = getentarray( "cavern_end_dummy_right", "targetname" );
	array_spawn( s );
	holder waittill( "rotatedone" );
	wait( 0.5 );
	point = get_midpoint( level.sandman.origin, level.grinch.origin );
	ang = VectorToAngles( point - holder.origin );
	holder rotateTo( ang, 4, 1.5, 1.5 );
	s = getentarray( "cavern_end_dummy_left", "targetname" );
//	thread maps\_spawner::flood_spawner_scripted( s );
	thread array_spawn_targetname( "end_gimme_leftside_1" );
	holder waittill( "rotatedone" );
	s = getentarray( "cavern_end_dummy_right", "targetname" );
//	thread maps\_spawner::flood_spawner_scripted( s );
	array_spawn( s );
	point = level.sandman.origin; //get_midpoint( level.sandman.origin, level.grinch.origin );
	ang = VectorToAngles( point - holder.origin );
	holder rotateTo( ang, 4, 1.5, 1.5 );
	holder waittill( "rotatedone" );
}

argue_dialogue()
{
	level.sandman dialogue_queue( "rescue_snd_gottago" );
	level.price dialogue_queue( "rescue_pri_dontthink" );
	thread radio_dialogue( "rescue_snd_toomuchheat" );
}

argue_dialogue_interrupt()
{
	thread radio_dialogue_stop();
	thread radio_dialogue_interupt( "rescue_rno_rpg" );
	wait( 1.1 );
	level.sandman dialogue_queue( "rescue_snd_coverright" );
	wait( 0.8 );
	level.price dialogue_queue( "rescue_pri_betterbe" );
}

heli_leave_dialogue()
{
	flag_wait( "cavern_player_in_heli" );
	wait( 0.3 );
	level.price dialogue_queue( "rescue_pri_timetogo" );
	thread radio_dialogue( "rescue_snd_justgo" );
	wait( 1.0 );
	thread radio_dialogue_interupt( "rescue_trk_rpg" );
	wait( 0.2 );
	radio_dialogue( "rescue_hp2_hangon" );
	wait( 0.5 );
	radio_dialogue( "rescue_snd_goooo" );
	wait( 0.5 );
	radio_dialogue( "rescue_hp2_gottaleave" );
	level.price dialogue_queue( "rescue_pri_no" );
	wait( 0.5 );
	level.price dialogue_queue( "rescue_pri_backdown" );
	radio_dialogue( "rescue_hp2_toohot" );
	wait( 0.2 );
	level.price dialogue_queue( "rescue_pri_readme" );
	wait( 0.5 );
	level.price dialogue_queue( "rescue_pri_comein" );
	wait( 0.8 );
	level.price dialogue_queue( "rescue_pri_doyoucopy" );
	wait( 0.9 );
	level.price dialogue_queue( "rescue_pri_stillthere" );
}

argue_rpgs()
{
	delayThread( 6.5, ::argue_dialogue_interrupt );
	delayThread( 6.5, ::magic_rpg, "argue_rpg_1" );
	delayThread( 7.3, ::magic_rpg, "argue_rpg_2", "rpg_dirt_impact" );
	delayThread( 12.6, ::magic_rpg, "argue_rpg_3" );
}

retreat_rpgs()
{
	delayThread( 0.7, ::magic_rpg, "retreat_rpg_0", "rpg_dirt_impact" );
	delayThread( 4.2, ::magic_rpg, "retreat_rpg_1", "rpg_dirt_impact" );
	delayThread( 13.3, ::magic_rpg, "retreat_rpg_2", "rpg_dirt_impact" );
}

retreat_drones()
{
	spawners = getentarray( "cavern_end_drone_random", "targetname" );
	array_thread( spawners, ::cavern_bottom_drone_runner );
	thread array_spawn_targetname( "end_gimme_rightside_1" );
	delayThread( 7.6, ::spawn_targetname, "cavern_end_drone_close_1" );
	delayThread( 11.85, ::spawn_targetname, "cavern_end_drone_close_2" );
	wait( 13.05 );
	level.sandman_knife_guy = spawn_targetname( "cavern_end_drone_close_3" );
	level.sandman_knife_guy waittill( "death" );
}

player_shellshock_heartbeat()
{
	level.player endon( "stop_breathing" );

	childthread player_shellshock_blur();
	
	wait( 0.5 );
	
	while( 1 )
	{
		level.player play_sound_on_entity( "breathing_heartbeat" );
		wait( 0.5 );
	}
}

player_shellshock_blur()
{
	while( 1 )
	{
		thread fade_out( 5 );
		level.player setBlurforplayer( 1, 2 );
		wait( 2 );
		level.player setBlurforplayer( 0, 4 );
		fade_in( 2 );
		wait( 2 );
	}
}

player_shellshock_breathing()
{
	level.player endon( "stop_breathing" );
	
	level.player play_sound_on_entity( "breathing_hurt_start" );
	
	delay = 0.2;
	
	while( 1 )
	{
		level.player play_sound_on_entity( "breathing_hurt" );
		wait( delay );
		delay += 0.3;
	}
}

cavern_helicopter_scene()
{
	flag_wait( "cavern_heli_landing" );
	maps\_spawner::killspawner( 600 );
	disable_defend_triggers();
	enable_heli_run_triggers();
	activate_trigger_with_noteworthy( "cavern_run_friendlies_chopper" );
	array_thread( get_heroes(), ::disable_pain );
	array_thread( get_heroes(), ::set_baseaccuracy, 15 );
	thread maps\_spawner::flood_spawner_scripted( getentarray( "cavern_run_chaser", "targetname" ) );
}

// ---------------------------------------------UTILITY-----------------------------------------------------------

crazy_rotate()
{
	self endon( "death" );
	while( 1 )
	{
		self rotateTo( self.angles + (5,180,9), 0.5, 0 );
		self waittill( "rotatedone" );
	}
}

move_up_when_clear()
{
	volume = self get_target_ent();
	trigger = volume get_target_ent();
	
	trigger endon( "trigger" );
	
	self waittill( "trigger" );
	
	volume_waittill_no_axis( volume.targetname, volume.script_count );
	
	trigger thread activate_trigger();
}

cleanup_ai_in_volume()
{
	self waittill( "trigger" );
	cleanup_guys = [];
	volume = self get_target_ent();
	ai = getaiarray( "axis" );
	foreach ( a in ai )
	{
		if ( a isTouching( volume ) )
		{
			cleanup_guys = array_add( cleanup_guys, a );
		}
	}
	
	ai_delete_when_out_of_sight( cleanup_guys, 256 );
}


guy_anim_think()
{
	self endon( "death" );
	self endon( "damage" );
	
	self set_battlechatter( false );
	
	if ( isdefined( self.target ) )
		node = self get_target_ent();
	else
		node = self;
	
	self gunless_anim_check( node.animation );
	
	if ( IsAI( self ) && isdefined( self.moveoverride ) )
	{
		node anim_generic_reach( self, node.animation );
	}
	
	node thread anim_generic_first_frame( self, node.animation );
	if ( isdefined( self.script_delay ) )
		self script_delay();
	else
		wait( RandomFloatRange( 0, 3 ) );
	self.allowdeath = true;
	node anim_generic( self, node.animation );
	
	self set_battlechatter( true );
}

guy_anim_then_idle_think()
{
	self endon( "death" );
	self endon( "damage" );
	
	self set_battlechatter( false );
	
	self.health = 1;
	self.allowdeath = true;
	
	if ( isdefined( self.target ) )
		node = self get_target_ent();
	else
		node = self;

	self gunless_anim_check( node.animation );

	if ( !isAI( self ) )
	{
		thread drone_proper_death();
	}
	
	node thread anim_generic_first_frame( self, node.animation );
	if ( isdefined( self.script_delay ) )
		self script_delay();
	else
		wait( RandomFloatRange( 0, 3 ) );
	
	self.allowdeath = true;
	node anim_generic( self, node.animation );	
	self.allowdeath = true;
	self.ragdoll_immediate = true;
	node anim_generic_loop( self, node.animation + "_idle" );
}

guy_anim_then_die_think()
{
	self endon( "death" );
	self endon( "damage" );
	
	self set_battlechatter( false );
	
	self.health = 1;
	self.allowdeath = true;
	
	if ( isdefined( self.target ) )
		node = self get_target_ent();
	else
		node = self;
	
	if ( isdefined( level.scr_anim[ "generic" ][ node.animation + "_death" ] ) )
		self.deathanim = getgenericanim( node.animation + "_death" );
	
	self gunless_anim_check( node.animation );
	
	if ( issubstr( node.animation, "crawl" ) )
	{
		if ( !isdefined( self.a ) )
			self.a = spawnstruct();
		self.animplaybackrate = RandomFloatRange( 0.7, 1.1 );
		self.a.pose = "prone";
		self delaythread( 0.1, animscripts\pain::dyingCrawlBloodSmear );
	}
	
	if ( !isAI( self ) )
	{
		thread drone_proper_death();
	}

	
	if ( isdefined( self.script_linkTo ) )
	{
		ents = self get_linked_ents();
		foreach ( e in ents )
		{
			if ( !isSpawner( e ) )
			{
				self thread die_on_death( e );
				e thread die_on_death( self );
			}
		}
	}

	node thread anim_generic_first_frame( self, node.animation );
	
	if ( isdefined( self.script_delay ) )
		self script_delay();
	else
		wait( RandomFloatRange( 0, 3 ) );	
	
	self.allowdeath = true;
	self.ragdoll_immediate = true;
	node anim_generic_gravity( self, node.animation );
	self.ragdoll_immediate = undefined;
	self kill();
}

die_on_death( guy )
{
	self endon( "death" );
	guy waittill( "death" );
	self kill();
}


gunless_anim_check( animation )
{
	if ( array_contains( level.gunless_anims, animation ) && self.weapon != "none" )
		self gun_remove();
}

drone_blood_on_damage()
{
	self waittill( "damage", amount, attacker, dir, point, mod, modelname, tag, part, weapon );
	if ( isdefined( self ) )
	{
		PlayFX( getfx( "bodyshot1" ), point );
	}
}

drone_proper_death()
{	
	self.health = 1;
	self thread drone_blood_on_damage();
	self thread maps\_drone::drone_drop_real_weapon_on_death();
	self waittill_either( "death", "damage" );
	
	if ( !isdefined( self ) || isdefined( self.skipdeathfx ) )
		return;
		
	thread play_sound_in_space( "generic_death_falling_scream", self.origin );
	if ( cointoss() )
	{
		num = RandomIntRange( 1, 3 );
		self bodyshot( "bodyshot" + num, "J_SpineUpper" );
	}
	else
	{
		num = RandomIntRange( 1, 3 );
		self bodyshot( "headshot" + num, "tag_eye" );
	}
	wait( 2.0 );
	self animscripts\death::play_blood_pool();
}

bodyshot( fx, tag )
{
	origin = self GetTagOrigin( tag );

	PlayFX( getfx( fx ), origin );
}

run_to_position_think()
{
	self.goalradius = 64;
	self.pacifist = true;
	self.ignoreSuppression = true;
	
	self waittill( "goal" );
	
	self.ignoreSuppression = false;
	self.pacifist = false;
	self.goalradius = 1024;
}

cavern_dust()
{
	level endon( "start_bottom_fight" );
	volume = get_target_ent( "cavern_volume" );
	
	level.cave_shake_sound = "scn_prague_tank_alley_exp";
	level.cave_shake_source = level.player;
	
	while( 1 )
	{
		wait( RandomFloatRange( 4,6 ) );
		
		if ( !level.player isTouching( volume ) )
			continue;

		strength = RandomFloatRange( 0.3, 0.6 );
		maps\rescue_2_code::cave_shake( strength, "cavern_dust_source", "cavern_primary_light" );
	}
}

cavern_bottom_dust()
{
	level.cave_shake_sound = "scn_prague_tank_alley_exp";
	level.cave_shake_source = level.player;
	level.cave_shake_delay_min = 2;
	level.cave_shake_delay_max = 4;
	level.cave_shake_stength_min = 0.4;
	level.cave_shake_stength_max = 0.7;
	
	level.shake_fx_num = 5;
	
	while( 1 )
	{
		wait( RandomFloatRange( level.cave_shake_delay_min, level.cave_shake_delay_max ) );

		strength = RandomFloatRange( level.cave_shake_stength_min, level.cave_shake_stength_max );
		maps\rescue_2_code::cave_shake( strength, "cavern_bottom_fx", "cavern_bottom_primary", true );
		
		times = RandomIntRange( 2, 5 );
		fwd = AnglesToForward( level.player.angles );
		org = level.player.origin + fwd*256 + (0,0,128);
		
		fwd = AnglesToForward( level.player.angles );
		PlayFx( getfx( "ceiling_rock_collapse" ), level.player.origin + (0,0,128) + fwd*128);
		PlayFx( getfx( "ceiling_rock_collapse_big" ), level.player.origin + (0,0,256) + fwd*512);
		
		for ( i=0; i<times; i++ )
		{
			PlayFX( getfx( "cavern_bottom_collapse_dirt" ), org + ( RandomFloatRange( 0, 256 ), RandomFloatRange( 0, 256 ), 0 ), (0,0,-1) );
			wait( RandomFloatRange( 0.2, 0.3 ) );
		}
		times = RandomIntRange( 2, 5 );
		fwd = AnglesToForward( level.player.angles );
		org = level.player.origin + fwd*1024 + (0,0,128);
		for ( i=0; i<times; i++ )
		{
			PlayFX( getfx( "cavern_bottom_collapse_dirt" ), org + ( RandomFloatRange( 0, 512 ), RandomFloatRange( 0, 512 ), 0 ), (0,0,-1) );
			wait( RandomFloatRange( 0.2, 0.3 ) );
		}
	}
}

low_earthquakes()
{
	level endon( "stop_earthquakes" );
	level.low_earthquake_min = 0.1;
	level.low_earthquake_max = 0.2;
	level.low_earthquake_delay_min = 0.6;
	level.low_earthquake_delay_max = 1.0;
	level.low_earthquake_pause_min = 0.5;
	level.low_earthquake_pause_max = 3;
	while( 1 )
	{
		time = RandomFloatRange( level.low_earthquake_delay_min, level.low_earthquake_delay_max );
		Earthquake( RandomFloatRange( level.low_earthquake_min, level.low_earthquake_max ), time, level.player.origin, 1024 );
		wait( time );
		if ( level.low_earthquake_pause_min > 0 )
			wait( RandomFloatRange( level.low_earthquake_pause_min, level.low_earthquake_pause_max ) );
	}
}

setup_elevator()
{
	elevator_array = getentarray( "cavern_elevator", "targetname" );
	linkers = [];
	
	foreach ( item in elevator_array )
	{
		switch ( item.classname )
		{
			case "script_brushmodel":
				level.cavern_elevator = item;
				break;
			case "script_model":
				linkers = array_add( linkers, item );
				break;
		}
	}
	
	foreach ( l in linkers )
	{
		l linkTo( level.cavern_elevator );
	}
	
//	level.cavern_elevator moveZ( -4000, 30 );
	level.cavern_elevator_doors = getentarray( "cavern_elevator_door", "targetname" );
	array_thread( level.cavern_elevator_doors, ::setup_elevator_door );
	
	level notify( "open_cavern_elevator" );
}

setup_elevator_door()
{
	node = self get_target_ent();
	self.close_pos = self.origin;
	self.open_pos = ( node.origin[0], node.origin[1], self.origin[2] );
	
	time = 3;
	
	while ( 1 )
	{
		level waittill( "open_cavern_elevator" );
		self moveTo( self.open_pos, time, time/2, time/2 );
		self connectpaths();
		level waittill( "close_cavern_elevator" );
		self moveTo( self.close_pos, time, time/2, time/2 );
		self disconnectpaths();
	}
}

get_door_from_targetname( name )
{
	door = get_target_ent( name );
	ents = door get_linked_ents();
	foreach ( e in ents )
	{
		e linkTo( door );
	}
	return door;
}

president_breach_spawners_think()
{
	self endon( "death" );
	if ( self.team != "axis" )
	{
		self endon( "stop_breach_behavior" );
		level.president = self;
		self.deathanim = getgenericanim( self.animation + "_death" );
		if ( self.weapon != "none" )
			self gun_remove();
		self thread fail_on_death();
		node = SpawnStruct();
		level.president.animnode = node;
		node.origin = self.origin;
		node.angles = self.angles;
		
		self.health = 1;
		self.allowdeath = true;	
		
		wait( level.slowmo_breach_start_delay );
		self.animname = "president";
		node thread anim_generic_gravity( self, self.animation );
		wait( 0.1 );
		self childthread president_holder_dies();
		
	}
	else
	{
		thread maps\_slowmo_breach::breach_enemy_spawner_think();
		if ( isSubstr( self.animation, "execution" ) || isSubstr( self.animation, "holder" ) )
		{
			level.president_holder = self;
			self forceuseWeapon( "deserteagle", "sidearm" );
		}
	}
}

president_holder_dies()
{
	level.president_holder waittill( "death" );
	node = get_Target_ent( "president_rescue_node" );
	node.origin = self.origin;
	n2 = SpawnStruct();
	n2.origin = node.origin;
	n2.angles = node.angles + (0,90,0);
	n2 anim_generic_gravity( self, self.animation + "_survives" );
	self clear_deathanim();
	self thread anim_generic_loop( self, "pres_getup_idle" );
	ai = getaiarray( "axis" );
	array_thread( ai, ::set_ignoreme, false );
	flag_set( "no_mercy" );
}

fail_on_death()
{
	level endon( "missionfailed" );
	level.player endon( "death" );

	self waittill( "death", other );

	radio_dialogue_stop();

	wait( 0.5 );

	quote = undefined;

	if ( IsPlayer( other ) )
		//Friendly fire will not be tolerated.
		quote = &"RESCUE_2_FRIENDLY_FIRE";
	else
		//Mission Failed. The President was killed.
		quote = &"RESCUE_2_PRESIDENT_WAS_KILLED";

	SetDvar( "ui_deadquote", quote );
	thread maps\_utility::missionFailedWrapper();
}

bumrush_player()
{
	self endon( "death" );
	
	if ( isdefined( self.target ) )
		wait( RandomFloatRange( 15, 20 ) );
	
	self.favoriteenemy = level.player;
	
	while( 1 )
	{
		self setGoalEntity( level.player );
		wait( RandomFloatRange( 5, 10 ) );
		self.goalradius = self.goalradius * 0.5;
	}
}

cavern_defend_bumrush()
{
	flag_wait( "cavern_defend_wave_1" );
	wait( 2 );
	level endon( "cavern_rescue_arrives" );
	
	while( 1 )
	{
		ai = getaiarray( "axis" );
		if ( ai.size < 1 )
		{
			wait( 1 );
			continue;
		}
		
		ai = SortByDistance( ai, level.player.origin );
		bumrush_guy = ai[0];
		bumrush_guy.goalradius = 64;
		bumrush_guy setGoalEntity( level.player );
		bumrush_guy waittill( "death" );
	}
}

disable_defend_triggers()
{
	triggers = getentarray( "defend_trigger", "script_noteworthy" );
	array_thread( triggers, ::trigger_off );
	triggers = getentarray( "cavern_run", "script_noteworthy" );
	array_thread( triggers, ::trigger_off );
}

enable_defend_triggers()
{
	enable_trigger_with_noteworthy( "cavern_breach_exit" );
	
	triggers = getentarray( "defend_trigger_off", "script_noteworthy" );
	array_thread( triggers, ::trigger_off );
	triggers = getentarray( "defend_trigger", "script_noteworthy" );
	array_thread( triggers, ::trigger_on );
}

enable_heli_run_triggers()
{
	triggers = getentarray( "cavern_run", "script_noteworthy" );
	array_thread( triggers, ::trigger_on );
}

dead_daughter()
{
	self gun_remove();
	self thread deletable_magic_bullet_shield();
	self.disabledamageshieldpain = true;
	self.animname = "alena";
	node = self get_target_ent();
//	self AnimScripted( "endanim", node.origin, node.angles, getgenericanim( node.animation ) );
//	wait( 0.05 );
//	self setAnimTime( getgenericanim( node.animation ), 1 );
	node thread anim_single_solo( self, "rescue_chair_untie" );
}

cavern_start_dialogue()
{
	flag_wait( "cavern_drop_down" );
	
	radio_dialogue( "rescue_snd_holdingcell" );
	
	trigger_wait( "first_breach_trigger", "script_noteworthy" );
	
	level.price dialogue_queue( "rescue_pri_openitup" );
}

breach_room_dialogue()
{
//	flag_wait( "torture_room_cleared" );
	
	level waittill( "sp_slowmo_breachanim_done" );
	level.price disable_ai_color();
	
	array_thread( get_heroes(), ::disable_cqbwalk );
	thread breach_room_scene();
	level.truck thread dialogue_queue( "rescue_pri_bloody" );
	level.truck thread dialogue_queue( "rescue_trk_daughter" );
	wait( 3 );
	radio_dialogue( "rescue_hqr_securedpresident" );
	wait( 0.5 );
	radio_dialogue( "rescue_snd_foundathena" );
	wait( 0.5 );
	radio_dialogue( "rescue_hqr_sendinateam" );
	level.daughter thread generic_dialogue_queue( "rescue_aln_mumbles" );
	wait( 1.25 );
	level.truck dialogue_queue( "rescue_trk_tryingtosay" );
	wait( 1.25 );
	level.truck dialogue_queue( "rescue_trk_furtherdown" );
	wait( 0.5 );
	level.sandman.a.pose = "stand";
	level.sandman dialogue_queue( "rescue_snd_maybealive" );
}

breach_room_scene()
{
	guys = array_spawn_targetname( "delta_daughter_exfil", true );
	array_thread( guys, ::set_battlechatter, false );
	activate_trigger_with_noteworthy( "daughter_exfil_position" );
		
	node = get_target_Ent( "daughter_chair_node" );
	thread daughter_think();
	cuffs = spawn_anim_model( "flexcuff" );
	node thread anim_single( [ level.price, level.sandman, cuffs ], "rescue_chair_untie" );
	wait( 12 );
	thread daughter_exfil( guys[0] );
	node = get_target_ent( "price_sees_nothing" );
	level.price setGoalNode( node );

	objective_onentity( obj( "rescue_prez" ), level.price );
	objective_setpointertextoverride( obj( "rescue_prez" ), "" );
	array_thread( get_heroes(), ::disable_cqbwalk );
	
	node = get_target_ent( "cavern_door_kick_node" );
	node anim_generic_reach( level.sandman, "doorkick_2_cqbrun" );
	
	thread kick_double_door_open( get_door_from_targetname( "cavern_door_l" ), get_door_from_targetname( "cavern_door_r" ), "scn_rescue_big_metal_dbl_door_kick", undefined, get_target_ent( "cavern_door_kick_fxnode" ) );
	activate_trigger_with_noteworthy( "cavern_top_1_trigger" );
	delayThread( 0.5, ::music_play, "rescue_2_assault", 0.0 );	
	cuffs delete();	
	node anim_generic( level.sandman, "doorkick_2_cqbrun" );
	array_thread( get_heroes(), ::enable_ai_color );
	activate_trigger_with_noteworthy( "heroes_post_breach" );
	battlechatter_on( "allies" );
	autosave_if_safe( "post_breach" );
	flag_set( "start_chase" );
}

daughter_exfil( g )
{
	node = get_target_Ent( "daughter_chair_node" );
	
	node anim_generic_reach( g, "rescue_chair_untie" );	
	g delaythread( 5.5, ::generic_dialogue_queue, "rescue_dlt1_confirmstation" );
	node anim_generic( g, "rescue_chair_untie" );	
	node thread anim_generic_loop( g, "rescue_chair_untie_idle" );
}

daughter_think()
{
	node = get_target_Ent( "daughter_chair_node" );
	node anim_single_solo( level.daughter, "rescue_chair_untie" );
	node thread anim_loop_solo( level.daughter, "rescue_chair_untie_idle" );
}

explosion_trigger()
{
	self waittill( "trigger" );
	
	nodes = getstructarray_delete( self.target, "targetname" );
	
	foreach ( n in nodes )
	{
		n thread node_explode();
	}
}

node_explode()
{
	self script_delay();
	
	if ( !isdefined( self.script_fxid ) )
		self.script_fxid = "generic_explosion";
	
	thread play_sound_in_space( "scn_large_tank_explode" );
	
	fwd = ( 0, 1, 0 );
	if ( isdefined( self.angles ) )
		fwd = AnglesToForward( self.angles );
		
	PlayFX( getfx( self.script_fxid ), self.origin, fwd );
	Earthquake( RandomFloatRange( 0.4, 0.6 ), RandomFloatRange( 0.4, 0.6 ), self.origin, 2048 );
}

playerBloodSmear()
{
	self endon( "stop_blood" );
	
	fx_rate = .25;
	fx = level._effect[ "crawling_death_blood_smear" ];
	
	if ( isdefined( self.a.crawl_fx_rate ) )
		fx_rate = self.a.crawl_fx_rate;
	if( isdefined( self.a.crawl_fx ) )
		fx = level._effect[ self.a.crawl_fx ];
	
	while( fx_rate )
	{
		org = self geteye();
		angles = self.angles;
		forward = anglestoright( angles );
		up = anglestoforward( ( 270, 0, 0 ) );
		
		playfx( fx, org, up, forward );
		
		wait( fx_rate );
	}
}

cavern_shake_trigger()
{
	self waittill( "trigger" );
	strength = 0.5;
	maps\rescue_2_code::cave_shake( strength, "cavern_dust_source", "cavern_primary_light" );
}

swinging_light()
{
	self.animname = "swinging_light";
	self SetAnimTree();
	self.light = self get_target_ent();
//	self.light.targetname = "cavern_primary_light";
	thread flickering_light( self.light, 1.8, 2 );
	linkent = spawn_tag_origin();
	linkent LinkTo( self, "J_Hanging_Light_03", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	self.light thread manual_linkto( linkent );
	self thread anim_loop_solo( self , "wind_medium" );
}

cavern_defend_stay_close()
{
	flag_wait( "cavern_defend_wave_1" );
	level endon( "kill_rescue_heli" );
	level.president endon( "death" );
	flag_init( "player_close_to_president" );

	while( 1 )
	{
		flag_set( "player_close_to_president" );
		
		while( player_is_ok() )
		{
			wait( 0.05 );
		}
		
		flag_clear( "player_close_to_president" );
		childthread protect_president_nag();
		
		while( !player_is_ok() )
		{
			wait( 0.05 );
		}
	}
}

player_is_ok()
{
	// am i close to the president?
	if ( distance( level.player.origin, level.president.origin ) < 350 )
		return true;
	// am i close to any of our heroes?
	heroes = get_heroes();
	foreach ( guy in heroes )
		if ( distance( level.player.origin, guy.origin ) < 350 )
			return true;
	
	return false;
}

protect_president_nag()
{
	level endon( "player_close_to_president" );
	wait( 3 );
	
	level.price dialogue_queue( "rescue_pri_yurigetbackhere" );
	wait( 5 );
	level.price dialogue_queue( "rescue_pri_whereareyougoing" );
	wait( 5 );
	
	
	level.president stop_magic_bullet_shield();
	level.president kill();
}

move_passengers( from, to )
{
	level.price unlink();
	level.player_rig unlink();
	
	from notify( "stop_price_loop" );
	put_price_on_heli( to );
	put_player_on_heli( to );
}

move_player_to_heli( time )
{
	mover = get_player_rig();
	mover hide();
	level.player PlayerLinkToDelta( mover, "tag_origin", 1, 120, 60, 20, 80 );
	
	playerspot = "tag_guy6";
	
	level.player allowstand( true );
	level.player allowcrouch( false );
	level.player allowprone( false );
	level.player EnableInvulnerability();
	
	org = level.rescue_heli getTagOrigin( playerspot ) - (0,0,30);
	ang = level.rescue_heli getTagAngles( playerspot ) - (0,180,0);
	mover moveTo( org - AnglesToRight(ang)*5, time );
	mover rotateTo( ang, time );
	mover waittill( "movedone" );
}

put_price_on_heli( heli )
{	
	level.price linkTo( heli, "tag_detach" );
	heli thread anim_loop_solo( level.price, "bh_idle", "stop_price_loop", "tag_detach" );
}

put_player_on_heli( heli )
{
	playerspot = "tag_guy6";
	
	level.player allowstand( true );
	level.player allowcrouch( false );
	level.player allowprone( false );
	
	org = heli getTagOrigin( playerspot ) - (0,0,30);
	ang = heli getTagAngles( playerspot ) - (0,180,0);
	
	level.player_rig.origin = org - AnglesToRight(ang)*5;
	level.player_rig.angles = ang;
	level.player_rig linkTo( heli, playerspot );
}

magic_rpg( targetname, impact_fx, custom_bullet, custom_earthquake )
{
	if ( !isdefined( custom_bullet ) )
		 custom_bullet = "rpg_straight";
	node = get_target_ent( targetname );
	node2 = node get_Target_ent();
	rpg = MagicBullet( custom_bullet, node.origin, node2.origin );
	
	if ( isdefined( impact_fx ) )
	{
		rpg waittill( "death" );
		PlayFX( getfx( impact_fx ), rpg.origin );
		if ( isdefined( custom_earthquake ) )
		{
			do_earthquake( custom_earthquake, rpg.origin );
		}
	}
}

spawn_sandman_ambusher( guy )
{
	node = get_target_ent( "ending_delta_vignette" );
	guy = spawn_targetname( "vignette_drone" );
	guy thread magic_bullet_shield();
	guy.disabledamageshieldpain = true;
	guy.special_death = true;
	guy.a.nodeath = true;
	node thread anim_generic( guy, "rescue_ending_delta_retreat_sandman_ambusher" );
	time = GetAnimLength( getgenericanim( "rescue_ending_delta_retreat_truck_ambusher" ) );
	wait( 0.1 );
	guy.allowDeath = true;
	guy.a.nodeath = true;
	wait( time*0.9 );
	if ( isAlive( guy ) )
	{
		guy stop_magic_bullet_shield();
		guy kill();
	}
}

spawn_truck_ambusher( guy )
{
	node = get_target_ent( "ending_delta_vignette" );
	guy = spawn_targetname( "vignette_drone" );
	guy thread magic_bullet_shield();
	guy.disabledamageshieldpain = true;
	guy.special_death = true;
	guy.a.nodeath = true;
	node thread anim_generic( guy, "rescue_ending_delta_retreat_truck_ambusher" );
	time = GetAnimLength( getgenericanim( "rescue_ending_delta_retreat_truck_ambusher" ) );
	wait( 0.1 );
	guy stop_magic_bullet_shield();
	guy.allowDeath = true;
	guy.a.nodeath = true;
	wait( time*0.9 );
	if ( isAlive( guy ) )
	{
		guy stop_magic_bullet_shield();
		guy kill();
	}
}

get_midpoint( pt1, pt2 )
{
	return pt1 + (pt2-pt1)*0.5;
}

get_rescue_heli_node()
{
	if ( isdefined( level.rescue_heli.dummynode ) )
		return level.rescue_heli.dummynode;
	level.rescue_heli.dummynode = spawn_tag_origin();
	level.rescue_heli.dummynode.origin = level.rescue_heli getTagOrigin( "tag_ground" );
	level.rescue_heli.dummynode.angles = level.rescue_heli getTagAngles( "tag_ground" );
	level.rescue_heli.dummynode linkTo( level.rescue_heli, "tag_ground" );
	return level.rescue_heli.dummynode;
}

chopper_spawn_pilot()
{
	position = 0;
	spawner = get_target_ent( "pilot_spawner" );
	passenger = dronespawn( spawner );
	passenger.forced_startingposition = position;
	self guy_enter_vehicle( passenger );
	
	return passenger;
}

cavern_end_drone_think()
{
	self drone_parameters();
	self.script_noteworthy = "die_on_goal";
	node = self get_target_ent();
	
	if ( !issubstr( self.script_parameters, "randompath" ) )
		node = node get_last_ent_in_chain( "struct" );

	if ( isdefined( node.animation ) )
		self.deathanim = getgenericanim( node.animation );
	else
		self.deathanim = random( level.drone_deaths_f );
}

drone_parameters()
{
	if ( !isdefined( self.script_parameters ) )
	{
		self thread drone_proper_death();
		return;
	}
	
	if ( issubstr( self.script_parameters, "notsolid" ) )
		self NotSolid();
	
	// special deaths
	if ( issubstr( self.script_parameters, "stagger" ) )
		self thread stagger_death();
	else if ( issubstr( self.script_parameters, "headshot" ) )
		self thread headshot_death();
	else
		self thread drone_proper_death();
}

headshot_death()
{
	self waittill( "death" );
	
	if ( !isdefined( self ) )
		return;
	
	org = self getTagOrigin( "tag_eye" );
	PlayFX( getfx( "headshot1" ), org );
	
	wait( 2.0 );
	self animscripts\death::play_blood_pool();
}

stagger_death()
{
	self waittill( "death" );
	
	if ( !isdefined( self ) )
		return;
	
	time = getAnimLength( self.deathanim ) * 0.3 ;
	self random_bloodspurt( time );
	
	wait( 2.0 );
	self animscripts\death::play_blood_pool();
}

random_bloodspurt( time, tags )
{	
	if ( !isdefined( tags ) )
		tags = [ "j_spinelower", "j_spineupper", "j_shoulder_le", "j_shoulder_ri", "j_head" ];
	
	fxs = [ "bodyshot1", "bodyshot2", "headshot1", "headshot2" ];
	
	elapsed = 0;
	
	while( time > elapsed )
	{
		fxname = fxs[ RandomIntRange( 0,fxs.size ) ];
		PlayFXOnTag( getfx( fxname ), self, tags[ RandomIntRange(0,tags.size) ] );
		t = RandomFloatRange( 0.1, 0.2 );
		wait( t );
		elapsed = elapsed + t;
	}
}

cavern_bottom_drone_runner()
{
	spawner = self;
	while( 1 )
	{
		wait( RandomFloatRange( 3, 5 ) );
		drone = spawner spawn_ai();
		drone waittill( "death" );
	}
}

retreat_fire( guy )
{
	if ( !isdefined( self.last_kill_time ) )
	{
		self.kill_timeout = 500;
		self.last_kill_time = -1;
	}
		
	enemies = getaiarray( "axis" );
	org = guy getTagOrigin( "tag_flash" );
	ang = guy getTagAngles( "tag_flash" );
	fwd = AnglesToForward( ang );
	
	if ( cointoss() )
		enemies = SortByDistance( enemies, guy.origin );
	
	if ( getTime() - self.last_kill_time < self.kill_timeout )
		self.last_kill_time = getTime();
	else
		return;
		
	foreach ( e in enemies )
	{
		if ( !isdefined( e.special_death ) )
		{
			if ( within_fov_2d( org, ang, e.origin, cos(65) ) )
			{
				wait( 0.1 );
				if ( isAlive( e ) )
				{
					e kill();
					break;
				}
			}
		}
	}
}

fan_spin()
{
	while( 1 )
	{
		self rotatePitch( 180, 0.6 );
		wait ( 0.5 );
	}
}

disable_autoaim_think()
{
	self.health = 1;
//	self DisableAimAssist();
}

player_lerp_eq()
{
//	level.player SetEqLerp( 0, level.eq_main_track );
//	AmbientStop( 1 );
	thread maps\_ambient::use_eq_settings( "scn_rescue2_news", level.eq_mix_track );
//	thread maps\_ambient::blend_to_eq_track( level.eq_mix_track , 1 );	
}

gimme_deaths_think()
{
	self endon( "death" );
	self.special_death = true;
	self.health = 1;
	self.goalradius = 1;
	self setGoalPos( self.origin );
	self.favoriteenemy = level.player;
	wait( RandomFloatRange( 5, 8 ) );
	self kill();
}

base_alarm()
{
	// because it's really annoying to hear that alarm all day
	
	play_alarm = GetDvarInt( "play_alarm", 1 );
	
	if ( play_alarm )
	{
		flag_wait( "start_base_alarm" );
		sound_ent = getent( "origin_sound_alarm", "targetname" );
	
		//sound_ent thread play_loop_sound_on_entity( "emt_alarm_base_alert" );
		sound_ent playloopsound( "emt_alarm_base_alert" );
		flag_waitopen( "start_base_alarm" );
		sound_ent stopLoopSound( "emt_alarm_base_alert" );
	}
}

fire_light( flagname )
{
	wait( 0.1 );
	if ( isdefined( flagname ) )
		flag_wait( flagname );
	
	if ( !isdefined( self.script_maxdist ) )
		self.script_maxdist = 20;
	
	i = self getLightIntensity();
	if ( i <= 0 )
		return;
		
	thread flickering_light( self, i*0.6, i );
	thread moving_light( self, self.script_maxdist );
}

player_damage_trigger()
{
	trigger = get_target_ent( "defend_player_damage_trigger" );
	level endon( "cavern_run_to_heli" );
	childthread player_kill_trigger( "defend_player_kill_trigger" );
	while( 1 )
	{
		trigger waittill( "trigger" );
		fwd = AnglesToForward( level.player.angles );
		level.player dodamage( 60, level.player.origin + fwd );
		wait( 1 );
	}
}

player_kill_trigger( targetname )
{
	trigger = get_target_ent( targetname );
	trigger waittill( "trigger" );
	level.player kill();
}

pipes_fall()
{
	trigger_wait_targetname( "pipes_fall_1_trigger" );
	wait( 0.6 );
	pipes = getentarray( "pipes_fall_1", "targetname" );
	
	foreach ( p in pipes )
	{
		vec = VectorNormalize(level.player.origin - p.origin);
//		p PhysicsLaunchClient( p.origin, vec*0.1 );
		mod = random( [200,350,450] );
		p MoveGravity( vec*mod, 10 );
		p RotateVelocity( (RandomFloatRange(-40,40),RandomFloatRange(-40,40),RandomFloatRange(-40,40) ), 10 );
	}
	
	trigger_wait_targetname( "pipes_fall_2_trigger" );
	wait( 1 );
	pipes = getentarray( "pipes_fall_2", "targetname" );
	
	foreach ( p in pipes )
	{
		vec = VectorNormalize(level.player.origin - p.origin);
//		p PhysicsLaunchClient( p.origin, vec*0.1 );
		mod = random( [200,350,450] );
		p MoveGravity( vec*mod, 10 );
		p RotateVelocity( (RandomFloatRange(-40,40),RandomFloatRange(-40,40),RandomFloatRange(-40,40) ), 10 );
	}
}

kill_nearby_enemies()
{
	self endon( "death" );
	while( 1 )
	{
		wait( RandomFloatRange( 0.3, 0.6 ) );
		ai = getaiarray( "axis" );
		foreach ( a in ai )
		{
			if ( !isdefined( a.special_death ) && Distance2d( a.origin, self.origin ) < 200 )
			{
				a kill();
				break;
			}
		}
	}
}

keep_president_in_combat()
{
	self endon( "death" );
	while ( 1 )
	{
		ai = getaiarray( "axis" );
		if ( ai.size > 0 )
		{
			self getEnemyInfo( ai[0] );
			self.favoriteenemy = ai[0];
			ai[0] waittill_notify_or_timeout( "death", 10 );
		}
		else
			wait( 0.3 );
	}
}

autosave_if_safe( name )
{
	wait( 0.05 );
	if ( flag( "lots_of_time" ) )
		autosave_by_name( name );
}