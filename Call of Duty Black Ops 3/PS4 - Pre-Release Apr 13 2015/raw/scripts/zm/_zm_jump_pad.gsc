#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_util;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;

#namespace zm_jump_pad;

function autoexec __init__sytem__() {     system::register("zm_jump_pad",&__init__,undefined,undefined);    }

// Jump Pad
// Trigger points to a struct which is the start point
// Start point targets another struct which is the end point
// If the End Point has a target then this should be used to create the poi for the landing area
// Each jump pad can have multiple landing spots that are chosen randomly by default
// Overrides are as follows:
// On Trigger:
//		Script_flag_wait - This string dictates when the pad will become active. Should probably be "on_power"
//		Script_parameters - This variable should also be added to the level._jump_pad_override array, the function should set where the pad's destination is.
//		Script_string - This variable should also be added to the level._jump_pad_override_array, and the function should return an array.
//		This first spot in the array should be the velocity to send the player and the second spot should be the amount of time the player should be in
//		the air.

function __init__()
{
	level jump_pad_init();
}

// jumppad setup
function jump_pad_init()
{
	// set up the override array
	level._jump_pad_override = [];
	
	jump_pad_triggers = GetEntArray( "trig_jump_pad", "targetname" );
	
	if( !isdefined( jump_pad_triggers ) )
	{
		return;
	}
	
	for( i = 0; i < jump_pad_triggers.size; i++ )
	{
		jump_pad_triggers[i].start = struct::get( jump_pad_triggers[i].target, "targetname" );
		jump_pad_triggers[i].destination = struct::get_array( jump_pad_triggers[i].start.target, "targetname" );
		
		if( isdefined( jump_pad_triggers[i].script_string ) )
		{
			jump_pad_triggers[i].overrides = StrTok( jump_pad_triggers[i].script_string, "," );
		}
		
		jump_pad_triggers[i] thread jump_pad_think();
	}
	
	// anything that needs to be on the player should go here
	callback::on_connect( &jump_pad_player_variables );
}

// variables for the player when it comes to jump pads
function jump_pad_player_variables()
{
	self._padded = false;
	self.lander = false;
}

// jump pad main function
function jump_pad_think()
{
	self endon( "destroyed" );
	
	end_point = undefined;
	start_point = undefined;
	z_velocity = undefined;
	z_dist = undefined;
	fling_this_way = undefined;
	jump_time = undefined;
	
	world_gravity = GetDvarInt( "bg_gravity" ); // 800;
	gravity_pulls = 13.3 * -1; // this is gravity divided by the amount of frames in a second (800/60).
	top_velocity_sq = 900 * 900;
	forward_scaling = 1.0;
	
	if( isdefined( self.script_flag_wait ) )
	{
		if( !isdefined( level.flag[ self.script_flag_wait ] ) )
		{
			level flag::init( self.script_flag_wait );
		}
		
		level flag::wait_till( self.script_flag_wait );
	}	
	
	while( isdefined( self ) )
	{
		self waittill( "trigger", who );
		
		if( IsPlayer( who ) )
		{
			self thread trigger::function_thread( who,&jump_pad_start,&jump_pad_cancel );
		}		
	}	
}

