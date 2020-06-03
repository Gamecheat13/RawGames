#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_vehicle_utility;
#include animscripts\utility;
#include animscripts\combat_utility;

/////////////////////////////////
// FUNCTION: do_bunker_group
// CALLED ON: level
// PURPOSE: After a group of bunker guards is spawned, waits until a player gets close enough or 
//          does explosive damage close enough to the bunker then causes a retreat.
// ADDITIONS NEEDED: None
/////////////////////////////////
do_bunker_group( bunker_name, new_bunker_name, event, groupid )
{
	if( isDefined( groupid ) )
	{
		spawners = GetEntArray( groupid, "targetname" );
		array_thread(spawners, ::add_spawn_function, maps\see2::setup_bunker_infantry); 
		
		trigger = getEnt( groupid, "target" );
		if( isDefined( trigger ) )
		{
			trigger waittill( "trigger" );
			wait( 1 );
		}
	}
	group = get_living_ai_array( bunker_name+" guard", "script_noteworthy" );
	goalNodes = getNodeArray( bunker_name+" retreat node", "script_noteworthy" );
	damageTrigger = getEnt( bunker_name+" damage trigger", "script_noteworthy" );
	smokeNodes = getEntArray( bunker_name+" smoke", "script_noteworthy" );
	tankTrigger = getEnt( bunker_name+" tank trigger", "script_noteworthy" );
	
	truck = getEnt( bunker_name+" truck", "script_noteworthy" );
	
	for( i = 0; i < group.size; i++ )
	{
		if( isDefined( group[i] ) && group[i].classname == "actor_axis_ger_ber_wehr_reg_panzerschrek" )
		{
			group[i].maxsightdistsqrd = 3000*3000;
		}
		group[i].animname = "trench guy";
	}
	
	if( isDefined( damageTrigger ) )
	{
		damageTrigger thread maps\see2::inform_on_damage_trigger( "retreat "+bunker_name );
	}
	if( isDefined( tankTrigger ) )
	{
		tankTrigger thread maps\see2::inform_on_touch_trigger( "retreat "+bunker_name );
	}
	
	level waittill( "retreat "+bunker_name ); 
	
	for( i = 0; i < smokeNodes.size; i++ )
	{
		if( isDefined( group[i] ) )
		{
			playfx( level._effect["retreat_smoke"], smokeNodes[i].origin );
			wait( randomfloat( 0.5, 0.75 ) );
		}
	}
	
	if( isDefined( truck ) )
	{
		movetrigger = getEnt( truck.script_noteworthy+" move trigger", "script_noteworthy" );
		movetrigger notify( "trigger" );
	}
	
	group = get_living_ai_array( bunker_name+" guard", "script_noteworthy" );
	
	//-- if I am not a panzerschreck guy, then I attempt to throw a panic grenade before I run
	possible_tanks = GetEntArray( "script_vehicle", "classname" );
	player_tanks = [];
	for( i = 0; i < possible_tanks.size; i++ )
	{
		tank_owner = possible_tanks[i] GetVehicleOwner();
		if( IsPlayer(tank_owner ) )
		{
			player_tanks[player_tanks.size] = possible_tanks[i];
		}
	}
	
				
	notified = false;
	for( i = 0; i < group.size && i < goalNodes.size; i++ )
	{
		if( isDefined( group[i] ) )
		{
			if( notified == false ) 
			{
				level notify( "retreaters", group[i] );
				notified = true;
			}
			
			if( group[i].classname == "actor_axis_ger_ber_wehr_reg_kar98k" )
			{
				group[i].ignoreme = true;
				group[i].ignoreall = true;
				group[i] thread watch_for_grenade_throw_done( player_tanks, goalNodes[i] );
			}
			else
			{
				group[i] setGoalNode( goalNodes[i] );
				group[i] thread do_panzerschreck_retreat();
			}
			group[i] thread maps\see2::do_generic_retreats();
			wait( randomfloat( 0.7, 0.95 ) );
		}
	}
	
	thread maps\see2::log_finished_event( event, 10 );
}

