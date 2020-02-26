#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

autoexec _scene_init()
{
	PrecacheRumble( "anim_light" );
	PrecacheRumble( "anim_med" );
	PrecacheRumble( "anim_heavy" );

	PreCacheString( &"hud_shrink_ammo" );
	PreCacheString( &"hud_expand_ammo" );
	
	// init scene triggers // 
	triggers = get_triggers();
	foreach ( trig in triggers )
	{
		if ( IsDefined( trig.script_run_scene ) )
		{
			a_scenes = StrTok( trig.script_run_scene, " ,;" );
			
			foreach ( str_scene in a_scenes )
			{
				add_trigger_function( trig, ::run_scene, str_scene );
			}
		}
	}
}

/@
"Name: precache_assets( <b_skip_precache_models> )"
"Summary: Sets up all the assets in its appropriate level.scr_* and precaches all models. This must be called after all scenes are added."
"Module: Animation"
"CallOn: level"
"OptionalArg: [b_skip_precache_models] If set to true, it will not call PrecacheModel."
"Example: precache_assets();"
"SPMP: singleplayer"
@/
precache_assets( b_skip_precache_models = false )
{
	Assert( IsDefined( level.a_scenes ), "There are no scenes to precache. Make sure to call add_scene() before calling this function." );

	a_scene_names = GetArrayKeys( level.a_scenes );
	
	// Loops through each scene to set up its asset info and to preache models
	for ( i = 0; i < a_scene_names.size; i++ )
	{
		str_scene = a_scene_names[ i ];
		s_scene_info = level.a_scenes[ str_scene ];
		
		if ( is_scene_deleted( str_scene ) )
		{
			continue;
		}
		
		// All assets must all use the same animation in a scene that is generic
		if ( IS_TRUE( s_scene_info.do_generic ) )
		{
			has_different = _has_different_generic_anims( str_scene );
			
			Assert( !has_different, "Since scene, " + str_scene + ", is a generic, all asset must use the same aniamtion.");
		}
		
		a_anim_keys = GetArrayKeys( s_scene_info.a_anim_info );
		
		// Loops through each asset info and sets each of them up in its appropriate level.scr_*
		for ( j = 0; j < a_anim_keys.size; j++ )
		{
			str_animname = a_anim_keys[ j ];
			s_asset_info = s_scene_info.a_anim_info[ str_animname ];
			
			// Precaches a model if the model name is defined and sets up the asset's level.scr_model
			if ( IsDefined( s_asset_info.str_model ) )
			{
				level.scr_model[ str_animname ] = s_asset_info.str_model;
				
				if ( !b_skip_precache_models )
				{
					//Assert( IsAssetLoaded( "xmodel", s_asset_info.str_model ), "Add this asset, " + s_asset_info.str_model + ", into your csv to load it into memory" );
					PreCacheModel( s_asset_info.str_model );
				}
			}
			
			level.scr_animtree[ str_animname ] = s_asset_info.anim_tree;
			
			// 'generic' animations have a different way of looking up than normal animations in level.scr_anim
			if ( IS_TRUE( s_scene_info.do_generic ) )
			{
				str_animname = "generic";
			}
			
			animation = s_asset_info.animation;
			
			if ( IS_TRUE( s_scene_info.do_loop ) )
			{
				level.scr_anim[ str_animname ][ str_scene ][ 0 ] = animation;
			}
			else
			{
				level.scr_anim[ str_animname ][ str_scene ] = animation;
			}
		}
	}
}

/@
"Name: run_scene( <str_scene>, <n_lerp_time> )"
"Summary: Plays the scene that it is given. This function sets a flag, str_scene + "_started", once all the assets has start animating"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [n_lerp_time] Specify a specific lerp time."
"Example: run_scene( "rr_1" );"
"SPMP: singleplayer"
@/
run_scene( str_scene, n_lerp_time, b_test_run = false )
{
	level.scene_sys endon( "_delete_scene_" + str_scene );
	level.scene_sys endon( "_stop_scene_" + str_scene );
	
	Assert( IsDefined( str_scene ), "str_scene is a required argument for run_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	// Resets the following if this scene has previously been used
	if ( flag( str_scene + "_started" ) )
	{
		level.a_scenes[ str_scene ].a_ai_anims = [];
		level.a_scenes[ str_scene ].a_model_anims = [];
	
		if ( !b_test_run )
		{
			flag_clear( str_scene + "_started" );
			flag_clear( str_scene + "_done" );
		}
	}

	s_scene_info = level.a_scenes[ str_scene ];
	
	align_object = s_scene_info _get_align_object( str_scene );
	if ( IS_TRUE( align_object.is_node ) )
	{
		SetEnableNode( align_object, false );
	}
	
	// This is where the all the assets that is going to be animated gets assembled into an array
	a_active_anims = align_object _assemble_assets( str_scene, b_test_run );
	align_object thread _anim_death_notify( str_scene, a_active_anims );
	
	foreach ( e_asset in a_active_anims )
	{
		e_asset thread _animate_asset( str_scene, align_object, n_lerp_time, b_test_run );
	}

//	if ( !b_test_run )
//	{
//		flag_set( str_scene + "_started" );
//	}
	
	align_object waittill( str_scene );
	
	_end_scene( str_scene, b_test_run );
}

_end_scene( str_scene, b_test_run = false )
{
	if ( !b_test_run )
	{
		flag_set( str_scene + "_done" );
	}
	
	delete_scene( str_scene );
}

/@
"Name: run_scene_and_delete( <str_scene>, [n_lerp_time] )"
"Summary: Plays the scene that it is given. This function sets a flag, str_scene + "_started", once all the assets has start animating.  Deletes the scene after it has finished playing."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [n_lerp_time] Specify a specific lerp time."
"Example: run_scene( "rr_1" );"
"SPMP: singleplayer"
@/
run_scene_and_delete( str_scene, n_lerp_time )
{
	run_scene( str_scene, n_lerp_time );
	delete_scene( str_scene, true );
}

/@
"Name: run_scene_first_frame( <str_scene> )"
"Summary: Puts a scene in its first animation frame"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"Example: run_scene_first_frame( "rr_1" );"
"SPMP: singleplayer"
@/
run_scene_first_frame( str_scene, b_skip_ai = false, b_clear_anim )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for run_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );

	s_scene_info = level.a_scenes[ str_scene ];
	
	align_object = s_scene_info _get_align_object( str_scene );
	if ( IS_TRUE( align_object.is_node ) )
	{
		SetEnableNode( align_object, false );
	}
	
	a_active_anims = align_object _assemble_assets( str_scene, false, b_skip_ai, true );
	
	foreach ( e_asset in a_active_anims )
	{
		e_asset _run_anim_first_frame_on_asset( str_scene, align_object, b_clear_anim );
	}
}

/@
"Name: end_scene( <str_scene> )"
"Summary: Ends the scene that it is given."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"Example: end_scene( "rr_1" );"
"SPMP: singleplayer"
@/
end_scene( str_scene )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for end_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Invalid scene name '" + str_scene + "' passed to end_scene()" );
	
	if ( !is_scene_deleted( str_scene ) )
	{
		s_scene_info = level.a_scenes[ str_scene ];
		
		if ( IsDefined( s_scene_info.a_ai_anims ) )
		{
			REMOVE_UNDEFINED( s_scene_info.a_ai_anims );
			
			foreach ( ai_anim in s_scene_info.a_ai_anims )
			{
				ai_anim anim_stopanimscripted( .2 );
			}
		}
	
		if ( IsDefined( s_scene_info.a_model_anims ) )
		{
			REMOVE_UNDEFINED( s_scene_info.a_model_anims );
			
			foreach ( m_anim in s_scene_info.a_model_anims )
			{
				m_anim anim_stopanimscripted( .2 );
			}
		}
		
		level.scene_sys notify( "_stop_scene_" + str_scene );
		_end_scene( str_scene );
	}
}

/@
"Name: add_scene_properties( <str_scene>, [str_align_targetname] ) "
"Summary: Adds properties to a specific scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [str_align_targetname] The targetname of struct, node or entity, that the scene is aligned to. This is required if do_reach is true or do_not_align is false."
"Example: add_scene_properties( "drop_down", self.script_string );"
"SPMP: singleplayer"
@/
add_scene_properties( str_scene, str_align_targetname )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for add_scene_properties()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	level.a_scenes[ str_scene ].align_object = undefined;
	level.a_scenes[ str_scene ].str_align_targetname = str_align_targetname;
	level.a_scenes[ str_scene ].do_not_align = undefined;
}

/@
"Name: add_asset_properties( <str_animname>, <str_scene>, [v_origin], [v_angles] ) "
"Summary: Adds properties to a specific asset in a specific scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname for the asset"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [v_origin] The origin that you want this asset to have. Right now, this is mainly for models that needs to be spawned in a specific spot."
"OptionalArg: [v_angles] The angle that you want this asset to have. Right now, this is mainly for models that needs to be spawned in."
"Example: add_asset_properties( "m16_weapon", "prop_animations", s_weapon_start.origin, s_weapon_start.angles );"
"SPMP: singleplayer"
@/
add_asset_properties( str_animname, str_scene, v_origin, v_angles )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_asset_properties()" );
	Assert( IsDefined( str_scene ), "str_scene is a required argument for add_asset_properties()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ].a_anim_info[ str_animname ] ), "Asset with this animname, " + str_animname + ", does not exist in scene, " + str_scene );
	
	level.a_scenes[ str_scene ].a_anim_info[ str_animname ].v_origin = v_origin;
	level.a_scenes[ str_scene ].a_anim_info[ str_animname ].v_angles = v_angles;
}

/@
"Name: add_generic_ai_to_scene( <ai_generic>, <str_scene> )"
"Summary: Adds an AI that will be playing a generic animation to the actor anims array"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <ai_generic> The AI that needs to be added to the actor anims array for the specify scene"
"MandatoryArg: <str_scene> The name of the scene"
"Example: add_generic_ai_to_scene( ai_random, "generic_scene" );"
"SPMP: singleplayer"
@/
add_generic_ai_to_scene( ai_generic, str_scene )
{	
	Assert( IsDefined( ai_generic ), "ai_generic is a required argument for add_generic_ai_to_scene()" );
	Assert( IsDefined( str_scene ), "str_scene is a required argument for add_generic_ai_to_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ].a_anim_info[ "generic" ] ), "Make sure the actor info is setup properly for scene, " + str_scene + ", with add_actor_anim() or add_multiple_generic_actors()" );
	
	if ( !IsDefined( level.a_scenes[ str_scene ].a_ai_anims ) )
	{
		level.a_scenes[ str_scene ].a_ai_anims = [];
	}
	
	// Resets the following if this scene has previously been used
	if ( flag( str_scene + "_started" ) )
	{
		level.a_scenes[ str_scene ].a_ai_anims = [];
		flag_clear( str_scene + "_started" );
	}
	
	s_asset_info = level.a_scenes[ str_scene ].a_anim_info[ "generic" ];

	ai_generic thread _setup_asset_for_scene( s_asset_info );
	
	ARRAY_ADD( level.a_scenes[ str_scene ].a_ai_anims, ai_generic );
}

/@
"Name: add_generic_prop_to_scene( <m_generic>, <str_scene> )"
"Summary: Adds a prop that will be playing a generic animation to the prop anims array"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <m_generic> The prop that needs to be added to the prop anims array for the specify scene"
"MandatoryArg: <str_scene> The name of the scene"
"Example: add_generic_prop_to_scene( m_random, "generic_scene" );"
"SPMP: singleplayer"
@/
add_generic_prop_to_scene( m_generic, str_scene, anim_tree )
{	
	Assert( IsDefined( m_generic ), "m_generic is a required argument for add_generic_prop_to_scene()" );
	Assert( IsDefined( str_scene ), "str_scene is a required argument for add_generic_prop_to_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ].a_anim_info[ "generic" ] ), "Make sure the prop info is setup properly for scene, " + str_scene + ", with add_prop_anim() or add_multiple_generic_props_from_radiant()" );
	
	if ( !IsDefined( level.a_scenes[ str_scene ].a_model_anims ) )
	{
		level.a_scenes[ str_scene ].a_model_anims = [];
	}
	
	// Resets the following if this scene has previously been used
	if ( flag( str_scene + "_started" ) )
	{
		level.a_scenes[ str_scene ].a_model_anims = [];
		flag_clear( str_scene + "_started" );
	}
	
	s_asset_info = level.a_scenes[ str_scene ].a_anim_info[ "generic" ];
	
	m_generic.str_name = s_asset_info.str_name;
	m_generic.do_delete = s_asset_info.do_delete;
	m_generic.str_tag = s_asset_info.str_tag;
	m_generic init_anim_model( s_asset_info.str_name, s_asset_info.is_simple_prop, anim_tree );
	
	// Hide parts on a model if defined	
	if ( IsDefined( s_asset_info.a_parts ) )
	{
		for ( i = 0; i < s_asset_info.a_parts.size; i++ )
		{
			m_generic HidePart( s_asset_info.a_parts[ i ] );
		}
	}
	
	n_model_anims_size = level.a_scenes[ str_scene ].a_model_anims.size;
	level.a_scenes[ str_scene ].a_model_anims[ n_model_anims_size ] = m_generic;
}

/@
"Name: get_model_or_models_from_scene( <str_scene>, [str_name] )"
"Summary: Returns a model or an array of models from the specified scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [str_name] The animname of a model that you are looking for in a particular scene"
"Example: a_models = get_model_or_models_from_scene( str_scene );"
"SPMP: singleplayer"
@/
get_model_or_models_from_scene( str_scene, str_name )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for get_model_or_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	s_scene_info = level.a_scenes[ str_scene ];
	
	model_or_models = [];
	
	if ( !IsDefined( str_name ) )
	{
		// Grabs all models in a scene that has already been used for animation
		model_or_models = s_scene_info.a_model_anims;
		
		// If there are no models that has already been used for animation 
		if ( model_or_models.size == 0 )
		{
			// Find models that would be use for this scene in Radiant
			foreach ( str_anim_key, s_asset_info in s_scene_info.a_anim_info )
			{
				if ( IS_TRUE( s_asset_info.is_model ) && !IsDefined( s_asset_info.str_model ) )
				{
					model_or_models = s_asset_info _get_models_from_radiant( str_scene );
				}
			}
		}
		
		//REMOVE_UNDEFINED( model_or_models ); // doesn't look like we need this
	}
	else
	{
		// Loops through all models in the scene and finds a model or models with the same name
		foreach ( m_check in s_scene_info.a_model_anims )
		{
			if ( IsDefined( m_check ) && ( m_check.str_name == str_name ) )
			{
				ARRAY_ADD( model_or_models, m_check );
			}
		}
		
		// Return a model or undefined if there one model or no model is found with that name
		if ( model_or_models.size < 2 )
		{
			model_or_models = model_or_models[ 0 ];
		}
	}

	return model_or_models;
}

/@
"Name: get_ais_from_scene( <str_scene>, [str_animname] )"
"Summary: Returns an array of AIs from the specified scene, or a specific actor if an animname is specified"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [str_name] The animname of an AI that you are looking for in a particular scene"
"Example: a_ais = get_ais_from_scene( str_scene );"
"SPMP: singleplayer"
@/
get_ais_from_scene( str_scene, str_animname )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for get_model_or_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	if ( !is_scene_deleted( str_scene ) )
	{
		REMOVE_UNDEFINED( level.a_scenes[ str_scene ].a_ai_anims );
		
		if ( !IsDefined( str_animname ) )
		{
			return level.a_scenes[ str_scene ].a_ai_anims;
		}
		
		// Look for the actor with the desired animname
		foreach( ai_actor in level.a_scenes[ str_scene ].a_ai_anims )
		{
			if ( ai_actor.animname == str_animname )
			{
				return ai_actor;
			}
		}
	}
}

