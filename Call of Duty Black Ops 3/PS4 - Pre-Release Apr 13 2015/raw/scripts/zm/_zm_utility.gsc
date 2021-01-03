#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     

#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_server_throttle;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_ai_faller;
#using scripts\zm\_zm_spawner;

                                                                                       	                                
                                                                                                                               

#namespace zm_utility;

function init_utility()
{
//	level thread edge_fog_start(); 

//	level thread hudelem_count(); 
}

function is_Classic()
{
	dvar = GetDvarString( "ui_zm_gamemodegroup" );
	
	if ( dvar == "zclassic" )
	{
		return true;
	}
	
	return false;
}

function is_Standard()
{
	dvar = GetDvarString( "ui_gametype" );
	
	if ( dvar == "zstandard" )
	{
		return true;
	}
	
	return false;
}


function ConvertSecondsToMilliseconds( seconds )
{
	return ( seconds * 1000 );
}

function is_player()
{
	return ( IsPlayer( self ) || ( IsDefined( self.pers ) && ( isdefined( self.pers[ "isBot" ] ) && self.pers[ "isBot" ] ) ) );
}

// self is Ai and chunk is selected piece
function lerp( chunk )
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
	
	link util::waittill_multiple("rotatedone", "movedone");

	self Unlink();
	link Delete();
	
	return;
}

// DCS 091610: delete any designated mature blood patches if set to mature.
function clear_mature_blood()
{
	blood_patch = GetEntArray("mature_blood", "targetname");

	if(util::is_mature())
		return;
	
	if(IsDefined(blood_patch))
	{
		for (i = 0; i < blood_patch.size; i++)
		{
			blood_patch[i] Delete();
		}	
	}
}	


function recalc_zombie_array()
{
/*	
	enemies = [];
	level.current_zombie_array = [];
	enemies = GetAiSpeciesArray( level.zombie_team, "all" );

	for( i = 0; i < enemies.size; i++ )
	{
		if ( IS_TRUE( enemies[i].ignore_enemy_count ) )
		{
			continue;
		}
		ARRAY_ADD( level.current_zombie_array, enemies[i] );
	}
	
	level.current_zombie_count = level.current_zombie_array.size;
*/
}

function init_zombie_run_cycle()
{
	if ( isdefined( level.speed_change_round ) )
	{
		if ( level.round_number >= level.speed_change_round )
		{
			speed_percent = 0.2 + ( ( level.round_number - level.speed_change_round ) * 0.2 );
			speed_percent = min( speed_percent, 1 );

			change_round_max = Int( level.speed_change_max * speed_percent );
			change_left = change_round_max - level.speed_change_num;

			if ( change_left == 0 )
			{
				self zombie_utility::set_zombie_run_cycle();
				return;
			}

			change_speed = RandomInt( 100 );
			if ( change_speed > 80 )
			{
				self change_zombie_run_cycle();
				return;
			}

			zombie_count = zombie_utility::get_current_zombie_count();
			zombie_left = level.zombie_ai_limit - zombie_count;

			if ( zombie_left == change_left )	// need to force the speed change at this point
			{
				self change_zombie_run_cycle();
				return;
			}
		}
	}

	self zombie_utility::set_zombie_run_cycle();
}

function change_zombie_run_cycle()
{
	level.speed_change_num++;
	if ( level.gamedifficulty == 0 )
	{
		self zombie_utility::set_zombie_run_cycle( "sprint" );
	}
	else
	{
		/*
			iprintln( "walker round " + level.round_number + " change " + level.speed_change_num );
		*/
		self zombie_utility::set_zombie_run_cycle( "walk" );
	}

	self thread speed_change_watcher();
}

function speed_change_watcher()
{
	self waittill( "death" );

	if ( level.speed_change_num > 0 )
	{
		level.speed_change_num--;
	}
}

function move_zombie_spawn_location(spot)
{
	self endon( "death" );
	
	if(IsDefined(self.spawn_pos))
	{
		self notify("risen", self.spawn_pos.script_string );
		return;
	}		
	self.spawn_pos = spot;
	
	// give target from spawn location to spawner to path
	if(IsDefined(spot.target))
	{
		self.target = spot.target;
	}	

	if(IsDefined(spot.zone_name))
	{
		self.zone_name = spot.zone_name;
	}	

	if(IsDefined(spot.script_parameters))
	{
		self.script_parameters = spot.script_parameters;
	}

	if(!IsDefined(spot.script_noteworthy))
	{
		spot.script_noteworthy = "spawn_location";
	}	

	tokens = StrTok( spot.script_noteworthy, " " );
	foreach ( index, token in tokens )
	{
		// time bomb needs to spawn zombies away from their original spawn point; this should point to a struct
		if ( IsDefined( self.spawn_point_override ) )
		{
			spot = self.spawn_point_override;
			token = spot.script_noteworthy;
		}
		
		if ( token == "custom_spawner_entry" )
		{
			next_token = index + 1;
			
			if ( IsDefined( tokens[ next_token ] ) )
			{
				str_spawn_entry = tokens[ next_token ];
				
				if ( IsDefined( level.custom_spawner_entry ) && IsDefined( level.custom_spawner_entry[ str_spawn_entry ] ) )
				{
					self thread [[ level.custom_spawner_entry[ str_spawn_entry ] ]]( spot );
					continue;
				}
			}
		}
		
		if(token == "riser_location")
		{
			self thread zm_spawner::do_zombie_rise(spot);
		}
		else if (token == "faller_location")
		{
			self thread zm_ai_faller::do_zombie_fall(spot);	
		}
		else if (token == "dog_location")
		{
			continue;	
		}
		else if (token == "screecher_location")
		{
			continue;	
		}
		else if (token == "raps_location" )
		{
			continue;
		}
		else if (token == "wasp_location" )
		{
			continue;
		}
		else // just spawn where at and go.
		{
			// anchor defined by some other custom spawner behavior, so bypass standard behavior
			if ( IsDefined( self.anchor ) )
			{
				return;
			}
				
			self.anchor = spawn("script_origin", self.origin);
			self.anchor.angles = self.angles;
			self linkto(self.anchor);
	
			if( !isDefined( spot.angles ) )
			{
				spot.angles = (0, 0, 0);
			}
			
			self Ghost();
			self.anchor moveto(spot.origin, .05);
			self.anchor waittill("movedone");
			
			// face goal
			target_org = zombie_utility::get_desired_origin();
			if (IsDefined(target_org))
			{
				anim_ang = VectorToAngles(target_org - self.origin);
				self.anchor RotateTo((0, anim_ang[1], 0), .05);
				self.anchor waittill("rotatedone");
			}
			if(isDefined(level.zombie_spawn_fx))
			{
				playfx(level.zombie_spawn_fx,spot.origin);
			}
			self unlink();
			if(isDefined(self.anchor))
			{
				self.anchor delete();
			}
			self Show();
			self notify("risen", spot.script_string );
		}
	}	
}	


function run_spawn_functions()
{
	self endon( "death" );

 	waittillframeend;	// spawn functions should override default settings, so they need to be last

	for (i = 0; i < level.spawn_funcs[ self.team ].size; i++)
	{
		func = level.spawn_funcs[ self.team ][ i ];
		util::single_thread(self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ], func[ "param5" ] );
	}

	if ( IsDefined( self.spawn_funcs ))
	{
		for (i = 0; i < self.spawn_funcs.size; i++)
		{
			func = self.spawn_funcs[ i ];
			util::single_thread(self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ] );
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


function create_simple_hud( client, team )
{
	if ( IsDefined( team ) )
	{
		hud = NewTeamHudElem( team );
		hud.team = team;
	}
	else
	{
		if( IsDefined( client ) )
		{
			hud = NewClientHudElem( client ); 
		}
		else
		{
			hud = NewHudElem(); 
		}
	}

	level.hudelem_count++; 

	hud.foreground = true; 
	hud.sort = 1; 
	hud.hidewheninmenu = false; 

	return hud; 
}

function destroy_hud()
{
	level.hudelem_count--; 
	self Destroy(); 
}


// self = exterior_goal which is barrier_chunks
function all_chunks_intact( barrier, barrier_chunks )
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
function no_valid_repairable_boards( barrier, barrier_chunks )
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

function is_Survival()
{
	dvar = GetDvarString( "ui_zm_gamemodegroup" );
	if(dvar == "zsurvival")
	{
		return true;
	}
	
	return false;
}

function is_Encounter()
{
	if(( isdefined( level._is_encounter ) && level._is_encounter ))
	{
		return true;
	}
	dvar = GetDvarString( "ui_zm_gamemodegroup" );
	if(dvar == "zencounter")
	{
		level._is_encounter = true;
		return true;
	}	
	
	return false;
}

function all_chunks_destroyed( barrier, barrier_chunks )
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
		ASSERT( IsDefined(barrier_chunks), "zombie_utility::all_chunks_destroyed - Barrier chunks undefined" );
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

function check_point_in_playable_area( origin )
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

//*****************************************************************************
// origin - 
// zone_is_active - (optional) if set the zone must also be active as well
// player_zones - (optional) optimization
//*****************************************************************************

//aka check_point_in_active_zone( origin )
function check_point_in_enabled_zone( origin, zone_is_active, player_zones )
{
	if( !IsDefined(player_zones) )
	{
		player_zones = getentarray("player_volume","script_noteworthy");
	}

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
			zone = level.zones[player_zones[i].targetname];

			if( IsDefined(zone) && ( isdefined( zone.is_enabled ) && zone.is_enabled ) )
			{
				if( IsDefined(zone_is_active) && (zone_is_active == true) && !( isdefined( zone.is_active ) && zone.is_active ) )
				{
					continue;
				}

				one_valid_zone = true;
				break;
			}
		}
	}
	
	scr_org delete();
	return one_valid_zone;
}

