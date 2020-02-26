// _player_rappel.gsc


#include maps\_utility;
#include common_scripts\utility;

/*=============================================================================
-------------------------------------------------------------------------------
-------------------- BASIC SCRIPTER INTERFACE SECTION -------------------------
-------------------------------------------------------------------------------
=============================================================================*/

/@
"Name: rappel_precache()"
"Summary: Precaches everything necesarry for default settings of the rappel system. Call before _load::main()."
"Module: Rappel"
"CallOn: Level"
"Example: rappel_precache();"
"SPMP: singleplayer"
@/
rappel_precache()
{
	// default viewarms for 1h rappel with weapon. should not give SRE if not in memory
	PrecacheModel( "viewmodel_hands_no_model" );  
}
	
/@
"Name: rappel_start( <s_aligned> )"
"Summary: Starts a player controlled rappel from a reference point"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <s_aligned> reference object that the anchor tie animation is aligned to"
"Example: e_player thread rappel_start( s_anchor_point );"
"SPMP: singleplayer"
@/
rappel_start( s_aligned )
{
	Assert( IsDefined( s_aligned ), "s_aligned is a required parameter for rappel_start" );
	
	if( !IsDefined( self._rappel ) )
	{
		self rappel_init_2h();
	}
	
	if ( IsDefined( self._rappel.anims.rappel_viewmodel ) )
	{
		str_viewmodel = self._rappel.anims.rappel_viewmodel;
		Assert( IsAssetLoaded( "xmodel", str_viewmodel ), str_viewmodel + " xmodel is not loaded in memory. make sure custom viewarms are precached before using rappel_start!" );
	}
	
	//self _rappel_anim_loaded_check();
	self._rappel _rappel_init_status( s_aligned ); // in case player uses more than one rappel in the same level, clear these values
	self _rappel_hook_up( s_aligned );
	self _rappel_control_start( s_aligned );
}

/@
"Name: rappel_init_1h()"
"Summary: sets up default one-handed rappel parameters on a player"
"Module: Rappel"
"CallOn: Player"
"Example: e_player rappel_init_1h();"
"SPMP: singleplayer"
@/
rappel_init_1h()
{
	rappel_init_2h(); // initialize everything since most parameters are the same
	
	_rappel_setup_default_anims_1h(); // set up default anims in level.scr_anims array		
	
	self._rappel.controls.allow_weapons = true;
	self._rappel.controls.is_2h_rappel = false;

	self._rappel.strings.rappel_hint = "Press and hold [{+speed_throw}] to rappel";
	self._rappel.strings.brake_hint = "Release [{+speed_throw}] to brake";	
	
	self._rappel.movement.enable_rotation = false;
	self._rappel.movement.is_wall_rappel = false;

	self._rappel.viewcone.link_tag = "tag_player";
	self._rappel.viewcone.right_arc = 90;
	self._rappel.viewcone.left_arc = 50;
	self._rappel.viewcone.top_arc = 80;
	self._rappel.viewcone.bottom_arc = 80;	
	self._rappel.viewcone.use_tag_angles = true;
	self._rappel.viewcone.use_absolute = false;
	self._rappel.difficulty.can_fail = true;
	self._rappel.movement.acceleration = -50;
	self._rappel.movement.brake_frames_max = 15;
	self._rappel.controls.should_grab_rope = false;
	self._rappel.movement.should_charge = false;  // single button control scheme won't work with charging since it depends on compliments
	self._rappel.movement.disable_decend_until_notify = undefined;
	
	self._rappel.movement.threshold_to_ground = 55;
	self._rappel.controls.should_switch_to_sidearm = false;
	self._rappel.anims.rappel_viewmodel = "viewmodel_hands_no_model";
}


/@
"Name: rappel_init_2h()"
"Summary: sets up default two-handed rappel data on a player"
"Module: Rappel"
"CallOn: Player"
"Example: e_player rappel_init_2h();"
"SPMP: singleplayer"
@/
rappel_init_2h()
{	
	self._rappel = SpawnStruct();
	
	_rappel_setup_default_anims_2h();  // set up default anims in level.scr_anims array	
	
	self._rappel _rappel_init_controls();
	self._rappel _rappel_init_anims();
	self._rappel _rappel_init_depth_of_field();	
	self._rappel _rappel_init_movement(); 
	self._rappel _rappel_init_viewcone();
	self._rappel _rappel_init_status();
	self._rappel _rappel_init_difficulty();
	self._rappel _rappel_init_strings();
	
	self._rappel.ent = Spawn( "script_origin", self.origin );	
	
	return self._rappel;
}


/*=============================================================================
-------------------------------------------------------------------------------
-------------------- ACCESSOR FUNCTION INTERFACE SECTION ----------------------
-------------------------------------------------------------------------------
=============================================================================*/

