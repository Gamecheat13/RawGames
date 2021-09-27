#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\ny_manhattan_code_intro;
#include maps\_helicopter_globals;
#include maps\_shg_common;
#include maps\_audio;
#include maps\ss_util;




tiff_main()
{
	
	wait(0.1);
	flag_init ( "tiff_checkpoint" );
	flag_init ( "tiff_hind_dead" );
	
	level.tiff_guys = [];
	level.lonely_guys = [];
	level.trading_guys = [];
	level.force_spawn = undefined;
	
	//start threads
	thread tiff_hummer2_start();
	thread tiff_sandman_moveout();
	thread nyse_lobby();
	thread nyse_reset_ally_colors();
	thread flashbang_training();
	thread tiff_battle_progression();
	thread tiff_change_colors();
	thread tiff_color_progression();
	thread nyse_rooftop_hind();
	thread nyse_upper_combat();
	thread nyse_dialog();
	thread jammer_monitor();
	thread spawn_bravo();
	//thread tiff_control_sun_shadows();
	//thread nyse_control_sun_shadows();
	thread grizzly_goal(); //this is to be deleted.  Temp.
	//thread tiff_hind_start();
	thread setup_uav();
	thread E3Demo_skip_forward();
	
	add_global_spawn_function( "axis", ::setup_remote_missile_target_guy );
	array_spawn_function_noteworthy ( "trading_guys_01", ::trading_guys_think );
	array_spawn_function_targetname ( "nyse_rooftop_01", ::rooftop_guys_think );
	array_spawn_function_targetname ( "nyse_rooftop_02", ::rooftop_guys_think );
	array_spawn_function_targetname ( "tiff_guys", ::tiff_guys_think );

	
}



tiff_hummer2_start()
{
	
	flag_wait ( "tiff_hummer_spawn" );
	
	tiff_hummer3 = spawn_vehicle_from_targetname( "tiff_hummer3" );
	tiff_hummer2 = spawn_vehicle_from_targetname( "tiff_hummer2" );
	tiff_hummer2 delaythread ( 1, ::gaz_monitor_gunner );
	
	foreach ( rider in tiff_hummer2.riders )
		rider.ignoreall = true;
			
	flag_wait ( "tiff_fight_04" );
	
	foreach ( rider in tiff_hummer2.riders )
		rider.ignoreall = false;
		
	thread kill_tiff_spawner("nmy_wall_group_03");
	
	aud_send_msg("tiff_hummer2_start", tiff_hummer2);
	 
	flag_wait ( "obj_nyse_rally_given" );
	
	foreach ( rider in tiff_hummer2.riders )
	{
		if ( isdefined ( rider ) && isalive ( rider ) )
			rider thread fake_death_bullet();
	}
	//tiff_hummer2 DoDamage( tiff_hummer2.health + 9999, tiff_hummer2.origin );
	//aud_send_msg("gaz_pre_nyse_explode", tiff_hummer2);

	

}

gaz_monitor_gunner()
{
	self endon ( "death" );
	self endon ( "stop_monitoring" );
	
	while ( true )
	{
		if ( self.riders.size <= 0 )
		{
			self mgoff();
			self notify ( "stop_monitoring" );
		}
		
		wait 0.1;
		
	}
	
}
		

tiff_change_colors()
{
	flag_wait ("change_ally_color");
	
	foreach (guy in level.squad1)
	{
		guy set_force_color( "r" );
	}
	
	wait 0.5;
	level.sandman set_force_color ( "y" );
	
	//activate_trigger_with_targetname("color_trigger_tiff_01");
}

tiff_color_progression()
{
	flag_wait ("wall_group1_done");
	activate_trigger_with_targetname ("color_trigger_03");
	
//	flag_wait ("color_flag_03");
//	activate_trigger_with_targetname ("color_trigger_03");
//	
	flag_wait ("wall_group3_dead");
	activate_trigger_with_targetname ("colorsr4y4");
	
	flag_wait ("wall_baddies_03_dead");
	activate_trigger_with_targetname ("colors3001");
	

}

tiff_control_sun_shadows()
{
	flag_wait ("tiff_sandman_moveout");
	//EnableForcedNoSunShadows();
	flag_wait ("tiff_fight_03");
	//DisableForcedSunShadows();
}

tiff_battle_progression()
{
	
	flag_wait ("tiff_hummer_spawn");
	
	if ( !flag ( "tiff_guys_dead" ) )
	{
		ai = getaiarray ( "axis" );
		array_thread ( ai, ::fake_death_over_time, "bullet", 3, 6 );
	}
	
	flag_set ( "change_ally_color" );
	
	//auto-save
	autosave_by_name( "exiting_stephanies" );  

	flag_wait ("tiff_fight_02");
	
	wave1_spawners = getentarray ( "nmy_wall_group_2", "targetname" );
	wave1_guys = array_spawn ( wave1_spawners, false, true );
	thread wall_wave_monitor ( wave1_guys, "wall_group1_done" );

	thread spawn_ambient_hinds();

	flag_wait ("tiff_fight_03");
	
	//wave 1 guys fall back
//	foreach ( guy in wave1_guys )
//	{
//		if ( isdefined ( guy ) && isalive ( guy ) && isai ( guy ) )
//			guy thread enable_heat_behavior ( true );
//	}
	
	wave1_guys = getentarray ( "wall_baddies_01", "script_noteworthy" );
	thread array_setgoalvolume ( wave1_guys, "nmy_wall_group_4_volume" );
	
	wave3_spawners = getentarray ( "nmy_wall_group_3", "targetname" );
	thread maps\_spawner::flood_spawner_scripted ( wave3_spawners );
	
	maps\_spawner::killspawner( 1011 );
	
	level.reno dialogue_queue_single ( "reno_line7" );
	
	flag_wait ("tiff_fight_04");
	
	array_thread ( wave1_guys, ::fake_death_over_time, "bullet", 2, 4 );
	
//	foreach ( guy in wave1_guys )
//	{
//		if ( isdefined ( guy ) && isai ( guy ) )
//		{
//			guy kill();
//		}
//	}
	
	//wave 2 guys fall back
	wave2_guys = getentarray ( "wall_baddies_02", "script_noteworthy" );
	//array_thread ( wave2_guys, ::enable_heat_behavior, true );
	thread array_setgoalvolume ( wave2_guys, "volume_nyse_upper_combat" );
	
	wave4_spawners = getentarray ( "nmy_wall_group_4", "targetname" );
	thread maps\_spawner::flood_spawner_scripted ( wave4_spawners );
	
	level.sandman thread dialogue_queue ( "lonestar_line39" );
	
	flag_wait ( "obj_nyse_rally_given" );
	
	array_thread ( wave2_guys, ::fake_death_over_time, "bullet", 4, 8 );
	
//	foreach ( guy in wave2_guys )
//	{
//		if ( isdefined ( guy ) && isai ( guy ) )
//		{
//			guy kill();
//		}
//	}
	
	maps\_spawner::killspawner( 1004 );
	
	//wave3 guys fall back
	//wave3_guys = getentarray ( "wall_baddies_03", "script_noteworthy" );
	//array_thread ( wave3_guys, ::enable_heat_behavior, true );
	//thread array_setgoalvolume ( wave3_guys, "volume_nyse_upper_combat" );
	
	flag_wait_either ( "give_xm25", "skip_paw" );
	
	wave3_guys = getentarray ( "wall_baddies_03", "script_noteworthy" );
	array_thread ( wave3_guys, ::fake_death_over_time, "bullet", 4, 8 );
	
//	foreach ( guy in wave3_guys )
//	{
//		if ( isdefined ( guy ) && isai ( guy ) )
//		{
//			guy delete();
//		}
//	}
//	
}

wall_wave_monitor( guys, script_flag )
{
	level endon ( script_flag );
	
	while ( true )
	{
		guys = array_removeUndefined ( guys );
		if ( guys.size < 3 )
			flag_set ( script_flag );
		wait 0.05;
	}
	
}

	kill_tiff_spawner(spawn_group)
	{
		spawners = getentarray (spawn_group, "targetname");
		
		foreach (spawner in spawners)
		{
			spawner delete();
		}
	}


battle_flava( cover, enemy)
{
	eArray = getentarray ( enemy, "targetname");
	cArray = getnodearray ( cover, "targetname");
	
	i = 0;
	
	foreach (guy in eArray)
	{
		dude = guy doSpawn();
		wait 0.05;
					
		w = (level.tiff_guys.size + i);
		level.tiff_guys[w] = dude;
		
		if (isdefined(cArray[i]) && isdefined(eArray[i]))
		{
			dude thread maps\_spawner::go_to_node( cArray[i] );
		}
		else if (isdefined( eArray[i] ))
			level.lonely_guys [level.lonely_guys.size] = eArray[i];
		
		wait 1;
		i++;
	}
}

