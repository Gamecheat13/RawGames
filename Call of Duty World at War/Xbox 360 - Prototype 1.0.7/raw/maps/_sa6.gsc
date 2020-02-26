#include maps\_vehicle_aianim;
#using_animtree ("tank");
main(model,type)
{
	if(!isdefined(type))
		type = "sa6";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;
	switch(model)	
	{
		case "vehicle_sa6_no_missiles_desert":
			precachemodel("vehicle_sa6_no_missiles_desert");
			precachemodel("projectile_sa6_missile_desert");
			level.vehicle_deathmodel[model] = "vehicle_sa6_no_missiles_desert";
			break;
		case "vehicle_sa6_no_missiles_woodland":
			precachemodel("vehicle_sa6_no_missiles_woodland");
			precachemodel("projectile_sa6_missile_woodland");
			level.vehicle_deathmodel[model] = "vehicle_sa6_no_missiles_woodland";
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
	self.missileModel = "projectile_sa6_missile_desert";
	self.missileTags = [];
	self.missileTags[0] = "tag_missle1";
	self.missileTags[1] = "tag_missle2";
	self.missileTags[2] = "tag_missle3";
	
	thread maps\_vehicle_missile::main();
}

