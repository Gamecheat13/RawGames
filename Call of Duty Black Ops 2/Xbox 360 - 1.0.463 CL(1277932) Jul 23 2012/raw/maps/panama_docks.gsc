#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_vehicle_aianim;
#include maps\panama_utility;
#include maps\_objectives;
#include maps\_turret;
#include maps\_dynamic_nodes;

#insert raw\maps\panama.gsh;

/* TODO
 * Jeep Ride
 * ---------
 * Get noriega in the passenger seat - linked currently, need anim
 * path pass
 * rumble pass
 * ai/vehicle/goalvolume placement pass
 * VO - Woods to Noriega "tell them to stand down"
 * 	- VO - Noriega to Woods "too late for that"
 * /
*/

//Sets up start for docks on skipto
skipto_docks()
{
	//level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	a_heroes = array( level.mason, level.noriega );
	
	flag_set( "movie_done" );
	skipto_teleport( "player_skipto_docks", a_heroes );
}

//Sets up start for sniper event in docks on skipto
skipto_sniper()
{
	level.mason = init_hero( "mason" );
	level.noriega = init_hero( "noriega" );
	a_heroes = array( level.mason, level.noriega );
	
	skipto_teleport( "player_skipto_sniper", a_heroes );
	
	e_sniper_turret = GetEnt( "barret_turret", "targetname" );
	e_sniper_turret Hide();
	e_sniper_turret MakeTurretUnusable();
	
	spawn_vehicles_from_targetname( "end_scene_vehicles" );
	
//	level.player TakeAllWeapons();
//	level.player GiveWeapon( "barretm82_sp" );
//	level.player SwitchToWeapon( "barretm82_sp" );
//	level.player DisableWeaponCycling();
//	level.player SetLowReady( true );
//	level.player AllowAds( true );
	
	//level thread start_fire_work();
	level thread kick_off_end_event();
	
}
kick_off_end_event()
{
	sniper_event();
	betrayed_event();
}


main()
{	
	//docks_setup();
	//docks_intro();
	//jeep_turret_event();	
	
	//level waittill( "movie_done" );
	flag_wait( "movie_done" );
	
	level thread dock_vo();
	
	
	jeep_intro_setup();
	jeep_intro_ride();
	
	elevator_ride();
	sniper_event();
	betrayed_event();
}


jeep_intro_setup()
{
	//turn off sniper trigger
	trigger_off( "sniper_turret_trigger", "targetname" );
	
	//Skybox transition
	maps\createart\panama3_art::docks();	

	//Setup elevator interior light	
	s_elevator_light_attach_marker = GetStruct( "elevator_light_attach_marker", "targetname" );
	m_elevator_light_attach_point = spawn_model( "tag_origin", s_elevator_light_attach_marker.origin, s_elevator_light_attach_marker.angles );
	m_elevator_light_attach_point LinkTo( GetEnt( "docks_elevator", "targetname" ), "tag_origin" );
	PlayFXOnTag( GetFX( "elevator_light" ), m_elevator_light_attach_point, "tag_origin" );
	
	//Setup collision brushes on elevator doors
//	m_docks_elevator = GetEnt( "docks_elevator", "targetname" );
//	GetEnt( "docks_elevator_door_collision_left1", "targetname" ) LinkTo( m_docks_elevator, "j_door_1" );
//	GetEnt( "docks_elevator_door_collision_right1", "targetname" ) LinkTo( m_docks_elevator, "j_door_2" );
//	GetEnt( "docks_elevator_door_collision_left2", "targetname" ) LinkTo( m_docks_elevator, "j_door_4" );
//	GetEnt( "docks_elevator_door_collision_right2", "targetname" ) LinkTo( m_docks_elevator, "j_door_3" );	
//	
	//Set elevator in starting position
	//run_scene_first_frame( "elevator_bottom_open" );

	//Hide sniper turret and keep player from using it through core control
	e_sniper_turret = GetEnt( "barret_turret", "targetname" );
	e_sniper_turret Hide();
	e_sniper_turret MakeTurretUnusable();	
	
	//Spawn vehicles at the end of the docks
	a_end_scene_vehicles = spawn_vehicles_from_targetname( "end_scene_vehicles" );
	
	//Prevent player from blowing up vehicles during sniper sequence
	foreach( vh_vehicle in a_end_scene_vehicles )
	{
		vh_vehicle GodOn();
	}	
}

docks_magic_rpg_setup()
{
	a_triggers = GetEntArray( "docks_rpg", "targetname" );
	array_thread( a_triggers, ::docks_magic_rpg_think );
}

docks_magic_rpg_think()
{
	self waittill( "trigger" );
	
	s_rpg_start = getstruct( self.target, "targetname" );
	s_rpg_end = getstruct( s_rpg_start.target, "targetname" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_rpg_start.origin, s_rpg_end.origin );
	
	self Delete();
}

