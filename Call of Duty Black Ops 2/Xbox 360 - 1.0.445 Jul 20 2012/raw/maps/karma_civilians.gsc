/*****************************************************************************
 * 	Civilians
 * 		A large portion of this was copied and modified from the _patrol
 * 	system.	 Civilians will follow connected pathways.
 * 
 * 
 * 	Drone model civs
 * 		Spawners
 * 			script_string - used to denote the type of spawner like civ_male, civ_bouncer, civ_dancer
 * 
 * 
 *****************************************************************************/
#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


civ_precache()
{
	PrecacheModel( "p6_anim_bluetooth_female" );
	PrecacheModel( "p6_anim_bluetooth_male" );
	
	PrecacheModel( "p6_anim_cell_phone" );

	PrecacheModel( "p6_anim_shopping_bag_red" );
	PrecacheModel( "p6_anim_shopping_bag_blue" );
	
	PrecacheModel( "com_metal_briefcase" );

	PrecacheModel( "p6_water_bottle" );
	PrecacheModel( "ma_cup_smoothie" );
	PrecacheModel( "ma_cup_single_closed" );
	PrecacheModel( "popcorn_cup_single" );
	PrecacheModel( "food_soda_single01" );
	PrecacheModel( "food_soda_single02" );
}


#using_animtree( "generic_human" );
//
//	Initialize the civs
civ_init()
{
	// Need to initialize available models
	level.a_sp_civs = [];
	
	// 1st param: str_goal_type - "ent" (script_origins) or "node"
	// 2nd param: str_link_type - "target" or "linkto"
	level.civ_get_goal_func[ "ent" ][ "target" ] = ::get_target_ents;
	level.civ_get_goal_func[ "ent" ][ "linkto" ] = ::get_linked_ents;
	level.civ_get_goal_func[ "node" ][ "target" ] = ::get_target_nodes;
	level.civ_get_goal_func[ "node" ][ "linkto" ] = ::get_linked_nodes;
	
	level.civ_set_goal_func[ "ent" ] = ::set_goal_ent;
	level.civ_set_goal_func[ "node" ] = ::set_goal_node;
	
	level.civ_init = true;

	// Define the civ props
	level.a_str_civ_props["phone"][0] = "p6_anim_cell_phone";
	
	level.a_str_civ_props["drink"][0] = "p6_water_bottle";
	level.a_str_civ_props["drink"][1] = "ma_cup_smoothie";
	level.a_str_civ_props["drink"][2] = "ma_cup_single_closed";
	level.a_str_civ_props["drink"][3] = "popcorn_cup_single";
	level.a_str_civ_props["drink"][4] = "food_soda_single01";
	level.a_str_civ_props["drink"][5] = "food_soda_single02";
}


// --------------------------------------------------------------------------------
// ---- Civilian run cycle ----
// --------------------------------------------------------------------------------

//
//	Set the run cycle for the civilian
//	"MandatoryArg: <str_state> : level.scr_anim[ self.script_string ][self.anim_set][ state ] must exist"
//	"OptionalArg: <anim_override> : force set a specific animation, in which case, state may be undefined
set_civilian_run_cycle( str_state, anim_override )
{
	// CIVILIAN_TODO - Add run/walk/sprint variations based on the scared or regular AI
	self.alwaysRunForward = true;
	
	if ( IsDefined( anim_override ) )
	{
		anime = anim_override;
	}
	else
	{
		if ( IsArray( level.scr_anim[ self.script_string ][ self.anim_set ][ str_state ] ) )
		{
			anime = random( level.scr_anim[ self.script_string ][ self.anim_set ][ str_state ] );
		}
		else
		{
			anime = level.scr_anim[ self.script_string ][ self.anim_set ][ str_state ];
		}
	}
	self.a.combatrunanim 	= anime;
	self.run_noncombatanim  = anime;
	self.walk_combatanim 	= anime;
	self.walk_noncombatanim = anime;
}


