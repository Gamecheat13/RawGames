//included by my sparkinson test map and the main payback streets gsc, so that it works okay from either setup
#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\payback_util;
#include maps\payback_env_code;
#include maps\payback_sandstorm_code;
#include maps\_audio; 

// only called on level starting point, not on full playthrough
start_s2_construction()
{

	// AUDIO: jump/checkpoints
		
	aud_send_msg("s2_construction");
	
	default_start( maps\payback_streets_const::start_s2_construction );
	thread maps\payback_streets::streets_save_triggers();
	level.start_point = "s2_construction"; // for my test level
	move_player_to_start();
	level.price = spawn_ally( "price" );
	level.soap = spawn_ally( "soap" );
	level.price make_hero();
	level.soap make_hero();
	level.barracus = spawn_ally( "barracus" );
	level.barracus set_force_color( "blue" );
	texploder(2300);
	exploder(2000);
	exploder(2500);
	exploder(4000);        
	texploder(5300);
	exploder(5000);//const	
	
	if(IsDefined( level.price.magic_bullet_shield ) == false || level.price.magic_bullet_shield == false)
	{
		level.price magic_bullet_shield();
	}

	if(IsDefined( level.soap.magic_bullet_shield ) == false || level.soap.magic_bullet_shield == false)
	{
		level.soap magic_bullet_shield();
	}
	level.price.animname = "price";
	level.price thread make_hero();
	level.price.voice = "taskforce";
	level.price.countryID = "TF";
 	level.soap.animname = "soap";
	level.soap.disable_sniper_glint = 1;
	// currently using seal version, force voice to be taskforce
	level.soap.voice = "taskforce";
	level.soap.countryID = "TF";
	thread sandstorm_fx(4);
	level.chopper_fog_brushes = GetEntArray( "chopper_fog_brush", "targetname" );
	foreach ( brush in level.chopper_fog_brushes )
	{
		brush Hide();
        brush NotSolid();
	}
	
	maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");

	init_sandstorm_env_effects("s2_construction");

	objective_state( obj( "obj_kruger" ) , "done" );
	objective_state( obj( "obj_secondary_lz" ), "current");
	
	// Show compound exit vista
	GetEnt("compoundexit_vista", "targetname") Show();
	
	thread streets_construction();
	thread maps\payback_streets::sandstorm_timer();
	thread const_anims();
}
const_anims()
{
	wait 0.2;
	activate_trigger_with_targetname( "sjp_checkpoint_activate" );
	wait 2.8;
	flag_set( "start_construction_anims" );

}

start_s2_rappel()
{
	// AUDIO: jump/checkpoints
	aud_send_msg("s2_rappel");

	default_start( maps\payback_streets_const::start_s2_rappel );
	move_player_to_start();
	level.price = spawn_ally( "price" );
	level.soap = spawn_ally( "soap" );
	init_sandstorm_env_effects("s2_rappel");
	thread set_sandstorm_level( "medium" , 5.0 );
	thread sandstorm_fx(3,-2240);
	stop_exploder(3000);
	texploder(2300);
	exploder(2000);
	exploder(2500);
	exploder(4000);
	texploder(5300);
	exploder(5000);
	exploder(6000);
	objective_state( obj( "obj_kruger" ) , "done" );
	objective_state( obj( "obj_secondary_lz" ), "current");
	
	// Show compound exit vista
	GetEnt("compoundexit_vista", "targetname") Show();
	
	maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
	
	thread monitor_scaffold_fail();
	trigger_off( "strconst_retreat_trigger" , "targetname" );
	trigger_off( "const_roof_retreat_hurt" , "targetname" );
	
	thread spawn_construction_models();
	thread handle_wall_collapse( true );
	thread handleheli(); 
	thread handle_rappel_to_sandstorm();
	thread post_rappel_light();
	
}

init_construction_flags()
{
	flag_init( "strconst_combatstart" );
	flag_init( "strconst_wave2" );
	flag_init( "strconst_finished" );
	flag_init( "strconst_overrun_watch" );
	flag_init( "strconst_waveint");
	flag_init( "strconst_waveint_left");
	flag_init( "strconst_start_wallfall");
	flag_init( "strconst_fast_storm_start");
	flag_init( "player_upstairs_construction");
	flag_init( "strconst_start_wallfall_script");
	flag_init( "strconst_spawn_main");
	flag_init( "chopper_crashed");
	flag_init( "strconst_finished_ground");
	flag_init( "strconst_second_floor_all_dead");
	flag_init( "construction_heli_start_finished");
	flag_init( "const_rappel_player_finished" );
	flag_init( "sandstorm_intro_kill_chasers" );
	flag_init( "strconst_frame_fallen" );
	flag_init( "const_wallfall_screen_shake" );
	flag_init( "const_rappel_script_player_rappel" );
	flag_init( "waiting_on_chopper" );
	flag_init( "break_chain" );
}

streets_construction()
{
	//thread handle_vista_brush();

	trigger_off( "const_disable_outdoor_triggers" , "targetname" );
	//clean up stragglers from Dan's area.

	trigger_off( "strconst_retreat_trigger" , "targetname" );
	trigger_off( "const_roof_retreat_hurt" , "targetname" );
	
	lz2_obj = getstruct( "heli_lz2_objective" , "targetname" );
	Objective_Position( obj( "obj_secondary_lz" ) , lz2_obj.origin );
		
	hurt = GetEnt( "const_wallfall_hurt", "targetname" );
	if(isdefined( hurt ))
	{
		hurt trigger_off();
	}

	// AUDIO: music & ambience, for checkpoints and natural progression
	aud_send_msg("s2_construction"); 

	level.construction_spawned = 0;
	level.construction_waves = 0;
	level notify( "kill_color_replacements" );
	
	thread construction_lamps_thread();
	thread handle_wall_collapse();
	thread const_intro_vo();
	thread modify_construction_paths("wallfallclip" , true);
	thread wait_for_storm();
	thread monitor_scaffold_fail();
	thread monitor_player_blastzone();
	thread handle_mercs();
	thread handle_construction_waves();
	thread handle_initial_runner();
	thread handle_enemies_first_floor();
	thread handle_allies_moveup();
	thread iwrunners();
	thread watch_kill_ateam();
	thread post_rappel_light();
	thread spawn_construction_models();
	
	//level.barracus set_force_color( "blue" );
	
	
	handle_rappel_to_sandstorm();
	
}

spawn_construction_models()
{
	flag_wait("start_construction_anims");
	stairs_blocker_struct = GetStruct("roof_blocker_model","targetname");
	spawn_model_from_struct(stairs_blocker_struct);
	
	studwall_collapse_struct = GetStruct("studwall_collapse_model","targetname");
	spawn_model_from_struct(studwall_collapse_struct);
}

handle_rappel_to_sandstorm()
{
	thread const_rappel();

	flag_wait( "strconst_finished" );
	// cleanup after our area.
	
	thread maps\payback_sandstorm::sandstorm(); 
}

//VO
const_intro_vo()
{
	flag_wait("construction_intro_vo");
	flag_set( "streets_player_at_sec_LZ" ); //added DanO: this will shutdown all timer threads
	level.price dialogue_queue( "payback_pri_lzinsight" );
	wait 0.5;
	level.player radio_dialogue( "payback_nik_movefast" );

}

// Combat Flow Start

handle_construction_waves()
{
	thread modify_construction_paths("const_paths_to_modify" , false);
	flag_wait( "strconst_combatstart" );
	
	
	thread watch_player_stairs();
	thread start_left();
	flag_wait( "strconst_spawn_main" );
	array_spawn_targetname_allow_fail( "strconst_wave1_start" );
	thread handleheli(); 
}

price_hurry_stairs()
{
	flag_wait( "sjp_price_hurry" );
	level.price set_ignoreSuppression( 1 );
	level.price.old_baseaccuracy = level.price.baseaccuracy;
	level.price.baseaccuracy = 5000;
	level.soap.old_baseaccuracy = level.price.baseaccuracy;
	level.soap.baseaccuracy = 5000;
	
	level.price ClearEnemy();
	level.price disable_pain();
	level.price disable_cqbwalk();
	level.soap disable_cqbwalk();
	level.price set_ignoreall( 1 );
	level.price set_ignoreme( 1 );
	wait 1;
	level.price set_ignoreall( 0 );
	
	wait 4;
	
	level.price set_ignoreSuppression( 0 );
	level.price.baseaccuracy = level.price.old_baseaccuracy;
	level.soap.baseaccuracy = level.soap.old_baseaccuracy;
	level.price enable_pain();
	level.price set_ignoreme( 0 );
}
watch_kill_ateam()
{
	trigger = GetEnt( "const_kill_ateam", "targetname" );
	while(1)
	{
		trigger waittill( "trigger", ent );
		if(IsDefined(ent) && IsDefined(ent.script_forcecolor) )
		{
			if(ent.script_forcecolor == "b" )
			{
				if( IsDefined( ent.magic_bullet_shield ) && ent.magic_bullet_shield )
				{
					ent stop_magic_bullet_shield();
				}
				ent kill();
			}
			allies = getaiarray( "allies" );
			if(allies.size == 2)
			{
				break;
			}
		}
	}
}

iwrunners()
{
	thread price_hurry_stairs();
	flag_wait( "strconst_start_prerunners" );
	/*runners = [];
	runners = array_spawn_targetname_allow_fail( "strconst_pre_iwrunners" );
	
	foreach( runner in runners )
	{
		runner thread const_ignore_enemies( 20 );
	}
	*/
	flag_wait( "strconst_combatstart" );

	runners = array_spawn_targetname_allow_fail( "strconst_iwrunners" );
	foreach( runner in runners )
	{
		runner thread const_ignore_enemies( 20 );
	}
	
	flag_wait("strconst_wall_frame_fall");
	thread handle_crushedguy_a(); // runs close
	thread handle_crushedguy_b(); // runs far

	flag_wait( "strconst_start_wallfall_script_axis" );
	flag_set( "strconst_start_wallfall_script" );
}

