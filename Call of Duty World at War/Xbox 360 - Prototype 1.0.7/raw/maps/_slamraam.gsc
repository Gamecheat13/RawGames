#include maps\_vehicle_aianim;
#using_animtree ("tank");
main(model,type)
{
	if(!isdefined(type))
		type = "slamraam";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;
	switch(model)	
	{
		case "vehicle_slamraam":
			precachemodel("vehicle_slamraam");
			precachemodel("projectile_slamraam_missile");
			level.vehicle_deathmodel[model] = "vehicle_slamraam";
			break;
	}
	precachevehicle(type);
	
	// death fx stuff
	level.vehicle_death_fx[type] = [];

	deathfx = loadfx ("explosions/large_vehicle_explosion");
	//this builds an array of effects, timings and such that will be processed by _maps\_vehicle::kill();
	effects = maps\_vehicle::build_deathfx(undefined,deathfx,undefined,"explo_metal_rand");
	level.vehicle_death_fx[type] = effects;
	
	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	//set default team for this vehicletype
	level.vehicle_team[type] = "allies";	
	
	//enables turret
	level.vehicle_hasMainTurret[model] = false;
}

init_local()
{
	self.missileModel = "projectile_slamraam_missile";
	self.missileTags = [];
	self.missileTags[0] = "tag_missle1";
	self.missileTags[1] = "tag_missle2";
	self.missileTags[2] = "tag_missle3";
	self.missileTags[3] = "tag_missle4";
	self.missileTags[4] = "tag_missle5";
	self.missileTags[5] = "tag_missle6";
	self.missileTags[6] = "tag_missle7";
	self.missileTags[7] = "tag_missle8";
	
	thread maps\_vehicle_missile::main();
}

