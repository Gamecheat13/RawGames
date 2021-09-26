#using_animtree ("vehicles");
main(model)
{
	level.vehicleInitThread["armoredcar"][model] = ::init_local;

	switch(model)	
	{
		case "xmodel/vehicle_german_armored_car":
			precachemodel("xmodel/vehicle_german_armored_car");
			precachemodel("xmodel/vehicle_german_armored_car_d");
			level.deathmodel[model] = "xmodel/vehicle_german_armored_car_d";
			level.deathfx[model] = loadfx ("fx/explosions/armoredcar_explosion.efx");
			break;

	}	
	precachevehicle("armoredcar");

	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %german_armored_car_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;
	
	level._effect[model+"damaged_vehicle_smoke"] = loadfx("fx/smoke/damaged_vehicle_smoke.efx"); //loadfx("fx/smoke/damaged_vehicle_smoke.efx");
	level._effect[model+"tank_fire_turret"] = loadfx("fx/fire/armoredcar_fire_turret_large.efx");
	
	level._effect["armored_car_overheat"] = loadfx("fx/distortion/armored_car_overheat.efx");
	
	level.vehicletypefancy["armoredcar"] = &"VEHICLENAME_ARMORED_CAR";

	maps\_treadfx::main("armoredcar");
	
	//overhead stuff
	level.armoredCarOverheat = false;
	level.armoredcar_heat_status = 1;
	level.armoredcar_heat_max = 114;
	level.armoredcar_heat_maxshots = 15;
	level.armoredcar_cooldownrate = 25;
	precacheShader("white");
	precacheShader("black");
	precacheShader("hud_temperature_gauge");
	
	return true;
}

init_local()
{
	if (!isdefined (self.script_team))
		maps\_tank::setteam("allies");
	life();
	thread maps\_tank::kill();
	thread maps\_tank::init();
	thread armoredcar_shoot();
}

life()
{
	if (isdefined (self.script_startinghealth))
		self.health = self.script_startinghealth;
	else
		self.health  = (randomint(1000)+500);
}

armoredcar_shoot()
{		
	self endon ("death");
	while(self.health > 0)
	{
		self waittill( "turret_fire" );
		self FireTurret();
		if (level.armoredCarOverheat == true)
		{
			level.armoredcar_heat_status += int(level.armoredcar_heat_max / level.armoredcar_heat_maxshots);
			level overheat_overheated(self);
			level thread overheat_hud_update();
		}
	}
}

overheat_enable()
{
	level.armoredCarOverheat = true;
	level thread overheat_hud();
}

overheat_disable()
{
	level.armoredCarOverheat = false;
	level notify ("disable_overheat");
	level.savehere = undefined;
	
	waittillframeend;
	
	if (isdefined(level.overheat_bg))
		level.overheat_bg destroy();
	if (isdefined(level.overheat_status))
		level.overheat_status destroy();
	if (isdefined(level.overheat_status2))
		level.overheat_status2 destroy();
	if (isdefined(level.overheat_flashing))
		level.overheat_flashing destroy();
}

overheat_overheated(armoredCar)
{
	level endon ("disable_overheat");
	if (level.armoredcar_heat_status <= level.armoredcar_heat_max)
		return;
	
	level.savehere = false;
	armoredCar playsound("smokegrenade_explode_default");
	armoredCar thread overheat_fx();
	
	level.overheat_flashing.alpha = 1;
	level.overheat_status.alpha = 0;
	level.overheat_status2.alpha = 0;
	
	level notify ("stop_overheat_drain");
	level.armoredcar_heat_status = level.armoredcar_heat_max;
	thread overheat_hud_update();
	
	for (i=0;i<4;i++)
	{
		level.overheat_flashing fadeovertime(0.5);
		level.overheat_flashing.alpha = 0.5;
		wait 0.5;
		level.overheat_flashing fadeovertime(0.5);
		level.overheat_flashing.alpha = 1.0;
	}
	level.overheat_flashing fadeovertime(0.5);
	level.overheat_flashing.alpha = 0.0;
	level.overheat_status.alpha = 1;
	wait 0.5;
	
	thread overheat_hud_drain();
	
	wait 4;
	level.savehere = undefined;
	armoredCar notify("stop_overheatfx");
}

overheat_fx()
{
	level endon ("disable_overheat");
	self endon ("stop_overheatfx");
	for (;;)
	{
		playfxOnTag (level._effect["armored_car_overheat"], self, "tag_flash");
		wait .3;
	}
}

overheat_hud_update()
{
	level endon ("disable_overheat");
	level notify ("stop_overheat_drain");
	
	if (level.armoredcar_heat_status > 1)
		level.overheat_status.alpha = 1;
	
	if (isdefined(level.overheat_status2))
	{
		level.overheat_status2.alpha = 1;
		level.overheat_status2 setShader("white", 10, int(level.armoredcar_heat_status));
		level.overheat_status scaleovertime( 0.05, 10, int(level.armoredcar_heat_status));
	}
	
	//set color of bar
	overheat_setColor(level.armoredcar_heat_status);
	
	wait 0.05;
	if (isdefined(level.overheat_status2))
		level.overheat_status2.alpha = 0;
	if (level.armoredcar_heat_status < level.armoredcar_heat_max)
		thread overheat_hud_drain();
}

