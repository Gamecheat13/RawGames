#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;

/@
"Name: precache_assets( <b_skip_precache_models> )"
"Summary: Sets up all the assets in its appropriate level.scr_* and precaches all models. This must be called after all scenes are added."
"Module: Animation"
"CallOn: level"
"OptionalArg: [b_skip_precache_models] If set to true, it will not call PrecacheModel."
"Example: precache_assets();"
"SPMP: singleplayer"
@/
precache_assets( b_skip_precache_models )
{
	Assert( IsDefined( level.a_scenes ), "There are no scenes to precache. Make sure to call add_scene() before calling this function." );

	a_scene_names = GetArrayKeys( level.a_scenes );
	
	// Loops through each scene to set up its asset info and to preache models
	for ( i = 0; i < a_scene_names.size; i++ )
	{
		str_scene_name = a_scene_names[ i ];
		s_scene_info = level.a_scenes[ str_scene_name ];
		
		if ( IsString( s_scene_info ) && s_scene_info == "scene deleted" )
		{
			continue;
		}
		
		// All assets must all use the same animation in a scene that is generic
		if ( s_scene_info.do_generic )
		{
			has_different = _has_different_generic_anims( str_scene_name );
			
			Assert( !has_different, "Since scene, " + str_scene_name + ", is a generic, all asset must use the same aniamtion.");
		}
		
		a_anim_keys = GetArrayKeys( s_scene_info.a_anim_info );
		
		// Loops through each asset info and sets each of them up in its appropriate level.scr_*
		for ( j = 0; j < a_anim_keys.size; j++ )
		{
			str_animname = a_anim_keys[ j ];
			s_asset_info = s_scene_info.a_anim_info[ str_animname ];
			
			if ( !IS_TRUE( b_skip_precache_models ) )
			{
				// Precaches a model if the model name is defined and sets up the asset's level.scr_model
				if ( IsDefined( s_asset_info.str_model ) )
				{
					level.scr_model[ str_animname ] = s_asset_info.str_model;
					
					//Assert( IsAssetLoaded( "xmodel", s_asset_info.str_model ), "Add this asset, " + s_asset_info.str_model + ", into your csv to load it into memory" );
					PreCacheModel( s_asset_info.str_model );	
				}
			}
			
			level.scr_animtree[ str_animname ] = s_asset_info.anim_tree;
			
			// 'generic' animations have a different way of looking up than normal animations in level.scr_anim
			if ( s_scene_info.do_generic )
			{
				str_animname = "generic";
			}
			
			animation = s_asset_info.animation;
			
			if ( s_scene_info.do_loop )
			{
				level.scr_anim[ str_animname ][ str_scene_name ][ 0 ] = animation;
			}
			else
			{
				level.scr_anim[ str_animname ][ str_scene_name ] = animation;
			}
		}
	}
}


/@
"Name: run_scene( <str_scene_name>, <n_lerp_time> )"
"Summary: Plays the scene that it is given. This function sets a flag, str_scene_name + "_started", once all the assets has start animating"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"OptionalArg: [n_lerp_time] Specify a specific lerp time."
"Example: run_scene( "rr_1" );"
"SPMP: singleplayer"
@/
run_scene( str_scene_name, n_lerp_time )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for run_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	// Resets the following if this scene has previously been used
	if ( flag( str_scene_name + "_started" ) )
	{
		level.a_scenes[ str_scene_name ].a_ai_anims = [];
		level.a_scenes[ str_scene_name ].a_model_anims = [];
		flag_clear( str_scene_name + "_started" );
	}

	s_scene_info = level.a_scenes[ str_scene_name ];
	
	align_object = s_scene_info _get_align_object( str_scene_name );
	
	// This is where the all the assets that is going to be animated gets assembled into an array
	a_active_anims = align_object _assemble_assets( str_scene_name );
	align_object thread _anim_death_notify( str_scene_name, a_active_anims );
	
	foreach ( e_asset in a_active_anims )
	{
		e_asset thread _animate_asset( str_scene_name, align_object, n_lerp_time );
	}

	flag_set( str_scene_name + "_started" );
	
	align_object waittill( str_scene_name );
	
	level.scene_sys notify( str_scene_name + "_done" );
	
	_delete_models( str_scene_name, true );
	_give_back_ai_weapons( str_scene_name, true );
	_delete_ais( str_scene_name, true );
}


/@
"Name: run_scene_and_delete( <str_scene_name>, [n_lerp_time] )"
"Summary: Plays the scene that it is given. This function sets a flag, str_scene_name + "_started", once all the assets has start animating.  Deletes the scene after it has finished playing."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"OptionalArg: [n_lerp_time] Specify a specific lerp time."
"Example: run_scene( "rr_1" );"
"SPMP: singleplayer"
@/
run_scene_and_delete( str_scene_name, n_lerp_time )
{
	run_scene( str_scene_name, n_lerp_time );
	delete_scene( str_scene_name );
}


/@
"Name: run_scene_first_frame( <str_scene_name> )"
"Summary: Puts a scene in its first animation frame"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: run_scene_first_frame( "rr_1" );"
"SPMP: singleplayer"
@/
run_scene_first_frame( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for run_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );

	s_scene_info = level.a_scenes[ str_scene_name ];
	
	align_object = s_scene_info _get_align_object( str_scene_name );
	a_active_anims = align_object _assemble_assets( str_scene_name );
	
	foreach ( e_asset in a_active_anims )
	{
		e_asset _run_anim_first_frame_on_asset( str_scene_name, align_object );
	}
}

/@
"Name: end_scene( <str_scene_name> )"
"Summary: Ends the scene that it is given."
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: end_scene( "rr_1" );"
"SPMP: singleplayer"
@/
end_scene( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for end_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Invalid scene name '" + str_scene_name + "' passed to end_scene()" );
	
	s_scene_info = level.a_scenes[ str_scene_name ];
	
	if ( IsDefined( s_scene_info.a_ai_anims ) )
	{
		a_ai_anims = array_removeUndefined( s_scene_info.a_ai_anims );
		
		foreach ( ai_anim in a_ai_anims )
		{
				ai_anim anim_stopanimscripted();
		}
	}

	if ( IsDefined( s_scene_info.a_model_anims ) )
	{
		a_model_anims = array_removeUndefined( s_scene_info.a_model_anims );
		
		foreach ( m_anim in a_model_anims )
		{
			m_anim anim_stopanimscripted();
		}
	}
	
	align_object = s_scene_info get_align_object_from_scene( str_scene_name );
	align_object notify( str_scene_name );
}

/@
"Name: add_scene_properties( <str_scene_name>, [str_align_targetname] ) "
"Summary: Adds properties to a specific scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"OptionalArg: [str_align_targetname] The targetname of struct, node or entity, that the scene is aligned to. This is required if do_reach is true or do_not_align is false."
"Example: add_scene_properties( "drop_down", self.script_string );"
"SPMP: singleplayer"
@/
add_scene_properties( str_scene_name, str_align_targetname )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for add_scene_properties()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	level.a_scenes[ str_scene_name ].str_align_targetname = str_align_targetname;
}

/@
"Name: add_asset_properties( <str_animname>, <str_scene_name>, [v_origin], [v_angles] ) "
"Summary: Adds properties to a specific asset in a specific scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname for the asset"
"MandatoryArg: <str_scene_name> The name of the scene"
"OptionalArg: [v_origin] The origin that you want this asset to have. Right now, this is mainly for models that needs to be spawned in a specific spot."
"OptionalArg: [v_angles] The angle that you want this asset to have. Right now, this is mainly for models that needs to be spawned in."
"Example: add_asset_properties( "m16_weapon", "prop_animations", s_weapon_start.origin, s_weapon_start.angles );"
"SPMP: singleplayer"
@/
add_asset_properties( str_animname, str_scene_name, v_origin, v_angles )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_asset_properties()" );
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for add_asset_properties()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ].a_anim_info[ str_animname ] ), "Asset with this animname, " + str_animname + ", does not exist in scene, " + str_scene_name );
	
	level.a_scenes[ str_scene_name ].a_anim_info[ str_animname ].v_origin = v_origin;
	level.a_scenes[ str_scene_name ].a_anim_info[ str_animname ].v_angles = v_angles;
}

