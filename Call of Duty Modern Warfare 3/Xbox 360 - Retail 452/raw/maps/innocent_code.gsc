#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;


init_level()
{
	level.default_sort = -5;
	level.friendlyfire_destructible_attacker = true;

	init_level_flags();
	precache_level();
	maps\london_code::init_sas_squad();

}

init_level_post_load()
{
	SetSavedDvar( "ui_hideMap", "0" );
	maps\_compass::setupMiniMap( "compass_map_london_station" , "station_minimap_corner" );
	array_spawn_function_noteworthy( "innocent_truck_riders", ::postspawn_truck_rider );

	// Crazy audio stuff
	maps\_audio::aud_use_string_tables();
	maps\_audio::aud_set_occlusion("default");
	maps\_audio::aud_set_timescale();
}

precache_level()
{
	PrecacheShader( "overlay_grain" );
	PrecacheShader( "cam_51ch" );
	PrecacheShader( "cam_battery" );
	PrecacheShader( "cam_button_home" );
	PrecacheShader( "cam_button_options" );
	PrecacheShader( "cam_button_play" );
	PrecacheShader( "cam_hdsp" );
	PrecacheShader( "cam_portrait" );
	PrecacheShader( "cam_checkerboard" );
	PrecacheShader( "cam_checkerboard2" );
	PrecacheShader( "cam_scramble" );

	PrecacheShader( "cam_splash" );

	PrecacheModel( "pigeon_fly_iw5" );
}

init_level_flags()
{
	flag_init( "fade_up" );

	flag_init( "splashscreen_off" );
	flag_init( "truck_explodes" );
	flag_init( "after_first_anim_stop" );
	flag_init( "start_the_scene" );
	flag_init( "cab_passed_side_street" );
	flag_init( "feeder_traffic" );
	flag_init( "couple_past_civilian" );
	flag_set( "feeder_traffic" );

	flag_init( "got_contact" );
	flag_init( "innocent_ambient_switched" );
}

postspawn_truck_rider()
{
	self waittill( "goal" );
	self Delete();
}

//---------------------------------------------------------
// Starts Section
//---------------------------------------------------------


// Modded Introscreen Section 
//---------------------------------------------------------
intro_lines()
{
	level.intro_offset = 0;

	lines = [];
	lines[ lines.size ] = &"INNOCENT_LINEFEED_1";
	lines[ lines.size ] = &"INNOCENT_LINEFEED_2";
//	lines[ lines.size ] = &"INNOCENT_LINEFEED_3";

	foreach ( i, l in lines )
	{
		thread intro_line_thread( l, ( lines.size - i - 1 ) );
		wait( 1 );
	}
}

intro_line_thread( string, num )
{
	level notify( "new_introscreen_element" );

	level.intro_offset++;

	color = ( 0.8, 1.0, 0.8 );
	glowColor = ( 0.3, 0.6, 0.3 );

	y = maps\_introscreen::_CornerLineThread_height();

	hudelem = NewHudElem();
	hudelem.x = 20;
	hudelem.y = y;
	hudelem.alignX = "left";
	hudelem.alignY = "bottom";
	hudelem.horzAlign = "left";
	hudelem.vertAlign = "bottom";
	hudelem.sort = 1;// force to draw after the background
	hudelem.foreground = true;
	hudelem SetText( string );
	hudelem.alpha = 0;
	hudelem FadeOverTime( 0.2 );
	hudelem.alpha = 1;

	hudelem.hidewheninmenu = true;
	hudelem.fontScale = 2.0;// was 1.6 and 2.4, larger font change
	hudelem.color = color;
	hudelem.font = "objective";
	hudelem.glowColor = glowcolor;
	hudelem.glowAlpha = 1;
	duration = Int( ( num * 1000 ) + 4000 );
	hudelem SetPulseFX( 30, duration, 700 );// something, decay start, decay duration
	
	thread maps\_introscreen::hudelem_destroy( hudelem );

//	wait( 0.2 );
//	hudelem ChangeFontScaleOverTime( 5 );
//	hudelem.fontScale = 2.2;
//	hudelem FadeoverTime( 10 );
//	hudelem.alpha = 0;
}

//---------------------------------------------------------
// Camera Section
//---------------------------------------------------------
camera_fall()
{
	wait( 0.2 );

	thread camera_fall_blur();
	level.player ViewKick( 60, level.wife.origin );
//	wait( 0.5 );

//	SetSlowMotion( 1.0, 0.2, 0.3 );
//	noself_delayCall( 0.5, ::SetSlowMotion, 0.2, 1.0, 0.5 );

	level notify( "stop_shakey_cam" );
	level.player FreezeControls( true );

	level notify( "stop_camera_ads" );
	level.player LerpFov( 55, 0.2 );

	start = getstruct( "dot_line", "targetname" );
	end = getstruct( start.target, "targetname" );	
	dir = vectornormalize( start.origin - end.origin );

	level.ground_ref_ent RotateTo( ( 0, 0, 0 ), 0.2 );

	player_pos = level.player.origin;
	delta = level.player GetEye() - level.player.origin;

	base = spawn_tag_origin();
	base.origin = level.player.origin;
	base.angles = VectorToAngles( level.daughter_origin - level.player.origin );

	eye_model = spawn_tag_origin();
	eye_model.angles = base.angles;
	eye_model.origin = level.player GetEye();
	base LinkTo( eye_model );

	level thread player_blast_linkto( base );

	// The jump up
	dir_move = dir * 20;

	origin = eye_model.origin;
	eye_model MoveTo( origin + dir_move + ( 0, 0, 20 ), 0.1, 0.05, 0.05 );
	wait( 0.1 );
	eye_model MoveTo( origin + ( dir_move * 2 ) + ( 0, 0, -20 ), 0.1, 0.05 );
	wait( 0.1 );

	fall_time = delta[ 2 ] / 120;
	eye_model MoveTo( player_pos + ( dir_move * 3 ) + ( 0, 0, 10 ), fall_time, fall_time );
	eye_model RotateTo( eye_model.angles + ( 0, 0, 80 ), fall_time );

	wait( fall_time + 0.05 );
	EarthQuake( 0.5, 0.5, eye_model.origin, 200 );

	thread post_camerafall( eye_model.angles );

	level.camera_fall_angles = eye_model.angles;
	base_angles = eye_model.angles;
	roll = 3;
	time = 0.2;
	for ( i = 0; i < 6; i++ )
	{
		eye_model RotateTo( base_angles + ( roll, 0, 0 ), time, time * 0.5, time * 0.5 );
		wait( time );

		roll -= 0.3;
		roll *= -1;
		time *= 1.5;

		EarthQuake( 0.1, time * 2, eye_model.origin, 200 );
	}
}

