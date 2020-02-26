// Black Hole Bomb client side scripts
#include clientscripts\mp\_utility;
#include clientscripts\mp\_music;
#include clientscripts\mp\zombies\_zm_weapons;
#include clientscripts\mp\zombies\_zm;
#include clientscripts\mp\zombies\_zm_utility;

init()
{
	if ( GetDvar( "createfx" ) == "on" )
	{
		return;
	}
	
	if ( !clientscripts\mp\zombies\_zm_weapons::is_weapon_included( "zombie_black_hole_bomb" ) )
	{
		return;
	}
	
	// ww: black hole bomb effect
	level._effect[ "black_hole_bomb_portal" ]						= LoadFX( "maps/zombie/fx_zmb_blackhole_looping" );
	level._effect[ "black_hole_bomb_event_horizon" ] 		= LoadFX( "maps/zombie/fx_zmb_blackhole_implode" );
	level._effect[ "black_hole_bomb_marker_flare" ] 		= LoadFX( "maps/zombie/fx_zmb_blackhole_flare_marker" );
	level._effect[ "black_hole_bomb_zombie_pull" ]			= LoadFX( "maps/zombie/fx_blackhole_zombie_breakup" );
	
	// init vision set array
	level._current_black_hole_bombs = [];
	
	level._visionset_black_hole_bomb = "zombie_black_hole";
	level._visionset_black_hole_bomb_transition_time_in = 2.0;
	level._visionset_black_hole_bomb_transition_time_out = 1.0;
	level._visionset_black_hole_bomb_priority = 10;

	level._SCRIPTMOVER_CLIENT_FLAG_BLACKHOLE = 10;
	register_clientflag_callback( "scriptmover", level._SCRIPTMOVER_CLIENT_FLAG_BLACKHOLE, ::black_hole_deployed );
	
	level._ACTOR_CLIENT_FLAG_BLACKHOLE = 10;
	register_clientflag_callback( "actor", level._ACTOR_CLIENT_FLAG_BLACKHOLE, ::black_hole_zombie_being_pulled );
	
	level thread player_init();

	// start the black hole bomb visionset mangaer
	level thread black_hole_visionset_think();
}


player_init()
{
	waitforclient( 0 );

	players = level.localPlayers;
	for( i = 0 ; i < players.size; i++ )
	{
		// set the parameters for checking black hole dist
		players[i]._curr_black_hole_dist = 100000*100000;
		players[i]._last_black_hole_dist = 100000*100000;
		
		// ww: start the black hole vision set manager
		// players[i] thread black_hole_visionset_think( i );
	}

}


// self is the black hole bomb that was just thrown
black_hole_deployed( local_client_num, int_set, ent_new )
{
	if( local_client_num != 0 )
	{
		return;
	}
	
	// the array index number will be the local_client_num
	players = GetLocalPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		// thread off the fx functions
		level thread black_hole_fx_start( i, self );
		
		// vision set stuff
		level thread black_hole_activated( self, i );
	}
	
	
	/*
	if( int_set )
	{
		// thread off the fx functions
		level thread black_hole_fx_start( local_client_num, self );
		
		// special sound stuff can go here also
		
		// vision set stuff
		level thread black_hole_activated( self, local_client_num );
	}
	*/
}

// plays the black hole fx for the bomb
black_hole_fx_start( local_client_num, ent_bomb )
{
	//self endon( "entityshutdown" );
	bomb_fx_spot = Spawn( local_client_num, ent_bomb.origin, "script_model" );
	bomb_fx_spot SetModel( "tag_origin" );

	// the client number was passed in from black_hole_deployed
	PlayFXOnTag( local_client_num, level._effect[ "black_hole_bomb_portal" ], bomb_fx_spot, "tag_origin" );
	PlayFXOnTag( local_client_num, level._effect[ "black_hole_bomb_marker_flare" ], bomb_fx_spot, "tag_origin" );
	
	ent_bomb waittill( "entityshutdown" );
	
	event_horizon_spot = Spawn( local_client_num, bomb_fx_spot.origin, "script_model" );
	event_horizon_spot SetModel( "tag_origin" );
	bomb_fx_spot Delete();
	PlayFXOnTag( local_client_num, level._effect[ "black_hole_bomb_event_horizon" ], event_horizon_spot, "tag_origin" );
	
	wait( 0.2 );
	
	event_horizon_spot Delete();
}



