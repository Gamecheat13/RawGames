#include common_scripts\utility;
#include maps\_utility;
#include maps\pakistan_util;
#include maps\_turret;
#include maps\_vehicle;
#include maps\_objectives;
#include maps\_juggernaut;
#include maps\_scene;
#include maps\_dialog;
#include maps\_music;

#define PATH_ENEMY_FIGHT_DISTANCE 192

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_claw()
{
	/#
		IPrintLn( "CLAW" );
	#/
	
	level.harper = init_hero( "harper" );
	level.harper set_ignoreme( true );
	level.harper set_ignoreall( true );	
	
	maps\pakistan_anthem::setup_doors();
	
	set_objective( level.OBJ_ID_MENENDEZ );
	set_objective( level.OBJ_ID_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_RECORD_MENENDEZ );
	set_objective( level.OBJ_RECORD_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_SURVEIL_MENENDEZ );
	set_objective( level.OBJ_SURVEIL_MENENDEZ, undefined, "done" );
	set_objective( level.OBJ_CLEAR_RAILYARD );
	set_objective( level.OBJ_ESCAPE );
	
	claw1_spawn();
	
	skipto_teleport( "skipto_claw", array( level.harper ) );
}

main()
{
	//level.player hide_hud();
	trigger_off( "soct_mount_trigger", "targetname" );
	
	claw_setup();
	claw_startup();
	claw_soct_event();
	claw_cleanup();
}


claw_setup()
{
	level.claw1_ai_damage_total = 0;
	level.claw2_ai_damage_total = 0;
	level.claw1_damage_total = 0;
	level.claw2_damage_total = 0;
	level.str_claw1_target_pos = "ground_claw_goal_pos1";
	level.str_claw2_target_pos = "roof_claw_goal_pos1";
	level.n_claw_drones_dead = 0;
	level.n_juggernauts_dead = 0;
}

claw1_spawn()
{
	level.claw1 = spawn_vehicle_from_targetname( "claw1" );
	run_scene_first_frame( "claw_start_breach" );
} 

claw_pip_on( ai_pov_claw )
{
	e_extra_cam = maps\_glasses::get_extracam();
	e_extra_cam.origin = ai_pov_claw GetTagOrigin( "tag_eye" );
	e_extra_cam.angles = ai_pov_claw GetTagAngles( "tag_eye" );
	e_extra_cam LinkTo( ai_pov_claw, "tag_eye" );
	
	flag_set( "claw_pip_on" );
	maps\_glasses::turn_on_extra_cam();
}

claw_pip_off()
{
	maps\_glasses::turn_off_extra_cam();
	flag_clear( "claw_pip_on" );
}

claw_startup()
{	
	//SOUND - Shawn J
	PlaySoundAtPosition ("sce_transition", (0,0,0));
	
	//Fade out to static for Claw start
	screen_fade_out( 0.25, "compass_static" );
	
	//Stop PIP from garage startup sequence
	level notify( "claw1_startup_screen_faded" );
	
		
	//Spawn AI Claw on roof
	s_claw_ai_startup_position = GetStruct( "claw_ai_startup_position", "targetname" );
	claw_ai_origin = s_claw_ai_startup_position.origin;
	claw_ai_angles = s_claw_ai_startup_position.angles;
	
	level.claw_ai = simple_spawn_single( "claw_ai" );
	level.claw_ai set_ignoreall( true );
	level.claw_ai.overrideActorDamage = ::claw_ai_damage_override;
	level.claw_ai ForceTeleport( claw_ai_origin, claw_ai_angles );
	
	//Spawn enemy AI for Claw start
	init_ai_spawn_funcs();
	spawn_manager_enable( "claw_roof_sm_wave1" );
	level thread breach_spawn();
	
	//Put player in Claw vehicle and initilize player's current Claw (ground is Claw 1, roof is Claw 2)
	level.player FreezeControls( true );
	level.claw1 UseVehicle( level.player, 0 );
	level.harper Delete();
	level.player.current_claw = 1;
	
	//Setup damage handling for Claw vehicle and player
	level.claw1.overrideVehicleDamage = ::claw_vehicle_damage_override;
	level.claw1 veh_magic_bullet_shield( true );
	level.claw1 thread maps\_vehicle_death::vehicle_damage_filter();
	level.player.overridePlayerDamage = ::claw_player_damage_override;

	//Switch on Claw vision	
	maps\createart\pakistan_2_art::turn_on_claw_vision();
	
	setmusicstate ("PAK_CLAWS");
	
	//TODO: Don't remember what this is for.  Maybe can be removed?
	wait 1.25;
	
	//Enable Claw grenade weapon
	level.player thread claw_grenade_turret_think( level.claw1 );
	
	//Fade in from static and give player control
	screen_fade_in( 0.25, "compass_static" );
	level.player FreezeControls( false );
	
	autosave_by_name( "claw_battle_start" );
	
	//TODO: Bink was interfering with the extra cam view later on. Should be fixed and reenabled.
	//level thread claw2_startup_pip();
	
	//Display tutorial text for Claw start
	level thread claw_tutorial();
	
	//Advance the event when the player open fires or walks out of the alleyway they start in
	waittill_either_function( ::trigger_wait, "claw1_tutorial_trigger", ::waittill_any_attack_button_pressed, level.player );
	
	//Initialize cover trigger which handle enemy retreating to preset goal volumes as the Claw advances
	level thread init_cover_triggers();
	
	//Initialize triggers for cleaning up AI as the Claw advances.  
	//TODO: This may be deprecated.  Not sure any of these triggers are actually used.
	level thread init_ai_cleanup_triggers();
	
	//Start retreat action for starting enemy AI on ground
	level thread breach_retreat();
	
	//Start spawning waves of ground enemy AI
	spawn_manager_enable( "claw_ground_sm_wave1" );

	//Initialize trigger for juggernaut spawn on ground
	level thread claw_juggernaut_attack_trigger_think();
	
	//Initialize trigger for firescout spawn on roof
	level thread claw_drone_attack_think();
	
	//Wait until the player advances out of the alleyway
	trigger_wait( "claw1_tutorial_trigger" );
	
	//Init Claw objectives and update function for roof objectives
	level.claw1_objective = GetStruct( "claw_courtyard_marker", "targetname" );
	level.claw2_objective = GetStruct( "claw2_obj_marker1", "targetname" );
	set_objective( level.OBJ_ESCAPE, undefined, "remove" );
	set_objective( level.OBJ_ESCAPE, level.claw1_objective.origin, "breadcrumb" );
	level thread claw2_objective_update();
	
	//Set AI Claw's initial goal position
	level.claw_ai SetGoalNode( GetNode( level.str_claw2_target_pos, "targetname" ) );
	level.claw_ai set_goalradius( 8 );
	level.claw_ai set_ignoreall( false );
	
	//Turn on PIP extracam view from AI Claw perspective
	level thread claw_pip_on( level.claw_ai );
	level.player say_dialog( "harp_keep_an_eye_on_the_v_0" );
	
	//Enable switching function
	level.player thread claw_switch_think();
}

