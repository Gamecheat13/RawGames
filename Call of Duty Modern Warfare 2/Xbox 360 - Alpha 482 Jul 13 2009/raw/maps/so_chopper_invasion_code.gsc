#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\so_chopper_invasion;

so_chopper_invasion_fx()
{
	level._effect[ "chopper_minigun_shells" ] = LoadFX( "shellejects/20mm_cargoship" );
}

chopper_minigun_shells()
{
	fx = getfx( "chopper_minigun_shells" );
	tag = "tag_turret";

	while ( 1 )
	{
		if ( self AttackButtonPressed() )
		{
			PlayFXOnTag( fx, level.chopper, tag );
		}

		wait( 0.05 );
	}
}

so_chopper_invasion_enemy_setup()
{
	level.enemies = [];

	allspawners = GetSpawnerTeamArray( "axis" );
	array_thread( allspawners, ::add_spawn_function, ::so_chopper_invasion_enemy_spawnfunc );
}

so_chopper_invasion_enemy_spawnfunc()
{
	self pathrandompercent_set( 800 );

	if ( IsSubStr( self.code_classname, "juggernaut" ) )
	{
		self thread so_chopper_invasion_juggernaut_init();
	}

	level.activeEnemies[ level.enemies.size ] = self;
	self thread so_chopper_invasion_enemy_deathcleanup();
}

so_chopper_invasion_juggernaut_init()
{
	self SetThreatBiasGroup( "juggernauts" );
	//self thread juggernaut_hud_box();
}

/*
juggernaut_hud_box()
{
	offset = ( 0, 0, 32 );
	Target_Set( self, offset );
	
	self waittill( "death" );
	Target_Remove( self );
}
*/

so_chopper_invasion_enemy_deathcleanup()
{
	self waittill( "death" );
	level.activeEnemies = array_remove( level.enemies, self );
}

// TODO maybe genericize this
get_targeted_line_array( start )
{
	arr = [];
	arr[ 0 ] = start;
	point = start;

	while ( IsDefined( point.target ) )
	{
		nextpoint = getstruct( point.target, "targetname" );

		if ( !IsDefined( nextpoint ) )
		{
			nextpoint = GetEnt( point.target, "targetname" );
		}

		if ( !IsDefined( nextpoint ) )
		{
			nextpoint = GetNode( point.target, "targetname" );
		}

		if ( !IsDefined( nextpoint ) )
		{
			nextpoint = GetVehicleNode( point.target, "targetname" );
		}

		if ( IsDefined( nextpoint ) )
		{
			arr[ arr.size ] = nextpoint;
		}
		else
		{
			break;
		}

		point = nextpoint;
	}

	return arr;
}

milliseconds( seconds )
{
	return seconds * 1000;
}

seconds( milliseconds )
{
	return milliseconds / 1000;
}

// AI Section ---------------------------------------------
ai_post_spawn()
{
	self endon( "death" );

	if ( !IsDefined( self.target ) )
	{
		return;
	}

	points = getstructarray( self.target, "targetname" );
	while ( 1 )
	{
		if ( points.size == 0 )
		{
			return;
		}

		point = points[ 0 ];
		if ( points.size > 1 )
		{
			point = points[ RandomInt( points.size ) ];
		}

		if ( IsDefined( point.radius ) )
		{
			self.goalradius = point.radius;
		}

		self SetGoalPos( point.origin );
		self waittill( "goal" );

		if ( IsDefined( point.script_noteworthy ) )
		{
			if ( point.script_noteworthy == "so_shoot_rpg" )
			{
				self.a.rockets = 1;
//				target = GetEnt( "so_rpg_target", "targetname" );
				self SetEntityTarget( level.chopper );

				self.ignoreall = false;
				level notify( "so_rpgs_shot" );
			}
		}

		if ( IsDefined( point.script_flag_wait ) )
		{
			flag_wait( point.script_flag_wait );
		}

		point script_delay();

		if ( IsDefined( point.script_noteworthy ) )
		{
			if ( point.script_noteworthy == "shoot_rpg" )
			{
				self ClearEntityTarget();
			}
		}

		if ( !IsDefined( point.target ) )
		{
			break;
		}

		points = getstructarray( point.target, "targetname" );
	}


	self.goalradius = level.default_goalradius;
}

friendlyfire()
{
	next_time = 0;
	duration = 3000;

	while ( 1 )
	{
		level.groundplayer waittill( "damage", dmg, attacker );

		if ( attacker == level.chopper )
		{
			if ( GetTime() > next_time )
			{
				next_time = GetTime() + duration;
				chopper_dialog( "friendlyfire" );
			}
		}
	}
}

