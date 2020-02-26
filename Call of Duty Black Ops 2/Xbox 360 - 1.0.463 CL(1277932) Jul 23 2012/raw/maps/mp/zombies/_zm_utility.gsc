#include maps\mp\_utility;
#include common_scripts\utility; 


#insert raw\common_scripts\utility.gsh;
#insert raw\maps\mp\zombies\_zm_utility.gsh;


init_utility()
{
//	level thread edge_fog_start(); 

//	level thread hudelem_count(); 
}

is_Classic()
{
	var = GetDvar( "ui_zm_gamemodegroup" );
	
	if ( var == "zclassic" )
	{
		return true;
	}
	
	return false;
}

is_Standard()
{
	var = GetDvar( "ui_gametype" );
	
	if ( var == "zstandard" )
	{
		return true;
	}
	
	return false;
}


ConvertSecondsToMilliseconds( seconds )
{
	return ( seconds * 1000 );
}

is_player()
{
	return ( IsPlayer( self ) || ( IsDefined( self.pers ) && is_true( self.pers[ "isBot" ] ) ) );
}

// self is Ai and chunk is selected piece
lerp( chunk )
{
	// anim_reach_aligned
	link = Spawn( "script_origin", self GetOrigin() ); // link is a new origin of the ai
	link.angles = self.first_node.angles ; // link now has the angles of itself, perhaps these angles aren't coming over..
	self LinkTo(link); // link ai + origin to chunk + origin

	// link RotateTo(chunk.origin GetTagAngles("Tag_bottom"), level._CONTEXTUAL_GRAB_LERP_TIME); // this should angle him to spot
	// link MoveTo(chunk.origin GetTagOrigin("Tag_bottom"), level._CONTEXTUAL_GRAB_LERP_TIME); // this should move him over to spot
	
	// I need to have the offest for the bar
	link RotateTo(self.first_node.angles , level._CONTEXTUAL_GRAB_LERP_TIME); // this should angle him to spot

	link MoveTo(self.attacking_spot , level._CONTEXTUAL_GRAB_LERP_TIME); // this should move him over to spot
	//link RotateTo(self GetTagAngles ("Tag_player"), level._CONTEXTUAL_GRAB_LERP_TIME); // this should angle him to spot
	//link MoveTo(self GetTagOrigin ("Tag_player"), level._CONTEXTUAL_GRAB_LERP_TIME); // this should move him over to spot
	
	link waittill_multiple("rotatedone", "movedone");

	self Unlink();
	link Delete();
	
	return;
}

// DCS 091610: delete any designated mature blood patches if set to mature.
clear_mature_blood()
{
	blood_patch = GetEntArray("mature_blood", "targetname");
	
	if(IsDefined(blood_patch) && !is_mature())
	{
		for (i = 0; i < blood_patch.size; i++)
		{
			blood_patch[i] Delete();
		}	
	}
}	

get_enemy_count()
{
	enemies = [];
	valid_enemies = [];
	enemies = GetAiSpeciesArray( "axis", "all" );

	for( i = 0; i < enemies.size; i++ )
	{
		if ( is_true( enemies[i].ignore_enemy_count ) )
		{
			continue;
		}

		if( isDefined( enemies[i].animname ) )
		{
			ARRAY_ADD( valid_enemies, enemies[i] );
		}
	}
	return valid_enemies.size;
}


get_round_enemy_array()
{
	enemies = [];
	valid_enemies = [];
	enemies = GetAiSpeciesArray( "axis", "all" );

	for( i = 0; i < enemies.size; i++ )
	{
		if ( is_true( enemies[i].ignore_enemy_count ) )
		{
			continue;
		}

		if( isDefined( enemies[i].animname ) )
		{
			ARRAY_ADD( valid_enemies, enemies[i] );
		}
	}
	return valid_enemies;
}


set_zombie_run_cycle( new_move_speed )
{
	self.zombie_move_speed_original = self.zombie_move_speed;

	if ( isDefined( new_move_speed ) )
	{
		self.zombie_move_speed = new_move_speed;
	}
	else
	{
		self set_run_speed();
	}

	self.needs_run_update = true;

	self.deathanim = self maps\mp\animscripts\zm_utility::append_missing_legs_suffix( "zm_death" );
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


spawn_zombie( spawner,target_name,spawn_point,round_number) 
{ 
	if( !isdefined( spawner ) )
	{
	/#	println( "ZM >> spawn_zombie - NO SPAWNER DEFINED" );	#/
		return undefined; 
	}
	
	spawner.script_moveoverride = true; 

	if( IsDefined( spawner.script_forcespawn ) && spawner.script_forcespawn ) 
	{  
		guy = spawner spawnactor();
		guy EnableAimAssist();		
		
		if(isDefined(round_number))
		{
			guy._starting_round_number = round_number;
		}
				
		//guy.type = "zombie";
		guy.aiteam = "axis";
		guy ClearEntityOwner();
		level.zombieMeleePlayerCounter = 0;

		guy thread run_spawn_functions();

		guy forceteleport( spawner.origin );
		guy show();
			 
	} 

	spawner.count = 666; 

//	// sometimes we want to ensure a zombie will go to a particular door node
//	// so we target the spawner at a struct and put the struct near the entry point
//	if( isdefined( spawner.target ) )
//	{
//		guy.forced_entry = getstruct( spawner.target, "targetname" ); 
//	}

	if( !spawn_failed( guy ) ) 
	{ 
		if( IsDefined( target_name ) ) 
		{ 
			guy.targetname = target_name; 
		} 
		return guy;  
	}
	return undefined;  
}


run_spawn_functions()
{
	self endon( "death" );

 	waittillframeend;	// spawn functions should override default settings, so they need to be last

	for (i = 0; i < level.spawn_funcs[ self.team ].size; i++)
	{
		func = level.spawn_funcs[ self.team ][ i ];
		single_thread(self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ], func[ "param5" ] );
	}

	if ( IsDefined( self.spawn_funcs ))
	{
		for (i = 0; i < self.spawn_funcs.size; i++)
		{
			func = self.spawn_funcs[ i ];
			single_thread(self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ] );
		}

		/#
			self.saved_spawn_functions = self.spawn_funcs;
		#/

		self.spawn_funcs = undefined;

		/#
			// keep them around in developer mode, for debugging
			self.spawn_funcs = self.saved_spawn_functions;
			self.saved_spawn_functions = undefined;
		#/

		self.spawn_funcs = undefined;
	}
}


create_simple_hud( client )
{
	if( IsDefined( client ) )
	{
		hud = NewClientHudElem( client ); 
	}
	else
	{
		hud = NewHudElem(); 
	}

	level.hudelem_count++; 

	hud.foreground = true; 
	hud.sort = 1; 
	hud.hidewheninmenu = false; 

	return hud; 
}

destroy_hud()
{
	level.hudelem_count--; 
	self Destroy(); 
}


// self = exterior_goal which is barrier_chunks
all_chunks_intact( barrier, barrier_chunks )
{
	if(isdefined(barrier.zbarrier))
	{
		pieces = barrier.zbarrier GetZBarrierPieceIndicesInState("closed");
		
		if(pieces.size != barrier.zbarrier GetNumZBarrierPieces())
		{
			return false;
		}
	}
	else
	{
		for( i = 0; i < barrier_chunks.size; i++ ) // Count up barrier_chunks total size
		{
			if( barrier_chunks[i] get_chunk_state() != "repaired" ) // if any piece has the state of not repaired then return false
			{
				return false; 
			}
		}
	}
	
	return true; // if the board has been repaired then return true 
}


// self = exterior_goal which is barrier_chunks
no_valid_repairable_boards( barrier, barrier_chunks )
{

	if(isdefined(barrier.zbarrier))
	{
		pieces = barrier.zbarrier GetZBarrierPieceIndicesInState("open");
		
		if(pieces.size)
		{
			return false;
		}
	}
	else
	{
		for( i = 0; i < barrier_chunks.size; i++ ) // Count up barrier_chunks total size
		{
			if( barrier_chunks[i] get_chunk_state() == "destroyed" ) // if any piece has been destroyed return false
			{
				return false; 
			}
		}
	}
	
	return true; // if any piece is not destroyed then return true
}

is_Survival()
{
	var = GetDvar( "ui_zm_gamemodegroup" );
	if(var == "zsurvival")
	{
		return true;
	}
	
	return false;
}

is_Encounter()
{
	if(is_true(level._is_encounter))
	{
		return true;
	}
	var = GetDvar( "ui_zm_gamemodegroup" );
	if(var == "zencounter")
	{
		level._is_encounter = true;
		return true;
	}	
	
	return false;
}

all_chunks_destroyed( barrier, barrier_chunks )
{
	if(isdefined(barrier.zbarrier))
	{
		pieces = ArrayCombine(barrier.zbarrier GetZBarrierPieceIndicesInState("open"), barrier.zbarrier GetZBarrierPieceIndicesInState("opening"), true, false);
		
		if(pieces.size !=  barrier.zbarrier GetNumZBarrierPieces())
		{
			return false;
		}
	}
	else if( IsDefined( barrier_chunks ) )
	{
		ASSERT( IsDefined(barrier_chunks), "_zm_utility::all_chunks_destroyed - Barrier chunks undefined" );
		for( i = 0; i < barrier_chunks.size; i++ )
		{
			if( barrier_chunks[i] get_chunk_state() != "destroyed" )
			{
				return false; 
			}
		}
	}
	return true; 
}

check_point_in_playable_area( origin )
{
	playable_area = getentarray("player_volume","script_noteworthy");
	check_model = spawn ("script_model", origin + (0,0,40));
	
	valid_point = false;
	for (i = 0; i < playable_area.size; i++)
	{
		if (check_model istouching(playable_area[i]))
		{
			valid_point = true;
		}
	}
	
	check_model delete();
	return valid_point;
}

check_point_in_active_zone( origin )
{
	player_zones = getentarray("player_volume","script_noteworthy");
	if( !isDefined( level.zones ) || !isDefined( player_zones ) )
	{
		return true;
	}
	
	scr_org = spawn( "script_origin", origin+(0, 0, 40) );
	
	one_valid_zone = false;
	for( i = 0; i < player_zones.size; i++ )
	{
		if( scr_org isTouching( player_zones[i] ) )
		{
			if( isDefined( level.zones[player_zones[i].targetname] ) && 
				is_true( level.zones[player_zones[i].targetname].is_enabled ) )
			{
				one_valid_zone = true;
			}
		}
	}
	
	scr_org delete();
	return one_valid_zone;
}

round_up_to_ten( score )
{
	new_score = score - score % 10; 
	if( new_score < score )
	{
		new_score += 10; 
	}
	return new_score; 
}

round_up_score( score, value )
{
	score = int(score);	// Make sure it's an int or modulus will die

	new_score = score - score % value; 
	if( new_score < score )
	{
		new_score += value; 
	}
	return new_score; 
}

random_tan()
{
	rand = randomint( 100 ); 
	
	// PI_CHANGE_BEGIN - JMA - only 15% chance that we are going to spawn charred zombies in sumpf
	if(isDefined(level.char_percent_override) )
	{
		percentNotCharred = level.char_percent_override;
	}
	else
	{
		percentNotCharred = 65;
	}
	
// 	if( rand > percentNotCharred )
// 	{
// 		self StartTanning(); 
// 	}
	// PI_CHANGE_END
}

// Returns the amount of places before the decimal, ie 1000 = 4, 100 = 3...
places_before_decimal( num )
{
	abs_num = abs( num ); 
	count = 0; 
	while( 1 )
	{
		abs_num *= 0.1; // Really doing num / 10
		count += 1; 

		if( abs_num < 1 )
		{
			return count; 
		}
	}
}

create_zombie_point_of_interest( attract_dist, num_attractors, added_poi_value, start_turned_on, initial_attract_func, arrival_attract_func,poi_team )
{
	if( !isDefined( added_poi_value ) )
	{
		self.added_poi_value = 0;
	}
	else
	{
		self.added_poi_value = added_poi_value;
	}
	
	if( !isDefined( start_turned_on ) )
	{
		start_turned_on = true;
	}
	
	self.script_noteworthy = "zombie_poi";
	self.poi_active = start_turned_on;

	if( isDefined( attract_dist ) )
	{
		self.poi_radius = attract_dist * attract_dist;
	}
	else // This poi has no maximum attract distance, it will attract all zombies
	{
		self.poi_radius = undefined;
	}
	self.num_poi_attracts = num_attractors;
	self.attract_to_origin = true;
	self.attractor_array = [];
	self.initial_attract_func = undefined;
	self.arrival_attract_func = undefined;
	if(isDefined(poi_team))
	{
		self._team = poi_team;
	}
	
	// any special functions for initial reaction or arrival at the poi are stored here for get_zombie_point_of_intrest
	if( IsDefined( initial_attract_func ) )
	{
		self.initial_attract_func = initial_attract_func;
	}
	
	if( IsDefined( arrival_attract_func ) )
	{
		self.arrival_attract_func = arrival_attract_func;
	}
	
}

create_zombie_point_of_interest_attractor_positions( num_attract_dists, diff_per_dist, attractor_width )
{
	self endon( "death" );

	forward = ( 0, 1, 0 );
	
	if( !isDefined( self.num_poi_attracts ) || (isDefined(self.script_noteworthy) && self.script_noteworthy != "zombie_poi" ))
	{
		return;
	}
	
	if( !isDefined( num_attract_dists ) )
	{
		num_attract_dists = 4;
	}
	
	if( !isDefined( diff_per_dist ) )
	{
		diff_per_dist = 45;
	}
	
	if( !isDefined( attractor_width ) )
	{
		attractor_width = 45;
	}
	
	self.attract_to_origin = false;
	
	self.num_attract_dists = num_attract_dists;
	
	// The last index in the attractor_position arrays for each of the four distances
	self.last_index = [];
	for( i = 0; i < num_attract_dists; i++ )
	{
		self.last_index[i] = -1;
	}
	
	self.attract_dists = [];
	for( i = 0; i < self.num_attract_dists; i++ )
	{
		self.attract_dists[i] = diff_per_dist * (i+1);
	}
	
	// Array of max positions per distance
	// 0 = close, 1 = med, 2 = far, 3 = very far
	max_positions = [];
	for( i = 0; i < self.num_attract_dists; i++ )
	{
		max_positions[i] = int(3.14*2*self.attract_dists[i]/attractor_width);
	}
	
	num_attracts_per_dist = self.num_poi_attracts/self.num_attract_dists;
	
	self.max_attractor_dist = self.attract_dists[ self.attract_dists.size - 1 ] * 1.1; // Give some wiggle room for assigning nodes
	
	diff = 0;
	
	//self thread debug_draw_attractor_positions();
	
	// Determine the ideal number of attracts based on what a distance can actually hold after any bleed from closer
	// distances is added to the calculated
	actual_num_positions = [];
	for( i = 0; i < self.num_attract_dists; i++ )
	{
		if( num_attracts_per_dist > (max_positions[i]+diff) )
		{
			actual_num_positions[i] = max_positions[i];
			diff += num_attracts_per_dist - max_positions[i];
		}
		else
		{
			actual_num_positions[i] = num_attracts_per_dist + diff;
			diff = 0;
		}	
	}
	
	// Determine the actual positions that will be used, including failed nodes from closer distances, index zero is always the origin
	self.attractor_positions = [];
	failed = 0;
	angle_offset = 0; // Angle offset, used to make nodes not all perfectly radial
	prev_last_index = -1;
	for( j = 0; j < 4; j++ )
	{
		if( (actual_num_positions[j]+failed) < max_positions[j] )
		{
			actual_num_positions[j] += failed;
			failed = 0;
		}
		else if( actual_num_positions[j] < max_positions[j] ) 
		{
			actual_num_positions[j] = max_positions[j];
			failed = max_positions[j] - actual_num_positions[j];
		}
		failed += self generated_radius_attract_positions( forward, angle_offset, actual_num_positions[j], self.attract_dists[j] );
		angle_offset += 15;
		self.last_index[j] = int(actual_num_positions[j] - failed + prev_last_index);
		prev_last_index = self.last_index[j];
	}
	
	self notify( "attractor_positions_generated" );
	level notify( "attractor_positions_generated" );
}

