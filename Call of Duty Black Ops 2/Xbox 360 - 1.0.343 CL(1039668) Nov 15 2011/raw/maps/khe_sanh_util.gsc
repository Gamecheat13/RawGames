
#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_objectives;
#include maps\_dialog;

#using_animtree("generic_human");

/***************************************************************/
//	do_vignette
//
//	Util for playing a vignette involving multiple actors...
//	this function will spawn the actors for you based on an 
//	array of spawner names...
//
//	params: align node, actor spawner names, thread type,
//	group_name option...if group_name is specified an array of 
//	the spawned actors will be stored for the level. This can be
//	used to access actors again if needed (ie for deletion)
//
//	thread types
//	{
//		0 = not threaded (will all be played together)
//		1 = thread_together (will all be played together on a thread)
//		2 = thread_individually (will be played individually on threads)
//	}
//
/***************************************************************/
do_vignette(node, actor_names, anim_name, loop, thread_type, group_name, auto_delete /* only works for non threaded */, disable_weapons)
{
	// get the alignment node
	if (IsString(node))
	{
		align_node = GetEnt(node, "targetname");
	}
	else
	{
		align_node = node;
	}

	//IsString(node) ? align_node = GetEnt(node, "targetname") : align_node = node;
	//align_node = IsString(node) ? GetEnt(node, "targetname") : node;

	// create actors
	names = build_ent_array(actor_names);
	actors = [];
	for (i = 0; i < names.size; i++)
	{
		if (IsString(names[i]))
		{
			actors[i] = simple_spawn_single(names[i]);
			actors[i].animname = names[i];
			actors[i].ignoreall = true;

			if (IsDefined(disable_weapons) && disable_weapons)
			{
				actors[i] gun_remove();
			}
		}
		else
		{
			actors[i] = names[i];
		}
	}

	// create a group if specified
	if (IsDefined(group_name))
	{
		if (IsDefined(level.vignette_group) && IsDefined(level.vignette_group[group_name]))
		{
			level.vignette_group[group_name] = array_combine(level.vignette_group[group_name], actors);
		}
		else
		{
			level.vignette_group[group_name] = actors;
		}
	}

	switch(thread_type)
	{
		// 0 = not threaded (will all be played together)
		case 0:
		{
			// play anim
			if (loop)
			{
				align_node anim_loop_aligned(actors, anim_name);
			}
			else
			{
				align_node anim_single_aligned(actors, anim_name);
			}

			// check for auto delete
			if (IsDefined(auto_delete) && auto_delete)
			{
				array_delete(actors);
			}

			break;
		}

		// 1 = thread_together (will all be played together on a thread)
		case 1:
		{
			// play anim
			if (loop)
			{
				align_node thread anim_loop_aligned(actors, anim_name);
			}
			else
			{
				align_node thread anim_single_aligned(actors, anim_name);
			}

			break;
		}

		// 2 = thread_individually (will be played individually on threads)
		case 2:
		{
			// loop the actors and spin indiviual threads
			for (i = 0; i < actors.size; i++)
			{
				if (loop)
				{
					align_node thread anim_loop_aligned(actors[i], anim_name);
				}
				else
				{
					align_node thread anim_single_aligned(actors[i], anim_name);
				}
			}

			break;
		}

		default: break;
	}	
}

gameover_screen()
{
	level.blackscreen = NewHudElem(); 
	level.blackscreen.x = 0; 
	level.blackscreen.y = 0; 
	level.blackscreen.horzAlign = "fullscreen"; 
	level.blackscreen.vertAlign = "fullscreen"; 
	level.blackscreen.foreground = true;
	level.blackscreen SetShader( "black", 640, 480 );
}

/***************************************************************/
//
//	spawn_fake_character
//
/***************************************************************/
spawn_fake_character(origin, angles, char_type )
{
	team = "allies";
	model = spawn("script_model", origin);
	if (IsDefined(angles))
	{
		model.angles = angles;
	}

	//default to allies
	model.team = team;

	if (char_type == "marine")
	{
		model character\c_usa_jungmar_assault::main();
	}
	else if (char_type == "driver")
	{
		model character\c_usa_jungmar_driver::main();
	}
	else if (char_type == "topless")
	{
		model character\c_usa_jungmar_barechest::main();
	}
	else if (char_type == "chaplain")
	{
		model character\c_usa_jungmar_chaplain::main();
	}
	else if (char_type == "wounded_torso")
	{
		model character\c_usa_jungmar_wounded_torso::main();
	}
	else if (char_type == "wounded_knee")
	{
		model character\c_usa_jungmar_wounded_knee::main();
	}
	else if (char_type == "sergeant")
	{
		model character\c_usa_jungmar_sarge2::main();
	}
	else if (char_type == "c_vtn_nva1")
	{
		model.team = "axis";
		model character\c_vtn_nva1::main();
	}
	else if (char_type == "c_vtn_nva1_char")
	{
		model.team = "axis";
		model character\c_vtn_nva1_char::main();
	}
	else if (char_type == "c_vtn_nva2")
	{
		model.team = "axis";
		model character\c_vtn_nva2::main();
	}
	else if (char_type == "c_vtn_nva3")
	{
		model.team = "axis";
		model character\c_vtn_nva3::main();
	}
	else if (char_type == "huey_pilot_1")
	{
		model character\c_usa_huey_pilot_1::main();
	}
	else if (char_type == "huey_pilot_2")
	{
		model character\c_usa_huey_pilot_2::main();
	}
	else if (char_type == "blown_head")
	{
		model character\c_usa_jungmar_headblown::main();
	}
	else if (char_type == "bowman")
	{
		model character\c_usa_jungmar_bowman_nobackpack::main();
	}
	else if (char_type == "medic")
	{
		model character\c_usa_jungmar_medic::main();
	}


	//give name if allies
	if(model.team == "allies" && char_type != "bowman")
	{
		model MakeFakeAI();
		model maps\_names::get_name();
		model setlookattext(model.name, &"");
	}

	if(char_type == "bowman")
	{
		model MakeFakeAI();
		model.name = "Bowman";
		model setlookattext(model.name, &"");
	}

	return model;
}