// switch blackhole vision set
black_hole_visionset_switch( str_switch, flt_transition_time, int_local_client_num )
{
	self endon( "disconnect" );
	self endon( "death" );
	
	if( !IsDefined( flt_transition_time ) )
	{
		flt_transition_time = 2.0;
	}
	
	switch( str_switch )
	{
		case "inside_bh":

			if ( IsSpectating( self GetLocalClientNumber(), false ) ) // if in spectator mode don't take on the vision set otherwise it will not clear
			{
				return;
			}

			self zombie_vision_set_apply( level._visionset_black_hole_bomb, level._visionset_black_hole_bomb_priority, level._visionset_black_hole_bomb_transition_time_in, int_local_client_num );

		break;
		
		case "outside_bh":	

			self zombie_vision_set_remove( level._visionset_black_hole_bomb, level._visionset_black_hole_bomb_transition_time_in, int_local_client_num );

		break;
		
		default:

			self zombie_vision_set_remove( undefined, level._visionset_black_hole_bomb_transition_time_out, int_local_client_num );

		break;
	}

}

// black hole watcher
black_hole_visionset_think()
{
	//self endon( "disconnect" );
	//self endon( "death" );
	
	flt_black_hole_vision_transition_time = 0;
	min_black_hole_dist = 512*512;
	self._visionset_think_running = 1;
	temp_array = [];
	
	while( IsDefined( level._current_black_hole_bombs ) )
	{
		players = GetLocalPlayers();
		
		for( i = 0; i < players.size; i++ )
		{
			// reset the current distance at the beginning of each loop
			players[i]._curr_black_hole_dist = 100000*100000;
		}
		
		// reset the current distance at the beginning of each loop
		self._curr_black_hole_dist = 100000*100000;
		
		if( level._current_black_hole_bombs.size == 0 )
		{
			players = GetLocalPlayers();
			
			for( i = 0; i < players.size; i++ )
			{
				// there are no present black hole bombs so there is no reason to change them
				players[i] black_hole_visionset_switch( "default", 2.0, i );
			}

		}
		else
		{
			players = GetLocalPlayers();
			
			for( i = 0; i < players.size; i++ ) // the i will be the client number
			{
				// get the closest black hole
				struct_closest_black_hole = players[i] get_closest_black_hole();
				
				// check the distance and set the correct visionset
				players[i] black_hole_vision_set( min_black_hole_dist, flt_black_hole_vision_transition_time, struct_closest_black_hole, i );
				
				// save the current distance as the last distance
				players[i]._last_black_hole_dist = players[i]._curr_black_hole_dist;
			}
			
		}
		
		temp_array = level._current_black_hole_bombs;
		
		for( i = 0; i < temp_array.size; i++ )
		{
			// check to see if the index spot is still valid
			if( IsDefined( temp_array[i]._black_hole_active ) && temp_array[i]._black_hole_active == 0 )
			{
				level._current_black_hole_bombs = array_remove( level._current_black_hole_bombs, temp_array[i] );
			}
		}
		
		/*
		// check the array for anything that is _black_hole_bomb = 0;
		for( i = 0; i < level._current_black_hole_bombs.size; i++ )
		{
			if( level._current_black_hole_bombs[i]._black_hole_active == 0 )
			{
				// remove it from the array and undefine it
				temp_spot = level._current_black_hole_bombs[i];
				level._current_black_hole_bombs = array_remove( level._current_black_hole_bombs, temp_spot );
				temp_spot = undefined;
			}
		}
		*/
		
		// wait before looping
		wait( 0.1 );
		temp_array = [];
	}
	
	// function ends
}

// ww: go through the all the black holes and return the one closest to the player
get_closest_black_hole()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	struct_closest_black_hole = undefined;
	
	// find out which black hole it the closest
	for( i = 0; i < level._current_black_hole_bombs.size; i++ )
	{
		curr_dist = DistanceSquared( level._current_black_hole_bombs[i].origin, self.origin );
		
		if( curr_dist < self._curr_black_hole_dist )
		{
			// save the closest one to the player's parameter
			self._curr_black_hole_dist = curr_dist;
			struct_closest_black_hole = level._current_black_hole_bombs[i];
		}
	}
	
	// after ending the player should have the closest distance
	return struct_closest_black_hole;
}

