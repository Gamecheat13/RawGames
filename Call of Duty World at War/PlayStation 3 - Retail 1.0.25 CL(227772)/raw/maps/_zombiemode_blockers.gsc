#include maps\_utility; 
#include common_scripts\utility; 
#include maps\_zombiemode_utility; 

init()
{
	init_blockers(); 
//	level thread rebuild_barrier_think(); 

	//////////////////////////////////////////
	//designed by prod
	//set_zombie_var( "rebuild_barrier_cap_per_round", 500 );
	//////////////////////////////////////////
}

init_blockers()
{
	// EXTERIOR BLOCKERS ----------------------------------------------------------------- //
	level.exterior_goals = getstructarray( "exterior_goal", "targetname" ); 

	for( i = 0; i < level.exterior_goals.size; i++ )
	{
		level.exterior_goals[i] thread blocker_init(); 
	}

	// DOORS ----------------------------------------------------------------------------- //
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 

	for( i = 0; i < zombie_doors.size; i++ )
	{
		zombie_doors[i] thread door_init(); 
	}

	// DEBRIS ---------------------------------------------------------------------------- //
	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 

	for( i = 0; i < zombie_debris.size; i++ )
	{
		zombie_debris[i] thread debris_init(); 
	}

	// Flag Blockers ---------------------------------------------------------------------- //
	flag_blockers = GetEntArray( "flag_blocker", "targetname" );

	for( i = 0; i < flag_blockers.size; i++ )
	{
		flag_blockers[i] thread flag_blocker(); 
	}	
}

//
// DOORS --------------------------------------------------------------------------------- //
//
door_init()
{
	self.type = undefined; 

	// Figure out what kind of door we are
	targets = GetEntArray( self.target, "targetname" ); 

	if( targets.size == 1 )
	{
		door = targets[0]; 
		if( IsDefined( door.script_angles ) )
		{
			self.type = "rotate"; 
		}
		else if( IsDefined( door.script_vector ) )
		{
			self.type = "move";
		}

		self.door = door; 
	}
	else
	{
		if( IsDefined( self.script_noteworthy ) )
		{
			if( self.script_noteworthy == "bust_apart" )
			{
				self.pieces = targets; 
			}
		}
	}

	AssertEx( IsDefined( self.type ), "You must determine how this door opens. Specify script_angles, script_vector, or a script_noteworthy... Door at: " + self.origin ); 

	cost = 1000;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost;
	}

	self set_hint_string( self, "default_buy_door_" + cost );
	self SetCursorHint( "HINT_NOICON" ); 
	self UseTriggerRequireLookAt();

	self thread door_think(); 
}

door_think()
{

	// maybe the door the should just bust open instead of slowly opening.
	// maybe just destroy the door, could be two players from opposite sides..
	// breaking into chunks seems best.
	// or I cuold just give it no collision
	while( 1 )
	{
		self waittill( "trigger", who ); 

		if( !who UseButtonPressed() )
		{
			continue;
		}

		if( who in_revive_trigger() )
		{
			continue;
		}

		if( is_player_valid( who ) )
		{
			if( who.score >= self.zombie_cost )
			{
				// set the score
				who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost ); 
				
				self.door connectpaths(); 
	
				play_sound_at_pos( "purchase", self.door.origin );
	
				if( self.type == "rotate" )
				{
					self.door NotSolid(); 
					
					time = 1; 
					if( IsDefined( self.door.script_transition_time ) )
					{
						time = self.door.script_transition_time; 
					}
					
					play_sound_at_pos( "door_rotate_open", self.door.origin );
	
					self.door RotateTo( self.door.script_angles, time, 0, 0 ); 
					self.door thread door_solid_thread(); 
				}
				else if( self.type == "move" )
				{
					self.door NotSolid(); 
					
					time = 1; 
					if( IsDefined( self.door.script_transition_time ) )
					{
						time = self.door.script_transition_time; 
					}
					
					play_sound_at_pos( "door_slide_open", self.door.origin );
	
					self.door MoveTo( self.door.origin + self.door.script_vector, time, time * 0.25, time * 0.25 ); 
					self.door thread door_solid_thread();
				}
	
				// door needs to target new spawners which will become part
				// of the level enemy array
				self.door add_new_zombie_spawners(); 
	
				// get all trigs, we might want a trigger on both sides
				// of some junk sometimes
				all_trigs = getentarray( self.target, "target" ); 
				for( i = 0; i < all_trigs.size; i++ )
				{
					all_trigs[i] delete(); 
				}
	
				break; 	
			}
			else // Not enough money
			{
				play_sound_at_pos( "no_purchase", self.door.origin );
			}
		}
	}
}