//
//	Keep spawning civilians (up to n_max_spawns alive at once)
//
//	"MandatoryArg: <str_spawn_loc> : targetname of the spawner structs"
//	"MandatoryArg: <n_max_spawns> : maximum number of civilian AIs to have active at once"
//	"OptionalArg: <str_starter_loc> : targetname of the initial spawn locations"
//	"OptionalArg: <n_initial_spawns> : number of AI to quickly spawn at initial and spawn locs"
//	"OptionalArg: <str_endon> : Message to end civ spawning"
spawn_civs( str_spawn_loc, n_max_spawns, str_starter_loc, n_initial_spawns, str_endon, n_min_spawn_delay, n_max_spawn_delay )
{
	level endon( "stop_civ_spawns" );

	if ( IsDefined( str_endon ) )
	{
		level endon( str_endon );
	}
	
	if ( !IsDefined( n_initial_spawns ) )
	{
		n_initial_spawns = 0;
	}
	
	if ( !IsDefined( n_min_spawn_delay ) )
	{
		n_min_spawn_delay = 1.0;
	}
	
	if ( !IsDefined( n_max_spawn_delay ) )
	{
		n_max_spawn_delay = 4.0;
	}
	
	level.ai_civs = [];
	a_nd_spawn_locs = GetNodeArray( str_spawn_loc, "targetname" );
	if ( IsDefined( str_starter_loc ) )
	{
		a_nd_patrol_locs = GetNodeArray( str_starter_loc, "targetname" );
		a_nd_initial_locs = ArrayCombine( a_nd_spawn_locs, a_nd_patrol_locs, true, false );
		a_nd_initial_locs = array_randomize( a_nd_initial_locs );
	}

	// Keep spawning civs until we get an endon	
	while( 1 )
	{
		if ( level.ai_civs.size < n_max_spawns )
		{
			ai_civ = pick_a_civ();
			if ( IsDefined( ai_civ ) )
			{
				if ( level.ai_civs.size < n_initial_spawns && IsDefined( a_nd_initial_locs ) )
				{
					nd_start = a_nd_initial_locs[ level.ai_civs.size ];
				}
				else
				{
					nd_start = random( a_nd_spawn_locs );
				}
				ai_civ.targetname = "civilian";
				ai_civ forceteleport( nd_start.origin, nd_start.angles );
//				ai_civ gun_remove();
//				ai_civ thread maps\_patrol::patrol( "civ_poi" );
				ai_civ thread wander( nd_start );
				
				level.ai_civs[ level.ai_civs.size ] = ai_civ;
			}
		}

		if ( level.ai_civs.size <= n_initial_spawns )
		{
			wait( 0.1 );
		}
		else
		{
			wait( RandomFloatRange( n_min_spawn_delay, n_max_spawn_delay ) );
		}
	}
}


//
//	Pick a random civ spawner.  Try not to pick the same one as the last one.
//	"OptionalArg: <str_type> - 'civ_male' or 'civ_female' to force a particular one to spawn"
pick_a_civ( str_type )
{
	if ( !IsDefined( str_type ) || !IsDefined( level.a_sp_civs[ str_type ] ) )
	{
		a_keys = GetArrayKeys( level.a_sp_civs );
		str_type = a_keys[ RandomInt( a_keys.size ) ];
	}

	sp_last = level.a_sp_civs[ str_type ][ level.n_curr_sp_civ[ str_type ] ];

	// Check what the last spawn was.  If we've reached the end of the list,
	//	randomize and start again.
	level.n_curr_sp_civ[ str_type ]++;
	if ( level.n_curr_sp_civ[ str_type ] >= level.a_sp_civs[ str_type ].size - 1 )
	{
		level.a_sp_civs[ str_type ] = array_randomize( level.a_sp_civs[ str_type ] );

		// Make sure the start of this isn't the same as the last one we spawned
		if ( level.a_sp_civs[ str_type ][0] == sp_last && level.a_sp_civs[ str_type ].size > 1 )
		{
			level.n_curr_sp_civ[ str_type ] = 1;
		}
		else
		{
			level.n_curr_sp_civ[ str_type ] = 0;
		}
	}

	sp_civ = level.a_sp_civs[ str_type ][ level.n_curr_sp_civ[ str_type ] ];
	sp_civ.count = 2;	// always make sure you can spawn one
	
	ai_civ = simple_spawn_single( sp_civ );
	// Keep trying until you can
	while ( !IsDefined( ai_civ ) )
	{
		wait( 1.0 );
		
		ai_civ = simple_spawn_single( sp_civ );
	}
	
	return ai_civ;
}

