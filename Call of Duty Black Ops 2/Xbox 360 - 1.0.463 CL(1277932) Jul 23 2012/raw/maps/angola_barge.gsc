#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\angola_2_util;
#include animscripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

skipto_barge()
{
	level.hudson = init_hero("hudson");
	level.woods = init_hero("woods");
	setup_main_barge();
	wait(0.05);
	teleport_player_to_location( "player_barge_teleport" );
	teleport_hudson_to_location("hudson_barge_teleport");
	cleanup_river_intro_boats();
	VisionSetNaked( "sp_angola_2_river", 0.5 );
	
	level.barge_spawners = [];
	level.barge_spawners[0] = GetEnt( "river_barge_convoy_2_guards_assault", "targetname" );
	level.barge_spawners[1] = GetEnt( "river_barge_convoy_2_guards_assault", "targetname" );	
	level thread maps\angola_river::spawn_guard_on_wave_1();	
}

setup_main_barge()
{
	level.main_barge = getent("main_barge", "targetname");
	level.main_barge thread maps\angola_river::barge_audio("veh_barge2_engine_high_plr");//kevin
	level.main_barge SetMovingPlatformEnabled( true );
	level.main_barge thread veh_magic_bullet_shield(1);
	
	hind_fly_path = getentarray("hind_fly_path", "script_noteworthy");
	
	for(i = 0; i < hind_fly_path.size; i++)
	{
		hind_fly_path[i] linkto(level.main_barge);
	}
	
	side_lookat_trigger = getent("side_damage_lookat", "targetname");
	side_lookat_trigger EnableLinkTo();
	side_lookat_trigger linkto(level.main_barge);
	
	reinforcement_trigger = getent("side_reinforcement_lookat", "targetname");
	reinforcement_trigger enablelinkto();
	reinforcement_trigger linkto(level.main_barge);

	//container
	woods_container = getent("woods_container", "targetname");
	woods_container.animname = "woods_container";
	woods_container linkto(level.main_barge);
	container_clip = getent("woods_container_clip", "targetname");
	container_clip linkto(woods_container);
	
	//damage clip
	side_damage_clip = getent("side_damage_clip", "targetname");
	side_damage_clip linkto_trigger_off();
	side_damage_clip linkto(level.main_barge);
	side_damage_clip SetMovingPlatformEnabled( true );
	
	rear_damage_clip = getent("rear_damage_clip", "targetname");
	rear_damage_clip linkto_trigger_off();
	rear_damage_clip linkto(level.main_barge);
	rear_damage_clip SetMovingPlatformEnabled( true );
	
	barge_lookat_ent_right = getent("barge_lookat_ent_right", "targetname");
	barge_lookat_ent_right linkto(level.main_barge);
	barge_lookat_ent_left = getent("barge_lookat_ent_left", "targetname");
	barge_lookat_ent_left linkto(level.main_barge);
	
	woods_truck_trigger = getent("woods_truck_trigger", "targetname");
	woods_truck_trigger EnableLinkTo();
	woods_truck_trigger linkto(level.main_barge);
	//woods_truck_trigger hide();
	woods_truck_trigger SetCursorHint("hint_noicon");
	//woods_truck_trigger SetHintString(&"angola_2_open_truck_door");
	
	gaz_truck = getent( "gaz_trucks" ,"script_noteworthy" );
	gaz_truck SetMovingPlatformEnabled( true );
	gaz_truck GodOn();
	gaz_truck thread maps\angola_river::use_gaz_gunner();

	gaz_truck_origin = getstruct( "barge_truck_origin", "targetname" );
	offset = gaz_truck_origin.origin - level.main_barge.origin;
	
	gaz_truck linkto( level.main_barge, "tag_origin", offset );	
	
	clip = getent("strella_truck_clip", "targetname");
	clip linkto(gaz_truck);
	clip SetMovingPlatformEnabled( true );

	damage_trigger = getent("truck_damage_trigger", "targetname");
	damage_trigger EnableLinkTo();
	damage_trigger linkto( gaz_truck );
	damage_trigger thread obj_fail_if_truck_takes_damage();
	
	start_node = GetVehicleNode("main_barge_skipto", "targetname");
	level.main_barge thread go_path(start_node);
	level.main_barge SetSpeed( 30 );
}