function round_up_to_ten( score )
{
	new_score = score - score % 10; 
	if( new_score < score )
	{
		new_score += 10; 
	}
	return new_score; 
}

function round_up_score( score, value )
{
	score = int(score);	// Make sure it's an int or modulus will die

	new_score = score - score % value; 
	if( new_score < score )
	{
		new_score += value; 
	}
	return new_score; 
}

function random_tan()
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
function places_before_decimal( num )
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

function create_zombie_point_of_interest( attract_dist, num_attractors, added_poi_value, start_turned_on, initial_attract_func, arrival_attract_func,poi_team )
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

function create_zombie_point_of_interest_attractor_positions( num_attract_dists, diff_per_dist, attractor_width )
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

function generated_radius_attract_positions( forward, offset, num_positions, attract_radius )
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
		else if(( isdefined( level.use_alternate_poi_positioning ) && level.use_alternate_poi_positioning ))
		{
			pos = zm_server_throttle::server_safe_ground_trace( "poi_trace", 10, self.origin + rotated_forward + ( 0, 0, 10 ) ); //only trace from 10 units above instead of 100 units
		}
		else
		{
			pos = zm_server_throttle::server_safe_ground_trace( "poi_trace", 10, self.origin + rotated_forward + ( 0, 0, 100 ) );
		}
		
		if(!isDefined(pos))
		{
			failed++;
			continue;
		}
		
		if(( isdefined( level.use_alternate_poi_positioning ) && level.use_alternate_poi_positioning ))
		{
			if ( isDefined( self ) && isDefined( self.origin ) )
			{
				if( self.origin[2] >= (pos[2]-epsilon) && self.origin[2] - pos[2] <= 150 )
				{
					pos_array = [];
					pos_array[0] = pos;
					pos_array[1] = self;
					if ( !isdefined( self.attractor_positions ) ) self.attractor_positions = []; else if ( !IsArray( self.attractor_positions ) ) self.attractor_positions = array( self.attractor_positions ); self.attractor_positions[self.attractor_positions.size]=pos_array;;
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
			if ( !isdefined( self.attractor_positions ) ) self.attractor_positions = []; else if ( !IsArray( self.attractor_positions ) ) self.attractor_positions = array( self.attractor_positions ); self.attractor_positions[self.attractor_positions.size]=pos_array;;
		}
		else
		{
			failed++;
		}
	}
	return failed;
}

function debug_draw_attractor_positions()
{
	/#
	while( true )
	{
		while( !isDefined( self.attractor_positions ) )
		{
			{wait(.05);};
			continue;
		}
		for( i = 0; i < self.attractor_positions.size; i++ )
		{
			Line( self.origin, self.attractor_positions[i][0], (1, 0, 0), true, 1 );
		}
		{wait(.05);};
		if( !IsDefined( self ) )
		{
			return;
		}
	}
	#/
}


function get_zombie_point_of_interest( origin, poi_array )
{
	if ( ( isdefined( self.ignore_all_poi ) && self.ignore_all_poi ) )
	{
		return undefined;
	}

	curr_radius = undefined;
	
	if ( isdefined( poi_array ) )
	{
		ent_array = poi_array;
	}
	else
	{
		ent_array = getEntArray( "zombie_poi", "script_noteworthy" );
	}
	
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
		if( ( isdefined( best_poi._new_ground_trace ) && best_poi._new_ground_trace ) ) // needed for the bhb so it won't trace through metal clip
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

function activate_zombie_point_of_interest()
{
	if( self.script_noteworthy != "zombie_poi" )
	{
		return;
	}
	
	self.poi_active = true;
}

function deactivate_zombie_point_of_interest()
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
function assign_zombie_point_of_interest (origin, poi)
{
	position = undefined;
	doremovalthread = false;

	if (IsDefined(poi) && poi can_attract(self))
	{
		//don't want to touch add poi attractor, but yeah, this is kind of weird
		if (!IsDefined(poi.attractor_array) || ( IsDefined(poi.attractor_array) && !IsInArray( poi.attractor_array, self ) ))
			doremovalthread = true;
		
		position = self add_poi_attractor( poi );
		
		//now that I know this is the first time they've been added, set up the thread to remove them from the array
		if (IsDefined(position) && doremovalthread && IsInArray( poi.attractor_array, self  ))
			self thread update_on_poi_removal( poi );		
	}
	
	return position;
}
//PI_CHANGE_END

function remove_poi_attractor( zombie_poi )
{
	if( !isDefined( zombie_poi ) || !isDefined( zombie_poi.attractor_array ) )
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

function array_check_for_dupes_using_compare( array, single, is_equal_fn )
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

function poi_locations_equal( loc1, loc2 )
{
	return loc1[0]==loc2[0];
}


function add_poi_attractor( zombie_poi )
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
	if( !IsInArray( zombie_poi.attractor_array, self ) )
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
			//if( !IsInArray( zombie_poi.claimed_attractor_positions, zombie_poi.attractor_positions[i] ) )
			if( array_check_for_dupes_using_compare( zombie_poi.claimed_attractor_positions, zombie_poi.attractor_positions[i], &poi_locations_equal ) )
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
		
		if ( !isdefined( zombie_poi.attractor_array ) ) zombie_poi.attractor_array = []; else if ( !IsArray( zombie_poi.attractor_array ) ) zombie_poi.attractor_array = array( zombie_poi.attractor_array ); zombie_poi.attractor_array[zombie_poi.attractor_array.size]=self;;
		self thread update_poi_on_death( zombie_poi );		
		
		if ( !isdefined( zombie_poi.claimed_attractor_positions ) ) zombie_poi.claimed_attractor_positions = []; else if ( !IsArray( zombie_poi.claimed_attractor_positions ) ) zombie_poi.claimed_attractor_positions = array( zombie_poi.claimed_attractor_positions ); zombie_poi.claimed_attractor_positions[zombie_poi.claimed_attractor_positions.size]=best_pos;;
		
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

function can_attract( attractor )
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
	if( IsInArray( self.attractor_array, attractor ) )
	{
		return true;
	}
	if( isDefined(self.num_poi_attracts) && self.attractor_array.size >= self.num_poi_attracts )
	{
		return false;
	}

	return true;
}

function update_poi_on_death( zombie_poi )
{
	self endon( "kill_poi" );
	
	self waittill( "death" );
	self remove_poi_attractor( zombie_poi );
}

//PI_CHANGE_BEGIN - 6/18/09 JV This was set up to work with assign_zombie_point_of_interest (which works with the teleportation in theater).
//The poi attractor array needs to be emptied when a player is teleported out of projection room (if they were all in there).  
//As a result, we wait for the poi's death (I'm sending that notify via the level script)
function update_on_poi_removal (zombie_poi )
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

function invalidate_attractor_pos( attractor_pos, zombie )
{
	if( !isDefined( self ) || !isDefined( attractor_pos ) )
	{
		wait( 0.1 );
		return undefined;
	}
	
	if( isDefined( self.attractor_positions) && !array_check_for_dupes_using_compare( self.attractor_positions, attractor_pos, &poi_locations_equal ) )
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

function remove_poi_from_ignore_list( poi )
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

function add_poi_to_ignore_list( poi )
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


//-------------------------------------------------------------------------------
// player should be within a couple feet of enemy	
//-------------------------------------------------------------------------------
function default_validate_enemy_path_length( player )
{
	max_dist = 1296;

	d = DistanceSquared( self.origin, player.origin );
	if ( d <= max_dist )
	{
		return true;
	}

	return false;
}

function get_closest_valid_player( origin, ignore_player )
{
	valid_player_found = false; 
	
	players = GetPlayers();	
	if( IsDefined( ignore_player ) )
	{
		for(i = 0; i < ignore_player.size; i++ )
		{
			ArrayRemoveValue( players, ignore_player[i] );
		}
	}

	// pre-cull any players that are in last stand 
	done = false; 
	while ( players.size && !done )
	{
		done = true;
		for(i = 0; i < players.size; i++ )
		{
			player = players[i];
			if( !is_player_valid( player, true ) )
			{
				ArrayRemoveValue( players, player ); 
				done = false;
				break;
			}
		}
	}
	
	if( players.size == 0 )
	{
		return undefined; 
	}
	
	while( !valid_player_found )
	{
		// find the closest player
		if( IsDefined( self.closest_player_override ) )
		{
			player = [[ self.closest_player_override ]]( origin, players );
		}
		else if( isdefined( level.closest_player_override ) )
		{
			player = [[ level.closest_player_override ]]( origin, players );
		}
		else
		{
			player = array::get_closest( origin, players );
		} 

		if( !isdefined( player ) || players.size == 0 )
		{
			return undefined; 
		}
		
		if( ( isdefined( level.allow_zombie_to_target_ai ) && level.allow_zombie_to_target_ai ) || ( isdefined( player.allow_zombie_to_target_ai ) && player.allow_zombie_to_target_ai ) )
			return player;

		// make sure they're not a zombie or in last stand
		if( !is_player_valid( player, true ) )
		{
			// unlikely to get here unless there is a wait in one of the closest player overrides
			ArrayRemoveValue( players, player ); 
			if( players.size == 0 )
			{
				return undefined;
			}
		
			continue;
		}
		
		return player; 
	}
}

function is_player_valid( player, checkIgnoreMeFlag,ignore_laststand_players )
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
	
	if( ( isdefined( self.intermission ) && self.intermission ) )
	{
		return false;
	}
	
	if(!( isdefined( ignore_laststand_players ) && ignore_laststand_players ))
	{
		if(  player laststand::player_is_in_laststand() )
		{
			return false; 
		}
	}

//T6.5todo	if ( player isnotarget() )
//T6.5todo	{
//T6.5todo		return false;
//T6.5todo	}
	
	//We only want to check this from the zombie attack script
	if( ( isdefined( checkIgnoreMeFlag ) && checkIgnoreMeFlag ) && player.ignoreme )
	{
		//IPrintLnBold(" ignore me ");
		return false;
	}
	
	//for additional level specific checks
	if( IsDefined( level.is_player_valid_override ) )
	{
		return [[ level.is_player_valid_override ]]( player );
	}
	
	return true; 
}

function get_number_of_valid_players()
{

	players = GetPlayers();
	num_player_valid = 0;
	for( i = 0 ; i < players.size; i++ )
	{
		if( is_player_valid( players[i] ) )
			num_player_valid += 1;
	}

	
	return num_player_valid;



}

function in_revive_trigger()
{
	if (isdefined(self.rt_time) && self.rt_time + 100 >= GetTime())
		return self.in_rt_cached;
	self.rt_time = GetTime();
	
	players = level.players;	//GetPlayers();
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
				self.in_rt_cached = true;
				return true;
			}
		}
	}

	self.in_rt_cached = false;
	return false;
}