// ---------------------
// --- CHOPPER STUFF ---
// ---------------------
#using_animtree( "vehicles" );
build_chopper()
{
	// Work around for creating vehicle
	maps\_vehicle::build_template( "blackhawk_minigun_so", "vehicle_blackhawk_minigun_hero" );
	maps\_vehicle::build_localinit( maps\_blackhawk_minigun::init_local );

	maps\_vehicle::build_drive( %bh_rotors, undefined, 0 );

	blackhawk_death_fx = [];
	blackhawk_death_fx[ "vehicle_blackhawk_minigun_low" ] 					 = "explosions/helicopter_explosion";
	blackhawk_death_fx[ "vehicle_blackhawk_minigun_hero" ] 					 = "explosions/helicopter_explosion";

	maps\_vehicle::build_deathfx( "explosions/grenadeexp_default", 		"tag_engine_left", 		"blackhawk_helicopter_hit", 			undefined, 			undefined, 		undefined, 		0.2, 		true );
	maps\_vehicle::build_deathfx( "explosions/grenadeexp_default", 		"elevator_jnt", 		"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.5, 		true );
	maps\_vehicle::build_deathfx( "fire/fire_smoke_trail_L", 			"elevator_jnt", 		"blackhawk_helicopter_dying_loop", 		true, 				0.05, 			true, 			0.5, 		true );
	maps\_vehicle::build_deathfx( "explosions/aerial_explosion", 		"tag_engine_right", 	"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
	maps\_vehicle::build_deathfx( "explosions/aerial_explosion", 		"tag_deathfx", 			"blackhawk_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		4.0 );
	maps\_vehicle::build_deathfx( blackhawk_death_fx[ "vehicle_blackhawk_minigun_hero" ], 			undefined, 				"blackhawk_helicopter_crash", 			undefined, 			undefined, 		undefined, 		 - 1, 		undefined, 	"stop_crash_loop_sound" );

	maps\_vehicle::build_treadfx();
	level.vehicle_treads[ "blackhawk_minigun_so" ] = undefined;

	maps\_vehicle::build_life( 999, 500, 1500 );

	maps\_vehicle::build_team( "allies" );

	maps\_vehicle::build_aianims( maps\_blackhawk_minigun::setanims, maps\_blackhawk_minigun::set_vehicle_anims );

	maps\_vehicle::build_attach_models( maps\_blackhawk_minigun::set_attached_models );

	maps\_vehicle::build_unload_groups( maps\_blackhawk_minigun::Unload_Groups );
	maps\_vehicle::build_compassicon( "helicopter", false );

	randomStartDelay = RandomFloatRange( 0, 1 );
	maps\_vehicle::build_light( "vehicle_blackhawk_minigun_hero", "cockpit_blue_cargo01", 		"tag_light_cargo01", 	"misc/aircraft_light_cockpit_red", 		"interior", 	0.0 );
	maps\_vehicle::build_light( "vehicle_blackhawk_minigun_hero", "cockpit_blue_cockpit01", 	"tag_light_cockpit01", 	"misc/aircraft_light_cockpit_blue", 	"interior", 	0.0 );
	maps\_vehicle::build_light( "vehicle_blackhawk_minigun_hero", "white_blink", 				"tag_light_belly", 		"misc/aircraft_light_white_blink", 		"running", 	randomStartDelay );
	maps\_vehicle::build_light( "vehicle_blackhawk_minigun_hero", "white_blink_tail", 			"tag_light_tail", 		"misc/aircraft_light_white_blink", 		"running", 	randomStartDelay );
	maps\_vehicle::build_light( "vehicle_blackhawk_minigun_hero", "wingtip_green", 				"tag_light_L_wing", 	"misc/aircraft_light_wingtip_green", 	"running", 	randomStartDelay );
	maps\_vehicle::build_light( "vehicle_blackhawk_minigun_hero", "wingtip_red", 				"tag_light_R_wing", 	"misc/aircraft_light_wingtip_red", 		"running", 	randomStartDelay );
}

chopper_defaults()
{
	self ClearGoalYaw();
	self chopper_default_speed();
	self SetHoverParams( 50, 10, 3 );
	self chopper_default_pitch_roll();
	self SetNearGoalNotifyDist( 200 );
}

chopper_default_pitch_roll()
{
	self SetMaxPitchRoll( 0, 0 );
}

chopper_default_speed()
{
//	self Vehicle_SetSpeed( 15, 7.5 );
//	self Vehicle_SetSpeed( 20, 10, 10 ); 
	self Vehicle_SetSpeed( 20, 20, 20 ); 
}

chopper_high_speed()
{
	self Vehicle_SetSpeed( 40, 20, 20 );
}

// Mouns the player to the chopper
chopper_playermount( player )
{
	player AllowCrouch( false );
	player AllowProne( false );
	player AllowSprint( false );
	player AllowJump( false );

	self maps\_blackhawk_minigun::player_mount_blackhawk_gun( true, player, false );
	self chopper_defaults();
}

chopper_dialog( alias )
{
	switch ( alias )
	{
		case "lift_off":
			level thread add_dialogue_line( "Pilot", "Gunslinger to ground, primary LZ is too hot! We've got ten-plus hostiles in our immediate AO and cannot remain on the ground, over!" );
			break;
		case "objective":
			level thread add_dialogue_line( "Pilot", "Ground forces, we're gonna link up at the secondary extraction point. Head for the roof of Nate's Bar, to the East. We'll cover you with the minigun from the sky. Gunner, you are cleared to engage hostiles. Watch out for friendlies on the ground, over." );
			break;
		case "drive_by":
			level thread add_dialogue_line( "Pilot", "Gunslinger to ground forces, find some cover! We are tracking a platoon-sized group of hostile foot-mobiles behind that barricade at the end of the street, over!" );
			break;
		case "start_drive_by":
			level thread add_dialogue_line( "Pilot", "Danger close ground forces, we're comin' in hot! Gunner, you are cleared to engage enemy tangoes by the barricade." );
			break;
		case "evade_rpgs":
			level thread add_dialogue_line( "Pilot", "Good effect on target, Gunner - whoa, hang on!" );
			break;
		case "evade_extra":
			level thread add_dialogue_line( "Pilot", "Ground forces be advised, we've got RPGs in the area, over.  Comin' back around for a strafing run here in a second." );
			break;
		case "drive_by_payback":
			level thread add_dialogue_line( "Pilot", "Gunslinger One to ground, we are starting our strafing run, over. Gunner, light 'em up." );
			break;
		case "drive_by_guns_guns_guns":
			level thread add_dialogue_line( "Pilot", "Guns guns guns." );
			break;
		case "back_to_squad":
			level thread add_dialogue_line( "Pilot", "Gunslinger One to ground, repositioning to your postiion, over." );
			break;
		case "convoy":
			level thread add_dialogue_line( "Pilot", "Gunslinger One to ground, be advised, we are tracking a convoy of enemy trucks movin' in from the southeast, recommend you let us handle those, over." );
			break;
		case "objective_reminder":
			msgs = [];
			msgs[ 0 ] = "Ground forces, link up on the roof of the restaurant!";
			msgs[ 1 ] = "Gunslinger One to ground, meet us up on the roof of Nate's Restaurant!";
			msgs[ 2 ] = "Ground forces, get to the roof of Nate's Restaurant!";

			level thread add_dialogue_line( "Pilot", msgs[ RandomInt( msgs.size ) ] );
			break;
		case "on_the_roof":
			level thread add_dialogue_line( "Pilot", "Gunslinger One to ground, we see you! Maintain your location on the roof, we're en route!" );
			break;
		case "end_reminder":
			msgs = [];
			msgs[ 0 ] = "Ground forces, let's go let's go! We are at the roof and ready to link up for extraction!";
			msgs[ 1 ] = "Ground forces, pick up the pace, we're sitting ducks up here!";

			level thread add_dialogue_line( "Pilot", msgs[ RandomInt( msgs.size ) ] );
			break;
		case "friendlyfire":
			msgs = [];
			msgs[ 0 ] = "Gunner, watch your fire - that's a friendly!";
			msgs[ 1 ] = "Gunner, that is friendly fire! Check your aim!";
			msgs[ 2 ] = "That's a friendly down there, Gunner! Focus up!";

			level thread add_dialogue_line( "Pilot", msgs[ RandomInt( msgs.size ) ] );

			break;
		default:
			break;
	}
}

// Kicks off the chopper threads
chopper_think()
{
//	draw_high_obstacles();

	self SetMaxPitchRoll( 30, 30 );

	level.chopper_segment_points 	= 15;
	level.chopper_range_from_point 	= 1300;

	level.chopper_base_elevation 	= 3100;
	level.chopper_lookat_point 		= level.groundplayer.origin;

//	self thread chopper_base_elevation_think();

	chopper_dialog( "lift_off" );

	// initial getting into the air
	liftoffPath = get_targeted_line_array( self.start );

	for ( i = 1; i < liftoffPath.size; i++ )
	{
		if ( i == 1 )
		{
			self Vehicle_SetSpeed( 20, 6, 6 );
		}
		else
		{
			self chopper_default_speed();
		}

		node = liftoffPath[ i ];

		self SetGoalYaw( node.angles[ 1 ] );
		self SetVehGoalPos( node.origin, 0 );
		self waittill_either( "near_goal", "goal" );
	}

	chopper_dialog( "objective" );

	self chopper_defaults();
	
// Show the groundplayer icon on the chopperplayer
// UNCOMMENT ME WHEN CODE IS WORKING!
//	Target_Set( level.groundplayer, ( 0, 0, 32 ) );
//	Target_SetShader( level.groundplayer, "hud_fofbox_self" );
//	Target_ShowToPlayer( level.groundplayer, level.chopperplayer );
//	test_chopper_paths();

	self thread chopper_gun_face_entity( level.groundplayer );
	self thread chopper_move_with_player();
//	self thread chopper_target();

	self thread debug_chopper_base_path();
}

test_chopper_paths()
{
	level.chopper thread chopper_follow_path( "so_chopper_driveby", true );

	level waittill( "never" );
}

chopper_target()
{
	while ( 1 )
	{
		wait( 0.5 );
		foreach ( ai in GetAiArray( "axis" ) )
		{
			if ( !IsDefined( ai.showing_as_target ) && IsAlive( ai ) && !( IsDefined( ai.a.special ) && ai.a.special == "none" ) )
			{
				ai.showing_as_target = true;
				Target_Set( ai, ( 0, 0, 32 ) );
				Target_SetShader( ai, "remotemissile_infantry_target" );
				Target_ShowToPlayer( ai, level.chopperplayer );
			}
		}
	}
}

//chopper_base_elevation_think()
//{
//	self endon( "death" );
//
//	while ( 1 )
//	{
//		if ( self.origin[1] < 500 )
//		{
//			level.chopper_base_elevation = 3200;
//		}
//		else
//		{
//			level.chopper_base_elevation = 3200;
//		}
//
//		wait( 0.1 );
//	}
//}

// Handles the chopper orientation with the ground player
chopper_gun_face_entity( ent, wait_for_goal )
{
	self endon( "stop_chopper_gun_face_entity" );

	if ( !IsDefined( level.chopper_gun_ground_entity ) )
	{
		level.chopper_gun_ground_entity = Spawn( "script_origin", self.origin );
	}

	if ( IsDefined( wait_for_goal ) )
	{
		self SetMaxPitchRoll( 20, 20 );
//		self waittill_either( "near_goal", "goal" );
		self waittill( "chopper_near_goal" );

		self chopper_default_pitch_roll();
	}

	self delayCall( 1, ::SetLookAtEnt, level.chopper_gun_ground_entity );

	while ( 1 )
	{
		if ( ent == level.groundplayer )
		{
			lookat_origin = level.chopper_lookat_point;
		}
		else
		{
			lookat_origin = ent.origin;
		}

		// "forward" = vector from the chopper to the groundplayer
		forwardvec = VectorNormalize( lookat_origin - self.origin );
		forwardangles = VectorToAngles( forwardvec );
		rightvec = AnglesToRight( forwardangles );
		backvec = rightvec * -1;
		neworigin = self.origin + ( backvec * 100 );

		level.chopper_gun_ground_entity.origin = neworigin;

		wait( 0.05 );
	}
}

// Overall chopper movement thread
chopper_move_with_player( player )
{
	thread debug_player_pos();
	self.chopper_pathpoint = chopper_get_closest_pathpoint( 4 );
	self.no_bline_to_goal = true;
	just_started = true;

	while ( 1 )
	{
		if ( self ent_flag( "manual_control" ) )
		{
			wait( 0.1 );
			continue;
		}

		self SetNearGoalNotifyDist( 200 );

		chopper_move_till_goal();

		self.chopper_pathpoint = chopper_get_next_pathpoint( self.chopper_pathpoint[ "index" ] );

		if ( just_started )
		{
			just_started = false;
			self.no_bline_to_goal = false;
		}
	}
}

// Keeps updating the choppers goal, incase the ground player moves, will end once the chopper
// reaches it's goal.
chopper_move_till_goal()
{
	self endon( "chopper_near_goal" );
	self endon( "manual_control" );

	self thread chopper_notify_near_goal();
	is_far = false;

	while ( 1 )
	{
		pos = chopper_get_pathpoint( self.chopper_pathpoint[ "index" ] );

		level thread debug_draw_chopper_line( pos, "final_destination", ( 0, 1, 0 ) );

		// If the chopper is too far away from it's goal, figure out a b-line path to the closest
		// Assume that we need to get back on track...
		if ( !self.no_bline_to_goal && distance2d_squared( pos, self.origin ) > 1000 * 1000 )
		{
			// Stop the endon until we are close enough
			is_far = true;
			self notify( "stop_chopper_notify_near_goal" );
			info = chopper_get_closest_pathpoint();

			pos = info[ "point" ];
			self.chopper_pathpoint = info;

			level thread debug_draw_chopper_line( pos, "final_destination", ( 0, 1, 0 ) );

			pos = chopper_get_bline_path_point( pos );

			level thread debug_draw_chopper_line( pos, "closer_point" );

			self SetVehGoalPos( pos );
			self waittill_either( "near_goal", "goal" );
			continue;
		}
		else
		{
			if ( is_far )
			{
				// Reinitiate the chopper_notify_near_goal since we stopped it before
				self thread chopper_notify_near_goal();
			}

			is_far = false;
		}

//		Line( pos, pos + ( 0, 0, 2000 ), ( 1, 1, 0 ), 2 );

		level thread debug_draw_chopper_line( pos, "closer_point" );
		self SetVehGoalPos( pos );
		wait( 0.1 );
	}
}

chopper_notify_near_goal()
{
	self notify( "stop_chopper_notify_near_goal" );
	self endon( "stop_chopper_notify_near_goal" );

	self waittill_either( "near_goal", "goal" );
	self notify( "chopper_near_goal" );
}

// Returns the 1 chopper flight path, depending on the num passed in
chopper_get_pathpoint( num )
{
	add_angles = ( 360 / level.chopper_segment_points ) * -1;//* - 1 to have the reverse effect of movement( forward )

	angles = ( 0, add_angles * num, 0 );
	forward = AnglesToForward( angles );
//	point = level.groundplayer.origin + vector_multiply( forward, level.chopper_range_from_point );

	if ( is_player_in_parking_lot() )
	{
		level.chopper_lookat_point = get_parkinglot_point();
		point = level.chopper_lookat_point + vector_multiply( forward, level.chopper_range_from_point );
	}
	else
	{
		level.chopper_lookat_point = get_closest_point_on_base_path();
		point = level.chopper_lookat_point + vector_multiply( forward, level.chopper_range_from_point );
	}

	point = chopper_get_pointheight( point );

	return point;
}

chopper_get_bline_path_point( pos )
{
	angles = VectorToAngles( pos - level.chopper.origin );
	forward = AnglesToForward( angles );
	point = level.chopper.origin + vector_multiply( forward, 500 );

	point = chopper_get_pointheight( point );

	return point;
}

// Returns all of the choppers flight path points
chopper_get_pathpoints()
{
	points = [];

	for ( i = 0; i < level.chopper_segment_points; i++ )
	{
		points[ i ] = chopper_get_pathpoint( i );
	}

	return points;
}

// Takes the given point and adjusts it's Z coordinate depending on the obstacles.
chopper_get_pointheight( point )
{
	base = level.chopper_base_elevation;
	height = base;

	info = chopper_get_closest_obstacle_info( point );

	if( IsDefined( info[ "struct" ] ) )
	{
		if ( info[ "dist" ] < info[ "min_radius" ] )
		{
			height =  info[ "struct" ].origin[ 2 ];
		}
		else
		{
//			height = level.chopper_base_elevation + ( ( info[ "struct" ].origin[ 2 ] - level.chopper_base_elevation ) * ( info[ "dist" ] / ( info[ "max_radius" ] - info[ "min_radius" ] ) ) );
			height_diff = info[ "struct" ].origin[ 2 ] - level.chopper_base_elevation;
			height_perc = info[ "dist" ] / ( info[ "max_radius" ] - info[ "min_radius" ] );
			height = base + ( height_diff * height_perc );
		}

		if( height < base )
		{
			height = base;
		}
	}

	point = ( point[ 0 ], point[ 1 ], height );

	return point;
}

// Return the closest and highest struct
chopper_get_closest_obstacle_info( point )
{
	structs = getstructarray( "high_obstacle", "targetname" );

	// First find all of the structs the point within it's radius.
	close_structs = [];
	dist_array = [];
	min_radius_array = [];
	max_radius_array = [];
	foreach ( struct in structs )
	{
		max_radius = 600;
		if ( IsDefined( struct.radius ) )
		{
			max_radius = struct.radius;
		}

		min_radius = max_radius * 0.5;

		test_dist = Distance2d( point, struct.origin );
		if ( test_dist < max_radius )
		{
			close_structs[ close_structs.size ] 		= struct;
			dist_array[ dist_array.size ] 				= test_dist;
			min_radius_array[ min_radius_array.size ] 	= min_radius;
			max_radius_array[ max_radius_array.size ] 	= max_radius;
		}
	}

	// Now filter out the highest struct and return it
	highest_struct = undefined;
	dist = undefined;
	min_radius = undefined;
	max_radius = undefined;
	if ( close_structs.size > 0 )
	{
		highest_struct 	= close_structs[ 0 ];
		dist 			= dist_array[ 0 ];
		min_radius 		= min_radius_array[ 0 ];
		max_radius 		= max_radius_array[ 0 ];

		for ( i = 1; i < close_structs.size; i++ )
		{
			if ( close_structs[ i ].origin[ 2 ] > highest_struct.origin [ 2 ] )
			{
				highest_struct 	= close_structs[ i ];
				dist 			= dist_array[ i ];
				min_radius 		= min_radius_array[ i ];
				max_radius 		= max_radius_array[ i ];
			}
		}
	}

	info = [];
	info[ "struct" ] 	 	= highest_struct;
	info[ "dist" ] 		 	= dist;
	info[ "min_radius" ] 	= min_radius;
	info[ "max_radius" ]	= max_radius;

	return info;
}

// Returns the next point (in array form for extra info) on the path
chopper_get_next_pathpoint( num )
{
	points = chopper_get_pathpoints();

	num++;

	if ( num >= points.size )
	{
		num = 0;
	}

	info = [];
	info[ "point" ] = points[ num ];
	info[ "index" ] = num;

	return info;
}

// Returns the closest point (in array form for extra info) on the path
chopper_get_closest_pathpoint( add_index )
{
	points = chopper_get_pathpoints();

	dist = DistanceSquared( points[ 0 ], level.chopper.origin );
	closest = points[ 0 ];
	index = 0;

	foreach ( i, point in points )
	{
		test = DistanceSquared( point, level.chopper.origin );
		if ( test < dist )
		{
			closest = point;
			index = i;
			dist = test;
		}
	}

	info = [];
	if ( IsDefined( add_index ) )
	{
		index = index + add_index;

		if ( index > level.chopper_segment_points )
		{
			index = index - level.chopper_segment_points;
		}

		info[ "point" ] = chopper_get_pathpoint( index );
		info[ "index" ] = index;		
	}
	else
	{
		info[ "point" ] = closest;
		info[ "index" ] = index;
	}

	return info;
}

chopper_follow_path( path_targetname, follow_player_when_done, dialog, safe_flight )
{
	self notify( "stop_chopper_gun_face_entity" );
	self ClearLookAtEnt();

	self ent_flag_set( "manual_control" );

	if ( !IsDefined( safe_flight ) )
	{
		safe_flight = false;
	}

	path_start = getstruct( path_targetname, "targetname" );
	path_point = path_start;
	going_to_start = true;

	while ( IsDefined( path_point ) )
	{
		if ( IsDefined( path_point.speed ) )
		{
			speed = path_point.speed;

			accel = 20;
			decel = 10;

			if ( IsDefined( path_point.script_accel ) )
			{
				accel = path_point.script_accel;
			}

			if ( IsDefined( path_point.script_decel ) )
			{
				decel = path_point.script_decel;
			}

			self Vehicle_SetSpeed( path_point.speed, accel, decel );
		}

		if ( IsDefined( path_point.radius ) )
		{
			self SetNearGoalNotifyDist( path_point.radius );
		}

		stop_at_goal = false;
		if ( IsDefined( path_point.script_stopnode ) && path_point.script_stopnode )
		{
			stop_at_goal = true;
		}

		self SetGoalYaw( path_point.angles[ 1 ] );

		// If the chopper is too far away from it's goal, figure out a b-line path
		if ( going_to_start && safe_flight )
		{
			while ( distance2d_squared( path_point.origin, self.origin ) > 1000 * 1000 )
			{
				point = chopper_get_bline_path_point( path_point.origin );
				self SetVehGoalPos( point, stop_at_goal );
				self waittill_either( "near_goal", "goal" );
			}
		}

		self SetVehGoalPos( path_point.origin, stop_at_goal );
		self waittill_either( "near_goal", "goal" );

		if ( IsDefined( path_point.script_flag_set ) )
		{
			flag_set( path_point.script_flag_set );
		}

		going_to_start = false;

		if ( IsDefined( path_point.script_noteworthy ) )
		{
			[[level.chopper_funcs[ path_point.script_noteworthy ]]]();
		}

		path_point script_delay();

		if ( !IsDefined( path_point.target ) )
		{
			break;
		}

		path_point = getstruct( path_point.target, "targetname" );
	}

	self notify( "follow_path_done" );
	
	if ( IsDefined( follow_player_when_done ) )
	{
		self chopper_defaults();
		self.chopper_pathpoint = chopper_get_closest_pathpoint();
		self ent_flag_clear( "manual_control" );
		self thread chopper_gun_face_entity( level.groundplayer, true );
	}

	if ( IsDefined( dialog ) )
	{
		chopper_dialog( dialog );
	}
}

get_parkinglot_point()
{
	point = level.groundplayer.origin;

	point = ( Clamp( point[ 0 ], -2400, 3100 ), Clamp( point[ 1 ], -5300, -700 ), point[ 2 ] );

	return point;
}

get_closest_point_on_base_path()
{
	paths = [];
	struct_array = getstructarray( "base_player_path", "targetname" );

	foreach ( struct in struct_array )
	{
		paths[ paths.size ] = get_targeted_line_array( struct );
	}

	points = [];
	foreach ( path in paths )
	{
		for ( i = 0; i < path.size - 1; i++ )
		{
			points[ points.size ] = PointOnSegmentNearestToPoint( path[ i ].origin, path[ i + 1 ].origin, level.groundplayer.origin );
		}
	}

	dist = DistanceSquared( points[ 0 ], level.groundplayer.origin );
	closest_point = points[ 0 ];

	foreach ( point in points )
	{
		test_dist = DistanceSquared( point, level.groundplayer.origin );
		if ( test_dist < dist )
		{
			closest_point = point;
			dist = test_dist;
		}
	}

	// Let's not go more than 200 units off the base path
	if ( distance2d_squared( closest_point, level.groundplayer.origin ) > 200 * 200 )
	{
		angles = VectorToAngles( level.groundplayer.origin - closest_point );
		forward = AnglesToForward( angles );
		closest_point = closest_point + vector_multiply( forward, 200 );
	}
	else
	{
		closest_point = level.groundplayer.origin;
	}
	

	return closest_point;
}

distance2d_squared( pos1, pos2 )
{
	pos1 = ( pos1[ 0 ], pos1[ 1 ], 0 );
	pos2 = ( pos2[ 0 ], pos2[ 1 ], 0 );

	return DistanceSquared( pos1, pos2 );
}

is_player_in_parking_lot()
{
	return level.groundplayer IsTouching( GetEnt( "so_parkinglot", "targetname" ) );
}

// TRUCK Section ------------------------------------------
truck_init()
{
	level.truck_spawner = GetEnt( "gas_station_truck", "targetname" );
	level.truck_ai_spawners = GetEntArray( "so_truck_ai_spawner", "targetname" );
}

spawn_truck( targetname )
{
	spawner = level.truck_spawner;
	ai_spawners = level.truck_ai_spawners;

	spawner.script_startinghealth = 5000;

	spawner.targetname = "so_truck";
	spawner.target = targetname;
	foreach ( ai_spawner in ai_spawners )
	{
		ai_spawner.targetname = targetname;
	}

	truck = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "so_truck" );
	truck thread truck_brakes();
}

truck_brakes()
{
	self waittill( "unloading" );
	self set_brakes( 0.5 );
}

// DEBUG Section ------------------------------------------
debug_chopper_base_path()
{
/#
	if ( !debug_chopper_enabled() )
	{
		return;
	}

	while ( 1 )
	{
		wait( 0.05 );

		if ( is_player_in_parking_lot() )
		{
			continue;
		}

		closest_point = get_closest_point_on_base_path();

//		level thread draw_linesegment_point( closest_point );
		Line( closest_point, closest_point + ( 0, 0, 1000 ), ( 1, 0.5, 0 ) );
		Line( closest_point, level.groundplayer.origin, ( 1, 1, 1 ) );
	}
#/
}

// Draw the player's location with chopper flight path
// Dvar debug_follow + number will have the fake ground player move along a path
// If not using debug_follow, the player can hit use to update the fake ground player's origin 
// to whatever the chopper player is aiming at.
debug_player_pos()
{
/#
	if ( !debug_chopper_enabled() )
	{
		return;
	}

	level.groundplayer.origin = ( 84, 4450, 2260 );
	thread draw_player_pos();
	thread draw_chopper_path();

	if ( GetDvarInt( "debug_follow" ) != 0 )
	{
		num = GetDvarInt( "debug_follow" );
		start = getstruct( "follow_player_path_start" + num, "targetname" );
		struct = start;
		speed = 200;

		debug_trigger_everything();
		while ( 1 )
		{
			dist = Distance( level.groundplayer.origin, struct.origin );
			time = dist / speed;

			level.groundplayer MoveTo( struct.origin, time, 0, 0 );
			level.groundplayer waittill( "movedone" );

			struct script_delay();

			if( IsDefined( struct.target ) )
			{
				struct = getstruct( struct.target, "targetname" );
			}
			else
			{
				struct = start;
				debug_trigger_everything();
				so_chopper_invasion_moments();
				debug_kill_ai();
			}
		}
	}
	else
	{
		while ( 1 )
		{
			wait( 0.05 );
	
			if ( level.player UseButtonPressed() )
			{
				eye = level.player GetEye();
				forward = AnglesToForward( level.player GetPlayerAngles() );
				forward_origin = eye + vector_multiply( forward, 10000 );
				trace = BulletTrace( level.player GetEye(), forward_origin, false, self );
	
				level.groundplayer.origin = trace[ "position" ];
			}
		}
	}
#/
}

debug_trigger_everything()
{
/#
	foreach ( trigger in GetEntArray( "trigger_multiple_spawn", "classname" ) )
	{
		trigger thread debug_trigger_everything_think();
	}
#/
}

debug_trigger_everything_think()
{
/#
	self notify( "stop_debug_trigger_everything_think" );
	self endon( "stop_debug_trigger_everything_think" );

	if ( !IsDefined( self.spawners ) )
	{
		self.spawners = GetEntArray( self.target, "targetname" );
		foreach ( spawner in self.spawners )
		{
			spawner.old_count = spawner.count;
		}
	}
	else
	{
		foreach ( spawner in self.spawners )
		{
			spawner.count = spawner.old_count;
		}
	}

	while ( 1 )
	{
		wait( 0.05 );
		if ( level.groundplayer IsTouching( self ) )
		{
			break;
		}
	}

	self notify( "trigger" );
#/
}

// Draws the chopper flight path
draw_chopper_path()
{
/#
	while ( 1 )
	{
		wait( 0.05 );

		points = chopper_get_pathpoints();

		for ( i = 0; i < points.size; i++ )
		{
			next = i + 1;

			if ( next == points.size )
			{
				next = 0;
			}

			Line( points[ i ], points[ next ], ( 1, 1, 0.3 ) );
		}
	}
#/
}

draw_linesegment_point( pos )
{
/#
	level notify( "stop_draw_linesegment_point" );
	level endon( "stop_draw_linesegment_point" );	

	while ( 1 )
	{
		Line( pos, pos + ( 0, 0, 1000 ), ( 1, 1, 0.1 ) );
		wait( 0.05 );
	}
#/
}

// Draws the ground player's position
draw_player_pos( pos )
{
/#
	while ( 1 )
	{
		wait( 0.05 );
		Line( level.groundplayer.origin, level.groundplayer.origin + ( 0, 0, 1000 ), ( 0.3, 1, 0.3 ) );
	}
#/
}

// Draws all of the high objstacle points
draw_high_obstacles()
{
/#
	structs = getstructarray( "high_obstacle", "targetname" );
	foreach ( struct in structs )
	{
		struct thread draw_high_obstacle();
	}
#/
}

draw_high_obstacle()
{
/#
	while ( 1 )
	{
		wait( 0.05 );
		Line( self.origin, self.origin + ( 0, 0, -5000 ), ( 1, 1, 1 ) );
	}
#/
}

debug_kill_ai()
{
/#
	foreach ( ai in GetAIArray( "axis" ) )
	{
		ai Kill();
	}
#/
}

debug_chopper_enabled()
{
/#
	return GetDvarInt( "debug_chopper" ) == 1;
#/
}

debug_draw_chopper_line( pos, note, color )
{
/#
	level notify( note );
	level endon( note );

	if ( !IsDefined( color ) )
	{
		color = ( 1, 1, 1 );
	}

	if ( !debug_chopper_enabled() )
	{
		return;
	}

	while ( 1 )
	{
		wait( 0.05 );
		Line( pos, level.chopper.origin, color );
	}
#/
}