/@
"Name: get_scene_start_pos( <str_scene>, <str_name> )"
"Summary: Returns the start position for the specified object in a scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"MandatoryArg: <str_name> The name of the asset in the scene"
"Example: v_pos = get_scene_start_pos( "player_rappel", "player_body" );"
"SPMP: singleplayer"
@/
get_scene_start_pos( str_scene, str_name )
{
	a_anim_info = level.a_scenes[ str_scene ].a_anim_info;
	align = level.a_scenes[ str_scene ] _get_align_object( str_scene );
	return GetStartOrigin( align.origin, align.angles, a_anim_info[ str_name ].animation );
}

/@
"Name: scene_wait( <str_scene> )"
"Summary: Waits for a scene to be done"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"Example: scene_wait( "rr_1c" );"
"SPMP: singleplayer"
@/
scene_wait( str_scene )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for delete_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	flag_wait( str_scene + "_done" );
}

/@
"Name: skip_scene( <str_scene> )"
"Summary: Use in skipto functions to mark a scene as skipped so scene_wait will return as if the scene finished."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"Example: skip_scene( "rr_1c" );"
"SPMP: singleplayer"
@/
skip_scene( str_scene )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for skip_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	flag_set( str_scene + "_started" );
	flag_set( str_scene + "_done" );
	level.a_scenes[ str_scene ].b_skip = true;
}

/@
"Name: is_scene_skipped( <str_scene> )"
"Summary: Check if a scene is skipped if special event logic is needed for skipto."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"Example: if ( is_scene_skipped( "rr_1c" ) ){ ... }"
"SPMP: singleplayer"
@/
is_scene_skipped( str_scene )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for skip_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	return IS_TRUE( level.a_scenes[ str_scene ].b_skip );
}

/@
"Name: delete_models_from_scene( <str_scene> )"
"Summary: Delete all models from a scene. If the scene has not been played, it will delete the models that was in Radiant for the scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"Example: delete_models_from_scene( "rr_4" );"
"SPMP: singleplayer"
@/
delete_models_from_scene( str_scene )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for delete_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	_delete_models( str_scene );
}

/@
"Name: delete_ais_from_scene( <str_scene> )"
"Summary: Delete all AI from a scene. If the scene has not been played,"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"Example: delete_ais_from_scene( "rr_4" );"
"SPMP: singleplayer"
@/
delete_ais_from_scene( str_scene )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for delete_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	
	_delete_ais( str_scene );
}

/@
"Name: delete_scene( <str_scene>, [b_cleanup_vars] )"
"Summary: Deletes objects in a scene and resets AI weapons, etc. based on how scene was set up. Optionally cleans up system variables."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [b_cleanup_vars] Clean up system variables. Will not beable to run this scene again."
"OptionalArg: [b_cleanup_flags] Clean up system variables. Will not beable check to see if this scenes is running or done."
"Example: delete_scene( "rr_4" );"
"SPMP: singleplayer"
@/
delete_scene( str_scene, b_cleanup_vars, b_cleanup_flags )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for delete_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	Assert( !is_scene_deleted( str_scene ), "Attempting to delete a scene that's already been deleted." );
	
	_delete_scene( str_scene, true, b_cleanup_vars, undefined, b_cleanup_flags );
}

/@
"Name: delete_scene_all( <str_scene>, [b_cleanup_vars] )"
"Summary: Deletes all objects in a scene.  Optionally cleans up system variables."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [b_cleanup_vars] Clean up system variables. Will not beable to run this scene again."
"Example: delete_scene_all( "rr_4" );"
"SPMP: singleplayer"
@/
delete_scene_all( str_scene, b_cleanup_vars, b_keep_radiant_ents )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for delete_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene ] ), "Make sure this scene, " + str_scene + ", is added by using add_scene()" );
	Assert( !is_scene_deleted( str_scene ), "Attempting to delete a scene that's already been deleted." );
		
	_delete_scene( str_scene, false, b_cleanup_vars, b_keep_radiant_ents );
}

/*==============================================================
SELF: NA
PURPOSE: Main function to clean up a scene.  Will clean up models
			and AI based on settings in scene setup or optionally
			deletes everything.  Also optionally cleans up the
			system variables for this scene.
RETURNS: NA
CREATOR: BrianB (12/21/2011)
===============================================================*/
_delete_scene( str_scene, b_specific_ents, b_cleanup_vars, b_keep_radiant_ents, b_cleanup_flags )
{
	_delete_models( str_scene, b_specific_ents, b_keep_radiant_ents );
	_delete_ais( str_scene, b_specific_ents );
		
	if ( IS_TRUE( b_cleanup_vars ) )
	{	
		level.a_scenes[ str_scene ] = undefined;
		level.a_scenes[ str_scene ] = "scene deleted";
	}
	
	if ( IS_TRUE( b_cleanup_flags ) )
	{	
		flag_delete( str_scene + "_started" );
		flag_delete( str_scene + "_done" );	
	}
	
	level.scene_sys notify( "_delete_scene_" + str_scene );
}

/@
"Name: is_scene_deleted( <str_scene> )"
"Summary: Returns true or false depending on if a scene is deleted and cannot be run again."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"Example: is_scene_deleted( "rr_4" );"
"SPMP: singleplayer"
@/
is_scene_deleted( str_scene )
{
	return ( IsString( level.a_scenes[ str_scene ] ) && ( level.a_scenes[ str_scene ] == "scene deleted" ) );
}

/*==============================================================
SELF: level
PURPOSE: Checks to see if there are different animations in a
		 'generic' scene
RETURNS: A boolean that determains if there are different
		 animations in the scene
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_has_different_generic_anims( str_scene )
{
	has_different = false;
	
	a_anim_info = level.a_scenes[ str_scene ].a_anim_info;
	a_anim_keys = GetArrayKeys( a_anim_info );
	
	// Loops through all asset info and see if any of them has a different animation
	// This is used mainly for error check to make sure there are no different animations in a 'generic' scene
	for ( i = 0; i < a_anim_keys.size; i++ )
	{
		anim_current = a_anim_info[ a_anim_keys[ i ] ].animation;
		
		for ( j = i + 1; j < a_anim_info.size; j++ )
		{
			anim_check = a_anim_info[ a_anim_keys[ j ] ].animation;
			
			if ( anim_current != anim_check )
			{
				has_different = true;
			}
		}
	}
	
	return has_different;
}

/*==============================================================
SELF: level
PURPOSE: Checks to see if there are different animations in a
		 'generic' scene
RETURNS: A boolean that determains if there are different
		 animations in the scene
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_add_anim_to_current_scene()
{
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ self.str_name ] = self;
	self thread _preprocess_notetracks();
}

/*==============================================================
SELF: A struct that has all the info for that scene
PURPOSE: Finds the align object for a scene. Returns 'level' by default.
RETURNS: The align object or level
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_get_align_object( str_scene )
{
	align_object = level;
	
	if ( IsDefined( self.align_object ) )
	{
		align_object = self.align_object;
	}
	else if ( IsDefined( self.str_align_targetname ) )
	{
		align_object = getstruct( self.str_align_targetname, "targetname" );

		if ( !IsDefined( align_object ) )
		{
			align_object = GetNode( self.str_align_targetname, "targetname" );
			
			if ( IsDefined( align_object ) )
			{
				align_object.is_node = true;
			}
			else
			{
				align_object = GetEnt( self.str_align_targetname, "targetname" );
			}
		}
		else
		{
			// Spawns a copy of the struct in case another scene needs to be aligned to it
			s_align = SpawnStruct();
			s_align.origin = align_object.origin;
			
			if ( IsDefined( align_object.angles ) )
			{
				s_align.angles = align_object.angles;
			}
			else
			{
				s_align.angles = ( 0, 0, 0 );
			}
			
			align_object = s_align;
		}
		
		Assert( IsDefined( align_object ), "Could not find a struct, node, or entity with the targetname, " + self.str_align_targetname + ", in the map for scene, " + str_scene );
		
		level.a_scenes[ str_scene ].align_object = align_object;
	}
	
	return align_object;
}

/*==============================================================
SELF: The align object
PURPOSE: Assemble all assets that needs to be animated for this
		 scene into one array
RETURNS: An array of assets that are ready for animation
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_assemble_assets( str_scene, b_test_run, b_skip_ai = false, b_first_frame )
{
	s_scene_info = level.a_scenes[ str_scene ];
	
	// Loops through all assets and sets each of them based on various criterias
	foreach ( str_anim_key, s_asset_info in s_scene_info.a_anim_info )
	{
		if ( str_anim_key == "generic" )
		{
			continue; // The scripter should have already set this up using add_generic_ai_to_scene() or add_generic_prop_to_scene()
		}
		
		if ( ( IsDefined( s_asset_info.str_model ) || IsDefined( s_asset_info.str_vehicletype ) || IsDefined( s_asset_info.n_player_number ) )
		      && !IsDefined( level.scene_sys.a_active_anim_models[ s_asset_info.str_name ] ) )
		{
			// Spawns a model that does not exist yet and sets it up for animation
			s_asset_info _assemble_non_existent_model( str_scene, b_first_frame );
		}
		else if ( IS_TRUE( s_asset_info.is_model ) )
		{
			// Model already exists, but needs to be set up for animation
			s_asset_info _assemble_already_exist_model( str_scene, b_first_frame );
		}
		else if ( !b_skip_ai ) // Sets AIs up for animation
		{
			if ( IS_TRUE( s_asset_info.has_multiple_ais ) )
			{
				s_asset_info _assemble_multiple_ais( str_scene, b_test_run );
			}
			else
			{		
				s_asset_info _assemble_single_ai( str_scene, str_anim_key, b_test_run );
			}
		}
	}
	
	a_active_anims = [];
	
	if ( IsDefined( s_scene_info.a_ai_anims ) )
	{
		REMOVE_UNDEFINED( s_scene_info.a_ai_anims );
		a_active_anims = ArrayCombine( a_active_anims, s_scene_info.a_ai_anims, true, false );
	}
	
	if ( IsDefined( s_scene_info.a_model_anims ) )
	{
		REMOVE_UNDEFINED( s_scene_info.a_model_anims );
		a_active_anims = ArrayCombine( a_active_anims, s_scene_info.a_model_anims, true, false );
	}
	
	return a_active_anims;
}

/*==============================================================
SELF: A struct that has all the info for that model
PURPOSE: Spawns a model that does not exist yet and sets it up for animation
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_assemble_non_existent_model( str_scene, b_first_frame )
{
	if ( IsDefined( self.str_vehicletype ) )
	{
		m_ready = _spawn_vehicle_for_anim();
	}
	else
	{
		if ( IsDefined( self.n_player_number ) )
		{
			level.scr_model[ self.str_name ] = level.player_interactive_model;
		}
		
		m_ready = spawn( "script_model", ( 0, 0, 0 ), ( IS_TRUE( self.b_connect_paths ) ? SPAWNFLAG_MODEL_DYNAMIC_PATH : undefined ) );
		m_ready assign_model( self.str_name );
		m_ready init_anim_model( self.str_name, self.is_simple_prop );
	}
	
	// Checks to see if this asset is for the player and handles player specific tasks
	if ( IsDefined( self.n_player_number ) )
	{
		player = get_players()[ self.n_player_number ];
		
		if ( !level.createFX_enabled )
		{
			if ( level.era != "twentytwenty" )	// Dont hide the glasses
			{
				player hide_hud();
			}
			
			LUINotifyEvent( &"hud_shrink_ammo" );
			
			self thread _link_to_player_model( player, m_ready );
		}
		
		m_ready.origin = player GetOrigin();
		m_ready.angles = player GetPlayerAngles();

		m_ready UsePlayerFootstepTable();
		
		m_ready.n_player_number = self.n_player_number;
		
		player DisableWeapons();
		player HideViewModel();
		
		player.m_scene_model = m_ready;
		player.s_scene_info = self;
	}
	
	m_ready.targetname = self.str_name;
	m_ready thread _setup_asset_for_scene( self, b_first_frame );
	
	level.scene_sys.a_active_anim_models[ self.str_name ] = m_ready;
	
	if ( !IsDefined( level.a_scenes[ str_scene ].a_model_anims ) )
	{
		level.a_scenes[ str_scene ].a_model_anims = [];
	}
	
	ARRAY_ADD( level.a_scenes[ str_scene ].a_model_anims, m_ready );
}

_setup_asset_for_scene( s_asset_info, b_first_frame = false )
{
	self.str_name = s_asset_info.str_name;
	self.animname = s_asset_info.str_name;
	self.do_delete = s_asset_info.do_delete;
	self.str_tag = s_asset_info.str_tag;
	
	if ( IsDefined( s_asset_info.a_parts ) )
	{
		foreach ( str_part in s_asset_info.a_parts )
		{
			self HidePart( str_part );
		}
	}
	
	if ( IS_TRUE( s_asset_info.is_weapon ) )
	{
		self UseWeaponHideTags( self.str_weapon_name );
	}
	else if ( IsAI( self ) )
	{
		_setup_ai_for_scene( s_asset_info );
	}
	else if ( self IsVehicle() )
	{
		_setup_vehicle_for_scene( s_asset_info );
	}
	else if ( IS_TRUE( s_asset_info.is_model ) )
	{
		_setup_model_for_scene( s_asset_info, b_first_frame );		
	}
}

/*==============================================================
SELF: An AI
PURPOSE: Sets up an AI based on its asset info
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_setup_ai_for_scene( s_asset_info )
{
	if ( IS_TRUE( s_asset_info.do_not_allow_death ) )
	{
		self.allowdeath = false;
		self SetCanDamage( false );
	}
	else
	{
		self.allowdeath = true;
		self SetCanDamage( true );
	}

	self.do_hide_weapon = s_asset_info.do_hide_weapon;
	self.do_give_back_weapon = s_asset_info.do_give_back_weapon;
}

/*==============================================================
SELF: An AI
PURPOSE: Sets up a vehicle based on its asset info
RETURNS: nothing
CREATOR: BrianB (02/21/2012)
===============================================================*/
_setup_vehicle_for_scene( s_asset_info )
{
	if ( IS_TRUE( s_asset_info.do_not_allow_death ) )
	{
		self.takedamage = false;
	}
	else if ( !IS_TRUE( self.script_godmode ) )
	{
		self.takedamage = true;
	}
	
	if ( IS_FALSE( s_asset_info.b_animate_origin ) )
	{
		self.supportsAnimScripted = undefined;
	}
	else
	{
		self.supportsAnimScripted = true;
	}
}