function get_closest_node( org, nodes )
{
	return array::get_closest( org, nodes ); 
}

// bars are not damaged pull them off now.
function non_destroyed_bar_board_order( origin, chunks )
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


function non_destroyed_grate_order( origin, chunks_grate )
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
function non_destroyed_variant1_order( origin, chunks_variant1 )
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
function non_destroyed_variant2_order( origin, chunks_variant2 )
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
function non_destroyed_variant4_order( origin, chunks_variant4 )
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
function non_destroyed_variant5_order( origin, chunks_variant5 )
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

function show_grate_pull()
{
	wait(0.53);
	self Show();
	self vibrate(( 0, 270, 0 ), 0.2, 0.4, 0.4);
	// I could fx and sound from here as well.
}


function get_closest_2d( origin, ents )
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
			if ( !isdefined( temp_array ) ) temp_array = []; else if ( !IsArray( temp_array ) ) temp_array = array( temp_array ); temp_array[temp_array.size]=ents[i];;
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

//edge_fog_start()
//{
//	playpoint = struct::get( "edge_fog_start", "targetname" ); 
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
//		playpoint = struct::get( playpoint.target, "targetname" ); 
//	}
//}


//chris_p - fix bug with this not being an ent array!
function in_playable_area()
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
function get_closest_non_destroyed_chunk( origin, barrier, barrier_chunks ) 
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
			return array::randomize(chunks)[0];
		}
		
		if(isdefined(chunks_grate))
		{
			return array::randomize(chunks_grate)[0];
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
function get_random_destroyed_chunk( barrier, barrier_chunks )
{
	if(isdefined(barrier.zbarrier))
	{
		ret = undefined;
		
		pieces = barrier.zbarrier GetZBarrierPieceIndicesInState("open");
		
		if(pieces.size)
		{
			ret = array::randomize(pieces)[0];
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

function get_destroyed_repair_grates( barrier_chunks )
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
function get_non_destroyed_chunks( barrier, barrier_chunks )
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

function get_non_destroyed_chunks_grate( barrier, barrier_chunks )
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

function get_non_destroyed_variant1( barrier_chunks )
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

function get_non_destroyed_variant2( barrier_chunks )
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

function get_non_destroyed_variant4( barrier_chunks )
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

function get_non_destroyed_variant5( barrier_chunks )
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

function get_destroyed_chunks( barrier_chunks )
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


function grate_order_destroyed( chunks_repair_grate )
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
function show_grate_repair()
{
	wait( 0.34 );
	self Hide();
}

function get_chunk_state()
{
	assert( isdefined( self.state ) );

	return self.state;
}

function array_limiter( array, total )
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

function add_spawner( spawner )
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

function fake_physicslaunch( target_pos, power )
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
function add_zombie_hint( ref, text )
{
	if( !IsDefined( level.zombie_hints ) )
	{
		level.zombie_hints = []; 
	}

	level.zombie_hints[ref] = text; 
}

function get_zombie_hint( ref )
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
function set_hint_string( ent, default_ref, cost )
{
	ref = default_ref;
	if( IsDefined( ent.script_hint ) )
	{
		ref = ent.script_hint;
	}
	if ( ( isdefined( level.legacy_hint_system ) && level.legacy_hint_system ) ) // T7TODO - this can be deleted
	{
		ref = ref + "_" + cost;
		self SetHintString( get_zombie_hint( ref ) ); 
	}
	else
	{
		hint = get_zombie_hint( ref );
		if (IsDefined(cost))
		{
			self SetHintString( hint, cost ); 
		}
		else
		{
			self SetHintString( hint ); 
		}
	}
}

function get_hint_string(ent, default_ref, cost )
{
	ref = default_ref;
	if( IsDefined( ent.script_hint ) )
	{
		ref = ent.script_hint;
	}
	if ( ( isdefined( level.legacy_hint_system ) && level.legacy_hint_system ) && IsDefined(cost) ) // T7TODO - this can be deleted
	{
		ref = ref + "_" + cost;
	}
	return get_zombie_hint( ref );
}

function unitrigger_set_hint_string( ent, default_ref, cost )
{
	triggers=[];
	if(self.trigger_per_player)
	{
		triggers = self.playertrigger;
	}
	else
	{
		triggers[0] = self.trigger;
	}
	foreach(trigger in triggers)
	{
		ref = default_ref;
		if( IsDefined( ent.script_hint ) )
		{
			ref = ent.script_hint;
		}
		if ( ( isdefined( level.legacy_hint_system ) && level.legacy_hint_system ) ) // T7TODO - this can be deleted
		{
			ref = ref + "_" + cost;
			trigger SetHintString( get_zombie_hint( ref ) ); 
		}
		else
		{
			hint = get_zombie_hint( ref );
			if (IsDefined(cost))
			{
				trigger SetHintString( hint, cost ); 
			}
			else
			{
				trigger SetHintString( hint ); 
			}
		}
	}
}

//
// SOUNDS =========================================================== 
// 

function add_sound( ref, alias )
{
	if( !IsDefined( level.zombie_sounds ) )
	{
		level.zombie_sounds = []; 
	}

	level.zombie_sounds[ref] = alias; 
}

function play_sound_at_pos( ref, pos, ent )
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

function play_sound_on_ent( ref )
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

function play_loopsound_on_ent( ref )
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


function string_to_float( string )
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

//
// TABLE LOOK SECTION ============================================================
// 

//	Read a value from a table and set the related level.zombie_var
//
function set_zombie_var( zvar, value, is_float, column, is_team_based )
{
	if ( !IsDefined( is_float ) )
	{
		is_float = false;
	}
	if ( !IsDefined(column) )
	{
		column = 1;
	}

	if ( ( isdefined( is_team_based ) && is_team_based ) )
	{
		foreach( team in level.teams )
		{
			level.zombie_vars[ team ][ zvar ] = value;
		}
	}
	else
	{
		level.zombie_vars[zvar] = value;
	}
	
	return value;
}


//	Read a value from a table and return the result
//
function get_table_var( table, var_name, value, is_float, column )
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


function hudelem_count()
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
		{wait(.05);}; 
	}
#/
}

function debug_round_advancer()
{
/#
	while( 1 )
	{
		zombs = zombie_utility::get_round_enemy_array(); 
		
		for( i = 0; i < zombs.size; i++ )
		{
			zombs[i] dodamage( zombs[i].health + 666, ( 0, 0, 0 ) ); 
			wait 0.5; 
		}
	}	
#/
}

function print_run_speed( speed )
{
/#
	self endon( "death" ); 
	while( 1 )
	{
		print3d( self.origin +( 0, 0, 64 ), speed, ( 1, 1, 1 ) ); 
		{wait(.05);}; 
	}
#/
}

function draw_line_ent_to_ent( ent1, ent2 )
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
		{wait(.05);}; 
	}
#/
}