//can't use struct for moving platform
teleport_player_to_location( targetname )
{
	wait_for_first_player();
	players = get_players();
	node = getnode(targetname, "targetname");
	players[0] setOrigin( node.origin );
	players[0] setPlayerAngles( node.angles );
}

teleport_hudson_to_location( targetname )
{
	level.hudson = init_hero("hudson");
	node = getnode(targetname, "targetname");
	level.hudson forceteleport( node.origin, node.angles );
}

init_flags()
{
	SetSavedDvar("aim_slowdown_enabled", 0);
	SetSavedDvar("aim_lockon_enabled", 0);
	flag_init("hind_crash");
	flag_init("river_done");
}

setup_heroes()
{
	
}

main()
{
	init_flags();
	setup_heroes();
	
	level thread voice_over_barge();	
	level.player thread maps\createart\angola_art::river_barge();	
	
	barge_fight();
	find_woods();
	hind_fight();
	river_finale();
	
	level thread river_clean_up();
	
	flag_wait("river_done");
}

barge_fight()
{
	hudson_cover = getnode("hudson_cover", "targetname");
	
	level.hudson.goalradius = 64;
	level.hudson.fixednode = false;
	level.hudson setgoalnode(hudson_cover);
	
	level.main_barge SetSpeed( 30 );
	
	set_objective( level.OBJ_SECURE_THE_BARGE );
	
	wait(1);
	
	level thread set_in_the_boat();
	
	while( 1 )
	{
		enemies = GetAIArray("axis");
		
		for( i = 0 ; i < enemies.size; i++)
		{
			if ( Distance2DSquared(enemies[i].origin, level.main_barge.origin) > 8000 * 8000 )
			{
				enemies[i] die();
			}
		}
		
		if ( enemies.size == 0 )
			break;
		
		wait(0.1);
	}
	
	set_objective( level.OBJ_SECURE_THE_BARGE, undefined, "done" );
}

find_woods()
{	
	/#
		iprintlnbold("Hudson: Check the trucks to see if Woods is here!.");
	#/
	
	truck = getent("woods_container", "targetname");
	
	woods_trigger = getent("woods_truck_trigger", "targetname");
	woods_trigger SetHintString(&"angola_2_open_truck_door");
	
	trigger_origin = spawn("script_model", woods_trigger.origin);
	trigger_origin setmodel("tag_origin");
	trigger_origin linkto( level.main_barge );
	
	PlayFXOnTag(level._effect[ "fx_ango_container_light" ], truck, "tag_flashlight");
	
	dead_body_group_1 = spawn("script_model", truck GetTagOrigin("tag_origin"));
	dead_body_group_1 SetModel("p6_angola_dead_pile_on_floor");
	dead_body_group_1.angles = truck GetTagAngles("tag_origin");
	dead_body_group_1 linkto(truck, "tag_origin");
	dead_body_group_1.targetname = "fake_container_body_1";
	
	dead_body_group_2 = spawn("script_model", truck GetTagOrigin("tag_origin"));
	dead_body_group_2 SetModel("p6_angola_dead_pile_on_crate");
	dead_body_group_2.angles = truck GetTagAngles("tag_origin");
	dead_body_group_2 linkto(truck, "tag_origin");
	dead_body_group_2.targetname = "fake_container_body_2";
	
	autosave_by_name("angola_find_woods");
	
	level notify("search_for_woods");
	
	set_objective( level.OBJ_FIND_WOODS, trigger_origin, "use" );
	//woods_trigger trigger_on();
	trigger_wait("woods_truck_trigger");
	
	level.woods = init_hero("woods");
	woods_trigger delete();
	
	set_objective( level.OBJ_FIND_WOODS, undefined, "done" );
	
	trigger_origin delete();
	level.player EnableInvulnerability();
	
	// comment for test.
	level thread start_fake_scene();
	level clientnotify( "heli_context_switch" );
	level thread run_scene("container_find_woods");
	//level thread run_scene("player_find_woods_part2");
	level.player thread maps\createart\angola_art::vision_leave_container();
	
	level waittill("spawn_hind");
//	level thread run_scene("dead_body_idle_loop");
}

