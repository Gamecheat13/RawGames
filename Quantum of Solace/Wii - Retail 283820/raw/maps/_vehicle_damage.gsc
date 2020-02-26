






main()
{
	
	
	

	self build_model();

	self thread bond_veh_damage_collision();
	self thread bond_veh_damage_grind();

	self thread damage_front();
	self thread damage_left_corner();
	self thread damage_right_corner();
	self thread damage_left();
	self thread damage_right();

	damage = 0;

	while (true)
	{
		self waittill("vehicle_collision", hitPos, hitNorm, hitEnt, hitType);

		if (!IsDefined(hitEnt))
		{
			hitEnt = level;
		}

		if ((hitEnt == level) && (hitType == "collision"))
		{
			
			damage = self.health;
			self notify("death", hitEnt);
		}
		else
		{
			damage = 20;
		}

		
		if (hitType == "grind")
		{
			if (IsDefined(level._vehicle_damage_effect[self.vehicletype]) && IsDefined(level._vehicle_damage_effect[self.vehicletype]["grind"]))
			{
				Playfx(level._vehicle_damage_effect[self.vehicletype]["grind"], hitPos);
			}
		}
		

		v_point = hitPos - self.origin;
		

		v_right = AnglesToRight(self.angles);
		dot_right = VectorDot(v_right, VectorNormalize(v_point));

		v_forward = AnglesToForward(self.angles);
		dot_forward = VectorDot(v_forward, VectorNormalize(v_point));

		if (hitType == "collision")
		{
			if (dot_forward > .8)
			{
				self notify("damage_front", damage);
			}
			else if (dot_right > 0)
			{
				self notify("damage_right_corner", damage);
			}
			else
			{
				self notify("damage_left_corner", damage);
			}
		}
		else if ((hitType == "grind"))
		{
			if (dot_right > 0)
			{
				if (dot_forward > .7)
				{
					self notify("damage_right_corner", damage);
				}
				else
				{
					self notify("damage_right", damage);
				}
			}
			else
			{
				if (dot_forward > .7)
				{
					self notify("damage_left_corner", damage);
				}
				else
				{
					self notify("damage_left", damage);
				}
			}
		}

		
		self notify("damage", damage, hitEnt, hitNorm, hitPos, hitType);
	}
}

bond_veh_damage_collision()
{
	while (true)
	{
		self waittill("script_vehicle_collision", hitPos, hitNorm, hitEnt);
		self notify("vehicle_collision", hitPos, hitNorm, hitEnt, "collision");
	}
}

bond_veh_damage_grind()
{
	while (true)
	{
		self waittill("script_vehicle_grind", hitPos, hitNorm, hitEnt);
		self notify("vehicle_collision", hitPos, hitNorm, hitEnt, "grind");
	}
}

damage_front()
{
	damage_stage = 0;
	front_damage = 0;

	self.damaged_front = 0;

	while (true)
	{
		self waittill("damage_front", damage);
		front_damage += damage;

		damage_swap = self.currenthealth / 4;
		if ((front_damage > damage_swap) && (damage_stage < 2))	
		{
			damage_stage++;
			front_damage = 0;

			
			self.damaged_front = damage_stage;

			attach_part("hood", damage_stage, "hood");
			attach_part("engine", damage_stage);

			if (self.damaged_right && self.damaged_left)
			{
				attach_part("front_f", damage_stage, "front_lrf");
			}
			else if (self.damaged_right)
			{
				
				
			}
			else if (self.damaged_left)
			{
				
				
			}
			else
			{
				
				
			}
		}
	}
}

damage_left()
{
	damage_stage = 0;
	left_damage = 0;

	self.damaged_left = 0;

	while (true)
	{
		self waittill("damage_left", damage);
		left_damage += damage;

		damage_swap = self.currenthealth / 4;
		if ((left_damage > damage_swap) && (damage_stage < 2))	
		{
			damage_stage++;
			left_damage = 0;

			
			self.damaged_left = damage_stage;

			attach_part("door_l", damage_stage, "door_l");

			if (self.damaged_right)
			{
				attach_part("frame_lrb", damage_stage, "body");
				attach_part("front_lrf", damage_stage, "front_rf");
			}
			else
			{
				if (damage_stage == 1)
				{
					attach_part("front_lf", damage_stage, "front", damage_stage - 1);
				}

				attach_part("frame_lb", damage_stage, "body");
				attach_part("interior", damage_stage);
			}
		}
	}
}