player_blast_linkto( base )
{
	time = 0.2;
	tag = "tag_origin";
	level.player PlayerLinkToBlend( base, tag, time, time * 0.9 );
//	wait( time );
//	level.player PlayerLinkTo( base, tag, 1, 0, 0, 0, 0, true );
}

post_camerafall( angles )
{
//	base = getstruct( "camera_base", "targetname" );

//	camera_guy_spot = getstruct( "camera_guy_spot", "targetname" );
//	delta_pos = camera_guy_spot.origin - base.origin;
//	delta_angles = camera_guy_spot.angles - base.angles;

//	player_eye = drop_to_ground( level.player GetEye(), 30, -1000 );
//	player_angles = level.player GetPlayerAngles();

//	camera_guy = spawn_targetname( "camera_guy" );
//	origin = get_world_relative_offset( player_eye, player_angles, delta_pos );
//	camera_guy.origin = ( origin[ 0 ], origin[ 1 ], 46 );
//	camera_guy.angles = player_angles - delta_angles;
//
//	temp = SpawnStruct();
//	temp.origin = camera_guy.origin;
//	temp.angles = player_angles + delta_angles;
//
//	temp thread anim_generic( camera_guy, "camera_guy_death" );
}


camera_fall_blur()
{
	SetBlur( 5, 0.2 );
	wait( 0.5 );	
	SetBlur( 0, 2 );
}

camera_cut()
{
	ent = Spawn( "script_origin", level.player.origin );
	forward = AnglesToForWard( level.player GetPlayerAngles() );
	start_pos = level.player GetEye();

	sound_ent = Spawn( "script_origin", level.player GetEye() );

	thread dof_think( ent, "ending" );
	max_dist = Distance( level.player.origin, level.wife_origin );

	for( i = 0; i < 9; i++ )
	{
		if ( i % 2 == 0 )
		{
			// Near 
			sound_ent PlayLoopSound( "scn_videocamera_zoom_loop2" );
			pos = start_pos + ( forward * RandomFloatRange( 0, 32 ) );
		}
		else
		{
			sound_ent PlayLoopSound( "scn_videocamera_zoom_loop" );
			pos = start_pos + ( forward * RandomFloatRange( max_dist - 25, max_dist + 25 ) );
		}

		if ( i == 5 )
		{
			fx = getfx( "poisonous_gas_spillage_innocent_dood" );
			forward = AnglesToForward( level.camera_fall_angles );
			backward = AnglesToForward( level.camera_fall_angles + ( 0, 180, 0 ) );
			origin = level.player GetEye() + ( forward * 200 );
			
			PlayFx( fx, origin, backward );
		}

//		speed = RandomFloatRange( 50, 100 );
//		dist = Distance( ent.origin, pos );
//		move_time = dist / speed;

		move_time = RandomFloatRange( 0.5, 1 );

		ent MoveTo( pos, move_time );
		wait( move_time );

		sound_ent StopLoopSound();
	
		delay = RandomFloatRange( 0.2, 0.75 );
//		delay = Max( delay, 0.2 );
		wait( delay );
	}

	foreach ( hud in level.cam_huds )
	{
		hud Destroy();
	}

	vision_set_changes( "cheat_invert", 0 );
	wait( 0.5 );

	full_hud = create_cut_hud( "cam_scramble", 800, 600 );
	full_hud.x -= 60;
	full_hud.y -= 20;
	full_hud.alpha = 0.5;

	wait( 0.1 );

	full_hud.x = 0;
	full_hud.y = 0;
	full_hud.alpha = 0.95;
	full_hud.color = ( 0.5, 0.2, 0.2 );

	wait( 0.1 );

	checker = create_cut_hud( "cam_checkerboard2", 640, 256 );
	checker.x += 3;
	checker.y -= 128;
	checker.alpha = 0.2;
	checker.alignY = "top";
	checker.color = ( 0.238, 0.328, 0.246 );
	checker.sort += 1;

	wait( 0.1 );

	checker SetShader( "cam_checkerboard", 640, 256 );
	checker.alpha = 0.5;
	checker.x += 9;
	checker.y = -64;
	checker.color = ( 0.015, 0.101, 0.015 );
	checker.color = ( 1, 1, 1 );

	wait( 0.1 );

	play_loopsound_in_space( "tinnitus_soft_loop", level.player GetEye() );
	
	black = get_black_overlay();
	black.alpha = 1;

	wait( 0.05 );
	maps\_audio_mix_manager::MM_start_preset( "mute_all" );

	wait( 0.25 );
	nextmission();
}

camera_hud()
{
	huds = [];
	huds[ "rec" ] 		= create_hud_rec();
	huds[ "time" ] 		= create_hud_time();
	huds[ "btn_home" ] 	= create_hud_shader( "cam_button_home", "top_left", 128, 64 );
	huds[ "51ch" ] 		= create_hud_shader( "cam_51ch", "top_left", 128, 64 );
	huds[ "51ch" ].y += 60;
	huds[ "battery" ] 	= create_hud_shader( "cam_battery", "top_left", 256, 64 );
	huds[ "battery" ].x += 60;
	huds[ "hdsp" ] 		= create_hud_shader( "cam_hdsp", "top_left", 128, 64 );
	huds[ "hdsp" ].y += 30;
	huds[ "play" ] 		= create_hud_shader( "cam_button_play", "bottom_left", 128, 64 );
	huds[ "options" ] 	= create_hud_shader( "cam_button_options", "bottom_right", 128, 64 );
	huds[ "portrait" ] 	= create_hud_shader( "cam_portrait", "mid_left", 64, 64 );
	huds[ "noise" ]		= create_hud_static();

	return huds;
}

create_hud_rec()
{
	hud = NewHudElem();
	hud.x = 320;
	hud.y = 50;
	hud.sort = -5;
	hud.alignX = "center";
	hud.alignY = "middle";
	hud.fontscale = 2;
	hud.font = "objective";
	hud.color = ( 0.8, 0, 0 );
	hud SetText( &"INNOCENT_REC" );

	hud thread rec_thread();

	return hud;
}