/***************************************************************/
//
//	sky metal
//
/***************************************************************/
sky_metal(node, models, count, min_offset, max_offset, min_vel, max_vel, separation, group, ender)
{
	level endon(ender);

	metal_org = node;
	if (IsString(node))
	{
		metal_org = GetEnt(node, "targetname");
	}

	level.metal[group] = [];
	center = metal_org.origin;
	angles = metal_org.angles;
	up = AnglesToUp(angles);
	forward = AnglesToForward(angles);
	right = AnglesToRight(angles);

	// spawn a bunch of stuff
	for (i = 0; i < count; i++)
	{
		offset = (RandomFloatRange(min_offset[0], max_offset[0]), RandomFloatRange(min_offset[1], max_offset[1]), RandomFloatRange(min_offset[2], max_offset[2]));		
		offset_f = forward * offset[0];
		offset_r = right * offset[1];
		offset_u = up * offset[2];

		position = center + (offset_f + offset_r + offset_u);

		level.metal[group][i] = spawn("script_model", position);
		level.metal[group][i] SetForceNoCull();
		level.metal[group][i].angles = angles;
		level.metal[group][i] SetModel(models["side"]);
		level.metal[group][i] Attach(models["interior"], "tag_body");

		//if(even_number(i))
		//{
		level.metal[group][i] RotatePitch(12, 0.05);
		//}

		PlayFXOnTag(level._effect["huey_rotor"], level.metal[group][i], "main_rotor_jnt");

		level.metal[group][i].vel = AnglesToForward(angles) * RandomFloatRange(min_vel, max_vel);
	}

	while (1)
	{
//		Box(center, min_offset, max_offset, angles[1], (1, 0, 0), 1, 1, 1);

		if (!flag("e1_pause_sky_metal"))
		{
			for (i = 0; i < count; i++)
			{
			//	v1 = metal[i] sky_metal_cohesion(metal, 0.001);
				v2 = level.metal[group][i] sky_metal_separation(level.metal[group], 1.0, separation);

				level.metal[group][i].origin = level.metal[group][i].origin + v2 * 0.05;
				level.metal[group][i].origin = level.metal[group][i].origin + level.metal[group][i].vel * 0.05;
			}
		}

		wait(0.05);
	}
}

// self == metal[i]
sky_metal_cohesion(metal_list, weight)
{
	average_pos = (0, 0, 0);
	
	// sum up the positions
	for (i = 0; i < metal_list.size; i++)
	{
		if (self != metal_list[i])
		{
			average_pos += metal_list[i].origin;
		}
	}

	// find the average
	average_pos = average_pos / (metal_list.size - 1);

	// get the delta to the average position
	delta = average_pos - self.origin;

	// return the weighted average
//	return (delta * weight);
	return (0,0,0);
}

// self == metal[i]
sky_metal_separation(metal_list, weight, min_delta)
{
	delta = (0, 0, 0);
	min_delta_squared = min_delta * min_delta;

	for (i = 0; i < metal_list[i].size; i++)
	{
		if (self != metal_list[i])
		{
			dist = DistanceSquared(self.origin, metal_list[i].origin);
			if (dist < min_delta_squared)
			{
				delta = delta + (self.origin - metal_list[i].origin);
				//dir = VectorNormalize(self.origin - metal_list[i].origin);
				//delta = delta + (dir * (min_delta - Sqrt(dist)));
				//delta = delta + dir;
			}
		}
	}

	return delta * weight;
}

sky_metal_velocity_match(metal_list)
{

}

/***************************************************************/
//
//	ragdoll explosion	
//
/***************************************************************/
guy_explosion_launch(org, force)
{
	self StopAnimScripted();
	//self DoDamage( self.health * 100, org, self, undefined, "explosive" );
	self thread bloody_death();
	self StartRagdoll( 1 );
	self LaunchRagdoll( force );
}

// explosion_launch added to _utility.gsc on CL#853750, marking this for deletion on 4/6/2011 - TravisJ
//explosion_launch(org, radius, min_force, max_force, min_launch_angle, max_launch_angle, drones)
//{
//	if(IsDefined(drones) && drones)
//	{
//		allies = GetEntArray("drone", "targetname");
//	}
//	else
//	{
//		allies = GetAIArray("allies");
//	}

//	allies = array_exclude(allies, level.hero_list);

//	radiusSquared = radius * radius;
//	for (i = 0; i < allies.size; i++)
//	{
//		is_hero = (allies[i] == level.squad["woods"]) || (allies[i] == level.squad["hudson"]);

//		if (IsDefined(allies[i]) && !IsGodMode(allies[i]) && !is_hero)
//		{
//			distSquared = Distance2DSquared(org, allies[i].origin);
//			if (distSquared < radiusSquared)
//			{
//				dir = allies[i].origin - org;
//				dir = (dir[0], dir[1], 0);
//				dir = VectorNormalize(dir);
//				launch_angles = VectorToAngles(dir);

//				launch_pitch = linear_map(distSquared, 0, radiusSquared, min_launch_angle, max_launch_angle);
//				launch_pitch = launch_pitch * -1;
//				launch_angles = (launch_pitch, launch_angles[1], launch_angles[2]);

//				dir = AnglesToForward(launch_angles);