/*==============================================================
SELF: An AI
PURPOSE: Sets up a model based on its asset info
RETURNS: nothing
CREATOR: BrianB (05/16/2012)
===============================================================*/
_setup_model_for_scene( s_asset_info, b_first_frame )
{
	if ( IS_TRUE( s_asset_info.b_connect_paths ) )
	{
		if ( b_first_frame )
		{
			wait_network_frame();	// allow animation to be applied before disconnecting paths
			self DisconnectPaths();
		}
		else
		{
			self ConnectPaths();
			self.b_disconnect_paths_after_scene = true;
		}
	}
	else
	{
		// clear it out for scenes that don't set b_connect_paths parameter
		self.b_disconnect_paths_after_scene = undefined;
	}
}

/*==============================================================
SELF: A struct that has all the info for that model
PURPOSE: Links the player to the body model after a delay to give
		the animation time to take effect on the client before
		linking to reduce camera pop.
RETURNS: nothing
CREATOR: BrianB (9/29/11)
===============================================================*/
_link_to_player_model( player, m_player_model, b_first_link = true )
{
	if ( b_first_link )
	{
		player EnableInvulnerability();
		m_player_model Hide();
	
		wait_network_frame();
	
		if ( !IS_FALSE( self.b_use_camera_tween ) )
		{
			player StartCameraTween( 0.2 );
		}
	}
	
	player notify( "scene_link" );
	waittillframeend;	// allow level script to run to do custom stuff before linking
	
	if ( IS_TRUE( self.do_delta ) )
	{
		player PlayerLinkToDelta( m_player_model, "tag_player", self.n_view_fraction, self.n_right_arc, self.n_left_arc, self.n_top_arc, self.n_bottom_arc, self.use_tag_angles, self.b_auto_center );
	}
	else
	{
		player PlayerLinkToAbsolute( m_player_model, "tag_player" );
	}
	
	if ( b_first_link )
	{	
		wait .2;	
		m_player_model Show();
	}
}

/@
"Name: switch_player_scene_to_delta()"
"Summary: Switches a player to allow head look in the middle of a scene."
"Module: Animation"
"CallOn: level"
"Example: level.player switch_player_scene_to_delta();"
"SPMP: singleplayer"
@/
switch_player_scene_to_delta()
{
	Assert( IsDefined( self.m_scene_model ), "switch_player_scene_to_delta can only be called on an active scene." );
	self PlayerLinkToDelta( self.m_scene_model, "tag_player", self.s_scene_info.n_view_fraction, self.s_scene_info.n_right_arc, self.s_scene_info.n_left_arc, self.s_scene_info.n_top_arc, self.s_scene_info.n_bottom_arc, self.s_scene_info.use_tag_angles, self.s_scene_info.b_auto_center );
}

/*==============================================================
SELF: NA
PURPOSE: Links the player to the body model using PlayerLinkToDelta.
		Useful for starting the animation in PlayerLinkToAbsolute.
		This version will be useful for notetracks.
RETURNS: nothing
CREATOR: BrianB (10/3/11)
===============================================================*/
_switch_to_delta( m_player_model )
{
	player = level.players[ m_player_model.n_player_number ];	
	player switch_player_scene_to_delta();
}

/*==============================================================
SELF: A struct that has all the info for that model
PURPOSE: Set a model that already exists up for animation
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_assemble_already_exist_model( str_scene, b_first_frame )
{
	a_models = [];
	
	// Models that have already animated
	if ( IsDefined( level.scene_sys.a_active_anim_models[ self.str_name ] ) )
	{
		if ( IsArray( level.scene_sys.a_active_anim_models[ self.str_name ] ) )
		{
			a_models = level.scene_sys.a_active_anim_models[ self.str_name ];
		}
		else
		{
			m_model = level.scene_sys.a_active_anim_models[ self.str_name ];
			ARRAY_ADD( a_models, m_model );
			
			if ( IsDefined( self.n_player_number ) )
			{
				if ( !level.createFX_enabled )
				{
					player = get_players()[ self.n_player_number ];
					self thread _link_to_player_model( player, m_model, false );
				}
			}
		}
	}
	else // For models that are in Radiant, but has not been animated before
	{
		if(!IsDefined(self.str_spawner))
		{
			a_models = self _get_models_from_radiant( str_scene );
		}
		
		if ( a_models.size == 0 )
		{
			if ( IS_TRUE( self.is_vehicle ) )
			{
				a_models = maps\_vehicle::spawn_vehicles_from_targetname( self.str_name, true );
				foreach ( veh in a_models )
				{
					veh._radiant_ent = true;
				}
			}
			else
			{
				sp_model = _get_spawner( self.str_name, str_scene, self.str_spawner );
				m_drone = sp_model spawn_drone( true, undefined, true );
				
				if ( IsDefined( self.str_spawner ) )
				{
					// Using a shared spawner, give this ent a more useful targetname
					m_drone.targetname = self.str_name + "_drone";
				}
				
				a_models[0] = m_drone;
			}
		}
	
		if ( IS_TRUE( self.is_vehicle ) && IS_TRUE( self.not_usable ) )
		{
			foreach ( e_model in a_models )
			{
				e_model MakeVehicleUnusable();
			}
		}
	}
	
	n_models_array_size = a_models.size;
	Assert( n_models_array_size > 0, "Could not find any models with this animname or targetname, " + self.str_name + ", anywhere in the level" );

	// Creates an array if there is more than one model for this name
	if ( ( n_models_array_size > 1 ) && !IsDefined( level.scene_sys.a_active_anim_models[ self.str_name ] ) )
	{
		level.scene_sys.a_active_anim_models[ self.str_name ] = [];
	}
	
	// Loops through all models and sets it up for animation
	for ( i = 0; i < n_models_array_size; i++ )
	{
		m_exist = a_models[ i ];
		
		s_asset_info = level.a_scenes[ str_scene ].a_anim_info[ self.str_name ];
		m_exist init_anim_model( self.str_name, self.is_simple_prop, s_asset_info.anim_tree );
		m_exist thread _setup_asset_for_scene( self, b_first_frame );
		
		if ( n_models_array_size > 1 )
		{
			level.scene_sys.a_active_anim_models[ self.str_name ][ i ] = m_exist;
		}
		else
		{
			level.scene_sys.a_active_anim_models[ self.str_name ] = m_exist;
		}
		
		if ( !IsDefined( level.a_scenes[ str_scene ].a_model_anims ) )
		{
			level.a_scenes[ str_scene ].a_model_anims = [];
		}
		
		if ( !IsInArray( level.a_scenes[ str_scene ].a_model_anims, m_exist ) )
		{
			ARRAY_ADD( level.a_scenes[ str_scene ].a_model_anims, m_exist );
		}
	}
}

/*==============================================================
SELF: A struct that has all the info for the AI
PURPOSE: Assemble multiple AIs for animation
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_assemble_multiple_ais( str_scene, b_test_run )
{
	a_ai_spawned = GetEntArray( self.str_name + "_ai", "targetname" );
	
	does_spawner_exist = false;
	
	// Spawn AIs with that targetname if the AIs does not already exist in the level
	if ( a_ai_spawned.size == 0 )
	{
		a_ai_spawners = GetEntArray( self.str_name, "targetname" );
		
		// Checks to see if there is any spawners with that name found
		if ( a_ai_spawners.size > 0  )
		{
			does_spawner_exist = true;
			foreach ( sp_guy in a_ai_spawners )
			{
				n_spawner_count = sp_guy.count;
				
				// Spawn an AI if it can be spawn from this spawner
				for ( j = 0; j < n_spawner_count; j++ )
				{
					/#
					if ( IS_TRUE( b_test_run ) )
					{
						//development support for running scenes outside of event logic
						sp_guy.count++;
					}
					#/
					
					ai = simple_spawn_single( sp_guy );
					Assert( IsAlive( ai ), "Failed to spawn AI '" + self.str_name + "' for scene '" + str_scene + "'. Make sure player cannot see the spawn point or the spawner has spawnflag SCRIPT_FORCESPAWN set." );
					
					ARRAY_ADD( a_ai_spawned, ai );
				}
			}
		}
	}
	
	does_ai_exist = a_ai_spawned.size > 0;
	Assert( does_ai_exist || does_spawner_exist, "Could not find any AIs or spawners with this targetname, " + self.str_name + ", for the scene, " + str_scene );
	
	if ( a_ai_spawned.size > 0 )
	{
		// Sets up the AIs and puts them in the actor anims array
		foreach ( ai_spawned in a_ai_spawned )
		{
			ai_spawned thread _setup_asset_for_scene( self );
			
			if ( !IsDefined( level.a_scenes[ str_scene ].a_ai_anims ) )
			{
				level.a_scenes[ str_scene ].a_ai_anims = [];
			}
			
			ARRAY_ADD( level.a_scenes[ str_scene ].a_ai_anims, ai_spawned );
		}
	}
}

/*==============================================================
SELF: A struct that has all the info for the AI
PURPOSE: Assemble a specific AI for animation
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_assemble_single_ai( str_scene, str_anim_key, b_test_run )
{
	a_all_ai_in_level = GetAISpeciesArray();
	ai_found = undefined;
	
	// Tries to find an AI with this animname by searching through all the AIs in the level
	foreach ( ai in a_all_ai_in_level )
	{
		if ( IS_EQUAL( ai.animname, str_anim_key ) )
		{
			Assert( !IsDefined( ai_found ), "More than one AI in the level has the same animname, " + self.str_name + ", for scene, " + str_scene );
			ai_found = ai;
		}
	}
	
	if ( !IsAlive( ai_found ) )
	{
		sp_guy = _get_spawner( str_anim_key, str_scene, self.str_spawner );
		Assert( IsDefined( sp_guy ) || IS_TRUE( self.b_optional ), "Couldn't find spawner with name '" + str_anim_key + "' for scene '" + str_scene + "'." );
		
		if ( IsDefined( sp_guy ) )
		{
			if ( IS_TRUE( sp_guy.script_hero ) )
			{
				ai_found = init_hero( sp_guy.targetname );
			}
			else
			{
				/#
				if ( IS_TRUE( b_test_run ) )
				{
					//development support for running scenes outside of event logic
					sp_guy.count++;
				}
				
				Assert( sp_guy.count > 0 || IS_TRUE( self.b_optional ), "Trying to spawn AI '" + str_anim_key + "' for scene '" + str_scene + "' with zero spawner count! Might need a higher count value on the spawner." );
				#/
				
				if ( sp_guy.count > 0 )
				{
					ai_found = simple_spawn_single( sp_guy, undefined, undefined, undefined, undefined, undefined, undefined, b_test_run );
				}
				
				if ( IsAlive( ai_found ) )
				{
					ai_found DontInterpolate();	// when spawning AI for animation, dont interpolate to animation location. Should fix some glitches we sometimes see.
				}
			}
		}
	}
				
	Assert( IsAlive( ai_found ) || IS_TRUE( self.b_optional ), "Failed to spawn AI '" + str_anim_key + "' for scene '" + str_scene + "'. Make sure player cannot see the spawn point or the spawner has spawnflag SCRIPT_FORCESPAWN set." );
	
	if ( IsAlive( ai_found ) )
	{
		ai_found thread _setup_asset_for_scene( self );
		
		if ( IsDefined( self.str_spawner ) )
		{
			// Using a shared spawner, give this ent a more useful targetname
			ai_found.targetname = str_anim_key + "_ai";
		}
			
		if ( !IsDefined( level.a_scenes[ str_scene ].a_ai_anims ) )
		{
			level.a_scenes[ str_scene ].a_ai_anims = [];
		}
			
		ARRAY_ADD( level.a_scenes[ str_scene ].a_ai_anims, ai_found );
	}
}

_get_spawner( str_name, str_scene, str_name_override )
{
	if ( IsDefined( str_name_override ) )
	{
		str_name = str_name_override;
	}
	
	/* Find by targetname */
	
	a_spawners = GetSpawnerArray( str_name, "targetname" );
	if ( a_spawners.size > 0 )
	{
		if ( a_spawners.size == 1 )
		{
			return a_spawners[0];
		}
		else
		{
			/#
			AssertMsg( "More than one spawner in Radiant has the same name, '" + str_name + "', for scene, '" + str_scene + "'.");
			#/
		}
	}
	
	/* Find by script_animname */
	
	if ( !IsDefined( level.a_scene_ai_spawners ) )
	{
		level.a_scene_ai_spawners = GetSpawnerArray();
	}
	
	sp = undefined;
	
	/#
	b_found = false;
	#/
		
	// Loops through all spawners and spawns an AI if it can and has the required script_animname
	foreach ( sp_guy in level.a_scene_ai_spawners )
	{
		if ( IS_EQUAL( sp_guy.script_animname, str_name ) )
		{
			sp = sp_guy;
			
			/#
			Assert( !b_found, "More than one spawner in Radiant has the same name, '" + str_name + "', for scene, '" + str_scene + "'.");
			b_found = true;
			continue;
			#/

			break;				
		}
	}
	
	level thread _delete_scene_ai_spawner_array();
	return sp;
}