// figures out where to send the player then launches them if they haven't left the pad
function jump_pad_start( ent_player, endon_condition )
{
	self endon( "endon_condition" );
	
	ent_player endon( "left_jump_pad" );
	ent_player endon("death");
	ent_player endon("disconnect");
	
	
	// objects
	end_point = undefined;
	start_point = undefined;
	z_velocity = undefined;
	z_dist = undefined;
	fling_this_way = undefined;
	jump_time = undefined;
	
	world_gravity = GetDvarInt( "bg_gravity" ); // 800;
	gravity_pulls = 13.3 * -1; // this is gravity divided by the amount of frames in a second (800/60).
	top_velocity_sq = 900 * 900;
	forward_scaling = 1.0;
	
	start_point = self.start; // using the start struct here because we don't want the player to be sent without having to steer a bit
	
	// any extra special trigger behavior should go on the trigger in the name KVP, tokenize that string then use a switch to decide at the action
	if( isdefined( self.name ) )
	{
		self._action_overrides = StrTok( self.name, "," );
		
		if( isdefined( self._action_overrides ) )
		{			
			for( i = 0; i < self._action_overrides.size; i++ )
			{				
				ent_player jump_pad_player_overrides( self._action_overrides[i] );				
			}			
		}		
	}
	
	if( isdefined( self.script_wait ) )
	{
		if( self.script_wait < 1 )
		{
			self playsound( "evt_jump_pad_charge_short" );
		}
		else
		{
			self playsound( "evt_jump_pad_charge" );
		}
		wait( self.script_wait );
	}
	else
	{
		self playsound( "evt_jump_pad_charge" );
		wait( 1.0 ); // give the player a moment if they don't want to jump	
	}
	
		
	// if the trigger has an override set up then use it to find the end point
	if( isdefined( self.script_parameters ) && isdefined( level._jump_pad_override[ self.script_parameters ] ) )
	{
		end_point = self [[ level._jump_pad_override[ self.script_parameters ] ]]( ent_player );
	}
	
	if( !isdefined( end_point ) )
	{
		// choose randomly between all the end points
		end_point = self.destination[ RandomInt( self.destination.size ) ];
	}
	
	// special override to change the velocity and jump timing for a pad
	if( isdefined( self.script_string ) && isdefined( level._jump_pad_override[ self.script_string ] ) ) 
	{
			info_array = self [[ level._jump_pad_override[ self.script_string ] ]]( start_point, end_point );
			
			fling_this_way = info_array[0];
			jump_time = info_array[1];
	}
	else
	{
		end_spot = end_point.origin;
		
		// randomness
		if( !( isdefined( self.script_airspeed ) && self.script_airspeed ) )
		{
			rand_end = ( RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 ), 0 );
			
			rand_scale = RandomInt( 100 );
			
			rand_spot = VectorScale( rand_end, rand_scale );
			
			end_spot = end_point.origin + rand_spot;
		}
		
		// distance
		pad_dist = Distance( start_point.origin, end_spot );

		z_dist = end_spot[2] - start_point.origin[2];
		
		// velocity
		jump_velocity = end_spot - start_point.origin;
		

		
		// the end point is much higher than the start point so we need to double the z_velocity and scale up the x & y
		if( z_dist > 40 && z_dist < 135 )
		{
			z_dist *= 2.5;
			forward_scaling = 1.1;
			
			/#
			if( GetDvarInt( "jump_pad_tweaks" ) ) // TODO: Remove check in to dvars for debugging
			{
				if( GetDvarString( "jump_pad_z_dist" ) != "" )
				{
					z_dist *= GetDvarFloat( "jump_pad_z_dist" );
				}
				
				if( GetDvarString( "jump_pad_forward" ) != "" )
				{
					forward_scaling = GetDvarFloat( "jump_pad_forward" );	
				}				
			}
			#/
		}
		else if( z_dist >= 135 )
		{
			z_dist *= 2.7;
			forward_scaling = 1.3;
			
			/#
			if( GetDvarInt( "jump_pad_tweaks" ) ) // TODO: Remove check in to dvars for debugging
			{
				if( GetDvarString( "jump_pad_z_dist" ) != "" )
				{
					z_dist *= GetDvarFloat( "jump_pad_z_dist" );
				}
				
				if( GetDvarString( "jump_pad_forward" ) != "" )
				{
					forward_scaling = GetDvarFloat( "jump_pad_forward" );	
				}				
			}
			#/
			
		}
		else if( z_dist < 0 ) // end_point is lower than the start point
		{
			z_dist *= 2.4;
			forward_scaling = 1.0;
			
			/#
			if( GetDvarInt( "jump_pad_tweaks" ) ) // TODO: Remove check in to dvars for debugging
			{
				if( GetDvarString( "jump_pad_z_dist" ) != "" )
				{
					z_dist *= GetDvarFloat( "jump_pad_z_dist" );
				}
				
				if( GetDvarString( "jump_pad_forward" ) != "" )
				{
					forward_scaling = GetDvarFloat( "jump_pad_forward" );	
				}				
			}
			#/
			

		}
			
			
			// get the z velocity
			z_velocity = 2 * z_dist * world_gravity;	
			
			// make sure the z velocity isn't a negative
			if( z_velocity < 0 )
			{
				z_velocity *= -1;
			}
			
			// make sure the distance isn't a negative
			if( z_dist < 0 )
			{
				z_dist *= -1;
			}
			
			// time
			jump_time = Sqrt( 2 * pad_dist / world_gravity );
			jump_time_2 = Sqrt( 2 * z_dist / world_gravity );
			jump_time = jump_time + jump_time_2;
			if( jump_time < 0 )
			{
				jump_time *= -1;
			}
			
			// velocity
			x = jump_velocity[0] * forward_scaling / jump_time;
			y = jump_velocity[1] * forward_scaling / jump_time;
			z = z_velocity / jump_time;
		
			// final vector
			fling_this_way = ( x, y, z );
	}
		
	// create poi
	if( isdefined( end_point.target ) )
	{
		poi_spot = struct::get( end_point.target, "targetname" );
	}
	else
	{
		poi_spot = end_point;
	}
	
	// pass on any checks info needed for the poi creation in to jump_pad_move
	if( !isdefined( self.script_index ) ) // this checks to see if the attract function should be started on the poi_spot
	{
		ent_player.script_index = undefined;
	}
	else
	{
		ent_player.script_index = self.script_index;
	}
	
	// some pads should probably send the player even if they are jumping
	if( isdefined( self.script_start ) && self.script_start == 1 )
	{
		if( !( isdefined( ent_player._padded ) && ent_player._padded ) )
		{
			self playsound( "evt_jump_pad_launch" );
			playfx(level._effect["jump_pad_jump"],self.origin);
			ent_player thread jump_pad_move( fling_this_way, jump_time, poi_spot, self ); // move the player in the proper direction
			
			if( isdefined( self.script_label ) )
			{
				level notify( self.script_label );
			}
			
			return;
		}
	}
	else // player must be on the ground to be tossed
	{
		if( ent_player IsOnGround() && !( isdefined( ent_player._padded ) && ent_player._padded ) )
		{
			self playsound( "evt_jump_pad_launch" );
			playfx(level._effect["jump_pad_jump"],self.origin);
			ent_player thread jump_pad_move( fling_this_way, jump_time, poi_spot, self ); // move the player in the proper direction
			
			if( isdefined( self.script_label ) )
			{
				level notify( self.script_label );
			}
			
			return;
		}
	}

	// failsafe against timing where the player spams jump button as they land and being able to stay on the pad
	wait( 0.5 );
	if ( ent_player IsTouching( self ) )
	{
		self jump_pad_start( ent_player, endon_condition );
	}
}

