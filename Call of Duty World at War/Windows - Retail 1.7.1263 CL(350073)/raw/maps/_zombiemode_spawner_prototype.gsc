#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

#using_animtree( "generic_human" ); 
init()
{
	level.zombie_move_speed = 1; 
	level.zombie_health = 150; 

	zombies = getEntArray( "zombie_spawner", "script_noteworthy" ); 
	later_rounds = getentarray("later_round_spawners", "script_noteworthy" );
	
	zombies = array_combine( zombies, later_rounds );

	for( i = 0; i < zombies.size; i++ )
	{
		if( is_spawner_targeted_by_blocker( zombies[i] ) )
		{
			zombies[i].locked_spawner = true;
		}
	}
	
	array_thread( zombies, ::add_spawn_function, ::zombie_spawn_init );
}

is_spawner_targeted_by_blocker( ent )
{
	if( IsDefined( ent.targetname ) )
	{
		targeters = GetEntArray( ent.targetname, "target" );

		for( i = 0; i < targeters.size; i++ )
		{
			if( targeters[i].targetname == "zombie_door" || targeters[i].targetname == "zombie_debris" )
			{
				return true;
			}

			result = is_spawner_targeted_by_blocker( targeters[i] );
			if( result )
			{
				return true;
			}
		}
	}

	return false;
}

// set up zombie walk cycles
zombie_spawn_init()
{
	self.targetname = "zombie";
	self.script_noteworthy = undefined;
	self.animname = "zombie"; 		
	self.ignoreall = true; 
	self.allowdeath = true; 			// allows death during animscripted calls
	self.gib_override = true; 		// needed to make sure this guy does gibs
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	self.has_legs = true; 			// Sumeet - This tells the zombie that he is allowed to stand anymore or not, gibbing can take 
									// out both legs and then the only allowed stance should be prone.

	self.gibbed = false; 
	self.head_gibbed = false;
	
	// might need this so co-op zombie players cant block zombie pathing
	self PushPlayer( true ); 
//	self.meleeRange = 128; 
//	self.meleeRangeSq = anim.meleeRange * anim.meleeRange; 
	
	animscripts\shared::placeWeaponOn( self.primaryweapon, "none" ); 
	
	// This isn't working, might need an "empty" weapon
	//self animscripts\shared::placeWeaponOn( self.weapon, "none" ); 

	self allowedStances( "stand" ); 
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;

	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;

	self.badplaceawareness = 0;
	self.chatInitialized = false; 

	self disable_pain(); 

	self.maxhealth = level.zombie_health; 
	self.health = level.zombie_health; 
	self.dropweapon = false; 
	level thread zombie_death_event( self ); 

// We need more script/code to get this to work properly
//	self add_to_spectate_list();
	self random_tan(); 
	self set_zombie_run_cycle(); 
	self thread zombie_think(); 
	self thread zombie_gib_on_damage(); 
//	self thread zombie_head_gib(); 
	self zombie_eye_glow(); 
	self.deathFunction = ::zombie_death_animscript;
	self.flame_damage_time = 0;

	self zombie_history( "zombie_spawn_init -> Spawned = " + self.origin );

	self thread zombie_testing();

	self notify( "zombie_init_done" );
}

