#include maps\_utility;
#include common_scripts\utility;
#include animscripts\shared;
#include maps\_anim;
#include maps\sink_hole_helicopter;
#using_animtree("vehicles");


///////// EVENT: BOWL BATTLE /////////

set_stage_2_triggers()
{
	level thread set_bowl_helicopter_trigger();
	//level thread set_bowl_prelude_trigger();
	level thread set_bowl_trigger();
	level thread set_engine_damage_trigger();
	level thread set_tnt_crate_helpers();
	level thread set_helicopter_crouch_trigger();
	//level thread set_ai_grenade_trigger();
	level thread check_for_turret_damage();

	level thread set_snipers_perch_trigger();
	level thread set_sniper_vo_trigger();
	level thread set_past_trench_trigger(); 

	level.helicopter_radio = getent("helicopter_radio", "targetname");

	level.side_wall_damage_trigger = getent("side_wall_damage_trigger", "targetname");
	level.side_wall_damage_trigger trigger_off();

	level.mine_tunnel_damage_trigger = getent("mine_tunnel_damage_trigger", "targetname");
	level.mine_tunnel_damage_trigger trigger_off();

	//level thread prep_destructible_terrain();

	//level thread play_ambiant_effects();

	level.landed_helicopter = getent("helicopter_grounded", "targetname");
	level.landed_helicopter hide();
	//level.landed_helicopter.health = 100000;
	//level.landed_helicopter thread maintain_helicopter_health();
	//level.landed_helicopter UseAnimTree( #animtree );
	//level.landed_helicopter setanim( %bh_idle );
	//level.landed_helicopter setanim( %bh_rotors );
	//level.landed_helicopter pilot_death_tracker();

	//level.pilot_hit_box = getent("pilot_detection_box", "targetname");
	//pilot_angles = level.landed_helicopter GetTagAngles("tag_driver") + (0, 180, 0);
	//level.pilot_hit_box linkto( level.landed_helicopter, "tag_driver", ( 5, 0, 10 ), pilot_angles);
	//level.pilot_hit_box SetCanDamage(true);

	//level thread pilot_test();

	//level thread weapon_test();

}


weapon_test()
{
	while(1)
	{
		currentweapon = level.player getCurrentWeapon();

		//iPrintLnBold( "weapon is " +  currentweapon);

		wait(3);
	}
}


pilot_test()
{

	trigger = getent("pilot_damage_trigger", "script_noteworthy");
	while(1)
	{
		trigger waittill("trigger");
		//iPrintLnBold( "pilot hit" );
	}
	/*
	pilot_test = getent("pilot_model", "targetname");

	while(1)
	{
	pilot_test waittill("damaged");
	//iPrintLnBold( "pilot hit" );
	}
	*/

}
/*
play_ambiant_effects()
{
engine_smoke = getent("engine_smoke_origin", "targetname");
playfxontag (level._effect["small_fire"], engine_smoke, "tag_origin");
}
*/

prep_destructible_terrain()
{
	// Mine Tunnel:  when destroyed, unhide script_brushmodel with targetname “destroyed_minetunnel”
	//level.mine_tunnel_collapsed = getent("destroyed_minetunnel", "targetname");
	//level.mine_tunnel_collapsed connectpaths();
	//level.mine_tunnel_collapsed.origin = level.mine_tunnel_collapsed.origin + (0,0,-256); // move underground

	//Side Wall: when destroyed, hide script_brushmodel “undestroyed_sidewall” and unhide script_brushmodel “destroyed_sidewall”
	//level.side_wall = getent("undestroyed_sidewall", "targetname");

	//level.side_wall_collapsed = getent("destroyed_sidewall", "targetname");
	//level.side_wall_collapsed connectpaths();
	//level.side_wall_collapsed.origin = level.side_wall_collapsed.origin + (0,0,-256); // move underground



	//End Wall:  when destroyed, hide script_brushmodel “undestroyed_endwall” and unhide script_brushmodel “destroyed_endwall”
	//level.end_wall = getent("undestroyed_endwall", "targetname");

	//level.end_wall_collapsed = getent("destroyed_endwall", "targetname");
	//level.end_wall_collapsed hide();

	//level.end_wall_explosive = getent("end_wall_explosive", "script_noteworthy");
	//level.end_wall_explosive hide();

	//level.sniper_cave = getent("snipercave_undestroyed", "targetname");
	//level.sniper_cave_collapsed = getent("snipercave_destroyed", "targetname");
	//level.sniper_cave_collapsed.origin = level.sniper_cave_collapsed.origin + (0,0,-256);

	//level thread wait_for_side_wall_destruction();
	//level thread wait_for_mine_tunnel_destruction();
}

/*
wait_for_side_wall_destruction()
{
explosive = getent("side_wall_explosive", "script_noteworthy");
explosive waittill("death");

//level.side_wall hide();
//level.side_wall_collapsed show();

collapse_point = getent("side_wall_origin", "targetname");

playfxontag (level._effect["collapse_dust"], collapse_point, "tag_origin");
earthquake(.5, 2, collapse_point.origin, 1200);
level.player PlayRumbleOnEntity( "grenade_rumble" );

//level notify("side_wall_destroyed");

//level.side_wall_destroyed = true;

//level.side_wall_damage_trigger trigger_on();

//level.side_wall.origin = level.side_wall.origin + (0,0,-256);
//level.side_wall_collapsed.origin = level.side_wall_collapsed.origin + (0,0,256);
//level.side_wall_collapsed disconnectpaths();

}

wait_for_mine_tunnel_destruction()
{
explosive = getent("mine_tunnel_explosive", "script_noteworthy");
explosive waittill("death");

collapse_point = getent("mine_tunnel_origin", "targetname");
playfxontag (level._effect["collapse_dust"], collapse_point, "tag_origin");
earthquake(.5, 2, collapse_point.origin, 1200);
level.player PlayRumbleOnEntity( "grenade_rumble" );

//level notify("mine_tunnel_destroyed");

//level.mine_tunnel_damage_trigger trigger_on();

//wait(.2);
//level.mine_tunnel_collapsed.origin = level.mine_tunnel_collapsed.origin + (0,0,256);
//level.mine_tunnel_collapsed disconnectpaths();

//level.mine_tunnel_destroyed = true;
}
*/
/*
reveal_end_wall_explosive()
{
//if(level.mine_tunnel_destroyed == true && level.side_wall_destroyed == true)
//{
level.end_wall_explosive show();
// place rpg man
// for fire and miss first shot
// control firing rate of subsequent shots

level thread wait_for_end_wall_destruction();
//}
}
*/
/*
wait_for_end_wall_destruction()
{
//explosive = getent("end_wall_explosive", "script_noteworthy");
//explosive waittill("death");

self waittill("death");

level.end_wall_destroyed = true;

collapse_point = getent("end_wall_origin", "targetname");
playfxontag (level._effect["tnt_explosion"], collapse_point, "tag_origin");

RadiusDamage( collapse_point.origin, 500, 500, 10);		//kill the surroundings
PhysicsExplosionSphere( collapse_point.origin, 300, 32, 20 );
Earthquake( 0.5, 2, collapse_point.origin, 1200 );

//earthquake(.5, 2, collapse_point.origin, 1200);
level.player PlayRumbleOnEntity( "grenade_rumble" );

level.end_wall.origin = level.end_wall.origin + (0,0,-256);
level.end_wall_collapsed.origin = level.end_wall_collapsed.origin + (0,0,256);

wait(.5);
playfxontag (level._effect["collapse_dust"], collapse_point, "tag_origin");


//level notify("force_rush");
////iPrintLnBold( "Force rush" );
}
*/
/*
set_mine_tunnel_explosive_trigger()
{
trigger = getent("mine_tunnel_explosive_trigger", "targetname");
trigger waittill( "trigger" );

level thread place_rag_doll_men(3);
}


set_side_wall_explosive_trigger()
{
trigger = getent("side_wall_explosive_trigger", "targetname");
trigger waittill( "trigger" );

level thread place_rag_doll_men(1);
}
*/

place_rag_doll_men(location)
{
	switch(location)
	{
	case 1:
		spawner = getentarray( "rag_doll_men_side_wall", "targetname");
		break;

	case 2:
		spawner = getentarray( "rag_doll_men_end_wall", "targetname");
		break;

	case 3:
		spawner = getentarray( "rag_doll_men_mine_tunnel", "targetname");
		break;

	default:
		spawner = getentarray( "rag_doll_men_mine_tunnel", "targetname");
		iPrintLnBold( "WARNING: Switch using default" );
		break;
	}

	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		level.rag_doll_men[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.rag_doll_men[i]) )
		{
			return;
		}

		level.rag_doll_men[i] lockalertstate("alert_red");
		level.rag_doll_men[i] SetPerfectSense( true );

		if(location != 2)
		{
			level.rag_doll_men[i] thread force_rush_ready();
		}

		level.rag_doll_men[i] thread bowl_death_tracker();

		level.rag_doll_men[i].accuracy = .4;

		//level.rag_doll_men[i] thread die_on_explosion(location);
		//level.rag_doll_men[i] thread bowl_death_tracker();
	}
}

die_on_explosion(location)
{	
	switch(location)
	{
	case 1:
		level waittill("side_wall_destroyed");
		wait(.5);

		if(isdefined(self))
		{
			if(isalive(self))
			{
				self DoDamage( 500, ( 0, 0, 0 ) );
			}
		}
		break;

	case 3:
		level waittill("mine_tunnel_destroyed");
		wait(.5);

		if(isdefined(self))
		{
			if(isalive(self))
			{
				self DoDamage( 500, ( 0, 0, 0 ) );
			}
		}
		break;

	default:
		break;
	}
}


set_bowl_helicopter_trigger()
{
	trigger = getent( "bowl_helicopter_trigger", "targetname" );
	trigger waittill( "trigger" );

	level thread hide_unused_helicopters();
	level notify("hide_helicopter_rope");

	//level.helicopter3 thread play_rotor_sparks();

	//level.helicopter2 thread place_door_gunner_right(2);
	//level.helicopter2 thread place_window_gunner_right(2);
	level.helicopter3 thread place_door_gunner_right(3);
	level.helicopter3 thread place_window_gunner_right(3);

	// helicopter prepares to fire
	level.helicopter3 thread begin_helicopter_patrol("block_cave_path", 20); // ambient helicopter
	level.helicopter3 thread target_spotlight_at_path("cave_spotlight_path", 3);


	// jeremy the player can skip by this guy and the heli will never crash.
	place_bowl_tunnel_rusher();


	// ludes
	// player punks out and runs by guy
	level thread heli_force_either_passed();

	// killed the ai
	level thread heli_force_either_death();


	// ai dies or trigger is hit send a notify

	level waittill("player_killed_rudher_ran_passed");

	/*
	level.bowl_tunnel_rusher setpainenable( false );
	level.bowl_tunnel_rusher setDeathenable( false );


	level.bowl_tunnel_rusher waittill("damage");
	level.bowl_tunnel_rusher cmdplayanim("thug_heli_death", false, true);
	//level.bowl_tunnel_rusher waittill( "cmd_done" );
	wait(.3);

	// ragdoll
	level.bowl_tunnel_rusher StartRagDoll();
	// wait for the anim to finish
	level.bowl_tunnel_rusher waittill("cmd_done");
	// kill him
	level.bowl_tunnel_rusher BecomeCorpse();
	//level.bowl_tunnel_rusher notify("death");

	//level.bowl_tunnel_rusher setDeathenable( true );
	//level.bowl_tunnel_rusher dodamage(500, level.Player.origin);
	*/


	//level thread search_helicopter();

	//level.helicopter3 thread begin_helicopter_patrol("cave_reposition_path", 20); // ambient helicopter
	level.helicopter3 setLookAtEnt( level.player );
	level.helicopter3 SetLookAtEntYawOffset( 90 );
	//playfxontag (level._effect["rocks_hit_copter"], level.helicopter3, "tag_origin");
	wait(1);

	level.helicopter3 thread play_rotor_sparks();
	//iprintlnbold ("SOUND: rotor blades impact");
	level.helicopter3 playsound("heli_rotor_impact");
	level.helicopter3  playsound("helicopter_avalanche");



	wait(1);
	//level.helicopter3 SetLookAtEntYawOffset( 0 );
	level.helicopter3 clearLookAtEnt();

	// collapse damages helicopter
	playfxontag (level._effect["copter_dust"], level.helicopter3, "tag_origin"); // copter_dust
	//playfxontag (level._effect["rocks_hit_copter"], level.helicopter3, "tag_origin"); // copter_dust
	playfxontag (level._effect["helicopter_smoking"], level.helicopter3, "tag_origin");
	//playfxontag (level._effect["rocks_hit_copter"], level.helicopter3, "tag_origin");
	//iPrintLnBold("SOUND Helicopter damage 1");
	level.helicopter3 playsound("helicopter_avalanche_impact");

	//iPrintLnBold( "Helicopter damaged" );

	earthquake(.75, 3, level.helicopter3.origin, 2000);
	//iPrintLnBold("SOUND Helicopter spin engine");
	level.helicopter3 playsound("helicopter_spin");
	level.player playsound("helicopter_avalanche");
	level.player PlayRumbleOnEntity( "grenade_rumble" );

	level.helicopter3 notify("turn_off_spotlight");
	level.helicopter3 notify("cancel_spotlight_target");

	//level.helicopter3 StopLoopSound();
	//level.helicopter3 PlayLoopSound("sink_hole_helicopter_defect");

	// helicopter crash
	level.helicopter3 thread begin_helicopter_patrol("bowl_crash_path", 45);

	wait(.75);
	rock_collapse = getent("rock_collapse_origin", "targetname");
	physicsExplosionSphere( rock_collapse.origin, 100, 1, 5 );

	level.helicopter3 spin_helicopter();

	level.helicopter3 waittill("end_of_path");

	level.helicopter3 notify("crash");

	crash_land_point = getent("crash_land_origin", "targetname");
	playfxontag (level._effect["copter_dust"], crash_land_point, "tag_origin");

	level notify("copter_smoke"); // triggers smoke effect

	physicsExplosionSphere( crash_land_point.origin, 2000, 1, 10 );
	earthquake(.75, 3, crash_land_point.origin, 2000);
	level.player playsound("helicopter_avalanche");
	level.player PlayRumbleOnEntity( "grenade_rumble" );

	//level.copilot delete();
	//level.pilot delete();

	//if(isalive(level.gunner))
	//{
	//	level.gunner DoDamage( 500, crash_land_point.origin );
	//}

	level.helicopter3 StopLoopSound();
	////iPrintLnBold("SOUND: Helicopter crash");
	crash_land_point playsound("helicopter_explosion_1");

	//Music - Climax Cue - Added by crussom
	level notify( "playmusicpackage_climax" );

	level.helicopter3.pilot delete();

	level.helicopter3.rear_rotor delete();

	//level.helicopter3.copilot delete();

	if(isdefined(level.helicopter3.window_gunner_right))
	{
		if(isalive(level.helicopter3.window_gunner_right))
		{
			level.helicopter3.window_gunner_right delete();
		}
	}

	if(isdefined(level.helicopter3.door_gunner_right))
	{
		if(isalive(level.helicopter3.door_gunner_right))
		{
			level.helicopter3.door_gunner_right delete();
		}
	}

	level.helicopter3 delete();

	level.landed_helicopter show();
	place_dead_pilot();

	level thread place_dead_crew();
	level thread place_surviving_crew();

	wait(.75);
	rock_collapse2 = getent("rock_collapse_origin_2", "targetname");

	objective_state(6, "done");
	objective_add(7, "active", &"SINK_HOLE_OBJECTIVE_HEADER_FIND_HELICOPTER", GetEnt("objective_7_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_FIND_HELICOPTER");
	objective_state(7, "current");
	//iPrintLnBold( "Objective - find helicopter" );
	wait(6);
	//VisionSetNaked( "sink_hole_bowl", 6.0 );	// moved
	//physicsExplosionSphere( rock_collapse.origin, 2000, 1, 10 );
	//VisionSetNaked( "sink_hole_geo", 0.0 );
}

heli_force_either_death()
{
	level.bowl_tunnel_rusher waittill_any("damage", "death");
	level notify("player_killed_rudher_ran_passed");
}

heli_force_either_passed()
{
	trigger = getent( "bowl_helicopter_trigger_force", "targetname" );
	trigger waittill( "trigger" );
	level notify("player_killed_rudher_ran_passed");
}


hide_unused_helicopters()
{
	if(isdefined(level.helicopter))
	{
		level.helicopter notify("turn_off_spotlight");
		level.helicopter notify("cancel_spotlight_target");
		level.helicopter hide();

		if(isdefined(level.helicopter.pilot))
		{
			level.helicopter.pilot hide();
		}
	}

	if(isdefined(level.helicopter2))
	{
		level.helicopter2 notify("turn_off_spotlight");
		level.helicopter2 notify("cancel_spotlight_target");

		wait(1);

		if(isdefined(level.helicopter2.pilot))
		{
			level.helicopter2.pilot delete();
		}

		level.helicopter2 delete();	
	}

}


spin_helicopter()
{
	//wait(.5);
	self SetLookAtEntYawOffset( -30 );
	self setLookAtEnt( level.player );
}


play_rotor_sparks()
{
	for(i=0; i<8; i++)
	{
		playfxontag (level._effect["sparks"], self.rear_rotor, "tag_origin");
		level.player PlayRumbleOnEntity( "damage_light" );
		wait(.2);
	}
	playfxontag (level._effect["helicopter_crashing"], self.rear_rotor, "tag_origin");
}


place_window_gunner_right(id)
{
	if(id == 2)
	{
		level.helicopter2 endon("crash");
		spawner = getent( "helicopter2_window_gunner", "targetname");
	}
	else if(id == 3)
	{
		level.helicopter3 endon("crash");
		spawner = getent( "helicopter3_window_gunner", "targetname");
	}
	else
	{
		return;
	}

	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "No Spawner!" );
		return;
	}

	self.window_gunner_right = spawner stalingradspawn();

	if ( spawn_failed(self.window_gunner_right) )
	{
		iPrintLnBold( "Spawn failed" );
		return;
	}

	self.window_gunner_right allowedStances ("crouch");
	//self.window_gunner_right SetPerfectSense( true );
	self.window_gunner_right SetEnableSense( false);
	self.window_gunner_right lockalertstate( "alert_red" );
	self.window_gunner_right.dropweapon = false;

	self.window_gunner_right endon("death");

	wait(1);

	if(id == 2)
	{
		facing_adjustment = -90;

		gunner_angles_right = level.helicopter2 getTagAngles( "tag_guy0" ) + (0, facing_adjustment, 0);

		while(isalive(self))
		{
			self.window_gunner_right linkto( level.helicopter2, "tag_guy0", ( 17, -4, -18 ), gunner_angles_right); // right gunner
			wait(.01);
		}
	}
	else if(id == 3)
	{
		facing_adjustment = 90;

		gunner_angles_right = level.helicopter3 getTagAngles( "tag_guy0" ) + (0, facing_adjustment, 0);

		while(isalive(self))
		{
			self.window_gunner_right linkto( level.helicopter3, "tag_guy0", ( 17, -4, -18 ), gunner_angles_right); // right gunner
			wait(.01);
		}
	}
}