create_cut_hud( shader_name, width, height )
{
	overlay = NewHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader( shader_name, width, height );
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = -3;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0.2;
	return overlay;
}

rec_thread()
{
	self endon( "death" );
	while( 1 )
	{
		wait( 0.8 );
		self.alpha = 0;
		wait( 1 );
		self.alpha = 1;	
	}
}

create_hud_shader( shader, side, width, height, scale )
{
	x = undefined;
	y = undefined;
	align_x = undefined;
	if ( side == "top_left" )
	{
		align_x = "left";
		x = 0;
		y = 50;
	}
	else if ( side == "bottom_left" )
	{
		align_x = "left";
		x = 0;
		y = 480 - 50;
	}
	else if ( side == "top_right" )
	{
		align_x = "right";
		x = 640;
		y = 50;
	}
	else if ( side == "bottom_right" )
	{
		align_x = "right";
		x = 640;
		y = 480 - 50;
	}
	else if ( side == "mid_left" )
	{
		align_x = "left";
		x = 0;
		y = 240;
	}

	hud = NewHudElem();
	hud.x = x;
	hud.y = y;
	hud.sort = -5;
	hud.alignX = align_x;
	hud.alignY = "middle";


	if ( !IsDefined( scale ) )
	{
		scale = 0.375;
	}

	hud SetShader( shader, int( width * scale ), int( height * scale ) );

	return hud;
}

create_hud_static()
{
	hud = NewHudElem();
	hud.x = 0;
	hud.y = 0;
	hud.sort = level.default_sort - 1;
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud SetShader( "overlay_grain", 640, 480 );
	hud.alpha = 0.2;

	return hud;
}

create_hud_time()
{
	hud = NewHudElem();
	hud.x = 640;
	hud.y = 50;
	hud.sort = level.default_sort;
	hud.alignX = "right";
	hud.alignY = "middle";
	hud.fontscale = 2;
	hud.font = "objective";
	hud.color = ( 1, 1, 1 );
	hud SetTimerUp( 0 );
}

shakey_cam()
{
	level endon( "stop_shakey_cam" );

	ent = spawn( "script_model", ( 0, 0, 0 ) );
	level.ground_ref_ent = ent;
	level.player PlayerSetGroundReferenceEnt( ent );

	base = ( 0, 0, 0 );
	while ( 1 )
	{
		angles = base + ( RandomFloatRange( -2, 2 ), RandomFloatRange( -2, 2 ), RandomFloatRange( -2, 2 ) );
		time = RandomFloatRange( 0.4, 0.8 );
		ent RotateTo( angles, time, time * 0.5, time * 0.5 );
		wait( time );
	}
}

camera_thread()
{
	thread shakey_cam();
	thread camera_ads();

	while ( 1 )
	{
		// TODO AUTO FOCUS
		wait( 0.05 );
	}
}

camera_ads()
{
	level endon( "stop_camera_ads" );

	is_ads = false;
	zoom_in = 35;
	zoom_out = 55;

	level.player LerpFov( zoom_out, 0.5 );
	while ( 1 )
	{
		if ( level.player AdsButtonPressed() )
		{
			if ( !is_ads )
			{
				is_ads = true;
				level.player LerpFov( zoom_in, 0.5 );
			}
		}
		else if ( is_ads )
		{
			is_ads = false;
			level.player LerpFov( zoom_out, 0.5 );
		}

		wait( 0.05 );
	}
}

dof_think( ent, type )
{
	level notify( "stop_dof_think" );
	level endon( "stop_dof_think" );

	if ( type == "ending" )
	{
		near_range = 128;
		far_range = 600;
		near_blur = 10;
		far_blur = 2;
	}
	else
	{
		near_range = 1000;
		far_range = 600;
		near_blur = 4;
		far_blur = 1.5;
	}

	level.dof_normal = [];
	foreach ( index, value in level.dofdefault )
	{
		level.dof_normal [ index ] = value;
	}

	while ( 1 )
	{
//		if ( 1 )
//		{
//			dof_testing();
//			wait( 0.05 );
//			continue;
//		}
		
		distance_to_target = Distance( level.player GetEye(), ent.origin );

		level.dofDefault[ "nearStart" ] = distance_to_target - near_range;
		level.dofDefault[ "nearStart" ] = Max( 0, level.dofDefault[ "nearStart" ] );
		level.dofDefault[ "nearEnd" ] = distance_to_target;
		level.dofDefault[ "farStart" ] = distance_to_target;
		level.dofDefault[ "farEnd" ] = distance_to_target + far_range;
		level.dofDefault[ "nearBlur" ] = near_blur;
		level.dofDefault[ "farBlur" ] = far_blur;
		wait( .05 );
	}
}

dof_testing( ent )
{
	if ( !IsDefined( level.dof_testing_dist ) )
	{
		level.dof_testing_dist = 20;
	}

	// TESTING!
	if ( level.player ButtonPressed( "=" ) )
	{
		level.dof_testing_dist += 10;
	}
	else if ( level.player ButtonPressed( "-" ) )
	{
		level.dof_testing_dist -= 10;
	}

	if ( level.player ButtonPressed( "]" ) )
	{
		level.dofDefault[ "nearBlur" ] += 0.01;
	}
	else if ( level.player ButtonPressed( "[" ) )
	{
		level.dofDefault[ "nearBlur" ] -= 0.01;
	}

	if ( level.player ButtonPressed( "0" ) )
	{
		level.dofDefault[ "farBlur" ] += 0.01;
	}
	else if ( level.player ButtonPressed( "9" ) )
	{
		level.dofDefault[ "farBlur" ] -= 0.01;
	}


	level.dofDefault[ "nearBlur" ] = Max( 4, level.dofDefault[ "nearBlur" ] );


	level.dof_testing_dist = Max( 0, level.dof_testing_dist );
	level.dofDefault[ "nearStart" ] = level.dof_testing_dist - 64;
	level.dofDefault[ "nearStart" ] = Max( 0, level.dofDefault[ "nearStart" ] );
	level.dofDefault[ "nearEnd" ] = level.dof_testing_dist;
	level.dofDefault[ "farStart" ] = level.dof_testing_dist;
	level.dofDefault[ "farEnd" ] = level.dof_testing_dist + 500;

	println( "Dist = " + level.dof_testing_dist );
	println( "nearBlur = " + level.dofDefault[ "nearBlur" ] );
	println( "farBlur = " + level.dofDefault[ "farBlur" ] );
}