overheat_setColor(value, fadeTime)
{
	level endon ("disable_overheat");
	
	//define what colors to use
	color_cold = [];
	color_cold[0] = 1.0;
	color_cold[1] = 0.9;
	color_cold[2] = 0.0;
	color_warm = [];
	color_warm[0] = 1.0;
	color_warm[1] = 0.5;
	color_warm[2] = 0.0;
	color_hot = [];
	color_hot[0] = 0.9;
	color_hot[1] = 0.16;
	color_hot[2] = 0.0;
	
	//default color
	SetValue = [];
	SetValue[0] = color_cold[0];
	SetValue[1] = color_cold[1];
	SetValue[2] = color_cold[2];
	
	//define where the non blend points are
	cold = 0;
	warm = (level.armoredcar_heat_max / 2);
	hot = level.armoredcar_heat_max;
	
	iPercentage = undefined;
	difference = undefined;
	increment = undefined;
	
	if ( (value > cold) && (value <= warm) )
	{
		iPercentage = int(value * (100 / warm));
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_warm[colorIndex] - color_cold[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_cold[colorIndex] + (increment * iPercentage);
		}
	}
	else if ( (value > warm) && (value <= hot) )
	{
		iPercentage = int( (value - warm) * (100 / (hot - warm) ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_hot[colorIndex] - color_warm[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_warm[colorIndex] + (increment * iPercentage);
		}
	}
	
	if (isdefined(fadeTime))
		level.overheat_status fadeOverTime(fadeTime);
	
	level.overheat_status.color = (SetValue[0], SetValue[1], SetValue[2]);
	level.overheat_status2.color = (SetValue[0], SetValue[1], SetValue[2]);
}

overheat_hud_drain()
{
	level endon ("disable_overheat");
	level endon ("stop_overheat_drain");
	
	waitTime = 1.0;
	for (;;)
	{
		if (level.armoredcar_heat_status > 1)
			level.overheat_status.alpha = 1;
		
		value = level.armoredcar_heat_status - level.armoredcar_cooldownrate;
		thread overheat_status_rampdown(value, waitTime);
		if (value < 1)
			value = 1;
		level.overheat_status scaleovertime( waitTime, 10, int(value) );
		overheat_setColor(level.armoredcar_heat_status, waitTime);
		wait waitTime;
		
		if (level.armoredcar_heat_status <= 1)
			level.overheat_status.alpha = 0;
	}
}

overheat_status_rampdown(targetvalue, time)
{
	level endon ("disable_overheat");
	level endon ("stop_overheat_drain");
	
	frames = (20 * time);
	difference = (level.armoredcar_heat_status - targetvalue);
	frame_difference = (difference / frames);
	
	for (i=0;i<frames;i++)
	{
		level.armoredcar_heat_status -= frame_difference;
		if (level.armoredcar_heat_status < 1)
		{
			level.armoredcar_heat_status = 1;
			return;
		}
		wait 0.05;
	}
}

overheat_hud()
{
	level endon ("disable_overheat");
	if (!isdefined(level.overheat_bg))
	{
		level.overheat_bg = newhudelem();
		level.overheat_bg.alignX = "right";
		level.overheat_bg.alignY = "bottom";
		level.overheat_bg.horzAlign = "right";
		level.overheat_bg.vertAlign = "bottom";
		level.overheat_bg.x = 2;
		level.overheat_bg.y = -120;
		level.overheat_bg setShader("hud_temperature_gauge", 35, 150);
		level.overheat_bg.sort = 4;
	}
	
	barX = -10;
	barY = -152;
	
	//status bar
	if (!isdefined(level.overheat_status))
	{
		level.overheat_status = newhudelem();
		level.overheat_status.alignX = "right";
		level.overheat_status.alignY = "bottom";
		level.overheat_status.horzAlign = "right";
		level.overheat_status.vertAlign = "bottom";
		level.overheat_status.x = barX;
		level.overheat_status.y = barY;
		level.overheat_status setShader("white", 10, 0);
		level.overheat_status.color = (1,.9,0);
		level.overheat_status.alpha = 0;
		level.overheat_status.sort = 1;
	}
	
	//draw fake bar to cover up a hitch
	if (!isdefined(level.overheat_status2))
	{
		level.overheat_status2 = newhudelem();
		level.overheat_status2.alignX = "right";
		level.overheat_status2.alignY = "bottom";
		level.overheat_status2.horzAlign = "right";
		level.overheat_status2.vertAlign = "bottom";
		level.overheat_status2.x = barX;
		level.overheat_status2.y = barY;
		level.overheat_status2 setShader("white", 10, 1);
		level.overheat_status2.color = (1,.9,0);
		level.overheat_status2.alpha = 0;
		level.overheat_status.sort = 2;
	}
	
	if (!isdefined(level.overheat_flashing))
	{
		level.overheat_flashing = newhudelem();
		level.overheat_flashing.alignX = "right";
		level.overheat_flashing.alignY = "bottom";
		level.overheat_flashing.horzAlign = "right";
		level.overheat_flashing.vertAlign = "bottom";
		level.overheat_flashing.x = barX;
		level.overheat_flashing.y = barY;
		level.overheat_flashing setShader("white", 10, level.armoredcar_heat_max);
		level.overheat_flashing.color = (.8,.16,0);
		level.overheat_flashing.alpha = 0;
		level.overheat_status.sort = 3;
	}
}