//				force_mag = linear_map(distSquared, 0, radiusSquared, min_force, max_force);
//				force = dir * force_mag;
//				
//				allies[i] guy_explosion_launch(org, force);
///*		//burn_me doesnt work for this	
//				if(IsDefined(drones) && drones)
//				{
//					allies[i] burn_me();
//				}
//				else
//				{
//					allies[i] guy_explosion_launch(org, force);
//				}
//*/				
//			}
//		}
//	}
////}

/////////////////////////////////////////////////
//		NVA ladder runners, jumperd and hill guys
/////////////
runner_behaviour()
{
	self endon( "death" );

	if(  self.script_noteworthy == "ladder_runners" || self.script_noteworthy == "hill_ai_delete" || self.script_noteworthy == "jumpers" )
	{
		self.health = 100;
		self.goalradius = 64;
		self.ignoreall = true;
		self.ignoreme = true;
		self.pacifist = true;
		self.ignoresuppression = true;

		self waittill( "goal" );
		self khe_sanh_die();
	}
}

///////////////////
//
// Have a tank fire its turret at an entity
//
///////////////////////////////
tank_fire_at_ent( ent_name, timeout )
{
	
	self endon( "death" );
	self endon( "end_tank_fire_at" );

	if( !isdefined( timeout ) )
	{
		timeout = 5;
	}

	spot = getent( ent_name, "targetname" );

	self SetTurretTargetEnt( spot );
	self waittill_notify_or_timeout( "turret_on_target", timeout ); 
	wait ( 1 );
	self ClearTurretTarget(); 
	self fireweapon();
	
}

///////////////////
//
// Have a tank set its turret forward and not track any target
//
///////////////////////////////

tank_reset_turret( timeout )
{

	self endon( "death" );

	if( !isdefined( timeout ) )
	{
		timeout = 5;
	}

	// get its turret facing forward
	forward = AnglesToForward( self.angles );
	vec = VectorScale( forward, 1000 );

	// to see where its forward vec is
	//self thread draw_line_from_ent_to_vec( vec );

	self SetTurretTargetVec( self.origin + vec );

	self waittill_notify_or_timeout( "turret_on_target", timeout ); 
	
	// once it's facing forward, don't let it track any previously set turret target
	self ClearTurretTarget(); 

}

///////////////////
//
// Stops a vehicle once it reaches its goal node - from guzzo_util
//
///////////////////////////////

veh_stop_at_node( node_name, accel, decel, dont_stop_flag )
{
	if( !IsDefined( accel ) )
	{
		accel = 15;	
	}

	if( !IsDefined( decel ) )
	{
		decel = 15;	
	}
	
	vnode = GetVehicleNode( node_name, "script_noteworthy" );
	vnode waittill( "trigger" );	
	
	if( !isdefined( dont_stop_flag ) || ( isdefined( dont_stop_flag ) && !flag( dont_stop_flag ) ) )
	{
		self SetSpeed( 0, accel, decel );
//		println( "*** debug tank stop node: node " + node_name + "... now stopping" );		
	}
}


///////////////////
//
// Have a tank fire its turret at a script_struct
//
///////////////////////////////

tank_fire_at_struct( struct_targ, timeout )
{
	
	self endon( "death" );
	self endon( "end_tank_fire_at" );

	if( !isdefined( timeout ) )
	{
		timeout = 5;
	}

	self SetTurretTargetVec( struct_targ.origin );
	self waittill_notify_or_timeout( "turret_on_target", timeout ); 
	wait ( 1 );
	self ClearTurretTarget(); 
	self fireweapon();
	
}

debug_tank_health()
{
	
	while( 1 )
	{
	
		tanks = getentarray( "script_vehicle", "classname" );
		dead_tanks = getentarray( "script_vehicle_corpse", "classname" );
		tanks = array_combine( tanks, dead_tanks );
		
		for( i  = 0; i < tanks.size; i++ )
		{
//			if( tanks[i].vehicletype == "type97" || tanks[i].vehicletype == "sherman" || tanks[i].vehicletype == "model94" || tanks[i].vehicletype == "triple25" )
//			{
			
				if( isdefined( tanks[i].keep_tank_alive ) && tanks[i].keep_tank_alive == 1 )
				{
					print3d( tanks[i].origin + ( 0, 0, 70 ), tanks[i].health, ( 0.0, 1.0, 0.0 ), 1, 1, 1 );		
					if( isdefined( tanks[i].targetname ) )
					{
						print3d( tanks[i].origin + ( 0, 0, 80 ), tanks[i].targetname, ( 0.0, 1.0, 0.0 ), 1, 1, 1 );		
					}
				}
				else if( tanks[i].health > 0 )
				{
					print3d( tanks[i].origin + ( 0, 0, 70 ), tanks[i].health, ( 1.0, 1.0, 0.0 ), 1, 1, 1 );			
					if( isdefined( tanks[i].targetname ) )
					{					
						print3d( tanks[i].origin + ( 0, 0, 80 ), tanks[i].targetname, ( 1.0, 1.0, 0.0 ), 1, 1, 1 );			
					}
				}
				else
				{
					if( isdefined( tanks[i].targetname ) )
					{
						print3d( tanks[i].origin + ( 0, 0, 80 ), tanks[i].targetname, ( 1.0, 0.0, 0.0 ), 1, 1, 1 );	
					}
				}
			}
//		}
		
		wait( 0.05 );
		
	}
	
}

debug_num_vehicles()
{

	while( 1 )
	{
		vehicles = getentarray( "script_vehicle", "classname" );
		extra_text( "vehicles: " + vehicles.size );
		wait( 0.5 );
	}
	
}

///////////////////
//
// Sets text on extra_info hudelem
//
///////////////////////////////

