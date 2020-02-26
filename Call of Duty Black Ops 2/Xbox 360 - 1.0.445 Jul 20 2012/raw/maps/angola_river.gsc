#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_anim;
#include maps\angola_2_util;
#include animscripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

init_flags()
{
	flag_init("moving_boat");
	flag_init("heli_moving_to_location");
	flag_init("player_jump_on_barge");
	SetSavedDvar("aim_slowdown_enabled", 0);
	SetSavedDvar("aim_lockon_enabled", 0);
	
	level.overrideActorDamage = ::actor_turret_damage_override;
	
	//debug var
	level.num_enemy_falls_off = 0;
	
	exploder(100);
}

setup_heroes()
{
	level.hudson = init_hero("hudson");
	level.player thread maps\createart\angola_art::river();
}

setup_level()
{
	level.barge_spawners = [];
	level.barge_spawners[0] = GetEnt( "river_barge_convoy_2_guards_assault", "targetname" );
	level.barge_spawners[1] = GetEnt( "river_barge_convoy_2_guards_assault", "targetname" );	
	
	level.max_river_heli_speed = 65;
	
	level.heli_barge_path_start = GetVehicleNode( "barge_heli_path", "targetname" );
	level.main_barge = GetEnt("main_barge", "targetname");
	
	level.heli_barge_path_offset = level.heli_barge_path_start.origin - level.main_barge.origin;
	
	level.escort_boat = getent("main_convoy_escort_boat_medium_1", "targetname");
	level.escort_boat_2 = getent("main_convoy_escort_boat_medium_2", "targetname");
	level.escort_boat_3 = getent("main_convoy_escort_boat_medium_4", "targetname");	

	level.escort_boat_small = getentarray("main_convoy_escort_boat_small", "targetname");	
}

main()
{
	init_flags();
	
	level thread blackscreen( 0, 2.2, 0 );
	
	setup_level();
	setup_heroes();
	setup_hudson_heli();
	setup_main_convoy();
	
	level thread voice_over_river();
	level thread hudson_heli_think();
	
	convoy_one();
	convoy_main();
}

main_jump()
{
	heli_jump();
	barge_ram();
}

skipto_river()
{
	level.hudson = init_hero("hudson");
	
	skipto_teleport_players( "player_skipto_river" );
	skipto_teleport_ai("player_skipto_river");
	
	level clientnotify( "f35_interior" );
}

skipto_heli_jump()
{
	init_flags();

	setup_heroes();
	setup_hudson_heli();

	level thread blackscreen( 0, 2.2, 0 );
	
	setup_level();
	setup_heroes();
	setup_hudson_heli();
	
	path_node_start_boat = getvehiclenode("main_convoy_start_node", "targetname");

	// Setup the main barge
	level.main_barge thread setup_barge( path_node_start_boat, undefined );
	
	// Misc escort boat stuff
	level.escort_boat thread barge_audio("veh_barge_engine_high_plr");//kevin adding audio to main barge while plr is on it	
	level.escort_boat HidePart("tag_glass_shattered");
	level.escort_boat thread veh_magic_bullet_shield(1);
	level.escort_boat thread setup_animation_trigger_on_escort_boat();
	level.escort_boat thread setup_rpg_crate_and_trigger();
	
	// Setup escort boat
	level.escort_boat thread setup_escort_boat( path_node_start_boat, undefined, ( -500, 1250, 0 ), "main_convoy_escort_boat_medium_1_guard" );
	
	level.escort_boat_2 Delete();
	level.escort_boat_3 Delete();
	
	for ( i = 0; i < level.escort_boat_small.size; i++ )
	{
		level.escort_boat_small[i] Delete();
	}
	
	level clientnotify( "f35_interior" );
}

setup_river_player( driver = false )
{
	level.player thread take_and_giveback_weapons("give_player_weapon_back", false);
	
	wait(2);
	
	level.player GiveWeapon("usrpg_player_sp");
	level.player GiveStartAmmo("usrpg_player_sp");
	level.player SwitchToWeapon("usrpg_player_sp");
	level.player thread give_player_max_ammo();
	level.player SetClientDvar( "r_lodScaleRigid", 0.1 );
	
	run_scene("heli_attack_player_intro");
	level thread run_scene("heli_attack_player_idle");
	
	//OnSaveRestored_Callback( ::send_player_on_ship );
}

give_player_max_ammo()
{
	level endon( "heli_ride_done" );
	
	while(1)
	{
		self GiveMaxAmmo("usrpg_player_sp");
		wait(1);
	}
}

setup_hudson_heli( player_driver = false )
{
	path_node_start_heli = getvehiclenode("heli_start_node", "targetname");
	river_player_heli_spawner = "river_player_heli_spawner";
	
	level.river_heli = spawn_vehicle_from_targetname(river_player_heli_spawner);
	level.river_heli.player_transfer_location = getent("heli_transfer_player_location", "targetname");
	level.river_heli.rpg_target = getent("heli_target_origin", "targetname");
	level.river_heli.rpg_target linkto(level.river_heli, "tag_origin", (800, 0, -100) );
	level.river_heli.player_transfer_location linkto( level.river_heli, "tag_origin", (0, 0, -100 ) );
	level.river_heli SetMovingPlatformEnabled( true );
	level.river_heli.animname = "player_heli";
	level.river_heli.targetname = "player_heli";
	level.river_heli thread veh_magic_bullet_shield(1);
	playfxontag(level._effect[ "heli_trail" ], level.river_heli, "tag_origin");
	
	if ( player_driver )
	{
		level.river_heli UseVehicle( level.player, 0 );
		level.river_heli.player_vehicle = true;
	}
	else
		level.river_heli.player_vehicle = false;		
	
	//level.river_heli HidePart("tag_weapons_pod");
}

hudson_heli_think()
{
	path_node_start_heli = getvehiclenode("heli_start_node", "targetname");
	level.hudson linkto(level.river_heli, "tag_driver");

	level thread run_scene("heli_attack_hudson_idle");

	level.player PlayRumbleLoopOnEntity("angola_hind_ride");
	
	level.river_heli thread go_path(path_node_start_heli);
	level.river_heli PathVariableOffset( ( 125, 125, 125 ), 2.5 );	
	
    level notify("hudson_attack_convoy");	
    
    wait( 11 );
    
	level notify( "reached_convoy_one" );    
    
	level.river_heli thread heli_match_best_boat_speed(); 
		
	level.river_heli HidePart("tag_weapons_pod");
	level.river_heli hidepart("Tag_gunner_barrel2");
	level.river_heli hidepart("Tag_gunner_barrel4");
	end_scene("heli_attack_player_idle");
	
	level.river_heli attach("veh_t6_air_alouette_dmg_att", "tag_origin");		

	wait(0.05);	
	
	fake_body = get_model_or_models_from_scene( "heli_attack_player_intro", "player_body_river");
	fake_body attach( "t6_wpn_launch_usrpg_world", "tag_weapon1");
	
	run_scene("heli_attack_player_fall");
	
	transfer_player_to_heli();
	
	level.river_heli setspeed(50);
	
	level notify( "hudson_missile_jam" );

	wait(1);
	
	level thread update_player_heli_rolling();
	level notify("bombing_run_done");
	level thread trigger_gun_flak();
	
	level waittill( "rear_escort_dead" );
	
	level.river_heli CancelAIMove();
	level.river_heli ClearVehGoalPos();
	
	angles = level.main_barge.angles;
	VEC_SET_X( angles, 0 );
	VEC_SET_Z( angles, 0 );		
	
	fwd = AnglesToForward( angles );	
	
	level.river_heli SetVehGoalPos( level.main_barge.origin + ( fwd * -5000 ) + ( 0, 0, 1000 ), 1 );
	level.river_heli SetTargetYaw( level.main_barge.angles[1] + 90 );
	
	level.river_heli waittill( "goal" );		
	level.river_heli notify( "end_speed_match" );	

	level.river_heli ClearTargetYaw();
	level.river_heli SetNearGoalNotifyDist( 250 );
	level.river_heli thread heli_monitor_near_goal();
	
	level thread update_heli_barge_path();		
	
	while ( !IsDefined( level.river_heli.near_goal ) )
	{
		if ( !IsDefined( level.river_heli.node_pos ) )
		{
			wait( 0.05 );
		}
		else
		{
			//Line( level.river_heli.origin, level.river_heli.node_pos, ( 1, 1, 1 ), 1, false, 1000 );
			level.river_heli SetVehGoalPos( level.river_heli.node_pos, 0 );
			wait( 0.05 );
		}
	}

	level.river_heli.path_move = true;
	
	wait( 0.05 );

	level.river_heli SetSpeed( 30 );
//	level.river_heli SetPathTransitionTime( 2 );
	level.river_heli thread go_path( level.heli_barge_path_start );
	level.river_heli thread heli_match_best_boat_speed();
	level.river_heli thread heli_reached_barge_rear();
	
	level notify( "reached_barge" );
}

