#include maps\_utility;
#include common_scripts\utility;

CONST_POI_DETECT_DIST			= 360;	// 30 feet

// -.-.-.-.-.-.-.-.-.-.-.-. Stealth -.-.-.-.-.-.-.-.-.-.-.-. //

is_stealth_ai_living()
{
	return get_stealth_ai_living().size;
}

get_stealth_ai_living()
{
	ai_array = array_combine( GetAIArray( "axis" ), get_dogs() );
	ai_array_alive = [];
	
	foreach ( ai in ai_array )
	{
		if ( !IsAlive( ai ) || !ai ent_flag_exist( "_stealth_enabled" ) || !ai ent_flag( "_stealth_enabled" ) )
			continue;
		
		ai_array_alive[ ai_array_alive.size ] = ai;
	}
	
	return ai_array_alive;
}

stealth_alert_living_ai()
{
	ai_array = get_stealth_ai_living();
	foreach ( ai in ai_array )
	{
		enemy = get_closest_player_healthy( ai.origin );
		ai alert_stealth_ai( enemy );
	}
}

alert_stealth_ai( enemy )
{
	self GetEnemyInfo( enemy );
	group_flag = self maps\_stealth_utility::stealth_get_group_spotted_flag();
	if ( !flag( group_flag ) )
	{
		flag_set( group_flag );
	}
}

all_stealth_normal()
{
	ai_living = get_stealth_ai_living();
	foreach ( ai in ai_living )
	{
		if ( !ai ent_flag( "_stealth_normal" ) )
		{
			return false;
		}
	}
	return true;
}

// When the "_stealth_spotted" flag is set manually the stealth system
// doesn't always clear it when the battle is over. Specifically, if
// the flag is set but no stealth_group AI actually become alerted.
stealth_attempt_alert_clear()
{
	if ( flag( "_stealth_spotted" ) && !is_stealth_ai_living() )
	{
		flag_clear( "_stealth_spotted" );
	}
}

alert_and_player_seek()
{
	player = get_closest_player_healthy( self.origin );
	
	self alert_stealth_ai( player );
	self thread player_seek_coop( player );
}

stealth_ai_seek_player()
{
	ai_array = get_stealth_ai_living();
	
	foreach ( ai in ai_array )
	{
		if	( IsAlive( ai ) && ai IsBadGuy() )
		{
			ai player_seek_coop();
		}
	}
}

stealth_enemy_within_dist( location, dist )
{
	dist2rd = squared( dist );
	ai_array = get_stealth_ai_living();

	foreach ( ai in ai_array )
	{
		if ( DistanceSquared( location, ai.origin ) < dist2rd )
		{
			return true;
		}
	}
	return false;
}

// -.-.-.-.-.-.-.-.-.-.-.-. AI -.-.-.-.-.-.-.-.-.-.-.-. //

player_seek_coop( player )
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	if ( IsDefined( self.stationary ) )
		return;
	
	self.aggressivemode = true;		// don't linger at cover when you cant see your enemy
	self.ignoreme		= false;
	self.ignoreall		= false;
	
	if ( !IsDefined( player ) )
	{
		player = get_closest_player_healthy( self.origin );
	}
	
	if ( !IsDefined( player ) )
	{
		player = get_closest_player( self.origin );
	}
	
	self notify( "end_patrol" );
	
	if ( self ent_flag_exist( "_stealth_enabled" ) && ent_flag( "_stealth_enabled" ) )
	{
		self maps\_stealth_utility::stealth_disable_seek_player_on_spotted();
	}
	
	while( 1 )
	{
		// JC-ToDo: Next project look into the stealth system setting goalradius when seek is off. See below:
		// Because maps\_stealth_threat_enemy::enemy_close_in_on_target()
		// sets the goalradius of the AI even when script_stealth_dontseek
		// is set to true spam the AI goal radius here for each update.
		self.goalradius = 384;
		self SetGoalEntity( player );
		wait 1.0;
		
		if ( is_player_down( player ) )
		{
			player = get_closest_player_healthy( self.origin );
		}
		
		if ( !IsDefined( player ) )
		{
			player = get_closest_player( self.origin );
		}
	}
}

