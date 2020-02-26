/*****************************************************************************
 * 	Civilians
 * 		A large portion of this was copied and modified from the _partrol
 * 	system.	 Civilians will follow connected pathways.
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
	PrecacheModel( "c_usa_billclinton_g20_fb" );
//	PrecacheModel( "c_mul_civ_club_male_light_head1" );
}


#using_animtree( "generic_human" );
//
//	Initialize the civs
civ_init()
{
	// Need to initialize available models
	assign_civ_spawners( "civ_lobby_male", "civ_lobby_female" );
	
	level.n_curr_sp_civ["male"]		= 0;
	level.n_curr_sp_civ["female"]	= 0;

	// 1st param: str_goal_type - "ent" (script_origins) or "node"
	// 2nd param: str_link_type - "target" or "linkto"
	level.civ_get_goal_func[ "ent" ][ "target" ] = ::get_target_ents;
	level.civ_get_goal_func[ "ent" ][ "linkto" ] = ::get_linked_ents;
	level.civ_get_goal_func[ "node" ][ "target" ] = ::get_target_nodes;
	level.civ_get_goal_func[ "node" ][ "linkto" ] = ::get_linked_nodes;
	
	level.civ_set_goal_func[ "ent" ] = ::set_goal_ent;
	level.civ_set_goal_func[ "node" ] = ::set_goal_node;
	
	level.civ_init = true;
}


// --------------------------------------------------------------------------------
// ---- Civilian run cycle ----
// --------------------------------------------------------------------------------

//
//	Set the run cycle for the civilian
//	"MandatoryArg: <state> : level.scr_anim[ "generic" ][ state ] must exist"
set_civilian_run_cycle( state )
{
	// CIVILIAN_TODO - Add run/walk/sprint variations based on the scared or regular AI
	self.alwaysRunForward = true;
	
	if ( IsArray( level.scr_anim[ "generic" ][ state ] ) )
	{
		anime = random( level.scr_anim[ "generic" ][ state ] );
	}
	else
	{
		anime = level.scr_anim[ "generic" ][ state ];
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
		a_nd_initial_locs = array_combine( a_nd_spawn_locs, a_nd_patrol_locs );
		a_nd_initial_locs = array_randomize( a_nd_initial_locs );
	}

	// Make the player drop bad places so the civilians walk around
//	level thread player_path_block( str_endon );

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
				ai_civ gun_remove();
//				ai_civ thread maps\_patrol::patrol( "civ_poi" );
				ai_civ.patroller_delete_on_path_end = 1;
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
//	Pick a random civ.  Try not to pick the same one as the last one.
//	"OptionalArg: <str_type> - 'male' or 'female' to force a particular one to spawn"
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
	
	ai_civ thread setup_civilian_footsteps( str_type );
	
	return ai_civ;
}

setup_civilian_footsteps( type )
{
	if( !IsDefined( self ) )
		return;
	
	if( type == "male" )
	{
		self SetClientFlag( level.CLIENT_FLAG_CIVILIAN_FOOTSTEPS_MALE );
	}
	else
	{
		self SetClientFlag( level.CLIENT_FLAG_CIVILIAN_FOOTSTEPS_FEMALE );
	}
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
//	level endon( "_stealth_spotted" );
//	level endon( "_stealth_found_corpse" );

//	self thread waittill_combat();
	self thread waittill_death();
//	assert(!IsDefined(self.enemy));
//	self endon("enemy");
	
	self.goalradius = 32;
	self allowedStances("stand");
	self.disableArrivals = true;
	self.disableExits = true;
	self.disableTurns = true;
	self.allowdeath = true;
	self.script_patroller = 1;

	self ent_flag_init( "moving_to_goal" );			// moving to next patrol point
	self ent_flag_init( "moving_to_anim_point" );	// moving to a special interest point not on the patrol path

	// MikeD (3/4/2008): Wait for a couple frames so the level_anim.gsc can kick in.
	waittillframeend;
	
	walkanim = "civ_walk";
	
	if( IsDefined( self.unique_patrol_walk_anim ) )
	{
		walkanim = self.unique_patrol_walk_anim;
		self set_run_anim( walkanim, true );
	}
	else
	{
		if( IsDefined( self.patrol_walk_anim ) )
		{
			walkanim = self.patrol_walk_anim;
		}

		if( IsDefined( self.script_patrol_walk_anim ) )
		{
			walkanim = self.script_patrol_walk_anim;
		}

		self set_civilian_run_cycle( walkanim );
	}


	// Time delay version, only 25% will try to stop at an interest point
	if ( IsDefined( level.a_civ_wander_anim_points ) && RandomInt( 100 ) < 45 )
	{
		self thread goto_wander_anim_point();
	}
	
//	self thread patrol_walk_twitch_loop();
	
	//NOTE add combat call back and force patroller to walk

	if ( IsDefined( start_target ) )
	{
		if ( IsString( start_target ) )
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
	}
	
	assert( IsDefined( currentgoal ), "Initial goal for patroller is undefined" );

//	self thread restart_path( str_goal_type );
	
	nextgoal = currentgoal;
	while ( true )
	{
		while ( IsDefined( nextgoal.patrol_claimed ) )
		{
			// self animscripted( "scripted_animdone", self.origin, self.angles, getGenericAnim( "pause" ) );
			// self waittill( "scripted_animdone" );
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
//			self thread showclaimed( currentgoal );
		}
		
		//this is so we can send him back to his patrol node if need be
		self.last_patrol_goal = currentgoal;
				
		self wander_to_goal( str_goal_type, currentgoal );
		
		while ( self ent_flag( "moving_to_anim_point" ) )
		{
			self waittill( "restart_moving_to_goal" );

			self wander_to_goal( str_goal_type, currentgoal );
		}
		
		self ent_flag_clear( "moving_to_goal" );
		currentgoal notify( "trigger", self );

		if ( IsDefined( currentgoal.script_animation ) )
		{
			//assert( currentgoal.script_animation == "pause" || currentgoal.script_animation == "turn180" || currentgoal.script_animation == "smoke" );

			stop = "patrol_stop";
			self anim_generic_custom_animmode( self, "gravity", stop ); 

			wait( 1.0 );	// test to see if they orient properly
			
			switch( currentgoal.script_animation )
			{
/*
  				case "pause":
					idle = "patrol_idle_" + RandomIntRange(1,4);
					self anim_generic( self, idle );
					start = "patrol_start";
					self anim_generic_custom_animmode( self, "gravity", start ); 
					break;
*/
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
				level.ai_civs = array_remove( level.ai_civs, self );
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
	wait( RandomFloatRange( 10.0, 20.0 ) );
	
	// Find a nearby point of interest
	CONST n_range = 512 * 512;
	
	b_point_found = false;
	while ( !b_point_found )
	{
		foreach( n_point in level.a_civ_wander_anim_points )
		{
			if ( !IS_TRUE(n_point.patrol_claimed) &&
			     DistanceSquared( self.origin, n_point.origin ) < n_range )
			{
				// see if it's in front of you too
				v_to_point = n_point.origin - self.origin;
				n_dot = VectorDot( v_to_point, AnglesToForward( self.angles ) );
				// within +/- 75 degrees from front ~= cos( 75 ) ~= 0.2588
				if ( n_dot > 0.2588 )
				{
					b_point_found = true;
					n_anim_point = n_point;
				}
				break;
			}
		}

		if ( !b_point_found )
		{
			wait( 5.0 );
		}
	}

	if ( !IsDefined( n_anim_point ) )
	{
		return;
	}
	
	// Now go there
	self notify( "interrupt_wandering" );
	n_anim_point.patrol_claimed = true;
	self ent_flag_set( "moving_to_anim_point" );
	self SetGoalNode( n_anim_point );
	self waittill( "goal" );
	
	// Play anim
	if ( IsDefined( n_anim_point.script_animation ) )
	{
		self anim_generic( self, n_anim_point.script_animation );
		self anim_generic_custom_animmode( self, "gravity", "patrol_start" ); 
	}
	self ent_flag_clear( "moving_to_anim_point" );
	n_anim_point.patrol_claimed = undefined;
	
	// Continue	back to what you were doing
	if ( self ent_flag( "moving_to_goal" ) )
    {
		self notify( "restart_moving_to_goal" );
	}
}


