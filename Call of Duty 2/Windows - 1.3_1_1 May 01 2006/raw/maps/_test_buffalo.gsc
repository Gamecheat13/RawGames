#using_animtree ("generic_human");
main(model)
{
	level.vehicleInitThread["test_buffalo"][model] = ::init;

	switch(model)	
	{
		case "xmodel/vehicle_german_armored_car":
			precachemodel("xmodel/vehicle_german_armored_car");
			precachemodel("xmodel/vehicle_german_armored_car_d");
			level.deathmodel[model] = "xmodel/vehicle_german_armored_car_d";
			level.deathfx[model] = loadfx ("fx/explosions/tank_explosion.efx");
			break;

	}	
	precachevehicle("armoredcar");


	level._effect[model+"damaged_vehicle_smoke"] = loadfx("fx/smoke/damaged_vehicle_smoke.efx"); //loadfx("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect[model+"tank_fire_turret"] = loadfx("fx/fire/armoredcar_fire_turret_large.efx");

	level.vehicletypefancy["test_buffalo"] = "Armored Car";

	//precacheturret("mg42_tank_crusader");
	//loadfx("fx/explosions/tank_explosion.efx");
	maps\_treadfx::main("armoredcar");
	
	//level._effect["tank_enginesmoke"]["crusader"] = loadfx("fx/smoke/thin_light_smoke_S.efx");
	return true;
}

#using_animtree( "tiger" );
init()
{
	if (!isdefined (self.script_team))
		maps\_tank::setteam("allies");
	self useAnimTree( #animtree );
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

kill()
{
	thread maps\_tank::kill();
	self waittill ("tankkilled");
}

shoot()
{
	while(self.health > 0)
	{
		self waittill( "turret_fire" );
		self fire();
	}
}

fire()
{
	if(self.health <= 0)
		return;

	// fire the turret
	self FireTurret();

	// play the fire animation
	//self setAnimKnobRestart( %PanzerIV_fire );
}