hind_fight()
{
	start_origin = getent("heli_destination_back_left", "targetname");
	
	level.river_hind = spawn_vehicle_from_targetname("river_hind_attack_chopper");
	level.river_hind.animname = "river_hind";

	PlayFXOnTag(level._effect[ "hind_damage" ], level.river_hind, "tag_wing_r");
	
	//level.river_hind thread veh_magic_bullet_shield(1);
	Target_set( level.river_hind, (0, 0, -40) );

	level.river_hind.overrideVehicleDamage = ::river_hind_damage_override;		
	level.river_hind.origin = start_origin.origin;
	level.river_hind.angles = start_origin.angles;
	level.river_hind setspeed(80);
	level.river_hind SetDefaultPitch(10);
	level.river_hind SetLookAtEnt(level.player);
	level.river_hind notify( "nodeath_thread" );
	level.river_hind maps\_turret::set_turret_target( level.main_barge, (0, 0, 0), 1 );
	level.river_hind maps\_turret::set_turret_target( level.main_barge, (0, 0, 0), 2 );
	level.river_hind thread attack_barge_back_front( 2, 7 );
	
	level.player thread heli_evade();
	level thread spawn_aft_explosion();
	
	autosave_by_name("woods_located");
	level.main_barge thread rotate_barge();
	level.main_barge setspeed(15);
	
	wait(2);
	
	/#
		iprintlnbold("Hudson: Use the turret!!!");
	#/
		
	level thread play_rumble_on_spinning_barge();
	level.river_hind thread run_heli_path_logic();
	level thread hind_blow_up_barge_side();

	set_objective( level.OBJ_FIND_STINGER, getent( "gaz_trucks" ,"script_noteworthy" ), "use" );	
	set_objective( level.OBJ_DESTROY_HIND, level.river_hind, "destroy" );	
	
	wait(8);	
	
	level.player DisableInvulnerability();
	
	level waittill( "hind_crash" );
}

river_hind_damage_override( eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if( self.health < 200 )
	{		
		level notify( "hind_crash" );
		return 0;		
	}
	
	return iDamage;
}

set_in_the_boat()
{
	level endon("search_for_woods");
	
	while(1)
	{
		enemies = GetAIArray("axis");
		
		if(enemies.size <= 0)
		{
			return;	
		}
		
		if( enemies.size < 5 )
			break;
		
		wait(0.1);
	}
	
//	level thread setup_enemy_boat_ramming();
}

setup_enemy_boat_ramming( delay )
{
	level endon("search_for_woods");
	
	if ( IsDefined( delay ) )
	{
		wait( delay );
	}
	
//	lookat_trigger_while_not_in_trigger("side_reinforcement_lookat");
	
	level.enemy_boat = spawn_vehicle_from_targetname("river_pbr_spawner");
	level.enemy_boat.animname = "enemy_ramming_boat";
	level.enemy_boat.targetname = "enemy_ramming_boat";
	level.enemy_boat linkto(level.main_barge);
	
	level notify("enemy_boat_reinforce");
	
	run_scene("enemy_boat_ram_barge");
	
	level thread run_scene("enemy_boat_driver_idle");
	level thread run_scene("enemy_ramming_boat_idle");
	
	wait(2);
	
	driver = get_ais_from_scene("enemy_boat_driver_idle");
	
	if( isdefined( driver[0] ) )
	{
		driver[0] delete();
	}
	
	level thread run_scene("enemy_boat_driver_crash");
	
	wait(2);
	
	PlayFXOnTag(level._effect[ "ship_explosion" ], level.enemy_boat, "tag_body");
	PlayFXOnTag(level._effect[ "heli_fire" ], level.enemy_boat, "tag_body");
	
	wait(7);
	
	level.enemy_boat delete();
}

