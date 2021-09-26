#include maps\_tank;
#using_animtree ("vehicles");
main(model)
{
	level.vehicleInitThread["buffalo"][model] = ::init_local;

	switch(model)	
	{
		case "xmodel/vehicle_ltv4_buffalo":
			precachemodel("xmodel/vehicle_ltv4_buffalo");
			precachemodel("xmodel/vehicle_ltv4_buffalo_d");
			level.deathmodel[model] = "xmodel/vehicle_ltv4_buffalo_d";
			level.deathfx[model] = loadfx ("fx/explosions/large_vehicle_explosion.efx");
			break;

	}	
	precachevehicle("buffalo");

	// these next 3 lines might now work so well
	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %german_armored_car_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;

	level._vehicle_door_jumpout_tag[model] = "ramp_open";
	level._vehicle_door_jumpout_anim[model] = %american_buffalo_backgatedown;

	level.vehiclefireanim[model] = %american_buffalo_30_cal_fire_cycle;
	level.vehiclefireanim_settle[model] = %american_buffalo_30_cal_settle;
	
//	level._effect[model+"damaged_vehicle_smoke"] = loadfx("fx/smoke/damaged_vehicle_smoke.efx"); //loadfx("fx/smoke/damaged_vehicle_smoke.efx");
//	level._effect[model+"tank_fire_turret"] = loadfx("fx/fire/armoredcar_fire_turret_large.efx");

	level.deathfx_extra[model]["loop"] = loadfx ("fx/fire/tank_fire_libya_distant.efx");
	level.deathfx_extra[model]["tag"] = "tag_firefx";
	level.deathfx_extra[model]["delay"] = 1;

	level.vehicletypefancy["buffalo"] = &"VEHICLENAME_BUFFALO";

	maps\_treadfx::main("buffalo");
	return true;
}
#using_animtree ("generic_human");

init_local()
{
	if (!isdefined (self.script_team))
		maps\_tank::setteam("allies");
//	self.rumbleon = false;
	self.rumble_scale = 0.035;
	self.rumble_duration = 2.5;
	self.rumble_radius = 600;
	self.rumble_basetime = 1;
	self.rumble_randomaditionaltime = .25;
	life();
	
	if(!isdefined(self.script_nomg) || self.script_nomg == 0)
	{
//		self.mgturret[0] = spawnTurret("misc_turret", (0,0,0), "mg42_bipod_stand");
		self.mgturret[0] = spawnTurret("misc_turret", (0,0,0), "30cal_stand");

		if (self.script_team == "axis")
			self.mgturret[0] setturretteam("axis");
		else
			self.mgturret[0] setturretteam("allies");
		if(isdefined(self.script_fireondrones))
			self.mgturret[0].script_fireondrones = self.script_fireondrones;
		self.mgturret[0] thread maps\_mg42::mg42_target_drones(true,self.script_team);
		self.mgturret[0] linkto(self, "tag_ai_30cal", (0, 0, -16), (0, 0, 0));
		self.mgturret[0].angles = self.angles;
		self.mgturret[0] setmode("auto_nonai");
//		self.mgturret[0] setmodel("xmodel/weapon_mg42");
		self.mgturret[0] setmodel("xmodel/weapon_30cal");
		self.mgturret[0] maketurretunusable();
		level thread maps\_mg42::mg42_setdifficulty(self.mgturret[0],getdifficulty());
		self.mgturret[0] setshadowhint ("never");
	}

	positions[0]["getoutanim"] = maps\_halftrack::randomjumpout();
	positions[1]["getoutanim"] = maps\_halftrack::randomjumpout();  // mggunner
//	positions[2]["getoutanim"] = %halftrack_guy03_jumpout;
//	positions[3]["getoutanim"] = %halftrack_guy05_jumpout;
	positions[2]["getoutanim"] = maps\_halftrack::randomjumpout();
	positions[3]["getoutanim"] = maps\_halftrack::randomjumpout();
	positions[4]["getoutanim"] = maps\_halftrack::randomjumpout();
	positions[5]["getoutanim"] = maps\_halftrack::randomjumpout();
	positions[6]["getoutanim"] = maps\_halftrack::randomjumpout();
	positions[7]["getoutanim"] = maps\_halftrack::randomjumpout();
	positions[8]["getoutanim"] = maps\_halftrack::randomjumpout();
	
/*	positions[0]["idleanim"] = %halftrack_driver_idle;
	positions[1]["idleanim"] = %halftrack_MGgunner_idle;
	positions[2]["idleanim"] = %halftrack_guy03_idle;
	positions[3]["idleanim"] = %halftrack_guy05_idle;
	positions[4]["idleanim"] = %halftrack_guy06_idle;
	positions[5]["idleanim"] = %halftrack_guy04_idle;
	positions[6]["idleanim"] = %halftrack_guy01_idle;
	positions[7]["idleanim"] = %halftrack_guy02_idle;
	positions[8]["idleanim"] = %halftrack_passenger_idle;
*/
	positions[0]["idleanim"] = %higginsboat_medic_idle;
	positions[1]["idleanim"] = %higginsboat_ranger1_idle;
	positions[2]["idleanim"] = %higginsboat_ranger1_idle;
	positions[3]["idleanim"] = %higginsboat_ranger1_idle;
	positions[4]["idleanim"] = %higginsboat_rangerL_idle;
	positions[5]["idleanim"] = %higginsboat_ranger1_idle;
	positions[6]["idleanim"] = %higginsboat_ranger1_idle;
	positions[7]["idleanim"] = %higginsboat_ranger1_headdown_idle;
	positions[8]["idleanim"] = %higginsboat_rangerL_idle;
		
	positions[0]["deathanim"] = %death_stand_dropinplace;
	positions[1]["deathanim"] = %death_stand_dropinplace;
	positions[2]["deathanim"] = %death_stand_dropinplace;
	positions[3]["deathanim"] = %death_stand_dropinplace;
	positions[4]["deathanim"] = %death_stand_dropinplace;
	positions[5]["deathanim"] = %death_stand_dropinplace;
	positions[6]["deathanim"] = %death_stand_dropinplace;
	positions[7]["deathanim"] = %death_stand_dropinplace;
	positions[8]["deathanim"] = %death_stand_dropinplace;
	
	positions[0]["exittag"] = "tag_out";
	positions[1]["exittag"] = "tag_out";
	positions[2]["exittag"] = "tag_out";
	positions[3]["exittag"] = "tag_out";
	positions[4]["exittag"] = "tag_out";
	positions[5]["exittag"] = "tag_out";
	positions[6]["exittag"] = "tag_out";
	positions[7]["exittag"] = "tag_out";
	positions[8]["exittag"] = "tag_out";
	
	positions[0]["idletag"] = "tag_guy1";
	positions[1]["idletag"] = "tag_MGguy";
	positions[2]["idletag"] = "tag_guy3";
	positions[3]["idletag"] = "tag_guy4";
	positions[4]["idletag"] = "tag_guy5";
	positions[5]["idletag"] = "tag_guy6";
	positions[6]["idletag"] = "tag_guy7";
	positions[7]["idletag"] = "tag_guy8";
	positions[8]["idletag"] = "tag_guy9";
	self thread maps\_halftrack::handle_attached_guys(positions);

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