//fuel_tank_damage_trigs() //self = damage trig
//{
////	self trigger_off();
////	
////	nd_spawn_container_pdf = GetVehicleNode( "spawn_container_pdf", "script_noteworthy" );
////	nd_spawn_container_pdf waittill( "trigger" );	
////	
////	self trigger_on();
//	
//	self waittill( "trigger" );
//
//	switch( self.script_noteworthy )
//	{
//		case "right_fuel_tanks":
//			//delete prestine fuel tanks
//			a_fuel_tanks_right = GetEntArray( "fuel_tanks_right", "targetname" );
//			foreach( fuel_tank in a_fuel_tanks_right )
//			{
//				fuel_tank Delete();
//			}
//			
//			//show damaged tanks
//			a_fuel_tanks_dmg_right = GetEntArray( "fuel_tanks_dmg_right", "targetname" );
//			foreach( fuel_tank in a_fuel_tanks_dmg_right )
//			{
//				PlayFX( getfx( "fuel_tank_explosion" ), fuel_tank.origin );	
//				fuel_tank Show();
//			}	
//			
//			break;
//		case "left_fuel_tanks":
//			//delete prestine fuel tanks
//			a_fuel_tanks_left = GetEntArray( "fuel_tanks_left", "targetname" );
//			foreach( fuel_tank in a_fuel_tanks_left )
//			{
//				fuel_tank Delete();
//			}	
//				
//			//show damaged tank
//			a_fuel_tanks_dmg_left = GetEntArray( "fuel_tanks_dmg_left", "targetname" );
//			foreach( fuel_tank in a_fuel_tanks_dmg_left )
//			{
//				fuel_tank Show();
//				PlayFX( getfx( "fuel_tank_explosion" ), fuel_tank.origin );
//			}		
//			break;
//	}
//	
//	
//	for(i = 0; i < 5; i++)
//	{
//		blowup_origin = getent("container_damage_points_" + (i + 1), "targetname");
//		RadiusDamage( blowup_origin.origin, 30, 30, 30, undefined, "MOD_EXPLOSIVE");
//		wait(0.5);
//	}
//	
//	flag_set( "fuel_tanks_destroyed" );	
//}

docks_container_moment()
{

	
	flag_wait("jeep_fence_crash");

	simple_spawn_single( "docks_container_pdf_rpg", ::init_docks_container_pdf_rpg );
//	
	simple_spawn( "docks_container_pdf", ::init_docks_container_pdf );
	
	vh_contrainer_truck = spawn_vehicle_from_targetname_and_drive( "docks_container_truck" );
	
	//flag_wait( "fuel_tanks_destroyed" );
	trigger_wait("docks_rpg");
	
	wait(2);
		
	for(i = 0; i < 6; i++)
	{
		blowup_origin = getent("container_damage_points_" + (i + 1), "targetname");
		RadiusDamage( blowup_origin.origin, 50, 50, 100, undefined, "MOD_EXPLOSIVE");
		wait(0.2);
	}
	
	super_fly = getentarray("super_fly_pdf", "script_noteworthy");
	
	for(i = 0; i < super_fly.size; i++)
	{
		if( IsAI(super_fly[i] ) )
		{
			if( isdefined( super_fly[i] ) )
			{
				PlayFXOnTag(level._effect[ "pdf_armstrong_fire_Fx" ], super_fly[i], "tag_origin");
				super_fly[i] StartRagdoll();
				super_fly[i] LaunchRagdoll( ( 180, 0, 150) );
				break;
		
			}
		}
	}
	
	
	
//	blowup_origin = getent("container_damage_points_2", "targetname");
//	RadiusDamage( blowup_origin.origin, 50, 50, 100, undefined, "MOD_EXPLOSIVE");
	
	
	wait(1);
	
	vh_contrainer_truck notify( "death" );
}

//fail condition
init_docks_container_pdf_rpg()
{
	self endon( "death" );
	
	self.ignoreme = 1;
	self.ignoreall = 1;
	
//	nd_player_shooting_end = GetVehicleNode( "player_shooting_end", "script_noteworthy" );
//	nd_player_shooting_end waittill( "trigger" );		
	
	trigger_wait("docks_rpg");
	
	e_rpg_jeep_target = GetEnt( "rpg_jeep_target", "targetname" );
	
	//TODO: Create a more apparent fail condition. Success for now - shabs
	wait(4);
	MagicBullet( "rpg_magic_bullet_sp", self GetTagOrigin( "tag_flash" ), e_rpg_jeep_target.origin );			
	
}

init_docks_container_pdf()
{
	self endon( "death" );
	
	self.ignoreall = 1;
	trigger_wait("docks_rpg");
	self.ignoreall = 0;
	
	
	//self Die();
}

jeep_crash_moments()
{
	a_foliage_crash_1 = GetEntArray( "foliage_crash_1", "targetname" );
//	level.player PlayRumbleLoopOnEntity( "angola_hind_ride" );
	
	flag_wait( "jeep_fence_crash" );
	
//	level.player PlayRumbleOnEntity("damage_heavy");
	//earthquake( 0.5, 1.5, level.player.origin, 250 );
	level notify("fxanim_fence_break_start");
	

}

