#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\angola_utility;
#include maps\_drones;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\angola.gsh;

skipto_savannah_start()
{
	skipto_teleport_players( "player_skipto_savannah_start" );	
	level thread maps\createart\angola_art::savannah_start();
	
	level.savimbi = init_hero( "savimbi", ::savimbi_setup );
	level thread run_scene( "savimbi_ride_idle" );
	
	//move vehicles up from the base
	a_vh = GetEntArray( "convoy", "script_noteworthy" );
	foreach( vh in a_vh )
	{
		if( IsDefined( vh.targetname ) && ( vh.targetname == "riverbed_convoy_buffel" || vh.targetname == "convoy_destroy_2" || vh.targetname == "riverbed_convoy_eland" ) )
		{
			///if( vh.targetname != "riverbed_convoy_buffel" )
			{
				vh.drivepath = true;
			}			
			vh thread go_path();
		}
		vh SetSpeed( 20 );
	}
}

skipto_savannah_hill()
{
	cleanup_riverbed_scenes();
	//cleanup_savannah_hill();
	
	skipto_teleport_players( "player_skipto_savannah_hill" );
	level thread maps\createart\angola_art::savannah_start();
	
	level.player SetClientDvar( "r_lodScaleRigid", 0.1 );
	
	savannah_drone_setup();
	
	level thread animate_grass( true );
	
	level.savimbi = init_hero( "savimbi", ::savimbi_setup );
	level thread run_scene( "savimbi_ride_idle" );

	//move vehicles up from the base
	a_vh = GetEntArray( "convoy", "script_noteworthy" );
	array_thread( a_vh, ::load_buffel );
	foreach( vh in a_vh )
	{
		vh veh_magic_bullet_shield( true );
		if( IsDefined( vh.targetname ) && vh.targetname == "savimbi_buffel" )
		{
			nd_start = GetVehicleNode( "savimbi_buffel_brim_path", "targetname" );
			vh thread go_path( nd_start );	
			vh thread savimbi_buffel();
		}
		else if( IsDefined( vh.targetname ) && ( vh.targetname == "riverbed_convoy_buffel" || vh.targetname == "convoy_destroy_2" || vh.targetname == "riverbed_convoy_eland" ) )
		{
			///nd_start = GetVehicleNode( vh.targetname + "_savannah_start", "script_noteworthy" );
			vh thread go_path();
			vh SetSpeed( 20 );
			//self waittill( "vehicle_flag_arrived" );
			flag_set( "convoy_continue_path" );
		}
		else
		{	
			vh thread go_path();
		}
		vh SetSpeed( 20 );
	}	
	level thread mortar_buffel_blocker();
	level.player delay_thread( 10, ::player_convoy_watch, "savannah_final_push_success" );	
	
	level thread setup_threat_bias_group();
	
	level.player.overridePlayerDamage = ::savannah_player_damage_override;
}

skipto_debug_heli_strafe()
{
	cleanup_riverbed_scenes();
	
	skipto_teleport_players( "player_skipto_savannah_hill" );
	flag_set( "skipto_debug_heli_strafe" );
	
	level.player SetClientDvar( "r_lodScaleRigid", 0.1 );
	
	savannah_drone_setup();
	
	level.savimbi = init_hero( "savimbi", ::savimbi_setup );
	level thread run_scene( "savimbi_ride_idle" );

	//move vehicles up from the base
	a_vh = GetEntArray( "convoy", "script_noteworthy" );
	array_thread( a_vh, ::load_buffel );
	foreach( vh in a_vh )
	{
		vh veh_magic_bullet_shield( true );
		if( IsDefined( vh.targetname ) && vh.targetname == "savimbi_buffel" )
		{
			nd_start = GetVehicleNode( "savimbi_buffel_brim_path", "targetname" );
			vh thread go_path( nd_start );	
			vh thread savimbi_buffel();
		}
		else
		{	
			vh thread go_path();
		}
		vh SetSpeed( 20 );
	}	
	
	level.player delay_thread( 10, ::player_convoy_watch, "savannah_final_push_success" );
	
	level.player.overridePlayerDamage = ::savannah_player_damage_override;
}

skipto_savannah_finish()
{
	cleanup_riverbed_scenes();
	cleanup_savannah_start();
	
	level thread maps\createart\angola_art::savannah_finish();
	
	flag_set( "savannah_done" );
	
}


#define OBJ_IND_FAR_DIST_FAR 8000
#define OBJ_IND_FAR_DIST_CLOSE 3000
#define OBJ_IND_FAR_DIST_CLOSER 1000
challenge_heli_runs( str_notify )
{
	level.num_heli_runs = 0;
	
	flag_wait( "savannah_final_push_success" );
	
	if( level.num_heli_runs < 4 )
	{
		self notify( str_notify );
	}
}

//TODO: Convert story stat variables to temp stat system (once it gets authored by Lucas)
challenge_machete_gibs( str_notify )
{	
	add_global_spawn_function( "axis", ::check_machete_death, str_notify );
	/*b_right_arm = false;
	b_left_arm = false;
	b_right_leg = false;
	b_left_leg = false;
	b_head = false;
	
	n_machete_gib_counter = 0;
	n_machete_gib_total = 5;
	n_unique_gib = 0;
	
	while ( n_machete_gib_counter < n_machete_gib_total )
	{
		gib = level waittill_any_return( "machete_gib_head", "machete_gib_right_arm", "machete_gib_left_arm", 
		                                "machete_gib_right_leg", "machete_gib_left_leg", "machete_gib_no_legs");
		
		switch( gib )
		{
			case "machete_gib_right_arm":
				if( !b_right_arm )
				{	
					n_unique_gib++;
					b_right_arm = true;
					set_temp_stat( ANGOLA_RARM_CHOP, 1);
					//PrintLn( "Right Arm Gibbed");
				}
				break;
			
			case "machete_gib_left_arm":
				if( !b_left_arm )
				{	
					n_unique_gib++;
					b_left_arm = true;
					set_temp_stat( ANGOLA_LARM_CHOP, 1);
					//PrintLn( "Left Arm Gibbed");
				} 
				break;
			
			case "machete_gib_right_leg":
				if( !b_right_leg )
				{	
					n_unique_gib++;
					b_right_leg = true;
					set_temp_stat( ANGOLA_RLEG_CHOP, 1);
					//PrintLn( "Right Leg Gibbed");
				}  
				break; 
			
			case "machete_gib_left_leg":
				if( !b_left_leg )
				{	
					n_unique_gib++;
					b_left_leg = true;
					set_temp_stat( ANGOLA_LLEG_CHOP, 1);
					//PrintLn( "Left Leg Gibbed");
				}  
				break;

			case "machete_gib_no_legs":
				if( !b_right_leg )
				{	
					n_unique_gib++;
					b_right_leg = true;
					set_temp_stat( ANGOLA_RLEG_CHOP, 1);
					//PrintLn( "Right Leg Gibbed");
				}  
				
				if( !b_left_leg )
				{	
					n_unique_gib++;
					b_left_leg = true;
					set_temp_stat( ANGOLA_LLEG_CHOP, 1);
					//PrintLn( "Left Leg Gibbed");
				}				
				break;				
			
			case "machete_gib_head":
				if( !b_head )
				{	
					n_unique_gib++;
					b_head = true;
					set_temp_stat( ANGOLA_HEAD_CHOP, 1);
					//PrintLn( "Head Gibbed");
				}  
				break; 
		}
		
		while (n_unique_gib > 0)
		{
			self notify( str_notify );
			n_machete_gib_counter++;
			n_unique_gib--;
			wait 0.1;
		}
	}*/		
}

check_machete_death( str_notify )
{
	self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname );
	
	//Check if the player killed the enemy and if he did it with the machete
	if( (attacker == level.player) && (type == "MOD_MELEE") )
	{
		level notify( str_notify );
	}
}

challenge_mortar_kills( str_notify )
{
	self endon( str_notify );
	
	while ( !flag("mortar_challenge_complete") )
	{
		level.player waittill( "grenade_fire", e_grenade, str_weapon_name );
		
		if ( str_weapon_name == "mortar_shell_sp" )
		{	
			e_grenade thread check_mortar_killcount();
		}
	}
	
	self notify( str_notify );
}

//hardcoded radius to match mortar damage radius
#define MORTAR_SP_RADIUS 512

check_mortar_killcount() //self = grenade
{
	self waittill( "death" );
	
	wait 0.25;
	
	a_enemies = GetAIArray( "axis" );
	a_drones = drones_get_array( "axis" );
	a_enemies_and_drones = ArrayCombine( a_enemies, a_drones,true,false );
	a_enemies_in_range = get_within_range( self.origin, a_enemies_and_drones, MORTAR_SP_RADIUS );
	
	n_killcount = 0;
	
	foreach( guy in a_enemies_in_range )
	{
		if(	!(is_alive(guy)) )
		{
			n_killcount++;
		}  	
		else if( (guy.targetname == "drone") && (isdefined(guy.dead)) )
		{
			n_killcount++;
		}
	}
	
	iprintlnbold( "Mortar toss killed " + n_killcount);
	
	if (n_killcount >= 5)
	{
		flag_set( "mortar_challenge_complete" );
	}
}
 
init_flags()
{
	flag_init( "savannah_base_reached" );
	flag_init( "savannah_brim_reached" );
	flag_init( "savannah_final_push" );
	flag_init( "savannah_final_push_success" );
	flag_init( "savannah_player_boarded_buffel" );
	flag_init( "savannah_done" );
	flag_init( "savannah_start_hudson" );
	flag_init( "player_in_helicopter" );
	flag_init( "skipto_debug_heli_strafe" );
	flag_init( "buffel2_continue_path" );
	flag_init( "buffel1_continue_path" );
	flag_init( "savannah_convoy_start" );
	flag_init( "mortar_challenge_complete" );
	flag_init( "final_push" );
	flag_init( "wave_one_done" );
	flag_init( "wave_two_done" );
	flag_init( "pause_fire" );
}

savannah_drone_setup()
{
	level.drones.max_drones = 300;
	maps\_drones::drones_set_impact_effect( level._effect[ "drone_impact_fx" ] );
	
	sp_drone_mpla = GetEnt( "mpla_drone", "targetname" );
	drones_assign_spawner( "mpla_drones", sp_drone_mpla );
	
	sp_drone_mpla_high = GetEnt( "mpla_drone_high", "targetname" );
	drones_assign_spawner( "mpla_drones_high", sp_drone_mpla_high );
	drones_assign_spawner( "brim_mpla_drones", sp_drone_mpla_high );
	
	sp_drone_unita = GetEnt( "unita_drone", "targetname" );
	drones_assign_spawner( "unita_drones", sp_drone_unita );
}

/#
draw_team_targetname()
{
	self endon("death");
	
	while(1)
	{		
		RecordEntText( self.team + self.targetname, self, (1,1,1), "Script" );
		wait 0.05;
	}
}
#/
	