/*
//
//	Try to get the AI moving again after being blocked
//	NOTE: This doesn't work
restart_path( str_goal_type )
{
	self endon( "death" );
	
	n_restarts = 0;	// number of restart attempts made
	while (1)
	{
		self ent_flag_wait( "moving_to_goal" );
		
		while ( self ent_flag( "moving_to_goal" ) )
		{
			if ( self.movemode == "stop" )
			{
				n_restarts++;
				if ( n_restarts < 100 )
				{
					// Try to recalculate your path to the goal
					[[ level.civ_set_goal_func[ str_goal_type ] ]]( self.currentgoal );
					wait( 1.0 );
				}
				else
				{
					// Something is blocking us.  Wait to see if the blockage goes away.
					wait( 5.0 );
				}
			}
			else
			{
				n_restarts = 0;
			}
			
			wait( 0.1 );
		}
	}
}


patrol_walk_twitch_loop()
{
	self endon( "death" );
	self endon( "enemy" );
	self endon( "end_patrol" );
	level endon( "_stealth_spotted" );
	level endon( "_stealth_found_corpse" );
	
	self notify( "patrol_walk_twitch_loop" );
	self endon( "patrol_walk_twitch_loop" );
	
	if( (IsDefined( self.patrol_walk_anim )||IsDefined(self.unique_patrol_walk_anim) ) && !IsDefined( self.patrol_walk_twitch ) )
	{
		return;
	}
	
	while(1)
	{
		wait randomfloatrange(8,20);
		
		walkanim = "patrol_walk_twitch";	
		if( IsDefined( self.patrol_walk_twitch ) )
		{
			walkanim = self.patrol_walk_twitch;
		}
					
		self set_generic_run_anim( walkanim, true );
		length = getanimlength( getanim_generic( walkanim ) );
		wait length;
		
		walkanim = "patrol_walk";
		if( IsDefined( self.unique_patrol_walk_anim ) )
		{
			walkanim = self.unique_patrol_walk_anim;
			self set_run_anim( walkanim, true );
		}
		else
		{
			if( IsDefined( self.patrol_walk_anim ) )
			{
				walkanim = self.patrol_walk_anim;
			}

			if( IsDefined( self.script_patrol_walk_anim ) )
			{
				walkanim = self.script_patrol_walk_anim;
			}

			self set_generic_run_anim( walkanim, true );
		}
	}
}

waittill_combat_wait()
{
	self endon( "end_patrol" );
	level endon( "_stealth_spotted" );
	level endon( "_stealth_found_corpse" );
	self waittill( "enemy" );
}
*/

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
/*
waittill_combat()
{
	self endon( "death" );

	assert(!IsDefined(self.enemy));

	waittill_combat_wait();

	//	self.walkdist = self.old_walkdist;

	if( !IsDefined( self._stealth ) )
	{
		self clear_run_anim();
		self allowedStances( "stand", "crouch", "prone" );
		self.disableArrivals = false;
		self.disableExits = false;
		self.disableTurns = false;
		self stopanimscripted();
		self notify( "stop_animmode" );
	}

	self.allowdeath = false;	

	if( !IsDefined( self ) )
	{
		return;
	}

	self notify( "release_node" );

	if( !IsDefined( self.last_patrol_goal ) )
	{
		return;
	}

	self.last_patrol_goal.patrol_claimed = undefined;
}
*/

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
 //	Tells us which spawners to use for our civs.