damage_left_corner()
{
	while (true)
	{
		self waittill("damage_left_corner");

	}
}

damage_right()
{
	damage_stage = 0;
	right_damage = 0;

	self.damaged_right = 0;

	while (true)
	{
		self waittill("damage_right", damage);
		right_damage += damage;

		damage_swap = self.currenthealth / 4;
		if ((right_damage > damage_swap) && (damage_stage < 2))	
		{
			damage_stage++;
			right_damage = 0;

			
			self.damaged_right = damage_stage;

			attach_part("door_r", damage_stage, "door_r");

			if (self.damaged_left)
			{
				attach_part("frame_lrb", damage_stage, "body");
				attach_part("front_lrf", damage_stage, "front_lf");
			}
			else
			{
				if (damage_stage == 1)
				{
					attach_part("front_rf", damage_stage, "front", damage_stage - 1);
				}

				attach_part("frame_rb", damage_stage, "body");
				attach_part("interior", damage_stage);
			}
		}
	}
}

damage_right_corner()
{
	while (true)
	{
		self waittill("damage_right_corner");

	}
}

build_model()
{
	self.base_model = self.model;
	self attach_part("body");
	self attach_part("door_l");
	self attach_part("door_r");
	self attach_part("front");
	self attach_part("hood");
	self attach_part("lights_l");
	self attach_part("lights_r");
	self attach_part("window_l_back");
	self attach_part("window_l_front");
	self attach_part("window_r_back");
	self attach_part("window_r_front");
	self attach_part("winshield_back");
	self attach_part("winshield");
	self attach_part("tire_l_back");
	self attach_part("tire_l_front");
	self attach_part("tire_r_back");
	self attach_part("tire_r_front");
}





