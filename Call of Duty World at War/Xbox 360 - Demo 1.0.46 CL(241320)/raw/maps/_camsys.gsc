// MikeD (3/21/2007): Camera System for CoD5
#include common_scripts\utility;
#include maps\_utility;

camsys_init()
{
	level.cam_shots = [];
}

create_cp( origin )
{
	cp = SpawnStruct();

	cp.origin = origin;

	// Attributes
	cp.attrib = [];
	cp.attrib["time"] 		= 1;
	cp.attrib["fov"] 		= undefined;
	cp.attrib["blur"] 		= undefined;
	cp.attrib["shake"] 		= undefined;

	return cp;
}

build_shot( shot_name, track_type, target_type, track_array, target_array )
{
	if( IsDefined( level.cam_shots[shot_name] ) )
	{
		assertmsg( "shot_name of, '" + shot_name + "' already exists." );
		return;
	}

	shot = SpawnStruct();

	// Track
	track = SpawnStruct();
	track.type = track_type;
	track.cpoints = [];

	for( i = 0; i < track_array.size; i++ )
	{
		track.cpoints[track.cpoints.size] = track_array[i];
	}
	
	shot.cam_track = track;

	// Target
	target = SpawnStruct();
	target.type = target_type;
	target.cpoints = [];

	for( i = 0; i < target_array.size; i++ )
	{
		target.cpoints[target.cpoints.size] = target_array[i];
	}
	
	shot.cam_target = target;

	level.cam_shots[shot_name] = shot;
}

build_curve( cpoints )
{
	curve_id = GetCurve();

	for( i = 0; i < cpoints.size; i++ )
	{
		if( i == 0 )
		{
			AddNodeToCurve( curve_id, cpoints[i].origin, 0 );
		}
		else
		{
			AddNodeToCurve( curve_id, cpoints[i].origin, cpoints[i].attrib["time"] );
		}
	}
 
	BuildCurve( curve_id );

	return curve_id;
}

create_camera( origin )
{
	if( !IsDefined( origin ) )
	{
		origin = ( 0, 0, 0 );
	}

	return Spawn( "script_camera", origin );
}

create_scene( scene_name, shots )
{
	for( i = 0; i < shots.size; i++ )
	{
		create_scene_add_shot( scene_name, shots[i] );
	}
}

play_scene( scene )
{
	camera = create_camera();

	link_players_to_camera( camera );

	level thread skip_scene( scene );

	// Manually undefine the flag
	level.flag["skip_igc_" + scene] = undefined;
	level.flags_lock["skip_igc_" + scene] = undefined;

	flag_init( "skip_igc_" + scene );
	flag_clear( "skip_igc_" + scene );

	for( i = 0; i < level.cam_scenes[scene].shots.size; i++ )
	{
		if( flag( "skip_igc_" + scene ) )
		{
			break;
		}
		play_shot( level.cam_scenes[scene].shots[i], camera );
	}

	unlink_players_from_camera( camera );

	level notify( "igc_finished" );
}

skip_scene( scene )
{
	level endon( "igc_finished" );

	level thread catch_use_button();
	level waittill( "player_skip_igc" );

	flag_set( "skip_igc_" + scene );

	level notify( "player_skip_igc_confirmed" );
}

catch_use_button()
{
	level endon( "igc_finished" );

	wait( 0.2 );

	while( 1 )
	{
		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] UseButtonPressed() )
			{
				level notify( "player_skip_igc" );
				return;
			}
		}

		wait( 0.05 );
	}
}

create_scene_add_shot( name_of_scene, shot_name, shot_number )
{
	if( !IsDefined( level.cam_scenes ) )
	{
		level.cam_scenes = [];
	}

	if( !IsDefined( level.cam_scenes[name_of_scene] ) )
	{
		level.cam_scenes[name_of_scene] = SpawnStruct();
	}

	if( !IsDefined( level.cam_scenes[name_of_scene].shots ) )
	{
		level.cam_scenes[name_of_scene].shots = [];
	}

	if( !IsDefined( shot_number ) )
	{
		shot_number = level.cam_scenes[name_of_scene].shots.size;
	}

	level.cam_scenes[name_of_scene].shots[shot_number] = shot_name;
}