handle_crushedguy_a()
{
	crushedguy_a = spawn_targetname("construction_crushedguy_a");
	crushedguy_a.animname = "generic";
	crushedguy_a thread const_ignore_enemies( 20 );
	crushedguy_a thread remove_traits();
	crushedguy_a endon("death");
	
	wait(3.45);
	
	crushedguy_a thread anim_single_solo(crushedguy_a,"wall_fall_a");
	crushedguy_a.allowdeath = true;
	crushedguy_a.deathfunction = ::only_ragdoll;
	
	wait(1.60);
	crushedguy_a kill();
}

remove_traits()
{
	self.grenadeawareness = 0;
	self.ignoreexplosionevents = true;
	self.ignorerandombulletdamage = true;
	self.disableBulletWhizbyReaction = true;
	self thread disable_pain();
	self thread disable_surprise();
}

handle_crushedguy_b()
{
	crushedguy_b = spawn_targetname("construction_crushedguy_b");
	crushedguy_b.animname = "generic";
	crushedguy_b thread const_ignore_enemies( 20 );
	crushedguy_b thread remove_traits();
	crushedguy_b endon("death");
	
	wait(3.30);
	
	crushedguy_b thread anim_single_solo(crushedguy_b,"wall_fall_b");
	crushedguy_b.allowdeath = true;
	crushedguy_b.deathfunction = ::only_ragdoll;
	
	wait(1.55);
	crushedguy_b kill();
}

only_ragdoll()
{
	self StartRagDoll();
}

wait_for_storm()
{
	flag_wait("strconst_fast_storm_start");
	thread set_sandstorm_level( "medium" , 10 );
}

//this is the Primary spawn for Construction, there is no left or right
start_left()
{
	flag_wait( "strconst_start_left" );
	array_spawn_targetname_allow_fail( "strconst_wave1") ;
	wait 0.5;
	flag_set( "strconst_spawn_main" );

}

/*
watch_failsafe()
{
	flag_wait( "sjp_kill_failsafe" );
	
	vol1 = GetEnt( "sjp_ground_floor", "targetname" );
	enemies = [];
	enemies = vol1 get_ai_touching_volume( "axis" );
	foreach(enemy in enemies)
	{
		enemy kill();
	}
}
*/

handle_allies_moveup()
{
	flag_wait( "sjp_ai_in_const" );
//	thread watch_failsafe();
	
	level.soap set_ignoreSuppression( true );
	level.price set_ignoreSuppression( true );
	wait 1.4;
	if( IsDefined (level.hannibal) )
	{
		level.hannibal disable_sprint();
		level.hannibal set_ignoreall( false );
	}
	if( IsDefined (level.murdock) )
	{
		level.murdock disable_sprint();
		level.murdock set_ignoreall( false );
	}
	if( IsDefined (level.barracus) )
	{
		level.barracus disable_sprint();
		level.barracus set_ignoreall( false );
	}

	
	
	wait_until_enemies_in_volume( "sjp_moveup_halfway_vol" , 0 );
	trigger_activate_targetname_safe( "sjp_moveup_halfway");
	
	wait_until_enemies_in_volume( "sjp_moveup_stairsground_vol" , 0 );
	
	trigger_activate_targetname_safe( "sjp_moveup_stairsground");
	
	// disable any triggers not tripped.
	triggers = [];
	triggers = GetEntArray( "sjp_disable_ground_interior", "targetname" );
	foreach( trigger in triggers)
	{
		trigger trigger_off();
	}
	
	// NEW: "First floor clear! Move!"
	level.price dialogue_queue( "payback_pri_1stfloorclear2" );
	wait 1.5;
	exploder(6000); // storm fx
//	// NEW: "Starting my approach to the LZ."
//	level.player radio_dialogue( "payback_nik_startingmyapproach" );
//	wait 1;	
//	// NEW: "We’ll meet you at the top, Nikolai."
//	level.price dialogue_queue( "payback_pri_meetyouattop" );
//	
	

	//disable_trigger_with_targetname( "sjp_disable_ground_interior" );
	
	flag_wait( "sjp_ai_firstfloor_const" );
	
	wait_until_enemies_in_volume( "sjp_ai_firstfloor_check_vol" , 0 );
	triggers = GetEntArray( "sjp_ai_firstfloor_disable", "targetname" );
	foreach(trigger in triggers)
		trigger trigger_off();
	trigger_activate_targetname_safe( "sjp_ai_firstfloor_check");
	
	// NEW: "Second floor clear! Keep moving!"
	level.price dialogue_queue( "payback_pri_2ndfloorclear" );


}



watch_player_stairs()
{
	flag_wait( "player_upstairs_construction");
//iprintlnbold ("watch_player_stairs flag tripped");
	trigger_off( "const_disable_inside_triggers" , "targetname" );
	//autosave_by_name( "save_construction_firstfloor" );
	//Start spawning the upstairs waves too now.
	//Get the first two guys already in place, and have the other two run into the scene as the player comes around the corner.
	wave2_enemies = array_spawn_targetname_allow_fail( "strconst_firstfloor_init" );
	flag_wait( "strconst_spawn_firstfloor_enemies" );
	wave2_enemies = array_combine(wave2_enemies, array_spawn_targetname_allow_fail( "strconst_firstfloor" ) );

	thread ai_array_killcount_flag_set(wave2_enemies,wave2_enemies.size,"strconst_second_floor_all_dead") ;
	watch_second_floor_all_dead();
	flag_wait( "strconst_on_second_floor" );
	trigger_off( "const_disable_floor1_triggers" , "targetname" );
}

watch_second_floor_all_dead()
{
	flag_wait( "strconst_second_floor_all_dead") ;

	level.soap set_ignoreSuppression( false );
	level.price set_ignoreSuppression( false );

}


cleanup_enemies_when_on_rooftop()
{
	enemies = getaiarray( "axis" );
	foreach ( enemy in enemies )
	{
		enemy Delete();
	}

	array_spawn_targetname_allow_fail( "strconst_wave_heliblast" );
	thread heli_rooftop_enemies();
	wait 1.5;
	
	enemies_to_player = array_spawn_targetname_allow_fail( "strconst_wave_heliplayer" );
	foreach ( enemy in enemies_to_player)
	{
		enemy attack_player();
	}
}

heli_rooftop_enemies()
{
	level endon("const_rappel_player_start");
	
	flag_wait("chopper_in_use_by_player");
	level.chopper_in_use = true;
	array_spawn_targetname_allow_fail( "strconst_wave_heliblast_rooftop" );
}

rooftop_runner()
{
	level endon("const_rappel_player_start");
	
	flag_wait("chopper_give_player_control");
	wait(8);
	if (flag("chopper_in_use_by_player"))
	{
		flag_set( "waiting_on_chopper" );
	}
}



construction_heli_start()
{
	//Nikolai, we're at the LZ.  Where are you?
	//Almost there.
	flag_wait("const_heli_start_vo");
	
	level.price dialogue_queue( "payback_pri_whereareyou" );
	level.player radio_dialogue( "payback_nik_almostthere" );
	flag_set("construction_heli_start_finished");
}

construction_heli_toohot()
{
	//The site is too hot!  I can't land!
	//Yuri, get on the remote turret and thin 'em out.
	if ( !flag("construction_heli_start_finished") )
	{
		flag_wait( "construction_heli_start_finished" );
	}
	
	level.player radio_dialogue( "payback_nik_sitetoohot" );
	level.price dialogue_queue( "payback_pri_turret" );
	
}

construction_heli_hit()
{
	
	//thread activate_heavy_sandstorm();
	
	// "I'm hit!! I'm hit!!!"
	level.player thread radio_dialogue( "payback_nik_imhit");
	
	wait 0.3;
	
	// "Baseplate, Nikolai’s bird is hit!"
	//level.player radio_dialogue( "payback_pri_nikolaibirdhit");
	
	//wait .2;
	//Uncomment for QUICKER_CRASH_SEQUENCE
	//I'm going down!!  I'm going  *static*
	//level.player radio_dialogue( "payback_nik_goingdown");
	if ( flag( "chopper_give_player_control" ) )
	{
		// teleport player to preferred spot
		playerwarp_post_heli_hit = getStruct( "playerwarp_post_heli_hit" , "targetname" );
		level.old_player_origin = playerwarp_post_heli_hit.origin;
		flag_waitopen( "chopper_give_player_control" );
	}
	else
	{
		level.player DisableWeapons();
	}
				
	level notify( "start_rappel_sequence" );

	//wait 0.3;	
	
	// "He's out of control!"
	level.price dialogue_queue( "payback_pri_outofcontrol" );
	
	wait 0.5;
	
	// "We've gotta get off this roof!"
	level.price dialogue_queue( "payback_pri_getoffroof" );
	
	// "Go! Use the ropes!"
	level.price dialogue_queue( "payback_pri_useropes" );

	enemies = GetAIArray( "axis" );
	to_delete = [];
	foreach ( enemy in enemies )
	{
		if ( !IsDefined( enemy.rappel_chaser ) || !enemy.rappel_chaser )
		{
			to_delete[to_delete.size] = enemy;
		}
	}
	thread AI_delete_when_out_of_sight(to_delete,128);

}

