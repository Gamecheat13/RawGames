#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_vehicle_utility;

/////////////////////////////////
// FUNCTION: main
// CALLED ON: level
// PURPOSE: sets up all relevant drone data structures and variables
// ADDITIONS NEEDED: None
/////////////////////////////////
main()
{
	character\char_rus_r_rifle::precache();
	character\char_ger_wrmcht_k98::precache();
	character\char_rus_h_reznov_coat::precache();
	character\char_rus_p_chernova::precache();
	precacheModel( "vehicle_rus_tracked_t34" );
	level.drone_spawnFunction["allies"] = character\char_rus_r_rifle::main;
	level.drone_spawnFunction["axis"] = character\char_ger_wrmcht_k98::main;
	level.droneCustomDeath = ::see2_drone_death;
	maps\_drones::init();
	
	level._effect["water_exploder"] = loadfx("weapon/tank/fx_tank_water");
	level._effect["dirt_exploder"] = loadfx("weapon/tank/fx_tank_dirt");
	level._effect["dummy_tank_fire"] = loadfx("weapon/muzzleflashes/fx_tank_t34_fire_flash");
	level._effect["dummy_tank_explode"] = loadfx("explosions/large_vehicle_explosion");
	
	level.num_drone_areas = 3;
	
	custom_level_run_cycles();
	see2_droneanim_init();
	level thread init_drone_manager();
	level thread start_drone_waves();
}

/////////////////////////////////
// FUNCTION: custom_level_run_cycles
// CALLED ON: level
// PURPOSE: sets up custom run cycles for drones
// ADDITIONS NEEDED: None
/////////////////////////////////
#using_animtree ("fakeshooters");
custom_level_run_cycles()
{
	// for demonstrating custom run cycles
	// these need to exist in fakeshooters, as well as have 
	// #using_animtree ("fakeshooters") be called above this function
	level.drone_run_cycle["run_deep_a"] 					= %ai_run_deep_water_a; 
	level.drone_run_cycle["run_deep_b"] 					= %ai_run_deep_water_b; 
	
	level.drone_trigger_spawn_time = 3;
}

/////////////////////////////////
// FUNCTION: wait_for_kill_trigger
// CALLED ON: level
// PURPOSE: Waits until a trigger is hit and then stops a particular areas drones
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_kill_trigger( areaNum )
{
	while( 1 )
	{
		self waittill( "trigger", guy );
		if( isPlayer( guy ) )
		{
			break;
		}
	}
	
	level.valid[areaNum] = false;
}

/////////////////////////////////
// FUNCTION: wait_for_master_trigger
// CALLED ON: level
// PURPOSE: Waits until a trigger is hit then starts the drones for a specific area
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_master_trigger( areaNum )
{
	while( 1 )
	{
		self waittill( "trigger", guy );
		if( isPlayer( guy ) )
		{
			break;
		}
	}
	
	level.valid[areaNum] = true;
}

/////////////////////////////////
// FUNCTION: start_drone_waves
// CALLED ON: level
// PURPOSE: Handles the spawning of drones and the playing of fx in all valid areas in the map
// ADDITIONS NEEDED: None
/////////////////////////////////
start_drone_waves()
{
	level.trigger_arrays = [];
	level.valid = [];
	
	for( i = 1; i <= level.num_drone_areas; i++ )
	{
		level thread do_random_explosions( i );
		level thread do_random_smoke( i );
		master_trigger = getEnt("area "+i+" master drone trigger", "script_noteworthy");
		master_trigger thread wait_for_master_trigger( i );
		level.trigger_arrays[i] = getEntArray( "area "+i+" drone trigger", "script_noteworthy" );
		level.valid[i] = false;
		kill_trigger = getEnt( "area "+i+" drone kill trigger", "script_noteworthy" );
		kill_trigger thread wait_for_kill_trigger( i );
	}
	
 	level waittill( "controls_active" );
 	
 	//NETWORK: possibility of just removing drones from co-op
 	if( get_players().size > 1 )
 	{
 		return;
 	}
	
	min_time_between_waves = 1;
	max_time_between_waves = 4;
	
	for( i = 1; i < level.num_drone_areas; i++ )
	{
		for( j = 0; j < level.trigger_arrays[i].size; j++ )
		{
			level.trigger_arrays[i][j].cooldown_timer = 0;
			level.trigger_arrays[i][j] thread do_cooldown();
		}
	}
	
	while( 1 )
	{
		players = get_players();
		for( k = 1; k <= level.num_drone_areas; k++ )
		{
			if( !level.valid[k] )
			{
				continue;
			}
			
			loop_size = level.trigger_arrays[k].size;
			
			//NETWORK: FULL REMOVAL OF DRONES DURING C0-OP
			//if(get_players().size > 1 && level.trigger_arrays[k].size > 2)
			//{
				loop_size = level.trigger_arrays[k].size - 2;
			//}
				
			//for( m = 0; m < level.trigger_arrays[k].size; m++ )
			for( m = 0; m < loop_size; m++ )
			{
				level.trigger_arrays[k][m] notify( "trigger" );
				wait_network_frame();
			}
		}
		wait( randomfloatrange( min_time_between_waves, max_time_between_waves ) );
	}
}