spawn_bravo()
{
	
	flag_wait_either ( "tiff_hummer_spawn", "spawn_bravo_early" );
	level.delta2 = [];
	bravo_spawners = getentarray ( "delta2_spawners", "targetname" );
	
	foreach (spawner in bravo_spawners )
	{
		guy = spawner stalingradspawn ();
		guy thread magic_bullet_shield ( true );
		guy set_force_color ( "r" );
		level.delta2 [ level.delta2.size ] = guy;
		
		if ( guy.script_noteworthy == "d2_leader" )
		{
			level.delta2_leader = guy;
			level.delta2_leader.animname = "delta2_leader";
		}	
		
	}
	
	wait 1;
	
	if ( getdvarint ( "demo_itiot" ) == 0 )
	{
		level.sandman dialogue_queue ( "lonestar_line177" );
		
		flag_wait ( "tiff_hummer_spawn" );
		
		thread dialog_anvil_wall();
		
		flag_wait ( "tiff_fight_02" );
		
		weapons = level.player getweaponslistall();
		
		foreach ( weapon in weapons )
		{
			if ( IsSubStr( weapon, "xm25" ) )
			{
				flag_set ( "player_has_xm" );
				
				if ( level.player getammocount ( "xm25" ) <= 1 )
				{
					level.player giveweapon ( "xm25" );
					level.player setweaponammoclip ( "xm25", 4 );
				}
				
				level.truck dialogue_queue_single ( "lonestar_line176" );
			}
		}
		
		if ( flag ( "player_has_xm" ) && !flag ( "player_used_xm25" ) )
		{
			cur_weapon = level.player getcurrentprimaryweapon();
			if ( !IsSubStr( cur_weapon, "xm25" ) )
			{
				display_hint_timeout ( "hint_xm25", 5 );
			}

		}
		
	}
	
	
	
}

dialog_anvil_wall()
{
	conversation_start();
	level.sandman dialogue_queue ( "lonestar_line37" );
	level.delta2_leader dialogue_queue ( "d2_line1" );
	level.sandman dialogue_queue ( "lonestar_line131" );
	level.delta2_leader dialogue_queue ( "d2_line4" );
	level.sandman dialogue_queue ( "lonestar_line132" );
	level.delta2_leader dialogue_queue ( "d2_line5" );
	level.sandman dialogue_queue ( "lonestar_line133" );
	conversation_stop();
		
}

spawn_ambient_hinds()
{

	hind01 = spawn_vehicle_from_targetname_and_drive ("ambient_hind01");
	aud_send_msg ("aud_beehind01_spawn", hind01);
	wait 5;
	hind02 = spawn_vehicle_from_targetname_and_drive ("ambient_hind02");
	aud_send_msg ("aud_beehind02_spawn", hind02);
	wait 8;
	hind03 = spawn_vehicle_from_targetname_and_drive ("ambient_hind01");
	aud_send_msg ("aud_beehind03_spawn", hind03);
	flag_wait ("tiff_fight_04");
	wait 5;	// just to ensure they've all reached
	hind01 delete();
	hind02 delete();
	hind03 delete();
}

tiff_sandman_moveout()
{
	flag_wait ( "tiff_sandman_moveout" );
	
	array_thread ( level.flashbang_guys, ::fake_death_bullet );
	
	thread tiff_firstguys();
	
	//checkpoint
	autosave_by_name( "entering_stephanies" ); 
	
	//kacper: threaded off this dialog exchange because the player could run past the color trigger before "reno_line6" finished
	thread reno_tiff_shooters_below();	
	thread sandman_tiff_takecover_dialog();
	thread battlechatter_on ( "allies" );
	
	//move squad down into the lower store after the first guys are dead
	flag_wait_either ( "tiff_first_guys_dead", "dialog_sandman_tiff_takecover" );
	
	wait 1;
	
	thread vo_hurry_up ( "dialog_sandman_tiff_takecover" );
	
	if (!flag ( "dialog_sandman_tiff_takecover" ) )
	{
		level.sandman dialogue_queue ( "lonestar_line32" );
	}
	
	if (!flag ( "dialog_sandman_tiff_takecover" ) )
	{
		level.reno dialogue_queue ( "reno_line30" );
	}
	
	activate_trigger_with_targetname ( "allies_to_tiff_lower" );
	
	flag_wait ( "tiff_guys_dead" );
	
	wait 2;
	
	if ( !flag ( "change_ally_color" ) )
		activate_trigger_with_targetname ( "color_trigger_tiff_01" );
	
	if ( !flag ( "tiff_hummer_spawn" ) )
		level.sandman dialogue_queue ( "lonestar_line35" );
	
	flag_set ( "spawn_bravo_early" );
	
}

reno_tiff_shooters_below()
{
	reno_node = getnode ( "node_tiff_grinch", "targetname" );
	
	
	level.sandman dialogue_queue ( "manhattan_snd_holdup" );
	if ( !flag ( "player_into_tiffs" ) )
		level.reno dialogue_queue( "reno_line6" );
	
	level.reno set_force_color ( "r" );
	level.reno setgoalnode ( reno_node );
	
	if ( !flag ( "player_into_tiffs" ) )
	{
		level.sandman thread dialogue_queue( "manhattan_snd_rogerthat" );
		level.sandman anim_single_solo ( level.sandman, "sandman_signal_go" );
	}
	
	activate_trigger_with_targetname ( "colors_tiff_balcony" );
}
	
tiff_firstguys()
{
	tiff_firstguys = [];
	
	spawners = getentarray ( "tiff_firstguys", "targetname" );
	
	foreach ( spawner in spawners )
	{
		guy = spawner spawn_ai ( true );
		tiff_firstguys [ tiff_firstguys.size ] = guy;
	}
	
	flag_wait ( "tiff_firstguys_go" );
	
	foreach ( guy in tiff_firstguys )
	{
		node = getnode ( guy.script_noteworthy, "targetname" );
		guy setgoalnode ( node );
		//guy.goalradius = 256;
	}
	
}
		

sandman_tiff_takecover_dialog()
{
	flag_wait ( "dialog_sandman_tiff_takecover" );
	
	wait 2;
	level.sandman dialogue_queue ( "lonestar_line33" );
	
	wait 5;
	level.sandman dialogue_queue ( "lonestar_line34" );
	
	wait 1;
	
	if ( level.player GetAmmoCount ( "fraggrenade" ) >= 1 )
		display_hint ( "hint_frag" );
}
	
nyse_control_sun_shadows()
{
	flag_wait ( "obj_nyse_rally_complete" );
	//EnableForcedNoSunShadows();
	flag_wait ( "nyse_rooftop_hind" );
	//DisableForcedSunShadows();
}

nyse_lobby()
{
	
	flag_wait_either ( "give_xm25", "skip_paw" );
	
	activate_trigger_with_targetname ( "nyse_skip_lobby" );
	
	flag_set ( "obj_nyse_rally_complete" );
	
	//checkpoint
	autosave_by_name( "entering_stockexchange" );
	
	//redundant
	flag_set ( "skip_paw" );
	
	dnode = getnode ( "node_d2_lobby", "targetname" );
	level.delta2_leader setgoalnode ( dnode );
	level.delta2_leader setlookatentity ();
	
	level.sandman set_force_color ( "c" );
	
	aud_send_msg("entering_stockexchange_before_vo");
	level.delta2_leader dialogue_queue ( "d2_line3" );	
	level.sandman dialogue_queue ( "lonestar_line116" );
		
	lines = [];
  	lines [ lines.size ] = "lonestar_line52";
  	lines [ lines.size ] = "lonestar_line53";
  	lines [ lines.size ] = "manhattan_snd_headingame";
  	
	thread dialogue_reminder ( level.sandman, "nyse_combat_start", lines );
	
	aud_send_msg("entering_stockexchange_after_vo");
	
	thread nyse_start_combat();
	thread nyse_balcony();
	 	
}

nyse_start_combat()
{
	
	flag_wait_either ( "nyse_combat_start", "nyse_entrance_vo" );
	
	foreach ( guy in level.trading_guys )
	{
		if ( isAlive( guy ) )
		{
			guy.ignoreall = false;
			guy.ignoreme = false;
		}
	}
	
	flag_set ( "nyse_combat_start" );
	aud_send_msg("mus_nyse_combat_start");
	
	level.rooftop_playerclip = getent ( "rooftop_playerclip", "targetname" );
	level.rooftop_playerclip notsolid();
	flag_wait ( "dialog_head_up_top" );
	
	//array_thread ( level.squad1, ::enable_heat_behavior, true );
	
	foreach ( guy in level.squad1 )
	{

		guy.ignoreSuppression = true;
		guy.suppressionwait = 0;
		guy disable_surprise();
		guy.IgnoreRandomBulletDamage = true;
		guy disable_bulletwhizbyreaction();
		guy disable_pain();
		guy disable_danger_react();
		guy.disableFriendlyFireReaction = true;
	}
	
	lines = [];
  	lines [ lines.size ] = "lonestar_line52";
  	lines [ lines.size ] = "lonestar_line53";
  	lines [ lines.size ] = "manhattan_snd_headingame";
  	
	thread dialogue_reminder ( level.sandman, "nyse_balcony_spawn", lines );
}

nyse_reset_ally_colors()
{
	//only do this stuff if we're not starting at the nyse start point
	if ( !flag ( "nyse_start_point" ) )
	{
	
		flag_wait ( "nyse_reset_ally_colors" );	
		
		foreach (guy in level.squad1)
		{
			guy set_force_color( "b" );
		}
		
		wait 0.5;
		
		activate_trigger_with_targetname ( "jammer_start_r_colors" );
		//level.sandman set_force_color ( "c" );
		
		flag_set ( "obj_nyse_rally_given" );
		
		level.sandman thread dialogue_queue ( "lonestar_line41" );
		
		level.sandman set_force_color ( "o" );
		
		snode = getnode ( "node_sandman_lobby", "targetname" );
		level.sandman setgoalnode ( snode );
		
		level.sandman waittill ( "goal" );
		flag_set ( "lobby_sandman_in_position" );
	}
}

flashbang_training_sandman( scriptednode )
{
	aud_send_msg("flashbang_training_anim_begin");
	scriptednode anim_single_solo ( level.sandman, "flashbang_training_start" );
	scriptednode anim_single_solo ( level.sandman, "flashbang_training_end" );
	level.sandman enable_ai_color();
}