assign_civ_spawners( str_male_spawnername, str_female_spawnername )
{
	if ( IsDefined( str_male_spawnername ) )
	{
		level.a_sp_civs[ "male" ] = GetEntArray( str_male_spawnername, "targetname" );
	}
	
	if ( IsDefined( str_female_spawnername ) )
	{
		level.a_sp_civs[ "female" ] = GetEntArray( str_female_spawnername, "targetname" );
	}
}
	
	
//
//	Assigns a drone spline to use our civilians
assign_civ_drone_spawners( script_string )
{
	a_str_keys = GetArrayKeys( level.a_sp_civs );
	foreach( str_key in a_str_keys )
	{
		foreach( sp_civ in level.a_sp_civs[ str_key ] )
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
		m_civ Delete();
		
		// Throttle it a bit
		if ( index % 20 == 0 )
		{
			wait( 0.05 );
		}
	}
}

#using_animtree( "fakeShooters" );
spawn_static_drones( script_string, targetname )
{
	s_drone_data = maps\_drones::drones_get_data_from_script_string( script_string );
	a_s_static_locs = GetStructArray( targetname, "targetname" );
	foreach( s_static_loc in a_s_static_locs )
	{
/*
		// TEMP test for filling the Club
		if ( IsDefined( s_static_loc.script_noteworthy ) &&
		    s_static_loc.script_noteworthy == "model_only" )
		{
			s_trace = BulletTrace( s_static_loc.origin, (s_static_loc.origin+(0,0,-100)), false, level.player );
			m_model = Spawn( "script_model", s_trace[ "position" ] );
			m_model.angles = s_static_loc.angles;
			m_model SetModel( "c_usa_billclinton_g20_fb" );
//			m_model Attach( "c_mul_civ_club_male_light_head1", "J_Body" );
			m_model.targetname = "civilian";
		}
		else
*/
		{
			s_static_loc maps\_drones::drone_spawn( "allies", 0, 0, s_drone_data );
		}
	}
}


//
//	Drop bad places around the player so AIs walk around
player_path_block( str_endon )
{
	level endon( "stop_civ_spawns" );

	if ( IsDefined( str_endon ) )
	{
		level endon( str_endon );
	}

	BadPlacesEnable( 1 );
	while (1)
	{
		BadPlace_Cylinder( "player", 1, level.player.origin, 20, 72, "neutral" );
		wait( 0.2 );
	}
}