/*==============================================================
SELF: An asset
PURPOSE: Notify a scene to end if this asset dies
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_anim_death_notify( str_scene, a_active_anims )
{
	self endon( str_scene );
	
	array_wait( a_active_anims, "death" );
	
	self notify( str_scene );
}

_watch_for_stop_anim( str_scene, align_object )
{
	self endon( "death" );
	level.scene_sys endon( "_delete_scene_"+str_scene );
	
	self waittill( "_scene_stopped" );
	
	align_object notify( str_scene );
}

/*==============================================================
SELF: An asset
PURPOSE: Animates an asset based on the scene info
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_animate_asset( str_scene, align_object, n_lerp_time, b_test_run = false )
{
	self endon( "death" );
	//self endon( "_anim_stopped" );  // sent from anim_stopanimscripted()
	self thread _watch_for_stop_anim( str_scene, align_object );
	
	s_scene_info = level.a_scenes[ str_scene ];
	
	if ( IS_VEHICLE( self ) )
	{
		old_free_vehicle = self.dontfreeme;
		self.dontfreeme = true;
	}
	
	if ( IS_TRUE( s_scene_info.do_reach ) && !level flag( "running_skipto" ) && !b_test_run )
	{
		self _run_anim_reach_on_asset( str_scene, align_object );
		
		// Waits for all the AIs in this scene to be done with their anim_reach
		array_wait( s_scene_info.a_ai_anims, "goal" );
	}
	
	if ( IsAI( self ) )
	{
		if ( IS_TRUE( self.do_hide_weapon ) )
		{
			self gun_remove();
		}
		else if ( IsDefined( self.species ) && self.species == "human" )
		{
			self gun_recall();
		}
	}
	
	if ( !b_test_run )
	{
		flag_set( str_scene + "_started" );
	}
	
	//self thread _process_notetracks( str_scene, s_scene_info.do_loop );
	
	if ( IS_TRUE( s_scene_info.do_loop ) )
	{
		self _run_anim_loop_on_asset( str_scene, align_object, n_lerp_time );
	}
	else
	{
		self _run_anim_single_on_asset( str_scene, align_object, n_lerp_time );
	}
	
	if ( IS_VEHICLE( self ) )
	{
		self.dontfreeme = old_free_vehicle;
	}
}

/*==============================================================
SELF: An asset
PURPOSE: Makes an AI in this scene to do a reach
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_run_anim_reach_on_asset( str_scene, align_object )
{
	s_scene_info = level.a_scenes[ str_scene ];
	
	// Only do reach on an AI
	if ( IsSentient( self ) )
	{
		if ( IS_TRUE( s_scene_info.do_not_align ) )
		{
			if ( IS_TRUE( s_scene_info.do_generic ) )
			{
				align_object thread anim_generic_reach( self, str_scene );
			}
			else
			{
				align_object thread anim_reach( self, str_scene );
			}
		}
		else
		{
			if ( IS_TRUE( s_scene_info.do_generic ) )
			{
				align_object thread anim_generic_reach_aligned( self, str_scene, self.str_tag );
			}
			else
			{
				align_object thread anim_reach_aligned( self, str_scene, self.str_tag );
			}
		}
	}
}

/*==============================================================
SELF: An asset
PURPOSE: Plays a loop animation on a specific asset
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_run_anim_loop_on_asset( str_scene, align_object, n_lerp_time )
{
	s_scene_info = level.a_scenes[ str_scene ];
	
	if( isdefined( self.is_horse ) )
	{
		self ent_flag_set("playing_scripted_anim");
	}
	
	if ( IS_TRUE( s_scene_info.do_not_align ) )
	{
		if ( IS_TRUE( s_scene_info.do_generic ) )
		{
			align_object anim_generic_loop( self, str_scene );
		}
		else
		{
			align_object anim_loop( self, str_scene );
		}
	}
	else
	{
		// Links the asset to a specific tag if the tag is defined
		if ( IsDefined( self.str_tag ) )
		{
			self thread _scene_link( align_object, self.str_tag );
		}
				
		if ( IS_TRUE( s_scene_info.do_generic ) )
		{
			align_object anim_generic_loop_aligned( self, str_scene, self.str_tag, undefined, n_lerp_time );
		}
		else
		{
			align_object anim_loop_aligned( self, str_scene, self.str_tag, undefined, undefined, n_lerp_time );
		}
		
		if ( !IS_TRUE( self._scene_linking ) && IsDefined( self.str_tag ) )
		{
			self Unlink();
		}
	}
}

/*==============================================================
SELF: An asset
PURPOSE: Plays a single animation on a specific asset
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_run_anim_single_on_asset( str_scene, align_object, n_lerp_time )
{
	if( is_scene_deleted( str_scene ) )
	{
		/#
		PrintLn( "ERROR: Trying to run deleted scene "+str_scene+"!" );
		#/
		return;
	}
	
	s_scene_info = level.a_scenes[ str_scene ];
	
	if( isdefined( self.is_horse ) )
	{
		self ent_flag_set("playing_scripted_anim");
	}
	
	if ( level flag( "running_skipto" ) )
	{
		self._anim_rate = 10;
	}
		
	if ( IS_TRUE( s_scene_info.do_not_align ) )
	{
		if ( IS_TRUE( s_scene_info.do_generic ) )
		{
			align_object anim_generic( self, str_scene );
		}
		else
		{
			align_object anim_single( self, str_scene );
		}
	}
	else
	{
		// Links the asset to a specific tag if the tag is defined
		if ( IsDefined( self.str_tag ) && ( self != align_object ) )
		{
			self thread _scene_link( align_object, self.str_tag );
		}
				
		if ( IS_TRUE( s_scene_info.do_generic ) )
		{
			align_object anim_generic_aligned( self, str_scene, self.str_tag, n_lerp_time );
		}
		else
		{
			align_object anim_single_aligned( self, str_scene, self.str_tag, undefined, n_lerp_time );
		}
		
		if ( IS_TRUE( align_object.is_node ) && IsAI( self ) )
		{
			SetEnableNode( align_object, true );
			self SetGoalNode( align_object );
		}
		else if ( !IS_TRUE( self._scene_linking ) && IsDefined( self.str_tag ) && ( self != align_object ) )
		{
			self Unlink();
		}
		
		if ( IS_TRUE( self.b_connect_paths ) )
		{
			self DisconnectPaths();
		}
	}
	
	self._anim_rate = undefined;
	
	if( isdefined( self.is_horse ) )
	{
		self ent_flag_clear("playing_scripted_anim");
	}
}

_scene_link( align_object, str_tag )
{
	self endon( "death" );
	self._scene_linking = true;
	self LinkTo( align_object, str_tag );
	waittillframeend;
	self._scene_linking = undefined;
}

/*==============================================================
SELF: An asset
PURPOSE: Puts an animation on its first frame on a specific asset
RETURNS: nothing
CREATOR: BrianB (06/27/2011)
===============================================================*/
_run_anim_first_frame_on_asset( str_scene, align_object, b_clear_anim = false )
{
	s_scene_info = level.a_scenes[ str_scene ];
	
	if ( IsAI( self ) )
	{
		self.allowdeath = false;
		self SetCanDamage( false );
	}
	
	if ( IS_TRUE( s_scene_info.do_not_align ) )
	{
		self anim_first_frame( self, str_scene );
	}
	else
	{
		// Links the asset to a specific tag if the tag is defined
		if ( IsDefined( self.str_tag ) && ( self != align_object ) )
		{	
			self LinkTo( align_object, self.str_tag );
		}
				
		align_object anim_first_frame( self, str_scene, self.str_tag );
		
		if ( b_clear_anim )
		{
			self thread _clear_anim_first_frame();
		}
	}
}

_clear_anim_first_frame()
{
	wait_network_frame();
	self StopAnimScripted();
}

