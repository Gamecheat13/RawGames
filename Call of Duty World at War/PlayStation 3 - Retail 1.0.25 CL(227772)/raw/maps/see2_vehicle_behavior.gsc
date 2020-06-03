#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_vehicle_utility;

///////////////////////////////////
// UTILITY FUNCTIONS
///////////////////////////////////

////////////////////////////////////
// FUNCTION: retreat_truck`_behavior
// CALLED ON: a covered opel blitz truck
// PURPOSE: Sends a truck ahead to a rally point, waits until a trigger associated with the
//          rally point is hit then proceeds to the next rally point.
// ADDITIONS NEEDED: None
///////////////////////////////////
retreat_truck_behavior()
{
	self endon( "death" );
	
	self thread do_death_fx();
	
	if( self.health <= 0 )
	{
		return;
	}
	
	self.health = 100;
	self thread retreat_truck_behavior_node_kill();
	self thread retreat_truck_player_hit_me();
	
	movetrigger = GetEnt( self.script_noteworthy+" move trigger", "script_noteworthy" );
	
	movetrigger waittill( "trigger" );
	level notify( "retreaters", self );
	
	if( !IsDefined( self.script_string ) )
	{
		for( i = 0; i < level.retreat_points.size; i++ )
		{
			if( isDefined( self ) && self.health > 0 && self.classname != "script_vehicle_corpse" ) 
			{
				wait_node = getVehicleNode( self.script_noteworthy+" "+level.retreat_points[i]+" wait", "script_noteworthy" );
				
				if( isDefined( wait_node ) )
				{
					self setWaitNode( wait_node );
					self waittill( "reached_wait_node" );
					oldspeed = self GetSpeedMPH();
					self setSpeed( 0, 6, 6 );
					while( 1 )
					{
						if( !array_check_for_dupes( level.invalid_retreat_points, "stop "+level.retreat_points[i] +" wait") )
						{
							break;
						}
						wait( 0.05 );
					}
					self setSpeed( oldSpeed, oldSpeed/2 );
					level notify( "retreaters", self );
				}
				else
				{
					wait(0.5);
				}
			}
		}
	}
	else
	{
		//-- Empty I think... this retreater was never going to make it anyways
	}
}

retreat_truck_player_hit_me()
{
	self endon( "death" );
	
	while(1)
	{
		self waittill("damage", amt, guy, direction, origin, damage_type);
		
		if(damage_type == "MOD_PROJECTILE")
		{
			if(IsPlayer(guy))
			{
				self notify("death");
			}
		}
	}
}

//Glocke: Built this function to keeps trucks and tanks from running into each other
retreat_truck_behavior_node_kill()
{
	self endon( "death" );
	
	self waittill( "kill retreat truck node" );
	
	self.health = 1;
	radiusDamage( self.origin, 256, 200, 200 );
}