place_door_gunner_right(id)
{
	if(id == 2)
	{
		level.helicopter2 endon("crash");
		spawner = getent( "helicopter2_door_gunner", "targetname");
	}
	else if(id == 3)
	{
		level.helicopter2 endon("crash");
		spawner = getent( "helicopter3_door_gunner", "targetname");
	}
	else
	{
		return;
	}

	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "No Spawner!" );
		return;
	}

	self.door_gunner_right = spawner stalingradspawn();

	if ( spawn_failed(self.door_gunner_right) )
	{
		iPrintLnBold( "Spawn failed" );
		return;
	}

	self.door_gunner_right allowedStances ("crouch");
	//self.door_gunner_right SetPerfectSense( true );
	self.door_gunner_right SetEnableSense( false);
	self.door_gunner_right lockalertstate( "alert_red" );
	self.door_gunner_right.dropweapon = false;
	//self.door_gunner_right thread maintain_rpg_facing("right");

	self.door_gunner_right endon("death");

	wait(1);

	if(id == 2)
	{
		facing_adjustment = 90;

		gunner_angles_right = level.helicopter2 getTagAngles( "tag_playerride" ) + (0, facing_adjustment, 0);

		while(isalive(self))
		{
			self.door_gunner_right linkto( level.helicopter2, "tag_playerride", ( -5, 0, 8 ), gunner_angles_right); // right gunner
			wait(.01);
		}
	}
	else if(id == 3)
	{
		facing_adjustment = -90;

		gunner_angles_right = level.helicopter3 getTagAngles( "tag_playerride" ) + (0, facing_adjustment, 0);

		while(isalive(self))
		{
			self.door_gunner_right linkto( level.helicopter3, "tag_playerride", ( -5, 0, 8 ), gunner_angles_right); // right gunner
			wait(.01);
		}
	}
}


place_bowl_tunnel_rusher()
{
	spawner = getent( "bowl_tunnel_infantry", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.bowl_tunnel_rusher = spawner stalingradspawn();

	if ( spawn_failed(level.sniper) )
	{
		return;
	}

	level.bowl_tunnel_rusher SetPerfectSense( true );
	level.bowl_tunnel_rusher allowedStances ("stand");
	//level.bowl_tunnel_rusher lockalertstate("alert_red");
	//level.bowl_tunnel_rusher SetCombatRole( "turret" );

	level.bowl_tunnel_rusher thread maintain_alert_status();
}

maintain_alert_status()
{
	while(isalive(self))
	{
		self lockalertstate("alert_red");
		wait(.5);
	}
}

//#using_animtree("fakeShooters");

search_helicopter()
{
	level.helicopter2 thread begin_helicopter_patrol("bowl_helicopter_path", 20); // ambient helicopter

	level.helicopter2 waittill("crash_search_path");
	level.helicopter2 thread target_spotlight_at_path("crash_search_path", 3);

	level.helicopter2 waittill("end_of_path");

	//wait(20);
	////iPrintLnBold( "About to play anim" );
	//wait(4);

	//level.helicopter3.pilot UseAnimTree(#animtree);
	//level.helicopter3.pilot SetAnim(%pilot_hitreaction);
	////iPrintLnBold( "played anim" );

	/*
	level.helicopter3.door_gunner_right thread signal_test();

	level.helicopter3.door_gunner_right setpainenable( false );
	level.helicopter3.door_gunner_right setDeathenable( false );


	//level.helicopter3.door_gunner_right waittill("damage");
	wait(20);
	//iPrintLnBold( "About to play anim" );
	wait(4);


	level.helicopter3.door_gunner_right cmdplayanim("thug_heli_death", false, true);
	//level.helicopter3.door_gunner_right waittill( "cmd_done" );
	wait(.5);

	//level.helicopter3.door_gunner_right setDeathenable( true );
	//level.helicopter3.door_gunner_right dodamage(500, level.Player.origin);
	// ragdoll
	level.helicopter3.door_gunner_right StartRagDoll();
	// wait for the anim to finish
	level.helicopter3.door_gunner_right waittill("cmd_done");
	// kill him
	level.helicopter3.door_gunner_right BecomeCorpse();
	//level.bowl_tunnel_rusher notify("death");

	//level.bowl_tunnel_rusher setDeathenable( true );
	//level.bowl_tunnel_rusher dodamage(500, level.Player.origin);
	*/

	level.helicopter2 notify("cancel_spotlight_target");
	wait(.5);
	level.helicopter2 thread target_spotlight_at_entity(level.helicopter3.spotlight_fixed_target, 3);	

	level.helicopter2 thread begin_helicopter_patrol("bowl_search_exit_path", 25); 
	wait(2);
	level.helicopter2 notify("turn_off_spotlight");
}

signal_test()
{
	self waittill("death");

	//iPrintLnBold( "gunner died" );
}


/*
check_for_bowl_detection()
{
level thread check_if_player_fires_weapon();
level thread check_for_spotlight_detection();
}

check_if_player_fires_weapon()
{
level endon("player_detected_in_bowl");
level endon("bowl_helicopter_left");

while(1)
{
if ( level.player attackbuttonpressed() )
{
player_detected_in_bowl = true;
level notify("player_detected_in_bowl");
}
wait(.25);
}
}


check_for_spotlight_detection()
{
flag_set("player_detection");

level.gunner endon("death");

min_allowed_distance = 100; // The closest you can get to the spotlight without risking detection.
grace_period = .5;

while(IsAlive(level.gunner))
{
flag_wait("player_detection");

distance_to_spotlight = Distance( level.player.origin, level.helicopter.spotlight_target.origin );
if(distance_to_spotlight < min_allowed_distance)
{
if(bullettracepassed( level.helicopter.primary_spotlight.origin, level.player geteye(), false, undefined ))
{
wait(grace_period);

if(distance_to_spotlight < min_allowed_distance)
{
//if(bullettracepassed( level.helicopter.primary_spotlight.origin, level.player geteye(), false, undefined ))
if (!level.player IsInCover() || flag("player_targeted_by_gunner"))
{
flag_set("player_targeted_by_gunner");
}
else
{
flag_clear("player_targeted_by_gunner");
}
}
}
}

wait .5;
}
}


gunner_attacks_player()
{
level.gunner endon("death");

level.gunner.accuracy_modifier = .3;

level thread can_gunner_see_player();

level thread clear_target();

while (IsAlive(level.gunner))
{
flag_wait("player_targeted_by_gunner");

level.helicopter thread target_spotlight_at_entity(level.player, 1);

level.gunner StopAllCmds();
level.gunner CmdShootAtEntity(level.player, false, 3, level.gunner.accuracy_modifier);
wait 3;

if(level.player IsInCover() || flag("in_fuselage"))
{
wait 3.5;
}
else
{
wait .3;
}
}
}

clear_target()
{
while (IsAlive(level.gunner))
{
flag_wait("player_targeted_by_gunner");
flag_waitopen("player_targeted_by_gunner");
level.gunner ClearEnemy();
}
}

update_yaw()
{
level.helicopter endon("death");
level.gunner endon("death");

while (true)
{
flag_wait("update_yaw");

while (flag("update_yaw"))
{
if (IsDefined(level.gunner.enemy))
{
//level.helicopter ClearGoalYaw();

//ang = VectorToAngles(level.gunner.enemy.origin - level.helicopter.origin);
//ang = VectorToAngles(AnglesToRight(ang));

level.helicopter SetLookAtEnt(level.gunner.enemy);
level.helicopter SetLookAtEntYawOffset(-90);
////iPrintLnBold("updating yaw");
}
//else if (IsDefined(self.spotlight_target))
//{
//	//level.helicopter ClearGoalYaw();

//	//ang = VectorToAngles(level.helicopter.spotlight_target.origin - level.helicopter.origin);
//	//ang = VectorToAngles(AnglesToRight(ang));

//	//level.helicopter SetTargetYaw(ang[1]);
//	level.helicopter SetLookAtEnt(level.helicopter.spotlight_target);
//	level.helicopter SetLookAtEntYawOffset(-90);
//	////iPrintLnBold("updating yaw");
//}
else
{
//level.helicopter ClearTargetYaw();
level.helicopter ClearLookAtEnt();
////iPrintLnBold("clearing yaw");
}

wait .1;
}

//level.helicopter ClearTargetYaw();
level.helicopter ClearLookAtEnt();
wait .05;
}
}

can_gunner_see_player()
{
flag_set("player_detection");

level.gunner endon("death");

min_allowed_distance = 100; // The closest you can get to the spotlight without risking detection.
grace_period = .5;

while(IsAlive(level.gunner))
{
flag_wait("player_detection");

distance_to_spotlight = Distance( level.player.origin, level.helicopter.spotlight_target.origin );
if(distance_to_spotlight < min_allowed_distance)
{
if(bullettracepassed( level.helicopter.primary_spotlight.origin, level.player geteye(), false, undefined ))
{
wait(grace_period);

if(distance_to_spotlight < min_allowed_distance)
{
//if(bullettracepassed( level.helicopter.primary_spotlight.origin, level.player geteye(), false, undefined ))
if (!level.player IsInCover() || flag("player_targeted_by_gunner"))
{
flag_set("player_targeted_by_gunner");
}
else
{
flag_clear("player_targeted_by_gunner");
}
}
}
}

wait .5;
}
}
*/



spin_out_of_control_bowl()
{
	self endon("end_of_path");

	facing_node = getent("crash_land_lookat_node", "targetname");
	self setLookAtEnt( facing_node );

	destination = getent(facing_node.target, "targetname");

	time = 2.0;

	while(1)
	{
		facing_node moveto(destination.origin, time, 0, 0);
		wait(time);
		destination = getent(destination.target, "targetname");
	}
}

#using_animtree("fakeShooters");

place_dead_pilot()
{
	pilot_tag = getent("landed_helicopter_pilot", "targetname");

	//pilot_angles = pilot_tag GetTagAngles("tag_origin");
	//pilot_origin = pilot_tag GetTagOrigin("tag_origin");

	dead_pilot = Spawn("script_model", (0,0,0));
	dead_pilot character\character_thug_2_sinkhole::main();
	dead_pilot LinkTo(pilot_tag, "tag_origin", (0,0,0), (0,0,0));

	dead_pilot UseAnimTree(#animtree);
	dead_pilot SetAnim(%pilot_dead_loop);
}

place_dead_crew()
{
	spawner = getentarray( "dead_crew", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "No Spawner!" );
		return;
	}

	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		level.dead_crew[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.dead_crew[i]) )
		{
			return;
		}

		level.dead_crew[i] DoDamage( 500, ( 0, 0, 0 ) );
	}
}