claw_tutorial()
{
	screen_message_create( &"PAKISTAN_SHARED_CLAW_HINT_MOVEMENT" );
	trigger_wait( "claw1_tutorial_trigger" );
	
	screen_message_delete();
	screen_message_create( &"PAKISTAN_SHARED_CLAW_HINT_MINIGUN", &"PAKISTAN_SHARED_CLAW_HINT_GRENADE", &"PAKISTAN_SHARED_CLAW_HINT_FLAMETHROWER" );
	trigger_wait( "claw1_enter_trigger" );
	
	screen_message_delete();
}

breach_spawn()
{	
	level thread run_scene( "claw_start_breach" );
	waittill_either_function( ::trigger_wait, "claw1_tutorial_trigger", ::waittill_any_attack_button_pressed, level.player );
}

claw2_startup_pip()
{
	thread maps\_glasses::play_bink_on_hud( "claw_offline_temp", true, true );
	level waittill( "claw2_startup_screen_faded" );
	
	thread maps\_glasses::stop_bink_on_hud();
}

claw_switch()
{
	//SOUND - Shawn J
	PlaySoundAtPosition ("sce_transition_short", (0,0,0));
	
	screen_message_delete();
	screen_fade_out( 0.25, "compass_static" );
	level.player FreezeControls( true );
	level.player EnableInvulnerability();
		
	if( level.player.current_claw == 1 )
	{	
		new_claw_vehicle_origin = level.claw_ai.origin;
		new_claw_vehicle_angles = level.claw_ai.angles;
		new_claw_ai_origin = level.claw1.origin;
		new_claw_ai_angles = level.claw1.angles;
		
		if( flag( "claw_pip_on" ) )
		{
			claw_pip_off();
		}
		
		level.claw_ai Delete();
		level.claw2 = CodeSpawnVehicle( "veh_t6_drone_claw_mk2", "claw2", "drone_claw", new_claw_vehicle_origin, new_claw_vehicle_angles );
		vehicle_init( level.claw2 );
		
		//Wait for vehicle to initialize
		wait 0.05;
		
		level.player notify( "stop_claw_grenade_turret" );
		level.claw1 UseVehicle( level.player, 0 );
		level.claw1 notify( "stop_death_think" );
		
		//Wait to exit vehicle before trying to enter the other Claw
		wait 0.05;		
		
		level.claw2 UseVehicle( level.player, 0 );
		level.claw2.overrideVehicleDamage = ::claw_vehicle_damage_override;
		level.claw2 veh_magic_bullet_shield( true );
		
		level.player.current_claw = 2;
		level.claw1 Delete();
		level.claw2 thread maps\_vehicle_death::vehicle_damage_filter();
		
		level.claw_ai = simple_spawn_single( "claw_ai" );
		level.claw_ai.overrideActorDamage = ::claw_ai_damage_override;
		level.claw_ai ForceTeleport( new_claw_ai_origin, new_claw_ai_angles );
		level.claw_ai SetGoalNode( GetNode( level.str_claw1_target_pos, "targetname" ) );
		level.claw_ai set_goalradius( 8 );
		
		if( !flag( "claw_pip_on" ) )
		{
			level thread claw_pip_on( level.claw_ai );
		}
		
		level.player thread claw_grenade_turret_think( level.claw2 );
		
		set_objective( level.OBJ_ESCAPE, undefined, "remove" );
		set_objective( level.OBJ_ESCAPE, level.claw2_objective.origin, "breadcrumb" );
	}
	else
	{
		new_claw_vehicle_origin = level.claw_ai.origin;
		new_claw_vehicle_angles = level.claw_ai.angles;
		new_claw_ai_origin = level.claw2.origin;
		new_claw_ai_angles = level.claw2.angles;
		
		if( flag( "claw_pip_on" ) )
		{
			claw_pip_off();
		}
		
		level.claw_ai Delete();
		level.claw1 = CodeSpawnVehicle( "veh_t6_drone_claw_mk2", "claw1", "drone_claw_wflamethrower", new_claw_vehicle_origin, new_claw_vehicle_angles );
		vehicle_init( level.claw1 );
		
		//Wait for vehicle init
		wait 0.05;
		
		level.player notify( "stop_claw_grenade_turret" );
		level.claw2 UseVehicle( level.player, 0 );
		level.claw2 notify( "stop_death_think" );
		
		//Wait to exit vehicle before entering other Claw
		wait 0.05;		
		level.claw1 UseVehicle( level.player, 0 );
		level.claw1.overrideVehicleDamage = ::claw_vehicle_damage_override;
		level.claw1 veh_magic_bullet_shield( true );
		
		level.player.current_claw = 1;
		level.claw2 Delete();
		level.claw1 thread maps\_vehicle_death::vehicle_damage_filter();
		
		level.claw_ai = simple_spawn_single( "claw_ai" );
		level.claw_ai.overrideActorDamage = ::claw_ai_damage_override;
		level.claw_ai ForceTeleport( new_claw_ai_origin, new_claw_ai_angles );
		level.claw_ai SetGoalNode( GetNode( level.str_claw2_target_pos, "targetname" ) );
		level.claw_ai set_goalradius( 8 );
		
		if( !flag( "claw_pip_on" ) )
		{
			level thread claw_pip_on( level.claw_ai );
		}
		
		level.player thread claw_grenade_turret_think( level.claw1 );
		
		set_objective( level.OBJ_ESCAPE, undefined, "remove" );
		set_objective( level.OBJ_ESCAPE, level.claw1_objective.origin, "breadcrumb" );
	}
	
	claw_kill_objectives_update();
	
	level thread screen_fade_in( 0.25, "compass_static" );
	//SOUND - Shawn J
	level.player FreezeControls( false );
	level.player DisableInvulnerability();
	flag_set( "claw_switch_done" );
}

