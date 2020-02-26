#include maps\_utility;
#include common_scripts\utility;
#include animscripts\shared;
#include maps\_anim;
#include maps\sink_hole_helicopter;
#using_animtree("vehicles");




set_stage_2_triggers()
{
	
	level thread set_bowl_helicopter_trigger();
	
	level thread set_bowl_trigger();
	level thread set_engine_damage_trigger();
	level thread set_tnt_crate_helpers();
	level thread set_helicopter_crouch_trigger();
	
	level thread check_for_turret_damage();

	level thread set_snipers_perch_trigger();
	level thread set_sniper_vo_trigger();
	level thread set_past_trench_trigger(); 

	level.helicopter_radio = getent("helicopter_radio", "targetname");

	level.side_wall_damage_trigger = getent("side_wall_damage_trigger", "targetname");
	level.side_wall_damage_trigger trigger_off();

	level.mine_tunnel_damage_trigger = getent("mine_tunnel_damage_trigger", "targetname");
	level.mine_tunnel_damage_trigger trigger_off();

	

	

	level.landed_helicopter = getent("helicopter_grounded", "targetname");
	level.landed_helicopter hide();
	
	
	
	
	
	

	
	
	
	

	

	

}

weapon_test()
{
	while(1)
	{
		currentweapon = level.player getCurrentWeapon();

		

		wait(3);
	}
}


pilot_test()
{

	trigger = getent("pilot_damage_trigger", "script_noteworthy");
	while(1)
	{
		trigger waittill("trigger");
		
	}
	

}


prep_destructible_terrain()
{
	
	
	
	

	
	

	
	
	



	
	

	
	

	
	

	
	
	

	
	
}






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

	for( i = 0; i < spawner.size-1; i++ )
	{
		
		aiarray = getaiarray("axis");
		if(aiarray.size > 5)
		{
			return;
		}
	
		level.rag_doll_men[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.rag_doll_men[i]) )
		{
			return;
		}

		level.rag_doll_men[i] lockalertstate("alert_red");
		level.rag_doll_men[i] SetPerfectSense( true );

		level.rag_doll_men[i] thread force_rush_ready();

		level.rag_doll_men[i] thread bowl_death_tracker();

		level.rag_doll_men[i].accuracy = .4;

		
		
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

	

	
	
	level.helicopter3 thread place_door_gunner_right(3);
	level.helicopter3 thread place_window_gunner_right(3);

	
	level.helicopter3 thread begin_helicopter_patrol("block_cave_path", 20); 
	level.helicopter3 thread target_spotlight_at_path("cave_spotlight_path", 3);

	place_bowl_tunnel_rusher();
	level.bowl_tunnel_rusher waittill_any("damage", "death");



	

	
	level.helicopter3 setLookAtEnt( level.player );
	level.helicopter3 SetLookAtEntYawOffset( 90 );
	
	wait(1.5);
	
	


	wait(.5);
	
	level.helicopter3 clearLookAtEnt();

	
	playfxontag (level._effect["copter_dust"], level.helicopter3, "tag_origin");
	playfxontag (level._effect["helicopter_smoking"], level.helicopter3, "tag_origin");
	
	
	level.helicopter3 playsound("helicopter_avalanche_impact");

	
	
	earthquake(.75, 3, level.helicopter3.origin, 2000);
	
	level.helicopter3 playsound("helicopter_spin");
	level.player playsound("helicopter_avalanche");
	level.player PlayRumbleOnEntity( "grenade_rumble" );

	level.helicopter3 notify("turn_off_spotlight");
	level.helicopter3 notify("cancel_spotlight_target");

	
	

	
	level.helicopter3 thread begin_helicopter_patrol("bowl_crash_path", 45);

	wait(.75);
	rock_collapse = getent("rock_collapse_origin", "targetname");
	physicsExplosionSphere( rock_collapse.origin, 100, 1, 5 );
	
	
	level notify( "playmusicpackage_climax" );

	level.helicopter3 spin_helicopter();

	level.helicopter3 waittill("end_of_path");

	level.helicopter3 notify("crash");
	
	deleteallcorpses(1);
	iprintlnbold("deleteallcorpses!!!");
	wait(0.2);

	crash_land_point = getent("crash_land_origin", "targetname");
	playfxontag (level._effect["copter_dust"], crash_land_point, "tag_origin");

	level notify("copter_smoke"); 

	physicsExplosionSphere( crash_land_point.origin, 2000, 1, 10 );
	earthquake(.75, 3, crash_land_point.origin, 2000);
	level.player playsound("helicopter_avalanche");
	level.player PlayRumbleOnEntity( "grenade_rumble" );


	
	

	
	
	
	

	
	
	crash_land_point playsound("helicopter_explosion_1");
	
	level.helicopter3.pilot delete();
	

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
	
	wait(6);
	
	
		
}