savannah_start()
{
	/#	
	//array_thread( GetSpawnerArray(), ::add_spawn_function, ::draw_team_targetname );
	#/
		
	level.player.overridePlayerDamage = ::savannah_player_damage_override;
	
	level.player SetClientDvar( "r_lodScaleRigid", 0.1 );
	savannah_drone_setup();
	
	level thread setup_threat_bias_group();
	
	level thread savannah_start_mortars();
	//level thread heli_strafe_run_sound();

	sp_unita = GetEnt( "savannah_start_unita", "targetname" );
	sp_mpla = GetEnt( "savannah_start_mpla", "targetname" );

	for( i = 1; i < 7; i++ )
	{
		ai_unita = sp_unita spawn_ai( true );
		ai_unita.animname = "unita_0" + i;
		ai_unita.script_noteworthy = "initial_brim";
		ai_unita.a.nodeath = true;
		//all but the last have a machete
		if( i != 6 )
		{
			ai_unita.script_string = "machete";
			ai_unita maps\_mpla_unita::setup_mpla();
			//ai_unita equip_machete();
			ai_unita.dontmelee = true;
		}
	}
	
	//spawn initial AI between the convoy
	trigger_use( "sm_brim_initial" );
	
	level thread run_scene( "unita_wait" );
	
	a_veh_buffels = GetEntArray( "convoy", "script_noteworthy" );
	array_thread( a_veh_buffels, ::load_buffel );
	
	flag_wait( "savannah_base_reached" );
	
	level thread maps\createart\angola_art::savannah_start();
		
	//save game
	autosave_by_name( "savannah_start" );
	
	level.player thread player_convoy_watch( "savannah_final_push_success" );
	
	//stop effects from playing in the starting area of the level
	stop_exploder( EXPLODER_INTRO );
	level thread cleanup_riverbed_scenes();
	
	//explosions stop and it gets uncomfortably quiet
	level.savimbi thread vo_play_savannah_start();
	
	wait 5;
	
	//start drone spawning in script
	drones_start( "brim_mpla_drones" );
	drones_set_cheap_flag( "brim_mpla_drones", true );
	
	//start spawning the real AI
	playsoundatposition ( "evt_enemy_charge" , (1243, 1625, 210));
	
	//Tuey - switch music to ANGOLA_SAVANNAH_BATTLE
	setmusicstate ("ANGOLA_SAVANNAH_BATTLE");
	
	level.savimbi delay_thread( 1, ::say_dialog, "savi_here_they_come_0" );//Here they come!!!
	level.savimbi delay_thread( 2, ::say_dialog, "savi_fight_my_brothers_0" );//Fight my brothers!
	
	level clientnotify( "pgw" );
	level thread fake_battle_loop();
	
	trigger_use( "sm_brim_shooters" );
	
	wait 2;
	
	level thread set_pre_melee_mortars();	
	//level.player thread say_dialog( "savimbi_hold" );
	
	wait 5.5;
		
	level thread set_melee_mortars();
	
	ai_mpla_array = [];
	for( i = 1; i < 9; i++ )
	{
		ai_mpla = sp_mpla spawn_ai( true );
		ai_mpla magic_bullet_shield();
		ai_mpla_array[ai_mpla_array.size] = ai_mpla;
		ai_mpla.animname = "mpla_0" + i;
		ai_mpla.script_noteworthy = "initial_brim";
		ai_mpla.a.nodeath = true;
		//all but the last have a machete
		if( i != 8 )
		{
			ai_mpla.script_string = "machete";
			ai_mpla maps\_mpla_unita::setup_mpla();			
			//ai_mpla equip_machete();
		}
	}	
	
	level thread run_scene( "initial_charge" );
	level thread savimbi_shoot();
	trigger_use( "sm_hill_machete" );
	
	foreach( ai_enemy in ai_mpla_array )
	{
		ai_enemy stop_magic_bullet_shield();
	}	

	//wait 1;
	
	level thread savannah_brim_fights();
	
	a_ai_initial = GetEntArray( "initial_brim", "script_noteworthy" );
	array_thread( a_ai_initial, ::_random_death );
	
	//the convoy starts to move up to the brim
	a_vh = GetEntArray( "convoy", "script_noteworthy" );
	foreach( vh in a_vh )
	{
		vh veh_magic_bullet_shield( true );
		vh.drivepath = true;
		vh thread maps\_vehicle::disconnect_paths_while_moving( 0.5 );
		vh SetSpeed( 3 );
		
		if( IsDefined( vh.targetname ) && vh.targetname == "savimbi_buffel" )
		{
			nd_start = GetVehicleNode( "savimbi_buffel_brim_path", "targetname" );
			vh thread go_path( nd_start );
		}
		else
		{	
			flag_set( "convoy_continue_path" );
			vh thread go_path();
		}
					
		wait RandomFloatRange( 0.2, 0.5 );
	}
	
	vh_lead = GetEnt( "savimbi_buffel", "targetname" );
	vh_lead thread savimbi_buffel();
	
	//setup blocker for hilltop ally spawners
	level thread mortar_buffel_blocker();
	
	flag_wait( "savannah_brim_reached" );
	
	level thread animate_grass( true );
	level thread cleanup_savannah_start();
}

set_pre_melee_mortars()
{
	for( x = 1; x < 6; x++ )
	{
		str_mortar = "start_melee_mortar" + x;
		s_mortar = getstruct( str_mortar, "script_noteworthy" );
		PlayFx( getfx( "mortar_savannah" ), s_mortar.origin );
		wait RandomFloatRange( 1.1, 1.2 );
	}
}

set_melee_mortars()
{
	melee_pos1 = GetEnt( "start_melee_mortar1", "targetname" );
	melee_pos2 = GetEnt( "start_melee_mortar2", "targetname" );
	melee_pos3 = GetEnt( "start_melee_mortar3", "targetname" );
	
	PlayFx( getfx( "mortar_savannah" ), melee_pos1.origin ); 
	wait .25;
	PlayFx( getfx( "mortar_savannah" ), melee_pos2.origin );
	wait .25;
	PlayFx( getfx( "mortar_savannah" ), melee_pos3.origin );	
}

vo_play_savannah_start()
{
	wait 1.5;
	self say_dialog( "savi_the_mortars_have_sto_0" );//The mortars have stopped.
	wait 0.5;
	self say_dialog( "maso_they_re_about_to_cha_0" );//They’re about to charge.
}

cleanup_savannah_start()
{
	ai_sweepers = GetEntArray( "convoy_trailers", "script_noteworthy" );
	foreach( sweeper in ai_sweepers )
	{
		sweeper stop_magic_bullet_shield();
		sweeper bloody_death();
	}
	
	delete_scene( "unita_wait", true );
	delete_scene( "initial_charge", true );
	
	delete_array( "brim_ally", "targetname" );
	delete_array( "brim_ally2", "targetname" );	
	delete_array( "savannah_start_unita", "targetname" );
	delete_array( "savannah_start_mpla", "targetname" );
	delete_array( "brim_ally_initial", "targetname" );
	delete_array( "sm_brim_initial", "targetname" );
}

savannah_start_mortars()
{
	// sets up the endon for this mortar group
	level._explosion_stopNotify[ "mortar_savannah_start" ] = "stop_savannah_start_mortars";
	
	// starts the mortar loop for this mortar group
	level thread maps\_mortar::set_mortar_delays( "mortar_savannah_start", 1, 3 );	
	level thread maps\_mortar::set_mortar_damage( "mortar_savannah_start", 256, 1001, 1003 );	
	level thread maps\_mortar::mortar_loop( "mortar_savannah_start" );
	
	flag_wait( "savannah_base_reached" );
		
	// notifies the mortar group with this string to stop
	level notify( "stop_savannah_start_mortars" );
}

mortar_buffel_blocker()
{
	flag_wait( "fire_eland_mortar" );
	vh_buffel_mortar = GetEnt( "buffel_mortar", "targetname" );
	PlayFx( getfx( "mortar_savannah" ), vh_buffel_mortar.origin );
	vh_buffel_mortar thread destroy_buffel();
	vh_buffel_mortar waittill( "reached_end_node" );
	vh_buffel_mortar notify( "death" );
}

//self is the buffel savimbi is riding
savimbi_buffel()
{
	self waittill( "stop_brim_drones" );
	
	//stop drone spawning in script
	drones_delete( "brim_mpla_drones" );
	
	self waittill( "stop_brim_fights" );
	
	flag_set( "savannah_brim_reached" );
	
	spawn_manager_kill( "sm_brim_shooters" );
		
	//self waittill_any( "reached_end_node", "vehicle_flag_arrived" );
	self waittill( "savimbi_hill_wait" );
	self setspeedimmediate( 0 );

	level.savimbi setup_savimbi_for_battle();
	run_scene( "savimbi_join_battle" );
	level.savimbi unequip_savimbi_machete_battle();
	level.savimbi set_ignoreme( false );
	//level.savimbi unequip_savimbi_machete();
}

setup_savimbi_for_battle()
{
	self equip_savimbi_machete_battle();
	self Attach( "t6_wpn_launch_mm1_world", "tag_weapon_left" );
	self Detach( "t6_wpn_launch_mm1_world", "tag_weapon_right" );	
	self set_ignoreme( true );
}

savimbi_buffel_drop_mgl( savimbi )
{
	savimbi Detach( "t6_wpn_launch_mm1_world", "tag_weapon_left" );
}

savimbi_buffel_spawn_enemy( savimbi )
{
	v_buffel = GetEnt( "savimbi_buffel", "targetname" );
	v_origin = GetStartOrigin( v_buffel GetTagOrigin( "tag_rear_door_l" ), v_buffel GetTagAngles( "tag_rear_door_l" ) , %generic_human::ch_ang_03_01_savimbi_joins_enemy );
	
	PlayFx( getfx( "mortar_savannah" ), v_origin ); 
		
	run_scene( "savimbi_join_battle_enemy" );
}

savannah_destroy_buffel1()
{
	vh_buffel_1 = GetEnt( "convoy_destroy_1", "targetname" );
	vh_buffel_1 destroy_buffel();
	flag_set("buffel1_continue_path");
	vh_buffel_1  waittill( "reached_end_node" );
	vh_buffel_1 notify( "death" );
}

savannah_destroy_buffel2()
{
	vh_buffel_2 = GetEnt( "convoy_destroy_2", "targetname" );	
	vh_buffel_2 destroy_buffel();	
	flag_set("buffel2_continue_path");
	vh_buffel_2  waittill( "reached_end_node" );
	vh_buffel_2 notify( "death" );
}

savannah_destroy_eland_fight()
{
	level thread run_scene( "post_heli_run_fight" );
	level thread savannah_destroy_eland();
	level thread cleanup_post_heli_fight();
}

