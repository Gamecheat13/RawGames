#include maps\_utility;
#include maps\_vehicle;
//#include animscripts\shared;
//#include maps\_anim;
#using_animtree("vehicles");

sink_hole_helicopter()
{
	level thread gunner_attacks_player();
}

place_helicopter()
{
	spawnpoint = getent( "helicopter_spawnpoint", "targetname" );
	//spawnvehicle("v_blackhawk_radiant", "helicopter", "blackhawk", (spawnpoint.origin), (spawnpoint.angles));

	level.helicopter = getent( "temp_helicopter", "targetname" );
	level.helicopter.origin = spawnpoint.origin;

	level.helicopter2 = getent( "helicopter2", "targetname" );
	level.helicopter3 = getent( "helicopter3", "targetname" );

	level.hit_detection_mask = getent("helicopter_hit_detection_mask", "targetname");
	level.hit_detection_mask linkto (level.helicopter);
	level.hit_detection_mask SetCanDamage(true);

	level.helicopter PlayLoopSound("sink_hole_helicopter_wind");
	level.helicopter2 PlayLoopSound("sink_hole_helicopter_wind");
	level.helicopter3 PlayLoopSound("sink_hole_helicopter_wind");

	level.helicopter thread setup_spotlight();
	level.helicopter2 thread setup_spotlight();
	level.helicopter3 thread setup_spotlight();

	level.helicopter thread rappel_rope();
	level.helicopter2 thread rappel_rope();
	level.helicopter3 thread rappel_rope();

	level.helicopter thread place_pilot();
	level.helicopter2 thread place_pilot();
	level.helicopter3 thread place_pilot();

	//level.helicopter thread place_copilot();
	//level.helicopter2 thread place_copilot();
	//level.helicopter3 thread place_copilot();

	playfxontag (level._effect["chopper_cyclone"], level.helicopter, "tag_ground");
	playfxontag (level._effect["chopper_cyclone"], level.helicopter2, "tag_ground");
	playfxontag (level._effect["chopper_cyclone"], level.helicopter3, "tag_ground");
	
	place_gunner("left");

	level.helicopter UseAnimTree( #animtree );
	level.helicopter setanim( %bh_idle );
	level.helicopter setanim( %bh_rotors );

	level.helicopter2 UseAnimTree( #animtree );
	//level.helicopter2 setanim( %bh_idle );
	level.helicopter2 setanim( %bh_rotors );

	level.helicopter3 UseAnimTree( #animtree );
	level.helicopter3 setanim( %bh_idle );
	level.helicopter3 setanim( %bh_rotors );

	level.helicopter.goalradius = 64;

	level.helicopter thread sink_hole_helicopter();

	level.helicopter thread update_yaw();

	//level.helicopter thread magic_bullet_shield();

	//level.helicopter thread helicopter_cyclone_efx();  // NOTE - BRIAN:  This is causing a huge frame rate hit.

	//level thread activate_helicopter_mg();  // NOTE - BRIAN:  This is the magic bullet method for the mg.  I'm not using it.
}

helicopter_cyclone_efx()
{
	wait(4);
	level.cyclone_position = getent("helicopter_cyclone_origin", "targetname");

	playfxontag (level._effect["chopper_cyclone"], level.cyclone_position, "tag_origin");
	//iprintlnbold("SOUND: cyclone wind");
	//level.cyclone_position playloopsound("sink_hole_helicopter_wind", .5);

	while(1)
	{
		start_pos = self GetTagOrigin( "tag_ground" );
		end_pos = start_pos + (0,0,-1000);

		endpos = physicstrace(start_pos, end_pos);

		level.cyclone_position.origin = endpos;
		//iPrintLnBold( "update efx position" );
		wait(2);
	}
}

place_gunner(gun_position)
{
	spawner = getent( "gunner_spawner", "targetname");
	if ( !IsDefined( spawner) )
	{
		iPrintLnBold( "No Spawner!" );
		return;
	}

	level.gunner = spawner stalingradspawn();

	if ( spawn_failed(level.gunner) )
	{
		return;
	}

	spawner.count++;
	level notify("gunner_spawned");

	gunner_angles = level.helicopter getTagAngles( "tag_playerride" ) ;

	if(gun_position == "left")
	{
		level.gunner linkto( level.helicopter, "tag_playerride", ( -50, 0, 8 ), gunner_angles); // left gunner

		level.gunner thread maintain_rpg_facing("left");
	}
	else
	{
		level.gunner linkto( level.helicopter, "tag_playerride", ( -5, 0, 8 ), gunner_angles); // right gunner

		level.gunner thread maintain_rpg_facing("right");
	}

	level.gunner LockAlertState("alert_red");
	level.gunner AllowedStances("crouch");
	level.gunner SetEnableSense(false);

	level.gunner.dropweapon = false;
}

maintain_facing(facing)
{
	self endon("death");

	if(facing == "right")
	{
		gunner_angles = level.helicopter getTagAngles( "tag_guy0" ) + (0, 90, 0);

		while(isalive(self))
		{
			self linkto( level.helicopter, "tag_guy0", ( 17, -4, -18 ), gunner_angles); // left gunner
			wait(.01);
		}
	}
	else if(facing == "left")
	{
		gunner_angles = level.helicopter getTagAngles( "tag_guy0" ) + (0, -90, 0);

		while(isalive(self))
		{
			self linkto( level.helicopter, "tag_guy0", ( 17, 26, -18 ), gunner_angles); // left gunner
			wait(.01);
		}
	}
}


////////////////////////////////////////
///////// HELICOPTER: MOVEMENT /////////
////////////////////////////////////////

begin_helicopter_patrol(start_node_targetname, speed)
{
	self.end_of_path = false;
	self notify("cancel_patrol"); // interrupts any existing patrol path for this helicopter
	wait(.05);
	self endon("cancel_patrol");
	self endon("death");

	destination = getent(start_node_targetname, "targetname");
	if(!isdefined(destination))
	{
		iPrintLnBold( "Bad patrol path name" );
		return;
	}

	self setspeed(speed, speed*.5);
	patrol_active = true;

	self SetTurningAbility(.9);

	while(IsDefined(destination) && IsDefined(self))
	{
		stop = false;
		next = undefined;

		if(IsDefined (destination.target))
		{
			next = getent(destination.target, "targetname");

			if (IsDefined(destination.radius) && (destination.radius == -1))
			{
				stop = true;
			}

			if (IsDefined(destination.script_wait)
				|| (IsDefined(destination.script_wait_min)
				&& IsDefined(destination.script_wait_max)))
			{
				stop = true;
			}
			else if (IsDefined(destination.script_flag_wait) && !flag(destination.script_flag_wait))
			{
				stop = true;
				//self thread helicopter_patrol_skip_for_flag(destination.script_flag_wait);
			}
		}
		else
		{
			stop = true;
		}

		if (IsDefined(destination.script_airspeed))
		{
			self SetSpeed(destination.script_airspeed, destination.script_airspeed * .2);
		}

		self SetVehGoalPos(destination.origin, stop);
		if (destination.angles[1] != 0)
		{
			self SetTargetYaw(destination.angles[1]);
		}
		else
		{
			self ClearTargetYaw();
		}

		radius = 0;
		if (IsDefined(destination.radius))
		{
			radius = destination.radius;
			if (radius > 1)
			{
				self SetNearGoalNotifyDist(radius);
			}
		}

		if (radius <= 1)
		{
			self SetNearGoalNotifyDist(50);
		}

		if (stop && (radius <= 1))
		{
			self waittill( "goal" );
		}
		else
		{
			self waittill( "near_goal" );
		}

		if(IsDefined(destination.script_noteworthy))
		{
			self notify(destination.script_noteworthy);
		}

		if (IsDefined(destination.script_flag_wait))
		{
			flag_wait(destination.script_flag_wait);
		}
		else
		{
			destination script_wait();
		}

		destination = next;
	}

	self notify("end_of_path");
	self.end_of_path = true;
}

//helicopter_patrol_skip_for_flag(flag)
//{
//	self endon("goal");
//	flag_wait(flag);
//	//iPrintLnBold("skipping for flag (" + flag + ")");
//	self notify("goal");
//}

///////////////////////////////////////////////////
///////// HELICOPTER: SPOTLIGHT /////////////////
//////////////////////////////////////////////////

setup_spotlight()
{
	self.maxhealth = 7777777; // if max health is set to seven 7's, then the hit crosshair will not appear when you hit the entity. 
								// this is important so the player does not think he can damage the helicopter or that he is hitting the 
								// crew when he is actually missing them but hitting the helicopter.
	self.health = 100000;


	if (self == level.helicopter)
	{
		self thread maintain_helicopter_health();
	}

	// spawn locked forward position target
	self.spotlight_fixed_target = Spawn( "script_origin", self GetTagOrigin( "tag_ground" )+ (200, 0, -100));
	self.spotlight_fixed_target linkto( self, "tag_ground", (200, 0, -100), (0,0,0)); 

	// set up rotor position (has nothing to do with the spotlight
	self.rear_rotor = Spawn( "script_model", self GetTagOrigin( "tag_origin" )+ (-400, 0, 200));
	self.rear_rotor setModel( "tag_origin" );
	self.rear_rotor linkto( self, "tag_ground", (-400, 0, 200), (0,0,0)); 

	// spawn spotlight target node
	if (self == level.helicopter)
	{
		self.spotlight_target = getent("spotlight_target", "targetname");
		self.primary_spotlight = getent("light_source", "targetname");
	}
	else if (self == level.helicopter2)
	{
		self.spotlight_target = getent("spotlight_target2", "targetname");
		self.primary_spotlight = getent("light_source2", "targetname");
	}
	else if (self == level.helicopter3)
	{
		self.spotlight_target = getent("spotlight_target3", "targetname");
		self.primary_spotlight = getent("light_source3", "targetname");
	}

	self.spotlight_target.origin = self.spotlight_fixed_target.origin;

	if (level.ps3)
	{
		self.primary_spotlight SetLightIntensity(0);	// turn off dynamic spotlights for ps3 :(
	}

	// set primary light
	self.primary_spotlight.spotlight_intensity = self.primary_spotlight GetLightIntensity();

	self.primary_spotlight SetLightIntensity(0);
	self.primary_spotlight.origin = (0,0,0);
	self.primary_spotlight.angles = (0,0,0);
	self.primary_spotlight linkLightToEntity( self, "tag_barrel" );

	self thread activate_spotlight();
	self thread setup_running_lights();
}

//CG - adding running light effects
setup_running_lights()
{
	wait(randomfloatrange(0,1)); //staggering lights between choppers
	//iprintlnbold("FX: setup_running_lights...");
	playfxontag (level._effect["chopper_light_red"], self, "tag_origin");
	playfxontag (level._effect["chopper_light_red2"], self, "tag_origin");
}

maintain_helicopter_health()
{
	level endon("helicopter crashing");

	//iPrintLnBold( "Helicopter health check active" );

	while(1)
	{
		//level.hit_detection_mask waittill("damage");
		level.hit_detection_mask waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName ); 
		self.health = 100000;

		if(attacker == level.player) 
		{
			currentweapon = level.player getCurrentWeapon();

			if(currentweapon == "dad_sink")
			{
				//iPrintLnBold( "Shot with DAD" );
				playfxontag (level._effect["helicopter_smoking"], level.helicopter, "tag_engine_right");
				playfxontag (level._effect["helicopter_smoking"], level.helicopter, "tag_engine_left");
				wait(1);

				while(1)
				{
					//level.hit_detection_mask waittill("damage");
					//self.health = 100000;
					level.hit_detection_mask waittill("damage", damage, attacker, direction_vec, point, type, modelName, tagName ); 
					self.health = 100000;

					if(attacker == level.player) 
					{
						currentweapon = level.player getCurrentWeapon();

						if(currentweapon == "dad_sink")
						{
							//iPrintLnBold( "Shot with DAD" );
							playfxontag (level._effect["helicopter_crashing"], level.helicopter, "tag_origin");
							level thread maps\sink_hole_2::helicopter_crash();
						}
					}
				}
			}
		}
	}
}


activate_spotlight()
{
	self endon("death");

	self setTurretTargetEnt( self.spotlight_target );
	self thread target_spotlight_at_entity(self.spotlight_fixed_target, .01);

	while (true)
	{
		self waittill("turn_on_spotlight");
		
		self.spotlighttag = spawn( "script_model", (0, 0, 0) );
		self.spotlighttag setModel( "tag_origin" );
		self.spotlighttag linkTo( self, "tag_barrel", (20, 0, 0), (0, 0, 0) );
		
		PlayfxOnTag(level._effect["science_lightbeam05"], self.spotlighttag, "tag_origin" );
		self.primary_spotlight SetLightIntensity(self.primary_spotlight.spotlight_intensity);

		self waittill("turn_off_spotlight");

		self.spotlighttag delete();
		self.primary_spotlight SetLightIntensity(0);
	}
}

target_spotlight_at_entity(target_entity, speed)
{
	self notify("cancel_spotlight_target"); // interrupts any existing patrol path for this helicopter
	wait(.05);
	self endon("cancel_spotlight_target");
	self endon("death");

	while (IsDefined(target_entity))
	{
		if (self.spotlight_target.origin != target_entity.origin)
		{
			self.spotlight_target moveto( target_entity.origin, speed, speed / 4, speed / 2 );
			wait speed;
		}
		else
		{
			wait .1;
		}
	}
}

target_spotlight_at_path(start_node_targetname, speed)
{
	self notify("cancel_spotlight_target");
	wait(.05);
	self endon("cancel_spotlight_target");
	//self endon("death");

	//flag_clear("player_targeted_by_gunner");

	// grab start node
	destination = getent(start_node_targetname, "targetname");
	assertex(IsDefined(destination), "Bad spotlight path name (" + start_node_targetname + ")");

	first = destination;

	target_array = [];
	target_array[0] = destination;

	while (IsDefined(destination) && IsDefined(destination.target))
	{
		next = GetEnt(destination.target, "targetname");
		if (next != first)
		{
			target_array[target_array.size] = next;
			destination = next;
		}
		else
		{
			break;
		}
	}
	
	target = random(target_array);
	destination = target;

	// set light to move to start node
	self.spotlight_target moveto( destination.origin, speed, .20, .35 );
	wait(speed);

	// NOTE: I could put in here the ability to have each node specify the speed to go to the next node.  For now I'm going to try to use one speed
	//       and use the node spacing as a way of controlling the pace of the light's movement.

	while (level.end_of_level == false) // this ensures the function shuts down before I delete the helicopters
	{
		//if(IsDefined(destination.target))
		//{
			//destination = getent(destination.target, "targetname");
			while (target == destination)
			{
				wait .05;
				target = random(target_array);
			}

			destination = target;
			self.spotlight_target moveto( destination.origin, speed, speed / 2, speed / 2 );
			wait(speed);

			if(IsDefined(destination.script_noteworthy))
			{
				self.spotlight_target notify(destination.script_noteworthy);
			}
		//}
		//else
		//{
		//	break;
		//}
	}
}



///////////////////////////////////////
///////// HELICOPTER: COMBAT /////////
/////////////////////////////////////

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
				//iPrintLnBold("updating yaw");
			}
			//else if (IsDefined(self.spotlight_target))
			//{
			//	//level.helicopter ClearGoalYaw();

			//	//ang = VectorToAngles(level.helicopter.spotlight_target.origin - level.helicopter.origin);
			//	//ang = VectorToAngles(AnglesToRight(ang));

			//	//level.helicopter SetTargetYaw(ang[1]);
			//	level.helicopter SetLookAtEnt(level.helicopter.spotlight_target);
			//	level.helicopter SetLookAtEntYawOffset(-90);
			//	//iPrintLnBold("updating yaw");
			//}
			else
			{
				//level.helicopter ClearTargetYaw();
				level.helicopter ClearLookAtEnt();
				//iPrintLnBold("clearing yaw");
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

helicopter_fires_at_camille(stage_number)
{
	level.gunner endon("death");

	flag_clear("player_targeted_by_gunner");
	//level endon("cancel_spotlight_target");

	//level.gunner thread stop_gunner_if_interrupted();

	level.gunner stopcmd();

	//level.gunner notify("stop_interruption_check");

	switch(stage_number)
	{
	case 1:
		level.gunner cmdshootatentity( level.helicopter.spotlight_target, false, 6, 5 );
		wait(6);
		level.gunner stopcmd();
		wait(3);
		level.gunner cmdshootatentity( level.helicopter.spotlight_target, false, 6, 5 );
		level.helicopter thread target_spotlight_at_path("camille_search_1_path", 2);
		break;

	case 2:
		level.helicopter thread target_spotlight_at_entity(level.camille, .8);
		wait 1;
		level.gunner cmdshootatentity( level.helicopter.spotlight_target, false, 6, 5 );
		break;

	case 3:
		level.helicopter thread target_spotlight_at_entity(level.camille, .5);
		level.gunner cmdshootatentity( level.helicopter.spotlight_target, false, 6, 5 );
		break;
	}
}

//stop_gunner_if_interrupted()
//{
//	self endon("stop_interruption_check");
//
//	level waittill("cancel_spotlight_target");
//	self stopcmd();
//}
//

debug_origin()
{
	while (true)
	{
		Print3d(self.origin, "origin", (1, 1, 1), 1, 3, 1);
		wait .05;
	}
}

///////////////////////////////////////
///////// HELICOPTER: BOSS FIGHT /////////
/////////////////////////////////////////

maintain_rpg_facing(facing)
{
	self endon("death");
	self endon("death_sequence");

	level notify("change_rpg_facing");
	wait(.1);
	level endon("change_rpg_facing");

	if(facing == "right")
	{
		gunner_angles_right = level.helicopter getTagAngles( "tag_playerride" ) + (0, level.facing_adjustment, 0);

		while(isalive(self))
		{
			self linkto( level.helicopter, "tag_playerride", ( -5, 0, 8 ), gunner_angles_right); // right gunner
			wait(.01);
		}
	}
	else
	{
		gunner_angles_left = level.helicopter getTagAngles( "tag_playerride" ) + (0, 90, 0);

		while(isalive(self))
		{
			self linkto( level.helicopter, "tag_playerride", ( -50, 0, 8 ), gunner_angles_left); // right gunner
			wait(.01);
		}
	}
}


maintain_gunner_facing(facing)
{
	self endon("death");

	level notify("change_gunner_facing");
	wait(.1);
	level endon("change_gunner_facing");

	if(facing == "right")
	{
		gunner_angles_right = level.helicopter getTagAngles( "tag_guy0" ) + (0, level.gunner_facing_adjustment, 0);

		while(isalive(self))
		{
			self linkto( level.helicopter, "tag_guy0", ( 22, -4, -18 ), gunner_angles_right); // right gunner // 17
			wait(.01);
		}
	}
	else
	{
		gunner_angles_left = level.helicopter getTagAngles( "tag_guy0" ) + (0, -90, 0);

		while(isalive(self))
		{
			self linkto( level.helicopter, "tag_guy0", ( 22, 26, -18 ), gunner_angles_left);  // right gunner
			wait(.01);
		}
	}
}


#using_animtree("fakeShooters");

place_pilot()
{
	pilot_angles = self GetTagAngles("tag_driver") + (0, 180, 0);
	pilot_origin = self GetTagOrigin("tag_driver");

	self.pilot = Spawn("script_model", pilot_origin);
	self.pilot.angles = pilot_angles;
	self.pilot character\character_thug_2_sinkhole::main();
	self.pilot LinkTo(self, "tag_driver", (-3, -17, -35), (0,0,0));// 0  -19

	self.pilot UseAnimTree(#animtree);
	self.pilot SetAnim(%pilot_flying_loop);
}

place_copilot()
{
	copilot_angles = self GetTagAngles("tag_passenger") + (0, 180, 0);
	copilot_origin = self GetTagOrigin("tag_passenger");

	self.copilot = Spawn("script_model", copilot_origin);
	self.copilot.angles = copilot_angles;
	self.copilot character\character_thug_1_sinkhole::main();
	self.copilot LinkTo(self, "tag_passenger", (-4, 0, -19), copilot_angles);

	self.copilot UseAnimTree(#animtree);
	self.copilot SetAnim(%Gen_Civs_SitConversation_A);
}

/*
place_dead_pilot()
{
	//pilot_angles = self GetTagAngles("tag_driver");
	//pilot_origin = self GetTagOrigin("tag_driver");

	self.dead_pilot = Spawn("script_model", pilot_origin);
	self.dead_pilot.angles = pilot_angles;
	self.dead_pilot character\character_thug_2_sinkhole::main();
	self.dead_pilot LinkTo(self, "tag_driver", (0, 0, 0), pilot_angles);

	self.dead_pilot UseAnimTree(#animtree);
	self.dead_pilot SetAnim(%pilot_dead_loop);
}
*/
#using_animtree("generic_human");

//rappel(guy, dest_node)
//{
//	self SetSpeedImmediate(0, 10, 10);
//
//	guy LinkTo(self, "tag_playerride", (0, 0, 0), (0, 180, 0));
//	guy CmdPlayAnim("Thu_SH_Rappel_Full", false );
//	//guy waittill("cmd_done");
//	guy waittill("unlink");
//	guy UnLink();
//
//	if (IsDefined(dest_node))
//	{
//		guy SetGoalNode(dest_node);
//	}
//
//	guy notify("rappel_done");
//}

rappel(guy, dest_node)
{
	hook = Spawn("script_model", self GetTagOrigin("tag_playerride"));
	hook SetModel("tag_origin");
	hook.angles = self GetTagAngles("tag_playerride");

	if (IsDefined(dest_node))
	{
		hook.anlges = (0, VectorToAngles(dest_node.origin - hook.origin)[1], 0);	// face destination 
	}

	guy LinkTo(hook, "tag_origin", (0, 0, 0), (0, 0, 0));
	guy CmdPlayAnim("Thu_SH_Rappel", false );

	wait 0.05;	// wait so the anim is playing for the bullet trace, because the anim positions the guy's origin

	// bullet trace to get the ground position
	trace = bullettrace(guy.origin, guy.origin + (0, 0, -10000), false, self);

	dist = guy.origin[2] - trace["position"][2];
	hook MoveZ(-1 * dist, 2, .5, .5);	//dist = 347.076
	hook waittill("movedone");

	// play the land anim
	guy Unlink();
	guy CmdPlayAnim("Thu_SH_Rappel_Land", false );
	guy StopCmd();
	guy waittill("cmd_done");

	if (IsDefined(dest_node))
	{
		guy SetGoalNode(dest_node);
	}

	guy notify("rappel_done");
}


#using_animtree("fxanim_repel_rope");

rappel_rope()
{
	self endon("death");

	rope = Spawn("script_model", self GetTagOrigin("tag_playerride"));
	rope SetModel("fxanim_repel_rope");
	rope LinkTo(self, "tag_playerride", (0, 0, 0), (0, 0, 0));
	rope UseAnimTree(#animtree);

	rope thread wait_to_hide_rope();

	while (true)
	{
		self waittill("rappel_rope_down");
		rope StopAnimScripted();
		rope AnimScripted("rappel_rope_down", rope.origin, rope.angles, %fxanim_repel_rope_down);

		self waittill("rappel_rope_up");
		rope StopAnimScripted();
		rope AnimScripted("rappel_rope_up", rope.origin, rope.angles, %fxanim_repel_rope_up);
	}
}


wait_to_hide_rope()
{
	level waittill("hide_helicopter_rope");
	if(isdefined(self))
	{
		self hide();
	}
}