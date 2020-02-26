mginit(optionalTurret)
{
	if (isdefined (optionalTurret))
		self.mgturret = spawnTurret("misc_turret", (0,0,0), optionalTurret);
	else
		self.mgturret = spawnTurret("misc_turret", (0,0,0), "mg42_panzerIV_tank");

	self.mgturret setmodel("xmodel/vehicle_tank_panzeriv_machinegun");
	self.mgturret linkto(self, "tag_turret2", (0, 0, 0), (0, 0, 0));
	self.mgturret.angles = self.angles;
	self.mgturret.angles = self.angles;
	self.mgturret thread maps\_mg42::burst_fire_unmanned();
	self.mgturret maketurretunusable();
	mgon();
}

mgoff()
{
	self.mgturret setmode("manual");

}

mgon()
{

	self.mgturret setmode("auto_nonai");
	if(!isdefined(self.script_team)) // player tank
		self.mgturret setTurretTeam("allies");
	else
		self.mgturret setTurretTeam(self.script_team);
}