heli_reached_barge_rear()
{
	self endon( "death" );
	self waittill( "barge_rear" );
	
	level.main_barge.b_no_speed_match = undefined;
}

heli_follow_boat( boat )
{
	self endon( "death" );
	
	while ( 1 )
	{
		self SetVehGoalPos( boat.origin + ( 0, 0, 1000 ), 1 );
		wait( 1 );
	}
}

heli_monitor_near_goal()
{
	self waittill_any( "goal", "near_goal" );
	self.near_goal = true;
}

update_heli_barge_path()
{
	level endon( "river_heli_delete" );
	
	while ( 1 )
	{
		angles = level.main_barge.angles;
		VEC_SET_X( angles, 0 );
		VEC_SET_Z( angles, 0 );		
		
		fwd = AnglesToForward( angles );
		right = AnglesToRight( angles );
		up = ( 0, 0, 1 );
		
		level.river_heli.node_pos = level.main_barge.origin + fwd * level.heli_barge_path_offset[0] - right * level.heli_barge_path_offset[1] + up * level.heli_barge_path_offset[2];
		level.river_heli.node_angles = angles + level.heli_barge_path_start.angles;
		
		if ( IsDefined( level.river_heli.path_move ) )
		{
			level.river_heli PathMove( level.heli_barge_path_start, level.river_heli.node_pos, level.river_heli.node_angles );
		}
		
		wait( 0.05 );
	}
	
}

#define SPEED_MATCH_DIST_X 1000
#define SPEED_MATCH_DIST_Y 5000	
heli_match_best_boat_speed()
{
	self endon( "death" );
	self endon( "end_speed_match" );
	
	while ( 1 )
	{
		best_boat = undefined;
		best_boat_dist = 999999;
		
		vehicles = GetVehicleArray();
		foreach( vehicle in vehicles )
		{
			if ( vehicle.vehicleclass == "boat" && !IsDefined( vehicle.b_no_speed_match ) && vehicle.health > 0 )
			{
				delta = self.origin - vehicle.origin;
				VEC_SET_Z( delta, 0 );
				
				angles = vehicle.angles;
				VEC_SET_X( angles, 0 );
				VEC_SET_Z( angles, 0 );				
				
				fwd = AnglesToForward( angles );
				right = AnglesToRight( angles );
				
				dist = Abs( VectorDot( delta, fwd ) );
				dist_y = Abs( VectorDot( delta, right ) );
				
				//Print3d( vehicle.origin + ( 0, 0, 100 ), "Dist X: " + dist + " Dist Y: " + dist_y, ( 1, 1, 1 ), 1, 1, 1 );
				
				if ( dist < SPEED_MATCH_DIST_X && dist_y < SPEED_MATCH_DIST_Y && dist < best_boat_dist )
				{
					best_boat_dist = dist;
					best_boat = vehicle;
				}
			}	
		}
		
		if ( IsDefined( best_boat ) )
		{
			speed = best_boat GetSpeedMPH();
			//Print3d( vehicle.origin + ( 0, 0, 150 ), "Speed: " + speed, ( 1, 1, 1 ), 1, 1, 1 );			
			//Line( level.river_heli.origin, best_boat.origin, ( 1, 1, 0 ), false, 1 );	
			self SetSpeed( speed + 2 );
		}
		else
		{
			self SetSpeed( level.max_river_heli_speed );
		}
		
		wait( 0.05 );		
	}
}

stop_boat_on_damage()
{
	self waittill("damage");
	
	if ( IsDefined( self ) )
		self setspeed(0);
	
}

fire_machine_gun_on( target )
{
	self maps\_turret::set_turret_target(target, (0, 0, -50), 1);
    self maps\_turret::set_turret_target(target, (0, 0, -50), 2);	
    self maps\_turret::set_turret_target(target, (0, 0, -50), 3);
   	self maps\_turret::set_turret_target(target, (0, 0, -50), 4);
    
   	wait(0.5);
    self thread maps\_turret::fire_turret_for_time(6, 1);
    self thread maps\_turret::fire_turret_for_time(6, 2);
    self thread maps\_turret::fire_turret_for_time(5, 3);
    wait(0.5);
    self thread maps\_turret::fire_turret_for_time(5, 4);
}

river_heli_crash_animation()
{
	main_barge = getent("main_barge", "targetname");
	main_barge.animname = "main_barge";
	
	level.escort_boat.animname = "player_gun_boat";
	
	fake_body = spawn("script_model", (0, 0, 0));
	fake_body setmodel("c_usa_woods_panama_viewbody");
	fake_body.animname = "player_body_river";
	fake_body.targetname = "player_body_river";
	fake_body linkto(main_barge);
	
	level.escort_boat notify( "kill_sway" );
	level.escort_boat LinkTo( main_barge );
	
	level notify( "heli_ride_done" );
//	StopAllRumbles();
	
	level.player shellshock( "default", 3);
	level.player PlayRumbleOnEntity("explosion_generic");
	level.player TakeAllWeapons();
	
	clear_all_guards_on_medium_boat();
	
	level.player PlayerSetGroundReferenceEnt(undefined);
	
	run_scene("heli_hit_by_missile");
	
	level.player notify( "walking_plank_event_over" );
	
	transfer_player_to_heli();
	
	level thread run_scene("heli_hold_steady");
	
	set_objective( level.OBJ_TAKE_OUT_ESCORT, undefined, "done");
	set_objective( level.OBJ_TAKE_OUT_ESCORT, undefined, "remove");
	
	level.player notify( "give_player_weapon_back" );
	
	wait(0.05);
	
	weapons = level.player GetWeaponsListPrimaries();
	if ( weapons.size > 0 )
	{	
		level.player SwitchToWeapon(weapons[0]);
	}

	StopAllRumbles();
	
	spawners = getent("river_barge_convoy_2_guards_assault", "targetname");
	machete_dude = simple_spawn_single(spawners);
	machete_dude thread magic_bullet_shield();
	machete_dude.animname = "machete_dude";
	machete_dude attach("t6_wpn_machete_prop", "tag_weapon_left");
	machete_dude linkto(main_barge);	
	machete_dude thread stop_magic_bullet_shield();
	
	level.hudson linkto(main_barge);
	
	end_scene( "heli_hold_steady" );
	
	level notify("hel_alrm_off");
	level.player DisableWeapons();
	
	level clientnotify ("alouette_jumped");
	
	level thread heli_crash_audio();
	//level.escort_boat thread barge_audio();//kevin adding audio to main barge while plr is on it
	level thread run_scene("player_jump_on_boat");

	level waittill("machete_guy_dead");
	
	scene_wait("player_jump_on_boat");	
}