jeep_intro_ride()
{	
	//level thread docks_magic_rpg_setup();
	
	level thread docks_gate_ambush();

	level thread docks_container_moment();

	level thread jeep_crash_moments();
	
	level thread red_barrel_detect_damage();
	
	level thread dock_rumble();
	
	
	const n_right_arc = 30;
	const n_left_arc = 30;
	const n_top_arc = 15;
	const n_bottom_arc = 15;	
	
	//level.player PlayRumbleLoopOnEntity( "slide_rumble" );
	
	//spawn jeep
	level.vh_player_jeep = spawn("script_model", (0, 0, 0));
	level.vh_player_jeep setmodel("veh_t6_mil_ultimate_jeep");
	level.vh_player_jeep.animname = "player_jeep";
	level.vh_player_jeep.targetname = "player_jeep";
	//level.vh_player_jeep veh_magic_bullet_shield( true );
	PlayFXOnTag(level._effect[ "jeep_spot_light" ] , level.vh_player_jeep, "tag_headlight_left");
	PlayFXOnTag(level._effect[ "jeep_headlight" ] , level.vh_player_jeep, "tag_headlight_left");
	PlayFXOnTag(level._effect[ "jeep_headlight" ] , level.vh_player_jeep, "tag_headlight_right");
	wait(0.05);
	PlayFXOnTag(level._effect[ "jeep_taillight" ] , level.vh_player_jeep, "tag_brakelight_left");
	PlayFXOnTag(level._effect[ "jeep_taillight" ] , level.vh_player_jeep, "tag_brakelight_right");
	PlayFXOnTag(level._effect[ "jeep_guagelight" ] , level.vh_player_jeep, "tag_gauges");

	
	level.player EnableInvulnerability();

	level.noriega set_ignoreall( true );
	level.noriega set_ignoreme( true );
	
	level thread run_scene("player_jeep_rail_jeep");
	level thread run_scene("player_jeep_rail");
	
	//drive by sequence
	level thread do_drive_by_shooting_sequence();
	//wait(5);
	exploder(802);
	scene_wait("player_jeep_rail");
	level.noriega.ignoreme = true;
	level.noriega.ignoreall = true;
	enemies = GetAIArray("axis");
	for(i = 0; i < enemies.size; i++)
	{
		enemies[i] delete();
	}
	//sideway pistol shooting sequence
	colt_victim = simple_spawn("docks_colt_victims");
	level thread run_scene("player_jeep_jeep_idle");
	level thread run_scene("player_jeep_idle_loop");
	player_body = get_model_or_models_from_scene("player_jeep_rail", "player_body");
	level thread give_player_max_ammo();
	level.player EnableWeapons();
	wait(0.05);
	level.player PlayerLinkToDelta(player_body, "tag_player", 0.5, 30, 30, 40, 30);
	level.player ShowViewModel();
	level.player DisableWeaponCycling();
	player_body hide();

	while(1)
	{
		colt_victim = array_removedead(colt_victim);

		if(colt_victim.size == 0)
		{
			break;
		}
		wait(0.05);
	}
	level.player PlayerLinkToAbsolute(player_body, "tag_player");
	
	level notify("viewmodel_off");
	level.player DisableWeapons();
	wait(0.5);
	level.player TakeWeapon("m1911_1handed_sp");
	level.player HideViewModel();
	player_body show();
	level.player EnableWeaponCycling();
	level.player SwitchToWeapon(level.player.original_weapon);
	
	
	
	level thread run_scene("player_jeep_jeep_idle_end");
	run_scene("player_jeep_idle_end");
	flag_set("docks_cleared");
}


do_drive_by_shooting_sequence()
{
	wait(1);
	player_body = get_model_or_models_from_scene("player_jeep_rail", "player_body");
	//level waittill("attach_weapon");
	level.player.current_weapon = level.player GetCurrentWeapon();
	level.player.original_weapon = level.player GetCurrentWeapon();
	modelname = GetWeaponModel( level.player.current_weapon );
	player_body attach(modelname, "tag_weapon");
	wait(4);
	level.player EnableWeapons();
	level.player SetLowReady(true);
	
	
	level waittill("viewmodel_on");

	level thread give_player_max_ammo();
	level thread timescale_tween(1, 0.5, 1);
	level.player PlayerLinkToDelta(player_body, "tag_player", 0.5, 40, 30, 40, 30);
	level.player SetLowReady(false);
	level.player ShowViewModel();
	level.player DisableWeaponCycling();
	level.player AllowAds(false);
	player_body hide();
//	SetTimeScale(0.5);
	level waittill("viewmodel_off");
	player_body Detach(modelname, "tag_weapon");
	level.player PlayerLinkToAbsolute(player_body, "tag_player");
	player_body show();
	level.player HideViewModel();
	level.player EnableWeaponCycling();
	level.player DisableWeapons();
	level.player AllowAds(true);
	level.player GiveWeapon("m1911_1handed_sp");
	level.player SwitchToWeapon("m1911_1handed_sp");
	timescale_tween(0.5, 1, 1);	
}
give_player_max_ammo()
{
	level endon("viewmodel_off");
	
	while(1)
	{
		wait(0.1);
		level.player.current_weapon = level.player GetCurrentWeapon();
		level.player SetWeaponAmmoClip(level.player.current_weapon, 400);
	}
}

red_barrel_detect_damage()
{
	dam_trigger = getentarray("drive_by_damage_trigger", "targetname");
	array_thread(dam_trigger, ::deal_damage_when_shot);
	
	
}
deal_damage_when_shot()
{
	while(1)
	{
		self waittill("damage", amount, attacker);
		if(attacker == level.player)
		{
			RadiusDamage( self.origin, 50, 50, 100, undefined, "MOD_EXPLOSIVE");
			break;
				
		}
		
	}
}
//init_docks_colt_victims()
//{
//	self endon( "death" );
//	
//	self waittill( "goal" );
//	self Die();
//}

docks_gate_ambush()
{
	add_spawn_function_veh( "docks_gate_turret_truck", ::init_docks_gate_turret_truck );	

	a_docks_gate_runners = GetEntArray( "docks_gate_runners", "targetname" );
	array_thread( a_docks_gate_runners, ::add_spawn_function, ::init_docks_frontgate_pdf );
	
	a_docks_frontgate_pdf = GetEntArray( "docks_frontgate_pdf", "targetname" );
	array_thread( a_docks_frontgate_pdf, ::add_spawn_function, ::init_docks_frontgate_pdf );
	
	wait(2);
//	nd_spawn_frontgate_pdf = GetVehicleNode( "spawn_frontgate_pdf", "script_noteworthy" );
//	nd_spawn_frontgate_pdf waittill( "trigger" );
	
	simple_spawn( "docks_frontgate_pdf" );
//
//	nd_spawn_frontgate_turret_truck = GetVehicleNode( "spawn_frontgate_turret_truck", "script_noteworthy" );
//	nd_spawn_frontgate_turret_truck waittill( "trigger" );
	
	
	wait(2);
	//turret truck
	spawn_vehicle_from_targetname_and_drive( "docks_gate_turret_truck" );
	
	
	wait(2);
//	nd_spawn_frontgate_runners = GetVehicleNode( "spawn_frontgate_runners", "script_noteworthy" );
//	nd_spawn_frontgate_runners waittill( "trigger" );
	
	simple_spawn( "docks_gate_runners" );
}