generated_radius_attract_positions( forward, offset, num_positions, attract_radius )
{
	self endon( "death" );

	epsilon = 0.1;
	failed = 0;
	degs_per_pos = 360 / num_positions;
	for( i = offset; i < 360+offset; i += degs_per_pos )
	{
		altforward = forward * attract_radius;
		rotated_forward = ( (cos(i)*altforward[0] - sin(i)*altforward[1]), (sin(i)*altforward[0] + cos(i)*altforward[1]), altforward[2] );
		
		if(isDefined(level.poi_positioning_func))
		{
			pos = [[level.poi_positioning_func]](self.origin, rotated_forward);
		}
		else if(is_true(level.use_alternate_poi_positioning))
		{
			pos = maps\mp\zombies\_zm_server_throttle::server_safe_ground_trace( "poi_trace", 10, self.origin + rotated_forward + ( 0, 0, 10 ) ); //only trace from 10 units above instead of 100 units
		}
		else
		{
			pos = maps\mp\zombies\_zm_server_throttle::server_safe_ground_trace( "poi_trace", 10, self.origin + rotated_forward + ( 0, 0, 100 ) );
		}
		
		if(!isDefined(pos))
		{
			failed++;
			continue;
		}
		
		if(is_true(level.use_alternate_poi_positioning))
		{
			if ( isDefined( self ) && isDefined( self.origin ) )
			{
				if( self.origin[2] >= (pos[2]-epsilon) && self.origin[2] - pos[2] <= 150 )
				{
					pos_array = [];
					pos_array[0] = pos;
					pos_array[1] = self;
					ARRAY_ADD( self.attractor_positions , pos_array );
				}
			}
			else
			{
				failed++;
			}
		}
		else if(abs( pos[2] - self.origin[2] ) < 60 )
		{
			pos_array = [];
			pos_array[0] = pos;
			pos_array[1] = self;
			ARRAY_ADD( self.attractor_positions , pos_array );
		}
		else
		{
			failed++;
		}
	}
	return failed;
}

debug_draw_attractor_positions()
{
	/#
	while( true )
	{
		while( !isDefined( self.attractor_positions ) )
		{
			wait( 0.05 );
			continue;
		}
		for( i = 0; i < self.attractor_positions.size; i++ )
		{
			Line( self.origin, self.attractor_positions[i][0], (1, 0, 0), true, 1 );
		}
		wait( 0.05 );
		if( !IsDefined( self ) )
		{
			return;
		}
	}
	#/
}


get_zombie_point_of_interest( origin )
{
	if ( is_true( self.ignore_all_poi ) )
	{
		return undefined;
	}

	curr_radius = undefined;
	
	ent_array = getEntArray( "zombie_poi", "script_noteworthy" );
	
	best_poi = undefined;
	position = undefined;
	best_dist = 10000 * 10000;
	
	for( i = 0; i < ent_array.size; i++ )
	{
		if( !isDefined( ent_array[i].poi_active ) || !ent_array[i].poi_active  )
		{
			continue;
		}

		if ( isDefined( self.ignore_poi_targetname ) && self.ignore_poi_targetname.size > 0 )
		{
			if ( isDefined( ent_array[i].targetname ) )
			{
				ignore = false;
				for ( j = 0; j < self.ignore_poi_targetname.size; j++ )
				{
					if ( ent_array[i].targetname == self.ignore_poi_targetname[j] )
					{
						ignore = true;
						break;
					}
				}
				if ( ignore )
				{
					continue;
				}
			}
		}

		if ( isDefined( self.ignore_poi ) && self.ignore_poi.size > 0 )
		{
			ignore = false;
			for ( j = 0; j < self.ignore_poi.size; j++ )
			{
				if ( self.ignore_poi[j] == ent_array[i] )
				{
					ignore = true;
					break;
				}
			}
			if ( ignore )
			{
				continue;
			}
		}
		
		dist = distanceSquared( origin, ent_array[i].origin );
		
		dist -= ent_array[i].added_poi_value;
		
		if( isDefined( ent_array[i].poi_radius ) )
		{
			curr_radius = ent_array[i].poi_radius;
		}
		
		if( (!isDefined( curr_radius ) || dist < curr_radius) && dist < best_dist && ent_array[i] can_attract(self) )
		{
			best_poi = ent_array[i];
			best_dist = dist;
		}
	}
	
	if( isDefined( best_poi ) )
	{
		if(isDefined(best_poi._team))
		{
			if(isDefined(self._race_team) && self._race_team != best_poi._team)
			{
				return undefined;
			}
		}
		if( is_true( best_poi._new_ground_trace ) ) // needed for the bhb so it won't trace through metal clip
		{
			position = [];
			position[0] = groundpos_ignore_water_new( best_poi.origin + (0, 0, 100) );
			position[1] = self;
		}
		else if( isDefined( best_poi.attract_to_origin ) && best_poi.attract_to_origin ) // Override, currently only used for monkeys in the air.
		{
			position = [];
			position[0] = groundpos( best_poi.origin + (0, 0, 100) );
			position[1] = self;
		}
		else
		{
			position = self add_poi_attractor( best_poi );
		}
		
		if( IsDefined( best_poi.initial_attract_func ) )
		{
			self thread [[ best_poi.initial_attract_func ]]( best_poi );
		}
		
		if( IsDefined( best_poi.arrival_attract_func ) )
		{
			self thread [[ best_poi.arrival_attract_func ]]( best_poi );
		}
	}
	
	return position;
}

activate_zombie_point_of_interest()
{
	if( self.script_noteworthy != "zombie_poi" )
	{
		return;
	}
	
	self.poi_active = true;
}

deactivate_zombie_point_of_interest()
{
	if( self.script_noteworthy != "zombie_poi" )
	{
		return;
	}

	for( i = 0; i < self.attractor_array.size; i++ )
	{
		self.attractor_array[i] notify( "kill_poi" );
	}

	self.attractor_array = [];
	self.claimed_attractor_positions = [];
	
	self.poi_active = false;
}

//PI_CHANGE_BEGIN - 6/18/09 JV This works to help set "wait" points near the stage if all players are in the process teleportation.  
//It is unlike the previous function in that you dictate the poi.
assign_zombie_point_of_interest (origin, poi)
{
	position = undefined;
	doremovalthread = false;

	if (IsDefined(poi) && poi can_attract(self))
	{
		//don't want to touch add poi attractor, but yeah, this is kind of weird
		if (!IsDefined(poi.attractor_array) || ( IsDefined(poi.attractor_array) && array_check_for_dupes( poi.attractor_array, self ) ))
			doremovalthread = true;
		
		position = self add_poi_attractor( poi );
		
		//now that I know this is the first time they've been added, set up the thread to remove them from the array
		if (IsDefined(position) && doremovalthread && !array_check_for_dupes( poi.attractor_array, self  ))
			self thread update_on_poi_removal( poi );		
	}
	
	return position;
}
//PI_CHANGE_END

remove_poi_attractor( zombie_poi )
{
	if( !isDefined( zombie_poi.attractor_array ) )
	{
		return;
	}
	
	for( i = 0; i < zombie_poi.attractor_array.size; i++ )
	{
		if( zombie_poi.attractor_array[i] == self )
		{
			self notify( "kill_poi" );
			
			ArrayRemoveValue( zombie_poi.attractor_array, zombie_poi.attractor_array[i] );
			ArrayRemoveValue( zombie_poi.claimed_attractor_positions, zombie_poi.claimed_attractor_positions[i] );
		}
	}
}

array_check_for_dupes_using_compare( array, single, is_equal_fn )
{
	for( i = 0; i < array.size; i++ )
	{
		if( [[is_equal_fn]]( array[i], single ) )
		{
			return false;
		}
	}

	return true;
}

poi_locations_equal( loc1, loc2 )
{
	return loc1[0]==loc2[0];
}


add_poi_attractor( zombie_poi )
{
	if( !isDefined( zombie_poi ) )
	{
		return;
	}
	if( !isDefined( zombie_poi.attractor_array ) )
	{
		zombie_poi.attractor_array = [];
	}
	
	// If we are not yet an attractor to this poi, claim an attractor position and start attracting to it
	if( array_check_for_dupes( zombie_poi.attractor_array, self ) )
	{
		if( !isDefined( zombie_poi.claimed_attractor_positions ) )
		{
			zombie_poi.claimed_attractor_positions = [];
		}
		
		if( !isDefined( zombie_poi.attractor_positions ) || zombie_poi.attractor_positions.size <= 0 )
		{
			return undefined;
		}
		
		start = -1;
		end = -1;
		last_index = -1;
		for( i = 0; i < 4; i++ )
		{
			if( zombie_poi.claimed_attractor_positions.size < zombie_poi.last_index[i] ) 
			{
				start = last_index+1;
				end = zombie_poi.last_index[i];
				break;
			}
			last_index = zombie_poi.last_index[i];
		}
		
		
		best_dist = 10000*10000;
		best_pos = undefined;
		if( start < 0 )
		{
			start = 0;
		}
		if( end < 0 )
		{
			return undefined;
		}
		for( i = int(start); i <= int(end); i++ )
		{
			if(!isDefined(zombie_poi.attractor_positions[i]))
			{
				continue;
			}
			//if( array_check_for_dupes( zombie_poi.claimed_attractor_positions, zombie_poi.attractor_positions[i] ) )
			if( array_check_for_dupes_using_compare( zombie_poi.claimed_attractor_positions, zombie_poi.attractor_positions[i], ::poi_locations_equal ) )
			{

				if ( isDefined( zombie_poi.attractor_positions[i][0] ) && isDefined( self.origin ) )
				{
					dist = distancesquared( zombie_poi.attractor_positions[i][0], self.origin );
					if( dist < best_dist || !isDefined( best_pos ) )
					{
						best_dist = dist;
						best_pos = zombie_poi.attractor_positions[i];
					}
				}
			}
		}
		
		if( !isDefined( best_pos ) )
		{
			return undefined;
		}
		
		ARRAY_ADD( zombie_poi.attractor_array, self );
		self thread update_poi_on_death( zombie_poi );		
		
		ARRAY_ADD( zombie_poi.claimed_attractor_positions, best_pos );
		
		return best_pos;
	}
	else
	{
		for( i = 0; i < zombie_poi.attractor_array.size; i++ )
		{
			if( zombie_poi.attractor_array[i] == self )
			{
				if( isDefined( zombie_poi.claimed_attractor_positions ) && isDefined( zombie_poi.claimed_attractor_positions[i] ) )
				{
					return zombie_poi.claimed_attractor_positions[i];
				}
			}
		}
	}
	
	return undefined;
}

can_attract( attractor )
{
	if( !isDefined( self.attractor_array ) )
	{
		self.attractor_array = [];
	}
	//Raven Begin - Allow only selected zombies to be attracted
	if( isDefined(self.attracted_array) && !IsInArray(self.attracted_array, attractor) )
	{
		return false;
	}
	//Raven End
	if( !array_check_for_dupes( self.attractor_array, attractor ) )
	{
		return true;
	}
	if( isDefined(self.num_poi_attracts) && self.attractor_array.size >= self.num_poi_attracts )
	{
		return false;
	}

	return true;
}

update_poi_on_death( zombie_poi )
{
	self endon( "kill_poi" );
	
	self waittill( "death" );
	self remove_poi_attractor( zombie_poi );
}

//PI_CHANGE_BEGIN - 6/18/09 JV This was set up to work with assign_zombie_point_of_interest (which works with the teleportation in theater).
//The poi attractor array needs to be emptied when a player is teleported out of projection room (if they were all in there).  
//As a result, we wait for the poi's death (I'm sending that notify via the level script)
update_on_poi_removal (zombie_poi )
{	
	zombie_poi waittill( "death" );
	
	if( !isDefined( zombie_poi.attractor_array ) )
		return;
	
	for( i = 0; i < zombie_poi.attractor_array.size; i++ )
	{
		if( zombie_poi.attractor_array[i] == self )
		{	
			ArrayRemoveIndex( zombie_poi.attractor_array, i );
			ArrayRemoveIndex( zombie_poi.claimed_attractor_positions, i );
		}
	}
	
}
//PI_CHANGE_END

invalidate_attractor_pos( attractor_pos, zombie )
{
	if( !isDefined( self ) || !isDefined( attractor_pos ) )
	{
		wait( 0.1 );
		return undefined;
	}
	
	if( isDefined( self.attractor_positions) && !array_check_for_dupes_using_compare( self.attractor_positions, attractor_pos, ::poi_locations_equal ) )
	{
		index = 0;
		for( i = 0; i < self.attractor_positions.size; i++ )
		{
			if( poi_locations_equal( self.attractor_positions[i], attractor_pos) )
			{
				index = i;
			}
		}
		
		for( i = 0; i < self.last_index.size; i++ )
		{
			if( index <= self.last_index[i] )
			{
				self.last_index[i]--;
			}
		}
		
		ArrayRemoveValue( self.attractor_array, zombie );
		ArrayRemoveValue( self.attractor_positions, attractor_pos );
		for( i = 0; i < self.claimed_attractor_positions.size; i++ )
		{
			if( self.claimed_attractor_positions[i][0] == attractor_pos[0] )
			{
				ArrayRemoveValue( self.claimed_attractor_positions, self.claimed_attractor_positions[i] );
			}
		}
	}
	else
	{
		wait( 0.1 );
	}
	
	return get_zombie_point_of_interest( zombie.origin );
}

remove_poi_from_ignore_list( poi )
{
	if ( isDefined( self.ignore_poi ) && self.ignore_poi.size > 0 )
	{
		for ( i = 0; i < self.ignore_poi.size; i++ )
		{
			if ( self.ignore_poi[i] == poi )
			{
				ArrayRemoveValue( self.ignore_poi, self.ignore_poi[i] );
				return;
			}
		}
	}
}

add_poi_to_ignore_list( poi )
{
	if ( !isDefined( self.ignore_poi ) )
	{
		self.ignore_poi = [];
	}

	add_poi = true;
	if ( self.ignore_poi.size > 0 )
	{
		for ( i = 0; i < self.ignore_poi.size; i++ )
		{
			if ( self.ignore_poi[i] == poi )
			{
				add_poi = false;
				break;
			}
		}
	}

	if ( add_poi )
	{
		self.ignore_poi[self.ignore_poi.size] = poi;
	}
}

get_path_length_to_enemy( enemy )
{
	//self SetGoalPos( enemy.origin );
	//wait( 0.1 );			
	//path_length = self GetPathLength();
	
	path_length = self CalcPathLength( enemy.origin );
	
	return path_length;
}		

get_closest_player_using_paths( origin, players )
{
	//First check the straight line distances if we are currently tracking someone
// 	if( IsDefined( self.favoriteenemy ) )
// 	{
// 		player = GetClosest( origin, players ); 
// 		if( player == self.favoriteenemy )
// 		{
// 			return player;
// 		}
// 	}
	
	min_length_to_player = 9999999;
	player_to_return = undefined;//players[0];
	for(i = 0; i < players.size; i++ )
	{
		player = players[i];
		length_to_player = get_path_length_to_enemy( player );
		
	//	Print3d(self.origin+(0,0,70+i*20), length_to_player, ( 1, 0.8, 0.5), 1, 1, 1);

		if ( isDefined( level.validate_enemy_path_length ) )
		{
			if ( length_to_player == 0 )
			{
				valid = self thread [[ level.validate_enemy_path_length ]]( player );
				if ( !valid )
				{
					continue;
				}
			}

		}

		if( length_to_player < min_length_to_player )
		{
			min_length_to_player = length_to_player;
			player_to_return = player;
		}
	}
	
	return player_to_return;
}

get_closest_valid_player( origin, ignore_player )
{
	valid_player_found = false; 
	
	players = GET_PLAYERS();	

	if( is_true( level._zombie_using_humangun ) )
	{
		players = ArrayCombine( players, level._zombie_human_array , false, false);
	}
	

	if( IsDefined( ignore_player ) )
	{
		//PI_CHANGE_BEGIN - 7/2/2009 JV Reenabling change 274916 (from DLC3)
		for(i = 0; i < ignore_player.size; i++ )
		{
			ArrayRemoveValue( players, ignore_player[i] );
		}
		//PI_CHANGE_END
	}

	while( !valid_player_found )
	{
		// find the closest player
		if( isdefined( level.closest_player_override ) )
		{
			player = [[ level.closest_player_override ]]( origin, players );
		}
		else if( is_true( level.calc_closest_player_using_paths ) )
		{
			player = get_closest_player_using_paths( origin, players );
		}
		else
		{
			player = GetClosest( origin, players );
		} 

		if( !isdefined( player ) )
		{
			return undefined; 
		}
		
		if( is_true( level._zombie_using_humangun ) && IsAI( player ) )
		{
			return player;
		}
		
		// make sure they're not a zombie or in last stand
		if( !is_player_valid( player, true ) )
		{
			ArrayRemoveValue( players, player ); 
			continue; 
		}
		return player; 
	}
}