// player left the jump pad trigger, don't toss them
function jump_pad_cancel( ent_player )
{	
	ent_player notify( "left_jump_pad" );
	
	if( isdefined( ent_player.poi_spot ) && !( isdefined( ent_player._padded ) && ent_player._padded ) )
	{
		// ent_player.poi_spot Delete();
	}
	
	// any extra special trigger behavior should go on the trigger in the name KVP, tokenize that string then use a switch to decide at the action
	if( isdefined( self.name ) )
	{
		self._action_overrides = StrTok( self.name, "," );
		
		if( isdefined( self._action_overrides ) )
		{
			
			for( i = 0; i < self._action_overrides.size; i++ )
			{
				
				ent_player jump_pad_player_overrides( self._action_overrides[i] );
				
			}
			
		}
		
	}
	
}


function jump_pad_move( vec_direction, flt_time, struct_poi, trigger )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	start_time = GetTime();
	jump_time = flt_time * 500;
	
	attract_dist = undefined;
	num_attractors = 30;
	added_poi_value = 0;
	start_turned_on = true;
	// poi_spot = undefined;
	poi_start_func = undefined;
	
	while( ( isdefined( self.divetoprone ) && self.divetoprone ) || ( isdefined( self._padded ) && self._padded ) )
	{
		{wait(.05);};
		// util::wait_network_frame();
	}

	self._padded = 1;
	self.lander = 1;
	
	self SetStance( "stand" );
	
	wait( 0.1 );

	// low triggers are ok because they get turned off
	if ( isdefined( trigger.script_label ) )
	{
		if ( issubstr( trigger.script_label, "low" ) )
		{
			self.jump_pad_current = undefined;
			self.jump_pad_previous = undefined;
		}
		else if ( !isdefined( self.jump_pad_current ) )
		{
			self.jump_pad_current = trigger;
		}
		else 
		{
			self.jump_pad_previous = self.jump_pad_current;
			self.jump_pad_current = trigger;
		}
	}
	
	if( isdefined( self.poi_spot ) )
	{
		level jump_pad_ignore_poi_cleanup( self.poi_spot );
		
		self.poi_spot zm_utility::deactivate_zombie_point_of_interest();

		self.poi_spot Delete();
	}
	
	if( isdefined( struct_poi ) )
	{
		self.poi_spot = spawn( "script_origin", struct_poi.origin );
		
		if( isdefined( level._pad_poi_ignore ) )
		{
			level [[level._pad_poi_ignore]]( self.poi_spot );
		}
		
		self thread jump_pad_enemy_follow_or_ignore( self.poi_spot );	
		
		if( isdefined( level._jump_pad_poi_start_override ) && !( isdefined( self.script_index ) && self.script_index ) )
		{
			poi_start_func = level._jump_pad_poi_start_override;
		}
		
		if( isdefined( level._jump_pad_poi_end_override ) )
		{
			poi_end_func = level._jump_pad_poi_end_override;
		}
	
		self.poi_spot zm_utility::create_zombie_point_of_interest( attract_dist, num_attractors, added_poi_value, start_turned_on, poi_start_func );
		self thread disconnect_failsafe_pad_poi_clean();
	}
	
	
	self SetOrigin( self.origin + ( 0, 0, 1 ) );
	
	if( 20 >= randomintrange( 0, 101 ) )
	{
		self thread zm_audio::create_and_play_dialog( "general", "jumppad" );
	}
	
	while( GetTime() - start_time < jump_time )
	{
		self SetVelocity( vec_direction );
		{wait(.05);};
	}
	
	while( !self IsOnGround() )
	{
		{wait(.05);};
	}
	
	self._padded = 0;
	self.lander = 0;
	
	jump_pad_triggers = GetEntArray( "trig_jump_pad", "targetname" );
	
	for( i = 0; i < jump_pad_triggers.size; i++ )
	{
		if( self IsTouching( jump_pad_triggers[i] ) )
		{
			level thread failsafe_pad_poi_clean( jump_pad_triggers[i], self.poi_spot );
			return;
		}
	}
	
	if( isdefined( self.poi_spot ) )
	{
		level jump_pad_ignore_poi_cleanup( self.poi_spot );
		self.poi_spot Delete();
	}
	

}