savannah_destroy_eland( e_enemy )
{	
	v_eland = GetEnt( "eland_hero", "targetname" );
	//m_eland = spawn_model( "veh_t6_mil_eland", v_eland.origin, v_eland.angles );
	//m_eland.animname = "model_eland_destroy";
	
	//VEHICLE_DELETE( v_eland );
	v_eland veh_magic_bullet_shield( false );
	//fire_pos = getent( "heli_fire_2", "targetname" );
	//MagicBullet( "t72_turret", fire_pos.origin, v_eland.origin );
	wait .05;
	
	v_eland playsound( "exp_veh_large" );
	PlayFx( getfx( "mortar_savannah" ), v_eland.origin );
	radiusdamage( v_eland.origin, 100, 20, 10, undefined, "MOD_PROJECTILE_SPLASH" );
	run_scene( "destroy_eland" );
	v_eland notify( "death" );	
}

savimbi_shoot()
{
	while( !flag( "savannah_brim_reached" ) )
	{
		//run_scene( "savimbi_fire_start" );
		//run_scene( "savimbi_fire_loop" );
		//run_scene( "savimbi_fire_stop" );
		end_scene( "savimbi_ride_idle" );
		run_scene( "savimbi_fire_mgl" );
		level thread run_scene( "savimbi_ride_idle" );
		wait RandomFloatRange( 4.0, 6.0 );
	}
}

savannah_brim_fights()
{
	init_fight( "brim_fight", "brim_ally", "brim_axis" );
	
	a_ai_initial = GetEntArray( "brim_ally_initial_ai", "targetname" );
	
	foreach( ai in a_ai_initial )
	{
		if( IsDefined( ai ) && IsAlive( ai ) )
		{
			create_fight( ai );
			//wait 2;
		}
	}
	
	while( !flag( "savannah_brim_reached" ) )
	{
		create_fight();
		wait RandomFloatRange( 1.5, 2.5 );
	}
}

#define TANK_KILLS_TO_PROGRESS 5
#define TANK_KILLS_TO_FINISH 3
	
#define TANK_KILLS_FIRST_WAVE 2
#define TANK_KILLS_SECOND_WAVE 4
#define TANK_KILL_FINAL_WAVE 3
	
#define RPG_KILLS_FIRST_WAVE 4
#define RPG_KILLS_SECOND_WAVE 6
savannah_hill()
{
	level.savannah_tank_kills = 0;
	level.savannah_final_push_kills = 0;
	level.savannah_first_wave_kills = 0;
	level.savannah_second_wave_kills = 0;
	level.savannah_final_wave_kills = 0;
	
	level.savannah_first_wave_rpg_kills = 0;
	level.savannah_second_wave_rpg_kills = 0;
	
	level thread maps\createart\angola_art::savannah_hill();
	
	//spawn the initial tanks
	///trigger_use( "first_tanks" );
	trigger_use( "first_wave" );
	level thread setup_wave_one_launchers();
	level thread wave_one_tank_fire();
	
	level.player thread heli_strafing_watch();
	level.player thread tank_fail_watch();
	level thread savannah_mortars();
	///level thread savannah_hill_deform_terrain();
	level thread set_water_dvars_strafe();
	
	sp_hill_shooters = GetEntArray( "hill_shooter", "targetname" );
	sp_brim_shooters = GetEntArray( "brim_shooter", "targetname" );
	sp_all_shooters = ArrayCombine( sp_hill_shooters, sp_brim_shooters,true,false );
	foreach( shooter in sp_all_shooters )
	{
		shooter add_spawn_function( ::init_hill_shooter );
	}
	
	sp_hill_machete = GetEntArray( "hill_machete", "targetname" );
	foreach( machete_guy in sp_hill_machete )
	{
		machete_guy add_spawn_function( ::init_hill_shooter );
	}
	
	//trigger_use( "sm_hill_machete" );
	trigger_use( "sm_hill_shooters" );
	
	//setup and hide the use trigger to board the buffel
	t_use = GetEnt( "trigger_board_buffel", "targetname" );
	//t_use SetHintString( &"ANGOLA_BOARD_BUFFEL_HINT" );
	//t_use SetCursorHint( "HINT_NOICON" );
	t_use trigger_off();
	
	//eland logic
	a_veh_elands = GetEntArray( "convoy", "script_noteworthy" );
	array_thread( a_veh_elands, ::eland_think, true );
	array_thread( a_veh_elands, ::buffel_gunner_think, true );
	
	add_spawn_function_veh_by_type( "tank_t62_nophysics", ::tank_think );
	
	//sets the draw distance of objectives
	level.player SetClientDvar( "cg_objectiveIndicatorFarFadeDist", OBJ_IND_FAR_DIST_CLOSE );

	///set_objective( level.OBJ_DESTROY_TANKS, undefined, undefined, level.savannah_tank_kills );
	set_objective( level.OBJ_DESTROY_FIRST_WAVE, undefined, undefined, level.savannah_first_wave_kills );
	
	//start shrimps
	exploder( 2000 );
	
	//start drone spawning in script
	drones_start( "mpla_drones" );
	drones_set_cheap_flag( "mpla_drones", true );
	drones_start( "mpla_drones_high" );
	drones_set_cheap_flag( "mpla_drones_high", true );
	drones_start( "unita_drones" );
	
	//start fights in the immediate foreground
	level thread savannah_hill_fights();
	
	//save
	autosave_by_name( "savannah_hill" );
	
	//hold until a certain amount of tanks have been killed	
	while( level.savannah_first_wave_kills < TANK_KILLS_FIRST_WAVE )
	{
		wait 1;
	}	
	
	flag_set( "wave_one_done" );
	
	//hold until second wave tanks have been killed	
	while( level.savannah_second_wave_kills < TANK_KILLS_SECOND_WAVE )
	{
		wait 1;
	}	
	//hold until a certain amount of tanks have been killed	
	/*while( level.savannah_tank_kills < TANK_KILLS_TO_PROGRESS )
	{
		wait 1;
	}*/
	
	flag_set( "savannah_final_push" );
	level notify( "stop_fire" );
	
	spawn_manager_kill( "sm_hill_machete" );
	spawn_manager_kill( "sm_hill_shooters" );
	
	//show the use trigger to board the buffel
	t_use = GetEnt( "trigger_board_buffel", "targetname" );
	t_use trigger_on();
	
	///set_objective( level.OBJ_DESTROY_TANKS, undefined, "done" );
	
	flag_waitopen( "player_in_helicopter" );
	
	set_objective( level.OBJ_GET_TO_BUFFEL, GetEnt( "trigger_board_buffel", "targetname" ) );
	
	//wait for the player to get onto the buffel (or fail to under the time limit)
	level thread savannah_board_buffel();
	
	flag_wait( "savannah_player_boarded_buffel" );
	
	set_objective( level.OBJ_GET_TO_BUFFEL, undefined, "done" );
	set_objective( level.OBJ_DESTROY_FINAL_WAVE, undefined, undefined, level.savannah_final_push_kills );

	//stop friendly drones
	drones_delete( "unita_drones" );
	
	//stop the shrimps
	stop_exploder( 2000 );
	
	//hold until a certain amount of tanks have been killed
	while( level.savannah_final_push_kills < TANK_KILLS_TO_FINISH )
	{
		wait 1;
	}	
	
	flag_set( "savannah_final_push_success" );
	drones_delete( "mpla_drones" );
	drones_delete( "mpla_drones_high" );
	
	set_objective( level.OBJ_DESTROY_FINAL_WAVE, undefined, "done" );
	
}

vo_play_savannah_hill()
{
	self say_dialog( "maso_dammit_hudson_they_0" );//Dammit Hudson!  They’ve got T-62 tanks in support.
	wait 0.5;
	self say_dialog( "maso_we_need_you_to_take_0" );//We need you to take the heat off.
}

//test case for this idea
savannah_hill_deform_terrain()
{
	wait RandomFloatRange( 10, 20 );
	
	m_terrain = GetEnt( "mortar_top_1", "targetname" );
	m_terrain maps\_mortar::explosion_boom( "mortar_savannah" );
	m_terrain Delete();
}

#define HILL_FIGHT_MAX 6
savannah_hill_fights()
{
	init_fight( "hill_fight", "hill_ally", "hill_axis" );
	
	n_fight_counter = 0;
	while( !flag( "savannah_final_push" ) )
	{
		if( n_fight_counter >= HILL_FIGHT_MAX )
		{
			create_fight( undefined, undefined, true );
			n_fight_counter = 0;
		}
		else
		{
			create_fight();	
		}
		
		wait RandomFloatRange( 2.0, 3.0 );
		n_fight_counter++;
	}
}

savannah_wave_one_fights()
{
	init_fight( "wave_one_fight", "wave_one_ally", "hill_axis" );
	
	n_fight_counter = 0;
	while( !flag( "savannah_final_push" ) )
	{
		if( n_fight_counter >= HILL_FIGHT_MAX )
		{
			create_fight( undefined, undefined, true );
			n_fight_counter = 0;
		}
		else
		{
			create_fight();	
		}
		
		wait RandomFloatRange( 2.0, 3.0 );
		n_fight_counter++;
	}
}


savannah_board_buffel()
{
	veh_buffel = GetEnt( "savimbi_buffel", "targetname" );
	veh_buffel veh_magic_bullet_shield( true );
	
	level thread savannah_board_buffel_savimbi();	
	level thread savannah_board_buffel_fail();
	
	//t_use = trigger_wait( "trigger_board_buffel" );
	t_use = GetEnt( "trigger_board_buffel", "targetname" );
	t_use waittill( "trigger" );
	t_use Delete();
			
	flag_set( "savannah_player_boarded_buffel" );
	
	run_scene( "player_board_buffel" );
	
	//Tuey - resetting the audio snapshot back to default so the ambient sound comes back up.
	level clientNotify ("pobws");
	
	level thread run_scene( "savimbi_ride_idle" );
	level thread run_scene( "player_ride_buffel" );
	
	level thread refill_player_clip();
	level.player EnableWeapons();
	level.player ShowViewModel();
	level.player EnableInvulnerability();

	wait 1;
	
	//nd_start = GetVehicleNode( "player_buffel_path", "targetname" );
	//veh_buffel thread go_path( nd_start );
	
	e_mortar1 = GetEnt( "final_push_mortar1", "targetname" );
	e_mortar2 = GetEnt( "final_push_mortar2", "targetname" );
	e_mortar3 = GetEnt( "final_push_mortar3", "targetname" );
	
	flag_set( "final_push" );
	wait 0.05;
	veh_buffel SetSpeed( 8 );
	PlayFx( getfx( "mortar_savannah" ), e_mortar1.origin );
	
	level.hudson say_dialog( "huds_mason_tell_zavimbi_0" );//Mason!  Tell Zavimbi to hold on the advance.  We got more tanks inbound!
	wait 0.5;
	level.player say_dialog( "maso_i_don_t_think_he_s_g_0" );//I don’t think he’s gonna listen.
	
	wait 0.10;
	PlayFx( getfx( "mortar_savannah" ), e_mortar2.origin );
	wait 0.35;
	PlayFx( getfx( "mortar_savannah" ), e_mortar3.origin );
}

