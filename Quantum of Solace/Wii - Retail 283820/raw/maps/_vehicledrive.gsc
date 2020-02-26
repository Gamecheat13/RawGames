main()
{
	if (getdvar("debug_vehiclegod") == "")
		setdvar("debug_vehiclegod", "off");
	if (getdvar("debug_vehicleplayerhealth") == "")
		setdvar("debug_vehicleplayerhealth", "off");
	if (getdvar("player_vehicle_dismountable") == "")
		setdvar("player_vehicle_dismountable", "off");
	
	
}

vehicle_wait(startinvehicle)
{
	if(!isdefined(startinvehicle))
	{
		startinvehicle = false;
	}

	if(getdvar("player_vehicle_dismountable") == "off")
	{
		self makevehicleunusable();
	}

	self endon ("death");
	self endon ("stop_vehicle_wait");

	while (self.health > 0)
	{
		if(!startinvehicle)
		{
		 	self waittill("trigger");
		}
		else
		{
			startinvehicle = false;
			self useby(level.player);
		}
			
		owner = self GetVehicleOwner();
		if(IsDefined(owner) && (owner == level.player))
		{
			self vehicle_enter();
		}
		else
		{
			self vehicle_exit();
		}

		
		
		
	}
}

vehicle_exit()
{
	level.playervehicle = level.playervehiclenone;
	level notify("player exited vehicle");

	
	level.player DisableInvulnerability();
	setDvar("ui_hud_showstanceicon","1");

	
	
	

	if(isdefined(level.player.oldthreatbias))
	{
		level.player.threatbias = level.player.oldthreatbias;
		level.player.oldthreatbias = undefined;
	}

	if (isdefined (level.vehicleHUD))
		level.vehicleHUD destroy();
	if (isdefined (level.vehicleHUD2))
		level.vehicleHUD2 destroy();
	if (isdefined (level.VehicleFireIcon))
		level.VehicleFireIcon destroy();
}

vehicle_enter()
{
	level.playervehicle = self;
	self setPlayerControlled(true);	

	self thread vehicle_ridehandle();

	self notify("player entered vehicle");
	level notify("player entered vehicle");

	
	self thread bond_veh_drive_health();

	
	level.player EnableInvulnerability();
	setDvar("ui_hud_showstanceicon","0");

	
	
	

	level thread maps\_vehicle::gopath(self);
	


}






setup_vehicle()
{
	self vehicle_giveHealth();
}

vehicle_giveHealth()
{
	
	skill = getdifficulty();
	
	if(skill == ("Civilian"))
		self.health  = 3000;
	else if(skill == ("New Recruit"))
		self.health = 2500;
	else if(skill == ("Agent"))
		self.health = 2000;
	else if(skill == ("Double-Oh"))
		self.health = 1300;
	else
		self.health = 2000;

	if(isdefined(self.healthbuffer))
	{
		self.health += self.healthbuffer;  
		self.currenthealth = self.health;
		self.maxhealth = self.health;
		
	}
}




































vehicle_ridehandle()
{
	level endon ("player exited vehicle");
	self endon ("no_regen_health");
	self endon ("death");
	



	
	self.maximumhealth = self.health / 2;	
	
	switch(getdifficulty())
	{
		case "gimp":
		health_regeninc = 50;
		health_regentimer = 2700;
		break;
		case "Civilian":
		health_regeninc = 40;
		health_regentimer = 2700;
		break;
		case "New Recruit":
		health_regeninc = 30;
		health_regentimer = 2700;
		break;
		case "Agent":
		health_regeninc = 20;
		health_regentimer = 3700;
		break;
		case "Double-Oh":
		health_regeninc = 10;
		health_regentimer = 4700;
		break;
		default:
		health_regeninc = 30;
		health_regentimer = 2700;
		break;
		
	}
	if(self.vehicletype == "crusader_player")
	{
		self setmodel ("vehicle_crusader2_viewmodel");
	}

	regentimer = gettime();
	if (getdvar("debug_vehiclegod") != "off")
	{
		while(1)
		{
			self waittill ("damage");
			self.health = self.maximumhealth;
		}
	}

	self waittill("damage");
	thread vehicle_damageset();
	regeninctimer = gettime();
	while(1)
	{
		if(self.damaged)
		{
			if(getdvar("debug_vehicleplayerhealth") != "off")
				iprintlnbold("playervehicles health: ", self.health - self.healthbuffer);
			self.damaged = false;
			regentimer = gettime() + health_regentimer;
		}
		
		time = gettime();
		if(((self.currenthealth / 4) < self.maximumhealth) && (time > regentimer) && (time > regeninctimer))
		{
			if((self.currenthealth + health_regeninc) > self.maximumhealth)
				self.currenthealth = self.maximumhealth;
			else
				self.currenthealth += health_regeninc;

			update_health();

			regeninctimer = gettime() + 250 * 3;
			if(getdvar("debug_vehicleplayerhealth") != "off")
				iprintlnbold("playervehicles health: ", self.health-self.healthbuffer);
		}
			
		wait .05;
	}
}