claw_switch_think()
{
	level endon( "claw_event_over" );
	level endon( "claw_dead" );
	
	flag_set( "claw_switch_done" );
	
	while( true )
	{
		self waittill_weapon_switch_button_pressed();
		
		flag_clear( "claw_switch_done" );
		level thread claw_switch();
		flag_wait( "claw_switch_done" );
		
		//Delay before allowing another switch
		wait 1.0;
	}
}

claw_ai_target_pos_update( str_new_pos, claw_id )
{
	level endon( "claw_event_over" );
	level endon( "claw_dead" );
	
	self waittill( "death" );
	
	if( claw_id == 1 )
	{
		level.str_claw1_target_pos = str_new_pos;
	}
	else
	{
		level.str_claw2_target_pos = str_new_pos;
	}
}

claw_juggernaut_attack_trigger_think()
{
	level endon( "claw_event_over" );
	
	trigger_wait( "claw_juggernaut_attack_trigger" );
	
	if( level.player.current_claw == 1 )
	{
		level.player say_dialog( "harp_multiple_enemies_inc_0" );
	}
	
	level.a_juggernauts = simple_spawn( "claw_juggernaut" );
	
	claw_kill_objectives_update();
	level.a_juggernauts[0] thread claw_kill_objectives_death_think( "juggernaut" );
	level.a_juggernauts[1] thread claw_kill_objectives_death_think( "juggernaut" );
	
	foreach( ai_juggernaut in level.a_juggernauts )
	{
		ai_juggernaut make_juggernaut( false );
		//ai_juggernaut.health = 2500;
		ai_juggernaut.pathenemyfightdist = PATH_ENEMY_FIGHT_DISTANCE;
		ai_juggernaut thread claw_ai_target_pos_update( "ground_claw_goal_pos2", 1 );
		
		ai_juggernaut change_movemode( "sprint" );
		ai_juggernaut thread force_goal( GetNode( ai_juggernaut.target, "targetname" ), 32, false );
		ai_juggernaut waittill( "goal" );
		
		ai_juggernaut reset_movemode();
	}
}

claw_drone_attack_think()
{
	level endon( "claw_event_over" );
	level endon( "stop_drones" );
	
	//trigger_wait( "claw_drone_attack_trigger1" );
	
	vh_drone1 = spawn_vehicle_from_targetname( "claw_roof_drone1" );
	level.a_claw_drones[0] = vh_drone1;
	nd_start1 = GetNode( "claw_drone_path_start1", "targetname" );

	claw_kill_objectives_update();
	vh_drone1 thread claw_kill_objectives_death_think( "drone" );
	
	vh_drone1 play_fx( "drone_spotlight_cheap", vh_drone1 GetTagOrigin( "tag_flash" ), vh_drone1 GetTagAngles( "tag_flash" ), "death", true, "tag_flash" );
	vh_drone1 thread claw_ai_target_pos_update( "roof_claw_goal_pos2", 2 );
	vh_drone1 thread go_path( nd_start1 );
	vh_drone1 waittill( "start_shooting" );
		
	vh_drone1 SetLookAtEnt( level.player );
	vh_drone1 enable_turret( 0, false );
	vh_drone1 set_turret_target( level.player, undefined, 0 );
	trigger_wait( "claw_drone_attack_trigger2" );
	
	vh_drone2 = spawn_vehicle_from_targetname( "claw_roof_drone2" );
	level.a_claw_drones[1] = vh_drone2;
	nd_start2 = GetNode( "claw_drone_path_start2", "targetname" );
	
	claw_kill_objectives_update();	
	vh_drone2 thread claw_kill_objectives_death_think( "drone" );
	
	vh_drone2 play_fx( "drone_spotlight_cheap", vh_drone2 GetTagOrigin( "tag_flash" ), vh_drone2 GetTagAngles( "tag_flash" ), "death", true, "tag_flash" );
	vh_drone1 thread claw_ai_target_pos_update( "roof_claw_goal_pos2", 2 );
	vh_drone2 thread go_path( nd_start2 );
	vh_drone2 waittill( "start_shooting" );
		
	vh_drone2 SetLookAtEnt( level.player );
	vh_drone2 enable_turret( 0, false );
	vh_drone2 set_turret_target( level.player, undefined, 0 );
}