init_docks_gate_turret_truck() //self = truck
{
	self endon( "death" );

	flag_wait( "start_gate_ambush" );
	
	self maps\_turret::set_turret_burst_parameters( 3.0, 5.0, 1.0, 2.0, 1 ); 	
	self enable_turret( 1 );	
	
	flag_wait( "jeep_fence_crash" );
	
	self disable_turret( 1 );
	self notify( "death" );
}

init_docks_frontgate_pdf() //self = ai
{
	self endon( "death" );

	self.ignoreall = 1;
	self.ignoreme = 1;
	
	flag_wait( "start_gate_ambush" );
	
	self.ignoreall = 0;
	self.ignoreme = 0;
	
	flag_wait( "jeep_fence_crash" );
	
	self Die();
}

//Moves player out of jeep, links them in cover on the jeep door for the turret sequence, and handles unlinking the player
//Self is the player
jeep_unload_player()
{
	const n_right_arc = 7;
	const n_left_arc = 45;
	const n_top_arc = 15;
	const n_bottom_arc = 7;
	
	//run_scene( "gate_player_unload" );
	
	self.e_jeep_door_mount = Spawn( "script_origin", self.origin );
	self.e_jeep_door_mount.angles = self.angles;
	self PlayerLinkTo( self.e_jeep_door_mount, undefined, 0, n_right_arc, n_left_arc, n_top_arc, n_bottom_arc );
}

//Runs jeep drive animation with tread effects
jeep_drive( docks_jeep )
{
	docks_jeep veh_toggle_tread_fx( 1 );
	run_scene( "docks_drive" );
	docks_jeep veh_toggle_tread_fx( 0 );
}


init_flags()
{
	flag_init( "docks_battle_one_trigger_event" );
	flag_init( "docks_cleared" );
	flag_init( "docks_entering_elevator" );
	flag_init( "docks_rifle_mounted" );
	flag_init( "docks_kill_menendez" );
	flag_init( "sniper_start_timer" );
	flag_init( "sniper_stop_timer" );
	flag_init( "sniper_mason_shot1" );
	flag_init( "sniper_mason_shot2" );
	flag_init( "docks_mason_down" );
	flag_init( "docks_betrayed_fade_in" );
	flag_init( "docks_betrayed_fade_out" );
	flag_init( "docks_mason_dead_reveal" );
	flag_init( "docks_final_cin_fade_in" );
	flag_init( "docks_final_cin_fade_out" );
	flag_init( "docks_final_cin_landed1" );
	flag_init( "docks_final_cin_landed2" );
	flag_init( "challenge_nodeath_check_start" );
	flag_init( "challenge_nodeath_check_end" );
	flag_init( "challenge_docks_guards_speed_kill_start" );
	flag_init( "challenge_docks_guards_speed_kill_pause" );
	
	
	//shabs
	flag_init( "jeep_foliage_crash_1" );
	flag_init( "jeep_foliage_crash_2" );
	flag_init( "jeep_fence_crash" );
	flag_init( "start_gate_ambush" );
	flag_init( "fuel_tanks_destroyed" );
}


//Logic for speed kill challenge
challenge_docks_guards_speed_kill( str_notify )
{
	flag_wait( "challenge_docks_guards_speed_kill_start" );
	
	n_timer_start = getTime();
	flag_wait( "challenge_docks_guards_speed_kill_pause" );
	
	n_total_time = getTime() - n_timer_start;
	flag_wait( "challenge_docks_guards_speed_kill_start" );
	
	n_timer_start = getTime();
	flag_wait( "docks_cleared" );
	
	n_total_time = n_total_time + (getTime() - n_timer_start);
	
	if( n_total_time < 15000 )
	{
		self notify( str_notify );
	}
}

////Plays VO for elevator approach after the jeep defend finishes
//docks_elevator_approach_vo()
//{	
//	level.player say_dialog( "hudson_im_appr_001" );
//	level.player say_dialog( "mason_should_be_in_002", 0.5 );
//	level.player say_dialog( "expecting_trouble_004", 0.5 );
//	level.player say_dialog( "its_menendez_005", 1.0 );
//	level.player say_dialog( "theres_an_elevato_007", 0.5 );
//	level.player say_dialog( "got_it_008", 0.5 );
//}

//Plays VO outside of the elevator
docks_elevator_wait_vo()
{
	level.player say_dialog( "im_at_the_elevato_009", 0.5 );
	level.player say_dialog( "take_it_up_to_the_010", 0.5 );
}

//Plays VO during elevator ride
docks_elevator_ride_vo()
{
	level.player say_dialog( "mason_001", 0.5 );
	level.player say_dialog( "where_are_you_bro_002" );
	level.player say_dialog( "fucking_comms_006", 1.0 );
}

//Plays VO when exiting the elevator
docks_elevator_exit_vo()
{
	level.player say_dialog( "woods_what_is_y_004" );
	level.player say_dialog( "hudson_ive_lo_005", 0.5 );
}

