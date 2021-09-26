#include maps\_utility;
#using_animtree("drones");

main (model)
{
	level.vehicleInitThread["vehicledroneai"][model] = ::init;
	level.drones["axis"] = struct_arrayspawn();
	level.drones["allies"] = struct_arrayspawn();
}

init ()
{
	self hide();
	self waittill ("onpath");
	guy = spawn ("script_model",(self.origin));
	guy.turrettarget = spawn ("script_origin",self.origin+(0,0,80));
	guy.turrettarget linkto (self);
	guy makefakeai();
	if(!isdefined(self.script_team))
		self.script_team = "allies";
	guy.targetname = "drone";
	guy.team = self.script_team;
	guy setcandamage(true);
	guy.health = 100000;
	guy UseAnimTree(#animtree);
	guy [[level.scr_character["drone"+guy.team][randomint(level.scr_character["drone"+guy.team].size)]]]();
	guy.run_index = randomint (level.scr_anim["drone"]["run"].size);
	guy.walk_index = randomint (level.scr_anim["drone"]["walk"].size);
	guy.move_anim = level.scr_anim["drone"]["run"][guy.run_index];
	guy linkto (self,"Trim_Char_F_1_1",(0,0,0),(0,0,0));
	guy thread maps\_drones::drone_axis_assignWeapon();
	guy thread maps\_drones::guy_run("drone");
	level thread maps\_spawner::killfriends_missionfail_think(guy);
	wait .1;
	guy notify ("run");
	level notify ("new_drone");
	if(!isdefined(level.drones[self.script_team]))
		level.drones[self.script_team] = struct_arrayspawn();
	structarray_add(level.drones[self.script_team],guy);	
	guy thread death(self);
	self thread delete_on_end(guy);	
	
}


death(vehicle)
{
	self endon ("death");
	if(isdefined(level.currentlayer))
		script_layer = level.currentlayer;
	else
		script_layer = "none";
	thread death_remove(vehicle);
	deathanim = random (level.scr_anim["drone"]["death"]);
	self waittill("damage",damage , other, direction_vec, point );
	self unlink();
	if(damage<=250)
	{
		self animscripted("death anim", self.origin, self.angles, deathanim, "deathplant");
//		self maps\_drones::bloody_death();
	}
	else
	{
		dist = distance (self.origin,point);
		self.mortarDeath = maps\_drones::getExplodeDeath("drone", self.origin, dist);
		self notify ("mortar death");
		self animscripted("death anim", self.origin, self.angles, self.mortarDeath);
	}
	if(other == level.player || other == level.playervehicle)
	{
		if(isdefined(level.axiskilledbyplayer))
			level.axiskilledbyplayer++;
		level notify ("axis death by player"+script_layer); // special decoytown stuff.
	}
	wait 1;
	self maps\_drones::drone_delete();
}

death_remove(vehicle)
{
	self waittill("death");
	self maps\_drones::drone_delete();
	if(isdefined(vehicle))
		vehicle delete();
}

delete_on_end(guy)
{
	self waittill_any ("reached_end_node","death");  //death happens on deleting the vehicle
	if(isdefined(guy))
		guy maps\_drones::drone_delete();
	waittillframeend;
	if(isdefined(self))
		self delete();
}
