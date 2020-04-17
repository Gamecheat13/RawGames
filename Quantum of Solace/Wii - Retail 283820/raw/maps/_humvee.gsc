#include maps\_vehicle_aianim;
main(model,type)
{
	if(!isdefined(type))
		type = "humvee";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = loadfx ("explosions/large_vehicle_explosion");

	
	level.vehicle_hasMainTurret[model] = false;

	switch(model)	
	{
		case "vehicle_humvee_camo":
			precachemodel("vehicle_humvee_camo");
			precachemodel("vehicle_humvee_camo");
			level.vehicle_deathmodel[model] = "vehicle_humvee_camo";
			break;
		case "vehicle_humvee_camo_50cal_doors":
			precachemodel("vehicle_humvee_camo_50cal_doors");
			precachemodel("vehicle_humvee_camo_50cal_doors");
			level.vehicle_deathmodel[model] = "vehicle_humvee_camo_50cal_doors";
			level.vehicle_hasMainTurret[model] = true;  
			level.vehicle_turretFireTime[model] = .15;
			break;
		case "vehicle_humvee_camo_50cal_nodoors":
			precachemodel("vehicle_humvee_camo_50cal_nodoors");
			precachemodel("vehicle_humvee_camo_50cal_nodoors");
			level.vehicle_deathmodel[model] = "vehicle_humvee_camo_50cal_nodoors";
			level.vehicle_hasMainTurret[model] = true; 
			level.vehicle_turretFireTime[model] = .15;
			break;
	}
	precachevehicle(type);
	




	
	level.vehicle_death_fx[type] = [];
	


	



	effects = maps\_vehicle::build_deathfx(undefined,deathfx,undefined,"explo_metal_rand");
	level.vehicle_death_fx[type] = effects;
	
	


	
	



	
	
	

	
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	
	

	
	


	
	level.vehicle_team[type] = "allies";	
	
	
	

	
	
	level.vehicle_unloadwhenattacked[type] = false;
	
	level.vehicle_aianims[type] = setanims();

	
	

	
	


}

init_local()
{
	
}

#using_animtree ("tank");
set_vehicle_anims(positions)
{

	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	return positions;
}