/@
"Name: add_generic_ai_to_scene( <ai_generic>, <str_scene_name> )"
"Summary: Adds an AI that will be playing a generic animation to the actor anims array"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <ai_generic> The AI that needs to be added to the actor anims array for the specify scene"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: add_generic_ai_to_scene( ai_random, "generic_scene" );"
"SPMP: singleplayer"
@/
add_generic_ai_to_scene( ai_generic, str_scene_name )
{	
	Assert( IsDefined( ai_generic ), "ai_generic is a required argument for add_generic_ai_to_scene()" );
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for add_generic_ai_to_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ].a_anim_info[ "generic" ] ), "Make sure the actor info is setup properly for scene, " + str_scene_name + ", with add_actor_anim() or add_multiple_generic_actors()" );
	
	if ( !IsDefined( level.a_scenes[ str_scene_name ].a_ai_anims ) )
	{
		level.a_scenes[ str_scene_name ].a_ai_anims = [];
	}
	
	// Resets the following if this scene has previously been used
	if ( flag( str_scene_name + "_started" ) )
	{
		level.a_scenes[ str_scene_name ].a_ai_anims = [];
		flag_clear( str_scene_name + "_started" );
	}
	
	s_asset_info = level.a_scenes[ str_scene_name ].a_anim_info[ "generic" ];

	ai_generic _setup_ai_for_anim( s_asset_info );
	
	n_ai_anims_size = level.a_scenes[ str_scene_name ].a_ai_anims.size;
	level.a_scenes[ str_scene_name ].a_ai_anims[ n_ai_anims_size ] = ai_generic;
}

/@
"Name: add_generic_prop_to_scene( <m_generic>, <str_scene_name> )"
"Summary: Adds a prop that will be playing a generic animation to the prop anims array"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <m_generic> The prop that needs to be added to the prop anims array for the specify scene"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: add_generic_prop_to_scene( m_random, "generic_scene" );"
"SPMP: singleplayer"
@/
add_generic_prop_to_scene( m_generic, str_scene_name )
{	
	Assert( IsDefined( m_generic ), "m_generic is a required argument for add_generic_prop_to_scene()" );
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for add_generic_prop_to_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ].a_anim_info[ "generic" ] ), "Make sure the prop info is setup properly for scene, " + str_scene_name + ", with add_prop_anim() or add_multiple_generic_props_from_radiant()" );
	
	if ( !IsDefined( level.a_scenes[ str_scene_name ].a_model_anims ) )
	{
		level.a_scenes[ str_scene_name ].a_model_anims = [];
	}
	
	// Resets the following if this scene has previously been used
	if ( flag( str_scene_name + "_started" ) )
	{
		level.a_scenes[ str_scene_name ].a_model_anims = [];
		flag_clear( str_scene_name + "_started" );
	}
	
	s_asset_info = level.a_scenes[ str_scene_name ].a_anim_info[ "generic" ];
	
	m_generic.str_name = s_asset_info.str_name;
	m_generic.do_delete = s_asset_info.do_delete;
	m_generic.str_tag = s_asset_info.str_tag;
	m_generic init_anim_model( s_asset_info.str_name, s_asset_info.is_simple_prop );
	
	// Hide parts on a model if defined	
	if ( IsDefined( s_asset_info.a_parts ) )
	{
		for ( i = 0; i < s_asset_info.a_parts.size; i++ )
		{
			m_generic HidePart( s_asset_info.a_parts[ i ] );
		}
	}
	
	n_model_anims_size = level.a_scenes[ str_scene_name ].a_model_anims.size;
	level.a_scenes[ str_scene_name ].a_model_anims[ n_model_anims_size ] = m_generic;
}

/@
"Name: get_align_object_from_scene( <str_scene_name> )"
"Summary: Returns the align object from the specified scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: align_object = s_scene_info get_align_object_from_scene( str_scene_name );"
"SPMP: singleplayer"
@/
get_align_object_from_scene( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for get_model_or_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	align_object = level.a_scenes[ str_scene_name ].align_object;
	
	if ( IsDefined( align_object ) )
	{
		return align_object;
	}
	else
	{
		return level;
	}
}

/@
"Name: get_model_or_models_from_scene( <str_scene_name>, [str_name] )"
"Summary: Returns a model or an array of models from the specified scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"OptionalArg: [str_name] The animname of a model that you are looking for in a particular scene"
"Example: a_models = get_model_or_models_from_scene( str_scene_name );"
"SPMP: singleplayer"
@/
get_model_or_models_from_scene( str_scene_name, str_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for get_model_or_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	s_scene_info = level.a_scenes[ str_scene_name ];
	
	model_or_models = [];
	
	if ( !IsDefined( str_name ) )
	{
		// Grabs all models in a scene that has already been used for animation
		model_or_models = s_scene_info.a_model_anims;
		
		// If there are no models that has already been used for animation 
		if ( model_or_models.size == 0 )
		{
			a_anim_keys = GetArrayKeys( s_scene_info.a_anim_info );
			
			// Find models that would be use for this scene in Radiant
			for ( i = 0; i < a_anim_keys.size; i++ )
			{
				str_anim_key = a_anim_keys[ i ];
				s_asset_info = s_scene_info.a_anim_info[ str_anim_key ];
				
				if ( IS_TRUE( s_asset_info.is_model ) && !IsDefined( s_asset_info.str_model ) )
				{
					model_or_models = s_asset_info _get_models_from_radiant( str_scene_name );
				}
			}
		}
		
		model_or_models = array_removeundefined( model_or_models );
	}
	else
	{
		a_model_anims = level.a_scenes[ str_scene_name ].a_model_anims;
		
		// Loops through all models in the scene and finds a model or models with the same name
		for ( i = 0; i < a_model_anims.size; i++ )
		{
			m_check = a_model_anims[ i ];
			
			if ( m_check.str_name == str_name )
			{
				model_or_models[ model_or_models.size ] = m_check;
			}
		}
		
		// Return a model or undefined if there one model or no model is found with that name
		if ( model_or_models.size < 2 )
		{
			model_or_models = model_or_models[ 0 ];
		}
		else
		{
			model_or_models = array_removeundefined( model_or_models );
		}
	}

	return model_or_models;
}

/@
"Name: get_ais_from_scene( <str_scene_name> )"
"Summary: Returns an array of AIs from the specified scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: a_ais = get_ais_from_scene( str_scene_name );"
"SPMP: singleplayer"
@/
get_ais_from_scene( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for get_model_or_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	a_ais_from_scene = level.a_scenes[ str_scene_name ].a_ai_anims;
	a_ais_from_scene = array_removeundefined( a_ais_from_scene );
	
	return a_ais_from_scene;
}

/@
"Name: give_back_ai_weapons_on_scene( <str_scene_name>, [b_specific_ais] )"
"Summary: Give back weapons to AIs in a specific scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: give_back_ai_weapons_on_scene( "rr_3" );"
"SPMP: singleplayer"
@/
give_back_ai_weapons_on_scene( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for give_back_ai_weapons_on_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	_give_back_ai_weapons( str_scene_name );
}

/@
"Name: scene_wait( <str_scene_name> )"
"Summary: Waits for a scene to be done"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: scene_wait( "rr_1c_done" );"
"SPMP: singleplayer"
@/
scene_wait( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for delete_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	level.scene_sys waittill( str_scene_name + "_done" );
}