construction_heli_killplayer_check()
{
	level endon( "const_rappel_player_start" );
	level endon( "const_rappel_player_start_ledge" );
	
	wait(1);
	
	chopper_dir = ( 0 , -1 , 0 ); // TODO: get from something in the game
	
	while( IsDefined( level.chopper ) )
	{
		// use an ellipse to cheat distance
		to_chopper = ( level.player.origin - level.chopper.origin );
		dist_to_chopper = Length( to_chopper );
		to_chopper = VectorNormalize( to_chopper );
		dp = VectorDot( to_chopper , chopper_dir );
		scalar = 1.0 + 2.0 * ( 1.0 - abs( dp )); // sideways = greater scalar
		dist_to_chopper /= scalar;
		max_dist_to_chopper = 150;
		if ( flag("heli_kill_player_early") )
		{
			max_dist_to_chopper = 300;
		}
		if ( dist_to_chopper < max_dist_to_chopper )
		{
			level.player DoDamage( 50 , level.chopper.origin , level.chopper );
			setDvar( "ui_deadquote", &"PAYBACK_FAIL_CHOPPER" );
			if ( IsAlive(level.soap) )
			{
				level.soap stop_magic_bullet_shield();
				level.soap Kill();
			}
			wait 0.1;
			level.player Kill();
		}
		else
		{
			// determine speed of heli
			player_to_heli = VectorNormalize( level.chopper.origin - level.player.origin );
			player_forward = AnglesToForward( level.player GetPlayerAngles() );
			dp = VectorDot( player_to_heli , player_forward );
			speed = 1;
			if ( dp > 0.15 ) // roughly facing the helicopter (full speed)
			{
				speed = 1;
			}
			else if ( dp < 0 )
			{
				speed = 0.5;	
			}
			else
			{
				speed = ( dp / 0.15 ) + ( 1 - ( dp / 0.15 )) * 0.5;
			}
			level.chopper anim_set_rate_single( level.chopper , "heli_crash" , speed );
			level.heli_crash_roof_debris anim_set_rate_single( level.heli_crash_roof_debris , "heli_crash_roof_debris" , speed );
		}
		wait 0.05;		
	}
}

heli_earthquake()
{
	while ( IsDefined( self ) )
	{
		Earthquake( 0.333, 0.05, self.origin, 2000 );
		wait 0.05;
	}
}

fire_rpgs_at_chopper()
{
	rpg_spots = GetStructArray( "scripted_chopper_rpg_spot", "targetname" );
	
	if ( IsDefined( rpg_spots ) )
	{
		wait_time_min = 2.0;
		wait_time_max = 4.5;
		while ( flag( "chopper_give_player_control" ) && rpg_spots.size > 0 && IsDefined( level.chopper ) )
		{
			wait(RandomFloatRange(wait_time_min, wait_time_max));
			// need to check again because it may be become undefined in the window	
			if ( IsDefined( level.chopper ))
			{
				index = RandomInt( rpg_spots.size );
				
				rpg_spot = rpg_spots[ index ];
				
				rpg_target = level.chopper.origin + ( AnglesToForward( level.chopper.angles ) * RandomFloatRange( 500, 1000 ) );
				rpg_dir_norm = VectorNormalize(rpg_target - rpg_spot.origin);
				
				//extend rpg direction out 6000 units, see if it is behind the sandwall.  If so, try another spot
				test_dest_spot = rpg_spot.origin + rpg_dir_norm*6000;
				if ( test_dest_spot[1] < -1344 )
				{
					wait_time_min = 0.05;
					wait_time_max = 0.10;
				}
				// If trace to heli doesn't pass, try another spot
				else if ( !BulletTracePassed(rpg_spot.origin,rpg_target,false,undefined) )
				{
					wait_time_min = 0.05;
					wait_time_max = 0.10;
				}
				else
				{
					MagicBullet( "rpg", rpg_spot.origin, rpg_target );
					wait_time_min = 2.0;
					wait_time_max = 4.5;
					rpg_spots = array_remove( rpg_spots, rpg_spots[ index ] );
				}
			}
		}
	}
}

allow_chopper_gunner()
{
	wait .5;
	flag_clear( "chopper_should_strafe" );
	flag_set( "chopper_give_player_control" );
}

wait_till_all_allies_on_roof()
{
	roof_trigger = GetEnt("construction_roof_trigger","targetname");
	roof_trigger_prone = GetEnt("construction_roof_trigger_prone","targetname");
	
	everyone_on_roof = false;
	while(!everyone_on_roof)
	{
		if ( level.soap IsTouching(roof_trigger) && level.price IsTouching(roof_trigger) )
		{
			if ( level.player IsTouching(roof_trigger) )
			{
				everyone_on_roof = true;
			}
			else if ( level.player IsTouching(roof_trigger_prone) && (level.player GetStance() == "prone" || level.player GetStance() == "crouch") )
			{
				everyone_on_roof = true;
			}
		}
		wait(0.05);
	}
}

disable_const_roof_obj()
{
	wait(1);
	Objective_Position( obj( "obj_secondary_lz" ) , ( 0 , 0 , 0 ) );
}

handleheli()
{
	// use heli_tower_2 for QUICKER_CRASH_SEQUENCE
	level.heli_tower_struct = GetStruct( "heli_tower", "targetname" );
	
	level.heli_crash_roof_debris = GetEnt("heli_crash_roof_debris","targetname");
	level.heli_crash_roof_debris.animname = "payback_heli_crash";
	level.heli_crash_roof_debris SetAnimTree();
	level.heli_tower_struct thread anim_first_frame_solo( level.heli_crash_roof_debris , "heli_crash_roof_debris" );
	
	wait(0.05);
	const_roof_blocker_debris = GetEnt("roof_blocker_model","targetname");
	const_roof_blocker_debris.animname = "payback_const_crates";
	const_roof_blocker_debris SetAnimTree();
	level.const_rappel_spot thread anim_first_frame_solo(const_roof_blocker_debris,"debris_fall");

	thread construction_heli_start();
	flag_wait( "on_construction_roof");
	
	level.chopper_in_use = false;
	
	thread disable_const_roof_obj();
	
	wait_till_all_allies_on_roof();
	
	// block the stairs so you can't go back down and break everything
	blocker_vols = GetEntArray("construction_roof_blocker_volume","targetname");
	foreach(vol in blocker_vols)
	{
		vol Solid();
		vol DisconnectPaths();
	}
	level.const_rappel_spot thread anim_single_solo(const_roof_blocker_debris,"debris_fall");
	aud_send_msg("aud_crate_falls");
	
	thread manage_animation_blocking_vol();
	
	thread construction_retreat_handler();
	
	thread construction_heli_toohot();
	
	flag_set( "streets_player_at_sec_LZ" ); //added DanO: this will shutdown all timer threads
	thread cleanup_enemies_when_on_rooftop();
	
	flag_set( "chopper_final_ride" );
	
	level maps\payback_1_script_d::chopper_main(true);
	
	if ( !IsDefined(level.nikolai) )
	{
		level.nikolai = spawn_ally("nikolai", "nikolai_spawn_point");
	}

	thread nikolai_in_chopper();
	
	level.chopper.angles = ( 0, 0, 0 );
	level.chopper.animname = "payback_heli_crash";
	level.chopper SetAnimTree();
	level.heli_tower_struct thread anim_single_solo( level.chopper, "heli_crash" );
	
	thread chopper_crash_fx();

	thread rooftop_runner();
	
	level allow_chopper_gunner();

	level thread fire_rpgs_at_chopper();

	level.chopper waittillmatch( "single anim", "rpg_fire" );

	level.rpg = spawn( "script_model", level.heli_tower_struct.origin );
	level.rpg SetModel( "projectile_rpg7" );
	level.rpg.angles = ( 0, 0, 0 );
	level.rpg.animname = "payback_heli_crash";
	level.rpg SetAnimTree();
	level.heli_tower_struct thread anim_single_solo( level.rpg, "heli_crash_rpg" );
	PlayFxOnTag( level._effect[ "smoke_geotrail_rpg" ], level.rpg, "tag_origin" );
	level.rpg PlaySound( "weap_rpg_fire_npc" );
	level.rpg PlayLoopSound( "weap_rpg_loop" );
	aud_send_msg("chopper_prime"); // AUDIO: prime the streaming chopper sounds for the crash once the final RPG missile is launched
	level.chopper waittillmatch( "single anim", "rpg_hit" );
	aud_send_msg("chopper_play_static");
	rpg_hit_anim_time = level.chopper GetAnimTime(level.chopper GetAnim("heli_crash"));
	
	level.rpg Delete();
	level.rpg = undefined;
	
	level.chopper thread maps\payback_1_script_d::Chopper_Death_Handler();
	level.chopper thread maps\payback_1_script_d::Chopper_Death_Fx();
	
	//wait(0.3);    					// wait needs to be here to delay the visual effect to sync up the audio
	
	thread construction_heli_hit();
	
	if ( IsDefined( level.soap.node ))
	{
		level.soap teleport_ai( level.soap.node );
	}

	if ( flag( "chopper_give_player_control" ) )
	{
		flag_waitopen( "chopper_give_player_control" );
		level.chopper anim_self_set_time( "heli_crash", rpg_hit_anim_time );
		
		enemies = getaiarray( "axis" );
	    foreach ( enemy in enemies )
	    {
			if(isdefined(enemy) && isAlive( enemy ) )
			{
				enemy Delete();
			}
		}
	}
	
	level.heli_tower_struct thread anim_single_solo( level.heli_crash_roof_debris , "heli_crash_roof_debris" );
	
	thread construction_heli_killplayer_check();
	
	level.chopper thread heli_earthquake();
	level.chopper PlayRumbleLoopOnEntity( "steady_rumble" );

	level.chopper waittillmatch( "single anim", "end" );
	
	if ( IsDefined( level.chopper ) )
	{
		level.chopper Delete();
		level.chopper = undefined;
		//thread maps\payback_aud::delete_chopper_audio(); // do not fade out here since we're re-creating the chopper immediately following...
	}
	
	level.heli_crash_roof_debris delete();
}

manage_animation_blocking_vol()
{
	vol = GetEnt("construction_roof_blocker_volume_during_anim","targetname");
	vol Solid();
	
	wait(3);
	vol NotSolid();
}

