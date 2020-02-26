#using_animtree("panzerflak");
main()
{
	maps\_utility::precache ("xmodel/vehicle_tank_flakpanzer_d");
	maps\_utility::precache ("xmodel/panzerflak_ammo");
	maps\_utility::precache ("xmodel/bomb");

    level._effect["flak_burst"] = loadfx ("fx/muzzleflashes/flaktemp.efx");
    level._effect["flak_burst_lite"] = loadfx ("fx/muzzleflashes/flaktemp_nolight.efx");
	script_models = getentarray ("script_model","classname");
	script_vehicles = getentarray ("script_vehicles","classname");
	for(i=0;i<script_vehicles.size;i++)
		maps\_utility::add_to_array ( script_models , script_vehicles[i]);
	for (i=0;i<script_models.size;i++)
	{
		if (script_models[i].model == "xmodel/vehicle_tank_flakpanzer")
		{
			script_models[i].dead_model = ("xmodel/vehicle_tank_flakpanzer_d");
			script_models[i].getFlakAnim = maps\_panzer::getFlakanim;
			script_models[i].flaknum = i;
			script_models[i].anim_thread = maps\_panzer::flakers_animation;
			script_models[i] thread maps\_scripted_turrets::flak_animation(i);
			script_models[i] UseAnimTree(#animtree);
		}
	}
}

#using_animtree("generic_human");
flakers_animation(p)
{
	if (p==0)
	{
		self.atype = "leader";
		self.flakanim["fireA"] = %flakpanzer_gunner_fire_a;
		self.flakanim["fireB"] = %flakpanzer_gunner_fire_b;
	}
	if (p==1)
	{
		self.atype = "leftloader";
		self.flakanim["fireA"] = %flakpanzer_leftloader_fire_a;
		self.flakanim["fireB"] = %flakpanzer_leftloader_fire_b;
	}
	if (p==2)
	{
		self.atype = "rightloader";
		self.flakanim["fireA"] = %flakpanzer_rightloader_fire_a;
		self.flakanim["fireB"] = %flakpanzer_rightloader_fire_b;
	}
}

#using_animtree("panzerflak");
getFlakanim(nonparm)
{
	flakanim["fireA"] = %flakpanzer_gun_fire_a;
	flakanim["fireB"] = %flakpanzer_gun_fire_b;

	return flakanim;
}