heli_crash_audio()
{
	wait (1);
	fake_heli_snd = spawn ("script_origin", level.river_heli.origin);
	fake_heli_snd linkto(level.river_heli);
	fake_heli_snd playloopsound("evt_heli_crash_loop", 2);
	wait (9);
	fake_heli_snd playsound("evt_heli_crash");
	
	wait (3);
	fake_heli_snd stoploopsound(.5);
	fake_heli_snd stopsound("evt_heli_crash");
	fake_heli_snd playsound( "evt_heli_river_exp" );
	wait (5);
	fake_heli_snd delete();
}

barge_audio(alias)
{
	sound_ent = spawn( "script_origin" , self.origin);
	sound_ent linkto(self);
	sound_ent PlayLoopSound( alias , .05 );
	level waittill("stop_boat_audio");
	sound_ent StopLoopSound(.1);
}

transfer_player_to_heli()
{
	level.player allowstand(false);
	level.player SetStance("crounch");
	level.player Setorigin(level.river_heli.player_transfer_location.origin );
	level.player SetPlayerAngles((0, 180, 0));
}

convoy_one()
{
	set_objective( level.OBJ_LOCATE_CONVOY, undefined );
	
	medium_barge_spawner = "river_pbr_spawner";
	small_barge_spawner = "river_pbr_patrol_spawner";
	
	path_node_start_boat = getvehiclenode("intro_river_boat_path", "targetname");
	path_node_start_heli = getvehiclenode("intro_heli_path", "targetname");	
	
	barge = getent("river_barge_convoy_1", "targetname");
	barge SetMovingPlatformEnabled( true );
	
	guard_spawner = getentarray("river_barge_convoy_1_guards", "targetname");
	for ( i = 0; i < guard_spawner.size; i++ )
	{
		guard_spawner[i] linkto( barge );
	}

	barge_hind = getent("barge_hind", "targetname");
	barge_hind linkto( barge );
	barge_hind.do_scripted_crash = false;
	barge_hind.health = 100;
	barge_hind notify( "nodeath_thread" );
	barge_hind thread damage_barge_hind();
	
	barge thread go_path(path_node_start_boat);
	
	// Spawn the river boats
	level thread populate_river_boats();

	// setup the player
	level thread setup_river_player();
	
	wait( 6 );
	
	medium_boat = spawn_vehicle_from_targetname(medium_barge_spawner);
	medium_boat PathFixedOffset( ( -600, 600, 0 ) );
	medium_boat thread go_path(path_node_start_boat);
	medium_boat thread boat_river_bob();
	medium_boat thread fire_weapon_on_heli();	
	
	guards = simple_spawn( "river_barge_convoy_1_guards", ::guard_setup );	
	barge guards_death_monitor( guards );	
}

convoy_main()
{
	for ( i = 0; i < level.escort_boat_small.size; i++ )
	{
		level.escort_boat_small[i] thread fire_weapon_on_target( level.river_heli );
	}
	
	level.escort_boat thread fire_weapon_on_heli();
	level.escort_boat_2 thread fire_weapon_on_heli();
	level.escort_boat_3 thread fire_weapon_on_heli();
	
	level.escort_boat.b_no_speed_match = true;

	level thread spawn_guard_on_wave_3();	
	
	level waittill( "rear_escort_dead" );
	
	autosave_by_name( "angola_river" );	
	
	level.river_heli waittill( "goal" );
	
	cleanup_river_intro_boats();
	
	set_objective( level.OBJ_LOCATE_CONVOY, undefined, "done" );
	set_objective( level.OBJ_TAKE_OUT_ESCORT);
	
	level.river_heli waittill( "start_heli_crash" );

	PlayFXOnTag(level._effect[ "ship_explosion" ], level.river_heli, "tag_body");
	PlayFXOnTag(level._effect[ "heli_fire" ], level.river_heli, "tag_body");
}

heli_jump()
{
	level.escort_boat PathFixedOffsetClear();
	level.escort_boat PathVariableOffsetClear();

	level.river_heli linkto( level.main_barge );

	// Fire the magic missile	
	passenger_side = level.player.origin + VectorNormalize( level.river_heli.velocity ) * 150;
	MagicBullet("rpg_magic_bullet_sp", level.main_barge.origin + (-200, -150, 120), passenger_side);
	
	// TODO: Make magic missile track player heli so it always hits
	wait( 1 );
	
	// Run the animation all the way down to the escort boat
	// TODO: Make this one seamless animation
	river_heli_crash_animation();
	
	level.player EnableWeapons();
	level.escort_boat setspeed(30);
	
	level.player allowstand(true);
	level.player SetStance("stand");
	level.player unlink();
	
	level thread cleanup_river_lance_trash();
	
	level notify( "player_on_escort_boat" );	
	
	autosave_by_name( "angola_2_river" );
	
//	level thread chase_sequence_fail_state();
	
	level notify( "river_heli_delete" );
	level.river_heli delete();

	level.main_barge thread go_path( GetVehicleNode( level.main_barge.nextNode.target, "targetname" ) );
	level.main_barge setspeed( 50 );
	
	level.hudson LinkTo( level.escort_boat );
	level.escort_boat Unlink();
	level.escort_boat getoffpath();
	
	wait( 0.05 );
	
	run_scene("hudson_walk_to_wheel_origin");
	
	level thread run_scene("hudson_drive_wheel");
	level thread run_scene("hudson_idle_wheel");
	
	set_objective( level.OBJ_DESTROY_PURSUING_BOAT ); 

	wait( 3 );
	
	level thread barge_chase_boats( level.main_barge.origin );
	
	level.escort_boat setspeed( 75, 20 );	
	level.escort_boat thread escort_boat_follow( level.main_barge );
}

barge_ram()
{
	/#
		iprintlnbold("Hudson: Grab a weapon and get your ass up here!" );
	#/
	end_scene("hudson_idle_wheel");
	end_scene("hudson_drive_wheel");
	
	level thread run_scene("hudson_idle_steering");
	
	set_objective( level.OBJ_DESTROY_PURSUING_BOAT, undefined, "done" ); 
	set_objective( level.OBJ_HEAD_TO_WHEEL_HOUSE, level.hudson ); 
	
	//level.escort_boat.supportsAnimScripted = 1;
	
	level.main_barge SetSpeed( 40 );
	
	level thread spawn_guard_on_wave_1();
	level thread make_guards_fire_on_boat();	
	
	while ( Distance2D( level.escort_boat.origin, level.main_barge.origin ) > 2050 )
	{
		wait( 0.05 );
	}
	
	if ( IsDefined( level.player.viewlockedentity ) )
	{
		level.player.viewlockedentity UseBy( level.player );
	}
	
	wait( 0.05 );
	
//	brace_trigger = getent("boat_ram_brace_trigger", "targetname");
//	brace_trigger waittill("trigger");
	
	/#
		iprintlnbold("Brace yourself, I'm going to ram the barge!");
	#/	
	
	level notify( "player_ram_boat_start" );
	end_scene("hudson_idle_steering");
	
	set_objective( level.OBJ_HEAD_TO_WHEEL_HOUSE, level.hudson, "done" ); 
	
	main_barge = getent("main_barge", "targetname");
	level.escort_boat linkto( main_barge );
	
	level thread run_scene("boat_ram_barge_player");
	level thread run_scene("boat_ram_barge_medium_boat");
	
	level.escort_boat HidePart("tag_glass");
	level.escort_boat ShowPart("tag_glass_shattered");

	level thread maps\angola_barge::setup_enemy_boat_ramming( 6 );
	
	run_scene("boat_ram_barge_hudson");
	
	PlayFXOnTag(level._effect[ "medium_boat_explosion" ], level.escort_boat, "tag_origin");
	level.escort_boat playsound( "exp_veh_large" );
	
	run_scene("bye_bye_gun_boat");
	
	level notify( "prison_barge_event_start" );
	
	level.escort_boat delete();
}

