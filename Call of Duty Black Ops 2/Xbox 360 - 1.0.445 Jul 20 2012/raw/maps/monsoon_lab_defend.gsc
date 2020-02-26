/*
	MONSOON!
	
	SCRIPTERS: Kevin Drew, Damoun Shabestari, Sky Silcox
	BUILDERS: Gavin Goslin, Susan Arnold
	PROD: Brent Toda, John Dehart
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\monsoon_util;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_dialog;
#include maps\_anim;
#include maps\_dynamic_nodes;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

skipto_lab_defend()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
	
	skipto_teleport( "player_skipto_lab_defend", get_heroes() );
	
	lab_spawn_funcs();
		
	maps\monsoon_lab::temp_lab_dialogue();
}

init_lab_defend_flags()
{
	flag_init( "squad_at_ddm" );
	flag_init( "lab_defend_anim_done" );
	
	flag_init( "start_asd_wall_crash" );
	flag_init( "start_ceiling_rappelers" );
	
	flag_init( "spawn_left_defend_squad" );
	
	flag_init( "spawn_left_camo_squad" );
	flag_init( "spawn_right_camo_squad" );
	
	flag_init( "set_obj_help_isaac" );
	flag_init( "player_at_isaac" );
	
	flag_init( "start_defend_sm_think" );
	flag_init( "stop_defend_sm_think" );
	
	flag_init( "isaac_defend_start" );	
	flag_init( "isaac_now_vulnerable" );
	flag_init( "isaac_lives" );
	flag_init( "isaac_is_wounded" );
	flag_init( "isaac_is_killed" );
	
	flag_init( "salazar_at_hack_pos" );
	
	flag_init( "lab_defend_done" );
	
	flag_init( "rocket_intro_start" );
	flag_init( "rocket_intro_done" );
	
	flag_init( "open_asd_door" );
	flag_init( "player_asd_rollout" );
}

lab_defend_waves()
{
	level thread asd_wall_crash();
	level thread ceiling_rappelers();	
	level thread left_defend_squad();
	level thread left_camo_squad();
	level thread right_camo_squad();
}

lab_defend_main()
{
	flag_wait( "start_lab_defend" );
	
	lab_defend_waves();

	level.isaac = simple_spawn_single( "isaac" );
	level.isaac thread isaac_defend();	 
	
	level.salazar thread salazar_console_scene();
	
	level.crosby thread crosby_console_scene();
	
	level.harper thread harper_console_scene();
	
	array_wait( get_heroes(), "squad_at_ddm_pos" );
	
	trig_squad_at_console = GetEnt( "trig_squad_at_console", "targetname" );
	
	while ( 1 )
	{
		if ( level.crosby IsTouching( trig_squad_at_console ) &&
		   	 level.harper IsTouching( trig_squad_at_console ) &&
		  	 level.salazar IsTouching( trig_squad_at_console )
		   )
		{
			break;
		}
	
		wait 0.05;		
	}
	
	trig_ddm_regroup = GetEnt( "trig_ddm_regroup", "targetname" );
	trig_ddm_regroup trigger_on();
	trig_ddm_regroup waittill( "trigger" );
	trig_ddm_regroup Delete();
	
	autosave_by_name( "ddm_regroup" );	
	
	flag_set( "player_at_ddm" );
	
	level thread blast_doors_close();
	
	//TEMP DIALOGE
	level thread temp_isaac_dialog();

	end_scene( "salazar_console_loop" );
	delete_scene( "salazar_console_loop" );

	end_scene( "salazar_console_loop" );
	delete_scene( "salazar_console_loop" );

	end_scene( "salazar_console_loop" );
	delete_scene( "salazar_console_loop" );
	
	run_scene( "lab_defend_approach_isaac" );
	
	level thread run_scene( "lab_defend_player_loop" );
	
	flag_set( "set_obj_help_isaac" );
	
	level thread isaac_cabinet_nag();
	
	trig_isaac_player = GetEnt( "trig_isaac_player", "targetname" );
	trig_isaac_player trigger_on();
	trig_isaac_player waittill( "trigger" );
	trig_isaac_player Delete();
	
	flag_set( "player_at_isaac" );
	run_scene( "player_isaac_interact" );
		
	//at this point, all of the squad should end thier scene and run to cover and fight
	//isaac is now looping after his defend end anim
	run_scene( "lab_defend_end" );
	
	flag_set( "lab_defend_anim_done" );
			
	level.crosby.dontmelee = true;	
	nd_crosby_defend = GetNode( "nd_crosby_defend", "targetname" );
	level.crosby SetGoalNode( nd_crosby_defend );	
	
	level.harper thread harper_sheild_grab();

	level.salazar thread salazar_defend_think();
	
	level thread player_riotshield();
}

salazar_defend_think()
{
	self.dontmelee = true;	
	
	nd_salazar_defend = GetNode( "nd_salazar_defend", "targetname" );
	self SetGoalNode( nd_salazar_defend );
	self waittill( "goal" );
	
	//setup functions to wait for either isaacs death to hack, or isaac lives and he plays his celerium door anim
	self thread salazar_hack();	
}

harper_sheild_grab()
{
	run_scene( "harper_shield_plant" );
	
	self.dontmelee = true;	
	
	nd_harper_defend = GetNode( "nd_harper_defend", "targetname" );
	self SetGoalNode( nd_harper_defend );
}
	
blast_doors_close()
{
	e_lab_blast_doors = GetEnt( "lab_blast_doors", "targetname" );
	e_lab_blast_doors MoveZ( -128, 1 );
	e_lab_blast_doors waittill( "movedone" );
	e_lab_blast_doors DisconnectPaths();
	
	a_blast_door_nodes = GetNodeArray( "blast_door_nodes", "targetname" );
	foreach( node in a_blast_door_nodes )
	{
		node node_disconnect_from_path();
	}	
}

player_riotshield()
{
	//place shield in anim first frame
	run_scene_first_frame( "player_defend_shield" );
	
	trig_player_riotshield = GetEnt( "trig_player_riotshield", "targetname" );
	trig_player_riotshield trigger_on();
	trig_player_riotshield SetHintString( &"MONSOON_LIFT_PROMPT" );
	trig_player_riotshield waittill( "trigger" );
	trig_player_riotshield Delete();
		
	level thread run_scene( "player_defend_shield" );
	run_scene( "player_shield_grab" );
	
	level.player Giveweapon( "riotshield_sp" );
	level.player SwitchToWeapon( "riotshield_sp" );
}

isaac_cabinet_nag()
{
	n_nag_line_frequency = RandomIntRange( 4, 6 );
	
	while ( !flag( "player_at_isaac") )
	{
		n_index = RandomIntRange( 1, 4 );
		
		level.harper thread say_dialog( "harper_cabinet_nag_" + n_index );
		
		wait n_nag_line_frequency;
	}	
}

temp_isaac_dialog()
{
	level.harper thread say_dialog( "isaac_noise_1" );
	wait 3;
	level.harper thread say_dialog( "isaac_noise_2" );
	wait 3;
	level.player thread say_dialog( "isaac_noise_3" );
	
	flag_wait( "player_at_isaac" );
	
	level.isaac thread say_dialog( "isaac_reveal_1" );
	wait 3;
	level.isaac thread say_dialog( "isaac_reveal_2" );
	wait 3;
	level.salazar thread say_dialog( "isaac_reveal_3" );
	wait 3;
	level.isaac thread say_dialog( "isaac_reveal_4" );
	wait 3;
	level.harper thread say_dialog( "isaac_reveal_5" );
	wait 3;
	level.isaac thread say_dialog( "isaac_reveal_6" );
	wait 3;
	level.player thread say_dialog( "isaac_reveal_7" );
	
	flag_wait( "isaac_defend_start" );
	
	level.isaac thread say_dialog( "isaac_defend_1" );
	wait 3;
	level.harper thread say_dialog( "isaac_defend_2" );
	wait 3;
	level.salazar thread say_dialog( "isaac_defend_3" );
	wait 3;
	level.harper thread say_dialog( "isaac_defend_4" );
}

crosby_console_scene()
{
	self disable_ai_color();
	
	run_scene( "crosby_console_approach" );
	
	level thread run_scene( "crosby_console_loop" );
	
	self notify( "squad_at_ddm_pos" );
}

harper_console_scene()
{
	self disable_ai_color();
	
	run_scene( "harper_console_approach" );
	
	level thread run_scene( "harper_console_loop" );
	self notify( "squad_at_ddm_pos" );
}

salazar_console_scene()
{
	self disable_ai_color();
	
	run_scene( "salazar_console_approach" );
	
	level thread run_scene( "salazar_console_loop" );
	self notify( "squad_at_ddm_pos" );
	level.isaac notify( "squad_at_ddm_pos" );
}

salazar_hack()
{
	level endon( "isaac_lives" );
	
	flag_wait( "isaac_is_killed" );
	
	run_scene( "salazar_hack_approach" );

	level thread run_scene( "salazar_hack_loop" );
	
	flag_set( "salazar_at_hack_pos" );
}

isaac_defend()
{
	self endon( "death" );
	
	level thread run_scene( "isaac_console_loop" );
	
	flag_wait( "lab_defend_anim_done" );
	
	level thread run_scene( "isaac_hack_loop" );

	//handles enemy waves during defend
	level thread lab_defend_timer();
	
	level thread monitor_defend_spawns();
	
	flag_wait( "isaac_defend_start" );
	
	autosave_by_name( "defend_start" );	
	
	level.isaac.n_shots_taken = 0;
	
	level.isaac.overrideActorDamage = ::isaac_health_defend_callback;
	level.isaac thread monitor_isaac_health();
	
	//isaac death anim if he dies
	level thread monitor_isaac_death();
}

monitor_defend_spawns()
{
	level endon( "stop_defend_sm_think" );
	
	flag_wait( "start_defend_sm_think" );
	
	trig_spawn_area_1 = GetEnt( "trig_spawn_area_1", "targetname" );
	trig_spawn_area_2 = GetEnt( "trig_spawn_area_2", "targetname" );
		
	while ( 1 )
	{	
		if ( level.player IsTouching( trig_spawn_area_1 ) )
		{
			/#
				//IPrintLn( "player in area 1" );
			#/
				
			spawn_manager_disable( "trig_sm_area_defend_area_2" );
			
			spawn_manager_enable( "trig_sm_area_defend_area_1" );
		}
		else if ( level.player IsTouching( trig_spawn_area_2 ) )
		{
			/#
				//IPrintLn( "player in area 2" );
			#/
				
			spawn_manager_disable( "trig_sm_area_defend_area_1" );
			
			spawn_manager_enable( "trig_sm_area_defend_area_2" );
		}

		wait 0.05;
	}
}

isaac_health_defend_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	self.n_shots_taken++;
	
	/#
//		IPrintLn( self.n_shots_taken );
	#/	
	
	return 0;
}

monitor_isaac_health() //self = isaac
{
	level endon( "isaac_lives" );
	level endon( "lab_defend_done" );
	
	flag_wait( "isaac_now_vulnerable" );

	self stop_magic_bullet_shield();
	
	/#
//		IPrintLn( "isaac_healthy" );
	#/
	
	while ( self.n_shots_taken <= 50 )
	{
		wait 0.05;
	}
	
	/#
//		IPrintLn( "isaac_wounded" );
	#/
	
	flag_set( "isaac_is_wounded" );
	level.player thread say_dialog( "isaac_codes_wounded" );

	while ( self.n_shots_taken <= 100 )
	{
		wait 0.05;
	}
	
	/#
//		IPrintLn( "isaac_dead" );
	#/
	
	flag_set( "isaac_is_killed" );
	level.salazar thread say_dialog( "sala_salazar_isaac_is_de_0" );
}

lab_defend_timer()
{
	flag_set( "isaac_defend_start" );
	
	//light switch
	clientnotify( "defend_room_destroy" );
	VisionSetNaked( "sp_monsoon_defend_off", 2 );
	
	exploder( 1500 );
	
	wait 1;
	
	flag_set( "start_ceiling_rappelers" );

	wait 6;	
	
	flag_set( "start_asd_wall_crash" );
	
	wait 5;
	
	flag_set( "spawn_left_camo_squad" );
	flag_set( "spawn_left_defend_squad" );
	flag_set( "spawn_right_camo_squad" );
	
	flag_set( "start_defend_sm_think" );
	
	wait 5;
	
	flag_set( "isaac_now_vulnerable" );
	
	//light switch to normal
	clientnotify( "defend_room_destroy" );
	VisionSetNaked( "default", 2 );

	wait 30;
	
	flag_set( "stop_defend_sm_think" );
	
	//shutdown spawnmanagers
	spawn_manager_disable( "trig_sm_area_defend_area_1" );
	spawn_manager_disable( "trig_sm_area_defend_area_2" );
	
	a_ai = GetAiArray( "axis" );
	foreach( ai in a_ai )
	{
		// reduce goal radius
		// set closer spawner targets
		ai.goalradius = 32;
		ai set_spawner_targets( "front_attack_nodes" );
	}
	
	wait 1;
	
	//salazar is on his way to terminal to hack
	if ( !flag( "salazar_at_hack_pos" ) && flag( "isaac_is_killed" ) )
	{
		flag_wait( "salazar_at_hack_pos" );
	}
	
	if ( !flag( "isaac_is_killed" ) )
	{
		flag_set( "isaac_lives" );
		level.isaac magic_bullet_shield();
		//level.isaac thread say_dialog( "isaac_codes_success" );
		level.isaac thread say_dialog( "isaa_i_got_it_let_s_move_0" );
	}	
	else
	{
		level.salazar thread say_dialog( "sala_i_got_it_let_s_move_0" );
	}
	
	autosave_by_name( "defend_end" );	
	
	flag_set( "lab_defend_done" );
}

monitor_isaac_death()
{
	level endon( "isaac_lives" );
	
	flag_wait( "isaac_is_wounded" );
	
	end_scene( "isaac_hack_loop" );
	
	run_scene( "isaac_hack_reaction" );
	
	level thread run_scene( "isaac_hack_loop" );
	
	flag_wait( "isaac_is_killed" );
	
	end_scene( "isaac_hack_wounded_loop" );
	
	if ( level.isaac.magic_bullet_shield )
	{
		level.isaac stop_magic_bullet_shield();
	}
	
	run_scene( "isaac_hack_death" );
}

asd_wall_crash()
{
	flag_wait( "start_asd_wall_crash" );	
	
	spawn_vehicle_from_targetname( "asd_defend_1" );
	spawn_vehicle_from_targetname( "asd_defend_2" );	
	
	simple_spawn( "wall_crash_enemies" ); //7 AI
	
	a_crash_wall_damage_spots = getstructarray( "crash_wall_damage_spots", "targetname" );
	foreach( damage_struct in a_crash_wall_damage_spots )
	{
		RadiusDamage( damage_struct.origin, 200, 200, 450 );
	}		
	
	a_defend_crash_show = GetEntArray( "defend_crash_show", "targetname" );
	foreach( crash_piece in a_defend_crash_show )
	{
		crash_piece Show();
	}		
	
	defend_crash_hide = GetEntArray( "defend_crash_hide", "targetname" );
	foreach( piece in defend_crash_hide )
	{
		piece Hide();
	}		
	
	//panels
	m_asd_defend_panel_1 = GetEnt( "asd_defend_panel_1", "targetname" );
	m_asd_defend_panel_1 Delete();
	
	m_asd_defend_panel_2 = GetEnt( "asd_defend_panel_2", "targetname" );
	m_asd_defend_panel_2 Delete();
		
	//wall
	m_defend_crash_hide = GetEnt( "defend_crash_hide", "targetname" );
	m_defend_crash_hide ConnectPaths();
	m_defend_crash_hide Delete();
	
	s_wall_blast_pos = getstruct( "wall_blast_pos", "targetname" );
	
	//player rumble and screen shake
	Earthquake( 0.4, 0.5, level.player.origin, 256);
	level.player PlayRumbleOnEntity( "damage_heavy" );
		
	//if the player is close to wall, he dies
	n_distance = DistanceSquared( s_wall_blast_pos.origin, level.player.origin );
	if ( n_distance < 400 )
	{
		level.player kill();
	}	
	
	level thread asd_intro_destruction();
	
	exploder( 2000 );
	
	level notify( "fxanim_defend_truck_start" );
	
	//kill player if he is close to the wall blast
	s_wall_blast_pos = getstruct( "wall_blast_pos", "targetname" );
	n_distance = DistanceSquared( s_wall_blast_pos.origin, level.player.origin );
	if ( n_distance < 240 )
	{
		level.player kill();
	}
}

init_defend_left_asd() //self == asd_defend_1
{
	self endon( "death" );
	
	self thread player_asd_rumble();
	self thread monitor_defend_asd_death();

	self maps\_metal_storm::metalstorm_stop_ai();
	self.ignoreme = 1;
	
	nd_start_node = GetVehicleNode( self.target, "targetname" );
	self thread go_path( nd_start_node );
	
	self veh_magic_bullet_shield( true );

	flag_wait( "rocket_intro_start" );
	
	self veh_magic_bullet_shield( false );
	self.ignoreme = 0;
	self thread metalstorm_weapon_think();	
	
	self SetSpeed( 0, 3, 2 );
	
	//column shot
	s_column_target = getstruct( "column_target", "targetname" );
	e_column_target = Spawn( "script_origin", s_column_target.origin );
	e_column_target.angles = s_column_target.angles;
	
	self SetTurretTargetEnt( e_column_target );
	self waittill_notify_or_timeout( "turret_on_target", 0.5 );
	MagicBullet( "metalstorm_launcher", self GetTagOrigin( "TAG_MISSILE1" ), e_column_target.origin );
	self ClearTargetEntity();
	
	//tv shot
	s_tv_target = getstruct( "tv_target", "targetname" );
	e_tv_target = Spawn( "script_origin", s_tv_target.origin );
	e_tv_target.angles = s_tv_target.angles;
	
	self SetTurretTargetEnt( e_tv_target );
	self waittill_notify_or_timeout( "turret_on_target", 0.5 );
	MagicBullet( "metalstorm_launcher", self GetTagOrigin( "TAG_MISSILE1" ), e_tv_target.origin );
	self ClearTargetEntity();
	
	//overhead shot
	s_overhead_target = getstruct( "overhead_target", "targetname" );	
	e_overhead_target = Spawn( "script_origin", s_overhead_target.origin );
	e_overhead_target.angles = s_overhead_target.angles;
	
	self SetTurretTargetEnt( e_overhead_target );
	self waittill_notify_or_timeout( "turret_on_target", 0.5 );	
	MagicBullet( "metalstorm_launcher", self GetTagOrigin( "TAG_MISSILE1" ), e_overhead_target.origin );
	self ClearTargetEntity();
	
	flag_set( "rocket_intro_done" );
	flag_set( "rocket_intro_done" );
	self ResumeSpeed( 5 );
	
	self waittill( "reached_end_node" );
	self maps\_vehicle::vehicle_pathdetach();		
	
//	s_left_asd_attack_pos = getstruct( "left_asd_attack_pos", "targetname" );
//	self SetVehGoalPos( s_left_asd_attack_pos.origin, true, 2, true );
//	self waittill_any( "goal", "near_goal" );	
	
	self maps\_vehicle::defend( self.origin, 300 );	
}

init_defend_right_asd() //self == asd_defend_2
{
	self endon( "death" );
	
	self thread player_asd_rumble();
	self thread monitor_defend_asd_death();
	
	self maps\_metal_storm::metalstorm_stop_ai();

	nd_start_node = GetVehicleNode( self.target, "targetname" );
	self thread go_path( nd_start_node );

	self SetSpeed( 0, 3, 2 );
	 
	flag_wait( "rocket_intro_done" );
	
	self thread metalstorm_weapon_think();	
	
	self ResumeSpeed( 5 );
	
	self waittill( "reached_end_node" );
	
	self maps\_vehicle::vehicle_pathdetach();		
	
	self maps\_vehicle::defend( self.origin, 300 );		
}

init_right_path_asd()
{
	self endon( "death" );
	
	self thread player_asd_rumble();
	self thread monitor_defend_asd_death();	
	
	self maps\_metal_storm::metalstorm_stop_ai();
	
	nd_start_node = GetVehicleNode( self.target, "targetname" );
	self thread go_path( nd_start_node );	
	
	self SetSpeed( 5, 4, 1 );
	
	self waittill( "reached_end_node" );
	self maps\_vehicle::vehicle_pathdetach();		

	self maps\_vehicle::defend( self.origin, 200 );		
	
	trigger_wait( "trig_3_2_right_half" );

	s_right_path_asd_fallback = getstruct( "right_path_asd_fallback", "targetname" );
	self SetVehGoalPos( s_right_path_asd_fallback.origin, true, 2, true );
	self waittill_any( "goal", "near_goal" );	
	
	self maps\_vehicle::defend( self.origin, 200 );			
}

asd_intro_destruction()
{
	level endon( "defend_asd_destroyed" );
	
	//struct targets
	s_column_target = getstruct( "column_target", "targetname" );
	s_tv_target = getstruct( "tv_target", "targetname" );
	s_overhead_target = getstruct( "overhead_target", "targetname" );	
	
	//damage triggers
	trig_damage_pillar = GetEnt( "trig_damage_pillar", "targetname" );
	trig_damage_tv = GetEnt( "trig_damage_tv", "targetname" );
	
	trigger_wait( "trig_damage_pillar" );
	
	//player rumble and screen shake
	Earthquake( 0.4, 0.5, level.player.origin, 400 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
	
	//hide prestine
	defend_pillar_hide = GetEntArray( "defend_pillar_hide", "targetname" );
	foreach( piece in defend_pillar_hide )
	{
		piece Hide();
	}	
	
	//show destoryed state
	defend_pillar_show = GetEntArray( "defend_pillar_show", "targetname" );
	foreach( piece in defend_pillar_show )
	{
		piece Show();
	}		
	
	trigger_wait( "trig_damage_tv" );
	RadiusDamage( s_tv_target.origin, 300, 300, 300 );

	//player rumble and screen shake
	Earthquake( 0.4, 0.5, level.player.origin, 400 );
	level.player PlayRumbleOnEntity( "damage_heavy" );
}

ceiling_rappelers()
{
	flag_wait( "start_ceiling_rappelers" );
		
	a_rappel_glass_structs = getstructarray( "rappel_glass_structs", "targetname" );
	foreach( glass_struct in a_rappel_glass_structs )
	{
		RadiusDamage( glass_struct.origin, 200, 200, 450 );
	}
	
	simple_spawn( "defend_rappelers_wave_1", ::init_defend_rappelers );
	
	PlaySoundAtPosition ("evt_enemy_rappel_01", (7810, 56028, -1051));
	PlaySoundAtPosition ("evt_enemy_rappel_02", (7727, 55763, -1047));
	PlaySoundAtPosition ("evt_enemy_rappel_03", (7807, 56287, -1043));

	flag_wait( "start_asd_wall_crash" );

	simple_spawn( "defend_rappelers_wave_2", ::init_defend_rappelers );
	
	PlaySoundAtPosition ("evt_enemy_rappel_01", (7810, 56028, -1051));
	PlaySoundAtPosition ("evt_enemy_rappel_03", (7552, 55787, -1038));
	PlaySoundAtPosition ("evt_enemy_rappel_02", (7816, 56317, -1084));
}

#define INT_RAPPEL_TIME 2.5
#define B_SHOULD_CREATE_ROPE true
#define B_SHOULD_DELETE_ROPE true

init_defend_rappelers()
{
	self endon( "death" );
	
	s_rappel_struct = getstruct( self.target, "targetname" );
	
	self thread maps\_ai_rappel::start_ai_rappel( INT_RAPPEL_TIME, s_rappel_struct, B_SHOULD_CREATE_ROPE, B_SHOULD_DELETE_ROPE );
}

left_defend_squad()
{
	flag_wait( "spawn_left_defend_squad" );
	
	simple_spawn( "left_defend_squad" ); //2 AI
	
	//left door
	e_defend_door_03l = GetEnt( "defend_door_03l", "targetname" );
	e_defend_door_03l_clip = GetEnt( "defend_door_03l_clip", "targetname" );
	
	e_defend_door_03l_clip LinkTo( e_defend_door_03l );

	//right door
	e_defend_door_03r = GetEnt( "defend_door_03r", "targetname" );
	e_defend_door_03r_clip = GetEnt( "defend_door_03r_clip", "targetname" );
	
	e_defend_door_03r_clip LinkTo( e_defend_door_03r );
	
	e_defend_door_03l MoveY( -52, 1 );
	e_defend_door_03r MoveY( 52, 1 );
	
	e_defend_door_03r waittill( "movedone" );
	
	e_defend_door_03l ConnectPaths();	
	e_defend_door_03r ConnectPaths();	
	
	e_defend_door_03l_clip ConnectPaths();
	e_defend_door_03r_clip ConnectPaths();
}

left_camo_squad()
{
	flag_wait( "spawn_left_camo_squad" );
	
	simple_spawn( "left_camo_squad" ); // 2 AI
	
	//left door
	m_defend_door_01l = GetEnt( "defend_door_01l", "targetname" );
	bm_defend_door_01l_clip = GetEnt( "defend_door_01l_clip", "targetname" );
	
	bm_defend_door_01l_clip LinkTo( m_defend_door_01l );
	
	//right door
	m_defend_door_01r = GetEnt( "defend_door_01r", "targetname" );
	bm_defend_door_01r_clip = GetEnt( "defend_door_01r_clip", "targetname" );

	bm_defend_door_01r_clip LinkTo( m_defend_door_01r );
	
	m_defend_door_01l MoveY( 54, 0.5 );
	m_defend_door_01r MoveY( -54, 0.5 );
	
	m_defend_door_01l waittill( "movedone" );
	
	m_defend_door_01l ConnectPaths();
	m_defend_door_01r ConnectPaths();
	
	bm_defend_door_01l_clip ConnectPaths();
	bm_defend_door_01r_clip ConnectPaths();
}

right_camo_squad()
{
	flag_wait( "spawn_right_camo_squad" );
	
	simple_spawn( "right_camo_squad" ); // 2 AI
	
	//left door
	m_defend_door_02l = GetEnt( "defend_door_02l", "targetname" );
	bm_defend_door_02l_clip = GetEnt( "defend_door_02l_clip", "targetname" );
	
	bm_defend_door_02l_clip LinkTo( m_defend_door_02l );
	
	//right door
	m_defend_door_02r = GetEnt( "defend_door_02r", "targetname" );
	bm_defend_door_02r_clip = GetEnt( "defend_door_02r_clip", "targetname" );
	
	bm_defend_door_02r_clip LinkTo( m_defend_door_02r );
	
	m_defend_door_02l MoveX( 54, 0.5 );
	m_defend_door_02r MoveX( -54, 0.5 );

	m_defend_door_02l waittill( "movedone" );

	m_defend_door_02l ConnectPaths();
	m_defend_door_02r ConnectPaths();	
	
	bm_defend_door_02l_clip ConnectPaths();
	bm_defend_door_02r_clip ConnectPaths();	
}

monitor_defend_asd_death()
{
	level endon( "lab_defend_done" );
	
	self waittill( "death" );
	
	//kills damage trigger function
	level notify( "defend_asd_destroyed" ); 
	
	if ( cointoss() )
	{
		level.player thread say_dialog( "isaac_defend_asd_death_1" );		
	}
	else
	{
		level.player thread say_dialog( "isaac_defend_asd_death_2" );
	}
}