/@
"Name: delete_models_from_scene( <str_scene_name> )"
"Summary: Delete all models from a scene. If the scene has not been played, it will delete the models that was in Radiant for the scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: delete_models_from_scene( "rr_4" );"
"SPMP: singleplayer"
@/
delete_models_from_scene( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for delete_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	_delete_models( str_scene_name );
}

/@
"Name: delete_ais_from_scene( <str_scene_name> )"
"Summary: Delete all AI from a scene. If the scene has not been played,"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: delete_ais_from_scene( "rr_4" );"
"SPMP: singleplayer"
@/
delete_ais_from_scene( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for delete_models_from_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	
	_delete_ais( str_scene_name );
}

/@
"Name: delete_scene( <str_scene_name> )"
"Summary: Delete all models from a scene. Gives back weapons to all AIs in that scene. Removes all info for that scene from memory. (NOTE: Do not call this function until the scene is done.)"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"Example: delete_scene( "rr_4" );"
"SPMP: singleplayer"
@/
delete_scene( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for delete_scene()" );
	Assert( IsDefined( level.a_scenes[ str_scene_name ] ), "Make sure this scene, " + str_scene_name + ", is added by using add_scene()" );
	Assert( !IsString( level.a_scenes[ str_scene_name ] ), "Attempting to delete a scene that's already been deleted." );
	
	delete_models_from_scene( str_scene_name );
	give_back_ai_weapons_on_scene( str_scene_name );
	
	level.a_scenes[ str_scene_name ] = undefined;
	level.a_scenes[ str_scene_name ] = "scene deleted";
}

/*==============================================================
SELF: level
PURPOSE: Checks to see if there are different animations in a
		 'generic' scene
RETURNS: A boolean that determains if there are different
		 animations in the scene
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_has_different_generic_anims( str_scene_name )
{
	has_different = false;
	
	a_anim_info = level.a_scenes[ str_scene_name ].a_anim_info;
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
	self _preprocess_notetracks();
}

/*==============================================================
SELF: A struct that has all the info for that scene
PURPOSE: Finds the align object for a scene. Returns 'level' by default.
RETURNS: The align object or level
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_get_align_object( str_scene_name )
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
			// If the align object is not a struct, it might be a node
			nd_align = GetNode( self.str_align_targetname, "targetname" );
			align_object = nd_align;

			// If the align object is not a struct or node, it might be an entity			
			if ( !IsDefined( align_object ) )
			{
				e_align = GetEnt( self.str_align_targetname, "targetname" );
				align_object = e_align;
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
		
		Assert( IsDefined( align_object ), "Could not find a struct, node, or entity with the targetname, " + self.str_align_targetname + ", in the map for scene, " + str_scene_name );
		
		level.a_scenes[ str_scene_name ].align_object = align_object;
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
_assemble_assets( str_scene_name )
{
	s_scene_info = level.a_scenes[ str_scene_name ];
	
	// Loops through all assets and sets each of them based on various criterias
	foreach ( str_anim_key, s_asset_info in s_scene_info.a_anim_info )
	{
		if ( str_anim_key == "generic" )
		{
			continue; // The scripter should have already set this up using add_generic_ai_to_scene() or add_generic_prop_to_scene()
		}
				
		if ( ( IsDefined( s_asset_info.str_model ) || IsDefined( s_asset_info.str_vehicletype ) )
		      && !IsDefined( level.scene_sys.a_active_anim_models[ s_asset_info.str_name ] ) )
		{
			// Spawns a model that does not exist yet and sets it up for animation
			s_asset_info _assemble_non_existent_model( str_scene_name/*, self */);
		}
		else if ( IsDefined( level.scene_sys.a_active_anim_models[ s_asset_info.str_name ] ) || IS_TRUE( s_asset_info.is_model ) )
		{
			// Model already exists, but needs to be set up for animation
			s_asset_info _assemble_already_exist_model( str_scene_name );
		}
		else // Sets AIs up for animation
		{
			if ( IS_TRUE( s_asset_info.has_multiple_ais ) )
			{
				s_asset_info _assemble_multiple_ais( str_scene_name );
			}
			else
			{		
				s_asset_info _assemble_single_ai( str_scene_name, str_anim_key );
			}
		}
	}
	
	if ( !IsDefined( s_scene_info.a_ai_anims ) && !IsDefined( s_scene_info.a_model_anims ) )
	{
		a_active_anims = [];
	}
	else if ( !IsDefined( s_scene_info.a_ai_anims ) )
	{
		a_active_anims = s_scene_info.a_model_anims;
	}
	else if ( !IsDefined( s_scene_info.a_model_anims ) )
	{
		a_active_anims = s_scene_info.a_ai_anims;
	}
	else
	{
		a_active_anims = array_combine( s_scene_info.a_ai_anims, s_scene_info.a_model_anims );
	}
	
	return a_active_anims;
}

/*==============================================================
SELF: A struct that has all the info for that model
PURPOSE: Spawns a model that does not exist yet and sets it up for animation
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_assemble_non_existent_model( str_scene_name/*, align_object*/ )
{
	if ( IsDefined( self.str_vehicletype ) )
	{
		m_ready = _spawn_vehicle_for_anim();
	}
	else
	{
		m_ready = spawn_anim_model( self.str_name, self.v_origin, self.v_angles, self.is_simple_prop );
	}
	
	// Hide parts on a model if defined
	if ( IsDefined( self.a_parts ) )
	{
		for ( i = 0; i < self.a_parts.size; i++ )
		{
			m_ready HidePart( self.a_parts[ i ] );
		}
	}
	else if ( IS_TRUE( self.is_weapon ) )
	{
		m_ready UseWeaponHideTags( self.str_weapon_name );
	}
	
	// Checks to see if this asset is for the player and handles player specific tasks
	if ( IsDefined( self.n_player_number ) )
	{
		player = get_players()[ self.n_player_number ];
		
		m_ready Hide();
		m_ready.origin = player GetOrigin();
		m_ready.angles = player GetPlayerAngles();
	
		m_ready.n_player_number = self.n_player_number;
		
		player DisableWeapons();
		player HideViewModel();
		
		player hide_hud();
		
		player.m_scene_model = m_ready;
		player.s_scene_info = self;
		
		self delay_thread( .1, ::_link_to_player_model, player, m_ready );	// delay thread so anim can start
	}
			
	m_ready.str_name = self.str_name;
	m_ready.do_delete = self.do_delete;
	m_ready.str_tag = self.str_tag;
	
	if ( IS_TRUE( self.b_animate_origin ) )
	{
		m_ready.supportsAnimScripted = true;
	}
	else
	{
		m_ready.supportsAnimScripted = undefined;
	}
	
	m_ready.targetname = self.str_name;
	
	level.scene_sys.a_active_anim_models[ self.str_name ] = m_ready;
	
	if ( !IsDefined( level.a_scenes[ str_scene_name ].a_model_anims ) )
	{
		level.a_scenes[ str_scene_name ].a_model_anims = [];
	}
	
	n_model_anims_size = level.a_scenes[ str_scene_name ].a_model_anims.size;
	level.a_scenes[ str_scene_name ].a_model_anims[ n_model_anims_size ] = m_ready;
}