door_solid_thread()
{
	self waittill( "rotatedone" ); 

	while( 1 )
	{
		players = get_players(); 
		player_touching = false; 
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] IsTouching( self ) )
			{
				player_touching = true; 
				break; 
			}
		}

		if( !player_touching )
		{
			self Solid(); 
			return; 
		}

		wait( 1 ); 
	}
}

//
// DEBRIS ----------------------------------------------------------------------------------- //
//

debris_init()
{
	cost = 1000;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost;
	}

	self set_hint_string( self, "default_buy_debris_" + cost );
	self SetCursorHint( "HINT_NOICON" ); 

	if( !IsDefined( level.flag[self.script_flag] ) )
	{
		flag_init( self.script_flag ); 
	}

	self UseTriggerRequireLookAt();

	self thread debris_think(); 
}

debris_think()
{
	while( 1 )
	{
		self waittill( "trigger", who ); 

		if( !who UseButtonPressed() )
		{
			continue;
		}

		if( who in_revive_trigger() )
		{
			continue;
		}

		if( is_player_valid( who ) )
		{
			if( who.score >= self.zombie_cost )
			{
				// set the score
				who maps\_zombiemode_score::minus_to_player_score( self.zombie_cost ); 
	
				// delete the stuff
				junk = getentarray( self.target, "targetname" ); 
	
				if( IsDefined( self.script_flag ) )
				{
					flag_set( self.script_flag );
				}

				play_sound_at_pos( "purchase", self.origin );
	
				move_ent = undefined;
				clip = undefined;
				for( i = 0; i < junk.size; i++ )
				{	
					junk[i] connectpaths(); 
					junk[i] add_new_zombie_spawners(); 
	
					if( IsDefined( junk[i].script_noteworthy ) )
					{
						if( junk[i].script_noteworthy == "clip" )
						{
							clip = junk[i];
							continue;
						}
					}
	
					struct = undefined;
					if( IsDefined( junk[i].script_linkTo ) )
					{
						struct = getstruct( junk[i].script_linkTo, "script_linkname" );
						if( IsDefined( struct ) )
						{
							move_ent = junk[i];
							junk[i] thread debris_move( struct );
						}
						else
						{
							junk[i] Delete();
						}
					}
					else
					{
						junk[i] Delete();
					}
				}
				
				// get all trigs, we might want a trigger on both sides
				// of some junk sometimes
				all_trigs = getentarray( self.target, "target" ); 
				for( i = 0; i < all_trigs.size; i++ )
				{
					all_trigs[i] delete(); 
				}
	
				if( IsDefined( clip ) )
				{
					if( IsDefined( move_ent ) )
					{
						move_ent waittill( "movedone" );
					}
	
					clip Delete();
				}
				
				break; 								
			}
			else
			{
				play_sound_at_pos( "no_purchase", self.origin );
			}
		}
	}
}

debris_move( struct )
{
	self script_delay();

	self play_sound_on_ent( "debris_move" );

	if( IsDefined( self.script_firefx ) )
	{
		PlayFX( level._effect[self.script_firefx], self.origin );
	}

	// Do a little jiggle, then move.
	if( IsDefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "jiggle" )
		{
			num = RandomIntRange( 3, 5 );
			og_angles = self.angles;
			for( i = 0; i < num; i++ )
			{
				angles = og_angles + ( -5 + RandomFloat( 10 ), -5 + RandomFloat( 10 ), -5 + RandomFloat( 10 ) );
				time = RandomFloatRange( 0.1, 0.4 );
				self Rotateto( angles, time );
				wait( time - 0.05 );
			}
		}
	}

	time = 0.5;
	if( IsDefined( self.script_transition_time ) )
	{
		time = self.script_transition_time; 
	}

	self MoveTo( struct.origin, time, time * 0.5 );
	self RotateTo( struct.angles, time * 0.75 );

	self waittill( "movedone" );
	self play_sound_on_entity ("couch_slam");
	self play_loopsound_on_ent( "debris_hover_loop" );

	if( IsDefined( self.script_fxid ) )
	{
		PlayFX( level._effect[self.script_fxid], self.origin );
	}

	if( IsDefined( self.script_delete ) )
	{
		self Delete();
	}
}

