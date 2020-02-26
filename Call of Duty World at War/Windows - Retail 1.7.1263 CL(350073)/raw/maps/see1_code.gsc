#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_hud_util;

// TELEPORT
//////////////////////////////////////////////////////////////////////////////////////////

// Teleports players to a temporary position, then teleport the AI
// Required: Have at least 4 script structs with targetname "temp_player_pos" in a safe position on map
// Required: Call teleport_players after all AIs are done teleporting, to restore player position
teleport_actor( node_targetname )
{
	node = getnode( node_targetname, "targetname" );
	if( !isdefined( node ) )
	{
		//iprintlnbold( "ERROR: Node not found to teleport AI to" );
		return;
	}

	players = get_players();
	teleport_points = getstructarray( "temp_player_pos", "targetname" );

	if( teleport_points.size < 4 )
	{
		//iprintlnbold( "ERROR: Not enough temp_player_pos structs in map" );
		return;
	}

	for( i = 0; i < players.size; i++ )
	{
		players[i] setorigin( teleport_points[i].origin );
	}

	self teleport( node.origin, node.angles );
	self setgoalpos( node.origin );	
}

teleport_actor_to_node( node )
{
	players = get_players();
	teleport_points = getstructarray( "temp_player_pos", "targetname" );

	if( teleport_points.size < 4 )
	{
		//iprintlnbold( "ERROR: Not enough temp_player_pos structs in map" );
		return;
	}

	for( i = 0; i < players.size; i++ )
	{
		players[i] setorigin( teleport_points[i].origin );
	}

	self teleport( node.origin, node.angles );
	self setgoalpos( node.origin );	
}

teleport_players( start_nodes_targetname )
{
	nodes = getnodearray( start_nodes_targetname,"targetname" );
	
	if( nodes.size < 4 )
	{
		//iprintlnbold( "ERROR: Not enough nodes to start players at" );
		return;
	}

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] setorigin( nodes[i].origin + (0,0,4) );
		players[i] setplayerangles( nodes[i].angles );
	}
}

teleport_friendlies( hero1_node_name, hero2_node_name, friends_node_name )
{
	level.hero1 teleport_actor( hero1_node_name );
	level.hero2 teleport_actor( hero2_node_name );

	nodes = getnodearray( friends_node_name, "targetname" );
	if( nodes.size < level.friends.size )
	{
		//iprintlnbold( "ERROR: Not enough nodes to teleport AIs" );
		return;
	}
	for( i = 0; i < level.friends.size; i++ )
	{
		if( isalive( level.friends[i] ) )
		{
			level.friends[i] teleport_actor_to_node( nodes[i] );
		}
	}
}


// AI
//////////////////////////////////////////////////////////////////////////////////////////

// Delete live AIs upon flag set. Use it to clean up old AIs in the earlier zones
// - If no name is specified, all enemy AIs are deleted
clean_previous_ai( _flag, name, type )
{
	flag_wait( _flag );
	
	ai = undefined;
	
	if( !isdefined( name ) )
		ai = getaispeciesarray( "axis", "all" );
	else
		ai = get_living_aispecies_array( name, type );
		
	for( i=0; i<ai.size; i++ )
		ai[i] delete();
}

initialize_spawn_function( name, key, spawn_func )
{
	spawners = getEntArray( name, key );
	
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			if( !isalive( spawners[i] ) )
			{
				if( !isdefined( spawners[i].spawn_functions ) )
				{
					spawners[i].spawn_functions = [];
				}
				spawners[i] add_spawn_function( spawn_func );
			}
		}
	}
}

force_to_goal( damage_detection )
{
	self endon( "death" );
	
	old_goal_radius = self.goalradius;

	self hold_fire();
	self.goalradius = 256; // pretty close to goal but not exact

	if( isdefined( damage_detection ) )
	{
		self thread damage_detection(); // if shot at during the run, seek cover immediately
	}

	self waittill_either( "goal", "damaged" );
	
	self resume_fire();
	self.goalradius = old_goal_radius;
}

force_to_goal_exact( damage_detection )
{
	self endon( "death" );
	
	old_goal_radius = self.goalradius;

	self hold_fire();
	self.goalradius = 4; // exactly to the goal

	if( isdefined( damage_detection ) )
	{
		self thread damage_detection(); // if shot at during the run, seek cover immediately
	}

	self waittill_either( "goal", "damaged" );
	
	self resume_fire();
	self.goalradius = old_goal_radius;
}

reinforce_goal( node, time )
{
	self endon( "death" );
	
	init_pos = self.origin;

	wait( time );

	distance_moved = distance( self.origin, init_pos );
	if( distance_moved < 32 )
	{
		self setgoalnode( node );
	}
}

simple_spawn_force_to_goal()
{
	self thread force_to_goal( true );
}

simple_spawn_force_to_goal_exact()
{
	self thread force_to_goal_exact( true );
}