create_splashscreen()
{
	hud = NewHudElem();
	hud.sort = level.default_sort + 5;
	hud.x = 320;
	hud.y = 240;
	hud.alignX = "center";
	hud.alignY = "middle";	
	hud.horzAlign = "fullscreen";
	hud.vertAlign = "fullscreen";
	hud.foreground = true;
	hud SetShader( "cam_splash", 480, 120 );
	hud.color = ( 1, 1, 1 );
	hud.sort = 100;

	return hud;
}

splashscreen_on()
{
	thread play_sound_in_space( "scn_videocamera_turn_on", level.player GetEye() );

	level.splashscreen = create_splashscreen();
	level.splashscreen FadeOverTime( 0.2 );
	level.splashscreen.alpha = 1;
}

splashscreen_off()
{
	level.black_overlay FadeOverTime( 0.4 );
	level.black_overlay.alpha = 0;

	wait( 1 );

	time = 0.4;
	level.splashscreen FadeOverTime( time );
	level.splashscreen.alpha = 0;

	wait( time + 0.05 );
	level.splashscreen Destroy(); 
}

//---------------------------------------------------------
// VEHICLE TRAFFIC Section
////---------------------------------------------------------
//
//vehicle_traffic()
//{
//	spawners = GetEntArray( "traffic_vehicle", "targetname" );
//
//	paths = GetVehicleNodeArray( "traffic_path_start", "script_noteworthy" );
//	foreach ( path in paths )
//	{
//		if ( IsDefined( path.script_chance ) )
//		{
//			path.weight = path.script_chance;
//		}
//		else
//		{
//			path.weight = 1;
//		}
//
//		path.count = 0;
//	}
//
//	intersections_init();
//
//	while ( 1 )
//	{
//		spawner = spawners[ RandomInt( spawners.size ) ];
//		spawner vehicle_traffic_spawn( paths );
//		
//		vehicles = Vehicle_GetArray();
//		while ( vehicles.size > 48 )
//		{
//			wait( 0.1 );
//			vehicles = Vehicle_GetArray();
//		}
//
//		wait( RandomFloatRange( 1, 3 ) );
//	}
//}
//
//vehicle_traffic_spawn( paths )
//{
//	while ( 1 )
//	{
//		path = get_weighted_vehicle_path( paths );
//		if ( self vehicle_spawn_on_path( path ) )
//		{
//			return;
//		}
//
//		wait( 0.05 );
//	}
//}
//
//get_weighted_vehicle_path( paths )
//{
//	total_weight = 0;
//	weights = 0;
//	foreach ( path in paths )
//	{
//		weights++;
//		total_weight += path.weight;
//	}
//
//
//	num = RandomFloat( total_weight );
//	weight	 = 0;
//
//	weighted_path = undefined;
//
//	foreach ( path in paths )
//	{
//		weight += path.weight;
//		if ( num < weight )
//		{
//			return path;
//		}
//	}
//}
//
//vehicle_spawn_on_path( path )
//{
//	if ( !IsDefined( path.next_spawn_time ) )
//	{
//		path.next_spawn_time = 0;
//	}
//
//	if ( IsDefined( path.script_count ) )
//	{
//		if ( path.count == path.script_count )
//		{
//			return false;
//		}
//	}
//
//	if ( GetTime() < path.next_spawn_time )
//	{
//		return false;
//	}
//
//	if ( IsDefined( path.last_vehicle ) )
//	{
//		if ( DistanceSquared( path.last_vehicle.origin, path.origin ) < 300 * 300 )
//		{
//			return false;
//		}
//	}
//
//	path.next_spawn_time = GetTime() + 3000;
//	path.count++;
//
//	self.target = path.targetname;
//	self.dontgetonpath = true;
//
//	vehicle = self spawn_vehicle();
//
//	vehicle.touch_ent = Spawn( "script_origin", vehicle.origin );
//	vehicle.touch_ent LinkTo( vehicle );
//
//	vehicle.attachedpath = path;
//	vehicle AttachPath( path );
//	vehicle StartPath();
//
//	vehicle.path_start = path;
//	vehicle thread vehicle_follow_path( path );
//
////	vehicle thread debug_ahead_vehicle();
//
//	return true;
//}
//
//vehicle_follow_path( path )
//{
//	self endon( "death" );
//	self notify( "follow_path" );
//	self endon( "follow_path" );
//
//	self.at_intersection = false;
//	node = path;
//
//	self thread vehicle_speed_thread( path );
//
//	while ( 1 )
//	{
//		self.current_node = node;
//		self vehicle_node_wait( node );
//
//		if ( IsDefined( node.script_noteworthy ) )
//		{
//			if ( node.script_noteworthy == "switch" )
//			{
//				self vehicle_switchnode( node, path );
//				waittillframeend;
//			}
//			else if ( node.script_noteworthy == "intersection_light" )
//			{
//				self vehicle_intersection_light( node );
//			}
//			else if ( node.script_noteworthy == "update_ahead_vehicle" )
//			{
//				self vehicle_update_ahead_vehicle();
//			}
//		}
//
//		if ( !self.at_intersection )
//		{
////			if ( IsDefined( node.speed ) )
////			{
////				self Vehicle_SetSpeed( node.speed / 17.6, 20 );
////			}
//		}
//
//		if ( !IsDefined( node.target ) )
//		{
//			break;
//		}
//
//		node = GetVehicleNode( node.target, "targetname" );
//	}
//
//	if ( IsDefined( self.touch_ent ) )
//	{
//		self.touch_ent Delete();
//	}
//
//	self.path_start.count--;
//	self Delete();
//}
//
//vehicle_update_ahead_vehicle()
//{
//	if ( self.path_start.last_vehicle == self )
//	{
//		if ( !IsDefined( self.ahead_vehicle ) )
//		{
//			self.path_start.last_vehicle = undefined;
//		}
//		else
//		{
//			self.path_start.last_vehicle = self.ahead_vehicle;
//		}
//
//		if ( IsDefined( self.next_ahead_vehicle ) )
//		{
//			self.ahead_vehicle = self.next_ahead_vehicle;
//			self.next_ahead_vehicle = undefined;
//		}
//
//		return;
//	}
//
//	
//	ahead_vehicle = undefined;
//
//	if ( IsDefined( self.ahead_vehicle ) )
//	{
//		ahead_vehicle = self.ahead_vehicle;
//	}
//
//	self.ahead_vehicle = undefined;
//
//	vehicles = Vehicle_GetArray();
//
//	foreach ( vehicle in vehicles )
//	{
//		if ( !IsDefined( vehicle.ahead_vehicle ) )
//		{
//			continue;
//		}
//
//		if ( vehicle.ahead_vehicle == self )
//		{
//			vehicle.ahead_vehicle = ahead_vehicle;
//		}
//	}
//
//	if ( IsDefined( self.next_ahead_vehicle ) )
//	{
//		self.ahead_vehicle = self.next_ahead_vehicle;
//		self.next_ahead_vehicle = undefined;
//	}
//}
//
//vehicle_speed_thread( path )
//{
//	self endon( "death" );
//	self endon( "reached_end_node" );
//
//	if ( !IsDefined( path.last_vehicle ) )
//	{
//		path.last_vehicle = self;
//		return;
//	}
//
//	// Assume switchnode has been done
//	if ( IsDefined( self.ahead_vehicle ) )
//	{
//		self.next_ahead_vehicle = path.last_vehicle;
//	}
//	else
//	{
//		self.ahead_vehicle = path.last_vehicle;
//	}
//
//	path.last_vehicle = self;
//
////	near_dist = 600;
////	far_dist = 700;
//
//
//	vehicle_size = 250;
//	far_dist = 300;
//
//	ahead_vehicle_size = 250;
//	ahead_vehicle_far_dist = 400;
//
//	if ( self.vehicletype == "bus" )
//	{
//		vehicle_size = 400;
//		far_dist = 400;
//	}
//
//	if ( self.ahead_vehicle.vehicletype == "bus" )
//	{
//		ahead_vehicle_size = 400;
//		ahead_vehicle_far_dist = 500;
//	}
//
//	near_dist = ahead_vehicle_size + vehicle_size;
//	far_dist += ahead_vehicle_far_dist;
//
//	near_dist *= near_dist;
//	far_dist *= far_dist;
//
//	was_near = false;
//	is_stopped = false;
//
//	while ( IsDefined( self.ahead_vehicle ) )
//	{
//		if ( self.at_intersection )
//		{
//			wait( 0.05 );
//			continue;
//		}
//
//		test_dist = DistanceSquared( self.origin, self.ahead_vehicle.origin );
//		if ( test_dist < near_dist )
//		{
//			was_near = true;
//
//			// match speed
//			if ( self.ahead_vehicle.veh_speed == 0 )
//			{
//				is_stopped = true;
//				self Vehicle_SetSpeed( 0, 10 + RandomFloat( 5 ) );
//			}
//			else if ( is_stopped )
//			{
//				is_stopped = false;
//				wait( RandomFloat( 2 ) );
//				self Vehicle_SetSpeed( self.ahead_vehicle.veh_speed, 10 + RandomFloat( 5 ) );
//			}
//			else
//			{
//				self Vehicle_SetSpeed( self.ahead_vehicle.veh_speed, 10 );
//			}
//		}
//		else if ( test_dist > far_dist )
//		{
//			if ( was_near )
//			{
//				was_near = false;
//				self ResumeSpeed( 10 );
//			}
//		}
//
//		wait( 0.05 );
//	}
//}
//
//vehicle_switchnode( node, path_start )
//{
//	struct = getstruct( node.target, "targetname" );
//
//	turn_node = undefined;
//	is_switchnode = false;
//
//	// Optional turn at intersection...
//	if ( IsDefined( struct ) )
//	{
//		if ( IsDefined( node.script_flag ) )
//		{
//			if ( !flag( node.script_flag ) )
//			{
//				return;
//			}
//		}
//		else if ( cointoss() )
//		{
//			return;
//		}
//
//		turn_node = GetVehicleNode( struct.target, "targetname" );
//		self SetSwitchNode( node, turn_node );
//		self.path_start.count--;
//
//		is_switchnode = true;
//	}
//
//	triggers = GetEntArray( node.target, "targetname" );
//	if ( !IsDefined( triggers ) || triggers.size == 0 )
//	{
//		if ( is_switchnode )
//		{
//			self.attachedpath = turn_node;
//			self thread vehicle_follow_path( turn_node );
//		}
//
//		return;
//	}
//
//	if ( !self is_vehicle_touching_triggers( triggers ) )
//	{
//		if ( is_switchnode )
//		{
//			self.attachedpath = turn_node;
//			self thread vehicle_follow_path( turn_node );
//		}
//
//		return;
//	}
//
//	speed = self.veh_speed;
//
//	self Vehicle_SetSpeed( 0, 10 );
//	self.at_intersection = true;
//
//	while ( 1 )
//	{
//		if ( !self is_vehicle_touching_triggers( triggers ) )
//		{
//			break;
//		}
//
//		wait( 0.05 );
//	}
//
//	self.at_intersection = false;
//	self ResumeSpeed( 10 );
//
//	if ( is_switchnode )
//	{
//		self.attachedpath = turn_node;
//		self thread vehicle_follow_path( turn_node );
//	}
//}
//
//vehicle_intersection_light( node )
//{
//	light = getstruct( node.script_linkto, "script_linkname" );
//	node_direction = node.script_parameters;
//
//	if ( light.direction != node_direction )
//	{
//		self Vehicle_SetSpeed( 0, 10 + RandomFloat( 5 ) );
//		self.at_intersection = true;
//
//		while ( light.direction != node_direction )
//		{
//			light waittill( "light_switched" );
//		}
//
//		self.at_intersection = false;
//		self ResumeSpeed( 10 );
//	}
//}
//
//is_vehicle_touching_triggers( triggers )
//{
//	touch_count = 0;
//	foreach ( trigger in triggers )
//	{
//		if ( IsDefined( trigger.script_parameters ) )
//		{
//			if ( trigger.script_parameters == "stop_check" )
//			{
//				if ( self is_vehicle_touching( trigger, true ) )
//				{
//					touch_count++;					
//				}
//			}
//		}
//		else if ( self is_vehicle_touching( trigger ) )
//		{
//			touch_count++;
//		}
//	}
//
//	return touch_count;
//}
//
//is_vehicle_touching( trigger, stop_check )
//{
//	vehicles = Vehicle_GetArray();
//
////	// TESTING!
////	vehicles[ vehicles.size ] = level.player;
////	if ( !IsDefined( level.player.touch_ent ) )
////	{
////		level.player.touch_ent = Spawn( "script_origin", level.player.origin );
////		level.player.touch_ent LinkTo( level.player );
////	}
//
//	foreach ( vehicle in vehicles )
//	{
//		if ( vehicle == self )
//		{
//			continue;
//		}
//
//		if ( !IsDefined( vehicle.touch_ent ) )
//		{
//			continue;
//		}
//
//		if ( trigger IsTouching( vehicle.touch_ent ) )
//		{
//			if ( IsDefined( stop_check ) )
//			{
//				// 10 is close to stopping since the average speed is 20
//				if ( vehicle.veh_speed < 10 )
//				{
//					return true;
//				}
//			}
//			else
//			{
//				return true;
//			}
//		}
//	}	
//
//	return false;
//}
//
//vehicle_node_wait( node )
//{
//	self endon( "follow_path" );
//	self endon( "reached_end_node" );
//
//	if ( self.attachedpath == node )
//	{
//		waittillframeend;
//		return;
//	}
//
//	node waittillmatch( "trigger", self );
//}
//
//intersections_init()
//{
//	structs = getstructarray( "intersection_light", "targetname" );
//	foreach ( struct in structs )
//	{
//		struct thread intersection_thread();
//	}
//}
//
//intersection_thread()
//{
//	self.direction = "none";
//	self thread debug_intersection_light();
//
//	while ( 1 )
//	{
//		self notify( "light_switched" );
//		self.direction = "north_south";
//		wait( 30 );
//
//		self.direction = "none";
//		wait( 5 );
//
//		self notify( "light_switched" );
//		self.direction = "east_west";
//		wait( 30 );
//
//		self.direction = "none";
//		wait( 5 );
//	}
//}
//
//debug_intersection_light()
//{
//	while ( 1 )
//	{
//		wait( 0.05 );
//		print3d( self.origin, self.direction );
//	}
//}
//
//debug_ahead_vehicle()
//{
//	self endon( "death" );
//
//	offset = ( 0, 0, 200 );
//	while ( 1 )
//	{
//		wait( 0.05 );
//
//		if ( !IsDefined( self.ahead_vehicle ) )
//		{
//			print3d( self.origin + offset, "undefined" );
//		}
//		else
//		{
//			print3d( self.origin + offset, self.ahead_vehicle GetEntityNumber() );
//			line( self.origin + offset, self.ahead_vehicle.origin + offset );
//		}
//	}
//}

