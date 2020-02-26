#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_dialog;
#include maps\monsoon_util;
#include maps\monsoon_heli;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

init_ruins_flags()
{
	flag_init( "ruins_stealth_over" );
	flag_init( "player_reached_switchback" );
	flag_init( "player_reached_helipad" );
	flag_init( "squad_reached_helipad" );
	flag_init( "salazar_destroyed_heli" );
	flag_init( "heli_retreat_to_ruins" );
	flag_init( "helipad_battle_intro_vo_done" );
	flag_init( "player_reached_outer_ruins" );
	flag_init( "squad_reached_outer_ruins" );
	flag_init( "player_emp_ready" );
	flag_init( "player_has_emp" );
	flag_init( "helicopter_destroyed" );
	flag_init( "helicopter_crash_done" );
	flag_init( "squad_reached_temple_entrance" );
	flag_init( "player_reached_temple_entrance" );
	flag_init( "ruins_door_destroyed" );
	flag_init( "player_in_ruins_interior" );
	flag_init( "seal_ruins" );
	flag_init( "player_off_turret" );
}

////////////////////////////////
//                            //
//          SKIPTOS           //
//                            //
////////////////////////////////

skipto_camo_battle()
{
	//move the squad to specific spots
	level.harper = init_hero( "harper", ::skipto_teleport_single_ai, getstruct( "harper_skipto_camo_battle", "targetname" ) );
	level.salazar = init_hero( "salazar",  ::skipto_teleport_single_ai, getstruct( "salazar_skipto_camo_battle", "targetname" ) );
	level.crosby = init_hero( "crosby", ::skipto_teleport_single_ai, getstruct( "crosby_skipto_camo_battle", "targetname" ) );
	skipto_teleport_players( "player_skipto_camo_battle" );
	
	array_thread( get_heroes(), ::set_ignoreme, true );
	array_thread( get_heroes(), ::set_ignoreall, true );
	
	level.player set_ignoreme( true );
	
	//put the player in the crouch postion
	level.player AllowStand( false );
	level.player AllowCrouch( false );
	wait 0.5;
	level.player AllowStand( true );
	level.player AllowCrouch( true );
	
	//spawn the 3 ai that would have spawned in the predator scene
	run_scene( "camo_intro_enemy" );
	
	level.player set_ignoreme( false );

}

skipto_helipad_battle()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
	
	skipto_teleport( "player_skipto_helipad_battle", get_heroes() );
}

skipto_outer_ruins()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
	
	skipto_teleport( "player_skipto_outer_ruins", get_heroes() );
	
	trigger_use( "trigger_spawn_helicopters" );
	
	vh_heli = spawn_vehicle_from_targetname( "skipto_heli" );
	Target_Set( vh_heli, (0, 0, -60 ) );
	vh_heli thread heli_spotlight();
	vh_heli thread heli_monitor_health_ruins();
	vh_heli SetDefaultPitch( 20 );
	level.vh_heli = vh_heli;
	
}

skipto_inner_ruins()
{
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
	
	skipto_teleport( "player_skipto_inner_ruins", get_heroes() );
	
	vh_heli = spawn_vehicle_from_targetname( "skipto_heli" );
	vh_heli thread heli_spotlight();
	vh_heli thread heli_monitor_health_ruins();
	vh_heli SetDefaultPitch( 20 );
	
	level.player GiveWeapon( "m32_titus_sp" );
	
	delay_thread( 2, ::outer_ruins_emp, vh_heli.origin );
	
	spawn_manager_enable( "sm_heli_battle" );
	delay_thread( 2, ::spawn_manager_kill, "sm_heli_battle" );
}

skipto_ruins_interior()
{
	//heavy rain	
	set_rain_level( 5 );
	
	level.harper = init_hero( "harper" );
	level.salazar = init_hero( "salazar" );
	level.crosby = init_hero( "crosby" );
	
	skipto_teleport( "player_skipto_ruins_interior", get_heroes() );
	
	trigger_use( "trigger_color_ruins_interior" );
}

////////////////////////////////
//                            //
//        CHALLENGES          //
//                            //
////////////////////////////////

challenge_stealth( str_notify )
{
	level waittill( "stealth_successful" );
	
	self notify( str_notify );
}

challenge_turretkills( str_notify )
{
	while( 1 )
	{
		level waittill( "turret_death" );
		self notify( str_notify );
	}
}

////////////////////////////////
//                            //
//       CAMO BATTLE          //
//                            //
////////////////////////////////