play_shot( shot_name, camera )
{
/#
	draw_shot( shot_name );
#/

	track 	= level.cam_shots[shot_name].cam_track;
	target 	= level.cam_shots[shot_name].cam_target;
	play_shot_internal( camera, track, target );
}

play_shot_internal( camera, track, target, end_on )
{
	level endon( "player_skip_igc_confirmed" );

	// Track Setup --------------------------------//
	track_id = -1;
	if( IsCurve( track.type ) )
	{
		track_id = build_curve( track.cpoints );
	}
	//---------------------------------------------//

	// Target Setup -------------------------------//
	target_id = -1;
	if( IsCurve( target.type ) )
	{
		target_id = build_curve( target.cpoints );
	}
	//---------------------------------------------//

	// Set the camera's position to the track -----//
	if( track_id > 0 ) // Track is a Curve
	{
		camera CameraLinkToCurve( track_id );
		SetCurveNotifyEnt( track_id, get_players()[0] );
	}
	else if( track.type == "Point" )
	{
		camera.origin = track.cpoints[0].origin;

		wait( 1 );
		camera.origin = ( 1000, 1000, 1000 );
	}
	//---------------------------------------------//

	// Set the camera's look-at point -------------//
	if( track_id > 0 )
	{
		StartCurve( track_id );
	}
	else if( target.type == "Point" )
	{
		camera SetLookAtOrigin( target.cpoints[0].origin );
	}
	//---------------------------------------------//

	if( target_id > 0 )
	{
		camera SetLookAtCurve( target_id );
		StartCurve( target_id );
	}

	if( track_id > 0 )
	{
		get_players()[0] waittill( "curve_end" );
	}
	else
	{
		wait( track.cpoints[0].attrib["time"] );
	}

	if( track_id > 0 )
	{
		FreeCurve( track_id );
	}

	if( target_id > 0 )
	{
		FreeCurve( target_id );
	}
}

link_players_to_camera( camera )
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] PlayerLinkToCamera( camera );
	}
}

unlink_players_from_camera( camera )
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] Unlink();
	}

	camera Delete();
}

IsCurve( type )
{
	if( type == "Timed Curve" || type == "Rounded Curve" || type == "Smoothed Curve" )
	{
		return true;
	}

	return false;
}


////////////////////////////////////
// OLD!