vehicle_feeder_traffic()
{
	level endon( "truck_explodes" );

	spawners = GetEntArray( "feeder_traffic", "targetname" );

	while ( 1 )
	{
		spawners = array_randomize( spawners );
		foreach ( spawner in spawners )
		{
			wait( RandomFloatRange( 5, 10 ) );
	
			while ( vehicles_in_feeder_trigger() )
			{
				wait( 0.1 );
			}

			vehicle = spawner spawn_vehicle_and_gopath();
		}
	}
}

vehicles_in_feeder_trigger()
{
	trigger = GetEnt( "feeder_traffic_trigger", "targetname" );
	vehicles = Vehicle_GetArray();

	if ( IsDefined( level.end_truck ) )
	{
		vehicles = array_remove( vehicles, level.end_truck );
	}

	foreach ( vehicle in vehicles )
	{
		if ( IsDefined( vehicle.is_pigeon ) )
		{
			continue;
		}

		if ( vehicle.touch_ent IsTouching( trigger ) )
		{
			return true;
		}
	}

	return false;
}

vehicle_spawned( vehicle )
{
	vehicle.touch_ent = Spawn( "script_origin", vehicle.origin + ( 0, 0, 32 ) );
	vehicle waittill( "death" );
	vehicle.touch_ent Delete();
}