/@
"Name: rappel_set_wall_rappel( <b_is_wall_rappel>, [n_kick_strength_min], [n_kick_strength_max] )"
"Summary: sets rappel data for a wall rappel. This will use kick animations after a charge for two-handed rappel types."
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <b_is_wall_rappel>"
"OptionalArg: [n_kick_strength_min] If using a wall rappel, this will set the minimum kick strength when pushing away from the wall"
"OptionalArg: [n_kick_strength_max] If using a wall rappel, this will set the maximum kick strength when pushing away from the wall"	
"Example: e_player rappel_set_wall_rappel( true );"
"SPMP: singleplayer"
@/
rappel_set_wall_rappel( b_is_wall_rappel, n_kick_strength_min, n_kick_strength_max )
{
	Assert( IsDefined( b_is_wall_rappel ), "b_is_wall_rappel parameter missing for rappel_set_wall_rappel" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_wall_rappel" );
	
	self._rappel.movement.is_wall_rappel = b_is_wall_rappel;
	
	if ( IsDefined( n_kick_strength_min ) && IsDefined( n_kick_strength_max ) )
	{
		self._rappel.movement.impulse_min = n_kick_strength_min;
		self._rappel.movement.impulse_max = n_kick_strength_max;
	}
}

/@
"Name: rappel_set_control_scheme( <func_rappel>, [func_brake] )"
"Summary: sets the controls for a rappel. All input arguments are function pointers that should return a Boolean to check if a player is pressing the desired button. Note that if you're using this function, you'll probably want to set the text strings as well"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <func_rappel> The button that a player should press to jump or descend with a player controlled rappel. This function should return True whenever you want the player to descend."
"OptionalArg: [func_brake] The button a player should press to brake. This should return True when you some scenario is met where you want a player to brake. This button is required for two-handed rappels."
"Example: e_player rappel_set_control_scheme( ::check_for_LT_push, ::check_for_RT_push );"
"SPMP: singleplayer"
@/
rappel_set_control_scheme( func_rappel, func_brake )
{
	Assert( IsDefined( func_rappel ), "func_rappel is missing in rappel_set_control_scheme!" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_control_scheme" );
	
	if ( self _is_2h_rappel() && !IsDefined( func_brake ) )
	{
		AssertMsg( "func_brake is a required parameter for two-handed rappels in rappel_set_control_scheme!" );
	}
	
	self._rappel.controls.rappel_button = func_rappel;
	
	if ( IsDefined( func_brake ) )
	{
		self._rappel.controls.rappel_brake_button = func_brake;
	}
}

/@
"Name: rappel_set_can_fail( <b_can_fail>, [n_drop_speed_before_fail] )"
"Summary: gives a player the ability to fail and fall to death in a player controlled rappel event. Optionally defines how fast a player can drop before failing."
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <b_can_fail> Boolean - can player fail or not?"
"OptionalArg: <n_drop_speed_before_fail> the max speed a player can reach before failing and falling to his death"
"Example: e_player rappel_set_can_fail( true );"
"SPMP: singleplayer"
@/
rappel_set_can_fail( b_can_fail, n_drop_speed_before_fail )
{
	Assert( IsDefined( b_can_fail ), "b_can_fail is missing in rappel_set_can_fail!" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_can_fail" );
	
	self._rappel.difficulty.can_fail = b_can_fail;
	
	if ( IsDefined( n_drop_speed_before_fail ) )
	{
		self._rappel.movement.drop_speed_max = n_drop_speed_before_fail;
	}
}

/@
"Name: rappel_set_drop_and_stop_parameters( <n_speed_drop>, <n_brake_time_min>, <n_brake_time_max> )"
"Summary: Sets drop speed and brake time window parameters for player controlled rappel"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <n_drop_speed> The rate at which the player will drop in the Z direction after rappelling. Scalar quantity."
"MandatoryArg: <n_brake_time_min> The minimum amount of time it will take a player to come to a stop after using the brake mid rappel. Should always be greater than zero."
"MandatoryArg: <n_brake_time_max> The maximum amount of time it will take a player to stop after using the brake mid-rappel. Should be greater than n_brake_time_min"
"Example: e_player rappel_set_drop_and_stop_parameters( 85, 0.05, 1.5 );"
"SPMP: singleplayer"
@/
rappel_set_drop_and_stop_parameters( n_speed_drop, n_brake_time_min, n_brake_time_max )
{
	Assert( IsDefined( n_speed_drop ), "n_speed_drop is a required parameter for rappel_set_drop_and_stop_parameters" );
	Assert( IsDefined( n_brake_time_min ), "n_brake_time_min is a required parameter for rappel_set_drop_and_stop_parameters" );
	Assert( IsDefined( n_brake_time_max ), "n_brake_time_max is a required parameter for rappel_set_drop_and_stop_parameters" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_drop_and_stop_parameters" );
	Assert( ( n_brake_time_min > 0 ), "n_brake_time_min must be at least one frame in duration" );
	Assert( ( n_brake_time_max > n_brake_time_min ), "n_brake_time_max must exceed n_brake_time_min in rappel_set_drop_and_stop_parameters" );
	
	self._rappel.movement.acceleration = Abs( n_speed_drop ) * ( -1 );  // this should always be a negative value since it represents drop
	
	const n_server_frames_per_second = 20;
	
	n_brake_frames_min = Int( Ceil( n_brake_time_min * n_server_frames_per_second ) );  // want at least 1 frame here
	self._rappel.movement.brake_frames_min = n_brake_frames_min;
	
	n_brake_frames_max = Int( n_brake_time_max * n_server_frames_per_second );
	self._rappel.movement.brake_frames_max = n_brake_frames_max;
}


/@
"Name: rappel_set_ground_tolerance_height( <n_height> )"
"Summary: Sets the maximum distance from the ground a player can be that the rappel system will consider to be on the ground and land the player"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <n_height> The distance the rappel system will consider 'on ground'"
"Example: e_player rappel_set_ground_tolerance_height( 55 );"
"SPMP: singleplayer"
@/
rappel_set_ground_tolerance_height( n_height )
{
	Assert( IsDefined( n_height ), "n_height is a required parameter in rappel_set_ground_tolerance_height" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_ground_tolerance_height" );
	
	self._rappel.movement.threshold_to_ground = n_height;
}

/@
"Name: rappel_set_clear_data_after_landing( <b_should_clear_data> )"
"Summary: Determines if player rappel data should be cleared after the player lands. If you keep it around and rappel several times, your settings will stay on the player but cost you script variables and one ent."
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <b_should_clear_data> set to true if you'd like to clear rappel data after player lands."
"Example: e_player rappel_set_clear_data_after_landing( true );"
"SPMP: singleplayer"
@/
rappel_set_clear_data_after_landing( b_should_clear_data )
{
	Assert( IsDefined( b_should_clear_data ), "b_should_clear_data is a required parameter for rappel_set_clear_data_after_landing" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_ground_tolerance_height" );

	self._rappel.status.cleanup_after_landing = b_should_clear_data;
}

/@
"Name: rappel_set_hint_strings( <str_rappel_message>, <str_brake_message> )"
"Summary: sets up strings to print during one-handed rappel"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <str_rappel_message> Control hint string for rappel button. This string will be shown when player control begins. "
"MandatoryArg: <str_brake_message> Control hint for the brake. This string will be shown when the player is mid-rappel.
"Example: e_player rappel_set_hint_strings( &"LEVELNAME_RAPPEL_HINT", &"LEVELNAME_RAPPEL_BRAKE_HINT" );"
"SPMP: singleplayer"
@/
rappel_set_hint_strings( str_rappel_message, str_brake_message )
{
	Assert( IsDefined( str_rappel_message ), "str_rappel_message is a required parameter for rappel_set_hint_strings" );
	Assert( IsDefined( str_brake_message ), "str_brake_message is a required parameter for rappel_set_hint_strings" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_hint_strings" );

	self._rappel.strings.rappel_hint = str_rappel_message;
	self._rappel.strings.brake_hint = str_brake_message;
}

/@
"Name: rappel_set_falling_death_quote( <str_deadquote> )"
"Summary: sets the string to print once the player has fallen to his death after failing a rappel"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <str_deadquote> The string to print once the player has died from falling."
"Example: e_player rappel_set_falling_death_quote( &"LEVELNAME_RAPPEL_FALL_DEATH" );"
"SPMP: singleplayer"
@/
rappel_set_falling_death_quote( str_deadquote )
{
	Assert( IsDefined( str_deadquote ), "str_deadquote is a required parameter for rappel_set_falling_death_quote" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". Run rappel_init_1h or rappel_init_2h before running this function!" );
	
	self._rappel.strings.death_string = str_deadquote;
}

/@
"Name: rappel_set_viewcone( <n_right_arc>, <n_left_arc>, <n_top_arc>, <n_bottom_arc>, <b_use_tag_angles> )"
"Summary: sets the player's viewcone during rappel control section. Note that the input arguments will internally call PlayerLinkToDelta when this function is used rather than PlayerLinkToAbsolute"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <n_right_arc> how far the player can look to the right of the forward vector of the player rig. In degrees."
"MandatoryArg: <n_left_arc> how far the player can look to the left of the forward vector of the player rig. In degrees."
"MandatoryArg: <n_top_arc> how far the player can look up from the forward vector of the player rig. In degrees."
"MandatoryArg: <n_bottom_arc> how far the player can look down relative to the forward vector of the player rig. In degrees."
"MandatoryArg: <b_use_tag_angles> determines how the player's view will be tilted when the player rig is animating. If player view should move along with the tag, this should be set to true."	
"Example: e_player rappel_set_viewcone( 1, 80, 10, 60, 40, true );"
"SPMP: singleplayer"
@/
rappel_set_viewcone( n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles )
{
	Assert( IsDefined( n_right_arc ), "n_right_arc is a required parameter for rappel_set_viewcone" );
	Assert( IsDefined( n_left_arc ), "n_left_arc is a required parameter for rappel_set_viewcone" );
	Assert( IsDefined( n_top_arc ), "n_top_arc is a required parameter for rappel_set_viewcone" );
	Assert( IsDefined( n_bottom_arc ), "n_bottom_arc is a required parameter for rappel_set_viewcone" );
	Assert( IsDefined( b_use_tag_angles ), "b_use_tag_angles is a required parameter for rappel_set_viewcone" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_viewcone" );
	
	self._rappel.viewcone.use_absolute = false; // use PlayerLinkToDelta since we want a view cone
	
	self._rappel.viewcone.right_arc = n_right_arc;
	self._rappel.viewcone.left_arc = n_left_arc;
	self._rappel.viewcone.top_arc = n_top_arc;
	self._rappel.viewcone.bottom_arc = n_bottom_arc;
	self._rappel.viewcone.use_tag_angles = b_use_tag_angles;
}


/@
"Name: rappel_set_depth_of_field_parameters( <n_near_start>, <n_near_end>, <n_far_start>, <n_far_end>, <n_near_blur>, <n_far_blur> )"
"Summary: sets up depth of field parameters for use during a rappel. Internally used by SetDepthOfField()"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <n_near_start> max blur before this distance for near depth of field"
"MandatoryArg: <n_near_end> vision perfectly focused after this distance in near depth of field"
"MandatoryArg: <n_far_start> before this distance, far depth of field is perfectly in focus"	
"MandatoryArg: <n_far_end> after this distance, far depth of field is blurry"	
"MandatoryArg: <n_near_blur> max blur for near depth of field"	
"MandatoryArg: <n_far_blur> max blur for far depth of field"
"Example: e_player rappel_set_depth_of_field_parameters( 5, 33, 0, 0, 4, 0 );"
"SPMP: singleplayer"
@/
rappel_set_depth_of_field_parameters( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur )
{
	Assert( IsDefined( n_near_start ), "n_near_start is a required parameter for rappel_set_depth_of_field_parameters!" );
	Assert( IsDefined( n_near_end ), "n_near_end is a required parameter for rappel_set_depth_of_field_parameters!" );
	Assert( IsDefined( n_far_start ), "n_far_start is a required parameter for rappel_set_depth_of_field_parameters!" );
	Assert( IsDefined( n_far_end ), "n_far_end is a required parameter for rappel_set_depth_of_field_parameters!" );
	Assert( IsDefined( n_near_blur ), "n_near_blur is a required parameter for rappel_set_depth_of_field_parameters!" );
	Assert( IsDefined( n_far_blur ), "n_far_blur is a required parameter for rappel_set_depth_of_field_parameters!" );
	Assert( IsDefined( self._rappel ), "rappel struct has not been set up on entity " + self GetEntityNumber() + ". run rappel_init_1h or rappel_init_2h prior to rappel_set_depth_of_field_parameters!" );
	
	self._rappel.depth_of_field.near_start = n_near_start;
	self._rappel.depth_of_field.near_end = n_near_end;
	self._rappel.depth_of_field.far_start = n_far_start;
	self._rappel.depth_of_field.far_end = n_far_end;
	self._rappel.depth_of_field.near_blur = n_near_blur;
	self._rappel.depth_of_field.far_blur = n_far_blur;
}


/@
"Name: rappel_get_data_struct()"
"Summary: gets the rappel data struct and returns it. You can then store it for any desired purpose."
"Module: Rappel"
"CallOn: Player"
"Example: s_rappel_data = e_player rappel_get_data_struct();"
"SPMP: singleplayer"
@/
rappel_get_data_struct()
{
	Assert( IsDefined( self._rappel ), "rappel data is not set up on entity " + self GetEntityNumber() + "! Run rappel_init functions on this entity before attempting to access rappel data" );
	
	s_rappel_data = self._rappel;
	
	return s_rappel_data;
}


/@
"Name: rappel_set_data_struct( <s_rappel_data> )"
"Summary: sets the rappel data struct to the input one. This can be used with rappel_get_data_struct if you want identical rappel setups in different parts of the same level."
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <s_rappel_data> this is a rappel data struct. you should only be getting this from rappel_get_data_struct()!"
"Example: e_player rappel_set_data_struct( s_old_rappel_data );  // use the same rappel data for the next rappel"
"SPMP: singleplayer"
@/
rappel_set_data_struct( s_rappel_data )
{
	Assert( IsDefined( s_rappel_data ), "s_rappel_data is a required parameter for rappel_set_data_struct" );

	self._rappel = s_rappel_data;
	
	if ( !IsDefined( self._rappel.ent ) )  // normal cleanup functions will delete this ent. remake it if it's missing
	{
		self._rappel.ent = Spawn( "script_origin", self.origin );
	}
}


/@
"Name: rappel_update_anim_set( <a_anims> )"
"Summary: updates any or all of the animations associated with a player rappel. Any undefined aruments will be left in their default state."
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <a_anims> These entries correspond to the scene names of player rig animations. Available anim references: "hookup", "idle_hang", "charge", "charge_loop", "kickoff", "brake", "brake_loop", "fall_start", "fall_loop", "fall_ground_hit", and "land"."
"Example: e_player rappel_update_anim_set( a_new_anims );"
"SPMP: singleplayer"
@/
rappel_update_anim_set( a_anims )
{
	Assert( IsDefined( a_anims ), "a_anims is a required parameter for rappel_update_anim_set" );

	if ( IsDefined( a_anims[ "hookup" ] ) )
	{
		self._rappel.anims.rappel_start = a_anims[ "hookup" ];
	}
	
	if ( IsDefined( a_anims[ "idle_hang" ] ) )
	{
		self._rappel.anims.idle_loop = a_anims[ "idle_hang" ];
	}
	
	if ( IsDefined( a_anims[ "charge" ] ) )
	{
		self._rappel.anims.charge = a_anims[ "charge" ];
	}
	
	if ( IsDefined( a_anims[ "charge_loop" ] ) )
	{
		self._rappel.anims.charge_loop = a_anims[ "charge_loop" ];
	}
	
	if ( IsDefined( a_anims[ "kickoff" ] ) )
	{
		self._rappel.anims.push = a_anims[ "kickoff" ];
	} 
	
	if( IsDefined( a_anims[ "brake" ] ) )
	{
		self._rappel.anims.brake = a_anims[ "brake" ];
	}
	
	if( IsDefined( a_anims[ "brake_loop" ] ) )
	{
		self._rappel.anims.brake_loop = a_anims[ "brake_loop" ];
	}
	
	if ( IsDefined( a_anims[ "fall_start" ] ) )
	{
		self._rappel.anims.fall = a_anims[ "fall_start" ];
	}
	
	if ( IsDefined( a_anims[ "fall_loop" ] ) )
	{
		self._rappel.anims.fall_loop = a_anims[ "fall_loop" ];
	}
	
	if ( IsDefined( a_anims[ "fall_ground_hit" ] ) )
	{
		self._rappel.anims.fall_splat = a_anims[ "fall_ground_hit" ];
	}
	
	if ( IsDefined( a_anims[ "land" ] ) )
	{
		self._rappel.anims.land = a_anims[ "land" ];
	}
}


/@
"Name: rappel_set_viewmodel( <str_viewmodel_name> )"
"Summary: sets the viewmodel of a rappelling player. this will be shown when the player has control mid-rappel"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <str_viewmodel_name> name of the viewmodel to use. make sure to precache this model before rappelling!"
"Example: e_player rappel_set_viewmodel( "new_awesome_viewarms" );"
"SPMP: singleplayer"
@/
rappel_set_viewmodel( str_viewmodel_name )
{
	Assert( IsDefined( str_viewmodel_name ), "str_viewmodel_name is a required parameter for rappel_set_viewmodel!" );
	Assert( IsDefined( self._rappel ), "player rappel is not set up on entity " + self GetEntityNumber() + "! make sure to run rappel_init_1h or rappel_init_2h before calling rappel_set_viewmodel" );
	Assert( IsAssetLoaded( "xmodel", str_viewmodel_name ), "rappel_set_viewmodel could not find xmodel" + str_viewmodel_name + " loaded in memory. Load this in your level CSV!" );

	self._rappel.anims.rappel_viewmodel = str_viewmodel_name;
}

/@
"Name: rappel_pause()"
"Summary: pauses an active rappel so player cannot descend any farther. Acts as though player hit brake. Resume with rappel_resume()"
"Module: Rappel"
"CallOn: Player"
"Example: e_player rappel_pause();"
"SPMP: singleplayer"
@/
rappel_pause()
{
	Assert( IsDefined( self._rappel ), "rappel not initialized on entity " + self GetEntityNumber() + "! Call rappel_init_1h or rappel_init_2h before using rappel_pause" );
	
	screen_message_delete();
	self._rappel.status.can_rappel_now = false;
}

/@
"Name: rappel_resume()"
"Summary: restores player rappel to controllable state"
"Module: Rappel"
"CallOn: Player"
"Example: e_player rappel_resume();"
"SPMP: singleplayer"
@/
rappel_resume()
{
	Assert( IsDefined( self._rappel ), "rappel not initialized on entity " + self GetEntityNumber() + "! Call rappel_init_1h or rappel_init_2h before using rappel_resume" );
		
	_rappel_print_controls_full();
	self._rappel.status.can_rappel_now = true;
}

/@
"Name: rappel_play_custom_anim( <str_animname>, [n_blend_time_to_idle] )"
"Summary: plays a non-looping animation on the player body when stopped mid-rappel"
"Module: Rappel"
"CallOn: Player"
"MandatoryArg: <str_animname> anim reference to play. Make sure this is set up in level.scr_anim[ "player_body" ] before use."
"OptionalArg: [n_blend_time_to_idle] time to blend from single anim to idle. Default = 1 second"
"Example: "
"SPMP: "
@/
rappel_play_custom_anim( str_animname, n_blend_time_to_idle )
{
	self endon( "death" );
	self endon( "_rappel_safe_landing" );
	
	Assert( IsDefined( str_animname ), "str_animname is a required parameter for rappel_play_custom_anim" );
	Assert( IsDefined( level.scr_anim[ "player_body" ][ str_animname ] ), str_animname + " is not set up in level.scr_anim['player_body']! Add this reference before using rappel_play_custom_anim!" );
	Assert( IsDefined( self._rappel ), "rappel not initialized on entity " + self GetEntityNumber() + "! Call rappel_init_1h or rappel_init_2h before using rappel_play_custom_anim" );
	Assert( !self._rappel.status.can_rappel_now, "rappel_play_custom_anim() called while rappel controls were active. call rappel_pause() before rappel_play_custom_anim()!" );
	
	// wait until player body has stopped moving prior to animation
	while( self._rappel.status.is_descending )
	{
		wait 0.05;
	}

	str_idle_loop = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.idle_loop ][0];
	str_idle_stop_notify = self._rappel.anims.idle_stop_notify;
	const n_clear_anim_time = 0.05;  	
	
	if ( !IsDefined( n_blend_time_to_idle ) )
	{
		n_blend_time_to_idle = 1;	
	}

	self DisableWeapons();
	
	// link to 'absolute' for animation
	self Unlink();
	self _rappel_player_link( self.body, true );
	
	// play custom animation, then clear anim body's anim
	self.body maps\_anim::anim_single( self.body, str_animname );	
	
	self.body anim_stopanimscripted();
	
	wait n_clear_anim_time;
	
	self _rappel_enable_weapons_if_allowed();
	self.body SetAnim( str_idle_loop, 1, n_blend_time_to_idle );	
	
	// re-link with previous settings
	self Unlink();
	self _rappel_player_link( self.body );
}

/*=============================================================================
-------------------------------------------------------------------------------
------------------------- INTERNAL FUNCTION SECTION ---------------------------
-------------------------------------------------------------------------------
=============================================================================*/
#using_animtree( "player" );
_rappel_setup_default_anims_2h()
{
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_animtree["player_body"] = #animtree;	
	
	//player rappel
	level.scr_anim["player_body"]["rappel_hookup"]					= %int_rappel_hookup;
	
	level.scr_anim["player_body"]["player_rappel_idle"][0]			= %int_rappel_idle;
	//level.scr_anim["player_body"]["player_rappel_loop"][0]			= %int_rappel_loop;
	
	level.scr_anim["player_body"]["player_rappel_compress"]			= %int_rappel_compress;
	level.scr_anim["player_body"]["player_rappel_compress_loop"][0]	= %int_rappel_compress_loop;
	level.scr_anim["player_body"]["player_rappel_kickoff"]			= %int_rappel_kickoff;
	level.scr_anim["player_body"]["player_rappel_brake"]			= %int_rappel_brake;
	level.scr_anim["player_body"]["player_rappel_brake_loop"][0]	= %int_rappel_brake_loop;
	//level.scr_anim["player_body"]["player_rappel_brake_succeed"]	= %int_rappel_brake_succeed;
	level.scr_anim["player_body"]["player_rappel_2_fall"]			= %int_rappel_2_fall;
	level.scr_anim["player_body"]["player_rappel_fall_loop"][0]		= %int_rappel_fall_loop;
	level.scr_anim["player_body"]["player_rappel_fall_hit_a"]		= %int_rappel_fall_hit_a;
	level.scr_anim["player_body"]["player_rappel_land"]				= %ch_wmd_b01_player_control_rappel_land;
}

// TODO: test
_rappel_anim_loaded_check()
{	
	s_anims = self._rappel.anims;
	
	// animations that'll be common in all rappel logic
	a_animations = array( 	s_anims.rappel_start, s_anims.idle_loop, s_anims.charge, s_anims.charge_loop, 
							s_anims.push, s_anims.brake, s_anims.brake_loop, s_anims.land );
	
	// these animations will only be used if the player can fail his rappel
	if ( self._rappel.difficulty.can_fail )
	{
		a_animations[ a_animations.size ] = s_anims.fall;
		a_animations[ a_animations.size ] = s_anims.fall_loop;
		a_animations[ a_animations.size ] = s_anims.fall_splat;
	}
	
	// loop through all animations that will be used and check if they're loaded in memory
	a_keys = GetArrayKeys( a_animations );
	for ( i = 0; i < a_keys.size; i++ )
	{
		str_anim = level.scr_anim[ self._rappel.anims.body_model ][ a_animations[ a_keys[ i ] ] ];
		//str_anim_asset_name = a_animations[ a_keys[ i ] ];		
		Assert( IsAssetLoaded( "xanim", str_anim ), str_anim + " is not loaded into memory for use with the player rappel system. Include it in your level CSV!" );
	}		
}

#using_animtree( "player" );
_rappel_setup_default_anims_1h()
{
	level.scr_model["player_body"] = level.player_interactive_model;
	level.scr_animtree["player_body"] = #animtree;	
	
//	level.scr_model["rappel_rope"] = "anim_rus_rappel_rope";
//	level.scr_animtree["rappel_rope"] = #animtree;
		
	//player rappel
	level.scr_anim["player_body"]["rappel_hookup"]					= %int_rappel_hookup;
	//addNotetrack_customFunction("player_body", "rumble1", ::rumble_on_hookup, "rappel_hookup");
	
	level.scr_anim["player_body"]["player_rappel_idle"][0]			= %int_rappel_idle;
	//level.scr_anim["player_body"]["player_rappel_loop"][0]			= %int_rappel_loop;
	
	level.scr_anim["player_body"]["player_rappel_compress"]			= %int_rappel_compress;
	level.scr_anim["player_body"]["player_rappel_compress_loop"][0]	= %int_rappel_compress_loop;
	level.scr_anim["player_body"]["player_rappel_kickoff"]			= %int_rappel_kickoff;
	level.scr_anim["player_body"]["player_rappel_brake"]			= %int_rappel_brake;
	level.scr_anim["player_body"]["player_rappel_brake_loop"][0]	= %int_rappel_brake_loop;
	//level.scr_anim["player_body"]["player_rappel_brake_succeed"]	= %int_rappel_brake_succeed;
	level.scr_anim["player_body"]["player_rappel_2_fall"]			= %int_rappel_2_fall;
	level.scr_anim["player_body"]["player_rappel_fall_loop"][0]		= %int_rappel_fall_loop;
	level.scr_anim["player_body"]["player_rappel_fall_hit_a"]		= %int_rappel_fall_hit_a;
	level.scr_anim["player_body"]["player_rappel_land"]				= %ch_wmd_b01_player_control_rappel_land;
}


_rappel_init_strings()  // self = _rappel struct
{
	self.strings = SpawnStruct();
	
	// TODO: add these as string references 
	self.strings.rappel_1h_grab = "Press [{+speed_throw}] to grab rappel rope";
//	self.strings.rappel_1h_rappel = "Press and hold LT to rappel";
//	self.strings.rappel_1h_brake = "Release LT to brake";		
//	self.strings.rappel_1h_rappel = "Release LT to rappel";
//	self.strings.rappel_1h_brake = "Hold LT to brake";
	
	self.strings.rappel_hint = "Charge and release [{+speed_throw}] to rappel";
	self.strings.brake_hint = "Hold [{+attack}] to brake";
	
	self.strings.death_string = "You fell to your death. Try braking earlier to slow your fall.";
}

_rappel_init_difficulty()
{
	self.difficulty = SpawnStruct();
	
	self.difficulty.can_fail = true;
}

_rappel_init_status( s_aligned )
{
	if ( IsDefined( self.status ) )
	{
		self.status = undefined;
	}
	
	self.status = SpawnStruct();
	
	self.status.is_rotating = false;
	self.status.is_descending = false;
	self.status.is_near_ground = false;
	self.status.is_braking = false;
	self.status.falling_to_death = false;
	self.status.can_rappel_now = true;  // use this to selectively toggle the ability to rappel for scripted purposes
	self.status.on_ground = false;
	self.status.cleanup_after_landing = true;  // delete rappel origin and set rappel struct to undefined after landing
	self.status.ground_position = undefined;
	self.status.frames_since_jump = 0;  // internal parameter for calculating how long stop movement should take
	
	if ( IsDefined( s_aligned ) )
	{
		self.status.reference_node = s_aligned;
	}
}

_rappel_init_controls()  // self = rappel struct on player
{
	self.controls = SpawnStruct();
	self.controls.rappel_button = ::_check_rappel_button; 
	self.controls.rappel_brake_button = ::_check_rappel_brake_button;
	self.controls.allow_weapons = false;
	self.controls.is_2h_rappel = true;
	self.controls.should_switch_to_sidearm = false;
}

// these should all be referencing the same .animname, which is whatever the body_model is
_rappel_init_anims()
{
	self.anims = SpawnStruct();
	
	self.anims.anim_tag = "tag_player";  // tag that will be used to link player to animated body
	self.anims.body_model = "player_body";  // model and animname for animated body. spawned in rappel logic
	
	self.anims.rappel_start = "rappel_hookup";  // anchor tie and initial positioning animation
	self.anims.rappel_1h_grab_notify = "rope_grab"; // 1h rappels will pause when this notify is hit and prompt player to grab rope
	
	self.anims.idle_loop = "player_rappel_idle";  // idle hang after anchor tie. should be setup as loop
	self.anims.idle_stop_notify = "stop_rappel_idle_loop";  // notify to be sent out to stop idle hang loop

	self.anims.charge = "player_rappel_compress";  // "charge" animation for when player is 2h jumping
	self.anims.charge_loop = "player_rappel_compress_loop";  // charging loop anim for 2h jumping. should be setup as loop
	
	self.anims.push = "player_rappel_kickoff";  // anim to play when kicking off a surface while rappelling
	
	self.anims.brake = "player_rappel_brake";  // initial brake anim
	self.anims.brake_loop = "player_rappel_brake_loop";  // brake loop. should be setup as loop
	
	self.anims.fall = "player_rappel_2_fall";  // initial fall anim
	self.anims.fall_loop = "player_rappel_fall_loop";  // falling death anim (hands). should be setup as loop
	self.anims.fall_splat = "player_rappel_fall_hit_a";  // contact with ground then death rollover anim
	
	self.anims.land = "player_rappel_land";  // landing animation when rappel has completed	
}

_rappel_init_depth_of_field()
{
	self.depth_of_field = SpawnStruct();
	
	self.depth_of_field.near_start = 5;
	self.depth_of_field.near_end = 33;
	self.depth_of_field.far_start = 0;
	self.depth_of_field.far_end = 0;
	self.depth_of_field.near_blur = 4;
	self.depth_of_field.far_blur = 0;
}

// sets rappel defined depth of field parameters
_rappel_set_depth_of_field( e_player )  // self = player._rappel.<depth of field struct>. works on depth_of_field and depth_of_field_old
{
	Assert( IsDefined( e_player ), "e_player is a required parameter for _rappel_set_depth_of_field!" );
	Assert( IsDefined( e_player._rappel ), "rappel struct is not set up on entity " + e_player GetEntityNumber() + "! Make sure to run rappel_init_1h or rappel_init_2h before calling _rappel_set_depth_of_field!" );
	
	e_player SetDepthOfField( self.near_start, self.near_end, self.far_start, self.far_end, self.near_blur, self.far_blur );
}

// gets and stores depth of field parameters present on player before rappel begins
_rappel_get_depth_of_field_old()  // self = player
{
	self._rappel.depth_of_field_old = SpawnStruct();
	
	self._rappel.depth_of_field_old.near_start = self GetDepthOfField_NearStart();
	self._rappel.depth_of_field_old.near_end = self GetDepthOfField_NearEnd();
	self._rappel.depth_of_field_old.near_blur = self GetDepthOfField_NearBlur();
	self._rappel.depth_of_field_old.far_blur = self GetDepthOfField_FarBlur();	
	self._rappel.depth_of_field_old.far_start = self GetDepthOfField_FarStart();
	self._rappel.depth_of_field_old.far_end = self GetDepthOfField_FarEnd();	
}

// this gets called with PlayerLinkToDelta
_rappel_init_viewcone()
{
	self.viewcone = SpawnStruct();
	
	self.viewcone.link_tag = "tag_player";
	self.viewcone.percentage = 0; 
	self.viewcone.right_arc = 0;
	self.viewcone.left_arc = 0;
	self.viewcone.top_arc = 0;
	self.viewcone.bottom_arc = 0;
	self.viewcone.use_tag_angles = true;
	self.viewcone.use_absolute = true;  // will use PlayerLinkToAbsolute instead of PlayerLinkToDelta
	
	self.viewcone.threshold_edge = 1;  // number of degrees from edge a player can be from edge to return hit
}

_rappel_init_movement()
{
	self.movement = SpawnStruct();
	self.movement.rotate_speed = 10;  // TODO
	self.movement.threshold_to_ground = 55;  // number of units from ground a player can be before "on ground"
	self.movement.enable_rotation = false;
	self.movement.is_wall_rappel = true;  // will use impulse calculation if set to true
	
	self.movement.acceleration = -85;  // WMD: -85
	self.movement.impulse_min = 160; 
	self.movement.impulse_max = 260;	
	
	self.movement.drop_speed_max = 60;
	
	self.movement.brake_frames_min = 1;
	self.movement.brake_frames_max = 30;
	self.movement.should_charge = true;
}

_check_rappel_button()  // self = player
{
	b_is_rappelling = self ThrowButtonPressed(); 
	return b_is_rappelling;
}

_check_rappel_brake_button()
{
	b_is_braking =  self AttackButtonPressed();
	return b_is_braking;
}

// control logic - checks to see if appropriate button is bring pressed for use with rappel
_descent_control_active()
{
	b_is_2h_rappel = self _is_2h_rappel();
	
	if ( b_is_2h_rappel )
	{
		b_control_active = self _is_pressing_rappel_button();
	}
	else 
	{
		b_control_active = self _is_pressing_rappel_button();
	}
	
	return b_control_active;
}

_is_pressing_rappel_button()
{
	b_is_rappelling = false; 
	
	// control logic for 2h rappel: PRESS rappel button to start rappel
	if ( self _is_2h_rappel() )
	{
		if ( self [[ self._rappel.controls.rappel_button ]]() )
		{
			b_is_rappelling = true;
		}
	}
	else   // control logic for 1h rappel: PRESS rappel button to start rappel
	{
		if ( self [[ self._rappel.controls.rappel_button ]]() )
		{
			b_is_rappelling = true;
		}		
	}

	
	return b_is_rappelling;
}



// plays anchor tie animation that's referenced in _rappel struct
_rappel_hook_up( s_aligned )  // self = player
{
	self DisableWeapons();
	
	self playsound ("evt_rappel_hookup");
	
	self.body = spawn_anim_model( self._rappel.anims.body_model, self.origin );
	self.body.angles = self.angles;  // 2d only for now
	self.body Hide();
	
	//self.body SetClientFlag( 6 );  // for scrolling rope texture
	
	self thread _1h_rappel_start( s_aligned );
	s_aligned thread maps\_anim::anim_single_aligned( self.body, self._rappel.anims.rappel_start );
	
	wait 0.05; // frame end?
	self StartCameraTween( 0.2 );
	
	// player -> body -> origin
	self _rappel_player_link( self.body, true );
	
	wait 0.3;
	
	self.body Show();
	self _rappel_get_depth_of_field_old();  // cache old values for depth of field to restore on landing
	self._rappel.depth_of_field _rappel_set_depth_of_field( self );
	// TODO: create rope
	
	// switch to sidearm if requested by script
	self thread _rappel_switch_to_sidearm();
	
	s_aligned waittill( self._rappel.anims.rappel_start );
	
	self notify( "rappel_hookup_done" );
//	iprintlnbold( "HOOKUP DONE" );
}

// if 1h rappel is active, controls are different. player is prompted with control scheme below 
_1h_rappel_start( s_aligned )
{
	b_is_2h_rappel = self _is_2h_rappel();
	b_require_input_for_grab = self._rappel.controls.should_grab_rope;
	//iprintlnbold( "1h rappel check: " + b_is_2h_rappel );
	
	if ( !b_is_2h_rappel && b_require_input_for_grab )
	{
		str_hookup_anim = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.rappel_start ];
		n_hookup_anim_length = GetAnimLength( str_hookup_anim );
		n_hookup_control_delay = n_hookup_anim_length * 0.95;
		n_notify_delay = n_hookup_anim_length - n_hookup_control_delay;
		str_grab_notify = self._rappel.anims.rappel_1h_grab_notify;
		
		const n_transition_time = 0;
		
		self waittill_notify_or_timeout( str_grab_notify, n_hookup_control_delay );
		//wait n_hookup_control_delay;
		//iprintlnbold( "PAUSE" );
		
		self.body SetAnimLimited( str_hookup_anim, 1, n_transition_time, 0 );
		
		screen_message_create( self._rappel.strings.rappel_1h_grab );
		
		while( !( self _is_pressing_rappel_button() ) )
		{
			wait 0.05;
		}
		
		self.body SetAnimLimited( str_hookup_anim, 1, n_transition_time, 1 );
		
		screen_message_delete();
		
		//iprintlnbold( "UNPAUSED" );
		
		wait n_notify_delay;
		
		s_aligned notify( self._rappel.anims.rappel_start );
	}
}

_rappel_player_link( e_to_link, b_no_viewlook )  // self = player
{
	Assert( IsDefined( e_to_link ), "_rappel_player_link is missing e_to_link parameter" );

	if ( !IsDefined( b_no_viewlook ) )
	{
		b_no_viewlook = false;
	}
	
	b_use_absolute = self._rappel.viewcone.use_absolute;
		
	if ( b_use_absolute )
	{
		self PlayerLinkToAbsolute( e_to_link, self._rappel.viewcone.link_tag );
//		iprintlnbold( "linked with absolute" );
	}
	else if ( !b_use_absolute && b_no_viewlook )
	{
		//iprintlnbold( "using PlayerLinkTo" );
		const n_view_percentage_fraction = 80;
		const b_use_tag_angles = true;
		self PlayerLinkToDelta( e_to_link, self._rappel.viewcone.link_tag, n_view_percentage_fraction, 0, 0, 0, 0, b_use_tag_angles ); // simulated PlayerLinkToAbsolute
	}
	else 
	{
		self PlayerLinkToDelta( e_to_link, self._rappel.viewcone.link_tag, self._rappel.viewcone.percentage, 
			self._rappel.viewcone.right_arc, self._rappel.viewcone.left_arc, self._rappel.viewcone.top_arc, 
			self._rappel.viewcone.bottom_arc, self._rappel.viewcone.use_tag_angles );		
//		iprintlnbold( "linked with delta" );
	}
}

// print both rappel and brake control buttons
_rappel_print_controls_full()
{
	screen_message_delete();  // remove current screen message if one exists
	
//	if ( self _is_2h_rappel() )
//	{
//		str_line_1 = self._rappel.strings.rappel_2h_rappel;
//		str_line_2 = self._rappel.strings.rappel_2h_brake;
//	}
//	else 
//	{
//		str_line_1 = self._rappel.strings.rappel_1h_rappel;
//		str_line_2 = self._rappel.strings.rappel_1h_brake;
//	}
	str_line_1 = self._rappel.strings.rappel_hint;
	str_line_2 = self._rappel.strings.brake_hint;
	
	screen_message_create( str_line_1, str_line_2 );
}

// print only brake control prompts (for use with rappel descent)
_rappel_controls_print_brake()
{
	screen_message_delete();  // remove current screen message if one exists
	
//	if ( self _is_2h_rappel() )
//	{
//		str_brake = self._rappel.strings.rappel_2h_brake;
//	}
//	else 
//	{
//		str_brake = self._rappel.strings.rappel_1h_brake;
//	}	
	str_brake = self._rappel.strings.brake_hint;
	
	if ( IsDefined( str_brake ) && ( str_brake != "" ) )
	{
		screen_message_create( str_brake );
	}
}

_rappel_control_start( s_aligned )
{
	self endon( "_rappel_falling_death" );
	const n_delay = 0.05;

	//iprintlnbold( "player control starts" );
	_rappel_print_controls_full();
	
	// allow player to look around now that rappel anim is done if desired
	self Unlink();
	self _rappel_player_link( self.body );  // used to be 0,0,0,0 angle cap. now supports view look
	
	self._rappel.ent.origin = self.origin;
	self._rappel.ent.angles = self GetPlayerAngles();
	self.body LinkTo( self._rappel.ent );  

	self.body thread maps\_anim::anim_loop( self.body, self._rappel.anims.idle_loop, self._rappel.anims.idle_stop_notify );

	// set up viewmodel here, if one exists (example: make it look like one handed firing)
	if ( IsDefined( self._rappel.anims.rappel_viewmodel ) )
	{
		self SetViewModel( self._rappel.anims.rappel_viewmodel );  
	}	
	
	self _rappel_enable_weapons_if_allowed();
	
	if ( IsDefined( self._rappel.movement.disable_decend_until_notify ) )
	{
		self waittill( self._rappel.movement.disable_decend_until_notify );
	}
	
	self AllowAds( false );  // left hand busy with rappel line; don't ADS
			
	while ( !self._rappel.status.is_near_ground )
	{
		if ( self _descent_control_active() && !self._rappel.status.is_descending && self._rappel.status.can_rappel_now )
		{
//			IPrintlnbold( "descent started" );
			self thread _rappel_descend();
			self thread decend_sound();
		}
		
		if ( self._rappel.movement.enable_rotation )
		{
			v_angles_player_forward = self.angles; // 2d only. top and bottom view cone are static
			v_angles_player_forward = AnglesToForward( v_angles_player_forward );
			v_angles_player_forward = _rappel_vector_remove_z( v_angles_player_forward );
			
			v_angles_body_forward = AnglesToForward( self.body.angles );	
			v_angles_body_forward = _rappel_vector_remove_z( v_angles_body_forward );
			v_angles_body_right = AnglesToRight( self.body.angles );
			
			n_dot_forward_view = VectorDot( v_angles_body_forward, v_angles_player_forward );
			n_degrees_from_center = ACos( n_dot_forward_view );
			
			n_dot_right = VectorDot( v_angles_body_right, v_angles_player_forward );
			
			b_is_looking_right = ( n_dot_right > 0 );
		
			n_viewcone_left = self._rappel.viewcone.left_arc;
			n_viewcone_right = self._rappel.viewcone.right_arc;
			
			// TODO: cache these values so we don't look up every frame? though what if view can change mid-rappel?
			b_at_left_edge = ( ( !b_is_looking_right ) && ( ( self._rappel.viewcone.left_arc - self._rappel.viewcone.threshold_edge ) < n_degrees_from_center ) );
			b_at_right_edge = ( ( b_is_looking_right ) && ( ( self._rappel.viewcone.right_arc - self._rappel.viewcone.threshold_edge ) < n_degrees_from_center ) );

			// rotation section
			v_movement = self GetNormalizedCameraMovement();
		//	iprintln( v_movement );
			
			n_movement_y = v_movement[ 1 ];  // y component of movement vector
			//v_rotate_speed = ( 0, 50, 0 );  // TODO: cache?	
			//n_rotate_angle = 60;  // TODO: cache
			const n_rotate_angle = 20;
			
			if ( b_at_left_edge )
			{
				if ( ( n_movement_y <= -0.2 ) && !self._rappel.status.is_rotating )
				{
					iprintlnbold( "rotating left" );
					self thread _rappel_rotate_origin( n_rotate_angle );
				}				
			}
			else if ( b_at_right_edge )
			{			
				if ( ( n_movement_y >= 0.2 ) && !self._rappel.status.is_rotating )
				{
					iprintlnbold( "rotating right" );
					self thread _rappel_rotate_origin( n_rotate_angle * -1 );
				}								
			}			
		}
		
		wait n_delay;
	}
		
	self _rappel_landing();
	self _rappel_cleanup();
}

_rappel_enable_weapons_if_allowed()
{
	if ( self._rappel.controls.allow_weapons )
	{		
		self ShowViewModel();
		self EnableWeapons();
	}	
}

// if desired by script, switch to sidearm (preferably 1-handed) when starting rappel with weapon
_rappel_switch_to_sidearm()
{
	if ( self._rappel.controls.should_switch_to_sidearm )
	{
		//iprintlnbold( "switching to sidearm" );
		a_weapon_list = self GetWeaponsList();
		
		for ( i = 0; i < a_weapon_list.size; i++ )
		{
			str_class = WeaponClass( a_weapon_list[ i ] );
			
			if ( str_class == "pistol" )
			{
				self SwitchToWeapon( a_weapon_list[ i ] );
			}
		}
	}
}

// handle landing
_rappel_landing()
{
	//iprintlnbold( "hit landing function" );
	screen_message_delete();
	level.player stoploopsound (.25);
	level.player playsound ("fly_land_plr_default");
	
	if ( !self._rappel.status.falling_to_death )
	{
		//iprintlnbold( "landing now" );

		
		self notify( "_rappel_safe_landing" ); 
		
		self DisableWeapons();
		self reset_near_plane();
		self.body ClearAnim( %root, 0.2 );
		// TODO: anim can put player through wall if it contains forward motion. talk to animation department about movement post landing
		self.body maps\_anim::anim_single( self.body, self._rappel.anims.land );  
		// TODO: make sure player is flat on ground?
		
		self Unlink();
		
		self.body Hide();
		self.body Delete();
		
		self AllowAds( true );
		
		// if we used a custom viewmodel for hands during 1h rappel, reset to original model
		if ( IsDefined( self._rappel.anims.rappel_viewmodel ) )
		{
			str_viewmodel = level.player_viewmodel;
			self SetViewModel( str_viewmodel );
		}
		
		self._rappel.depth_of_field_old _rappel_set_depth_of_field( self );
		self EnableWeapons();		
	}	
}

_rappel_cleanup()
{
	if ( self._rappel.status.cleanup_after_landing )
	{
		self._rappel.ent Delete();
		self._rappel = undefined;
	}
}

//Eckert - handles decending sounds
decend_sound()
{
	self endon( "_rappel_safe_landing" );

	if (self._rappel.status.is_descending == true)
	{
		level.player playloopsound ("evt_rappel_slide");
		//iprintlnbold ("decending sound");
	}
	else
	{
		level.player stoploopsound (.25);
	}
	
}


_rappel_descend()
{
	Assert( IsDefined( self._rappel ), "rappel struct not set up! can't use _rappel_descend" );

	self._rappel.status.is_descending = true;
	
	
	const n_delay = 0.05;
	n_charge_time = 0;
	const n_charge_time_full = 1;  // TODO: charge anim length??
	b_is_fully_charged = false;
	str_idle_loop = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.idle_loop ][0];
	str_charge_anim = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.charge ];
	n_charge_anim_length = GetAnimLength( str_charge_anim );
	str_charge_loop_anim = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.charge_loop ][0];	
	b_should_charge = self._rappel.movement.should_charge;
	
	self.body anim_stopanimscripted();

	
	if ( b_should_charge )
	{
		//iprintlnbold( "charge anim time: " + n_charge_anim_length );
		self.body SetAnim( str_charge_anim, n_charge_anim_length );
		self thread notify_delay_with_ender( "_rappel_start_charge_loop", n_charge_anim_length, "_rappel_jump_start" );
		self thread _rappel_charge_loop_starter( str_charge_loop_anim, n_charge_time_full );
		

		
		// figure out how long rappel charge is based on button input
		while ( self _is_pressing_rappel_button() && b_should_charge )
		{
			n_charge_time += 0.05;
			wait n_delay;
		}
	}

	if ( !IsDefined( self._rappel.status.ground_position ) )
	{
		self._rappel.status.ground_position = self _rappel_get_ground_trace_position();  // cache ground position for single jump in case of death
	}	
	
	_rappel_controls_print_brake();  // print brake controls now that player has started rappel
	
	if ( n_charge_time >= n_charge_time_full )
	{
		n_charge_time = n_charge_time_full; // clamp to full
		b_is_fully_charged = true;
	}
	
	self thread _rappel_jump( n_charge_time );	
	self _rappel_brake( n_charge_time );
}

_rappel_charge_loop_starter( str_charge_loop_anim, n_charge_time_full )
{
	self endon( "_rappel_jump_start" );
	
	self waittill( "_rappel_start_charge_loop" );
	
	self.body SetAnimKnobAll( str_charge_loop_anim, %root, 1, n_charge_time_full, 1 );
}

// handle rappel jump anims and (internally) fall movement logic
_rappel_jump( n_charge_time )
{
	self endon( "_rappel_safe_landing" );
	self notify( "_rappel_jump_start" );
	n_acceleration_base = self._rappel.movement.acceleration;
	n_impulse_min = self._rappel.movement.impulse_min;
	n_impulse_max = self._rappel.movement.impulse_max;
	
	self._rappel.status.is_braking = false;
	
	n_scale = n_impulse_min + ( ( n_impulse_max - n_impulse_min ) * n_charge_time );
	v_velocity = ( 0, 0, 0 );
	
	if ( self._rappel.movement.is_wall_rappel )
	{
		v_wall_normal = self _rappel_get_wall_normal();
		v_velocity = v_wall_normal * -1 *  n_scale;
	}
	
	// actual movement done inside this function (sets .origin manually per frame)
	self thread _rappel_fall( v_velocity );	
	
	// idle to jump anim setup here
	self.body ClearAnim( %root, 1 );
	
	str_push_anim = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.push ];
	str_idle_loop_anim = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.idle_loop ][0];
	n_anim_time_push = GetAnimLength( str_push_anim );	

	const n_delay = 0.05;
	n_counter = 0;
	
	self.body SetAnim( str_push_anim, 1, n_anim_time_push );   // old = default
	
	while ( self _is_freefalling() )
	{		
		if ( n_counter < n_anim_time_push )
		{
			n_counter += n_delay;
		}
		else
		{
			//iprintlnbold( "loop anim now" );
			self.body SetAnimKnobAll( str_idle_loop_anim, %root, 1, n_anim_time_push, 1 );
			break;
		}
		
		wait n_delay;
	}
}

// handle fall movement
_rappel_fall( v_velocity )
{
	self endon( "_rappel_safe_landing" );
	self endon( "_rappel_stop_movement" );
	
	if ( !IsDefined( self._rappel.movement.acceleration_per_frame ) )
	{
		self._rappel.movement.acceleration_per_frame = self._rappel.movement.acceleration / 20;
	}
	
	self._rappel.status.frames_since_jump = 0;
	
	
	if ( !IsDefined( self._rappel.status.ground_position ) )
	{
//		IPrintLnBold( "initializing ground trace" );
		self._rappel.status.ground_position = self _rappel_get_ground_trace_position();  // cache ground position for single jump in case of death
	}
	
	v_ground_pos = self._rappel.status.ground_position;
	
	n_counter_threshold = self _rappel_get_frames_to_threshold();  // max frames before wall push motion will be removed
	
	n_counter = 0;
	const n_delay = 0.05;
	n_fail_speed = self._rappel.movement.drop_speed_max;	
	v_velocity_per_frame = v_velocity / n_counter_threshold;  // divide by zero error?
	v_drop_per_frame = ( 0, 0, self._rappel.movement.acceleration_per_frame );	
	
	// falling motion
	while ( self _is_freefalling() )
	{
		if ( n_counter > n_counter_threshold )  // don't continue with push velocity after one second
		{
			v_velocity_per_frame = ( 0, 0, 0 );
		}
	
		v_fall_vector_current =  v_velocity_per_frame + ( v_drop_per_frame * n_counter );
		v_new_position = self._rappel.ent.origin + v_fall_vector_current;
		n_distance_to_ground = Distance( self.origin, v_ground_pos );		
		b_next_point_above_threshold = self _is_above_threshold();
		
		if ( !b_next_point_above_threshold )
		{
//			IPrintLnBold( "near ground" );
			self._rappel.status.is_near_ground = true;
		}
		
		b_is_point_below_threshold = ( self._rappel.movement.threshold_to_ground > n_distance_to_ground );	
		b_is_point_above_ground = self _is_point_above_ground( v_new_position, v_ground_pos );
		
		if ( !b_is_point_above_ground || b_is_point_below_threshold )
		{
			self._rappel.status.is_near_ground = true;
			self._rappel.status.on_ground = true;
			
			if ( !self._rappel.status.falling_to_death )
			{
				self._rappel.difficulty.can_fail = false;
				//self notify( "_rappel_safe_landing" );
				self notify( "_rappel_stop_movement" );
			}
		}			
		
		n_drop_this_frame = Abs( v_fall_vector_current[ 2 ] );  // vertical movement magnitude
//		iprintlnbold( n_drop_this_frame + " drop speed " );
		
		self._rappel.ent.origin = v_new_position;
		
		// check for fall death
		if ( ( self._rappel.difficulty.can_fail ) && ( n_drop_this_frame > n_fail_speed ) && ( !self._rappel.status.falling_to_death ) ) // TODO: absolute values?
		{
			self thread _rappel_do_falling_death();
		}
		
		n_counter++;
		self._rappel.status.frames_since_jump = n_counter;
		wait n_delay;
	}	
}

_rappel_get_frames_to_threshold()
{
	// if we have less than 20 frames to hit ground, player will go through wall. scale here
	//n_frames_to_ground = 0;
	n_distance_after_frames = 0;
	n_drop_speed = Abs( self._rappel.movement.acceleration_per_frame );
	n_distance_to_ground = self _rappel_get_distance_to_ground();
	n_distance_to_threshold = n_distance_to_ground - self._rappel.movement.threshold_to_ground;
	const n_cutoff_threshold = 20;  // max frames we will ever return
	n_distance_after_frames = 0;  // distance counter variable
	n_frames_to_threshold = 0;  // frame counter variable
	
	while ( n_distance_after_frames < n_distance_to_threshold )
	{
		n_distance_after_frames += ( ( n_frames_to_threshold + 1 ) * n_drop_speed );  // increment by one so we don't calculate zero movement on first frame
		
		n_frames_to_threshold++;
	}	
	
	n_frames_to_threshold = clamp( n_frames_to_threshold, 1, n_cutoff_threshold );
	
	return n_frames_to_threshold;
}

// check to see if movement position is above safe landing threshold
_is_above_threshold()
{
	b_is_above_threshold = true; 
	
	n_threshold_height = self._rappel.movement.threshold_to_ground;
	
	n_distance_to_ground = self _rappel_get_distance_to_ground();
	
	if ( n_threshold_height > n_distance_to_ground )
	{
		b_is_above_threshold = false;
	}
	
	return b_is_above_threshold;
}

// make sure point is above ground so player movement doesn't go through geo on landing
_is_point_above_ground( v_next_position, v_ground_position )
{
	b_is_above_ground = true; 
	
	n_height_next = v_next_position[ 2 ];
	n_height_ground = v_ground_position[ 2 ];
	
	if ( n_height_ground > n_height_next )
	{
		b_is_above_ground = false;
	}
	
	return b_is_above_ground;	
}

// handle falling death scenario
_rappel_do_falling_death()
{
//	iprintlnbold( "falling to death!" );
	self playsound ("evt_rappel_fail");
	screen_message_delete();
	self DisableWeapons(); 
	self notify( "_rappel_falling_death" );
	self._rappel.status.falling_to_death = true;
	str_fall_death = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.fall ];
	str_fall_death_loop = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.fall_loop ][0];
	str_fall_death_splat = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.fall_splat ];
	const n_blend_time = 0.2;
	n_anim_length = GetAnimLength( str_fall_death );
	str_deadquote = self._rappel.strings.death_string;
	
	self.body SetAnimKnobAll( str_fall_death, %root, 1, n_blend_time, 1 );
	
	n_counter = 0;
	const n_wait_time = 0.05;
	
	while ( !self._rappel.status.on_ground )  
	{
		if ( n_counter < n_anim_length )
		{
			n_counter += n_wait_time;
		}
		else 
		{
			self.body SetAnimKnobAll( str_fall_death_loop, %root, 1, n_blend_time, 1 );
		}
		
		wait n_wait_time;
	}
	
	// move to real ground so anims line up
	v_ground_pos = self._rappel.status.ground_position;
	v_offset = ( 0, 0, 10 );  // eye level may be through ground, so offset a bit in Z
	self._rappel.ent MoveTo( v_ground_pos + v_offset, 0.05 );
	
	n_fall_death_length = GetAnimLength( str_fall_death_splat );
	self.body SetAnimKnobAll( str_fall_death_splat, %root, 1, 0, 1 );	
	Earthquake( 1.0, 0.5, self.origin, 500 );
	wait n_fall_death_length;
	SetDvar( "ui_deadquote", str_deadquote );
	MissionFailed();
}

