#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main( model, type )
{
	if(!isdefined(type))
		type = "cobra";
	level.vehicleInitThread[type][model] = ::init_local;

	setParams( model, type );
}

setParams( model, type )
{
	deathfx = undefined;
	switch(model)	
	{
		case "vehicle_cobra_helicopter":
		case "vehicle_cobra_helicopter_fly":
			precachemodel("vehicle_cobra_helicopter");
			precachemodel("vehicle_cobra_helicopter");
			level.vehicle_deathmodel[model] = "vehicle_cobra_helicopter";
			deathfx = loadfx ("explosions/large_vehicle_explosion");
			break;
	}
	precachevehicle(type);
	
	level.vehicleanimtree[model] = #animtree;
	level.vehicle_DriveIdle[model] = %bh_rotors;
	level.vehicle_DriveIdle_normal_speed[model] = 0;  // 0 makes it animate even while idle.
	level.vehicle_DriveIdle_animrate[model]	= 3.0;

	// death fx stuff
	level.vehicle_death_fx[type] = [];
	effects = maps\_vehicle::build_deathfx(undefined,deathfx,undefined,"explo_metal_rand");
	level.vehicle_death_fx[type] = effects;

	maps\_treadfx::main(type);
	
	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	//set default team for this vehicletype
	level.vehicle_team[type] = "allies";	
	
	//enables turret
	level.vehicle_hasMainTurret[model] = true;	
}

init_local()
{
	self.delete_on_death = true;
	self.script_badplace = false; //All helicopters dont need to create bad places
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
	for(i=0;i<11;i++)
		positions[i] = spawnstruct();

	positions[0].getout_delete = true;
	return positions;
}