// make sure to delete the poi in cases where the player disconnects while it's active
function disconnect_failsafe_pad_poi_clean()
{
	self notify( "kill_disconnect_failsafe_pad_poi_clean" );
	self endon( "kill_disconnect_failsafe_pad_poi_clean" );
	self.poi_spot endon( "death" );
	
	self waittill( "disconnect" );

	if ( isdefined( self.poi_spot ) )
	{
		level jump_pad_ignore_poi_cleanup( self.poi_spot );
		
		self.poi_spot zm_utility::deactivate_zombie_point_of_interest();
		
		self.poi_spot Delete();
	}
}

// make sure to delete the poi in cases where the player lands on the pad for just a moment before falling off
function failsafe_pad_poi_clean( ent_trig, ent_poi )
{
	if( isdefined( ent_trig.script_wait ) )
	{
		wait( ent_trig.script_wait );
	}
	else
	{
		wait( 0.5 );
	}
	
	if( isdefined( ent_poi ) )
	{
		level jump_pad_ignore_poi_cleanup( ent_poi );
		
		ent_poi zm_utility::deactivate_zombie_point_of_interest();
		
		ent_poi Delete();
	}
}

// sets all zombies not chasing the player to ignore the poi that is going to be created
// enemy stays set as the player they were chasing for a few moments in to the jump
function jump_pad_enemy_follow_or_ignore( ent_poi )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	zombies = GetAiTeamArray( level.zombie_team );

	players = GetPlayers();
	valid_players = 0;
	for( p = 0; p < players.size; p++ )
	{
		if ( zm_utility::is_player_valid( players[p] ) )
		{
			valid_players++;
		}
	}

	for( i = 0; i < zombies.size; i++ )
	{
		ignore_poi = false;

		if( !isdefined( zombies[i] ) )
		{
			continue;
		}

		enemy = zombies[i].favoriteenemy;

		if( isdefined( enemy ) )
		{
			if ( players.size > 1 && valid_players > 1 )
			{
				if ( enemy != self || ( isdefined( enemy.jump_pad_previous ) && enemy.jump_pad_previous == enemy.jump_pad_current ) )
				{
					ignore_poi = true;
				}
			}
		}

		if ( ( isdefined( ignore_poi ) && ignore_poi ) )
		{
			zombies[i] thread zm_utility::add_poi_to_ignore_list( ent_poi );
		}
		else
		{
			zombies[i].ignore_distance_tracking = true;
			zombies[i]._pad_follow = 1;
			zombies[i] thread stop_chasing_the_sky( ent_poi );
		}
	}
}