extra_text( text )
{
/#
	level.extra_info settext( text );
	// print to output so we have a record of quick_text prints
	println( "extra_text print: " + text );	
#/
}

//self = ai
burn_me()
{
	self endon( "death" );

//	self random_burn_anim();

	if( is_mature() )
	{
		self StartTanning();
		self SetClientFlag(level.ACTOR_CHARRING);
	}
	
	//SOUND - Shawn J
	self playsound ("amb_fougasse_scream");
	
	self.ignoreme = true;
	self.ignoreall = true;

	self thread animscripts\death::flame_death_fx();

	//have to set this //death.gsc
	self.a.forceflamedeath = true;

	wait 0.1;
	
	self DoDamage( 1000, self.origin, level.player, level.player, 0, "MOD_BURNED");

	//anim_single( self, "burning_fate" );
	//self Die();
}

//self = ai actor
enable_charring(pause)
{
	if(pause)	
	{
		self waittill("death");
	}

	if( is_mature() )
	{
		self SetClientFlag(level.ACTOR_CHARRING);
	}
}

//self is a non ai script model
ragdoll_burn_model()
{
	self StartRagdoll();

	self StartTanning();

	//SOUND - Shawn J
	self playsound ("amb_fougasse_scream");

	//self thread animscripts\death::flame_death_fx();

	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_torso"] ) )
	{
		PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" ); 
	}

/*
	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_sm"] ) )
	{
		wait 1;

		tagArray = []; 
		tagArray[0] = "J_Elbow_LE"; 
		tagArray[1] = "J_Elbow_RI"; 
		tagArray[2] = "J_Knee_RI"; 
		tagArray[3] = "J_Knee_LE"; 
		tagArray = array_randomize( tagArray ); 

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 

		wait 1;

		tagArray = array_randomize( tagArray ); 

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[1] ); 
	}
*/
}

random_burn_anim()
{
	anims = array("napalm_victim_1","napalm_victim_2","napalm_victim_3","napalm_victim_4");
	self.animname = anims[RandomInt(anims.size)];
}

do_nag_loop( name, dialogue, ender_flag, repeat_interval )
{
	//prints dialogue line every 10 secs until specified flag
	level thread add_temp_dialog_line( name, dialogue );
	x = 0;
	while( !flag( ender_flag ) )
	{
		wait 1;
		x++;
		if( x == repeat_interval )
		{
			add_temp_dialog_line( name, dialogue );
			x = 0;
		}
	}	
}