get_dogs()
{
	dogs = [];
	
	if ( IsDefined( level.dogs ) )
	{
		foreach ( dog in level.dogs )
		{
			if ( IsAlive( dog ) )
			{
				dogs[ dogs.size ] = dog;
			}
		}
	}
	
	return dogs;
}

record_dog()
{
	if ( !IsDefined( level.dogs ) )
	{
		level.dogs = [];
	}
	
	level.dogs[ level.dogs.size ] = self;
	
	self thread on_death_unrecord_dog();
}

on_death_unrecord_dog()
{
	Assert( IsDefined( level.dogs ) );
	
	self waittill( "death" );
	
	level.dogs = array_remove( level.dogs, self );
}

active_patrol_light_swap()
{
	self.animation = "active_patrolwalk_v2";
	self.patrol_anim_turn180 = "active_patrolwalk_turn";
	self.patrol_no_stop_transition = true;
	
	self thread maps\prague_code::active_patrol();
	self thread on_remove_flashlight_add_gun_light();
}

patrol_light_swap()
{
	self maps\_util_carlos::light_on_gun();
	self thread maps\_patrol::patrol();
	self thread on_path_end_remove_gun_light();
}

on_remove_flashlight_add_gun_light()
{
	self endon( "death" );
	
	self waittill( "remove_flashlight" );
	
	self maps\_util_carlos::light_on_gun();
}

on_path_end_remove_gun_light()
{
	self endon( "death" );
	
	self waittill( "reached_path_end" );
	
	StopFXOnTag( getfx( "flashlight" ), self, "TAG_FLASH" );
}

on_anim_ending_event( node )
{
	self endon( "animation_killed_me" );
	
//	if ( self ent_flag_exist( "_stealth_enabled" ) && ent_flag( "_stealth_enabled" ) )
//	{
//		self childthread ent_flag_notify_on_open( "_stealth_normal", "stealth_not_normal" );
//	}
	
	self waittill_any( "damage", "enemy", "event_awareness" );
	
	self StopAnimScripted();
	node notify( "stop_loop" );
}

// JC-ToDo: Once we get an idle active patrol animation this won't
// need a wait flag parameter as the stuct could just script_wait set
on_spawn_ai_active_patrol( wait_flag, move_playback )
{
	self endon( "death" );
	
	if ( ent_flag_exist( "_stealth_enabled" ) && ent_flag( "_stealth_enabled" ) )
	{
		ai_group_alert_flag = self maps\_stealth_utility::stealth_get_group_spotted_flag();
		
		if ( flag( ai_group_alert_flag ) )
		{
			return;
		}
			
		level endon( ai_group_alert_flag );
		level endon( "_stealth_spotted" );
	}

	if ( IsDefined( wait_flag ) )
	{
		flag_wait( wait_flag );
	}
	
	if ( IsDefined( move_playback ) )
	{
		self.moveplaybackrate = move_playback;
	}
	
	AssertEx( IsDefined( self.target ), "AI runing active patrol in script need to have a .target value." );
	
	if ( IsDefined( self.target ) )
	{
		self thread active_patrol_light_swap();
	}
}

// -.-.-.-.-.-.-.-.-.-.-.-. Person Of Interest Systems -.-.-.-.-.-.-.-.-.-.-.-. //
poi_pathing_initialize()
{
	poi_path_create( "poi_path_first_struct" );
	if ( !IsDefined( level.so_prague_poi_array ) )
	{
		level.so_prague_poi_array = [];
	}
	
	thread poi_pathing_think( 1.0, 128, 192 );
	thread poi_team_alert_think();
}