watch_for_grenade_throw_done(player_tanks, goal_node)
{
	//-- if I am not a panzerschreck guy, then I attempt to throw a panic grenade before I run					
	if(player_tanks.size == 0)
	{
		return;
	}
	self.scripted_grenade_throw = true;
	
	random_wait = RandomFloatRange(0.2, 1.5);
	wait(random_wait);
		
	my_target = player_tanks[0];
	
	for( j=0 ; j<player_tanks.size; j++)
	{
		if( DistanceSquared(self.origin, my_target.origin) < DistanceSquared(self.origin, player_tanks[j].origin) )
		{
			my_target = player_tanks[j];
		}
	}
	
	self maps\_grenade_toss::force_grenade_toss(	my_target.origin, undefined, 3, undefined, undefined );
	
	self setGoalNode( goal_node );
	self.scripted_grenade_throw = undefined;
}

debug_line_on_damage()
{
	while(1)
	{
		self waittill("damage", amount, attacker, direction, point, mod);
		if(mod == "MOD_PROJECTILE")
		{
			Print3d( point, "***", (1, 0, 0), 1, 3, 3000 );
		}
		
		if(mod == "MOD_EXPLOSIVE")
		{
			Print3d( point, "***", (0, 0, 1), 1, 3, 3000 );
		}
	}
}