camo_battle_main()
{
	camo_battle_cleanup_anims();
	
	//settings for stealth so the player can't be seen during the cutscene
	camo_intro_stealth_settings();
	
	//graps spawners with script_noteworthy and places them in stealth loops
	add_spawn_function_group( "camo_battle_loop", "script_noteworthy", ::camo_stealth_loop );
	
  	//monitor stealth level
  	level thread camo_battle_stealth_watch();
		
  	//spawn the enemies in the area
	spawn_manager_enable( "sm_camo_battle" );
	
	level.player thread maps\_stealth_logic::stealth_ai();
		
	//make the squad pacifist for stealth
	array_thread( get_heroes(), ::camo_battle_friendly_stealth );
			
	//heavy rain	
	set_rain_level( 5 );
	
	level thread camo_battle_lift();
	
	flag_wait( "predator_intro_scene_done" );
	
	//mark targets that were marked in the intro
	if( IsDefined( level.n_intro_spotted ) )
	{
		a_enemies = GetAIArray( "axis" );
		for( i = 0; i < level.n_intro_spotted; i++ )
		{
			a_enemies[i] play_fx( "enemy_marker_spotted", undefined, undefined, "death", true, "J_SpineLower" );
		}
	}

	//HACK remove this weapon switching nonsense once the scar weapon is supported and make it and titus default loadout
	w_primary = GetLoadoutItem( "primary" );
	w_secondary = GetLoadoutItem( "secondary" );
	level.player TakeWeapon( w_primary );
	level.player TakeWeapon( w_secondary );
	level.player GiveWeapon( "scar_dualoptic_silencer_sp" );
	level.player GiveWeapon( "m32_titus_sp" );
	level.player SwitchToWeapon( "scar_dualoptic_silencer_sp" );
	
	//if the player has a silenced weapon tell him he can sneak, otherwise tell him it will go hot
	if( player_has_silenced_weapon() )
	{
		level.harper thread say_dialog( "Harper: Section take point.  We go silent or hot, your choice." );
	}
	else
	{
		level.harper thread say_dialog( "Harper: Too many out there, we'll have to go hot. Take the first shot." );
	}

	//end of intro save
	autosave_by_name( "camo_battle" );
	
	//start AI from the animation into patrols
	camo_patrol( "lz_patroller_1", "intro_patrol_left" );
	camo_patrol( "lz_patroller_2", "intro_patrol_right" );
	camo_patrol( "lz_invisible_patroller", "intro_patrol_left_camo" );
	
	//move up squad carefully if the player is maintaining stealth
	level thread camo_battle_friendly_stealth_move();
	
	n_camo_aigroup_size = get_ai_group_count( "camo_battle_main" );
	
	//color trigger use conditions
	use_trigger_on_group_count( "camo_battle_main", "camo_harper_jump_down", n_camo_aigroup_size - 2 );
	use_trigger_on_group_count( "camo_battle_main", "lift_patrol_start", n_camo_aigroup_size - 3 );
	use_trigger_on_group_count( "camo_battle_main", "camo_salazar_jump_down", n_camo_aigroup_size - 5 );
	use_trigger_on_group_count( "camo_battle_main", "camo_battle_middle", n_camo_aigroup_size - 7 );
	
	level thread camo_battle_move_up_final();

	//settings for stealth to be easier given extreme weather	
	wait 2;
	array_thread( GetAIArray( "axis" ), ::camo_battle_stealth_assist );
	level thread camo_stealth_positive_listener();
	camo_battle_stealth_settings();
	
	//flag set on a color trigger at the base of the switchback or elevator
	flag_wait( "player_reached_switchback" );
	
	//makes the heroes move fast to the helipad area
	use_trigger_on_group_count( "lift_top", "obj_helipad", 1, true );
		
	// see if the player was able to stealth up until this point
	if( !flag( "ruins_stealth_over" ) )
	{
		spawn_manager_kill( "sm_camo_break_stealth" );
		
		//notify for challenge and end reinforcement function
		level notify( "stealth_successful" );
		flag_set( "ruins_stealth_over" );
		level thread camo_battle_stealth_success_vo();
	}
	
	//disable stealth behavior on player for the rest of the level
	level notify( "_stealth_stop_stealth_logic" );
}

camo_battle_stealth_success_vo()
{
	level.salazar say_dialog( "sala_something_triggered_0" );	
	wait 1;
	level.player say_dialog( "sect_the_pmcs_must_have_b_0" );
}

camo_battle_cleanup_anims()
{
	delete_scene( "cliff_intro", true );
	
	delete_scene( "cliff_swing_1_idle", true );
	delete_scene( "cliff_swing_1", true );
	delete_scene( "cliff_swing_1_fail", true );
	
	delete_scene( "cliff_swing_2_idle", true );
	delete_scene( "cliff_swing_2", true );
	delete_scene( "cliff_swing_2_fail", true );
	
	delete_scene( "cliff_swing_3_idle", true );
	delete_scene( "cliff_swing_3", true );
	delete_scene( "cliff_swing_3_fail", true );
	
	delete_scene( "cliff_swing_4_idle", true );
	delete_scene( "cliff_swing_4", true );
	delete_scene( "cliff_swing_4_fail", true );
	
	delete_scene( "cliff_swing_5_idle", true );
	delete_scene( "cliff_swing_5", true );
	delete_scene( "cliff_swing_5_fail", true );

	delete_scene( "cliff_swing_6_idle", true );
	delete_scene( "cliff_swing_6_player", true );
	delete_scene( "cliff_swing_6", true );
}

//waits for all the initial group to be killed and all but one of the reinforcements
camo_battle_move_up_final()
{
	//wait until all the enemies in the area are killed
	waittill_ai_group_cleared( "camo_battle_main" );
	
	//additional check if stealth was broken to check for alive reinforcements
	if( flag( "ruins_stealth_over" ) )
	{
		waittill_ai_group_count( "camo_broke_stealth", 1 );
	}
	
	//use the color trigger to send the squad up the switchbacks
	trigger_use( "camo_battle_switchbacks" );
}

//self is an enemy
#define HELP_KILL_DIST 250
camo_battle_stealth_assist()
{
	level endon( "ruins_stealth_over" );
	self endon( "assisted_kill" );
	
	self waittill( "death", attacker );
	if( IsPlayer( attacker ) )
	{
		ai_close = get_closest_ai( self.origin, "axis" );
		if( IsDefined( ai_close ) && DistanceSquared( self.origin, ai_close.origin ) < ( HELP_KILL_DIST * HELP_KILL_DIST ) )
		{
			wait RandomFloatRange( 0.4, 0.8 );
			MagicBullet( "scar_dualoptic_silencer_sp", ai_close.origin + ( 0, 0, 80 ), ai_close GetEye(), level.harper );
			ai_close notify( "assisted_kill" );
			if( cointoss() )
			{
				level.harper thread say_dialog( "Harper: Other one is mine." );
			}
			else
			{
				level.salazar thread say_dialog( "Salazar: I got him. Nice one Section." );
			}
		}
		else
		{
			level notify( "positive_kill" );
		}
	}
}

//says a positive reinforcement of a kill, threaded to avoid multiple message on same frame kills
camo_stealth_positive_listener()
{
	level endon( "ruins_stealth_over" );
	
	while( 1 )
	{
		level waittill( "positive_kill" );
		if( cointoss() )
		{
			level.harper thread say_dialog( "Harper: Good kill." );
		}
		else
		{
			level.salazar thread say_dialog( "Salazar: Nice one Section" );
		}
		wait 1;
	}	
}