claw_kill_objectives_update()
{
	if( level.player.current_claw == 1 )
	{
		if( IsDefined( level.a_claw_drones ) )
		{
			foreach( vh_drone in level.a_claw_drones )
			{
				if( IsDefined( vh_drone ) )
				{
					set_objective( level.OBJ_CLEAR_RAILYARD, vh_drone, "remove" );
				}
			}
		}
		
		set_objective( level.OBJ_CLEAR_RAILYARD, undefined, undefined, level.n_juggernauts_dead );
		
		if( IsDefined( level.a_juggernauts ) )
		{
			foreach( ai_juggernaut in level.a_juggernauts )
			{
				if( IsDefined( ai_juggernaut ) && IsAlive( ai_juggernaut ) )
				{
					set_objective( level.OBJ_CLEAR_RAILYARD, ai_juggernaut, "kill", -1 );
				}
			}
		}
	}
	else
	{
		if( IsDefined( level.a_juggernauts ) )
		{
			foreach( ai_juggernaut in level.a_juggernauts )
			{
				if( IsDefined( ai_juggernaut ) )
				{
					set_objective( level.OBJ_CLEAR_RAILYARD, ai_juggernaut, "remove" );
				}
			}
		}
		
		set_objective( level.OBJ_CLEAR_RAILYARD, undefined, undefined, level.n_claw_drones_dead );
		
		if( IsDefined( level.a_claw_drones ) )
		{
			foreach( vh_drone in level.a_claw_drones )
			{
				if( IsDefined( vh_drone ) && IsAlive( vh_drone ) )
				{
					set_objective( level.OBJ_CLEAR_RAILYARD, vh_drone, "destroy", -1 );
				}
			}
		}
	}
}

claw_kill_objectives_death_think( str_target_type )
{
	self waittill( "death" );
	
	set_objective( level.OBJ_CLEAR_RAILYARD, self, "remove" );
	
	if( str_target_type == "juggernaut" )
	{
		level.n_juggernauts_dead++;
		set_objective( level.OBJ_CLEAR_RAILYARD, undefined, undefined, level.n_juggernauts_dead );
	}
	else
	{
		level.n_claw_drones_dead++;
		set_objective( level.OBJ_CLEAR_RAILYARD, undefined, undefined, level.n_claw_drones_dead );
	}
	
}

claw_kill_objectives_cleanup()
{
	foreach( ai_juggernaut in level.a_juggernauts )
	{
		if( IsDefined( ai_juggernaut ) )
		{
			set_objective( level.OBJ_CLEAR_RAILYARD, ai_juggernaut, "remove" );
		}
	}
	
	foreach( vh_drone in level.a_claw_drones )
	{
		if( IsDefined( vh_drone ) )
		{
			set_objective( level.OBJ_CLEAR_RAILYARD, vh_drone, "remove" );
		}
	}
}

claw_drone_withdraw()
{
	level notify( "stop_drones" );
	
	if( level.player.current_claw == 2 )
	{
		foreach( vh_drone in level.a_claw_drones )
		{
			if( IsDefined( vh_drone ) )
			{
				set_objective( level.OBJ_CLEAR_RAILYARD, vh_drone, "remove" );
			}
		}
	}
	
	vh_drone = GetEnt( "claw_roof_drone1", "targetname" );
	nd_exit = GetVehicleNode( "claw_drone_path_exit1", "targetname" );
	
	if( IsDefined( vh_drone ) && IsAlive( vh_drone ) )
	{
		vh_drone ClearLookAtEnt();
		vh_drone disable_turret( 0 );
		vh_drone clear_turret_target( 0 );
		vh_drone thread go_path( nd_exit );
		vh_drone thread claw_drone_cleanup();
	}
	
	vh_drone = GetEnt( "claw_roof_drone2", "targetname" );
	nd_exit = GetVehicleNode( "claw_drone_path_exit2", "targetname" );
	
	if( IsDefined( vh_drone ) && IsAlive( vh_drone ) )
	{
		vh_drone ClearLookAtEnt();
		vh_drone disable_turret( 0 );
		vh_drone clear_turret_target( 0 );
		vh_drone thread go_path( nd_exit );
		vh_drone thread claw_drone_cleanup();
	}
}