/*==============================================================
SELF: A struct that has all the info for that model
PURPOSE: Links the player to the body model after a delay to give
		the animation time to take effect on the client before
		linking to reduce camera pop.
RETURNS: nothing
CREATOR: BrianB (9/29/11)
===============================================================*/
_link_to_player_model( player, m_player_model )
{
	if ( !IS_FALSE( self.b_use_camera_tween ) )
	{
		player StartCameraTween( 0.2 );
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
	
	wait .2;
		
	m_player_model Show();
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
_assemble_already_exist_model( str_scene_name )
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
			// Add one model
			n_models_array_size = a_models.size;
			a_models[ n_models_array_size ] = level.scene_sys.a_active_anim_models[ self.str_name ];
		}
	}
	else // For models that are in Radiant, but has not been animated before
	{
		a_models = self _get_models_from_radiant( str_scene_name );
		
		if ( a_models.size == 0 )
		{
			if ( IS_TRUE( self.is_vehicle ) )
			{
				a_models = maps\_vehicle::spawn_vehicles_from_targetname( self.str_name, true );
				
			}
			else
			{
				sp_model = GetEnt( self.str_name, "targetname" );
				if( IsSpawner( sp_model ) )
				{
					m_actor = Spawn( "script_model", (0, 0, 0) );
					m_actor GetDroneModel( sp_model.classname );
					m_actor.targetname = self.str_name + "_am";
					a_models[0] = m_actor;
				}
			}
			                   
		}
	
		if(IS_TRUE( self.is_vehicle ) && IS_TRUE( self.not_usable ) )
		{
			foreach( e_model in a_models )
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
		
		m_exist init_anim_model( self.str_name, self.is_simple_prop );
		
		// Hide parts on a model if defined	
		if ( IsDefined( self.a_parts ) )
		{
			for ( j = 0; j < self.a_parts.size; j++ )
			{
				m_exist HidePart( self.a_parts[ j ] );
			}
		}
		
		m_exist.str_name = self.str_name;
		m_exist.do_delete = self.do_delete;
		m_exist.str_tag = self.str_tag;
		
		if ( IS_TRUE( self.b_animate_origin ) )
		{
			m_exist.supportsAnimScripted = true;
		}
		else
		{
			m_exist.supportsAnimScripted = undefined;
		}
		
		if ( n_models_array_size > 1 )
		{
			level.scene_sys.a_active_anim_models[ self.str_name ][ i ] = m_exist;
		}
		else
		{
			level.scene_sys.a_active_anim_models[ self.str_name ] = m_exist;
		}
		
		if ( !IsDefined( level.a_scenes[ str_scene_name ].a_model_anims ) )
		{
			level.a_scenes[ str_scene_name ].a_model_anims = [];
		}
		
		if ( !is_in_array( level.a_scenes[ str_scene_name ].a_model_anims, m_exist ) )
		{
			n_model_anims_size = level.a_scenes[ str_scene_name ].a_model_anims.size;
			level.a_scenes[ str_scene_name ].a_model_anims[ n_model_anims_size ] = m_exist;
		}
	}
}

