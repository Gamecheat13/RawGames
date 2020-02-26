#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;


///////////////////////////////////////////////////////////////////////
// Pendulum Trap
///////////////////////////////////////////////////////////////////////
initPendulumTrap ()
{
	penBuyTrigger = getentarray("pendulum_buy_trigger","targetname");
	
	for(i = 0; i < penBuyTrigger.size; i++)
	{
		penBuyTrigger[i].lever = getent(penBuyTrigger[i].target, "targetname");
		penBuyTrigger[i].penDamageTrig = getent((penBuyTrigger[i].lever).target, "targetname");
		penBuyTrigger[i].pen = getent((penBuyTrigger[i].penDamageTrig).target, "targetname");
		penBuyTrigger[i].pulley = getent((penBuyTrigger[i].pen).target, "targetname");		
	}
	
	penBuyTrigger[0].penDamageTrig EnableLinkTo();
	penBuyTrigger[0].penDamageTrig LinkTo (penBuyTrigger[0].pen);
	
	level thread maps\nazi_zombie_sumpf::turnLightGreen("pendulum_light");
}

moveLeverDown()
{	
	soundent_left = getent("switch_left","targetname");	
	soundent_right = getent("switch_right","targetname");	
	self.lever rotatepitch(180,.5);
	soundent_left playsound("switch");
	soundent_right playsound("switch");
	self.lever waittill ("rotatedone");
	
	self notify ("leverDown");
	
}

moveLeverUp()
{
	soundent_left = getent("switch_left","targetname");	
	soundent_right = getent("switch_right","targetname");
	
	self.lever rotatepitch(-180,.5);
	
	soundent_left playsound("switch");
	soundent_right playsound("switch");
	
	self.lever waittill ("rotatedone");
	
	self notify ("leverUp");
}	
play_trap_dialog()
{
	waittime = 0.12;
	
	index = maps\_zombiemode_weapons::get_player_index(self);
	player_index = "plr_" + index + "_";
	
	
	if(!IsDefined (self.vox_trap_log))
	{
		num_variants = maps\_zombiemode_spawner::get_number_variants(player_index + "vox_trap_log");
		//iprintlnbold(num_variants);
		self.vox_trap_log = [];
		for(i=0;i<num_variants;i++)
		{
			self.vox_trap_log[self.vox_trap_log.size] = "vox_trap_log_" + i;
			//iprintlnbold("vox_kill_headdist_" + i);	
		}
		self.vox_trap_log_available = self.vox_trap_log;
	}
		sound_to_play = random(self.vox_trap_log_available);
		//iprintlnbold("LINE:" + player_index + sound_to_play);
		
		self maps\_zombiemode_spawner::do_player_playdialog(player_index, sound_to_play, waittime);
		self.vox_trap_log_available = array_remove(self.vox_trap_log_available,sound_to_play);
	
		if (self.vox_trap_log_available.size < 1 )
		{
			self.vox_trap_log_available = self.vox_trap_log;
		}	
	
}
penThink()
{	
	//lets give it a little time to make sure the doors have opened
	self sethintstring( "" );
	pa_system = getent("speaker_by_log", "targetname");
	wait(0.5);

	self sethintstring( &"ZOMBIE_ACTIVATE_TRAP" );
	self.zombie_cost = 750;
	self.in_use = 0;
	
	while(1)
	{
		self waittill( "trigger", who );
		self.used_by = who;
		if( who in_revive_trigger() )
		{
			continue;
		}
					
		if( is_player_valid( who ) )
		{
			if( who.score >= self.zombie_cost )
			{				
				if(!self.in_use)
				{
					self.in_use = 1;
					penBuyTrigger = getentarray("pendulum_buy_trigger","targetname");
					level thread maps\nazi_zombie_sumpf::turnLightRed("pendulum_light");
					array_thread (penBuyTrigger,::trigger_off);

					play_sound_at_pos( "purchase", who.origin );
					who thread play_trap_dialog();
					
					//set the score
					who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost );
					
					self thread moveLeverDown();	
					self waittill("leverDown");
					motor_left = getent("engine_loop_left", "targetname");
					motor_right = getent("engine_loop_right", "targetname");
					
					playsoundatposition ("motor_start_left", motor_left.origin);
					playsoundatposition ("motor_start_right", motor_right.origin);
					//adding a ramp up time, I'm sure this will be accompanied by audio
					wait(0.5);
						
					self thread activatePen(motor_left, motor_right, who);
					
					self waittill("penDown");
					
					self thread moveLeverUp();	
					self waittill("leverUp");
					
					wait (45.0);
					pa_system playsound("warning");
					
					array_thread (penBuyTrigger,::trigger_on);
					level thread maps\nazi_zombie_sumpf::turnLightGreen("pendulum_light");
					self.in_use = 0;	
				}
			}
		}
	}
}