simple_spawn_force_to_goal_no_stop()
{
	self thread force_to_goal();
}

damage_detection()
{
	self endon( "goal" );
	self endon( "death" );
	
	starting_health = self.health;
	while( 1 )
	{
		if( starting_health > self.health )
		{
			self notify( "damaged" );
			return;
		}
		wait( 0.05 );
	}
}

spawn_friendlies()
{
	level.hero1 = force_spawn_ai( "hero1" );
	level.hero2 = force_spawn_ai( "hero2" );
	wait( 0.5 );
	level.friends = force_spawn_ai_array( "friend" );

	level.hero1 thread magic_bullet_shield();
	level.hero2 thread magic_bullet_shield();

	for( i = 0; i < level.friends.size; i++ )
	{
		//level.friends[i] thread magic_bullet_shield();
	}

	level.hero1.name = "Sgt. Reznov";
	level.hero2.name = "Pvt. Chernov";

	level.hero1.script_friendname = "Sgt. Reznov";
	level.hero2.script_friendname = "Pvt. Chernov";

	level.hero1.animname = "reznov";
	level.hero2.animname = "chernov";
}

force_spawn_ai( spawner_name )
{
	spawner = getent( spawner_name, "targetname" );
	spawned = spawner stalingradSpawn( true );
	if( spawn_failed( spawned ) )
	{
		//iprintlnbold( "ERROR: Spawn failed" );
		return;
	}

	spawned setthreatbiasgroup( "squad" );
	//spawned.script_grenades = 4;
	//spawned.grenadeWeapon = "molotov";

	return spawned;
}

force_spawn_ai_array( spawners_name )
{
	spawners = getentarray( spawners_name, "targetname" );
	spawned = [];
	for( i = 0; i < spawners.size; i++ )
	{
		spawned[i] = spawners[i] stalingradSpawn( true );
		if( spawn_failed( spawned[i] ) )
		{
			//iprintlnbold( "ERROR: Spawn failed" );
			return;
		}
		spawned[i] setthreatbiasgroup( "squad" );
		spawned[i].accuracy = 0.1;

		//spawned[i].script_grenades = 4;
		//spawned[i].grenadeWeapon = "molotov";
	}
	return spawned;
}

hold_fire()
{	
	self.pacifist = 1;
	self.ignoreall = 1;
}

all_friends_hold_fire()
{	
	friends = getAIArray( "allies" );
	for( i = 0; i < friends.size; i++ )
	{
		friends[i].pacifist = 1;
		friends[i].ignoreall = 1;
	}
}

all_friends_resume_fire()
{	
	friends = getAIArray( "allies" );
	for( i = 0; i < friends.size; i++ )
	{
		friends[i].pacifist = 0;
		friends[i].ignoreall = 0;
	}
}

resume_fire()
{	
	self.pacifist = 0;
	self.ignoreall = 0;
}

prepare_players()
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] setthreatbiasgroup( "players" );
	}
}


assign_random_retreat_anim()
{
	index = randomint( 100 );
	if( index < 20 )
	{
		//self putGunAway();
		self set_run_anim( "panick_run_1" );
	}
	else if( index < 30 )
	{
		//self putGunAway();
		self set_run_anim( "panick_run_2" );
	}
}

/*
play_random_turning_anim()
{
	self anim_single_solo( self, "panick_turn_4" );

	index = randomint( 100 );
	if( index < 15 )
	{
		//self anim_single_solo( self, "panick_turn_1" );
	}
	else if( index < 30 )
	{
		self anim_single_solo( self, "panick_turn_2" );
	}
}
*/

reset_run_anim()
{
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = self.a.combatrunanim;
	self.walk_combatanim = self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.preCombatRunEnabled = false;
}


play_random_return_fire_anim()
{
	wait( randomfloat( 2 ) + 2 );

	index = randomint( 100 );
	if( index < 10 )
	{
		self anim_single_solo( self, "return_fire_1" );
	}
	else if( index < 20 )
	{
		self anim_single_solo( self, "return_fire_2" );
	}
}

say_dialogue( animname, theLine, lookTarget )
{
	self.istalkingnow = true;
	self.og_animname = self.animname;
	self.animname = animname;
	//iprintlnbold( theLine );
	/*
	sound_name = level.scr_sound[animname][theLine];

	if( isdefined( lookTarget ) )
	{
		self thread playsound_generic_facial( sound_name, lookTarget );
	}
	else
	{
		self thread playsound_generic_facial( sound_name, undefined );
	}
*/
	self anim_single_solo( self, theLine );
	self.animname = self.og_animname;
	self.istalkingnow = false;
}

