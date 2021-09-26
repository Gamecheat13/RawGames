mginit ()

{
	if( (isdefined(self.script_nomg)) && (self.script_nomg > 0) )
		return;
		
	switch(self.vehicletype)
	{
		case "tiger":
			self.mgturret[0] = spawnTurret("misc_turret", (0,0,0), "mg42_tank_tiger");
			self.mgturret[0] linkto(self, "tag_turret2", (0, 0, 0), (0, 0, 0));
			self.mgturret[0] setmodel("xmodel/weapon_machinegun_tiger");
			break;
		case "crusader":
		case "crusader_player":
			self.mgturret[0] = spawnTurret("misc_turret", (0,0,0), "mg42_tank_crusader");
			self.mgturret[0] linkto(self, "tag_turret3", (0, 0, 0), (0, 0, 0));
			self.mgturret[0] setmodel("xmodel/weapon_machinegun_crusader2");
			if(isdefined(self.script_noteworthy) && self.script_noteworthy == "onemg")
				break;
			self.mgturret[1] = spawnTurret("misc_turret", (0,0,0), "mg42_tank_crusader");
			self.mgturret[1] linkto(self, "tag_turret2", (0, 0, 0), (0, 0, 0));
			self.mgturret[1] setmodel("xmodel/weapon_miniturret_crusader2");
			break;
		case "panzer2":
			self.mgturret[0] = spawnTurret("misc_turret", (0,0,0), "mg42_tank_panzer2");
			self.mgturret[0] linkto(self, "tag_turret2", (0, 0, 0), (0, 0, 0));
			self.mgturret[0] setmodel("xmodel/weapon_machinegun_panzer2");
			break;
		case "sherman":
			if (self.model == "xmodel/vehicle_american_sherman_desert")
				return;
			self.mgturret[0] = spawnTurret("misc_turret", (0,0,0), "mg42_tank_crusader");
			self.mgturret[0] linkto(self, "tag_turret2", (0, 0, 0), (0, 0, 0));
			self.mgturret[0] setmodel("xmodel/vehicle_sherman__tank_machinegun");
			break;
		default:
			return;
	}
	for (i=0;i<self.mgturret.size;i++)
	{
		self.mgturret[i].angles = self.angles;
		self.mgturret[i] thread maps\_mg42::burst_fire_unmanned();
		self.mgturret[i] maketurretunusable();
		level thread maps\_mg42::mg42_setdifficulty(self.mgturret[i],getdifficulty());
		if(isdefined(self.script_fireondrones))
			self.mgturret[i].script_fireondrones = self.script_fireondrones;
		self.mgturret[i] thread maps\_mg42::mg42_target_drones(true,self.script_team);
		self.mgturret[i].convergencetime = 4;
		self.mgturret[i] setshadowhint ("never");
		
	}
	
	if ( isdefined (self.script_turretmg) && self.script_turretmg == 0 )
	{
		self thread mgoff();
	}
	else
	{
		self.script_turretmg = 1;
		self thread mgon();
	}
	self thread mgtoggle();
}

mgtoggle()
{
	self endon ("death");
	if(self.script_turretmg)
		lasttoggle = 1;
	else
		lasttoggle = 0;
	while(1)
	{
		if(lasttoggle != self.script_turretmg)
		{
			lasttoggle = self.script_turretmg;
			if(self.script_turretmg)
				self thread mgon();
			else
				self thread mgoff();
		}
		wait .5;
	}
}

mgoff ()
{
	self.script_turretmg = 0;  // fix me.. defense for scripts using maps\_tankgun::mgoff();
	if (isdefined (self.mgturret))
		for (i=0;i<self.mgturret.size;i++)
		{
			if(isdefined(self.mgturret[i].script_fireondrones))
				self.mgturret[i].script_fireondrones = false;
			self.mgturret[i] setmode("manual");
		}
}

mgon ()
{
	self.script_turretmg = 1; // fix me.. defense for scripts using maps\_tankgun::mgon();
	if (!isdefined (self.mgturret))
		return;
	for (i=0;i<self.mgturret.size;i++)
	{
		if(isdefined(self.mgturret[i].script_fireondrones))
			self.mgturret[i].script_fireondrones = true;
		self.mgturret[i] setmode("auto_nonai");
		if ( (self.script_team == "allies") || (self.script_team == "friendly") )
			self.mgturret[i] setTurretTeam("allies");
		else if ( (self.script_team == "axis") || (self.script_team == "enemy") )
			self.mgturret[i] setTurretTeam("axis");
	}
}