// checks to see if rappel is 2h 
_is_2h_rappel()
{
	b_is_2h_rappel = self._rappel.controls.is_2h_rappel;
	return b_is_2h_rappel;
}

_is_pressing_brake_button()
{	
	// brake logic for 2h rappel: unique button for brake
	if ( self _is_2h_rappel() )
	{
		b_is_pressing_brake = self [[ self._rappel.controls.rappel_brake_button ]]();
	}
	else  // brake logic for 2h rappel: same button to start and stop rappel descent. return compliment
	{
		b_is_pressing_brake = !( self [[ self._rappel.controls.rappel_button ]]() );  // DO NOT ALLOW CHARGE MOVEMENT FOR 1H RAPPEL! logic breaks
	}
	
	return b_is_pressing_brake;
}


_rappel_brake( n_charge_time )
{
	self endon( "_rappel_safe_landing" );  
	self endon( "_rappel_falling_death" );
	
	if ( !IsDefined( self._rappel.movement.acceleration_per_frame ) )
	{
		self._rappel.movement.acceleration_per_frame = self._rappel.movement.acceleration / 20;
	}
	
	self._rappel.status.is_braking = false;
	
	while ( !( self _is_pressing_brake_button() ) && self._rappel.status.can_rappel_now )
	{
		wait 0.05;
	}
	
//	iprintlnbold( "rappel brake detected" );
	
	// put player back on wall if he jumped before
	n_frames_to_stop_min = self._rappel.movement.brake_frames_min; 
	n_frames_to_stop_max = self._rappel.movement.brake_frames_max;
	b_is_short_stop = false;
	
	n_frames_since_jump = self._rappel.status.frames_since_jump;
	
	if ( self._rappel.status.frames_since_jump > n_frames_to_stop_max )
	{
		n_frames_since_jump = n_frames_to_stop_max;
	}
	
	n_frames_to_stop = Int( n_frames_to_stop_min + ( ( n_frames_to_stop_max - n_frames_to_stop_min ) * ( n_frames_since_jump / n_frames_to_stop_max ) ) );

//	iprintlnbold( "frames to stop: " + n_frames_to_stop );
	
	// check to make sure we have enough distance to stop above ground
	n_distance_to_ground = self _rappel_get_distance_to_ground();
	n_distance_left_to_stop = n_distance_to_ground - self._rappel.movement.threshold_to_ground;
	
	n_required_distance_to_stop = 0;
	for ( i = 0; i < n_frames_to_stop; i++ )
	{
		if ( n_required_distance_to_stop > n_distance_left_to_stop )
		{
//			IPrintLnBold( "short stop required" );
			n_frames_to_stop = i;
			
			if ( i == 0 )
			{
				n_frames_to_stop = 1;  // divide by zero check
			}
			
			b_is_short_stop = true;
			
			break;
		}
		
		n_required_distance_to_stop += Abs( self._rappel.movement.acceleration_per_frame * ( i + 1 ) );
	}
	
	if ( b_is_short_stop && self._rappel.difficulty.can_fail )
	{
		self thread _rappel_do_falling_death();
		return;
	}
	
	self._rappel.status.is_braking = true;  // error checking is done, so we're actually braking now
	
	if ( self._rappel.status.can_rappel_now )
	{
		_rappel_print_controls_full();
	}
	
	v_movement_down = ( 0, 0, self._rappel.movement.acceleration_per_frame );
	v_to_wall = ( 0, 0, 0 );
	
	if ( self._rappel.movement.is_wall_rappel )  // don't push to wall on short stop since we're landing
	{
		v_to_wall = self _rappel_get_wall_vector();
//		iprintlnbold( "to wall + " + v_to_wall );
		v_to_wall = _rappel_vector_remove_z( v_to_wall );
	}	
	
	v_to_wall_per_frame = v_to_wall / n_frames_to_stop;
	
	str_brake_anim = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.brake ];
	str_brake_loop_anim = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.brake_loop ][ 0 ];
	n_brake_anim_length = GetAnimLength( str_brake_anim );
	
	n_time_to_stop = n_frames_to_stop * 0.05;
	
	self.body SetAnimKnobAll( str_brake_anim, %root, 1, 0, 1 );
	
	v_distance_traveled = ( 0, 0, 0 );
	// slow down then stop movement
	for ( i = n_frames_to_stop; i > 0; i-- )
	{
		v_distance_traveled += ( i * v_movement_down );
		v_movement_current = v_to_wall_per_frame + ( i * v_movement_down );
		v_new_position = self._rappel.ent.origin + v_movement_current;
		self._rappel.ent.origin = v_new_position;
		
		wait 0.05;
	}

	