//self is an enemy in stealth
camo_stealth_loop()
{
	s_align = getstruct( "camo_battle_intro", "targetname" );
	n_index = self.script_int;
	
	s_align maps\_stealth_logic::stealth_ai_idle_and_react( self, "camo_stealth_loop_" + n_index, "camo_stealth_react_" + n_index );
}

//wrapper for the patrol function that grabs an enemy with his noteworthy and checks if he is alive
camo_patrol( str_targetname, str_patrol_name )
{
	ai_guy = get_ai( str_targetname + "_ai", "targetname" );
	ai_guy set_ignoreall( false );
	if( IsDefined( ai_guy ) && IsAlive( ai_guy ) )
	{
		ai_guy thread maps\_patrol::patrol( str_patrol_name );
	}
}

//running at the start to set when the squad is discovered
#define CAMO_BACKUP_TIME 8
camo_battle_stealth_watch()
{
	level endon( "stealth_successful" );
	
	flag_wait( "_stealth_spotted" );
	flag_set( "ruins_stealth_over" );
	
	//don't want reinforcements to show up immediately
	wait CAMO_BACKUP_TIME;	
	
	spawn_manager_enable( "sm_camo_break_stealth" );
}

camo_battle_friendly_stealth()
{
	self set_ignoreme( true );
	self set_ignoreall( true );
	self change_movemode( "cqb" );
		
	flag_wait( "predator_intro_scene_done" );
	
	self disable_ai_color();
	
	flag_wait( "ruins_stealth_over" );
	
	self reset_movemode();
	self set_ignoreme( false );
	self set_ignoreall( false );
	self enable_ai_color();
	
	self monsoon_hero_rampage( true );
}

camo_battle_friendly_stealth_move()
{
	level endon( "_stealth_spotted" );
	level endon( "_stealth_alert" );
	
	wait 10;

	//move Harper up and kill enemy if alive
	nd_goal = GetNode( "stealth_harper_move", "targetname" );
	level.harper SetGoalNode( nd_goal );
	level.harper waittill( "goal" );
	ai_guy = get_ai( "lz_patroller_2_ai", "targetname" );
	if( IsDefined( ai_guy ) && IsAlive( ai_guy ) )
	{
		level.harper shoot_and_kill( ai_guy, 2 );
	}
	
	wait 20; 

	ai_guy = get_ai( "lz_invisible_patroller_ai", "targetname" );
	if( IsDefined( ai_guy ) && IsAlive( ai_guy ) )
	{
		level.crosby shoot_and_kill( ai_guy );
	}
	
	wait 10;
	
	nd_goal = GetNode( "stealth_salazar_move", "targetname" );
	level.salazar SetGoalNode( nd_goal );
	
	wait 5;
	
	nd_goal = GetNode( "stealth_crosby_move", "targetname" );
	level.crosby SetGoalNode( nd_goal );
}

camo_intro_stealth_settings()
{
	//these values represent the BASE huristic for max visible distance base meaning 
	//when the character is completely still and not turning or moving
	//HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]	= 2;
	hidden[ "crouch" ]	= 2;
	hidden[ "stand" ]	= 2;
	
	//ALERT levels are when the same AI has sighted the same enemy twice OR found a body	
	alert = [];
	alert[ "prone" ]	= 140;
	alert[ "crouch" ]	= 900;
	alert[ "stand" ]	= 1500;

	//SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	//distance they can see you is still limited by these numbers because of the assumption that
	//you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	= 512;
	spotted[ "crouch" ]	= 5000;
	spotted[ "stand" ]	= 8000;
	
	maps\_stealth_logic::system_set_detect_ranges( hidden, alert, spotted );
}

camo_battle_stealth_settings()
{
	//these values represent the BASE huristic for max visible distance base meaning 
	//when the character is completely still and not turning or moving
	//HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]	= 70;
	hidden[ "crouch" ]	= 256;
	hidden[ "stand" ]	= 600;
	
	//ALERT levels are when the same AI has sighted the same enemy twice OR found a body	
	alert = [];
	alert[ "prone" ]	= 140;
	alert[ "crouch" ]	= 600;
	alert[ "stand" ]	= 800;

	//SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	//distance they can see you is still limited by these numbers because of the assumption that
	//you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	= 512;
	spotted[ "crouch" ]	= 5000;
	spotted[ "stand" ]	= 8000;
	
	maps\_stealth_logic::system_set_detect_ranges( hidden, alert, spotted );
	
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ][ "hidden" ] 	= 128;
}

camo_battle_lift()
{
	trigger_wait( "lift_patrol_start" );
	
	//spawn the guard for the lift
	ai_lift_guard = GetEnt( "lift_guard", "targetname" ) spawn_ai( true );
	ai_lift_guard thread camo_battle_stealth_assist();
	
	//patrol was exited early if stealth was broken, force him to the lift
	if( flag( "ruins_stealth_over" ) )
	{
		//allow for stealth logic to die which is setting values on the AI
		wait 0.05;
		ai_lift_guard force_goal( GetNode( "lift_patrol_goal", "targetname" ), 32, false );
	}
	else
	{
		//otherwise he should patrol to the lift
		ai_lift_guard maps\_patrol::patrol( "lift_patrol_goal" );
	}
	
	if( flag( "ruins_stealth_over" ) )
	{
		level.salazar thread say_dialog( "Salazar: They are coming down the lift!", 4 );
	}
	else
	{
		level.salazar thread say_dialog( "Salazar: Careful, one is coming down the lift.", 4 );
	}
	
	outside_lift_move_down();		
		
	//if stealth still isn't broken have him patrol to meet with another guard
	if( !flag( "ruins_stealth_over" ) )
	{
		ai_lift_guard patrol( "lift_patrol_end" );
	}
	
	level notify( "player_used_outside_lift" );
	spawn_manager_enable( "sm_lift_top" );
}

////////////////////////////////
//                            //
//     HELIPAD BATTLE         //
//                            //
////////////////////////////////