/////////////////////////////////
// FUNCTION: do_cooldown
// CALLED ON: a drone trigger
// PURPOSE: Counts down a timer used to invalidate a trigger for x seconds after spawn
// ADDITIONS NEEDED: None
/////////////////////////////////
do_cooldown()
{
	self endon( "kill drones" );
	
	while( 1 )
	{
		if( isDefined( self.cooldown_timer ) && self.cooldown_timer > 0 )
		{
			self.cooldown_timer -= 0.05;
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: find_best_drone_triggers
// CALLED ON: an entity
// PURPOSE: Finds the closest num valid triggers to an entity (in case multiple areas of drones are 
//          active or triggers are on cooldown)
// ADDITIONS NEEDED:
/////////////////////////////////
find_best_drone_triggers( num )
{
	best_dist = 10000000000;
	best_trigger = undefined;
	worst_dist = 0;
	worst_trigger = undefined;
	return_array = [];
	for( i = 0; i < level.drone_triggers.size; i++ )
	{
		if( !isDefined( level.drone_triggers[i].cooldown_timer ) || level.drone_triggers[i].cooldown_timer <= 0 )
		{
			dist = distanceSquared( level.drone_triggers[i].origin, level.centroid );
			if( dist < best_dist )
			{
				best_dist = dist;
				best_trigger = level.drone_triggers[i];
			}
			
			if( return_array.size < num || dist < worst_dist ) 
			{
				if( return_array.size == num )
				{
					return_array = array_remove( return_array, worst_trigger );
					return_array = array_add( return_array, level.drone_triggers[i] );
					worst_trigger = get_worst_drone_trigger( return_array );
					worst_dist = distanceSquared( worst_trigger.origin, level.centroid );
				}
				else
				{
					return_array = array_add( return_array, level.drone_triggers[i] );
				}
				if( dist > worst_dist )
				{
					worst_dist = dist;
					worst_trigger = level.drone_triggers[i];
				}
			}
		}
	}
	return return_array;
}

/////////////////////////////////
// FUNCTION: get_worst_drone_trigger
// CALLED ON: level
// PURPOSE: Gets the worst trigger for comparison
// ADDITIONS NEEDED: None
/////////////////////////////////
get_worst_drone_trigger( array )
{
	worst_dist = 0;
	worst_trigger = undefined;
	for( i = 0; i < array.size; i++ )
	{
		dist = distanceSquared( array[i].origin, level.centroid ) > worst_dist;
		if( dist )
		{
			worst_dist = dist;
			worst_trigger = array[i];
		}
	}
	return worst_trigger;
}

/////////////////////////////////
// FUNCTION: Remove drone triggers
// CALLED ON: level
// PURPOSE: Deletes drone triggers with a specific ID
// ADDITIONS NEEDED: None
/////////////////////////////////
remove_drone_triggers( remove_id )
{
	remove_list = [];
	for( i = 0; i < level.drone_triggers.size; i++ )
	{
		if( level.drone_triggers[i].script_string == remove_id )
		{
			remove_list = array_add( remove_list, level.drone_triggers[i] );
		}
	}
	
	for( j = 0; j < remove_list.size; j++ )
	{
		level.drone_triggers = array_remove( level.drone_triggers, remove_list[j] );
		remove_list[j] notify( "kill drones" );
		remove_list[j] delete();
	}
}

/////////////////////////////////
// FUNCTION: do_random_explosions
// CALLED ON: level
// PURPOSE: Plays dirt explosions and does radius damage to simulate artillery fire on a 
//          area's drones
// ADDITIONS NEEDED: None
/////////////////////////////////
do_random_explosions( wave )
{
	level endon( "stop wave "+wave );
	
	exploder_array = getEntArray( "exploder wave"+wave, "script_noteworthy" );
	
	while( 1 )
	{
		if( !isDefined( exploder_array ) || exploder_array.size < 1 )
		{
			break;
		}
		rand = randomintrange( 2, 5 );
		wait( rand );
		
		if( !level.valid[wave] )
		{
			continue;
		}
		
		rand = randomint( exploder_array.size-1 );
		if( exploder_array[rand].targetname == "dirt_exploder" )
		{
			playfx( level._effect["dirt_exploder"], exploder_array[rand].origin );
		}
		else
		{
			playfx( level._effect["water_exploder"], exploder_array[rand].origin );
		}
		radiusDamage( exploder_array[rand].origin, 500, 500, 500 );
	}
}

/////////////////////////////////
// FUNCTION: do_random_smoke
// CALLED ON: level
// PURPOSE: Spawns non-vision blocking smoke to cover drone advance for an area
// ADDITIONS NEEDED: None
/////////////////////////////////
do_random_smoke( wave )
{
	smoke_array = getEntArray( "smoke wave"+wave, "script_noteworthy" );
	for( i = 0; i < smoke_array.size; i++ )
	{
		smoke_array[i] thread do_smoke_at_intervals( wave );
	}
}

/////////////////////////////////
// FUNCTION: do_smoke_at_intervals
// CALLED ON: a smoke node
// PURPOSE: Plays the smoke grenade fx on a random distribution on a smoke node
// ADDITIONS NEEDED: None
/////////////////////////////////
do_smoke_at_intervals( wave )
{
	level endon( "stop wave "+wave );
	
	wait( randomintrange( 1, 22 ) );
	
	while( 1 )
	{
		if( level.valid[wave] )
		{
			playfx( level._effect["drone_smoke"], self.origin );
		}
		
		rand = randomintrange( 25, 30 );
		wait( rand );
	}
}

/////////////////////////////////
// FUNCTION: do_dummy_vehicles
// CALLED ON: level
// PURPOSE: Spawns dummy vehicles and moves them along a path, animates them and does fake firing
// ADDITIONS NEEDED: None
/////////////////////////////////
do_dummy_vehicles( wave, model, maxTimeBeforeDestroy, minSpeed, maxSpeed, staggerAmt )
{
	level.vehicle_starts = GetEntArray( "wave"+wave+" tank start", "script_noteworthy" );
	level.valid_path = [];
	
	for( i = 0; i < level.vehicle_starts.size; i++ )
	{
		level.valid_path = array_add( level.valid_path, true );
		thread do_single_dummy_vehicle( i, model, maxTimeBeforeDestroy, minSpeed, maxSpeed, staggerAmt );
		wait_network_frame();
	}
	
	level.static_vehicles = GetEntArray( "wave"+wave+" dummy tank", "script_noteworthy" );
	
	for( i = 0; i < level.static_vehicles.size; i++ )
	{
		level.static_vehicles[i] thread do_single_static_dummy_vehicle( model, maxTimeBeforeDestroy );
		wait_network_frame();
	}
}

/////////////////////////////////
// FUNCTION: do_single_static_dummy_vehicle
// CALLED ON: a dummy vehicle node
// PURPOSE: Creates a static dummy vehicle that will switch to a destroyed state after a 
//          random amount of time
// ADDITIONS NEEDED: None
/////////////////////////////////
do_single_static_dummy_vehicle( model, maxTimeBeforeDestroy )
{
	self endon( "destroy dummy vehicle" );
	myModel = spawn( "script_model", groundpos(self.origin) );
	myModel setModel( model );
	myModel.angles = self.angles;
	self thread wait_for_destroy( maxTimeBeforeDestroy, myModel );
	while( 1 )
	{
		wait( randomint( 6, 10 ) );
		playfxontag( level._effect["dummy_tank_fire"], myModel, "tag_flash" );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_destroy
// CALLED ON: a static dummy vehicle
// PURPOSE: Waits a random amount of time then tells the dummy vehicle to destroy itself.
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_destroy( maxTimeBeforeDestroy, model )
{
	if( maxTimeBeforeDestroy < 60 )
	{
		maxTimeBeforeDestroy = 60;
	}
	wait( randomfloat( 59, maxTimeBeforeDestroy ) );
	playfx( level._effect["dummy_tank_explode"], model.origin );
	model setModel( model.model+"_dmg" );
	self notify( "destroy dummy vehicle" );
}

/////////////////////////////////
// FUNCTION: do_single_dummy_vehicle
// CALLED ON: a start node
// PURPOSE: Spawns a vehicle, move it along the path, animates it and does fake firing
// ADDITIONS NEEDED: None
/////////////////////////////////
#using_animtree( "see2_models" );
do_single_dummy_vehicle( pathnum, model, maxTimeBeforeDestroy, minSpeed, maxSpeed, staggerAmt )
{
	// TODO: create endon for handling multiple paths working simultaneously
	wait( randomfloat( staggerAmt ) );
	speed = randomfloatrange( minSpeed, maxSpeed );
	time = 0;
	toNode = GetEnt( level.vehicle_starts[pathnum].target, "targetname" );
	fromNode = level.vehicle_starts[pathnum];
	toVec = toNode.origin - fromNode.origin;
	myModel = spawn( "script_model", fromNode.origin+(0,0,15) );
	myModel.angles = vectortoangles( toVec );
	myModel setModel( model );
	myModel.animname = "dummy";
	myModel setAnimTree();
	myModel notify( "stop anim" );
	myModel play_vehicle_anim( "tank_scan_straight" );
	myModel thread do_fake_firing();
	self thread run_timer( time );
	while( level.valid_path[pathnum] )
	{
		if( isDefined( fromNode.target ) )
		{
			toNode = GetEnt( fromNode.target, "targetname" );
			if( isDefined( fromNode.script_string ) )
			{
				myModel notify( "stop anim" );
				myModel play_vehicle_anim( fromNode.script_string );
			}
		}
		else
		{
			toNode = level.vehicle_starts[pathnum];
		}
		maxTime = distance( fromNode.origin, toNode.origin )/speed;
		goalAngles = vectortoangles( toNode.origin - fromNode.origin );
		if( toNode != level.vehicle_starts[pathnum] )
		{
			//origin notify( "stop lerping" );
			//origin thread lerpToOrient( goalAngles );
			myModel.goalAngles = myModel.angles;
			myModel thread smoothOrient( 0.1 );
			myModel thread lerpToPos( toNode.origin, speed, maxTime );
			//origin thread hug_ground( model );
			myModel waittill( "continue" );
		}
		else
		{
			myModel delete();
			myModel notify( "stop lerping" );
			wait( 1 );
			myModel = spawn( "script_model", toNode.origin );
			myModel setModel( model );
			myModel.angles = VectorToAngles( GetEnt(toNode.target, "targetname" ).origin - toNode.origin );
			myModel.animname = "dummy";
			myModel setAnimTree();
			myModel notify( "stop anim" );
			myModel play_vehicle_anim( "tank_scan_straight" );
			myModel thread do_fake_firing();
			wait( 0.05 );
		}
		if( time > maxTimeBeforeDestroy )
		{
			destroyDummyVehicle( pathnum, model, myModel );
		}
		else
		{
			percentToDestroy = time/maxTimeBeforeDestroy;
			rand = randomfloat( 1 );
			if( percentToDestroy > rand )
			{
				destroyDummyVehicle( pathnum, model, myModel );
			}
			else
			{
				fromNode = toNode;
			}
		}
	}
}

/////////////////////////////////
// FUNCTION: play_vehicle_anim
// CALLED ON: a dummy vehicle model
// PURPOSE: Animates the turret, the animation can be overridden by script_string values on 
//          path nodes
// ADDITIONS NEEDED: None
/////////////////////////////////
play_vehicle_anim( anime )
{
	self endon( "stop anim" );
	
	self SetFlaggedAnimKnobRestart( "blend_anim" + anime, level.scr_anim[self.animname][anime], 1, 0.2, 1 );
	self waittillmatch( "blend_anim" + anime, "end" );
}

/////////////////////////////////
// FUNCTION: do_fake_firing
// CALLED ON: a dummy vehicle model
// PURPOSE: Plays the firing fx on a random basis
// ADDITIONS NEEDED: None
/////////////////////////////////
do_fake_firing()
{
	while( isDefined( self ) )
	{
		playfxontag( level._effect["dummy_tank_fire"], self, "tag_flash" );
		wait( randomint( 6, 10 ) );
	}
}

/////////////////////////////////
// FUNCTION: destroyDummyVehcile
// CALLED ON: a dummy vehicle
// PURPOSE: Nothing, apparently
// ADDITIONS NEEDED: None
/////////////////////////////////
destroyDummyVehicle( pathnum, model, origin )
{
}

/////////////////////////////////
// FUNCTION: smoothOrient
// CALLED ON: a dummy vehicle model
// PURPOSE: Tries to smooth the vehicle's orientation to hug the ground and make any shift in
//          orientation more gradual to avoid jerkiness
// ADDITIONS NEEDED: Maybe allow for different amounts of deviation for pitch, yaw and roll
/////////////////////////////////
smoothOrient( max_dev_per_frame )
{
	self endon( "stop lerping" );
	
	while( 1 )
	{
		if( self.angles == self.goalAngles )
		{
			wait( 0.05 );
			continue;
		}
		else
		{
			normGoalAngles = angle_normalize180( self.goalAngles );
			normAngles = angle_normalize180( self.angles );
			diff1 =  self.goalAngles - self.angles;
			normGoalAngles = ( normGoalAngles[0], normGoalAngles[1], normGoalAngles[2] );
			normAngles = ( normAngles[0], normAngles[1], normAngles[2] );
			diff2 = normGoalAngles - normAngles;
			finalDiff = [];
			// first check if it is the -180/180 border
			for( i = 0; i < 3; i++ )
			{
				if( abs(diff1[i]) < abs(diff2[i]) )
				{
					finalDiff = array_add( finalDiff, diff1[i] );
				}
				else
				{
					finalDiff = array_add( finalDiff, diff2[i] );
				}
			}
			if( abs( finalDiff[0]) > max_dev_per_frame )
			{
				if( finalDiff[0] > 0 )
				{
					self.angles = (self.angles[0] + max_dev_per_frame, self.angles[1], self.angles[2]);
				}
				else
				{
					self.angles = (self.angles[0] - max_dev_per_frame, self.angles[1], self.angles[2]);
				}
			}
			else
			{
				self.angles = (self.goalAngles[0], self.angles[1], self.angles[2]);
			}
			
			if( abs( finalDiff[1]) > max_dev_per_frame )
			{
				if( finalDiff[1] > 0 )
				{
					self.angles = (self.angles[0], self.angles[1]+ max_dev_per_frame, self.angles[2]);
				}
				else
				{
					self.angles = (self.angles[0], self.angles[1]- max_dev_per_frame, self.angles[2]);
				}
			}
			else
			{
				self.angles = (self.angles[0], self.goalAngles[1], self.angles[2]);
			}
			
			
			if( abs(finalDiff[2]) > max_dev_per_frame )
			{
				if( finalDiff[2] > 0 )
				{
					self.angles = (self.angles[0], self.angles[1], self.angles[2]+max_dev_per_frame);
				}
				else
				{
					self.angles = (self.angles[0], self.angles[1], self.angles[2]-max_dev_per_frame);
				}
			}
			else
			{
				self.angles = (self.angles[0], self.angles[1], self.goalAngles[2]);
			}
			wait( 0.05 );
		}
	}
}

/////////////////////////////////
// FUNCTION: lerpToPos
// CALLED ON: a dummy vehicle model
// PURPOSE: Moves an entity to a point over time
// ADDITIONS NEEDED: None
/////////////////////////////////
lerpToPos( goalPos, speed, maxTime )
{
	self endon( "stop lerping" );
	startPos = self.origin;
	toVec = goalPos - self.origin;
	toVec = vectorNormalize( toVec );
	time = 0;
	
	while( 1 )
	{
		scaled_move = ( toVec[0] * speed * 0.05, toVec[1] * speed * 0.05, toVec[2] * speed * 0.05 );
		self.origin += scaled_move;
		self.origin = groundpos( self.origin + (0, 0, 100) );
		proj_loc = self.origin + scaled_move + (0, 0, 100);
		self.goalAngles = vectorToAngles( groundpos(proj_loc) - self.origin );
		wait( 0.05 );
		time += 0.05;
		if( vec_approx_equals( self.origin, startPos, goalPos, 0.05 ) || time > maxTime )
		{
			self notify( "continue" );
			break;
		}
	}
}

/////////////////////////////////
// FUNCTION: vec_approx_equals
// CALLED ON: level
// PURPOSE: Checks to see if the difference between two vectors is within a percent difference
//          of the difference between the second and another vector.
// ADDITIONS NEEDED: I am not sure exactly why I wrote this, but it seems to work
/////////////////////////////////
vec_approx_equals( vec, vec1, vec2, diff )
{
	// Need to fix this function
	if( abs(vec[0] - vec2[0]) <= abs(vec1[0]-vec2[0])*diff )
	{
		if( abs(vec[1] - vec2[1]) <= abs(vec1[1]-vec2[1])*diff )
		{
			if( abs(vec[2] - vec2[2]) <= abs(vec1[2]-vec2[2])*diff )
			{
				return true;
			} 
		}
	}
	return false;
}

/////////////////////////////////
// FUNCTION: run_timer
// CALLED ON: level
// PURPOSE: increments a time value
// ADDITIONS NEEDED: None
/////////////////////////////////
run_timer( time )
{
	wait( 0.05 );
	time += 0.05;
}

/////////////////////////////////
// FUNCTION: angle_normalize180
// CALLED ON: level
// PURPOSE: Normalizes a vec3 of angles to the [-180, 180] range
// ADDITIONS NEEDED: None
/////////////////////////////////
angle_normalize180( angles )
{	
	retAngles = [];
	for( i = 0; i < 3; i++ )
	{
		scaledAngle = angles[i] * (1.0 / 360.0);
		
		if( (scaledAngle + 0.5) > 1 )
		{
			floor = 1;
		}
		else
		{
			floor = 0;
		} 
		retAngles[i] = (scaledAngle - floor) * 360.0;
	}
	
	return retAngles;
}

/////////////////////////////////
// FUNCTION: see2_droneanim_init
// CALLED ON: level
// PURPOSE: Initializes drone animations to use in this level
// ADDITIONS NEEDED: None
/////////////////////////////////
#using_animtree ("generic_human");
see2_droneanim_init()
{
	//println("scriptprint - extra drone anims created");
	
	level.drone_anims[ "stand" ][ "idle" ]		= %drone_stand_idle;
	level.drone_anims[ "stand" ][ "run" ]			= %drone_stand_run;
	level.drone_anims[ "stand" ][ "reload" ]	= %exposed_crouch_reload;
	
	level.drone_anims[ "stand" ][ "death" ] = [];
	level.drone_anims[ "stand" ][ "death" ][0]	= %drone_stand_death;
	level.drone_anims[ "stand" ][ "death" ][1]	= %death_explosion_up10;
	level.drone_anims[ "stand" ][ "death" ][2]	= %death_explosion_back13;
	level.drone_anims[ "stand" ][ "death" ][3]	= %death_explosion_forward13;
	level.drone_anims[ "stand" ][ "death" ][4]	= %death_explosion_left11;
	level.drone_anims[ "stand" ][ "death" ][5]	= %death_explosion_right13;
	
	//-- explosions particular to pby ships
	level.drone_anims[ "stand" ][ "death" ][6]  = %ch_pby_explosion_back;
	level.drone_anims[ "stand" ][ "death" ][7]  = %ch_pby_explosion_front;
	level.drone_anims[ "stand" ][ "death" ][8]  = %ch_pby_explosion_right;
	level.drone_anims[ "stand" ][ "death" ][9]  = %ch_pby_explosion_left;
}

/////////////////////////////////
// FUNCTION: see2_drone_death
// CALLED ON: a drone
// PURPOSE: Checks for different damage types and plays appropriate death anims.
// ADDITIONS NEEDED: More support for burning deaths
/////////////////////////////////
see2_drone_death()
{
	self endon("no_drone_death_thread");
	//println("scriptprint - custom death thread running");
	
	if(!IsDefined(level.drone_death_queue))
	{
		ASSERT(false, "The drone death manager has not been inited");
	}
	
	drone = self;
	damage_type = self;
	damage_ori = self;
	death_index = 0;
	
	// Wait until the drone reaches 0 health
	while( isdefined( drone ) )
	{
		drone waittill( "damage", amount, attacker, damage_dir, damage_ori, damage_type);
		if ( drone.health <= 0 )
		{
			break;
		}
		
		if( damage_type == "MOD_BURNED" )
		{
			break;
		}
	}
	
	println(damage_type);
	
	if(damage_type == "MOD_PROJECTILE" || damage_type == "MOD_PROJECTILE_SPLASH")
	{
		drone.special_death_fx = "drone_burst";
	}
	
	drone unlink();
	
	if(damage_type == "MOD_EXPLOSIVE" || damage_type == "MOD_PROJECTILE_SPLASH" )
	{
		/*
		ref_point = [];
		ref_point[0] = drone.origin + ( AnglesToForward(drone.angles) * 5 ); 	//front
		ref_point[1] = drone.origin + ( AnglesToForward(drone.angles) * -5 ); //rear
		ref_point[2] = drone.origin + ( AnglesToRight(drone.angles) * -5 ); 	//left
		ref_point[3] = drone.origin + ( AnglesToRight(drone.angles) * 5 );  	//right
		
		closest_point = ref_point[0];
		index = 0;
		
		for(i = 1 ; i < ref_point.size; i++)
		{
			if(Distance(ref_point[i], damage_ori) < Distance(closest_point, damage_ori))
			{
				closest_point = ref_point[i];
				index = i;
			}
		}
		
		//Figure out if the drone is falling off of a ship or not
		new_point = 0;
		trace = 0;
		
		switch(index) //index 0/forward, 1/back, 2/left, 3,right
		{
			case 0:
				new_point = drone.origin + (AnglesToForward(drone.angles) * 264);
				drone.angles = VectorToAngles(damage_ori - drone.origin);		
			break;
			case 1:
				new_point = drone.origin + (AnglesToForward(drone.angles) * -264);
				drone.angles = VectorToAngles(drone.origin - damage_ori);		
			break;
			case 2:
				new_point = drone.origin + (AnglesToRight(drone.angles) * -264);
				drone.angles = VectorToAngles(damage_ori - drone.origin) - (0, 90, 0);		
			break;
			case 3:
				new_point = drone.origin + (AnglesToRight(drone.angles) * 264);
				drone.angles = VectorToAngles(damage_ori - drone.origin) + (0, 90, 0);		
			break;
		}
		trace = BulletTrace(new_point, new_point - (0,0,2000), true, undefined);
		
		//-- stopped here to go to lunch, you want to check the traces vertical position and then decide which animation to play
		if(trace["position"][2] < (new_point[2] - 32))
		{
			switch(index)
			{
				case 0:
					index = 4;
				break;
				case 1:
					index = 5;
				break;
				case 2:
					index = 6;
				break;
				case 3:
					index = 7;
				break;
			}
		}
		*/
		index = randomint( 4 );
		//-- decide which death anim to play
		switch(index)
		{
			case 0:
				death_index = 2;	// [3]	= %death_explosion_forward13;
			break;
			case 1:
				death_index = 3;	// [2]	= %death_explosion_back13;
			break;
			case 2:
				death_index = 5; 	// [4]	= %death_explosion_left11;
			break;
			case 3:
				death_index = 4;	// [5]	= %death_explosion_right13;
			break;
			case 4:
				death_index = 6; //front
			break;
			case 5:
				death_index = 7; //back
			break;
			case 6:
				death_index = 8; //left
			break;
			case 7:
				death_index = 9; //right
			break;
		}
		
		if(IsDefined(drone.combust))
		{
			drone thread torch_ai(0.1);
		}
	}
	else if( damage_type == "MOD_BURNED" )
	{
		drone thread torch_ai(0.1);
		death_index = 0;
	}
	else
	{
		death_index = 0;
	}
		
	// Make drone die
	drone notify( "death" );
	drone stopAnimScripted();
	
	if(IsDefined(drone.special_death_fx))
	{
		drone.special_death_fx = "drone_burst";
		PlayFXOnTag(level._effect[drone.special_death_fx], drone, "J_SpineLower");
	}
	
	drone.need_notetrack = true;
	drone maps\_drone::drone_play_anim( level.drone_anims[ "stand" ][ "death"][death_index] );
	
	
	drone add_me_to_the_death_queue();
	/*
	wait 10;
	
	if ( isdefined( drone ) )
		drone delete();
	*/
}

/////////////////////////////////
// FUNCTION: add_me_to_death_queue
// CALLED ON: a drone
// PURPOSE: Tells the drone manager that the drone needs to be killed
// ADDITIONS NEEDED: None
/////////////////////////////////
add_me_to_the_death_queue()
{
	level.drone_death_queue[level.drone_death_queue.size] = self;
	level notify("drone_manager_process");
}

/////////////////////////////////
// FUNCTION: init_drone_manager
// CALLED ON: level
// PURPOSE: inits the drone manager that handles drone deaths, etc
// ADDITIONS NEEDED: None
/////////////////////////////////
init_drone_manager()
{
	MAX_DEAD_DRONES = 10;
	level.drone_death_queue = [];
	
	while(1)
	{
		level waittill("drone_manager_process");
		
		if(level.drone_death_queue.size > MAX_DEAD_DRONES)
		{
			while( level.drone_death_queue.size > MAX_DEAD_DRONES )
			{
				removed_guy = level.drone_death_queue[0];
				new_drone_queue = [];
				
				for( i = 1 ; i < (level.drone_death_queue.size); i++)
				{
					new_drone_queue[i-1] = level.drone_death_queue[i];
				}
				
				if(IsDefined(removed_guy))
				{
					removed_guy Delete();
				}
				level.drone_death_queue = new_drone_queue;
			}
		}
		//else
		//{
			//-- we are ok on the number of dead drones
		//}
	}
}

/////////////////////////////////
// FUNCTION: torch_ai
// CALLED ON: a drone
// PURPOSE: lights an AI on Fire
// ADDITIONS NEEDED: None
/////////////////////////////////
torch_ai( delay )
{
	tagArray = [];
	tagArray[tagArray.size] = "J_Wrist_RI";
	tagArray[tagArray.size] = "J_Wrist_LE";
	tagArray[tagArray.size] = "J_Elbow_LE";
	tagArray[tagArray.size] = "J_Elbow_RI";
	tagArray[tagArray.size] = "J_Knee_RI";
	tagArray[tagArray.size] = "J_Knee_LE";
	tagArray[tagArray.size] = "J_Ankle_RI";
	tagArray[tagArray.size] = "J_Ankle_LE";

	tagArray = maps\_utility::array_randomize( tagArray );
	for( i = 0; i < 3; i++ )
	{
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[i] );

		if( IsDefined( delay ) )
		{
			wait( delay );
		}
	}

	PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" );
}