flashbang_training()
{
	addNotetrack_flag ( "lonestar", "open_door", "flashbang_open_door", "flashbang_training_start" );
	flashbang_spawners = getentarray ( "flashbang_guys", "targetname" );
	level.flashbang_guys = [];
	door = getent ( "sandman_kick_door", "targetname" );
	door.animname = "door";
	door SetAnimTree();
	col = getent ( "flashbang_door_col", "targetname" );
	scriptednode = getent( "flashbang_scriptnode", "targetname" );
	scriptednode thread anim_single_solo( door, "closed" );	// we aren't quite closed
	flag_wait ( "sandman_kick_start" );
	
	level.sandman dialogue_queue ( "lonestar_line104" );
	
	//delete AI from exchange to broad street
	thread cleanup_ai ( "broad_enemies", "script_noteworthy" );
	thread cleanup_ai ( "gaz_entrance_guy1", "script_noteworthy" );
	thread cleanup_ai ( "gaz_entrance_guy2", "script_noteworthy" );
	thread cleanup_ai ( "gaz_entrance_guy3", "script_noteworthy" );
	thread cleanup_ai ( "gaz_entrance_guy4", "script_noteworthy" );
	thread cleanup_ai ( "first_combat", "script_noteworthy" );
	thread cleanup_ai ( "first_combat_backup", "script_noteworthy" );
	thread cleanup_ai ( "first_combat_backup_02", "script_noteworthy" );
	thread cleanup_ai ( "massacre_guy", "script_noteworthy" );
	thread cleanup_ai ( "fc_gaz_guys", "script_noteworthy" );
	thread cleanup_ai ( "broad_aggressive", "script_noteworthy" );
	
	thread cleanup_ai ( "army_01", "script_noteworthy" );
	thread cleanup_ai ( "army_02", "script_noteworthy" );
	thread cleanup_ai ( "army_02_deadguys", "script_noteworthy" );
	
	thread battlechatter_off ( "allies" );
	
	level.truck set_force_color( "o" );
	truck_node = getnode ( "reno_flashbang", "targetname" );
	level.truck setgoalnode ( truck_node );
	
	level.reno set_force_color ( "o" );
	reno_node = getnode ( "grinch_fb_stairwell", "targetname" );
	level.reno setgoalnode ( reno_node );
	
	//checkpoint
	autosave_by_name( "15_broad_done" ); 
	
	foreach ( spawner in flashbang_spawners )
	{
		guy = spawner spawn_ai (true);
		guy.ignoreall = true;
		guy.grenadeammo = 0;
		level.flashbang_guys [ level.flashbang_guys.size ] = guy;
		if ( guy.script_noteworthy == "flashbang_leader" )
		{
			level.flashbang_leader = guy;
			guy.animname = "flashbang_leader";
		}
		
		else if ( guy.script_noteworthy == "fb_guy1" )
		{
			level.fb_guy1 = guy;
		}
		
//		else if ( guy.script_noteworthy == "fb_guy2" )
//		{
//			level.fb_guy2 = guy;
//		}
	}
	
	foreach ( guy in level.squad1 )
	{
		guy.ignoreall = true;
	}
	
	thread fb_leader_flashbanged();
	
	scriptednode anim_reach_solo ( level.sandman, "flashbang_training_trans" );
	level.sandman setlookatentity ( level.player );
	scriptednode anim_single_solo ( level.sandman, "flashbang_training_trans" );
	scriptednode thread anim_loop_solo ( level.sandman, "flashbang_training_idle", "stop_loop" );
	
	flag_wait ( "flashbang_start" );
	
	if ( !flag ( "fb_leader_flashbanged" ) )
		thread fb_leader_anim();
	
	aud_send_msg("play_fake_9_bang_chatter");
	
	level.sandman dialog_prime( "lonestar_line27" );
	
	truck_node = getnode ( "truck_fb_stair", "targetname" );
	level.truck setgoalnode ( truck_node );
	
	//delete any remaining bad guys from 15 broad
	thread cleanup_ai ( "russians_destroyed_building_fl2", "script_noteworthy" );
	
	if ( level.player getammocount ( "ninebang_grenade" ) <= 1 )
	{
		level.player giveweapon ( "ninebang_grenade" );
	}
		
	level.sandman delaythread ( 1, ::dialogue_queue, "lonestar_line27" );

	wait 1.0;	// synchronized with dialog now.
	
	scriptednode notify ( "stop_loop" );
	
	//temporarily disable friendly suppression reaction to keep sandman from acting wonky
	SetSavedDvar ( "ai_friendlysuppression", 0 );
	
	thread flashbang_training_sandman ( scriptednode );
	delaythread ( 2,  ::display_hint, "hint_flashbang" );
	
	thread fb_guys_goto();
	
	flag_wait ( "flashbang_open_door" );
	
	level.sandman setlookatentity ();
	scriptednode thread anim_single_solo ( door, "open" );
	level.sandman disable_surprise();
	level.sandman disable_bulletwhizbyreaction();
	
	col connectpaths();
	col delaycall ( 1.2, ::delete );
	
	wait 3;
	
	foreach ( guy in level.flashbang_guys )
	{
		if (isdefined(guy))
			guy.ignoreall = false;
	}
	
	if ( isdefined ( level.flashbang_leader ) && isalive ( level.flashbang_leader ) )
	{
		level.flashbang_leader stopanimscripted();
		node = getnode ( "node_fb_leader", "targetname" );
		level.flashbang_leader setgoalnode ( node );
	}
	
	level.sandman.ignoreall = false;
	level.truck.ignoreall = false;
	
	level.sandman dialogue_queue ( "lonestar_line28" );
	
	flag_wait ( "flashbang_done" );
	
	level.reno.ignoreall = false;
	level.truck.ignoreall = false;
	//re-enable squad friendly suppression reaction
	SetSavedDvar ( "ai_friendlysuppression", 1 );
	
	thread dialog_flashbang_done();
	
	activate_trigger_with_targetname ( "flashbang_colors" );
	
	level.sandman enable_surprise();
	level.sandman enable_bulletwhizbyreaction();
	
	level.truck set_force_color ( "b" );
	
	//only set grinch's color back if the player hasn't already run up into tiffs
	if ( !flag ( "tiff_sandman_moveout" ) )
		level.reno set_force_color ( "b" );
	
}

fb_leader_anim()
{	
	level.flashbang_leader endon ( "flashbang" );
	
	flag_wait ( "flashbang_open_door" );
	
	//animate the leader guy and start the other 2 guys moving
	if (isdefined(level.flashbang_leader) && isalive(level.flashbang_leader))
	{
		level.flashbang_leader thread exit_animscripted_on_hit_or_flashbang();
		level.flashbang_leader thread anim_single_solo ( level.flashbang_leader, "pre_flashbang" );
	}
	
}

fb_leader_flashbanged()
{
	level endon ( "flashbang_open_door" );
	level.flashbang_leader waittill ( "flashbang" );
	flag_set ( "fb_leader_flashbanged" );

	foreach ( guy in level.flashbang_guys )
		guy.ignoreall = false;
	
	node = getnode ( "node_fb_leader", "targetname" );
	level.flashbang_leader setgoalnode ( node );
	
}

dialog_flashbang_done()
{
	level endon ( "tiff_sandman_moveout" );
	
	if ( !flag ( "tiff_sandman_moveout" ) )
	{
		wait 1;
		level.sandman dialogue_queue ( "manhattan_snd_lessresistance" );
		level.reno dialogue_queue ( "manhattan_rno_anythingoncomms" );
		level.truck dialogue_queue ( "manhattan_trk_static" );
		
		//put alleyway lines here
	}
		
}

exit_animscripted_on_flashbang()
{
	self endon("death");
	self endon("stop_exit_threads");
	self waittill( "flashbang" );
	self anim_stopanimscripted();
	self notify("stop_exit_threads");
}

exit_animscripted_on_hit_or_flashbang()
{
	self endon("death");
	self endon("stop_exit_threads");
	self thread exit_animscripted_on_flashbang();
	self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName );
	self anim_stopanimscripted();
	self notify("stop_exit_threads");
}


fb_guys_goto()
{
	fb_guy1_node = getnode ( "node_fb_guy1", "targetname" );
	//fb_guy2_node = getnode ( "node_fb_guy2", "targetname" );
	
	wait 2;
	if (isdefined(level.fb_guy1))	// he could have been killed
		level.fb_guy1 setgoalnode ( fb_guy1_node );
//	if (isdefined(level.fb_guy2))	// he could have been killed
//		level.fb_guy2 setgoalnode ( fb_guy2_node );
}

nyse_rooftop_hind()
{
	flag_wait ( "nyse_rooftop_hind" );
	
	nyse_rooftop_hinds = spawn_vehicles_from_targetname_and_drive ( "nyse_hind_flyover" );
	aud_send_msg("nyse_hind_flyover", nyse_rooftop_hinds);
	
	if (IsDefined(level.balcony_guys))
	{
		//kill leftover balcony guys so reno will advance
		foreach (guy in level.balcony_guys)
		{
			if (isalive (guy ) )
			{
				guy kill();
			}
		}
	}
	wait 1;
	
	nyse_rooftop_hinds [0] thread fire_missile( "hind_rpg_cheap", 4 );
	
	nyse_rooftop_hinds [0] waittill ( "reached_dynamic_path_end" );
	nyse_rooftop_hinds [0] delete();
}
	