/*==============================================================
SELF: A struct that has all the info for the AI
PURPOSE: Assemble multiple AIs for animation
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_assemble_multiple_ais( str_scene_name )
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
			n_ai_count = 0;
			does_spawner_exist = true;
			foreach ( sp_guy in a_ai_spawners )
			{
				n_spawner_count = sp_guy.count;
				
				// Spawn an AI if it can be spawn from this spawner
				for ( j = 0; j < n_spawner_count; j++ )
				{
					a_ai_spawned[ n_ai_count ] = simple_spawn_single( sp_guy );
					n_ai_count++;
				}
			}
		}
	}
	
	does_ai_exist = a_ai_spawned.size > 0;
	Assert( does_ai_exist || does_spawner_exist, "Could not find any AIs or spawners with this targetname, " + self.str_name + ", for the scene, " + str_scene_name );
	
	if ( a_ai_spawned.size > 0 )
	{
		// Sets up the AIs and puts them in the actor anims array
		for ( i = 0; i < a_ai_spawned.size; i++ )
		{
			ai_spawned = a_ai_spawned[ i ];
			ai_spawned _setup_ai_for_anim( self );
			
			if ( !IsDefined( level.a_scenes[ str_scene_name ].a_ai_anims ) )
			{
				level.a_scenes[ str_scene_name ].a_ai_anims = [];
			}
			
			n_ai_anims_size = level.a_scenes[ str_scene_name ].a_ai_anims.size;
			level.a_scenes[ str_scene_name ].a_ai_anims[ n_ai_anims_size ] = ai_spawned;
		}
	}
}

/*==============================================================
SELF: A struct that has all the info for the AI
PURPOSE: Assemble a specific AI for animation
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_assemble_single_ai( str_scene_name, str_anim_key )
{
	a_all_ai_in_level = GetAISpeciesArray();
	ai_found = undefined;
	
	// Tries to find an AI with this animname by searching through all the AIs in the level
	foreach ( ai_in_level in a_all_ai_in_level )
	{
		str_animname = ai_in_level.animname;
					
		if ( IsDefined( str_animname ) && ( str_anim_key == str_animname ) )
		{
			Assert( !IsDefined( ai_found ), "More than one AI in the level has the same animname, " + self.str_name + ", for scene, " + str_scene_name );
			ai_found = ai_in_level;
		}
	}
			
	does_spawner_exist = false;
	
	// Spawn an AI with that script_animname if the AI does not already exist in the level
	if ( !IsDefined( ai_found ) )
	{
		a_spawners = GetSpawnerArray();
		
		// Loops through all spawners and spawns an AI if it can and has the required script_animname
		foreach ( sp_guy in a_spawners )
		{
			str_animname = sp_guy.script_animname;
			str_targetname = sp_guy.targetname;
			
			if ( IsDefined( str_animname ) && ( str_anim_key == str_animname ) )
			{	
				Assert( !IsDefined( ai_found ), "More than one spawner in Radiant have the same script_animname, " + self.str_name + ", for scene, " + str_scene_name );
				
				does_spawner_exist = true;
			
				if ( sp_guy.count > 0 )
				{
					ai_found = simple_spawn_single( sp_guy );
				}
			}
			else if ( IsDefined( str_targetname ) && ( str_anim_key == str_targetname ) )
			{
				does_spawner_exist = true;
				
				if ( sp_guy.count > 0 )
				{
					ai_found = simple_spawn_single( sp_guy );
					
					if ( IsDefined( ai_found ) && !IsDefined( ai_found.animname ) )
					{
						ai_found.animname = str_anim_key;
					}
				}
			}			
		}
	}
	
	is_scene_generic = level.a_scenes[ str_scene_name ].do_generic;
	
	// Find an AI with that targetname if the AI does not have an animname and the scene is generic
	if ( !IsDefined( ai_found ) && is_scene_generic )
	{
		ai_found = GetEnt( self.str_name + "_ai", "targetname" );
	}
	
	// Spawn an AI with that targetname if the AI does not already exist in the level, does not have an animname, and the scene is generic
	if ( !IsDefined( ai_found ) && is_scene_generic )
	{
		sp_guy = GetEnt( self.str_name, "targetname" );
		
		// Checks to see if the spawner with that name found
		if ( IsDefined( sp_guy )  )
		{
			does_spawner_exist = true;
			
			if ( sp_guy.count > 0 )
			{
				ai_found = simple_spawn_single( sp_guy );
			}
		}
	}
	
	if ( is_scene_generic )
	{
		Assert( IsDefined( ai_found ) || does_spawner_exist, "Could not find any AI or spawner with this targetname, " + str_anim_key + ", for the scene, " + str_scene_name );
	}
	else
	{
		Assert( IsDefined( ai_found ) || does_spawner_exist, "Could not find any AI or spawner with this animname or script_animname, " + str_anim_key + ", for the scene, " + str_scene_name );
	}
	
	// Sets up the AI and adds it to actor anims array
	if ( IsDefined( ai_found ) )
	{		
		ai_found _setup_ai_for_anim( self );
		
		if ( !IsDefined( level.a_scenes[ str_scene_name ].a_ai_anims ) )
		{
			level.a_scenes[ str_scene_name ].a_ai_anims = [];
		}
		
		n_ai_anims_size = level.a_scenes[ str_scene_name ].a_ai_anims.size;
		level.a_scenes[ str_scene_name ].a_ai_anims[ n_ai_anims_size ] = ai_found;
	}
}

/*==============================================================
SELF: An AI
PURPOSE: Sets up an AI based on its asset info
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_setup_ai_for_anim( s_asset_info )
{
	if ( !s_asset_info.do_not_allow_death )
	{
		self.allowdeath = true;
		self SetCanDamage( true );
	}
	
	if ( s_asset_info.do_hide_weapon )
	{
		self gun_remove();
	}
	
	self.str_tag = s_asset_info.str_tag;
	self.do_give_back_weapon = s_asset_info.do_give_back_weapon;
	self.do_delete = s_asset_info.do_delete;
}

/*==============================================================
SELF: An asset
PURPOSE: Notify a scene to end if this asset dies
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_anim_death_notify( str_scene_name, a_active_anims )
{
	self endon( str_scene_name );
	
	array_wait( a_active_anims, "death" );
	
	self notify( str_scene_name );
}

/*==============================================================
SELF: An asset
PURPOSE: Animates an asset based on the scene info
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_animate_asset( str_scene_name, align_object, n_lerp_time )
{
	self endon( "death" );
	
	s_scene_info = level.a_scenes[ str_scene_name ];
		
	if ( s_scene_info.do_reach )
	{
		self _run_anim_reach_on_asset( str_scene_name, align_object );
		
		// Waits for all the AIs in this scene to be done with their anim_reach
		array_wait( s_scene_info.a_ai_anims, "goal" );
	}
	
	if ( s_scene_info.do_loop )
	{
		self _run_anim_loop_on_asset( str_scene_name, align_object, n_lerp_time );
	}
	else
	{
		self _run_anim_single_on_asset( str_scene_name, align_object, n_lerp_time );
	}
}

/*==============================================================
SELF: An asset
PURPOSE: Makes an AI in this scene to do a reach
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_run_anim_reach_on_asset( str_scene_name, align_object )
{
	s_scene_info = level.a_scenes[ str_scene_name ];
	
	// Only do reach on an AI
	if ( IsSentient( self ) )
	{
		if ( s_scene_info.do_not_align )
		{
			if ( s_scene_info.do_generic )
			{
				align_object thread anim_generic_reach( self, str_scene_name );
			}
			else
			{
				align_object thread anim_reach( self, str_scene_name );
			}
		}
		else
		{
			if ( s_scene_info.do_generic )
			{
				align_object thread anim_generic_reach_aligned( self, str_scene_name, self.str_tag );
			}
			else
			{
				align_object thread anim_reach_aligned( self, str_scene_name, self.str_tag );
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
_run_anim_loop_on_asset( str_scene_name, align_object, n_lerp_time )
{
	s_scene_info = level.a_scenes[ str_scene_name ];
	
	if( isdefined( self.is_horse ) )
	{
		self ent_flag_set("playing_scripted_anim");
	}
	
	if ( s_scene_info.do_not_align )
	{
		if ( s_scene_info.do_generic )
		{
			align_object anim_generic_loop( self, str_scene_name );
		}
		else
		{
			align_object anim_loop( self, str_scene_name );
		}
	}
	else
	{
		// Links the asset to a specific tag if the tag is defined
		if ( IsDefined( self.str_tag ) )
		{
			self LinkTo( align_object, self.str_tag );
		}
				
		if ( s_scene_info.do_generic )
		{
			align_object anim_generic_loop_aligned( self, str_scene_name, self.str_tag, undefined, n_lerp_time );
		}
		else
		{
			align_object anim_loop_aligned( self, str_scene_name, self.str_tag, undefined, undefined, n_lerp_time );
		}
	}
}

/*==============================================================
SELF: An asset
PURPOSE: Plays a single animation on a specific asset
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_run_anim_single_on_asset( str_scene_name, align_object, n_lerp_time )
{
	s_scene_info = level.a_scenes[ str_scene_name ];
	
	if( isdefined( self.is_horse ) )
	{
		self ent_flag_set("playing_scripted_anim");
	}
	
	if ( s_scene_info.do_not_align )
	{
		if ( s_scene_info.do_generic )
		{
			align_object anim_generic( self, str_scene_name );
		}
		else
		{
			align_object anim_single( self, str_scene_name );
		}
	}
	else
	{
		// Links the asset to a specific tag if the tag is defined
		if ( IsDefined( self.str_tag ) )
		{	
			self LinkTo( align_object, self.str_tag );
		}
				
		if ( s_scene_info.do_generic )
		{
			align_object anim_generic_aligned( self, str_scene_name, self.str_tag, n_lerp_time );
		}
		else
		{
			align_object anim_single_aligned( self, str_scene_name, self.str_tag, undefined, n_lerp_time );
		}
	}
	
	if( isdefined( self.is_horse ) )
	{
		self ent_flag_clear("playing_scripted_anim");
	}
	
	
}

/*==============================================================
SELF: An asset
PURPOSE: Puts an animation on its first frame on a specific asset
RETURNS: nothing
CREATOR: BrianB (06/27/2011)
===============================================================*/
_run_anim_first_frame_on_asset( str_scene_name, align_object )
{
	s_scene_info = level.a_scenes[ str_scene_name ];
	
	if ( s_scene_info.do_not_align )
	{
		self anim_first_frame( self, str_scene_name );
	}
	else
	{
		// Links the asset to a specific tag if the tag is defined
		if ( IsDefined( self.str_tag ) )
		{	
			self LinkTo( align_object, self.str_tag );
		}
				
		align_object anim_first_frame( self, str_scene_name, self.str_tag );
	}
}