say_dialogue_wait( animname, theLine, lookTarget )
{
	if( !isdefined( self.istalkingnow ) )
	{
		self.istalkingnow = false;
	}

	while( self.istalkingnow )
	{
		wait( 0.1 );
	}

	self.istalkingnow = true;
	self.og_animname = self.animname;
	self.animname = animname;
	//iprintlnbold( theLine );
/*
	sound_name = level.scr_sound[animname][theLine];

	if( isdefined( lookTarget ) )
	{
		self thread playsound_generic_facial( sound_name, lookTarget );
	}
	else
	{
		self thread playsound_generic_facial( sound_name, undefined );
	}
*/
	self anim_single_solo( self, theLine );
	self.animname = self.og_animname;
	self.istalkingnow = false;
}

run_chain_nodes( start_node )
{
	self endon( "death" );
	goal_radius = self.goalradius + 50;
	self setgoalnode( start_node );
	self waittll_close_enough( start_node.origin, goal_radius );

	while( isdefined( start_node.target ) )
	{
		next_node = getnode( start_node.target, "targetname" );
		self setgoalpos( next_node.origin );
		self waittll_close_enough( next_node.origin, goal_radius );
		start_node = next_node;
	}
	self notify( "chain_ends" );
}

waittll_close_enough( pos, radius )
{
	self endon( "death" );

	init_pos = self.origin;
	frame_counter = 0;
	while( distance( self.origin,  pos ) > radius )
	{
		wait( 0.05 );
/*
		frame_counter++;
		if( frame_counter > 60 ) // 3 secs
		{	
			frame_counter = 0;

			if( distance( init_pos, self.origin ) < 32 )
			{
				self notify( "death" );
			}
			else
			{
				init_pos = self.origin;
			}
		}
*/
	}
}

find_cover( msg )
{
	self endon( "death" );

	self waittill( msg );
	self FindCoverNode();
}

// TANK
//////////////////////////////////////////////////////////////////////////////////////////

// 1. Spawn a T34 when trigger is hit
// 2. Have the T34 continuously fire at the designated target
// 3. After a delay (or none) the tank moves along the path
// 4. When the tank reaches a specified node, it stops and wait (wait can be 0 sec)
// 5. A panzershreck/or artillery fire coming from a specified position will hit and destroy the tank
// 6. (TODO) play anims of guys climbing out
//
// Ex: t34_move_and_blow_up( trigger1, start_node ) -> will spawn and move the tank, nothing else
//     t34_move_and_blow_up( trigger1, start_node, true ) -> will spawn and move the tank and have it fire while moving
//	   t34_move_and_blow_up( trigger1, start_node, undefined, death_node )
//									-> spawn and move tank. It does not fire. Get blown up at death_node

t34_move_and_blow_up( 	spawn_trigger_name, 	// required
						start_node_name, 		// required
						open_fire,				// make tank fire forard continuously if set. Leave it undefined otherwise
						death_node_name,				// if undefined, the tank will keep going till the last node and not die
						artillery_origin_struct_name,  	// can be undefined or left out
															// if left out, the tank will be destroyed by generic explosion
						initial_wait_delay, 	// can be 0, undefined, or left out
						stop_wait_delay ) 		// can be 0, undefined, or left out
{
	spawn_trigger = getent( spawn_trigger_name, "targetname" );
	if( !isdefined( spawn_trigger ) )
	{
		//iprintlnbold( "ERROR: No tank spawn trigger found" );
		return;
	}

	start_node = getvehiclenode( start_node_name, "targetname" );
	if( !isdefined( start_node ) )
	{
		//iprintlnbold( "ERROR: No tank start node found" );
		return;
	}

	
	spawn_trigger waittill( "trigger" );
		
	// spawn
	tank = spawnvehicle( "vehicle_rus_tracked_t34", 
						 "tank", 
						 "t34", 
						 start_node.origin, 
						 start_node.angles );		

	tank attachPath( start_node );

	// start firing if needed
	if( isdefined( open_fire ) )
	{
		tank thread fire_loop_generic();
	}

	// wait before moving up
	if( isdefined( initial_wait_delay ) )
	{
		wait( initial_wait_delay );
	}
	
	// move up
	tank startpath();
		
	// find the node the trigger death
	if( isdefined( death_node_name ) )
	{
		death_node = getvehiclenode( death_node_name, "targetname" );
		if( isdefined( death_node ) )
		{
			tank setwaitnode( death_node );
			tank waittill( "reached_wait_node" );

			if( isdefined( artillery_origin_struct_name ) )
			{
				// TODO: Destroy the tank via a panzershreck trail from this position
			}
			else
			{
				// generic explosion
				playfx( level.fx_vehicle_explosion, tank.origin );
				tank setspeed( 0, 10, 10 );
				players = get_players();
				tank DoDamage( tank.health + 1, ( 0, 0, 0 ), players[0] );
			}
		}
	}
}

fire_loop_generic()
{
	self endon( "death" );
	self endon( "stop_fire" ); // optional way to end fire loop

	while( 1 )
	{
		wait( randomint( 2 ) + 3 );
		self FireWeapon();
	}
}