nyse_upper_combat()
{
	upper_combat_spawners = getentarray ( "nyse_upper_combat", "targetname" );
	
	flag_wait ( "nyse_player_up_top" );
	
	foreach (spawner in upper_combat_spawners)
	{
		guy = spawner spawn_ai(true);
	}
	
	//make sure all awareness parameters are cleared and re-set
	array_thread ( level.squad1, ::disable_awareness );
	wait 0.05;
	array_thread ( level.squad1, ::enable_awareness );
	
	flag_wait ( "dialog_second_tier" );
	
	foreach ( guy in level.squad1 )
		guy.ignoresuppression = true;
	
	level.reno.ignoreall = false;
	
	level.truck disable_ai_color();
	level.reno disable_ai_color();
	reno_node = getnode ( "grinch_rooftop", "targetname" );
	truck_node = getnode ( "truck_rooftop", "targetname" );
	
	level.truck delaycall ( 5, ::setgoalnode, truck_node );
	//level.reno delaycall ( 7, ::setgoalnode, reno_node );
	
	flag_wait_either ( "jammer_plant_dialog", "squad_at_roof" );
	
	level.reno enable_ai_color();
	level.truck enable_ai_color();
	
}

nyse_dialog()
{
	flag_wait ( "nyse_entrance_vo" );
	level.truck dialogue_queue ( "truck_line7" );
	
	flag_wait ( "sandman_vo_pushforward" );
	thread nyse_friendly_chatter( "dialog_head_up_top" );
	
	//get rid of wall street enemies
	thread cleanup_ai ( "wall_baddies_01", "script_noteworthy" );
	thread cleanup_ai ( "wall_baddies_02", "script_noteworthy" );
	thread cleanup_ai ( "wall_baddies_03", "script_noteworthy" );
	
	flag_wait ( "dialog_head_up_top" );
	
	level.sandman dialogue_queue_single ( "lonestar_line51" );
	
	flag_wait ( "over_the_rail" );
	level.sandman dialogue_queue_single ( "lonestar_line123" );
	
	flag_wait ( "dialog_get_up_ladder" );
	level.sandman dialogue_queue_single ( "lonestar_line57" );
	
	//autosave at top of ladder
	autosave_by_name( "climbing_ladder" ); 
	
	flag_wait ( "dialog_second_tier" );
	level.sandman dialogue_queue ( "lonestar_line58" );
	
	//get rid of trading floor enemies
	thread cleanup_ai ( "trading_guys_01", "script_noteworthy" );
	
	flag_wait ( "jammer_plant_dialog" );
	level.sandman dialogue_queue ( "lonestar_line78" );
		
}

blackhawk_animated_rotors()
{
	self endon( "death" );
	xanim = self getanim( "rotors" );
	length = getanimlength( xanim );

	while ( true )
	{
		if ( !isdefined( self ) )
			break;
		self setanim( xanim );
		wait length;
	}
}