//
//	Most of this is copied from _patrol
//		Make a civ follow a chain of nodes.  There is some special code to prevent them from
//	choosing destinations with the same ID as their current node.
wander( start_target )
{
	if (!IsDefined(level.civ_init))
	{
		civ_init();
	}

	if (IsDefined(self.enemy))
	{
		return;
	}
	self endon( "death" );
	self endon( "end_patrol" );

	self thread waittill_death();
	
	self.goalradius = 32;
	self allowedStances("stand");
	self.allowdeath = true;
	self.script_patroller = 1;
	self.patroller_delete_on_path_end = 1;
	self.disableTurns = 1;

	self ent_flag_init( "moving_to_goal" );			// moving to next patrol point
	self ent_flag_init( "wander_pause" );	// moving to a special interest point not on the patrol path

	// MikeD (3/4/2008): Wait for a couple frames so the level_anim.gsc can kick in.
	waittillframeend;

	// Override stuff set in _civilians::civilian_spawn_init()
	self PushPlayer( false );
//	self.badplaceawareness    = 1;

	if( !isdefined( self.script_string ) )
	{
		//default to male
		self.script_string = "civ_male";
	}

	// Setup the anim override sets
	self init_anim_set_overrides();
	
	//	Do we need to spawn any props on this ai?
	self civ_spawn_props();
	
	// Time delay version, only X% will try to stop at an interest point
	if ( IsDefined( level.a_civ_wander_anim_points ) && RandomInt( 100 ) < 45 )
	{
		self thread goto_wander_anim_point();
	}

	//NOTE add combat call back and force patroller to walk
	if ( IsDefined( start_target ) && IsString( start_target ) )
	{
		self.target = start_target;

		assert( IsDefined( self.target ) || IsDefined( self.script_linkto ), "Patroller with no target or script_linkto defined." );

		if ( IsDefined( self.target ) )
		{
			str_link_type = "target";
			ents = self get_target_ents();
			nodes = self get_target_nodes();

			if ( ents.size )
			{
				currentgoal = random( ents );
				str_goal_type = "ent";
			}
			else
			{
				currentgoal = random( nodes );
				str_goal_type = "node";
			}
		}
		else
		{
			str_link_type = "linkto";
			ents = self get_linked_ents();
			nodes = self get_linked_nodes();
	
			if ( ents.size )
			{
				currentgoal = random( ents );
				str_goal_type = "ent";
			}
			else
			{			
				currentgoal = random( nodes );
				str_goal_type = "node";
			}
		}
	}
	else
	{
		self.target = start_target.targetname;
		currentgoal = start_target;
		str_link_type = "target";

		if ( start_target.type == "Path" )
		{
			str_goal_type = "node";
		}
		else
		{
			str_goal_type = "ent";
		}
	}
	
	assert( IsDefined( currentgoal ), "Initial goal for patroller is undefined" );

	nextgoal = currentgoal;
	while ( true )
	{
		while ( IsDefined( nextgoal.patrol_claimed ) )
		{
			wait 0.05;
		}

		currentgoal.patrol_claimed = undefined;
		currentgoal = nextgoal;
		self.currentgoal = currentgoal;
		self notify( "release_node" );

		assert( !IsDefined( currentgoal.patrol_claimed ), "Goal was already claimed" );

		// Don't claim the node if you're not going to stay
		if (!IS_TRUE(self.patrol_dont_claim_node) &&
		    ( IsDefined( currentgoal.script_animation ) && currentgoal.script_animation != "delete" ) )
		{
			currentgoal.patrol_claimed = true;
		}
		
		// This is so we can send him back to his patrol node if need be
		self.last_patrol_goal = currentgoal;
				
		self wander_to_goal( str_goal_type, currentgoal );
		
		while ( self ent_flag( "wander_pause" ) )
		{
			self waittill( "restart_moving_to_goal" );

			self wander_to_goal( str_goal_type, currentgoal );
		}
		
		self ent_flag_clear( "moving_to_goal" );
		currentgoal notify( "trigger", self );

		if ( IsDefined( currentgoal.script_animation ) )
		{
			stop = "patrol_stop";
			self anim_generic_custom_animmode( self, "gravity", stop ); 

			wait( 1.0 );	// test to see if they orient properly
			
			switch( currentgoal.script_animation )
			{
				case "turn180":
					turn = "patrol_turn180";
					self anim_generic_custom_animmode( self, "gravity", turn );
					break;
				case "smoke":
					anime = "patrol_idle_1";
					self anim_generic( self, anime );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
				case "stretch":
					anime = "patrol_idle_1";
					self anim_generic( self, anime );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
				case "checkphone":
					anime = "patrol_idle_1";
					self anim_generic( self, anime );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
				case "phone":
					anime = "patrol_idle_1";
					self anim_generic( self, anime );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
				default:
					self anim_generic( self, currentgoal.script_animation );
					self anim_generic_custom_animmode( self, "gravity", "patrol_start" ); 
					break;
			}
		}

		currentgoals = currentgoal [[ level.civ_get_goal_func[ str_goal_type ][ str_link_type ] ]]();

		if ( !currentgoals.size )
		{
			self notify( "reached_path_end" );

			// if set then this AI will be removed at the end of the patrol path
			if( IsDefined( self ) && IsDefined( self.patroller_delete_on_path_end ) && self.patroller_delete_on_path_end )
			{
				release_claimed_node();
				ArrayRemoveValue( level.ai_civs, self );
				self notify( "patroller_deleted_on_path_end" );
				self Delete();
			}
	
			break;
		}

		nextgoal = random( currentgoals );
		
		// Make sure the next one doesn't share the same ID as the current one.
		//	This is basically how I avoid people in the traffic lanes from making
		//	U-turns (to avoid wanderers from double-backing on each other)
		if ( IsDefined( currentgoal.script_int ) && IsDefined( nextgoal.script_int ) && currentgoals.size > 1 )
		{
			while ( IsDefined( nextgoal.script_int ) && currentgoal.script_int == nextgoal.script_int )
			{
				nextgoal = random( currentgoals );
				wait( 0.05 );
			}
		}
	}
}