setup(model)
{
	switch(model)	
	{
	case "v_astonmartindbs_radiant":

		

		level.vehicle_parts[model]["body"][0]["model"] = "v_astonmartindbs_body_dmg0";

		

		level.vehicle_parts[model]["door_l"][0]["model"] = "v_astonmartindbs_door_l_dmg0";
		level.vehicle_parts[model]["door_l"][1]["model"] = "v_astonmartindbs_door_l_dmg1";
		PrecacheModel("v_astonmartindbs_door_l_dmg1");

		level.vehicle_parts[model]["door_r"][0]["model"] = "v_astonmartindbs_door_r_dmg0";
		level.vehicle_parts[model]["door_r"][1]["model"] = "v_astonmartindbs_door_r_dmg1";
		PrecacheModel("v_astonmartindbs_door_r_dmg1");
		
		

		level.vehicle_parts[model]["engine"][1]["model"] = "v_astonmartindbs_engine_dmg1";
		PrecacheModel("v_astonmartindbs_engine_dmg1");

		

		level.vehicle_parts[model]["frame_b"][1]["model"] = "v_astonmartindbs_frame_dmg1_b";
		PrecacheModel("v_astonmartindbs_frame_dmg1_b");

		level.vehicle_parts[model]["frame_lb"][1]["model"] = "v_astonmartindbs_frame_dmg1_lb";
		PrecacheModel("v_astonmartindbs_frame_dmg1_lb");

		level.vehicle_parts[model]["frame_lrb"][1]["model"] = "v_astonmartindbs_frame_dmg1_lrb";
		PrecacheModel("v_astonmartindbs_frame_dmg1_lrb");

		level.vehicle_parts[model]["frame_rb"][1]["model"] = "v_astonmartindbs_frame_dmg1_rb";
		PrecacheModel("v_astonmartindbs_frame_dmg1_rb");
		
		
		
		level.vehicle_parts[model]["front"][0]["model"] = "v_astonmartindbs_front_dmg0";

		level.vehicle_parts[model]["front_f"][1]["model"] = "v_astonmartindbs_front_dmg1_f";
		PrecacheModel("v_astonmartindbs_front_dmg1_f");

		level.vehicle_parts[model]["front_lf"][1]["model"] = "v_astonmartindbs_front_dmg1_lf";
		PrecacheModel("v_astonmartindbs_front_dmg1_lf");

		level.vehicle_parts[model]["front_lrf"][1]["model"] = "v_astonmartindbs_front_dmg1_lrf";
		PrecacheModel("v_astonmartindbs_front_dmg1_lrf");

		level.vehicle_parts[model]["front_rf"][1]["model"] = "v_astonmartindbs_front_dmg1_rf";
		PrecacheModel("v_astonmartindbs_front_dmg1_rf");

		

		level.vehicle_parts[model]["hood"][0]["model"] = "v_astonmartindbs_hood_dmg0";
		level.vehicle_parts[model]["hood"][1]["model"] = "v_astonmartindbs_hood_dmg1";
		PrecacheModel("v_astonmartindbs_hood_dmg1");

		

		level.vehicle_parts[model]["interior"][1]["model"] = "v_astonmartindbs_interior_dmg1";
		PrecacheModel("v_astonmartindbs_interior_dmg1");

		

		level.vehicle_parts[model]["lights_l"][0]["model"] = "v_astonmartindbs_lights_l_front_dmg0";

		level.vehicle_parts[model]["lights_r"][0]["model"] = "v_astonmartindbs_lights_r_front_dmg0";

		

		level.vehicle_parts[model]["tire_l_back"][0]["model"] = "v_astonmartindbs_tire_l_back_dmg0";

		level.vehicle_parts[model]["tire_l_front"][0]["model"] = "v_astonmartindbs_tire_l_front_dmg0";

		level.vehicle_parts[model]["tire_r_back"][0]["model"] = "v_astonmartindbs_tire_r_back_dmg0";

		level.vehicle_parts[model]["tire_r_front"][0]["model"] = "v_astonmartindbs_tire_r_front_dmg0";

		

		level.vehicle_parts[model]["window_l_back"][0]["model"] = "v_astonmartindbs_window_l_back_dmg0";
		level.vehicle_parts[model]["window_l_back"][1]["model"] = "v_astonmartindbs_window_l_back_dmg1";
		PrecacheModel("v_astonmartindbs_window_l_back_dmg1");

		level.vehicle_parts[model]["window_l_front"][0]["model"] = "v_astonmartindbs_window_l_front_dmg0";
		level.vehicle_parts[model]["window_l_front"][1]["model"] = "v_astonmartindbs_window_l_front_dmg1";
		PrecacheModel("v_astonmartindbs_window_l_front_dmg1");

		level.vehicle_parts[model]["window_r_back"][0]["model"] = "v_astonmartindbs_window_r_back_dmg0";
		level.vehicle_parts[model]["window_r_back"][1]["model"] = "v_astonmartindbs_window_r_back_dmg1";
		PrecacheModel("v_astonmartindbs_window_r_back_dmg1");

		level.vehicle_parts[model]["window_r_front"][0]["model"] = "v_astonmartindbs_window_r_front_dmg0";
		level.vehicle_parts[model]["window_r_front"][1]["model"] = "v_astonmartindbs_window_r_front_dmg1";
		PrecacheModel("v_astonmartindbs_window_r_front_dmg1");

		level.vehicle_parts[model]["winshield_back"][0]["model"] = "v_astonmartindbs_windshield_back_dmg0";
		level.vehicle_parts[model]["winshield_back"][1]["model"] = "v_astonmartindbs_windshield_back_dmg1";
		PrecacheModel("v_astonmartindbs_windshield_back_dmg1");

		level.vehicle_parts[model]["winshield"][0]["model"] = "v_astonmartindbs_windshield_dmg0";
		level.vehicle_parts[model]["winshield"][1]["model"] = "v_astonmartindbs_windshield_dmg1";
		PrecacheModel("v_astonmartindbs_windshield_dmg1");

		break;
	}
}
















detach_part(part, stage)
{
	if (IsDefined(level.vehicle_parts[self.base_model][part][stage]))
	{
		self Detach(level.vehicle_parts[self.base_model][part][stage]["model"]);
	}
}

attach_part(part, stage, remove_part, remove_part_stage)
{
	if (!IsDefined(stage))
	{
		stage = 0;
	}

	if (IsDefined(level.vehicle_parts[self.base_model][part][stage]))
	{
		if ((part == "body") || (IsDefined(remove_part) && (remove_part == "body")))
		{
			self SetModel(level.vehicle_parts[self.base_model][part][stage]["model"]);
		}
		else
		{
			self Attach(level.vehicle_parts[self.base_model][part][stage]["model"]);
		}
	}

	if (IsDefined(remove_part))
	{
		if (remove_part == part)
		{
			remove_part_stage = stage - 1;
		}
		else if (!IsDefined(remove_part_stage))
		{
			remove_part_stage = stage;
		}

		detach_part(remove_part, remove_part_stage);
	}
}