savannah_board_buffel_savimbi()
{
	run_scene( "savimbi_climb_on_again" );
	//level.savimbi say_dialog( "savi_come_my_friend_0" );//Come, my friend!
	level thread run_scene( "savimbi_ride_idle" );
}

//time limit for player to get to the buffel before the convoy is overun
savannah_board_buffel_fail()
{
	level endon( "savannah_player_boarded_buffel" );
	
	wait 20;
	
	missionfailedwrapper( &"ANGOLA_BUFFEL_FAIL" );
}

savannah_mortars()
{
	// sets up the endon for this mortar group
	level._explosion_stopNotify[ "mortar_savannah" ] = "stop_mortars";
	
	// starts the mortar loop for this mortar group
	level thread maps\_mortar::set_mortar_delays( "mortar_savannah", 3, 6 );	
	level thread maps\_mortar::set_mortar_damage( "mortar_savannah", 256, 1001, 1003 );	
	level thread maps\_mortar::mortar_loop( "mortar_savannah" );
	
	flag_wait( "savannah_done" );
	
	// notifies the mortar group with this string to stop
	level notify( "stop_mortars" );
}

savannah_finish()
{
	flag_wait( "savannah_done" );
	
	//turning off combat audio loop
	level clientnotify( "sgw" );
	level notify ( "turn_off_walla_loop" );
	
	level thread stop_savannah_grass();
	level thread maps\createart\angola_art::savannah_finish();
	level thread cleanup_hill_ai();
	level thread cleanup_wave_one_shooters();
	level thread animate_heli_grass( true );
	
	exploder( EXPLODER_HELI_END );
	
	level.savimbi = init_hero( "savimbi" );
	
	//make the player invincible for the ending
	level.player set_ignoreme( true );
	level.player EnableInvulnerability();
	
	buffel = spawn_vehicle_from_targetname( "savimbi_buffel_end" );
	buffel veh_magic_bullet_shield( true );
	//buffel.drivepath = true;
	
	buffel2 = spawn_vehicle_from_targetname( "victory_buffel" );
	buffel2 veh_magic_bullet_shield( true );
	buffel2.drivepath = true;	
	buffel2 thread load_buffel();
	buffel2 thread victory_buffel_fire();
	
	tank = spawn_vehicle_from_targetname( "victory_tank" );
	wait 0.05;
	tank notify( "death" );
	
	maps\_drones::drones_speed_modifier( "victory_mpla_drones", -0.4, -0.2 );//slow these guys down a bit to allow more shooting
	delay_thread( 7.5, ::drones_start, "victory_mpla_drones" );
	level thread run_scene_first_frame( "savannah_kill_shots_enemy" );
	
	end_scene( "savimbi_ride_idle" );
	wait 0.05;
	run_scene( "return_to_buffel" );
	level thread run_scene( "buffel_ride_end" );
	
	level thread refill_player_clip();
	level.player EnableWeapons();
	level.player ShowViewModel();	
	//level thread run_scene( "savannah_ending_helicopter_idle" );
	
	level.player NotSolid();
	buffel NotSolid();
	
	buffel2 thread go_path();
	level thread prep_victory_scene();
	buffel go_path();
	
	level notify( "fxanim_grass_heli_land_start" );
	level thread animate_heli_grass( false );//activate heli grass
	end_scene( "buffel_ride_end" );//Note: this scene is deleting both savimbi and player_body to fix bug with end_scene not unlinking properly
	wait 0.05;
	//run_scene( "savannah_ending_buffel", 0.5 );
	level thread run_scene( "savannah_ending", 1 );
	level thread run_scene( "savannah_kill_shots_enemy" );
	level thread run_scene( "savannah_kill_shots_friendly" );
	//level thread run_scene( "savannah_ending_cheer" );
	
	level.player DisableWeapons();
	level.player HideViewModel();
	
	flag_wait( "end_angola" );
	
	//go to angola_2
	nextmission();
}

prep_victory_scene()
{
	sp_friendly = GetEnt( "landing_soldier", "targetname" );	

	for( x = 1; x < 8; x++ )
	{
		landing_guy = sp_friendly spawn_ai( true );
		landing_guy.animname = "landing_soldier" + x;
	}
}

victory_buffel_fire()
{
	flag_wait( "victory_buffel_fire" );
	wait 0.05;
	self thread victory_buffel_target();
	self maps\_turret::fire_turret_for_time( 1, 1 );
	wait 1;
	self maps\_turret::fire_turret_for_time( 5, 1 );	
}

victory_buffel_target()
{
	temp_target_model = spawn_model( "tag_origin" );
	for( x = 3; x < 8; x++ )
	{
		temp_target = getstruct( "victory_target" + x, "script_noteworthy" );
		temp_target_model.origin = temp_target.origin + (0, -5, 0);
		self maps\_turret::set_turret_target( temp_target_model, undefined, 1 );	
		wait 1;		
	}
	temp_target_model Delete();
}

cleanup_hill_ai()
{
	ai_hill_array = GetEntArray( "hill_shooter_ai", "targetname" );
	foreach( ai_hill_guy in ai_hill_array )
	{
		ai_hill_guy delete();
	}
	
	ai_hill_axis_array = GetEntArray( "hill_axis_ai", "targetname" );
	foreach( ai_axis_guy in ai_hill_axis_array )
	{
		ai_axis_guy delete();
	}	
}

heli_custom_flyby()
{	
	wait (2.5);
	self playsound ( "veh_hudson_heli_flyby" );
}

//self is the player
#define HELI_COOLDOWN 25
heli_strafing_watch()
{	
	//level.player thread say_dialog( "hudson_incoming" );
	
	if( !flag("skipto_debug_heli_strafe") )
	{
		flag_wait_or_timeout( "savannah_start_hudson", 15 );
		level.player thread vo_play_savannah_hill();
	}
	
	veh_hudson_heli = spawn_vehicle_from_targetname( "hudson_helicopter" );
	veh_hudson_heli SetForceNoCull();
	veh_hudson_heli veh_magic_bullet_shield( true );
	level.veh_hudson_heli = veh_hudson_heli;
	nd_start = GetVehicleNode( "heli_strafe_path", "targetname" );
	nd_start2 = GetVehicleNode( "heli_strafe_path2", "targetname" );
	nd_start3 = GetVehicleNode( "heli_strafe_path3", "targetname" );
	nd_start_first_wave = GetVehicleNode( "heli_first_wave_path", "targetname" );
	nd_end = GetVehicleNode( "heli_return_path", "targetname" );
	nd_end2 = GetVehicleNode( "heli_return_path2", "targetname" );
	nd_end3 = GetVehicleNode( "heli_return_path3", "targetname" );
	nd_intro = GetVehicleNode( "heli_intro_path", "targetname" );
	
	level.hudson = init_hero( "hudson" );
	level.hudson LinkTo( veh_hudson_heli, "tag_driver" );
	level thread run_scene( "hudson_ride_idle" );
		
	veh_hudson_heli.drivepath = true;
	veh_hudson_heli thread go_path( nd_intro );
	veh_hudson_heli thread heli_intro_fire();
	
	//Eckert - Playing Heli flyby sound
	veh_hudson_heli thread heli_custom_flyby();
	
	veh_hudson_heli waittill( "shoot_up" );
	
	
	//level.player thread say_dialog( "hudson_arrive" );
	//level.player thread say_dialog( "mason_arrive", 2 );
	
	level thread mpla_shoot_hudson();
	
	//veh_hudson_heli waittill( "reached_end_node" );
	if( !flag("skipto_debug_heli_strafe") )
	{	
		wait HELI_COOLDOWN;
	}
	
	//level.player thread say_dialog( "hudson_ready" );
		
	while( !flag( "savannah_final_push" ) )
	{
		level.player vo_strafing_run_ready();
		self waittill_call_strafe_run( true );
		//level.player thread say_dialog( "mason_ready" );
		veh_hudson_heli thread heli_strafe_check_fail();
		switch( level.num_heli_runs )
		{
			case 0:
				self heli_strafe_run( veh_hudson_heli, nd_start_first_wave, nd_end2 );
				break;
				
			case 1:
				self heli_strafe_run( veh_hudson_heli, nd_start2, nd_end2 );
				break;
				
			case 2:
				self heli_strafe_run( veh_hudson_heli, nd_start, nd_end2 );
				break;
				
			default:
				self heli_strafe_run( veh_hudson_heli, nd_start, nd_end2 );
				break;
		}
		if( !flag( "savannah_final_push" ) )
		{
			switch( level.num_heli_runs )
			{
				case 1:
					wait 35;
					break;
					
				default:
					wait 35;
					break;
			}			
		}
	}
	
	flag_wait( "savannah_player_boarded_buffel" );
	
	wait 13.5;//Time allowed for final push side shooting
	
	self thread heli_final_call_fail();
	self waittill_call_strafe_run();
	
	veh_hudson_heli thread heli_final_strafe_fail_watch();
	self heli_strafe_run( veh_hudson_heli, nd_start3, nd_end );
	
	//Eckert - Sets sound snapshot to change tank shots while in air

	
	//kill off remaining living tanks
	a_veh_tanks = GetEntArray( "final_push_tank", "script_noteworthy" );
	foreach( veh_tank in a_veh_tanks )
	{
		if( IsAlive( veh_tank ) )
		{
			veh_tank notify( "death" );
		}
	}
	
	VEHICLE_DELETE( veh_hudson_heli );
	level thread maps\_drones::drones_delete_spawned();//Kill all remaining drones

}

heli_intro_fire()
{
	flag_wait( "heli_flyby_shoot" );
	
	heli_target_array = GetEntArray( "heli_fire_spots", "script_noteworthy" );
	
	for( x = 0; x < 4; x++ )
	{
		//TODO - set better target positions
		//target_point = getent( "heli_fire_" + (x+1), "targetname" );
		//self SetGunnerTargetVec( heli_target_array[x].origin, 0 );
		//self SetGunnerTargetVec( heli_target_array[x].origin, 1 );
		//self SetGunnerTargetVec( heli_target_array[x].origin, 2 );
		//self SetGunnerTargetVec( heli_target_array[x].origin, 3 );		
		self FireGunnerWeapon(2);
		//self FireGunnerWeapon(3);
		wait .3;
	}
}

mpla_shoot_hudson()
{
	ai = GetEntArray( "chopper_guy_ai", "targetname" );	
	for( i = 0; i < ai.size; i++ )
	{
		add_generic_ai_to_scene( ai[i], "mpla_shoot_heli_" + i );
		level thread run_scene( "mpla_shoot_heli_" + i );
	}
	flag_wait( "savannah_done" );
	
	//kill any remaining guys
	ai = GetEntArray( "chopper_guy_ai", "targetname" );
	for( i = 0; i < ai.size; i++ )
	{
		ai[i] Delete();
	}	
}