place_surviving_crew()
{
	spawner = getent( "surviving_crew", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "No Spawner!" );
		return;
	}

	level.surviving_crew = spawner stalingradspawn();

	if ( spawn_failed(level.surviving_crew) )
	{
		return;
	}

	level.surviving_crew thread patrol_behaviors();
}

patrol_behaviors()
{
	self endon("death");
	self endon("alerted");

	self SetEnableSense( false );

	trigger = getent( "bowl_prelude_trigger", "targetname" );
	trigger waittill( "trigger" );

	self thread check_for_awareness();
	self setscriptspeed( "walk" );

	dest1 = GetNode("kneel_node", "targetname");
	self setgoalnode( dest1 );
	self waittill( "goal" );
	self stopallcmds();

	self cmdplayanim ("thu_cvrmid_crch_idlready_foregrip", false);


	trigger = getent("helicopter_approach_trigger", "targetname");
	trigger waittill("trigger");

	self stopallcmds();

	dest2 = GetNode("ear_piece_node", "targetname");
	self setgoalnode( dest2 );
	self waittill( "goal" );
	self CmdAction ( "CheckEarpiece", false);
	wait(3);
	self SetEnableSense( true );
	self notify("alerted");
}


check_for_awareness()
{
	self endon("death");
	self endon("alerted");

	self thread check_for_gunshot();

	self waittill( "damage");

	self stopallcmds();
	self SetEnableSense( true );

	self notify("alerted");
}

check_for_gunshot()
{
	self endon("death");
	self endon("alerted");

	while(isalive(self))
	{
		if ( level.player attackbuttonpressed() )
		{
			self stopallcmds();
			self SetEnableSense( true );
			self notify("alerted");
		}
		wait(.25);
	}
}


set_crew_alert_status_trigger()
{
	trigger = getent( "crew_alert_status_trigger", "targetname" );
	trigger waittill( "trigger" );
	wait(1);

	for( i = 0; i < level.surviving_crew.size; i++ )
	{
		level.surviving_crew[i] SetEnableSense( true );
	}
}

/*
set_bowl_prelude_trigger()
{
trigger = getent( "bowl_prelude_trigger", "targetname" );
trigger waittill( "trigger" );

level.player play_dialogue("CAMI_SinkG_512A", true);
}
*/
set_engine_damage_trigger()
{
	engine_fire_hurt_trigger = getentarray( "engine_fire_hurt_trigger", "targetname" );
	for(i=0; i< engine_fire_hurt_trigger.size; i++)
	{
		engine_fire_hurt_trigger[i] trigger_off();
	}

	engine_smoke_origin = getent("engine_smoke_origin", "targetname");
	playfxontag (level._effect["smoke"], engine_smoke_origin, "tag_origin");


	trigger = getent( "engine_damage_trigger", "targetname" );
	//trigger waittill( "trigger" );

	engine_exploded = false;

	while(engine_exploded == false)
	{
		trigger waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName ); 

		if(attacker == level.player) //a damage filter on the trigger volume for player only damage
		{
			engine_exploded = true;

			level notify ("engine_toss_start");

			engine_smoke_origin delete();

			// add explosive force and damage near engine start
			engine_explosion = getent("engine_explosion_origin", "targetname");
			earthquake(.50, 1, engine_explosion.origin, 1500);
			physicsExplosionSphere( engine_explosion.origin, 1200, 1, 10 );
			radiusdamage(engine_explosion.origin, 300, 500, 0 );

			////iPrintLnBold ("SOUND: engine explosion");
			engine_explosion playsound("helicopter_explosion_1");
			//level.player playsound("helicopter_avalanche");
			//level.player playsound("sink_hole_engine_explosion");

			level.player PlayRumbleOnEntity( "damage_heavy" );

			// delete old player clip - engine_start_player_clip
			engine_start_player_clip = getent("engine_start_player_clip", "targetname");
			engine_start_player_clip delete();

			// engine lands on the ground
			wait(1.25);
			//level waittill("egine_hit");
			earthquake(.50, 1, engine_explosion.origin, 1500);
			level.player PlayRumbleOnEntity( "damage_light" );

			physicsExplosionSphere( engine_explosion.origin, 300, 1, 10 );
			radiusdamage(engine_explosion.origin, 200, 500, 10 );
			wait(.25);
			level.player PlayRumbleOnEntity( "damage_light" );

			////iPrintLnBold ("SOUND: engine explosion landing");
			engine_explosion playsound("generic_explosion");
			level.player playsound("helicopter_avalanche");
			engine_explosion playloopsound("sink_hole_fireloop_2");
			engine_explosion playloopsound("sink_hole_fireloop_1");


			// activate damage trigger to fire pit
			for(i=0; i< engine_fire_hurt_trigger.size; i++)
			{
				engine_fire_hurt_trigger[i] trigger_on();
			}

			// move full metal clip into position
			engine_explosion_clip = getentarray("engine_explosion_clip", "targetname");
			for(i=0; i< engine_explosion_clip.size; i++)
			{
				engine_explosion_clip[i].origin = engine_explosion_clip[i].origin + (0,0,200);

				// nullify nodes that are covered by fire
				engine_explosion_clip[i] disconnectpaths();
			}

		}
	}
}


set_tnt_crate_helpers()
{
	trigger = getentarray("tnt_crate_helper_trigger", "targetname");

	for(i=0; i<trigger.size; i++)
	{
		trigger[i] thread wait_for_gunshot();
	}
}


wait_for_gunshot()
{
	player_hit = false;

	while(player_hit == false)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName ); 

		if(attacker == level.player) 
		{
			player_hit = true;

			tnt_crate = getent(self.script_parameters, "script_noteworthy");

			tnt_crate dodamage(1000, (0,0,5));   
		}
	}
}


set_helicopter_crouch_trigger()
{
	trigger = getent("helicopter_crouch_trigger", "targetname");
	trigger waittill("trigger");

	level.player allowStand(false);
	wait(.25);
	level.player allowStand(true);
}




set_bowl_trigger()
{
	trigger = getent( "bowl_trigger", "targetname" );
	trigger waittill( "trigger" );

	objective_state(7, "done");
	//objective_add(8, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DEFEND_YOURSELF_AGAIN", GetEnt("objective_7_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DEFEND_YOURSELF_AGAIN");
	objective_add(8, "active", &"SINK_HOLE_OBJECTIVE_HEADER_MOUNT_TURRET", GetEnt("objective_7_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_MOUNT_TURRET");
	objective_state(8, "current");
	//iPrintLnBold( "Objective - defend yourself" );

	level.player play_dialogue("CAMI_SinkG_512A", true);

	////iPrintLnBold( "Bowl Battle" );

	place_bowl_infantry();

	if(isdefined(level.surviving_crew) )
	{
		level.surviving_crew SetEnableSense( true );
		level.surviving_crew notify("alerted");
	}

	maps\sink_hole_1::remove_surviving_hill_ai();

	maps\_autosave::autosave_now("sink_hole"); // Just before Bond enters the second combat arena (past pacing – before battle)

	level thread wait_for_reinforcements();

	level.helicopter_radio play_dialogue("MDS1_SinkC_604A"); // Enemy contact, dead ahead!  Engage!

	wait(1.5);
	place_rpg_wave_1();
}

place_bowl_infantry()
{
	if (IsDefined(level.surviving_crew))
	{
		level.surviving_crew SetEnableSense( true );
		level.surviving_crew notify("alerted");
		wait .05;

		if (IsDefined(level.surviving_crew))
		{
			level.surviving_crew StopAllCmds();
			level.surviving_crew SetPerfectSense(true);
		}
	}

	spawner = getentarray( "first_wave_mine_tunnel", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		level.bowl_infantry[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.bowl_infantry[i]) )
		{
			return;
		}

		level.bowl_infantry[i] lockalertstate("alert_red");
		level.bowl_infantry[i] SetPerfectSense( true );
		level.bowl_infantry[i].accuracy = 0.65;

		level.bowl_infantry[i] thread bowl_death_tracker();

		level.bowl_infantry[i] thread force_rush_ready();

		level.bowl_infantry[i] thread check_to_throw_grenade();

		//level.bowl_infantry[i] thread control_approach_speed();
	}
}
/*
check_to_throw_grenade()
{
while(isalive(self))
{
distance = Distance( level.player.origin, self.origin );

if(distance < 540)
{
wait(1);
if(level.grenade_thrown == false)
{
if(isalive(self))
{
self cmdthrowgrenadeatentity(level.player, false, 1);
level.grenade_thrown = true;
rand = randomfloatrange(3.0,6.0);
wait (rand);
level.grenade_thrown = false;
}
}
}

wait(1);
}

//trigger = getent( "ai_grenade_trigger", "targetname" );
//trigger waittill( "trigger" );

// AI distance check to player

// distance is

// if distance is less than previous distance
// entity = entity name // capture AI name
}


set_ai_grenade_trigger()
{
trigger = getent( "ai_grenade_trigger", "targetname" );
trigger waittill( "trigger", thug );

//iPrintLnBold( "Grenade trigger activated" );

wait(1);

if(isalive(thug))
{
//iPrintLnBold( "Thug is alive" );
thug cmdthrowgrenadeatentity(level.player, false, 6);

//iPrintLnBold( "Grenade thrown" );
wait(3);
rand = randomfloatrange(3.0,6.0);
wait (rand);
}

level thread set_ai_grenade_trigger();
}
*/

check_for_turret_damage()
{
	//destroyed_turret_origin = getent("destroyed_turret_origin", "targetname");
	//playfxontag (level._effect["smoke"], destroyed_turret_origin, "tag_origin");


	destroyed_turret = getent("destroyed_turret", "targetname");
	destroyed_turret hide();

	turret_weapon = getent("turret_weapon", "targetname");

	level.player.turret_eject_count = 0;

	while ( level.player.turret_eject_count < 3 )
	{
		turret_weapon maketurretusable();

		turret_weapon waittill("turret_owner_damaged", turret_owner, damagetype);

		if (/*damagetype == "MOD_CONCUSSION_GRENADE" || damagetype == "MOD_GRENADE" || */damagetype == "MOD_PROJECTILE" || damagetype == "MOD_PROJECTILE_SPLASH")
		{
			level.player.turret_eject_count ++;
			//iPrintLnBold("Kicked off turret" + level.player.turret_eject_count);

			level.player turretDismount();

			turret_weapon maketurretunusable();

			wait( 0.05 );

			level.player knockback( 2000, turret_weapon.origin);
		}
	}

	turret_weapon.origin = turret_weapon.origin + (0, 0, -500);
	destroyed_turret show();

	destroyed_turret_origin = getent("destroyed_turret_origin", "targetname");
	playfxontag (level._effect["smolder"], destroyed_turret_origin, "tag_origin");
}



check_to_throw_grenade()
{
	self endon("death");

	trigger = getent( "ai_grenade_trigger", "targetname" );

	while(1)
	{
		if (self istouching (trigger))
		{
			wait(1);

			self thread throw_grenade();
		}
		wait(1);
	}
}


throw_grenade()
{
	if(level.grenade_thrown == false )// && level.lower_smoke_active == false
	{
		level.grenade_thrown = true;
		self cmdthrowgrenadeatentity(level.player, false, 1);
		rand = randomfloatrange(15.0,30.0);
		wait (rand);
		level.grenade_thrown = false;
	}
}


force_rush_ready()
{
	level waittill("force_rush");

	if ( IsDefined( self) )
	{
		if(isalive(self))
		{
			self SetCombatRole("rusher");
		}
	}
}


control_approach_speed()
{
	self setscriptspeed( "sprint" );
	self waittill("goal");
	//iPrintLnBold("Reached goal");
	self setscriptspeed( "default" );
}



bowl_death_tracker()
{
	level.total_bowl_infantry ++;

	self waittill("death");

	//level.bowl_infantry_killed ++;
	level.total_bowl_infantry --;

	////iPrintLnBold( "Total killed is " +  level.bowl_infantry_killed);
	//iPrintLnBold( "Total living infantry " +  level.total_bowl_infantry);

	/*
	if(level.bowl_infantry_killed ==5)
	{
	level thread place_bowl_reinforcements();
	}
	if(level.bowl_infantry_killed ==10)
	{
	level thread place_bowl_infantry_final_wave();
	}
	*/
}