river_finale()
{
	end_scene("hudson_wood_idle");
	
	wait(0.5);
	
	stop_exploder(100);
	
	wait(1);
	
	exploder(200);
	
	level notify( "stop_boat_audio" );
	
	set_objective( level.OBJ_FIND_STINGER, undefined, "done" );
	set_objective( level.OBJ_DESTROY_HIND, undefined, "done" );	
	
	PlayFXOnTag(level._effect[ "hind_rotor_damage" ], level.river_hind, "tag_tail_rotor");
	
	flag_set("hind_crash");
	
	level.river_hind thread fire_dying_missile_at_boat();
	
	end_scene("hudson_wood_idle");
	
	for(i = 1; i < 8; i++)
	{
		end_scene("dead_body_idle_" + i);
	}
	
	level.woods unlink();
	level.hudson unlink();
	
	if ( IsDefined( level.player.viewlockedentity ) )
	{
		level.player.viewlockedentity UseBy( level.player );
	}
	
	wait(2);
		
	level.player PlaySound ("evt_barge_sandbar");
	level clientnotify( "aS_on" );
	
	PlayFXOnTag(level._effect[ "barge_sinking" ], level.main_barge, "tag_origin");
	
	level thread play_barge_explosion_fx();
	
	PlayFXOnTag(level._effect[ "barge_truck_quarter_explosion" ], level.main_barge, "tag_origin");
	
//	level thread run_scene("strella_truck_flip");
	
	level notify("fxanim_river_debris_start");
	
	level thread run_scene("barge_sinking_idle");
	level thread run_scene("hind_crash_on_shore");
	
	run_scene("player_hind_shell_shock");
	
	level thread player_save_woods();		
	
	level.river_hind delete();
}

remove_strela_from_player()
{
	weaponlist = level.player GetCurrentWeapon();
	
	for(i = 0; i < weaponlist.size; i++)
	{	
		if(weaponlist[i] == "strela_sp")
		{
			level.player TakeWeapon("strela_sp");
			return;
		}
	}
}

hudson_tell_player_not_use_bullet()
{
	level endon("hind_crash");

	while(1)
	{
		level waittill("player_using_bullet_on_hind");
		/#
			iprintlnbold("Hudson: Small arms fire are useless against Hind");
		#/
			
			wait(10);
	}
	
	
}


run_heli_path_logic()
{
	self endon("death");
	level endon("hind_crash");
	
	level.river_hind.goal_radius = 300;
	level.river_hind.is_player_control = false;
	
	first_location = getent("heli_destination_front_left", "targetname");
	level.river_hind setvehgoalpos(first_location.origin, false);
	level.river_hind hind_reach_goal(first_location);	
	level.river_hind.current_destination = "heli_destination_front_left";
	level.river_hind thread gatling_on_player();
	
	while( 1 )
	{
		new_destination = get_new_destination_index();
		
		level.river_hind hind_reach_goal(new_destination);
		level.river_hind fire_on_player_in_sight();
		
		while( level.river_hind.is_player_control == true )
		{
			wait(0.05);
		}
	}
}

get_new_destination_index()
{
	hind_fly_location = getentarray("hind_fly_path", "script_noteworthy");
	
	while(1)
	{
		new_destination_index = RandomInt(hind_fly_location.size);
		if( hind_fly_location[new_destination_index].targetname != level.river_hind.current_destination)
		{
			level.river_hind.current_destination = hind_fly_location[new_destination_index].targetname;
			return hind_fly_location[new_destination_index];
		}
		wait(0.05);
	}

}