claw_drone_cleanup()
{
	self waittill( "delete" );
	
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

waittill_weapon_switch_button_pressed()
{
	while ( true )
	{
		if ( self changeSeatButtonPressed() )
		{
			break;
		}
		
		//Run once per frame
		wait 0.05;
	}
}

claw_grenade_turret_think( veh_claw )
{
	self endon( "stop_claw_grenade_turret" );
	delay_time = 1.5;

	while( true )
	{
		waittill_frag_button_pressed( self );
		
		veh_claw claw_fire_grenade( delay_time );
		
		//Delay before allowing another grenade to fire
		wait delay_time;
	}
}

waittill_frag_button_pressed( e_player )
{
	while ( !e_player FragButtonPressed() )
	{
		//Run once per frame
		wait 0.05;
	}
}

waittill_any_attack_button_pressed( e_player )
{
	while ( !e_player FragButtonPressed() && !e_player AttackButtonPressed() && !e_player AdsButtonPressed() )
	{
		//Run once per frame
		wait 0.05;
	}
}

claw_fire_grenade( delay_time )
{
	n_grenade_speed_scale = 3000;
	n_grenade_timer = 1.25;
	n_grenade_max_range = 4096;
	v_start_pos = self GetTagOrigin( "tag_barrel" );
	v_end_pos = v_start_pos + ( AnglesToForward( self GetTagAngles( "tag_barrel" ) ) * n_grenade_max_range );
	v_grenade_velocity = VectorNormalize( v_end_pos - v_start_pos ) * n_grenade_speed_scale;
	
	self MagicGrenadeType( "claw_grenade_impact_explode_sp", v_start_pos, v_grenade_velocity, delay_time );
	self playsound("wpn_claw_gren_fire_plr");//kevin adding launch sound
	LUINotifyEvent( &"hud_claw_grenade_fire", 1, Int( n_grenade_timer * 1000 ) );
}

claw_ai_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if( IsDefined( eInflictor.script_noteworthy ) && eInflictor.script_noteworthy == "lethal" )
	{
		if( level.player.current_claw == 1 )
		{	
			if( level.claw2_ai_damage_total == 0 && flag( "claw_switch_done" ) )
			{
				level.player say_dialog( "harp_switch_to_the_other_0" );
				
				screen_message_create( &"PAKISTAN_SHARED_CLAW_HINT_SWITCH" );
			}
			
			level.claw2_ai_damage_total = level.claw2_ai_damage_total + iDamage;
			
			if( level.claw2_ai_damage_total > 7500 && flag( "claw_switch_done" ) )
			{
				if( flag( "claw_pip_on" ) )
				{
					claw_pip_off();
				}

				screen_message_delete();
				level notify( "claw_dead" );
				level thread claw_drone_withdraw();
				level.player say_dialog( "sect_claw_s_offline_0" );
				return level.claw_ai.health;
			}
		}
		else
		{	
			if( level.claw1_ai_damage_total == 0 && flag( "claw_switch_done" ) )
			{
				screen_message_create( &"PAKISTAN_SHARED_CLAW_HINT_SWITCH" );
			}
			
			level.claw1_ai_damage_total = level.claw1_ai_damage_total + iDamage;
			
			if( level.claw1_ai_damage_total > 7500 && flag( "claw_switch_done" ) )
			{
				if( flag( "claw_pip_on" ) )
				{
					claw_pip_off();
				}
				
				screen_message_delete();
				level notify( "claw_dead" );
				level.player say_dialog( "sect_claw_s_offline_0" );
				return level.claw_ai.health;
			}
		}
	}
	
	return 0;
}

claw_vehicle_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if( IsDefined( eInflictor.script_noteworthy ) && eInflictor.script_noteworthy == "lethal" )
	{
		if( level.player.current_claw == 1 )
		{	
			level.claw1_damage_total = level.claw1_damage_total + iDamage;
			
			if( level.claw1_damage_total > 25000 && flag( "claw_switch_done" ) )
			{
				if( IsDefined( level.claw_ai ) && IsAlive( level.claw_ai ) )
				{
					level thread player_switch_claw_on_death();
				}
				else
				{
					level thread missionfailedwrapper();
				}
			}
		}
		else
		{
			level.claw2_damage_total = level.claw2_damage_total + iDamage;
			
			if( level.claw2_damage_total > 5000 && flag( "claw_switch_done" ) )
			{
				if( IsDefined( level.claw_ai ) && IsAlive( level.claw_ai ) )
				{
					level thread player_switch_claw_on_death();
				}
				else
				{
					level thread missionfailedwrapper();
				}
			}
		}
	}
	
	return iDamage;
}

player_switch_claw_on_death()
{
	level notify( "claw_dead" );
	
	flag_clear( "claw_switch_done" );
	claw_switch();
	
	if( flag( "claw_pip_on" ) )
	{
		claw_pip_off();
	}
	screen_message_delete();
	
	level.claw_ai.overrideActorDamage = undefined;
	level.claw_ai DoDamage( level.claw_ai.health, level.claw_ai.origin );
	
	level.player say_dialog( "sect_claw_s_offline_0" );
}

claw_juggernaut_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if( !IsAI( eInflictor ) )
	{
		return iDamage;
	}
	
	return 0;
}

claw_player_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	return 0;
}

init_ai_spawn_funcs()
{
	level.current_roof_goal_volume = GetEnt( "claw_roof_cover_group1", "targetname" );
	level.current_ground_goal_volume = GetEnt( "claw_ground_cover_group1", "targetname" );
	
	add_spawn_function_group( "claw_roof_soldiers", "script_noteworthy", ::ai_init_start_goal_volume );
	add_spawn_function_group( "claw_ground_soldiers", "script_noteworthy", ::ai_init_start_goal_volume );
}

breach_retreat()
{
	simple_spawn( "claw_breach_guys2" );
	
	//Wait for new spawns to fill in trainyard before retreat
	wait 1.0;
	
	end_scene( "claw_start_breach" );
	
	for( i = 1; i <= 6; i++ )
	{
		ai_enemy = GetEnt( "door_breacher" + i + "_ai", "targetname" );
		
		if( IsDefined( ai_enemy ) && IsAlive( ai_enemy ) )
		{
			ai_enemy SetGoalVolumeAuto( GetEnt( "claw_ground_cover_group2", "targetname" ) );
			self.pathenemyfightdist = PATH_ENEMY_FIGHT_DISTANCE;
			ai_enemy thread ai_fallback_reengage();
		}
	}
	
	//Stagger retreat
	wait 1.0;
	
	foreach( ai_enemy in GetEntArray( "claw_breach_guys2_ai", "targetname" ) )
	{
		ai_enemy SetGoalVolumeAuto( GetEnt( "claw_ground_cover_group2", "targetname" ) );
		self.pathenemyfightdist = PATH_ENEMY_FIGHT_DISTANCE;
		ai_enemy thread ai_fallback_reengage();
	}
}