spin_helicopter()
{
	
	self SetLookAtEntYawOffset( -30 );
	self setLookAtEnt( level.player );
}


play_rotor_sparks()
{
	for(i=0; i<15; i++)
	{
		playfxontag (level._effect["sparks"], self.rear_rotor, "tag_origin");
		wait(.2);
	}
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
			self.window_gunner_right linkto( level.helicopter2, "tag_guy0", ( 17, -4, -18 ), gunner_angles_right); 
			wait(.01);
		}
	}
	else if(id == 3)
	{
		facing_adjustment = 90;

		gunner_angles_right = level.helicopter3 getTagAngles( "tag_guy0" ) + (0, facing_adjustment, 0);

		while(isalive(self))
		{
			self.window_gunner_right linkto( level.helicopter3, "tag_guy0", ( 17, -4, -18 ), gunner_angles_right); 
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
	
	self.door_gunner_right SetEnableSense( false);
	self.door_gunner_right lockalertstate( "alert_red" );
	self.door_gunner_right.dropweapon = false;
	

	self.door_gunner_right endon("death");

	wait(1);

	if(id == 2)
	{
		facing_adjustment = 90;

		gunner_angles_right = level.helicopter2 getTagAngles( "tag_playerride" ) + (0, facing_adjustment, 0);

		while(isalive(self))
		{
			self.door_gunner_right linkto( level.helicopter2, "tag_playerride", ( -5, 0, 8 ), gunner_angles_right); 
			wait(.01);
		}
	}
	else if(id == 3)
	{
		facing_adjustment = -90;

		gunner_angles_right = level.helicopter3 getTagAngles( "tag_playerride" ) + (0, facing_adjustment, 0);

		while(isalive(self))
		{
			self.door_gunner_right linkto( level.helicopter3, "tag_playerride", ( -5, 0, 8 ), gunner_angles_right); 
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



search_helicopter()
{
	level.helicopter2 thread begin_helicopter_patrol("bowl_helicopter_path", 20); 

	level.helicopter2 waittill("crash_search_path");
	level.helicopter2 thread target_spotlight_at_path("crash_search_path", 3);

	level.helicopter2 waittill("end_of_path");

	
	
	

	
	
	

	

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

	
}






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

	for( i = 0; i < spawner.size-1; i++ )
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
	self thread check_for_awareness();
	self setscriptspeed( "walk" );

	wait(4);
	
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
	wait(5);
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
	

	engine_exploded = false;

	
	
	
	

	
	
			engine_exploded = true;

			level notify ("engine_toss_start");

			engine_smoke_origin delete();

			
			engine_explosion = getent("engine_explosion_origin", "targetname");
			earthquake(.50, 1, engine_explosion.origin, 1500);
			
			
			
			
			
			
			
			
			

			
			engine_start_player_clip = getent("engine_start_player_clip", "targetname");
			engine_start_player_clip delete();

			
			wait(1.25);
			
			
			

			
			
			wait(.25);
			
			
			
			
			
			
			
		

			
			iprintlnbold("engine explosion");
			for(i=0; i< engine_fire_hurt_trigger.size; i = i + 2)
			{
				engine_fire_hurt_trigger[i] trigger_on();
			}

			
			engine_explosion_clip = getentarray("engine_explosion_clip", "targetname");
			for(i=0; i< engine_explosion_clip.size; i++)
			{
				engine_explosion_clip[i].origin = engine_explosion_clip[i].origin + (0,0,200);

				
				engine_explosion_clip[i] disconnectpaths();
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
	
	objective_add(8, "active", &"SINK_HOLE_OBJECTIVE_HEADER_MOUNT_TURRET", GetEnt("objective_7_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_MOUNT_TURRET");
	objective_state(8, "current");
	

	level.player play_dialogue("CAMI_SinkG_512A", true);

	

	place_bowl_infantry();

	maps\sink_hole_1::remove_surviving_hill_ai();

	maps\_autosave::autosave_now("sink_hole"); 

	level thread wait_for_reinforcements();

	level.helicopter_radio play_dialogue("MDS1_SinkC_604A"); 

	wait(1.5);
	place_rpg_wave_1();
}

place_bowl_infantry()
{
  spawner = getentarray( "first_wave_mine_tunnel", "targetname");
  if ( !IsDefined( spawner) )
  {
    iPrintLnBold( "Spawner Not Defined!" );
    return;
  }

  for( i = 0; i < spawner.size-1; i++ )
  {
	wait(0.05);
	
	aiarray = getaiarray("axis");
	if(aiarray.size > 6)
	{
		return;
	}
  
    level.bowl_infantry[i] = spawner[i] stalingradspawn();

    if ( spawn_failed(level.bowl_infantry[i]) )
    {
      return;
    }

	level.bowl_infantry[i] lockalertstate("alert_red");
	level.bowl_infantry[i] SetPerfectSense( true );
	level.bowl_infantry[i].accuracy = .8;

	level.bowl_infantry[i] thread bowl_death_tracker();

	level.bowl_infantry[i] thread force_rush_ready();

	

	
  }
}




check_for_turret_damage()
{
	turret_weapon = getent("turret_weapon", "targetname");

	level.player.turret_eject_count = 0;

	while ( level.player.turret_eject_count < 4 )
	{
		self waittill("turret_player_ejected", damagetype);

		level.player.turret_eject_count ++;

		if (damagetype == "MOD_CONCUSSION_GRENADE" || damagetype == "MOD_GRENADE" || damagetype == "MOD_PROJECTILE")
		{
			level.player knockback( 2000, turret_weapon.origin);
		}
	}

	turret_weapon.origin = turret_weapon.origin + (0, 0, -500);
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
	if(level.grenade_thrown == false )
	{
		level.grenade_thrown = true;
		self cmdthrowgrenadeatentity(level.player, false, 1);
		rand = randomfloatrange(10.0,20.0);
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
	
	self setscriptspeed( "default" );
}



bowl_death_tracker()
{
	level.total_bowl_infantry ++;

	self waittill("death");

	
	level.total_bowl_infantry --;

	
	


}


wait_for_reinforcements()
{
	level endon("reached_bowl_exit");

	
	
	while(level.total_bowl_infantry > 3 )
	{
		wait(1);
	}

	level notify("force_rush");
	maps\_autosave::autosave_by_name("sink_hole");
	second_wave_side_wall();

	objective_state(8, "done");
	objective_add(9, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DEFEND_FLANK", GetEnt("objective_7_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DEFEND_FLANK");
	objective_state(9, "current");

	
	
	while(level.total_bowl_infantry > 4 )
	{
		wait(1);
	}

	
	maps\_autosave::autosave_by_name("sink_hole");
	third_wave_end_wall();

	objective_state(9, "done");
	objective_add(10, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DEFEND_ALL", GetEnt("objective_7_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DEFEND_ALL");
	objective_state(10, "current");

	
	while(level.total_bowl_infantry > 6 )
	{
		wait(1);
	}

	
	

	
	
	
	
	place_trickle(2); 
	place_trickle(1);
	place_trickle(3);

	level thread play_trickle_vo();

	
	while(level.total_bowl_infantry > 6 )
	{
		wait(1);
	}
	level notify("force_rush");

	block = getent("player_turret_block", "targetname");
	block delete();

	level.bowl_cleared = true;

	
	while(level.total_bowl_infantry > 0 )
	{
		wait(1);
	}

	
	objective_state(10, "done");
	objective_add(11, "active", &"SINK_HOLE_OBJECTIVE_HEADER_FIND_CAMILLE", GetEnt("objective_9_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_FIND_CAMILLE");
	objective_state(11, "current");
	
	wait(3);

	maps\_autosave::autosave_by_name("sink_hole");
}





second_wave_side_wall()
{
	
	place_rag_doll_men(1);
	wait(1.5);
	level.helicopter_radio play_dialogue("MDS1_SinkC_620A"); 
	wait(1.5);
	place_second_wave(1);
	wait(1.5);
	level.helicopter_radio play_dialogue("MDS1_SinkC_609A"); 
	
}

second_wave_end_wall()
{
	
	place_rag_doll_men(2);
	wait(1.5);
	
	wait(2.5);
	place_second_wave(2);
}

second_wave_mine_tunnel()
{
	

	place_rag_doll_men(3);
	wait(1.5);
	
	wait(2.5);
	place_second_wave(3);
}


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

	for( i = 0; i < spawner.size-1; i++ )
	{
		
		wait(0.05);
		aiarray = getaiarray("axis");
		if(aiarray.size > 6)
			return;
	
		level.bowl_second_wave[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.bowl_second_wave[i]) )
		{
			return;
		}

		level.bowl_second_wave[i] lockalertstate("alert_red");
		level.bowl_second_wave[i] SetPerfectSense( true );
		level.bowl_second_wave[i].accuracy = .65;

		level.bowl_second_wave[i] thread bowl_death_tracker();

		level.bowl_second_wave[i] thread force_rush_ready();

		
	}
}


third_wave_side_wall()
{
	

	place_rag_doll_men(1);
	wait(1.5);
	
	wait(2.5);
	place_third_wave(1);
}

third_wave_end_wall()
{
	
	place_rag_doll_men(2);
	level thread smoke_screen_timing();
	wait(10);
	level.helicopter_radio play_dialogue("MDS1_SinkC_610A"); 
	place_third_wave(2);
	wait(4);
	level.helicopter_radio play_dialogue("MDS1_SinkC_605A"); 
	wait(8);
	place_rpg_wave_3();
}

smoke_screen_timing()
{
	wait(12);
	level.lower_smoke_active = true;
	
	level thread place_smoke_rushers(1);

	wait(4);
	level.middle_smoke_active = true;
	
	level thread place_smoke_rushers(2);

	wait(5);
	level.upper_smoke_active = true;
	
	level thread place_smoke_rushers(3);

	wait(24);
	level.upper_smoke_active = false;
	

	wait(3);
	level.middle_smoke_active = false;
	

	wait(8);
	level.lower_smoke_active = false;
	
}



third_wave_mine_tunnel()
{
	

	place_rag_doll_men(3);
	wait(1.5);
	
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

	for( i = 0; i < spawner.size-1; i++)
	{
		
		aiarray = getaiarray("axis");
		if(aiarray.size > 6)
		{
			return;
		}
		
		level.bowl_third_wave[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.bowl_third_wave[i]) )
		{
			return;
		}

		level.bowl_third_wave[i] lockalertstate("alert_red");
		level.bowl_third_wave[i] SetPerfectSense( true );
		level.bowl_third_wave[i].accuracy = .4;
		level.bowl_third_wave[i] thread bowl_death_tracker();

		level.bowl_third_wave[i] thread force_rush_ready();

		
	}
}

play_trickle_vo()
{
	level.helicopter_radio play_dialogue("MDS1_SinkC_618A"); 
	wait(2);
	level.helicopter_radio play_dialogue("MDS1_SinkC_608A"); 
	wait(1);
	level.helicopter_radio play_dialogue("MDS1_SinkC_611A"); 
}


trickle_side_wall()
{
	
	place_trickle(1);
}

trickle_end_wall()
{
		
	place_trickle(2);
}

trickle_mine_tunnel()
{
		
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
		
		return;
	}

	for( i = 0; i < spawner.size-1; i++ )
	{
		if(isdefined(level.smoke_rusher[i]))
		{
			if(!isalive(level.smoke_rusher[i]))
			{
				level.smoke_rusher[i] delete();
				
				wait(1);
			}
		}

		level.smoke_rusher[i] = spawner[i] stalingradspawn();

		if ( spawn_failed(level.smoke_rusher[i]) )
		{
			
			return;
		}

		level.smoke_rusher[i] lockalertstate("alert_red");
		level.smoke_rusher[i] SetPerfectSense( true );
		level.smoke_rusher[i].accuracy = .3;

		level.smoke_rusher[i] thread bowl_death_tracker();
	}
}

set_past_trench_trigger()
{
	trigger = getent( "past_trench_trigger", "targetname" );
	trigger waittill( "trigger" );

	if(level.bowl_cleared == true) 
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
		

		
	}

	else  
	{
		spawner = getentarray( "early_exit_infantry", "targetname");
		if ( !IsDefined( spawner) )
		{
			iPrintLnBold( "Spawner Not Defined!" );
			return;
		}

		for( i = 0; i < spawner.size-1; i++ )
		{
			level.early_exit_infantry[i] = spawner[i] stalingradspawn();

			if ( spawn_failed(level.early_exit_infantry[i]) )
			{
				return;
			}

			level.early_exit_infantry[i] lockalertstate( "alert_red" );
			level.early_exit_infantry[i] SetPerfectSense( true );
			level.early_exit_infantry[i] thread bowl_death_tracker();
			
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

	for( i = 0; i < spawner.size-1; i++ )
	{
		if(isdefined(level.bowl_trickle[i]))
		{
			if(!isalive(level.bowl_trickle[i]))
			{
				level.bowl_trickle[i] delete();
				
				wait(1);
			}
		}

		level.bowl_trickle[i] = spawner[i] stalingradspawn();
		
		if ( spawn_failed(level.bowl_trickle[i]) )
		{
			
			return;
		}

		
		level.bowl_trickle[i] lockalertstate("alert_red");
		level.bowl_trickle[i] SetPerfectSense( true );
		level.bowl_trickle[i].accuracy = .3;

		level.bowl_trickle[i] thread bowl_death_tracker();
		level.bowl_trickle[i] thread force_rush_ready();

		
	}
}

place_rpg()
{
	


	
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

manage_rpg(blocked_by_smoke)
{
	self lockalertstate("alert_yellow");
	
	self SetEnableSense( false );

	self thread bowl_death_tracker();

	self.dropweapon = false;


	self waittill("goal");
		
	wait(.5);

	accuracy = -5000;

	min_error = 70;
	max_error = 120;

	while(isalive(self))
	{
		
		
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

				level.helicopter_radio play_dialogue_nowait("MDS1_SinkC_623A"); 
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
		
		wait(randomfloatrange( 10, 20 ));
	}
}








set_snipers_perch_trigger()
{
	trigger = getent( "snipers_perch_trigger", "targetname" );
	trigger waittill( "trigger" );

	level thread wait_for_wing_fall();

	level notify("reached_bowl_exit");
	wait(.2);

	remove_surviving_bowl_ai();
	

	
	
	
	level notify( "playmusicpackage_sniper" );

	maps\_autosave::autosave_now("sink_hole"); 

	place_camille_diorama();
	level.camille_diorama thread magic_bullet_shield();
	place_sniper_infantry();
	place_sniper();
	level thread set_alert_status_trigger();
	level thread set_quick_kill_distance_trigger();

	
	

	level.player play_dialogue("CAMI_SinkG_048A", true);
	place_camille_infantry();
	wait(2);
	level.player play_dialogue("CAMI_SinkG_049A", true);
	wait(2);
	
	
	level notify("cleared_bowl_battle");
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

	
	
	

	if(isalive(level.sniper_infantry) && level.sniper_infantry_alerted == false)
	{
		level.sniper_infantry play_dialogue("SHS1_SinkG_021A");	 

		if(isalive(level.sniper) && level.sniper_alerted == false)
		{
			level.sniper play_dialogue("SHS2_SinkG_524A");	

			if(isalive(level.sniper_infantry) && level.sniper_infantry_alerted == false)
			{
				level.sniper_infantry play_dialogue("SHS1_SinkG_023A");	 
				wait(1);

				if(isalive(level.sniper) && level.sniper_alerted == false)
				{
					level.sniper play_dialogue("SHS2_SinkG_024A");	
				}
			}
		}
	}
}

place_camille_diorama()
{
	spawner = getent( "camille_diorama", "targetname");
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
	
	level.camille_diorama SetTetherRadius( 80 );
	level.camille_diorama setpainenable( false );
	level.camille_diorama allowedStances ("crouch");

	level.camille_diorama thread play_camille_combat_anims();
}

play_camille_combat_anims()
{
	level endon("no_targets_for_camille");
	self thread Camille_weapon_fire();

	self cmdplayanim("Camille_Cover_Idle", false);

	
	while (true)
	{
		self cmdplayanim("Camille_Cover_PopOut_Peek", false);
		self cmdplayanim("Camille_Cover_Idle", false);

		wait 3;
		self StopCmd();	
		self waittill("cmd_done");

		self cmdplayanim("Camille_Cover_BlindFire_Out", false);
		self cmdplayanim("Camille_Cover_Idle", false);
		
		wait 3;
		self StopCmd();	
		self waittill("cmd_done");
	}

	
	
	
	
	

	
	
	
	

	
	
	
	
	
}


Camille_weapon_fire()
{
	level endon("no_targets_for_camille");

	while(1)
	{
		
		self waittillmatch("anim_notetrack", "start_fire");

		
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


	if(level.diorama_infantry_killed == 2)
	{
		level.player play_dialogue("CAMI_SinkG_516B", true);
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

	
	level.sniper_infantry SetEnableSense( false );
	
	
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




sniper_alert_check()
{
	level endon("sniper_group_injured");

	self waittill_any( "damage", "death" );

	if(isalive(level.sniper_infantry)) 
	{
		level.sniper_infantry lockalertstate("alert_red");
		level.sniper_infantry SetEnableSense( true );
		level.sniper_infantry SetPerfectSense(true);
		
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
		
		level.sniper_alerted = true;
	}

	level notify("sniper_group_injured");
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
		
		aiarray = getaiarray("axis");
		if(aiarray.size > 6)
		{
			return;
		}
	
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




begin_boss_fight()
{
	
	level thread countdown_to_boss_fight(30);
	

	level waittill("begin_boss_fight");

	
	maps\_autosave::autosave_by_name("sink_hole");

	level notify("change_rpg_facing");
	wait(1);

	if(isdefined(level.gunner))
	{
		if(isalive(level.gunner))
		{
			level.gunner DoDamage( 500, ( 0, 0, 0 ) );
			
			level.gunner hide();
		}
	}

	if(isdefined(level.helicopter.copilot))
	{
		level.helicopter.copilot delete();
	}

	
	
		level.helicopter thread pilot_death_tracker();
	
	
	
	
	

	

	level.facing_adjustment = -90; 
	level.gunner_facing_adjustment = 90;

	place_boss_gunner_right();
	
	
	place_boss_rpg(); 

	wait(1);

	

	level.helicopter thread begin_helicopter_patrol("sniper_descent_path", 30);

	level thread manage_boss_fight_searchlight();

	level.helicopter waittill("helicopter_rotation");
	wait(3);
	level.helicopter setLookAtEnt( level.player );

	level.helicopter waittill("end_of_path");

	
	level.helicopter SetLookAtEntYawOffset( 45 );
	level.helicopter thread manage_helicopter_facing();
	
	
	level notify( "playmusicpackage_helicopter" );

	level.helicopter thread begin_helicopter_patrol("sniper_dual_gun_pass_path", 10);

	level.player play_dialogue("CAMI_SinkG_525A", true); 

	objective_add(13, "active", &"SINK_HOLE_OBJECTIVE_HEADER_DESTROY_HELICOPTER", GetEnt("objective_9_org", "targetname").origin, &"SINK_HOLE_OBJECTIVE_TEXT_DESTROY_HELICOPTER");
	objective_state(13, "current");
	
	
	
	
		
	
	
	
	
	
	
	wait(2);
	level.helicopter notify("start_shooting_right");
	wait(5);
	level.facing_adjustment = 0;  
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

	wait(2); 

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
		
		return;
	}

	level.gunner_right = spawner stalingradspawn();

	while ( spawn_failed(level.gunner_right) )
	{
		for(i=0; i<6; i++)
		{
			if ( spawn_failed(level.gunner_right) )
			{
				
				wait(.25);
				level.gunner_right = spawner stalingradspawn();
			}
		}

		if ( spawn_failed(level.gunner_right) )
		{
			
			level.gunners_killed ++;
			return;
		}
	}

	level.gunner_right allowedStances ("crouch");
	
	level.gunner_right SetEnableSense( false );
	level.gunner_right lockalertstate( "alert_red" );
	level.gunner_right.dropweapon = false;
	

	level.gunner_right thread gunner_death_tracker(1);

	level thread manage_boss_gunner();
}




place_boss_rpg()
{
	spawner = getent( "rpg_spawner", "targetname");
	if ( !IsDefined( spawner) )
	{
		
		return;
	}

	level.gunner_rpg = spawner stalingradspawn();

	if ( spawn_failed(level.gunner_rpg) )
	{
		return;
	}

	level.gunner_rpg allowedStances ("crouch");
	
	level.gunner_rpg SetEnableSense( false );
	level.gunner_rpg lockalertstate( "alert_red" );
	level.gunner_rpg.dropweapon = false;
	

	
	

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
			
			level.gunner_rpg stopcmd();
			wait(.5);
			level.gunner_rpg thread maintain_rpg_facing("right");
			wait(4);
			level.gunner_rpg thread rpg_fire_bursts();
			
		}


		level.helicopter waittill("start_shooting_left");
		if(isalive(level.gunner_rpg))
		{
			
			level.gunner_rpg stopcmd();
			wait(.5);
			level.gunner_rpg thread maintain_rpg_facing("left");
			wait(4);
			level.gunner_rpg thread rpg_fire_bursts();
			
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
		wait(1);
		self cmdshootatentityxtimes( level.helicopter.spotlight_target, false, 1, 100 );
		wait(1);
		self cmdshootatentityxtimes( level.helicopter.spotlight_target, false, 1, 100 );
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
		
		level.pilot_hit_box waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName ); 
		if(attacker == level.player) 
		{
			currentweapon = level.player getCurrentWeapon();
			if(currentweapon == "m14_sink")
			{
				level.helicopter.pilot UseAnimTree(#animtree);
				level.helicopter.pilot SetAnim(%pilot_hitreaction);

				

				

				if(isalive(level.gunner_right) && isalive(level.gunner_rpg) )
				{
					GiveAchievement( "Challenge_SinkHole" );
					
				}
				else
				{
					
				}

				level thread helicopter_crash();
			}
		}
	}
}


gunner_death_tracker(id)
{
	level endon("helicopter crashing");
	
	
	
		self waittill("death");
	
	
	
	
	

	level.gunners_killed ++;

	
	if(level.gunners_killed == 2)
	{
		
		

		level thread play_damage_effects();
		
		level thread helicopter_crash();
	}

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
		
		
		
		

		if(level.gunner_on_right == true)
		{
			
			level.death_hit_direction = self.origin + (0, -24, 0);

		}
		else
		{
			
			level.death_hit_direction = self.origin + (0, 46, 0);
		}
		nearestPoint = pointOnSegmentNearestToPoint( self.origin, level.player.origin, level.death_hit_direction );

		
		radiusdamage(nearestPoint, 500, 1, 0 );

		wait(.25);
		if(isdefined(self))
		{
			self hide();
		}
	}
}

play_damage_effects()
{
	
	level.helicopter PlaySound("sink_hole_helicopter_grenade_explosion");
	playfxontag (level._effect["rpg_explosion"], level.helicopter, "tag_guy0");
	wait(.25);
	
	playfxontag (level._effect["rpg_explosion"], level.helicopter, "tag_guy0");
	wait(.25);
	
	playfxontag (level._effect["rpg_explosion"], level.helicopter, "tag_guy0");
	wait(.25);
	
	

	playfxontag (level._effect["helicopter_crashing"], level.helicopter, "tag_engine_right");
	playfxontag (level._effect["helicopter_crashing"], level.helicopter, "tag_engine_left");

}

manage_boss_fight_searchlight()
{
	level endon("helicopter crashing");

	level.helicopter notify("turn_on_spotlight");
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
					
			wait(3);
		}
		wait(.25);
	}
}











		
helicopter_crash()
{
	level notify("helicopter crashing");
	level.helicopter notify("turn_off_spotlight");
	level.helicopter notify("cancel_spotlight_target");
	level.end_of_level = true; 

	wait(.25);

	if(isdefined(level.helicopter2))
	{
		level.helicopter2 delete();
	}

	if(isdefined(level.helicopter3))
	{
		level.helicopter3 delete();
	}
	
	
	
	
	level.helicopter playsound("helicopter_avalanche_impact");
	
	level.player playloopsound("helicopter_spin_2");
	
	
	

	level.helicopter clearLookAtEnt();

	

	wait(.2);

	level.helicopter thread begin_helicopter_patrol("crash_path", 60);

	if(isalive(level.gunner_right))
	{
		level.gunner_right stopcmd();
	}

	
	
	

			


	level.helicopter waittill("helicopter_explosion");
	

	

	level notify("change_rpg_facing");

	

	
	level notify("copter_explosion"); 
	
	
	level.player playsound("helicopter_explosion_1");
	level.player stoploopsound();
	
	
	
	level notify( "playmusicpackage_ending" );

	
	
	level thread kill_remaining_ai();
	
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


	
	

	
	

	


	
	
	level.helicopter.pilot delete();
	level.helicopter delete();

	objective_state(12, "done");
	objective_state(13, "done");

	wait(1);
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


	

	wait(2.0);

	

	
	earthquake(.50, 1, wing_crash_destination.origin, 2000);
	level.player PlayRumbleOnEntity( "damage_heavy" );

	physicsExplosionSphere( wing_crash_destination.origin, 300, 1, 10 );
	radiusdamage(wing_crash_destination.origin, 200, 500, 10 );

	
	wing_fall_hurt_trigger trigger_on();

	wait(3);

	
	wing_fall_clip = getent("wing_fall_clip", "targetname");
	wing_fall_clip.origin = wing_fall_clip.origin + (0,0,200); 

	
	wing_fall_clip disconnectpaths();

	
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
		
		
	}
}


play_sniper_collapse_dust_effect(id)
{
	sniper_collapse_dust_point = getentarray("sniper_collapse_dust", "targetname");

	if(id== 0) 
	{
		for(i=0; i<sniper_collapse_dust_point.size; i++)
		{
			playfxontag (level._effect["collapse_dust"], sniper_collapse_dust_point[i], "tag_origin");
		}
	}

	else if(id== 1) 
	{
		for(i=0; i<sniper_collapse_dust_point.size; i++)
		{
			playfxontag (level._effect["collapse_dust_oneshot"], sniper_collapse_dust_point[i], "tag_origin");
		}
	}

}



kill_remaining_ai()
{
	

	level endon("no_targets_for_camille");
	level.camille_diorama hide();

	explosion_location = level.helicopter.origin;
	
	for( i = 0; i < level.camille_infantry.size; i++ )
	{
		if (isalive(level.camille_infantry[i]))
		{
			level.camille_infantry[i] thread flee_and_die();
		}
	}


	
	for( i = 0; i < level.camille_reinforcements.size; i++ )
	{
		if (isalive(level.camille_reinforcements[i]))
		{
			level.camille_reinforcements[i] thread flee_and_die();
		}
	}

	
	for( i = 0; i < level.camille_final_wave.size; i++ )
	{
		if (isalive(level.camille_final_wave[i]))
		{
			level.camille_final_wave[i] thread flee_and_die();
		}
	}

	
	
	
	

	
	
	
	

	if(isalive(level.gunner_right))
	{
		level.gunner_right  DoDamage( 500, explosion_location );
	}
	
	
	
	
	if(isalive(level.gunner_rpg))
	{
		level.gunner_rpg  DoDamage( 500, explosion_location );
	}	
}


flee_and_die()
{
	self endon("death");

	destination = GetNode("flee_destination", "targetname");

	self setgoalnode(destination);
	self waittill("goal");
	self DoDamage( 500, destination.origin );
}


place_destroyed_helicopter()
{
	level.destroyed_helicopter = spawn( "script_model", (542.7, 935.1, -843.8) ); 
	level.destroyed_helicopter setModel( "v_blackhawk_static_damage" );
	level.destroyed_helicopter.angles = (0.303317, 85.1345, 12.2469); 
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




find_camille_end_sequence()
{
	remove_fall_damage_triggers();

	if(isalive(level.camille_diorama))
	{
		level.camille_diorama stop_magic_bullet_shield();
		
		
		
	}

	

	level thread set_approaching_camille_vo_trigger();
	level thread set_reached_camille_trigger();

	

	wait(1);
	level.player play_dialogue("BOND_SinkG_031A");
	wait(2);
	
	
	wait(2);

	level.player play_dialogue("CAMI_SinkG_032A", true);
}


remove_fall_damage_triggers()
{
	damage_triggers = getentarray("fall_damage_trigger", "targetname");

	if ( !IsDefined( damage_triggers) )
	{
		
		return;
	}

	for( i = 0; i < damage_triggers.size; i++ )
	{
		damage_triggers[i] delete();
	}
}


temp_teleport_player()
{
	player_ending_position = getent ( "player_ending_reposition", "targetname" );
	level.player setorigin ( player_ending_position.origin);
	level.player setplayerangles( player_ending_position.angles );
}

set_reached_camille_trigger()
{
	
	trigger = getent( "crash_site_trigger", "targetname" );	
	trigger waittill( "trigger" );

	objective_state(6, "done");

	GiveAchievement("Progression_Opera");
	
	
	wait(1);
	
	

	
	
	


	

	
	level.player FreezeControls(true);

	

	level.hudBlack fadeOverTime(3);		
	level.hudBlack.alpha = 1;

	wait(3);




	
	

	
	
	
	

	
	
	

	
	maps\_endmission::nextmission();
	
	
	level notify( "endmusicpackage" );
}


set_approaching_camille_vo_trigger()
{
	trigger = getent( "approaching_camille_vo_trigger", "targetname" );	
	trigger waittill( "trigger" );

	
	

	level.camille_vo_done = true;
}