chopper_crash_fx()
{
	
	texploder_delete(2300); // Docks / city
	stop_exploder(4000); // City 1
	stop_exploder(3001); // Gas
	// wood
	level.chopper_audio_damaged3 = Spawn( "script_origin", level.chopper_audio.origin );
	level.chopper_audio_damaged3 LinkTo( level.chopper_audio );
	
	level.chopper waittillmatch("single anim", "fx_tag1");
	//PlayFXOnTag(level._effect["payback_const_chopper_wood_splint"],level.chopper,"TAG_fx1");
	exploder(5002);
	thread maps\payback_aud::MM_add_submix_oneshot("mix_construction_chopper_debris", 0.1, 1.25, 0.5);
	level.chopper_audio_damaged3 PlaySound("pybk_chopper_down_debris01");
	//bricks
	level.chopper waittillmatch("single anim", "fx_tag2");
	thread maps\payback_aud::MM_add_submix_oneshot("mix_construction_chopper_debris", 0.1, 1.5, 0.5);
	level.chopper_audio_damaged3 PlaySound("pybk_chopper_down_debris02");
	construction_player_blocker = GetEnt( "construction_player_blocker", "targetname" );
	construction_player_blocker delete();
	//PlayFXOnTag(level._effect["fx_sparks_impact"],level.chopper,"TAG_fx2");
	exploder(5003);
	
	//?
	level.chopper waittillmatch("single anim", "fx_tag3");
	thread maps\payback_aud::MM_add_submix_oneshot("mix_construction_chopper_debris", 0.1, 2, 0.5);
	level.chopper_audio_damaged3 PlaySound("pybk_chopper_down_debris03");
	//PlayFXOnTag(level._effect["payback_const_chopper_wood_splint"],level.chopper,"TAG_fx3");
	exploder(5004);
	
	level.chopper waittillmatch("single anim", "fx_tag6");
	exploder(5005);
	
	// slide
	level.chopper waittillmatch("single anim", "fx_tag4");
	PlayFXOnTag(level._effect["payback_const_chopper_spark_runner"],level.chopper,"TAG_fx4");// wheel back
	PlayFXOnTag(level._effect["payback_const_chopper_spark_runner"],level.chopper,"TAG_fx5"); // back wing
	PlayFXOnTag(level._effect["payback_const_chopper_spark_runner"],level.chopper,"TAG_fx6"); // Wheel front
	PlayFXOnTag(level._effect["payback_const_chopper_spark_runner"],level.chopper,"TAG_fx7"); // front bottom
	
	// I beam
	level.chopper waittillmatch("single anim", "fx_tag5");
	PlayFXOnTag(level._effect["fx_sparks_impact"],level.chopper,"TAG_fx8");


	wait (2);
	level.chopper_audio_damaged3 delete();

}


nikolai_in_chopper()
{
	level.nikolai gun_remove();
	
	level.nikolai linkto( level.chopper , "tag_passenger" , ( 0 , 0 , 0 ) , ( 0 , 0 , 0 ) );
	level.chopper thread anim_generic_loop( level.nikolai , "nikolai_in_heli_loop" , "stop_nikolai_heli_loop", "tag_passenger");
	
	level.chopper waittillmatch( "single anim", "end" );

	level.nikolai notify("stop_nikolai_heli_loop");
	level.nikolai stop_magic_bullet_shield();
    level.nikolai delete();
    level.nikolai = undefined;
}

enable_jump_objective()
{
	level.rappel_obj = GetStruct( "const_rappel_obj" , "targetname" );
	Objective_SetPointerTextOverride( obj( "obj_secondary_lz" ) , &"PAYBACK_JUMP" );
	Objective_Position( obj( "obj_secondary_lz" ) , level.rappel_obj.origin );		
}

ai_go_to_rooftop_lookat_chopper( goal, animation, roof_entry_anim )
{
	//self enable_sprint();
	
	if ( IsDefined(roof_entry_anim) )
	{
		level.const_rappel_spot anim_reach_solo(self,roof_entry_anim);
		flag_wait("chopper_final_ride");
		
		level.const_rappel_spot anim_single_solo(self,roof_entry_anim);
	}
	
	self SetGoalNode( goal );
	
	self waittill( "goal" );
	
	self enable_cqbwalk();
	self cqb_aim( level.chopper );
	self AllowedStances( "crouch" );
	self.ignoreall = true;
	
	level waittill( "start_rappel_sequence" );
	self.ignoreall = false;
}

activate_heavy_sandstorm()
{
	sandstorm_fx(0);
	//thread set_sandstorm_level( "extreme" , 15, true ); 
}

chopper_hit_tower_fx()
{
	chopper_hit_tower_fx_spot = getStruct( "chopper_hit_tower_fx_spot" , "targetname" );
	PlayFx(level._effect[ "rock_impact_large" ], chopper_hit_tower_fx_spot.origin );
	aud_send_msg("chopper_crash", chopper_hit_tower_fx_spot.origin);
	aud_send_msg("mus_start_chopper_stinger");
}

construction_retreat_handler()
{
	level.player endon( "death" );
	level endon( "strconst_finished" );
	
	trigger_on( "strconst_retreat_trigger" , "targetname" );
	trigger_on( "const_roof_retreat_hurt" , "targetname" );
	
	flag_wait( "strconst_retreat_trigger" );
	
	spawners = GetEntArray( "strconst_retreat_stopper_backup" , "targetname" );
	
	ai = array_spawn_targetname_allow_fail( "strconst_retreat_stopper_init" );

	// Doing a manual array_wait_any() here as we need to add the thread to each guy individually
	// as opposed to batching it after each death which would build up additional notifies exponentially
	foreach ( guy in ai )
	{
		guy thread array_wait_set( "death", "array_wait_any_death" );
	}
	
	while( true )
	{
		level waittill( "array_wait_any_death" );
		ai = array_removeDead( ai );
		new_ai = spawners[ RandomIntRange( 0 , spawners.size ) ] spawn_ai();
		if ( IsDefined(new_ai) )
		{
			new_ai thread array_wait_set( "death", "array_wait_any_death" );
			ai[ai.size] = new_ai;
		}
	}
}

//Construction Site Rappel
const_rappel()
{
	level.const_rappel_spot = GetEnt( "const_rappel_spot" , "targetname" );
	
	disable_trigger_with_noteworthy( "trig_rope_jump_ledge" );
	disable_trigger_with_noteworthy( "trig_rope_jump_ledge_2" );
	
	
	//running jump
	level.const_player_rig_1 = spawn_anim_model( "const_player_rig_1" );
	level.const_player_rig_1 Hide();
	level.const_rappel_spot anim_first_frame_solo( level.const_player_rig_1 , "const_rappel_player" );
	
	level.const_player_rig_2 = spawn_anim_model( "const_player_rig_2" );
	level.const_player_rig_2 Hide();
	level.const_rappel_spot anim_first_frame_solo( level.const_player_rig_2 , "const_rappel_player" );
	
	//ledge jump
	level.const_player_rig_ledge_1 = spawn_anim_model( "const_player_rig_ledge_1" );
	level.const_player_rig_ledge_1 Hide();
	level.const_rappel_spot anim_first_frame_solo( level.const_player_rig_ledge_1 , "const_rappel_player" );
	
	level.const_player_rig_ledge_2 = spawn_anim_model( "const_player_rig_ledge_2" );
	level.const_player_rig_ledge_2 Hide();
	level.const_rappel_spot anim_first_frame_solo( level.const_player_rig_ledge_2 , "const_rappel_player" );
	
	level.const_rooftop_vol = GetEnt( "const_rooftop_vol" , "targetname" );
	price_spot = GetNode( "price_rooftop_teleport_spot" , "targetname" );
	soap_spot = GetNode( "soap_rooftop_teleport_spot" , "targetname" );
	
	price_goal = GetNode( "price_const_rooftop_spot" , "targetname" );
	soap_goal = GetNode( "soap_const_rooftop_spot" , "targetname" );
	
	if ( level.start_point == "s2_rappel" )
	{
		level.price thread teleport_if_too_far_away( price_spot , price_goal , "exposed_crouch_turn_180_right" );
	}
	else
	{
		level.price thread teleport_if_too_far_away( price_spot , price_goal , "exposed_crouch_turn_180_right" , "const_top" );
	}
	level.soap thread teleport_if_too_far_away( soap_spot , soap_goal , "exposed_crouch_turn_180_left" );
	
	thread post_chopper_crash_vo();
	thread rappel_rope_soap();
	thread rappel_rope_player();
	//thread rappel_rpg();
	//thread rpg_debris_explosion();
	
	level waittill( "start_rappel_sequence" );
	
	if ( IsDefined( level.soap.node ))
	{
		level.soap teleport_ai( level.soap.node );
	}
	
	kill_triggers = getEntArray( "strconst_fallkill" , "targetname" );
	array_thread( kill_triggers , ::trigger_off );
	
	level.price disable_sprint();
	level.price disable_cqbwalk();
	level.price AllowedStances( "stand", "crouch", "prone" );
	level.price anim_stopanimscripted();
	
	level.soap disable_sprint();
	level.soap disable_cqbwalk();
	level.soap AllowedStances( "stand", "crouch", "prone" );
	level.soap anim_stopanimscripted();
	
	level.price.goalradius = 30;
	level.price.animname = "price";
	level.soap.goalradius = 30;
	level.soap.animname = "soap";
	thread price_rappel_vo();
	//level.const_rappel_spot thread anim_reach_solo( level.soap , "const_rappel_soap" );
	//soap_rappel_wait_spot = GetNode( "soap_rappel_wait_spot" , "targetname" );
	//level.soap SetGoalNode( soap_rappel_wait_spot );
	
	thread const_rappel_price();
	thread const_rappel_soap_wave();
	
	level waittill( "const_rappel_player_can_jump" );
	enable_jump_objective();
	//wait 1;
	
	//thread rappel_enable_and_disable_weapons();
	
	//wait .5;
	
	enable_trigger_with_noteworthy( "trig_rope_jump_ledge" );
	enable_trigger_with_noteworthy( "trig_rope_jump_ledge_2" );
	
	thread rope_jump();
	
	level waittill( "clear_rope_obj" );
	thread activate_heavy_sandstorm();
	
	for ( i = 0; i < 8; i++ )
	{
		objective_additionalposition( obj( "obj_find_chopper" ), i, (0,0,0) );
		wait(0.25); // need this wait here to prevent a Reliable Command Buffer Overflow crash
	}

	setSavedDvar( "player_sprintSpeedScale", level.orig_player_sprint_speed );
	
	//thread const_rappel_enemies();
}