claw_ai_wave_setup( wave_start )
{
	switch( wave_start )
	{
		case 1:
				foreach( ai_enemy in GetEntArray( "claw_breach_soldiers", "script_noteworthy" ) )
				{
					ai_enemy Delete();
				}
				
				spawn_manager_enable( "claw_ground_sm_wave1" );
			break;
		case 2:
			if( level.player.current_claw == 1 )
			{
				level.current_roof_goal_volume = GetEnt( "claw_roof_cover_group3", "targetname" );
				
				spawn_manager_disable( "claw_roof_sm_wave1" );
				
				foreach( ai_enemy in GetEntArray( "claw_roof_soldiers", "script_noteworthy" ) )
				{
					if( IsAI( ai_enemy ) )
					{
						ai_enemy Delete();
					}
				}
				
				spawn_manager_enable( "claw_roof_sm_wave2" );
				
				while( true )
				{
					a_roof_soldiers = GetEntArray( "claw_roof_wave2_ai", "targetname" );
					
					if( a_roof_soldiers.size >= 4 )
					{
						a_positions = GetNodeArray( "claw_roof_wave2_starts", "targetname" );
						
						for( i = 0; i < 4; i++ )
						{
							a_roof_soldiers[i] ForceTeleport( a_positions[i].origin, a_positions[i].angles );
						}
						break;
					}
					
					//Run once per frame
					wait 0.05;
				}
				
				//level thread claw_roof_drone_attack();
			}
			break;
		default:
			break;
	}
}

init_cover_triggers()
{
	array_thread( GetEntArray( "claw_cover_trigger", "targetname" ), ::cover_trigger_think );
}

cover_trigger_think()
{
	level endon( "claw_event_over" );
	
	self waittill( "trigger", e_triggerer );
	self thread trigger_thread( e_triggerer, ::cover_trigger_in, ::cover_trigger_out );
}

cover_trigger_in( ent, endon_string )
{	
	if( (level.player.current_claw == 1 && IsPlayer( ent )) || (level.player.current_claw == 2 && IsAI( ent )) )
	{
		level.current_ground_goal_volume = GetEnt( self.target, "targetname" );
		
		foreach( ai_enemy in GetEntArray( "claw_ground_soldiers", "script_noteworthy" ) )
		{
			if( IsAI( ai_enemy ) )
			{
				ai_enemy ClearGoalVolume();
				ai_enemy SetGoalVolumeAuto( level.current_ground_goal_volume );
				ai_enemy thread ai_fallback_reengage();
			}
		}
	}
	else if( (level.player.current_claw == 2 && IsPlayer( ent )) || (level.player.current_claw == 1 && IsAI( ent )) )
	{
		level.current_roof_goal_volume = GetEnt( self.target, "targetname" );
		
		foreach( ai_enemy in GetEntArray( "claw_roof_soldiers", "script_noteworthy" ) )
		{
			if( IsAI( ai_enemy ) )
			{
				ai_enemy ClearGoalVolume();
				ai_enemy SetGoalVolumeAuto( level.current_roof_goal_volume );
				ai_enemy thread ai_fallback_reengage();
			}
		}
	}
}

cover_trigger_out( ent )
{
	self thread cover_trigger_think();
}

ai_init_start_goal_volume()
{	
	if( self.script_noteworthy == "claw_roof_soldiers" )
	{
		self SetGoalVolumeAuto( level.current_roof_goal_volume );
	}
	else if( self.script_noteworthy == "claw_ground_soldiers" )
	{
		self SetGoalVolumeAuto( level.current_ground_goal_volume );
	}
	
	self.pathenemyfightdist = PATH_ENEMY_FIGHT_DISTANCE;
	self thread ai_fallback_reengage();
}

ai_fallback_reengage()
{
	self endon( "death" );
	
	self change_movemode( "sprint" );
	self set_ignoreall( true );
	self waittill( "goal" );
	
	self change_movemode( "run" );
	self set_ignoreall( false );
}

init_ai_cleanup_triggers()
{
	array_thread( GetEntArray( "claw_ai_cleanup_trigger", "targetname" ), ::ai_cleanup_trigger_think );
}

ai_cleanup_trigger_think()
{
	self waittill( "trigger" );
	
	foreach( ai_enemy in GetEntArray( self.script_noteworthy + "_ai", "targetname" ) )
	{
		ai_enemy Delete();
	}
}

claw_soct_event()
{
	flag_wait( "claw_battle_end" );
	
	//SOUND - Shawn J
	PlaySoundAtPosition ("sce_transition", (0,0,0));
	
	//Fade to static for tranistion to SOCT event
	screen_fade_out( 0.25, "compass_static" );
	level.player FreezeControls( true );
	
	soct_event_start_setup();
		
	//Fade in for SOCT event start
	level thread screen_fade_in( 0.25, "compass_static" );
	level.player FreezeControls( false );
	
	//Checkpoint and start VO thread for SOCT event
	level thread autosave_by_name( "juggernauts_clear" );
	level thread claw_vo();
	
	//Run Harper out of the garage for evil SOCT entrance on player exit
	run_anim_to_idle( "garage_exit_harper", "garage_exit_harper_idle" );
	flag_wait( "garage_exited" );
	
	//If player runs out of SOCT event area mission fail
	GetEnt( "soct_event_proximity_trigger", "targetname" ) thread soct_proximity_fail_think();
	
	//Enter evil SOCT and put enemy AI in vehicle at end of scene
	run_scene( "claw_soct_entrance_enemy" );
	GetEnt( "claw_enemy_driver_ai", "targetname" ) enter_vehicle( GetEnt( "claw_enemy_soct", "targetname" ), "tag_driver" );
	GetEnt( "claw_enemy_gunner_ai", "targetname" ) enter_vehicle( GetEnt( "claw_enemy_soct", "targetname" ), "tag_gunner" );
	
	//Harper idle at box for suicide
	level thread run_scene( "claw_soct_harper_idle" );
	
	//Pop up data glove to take control of suicide CLAW
	level.player DisableWeaponCycling();
	str_previous_weapon = level.player GetCurrentWeapon();
	level.player GiveWeapon( "data_glove_sp" );
	
	//Wait for player to have weapon
	wait 0.1;
	
	level.player SwitchToWeapon( "data_glove_sp" );
	
	//Pause before taking away weapon
	wait 1.5;
	level.player SwitchToWeapon( str_previous_weapon );
	level.player TakeWeapon( "data_glove_sp" );
	level.player EnableWeaponCycling();
	
	//Fade out to static for transition
	screen_fade_out( 0.25, "compass_static" );

	soct_claw_suicide();

	//Checkpoint and start Salazar entrance
	level thread autosave_by_name( "claw_clear" );
	level thread friendly_drone_enter();
	level thread run_scene( "claw_soct_entrance_ally" );
	
	//Fade up from suicide transtion
	level thread screen_fade_in( 0.25, "compass_static" );
	
	//Allow player to enter SOCT once his SOCT unloads
	level thread soct_player_mount();
	
	//Put AI in SOCT as they move SOCTs in animation
	level thread soct_exit();
	
	//Wait for player to enter SOCT before tranistion to Pak3
	scene_wait( "claw_soct_mount_player" );
}