//
// BLOCKER -------------------------------------------------------------------------- //
//
blocker_init()
{
	if( !IsDefined( self.target ) )
	{
		return;
	}

	targets = GetEntArray( self.target, "targetname" ); 

	self.barrier_chunks = []; 
	for( j = 0; j < targets.size; j++ )
	{
		if( IsDefined( targets[j].script_noteworthy ) )
		{
			if( targets[j].script_noteworthy == "clip" )
			{
				self.clip = targets[j]; 
				continue; 
			}
		}

		targets[j].destroyed = false;
		targets[j].claimed = false;
		self.barrier_chunks[self.barrier_chunks.size] = targets[j];

		self blocker_attack_spots();
	}

	self.trigger_location = getstruct( self.target, "targetname" ); 

	self thread blocker_think(); 
}

blocker_attack_spots()
{
	// Get closest chunk
	chunk = getClosest( self.origin, self.barrier_chunks );
	
	dist = Distance2d( self.origin, chunk.origin ) - 36;
	spots = [];
	spots[0] = groundpos( self.origin + ( AnglesToForward( self.angles ) * dist ) + ( 0, 0, 60 ) );
	spots[spots.size] = groundpos( spots[0] + ( AnglesToRight( self.angles ) * 28 ) + ( 0, 0, 60 ) );
	spots[spots.size] = groundpos( spots[0] + ( AnglesToRight( self.angles ) * -28 ) + ( 0, 0, 60 ) );

	taken = [];
	for( i = 0; i < spots.size; i++ )
	{
		taken[i] = false;
	}

	self.attack_spots_taken = taken;
	self.attack_spots = spots;

	self thread debug_attack_spots_taken();
}

blocker_think()
{
	while( 1 )
	{
		wait( 0.5 ); 

		if( all_chunks_intact( self.barrier_chunks ) )
		{
			continue; 
		}

		self blocker_trigger_think(); 
	}
}

blocker_trigger_think()
{
	// They don't cost, they now award the player the cost...
	cost = 10;
	if( IsDefined( self.zombie_cost ) )
	{
		cost = self.zombie_cost; 
	}

	original_cost = cost;

	radius = 96; 
	height = 96; 

	if( IsDefined( self.trigger_location ) )
	{
		trigger_location = self.trigger_location; 
	}
	else
	{
		trigger_location = self; 
	}

	if( IsDefined( trigger_location.radius ) )
	{
		radius = trigger_location.radius; 
	}

	if( IsDefined( trigger_location.height ) )
	{
		height = trigger_location.height; 
	}

	trigger_pos = groundpos( trigger_location.origin ) + ( 0, 0, 4 );
	trigger = Spawn( "trigger_radius", trigger_pos, 0, radius, height ); 

	/#
		if( GetDvarInt( "zombie_debug" ) > 0 )
		{
			thread debug_blocker( trigger_pos, radius, height ); 
		}
	#/

	// Rebuilding no longer costs us money... It's rewarded
	
	//////////////////////////////////////////
	//designed by prod; NO reward hint (See DT#36173)
	trigger set_hint_string( self, "default_reward_barrier_piece" );
	//trigger thread blocker_doubler_hint( "default_reward_barrier_piece_", original_cost );
	//////////////////////////////////////////
	
	doubler_status = level.zombie_vars["zombie_powerup_point_doubler_on"];

	if( doubler_status )
	{
		cost = original_cost * 2;
	}

	trigger SetCursorHint( "HINT_NOICON" ); 

	while( 1 )
	{
		trigger waittill( "trigger", player ); 

		wait( 0.4 );

		while( 1 )
		{
			if( !player IsTouching( trigger ) )
			{
				break;
			}

			if( !is_player_valid( player ) )
			{
				break; 
			}

			if( player in_revive_trigger() )
			{
				break;
			}

			//DT# 37553
			//COST NOTHING NOW, will GIVE you money, so this
			//check is totally invalid	
			//if( ( player.score - cost ) < 0 )
			//{
			//	play_sound_at_pos( "no_purchase", trigger.origin );
			//	break; 
			//}
	
			if( !player UseButtonPressed() )
			{
				break; 
			}

			if( doubler_status != level.zombie_vars["zombie_powerup_point_doubler_on"] )
			{
				doubler_status = level.zombie_vars["zombie_powerup_point_doubler_on"];
				cost = original_cost;
				if( level.zombie_vars["zombie_powerup_point_doubler_on"] )
				{
					cost = original_cost * 2;
				}
			}
	
			// restore a random chunk
			chunk = get_random_destroyed_chunk( self.barrier_chunks ); 
			assert( chunk.destroyed == true ); 
	
			chunk Show(); 
	
			//TUEY Play the sounds
			chunk play_sound_on_ent( "rebuild_barrier_piece" );
	
			self thread replace_chunk( chunk ); 
	
			if( IsDefined( self.clip ) )
			{
				self.clip enable_trigger(); 
				self.clip DisconnectPaths(); 
			}
	
			if( !self script_delay() )
			{
				wait( 1 ); 
			}

			if( !is_player_valid( player ) )
			{
				break;
			}
	
			// set the score
			player.rebuild_barrier_reward += cost;
			if( player.rebuild_barrier_reward < level.zombie_vars["rebuild_barrier_cap_per_round"] )
			{
				player maps\_zombiemode_score::add_to_player_score( cost );
			}
	
			if( all_chunks_intact( self.barrier_chunks ) )
			{
				trigger Delete(); 
				return; 
			}
		}
	}
}