//Plays VO for setting up on the sniper rifle
docks_sniping_setup_vo()
{
	level.player say_dialog( "do_you_see_nexus_t_006", 0.5 );
	level.player say_dialog( "its_him_menend_007", 0.5 );
	level.player say_dialog( "make_it_quick_woo_008", 0.5 );
}

//Plays VO when watching Mason be brought out
docks_sniping_walk_vo()
{
	level.player say_dialog( "hudson_confirm_h_009", 1.5 );
	level.player say_dialog( "take_the_headshot_010", 0.5 );
}

//************************************************************************************************************************************//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////**********  SNIPER EVENT  **********////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles elevator ride up to sniper position
elevator_ride()
{	
	level.noriega change_movemode("walk");
	//level thread run_scene("noriega_walk_to_elevator");
	
	level thread open_bottom_elevator_door();
	run_scene("noriega_enter_elevator");
	level thread run_scene("noriega_idle_elevator");
	trigger_wait( "elevator_trigger_interior" );

	close_bottom_door_elevator();
	
	flag_set( "docks_entering_elevator" );
	//run_scene( "elevator_bottom_close" );
	
	//level thread docks_elevator_ride_vo();
	
	//Need to wait for the door to close and then end the scene otherwise the elevator close anim blocks forever
	wait 1.0;
	//end_scene( "elevator_bottom_close" );
	
	
	top_roll_door = getent("dock_top_roll_door", "targetname");
	
	e_elevator = GetEnt( "docks_elevator", "targetname" );
	e_elevator SetMovingPlatformEnabled(true);
	top_roll_door linkto(e_elevator);
	e_elevator_move_target = GetStruct( "docks_elevator_move_target", "targetname" );
//	e_elevator SetMovingPlatformEnabled( true );
	
	level.player playsound( "evt_elevator_quad" );
	
	e_elevator MoveTo( e_elevator_move_target.origin, 5.0 );
	e_elevator waittill( "movedone" );
	level thread maps\createart\panama3_art::sniper();
	level notify("elevator_stop_top");
	open_top_elevator_door();
	
	elevator_door_clip = getent("elevator_top_player_clip", "targetname");
	elevator_door_clip delete();
	level.player SetMoveSpeedScale(0.3);
	level.player AllowSprint(false);
	level thread autosave_by_name( "sniper_start" );
	//level thread run_scene( "elevator_top_open" );
//	trigger_wait( "elevator_exit_trigger" );
	
}

open_bottom_elevator_door()
{
	bottom_door_bottom = getent("dock_elevator_bottom_door_bottom", "targetname");
	bottom_door_top = getent("dock_elevator_bottom_door_top", "targetname");
	bottom_roll = getent("dock_bottom_roll_door", "targetname");
	
	bottom_door_top playsound( "evt_elevator_middoor" );
	
	bottom_door_bottom MoveZ( -74, 2);
	bottom_door_top MoveZ( 74, 2);
	
	bottom_door_top waittill("movedone");
	
	bottom_roll playsound( "evt_elevator_topdoor" );
	
	bottom_roll MoveZ(130, 4);
	bottom_roll waittill("movedone");
	
	elevator_door_clip = getent("elevator_player_clip", "targetname");
	elevator_door_clip trigger_off();
	
}

close_bottom_door_elevator()
{
	bottom_door_bottom = getent("dock_elevator_bottom_door_bottom", "targetname");
	bottom_door_top = getent("dock_elevator_bottom_door_top", "targetname");
	bottom_roll = getent("dock_bottom_roll_door", "targetname");
	elevator_door_clip = getent("elevator_player_clip", "targetname");
	
	trigger_wait("elevator_trigger_interior");
	
	elevator_door_clip trigger_on();
	
	bottom_door_top playsound( "evt_elevator_middoor" );
	
	bottom_door_bottom MoveZ( 74, 2);
	bottom_door_top MoveZ( -74, 2);
	
	bottom_roll playsound( "evt_elevator_topdoor" );
	
	bottom_roll = getent("dock_bottom_roll_door", "targetname");
	bottom_roll MoveZ(-130, 4);
	bottom_roll waittill("movedone");
	e_elevator = GetEnt( "docks_elevator", "targetname" );
	bottom_roll linkto(e_elevator);
	
}

open_top_elevator_door()
{
	top_door_bottom = getent("dock_elevator_top_door_bottom", "targetname");
	top_door_top = getent("dock_elevator_top_door_top", "targetname");
	top_roll = getent("dock_top_roll_door", "targetname");
	top_roll unlink();
	
	top_door_top playsound( "evt_elevator_middoor" );
	
	top_door_bottom MoveZ( -74, 2);
	top_door_top MoveZ( 74, 2);
	
	top_door_bottom waittill("movedone");
	
	top_roll playsound( "evt_elevator_topdoor" );
	
	top_roll MoveZ(130, 4);
	top_roll waittill("movedone");
	
}
	