//
//	Overrides the default animations using an anim_set
//		self is a civilian AI
init_anim_set_overrides()
{
	Assert( IsDefined( level.scr_anim[ self.script_string ] ), "There is no anim set for "+ self.script_string );

	self.disablearrivals = true;
	self.disableexits = true;

	a_str_anim_sets = GetArrayKeys( level.scr_anim[ self.script_string ] );
	self.anim_set = random( a_str_anim_sets );

	// Run
	self set_civilian_run_cycle( "walk" );
	
	// Idle
	self animscripts\anims::setIdleAnimOverride( level.scr_anim[ self.script_string ][ self.anim_set ][ "idle" ] );

	// Turn
	if( !IsDefined(self.anim_array) )
	{
    	 self.anim_array = [];
	}

	self.anim_array[self.animType]["turn"]["stand"]["none"]["turn_f_l_45"]  = level.scr_anim[ self.script_string ][ self.anim_set ][ "turn_l" ];
	self.anim_array[self.animType]["turn"]["stand"]["none"]["turn_f_l_90"]  = level.scr_anim[ self.script_string ][ self.anim_set ][ "turn_l" ];
	self.anim_array[self.animType]["turn"]["stand"]["none"]["turn_f_l_135"] = level.scr_anim[ self.script_string ][ self.anim_set ][ "turn_l" ];
	self.anim_array[self.animType]["turn"]["stand"]["none"]["turn_f_l_180"] = level.scr_anim[ self.script_string ][ self.anim_set ][ "turn_l" ];
	self.anim_array[self.animType]["turn"]["stand"]["none"]["turn_f_r_45"]  = level.scr_anim[ self.script_string ][ self.anim_set ][ "turn_r" ];
	self.anim_array[self.animType]["turn"]["stand"]["none"]["turn_f_r_90"]  = level.scr_anim[ self.script_string ][ self.anim_set ][ "turn_r" ];
	self.anim_array[self.animType]["turn"]["stand"]["none"]["turn_f_r_135"] = level.scr_anim[ self.script_string ][ self.anim_set ][ "turn_r" ];
	self.anim_array[self.animType]["turn"]["stand"]["none"]["turn_f_r_180"] = level.scr_anim[ self.script_string ][ self.anim_set ][ "turn_r" ];

	// Bump behavior/anims
	self set_exception( "stop_immediate", ::civ_stop_callback );
}


