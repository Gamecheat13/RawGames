#include maps\_utility;
#include maps\_cars;
#using_animtree ("germantruck");

main (model)
{
	type = "blitz";
	switch(model)	
	{
		case "xmodel/vehicle_opel_blitz_woodland":
			precachemodel("xmodel/vehicle_opel_blitz_woodland");
			precachemodel("xmodel/vehicle_opel_blitz_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_opel_blitz_woodland_d";
			break;
		case "xmodel/vehicle_opel_blitz_desert":
			precachemodel("xmodel/vehicle_opel_blitz_desert");
			precachemodel("xmodel/vehicle_opel_blitz_desert_d");
			level.deathmodel[model] = "xmodel/vehicle_opel_blitz_desert_d";
			break;
		case "xmodel/vehicle_opel_blitz_snow":
			precachemodel("xmodel/vehicle_opel_blitz_snow");
			precachemodel("xmodel/vehicle_opel_blitz_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_opel_blitz_woodland_d";
			break;

	}
	
	level._vehicle_door_jumpout_anim[model] = %germantruck_truck_jumpoff_dooropen;
	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %eldaba_truckride_truckidle;
	level._vehicledriveidle_normal_speed[model] = 40;

	level.vehicleInitThread[type][model] = ::init;
	level.deathfx[model] = 	loadfx("fx/explosions/large_vehicle_explosion.efx");

	level.deathfx_extra[model]["loop"] = loadfx("fx/fire/halftrack_fire.efx");
	level.deathfx_extra[model]["tag"] = "tag_firefx";
	level.deathfx_extra[model]["delay"] = 1;

	maps\_treadfx::main(type);
}

#using_animtree ("generic_human");
init ()
{
	if(!isdefined(self.script_team))
		self.script_team = "axis";
	life();
	thread kill();
	thread maps\_treads::main();
	self.runtovehicleoverride = ::runtovehicle_truck;
	self.buddyjumperslotfree = true;
	self.guygetinque = [];
	
	positions[0]["movetospotanim"] = %stand_alert_1;
	positions[1]["movetospotanim"] = %stand_alert_1;
	positions[2]["movetospotanim"] = %stand_alert_1;
	positions[3]["movetospotanim"] = %stand_alert_1;
	positions[4]["movetospotanim"] = %stand_alert_1;
	positions[5]["movetospotanim"] = %stand_alert_1;
	positions[6]["movetospotanim"] = %stand_alert_1;
	positions[7]["movetospotanim"] = %stand_alert_1;
	positions[8]["movetospotanim"] = %stand_alert_1;

	positions[0]["getout"] = %germantruck_driver_climbout;
	positions[1]["getout"] = %germantruck_guy1_jumpout;
	positions[2]["getout"] = %germantruck_guy2_jumpout;
	positions[3]["getout"] = %germantruck_guy3_jumpout;
	positions[4]["getout"] = %germantruck_guy4_jumpout;
	positions[5]["getout"] = %germantruck_guy5_jumpout;
	positions[6]["getout"] = %germantruck_guy6_jumpout;
	positions[7]["getout"] = %germantruck_guy7_jumpout;
	positions[8]["getout"] = %germantruck_guy8_jumpout;

	positions[0]["idleanimstop"]	= %germantruck_driver_sitidle_loop;
	positions[0]["idleanim"] 		= %germantruck_driver_drive_loop;
	positions[0]["idle"] 		= positions[0]["idleanimstop"];

	positions[0]["closedooranim"] 	= %germantruck_driver_closedoor;
	
	positions[1]["death"] = %death_stand_dropinplace;
	positions[2]["death"] = %death_stand_dropinplace;
	positions[3]["death"] = %death_stand_dropinplace;
	positions[4]["death"] = %death_stand_dropinplace;
	positions[5]["death"] = %death_stand_dropinplace;
	positions[6]["death"] = %death_stand_dropinplace;
	positions[7]["death"] = %death_stand_dropinplace;
	positions[8]["death"] = %death_stand_dropinplace;
	              
	positions[1]["deathscript"] = ::deathremove;
	positions[2]["deathscript"] = ::deathremove;
	positions[3]["deathscript"] = ::deathremove;
	positions[4]["deathscript"] = ::deathremove;
	positions[5]["deathscript"] = ::deathremove;
	positions[6]["deathscript"] = ::deathremove;
	positions[7]["deathscript"] = ::deathremove;
	positions[8]["deathscript"] = ::deathremove;
	
	
	climbnode [0] = "tag_climbnode";
	climbanim [0] = %germantruck_guyC_climbin;

	for(i=0;i<climbnode.size;i++)
		self.climbnode[i] = climbnode[i];
	for(i=0;i<climbanim.size;i++)
		self.climbanim[i] = climbanim[i];
	positions[0]["sittag"] = "tag_driver";
	positions[1]["sittag"] = "tag_guy01";
	positions[2]["sittag"] = "tag_guy02";
	positions[3]["sittag"] = "tag_guy03";
	positions[4]["sittag"] = "tag_guy04";
	positions[5]["sittag"] = "tag_guy05";
	positions[6]["sittag"] = "tag_guy06";
	positions[7]["sittag"] = "tag_guy07";
	positions[8]["sittag"] = "tag_guy08";

	positions[0]["delay"] = 0; 	//driver
	positions[1]["delay"] = 0; 	//tag1
	positions[2]["delay"] = .2; //tag2
	positions[3]["delay"] = .3;	//tag3
	positions[4]["delay"] = 0;	//tag4
	positions[5]["delay"] = .4;	//tag5
	positions[6]["delay"] = .2;	//tag6
	positions[7]["delay"] = .5;	//tag7
	positions[8]["delay"] = .8;	//tag8

	
	thread handle_attached_guys(9,positions);
}

deathremove ()
{
	self delete();
}

removeguyonguydeath( guy )
{
	self endon ("death");
	guy notify ("removedfromgetinque");
	guy waittill ("death");
	self.guygetinque = array_remove(self.guygetinque,guy);
}

runtovehicle_truck (guy,removefromarray)
{
	self endon ("death");
	guy endon ("death");
	self.runningtovehicle[self.runningtovehicle.size] = guy;
	thread runtovehicle_death(guy);

	guyarray = [];
	guy.animatein = 1;

	climbinnode = self.climbnode;
	climbinanim = self.climbanim;
	closenode = climbinnode[0];
	currentdist = 5000;
	thenode = undefined;
	for(i=0;i<climbinnode.size;i++)
	{
		climborg = self gettagorigin(climbinnode[i]);
		climbang = self gettagangles(climbinnode[i]);
		org = getstartorigin (climborg, climbang, climbinanim[i]);
		distance = distance(guy.origin, climborg);
		if(distance < currentdist)
		{
			currentdist = distance;
			closenode = climbinnode[i];
			thenode = i;
		}

	}
	climborg = self gettagorigin(climbinnode[thenode]);
	climbang = self gettagangles(climbinnode[thenode]);
	org = getStartOrigin (climborg, climbang, climbinanim[thenode]);

	guy allowedstances("stand","crouch");
	guy set_forcegoal();

	wait .05;
	guy setgoalpos (org);
	guy.goalradius = 128;

	guy waittill ("goal");
	guy unset_forcegoal();

	self.guygetinque[self.guygetinque.size] = guy;
	self thread removeguyonguydeath(guy);

	guy endon ("buddyjumped");
	while(self.guygetinque.size && self.guygetinque[0] != guy)
		wait .05;
	
	if(self getspeedmph() < 1)
	{
		guyarray[0] = guy;
		if(self.guygetinque.size > 1 && self.buddyjumperslotfree)
		{
			self.buddyjumperslotfree = false;
			self thread buddyjump(self.guygetinque[0], self.guygetinque[1]);
			self.guygetinque[1] notify ("buddyjumped");
		}
		else
		{
			guy setgoalpos (org);
			guy.goalradius = 16;
			wait .05;
			guy waittill ("goal");
			guy.allowdeath = 0;
			guy animscripted("hopinend", climborg,climbang, climbinanim[thenode]);
			self.buddyjumper = guy;
			self.buddyjumptimeouttimer = gettime()+6000;
			guy waittillmatch ("hopinend", "end");
			guy.allowdeath = 1;
			
			guy notify ("enteredvehicle");
			guy notify ("removedfromgetinque");
			self.guygetinque = array_remove(self.guygetinque,guy);
			guyarray[0] = guy;
			self notify ("guyenters", guyarray);
			
		}
	}
}

array_remove_deadguy(array)
{
	newarray = [];
	for(i=0;i<array.size;i++)
		if(isdefined(array[i]) && isalive(array[i]))
			newarray[newarray.size] = array[i];	
	return newarray;
}

guygettonode(node)
{
	self.gottonode = false;
	self setgoalpos (node);
	self.goalradius = 16;
	self waittill ("goal");
	self.gottonode = true;
}

buddyjump ( guy ,buddy ) // guy is the guy standing in the truck I think
{
	self endon ("death");
	buddy allowedstances ("stand");
	buddy.animatein = 1;
	guy.animatein = 1;
	buddyanim1 = %germantruck_guyA_climbin;
	buddyanim2 = %germantruck_guyB_climbin;
	climbinnode = "tag_climbnode";
	climborg = self gettagorigin(climbinnode);
	climbang = self gettagangles(climbinnode);
	org1 = getStartOrigin (climborg, climbang, buddyanim1);
	angles1 = getStartAngles (climborg, climbang, buddyanim1);
	org2 = getStartOrigin (climborg, climbang, buddyanim2);
	angles2 = getStartAngles (climborg, climbang, buddyanim2);
	
	if(isdefined (guy.script_delay))
		wait guy.script_delay;
	guy thread guygettonode(org1);
	buddy thread guygettonode(org2);
	while(!guy.gottonode && !buddy.gottonode)
	{
		wait .05;
		if(!buddyjump_partneralive(guy,buddy))
			return;
	}
	guy linkto(self,climbinnode,(0,0,0),(0,0,0));
	buddy linkto(self,climbinnode,(0,0,0),(0,0,0));

	guy.allowdeath = 0;
	buddy.allowdeath = 0;

	 thread buddyjump_death(buddy);
	 thread buddyjump_death(guy);
	self thread animontag(guy, climbinnode , buddyanim1);
	animontag(buddy, climbinnode , buddyanim2);

//	guy.allowdeath = 1;
//	buddy.allowdeath = 1;
	
	guy notify ("enteredvehicle");
	buddy notify ("enteredvehicle");

	self notify ("buddys_in");

	guysarray = [];
	if(guy.health > 0)
		guysarray[0] = guy;
	if(buddy.health > 0)
		guysarray[1] = buddy;

	self notify ("guyenters", guysarray);
	self.buddyjumperslotfree = true;
}

buddyjump_death(guy)
{
	guy endon ("enteredvehicle");
	self waittill ("death");
	if(isdefined(guy))
		guy delete();
}

buddyjump_partneralive(guy,buddy)
{
	if(!isalive(guy))
	{
		self.buddyjumperslotfree = true;
		thread runtovehicle_truck (buddy);
		return false;
	}
	if(!isalive(buddy))
	{
		self.buddyjumperslotfree = true;
		thread runtovehicle_truck (guy);
		return false;
	}
	return true;
}