// teleport price and soap to the level below the top if the player rushes too fast and loses them
teleport_if_too_far_away( teleport_spot , goal , animation , roof_entry_anim )
{
	flag_wait( "move_allies_to_construction_roof" );
	
	self disable_ai_color();
	
	if( !self IsTouching( level.const_rooftop_vol ) )
	{
		self ClearEnemy();
		self teleport_ai( teleport_spot );
		self thread ai_go_to_rooftop_lookat_chopper( goal, animation, roof_entry_anim );
	}
	else
	{
		self thread ai_go_to_rooftop_lookat_chopper( goal, animation, roof_entry_anim );
	}
}

rappel_rope_soap()
{
	// spawn in the the rope that price and soap go down
	level.rappel_rope_soap = spawn_anim_model( "soap_rope" );

	// put it in an idle anim
	level.const_rappel_spot thread anim_loop_solo( level.rappel_rope_soap , "payback_const_rappel_rope_idle_2" , "stop_soap_rope_first_loop" );
}

rappel_rope_player()
{
	// spawn in the player's rope
	level.rappel_rope_player = spawn_anim_model( "player_rope" );
	
	// wait a bit so the ropes aren't in the same loop at the same time
	wait .4;
	
	level.const_rappel_spot thread anim_loop_solo( level.rappel_rope_player , "payback_const_rappel_rope_idle_1" , "stop_player_rope_first_loop" );
}

rappel_rpg()
{
	level waittill( "const_rappel_player_anim_started" );
	
	wait .25;
	
	rpg_rappel_spot = getstruct( "rpg_rappel_spot" , "targetname" );
	rpg_rappel_spot_target = getstruct( "rpg_rappel_spot_target" , "targetname" );
	magicBullet( "rpg_straight" , rpg_rappel_spot.origin + ( 20 , 0 , 40 ) , rpg_rappel_spot_target.origin + ( 40 , 40 , 42) );
	
	wait .75;
	
	rpg_rappel_spot = getstruct( "rpg_rappel_spot" , "targetname" );
	rpg_rappel_spot_target = getstruct( "rpg_rappel_spot_target" , "targetname" );
	magicBullet( "rpg_straight" , rpg_rappel_spot.origin, rpg_rappel_spot_target.origin + ( 0 , 0 , 32) );
	
	wait .1;
	
	rpg_rappel_spot = getstruct( "rpg_rappel_spot" , "targetname" );
	rpg_rappel_spot_target = getstruct( "rpg_rappel_spot_target" , "targetname" );
	magicBullet( "rpg_straight" , rpg_rappel_spot.origin, rpg_rappel_spot_target.origin );
}

rpg_debris_explosion()
{
	rpg_rappel_spot_target = getstruct( "rpg_rappel_spot_target" , "targetname" );
	level waittill( "const_rappel_player_anim_started" );
	wait 1.2;
	PlayFx( level._effect[ "debri_explosion" ], rpg_rappel_spot_target.origin );
	wait .1;
	PlayFx( level._effect[ "debri_explosion" ], rpg_rappel_spot_target.origin );
}
/*
const_rappel_price_finished()
{
	level.price.ignoreall = false;
	
	flag_wait( "const_rappel_player_finished" );
	
	level.price enable_ai_color();
	activate_trigger_with_targetname( "const_rappel_move_price" );
}
*/
const_rappel_price()	
{
	level.const_rappel_spot anim_reach_solo( level.price , "const_rappel_price" );
		
	level.const_rappel_spot notify( "stop_player_rope_first_loop" );

	level.const_rappel_spot anim_first_frame_solo( level.price, "const_rappel_price" );
	
	max_wait_time = 2.5;
	wait_time = 0;
	while ( wait_time < max_wait_time )
	{
		player_to_price = VectorNormalize( level.price.origin - level.player.origin );
		player_forward = AnglesToForward( level.player GetPlayerAngles() );
		dp = VectorDot( player_to_price , player_forward );
		if ( dp > 0.2 )
		{
			break;	
		}
		wait 0.05;	
		wait_time += 0.05;
	}
	
	thread price_rope_anim();
	level.const_rappel_spot thread anim_single_solo( level.price, "const_rappel_price" );
	if(level.chopper_in_use)
	{
		enable_jump_objective();
	}
	
	level.orig_player_sprint_speed = GetDvarFloat("player_sprintSpeedScale");
	setSavedDvar( "player_sprintSpeedScale", 1.4 );
	//wait 2.25;
	wait(1.5);
	level notify( "const_rappel_player_can_jump" );
	//level notify( "const_rappel_price_finished" );
	
	//const_rappel_price_finished();
}

const_rappel_soap_wave()
{
	level.const_rappel_spot endon( "stop_soap_rope_first_loop" );
	
	wait 1;
	level.soap AllowedStances( "stand" );
	wait 1;
	target_node = getNode( "soap_rappel_wait_spot" , "targetname" );
	level.soap.goalradius = target_node.radius;
	level.soap set_goal_node( target_node );
	
	level.soap AllowedStances( "stand" , "prone" , "crouch" );
	
	level.soap waittill( "goal" );
	/*
	ref = level.soap;	
	level.soap.rappel_waving = true;
	ref anim_first_frame_solo( level.soap , "payback_const_rappel_soap_wave" );
	//level.soap anim_self_set_time( "payback_const_rappel_soap_wave" , 0.22 );
	
	dp_limit = 0.4;
	while ( dp_limit > 0 )
	{
		player_to_soap = VectorNormalize( level.soap.origin - level.player.origin );
		player_forward = AnglesToForward( level.player GetPlayerAngles() );
		dp = VectorDot( player_to_soap , player_forward );
		if ( dp > dp_limit )
		{
			break;	
		}
		dp_limit -= 0.01;
		wait 0.05;	
	}
	
	ref anim_single_solo( level.soap , "payback_const_rappel_soap_wave" , undefined, 0.6 );
	level.soap.rappel_waving = undefined;
	ref anim_stopanimscripted();
	goal_node = GetNode( "soap_rappel_wait_spot" , "targetname" );
	level.soap SetGoalNode( goal_node );
	*/
}

post_rappel_gate_open( dude )
{		
	//thread gate_chain();
	flag_set("break_chain");
	
	block_vol = getEnt( "sstorm_entrance_gate" , "targetname" );
	block_vol ConnectPaths();
	block_vol delete();
	
	gate_rig = getent( "gate_rig", "targetname");
	gate_rig.animname = "sstorm_gate";
	gate_rig setanimtree();
	
	anim_origin = getstruct("gate_origin","targetname");
	
	anim_origin notify("stop_gate_loop");
	anim_origin anim_single_solo( gate_rig ,"gate_windy_open");
	anim_origin thread anim_loop_solo( gate_rig , "gate_loop", "stop_gate_loop" );
}

gate_chain(chain_model, anim_origin)
{
	flag_wait("break_chain");
	
	anim_origin notify("gate_1_stop");
	anim_origin anim_single_solo( chain_model ,"chain_windy_open");
}

price_rope_anim()
{
	level endon( "const_rappel_player_start" );
	level endon( "const_rappel_player_start_ledge" );
	aud_send_msg("rappel_npc", level.price); // AUDIO: rappel for price
	level.const_rappel_spot anim_single_solo( level.rappel_rope_player, "const_rappel_price" );
	
	level.const_rappel_spot thread anim_loop_solo( level.rappel_rope_player , "payback_const_rappel_rope_idle_1" , "stop_player_rope_second_loop" );
}

/*
rappel_enable_and_disable_weapons()
{
	level endon( "const_rappel_player_start" );
	level endon( "const_rappel_player_start_ledge" );
	while(1)
	{
		flag_wait( "rappel_disable_weapons" );
		level.player DisableWeapons();
		flag_waitopen( "rappel_disable_weapons" );
		level.player EnableWeapons();
	}
}
*/