/*
wait_for_lake_objective_completion()
{
level waittill("cleared_bowl_battle");

objective_state(8, "done");
objective_add(9, "current", &"SINK_HOLE_OBJECTIVE_HEADER_FIND_CAMILLE", GetEnt("objective_9_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_FIND_CAMILLE");
//iPrintLnBold( "Objective - find camille" );

//Music - Sniper Cue - Added by crussom
level notify( "playmusicpackage_sniper" );
}
*/
wait_for_reinforcements()
{
	level endon("reached_bowl_exit");

	level.turret_battle_active = true; // keeps smoke grenades from forcing ai into rushers.

	// force remainer to rush
	//while(level.bowl_infantry_killed < 5 )
	while(level.total_bowl_infantry > 2 )
	{
		wait(1);
	}

	level notify("force_rush");
	maps\_autosave::autosave_by_name("sink_hole");
	second_wave_side_wall();

	objective_state(8, "done");
	objective_add(9, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DEFEND_FLANK", GetEnt("objective_7_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DEFEND_FLANK");
	objective_state(9, "current");

	// 3rd wave
	//while(level.bowl_infantry_killed < 8)
	while(level.total_bowl_infantry > 4 )
	{
		wait(1);
	}

	//level notify("force_rush");
	maps\_autosave::autosave_by_name("sink_hole");
	third_wave_end_wall();

	objective_state(9, "done");
	objective_add(10, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DEFEND_ALL", GetEnt("objective_7_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DEFEND_ALL");
	objective_state(10, "current");

	while(level.lower_smoke_active == false ) // wait for smoke to deploy
	{
		wait(1);
	}
	while(level.total_bowl_infantry > 7 )
	{
		wait(1);
	}

	if(level.lower_smoke_active == true ) // is some smoke still visible?
	{
		place_smoke_rushers(1);
	}

	while(level.total_bowl_infantry > 8 )
	{
		wait(1);
	}
	if(level.lower_smoke_active == true ) // is some smoke still visible?
	{
		place_smoke_rushers(2);
	}
	/*
	while(level.total_bowl_infantry > 11 )
	{
	wait(1);
	}
	if(level.lower_smoke_active == true ) // is some smoke still visible?
	{
	place_smoke_rushers(3);
	}
	*/

	//while(level.bowl_infantry_killed < 24)
	while(level.total_bowl_infantry > 5 )
	{
		wait(1.5);
	}

	// rpg and exit
	//maps\_autosave::autosave_by_name("sink_hole");

	//place_rpg();
	//place_rpg_wave_4();
	//level.rpg_placed = true;
	//level.bowl_rpg thread wait_for_end_wall_destruction();

	level thread play_trickle_vo();
	wait(1);

	place_trickle(2); // firing line with rpg man
	place_trickle(1);
	place_trickle(3);

	//while(level.bowl_infantry_killed < 28)
	while(level.total_bowl_infantry > 6 )
	{
		wait(1);
	}
	level notify("force_rush");

	block = getent("player_turret_block", "targetname");
	block delete();

	level.bowl_cleared = true;

	if(isdefined(level.rpg_wave_3) && isalive(level.rpg_wave_3))
	{
		destination = GetNode("rpg_forward_position", "targetname");
		level.rpg_wave_3 setgoalnode(destination);
	}

	//while(level.bowl_infantry_killed < 34)
	while(level.total_bowl_infantry > 0 )
	{
		wait(1);
	}

	wait(.5);

	objective_state(10, "done");

	objective_add(11, "active", &"SINK_HOLE_OBJECTIVE_HEADER_FIND_CAMILLE", GetEnt("objective_9_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_FIND_CAMILLE");
	objective_state(11, "current");

	wait(1.5);

	turret_weapon = getent("turret_weapon", "targetname");
	level.player turretDismount();
	turret_weapon maketurretunusable();

	//level waittill("cleared_bowl_battle");

	//iPrintLnBold( "Objective - find camille" );

	//Music - Sniper Cue - Added by crussom
	level notify( "playmusicpackage_sniper" );

	wait(1);

	//maps\_autosave::autosave_by_name("sink_hole");
	maps\_autosave::autosave_now("sink_hole"); 
}




/*
wait_for_reinforcements()
{
level endon("reached_bowl_exit");

level thread set_past_trench_trigger(); 
level thread set_high_ground_trigger(); 
level thread set_bowl_side_a_trigger();

// force remainer to rush
while(level.bowl_infantry_killed < 4 )
{
wait(1);
}
level notify("force_rush");
//iPrintLnBold( "Force rush" );

// wait until near trench
trigger = getent( "trench_trigger", "targetname" );
trigger waittill( "trigger" );

////iPrintLnBold( "trench trigger" );

//2nd wave
while(level.bowl_infantry_killed < 5 )
{
wait(1);
}
maps\_autosave::autosave_by_name("sink_hole");
level thread place_bowl_second_wave();


while(level.bowl_infantry_killed < 8 )
{
wait(1);
}
level notify("force_rush");
//iPrintLnBold( "Force rush" );

// 3rd wave
while(level.bowl_infantry_killed < 10)
{
wait(1);
}
maps\_autosave::autosave_by_name("sink_hole");
level thread place_bowl_third_wave();





while(level.bowl_infantry_killed < 13)
{
wait(1);
}

// trickle in
total_killed = level.bowl_infantry_killed;
while(level.mine_tunnel_destroyed == false || level.side_wall_destroyed == false)
{
if(total_killed + 1 < level.bowl_infantry_killed)
{
total_killed = level.bowl_infantry_killed;
level thread place_trickle_reinforcments();
}
wait(1);
}

// rpg and exit
while(level.bowl_infantry_killed < 16)
{
wait(1);
}

wait(3);

maps\_autosave::autosave_by_name("sink_hole");

place_rpg();
level.rpg_placed = true;
level.bowl_rpg thread wait_for_end_wall_destruction();
place_trickle(2); // firing line with rpg man


// resume trickle in - until end wall destroyed
//total_killed = level.bowl_infantry_killed;
//while(level.end_wall_destroyed == false)
//{
//	if(total_killed + 1 < level.bowl_infantry_killed)
//	{
//		total_killed = level.bowl_infantry_killed;
//		level thread place_trickle_reinforcments();
//	}
//	wait(1);
//	}

}


set_past_trench_trigger()
{
trigger = getent( "past_trench_trigger", "targetname" );
trigger waittill( "trigger" );

level.player_past_trench = true;
}

set_high_ground_trigger()
{
while(level.end_wall_destroyed == false)
{
trigger = getent( "high_ground_trigger", "targetname" );
trigger waittill( "trigger" );

level.player_reached_high_ground = true;

wait(.25);
////iPrintLnBold( "Reached high ground" );
}
}

set_bowl_side_a_trigger()
{
while(level.end_wall_destroyed == false)
{
trigger = getent( "bowl_side_a_trigger", "targetname" );
trigger waittill( "trigger" );

level.player_on_side_a = true;

wait(.25);
}
}


place_bowl_second_wave()
{
level.player_on_side_a = false;	
wait(.5);
if(level.player_on_side_a == true) // may be changed by a trigger
{
//iPrintLnBold( "player_on_side_a" );
if(level.side_wall_destroyed == false)
{
second_wave_side_wall();
//iPrintLnBold( "second_wave_side_wall" );
}
else
{
second_wave_end_wall();
//iPrintLnBold( "second_wave_end_wall" );
}
}
else
{
//iPrintLnBold( "player NOT on_side_a" );
if(level.mine_tunnel_destroyed == false)
{
second_wave_mine_tunnel();
//iPrintLnBold( "second_wave_mine_tunnel" );
}
else
{
second_wave_end_wall();
//iPrintLnBold( "second_wave_end_wall" );
}
}
}


place_bowl_third_wave()
{
level.player_reached_high_ground = false;
level.player_on_side_a = false;	
wait(.5);
if(level.player_reached_high_ground == true) // may be changed by a trigger
{
//iPrintLnBold( "player_reached_high_ground" );
if(level.side_wall_destroyed == false)
{
third_wave_side_wall();
}
else if(level.player_on_side_a == false && level.mine_tunnel_destroyed == false)
{
//iPrintLnBold( "player_on_side_a" );
third_wave_mine_tunnel();
}
else
{
third_wave_end_wall();
}
}

else if(level.mine_tunnel_destroyed == false)
{
third_wave_mine_tunnel();
}
else
{
third_wave_end_wall();
}
}


place_trickle_reinforcments()
{
level.player_reached_high_ground = false;
level.player_on_side_a = false;	
wait(.5);
if(level.player_reached_high_ground == true) // may be changed by a trigger
{
//iPrintLnBold( "player_reached_high_ground" );
if(level.side_wall_destroyed == false)
{
trickle_side_wall();
level.side_wall_destroyed = true; // stops future spawns - even though its not really destroyed.
}
else if(level.player_on_side_a == false && level.mine_tunnel_destroyed == false)
{
//iPrintLnBold( "player_on_side_a" );
trickle_mine_tunnel();
level.mine_tunnel_destroyed = true; // stops future spawns - even though its not really destroyed.
}
else
{
trickle_end_wall();
level.mine_tunnel_destroyed = true; // stops future spawns - even though its not really destroyed.
}
}

else if(level.mine_tunnel_destroyed == false)
{
trickle_mine_tunnel();
level.mine_tunnel_destroyed = true; // stops future spawns - even though its not really destroyed.
}
else
{
trickle_end_wall();
level.side_wall_destroyed = true; // stops future spawns - even though its not really destroyed.
}
}

*/
second_wave_side_wall()
{
	//iPrintLnBold( "2nd wave side wall" );
	place_rag_doll_men(1);
	wait(1.5);
	level.helicopter_radio play_dialogue("MDS1_SinkC_620A"); // Second team in position.  Attack!
	wait(1.5);
	place_second_wave(1);
	wait(1.5);
	level.helicopter_radio play_dialogue("MDS1_SinkC_609A"); // Flanking from his right.
	//place_rpg_wave_2();
}

second_wave_end_wall()
{
	//iPrintLnBold( "2nd wave end wall" );
	place_rag_doll_men(2);
	wait(1.5);
	//play_wave2_alert_sound();
	wait(2.5);
	place_second_wave(2);
}

second_wave_mine_tunnel()
{
	//iPrintLnBold( "2nd wave mine tunnel" );

	place_rag_doll_men(3);
	wait(1.5);
	//play_wave2_alert_sound();
	wait(2.5);
	place_second_wave(3);
}
/*
play_wave2_alert_sound()
{
if(isdefined(level.rag_doll_men[0]))
{
if(isalive(level.rag_doll_men[0]))
{
level.rag_doll_men[0] play_dialogue("SAM_E_1_Flan_Cmb");
}
}
}

play_wave3_alert_sound()
{
if(isdefined(level.rag_doll_men[0]))
{
if(isalive(level.rag_doll_men[0]))
{
level.rag_doll_men[0] play_dialogue("SAM_E_2_Flan_Cmb");
}
}
}
*/

place_second_wave(location)
{
	switch(location)
	{
	case 1:
		spawner = getentarray( "second_wave_side_wall", "targetname");
		break;

	case 2:
		spawner = getentarray( "second_wave_end_wall", "targetname");
		break;

	case 3:
		spawner = getentarray( "second_wave_mine_tunnel", "targetname");
		break;

	default:
		spawner = getentarray( "second_wave_mine_tunnel", "targetname");
		iPrintLnBold( "WARNING: Switch using default" );
		break;
	}

	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		level.bowl_second_wave[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.bowl_second_wave[i]) )
		{
			return;
		}

		level.bowl_second_wave[i] lockalertstate("alert_red");
		level.bowl_second_wave[i] SetPerfectSense( true );
		level.bowl_second_wave[i].accuracy = .45;

		level.bowl_second_wave[i] thread bowl_death_tracker();

		level.bowl_second_wave[i] thread force_rush_ready();

		level.bowl_second_wave[i]  thread check_to_throw_grenade();
	}
}


third_wave_side_wall()
{
	//iPrintLnBold( "3rd wave side wall" );

	place_rag_doll_men(1);
	wait(1.5);
	//play_wave3_alert_sound();
	wait(2.5);
	place_third_wave(1);
}

third_wave_end_wall()
{
	//iPrintLnBold( "3rd wave end wall" );
	place_rag_doll_men(2);
	level thread smoke_screen_timing();
	wait(10);//10
	level.helicopter_radio play_dialogue("MDS1_SinkC_610A"); // We’re moving on him.
	place_third_wave(2);
	wait(4);
	level.helicopter_radio play_dialogue("MDS1_SinkC_605A"); // Contact, 12 o’clock!  Attack!
	wait(8);//8
	place_rpg_wave_3();
}

smoke_screen_timing()
{
	wait(12);
	level.lower_smoke_active = true;
	//iPrintLnBold( "Lower Smoke" );
	//level thread place_smoke_rushers(1);

	wait(4);
	level.middle_smoke_active = true;
	//iPrintLnBold( "Middle Smoke" );
	//level thread place_smoke_rushers(2);

	wait(5);
	level.upper_smoke_active = true;
	//iPrintLnBold( "Upper Smoke" ); // 20
	//level thread place_smoke_rushers(3);

	wait(24);
	level.upper_smoke_active = false;
	//iPrintLnBold( "Upper Clear" );

	wait(3);
	level.middle_smoke_active = false;
	//iPrintLnBold( "Middle Clear" );

	wait(8);
	level.lower_smoke_active = false;
	//iPrintLnBold( "Lower Clear" );
}



third_wave_mine_tunnel()
{
	//iPrintLnBold( "3rd wave mine tunnel" );

	place_rag_doll_men(3);
	wait(1.5);
	//play_wave3_alert_sound();
	wait(2.5);
	place_third_wave(3);
}

place_third_wave(location)
{
	switch(location)
	{
	case 1:
		spawner = getentarray( "third_wave_side_wall", "targetname");
		break;

	case 2:
		spawner = getentarray( "third_wave_end_wall", "targetname");
		break;

	case 3:
		spawner = getentarray( "third_wave_mine_tunnel", "targetname");

		break;

	default:
		spawner = getentarray( "third_wave_mine_tunnel", "targetname");
		iPrintLnBold( "WARNING: Switch using default" );
		break;
	}

	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		level.bowl_third_wave[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.bowl_third_wave[i]) )
		{
			return;
		}

		level.bowl_third_wave[i] lockalertstate("alert_red");
		level.bowl_third_wave[i] SetPerfectSense( true );
		level.bowl_third_wave[i].accuracy = .25;
		level.bowl_third_wave[i] thread bowl_death_tracker();

		level.bowl_third_wave[i] thread force_rush_ready();

		level.bowl_third_wave[i]  thread check_to_throw_grenade();
	}
}

play_trickle_vo()
{
	level.helicopter_radio play_dialogue("MDS1_SinkC_618A"); // Move in!  Flank him!  Go!
	wait(2);
	level.helicopter_radio play_dialogue("MDS1_SinkC_608A"); // Flanking from his left.
	wait(1);
	level.helicopter_radio play_dialogue("MDS1_SinkC_611A"); // Engaging from right
}


trickle_side_wall()
{
	//iPrintLnBold( "trickle side wall" );
	place_trickle(1);
}

trickle_end_wall()
{
	//iPrintLnBold( "trickle end wall" );
	place_trickle(2);
}

trickle_mine_tunnel()
{
	//iPrintLnBold( "trickle mine tunnel" );
	place_trickle(3);
}