create_cam_node( scene_name, pos, angles, time, accel, deccel )
{
	if( !IsDefined( level.cam_scenes ) )
	{
		level.cam_scenes = [];
	}

	if( !IsDefined( level.cam_scenes_names ) )
	{
		level.cam_scenes_names = [];
	}

/#
	// For debugging purposes only. Checks to see if you are trying to setup
	// 2 different scenes with the same name.
//	debug_dupe_scene( scene_name );
#/

	if( !IsDefined( level.cam_scenes[scene_name] ) )
	{
		level.cam_scenes[scene_name] = [];
	}
	
	// If this is the first time adding this scene, then add it to the overall
	// scene_names array.
	if( level.cam_scenes[scene_name].size == 0 )
	{
		level.cam_scenes_names[level.cam_scenes_names.size] = scene_name;
	}

	size = level.cam_scenes[scene_name].size;

/#
	if( GetDvar( "createcam" ) == "1" )
	{
		level.cam_scenes[scene_name][size]["time_stamp"] = GetTime();
	}
#/
	level.cam_scenes[scene_name][size]["pos"] = pos;
	level.cam_scenes[scene_name][size]["angles"] = angles;
	level.cam_scenes[scene_name][size]["time"] = time;
	level.cam_scenes[scene_name][size]["accel"] = accel;
	level.cam_scenes[scene_name][size]["deccel"] = deccel;

/#
	if( IsDefined( level.cam_model_func ) )
	{
		if( !IsDefined( level.cam_models ) )
		{
			level.cam_models = [];
		}

		if( !IsDefined( level.cam_models[scene_name] ) )
		{
			level.cam_models[scene_name] = [];
		}

		size = level.cam_models[scene_name].size;
		level.cam_models[scene_name][size] = [[level.cam_model_func]]( scene_name, pos, angles );
	}
#/
}
//
//// ??????
//insert_effect_node()
//{
//}
//
//remove_scene( scene_name )
//{
//	if( !IsDefined( level.cam_scenes ) )
//	{
//		level.cam_scenes = [];
//		return;
//	}
//
//	if( !IsDefined( level.cam_scenes[scene_name] ) )
//	{
//		level.cam_scenes[scene_name] = [];
//		return;
//	}
//
///#
//	if( IsDefined( level.cam_models[scene_name]["cam_model"] ) )
//	{
//		for( i = 0; i < level.cam_models[scene_name]["cam_model"].size; i++ )
//		{
//			if( IsDefined( level.cam_models[scene_name]["cam_model"][i] ) )
//			{
//				level.cam_models[scene_name]["cam_model"][i] Delete();
//			}
//		}
//	}
//#/
//	
//	level.cam_scenes_names = array_remove( level.cam_scenes_names, scene_name );
//	level.cam_scenes[scene_name] = undefined;
//
//	for( i = 0; i < level.cam_models[scene_name].size; i++ )
//	{
//		level.cam_models[scene_name][i] Delete();
//	}
//
//	level.cam_models[scene_name] = undefined;
//}
//
//copy_scene( scene_name, new_scene_name )
//{
//	if( !IsDefined( level.cam_scenes ) )
//	{
//		level.cam_scenes = [];
//		return;
//	}
//
//	if( !IsDefined( level.cam_scenes[scene_name] ) )
//	{
//		level.cam_scenes[scene_name] = [];
//		return;
//	}
//
///#
//	if( IsDefined( level.cam_models[scene_name] ) )
//	{
//		for( i = 0; i < level.cam_models[scene_name].size; i++ )
//		{
//			origin = level.cam_models[scene_name][i].origin;
//			angles = level.cam_models[scene_name][i].angles;
//
//			if( IsDefined( level.cam_model_func ) )
//			{
//				if( !IsDefined( level.cam_models ) )
//				{
//					level.cam_models = [];
//				}
//		
//				if( !IsDefined( level.cam_models[new_scene_name] ) )
//				{
//					level.cam_models[new_scene_name] = [];
//				}
//		
//				size = level.cam_models[new_scene_name].size;
//				level.cam_models[new_scene_name][size] = [[level.cam_model_func]]( new_scene_name, origin, angles );
//			}
//		}
//	}
//#/
//
//	size = level.cam_scenes[scene_name].size;
//
//	if( !IsDefined( level.cam_scenes[new_scene_name] ) )
//	{
//		level.cam_scenes[new_scene_name] = [];
//	}
//
//	for( i = 0; i < size; i++ )
//	{
//		index_names = GetArrayKeys( level.cam_scenes[scene_name][i] );
//
//		for( q = 0; q < index_names.size; q++ )
//		{
//			level.cam_scenes[new_scene_name][i][index_names[q]] = level.cam_scenes[scene_name][i][index_names[q]];
//		}
//	}
//
//	level.cam_scenes_names[level.cam_scenes_names.size] = new_scene_name;
//}
//

// OLD!
playback_scene( option1, option2, option3 )
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( true );
		players[i] EnableInvulnerability();
	}

	black_bg = NewHudElem(); 
	black_bg.x = 0; 
	black_bg.y = 0; 
	black_bg.alpha = 0; 
	black_bg.horzAlign = "fullscreen"; 
	black_bg.vertAlign = "fullscreen"; 
	black_bg SetShader( "black", 640, 480 ); 

	temp_text = NewHudElem(); 
	temp_text.x = 320; 
	temp_text.y = 240; 
	temp_text.alignY = "middle"; 
	temp_text.alignX = "center"; 
	temp_text.alpha = 0; 
	temp_text.fontscale = 2;
	temp_text SetText( "[IGC WILL BE HERE]" );
	
	// Fade in
	black_bg FadeOverTime( 1.0 ); 
	black_bg.alpha = 0.8;
	temp_text FadeOverTime( 1.0 );
	temp_text.alpha = 1;
	
	wait( 1.0 );
	level notify ("blacked out");

	if( IsDefineD( option1 ) && !IsString( option1 ) ) // Assume float/int
	{
		wait( option1 );
	}
	else
	{
		wait( 3 );

		if( IsDefined( option2 ) )
		{
			level waittill( option2 );
		}
	}

	// Fade out
	black_bg FadeOverTime( 1.0 ); 
	black_bg.alpha = 0; 
	temp_text FadeOverTime( 1.0 );
	temp_text.alpha = 0;

	wait( 1.0 );
	black_bg destroy();
	temp_text destroy();
	
 	level notify ("fade complete");

	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( false );
		players[i] DisableInvulnerability();
	}

	// TEMP!!
	level notify( "plackback_finished" );
}