spawn_tigers()
{
	scripted_spawn_go( 200 );

	wait( 2 );

	level.ev2_tank1 = getent( "ev2_tank1", "targetname" );
	level.ev2_tank2 = getent( "ev2_tank2", "targetname" );
	level.ev2_tank3 = getent( "ev2_tank3", "targetname" );

	level.ev2_tank1.health = 10000;
	level.ev2_tank2.health = 10000;
	level.ev2_tank3.health = 10000;
}

check_for_panzershreck_hit( num_hits_to_kill )
{
	hits_taken = 0;

	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		
		valid_type = false;
		
		if ( type == "MOD_PROJECTILE_SPLASH" || type == "MOD_PROJECTILE" )
		{
			valid_type = true;
		}
				
		if ( maps\_collectibles::has_collectible( "collectible_sticksstones" ) )
		{
			if ( isplayer( attacker ) && type == "MOD_IMPACT" )
			{
				valid_type = true;
			}
			else
			{
				valid_type = false;
			}
		}
	
		if( valid_type == true )
		{
			if( isplayer( attacker ) || attacker.team == "axis" )
			{
				hits_taken++;
				if( hits_taken >= num_hits_to_kill )
				{
					playfx( level._effect["tank_blow_up"], self.origin );
					playfx( level._effect["tank_smoke_column"], self.origin );
					self.script_team = "axis";
					self dodamage( self.health + 100, ( 0, 0, 0 ), attacker, attacker );
					//self arcademode_assignpoints( "arcademode_score_tank", attacker );
					self notify( "death", attacker );
					return;
				}

				//self setmodel( "vehicle_ger_tracked_king_tiger_d_inter" );
				self notify( "hit_damage" );

				chance = randomint( 100 );
				if( chance < 40 )
				{
					level.hero1 say_dialogue( "reznov", "fire_shreck" );
				}
				else if( chance < 80 )
				{
					level.hero1 say_dialogue( "reznov", "again" );
				}
				else
				{
					level.hero1 say_dialogue( "reznov", "again" );
					level.hero1 say_dialogue( "reznov", "fire_shreck" );
				}
			}
		}
	}
}
// TRIGGER
//////////////////////////////////////////////////////////////////////////////////////////

// set off a trigger
script_trigger( trigger_name )
{
	trigger = getent( trigger_name, "targetname" );
	trigger notify( "trigger" );
}

script_trigger2( trigger_name, key )
{
	trigger = getent( trigger_name, key );
	trigger notify( "trigger" );
}

script_notify_trigger( trigger_name, key, msg )
{
	trigger = getent( trigger_name, key );
	trigger notify( msg );
}

auto_turn_off_trigger( trigger, time )
{
	trigger waittill( "trigger" );
	wait( time );
	if( isdefined( trigger ) )
	{
		trigger trigger_off();
	}
}

auto_mutex_triggers( trigger1, trigger2 )
{
	level thread turn_off_mutex_trigger( trigger1, trigger2 );
	level thread turn_off_mutex_trigger( trigger2, trigger1 );
}

turn_off_mutex_trigger( trigger1, trigger2 )
{
	trigger2 endon( "trigger" );

	trigger1 waittill( "trigger" );
	trigger2 trigger_off();
}

wait_for_trigger_and_notify( trigger, msg )
{
	trigger waittill( "trigger" );
	level notify( msg );
}

wait_for_trigger_and_notify_ent( trigger, ent, msg )
{
	trigger waittill( "trigger" );
	ent notify( msg );
}

wait_time( time, msg )
{
	wait( time );
	level notify( msg );
}

// OBJECTIVE
//////////////////////////////////////////////////////////////////////////////////////////

// add an objective, using given script_struct for positioning
objective_add_new( num, obj_string, struct_name )
{
	obj_position = getstruct( struct_name, "targetname" );
	if( isdefined( obj_position ) )
	{
		objective_add( num, "current", obj_string, obj_position.origin );
	}
	else
	{
		//iprintlnbold( "ERROR: objective position struct not found" );
	}
}

// add an objective and set it as done
objective_add_done( num, obj_string )
{
	objective_add( num, "current", obj_string );
	objective_state( num, "done" );
}

// wait until a trigger goes off, then complete the objective
objective_triggered_complete( num, trigger_name )
{
	trigger_wait( trigger_name, "targetname" );
	objective_state( num, "done" );
}


// wait until a trigger goes off, then update the objective star to the 
// position of the new struct. Mainly used to guide the player through a 
// series of objective star updates
objective_triggered_update_position( num, trigger_name, next_struct_name )
{
	trigger_wait( trigger_name, "targetname" );
	
	obj_position = getstruct( next_struct_name, "targetname" );
	if( isdefined( obj_position ) )
	{
		objective_position( num, obj_position.origin );
	}
	else
	{
		//iprintlnbold( "ERROR: new objective position struct not found" );
	}
}


