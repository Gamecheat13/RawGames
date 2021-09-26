#include maps\_tank;
#using_animtree ("tank");
main(model)
{
	level.vehicleInitThread["sherman"][model] = ::init_local;
	switch(model)	
	{
		case "xmodel/vehicle_american_sherman":
			precachemodel("xmodel/vehicle_american_sherman");
			precachemodel("xmodel/vehicle_american_sherman_d");
			level.deathmodel[model] = "xmodel/vehicle_american_sherman_d";
			level.deathfx[model] = loadfx ("fx/explosions/large_vehicle_explosion.efx");
			break;
		case "xmodel/vehicle_american_sherman_desert":
			precachemodel("xmodel/vehicle_american_sherman_desert");
			precachemodel("xmodel/vehicle_american_sherman_desert_d");
			level.deathmodel[model] = "xmodel/vehicle_american_sherman_desert_d";
			level.deathfx[model] = loadfx ("fx/explosions/large_vehicle_explosion.efx");
			break;
	}
	
	precacheModel("xmodel/vehicle_sherman__tank_machinegun");
	precachevehicle("sherman");
	precacheturret("mg42_tank_crusader");

	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %american_sherman_tank_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;
		
	level.TankopenHatch_anim_pose[model] = %tigertank_hatch_open;
//	level.TankopenHatch_anim_animate[model] = %tigertank_hatchopencloseandrun_hatch;
	level.TankopenHatch_Pose[model] = ::openHatch_Pose;
	level.TankcloseHatch_Animated[model] = ::closeHatch_Animated;

	level._effect[model+"damaged_vehicle_smoke"] = loadfx("fx/smoke/damaged_vehicle_smoke.efx"); //loadfx("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect[model+"tank_fire_turret"] = loadfx("fx/fire/sherman_fire_turret_large.efx");
	level._effect[model+"tank_fire_engine"] = loadfx("fx/fire/tank_fire_engine.efx");
	level.damagefiretag[model] = [];
	level.damagefiretag[model][level.damagefiretag[model].size] = "tag_right_wheel_03";
	level.damagefiretag[model][level.damagefiretag[model].size] = "tag_left_wheel_05";
	
	level.vehicletypefancy["sherman"] = &"VEHICLENAME_SHERMAN_TANK";

	maps\_treadfx::main("sherman");
	return true;
}

init_local()
{
	if (!isdefined (self.script_team))
		maps\_tank::setteam("allies");
	self.frontarmorregen = .33;  // percentage of damage to regenerate for attacks from the front
	life();
	thread kill();
	thread init();
	thread shoot();
}

life()
{
	if (isdefined (self.script_startinghealth))
		self.health = self.script_startinghealth;
	else
		self.health  = (randomint(1000)+500);
}