escort_boat_follow( follow_ent )
{
	self endon( "death" );
	
	while ( 1 )
	{
		self SetVehGoalPos( follow_ent.nextNode.origin, 1, 1 );
		wait( 2 );
	}
}

barge_chase_boats( start_origin )
{
	const num_boats = 2;

	offsets = [];
	offsets[0] = ( -500, -700, 0 );
	offsets[1] = ( 350, 650, 0 );	
	offsets[2] = ( 1500, -850, 0 );
	offsets[3] = ( 1250, 1000, 0 );	
	
	level.chase_boats_slots = [];
	level.chase_boats_slots[0] = ( 5000, 1500, 0 );
	level.chase_boats_slots[1] = ( 4000, 1000, 0 );	
	level.chase_boats_slots[2] = ( 4000, -1000, 0 );		
	
	for ( i = 0; i < num_boats; i++ )
	{
		boat = spawn_vehicle_from_targetname( "barge_chase_small" );
		
		new_pos = start_origin + offsets[i];
		VEC_SET_Z( new_pos, start_origin[2] - 25 );		
		          
		boat.origin = new_pos;
		
		delta = level.escort_boat.origin - boat.origin;
		VEC_SET_Z( delta, 0 );
		
		yaw = VectorToAngles( VectorNormalize( delta ) )[1];
		boat SetPhysAngles( ( 0, yaw, 0 ) );

		boat thread barge_chase_boat_think( offsets[i], i );
	
		wait( 1.0 );
	}
	
	new_pos = start_origin + offsets[2];
	
	boat = spawn_vehicle_from_targetname( "barge_chase_medium" );	          
	boat.origin = new_pos;
	
	delta = level.escort_boat.origin - boat.origin;
	VEC_SET_Z( delta, 0 );
	
	yaw = VectorToAngles( VectorNormalize( delta ) )[1];
	boat SetPhysAngles( ( 0, yaw, 0 ) );	

	boat thread barge_chase_boat_think( ( 0, 0, 0 ), 2 );
}

barge_chase_boat_think( offset, id )
{
	self endon( "death" );
	level endon( "prison_barge_event_start" );
	
	self PathFixedOffset( offset );
	
	self thread barge_chase_boat_delete();
	self thread boat_river_bob();
	self thread barge_chase_boat_fire( level.escort_boat );
	
	self SetSpeed( 80, 35 );
	
	wait( 12 );
	
	while ( 1 )
	{
		position = level.escort_boat.origin + AnglesToForward( level.escort_boat.angles ) * level.chase_boats_slots[id][0] + AnglesToRight( level.escort_boat.angles ) * level.chase_boats_slots[id][1];
		self SetVehGoalPos( position );
		
		Line( self.origin, position, ( 1, 1, 0 ), 1, false, 10 );
				
		wait( 0.5 );
	}
}

barge_chase_boat_fire( target )
{
	self endon( "death" );
	
	self set_turret_target( target, ( 0, 0, 30 ), 1 );
	while ( 1 ) 
	{
		self fire_turret_for_time( RandomIntRange( 3, 5 ), 1 );
		wait( RandomIntRange( 1, 3 ) );
	}	
}

barge_chase_boat_delete()
{
	self endon( "death" );
	level waittill( "prison_barge_event_start" );
	self Delete();
}

setup_main_convoy()
{
	path_node_start_boat = getvehiclenode("main_convoy_start_node", "targetname");

	// Setup the main barge
	level.main_barge thread setup_barge( path_node_start_boat, 7 );
	
	// Misc escort boat stuff
	level.escort_boat thread barge_audio("veh_barge_engine_high_plr");//kevin adding audio to main barge while plr is on it	
	level.escort_boat HidePart("tag_glass_shattered");
	level.escort_boat thread veh_magic_bullet_shield(1);
	level.escort_boat thread setup_animation_trigger_on_escort_boat();
	level.escort_boat thread setup_rpg_crate_and_trigger();
	
	// Setup up the other escort boats
	level.escort_boat thread setup_escort_boat( path_node_start_boat, 14, ( 0, 1250, 0 ), "main_convoy_escort_boat_medium_1_guard" );
	level.escort_boat_2 thread setup_escort_boat( path_node_start_boat, 14, ( 700, -1250, 0 ), "main_convoy_escort_boat_medium_2_guard" );	
	level.escort_boat_3 thread setup_escort_boat( path_node_start_boat, 29, (0, -650, 0), "main_convoy_escort_boat_medium_4_guard" );		

	// Setup the small boats
	level.escort_boat_small[0] thread setup_small_boat( path_node_start_boat, undefined, ( 0, 200, 0 ) );
	level.escort_boat_small[1] thread setup_small_boat( path_node_start_boat, 22, ( 250, -100, 0 ) );
	
	// Misc threads
	level thread rear_convoy_boat_death_monitor( level.escort_boat_3, undefined, "rear_escort_dead" );
}

populate_river_boats()
{
	const num_river_boats = 2;
	
	start_nodes = getvehiclenodearray("river_scatter_boat_node", "targetname");
	
	for ( i = 0; i < num_river_boats; i++ )
	{
		boat = spawn_vehicle_from_targetname( "random_small_boat_spawner" );			
		boat thread setup_small_boat( start_nodes[i] );
	}
}