/////////////////////////////////
// FUNCTION: do_death_fx
// CALLED ON: an opel truck
// PURPOSE: Plays gibbing explosion if the game is not PG
// ADDITIONS NEEDED: None
/////////////////////////////////
do_death_fx()
{
	self waittill( "death" );
	
	if( is_mature() )
	{
		playfx( level._effect["truck_gib_explode"], self.origin );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_global_trigger
// CALLED ON: level
// PURPOSE: Waits until the trigger flagged area # all is hit then activates all remaining tanks in
//          the area
// ADDITIONS NEEDED: None 
/////////////////////////////////
wait_for_global_trigger( area )
{
	all_trigger = GetEnt( "area "+area+" trigger all", "script_noteworthy" );
	trigger_array = GetEntArray( "area "+area+" trigger" );
	all_trigger waittill( "trigger" );
	for( i = 0; i < trigger_array.size; i++ )
	{
		if( isDefined( trigger_array[i] ) )
		{
			trigger_array[i] notify( "trigger" );
		}
	}
}

/////////////////////////////////
// FUNCTION: see2_veh_death_thread
// CALLED ON: panzers, tigers and panthers
// PURPOSE: This is used to play the custom fx that pop the vehicle turret, or just
//          do the standard vehicle model swap. Turret pops happen on a percent basis based on 
//          which kind of tank has died.
// ADDITIONS NEEDED: The function used to spawn a turret model if the turret pop did not occur. 
//                   This was causing intersecting physics solids and was killing the framerate
//                   so we need to do a model swap to the whole destroyed model here in a way
//                   that doesn't interfere with the rest of the vehicle death script stuff.
/////////////////////////////////
see2_veh_death_thread()
{
	level notify( "destruction" );
	turret_model = undefined;
	turret_fx = undefined;
	pop_threshold = 100;
	if( self.vehicletype == "see2_panzeriv" )
	{
		turret_model = "vehicle_ger_tracked_panzer4_d_turret";
		turret_fx = "panzer_turret_fly";
		pop_threshold = 50;
	}
	else if( self.vehicletype == "see2_tiger" )
	{
		turret_model = "vehicle_ger_tracked_king_tiger_d_turret";
		turret_fx = "tiger_turret_fly";
		pop_threshold = 80;
	}
	else if( self.vehicletype == "see2_panther" )
	{
		turret_model = "vehicle_ger_tracked_panther_d_turret";
		turret_fx = "panther_turret_fly";
		pop_threshold = 60;
	}
	
	rand = randomint( 100 );
	
	if( !isDefined( turret_fx ) || !isDefined( turret_model ) )
	{
		return;
	}
	
	if( rand > pop_threshold )
	{
		playfxontag( level._effect[turret_fx], self, "tag_turret" );
	}
	else
	{
		/*
		turret = spawn("script_model", self.origin);
		turret.angles = self GetTagAngles( "tag_turret" );
		turret.origin = self GetTagOrigin( "tag_turret" );
		turret setmodel(turret_model);
		*/
	}
}

/////////////////////////////////
// FUNCTION: do_tarp_flap
// CALLED ON: an animated artillery cover tarp.
// PURPOSE: This causes the tarp to animate and flap whenever the artillery fires a shot
// ADDITIONS NEEDED: None
/////////////////////////////////
#using_animtree( "see2_models" );
do_tarp_flap()
{
	self endon( "stop tarp" );
	self.animname = "arty tarp";
	self UseAnimTree( #animtree );
	targetEnt = undefined;
	while( 1 )
	{
		while( !isDefined( targetEnt ) )
		{
			targetEnt = GetEnt(self.target, "targetname");
			wait( 0.05 );
		}
		targetEnt waittill( "turret_fire" );
		self anim_single_solo( self, "fire_flap" );
		wait( 0.05 );
	}
}


/////////////////////////////////
// FUNCTION: cleanup tarp
// CALLED ON: an animated artillery cover tarp
// PURPOSE: This deletes the tarp when the artillery is destroyed
// ADDITIONS NEEDED: None
/////////////////////////////////
cleanup_tarp()
{
	targetEnt = undefined;

	while( !isDefined( targetEnt ) )
	{
		targetEnt = GetEnt(self.target, "targetname");
		wait( 0.05 );
	}
	targetEnt waittill( "death" );
	self notify( "stop tarp" );
	wait( 0.1 );
	
	if(IsDefined(self.script_string))
	{
		sticks = [];
		sticks = GetEntArray( self.script_string, "targetname" );
		for(i=0; i < sticks.size; i++)
		{
			sticks[i] Delete();
		}
	}
	
	self delete();
}

/////////////////////////////////
// FUNCTION: do_arty_spawn
// CALLED ON: level
// PURPOSE: This spawns all artillery for an area. It also sets up the artillery count that is
//          used to handle the destroy artillery objective. 
// ADDITIONS NEEDED: Need to clean up the artillery tarps for non spawned artillery here
/////////////////////////////////
do_arty_spawn( areaNum )
{
	extra_count = 0;
	num_extra = get_players().size - 1;
	trigger_array = getEntArray( "arty"+areaNum+" trigger", "targetname" );
	for( i = 0; i < trigger_array.size; i++ )
	{
		should_spawn = false;
		if( !isDefined( trigger_array[i].script_noteworthy ) )
		{
			should_spawn = true;
		}
		// Check to see if this is one of the artillery (targetnames arty 5 and arty 6). If it is, only spawn it if we have extra coop players
		else if( isDefined( trigger_array[i].script_noteworthy ) && trigger_array[i].script_noteworthy == "extra" && extra_count < num_extra )
		{
			extra_count++;
			should_spawn = true;
		}
		// If it is extra and we have already spawned as many extra as we have coop players, hide the base and don't spawn it.
		else
		{
			//base = getEnt( trigger_array[i].script_string, "script_noteworthy" );
			//base hide();
		}

		// Do gated spawn
		if( should_spawn )
		{
			trigger_array[i] notify( "trigger" );
			wait_network_frame();
		}
	}
	
	wait( 1 );
	
	for( j = 1; j < 6; j++ )
	{
		arty = getEnt( "arty "+j, "targetname" );
		
		if( isDefined( arty ) )
		{
			level.enemy_armor = array_add( level.enemy_armor, arty );
			arty thread cleanup_targeting();
		}
	}
}

/////////////////////////////////
// FUNCTION: self_inform_on_damage_trigger
// CALLED ON: a vehicle who will retreat	
// PURPOSE: It waits until a player uses explosive damage against a damage trigger (usually at 
//					the same point as the tank) and then triggers the tank's move trigger performing a
//          strategic retreat *See tank targetname lineveh 8 group0 to see an example of this*
// ADDITIONS NEEDED: None
/////////////////////////////////
self_inform_on_damage_trigger( event ) 
{
	while( 1 )
	{
		self waittill( "damage", damage, other, direction, origin, damage_type );
		if ( maps\see2::explosive_damage( damage_type ) )
		{
			if( isDefined( other.script_team ) && other.script_team == "allies" )
			{
				self notify( event );
				return;
			}
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: check_for_player_proximity
// CALLED ON: a moving vehicle
// PURPOSE: This causes a vehicle to stop if a player reaches a specific distance from them
// ADDITIONS NEEDED: We may want to add a boolean to allow the tank to speed up if the player
//                   moves outside of the specified radius.
/////////////////////////////////
check_for_player_proximity( distance )
{
	self endon( "death" );
	
	while( !isDefined( get_players() ) )
	{
		wait( 0.05 );
	}
	
	while( 1 )
	{
		for( i = 0; i < get_players().size; i++ )
		{
			if( distancesquared( get_players()[i].origin, self.origin ) < (distance * distance) ) 
			{
				speed = self getSpeedMPH();
				if( speed > 0 )
				{
					self setSpeed( 0, speed/3, speed/2 );
				}
				return;
			}
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: setup_spawngroup_generics
// CALLED ON: level
// PURPOSE: This spawns all the relevant vehicles for an area. Currently there are 4 areas
//					group0 - area1 - Destroy artillery area
//					group1 - area2 - Destroy Radiotower area
//					group2 - area3 - Hardpoint/fuel depot
//					group3 - area4 - Take Train station
// ADDITIONS NEEDED: Need to set up any addition moving or firing behaviors desired here.
/////////////////////////////////
setup_spawngroup_generics( groupnum )
{
	max_group_tanks = 12;
	level waittill( "area"+groupNum+" spawned" );
	// Wait for spawn to finish
	wait( 1 );
	
	// setup looping tanks
	for( i = 0; i < max_group_tanks; i++ )
	{
		tank = GetEnt( "loopveh "+i+" group"+groupNum, "script_noteworthy" );
		if( isDefined( tank ) ) 
		{
			approach = tank check_for_approach( i, groupnum );
			if( !approach )
			{
				tank thread loop_movement_behavior(undefined, undefined, i, groupnum);
			}
			tank thread moving_firing_behavior();
			tank thread do_intermediate_damage_states();
			level.enemy_armor = array_add( level.enemy_armor, tank );
			tank thread cleanup_targeting();
		}
		else
		{
			continue;
		}
	}
	
	// setup advance_retreat tanks
	for( i = 0; i < max_group_tanks; i++ )
	{
		tankname = "advance_retreat "+i+" group"+groupNum;
		tank = getEnt( tankname, "script_noteworthy" );
		if( isDefined( tank ) ) 
		{
			tank thread advance_retreat_behavior( i, groupNum );
			tank thread moving_firing_behavior();
			tank thread do_intermediate_damage_states();
			level.enemy_armor = array_add( level.enemy_armor, tank );
			tank thread cleanup_targeting();
		}
		else
		{
			continue;
		}
	}
	
	// setup linear tanks
	for( i = 0; i < max_group_tanks; i++ )
	{
		tank = GetEnt( "lineveh "+i+" group"+groupNum, "script_noteworthy" );
		if( isDefined( tank ) ) 
		{
			tank thread linear_movement_behavior(undefined, undefined, i, groupNum);
			tank thread moving_firing_behavior();
			tank thread do_intermediate_damage_states();
			level.enemy_armor = array_add( level.enemy_armor, tank );
			tank thread cleanup_targeting();
		}
		else
		{
			continue;
		}
	}
	
	// setup linear tanks with backing up
	for( i = 0; i < max_group_tanks; i++ )
	{
		tank = GetEnt( "lineveh_with_backup "+i+" group"+groupNum, "script_noteworthy" );
		if( isDefined( tank ) ) 
		{
			tank thread linear_movement_behavior_adjusted(undefined, undefined, i, groupNum);
			tank thread moving_firing_behavior();
			tank thread do_intermediate_damage_states();
			level.enemy_armor = array_add( level.enemy_armor, tank );
			tank thread cleanup_targeting();
		}
		else
		{
			continue;
		}
	}
	
	
	// setup static tanks
	for( i = 0; i < max_group_tanks; i++ )
	{
		tank = GetEnt( "staticveh "+i+" group"+groupNum, "script_noteworthy" );
		if( isDefined( tank ) ) 
		{
			tank thread static_firing_behavior();
			tank thread do_intermediate_damage_states();
			level.enemy_armor = array_add( level.enemy_armor, tank );
			tank thread cleanup_targeting();
		}
		else
		{
			continue;
		}
	}
	
	if( groupnum == 3 )
	{
		level thread maps\see2::setup_airstrike_planes();
	}
	
	//setup tank retreats
	level thread do_vehicle_retreats( groupNum );
}

/////////////////////////////////
// FUNCTION: do_intermediate_damage_states
// CALLED ON: a vehicle
// PURPOSE: When the vehicle reaches below half health, it will do a model swap and play a looping
//          smoke fx on the vehicle
// ADDITIONS NEEDED: The model swap is currently disabled due to issues with vehicle systems not
//                   recognizing the intermediate damaged model.
/////////////////////////////////
do_intermediate_damage_states()
{
	self endon( "death" );
	int_damage_model = undefined;
	int_dmg_fx = undefined;
	max_health = 100000000000;
	damage_count = 0;
	if( self.vehicletype == "see2_panzeriv" )
	{
		int_damage_model = "vehicle_ger_tracked_panzer4v1_dmg1";
		int_dmg_fx = "panzer_int_dmg";
		max_health = 1000;
	}
	if( self.vehicletype == "see2_panther" )
	{
		int_damage_model = "vehicle_ger_tracked_panther_dmg1";
		int_dmg_fx = "panther_int_dmg";
		max_health = 2000;
	}
	if( self.vehicletype == "see2_tiger" )
	{
		int_damage_model = "vehicle_ger_tracked_king_tiger_dmg1";
		int_dmg_fx = "tiger_int_dmg";
		max_health = 3000;
	}
	if( self.vehicletype == "see2_t34" )
	{
		int_damage_model = "vehicle_rus_tracked_t34_dmg1";
		int_dmg_fx = "t34_int_dmg";
		max_health = 2000;
	}
	if( self.vehicletype == "see2_t34" )
	{
		int_damage_model = "veh_rus_tracked_ot34_dmg1";
		max_health = 3000;
	}
	
	while( 1 )
	{
		self waittill( "damage", amount );
		if( damage_count >= (max_health/2) )
		{
			//self setModel( int_damage_model );
			if( isDefined( int_dmg_fx ) )
			{
				self thread play_int_dmg_fx( int_dmg_fx );
			}
			break;
		}
		else
		{
			damage_count += amount;
		}
	}
}


/////////////////////////////////
// FUNCTION: play_int_dmg_fx
// CALLED ON: vehicle
// PURPOSE: This is a threaded function that plays the intermediate damage fx for a tank
//          until it is destroyed
// ADDITIONS NEEDED: None
/////////////////////////////////
play_int_dmg_fx( fx_name )
{
	self endon( "death" );
	while( 1 )
	{
		playfxontag( level._effect[fx_name], self, "tag_origin" );
		wait( 0.3 );
	}
}

///////////////////////////////////
// MOVEMENT FUNCTIONS
///////////////////////////////////

/////////////////////////////////
// FUNCTION: advance_retreat_behavior
// CALLED ON: a vehicle 
// PURPOSE: This causes a vehicle to advance along a path once its move trigger has been hit. Once
//					it has reached a percent damage globally chosen for the level, it finds the nearest
//					retreat node belonging to it, sets up the switchNode system and begins backing up on
//          the retreat path
// ADDITIONS NEEDED: Path switching still kind of looks bad, needs a second pass and needs speed
//									 scaling prior to doing the switch.
// CHANGES MADE:
//					This behavior had functionality problems if a tank had already reached the very end of it's path.						
/////////////////////////////////
advance_retreat_behavior( identifier, groupNum )
{
	self endon( "death" );
	
	self thread check_for_player_proximity( 1500 );
	
	self thread wait_for_retreat( identifier, groupNum);
	start_node = getVehicleNode( self.target, "targetname" );
	self.curr_node = getVehicleNode( start_node.target, "targetname" );
	
	end_node = getVehicleNode( "line "+identifier+" group"+groupNum+" advance end", "script_noteworthy" );
	switch_node = getVehicleNode( "line "+identifier+" group"+groupNum+" retreat start", "script_noteworthy" );
	
	while( 1 )
	{
		self setWaitNode( self.curr_node );
		
		self waittill( "reached_wait_node" );
		
		self.curr_node = getVehicleNode( self.curr_node.target, "targetname" );
		
		//-- Glocke: fix for the retreat breaking if the tank actually reached it's last node
		if( !IsDefined(self.curr_node.target) )
		{
			self SetSpeed( 0, 100, 100 ); // stop the tank, because later we will need to set a switchnode and then resume speed
		}
		
	}
}

/////////////////////////////////
// FUNCTION: wait_for_retreat
// CALLED ON: a vehicle running advance_retreat functionality
// PURPOSE: Waits until the damage threshold has been reached and starts vehicle retreating
// ADDITIONS NEEDED: Do a speed scale when changing directions
/////////////////////////////////
wait_for_retreat( identifier, groupNum )
{
	self endon( "death" );
	
	retreat_nodes = getVehicleNodeArray( "retreat "+identifier+" group"+groupNum, "script_noteworthy" ); 
	
	if( retreat_nodes.size < 1 )
	{
		return;
	}		
	
	best_node = undefined;
	best_dist = 10000000000;
	while( 1 )
	{
		self waittill( "damage" );

		if( ((self.health-self.healthbuffer) / (self.maxhealth-self.healthbuffer)) <= level.retreat_threshold )
		{
			for( i = 0; i < retreat_nodes.size; i++ )
			{
				dist = distanceSquared( retreat_nodes[i].origin, self.origin );
				if( dist < best_dist ) 
				{
					best_node = retreat_nodes[i];
					best_dist = dist;
				}
			}
			
			if( isDefined( best_node ) )
			{
				if( self getSpeed() > 0 )
				{
					self setSwitchNode( self.curr_node, best_node );
					self.curr_node = best_node;
					self setWaitNode( best_node );
				}
				else
				{
					//-- In this case the best node is no longer accurate, we need a node
					//-- that is close to the location of the switchnode, not the location of the tank.
					for( i = 0; i < retreat_nodes.size; i++ )
					{
						dist = distanceSquared( retreat_nodes[i].origin, self.curr_node.origin );
						if( dist < best_dist ) 
						{
							best_node = retreat_nodes[i];
							best_dist = dist;
						}	
					}
					
					self setSwitchNode( self.curr_node, best_node );
					self.curr_node = best_node;
					self setWaitNode( best_node );
					self ResumeSpeed( 5 );
				}
			}
			
			break;
		}
	}
}

/////////////////////////////////
// FUNCTION: check_for_approach
// CALLED ON: a vehicle running looping movement behavior
// PURPOSE: This checks to see if there is a linear approach to a patrol loop and navigates this
//				  approach if it exists
// ADDITIONS NEEDED: None
/////////////////////////////////
check_for_approach( identifier, groupNum, signalArray )
{
	if( isDefined( groupNum ) )
	{
		startLeadin = "loop "+identifier+" group"+groupNum+" leadin start";
		endLeadin = "loop "+identifier+" group"+groupNum+" leadin end";
		beginLoop = "loop "+identifier+" part0 group"+groupNum+ " start";
	}
	else
	{
		startLeadin = "loop "+identifier+" leadin start";
		endLeadin = "loop "+identifier+" leadin end";
		beginLoop = "loop "+identifier+" part0 start";
	}
	approachStartNode = GetVehicleNode( startLeadin, "script_noteworthy" );
	approachEndNode = GetVehicleNode( endLeadin, "script_noteworthy" );
	if( isDefined( approachStartNode ) && isDefined( approachEndNode ) )
	{
		self thread do_approach_to_loop( endLeadin, beginLoop, identifier, groupNum, signalArray );
		return true;
	}
	else
	{
		return false;
	}
}

/////////////////////////////////
// FUNCTION: do_approach_to_loop
// CALLED ON: a loop vehicle
// PURPOSE: Causes the vehicle to move along the approach path until it reaches the end, then
//          it switches to the loop
// ADDITIONS NEEDED: None
/////////////////////////////////
do_approach_to_loop( endLeadin, beginLoop, identifier, groupNum, signalArray )
{
	destNode = GetVehicleNode( endLeadin, "script_noteworthy" );
	switchNode = GetVehicleNode( beginLoop, "script_noteworthy" );
	self thread moving_firing_behavior();
	self setSwitchNode( destNode, switchNode );
	self setWaitNode( switchNode );
	self waittill( "reached_wait_node" );
	
	self loop_movement_behavior( 10, 5, identifier, groupNum, signalArray );
}

/////////////////////////////////
// FUNCTION: linear_movement_behavior
// CALLED ON: a linear movement vehicle
// PURPOSE: This causes a tank to move linearly along a series of linear path parts, making 
//          making decisions at junctions based on signals. The choice behavior is untested
//          and probably does not work
// ADDITIONS NEEDED: None, not really used
/////////////////////////////////
linear_movement_behavior( speed, accel, identifier, groupNum, signalArray )
{
	self thread wait_for_signals( signalArray, identifier );
	if( isDefined( speed ) && isDefined( accel ) )
	{
		self setSpeed( speed, accel );
	}
	else if( isDefined( speed ) )
	{
		self setSpeed( speed );
	}
	
	self thread check_for_player_proximity( 1500 );
	
	// continue moving through 
	for( i = 0; ; i++ )
	{
		self.currPart = i;
		if( isDefined( groupNum ) )
		{
			destName = "line "+identifier+" group"+groupNum+" part"+i+" end";
			destNode = GetVehicleNode( destName, "script_noteworthy" );
			switchName = "line"+identifier+" part"+(i+1)+" group"+groupNum+" start";
			switchNode = GetVehicleNode( switchName, "script_noteworthy" );
		}
		else
		{
			destName = "line"+identifier+" part"+i+" end";
			destNode = GetVehicleNode( destName, "script_noteworthy" );
			switchName = "line"+identifier+" part"+(i+1)+" start";
			switchNode = GetVehicleNode( switchName, "script_noteworthy" );
		}
		if( !isDefined(destNode) || !isDefined(switchNode) )
		{
			break;
		}
		else
		{
			self setSwitchNode( destNode, switchNode );
			self setWaitNode( switchNode );
			self waittill( "reached_wait_node" );
		}
	}
}


linear_movement_behavior_adjusted( speed, accel, identifier, groupNum, signalArray )
{
	self endon("death");
		
	//self thread check_for_player_proximity( 1500 );
	self thread linear_movement_behavior_adjusted_hit_react();
	
	//-- if I reached the end of my node, wait until I get shot and then roll backward.
	self waittill("reached_end_node");
	
	if(!IsDefined(self.script_noteworthy))
	{
		return;
	}
	
	backup_path = GetVehicleNode( self.script_noteworthy + " path", "script_noteworthy" );
	self AttachPath( backup_path );
	self SetSpeed(0, 50, 50);
	self.attached_to_backup_path_but_not_moving = true;
	
	//-- See if the backup_path ends on a script_string, if it does, then reset that to the new backup path
	temp_node = backup_path;
	while( IsDefined(temp_node.target) )
	{
		temp_node = GetVehicleNode( temp_node.target, "targetname" );
	}
	
	if( IsDefined(temp_node.script_noteworthy) )
	{
		self.script_noteworthy = temp_node.script_noteworthy;
	}
	else
	{
		self.script_noteworthy = undefined;
	}
	
	time_hit = 0;
	
	while(1)
	{
		self waittill("damage", amount, attacker, direction, point, type);
		
		if(type == "MOD_PROJECTILE")
		{
			time_hit++;
		}
		
		if( IsPlayer(attacker) )
		{
			if(self.vehicletype == "see2_panther")
			{
				if(time_hit >= 1)
				{
					break;
				}
			}
			else
			{
				break;
			}
		}
	}
	
	self StartPath();
	self ResumeSpeed(5);
	self.attached_to_backup_path_but_not_moving = undefined;
	
	self thread linear_movement_behavior_adjusted( speed, accel, identifier, groupNum, signalArray );
	
}

linear_movement_behavior_adjusted_hit_react()
{
	self endon("death");
	wait(2); //let the vehicle get up to speed
	
	while(1)
	{
		self waittill("damage", amount, attacker, direction, point, type);
		
		if(type != "MOD_PROJECTILE")
		{
			continue;
		}
		
		if( IsPlayer(attacker) )
		{
			old_speed = self GetSpeedMPH();
			
			self SetSpeed( old_speed * 0.7, 5, 5 );
			
			if( !IsDefined(self.attached_to_backup_path_but_not_moving) )
			{
				wait(1.5);
				self ResumeSpeed(5);		
			}
		}
	}
}

/////////////////////////////////
// FUNCTION: loop_movement_behavior
// CALLED ON: a loop vehicle
// PURPOSE: This causes a vehicle to switch between the parts of a loop path by setting switch
//          nodes. It also has signal based choice behavior similar to linear movement behavior 
//          but it also doesn't work. 
// ADDITIONS NEEDED: None
/////////////////////////////////
loop_movement_behavior( speed, accel, identifier, groupNum, signalArray )
{
	if( isDefined( speed ) && isDefined( accel ) )
	{
		self setSpeed( speed, accel );
	}
	else if( isDefined( speed ) )
	{
		self setSpeed( speed );
	}
	
	for( i = 0; ; i++ )
	{
		self set_path_wait_points( groupNum );
		self.currPart = i;
		if( isDefined( groupNum ) )
		{
			destName = "loop "+identifier+" group"+groupNum+" part"+i+" end";
			destNode = GetVehicleNode( destName, "script_noteworthy" );
			switchName = "loop "+identifier+" part"+(i+1)+" group"+groupNum+" start";
			switchNode = GetVehicleNode( switchName, "script_noteworthy" );
		}
		else
		{
			destName = "loop"+identifier+" part"+i+" end";
			destNode = GetVehicleNode( destName, "script_noteworthy" );
			switchName = "loop"+identifier+" part"+(i+1)+" start";
			switchNode = GetVehicleNode( switchName, "script_noteworthy" );
		}
		if( !isDefined(switchNode) )
		{
			if( isDefined( groupNum ) )
			{
				switchNode = GetVehicleNode( "loop "+identifier+" part0 group"+groupNum+" start", "script_noteworthy" );
			}
			else
			{
				switchNode = GetVehicleNode( "loop "+identifier+" part0 start", "script_noteworthy" );
			}
			i = -1;
		}
		wait( 0.05 );
		self setSwitchNode( destNode, switchNode );
		self setWaitNode( switchNode );
		self waittill( "reached_wait_node" );
	}
}

/////////////////////////////////
// FUNCTION: do_vehicle_retreats
// CALLED ON: level
// PURPOSE: Sets up threads for all retreat triggers
// ADDITIONS NEEDED: None
/////////////////////////////////
do_vehicle_retreats( groupNum )
{
	retreatTriggers = GetEntArray( "retreat trigger group"+groupNum, "script_noteworthy" );
	for( i = 0; i < retreatTriggers.size; i++ )
	{
		retreatTriggers[i] thread wait_for_vehicle_retreat();
	}
}

/////////////////////////////////
// FUNCTION: wait_for_vehicle_retreat
// CALLED ON: a retreat trigger
// PURPOSE: This waits till the retreat trigger is set off by a player or allied tank then
// 					activates its targeted trigger.
// ADDITIONS NEEDED:
/////////////////////////////////
wait_for_vehicle_retreat()
{
	self thread self_inform_on_damage_trigger( "start retreat" );
	
	self waittill( "start retreat" );
	
	if( !isDefined( self.target ) )
	{
		return;
	}
	
	GetEnt(self.target, "targetname") notify( "trigger" );
}

/////////////////////////////////
// FUNCTION: custom_array_remove
// CALLED ON: level
// PURPOSE: Removes an element from an array, while preserving order.
// ADDITIONS NEEDED:
/////////////////////////////////
custom_array_remove( array, element )
{
	new_array = [];
	for( i = 0; i < array.size; i++ )
	{
		if( array[i] == element )
		{
			continue;
		}
		new_array[new_array.size] = array[i];
	} 
	return new_array;
}

/////////////////////////////////
// FUNCTION: wait_for_arrive
// CALLED ON: a vehicle
// PURPOSE: Waits until a vehicle arrives at a reach node then causes it to stop
// ADDITIONS NEEDED:
/////////////////////////////////
wait_for_arrive()
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "reached_wait_node" );
		self.current_node = self.target_node;
		// This is an incredibly badly named call for stopping the vehicle - LDS
		self returnplayercontrol();
		wait( 0.05 );
		self setSpeed( 0, 6, 6 );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_player_advance
// CALLED ON: level
// PURPOSE: This waits until an advance trigger is hit then sets that as the desired advance level
//          for all friendly AI tanks
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_player_advance()
{
	while( 1 )
	{
		self waittill( "trigger", guy);
		if( !isPlayer( guy ) )
		{
			continue;
		}
		level.current_advance_level = self.script_noteworthy;
		self delete();
	} 
}

/////////////////////////////////
// FUNCTION: lerp_to_stop
// CALLED ON: a vehicle
// PURPOSE: When requested, a vehicle will lerp to a stop over a short period of time
// ADDITIONS NEEDED: None
/////////////////////////////////
lerp_to_stop()
{
	self endon( "death" );
	while( 1 )
	{
		current_speed = self getspeedMPH();
		current_speed -= (current_speed * 0.5 * 0.05);
		if( current_speed < 1 ) 
		{
			current_speed = 0;
		}
		self setSpeed( current_speed, current_speed/2, current_speed/2 );
		if( current_speed == 0 )
		{
			return;
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: set_path_wait_points
// CALLED ON: a vehicle
// PURPOSE: This is the wait point choice stuff that doesn't work for line movement and loop movement
//          behavior.
// ADDITIONS NEEDED: None
/////////////////////////////////
set_path_wait_points( lineOrLoop, identifier, groupNum, partNum)
{
	nextNode = GetEnt(lineOrLoop+" "+identifier+" group"+groupNum+" part"+partNum+" start", "targetname" );
	while( 1 )
	{
		if( isDefined( nextNode ) ) 
		{
			if( isDefined( nextNode.script_string ) )
			{
				self setWaitNode( nextNode );
				self waittill( "reached_wait_node" );
				self waittill( nextNode.script_string );
			}
			if( isDefined( nextNode.target ) )
			{
				nextNode = GetEnt( nextNode.target, "targetname" );
			}
			else
			{
				nextNode = undefined;
			}
		}
		else
		{
			break;
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_signals
// CALLED ON: a line or loop vehicle
// PURPOSE: This is more of the choice stuff that doesn't work
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_signals( signalArray, identifier, loop )
{
	if( !isDefined( loop ) )
		loop = false;
	check_array = [];
	if( isDefined( signalArray ) )
	{
		for( i = 0; i < signalArray.size; i++ )
		{
			if( !loop )
			{
				check_array[i].forkpoint = "line"+identifier+"part"+(signalArray[i].part-1)+" end";
				check_array[i].targetpoint = "line"+identifier+"part"+signalArray[i].part+signalArray[i].letter+" start";
			}
			else
			{
				check_array[i].forkpoint = "loop"+identifier+"part"+(signalArray[i].part-1)+" end";
				check_array[i].targetpoint = "loop"+identifier+"part"+signalArray[i].part+signalArray[i].letter+" start";
				test_node = GetVehicleNode( check_array[i].targetpoint, "script_noteworthy" );
				if( !isDefined( test_node ) )
				{
					check_array[i].targetpoint = "loop"+identifier+"part0"+signalArray[i].letter+" start";
				}
			}
			check_array[i].waitsignal = signalArray[i].waitsignal;
			check_array[i].part = signalArray[i].part-1;
			self thread wait_for_signal( check_array[i] );
		}
	}
}

/////////////////////////////////
// FUNCTION: wait_for_signal
// CALLED ON: a line or loop vehicle
// PURPOSE: Yep, choice stuff, doesn't work.
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_signal( signal )
{
	self waittill( signal.waitsignal );
	if( self.currPart == signal.part )
	{
		destNode = GetVehicleNode( signal.forkpoint, "script_noteworthy" );
		switchNode = GetVehicleNode( signal.targetpoint, "script_noteworthy" );
		if( isDefined( destNode ) && isDefined( switchNode ) )
		{
			self setSwitchNode( destNode, switchNode );
			self thread wait_for_switch_then_update(switchNode, signal.part);
		}
	}
	
	self thread wait_for_signal( signal );
	
}

/////////////////////////////////
// FUNCTION: wait_for_switch_then_update
// CALLED ON: a line or loop vehicle
// PURPOSE: Choice. blah. blah. blah. Does not work. blah. blah.
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_switch_then_update( node, part )
{
	self endon( "new switch command" );
	wait( 0.05 );
	self notify( "new switch command" );
	
	self setWaitNode( node );
	self waittill( "reached_wait_node" );
	self.currPart = part + 1;
}

////////////////////////////////////////////
// COMBAT FUNCTIONS
////////////////////////////////////////////

/////////////////////////////////
// FUNCTION: arty_behavior
// CALLED ON: a flak 88
// PURPOSE: Waits until a player enters its trigger, then targets and tries to kill the player
// ADDITIONS NEEDED: None
/////////////////////////////////
arty_behavior()
{
	trigger = GetEnt( self.targetname+" trigger", "script_noteworthy" );
	damage_trigger = GetEnt( self.targetname+" damage trigger", "script_noteworthy" );
	damage_trigger thread maps\see2::inform_on_damage_trigger( damage_trigger.script_noteworthy );
	trigger thread maps\see2::inform_on_touch_trigger( trigger.script_noteworthy );
	while( 1 ) 
	{
		level waittill_either( damage_trigger.script_noteworthy, trigger.script_noteworthy );
		current_target = self maps\_vehicle::get_nearest_target( level.player_tanks );
		if( isDefined( current_target ) )
		{
			self.customTarget = current_target;
		}
	}
}

/////////////////////////////////
// FUNCTION: arty_custom_targeting
// CALLED ON: a flak 88
// PURPOSE: causes an artillery to switch back to its phantom target if told to
// ADDITIONS NEEDED: None
/////////////////////////////////
arty_custom_targeting()
{
	while( 1 ) 
	{
		level waittill( "target this", ent );
		self.customTarget = level.customTarget;
		level waittill( "stop target this" );
		self.customTarget = GetStruct( self.target, "targetname" );
	}
}

/////////////////////////////////
// FUNCTION: moving_firing_behavior
// CALLED ON: an enemy vehicle
// PURPOSE: This gets the closest friendly armor unit. If it is close enough to target it tracks
//          it with its turret. If it gets within the firing radius, the tank calls request_target
//          and begins firing on the entity. If it goes outside of this radius it will stop
//          firing and acquire new targets, potentially.
// ADDITIONS NEEDED: Add speed based inaccuracy
/////////////////////////////////
moving_firing_behavior()
{
	if( self.vehicletype == "opel" )
	{
		return;
	}
	
	self notify( "kill old firing behavior" );
	wait( 0.05 );
	self endon( "kill old firing behavior" );
	self endon( "death" );
	
	if( !isDefined( get_players() ) )
	{
		while( 1 )
		{
			if( isDefined( get_players() ) )
			{
				break;
			}
			wait( 0.05 );
		}
	}
	
	current_target = undefined;
	best_target = undefined;
	while( 1 )
	{
		if( isDefined( level.custom_target ) )
		{
			best_target = level.custom_target;
			current_target = level.custom_target;
			myOrigin = self.origin + (0,0,200);// gettagorigin( "tag_barrel" );
			theirOrigin = current_target.origin + (0, 0, 200);
			trace = bullettrace( myOrigin, theirOrigin, false, undefined );
			if( trace["fraction"] < 0.95 || current_target == self)
			{
				current_target = undefined;
				wait( 3 );
				continue;
			}
		}
		
		if( !isDefined( current_target ) || current_target.health <= 0 || distancesquared( current_target.origin, self.origin ) > (level.see2_max_tank_target_dist*level.see2_max_tank_target_dist) || current_target.classname == "script_vehicle_corpse")
		{
			best_target = self maps\_vehicle::get_nearest_target( level.player_tanks );
			current_target = self maps\see2::request_target( best_target );
			myOrigin = self.origin + (0,0,200);// gettagorigin( "tag_barrel" );
			theirOrigin = current_target.origin + (0, 0, 200);
			trace = bullettrace( myOrigin, theirOrigin, false, undefined );
			if( trace["fraction"] < 0.95 || current_target == self)
			{
				current_target = undefined;
				wait( 3 );
				continue;
			}
		}
		
		if( distancesquared( current_target.origin, self.origin ) > (level.see2_max_tank_firing_dist*level.see2_max_tank_firing_dist) )
		{
			wait( 3 );
			continue;
		}
		
		if( self.health < 1 )
		{
			 self notify( "death" );
			 return;
		}
		
		self thread set_tank_accuracy( current_target, best_target );
		self thread wait_fire_weapon( current_target );
		
		while( isDefined( current_target ) && isDefined( best_target ) && distancesquared( current_target.origin, self.origin ) < level.see2_max_tank_target_dist*level.see2_max_tank_target_dist && current_target.classname != "script_vehicle_corpse" )
		{
			if( isDefined( self.my_target_point ) )
			{
				self setturrettargetvec( self.my_target_point );	
			}
			wait( 0.05 );
		}
		
		self notify( "need new target" );
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: notify_on_advance_trigger
// CALLED ON: level
// PURPOSE: setup the array of friendlies to tell about new advance orders
// ADDITIONS NEEDED: None
/////////////////////////////////
notify_on_advance_trigger()
{
	if( !isDefined( level.support_ai ) )
	{
		level.support_ai = [];
	}
	if( array_check_for_dupes( level.support_ai, self ) )
	{
		level.support_ai = array_add( level.support_ai, self );
	}
	
	self waittill( "death" );
	
	level.support_ai = array_remove( level.support_ai, self );
}

/////////////////////////////////
// FUNCTION: setup_friendly_advance_triggers
// CALLED ON: level
// PURPOSE: Threads the necessary functions on all advance triggers
// ADDITIONS NEEDED: None
/////////////////////////////////
setup_friendly_advance_triggers()
{
	advance_triggers = GetEntArray( "friendly advance trigger", "targetname" );
	for( i = 0; i < advance_triggers.size; i++ )
	{
		advance_triggers[i] thread wait_for_player_advance();
	}
}

/////////////////////////////////
// FUNCTION: do_depth_setup
// CALLED ON: a friendly AI
// PURPOSE: Sets the depth of all nodes in a friendly path for easy outing advance orders that
//          go backwards
// ADDITIONS NEEDED: None
/////////////////////////////////
do_depth_setup()
{
	current_node = GetVehicleNode( self.target, "targetname" );
	current_depth = 0;
	next_node = undefined;
	self.current_path_depth = current_depth;
	
	while( 1 )
	{
		if(isDefined(current_node))
		{
			current_node.path_depth = current_depth;
			if( !isDefined( current_node.target ) )
			{
				break;
			}
			current_node = GetVehicleNode( current_node.target, "targetname" );
			current_depth++;
			
			if(current_depth%10 == 0)
			{
				wait(0.05);
			}
		}
		else
		{
			break;
		}
	}
}

/////////////////////////////////
// FUNCTION: do_player_support
// CALLED ON: a friendly AI
// PURPOSE: This causes a friendly AI to exhibit the advance behavior and friendly firing
//          behavior required of friendly tanks.
// ADDITIONS NEEDED: None
/////////////////////////////////
do_player_support()
{
	self endon( "death" );
	self endon( "stop supporting" );
	
	self.scanning = true;
	self do_depth_setup();
	
	self thread do_friendly_firing();
	self thread do_turret_scanning();
	self thread wait_for_arrive();
	self thread notify_on_advance_trigger();
	self thread check_should_stop();
	
	while( 1 )
	{
		if( isDefined( level.current_advance_level ) )
		{
			current_support_positions = getVehicleNodeArray( level.current_advance_level, "script_noteworthy" );
		}
		else
		{
			wait( 0.05 );
			continue;
		}
		my_node = undefined;
		
		for( i = 0; i < current_support_positions.size; i++ )
		{
			if( current_support_positions[i].script_string == self.script_noteworthy )
			{
				my_node = current_support_positions[i];
			}
		}
		
		if( !isDefined( self.target_node ) || (isDefined( my_node ) && (my_node != self.target_node) && my_node.path_depth > self.current_path_depth) )
		{
			self.target_node = my_node;
			self.current_path_depth = my_node.path_depth;
			self setWaitNode( my_node );
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: cleanup_targeting
// CALLED ON: a vehicle
// PURPOSE: Cleans the vehicle out of the targeting arrays on death
// ADDITIONS NEEDED: None
/////////////////////////////////
cleanup_targeting()
{
	self waittill( "death" );
	
	if( !array_check_for_dupes( level.enemy_armor, self ) )
	{
		level.enemy_armor = array_remove( level.enemy_armor, self );
	}
	
	if( !array_check_for_dupes( level.player_tanks, self ) )
	{
		level.player_tanks = array_remove( level.player_tanks, self );
	}
}

/////////////////////////////////
// FUNCTION: check_should_stop
// CALLED ON: a friendly AI
// PURPOSE: This keeps friendly tanks from barrelling through one another, each has a script_int
//          (the host's is 0) and they stop if within 1000 units of any tank with a lower scrip_int
//          than theirs. They continue moving once this is no longer the case.
// ADDITIONS NEEDED: None
/////////////////////////////////
check_should_stop()
{
	self endon( "death" );
	
	distance = 1000;
	while( 1 )
	{
		self.should_stop = false;
		for( i = 0; i < level.player_tanks.size; i++ )
		{
			if( level.player_tanks[i].script_int < self.script_int )
			{
				if( distanceSquared( self.origin, level.player_tanks[i].origin ) < distance*distance )
				{
					self.should_stop = true;
					break;
				}	
			}
		}
		
		if( !isDefined( self.current_node ) || !isDefined( self.target_node ) )
		{
			self.should_stop = true;
		}
		else if( self.current_node == self.target_node )
		{
			self.should_stop = true;
		}
		
		if( !self.should_stop )
		{
			self setSpeed( 12, 6 );
		}
		else
		{
			self.should_stop = true;
			self returnplayercontrol();
			wait( 0.05 );
			self setSpeed( 0, 6, 6 );
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: do_friendly_firing
// CALLED ON: a friendly AI
// PURPOSE: This causes the friendlies to acquire and fire on enemy tanks
// ADDITIONS NEEDED: From Corky - Friendlies need to be less accurate
/////////////////////////////////
do_friendly_firing()
{
	self endon( "death" );
	get_players()[0] endon( "death" );
	
	main_turret_dist = 2500;
	hull_dist = 2000;
	fire_time = 5;
	time_since_fire = 0;
	
	while( 1 )
	{
		main_turret_target = undefined;
		hull_target = undefined;
		
		main_turret_target = self maps\_vehicle::get_nearest_target( level.enemy_armor );
		hull_target = self maps\_vehicle::get_nearest_target( level.enemy_infantry );
		
		if( isDefined( main_turret_target ) && main_turret_target.classname != "script_vehicle_corpse" )
		{
			if( distanceSquared( main_turret_target.origin, self.origin ) < (main_turret_dist * main_turret_dist) )
			{
				self notify ( "stop scanning" );
				self.scanning = false;
				trace = bullettrace( self.origin+(0, 0, 200), main_turret_target.origin+(0, 0, 200), false, main_turret_target );
				self setTurretTargetEnt( main_turret_target );
				if( trace["fraction"] > 0.95 )
				{
					self fireweapon();
				}
			}
 			else if( distanceSquared( main_turret_target.origin, self.origin ) < (2 * main_turret_dist * main_turret_dist) )
			{
				self notify ( "stop scanning" );
				self.scanning = false;
				self setTurretTargetVec( vectorToAngles( main_turret_target.origin - self.origin ) );
			}
			else
			{
				self.scanning = true;
			}
		}
		else
		{
			self.scanning = true;
		}
		
		if( isDefined( hull_target  ) )
		{
			if( distanceSquared( hull_target.origin, self.origin ) < (hull_dist * hull_dist) )
			{
				self aim_and_fire_hull( hull_target, fire_time );
			}
			else
			{
				self notify( "need new flamethrower target" );
			}
		}
		else
		{
			self notify( "need new flamethrower target" );
		}
		wait( 3 );
	}
}

/////////////////////////////////
// FUNCTION: do_turret_scanning
// CALLED ON: a friendly vehicle
// PURPOSE: Makes the friendly vehicle scan with its turret when its self.scanning is set to true.
//          Makes them feel a little less wooden
// ADDITIONS NEEDED: None
/////////////////////////////////
do_turret_scanning()
{
	self endon( "death" );
	
	while( 1 )
	{
		if( self.scanning )
		{
			angles = ( randomintrange(-5, 10), randomintrange( -45, 45 ), 0 );
			angles += self.angles;
			self setTurretTargetVec( self.origin + (5000*anglesToForward( angles )) );
		}
		wait( randomintrange( 6, 8 ) );
	}
}

/////////////////////////////////
// FUNCTION: aim_and_fire_hull
// CALLED ON: a friendly vehicle
// PURPOSE: This causes them to fire their hull gun in a quick burst
// ADDITIONS NEEDED: None
/////////////////////////////////
aim_and_fire_hull( targetEnt, burst_time )
{
	self endon( "death" );
	
	self maps\_vehicle::mgon();
	
	wait( burst_time );
	
	self maps\_vehicle::mgoff();
	
	self endon( "need new flamethrower target" );
}

/////////////////////////////////
// FUNCTION: set_tank_accuracy
// CALLED ON: an enemy vehicle
// PURPOSE: This requests a delayed position from the breadcrumb system. Delay is based on level 
//          difficulty and distance from target
// ADDITIONS NEEDED: None
/////////////////////////////////
set_tank_accuracy( curr_target, best_target, min_speed_for_motion, time_before_accurate, max_offset )
{
	self endon( "need new target" );
	self endon( "death" );

	lastpos = curr_target.origin;
	time_stationary = 0;
	time_since_last_adjust = 0;
	while( 1 )
	{
		if( !isDefined( curr_target ) || !isDefined( best_target ) )
		{
			return;
		}
		
		delay_frac = distanceSquared( self.origin, curr_target.origin ) / (3500 * 3500);
		if( delay_frac > 1 )
		{
			delay_frac = 1;
		}
		curr_delay = 0.5 + level.see2_base_lag_time*delay_frac;
		
		if( curr_target != best_target )
		{
			target_pos = maps\see2_breadcrumbs::get_delayed_position( best_target, curr_delay );
		}
		else
		{
			target_pos = curr_target.origin;
		}
		if( target_pos == ( 0, 0, 0 ) )
		{
			target_pos = curr_target.origin;
		}
		if( distancesquared( curr_target.origin, self.origin ) > (1500*1500) )
		{
			target_pos = target_pos + (curr_target.origin - best_target.origin );
		}
		
		if( target_pos[0] > 1152 && target_pos[0] < 4928 && target_pos[1] > -12672 && target_pos[1] < -11200 ) //-- hope the map doesn't move...
		{
			self setTurretTargetVec(target_pos+(0,0,24));
		}
		else
		{
			self setTurretTargetVec( target_pos+(0, 0, 80) );
		}
		
		
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: static_firing_behavior
// CALLED ON: an enemy vehicle
// PURPOSE: Functions the same as ::moving_firing_behavior, but all ranges for target acquisition
//          and firing are longer.
// ADDITIONS NEEDED: None
/////////////////////////////////
static_firing_behavior()
{
	if( self.vehicletype == "opel" )
	{
		return;
	}
	
	self notify( "kill old firing behavior" );
	wait( 0.05 );
	self endon( "kill old firing behavior" );
	self endon( "death" );
	
	if( !isDefined( get_players() ) )
	{
		while( 1 )
		{
			if( isDefined( get_players() ) )
			{
				break;
			}
			wait( 0.05 );
		}
	}
	
	current_target = undefined;
	best_target = undefined;
	while( 1 )
	{
		if( isDefined( level.custom_target ) )
		{
			best_target = level.custom_target;
			current_target = level.custom_target;
			myOrigin = self.origin + (0,0,200);// gettagorigin( "tag_barrel" );
			theirOrigin = current_target.origin + (0, 0, 200);
			trace = bullettrace( myOrigin, theirOrigin, false, undefined );
			if( trace["fraction"] < 0.95 || current_target == self)
			{
				current_target = undefined;
				wait( 3 );
				continue;
			}
		}
		
		if( !isDefined( current_target ) || current_target.health <= 0 || distancesquared( current_target.origin, self.origin ) > (level.see2_max_tank_target_dist*1.25*level.see2_max_tank_target_dist*1.25) || current_target.classname == "script_vehicle_corpse")
		{
			best_target = self maps\_vehicle::get_nearest_target( level.player_tanks );
			current_target = self maps\see2::request_target( best_target );
			myOrigin = self.origin + (0,0,200);// gettagorigin( "tag_barrel" );
			theirOrigin = current_target.origin + (0, 0, 200);
			trace = bullettrace( myOrigin, theirOrigin, false, undefined );
			if( trace["fraction"] < 0.95 || current_target == self)
			{
				current_target = undefined;
				wait( 3 );
				continue;
			}
		}
		
		if( distancesquared( current_target.origin, self.origin ) > (level.see2_max_tank_firing_dist*1.25*level.see2_max_tank_firing_dist*1.25) )
		{
			wait( 3 );
			continue;
		}
		
		if( self.health < 1 )
		{
			 self notify( "death" );
			 return;
		}
		
		self thread set_tank_accuracy( current_target, best_target );
		self thread wait_fire_weapon( current_target );
		
		while( isDefined( current_target ) && isDefined( best_target ) && distancesquared( current_target.origin, self.origin ) < level.see2_max_tank_target_dist*level.see2_max_tank_target_dist && current_target.classname != "script_vehicle_corpse" )
		{
			if( isDefined( self.my_target_point ) )
			{
				self setturrettargetvec( self.my_target_point );	
			}
			wait( 0.05 );
		}
		
		self notify( "need new target" );
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: wait_fire_weapon
// CALLED ON: a vehicle
// PURPOSE: Fires the main cannon every so often if the vehicle has a target
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_fire_weapon( current_target )
{
	self endon( "need new target" );
	self endon( "death" );
	
	if( self == current_target )
	{
		breaker = 1;
	}
	
	someone_is_close = false;
	my_target = undefined;
	
	while( 1 )
	{
		angles = vectortoangles( current_target.origin - self.origin );
		turret_angles = self GetTagAngles( "tag_barrel" );
		if( abs(angles[1] - turret_angles[1]) > 20 )
		{
			if( distanceSquared(self.origin, current_target.origin) < 300 * 300) //-- your target is really really close, then kill him and add a little modifier to it
			{
				someone_is_close = true;
				my_target = undefined;
			}
			else
			{
				wait( 0.05 );
				continue;
			}
		}
		
		old_speed = self GetSpeedMPH();
		self SetSpeed(0, 5, 5);
		
		while(self GetSpeedMPH() >  0.1)
		{
			wait(0.05);
		}
		
		wait(0.2);
		if(someone_is_close) //-- find the closest Player Tank
		{
			player_tanks = [];
			players = get_players();
			for(i = 0; i < players.size; i++)
			{
				player_tanks[i] = players[i].myTank;
			}
		
			my_target = player_tanks[0];
			for( j=0 ; j<player_tanks.size; j++)
			{
				if( DistanceSquared(current_target.origin, my_target.origin) > DistanceSquared(current_target.origin, player_tanks[j].origin) )
				{
					my_target = player_tanks[j];
				}
			}

			if(!IsDefined(current_target.too_close_damage_modifier) && ( DistanceSquared(my_target.origin, current_target.origin) < 300 * 300 ) )
			{
				my_target.too_close_damage_modifier = 3;
			}
		}
		
		self fireweapon();
		
		level notify( "enemy vehicle fired" );
		
		if( !IsDefined(self.attached_to_backup_path_but_not_moving) )
		{
			self SetSpeed(old_speed, 5, 5);
		}
		
		wait(0.5);
		if(IsDefined(my_target))
		{
			//-- reset the damage scale
			my_target.too_close_damage_modifier =  undefined;
		}
		
		wait( randomfloatrange( 4.5, 7.0) );
	}
}