jammer_monitor()
{
	level.c4_hintstring = &"NY_MANHATTAN_THERMITE_HINT";
	
	org_thermite = getent ( "org_thermite", "targetname" );
	level.thermite = getent( "thermite_jammer", "targetname" );
	
	node_sandman = getnode ( "node_sandman_roof_final", "targetname" );	
	
	//move thermite fx to same origin as the planted thermite bomb
	org_thermite.origin = level.thermite.origin;
	// override the c4 explosion effect with our thermite effect
	level._effect[ "c4_explosion" ] = level._effect["thermite_reaction"];
	
	level.thermite hide();
	level.thermite maps\_c4::c4_location( undefined, ( 0, 0, 0 ), ( 0, 0, 0 ), level.thermite.origin, "weapon_thermite_device", "weapon_thermite_device_obj" ); //calling c4 utlity script's c4_location function (makes c4 work...)

	thread jammer_waitfor_plant();
	thread jammer_destruct();
	thread jammer_guys_monitor();
	thread jammer_enemies_fake_death();
	
	flag_wait ( "thermite_planted" );

	if (isdefined(level.rooftop_playerclip))	// debug start to jammer wouldn't have set this yet
		level.rooftop_playerclip solid();
	
	activate_trigger_with_targetname ( "thermite_planted" );
	
	level.sandman thread jammer_destruct_in_position();
	
	thread hint_thermite_detonate();
	thread hint_thermite_switch();
	
	thread jammer_waitfor_trigger();
	
	level.player SetWeaponHudIconOverride ( "actionslot2", "dpad_thermite_bomb_static" );
	
	flag_wait ( "thermite_detonated" );
	
	level.player delaycall ( 3, ::SetWeaponHudIconOverride, "actionslot2", "none" );
	
	earthquake ( 0.4, 1.5, level.thermite.origin, 10000 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
	level.rumble delaythread ( 10.8, ::rumble_ramp_to, 1, 0.1 );
	level.rumble delaythread ( 11.3, ::rumble_ramp_to, 0, 0.75 );
	
	level.truck delaythread ( 2, ::dialogue_queue, "lonestar_line170" );
	level.reno delaythread ( 3.5, ::dialogue_queue, "manhattan_rno_adios" );
	
	flag_set ( "obj_jammer_complete" );
	
	thread maps\_compass::setupMiniMap("compass_map_ny_manhattan"); 
	
	all_ai = getaiarray ();
	foreach ( guy in all_ai )
		guy.drawoncompass = true;
	
  	level.thermite hide();  	
  	
  	flag_wait ( "predator_defend_complete" );
  	
  	level.sandman thread dialogue_queue ( "lonestar_line157" );
  	
  	wait 3;
  	
  	//spawn the blackhawk and start it on its path	 	
  	start_node = getstruct ( "blackhawk_intro", "targetname" );
  	
  	level.player_hind = spawn_vehicle_from_targetname ( "hind_vehicle" );  	
	level.player_hind thread maps\ny_blackhawk::setup_ny_harbor_hind( true );
	level.player_hind thread blackhawk_animated_rotors();
	level.player_hind.mgturret[0] setmode ( "manual" );
	level.player_hind.godmode = true;
  	
  	wait 0.05;
  	
  	flag_set ( "obj_capturehind_given" );
  		
	thread blackhawk_approach(); 
	
	wait 2;
	
	level.sandman dialogue_queue ( "lonestar_line158" );	
	
}

jammer_destruct_in_position()
{
	level endon ( "thermite_detonated" );
	
	self waittill ( "goal" );
	
	self.can_play_jammer_react = true;
	
}

jammer_waitfor_trigger()
{
	level.thermite waittill ( "c4_detonation" );
	flag_set ( "thermite_detonated" );
}

jammer_waitfor_plant()
{
	level.thermite waittill ( "c4_planted" );	
	aud_send_msg("thermite_plant");
	flag_set ( "thermite_planted" );
	
	level.truck dialogue_queue ( "lonestar_line128" );
	
	flag_wait ( "thermite_player_clear" );
	
	if ( !flag ( "thermite_detonated" ) )
		level.sandman dialogue_queue ( "lonestar_line171" );
	
	lines = [];
  	lines [ lines.size ] = "lonestar_line172";
  	lines [ lines.size ] = "lonestar_line173";
  	
	thread dialogue_reminder ( level.sandman, "thermite_detonated", lines );		
}

jammer_destruct()
{
	jammer = getent ( "jamming_tower", "targetname" );
	jammer.animname = "tower";
	jammer SetAnimTree();
	jammer_destroyed = getent ( "jamming_tower_destroyed", "targetname" );
	jammer_destroyed.animname = "tower";
	jammer_destroyed SetAnimTree();
	jammer_destroyed_collision = getent ( "tower_destroyed_collision", "targetname" );
	jammer_destroyed_static = getent ( "jammer_destroyed_static", "targetname" );
	jammer_destruct_rail = getent ( "jammer_destruct_rail", "targetname" );
		
	org = getent ( "org_tower_collapse", "targetname" );
	
	org anim_first_frame_solo ( jammer_destroyed, "collapse" );
	org anim_first_frame_solo ( jammer, "idle" );
	
	jammer_destroyed hide();
	jammer_destroyed_collision notsolid();
	jammer_destroyed_static hide();
	jammer_destroyed_static notsolid();
	
	flag_wait ( "dialog_second_tier" );
	
	thread jammer_idle ( jammer, org );
	
	flag_wait ( "thermite_detonated" );
	
	jammer thread jammer_thermite_burn_player();
	array_thread ( level.squad1,  ::jammer_destruct_react );
	
	autosave_by_name ( "jammer_destroyed" );
	
	jammer hide();
	jammer_destroyed show();
	
	wait 2;
	
	org thread anim_single_solo ( jammer_destroyed, "collapse" );
	
	anm = getanim_from_animname("collapse", jammer_destroyed.animname);
	
	animtime = GetAnimLength( anm );
	wait animtime - 3.0;
	
	thread jammer_destruct_kill();

	jammer_destroyed_collision solid();
	
	jammer_destruct_rail hide();
	
	thread jammer_destruct_dialog();
	wait 2.5; // Wait for tower audio moment to complete.
	
	wait 0.5;
	
	jammer_destroyed hide();
	jammer_destroyed_static show();
	jammer_destroyed_static solid();
	
  		
}

jammer_idle ( jammer, org )
{
	org anim_single_solo ( jammer, "idle" );
	org anim_single_solo ( jammer, "idle" );
}

jammer_destruct_dialog()
{
	delaythread (2.5, ::radio_dialogue_queue_single, "manhattan_test_we_have_comms_fx");
	
	flag_wait ( "squad_at_roof" );
	
	//level.sandman dialogue_queue ( "lonestar_line137" );
	
	jammer_sandman_overlord();

  	thread predator_monitor();
	thread predator_dialog();
	level.player thread predator_keep_safe_view();
	//thread predator_defend();
	thread predator_fail();
	
	flag_set ( "obj_predator_given" );
	level.reno.script_pushable = false;
	level.sandman.script_pushable = false;
	level.truck.script_pushable = false;
	//wait 2;
	//level.truck dialogue_queue ( "truck_line7" );
	conversation_start();
	level.reno dialogue_queue ( "reno_line36" );
  	radio_dialogue ( "manhattan_hqr_backonline" );
  	if ( !flag ( "player_used_predator" ) )
  		level.sandman dialogue_queue ( "lonestar_line139" );
  	conversation_stop();
  	
  	thread predator_hint();
  	thread dialog_predator_nag();
  	thread reaper_player_model();
  	
	
}

jammer_sandman_overlord()
{
	org = spawn ( "script_origin", level.sandman.origin );
	org.angles = level.sandman.angles;
	//level.sandman anim_single_solo ( level.sandman, "radio_in" );
	level.sandman thread anim_single_run_solo ( level.sandman, "radio" );
	level.sandman dialogue_queue ( "lonestar_line137" );
	delaythread ( 3, ::predator_defend );
  	radio_dialogue ( "manhattan_hqr_proceed" );
  	level.sandman dialogue_queue ( "lonestar_line138" );
  	//level.sandman notify ( "stop_loop" );
	//level.sandman anim_single_solo ( level.sandman, "radio_out" );
	org delete();
	
}
	

jammer_destruct_react()
{
	if ( flag ( "squad_at_roof" ) )
	{
		if ( isdefined ( self.can_play_jammer_react ) && self.can_play_jammer_react )
			self thread anim_single_solo ( self, "tower_destruct_react" );
	}
	
}

jammer_destruct_kill()
{
	if ( flag ( "jammer_destruct_kill" ) )
		level.player kill();
		
}

jammer_thermite_burn_player()
{
	level endon ( "entering_hind" );
	
	while ( !flag ( "entering_hind" ) )
	{
			
		while ( flag ( "thermite_burn" ) )
		{
			level.player DoDamage(40, self.origin);
			level.player play_sound_on_entity( "breathing_hurt_start" );
			level.player PlayRumbleOnEntity( "damage_light" );
			//player setblurforplayer ( 10, 1 );

			wait 0.5;
		}
		
		wait 0.05;
	}
	
}

jammer_guys_monitor()
{
	flag_wait ( "jammer_guys_dead" );
	
	level.truck delaythread ( 1, ::dialogue_queue_single, "manhattan_trk_clear" );
	aud_send_msg("mus_stock_exchange_roof_combat_done");
	
	//iprintlnbold ( "jammer guys are dead" );
	//nag dialogue for jammer objective
	
	lines = [];
  	lines [ lines.size ] = "lonestar_line167";
  	lines [ lines.size ] = "lonestar_line168";
  	lines [ lines.size ] = "lonestar_line169";
	
	thread dialogue_reminder ( level.sandman, "thermite_planted", lines );
	
	//get grinch and truck to specific nodes
	grinch_node = getnode ( "grinch_collapse", "script_noteworthy" );
	truck_node = getnode ( "truck_collapse", "script_noteworthy" );
	level.reno set_force_color ( "o" );
	level.truck set_force_color ( "o" );
	level.reno  setgoalnode ( grinch_node );
	level.truck setgoalnode ( truck_node );
	
	level.reno thread jammer_destruct_in_position();
	level.truck thread jammer_destruct_in_position();
	
	if ( !flag ( "thermite_planted" ) )
		activate_trigger_with_targetname ( "colors_3007" );
}

jammer_enemies_fake_death()
{
	//take out any remaining enemies since we don't want them around anymore when the jammer is collapsing
	flag_wait ( "thermite_planted" );
	flag_wait ( "squad_at_roof" );
	
	enemies = getaiarray ( "axis" );
	
	array_thread ( enemies, ::fake_death_over_time, "bullet", 2, 3 );
	
	wait 3;
	
//	level.sandman.alertlevel = "noncombat";
//	level.reno.alertlevel = "noncombat";
//	level.truck.alertlevel = "noncombat";
}

hint_thermite_detonate()
{
	level endon ( "thermite_detonated" );
	
	wait 5;
	
	thread display_hint ( "hint_thermite_detonate" );
	
}

hint_thermite_switch()
{
	level endon ( "thermite_detonated" );
	
	while ( true )
	{
		level.player waittill ( "weapon_change" );
		
		wait 1;
		
		thread display_hint ( "hint_thermite_switch" );
		
		while ( true )
		{
			cur_weap = level.player GetCurrentPrimaryWeapon();
			if ( issubstr ( cur_weap, "thermite" ) )
				break;
			wait .05;
		}
		
		thread hint_thermite_detonate();
		
		wait 0.05;
	}
		
		
}

blackhawk_approach()
{
	org = getent ( "org_tower_collapse", "targetname" );
	aud_send_msg("blackhawk_approach");	
	thread blackhawk_approach_sandman( org );
	thread blackhawk_approach_monitor_a_button(); 	//listen for a button press to get player on blackhawk with an a button press OR hitting x to activate the trigger
	org anim_single_solo ( level.player_hind, "approach" );
	org thread anim_loop_solo ( level.player_hind, "approach_idle", "stop_idle" );
	level.player_hind SetAnim( level.scr_anim[level.player_hind.animname]["approach"], 0, 0.0 );	// don't interp to get to the looping anim
	level.player_hind SetAnim( level.scr_anim[level.player_hind.animname]["approach_idle"][0], 1, 0.0 );	// don't interp to get to the looping anim
	flag_set ( "blackhawk_at_rooftop" );
	
	if ( !flag ( "sandman_animating" ) )
		flag_set ( "player_can_board_blackhawk" );
	
	lines = [];
  	lines [ lines.size ] = "lonestar_line160";
  	lines [ lines.size ] = "lonestar_line161";
  	lines [ lines.size ] = "lonestar_line162";
  	lines [ lines.size ] = "lonestar_line163";
	
	thread dialogue_reminder ( level.sandman, "entering_hind", lines );	
	
	//level.sandman dialogue_queue ( "lonestar_line159" );
	
  	flag_wait ( "entering_hind" );
  	
  	//	org notify ( "stop_idle" );
  	//level.player_hind notify ( "stop_idle" );
	
}

blackhawk_approach_monitor_a_button()
{
	level endon ( "entering_hind" );
	
	while ( !flag ( "entering_hind" ) )
	{
		while ( flag ( "player_can_jump_on_blackhawk" ) )
		{
			level.player NotifyOnPlayerCommand( "jump", "+gostand" );
			level.player waittill ( "jump" );
			activate_trigger_with_targetname ( "player_at_hind" );
			wait 0.05;
		}
	
		wait 0.05;		
	}
}
	
blackhawk_approach_sandman( org )
{
	level endon ( "entering_hind" );
	
	anm = getanim_from_animname("approach", level.player_hind.animname);
	
	animtime = GetAnimLength( anm );
	wait animtime - 3.0;
	
	flag_waitopen ( "player_blocking_sandman" );
	
	flag_set ( "sandman_animating" );
	flag_clear ( "player_can_board_blackhawk" );
	
	level.sandman disable_awareness();
	
	org anim_reach_solo ( level.sandman, "blackhawk_jump" );
	org anim_single_solo ( level.sandman, "blackhawk_jump" );
	
	level.sandman linktoblendtotag (level.player_hind, "tag_player" );
	
	thread blackhawk_approach_sandman_idle();
	
	wait 1;
	
	flag_set ( "player_can_board_blackhawk" );
		  	
}

blackhawk_approach_sandman_idle()
{
	level.player_hind anim_single_solo ( level.sandman, "blackhawk_land", "tag_player" );
	level.player_hind anim_loop_solo ( level.sandman, "blackhawk_land_idle", "stop_idle", "tag_player" );
}

predator_defend()
{
	level.enemies_killed = 0;
	
	flag_set ( "give_predator" );
	flag_clear ( "punish_time" );
	
	array_spawn_function_targetname ( "enemy_predator_01", ::predator_guy_think );
	array_spawn_function_targetname ( "enemy_predator_02", ::predator_guy_think );
  	
  	level.enemy_predator_01 = [];
  	level.enemy_predator_02 = [];
  	level.enemy_predator_01_spawners = getentarray ( "enemy_predator_01", "targetname" );
  	level.enemy_predator_02_spawners = getentarray ( "enemy_predator_02", "targetname" );
  	level.enemy_predator_01_nodes = getnodearray ( "enemy_predator_01_nodes", "targetname" );
  	level.enemy_predator_02_nodes = getnodearray ( "enemy_predator_02_nodes", "targetname" );
  	array_spawn_function_targetname ( "enemy_predator_01", ::enemy_predator_01_assign );
  	array_spawn_function_targetname ( "enemy_predator_02", ::enemy_predator_02_assign );
	thread maps\_spawner::flood_spawner_scripted ( level.enemy_predator_01_spawners );
	thread maps\_spawner::flood_spawner_scripted ( level.enemy_predator_02_spawners );
	
  	wait 5;
  	
  	level.reno set_force_color ( "b" );
	level.truck set_force_color ( "b" );
	level.reno enable_ai_color();
	level.truck enable_ai_color();
	
  	activate_trigger_with_targetname ( "colors_3009" );
 
  	flag_wait_or_timeout ( "predator_wave2_dead", 30 );
 		
  	thread predator_hind();
  	thread predator_hind_attractors();
  	thread predator_enemy_shuffle ( level.enemy_predator_01, level.enemy_predator_01_nodes ); 
  	thread predator_enemy_shuffle ( level.enemy_predator_02, level.enemy_predator_02_nodes );  	
  	
  	flag_wait ( "predator_defend_hind_dead" );
  	level.lookat = level.uav_lookat_point;
  	
  	wait 3;
  	
  	autosave_by_name ( "predator_defend_finished" );
  	
  	flag_set ( "predator_defend_complete" );
  	flag_clear ( "backtrack_warn" );
  	
  	level.player thread maps\_remotemissile::disable_uav( false, true );	// ensure we aren't stuck in predator hud
  	
  	level notify ( "stop_predator_shuffle" );
  	
}

dialog_predator_nag()
{
	lines = [];
  	lines [ lines.size ] = "lonestar_line140";
  	lines [ lines.size ] = "lonestar_line142";
  	lines [ lines.size ] = "lonestar_line143";
	
	thread dialogue_reminder ( level.sandman, "player_used_predator", lines, 5, 10 );	
	
	
}

enemy_predator_01_assign()
{
	level.enemy_predator_01 [ level.enemy_predator_01.size ] = self;
}

enemy_predator_02_assign()
{
	level.enemy_predator_02 [ level.enemy_predator_02.size ] = self;
}

predator_enemy_shuffle( guys, nodes )
{
	level endon ( "stop_predator_shuffle" );
	
	while ( true )
		{
			wait 1;
			if ((guys.size > 0) && nodes.size > 0)
			{
			        gNum = randomint( guys.size );
			        cNum = randomint( nodes.size );
			        
			        if (isdefined( nodes[ cNum ] ) && (isdefined(guys [ gNum ] )))
			                        guys [gnum] thread maps\_spawner::go_to_node( nodes[ cNum ] );
			}
	}

}

predator_hind_rotor_collision()
{
	self endon( "death" );
	
	rotor_coll = getent("hind_rotor_collision","targetname");
	rotor_coll.health = 1;
	rotor_coll hide();
	rotor_coll.origin = self GetTagOrigin( "main_rotor_jnt" );
	rotor_coll.angles = self GetTagAngles( "main_rotor_jnt" );
	rotor_coll linkto( self, "main_rotor_jnt" );
	while ( true )
	{
		rotor_coll waittill("damage", amount, attacker, direction_vec, point, type, modelName, tagName);
		self notify("damage", amount, attacker, direction_vec, point, type, modelName, tagName);
	}
}

watch_predator_hind_death()
{
	self waittill( "death" );
	flag_set( "predator_hind_dead" );
}

predator_hind()
{
	//wait 20;
	
	level.predator_hind = spawn_vehicle_from_targetname_and_drive ( "predator_defend_hind" );
	level.predator_hind.perferred_crash_location = GetEnt( "wall_hind_crash", "script_noteworthy" );
	level.predator_hind thread maps\_remotemissile_utility::setup_remote_missile_target();
	level.predator_hind thread predator_hind_rotor_collision();
	level.predator_hind thread broad_hind_think ();
	level.predator_hind notify ( "stop_street_strafe" );
	level.predator_hind notify ( "stop_ai" );
	level.predator_hind thread maps\ny_manhattan_fx::nyse_hinddeath_override();
	level.predator_hind thread hind_dmg_hint();
	level.predator_hind thread watch_predator_hind_death();
	
	crash_loc = getent ( "predator_hind_crash", "script_noteworthy" );	
	level.predator_hind.preferred_crash_location = crash_loc;
	
	aud_send_msg("aud_predator_hind", level.predator_hind);
	
	flag_wait ( "start_predator_hind_orient" );
	
	thread predator_hind_vo();
	
	if (isdefined(level.predator_hind))
		level.predator_hind setlookatent ( level.player );
	
	wait 4;
	
	flag_set ( "predator_lookat_changed" );
	
	if (isdefined(level.predator_hind))
	{
		level.lookat = level.predator_hind;
	}
	
 	wait 10;
 	
 	if ( isdefined ( level.predator_hind ) )
 		level.predator_hind thread broad_hind_turret_ai();
	
	wait 30;
	
	flag_set ( "predator_hind_deadly" );
	
}

predator_hind_vo()
{
	radio_dialogue_queue_single ( "manhattan_snd_knockitout" );
	
	lines = [];
	lines [ lines.size ] = "manhattan_snd_pinneddown";
	lines [ lines.size ] = "manhattan_snd_usethereaper";
	lines [ lines.size ] = "manhattan_snd_alloverus";
	
	thread dialogue_reminder ( level.sandman, "predator_defend_complete", lines );
	
}

predator_hind_attractors()
{	
	attractor_org = spawn ( "script_origin", level.player.origin );
	attractor = missile_createattractorent ( attractor_org, 5000, 99999, level.predator_hind );
	
	while ( !flag ( "predator_defend_hind_dead" ) )
	{
		if (!flag ( "predator_hind_deadly" ) )
			{	
				x = RandomFloatRange ( 256, 380 );
				y = RandomFloatRange ( -400, 400);
			}
			
			else
			{
				x = RandomFloatRange ( 0, 128 );
				y = RandomFloatRange ( -128, 128 );
			}
		
		offset = ( x, y, 0 );
		
		attractor_org.origin = level.player.origin + offset;
		
		wait RandomIntRange ( 3, 7 );
	}
	
	missile_deleteattractor( attractor );
}
		
predator_fail()
{
	level endon ( "predator_defend_complete" );
	
	while ( !flag ( "predator_defend_complete" ) )
	{
		flag_wait ( "predator_player_ranaway" );
		
		flag_set ( "backtrack_warn" );
		
		flag_wait_or_timeout ( "predator_player_ranaway_clear", 10 );
		
		wait 0.1;
		
		if ( !flag ( "predator_player_ranaway_clear" ) )
		{
			flag_clear ( "backtrack_warn" );
			SetDvar( "ui_deadquote", &"NY_MANHATTAN_BRAVO_KILLED" );
			missionfailedwrapper();
		}
		
		else
		{
			flag_clear ( "predator_player_ranaway" );
			flag_clear ( "predator_player_ranaway_clear" );
			flag_clear ( "backtrack_warn" );
		}
			
			
		wait 0.05;		
		
	}
}	

predator_monitor()
{
	while ( !flag ( "predator_defend_complete" ) )
	{
		level waittill ( "starting_predator_drone_control" );
		flag_set ( "player_used_predator" );
	
	}
		
}

monitor_delta2_guys()
{
	flag_wait ( "bravo_killed" );
	
	if ( !flag ( "predator_wave1_dead" ) )
	{
		SetDvar( "ui_deadquote", &"NY_MANHATTAN_BRAVO_KILLED" );
		missionFailedWrapper();
	}
}

predator_guy_think()
{
	self waittill ( "death", attacker, cause );
	if ( ( isdefined( attacker ) ) && ( isplayer( attacker ) ) )
	{
		if ( ( isdefined ( cause ) ) && ( cause == "MOD_PROJECTILE_SPLASH" ) )
		{
			level notify ( "predator_someone_killed" );
			level.enemies_killed++;
		}
	}
}

predator_keep_safe_view()
{
	self endon("death");
	start_forward = (0.0111, -0.342, -0.94);	// hard coding so we can limit the dp as much as possible
	
	while( !flag ( "predator_defend_complete" ) )
	{
		self waittill("player_fired_remote_missile");
		while (isdefined(self.active_uav_missile))
		{	// monitor to ensure our missile is in a valid area
			forward = AnglesToForward(self.active_uav_missile.angles);
			dp = VectorDot(forward,start_forward);
			if (dp < 0.91)
			{	// cause 1 point of damage to take player out of remotemissile view.
				self notify("force_out_of_uav");	// ensure we exit even if in god mode
				pos = self.active_uav_missile.origin;	// for lack of a better pos
				self DoDamage(1,pos);
				break;
			}
			wait 0.05;
		}
	}
}

predator_dialog()
{
	
	hit_line_last = undefined;
	keep_going_line_last = undefined;
	
	fiveplus_lines = [];
	fiveplus_lines [ fiveplus_lines.size ] = "pred_5_targets_down";
	fiveplus_lines [ fiveplus_lines.size ] = "pred_multiple_down";
	
	twoplus_lines = [];
	twoplus_lines [ twoplus_lines.size ] = "pred_multiple_down";
	twoplus_lines [ twoplus_lines.size ] = "pred_multiple_eliminted";
	twoplus_lines [ twoplus_lines.size ] = "pred_good_effect";
	
	solo_lines = [];
	solo_lines [ solo_lines.size ] = "pred_good_hit";
	solo_lines [ solo_lines.size ] = "pred_good_effect";
	solo_lines [ solo_lines.size ] = "pred_hit_confirmed";
	
	miss_lines = [];
	miss_lines [ miss_lines.size ] = "pred_miss";
	miss_lines [ miss_lines.size ] = "pred_short_repeat";
	miss_lines [ miss_lines.size ] = "pred_zero_kills";
	
	keep_going_lines = [];
	keep_going_lines [ keep_going_lines.size ] = "";
	keep_going_lines [ keep_going_lines.size ] = "";
	
	while( !flag ( "predator_defend_complete" ) )
	{
		level waittill( "remote_missile_exploded" );
		
		flag_clear ( "predator_hit_line_success" );
		
		wait 1.0;
		
		if ( !flag ( "predator_defend_complete" ) )
		{
			if ( level.enemies_killed >= 5 )
			{
				while ( !flag ( "predator_hit_line_success" ) )
				{
					hit_line = random ( fiveplus_lines );
				
					if ( isdefined ( hit_line_last ) && hit_line_last == hit_line )
						continue;
					else	
					{
						hit_line_last = hit_line;
						level.sandman dialogue_queue_single ( hit_line );
						level.sandman dialogue_random_line ( "manhattan_snd_sendanothermissile", "manhattan_snd_hitemagain" );
						flag_set ( "predator_hit_line_success" );
					}
				}
			}
			
			else if ( level.enemies_killed >= 2 )
			{
				while ( !flag ( "predator_hit_line_success" ) )
				{
					hit_line = random ( twoplus_lines );
				
					if ( isdefined ( hit_line_last ) && hit_line_last == hit_line )
						continue;
					else	
					{
						hit_line_last = hit_line;
						level.sandman dialogue_queue_single ( hit_line );
						level.sandman dialogue_random_line ( "manhattan_snd_sendanothermissile", "manhattan_snd_hitemagain" );
						flag_set ( "predator_hit_line_success" );
					}
				}
			}
			
			else if ( level.enemies_killed == 1 )
			{
				while ( !flag ( "predator_hit_line_success" ) )
				{
					hit_line = random ( solo_lines );
				
					if ( isdefined ( hit_line_last ) && hit_line_last == hit_line )
						continue;
					else	
					{
						hit_line_last = hit_line;
						level.sandman dialogue_queue_single ( hit_line );
						level.sandman dialogue_random_line ( "manhattan_snd_sendanothermissile", "manhattan_snd_hitemagain" );
						flag_set ( "predator_hit_line_success" );
					}
				}
			}
			
			else
			{
				if ( !isdefined ( level.predator_hind ) || maps\ny_manhattan_code_hind::isVehicleAlive ( level.predator_hind ) )
				{
					while ( !flag ( "predator_hit_line_success" ) )
					{
						hit_line = random ( miss_lines );
					
						if ( isdefined ( hit_line_last ) && hit_line_last == hit_line )
							continue;
						else	
						{
							hit_line_last = hit_line;
							level.sandman dialogue_queue_single ( hit_line );
							flag_set ( "predator_hit_line_success" );
						}
					}
				}
			}
			
			wait 0.05;
			
			level.enemies_killed = 0;
		}
			
			
		wait 0.05;			
	}
}

nyse_balcony()
{
	level.balcony_guys = [];
	spawners = getentarray ( "enemy_nyse_balcony", "targetname" );
	
	CreateThreatBiasGroup ( "nyse_balcony" );
	
	flag_wait ( "allies_up_top" );
	
	level.reno set_force_color ( "o" );
	level.sandman set_force_color ( "o" );
	level.truck set_force_color ( "o" );
	
	level.reno setgoalnode ( getnode ( "grinch_uptop", "targetname" ) );
	level.sandman setgoalnode ( getnode ( "sandman_uptop", "targetname" ) );
	level.truck setgoalnode ( getnode ( "truck_uptop", "targetname" ) );
	
	flag_wait ( "dialog_head_up_top" );
	
	thread autosave_by_name ( "trading_floor_done" );
	
	level.sandman set_force_color ( "c" );
	thread grinch_balcony_waitforsandman();
	
	flag_wait ( "nyse_balcony_spawn" );
	
	level.truck set_force_color ( "b" );
	
	foreach ( spawner in spawners )
	{
		guy = spawner stalingradspawn();
		guy SetThreatBiasGroup ( "nyse_balcony" );
		level.balcony_guys [ level.balcony_guys.size ] = guy;
		
	}	
	
	setignoremegroup ( "nyse_balcony", "sandman_15_broad" );
	setignoremegroup ( "sandman_15_broad", "nyse_balcony" );
	
	thread setup_ignore_all_triggers();
	
	wait 1;
	
	level.reno thread dialogue_queue_single ( "reno_line31" );
	
	flag_wait ( "balcony_guys_dead" );
	
	if (!flag ( "nyse_rooftop_hind" ) )
	{
		level.reno dialogue_queue ( "reno_line32" );
	}
	
	level.reno set_force_color ( "b" );
	level.reno.ignoreall = true;
	level.reno waittill ( "goal" );
	level.reno.ignoreall = false;
}

//kacper: triggers are placed over the nyse scaffolding to prevent the ai from engaging the balcony baddies only during the stair climb

setup_ignore_all_triggers()
{
	triggers = GetEntArray( "trigger_ignore_all", "targetname" );	
	foreach(trigger in triggers)
	{
		level thread ignore_all_trigger_think(trigger);	
	}
}

ignore_all_trigger_think(trigger)
{
	for(;;)
	{
		trigger waittill("trigger", guy);
		if(IsDefined(guy) &&  IsAI(guy) && !guy IsBadGuy())
		{
			guy thread ignore_all_trigger_ai_think(trigger);	
		}		
	}	
}

ignore_all_trigger_ai_think(trigger)
{
	// self is the ai
	
	self notify( "ignore_all_trigger_ai_think_stop" );
	self endon( "ignore_all_trigger_ai_think_stop" );
	self endon( "balcony_guys_dead" );
	self endon( "death" );
	
	self set_ignoreall(true);
	self set_ignoreme(true);
	
	while(self IsTouching(trigger))
	{
		wait .5;	
	}
	
	self set_ignoreall(false);
	self set_ignoreme(false);
}

grinch_balcony_waitforsandman()
{
	flag_wait ( "sandman_up_top" );
	
	level.reno setgoalnode ( getnode ( "truck_balcony", "targetname" ) );
	
}
	
	
nyse_friendly_chatter(while_flag)
{
		
	if (!flag ( while_flag ) )
	{
		
		level.sandman dialogue_queue ( "lonestar_line50" );
	}			
		
	
	rand_delay = RandomIntRange ( 5, 15 );
	wait rand_delay;
	if (!flag ( while_flag ) )
	{
		level.sandman dialogue_queue ( "lonestar_line105" );
	}
	
	rand_delay = RandomIntRange ( 5, 15 );
	wait rand_delay;
	if (!flag ( while_flag ) )
	{
		level.reno dialogue_queue ( "reno_line29" );
	}
	
	rand_delay = RandomIntRange ( 5, 15 );
	wait rand_delay;
	if (!flag ( while_flag ) )
	{
		level.sandman dialogue_queue ( "lonestar_line106" );
	}
	
	rand_delay = RandomIntRange ( 5, 15 );
	wait rand_delay;
	if (!flag ( while_flag ) )
	{
		level.reno dialogue_queue ( "reno_line28" );
	}
	
	rand_delay = RandomIntRange ( 5, 15 );
	wait rand_delay;
	if (!flag ( while_flag ) )
	{
		level.sandman dialogue_queue ( "lonestar_line108" );
	}
	
	
	rand_delay = RandomIntRange ( 5, 15 );
	wait rand_delay;
	if (!flag ( while_flag ) )
	{
		level.sandman dialogue_queue ( "lonestar_line107" );
	}

			
}

trading_guys_think()
{
	level.trading_guys [ level.trading_guys.size ] = self;
	
	if ( !flag ( "nyse_combat_start" ) )
	{
		self.ignoreall = true;
		self.ignoreme = true;
	}
}

rooftop_guys_think()
{
	self.ignoresuppression = true;
	//self enable_heat_behavior();
	//self.aggressivemode = true;
}

tiff_guys_think()
{
	self.favoriteenemy = level.player;
}
	
	
grizzly_goal()
{
	node = getnode ( "node_grizzly_lobby", "targetname" );
	flag_wait ( "obj_nyse_rally_given" );
	level.delta2_leader set_force_color ( "o" );
	level.delta2_leader setgoalnode ( node );
}

setup_uav()
{
	cur_vision_set = GetDvar( "vision_set_current" );
	set_vision_set( cur_vision_set, 0 );	// we need to do this to ensure the level.lvl_visionset is set for the uav code
	//  we may need to do some work on this for specops since it is using the level setting rather than a player setting
	
	level.uav = spawn_vehicle_from_targetname_and_drive( "uav" );
	level.uav playLoopSound( "uav_engine_loop" );
	level.uavRig = spawn( "script_model", level.uav.origin );
	level.uavRig setmodel( "tag_origin" );
	
	level.uav_struct.view_cone = 12;
	
	level.uav vehicle_setspeed ( 3, 15, 5 );
	
	thread UAVRigAiming();
	
	thread give_player_predator_drone();
	thread monitor_reaper_usage();
	
	level.uav hide();

}
	
give_player_predator_drone()
{
	//flag_set( "player_has_predator_drones" );
	
	flag_wait ( "give_predator" );
	
	level.uav show();
	
	aud_send_msg("mus_predetor");
	
	level.min_time_between_uav_launches = 5 * 1000;
	level.uav_struct.viewcone = 25;
	level.player maps\_remotemissile::give_remotemissile_weapon( "remote_missile_detonator" );

}

predator_hint()
{
	level endon ( "entering_hind" );
	
	while ( true )
	{
		if( !flag( "uav_in_use" ) )
		{
			display_hint( "hint_predator" );
		}
		
		//when it is used, hint will be removed
		flag_wait_either( "uav_in_use", "hind_dmg_hint" );
		
		//wait until player stops using it to start timer
		flag_waitopen( "uav_in_use" );
		
		//if uav isn't used within the next 45 seconds, show the hint.  
		flag_wait_or_timeout( "uav_in_use", 30 );
	}
}

monitor_reaper_usage()
{
	while( true )
	{
		level waittill ( "player_is_controlling_UAV" );
		{
			flag_set( "uav_in_use" );
			thread predator_shoot_hint();
		}
	
		level waittill ( "draw_target_end" );
		flag_clear( "uav_in_use" );
	}
}

predator_shoot_hint()
{
	level endon ( "player_fired_remote_missile" );
	level endon ( "predator_hind_dead" );
	level endon ( "draw_target_end" );
	
	wait 3;
	
	display_hint ( "hint_predator_shoot" );
	
}
	

reaper_player_model()
{
	//show a dummy player model while in predator viewcone
	level endon ( "predator_defend_complete" );
	
	dummy_spawner = getent ( "player_dummy", "targetname" );
	dummy = dummy_spawner spawn_ai ( true );
	dummy_org = dummy.origin;
	dummy_angles = dummy.angles;
	dummy magic_bullet_shield();
	dummy disable_pain();
	
	player_org = spawn ( "script_origin", ( 0, 0, 0 ) );
	player_angles = undefined;
	
	model = spawn ( "script_model", ( 0, 0, 0 ) );
	model setmodel ( "body_delta_elite_assault_aa" );
	model attach ( "head_hero_sandman_delta", "" );
	level.player thread maps\_remotemissile_utility::setup_remote_missile_target();
	model hide();
	//model.animname = "reaper_dummy";
	//model assign_animtree();
	//player_org anim_first_frame_solo ( model, "reaper_dummy_idle" );
	
	
	while ( true )
	{
		while ( !flag ( "uav_in_use" ) )
		{
			player_org.origin = level.player.origin;
			player_angles = level.player getplayerangles ();
			stance = level.player getstance();
			model.angles = player_angles;
			model.origin = level.player.origin;
			
			wait 0.1;
		}
		
		while ( flag ( "uav_in_use" ) )
		{
			model show();
			flag_waitopen ( "uav_in_use" );
			model hide();
		}
	}
	
}
		
		
		

UAVRigAiming()
{
	level.uav_lookat_point = getent ( "uav_lookat", "targetname" );
	level.lookat = level.uav_lookat_point;
	level.uav endon ( "death" );
	for ( ;; )
	{
		if ( IsDefined( level.uavTargetEnt ) )
			targetPos = level.uavTargetEnt.origin;
		else
			targetpos = level.lookat.origin;  // you could put this in invasion.map if you'd like.
			
		if (IsDefined(targetpos)) // level.lookat.origin may be undefined
		{
			angles = VectorToAngles( targetPos - level.uav.origin );

			level.uavRig MoveTo( level.uav.origin, 0.10, 0, 0 );
			level.uavRig RotateTo( ANGLES, 0.10, 0, 0 );
		}
		wait 0.05;
	}
}



//Temp super hacky "In the interest of time" skip forward stuff

E3Demo_skip_forward()
{
	
	flag_wait ( "start_itiot" );
	
	if ( getdvarint ( "demo_itiot" ) == 1 )
	{
		thread e3demo_gaz();
		
		wait 0.5;
		
		thread introscreen_generic_fade_out("black", 5, 1, 1 );
		aud_send_msg("e3_demo_fade_out", 2);
		lines = [];
		lines[0] = &"NY_MANHATTAN_ITIOT";
		thread demo_feed_lines(lines, 1);
		
		wait 1;
		
		level.player FreezeControls( true );
		level.player enableinvulnerability();
		
		//flag_set ( "dialog_sandman_tiff_takecover" );
		
		thread vision_set_fog_changes("ny_manhattan",0);
		thread e3demo_setup_squad_and_player();
		thread e3demo_combat();
		
		vehicles = getentarray ( "broad_vehicles_hide", "script_noteworthy" );
		
		foreach ( vehicle in vehicles )
		{
			vehicle show();
		}
		
		wait 4;
		
		aud_send_msg("e3_demo_fade_in", 2);
		
		//level.player setplayerangles ( ( 11, 135, 0 ) );
		level.player FreezeControls ( false );
		
		level.player delaycall ( 3, ::disableinvulnerability );
		
		wait 2;
		
		
		level.reno dialogue_queue ( "reno_line7" );
		
		flag_set ( "tiff_fight_01a" );
	}
}

e3demo_gaz()
{
	tiff_hummer3 = spawn_vehicle_from_targetname( "tiff_hummer3" );
	tiff_hummer2 = spawn_vehicle_from_targetname( "tiff_hummer2" );
	tiff_hummer2 delaythread ( 1, ::gaz_monitor_gunner );
	
	flag_wait ( "obj_nyse_rally_given" );
		
	foreach ( rider in tiff_hummer2.riders )
	{
		if ( isdefined ( rider ) && isalive ( rider ) )
			rider thread fake_death_bullet();
	}
}

e3demo_setup_squad_and_player()
{
	level.delta2 = [];
	bravo_spawners = getentarray ( "delta2_spawners", "targetname" );
	
	foreach (spawner in bravo_spawners )
	{
		guy = spawner stalingradspawn ();
		guy thread magic_bullet_shield ( true );
		guy set_force_color ( "r" );
		level.delta2 [ level.delta2.size ] = guy;
		
		if ( guy.script_noteworthy == "d2_leader" )
		{
			level.delta2_leader = guy;
			level.delta2_leader.animname = "delta2_leader";
		}	
		
	}
	
	e3_start_locs_bravo = getentarray ( "e3_start_locs_bravo", "targetname" );
	e3_start_locs_squad = getentarray ( "e3_start_locs_squad", "targetname" );
	
	wait 0.1;
	
	for ( i = 0; i < level.delta2.size; i++ )
	{
		level.delta2 [ i ] teleport ( e3_start_locs_bravo [ i ].origin, e3_start_locs_bravo [ i ].angles );
	}
	
	level.player teleport_player ( getent ( "itiot_pre_player_start", "targetname" ) );
	
	wait 0.05;
	
	for ( i = 0; i < level.squad1.size; i++ )
	{
		level.squad1 [ i ] teleport ( e3_start_locs_squad [ i ].origin, e3_start_locs_squad [ i ].angles );
		level.squad1 [ i ] set_force_color ( "r" );
	}
	
	level.player teleport_player ( getent ( "itiot_player_start", "targetname" ) );
	
	wait 0.05;
	
	level.sandman set_force_color ( "y" );
	
}

e3demo_combat()
{
	
	
	preseed_spawners = getentarray ( "e3demo_pre_seed", "targetname" );
	thread maps\_spawner::flood_spawner_scripted ( preseed_spawners );
	
	wave3_spawners = getentarray ( "nmy_wall_group_3", "targetname" );
	thread maps\_spawner::flood_spawner_scripted ( wave3_spawners );
	
	maps\_spawner::killspawner( 1011 );
	
	conversation_start();
	level.reno dialogue_queue ( "reno_line7" );
	conversation_stop();
	
	flag_wait ("tiff_fight_04");
	
	wave4_spawners = getentarray ( "nmy_wall_group_4", "targetname" );
	thread maps\_spawner::flood_spawner_scripted ( wave4_spawners );
	
	level.sandman thread dialogue_queue ( "lonestar_line39" );
	
	flag_wait ( "obj_nyse_rally_given" );
	
	maps\_spawner::killspawner( 1004 );
	
	//wave3 guys fall back
	wave3_guys = getentarray ( "wall_baddies_03", "script_noteworthy" );
	//array_thread ( wave3_guys, ::enable_heat_behavior, true );
	thread array_setgoalvolume ( wave3_guys, "volume_nyse_upper_combat" );
	
	flag_wait_either ( "give_xm25", "skip_paw" );
	
	foreach ( guy in wave3_guys )
	{
		if ( isdefined ( guy ) && isai ( guy ) )
		{
			guy delete();
		}
	}
	
	
}
	
	

introscreen_generic_fade_out( shader, pause_time, fade_in_time, fade_out_time )
{
    if ( !isdefined( fade_in_time ) )
    	fade_in_time = 1.5;

    introblack = NewHudElem();
    introblack.x = 0;
    introblack.y = 0;
    introblack.horzAlign = "fullscreen";
    introblack.vertAlign = "fullscreen";
    introblack.foreground = true;
    introblack SetShader( shader, 640, 480 );

    if ( IsDefined( fade_out_time ) && fade_out_time > 0 )
    {
	    introblack.alpha = 0;
	    introblack FadeOverTime( fade_out_time );
	    introblack.alpha = 1;
	    wait( fade_out_time );
    }

    wait pause_time;
    
    
    if ( IsDefined( fade_in_time ) && fade_in_time > 0 )
    {
	    introblack.alpha = 1;
	    introblack FadeOverTime( fade_in_time );
	    introblack.alpha = 0;
    }

    introblack destroy();
}
 
 demo_feed_lines( lines, interval )
 {
    keys = GetArrayKeys( lines );

    for ( i = 0; i < keys.size; i++ )
    {
        key = keys[ i ];
        time = ( i * interval ) + 1;
        delayThread( time, ::CenterLineThread, lines[ key ], ( lines.size - i - 1 ), interval, key );
    }
 }
 
 CenterLineThread( string, size, interval, index_key )
 {
    level notify( "new_introscreen_element" );

    hudelem = NewHudElem();
    hudelem.x = 0;
    hudelem.y = 0;
    hudelem.alignX = "center";
    hudelem.alignY = "middle";
    hudelem.horzAlign = "center";
    hudelem.vertAlign = "middle_adjustable";
    hudelem.sort = 1;// force to draw after the background
    hudelem.foreground = true;
    hudelem SetText( string );
    hudelem.alpha = 0;
    hudelem FadeOverTime( 0.2 );
    hudelem.alpha = 1;

    hudelem.hidewheninmenu = true;
    hudelem.fontScale = 2.4;// was 1.6 and 2.4, larger font change
    hudelem.color = ( 0.8, 1.0, 0.8 );
    hudelem.font = "objective";
    hudelem.glowColor = ( 0.3, 0.6, 0.3 );
    hudelem.glowAlpha = 1;
    duration = Int( ( interval * 1000 ) + 4000 );
    hudelem SetPulseFX( 30, duration, 700 );// something, decay start, decay duration

    thread maps\_introscreen::hudelem_destroy( hudelem );

    if ( !isdefined( index_key ) )
                    return;
    if ( !isstring( index_key ) )
                    return;
    if ( index_key != "date" )
                    return;
 }