is_player_valid( player, checkIgnoreMeFlag )
{
	if( !IsDefined( player ) ) 
	{
		return false; 
	}

	if( !IsAlive( player ) )
	{
		return false; 
	} 

	if( !IsPlayer( player ) )
	{
		return false;
	}

	if( IsDefined(player.is_zombie) && player.is_zombie == true )
	{
		return false; 
	}

	if( player.sessionstate == "spectator" )
	{
		return false; 
	}

	if( player.sessionstate == "intermission" )
	{
		return false; 
	}

	if(  player maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
	{
		return false; 
	}

//T6.5todo	if ( player isnotarget() )
//T6.5todo	{
//T6.5todo		return false;
//T6.5todo	}
	
	//We only want to check this from the zombie attack script
	if( isdefined(checkIgnoreMeFlag) && player.ignoreme )
	{
		//IPrintLnBold(" ignore me ");
		return false;
	}
	
	return true; 
}

get_number_of_valid_players()
{

	players = GET_PLAYERS();
	num_player_valid = 0;
	for( i = 0 ; i < players.size; i++ )
	{
		if( is_player_valid( players[i] ) )
			num_player_valid += 1;
	}

	
	return num_player_valid;



}

in_revive_trigger()
{
	players = level.players;	//GET_PLAYERS();
	for( i = 0; i < players.size; i++ )
	{
		current_player = players[i];

		//if( !IsDefined( current_player )) || !IsAlive( current_player ) ) 
		//{
		//	continue; 
		//}
	
		if( IsDefined( current_player ) && IsDefined( current_player.revivetrigger ) && IsAlive( current_player ) )
		{
			if( self IsTouching( current_player.revivetrigger ) )
			{
				return true;
			}
		}
	}

	return false;
}

get_closest_node( org, nodes )
{
	return getClosest( org, nodes ); 
}

// bars are not damaged pull them off now.
non_destroyed_bar_board_order( origin, chunks )
{
	//bars = getentarray("bar","script_parameters");
	first_bars = []; // first set of 2 bars to be removed
	first_bars1 = []; // Added single check when combined with wood
	first_bars2 = []; // Added single check when combined with wood

	//-------------------------BOARDS----------------------------------------------------------
	// If all boards do the old system
	for( i=0;i<chunks.size;i++ ) // Go through the array 
	{
		if (IsDefined ( chunks[i].script_team ) && ( chunks[i].script_team == "classic_boards" ) )
		{
			if (IsDefined (chunks[i].script_parameters) && (chunks[i].script_parameters == "board") )	
			{	
				return get_closest_2d( origin, chunks );
			}				
			// I need to add a script name team regular boards
			else if (IsDefined ( chunks[i].script_team ) && chunks[i].script_team == "bar_board_variant1" || chunks[i].script_team == "bar_board_variant2" ||
			chunks[i].script_team == "bar_board_variant4" || chunks[i].script_team == "bar_board_variant5" )
			{	
				return undefined;
			}
		}
		// DCS: adding new variable to start with like new condition repaired with boards.
		else if(IsDefined(chunks[i].script_team ) && chunks[i].script_team == "new_barricade")
		{
			if(IsDefined(chunks[i].script_parameters) && (chunks[i].script_parameters == "repair_board" || chunks[i].script_parameters == "barricade_vents"))
			{
				return get_closest_2d( origin, chunks );
			}
		}
	}
	//-------------------------BOARDS----------------------------------------------------------

	//-------------------------BARS------------------------------------------------------------
	for(i=0;i<chunks.size;i++) // Go through the array 
	{
		if ( IsDefined (chunks[i].script_team ) && ( chunks[i].script_team == "6_bars_bent" )  || ( chunks[i].script_team == "6_bars_prestine" ) )
		{
			if (IsDefined (chunks[i].script_parameters) && (chunks[i].script_parameters == "bar") )
			{	
				if(isDefined(chunks[i].script_noteworthy))
				{
					if(chunks[i].script_noteworthy == "4" || chunks[i].script_noteworthy == "6" ) // this two are defined create a new array that just keeps track of them
					{
						first_bars[first_bars.size] = chunks[i]; // In total this should be a size of two
					}
				}
			}
		}
	}
	
	for(i=0;i<first_bars.size;i++) // Jl added second check if there is only peace
	{
		if ( IsDefined (chunks[i].script_team ) && ( chunks[i].script_team == "6_bars_bent" )  || ( chunks[i].script_team == "6_bars_prestine" ) )
		{			
			if (IsDefined (chunks[i].script_parameters) && (chunks[i].script_parameters == "bar") )
			{	
				//send back the first bars that are NOT destroyed
				if( !first_bars[i].destroyed )
				{
					return first_bars[i];
				}
			}
		}
	}
	
	// Grab the remaining bars that are the closest to the ai
	for(i=0;i<chunks.size;i++)
	{
		if ( IsDefined (chunks[i].script_team ) && ( chunks[i].script_team == "6_bars_bent" )  || ( chunks[i].script_team == "6_bars_prestine" ) )
		{	
		
			if (IsDefined (chunks[i].script_parameters) && (chunks[i].script_parameters == "bar") )
			{	
				if( !chunks[i].destroyed )
				{
					return get_closest_2d( origin, chunks );
					//return chunks[i];
				}
			}
		}
	}
	//-------------------------BARS------------------------------------------------------------
}


non_destroyed_grate_order( origin, chunks_grate )
{
	//-------------------------GRATES----------------------------------------------------------
	grate_order = [];
	grate_order1 =[]; // this sets up the order for the grates
	grate_order2 =[]; // this sets up the order for the grates
	grate_order3 =[]; // this sets up the order for the grates
	grate_order4 =[]; // this sets up the order for the grates
	grate_order5 =[]; // this sets up the order for the grates
	grate_order6 =[]; // this sets up the order for the grates

	
	if ( IsDefined ( chunks_grate ) )
	{
		for(i=0;i<chunks_grate.size;i++) // Go through the array 
		{
			if (IsDefined (chunks_grate[i].script_parameters) && (chunks_grate[i].script_parameters == "grate") )
			{	
				//return grate_order[i];
				
				if ( IsDefined ( chunks_grate[i].script_noteworthy ) && ( chunks_grate[i].script_noteworthy == "1" ) )
				{
						grate_order1[grate_order1.size] = chunks_grate[i];
						// send back order here
				}
				if ( IsDefined ( chunks_grate[i].script_noteworthy ) && ( chunks_grate[i].script_noteworthy == "2" ) )
				{
						grate_order2[grate_order2.size] = chunks_grate[i];
							// send back order here
				}
				if ( IsDefined ( chunks_grate[i].script_noteworthy ) && ( chunks_grate[i].script_noteworthy == "3" ) )
				{
						grate_order3[grate_order3.size] = chunks_grate[i];
							// send back order here
				}
				if ( IsDefined ( chunks_grate[i].script_noteworthy ) && ( chunks_grate[i].script_noteworthy == "4" ) )
				{
						grate_order4[grate_order4.size] = chunks_grate[i];
							// send back order here
				}
				if ( IsDefined ( chunks_grate[i].script_noteworthy ) && ( chunks_grate[i].script_noteworthy == "5" ) )
				{
						grate_order5[grate_order5.size] = chunks_grate[i];
							// send back order here
				}
				if ( IsDefined ( chunks_grate[i].script_noteworthy ) && ( chunks_grate[i].script_noteworthy == "6" ) )
				{
						grate_order6[grate_order6.size] = chunks_grate[i];
							// send back order here
				}
			}
		}
		
		
		// I need to make this function also tell which piece to move again.
		for(i=0;i<chunks_grate.size;i++) // Go through the array 
		{
			if (IsDefined ( chunks_grate[i].script_parameters ) && ( chunks_grate[i].script_parameters == "grate") )
			{	
				if ( IsDefined ( grate_order1[i] ) )
				{
					if( ( grate_order1[i].state == "repaired" )  )
					{
						grate_order2[i] thread show_grate_pull();
						return grate_order1[i];
					}
					if(  ( grate_order2[i].state == "repaired" )  )
					{
						/#
						IPrintLnBold(" pull bar2 ");
						#/
						grate_order3[i] thread show_grate_pull(); 
						return grate_order2[i];
						
					}
					else if( ( grate_order3[i].state == "repaired" ) )
					{
						/#
						IPrintLnBold(" pull bar3 ");
						#/
						grate_order4[i] thread show_grate_pull();
						return grate_order3[i];
						 
					}
					else if( ( grate_order4[i].state == "repaired" ) )
					{
						/#
						IPrintLnBold(" pull bar4 ");
						#/
						grate_order5[i] thread show_grate_pull();
						return grate_order4[i];
					}
					else if( ( grate_order5[i].state == "repaired" ) )
					{
						/#
						IPrintLnBold(" pull bar5 ");
						#/
						grate_order6[i] thread show_grate_pull();
						return grate_order5[i];
					}
					else if( ( grate_order6[i].state == "repaired" ) )
					{
						// I need to return nothing here.
						//return undefined();
						return grate_order6[i];
					}
				}
			}
		}
	}
	//-------------------------GRATES----------------------------------------------------------
}

//////////////////////////////////////////////////////////////////////////////////////////////
//
// A seperate function is needed for each variant because there are different pull down and repair orders for each
// Also I had to add extra strings to idetify combined pieces that used the same script_noteworthy
//
//////////////////////////////////////////////////////////////////////////////////////////////
// variant1 
non_destroyed_variant1_order( origin, chunks_variant1 )
{
	//-------------------------VARIANT1----------------------------------------------------------
	variant1_order = [];
	variant1_order1 =[]; // this sets up the order for the grates
	variant1_order2 =[]; // this sets up the order for the grates
	variant1_order3 =[]; // this sets up the order for the grates
	variant1_order4 =[]; // this sets up the order for the grates
	variant1_order5 =[]; // this sets up the order for the grates
	variant1_order6 =[]; // this sets up the order for the grates

	
	if ( IsDefined ( chunks_variant1 ) )
	{
		for(i=0;i<chunks_variant1.size;i++) // Go through the array 
		{
			if (IsDefined (chunks_variant1[i].script_team) && (chunks_variant1[i].script_team == "bar_board_variant1") )
			{	
				//return grate_order[i];
				
				if ( IsDefined ( chunks_variant1[i].script_noteworthy ) )
				{
					if ( chunks_variant1[i].script_noteworthy == "1" )
					{
						variant1_order1[variant1_order1.size] = chunks_variant1[i];
					}
					if ( chunks_variant1[i].script_noteworthy == "2" )
					{
						variant1_order2[variant1_order2.size] = chunks_variant1[i];
					}
					if ( chunks_variant1[i].script_noteworthy == "3" )
					{
						variant1_order3[variant1_order3.size] = chunks_variant1[i];
					}
					if ( chunks_variant1[i].script_noteworthy == "4" )
					{
						variant1_order4[variant1_order4.size] = chunks_variant1[i];
					}
					if ( chunks_variant1[i].script_noteworthy == "5" )
					{
						variant1_order5[variant1_order5.size] = chunks_variant1[i];
					}
					if ( chunks_variant1[i].script_noteworthy == "6" )
					{
						variant1_order6[variant1_order6.size] = chunks_variant1[i];						
					}
				}
			}
		}
		
		
		// This needs a different order
		for(i=0;i<chunks_variant1.size;i++) // Go through the array 
		{
			if (IsDefined ( chunks_variant1[i].script_team ) && ( chunks_variant1[i].script_team == "bar_board_variant1") )
			{	
				if( IsDefined ( variant1_order2[i] ) )
				{
					if( ( variant1_order2[i].state == "repaired" )  )
					{
						return variant1_order2[i];
					}
					else if(  ( variant1_order3[i].state == "repaired" ) )
					{
						return variant1_order3[i];
					}
					else if( ( variant1_order4[i].state == "repaired" ) )
					{
						return variant1_order4[i]; 
					}
					else if( ( variant1_order6[i].state == "repaired" ) )
					{
						return variant1_order6[i];
					}
					else if( ( variant1_order5[i].state == "repaired" ) )
					{
						return variant1_order5[i];
					}
					else if( ( variant1_order1[i].state == "repaired" ) )
					{
						return variant1_order1[i];
					}
				}
			}
		}
	}
	
	//if( chunks_variant1.size == 0 )
	//{
	//	return undefined; // If there are no more pieces left then don't allow it to continue
	//}
	//-------------------------VARIANT1----------------------------------------------------------
}

// variant2
non_destroyed_variant2_order( origin, chunks_variant2 )
{
	//-------------------------VARIENT2----------------------------------------------------------
	variant2_order = [];
	variant2_order1 =[]; // this sets up the order for the grates
	variant2_order2 =[]; // this sets up the order for the grates
	variant2_order3 =[]; // this sets up the order for the grates
	variant2_order4 =[]; // this sets up the order for the grates
	variant2_order5 =[]; // this sets up the order for the grates
	variant2_order6 =[]; // this sets up the order for the grates

	
	if ( IsDefined ( chunks_variant2 ) )
	{
		for(i=0;i<chunks_variant2.size;i++) // Go through the array 
		{
			if (IsDefined (chunks_variant2[i].script_team) && (chunks_variant2[i].script_team == "bar_board_variant2") )
			{	
				//return grate_order[i];
				
				if ( IsDefined ( chunks_variant2[i].script_noteworthy ) && ( chunks_variant2[i].script_noteworthy == "1" ) )
				{
						variant2_order1[variant2_order1.size] = chunks_variant2[i];
						// send back order here
				}
				if ( IsDefined ( chunks_variant2[i].script_noteworthy ) && ( chunks_variant2[i].script_noteworthy == "2" ) )
				{
						variant2_order2[variant2_order2.size] = chunks_variant2[i];
							// send back order here
				}
				if ( IsDefined ( chunks_variant2[i].script_noteworthy ) && ( chunks_variant2[i].script_noteworthy == "3" ) )
				{
						variant2_order3[variant2_order3.size] = chunks_variant2[i];
							// send back order here
				}
				if ( IsDefined ( chunks_variant2[i].script_noteworthy ) && ( chunks_variant2[i].script_noteworthy == "4" ) )
				{
						variant2_order4[variant2_order4.size] = chunks_variant2[i];
							// send back order here
				}
				// I had to add another string to check against out of order noteworthy when combining board and wood
				if ( IsDefined ( chunks_variant2[i].script_noteworthy ) && ( chunks_variant2[i].script_noteworthy == "5" ) && IsDefined( chunks_variant2[i].script_location ) && (chunks_variant2[i].script_location == "5") )
				{
						variant2_order5[variant2_order5.size] = chunks_variant2[i];
							// send back order here
				}
				if ( IsDefined ( chunks_variant2[i].script_noteworthy ) && ( chunks_variant2[i].script_noteworthy == "5" ) && IsDefined( chunks_variant2[i].script_location ) && (chunks_variant2[i].script_location == "6") )
				{
						variant2_order6[variant2_order6.size] = chunks_variant2[i];
							// send back order here
				}
			}
		}	
		
		// There is a different pull order for every variant
		for(i=0;i<chunks_variant2.size;i++) // Go through the array 
		{
			if (IsDefined ( chunks_variant2[i].script_team ) && ( chunks_variant2[i].script_team == "bar_board_variant2") )
			{	
				if( IsDefined ( variant2_order1[i] ) )
				{	
					if( ( variant2_order1[i].state == "repaired" ) )
					{
						return variant2_order1[i];
					}
					else if(  ( variant2_order2[i].state == "repaired" ) )
					{
						return variant2_order2[i];
					}
					else if( ( variant2_order3[i].state == "repaired" ) )
					{
						return variant2_order3[i]; 
					}
					else if( ( variant2_order5[i].state == "repaired" ) )
					{
						return variant2_order5[i];
					}
					else if( ( variant2_order4[i].state == "repaired" ) )
					{
						return variant2_order4[i];
					}
					else if( ( variant2_order6[i].state == "repaired" ) )
					{
						return variant2_order6[i];
					}
				}
			}
		}
	}
	//-------------------------VARIENT2----------------------------------------------------------
}

// variant4
non_destroyed_variant4_order( origin, chunks_variant4 )
{
	//-------------------------VARIENT4----------------------------------------------------------
	variant4_order = [];
	variant4_order1 =[]; // this sets up the order for the grates
	variant4_order2 =[]; // this sets up the order for the grates
	variant4_order3 =[]; // this sets up the order for the grates
	variant4_order4 =[]; // this sets up the order for the grates
	variant4_order5 =[]; // this sets up the order for the grates
	variant4_order6 =[]; // this sets up the order for the grates

	
	if ( IsDefined ( chunks_variant4 ) )
	{
		for(i=0;i<chunks_variant4.size;i++) // Go through the array 
		{
			if (IsDefined (chunks_variant4[i].script_team) && (chunks_variant4[i].script_team == "bar_board_variant4") )
			{	
				//return grate_order[i];
				
				if ( IsDefined ( chunks_variant4[i].script_noteworthy ) && ( chunks_variant4[i].script_noteworthy == "1" ) && !IsDefined( chunks_variant4[i].script_location ) )
				{
						variant4_order1[variant4_order1.size] = chunks_variant4[i]; 
						// send back order here
				}
				if ( IsDefined ( chunks_variant4[i].script_noteworthy ) && ( chunks_variant4[i].script_noteworthy == "2" ) ) 
				{
						variant4_order2[variant4_order2.size] = chunks_variant4[i];
							// send back order here
				}
				if ( IsDefined ( chunks_variant4[i].script_noteworthy ) && ( chunks_variant4[i].script_noteworthy == "3" ) ) 
				{
						variant4_order3[variant4_order3.size] = chunks_variant4[i];
							// send back order here
				}
				if ( IsDefined ( chunks_variant4[i].script_noteworthy ) && ( chunks_variant4[i].script_noteworthy == "1" ) && IsDefined( chunks_variant4[i].script_location ) && (chunks_variant4[i].script_location == "3") )
				{
						variant4_order4[variant4_order4.size] = chunks_variant4[i];
						// send back order here
				}
				// There isn't a noteworthy 4
				if ( IsDefined ( chunks_variant4[i].script_noteworthy ) && ( chunks_variant4[i].script_noteworthy == "5" ) )
				{
						variant4_order5[variant4_order5.size] = chunks_variant4[i];
							// send back order here
				}
				if ( IsDefined ( chunks_variant4[i].script_noteworthy ) && ( chunks_variant4[i].script_noteworthy == "6" ) )
				{
						variant4_order6[variant4_order6.size] = chunks_variant4[i];
							// send back order here
				}
			}
		}	
		
		// There is a different pull order for every variant
		for(i=0;i<chunks_variant4.size;i++) // Go through the array 
		{
			if (IsDefined ( chunks_variant4[i].script_team ) && ( chunks_variant4[i].script_team == "bar_board_variant4") )
			{	
				if( IsDefined ( variant4_order1[i] ) ) // last one here
				{	
					if( ( variant4_order1[i].state == "repaired" ) )
					{
						return variant4_order1[i];
					}
					else if(  ( variant4_order6[i].state == "repaired" ) )
					{
						return variant4_order6[i];
					}
					else if( ( variant4_order3[i].state == "repaired" ) )
					{
						return variant4_order3[i]; 
					}
					else if( ( variant4_order4[i].state == "repaired" ) ) // second one
					{
						return variant4_order4[i];
					}
					else if( ( variant4_order2[i].state == "repaired" ) )
					{
						return variant4_order2[i];
					}
					else if( ( variant4_order5[i].state == "repaired" ) )
					{
						return variant4_order5[i];
					}
				}
			}
		}
	}
	//-------------------------Variant2----------------------------------------------------------
}

// variant5 
non_destroyed_variant5_order( origin, chunks_variant5 )
{
	//-------------------------VARIANT5----------------------------------------------------------
	variant5_order = [];
	variant5_order1 =[]; // this sets up the order for the grates
	variant5_order2 =[]; // this sets up the order for the grates
	variant5_order3 =[]; // this sets up the order for the grates
	variant5_order4 =[]; // this sets up the order for the grates
	variant5_order5 =[]; // this sets up the order for the grates
	variant5_order6 =[]; // this sets up the order for the grates

	
	if ( IsDefined ( chunks_variant5 ) )
	{
		for(i=0;i<chunks_variant5.size;i++) // Go through the array 
		{
			if (IsDefined (chunks_variant5[i].script_team) && (chunks_variant5[i].script_team == "bar_board_variant5") )
			{	
				//return grate_order[i];
				if ( IsDefined ( chunks_variant5[i].script_noteworthy ) )
				{
					// if ( IsDefined ( chunks_variant4[i].script_noteworthy ) && ( chunks_variant4[i].script_noteworthy == "1" ) && !IsDefined( chunks_variant4[i].script_location ) )
					if ( ( chunks_variant5[i].script_noteworthy == "1" ) && !IsDefined( chunks_variant5[i].script_location ) )
					{
						variant5_order1[variant5_order1.size] = chunks_variant5[i];
					}
					if ( chunks_variant5[i].script_noteworthy == "2" )
					{
						variant5_order2[variant5_order2.size] = chunks_variant5[i];
					}
					if ( IsDefined ( chunks_variant5[i].script_noteworthy ) && ( chunks_variant5[i].script_noteworthy == "1" ) && IsDefined( chunks_variant5[i].script_location ) && (chunks_variant5[i].script_location == "3") )
					{
						variant5_order3[variant5_order3.size] = chunks_variant5[i];
					}
					if ( chunks_variant5[i].script_noteworthy == "4" )
					{
						variant5_order4[variant5_order4.size] = chunks_variant5[i];
					}
					if ( chunks_variant5[i].script_noteworthy == "5" )
					{
						variant5_order5[variant5_order5.size] = chunks_variant5[i];
					}
					if ( chunks_variant5[i].script_noteworthy == "6" )
					{
						variant5_order6[variant5_order6.size] = chunks_variant5[i];						
					}
				}
			}
		}	
		for(i=0;i<chunks_variant5.size;i++) // Go through the array 
		{
			if (IsDefined ( chunks_variant5[i].script_team ) && ( chunks_variant5[i].script_team == "bar_board_variant5") )
			{	
				if( IsDefined ( variant5_order1[i] ) )
				{
					if( ( variant5_order1[i].state == "repaired" )  )
					{
						return variant5_order1[i];
					}
					else if(  ( variant5_order6[i].state == "repaired" ) )
					{
						return variant5_order6[i];
					}
					else if( ( variant5_order3[i].state == "repaired" ) )
					{
						return variant5_order3[i]; 
					}
					else if( ( variant5_order2[i].state == "repaired" ) )
					{
						return variant5_order2[i];
					}
					else if( ( variant5_order5[i].state == "repaired" ) )
					{
						return variant5_order5[i];
					}
					else if( ( variant5_order4[i].state == "repaired" ) )
					{
						return variant5_order4[i];
					}
				}
			}
		}
	}
	//-------------------------VARIANT5----------------------------------------------------------
}

show_grate_pull()
{
	wait(0.53);
	self Show();
	self vibrate(( 0, 270, 0 ), 0.2, 0.4, 0.4);
	// I could fx and sound from here as well.
}


get_closest_2d( origin, ents )
{
	if( !IsDefined( ents ) )
	{
		return undefined; 
	}
	
	dist = Distance2d( origin, ents[0].origin ); 
	index = 0; 
	temp_array = [];
		
	for( i = 1; i < ents.size; i++ )
	{
		if(IsDefined(ents[i].unbroken) && ents[i].unbroken == true)
		{
			ents[i].index = i; 
			ARRAY_ADD(temp_array, ents[i]);
		}
	}	

	if(temp_array.size > 0)
	{
		index = temp_array[RandomIntRange(0, temp_array.size)].index; // must pick unbroken piece first! 
		return ents[index]; 
	}
	else
	{		
		for( i = 1; i < ents.size; i++ )
		{
			temp_dist = Distance2d( origin, ents[i].origin ); 
			if( temp_dist < dist )
			{
				dist = temp_dist; 
				index = i; 
			}
		}
		return ents[index]; 
	}
}

disable_trigger()
{
	if( !IsDefined( self.disabled ) || !self.disabled )
	{
		self.disabled = true; 
		self.origin = self.origin -( 0, 0, 10000 ); 
	}
}

enable_trigger()
{
	if( !IsDefined( self.disabled ) || !self.disabled )
	{
		return; 
	}

	self.disabled = false; 
	self.origin = self.origin +( 0, 0, 10000 ); 
}

//edge_fog_start()
//{
//	playpoint = getstruct( "edge_fog_start", "targetname" ); 
//
//	if( !IsDefined( playpoint ) )
//	{
//		
//	} 
//	
//	while( isdefined( playpoint ) )
//	{
//		playfx( level._effect["edge_fog"], playpoint.origin ); 
//		
//		if( !isdefined( playpoint.target ) )
//		{
//			return; 
//		}
//		
//		playpoint = getstruct( playpoint.target, "targetname" ); 
//	}
//}


//chris_p - fix bug with this not being an ent array!
in_playable_area()
{
	playable_area = getentarray("player_volume","script_noteworthy");

	if( !IsDefined( playable_area ) )
	{
	/#	println( "No playable area playable_area found! Assume EVERYWHERE is PLAYABLE" );	#/
		return true;
	}
	
	for(i=0;i<playable_area.size;i++)
	{

		if( self IsTouching( playable_area[i] ) )
		{
			return true;
		}
	}

	return false;
}

// I beleive this is where I can do the check to see what 
// barrier_chunks is the total amount of bars or boards that the exterior_goal was connected to. 
get_closest_non_destroyed_chunk( origin, barrier, barrier_chunks ) 
{
	chunks = undefined; 
	chunks_grate = undefined;
	
	// This returns only if grate is defined
	chunks_grate = get_non_destroyed_chunks_grate( barrier, barrier_chunks );
	
	// This grabs classic boards, 6 bar prestine set and 6 bar bent set
	chunks = get_non_destroyed_chunks( barrier, barrier_chunks ); // Grab all the chunks that are repaired

	if(isdefined(barrier.zbarrier))
	{
		if(isdefined(chunks))
		{
			return array_randomize(chunks)[0];
		}
		
		if(isdefined(chunks_grate))
		{
			return array_randomize(chunks_grate)[0];
		}
	}
	else
	{
		// This returns an array of what chunks can be pulled
		
		if( IsDefined( chunks ) ) // && IsDefined ( chunks.script_parameters ) && chunks.script_parameters == "board" ) 
		{
					// Jl This was the original call
					// return get_closest_2d( origin, chunks ); 
			return non_destroyed_bar_board_order ( origin, chunks ); // Go through all the repaired chunk pieces
		}
		
		else if ( IsDefined ( chunks_grate ) )
		{
			return  non_destroyed_grate_order ( origin, chunks_grate ); // Go through all the repaired chunk pices
		}
	}
	
	return undefined; 
}


// Jluyties barrier_chunks is the total amount of bars or boards that the exterior_goal was connected to 
// The grates do not return random
get_random_destroyed_chunk( barrier, barrier_chunks )
{
	if(isdefined(barrier.zbarrier))
	{
		ret = undefined;
		
		pieces = barrier.zbarrier GetZBarrierPieceIndicesInState("open");
		
		if(pieces.size)
		{
			ret = array_randomize(pieces)[0];
		}
		
		return ret;
	}
	else
	{
		chunk = undefined; 
		chunks_repair_grate = undefined;
	
	
		chunks = get_destroyed_chunks( barrier_chunks );
	
		chunks_repair_grate = get_destroyed_repair_grates ( barrier_chunks );
	
	// for(i = 0; i < chunks.size; i++ )
		
		if ( IsDefined( chunks )  )
		{
			return chunks[RandomInt( chunks.size )]; 
			//return get_destroyed_chunks_without_grate ( chunks );
		} 
	
		else if( IsDefined( chunks_repair_grate ) )
		{
			return grate_order_destroyed ( chunks_repair_grate );
		}
		
		return undefined; 
	}
}

get_destroyed_repair_grates( barrier_chunks )
{
	// I may have to do my check here
	array = []; // Setup array
	for( i = 0; i < barrier_chunks.size; i++ ) // Cycle through and grab all chunks
	{			
		if( IsDefined ( barrier_chunks[i] ) )
		{
			if( IsDefined ( barrier_chunks[i].script_parameters ) && ( barrier_chunks[i].script_parameters == "grate" ) )
			{
				array[array.size] = barrier_chunks[i];  
			}
		}
	}

	if( array.size == 0 )
	{
		return undefined; // If there are no more pieces left then don't allow it to continue
	}

	return array; // send back state of array so it knows if boards are full or note and which board it is.
}


// this is the layer I want to do the check
// I need to define each part of 
get_non_destroyed_chunks( barrier, barrier_chunks )
{
	if(isdefined(barrier.zbarrier))
	{
		return barrier.zbarrier GetZBarrierPieceIndicesInState("closed");
	}
	else
	{
		array = []; // Setup array
		for( i = 0; i < barrier_chunks.size; i++ ) // Cycle through and grab all chunks
		{	
			if(IsDefined (barrier_chunks[i].script_team) && (barrier_chunks[i].script_team == "classic_boards") )
			{
				if (IsDefined (barrier_chunks[i].script_parameters) && (barrier_chunks[i].script_parameters == "board") )		
				{				
					if( barrier_chunks[i] get_chunk_state() == "repaired" ) // If the state of the chunk is repaired then continue
					{
						if( barrier_chunks[i].origin == barrier_chunks[i].og_origin ) // If this chunk has its original origin then continue
						{
							array[array.size] = barrier_chunks[i]; // 
						}
					}
				}
			}
			//DCS: new barricade added for pentagon.
			if(IsDefined (barrier_chunks[i].script_team) && (barrier_chunks[i].script_team == "new_barricade") )
			{
				if(IsDefined(barrier_chunks[i].script_parameters) && (barrier_chunks[i].script_parameters == "repair_board" || barrier_chunks[i].script_parameters == "barricade_vents"))
				{				
					if( barrier_chunks[i] get_chunk_state() == "repaired" ) // If the state of the chunk is repaired then continue
					{
						if( barrier_chunks[i].origin == barrier_chunks[i].og_origin ) // If this chunk has its original origin then continue
						{
							array[array.size] = barrier_chunks[i]; // 
						}
					}
				}
			}		
			
			else if ( IsDefined (barrier_chunks[i].script_team ) && ( barrier_chunks[i].script_team == "6_bars_bent" ) )
			{
				if (IsDefined (barrier_chunks[i].script_parameters) &&  (barrier_chunks[i].script_parameters == "bar") )			
				{
					if( barrier_chunks[i] get_chunk_state() == "repaired" ) // If the state of the chunk is repaired then continue
					{
		
						if( barrier_chunks[i].origin == barrier_chunks[i].og_origin ) // If this chunk has its original origin then continue
						{
							array[array.size] = barrier_chunks[i]; // 
						}
					}
				}
			}
			
			else if ( IsDefined (barrier_chunks[i].script_team ) && ( barrier_chunks[i].script_team == "6_bars_prestine" ) )
			{
				if (IsDefined (barrier_chunks[i].script_parameters) &&  (barrier_chunks[i].script_parameters == "bar") )			
				{
					if( barrier_chunks[i] get_chunk_state() == "repaired" ) // If the state of the chunk is repaired then continue
					{
		
						if( barrier_chunks[i].origin == barrier_chunks[i].og_origin ) // If this chunk has its original origin then continue
						{
							array[array.size] = barrier_chunks[i]; // 
						}
					}
				}
			}
		}
	
		if( array.size == 0 )
		{
			return undefined; // If there are no more pieces left then don't allow it to continue
		}
	
		return array; // send back state of array 
	}
}

get_non_destroyed_chunks_grate( barrier, barrier_chunks )
{
	if(isdefined(barrier.zbarrier))
	{
		return barrier.zbarrier GetZBarrierPieceIndicesInState("closed");
	}
	else
	{
		array = []; // Setup array
		for( i = 0; i < barrier_chunks.size; i++ ) // Cycle through and grab all chunks
		{
			if (IsDefined (barrier_chunks[i].script_parameters) && (barrier_chunks[i].script_parameters == "grate") )
			{	
				if( IsDefined ( barrier_chunks[i] ) )
				{
					array[array.size] = barrier_chunks[i]; // 
				}
			}
		}
	
		if( array.size == 0 )
		{
			return undefined; // If there are no more pieces left then don't allow it to continue
		}
	
		return array; // send back state of array so it knows if boards are full or note and which board it is.
	}
}

get_non_destroyed_variant1( barrier_chunks )
{
	array = []; // Setup array
	for( i = 0; i < barrier_chunks.size; i++ ) // Cycle through and grab all chunks
	{
		if (IsDefined (barrier_chunks[i].script_team) && (barrier_chunks[i].script_team == "bar_board_variant1") )
		{	
			if( IsDefined ( barrier_chunks[i] ) )
			{
				array[array.size] = barrier_chunks[i];  
			}
		}
	}

	if( array.size == 0 )
	{
		return undefined; // If there are no more pieces left then don't allow it to continue
	}

	return array; // send back state of array so it knows if boards are full or note and which board it is.
}

get_non_destroyed_variant2( barrier_chunks )
{
	array = []; // Setup array
	for( i = 0; i < barrier_chunks.size; i++ ) // Cycle through and grab all chunks
	{
		if (IsDefined (barrier_chunks[i].script_team) && (barrier_chunks[i].script_team == "bar_board_variant2") )
		{	
			if( IsDefined ( barrier_chunks[i] ) )
			{
				array[array.size] = barrier_chunks[i];  
			}
		}
	}

	if( array.size == 0 )
	{
		return undefined; // If there are no more pieces left then don't allow it to continue
	}

	return array; // send back state of array so it knows if boards are full or note and which board it is.
}

get_non_destroyed_variant4( barrier_chunks )
{
	array = []; // Setup array
	for( i = 0; i < barrier_chunks.size; i++ ) // Cycle through and grab all chunks
	{
		if (IsDefined (barrier_chunks[i].script_team) && (barrier_chunks[i].script_team == "bar_board_variant4") )
		{	
			if( IsDefined ( barrier_chunks[i] ) )
			{
				array[array.size] = barrier_chunks[i]; // 
			}
		}
	}

	if( array.size == 0 )
	{
		return undefined; // If there are no more pieces left then don't allow it to continue
	}

	return array; // send back state of array so it knows if boards are full or note and which board it is.
}

get_non_destroyed_variant5( barrier_chunks )
{
	array = []; // Setup array
	for( i = 0; i < barrier_chunks.size; i++ ) // Cycle through and grab all chunks
	{
		if (IsDefined (barrier_chunks[i].script_team) && (barrier_chunks[i].script_team == "bar_board_variant5") )
		{	
			if( IsDefined ( barrier_chunks[i] ) )
			{
				array[array.size] = barrier_chunks[i]; // 
			}
		}
	}

	if( array.size == 0 )
	{
		return undefined; // If there are no more pieces left then don't allow it to continue
	}

	return array; // send back state of array so it knows if boards are full or note and which board it is.
}

get_destroyed_chunks( barrier_chunks )
{
	array = []; 
	for( i = 0; i < barrier_chunks.size; i++ )
	{
		if( barrier_chunks[i] get_chunk_state() == "destroyed" ) // if the chunks state says it is destroyed then continue
		{
			if (IsDefined (barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "board")
			{			
				array[array.size] = barrier_chunks[i]; // create a new array from barrier chunks
			}
			else if (IsDefined (barrier_chunks[i].script_parameters) && barrier_chunks[i].script_parameters == "repair_board" || barrier_chunks[i].script_parameters == "barricade_vents")
			{			
				array[array.size] = barrier_chunks[i]; // create a new array from barrier chunks
			}
			else if (IsDefined (barrier_chunks[i].script_parameters) && (barrier_chunks[i].script_parameters == "bar") )
			{
				array[array.size] = barrier_chunks[i]; // create a new array from barrier chunks
			}	
			
			else if (IsDefined (barrier_chunks[i].script_parameters) && (barrier_chunks[i].script_parameters == "grate") )
			{
				// This makes sure that it isn't returned
				return undefined;
				//array[array.size] = barrier_chunks[i]; // create a new array from barrier chunks
			}	
		}
	}
	
	if( array.size == 0 )
	{
		return undefined;
	}
	
	return array;
	
	//if( IsDefined( barrier_chunks ) )
	//{
	//	return barrier_chunks; 
	//}
}


grate_order_destroyed( chunks_repair_grate )
{
	grate_repair_order = [];
	grate_repair_order1 =[]; // this sets up the order for the grates
	grate_repair_order2 =[]; // this sets up the order for the grates
	grate_repair_order3 =[]; // this sets up the order for the grates
	grate_repair_order4 =[]; // this sets up the order for the grates
	grate_repair_order5 =[]; // this sets up the order for the grates
	grate_repair_order6 =[]; // this sets up the order for the grates
	
	
	// DEBUG
	/*
	for(i=0;i<chunks_repair_grate.size;i++) // Go through the array 
	{
		if (IsDefined (chunks_repair_grate[i].script_parameters) && (chunks_repair_grate[i].script_parameters == "grate") )
		{	
			grate_repair_order[grate_repair_order.size] = chunks_repair_grate[i]; // now chunks is the total amount of grates connecte
		}
	}
	*/
	
	for(i=0;i<chunks_repair_grate.size;i++)
	{
		if (IsDefined (chunks_repair_grate[i].script_parameters) && (chunks_repair_grate[i].script_parameters == "grate") )
		{	
			if ( IsDefined ( chunks_repair_grate[i].script_noteworthy ) && ( chunks_repair_grate[i].script_noteworthy == "1" ) )
			{
					grate_repair_order1[grate_repair_order1.size] = chunks_repair_grate[i];
					// send back order here
			}
			if ( IsDefined ( chunks_repair_grate[i].script_noteworthy ) && ( chunks_repair_grate[i].script_noteworthy == "2" ) )
			{
					grate_repair_order2[grate_repair_order2.size] = chunks_repair_grate[i];
						// send back order here
			}
			if ( IsDefined ( chunks_repair_grate[i].script_noteworthy ) && ( chunks_repair_grate[i].script_noteworthy == "3" ) )
			{
					grate_repair_order3[grate_repair_order3.size] = chunks_repair_grate[i];
						// send back order here
			}
			if ( IsDefined ( chunks_repair_grate[i].script_noteworthy ) && ( chunks_repair_grate[i].script_noteworthy == "4" ) )
			{
					grate_repair_order4[grate_repair_order4.size] = chunks_repair_grate[i];
						// send back order here
			}
			if ( IsDefined ( chunks_repair_grate[i].script_noteworthy ) && ( chunks_repair_grate[i].script_noteworthy == "5" ) )
			{
					grate_repair_order5[grate_repair_order5.size] = chunks_repair_grate[i];
						// send back order here
			}
			if ( IsDefined ( chunks_repair_grate[i].script_noteworthy ) && ( chunks_repair_grate[i].script_noteworthy == "6" ) )
			{
					grate_repair_order6[grate_repair_order6.size] = chunks_repair_grate[i];
						// send back order here
			}
		}
	}
	
	for(i=0;i<chunks_repair_grate.size;i++) // Go through the array 
	{
		if (IsDefined (chunks_repair_grate[i].script_parameters) && (chunks_repair_grate[i].script_parameters == "grate") )
		{	
			if( IsDefined ( grate_repair_order1[i] ) ) // last one here
			{	
			
				if( ( grate_repair_order6[i].state == "destroyed" )  )
					{
							/#
							IPrintLnBold(" Fix grate6 ");
							#/
								// Here I will tell the other board to replace		
							return grate_repair_order6[i];
					}
					if(  ( grate_repair_order5[i].state == "destroyed" )  )
					{
						/#
						IPrintLnBold(" Fix grate5 ");
						#/
						grate_repair_order6[i] thread show_grate_repair();		
						return grate_repair_order5[i];
					}
					else if( ( grate_repair_order4[i].state == "destroyed" ) )
					{
						/#
						IPrintLnBold(" Fix grate4 ");
						#/
						grate_repair_order5[i] thread show_grate_repair();	
						return grate_repair_order4[i];
					}
					else if( ( grate_repair_order3[i].state == "destroyed" ) )
					{
						/#
						IPrintLnBold(" Fix grate3 ");
						#/
						grate_repair_order4[i] thread show_grate_repair();	
						return grate_repair_order3[i];
					}
					else if( ( grate_repair_order2[i].state == "destroyed" ) )
					{
						/#
						IPrintLnBold(" Fix grate2 ");
						#/
						grate_repair_order3[i] thread show_grate_repair();	
						return grate_repair_order2[i];
					}
					else if( ( grate_repair_order1[i].state == "destroyed" ) )
					{
						/#
						IPrintLnBold(" Fix grate1 ");
						#/
						grate_repair_order2[i] thread show_grate_repair();	
						// I need to return nothing here.
						//return undefined();
						return grate_repair_order1[i];
					}
			}
		}
	}
}

// Self is grate
show_grate_repair()
{
	wait( 0.34 );
	self Hide();
}

get_chunk_state()
{
	assert( isdefined( self.state ) );

	return self.state;
}

is_float( num )
{
	val = num - int( num ); 

	if( val != 0 )
	{
		return true; 
	}
	else
	{
		return false; 
	}
}

array_limiter( array, total )
{
	new_array = []; 

	for( i = 0; i < array.size; i++ )
	{
		if( i < total )
		{
			new_array[new_array.size] = array[i]; 
		}
	}

	return new_array; 
}

array_validate( array )
{
	if( IsDefined( array ) && array.size > 0 )
	{
		return true;
	}
	else
	{
		return false;
	}
}

add_spawner( spawner )
{
	if( IsDefined( spawner.script_start ) && level.round_number < spawner.script_start )
	{
		return;
	}

	if( IsDefined( spawner.is_enabled ) && !spawner.is_enabled)
	{
		return;
	}

	if( IsDefined( spawner.has_been_added ) && spawner.has_been_added )
	{
		return;
	}

	spawner.has_been_added = true;

	level.zombie_spawn_locations[level.zombie_spawn_locations.size] = spawner; 
}

fake_physicslaunch( target_pos, power )
{
	start_pos = self.origin; 
	
	///////// Math Section
	// Reverse the gravity so it's negative, you could change the gravity
	// by just putting a number in there, but if you keep the dvar, then the
	// user will see it change.
	gravity = GetDvarInt( "bg_gravity" ) * -1; 

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

//
// STRINGS ======================================================================= 
// 
add_zombie_hint( ref, text )
{
	if( !IsDefined( level.zombie_hints ) )
	{
		level.zombie_hints = []; 
	}

	PrecacheString( text ); 
	level.zombie_hints[ref] = text; 
}

get_zombie_hint( ref )
{
	if( IsDefined( level.zombie_hints[ref] ) )
	{
		return level.zombie_hints[ref]; 
	}

/#
	println( "UNABLE TO FIND HINT STRING " + ref ); 
#/
	return level.zombie_hints["undefined"]; 
}

// self is the trigger( usually spawned in on the fly )
// ent is the entity that has the script_hint info
set_hint_string( ent, default_ref )
{
	if( IsDefined( ent.script_hint ) )
	{
		self SetHintString( get_zombie_hint( ent.script_hint ) ); 
	}
	else
	{
		self SetHintString( get_zombie_hint( default_ref ) ); 
	}
}

//
// SOUNDS =========================================================== 
// 

add_sound( ref, alias )
{
	if( !IsDefined( level.zombie_sounds ) )
	{
		level.zombie_sounds = []; 
	}

	level.zombie_sounds[ref] = alias; 
}

play_sound_at_pos( ref, pos, ent )
{
	if( IsDefined( ent ) )
	{
		if( IsDefined( ent.script_soundalias ) )
		{
			PlaySoundAtPosition( ent.script_soundalias, pos ); 
			return;
		}

		if( IsDefined( self.script_sound ) )
		{
			ref = self.script_sound; 
		}
	}

	if( ref == "none" )
	{
		return; 
	}

	if( !IsDefined( level.zombie_sounds[ref] ) )
	{
		AssertMsg( "Sound \"" + ref + "\" was not put to the zombie sounds list, please use add_sound( ref, alias ) at the start of your level." ); 
		return; 
	}
	
	PlaySoundAtPosition( level.zombie_sounds[ref], pos ); 
}

play_sound_on_ent( ref )
{
	if( IsDefined( self.script_soundalias ) )
	{
		self PlaySound( self.script_soundalias ); 
		return;
	}

	if( IsDefined( self.script_sound ) )
	{
		ref = self.script_sound; 
	}

	if( ref == "none" )
	{
		return; 
	}

	if( !IsDefined( level.zombie_sounds[ref] ) )
	{
		AssertMsg( "Sound \"" + ref + "\" was not put to the zombie sounds list, please use add_sound( ref, alias ) at the start of your level." ); 
		return; 
	}

	self PlaySound( level.zombie_sounds[ref] ); 
}

play_loopsound_on_ent( ref )
{
	if( IsDefined( self.script_firefxsound ) )
	{
		ref = self.script_firefxsound; 
	}

	if( ref == "none" )
	{
		return; 
	}

	if( !IsDefined( level.zombie_sounds[ref] ) )
	{
		AssertMsg( "Sound \"" + ref + "\" was not put to the zombie sounds list, please use add_sound( ref, alias ) at the start of your level." ); 
		return; 
	}

	self PlaySound( level.zombie_sounds[ref] ); 
}


string_to_float( string )
{
	floatParts = strTok( string, "." );
	if ( floatParts.size == 1 )
		return int(floatParts[0]);

	whole = int(floatParts[0]);
	// Convert the decimal part into a floating point value
	decimal = 0;
	for ( i=floatParts[1].size-1; i>=0; i-- )
	{
		decimal = decimal/10 + int(floatParts[1][i])/10;
	}

	if ( whole >= 0 )
		return (whole + decimal);
	else
		return (whole - decimal);
}

AddCallback(event, func)
{
	assert(IsDefined(event), "Trying to set a callback on an undefined event.");

	if (!IsDefined(level._callbacks) || !IsDefined(level._callbacks[event]))
	{
		level._callbacks[event] = [];
	}

	level._callbacks[event] = add_to_array(level._callbacks[event], func, false);
}

OnPlayerConnect_Callback(func)
{
	AddCallback("on_player_connect", func);
}

OnPlayerDisconnect_Callback(func)
{
	AddCallback("on_player_disconnect", func);
}

Callback(event)
{
	if (IsDefined(level._callbacks) && IsDefined(level._callbacks[event]))
	{
		for (i = 0; i < level._callbacks[event].size; i++)
		{
			callback = level._callbacks[event][i];
			if (IsDefined(callback))
			{
				self thread [[callback]]();
			}
		}
	}
}

//
// TABLE LOOK SECTION ============================================================
// 

//	Read a value from a table and set the related level.zombie_var
//
set_zombie_var( var, value, is_float, column )
{
	if ( !IsDefined( is_float ) )
	{
		is_float = false;
	}
	if ( !IsDefined(column) )
	{
		column = 1;
	}

	// First look it up in the table
	table = "mp/zombiemode.csv";
	table_value = TableLookUp( table, 0, var, column );

	if ( IsDefined( table_value ) && table_value != "" )
	{
		if( is_float )
		{
			value = float( table_value );
		}
		else
		{
			value = int( table_value );
		}
	}

	level.zombie_vars[var] = value;
	return value;
}


//	Read a value from a table and return the result
//
get_table_var( table, var_name, value, is_float, column )
{
	if ( !IsDefined(table) )
	{
		table = "mp/zombiemode.csv";
	}
	if ( !IsDefined(is_float) )
	{
		is_float = false;
	}
	if ( !IsDefined(column) )
	{
		column = 1;
	}

	// First look it up in the table
	table_value = TableLookUp( table, 0, var_name, column );
	if ( IsDefined( table_value ) && table_value != "" )
	{
		if( is_float )
		{
			value = string_to_float( table_value );
		}
		else
		{
			value = int( table_value );
		}
	}

	return value;
}


hudelem_count()
{
/#
	max = 0; 
	curr_total = 0; 
	while( 1 )
	{
		if( level.hudelem_count > max )
		{
			max = level.hudelem_count; 
		}
		
		println( "HudElems: " + level.hudelem_count + "[Peak: " + max + "]" ); 
		wait( 0.05 ); 
	}
#/
}

debug_round_advancer()
{
/#
	while( 1 )
	{
		zombs = getaiarray( "axis" ); 
		
		for( i = 0; i < zombs.size; i++ )
		{
			zombs[i] dodamage( zombs[i].health * 100, ( 0, 0, 0 ) ); 
			wait 0.5; 
		}
	}	
#/
}

print_run_speed( speed )
{
/#
	self endon( "death" ); 
	while( 1 )
	{
		print3d( self.origin +( 0, 0, 64 ), speed, ( 1, 1, 1 ) ); 
		wait 0.05; 
	}
#/
}

draw_line_ent_to_ent( ent1, ent2 )
{
/#
	if( GetDvarInt( "zombie_debug" ) != 1 )
	{
		return; 
	}

	ent1 endon( "death" ); 
	ent2 endon( "death" ); 

	while( 1 )
	{
		line( ent1.origin, ent2.origin ); 
		wait( 0.05 ); 
	}
#/
}

draw_line_ent_to_pos( ent, pos, end_on )
{
/#
	if( GetDvarInt( "zombie_debug" ) != 1 )
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

debug_print( msg )
{
/#
	if( GetDvarInt( "zombie_debug" ) > 0 )
	{
		println( "######### ZOMBIE: " + msg ); 
	}
#/
}

debug_blocker( pos, rad, height )
{
/#
	self notify( "stop_debug_blocker" );
	self endon( "stop_debug_blocker" );
	
	for( ;; )
	{
		if( GetDvarInt( "zombie_debug" ) != 1 )
		{
			return;
		}

		wait( 0.05 ); 
		drawcylinder( pos, rad, height ); 
		
	}
#/
}

drawcylinder( pos, rad, height )
{
/#
	currad = rad; 
	curheight = height; 

	for( r = 0; r < 20; r++ )
	{
		theta = r / 20 * 360; 
		theta2 = ( r + 1 ) / 20 * 360; 

		line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, 0 ) ); 
		line( pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, curheight ) ); 
		line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ) ); 
	}