hind_reach_goal( destination )
{
	self endon("death");
	level endon("hind_crash");
	level endon("player_control_hind");
	
	while(1)
	{
		if(DistanceSquared(self.origin, destination.origin) < 500 * 500)
		{
			break;	
		}
		
		level.river_hind setvehgoalpos(destination.origin, false);
		
		wait(0.05);
	}

}

fire_on_player_in_sight()
{
	self endon( "death" );
	level endon("hind_crash");
	level endon("player_control_hind");
	
	self maps\_turret::set_turret_target(level.player, (0, 0, 30), 1);
	self maps\_turret::set_turret_target(level.player, (0, 0, 30), 2);
	
	self thread maps\_turret::fire_turret_for_time(1, 1);
	wait(0.5);
    self thread maps\_turret::fire_turret_for_time(1, 2);
}

gatling_on_player()
{
	self endon( "death" );
	
	self SetTurretTargetEnt(level.player);

	while(1)
	{
		self thread maps\_turret::fire_turret_for_time(5, 0);
		wait(7);	
	}

}

// hind attack side
hind_blow_up_barge_side()
{
	level endon("river_done");
	
	wait(10);
	
	lookat_trigger_while_not_in_trigger("side_damage_lookat");

	level.river_hind.is_player_control = true;
	
	level notify("player_control_hind");

	front_side_destination = getent("heli_destination_front_left", "targetname");
	back_side_destination = getent("heli_destination_mid_left", "targetname");
	
	level.river_hind hind_reach_goal(front_side_destination);
	level thread spawn_barge_side_damage_fx();
	level.river_hind thread fire_on_player_in_sight();
	level.river_hind.current_destination = "heli_destination_front_left";
	level.river_hind hind_reach_goal(back_side_destination);
	
	level.river_hind.is_player_control = false;
	
}

hind_strafe_player_after_missile()
{
	level endon("river_done");
	
	level.river_hind.is_player_control = true;
	level notify("player_control_hind");

	if(isdefined(level.river_hind.current_destination) )
	{
		current_location = getent(level.river_hind.current_destination, "targetname");
	}
	else
	{
		level.river_hind.current_destination = "heli_destination_front_left";
	}

	destination = getent(current_location.target, "targetname");
	level.river_hind thread fire_on_player_in_sight();
	level.river_hind.current_destination = destination.targetname;
	level.river_hind hind_reach_goal(destination);
	level.river_hind.is_player_control = false;
}

start_fake_scene()
{
	level thread run_scene("player_find_woods");
	level thread run_scene("hero_find_woods");
	level thread body_idle();
	
	level waittill("open_door");
	level thread teleport_barge_and_stop_barge();
	level.player thread maps\createart\angola_art::vision_find_woods();
	scene_wait("hero_find_woods");
	level thread run_scene("hudson_wood_idle");
}

teleport_barge_and_stop_barge()
{
	new_path = GetVehicleNode("woods_container_lightning_node", "targetname");
	//wait(2);
	level.main_barge setspeed(0, 10000, 10000);
	//wait(2);
	level.main_barge thread go_path(new_path);
	scene_wait("hero_find_woods");
	level.main_barge setspeed(20);
}

woods_hudson_idle()
{
    truck = getent("woods_container", "targetname");
    barge = getent("main_barge", "targetname");
   
    level thread run_scene("woods_truck_flip");
    PlayFXOnTag(level._effect[ "barge_truck_exp" ], truck, "tag_origin" );
    PlayFXOnTag(level._effect[ "barge_truck_exp_2" ], barge, "tag_origin");
    level thread run_scene("barge_bodies_explosion");
//    level thread spawn_barge_side_damage_fx();

//    barge HidePart("TAG_SIDE_DAMAGE");

	PlayFXOnTag(level._effect[ "barge_truck_exp_2" ], barge, "tag_origin");
	wait(8);
	bodies = get_model_or_models_from_scene("barge_bodies_explosion");
	for(i = 0; i < bodies.size; i++)
	{
		bodies[i] delete();
	}

}