poi_team_alert_think()
{
	level endon( "special_op_terminated" );
	while ( 1 )
	{
		flag_wait( "_stealth_spotted" );
		
		foreach( poi in level.so_prague_poi_array )
		{
			if ( IsDefined( poi ) && IsAlive( poi ) )
			{
				poi.ignoreme = false;
			}
		}
		
		flag_waitopen( "_stealth_spotted" );
		
		foreach( poi in level.so_prague_poi_array )
		{
			if ( IsDefined( poi ) && IsAlive( poi ) )
			{
				poi.ignoreme = true;
			}
		}
	}
}

poi_pathing_think( delay, goal_radius_min, goal_radius_max )
{
	level endon( "special_op_terminated" );
	level endon( "poi_pathing_think_stop" );
	
	while( 1 )
	{
		// In case any poi were killed during the wait
		poi_team_update();
		
		if ( level.so_prague_poi_array.size )
		{
			goal_pos = poi_pathing_calculate_goal_pos( goal_radius_max );
			
			foreach ( poi in level.so_prague_poi_array )
			{
				if ( IsDefined( poi.override_poi_pathing ) && poi.override_poi_pathing == true )
					continue;

				poi.goalradius = goal_radius_min;
				poi SetGoalPos( goal_pos );
			}
		}
		
		msg = level waittill_any_timeout( delay, "poi_team_updated" );
		
		if ( msg == "poi_team_updated" )
		{
			// Wait till frame end just in case multiple team updates
			// happen this frame.
			waittillframeend;
		}
	}
}

poi_path_create( first_struct_name )
{
	level.poi_path = [];
	index = 0;
	struct = getstruct( first_struct_name, "targetname" );
	
	while ( IsDefined( struct ) )
	{
		// Figure out length on segment
		struct_next = undefined;
		segment_length = undefined;
		if ( IsDefined( struct.target ) )
		{
			struct_next = getstruct( struct.target, "targetname" );
			segment_length = distance( struct.origin, struct_next.origin );
		}
		
		// Store the struct, and the legth of the segment to
		// the next struct
		level.poi_path[ index ] = [];
		level.poi_path[ index ][ "struct" ] = struct;
		level.poi_path[ index ][ "length" ] = segment_length;
		
		index++;
		struct = struct_next;
	}
}

poi_path_get_distance_along( path_index, point )
{
	dist = 0;
	for( i = 0; i < path_index; i++ )
	{
		dist += level.poi_path[ i ][ "length" ];
	}
	
	if ( path_index < level.poi_path.size - 1 )
	{
		dist += Distance( level.poi_path[ i ][ "struct" ].origin, point );
	}
	
	return dist;
}

poi_path_get_point_along( dist )
{
	point = undefined;
	distance_remaining = dist;
	for ( i = 0; i < level.poi_path.size - 1; i++ )
	{
		segment_length = level.poi_path[ i ][ "length" ];
		if ( segment_length == distance_remaining )
		{
			point = level.poi_path[ i+1 ][ "struct" ].origin;
			break;
		}
		else if ( segment_length > distance_remaining )
		{
			dir = VectorNormalize( level.poi_path[ i+1 ][ "struct" ].origin - level.poi_path[ i ][ "struct" ].origin );
			point = level.poi_path[ i ][ "struct" ].origin + dir * distance_remaining;
			break;
		}
		else if ( i + 1 == level.poi_path.size - 1 )
		{
			point = level.poi_path[ level.poi_path.size - 1 ][ "struct" ].origin;
			break;
		}
		else
		{
			distance_remaining -= segment_length;
		}
	}
	
	AssertEx( IsDefined( point ), "failed to figure out point along person of interest path." );
	
	return point;
}