blocker_doubler_hint( hint, original_cost )
{
	self endon( "death" );

	doubler_status = level.zombie_vars["zombie_powerup_point_doubler_on"];
	while( 1 )
	{
		wait( 0.5 );

		if( doubler_status != level.zombie_vars["zombie_powerup_point_doubler_on"] )
		{
			doubler_status = level.zombie_vars["zombie_powerup_point_doubler_on"];
			cost = original_cost;
			if( level.zombie_vars["zombie_powerup_point_doubler_on"] )
			{
				cost = original_cost * 2;
			}
	
			self set_hint_string( self, hint + cost );
		}
	}
}

rebuild_barrier_reward_reset()
{
	self.rebuild_barrier_reward = 0;
}

remove_chunk( chunk, node )
{
	chunk play_sound_on_ent( "break_barrier_piece" );
	
	chunk NotSolid();

	fx = "wood_chunk_destory";
	if( IsDefined( self.script_fxid ) )
	{
		fx = self.script_fxid;
	}

	playfx( level._effect[fx], chunk.origin ); 
	playfx( level._effect[fx], chunk.origin + ( randomint( 20 ), randomint( 20 ), randomint( 10 ) ) ); 
	playfx( level._effect[fx], chunk.origin + ( randomint( 40 ), randomint( 40 ), randomint( 20 ) ) ); 

	if( IsDefined( chunk.script_moveoverride ) && chunk.script_moveoverride )
	{
		chunk Hide();
	}
	else
	{
		if( !IsDefined( chunk.og_origin ) )
		{
			chunk.og_origin = chunk.origin; 
		}

//		angles = node.angles +( 0, 180, 0 );
//		force = AnglesToForward( angles + ( -60, 0, 0 ) ) * ( 200 + RandomInt( 100 ) ); 
//		chunk PhysicsLaunch( chunk.origin, force );
	
		ent = Spawn( "script_origin", chunk.origin ); 
		ent.angles = node.angles +( 0, 180, 0 );
		dist = 100 + RandomInt( 100 );
		dest = ent.origin + ( AnglesToForward( ent.angles ) * dist );
		trace = BulletTrace( dest + ( 0, 0, 16 ), dest + ( 0, 0, -200 ), false, undefined );

		if( trace["fraction"] == 1 )
		{
			dest = dest + ( 0, 0, -200 );
		}
		else
		{
			dest = trace["position"];
		}
	
//		time = 1; 
		chunk LinkTo( ent ); 

		time = ent fake_physicslaunch( dest, 200 + RandomInt( 100 ) );

//		forward = AnglesToForward( ent.angles + ( -60, 0, 0 ) ) * power ); 
//		ent MoveGravity( forward, time ); 

		if( RandomInt( 100 ) > 40 )
		{
			ent RotatePitch( 180, time * 0.5 );
		}
		else
		{
			ent RotatePitch( 90, time, time * 0.5 ); 
		}
		wait( time );

		chunk Hide();
	
		wait( 1 );
		ent Delete(); 
	}

	chunk.destroyed = true;

	if( all_chunks_destroyed( node.barrier_chunks ) )
	{
		EarthQuake( randomfloatrange( 0.5, 0.8 ), 0.5, chunk.origin, 300 ); 
	
		if( IsDefined( node.clip ) )
		{
			node.clip ConnectPaths(); 
			wait( 0.05 ); 
			node.clip disable_trigger(); 
		}
		else
		{
			for( i = 0; i < node.barrier_chunks.size; i++ )
			{
				node.barrier_chunks[i] ConnectPaths(); 
			}
		}
	}
	else
	{
		EarthQuake( RandomFloatRange( 0.1, 0.15 ), 0.2, chunk.origin, 200 ); 
	}
}