#/
}

print3d_at_pos( msg, pos, thread_endon, offset )
{
/#
	self endon( "death" ); 

	if( IsDefined( thread_endon ) )
	{
		self notify( thread_endon ); 
		self endon( thread_endon ); 
	}

	if( !IsDefined( offset ) )
	{
		offset = ( 0, 0, 0 ); 
	}

	while( 1 )
	{
		print3d( self.origin + offset, msg ); 
		wait( 0.05 ); 
	}
#/
}

debug_breadcrumbs()
{
/#
	self endon( "disconnect" ); 

	while( 1 )
	{
		if( GetDvarInt( "zombie_debug" ) != 1 )
		{
			wait( 1 ); 
			continue; 
		}

		for( i = 0; i < self.zombie_breadcrumbs.size; i++ )
		{
			drawcylinder( self.zombie_breadcrumbs[i], 5, 5 );
		}

		wait( 0.05 ); 
	}
#/
}

/#
debug_attack_spots_taken()
{
// this section was totally commented out.
	while( 1 )
	{
		if( GetDvarInt( "zombie_debug" ) != 2 )
		{
			wait( 1 ); 
			continue; 
		}

		wait( 0.05 );
		count = 0;
		for( i = 0; i < self.attack_spots_taken.size; i++ )
		{
			if( self.attack_spots_taken[i] )
			{
				count++;
				circle(self.attack_spots[i], 12, (1,0,0), false, true, 1);
			}
			else
			{
				circle(self.attack_spots[i], 12, (0,1,0), false, true, 1);
			}
		}

		msg = "" + count + " / " + self.attack_spots_taken.size;
		print3d( self.origin, msg );
	}

}
#/