poi_pathing_calculate_goal_pos( trail_distance )
{
	// Using global variable to prevent some array copies
	AssertEx( IsDefined( level.poi_path ), "Person of Interest path not defined." );
	if ( !IsDefined( level.poi_path ) )
	{
		return level.player.origin;
	}
	
	segment_dist_players = [];
	
	// Figure out the closest points on the path for each player
	foreach ( player_index, player in level.players )
	{
		segment_dist_players[ player_index ] = [];
		player_dist2rd = undefined;
		// Figure out the player distance from each segment of the spline
		for ( path_index = 0; path_index < level.poi_path.size - 1; path_index++ )
		{
//			// Draw Path
//			Line(
//					level.poi_path[ path_index ][ "struct" ].origin,
//					level.poi_path[ path_index + 1 ][ "struct" ].origin,
//					(0,0,1),
//					1.0,
//					false,
//					20
//				);
			
			point = PointOnSegmentNearestToPoint( level.poi_path[ path_index ][ "struct" ].origin, level.poi_path[ path_index+1 ][ "struct" ].origin, player.origin );
			
			if ( !IsDefined( player_dist2rd ) )
			{
				player_dist2rd = DistanceSquared( player.origin, point );
				segment_dist_players[ player_index ][ "closest_index" ] = path_index;
				segment_dist_players[ player_index ][ "closest_point" ] = point;
				segment_dist_players[ player_index ][ "dist_along_path" ] = poi_path_get_distance_along( path_index, point );
			}
			else
			{
				dist2rd = DistanceSquared( player.origin, point );
				if ( dist2rd < player_dist2rd )
				{
					player_dist2rd = dist2rd;
					segment_dist_players[ player_index ][ "closest_index" ] = path_index;
					segment_dist_players[ player_index ][ "closest_point" ] = point;
					segment_dist_players[ player_index ][ "dist_along_path" ] = poi_path_get_distance_along( path_index, point );
				}
			}
		}
	}
	
	// Figure out which player is closest to the start of the spline
	// and use that point to determine the poi goal pos
	closest_index = undefined;
	closest_point = undefined;
	dist_along_path = undefined;
	foreach ( player_index, player in level.players )
	{
//		// Draw line to player closest path point
//		Line(
//				player.origin,
//				segment_dist_players[ player_index ][ "closest_point" ], 
//				(1,1,0),
//				1.0,
//				false,
//				20
//			);
		
		if ( !IsDefined( dist_along_path ) || dist_along_path > segment_dist_players[ player_index ][ "dist_along_path" ] )
		{
			closest_index = segment_dist_players[ player_index ][ "closest_index" ];
			closest_point = segment_dist_players[ player_index ][ "closest_point" ];
			dist_along_path = segment_dist_players[ player_index ][ "dist_along_path" ];
		}
	}
	
	return poi_path_get_point_along( Max( 0, dist_along_path - trail_distance ) );
}

poi_team_update( friendly )
{
	if ( !IsDefined( level.so_prague_poi_array ) )
	{
		poi_pathing_initialize();
	}
	
	poi_removed = false;
	poi_added = false;
	
	// Clean out dead teammates
	poi_array = [];
	foreach ( poi in level.so_prague_poi_array )
	{
		if ( IsAlive( poi ) )
		{
			poi_array[ poi_array.size ] = poi;
		}
		else
		{
			poi_removed = true;
		}
	}
	
	// Add friendly to team if defined
	if ( IsDefined( friendly ) && IsAlive( friendly ) )
	{
		if ( flag( "_stealth_spotted" ) )
		{
			friendly.ignoreme = false;
		}
		else
		{
			friendly.ignoreme = true;
		}
		friendly.ignoreall = true;
		self.drawoncompass = true;

		friendly poi_team_member_scrub();
		
		friendly.combatmode = "cover";
		if ( !IsDefined( level.so_prague_poi_run_num ) )
		{
			level.so_prague_poi_run_num = 0;
		}
		else
		{
			level.so_prague_poi_run_num++;
			if ( level.so_prague_poi_run_num > 2 )
			{
				level.so_prague_poi_run_num = 0;
			}
		}
		
		run_anim = undefined;
		
		switch ( level.so_prague_poi_run_num )
		{
			case 0:
				run_anim = "civilian_run_hunched_C";
				break;
			case 1:
				run_anim = "civilian_run_hunched_A";
				break;
			case 2:
				run_anim = "civilian_run_upright";
				break;
			default:
				AssertMsg( "Invalid poi run anim number: " + level.so_prague_poi_run_num );
				run_anim = "civilian_run_upright";
				break;
		}
		
		friendly thread poi_team_member_ignore_think( CONST_POI_DETECT_DIST );
		friendly set_generic_run_anim( run_anim, false );
		
		poi_array[ poi_array.size ] = friendly;
		poi_added = true;
		
		if ( !IsDefined( level.poi_added_dialog ) )
		{
			level.poi_added_dialog =	[
											"so_ste_prague_reb1_illgo",
											"so_ste_prague_reb1_withyou",
											"so_ste_prague_reb2_followyou",
											"so_ste_prague_reb2_yessir",
											"so_ste_prague_reb3_somuch",
											"so_ste_prague_reb3_helping"
										];
		}
		
		thread radio_dialogue( level.poi_added_dialog[ RandomInt( level.poi_added_dialog.size ) ] );
	}
	
	// Update team and notify
	level.so_prague_poi_array = poi_array;
	
	if ( poi_removed || poi_added )
	{
		level notify( "poi_team_updated" );
	}
}