//
//	Check if we need to spawn any props appropriate to their anim set
//
civ_spawn_props()
{
	// Spawn in-hand prop
	if ( IsDefined( self.anim_set ) && IsDefined( level.a_str_civ_props[ self.anim_set ] ) )
	{
		if ( self.script_string == "civ_male" )
		{
			self Attach( random( level.a_str_civ_props[ self.anim_set ] ), "TAG_WEAPON_LEFT" );
		}
		else
		{
			self Attach( random( level.a_str_civ_props[ self.anim_set ] ), "TAG_WEAPON_RIGHT" );
		}
	}
	
	// Randomly attach Headset phones
	if ( RandomInt(100) > 60 && self.anim_set != "phone" )
	{
		if ( self.script_string == "civ_female" )
		{
			self Attach( "p6_anim_bluetooth_female", "J_Head" );
		}
		else
		{
			self Attach( "p6_anim_bluetooth_male", "J_Head" );
		}
	}
}


// 
//	Check to see if we need to play a bump anim
//	This is a "stop_immediate" state callback.
//		self is a civilian AI
civ_stop_callback()
{
	n_player_near_dist = 72 * 72;
	n_pathing_fov = cos( 45 );

	n_dist = DistanceSquared( self.origin, level.player.origin );
	v_facing = AnglesToForward( self.angles );
	v_to_player = VectorNormalize( level.player.origin - self.origin );
	n_facing_offset = VectorDot( v_facing, v_to_player );

	// Is the player near and in front of us?
	if ( n_dist < n_player_near_dist && n_facing_offset > n_pathing_fov )
	{
		// stop.  Do not attempt to repath.
		self ent_flag_set( "wander_pause" );
		self SetGoalPos( self.origin );
		
		// Look at the player
		self animscripts\utility::SetLookAtEntity( level.player );
		self OrientMode( "face point", level.player.origin );

		// Play bump anim
		anim_bump = level.scr_anim[ self.script_string ][ self.anim_set ][ "bump" ];
		self SetFlaggedAnimKnobAllRestart( "bump", anim_bump, %generic_human::root );
		self animscripts\shared::DoNoteTracks( "bump" );
		
		self thread civ_bumped();
	}

}