place_smoke_rushers(smoke_level)
{
	switch(smoke_level)
	{
	case 1:
		spawner = getentarray( "smoke_rusher_low", "targetname");
		break;

	case 2:
		spawner = getentarray( "smoke_rusher_middle", "targetname");
		break;

	case 3:
		spawner = getentarray( "smoke_rusher_high", "targetname");
		break;

	default:
		spawner = getentarray( "smoke_rusher_high", "targetname");
		break;

	}

	if ( !IsDefined( spawner) )
	{
		//iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		if(isdefined(level.smoke_rusher[i]))
		{
			if(!isalive(level.smoke_rusher[i]))
			{
				level.smoke_rusher[i] delete();
				//iPrintLnBold( "Deleting dead trickle" );
				wait(1);
			}
		}

		level.smoke_rusher[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.smoke_rusher[i]) )
		{
			//iPrintLnBold( "smoke_rusher spawn failed!" );
			return;
		}

		level.smoke_rusher[i] lockalertstate("alert_red");
		level.smoke_rusher[i] SetPerfectSense( true );
		level.smoke_rusher[i].accuracy = .25;

		level.smoke_rusher[i] thread bowl_death_tracker();
	}
}

set_past_trench_trigger()
{
	trigger = getent( "trench_trigger", "targetname" );
	trigger waittill( "trigger" );

	if(level.bowl_cleared == true) // spawn a single guy showing the exit
	{
		spawner = getent( "bread_crumb_turret", "targetname");

		if ( !IsDefined( spawner) )
		{
			iPrintLnBold( "Spawner Not Defined!" );
			return;
		}

		level.bread_crumb_turret = spawner stalingradspawn();

		if ( spawn_failed(level.bread_crumb_turret) )
		{
			iPrintLnBold( "bread crumb spawn failed!" );
			return;
		}

		level.bread_crumb_turret lockalertstate("alert_red");
		level.bread_crumb_turret SetPerfectSense( true );
		//level.bread_crumb_turret.accuracy = .65;

		//level.bread_crumb_turret thread bowl_death_tracker();
	}

	else  // spawn 6 guys to make the player work to exit early
	{
		spawner = getentarray( "early_exit_infantry", "targetname");
		if ( !IsDefined( spawner) )
		{
			iPrintLnBold( "Spawner Not Defined!" );
			return;
		}

		for( i = 0; i < spawner.size; i++ )
		{
			level.early_exit_infantry[i] = spawner[i] stalingradspawn();

			if ( spawn_failed(level.early_exit_infantry[i]) )
			{
				return;
			}

			level.early_exit_infantry[i] lockalertstate( "alert_red" );
			level.early_exit_infantry[i] SetPerfectSense( true );
			level.early_exit_infantry[i] thread bowl_death_tracker();
			//level.early_exit_infantry[i] thread diaroma_death_tracker();
		}
	}
}


place_trickle(location)
{
	switch(location)
	{
	case 1:
		spawner = getentarray( "trickle_side_wall", "targetname");
		break;

	case 2:
		if(level.rpg_placed == false)
		{
			spawner = getentarray( "trickle_end_wall", "targetname");
			iPrintLnBold( "trickle normal end wall" );
		}
		else
		{
			spawner = getentarray( "trickle_firing_line", "targetname");
			iPrintLnBold( "trickle - firing line" );
		}
		break;

	case 3:
		spawner = getentarray( "trickle_mine_tunnel", "targetname");
		break;

	default:
		spawner = getentarray( "trickle_mine_tunnel", "targetname");
		iPrintLnBold( "WARNING: Switch using default" );
		break;
	}

	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		if(isdefined(level.bowl_trickle[i]))
		{
			if(!isalive(level.bowl_trickle[i]))
			{
				level.bowl_trickle[i] delete();
				//iPrintLnBold( "Deleting dead trickle" );
				wait(1);
			}
		}

		level.bowl_trickle[i] = spawner[i] stalingradspawn();
		//iPrintLnBold( "Spawning trickle" );
		if ( spawn_failed(level.bowl_trickle[i]) )
		{
			//iPrintLnBold( "Trickle spawn failed!" );
			return;
		}

		//iPrintLnBold( "finishing trickle spawn" );
		level.bowl_trickle[i] lockalertstate("alert_red");
		level.bowl_trickle[i] SetPerfectSense( true );
		level.bowl_trickle[i].accuracy = .25;

		level.bowl_trickle[i] thread bowl_death_tracker();
		level.bowl_trickle[i] thread force_rush_ready();

		level.bowl_trickle[i]  thread check_to_throw_grenade();
	}
}