poi_team_member_ignore_think( enemy_detect_dist )
{
	self endon( "death" );
	
	detect_dist2rd = squared( enemy_detect_dist );
	
	while ( 1 )
	{
		// If stealth spotted is set then the global
		// ignore manage logic for all poi team members
		// will manage ignoreme so wait for stealth to be
		// cleared
		if ( flag( "_stealth_spotted" ) )
		{
			flag_waitopen( "_stealth_spotted" );
		}
		
		self.ignoreme = true;
		
		ai_array = get_stealth_ai_living();
		foreach ( ai in ai_array )
		{
			if ( DistanceSquared( ai.origin, self.origin ) < detect_dist2rd )
			{
				self.ignoreme = false;
				break;
			}
		}
		
		wait 0.2;
	}
}

poi_team_member_scrub()
{
	if ( IsDefined( self.script_patroller ) )
	{
		self notify( "end_patrol" );
		// Upon notifying end patrol the patrol system goes back
		// and updates a bunch of values including clearing the
		// run anim. Wait untill frame end to get behind this.
		waittillframeend;
	}
	
	self.team = "allies";
	self disable_arrivals();
	self PushPlayer( false );
}

poi_collectible_think()
{
	level endon( "special_op_terminated" );
	
	poi_with_light = undefined;
	
	while ( 1 )
	{
		poi_waiting_array_clean();
		
		// make sure the poi with the light hasn't been collected
		if ( IsDefined( poi_with_light ) && !array_contains( level.so_prague_poi_waiting, poi_with_light ) )
		{
			StopFXOnTag( getfx( "dlight_red" ), poi_with_light, "tag_eye" );
			poi_with_light = undefined;
		}
		
		// make sure the closest poi has the light on them
		if ( level.so_prague_poi_waiting.size )
		{	
			poi_closest = undefined;
			poi_close_dist2rd = undefined;
			
			foreach ( poi in level.so_prague_poi_waiting )
			{
				player_close = get_closest_player_healthy( poi.origin );
				player_dist2rd = DistanceSquared( player_close.origin, poi.origin );
				
				if ( !IsDefined( poi_closest ) || player_dist2rd < poi_close_dist2rd )
				{
					poi_closest = poi;
					poi_close_dist2rd = player_dist2rd;
				}
			}
			
			if ( !IsDefined( poi_with_light ) || poi_with_light != poi_closest )
			{
				if ( IsDefined( poi_with_light ) )
				{
					StopFXOnTag( getfx( "dlight_red" ), poi_with_light, "tag_eye" );
				}
				PlayFXOnTag( getfx( "dlight_red" ), poi_closest, "tag_eye" );
				poi_with_light = poi_closest;
			}
		}
		
		waittill_any_timeout( 0.5, "poi_waiting_list_updated" );
	}
}