activatePen(motor_left, motor_right, who)
{	
	wheel_left = spawn("script_origin", motor_left.origin);
	wheel_right = spawn("script_origin", motor_right.origin);
	
	wait_network_frame();		// CODER_MOD : DSL - let the cost of spawning these across first.

	motor_left playloopsound ("motor_loop_left");
	motor_right playloopsound("motor_loop_right");
	
	wait_network_frame();
	
	wheel_left playloopsound("wheel_loop");
	wheel_right playloopsound("belt_loop");
	
	//kill any thread that wants to turn the log trap solid from the previous run
	self.pen notify ("stopmonitorsolid");
	
	self.pen notsolid();
	
	self.penDamageTrig trigger_on();
	
	self.penDamageTrig thread penDamage(self, who);
	
	self.penactive = true;
	if (self.script_noteworthy == "1")
	{
		self.pulley rotatepitch( -14040, 30, 6, 6 );
		self.pen rotatepitch( -14040, 30, 6, 6 );		
	}
	else
	{
		self.pulley rotatepitch( 14040, 30, 6, 6 );
		self.pen rotatepitch( 14040, 30, 6, 6 );
	}
    level thread trap_sounds (motor_left, motor_right, wheel_left, wheel_right);
    self.pen thread blade_sounds();
	self.pen waittill("rotatedone");
	
	//turn off damage triggers
	self.penDamageTrig trigger_off();
	self.penactive = false;
	
	//pen has collision again
	self.pen thread maps\nazi_zombie_sumpf_zipline::objectSolid();
		
	self notify ("penDown");
	level notify ("stop_blade_sounds");
	wait(3);
	wheel_left delete();
	wheel_right delete();
	
}
blade_sounds()
{
	self endon("rotatedone");
	
	blade_left = getent("blade_left", "targetname");
	blade_right = getent("blade_right", "targetname");

	
	lastAngle = self.angles[0];
	
	for(;;)
	{
		wooshAngle = 90;
		wait(.01);
		angle = self.angles[0];
		speed = int(abs(angle - lastAngle))%360;
		relPos = int(abs(angle))%360;
		lastRelPos = int(abs(lastAngle))%360;

		if(relPos == lastRelPos || speed < 7)
		{
			lastAngle = angle;
			continue;
		}
		
		if(relPos > wooshAngle && lastRelPos <= wooshAngle)
		{
			blade_left playsound("blade_right");
			blade_right playsound("blade_right");
		}		

		if((relPos+180)%360 > wooshAngle && ((lastRelPos+180)%360) <= wooshAngle) //&& speed > 42
		{
			blade_left playsound("blade_right");
			blade_right playsound("blade_right");
		}		
		
		
		lastAngle = angle;
	}
	
}
trap_sounds(motor_left, motor_right, wheel_left, wheel_right)
{
	wait(11);
	motor_left stoploopsound(2);
	motor_left playsound("motor_stop_left");
	motor_right stoploopsound(2);
	motor_right playsound("motor_stop_right");
	wait(6);
	wheel_left stoploopsound(4);
	wheel_right stoploopsound(4);
	
}
penDamage(parent, who)
{	
	thread customTimer();
	while(1)
	{
		self waittill("trigger",ent);
			
		if (parent.penactive == true)
		{
			if(isplayer(ent) )
			{
				ent thread playerPenDamage();
			}
			else
			{
				ent thread zombiePenDamage(parent);

				//add the round number when player made a kill with the trap.
				who.trapped_used["log_trap"] = level.round_number;
			}
		}
	}
}

customTimer()
{
	level.my_time = 0;
	while (level.my_time <= 20)
	{
		wait(.1);
		level.my_time = level.my_time + 0.1;
	}
}

playerPenDamage()
{	
	self endon("death");
	self endon("disconnect");
		
	players = get_players();
	if (players.size == 1)
	{
		self thread maps\_zombiemode::player_damage_override( undefined, undefined, 100, undefined, "MOD_MELEE", undefined, self.origin, self.origin, undefined, undefined, undefined );
	}
	else
	{
		if(!self maps\_laststand::player_is_in_laststand() )
		{                
			radiusdamage(self.origin,10,self.health + 100,self.health + 100);
		}
	}	
}

zombiePenDamage(parent, time)
{
	self endon("death");
	
	if(flag("dog_round"))
	{
		self.a.nodeath = true;
	}
	else
	{
		if(!isdefined(level.numLaunched))
		{
			level thread launch_monitor();
		}
		
		if(!isdefined(self.flung))
		{
			if (parent.script_noteworthy == "1")
			{
				x = randomintrange(200, 250);
				y = randomintrange(-35, 35);
				z = randomintrange(95,120);
			}
			else
			{
				x = randomintrange(-250, -200);		
				y = randomintrange(-35, 35);
				z = randomintrange(95,120);
			}
			
			//adjust the force to match speed of trap
			if (level.my_time < 6)
				adjustment = level.my_time / 6;
			else if (level.my_time > 24)
				adjustment = (30 - level.my_time) / 6;
			else
				adjustment = 1;
			
			x = x * adjustment;
			y = y * adjustment;
			z = z * adjustment;
			
			self thread do_launch(x,y,z);
		}
	}
}

launch_monitor()
{
	level.numLaunched = 0;
	while(1)
	{
		wait_network_frame();
		wait_network_frame();
		level.numLaunched = 0;
	}
}

do_launch(x,y,z)
{
	self.flung = 1;
	
	while(level.numLaunched > 4)
	{
		wait_network_frame();
	}
	
	self thread play_imp_sound();
	
	self StartRagdoll();
	
	self launchragdoll((x, y, z));

	level.numLaunched ++;	

}

flogger_vocal_monitor()
{
	while(1)
	{
		level.numFloggerVox = 0;
		wait_network_frame();
		wait_network_frame();
	}
}

play_imp_sound()
{
	if(!isdefined(level.numFloggerVox))
	{
		level thread flogger_vocal_monitor();
	}
	
	if((level.numFloggerVox < 5) && oktospawn())
	{
		self playsound("flogger_vocals");
		playfxontag(level._effect["trap_log"],self,"tag_origin");
		level.numFloggerVox ++;
	}
	wait(0.75);
	self dodamage(self.health + 600, self.origin); 
}