//Handles sniper sequence at the end of the docks section
sniper_event()
{	
	end_scene("noriega_idle_elevator");
	
	level thread run_Scene("sniper_idle_door");
	level.noriega unlink();
	run_scene("noriega_exit_elevator");
	level thread run_scene("noriega_idle_sniper_door");
	
	trigger_wait("sniper_noriega_kill_guard_trigger");
	
	run_scene("noriega_kill_guard_give_sniper");
	level thread run_scene("noriega_idle_woods_snipe");
	
	
//	trigger_on( "sniper_turret_trigger", "targetname" );
//	trigger_wait( "sniper_turret_trigger" );
	
	//level thread docks_sniping_setup_vo();
	
	SetSavedDvar("cg_fovmin", 5);
	
	e_sniper_turret = GetEnt( "barret_turret", "targetname" );
	
	flag_set( "docks_rifle_mounted" );
	level.player playsound ("evt_prep_rifle");
	//run_scene( "mount_sniper_turret" );
	
	//Need to wait a frame after the mount scene, otherwise it breaks the player out of the sniper turret
	wait 0.05;
	level.player TakeAllWeapons();
	level.player GiveWeapon("barretm82_highvzoom_sp");
	
	//Place player onto sniper turret and prevent them from dismounting or firing until Mason is in position
	//level.player DisableTurretDismount();
	//e_sniper_turret TurretFireDisable();
	//e_sniper_turret MakeTurretUsable();
	//e_sniper_turret UseBy( level.player );
	//e_sniper_turret Show();
	//e_sniper_turret MakeTurretUnusable();
	//set_sniper_turret_zoom();
	//e_sniper_aim_target = GetEnt( "sniper_aim_target", "targetname" );
	//e_sniper_aim_angles = VectorToAngles( e_sniper_aim_target.origin - level.player.origin );
	//level.player lerp_player_view_to_position( level.player.origin, e_sniper_aim_angles, 0.05, 1, 2, 2, 2, 2, false );
	
	add_spawn_function_group( "sniper_guards", "targetname", ::set_ignoreall, true );
	ai_sniper_guards = simple_spawn( "sniper_guards" );
	level.mason = simple_spawn_single( "mason_prisoner" );
	
	//Make Mason's faction axis to prevent friendly fire fail and keep him from ragdolling normally from damage
	level.mason.team = "axis";
	level.mason magic_bullet_shield();
	
	array_thread( ai_sniper_guards, ::sniper_guard_damage_fail );
	//level thread docks_sniping_walk_vo();
	level thread run_scene( "sniper_walk" );
	level thread maps\createart\panama3_art::walk();
	flag_set( "docks_kill_menendez" );
	flag_wait( "sniper_start_timer" );
	
	//Enable turret fire and start timer for player to take the first shot
	//e_sniper_turret TurretFireEnable();
//	level thread mason_no_snipe_fail(); 
	level.mason thread mason_damage_events( e_sniper_turret );
	flag_wait( "docks_mason_down" );
	//level.player AllowAds(false);
	//Freeze controls once Mason is down to prevent player from walking off the building and dying during the old man woods video
	//level.player FreezeControls( true );
}

//Sets up zoom dvars for sniper turret
set_sniper_turret_zoom()
{
	SetSavedDvar( "cg_fovmin", 3 );
	SetSavedDvar( "turretscopezoom", 7.5 );
	SetSavedDvar( "turretscopezoommax", 7.5 );
	SetSavedDvar( "turretscopezoommin", 3 );
	SetSavedDvar( "turretscopezoomrate", 7 );
}

//Tracks damage events on Mason during the sniper sequence and implementes logic for non-lethal shots
//TODO: Set global game variable (when available) if Mason is left alive
//Self is Mason
mason_damage_events( e_sniper_turret )
{
	self waittill( "damage" );
	
	level notify( "mason_shot" );
	flag_set( "sniper_mason_shot1" );
	
	if( self is_fatal_shot() )
	{
		//Special blood effect for headshot
		if( self.damageLocation == "helmet" || self.damageLocation == "neck" )
		{
			PlayFxOnTag( GetFX( "mason_fatal_shot" ), self, "j_head" );
		}
		
		level thread run_scene( "sniper_shot" );
	}
	else
	{
		//Disable turret fire after first shot until Mason is idling on the ground
		e_sniper_turret TurretFireDisable();
		level.player thread say_dialog( "shoot_him_in_the_f_001", 0.5 );
		run_scene( "sniper_injured_shot" );
		level thread run_scene( "sniper_shot_idle" );
		
		//Reenable turret for second shot
		e_sniper_turret TurretFireEnable();
		self waittill( "damage" );
		
		flag_set( "sniper_mason_shot2" );
		
		if( self is_fatal_shot() )
		{
			//Special blood effect for headshot
			if( self.damageLocation == "helmet" || self.damageLocation == "neck" )
			{
				PlayFxOnTag( GetFX( "mason_fatal_shot" ), self, "j_head" );
			}
		}
		else
		{
			//Set global game variable for Mason left alive
			/#
				iprintln( "MASON LIVES!!!..." );
			#/
		}
		
		level thread run_scene( "sniper_injured_last_shot" );
	}
	
	//Disable turret during old man woods video
	e_sniper_turret TurretFireDisable();
	
	//Let the player see the results of the kill
	wait 1.5;
	flag_set( "docks_mason_down" );
	level thread old_man_woods( "old_woods_4" );
}

//Handles fail condition for player waiting too long before sniping Mason
//Self is Mason
mason_no_snipe_fail()
{
	level endon( "mason_shot" );
	flag_wait( "sniper_stop_timer" );
	
	fail_player( &"PANAMA_SNIPER_FAIL" );
}

//Handles fail condition for player sniping Noriega's guards instead of Mason
//Self is one of the guards leading Mason out
sniper_guard_damage_fail()
{
	level endon( "sniping finished" );
	self magic_bullet_shield();
	
	while( true )
	{
		self waittill( "damage" );
		
		//Wait a frame for flags to be set in case of Mason and guard damage events being received simultaneously
		wait 0.05;
		
		//Only fail the player of guard shot fatally and Mason hasn't also been shot (i.e. bullet penetrated Mason and hit guard)
		if( self is_fatal_shot() && !flag( "sniper_mason_shot1" ) && !flag( "sniper_mason_shot2" ) )
		{
			GetEnt( "barret_turret", "targetname" ) TurretFireDisable();
			self stop_magic_bullet_shield();
			self ragdoll_death();
			fail_player( &"PANAMA_SNIPER_FAIL" );
		}
	}
}