//while making the final push if the player doesn't switch to Hudson he fails
heli_final_call_fail()
{
	level endon( "strafe_run_called" );
	
	wait 6;
	
	missionfailedwrapper( &"ANGOLA_CALL_FAIL" );
}

//on the final strafe run if 3 tanks weren't destroyed the convoy is destroyed
heli_final_strafe_fail_watch()
{
	self waittill( "start_fade" );
	
	if( !flag( "savannah_final_push_success" ) )
	{
		missionfailedwrapper( &"ANGOLA_STRAFE_FAIL" );
	}
}

heli_strafe_check_fail()
{
	self waittill( "start_fade" );
	
	switch( level.num_heli_runs )
	{
		case 1:
			if( level.savannah_first_wave_kills >= 1 )
			{
				//kill remaining tanks	
				level thread kill_off_tanks( "wave_one_tank", "targetname" );
			}
			else
			{
				missionfailedwrapper( &"ANGOLA_STRAFE_FAIL" );
			}
			break;
			
		case 2:
			if( level.savannah_second_wave_kills >= 2 )
			{
				//kill remaining tanks	
				level thread kill_off_tanks( "wave_two_tank", "targetname" );
			}
			else
			{
				missionfailedwrapper( &"ANGOLA_STRAFE_FAIL" );
			}			
			break;
	}
}

kill_off_tanks( str_name, str_key )
{
	//kill off remaining living tanks
	a_veh_tanks = GetEntArray( str_name, str_key );
	foreach( veh_tank in a_veh_tanks )
	{
		if( IsAlive( veh_tank ) )
		{
			veh_tank notify( "death" );
		}
	}	
}

waittill_call_strafe_run( b_fail_watch = false )
{
	screen_message_create( &"ANGOLA_STRAFE_HINT" );
	
	if( b_fail_watch )
	{
		level thread watch_strafe_call_fail();
	}
		
	while( !self ActionSlotOneButtonPressed() )
	{
		wait 0.05;
	}
	
	level notify( "strafe_run_called" );
	level.player playsound ("evt_to_heli_transition_f");
		
	screen_message_delete();
}

watch_strafe_call_fail()
{
	level endon( "strafe_run_called" );
	
	wait 6;

	//fire at savimbi
	missionfailedwrapper( &"ANGOLA_CALL_FAIL" );
}

//performs one run of the helicopter
heli_strafe_run( veh_hudson_heli, nd_start, nd_end )
{
	//record where the player was and looking
	v_player_origin = self.origin;
	v_player_angles = self GetPlayerAngles();
	
	//for global tracking purposes
	flag_set( "player_in_helicopter" );

	level clientnotify ( "heli_int" );
	
	//show tutorial messages on first flight
	if( level.num_heli_runs == 0 )
	{
		level thread heli_strafe_run_controls();
	}
	
	//for challenge tracking
	level.num_heli_runs++;
	
	//drones play special blood fx while in the helicopter
	level.drones.death_func = ::drone_heliDeath;
			
	screen_fade_out( 0.25 );
	
	//decrease the FOV in the helicopter
	n_default_fov = GetDvarfloat( "cg_fov" );
	self SetClientDvar( "cg_fov", 60 );
	self SetClientDvar( "scr_damagefeedback", 0 );
	
	//DoF Change
	level heli_run_DOF_ON();
	
	level.player hide_hud();
	level thread return_prep();
	
	veh_hudson_heli SetDefaultPitch( 25 );
	veh_hudson_heli MakeVehicleUsable();
	veh_hudson_heli UseVehicle( self, 0 );

	self DisableUsability();
	self EnableInvulnerability();
	self StopShellShock();
	veh_hudson_heli.drivepath = false;
	veh_hudson_heli ClearTargetYaw();
	veh_hudson_heli thread go_path( nd_start );
	self thread heli_strafe_controls( veh_hudson_heli );
	screen_fade_in( 1.5 );
	
	//sets the draw distance of objectives
	self SetClientDvar( "cg_objectiveIndicatorFarFadeDist", OBJ_IND_FAR_DIST_FAR );
	
	level thread vo_strafing_run_start();
	
	veh_hudson_heli waittill( "start_fade" );
	level.player playsound ("evt_from_heli_transition_f");
	//sets the draw distance of objectives to a small distance to hide on ground
	self SetClientDvar( "cg_objectiveIndicatorFarFadeDist", OBJ_IND_FAR_DIST_CLOSE );
	
	screen_fade_out( 1 );
	veh_hudson_heli MakeVehicleUnusable();
	veh_hudson_heli UseBy( self );
	veh_hudson_heli.drivepath = true;
	veh_hudson_heli thread go_path( nd_end );
	veh_hudson_heli SetDefaultPitch( 10 );
	
	// delete target reticule
	if ( IsDefined( veh_hudson_heli.target_reticule ) )
	{
		veh_hudson_heli.target_reticule Delete();
	}
	
	//go back to the default drone death function
	level.drones.death_func = undefined;
	
	//spawn in the next wave of tanks for the next section and save
	if( flag( "savannah_final_push" ) )
	{
		trigger_use( "final_push_tanks" );
		autosave_by_name( "savannah_final_push" );
		
		//on the return play a specific scene from a spot
		s_player_pos = getstruct( "player_board_start", "targetname" );
		v_player_origin = s_player_pos.origin;
		v_player_angles = s_player_pos.angles;
		
		//TODO left this here, an attempt to just rotate the player angles to face the buffel, remove for final
		//v_temp = VectorToAngles( GetEnt( "savimbi_buffel", "targetname" ).origin - v_player_origin );
		//v_player_angles = ( 0, v_temp[1], 0 );
	}
	
	//prep wave two changes
	if( flag( "wave_one_done" ) )
	{
		delay_thread( 1, ::prep_wave_two );
	}	
	
	//place the player back where they called in the run
	anchor = Spawn( "script_origin", self.origin );
	self PlayerLinkToAbsolute( anchor );
	anchor MoveTo( v_player_origin, 0.05 );
	anchor waittill( "movedone" );
	self UnLink();
	self SetPlayerAngles( v_player_angles );
	anchor Delete();
	
	flag_clear( "player_in_helicopter" );
	level clientnotify ( "heli_done" );
		
	//if this was the final heli strafe place the player back on the side of the buffel
	if( flag( "savannah_final_push_success" ) )
	{
		end_scene( "savimbi_ride_idle" );
		end_scene( "player_ride_buffel" );

		flag_set( "savannah_done" );
	}
	else
	{
		create_after_strafe_fights( level.num_heli_runs );
		delay_thread( 2.5, ::vo_strafing_run_stop );
	}
	
	//FOV back to default
	self SetClientDvar( "cg_fov", n_default_fov );
	self SetClientDvar( "scr_damagefeedback", 1 );
	
	//DoF back to default
	heli_run_DOF_OFF();
	
	level.player show_hud();
	
	screen_fade_in( 2 );	
		
	self thread heli_lingering_invincibility();
}

vo_strafing_run_start()
{
	if(	!flag( "savannah_final_push" ) )
	{
		switch( level.num_heli_runs )
		{
			case 1:
				level.player say_dialog( "huds_beginning_strafing_r_0" );
				break;
				
			case 2:
				level.player say_dialog( "huds_making_another_run_0" );
				break;
				
			case 3:
				level.player say_dialog( "huds_okay_coming_round_a_0" );
				break;
		}		
	}
	else
	{		
		level.player say_dialog( "maso_bring_down_the_rain_0" );	
	}
}

vo_strafing_run_stop()
{
	if(	!flag( "savannah_final_push" ) )
	{		
		switch( level.num_heli_runs )
		{
			case 1:
				level.player say_dialog( "maso_nice_work_hudson_0" );
				break;
		}		
	}
}

vo_strafing_run_ready()
{
	switch( level.num_heli_runs )
	{
		case 1:
			level.player say_dialog( "maso_there_s_a_lot_of_arm_0" );
			break;
			
		case 2:
			level.player say_dialog( "maso_damn_i_think_you_m_0" );
			break;	
			
		case 3:
			level.player say_dialog( "huds_one_more_run_let_s_0" );
			break;			
	}	
}

heli_strafe_run_controls()
{
		wait 1;
	
		screen_message_create( &"ANGOLA_HELI_STRAFE", &"ANGOLA_HELI_AIM" );
			
		wait 4;
		
		screen_message_delete();
		
		wait 1;
		
		screen_message_create( &"ANGOLA_HELI_MG", &"ANGOLA_HELI_ROCKET" );
		
		wait 4;
		
		screen_message_delete();
}

heli_lingering_invincibility()
{
	wait 3;
	self EnableUsability();
	self DisableInvulnerability();
}

#define STRAFE_AIM_FREE_LOOK 1	
#define MPH_TO_INCHES_PER_SEC 17.6
#define STRAFE_DT 0.05
#define STRAFE_CLAMP_Y 750	
#define STRAFE_CLAMP_Z 0
#define STRAFE_MAX_VEL 40
heli_strafe_controls( veh_hudson_heli )
{
	veh_hudson_heli endon( "start_fade" );
	
	veh_hudson_heli thread heli_aim_update();
	veh_hudson_heli thread heli_weapon_controls( veh_hudson_heli );
	veh_hudson_heli thread heli_missile_controls( veh_hudson_heli );	
	
	offset = ( 0, 0, 0 );
	strafe_vel = ( 0, 0, 0 );
	max_strafe_vel = ( 0, STRAFE_MAX_VEL * MPH_TO_INCHES_PER_SEC, STRAFE_MAX_VEL * MPH_TO_INCHES_PER_SEC );
	
	while ( 1 )
	{
		stick = self GetNormalizedMovement();
		
		// Get strafe velocity
		desired_vel_y = ( Abs( offset[1] ) >= STRAFE_CLAMP_Y && ( offset[1] * stick[1] >= 0 ) ? 0 : stick[1] * max_strafe_vel[1] );
		desired_vel_z = ( Abs( offset[2] ) >= STRAFE_CLAMP_Z && ( offset[2] * stick[0] >= 0 ) ? 0 : stick[0] * max_strafe_vel[2] );
		
		strafe_vel_y = DiffTrack( desired_vel_y, strafe_vel[1], 1, STRAFE_DT );
		strafe_vel_z = DiffTrack( desired_vel_z, strafe_vel[2], 1, STRAFE_DT );
	
		strafe_vel = ( 0, strafe_vel_y, strafe_vel_z );

		if ( !STRAFE_AIM_FREE_LOOK )
		{
			a = AngleClamp180( self.angles[1] );
			path_a = veh_hudson_heli.pathlookpos - veh_hudson_heli.pathpos;
			path_a = vectoangles( path_a );
			
			delta = AngleClamp180( path_a - a );
			
			a = ( 0, delta, 0 );
			
			// Get Axes
			forward = AnglesToForward( a );
			right = AnglesToRight( a );
		
			v = forward * strafe_vel[2] - right * strafe_vel[1];
			//dir = AnglesToForward( ( 0, path_a + 90, 0 ) );
			//d = VectorDot( v, dir );
			
			//speed = linear_map( d, -max_strafe_vel[1], max_strafe_vel[1], 0, 25 );
			//PrintLn( speed );
			
			//v = v - dir * d;
			
			//veh_hudson_heli SetSpeed( speed );
		}
		else
		{
			v = strafe_vel;
		}
		
		// Integrate velocity	
		offset += v * STRAFE_DT;
	
		// Set offset
		veh_hudson_heli PathFixedOffset( offset );			
		
		wait( STRAFE_DT );
	}
}