vehicle_kill_player_ondeath()
{
	level endon ("player exited vehicle");
	self waittill ("death");
	level.player enablehealthshield(false);
	while(1)
	{
		level.player DoDamage ( level.player.health + 500, level.player.origin );
		wait .1;		
	}
	wait .5;
	level.player enablehealthshield(true);
}

vehicle_damageset()
{
	self.damaged = false;
	self endon ("death");
	while(1)
	{
		self waittill ("damage",ammount);
		println("damage ",ammount);
		self.damaged = true;
	}
}

vehicle_reloadsound()
{
	while (1)
	{
		self waittill ("turret_fire");
		wait .5;
		self playsound ("tank_reload");
	}	
}

vehicle_hud_tank_fireicon()
{
	if(getdvar("player_vehicle_dismountable") != "off")
		return;
	level endon ("player exited vehicle");
	level.player endon ("death");
	self endon ("death");
	if (isdefined (level.VehicleFireIcon))
		level.VehicleFireIcon destroy();
	
	level.VehicleFireIcon = newHudElem();
	level.VehicleFireIcon.x = -32;
	level.VehicleFireIcon.y = -64;
	level.VehicleFireIcon.alignX = "center";
	level.VehicleFireIcon.alignY = "middle";
	level.VehicleFireIcon.horzAlign = "right";
	level.VehicleFireIcon.vertAlign = "bottom";
	level.VehicleFireIcon setShader("tank_shell", 64, 64);
	
	icon = true;
	level.VehicleFireIcon.alpha = icon;
	while (1)
	{
		if(icon)
		{
			if(!self isTurretReady())
			{
				icon = false;
				level.VehicleFireIcon.alpha = icon;
			}
		}
		else
		{
			if(self isTurretReady())
			{
				icon = true;
				level.VehicleFireIcon.alpha = icon;
			}
			
		}
		wait .05;
	}
}


healthOverlay()
{
	self endon ("death");
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ("overlay_low_health", 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;


	maxHealth = self.health-self.healthbuffer;
	hurt = false;
	bonus = 0.3;
	for (;;)
	{
		healthRatio = (self.health-self.healthbuffer) / maxHealth;
		pulseTime = 0.5 + (0.5 * healthRatio);
		if (healthRatio < 0.75 || hurt)
		{
			if (!hurt)
			{
				hurt = true;
			}

			fullAlpha = (1.0 - healthRatio) + bonus;
			
			overlay fadeOverTime(0.05);
			overlay.alpha = fullAlpha;
			wait (0.1);
			overlay fadeOverTime(pulseTime*0.2);
			overlay.alpha = fullAlpha * 0.5;
			wait (pulseTime*0.2);
			overlay fadeOverTime(pulseTime*0.3);
			overlay.alpha = fullAlpha * 0.3;
			wait (pulseTime*0.3);


			healthRatio = (self.health-self.healthbuffer) / maxHealth;
			pulseTime = 0.3 + (0.7 * healthRatio);
			if (healthRatio > 0.9)
			{
				hurt = false;
				overlay fadeOverTime(0.5);
				overlay.alpha = 0;
				wait (pulseTime*0.5) - 0.1;
			}
			else
				wait (pulseTime*0.5) - 0.1;
		}
		else
			wait (0.05);
	}
}







bond_veh_drive_health()
{
	level endon("player exited vehicle");

	if (!IsDefined(level.player_veh_damage_hud))
	{
		level.player_veh_damage_hud = newHudElem();
		level.player_veh_damage_hud.x = 0;
		level.player_veh_damage_hud.y = 180;
		level.player_veh_damage_hud.horzAlign = "left";
		level.player_veh_damage_hud.vertAlign = "middle";
		level.player_veh_damage_hud.width = 200;
		level.player_veh_damage_hud.height = 20;
		level.player_veh_damage_hud SetShader("white", level.player_veh_damage_hud.width, level.player_veh_damage_hud.height);
		level.player_veh_damage_hud.alpha = 1;
	}

	if (!IsDefined(level.player_veh_damage_hud_text))
	{
		level.player_veh_damage_hud_text = newHudElem();
		level.player_veh_damage_hud_text.x = 0;
		level.player_veh_damage_hud_text.y = 165;
		level.player_veh_damage_hud_text.horzAlign = "left";
		level.player_veh_damage_hud_text.vertAlign = "middle";
		level.player_veh_damage_hud_text.alpha = 1;
	}

	self.currenthealth = self.health;
	level.player_veh_damage_hud_text SetText("Vehicle Health: " + self.currenthealth);

	while (self.currenthealth > 0)
	{
		self waittill("damage", damage);
		if (IsDefined(damage))
		{
			self.currenthealth -= damage;

			if (self.currenthealth < 0)
			{
				self.currenthealth = 0;
			}

			update_health();
		}
		else
		{
			assertmsg("damage amount is undefined");
		}
	}

	self notify("death");
}

update_health()
{
	level.player_veh_damage_hud_text SetText("Vehicle Health: " + self.currenthealth);
	scale = level.player_veh_damage_hud.width / self.health;
	bar = int(self.currenthealth * scale);
	if (bar < 1)
	{
		bar = 1;
	}
	level.player_veh_damage_hud SetShader("white", bar, level.player_veh_damage_hud.height);
}