setup_barge( start_node, path_start_delay )
{
	self thread barge_audio("veh_barge2_engine_high_plr");//kevin playing boat audio
	self.b_no_speed_match = true;
	
	hind_fly_path = getentarray("hind_fly_path", "script_noteworthy");
	
	for(i = 0; i < hind_fly_path.size; i++)
	{
		hind_fly_path[i] linkto(self);
	}

	side_lookat_trigger = getent("side_damage_lookat", "targetname");
	side_lookat_trigger EnableLinkTo();
	side_lookat_trigger linkto(self);
	
	reinforcement_trigger = getent("side_reinforcement_lookat", "targetname");
	reinforcement_trigger enablelinkto();
	reinforcement_trigger linkto(self);
	
	woods_container = getent("woods_container", "targetname");
	woods_container.animname = "woods_container";
	woods_container linkto( self );
	
	container_clip = getent("woods_container_clip", "targetname");
	container_clip linkto(woods_container);

//	stinger_truck_trigger = getent("stinger_truck_trigger", "targetname");
//	stinger_truck_trigger EnableLinkTo();
//	stinger_truck_trigger linkto(self);
//	stinger_truck_trigger trigger_off();
//	stinger_truck_trigger SetCursorHint("hint_noicon");
	
	woods_truck_trigger = getent("woods_truck_trigger", "targetname");
	woods_truck_trigger EnableLinkTo();
	woods_truck_trigger linkto(self);
	woods_truck_trigger trigger_off();
	woods_truck_trigger SetCursorHint("hint_noicon");

	gaz_truck = getent("gaz_trucks" ,"script_noteworthy");
	gaz_truck GodOn();
	gaz_truck thread use_gaz_gunner();

	gaz_truck_origin = getstruct( "barge_truck_origin", "targetname" );
	offset = gaz_truck_origin.origin - level.main_barge.origin;
	
	gaz_truck linkto( level.main_barge, "tag_origin", offset );		
	
	clip = getent("strella_truck_clip", "targetname");
	clip linkto(gaz_truck);

	damage_trigger = getent("truck_damage_trigger", "targetname");	
	damage_trigger EnableLinkTo();
	damage_trigger linkto( gaz_truck );
	damage_trigger thread obj_fail_if_truck_takes_damage();
	
	fake_fire_origin = getentarray("fake_fire_origin", "targetname");
	for(i = 0; i < fake_fire_origin.size; i++)
	{
		fake_fire_origin[i] linkto(self);
	}
	
	self SetMovingPlatformEnabled( true );
	
	barge_origin_struct = spawn("script_origin", level.main_barge GetTagOrigin("tag_origin") );
	barge_origin_struct linkto( self, "tag_origin" );
	barge_origin_struct.targetname = "barge_origin_struct";
	
	fake_gaz = getent( "woods_lighting_truck", "targetname" );
	fake_gaz Attach( "veh_t6_mil_gaz66_cargo", "tag_bed_troops" );
	fake_gaz = getent( "stinger_lighting_truck", "targetname" );
	fake_gaz Attach( "veh_t6_mil_gaz66_cargo", "tag_bed_troops" );
	
	if ( IsDefined( start_node ) )
	{
		if ( IsDefined( path_start_delay ) )
		{
			wait( path_start_delay );	
		}
	
		self thread go_path( start_node );	
	}
}

setup_escort_boat( start_node, start_path_delay, path_fixed_offset, spawner_targetname )
{
	self endon( "death" );
	
	self SetMovingPlatformEnabled( true );	
	self thread play_damage_fx_on_boat();
	self thread boat_river_bob();
	
	// Link spawners to the boat
	if ( IsDefined( spawner_targetname ) )
	{
		guard_spawner = getentarray(spawner_targetname, "targetname");
		for(i = 0; i < guard_spawner.size; i++)
		{
			guard_spawner[i] linkto( self );
		}
	}
	
	// Offset from the spline
	if ( IsDefined( path_fixed_offset ) ) 
	{
		self.spline_offset = path_fixed_offset[1];
		self PathFixedOffset( path_fixed_offset );
	}
	
	// Start Path
	if ( IsDefined( start_node ) )
	{
		if ( IsDefined( start_path_delay ) )
		{
			wait( start_path_delay );
		}
		
		self thread go_path( start_node );	
	}
}

setup_small_boat( start_node, start_path_delay, path_fixed_offset )
{
	self endon( "death" );
	
	self thread fire_weapon_on_target( level.river_heli );
	self thread escort_boat_challenge_tracking();
	self thread boat_river_bob();

	self.dont_kill_riders = true;	
	
	if ( IsDefined( path_fixed_offset ) )
	{
		self.spline_offset = path_fixed_offset[1];
		self PathFixedOffset( path_fixed_offset );
	}
	
	if ( IsDefined( start_node ) )
	{
		if ( IsDefined( start_path_delay ) )
		{
			wait( start_path_delay );
		}
		
		self thread go_path( start_node );		
	}
}

rear_convoy_boat_death_monitor( boat1, boat2, death_notify )
{
	boats = [];
	
	if ( IsDefined( boat1 ) )
		boats[ boats.size ] = boat1;
	
	if ( IsDefined( boat2 ) )
		boats[ boats.size ] = boat2;		
	
	array_wait( boats, "death" );
	
	level notify( death_notify );
}

fire_weapon_on_heli( str_notify, ent = undefined )
{
	self endon("death");
	guards = simple_spawn("main_convoy_escort_boat_medium_1_guard", ::guard_setup);
	
	if ( !IsDefined( ent ) )
		ent = level.river_heli;
	
	if(isdefined(guards[0]))
	{
		guards[0] enter_vehicle(self, "tag_gunner1");
	}
	//guards[0] thread play_death_fx_on_turret( self, "tag_gunner1" );
	
	if(isdefined(guards[1]))
	{
		guards[1] enter_vehicle(self, "tag_gunner2");
	}
	//guards[1] thread play_death_fx_on_turret( self, "tag_gunner2");
	
	if( isdefined( str_notify ) )
	{
		level waittill( "str_notify" ) ;
	}

	self maps\_turret::set_turret_target(ent, (0, 0, -40), 1);
	self maps\_turret::set_turret_target(ent, (0, 0, -40), 2);
	while(1)
	{
		if( isalive(guards[0]) )
		{
			self thread maps\_turret::fire_turret_for_time(1, 1);
		}
		else
		{
			self maps\_turret::clear_turret_target(1);
		}
		
		if( isalive(guards[1]) )
		{
			self thread maps\_turret::fire_turret_for_time(1, 2);
		}
		else
		{
			self maps\_turret::clear_turret_target(2);	
		}
		
		if(!isalive( guards[0] ) && !isalive(guards[1]))
		{
			break;
		}
		
		wait(1);
	}
}


// WTF!!!!!!!!!!!
fire_weapon_on_ent( str_notify, ent )
{
	self endon("death");
	guards = simple_spawn( "main_convoy_escort_boat_medium_1_guard" );
	
	if(isdefined(guards[0]))
	{
		guards[0] enter_vehicle(self, "tag_gunner1");
	}
	//guards[0] thread play_death_fx_on_turret( self, "tag_gunner1" );
	
	if(isdefined(guards[1]))
	{
		guards[1] enter_vehicle(self, "tag_gunner2");
	}
	//guards[1] thread play_death_fx_on_turret( self, "tag_gunner2");
	
	if( isdefined( str_notify ) )
	{
		level waittill( "str_notify" ) ;
	}

	self maps\_turret::set_turret_target(ent, (0, 0, -40), 1);
	self maps\_turret::set_turret_target(ent, (0, 0, -40), 2);
	while(1)
	{
		if( isalive(guards[0]) )
		{
			self thread maps\_turret::fire_turret_for_time(1, 1);
		}
		else
		{
			self maps\_turret::clear_turret_target(1);
		}
		
		if( isalive(guards[1]) )
		{
			self thread maps\_turret::fire_turret_for_time(1, 2);
		}
		else
		{
			self maps\_turret::clear_turret_target(2);	
		}
		
		if(!isalive( guards[0] ) && !isalive(guards[1]))
		{
			break;
		}
		
		wait(1);
	}
}

guard_setup()
{
	self endon("death");
	level endon("kill_all_on_turret");
	
	heli_target = getent("heli_target_origin", "targetname");
	
	self SetEntityTarget( level.river_heli );
	
	if ( IsDefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" );
		self forceteleport( node.origin, node.angles );
	}	
}

guards_death_monitor( guards )
{
	self endon( "death" );
	
	array_wait( guards, "death" );
	
	self.b_no_speed_match = true;
	
	level.river_heli thread river_heli_speed_control();
	level notify( "convoy_one_dead" );
}

river_heli_speed_control()
{
	self endon( "death" );
	
	level.max_river_heli_speed = 90;
	wait( 3 );
	level.max_river_heli_speed = 75;	
}

kill_self_if_falls()
{
	self endon("death");
	
	while(1)
	{
		if(self.origin[2] < 50)
		{
			level.num_enemy_falls_off++;
			iprintln(level.num_enemy_falls_off);
			self die();
		}
		
		wait(0.5);
	}
	
}