//	iprintlnbold( "distance traveled: " + v_distance_traveled );
	
	const n_blend_time = 0.5;
	self.body SetAnimKnobAll( str_brake_loop_anim, %root, 1, n_blend_time, 1 );
	
	wait n_blend_time;
	// enable rappel again
	self._rappel.status.is_descending = false;

	self thread _rappel_brake_then_idle();
}

_rappel_brake_then_idle()
{
	self endon( "_rappel_jump_start" );
	

	
	wait 1;

	str_idle_loop = level.scr_anim[ self._rappel.anims.body_model ][ self._rappel.anims.idle_loop ][0];
	const n_blend_time = 1;
	self.body SetAnim( str_idle_loop, 1, n_blend_time );
}

_is_freefalling()
{
	b_is_freefalling = true;
	
	if ( self._rappel.status.on_ground || self._rappel.status.is_braking )
	{
		b_is_freefalling = false;
	}
	
	return b_is_freefalling;
}

// get a vector to the wall. this will be used as final position for player touching wall again so it
// is scaled back a bit so player model doesn't clip through the wall. 
_rappel_get_wall_vector()
{
	v_normal = self _rappel_get_wall_normal();
	const n_scale = 999999;
	const n_target_distance_from_wall = 30;  // TODO: talk with animators about solution to this; open up to _rappel struct
	
	v_scaled = v_normal * n_scale; 
	a_trace = BulletTrace( self.origin, v_scaled, false, undefined );
	
	v_hit = a_trace[ "position" ];
	
	v_to_wall = v_hit - self.origin;
	v_from_wall = self.origin - v_hit;
	v_from_wall_normalized = VectorNormalize( v_from_wall );
	v_offset = v_from_wall_normalized * n_target_distance_from_wall;
	v_to_wall_final = v_to_wall + v_offset;
	
	return v_to_wall_final;
}