spawn_barge_side_damage_fx()
{
	wait(1);
	
	fake_side_barge_damage = spawn("script_model", level.main_barge.origin);
	fake_side_barge_damage setmodel("fxanim_angola_barge_side_debris_mod");
	fake_side_barge_damage.angles = level.main_barge.angles;
	fake_side_barge_damage.animname = "barge_side_damage";
	fake_side_barge_damage linkto(level.main_barge);
	
	
	level thread woods_hudson_idle();
	//Temp	
	//woods_container = getent("woods_container", "targetname");
	//woods_container delete();	
	container_clip = getent("woods_container_clip", "targetname");
	container_clip delete();	
	side_damage_clip = getent("side_damage_clip", "targetname");
	side_damage_clip unlink();
	side_damage_clip linkto_trigger_on();
	side_damage_clip linkto(level.main_barge);
	
	dead_body = getent("fake_container_body_1", "targetname");
	dead_body delete();
	
	dead_body = getent("fake_container_body_2", "targetname");
	dead_body delete();
	
	level.main_barge HidePart("TAG_SIDE_DAMAGE");
	fake_model = spawn("script_model", level.main_barge GetTagOrigin("TAG_SIDE_DAMAGE") );
	fake_model setmodel("veh_t6_sea_barge_side_dmg_destroyed");
	fake_model.angles = level.main_barge GetTagAngles("TAG_SIDE_DAMAGE");
	fake_model linkto(level.main_barge, "TAG_SIDE_DAMAGE");
	run_scene("barge_side_explosion");	
}

body_idle()
{
	//scene_wait("player_woods_body_idle");
	for(i = 1; i < 8; i++)
	{
		level thread play_this_body_idle( ("player_woods_body_idle_" + i), "dead_body_idle_" + i);
	}
}

play_this_body_idle( scene1, scene2 )
{
	run_scene(scene1);
	level thread run_scene(scene2);	
	
}

attack_barge_back_front( missile_fire_time, gun_firing_time )
{
	level notify("start_attack_run");
	level endon("start_attack_run");

 	self thread maps\_turret::fire_turret_for_time(gun_firing_time, 0);
	wait(0.5);
	self thread maps\_turret::fire_turret_for_time(missile_fire_time, 1);
	wait(0.5);
    self thread maps\_turret::fire_turret_for_time(missile_fire_time, 2);

}

cleanup_river_intro_boats()
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
	
	e_trash = getentarray("river_boat_cleanup" ,"script_noteworthy");
	
	for(i = 0; i < e_trash.size; i++)
	{
		e_trash[i] notify("death");
		e_trash[i] delete();
	}
	
	e_trash = getentarray("river_boats_lance_cleanup" ,"script_noteworthy");
	for(i = 0; i < e_trash.size; i++)
	{
		e_trash[i] notify("death");
		e_trash[i] delete();
	}
}

player_save_woods()
{
	dive_trigger = getent("player_dive_in_trigger", "targetname");
	
	set_objective( level.OBJ_RESCUE_WOODS, dive_trigger.origin, "use" );
	
	level thread set_water_dvars_swim();
	trigger_wait("player_dive_in_trigger");
	
	level thread play_water_fx_on_everyone();
	
	run_scene("player_saving_hinds");
	run_scene("player_swim_to_shore");
	
	flag_set("river_done"); 
	
	set_objective( level.OBJ_RESCUE_WOODS, undefined, "done" );
}

