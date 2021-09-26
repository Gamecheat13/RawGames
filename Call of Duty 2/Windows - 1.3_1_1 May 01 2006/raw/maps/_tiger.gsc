#include maps\_tank;
#using_animtree ("tank");

main(model)
{
	level.vehicleInitThread["tiger"][model] = ::init_local;
	switch(model)	
	{
		case "xmodel/vehicle_tiger_woodland":
			precachemodel ("xmodel/vehicle_tiger_woodland");
			precachemodel ("xmodel/vehicle_tiger_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_tiger_woodland_d";
			level.deathfx[model] = loadfx("fx/explosions/tiger_explosion.efx");
			break;
		case "xmodel/vehicle_tiger_lefttread_d":
			precachemodel ("xmodel/vehicle_tiger_lefttread_d");
			precachemodel ("xmodel/vehicle_tiger_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_tiger_woodland_d";
			level.deathfx[model] = loadfx("fx/explosions/tiger_explosion.efx");
			break;
		case "xmodel/vehicle_tiger_righttread_d":
			precachemodel ("xmodel/vehicle_tiger_righttread_d");
			precachemodel ("xmodel/vehicle_tiger_woodland_d");
			level.deathmodel[model] = "xmodel/vehicle_tiger_woodland_d";
			level.deathfx[model] = loadfx("fx/explosions/tiger_explosion.efx");
			break;
		case "xmodel/vehicle_tiger_woodland_brush":
			precachemodel ("xmodel/vehicle_tiger_woodland_brush");
			precachemodel ("xmodel/vehicle_tiger_woodland_d_brush");
			level.deathmodel[model] = "xmodel/vehicle_tiger_woodland_d_brush";
			level.deathfx[model] = loadfx("fx/explosions/tiger_explosion.efx");
			break;

	}
	precacheModel("xmodel/weapon_machinegun_tiger");
	precachevehicle("tiger");
	precacheturret("mg42_tank_tiger");

	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %german_tiger_tank_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;

	level.TankopenHatch_anim_pose[model] = %tigertank_hatch_open;
//	level.TankopenHatch_anim_animate[model] = %tigertank_hatchopencloseandrun_hatch;
	level.TankopenHatch_Pose[model] = ::openHatch_Pose;
	level.TankcloseHatch_Animated[model] = ::closeHatch_Animated;

	level._effect[model+"damaged_vehicle_smoke"] = loadfx("fx/smoke/damaged_vehicle_smoke.efx"); //loadfx("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect[model+"tank_fire_turret"] = loadfx("fx/fire/tiger_fire_turret_large.efx");
	level._effect[model+"tank_fire_engine"] = loadfx("fx/fire/tank_fire_engine.efx");
	level.damagefiretag[model] = [];
	level.damagefiretag[model][level.damagefiretag[model].size] = "tag_engine_right";
	level.damagefiretag[model][level.damagefiretag[model].size] = "hatch_open";
		
	maps\_treadfx::main("tiger");
	return true;
}

init_local()
{
	maps\_tank::setteam("axis");
	self.frontarmorregen = .33; // percentage of damage to regenerate for attacks from the front
	life();
	thread kill();
	thread maps\_tank::init();
	thread shoot();
}

life()
{
	if (isdefined (self.script_startinghealth))
		self.health = self.script_startinghealth;
	else
		self.health  = (randomint(1000)+500);
}


