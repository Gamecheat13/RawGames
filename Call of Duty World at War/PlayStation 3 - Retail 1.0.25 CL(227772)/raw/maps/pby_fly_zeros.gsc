/*
spawn_a_zero()
{
	my_trig = GetEnt("start_zero_test", "targetname");
	my_trig waittill("trigger");
	
	spawn_pos = GetEnt("spawn_zero_pos", "targetname");
	plane = SpawnVehicle( "vehicle_jap_airplane_zero_d_fuselage", "new_plane", "zero", spawn_pos.origin, spawn_pos.angles );
	plane.vehicletype = "zero";
	maps\_vehicle::vehicle_init(plane);
	
}
*/  

strafing_runs()
{
	my_trig = GetEnt("start_zero_test", "targetname");
	my_trig waittill("trigger");
	
	target = GetEnt("strafing_target_one", "targetname");
	
	while(1)
	{
		level thread strafe_a_zero("back_strafe_right", target);
		wait(2);
		level thread strafe_a_zero("back_strafe_left", target);
		wait(2);
	}
	
}

strafe_a_zero(type_of_attack, target)
{
	
	/*
	if(level.total_zeros_spawned >= level.MAX_ZEROS)
	{
		return;
	}
	*/
	
	level.total_zeros_spawned++; //increment global zero counter
	
	starting_points = [];
	starting_points = get_pathpoints_start(target);
	
	if(starting_points["org"][0] > 60000 || starting_points["org"][0] < -60000 || starting_points["org"][1] > 60000 || starting_points["org"][1] < -60000 || starting_points["org"][2] > 20000 || starting_points["org"][2] < -1000)
	{
		ASSERTEX(false, "the spawn point for the new plane was all messed up");
	}
	
	plane = SpawnVehicle( "vehicle_jap_airplane_zero_d_fuselage", "new_plane", "zero", starting_points["org"], starting_points["ang"] );
	plane.vehicletype = "zero";
	maps\_vehicle::vehicle_init(plane);
	
	if(type_of_attack == "back_strafe_right")
	{
		plane get_pathpoints_straight_strafe_bank_away(target, "right");
	}
	else if(type_of_attack == "back_strafe_left")
	{
		plane get_pathpoints_straight_strafe_bank_away(target, "left");
	}
	
	plane thread ai_turret_think(target);
	plane endon("death");
	
	plane setplanegoalpos(plane.origin + (AnglesToForward(plane.angles) * 100), 160);
	plane waittill("curve_end");
	for(i = 0; i < plane.pathpoints["fly_org"].size - 5; i++)
	{
		//plane setplanegoalpos(plane.pathpoints["fly_org"][i], plane.pathpoints["fly_ang"][i], 160);
		plane setplanegoalpos(plane.pathpoints["fly_org"][i], plane.pathpoints["fly_org"][i+1], plane.pathpoints["fly_org"][i+2], plane.pathpoints["fly_org"][i+3], plane.pathpoints["fly_org"][i+4],plane.pathpoints["fly_org"][i+5], 160);
		//plane thread draw_debug_lines(i);
		
		if(plane.pathpoints["fly_cond"][i] == "range")
		{
			while(Distance2D(plane.origin, plane.pathpoints["fly_org"][i]) > 2000)
			{
				wait(0.05);
			}
		}
		else if(plane.pathpoints["fly_cond"][i] == "delay")
		{
			wait(0.4);
		}
		else
		{		
			plane waittill("curve_end");
		}
		
		if(Distance2D(plane.origin, target.origin) > plane.pathpoints["kill_on_range"][i])
		{
			plane RadiusDamage(plane.origin, 100, 50000, 50000);
			level.total_zeros_spawned--; //maintain the total number of zeros
		}
	}
}

get_pathpoints_start(target)
{ 
	start_points["org"] = target.origin - ((AnglesToForward(target.angles)[0] * 10000, (AnglesToForward(target.angles)[1] * 10000), 0));//The origin of the target
	
	//give the zeros a random initial dive degree that is between 15 and 30
	z_value = Tan(RandomIntRange(8,15)) * Distance2D(target.origin, start_points["org"]);
	//start_points["org"] += (0,0,z_value);
	start_points["org"] += (0, 0, 1500);
	start_points["ang"] = target.angles;	
	
	return start_points;
}