helipad_battle_main()
{
	add_spawn_function_veh( "heli_main", ::heli_main_think );
	add_spawn_function_veh( "heli_turret", ::heli_turret_think );
	add_spawn_function_veh( "heli_killed", ::heli_killed_think );
	
	trigger_use( "trigger_spawn_helicopters" );
	spawn_manager_enable( "sm_heli_guards" );
	
	//middle rain	
	set_rain_level( 5 );

	flag_wait( "player_reached_helipad" );
		
	level thread helipad_battle_intro_vo();
	
	//save at the helipad	
	autosave_by_name( "helipad" );	
	
	array_func( get_heroes(), ::disable_ai_color );
	
	level.salazar thread force_goal( GetNode( "helipad_goal_salazar", "targetname" ), 32, true );
	wait 0.5;
	level.harper thread force_goal( GetNode( "helipad_goal_harper", "targetname" ), 32, true );
	wait 1.5;
	level.crosby thread force_goal( GetNode( "helipad_goal_crosby", "targetname" ) );
		
	waittill_multiple_ents( level.harper, "goal", level.salazar, "goal" );
	flag_set( "squad_reached_helipad" );

	wait 1;
	
	level thread run_scene( "salazar_shoots_heli" );
	
	wait 5;
	
	array_func( get_heroes(), ::enable_ai_color );
	
	//setup color logic
	use_trigger_on_group_count( "group_helipad_front", "color_helipad_front", 1, true );
	use_trigger_on_group_count( "group_helipad_final", "color_helipad_final", 2, true );
		
	flag_wait( "squad_reached_outer_ruins" );
	
	//remove any leftover color triggers in the area
	a_t_color = GetEntArray( "helipad_color_trigger", "script_noteworthy" );
	foreach( color in a_t_color )
	{
		color Delete();
	}
	
	//save before the heli fight
	autosave_by_name( "outer_ruins" );
	
	flag_wait( "player_reached_outer_ruins" );
	
	//save as the player reaches the archway
	autosave_by_name( "heli_down" );

}

helipad_battle_intro_vo()
{
	level.harper say_dialog( "harp_dead_ahead_choppers_0" );
	wait 0.8;
	level.player say_dialog( "sect_shit_we_can_t_let_0" );
	wait 0.4;
	
	flag_wait( "squad_reached_helipad" );
	
	level.harper say_dialog( "harp_salazar_use_the_tit_0" );
	wait 1;
	level.salazar say_dialog( "sala_on_it_0" );
	wait 4;
	level.salazar say_dialog( "sala_that_chopper_is_toas_0" );
	
	wait 5;
	level.harper say_dialog( "harp_chopper_s_struggling_0" );
	wait 0.5;
	level.harper say_dialog( "harp_stay_on_it_0" );
	wait 1;
	level.player say_dialog( "sect_out_of_range_of_the_0" );
	
	flag_wait( "heli_retreat_to_ruins" );
	
	level.harper say_dialog( "harp_chopper_s_pulling_ba_0" );
	wait 0.4;
	level.harper say_dialog( "harp_it_s_moving_deeper_i_0" );

	flag_set( "helipad_battle_intro_vo_done" );
}

//called from a notetrack in salazar's animation in scene "salazar_shoots_heli"
helipad_battle_salazar_titus( ai_salazar )
{
	vh_heli = GetEnt( "heli_killed", "targetname" );
	maps\_titus::magic_bullet_titus( ai_salazar GetTagOrigin( "tag_flash" ), vh_heli.origin + ( 0, 0, -40 ) , ai_salazar );
	wait 3;
	flag_set( "salazar_destroyed_heli" );
	
	//save after the heli is taken out
	autosave_by_name( "outer_ruins" );
}

//self is the helicopter that can be hacked to use it's turret	
#define HELI_TURRET_FADE_TIME 1.3
heli_turret_think()
{
	level endon( "seal_ruins" );
	
	self SetRotorSpeed( 0 );
	self HidePart( "tag_main_rotor_static" );
	self heli_weapons_bay_close();
	self veh_toggle_tread_fx( false );
	self veh_magic_bullet_shield( true );
	
	//create the use trigger for the perk
	t_use = GetEnt( "helicopter_use_trigger", "targetname" );
	t_use SetHintString( &"MONSOON_LIFT_PROMPT" );
	t_use SetCursorHint( "HINT_NOICON" );
	t_use trigger_off();
	
	level.player waittill_player_has_intruder_perk();
	
	t_use trigger_on();	
	set_objective( level.OBJ_INTRUDER, t_use, "interact" );
	
	t_use thread heli_turret_vo();
		
	t_use waittill( "trigger", player );
	t_use trigger_off();
	self LinkTo( t_use );
	
	set_objective( level.OBJ_INTRUDER, t_use, "remove" );	
	
	n_objective_dist = GetDvar( "cg_objectiveIndicatorNearFadeDist" );
	player SetClientDvar( "cg_objectiveIndicatorNearFadeDist", 10000 );
	level.weather_wind_shake = false;
			
	flag_set( "intruder_perk_used" );
	
	//record where the player was and looking
	v_player_origin = player.origin;
	v_player_angles = player GetPlayerAngles();
	
	GetEnt( "heli_retreat_cover", "targetname" ) delay_thread( 1, ::spawn_ai, true );
		
	run_scene( "intruder_perk" );
	
	//GET ON TURRET
	screen_fade_out( 0 );
	
	self SetTargetEntity( GetEnt( "heli_retreat", "targetname" ), (0,0,70), 0 );
	
	//wait for the turret to move towards the target
	wait 0.2;
	
	self MakeVehicleUsable();
	self UseVehicle( player, 0 );
	
	run_scene_first_frame( "heli_turret_retreat" );
	
	player hide_hud();
	player EnableInvulnerability();
	player StopShellShock();
	player DisableUsability();
	self veh_magic_bullet_shield( false );
	
	LUINotifyEvent( &"hud_update_vehicle" );
	self thread maps\_vehicle_death::vehicle_damage_filter( "firestorm_turret" );
	screen_fade_in( HELI_TURRET_FADE_TIME );
	
	level thread heli_turret_challenge_watch();
	level thread heli_turret_events();
	player thread heli_turret_early_exit();
	player waittill_any( "early_exit", "vehicle_destroyed" );
	
	//GET OFF TURRET
	screen_fade_out( 0 );
	player EnableUsability();
	self UseBy( player );
	self MakeVehicleUnusable();
	self Unlink();
	player show_hud();
	player DisableInvulnerability();
	
	t_use Delete();
	
	//wait for the player to get off the vehicle
	wait 0.2;
	
	//place the player back where they called in the run
	anchor = Spawn( "script_origin", player.origin );
	player PlayerLinkToAbsolute( anchor );
	anchor MoveTo( v_player_origin, 0.05 );
	anchor waittill( "movedone" );
	player UnLink();
	player SetPlayerAngles( v_player_angles );
	anchor Delete();
	
	LUINotifyEvent( &"hud_update_vehicle" ); 
	
	screen_fade_in( HELI_TURRET_FADE_TIME );
	
	flag_set( "player_off_turret" );
	level.weather_wind_shake = true;
	player SetClientDvar( "cg_objectiveIndicatorNearFadeDist", n_objective_dist );
}