float_print3d( msg, time )
{
/#
	self endon( "death" );

	time = GetTime() + ( time * 1000 );
	offset = ( 0, 0, 72 );
	while( GetTime() < time )
	{
		offset = offset + ( 0, 0, 2 );
		print3d( self.origin + offset, msg, ( 1, 1, 1 ) );
		wait( 0.05 );
	}
#/
}
do_player_vo(snd, variation_count)
{

	
	index = maps\mp\zombies\_zm_weapons::get_player_index(self);
	
	// updated to new alias format - Steve G
	sound = "zmb_vox_plr_" + index + "_" + snd; 
	if(IsDefined (variation_count))
	{
		sound = sound + "_" + randomintrange(0, variation_count);
	}
	if(!isDefined(level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	
	if (level.player_is_speaking == 0)
	{	
		level.player_is_speaking = 1;
		self PlaySoundWithNotify(sound, "sound_done");			
		self waittill("sound_done");
		//This ensures that there is at least 3 seconds waittime before playing another VO.
		wait(2);
		level.player_is_speaking = 0;
	}	
}

/@
"Name: stop_magic_bullet_shield()"
"Summary: Stops magic bullet shield on an AI, setting his health back to a normal value and making him vulnerable to death."
"Module: AI"
"CallOn: AI"
"Example: friendly stop_magic_bullet_shield();"
"SPMP: singleplayer"
@/

stop_magic_bullet_shield()
{
	self.attackerAccuracy = 1;	// TODO: restore old value if we need it.

	self notify("stop_magic_bullet_shield");
	self.magic_bullet_shield = undefined;
	self._mbs = undefined;
}

/@
"Name: magic_bullet_shield()"
"Summary: Makes an AI invulnerable to death. When he gets shot, he is temporarily ignored by enemies."
"Module: AI"
"CallOn: AI"
"Example: guy magic_bullet_shield();"
"SPMP: singleplayer"
@/

magic_bullet_shield()
{
	if ( !IS_TRUE( self.magic_bullet_shield ) )
	{
		if ( IsAI( self ) || IsPlayer( self ) )
		{
			self.magic_bullet_shield = true;

			/#
				level thread debug_magic_bullet_shield_death( self );
			#/

			if ( !IsDefined( self._mbs ) )
			{
				self._mbs = SpawnStruct();
			}

			if ( IsAI( self ) )
			{
				assert( IsAlive( self ), "Tried to do magic_bullet_shield on a dead or undefined guy." );
				//assert( !self.delayedDeath, "Tried to do magic_bullet_shield on a guy about to die." ); // no longer needed

				self._mbs.last_pain_time = 0;
				self._mbs.ignore_time = 2;
				self._mbs.turret_ignore_time = 5;
			}

			self.attackerAccuracy = 0.1;
		}
		else
		{
			AssertMsg("magic_bullet_shield does not support entity of classname '" + self.classname + "'.");
		}
	}
}

debug_magic_bullet_shield_death( guy )
{
	targetname = "none";
	if ( IsDefined( guy.targetname ) )
	{
		targetname = guy.targetname;
	}

	guy endon( "stop_magic_bullet_shield" );
	guy waittill( "death" );
	Assert( !IsDefined( guy ), "Guy died with magic bullet shield on with targetname: " + targetname );
}

is_magic_bullet_shield_enabled( ent )
{
	if( !IsDefined( ent ) )
		return false;

	return ( IsDefined( ent.magic_bullet_shield ) && ent.magic_bullet_shield == true );
}

really_play_2D_sound(sound)
{
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent PlaySoundWithNotify (sound, sound + "wait");
	temp_ent waittill (sound + "wait");
	wait(0.05);
	temp_ent delete();	

}


play_sound_2D(sound)
{
	level thread really_play_2D_sound(sound);
	
	/*
	if(!isdefined(level.playsound2dent))
	{
		level.playsound2dent = spawn("script_origin",(0,0,0));
	}
	
	//players=GET_PLAYERS();
	level.playsound2dent playsound ( sound );
	*/
	/*
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent PlaySoundWithNotify (sound, sound + "wait");
	temp_ent waittill (sound + "wait");
	wait(0.05);
	temp_ent delete();	
	*/	
}

include_weapon( weapon_name, in_box, collector, weighting_func )
{
/#	println( "ZM >> include_weapon = " + weapon_name );	#/
	if( !isDefined( in_box ) )
	{
		in_box = true;
	}
	if( !isDefined( collector ) )
	{
		collector = false;
	}
	maps\mp\zombies\_zm_weapons::include_zombie_weapon( weapon_name, in_box, collector, weighting_func );
}

include_buildable( buildable_struct )
{
/#	println( "ZM >> include_buildable = " + buildable_struct.name );	#/
	
	maps\mp\zombies\_zm_buildables::include_zombie_buildable( buildable_struct );
}

create_zombie_buildable_piece( modelName, radius, height, hud_icon )
{
/#	println( "ZM >> create_zombie_buildable_piece = " + modelName );	#/
	
	self maps\mp\zombies\_zm_buildables::create_zombie_buildable_piece( modelName, radius, height, hud_icon );
}

is_buildable()
{
	return ( self maps\mp\zombies\_zm_buildables::is_buildable() );
}

include_powerup( powerup_name )
{
	maps\mp\zombies\_zm_powerups::include_zombie_powerup( powerup_name );
}

include_equipment( equipment_name )
{
	maps\mp\zombies\_zm_equipment::include_zombie_equipment( equipment_name );
}

// Allows triggers to be un/seen by players
trigger_invisible( enable )
{
	players = GET_PLAYERS();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( players[i] ) )
		{
			self SetInvisibleToPlayer( players[i], enable );
		}
	}
}