update_yaw( barge )
{
	while(1)
	{
		self SetGoalYaw(barge.angles[1]);	
		wait(0.5);
	}
	
}

play_death_fx_on_turret( boat, turret )
{
	boat endon("death");
	
	self waittill("death");
	if( isdefined( boat ) )
	{
		PlayFXOnTag(level._effect[ "turret_explosion" ], boat, turret);
	}
}

obj_fail_if_truck_takes_damage()
{
	while(1)
	{
		self waittill("trigger", ent);
	
		if(ent == level.player)
		{
			gaz_truck = getent("gaz_trucks" ,"script_noteworthy");
			PlayFXOnTag(level._effect[ "ship_explosion" ], gaz_truck, "tag_origin" );
			PlayFXOnTag(level._effect[ "ship_fire" ], gaz_truck, "tag_origin");
//			PlayFXOnTag(level._effect[ "ship_explosion" ], gaz_truck[1], "tag_origin" );
//			PlayFXOnTag(level._effect[ "ship_fire" ], gaz_truck[1], "tag_origin");
			wait(2);
			missionfailedwrapper( &"ANGOLA_2_TRUCK_DESTROY" );
		}
		
		wait(0.5);
	}
}

boat_adjusting()
{
//	level.escort_boat thread boat_realistic_tweaking();

	level.escort_boat thread boat_swaying();
//	wait(1);
//	level.escort_boat_2 thread boat_realistic_tweaking();
//	level.escort_boat_2 thread veh_magic_bullet_shield(1);
	level.escort_boat_2 thread boat_swaying();
	
	//	wait(1);
//	level.escort_boat_4 thread boat_realistic_tweaking();
//	level.escort_boat_4 thread veh_magic_bullet_shield(1);
	level.escort_boat_4 thread boat_swaying();

	wait(1);
	
	for(i = 0; i < level.escort_boat_small.size; i++)
	{
//		level.escort_boat_small[i] thread boat_realistic_tweaking();
		level.escort_boat_small[i] thread boat_swaying();
		wait(1);
	}
	
}

boat_swaying()
{
	self endon( "kill_sway" );
	self endon( "death");
	while(1)
	{
		num = 150;
		self set_boat_swaying(num);
		self set_boat_swaying(num * -1);
		self set_boat_swaying(num * -1);
		self set_boat_swaying(num);
	}
	
}

set_boat_swaying(num)
{
	self endon( "kill_sway" );
	self endon("death");
	
	moverate = num / 60;
	movement = 0;
	for(i = 0; i < 60; i++)
	{
		movement += moverate;
		self PathFixedOffset((0, self.spline_offset + movement, 0 ));
		wait(0.05);
	}
	self.spline_offset += movement;
	
}

attach_all_origin_to_boat()
{
	a_origin = getentarray("convoy_spawn_spot", "script_noteworthy");
	main_barge = getent("main_barge", "targetname");
	
	for(i = 0; i < a_origin.size; i++)
	{
		a_origin[i] linkto( main_barge );
	}
}

spawn_boat_guys( boat, spawners, wave_location, array_death_notify = undefined )
{
	spawn_nodes = GetNodeArray( wave_location, "targetname" );
	
	guys = [];
	foreach( i, node in spawn_nodes )
	{
		spawner = spawners[ ( i + 1 ) % 2 ];
		
		guy = simple_spawn_single( spawner );
		guys[ guys.size ] = guy;
		
		guy forceteleport( spawn_nodes[i].origin, spawn_nodes[i].angles );
		
		wait(0.05);

		guy SetGoalNode( spawn_nodes[i] );
		//guy.goalradius = 1024;		
	}
	
	if ( IsDefined( array_death_notify ) )
	{
		array_wait( guys, "death" );
	
		level notify( array_death_notify );
	}
}

spawn_guard_on_wave_1()
{
	spawn_location = getnodearray("first_wave_spawn_location" ,"targetname");
	node = getnode("barge_goal_node", "targetname");
	
	level.main_barge_guard = [];
	for(i = 0; i < spawn_location.size; i++)
	{
		cur_spawner = level.barge_spawners[ ( i +  1 ) % 2 ];
		guard = simple_spawn_single( cur_spawner );
		level.main_barge_guard[ level.main_barge_guard.size ] = guard;
		guard forceteleport( spawn_location[i].origin, spawn_location[i].angles );
		wait(0.05);
		//guard.goalradius = 1024;
		guard SetGoalNode(spawn_location[i]);		
		guard.fixednode = false;	
	}
	
	//iprintlnbold(level.main_barge_guard.size);
	
}

spawn_guard_on_wave_2()
{
	spawn_location = getnodearray("second_wave_spawn_location" ,"targetname");
	node = getnode("barge_goal_node", "targetname");
	
	level.main_barge_guard = array_removedead(level.main_barge_guard);
	
	for(i = 0; i < spawn_location.size; i++)
	{
		cur_spawner = level.barge_spawners[ ( i +  1 ) % 2 ];
		guard = simple_spawn_single( cur_spawner );
		level.main_barge_guard[ level.main_barge_guard.size ] = guard;
		guard forceteleport( spawn_location[i].origin, spawn_location[i].angles );
		wait(0.05);
		//guard.goalradius = 1024;
		guard SetGoalNode(spawn_location[i]);
		
		if(cur_spawner.targetname == "river_barge_convoy_2_guards_assault")
		{
			guard SetEntityTarget( level.river_heli );
		}
		
		guard.fixednode = false;
	}
	
	//iprintlnbold(level.main_barge_guard.size);
}

spawn_guard_on_wave_3()
{
	spawn_location = getnodearray("third_wave_spawn_location" ,"targetname");
	spawners = [];
	spawners[0] = getent("river_barge_convoy_2_guards_launcher", "targetname");
	spawners[1] = getent("river_barge_convoy_2_guards_launcher", "targetname");
	node = getnode("barge_goal_node", "targetname");
	
	if(isdefined(level.main_barge_guard))
	{
		level.main_barge_guard = array_removedead(level.main_barge_guard);
	}
	else
	{
		level.main_barge_guard = [];
	}
	//iprintlnbold(level.main_barge_guard.size);
	for(i = 0; i < spawn_location.size; i++)
	{
		cur_spawner = spawners[ ( i +  1 ) % 2 ];
		guard = simple_spawn_single( cur_spawner );
		level.main_barge_guard[ level.main_barge_guard.size ] = guard;
		guard forceteleport( spawn_location[i].origin, spawn_location[i].angles );
		wait(0.05);
		//guard.goalradius = 1024;
		guard SetGoalNode(spawn_location[i]);
		
		if(cur_spawner.targetname == "river_barge_convoy_2_guards_launcher")
		{
			guard SetEntityTarget( level.river_heli );
		}
		guard.fixednode = false;
	}
	
	//iprintlnbold(level.main_barge_guard.size);
}