// DRONES
//////////////////////////////////////////////////////////////////////////////



// Spawn a drone AI who can be animated
#using_animtree ("generic_human");
spawn_fake_guy_to_anim( struct_name, side, animname, name, assign_default_weapon )
{
	org = getstruct( struct_name, "targetname" );
	if( !isdefined( org ) )
	{
		org = getnode( struct_name, "targetname" );
	}

	guy = spawn_fake_guy( org.origin, org.angles, side, animname, name, assign_default_weapon );

	guy makeFakeAI();			// allow it to be animated
	guy setcandamage( true );	// can be killed
	guy.health = 5;				// can be killed easily

	return guy;
}

spawn_fake_guy_to_anim_2( spawn_origin, spawn_angle, side, animname, name, assign_default_weapon )
{
	guy = spawn_fake_guy( spawn_origin, spawn_angle, side, animname, name, assign_default_weapon );

	guy makeFakeAI();			// allow it to be animated
	guy setcandamage( true );	// can be killed
	guy.health = 5;				// can be killed easily

	return guy;
}

// Spawn a drone model. It cannot be animated yet.
spawn_fake_guy( startpoint, startangles, side, animname, name, assign_default_weapon )
{
	guy = spawn( "script_model", startpoint );
	guy.angles = startangles;
	
	if( side == "allies" )
	{
		guy character\char_rus_r_rifle::main();
		guy.team = "allies";
	}
	else
	{
		guy character\char_ger_wrmcht_k98::main();		
		guy.team = "axis";
	}
	
	guy UseAnimTree( #animtree );
	guy.animname = animname;
	guy.targetname = name;

	if( isdefined( assign_default_weapon ) && assign_default_weapon == 1 )
	{
		if( side == "allies" )
		{
			guy maps\_drones::drone_allies_assignWeapon_russian();
		}
		else
		{
			self see1_drone_axis_assignWeapon_german();
		}
	}
	
	return guy;
}

// Customize drone running animations
custom_drone_spawn_allies()
{
	self character\char_rus_r_rifle::main(); 
	self assign_random_run_anim();
}

custom_drone_spawn_axis()
{
	self character\char_ger_wrmcht_k98::main(); 
	self assign_random_run_anim();
}

see1_drone_axis_assignWeapon_german()
{	
	array = [];
	array[0] = "gewehr43";

	self.weapon = array[0];

	weaponModel = GetWeaponModel( self.weapon ); 
	self Attach( weaponModel, "tag_weapon_right" ); 
	self.bulletsInClip = WeaponClipSize( self.weapon ); 
}

assign_random_run_anim()
{
	if( is_german_build() )
	{
		self.drone_run_cycle = %run_n_gun_B;
		return;
	}

	index = randomint( 100 );
	if( index < 30 )
	{
		self.drone_run_cycle = %unarmed_run_russian;	// 30% standard run
	}
	else if( index < 60 )
	{
		self.drone_run_cycle = %run_n_gun_B;	// 30% run and gun
	}
	else if( index < 70 )
	{
		self.drone_run_cycle = %run_lowready_L;	// 10% 
	}
	else if( index < 80 )
	{
		self.drone_run_cycle = %run_lowready_R;	// 10% 
	}
	else if( index < 90 )
	{
		self.drone_run_cycle = %run_lowready_B;	// 10% 
	}
	else
	{
		self.drone_run_cycle = %unarmed_run_russian;	// 10% 
	}
}


// DEBUG ONLY
//////////////////////////////////////////////////////////////////////////////


debug_ai_counter()
{
	setup_hud();

	while( 1 )
	{
		axis_ai = GetAiArray( "axis" );
		allies_ai = GetAiArray( "allies" );
		total = allies_ai.size + axis_ai.size;
		set_hud_text( level.ai_info, "total ais: " + total );
	
		wait 1.5;
	}
}

setup_hud()
{
	level.ai_info = NewHudElem();
	level.ai_info.alignX = "right";
	level.ai_info.x = 100;
	level.ai_info.y = 277;
}

set_hud_text( hud_elem, text )
{
	hud_elem setText( text );
}

// MATH
//////////////////////////////////////////////////////////////////////////////

// returns:
// "up" if self_pos is close enough to the enxplosion - defined by up_distance
// "forward", "back", "left", "right" for the 4 quadrants, showing which direction the
//   animation should play towards
// Up_distance cannot be 0 or negative
get_explosion_death_dir( self_pos, self_angle, explosion_pos, up_distance )
{
	if( Distance2D( self_pos, explosion_pos ) < up_distance )
	{
		return "up";
	}

	// we need the angle between the self forward angle and the angle to the explosion
	// However to get this we need to draw a right triangle, find 2 sides, then ATan
	p1 = self_pos - vectornormalize( AnglesToForward( self_angle ) ) * 10000;
	p2 = self_pos + vectornormalize( AnglesToForward( self_angle ) ) * 10000;
	p_intersect = PointOnSegmentNearestToPoint( p1, p2, explosion_pos );

	side_away_dist = Distance2D( p_intersect, explosion_pos );
	side_close_dist = Distance2D( p_intersect, self_pos );

	if( side_close_dist != 0 )
	{
		angle = ATan( side_away_dist / side_close_dist );
	
		// depending on if the explosion is in front or behind self, modify the angle
		dot_product = vectordot( anglestoforward( self_angle ), vectornormalize( explosion_pos - self_pos ) );
		if( dot_product < 0 )
		{
			angle = 180 - angle;
		}

		if( angle < 45 )
		{
			return "forward";
		}
		else if( angle > 135 )
		{
			return "back";
		}
	}

	// now we need to know if this is to the left or right
	// We can simply creat another point either to the left or right side of self (I choose right)
	// and see if it's closer to the explosion. The new point must be closer than up_distance, or
	// the result can be wrong. 
	self_right_angle = vectornormalize( AnglesToRight( self_angle ) );
	right_point = self_pos + self_right_angle * ( up_distance * 0.5 );
	
	if( Distance2D( right_point, explosion_pos ) < Distance2D( self_pos, explosion_pos ) )
	{
		return "right";
	}
	else
	{
		return "left";
	}
}

get_explosion_death_dir_test()
{
	self_pos = ( 0, 0, 0 );
	self_angle = ( 0, -90, 0 );  // up

	start_pos = ( -100, 100, 0 );

	for( i = -100; i < 100; i+=20 )
	{
		wait( 0.5 );
		//iprintlnbold( get_explosion_death_dir( self_pos, self_angle, ( i, 100, 0 ), 10 ) );
	}
	for( i = 100; i > -100; i-=20 )
	{
		wait( 0.5 );
		//iprintlnbold( get_explosion_death_dir( self_pos, self_angle, ( 100, i, 0 ), 10 ) );
	}
	for( i = 100; i > -100; i-=20 )
	{
		wait( 0.5 );
		//iprintlnbold( get_explosion_death_dir( self_pos, self_angle, ( i, -100, 0 ), 10 ) );
	}
	for( i = -100; i < 100; i+=20 )
	{
		wait( 0.5 );
		//iprintlnbold( get_explosion_death_dir( self_pos, self_angle, ( -100, i, 0 ), 10 ) );
	}
}


play_burst_fake_fire( bullets, start_pos, end_pos )
{
	angles_to_target = vectortoangles( end_pos - start_pos );

	for (i = 0; i < bullets; i++)
	{
		// play fx with tracers
		playfx (level._effect["distant_muzzleflash"], start_pos, angles_to_target );
			
		bullettracer( start_pos, end_pos + ( randomintrange( 1, 300 ), randomintrange( 1, 300 ), randomintrange( 1, 40 ) ) );

		wait( randomfloatrange( 0.2, 0.4 ) );
	}
}

spawn_guy( spawner )
{
	spawnedGuy = spawner StalingradSpawn();
	spawn_failed (spawnedGuy);
	return spawnedGuy;
}

ai_auto_death( time )
{
	self endon( "death" );

	wait( randomfloat( time ) );

	//players = get_players();
	self dodamage( self.health + 100, ( 0, 0, 0 ) );
}


fire_shreck( spawn_struct, target_struct, time )
{
	shreck = spawn("script_model", spawn_struct.origin);
	shreck.angles = spawn_struct.angles;
	shreck setmodel("weapon_ger_panzershreck_rocket");
	shreck playsound("weap_pnzr_fire");
	
	dest = target_struct.origin;
	
	shreck moveTo( dest, time );
	playFxOnTag( level._effect["rocket_trail"], shreck, "tag_fx" );
	shreck playloopsound("weap_pnzr_fire_rocket");
	wait time;
	
	shreck hide();
	
	playfx( level._effect["shreck_explode"], shreck.origin );
	
	shreck stoploopsound();
	playSoundAtPosition("rpg_impact_boom", shreck.origin);
	radiusdamage( shreck.origin, 180, 300, 35 );
	earthquake( 0.5, 1.5, shreck.origin, 512 );
	
	wait( 4 );
	shreck delete();
}

fire_shreck_at_pos( spawn_struct, target_pos, time )
{
	shreck = spawn("script_model", spawn_struct.origin);
	shreck.angles = spawn_struct.angles;
	shreck setmodel("weapon_ger_panzershreck_rocket");
	
	dest = target_pos;
	
	shreck moveTo( dest, time );
	shreck playsound("weap_pnzr_fire");
	playFxOnTag( level._effect["rocket_trail"], shreck, "tag_fx" );
	shreck playloopsound("rpg_rocket");
	wait time;
	
	shreck hide();
	
	playfx( level._effect["shreck_explode"], shreck.origin );
	
	shreck stoploopsound();
	playSoundAtPosition("rpg_impact_boom", shreck.origin);
	radiusdamage( shreck.origin, 180, 300, 35 );
	earthquake( 0.5, 1.5, shreck.origin, 512 );
	
	wait( 4 );
	shreck delete();
}

periodic_trigger( trigger, end_msg )
{
	level endon( end_msg );
	while( 1 )
	{
		trigger notify( "trigger" );
		wait( 4 );
	}
}

triggered_explosions( target_name )
{
	triggers = getentarray( target_name, "targetname" );
	for( i = 0; i < triggers.size; i++ )
	{
		level thread triggered_explosions_single( triggers[i] );
	}
}

triggered_explosions_single( trigger )
{
	trigger waittill( "trigger" );
	
	target_name = trigger.target;
	target_struct = getstruct( target_name, "targetname" );
	
	playfx( level._effect["dirt_blow_up"], target_struct.origin );
}

print3d_on_ent( msg )
{
	self endon( "death" );

	while( 1 )
	{
		print3d( self.origin + ( 0, 0, 72 ), msg );
		wait( 0.05 );
	}
}

delete_ent_array( value, key )
{
	ents = getentarray( value, key );
	for( i = 0; i < ents.size; i++ )
	{
		ents[i] delete();
	}
	wait( 0.05 );
}

any_player_touching( trigger )
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( players[i] istouching( trigger ) )
		{
			return true;
		}
	}
	return false;
}