// Print3d
print3d_ent( text, color, scale, offset, end_msg, overwrite )
{
	self endon("death");

	if ( IsDefined(overwrite) && overwrite && IsDefined( self._debug_print3d_msg ) )
	{
		// Kill the previous thread
		self notify( "end_print3d" );
		wait(0.05);
	}

	self endon("end_print3d");

	if ( !IsDefined(color) )
	{
		color = (1,1,1);
	}

	if ( !IsDefined(scale) )
	{
		scale = 1.0;
	}

	if ( !IsDefined(offset) )
	{
		offset = (0,0,0);
	}

	if ( IsDefined(end_msg) )
	{
		self endon(end_msg);
	}

	// This way you can change the message dynamically by changing the var
	self._debug_print3d_msg = text;
	/#
	while (1)
	{
		print3d( self.origin+offset, self._debug_print3d_msg, color, scale );
		wait( 0.05 );
	}
	#/
}


// Copied from _class
// including grenade launcher, grenade, bazooka, betty, satchel charge
isExplosiveDamage( meansofdeath )
{
	explosivedamage = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE";

	if( isSubstr( explosivedamage, meansofdeath ) )
		return true;
	return false;
}

// if primary weapon damage
isPrimaryDamage( meansofdeath )
{
	// including pistols as well since sometimes they share ammo
	if( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" )
		return true;
	return false;
}

isFireDamage( weapon, meansofdeath )
{
	if ( ( isSubStr( weapon, "flame" ) || isSubStr( weapon, "molotov_" ) || isSubStr( weapon, "napalmblob_" ) ) && ( meansofdeath == "MOD_BURNED" || meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_GRENADE_SPLASH" ) )
		return true;
	return false;
}

isPlayerExplosiveWeapon( weapon, meansofdeath )
{
	if ( !isExplosiveDamage( meansofdeath ) )
		return false;

	if ( weapon == "artillery_mp" )
		return false;

	// no tank main guns
	if ( issubstr(weapon, "turret" ) )
		return false;

	return true;
}

//
//  Sets the counter's value to the specified number if necessary
//	Used in conjunction with precached models
//	self is a counter's digit model (0-9)
set_counter( value )
{
	if ( self.model != level.counter_model[ value ] )
	{
		self SetModel( level.counter_model[ value ] );
	}
}


//
//
create_counter_hud( x )
{
	if( !IsDefined( x ) )
	{
		x = 0;
	}

	hud = create_simple_hud();
	hud.alignX = "left"; 
	hud.alignY = "top";
	hud.horzAlign = "user_left"; 
	hud.vertAlign = "user_top";
	hud.color = ( 1, 1, 1 );
//	hud.color = ( 0.21, 0, 0 );
	hud.fontscale = 32;
	hud.x = x; 
	hud.alpha = 0;

	hud SetShader( "hud_chalk_1", 64, 64 );

	return hud;
}


//
//	Get the name of the zone that the entity is currently in
//	self is the entity to check on
get_current_zone()
{
	flag_wait( "zones_initialized" );

	zkeys = GetArrayKeys( level.zones );
	// clear out active zone flags
	for( z=0; z<zkeys.size; z++ )
	{
		zone_name = zkeys[z];
		zone = level.zones[ zone_name ];

		// Okay check to see if the entity is in one of the zone volumes
		for (i = 0; i < zone.volumes.size; i++)
		{
			if ( self IsTouching(zone.volumes[i]) )
			{
				return zone_name;
			}
		}
	}

	return undefined;
}

remove_mod_from_methodofdeath( mod )
{
	/*modStrings = strtok( mod, "mod_" );
	modName = "";
	for ( i = 1; i < modStrings.size; i++ )//skip the MOD_
	{
		modName += modStrings[i];
	}*/
	
	return mod;
}

clear_fog_threads()
{
	players = GET_PLAYERS();

	for( i = 0; i < players.size; i++ )
	{
		players[i] notify( "stop_fog" );
	}
}

display_message( titleText, notifyText, duration )
{
	notifyData = spawnStruct();
	notifyData.titleText = notifyText;//titleText;
	notifyData.notifyText = titleText;//notifyText;
	//notifyData.titleText = &"ZM_MEAT_GRAB";
	//notifyData.notifyText = "MEAT GRAB";
	notifyData.sound = "mus_level_up";
	notifyData.duration = duration;
	notifyData.glowColor = (1.0, 0.0, 0.0);
	notifyData.color = (0.0, 0.0, 0.0);
	notifyData.iconName = "hud_zombies_meat";
	self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

is_quad()
{
	return self.animname == "quad_zombie";
}

shock_onpain()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 

	if( GetDvar( "blurpain" ) == "" )
	{
		SetDvar( "blurpain", "on" ); 
	}

	while( 1 )
	{
		oldhealth = self.health; 
		self waittill( "damage", damage, attacker, direction_vec, point, mod ); 

		if( IsDefined( level.shock_onpain ) && !level.shock_onpain )
		{
			continue;
		}

		if( IsDefined( self.shock_onpain ) && !self.shock_onpain )
		{
			continue;
		}

		if( self.health < 1 )
		{
			continue;
		}

		if( mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" )
		{
			continue;
		}
		else if( mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GRENADE" ||  mod == "MOD_EXPLOSIVE" )
		{
			self shock_onexplosion( damage );
		}
		else
		{
			if( GetDvar( "blurpain" ) == "on" )
			{
				self ShellShock( "pain", 0.5 ); 
			}
		}
	}
}

shock_onexplosion( damage )
{
	time = 0; 

	multiplier = self.maxhealth / 100; 
	scaled_damage = damage * multiplier;

	if( scaled_damage >= 90 )
	{
		time = 4; 
	}
	else if( scaled_damage >= 50 )
	{
		time = 3; 
	}
	else if( scaled_damage >= 25 )
	{
		time = 2; 
	}
	else if( scaled_damage > 10 )
	{
		time = 1; 
	}

	if( time )
	{
		self ShellShock( "explosion", time );
	}
}

// ww: increment the is_drinking variable on a player
increment_is_drinking()
{
	//self endon( "death" );
	
	if( self.is_drinking == 0 )
	{
		self DisableOffhandWeapons();
		self DisableWeaponCycling();
	}
	
	self.is_drinking++;
}

// ww: checks is_drinking
//is_drinking()
//{
//	//self endon( "death" );
//	return ( self.is_drinking > 0 );
//}

// to check if more than one is active at once
is_multiple_drinking()
{
	//self endon( "death" );
	return ( self.is_drinking > 1 );
}

// ww: decrement drinking
decrement_is_drinking()
{
	//self endon( "death" );
	
	if( self.is_drinking > 0 )
	{
		self.is_drinking--;
	}
	else
	{
		AssertMsg( "making is_drinking less than 0" );
	}

	
	if( self.is_drinking == 0 )
	{
		self EnableOffhandWeapons();
		self EnableWeaponCycling();
	}
}

// ww: clear the variable, used for players going in to last stand
clear_is_drinking()
{
	//self endon( "death" );
	
	self.is_drinking = 0;
	
	self EnableOffhandWeapons();
	self EnableWeaponCycling();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
fade_out(time)
{
	if (!isDefined(time))
	{
		time = 1;
	}
	if( !IsDefined(level.introblack) )
	{
		level.introblack = NewHudElem(); 
		level.introblack.x = 0; 
		level.introblack.y = 0; 
		level.introblack.horzAlign = "fullscreen"; 
		level.introblack.vertAlign = "fullscreen"; 
		level.introblack.foreground = true;
		level.introblack SetShader( "black", 640, 480 );
		level.introblack.alpha = 0; 
		wait .05;
	}

	if( time > 0 )
	{
		level.introblack FadeOverTime( time ); 
	}
	level.introblack.alpha = 1; 

	players = GET_PLAYERS();
	for(i = 0; i < players.size; i++)
	{
		players[i] freezecontrols(true);
	}

	wait time;
}

fade_in( hold_black_time )
{
	if( !IsDefined(level.introblack) )
	{
		level.introblack = NewHudElem(); 
		level.introblack.x = 0; 
		level.introblack.y = 0; 
		level.introblack.horzAlign = "fullscreen"; 
		level.introblack.vertAlign = "fullscreen"; 
		level.introblack.foreground = true;
		level.introblack SetShader( "black", 640, 480 );
		level.introblack.alpha = 1; 
		wait .05;
	}

	level.introblack.alpha = 1; 

	if( IsDefined( hold_black_time ) )
		wait hold_black_time;
	else
		wait .2;
	
	level.introblack FadeOverTime( 1.5 ); 
	level.introblack.alpha = 0; 
	
	level notify("fade_introblack");

	wait 1.5;

	players = GET_PLAYERS();
	for(i = 0; i < players.size; i++)
	{
		players[i] freezecontrols(false);
	}
	level notify("fade_in_complete");
}
*/

register_lethal_grenade_for_level( weaponname )
{
	if ( is_lethal_grenade( weaponname ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_lethal_grenade_list ) )
	{
		level.zombie_lethal_grenade_list = [];
	}

	level.zombie_lethal_grenade_list[level.zombie_lethal_grenade_list.size] = weaponname;
}


is_lethal_grenade( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( level.zombie_lethal_grenade_list ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_lethal_grenade_list.size; i++ )
	{
		if ( weaponname == level.zombie_lethal_grenade_list[i] )
		{
			return true;
		}
	}
	
	return false;
}


is_player_lethal_grenade( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( self.current_lethal_grenade ) )
	{
		return false;
	}

	return self.current_lethal_grenade == weaponname;
}


get_player_lethal_grenade()
{
	grenade = "";
	
	if(IsDefined(self.current_lethal_grenade))
	{
		grenade = self.current_lethal_grenade;
	}
	
	return grenade;
}


set_player_lethal_grenade( weaponname )
{
	self.current_lethal_grenade = weaponname;
}


init_player_lethal_grenade()
{
	self set_player_lethal_grenade( level.zombie_lethal_grenade_player_init );
}


register_tactical_grenade_for_level( weaponname )
{
	if ( is_tactical_grenade( weaponname ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_tactical_grenade_list ) )
	{
		level.zombie_tactical_grenade_list = [];
	}

	level.zombie_tactical_grenade_list[level.zombie_tactical_grenade_list.size] = weaponname;
}


is_tactical_grenade( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( level.zombie_tactical_grenade_list ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_tactical_grenade_list.size; i++ )
	{
		if ( weaponname == level.zombie_tactical_grenade_list[i] )
		{
			return true;
		}
	}
	
	return false;
}


is_player_tactical_grenade( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( self.current_tactical_grenade ) )
	{
		return false;
	}

	return self.current_tactical_grenade == weaponname;
}


get_player_tactical_grenade()
{
	return self.current_tactical_grenade;
}


set_player_tactical_grenade( weaponname )
{
	self.current_tactical_grenade = weaponname;
}


init_player_tactical_grenade()
{
	self set_player_tactical_grenade( level.zombie_tactical_grenade_player_init );
}


register_placeable_mine_for_level( weaponname )
{
	if ( is_placeable_mine( weaponname ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_placeable_mine_list ) )
	{
		level.zombie_placeable_mine_list = [];
	}

	level.zombie_placeable_mine_list[level.zombie_placeable_mine_list.size] = weaponname;
}


is_placeable_mine( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( level.zombie_placeable_mine_list ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_placeable_mine_list.size; i++ )
	{
		if ( weaponname == level.zombie_placeable_mine_list[i] )
		{
			return true;
		}
	}
	
	return false;
}


is_player_placeable_mine( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( self.current_placeable_mine ) )
	{
		return false;
	}

	return self.current_placeable_mine == weaponname;
}


get_player_placeable_mine()
{
	return self.current_placeable_mine;
}


set_player_placeable_mine( weaponname )
{
	self.current_placeable_mine = weaponname;
}


init_player_placeable_mine()
{
	self set_player_placeable_mine( level.zombie_placeable_mine_player_init );
}


register_melee_weapon_for_level( weaponname )
{
	if ( is_melee_weapon( weaponname ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_melee_weapon_list ) )
	{
		level.zombie_melee_weapon_list = [];
	}

	level.zombie_melee_weapon_list[level.zombie_melee_weapon_list.size] = weaponname;
}


is_melee_weapon( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( level.zombie_melee_weapon_list ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_melee_weapon_list.size; i++ )
	{
		if ( weaponname == level.zombie_melee_weapon_list[i] )
		{
			return true;
		}
	}
	
	return false;
}


is_player_melee_weapon( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( self.current_melee_weapon ) )
	{
		return false;
	}

	return self.current_melee_weapon == weaponname;
}


get_player_melee_weapon()
{
	return self.current_melee_weapon;
}


set_player_melee_weapon( weaponname )
{
	self.current_melee_weapon = weaponname;
}


init_player_melee_weapon()
{
	self set_player_melee_weapon( level.zombie_melee_weapon_player_init );
}

register_equipment_for_level( weaponname )
{
	if ( is_equipment( weaponname ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_equipment_list ) )
	{
		level.zombie_equipment_list = [];
	}

	level.zombie_equipment_list[level.zombie_equipment_list.size] = weaponname;
}


is_equipment( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( level.zombie_equipment_list ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_equipment_list.size; i++ )
	{
		if ( weaponname == level.zombie_equipment_list[i] )
		{
			return true;
		}
	}
	
	return false;
}


is_player_equipment( weaponname )
{
	if ( !isdefined( weaponname ) || !isdefined( self.current_equipment ) )
	{
		return false;
	}

	return self.current_equipment == weaponname;
}


get_player_equipment()
{
	return self.current_equipment;
}

hacker_active()
{
	return(self maps\mp\zombies\_zm_equipment::is_equipment_active("equip_hacker_zm"));
}

set_player_equipment( weaponname )
{
	if(!IsDefined(self.current_equipment_active))
	{
		self.current_equipment_active = [];
	}
	
	if(IsDefined(weaponname))
	{
		self.current_equipment_active[weaponname] = false;
	}
	
	if(!IsDefined(self.equipment_got_in_round))
	{
		self.equipment_got_in_round = [];
	}
	
	if(IsDefined(weaponname))
	{
		self.equipment_got_in_round[weaponname] = level.round_number;
	}
	
	self.current_equipment = weaponname;
}


init_player_equipment()
{
	self set_player_equipment( level.zombie_equipment_player_init );
}


register_offhand_weapons_for_level_defaults()
{
	if ( isdefined( level.register_offhand_weapons_for_level_defaults_override ) )
	{
		[[ level.register_offhand_weapons_for_level_defaults_override ]]();
		return;
	}

	register_lethal_grenade_for_level( "frag_grenade_zm" );
	level.zombie_lethal_grenade_player_init = "frag_grenade_zm";

	register_tactical_grenade_for_level( "zombie_cymbal_monkey" );
	level.zombie_tactical_grenade_player_init = undefined;

	register_placeable_mine_for_level( "claymore_zm" );
	level.zombie_placeable_mine_player_init = undefined;

	register_melee_weapon_for_level( "knife_zm" );
	register_melee_weapon_for_level( "bowie_knife_zm" );
	level.zombie_melee_weapon_player_init = "knife_zm";
	
	level.zombie_equipment_player_init = undefined;
}


init_player_offhand_weapons()
{
	init_player_lethal_grenade();
	init_player_tactical_grenade();
	init_player_placeable_mine();
	init_player_melee_weapon();
	init_player_equipment();
}


is_offhand_weapon( weaponname )
{
	return (is_lethal_grenade( weaponname ) || is_tactical_grenade( weaponname ) || is_placeable_mine( weaponname ) || is_melee_weapon( weaponname ) || is_equipment( weaponname ) );
}


is_player_offhand_weapon( weaponname )
{
	return (self is_player_lethal_grenade( weaponname ) || self is_player_tactical_grenade( weaponname ) || self is_player_placeable_mine( weaponname )  || self is_player_melee_weapon( weaponname ) || self is_player_equipment( weaponname ) );
}


has_powerup_weapon()
{
	return is_true( self.has_powerup_weapon );
}


give_start_weapon( switch_to_weapon )
{
	self GiveWeapon( level.start_weapon );
	self GiveStartAmmo( level.start_weapon );
	if ( is_true( switch_to_weapon ) )
	{
		self SwitchToWeapon( level.start_weapon );
	}
}




array_flag_wait_any( flag_array )
{
	if( !IsDefined ( level._array_flag_wait_any_calls ) )
	{
		level._n_array_flag_wait_any_calls = 0;
	}
	else
	{
		level._n_array_flag_wait_any_calls ++; // Used to ensure that we can have multiple calls to this concurrently, that don't interfere with each other.
	}
	
	str_condition = "array_flag_wait_call_" + level._n_array_flag_wait_any_calls;
	
	for(index = 0; index < flag_array.size; index ++)
	{
		level thread array_flag_wait_any_thread ( flag_array[ index ], str_condition );
	}
		
	level waittill( str_condition );
                
}

array_flag_wait_any_thread( flag_name, condition )
{
  level endon( condition );
  
  flag_wait( flag_name );
  
  level notify( condition );
}


/@
"Name: array_removeDead( <array> )"
"Summary: Returns a new array of < array > minus the dead entities"
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : The array to search for dead entities in."
"Example: friendlies = array_removeDead( friendlies );"
"SPMP: singleplayer"
@/ 

array_removeDead( array )
{
	newArray = []; 

	if( !IsDefined( array ) )
	{
		return undefined;		
	}

	for( i = 0; i < array.size; i++ )
	{
		//GLocke: the .isacorpse is a value specific to physics vehicles because they never become vehicle_corpse entities
		if( !isalive( array[ i ] ) || ( isDefined( array[i].isacorpse) && array[i].isacorpse) )
		{
			continue; 
		}
		newArray[ newArray.size ] = array[ i ];
	}

	return newArray; 
}


groundpos( origin )
{
	return bullettrace( origin, ( origin + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
}

groundpos_ignore_water( origin )
{
	return bullettrace( origin, ( origin + ( 0, 0, -100000 ) ), 0, self, true )[ "position" ];
}

groundpos_ignore_water_new( origin )
{
	return groundtrace( origin, ( origin + ( 0, 0, -100000 ) ), 0, self, true )[ "position" ];
}


/@
"Name: waittill_notify_or_timeout( <msg>, <timer> )"
"Summary: Waits until the owner receives the specified notify message or the specified time runs out. Do not thread this!"
"Module: Utility"
"CallOn: an entity"
"Example: tank waittill_notify_or_timeout( "turret_on_target", 10 ); "
"MandatoryArg: <msg> : The notify to wait for."
"MandatoryArg: <timer> : The amount of time to wait until overriding the wait statement."
"SPMP: singleplayer"
@/
waittill_notify_or_timeout( msg, timer )
{
	self endon( msg ); 
	wait( timer ); 
}

/@
"Name: self_delete()"
"Summary: Just calls the delete() script command on self. Reason for this is so that we can use array_thread to delete entities"
"Module: Entity"
"CallOn: An entity"
"Example: ai[ 0 ] thread self_delete();"
"SPMP: singleplayer"
@/ 
self_delete()
{
	if (IsDefined(self))
	{
		self delete();
	}
}


script_delay()
{
	if( IsDefined( self.script_delay ) )
	{
		wait( self.script_delay ); 
		return true;
	}
	else if( IsDefined( self.script_delay_min ) && IsDefined( self.script_delay_max ) )
	{
		wait( RandomFloatrange( self.script_delay_min, self.script_delay_max ) ); 
		return true;
	}

	return false;
}







button_held_think(which_button)
{
	self endon("disconnect");

	if (!IsDefined(self._holding_button))
	{
		self._holding_button = [];
	}
	
	self._holding_button[which_button] = false;
	
	time_started = 0;
	use_time = 250; // GetDvarInt("g_useholdtime");

	while(1)
	{
		if(self._holding_button[which_button])
		{
			if(!self [[level._button_funcs[which_button]]]())
			{
				self._holding_button[which_button] = false;
			}
		}
		else
		{
			if(self [[level._button_funcs[which_button]]]())
			{
				if(time_started == 0)
				{
					time_started = GetTime();
				}

				if((GetTime() - time_started) > use_time)
				{
					self._holding_button[which_button] = true;
				}
			}
			else
			{
				if(time_started != 0)
				{
					time_started = 0;
				}
			}
		}

		wait(0.05);
	}
}

/@
"Name: use_button_held()"
"Summary: Returns true if the player is holding down their use button."
"Module: Player"
"Example: if(player use_button_held())"
"SPMP: SP"
@/

use_button_held()
{
	init_button_wrappers();

	if(!IsDefined(self._use_button_think_threaded))
	{
		self thread button_held_think(level.BUTTON_USE);
		self._use_button_think_threaded = true;
	}

	return self._holding_button[level.BUTTON_USE];
}

/@
"Name: ads_button_held()"
"Summary: Returns true if the player is holding down their ADS button."
"Module: Player"
"Example: if(player ads_button_held())"
"SPMP: SP"
@/

ads_button_held()
{
	init_button_wrappers();

	if(!IsDefined(self._ads_button_think_threaded))
	{
		self thread button_held_think(level.BUTTON_ADS);
		self._ads_button_think_threaded = true;
	}

	return self._holding_button[level.BUTTON_ADS];
}

/@
"Name: attack_button_held()"
"Summary: Returns true if the player is holding down their attack button."
"Module: Player"
"Example: if(player attack_button_held())"
"SPMP: SP"
@/

attack_button_held()
{
	init_button_wrappers();

	if(!IsDefined(self._attack_button_think_threaded))
	{
		self thread button_held_think(level.BUTTON_ATTACK);
		self._attack_button_think_threaded = true;
	}

	return self._holding_button[level.BUTTON_ATTACK];
}

// button pressed wrappers
use_button_pressed()
{
	return (self UseButtonPressed());
}

ads_button_pressed()
{
	return (self AdsButtonPressed());
}

attack_button_pressed()
{
	return (self AttackButtonPressed());
}

init_button_wrappers()
{
	if (!IsDefined(level._button_funcs))
	{
		level.BUTTON_USE	= 0;
		level.BUTTON_ADS	= 1;
		level.BUTTON_ATTACK	= 2;

		level._button_funcs[level.BUTTON_USE]		= ::use_button_pressed;
		level._button_funcs[level.BUTTON_ADS]		= ::ads_button_pressed;
		level._button_funcs[level.BUTTON_ATTACK]	= ::attack_button_pressed;
	}
}


/@
"Name: wait_network_frame()"
"Summary: Wait until a snapshot is acknowledged.  Can help control having too many spawns in one frame."
"Module: Utility"
"Example: wait_network_frame();"
"SPMP: singleplayer"
@/ 
wait_network_frame()
{
	if ( NumRemoteClients() )
	{
		snapshot_ids = getsnapshotindexarray();

		acked = undefined;
		while ( !IsDefined( acked ) )
		{
			level waittill( "snapacknowledged" );
			acked = snapshotacknowledged( snapshot_ids );
		} 
	}
	else
	{
		wait(0.1);
	}
}


/@
"Name: ignore_triggers( <timer> )"
"Summary: Makes the entity that this is threaded on not able to set off triggers for a certain length of time."
"Module: Utility"
"CallOn: an entity"
"Example: guy thread ignore_triggers( 0.2 );"
"SPMP: singleplayer"
@/ 
ignore_triggers( timer )
{
	// ignore triggers for awhile so others can trigger the trigger we're in.
	self endon( "death" ); 
	self.ignoreTriggers = true; 
	if( IsDefined( timer ) )
	{
		wait( timer ); 
	}
	else
	{
		wait( 0.5 ); 
	}
	self.ignoreTriggers = false; 
}



/@
"Name: giveachievement_wrapper( <achievment>, [all_players] )"
"Summary: Gives an Achievement to the specified player"
"Module: Mp"
"MandatoryArg: <achievment>: The code string for the achievement"
"OptionalArg: [all_players]: If true, then give everyone the achievement"
"Example: player giveachievement_wrapper( "MAK_ACHIEVEMENT_RYAN" );"
"SPMP: singleplayer"
@/
giveachievement_wrapper( achievement, all_players )
{
	if ( achievement == "" )
	{
		return;
	}

	if ( IsDefined( all_players ) && all_players )
	{
		players = GET_PLAYERS();
		for ( i = 0; i < players.size; i++ )
		{
			players[i] GiveAchievement( achievement );
		}
	}
	else
	{
		if ( !IsPlayer( self ) )
		{
		/#	println( "^1self needs to be a player for _utility::giveachievement_wrapper()" );	#/
			return;
		}

		self GiveAchievement( achievement );
	}
}


/@
"Name: spawn_failed( <spawn> )"
"Summary: Checks to see if the spawned AI spawned correctly or had errors. Also waits until all spawn initialization is complete. Returns true or false."
"Module: AI"
"CallOn: "
"MandatoryArg: <spawn> : The actor that just spawned"
"Example: spawn_failed( level.price );"
"SPMP: singleplayer"
@/ 
spawn_failed( spawn )
{
	if ( IsDefined(spawn) && IsAlive(spawn) )
	{
		/*
		if ( !IsDefined(spawn.finished_spawning) )
		{
			spawn waittill("finished spawning"); 
		}
		*/

		//waittillframeend;

		if ( IsAlive(spawn) )
		{
			return false; 
		}
	}

	return true; 
}


GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}


GetYawToSpot(spot)
{
	pos = spot;
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}


/* 
============= 
///ScriptDocBegin
"Name: add_spawn_function( <func> , <param1> , <param2> , <param3>, <param4> )"
"Summary: Anything that spawns from this spawner will run this function. Anything."
"Module: Utility"
"MandatoryArg: <func1> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"Example: spawner add_spawn_function( ::do_the_amazing_thing, some_amazing_parameter );"
"SPMP: zm"
///ScriptDocEnd
============= 
*/ 
add_spawn_function( function, param1, param2, param3, param4 )
{
	Assert( !IsDefined( level._loadStarted ) || !IsAlive( self ), "Tried to add_spawn_function to a living guy." );

	func = []; 
	func[ "function" ] = function;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;

	if (!IsDefined(self.spawn_funcs))
	{
		self.spawn_funcs = [];
	}

	self.spawn_funcs[ self.spawn_funcs.size ] = func;
}



/*
=============
///ScriptDocBegin
"Name: disable_react()"
"Summary: Disables reaction behavior of given AI"
"Module: Utility"
"CallOn: An ai"
"Example: level.zakhaev disable_react();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
disable_react()
{
	assert( isalive( self ), "Tried to disable react on a non ai" );
	self.a.disableReact = true;
	self.allowReact = false;
}


/*
=============
///ScriptDocBegin
"Name: enable_react()"
"Summary: Enables reaction behavior of given AI"
"Module: Utility"
"CallOn: An ai"
"Example: level.zakhaev enable_react();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
enable_react()
{
	assert( isalive( self ), "Tried to enable react on a non ai" );
	self.a.disableReact = false;
	self.allowReact = true;
}



/* 
============= 
///ScriptDocBegin
"Name: flag_wait_or_timeout( <flagname> , <timer> )"
"Summary: Waits until either the flag gets set or the timer elapses."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname1: Name of one flag to wait on"
"MandatoryArg: <timer> : Amount of time to wait before continuing regardless of flag."
"Example: flag_wait_or_timeout( "time_to_go", 3 );"
"SPMP: singleplayer"
///ScriptDocEnd
============= 
*/ 
flag_wait_or_timeout( flagname, timer )
{
	start_time = gettime();
	for( ;; )
	{
		if( level.flag[ flagname ] )
		{
			break;
		}

		if( gettime() >= start_time + timer * 1000 )
		{
			break;
		}

		wait_for_flag_or_time_elapses( flagname, timer );
	}
}

wait_for_flag_or_time_elapses( flagname, timer )
{
	level endon( flagname );
	wait( timer );
}



/@
"Name: isADS()"
"Summary: Returns true if the player is more than 50% ads"
"Module: Utility"
"Example: player_is_ads = isADS();"
"SPMP: singleplayer"
@/
isADS( player )
{
	return ( player playerADS() > 0.5 );
}


// MikeD (12/15/2007): IW abandoned the auto-adjust feature, however, we can use it for stats?
// SCRIPTER_MOD: JesseS (4/14/2008):  Added back in for Arcade mode
bullet_attack( type )
{
	if ( type == "MOD_PISTOL_BULLET" )
	{
		return true;
	}
	return type == "MOD_RIFLE_BULLET";
}



pick_up()
{
	player = self.owner;
	self destroy_ent();
	
	clip_ammo = player GetWeaponAmmoClip( self.name );
	clip_max_ammo = WeaponClipSize( self.name );
	if( clip_ammo < clip_max_ammo )
	{
		clip_ammo++;
	}
	player SetWeaponAmmoClip( self.name, clip_ammo );
}

destroy_ent()
{
	self delete();
}


/@
"Name: waittill_not_moving()"
"Summary: waits for the object to stop moving"
"Module: Utility"
"CallOn: Object that moves like a thrown grenade"
"Example: self waittill_not_moving();"
"SPMP: singleplayer"
@/ 
waittill_not_moving()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "detonated" );
	level endon( "game_ended" );

	prevorigin = self.origin;
	while(1)
	{
		wait .15;
		if ( self.origin == prevorigin )
			break;
		prevorigin = self.origin;
	}
}


/@
"Name: get_closest_player( <org> )"
"Summary: Returns the closest player to the given origin."
"Module: Coop"
"MandatoryArg: <origin>: The vector to use to compare the distances to"
"Example: closest_player = get_closest_player( objective.origin );"
"SPMP: singleplayer"
@/
get_closest_player( org )
{
	players = [];
	players = GET_PLAYERS(); 
	return GetClosest( org, players ); 
}





/@
"Name: ent_flag_wait( <flagname> )"
"Summary: Waits until the specified flag is set on self. Even handles some default flags for ai such as 'goal' and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to wait on"
"Example: enemy ent_flag_wait( "goal" );"
"SPMP: singleplayer"
@/ 
ent_flag_wait( msg )
{
	self endon("death");

	while (!self.ent_flag[ msg ])
	{
		self waittill(msg);
	}
}

/@
"Name: ent_flag_wait_either( <flagname1> , <flagname2> )"
"Summary: Waits until either of the the specified flags are set on self. Even handles some default flags for ai such as 'goal' and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname1> : name of one flag to wait on"
"MandatoryArg: <flagname2> : name of the other flag to wait on"
"Example: enemy ent_flag_wait( "goal", "damage" );"
"SPMP: singleplayer"
@/ 
ent_flag_wait_either( flag1, flag2 )
{
	self endon ("death");

	for( ;; )
	{
		if (ent_flag( flag1 ))
		{
			return;
		}
		if (ent_flag( flag2 ))
		{
			return;
		}

		self waittill_either( flag1, flag2 );
	}
}

ent_wait_for_flag_or_time_elapses( flagname, timer )
{
	self endon( flagname );
	wait( timer );
}

/@
"Name: ent_flag_wait_or_timeout( <flagname> , <timer> )"
"Summary: Waits until either the flag gets set on self or the timer elapses. Even handles some default flags for ai such as 'goal' and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname1: Name of one flag to wait on"
"MandatoryArg: <timer> : Amount of time to wait before continuing regardless of flag."
"Example: ent_flag_wait_or_timeout( "time_to_go", 3 );"
"SPMP: singleplayer"
@/ 
ent_flag_wait_or_timeout( flagname, timer )
{
	self endon("death");

	start_time = gettime();
	for( ;; )
	{
		if( self.ent_flag[ flagname ] )
		{
			break;
		}

		if( gettime() >= start_time + timer * 1000 )
		{
			break;
		}

		self ent_wait_for_flag_or_time_elapses( flagname, timer );
	}
}

ent_flag_waitopen( msg )
{
	self endon("death");

	while( self.ent_flag[ msg ] )
	{
		self waittill( msg );
	}
}

/@
"Name: ent_flag_init( <flagname> )"
"Summary: Initialize a flag to be used. All flags must be initialized before using ent_flag_set or ent_flag_wait.  Some flags for ai are set by default such as 'goal', 'death', and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to create"
"Example: enemy ent_flag_init( "hq_cleared" );"
"SPMP: singleplayer"
@/ 
ent_flag_init( message, val )
{
	if( !IsDefined( self.ent_flag ) )
	{
		self.ent_flag = [];
		self.ent_flags_lock = [];
	}
	
	if ( !IsDefined( level.first_frame ) )
	{
		assert( !IsDefined( self.ent_flag[ message ] ), "Attempt to reinitialize existing flag '" + message + "' on entity.");
	}

	if (is_true(val))
	{
		self.ent_flag[ message ] = true;

		/#
			self.ent_flags_lock[ message ] = true;
		#/
	}
	else
	{
		self.ent_flag[ message ] = false;

		/#
			self.ent_flags_lock[ message ] = false;
		#/
	}
}

/@
"Name: ent_flag_exist( <flagname> )"
"Summary: checks to see if a flag exists"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to check"
"Example: if( enemy ent_flag_exist( "hq_cleared" ) );"
"SPMP: singleplayer"
@/
ent_flag_exist( message )
{
	if ( IsDefined( self.ent_flag ) && IsDefined( self.ent_flag[ message ] ) )
		return true;
	return false;
}

/@
"Name: ent_flag_set_delayed( <flagname> , <delay> )"
"Summary: Sets the specified flag after waiting the delay time on self, all scripts using ent_flag_wait on self will now continue."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to set"
"MandatoryArg: <delay> : time to wait before setting the flag"
"Example: entity flag_set_delayed( "hq_cleared", 2.5 );"
"SPMP: singleplayer"
@/ 
ent_flag_set_delayed( message, delay )
{
	wait( delay ); 
	self ent_flag_set( message );
}

/@
"Name: ent_flag_set( <flagname> )"
"Summary: Sets the specified flag on self, all scripts using ent_flag_wait on self will now continue."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to set"
"Example: enemy ent_flag_set( "hq_cleared" );"
"SPMP: singleplayer"
@/ 
ent_flag_set( message )
{
	/#

	assert( IsDefined( self ), "Attempt to set a flag on entity that is not defined" );
	assert( IsDefined( self.ent_flag[ message ] ), "Attempt to set a flag before calling flag_init: '" + message + "'." );
	assert( self.ent_flag[ message ] == self.ent_flags_lock[ message ] );
	self.ent_flags_lock[ message ] = true;
	
	#/

	self.ent_flag[ message ] = true;
	self notify( message );
}

/@
"Name: ent_flag_toggle( <flagname> )"
"Summary: Toggles the specified ent flag."
"Module: Flag"
"MandatoryArg: <flagname> : name of the flag to toggle"
"Example: ent_flag_toggle( "hq_cleared" );"
"SPMP: SP"
@/ 
ent_flag_toggle( message )
{
	if (self ent_flag(message))
	{
		self ent_flag_clear(message);
	}
	else
	{
		self ent_flag_set(message);
	}
}

/@
"Name: ent_flag_clear( <flagname> )"
"Summary: Clears the specified flag on self."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to clear"
"Example: enemy ent_flag_clear( "hq_cleared" );"
"SPMP: singleplayer"
@/ 
ent_flag_clear( message )
{
	/#

	assert( IsDefined( self ), "Attempt to clear a flag on entity that is not defined" );
	assert( IsDefined( self.ent_flag[ message ] ), "Attempt to set a flag before calling flag_init: '" + message + "'." );
	assert( self.ent_flag[ message ] == self.ent_flags_lock[ message ] );
	self.ent_flags_lock[ message ] = false;

	#/	

	//do this check so we don't unnecessarily send a notify
	if(	self.ent_flag[ message ] )
	{
		self.ent_flag[ message ] = false;
		self notify( message );
	}
}

ent_flag_clear_delayed( message, delay )
{
	wait( delay );
	self ent_flag_clear( message );
}

/@
"Name: ent_flag( <flagname> )"
"Summary: Checks if the flag is set on self. Returns true or false."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to check"
"Example: enemy ent_flag( "death" );"
"SPMP: singleplayer"
@/ 
ent_flag( message )
{
	assert( IsDefined( message ), "Tried to check flag but the flag was not defined." );
	assert( IsDefined( self.ent_flag[ message ] ), "Tried to check entity flag '" + message + "', but the flag was not initialized.");

	if( !self.ent_flag[ message ] )
	{
		return false; 
	}

	return true; 
}

ent_flag_init_ai_standards()
{
	message_array = [];

	message_array[ message_array.size ] = "goal";
	message_array[ message_array.size ] = "damage";

	for( i = 0; i < message_array.size; i++)
	{
		self ent_flag_init( message_array[ i ] );
		self thread ent_flag_wait_ai_standards( message_array[ i ] );
	}	
}

ent_flag_wait_ai_standards( message )
{
	/*
	only runs the first time on the message, so for 
	example if it's waiting on goal, it will only set
	the goal to true the first time.  It also doesn't 
	call ent_set_flag() because that would notify the 
	message possibly twice in the same frame, or worse 
	in the next frame.
	*/
	self endon("death");
	self waittill( message );
	self.ent_flag[ message ] = true;
}


/@
"Name: flat_angle( <angle> )"
"Summary: Returns the specified angle as a flat angle.( 45, 90, 30 ) becomes( 0, 90, 0 ). Useful if you just need an angle around Y - axis."
"Module: Vector"
"CallOn: "
"MandatoryArg: <angle> : angles to flatten"
"Example: yaw = flat_angle( node.angles );"
"SPMP: singleplayer"
@/ 
flat_angle( angle )
{
	rangle = ( 0, angle[ 1 ], 0 );
	return rangle; 
}


/@
"Name: waittill_any_or_timeout( <timer>, <msg1>, <msg2>, <msg3>, <msg4>, <msg5> )"
"Summary: Waits until the owner receives the specified notify message or the specified time runs out. Do not thread this!"
"Module: Utility"
"CallOn: an entity"
"Example: tank waittill_any_or_timeout( 10, "turret_on_target"); "
"MandatoryArg: <timer> : The amount of time to wait until overriding the wait statement."
"MandatoryArg: <msg1> : The notify to wait for."
"MandatoryArg: <msg2> : The notify to wait for."
"MandatoryArg: <msg3> : The notify to wait for."
"MandatoryArg: <msg4> : The notify to wait for."
"MandatoryArg: <msg5> : The notify to wait for."
"SPMP: singleplayer"
@/
waittill_any_or_timeout( timer, string1, string2, string3, string4, string5  )
{
	assert( IsDefined( string1 ) );
	
	self endon( string1 );
	
	if ( IsDefined( string2 ) )
	{
		self endon( string2 );
	}

	if ( IsDefined( string3 ) )
	{
		self endon( string3 );
	}

	if ( IsDefined( string4 ) )
	{
		self endon( string4 );
	}

	if ( IsDefined( string5 ) )
	{
		self endon( string5 );
	}
			
	wait( timer ); 
}


/@
"Name: clear_run_anim()"
"Summary: Clears any set run anims "
"Module: AI"
"CallOn: an actor"
"Example: guy clear_run_anim();"
"SPMP: singleplayer"
@/ 
clear_run_anim()
{
	self.alwaysRunForward = undefined;
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = undefined;
	self.walk_combatanim = undefined;
	self.walk_noncombatanim = undefined;
	self.preCombatRunEnabled = true;
}

track_players_intersection_tracker()
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "end_game" );

	wait( 5 );
	
	while ( 1 )
	{
		killed_players = false;
		players = GET_PLAYERS();
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() || "playing" != players[i].sessionstate )					
			{
				continue;
			}
			
			for ( j = 0; j < players.size; j++ )
			{
				if ( i == j  || players[j] maps\mp\zombies\_zm_laststand::player_is_in_laststand() || "playing" != players[j].sessionstate )
				{
					continue;
				}
				
				if ( isDefined( level.player_intersection_tracker_override ) )
				{
					if ( players[i] [[level.player_intersection_tracker_override]]( players[j] ) )
					{
						continue;
					}
				}

				playerI_origin = players[i].origin;
				playerJ_origin = players[j].origin;
				
				//Check height first
				if ( abs(playerI_origin[2] - playerJ_origin[2] ) > 60 )
					continue;
					
				//Check 2d distance	
				distance_apart = distance2d( playerI_origin, playerJ_origin );
				//IPrintLnBold( "player=", i, ",", j, "distance_apart=", distance_apart );
				
				if ( abs(distance_apart) > 18 )
					continue;
					
				IPrintLnBold( "PLAYERS ARE TOO FRIENDLY!!!!!" );
				players[i] dodamage( 1000, (0, 0, 0) );
				players[j] dodamage( 1000, (0, 0, 0) );

				if ( !killed_players )
				{
					if( is_true( level.player_4_vox_override ) )
					{
						players[i] playlocalsound( "zmb_laugh_rich" );
					}
					else
					{
						players[i] playlocalsound( "zmb_laugh_child" );	
					}
				}
				killed_players = true;
			}	
		}
		wait( .5 );
	}
}