get_pathpoints_straight_strafe_bank_away(target, direction)
{
	self.shoot_gun_range = 5000;
	
	self.pathpoints["fly_org"] = [];
	self.pathpoints["fly_ang"] = [];
	self.pathpoints["fly_cond"] = [];
	self.pathpoints["kill_on_range"] = [];
		
	//setup the initial spawnpoint

	self.pathpoints["fly_org"][0] = (target.origin[0],  target.origin[1], RandomIntRange(75, 600));
	self.pathpoints["fly_ang"][0] = target.angles;
	self.pathpoints["fly_cond"][0] = "end_curve";
	self.pathpoints["kill_on_range"][0] = 999999; //A really LARGE number
	
	
	new_path_point_org = target.origin + (VectorNormalize(AnglesToForward(target.angles)) * 50000) + (0,0, 1200);//((AnglesToForward(target.angles)[0] * 50000, (AnglesToForward(target.angles)[1] * 50000), 600)); //(0, 50000, 600);
	new_path_point_ang = target.angles;
	
	self.pathpoints["fly_org"][1] = new_path_point_org; 
	self.pathpoints["fly_ang"][1] = new_path_point_ang;
	self.pathpoints["fly_cond"][1] = "delay";
	self.pathpoints["kill_on_range"][1] = 999999;
	
	if(direction == "right")
	{
		for(i = 2; i < 100; i++)
		{
			new_path_point_org = offset_point_generator(((AnglesToRight(target.angles)[0] * 10000),(AnglesToRight(target.angles)[1] * 10000), 5000), new_path_point_org);
			new_path_point_ang = offset_point_generator((10,5,0), new_path_point_ang);
			self.pathpoints["fly_org"][i] = new_path_point_org;
			self.pathpoints["fly_ang"][i] = new_path_point_ang;
			self.pathpoints["fly_cond"][i] = "delay";	
			self.pathpoints["kill_on_range"][i] = 12000;
		}
	}
	else if(direction == "left")
	{
		for(i = 2; i < 100; i++)
		{
			new_path_point_org = offset_point_generator( (((AnglesToRight(target.angles)[0] * 10000)) * -1, ((AnglesToRight(target.angles)[1] * 10000)) * -1, 5000), new_path_point_org);
			new_path_point_ang = offset_point_generator((-10,5,0), new_path_point_ang);
			self.pathpoints["fly_org"][i] = new_path_point_org;
			self.pathpoints["fly_ang"][i] = new_path_point_ang;
			self.pathpoints["fly_cond"][i] = "delay";	
			self.pathpoints["kill_on_range"][i] = 12000;
		}
	}
}

offset_point_generator(org_offset, original_point)
{
	new_point = original_point + org_offset;
	
	return new_point;
}

draw_debug_lines(id)
{
	self endon("curve_end");
	self endon("end_line");
	
	while(1)
	{
		Line(self.origin, self.pathpoints["fly_org"][id], (0,0,1));
		Line(self.origin, (self.origin + VectorNormalize(self.pathpoints["fly_ang"][id]) * 5000), (1,0,0));
		wait(0.01);
	}
}

ai_turret_think(target)
{
	max_fire_time = 2;
	time_firing = 0;
	
	self endon("stop_my_firing");
	self endon("death");
	
	i = 0;
	
	turret_origin = undefined;
	turret_target = undefined;
	
	if(!IsDefined(self.firing))
	{
		self.firing = false;
	}
	
	//self setgunnertargetent(self.right_turret_target, (0,0,0), 0);
	//self setgunnertargetent(self.left_turret_target, (0,0,0), 1);
	
	self_forward = (0,0,0);
	random_num = 0;
	firing_at_player = false;
	
	while(1)
	{
		firing_at_player = false;
		self_forward = AnglesToForward(self.angles);
		target_vector = self.origin + (self_forward * 5000) - (0,0, .2679491 * 5000); //-- Tan(15)	
		
		//-- Check and see if the player is within a reasonable angle and if he is, then shoot at him instead
		player_dir = VectorNormalize(level.player.origin - self.origin);
		angle = VectorDot(self_forward, player_dir);
		if( angle > .965 )
		{
			target_vector = level.player.origin + (0,0, 45);
			firing_at_player = true;
		}
		
		//-- if the player and the zero are flying in the same direction then no damage
		player_for = AnglesToForward( level.plane_a.angles );
		other_angle = VectorDot( self_forward, player_for );
		if(other_angle > 0)
		{
			firing_at_player = false;
		}
		
		self SetGunnerTargetVec( target_vector, 0 );
		self SetGunnerTargetVec( target_vector, 1 );
		
		if(Distance2D(self.origin, target.origin) < self.shoot_gun_range)
		{
			self firegunnerweapon( 0 );
			wait(0.14);
			time_firing += 0.14;
			self firegunnerweapon( 1 );
			wait(0.14);
			time_firing += 0.14;
			
			self.firing = true; //-- old
			
			if(firing_at_player)
			{
				if(IsDefined(level.zero_accuracy_override))
				{
					level.plane_a notify( "pby_nose_damage", self );
				}
				else
				{
					random_num = RandomIntRange(1, 10);
					if(random_num >= 7)
					{
						level.plane_a notify( "pby_nose_damage", self );
					}
				}
			}
		} 
		else
		{
			wait(0.1);
			self.firing = false; //-- old
		}
		
		if(time_firing > max_fire_time)
		{
			random_wait = RandomFloatRange(0.5, 1.0);
			wait(random_wait);
			time_firing = 0;
		}
	}
}