_rappel_get_wall_normal()
{
	Assert( IsDefined( self._rappel.status.reference_node ), "missing reference node for _rappel_get_wall_normal" );
	
	v_node_normal = AnglesToForward( self._rappel.status.reference_node.angles );
	
	return v_node_normal;
}

_rappel_get_distance_to_ground()  // self = player
{
	Assert( IsDefined( self._rappel ), "rappel struct not set up on player attempting to use _rappel_get_distance_to_ground!" );

	// create vector downward from players origin, bullet trace to ground, return distance from ground
	const n_scale = 999999;  // arbitrary large number
	v_ground_line = self.origin - ( 0, 0, n_scale );
	
	a_trace = BulletTrace( self.origin, v_ground_line, false, undefined );	
	v_trace_hit = a_trace[ "position" ];	
	n_height = Distance( v_trace_hit, self.origin );
	
	//iprintlnbold( n_height );
	
	return n_height;
}


_rappel_get_ground_trace_position()
{
	const n_scale = 999999;  // arbitrary large number
	v_ground_line = self.origin - ( 0, 0, n_scale );	
	a_trace = BulletTrace( self.origin, v_ground_line, false, undefined );	
	v_trace_hit = a_trace[ "position" ];	
	
	return v_trace_hit;
}


_rappel_rotate_origin( n_rotate_angle )
{
	self._rappel.status.is_rotating = true;
	self._rappel.ent.origin = self.origin; 
	const n_delay = 0.5;  // TODO: cache
	
	//self StartCameraTween( n_delay );
	self._rappel.ent RotateYaw( n_rotate_angle, n_delay );
	self._rappel.ent waittill( "rotatedone" );
	
	self._rappel.status.is_rotating = false;
}

// zero out the z component of a vector so it's effectively 2D
_rappel_vector_remove_z( v_with_z )
{
	Assert( IsVec( v_with_z ), "only vectors can be used with _rappel_vector_remove_z" );
	
	v_without_z = ( v_with_z[ 0 ], v_with_z[ 1 ], 0 );
	
	return v_without_z;
}