function draw_line_ent_to_pos( ent, pos, end_on )
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
		{wait(.05);}; 
	}
#/
}

function debug_print( msg )
{
/#
	if( GetDvarInt( "zombie_debug" ) > 0 )
	{
		println( "######### ZOMBIE: " + msg ); 
	}
#/
}

function debug_blocker( pos, rad, height )
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

		{wait(.05);}; 
		drawcylinder( pos, rad, height ); 
		
	}
#/
}

function drawcylinder( pos, rad, height )
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

function print3d_at_pos( msg, pos, thread_endon, offset )
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
		{wait(.05);}; 
	}
#/
}

function debug_breadcrumbs()
{
/#
	self endon( "disconnect" ); 
	self notify("stop_debug_breadcrumbs");
	self endon("stop_debug_breadcrumbs");
	

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

		{wait(.05);}; 
	}
#/
}

/#
function debug_attack_spots_taken()
{
// this section was totally commented out.
	self notify("stop_debug_breadcrumbs");
	self endon("stop_debug_breadcrumbs");
	
	while( 1 )
	{
		if( GetDvarInt( "zombie_debug" ) != 2 )
		{
			wait( 1 ); 
			continue; 
		}

		{wait(.05);};
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

function float_print3d( msg, time )
{
/#
	self endon( "death" );

	time = GetTime() + ( time * 1000 );
	offset = ( 0, 0, 72 );
	while( GetTime() < time )
	{
		offset = offset + ( 0, 0, 2 );
		print3d( self.origin + offset, msg, ( 1, 1, 1 ) );
		{wait(.05);};
	}
#/
}
function do_player_vo(snd, variation_count)
{

	
	index = zm_weapons::get_player_index(self);
	
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

function is_magic_bullet_shield_enabled( ent )
{
	if( !IsDefined( ent ) )
		return false;

	//return ( IsDefined( ent.magic_bullet_shield ) && ent.magic_bullet_shield == true );
	return !( isdefined( ent.allowDeath ) && ent.allowDeath );
}

function really_play_2D_sound(sound)
{
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent PlaySoundWithNotify (sound, sound + "wait");
	temp_ent waittill (sound + "wait");
	{wait(.05);};
	temp_ent delete();
}


function play_sound_2D(sound)
{
	level thread really_play_2D_sound(sound);
	
	/*
	if(!isdefined(level.playsound2dent))
	{
		level.playsound2dent = spawn("script_origin",(0,0,0));
	}
	
	//players=GetPlayers();
	level.playsound2dent playsound ( sound );
	*/
	/*
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent PlaySoundWithNotify (sound, sound + "wait");
	temp_ent waittill (sound + "wait");
	WAIT_SERVER_FRAME;
	temp_ent delete();	
	*/	
}

function include_weapon( weapon_name, in_box )
{
/#	println( "ZM >> include_weapon = " + weapon_name );	#/
	if( !isDefined( in_box ) )
	{
		in_box = true;
	}

	zm_weapons::include_zombie_weapon( weapon_name, in_box );
}

// Allows triggers to be un/seen by players
function trigger_invisible( enable )
{
	players = GetPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isdefined( players[i] ) )
		{
			self SetInvisibleToPlayer( players[i], enable );
		}
	}
}


// Print3d
function print3d_ent( text, color, scale, offset, end_msg, overwrite )
{
	self endon("death");

	if ( IsDefined(overwrite) && overwrite && IsDefined( self._debug_print3d_msg ) )
	{
		// Kill the previous thread
		self notify( "end_print3d" );
		{wait(.05);};
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
		{wait(.05);};
	}
	#/
}

//
//
function create_counter_hud( x )
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
function get_current_zone( return_zone )
{
	level flag::wait_till( "zones_initialized" );

	// clear out active zone flags
	for( z=0; z<level.zone_keys.size; z++ )
	{
		zone_name = level.zone_keys[z];
		zone = level.zones[ zone_name ];

		// Okay check to see if the entity is in one of the zone volumes
		for (i = 0; i < zone.volumes.size; i++)
		{
			if ( self IsTouching(zone.volumes[i]) )
			{
				if ( ( isdefined( return_zone ) && return_zone ) )
				{
					return zone;
				}
				return zone_name;
			}
		}
	}

	return undefined;
}

function remove_mod_from_methodofdeath( mod )
{
	/*modStrings = strtok( mod, "mod_" );
	modName = "";
	for ( i = 1; i < modStrings.size; i++ )//skip the MOD_
	{
		modName += modStrings[i];
	}*/
	
	return mod;
}

function clear_fog_threads()
{
	players = GetPlayers();

	for( i = 0; i < players.size; i++ )
	{
		players[i] notify( "stop_fog" );
	}
}

function display_message( titleText, notifyText, duration )
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
	self thread hud_message::notifyMessage( notifyData );
}

function is_quad()
{
	return self.animname == "quad_zombie";
}

function is_leaper()
{
	return self.animname == "leaper_zombie";
}

function shock_onpain()
{
	self endon( "death" ); 
	self endon( "disconnect" ); 
	
	self notify("stop_shock_onpain");
	self endon("stop_shock_onpain");

	if( GetDvarString( "blurpain" ) == "" )
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
			shockType = undefined;
			shockLight = undefined;
			
			if ( ( isdefined( self.is_burning ) && self.is_burning ) )
			{
				shockType = "lava";
				shockLight = "lava_small";
			}
			
			self shock_onexplosion( damage, shockType, shockLight );
		}
		else
		{
			if( GetDvarString( "blurpain" ) == "on" )
			{
				self ShellShock( "pain", 0.5 ); 
			}
		}
	}
}

function shock_onexplosion( damage, shockType, shockLight )
{
	time = 0; 

	scaled_damage = 100 * damage / self.maxhealth;

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
		if ( !IsDefined( shockType ) )
		{
			shockType = "explosion";
		}
		
		self ShellShock( shockType, time );
	}
	else if (IsDefined(shockLight))
	{
		self ShellShock( shockLight, time );
	}
}

// ww: increment the is_drinking variable on a player
function increment_is_drinking()
{
	//self endon( "death" );
	/#
	if( ( isdefined( level.devgui_dpad_watch ) && level.devgui_dpad_watch ) ) 
	{
		self.is_drinking++;
		return;
	}
	#/	
	
	if( !isdefined(self.is_drinking) )
		self.is_drinking = 0;

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
function is_multiple_drinking()
{
	//self endon( "death" );
	return ( self.is_drinking > 1 );
}

// ww: decrement drinking
function decrement_is_drinking()
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
function clear_is_drinking()
{
	//self endon( "death" );
	
	self.is_drinking = 0;
	
	self EnableOffhandWeapons();
	self EnableWeaponCycling();
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
function fade_out(time)
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

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] freezecontrols(true);
	}

	wait time;
}

function fade_in( hold_black_time )
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

	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		players[i] freezecontrols(false);
	}
	level notify("fade_in_complete");
}
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WEAPONS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function getWeaponClassZM( weapon )
{
	assert( isdefined( weapon ) );
	if ( !isdefined( weapon ) ) 
	{
		return undefined;
	}

	if ( !isdefined ( level.weaponClassArray ) ) 
	{
		level.weaponClassArray = [];
	}

	if ( isdefined( level.weaponClassArray[weapon] ) )
	{
	    return level.weaponClassArray[weapon];
	}

	baseWeaponIndex =  GetBaseWeaponItemIndex( weapon );
	statsTableName = util::getStatsTableName();
	weaponClass = tableLookup( statsTableName, 0, baseWeaponIndex, 2); 
	level.weaponClassArray[weapon] = weaponClass;
	return weaponClass;
}

function spawn_weapon_model( weapon, model, origin, angles, options )
{
	if ( !isdefined( model ) )
	{
		model = weapon.worldModel;
	}
	
	weapon_model = spawn( "script_model", origin ); 
	if ( isdefined( angles ) )
	{
		weapon_model.angles = angles;
	}

	if ( isdefined( options ) )
	{
		weapon_model useweaponmodel( weapon, model, options );
	}
	else
	{
		weapon_model useweaponmodel( weapon, model );
	}

	return weapon_model;
}