heli_turret_vo()
{
	level endon( "player_off_turret" );
		
	b_hint_vo = true;
	while( !flag( "intruder_perk_used" ) )
	{
		if( Distance2D( self.origin, level.player.origin ) < 500 )
		{
			if( flag( "helipad_battle_intro_vo_done" ) && b_hint_vo )
			{
				b_hint_vo = false;
				level.harper say_dialog( "harp_section_hack_the_w_0" );
			}
		}
		wait 0.05;
	}
	
	wait 5;
	
	if( flag( "helipad_battle_intro_vo_done" ) )
	{
		level.harper say_dialog( "harp_give_these_bastards_0" );
	}
}

heli_turret_events()
{
	run_scene( "heli_turret_retreat" );
	
	trigger_use( "sm_heli_turret" );
	
	flag_wait( "player_off_turret" );
	
	spawn_manager_kill( "sm_heli_turret" );
}

heli_turret_challenge_watch()
{
	while( !flag( "player_off_turret" ) )
	{
		a_enemies = GetAIArray( "axis" );
		foreach( enemy in a_enemies )
		{
			if( !IsDefined( enemy.watched ) )
			{
				enemy.watched = true;
				enemy thread heli_turret_challenge_watch_think();
			}
		}
		wait 1;
	}
}

heli_turret_challenge_watch_think()
{
	level endon( "player_off_turret" );
	
	self waittill( "death", undefined, undefined, str_weapon );
	if( IsDefined( str_weapon ) && str_weapon == "future_minigun_enemy_pilot" )
	{
		level notify( "turret_death" );
	}
}

heli_turret_early_exit()
{
	self endon( "vehicle_destroyed" );
	
	while( IsAlive( self ) )
	{
		if( self use_button_held() )
		{
			self notify( "early_exit" );
			return;
		}
		wait 0.05;
	}
}

//self is the helicopter that Salazar takes out with the Titus6
heli_killed_think()
{
	self SetRotorSpeed( 0 );
	self heli_landing_gear_down();
	self veh_toggle_tread_fx( false );
	self veh_magic_bullet_shield( true );
		
	flag_wait( "player_reached_helipad" );
	
	//in case this flag is set in the same frame from the skipto
	wait 0.05;
	
	self SetRotorSpeed( 0.8 );
	
	wait 8;
	
	self veh_toggle_tread_fx( true );
	
	flag_wait( "salazar_destroyed_heli" );
	
	//script_nocorpse disables helicopter crash path
	self.script_nocorpse = true;
	self veh_magic_bullet_shield( false );
	self notify( "death" );
	self SetRotorSpeed( 0 );
	self veh_toggle_tread_fx( false );
	
	a_nearby_enemies = get_ai_group_ai( "helipad_near" );
	foreach( enemy in a_nearby_enemies )
	{
		enemy die();
	}
}

////////////////////////////////
//                            //
//       OUTER RUINS          //
//                            //
////////////////////////////////

outer_ruins_main()
{
	//heavy rain	
	set_rain_level( 4 );
	
	level.salazar thread outer_ruins_squad_think();
	level.crosby thread outer_ruins_squad_think();
	level.harper thread outer_ruins_harper_think();
	
	level thread outer_ruins_vo();
	
	spawn_manager_enable( "sm_heli_battle" );
	flag_wait( "helicopter_destroyed" );
	spawn_manager_kill( "sm_heli_battle" );
	
	//delete the color triggers being used by the helicopter	
	a_triggers = GetEntArray( "heli_color_trigger", "targetname" );
	foreach( t_color in a_triggers )
	{
		t_color Delete();
	}

	//save after the helicopter is taken down
	autosave_by_name( "heli_down" );
}

outer_ruins_vo()
{
	level.player say_dialog( "sect_shit_2" );
	wait 0.5;
	level.harper say_dialog( "harp_chopper_s_still_figh_0" );
	wait 1;
	level.player say_dialog( "sect_prep_an_emp_grenade_0" );
	wait 1.5;
	level.harper say_dialog( "harp_draw_its_fire_you_0" );
	
	add_vo_to_nag_group( "emp_prep", level.player, "sect_dammit_4" ); 		 		//Dammit
	add_vo_to_nag_group( "emp_prep", level.player, "sect_too_close_0" ); 		 	//Too close!
	add_vo_to_nag_group( "emp_prep", level.player, "sect_you_gotta_hurry_it_u_0" ); //You gotta hurry it up, Harper!
	add_vo_to_nag_group( "emp_prep", level.harper, "harp_i_m_working_on_it_0" ); 	//I'm working on it!!!
	add_vo_to_nag_group( "emp_prep", level.player, "sect_come_on_harper_0" ); 		//Come on, Harper!
	add_vo_to_nag_group( "emp_prep", level.harper, "harp_almost_there_0" ); 		//Almost there!
	add_vo_to_nag_group( "emp_prep", level.player, "sect_dammit_harper_0" ); 		//Dammit, Harper!!
	add_vo_to_nag_group( "emp_prep", level.harper, "harp_i_m_on_it_1" ); 			//I'm on it!
	add_vo_to_nag_group( "emp_prep", level.player, "sect_pull_your_finger_out_0" ); //Pull your finger out of your ass before one of these rockets nails me!	
	
	level thread start_vo_nag_group_flag( "emp_prep", "player_emp_ready", 4, 3, true, 1 );
	
	flag_wait( "player_emp_ready" );
	
	delete_vo_nag_group( "emp_prep" );
}