//Wraps logic for determining whether the shot on Mason was fatal
//Self is Mason
is_fatal_shot()
{
	if( self.damageLocation == "helmet" || self.damageLocation == "neck" || self.damageLocation == "torso_upper" )
	{
		return true;
	}
	
	return false;
}

//*****************************************************************************************************************************************//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////**********  FINAL CINEMATIC EVENT **********////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Handles ending cinematic
betrayed_event()
{
	//Spawn Noriega with pistol for scene
//	level.noriega = init_hero( "noriega" );
//	level.noriega_betrayed_weapon = spawn_model( "t6_wpn_pistol_m1911_world", level.noriega GetTagOrigin( "tag_weapon_right" ), level.noriega GetTagAngles( "tag_weapon_right" ) );
//	level.noriega_betrayed_weapon LinkTo( level.noriega, "tag_weapon_right" );
	
	//Player animation uses Mason's gun. Attach pistol to Mason for scene.
	mason_prisoner = GetEnt( "mason_prisoner_ai", "targetname" );
	mason_prisoner_weapon = spawn_model( "t6_wpn_pistol_m1911_world", mason_prisoner GetTagOrigin( "tag_weapon_right" ), mason_prisoner GetTagAngles( "tag_weapon_right" ) );
	mason_prisoner_weapon LinkTo( mason_prisoner, "tag_weapon_right" );
	
	//Dismount player from rifle
	e_sniper_turret = GetEnt( "barret_turret", "targetname" );
	//level.player EnableTurretDismount();
	//e_sniper_turret UseBy( level.player );
	
	flag_wait( "movie_done" );
	
	level.player playsound ( "evt_betrayed" );
	end_scene("noriega_idle_woods_snipe");
	level thread run_scene( "betrayed" );
	level thread run_scene( "betrayed_sack" );
	level thread run_scene( "betrayed_mason_body" );
	
	
	wait(5);
	
	wait(5);
	
	//Unfreeze controls for headlook
	//level.player FreezeControls( false );
	flag_wait( "docks_betrayed_fade_out" );
	
	screen_fade_out();
	level.player playsound ("evt_recovered");
	level thread run_scene( "final_cin_mason" );
	level thread run_scene( "final_cin_player" );
	
	level thread run_scene( "final_cin_chopper1" );
	
	//Wait a frame for chopper used to align following anims to spawn from scene system and turn on spotlight
	wait 0.05;
	vh_littlebird1 = getEnt( "final_cin_littlebird1", "targetname" );
	vh_littlebird1 veh_magic_bullet_shield( true );
	e_littlebird1_barrel = spawn_model( "tag_origin", vh_littlebird1 GetTagOrigin( "tag_flash" ), vh_littlebird1 GetTagAngles( "tag_flash" ) );
	e_littlebird1_barrel LinkTo( vh_littlebird1, "tag_flash" );
	PlayFXOnTag( GetFX( "apache_spotlight_cheap" ), e_littlebird1_barrel, "tag_origin" );
	
	level thread run_scene( "final_cin_seals1_intro_idle" );
	level thread run_scene( "final_cin_skinner_medic" );
	level thread run_scene( "final_cin_pilots1_idle" );
	
	level thread run_scene( "final_cin_chopper2" );
	
	//Wait a frame for chopper used to align following anims to spawn from scene system and turn on spotlight
	wait 0.05;
	vh_littlebird2 = getEnt( "final_cin_littlebird2", "targetname" );
	vh_littlebird2 veh_magic_bullet_shield( true );
	e_littlebird2_barrel = spawn_model( "tag_origin", vh_littlebird2 GetTagOrigin( "tag_flash" ), vh_littlebird2 GetTagAngles( "tag_flash" ) );
	e_littlebird2_barrel LinkTo( vh_littlebird2, "tag_flash" );
	PlayFXOnTag( GetFX( "apache_spotlight_cheap" ), e_littlebird2_barrel, "tag_origin" );
	
	level thread run_scene( "final_cin_seals2_intro_idle" );
	level thread run_scene( "final_cin_seals3" );
	level thread run_scene( "final_cin_pilots2_idle" );
	
	//Helicopter rotor wash effect
	activate_exploder( 920 );
	vh_littlebird1 veh_toggle_tread_fx( 1 );
	vh_littlebird2 veh_toggle_tread_fx( 1 );
	flag_wait( "docks_final_cin_fade_in" );
	
	level thread screen_fade_in( 2 );
	flag_wait( "docks_final_cin_landed1" );
	
	level thread run_scene( "final_cin_seals1_unload" );
	flag_wait( "docks_final_cin_landed2" );
	
	level thread run_scene( "final_cin_seals2_unload" );
	flag_wait( "docks_final_cin_fade_out" );
	
	screen_fade_out();
	flag_set( "challenge_nodeath_check_start" );
	flag_wait( "challenge_nodeath_check_end" );
	
	NextMission();
}

//Handles logic for first damage state during ending cinematic
swap_player_body_dmg1( e_player_body )
{
	MagicBullet( MAGIC_BULLET_PISTOL, level.noriega_betrayed_weapon GetTagOrigin( "tag_flash" ), e_player_body GetTagOrigin( "J_Knee_LE" ) );
	PlayFxOnTag( GetFX( "player_knee_shot_l" ), e_player_body, "J_Knee_LE" );
	e_player_body SetModel( "c_usa_woods_panama_lower_dmg1_viewbody" );
	flag_set( "docks_mason_dead_reveal" );
}