function is_limited_weapon( weapon )
{
	if ( IsDefined( level.limited_weapons ) && IsDefined( level.limited_weapons[weapon] ) )
	{
		return true;
	}

	return false;
}


function register_lethal_grenade_for_level( weaponname )
{
	weapon = GetWeapon( weaponname );
	if ( is_lethal_grenade( weapon ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_lethal_grenade_list ) )
	{
		level.zombie_lethal_grenade_list = [];
	}

	level.zombie_lethal_grenade_list[weapon] = weapon;
}


function is_lethal_grenade( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( level.zombie_lethal_grenade_list ) )
	{
		return false;
	}

	return isdefined(level.zombie_lethal_grenade_list[weapon]);
}


function is_player_lethal_grenade( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( self.current_lethal_grenade ) )
	{
		return false;
	}

	return self.current_lethal_grenade == weapon;
}


function get_player_lethal_grenade()
{
	grenade = level.weaponNone;
	
	if(IsDefined(self.current_lethal_grenade))
	{
		grenade = self.current_lethal_grenade;
	}
	
	return grenade;
}


function set_player_lethal_grenade( weapon )
{
	if ( !IsDefined( weapon ) )
	{
		weapon = level.weaponNone;
	}

	self notify( "new_lethal_grenade", weapon );
	self.current_lethal_grenade = weapon;
}


function init_player_lethal_grenade()
{
	self set_player_lethal_grenade( level.zombie_lethal_grenade_player_init );
}


function register_tactical_grenade_for_level( weaponname )
{
	weapon = GetWeapon( weaponname );
	if ( is_tactical_grenade( weapon ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_tactical_grenade_list ) )
	{
		level.zombie_tactical_grenade_list = [];
	}

	level.zombie_tactical_grenade_list[weapon] = weapon;
}


function is_tactical_grenade( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( level.zombie_tactical_grenade_list ) )
	{
		return false;
	}

	return isdefined(level.zombie_tactical_grenade_list[weapon]);
}


function is_player_tactical_grenade( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( self.current_tactical_grenade ) )
	{
		return false;
	}

	return self.current_tactical_grenade == weapon;
}


function get_player_tactical_grenade()
{
	tactical = level.weaponNone;
	
	if(IsDefined(self.current_tactical_grenade))
	{
		tactical = self.current_tactical_grenade;
	}
	
	return tactical;
}


function set_player_tactical_grenade( weapon )
{
	if ( !IsDefined( weapon ) )
	{
		weapon = level.weaponNone;
	}

	self notify( "new_tactical_grenade", weapon );
	self.current_tactical_grenade = weapon;
}


function init_player_tactical_grenade()
{
	self set_player_tactical_grenade( level.zombie_tactical_grenade_player_init );
}

function is_placeable_mine( weapon )
{
	if ( !isdefined( weapon ) || weapon == level.weaponNone )
	{
		return false;
	}
	
	return isdefined( level.placeable_mines[weapon.name] );
}


function is_player_placeable_mine( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( self.current_placeable_mine ) )
	{
		return false;
	}

	return self.current_placeable_mine == weapon;
}


function get_player_placeable_mine()
{
	placeable_mine = level.weaponNone;
	
	if(IsDefined(self.current_placeable_mine))
	{
		placeable_mine = self.current_placeable_mine;
	}
	
	return placeable_mine;
}


function set_player_placeable_mine( weapon )
{
	if ( !IsDefined( weapon ) )
	{
		weapon = level.weaponNone;
	}

	self notify( "new_placeable_mine", weapon );
	self.current_placeable_mine = weapon;
}


function init_player_placeable_mine()
{
	self set_player_placeable_mine( level.zombie_placeable_mine_player_init );
}


function register_melee_weapon_for_level( weaponname )
{
	weapon = GetWeapon( weaponname );
	if ( is_melee_weapon( weapon ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_melee_weapon_list ) )
	{
		level.zombie_melee_weapon_list = [];
	}

	level.zombie_melee_weapon_list[weapon] = weapon;
}


function is_melee_weapon( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( level.zombie_melee_weapon_list ) )
	{
		return false;
	}

	return isdefined(level.zombie_melee_weapon_list[weapon]);
}


function is_player_melee_weapon( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( self.current_melee_weapon ) )
	{
		return false;
	}

	return self.current_melee_weapon == weapon;
}


function get_player_melee_weapon()
{
	melee_weapon = level.weaponNone;
	
	if(IsDefined(self.current_melee_weapon))
	{
		melee_weapon = self.current_melee_weapon;
	}
	
	return melee_weapon;
}


function set_player_melee_weapon( weapon )
{
	if ( !IsDefined( weapon ) )
	{
		weapon = level.weaponNone;
	}

	self notify( "new_melee_weapon", weapon );
	self.current_melee_weapon = weapon;
}


function init_player_melee_weapon()
{
	self set_player_melee_weapon( level.zombie_melee_weapon_player_init );
}


function register_hero_weapon_for_level( weaponname )
{
	weapon = GetWeapon( weaponname );
	if ( is_hero_weapon( weapon ) )
	{
		return;
	}

	if ( !isdefined( level.zombie_hero_weapon_list ) )
	{
		level.zombie_hero_weapon_list = [];
	}

	level.zombie_hero_weapon_list[weapon] = weapon;
}

function is_hero_weapon( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( level.zombie_hero_weapon_list ) )
	{
		return false;
	}

	return isdefined(level.zombie_hero_weapon_list[weapon]);
}


function is_player_hero_weapon( weapon )
{
	if ( !isdefined( weapon ) || !isdefined( self.current_hero_weapon ) )
	{
		return false;
	}

	return self.current_hero_weapon == weapon;
}


function get_player_hero_weapon()
{
	hero_weapon = level.weaponNone;
	
	if(IsDefined(self.current_hero_weapon))
	{
		hero_weapon = self.current_hero_weapon;
	}
	
	return hero_weapon;
}


function set_player_hero_weapon( weapon )
{
	if ( !IsDefined( weapon ) )
	{
		weapon = level.weaponNone;
	}

	self notify( "new_hero_weapon", weapon );
	self.current_hero_weapon = weapon;
}

function init_player_hero_weapon()
{
	self set_player_hero_weapon( level.zombie_hero_weapon_player_init );
}



function should_watch_for_emp()
{
	return ( isdefined( level.should_watch_for_emp ) && level.should_watch_for_emp );
}

function register_offhand_weapons_for_level_defaults()
{
	if ( isdefined( level.register_offhand_weapons_for_level_defaults_override ) )
	{
		[[ level.register_offhand_weapons_for_level_defaults_override ]]();
		return;
	}

	register_lethal_grenade_for_level( "frag_grenade" );
	level.zombie_lethal_grenade_player_init = GetWeapon( "frag_grenade" );

	register_tactical_grenade_for_level( "cymbal_monkey" );
	level.zombie_tactical_grenade_player_init = undefined;


	level.zombie_placeable_mine_player_init = undefined;

	register_melee_weapon_for_level( "knife" );
	register_melee_weapon_for_level( "bowie_knife" );
	level.zombie_melee_weapon_player_init = GetWeapon( "knife" );
	
	level.zombie_equipment_player_init = undefined;
}


function init_player_offhand_weapons()
{
	init_player_lethal_grenade();
	init_player_tactical_grenade();
	init_player_placeable_mine();
	init_player_melee_weapon();
	init_player_hero_weapon();
	zm_equipment::init_player_equipment();
}


function is_offhand_weapon( weapon )
{
	return (is_lethal_grenade( weapon ) || is_tactical_grenade( weapon ) || is_placeable_mine( weapon ) || is_melee_weapon( weapon ) || is_hero_weapon( weapon ) || zm_equipment::is_equipment( weapon ) );
}


function is_player_offhand_weapon( weapon )
{
	return (self is_player_lethal_grenade( weapon ) || self is_player_tactical_grenade( weapon ) || self is_player_placeable_mine( weapon ) || self is_player_melee_weapon( weapon ) || self is_player_hero_weapon( weapon ) || self zm_equipment::is_player_equipment( weapon ) );
}


function has_powerup_weapon()
{
	return ( isdefined( self.has_powerup_weapon ) && self.has_powerup_weapon );
}