outer_ruins_squad_think()
{
	self SetEntityTarget( level.vh_heli, 0.6 );
	self disable_pain();
	
	flag_wait( "helicopter_destroyed" );
	
	self ClearEntityTarget();
	self enable_pain();
}

#define N_PREP_TIME	25
outer_ruins_harper_think()
{
	level.harper set_ignoreme( true );
	level.harper idle_at_cover( true );
	level.harper disable_pain();
	
	set_objective( level.OBJ_DESTROY_HELI, self, "defend" );
	
	run_scene( "harper_emp_intro" );
	level thread run_scene( "harper_emp_loop" );
		
	wait N_PREP_TIME;
	
	level.harper thread say_dialog( "Harper: It's ready! Section get over here!" );
	flag_set( "player_emp_ready" );
		
	t_equip = GetEnt( "trigger_equip_emp", "targetname" );
	set_objective( level.OBJ_DESTROY_HELI, t_equip, "breadcrumb" );
	t_equip waittill( "trigger" );
	flag_set( "player_has_emp" );
	set_objective( level.OBJ_DESTROY_HELI, level.vh_heli, "destroy" );
	t_equip Delete();
	
	level.player EnableInvulnerability();
	run_scene( "equip_emp" );
	level.player DisableInvulnerability();
	
	autosave_by_name( "equipped_emp" );
	
	level.player thread outer_ruins_player_emp();
		
	flag_wait( "helicopter_destroyed" );
	
	set_objective( level.OBJ_DESTROY_HELI, undefined, "done" );
	
	level.harper set_ignoreme( false );
	level.harper idle_at_cover( false );
	level.harper enable_pain();
}

#define N_EMP_DETONATE	0.5
outer_ruins_player_emp()
{
	screen_message_create( &"MONSOON_PROMPT_EMP_THROW" );
	
	level.harper thread say_dialog( "harp_hit_it_0" );
	level.player thread take_and_giveback_weapons( "grenade_fired" );
	level.player GiveWeapon( "emp_grenade_monsoon_sp" );
	level.player waittill( "grenade_fire", e_grenade );
	
	screen_message_delete();
	
	wait N_EMP_DETONATE;
	
	level thread outer_ruins_emp( e_grenade.origin );
	e_grenade Delete();;
	
	//give weapons back
	level.player notify( "grenade_fired" );
}

outer_ruins_emp( v_origin )
{
	level notify( "emp" );
	
	PlayFX( getfx( "emp_detonate" ), v_origin );
	//SOUND - Shawn J
	playsoundatposition ("evt_emp_bomb", v_origin);
	
	wait 0.5;
	
	//grab the dynamic lights and order them closest to farthest
	a_lights = GetEntArray( "emp_light", "targetname" );
	a_m_lights = GetEntArray( "emp_light_model", "script_noteworthy" );
	a_m_lights = sort_by_distance( a_m_lights, v_origin );
	a_m_lights = array_reverse( a_m_lights );
	foreach( m_light in a_m_lights )
	{
		//play spark FX for each light
		switch( m_light.model )
		{
			case "p6_stadium_light_pole":
				m_light Detach( "p6_stadium_light_pole_on", "tag_origin" );
				m_light Attach( "p6_stadium_light_pole_off", "tag_origin" );
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_fx_light1" );
				wait 0.05;
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_fx_light2" );
				wait 0.05;
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_fx_light3" );
				wait 0.05;
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_fx_light4" );
				break;
			case "p6_container_yard_light":
				m_light Detach( "p6_container_yard_light_on", "tag_origin" );
				m_light Attach( "p6_container_yard_light_off", "tag_origin" );
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_light1" );
				wait 0.05;
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_light2" );
				break;
			case "ctl_light_spotlight_generator":
				m_light Detach( "ctl_light_spotlight_generator_on", "tag_origin" );
				m_light Attach( "ctl_light_spotlight_generator_off", "tag_origin" );
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_fx_bulb_1" );
				wait 0.05;
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_fx_bulb_2" );
				wait 0.05;
				m_light play_fx( "light_single_burst", undefined, undefined, undefined, true, "tag_fx_bulb_3" );
				break;
			case "ctl_spotlight_modern_3x":
				m_light Detach( "ctl_spotlight_modern_3x_on", "tag_origin" );
				m_light Attach( "ctl_spotlight_modern_3x_off", "tag_origin" );
				m_light play_fx( "light_3x_burst", undefined, undefined, undefined, true, "tag_light" );
				break;
		}
		
		//turn off the light's FX
		m_light notify( "turn_off" );
		
		//grab the closest scripted light to this model
		e_light = getclosest( m_light.origin, a_lights );
		e_light SetLightIntensity( 0 );
		
		wait 0.25;
	}
	
	level.player hide_hud();
}

////////////////////////////////
//                            //
//       INNER RUINS          //
//                            //
////////////////////////////////