rope_jump()
{
	self endon( "death" );
	self endon( "const_rappel_player_start_ledge" );
	level endon( "const_rappel_player_start_ledge" );
	
	level.killtrig = GetEnt( "kill_trig_rope_jump", "script_noteworthy" );
	level.killtrig thread rope_jump_kill_trig();
	
	player_rappel_intro_ents = [];
	player_rappel_intro_ents[ 0 ] = level.rappel_rope_player;
	
	// catch the jump
	jumpstart_vol_2 = GetEnt( "trig_rope_jump_2", "script_noteworthy" );
	thread player_jump_watcher();
	
	thread rappel_check_player_jump();
	thread rappel_check_player_fall();
	flag_wait( "const_rappel_script_player_rappel" );
	jump = level.rappel_player_jumped_off_ledge;
	
	if ( jump )
	{
		player_rappel_intro_ents[ 1 ] = level.const_player_rig_1;
	}
	else
	{
		jumpstart_vol_2 = GetEnt( "trig_rope_jump_ledge_2", "script_noteworthy" );
		player_rappel_intro_ents[ 1 ] = level.const_player_rig_ledge_1;
	}
	
	level notify( "const_rappel_player_start" );
	
	hide_hud_for_scripted_sequence();
	
	level notify( "clear_rope_obj" );
	
	// Uncomment for QUICKER_CRASH_SEQUENCE
	level.heli_tower_struct thread heli_crash_rappel_anim();
	//  put this here so the obj marker stays on until the chopper is hit
	objective_state( obj( "obj_secondary_lz" ), "done" );
	
	thread const_rappel_soap();
	
	level.killtrig Delete();
	
	aud_send_msg("rappel_player"); // AUDIO: player rappel sound
	
	level.player AllowJump( false );
	level.player AllowCrouch( false );
	level.player AllowProne( false );
	level.player DisableWeaponSwitch();
	level.player DisableOffhandWeapons();
	
	// "Juuuuump!"
	level.soap thread dialogue_queue( "payback_mct_jump" );

	level.player EnableInvulnerability();
	
	// if the player is to the side of the rope, play the slanted intro
	if( level.player IsTouching( jumpstart_vol_2 ) )
	{
		if ( jump )
		{
			player_rappel_intro_ents[ 1 ] = level.const_player_rig_2;
		}
		else
		{
			player_rappel_intro_ents[ 1 ] = level.const_player_rig_ledge_2;
		}
	}
	thread rope_jump_player_blend_to_anim( player_rappel_intro_ents[ 1 ] , 0.1 );
	player_rappel_intro_ents[ 1 ] delaycall( 0.1, ::Show );
	level.const_rappel_spot notify( "stop_player_rope_second_loop" );
	level.rappel_rope_player anim_stopanimscripted();
	
	thread sandstorm_extreme_fog_transitions();
	level notify( "const_rappel_player_anim_started" );
	sslight_01 = GetEnt( "sslight_01" , "targetname" );
	sslight_01 SetLightIntensity( 7 );
		
	street_light_gate = GetEnt( "street_light_gate" , "targetname" );
	street_light_gate SetLightIntensity( 3 );
	
	level.const_rappel_spot anim_single( player_rappel_intro_ents, "const_rappel_player" );

		
	level.player DisableInvulnerability();
	flag_set( "sandstorm_intro_kill_chasers" );
	flag_set( "const_rappel_player_finished" );
	
	show_hud_after_scripted_sequence();
	
	level.const_rappel_spot thread anim_loop_solo( level.rappel_rope_player , "payback_const_rappel_rope_idle_1" );
	                                    
	level.player Unlink();
	level.const_player_rig_1 Delete();
	level.const_player_rig_2 Delete();
	
	level.const_player_rig_ledge_1 Delete();
	level.const_player_rig_ledge_2 Delete();
	
	level.player EnableWeapons();
	level.player EnableWeaponSwitch();
	level.player EnableOffhandWeapons();
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player AllowJump( true );
	
}

rappel_check_player_jump()
{
	level endon( "const_rappel_player_start" );

	jumpstart_vol = GetEnt( "trig_rope_jump", "script_noteworthy" );
	altLookSpots = GetStructArray( "struct_rope_jump_alt_lookspot", "targetname" );
	ASSERT( altLookSpots.size );
	
	while( 1 )
	{
		while( level.player IsTouching( jumpstart_vol ) )
		{
			const_rappel_obj = getstruct( "const_rappel_obj" , "targetname" );
			flag_wait( "player_jumping" );
			if( player_leaps_to_rope( jumpstart_vol, const_rappel_obj, altLookSpots, true ) )
			{
				level.rappel_player_jumped_off_ledge = true;
				flag_set( "const_rappel_script_player_rappel" );
				return;
			}
			wait( 0.05 );
		}
		wait( 0.05 );
	}
}

rappel_check_player_fall()
{
	level endon( "const_rappel_player_start" );

	flag_wait( "trig_rope_jump_ledge" );

	jumpstart_vol = GetEnt( "trig_rope_jump_ledge", "script_noteworthy" );
	
	player_to_obj = VectorNormalize( level.rappel_obj.origin - level.player.origin );
	player_forward = AnglesToForward( level.player GetPlayerAngles() );
	while ( VectorDot( player_to_obj , player_forward ) < 0.5 )
	{
		wait 0.05;
		if ( !level.player IsTouching( jumpstart_vol ))
		{
			flag_clear(  "trig_rope_jump_ledge" );
			flag_wait( "trig_rope_jump_ledge" );
		}
		player_to_obj = VectorNormalize( level.rappel_obj.origin - level.player.origin );
		player_forward = AnglesToForward( level.player GetPlayerAngles() );
	}
	level.rappel_player_jumped_off_ledge = false;
	flag_set( "const_rappel_script_player_rappel" );
}

heli_crash_rappel_anim()
{
	/*Does not work??
	StopFXOnTag(level._effect["payback_const_chopper_spark_runner"],level.chopper,"TAG_fx4");// wheel back
	StopFXOnTag(level._effect["payback_const_chopper_spark_runner"],level.chopper,"TAG_fx5"); // back wing
	StopFXOnTag(level._effect["payback_const_chopper_spark_runner"],level.chopper,"TAG_fx6"); // Wheel front
	StopFXOnTag(level._effect["payback_const_chopper_spark_runner"],level.chopper,"TAG_fx7"); // front bottom
	*/
	
	texploder_delete(5300);
	stop_exploder(5000);//const
	exploder(5006);
	
	debris = Spawn( "script_model", level.heli_tower_struct.origin );
	debris SetModel( "pb_heli_crash_rappel_debris" );
	debris.animname = "payback_heli_crash";
	debris SetAnimTree();
	level.heli_tower_struct thread anim_single_solo( debris , "heli_crash_rappel_debris" );
	level.heli_tower_struct anim_single_solo( level.chopper , "heli_crash_rappel" );

	aud_send_msg("chopper_crash", level.chopper.origin); // AUDIO: stub in invisible chopper crash sound
	level notify( "chopper_hit_tower" );
	wait 0.05;
	if ( IsDefined( level.chopper ) )
	{
		level.chopper Delete();
		level.chopper = undefined;
		//thread maps\payback_aud::delete_chopper_audio(); // do not fade out here since we're re-creating the chopper immediately following...
	}
}

rope_jump_kill_trig()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( IsPlayer( other ) )
		{
			SetDvar( "ui_deadquote", "@PAYBACK_USE_THE_ROPE" );
			maps\_utility::missionFailedWrapper();
		}
		
		wait( 0.05 );
	}
}

player_leaps_to_rope( volume, player_rope, altLookSpots, checkIsOnGround )
{
	if( !IsDefined( checkIsOnGround ) )
	{
		checkIsOnGround = true;
	}
	
	if( !volume IsTouching( level.player ) )
	{
		return false;
	}
	
	if ( level.player GetStance() != "stand" )
	{
		return false;
	}
	
	if( checkIsOnGround && level.player IsOnGround() )
	{
		return false;
	}
	
	// need to be looking at the ladder or at one of our alternate look spots while jumping for it
	lookingGood = true;
	
	refPoint = player_rope.origin;  // uses the same offset as the objective indicator  was :refPoint = player_rope.origin + ( 0, 0, -84 );
	fov = GetDvarInt( "cg_fov" );
	if( !level.player WorldPointInReticle_Circle( refPoint, fov, 100 ) )  // was 120
	{
		lookingGood = false;
	}
	
	if( !lookingGood )
	{
		foundOne = false;
		foreach( spot in altLookSpots )
		{
			//print3d( spot.origin, "*", ( 1, 1, 1 ), 1, 1, 60 );
			
			if( level.player WorldPointInReticle_Circle( spot.origin, fov, 165 ) )  // was 165
			{
				foundOne = true;
				break;
			}
		}
		
		if( foundOne )
		{
			lookingGood = true;
		}
	}
	
	if( !lookingGood )
	{
		return false;
	}

	vel = level.player GetVelocity();
	// figure out the length of the vector to get the speed (distance from world center = length)
	velocity = Distance( ( vel[ 0 ], vel[ 1 ], 0 ), ( 0, 0, 0 ) );  // don't care about Z velocity
	//IPrintLnBold( velocity );
	if ( velocity < 115 ) // was 145
	{
		return false;
	}
	
	return true;
}

player_jump_watcher()
{
	level endon( "player_jump_watcher_stop" );
	
	jumpflag = "player_jumping";
	if( !flag_exist( jumpflag ) )
	{
		flag_init( jumpflag );
	}
	else
	{
		flag_clear( jumpflag );
	}
	
	NotifyOnCommand( "playerjump", "+gostand" );
	NotifyOnCommand( "playerjump", "+moveup" );
	
	while( 1 )
	{
		level.player waittill( "playerjump" );
		wait( 0.1 );  // jumps don't happen immediately
		
		if( !level.player IsOnGround() )
		{
			flag_set( jumpflag );
			println( "jumping" );
		}
		
		while( !level.player IsOnGround() )
		{
			wait( 0.05 );
		}
		flag_clear( jumpflag );
		println( "not jumping" );
	}
}
sandstorm_extreme_fog_transitions()
{
	maps\_sandstorm::blizzard_level_transition_extreme_fog_novision(.5,0.05);
	//maps\_sandstorm::blizzard_level_transition_extreme_fog(3.4,1.05);
	wait(1.25);
	thread set_sandstorm_level( "extreme" , 9); 
}
rope_jump_player_blend_to_anim( rig , time )
{
	level.player PlayerLinkToBlend( rig , "tag_player" , time );
}