//Handles logic for second damage state during ending cinematic
swap_player_body_dmg2( e_player_body )
{
	MagicBullet( MAGIC_BULLET_PISTOL, level.noriega_betrayed_weapon GetTagOrigin( "tag_flash" ), e_player_body GetTagOrigin( "J_Knee_RI" )  );
	PlayFxOnTag( GetFX( "player_knee_shot_r" ), e_player_body, "J_Knee_RI" );
	e_player_body SetModel( "c_usa_woods_panama_lower_dmg2_viewbody" );
}

//Handles logic for second damage state during ending cinematic
swap_player_body_dmg3( e_player_body )
{
	a_sniper_guards = GetEntArray( "sniper_guards_ai", "targetname" );
	
	foreach( e_guard in a_sniper_guards )
	{
		if( e_guard.script_animname == "sniper_guard1_ai" )
		{
			e_sniper_guard = e_guard;
		}
	}
	Assert( IsDefined( e_sniper_guard ), "No 'sniper_guard1_ai' for shot 3." );
	
	MagicBullet( MAGIC_BULLET_ENEMY, e_sniper_guard GetTagOrigin( "tag_flash" ), e_player_body GetTagOrigin( "J_Wrist_RI" )  );
	PlayFxOnTag( GetFX( "player_knee_shot_r" ), e_player_body, "J_Wrist_RI" );
}

//****************************************************************************************************************************************//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

dock_vo()
{
	level endon("docks_mason_down");
	            
	
	scene_wait("player_jeep_jeep_idle_end");
	
	level.player say_dialog("maso_woods_are_you_in_po_0");
	level.player say_dialog("wood_we_ve_run_into_resis_0");
	level.player say_dialog("maso_on_top_of_the_west_b_0");
	level.player say_dialog("wood_fucking_comms_0");
	level.player say_dialog("huds_copy_report_when_e_0");
	
	level.noriega say_dialog("nori_this_way_everythin_0");
	
	scene_wait("noriega_kill_guard_give_sniper");
	
	level.noriega say_dialog("nori_we_are_ready_bring_0");
	level.player say_dialog("wood_you_should_have_told_0");
	level.player say_dialog("huds_confirm_visual_0");
	level.player say_dialog("wood_you_should_have_told_1");
	level.player say_dialog("wood_they_re_bringing_the_0");
	level.noriega say_dialog("nori_kill_him_0");
	
	flag_wait("docks_kill_menendez");
	
	level.player say_dialog("huds_end_this_now_woods_0");
	wait(3);
	level.player say_dialog("huds_take_the_headshot_0");
	wait(3);
	level.noriega say_dialog("nori_now_woods_0");
	wait(3);
	level.player say_dialog("huds_that_is_a_direct_ord_0");
	wait(3);
	level.player say_dialog("huds_shoot_him_in_the_fuc_0");
	wait(3);
	
}

dock_rumble()
{
	level.player PlayRumbleLoopOnEntity( "angola_hind_ride" );
	flag_wait( "jeep_fence_crash" );
	level.player PlayRumbleOnEntity("grenade_rumble");
	
	wait(10.5);
	level.player PlayRumbleOnEntity("grenade_rumble");
	
	scene_wait("player_jeep_rail");
	level.player StopRumble( "angola_hind_ride" );
	
	flag_wait("docks_entering_elevator");
	level.player PlayRumbleLoopOnEntity( "angola_hind_ride" );
//	
	level waittill("elevator_stop_top");
	level.player StopRumble( "angola_hind_ride" );
//	
}


start_fire_work()
{
	rotator = getent("the_great_rotator", "targetname");
	spawners = getentarray("firework_spawner", "script_noteworthy");
	
	//trigger_wait("start_fire_work");
	
	for(i = 0; i < spawners.size; i++)
	{
		spawners[i] linkto(rotator);	
	}
	rotator RotateYaw(999999, 999999);
	while(1)
	{
		firework_forward_launch();
		wait(0.05);
	}
	
}

firework_forward_launch()
{
	for( i = 1; i < 11; i++)
	{
		firework = simple_spawn_single("firework_pdf_" + i);
		firework.targetname = "fire_works";
		PlayFXOnTag(level._effect[ "pdf_armstrong_fire_Fx" ], firework, "tag_origin");
		PlayFXOnTag(level._effect[ "jet_contrail" ], firework, "tag_origin");
		firework StartRagdoll();
		firework LaunchRagdoll( ( 0, 0, 1000) );
		wait(0.1);
	}
	
	wait(5);
	delete_fire_work = getentarray("fire_works", "targetname");
	
	for(i = 0; i < delete_fire_work.size; i++)
	{
		delete_fire_work[i] delete();
	}
	
	for( i = 10; i > 0; i--)
	{
		firework = simple_spawn_single("firework_pdf_" + i);
		firework.targetname = "fire_works";
		PlayFXOnTag(level._effect[ "pdf_armstrong_fire_Fx" ], firework, "tag_origin");
		PlayFXOnTag(level._effect[ "jet_contrail" ], firework, "tag_origin");
		firework StartRagdoll();
		firework LaunchRagdoll( ( 0, 0, 1000) );
		wait(0.1);
	}
	
	wait(5);
	delete_fire_work = getentarray("fire_works", "targetname");
	
	for(i = 0; i < delete_fire_work.size; i++)
	{
		delete_fire_work[i] delete();
	}
	
}