//
//	Civ has been blocked by the player.  Wait for the player to pass.
//		self is a civilian AI
civ_bumped()
{
	n_player_far_dist = 96 * 96;
	n_pathing_fov = cos( 45 );
	n_timeout = GetTime() + 5000;
	// Wait until the player is far enough away before attempting a restart
	while ( GetTime() < n_timeout )
	{
		n_dist = DistanceSquared( self.origin, level.player.origin );
		v_facing = AnglesToForward( self.angles );
		v_to_player = VectorNormalize( level.player.origin - self.origin );
		n_facing_offset = VectorDot( v_facing, v_to_player );

		if ( n_dist > n_player_far_dist || n_facing_offset < n_pathing_fov )
		{
			break;
		}
		
		wait( 1.0 );
	}

	// Return to wandering
	self animscripts\utility::StopLookingAtEntity();
	self OrientMode( "face default" );

	// continue to your previous goal
	self ent_flag_clear( "wander_pause" );
	self notify( "restart_moving_to_goal" );
	return;
}


//
//	Sets the goal destination
//	self is the wandering AI
wander_to_goal( str_goal_type, currentgoal )
{
	self endon( "interrupt_wandering" );
	
	[[ level.civ_set_goal_func[ str_goal_type ] ]]( currentgoal );
	self ent_flag_set( "moving_to_goal" );
	
	//check for both defined and size - because ents dont have radius defined by 
	//default - but nodes do - and that radius is 0 by default.
	if( IsDefined( currentgoal.radius ) && currentgoal.radius > 0 )
	{
		self.goalradius = currentgoal.radius;
	}
	else
	{
		self.goalradius = 32;
	}
	self waittill("goal");
}


//
//	Assigns the places of interest that civs will path towards
assign_wander_anim_points( str_name, str_key )
{
	level.a_civ_wander_anim_points = GetNodeArray( str_name, str_key );
}


//
//	Look for a suitable node to go to to play an animation.
goto_wander_anim_point()
{
	self endon( "death" );
	
	// See if it's time to look for a point of interest
	wait( RandomFloatRange( 10.0, 60.0 ) );
	
	// Find a nearby point of interest
	CONST n_range = 512 * 512;
	
	b_point_found = false;
	while ( !b_point_found )
	{
		foreach( nd_point in level.a_civ_wander_anim_points )
		{
			if ( !IS_TRUE(nd_point.patrol_claimed) &&
			     DistanceSquared( self.origin, nd_point.origin ) < n_range )
			{
				// see if it's in front of you too
				v_to_point = nd_point.origin - self.origin;
				n_dot = VectorDot( v_to_point, AnglesToForward( self.angles ) );
				// within +/- 75 degrees from front ~= cos( 75 ) ~= 0.2588
				if ( n_dot > 0.2588 )
				{
					b_point_found = true;
					nd_anim_point = nd_point;
				}
				break;
			}
		}

		if ( !b_point_found )
		{
			wait( 5.0 );
		}
	}

	if ( !IsDefined( nd_anim_point ) )
	{
		return;
	}
	
	// Now go there
	self notify( "interrupt_wandering" );
	nd_anim_point.patrol_claimed = true;
	self ent_flag_set( "wander_pause" );
	self.nd_curr_goal = nd_anim_point;
	self SetGoalNode( nd_anim_point );
	self waittill( "goal" );

	// Idle briefly	
	self OrientMode( "face angle", nd_anim_point.angles[1] );
	wait( RandomFloatRange( 5, 20 ) );
	
	self OrientMode( "face default" );
	self ent_flag_clear( "wander_pause" );
	nd_anim_point.patrol_claimed = undefined;
	
	// Continue	back to what you were doing
	if ( self ent_flag( "moving_to_goal" ) )
    {
		self notify( "restart_moving_to_goal" );
	}
}


waittill_death()
{
	self waittill( "death" );	
	
	if( !IsDefined( self ) )
	{
		return;
	}
	
	release_claimed_node();
}