const_rappel_soap()	
{
	level.soap disable_ai_color();
	
	level.const_rappel_spot notify( "stop_soap_rope_first_loop" );
	
	if ( IsDefined( level.soap.rappel_waving ))
	{
		level.soap anim_stopanimscripted();
		wait 0.05;
	}
	
	thread soap_rope_anim();
	thread price_rappel_end_anim();
	level.const_rappel_spot anim_single_solo( level.soap, "const_rappel_soap" );
	level.soap anim_generic(level.soap, "corner_standR_trans_A_2_B");
	level.soap enable_ai_color();
	wait 1;

/*
	level.soap thread anim_generic_loop(level.soap, "corner_standR_alert_idle");
	
	level.soap enable_ai_color();
	wait 1;
	if (!flag("sandstorm_market_stall_tear"))// hijacked this to save on a trigger and flag
	{
		level.soap StopAnimScripted();
		level.soap anim_generic(level.soap, "corner_standR_trans_A_2_B");
	}
*/
	trig = GetEnt("soap_into_sandstorm", "targetname");
	if (IsDefined(trig))
	{
		try_activate_trigger_targetname( "soap_into_sandstorm" );
	}
	
	// "Go, go, go!" 
	//radio_dialogue( "payback_mct_gogogo2_r" );
}



price_rappel_end_anim()
{
	level.price disable_ai_color();
	level.price anim_stopanimscripted();
	level.const_rappel_spot anim_single_solo( level.price, "const_rappel_end_price" );
	level.price enable_ai_color();
	try_activate_trigger_targetname( "allies_into_sandstorm" );
}

try_activate_trigger_targetname(msg)
{
	trigger = GetEnt( msg, "targetname" );
	if ( isdefined(trigger) && !isdefined(trigger.trigger_off) )
	{
		trigger activate_trigger();
	}
}


soap_rope_anim()
{
	aud_send_msg("rappel_npc", level.soap); // AUDIO: rappel for soap
	level.const_rappel_spot anim_single_solo( level.rappel_rope_soap, "const_rappel_soap" );
	
	level.const_rappel_spot thread anim_loop_solo( level.rappel_rope_soap , "payback_const_rappel_rope_idle_2" );
}

/* Caleb is putting the gun back in the anim, we don't need this anymore
soap_put_guns_back_in_hands( soap )
{
	level.soap place_weapon_on( "m4_grenadier", "right" );
}
*/

price_put_guns_back_in_hands( price )
{
	level.price place_weapon_on( "m4_grenadier", "right" );
}

post_chopper_crash_vo()
{
	level waittill( "start_rappel_sequence" );
	
	thread const_rooftop_pressure();
	//thread move_price_to_vo_position();
	//thread move_soap_to_vo_position();
	
	wait 1;
	
	autosave_now();
	

	// "Baseplate, Nikolai’s bird is down in the city."
	//level.player radio_dialogue( "payback_pri_downincity" );
	
	wait .3;
	
	// "Solid Copy.  Do you have a visual on the crash site?"
	//level.player radio_dialogue( "payback_eol_visualoncrash" );
	
	//wait .3;
	
	// "Negative. The sandstorm is on top of us."
	//level.player radio_dialogue( "payback_pri_negativesandstorm" );
	
	//wait .5;
	
	// "We need to get to the crash site and find Nikolai."
	//level.price dialogue_queue( "payback_pri_gettocrashsite" );
	
	//Update the objective
	objective_state ( obj( "obj_find_chopper" ), "current");
	
	// Comment out for QUICKER_CRASH_SEQUENCE
	//level notify( "start_rappel_sequence" );
}

price_rappel_vo()
{
	level endon( "const_rappel_player_start" );
	level endon( "const_rappel_player_start_ledge" );
	
	autosave_now();
	
	// "Jump to the ropes. Let’s go."
	//level.price dialogue_queue( "payback_pri_jumpthroughropes" );
	
	//level waittill( "const_rappel_price_finished" );
	
	return;
	/*
	wait 6;
	
	while(1)
	{
		// "Yuri, jump to the rope."
		level.price dialogue_queue( "payback_pri_yurijumprope" );
		
		wait 6;
		
		// "I’ve got you covered. Jump, Yuri."
		level.price dialogue_queue( "payback_pri_gotyoucovered2" );
		
		wait 6;
		
		// "Jump and slide down, Yuri!"	
		level.price dialogue_queue( "payback_pri_jumpandslide" );
		
		wait 6;
	}
	*/
}

move_price_to_vo_position()
{
	level.price.ignoreall = true;
	
	level.price ClearEnemy();
	
	price_vo_position = GetNode( "price_const_rooftop_cover" , "targetname" );
	
	level.price SetGoalNode( price_vo_position );
}

move_soap_to_vo_position()
{
	soap_vo_position = GetEnt( "soap_const_rooftop_cover" , "targetname" );
	
	level.soap SetGoalVolumeAuto( soap_vo_position );
}

const_rooftop_pressure()
{
	activate_trigger_with_targetname( "const_rooftop_pressure_trigger" );
	
	flag_wait( "const_rappel_player_finished" );
	
	const_rooftop_pressure = get_ai_group_ai( "const_rooftop_pressure" );
	foreach( guy in const_rooftop_pressure )
 	{
		guy.dieQuietly = true;
 		guy kill();
 	}
	
	enemies = getaiarray( "axis" );
	
//	goalVolume = getEnt( "const_retreat_volume" , "targetname" );
//	goalVolumeTarget = getNode( goalVolume.target , "targetname" );
//
//	foreach ( enemy in enemies )
//	{
//		if ( IsAlive( enemy ))
//		{
//			enemy.sprint = true;
//			enemy SetGoalNode( goalVolumeTarget );
//			enemy SetGoalVolume( goalVolume );
//		}
//	}
//
//	wait 5;
	foreach ( enemy in enemies )
	{
		if(isdefined(enemy) && isAlive( enemy ) )
		{
			enemy Delete();
		}
	}
}

//End of combat flow logic

//Utility type functions for the area.

/*
const_rappel_enemies()
{
	level.rappel_chasers = [];
	
	thread const_rappel_enemy_floor( 1 );
	thread const_rappel_enemy_floor( 2 );
	thread const_rappel_enemy_floor( 3 );
	
	flag_wait( "sandstorm_intro_kill_chasers" );
	
	level.rappel_chasers = array_removeDead( level.rappel_chasers );
	foreach( guy in level.rappel_chasers )
 	{
		guy.dieQuietly = true;
 		guy kill();
 	}
}

const_rappel_enemy_floor( floor_num )
{
	targetname = "payback_rappel_chaser_floor_" + floor_num;
	spawner = getEnt( targetname , "targetname" );
	count = spawner.count;
	for ( i = 0 ; i < count ; i++ )
	{
		if ( flag( "sandstorm_intro_kill_chasers" ))
		{
			break;
		}
		ai = spawner spawn_ai();
		ai.rappel_chaser = true;
		ai waittill_spawn_finished();
		// reset from militia crap
		if ( IsDefined( ai.script_accuracy ))
		{
			ai.baseAccuracy = ai.script_accuracy;
		}
		level.rappel_chasers[level.rappel_chasers.size] = ai;
		wait 1.5;
	}
}
*/

attack_player()
{
	self.goalradius 		= 64;
	self setgoalentity( level.player );
}

attack_price()
{
	self.goalradius 		= 64;
	self setgoalentity( level.player );
}


handle_mercs()
{
	//Allow all the mercs to die, and force one of them to run under the wall.

	blockers = getentarray( "const_exitblocker" , "targetname" );
	array_call( blockers , ::hide );

	mercs = [];
	if( IsDefined (level.hannibal) )
	{
		mercs[mercs.size] = level.hannibal;
	}
	if( IsDefined (level.murdock) )
	{
		mercs[mercs.size] = level.murdock;
	}
	if( IsDefined (level.barracus) )
	{
		mercs[mercs.size] = level.barracus;
	}
	

	
	merctodie = undefined ;
	senttowall = false;
	wallnode = getnode( "wallfall_wait" , "targetname" );
	foreach( merc in mercs )
	{
		// ignore supression so they are more likely to run into oncoming bullets.
		
		merc set_ignoreSuppression( 1 );
		merc enable_sprint();
		merc.health = 1;
		merc set_ignoreall( true );
		
		
		if(IsDefined( merc.magic_bullet_shield ) && merc.magic_bullet_shield)
		{
			merc stop_magic_bullet_shield();
		}
	}
	flag_wait( "strconst_combatstart" );
	thread wallfall_failsafe( 90 );	
	
	thread watch_good_wallfall_time();
	thread watch_wallfall_must_start();	
	flag_wait( "strconst_start_wallfall_script" );
	flag_wait( "strconst_frame_fallen" );
	
	wall_wait_time = 2.0;
	//HERE
	level.price dialogue_queue( "payback_pri_thewall" );
	//handle_wall_collapse();
	flag_wait( "const_wallfall_screen_shake" );
	//wait wall_wait_time;
	Earthquake( 0.7, 1.0, wallnode.origin, 2000 );
	thread handle_hurt_trigger();
	//Invalidate any paths in the vicinity of the fallen rubble.
	modify_construction_paths( "wallfallclip" , false);
	wait 1;
	array_call( blockers , ::show );
	brushes = getentarray( "wallfallclip" , "targetname" );
	foreach( brush in brushes)
	{
		brush Solid();
	}

	level.price set_battlechatter(true);
	
	disable_trigger_with_targetname( "player_rubble_kill" );
}

handle_hurt_trigger()
{
	hurt = GetEnt( "const_wallfall_hurt", "targetname" );
	if(isdefined( hurt ))
	{
		hurt trigger_on();
		wait 0.1;
		hurt notify( "trigger" );
		wait 0.1;
		hurt activate_trigger();
		wait 1;
		hurt trigger_off();
	}
}


watch_good_wallfall_time()
{
	while(1)
	{
		flag_wait( "looking_at_wall" );
		{
			
			//Make sure been looking there for a short while, not panning across
			flag_set( "strconst_start_wallfall_script" );
			break;
			
			
			
		}
			
		
	}
	
}
watch_wallfall_must_start()
{
	flag_wait( "const_wallfailsafe" );
	
	flag_set( "strconst_start_wallfall_script" );

}