function give_start_weapon( switch_to_weapon )
{
	self GiveWeapon( level.start_weapon );
	self GiveStartAmmo( level.start_weapon );
	if ( ( isdefined( switch_to_weapon ) && switch_to_weapon ) )
	{
		self SwitchToWeapon( level.start_weapon );
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


function array_flag_wait_any( flag_array )
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

function array_flag_wait_any_thread( flag_name, condition )
{
  level endon( condition );
  
  level flag::wait_till( flag_name );
  
  level notify( condition );
}

function groundpos( origin )
{
	return bullettrace( origin, ( origin + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
}

function groundpos_ignore_water( origin )
{
	return bullettrace( origin, ( origin + ( 0, 0, -100000 ) ), 0, self, true )[ "position" ];
}

function groundpos_ignore_water_new( origin )
{
	return groundtrace( origin, ( origin + ( 0, 0, -100000 ) ), 0, self, true )[ "position" ];
}

/@
"Name: self_delete()"
"Summary: Just calls the delete() script command on self. Reason for this is so that we can use array::thread_all to delete entities"
"Module: Entity"
"CallOn: An entity"
"Example: ai[ 0 ] thread self_delete();"
"SPMP: singleplayer"
@/ 
function self_delete()
{
	if (IsDefined(self))
	{
		self delete();
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
function ignore_triggers( timer )
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
function giveachievement_wrapper( achievement, all_players )
{
	if ( achievement == "" )
	{
		return;
	}
	
	//don't do stats stuff if stats are disabled
	if ( ( isdefined( level.zm_disable_recording_stats ) && level.zm_disable_recording_stats ) )
	{	
		return;	
	}	

	achievement_lower = tolower(achievement);
	global_counter = 0;
	
	if ( IsDefined( all_players ) && all_players )
	{
		players = GetPlayers();
		for ( i = 0; i < players.size; i++ )
		{
			players[i] GiveAchievement( achievement );
			
			has_achievement = players[i] zm_stats::get_global_stat( achievement_lower );
			if(!( isdefined( has_achievement ) && has_achievement ))
			{	
				global_counter++;
			}
			
			players[i] zm_stats::increment_client_stat( achievement_lower,false );
			
			if( issplitscreen() && i == 0 || !issplitscreen() )
			{
				if(isDefined(level.achievement_sound_func))
				{
					players[i] thread [[level.achievement_sound_func]](achievement_lower);
				}
			}
		}
	}
	else
	{
		if ( !IsPlayer( self ) )
		{
		/#	println( "^1self needs to be a player for util::giveachievement_wrapper()" );	#/
			return;
		}

		self GiveAchievement( achievement );
		
		//test the stat before updating it from 0 to 1
		has_achievement = self zm_stats::get_global_stat( achievement_lower );
		if(!( isdefined( has_achievement ) && has_achievement ))
		{	
			global_counter++;
		}
		self zm_stats::increment_client_stat( achievement_lower,false );
		
		if(isDefined(level.achievement_sound_func))
		{
			self thread [[level.achievement_sound_func]](achievement_lower);
		}
		
	}
	if(global_counter)
	{
		incrementCounter( "global_" + achievement_lower,global_counter);
	}

}

function GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}


function GetYawToSpot(spot)
{
	pos = spot;
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180( yaw );
	return yaw;
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
function disable_react()
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
function enable_react()
{
	assert( isalive( self ), "Tried to enable react on a non ai" );
	self.a.disableReact = false;
	self.allowReact = true;
}

// MikeD (12/15/2007): IW abandoned the auto-adjust feature, however, we can use it for stats?
// SCRIPTER_MOD: JesseS (4/14/2008):  Added back in for Arcade mode
function bullet_attack( type )
{
	if ( type == "MOD_PISTOL_BULLET" )
	{
		return true;
	}
	return type == "MOD_RIFLE_BULLET";
}



function pick_up()
{
	player = self.owner;
	self destroy_ent();
	
	clip_ammo = player GetWeaponAmmoClip( self.weapon );
	clip_max_ammo = self.weapon.clipSize;
	if( clip_ammo < clip_max_ammo )
	{
		clip_ammo++;
	}
	player SetWeaponAmmoClip( self.weapon, clip_ammo );
}

function destroy_ent()
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
function waittill_not_moving()
{
	self endon("death");
	self endon( "disconnect" );	
	self endon( "detonated" );
	level endon( "game_ended" );

	if ( self.classname == "grenade" )
	{
		self waittill("stationary");
	}
	else
	{
		prevorigin = self.origin;
		while(1)
		{
			wait .15;
			if ( self.origin == prevorigin )
				break;
			prevorigin = self.origin;
		}
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
function get_closest_player( org )
{
	players = [];
	players = GetPlayers(); 
	return array::get_closest( org, players ); 
}


function ent_flag_init_ai_standards()
{
	message_array = [];

	message_array[ message_array.size ] = "goal";
	message_array[ message_array.size ] = "damage";

	for( i = 0; i < message_array.size; i++)
	{
		self flag::init( message_array[ i ] );
		self thread ent_flag_wait_ai_standards( message_array[ i ] );
	}	
}

function ent_flag_wait_ai_standards( message )
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
function flat_angle( angle )
{
	rangle = ( 0, angle[ 1 ], 0 );
	return rangle; 
}

/@
"Name: clear_run_anim()"
"Summary: Clears any set run anims "
"Module: AI"
"CallOn: an actor"
"Example: guy clear_run_anim();"
"SPMP: singleplayer"
@/ 
function clear_run_anim()
{
	self.alwaysRunForward = undefined;
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = undefined;
	self.walk_combatanim = undefined;
	self.walk_noncombatanim = undefined;
	self.preCombatRunEnabled = true;
}

function track_players_intersection_tracker()
{
	self endon( "disconnect" );
	self endon( "death" );
	level endon( "end_game" );

	wait( 5 );
	
	while ( 1 )
	{
		killed_players = false;
		players = GetPlayers();
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] laststand::player_is_in_laststand() || "playing" != players[i].sessionstate )					
			{
				continue;
			}
			
			for ( j = 0; j < players.size; j++ )
			{
				if ( i == j  || players[j] laststand::player_is_in_laststand() || "playing" != players[j].sessionstate )
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
					
/#
				IPrintLnBold( "PLAYERS ARE TOO FRIENDLY!!!!!" );
#/
				players[i] dodamage( 1000, (0, 0, 0) );
				players[j] dodamage( 1000, (0, 0, 0) );

				if ( !killed_players )
				{
					players[i] playlocalsound( level.zmb_laugh_alias );
				}
				players[i] zm_stats::increment_map_cheat_stat( "cheat_too_friendly" );
				players[i] zm_stats::increment_client_stat( "cheat_too_friendly",false );
				players[i] zm_stats::increment_client_stat( "cheat_total",false );
				
				players[j] zm_stats::increment_map_cheat_stat( "cheat_too_friendly" );
				players[j] zm_stats::increment_client_stat( "cheat_too_friendly",false );
				players[j] zm_stats::increment_client_stat( "cheat_total",false );
				
				killed_players = true;
			}	
		}
		wait( .5 );
	}
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
"Example: if ( GetPlayers()[0] is_player_looking_at( org.origin ) )"
"SPMP: zombies"
@/
function is_player_looking_at(origin, dot, do_trace, ignore_ent)
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

	eye = self util::get_eye();

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

function add_gametype( gt, dummy1, name, dummy2 )
{
}

/@
"Name: add_gameloc()"
"Summary: dummy - Rex looks for these to populate the location pulldown"
"SPMP: zombies"
@/ 

function add_gameloc( gl, dummy1, name, dummy2 )
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
function get_closest_index( org, array, dist )
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

function is_valid_zombie_spawn_point(point)
{
	liftedorigin = point.origin + (0,0,5);
	size = 48;
	height = 64;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	absmins = liftedorigin + mins;
	absmaxs = liftedorigin + maxs;
	// check to see if we would telefrag any players
	if ( BoundsWouldTelefrag( absmins, absmaxs ) )
	{
		return false;
	}
	return true;
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
function get_closest_index_to_entity( entity, array, dist, extra_check )
{
	org = entity.origin;
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
		if (isdefined(extra_check) && ![[extra_check]](entity,array[ i ]) )
			continue;
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

function set_gamemode_var(gvar, val)
{
	if(!isdefined(game["gamemode_match"]))
	{
		game["gamemode_match"] = [];
	}	
	
	game["gamemode_match"][gvar] = val;
}

function set_gamemode_var_once(gvar, val)
{
	if(!isdefined(game["gamemode_match"]))
	{
		game["gamemode_match"] = [];
	}	
	
	if(!isdefined(game["gamemode_match"][gvar]))
	{
		game["gamemode_match"][gvar] = val;
	}
}

function set_game_var(gvar, val)
{
	game[gvar] = val;
}

function set_game_var_once(gvar, val)
{
	if(!isdefined(game[gvar]))
	{
		game[gvar] = val;
	}
}

function get_game_var( gvar )
{
	if(isdefined(game[gvar]))
	{
		return game[gvar];
	}
	
	return undefined;
}

function get_gamemode_var( gvar )
{
	if(isdefined(game["gamemode_match"]) && isdefined(game["gamemode_match"][gvar]))
	{
		return game["gamemode_match"][gvar];
	}
	
	return undefined;
}

function waittill_subset(min_num, string1, string2, string3, string4, string5 )
{
	self endon ("death");
	ent = SpawnStruct();
	ent.threads = 0;
	returned_threads = 0;

	if (IsDefined (string1))
	{
		self thread util::waittill_string(string1, ent);
		ent.threads++;
	}
	if (IsDefined (string2))
	{
		self thread util::waittill_string(string2, ent);
		ent.threads++;
	}
	if (IsDefined (string3))
	{
		self thread util::waittill_string(string3, ent);
		ent.threads++;
	}
	if (IsDefined (string4))
	{
		self thread util::waittill_string(string4, ent);
		ent.threads++;
	}
	if (IsDefined (string5))
	{
		self thread util::waittill_string(string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
		returned_threads++;
		if(returned_threads >= min_num ) //if we've got the minimum number of waittills returned, then that is good enough!
		{
			break;
		}
	}

	ent notify ("die");
}

function is_headshot( weapon, sHitLoc, sMeansOfDeath )
{
	if( (sHitLoc != "head" && sHitLoc != "helmet") )
	{
		return false;
	}
	
	//ballsitic knives 
	if( sMeansofDeath == "MOD_IMPACT" && weapon.isBallisticKnife )
	{
		return true;
	}
	
	return sMeansOfDeath != "MOD_MELEE" && sMeansOfDeath != "MOD_IMPACT" && sMeansofDeath != "MOD_UNKNOWN";
}

function is_jumping()
{
	// this probably doesn't work correctly on the bus
	// checking PMF_JUMPING in code would give more accurate results
	ground_ent = self GetGroundEnt();
	return (!isdefined(ground_ent));
}

function is_explosive_damage( mod )
{
	if( !IsDefined( mod ) )
		return false;	

	if( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" || mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE" )
		return true;

	return false;
}

function sndSwitchAnnouncerVox( who )
{
	switch( who )
	{
		case "sam":
			game["zmbdialog"]["prefix"] = "vox_zmba_sam";
			level.zmb_laugh_alias = "zmb_laugh_sam";
			level.sndAnnouncerIsRich = false;
			break;
	}
}

function do_player_general_vox(category,type,timer,chance)
{
	
	if( isDefined(timer) && isDefined(level.votimer[type]) && level.votimer[type] > 0)
	{
		return;
	}
		
	self thread zm_audio::create_and_play_dialog( category, type); 
		
	if(isDefined(timer))
	{
		level.votimer[type] = timer;
		level thread general_vox_timer( level.votimer[type],type );
	}	
}

function general_vox_timer(timer,type)
{
	level endon("end_game");
	
	/#	println( "ZM >> VOX TIMER STARTED FOR  " + type + " ( " + timer + ")" );	#/
	
	while(timer > 0 )
	{
		wait(1);
		timer--;
	}
	level.votimer[type] = timer;
	/#	println( "ZM >> VOX TIMER ENDED FOR  " + type + " ( " + timer + ")" );	#/
	
	
}

function create_vox_timer(type)
{
	level.votimer[type] = 0;
}

function play_vox_to_player(category,type,force_variant )
{
	//self thread zm_audio::playVoxToPlayer( category, type, force_variant );
}

function is_favorite_weapon(weapon_to_check)
{
	if(!isDefined(self.favorite_wall_weapons_list))
	{
		return false;
	}
	
	foreach(weapon in self.favorite_wall_weapons_list)
	{
		if (weapon_to_check == weapon )
		{
			return true;
		}
	}
	
	return false;
}

function add_vox_response_chance(event,chance)
{
	level.response_chances[event] = chance;
}

function set_demo_intermission_point()
{
	spawnpoints = getentarray("mp_global_intermission", "classname");
	if ( !spawnpoints.size )
	{
		return;
	}

	spawnpoint = spawnpoints[0];
	match_string = "";

	location = level.scr_zm_map_start_location;
	if ( (location == "default" || location == "") && IsDefined( level.default_start_location ) )
	{
		location = level.default_start_location;
	}		

	match_string = level.scr_zm_ui_gametype + "_" + location;

	for ( i = 0; i < spawnpoints.size; i++ )
	{
		if ( IsDefined( spawnpoints[i].script_string ) )
		{
			tokens = strtok( spawnpoints[i].script_string," " );
			foreach ( token in tokens )
			{
				if ( token == match_string )
				{
					spawnpoint = spawnpoints[i];
					i = spawnpoints.size; // to get out of the outer for loop
					break;
				}
			}
		}
	}			

	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
}

function register_map_navcard(navcard_on_map,navcard_needed_for_computer)
{
	level.navcard_needed = navcard_needed_for_computer;
	level.map_navcard = navcard_on_map;
}

function does_player_have_map_navcard(player)
{
	return player zm_stats::get_global_stat( level.map_navcard );
}

function does_player_have_correct_navcard(player)
{
	if(!isDefined(level.navcard_needed ))
	{
		return false;
	}
	return player zm_stats::get_global_stat( level.navcard_needed );
}

function place_navcard( str_model, str_stat, org, angles )
{
	navcard = spawn("script_model",org);
	navcard setmodel( str_model );
	navcard.angles = angles;
	
	wait 1;	// delay between spawning card and picking it up
	
	navcard_pickup_trig = Spawn( "trigger_radius_use", org, 0, 84, 72 );
	navcard_pickup_trig SetCursorHint( "HINT_NOICON" );
	navcard_pickup_trig SetHintString( &"ZOMBIE_NAVCARD_PICKUP" );
	navcard_pickup_trig TriggerIgnoreTeam();
	
	a_navcard_stats = array( "navcard_held_zm_transit", "navcard_held_zm_highrise", "navcard_held_zm_buried" );
	
	is_holding_card = false;
	str_placing_stat = undefined;
	
	while(1)
	{
		navcard_pickup_trig waittill("trigger",who );
		
		if( is_player_valid(who) )
		{
			// check for any currently held card.  If found, clear that stat and save which it was
			foreach ( str_cur_stat in a_navcard_stats )
			{
				if ( who zm_stats::get_global_stat( str_cur_stat ) )
				{
					str_placing_stat = str_cur_stat;
					is_holding_card = true;
					who zm_stats::set_global_stat( str_cur_stat, 0 );
				}
			}
			
			who playsound( "zmb_buildable_piece_add" );
			who zm_stats::set_global_stat( str_stat, 1 );
			who.navcard_grabbed = str_stat;
			util::wait_network_frame();

			is_stat = who zm_stats::get_global_stat( str_stat );
			
			thread sq_refresh_player_navcard_hud();
			break;
		}
	}
	
	navcard delete();
	navcard_pickup_trig delete();		
	
	// if a card was held, place a new card with the stat of the one that was held (set down the old card)
	if ( is_holding_card )
	{
		level thread place_navcard( str_model, str_placing_stat, org, angles );
	}
}

function sq_refresh_player_navcard_hud()
{
	if (!IsDefined(level.navcards))
		return;
	players = GetPlayers();
	foreach( player in players )
	{
		player thread sq_refresh_player_navcard_hud_internal();
	}
}

function sq_refresh_player_navcard_hud_internal()
{
	self endon("disconnect");
	
	navcard_bits = 0;
	for(i = 0;i < level.navcards.size; i++)
	{
		hasit = self zm_stats::get_global_stat( level.navcards[i] );
		if (isdefined(self.navcard_grabbed) && self.navcard_grabbed == level.navcards[i] )
			hasit = 1;
		if( hasit )
		{
			navcard_bits +=( 1 << i );
		}
	}
	util::wait_network_frame();
	self clientfield::set( "navcard_held", 0 );
	if ( navcard_bits > 0 )
	{
		util::wait_network_frame();
		self clientfield::set( "navcard_held", navcard_bits );
	}
}


function disable_player_move_states(forceStanceChange)
{
	self AllowCrouch( true );
	self AllowLean( false );
	self AllowAds( false );
	self AllowSprint( false );
	self AllowProne( false );		
	self AllowMelee( false );

	if((isdefined(forceStanceChange)) && (forceStanceChange == true))
	{
		if ( self GetStance() == "prone" )
		{
			self SetStance( "crouch" );
		}	
	}
}

function enable_player_move_states()
{
	if((!isdefined(self._allow_lean)) || (self._allow_lean == true))
	{
		self AllowLean( true );
	}
	
	if((!isdefined(self._allow_ads)) || (self._allow_ads == true))
	{
		self AllowAds( true );
	}
	
	if((!isdefined(self._allow_sprint)) || (self._allow_sprint == true))
	{
		self AllowSprint( true );
	}
	
	if((!isdefined(self._allow_prone)) || (self._allow_prone == true))
	{
		self AllowProne( true );		
	}
	
	if((!isdefined(self._allow_melee)) || (self._allow_melee == true))
	{
		self AllowMelee( true );	
	}
	
}

function check_and_create_node_lists()
{
	if(!isdefined(level._link_node_list))
	{
		level._link_node_list = [];
	}
	
	if(!isdefined(level._unlink_node_list))
	{
		level._unlink_node_list = [];
	}
}

function link_nodes(a, b, bDontUnlinkOnMigrate = false)
{
	if(NodesAreLinked(a,b))
	{
		return;
	}
	
	check_and_create_node_lists();

	a_index_string = "" + a.origin;
	b_index_string = "" + b.origin;
	
	if(!isdefined(level._link_node_list[a_index_string]))
	{
		level._link_node_list[a_index_string] = spawnstruct();
		level._link_node_list[a_index_string].node = a;
		level._link_node_list[a_index_string].links = [];
		level._link_node_list[a_index_string].ignore_on_migrate = [];
	}

	if(!isdefined(level._link_node_list[a_index_string].links[b_index_string]))
	{
		level._link_node_list[a_index_string].links[b_index_string] = b;	// Add a record of the link.
		level._link_node_list[a_index_string].ignore_on_migrate[b_index_string] = bDontUnlinkOnMigrate;
	}
	
	if(isdefined(level._unlink_node_list[a_index_string]))
	{
		if(isdefined(level._unlink_node_list[a_index_string].links[b_index_string]))
		{
			level._unlink_node_list[a_index_string].links[b_index_string] = undefined;	// Remove record of earlier unlink
			level._unlink_node_list[a_index_string].ignore_on_migrate[b_index_string] = undefined;
		}
	}
	
//	/# println("Linking node at " + a.origin + " to node at " + b.origin); #/
	
	LinkNodes(a,b);
}

function unlink_nodes(a,b, bDontLinkOnMigrate = false)
{
	if(!NodesAreLinked(a,b))
	{
		return;
	}
	
	check_and_create_node_lists();

	a_index_string = "" + a.origin;
	b_index_string = "" + b.origin;

	if(!isdefined(level._unlink_node_list[a_index_string]))
	{
		level._unlink_node_list[a_index_string] = spawnstruct();
		level._unlink_node_list[a_index_string].node = a;
		level._unlink_node_list[a_index_string].links = [];
		level._unlink_node_list[a_index_string].ignore_on_migrate = [];
	}
	
	if(!isdefined(level._unlink_node_list[a_index_string].links[b_index_string]))
	{
		level._unlink_node_list[a_index_string].links[b_index_string] = b;  // Add a record of the unlink.
		level._unlink_node_list[a_index_string].ignore_on_migrate[b_index_string] = bDontLinkOnMigrate;
	}
	

	if(isdefined(level._link_node_list[a_index_string]))
	{
		if(isdefined(level._link_node_list[a_index_string].links[b_index_string]))
		{
			level._link_node_list[a_index_string].links[b_index_string] = undefined;	// Remove record of earlier link.
			level._link_node_list[a_index_string].ignore_on_migrate[b_index_string] = undefined;
		}
	}
	
//	/# println("Unlinking node at " + a.origin + " from node at " + b.origin); #/
	
	UnlinkNodes(a,b);
}

//spawn_path_node( (-6392, 4329, 0), (0,0,0), "targetname", "blah" );

function spawn_path_node(origin, angles, k1, v1, k2, v2)
{
	if(!isdefined(level._spawned_path_nodes))
	{
		level._spawned_path_nodes = [];
	}
	
	node = spawnstruct();
	
	node.origin = origin;
	node.angles = angles;
	node.k1 = k1;
	node.v1 = v1;
	node.k2 = k2;
	node.v2 = v2;
	
	node.node = spawn_path_node_internal(origin, angles, k1, v1, k2, v2);
	
	level._spawned_path_nodes[level._spawned_path_nodes.size] = node;
	
	return node.node;
}

function spawn_path_node_internal(origin, angles, k1, v1, k2, v2)
{
	if(isdefined(k2))
	{
		return SpawnPathNode("node_pathnode", origin, angles, k1, v1, k2, v2);
	}
	else if(isdefined(k1))
	{
		return SpawnPathNode("node_pathnode", origin, angles, k1, v1);
	}
	else
	{
		return SpawnPathNode("node_pathnode", origin, angles);
	}

	return undefined;
}

function delete_spawned_path_nodes()
{
/*	if(!isdefined(level._spawned_path_nodes))
	{
		return;
	}	
	
	//for(i = 0; i < level._spawned_path_nodes.size; i ++)
	for(i = level._spawned_path_nodes.size - 1; i > -1; i --)		
	{
		/# println("Deleting spawned path node @ " + level._spawned_path_nodes[i].origin); #/
		DeletePathNode(level._spawned_path_nodes[i].node);
		level._spawned_path_nodes[i].node = undefined;
	}*/
}

function respawn_path_nodes()
{
	if(!isdefined(level._spawned_path_nodes))
	{
		return;
	}
	
	for(i = 0; i < level._spawned_path_nodes.size; i ++)
	{
		node_struct = level._spawned_path_nodes[i];
		
		/# println("Re-spawning spawned path node @ " + node_struct.origin); #/
		node_struct.node = spawn_path_node_internal(node_struct.origin, node_struct.angles, node_struct.k1, node_struct.v1, node_struct.k2, node_struct.v2);
	}
}

function link_changes_internal_internal(list, func)
{
	keys = GetArrayKeys(list);
	
	for(i = 0; i < keys.size; i ++)
	{
		node = list[keys[i]].node;
		
		node_keys = GetArrayKeys(list[keys[i]].links);
		
		for(j = 0; j < node_keys.size; j ++)
		{
			if(isdefined(list[keys[i]].links[node_keys[j]]))
			{
				
				if(( isdefined( list[keys[i]].ignore_on_migrate[node_keys[j]] ) && list[keys[i]].ignore_on_migrate[node_keys[j]] ))
				{
					/# println("Node at " + keys[i] + " to node at " + node_keys[j] + " - IGNORED"); #/
				}
				else
				{
					/# println("Node at " + keys[i] + " to node at " + node_keys[j]); #/
					[[func]](node, list[keys[i]].links[node_keys[j]]);
				}
			}
		}
	}
}

function link_changes_internal(func_for_link_list, func_for_unlink_list)
{
	if(isdefined(level._link_node_list))
	{
		/# println("Link List"); #/
		link_changes_internal_internal(level._link_node_list, func_for_link_list);
	}
	
	if(isdefined(level._unlink_node_list))
	{
		/# println("UnLink List"); #/
		link_changes_internal_internal(level._unlink_node_list, func_for_unlink_list);
	}
}

function link_nodes_wrapper(a, b)
{
	if(!NodesAreLinked(a,b))
	{
		LinkNodes(a,b);
	}
}

function unlink_nodes_wrapper(a, b)
{
	if(NodesAreLinked(a,b))
	{
		UnlinkNodes(a,b);
	}
}

function undo_link_changes()
{
	/# 	println("***");
		println("***");
		println("*** Undoing link changes"); #/
			
	link_changes_internal( &unlink_nodes_wrapper, &link_nodes_wrapper);
		
	delete_spawned_path_nodes();
		
}

function redo_link_changes()
{
	/# 	println("***");
		println("***");
		println("*** Redoing link changes"); #/

	respawn_path_nodes();
			
	link_changes_internal( &link_nodes_wrapper, &unlink_nodes_wrapper);
}

function is_gametype_active( a_gametypes )
{
	b_is_gametype_active = false;
	
	if ( !IsArray( a_gametypes ) )
	{
		a_gametypes = Array( a_gametypes );
	}
	
	for ( i = 0; i < a_gametypes.size; i++ )
	{
		if ( GetDvarString( "g_gametype" ) == a_gametypes[ i ] )
		{
			b_is_gametype_active = true;
		}
	}

	return b_is_gametype_active;
}

function register_custom_spawner_entry( spot_noteworthy, func )
{
	if ( !IsDefined( level.custom_spawner_entry ) )
	{
		level.custom_spawner_entry = [];
	}
	
	level.custom_spawner_entry[ spot_noteworthy ] = func;
}

function get_player_weapon_limit( player )
{
	if ( IsDefined( level.get_player_weapon_limit ) )
	{
		return [[level.get_player_weapon_limit]]( player );
	}

	weapon_limit = 2;
	if ( player HasPerk( "specialty_additionalprimaryweapon" ) )
	{
		weapon_limit = level.additionalprimaryweapon_limit;
	}

	return weapon_limit;
}

function get_player_perk_purchase_limit()
{
	if ( IsDefined( level.get_player_perk_purchase_limit ) )
	{
		return self [[level.get_player_perk_purchase_limit]]();
	}
	
	return level.perk_purchase_limit;	
}

function wait_for_attractor_positions_complete()
{
	self waittill( "attractor_positions_generated" );
	
	self.attract_to_origin = false;
}