/*==============================================================
SELF: A struct that has all the info for a model or models
PURPOSE: Get model or models from Radiant
RETURNS: An array of models
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_get_models_from_radiant( str_scene )
{
	a_models = [];
	m_exist = undefined;
	
	level.from_radiant_count = 0;
	
	if ( IS_TRUE( self.has_multiple_props ) )
	{
		a_models = GetEntArray( self.str_name, "targetname" );
	}
	else
	{
		//-- ONLY BUILD THIS ARRAY ONCE PER FRAME
		if (!IsDefined(level.a_script_models) || !IsDefined(level.a_script_models_time) || level.a_script_models_time != GetTime())
		{
			level.a_script_models = [];
			level.a_script_models["script_model"] = GetEntArray( "script_model", "classname" );
			level.a_script_models["script_vehicle"] = GetEntArray( "script_vehicle", "classname" );
			level.a_script_models["script_brushmodel"] = GetEntArray( "script_brushmodel", "classname" );
			level.a_script_models_time = GetTime();
		}
		
		if (IS_TRUE(self.is_vehicle))
		{
			m_exist = _get_models_from_radiant_internals( "script_vehicle" );
		}
		else
		{
			m_exist = _get_models_from_radiant_internals( "script_model" );
		
			if(!IsDefined(m_exist))
			{
				m_exist = _get_models_from_radiant_internals( "script_brushmodel" );
			}
		}
		
		if ( IsDefined( m_exist ) )
		{
			m_exist._radiant_ent = true;
			ARRAY_ADD( a_models, m_exist );
		}
		
		level thread _delete_scene_script_model_array();
	}
	
	/#println("*****RADIANT COUNT = " + level.from_radiant_count);#/
	return a_models;
}

_get_models_from_radiant_internals( str_key_type )
{
	my_array = level.a_script_models[str_key_type];
	m_in_radiant = undefined;
	
	foreach ( m_in_radiant in my_array )
	{
		// Tries to find a prop with this targetname
		if ( IsDefined( m_in_radiant.targetname ) )
		{
			if ( m_in_radiant.targetname == self.str_name )
			{
				//Assert( !IsDefined( m_exist ), "Another model in Radiant has the same targetname, " + self.str_name + ", as a prop in scene, " + str_scene );
				return m_in_radiant;
			}
		}	
	
		// Tries to find a prop with this animname
		if ( IsDefined( m_in_radiant.animname ) )
		{
			if ( m_in_radiant.animname == self.str_name )
			{
				//Assert( !IsDefined( m_exist ), "Another model in Radiant has the same animname, " + self.str_name + ", as a prop in scene, " + str_scene );
				return m_in_radiant;
			}
		}
			
		// Tries to find a prop with this script_animname
		if ( IsDefined( m_in_radiant.script_animname ) )
		{
			if ( m_in_radiant.script_animname == self.str_name )
			{
				//Assert( !IsDefined( m_exist ), "Another model in Radiant has the same script_animname, " + self.str_name + ", as a prop in scene, " + str_scene );
				return m_in_radiant;
			}
		}
		
		level.from_radiant_count++;
	}
	
	return undefined;
}

_delete_scene_script_model_array()
{
	level notify("kill_del_scr_array_thread");
	level endon("kill_del_scr_array_thread");
	
	while(level.a_script_models_time == GetTime())
	{
		wait (0.05);
	}
	
	level.a_script_models = undefined;
	level.a_script_models_time = undefined;
}

_delete_scene_ai_spawner_array()
{
	level notify("kill_del_ai_array_thread");
	level endon("kill_del_ai_array_thread");
	
	wait(0.05);
	
	level.a_scene_ai_spawners = undefined;
}

/*==============================================================
SELF: level
PURPOSE: Deletes all models in a specific scene or specific models
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_delete_models( str_scene, b_specific_models, b_keep_radiant_ents )
{
	if ( is_scene_deleted( str_scene ) )
	{
		return;
	}
	
	if ( !IsDefined( level.a_scenes[ str_scene ].a_model_anims ) )
	{
		return;
	}
	
	if ( !IsDefined( b_specific_models ) )
	{
		b_specific_models = false;
	}
	
	foreach ( model in level.a_scenes[ str_scene ].a_model_anims )
	{
		if ( IsDefined( model ) )
		{
			if ( IS_TRUE( model.do_delete )
			    || ( !b_specific_models && ( !IS_TRUE( b_keep_radiant_ents ) || !IS_TRUE( model._radiant_ent) ) ) )
			{
				if ( IsDefined( model.n_player_number ) )
				{
					player = get_players()[ model.n_player_number ];
					player _reset_player_after_anim();
				}
				
				model Delete();
			}
			else
			{
				if ( IS_TRUE( model.b_disconnect_paths_after_scene ) )
				{
					model DisconnectPaths();
				}
			}
		}
	}
	
	REMOVE_UNDEFINED( level.scene_sys.a_active_anim_models );
	REMOVE_UNDEFINED( level.a_scenes[ str_scene ].a_model_anims );
}

/*==============================================================
SELF: a player
PURPOSE: Resets the player back to normal
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_reset_player_after_anim()
{
	self.s_scene_info = undefined;
	self.m_scene_model = undefined;
	
	self EnableWeapons();
	self ShowViewModel();
	self DisableInvulnerability();
	
	if ( level.era != "twentytwenty" )	// The glasses aren't hidden.
	{
		self show_hud();
	}
	
	LUINotifyEvent( &"hud_expand_ammo" );
}

/*==============================================================
SELF: level
PURPOSE: Deletes all AIs in a specific scene or specific AIs
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_delete_ais( str_scene, b_specific_ais )
{
	if ( is_scene_deleted( str_scene ) )
	{
		return;
	}
	
	if ( !IsDefined( level.a_scenes[ str_scene ].a_ai_anims ) )
	{
		return;
	}
	
	if ( !IsDefined( b_specific_ais ) )
	{
		b_specific_ais = false;
	}
			
	foreach ( ai in level.a_scenes[ str_scene ].a_ai_anims )
	{
		if ( IsDefined( ai ) )
		{
			if ( !b_specific_ais || IS_TRUE( ai.do_delete ) )
			{
				ai Delete();
			}
			else
			{
				if ( IS_TRUE( ai.do_give_back_weapon ) )
				{
					ai gun_recall();
				}
				
				ai SetCanDamage( true );
			}
		}
	}
	
	REMOVE_UNDEFINED( level.a_scenes[ str_scene ].a_ai_anims );
}

/@
"Name: add_scene( <str_scene>, [str_align_targetname], [do_reach], [do_generic], [do_loop], [do_not_align] )"
"Summary: Initializes information on a new scene, so that animations can be later added to it. This must be called before adding any animation information for that scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [str_align_targetname] The targetname of struct, node or entity, that the scene is aligned to. This is required if do_reach is true or do_not_align is false."
"OptionalArg: [do_reach] A boolean to determine if the AIs in the scene needs to do a reach. Default is false."
"OptionalArg: [do_generic] A boolean to determine if the scene is 'generic'. Default is false."
"OptionalArg: [do_loop] A boolean to determine if the assets in the scene needs to be looped. Default is false."
"OptionalArg: [do_not_align] A boolean to determine if the scene is aligned or not. Default is false."
"Example: add_scene( "rr_1", "anim_rr" );"
"SPMP: singleplayer"
@/
add_scene( str_scene, str_align_targetname, do_reach, do_generic, do_loop, do_not_align )
{	
	if ( !IsDefined( level.scene_sys ) )
	{
		level.scene_sys = SpawnStruct();
		level.scene_sys.str_current_scene = undefined;
		
		// This array keeps up with all models that are ready for animations in a level
		// It is useful for having a quick look up later in other functions
		level.scene_sys.a_active_anim_models = [];
	}
	
	if ( !IsDefined( level.a_scenes ) )
	{
		level.a_scenes = [];
	}
	
	Assert( IsDefined( str_scene ), "str_scene is a required argument for add_scene()" );
	Assert( !IsDefined( level.a_scenes[ str_scene ] ), "Scene, " + str_scene + ", has already been declared." );
	
	if ( !level flag_exists( str_scene + "_started" ) )
	{
		flag_init( str_scene + "_started" );
	}
	
	if ( !level flag_exists( str_scene + "_done" ) )
	{
		flag_init( str_scene + "_done" );
	}
	
	s_scene_info = SpawnStruct();
	s_scene_info.str_scene = str_scene;
	s_scene_info.a_anim_info = [];
	
	if ( IsDefined( str_align_targetname ) )
	{
		s_scene_info.str_align_targetname = str_align_targetname;
	}
	else
	{
		s_scene_info.do_not_align = true;
	}
	
	if ( IS_TRUE( do_reach ) )
	{
		s_scene_info.do_reach = do_reach;
	}
	
	if ( IS_TRUE( do_generic ) )
	{
		s_scene_info.do_generic = do_generic;
	}
	
	if ( IS_TRUE( do_loop ) )
	{
		s_scene_info.do_loop = do_loop;
	}
	
	if ( IS_TRUE( do_not_align ) )
	{
		s_scene_info.do_not_align = do_not_align;
	}
	
	level.a_scenes[ str_scene ] = s_scene_info;
	
	level.scene_sys.str_current_scene = str_scene;
}

/@
"Name: add_scene_loop( <str_scene>, [str_align_targetname], [do_reach], [do_generic], [do_not_align] )"
"Summary: Initializes information on a new looping scene, so that animations can be later added to it. This must be called before adding any animation information for that scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene> The name of the scene"
"OptionalArg: [str_align_targetname] The targetname of struct, node or entity, that the scene is aligned to. This is required if do_reach is true or do_not_align is false."
"OptionalArg: [do_reach] A boolean to determine if the AIs in the scene needs to do a reach. Default is false."
"OptionalArg: [do_generic] A boolean to determine if the scene is 'generic'. Default is false."
"OptionalArg: [do_not_align] A boolean to determine if the scene is aligned or not. Default is false."
"Example: add_scene_loop( "rr_1", "anim_rr" );"
"SPMP: singleplayer"
@/
add_scene_loop( str_scene, str_align_targetname, do_reach, do_generic, do_not_align )
{
	add_scene( str_scene, str_align_targetname, do_reach, do_generic, true, do_not_align );
}

#using_animtree( "generic_human" );
/@
"Name: add_actor_anim( <str_animname>, <animation>, [do_hide_weapon], [do_give_back_weapon], [do_delete], [do_not_allow_death], [str_tag] )"
"Summary: Adds a new actor animation information to the most recent scene defined in add_scene(). This is for an AI."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> This is the animname or script_animname for the actor. This can also be the targetname if the scene is generic. It can also be 'generic'. If 'generic' is passed in, it is up to the scripter to pass in the asset later using add_generic_ai_to_scene()"
"MandatoryArg: <animation> The animation which this actor is going to play"
"OptionalArg: [do_hide_weapon] A boolean that hides the weapon of this actor. Default is false."
"OptionalArg: [do_give_back_weapon] A boolean that needs to be set if you want to give this AI back its weapon at the end of the scene. Default is false."
"OptionalArg: [do_delete] A boolean that needs to be set if the AI needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [do_not_allow_death] A boolean that does not allow the actor to die in the middle of its animation. Default is false."
"OptionalArg: [str_tag] The tag that the actor needs to LinkTo and the animation plays off"
"Example: add_actor_anim( "woods", %generic_human::ch_pow_b01_1d_barnes );"
"SPMP: singleplayer"
@/
add_actor_anim( str_animname, animation, do_hide_weapon, do_give_back_weapon, do_delete, do_not_allow_death, str_tag, str_spawner )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_actor_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( IsDefined( animation ), "animation is a required argument for add_actor_anim() in scene, " + level.scene_sys.str_current_scene );
	
	_basic_actor_setup( str_animname, animation, do_delete );
	
	if ( IS_TRUE( do_hide_weapon ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].do_hide_weapon = do_hide_weapon;
	}
	
	if ( IS_TRUE( do_give_back_weapon ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].do_give_back_weapon = do_give_back_weapon;
	}
	
	if ( IS_TRUE( do_not_allow_death ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].do_not_allow_death = do_not_allow_death;
	}
	
	if ( IsDefined( str_tag ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
	}
	
	if ( IsDefined( str_spawner ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_spawner = str_spawner;
	}
}

/@
	"Name: add_actor_spawner( <str_animname>, <str_spawner> )"
	"Summary: Assigns a spawner to the specified actor.
	"Module: Animation"
	"CallOn: level"
	"MandatoryArg: <str_animname> This is the animname or script_animname for the actor.
	"MandatoryArg: <str_spawner> The name of the spawner that is being assigned to this actor."
	"Example: add_actor_spawner( "attack_pmc_01", "generic_pmc_spawner" );"
	"SPMP: singleplayer"
@/
add_actor_spawner( str_animname, str_spawner )
{
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_spawner = str_spawner;
}

/@
"Name: add_optional_actor_anim( <str_animname>, <animation>, [do_hide_weapon], [do_give_back_weapon], [do_delete], [do_not_allow_death], [str_tag] )"
"Summary: Adds a new actor animation information to the most recent scene defined in add_scene(). This is for an AI. Will let the scene work with available actors if some of them are not available (dead)"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> This is the animname or script_animname for the actor. This can also be the targetname if the scene is generic. It can also be 'generic'. If 'generic' is passed in, it is up to the scripter to pass in the asset later using add_generic_ai_to_scene()"
"MandatoryArg: <animation> The animation which this actor is going to play"
"OptionalArg: [do_hide_weapon] A boolean that hides the weapon of this actor. Default is false."
"OptionalArg: [do_give_back_weapon] A boolean that needs to be set if you want to give this AI back its weapon at the end of the scene. Default is false."
"OptionalArg: [do_delete] A boolean that needs to be set if the AI needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [do_not_allow_death] A boolean that does not allow the actor to die in the middle of its animation. Default is false."
"OptionalArg: [str_tag] The tag that the actor needs to LinkTo and the animation plays off"
"Example: add_actor_anim( "woods", %generic_human::ch_pow_b01_1d_barnes );"
"SPMP: singleplayer"
@/
add_optional_actor_anim( str_animname, animation, do_hide_weapon, do_give_back_weapon, do_delete, do_not_allow_death, str_tag, str_spawner )
{
	add_actor_anim( str_animname, animation, do_hide_weapon, do_give_back_weapon, do_delete, do_not_allow_death, str_tag, str_spawner );
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].b_optional = true;
}

/@
"Name: add_multiple_generic_actors( <str_name>, <animation>, [do_hide_weapon], [do_give_back_weapon], [do_delete], [do_not_allow_death] )"
"Summary: Adds a new actor animation information to the most recent scene defined in add_scene(). This is for an AI."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_name> This can be a targetname of a spawner or the word 'generic'. If 'generic' is passed in, it is up to the scripter to pass in the asset later using add_generic_ai_to_scene()"
"MandatoryArg: <animation> The animation which this actor is going to play"
"OptionalArg: [do_hide_weapon] A boolean that hides the weapon of this actor. Default is false."
"OptionalArg: [do_give_back_weapon] A boolean that needs to be set if it is a looped animation. Default is false."
"OptionalArg: [do_delete] A boolean that needs to be set if the AI needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [do_not_allow_death] A boolean that does not allow the actor to die in the middle of its animation. Default is false."
"Example: add_multiple_generic_actors( "ai_no_align", %generic_human::ch_scripted_tests_b0_ice_slip );"
"SPMP: singleplayer"
@/
add_multiple_generic_actors( str_name, animation, do_hide_weapon, do_give_back_weapon, do_delete, do_not_allow_death )
{
	Assert( IsDefined( str_name ), "str_name is a required argument for add_actor_generic_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( IsDefined( animation ), "animation is a required argument for add_actor_generic_anim() in scene, " + level.scene_sys.str_current_scene );

	add_actor_anim( str_name, animation, do_hide_weapon, do_give_back_weapon, do_delete, do_not_allow_death );
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_name ].has_multiple_ais = true;
}

/@
"Name: add_actor_model_anim( <str_animname>, <animation>, [str_model], [do_delete], [str_tag], [a_parts] )"
"Summary: Adds a new actor animation information to the most recent scene defined in add_scene(). This is for any model that has their animation in generic_human."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> This is the animname for the model"
"MandatoryArg: <animation> The animation which this model is going to play"
"OptionalArg: [str_model] The name of the model"
"OptionalArg: [do_delete] A boolean that needs to be set if the model needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [str_tag] The tag that the model needs to LinkTo and the animation plays off"
"OptionalArg: [a_parts] An array of string tag names that you want to hide on the model. If only one tag is needed to be hidden, you can pass in a single string instead of an array."
"OptionalArg: [str_spawner] Specify a specific AI spawner to get the model from -- AIs ONLY"
"Example: add_actor_model_anim( "woods_model", %generic_human::crew_truck_guy1_sit_idle, "c_usa_jungmar_barnes_pris_fb", undefined, false, "tag_guy8" );"
"SPMP: singleplayer"
@/
add_actor_model_anim( str_animname, animation, str_model, do_delete, str_tag, a_parts, str_spawner )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_actor_model_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( IsDefined( animation ), "animation is a required argument for add_actor_model_anim() in scene, " + level.scene_sys.str_current_scene );
	
	if ( !IsArray( a_parts ) )
	{
		a_parts = array( a_parts );
	}
	
	_basic_actor_setup( str_animname, animation, do_delete );

	if ( IsDefined( str_model ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_model = str_model;
	}
	
	if ( IsDefined( a_parts ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].a_parts = a_parts;
	}
	
	if ( IsDefined( str_tag ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
	}
	
	if ( IsDefined( str_spawner ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_spawner = str_spawner;
	}
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].is_model = true;
}

/*==============================================================
SELF: level
PURPOSE: Initializes information that is common among all actor
		 animations. This is where the information gets added to
		 the array of anim info for that scene.
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_basic_actor_setup( str_name, animation, do_delete )
{
	Assert( !IsDefined( level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_name ] ), "Actor, " + str_name + ", has already been declared for the scene, " + level.scene_sys.str_current_scene );

	s_actor = SpawnStruct();
	s_actor.str_name = str_name;
	s_actor.animation = animation;
	s_actor.anim_tree = #animtree;
	
	if ( IS_TRUE( do_delete ) )
	{
		s_actor.do_delete = do_delete;
	}
	
	s_actor _add_anim_to_current_scene();
}

#using_animtree( "animated_props" );
/@
"Name: add_prop_anim( <str_animname>, <animation>, [str_model], [do_delete], [is_simple_prop], [a_parts], [str_tag] )"
"Summary: Adds a new prop animation information to the most recent scene defined in add_scene(). This is for any model that needs to be animated except for actor, weapon, or player models."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> This is the animname for the model. If the model is in Radiant, str_animname should be the same as the kvp, script_animname"
"MandatoryArg: <animation> The animation which this model is going to play"
"OptionalArg: [str_model] The name of the model. This is required if the model is not in Radiant or if it will not be spawned by the system somewhere else."
"OptionalArg: [do_delete] A boolean that needs to be set if the model needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [is_simple_prop] A boolen that needs to be set if the model is a simple prop. Default is false."
"OptionalArg: [a_parts] An array of string tag names that you want to hide on the model. If only one tag is needed to be hidden, you can pass in a single string instead of an array."
"OptionalArg: [str_tag] The tag that the model needs to LinkTo and the animation plays off"
"Example: add_prop_anim( "chair", %animated_props::o_pow_b01_1b_otherchair, "anim_jun_chair_01" );"
"SPMP: singleplayer"
@/
add_prop_anim( str_animname, animation, str_model, do_delete, is_simple_prop, a_parts, str_tag, b_connect_paths )
{
	if ( !IsArray( a_parts ) )
	{
		a_parts = array( a_parts );
	}
	
	_basic_prop_setup( str_animname, animation, do_delete, is_simple_prop, "add_prop_anim()" );
	
	if ( IsDefined( str_model ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_model = str_model;
	}
	
	if ( IsDefined( a_parts ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].a_parts = a_parts;
	}
	
	if ( IsDefined( str_tag ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
	}
	
	if ( IS_TRUE( b_connect_paths ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].b_connect_paths = true;
	}
}

/@
"Name: add_multiple_generic_props_from_radiant( <str_animname>, <animation>, [do_delete], [is_simple_prop], [a_parts] )"
"Summary: Adds a new animation information for multiple props to the most recent scene defined in add_scene(). This is for any models that need to be animated except for actor, weapon, or player models."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> This is the targetname for the models"
"MandatoryArg: <animation> The animation which this model is going to play"
"OptionalArg: [do_delete] A boolean that needs to be set if the model needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [is_simple_prop] A boolen that needs to be set if the model is a simple prop. Default is false."
"OptionalArg: [a_parts] An array of string tag names that you want to hide on the model. If only one tag is needed to be hidden, you can pass in a single string instead of an array."
"Example: add_multiple_generic_props_from_radiant( "shovel_name", %animated_props::o_pow_b01_1d_pipe );"
"SPMP: singleplayer"
@/
add_multiple_generic_props_from_radiant( str_name, animation, do_delete, is_simple_prop, a_parts )
{		
	if ( !IsArray( a_parts ) )
	{
		a_parts = array( a_parts );
	}
	
	_basic_prop_setup( str_name, animation, do_delete, is_simple_prop, "add_multiple_props_from_radiant" );
	
	if ( IsDefined( a_parts ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_name ].a_parts = a_parts;
	}
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_name ].has_multiple_props = true;
}

/@
"Name: add_weapon_anim( <str_animname>, <animation>, <str_weapon_name>, [do_delete], [is_simple_prop], [str_tag] )"
"Summary: Adds a new weapon animation information to the most recent scene defined in add_scene(). This is for any weapon model that needs to be animated."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname for the weapon model."
"MandatoryArg: <animation> The animation which this model is going to play"
"MandatoryArg: <str_weapon_name> The name of the weapon"
"OptionalArg: [do_delete] A boolean that needs to be set if the model needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [is_simple_prop] A boolen that needs to be set if the model is a simple prop. Default is false."
"OptionalArg: [str_tag] The tag that the model needs to LinkTo and the animation plays off"
"Example: add_weapon_anim( "m16_weapon", %animated_props::o_pow_b01_1d_cleaver, "m16_ir_sp" );"
"SPMP: singleplayer"
@/
add_weapon_anim( str_animname, animation, str_weapon_name, do_delete, is_simple_prop, str_tag )
{
	Assert( IsDefined( str_weapon_name ), "str_weapon_name is a required argument for add_weapon_anim() in scene, " + level.scene_sys.str_current_scene );
	
	str_model = GetWeaponModel( str_weapon_name );
	
	_basic_prop_setup( str_animname, animation, do_delete, is_simple_prop, "add_weapon_anim()" );
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_model = str_model;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_weapon_name = str_weapon_name;
	
	if ( IsDefined( str_tag ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
	}
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].is_weapon = true;
}

/*==============================================================
SELF: level
PURPOSE: Initializes information that is common among all prop
		 animations. This is where the information gets added to
		 the array of anim info for that scene.
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_basic_prop_setup( str_animname, animation, do_delete, is_simple_prop, str_function_name, animtree )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for " + str_function_name + " in scene, " + level.scene_sys.str_current_scene );
	Assert( IsDefined( animation ), "animation is a required argument for " + str_function_name + " in scene, " + level.scene_sys.str_current_scene );
	Assert( !IsDefined( level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ] ), "Prop, " + str_animname + ", has already been declared for the scene, " + level.scene_sys.str_current_scene );
	
	s_prop_anim = SpawnStruct();
	s_prop_anim.str_name = str_animname;
	s_prop_anim.animation = animation;

	if ( IS_TRUE( do_delete ) )
	{
		s_prop_anim.do_delete = do_delete;
	}
	
	if ( IS_TRUE( is_simple_prop ) )
	{
		s_prop_anim.is_simple_prop = is_simple_prop;
	}
	
	if ( IsDefined( animtree ) )
	{
		s_prop_anim.anim_tree = animtree;
	}
	else
	{
		s_prop_anim.anim_tree = #animtree;
	}
	
	s_prop_anim.is_model = true;
	
	s_prop_anim _add_anim_to_current_scene();
}

#using_animtree( "player" );
/@
"Name: add_player_anim( <str_animname>, <animation>, [do_delete], [n_player_number = 0], [str_tag], [do_delta = false], [n_view_fraction = 1], [n_right_arc = 180], [n_left_arc = 180], [n_top_arc = 180], [n_bottom_arc = 180], [use_tag_angles = true], [b_auto_center] )"
"Summary: Adds a new player animation information to the most recent scene defined in add_scene()."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname for this player model"
"MandatoryArg: <animation> The animation which this model is going to play"
"OptionalArg: [do_delete] A boolean that needs to be set if the model needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [n_player_number] Represents player that this animation is for. Default is 0."
"OptionalArg: [str_tag] The tag to attach the player to"
"OptionalArg: [do_delta] A boolean that needs to be set if you want to use PlayerLinkToDelta. Default is false."
"OptionalArg: [n_view_fraction] How much the change in the tag's rotation effects the players view. Defaults to 0."
"OptionalArg: [n_right_arc] Angle to clamp view to the right. Defaults to 180."
"OptionalArg: [n_left_arc] Angle to clamp view to the left. Defaults to 180."
"OptionalArg: [n_top_arc] Angle to clamp view to the top. Defaults to 180."
"OptionalArg: [n_bottom_arc] Angle to clamp view to the bottom. Defaults to 180."
"OptionalArg: [use_tag_angles] Determines how the player's view will be tilted. 'False' means that the orientation of the tag when the player is linked will appear flat to the player. Any rotation from that orientation will tilt the player's view. 'True' means that only a tag angles of (0,0,0) will appear flat to the player. Any rotation from (0,0,0) will tilt the player's view."
"OptionalArg: [b_auto_center] Auto center the camera to the animation when using delta."
"OptionalArg: [b_use_camera_tween] Use camera tween when linking player to body model."
"Example: add_player_anim( "player_body", %player::int_pow_b01_1b );"
"SPMP: singleplayer"
@/
add_player_anim( str_animname, animation, do_delete, n_player_number = 0, str_tag, do_delta = false, n_view_fraction = 1, n_right_arc = 180, n_left_arc = 180, n_top_arc = 180, n_bottom_arc = 180, use_tag_angles = true, b_auto_center = true, b_use_camera_tween )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_player_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( IsDefined( animation ), "animation is a required argument for add_player_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( !IsDefined( level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ] ), "Player model, " + str_animname + ", has already been declared for the scene, " + level.scene_sys.str_current_scene );

	s_player = SpawnStruct();
	s_player.str_name = str_animname;
	s_player.animation = animation;
	s_player.anim_tree = #animtree;
	s_player.n_player_number = n_player_number;
	
	if ( IsDefined( str_tag ) )
	{
		s_player.str_tag = str_tag;
	}
	
	if ( IS_TRUE( do_delete ) )
	{
		s_player.do_delete = do_delete;
	}
	
	if ( IS_TRUE( do_delta ) )
	{
		s_player.do_delta = do_delta;
	}
	
	if ( IS_TRUE( b_use_camera_tween ) )
	{
		s_player.b_use_camera_tween = b_use_camera_tween;
	}
	
	s_player.n_view_fraction = n_view_fraction;
	s_player.n_right_arc = n_right_arc;
	s_player.n_left_arc = n_left_arc;
	s_player.n_top_arc = n_top_arc;
	s_player.n_bottom_arc = n_bottom_arc;
	s_player.use_tag_angles = use_tag_angles;
	s_player.b_auto_center = b_auto_center;
	s_player.is_model = true;
	
	s_player _add_anim_to_current_scene();
}

#using_animtree( "vehicles" );
/@
"Name: add_vehicle_anim( <str_animname>, <animation>, [do_delete], [a_parts], [str_tag], [b_animate_origin], [str_vehicletype], [str_model], [str_destructibledef] )"
"Summary: Adds a new vehicle animation information to the most recent scene defined in add_scene()."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> This is the animname for the model. If the model is in Radiant, str_animname should be the same as the kvp, script_animname"
"MandatoryArg: <animation> The animation which this model is going to play"
"OptionalArg: [do_delete] A boolean that needs to be set if the model needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [a_parts] An array of string tag names that you want to hide on the model. If only one tag is needed to be hidden, you can pass in a single string instead of an array."
"OptionalArg: [str_tag] The tag that the model needs to LinkTo and the animation plays off"
"OptionalArg: [b_animate_origin] Set to false if the vehicles origin is not animated (on a spline, etc.)"
"OptionalArg: [str_vehicletype] Specify the vehicle type if not using a vehicle spawner"
"OptionalArg: [str_model] Specify the model if not using a vehicle spawner"
"OptionalArg: [str_destructibledef] Optionally specify the destructibledef if not using a vehicle spawner"
"Example: add_vehicle_anim( "intro_drone", %vehicle::v_la_03_04_cougarfalls_f35intro_drone );"
"SPMP: singleplayer"
@/
add_vehicle_anim( str_animname, animation, do_delete, a_parts, str_tag, b_animate_origin, str_vehicletype, str_model, str_destructibledef, do_not_allow_death )
{
	if ( !IsArray( a_parts ) )
	{
		a_parts = array( a_parts );
	}
	
	_basic_prop_setup( str_animname, animation, do_delete, false, "add_vehicle_anim()", #animtree );
	
	if ( IsDefined( a_parts ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].a_parts = a_parts;
	}
	
	if ( IsDefined( str_tag ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
	}
	
	if ( IsDefined( str_vehicletype ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_vehicletype = str_vehicletype;
	}
	
	if ( IsDefined( str_model ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_model = str_model;
	}
	
	if ( IsDefined( str_destructibledef ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_destructibledef = str_destructibledef;
	}
	
	if ( IS_TRUE( do_not_allow_death ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].do_not_allow_death = do_not_allow_death;
	}
	
	if ( IsDefined( b_animate_origin ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].b_animate_origin = b_animate_origin;
	}
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].is_vehicle = true;
}

/*==============================================================
SELF: NA
PURPOSE: Spawns and initializes a vehicle for animation.
RETURNS: NA
CREATOR: BrianB (9/21/2011)
===============================================================*/
_spawn_vehicle_for_anim()
{
	veh = SpawnVehicle( self.str_model, self.str_name, self.str_vehicletype, ( 0, 0 ,0 ), ( 0, 0 ,0 ), self.str_destructibledef );
	maps\_vehicle::vehicle_init( veh );
	return veh;
}