hudson_dialog()
{
	level waittill("hudson_attack_convoy");
	add_temp_dialog_line("Hudson", "We have located the MPLA convoy ahead, it might be the one with Woods.", 3);
	wait(3);
	add_temp_dialog_line("Mason", "Look like this barge is carrying arms and a Hind.", 3);
	wait(3);
	add_temp_dialog_line("Hudson", "They are firing on us, hold on tight.");

	level waittill("hudson_missile_jam");
	add_temp_dialog_line("Hudson", "Shit, our missile pods are hit!!.", 2);
	wait(3);
	add_temp_dialog_line("Mason", "Leave this barge, looks like it won't be following us any time soon.", 2);
	wait(3);
	
	level waittill("hudson_convoy_location_one");
	/#
	iprintlnbold("Do not Shoot the Trucks, Woods might be in one!!!");
	#/
	add_temp_dialog_line("Hudson", "We are pulling up to the bigger convoy, I see some trucks on the barge.", 2);
	wait(3);
	add_temp_dialog_line("Hudson", "Mason, there is a MGL and a Barret in the back, I try to keep the heli steady for you.", 2);
	wait(2);
	add_temp_dialog_line("Hudons", "Try to avoid blowing up those gaz trucks, Woods might in one.");
	wait(2);
	add_temp_dialog_line("Hudons", "Take care of the smaller boats first.");
	level waittill("hudson_convoy_location_two");
	add_temp_dialog_line("Hudson", "they almost smoked me there, moving to a better location", 2);
	wait(2);
	add_temp_dialog_line("Hudons", "They are manning the AA gun on the medium boat, take them out.");
	level waittill("hudson_convoy_location_three");
	add_temp_dialog_line("Hudson", "They must really want that barge, MPLA is putting up a good fight, I hope this is worth it", 2);
	wait(2);
	add_temp_dialog_line("Hudson", "Shit!! RPG fire, take them out quick, we are close enough for them to land some lucky shot.", 2);
}