any_player_within_distance( origin_vec, dist )
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( distance( players[i].origin, origin_vec ) < dist )
		{
			return true;
		}
	}
	return false;
}

dist_to_closest_player( origin_vec )
{
	closest = 999999;
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		if( distance( players[i].origin, origin_vec ) < closest )
		{
			closest = distance( players[i].origin, origin_vec );
		}
	}
	return closest;
}

lower_friendlies_accuracy( value, restore_msg )
{
	allies_ai = GetAiArray( "allies" );
	old_accuracy = [];

	for( i = 0; i < allies_ai.size; i++ )
	{
		old_accuracy[i] = allies_ai[i].accuracy;
		allies_ai[i].accuracy = value;
	}

	level waittill( restore_msg );

	for( i = 0; i < allies_ai.size; i++ )
	{
		if( isalive( allies_ai[i] ) )
		{
			allies_ai[i].accuracy = old_accuracy[i];
		}
	}
}

setup_dead_bodies( struct_name, delete_msg )
{
	bodies = [];
	structs = getstructarray( struct_name, "targetname" );
	
	for( i = 0; i < structs.size; i++ )
	{
		bodies[i] = spawn( "script_model", structs[i].origin );
		bodies[i].angles = structs[i].angles;
		bodies[i] character\char_ger_wrmcht_k98::main();	
		bodies[i] makeFakeAI();			
		bodies[i] startragdoll();	

		wait( 0.1 );
	}

	level waittill( delete_msg );

	for( i = 0; i < bodies.size; i++ )
	{
		if( isdefined( bodies[i] ) )
		{
			bodies[i] delete();
		}
	}
}