release_claimed_node()
{
	self notify( "release_node" );

	if( !IsDefined( self.last_patrol_goal ) )
	{
		return;
	}
	
	self.last_patrol_goal.patrol_claimed = undefined;
}


get_target_ents()
{
	array = [];

	if ( IsDefined( self.target ) )
	{
		array = getentarray( self.target, "targetname" );
	}

	return array;
}

get_target_nodes()
{
	array = [];
	
	if ( IsDefined( self.target ) )
	{
		array = getnodearray( self.target, "targetname" );
	}
	
	return array;
}

get_linked_nodes()
{
	array = [];

	if ( IsDefined( self.script_linkto ) )
	{
		linknames = strtok( self.script_linkto, " " );
		for ( i = 0; i < linknames.size; i ++ )
		{
			ent = getnode( linknames[ i ], "script_linkname" );
			if ( IsDefined( ent ) )
			{
				array[ array.size ] = ent;
			}
		}
	}
	
	return array;
}

/*
//	Test function
showclaimed( goal )
{
	self endon( "release_node" );
	
	 /#
	for ( ;; )
	{
		entnum = self getentnum();
		print3d( goal.origin, entnum, ( 1.0, 1.0, 0.0 ), 1 );
		wait 0.05;
	}
	#/ 
}
*/

//
//	Sort the spawners we're going to use by .script_string
//	str_spawnerbase - the base targetname of the spawner
//	n_baseindex - the starting index number of the targetname (if attempting to assign a group of spawners with different targetnames)
assign_civ_spawners( str_spawnerbase, n_baseindex = undefined )
{
	// Are we adding a series of spawner targetnames?
	if ( IsDefined( n_baseindex ) )
	{
		n_index = n_baseindex;
		str_spawnername = str_spawnerbase + n_index;
	}
	else
	{
		str_spawnername = str_spawnerbase;
	}
	a_spawners = GetEntArray( str_spawnername, "targetname" );

	// Double loop, outer for the series, inner for a single targetname
	while( a_spawners.size != 0 )
	{
		foreach( sp_civ in a_spawners )
		{
			if ( IsDefined( sp_civ.script_string ) )
		    {
				str_type = sp_civ.script_string;
		    	if ( !IsDefined( level.a_sp_civs[ str_type ] ) )
	    	    {
					level.n_curr_sp_civ[ str_type ] = 0;
	    	    	level.a_sp_civs[ str_type ] = [];
	    	    }
		    	
		    	// add the spawner to the str_type category
		    	level.a_sp_civs[ str_type ][ level.a_sp_civs[ str_type ].size ] = sp_civ;
			}
		}

		// Increment the index and search for the next one
		if ( IsDefined( n_index ) )
		{
			n_index++;
			str_spawnername = str_spawnerbase + n_index;
			a_spawners = GetEntArray( str_spawnername, "targetname" );
		}
		else
		{
			return;
		}
	}
}


//
//	Assigns a drone spline to use our civilians
assign_civ_drone_spawners( str_spawnername, script_string )
{
	a_sp_civs = GetEntArray( str_spawnername, "targetname" );
	foreach( sp_civ in a_sp_civs )
	{
		maps\_drones::drones_assign_spawner( script_string, sp_civ );
	}
}


//
//	Will assign an array of spawners to be used by the drone splines.
//	type - a string or array of strings representing the "type" of civ spawners you want to use
assign_civ_drone_spawners_by_type( type, script_string )
{
	if ( !IsArray( type ) )
	{
		a_str_type[0] = type;
	}
	else
	{
		a_str_type = type;
	}

	foreach( str_type in a_str_type )
	{
		assert( IsDefined( level.a_sp_civs[ str_type ] ), "Trying to assign a drone spawner a civ type( "+str_type+" ) that does not exist." );
		
		a_sp_civs = level.a_sp_civs[ str_type ];
		foreach( sp_civ in a_sp_civs )
		{
			maps\_drones::drones_assign_spawner( script_string, sp_civ );
		}
	}
}