play_water_fx_on_everyone()
{
	wait(1);
	exploder(210);
	wait(2);
	player_water_origin = spawn("script_model", level.player.origin);
	player_water_origin setmodel("tag_origin");
	PlayFXOnTag(level._effect[ "water_splash_effect" ], player_water_origin, "tag_origin");
	player_water_origin.origin = (level.player.origin[0], level.player.origin[1], -40);
	player_Water_origin linkto(level.player);
	
	hudson_water_origin = spawn("script_model", level.hudson.origin);
	hudson_water_origin setmodel("tag_origin");
	PlayFXOnTag(level._effect[ "water_splash_effect" ], hudson_water_origin, "tag_origin");
	hudson_water_origin.origin = (level.hudson.origin[0], level.hudson.origin[1], -40);
	hudson_water_origin linkto(level.hudson);
	
	flag_wait("river_done");
	player_water_origin delete();
	hudson_water_origin delete();
	
	
}

//update_fx_origin( character )
//{
//	level endon("river_done");
//	
//	while(1)
//	{
//		self.origin = (character.origin[0], character.origin[1], -40);
//		
//		wait(0.05);
//	}
//	
//}

play_barge_explosion_fx()
{
	wait(6.5);
	level.main_barge playsound( "exp_barge" );
	
	//LEE sounds
	level clientnotify ("barge_sink");
	
	PlayFXOnTag(level._effect[ "barge_woods_exp" ], level.main_barge, "TAG_WHEEL_BACK_RIGHT" );
	
	wait(2);
	exploder(250);
}


play_flares_fx()
{
	self endon( "death" );
	
	for ( i = 0; i < 3; i++ )
	{
		PlayFXOnTag( level._effect[ "aircraft_flares" ], self, "tag_origin" );
		self playsound ( "veh_huey_chaff_explo_npc" );
		wait 0.25;
	}
}

heli_evade()
{
	self endon( "death" );
	
	while(1)
	{
		self waittill( "missile_fire", missile );
		
		weapon = self GetCurrentWeapon();
		
		if(self GetCurrentWeapon() == "rpg_sp")
		{
			//level.river_hind thread check_for_fatal_damage();
			continue;
		}
		
		
		if(self GetCurrentWeapon() != "strela_sp")
		{
			wait(0.05);
			continue;
		}
		
		//heli = self.stingerTarget;
		//heli thread heli_deploy_flares( missile );
		break;
	}
	
}

#define BARGE_ANGULAR_VELOCITY 10
#define BARGE_ANGULAR_ACC 0.5
#define BARGE_WAVE_AMPLITUDE 4
#define BARGE_WAVE_FREQUENCY 0.075
rotate_barge()
{
	self endon( "end_rotate_barge" );
	
	start_angles = self.angles;
	yaw = start_angles[1];
	ang_vel = 0;
	
	while ( 1 )
	{
		dir = AnglesToForward( ( 0, yaw, 0 ) );
		path_dir = VectorNormalize( self.pathlookpos - self.pathpos );
		
		ang_vel += BARGE_ANGULAR_ACC * 0.05;
		ang_vel = Clamp( ang_vel, -BARGE_ANGULAR_VELOCITY, BARGE_ANGULAR_VELOCITY );
		
		yaw -= ang_vel * 0.05;
		yaw = AngleClamp180( yaw );
		self SetTargetYaw( yaw );
		self SetPhysAngles( ( self.angles[0], self.angles[1], BARGE_WAVE_AMPLITUDE * sin( GetTime() * BARGE_WAVE_FREQUENCY ) ) );
		//IPrintLn( "Yaw: " + yaw );
		wait( 0.05 );
	}
}

fire_dying_missile_at_boat()
{
	self maps\_turret::set_turret_target(level.main_barge, (0, 0, 0), 1);
	self maps\_turret::set_turret_target(level.main_barge, (0, 0, 0), 2);
	self thread maps\_turret::fire_turret_for_time(2, 1);
	self thread maps\_turret::fire_turret_for_time(2, 2);
}

move_boat_offset( offset, time )
{
	self endon("death");
	frame = 20 * time;
	
	moverate = offset / frame;
	movement = 0;
	for(i = 0; i < frame; i++)
	{
		movement += moverate;
		self PathFixedOffset((0, self.spline_offset + movement, 0 ));
		wait(0.05);
	}
	self.spline_offset += movement;
	
	
}

