#include maps\_utility;

kill_on_goal()
{
	self endon("death");
	
	self waittill("goal");
	self delete();
}

tether_on_goal(radius)
{
	self endon("death");

	self waittill("goal");
	self SetTetherRadius(radius);

}

change_speed_on_goal()
{
	self endon("death");

	self waittill("goal");
	self SetScriptSpeed("default");
}

shoot_on_goal(accuracy)
{
	self endon("death");

	if(!IsDefined(accuracy))
	{
		accuracy = .5;
	}
	self waittill("goal");
	self cmdshootatentity(level.player, false, -1, accuracy);
}

force_to_goal(goal_name, after_role, tactical)
{
	self endon("death");

	if(!IsDefined(tactical))
	{
		tactical = 0;
	}

	goal_node = GetNode(goal_name, "targetname");
	self setenablesense(false);
	self lockalertstate("alert_green");
	self setscriptspeed("run");
	self setgoalnode(goal_node,tactical);

	self waittill("goal");
	self setenablesense(true);
	self lockalertstate("alert_red");
	if(IsDefined(after_role))
	{
		self setcombatrole(after_role);
	}

	self thread sight_beyond_sight(10);
}

sight_beyond_sight(time)
{	
	self endon("death");

	if(!IsDefined(time))
	{
		time = 5;
	}
	self setperfectsense(true);

	if(time == -1)
	{
		return;
	}
	wait(time);
	self setperfectsense(false);
}

spawn_mitchell(spawner_name)
{
	spawner = GetEnt(spawner_name,"targetname");
	mitchell = spawner stalingradspawn();
	spawn_failed(mitchell);

	wait(0.05);

	//mitchell thread magic_fail_shield();
	mitchell.health = 100000;
	//mitchell.team = "allies";
	//mitchell.ignoreme = 1;
	//mitchell make_hero();
	mitchell.targetname = "mitchell";
	mitchell SetPainEnable(false);
	mitchell SetEnableSense(false);
	mitchell SetScriptSpeed("sprint");
	mitchell LockAlertState("alert_red");

	if(level.script == "siena" )
	{
		mitchell thread physics_sphere();
	}

	return mitchell;
}

magic_fail_shield()
{
	self endon("death");

	while(self.health/self.maxhealth > 0.2)
	{
		wait(.1);
	}

	MissionFailed();
	//self waittill ( "damage", damage, attacker );
	//if (attacker == level.player)
	//{
	//	MissionFailed(); 
	//}
}

spawn_enemy(spawner_name)
{
	spawner = GetEnt(spawner_name,"targetname");
	new_enemy = spawner StalingradSpawn();
	spawn_failed(new_enemy);

	level.enemy_count++;
	new_enemy thread enemy_death();
	new_enemy setcombatrole("basic");
	new_enemy addengagerule("tgtPerceive");

	//if(level.script == "siena" )
	//{
	//	new_enemy thread physics_sphere();
	//}


	return new_enemy;
}

enemy_death()
{
	self waittill("death");
	level.enemy_count--;
}

clear_enemies(check)
{
	if(!IsDefined(check))
	{
		check = 0;
	}

	todelete = GetAIArray("axis");
	for(i = 0; i < todelete.size; i++)
	{
		if(check == 1)
		{
			if(IsDefined(todelete[i].targetname) && todelete[i].targetname == "mitchell")
			{
				continue;
			}
			else
			{
				todelete[i] delete();
			}
		}
		else
		{
			todelete[i] delete();
		}

	}
}

display_enemy_count()
{
	wait(.5);
	level.hud_enemy = newHudElem();
	level.hud_enemy.alignX = "center";
	level.hud_enemy.alignY = "top";
	level.hud_enemy.fontScale = 1.5;
	level.hud_enemy.x = 0;
	level.hud_enemy.y = 50;
	level.hud_enemy.horzAlign = "center";
	level.hud_enemy.vertAlign = "fullscreen";

	while(1)
	{
		level.hud_enemy setText( level.enemy_count );
		wait(0.1);
	}
}

random_earthquakes()
{
	self endon("stop_earthquakes");

	while(1)
	{
		//Steve G - shake tuning
		//wait( 1.0 + randomfloat(2.0) );
		//Earthquake( randomfloat(.5)+0.1, randomfloat(2.0)+0.5,level.player.origin,2000);
		wait( 2.0 + randomfloat(6.0) );
		Earthquake( randomfloat(.3)+0.1, randomfloat(2.0)+0.5,level.player.origin,2000);
		
		//Steve G - shake sounds
		level.player playsound("random_shake_lf");
		
		level notify ("fx_falling_debris");
		
		pos = level.player.origin + (0,0,72);
		Playfx(level._effect["dust_door"], pos, (0,0,1), (1,0,0) );
	}
}

