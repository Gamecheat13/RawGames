#include maps\_utility;
#using_animtree ("germanhalftrack");

main (model,nodeathmodel)
{
	if(!isdefined(nodeathmodel))
		nodeathmodel = false;
	type = "germanhalftrack";
	switch(model)	
	{
		case "xmodel/vehicle_halftrack_mg_brush":
			type = "germanhalftrack";
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_halftrack_mg_brush");
			if(!nodeathmodel)
				precachemodel("xmodel/vehicle_halftrack_mg_brush_d");
			level.deathmodel[model] = "xmodel/vehicle_halftrack_mg_brush_d";
			break;
		case "xmodel/vehicle_halftrack_mg_desert":
			type = "germanhalftrack";
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_halftrack_mg_desert");
			if(!nodeathmodel)
				precachemodel("xmodel/vehicle_halftrack_mg_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_halftrack_mg_woodland_d";
			break;
		case "xmodel/vehicle_halftrack_mg_snow":
			type = "germanhalftrack";
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_halftrack_mg_woodland_d");
			if(!nodeathmodel)
				precachemodel("xmodel/vehicle_halftrack_mg_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_halftrack_mg_woodland_d";
			break;
		case "xmodel/vehicle_halftrack_mg_woodland":
			type = "germanhalftrack";
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_halftrack_mg_woodland");
			if(!nodeathmodel)
				precachemodel("xmodel/vehicle_halftrack_mg_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_halftrack_mg_woodland_d";
			break;
		case "xmodel/vehicle_halftrack_rockets_snow":
			type = "germanhalftrackrocket";
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_halftrack_rockets_snow");
			if(!nodeathmodel)
				precachemodel("xmodel/vehicle_halftrack_rockets_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_halftrack_rockets_woodland_d";
			break;
		case "xmodel/vehicle_halftrack_rockets_woodland":
			type = "germanhalftrackrocket";
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_halftrack_rockets_woodland");
			if(!nodeathmodel)
				precachemodel("xmodel/vehicle_halftrack_rockets_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_halftrack_rockets_woodland_d";
			break;
	}
	
	level._vehicle_door_jumpout_tag[model] = "hatch_open_left";
	level._vehicle_door_jumpout_anim[model] = %halftrack_halftrack_jumpout;
	
	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %german_halftrack_tank_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;
	level.deathfx_extra[model]["delay"] = 1;	
	level.deathfx[model] = loadfx("fx/explosions/large_vehicle_explosion.efx");
	level.vehicleInitThread[type][model] = ::init;

	level.deathfx_extra[model]["loop"] = loadfx ("fx/fire/halftrack_fire.efx");
	level.deathfx_extra[model]["tag"] = "tag_firefx";
	level.deathfx_extra[model]["delay"] = 1;
		
	level._effect["truck explosion"] = loadfx("fx/explosions/large_vehicle_explosion.efx");
	maps\_treadfx::main(type);
	
}
#using_animtree ("generic_human");

guy_deathinvehicle()
{
	self.ridingvehicle endon("death");

	self orientmode ("face current");
	self SetFlaggedAnimKnobAll("deathanim", self.deathanim, %root, 1, .05, 1);
	while(self.ridingvehicle.health > 0)
	{
		angles = self.ridingvehicle gettagAngles (self.idletag);
		self orientmode ("face angle",angles[1]);				
		wait .05;
	}
	self delete();
	return;
}

init ()
{
	life();

	if (!isdefined(self.script_team))
		self.script_team = "axis";

	thread kill();
	thread maps\_treads::main();

	//spawn mg42 and link it to the vehicle
	//this should probably be done in another script if I knew where was a better place
	if(!isdefined(self.script_nomg) || self.script_nomg == 0)
	{
		self.mgturret[0] = spawnTurret("misc_turret", (0,0,0), "mg42_bipod_stand");

		if (self.script_team == "axis")
			self.mgturret[0] setturretteam("axis");
		else
			self.mgturret[0] setturretteam("allies");
		if(isdefined(self.script_fireondrones))
		{
			self.mgturret[0].fakeowner = undefined;
			self.mgturret[0].script_fireondrones = self.script_fireondrones;
		}
		self.mgturret[0] thread maps\_mg42::mg42_target_drones(true,self.script_team,true);
		self.mgturret[0] linkto(self, "tag_turret", (0, 0, -16), (0, 0, 0));
		self.mgturret[0].angles = self.angles;
		self.mgturret[0] setmode("manual_ai");
		self.mgturret[0] setmodel("xmodel/weapon_mg42");
		self.mgturret[0] maketurretunusable();
		level thread maps\_mg42::mg42_setdifficulty(self.mgturret[0],getdifficulty());
		self.mgturret[0].maxrange = 15000;
		self.mgturret[0] setshadowhint ("never");
	}
	
	positions[0]["getoutanim"] = randomjumpout();
	positions[1]["getoutanim"] = randomjumpout();  // mggunner
	positions[2]["getoutanim"] = %halftrack_guy03_jumpout;
	positions[3]["getoutanim"] = %halftrack_guy05_jumpout;
	positions[4]["getoutanim"] = randomjumpout();
	positions[5]["getoutanim"] = randomjumpout();
	positions[6]["getoutanim"] = randomjumpout();
	positions[7]["getoutanim"] = randomjumpout();
	positions[8]["getoutanim"] = randomjumpout();

	positions[0]["idleanim"] = %halftrack_driver_idle;
	positions[1]["idleanim"] = %halftrack_MGgunner_idle;
	positions[2]["idleanim"] = %halftrack_guy03_idle;
	positions[3]["idleanim"] = %halftrack_guy05_idle;
	positions[4]["idleanim"] = %halftrack_guy06_idle;
	positions[5]["idleanim"] = %halftrack_guy04_idle;
	positions[6]["idleanim"] = %halftrack_guy01_idle;
	positions[7]["idleanim"] = %halftrack_guy02_idle;
	positions[8]["idleanim"] = %halftrack_passenger_idle;
	
	positions[0]["deathanim"] = %halftrack_driver_death;
	positions[1]["deathanim"] = randomdeath();
	positions[2]["deathanim"] = randomdeath();
	positions[3]["deathanim"] = randomdeath();
	positions[4]["deathanim"] = randomdeath();
	positions[5]["deathanim"] = randomdeath();
	positions[6]["deathanim"] = randomdeath();
	positions[7]["deathanim"] = randomdeath();
	positions[8]["deathanim"] = %halftrack_driver_death;
	
	

	positions[0]["exittag"] = "tag_out";
	positions[1]["exittag"] = "tag_out";
	positions[2]["exittag"] = "tag_guy03";
	positions[3]["exittag"] = "tag_guy05";
	positions[4]["exittag"] = "tag_out";
	positions[5]["exittag"] = "tag_out";
	positions[6]["exittag"] = "tag_out";
	positions[7]["exittag"] = "tag_out";
	positions[8]["exittag"] = "tag_out";

	positions[0]["idletag"] = "tag_driver";  
	positions[1]["idletag"] = "tag_MGguy";  
	positions[2]["idletag"] = "tag_guy03";   
	positions[3]["idletag"] = "tag_guy05";   
	positions[4]["idletag"] = "tag_guy06";   
	positions[5]["idletag"] = "tag_guy04";   
	positions[6]["idletag"] = "tag_guy01";   
	positions[7]["idletag"] = "tag_guy02";   
	positions[8]["idletag"] = "tag_passenger";   
	
	thread handle_attached_guys(positions);
}

randomdeath()
{
	if(randomint(100)>50)
		return %halftrack_guy_death1;
	else
		return %halftrack_guy_death2;
}

randomjumpout()
{
	if(randomint(100)>50)
		return %halftrack_guy02_jumpout;
	else
		return %halftrack_guy02b_jumpout;
		
}

handle_attached_guys (positions)
{
	self.usedPositions = [];
	for (i=0;i<9;i++)
		self.usedPositions[i] = false;
	if(isdefined(self.script_nomg) && self.script_nomg)
		self.usedpositions[1] = true; // nobody uses the gunner position;

	delayinc = .6;
	delayer = 1;

	movetospotanim = %stand_alert_1;
	//pos = 0;
	while(self.health > 0)
	{
		guysarray = undefined;
		self waittill ("guyenters" , other);
		guysarray = other;

		for(i=0;i<guysarray.size;i++)
		{
			if(!isdefined(guysarray[i]) || !isalive(guysarray[i]))
				continue;
			guy = guysarray[i];
			
			pos = undefined;
			if (isdefined (guy.script_startingposition))
			{
				pos = guy.script_startingposition;
				assertEx(((pos <= 8) && (pos >= 0)), "script_startingposition on a truck rider must be between 0 and 8");
			}
			else
			{
				//if there isn't one then set it to the lowest unused spot
				for (j=0;j<self.usedPositions.size;j++)
				{
					if (self.usedPositions[j] == true)
						continue;
					pos = j;
					break;
				}
			}

			self.usedPositions[pos] = true;
			assertEX(isdefined(pos),"Position not being defined in truck script");
			
			guy.exittag = positions[pos]["exittag"];
			guy.idletag = positions[pos]["idletag"];
			guy.getoutanim = positions[pos]["getoutanim"];
			guy.ridingvehicle = self;
			if(pos == 2 || pos == 3)
				guy.delay = 0;
			else
			{
				guy.delay = delayer;
				delayer+=delayinc;
			}

			// to make the buffalo use different delays.
			if (self.vehicletype == "buffalo")
			{
				temp_delay = 3.6 - (pos * .4);

 				if (temp_delay < 0)
					temp_delay = 0;
				guy.delay = temp_delay;
			}

			guy.fakedeathanim = positions[pos]["deathanim"];
			guy.idleanim = positions[pos]["idleanim"];
			
			org = self gettagorigin(guy.idletag);
			angles = self gettagAngles(guy.idletag);
			
			
			guy.deathanim = guy.fakedeathanim;  // custom death while in the back of the truck makes them fall into a pile rather than through the side rails
			guy.deathanimscript = ::guy_deathinvehicle; // deletes the guys when they are done doing this deathanim

			thread truck_death(guy);
			if(pos != 0)
			{
				guy teleport (org,angles);
				guy linkto (self, guy.idletag,(0,0,0),(0,0,0));
				if (pos == 1 && (!isdefined(self.script_nomg) || self.script_nomg == 0))
				{
					guy.allowdeath = true;
					//This guy is the gunner
					guy thread halftrack_man_turret(self.mgturret[0]);
					if (isdefined(self.script_unloadmgguy))
					{
						self thread wait_jump_out(guy,pos);
						self thread guy_idle(guy);
					}
					else
					{
						self thread guy_idle(guy,true);
						self thread guy_die_withvehicle(guy,true);
					}
				}
				else
				{
					guy.allowdeath = true;
					self thread guy_idle(guy);
					self thread wait_jump_out(guy,pos);
				}

			}
			if(pos == 0)
			{
				guy.hasweapon = false;
				guy animscripts\shared::PutGunInHand("none");
				guy.allowdeath = 1;
				guy.idleanimstop = positions[pos]["idleanimstop"];
				self.driver = guy; //so I can do driver guy stuff whereever I do truck stuff! cause the driver is soooo special. he gets to close the door
				guy teleport (org);
				guy linkto (self, guy.idletag, (0, 0, 0), (0, 0, 0));
				self thread wait_jump_out(guy,pos);
				self thread guy_idle(guy);
			}
		}
		if(isdefined(self.driver))
		{
			self.driver.delay = delayer;
			delayer+=delayinc;
		}
		thread jumpoutdoor(delayer+delayinc);  
	}
}

halftrack_man_turret(turret)
{
	turret endon ("death");

	self animscripts\shared::PutGunInHand("none");

	level thread maps\_mg42::mg42_setdifficulty(turret,getdifficulty());
	
//	turret.script_delay_min = 0.5;
//	turret.script_delay_max = 1;
//	turret.script_burst_min = 0.25;
//	turret.script_burst_max = 2.5;
	
	turret.fakeowner = self;
	turret.leftarc = 30;
	turret.rightarc = 30;
	turret setmode("auto_nonai");
	turret thread burst_fire_unmanned(self);
	turret setturretignoregoals(true);
	self waittill_any ("death","unload");
	turret.fakeowner = undefined;
	turret maketurretusable();
	turret setmode("manual_ai");
	turret stopfiring();
}

burst_fire_unmanned (guy)
{
	guy endon ("death");
	self maps\_mg42::burst_fire_unmanned();
}

guy_idle (guy,nounload)
{
	if (!isdefined(nounload))
		guy endon ("unload");
	guy endon("manual_idle");
	guy endon ("death");
	while (1)
	{
		org = self gettagOrigin (guy.idletag);
		angles = self gettagAngles (guy.idletag);
		guy animscripted("guyanimdone", org, angles, guy.idleanim);
		guy waittillmatch ("guyanimdone","end");
	}
}


guy_die_withvehicle(guy,nounload)
{
	if (!isdefined(nounload))
		self endon ("unload");
	guy endon ("death");

	self waittill ("death");
	guy dodamage(guy.health+50,(0,0,0));	
}

wait_jump_out (guy,pos)
{
	guy.anim_disablelongdeath = true;
	originalhealth = 0;
	self endon ("nodriverunload");
	if(!isdefined(guy.magic_bullet_shield))
	{
		originalhealth = guy.health;
		guy.health = 1;
	}
	//self endon("death");
	self thread guy_die_withvehicle(guy);
	self waittill ("unload");

	self.usedPositions[pos] = false;
	if (!(isalive (guy)))
		return;
	if(!isdefined(guy.magic_bullet_shield))
		guy.health = originalhealth;

	self.riders = array_remove(self.riders,guy);

	if(!isalive(self))
	{
		guy delete();
		return;
	}	
	guy.hasweapon = true;
	guy animscripts\shared::PutGunInHand("right");
	wait (guy.delay);

	if (!(isalive (guy)) || !isdefined(guy))
		return;
	if(!isalive(self))
	{
		guy delete();
		return;
	}

	guy.deathanim = undefined;
	guy.deathanimscript = undefined;

	guy notify ("unload");

	org = self gettagOrigin (guy.exittag);
	angles = self gettagAngles (guy.exittag);

	if (self.vehicletype == "buffalo")
	{
		guy stopanimscripted();
	}
	else
	{
		guy thread unlink_on_death();
		guy animscripted("jumpout", org, angles, guy.getoutanim);
		guy waittillmatch ("jumpout","end");
	}

	if(!isalive(self))
	{
		guy delete();
		return;
	}
	if(isalive(guy))
	{
		guy unlink();
		guy allowedstances("stand","crouch","prone");
	}
	guy notify ("jumpedout");
	guy.anim_disablelongdeath = false;

}

unlink_on_death()
{
	self endon("jumpedout");
	self waittill("death");
	if(isdefined(self))
		self unlink();
}

deathremove ()
{
	self delete();
}

#using_animtree ("germanhalftrack");

life ()
{
	if ( (isdefined (self.script_startinghealth)) && (self.script_startinghealth > 0) )
		self.health = self.script_startinghealth;
	else
		self.health = 600;
}

kill ()
{
	self thread turrets_delete();
	self waittill( "death", attacker );
	if (!isdefined(self))
		return;
	model = self.model;
	self setmodel(level.deathmodel[self.model]);
	self playsound ("explo_metal_rand");
	playfx (level.deathfx[model], self.origin );
	earthquake(0.25, 3, self.origin, 1050);
	radiusDamage (self.origin+(0,0,128), 245, 300, 200);
	
	if(self getspeedmph() > 8)
	{
		self setwaitspeed(8);
		self waittill("reached_wait_speed");
	}
	self notify ("unload");
}

turrets_delete()
{
	self waittill_any ("delete","death");
	if(isdefined(self.mgturret))
		for (i=0;i<self.mgturret.size;i++)
			if(isdefined(self.mgturret[i]))
				self.mgturret[i] delete();

}

jumpoutdoor (delaytime)
{
	self endon ("death");
	self useanimtree (level._vehicleanimtree[self.model]);
	self waittill ("unload");
	if(isdefined(level._vehicle_door_jumpout_anim) && isdefined(level._vehicle_door_jumpout_anim[self.model]))
  		self setanimknobrestart(level._vehicle_door_jumpout_anim[self.model]);
  	else
  		return;
	origin = self gettagorigin(level._vehicle_door_jumpout_tag[self.model]);
	level thread maps\_utility::playsoundinspace("heavyvehicle_door_open",origin);
	wait delaytime;
	self notify ("unloaded");
	
}

truck_death(guy)
{
	self endon ("unload");
	guy endon ("death");
	self waittill ("death");
	if(isdefined(guy)) // defense against deleted trucks who also delete their guys
	{
		if(!guy.allowdeath)
			guy delete();
		else
			guy doDamage(	guy.health+2005, guy.origin );
	}
	
}