//--------------------------
// Start section
//--------------------------
set_start_locations( targetname, extra_guys, ignore_player )
{
	guys = GetEntArray( "sas_squad", "targetname" );
	structs = getstructarray( targetname, "targetname" );

    if ( !IsDefined( ignore_player ) )
        ignore_player = false;
        
    if( !ignore_player )
    	guys[ guys.size ] = level.player;

	if ( IsDefined( extra_guys ) )
	{
		guys = array_combine( guys, extra_guys );
	}

	// Move the AI/Player to "assigned" structs
	foreach ( guy in guys )
	{
		foreach ( struct in structs )
		{
			if ( IsDefined( struct.script_noteworthy ) )
			{
				if ( IsDefined( guy.script_noteworthy ) && struct.script_noteworthy == guy.script_noteworthy )
				{
					guy set_start_location_internal( struct );
					break;
				}
				else if ( IsPlayer( guy ) && struct.script_noteworthy == "player" )
				{
					guy set_start_location_internal( struct );
					break;
				}
			}
		}
	}

	// Move everyone else that hasn't been moved yet
	foreach ( guy in guys )
	{
		if ( IsDefined( guy._start_location_done ) )
		{
			continue;
		}

		foreach ( struct in structs )
		{
			if ( IsDefined( struct._start_location_done ) )
			{
				continue;
			}

			guy set_start_location_internal( struct );
			break;
		}
	}

	// Everyone is done moving to their starts, now remove the _start_lcoation_done
	foreach ( guy in guys )
	{
		guy._start_location_done = undefined;
	}

	foreach ( struct in structs )
	{
		struct._start_location_done = undefined;
	}
}

set_start_location_internal( struct )
{
	if ( IsPlayer( self ) )
	{
		self SetOrigin( struct.origin );
		self SetPlayerAngles( struct.angles );
	}
	else
	{
		self ForceTeleport( struct.origin, struct.angles );
		self SetGoalPos( struct.origin );

		// If the start point is targeting something
		// then have the AI target it as well.
		if ( IsDefined( struct.target ) )
		{
			self.target = struct.target;
		}
	}

	self._start_location_done = true;
	struct._start_location_done = true;
}