/////////////////////////////////
// FUNCTION: do_panzerschreck_retreat
// CALLED ON: a panzerschreck infantryman
// PURPOSE: makes the panzerscheck guy turn and fire every so often
// ADDITIONS NEEDED: None
/////////////////////////////////
do_panzerschreck_retreat()
{
	self endon( "death" );
	
	while( 1 )
	{
		self.ignoreall = true;
		wait( randomintrange(6, 8) );
		self.ignoreall = false;
		wait( randomintrange( 6, 8 ) );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_guard_tower_sploders
// CALLED ON: level
// PURPOSE: Spawns a drone for each guard tower and waits for the damage trigger for the 
//          script_exploder to go off 
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_guard_tower_sploders()
{
	damage_triggers = GetEntArray( "guard tower damage trigger", "script_noteworthy" );
	
	for( i = 0; i < damage_triggers.size; i++ )
	{
		drone_struct = getStruct( damage_triggers[i].target, "targetname" );
		
		drone = maps\_drone::drone_scripted_spawn( "actor_axis_ger_ber_wehr_reg_kar98k", drone_struct );
		damage_triggers[i].myDrone = drone;
	
		damage_triggers[i] thread wait_for_single_sploder();
		level.enemy_armor = array_add( level.enemy_armor, damage_triggers[i] );
	}
}

/////////////////////////////////
// FUNCTION: wait_for_single_sploder
// CALLED ON: a guard tower exploder trigger
// PURPOSE: waits until the tower is triggered, then removes it from the list of enemy targets
//          and damages and eventually deletes the guard tower drone.
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_single_sploder()
{
	self waittill( "trigger", ent );
	if( ent == get_players()[0] )
	{
		level notify( "destruction" );
	}
	self.destroyed = true;
	if( !array_check_for_dupes( level.enemy_armor, self ) )
	{
		level.enemy_armor = array_remove( level.enemy_armor, self );
	}
	radiusdamage( self.origin, 150, 500, 500 );

	if( isDefined( self.myDrone ) )
	{
		self.myDrone notify("no_drone_death_thread");
		self.myDrone Delete();
		//self.myDrone thread cleanup_drones();
	}
	
	if( IsPlayer( ent ) )
	{
		arcademode_assignpoints( "arcademode_score_banzai", ent );
	}
	
	level notify( "achievement_destroy_notify", "schreck_tower" );
}

/////////////////////////////////
// FUNCTION: do_fake_schrecks
// CALLED ON: level
// PURPOSE: threads all the tower triggers to get them to spawn fake panzerschreck fire
// ADDITIONS NEEDED: None
/////////////////////////////////
do_fake_schrecks()
{
	tower_triggers = getEntArray( "guard tower damage trigger", "script_noteworthy" );
	
	for( i = 0; i < tower_triggers.size; i++ )
	{
		tower_triggers[i] thread do_fake_schreck();
	}
}

/////////////////////////////////
// FUNCTION: do_fake_schreck
// CALLED ON: a guard tower exploder trigger
// PURPOSE: This will spawn panzerschreck fire from a struct targeted by the trigger every so 
//          often. If it is targeting multiple structs it will pick the best one. The fire will
//          stop once the guard tower is destroyed
// ADDITIONS NEEDED: 
/////////////////////////////////
do_fake_schreck()
{
	self endon( "stop firing" );
	self thread wait_for_my_sploder();
	
	schrecks = getStructArray( self.target, "targetname" );
	
	while( 1 )
	{
		if( !isDefined( level.player_tanks ) )
		{
			wait( 0.05 );
			continue;
		}
		best_target = self maps\_vehicle::get_nearest_target( level.player_tanks );
		for( i = 0; i < schrecks.size; i++ )
		{
			if( !check_in_arc( schrecks[i], best_target, 30 ) )
			{
				continue;
			}
			if( distancesquared( best_target.origin, schrecks[i].origin ) > (3500*3500) )
			{
				continue;
			}
			
			current_target = self maps\see2::request_target( best_target );
			trace = bullettrace( schrecks[i].origin, current_target.origin, false, undefined );
			if( trace["fraction"] < 0.95 )
			{
				continue;
			}
			dist = distance( current_target.origin, schrecks[i].origin );
			level thread fire_schreck_at_pos( schrecks[i], current_target.origin, dist/2100 );
			wait( 10 );
			break;
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: check_in_arc
// CALLED ON: a panzerschreck node
// PURPOSE: This checks to see if a player is in a specified arc for a given node (using its 
//          orientation as the basis for the arc orientation). Returns true if it is in the arc,
//          false if it is not
// ADDITIONS NEEDED: None
/////////////////////////////////
check_in_arc( targeter, target, arc )
{
	if( !isDefined( targeter ) || !isDefined( target ) || !isDefined( arc ) )
	{
		/#
		iprintln( "COULD NOT FIRE SCHRECK, BAD DATA" );
		#/
		return false;
	}
	
	toVec = target.origin - targeter.origin;
	toVec = ( toVec[0], toVec[1], 0 );
	toAng = vectorToAngles( toVec );
	if( abs(targeter.angles[1] - toAng[1]) < arc ) 
	{
		return true;
	}
	
	return false;
}

/////////////////////////////////
// FUNCTION: fire_schreck_at_pos
// CALLED ON: level
// PURPOSE: This spawns a panzerschreck round and moves it from a start position to its target
//          exploding when it reaches its target.
// ADDITIONS NEEDED: Make the damage and radius a tunable value
//
// Gavin's Changes: Added a damage entity that can be used so that the HUD points at the shrecks origin instead
//                  of using the world for the radius damage.
/////////////////////////////////
fire_schreck_at_pos( spawn_struct, target_pos, time )
{
	// CODER_MOD : DSL - Make sure that the current snapshot isn't too crazy, before spawning one of these guys.

	while( !OkToSpawn() )
	{
		wait( 0.1 );
	}
	
	shreck = spawn("script_model", spawn_struct.origin);
	shreck.angles = vectortoangles( target_pos - spawn_struct.origin );
	shreck setmodel("weapon_ger_panzershreck_rocket");
	
	//-- Damage Entity
	shreck_damage_ent = spawn("script_model", spawn_struct.origin);
		
	dest = target_pos;
	
	shreck moveTo( dest, time );
	playFxOnTag( level._effect["rocket_trail"], shreck, "tag_fx" );
	shreck playloopsound("rpg_rocket");
	wait time;
	
	shreck hide();
	
	playfx( level._effect["shreck_explode"], shreck.origin );
	
	shreck stoploopsound();
	playSoundAtPosition("rpg_impact_boom", shreck.origin);
	radiusdamage( shreck.origin, 256, 250, 250, shreck_damage_ent );
	//earthquake( 0.5, 1.5, shreck.origin, 512 );
	
	wait( 4 );
	shreck Delete();
	shreck_damage_ent Delete();
}

/////////////////////////////////
// FUNCTION: wait_for_my_sploder
// CALLED ON: an exploder trigger
// PURPOSE: Tells any fake panzerschrecks linked to a trigger to stop firing when the trigger is
//          activated
// ADDITIONS NEEDED: None
/////////////////////////////////
wait_for_my_sploder()
{
	self waittill( "trigger" );
	self notify( "stop firing" );
}

/////////////////////////////////
// FUNCTION: do_flame_bunker
// CALLED ON: level
// PURPOSE: This generates fake panzerschreck fire from a flame bunker. It also generates drones
// 					to stand at the appropriate positions for flame deaths in case the bunker is flamed.
//					drones are spawned based on the front_death, side_death and rear_death variables. 
//          Currently all do_flame_bunker calls have these set to false for drone limit reasons. 
//          The correct values are commented out next to these calls, so simply uncomment them to
//          get proper behavior.
// ADDITIONS NEEDED: None, but need to work with animator to get anim positions synced.
//
// GAVIN CHANGE: the bunker now needs to be flamed for a certain period of time before it explodes
//								and there is an added trigger to the bunker to trigger the model swap
//
/////////////////////////////////
do_flame_bunker( bunker_name, event, front_death, side_death, rear_death, kill_drones_at_spawn )
{
	trigger = GetEnt( bunker_name+" damage trigger", "script_noteworthy" );
	trigger.swap_trigger = GetEnt( bunker_name+" anim trigger", "script_noteworthy" );
	
	tank_trigger = GetEnt( bunker_name+" tank trigger", "script_noteworthy" );	
	/#
	tank_Trigger thread debug_line_on_damage();
	#/
	
	anim_nodes = GetStructArray( bunker_name+" anim node", "script_noteworthy" );
	anim_node = anim_nodes[0];
	front_guard = undefined;
	side_guard = undefined;
	rear_guard = undefined;
	if( isDefined( front_death ) && front_death )
	{
		index = 1;//randomint(level.scr_anim["flame_bunker"]["front_death"].size);
		curr_anim = level.scr_anim["flame_bunker"]["front_death"][index];
		newOrigin = GetStartOrigin( anim_node.origin, anim_node.angles, curr_anim );
		newAngles = GetStartAngles( anim_node.origin, anim_node.angles, curr_anim );
		spawn_origin = spawnstruct();
		spawn_origin.origin = newOrigin;
		spawn_origin.angles = newAngles;
		trigger.front_guard = maps\_drone::drone_scripted_spawn( "actor_axis_ger_ber_wehr_reg_kar98k", spawn_origin );
		trigger.front_guard.flame_anim = curr_anim;
		trigger.front_guard thread maps\_drone::drone_idle();
		tank_trigger.front_guard = trigger.front_guard;
		trigger.front_guard SetCanDamage( true );
		
		if( IsDefined( kill_drones_at_spawn ) && kill_drones_at_spawn )
		{
				trigger.front_guard DoDamage( trigger.front_guard.health * 2, trigger.front_guard.origin, get_players()[0] );
		}
	}
	
	if( isDefined( side_death ) && side_death )
	{
		index = 1;//randomint(level.scr_anim["flame_bunker"]["side_death"].size);
		curr_anim = level.scr_anim["flame_bunker"]["side_death"][index];
		newOrigin = GetStartOrigin( anim_node.origin, anim_node.angles, curr_anim );
		newAngles = GetStartAngles( anim_node.origin, anim_node.angles, curr_anim );
		spawn_origin = spawnstruct();
		spawn_origin.origin = newOrigin;
		spawn_origin.angles = newAngles;
		trigger.side_guard = maps\_drone::drone_scripted_spawn( "actor_axis_ger_ber_wehr_reg_kar98k", spawn_origin );
		trigger.side_guard.flame_anim = curr_anim;
		trigger.side_guard thread maps\_drone::drone_idle();
		tank_trigger.side_guard = trigger.side_guard;
		trigger.side_guard SetCanDamage( true );
		
		if( IsDefined( kill_drones_at_spawn ) && kill_drones_at_spawn )
		{
				trigger.side_guard DoDamage( trigger.side_guard.health * 2, trigger.side_guard.origin, get_players()[0] );
		}
	}
	
	if( isDefined( rear_death ) && rear_death )
	{
		index = 1;//randomint(level.scr_anim["flame_bunker"]["rear_death"].size);
		curr_anim = level.scr_anim["flame_bunker"]["rear_death"][index];
		newOrigin = GetStartOrigin( anim_node.origin, anim_node.angles, curr_anim );
		newAngles = GetStartAngles( anim_node.origin, anim_node.angles, curr_anim );
		spawn_origin = spawnstruct();
		spawn_origin.origin = newOrigin;
		spawn_origin.angles = newAngles;
		trigger.rear_guard = maps\_drone::drone_scripted_spawn( "actor_axis_ger_ber_wehr_reg_kar98k", spawn_origin );
		trigger.rear_guard.flame_anim = curr_anim;
		trigger.rear_guard thread maps\_drone::drone_idle();
		tank_trigger.rear_guard = trigger.rear_guard;
		trigger.rear_guard SetCanDamage( true );
		
		if( IsDefined( kill_drones_at_spawn ) && kill_drones_at_spawn )
		{
				trigger.rear_guard DoDamage( trigger.rear_guard.health * 2, trigger.rear_guard.origin, get_players()[0] );
		}
	}

 	trigger thread do_fake_fb_schrecks( bunker_name );
 	trigger thread do_fb_effects();

	tank_trigger thread do_flame_bunker_tank_damage( bunker_name );
	trigger thread do_flame_bunker_flame_damage( bunker_name );

	level notify( "event" );

}

do_flame_bunker_tank_damage(bunker_name)
{
	level endon( bunker_name + "destroyed" );
	
	trigger = self;
	
	bunker_hit_max = 3;
	bunker_hit_counter = 0;
	
	while(1)
	{
		trigger waittill( "damage", damage, other, direction, origin, damage_type );
		
		if(damage_type == "MOD_PROJECTILE")
		{
			bunker_hit_counter++;
			
			if(bunker_hit_counter == bunker_hit_max)
			{
				//-- Destroy the bunker
				level notify( bunker_name + "end_schrecks");
				trigger thread do_secondary_fb_effects(bunker_name, true, other);
			}			
		}
	}
}

do_flame_bunker_flame_damage(bunker_name)
{
	level endon( bunker_name + "destroyed" );
	
	trigger = self;
	
	while(1)
	{
		trigger waittill( "damage", damage, other, direction, origin, damage_type );
		if( damage_type == "MOD_BURNED")
		{
			break;
		}
	}
	
	if( other == get_players()[0] )
	{
		level notify( "destruction" );
	}
	
	animNotify = "generic";
	
	if( damage_type == "MOD_BURNED" )
	{
		flame_time = 0;
		flame_time_threshold = 10;
		
		if( isDefined( trigger.front_guard ) )
		{
			trigger.front_guard notify( "bunker flamed" );
			trigger.front_guard DoDamage( trigger.front_guard.health * 2, trigger.front_guard.origin, get_players()[0]);
			//trigger.front_guard animscripted( animNotify, trigger.front_guard.origin, trigger.front_guard.angles, trigger.front_guard.flame_anim );
			//trigger.front_guard thread cleanup_drones();
		}
		if( isDefined( trigger.side_guard ) )
		{
			trigger.side_guard notify( "bunker flamed" );
			trigger.side_guard DoDamage( trigger.side_guard.health * 2, trigger.side_guard.origin, get_players()[0]);
			//trigger.side_guard animscripted( animNotify, trigger.side_guard.origin, trigger.side_guard.angles, trigger.side_guard.flame_anim );
			//trigger.side_guard thread cleanup_drones();
		}
		if( isDefined( trigger.rear_guard ) )
		{
			trigger.rear_guard notify( "bunker flamed" );
			trigger.rear_gaurd DoDamage( trigger.rear_guard.health * 2, trigger.rear_guard.origin, get_players()[0]);
			//trigger.rear_guard animscripted( animNotify, trigger.rear_guard.origin, trigger.rear_guard.angles, trigger.rear_guard.flame_anim );
			//trigger.rear_guard thread cleanup_drones();
		}
		
		while( flame_time < flame_time_threshold )
		{
			trigger waittill( "damage" );
			flame_time++;
			wait(0.05);
		}
			
		//wait( randomfloatrange( 2, 4 ) );
		
		trigger thread do_secondary_fb_effects(bunker_name, undefined, other);
	}
	
	wait( 0.05 );	
}

/////////////////////////////////
// FUNCTION: cleanup_drones
// CALLED ON: a drone
// PURPOSE: Waits until no players are looking at a drone then deletes it
// ADDITIONS NEEDED: None
/////////////////////////////////
cleanup_drones()
{
	while( 1 )
	{
		visible = false;
		for( i = 0; i < get_players().size; i++ )
		{
			myOrg = self.origin;
			myOrg = ( myOrg[0], myOrg[1], 0 );
			theirOrg = get_players()[i].origin;
			theirOrg = ( theirOrg[0], theirOrg[1], 0 );
			theirAng = get_players()[i].angles;
			
			diff = VectorToAngles( myOrg - theirOrg ) - theirAng;
			
			if( abs( diff[1] ) < 35 ) 
			{
				visible = true;
			}
		}
		if( !visible )
		{
			break;
		}
		wait( 0.05 );
	}
	self notify( "delete" );
}

/////////////////////////////////
// FUNCTION: do_fake_fb_schrecks
// CALLED ON: a flame bunker trigger
// PURPOSE: This finds the best panzerschreck node to target the bunker's current target then
//          fires a panzerschreck round at it.
// ADDITIONS NEEDED: Need to use check_in_arc similarly to the do_fake_schreck function
/////////////////////////////////
do_fake_fb_schrecks( bunker_name )
{
	self endon( "trigger" );
	level endon( bunker_name + "end_schrecks");
	schreck_nodes = getStructArray( self.target, "targetname" );
	
	while( 1 )
	{
		current_target = undefined;
		target_array = get_players();
		dist = 999999;
		fire_node = -1;
		for( i = 0; i < schreck_nodes.size; i++ )
		{
			for( j = 0; j < target_array.size; j++ )
			{
				dist = distanceSquared( schreck_nodes[i].origin, target_array[j].origin );
				if( dist > (3500 * 3500) )
				{
					continue;
				}
				trace = bullettrace( schreck_nodes[i].origin, target_array[j].origin+(0,0,30), false, undefined );
				if( trace["fraction"] > 0.95 )
				{
					current_target = target_array[j]; 
					fire_node = i;
					break;
				}
			}
			if( isDefined( current_target ) )
			{
				break;
			}
		}
		if( isDefined( current_target ) )
		{
			dist = distance( schreck_nodes[fire_node].origin, current_target.origin );
			level thread fire_schreck_at_pos( schreck_nodes[fire_node], current_target.origin+(randomfloatrange( -100, 100 ), randomfloatrange( -100, 100 ),30), dist/2100 );
			wait( randomintrange( 10, 15 ) );
		}
		else
		{
			wait( 1 );
		}
	}
}

/////////////////////////////////
// FUNCTION: do_fb_effects
// CALLED ON: flame bunker trigger
// PURPOSE: Causes flame effects to play on the panzerscheck nodes when the bunker is flamed
// ADDITIONS NEEDED: None
/////////////////////////////////
do_fb_effects()
{
	self.no_damage_timer = 0;
	self.shutoff_time = 5;
	exit_points = getStructArray( self.target, "targetname" );

	while( 1 )
	{
		self waittill( "damage", damage, other, direction, origin, damage_type );
		
		if( damage_type != "MOD_BURNED" )
		{
			continue;
		}
	 	self thread do_timer_resets();
	 	self thread increment_damage_timer();
	 	for( i = 0; i < exit_points.size; i++ )
	 	{
	 		playfx( level._effect["bunker_fire_start"], exit_points[i].origin, anglestoforward( exit_points[i].angles ) );
	 	}
		while( self.no_damage_timer < self.shutoff_time )
		{
			for( i = 0; i < exit_points.size; i++ )
			{
				playfx( level._effect["bunker_fire_out"], exit_points[i].origin, anglestoforward( exit_points[i].angles ) );
			}
			wait( 4.95 );
		}
		self notify( "kill_fx" );
	}
}

/////////////////////////////////
// FUNCTION: do_secondary_fb_effects
// CALLED ON: flame bunker trigger
// PURPOSE: This plays a series of flashes, followed by a massive explosion if a bunker is burned
//          out. Happens first time only, and only with flame damage.
// ADDITIONS NEEDED: All these FX need a sound treatment
/////////////////////////////////
do_secondary_fb_effects( bunker_name, tank_kill, attacker )
{
	if(IsDefined(tank_kill))
	{
		//-- Do anything special that needs to happen because a tank killed the bunker
		if( isDefined( self.front_guard ) )
		{
			self.front_guard Delete();
		}
		if( isDefined( self.side_guard ) )
		{
			self.side_guard Delete();
		}
		if( isDefined( self.rear_guard ) )
		{
			self.rear_guard Delete();
		}
	}
	
	playfx( level._effect["bunker_secondary_flash"], self.origin, anglestoforward( self.angles ) );
	wait( 1 );
	
	exploder_trigger = getEnt( bunker_name + " damage trigger exploder", "script_noteworthy" );
	exploder_trigger notify( "trigger" );
	
	damage_trigger = GetEnt( bunker_name + " damage trigger", "script_noteworthy");
	exit_points = getStructArray( damage_trigger.target, "targetname" );

 	for( i = 0; i < exit_points.size; i++ )
 	{
 		playfx( level._effect["bunker_secondary_window"], exit_points[i].origin, anglestoforward( exit_points[i].angles ) );
 	}
 	
 	wait(0.1); //-- give the fx time to populate
 	if(IsDefined(damage_trigger.swap_trigger))
	{
		damage_trigger.swap_trigger notify( "trigger" );
	}
	
	//-- Arcade points
	player_hit_me = undefined;
	if( IsPlayer( attacker ) )
	{
		player_hit_me = attacker;
	}
	else if( IsDefined(attacker.classname) && attacker.classname == "script_vehicle" )
	{
		veh_owner = attacker GetVehicleOwner();
		
		if(IsDefined(veh_owner) && IsPlayer(veh_owner))
		{
			player_hit_me = attacker;
		}
	}

	if(IsDefined(player_hit_me))
	{
		arcademode_assignpoints( "arcademode_score_generic500", player_hit_me );
	}
	
	level notify( "achievement_destroy_notify", "bunker" );
	level notify( bunker_name + "destroyed" );
}

/////////////////////////////////
// FUNCTION: increment_damage_timer
// CALLED ON: flame bunker trigger
// PURPOSE: Used to determine when the window fx need to be refreshed if the player continues to
//          flame a bunker by incrementing a counter
// ADDITIONS NEEDED: None
/////////////////////////////////
increment_damage_timer()
{
	while( 1 )
	{
		self.no_damage_timer += 0.05;
		if( self.no_damage_timer > self.shutoff_time )
		{
			return;
		}
		wait( 0.05 );
	}
}

/////////////////////////////////
// FUNCTION: do_timer_resets
// CALLED ON: flame bunker trigger
// PURPOSE: Resets the damage counter whenever a new damage event occurs
// ADDITIONS NEEDED: None
/////////////////////////////////
do_timer_resets()
{
	self endon( "kill fx" );
	while( 1 )
	{
		self waittill( "damage", damage, other, direction, origin, damage_type );
		if( damage_type == "MOD_BURNED" )
		{
			self.no_damage_timer = 0;
		}
	}
}

/////////////////////////////////
// FUNCTION: setup_flame_bunker_guard
// CALLED ON: an AI
// PURPOSE: This sets the AI values for a flame bunker guard
// ADDITIONS NEEDED: This is deprecated, it should be pulled out, since
//                   flame bunker guards are going to be drones.
/////////////////////////////////
setup_flame_bunker_guard()
{
	if( self.classname == "actor_axis_ger_ber_wehr_reg_panzerschrek" )
	{
		self.a.rockets = 200;
		self.maxsightdistsqrd = 3000*3000;
		self.a.no_weapon_switch = true;
		self.ignoreall = true;
	}
}

/////////////////////////////////
// FUNCTION: do_fortification_spawn
// CALLED ON: Level
// PURPOSE: Is used to gate the spawns of the drones that man the 88s, towers and flame bunkers
// ADDITIONS NEEDED: 
// ADDED BY: G. Locke (8/11/08)
/////////////////////////////////
do_fortification_spawn( groupNum )
{
	damage_triggers = GetEntArray( "guardtower group " + groupNum, "targetname" );
	
	if(damage_triggers.size == 0)
	{
		return;
	}
	
	for( i = 0; i < damage_triggers.size; i++ )
	{
		drone_struct = getStruct( damage_triggers[i].target, "targetname" );
		
		while( !OkToSpawn() )
		{
			wait(0.05);
		}
		
		drone = maps\_drone::drone_scripted_spawn( "actor_axis_ger_ber_wehr_reg_kar98k", drone_struct );
		damage_triggers[i].myDrone = drone;
	
		damage_triggers[i] thread wait_for_single_sploder();
		level.enemy_armor = array_add( level.enemy_armor, damage_triggers[i] );
	}
	
}