/*==============================================================
SELF: A struct that has all the info for a model or models
PURPOSE: Get model or models from Radiant
RETURNS: An array of models
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_get_models_from_radiant( str_scene_name )
{
	a_models = [];
	m_exist=undefined;
	
	if ( IS_TRUE( self.has_multiple_props ) )
	{
		a_models = GetEntArray( self.str_name, "targetname" );
	}
	else
	{
		a_script_models = [];
		a_script_models = array_combine( GetEntArray( "script_model", "classname" ), a_script_models );
		a_script_models = array_combine( GetEntArray( "script_brushmodel", "classname" ), a_script_models );
		a_script_models = array_combine( GetEntArray( "script_vehicle", "classname" ), a_script_models );
				
		// Loops through all script models to find a model with the same script_animname
		foreach ( m_in_radiant in a_script_models )
		{
			str_lookup_name = m_in_radiant.animname;
	
			// Tries to find a prop with this animname
			if ( IsDefined( str_lookup_name ) && ( str_lookup_name == self.str_name ) )
			{
				Assert( !IsDefined( m_exist ), "Another model in Radiant has the same animname, " + self.str_name + ", as a prop in scene, " + str_scene_name );
				m_exist = m_in_radiant;
			}
			
			if ( !IsDefined( m_exist ) )
			{
				str_lookup_name = m_in_radiant.targetname;
				
				// Tries to find a prop with this targetname
				if ( IsDefined( str_lookup_name ) && ( str_lookup_name == self.str_name ) )
				{
					Assert( !IsDefined( m_exist ), "Another model in Radiant has the same targetname, " + self.str_name + ", as a prop in scene, " + str_scene_name );
					m_exist = m_in_radiant;
				}
			}
			
			if ( !IsDefined( m_exist ) )
			{
				str_lookup_name = m_in_radiant.script_animname;
				
				// Tries to find a prop with this script_animname
				if ( IsDefined( str_lookup_name ) && ( str_lookup_name == self.str_name ) )
				{
					Assert( !IsDefined( m_exist ), "Another model in Radiant has the same script_animname, " + self.str_name + ", as a prop in scene, " + str_scene_name );
					m_exist = m_in_radiant;
				}
			}
		}
		
		n_models_array_size = a_models.size;
		a_models[ n_models_array_size ] = m_exist;
	}
	
	return a_models;
}

/*==============================================================
SELF: level
PURPOSE: Deletes all models in a specific scene or specific models
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_delete_models( str_scene_name, b_specific_models )
{
	if ( IsString( level.a_scenes[ str_scene_name ] ) && level.a_scenes[ str_scene_name ] == "scene deleted" )
	{
		return;
	}
	
	if ( !IsDefined( level.a_scenes[ str_scene_name ].a_model_anims ) )
	{
		return;
	}
	
	if ( !IsDefined( b_specific_models ) )
	{
		b_specific_models = false;
	}
	
	a_models = get_model_or_models_from_scene( str_scene_name );
	a_models = array_removeundefined( a_models );
	
	b_item_removed = false;
	
	// For each model, delete it if it is marked for deletion by add_prop_anim() or add_weapon_anim()
	for ( i = 0; i < a_models.size; i++ )
	{
		m_possible_deletion = a_models[ i ];
		
		if ( b_specific_models )
		{
			if ( m_possible_deletion.do_delete )
			{
				m_possible_deletion Delete();
				b_item_removed = true;
				
				if ( IsDefined( m_possible_deletion.n_player_number ) )
				{
					player = get_players()[ m_possible_deletion.n_player_number ];
					player _reset_player_after_anim();
				}
			}
		}
		else
		{
			if ( IS_TRUE( m_possible_deletion.do_delete) )
			{
				m_possible_deletion Delete();
				
				if ( IsDefined( m_possible_deletion.n_player_number ) )
				{
					player = get_players()[ m_possible_deletion.n_player_number ];
					player _reset_player_after_anim();
				}
			}
		}
	}
	
	if ( b_specific_models )
	{
		// Remove undefines if models were deleted from the array
		if ( b_item_removed )
		{
			a_remove_undefined = level.scene_sys.a_active_anim_models;
			level.scene_sys.a_active_anim_models = array_removeundefined( a_remove_undefined );
			
			level.a_scenes[ str_scene_name ].a_model_anims = array_removeundefined( a_models );
		}
	}
	else
	{
		a_remove_undefined = level.scene_sys.a_active_anim_models;
		level.scene_sys.a_active_anim_models = array_removeundefined( a_remove_undefined );
		
		level.a_scenes[ str_scene_name ].a_model_anims = [];
	}
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
	
	self Unlink();
	self EnableWeapons();
	self ShowViewModel();
	self show_hud();
}

/*==============================================================
SELF: level
PURPOSE: Deletes all AIs in a specific scene or specific AIs
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_delete_ais( str_scene_name, b_specific_ais )
{
	if ( IsString( level.a_scenes[ str_scene_name ] ) && level.a_scenes[ str_scene_name ] == "scene deleted" )
	{
		return;
	}
	
	if ( !IsDefined( level.a_scenes[ str_scene_name ].a_ai_anims ) )
	{
		return;
	}
	
	if ( !IsDefined( b_specific_ais ) )
	{
		b_specific_ais = false;
	}
	
	a_ai_in_scene = get_ais_from_scene( str_scene_name );
	
	b_ai_removed = false;
	
	foreach ( ai in a_ai_in_scene )
	{
		if ( b_specific_ais)
		{
			if ( IsDefined( ai ) && ai.do_delete )
			{
				ai Delete();
				b_ai_removed = true;
			}
		}
		else if ( IsDefined( ai ) )
		{
			ai Delete();
		}
	}
	
	if ( b_specific_ais )
	{
		// Remove undefines if models were deleted from the array
		if ( b_ai_removed )
		{	
			level.a_scenes[ str_scene_name ].a_ai_anims = array_removeundefined( a_ai_in_scene );
		}
	}
	else
	{
		level.a_scenes[ str_scene_name ].a_ai_anims = [];
	}
}

/*==============================================================
SELF: level
PURPOSE: Give back weapons to all AIs in a specific scene or
		 specific AIs
RETURNS: nothing
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_give_back_ai_weapons( str_scene_name, b_specific_ais )
{
	if ( IsString( level.a_scenes[ str_scene_name ] ) && level.a_scenes[ str_scene_name ] == "scene deleted" )
	{
		return;
	}
	
	if ( !IsDefined( level.a_scenes[ str_scene_name ].a_ai_anims ) )
	{
		return;
	}
	
	if ( !IsDefined( b_specific_ais ) )
	{
		b_specific_ais = false;
	}
	
	//a_ai_in_scene = level.a_scenes[ str_scene_name ].a_ai_anims;
	a_ai_in_scene = get_ais_from_scene( str_scene_name );
	
	// Loops through all AIs in the scene and gives back their weapon if certain requirements were met
	for ( i = 0; i < a_ai_in_scene.size; i++ )
	{
		ai_give_back_weapon = a_ai_in_scene[ i ];
		
		// b_specific_ais is a boolean to see if it only gives back weapons to specific AIs
		if ( b_specific_ais )
		{
			if ( ai_give_back_weapon.do_give_back_weapon )
			{
				ai_give_back_weapon gun_recall();
			}
		}
		else
		{
			ai_give_back_weapon gun_recall();
		}
	}
}

/@
"Name: add_scene( <str_scene_name>, [str_align_targetname], [do_reach], [do_generic], [do_loop], [do_not_align] )"
"Summary: Initializes information on a new scene, so that animations can be later added to it. This must be called before adding any animation information for that scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"OptionalArg: [str_align_targetname] The targetname of struct, node or entity, that the scene is aligned to. This is required if do_reach is true or do_not_align is false."
"OptionalArg: [do_reach] A boolean to determine if the AIs in the scene needs to do a reach. Default is false."
"OptionalArg: [do_generic] A boolean to determine if the scene is 'generic'. Default is false."
"OptionalArg: [do_loop] A boolean to determine if the assets in the scene needs to be looped. Default is false."
"OptionalArg: [do_not_align] A boolean to determine if the scene is aligned or not. Default is false."
"Example: add_scene( "rr_1", "anim_rr" );"
"SPMP: singleplayer"
@/
add_scene( str_scene_name, str_align_targetname, do_reach, do_generic, do_loop, do_not_align )
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
	
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for add_scene()" );
	Assert( !IsDefined( level.a_scenes[ str_scene_name ] ), "Scene, " + str_scene_name + ", has already been declared." );
	
	flag_init( str_scene_name + "_started" );
	
	if ( !IsDefined( do_reach ) )
	{
		do_reach = false;
	}
	
	if ( !IsDefined( do_generic ) )
	{
		do_generic = false;
	}
	
	if ( !IsDefined( do_loop ) )
	{
		do_loop = false;
	}
	
	if ( !IsDefined( do_not_align ) )
	{
		do_not_align = false;
	}
	
	s_scene_info = SpawnStruct();
	s_scene_info.str_scene_name = str_scene_name;
	s_scene_info.a_anim_info = [];
	s_scene_info.str_align_targetname = str_align_targetname;
	s_scene_info.do_reach = do_reach;
	s_scene_info.do_generic = do_generic;
	s_scene_info.do_loop = do_loop;
	s_scene_info.do_not_align = do_not_align;
	
	level.a_scenes[ str_scene_name ] = s_scene_info;
	
	level.scene_sys.str_current_scene = str_scene_name;
}

/@
"Name: add_scene_loop( <str_scene_name>, [str_align_targetname], [do_reach], [do_generic], [do_not_align] )"
"Summary: Initializes information on a new looping scene, so that animations can be later added to it. This must be called before adding any animation information for that scene"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_scene_name> The name of the scene"
"OptionalArg: [str_align_targetname] The targetname of struct, node or entity, that the scene is aligned to. This is required if do_reach is true or do_not_align is false."
"OptionalArg: [do_reach] A boolean to determine if the AIs in the scene needs to do a reach. Default is false."
"OptionalArg: [do_generic] A boolean to determine if the scene is 'generic'. Default is false."
"OptionalArg: [do_not_align] A boolean to determine if the scene is aligned or not. Default is false."
"Example: add_scene_loop( "rr_1", "anim_rr" );"
"SPMP: singleplayer"
@/
add_scene_loop( str_scene_name, str_align_targetname, do_reach, do_generic, do_not_align )
{
	add_scene( str_scene_name, str_align_targetname, do_reach, do_generic, true, do_not_align );
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
add_actor_anim( str_animname, animation, do_hide_weapon, do_give_back_weapon, do_delete, do_not_allow_death, str_tag )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_actor_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( IsDefined( animation ), "animation is a required argument for add_actor_anim() in scene, " + level.scene_sys.str_current_scene );
	
	if ( !IsDefined( do_hide_weapon ) )
	{
		do_hide_weapon = false;
	}
	
	if ( !IsDefined( do_give_back_weapon ) )
	{
		do_give_back_weapon = false;
	}
	
	if ( !IsDefined( do_not_allow_death ) )
	{
		do_not_allow_death = false;
	}
	
	_basic_actor_setup( str_animname, animation, do_delete );
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].do_hide_weapon = do_hide_weapon;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].do_give_back_weapon = do_give_back_weapon;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].do_not_allow_death = do_not_allow_death;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
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
"OptionalArg: [do_loop] A boolean that needs to be set if it is a looped animation. Default is false."
"OptionalArg: [str_tag] The tag that the model needs to LinkTo and the animation plays off"
"OptionalArg: [a_parts] An array of string tag names that you want to hide on the model. If only one tag is needed to be hidden, you can pass in a single string instead of an array."
"Example: add_actor_model_anim( "woods_model", %generic_human::crew_truck_guy1_sit_idle, "c_usa_jungmar_barnes_pris_fb", undefined, false, "tag_guy8" );"
"SPMP: singleplayer"
@/
add_actor_model_anim( str_animname, animation, str_model, do_delete, str_tag, a_parts )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_actor_model_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( IsDefined( animation ), "animation is a required argument for add_actor_model_anim() in scene, " + level.scene_sys.str_current_scene );
	
	if ( !IsArray( a_parts ) )
	{
		a_parts = array( a_parts );
	}
	
	_basic_actor_setup( str_animname, animation, do_delete );
	
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_model = str_model;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].a_parts = a_parts;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
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
	
	if ( !IsDefined( do_delete ) )
	{
		do_delete = false;
	}

	s_actor = SpawnStruct();
	s_actor.str_name = str_name;
	s_actor.animation = animation;
	s_actor.anim_tree = #animtree;
	s_actor.do_delete = do_delete;
	
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
add_prop_anim( str_animname, animation, str_model, do_delete, is_simple_prop, a_parts, str_tag )
{
	if ( !IsDefined( is_simple_prop ) )
	{
		is_simple_prop = false;
	}
	
	if ( !IsArray( a_parts ) )
	{
		a_parts = array( a_parts );
	}
	
	_basic_prop_setup( str_animname, animation, do_delete, is_simple_prop, "add_prop_anim()" );
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_model = str_model;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].a_parts = a_parts;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
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
	if ( !IsDefined( is_simple_prop ) )
	{
		is_simple_prop = false;
	}
	
	if ( !IsArray( a_parts ) )
	{
		a_parts = array( a_parts );
	}
	
	_basic_prop_setup( str_name, animation, do_delete, is_simple_prop, "add_multiple_props_from_radiant" );
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_name ].a_parts = a_parts;
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
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
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
	
	if ( !IsDefined( do_delete ) )
	{
		do_delete = false;
	}
	
	if ( !IsDefined( is_simple_prop ) )
	{
		is_simple_prop = false;
	}
	
	s_prop_anim = SpawnStruct();
	s_prop_anim.str_name = str_animname;
	s_prop_anim.animation = animation;

	s_prop_anim.do_delete = do_delete;
	s_prop_anim.is_simple_prop = is_simple_prop;
	s_prop_anim.is_model = true;
	
	if ( IsDefined( animtree ) )
	{
		s_prop_anim.anim_tree = animtree;
	}
	else
	{
		s_prop_anim.anim_tree = #animtree;
	}
	
	s_prop_anim _add_anim_to_current_scene();
}

#using_animtree( "player" );
/@
"Name: add_player_anim( <str_animname>, <animation>, [do_delete], [n_player_number], [str_tag], [do_delta], [n_view_fraction], [n_right_arc], [n_left_arc], [n_top_arc], [n_bottom_arc], [use_tag_angles], [b_auto_center] )"
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
add_player_anim( str_animname, animation, do_delete, n_player_number, str_tag, do_delta, n_view_fraction, n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, use_tag_angles, b_auto_center, b_use_camera_tween )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_player_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( IsDefined( animation ), "animation is a required argument for add_player_anim() in scene, " + level.scene_sys.str_current_scene );
	Assert( !IsDefined( level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ] ), "Player model, " + str_animname + ", has already been declared for the scene, " + level.scene_sys.str_current_scene );
	
	if ( !IsDefined( do_delete ) )
	{
		do_delete = false;
	}
	
	if ( !IsDefined( n_player_number ) )
	{
		n_player_number = 0;
	}
	
	if ( !IsDefined( do_delta ) )
	{
		do_delta = false;
	}
	
	if ( !IsDefined( n_view_fraction ) )
	{
		n_view_fraction = 1;
	}
	
	if ( !IsDefined( n_right_arc ) )
	{
		n_right_arc = 180;
	}
	
	if ( !IsDefined( n_left_arc ) )
	{
		n_left_arc = 180;
	}
	
	if ( !IsDefined( n_top_arc ) )
	{
		n_top_arc = 180;
	}
	
	if ( !IsDefined( n_bottom_arc ) )
	{
		n_bottom_arc = 180;
	}
	
	if ( !IsDefined( use_tag_angles ) )
	{
		use_tag_angles = true;
	}
	
	if ( !IsDefined( b_auto_center ) )
	{
		b_auto_center = true;
	}
	
	s_player = SpawnStruct();
	s_player.str_name = str_animname;
	s_player.animation = animation;
	s_player.anim_tree = #animtree;
	s_player.str_model = level.player_interactive_model; // Supports full body models only for now
	s_player.n_player_number = n_player_number;
	s_player.str_tag = str_tag;
	s_player.do_delete = do_delete;
	s_player.do_delta = do_delta;
	s_player.n_view_fraction = n_view_fraction;
	s_player.n_right_arc = n_right_arc;
	s_player.n_left_arc = n_left_arc;
	s_player.n_top_arc = n_top_arc;
	s_player.n_bottom_arc = n_bottom_arc;
	s_player.use_tag_angles = use_tag_angles;
	s_player.b_auto_center = b_auto_center;
	s_player.is_model = true;
	s_player.b_use_camera_tween = b_use_camera_tween;
	
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
	
	if ( !IsDefined( b_animate_origin ) )
	{
		b_animate_origin = true;
	}
	
	_basic_prop_setup( str_animname, animation, do_delete, false, "add_vehicle_anim()", #animtree );
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].a_parts = a_parts;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].is_vehicle = true;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].b_animate_origin = b_animate_origin;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_vehicletype = str_vehicletype;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_model = str_model;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_destructibledef = str_destructibledef;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].do_not_allow_death = do_not_allow_death;
}

_spawn_vehicle_for_anim()
{
	veh = SpawnVehicle( self.str_model, self.str_name, self.str_vehicletype, ( 0, 0 ,0 ), ( 0, 0 ,0 ), self.str_destructibledef );
	maps\_vehicle::vehicle_init( veh );
	veh.animname = self.str_name;
	veh.takedamage = !IS_TRUE( self.do_not_allow_death );
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
	
	if ( !IsDefined( b_animate_origin ) )
	{
		b_animate_origin = true;
	}
	
	_basic_prop_setup( str_animname, animation, do_delete, false, "add_horse_anim()", #animtree );
	
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].a_parts = a_parts;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].str_tag = str_tag;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].is_vehicle = true;
	level.a_scenes[ level.scene_sys.str_current_scene ].a_anim_info[ str_animname ].b_animate_origin = b_animate_origin;
}

/@
"Name: add_notetrack_attach( <str_animname>, <str_notetrack>, <str_model>, <str_tag>, [b_any_scene] )"
"Summary: Attaches a model on the specified tag when the notetrack is hit"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname of an entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <str_model> The name of the model"
"MandatoryArg: <str_tag> The tag that this model is going to be attached to"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_attach( "woods", "binoc_attach", "viewmodel_binoculars", "TAG_WEAPON_LEFT" );"
"SPMP: singleplayer"
@/
add_notetrack_attach( str_animname, str_notetrack, str_model, str_tag, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_attach()" );
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_attach()" );
	Assert( IsDefined( str_model ), "str_model is a required argument for add_notetrack_attach()" );
	Assert( IsDefined( str_tag ), "str_tag is a required argument for add_notetrack_attach()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_attach( str_animname, str_notetrack, str_model, str_tag, str_scene_name );
}

/@
"Name: add_notetrack_detach( <str_animname>, <str_notetrack>, <str_model>, <str_tag>, [b_any_scene] )"
"Summary: Detaches a model on the specified tag when the notetrack is hit"
"Module: Animation"
"CallOn: level"
"MandatoryArg: <str_animname> The animname of an entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <str_model> The name of the model"
"MandatoryArg: <str_tag> The tag that this model is going to be detach from"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_detach( "krav", "detach_radio", "t5_weapon_radio_world", "TAG_WEAPON_LEFT" );"
"SPMP: singleplayer"
@/
add_notetrack_detach( str_animname, str_notetrack, str_model, str_tag, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_detach()" );
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_detach()" );
	Assert( IsDefined( str_model ), "str_model is a required argument for add_notetrack_detach()" );
	Assert( IsDefined( str_tag ), "str_tag is a required argument for add_notetrack_detach()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_detach( str_animname, str_notetrack, str_model, str_tag, str_scene_name );
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
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_level_notify()" );
	Assert( IsDefined( str_notify ), "str_notify is a required argument for add_notetrack_level_notify()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_level_notify( str_animname, str_notetrack, str_notify, str_scene_name );
}

/@
"Name: add_notetrack_custom_function( <str_animname>, <str_notetrack>, <func_pointer>, [b_any_scene] )"
"Summary: Makes the function run when this notetrack is hit"
"Module: Animation"
"MandatoryArg: <str_animname> The animname of the entity"
"MandatoryArg: <str_notetrack> The name of the notetrack"
"MandatoryArg: <func_pointer> The function to call when this notetrack is hit"
"OptionalArg: [b_any_scene] A boolean that needs to be set if this needs to be occured in all scenes. Default is false."
"Example: add_notetrack_custom_function( "bowman", "hit", ::bowman_head_bleed_start );"
"SPMP: singleplayer"
@/
add_notetrack_custom_function( str_animname, str_notetrack, func_pointer, b_any_scene )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_custom_function()" );
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_custom_function()" );
	Assert( IsDefined( func_pointer ), "func_pointer is a required argument for add_notetrack_custom_function()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_customFunction( str_animname, str_notetrack, func_pointer, str_scene_name );
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
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_exploder()" );
	Assert( IsDefined( n_exploder ), "n_exploder is a required argument for add_notetrack_exploder()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_exploder( str_animname, str_notetrack, n_exploder, str_scene_name );
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
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_stop_exploder()" );
	Assert( IsDefined( n_exploder ), "n_exploder is a required argument for add_notetrack_stop_exploder()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_stop_exploder( str_animname, str_notetrack, n_exploder, str_scene_name ); 
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
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_flag()" );
	Assert( IsDefined( str_flag ), "str_flag is a required argument for add_notetrack_flag()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_flag( str_animname, str_notetrack, str_flag, str_scene_name );
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
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_fov()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_fov( str_animname, str_notetrack, str_scene_name );
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
add_notetrack_fx_on_tag( str_animname, str_notetrack, str_effect, str_tag, b_on_threader )
{
	Assert( IsDefined( str_animname ), "str_animname is a required argument for add_notetrack_fx_on_tag()" );
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_fx_on_tag()" );
	Assert( IsDefined( str_effect ), "str_effect is a required argument for add_notetrack_fx_on_tag()" );
	Assert( IsDefined( str_tag ), "str_tag is a required argument for add_notetrack_fx_on_tag()" );
	
	str_scene_name = level.scene_sys.str_current_scene;
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_FXOnTag( str_animname, str_scene_name, str_notetrack, str_effect, str_tag, b_on_threader );
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
	Assert( IsDefined( str_notetrack ), "str_notetrack is a required argument for add_notetrack_sound()" );
	Assert( IsDefined( str_soundalias ), "str_soundalias is a required argument for add_notetrack_sound()" );
	
	str_scene_name = _get_scene_name_for_notetrack( b_any_scene );
	str_animname = _get_animname_for_notetrack( str_animname );
	
	addNotetrack_sound( str_animname, str_notetrack, str_scene_name, str_soundalias );
}

/@
"Name: is_scene_defined( <str_scene_name> )"
"Summary: Checks to see if a scene is defined"
"Module: Animation"
"MandatoryArg: <str_scene_name> The name of the scene to check"
"Example: is_scene_defined( "worker_idle" );"
"SPMP: singleplayer"
@/
is_scene_defined( str_scene_name )
{
	Assert( IsDefined( str_scene_name ), "str_scene_name is a required argument for is_scene_defined()" );

	if ( IsDefined( level.a_scenes[ str_scene_name ] ) )
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
_get_scene_name_for_notetrack( b_any_scene )
{
	str_scene_name = undefined; // todo: remove
	
	if ( !IsDefined( b_any_scene ) )
	{
		b_any_scene = false;
	}

	// The notetrack will occur on a specific scene if b_any_scene is false	
	// If b_any_scene is true, str_scene_name is undefined and the notetrack for any scene in the level
	if ( !b_any_scene )
	{
		str_scene_name = level.scene_sys.str_current_scene;
	}
	
	return str_scene_name;
}

/*==============================================================
SELF: level
PURPOSE: Determine if this animname needs to be 'generic'
RETURNS: The animname that was passed in or 'generic'
CREATOR: JoannaL (04/06/2011)
===============================================================*/
_get_animname_for_notetrack( str_animname )
{
	str_scene_name = level.scene_sys.str_current_scene;
	
	// Make the animname to 'generic' if the scene is generic
	if ( level.a_scenes[ str_scene_name ].do_generic )
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
_preprocess_notetracks()
{
	notetracks = GetNotetracksInDelta( self.animation, .5, 9999 );
	
	foreach ( info in notetracks )
	{
		str_notetrack = info[1];
		str_notetrack_no_comment = StrTok( str_notetrack, "#" )[0];	// strip out comment
		a_tokens = StrTok( str_notetrack_no_comment, " " );
		
		switch ( a_tokens[0] )
		{
			case "exploder":
				
				n_exploder = Int( a_tokens[1] );
				if ( does_exploder_exist( n_exploder ) )
				{
					add_notetrack_exploder( self.str_name, str_notetrack, n_exploder );
				}
				
				break;
				
			case "stop_exploder":
				
				n_exploder = Int( a_tokens[1] );
				if ( does_exploder_exist( n_exploder ) )
				{
					add_notetrack_stop_exploder( self.str_name, str_notetrack, n_exploder );
				}
				
				break;
		}
	}
}