#include maps\_tank;
#using_animtree ("tank");
main(model)
{
	level.vehicleInitThread["crusader"][model] = ::init_local;

	switch(model)	
	{
		case "xmodel/vehicle_crusader2":
			precachemodel("xmodel/vehicle_crusader2");
			precachemodel("xmodel/vehicle_crusader2_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_crusader2_destroyed";
			level.deathfx[model] = loadfx ("fx/explosions/tank_explosion.efx");
			break;
		case "xmodel/vehicle_crusader2_viewmodel":
			precachemodel("xmodel/vehicle_crusader2_viewmodel");
			precachemodel("xmodel/vehicle_crusader2_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_crusader2_destroyed";
			level.deathfx[model] = loadfx ("fx/explosions/tank_explosion_libya_view.efx");
			break;
	}
	
	precacheModel("xmodel/weapon_machinegun_crusader2");
	precacheModel("xmodel/weapon_miniturret_crusader2");
	precachevehicle("crusader");
	precacheturret("mg42_tank_crusader");
	
	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %british_crusader_tank_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;

	level.TankopenHatch_anim_pose[model] = %tigertank_hatch_open;
//	level.TankopenHatch_anim_animate[model] = %tigertank_hatchopencloseandrun_hatch;
	level.TankopenHatch_Pose[model] = ::openHatch_Pose;
	level.TankcloseHatch_Animated[model] = ::closeHatch_Animated;

	level._effect[model+"damaged_vehicle_smoke"] = loadfx("fx/smoke/damaged_vehicle_smoke.efx"); //loadfx("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect[model+"tank_fire_turret"] = loadfx("fx/fire/crusader_fire_turret_large.efx");
	level._effect[model+"tank_fire_engine"] = loadfx("fx/fire/tank_fire_engine.efx");
	level.damagefiretag[model] = [];
	level.damagefiretag[model][level.damagefiretag[model].size] = "tag_right_wheel_03";
	level.damagefiretag[model][level.damagefiretag[model].size] = "tag_left_wheel_05";
	
	level.vehicletypefancy["crusader"] = &"VEHICLENAME_CRUSADER_TANK";

	maps\_treadfx::main("crusader");
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