inner_ruins_main()
{
	//heavy rain	
	set_rain_level( 5 );
	
	//move the squad forward
	delay_thread( 3.0, ::trigger_use, "post_heli_colors" );
		
	array_func( get_heroes(), ::monsoon_hero_rampage, true );
	
	level thread inner_ruins_vo();
	
	level thread inner_ruins_destruction_right();
	level thread inner_ruins_destruction_left();
	level thread inner_ruins_wounded_enemies();
	
	//color trigger use conditions
	use_trigger_on_group_clear( "harper_move_inner_ruins_1", "harper_move_inner_ruins_1" );
	use_trigger_on_group_count( "harper_move_inner_ruins_2", "harper_move_inner_ruins_2", 1 );
	use_trigger_on_group_count( "salazar_move_inner_ruins_1", "salazar_move_inner_ruins_1", 2 );
	use_trigger_on_group_count( "salazar_move_inner_ruins_2", "salazar_move_inner_ruins_2", 1 );
	use_trigger_on_group_clear( "salazar_move_inner_ruins_3", "salazar_move_inner_ruins_3" );
	use_trigger_on_group_clear( "move_inner_ruins_final", "move_inner_ruins_final" );
	
	//set on the last color trigger once the enemy group "move_inner_ruins_final" is cleared
	flag_wait( "squad_reached_temple_entrance" );
	
	//clear remaining enemies
	array_thread( GetAIArray( "axis" ), ::die );
	
	//remove any leftover color triggers in the area
	a_t_color = GetEntArray( "inner_ruins_color_trigger", "script_noteworthy" );
	foreach( color in a_t_color )
	{
		color Delete();
	}
	
	//save at the temple door
	autosave_by_name( "at_temple_door" );
	
	//grab the damage trigger at the door and run it's logic
	t_door_damage = GetEnt( "temple_doors_trigger", "targetname" );
	t_door_damage thread inner_ruins_door_think();
	
	//each hero has his own animations to play
	level.crosby thread inner_ruins_crosby();
	level.salazar thread inner_ruins_salazar();
	level.harper thread inner_ruins_harper();
	
	//wait for all heroes to be in their position
	array_wait( get_heroes(), "in_position" );
	
	//squad is in position wait for player to have been in position
	flag_wait( "player_reached_temple_entrance" );
	
	//turn the glasses back on from the EMP
	maps\_glasses::play_bootup();
	level.player delay_thread( 1.0, ::show_hud );
	
	if( !flag( "ruins_door_destroyed" ) )
	{
		level thread inner_ruins_destroy_choice();
	}
	
	//set by the door logic function once it is destroyed
	flag_wait( "ruins_door_destroyed" );	
	
	//calm the heroes down
	array_func( get_heroes(), ::monsoon_hero_rampage, false );
}

#define PLAYER_DESTROY_DOOR_TIME	5
inner_ruins_destroy_choice()
{
	level endon( "ruins_door_destroyed" );
	
	//if the player has the titus Harper tells him to use it
	if( player_has_titus_6_weapon() )
	{
		level.harper thread say_dialog( "Harper: Section use your Titus on the door." );
		
		run_scene( "harper_door_player" );
		level thread run_scene( "harper_door_loop" );
		
		wait PLAYER_DESTROY_DOOR_TIME;
		
		//player took too long
		level thread inner_ruins_harper_shoot_door();
	}
	//if the player does not have the weapon Harper just uses his
	else
	{
		level thread inner_ruins_harper_shoot_door();			
	}
}

inner_ruins_harper_shoot_door()
{
	level endon( "ruins_door_destroyed" );
	
	level.harper thread say_dialog( "harp_stand_back_0" );
	run_scene( "harper_door_shoots" );
	level thread run_scene( "harper_door_loop" );
}

//called from a notetrack in harper's animation in scene "harper_door_shoots"
inner_ruins_harper_titus( ai_harper )
{
	maps\_titus::magic_bullet_titus( ai_harper GetTagOrigin( "tag_flash" ), GetEnt( "temple_doors", "targetname" ).origin, ai_harper );
}

inner_ruins_vo()
{
	level endon( "ruins_door_destroyed" );
	
	flag_wait( "helicopter_destroyed" );
	
	wait 4;
	level.player say_dialog( "sect_okay_let_s_get_mo_0" );
	
	flag_wait( "harper_door_intro_started" );
	level.salazar say_dialog( "sala_i_m_picking_up_signa_0" );
	wait 0.5;
	level.harper say_dialog( "harp_he_s_right_multipl_0" );
	wait 0.5;
	level.harper say_dialog( "harp_so_what_do_we_do_w_0" );
	wait 0.5;
	level.player say_dialog( "sect_we_go_through_it_0" );
	wait 0.5;
	level.harper say_dialog( "harp_alright_then_let_s_0" );
}

//self is a damage trigger
inner_ruins_door_think()
{
	//wait for the Titus to be the weapon that does damage to the trigger 
	//TODO find a more specific way to determine the weapon, currently only grenade splash will set it off
	do
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
	}
	while( !IsDefined( type ) || type != "MOD_GRENADE_SPLASH" );
		
	flag_set( "ruins_door_destroyed" );
	
	//end lightning early to stop exposure tweaks
	level notify( "_rain_drops" );
	
	//set squads new nodes to inside the ruins
	trigger_use( "trigger_color_ruins_interior" );
		
	//wall destruction FX
	exploder( 1000 );
	
	//rumble and shake!
	Earthquake( 0.8, 0.5, level.player.origin, 500 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );	
	
	m_door_pristine = GetEnt( "temple_doors", "targetname" );
	m_door_destroyed = GetEnt( "temple_doors_destroyed", "targetname" );
	
	m_door_pristine NotSolid();
	m_door_pristine ConnectPaths();
	m_door_pristine Delete();
	m_door_destroyed Show();
	
	self Delete();
}

inner_ruins_salazar()
{
	self disable_ai_color();
	
	self SetGoalNode( GetNode( "salazar_start_temple_door", "targetname" ) );
	self waittill( "goal" );
	self notify( "in_position" );
	wait 0.5;
	
	if( !flag( "ruins_door_destroyed" ) )
	{
		level thread run_scene( "salazar_door_loop" );
		flag_wait( "ruins_door_destroyed" );
		end_scene( "salazar_door_loop" );
		run_scene( "salazar_enter_door" );
	}
	
	self enable_ai_color();
}

inner_ruins_crosby()
{
	self disable_ai_color();
	
	self SetGoalNode( GetNode( "crosby_start_temple_door", "targetname" ) );
	self waittill( "goal" );
	self notify( "in_position" );
	wait 0.5;
	
	if( !flag( "ruins_door_destroyed" ) )
	{
		level thread run_scene( "crosby_door_loop" );
		flag_wait( "ruins_door_destroyed" );
		end_scene( "crosby_door_loop" );
		run_scene( "crosby_enter_door" );
	}
	
	self enable_ai_color();
}