// makes sure the poi is removed from the enemies ignore list
function jump_pad_ignore_poi_cleanup( ent_poi )
{
	zombies = GetAiTeamArray( level.zombie_team );
	
	for( i = 0; i < zombies.size; i++ )
	{
		if( isdefined( zombies[i] ) )
		{
			if( ( isdefined( zombies[i]._pad_follow ) && zombies[i]._pad_follow ) )
			{
				zombies[i]._pad_follow = 0;
				zombies[i] notify( "stop_chasing_the_sky" );
				zombies[i].ignore_distance_tracking = false;
			}
			
			if( isdefined( ent_poi ) )
			{
				zombies[i] thread zm_utility::remove_poi_from_ignore_list( ent_poi );	
			}			
		}		
	}	
}

// If a zombie is chasing a guy jumping around and comes close to another player then they should break off and attack
// the closer player
// the favoriteenemy is usually the enemy from the start, but when the player is far from the zombie the zombie drops them as
// their .enemy, so for this check we need to see if the player getting close is not the .favoriteenemy
function stop_chasing_the_sky( ent_poi )
{
	self endon( "death" );
	self endon( "stop_chasing_the_sky" );
	
	while( ( isdefined( self._pad_follow ) && self._pad_follow ) )
	{
		if ( isdefined( self.favoriteenemy ) )
		{
			players = getplayers();
			for ( i = 0; i < players.size; i++ )
			{
				if ( zm_utility::is_player_valid( players[i] ) && players[i] != self.favoriteenemy )
				{
					if ( Distance2DSquared( players[i].origin, self.origin ) < 100 * 100 )
					{
						self zm_utility::add_poi_to_ignore_list( ent_poi );
						return;
					}
				}
			}
		}
		
		wait( 0.1 );
	}
	
	//wait( 0.5 ); // allow the zombies time to get close while the next pad warms up
	
	self._pad_follow = 0;
	self.ignore_distance_tracking = false;
	self notify( "stop_chasing_the_sky" );
	
}

// Runs any special player behavior wanted while the player is touching the pad trigger
function jump_pad_player_overrides( st_behavior, int_clean )
{
	if( !isdefined( st_behavior ) || !IsString( st_behavior ) )
	{
		return;
	}
	
	if( !isdefined( int_clean ) ) //int_clean decides if the behavior is applied or removed, not defining it means you want to set the behavior
	{
		int_clean = 0;
	}
	
	switch( st_behavior )
	{
		case "no_sprint":
			
			if( !int_clean )
			{
				//self AllowSprint( int_clean );
			}
			else
			{
				//self AllowSprint( int_clean );
			}
			break;			

		default:
			
			if( isdefined( level._jump_pad_level_behavior ) )
			{
				self [[ level._jump_pad_level_behavior ]]( st_behavior, int_clean );
			}
			else
			{
				// nothing happens
			}
			
			break;		
	}	
}