//
//	Delete all civs in existence
delete_all_civs()
{
	// Throttle it a bit
	a_m_civs = GetEntArray( "civilian", "targetname" );
	foreach( index, m_civ in a_m_civs )
	{
		if ( IsAlive( m_civ ) )
		{
			m_civ Delete();
		}
		
		// Throttle it a bit
		if ( index % 20 == 0 )
		{
			wait( 0.05 );
		}
	}
}


//
//	Delete all civs in existence
delete_civs( str_id, str_key )
{
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	// Throttle it a bit
	n_deleted = 0;
	a_m_civs = GetEntArray( str_id, str_key );
	foreach( m_civ in a_m_civs )
	{
		m_civ Delete();
		
		// Throttle it a bit
		n_deleted++;
		if ( n_deleted % 20 == 0 )
		{
			wait( 0.05 );
		}
	}
}


#using_animtree( "fakeShooters" );
//
//	Spawn a script model that will just play anims
//	str_structnames - the name of the structs to spawn civs into
//	n_delay - optional delay max (for randomizing animation, 0.0 means no delay)
//
spawn_static_civs( str_structnames, n_delay_max = 2.0 )
{
	// Get a list of available civ categories for random selection
	a_keys = GetArrayKeys( level.a_sp_civs );
	a_civ_types = [];
	foreach( str_type in a_keys )
	{
		if ( !IsDefined( level.a_sp_civs[ str_type ][0].script_percent ) )
		{
			a_civ_types[ str_type ] = 100;
		}
		else if ( level.a_sp_civs[ str_type ][0].script_percent > 0.0 )
		{
			a_civ_types[ str_type ] = level.a_sp_civs[ str_type ][0].script_percent;
		}
	}
	a_civ_types_keys = GetArrayKeys( a_civ_types );

	// Get locations
	a_s_static_locs = GetStructArray( str_structnames, "targetname" );
	a_sp_group = [];	// array of spawners to choose a spawner from
	n_index = 0;
	foreach( s_static_loc in a_s_static_locs )
	{
		// Check to see which array of spawners we should use
		if ( IsDefined( s_static_loc.script_string ) &&
		     IsDefined( level.a_sp_civs[ s_static_loc.script_string ] ) )
		{
			a_sp_group = level.a_sp_civs[ s_static_loc.script_string ];
		}
		else
		{
			//TODO factor in percentage spawning chance
			a_sp_group = level.a_sp_civs[ a_civ_types_keys[ RandomInt( a_civ_types_keys.size ) ] ];
		}

		// Pick a specific spawner
		if ( a_sp_group.size > 1 )
		{
			sp_spawner = a_sp_group[ RandomInt( a_sp_group.size ) ];
		}
		else
		{
			sp_spawner = a_sp_group[ 0 ];
		}

		// Spawn the drone
		m_drone = Spawn( "script_model", s_static_loc.origin );
		m_drone.angles = s_static_loc.angles;
		m_drone.targetname = s_static_loc.targetname;
		m_drone.script_noteworthy = s_static_loc.script_noteworthy;
		m_drone GetDroneModel( sp_spawner.classname );
		m_drone MakeFakeAI();
		m_drone UseAnimtree( #animtree );
		m_drone delay_thread( RandomFloat( n_delay_max ), ::civ_loop_anim, level.drones.anims[ s_static_loc.dr_animation ] );

		n_index++;		
		if ( n_index % 15 == 0 )
		{
			wait( 0.05 );
		}
	}
}

//
// Loop drone animation after a random wait
//	self is a drone
civ_loop_anim( anim_loop )
{
	self endon( "death" );

	// Loop the anim
	while( IsDefined( self ) )
	{
		self AnimScripted( "drone_idle_anim", self.origin, self.angles, anim_loop );
		self waittillmatch( "drone_idle_anim", "end" ); 
	}
}