inner_ruins_harper()
{
	self disable_ai_color();
	
	self SetGoalNode( GetNode( "harper_start_temple_door", "targetname" ) );
	self waittill( "goal" );
	wait 0.5;
	self thread inner_ruins_harper_destroy_watch();
	run_scene( "harper_door_intro" );
	self notify( "in_position" );
	
	if( !flag( "ruins_door_destroyed" ) )
	{
		level thread run_scene( "harper_door_loop" );
		flag_wait( "ruins_door_destroyed" );
		end_scene( "harper_door_loop" );
		run_scene( "harper_enter_door" );
	}
	
	self enable_ai_color();
}

//threaded during Harper's approach anim in case I need to end it early
inner_ruins_harper_destroy_watch()
{
	self endon( "in_position" );
	wait 0.05;
	flag_wait( "ruins_door_destroyed" );
	end_scene( "harper_door_intro" );
}

inner_ruins_destruction_right()
{
	m_ruin_p = GetEnt( "ruins_pagoda_right_pristine", "targetname" );
	m_ruin_d = GetEnt( "ruins_pagoda_right_destroyed", "targetname" );
	
	trigger_wait( "trigger_ruins_right_destroyed" );
	
	//start fx
	exploder( 850 );
	
	wait 1;
	
	//rumble and shake!
	Earthquake( 0.8, 0.5, level.player.origin, 500 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );	
	
	//m_ruin_d Show();
	m_ruin_p Delete();
	
	level notify( "fxanim_shrine_rt_start" );
		
	ai_in_ruin = get_ai( "ruin_collapse_right", "script_noteworthy" );
	if( IsDefined( ai_in_ruin ) && IsAlive( ai_in_ruin ) )
	{
		add_generic_ai_to_scene( ai_in_ruin, "ruin_collapse_death_right" );
		level thread run_scene( "ruin_collapse_death_right" );
	}
}

inner_ruins_destruction_left()
{
	trigger_wait( "trigger_ruins_left_destroyed" );
	
	//start fx
	exploder( 750 );
	
	//rumble and shake!
	Earthquake( 0.8, 0.5, level.player.origin, 500 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );	
	
	level notify( "fxanim_shrine_lft_mudslide_start" );
	m_shrub = GetEnt( "cliff_slide_left_shrub_1", "targetname" );
	m_shrub Delete();
	
	ai_in_ruin = get_ai( "ruin_collapse_left", "script_noteworthy" );
	if( IsDefined( ai_in_ruin ) && IsAlive( ai_in_ruin ) )
	{
		add_generic_ai_to_scene( ai_in_ruin, "ruin_collapse_death_left" );
		level thread run_scene( "ruin_collapse_death_left" );
	}
}

inner_ruins_destroy_left_temple( m_terrain )
{
	m_ruin_p = GetEnt( "ruins_pagoda_left_pristine", "targetname" );
	m_ruin_top_p = GetEnt( "ruins_pagoda_left_pristine_top", "targetname" );
	m_ruin_d = GetEnt( "ruins_pagoda_left_destroyed", "targetname" );
	
	level notify( "fxanim_shrine_lft_start" );
	m_ruin_p Delete();
	m_ruin_top_p Delete();
	
	//rumble and shake!
	Earthquake( 0.4, 3, level.player.origin, 500 );
	level.player PlayRumbleLoopOnEntity( "damage_light" );	
	wait 3;
	level.player StopRumble( "damage_light" );
}

inner_ruins_wounded_enemies()
{
	add_spawn_function_group( "post_heli_death_spawner", "script_noteworthy", ::inner_ruins_wounded_think );
	
	a_s_pos = getstructarray( "post_heli_death", "script_noteworthy" );
	foreach( s_pos in a_s_pos )
	{
		level thread run_scene( s_pos.targetname );
	}
}

inner_ruins_wounded_think()
{
	self endon( "death" );
	
	self magic_bullet_shield();
	self set_ignoreme( true );
	self.forceragdollimmediate = true;
	
	flag_wait( "helicopter_crash_done" );
	
	self stop_magic_bullet_shield();
	
	wait RandomFloatRange( 15.0, 20.0 );
	
	self die();
}

////////////////////////////////
//                            //
//       RUINS INTERIOR       //
//                            //
////////////////////////////////
	
ruins_interior_main()
{
	array_thread( get_heroes(), ::change_movemode, "cqb" );
	
	level thread ruins_interior_seal();
	level thread ruins_interior_vo();
	
	flag_wait( "player_in_ruins_interior" );
	
	trigger_use( "trig_salazar_lab_entrance" );
	
	flag_wait( "monsoon_gump_interior" );
	
	//save after the helicopter is taken down
	autosave_by_name( "sealed_in_temple" );
}

ruins_interior_vo()
{
	wait 3;
	level.player say_dialog( "sect_watch_your_step_fl_0" );
	
	flag_wait( "seal_ruins" );
	
	wait 2;
	level.harper say_dialog( "harp_no_turning_back_now_0" );
}

//close the path behind the player once he is far enough into the interior
ruins_interior_seal()
{
	
	//placed on a trigger around the turn in the interior
	flag_wait( "seal_ruins" );
	
	//turn off rain since the player will be inside from now on
	set_rain_level( 0 );
	
	//kill the wind inside
	SetSavedDvar( "wind_global_vector", "1 0 0" );	
	
	//move the destroyed blocker for the ruins
	trigger_on( "ruins_blocker", "targetname" );
	
	//rumble and shake!
	Earthquake( 0.4, 2, level.player.origin, 500 );
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	
	PlaySoundAtPosition ("evt_ruin_collapse", (6545, 53569, -493));
	level.player playsound( "evt_ruin_shake" );	
	
	wait 2;
	level.player StopRumble( "damage_light" );
	
	//use the lift outside after the flag "seal_ruins" is set to clean it up
	trigger_use( "lift_use_trigger" );
	
	//load the interior gump
	level thread load_gump( "monsoon_gump_interior" );
}