heli_weapon_controls( veh_hudson_heli )
{
	veh_hudson_heli endon( "start_fade" );	
	
	fire_time = WeaponFireTime( self SeatGetWeapon( 1 ) );	
	
	while ( 1 ) 
	{
		if ( level.player AttackButtonPressed() )
		{
			self FireGunnerWeapon(0);
			self FireGunnerWeapon(1);		
			wait ( fire_time );
		}
		else
		{
			wait ( 0.05 );
		}		
	}
}

heli_missile_controls( veh_hudson_heli )
{
	veh_hudson_heli endon( "start_fade" );	
	
	fire_time = WeaponFireTime( self SeatGetWeapon( 3 ) );	
	
	while ( 1 ) 
	{
		if ( level.player ThrowButtonPressed() )
		{
			//self FireGunnerWeapon(2);
			self FireGunnerWeapon(3);		
			wait ( fire_time );
		}
		else
		{
			wait ( 0.05 );
		}		
	}
}

#define STRAFE_AIM_CLAMP_YAW 20	
#define STRAFE_AIM_CLAMP_PITCH 10
#define STRAFE_AIM_CLAMP_YAW_2 180
#define STRAFE_AIM_CLAMP_PITCH_2 25	
#define STRAFE_AIM_MAX_VEL 60
heli_aim_update()
{
	self endon( "start_fade" );

	// initial offset
	offset = ( 0, 0, 0 );
	strafe_aim_vel = ( 0, 0, 0 );	
	max_strafe_aim_vel = ( STRAFE_AIM_MAX_VEL, STRAFE_AIM_MAX_VEL, 0 );	

	if ( !STRAFE_AIM_FREE_LOOK )
	{
		wait ( 0.05 );
	
		// Get the start angles
		start_angles = ( self.angles[0], self.angles[1], 0 );
	}
	else
	{
		if ( !IsDefined( self.target_reticule ) )
		{
			self.target_reticule = Spawn( "script_model", ( 0, 0, 0 ) );
			self.target_reticule SetModel( "tag_origin" );
			self.target_reticule.angles = ( -90, 0, 90 );
			PlayFXOnTag( level._effect["heli_target_reticule"], self.target_reticule, "tag_origin" );
		}
	}
	
	// update aim
	while ( 1 )
	{
		stick = level.player GetNormalizedCameraMovement();
		
		clamp_yaw = ( STRAFE_AIM_FREE_LOOK ? STRAFE_AIM_CLAMP_YAW : STRAFE_AIM_CLAMP_YAW_2 );
		clamp_pitch = ( STRAFE_AIM_FREE_LOOK ? STRAFE_AIM_CLAMP_PITCH: STRAFE_AIM_CLAMP_PITCH_2 );		
			
		if ( STRAFE_AIM_FREE_LOOK )
		{
			start_angles = ( self.angles[0], self.angles[1], 0 );			
		}
		
		// Get strafe velocity
		desired_aim_vel_yaw = ( Abs( offset[1] ) >= clamp_yaw && ( offset[1] * -stick[1] >= 0 ) ? 0 : -stick[1] * max_strafe_aim_vel[1] );
		desired_aim_vel_pitch = ( Abs( offset[0] ) >= clamp_pitch && ( offset[0] * -stick[0] >= 0 ) ? 0 : -stick[0] * max_strafe_aim_vel[0] );
		
		strafe_aim_vel_yaw = DiffTrack( desired_aim_vel_yaw, strafe_aim_vel[1], 3, STRAFE_DT );
		strafe_aim_vel_pitch = DiffTrack( desired_aim_vel_pitch, strafe_aim_vel[0], 3, STRAFE_DT );
		strafe_aim_vel = ( strafe_aim_vel_pitch, strafe_aim_vel_yaw, 0 );
		
		// Integrate angular velocity	
		offset += strafe_aim_vel * STRAFE_DT;
		
		// Clamp
		p = clamp( offset[0], -clamp_pitch, clamp_pitch );
		y = clamp( offset[1], -clamp_yaw, clamp_yaw );
		
		offset = ( p, y, 0 );
		
		if ( !STRAFE_AIM_FREE_LOOK )
		{
			angles = self.angles;
			new_angles = start_angles + offset;
			self SetPhysAngles( ( AngleClamp180( new_angles[0] ), AngleClamp180( new_angles[1] ), angles[2] ) );
		}
		else
		{		
			// Make a forward vector
			dir = AnglesToForward( start_angles + offset );
			
			// Get an aim point off in the distance
			start_point = level.player GetEye();
			target_point = level.player.origin + dir * 15000;
			
			// Trace to the actual hit point
			trace = BulletTrace( start_point, target_point, false, self, false );
			if ( trace["fraction"] != 1 )
			{
				target_point = trace["position"];
			}
			
			self SetGunnerTargetVec( target_point, 3 );
			self SetGunnerTargetVec( target_point, 0 );
			self SetGunnerTargetVec( target_point, 1 );
			self SetGunnerTargetVec( target_point, 2 );			
			
			// Draw the ui element
			if ( IsDefined( self.target_reticule ) )  
			{
				self.target_reticule.origin = target_point;
			}
			
			// Test line
			//Line( start_point, target_point, ( 1, 0, 0 ), true, 1 );
		}
			
		wait( STRAFE_DT );
	}
}

//self = player
tank_fail_watch()
{
	level endon( "savannah_final_push" );
	
	//how many tanks can reach the end of their path before failing the player
	level.savannah_tank_safety = 2;
	
	while( level.savannah_tank_safety )
	{
		wait 1;	
	}
		
	missionfailedwrapper( &"ANGOLA_TANK_FAIL" );
}

//called on a tank, starting point for all tank logic
tank_think()
{
	self.overrideVehicleDamage = ::tank_damage_callback;
	///self thread tank_finish_path();
	self thread tank_fire();
	self thread tank_objective_display();
	
	self waittill( "death" );
	
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "final_push_tank" )
	{
		if( level.savannah_final_push_kills < TANK_KILLS_TO_FINISH )
		{
			level.savannah_final_push_kills++;
			set_objective( level.OBJ_DESTROY_FINAL_WAVE, undefined, undefined, level.savannah_final_push_kills );
		}
	}
	else if( IsDefined( self.targetname ) && self.targetname == "wave_one_tank" )
	{
		if( level.savannah_first_wave_kills < TANK_KILLS_FIRST_WAVE )
		{
			level.savannah_first_wave_kills++;
			set_objective( level.OBJ_DESTROY_FIRST_WAVE, undefined, undefined, level.savannah_first_wave_kills );
			if( level.savannah_first_wave_kills == TANK_KILLS_FIRST_WAVE )
			{
				set_objective( level.OBJ_DESTROY_FIRST_WAVE, undefined, "done" );	
			}
		}			
	}
	else if( IsDefined( self.targetname ) && self.targetname == "wave_two_tank" )
	{
		if( level.savannah_second_wave_kills < TANK_KILLS_SECOND_WAVE )
		{
			level.savannah_second_wave_kills++;
			set_objective( level.OBJ_DESTROY_SECOND_WAVE, undefined, undefined, level.savannah_second_wave_kills );
			if( level.savannah_second_wave_kills == TANK_KILLS_SECOND_WAVE )
			{
				set_objective( level.OBJ_DESTROY_SECOND_WAVE, undefined, "done" );	
			}			
		}			
	}	
	/*else
	{
		if( level.savannah_tank_kills < TANK_KILLS_TO_PROGRESS )
		{
			level.savannah_tank_kills++;
			set_objective( level.OBJ_DESTROY_TANKS, undefined, undefined, level.savannah_tank_kills );
		}
	}*/
	
	PlayFX( getfx( "fx_ango_smoke_distant_lrg" ), self.origin );
}

//called on a tank, handles all displaying of objective logic on tanks
#define SPLINE_OFFSET 750
tank_objective_display()
{
	n_x_objective = GetVehicleNode( "heli_strafe_path", "targetname" ).origin[0] + SPLINE_OFFSET;
	
	//run different logic on the final run of tanks
	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "final_push_tank" )
	{
		flag_waitopen( "player_in_helicopter" );
		flag_wait( "player_in_helicopter" );
		wait 1;
		
		set_objective( level.OBJ_DESTROY_FINAL_WAVE, self, &"SP_OBJECTIVES_DESTROY", -1 );
		self waittill( "death" );
		set_objective( level.OBJ_DESTROY_FINAL_WAVE, self, "remove" );
	}
	else if( IsDefined( self.targetname ) && self.targetname == "wave_one_tank" )
	{		
		//don't display the destroy objective on the tank until it's in the playable space
		flag_wait( "player_in_helicopter" );
		wait 1;
		
		set_objective( level.OBJ_DESTROY_FIRST_WAVE, self, &"SP_OBJECTIVES_DESTROY", -1 );
		self waittill( "death" );
		set_objective( level.OBJ_DESTROY_FIRST_WAVE, self, "remove" );			
	}
	else if( IsDefined( self.targetname ) && self.targetname == "wave_two_tank" )
	{
		//don't display the destroy objective on the tank until it's in the playable space
		flag_wait( "player_in_helicopter" );
		wait 1;
		
		set_objective( level.OBJ_DESTROY_SECOND_WAVE, self, &"SP_OBJECTIVES_DESTROY", -1 );
		self waittill( "death" );
		set_objective( level.OBJ_DESTROY_SECOND_WAVE, self, "remove" );			
	}	
	/*else
	{
		//don't display the destroy objective on the tank until it's in the playable space
		while( self.origin[0] > n_x_objective )
		{
			wait 0.05;	
		}
		
		set_objective( level.OBJ_DESTROY_TANKS, self, &"SP_OBJECTIVES_DESTROY", -1 );
		self waittill( "death" );
		set_objective( level.OBJ_DESTROY_TANKS, self, "remove" );
	}*/
}