//---------------------------------------------------------
// Street Traffic 
//---------------------------------------------------------
street_traffic()
{
	start_points = getstructarray( "traffic_start_point", "targetname" );
	ent_models = GetEntArray( "traffic_model_innocent", "targetname" );

	foreach ( start in start_points )
	{
		start.vehicles = [];
		start.next_spawn_time = 0;
	}

	models = [];
	foreach ( ent in ent_models )
	{
		struct = SpawnStruct();
		struct.model = ent.model;
		struct.angles = ( 0, 0, 0 );

		if ( IsDefined( ent.script_angles ) )
		{
			struct.angles = ent.script_angles;
		}

		struct.radius = ent.radius;
		models[ models.size ] = struct;
		ent Delete();
	}

	counter = SpawnStruct();
	counter.max = 20;
	counter.count = 0;
	while ( 1 )
	{
		if ( counter.count == counter.max )
		{
			wait( 1 );
			continue;
		}

		start = start_points[ RandomInt( start_points.size ) ];
		if ( counter street_traffic_spawn( start, models ) )
		{
			wait( RandomFloatRange( 0.2, 0.5 ) );
		}
		else
		{
			wait( 0.05 );
		}
	}
}

street_traffic_spawn( start, models )
{
	if ( GetTime() < start.next_spawn_time )
	{
		return false;
	}

	end = getstruct( start.target, "targetname" );
	model = models[ Randomint( models.size ) ];

	if ( IsDefined( start.last_vehicle ) )
	{
		dist = ( model.radius * model.radius ) + ( start.last_vehicle.radius * start.last_vehicle.radius );
		if ( DistanceSquared( start.origin, start.last_vehicle.origin ) < dist )
		{
			return false;
		}
	}

	vehicle = Spawn( "script_model", start.origin );
	vehicle SetModel( model.model );
	vehicle.angles = VectorToAngles( end.origin - start.origin ) + ( 0, model.angles[ 1 ], 0 );
	vehicle.radius = model.radius;
	vehicle thread street_vehicle_movement( start, end, self );

	start.last_vehicle = vehicle;
	self.next_spawn_time = GetTime() + 2000;
	self.count++;

	return true;
}

street_vehicle_movement( start, end, counter )
{
	ahead_vehicle = undefined;
	bump_dist = undefined;
	if ( start.vehicles.size > 0 )
	{
		ahead_vehicle = start.vehicles[ start.vehicles.size - 1 ];
		bump_dist = ( self.radius * self.radius ) + ( ahead_vehicle.radius * ahead_vehicle.radius );
	}

	start.vehicles[ start.vehicles.size ] = self;
	speed = RandomIntRange( 348, 609 ); // 20-35mph
	dist = Distance( self.origin, end.origin );
	time = dist / speed;
	self.speed = speed;

	self MoveTo( end.origin, time );
	timer = GetTime() + ( time * 1000 );

	while ( GetTime() < timer )
	{
		if ( IsDefined( ahead_vehicle ) )
		{
			if ( DistanceSquared( self.origin, ahead_vehicle.origin ) < bump_dist )
			{
				bump_dist = Distance( self.origin, ahead_vehicle.origin );
				bump_dist *= bump_dist;

				speed = ahead_vehicle.speed;
				self.speed = speed;
				dist = Distance( self.origin, end.origin );
				time = dist / speed;
				self MoveTo( end.origin, time );
				timer = GetTime() + ( time * 1000 );
			}
		}

		wait( 0.05 );
	}

	start.vehicles = array_remove( start.vehicles, self );
	self Delete();
	counter.count--;
}

//---------------------------------------------------------
// Player Speed section
//---------------------------------------------------------
player_speed()
{
	level endon( "truck_explodes" );

	max_speed = 25;
	level.player player_speed_percent( max_speed );

	level.dist_from_wife = 100;
	while ( 1 )
	{
		if ( !IsDefined( level.wife ) )
		{
			wait( 0.05 );
			continue;
		}

		dist = get_player_dist_from_wife( level.dist_from_wife );

		percent = ( dist * 0.01 ); // dist * 0.01 is the same as dist / 100
		percent = clamp( percent, 0, 1 );

//		println( "percent = " + percent );
//		println( "dist = " + dist );

		level.player player_speed_percent( max_speed * percent );
		wait( 0.05 );
	}
}

get_player_dist_from_wife( offset_from_wife )
{
	start = getstruct( "dot_line", "targetname" );
	end = getstruct( start.target, "targetname" );
	vec = VectorNormalize( end.origin - start.origin );

	player_vec = ( level.player.origin - start.origin );
	player_dot = VectorDot( player_vec, vec );

	wife_vec = ( level.wife.origin - start.origin );
	wife_dot = VectorDot( wife_vec, vec );

	// Best dist for player, 100 units from wife
	dot = wife_dot - offset_from_wife;
	dist = dot - player_dot;

//		println( "player_dot = " + player_dot );
//		println( "wife_dot = " + wife_dot );

	return dist;
}

//---------------------------------------------------------
// Animation section
//---------------------------------------------------------
nag_for_player( guys, anim_prefix )
{
	self.nag_delay_count = 2;
	self.playing_anim = false;
	self.nag_sound_array = [ "london_wif_getcloser", "london_wif_honey" ];
	nag_count = 0;

	while ( 1 )
	{
		if ( get_player_dist_from_wife( 200 ) < 0 )
		{
			break;
		}

		if ( !self.playing_anim )
		{
			self.playing_anim = true;

			animation = anim_prefix + "_idle";
			self.nag_delay_count--;
			if ( self.nag_delay_count == 0 )	
			{
				self.nag_delay_count = RandomIntRange( 2, 4 );
				animation = anim_prefix + "_nag";

				if ( nag_count > self.nag_sound_array.size - 1 )
				{
					nag_count = 0;
					self.nag_sound_array = array_randomize( self.nag_sound_array );
				}
	
				dialogue = self.nag_sound_array[ nag_count ];
				level.wife thread dialogue_queue( dialogue );
				nag_count++;
			}

			self thread nag_for_player_anim( guys, animation );
			wait( 1 );
		}

		wait( 0.05 );
	}

	array_thread( guys, ::anim_stopanimscripted );
}

nag_for_player_anim( guys, animation )
{
	self anim_single( guys, animation );
	self.playing_anim = false;
}



//---------------------------------------------------------
// Pigeon Section
//---------------------------------------------------------