river_clean_up()
{
	level waittill("river_done");
	body = getent("player_body_river", "targetname");
	if(isdefined( body ) ) 
	{
		body delete();
	}
}

spawn_wheelhouse_explosion()
{
	level waittill("heli_in_front");
	
	fake_wheel_house = spawn("script_model", level.main_barge.origin);
	fake_wheel_house setmodel("fxanim_angola_barge_wheelhouse_mod");
	fake_wheel_house.angles = level.main_barge.angles;
	fake_wheel_house.animname = "barge_wheel_house";
	fake_wheel_house linkto(level.main_barge);
	PlayFXOnTag(level._effect[ "barge_wheelhouse_exp" ], fake_wheel_house, "wheelhouse_explode_loc_jnt");
	level.main_barge hidepart( "tag_wheelhouse" );

	run_scene("wheel_house_explosion");	
	fake_wheel_house linkto(level.main_barge);
}

spawn_aft_explosion()
{
	wait(1);
	
	fake_aft_board = spawn("script_model", level.main_barge.origin);
	fake_aft_board setmodel("fxanim_angola_barge_aft_debris_mod");
	fake_aft_board.angles = level.main_barge.angles;
	fake_aft_board.animname = "barge_aft";
	fake_aft_board linkto(level.main_barge);
	

	PlayFXOnTag(level._effect[ "barge_aft_exp" ], level.main_barge, "tag_origin");
	level.main_barge HidePart( "TAG_REAR_DAMAGE" );
	
	rear_damage_clip = getent("rear_damage_clip", "targetname");
	rear_Damage_clip unlink();
	rear_damage_clip linkto_trigger_on();
//	wait(0.05);
	rear_damage_clip linkto(level.main_barge);
	
//	set_objective( level.OBJ_FIND_STINGER, rear_damage_clip.origin, "use" );
	
	fake_model = spawn("script_model", level.main_barge GetTagOrigin("TAG_REAR_DAMAGE") );
	fake_model setmodel("veh_t6_sea_barge_rear_dmg_destroyed");
	fake_model.angles = level.main_barge GetTagAngles("TAG_REAR_DAMAGE");
	fake_model linkto(level.main_barge, "TAG_REAR_DAMAGE");

	run_scene("barge_aft_explosion");
	level thread update_player_barge_rolling();
	fake_aft_board delete();
}

play_rumble_on_spinning_barge()
{
	level endon("hind_crash");
	while(1)
	{
		level.player PlayRumbleOnEntity("tank_damage_light_mp");		
		wait(RandomFloatRange(1.0, 3.0));
		
	}
}

update_player_barge_rolling()
{
	level endon("hind_crash");
	
	if(!isdefined( level.player.fake_ground_ent ) )
	{
		level.player.fake_ground_ent = spawn("script_model", level.player.origin);
		level.player.fake_ground_ent setmodel("tag_origin");
		level.player.fake_ground_ent.angles = level.player.angles;
		level.player PlayerSetGroundReferenceEnt(level.player.fake_ground_ent);
	}
	
	while(1)
	{
		new_angles = (level.main_barge.angles[0], 0, level.main_barge.angles[2]);
		level.player.fake_ground_ent.angles = new_angles;
		wait(0.05);
	}
	
}

voice_over_barge()
{
	level waittill("enemy_boat_reinforce");
	level.player say_dialog("maso_i_swear_to_god_if_w_0");
	
	
	level waittill("search_for_woods");
	level.hudson say_dialog("huds_search_the_crates_0");
	level.player say_dialog("maso_woods_woods_are_0");
}


set_water_dvars_swim()
{
	SetDvar( "r_waterwavespeed", "0.5 1.1 1 1.012" );
	SetDvar( "r_waterwaveamplitude", "9.1 3.7 10.5 4.2" );
	SetDvar( "r_waterwavewavelength", "85 200 295 460" );	
	SetDvar( "r_waterwaveangle", "85 33 69 162" );
}