tank_fire()
{
	switch( level.num_heli_runs )
	{
		case 0:
			a_target_pos = GetEntArray( "savannah_tank_target", "targetname" );
			break;
			
		default:
			a_target_pos = GetEntArray( "savannah_tank_target2", "targetname" );
			break;
	}	

	e_target = spawn( "script_origin" , a_target_pos[0].origin );
		
	while( IsAlive( self ) && !flag( "savannah_final_push_success" ) )
	{
		wait RandomFloatRange( 1.5, 3.0 );
		if( !flag( "pause_fire" ) )
		{
			if( IsAlive( self ) && !flag( "pause_fire" ) )
			{
				self SetTurretTargetEnt( e_target );
			}
			e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, RandomFloatRange( 2.0, 4.0 ), 1.0, 1.0 );
			e_target waittill( "movedone" );
			if( IsAlive( self ) && !flag( "pause_fire" ) )
			{
				self FireWeapon();
			}
		}
	}

	e_target Delete();
}

tank_fire_target( e_target )
{
	self notify( "pause_fire" );
	self SetTurretTargetEnt( e_target );
	wait 1.5;
	self FireWeapon();
	flag_clear( "pause_fire" );
	level thread savannah_destroy_eland();
}

tank_finish_path()
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	
	level.savannah_tank_safety--;
	
	self notify( "death" );
}

tank_damage_callback(  eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if ( IsDefined( sWeapon ) )
	{
		if ( sWeapon == "alouette_missile_turret" && level.num_heli_runs > 0 )   // one shot kill from player missile
		{
			iDamage = 9999;
		}
		else
		{
			iDamage = 1;
		}	
	}
	
	return iDamage;
}