#using_animtree( "vehicles" );
strella_guard_run()
{
	spawners = getent("river_barge_convoy_2_guards_assault", "targetname");
	start_node = getnode("strella_guard_start", "targetname");
	strella_guard = simple_spawn_single( spawners);
	strella_guard.animname = "strella_guy";	
	strella_guard forceteleport( start_node.origin, start_node.angles );
	gaz66 = getent("strella_truck", "targetname");
	gaz66 UseAnimTree(#animtree);
	gaz66 setanim( %vehicles::v_ang_05_03_ghaz_cargo_open_cargo, 1, 0, 1);
	//level thread run_scene("strella_guard_run_truck");
	//level thread run_scene("strella_guard_run");
	
}

setup_rpg_crate_and_trigger()
{
	level endon( "prison_barge_event_start" );
	
	rpg_crates = getentarray("medium_boat_rpg_crates", "targetname");
	rpg = getentarray("medium_boat_rpg_spawn", "targetname");
	rpg_crate_clip = getent("rpg_crate_clip", "targetname");
	rpg_crate_clip SetMovingPlatformEnabled( true );
	
	rpg_crate_clip linkto( self );
	for( i = 0 ; i < rpg_crates.size; i++)
	{
		rpg_crates[i] linkto( self );
		//rpg_crates[i] SetMovingPlatformEnabled( true );
	}
	
	for( i = 0 ; i < rpg.size; i++)
	{
		rpg[i] linkto( self );
	}
	rpg_trigger = getent("medium_boat_rpg", "targetname");
	rpg_trigger setCursorHint( "HINT_NOICON" );
	rpg_trigger EnableLinkTo();
	rpg_trigger linkto(self);
	rpg_trigger SetMovingPlatformEnabled( true );
	
	level waittill( "player_on_escort_boat" );

	rpg_trigger SetHintString( &"Angola_2_RPG_TRIGGER" );
	
	while(1)
	{
		rpg_trigger waittill("trigger");
		weapons = level.player GetWeaponsListPrimaries();
		
		level.player DisableWeapons();
		
		for(i = 0; i < weapons.size; i++)
		{
			level.player giveMaxAmmo(weapons[i]);
			level.player SetWeaponAmmoClip(weapons[i], level.player GetWeaponAmmoClip(weapons[i]) );
		}
		
		wait(2);
		level.player EnableWeapons();
		wait(0.05);
	}
}

setup_animation_trigger_on_escort_boat()
{
	trigger = getent( "boat_ram_brace_trigger", "targetname" );
	trigger EnableLinkTo();
	trigger SetMovingPlatformEnabled( true );
	trigger linkto( self );
	
	trigger = getent("boat_ram_player_jump_trigger", "targetname");
	trigger EnableLinkTo();
	trigger linkto( self );
}

clear_all_guards_on_medium_boat()
{
	level notify( "kill_all_on_turret" );
	guards = get_ai_array("main_convoy_escort_boat_medium_1_guard_ai", "targetname");
	
	for(i = 0; i < guards.size; i++)
	{
		guards[i] die();
		guards[i] delete();
	}
	
	guards = get_ai_array("main_convoy_escort_boat_medium_2_guard_ai", "targetname");
	
	for(i = 0; i < guards.size; i++)
	{
		guards[i] die();
		guards[i] delete();
	}
	
	guards = get_ai_array("main_convoy_escort_boat_medium_3_guard_ai", "targetname");
	
	for(i = 0; i < guards.size; i++)
	{
		guards[i] die();
		guards[i] delete();
	}
	
	guards = get_ai_array("main_convoy_escort_boat_medium_4_guard_ai", "targetname");
	
	for(i = 0; i < guards.size; i++)
	{
		guards[i] die();
		guards[i] delete();
	}
	
	guards = get_ai_array("river_barge_convoy_2_guards_launcher_ai", "targetname");
	for(i = 0; i < guards.size; i++)
	{
		guards[i] die();
		guards[i] delete();
	}
}

make_guards_fire_on_boat()
{
	fire_origin = getentarray("fake_fire_origin", "targetname");
	
	for(i = 0; i < 50; i++)
	{
		MagicBullet("m60_sp", fire_origin[RandomInt(3)].origin, level.hudson.origin + (0, 0, 40) );
		wait( RandomFloatRange(0.3, 0.5) );
	}
	
	
}

explosive_death( )
{
	//self endon("death");
	
	self waittill("death");
	
	guard = simple_spawn_single("river_barge_convoy_2_guards_assault");
	guard.animname = "chase_boat_gunner_front";
	guard thread anim_single( guard, "front_death");
	
//	guard = simple_spawn_single("river_barge_convoy_2_guards_assault");
//	guard.animname = "chase_boat_gunner_back";
//	self thread anim_single_aligned( guard, "back_death", "tag_gunner2");
	
}

cleanup_river_intro_barge()
{
	e_trash = getentarray("river_boat_intro_cleanup" ,"script_noteworthy");
	
	for(i = 0; i < e_trash.size; i++)
	{
		e_trash[i] die();
		
		if( isdefined(e_trash[i]) )
		{
			e_trash[i] delete();
		}
	}	
}

cleanup_river_intro_boats()
{
	e_trash = getentarray("river_boat_cleanup" ,"script_noteworthy");
	
	for(i = 0; i < e_trash.size; i++)
	{
		e_trash[i] notify("death");
		//e_trash[i] delete();
	}
}

cleanup_river_lance_trash()
{
	e_trash = getentarray("river_boats_lance_cleanup" ,"script_noteworthy");
	for(i = 0; i < e_trash.size; i++)
	{
		e_trash[i] notify("death");
		e_trash[i] delete();
	}	
}

delete_all_corpse()
{
	level endon("hind_crash");
	while(1)
	{
		wait(20);
		ClearAllCorpses();
	}
}

trigger_gun_flak( )
{
	level endon("heli_ride_done");
	
	while(1)
	{
		flak_spot = get_flak_spot();
		
		type = RandomInt(100);
		if(type < 40 )
		{
			PlayFX(level._effect[ "medium_flak" ], flak_spot);
		}
		else if(type > 60)
		{
			PlayFX(level._effect[ "small_flak" ], flak_spot);
		}
		else
		{
			PlayFX(level._effect[ "large_flak" ], flak_spot);
		}
	
		wait(0.7);
	}
}

get_flak_spot()
{
	main_barge = getent("main_barge", "targetname");
	x = main_barge.origin[0] + RandomIntRange(-1500, 1500);
	y = main_barge.origin[1] + RandomIntRange(-1500, 1500);
	z = main_barge.origin[2] + RandomIntRange(500, 1000);
	
	fx_spot = (x, y, z);
	
	return fx_spot;
}

setup_specialty_perk()
{
	boat = getent("main_convoy_escort_boat_medium_1", "targetname");
	boat attach( "veh_t6_sea_gunboat_medium_waterbox", "tag_origin");
	specialty_trigger = getent("player_turret_special_trigger", "targetname");
	specialty_trigger EnableLinkTo();
	specialty_trigger linkto(boat);
	specialty_trigger SetCursorHint( "HINT_NOICON" );
	specialty_trigger SetHintString( "" );

	level waittill("heli_ride_done");
	
	level.escort_boat SetSeatOccupied(2, true);
	level.player waittill_player_has_brute_force_perk();
	e_obj_location = spawn("script_model", boat GetTagOrigin("tag_gunner2") + (0, 0, 60));
	e_obj_location setmodel("tag_origin");
	e_obj_location linkto(boat);
	
	set_objective( level.OBJ_BRUTE_FORCE, e_obj_location, "interact" );
	specialty_trigger SetHintString( &"ANGOLA_2_UNJAM_GUN" );
	specialty_trigger waittill("trigger");
	set_objective( level.OBJ_BRUTE_FORCE, e_obj_location, "remove" );
	run_scene("player_unlock_gun");
	level.escort_boat SetSeatOccupied(2, false);
	specialty_trigger delete();	
	boat UseVehicle(level.player, 2);
	
	damage_trigger = getent("player_turret_damage_trigger", "targetname");

	while( isdefined( boat ) )
	{
		if( isdefined( boat GetSeatOccupant( 2 ) ) )
		{
			damage_trigger waittill("trigger", amount, attacker, vec);
			level.player DoDamage( 10, (0, 0, 0) );
		}
		
		wait(0.1);
	}

}

update_player_heli_rolling()
{
	level endon("heli_ride_done");
	
	if(!isdefined( level.player.fake_ground_ent ) )
	{
		level.player.fake_ground_ent = spawn("script_model", level.player.origin);
		level.player.fake_ground_ent setmodel("tag_origin");
		level.player.fake_ground_ent.angles = level.player.angles;
		level.player PlayerSetGroundReferenceEnt(level.player.fake_ground_ent);
	}
	
	
	while(1)
	{
		new_angles = (level.river_heli.angles[0], 0, level.river_heli.angles[2] * 0.8);
		level.player.fake_ground_ent.angles = new_angles;
		wait(0.05);
	}
	
}

play_damage_fx_on_boat()
{
	self endon("death");
	count = 0;
	while(1)
	{
		self waittill("damage", amount, attacker, vec, p, type);
		
		if( ( type == "MOD_GRENADE" || type == "MOD_PROJECTILE" || type == "MOD_EXPLOSIVE" ) && count == 0)
		{
			PlayFXOnTag(level._effect[ "medium_boat_damage_1" ], self, "tag_origin");
			count++;
		}
		else if ( ( type == "MOD_GRENADE" || type == "MOD_PROJECTILE" || type == "MOD_EXPLOSIVE" ) && count == 1 )
		{
			PlayFXOnTag(level._effect[ "medium_boat_damage_2" ], self, "tag_origin");	
			count++;
			return;
		}
			
		wait(0.5);
	}	
}

chase_sequence_fail_state( time )
{
	level endon( "player_ram_boat_start" );
	
	wait( 120 );
	
	missionfailedwrapper(&"ANGOLA_2_CHASE_BOAT_FAIL");
}

voice_over_river()
{
	wait(3);
	level.hudson say_dialog("huds_comin_on_the_convoy_0");
	wait(4);
	level.hudson say_dialog("huds_looks_like_a_lot_of_0");
	wait(7);
	level.hudson say_dialog("huds_better_arm_up_0");
	wait(4);
	level.hudson say_dialog("huds_take_out_the_gunboat_0");
	wait(6);
	level.hudson say_dialog("huds_hit_em_mason_0");
	wait(3);
	level.hudson say_dialog("huds_stay_on_em_0");
	wait(6);
	level.hudson say_dialog("huds_the_barge_the_big_0");
	level.hudson say_dialog("huds_i_think_that_s_it_0");
	wait(2);
	level.hudson say_dialog("huds_do_not_fire_on_the_b_0");
	wait(3);
	level.hudson say_dialog("huds_matches_zavimbi_s_in_0");
	wait(3);
	level.hudson say_dialog("huds_pick_off_the_gunboat_0");
	wait(3);
	level.hudson say_dialog("huds_i_ll_try_to_bring_th_0");
	wait(3);
	level.hudson say_dialog("huds_taking_small_arms_fi_0");
	wait(2);
	level.hudson say_dialog("huds_take_em_down_mason_0");
	wait(2);
	level.hudson say_dialog("huds_dammit_we_re_taking_0");
	
}

voice_medium_boat_chase()
{
	level.hudson say_dialog("huds_jump_mason_jump_0");

	level waittill("hel_alrm_off");
	level.hudson say_dialog("huds_go_mason_go_0");
	
	wait(6);
	level.hudson say_dialog("huds_she_s_going_down_ma_0");
	
	wait(8);
	
	
	wait(2);
//	level.hudson say_dialog("huds_get_on_the_rear_gun_0");
//	level.hudson say_dialog("huds_i_l_get_on_the_whee_0");
//	level.hudson say_dialog("huds_we_ve_got_to_catch_u_0");
	
	wait(5);
	level.hudson say_dialog("huds_hold_off_those_gunbo_0");
	
	wait(3);
	level.hudson say_dialog("huds_woods_had_better_be_0");
	
	
	level waittill("medium_boat_chase_sequence_done");
	level.player say_dialog("maso_we_re_clear_0");
	level.hudson say_dialog("huds_get_up_here_i_m_go_0");
	
	wait(3);
	level.player say_dialog("maso_you_re_gonna_what_0");

}

boat_river_bob()
{
	self PathVariableOffset( ( 0, 0, RandomIntRange( 20, 25 ) ), RandomFloatRange( 0.75, 1.25 ) );
}

actor_turret_damage_override( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName  )
{
	//self actor_damage_override( inflictor, attacker, damage, flags, meansofdeath, weapon, vpoint, vdir, sHitLoc, psOffsetTime );
	if(sWeapon == "pbr_gun_turret") 
	{
		iDamage = 0;
	}
	
	
	team = eAttacker.team;
	
	if( isdefined(team) && team == "axis")
	{
		iDamage = 0;	
	}
	
//	if( isdefined( self.targetname) )
//	{
//		if( self.targetname == "hudson" || self.targetname == "woods")
//		{
//			iDamage = 0;
//		}
//	}
	
	return iDamage;
	
	//self finishActorDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime );
}

use_gaz_gunner()
{
	self endon( "death" );
	
	trigger = GetEnt( "use_gaz_trigger", "targetname" );
	trigger EnableLinkTo();	
	trigger LinkTo( self, "tag_origin" );
	
	while ( 1 )
	{
		trigger waittill( "trigger" );
		self UseBy( level.player, 1 );
	}
}

damage_barge_hind()
{
	self SetRotorSpeed( 0 );
	self waittill( "death" );
	self thread maps\_vehicle_death::death_fx();
	RadiusDamage( self.origin, 1000, 1000, 1000, level.player, "MOD_EXPLOSIVE" );
}