scripted_molotov_throw( node_noteworthy, end_msg )
{
	self endon( "death" );
	
	if( isdefined( end_msg ) )
	{
		level endon( end_msg );
	}
	self disable_ai_color();
	self thread delete_molotov_immediately( end_msg );

	node = getnode( node_noteworthy, "script_noteworthy" );
	molotov_target = getstruct( node_noteworthy, "targetname" );

	node anim_reach_solo( self, "molotov_generic_toss" );
	node thread anim_single_solo( self, "molotov_generic_toss" );
	
	self waittill( "attach_molotov" );
	molotov = spawn( "script_model", self gettagorigin( "tag_weapon_left" ) );
	level thread delete_molotov_later( molotov );
	molotov setmodel( "weapon_rus_molotov_grenade" );
	molotov linkto( self, "tag_weapon_left" );
	self.fake_molotov = molotov;
	self.fake_molotov_tossed = false;
	playfxontag( level._effect["molotov_trail_fire"], molotov, "tag_flash" );

	self waittill( "detach_molotov" );
	self thread let_go_molotov( molotov, molotov_target );

	self enable_ai_color();
}

delete_molotov_immediately( end_msg )
{
	level waittill( end_msg );

	if( isdefined( self.fake_molotov ) )
	{
		// delete it if it has not been tossed yet
		if( isdefined( self.fake_molotov_tossed ) && self.fake_molotov_tossed == false )
		{
			self.fake_molotov delete();
		}
	}
}

delete_molotov_later( molotov )
{
	wait( 7 );

	if( isdefined( molotov ) )
	{
		molotov delete();
	}
}

see1_molotov_attach( guy )
{
	guy notify( "attach_molotov" );
}