is_active_ai( suspect )
{
	if( IsDefined( suspect ) && IsSentient( suspect ) && IsAlive( suspect ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

fake_physicslaunch( target_pos, power )
{
	start_pos = self.origin; 
	
	///////// Math Section
	// Reverse the gravity so it's negative, you could change the gravity
	// by just putting a number in there, but if you keep the dvar, then the
	// user will see it change.
	gravity = getdvarint( "bg_gravity" ) * -1; 

	dist = Distance( start_pos, target_pos ); 
	
	time = dist / power; 
	delta = target_pos - start_pos; 
	drop = 0.5 * gravity *( time * time ); 
	
	velocity = ( ( delta[0] / time ), ( delta[1] / time ), ( delta[2] - drop ) / time ); 
	///////// End Math Section

	level thread draw_line_ent_to_pos( self, target_pos );
	self MoveGravity( velocity, time );
	return time;
}

draw_line_ent_to_pos( ent, pos, end_on )
{
/#
	if( getdvarint( "zombie_debug" ) != 1 )
	{
		return; 
	}

	ent endon( "death" ); 

	ent notify( "stop_draw_line_ent_to_pos" ); 
	ent endon( "stop_draw_line_ent_to_pos" ); 

	if( IsDefined( end_on ) )
	{
		ent endon( end_on ); 
	}

	while( 1 )
	{
		line( ent.origin, pos ); 
		wait( 0.05 ); 
	}
#/
}

// Check to see if we're on ground within some tolerance...pass back if we're under the ground
// and the ground pos
is_on_ground(tolerance)
{
	trace_start = self.origin + ((0, 0, 1) * 30);
	trace_end = trace_start + (0, 0, -256);
	trace = BulletTrace(trace_start, trace_end, 0, undefined);
	org = trace["position"];

	dist = DistanceSquared(self.origin, org);
	if (dist > 0.1)
	{
		// get the delta
		delta = self.origin - org;
		up = (0, 0, 1);

		// check to see if we're underground
		dot = VectorDot(delta, up);
		if (dot < 0)
		{
			self.origin = org;
			return true;
		}
	}

	// check vs. tolerance
	check = tolerance * tolerance;
	if (dist < check)
	{
		return true;
	}

	return false;
}


event3_show_tank_poi()
{
	flag_wait("picked_up_law");
	//Objective_AdditionalPosition( obj_num, 1, level.e3_t55_tank[0].obj_loc );
	//Objective_AdditionalPosition( obj_num, 2, level.e3_t55_tank[1].obj_loc );
	//Objective_AdditionalPosition( obj_num, 3, level.e3_t55_tank[2].obj_loc );
	//Objective_Set3D( obj_num, true, "default", &"KHE_SANH_OBJ_3D_DESTROY" );
	
	set_objective( level.OBJ_DEFEAT_T55, level.e3_t55_tank[0].obj_loc, "destroy", -1 );
	set_objective( level.OBJ_DEFEAT_T55, level.e3_t55_tank[1].obj_loc, "destroy", -1 );
	set_objective( level.OBJ_DEFEAT_T55, level.e3_t55_tank[2].obj_loc, "destroy", -1 );
}

//clears the objective
cleanup_law_obj(strucobj, strucobj_b, strucobj_c)
{
	flag_wait("picked_up_law");
	//Objective_State( num_of_obj, "done" ); 
	//Objective_Delete( num_of_obj );
	
	set_objective( level.OBJ_PICKUP_LAW, strucobj, "remove" );
	set_objective( level.OBJ_PICKUP_LAW, strucobj_b, "remove" );
	set_objective( level.OBJ_PICKUP_LAW, strucobj_c, "remove" );
	
	set_objective( level.OBJ_PICKUP_LAW, undefined, "done" );
	set_objective( level.OBJ_PICKUP_LAW, undefined, "delete" );
	
	remove_drone_struct(strucobj);
	remove_drone_struct(strucobj_b);
	remove_drone_struct(strucobj_c);
}


fougasse_obj_cleanup(index)
{
	if(index == 0)
	{
		//Objective_AdditionalPosition( level.fougasse_obj_num, 0, (0,0,0) );
		set_objective( level.OBJ_FOUGASSE_TRAPS, level.obj_fougasse_one, "remove" );
	}
	else if(index == 1)
	{
		//Objective_AdditionalPosition( level.fougasse_obj_num, 1, (0,0,0) );
		set_objective( level.OBJ_FOUGASSE_TRAPS, level.obj_fougasse_two, "remove" );
	}
}

show_time(interval)
{
	level.player endon("death");
	time = 0;
	while(1)
	{
		wait interval;
		time += interval;
	}
}

drone_speed_adjust()
{
	level.player endon("death");
	level endon("stop_drone_speed_adjust");

	while(1)
	{
		level waittill("new drone Spawn wave");

		// the speed and the anim rate will be multiplied by this number
		if(IsDefined(level.drone_speed_override) && level.drone_speed_override)
		{
			x = level.speed_mult;
		}
		else
		{
			x = RandomFloatRange( 0.8, 1.2 );
		}

		level.drone_run_rate_multiplier = x;

		wait 1;
	}
}

//-- Glocke: added to help "robustify" the drone spawn system to control levels of detail
axis_drone_spawn( start_struct )
{
	//The start_struct that gets passed in is the starting struct for that particular drone path
	
	if( IsDefined(start_struct.script_string) && start_struct.script_string == "high_detail") //-- whatever condition you want, i'd suggest putting a script_string or something on the first struct
	{
		self character\c_vtn_nva1::main();
		self.burn_drone = true;
		self UseWeaponHideTags("ak47_sp");
	}
	else if( IsDefined(start_struct.script_string) && start_struct.script_string == "low_detail_burn")
	{
		self character\c_vtn_nva1_drone::main();
		start_struct.weaponinfo = "ak47_lowpoly_sp";
		self.burn_drone = true;
		self UseWeaponHideTags("ak47_lowpoly_sp");
	}
	else if( IsDefined(start_struct.script_string) && start_struct.script_string == "high_detail_swap")
	{
		self character\c_vtn_nva1::main();
		self.burn_drone = true;
		self.can_swap = true;
		self.has_vo = true;
		self UseWeaponHideTags("ak47_sp");
	}
	else if( IsDefined(start_struct.script_string) && start_struct.script_string == "low_detail_swap")
	{
		self character\c_vtn_nva1_drone::main();
		start_struct.weaponinfo = "ak47_lowpoly_sp";
		self.burn_drone = true;
		self.can_swap = true;
		self.has_vo = true;
		self UseWeaponHideTags("ak47_lowpoly_sp");
	}
	else
	{
		self character\c_vtn_nva1_drone::main();
		start_struct.weaponinfo = "ak47_lowpoly_sp";
		self.burn_drone = false;
		self.can_swap = false;
		self.has_vo = false;
		self UseWeaponHideTags("ak47_lowpoly_sp");
	}
}

//AUDIO
//doing this rather than adding it to spawn func so audio can adjust per event
//also because sound asset played can be a single or group sound
/*
all_drones - runs yell threads on all drones that are not yelling. default off; threads are made per even index drone
interval_wait - how long to wait until it waits for another spawn wave of drones -INT
vox_weight_min - min range of the random selector to weight single yell vs group yell -INT
vox_weight_max - max range of the random selector to weight single yell vs group yell -INT
vox_weight_median - define the weight value to have a yell or group yell -INT
wait_min - min wait to play a yell on a drone -FLOAT
wait_max - max wait to play a yell on a drone -FLOAT
*/
setup_drone_yells(all_drones, interval_wait, wait_min, wait_max, vox_weight_min, vox_weight_max, vox_weight_median)
{
	level endon("stop_setup_drone_yells");

	if(!IsDefined(all_drones))
	{
		all_drones = false;
	}

	//how long to wait when spawn
	if(!IsDefined(interval_wait))
	{
		interval_wait = 5;
	}
	else
	{
		assert((IsInt(interval_wait) || IsFloat(interval_wait)), "interval_wait must be an int or float");
	}

	//lets you adjust to wight asset preference. single or group yell
	if(IsDefined(vox_weight_min) || IsDefined(vox_weight_max) || IsDefined(vox_weight_median))
	{
		assert(IsInt(vox_weight_min), "vox_weight_min is not an int");
		assert(IsInt(vox_weight_max), "vox_weight_max is not an int");
		assert(IsInt(vox_weight_median), "vox_weight_median is not an int");
		assert(vox_weight_min < vox_weight_max, "vox_weight_min must be < vox_weight_max");
	}
	else
	{
		vox_weight_min = 0;
		vox_weight_max = 2;
		vox_weight_median = 0;
	}

	//how often to yell while alive
	if(IsDefined(wait_min) || IsDefined(wait_max))
	{
		assert(wait_min < wait_max, "wait_min must be < wait_max");
	}
	else
	{
		wait_min = 1;
		wait_max = 3;
	}



	while(1)
	{
		level waittill("new drone Spawn wave");
		drone = getentarray ("drone", "targetname");

		for	(i=0; i<drone.size; i++)
		{
			if(IsDefined(drone[i]))
			{
				//can only have one thread on a drone
				if(!IsDefined(drone[i].yelling))
				{
					//can either be all drones or even numbered indexes
					if(all_drones)
					{
						drone[i].yelling = true;
						drone[i] thread play_drone_yells(vox_weight_min, vox_weight_max, vox_weight_median, wait_min, wait_max);
					}
					else
					{
						if(even_number(i))
						{
							drone[i].yelling = true;
							drone[i] thread play_drone_yells(vox_weight_min, vox_weight_max, vox_weight_median, wait_min, wait_max);
						}
					}
				}
			}
		}

		wait(interval_wait);
	}
}

//self is drone
play_drone_yells(vox_weight_min, vox_weight_max, vox_weight_median, wait_min, wait_max)
{
	self endon("death");
	level endon("stop_drone_yells");

	while(IsAlive (self) )
	{	
		random_voice = randomintrange(vox_weight_min, vox_weight_max);
		if(random_voice == vox_weight_median)
		{	
			self playsound ("evt_drone_yell");
		}
		else
		{
			self playsound ("evt_drone_yell_dds");

		}
		wait(RandomFloatRange (wait_min, wait_max));	
	}
}

return_drum_type_array(pristine_targetname, blown_targetname)
{
	//prop swap
	drum_pristine = [];
	drum_blown = [];

	if(IsDefined(pristine_targetname))
	{
		drum_pristine = GetEntArray(pristine_targetname, "targetname");
		return drum_pristine;
	}

	if(IsDefined(blown_targetname))
	{
		drum_blown = GetEntArray(blown_targetname, "targetname");
		return drum_blown;
	}
}

ambient_mortar_explosion(struct_name, grp_name, wait_time, interval, range)
{
	if(!IsDefined(range))
	{
		range = 256;
	}

	//notified in e4b
	level endon("stop_mortars");
	transition_structs = getstructarray(grp_name, "targetname");
	mortar = [];

	for(i = 0; i < transition_structs.size; i++ )
	{
		mortar[i] = GetStruct(struct_name +i, "script_noteworthy");
	}

	wait wait_time;

	while(1)
	{
		spot = random(mortar);
		//activate_mortar( range, max_damage, min_damage, quake_power, quake_time, quake_radius, bIsstruct, effect, bShellShock )
		spot thread maps\_mortar::activate_mortar(range, 1, 0, 0.55, 2.0, 512, true, level._effect["e4_trans_mortar"], false);
		wait interval;
	}
}

spawners_crouch_prone()
{
	x = RandomIntRange(0, 9);
	if(x < 4)
	{
		self AllowedStances("prone", "crouch");
	}
	else
	{
		self AllowedStances("stand", "crouch");
	}
}

custom_rumble(rate, amount)
{
	for(i = 0; i < amount; i++ )		 
	{	
		level.player PlayRumbleOnEntity( "damage_heavy" );
		wait rate;
	}
}

//self is trigger or struct
fire_damage_player()
{
	if(IsDefined(self.classname) && self.classname == "trigger_multiple")
	{
		self endon("death");
	}
	
	if(IsDefined(self.script_string) && self.script_string == "flame_struct")
	{
		self endon("turn_off_fire_struct");
	}

	player_health = level.player.health;

	while(1)
	{
		if( (IsDefined(self.classname) && self.classname == "trigger_multiple" && level.player IsTouching(self)) 
			|| (IsDefined(self.script_string) && self.script_string == "flame_struct" && Distance(self.origin, level.player.origin) < self.radius)
			)
		{
			level.player PlaySound( "chr_body_burn_novo" );
			level.player DoDamage( (player_health * 0.15), level.player.origin, undefined, undefined, undefined, "MOD_BURNED");
			//level.player DoDamage((player_health * 0.15), level.player.origin);
			level.player PlayRumbleOnEntity( "damage_heavy" );
			wait 0.3;
		}

		wait 0.05;
	}
}

//self is ai
//use this to force a walk anim on ai
actor_force_walk(enable, run_anim)
{
	if(enable)
	{
		self set_run_anim(run_anim);
		self.disableExits = true;
		self.disableArrivals = true;
		self.disableTurns = true;
		self.disableReact = true;
	}
	else
	{
		self clear_run_anim();
		self.disableExits = false;
		self.disableArrivals = false;
		self.disableTurns = false;
		self.disableReact = false;
	}
}

//self is player
player_force_walk(enable)
{
	if(enable)
	{
		self SetLowReady(true);
		self AllowAds(false);
		self AllowCrouch(false); 
		self AllowJump(false);
		self AllowMelee(false);
		self AllowProne(false);
		self AllowSprint(false);
	}
	else
	{
		self SetLowReady(false);
		self AllowAds(true);
		self AllowCrouch(true); 
		self AllowJump(true);
		self AllowMelee(true);
		self AllowProne(true);
		self AllowSprint(true);
	}
}

//self is vehicle. run thread on vehicle to delete when at the end of path
cleanup_vehicle()
{
	level.player endon("death");
	self waittill("reached_end_node");
	self Delete();
}

provide_ammo(weapon_name)
{
	//kill thread on death of tank or level end
	level.player endon("death");
	self endon("death");

	//if player has rpg give max ammo to that weapon only. 	
	while( 1 )
	{
		weapon = level.player getcurrentweapon();

		while( level.player IsTouching( self ) == false )	
		{
			wait 0.5;
		}

		if( weapon == weapon_name)
		{
			wait( 0.05 );
			level.player GiveMaxAmmo(weapon);
		}

		wait( 0.5 );
	}	
}

//self is AI
set_goal_to_crouch_cqb()
{
	self endon("death");
	self change_movemode("cqb_sprint");
	self.ignoresuppression = true;
	self AllowedStances("crouch");
}

//self is AI
set_ignore_to_goal()
{
	self endon("death");

	self.ignoreall = true;
	self waittill("goal");
	self.ignoreall = false;
}

//self is tank
tank_switch_path(path, init_switch)
{
	self endon("death");

	timer = 0;
	tank_timer_wait = 8;
	stop_tank = true;

	self waittill("reached_end_node");
	self thread go_path(path);

	while(1)
	{
		if(init_switch)
		{
			vehicle_node_wait( "switch_it" , "script_noteworthy" );
			self SetSwitchNode( GetVehicleNode(path.targetname, "targetname"), GetVehicleNode(path.targetname +"_reverse", "targetname") );

			vehicle_node_wait( "switch_it" , "script_noteworthy" );
			self SetSwitchNode( GetVehicleNode(path.targetname +"_switch", "targetname"), GetVehicleNode(path.targetname +"_back", "targetname") );
		}
		else
		{
			if(stop_tank)
			{
				stop_tank = false;
				vehicle_node_wait( "stop_tank" , "script_noteworthy" );
				self SetSpeed(0, 10, 5);
			}

			if(timer > tank_timer_wait)
			{
				timer = 0;
				stop_tank = true;
				self ResumeSpeed(4);
				self SetSpeed(8, 8, 4);
			}

			timer += 0.05;
			
		}

		wait 0.05;
	}
}

//self is tank
tank_move_manager()
{
	level.player endon("death");
	self endon("death");
	half_damage = false;

	while(1)
	{
		self waittill("damage");

		if((self.health < (level.DEFAULT_TANK_HEALTH * 0.75)) && !half_damage)
		{
			self.damage_fx = Spawn("script_model", self.origin);
			self.damage_fx.angles = self.angles;
			self.damage_fx SetModel("tag_origin");
			self.damage_fx LinkTo(self);
			PlayFXOnTag(level._effect["fx_tank_damage"], self.damage_fx, "tag_origin");
			half_damage = true;
		}

		//self thread tank_angry();

		wait 0.05;
	}
}

//self is tank
tank_angry()
{
	level.player endon("death");
	self endon("death");	
	//SetSpeed( <speed>, <acceleration>, <deceleration> )
	//tank must keep moving
	//self SetSpeed(0, 5, 2.5);
	self.shoot_angry = true;

	wait 5;

	//self ResumeSpeed(1);
	self.shoot_angry = false;
}

//self is tank
tank_stop_move_on_death()
{
	level.player endon("death");
	self waittill("death");
	//self.damage_fx Delete();
	//self.obj_loc Delete();
	PlayFXOnTag(level._effect["fx_tank_dead"], self, "tag_origin");
	//self SetSpeed(0, 2, 1);
}

even_number(val)
{
	even = false;

	if(val % 2 == 0)
	{
		even = true;	
	}

	return even; 	
}

//self is heli
#using_animtree("generic_human");
heli_pilot_maker(no_cull)
{
	self.my_crew = [];
	
	self.my_crew = array_add(self.my_crew, spawn_fake_character(self.origin, (0,0,0), "huey_pilot_1"));	
	self.my_crew = array_add(self.my_crew, spawn_fake_character(self.origin, (0,0,0), "huey_pilot_2"));

	if(IsDefined(no_cull) && no_cull)
	{
		for(i = 0; i < self.my_crew.size; i++)
		{
			self.my_crew[i] SetForceNoCull();
		}
	}

	self.my_crew[0].animname = "huey_pilot_1";
	self.my_crew[1].animname = "huey_pilot_2";

	self.my_crew[0] LinkTo(self, "tag_driver");
	self.my_crew[1] LinkTo(self, "tag_passenger");


	for(i = 0; i < self.my_crew.size; i++ )
	{
		self.my_crew[i] UseAnimTree(#animtree);
		self.my_crew[i] thread anim_loop(self.my_crew[i], "huey_idle");
	}

	self waittill("death");

	array_delete(self.my_crew);
}

// Fake death
// self = the guy getting worked
//bloody_death( die, delay )
//{
//	self endon( "death" );
//
//	if( !isdefined( die ) )
//	{
//		die = true;	
//	}
//
//	if( IsDefined( self.bloody_death ) && self.bloody_death )
//	{
//		return;
//	}
//
//	if( !IsDefined(self) )
//	{
//		return;
//	}
//
//	self.bloody_death = true;
//
//	if( IsDefined( delay ) )
//	{
//		wait( RandomFloat( delay ) );
//	}
//
//	if( !IsDefined( self ) )
//	{
//		return;	
//	}
//
//	tags = [];
//	tags[0] = "j_hip_le";
//	tags[1] = "j_hip_ri";
//	tags[2] = "j_head";
//	tags[3] = "j_spine4";
//	tags[4] = "j_elbow_le";
//	tags[5] = "j_elbow_ri";
//	tags[6] = "j_clavicle_le";
//	tags[7] = "j_clavicle_ri";
//
//	for( i = 0; i < 3; i++ )
//	{
//		if( IsAlive(self) )
//		{
//			random = RandomInt(tags.size);
//			self thread bloody_death_fx( tags[random], undefined );
//			self PlaySound ("prj_bullet_impact_large_flesh");
//		}
//		wait( RandomFloat( 0.1 ) );
//	}
//
//	if( die && IsDefined(self) && IsAlive(self) )
//	{
//		self DoDamage( self.health + 100, self.origin);
//	}
//}	
//
//// self = the AI on which we're playing fx
//bloody_death_fx( tag, fxName ) 
//{ 
//	if( !IsDefined( fxName ) )
//	{
//		fxName = level._effect["bloody_death"][ RandomInt(level._effect["bloody_death"].size) ];
//	}
//
//	PlayFxOnTag( fxName, self, tag );
//}

//COPIED FROM VORKUTA UTIL FROM KDREW
//modified to add force deletion of exisiting drones
//made wait an option
//in an attempt to reduce script variable count, this should be called on drone triggers that are no longer needed
remove_drone_structs(trigger, force_delete, wait_time)
{
	if ( IsDefined( trigger.marked_for_deletion ) )  // don't allow multiple copies of this function to run - TravisJ 4/7/2011
	{
		return;
	}
	
	trigger.marked_for_deletion = 1;
	
	if(IsDefined(wait_time) && !IsString( wait_time ) )
	{
		trigger notify("stop_drone_loop");
		wait wait_time;
	}
	
	//deletes any existing drones
	if(IsDefined(force_delete) && force_delete)
	{
		drone_array = GetEntArray("drone", "targetname");

		for(i = 0; i < drone_array.size; i++)
		{
			if(IsDefined(drone_array[i]))
			{
				drone_array[i] thread maps\_drones::drone_delete();
			}
		}
	}

	path_starts = GetStructArray(trigger.target, "targetname");

	paths = [];
	for(i = 0; i < path_starts.size; i++)
	{
		j = 0;
		while(IsDefined(path_starts[i]) && IsDefined(path_starts[i].target))
		{
			paths[i][j] = path_starts[i];
			path_starts[i] = GetStruct(path_starts[i].target,"targetname");
			j++;
		}
	}

	for(i = 0; i < paths.size; i++)
	{
		for(j = 0; j < paths[i].size; j++)
		{
			remove_drone_struct(paths[i][j]);
		}
	}

	trigger Delete();
}

remove_drone_struct(struct)
{
	if ( IsDefined( struct.targetname ) )
	{
		if ( IsDefined( level.struct_class_names[ "targetname" ][ struct.targetname ] ) )
		{
			level.struct_class_names[ "targetname" ][ struct.targetname ] = undefined;
		}
	}
	if ( IsDefined( struct.target ) )
	{
		if ( IsDefined( level.struct_class_names[ "target" ][ struct.target ] ) )
		{
			level.struct_class_names[ "target" ][ struct.target ] = undefined;
		}
	}
	if ( IsDefined( struct.script_noteworthy ) )
	{
		if ( IsDefined( level.struct_class_names[ "script_noteworthy" ][ struct.script_noteworthy ] ) )
		{
			level.struct_class_names[ "script_noteworthy" ][ struct.script_noteworthy ] = undefined;
		}
	}
}

//from POW to give hint to use FLAMETHROWER
wait_player_gets_flamethrower()
{
	player = get_players()[0];

	while(!player HasWeapon("ak47_ft_sp"))
	{
		wait(0.05);
	}

	level thread flamethrower_hint();
}

flamethrower_hint()
{
	player = get_players()[0];

	total_time = 0;

	currentweapon = player GetCurrentWeapon();
	while(currentweapon == "none") //-- need to give the player time to actually switch to the weapon
	{
		currentweapon = player GetCurrentWeapon();
		wait(0.05);
	}

	screen_message_create(&"KHE_SANH_INSTRUCT_FT");

	while(currentweapon == "ak47_ft_sp" && total_time < 3.0)
	{
		currentweapon = player GetCurrentWeapon();

		if(currentweapon == "ft_ak47_sp")
		{
			break;
		}

		wait(0.05);
		total_time += 0.05;
	}

	screen_message_delete();
}

no_look_delete(delete_time)
{
	self endon("death");
	timer = 0;

	if(IsDefined(delete_time))
	{
		assert(IsInt( delete_time ), "delete_time must be an int");
	}

	while(IsDefined(self.origin) && level.player is_player_looking_at( self.origin, 0.5, false ) 
		&& ( IsDefined(delete_time) && (timer > delete_time) ) )
	{
		if(IsDefined(delete_time))
		{
			timer += 0.05;
		}
		wait 0.05;
	}

	if(IsDefined(self))
	{
		self Delete();
	}
}

//self is ai
ignore_settings()
{
	self set_ignoreall( true );
	self set_ignoreme( true );
}

khe_sanh_die()
{
	self dodamage( self.health + 1000, self.origin);

	if(self == level.player)
	{
		self Suicide();
	}
}

//taken from Flashpoint
///////////////////////////////////////////////////////////////////////////////////////
// Fade In/Out functions from Alex
///////////////////////////////////////////////////////////////////////////////////////
custom_fade_screen_out( shader, time )
{
	// define default values
	if( !isdefined( shader ) )
	{
		shader = "black";
	}

	if( !isdefined( time ) )
	{
		time = 2.0;
	}

	if( isdefined( level.fade_screen ) )
	{
		level.fade_screen Destroy();
	}

	level.fade_screen = NewHudElem(); 
	level.fade_screen.x = 0; 
	level.fade_screen.y = 0; 
	level.fade_screen.horzAlign = "fullscreen"; 
	level.fade_screen.vertAlign = "fullscreen"; 
	level.fade_screen.foreground = true;
	level.fade_screen SetShader( shader, 640, 480 );

	if( time == 0 )
	{
		level.fade_screen.alpha = 1; 
	}
	else
	{
		level.fade_screen.alpha = 0; 
		level.fade_screen FadeOverTime( time ); 
		level.fade_screen.alpha = 1; 
		wait( time );
	}
	level notify( "screen_fade_out_complete" );
}