set_zombie_run_cycle()
{
	self set_run_speed(); 
		
	walkcycle = randomint( 4 ); 

	if( self.zombie_move_speed == "walk" )
	{
		if( walkcycle == 0 )
		{
			self.deathanim = %ch_dazed_a_death; 
			self set_run_anim( "walk1" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["walk1"]; 
		}
		else if( walkcycle == 1 )
		{
			self.deathanim = %ch_dazed_b_death; 
			self set_run_anim( "walk2" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["walk2"]; 
		}
		else if( walkcycle == 2 )
		{
			self.deathanim = %ch_dazed_c_death; 
			self set_run_anim( "walk3" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["walk3"]; 
		}
		else if( walkcycle == 3 )
		{
			self.deathanim = %ch_dazed_d_death; 
			self set_run_anim( "walk4" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["walk4"]; 
		}			
	}
	
	walkcycle = randomint( 3 ); 
	if( self.zombie_move_speed == "run" )
	{
		if( walkcycle == 0 )
		{
			self.deathanim = %ch_dazed_a_death; 
			self set_run_anim( "run1" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["run1"]; 
		}
		else if( walkcycle == 1 )
		{
			self.deathanim = %ch_dazed_b_death; 
			self set_run_anim( "run2" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["run2"]; 
		}
		else if( walkcycle == 2 )
		{
			self.deathanim = %ch_dazed_c_death; 
			self set_run_anim( "run3" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["run3"]; 
		}		
	}
	
	walkcycle = randomint( 2 ); 
	if( self.zombie_move_speed == "sprint" )
	{
		if( walkcycle == 0 )
		{
			self.deathanim = %ch_dazed_c_death; 
			self set_run_anim( "sprint1" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["sprint1"]; 
		}
		else if( walkcycle == 1 )
		{
			self.deathanim = %ch_dazed_d_death; 
			self set_run_anim( "sprint2" ); 		
			self.run_combatanim = level.scr_anim["zombie"]["sprint2"]; 
		}
	}
}

set_run_speed()
{
	rand = randomintrange( level.zombie_move_speed, level.zombie_move_speed + 35 ); 
	
//	self thread print_run_speed( rand );
	if( rand <= 35 )
	{
		self.zombie_move_speed = "walk"; 
	}
	else if( rand <= 70 )
	{
		self.zombie_move_speed = "run"; 
	}
	else
	{	
		self.zombie_move_speed = "sprint"; 
	}
}

// this is the main zombie think thread that starts when they spawn in
zombie_think()
{
	self endon( "death" ); 

	//node = level.exterior_goals[randomint( level.exterior_goals.size )]; 

	node = undefined;



	desired_nodes = [];
	self.entrance_nodes = [];

	if( IsDefined( self.script_forcegoal ) && self.script_forcegoal )
	{
		desired_origin = get_desired_origin();

		AssertEx( IsDefined( desired_origin ), "Spawner @ " + self.origin + " has a script_forcegoal but did not find a target" );
	
		origin = desired_origin;
			
		node = getclosest( origin, level.exterior_goals ); 	
		self.entrance_nodes[0] = node;

		self zombie_history( "zombie_think -> #1 entrance (script_forcegoal) origin = " + self.entrance_nodes[0].origin );
	}
	else
	{
		origin = self.origin;

		desired_origin = get_desired_origin();
		if( IsDefined( desired_origin ) )
		{
			origin = desired_origin;
		}

		// Get the 3 closest nodes
		nodes = get_array_of_closest( origin, level.exterior_goals, undefined, 3 );

		// Figure out the distances between them, if any of them are greater than 256 units compared to the previous, drop it
		max_dist = 500;
		desired_nodes[0] = nodes[0];
		prev_dist = Distance( self.origin, nodes[0].origin );
		for( i = 1; i < nodes.size; i++ )
		{
			dist = Distance( self.origin, nodes[i].origin );
			if( ( dist - prev_dist ) > max_dist )
			{
				break;
			}

			prev_dist = dist;
			desired_nodes[i] = nodes[i];
		}

		node = desired_nodes[0];
		if( desired_nodes.size > 1 )
		{
			node = desired_nodes[RandomInt(desired_nodes.size)];
		}

		self.entrance_nodes = desired_nodes;

		self zombie_history( "zombie_think -> #1 entrance origin = " + node.origin );

		// Incase the guy does not move from spawn, then go to the closest one instead
		self thread zombie_assure_node();
	}

	AssertEx( IsDefined( node ), "Did not find a node!!! [Should not see this!]" );

	level thread draw_line_ent_to_pos( self, node.origin, "goal" );

	self.first_node = node;

	self thread zombie_goto_entrance( node );
}

get_desired_origin()
{
	if( IsDefined( self.target ) )
	{
		ent = GetEnt( self.target, "targetname" );
		if( !IsDefined( ent ) )
		{
			ent = getstruct( self.target, "targetname" );
		}
	
		if( !IsDefined( ent ) )
		{
			ent = GetNode( self.target, "targetname" );
		}
	
		AssertEx( IsDefined( ent ), "Cannot find the targeted ent/node/struct, \"" + self.target + "\" at " + self.origin );
	
		return ent.origin;
	}

	return undefined;
}

zombie_goto_entrance( node, endon_bad_path )
{
	self endon( "death" );
	level endon( "intermission" );

	if( IsDefined( endon_bad_path ) && endon_bad_path )
	{
		// If we cannot go to the goal, then end...
		// Used from find_flesh
		self endon( "bad_path" );
	}

	self zombie_history( "zombie_goto_entrance -> start goto entrance " + node.origin );

	self.got_to_entrance = false;
	self.goalradius = 128; 
	self SetGoalPos( node.origin );
	self waittill( "goal" ); 
	self.got_to_entrance = true;

	self zombie_history( "zombie_goto_entrance -> reached goto entrance " + node.origin );

	// Guy should get to goal and tear into building until all barrier chunks are gone
	self tear_into_building();

	// here is where they zombie would play the traversal into the building( if it's a window )
	// and begin the player seek logic
	self zombie_setup_attack_properties();
	self thread find_flesh();
}

zombie_assure_node()
{
	self endon( "death" );
	self endon( "goal" );
	level endon( "intermission" );

	start_pos = self.origin;

	for( i = 0; i < self.entrance_nodes.size; i++ )
	{
		if( self zombie_bad_path() )
		{
			self zombie_history( "zombie_assure_node -> assigned assured node = " + self.entrance_nodes[i].origin );

			println( "^1Zombie @ " + self.origin + " did not move for 1 second. Going to next closest node @ " + self.entrance_nodes[i].origin );
			level thread draw_line_ent_to_pos( self, self.entrance_nodes[i].origin, "goal" );
			self.first_node = self.entrance_nodes[i];
			self SetGoalPos( self.entrance_nodes[i].origin );
		}
		else
		{
			return;
		}
	}

	self zombie_history( "zombie_assure_node -> failed to find a good entrance point" );
	assertmsg( "^1Zombie @ " + self.origin + " did not find a good entrance point... Please fix pathing or Entity setup" );

	wait( 3 );
	self DoDamage( self.health + 10, self.origin );
}

zombie_bad_path()
{
	self endon( "death" );
	self endon( "goal" );

	self thread zombie_bad_path_notify();
	self thread zombie_bad_path_timeout();

	self.zombie_bad_path = undefined;
	while( !IsDefined( self.zombie_bad_path ) )
	{
		wait( 0.05 );
	}

	self notify( "stop_zombie_bad_path" );

	return self.zombie_bad_path;
}

zombie_bad_path_notify()
{
	self endon( "death" );
	self endon( "stop_zombie_bad_path" );

	self waittill( "bad_path" );
	self.zombie_bad_path = true;
}

zombie_bad_path_timeout()
{
	self endon( "death" );
	self endon( "stop_zombie_bad_path" );

	wait( 2 );
	self.zombie_bad_path = false;
}

// zombies are trying to get at player contained behind barriers, so the barriers
// need to come down
tear_into_building()
{
	self endon( "death" ); 

	self zombie_history( "tear_into_building -> start" );

	while( 1 )
	{
		if( IsDefined( self.first_node.script_noteworthy ) )
		{
			if( self.first_node.script_noteworthy == "no_blocker" )
			{
				return;
			}
		}

		if( !IsDefined( self.first_node.target ) )
		{
			return;
		}

		if( all_chunks_destroyed( self.first_node.barrier_chunks ) )
		{
			self zombie_history( "tear_into_building -> all chunks destroyed" );
			return;
		}

		// Pick a spot to tear down
		if( !get_attack_spot( self.first_node ) )
		{
			self zombie_history( "tear_into_building -> Could not find an attack spot" );
			wait( 0.5 );
			continue;
		}

		self.goalradius = 4;
		self SetGoalPos( self.attacking_spot, self.first_node.angles );
		self waittill( "orientdone" );
		self zombie_history( "tear_into_building -> Reach position and orientated" );

		// Now tear down boards
		while( 1 )
		{
			chunk = get_closest_non_destroyed_chunk( self.origin, self.first_node.barrier_chunks );
	
			if( !IsDefined( chunk ) )
			{
				for( i = 0; i < self.first_node.attack_spots_taken.size; i++ )
				{
					self.first_node.attack_spots_taken[i] = false;
				}
				return; 
			}

			self zombie_history( "tear_into_building -> animating" );

			tear_anim = get_tear_anim( chunk ); 
			self AnimScripted( "tear_anim", self.origin, self.first_node.angles, tear_anim );
			self zombie_tear_notetracks( "tear_anim", chunk, self.first_node );
		}

		self reset_attack_spot();
	}		
}

reset_attack_spot()
{
	if( IsDefined( self.attacking_node ) )
	{
		node = self.attacking_node;
		index = self.attacking_spot_index;
		node.attack_spots_taken[index] = false;

		self.attacking_node = undefined;
		self.attacking_spot_index = undefined;
	}
}

get_attack_spot( node )
{
	index = get_attack_spot_index( node );
	if( !IsDefined( index ) )
	{
		return false;
	}

	self.attacking_node = node;
	self.attacking_spot_index = index;
	node.attack_spots_taken[index] = true;
	self.attacking_spot = node.attack_spots[index];

	return true;
}

get_attack_spot_index( node )
{
	indexes = [];
	for( i = 0; i < node.attack_spots.size; i++ )
	{
		if( !node.attack_spots_taken[i] )
		{
			indexes[indexes.size] = i;
		}
	}

	if( indexes.size == 0 )
	{
		return undefined;
	}

	return indexes[RandomInt( indexes.size )];
}

zombie_tear_notetracks( msg, chunk, node )
{
	while( 1 )
	{
		self waittill( msg, notetrack );

		if( notetrack == "end" )
		{
			return;
		}

		if( notetrack == "board" )
		{
			if( !chunk.destroyed )
			{
				self.lastchunk_destroy_time = getTime();
	
				PlayFx( level._effect["wood_chunk_destory"], chunk.origin );
				PlayFx( level._effect["wood_chunk_destory"], chunk.origin + ( randomint( 20 ), randomint( 20 ), randomint( 10 ) ) );
				PlayFx( level._effect["wood_chunk_destory"], chunk.origin + ( randomint( 40 ), randomint( 40 ), randomint( 20 ) ) );
	
				level thread maps\_zombiemode_blockers::remove_chunk( chunk, node );
			}
		}
	}
}

get_tear_anim( chunk )
{
	if( self.has_legs )
	{
		z_dist = chunk.origin[2] - self.origin[2];
		if( z_dist > 70 )
		{
			tear_anim = %ai_zombie_door_tear_high;
		}
		else if( z_dist < 40 )
		{
			tear_anim = %ai_zombie_door_tear_low;
		}
		else
		{
			anims = [];
			anims[anims.size] = %ai_zombie_door_tear_left;
			anims[anims.size] = %ai_zombie_door_tear_right;
	
			tear_anim = anims[RandomInt( anims.size )];
		}
	}
	else
	{
		anims = [];
		anims[anims.size] = %ai_zombie_attack_crawl;
		anims[anims.size] = %ai_zombie_attack_crawl_lunge;

		tear_anim = anims[RandomInt( anims.size )];
	}

	return tear_anim; 
}

zombie_head_gib( attacker )
{
	if( IsDefined( self.head_gibbed ) && self.head_gibbed )
	{
		return;
	}

	self.head_gibbed = true;
	self zombie_eye_glow_stop();

	size = self GetAttachSize(); 
	for( i = 0; i < size; i++ )
	{
		model = self GetAttachModelName( i ); 
		if( IsSubStr( model, "head" ) )
		{
			// SRS 9/2/2008: wet em up
			self thread headshot_blood_fx();
			self play_sound_on_ent( "zombie_head_gib" );
			
			self Detach( model, "", true ); 
			self Attach( "char_ger_honorgd_zomb_behead", "", true ); 
			break; 
		}
	}

	self thread damage_over_time( self.health * 0.2, 1, attacker );
}

damage_over_time( dmg, delay, attacker )
{
	self endon( "death" );

	if( !IsAlive( self ) )
	{
		return;
	}

	if( !IsPlayer( attacker ) )
	{
		attacker = undefined;
	}

	while( 1 )
	{
		wait( delay );

		if( IsDefined( attacker ) )
		{
			self DoDamage( dmg, self.origin, attacker );
		}
		else
		{
			self DoDamage( dmg, self.origin );
		}
	}
}

// SRS 9/2/2008: reordered checks, added ability to gib heads with airburst grenades
head_should_gib( attacker, type, point )
{
	if ( is_german_build() )
	{
		return false;
	}

	if( self.head_gibbed )
	{
		return false;
	}

	// check if the attacker was a player
	if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
	{
		return false; 
	}

	// check the enemy's health
	low_health_percent = ( self.health / self.maxhealth ) * 100; 
	if( low_health_percent > 10 )
	{
		return false; 
	}

	weapon = attacker GetCurrentWeapon(); 

	// SRS 9/2/2008: check for damage type
	//  - most SMGs use pistol bullets
	//  - projectiles = rockets, raygun
	if( type != "MOD_RIFLE_BULLET" && type != "MOD_PISTOL_BULLET" )
	{
		// maybe it's ok, let's see if it's a grenade
		if( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" )
		{
			if( Distance( point, self GetTagOrigin( "j_head" ) ) > 55 )
			{
				return false;
			}
			else
			{
				// the grenade airburst close to the head so return true
				return true;
			}
		}
		else if( type == "MOD_PROJECTILE" )
		{
			if( Distance( point, self GetTagOrigin( "j_head" ) ) > 10 )
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		// shottys don't give a testable damage type but should still gib heads
		else if( WeaponClass( weapon ) != "spread" )
		{
			return false; 
		}
	}

	// check location now that we've checked for grenade damage (which reports "none" as a location)
	if( !self animscripts\utility::damageLocationIsAny( "head", "helmet", "neck" ) )
	{
		return false; 
	}

	// check weapon - don't want "none", pistol, or flamethrower
	if( weapon == "none"  || WeaponClass( weapon ) == "pistol" || WeaponIsGasWeapon( self.weapon ) )
	{
		return false; 
	}

	return true; 
}

// does blood fx for fun and to mask head gib swaps
headshot_blood_fx()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	if( !is_mature() )
	{
		return;
	}

	fxTag = "j_neck";
	fxOrigin = self GetTagOrigin( fxTag );
	upVec = AnglesToUp( self GetTagAngles( fxTag ) );
	forwardVec = AnglesToForward( self GetTagAngles( fxTag ) );
	
	// main head pop fx
	PlayFX( level._effect["headshot"], fxOrigin, forwardVec, upVec );
	PlayFX( level._effect["headshot_nochunks"], fxOrigin, forwardVec, upVec );
	
	wait( 0.3 );
	
	if( IsDefined( self ) )
	{
		PlayFxOnTag( level._effect["bloodspurt"], self, fxTag );
	}
}

// gib limbs if enough firepower occurs
zombie_gib_on_damage()
{
//	self endon( "death" ); 

	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type ); 

		if( !IsDefined( self ) )
		{
			return;
		}

		if( !self zombie_should_gib( amount, attacker, type ) )
		{
			continue; 
		}

		if( self head_should_gib( attacker, type, point ) && type != "MOD_BURNED" )
		{
			self zombie_head_gib( attacker );
			continue;
		}

		if( !self.gibbed )
		{
			// The head_should_gib() above checks for this, so we should not randomly gib if shot in the head
			if( self animscripts\utility::damageLocationIsAny( "head", "helmet", "neck" ) )
			{
				continue;
			}

			refs = []; 
			switch( self.damageLocation )
			{
				case "torso_upper":
				case "torso_lower":
					// HACK the torso that gets swapped for guts also removes the left arm
					//  so we need to sometimes do another ref
					refs[refs.size] = "guts"; 
					refs[refs.size] = "right_arm";
					break; 
	
				case "right_arm_upper":
				case "right_arm_lower":
				case "right_hand":
					//if( IsDefined( self.left_arm_gibbed ) )
					//	refs[refs.size] = "no_arms"; 
					//else
					refs[refs.size] = "right_arm"; 
	
					//self.right_arm_gibbed = true; 
					break; 
	
				case "left_arm_upper":
				case "left_arm_lower":
				case "left_hand":
					//if( IsDefined( self.right_arm_gibbed ) )
					//	refs[refs.size] = "no_arms"; 
					//else
					refs[refs.size] = "left_arm"; 
	
					//self.left_arm_gibbed = true; 
					break; 
	
				case "right_leg_upper":
				case "right_leg_lower":
				case "right_foot":
					if( self.health <= 0 )
					{
						// Addition "right_leg" refs so that the no_legs happens less and is more rare
						refs[refs.size] = "right_leg";
						refs[refs.size] = "right_leg";
						refs[refs.size] = "right_leg";
						refs[refs.size] = "no_legs"; 
					}
					break; 
	
				case "left_leg_upper":
				case "left_leg_lower":
				case "left_foot":
					if( self.health <= 0 )
					{
						// Addition "left_leg" refs so that the no_legs happens less and is more rare
						refs[refs.size] = "left_leg";
						refs[refs.size] = "left_leg";
						refs[refs.size] = "left_leg";
						refs[refs.size] = "no_legs";
					}
					break; 
			default:
				
				if( self.damageLocation == "none" )
				{
					// SRS 9/7/2008: might be a nade or a projectile
					if( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE" )
					{
						// ... in which case we have to derive the ref ourselves
						refs = self derive_damage_refs( point );
						break;
					}
				}
				else
				{
					refs[refs.size] = "guts";
					refs[refs.size] = "right_arm"; 
					refs[refs.size] = "left_arm"; 
					refs[refs.size] = "right_leg"; 
					refs[refs.size] = "left_leg"; 
					refs[refs.size] = "no_legs"; 
					break; 
				}
			}

			if( refs.size )
			{
				self.a.gib_ref = animscripts\death::get_random( refs ); 
			
				// Don't stand if a leg is gone
				if( ( self.a.gib_ref == "no_legs" || self.a.gib_ref == "right_leg" || self.a.gib_ref == "left_leg" ) && self.health > 0 )
				{
					self.has_legs = false; 
					self AllowedStances( "crouch" ); 
										
					which_anim = RandomInt( 3 ); 
					
					if( which_anim == 0 ) 
					{
						self.deathanim = %ai_zombie_crawl_death_v1;
						self set_run_anim( "death3" );
						self.run_combatanim = level.scr_anim["zombie"]["crawl1"];
						self.crouchRunAnim = level.scr_anim["zombie"]["crawl1"];
						self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl1"];
					}
					else if( which_anim == 1 ) 
					{
						self.deathanim = %ai_zombie_crawl_death_v2;
						self set_run_anim( "death4" );
						self.run_combatanim = level.scr_anim["zombie"]["crawl2"];
						self.crouchRunAnim = level.scr_anim["zombie"]["crawl2"];
						self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl2"];
					}
					else if( which_anim == 2 ) 
					{
						self.deathanim = %ai_zombie_crawl_death_v2;
						self set_run_anim( "death4" );
						self.run_combatanim = level.scr_anim["zombie"]["crawl3"];
						self.crouchRunAnim = level.scr_anim["zombie"]["crawl3"];
						self.crouchrun_combatanim = level.scr_anim["zombie"]["crawl3"];
					}
					
				}
			}

			if( self.health > 0 )
			{
				// force gibbing if the zombie is still alive
				self thread animscripts\death::do_gib();
			}
		}
	}
}

zombie_should_gib( amount, attacker, type )
{
	if( !IsDefined( type ) )
	{
		return false; 
	}

	switch( type )
	{
		case "MOD_UNKNOWN":
		case "MOD_CRUSH": 
		case "MOD_TELEFRAG":
		case "MOD_FALLING": 
		case "MOD_SUICIDE": 
		case "MOD_TRIGGER_HURT":
		case "MOD_BURNED":
		case "MOD_MELEE":		
			return false; 
	}

	if( type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET" )
	{
		if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
		{
			return false; 
		}

		weapon = attacker GetCurrentWeapon(); 

		if( weapon == "none" )
		{
			return false; 
		}

		if( WeaponClass( weapon ) == "pistol" )
		{
			return false; 
		}

		if( WeaponIsGasWeapon( self.weapon ) )
		{
			return false; 
		}
	}

//	println( "**DEBUG amount = ", amount );
//	println( "**DEBUG self.head_gibbed = ", self.head_gibbed );
//	println( "**DEBUG self.health = ", self.health );

	prev_health = amount + self.health;
	if( prev_health <= 0 )
	{
		prev_health = 1;
	}

	damage_percent = ( amount / prev_health ) * 100; 

	if( damage_percent < 10 /*|| damage_percent >= 100*/ )
	{
		return false; 
	}

	return true; 
}

// SRS 9/7/2008: need to derive damage location for types that return location of "none"
derive_damage_refs( point )
{
	if( !IsDefined( level.gib_tags ) )
	{
		init_gib_tags();
	}
	
	closestTag = undefined;
	
	for( i = 0; i < level.gib_tags.size; i++ )
	{
		if( !IsDefined( closestTag ) )
		{
			closestTag = level.gib_tags[i];
		}
		else
		{
			if( DistanceSquared( point, self GetTagOrigin( level.gib_tags[i] ) ) < DistanceSquared( point, self GetTagOrigin( closestTag ) ) )
			{
				closestTag = level.gib_tags[i];
			}
		}
	}
	
	refs = [];
	
	// figure out the refs based on the tag returned
	if( closestTag == "J_SpineLower" || closestTag == "J_SpineUpper" || closestTag == "J_Spine4" )
	{
		// HACK the torso that gets swapped for guts also removes the left arm
		//  so we need to sometimes do another ref
		refs[refs.size] = "guts";
		refs[refs.size] = "right_arm";
	}
	else if( closestTag == "J_Shoulder_LE" || closestTag == "J_Elbow_LE" || closestTag == "J_Wrist_LE" )
	{
		refs[refs.size] = "left_arm";
	}
	else if( closestTag == "J_Shoulder_RI" || closestTag == "J_Elbow_RI" || closestTag == "J_Wrist_RI" )
	{
		refs[refs.size] = "right_arm";
	}
	else if( closestTag == "J_Hip_LE" || closestTag == "J_Knee_LE" || closestTag == "J_Ankle_LE" )
	{
		refs[refs.size] = "left_leg";
		refs[refs.size] = "no_legs";
	}
	else if( closestTag == "J_Hip_RI" || closestTag == "J_Knee_RI" || closestTag == "J_Ankle_RI" )
	{
		refs[refs.size] = "right_leg";
		refs[refs.size] = "no_legs";
	}
	
	ASSERTEX( array_validate( refs ), "get_closest_damage_refs(): couldn't derive refs from closestTag " + closestTag );
	
	return refs;
}

init_gib_tags()
{
	tags = [];
					
	// "guts", "right_arm", "left_arm", "right_leg", "left_leg", "no_legs"
	
	// "guts"
	tags[tags.size] = "J_SpineLower";
	tags[tags.size] = "J_SpineUpper";
	tags[tags.size] = "J_Spine4";
	
	// "left_arm"
	tags[tags.size] = "J_Shoulder_LE";
	tags[tags.size] = "J_Elbow_LE";
	tags[tags.size] = "J_Wrist_LE";
	
	// "right_arm"
	tags[tags.size] = "J_Shoulder_RI";
	tags[tags.size] = "J_Elbow_RI";
	tags[tags.size] = "J_Wrist_RI";
	
	// "left_leg"/"no_legs"
	tags[tags.size] = "J_Hip_LE";
	tags[tags.size] = "J_Knee_LE";
	tags[tags.size] = "J_Ankle_LE";
	
	// "right_leg"/"no_legs"
	tags[tags.size] = "J_Hip_RI";
	tags[tags.size] = "J_Knee_RI";
	tags[tags.size] = "J_Ankle_RI";
	
	level.gib_tags = tags;
}

zombie_death_points( origin, mod, hit_location, player )
{
	level thread maps\_zombiemode_powerups::powerup_drop( origin );

	if( !IsDefined( player ) || !IsPlayer( player ) )
	{
		return; 
	}

	player maps\_zombiemode_score::player_add_points( "death", mod, hit_location ); 
}

// Called from animscripts\death.gsc
zombie_death_animscript()
{
	self reset_attack_spot();

	// If no_legs, then use the AI no-legs death
	if( self.has_legs && IsDefined( self.a.gib_ref ) && self.a.gib_ref == "no_legs" )
	{
		self.deathanim = %ai_gib_bothlegs_gib;
	}

	self.grenadeAmmo = 0;

	// Give attacker points
	level zombie_death_points( self.origin, self.damagemod, self.damagelocation, self.attacker );

	if( self.damagemod == "MOD_BURNED" )
	{
		self thread animscripts\death::flame_death_fx();
	}

	return false;
}

damage_on_fire( player )
{
	self endon ("death");
	self endon ("stop_flame_damage");
	wait( 2 );
	
	while( isdefined( self.is_on_fire) && self.is_on_fire )
	{
		if( level.round_number < 6 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.2, 0.3 ); // 20% - 30%
		}
		else if( level.round_number < 9 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.1, 0.2 ); // 10% - 20%
		}
		else if( level.round_number < 11 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.8, 0.16 ); // 6% - 14%
		}
		else
		{
			dmg = level.zombie_health * RandomFloatRange( 0.06, 0.14 ); // 5% - 10%
		}

		if ( Isdefined( player ) && Isalive( player ) )
		{
			self DoDamage( dmg, self.origin, player );
		}
		else
		{
			self DoDamage( dmg, self.origin, level );
		}
		
		wait( randomfloatrange( 2.0, 5.0 ) );
	}
}

zombie_damage( mod, hit_location, hit_origin, player )
{
	if( !IsDefined( player ) )
	{
		return; 
	}

	if( self zombie_flame_damage( mod, player ) )
	{
		if( self zombie_give_flame_damage_points() )
		{
			player maps\_zombiemode_score::player_add_points( "damage", mod, hit_location );
		}
	}
	else
	{
		player maps\_zombiemode_score::player_add_points( "damage", mod, hit_location );
	}

	if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
	{
		if ( isdefined( player ) && isalive( player ) )
		{
			self DoDamage( level.round_number + randomint( 100, 500 ), self.origin, player);
		}
		else
		{
			self DoDamage( level.round_number + randomint( 100, 500 ), self.origin, undefined );
		}
	}
	else if( mod == "MOD_PROJECTILE" || mod == "MOD_EXPLOSIVE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_PROJECTILE_SPLASH")
	{
		if ( isdefined( player ) && isalive( player ) )
		{
			self DoDamage( level.round_number * randomint( 100, 500 ), self.origin, player);
		}
		else
		{
			self DoDamage( level.round_number * randomint( 100, 500 ), self.origin, undefined );
		}
	}
	
	self thread maps\_zombiemode_powerups::check_for_instakill( player );
}

zombie_damage_ads( mod, hit_location, hit_origin, player )
{
	if( !IsDefined( player ) )
	{
		return; 
	}

	if( self zombie_flame_damage( mod, player ) )
	{
		if( self zombie_give_flame_damage_points() )
		{
			player maps\_zombiemode_score::player_add_points( "damage_ads", mod, hit_location );
		}
	}
	else
	{
		player maps\_zombiemode_score::player_add_points( "damage_ads", mod, hit_location );
	}

	self thread maps\_zombiemode_powerups::check_for_instakill( player );
}

zombie_give_flame_damage_points()
{
	if( GetTime() > self.flame_damage_time )
	{
		self.flame_damage_time = GetTime() + level.zombie_vars["zombie_flame_dmg_point_delay"];
		return true;
	}

	return false;
}

zombie_flame_damage( mod, player )
{
	if( mod == "MOD_BURNED" )
	{
		if( !IsDefined( self.is_on_fire ) || ( Isdefined( self.is_on_fire ) && !self.is_on_fire ) )
		{
			self thread damage_on_fire( player );
		}

		do_flame_death = true;
		dist = 100 * 100;
		ai = GetAiArray( "axis" );
		for( i = 0; i < ai.size; i++ )
		{
			if( IsDefined( ai[i].is_on_fire ) && ai[i].is_on_fire )
			{
				if( DistanceSquared( ai[i].origin, self.origin ) < dist )
				{
					do_flame_death = false;
					break;
				}
			}
		}

		if( do_flame_death )
		{
			self thread animscripts\death::flame_death_fx();
		}

		return true;
	}

	return false;
}


zombie_death_event( zombie )
{
	zombie waittill( "death" );
	zombie thread zombie_eye_glow_stop();
}

// this is where zombies go into attack mode, and need different attributes set up
zombie_setup_attack_properties()
{
	self zombie_history( "zombie_setup_attack_properties()" );

	// allows zombie to attack again
	self.ignoreall = false; 

	// push the player out of the way so they use traversals in the house.
	self PushPlayer( true ); 

	self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;

	// turn off transition anims
	self.disableArrivals = true; 
	self.disableExits = true; 
}

// the seeker logic for zombies
find_flesh()
{
	self endon( "death" ); 
	level endon( "intermission" );

	if( level.intermission )
	{
		return;
	}

	self.ignore_player = undefined;

	self zombie_history( "find flesh -> start" );

	self.goalradius = 32;
	while( 1 )
	{
		players = get_players();
		// If playing single player, never ignore the player
		if( players.size == 1 )
		{
			self.ignore_player = undefined;
		}

		player = get_closest_valid_player( self.origin, self.ignore_player ); 
		
		if( !IsDefined( player ) )
		{
			self zombie_history( "find flesh -> can't find player, continue" );
			if( IsDefined( self.ignore_player ) )
			{
				self.ignore_player = undefined;
			}

			wait( 1 ); 
			continue; 
		}

		self.ignore_player = undefined;

		self.favoriteenemy = player;
		self thread zombie_pathing();

		self.zombie_path_timer = GetTime() + ( RandomFloatRange( 1, 3 ) * 1000 );
		while( GetTime() < self.zombie_path_timer )
		{
			wait( 0.1 );
		}

		self zombie_history( "find flesh -> bottom of loop" );

		self notify( "zombie_acquire_enemy" );
	}
}

zombie_testing()
{
/#
	self endon( "death" );

	while( 1 )
	{
		if( GetDvarInt( "zombie_soak_test" ) < 1 )
		{
			wait( 1 );
			continue;
		}

		if( !IsDefined( self.favoriteenemy ) )
		{
			wait( 0.5 );
			continue;
		}

		if( DistanceSquared( self.origin, self.favoriteenemy.origin ) < 64 * 64 )
		{
			self zombie_head_gib();
			self DoDamage( self.health + 10, self.origin );
		}

		wait( 0.05 );
	}
#/
}

zombie_pathing()
{
	self endon( "death" );
	self endon( "zombie_acquire_enemy" );
	level endon( "intermission" );

	assert( IsDefined( self.favoriteenemy ) );
	self.favoriteenemy endon( "disconnect" );

	self thread zombie_follow_enemy();
	self waittill( "bad_path" );

	debug_print( "Zombie couldn't path to player at origin: " + self.favoriteenemy.origin + " Falling back to breadcrumb system" );
	crumb_list = self.favoriteenemy.zombie_breadcrumbs;
	bad_crumbs = [];

	while( 1 )
	{
		if( !is_player_valid( self.favoriteenemy ) )
		{
			self.zombie_path_timer = 0;
			return;
		}

		goal = zombie_pathing_get_breadcrumb( self.favoriteenemy.origin, crumb_list, bad_crumbs, ( RandomInt( 100 ) < 20 ) );
		
		if ( !IsDefined( goal ) )
		{
			debug_print( "Zombie exhausted breadcrumb search" );
			goal = self.favoriteenemy.spectator_respawn.origin;
		}

		if ( self IsInGoal( goal ) )
		{
			self Melee();
		}
		
		debug_print( "Setting current breadcrumb to " + goal );

		self.zombie_path_timer += 1000;
		self SetGoalPos( goal );
		self waittill( "bad_path" );

		debug_print( "Zombie couldn't path to breadcrumb at " + goal + " Finding next breadcrumb" );
		for( i = 0; i < crumb_list.size; i++ )
		{
			if( goal == crumb_list[i] )
			{
				bad_crumbs[bad_crumbs.size] = i;
				break;
			}
		}
	}
}

zombie_pathing_get_breadcrumb( origin, breadcrumbs, bad_crumbs, pick_random )
{
	assert( IsDefined( origin ) );
	assert( IsDefined( breadcrumbs ) );
	assert( IsArray( breadcrumbs ) );

	/#
		if ( pick_random )
		{
			debug_print( "Finding random breadcrumb" );
		}
	#/
			
	for( i = 0; i < breadcrumbs.size; i++ )
	{
		if ( pick_random )
		{
			crumb_index = RandomInt( breadcrumbs.size );
		}
		else
		{
			crumb_index = i;
		}
				
		if( crumb_is_bad( crumb_index, bad_crumbs ) )
		{
			continue;
		}

		return breadcrumbs[crumb_index];
	}

	return undefined;
}

crumb_is_bad( crumb, bad_crumbs )
{
	for ( i = 0; i < bad_crumbs.size; i++ )
	{
		if ( bad_crumbs[i] == crumb )
		{
			return true;
		}
	}

	return false;
}

zombie_follow_enemy()
{
	self endon( "death" );
	self endon( "zombie_acquire_enemy" );
	self endon( "bad_path" );
	level endon( "intermission" );

	while( 1 )
	{
		if( IsDefined( self.favoriteenemy ) )
		{
			self SetGoalPos( self.favoriteenemy.origin );
		}

		wait( 0.1 );
	}
}


// When a Zombie spawns, set his eyes to glowing.
zombie_eye_glow()
{
	if( IsDefined( level.zombie_eye_glow ) && !level.zombie_eye_glow )
{
		return; 
	}

	if( !IsDefined( self ) )
	{
		return;
	}

	linkTag = "J_Eyeball_LE";
	fxModel = "tag_origin";
	fxTag = "tag_origin";

	// SRS 9/2/2008: only using one particle now per Barry's request;
	//  modified to be able to turn particle off
	self.fx_eye_glow = Spawn( "script_model", self GetTagOrigin( linkTag ) );
	self.fx_eye_glow.angles = self GetTagAngles( linkTag );
	self.fx_eye_glow SetModel( fxModel );
	self.fx_eye_glow LinkTo( self, linkTag );

	// TEMP for testing
	//self.fx_eye_glow thread maps\_debug::drawTagForever( fxTag );

	PlayFxOnTag( level._effect["eye_glow"], self.fx_eye_glow, fxTag );
}

// Called when either the Zombie dies or if his head gets blown off
zombie_eye_glow_stop()
{
	if( IsDefined( self.fx_eye_glow ) )
	{
		self.fx_eye_glow Delete();
	}
}

//
// DEBUG
//

zombie_history( msg )
{
/#
	if( !IsDefined( self.zombie_history ) )
	{
		self.zombie_history = [];
	}

	self.zombie_history[self.zombie_history.size] = msg;
#/
}