place_rpg()
{
	//level thread reveal_end_wall_explosive();


	// place rpg man
	spawner = getent( "bowl_rpg", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.bowl_rpg = spawner stalingradspawn();

	if ( spawn_failed(level.bowl_rpg) )
	{
		return;
	}

	level.bowl_rpg thread manage_rpg(3);
}

place_rpg_wave_1()
{
	spawner = getent( "rpg_wave_1", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.rpg_wave_1 = spawner stalingradspawn();

	if ( spawn_failed(level.rpg_wave_1) )
	{
		return;
	}

	level.rpg_wave_1 thread manage_rpg(1);
}

place_rpg_wave_2()
{
	spawner = getent( "rpg_wave_2", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.rpg_wave_2 = spawner stalingradspawn();

	if ( spawn_failed(level.rpg_wave_2) )
	{
		return;
	}

	level.rpg_wave_2 thread manage_rpg(2);
}

place_rpg_wave_3()
{
	spawner = getent( "rpg_wave_3", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.rpg_wave_3 = spawner stalingradspawn();

	if ( spawn_failed(level.rpg_wave_3) )
	{
		return;
	}

	level.rpg_wave_3 thread manage_rpg(2);
}
/*
place_rpg_wave_4()
{
spawner = getent( "rpg_wave_4", "targetname");
if ( !IsDefined( spawner) )
{
//iPrintLnBold( "Spawner Not Defined!" );
return;
}

level.rpg_wave_4 = spawner stalingradspawn();

if ( spawn_failed(level.rpg_wave_4) )
{
return;
}

level.rpg_wave_4 thread manage_rpg();
}
*/
manage_rpg(blocked_by_smoke)
{
	self lockalertstate("alert_yellow");
	//self SetPerfectSense( true );
	self SetEnableSense( false );

	self thread bowl_death_tracker();

	self.dropweapon = false;


	self waittill("goal");
	//iPrintLnBold("Reached goal");
	wait(.5);

	accuracy = -5000;
	/*
	if(isdefined(self))
	{
	if(isalive(self))
	{
	self cmdshootatentityxtimes( level.player, false, 1, 0 ); // force miss first shot
	wait(3);
	}
	}
	*/
	min_error = 70;
	max_error = 120;

	said_fire_in_the_hole = false;
	while(isalive(self))
	{
		//if(isdefined(self))
		//{
		if(blocked_by_smoke == 1 && level.lower_smoke_active == true)
		{
		}
		else if(blocked_by_smoke == 2 && level.middle_smoke_active == true)
		{
		}
		else if(blocked_by_smoke == 3 && level.upper_smoke_active == true)
		{
		}
		else
		{
			random_error_0 = randomfloatrange(min_error, max_error);
			random_error_1 = randomfloatrange(min_error,max_error);
			random_error_2 = randomfloatrange(min_error,max_error);

			target_position = level.player geteye() + (random_error_0, random_error_1, random_error_2);

			if (!said_fire_in_the_hole)	// just say this once
			{
				level.helicopter_radio play_dialogue_nowait("MDS1_SinkC_623A"); // Heads down!  Fire in the hole!
				said_fire_in_the_hole = true;
			}

			wait(.1);

			self cmdshootatposxtimes( target_position, false, 1, 0 );

			if(min_error >0)
			{
				min_error = min_error -10;
				max_error = max_error -10;
			}
			else
			{
				min_error = 50;
				max_error = 100;
			}

		}
		//}
		wait(randomfloatrange( 10, 20 ));
	}
}

/*
place_bowl_reinforcements()
{
spawner = getentarray( "bowl_infantry_reinforcements", "targetname");
if ( !IsDefined( spawner) )
{
//iPrintLnBold( "Spawner Not Defined!" );
return;
}

for( i = 0; i < spawner.size; i++ )
{
level.bowl_infantry_reinforcements[i] = spawner[i] stalingradspawn();

if ( spawn_failed(level.bowl_infantry_reinforcements[i]) )
{
return;
}

level.bowl_infantry_reinforcements[i] lockalertstate("alert_red");
level.bowl_infantry_reinforcements[i]  SetPerfectSense( true );

level.bowl_infantry_reinforcements[i] thread bowl_death_tracker();
}
}

place_bowl_infantry_final_wave_a()
{
spawner = getentarray( "bowl_infantry_final_wave_a", "targetname");
if ( !IsDefined( spawner) )
{
//iPrintLnBold( "Spawner Not Defined!" );
return;
}

for( i = 0; i < spawner.size; i++ )
{
level.bowl_infantry_final_wave[i] = spawner[i] stalingradspawn();

if ( spawn_failed(level.bowl_infantry_final_wave[i]) )
{
return;
}

level.bowl_infantry_final_wave[i] lockalertstate("alert_red");
level.bowl_infantry_final_wave[i]  SetPerfectSense( true );
}
}

place_bowl_infantry_final_wave_b()
{
spawner = getentarray( "bowl_infantry_final_wave_b", "targetname");
if ( !IsDefined( spawner) )
{
//iPrintLnBold( "Spawner Not Defined!" );
return;
}

for( i = 0; i < spawner.size; i++ )
{
level.bowl_infantry_final_wave[i] = spawner[i] stalingradspawn();

if ( spawn_failed(level.bowl_infantry_final_wave[i]) )
{
return;
}

level.bowl_infantry_final_wave[i] lockalertstate("alert_red");
level.bowl_infantry_final_wave[i]  SetPerfectSense( true );
}
}
*/




///////// EVENT: SNIPER BOSS FIGHT /////////

set_snipers_perch_trigger()
{
	trigger = getent( "snipers_perch_trigger", "targetname" );
	trigger waittill( "trigger" );

	level thread wait_for_wing_fall();

	level notify("reached_bowl_exit");
	wait(.2);

	remove_surviving_bowl_ai();
	//level.total_bowl_infantry = 0;

	//objective_state(8, "done");

	maps\_autosave::autosave_now("sink_hole"); // After the 2nd combat area, before the snipers 

	place_camille_diorama();
	//level.camille_diorama thread magic_bullet_shield();
	level.camille_diorama SetCanDamage(false);	// makes it so you don't fail if you shoot her
	place_sniper_infantry();
	place_sniper();
	level thread set_alert_status_trigger();
	level thread set_quick_kill_distance_trigger();

	// BEN WANG 6/22/08: NO MORE SNIPER SCOPE HANDLED IN SCRIPT, code takes over, makes things happier.
	//level thread sniperScope();

	level.player play_dialogue("CAMI_SinkG_048A", true);
	place_camille_infantry();
	wait(2);
	//level.player play_dialogue("CAMI_SinkG_049A", true);

	//level.player play_dialogue("CAMI_SinkG_025A");// get back
	//level.player play_dialogue("CAMI_SinkG_026A");// stay away from me

	wait(2);
	//objective_add(9, "current", &"SINK_HOLE_OBJECTIVE_HEADER_FIND_CAMILLE", GetEnt("objective_9_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_FIND_CAMILLE");
	////iPrintLnBold( "Objective - find camille" );
	level notify("cleared_bowl_battle");

	//Music - Sniper Cue - Added by crussom
	level notify( "playmusicpackage_sniper" );
}

remove_surviving_bowl_ai()
{
	for( i = 0; i < level.bowl_infantry.size; i++ )
	{
		if (isalive(level.bowl_infantry[i]))
		{
			level.bowl_infantry[i] delete();
		}
	}

	for( i = 0; i < level.bowl_second_wave.size; i++ )
	{
		if (isalive(level.bowl_second_wave[i]))
		{
			level.bowl_second_wave[i] delete();
		}
	}

	for( i = 0; i < level.bowl_third_wave.size; i++ )
	{
		if (isalive(level.bowl_third_wave[i]))
		{
			level.bowl_third_wave[i] delete();
		}
	}

	for( i = 0; i < level.bowl_trickle.size; i++ )
	{
		if (isalive(level.bowl_trickle[i]))
		{
			level.bowl_trickle[i] delete();
		}
	}

	//if (isalive(level.bowl_rpg))
	//{
	//	level.bowl_rpg delete();
	//}

	if (isalive(level.rpg_wave_1))
	{
		level.rpg_wave_1 delete();
	}

	if (isalive(level.rpg_wave_3))
	{
		level.rpg_wave_3 delete();
	}

	for( i = 0; i < level.rag_doll_men.size; i++ )
	{
		if (isalive(level.rag_doll_men[i]))
		{
			level.rag_doll_men[i] delete();
		}
	}

	for( i = 0; i < level.smoke_rusher.size; i++ )
	{
		if (isalive(level.smoke_rusher[i]))
		{
			level.smoke_rusher[i] delete();
		}
	}

	for( i = 0; i < level.early_exit_infantry.size; i++ )
	{
		if (isalive(level.early_exit_infantry[i]))
		{
			level.early_exit_infantry[i] SetCombatRole( "rusher" );
		}
	}

}

set_sniper_vo_trigger()
{
	trigger = getent( "sniper_vo_trigger", "targetname" );
	trigger waittill( "trigger" );

	////iPrintLnBold( "Play VO - Snipers talking" );
	////VisionSetNaked( "sink_hole_sniper", 6.0 );
	//objective_add(4, "current", &"SINK_HOLE_OBJECTIVE_PROTECT_HEADER", (0, 0, 0), &"SINK_HOLE_OBJECTIVE_PROTECT");

	if(isalive(level.sniper_infantry) && level.sniper_infantry_alerted == false)
	{
		level.sniper_infantry play_dialogue("SHS1_SinkG_021A");	 // take the shot

		if(isalive(level.sniper) && level.sniper_alerted == false)
		{
			level.sniper play_dialogue("SHS2_SinkG_524A");	// she keep moving

			if(isalive(level.sniper_infantry) && level.sniper_infantry_alerted == false)
			{
				level.sniper_infantry play_dialogue("SHS1_SinkG_023A");	 // don't hesitate
				wait(2.5);

				if(isalive(level.sniper) && level.sniper_alerted == false)
				{
					iPrintLnBold( "Play dialoge" );
					level.sniper play_dialogue("SHS2_SinkG_024A");	// just a little further  
				}
			}
		}
	}
}

place_camille_diorama()
{
	spawner = getent( "camille_diorama_spawner", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.camille_diorama = spawner stalingradspawn();

	if ( spawn_failed(level.camille_diorama) )
	{
		return;
	}

	level.camille_diorama lockalertstate( "alert_green" );
	level.camille_diorama.team = "allies";
	//level.camille_diorama SetCombatRole( "turret" );
	level.camille_diorama SetTetherRadius( 80 );
	level.camille_diorama setpainenable( false );
	level.camille_diorama allowedStances ("crouch");
	level.camille_diorama.targetname = "camille_diorama";

	level.camille_diorama.health = 1000000;

	level.camille_diorama thread play_camille_combat_anims();
}

play_camille_combat_anims()
{
	level endon("no_targets_for_camille");
	self thread Camille_weapon_fire();

	self cmdplayanim("Camille_Cover_Idle", false);

	//while(level.camille_final_wave_deployed == false)
	while (true)
	{
		self cmdplayanim("Camille_Cover_PopOut_Peek", false);
		self cmdplayanim("Camille_Cover_Idle", false);

		wait 3;
		self StopCmd();	// fire
		self waittill("cmd_done");

		self cmdplayanim("Camille_Cover_BlindFire_Out", false);
		self cmdplayanim("Camille_Cover_Idle", false);

		wait 3;
		self StopCmd();	// fire
		self waittill("cmd_done");
	}

	// not sure if you need this - is it doing the same thing?
	//while(1)
	//{
	//	self cmdplayanim("Camille_Cover_Idle", false);
	//	self waittill( "cmd_done" );

	//	self cmdplayanim("Camille_Cover_PopOut_Peek", false);
	//	self waittill( "cmd_done" );
	//	self cmdplayanim("Camille_Cover_Idle", false);
	//	self waittill( "cmd_done" );

	//	self cmdplayanim("Camille_Cover_PopOut_Fire", false);
	//	self waittill( "cmd_done" );
	//	self cmdplayanim("Camille_Cover_Idle", false);
	//	self waittill( "cmd_done" );
	//}
}


Camille_weapon_fire()
{
	level endon("no_targets_for_camille");

	while(1)
	{
		//level waittill("start_fire");
		self waittillmatch("anim_notetrack", "start_fire");

		////iPrintLnBold( "Camille fires weapon" );
		self thread begin_firing();
	}
}


begin_firing()
{
	level endon("no_targets_for_camille");
	self endon("camille_stops_firing");
	self thread raise_end_signal();

	gun_barrel_origin = self GetTagOrigin("tag_flash");

	while(1)
	{
		if(level.camille_final_wave_deployed == false)
		{
			random_error_0 = randomfloatrange(5.0,15.0);
			random_error_1 = randomfloatrange(5.0,15.0);
			random_error_2 = randomfloatrange(5.0,15.0);
		}
		else
		{
			random_error_0 = randomfloatrange(1.0,5.0);
			random_error_1 = randomfloatrange(1.0,5.0);
			random_error_2 = randomfloatrange(1.0,5.0);
		}

		camille_target = choose_target();
		target_position = camille_target geteye() + (random_error_0, random_error_1, random_error_2);
		magicbullet( "TND16_Sink", gun_barrel_origin, target_position);
		wait(.1);
	}
}


raise_end_signal()
{
	self waittillmatch("anim_notetrack", "stop_fire");
	////iPrintLnBold( "Camille stops firing" );
	self notify("camille_stops_firing");
}

choose_target()
{
	for( i = 0; i < level.camille_infantry.size; i++ )
	{
		if(isalive(level.camille_infantry[i]))
		{
			return(level.camille_infantry[i]);
		}
	}
	for( i = 0; i < level.camille_reinforcements.size; i++ )
	{
		if(isalive(level.camille_reinforcements[i]))
		{
			return(level.camille_reinforcements[i]);
		}
	}

	level.camille_final_wave_deployed = true;

	for( i = 0; i < level.camille_final_wave.size; i++ )
	{
		if(isalive(level.camille_final_wave[i]))
		{
			return(level.camille_final_wave[i]);
		}
	}

	level.camille_diorama cmdplayanim("Camille_Cover_Idle", false);

	level notify("no_targets_for_camille");
}

/*
num_shots = randomintrange(5, 9);
for(i=0; i<num_shots; i++)
{
random_error_0 = randomfloatrange(10.0,30.0);
random_error_1 = randomfloatrange(10.0,30.0);
random_error_2 = randomfloatrange(10.0,30.0);

target_position = level.quick_kill_infantry geteye() + (random_error_0, random_error_1, random_error_2);
magicbullet( "TND16_Sink", camille_gunshot_position.origin, target_position);
wait(.1);
}	

wait(randomfloatrange(4.0,7.0));
*/


place_camille_infantry()
{
	spawner = getentarray( "camille_infantry", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		level.camille_infantry[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.camille_infantry[i]) )
		{
			return;
		}

		level.camille_infantry[i] lockalertstate( "alert_red" );
		level.camille_infantry[i] setignorethreat(level.player, true);
		level.camille_infantry[i] SetPerfectSense( true );

		level.camille_infantry[i] thread diaroma_death_tracker();
	}
}


diaroma_death_tracker()
{
	level endon("helicopter crashing");

	self waittill("death");

	level.diorama_infantry_killed++;
	/*
	if(level.diorama_infantry_killed == 2)
	{
	for( i = 0; i < level.camille_infantry.size; i++ )
	{
	if(isdefined(level.camille_infantry[i]))
	{
	if(isalive(level.camille_infantry[i]))
	{
	level.camille_infantry[i] setignorethreat(level.player, false);
	}
	}
	}

	for( i = 0; i < level.camille_reinforcements.size; i++ )
	{
	if(isdefined(level.camille_reinforcements[i]))
	{
	if(isalive(level.camille_reinforcements[i]))
	{
	level.camille_reinforcements[i] setignorethreat(level.player, false);
	}
	}
	}
	}
	*/

	if(level.diorama_infantry_killed == 2)
	{
		level.player play_dialogue("CAMI_SinkG_516B", true);
		//wait(1.5);
		//level.player play_dialogue("BOND_GlobG_125A", true);
	}

	if(level.diorama_infantry_killed == 3)
	{
		place_camille_final_wave();
		wait(4);
		level notify("wing_fall");
	}

	if(level.diorama_infantry_killed == 5)
	{
		level notify("begin_boss_fight");
	}
}


place_camille_final_wave()
{
	spawner = getentarray( "camille_infantry_final_wave", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		level.camille_final_wave[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.camille_final_wave[i]) )
		{
			return;
		}

		level.camille_final_wave[i] lockalertstate( "alert_red" );
		level.camille_final_wave[i] SetPerfectSense( true );
		level.camille_final_wave[i] thread diaroma_death_tracker();
		level.camille_final_wave[i] setignorethreat(level.camille_diorama, true);
	}
}


place_sniper_infantry()
{
	spawner = getent( "sniper_infantry", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.sniper_infantry = spawner stalingradspawn();

	if ( spawn_failed(level.sniper_infantry) )
	{
		return;
	}

	//level.sniper_infantry lockalertstate("alert_green");
	level.sniper_infantry SetEnableSense( false );
	//level.sniper_infantry setalertstatemax("alert_green");
	//level.sniper_infantry cmdAction("fidget");
	level.sniper_infantry SetCombatRole( "rusher" );

	level.sniper_infantry thread death_tracker();
	level.sniper_infantry thread sniper_alert_check();

	level.sniper_infantry setignorethreat(level.camille_diorama, true);
}

place_sniper()
{
	spawner = getent( "sniper", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	level.sniper = spawner stalingradspawn();

	if ( spawn_failed(level.sniper) )
	{
		return;
	}

	level.sniper allowedStances ("crouch");
	//level.sniper lockalertstate("alert_red");
	//level.sniper setalertstatemin("alert_green");
	level.sniper cmdaimatentity(level.camille_diorama, false, -1);

	level.sniper thread death_tracker();
	level.sniper thread sniper_alert_check();
}


set_alert_status_trigger()
{
	trigger = getent("alert_status_trigger", "targetname");

	trigger waittill ("trigger");

	level thread play_sniper_collapse_dust_effect(0);
	level.player_in_sniper_perch = true;

	player_sniper_block = getent("player_sniper_block", "targetname");
	player_sniper_block.origin = player_sniper_block.origin + (0, 0, 200);

	if(isalive(level.sniper_infantry)) 
	{
		//level.sniper_infantry setalertstatemax("alert_red");
		//level.sniper_infantry stopcmd();
		level.sniper_infantry SetEnableSense( true );
	}
}


set_quick_kill_distance_trigger()
{
	level endon("sniper_group_injured");

	trigger = getent( "sniper_guard_sight_trigger", "targetname" );
	trigger waittill( "trigger" );

	level.within_quick_kill_distance = true;
}


/*
set_sniper_guard_sight_trigger()
{
level endon("sniper_group_injured");

trigger = getent( "sniper_guard_sight_trigger", "targetname" );
trigger waittill( "trigger" );


if(isalive(self))
{
self lockalertstate("alert_red");

wait(1);

level.sniper allowedStances ("crouch", "stand");
level.sniper stopcmd();

level notify("sniper_group_injured");
}

// This would have been new to replace what is above.  But I don't think it is necessary at all any more
if(isalive(level.sniper_infantry)) 
{
level.sniper_infantry lockalertstate("alert_red");
level.sniper_infantry SetEnableSense( true );
level.sniper_infantry SetPerfectSense(true);
//iPrintLnBold( "Sniper infantry alerted" );
}

if(isalive(level.sniper)) 
{
level.sniper stopcmd();
wait(.2);
level.sniper setignorethreat(level.camille_diorama, true);
level.sniper lockalertstate("alert_red");
level.sniper SetPerfectSense(true);
level.sniper allowedStances ("crouch", "stand");
//iPrintLnBold( "Sniper alerted" );
}

level notify("sniper_group_injured");
}
*/

sniper_alert_check()
{
	level endon("sniper_group_injured");

	self thread detect_shots();
	self waittill_any( "damage", "death", "sniper_alert" );

	if(isalive(level.sniper_infantry)) 
	{
		level.sniper_infantry lockalertstate("alert_red");
		level.sniper_infantry SetEnableSense( true );
		level.sniper_infantry SetPerfectSense(true);
		//iPrintLnBold( "Sniper infantry alerted" );
		level.sniper_infantry_alerted = true;
	}

	if(isalive(level.sniper)) 
	{
		if(level.within_quick_kill_distance == true)
		{
			wait(1.0);
		}
		level.sniper stopcmd();
		level.sniper setignorethreat(level.camille_diorama, true);
		level.sniper lockalertstate("alert_red");
		level.sniper SetPerfectSense(true);
		level.sniper allowedStances ("crouch", "stand");
		//iPrintLnBold( "Sniper alerted" );
		level.sniper_alerted = true;
	}

	level notify("sniper_group_injured");
}

detect_shots()
{
	trig = GetEnt("sniper_dmg_trigger", "targetname");
	trig waittill("trigger");
	self notify("sniper_alert");
}

death_tracker()
{
	self waittill("death");

	level.sniper_group_killed ++;

	if(level.sniper_group_killed >=2)
	{
		while(level.player_in_sniper_perch == false)
		{
			wait(1);
		}

		level thread place_camille_reinforcements();

		level thread begin_boss_fight();

		objective_state(11, "done");
		objective_add(12, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DEFEND_CAMILLE", GetEnt("objective_9_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DEFEND_CAMILLE");
		objective_state(12, "current");
		//iPrintLnBold( "Objective - defend camille" );

		wait(2);

		level.player play_dialogue("CAMI_SinkG_027A", true);
	}
}

place_camille_reinforcements()
{
	spawner = getentarray( "camille_infantry_reinforcements", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "Spawner Not Defined!" );
		return;
	}

	for( i = 0; i < spawner.size; i++ )
	{
		level.camille_reinforcements[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.camille_reinforcements[i]) )
		{
			return;
		}

		level.camille_reinforcements[i] lockalertstate( "alert_red" );
		level.camille_reinforcements[i] setignorethreat(level.player, true);
		level.camille_reinforcements[i] SetPerfectSense( true );

		level.camille_reinforcements[i] thread diaroma_death_tracker();
	}
}
/*
setup_sniperScope()
{
level.player endon ("death");

while(true)
{
wait(0.05);
currentweapon = level.player GetCurrentWeapon();
// BEN WANG 6/22/08: Removed sniper scope script calls, this is handled in code now
//sniperScope();
}	
}	
*/

///////// BEGIN BOSS FIGHT /////////

begin_boss_fight()
{
	// wait for boss fight to begin
	level thread countdown_to_boss_fight(30);// 30
	//level thread player_shots_before_boss_fight();

	level waittill("begin_boss_fight");

	//maps\_autosave::autosave_now("sink_hole"); // Just before the player takes on the helicopter (player begins saving Camille and helicopter is descending to attack) 
	maps\_autosave::autosave_by_name("sink_hole");

	level notify("change_rpg_facing");
	wait(1);

	if(isdefined(level.gunner))
	{
		if(isalive(level.gunner))
		{
			level.gunner DoDamage( 500, ( 0, 0, 0 ) );
			//level.gunner delete();
			level.gunner hide();
		}
	}

	if(isdefined(level.helicopter.copilot))
	{
		level.helicopter.copilot delete();
	}

	level.helicopter show();

	if(isdefined(level.helicopter.pilot))
	{
		level.helicopter.pilot show();
	}


	//if(isdefined(level.pilot))
	//{
	level.helicopter thread pilot_death_tracker();
	//}
	//else
	//{
	//	//iPrintLnBold( "Pilot Not Defined!" );
	//}

	//wait(1);

	level.facing_adjustment = -90; // weird bug work around in which angles for right rpg facing are different from start of event.
	level.gunner_facing_adjustment = 90;

	place_boss_gunner_right();
	//wait(.5);
	//place_boss_gunner_left();
	place_boss_rpg(); // right

	wait(1);

	//level thread maintain_pilot_link();

	level.helicopter thread begin_helicopter_patrol("sniper_descent_path", 30);

	level thread manage_boss_fight_searchlight();

	level.helicopter waittill("turn_on_spotlight");
	level.player play_dialogue_nowait("CAMI_SinkG_525A", true); // look out james, the helicopter

	//Music - Boss fight Cue - Added by crussom
	level notify( "playmusicpackage_helicopter" );

	level.helicopter waittill("helicopter_rotation");

	wait(3);
	level.helicopter setLookAtEnt( level.player );

	level.helicopter waittill("end_of_path");

	//level.helicopter clearLookAtEnt();
	level.helicopter SetLookAtEntYawOffset( 45 );
	level.helicopter thread manage_helicopter_facing();

	level.helicopter thread begin_helicopter_patrol("sniper_dual_gun_pass_path", 10);

	objective_add(13, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DESTROY_HELICOPTER", GetEnt("objective_9_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DESTROY_HELICOPTER");
	objective_state(13, "current");

	wait(4);
	level.helicopter notify("start_shooting_right");
	wait(5);
	level.facing_adjustment = 0;  // weird bug work around in which angles for right rpg facing are different from start of event.
	level.gunner_facing_adjustment = -135;
}

countdown_to_boss_fight(time)
{
	wait(time);
	level notify("begin_boss_fight");
}


player_shots_before_boss_fight()
{
	level endon("begin_boss_fight");

	wait(2); // to give the player a chance to pick up the sniper rifle and not count extra shots at the sniper

	times_player_fired = 0;

	while(1)
	{
		if ( level.player attackbuttonpressed() )
		{
			times_player_fired++;

			if(times_player_fired >0)
			{
				level notify("begin_boss_fight");
			}
		}
		wait(.25);
	}
}

manage_helicopter_facing()
{
	level endon("helicopter crashing");

	self waittill("start_shooting_right");
	wait(2);
	self setLookAtEnt( level.player );
	self SetLookAtEntYawOffset( 90 );

	while(1)
	{
		self waittill("start_shooting_left");
		self SetLookAtEntYawOffset( 0 );
		wait(2);
		self SetLookAtEntYawOffset( -90 );

		self waittill("start_shooting_right");
		self SetLookAtEntYawOffset( 0 );
		wait(2);
		self SetLookAtEntYawOffset( 90 );
	}
}

place_boss_gunner_right()
{
	spawner = getent( "boss_gunner", "targetname");
	if ( !IsDefined( spawner) )
	{
		//iPrintLnBold( "No Spawner!" );
		return;
	}

	level.gunner_right = spawner stalingradspawn();

	while ( spawn_failed(level.gunner_right) )
	{
		for(i=0; i<6; i++)
		{
			if ( spawn_failed(level.gunner_right) )
			{
				//iPrintLnBold( "Gunner Spawner Failed!!!" );
				wait(.25);
				level.gunner_right = spawner stalingradspawn();
			}
		}

		if ( spawn_failed(level.gunner_right) )
		{
			//iPrintLnBold( "Aborting Gunner Spawn" );
			level.gunners_killed ++;
			return;
		}
	}

	level.gunner_right allowedStances ("crouch");
	//level.gunner_right SetPerfectSense( true );
	level.gunner_right SetEnableSense( false );
	level.gunner_right lockalertstate( "alert_red" );
	level.gunner_right.dropweapon = false;
	//level.gunner_right thread maintain_facing("right");

	level.gunner_right thread gunner_death_tracker(1);

	level thread manage_boss_gunner();
}

/*
place_boss_gunner_left()
{
spawner = getent( "gunner_spawner", "targetname");
if ( !IsDefined( spawner) )
{
//iPrintLnBold( "No Spawner!" );
return;
}

level.gunner_left = spawner stalingradspawn();

if ( spawn_failed(level.gunner_left) )
{
return;
}

level.gunner_left allowedStances ("crouch");
level.gunner_left SetPerfectSense( true );
level.gunner_left lockalertstate( "alert_yellow" );

level.gunner_left thread maintain_facing("left");

level.gunner_left thread gunner_death_tracker();
}
*/


place_boss_rpg()
{
	spawner = getent( "rpg_spawner", "targetname");
	if ( !IsDefined( spawner) )
	{
		//iPrintLnBold( "No Spawner!" );
		return;
	}

	level.gunner_rpg = spawner stalingradspawn();

	if ( spawn_failed(level.gunner_rpg) )
	{
		return;
	}

	level.gunner_rpg allowedStances ("crouch");
	//level.gunner_rpg SetPerfectSense( true );
	level.gunner_rpg SetEnableSense( false );
	level.gunner_rpg lockalertstate( "alert_red" );
	level.gunner_rpg.dropweapon = false;

	// disable pain so that it can get special deathanimation played
	level.gunner_rpg setpainenable( false );


	//level.gunner_rpg setforcedbalconydeath();

	//level.gunner_rpg thread maintain_facing("left");

	//gunner_angles = level.helicopter getTagAngles( "tag_playerride" ) ;
	//level.gunner_rpg linkto( level.helicopter, "tag_playerride", ( -5, 0, 8 ), gunner_angles); // right gunner

	level.gunner_rpg thread gunner_death_tracker(2);

	level thread manage_boss_rpg();
}

manage_boss_rpg()
{
	level.gunner_rpg endon("death");
	level endon("helicopter crashing");

	level.gunner_rpg thread maintain_rpg_facing("right");

	while(isalive(level.gunner_rpg))
	{
		level.helicopter waittill("start_shooting_right");

		if(isalive(level.gunner_rpg))
		{
			//wait(.2);
			level.gunner_rpg stopcmd();
			wait(.5);
			level.gunner_rpg thread maintain_rpg_facing("right");
			wait(4);
			level.gunner_rpg thread rpg_fire_bursts();
			//level.gunner_rpg cmdshootatentity( level.helicopter.spotlight_target, false, -1, 10 );
		}


		level.helicopter waittill("start_shooting_left");
		if(isalive(level.gunner_rpg))
		{
			//wait(.2);
			level.gunner_rpg stopcmd();
			wait(.5);
			level.gunner_rpg thread maintain_rpg_facing("left");
			wait(4);
			level.gunner_rpg thread rpg_fire_bursts();
			//level.gunner_rpg cmdshootatentity( level.helicopter.spotlight_target, false, -1, 10 );
		}
	}
}

rpg_fire_bursts()
{
	self endon("death");
	level endon("helicopter crashing");

	level.helicopter endon("start_shooting_left");
	level.helicopter endon("start_shooting_right");

	while(isalive(self))
	{
		self cmdshootatentityxtimes( level.helicopter.spotlight_target, false, 1, 100 );
		wait(1.5);
		self cmdshootatentityxtimes( level.helicopter.spotlight_target, false, 1, 100 );
		//wait(1);
		//self cmdshootatentityxtimes( level.helicopter.spotlight_target, false, 1, 100 );
		wait(3);
		self stopcmd();
		wait(1);
	}
}

manage_boss_gunner()
{
	level.gunner_right endon("death");
	level endon("helicopter crashing");

	level.gunner_right thread maintain_gunner_facing("right");

	while(isalive(level.gunner_right))
	{
		level.helicopter waittill("start_shooting_right");

		level.gunner_side = 0;

		if(isalive(level.gunner_right))
		{
			//wait(.2);
			level.gunner_right stopcmd();
			wait(.5);
			level.gunner_right thread maintain_gunner_facing("right");
			wait(4);
			level.gunner_right cmdshootatentity( level.helicopter.spotlight_target, false, -1, 10 );
		}


		level.helicopter waittill("start_shooting_left");

		level.gunner_side = 1;

		if(isalive(level.gunner_right))
		{
			//wait(.2);
			level.gunner_right stopcmd();
			wait(.5);
			level.gunner_right thread maintain_gunner_facing("left");
			wait(4);
			level.gunner_right cmdshootatentity( level.helicopter.spotlight_target, false, -1, 10 );
		}
	}
}

#using_animtree("fakeShooters");

pilot_death_tracker()
{
	level endon("helicopter crashing");

	level.pilot_hit_box = getent("pilot_detection_box", "targetname");
	pilot_angles = self GetTagAngles("tag_driver") + (0, 180, 0);
	level.pilot_hit_box linkto( self, "tag_driver", ( 5, 0, 20 ), pilot_angles);
	level.pilot_hit_box SetCanDamage(true);

	while(1)
	{
		//level.pilot_hit_box waittill("damage");
		level.pilot_hit_box waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName ); 
		if(attacker == level.player) //a damage filter on the trigger volume for player only damage
		{
			currentweapon = level.player getCurrentWeapon();
			if(currentweapon == "m14_sink")
			{
				level.helicopter.pilot UseAnimTree(#animtree);
				level.helicopter.pilot SetAnim(%pilot_hitreaction);

				//iPrintLnBold( "pilot is dead" );

				//currentweapon = level.player getCurrentWeapon();

				if(isalive(level.gunner_right) && isalive(level.gunner_rpg) /*&& currentweapon != "dad_sink"*/)
				{
					GiveAchievement( "Challenge_SinkHole" );
					//iPrintLnBold( "Achievement given" );
				}
				else
				{
					//iPrintLnBold( "NO ACHIEVEMENT" );
				}

				level thread helicopter_crash();
			}
		}
	}
}


gunner_death_tracker(id)
{
	level endon("helicopter crashing");

	if(id == 1)
	{
		self waittill("death");
		self thread hide_after_death();
	}
	else
	{
		self.health = 1000;

		while(self.health > 900)
		{
			self waittill("damage");
		}
		self thread play_death_sequence();
	}


	level.gunners_killed ++;

	if(level.gunners_killed == 2)
	{
		level thread play_damage_effects();

		level thread helicopter_crash();
	}

	/*
	if(id == 1)
	{
	wait(.5);

	if(isdefined(self))
	{
	self hide();
	}
	}
	else
	{

	//self unlink();
	//position = level.helicopter getTagOrigin( "tag_origin" );//-4
	//position = level.helicopter getTagOrigin( "tag_guy0" ) + ( 17, -4, -18 );//-4
	//self knockback( 100000, position);

	if(level.gunner_on_right == true)
	{
	//level.death_hit_direction = level.helicopter GetTagOrigin("tag_guy0") + (17, -24, -18); // right
	level.death_hit_direction = self.origin + (0, -24, 0);

	}
	else
	{
	//level.death_hit_direction = level.helicopter GetTagOrigin("tag_guy0") + (17, 46, -18); // left
	level.death_hit_direction = self.origin + (0, 46, 0);
	}
	nearestPoint = pointOnSegmentNearestToPoint( self.origin, level.player.origin, level.death_hit_direction );

	//self knockback( 100000, level.player.origin);
	radiusdamage(nearestPoint, 500, 1, 0 );

	wait(.25);
	if(isdefined(self))
	{
	self hide();
	}

	}
	*/
}


hide_after_death()
{
	wait(.25);

	if(isdefined(self))
	{
		self hide();
	}
}


play_death_sequence()
{
	self notify("death_sequence");
	wait(.05);

	self setenablesense( false );

	// stop all commands
	self stopallcmds();

	// play the flip animation: this is a death animation 
	self cmdplayanim( "thug_heli_death_front", false, true );

	// wait
	wait( 0.2 );

	// ragdoll
	self startragdoll( );

	// wait for the anim to finish
	self waittill( "cmd_done" );

	// kill him
	self becomecorpse();
}


play_damage_effects()
{
	//iPrintLnBold( "rpg_explosion effect" );
	level.helicopter PlaySound("sink_hole_helicopter_grenade_explosion");
	playfxontag (level._effect["rpg_explosion"], level.helicopter, "tag_guy0");
	wait(.25);
	//iPrintLnBold( "rpg_explosion effect" );
	playfxontag (level._effect["rpg_explosion"], level.helicopter, "tag_guy0");
	wait(.25);
	//iPrintLnBold( "rpg_explosion effect" );
	playfxontag (level._effect["rpg_explosion"], level.helicopter, "tag_guy0");
	wait(.25);
	//iPrintLnBold( "burning effect" );
	//playfxontag (level._effect["helicopter_crashing"], level.helicopter, "tag_origin");

	playfxontag (level._effect["helicopter_crashing"], level.helicopter, "tag_engine_right");
	playfxontag (level._effect["helicopter_crashing"], level.helicopter, "tag_engine_left");

}

manage_boss_fight_searchlight()
{
	level endon("helicopter crashing");

	level.helicopter notify("turn_on_spotlight");

	level.helicopter waittill("end_of_path");
	wait(.3);
	level.helicopter notify("cancel_spotlight_target");
	wait(.1);

	level.helicopter.spotlight_target moveto( level.player.origin, 2, .20, .35 );
	wait(2);

	while(1)
	{
		if ( level.player attackbuttonpressed() )
		{
			level.helicopter.spotlight_target moveto( level.player.origin, 3, .20, .35 );
			////iPrintLnBold( "Spotlight move" );
			wait(3);
		}
		wait(.25);
	}
}

/*
manage_boss_fight_gunner()
{
while(1)
{
level.helicopter waittill("start_shooting");
////iPrintLnBold( "Begin Gun Pass Path" );
if(isalive(level.gunner))
{
//level thread shoot_at_light_target();
level.gunner cmdshootatentity( level.helicopter.spotlight_target, false, -1, 5 );
//level.gunner CmdShootAtPos( level.helicopter.spotlight_target.origin, false, -1, 5 );

}

level.helicopter waittill("stop_shooting");
////iPrintLnBold( "Begin Gun Pass Return Path" );
if(isalive(level.gunner))
{
wait(.2);
level.gunner stopcmd();
//level.gunner cmdaimatentity( level.helicopter.spotlight_target, false, -1, 1 );
}
}
}
*/



/*
shoot_at_light_target()
{
level.helicopter endon("stop_shooting");

while(1)
{
level.gunner CmdShootAtPos( level.helicopter.spotlight_target.origin, false, -1, 1 );
wait(.1);		
}
}
*/

/*
begin_gun_pass_path()
{
while(isalive(level.gunner))
{
level.helicopter thread begin_helicopter_patrol("sniper_gun_pass_path", 10);
////iPrintLnBold( "Gun pass" );
level.helicopter waittill("end_of_path");

if(isalive(level.gunner))
{
level.helicopter thread begin_helicopter_patrol("sniper_return_pass_path", 30);
////iPrintLnBold( "Return path" );
level.helicopter waittill("end_of_path");
}
}
}

throw_grenades_at_player()
{
place_grenader();

level.gunner thread check_for_death();

while(1)
{
level.helicopter waittill("throw_grenade");
wait(1);
////iPrintLnBold( "Throw grenade" );
level.gunner magicgrenade( level.gunner.origin +(0,50,0), level.player.origin, 4.0 );
}
}


check_for_death()
{
level endon("helicopter crashing");
level.gunner waittill("death");
////iPrintLnBold( "Grenader killed");
//iPrintLnBold( "Grenade explodes in helicopter" );

level thread helicopter_crash();
}
*/


/*
set_pilot_damage_trigger()
{
level endon("helicopter crashing");

trigger = getent( "pilot_damage_trigger", "targetname" );

level thread move_pilot_damage_trigger();

while(1)
{
trigger waittill( "trigger" );
//iPrintLnBold( "Pilot shot" );
level thread helicopter_crash();
}
}


move_pilot_damage_trigger()
{
level endon("helicopter crashing");

trigger = getent( "pilot_damage_trigger", "targetname" );

while(isalive(level.pilot))
{
pilot_position = level.helicopter getTagOrigin( "tag_driver" ) + ( 0, 0, 38 );
trigger.origin = pilot_position;
wait(.1);
}
}


place_grenader()
{
spawner = getent( "grenader_spawner", "targetname");
if ( !IsDefined( spawner) )
{
//iPrintLnBold( "No Spawner!" );
return;
}

level.gunner = spawner stalingradspawn();

if ( spawn_failed(level.gunner) )
{
return;
}

gunner_angles = level.helicopter getTagAngles( "tag_guy0" ) ;
level.gunner linkto( level.helicopter, "tag_guy0", ( 7, -4, -18 ), gunner_angles); // right grenader


level.gunner allowedStances ("crouch");
level.gunner SetPerfectSense( true );

level.gunner lockalertstate( "alert_yellow" );

level.gunner.grenadeAmmo = 500;
}
*/
//playfxontag (level._effect["helicopter_crashing"], level.helicopter, "tag_guy0");
helicopter_crash()
{
	level thread kill_remaining_ai();

	level notify("helicopter crashing");
	level.helicopter notify("turn_off_spotlight");
	level.helicopter notify("cancel_spotlight_target");
	level.end_of_level = true; // forces spotlight function to close - function wasn't respecting the endon notify

	wait(.25);

	if(isdefined(level.helicopter2))
	{
		level.helicopter2 delete();
	}

	if(isdefined(level.helicopter3))
	{
		level.helicopter3 delete();
	}
	//level.helicopter StopLoopSound();
	//level.helicopter PlayLoopSound("sink_hole_helicopter_defect");

	//iPrintLnBold("SOUND Helicopter damage 2");
	level.helicopter playsound("helicopter_avalanche_impact");
	//iPrintLnBold("SOUND Helicopter spin engine 2");
	level.player playloopsound("helicopter_spin_2");
	level.helicopter clearLookAtEnt();

	//level.helicopter thread spin_out_of_control();

	wait(.2);

	level.helicopter thread begin_helicopter_patrol("crash_path", 60);

	if(isalive(level.gunner_right))
	{
		level.gunner_right stopcmd();
	}

	//level.helicopter.primary_spotlight setLightIntensity( 0 );
	//level.spotlighttag unlink();
	//level.spotlighttag.origin = level.spotlighttag.origin + (0,0,-1000);

	//maps\_autosave::autosave_now("sink_hole"); // TEMP TESTING


	level.helicopter waittill("helicopter_explosion");
	//wait(.25);

	//level.helicopter StopLoopSound();

	level notify("change_rpg_facing");

	////iPrintLnBold( "Helicopter Explodes" );

	//playfxontag (level._effect["airplane_explosion"], level.helicopter, "tag_origin");
	level notify("copter_explosion"); // triggers explosion effect
	//level.helicopter PlaySound("sink_hole_helicopter_crash");
	////iPrintLnBold("SOUND: Helicopter explosion 2");
	level.player playsound("helicopter_explosion_1");
	level.player stoploopsound();	

	//Music - End music for more natural transistion to cutscene (fixes bug)
	level notify( "endmusicpackage" );

	//level.crash_death_trigger trigger_on();
	//wait(.5);
	//level thread kill_remaining_ai();
	//physicsExplosionCylinder( level.helicopter.origin, 30, 1, 2 );// 1.2
	physicsExplosionSphere( level.helicopter.origin, 900, 500, 10 );

	earthquake(.75, 3, level.helicopter.origin, 2500);
	level.player playsound("helicopter_avalanche");
	level thread play_sniper_collapse_dust_effect(1);
	level.player PlayRumbleOnEntity( "grenade_rumble" );

	level notify("boulder_fall_start");
	level notify("wing_fall");

	sniper_gate_collision = getentarray("sniper_gate_collision", "targetname");
	for(i=0; i<sniper_gate_collision.size; i++)
	{
		sniper_gate_collision[i] delete();
	}


	//level.sniper_cave_collapsed.origin = level.sniper_cave_collapsed.origin + (0,0,256);
	//level.sniper_cave.origin = level.sniper_cave.origin + (0,0,-256);

	//place_destroyed_helicopter();
	//place_helicopter_fire();

	// NEEDED - swap terrain so that path exists down to valley floor


	//level.helicopter stop_magic_bullet_shield();
	//wait(.5);
	level.helicopter.pilot delete();
	level.helicopter delete();

	objective_state(12, "done");
	wait(1);
	objective_state(13, "done");


	smoke_rising = getent("smoke_rising", "targetname");
	playfxontag (level._effect["thick_smoke"], smoke_rising, "tag_origin");

	level thread find_camille_end_sequence();
}

wait_for_wing_fall()
{
	wing_crash_destination = getent("wing_crash_destination", "targetname");

	wing_fall_hurt_trigger = getent("wing_fall_hurt_trigger", "targetname");
	wing_fall_hurt_trigger trigger_off();

	level waittill("wing_fall");

	wing_lookat_trigger = getent("wing_lookat_trigger", "targetname");
	wing_lookat_trigger waittill("trigger");

	level notify("wing_fall_start");
	level.player playsound("wing_fall");
	earthquake(.25, 1, wing_crash_destination.origin, 4000);
	level.player PlayRumbleOnEntity( "damage_light" );


	//level waittill("wing_hit");

	wait(2.0);

	////iPrintLnBold( "Wing stops" );

	// lands on the ground
	earthquake(.50, 1, wing_crash_destination.origin, 2000);
	level.player PlayRumbleOnEntity( "damage_heavy" );

	physicsExplosionSphere( wing_crash_destination.origin, 300, 1, 10 );
	radiusdamage(wing_crash_destination.origin, 200, 500, 10 );// 200 500 10

	// activate damage trigger
	wing_fall_hurt_trigger trigger_on();

	wait(3);

	// move full metal clip into position
	wing_fall_clip = getent("wing_fall_clip", "targetname");
	wing_fall_clip.origin = wing_fall_clip.origin + (0,0,200); 

	// nullify nodes that are covered by fire
	wing_fall_clip disconnectpaths();

	////iPrintLnBold( "Wing fall end" );
}


spin_out_of_control()
{
	self endon("helicopter_explosion");

	facing_node = getent("crash_lookat_node", "targetname");
	self setLookAtEnt( facing_node );

	destination = getent(facing_node.target, "targetname");

	time = 2;

	while(1)
	{
		facing_node moveto(destination.origin, time, 0, 0);
		wait(time);
		destination = getent(destination.target, "targetname");
		//time = time * .9;
		////iPrintLnBold( "Rotate" );
	}
}


play_sniper_collapse_dust_effect(id)
{
	sniper_collapse_dust_point = getentarray("sniper_collapse_dust", "targetname");

	if(id== 0) // ambient recurring
	{
		for(i=0; i<sniper_collapse_dust_point.size; i++)
		{
			playfxontag (level._effect["collapse_dust"], sniper_collapse_dust_point[i], "tag_origin");
		}
	}

	else if(id== 1) // immediate for crash
	{
		for(i=0; i<sniper_collapse_dust_point.size; i++)
		{
			playfxontag (level._effect["collapse_dust_oneshot"], sniper_collapse_dust_point[i], "tag_origin");
		}
	}

}



kill_remaining_ai()
{
	//level.pilot hide();

	//level endon("no_targets_for_camille");
	//level.camille_diorama hide();

	explosion_location = level.helicopter.origin;

	if(isalive(level.gunner_right))
	{
		level.gunner_right  DoDamage( 500, explosion_location );
	}

	if(isalive(level.gunner_rpg))
	{
		level.gunner_rpg  DoDamage( 500, explosion_location );
	}	


	//wait(1.0);


	// initial thugs  level.camille_infantry[i]
	for( i = 0; i < level.camille_infantry.size; i++ )
	{
		if (isalive(level.camille_infantry[i]))
		{
			level.camille_infantry[i] thread flee_and_die();
		}
	}


	// reinforcements   level.camille_reinforcements[i]
	for( i = 0; i < level.camille_reinforcements.size; i++ )
	{
		if (isalive(level.camille_reinforcements[i]))
		{
			level.camille_reinforcements[i] thread flee_and_die();
		}
	}

	// final wave level.camille_final_wave[i]
	for( i = 0; i < level.camille_final_wave.size; i++ )
	{
		if (isalive(level.camille_final_wave[i]))
		{
			level.camille_final_wave[i] thread flee_and_die();
		}
	}
}


flee_and_die()
{
	self endon("death");

	self.accuracy = .25;

	//self thread make_sure_thug_dies();

	destination = GetNode("flee_destination", "targetname");

	self SetScriptSpeed("Sprint");
	self setgoalnode(destination);
	self waittill("goal");
	//self DoDamage( 500, destination.origin );
	self delete();
}

make_sure_thug_dies()
{
	destination = GetNode("flee_destination", "targetname");

	initial_distance = Distance( self.origin, destination.origin );
	wait(3);

	if(isdefined(self) && isalive(self))
	{
		current_distance = Distance( self.origin, destination.origin );
		if((initial_distance * .9) > current_distance)
		{
			self DoDamage( 500, destination.origin );
		}
	}
}


place_destroyed_helicopter()
{
	level.destroyed_helicopter = spawn( "script_model", (542.7, 935.1, -843.8) ); //397.606, 798.542, -837.626
	level.destroyed_helicopter setModel( "v_blackhawk_static_damage" );
	level.destroyed_helicopter.angles = (0.303317, 85.1345, 12.2469); // 351.653, 225.062, -22.8805
}

place_helicopter_fire()
{
	fires = getentarray("crash_fire", "targetname");

	for(i=0; i< fires.size; i++)
	{
		playfxontag (level._effect["smoke_fire"], fires[i], "tag_origin");
		fires[i] playloopsound ("sink_hole_fireloop_1");
	}
}


///////// EVENT: END SEQUENCE /////////

find_camille_end_sequence()
{
	remove_fall_damage_triggers();

	//if(isalive(level.camille_diorama))
	//	{
	//level.camille_diorama stop_magic_bullet_shield();
	//wait(.2);
	//level.camille_diorama delete();
	//level.camille_diorama hide();
	//}

	//level thread place_camille_ending();

	level thread set_approaching_camille_vo_trigger();
	level thread set_reached_camille_trigger();

	//level thread temp_teleport_player();

	wait(1);
	level.player play_dialogue("BOND_SinkG_031A");

	wait(2);

	objective_add(14, "active", &"SINK_HOLE_OBJECTIVE_HEADER_REGROUP", GetEnt("objective_9_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_REGROUP");
	objective_state(14, "current");

	//wait(4);

	//level.player play_dialogue("CAMI_SinkG_032A", true);

	//PlayCutScene("SH_Camille_Sequence_07", "SH_Camille_Sequence_07_Done");
	//level waittill("SH_Camille_Sequence_07_Done");
}


remove_fall_damage_triggers()
{
	damage_triggers = getentarray("fall_damage_trigger", "targetname");

	if ( !IsDefined( damage_triggers) )
	{
		//iPrintLnBold( "Damage triggers Not Defined!" );
		return;
	}

	for( i = 0; i < damage_triggers.size; i++ )
	{
		damage_triggers[i] delete();
	}
}
/*
place_camille_ending()
{
spawner = getent( "camille_ending", "targetname");
if ( !IsDefined( spawner) )
{
//iPrintLnBold( "Spawner Not Defined!" );
return;
}

level.camille_ending = spawner stalingradspawn("camille");

if ( spawn_failed(level.camille_ending) )
{
return;
}

level.camille_ending setengagerule( "never" );
level.camille_ending SetEnableSense( false );
level.camille_ending lockalertstate( "alert_green" );
}
*/

temp_teleport_player()
{
	player_ending_position = getent ( "player_ending_reposition", "targetname" );
	level.player setorigin ( player_ending_position.origin);
	level.player setplayerangles( player_ending_position.angles );
}

set_reached_camille_trigger()
{
	//trigger = getent( "reached_camille_trigger", "targetname" );
	trigger = getent( "crash_site_trigger", "targetname" );	
	trigger waittill( "trigger" );

	objective_state(14, "done");

	//level.camille_diorama PlayCutScene("SH_Camille_Sequence_07", "SH_Camille_Sequence_07_Done");

	wait(1);
	////iPrintLnBold( "Begin Playing Final Cutscene" );
	//wait(2);

	//level.camille maps\sink_hole_1::start_cutscene("SH_Final_Sequence", "SH_Final_Sequence_Done");
	//playcutscene("SH_Final_Sequence","SH_Final_Sequence_Done");
	//level waittill("SH_Final_Sequence_Done");

	//black_screen_time = 1.0;

	//level.player.targetname = "bond";

	/*
	//black screen
	hudBlack = newHudElem();
	hudBlack.x = 0;
	hudBlack.y = 0;
	hudBlack.horzAlign = "fullscreen";
	hudBlack.vertAlign = "fullscreen";
	hudBlack.sort = 0;
	hudBlack.alpha = 1;
	hudBlack setShader("black", 640, 480);
	*/
	//wait black_screen_time;

	level.hudBlack fadeOverTime(3);		// fade out
	level.hudBlack.alpha = 1;

	wait(3);
	level.player FreezeControls(true);

	////iPrintLnBold( "Mission Accomplished" );
	//wait(2);

	//while(level.camille_vo_done == false)
	//{
	//	wait(.25);
	//}

	//level.player play_dialogue("BOND_SinkG_601A", false); // So we're both using
	//level.player play_dialogue("CAMI_SinkG_013B", false);
	//level.player play_dialogue("CAMI_SinkG_013B", false);

	//changelevel( "shantytown" );
	maps\_endmission::nextmission();

	//Music - Stop Music - Added by crussom
	level notify( "endmusicpackage" );
}


set_approaching_camille_vo_trigger()
{
	trigger = getent( "approaching_camille_vo_trigger", "targetname" );	
	trigger waittill( "trigger" );

	//level.player play_dialogue("BOND_SinkG_034A"); // Why are you after Madrono (you're good with a gun)
	//level.player play_dialogue("CAMI_SinkG_529A", true); // My father...

	if(isalive(level.camille_diorama))
	{
		holster_weapons();
		PlayCutScene("SH_Camille_Sequence_07", "SH_Camille_Sequence_07_Done");

		wait(1.5);
		level.player play_dialogue("CAMI_SinkG_032A", true);

		level.camille_vo_done = true;
	}
}