soct_event_start_setup()
{
	//Stop threads from Claw battle
	level notify( "claw_event_over" );
	
	//Turn off claw PIP
	if( flag( "claw_pip_on" ) )
	{
		claw_pip_off();
	}
	
	//Cleanup objectives
	claw_kill_objectives_cleanup();
	set_objective( level.OBJ_ESCAPE, undefined, "remove" );
	set_objective( level.OBJ_CLEAR_RAILYARD, undefined, "done" );
	
	//Stop grenade turret
	level.player notify( "stop_claw_grenade_turret" );
	
	//Remove player from CLAW and teleport to SOCT start
	if( level.player.current_claw == 1 )
	{
		level.claw1 UseBy( level.player );
		level.claw1 notify( "stop_death_think" );
		level.claw1 Delete();
	}
	else
	{
		level.claw2 UseBy( level.player );
		level.claw2 notify( "stop_death_think" );
		level.claw2 Delete();
	}
	
	if( IsDefined( level.claw_ai ) && IsAlive( level.claw_ai ) )
	{
		level.claw_ai Delete();
	}
	
	maps\createart\pakistan_2_art::turn_off_claw_vision();
	level.player.overridePlayerDamage = undefined;
	
	s_garage_exit_player_start = GetStruct( "garage_exit_player_start", "targetname" );
	
	level.player SetOrigin( s_garage_exit_player_start.origin );
	level.player SetPlayerAngles( s_garage_exit_player_start.angles );
	
	//Disable spawns and cleanup AI from CLAW battle
	spawn_manager_disable( "claw_courtyard_sm" );
	
	//Wait for any spawns to finish
	wait 1.0;
	
	a_enemies = GetAIArray( "axis" );
	foreach( ai_enemy in a_enemies )
	{
		ai_enemy DoDamage( ai_enemy.health, ai_enemy.origin );
	}
	
	vh_drone = GetEnt( "claw_roof_drone1", "targetname" );
	
	if( IsDefined( vh_drone ) && IsAlive( vh_drone ) )
	{
		vh_drone Delete();
	}
	
	vh_drone = GetEnt( "claw_roof_drone2", "targetname" );
	
	if( IsDefined( vh_drone ) && IsAlive( vh_drone ) )
	{
		vh_drone Delete();
	}
	
	//Setup CLAW vehicle for suicide run in scene
	if( level.player.current_claw == 1 )
	{
		level.veh_suicide_claw = spawn_vehicle_from_targetname( "suicide_claw1" );
		level.nd_suicide_claw_start = GetVehicleNode( "suicide_claw_start1", "targetname" );
	}
	else
	{
		level.veh_suicide_claw = spawn_vehicle_from_targetname( "suicide_claw2" );
		level.nd_suicide_claw_start = GetVehicleNode( "suicide_claw_start2", "targetname" );
	}
	
	//Reinit Harper and set anim first frame
	level.harper = init_hero( "harper" );
	
	run_scene_first_frame( "garage_exit_harper" );
	run_scene_first_frame( "claw_soct_entrance_enemy" );
}

soct_claw_suicide()
{
	//Put player in suicide CLAW
	level.veh_suicide_claw UseVehicle( level.player, 0 );
	level.veh_suicide_claw disable_driver_turret();
	maps\createart\pakistan_2_art::turn_on_claw_vision();
	level.veh_suicide_claw thread maps\_vehicle_death::vehicle_damage_filter();
	level.player.overridePlayerDamage = ::claw_player_damage_override;
	
	//Set destroy objective on evil SOCT
	set_objective( level.OBJ_ESCAPE, undefined, "remove" );
	set_objective( level.OBJ_ESCAPE, GetEnt( "claw_enemy_soct", "targetname" ).origin, "destroy" );
	
	//Fade in for suicide event
	screen_fade_in( 0.25, "compass_static" );
	
	//Fire SOCT turret at suicide CLAW
	level thread soct_fire_weapon( GetEnt( "claw_enemy_soct", "targetname" ) );
	GetEnt( "claw_enemy_soct", "targetname" ) set_turret_target( level.player, (0, 0, 192), 1 );
	
	//Set suicide CLAW on spline
	level.veh_suicide_claw thread go_path( level.nd_suicide_claw_start );
	level.veh_suicide_claw SetSpeedImmediate( 0 );

	//Give player ability to walk forward and wait for them to get to the SOCT
	level thread claw_suicide_move( level.veh_suicide_claw );
	trigger_wait( "claw_suicide_trigger" );
	
	//Stop weapon firing and kill player movement
	soct_stop_fire_weapon( GetEnt( "claw_enemy_soct", "targetname" ) );
	flag_set( "claw_suicide_target_reached" );
	level.veh_suicide_claw SetSpeedImmediate( 0 );
	
	//Remove destroy objective
	set_objective( level.OBJ_ESCAPE, undefined, "remove" );
	
	//Fade out for transition out of suicide CLAW
	screen_fade_out( 0.25, "compass_static" );
	
	//Remove player from suicide CLAW and teleport to start for SOCT escape
	level.veh_suicide_claw UseBy( level.player );
	level.player.overridePlayerDamage = undefined;
	maps\createart\pakistan_2_art::turn_off_claw_vision();
	
	s_soct_exit_player_start = GetStruct( "soct_exit_player_start", "targetname" );
	
	level.player SetOrigin( s_soct_exit_player_start.origin );
	level.player SetPlayerAngles( s_soct_exit_player_start.angles );
	
	//Blow the suicide CLAW/evil SOCT
	level.veh_suicide_claw Kill();
	GetEnt( "claw_enemy_soct", "targetname" ) Kill();

}