//-------//
// DEBUG //
//-------//
draw_shot( shot_name )
{
/#
	stop_drawing_all();
	draw_shot_track( shot_name );
	draw_shot_target( shot_name );
#/
}

draw_shot_track( shot_name )
{
/#
	if( !IsDefined( level.drawn_tracks ) )
	{
		level.drawn_tracks = [];
	}

	if( IsDefined( level.cam_shots[shot_name].cam_track ) )
	{
		level.drawn_tracks[shot_name] = build_curve( level.cam_shots[shot_name].cam_track.cpoints );
		DrawCurve( level.drawn_tracks[shot_name], ( 0, 0, 1 )  );
	}
#/
}

draw_shot_target( shot_name )
{
/#
	if( !IsDefined( level.drawn_targets ) )
	{
		level.drawn_targets = [];
	}

	if( IsDefined( level.cam_shots[shot_name].cam_target ) )
	{
		level.drawn_targets[shot_name] = build_curve( level.cam_shots[shot_name].cam_target.cpoints );
		DrawCurve( level.drawn_targets[shot_name], ( 1, 1, 0 ) );
	}
#/
}

stop_drawing_all()
{
/#
	stop_drawing_tracks();
	stop_drawing_targets();
#/
}

stop_drawing_tracks()
{
/#
	if( IsDefined( level.drawn_tracks ) )
	{
		keys = GetArrayKeys( level.drawn_tracks );
		for( i = 0; i < keys.size; i++ )
		{
			if( IsString( level.drawn_tracks[keys[i]] ) )
			{
				level notify( level.drawn_tracks[keys[i]] );
			}	
			else // Assume curve id
			{
				FreeCurve( level.drawn_tracks[keys[i]] );
			}
		}
	}

	level.drawn_tracks = [];
#/
}

stop_drawing_targets()
{
/#
	if( IsDefined( level.drawn_targets ) )
	{
		keys = GetArrayKeys( level.drawn_targets );
		for( i = 0; i < keys.size; i++ )
		{
			if( IsString( level.drawn_targets[keys[i]] ) )
			{
				level notify( level.drawn_targets[keys[i]] );
			}	
			else // Assume curve id
			{
				FreeCurve( level.drawn_targets[keys[i]] );
			}
		}
	}

	level.drawn_targets = [];
#/
}


//debug_dupe_scene( scene_name )
//{
///#
//	// For debugging purposes only. Checks to see if you are trying to setup
//	// 2 different scenes with the same name.
//	if( !IsDefined( level.cam_debug_old_scene_name ) )
//	{
//		level.cam_debug_old_scene_name = scene_name;
//	}
//
//	if( !Isdefined( level.cam_scenes_names ) )
//	{
//		return;
//	}
//
//	if( level.cam_debug_old_scene_name != scene_name )
//	{
//		for( i = 0; i < level.cam_scenes_names.size; i++ )
//		{
//			if( level.cam_scenes_names[i] == scene_name )
//			{
//				assertmsg( "Trying to setup a new camera scene with a duplicate scene name of \"" + scene_name + "\"" );
//				return;
//			}
//		}
//
//		// Made it past the assert.
//		level.cam_debug_old_scene_name = scene_name;
//	}
//	else
//	{
//		level.cam_debug_old_scene_name = scene_name;
//	}
//#/
//}

// Quick fade to black to hide cutscene transition
fade_to_black()
{	
	fadetoblack = NewHudElem(); 
	fadetoblack.x = 0; 
	fadetoblack.y = 0; 
	fadetoblack.alpha = 0; 
		
	fadetoblack.horzAlign = "fullscreen"; 
	fadetoblack.vertAlign = "fullscreen"; 
	fadetoblack.foreground = true; 
	fadetoblack SetShader( "black", 640, 480 ); 

	
	// Fade into black
	fadetoblack FadeOverTime( 1.0 ); 
	fadetoblack.alpha = 1; 
	
	wait (1.0);
	level notify ("blacked out");
	 	
	// Fade out to black
	fadetoblack FadeOverTime( 1.0 ); 
	fadetoblack.alpha = 0; 
	
	wait (1.0);
	fadetoblack destroy();
	
 	level notify ("fade complete");
}