constant_earthquake()
{
	self endon("stop_earthquakes");

	while(1)
	{
		Earthquake(0.2,0.1,level.player.origin,2000);
		wait(0.1);
	}
}

waittill_trigger_or_enemy(trigger_name, enemy_count)
{
	level thread t_wait(trigger_name);
	level thread e_wait(enemy_count);

	level waittill("condition_go");
}

t_wait(trigger_name)
{
	level endon("condition_go");
	trigger = GetEnt(trigger_name,"targetname");
	trigger waittill("trigger");

	wait(.1);

	level notify("condition_go");

}

e_wait(enemy_count)
{
	level endon("condition_go");

	while(level.enemy_count > enemy_count)
	{
		wait(.1);
	}

	wait(.1);

	level notify("condition_go");
}

save_on_death(enemy)
{
	enemy waittill("death");

	wait(.1);

	thread maps\_autosave::autosave_by_name("siena",20);
}

unload_vehicle(spawner_name, goal_name)
{
	self waittill("reached_end_node");

	spawner = GetEnt(spawner_name,"targetname");
	for(i = 0; i <= spawner.count; i++)
	{
		enemy = spawn_enemy(spawner_name);
		enemy LockAlertState("alert_red");
		enemy SetEnableSense(false);
		enemy_goal = GetNode(goal_name,"targetname");
		enemy SetGoalNode(enemy_goal);
		enemy thread kill_on_goal();
		wait(2);
	}
}

physics_sphere()
{
	self endon("death");
	self endon("stop_sphere");

	physics_ball = spawn("script_origin",self.origin);
	physics_ball.origin += (0,0,30);
	physics_ball linkto(self);

	while(1)
	{
		PhysicsExplosioncylinder( physics_ball.origin, 30,20,.3);
		wait(.1);
	}

}

reset_gravity()
{
	phys_changeDefaultGravityDir( (0,0,-1) );
}

slow_time(val, tim, out_tim)
{
	self endon("stop_timescale");

	thread check_for_death();
	SetSavedDVar( "timescale", val);

	wait(tim - out_tim);

	change = (1-val) / (out_tim*30);
	while(val < 1)
	{
		val += change;
		SetSavedDVar( "timescale", val);
		wait(0.05);
	}

	SetSavedDVar("timescale", 1);

	level notify("timescale_stopped");
}

check_for_death()
{
	self endon("timescale_stopped");

	while(level.player.health > 0)
	{
		wait(.05);
	}

	level notify("stop_timescale");
	SetSavedDVar( "timescale", 1);
}

norm_time()
{
	SetSavedDVar( "timescale", 1);
}

car_check_damage()
{
	self endon("death");

	sAttacker = undefined;
	
	// while loop to constantly check
	while( self.health > 0 )
	{
		// wait for the guy to take damage
		self waittill( "damage", iDamage, sAttacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );
		// check to make sure the player caused the damage
		if( sAttacker == level.player )
		{
			MissionFailed();
		}
	}

}

civilian_action_anim(anim_name)
{
	self endon("death");
	self endon("stop_anim");

	while(1)
	{
		self CmdPlayAnim(anim_name);
		self waittill("Cmd_Done");
	}
}


spawn_dummy(on_or_off)
{
	if(!IsDefined(on_or_off))
	{
		on_or_off = true;
	}

	if(on_or_off == false)
	{
		level notify("stop_dummy");
		return;
	}

	if(on_or_off == true)
	{
		fake_camille = getent ( "scared_lady", "targetname" )  stalingradspawn( "fake_camille" );
		fake_camille waittill( "finished spawning" );
		fake_camille hide();
		fake_camille LockAlertState( "alert_green" );
		fake_camille SetEnableSense( false );
		fake_camille setpainenable( false );
		fake_camille.health = 1000000;

		rail = spawn("script_origin",level.player.origin);
		fake_camille linkto(rail);

		rail moveto(self.origin,.05);
		rail waittill("movedone");
		rail linkto(self);

		level waittill("stop_dummy");

		fake_camille delete();
		rail delete();
		return;
	}
}