// ww: applies the black hole vision set based on the distance set
black_hole_vision_set( min_black_hole_dist, flt_transition_time, struct_closest_black_hole, int_local_client_num )
{
	self endon( "disconnect" );
	self endon( "death" );
	
	// apply the current distance to black holes to set_dist
	set_dist = self._curr_black_hole_dist;
	
	// inside the influence?
	if( set_dist < min_black_hole_dist  )
	{
		// inside influence but do you have a direct line?
		trace = bullettrace( self GetEye(), struct_closest_black_hole.origin, false, self );
		// not only should the trace pass but the struct still needs to be valid
		if( trace["fraction"] > 0.85 && struct_closest_black_hole._black_hole_active == 1 ) 
		{
			self black_hole_visionset_switch( "inside_bh", flt_transition_time, int_local_client_num );
		}
		else // no direct line then the player is not switched to the visionset
		{
			self black_hole_visionset_switch( "outside_bh", flt_transition_time, int_local_client_num );
		}
		
	}
	else if( set_dist > min_black_hole_dist )
	{
		self black_hole_visionset_switch( "outside_bh", flt_transition_time, int_local_client_num );
	}
}

// registers a new black hole to the array
black_hole_activated( ent_model, int_local_client_num )
{
	// make a struct to store the information on the new black hole bomb
	new_black_hole_struct = SpawnStruct();
	
	// anything that needs to be saved gets moved to the struct here
	new_black_hole_struct.origin = ent_model.origin;
	new_black_hole_struct._black_hole_active = 1;
	
	// add the struct to the array that checks for setting the visionset
	level._current_black_hole_bombs = add_to_array( level._cosmodrome_black_hole_bombs, new_black_hole_struct );
	
	// the model is no longer present, black hole in this area is done
	ent_model waittill( "entityshutdown" );
	
	// remove the struct from the array so the vision sets will be disabled
	// level._cosmodrome_black_hole_bombs = array_remove( level._current_black_hole_bombs, new_black_hole_struct );
	new_black_hole_struct._black_hole_active = 0;
	
	wait( 0.2 );
}

// plays an effect on the zombie being pulled in by the black hole
black_hole_zombie_being_pulled( local_client_num, int_set, actor_new )
{
	self endon( "death" );
	self endon( "entityshutdown" );
	
	if( local_client_num != 0 )
	{
		return;
	}
	
	if( int_set )
	{
		self._bhb_pulled_in_fx = Spawn( local_client_num, self.origin, "script_model" );
		self._bhb_pulled_in_fx.angles = self.angles;
		self._bhb_pulled_in_fx LinkTo( self, "tag_origin" );
		self._bhb_pulled_in_fx SetModel( "tag_origin" );
		
		level thread black_hole_bomb_pulled_in_fx_clean( self, self._bhb_pulled_in_fx );
		
		players = GetLocalPlayers();
		for( i = 0; i < players.size; i++ )
		{
			PlayFXOnTag( i, level._effect[ "black_hole_bomb_zombie_pull" ], self._bhb_pulled_in_fx, "tag_origin" );
		}
	}
	else
	{
		if( IsDefined( self._bhb_pulled_in_fx ) )
		{
			// DeleteFX( local_client_num, self._bhb_pulled_in_fx );
			self._bhb_pulled_in_fx notify( "no_clean_up_needed" );
			self._bhb_pulled_in_fx Unlink();
			self._bhb_pulled_in_fx Delete();
		}
	}
}

// clean up on the model playing the effect
black_hole_bomb_pulled_in_fx_clean( ent_zombie, ent_fx_origin )
{
	ent_fx_origin endon( "no_clean_up_needed" );
	
	if( !IsDefined( ent_zombie ) )
	{
		return;
	}
	
	ent_zombie waittill( "entityshutdown" );
	
	if( IsDefined( ent_fx_origin ) )
	{
		ent_fx_origin Delete();	
	}
	
	
}