poi_waiting_array_clean()
{
	poi_array = [];
	
	foreach ( poi in level.so_prague_poi_waiting )
	{
		if ( IsDefined( poi ) && IsAlive( poi ) )
		{
			poi_array[ poi_array.size ] = poi;
		}
	}
	
	level.so_prague_poi_waiting = poi_array;
}

poi_make_collectible( ignoreme, ignoreme_set_delay )
{
	self endon( "death" );
	
	AssertEx( IsDefined( ignoreme ), "Ignoreme must be set." );
	
	if ( !IsDefined( level.so_prague_poi_waiting ) )
	{
		level.so_prague_poi_waiting = [];
		thread poi_collectible_think();
	}
	
	poi_collectible_add( self );
	
	self poi_team_member_scrub();
	
	if ( IsDefined( ignoreme_set_delay ) )
	{
		self thread poi_collectible_set_ignoreme( ignoreme, ignoreme_set_delay );
	}
	else
	{
		self.ignoreme = ignoreme;
	}
	self.ignoreall = true;
	self.combatmode = "no_cover";
	self.goalradius = 10;
	self.drawoncompass = false;
	self SetGoalPos( self.origin );
	
	use_ent = spawn( "script_model", self.origin + (0, 0, 28) ); 
	use_ent setModel( "tag_origin" );
	use_ent linkTo( self, "tag_origin", (0, 0, 28), (0, 0, 0) );
	use_ent setHintString( &"SO_STEALTH_PRAGUE_COLLECT_CIVILIAN" );
	use_ent MakeUsable();
	
	thread poi_collectible_clean_up( use_ent );
	
	use_ent waittill( "trigger", activator );
	
	Assert( IsPlayer( activator ), "Only a player should collect civilians." );
	activator.stat_civs_rescued[ activator.stat_civs_rescued.size ] = self;
	
	poi_collectible_remove( self );
	
	use_ent Unlink();
	use_ent Delete();
	
	poi_team_update( self );
}

poi_collectible_set_ignoreme( ignoreme, delay )
{
	self endon( "death" );
	
	wait delay;
	self.ignoreme = ignoreme;
}

poi_collectible_add( poi )
{
	if ( IsDefined( poi ) && IsAlive( poi ) && !array_contains( level.so_prague_poi_waiting, poi ) )
	{
		level.so_prague_poi_waiting[ level.so_prague_poi_waiting.size ] = poi;
	}
	
	level notify( "poi_waiting_list_updated" );
}

poi_collectible_remove( poi )
{
	level.so_prague_poi_waiting = array_remove( level.so_prague_poi_waiting, poi );
	
	level notify( "poi_waiting_list_updated" );
}

poi_collectible_clean_up( use_ent )
{
	self waittill( "death" );
	
	if ( IsDefined( use_ent ) )
	{
		use_ent Unlink();
		use_ent Delete();
	}
	
	if ( IsDefined( self ) )
	{
		StopFXOnTag( getfx( "dlight_red" ), self, "tag_eye" );
	}
}


// -.-.-.-.-.-.-.-.-.-.-.-. Misc -.-.-.-.-.-.-.-.-.-.-.-. //

trigger_radius_from_struct( struct, spawn_flags )
{
	Assert( IsDefined( struct ) );
	Assert( IsDefined( struct.radius ) );
	Assert( IsDefined( struct.height ) );
	
	spawn_flags = ter_op( IsDefined( spawn_flags ), spawn_flags, 0 );
	
	return Spawn( "trigger_radius", struct.origin, spawn_flags, struct.radius, struct.height );
}

ent_flag_notify_on_open( entity_flag, entity_notify )
{	
	self ent_flag_waitopen( entity_flag );
	
	self notify( entity_notify );
}