/@
"Name: set_vehicle_unusable_in_scene( <str_animname> )"
"Summary: Sets the vehicle that is to be animated as non-usable"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> This is the animname for the model. If the model is in Radiant, str_animname should be the same as the kvp, script_animname"
"Example: set_vehicle_unusable_in_scene( "zhao_horse" );"
"SPMP: singleplayer"
@/
set_vehicle_unusable_in_scene( str_animname )
{
	if( IsDefined(level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ]) )
	{
	   	if(IS_TRUE(level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].is_vehicle))
	   	{
	   		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].not_usable = true;
	   	}
	   	else
	   	{
	   		Assert( false, "Non vehicle made unusable in scene: " + level.scene_sys.str_current_scene + " with animname: " + str_animname );
	   	}
	}
	else
	{
		Assert( false, "Couldn't find vehicle in scene: " + level.scene_sys.str_current_scene + " with animname: " + str_animname );
	}
		
		
}

#using_animtree( "horse" );
/@
"Name: add_horse_anim( <str_animname>, <animation>, [do_delete], [a_parts], [str_tag], [b_animate_origin] )"
"Summary: Adds a new horse animation information to the most recent scene defined in add_scene()."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> This is the animname for the model. If the model is in Radiant, str_animname should be the same as the kvp, script_animname"
"MandatoryArg: <animation> The animation which this model is going to play"
"OptionalArg: [do_delete] A boolean that needs to be set if the model needs to be deleted at the end of the scene. Default is false."
"OptionalArg: [a_parts] An array of string tag names that you want to hide on the model. If only one tag is needed to be hidden, you can pass in a single string instead of an array."
"OptionalArg: [str_tag] The tag that the model needs to LinkTo and the animation plays off"
"OptionalArg: [b_animate_origin] Set to false if the vehicles origin is not animated (on a spline, etc.)"
"Example: add_horse_anim( "muj_horse_1", %horse::ch_af_01_05_horse4 );"
"SPMP: singleplayer"
@/
add_horse_anim( str_animname, animation, do_delete, a_parts, str_tag, b_animate_origin )
{
	if ( !IsArray( a_parts ) )
	{
		a_parts = array( a_parts );
	}

	_basic_prop_setup( str_animname, animation, do_delete, false, "add_horse_anim()", #animtree );
	
	if ( IsDefined( a_parts ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].a_parts = a_parts;
	}
	
	if ( IsDefined( str_tag ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
	}
	
	if ( IS_TRUE( b_animate_origin ) )
	{
		level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].b_animate_origin = b_animate_origin;
	}
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].is_vehicle = true;
}

