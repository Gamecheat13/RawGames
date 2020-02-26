// MikeD (3/21/2007): Camera System for CoD5
#include maps\_utility;
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
	debug_dupe_scene( scene_name );
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

// ??????
insert_effect_node()
{
}

remove_scene( scene_name )
{
	if( !IsDefined( level.cam_scenes ) )
	{
		level.cam_scenes = [];
		return;
	}

	if( !IsDefined( level.cam_scenes[scene_name] ) )
	{
		level.cam_scenes[scene_name] = [];
		return;
	}

/#
	if( IsDefined( level.cam_models[scene_name]["cam_model"] ) )
	{
		for( i = 0; i < level.cam_models[scene_name]["cam_model"].size; i++ )
		{
			if( IsDefined( level.cam_models[scene_name]["cam_model"][i] ) )
			{
				level.cam_models[scene_name]["cam_model"][i] Delete();
			}
		}
	}
#/
	
	level.cam_scenes_names = array_remove( level.cam_scenes_names, scene_name );
	level.cam_scenes[scene_name] = undefined;

	for( i = 0; i < level.cam_models[scene_name].size; i++ )
	{
		level.cam_models[scene_name][i] Delete();
	}

	level.cam_models[scene_name] = undefined;
}

copy_scene( scene_name, new_scene_name )
{
	if( !IsDefined( level.cam_scenes ) )
	{
		level.cam_scenes = [];
		return;
	}

	if( !IsDefined( level.cam_scenes[scene_name] ) )
	{
		level.cam_scenes[scene_name] = [];
		return;
	}

/#
	if( IsDefined( level.cam_models[scene_name] ) )
	{
		for( i = 0; i < level.cam_models[scene_name].size; i++ )
		{
			origin = level.cam_models[scene_name][i].origin;
			angles = level.cam_models[scene_name][i].angles;

			if( IsDefined( level.cam_model_func ) )
			{
				if( !IsDefined( level.cam_models ) )
				{
					level.cam_models = [];
				}
		
				if( !IsDefined( level.cam_models[new_scene_name] ) )
				{
					level.cam_models[new_scene_name] = [];
				}
		
				size = level.cam_models[new_scene_name].size;
				level.cam_models[new_scene_name][size] = [[level.cam_model_func]]( new_scene_name, origin, angles );
			}
		}
	}
#/

	size = level.cam_scenes[scene_name].size;

	if( !IsDefined( level.cam_scenes[new_scene_name] ) )
	{
		level.cam_scenes[new_scene_name] = [];
	}

	for( i = 0; i < size; i++ )
	{
		index_names = GetArrayKeys( level.cam_scenes[scene_name][i] );

		for( q = 0; q < index_names.size; q++ )
		{
			level.cam_scenes[new_scene_name][i][index_names[q]] = level.cam_scenes[scene_name][i][index_names[q]];
		}
	}

	level.cam_scenes_names[level.cam_scenes_names.size] = new_scene_name;
}

playback_scene( scene_name )
{
	if( !IsDefined( level.cam_scenes[scene_name] ) )
	{
		return "ERROR: Camera scene \"" + scene_name + "\" was not found!";
	}

	// TEMP
	players = get_players();
	org = Spawn( "script_origin", players[0] GetEye() );
	diff = players[0] GetEye() - players[0].origin;
	org2 = Spawn( "script_origin", org.origin - diff );
	org2 LinkTo( org );

	org.angles = players[0] GetPlayerAngles();

	players[0] PlayerLinkToAbsolute( org2, "" );
	//

	org.origin = level.cam_scenes[scene_name][0]["pos"];
	org.angles = level.cam_scenes[scene_name][0]["angles"];

	size = level.cam_scenes[scene_name].size;
	for( i = 1; i < size; i++ )
	{
		time = level.cam_scenes[scene_name][i]["time"] * 0.001;
		accel = level.cam_scenes[scene_name][i]["accel"];
		deccel = level.cam_scenes[scene_name][i]["deccel"];

		if( time == 0 )
		{
			org.origin = level.cam_scenes[scene_name][i]["pos"];
			org.angles = level.cam_scenes[scene_name][i]["angles"];
		}
		else
		{
			org MoveTo( level.cam_scenes[scene_name][i]["pos"], time, accel, deccel );
			org RotateTo( level.cam_scenes[scene_name][i]["angles"], time, accel, deccel );
	
	//		if( ( time - 0.2 ) > 0.2 )
	//		{	
	//			wait( time - 0.2 );
	//		}
	//		else
	//		{
				wait( time );
	//		}
		}
	}

	wait( 0.5 );

	players[0] UnLink();
	org2 Delete();
	org Delete();

	level notify( "plackback_finished" );
}

//-------//
// DEBUG //
//-------//
debug_dupe_scene( scene_name )
{
/#
	// For debugging purposes only. Checks to see if you are trying to setup
	// 2 different scenes with the same name.
	if( !IsDefined( level.cam_debug_old_scene_name ) )
	{
		level.cam_debug_old_scene_name = scene_name;
	}

	if( !Isdefined( level.cam_scenes_names ) )
	{
		return;
	}

	if( level.cam_debug_old_scene_name != scene_name )
	{
		for( i = 0; i < level.cam_scenes_names.size; i++ )
		{
			if( level.cam_scenes_names[i] == scene_name )
			{
				assertmsg( "Trying to setup a new camera scene with a duplicate scene name of \"" + scene_name + "\"" );
				return;
			}
		}

		// Made it past the assert.
		level.cam_debug_old_scene_name = scene_name;
	}
	else
	{
		level.cam_debug_old_scene_name = scene_name;
	}
#/
}