see1_molotov_detach( guy )
{
	guy notify( "detach_molotov" );
}

let_go_molotov( molotov, molotov_target )
{
	molotov unlink();
	forward = VectorNormalize( ( molotov_target.origin + ( 0, 0, 300 ) ) - molotov.origin );
	velocities = forward * 12000;
	molotov physicslaunch( ( molotov.origin ), velocities );

	self.fake_molotov_tossed = true;

	wait( 1.2 );
	playfx( level._effect["molotov_explosion"], molotov_target.origin );

	radiusdamage( molotov_target.origin, 400, 100, 10 );

	if( isdefined( molotov ) )
	{
		playsoundatposition("weap_molotov_impact",molotov.origin);
		molotov delete();
	}

	wait( 0.5 );
	playfx( level._effect["molotov_burn_trail_large"], molotov_target.origin + ( 0, 0, -15 ) );
	playfx( level._effect["molotov_burn_trail_small"], molotov_target.origin + ( 35, 0, -15 )  );
	playfx( level._effect["molotov_burn_trail_small"], molotov_target.origin + ( -40, 0, -15 ) );
	playfx( level._effect["molotov_burn_trail_small"], molotov_target.origin + ( 0, 25, -15 ) );
	playfx( level._effect["molotov_burn_trail_small"], molotov_target.origin + ( 0, -43, -15 ) );

	anima[0] = %ai_flame_death_a;
	anima[1] = %ai_flame_death_b;
	anima[2] = %ai_flame_death_c;
	anima[3] = %ai_flame_death_d;

	enemies = getaiarray( "axis" );
	for( i = 0; i < enemies.size; i++ )
	{
		if( distance( enemies[i].origin, molotov_target.origin ) < 120 )
		{
			if( is_german_build() == false )
			{
				enemies[i].deathanim = anima[randomint(anima.size)];	
				enemies[i] thread animscripts\death::flame_death_fx();
			}
			enemies[i] doDamage( enemies[i].health + 25, ( 0, 0, 0 ) );
		}
	}
}

scripted_molotov_throw_triggered( trigger_value, trigger_key, node_noteworthy, stop_msg )
{
	self endon( "death" );
	if( isdefined( stop_msg ) )
	{
		level endon( stop_msg );
	}
	trigger = getent( trigger_value, trigger_key );
	trigger waittill( "trigger" );
	self thread scripted_molotov_throw( node_noteworthy, stop_msg );
}

print_text_on_screen( text )
{
	display_time = 5000;
	fade_time = 700;

	text_print = createFontString( "objective", 1.5 );
	text_print.glowColor = ( 0.7, 0.7, 0.3 );
	text_print.glowAlpha = 1;
	text_print.color = ( 1, 1, 1 );
	text_print.alpha = 1;
	text_print.x = 0;
	text_print.alignx = "center";
	text_print.aligny = "middle";
	text_print.horzAlign = "center";
	text_print.vertAlign = "middle";
	text_print.foreground = true;

	text_print.y = -60;
	text_print SetPulseFX( 60, display_time, fade_time );

	text_print.label = text;

	wait display_time + fade_time / 1000;

	text_print Destroy();
}


players_speed_set( speed, time )
{

	players = get_players();
	for( i  = 0; i < players.size; i++ )
	{
		players[i] SetMoveSpeedScale( speed ); 
	}

	level.current_player_speed = speed;

}

players_speed_set_gradual( speed, time )
{
	intervals = time * 5; // 5 times a second

	interval_change = ( speed - level.current_player_speed ) / intervals;

	players = get_players();
	for( j = 0; j < intervals; j++ )
	{
		for( i  = 0; i < players.size; i++ )
		{
			if( isdefined( players[i] ) )
			{
				players[i] SetMoveSpeedScale( level.current_player_speed + interval_change ); 
			}
		}
		level.current_player_speed += interval_change;
		wait( 0.2 );
	}

	players = get_players();
	for( i  = 0; i < players.size; i++ )
	{
		players[i] SetMoveSpeedScale( speed ); 
	}
}

playsound_generic_facial( sound, lookTarget )
{
      self endon( "death" );
      //notifyString = "sound_done";

      //self thread maps\_anim::anim_facialFiller( notifyString, lookTarget );

      //self animscripts\face::SaySpecificDialogue( undefined, sound, 1.0, notifyString );

      //self waittill( notifyString );
}

// Sets up the AI for force gibbing
set_random_gib()
{
	refs = []; 
	refs[refs.size] = "right_arm"; 
	refs[refs.size] = "left_arm"; 
	refs[refs.size] = "right_leg"; 
	refs[refs.size] = "left_leg"; 
	refs[refs.size] = "no_legs"; 
	refs[refs.size] = "guts"; 

	self.a.gib_ref = get_random( refs ); 
}

get_random( array )
{
	return array[RandomInt( array.size )]; 
}