/@
"Name: add_notetrack_attach( <str_animname>, <str_notetrack>, <str_model>, [str_tag], [b_any_scene] )"
"Summary: Attaches a model on the specified tag when the notetrack is hit"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname of an entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <str_model> The name of the model"
"OptionalArg: [str_tag] The tag that this model is going to be attached to"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_attach( "woods", "binoc_attach", "viewmodel_binoculars", "TAG_WEAPON_LEFT" );"
"SPMP: singleplayer"
@/
add_notetrack_attach( str_animname, str_notetrack, str_model, str_tag, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_attach()" );
	Assert( IsDefined( str_model ), "str_model is a required argument for add_notetrack_attach()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_attach( str_animname, str_notetrack, str_model, str_tag, str_scene );
}

/@
"Name: add_notetrack_detach( <str_animname>, <str_notetrack>, <str_model>, [str_tag], [b_any_scene] )"
"Summary: Detaches a model on the specified tag when the notetrack is hit"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname of an entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <str_model> The name of the model"
"OptionalArg: [str_tag] The tag that this model is going to be detach from"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_detach( "krav", "detach_radio", "t5_weapon_radio_world", "TAG_WEAPON_LEFT" );"
"SPMP: singleplayer"
@/
add_notetrack_detach( str_animname, str_notetrack, str_model, str_tag, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_detach()" );
	Assert( IsDefined( str_model ), "str_model is a required argument for add_notetrack_detach()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_detach( str_animname, str_notetrack, str_model, str_tag, str_scene );
}

/@
"Name: add_notetrack_level_notify( <str_animname>, <str_notetrack>, <str_notify>, [b_any_scene] )"
"Summary: Sends a level notify when the notetrack is hit"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname of an entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <str_notify> Level notify to send when notetrack is hit"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_level_notify( "krav", "do_fxanim", "fxanim_start", "my_scene" );"
"SPMP: singleplayer"
@/
add_notetrack_level_notify( str_animname, str_notetrack, str_notify, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_level_notify()" );
	Assert( IsDefined( str_notify ), "str_notify is a required argument for add_notetrack_level_notify()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_level_notify( str_animname, str_notetrack, str_notify, str_scene );
}

/@
"Name: add_notetrack_custom_function( <str_animname>, <str_notetrack>, <func_pointer>, [b_any_scene] )"
"Summary: Makes the function run when this notetrack is hit"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <func_pointer> The function to call when this notetrack is hit"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"OptionalArg: [passNote] A boolean defaulted to false. If set, function is passed additional parameter back which is the notetrack"
"Example: add_notetrack_custom_function( "bowman", "hit", ::bowman_head_bleed_start );"
"SPMP: singleplayer"
@/
add_notetrack_custom_function( str_animname, str_notetrack, func_pointer, b_any_scene, passNote = false )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_custom_function()" );
	Assert( IsDefined( func_pointer ), "func_pointer is a required argument for add_notetrack_custom_function()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_customFunction( str_animname, str_notetrack, func_pointer, str_scene, passNote );
}

/@
"Name: add_notetrack_exploder( <str_animname>, <str_notetrack>, <n_exploder>, [b_any_scene] )"
"Summary: Starts the specified exploder when this notetrack is hit"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <n_exploder> The exploder number"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_exploder( "crash_heli", "heli_explode", 323 );"
"SPMP: singleplayer"
@/
add_notetrack_exploder( str_animname, str_notetrack, n_exploder, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_exploder()" );
	Assert( IsDefined( n_exploder ), "n_exploder is a required argument for add_notetrack_exploder()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_exploder( str_animname, str_notetrack, n_exploder, str_scene );
}

/@
"Name: add_notetrack_stop_exploder( <str_animname>, <str_notetrack>, <n_exploder>, [b_any_scene] )"
"Summary: Stops the specified exploder when this notetrack is hit"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <n_exploder> The exploder number"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_stop_exploder( "door", "snow_fx_off", 600 );"
"SPMP: singleplayer"
@/
add_notetrack_stop_exploder( str_animname, str_notetrack, n_exploder, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_stop_exploder()" );
	Assert( IsDefined( n_exploder ), "n_exploder is a required argument for add_notetrack_stop_exploder()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_stop_exploder( str_animname, str_notetrack, n_exploder, str_scene ); 
}

/@
"Name: add_notetrack_flag( <str_animname>, <str_notetrack>, <str_flag>, [b_any_scene] )"
"Summary: Sets the specified flag when this notetrack is hit"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <str_flag> The flag that will be set"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_flag( "kennedy", "start_bloom", "notetrack_start_bloom" );"
"SPMP: singleplayer"
@/
add_notetrack_flag( str_animname, str_notetrack, str_flag, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_flag()" );
	Assert( IsDefined( str_flag ), "str_flag is a required argument for add_notetrack_flag()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	if ( !level flag_exists( str_flag ) )
	{
		flag_init( str_flag );
	}
	
	addNotetrack_flag( str_animname, str_notetrack, str_flag, str_scene );
}

/@
"Name: add_notetrack_fov( <str_animname>, <str_notetrack>, [b_any_scene] )"
"Summary: Switches the FOV based on notetrack"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_fov( "player_body", "fov_40" );"
"SPMP: singleplayer"
@/
add_notetrack_fov( str_animname, str_notetrack, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_fov()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_fov( str_animname, str_notetrack, str_scene );
}

/@
"Name: add_notetrack_fov_new( <str_animname>, <str_notetrack>, [b_any_scene] )"
"Summary: Switches the FOV based on notetrack"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_fov( "player_body", "fov_40" );"
"SPMP: singleplayer"
@/
add_notetrack_fov_new( str_animname, str_notetrack, n_fov, n_time, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_fov()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_fov_new( str_animname, str_notetrack, n_fov, n_time, b_any_scene );
}

/@
"Name: add_notetrack_fx_on_tag( <str_animname>, <str_notetrack>, <str_effect>, <str_tag>, [b_on_threader] )"
"Summary: Plays an effect on the specified tag when this notetrack is hit"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <str_effect> The name of the effect"
"MandatoryArg: <str_tag> The tag that the effect is going to play off on"
"OptionalArg: [b_on_threader] Default behavior, is play the FX on the ent playing the anim, not the ent that is threading the anim call"
"Example: add_notetrack_fx_on_tag( "bowman", "hit", "bowman_head_hit", "j_head" );"
"SPMP: singleplayer"
@/
add_notetrack_fx_on_tag( str_animname, str_notetrack, str_effect, str_tag, b_on_threader, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_fx_on_tag()" );
	Assert( IsDefined( str_effect ), "str_effect is a required argument for add_notetrack_fx_on_tag()" );
	Assert( IsDefined( str_tag ), "str_tag is a required argument for add_notetrack_fx_on_tag()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_FXOnTag( str_animname, str_scene, str_notetrack, str_effect, str_tag, b_on_threader );
}

/@
"Name: add_notetrack_sound( <str_animname>, <str_notetrack>, <str_soundalias>, [b_any_scene] )"
"Summary: Plays the specified sound alias when this notetrack is hit"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <str_soundalias> The name of the soundalias"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_sound( "hiding_door_guy", "sound_door_death", "scn_doorpeek_door_open_death" );"
"SPMP: singleplayer"
@/
add_notetrack_sound( str_animname, str_notetrack, str_soundalias, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_sound()" );
	Assert( IsDefined( str_soundalias ), "str_soundalias is a required argument for add_notetrack_sound()" );
	
	str_scene = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_sound( str_animname, str_notetrack, str_scene, str_soundalias );
}

/@
"Name: is_scene_defined( <str_scene> )"
"Summary: Checks to see if a scene is defined"
"Module: Animation"
"MandatoryArg: <str_scene> The name of the scene to check"
"Example: is_scene_defined( "worker_idle" );"
"SPMP: singleplayer"
@/
is_scene_defined( str_scene )
{
	Assert( IsDefined( str_scene ), "str_scene is a required argument for is_scene_defined()" );

	if ( IsDefined( level.a_scenes[ str_scene ] ) )
    {
	    return true;
	}
    else
    {
    	return false;
    }
}


/*==============================================================
SELF: level
PURPOSE: Determine if this notetrack is for a specific scene or
		 any scene in the level
RETURNS: The name of the current scene or undefined if it is for
		 any scene in the level
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_get_scene_name_for_notetrack( b_any_scene = false )
{
	if ( !IsString( b_any_scene ) )
	{
		if ( !b_any_scene )
		{
			return level.scene_sys.str_current_scene;
		}
	}
	else
	{
		return b_any_scene;
	}
}

/*==============================================================
SELF: level
PURPOSE: Determine if this animname needs to be 'generic'
RETURNS: The animname that was passed in or 'generic'
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_get_animname_for_notetrack( str_animname )
{
	str_scene = level.scene_sys.str_current_scene;
	
	// Make the animname to 'generic' if the scene is generic
	if ( IS_TRUE( level.a_scenes[ str_scene ].do_generic ) )
	{
		str_animname = "generic";
	}
	
	return str_animname;
}

/*==============================================================
SELF: level
PURPOSE: Set up notetrack handling for some things to be handled
automatically with notetrack keywords
RETURNS: NA
CREATOR: BrianB (09/15/2011)
===============================================================*/
_preprocess_notetracks( str_scene )
{
	str_scene = level.scene_sys.str_current_scene;
	waittill_asset_loaded( "xanim", string( self.animation ) );
	
	notetracks = GetNotetracksInDelta( self.animation, .5, 9999 );
	n_anim_length = GetAnimLength( self.animation );
	
	a_fov = [];
	
	foreach ( info in notetracks )
	{
		str_notetrack = info[1];
		str_notetrack_no_comment = StrTok( str_notetrack, "#" )[0];	// strip out comment
		a_tokens = StrTok( str_notetrack_no_comment, " " );
		
		n_notetrack_time = linear_map( info[2], 0, 1, 0, n_anim_length ); // convert normalized time to real time
		
		switch ( a_tokens[0] )
		{
			case "exploder":
				
				n_exploder = Int( a_tokens[1] );
				add_notetrack_exploder( self.str_name, str_notetrack, n_exploder, true );
				
				break;
				
			case "stop_exploder":
				
				n_exploder = Int( a_tokens[1] );
				add_notetrack_stop_exploder( self.str_name, str_notetrack, n_exploder, true );
				
				break;
				
			case "timescale":
				
				if ( IsDefined( a_tokens[1] ) )
				{
					switch ( a_tokens[1] )
					{
							case "slow":
								
								add_notetrack_custom_function( self.str_name, str_notetrack, ::_scene_time_scale_slow, true );
							
								break;
								
							case "med":
								
								add_notetrack_custom_function( self.str_name, str_notetrack, ::_scene_time_scale_med, true );
							
								break;
								
							case "fast":
								
								add_notetrack_custom_function( self.str_name, str_notetrack, ::_scene_time_scale_fast, true );
							
								break;
	
							case "off":
									
								add_notetrack_custom_function( self.str_name, str_notetrack, ::_scene_time_scale_off, true );
							
								break;
					}
				}
				
				break;
				
			case "rumble":
				
				if ( IsDefined( a_tokens[1] ) )
				{
					switch ( a_tokens[1] )
					{
							case "light":
								
								add_notetrack_custom_function( self.str_name, str_notetrack, ::_scene_rumble_light, true );
							
								break;
								
							case "med":
								
								add_notetrack_custom_function( self.str_name, str_notetrack, ::_scene_rumble_med, true );
							
								break;
								
							case "heavy":
								
								add_notetrack_custom_function( self.str_name, str_notetrack, ::_scene_rumble_heavy, true );
							
								break;
					}
				}
				
				break;
				
			case "fov":
				
				if ( IsDefined( a_tokens[1] ) )
				{
					if ( a_tokens[1] == "reset" )
					{
						a_tokens[1] = -1;
					}
					
					ARRAY_ADD( a_fov, array( str_notetrack, Float( a_tokens[1] ), Float( n_notetrack_time ) ) );
				}
				
				break;
		}
	}
	
	if ( a_fov.size > 0 )
	{
		_preprocess_fov_notetracks( a_fov, str_scene );
	}
}

/*
_add_notetrack_func( str_name, str_scene, str_notetrack, func, arg1, arg2, arg3, arg4, arg5 )
{
	if ( !IsDefined( level.scene_sys.notetracks ) )
	{
		level.scene_sys.notetracks = [];
	}
	
	if ( !IsDefined( level.scene_sys.notetracks[ str_name ] ) )
	{
		level.scene_sys.notetracks[ str_name ] = [];
	}
	
	if ( !IsDefined( level.scene_sys.notetracks[ str_name ][ str_scene ] ) )
	{
		level.scene_sys.notetracks[ str_name ][ str_scene ] = [];
	}
	
	if ( !IsDefined( level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ] ) )
	{
		level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ] = [];
	}
	
	n_size = level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ].size;
	
	level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ][ n_size ] = SpawnStruct();	
	level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ][ n_size ].func = func;
	level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ][ n_size ].arg1 = arg1;
	level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ][ n_size ].arg2 = arg2;
	level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ][ n_size ].arg3 = arg3;
	level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ][ n_size ].arg4 = arg4;
	level.scene_sys.notetracks[ str_name ][ str_scene ][ str_notetrack ][ n_size ].arg5 = arg5;
}

_process_notetracks( str_scene, do_loop )
{
	self endon( "death" );
	
	self notify( "stop_sequencing_notetracks" );
	self endon( "stop_sequencing_notetracks" );
	
	str_anim_flag = ( do_loop ? "looping anim" : "single anim" );
	str_notetrack = "start";
	
	while ( true )
	{
		
		
		self waittill( str_anim_flag, str_notetrack );
	}
}
*/

_preprocess_fov_notetracks( a_fov, str_scene )
{
	for ( i = a_fov.size - 1; i >= 0; i-- )
	{
		n_time_prev = 0;
		
		if ( IsDefined( a_fov[ i - 1 ] ) )
		{
			str_notetrack = a_fov[ i - 1 ][0];
			n_time_prev = a_fov[ i - 1 ][2];
		}
		else
		{
			str_notetrack = "start";
		}
			
		n_fov = a_fov[ i ][1];	// transitioning to next fov value
		n_time = a_fov[ i ][2] - n_time_prev;	// transition time will be the delta between current time and next fov time
			
		add_notetrack_fov_new( self.str_name, str_notetrack, n_fov, n_time, str_scene );
	}
}

_scene_time_scale_slow( e_scene_object )
{
	timescale_tween( .2, .4, .5 );
}

_scene_time_scale_med( e_scene_object )
{
	timescale_tween( .4, .7, .5 );
}

_scene_time_scale_fast( e_scene_object )
{
	timescale_tween( .7, .9, .5 );
}

_scene_time_scale_off( e_scene_object )
{
	timescale_tween( undefined, 1, .5 );
}

_scene_rumble_light( e_scene_object )
{
	e_scene_object PlayRumbleOnEntity( "anim_light" );
}

_scene_rumble_med( e_scene_object )
{
	e_scene_object PlayRumbleOnEntity( "anim_med" );
}

_scene_rumble_heavy( e_scene_object )
{
	e_scene_object PlayRumbleOnEntity( "anim_heavy" );
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Dev Menu Testing
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/#
autoexec run_scene_tests()
{
	while ( true )
	{
		str_scene = GetDvar( "run_scene");
		if ( str_scene != "" )
		{
			SetDvar( "run_scene", "" );
			
			level thread run_scene( str_scene, 0, true );
		}
		
		WAIT_FRAME;
	}
}

autoexec toggle_scene_menu()
{
	SetDvar( "scene_menu", 0 );
	
	b_displaying_menu = false;
	
	while ( true )
	{
		b_scene_menu = GetDvarIntDefault( "scene_menu", 0 );
				
		if ( b_scene_menu )
		{
			if ( !b_displaying_menu )
			{
				level thread display_scene_menu();
				b_displaying_menu = true;
			}
		}
		else
		{
			level notify( "scene_menu_cleanup" );
			b_displaying_menu = false;
		}
		
		wait .5;
	}
}

create_scene_hud( skipto, index )
{
	alpha = 1;
	color = ( 0.9, 0.9, 0.9 );
	if ( index != -1 )
	{
		const middle = 5;
		if ( index != middle )
		{
			alpha = 1 - ( abs( middle - index ) / middle );
		}
	}

	if ( alpha == 0 )
	{
		alpha = 0.05;
	}

	hudelem = NewDebugHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "middle";
	hudelem.x = 80;
	hudelem.y = 80 + index * 18;
	hudelem SetText( skipto );
	hudelem.alpha = 0;
	hudelem.foreground = true;
	hudelem.color = color;

	hudelem.fontScale = 1.75;
	hudelem FadeOverTime( 0.5 );
	hudelem.alpha = alpha;
	return hudelem;
}

display_scene_menu()
{
	if ( !IsDefined( level.a_scenes ) || level.a_scenes.size <= 0 )
		return;
	
	level endon( "scene_menu_cleanup" );
	
	SetSavedDvar( "hud_drawhud", 1 );

	names = GetArrayKeys( level.a_scenes );
	names[ names.size ] = "exit";

	elems = scene_list_menu();
	
	// Available skiptos:
	title = create_scene_hud( "Selected Scenes:", -1 );
	title.color = ( 1, 1, 1 );
	
	a_selected_scenes = [];

	foreach ( str_scene, _ in level.a_scenes )
	{
		if ( flag( str_scene + "_started" ) )
		{
			ARRAY_ADD( a_selected_scenes, str_scene );
		}
	}

	selected = 0;
	up_pressed = false;
	down_pressed = false;
	
	scene_list_settext( elems, names, selected, a_selected_scenes );
	old_selected = selected;
	
	level thread scene_menu_cleanup( elems, title );
	
	while ( true )
	{
		scene_list_settext( elems, names, selected, a_selected_scenes );
		
		if ( !up_pressed )
		{
			if ( get_players()[0] ButtonPressed( "UPARROW" ) || get_players()[0] ButtonPressed( "DPAD_UP" ) )
			{
				up_pressed = true;
				selected--;
			}
		}
		else
		{
			if ( !get_players()[0] ButtonPressed( "UPARROW" ) && !get_players()[0] ButtonPressed( "DPAD_UP" ) )
			{
				up_pressed = false;
			}
		}

		if ( !down_pressed )
		{
			if ( get_players()[0] ButtonPressed( "DOWNARROW" ) || get_players()[0] ButtonPressed( "DPAD_DOWN" ) )
			{
				down_pressed = true;
				selected++;
			}
		}
		else
		{
			if ( !get_players()[0] ButtonPressed( "DOWNARROW" ) && !get_players()[0] ButtonPressed( "DPAD_DOWN" ) )
			{
				down_pressed = false;
			}
		}

		if ( selected < 0 )
		{
			selected = names.size - 1;
		}

		if ( selected >= names.size )
		{
			selected = 0;
		}

		if ( get_players()[0] ButtonPressed( "BUTTON_B" ) )
		{
			exit_scene_menu();
		}

		if ( get_players()[0] ButtonPressed( "kp_enter" ) || get_players()[0] ButtonPressed( "BUTTON_A" ) || get_players()[0] ButtonPressed( "enter" ) )
		{
			if ( names[ selected ] == "exit" )
			{
				exit_scene_menu();
			}
			else if ( IsInArray( a_selected_scenes, names[ selected ] ) )
			{
				ArrayRemoveValue( a_selected_scenes, names[ selected ] );
				if ( !is_scene_deleted( names[ selected ] ) )
				{
					delete_scene_all( names[ selected ], false, true );
				}
			}
			else
			{
				if ( !is_scene_deleted( names[ selected ] ) )
				{
					ARRAY_ADD( a_selected_scenes, names[ selected ] );
					SetDvar( "run_scene", names[ selected ] );
				}
			}
			
			while ( get_players()[0] ButtonPressed( "kp_enter" ) || get_players()[0] ButtonPressed( "BUTTON_A" ) || get_players()[0] ButtonPressed( "enter" ) )
			{
				WAIT_FRAME;
			}
		}
		
		WAIT_FRAME;
	}
}

exit_scene_menu()
{
	SetDvar( "scene_menu", 0 );
	level notify( "scene_menu_cleanup" );
}

scene_list_menu()
{
	hud_array = [];
	for ( i = 0; i < 11; i++ )
	{
		hud = create_scene_hud( "", i );
		hud_array[ hud_array.size ] = hud;
	}

	return hud_array;
}

// handles the updating of the skipto menu selection(s)
scene_list_settext( hud_array, strings, num, a_selected_scenes )
{
	for ( i = 0; i < hud_array.size; i++ )
	{
		index = i + ( num - 5 );
		if ( IsDefined( strings[ index ] ) )
		{
			text = strings[ index ];
		}
		else
		{
			text = "";
		}
		
		if ( is_scene_deleted( text ) )
		{
			hud_array[ i ].color = ( .9, 0.5, 0.5 );
			text += "(deleted)";
		}
		else if ( is_scene_selected( text, a_selected_scenes ) )
		{
			hud_array[ i ].color = ( .5, .9, .5 );
		}
		else
		{
			hud_array[ i ].color = ( 0.9, 0.9, 0.9 );
		}
		
		if ( i == 5 )
		{
			text = ">" + text + "<";
		}

		hud_array[ i ] SetText( text );
	}

}

is_scene_selected( str_scene, a_selected_scenes )
{
	if ( str_scene != "" && str_scene != "exit" )
	{
		if ( flag( str_scene + "_started" ) )
		{
			return true;
		}
		
		if ( IsInArray( a_selected_scenes, str_scene ) )
		{
			return true;
		}
	}
	
	return false;
}

scene_menu_cleanup( elems, title )
{
	level waittill( "scene_menu_cleanup" );
	
	title Destroy();
	for ( i = 0; i < elems.size; i++ )
	{
		elems[ i ] Destroy();
	}
}
#/
