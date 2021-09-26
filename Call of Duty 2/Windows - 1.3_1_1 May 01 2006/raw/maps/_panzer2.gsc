#include maps\_tank;
#using_animtree ("tank");

main(model)
{
	level.vehicleInitThread["panzer2"][model] = ::init_local;
	switch(model)	
	{
		case "xmodel/vehicle_panzer_ii":
			precachemodel("xmodel/vehicle_panzer_ii");
			precachemodel("xmodel/vehicle_panzer_ii_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_panzer_ii_destroyed";
			level.deathfx[model] = loadfx("fx/explosions/panzer_explosion.efx");
			break;

		case "xmodel/vehicle_panzer_ii_winter":
			precachemodel("xmodel/vehicle_panzer_ii_winter");
			precachemodel("xmodel/vehicle_panzer_ii_winter_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_panzer_ii_winter_destroyed";
			level.deathfx[model] = loadfx("fx/explosions/panzer_explosion.efx");
			break;

		case "xmodel/vehicle_panzer_II_winter_r_tread_d":
			precachemodel("xmodel/vehicle_panzer_II_winter_r_tread_d");
			precachemodel("xmodel/vehicle_panzer_ii_winter_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_panzer_ii_winter_destroyed";
			level.deathfx[model] = loadfx("fx/explosions/panzer_explosion.efx");
			break;

		case "xmodel/vehicle_panzer_II_winter_l_tread_d":
			precachemodel("xmodel/vehicle_panzer_II_winter_l_tread_d");
			precachemodel("xmodel/vehicle_panzer_ii_winter_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_panzer_ii_winter_destroyed";
			level.deathfx[model] = loadfx("fx/explosions/panzer_explosion.efx");
			break;
	}
	

	precacheModel("xmodel/weapon_machinegun_panzer2");
	precachevehicle("panzer2");
	precacheturret("mg42_tank_panzer2");

	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %german_panzer_2_tank_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;

	level.TankopenHatch_anim_pose[model] = %tigertank_hatch_open;
//	level.TankopenHatch_anim_animate[model] = %tigertank_hatchopencloseandrun_hatch;
	level.TankopenHatch_Pose[model] = ::openHatch_Pose;
	level.TankcloseHatch_Animated[model] = ::closeHatch_Animated;
		
	level._effect[model+"damaged_vehicle_smoke"] = loadfx("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect[model+"tank_fire_turret"] = loadfx("fx/fire/panzer2_fire_turret_small.efx");
	level._effect[model+"tank_fire_engine"] = loadfx("fx/fire/tank_fire_engine.efx");
	level.damagefiretag[model] = [];
	level.damagefiretag[model][level.damagefiretag[model].size] = "tag_engine_left";
	
	maps\_treadfx::main("panzer2");
	return true;
}

#using_animtree( "tiger" );
init_local()
{
	if (!isdefined (self.script_team))
		maps\_tank::setteam("axis");
	self.frontarmorregen = .66; // percentage of damage to regenerate for attacks from the front
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