replace_chunk( chunk )
{
	if( IsDefined( chunk.og_origin ) )
	{
		time = 0.1 + RandomFloat( 0.2 ); 

		chunk Show();

		sound = "rebuild_barrier_hover";
		if( IsDefined( chunk.script_presound ) )
		{
			sound = chunk.script_presound;
		}

		play_sound_at_pos( sound, chunk.origin );

		only_z = ( chunk.origin[0], chunk.origin[1], chunk.og_origin[2] ); 
		chunk MoveTo( only_z, time, 0, time * 0.25 ); 
		chunk RotateTo( ( 0, 0, 0 ), time + 0.25 ); 
		chunk waittill( "rotatedone" ); 
		wait( 0.2 ); 

		chunk MoveTo( chunk.og_origin, 0.15, 0.1 ); 
		chunk waittill( "movedone" ); 
	}

	chunk.destroyed = false; 

	sound = "barrier_rebuild_slam";
	if( IsDefined( self.script_ender ) )
	{
		sound = self.script_ender;
	}
	
	play_sound_at_pos( sound, chunk.origin );

	chunk Solid(); 

	fx = "wood_chunk_destory";
	if( IsDefined( self.script_fxid ) )
	{
		fx = self.script_fxid;
	}

	playfx( level._effect[fx], chunk.origin ); 
	playfx( level._effect[fx], chunk.origin +( randomint( 20 ), randomint( 20 ), randomint( 10 ) ) ); 
	playfx( level._effect[fx], chunk.origin +( randomint( 40 ), randomint( 40 ), randomint( 20 ) ) ); 

	if( !Isdefined( self.clip ) )
	{
		chunk Disconnectpaths(); 
	}
}

add_new_zombie_spawners()
{
	if( isdefined( self.target ) )
	{
		self.possible_spawners = getentarray( self.target, "targetname" ); 
	}	

	if( isdefined( self.script_string ) )
	{
		spawners = getentarray( self.script_string, "targetname" ); 
		self.possible_spawners = array_combine( self.possible_spawners, spawners );
	}	
	
	if( !isdefined( self.possible_spawners ) )
	{
		return; 
	}
	
	// add new check if they've been added already
	zombies_to_add = self.possible_spawners; 

	for( i = 0; i < self.possible_spawners.size; i++ )
	{
		self.possible_spawners[i].locked_spawner = false;
		add_spawner( self.possible_spawners[i] );
	}
}

//
// Flag Blocker ----------------------------------------------------------------------------------- //
//

flag_blocker()
{
	if( !IsDefined( self.script_flag_wait ) )
	{
		AssertMsg( "Flag Blocker at " + self.origin + " does not have a script_flag_wait key value pair" );
		return;
	}

	if( !IsDefined( level.flag[self.script_flag_wait] ) )
	{
		flag_init( self.script_flag_wait ); 
	}

	type = "connectpaths";
	if( IsDefined( self.script_noteworthy ) )
	{
		type = self.script_noteworthy;
	}

	flag_wait( self.script_flag_wait );

	self script_delay();

	if( type == "connectpaths" )
	{
		self ConnectPaths();
		self disable_trigger();
		return;
	}

	if( type == "disconnectpaths" )
	{
		self DisconnectPaths();
		self disable_trigger();
		return;
	}

	AssertMsg( "flag blocker at " + self.origin + ", the type \"" + type + "\" is not recognized" );
}