pigeons()
{
//	pigeons = GetEntArray( "pigeon", "targetname" );
//	pigeons = array_randomize( pigeons );
	level.pigeons = [];

	nodes = GetVehicleNodeArray( "pigeon_node", "targetname" );
	foreach ( node in nodes )
	{
		pigeon = Spawn( "script_model", node.origin );
		pigeon.angles = node.angles;
		pigeon SetModel( "pigeon_iw5" );
		pigeon.node = node;

		level.pigeons[ level.pigeons.size ] = pigeon;

		pigeon thread pigeon_thread();
	}

//	temp = Spawn( "script_model", level.player.origin );
//	temp SetModel( "tag_origin" );

//	foreach ( pigeon in pigeons )
//	{
//		pigeon thread pigeon_thread();
//		wait( RandomFloat( 0.2 ) );
//	}
}

pigeon_thread()
{
	wait( RandomFloat( 0.5 ) );

	struct = SpawnStruct();
	struct.origin = self.node.origin;
	struct.angles = self.node.angles;

	self.animname = "pigeon";
	self setanimtree();
	self.struct = struct;

	struct thread anim_loop_solo( self, "idle" );
}

pigeon_fly()
{
	self.struct notify( "stop_loop" );
	self anim_stopanimscripted();

	level.pigeons = array_remove( level.pigeons, self );

	v_spawner = GetEnt( "bird_vehicle", "targetname" );

	while ( IsDefined( v_spawner.vehicle_spawned_thisframe ) )
	{
		wait( 0.05 );
	}

	vehicle = vehicle_spawn( v_spawner );
//	vehicle SetModel( "tag_origin" );
	vehicle.is_pigeon = true;

//	van Vehicle_Teleport( node.origin, node.angles );
	vehicle.attachedpath = self.node;
	vehicle AttachPath( self.node );
	vehicle StartPath();

	self thread pigeon_fly_loop();
	self LinkTo( vehicle, "" );

	vehicle thread vehicle_paths( self.node );

	vehicle.script_vehicle_selfremove = true;
	vehicle waittill( "death" );

	self Delete();
}

pigeon_fly_loop()
{
	self endon( "death" );
	
	self SetModel( "pigeon_fly_iw5" );
	animation = self getanim( "flying" );

	rate = 1;
	dec = 0.1;
	delay = 0.5;
	for ( i = 0; i < 5; i++ )
	{
		self ClearAnim( animation, 0.5 );
		self SetAnimRestart( animation, 1, 0.5, rate );
		wait( delay );

		rate -= dec;
	}
}

delete_pigeons()
{
	foreach ( pigeon in level.pigeons )
	{
		pigeon Delete();
	}
}

//---------------------------------------------------------
// Couple Walking
//---------------------------------------------------------
couple_walking()
{
	level.drone_lookAhead_value = 50;

	man_spawner = GetEnt( "civilian_male_spawner", "script_noteworthy" );
	man = dronespawn( man_spawner );
	man.animname = "drone_man";
	man.runanim = man getanim( "couple_walk" );

	girl_spawner = GetEnt( "civilian_female_spawner", "script_noteworthy" );
	girl = dronespawn( girl_spawner );
	girl.animname = "drone_girl";
	girl.runanim = girl getanim( "couple_walk" );

	girl.origin = GetStartOrigin( man.origin, man.angles, girl.runanim );
	girl.angles = GetStartAngles( man.origin, man.angles, girl.runanim );

	girl LinkTo( man );

	node = getstruct( "couple_start_node", "targetname" );
	man.target = node.target;
	
	man.origin = node.origin;
	man.angles = node.angles;
	man thread maps\_drone::drone_move();

	wait( 0.05 );
	girl thread maps\_drone::drone_play_looping_anim( girl.runAnim, girl.moveplaybackrate );

	struct = getstruct( "couple_past_civilian", "script_noteworthy" );
	while ( man.origin[ 1 ] < struct.origin[ 1 ] )
	{
		wait( 0.1 );
	}

	flag_set( "couple_past_civilian" );
}

civilians()
{
	spawners = GetEntArray( "civilian", "targetname" );
	array_thread( spawners, ::spawn_civilian );
}

spawn_civilian()
{
	self script_delay();

	self.script_moveoverride = true;
	self.script_forcespawn = true;

	guy = self spawn_ai();
	guy.animname = "civilian";
	guy.goalradius = 16;

	guy set_run_anim( "walk" );
	guy thread civilian_think();
}

civilian_think()
{
	self endon( "death" );

	if ( !IsDefined( self.target ) )
	{
		return;
	}

	node = GetNode( self.target, "targetname" );

	if ( IsDefined( self.script_flag_wait ) )
	{
		flag_wait( self.script_flag_wait );
	}

	self script_wait();

	// follow path
	while ( 1 )
	{
		self SetGoalNode( node );
		self waittill( "goal" );

		if ( IsDefined( node.script_animation ) )
		{
			self set_run_anim( node.script_animation );
		}

		if ( !IsDefined( node.target ) )
		{
			break;
		}

		node = GetNode( node.target, "targetname" );
	}

	self Delete();
}

//---------------------------------------------------------
// Utility Section
//---------------------------------------------------------
delete_ents( value, key )
{
	ents = GetEntArray( value, key );
	array_call( ents, ::Delete );
}

view_cone_clamp( duration, left, right, up, down )
{
	level.player LerpViewAngleClamp( duration, duration * 0.5, duration * 0.5, left, right, up, down );
}

get_black_overlay()
{
	if ( !IsDefined( level.black_overlay ) )
	{
		level.black_overlay = create_client_overlay( "black", 0, level.player );
	}

	level.black_overlay.sort = level.default_sort - 5;
	level.black_overlay.foreground = false;
	return level.black_overlay;
}

get_world_relative_offset( origin, angles, offset )
{
	cos_yaw = cos( angles[ 1 ] );
	sin_yaw = sin( angles[ 1 ] );

	// Rotate offset by yaw
	x = ( offset[ 0 ] * cos_yaw ) - ( offset[ 1 ] * sin_yaw );
	y = ( offset[ 0 ] * sin_yaw ) + ( offset[ 1 ] * cos_yaw );

	// Translate to world position
	x += origin[ 0 ];
	y += origin[ 1 ];
	return ( x, y, origin[ 2 ] + offset[ 2 ] );
}


//---------------------------------------------------------
// Audio Section
//---------------------------------------------------------
wind_on_mic()
{
	alias = "ambient_innocent_camera_wind";
	level.player thread play_loop_sound_on_entity( alias );

	flag_wait( "splashscreen_off" );
	level.player notify( "stop sound" + alias );

	alias = "ambient_innocent_camera_wind_fast";
	level.player thread play_loop_sound_on_entity( alias );
}