wallfall_failsafe( towaittime )
{
	wait towaittime ;
	flag_set( "strconst_start_wallfall_script" );
}

handle_initial_runner()
{
	flag_wait("strconst_combatstart");
//	array_spawn_targetname_allow_fail( "strconst_initial_runner" );
	/*
	runners = array_spawn_targetname_allow_fail( "strconst_initial_runner_bold" );
	foreach( runner in runners )
	{
		runner.ignoresuppression = true;
		runner disable_surprise();
		runner.disableBulletWhizbyReaction = true;
		runner.a.disablePain = true;
	}
	
*/
	
//	disable_payback_node( "startrunner" );
/*
	runnernodes = getnodearray( "runner_cover" , "targetname" );
	currnode = 0;
	if(runnernodes.size == 0 || runnernodes.size < runners.size )
	{
		return;
	}

	foreach( runner in runners )
	{

		runnernode = runnernodes[currnode];
		currnode++;
		if(IsDefined( runnernode ))
		{
			runner SetGoalNode( runnernode );
		}
	}
	//Give the runners chance to get out the AI / player's way.
	wait 1;
	foreach( runner in runners )
	{
		if ( IsDefined( runner.magic_bullet_shield ) )
		{
			runner stop_magic_bullet_shield();
		}
	}
*/	
		
}

handle_enemies_first_floor()
{
	flag_wait("strconst_waveint");
	// "We need to push to the top floor.  Let's move."
	level.price dialogue_queue( "payback_pri_topfloor" );
}

watch_enemies_first()
{
	while(1)
	{
		ent = flag_wait("ai_alive_on_first_floor");
		ent attack_player();
		flag_clear( "ai_alive_on_first_floor");
		if(flag("player_upstairs_construction"))
		{
			break;
		}		
	}
}

//Animated Specials inside the construction yard.

start_wall_loop()
{
	anim_start = GetStruct("construction_anim_origin","targetname");
	wall = GetEnt("wall_collapse_model","targetname");
	wall.animname = "payback_wall_collapse";
	wall useAnimTree( level.scr_animtree[ wall.animname ] );
	anim_start thread anim_loop_solo(wall, "wall_idle_loop","stop_wall_loop");
}

wall_fx()
{
	PlayFXOnTag(level._effect["payback_sand_wall_shake"],self,"tag_fx_1");
	//wait(0.5); // 4.8 seconds to impact
	PlayFXOnTag(level._effect["payback_sand_wall_shake"],self,"tag_fx_2");
	//wait(0.5); // 4.8 seconds to impact
}

handle_wall_collapse( fall_fast )
{
	if ( !IsDefined( fall_fast ))
	{
		fall_fast = false;	
	}
	
	ref = GetStruct( "construction_anim_origin" , "targetname" );
	frame = GetEnt( "const_wall_frame" , "targetname" );
	frame.animname = "const_wall_frame";
	scaffolding = GetEnt( "const_wall_scaffold" , "targetname" );
	scaffolding.animname = "const_wall_scaffold";
	wall = GetEnt( "const_wall_wall" , "targetname" );
	wall.animname = "const_wall_wall";
	side_wall = GetEnt( "const_wall_side_wall" , "targetname" );
	side_wall.animname = "const_wall_side_wall";
	final_debris = GetEnt( "const_wall_final_debris" , "targetname" );
	final_debris.animname = "const_wall_final_debris";
	
	all_pieces = [ frame , scaffolding , wall , side_wall , final_debris ];
	array_thread( all_pieces , ::SetAnimTree );
	// first frame
	ref anim_first_frame( all_pieces , "fall" );
	// frame
	if ( !fall_fast )
	{
		flag_wait( "strconst_wall_frame_fall" );
	}
	ref thread anim_single_solo( frame , "fall" );
	if ( fall_fast )
	{
		anim_set_rate_single( frame , "fall" , 50 );
	}
	all_pieces = array_remove( all_pieces , frame );
	if ( !fall_fast )
	{
		wait 0.05;
	}
	flag_set( "strconst_frame_fallen" );
	// everything else
	if ( !fall_fast )
	{
		flag_wait( "strconst_start_wallfall_script" );
	}
	ref thread anim_single( all_pieces , "fall" );
	if ( fall_fast )
	{
		anim_set_rate( all_pieces , "fall" , 50 );
	}
	else
	{
		aud_send_msg("wall_collapse", wall.origin);
		exploder(5001);	// Initial gust of debris
		stop_exploder(2500);
		
		wall thread wall_fx();
	}
	thread handle_studwall_collapse( ref , fall_fast );
}

handle_wall_collapse_old()
{
	anim_start = GetStruct("construction_anim_origin","targetname");
	wall = GetEnt("wall_collapse_model","targetname");
	wall notify("stop_wall_loop");
	wall.animname = "payback_wall_collapse";
	wall useAnimTree( level.scr_animtree[ wall.animname ] );
	anim_start thread anim_single_solo(wall, "wall_collapse");
	aud_send_msg("wall_collapse", wall.origin);
	
	exploder(5001);	// Initial gust of debris
	
	thread handle_studwall_collapse( anim_start );
}

handle_studwall_collapse( anim_start , fall_fast )
{
	if ( !fall_fast )
	{
		wait 2; // give the wall some time to fall
	}
	studwall = GetEnt( "studwall_collapse_model" , "targetname" );
	studwall.animname = "payback_studwall_collapse";
	studwall useAnimTree( level.scr_animtree[ studwall.animname ] );
	anim_start thread anim_loop_solo( studwall , "payback_studwall_collapse_loop" , "stop_studwall_loop" );
	if ( !fall_fast )
	{
		flag_wait( "construction_studwall_collapse" );
	}
	studwall notify( "stop_studwall_loop" );
	
	// "Watch it!"
	level.price thread dialogue_queue( "payback_pri_watchit" );
	
	anim_start thread anim_single_solo( studwall , "payback_studwall_collapse" );
	if ( fall_fast )
	{
		studwall anim_set_rate_single( studwall ,  "payback_studwall_collapse" , 50 );
	}
	else
	{
		aud_send_msg("studwall_collapse", studwall.origin); // AUDIO
	}

	wait 1.1;
	
	// NEW: "Starting my approach to the LZ."
	level.player radio_dialogue( "payback_nik_startingmyapproach" );
	wait 0.5;	
	
	// NEW: "We’ll meet you at the top, Nikolai."
	level.price dialogue_queue( "payback_pri_meetyouattop" );
	

}

handle_scaffold_collapse()
{
	
	anim_start = GetStruct("construction_anim_origin","targetname");
	scaffold = GetEnt("payback_scaffolding_collapse","targetname");
	scaffold.animname = "payback_scaffolding_collapse";
	scaffold useAnimTree( level.scr_animtree[ scaffold.animname ] );
	anim_start thread anim_single_solo(scaffold, "payback_scaffolding_collapse");
	aud_send_msg("scaffolding_collapse", scaffold.origin); // AUDIO
	
	
}

monitor_scaffold_fail()
{
	flag_wait( "strconst_trigger_scaffold_anim" );
	handle_scaffold_collapse();
}



monitor_player_blastzone()
{
	flag_wait( "player_rubble_kill" );
	level.player Kill();
}


modify_construction_paths( brushnames , enablepath )
{
	brushes = getentarray( brushnames , "targetname" );
	foreach( brush in brushes)
	{
		brush Solid();
		brush Show();
		if(enablepath)
		{
			brush ConnectPaths();
		}
		else
		{
			brush DisconnectPaths();
		}
		brush Hide();
		brush NotSolid();

	}
}

const_ignore_enemies( delay )
{
	self endon( "death" );
	self.ignoreall = true;
	self ClearEnemy();
	wait delay;
	self.ignoreall = false;
}

post_rappel_light()
{
	street_light = GetEnt("street_light_gate", "targetname");
	street_light SetLightIntensity(0);
	flag_wait("post_rappel_streetlight");

	exploder(6001);
	// ramp up light to 3 over 0.5 seconds
	light_enc = 3/5;
	for (i=0; i <= 5; i++)
	{
		street_light SetLightIntensity(i*light_enc);
		wait 0.1;
	}
	street_light SetLightIntensity(3);
	     
}

construction_lamps_thread()
{
	level endon( "const_rappel_player_finished" );
	
	level.construction_swinging_lamps = GetEntArray( "construction_swinging_lamps" , "targetname" );
	foreach ( lamp in level.construction_swinging_lamps )
	{
		if (IsDefined(lamp.target))
		{
			lamp.animname = "construction_lamp";
			lamp SetAnimTree();
			lamp thread anim_loop_solo( lamp , "wind_medium" , "end_lamp_swing" );
			
			light = getEnt( lamp.target , "targetname" );
			linkent = spawn_tag_origin();
			linkent LinkTo( lamp, "J_Hanging_Light_03", ( 0, 0, 0 ), ( 0, 0, 0 ) );
			light thread manual_linkto( linkent );
			//PlayFXOnTag( level._effect[ "lights_point_white_payback" ] , linkent, "tag_origin" );
			PlayFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp, "J_Hanging_Light_03" );
			PlayFXOnTag( level._effect[ "tinhat_beam" ] , lamp, "J_Hanging_Light_03" );
			wait RandomFloatRange( 0.1 , 0.25 );
		}
	}
	/*
 	flag_wait( "rescue_nikolai_disable_weapons" ); // TODO: sooner based on when it is supposed to be
	foreach( lamp in level.sandstorm_swinging_lamps )
	{
		lamp notify( "end_lamp_swing" );
		StopFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp , "tag_light" );
	}
	*/	
}