/*
turret_loop_right()
{
	self endon("death");
	
	while(1)
	{
		if(self.firing)
		{
			turret_right_origin = self GetTagOrigin("tag_gunright") + (AnglesToForward(self.angles) * 50);
			turret_right_target = turret_right_origin + (AnglesToForward(self.angles) * 5000) - (0,0, Tan(10) * 5000);
			MagicBullet("default_aircraft_turret", turret_right_origin, turret_right_target);
		}
		wait(RandomFloatRange(0.05, 0.1));
	}
}	

turret_loop_left()
{
	self endon("death");
	
	while(1)
	{
		if(self.firing)
		{
			turret_left_origin = self GetTagOrigin("tag_gunleft") + (AnglesToForward(self.angles) * 50);
			turret_left_target = turret_left_origin + (AnglesToForward(self.angles) * 5000) - (0,0, Tan(10) * 5000);
			MagicBullet("default_aircraft_turret", turret_left_origin, turret_left_target);
		}
		wait(RandomFloatRange(0.05, 0.1));
	}
}
*/


strafe_a_moving_target(target)
{
	//-- increment global zero counter
	level.total_zeros_spawned++; 
	
	//-- Get the initial starting point for the Zero
	
	starting_points = [];
	ref_ent = GetEnt("ev5_ref_origin", "targetname");
		
	//-- Calculate an approprite spawnpoint
	starting_points["org"] = target.origin - ((AnglesToForward(ref_ent.angles)[0] * 20000, (AnglesToForward(ref_ent.angles)[1] * 20000), 0));//The origin of the target
	z_value = Tan(RandomIntRange(8,15)) * Distance2D(target.origin, starting_points["org"]);
	starting_points["org"] += (0,0,z_value);
	starting_points["ang"] = ref_ent.angles;	
	
	plane = SpawnVehicle( "vehicle_jap_airplane_zero_d_fuselage", "new_plane", "zero", starting_points["org"], starting_points["ang"] );
	plane.vehicletype = "zero";
	maps\_vehicle::vehicle_init(plane);
	
	plane.shoot_gun_range = 5000;
	
	plane thread ai_turret_think(target);
	plane endon("death");
	
	//-- Make shorter splines that get flown completely while working on strafing the target
	plane.pathpoints["fly_org"] = [];
	plane.pathpoints["fly_ang"] = [];
	plane.pathpoints["fly_cond"] = [];
	plane.pathpoints["kill_on_range"] = [];
		
	while(Distance2D(target.origin, plane.origin) > 5000)
	{
		plane.pathpoints["fly_org"][0] = target.origin + (0,0,600);
		plane.pathpoints["fly_ang"][0] = ref_ent.angles;
		plane.pathpoints["fly_cond"][0] = "end_curve";
		plane.pathpoints["kill_on_range"][0] = 999999; //A really LARGE number
		
		plane setplanegoalpos(plane.pathpoints["fly_org"][0], 200);
		plane thread waittillclose( target );
		plane waittill("curve_end");
	}
	
	//-- Fly straight for a little bit
	
	plane.pathpoints["fly_org"][1] = plane.origin + AnglesToForward(VectorToAngles( (target.origin + (0,0,600)) - plane.origin )) * 8000;
	plane.pathpoints["fly_ang"][1] = ref_ent.angles;
	plane.pathpoints["fly_cond"][1] = "end_curve";
	plane.pathpoints["kill_on_range"][1] = 999999; //A really LARGE number
	
	plane setplanegoalpos(plane.pathpoints["fly_org"][1], plane.pathpoints["fly_ang"][1], 200);
	
	//-- Bank left/right after strafing past the target
	
	//TEMP - ZERO REACHED THE END OF ITS PATH WITHOUT DYING
	RadiusDamage(plane.origin, 100, 2500, 2500);
}

waittillclose( target )
{
	self endon( "curve_end" );
	
	for( i = 0; i < 10; i++ )
	{
		if( Distance2D(target.origin, self.origin) < 5000 )
			self notify( "curve_end" );
		wait 0.2;
	}
	self notify( "curve_end" );
}