soct_exit()
{
	scene_wait( "claw_soct_entrance_ally" );
	
	GetEnt( "salazar_ai", "targetname" ) enter_vehicle( GetEnt( "claw_salazar_soct", "targetname" ), "tag_driver" );
	GetEnt( "claw_redshirt_ai", "targetname" ) enter_vehicle( GetEnt( "claw_salazar_soct", "targetname" ), "tag_gunner" );
	level.harper enter_vehicle( GetEnt( "claw_player_soct", "targetname" ), "tag_gunner" );
}

soct_player_mount()
{
	//Wait for driver seat to be available to the player
	wait 6.0;
	
	GetEnt( "soct_mount_trigger", "targetname" ) SetHintString( &"PAKISTAN_SHARED_MOUNT_SOCT_TRIGGER_HINT" );
	trigger_on( "soct_mount_trigger", "targetname" );
	set_objective( level.OBJ_ESCAPE, GetStruct( "soct_mount_objective_marker", "targetname" ), "enter" );
	trigger_wait( "soct_mount_trigger" );
	
	run_scene( "claw_soct_mount_player" );
}

claw_suicide_move( veh_suicide_claw )
{
	while( !flag( "claw_suicide_target_reached" ) )
	{
		if( level.player GetNormalizedMovement()[0] > 0.25 )
		{
			veh_suicide_claw SetSpeedImmediate( 3 );
		}
		else
		{
			veh_suicide_claw SetSpeedImmediate( 0 );
		}
		
		//Run once per frame
		wait 0.05;
	}
}

claw_cleanup()
{
	screen_fade_out( 0.25, "compass_static" );
	SetSavedDvar( "player_waterSpeedScale", 1.3 );	
	
	nextmission();
}

soct_fire_weapon( veh_soct )
{
	level endon( "claw_soct_stop_fire_weapon" );
	while( true )
	{
		veh_soct fire_turret( 1 );
		
		//Run once per frame
		wait 0.05;
	}
}

soct_stop_fire_weapon( veh_soct )
{
	level notify( "claw_soct_stop_fire_weapon" );
}

friendly_drone_enter()
{
	vh_drone = spawn_vehicle_from_targetname( "friendly_drone" );
	nd_drone_start = GetVehicleNode( "friendly_drone_start", "targetname" );
	e_target = GetEnt( "friendly_drone_target", "targetname" );
	
	vh_drone play_fx( "drone_spotlight", vh_drone GetTagOrigin( "tag_flash" ), vh_drone GetTagAngles( "tag_flash" ), "death", true, "tag_flash" );
	vh_drone thread go_path( nd_drone_start );
	vh_drone waittill( "target" );
	
	vh_drone SetLookAtEnt( e_target );
	vh_drone set_turret_target( e_target, undefined, 0 );
}

claw2_objective_update()
{
	flag_wait( "claw2_obj1_reached" );
	
	level.claw2_objective = GetStruct( "claw2_obj_marker2", "targetname" );
	set_objective( level.OBJ_ESCAPE, undefined, "remove" );
	set_objective( level.OBJ_ESCAPE, level.claw2_objective.origin, "breadcrumb" );
	flag_wait( "claw2_obj2_reached" );
	
	level.claw2_objective = GetStruct( "claw_courtyard_marker", "targetname" );
	set_objective( level.OBJ_ESCAPE, undefined, "remove" );
	set_objective( level.OBJ_ESCAPE, level.claw2_objective.origin, "breadcrumb" );
}

fake_vo_on_delay( str_line, n_delay )
{
	wait n_delay;
	
	IPrintLnBold( str_line );
}

soct_proximity_fail_think()
{
	n_fail_time_start = undefined;
	
	while( true )
	{
		if( !level.player IsTouching( self ) && !IsDefined( n_fail_time_start ) )
		{
			n_fail_time_start = GetTime();
			screen_message_create( &"PAKISTAN_SHARED_SOCT_ABANDON_WARNING" );
		}
		else if( !level.player IsTouching( self ) && (GetTime() - n_fail_time_start) > 3000 )
		{
			screen_message_delete();
			mission_fail( &"PAKISTAN_SHARED_SOCT_ABANDON_FAIL" );
		}
		else if( level.player IsTouching( self ) && IsDefined( n_fail_time_start ) )
		{
			n_fail_time_start = undefined;
			screen_message_delete();
		}
		
		//Run once per frame
		wait 0.05;
	}
}

claw_vo()
{
	level.harper say_dialog( "harp_it_s_now_or_never_m_0" );
	flag_wait( "garage_exited" );
	
	level.harper say_dialog( "harp_mg_truck_incoming_0", 1.0 );
	level.harper say_dialog( "harp_we_re_outta_options_0", 3.0 );
	trigger_wait( "claw_suicide_trigger" );
	
	level.harper say_dialog( "harp_blow_it_0" );
}