/@
"Name: get_eye()"
"Summary: Get eye position accurately even on a player when linked to an entity."
"Module: Utility"
"CallOn: Player or AI"
"Example: eye_pos = player get_eye();"
"SPMP: singleplayer"
@/
get_eye()
{
	if (IsPlayer(self))
	{
		linked_ent = self GetLinkedEnt();
		if (IsDefined(linked_ent) && (GetDvarint( "cg_cameraUseTagCamera") > 0))
		{
			camera = linked_ent GetTagOrigin("tag_camera");
			if (IsDefined(camera))
			{
				return camera;
			}
		}
	}

	pos = self GetEye();
	return pos;
}

/@
"Name: is_player_looking_at( <origin>, <dot>, <do_trace> )"
"Summary: Checks to see if the player can dot and trace to a point"
"Module: Player"
"CallOn: A Player"
"MandatoryArg: <org> The position you're checking if the player is looking at"
"OptionalArg: <dot> Optional override dot (between 0 and 1) the higher the number, the more the player has to be looking right at the spot."
"OptionalArg: <do_trace> Set to false to skip the bullet trace check"
"OptionalArg: <ignore_ent> Ignore ent passed to trace check"
"Example: if ( get_players()[0] is_player_looking_at( org.origin ) )"
"SPMP: zombies"
@/
is_player_looking_at(origin, dot, do_trace, ignore_ent)
{
	assert(IsPlayer(self), "player_looking_at must be called on a player.");

	if (!IsDefined(dot))
	{
		dot = .7;
	}

	if (!IsDefined(do_trace))
	{
		do_trace = true;
	}

	eye = self get_eye();

	delta_vec = AnglesToForward(VectorToAngles(origin - eye));
	view_vec = AnglesToForward(self GetPlayerAngles());
		
	new_dot = VectorDot( delta_vec, view_vec );
	if ( new_dot >= dot )
	{
		if (do_trace)
		{
			return BulletTracePassed( origin, eye, false, ignore_ent );
		}
		else
		{
			return true;
		}
	}
	
	return false;
}



/@
"Name: add_gametype()"
"Summary: dummy - Rex looks for these to populate the gametype pulldown"
"SPMP: zombies"
@/ 

add_gametype( gt, dummy1, name, dummy2 )
{
}

/@
"Name: add_gameloc()"
"Summary: dummy - Rex looks for these to populate the location pulldown"
"SPMP: zombies"
@/ 

add_gameloc( gl, dummy1, name, dummy2 )
{
}

/@
"Name: get_closest_index( <org> , <array> , <dist> )"
"Summary: same as getClosest but returns the closest entity's array index instead of the actual entity."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on."
"OptionalArg: <dist> : Maximum distance to check"
"Example: "
"SPMP: mp"
@/
get_closest_index( org, array, dist )
{
	if( !IsDefined( dist ) )
	{
		dist = 9999999;
	}
	distsq = dist*dist;
	if( array.size < 1 )
	{
		return;
	}
	index = undefined;
	for( i = 0;i < array.size;i++ )
	{
		newdistsq = distancesquared( array[ i ].origin, org );
		if( newdistsq >= distsq )
		{
			continue;
		}
		distsq = newdistsq;
		index = i;
	}
	return index;
}