#using_animtree( "fakeshooters" ); 
drone_heliDeath()
{
	self endon( "delete" ); 
	self endon( "drone_death" ); 
	
	// SRS testing special explosive death anims
	explosivedeath = false; 
	explosion_ori = ( 0, 0, 0 ); 
	
	bone[0] = "J_Knee_LE"; 
	bone[1] = "J_Ankle_LE"; 
	bone[2] = "J_Clavicle_LE"; 
	bone[3] = "J_Shoulder_LE"; 
	bone[4] = "J_Elbow_LE"; 
		
	while( IsDefined( self ) )
	{
		self SetCanDamage( true ); 
		self waittill( "damage", amount, attacker, direction_vec, damage_ori, type ); 
		
		// SRS testing special explosive death anims
		if( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_EXPLOSIVE" || 
			type == "MOD_EXPLOSIVE_SPLASH" ||  type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" )
		{
			self.damageweapon = "none"; 
			explosivedeath = true; 
			explosion_ori = damage_ori; 
		}
		
		self death_notify_wrapper( attacker, type );
		
		if( self.team == "axis" && ( IsPlayer( attacker ) || attacker == level.playervehicle )  )
		{
			level notify( "player killed drone" ); 
		
			n_impacts = ( 1 + RandomInt( 2 ) ); 
			for( i = 0; i < n_impacts; i++ )
			{
				PlayFXOnTag( getfx( "drone_impact" ), self, bone[RandomInt( bone.size )] );
				wait( 0.05 ); 
			}
			
			attacker thread maps\_damagefeedback::updateDamageFeedback();
		}
	
		if( !IsDefined( self ) )
		{
			return; 
		}
		
		self notify( "stop_shooting" ); 
	
		self.dontDelete = true; 
		
		self useAnimTree( #animtree ); 
		
		// SRS Did the guy take damage from an explosive?
		if( explosivedeath )
		{
			// determine direction to play animation
			direction = drone_get_explosion_death_dir( self.origin, self.angles, explosion_ori, 50 ); 
			
			self thread drone_mortarDeath( direction ); 
			return; 
		}
		// Bloodlust - if not explosive death, then check if drone is running
		else if( IsDefined( self.running ) )
		{
			deaths[0] = %death_run_stumble; 
			deaths[1] = %death_run_onfront; 
			deaths[2] = %death_run_onleft; 
			deaths[3] = %death_run_forward_crumple; 
		}
		else
		{
			deaths[0] = %death_stand_dropinplace; 
		}
		
		self thread drone_doDeath( deaths[RandomInt( deaths.size )] ); 
		return; 
	}
}

eland_think( b_reach )
{
	level endon( "stop_fire" );
	
	if( self.vehicletype != "tank_eland" )
	{
		return;
	}
	
	if( IS_TRUE( b_reach ) )
	{
		self waittill_any( "reached_end_node" );
		self setspeedimmediate( 0 );		
	}
	
	//a_target_pos = getstructarray( "mortar_savannah", "targetname" );
	if( self.targetname == "eland_hero" || self.targetname == "riverbed_convoy_eland" )
	{
		a_target_pos = getstructarray( "left_side", "script_noteworthy" );
	}
	else
	{
		a_target_pos = getstructarray( "right_side", "script_noteworthy" );
	}

	e_target = spawn( "script_origin" , a_target_pos[0].origin );
	self SetTurretTargetEnt( e_target );
		
	while( IsAlive( self ) && !flag( "savannah_final_push_success" ) )
	{
		wait RandomFloatRange( 3.0, 6.0 );
		e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, RandomFloatRange( 2.0, 4.0 ), 1.0, 1.0 );
		e_target waittill( "movedone" );
		if( IsAlive( self ) )
		{
			//level thread run_scene( "eland_fire" );
			self FireWeapon();
			PlayRumbleOnPosition( "grenade_rumble", self.origin );
		}
	}

	e_target Delete();
}

return_prep()
{
	switch( level.num_heli_runs )
	{
		case 1:
			level thread kill_hill_rpgs();
			break;
			
		case 2:
			level thread kill_wave_one_rpgs();
			break;
	}
}


//return 2 hero shot
hero_eland_scene()
{	
	level thread run_scene( "eland_hero_fire" );
}

eland_hero_shoot()
{
	vh_hero_eland = getent( "eland_hero", "targetname" );
	vh_hero_eland FireWeapon();
	PlayRumbleOnPosition( "grenade_rumble", vh_hero_eland.origin );
}


//return 3 scene
savannah_buffel_tip()
{
	///vh_buffel_tip = spawn_vehicle_from_targetname( "buffel_flip" );
	///vh_buffel_tip veh_magic_bullet_shield( true );
	
	level thread run_scene_first_frame( "buffel_tip_guys" );
	
	///vh_buffel_tip thread go_path();
	///fire_pos = getent( "heli_fire_2", "targetname" );
	
	///vh_buffel_tip waittill( "reached_end_node" );
	
	self  maps\_vehicle::getoffpath();
	wait 0.05;
	PlayFx( getfx( "mortar_savannah" ), self.origin );
	foreach( rider in self.riders )
	{
		rider Delete();
	}
	self.fire_turret = false;
	level thread run_scene( "buffel_tip_guys" );
	level run_scene( "buffel_tip" );
	level run_scene( "buffel_tip_idle" );
}

buffel_gunner_think( b_reach )
{
	self.fire_turret = true;
	
	if( !IsSubStr( self.vehicletype, "buffel" ) )
	{
		return;
	}
	
	if( IS_TRUE( b_reach ) )
	{
		self waittill_any( "reached_end_node" );
		self setspeedimmediate( 0 );		
	}
	
	// Specify which turret index we want to fire, NOTE: seat index and gunner index are NOT necessarily the same!
	n_vehicle_gun_index = 1;	
	// set firing parameters
	n_fire_min = 3;  // minimum time a turret will fire per burst
	n_fire_max = 6;  // maximum time a turret will fire per burst
	n_wait_min = .5;  // minimum wait time after burst before firing again
	n_wait_max = 1;  // maximum wait time after burst before firing again
	n_fire_time = 6;  // Fire time, -1 = infinate
	
	// Enale the vehicle turret to start firing
	self maps\_turret::enable_turret( n_vehicle_gun_index ); 	
	//self maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_vehicle_gun_index );
	
	if( self.targetname == "savimbi_buffel" )
	{
		a_target_pos = getstructarray( "mortar_savannah", "targetname" );	
	}
	else if( self.targetname == "riverbed_convoy_buffel" || self.targetname == "convoy_destroy_2" )
	{
		a_target_pos = getstructarray( "left_side", "script_noteworthy" );
	}
	else
	{
		a_target_pos = getstructarray( "right_side", "script_noteworthy" );
	}

	e_target = spawn( "script_origin" , a_target_pos[0].origin );
	self maps\_turret::set_turret_target( e_target, undefined, n_vehicle_gun_index );
	wait 0.05;
	self maps\_turret::fire_turret_for_time( n_fire_time, n_vehicle_gun_index );
	self thread fire_buffel_think();
	while( IsAlive( self ) && !flag( "savannah_done" ) && self.fire_turret )
	{
		e_target MoveTo( a_target_pos[ RandomInt( a_target_pos.size ) ].origin, RandomFloatRange( 2.0, 4.0 ), 1.0, 1.0 );
		n_time = RandomFloatRange( 3.0, 6.0 );
		wait n_time;
	}

	e_target Delete();
}

fire_buffel_think()
{
	self endon( "death" );
	
	while( IsAlive( self ) && !flag( "savannah_done" ) && self.fire_turret )
	{
		n_time = RandomFloatRange( 9.0, 15.0 );

		if( IsAlive( self ) )
		{
			self maps\_turret::fire_turret_for_time( n_time, 1 );
		}
		wait RandomFloatRange( 1.0, 2.0 );
	}
}

fake_battle_loop()
{
	battle_walla_loop = spawn ( "script_origin" , (5783, 1929, 219));
	battle_walla_loop playloopsound ( "amb_sav_battle_line" );
	
	level waittill ( "turn_off_walla_loop");
	
	battle_walla_loop stoploopsound(4);	
	wait(10);
	battle_walla_loop delete();
	
}
start_heli_fire( guy )
{
	hudson_heli = getent( "hudson_helicopter", "targetname" );
	guy shoot_at_target( hudson_heli, undefined, undefined, -1 );
}

stop_heli_fire( guy )
{
	guy stop_shoot_at_target();
}

init_hill_shooter()
{
	//self SetGoalEntity( level.player );	
	self.a.disableLongDeath = true;
	self set_goalradius( 50 );
	if( self.targetname == "hill_shooter" || self.targetname == "brim_shooter" )
	{
		self SetThreatBiasGroup( "axis_shooters" );
	}
	else
	{
		self SetThreatBiasGroup( "machete_guy" );
	}
	
}

cleanup_riverbed_scenes()
{
	a_soldiers = GetEntArray( "intro_mpla_shooter", "script_noteworthy" );
	foreach( soldier in a_soldiers )
	{
		soldier bloody_death();
	}
	
	a_soldiers = GetEntArray( "intro_soldier", "script_noteworthy" );
	foreach( soldier in a_soldiers )
	{
		soldier bloody_death();
	}
	
	delete_scene_all( "level_intro_player", true );
	delete_scene_all( "level_intro_fake_player", true );
	delete_scene( "level_intro_savimbi_buffel", true );
	delete_scene( "level_intro_savimbi", true );
	delete_scene( "savimbi_ride_rally", true );
	//delete_scene_all( "riverbed_ambience_vehicles", true );
	delete_scene_all( "lockbreaker", true );
	delete_scene( "lockbreaker_interact", true );
	delete_scene( "level_intro_soldier_1", true );
	delete_scene( "level_intro_soldier_2", true );
	delete_scene( "level_intro_soldier_3", true );
	delete_scene( "level_intro_soldier_4", true );
	delete_scene( "level_intro_soldier_5", true );
	delete_scene( "level_intro_soldier_6", true );
	delete_scene( "level_intro_soldier_7", true );
	delete_scene_all( "riverbed_ambience_1", true );
	delete_scene_all( "riverbed_ambience_2", true );
	delete_scene_all( "riverbed_ambience_3", true );	
	delete_scene_all( "riverbed_ambience_4", true );
	delete_scene_all( "riverbed_ambience_5", true );	
	delete_scene_all( "riverbed_ambience_6", true );	
	delete_scene_all( "riverbed_ambience_7", true );	
	delete_scene_all( "riverbed_ambience_8", true );	
	delete_scene_all( "riverbed_corpses_driver", true );
	delete_scene_all( "riverbed_corpses_1", true );
	delete_scene_all( "riverbed_corpses_2", true );
	delete_scene_all( "riverbed_corpses_3", true );
	delete_scene_all( "riverbed_corpses_4", true );
	delete_scene_all( "riverbed_corpses_5", true );
	delete_scene_all( "riverbed_corpses_6", true );
	delete_scene_all( "riverbed_corpses_7", true );
	delete_scene_all( "riverbed_corpses_8", true );
	
	//Wait a bit so player has time to see the Bloody Deaths play out before deleting the spawners and all the related AI
	wait 5;
	cleanup_riverbed();
}

cleanup_riverbed()
{
	/*
	//Models
	m_driver = GetEnt( "riverbed_corpses_driver", "targetname" );
	m_driver Delete();*/
	
	//mortar structs
	array_delete( getstructarray( "mortar_intro", "targetname" ), 1);
	array_delete( getstructarray( "mortar_riverbed", "targetname" ), 1);
	
	//spawners
	array_delete( GetEntArray( "intro_soldier", "targetname" ) );
	
	delete_array( "burning_man", "targetname" );
	delete_array( "riverbed_ambience", "targetname" );
	
	array_delete( getentarray( "intro_mpla_shooter", "script_noteworthy" ) );
	
	delete_array( "intro_unita_shooter", "targetname" );
	delete_array( "intro_mpla_shooter", "targetname" );
}

cleanup_post_heli_fight()
{
	scene_wait( "post_heli_run_fight" );
	wait 1;//make sure we are done
	delete_scene( "post_heli_run_fight", true );
	wait 1;
	
	enemy = getent( "eland_destroy_enemy", "targetname" );
	enemy Delete();
	
	friendly = getent( "eland_destroy_friendly", "targetname" );
	friendly Delete();
}

setup_threat_bias_group()
{
	CreateThreatBiasGroup( "player" );
	CreateThreatBiasGroup( "player_team" );
	CreateThreatBiasGroup( "axis_shooters" );
	CreateThreatBiasGroup( "enemy_dancer" );
	CreateThreatBiasGroup( "friendly_dancer" );
	CreateThreatBiasGroup( "machete_guy" );
	
	//disable_auto_adjust_threatbias();
		
	level.player SetThreatBiasGroup( "player" );
	level.savimbi SetThreatBiasGroup( "player_team" );
	
	//TODO get this working again
	//SetThreatBias( "player", "axis_shooters", 1000 );
	SetIgnoreMeGroup( "friendly_dancer", "axis_shooters" );
	SetIgnoreMeGroup( "friendly_dancer", "machete_guy" );
}

setup_wave_one_launchers()
{
	sp_left = GetEnt( "hill_launcher1", "targetname" );
	sp_right = GetEnt( "hill_launcher2", "targetname" );
	
	level waittill( "savannah_start_hudson" );
	wait 2;
	
	for( x = 0; x < 2; x++ )
	{
		tmp_ent = simple_spawn_single( sp_left, ::init_hill_launcher, 1, undefined, undefined, undefined, undefined, true );
	}
	
	for( x = 0; x < 2; x++ )
	{
		tmp_ent = simple_spawn_single( sp_right, ::init_hill_launcher, 1, undefined, undefined, undefined, undefined, true );
	}	
}

setup_wave_two_launchers()
{
	wait 3;
	
	sp_left = GetEnt( "hill_launcher3", "targetname" );
	sp_right = GetEnt( "hill_launcher4", "targetname" );
	
	for( x = 0; x < 3; x++ )
	{
		tmp_ent = simple_spawn_single( sp_left, ::init_hill_launcher, 2, undefined, undefined, undefined, undefined, true );
	}
	
	for( x = 0; x < 3; x++ )
	{
		tmp_ent = simple_spawn_single( sp_right, ::init_hill_launcher, 2, undefined, undefined, undefined, undefined, true );
	}	
}

init_hill_launcher( n_wave )
{
	self thread magic_bullet_shield();
	self.dropweapon = false;
	self set_goalradius( 50 );
	self.health = self.health + 25;
	self.a.disableLongDeath = true;
	
	if( self.targetname == "hill_shooter" || self.targetname == "brim_shooter" || IsSubStr( self.script_noteworthy, "hill_launcher" ) )
	{
		self SetThreatBiasGroup( "axis_shooters" );	
	}
	else
	{
		self SetThreatBiasGroup( "machete_guy" );		
	}
	
	wait 5;
	if( n_wave == 1 )
	{
		set_objective( level.OBJ_KILL_RPG_ONE, self, &"SP_OBJECTIVES_TARGET", -1 );
	}
	else
	{
		set_objective( level.OBJ_KILL_RPG_TWO, self, &"SP_OBJECTIVES_TARGET", -1 );	
	}
	
	self thread stop_magic_bullet_shield();
	self waittill( "death" );
	
	if( n_wave == 1 )
	{
		level.savannah_first_wave_rpg_kills++;
		set_objective( level.OBJ_KILL_RPG_ONE, self, "remove" );	
		if( level.savannah_first_wave_rpg_kills == RPG_KILLS_FIRST_WAVE )
		{
			set_objective( level.OBJ_KILL_RPG_ONE, self, "done" );
		}
	}
	else
	{
		level.savannah_second_wave_rpg_kills++;
		set_objective( level.OBJ_KILL_RPG_TWO, self, "remove" );	
		if( level.savannah_second_wave_rpg_kills == RPG_KILLS_SECOND_WAVE )
		{
			set_objective( level.OBJ_KILL_RPG_TWO, self, "done" );
		}		
	}
}

kill_hill_rpgs()
{
	ai_rpgs = GetEntArray( "hill_launcher1_ai", "targetname" );
	foreach( rpg_guy in ai_rpgs )
	{
		rpg_guy Delete();
	}
	
	ai_rpgs = GetEntArray( "hill_launcher2_ai", "targetname" );
	foreach( rpg_guy in ai_rpgs )
	{
		rpg_guy Delete();
	}	
}

kill_wave_one_rpgs()
{
	ai_rpgs = GetEntArray( "hill_launcher3_ai", "targetname" );
	foreach( rpg_guy in ai_rpgs )
	{
		rpg_guy Delete();
	}
	
	ai_rpgs = GetEntArray( "hill_launcher4_ai", "targetname" );
	foreach( rpg_guy in ai_rpgs )
	{
		rpg_guy Delete();
	}	
}

wave_one_tank_fire()
{
	wait .5;
	vh_tank = GetEnt( "wave_one_fire", "script_noteworthy" );
	vh_target = GetEnt( "eland_hero", "targetname" );
	
	wait 20;
	
	vh_tank thread tank_fire_target( vh_target );
	wait 5;
	level thread savannah_destroy_buffel2();
}

cleanup_hill()
{
	//mortar structs
	s_mortars = GetEntArray( "mortar_savannah_start", "targetname" );
	foreach( mortar in s_mortars )
	{
		mortar Delete();
	}

	sp_spawner = GetEntArray( "brim_shooter", "targetname" );
	foreach( spawner in sp_spawner )
	{
		spawner Delete();
	}	
	
	sp_spawner = GetEntArray( "savannah_start_unita", "targetname" );
	foreach( spawner in sp_spawner )
	{
		spawner Delete();
	}	
	
	sp_spawner = GetEntArray( "savannah_start_mpla", "targetname" );
	foreach( spawner in sp_spawner )
	{
		spawner Delete();
	}
	
	sp_spawner = GetEntArray( "brim_ally_initial", "targetname" );
	foreach( spawner in sp_spawner )
	{
		spawner Delete();
	}	
}

cleanup_wave_one()
{
	//
	launcher1 = GetEnt( "hill_launcher1", "targetname" );
	launcher1 Delete();
	
	launcher2 = GetEnt( "hill_launcher2", "targetname" );
	launcher2 Delete();
	
	wait 7;//Give time for initial tanks to finish their death/cleanup no matter where they were in the sequence
	
	//cleanup tank fire structs
	a_target_pos = GetEntArray( "savannah_tank_target", "targetname" );
	foreach( target in a_target_pos )
	{
		target Delete();
	}
}

cleanup_wave_one_shooters()
{
	spawn_manager_kill( "sm_wave_one_shooters" );
	ai_shooter_array = GetEntArray( "wave_one_shooter_ai", "targetname" );
	foreach( ai_shooter in ai_shooter_array )
	{
		ai_shooter delete();
	}	
}

prep_wave_two()
{
	flag_clear( "wave_one_done" );
	//move melee
	
	//push back drones
	axis_drone_array = getstructarray( "drone_axis_wave_one_cut", "script_noteworthy" );
	foreach( new_end in axis_drone_array )
	{	
		new_end.dr_death_timer = 0;
		new_end.target = undefined;
		new_end.a_targeted = undefined;
	}
	
	//wave 2 go
	wait 1;
	level thread go_wave_two();	
	
	//cleanup wave one	
	level thread cleanup_wave_one();
}

go_wave_two()
{
	//start convoy moving again
	flag_set( "wave_one" );	
	
	//setup wave one fights
	level thread savannah_wave_one_fights();
	
	spawn_manager_kill( "sm_hill_shooters" );
	trigger_use( "sm_wave_one_shooters" );
	
	savimbi_goal_pos = getnode( "savimbi_wave_one_pos", "targetname" );
	level.savimbi SetGoalPos( savimbi_goal_pos.origin );		
		
	//trigger second wave tanks
	trigger_use( "second_wave" );
	
	level thread setup_wave_two_launchers();
	
	vh_buffel = GetEnt( "riverbed_convoy_buffel", "targetname" );
	vh_buffel waittill( "buffel_tip" );
	vh_buffel thread savannah_buffel_tip();
	
	wait 2;
	
	level thread savannah_destroy_buffel1();
}