#include common_scripts\utility;
#include common_scripts\_fx;
#include common_scripts\_createfxMenu;

createEffect( type, fxid )
{
	ent = spawnStruct();
	if ( !IsDefined( level.createFXent ) )
	{
		level.createFXent = [];
	}

	level.createFXent[ level.createFXent.size ] = ent;
	ent.v = [];
	ent.v[ "type" ] = type;
	ent.v[ "fxid" ] = fxid;
	ent.v[ "angles" ] = ( 0, 0, 0 );
	ent.v[ "origin" ] = ( 0, 0, 0 );
	ent.drawn = true;

	if ( IsDefined( fxid ) && IsDefined( level.createFXbyFXID ) )
	{	// if we're using the optimized lookup, add it in the proper place
		ary = level.createFXbyFXID[ fxid ];
		if ( !IsDefined( ary ) )
		{
			ary = [];
		}

		ary[ ary.size ] = ent;
		level.createFXbyFXID[ fxid ] = ary;
	}
	return ent;
}

// the following "get" functions are used to centralize the default values for some of the createFX options.
// This is so that we don't have to write the options into the createfx file if they are the same as the default.

getLoopEffectDelayDefault()
{
	return 0.5;
}

getOneshotEffectDelayDefault()
{
	return -15;
}

getExploderDelayDefault()
{
	return 0;
}

getIntervalSoundDelayMinDefault()
{
	return .75;
}

getIntervalSoundDelayMaxDefault()
{
	return 2;
}

add_effect( name, effect )
{
	if ( !IsDefined( level._effect ) )
		level._effect = [];

	level._effect[ name ] = loadfx( effect );
}

createLoopSound()
{
	ent = spawnStruct();
	if ( !IsDefined( level.createFXent ) )
		level.createFXent = [];

	level.createFXent[ level.createFXent.size ] = ent;
	ent.v = [];
	ent.v[ "type" ] = "soundfx";
	ent.v[ "fxid" ] = "No FX";
	ent.v[ "soundalias" ] = "nil";
	ent.v[ "angles" ] = ( 0, 0, 0 );
	ent.v[ "origin" ] = ( 0, 0, 0 );
	ent.v[ "server_culled" ] = 1;
	if ( getdvar( "serverCulledSounds" ) != "1" )
		ent.v[ "server_culled" ] = 0;
	ent.drawn = true;
	return ent;
}

createIntervalSound()
{
	ent = createLoopSound();
	ent.v[ "type" ] = "soundfx_interval";
	ent.v[ "delay_min" ] = getIntervalSoundDelayMinDefault();
	ent.v[ "delay_max" ] = getIntervalSoundDelayMaxDefault();
	return ent;
}

createNewExploder()
{
	ent = spawnStruct();
	if ( !IsDefined( level.createFXent ) )
		level.createFXent = [];

	level.createFXent[ level.createFXent.size ] = ent;
	ent.v = [];
	ent.v[ "type" ] = "exploder";
	ent.v[ "fxid" ] = "No FX";
	ent.v[ "soundalias" ] = "nil";
	ent.v[ "loopsound" ] = "nil";
	ent.v[ "angles" ] = ( 0, 0, 0 );
	ent.v[ "origin" ] = ( 0, 0, 0 );
	ent.v[ "exploder" ] = 1;
	ent.v[ "flag" ] = "nil";
	ent.v[ "exploder_type" ] = "normal";
	ent.drawn = true;
	return ent;
}

createExploderEx( fxid, exploderID )
{
	ent = createExploder( fxid );
	ent.v[ "exploder" ] = exploderID;
	return ent;
}

set_origin_and_angles( origin, angles )
{
	self.v[ "origin" ] = origin;
	self.v[ "angles" ] = angles;
}

set_forward_and_up_vectors()
{
	self.v[ "up" ] = AnglesToUp( self.v[ "angles" ] );
	self.v[ "forward" ] = AnglesToForward( self.v[ "angles" ] );
}

convertOneShotFx()
{


	setDvarIfUninitialized( "curr_exp_num", 1 );
	

	expNum = getdvarint( "curr_exp_num" );
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		
		ent = level._createfx.selected_fx_ents[ i ];
		ent.v[ "type" ] = "exploder";
		ent.v[ "delay" ] = 0;
		ent.v[ "exploder" ] = expNum;
		ent.v[ "exploder_type" ] = "normal";

	}
	
}

createfx_common()
{
	precacheShader( "black" );

	if ( level.mp_createfx )
	{
		hack_start( "painter_mp" );
	}
	else
	{
		hack_start( "painter" );
	}

	flag_init( "createfx_saving" );

	// Effects placing tool
	if ( !IsDefined( level.createFX ) )
	{
		level.createFX = [];
	}

	level.createfx_loopcounter = 0;
	
// NOT MP FRIENDLY
//	array_call( GetSpawnerArray(), ::Delete );
//	
//	ents = GetEntArray( "trigger_multiple", "code_classname" );
//	ents = array_combine( ents, GetEntArray( "trigger_radius", "code_classname" ) );
//	ents = array_combine( ents, GetEntArray( "trigger_once", "code_classname" ) );

//	array_call( ents, ::Delete );

	level notify( "createfx_common_done" );
}

//---------------------------------------------------------
// CreateFx Logic Initialization Section
//---------------------------------------------------------
init_level_variables()
{
	// gets cumulatively added to to create digital accelleration
	level._createfx.selectedMove_up = 0;
	level._createfx.selectedMove_forward = 0;
	level._createfx.selectedMove_right = 0;
	level._createfx.selectedRotate_pitch = 0;
	level._createfx.selectedRotate_roll = 0;
	level._createfx.selectedRotate_yaw = 0;
	level._createfx.selected_fx = [];
	level._createfx.selected_fx_ents = [];

	// Selected Ent Settings
	level._createfx.rate 		= 1;
	level._createfx.snap2normal = 0;
	level._createfx.axismode 	= 0;
	
	// Select By Name
	level._createfx.select_by_name = false; // unhighlights current ent

	level._createfx.player_speed = GetDvarFloat( "g_speed" );
	set_player_speed_hud();
}

init_locked_list()
{
	level._createfx.lockedList = [];
	level._createfx.lockedList[ "escape" ] = true;
	level._createfx.lockedList[ "BUTTON_LSHLDR" ] = true;
	level._createfx.lockedList[ "BUTTON_RSHLDR" ] = true;
	level._createfx.lockedList[ "mouse1" ] = true;
	level._createfx.lockedList[ "ctrl" ] = true;
}

init_colors()
{
	colors = [];
	colors[ "loopfx" ][ "selected" ] 		 = ( 1.0, 1.0, 0.2 );
	colors[ "loopfx" ][ "highlighted" ] 	 = ( 0.4, 0.95, 1.0 );
	colors[ "loopfx" ][ "default" ]		 	 = ( 0.3, 0.8, 1.0 );

	colors[ "oneshotfx" ][ "selected" ] 	 = ( 1.0, 1.0, 0.2 );
	colors[ "oneshotfx" ][ "highlighted" ] 	 = ( 0.4, 0.95, 1.0 );
	colors[ "oneshotfx" ][ "default" ]		 = ( 0.3, 0.8, 1.0 );

	colors[ "exploder" ][ "selected" ] 		 = ( 1.0, 1.0, 0.2 );
	colors[ "exploder" ][ "highlighted" ] 	 = ( 1.0, 0.2, 0.2 );
	colors[ "exploder" ][ "default" ]		 = ( 1.0, 0.1, 0.1 );

	colors[ "rainfx" ][ "selected" ] 		 = ( 1.0, 1.0, 0.2 );
	colors[ "rainfx" ][ "highlighted" ] 	 = ( .95, 0.4, 0.95 );
	colors[ "rainfx" ][ "default" ]			 = ( .78, 0.0, 0.73 );

	colors[ "soundfx" ][ "selected" ]	 	 = ( 1.0, 1.0, 0.2 );
	colors[ "soundfx" ][ "highlighted" ] 	 = ( .5, 1.0, 0.75 );
	colors[ "soundfx" ][ "default" ]		 = ( .2, 0.9, 0.2 );

	colors[ "soundfx_interval" ][ "selected" ]	 	 = ( 1.0, 1.0, 0.2 );
	colors[ "soundfx_interval" ][ "highlighted" ] 	 = ( .5, 1.0, 0.75 );
	colors[ "soundfx_interval" ][ "default" ]		 = ( .2, 0.9, 0.2 );

	level._createfx.colors = colors;
}

//---------------------------------------------------------
// CreateFx Logic Section
//---------------------------------------------------------
createFxLogic()
{
	waittillframeend;// let _load run first
	wait( 0.05 );

	level._createfx = SpawnStruct();

	if ( !IsDefined( level._effect ) )
	{
		level._effect = [];
	}

	if ( GetDvar( "createfx_map" ) == "" )
	{
		SetDevDvar( "createfx_map", get_template_level() );
	}
	else if ( GetDvar( "createfx_map" ) == get_template_level() )
	{
		[[ level.func_position_player ]]();
	}

	init_crosshair();
	init_menu();
	init_huds();
	init_tool_hud();
	init_crosshair();
	init_level_variables();
	init_locked_list();
	init_colors();

	SetDevDvar( "fx", "nil" );
	SetDevDvar( "select_by_substring", "" );

	if ( GetDvar( "createfx_use_f4" ) == "" )
		SetDevDvar( "createfx_use_f4", "0" );

	if ( GetDvar( "createfx_no_autosave" ) == "" )
		SetDevDvar( "createfx_no_autosave", "0" );

	level.createfx_draw_enabled = true;
	level.last_displayed_ent = undefined;

	level.buttonIsHeld = [];
	lastPlayerOrigin = (0,0,0);
	
	if ( !level.mp_createfx )
	{
		lastPlayerOrigin = level.player.origin;
	}

	lastHighlightedEnt = undefined;
	level.fx_rotating = false;
	setMenu( "none" );
	level.createfx_selecting = false;

	// black background for text
	black = newHudElem();
	black.x = -120;
	black.y = 200;
	black.foreground = 0;
	black setShader( "black", 250, 160 );
	black.alpha = 0;// 0.6;

	level.createfx_inputlocked = false;

	foreach ( ent in level.createFXent )
	{
		ent post_entity_creation_function();
	}

	thread draw_distance();
	lastSelectEntity = undefined;
	thread createfx_autosave();

	for ( ;; )
	{
		changedSelectedEnts = false;

		// calculate the "cursor"
		right = anglestoright( level.player getplayerangles() );
		forward = anglestoforward( level.player getplayerangles() );
		up = anglestoup( level.player getplayerangles() );
		dot = 0.85;

		placeEnt_vector = ( forward * 750 );
		level.createfxCursor = bullettrace( level.player geteye(), level.player geteye() + placeEnt_vector, false, undefined );
		highlightedEnt = undefined;

		// ************************************************************
		//
		// 				General input
		//
		// ************************************************************

		level.buttonClick = [];
		level.button_is_kb = [];
		process_button_held_and_clicked();
		ctrlHeld = button_is_held( "ctrl", "BUTTON_LSHLDR" );
		leftClick = button_is_clicked( "mouse1", "BUTTON_A" );
		leftHeld = button_is_held( "mouse1", "BUTTON_A" );

		create_fx_menu();

		//changing to allow devgui item
		// FOR PC Debugging purposes
		btn = "F5";
		if ( GetDvarInt( "createfx_use_f4" ) )
		{
			btn = "F4";
		}
		
		if ( button_is_clicked( btn ) )
			SetDevDvar( "scr_createfx_dump", 1 );
			
		if( GetDvarInt( "scr_createfx_dump" ) )
		{
			SetDevDvar( "scr_createfx_dump", 0 );
			generate_fx_log();
		}
	
		if ( button_is_clicked( "F2" ) )
			toggle_createfx_drawing();

		if ( button_is_clicked( "ins" ) )
			insert_effect();

		if ( button_is_clicked( "del" ) )
			delete_pressed();

		if ( button_is_clicked( "escape" ) )
			clear_settable_fx();

		if ( button_is_clicked( "space" ) )
			set_off_exploders();
			
//		if (button_is_clicked("j"))
//			setmenu("jump_to_effect");

		if ( button_is_clicked( "u" ) )
			select_by_name_list();

		if ( button_is_clicked( "z" ) )
			convertOneShotFx();
		
		
		modify_player_speed();

		if ( button_is_clicked( "g" ) )
		{
			select_all_exploders_of_currently_selected( "exploder" );
			select_all_exploders_of_currently_selected( "flag" );
		}

		if ( button_is_held( "h", "F1" ) )
		{
			show_help();
			wait( 0.05 );
			continue;
		}

		if ( button_is_clicked( "BUTTON_LSTICK" ) )
			copy_ents();
		if ( button_is_clicked( "BUTTON_RSTICK" ) )
			paste_ents();

		if ( ctrlHeld )
		{
			if ( button_is_clicked( "c" ) )
				copy_ents();

			if ( button_is_clicked( "v" ) )
				paste_ents();
		}

		if ( isdefined( level._createfx.selected_fx_option_index ) )
			menu_fx_option_set();

		//-------------------------------------------------
		// Highlighted Entity Handling
		//-------------------------------------------------
		for ( i = 0; i < level.createFXent.size; i++ )
		{
			ent = level.createFXent[ i ];

			difference = VectorNormalize( ent.v[ "origin" ] - ( level.player.origin + ( 0, 0, 55 ) ) );
			newdot = vectordot( forward, difference );
			if ( newdot < dot )
			{
				continue;
			}

			dot = newdot;
			highlightedEnt = ent;
		}

		level.fx_highLightedEnt = highLightedEnt;

		if ( IsDefined( highLightedEnt ) )
		{
			if ( IsDefined( lastHighlightedEnt ) )
			{
				if ( lastHighlightedEnt != highlightedEnt )
				{
					// a highlighted ent is no longer highlighted so scale down the text size
//					lastHighlightedEnt.text = ".";
//					lastHighlightedEnt.textsize = 2;
					if ( !ent_is_selected( lastHighlightedEnt ) )
						lastHighlightedEnt thread entity_highlight_disable();

					// an ent became highlighted for the first time so scale up the text size on the new ent
//					highlightedEnt.text = HighlightedEnt.v["fxid"];
//					highlightedEnt.textsize = 1;
					if ( !ent_is_selected( highlightedEnt ) )
						highlightedEnt thread entity_highlight_enable();
				}
			}
			else
			{
				// an ent became highlighted for the first time so scale up the text size on the new ent
//				HighlightedEnt.text = HighlightedEnt.v["fxid"];
//				HighlightedEnt.textsize = 1;
				if ( !ent_is_selected( highlightedEnt ) )
					highlightedEnt thread entity_highlight_enable();
			}
		}

		manipulate_createfx_ents( highlightedEnt, leftClick, leftHeld, ctrlHeld, right );

		//-------------------------------------------------
		// Handle Selected Entities
		//-------------------------------------------------
		changedSelectedEnts = handle_selected_ents( changedSelectedEnts );
		wait( 0.05 );

		if ( changedSelectedEnts )
			update_selected_entities();

		if( !level.mp_createfx )
			lastPlayerOrigin = [[ level.func_position_player_get ]]( lastPlayerOrigin );

		lastHighlightedEnt = highlightedEnt;

		// if the last selected entity changes then reset the options offset
		if ( last_selected_entity_has_changed( lastSelectEntity ) )
		{
			level.effect_list_offset = 0;
			clear_settable_fx();
			setmenu( "none" );
		}

		if ( level._createfx.selected_fx_ents.size )
			lastSelectEntity = level._createfx.selected_fx_ents[ level._createfx.selected_fx_ents.size - 1 ];
		else
			lastSelectEntity = undefined;
	}
}

modify_player_speed()
{
	modify_speed = false;

	ctrl_held = button_is_held( "ctrl" );
	if ( button_is_held( "." ) )
	{
		if ( ctrl_held )
		{
			if ( level._createfx.player_speed < 190 )
			{
				level._createfx.player_speed = 190;
			}
			else
			{
				level._createfx.player_speed += 10;
			}
		}
		else
		{
			level._createfx.player_speed += 5;
		}
		modify_speed = true;
	}
	else if ( button_is_held( "," ) )
	{
		if ( ctrl_held )
		{
			if ( level._createfx.player_speed > 190 )
			{
				level._createfx.player_speed = 190;
			}
			else
			{
				level._createfx.player_speed -= 10;
			}
		}
		else
		{
			level._createfx.player_speed -= 5;
		}
		modify_speed = true;
	}

	if ( modify_speed )
	{
		level._createfx.player_speed = Clamp( level._createfx.player_speed, 5, 500 );

		[[ level.func_player_speed ]]();

		set_player_speed_hud();
	}
}

set_player_speed_hud()
{
	if ( !IsDefined( level._createfx.player_speed_hud ) )
	{
		hud = newHudElem();
		hud.alignX = "right";
		hud.foreground = 1;
		hud.fontScale = 1.2;
		hud.alpha = 0.2;
		hud.x = 320;
		hud.y = 420;
		hud SetText( "Speed: " );

		hud_value = newHudElem();
		hud_value.alignX = "left";
		hud_value.foreground = 1;
		hud_value.fontScale = 1.2;
		hud_value.alpha = 0.2;
		hud_value.x = 320;
		hud_value.y = 420;

		hud.hud_value = hud_value;

		level._createfx.player_speed_hud = hud;
	}

	level._createfx.player_speed_hud.hud_value SetValue( level._createfx.player_speed );
}

toggle_createfx_drawing()
{
	level.createfx_draw_enabled = !level.createfx_draw_enabled;
}

insert_effect()
{
	setMenu( "creation" );
	level.effect_list_offset = 0;
	clear_fx_hudElements();
	set_fx_hudElement( "Pick effect type to create:" );
	set_fx_hudElement( "1. One Shot fx" );
	set_fx_hudElement( "2. Looping fx" );
	set_fx_hudElement( "3. Looping sound" );
	set_fx_hudElement( "4. Exploder" );
	set_fx_hudElement( "5. One Shot Sound" );
	set_fx_hudElement( "(c) Cancel" );
	set_fx_hudElement( "(x) Exit" );
	/*
	set_fx_hudElement("Pick an effect:");
	set_fx_hudElement("In the console, type");
	set_fx_hudElement("/fx name");
	set_fx_hudElement("Where name is the name of the sound alias");
	*/
}

manipulate_createfx_ents( highlightedEnt, leftClick, leftHeld, ctrlHeld, right )
{
	if ( !level.createfx_draw_enabled )
		return;
		
	if ( level._createfx.select_by_name )
	{
		level._createfx.select_by_name = false;
		highlightedEnt = undefined;
	}
	else if ( select_by_substring() )
	{
		highlightedEnt = undefined;
	}
		
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		ent = level.createFXent[ i ];
		if ( !ent.drawn )
			continue;

		scale = GetDvarFloat( "createfx_scaleid" );

		if ( IsDefined( highlightedEnt ) && ent == highlightedEnt )
		{
			if ( !entities_are_selected() )
				display_fx_info( ent );

			if ( leftClick )
			{
				entWasSelected = index_is_selected( i );
				level.createfx_help_active = false;
				level.createfx_selecting = !entWasSelected;// used for drag select / deselect
				if ( !ctrlHeld )
				{
					selectedSize = level._createfx.selected_fx_ents.size;
					clear_entity_selection();
					if ( entWasSelected && selectedSize == 1 )
						select_entity( i, ent );
				}
				toggle_entity_selection( i, ent );
			}
			else
			if ( leftHeld )
			{
				if ( ctrlHeld )
				{
					if ( level.createfx_selecting )
						select_entity( i, ent );

					if ( !level.createfx_selecting )
						deselect_entity( i, ent );
				}
			}

			colorIndex = "highlighted";
			if ( index_is_selected( i ) )
				colorIndex = "selected";

			if( GetDvarInt( "fx_showLightGridSampleOffset") != 0 )
			{
				offsetscale = GetDvarFloat( "fx_lightGridSampleOffset" );
				forwardoffset = anglestoforward( ent.v[ "angles" ] ) * offsetscale;
				print3d( ent.v[ "origin" ] + forwardoffset, ".", ( 1, 0.411, 0.705 ), 1, scale );
			}

			print3d( ent.v[ "origin" ], ".", level._createfx.colors[ ent.v[ "type" ] ][ colorIndex ], 1, scale );
			if ( ent.textalpha > 0 )
			{
				printRight = ( right * (ent.v[ "fxid" ].size * -2.93 * scale ));
				print3d( ent.v[ "origin" ] + printRight + ( 0, 0, 15 ), ent.v[ "fxid" ], level._createfx.colors[ ent.v[ "type" ] ][ colorIndex ], ent.textalpha, scale );
			}
		}
		else
		{
			colorIndex = "default";
			if ( index_is_selected( i ) )
				colorIndex = "selected";

			if( GetDvarInt( "fx_showLightGridSampleOffset") != 0 )
			{	
				offsetscale = GetDvarFloat( "fx_lightGridSampleOffset" );
				forwardoffset = anglestoforward( ent.v[ "angles" ] ) * offsetscale;
				print3d( ent.v[ "origin" ] + forwardoffset , ".", ( 1, 0.411, 0.705 ), 1, scale );
			}

			print3d( ent.v[ "origin" ], ".", level._createfx.colors[ ent.v[ "type" ] ][ colorIndex ], 1, scale );
			if ( ent.textalpha > 0 )
			{
				printRight = ( right * ( ent.v[ "fxid" ].size * -2.93 ) );
				print3d( ent.v[ "origin" ] + printRight + ( 0, 0, 15 ), ent.v[ "fxid" ], level._createfx.colors[ ent.v[ "type" ] ][ colorIndex ], ent.textalpha, scale );
			}
		}
	}
}

select_by_name_list()
{
	level.effect_list_offset = 0;
	clear_fx_hudElements();
	setmenu( "select_by_name" );
	draw_effects_list();
}

//---------------------------------------------------------
// Selected Ent Section
//---------------------------------------------------------
handle_selected_ents( changedSelectedEnts )
{
	if ( level._createfx.selected_fx_ents.size > 0 && level.createfx_help_active == false)
	{
		changedSelectedEnts = selected_ent_buttons( changedSelectedEnts );

		if ( !current_mode_hud( "selected_ents" ) )
		{
			new_tool_hud( "selected_ents" );
			set_tool_hudelem( "Selected Ent Mode" );
			set_tool_hudelem( "Mode:", "move" );
			set_tool_hudelem( "Rate:", level._createfx.rate );
			set_tool_hudelem( "Snap2Normal:", level._createfx.snap2normal );
			
		}

		if ( level._createfx.axismode && level._createfx.selected_fx_ents.size > 0 )
		{
			set_tool_hudelem( "Mode:", "rotate" );
			// draw axis and do rotation if shift is held
			thread [[ level.func_process_fx_rotater ]]();
			if ( button_is_clicked( "p" ) )
				reset_axis_of_selected_ents();
			
			if ( button_is_clicked( "o" ) )
				aim_axis_of_selected_ents();
		
			if ( button_is_clicked( "v" ) )
				copy_angles_of_selected_ents();
		
			for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
				level._createfx.selected_fx_ents[ i ] draw_axis();
		
			if ( level.selectedRotate_pitch != 0 || level.selectedRotate_yaw != 0  || level.selectedRotate_roll != 0 )
				changedSelectedEnts = true;
		/*
			for ( i=0; i < level._createfx.selected_fx_ents.size; i++)
			{
				ent = level._createfx.selected_fx_ents[i];
				ent.angles = ent.angles + (level.selectedRotate_pitch, level.selectedRotate_yaw, 0);
				ent set_forward_and_up_vectors();
			}
			
			if (level.selectedRotate_pitch != 0 || level.selectedRotate_yaw != 0)
				changedSelectedEnts = true;
		*/
		}
		else
		{
			set_tool_hudelem( "Mode:", "move" );
			selectedMove_vector = get_selected_move_vector();
			for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
			{
				ent = level._createfx.selected_fx_ents[ i ];
				if ( IsDefined( ent.model ) )// ents with brushmodels are from radiant and dont get moved
					continue;
		
				ent draw_cross();
				ent.v[ "origin" ] = ent.v[ "origin" ] + selectedMove_vector;
			}
		
			if ( distance( ( 0, 0, 0 ), selectedMove_vector ) > 0 )
				changedSelectedEnts = true;
		}
	}
	else
	{
		clear_tool_hud();
	}

	return changedSelectedEnts;
}

selected_ent_buttons( changedSelectedEnts )
{
	if ( button_is_clicked( "shift", "BUTTON_X" ) )
	{
		toggle_axismode();
	}

	modify_rate();

	if ( button_is_clicked( "s" ) )
	{
		toggle_snap2normal();
	}

	if ( button_is_clicked( "end", "l" ) )
	{
		drop_selection_to_ground();
		changedSelectedEnts = true;
	}

	if ( button_is_clicked( "tab", "BUTTON_RSHLDR" ) )
	{
		move_selection_to_cursor();
		changedSelectedEnts = true;
	}

	return changedSelectedEnts;
}

modify_rate()
{
	shift_held = button_is_held( "shift" );
	ctrl_held = button_is_held( "ctrl" );

	if ( button_is_clicked( "=" ) )
	{
		if ( shift_held )
		{
			level._createfx.rate += 1;
		}
		else if ( ctrl_held )
		{
			if ( level._createfx.rate < 1 )
			{
				level._createfx.rate = 1;
			}
			else
			{
				level._createfx.rate += 10;
			}
		}
		else
		{
			level._createfx.rate += 0.1;
		}

	}
	else if ( button_is_clicked( "-" ) )
	{
		if ( shift_held )
		{
			level._createfx.rate -= 1;
		}
		else if ( ctrl_held )
		{
			if ( level._createfx.rate > 1 )
			{
				level._createfx.rate = 1;
			}
			else
			{
				level._createfx.rate = 0.1;
			}
		}
		else
		{
			level._createfx.rate -= 0.1;
		}
	}

	level._createfx.rate = Clamp( level._createfx.rate, 0.1, 100 );

	set_tool_hudelem( "Rate:", level._createfx.rate );
}

toggle_axismode()
{
	level._createfx.axismode = !level._createfx.axismode;
}

toggle_snap2normal()
{
	level._createfx.snap2normal = !level._createfx.snap2normal;
	set_tool_hudelem( "Snap2Normal:", level._createfx.snap2normal );
}

copy_angles_of_selected_ents()
{
	// so it stops rotating them over time
	level notify( "new_ent_selection" );

	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		ent = level._createfx.selected_fx_ents[ i ];
		ent.v[ "angles" ] = level._createfx.selected_fx_ents[ level._createfx.selected_fx_ents.size - 1 ].v[ "angles" ];
		ent set_forward_and_up_vectors();
	}

	update_selected_entities();
}

aim_axis_of_selected_ents()
{
	// so it stops rotating them over time
	level notify( "new_ent_selection" );
	aim_ent = level._createfx.selected_fx_ents[level._createfx.selected_fx_ents.size - 1];
	for ( i = 0; i < (level._createfx.selected_fx_ents.size - 1); i++ )
	{
		ent = level._createfx.selected_fx_ents[ i ];
		aim_angle = VectorToAngles(aim_ent.v[ "origin" ] - ent.v[ "origin" ]);
		ent.v[ "angles" ] = aim_angle;
		ent set_forward_and_up_vectors();
	}

	update_selected_entities();
}

reset_axis_of_selected_ents()
{
	// so it stops rotating them over time
	level notify( "new_ent_selection" );

	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		ent = level._createfx.selected_fx_ents[ i ];
		ent.v[ "angles" ] = ( 0, 0, 0 );
		ent set_forward_and_up_vectors();
	}

	update_selected_entities();
}

last_selected_entity_has_changed( lastSelectEntity )
{
	if ( IsDefined( lastSelectEntity ) )
	{
		if ( !entities_are_selected() )
			return true;
	}
	else
		return entities_are_selected();

	return( lastSelectEntity != level._createfx.selected_fx_ents[ level._createfx.selected_fx_ents.size - 1 ] );
}

drop_selection_to_ground()
{
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		ent = level._createfx.selected_fx_ents[ i ];
		trace = BulletTrace( ent.v[ "origin" ], ent.v[ "origin" ] + ( 0, 0, -2048 ), false, undefined );
		ent.v[ "origin" ] = trace[ "position" ];
	}
}

set_off_exploders()
{
	level notify( "createfx_exploder_reset" );
	exploders = [];
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		ent = level._createfx.selected_fx_ents[ i ];
		if ( IsDefined( ent.v[ "exploder" ] ) )
			exploders[ ent.v[ "exploder" ] ] = true;
	}

	keys = getarraykeys( exploders );
	for ( i = 0; i < keys.size; i++ )
		exploder( keys[ i ] );
}

draw_distance()
{
	count = 0;
	if ( GetDvarInt( "createfx_drawdist" ) == 0 )
	{
		SetDevDvar( "createfx_drawdist", "500" );
	}

	for ( ;; )
	{
		maxDist = GetDvarInt( "createfx_drawdist" );
		maxDist *= maxDist;
		for ( i = 0; i < level.createFXent.size; i++ )
		{
			ent = level.createFXent[ i ];
			ent.drawn = DistanceSquared( level.player.origin, ent.v[ "origin" ] ) <= maxDist;

			count++ ;
			if ( count > 100 )
			{
				count = 0;
				wait( 0.05 );
			}
		}

		if ( level.createFXent.size == 0 )
		{
			wait( 0.05 );
		}
	}
}

createfx_autosave()
{
	SetDvarIfUninitialized( "createfx_autosave_time", "300" );
	
	for ( ;; )
	{
		wait( GetDvarInt( "createfx_autosave_time" ) );
		flag_waitopen( "createfx_saving" );
		
		if ( GetDvarInt( "createfx_no_autosave" ) )
		{
			continue;
		}
		
		generate_fx_log( true );
	}
}

rotate_over_time( org, rotater )
{
	level endon( "new_ent_selection" );
	timer = 0.1;
	for ( p = 0; p < timer * 20; p++ )
	{
		if ( level.selectedRotate_pitch != 0 )
			org AddPitch( level.selectedRotate_pitch );
		else
		if ( level.selectedRotate_yaw != 0 )
			org AddYaw( level.selectedRotate_yaw );
		else
			org AddRoll( level.selectedRotate_roll );

		wait( 0.05 );
		org draw_axis();

		for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
		{
			ent = level._createfx.selected_fx_ents[ i ];
			if ( IsDefined( ent.model ) )// ents with brushmodels are from radiant and dont get moved
				continue;

			ent.v[ "origin" ] = rotater[ i ].origin;
			ent.v[ "angles" ] = rotater[ i ].angles;
		}
	}
}

delete_pressed()
{
	if ( level.createfx_inputlocked )
	{
		remove_selected_option();
		return;
	}

	delete_selection();
}

remove_selected_option()
{
	if ( !IsDefined( level._createfx.selected_fx_option_index ) )
	{
		return;
	}

	name = level._createfx.options[ level._createfx.selected_fx_option_index ][ "name" ];
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		ent = level.createFXent[ i ];
		if ( !ent_is_selected( ent ) )
			continue;

		ent remove_option( name );
	}

	update_selected_entities();
	clear_settable_fx();
}

remove_option( name )
{
	self.v[ name ] = undefined;
}

delete_selection()
{
	newArray = [];

	for ( i = 0; i < level.createFXent.size; i++ )
	{
		ent = level.createFXent[ i ];
		if ( ent_is_selected( ent ) )
		{
			if ( IsDefined( ent.looper ) )
				ent.looper delete();

			ent notify( "stop_loop" );
		}
		else
			newArray[ newArray.size ] = ent;
	}

	level.createFXent = newArray;

	level._createfx.selected_fx = [];
	level._createfx.selected_fx_ents = [];
	clear_fx_hudElements();
}

move_selection_to_cursor()
{
	origin = level.createfxCursor[ "position" ];
	if ( level._createfx.selected_fx_ents.size <= 0 )
	{
		return;
	}

	center = get_center_of_array( level._createfx.selected_fx_ents );
	difference = center - origin;
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		ent = level._createfx.selected_fx_ents[ i ];
		if ( IsDefined( ent.model ) )// ents with brushmodels are from radiant and dont get moved
		{
			continue;
		}

		ent.v[ "origin" ] -= difference;

		if ( level._createfx.snap2normal )
		{
			if ( IsDefined( level.createfxCursor[ "normal" ] ) )
			{
				ent.v[ "angles" ] = VectorToAngles( level.createfxCursor[ "normal" ] );;
			}		
		}
	}
}

select_last_entity()
{
	select_entity( level.createFXent.size - 1, level.createFXent[ level.createFXent.size - 1 ] );
}

reselect_entitites()
{
	//this works some of the time, not sure why it isn't more reliable
	selected_exploders = [];
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		if (index_is_selected(i))
		{	
			selected_exploders[selected_exploders.size] = i;
		}
	}
	clear_entity_selection();
	select_index_array(selected_exploders);
}

select_all_selected_exploders()
{
	select_all_exploders_of_currently_selected( "exploder" );
	select_all_exploders_of_currently_selected( "flag" );
}

select_all_exploders_of_currently_selected( key )
{
	selected_exploders = [];
	foreach ( ent in level._createfx.selected_fx_ents )
	{
		if ( !IsDefined( ent.v[ key ] ) )
			continue;
		
		value = ent.v[ key ];
		selected_exploders[ value ] = true;
	}
	
	foreach ( value, _ in selected_exploders )
	{
		foreach ( index, ent in level.createFXent )
		{
			if ( index_is_selected( index ) )
				continue;
			if ( !IsDefined( ent.v[ key ] ) )
				continue;
			if ( ent.v[ key ] != value )
				continue;			

			select_entity( index, ent );
		}
	}
	
	update_selected_entities();
}

copy_ents()
{
	if ( level._createfx.selected_fx_ents.size <= 0 )
		return;

	array = [];
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		ent = level._createfx.selected_fx_ents[ i ];
		newent = spawnstruct();

		newent.v = ent.v;
		newent post_entity_creation_function();
		array[ array.size ] = newent;
	}

	level.stored_ents = array;
}

post_entity_creation_function()
{
	self.textAlpha = 0;
	self.drawn = true;
}

paste_ents()
{
	if ( !IsDefined( level.stored_ents ) )
		return;

	clear_entity_selection();

	for ( i = 0;i < level.stored_ents.size;i++ )
		add_and_select_entity( level.stored_ents[ i ] );

	move_selection_to_cursor();
	update_selected_entities();
	level.stored_ents = [];
	copy_ents();// roundabout way to put new entities in the copy queue
}

add_and_select_entity( ent )
{
	level.createFXent[ level.createFXent.size ] = ent;
	select_last_entity();
}

get_center_of_array( array )
{
	center = ( 0, 0, 0 );
	for ( i = 0; i < array.size; i++ )
		center = ( center[ 0 ] + array[ i ].v[ "origin" ][ 0 ], center[ 1 ] + array[ i ].v[ "origin" ][ 1 ], center[ 2 ] + array[ i ].v[ "origin" ][ 2 ] );

	return( center[ 0 ] / array.size, center[ 1 ] / array.size, center[ 2 ] / array.size );
}

ent_draw_axis()
{
	self endon( "death" );
	for ( ;; )
	{
		draw_axis();
		wait( 0.05 );
	}
}

rotation_is_occuring()
{
	if ( level.selectedRotate_roll != 0 )
		return true;
	if ( level.selectedRotate_pitch != 0 )
		return true;
	return level.selectedRotate_yaw != 0;
}

print_fx_options( ent, tab, autosave )
{
	for ( i = 0; i < level._createfx.options.size; i++ )
	{
		option = level._createfx.options[ i ];
		optionName = option[ "name" ];
		if ( !IsDefined( ent.v[ optionName ] ) )
			continue;
		if ( !mask( option[ "mask" ], ent.v[ "type" ] ) )
			continue;
			
		if( !level.mp_createfx )
		{
			if ( mask( "fx", ent.v[ "type" ] ) && optionName == "fxid" )
				continue;	// fxid is already set in the create functions
			if ( ent.v[ "type" ] == "exploder" && optionName == "exploder" )
				continue;	// exploder is set in createExploderEx()
				
			key = ent.v[ "type" ] + "/" + optionName;
		
			if ( IsDefined( level._createfx.defaults[ key ] ) && ( level._createfx.defaults[ key ] == ent.v[ optionName ] ) )
				continue;
		}
			
		if ( option[ "type" ] == "string" )
		{
			stringValue = ent.v[ optionName ] + "";
			if ( stringValue == "nil" )	// nil is treated the same as !defined - so why print it out?
				continue;
			if ( optionName == "platform" && stringValue == "all")
				continue;
//			if ( !autosave )
//				println( "	ent.v[ \"" + optionName + "\" ] = \"" + ent.v[ optionName ] + "\";" );
			cfxprintln( tab + "ent.v[ \"" + optionName + "\" ] = \"" + ent.v[ optionName ] + "\";" );
			continue;
		}

		// int or float
//		if ( !autosave )
//			println( "	ent.v[ \"" + optionName + "\" ] = " + ent.v[ optionName ] + ";" );
		cfxprintln( tab + "ent.v[ \"" + optionName + "\" ] = " + ent.v[ optionName ] + ";" );
	}
}

entity_highlight_disable()
{
	self notify( "highlight change" );
	self endon( "highlight change" );

	for ( ;; )
	{
		self.textalpha = self.textalpha * 0.85;
		self.textalpha = self.textalpha - 0.05;
		if ( self.textalpha < 0 )
			break;
		wait( 0.05 );
	}

	self.textalpha = 0;
}

entity_highlight_enable()
{
	self notify( "highlight change" );
	self endon( "highlight change" );

	for ( ;; )
	{
//		self.textalpha = sin(gettime()) * 0.5 + 0.5;
		self.textalpha = self.textalpha + 0.05;
		self.textalpha = self.textalpha * 1.25;
		if ( self.textalpha > 1 )
			break;
		wait( 0.05 );
	}

	self.textalpha = 1;

}

clear_settable_fx()
{	
	level.createfx_inputlocked = false;
	SetDevDvar( "fx", "nil" );
	// in case we were modifying an option
	level._createfx.selected_fx_option_index = undefined;
	reset_fx_hud_colors();
}

reset_fx_hud_colors()
{
	for ( i = 0;i < level._createfx.hudelem_count; i++ )
		level._createfx.hudelems[ i ][ 0 ].color = ( 1, 1, 1 );
}

toggle_entity_selection( index, ent )
{
	if ( IsDefined( level._createfx.selected_fx[ index ] ) )
		deselect_entity( index, ent );
	else
		select_entity( index, ent );
}

select_entity( index, ent )
{
	if ( IsDefined( level._createfx.selected_fx[ index ] ) )
		return;
	clear_settable_fx();
	level notify( "new_ent_selection" );

	ent thread entity_highlight_enable();

	level._createfx.selected_fx[ index ] = true;
	level._createfx.selected_fx_ents[ level._createfx.selected_fx_ents.size ] = ent;
}

ent_is_highlighted( ent )
{
	if ( !IsDefined( level.fx_highLightedEnt ) )
		return false;
	return ent == level.fx_highLightedEnt;
}

deselect_entity( index, ent )
{
	if ( !IsDefined( level._createfx.selected_fx[ index ] ) )
		return;

	clear_settable_fx();
	level notify( "new_ent_selection" );

	level._createfx.selected_fx[ index ] = undefined;

	if ( !ent_is_highlighted( ent ) )
		ent thread entity_highlight_disable();

	// remove the entity from the array of selected entities
	newArray = [];
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		if ( level._createfx.selected_fx_ents[ i ] != ent )
			newArray[ newArray.size ] = level._createfx.selected_fx_ents[ i ];
	}
	level._createfx.selected_fx_ents = newArray;
}

index_is_selected( index )
{
	return IsDefined( level._createfx.selected_fx[ index ] );
}

ent_is_selected( ent )
{
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		if ( level._createfx.selected_fx_ents[ i ] == ent )
			return true;
	}
	return false;
}

clear_entity_selection()
{
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		if ( !ent_is_highlighted( level._createfx.selected_fx_ents[ i ] ) )
			level._createfx.selected_fx_ents[ i ] thread entity_highlight_disable();
	}
	level._createfx.selected_fx = [];
	level._createfx.selected_fx_ents = [];
}

draw_axis()
{
/#
	range = 25 * GetDvarFloat( "createfx_scaleid" );

//	range = 25;
	forward = AnglesToForward( self.v[ "angles" ] );
	forward  *= range;
	right = AnglesToRight( self.v[ "angles" ] );
	right  *= range;
	up = AnglesToUp( self.v[ "angles" ] );
	up  *= range ;
	line( self.v[ "origin" ], self.v[ "origin" ] + forward, ( 1, 0, 0 ), 1 );
	line( self.v[ "origin" ], self.v[ "origin" ] + up, ( 0, 1, 0 ), 1 );
	line( self.v[ "origin" ], self.v[ "origin" ] + right, ( 0, 0, 1 ), 1 );
	
/*
	if ( IsDefined( self.v[ "soundalias" ] ) )
	{
		DrawSoundShape( self.v[ "origin" ], self.v[ "angles" ], self.v[ "soundalias" ], ( 1, 0, 1 ), 1 );
	}
*/
#/
}

draw_cross()
{
/#
	range = 4;

	Line( self.v[ "origin" ] - ( 0, 0, range ), self.v[ "origin" ] + ( 0, 0, range ) );
	Line( self.v[ "origin" ] - ( 0, range, 0 ), self.v[ "origin" ] + ( 0, range, 0 ) );
	Line( self.v[ "origin" ] - ( range, 0, 0 ), self.v[ "origin" ] + ( range, 0, 0 ) );
#/
}


createfx_centerprint( text )
{
	thread createfx_centerprint_thread( text );
}

createfx_centerprint_thread( text )
{
	level notify( "new_createfx_centerprint" );
	level endon( "new_createfx_centerprint" );
	for ( p = 0;p < 5;p++ )
		level.createFX_centerPrint[ p ] setText( text );
	wait( 4.5 );
	for ( p = 0;p < 5;p++ )
		level.createFX_centerPrint[ p ] setText( "" );
}

get_selected_move_vector()
{
	yaw = level.player GetPlayerAngles()[ 1 ];
	angles = ( 0, yaw, 0 );
	right = AnglesToRight( angles );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );

	keypressed = false;
	rate = level._createfx.rate;

	if ( buttonDown( "kp_uparrow", "DPAD_UP" ) )
	{
		if ( level.selectedMove_forward < 0 )
			level.selectedMove_forward = 0;

		level.selectedMove_forward = level.selectedMove_forward + rate;
	}
	else
	if ( buttonDown( "kp_downarrow", "DPAD_DOWN" ) )
	{
		if ( level.selectedMove_forward > 0 )
			level.selectedMove_forward = 0;
		level.selectedMove_forward = level.selectedMove_forward - rate;
	}
	else
		level.selectedMove_forward = 0;

	if ( buttonDown( "kp_rightarrow", "DPAD_RIGHT" ) )
	{
		if ( level.selectedMove_right < 0 )
			level.selectedMove_right = 0;

		level.selectedMove_right = level.selectedMove_right + rate;
	}
	else
	if ( buttonDown( "kp_leftarrow", "DPAD_LEFT" ) )
	{
		if ( level.selectedMove_right > 0 )
			level.selectedMove_right = 0;
		level.selectedMove_right = level.selectedMove_right - rate;
	}
	else
		level.selectedMove_right = 0;

	if ( buttonDown( "BUTTON_Y" ) )
	{
		if ( level.selectedMove_up < 0 )
			level.selectedMove_up = 0;

		level.selectedMove_up = level.selectedMove_up + rate;
	}
	else
	if ( buttonDown( "BUTTON_B" ) )
	{
		if ( level.selectedMove_up > 0 )
			level.selectedMove_up = 0;
		level.selectedMove_up = level.selectedMove_up - rate;
	}
	else
		level.selectedMove_up = 0;

//	vector = (level.selectedMove_right, level.selectedMove_forward, level.selectedMove_up);
	vector = ( 0, 0, 0 );
	vector += ( forward * level.selectedMove_forward );
	vector += ( right * level.selectedMove_right );
	vector += ( up * level.selectedMove_up );

	return vector;
}



set_anglemod_move_vector()
{
	rate = level._createfx.rate;

	if ( buttonDown( "kp_uparrow", "DPAD_UP" ) )
	{
		if ( level.selectedRotate_pitch < 0 )
			level.selectedRotate_pitch = 0;

		level.selectedRotate_pitch = level.selectedRotate_pitch + rate;
	}
	else
	if ( buttonDown( "kp_downarrow", "DPAD_DOWN" ) )
	{
		if ( level.selectedRotate_pitch > 0 )
			level.selectedRotate_pitch = 0;
		level.selectedRotate_pitch = level.selectedRotate_pitch - rate;
	}
	else
		level.selectedRotate_pitch = 0;

	if ( buttonDown( "kp_leftarrow", "DPAD_LEFT" ) )
	{
		if ( level.selectedRotate_yaw < 0 )
			level.selectedRotate_yaw = 0;

		level.selectedRotate_yaw = level.selectedRotate_yaw + rate;
	}
	else
	if ( buttonDown( "kp_rightarrow", "DPAD_RIGHT" ) )
	{
		if ( level.selectedRotate_yaw > 0 )
			level.selectedRotate_yaw = 0;
		level.selectedRotate_yaw = level.selectedRotate_yaw - rate;
	}
	else
		level.selectedRotate_yaw = 0;

	if ( buttonDown( "BUTTON_Y" ) )
	{
		if ( level.selectedRotate_roll < 0 )
			level.selectedRotate_roll = 0;

		level.selectedRotate_roll = level.selectedRotate_roll + rate;
	}
	else
	if ( buttonDown( "BUTTON_B" ) )
	{
		if ( level.selectedRotate_roll > 0 )
			level.selectedRotate_roll = 0;
		level.selectedRotate_roll = level.selectedRotate_roll - rate;
	}
	else
		level.selectedRotate_roll = 0;

}

update_selected_entities()
{
	for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
	{
		ent = level._createfx.selected_fx_ents[ i ];
		ent [[ level.func_updatefx ]]();
	}
}

hack_start( painter_spmp )
{
	if ( !IsDefined( painter_spmp ) )
		painter_spmp = "painter_mp";
	precachemenu( painter_spmp );
	wait .05; // make sure this wait stays above the return, since there is some logic in the calling code that assumes hack_start takes a frame.
	if( painter_spmp == "painter_mp" )
		return;
	
	level.player openpopupmenu( painter_spmp );// painter.menu execs some console commands( ufo mode ).. sneaky hacks.
	level.player closepopupmenu( painter_spmp );
}

stop_fx_looper()
{
	if ( IsDefined( self.looper ) )
		self.looper delete();
	self stop_loopsound();
}

stop_loopsound()
{
	self notify( "stop_loop" );
}

func_get_level_fx()
{
	AssertEx( IsDefined( level._effect ), "No effect aliases defined!" );

	if ( !IsDefined( level._effect_keys ) )
	{
		keys = GetArrayKeys( level._effect );
	}
	else
	{
		keys = GetArrayKeys( level._effect );
		if ( keys.size == level._effect_keys.size )
		{
			return level._effect_keys;
		}
	}

	println( "alphabetizing fx" );
	keys = alphabetize( keys );
	level._effect_keys = keys;
	return keys;
}

restart_fx_looper()
{
	stop_fx_looper();

	self set_forward_and_up_vectors();
	if ( self.v[ "type" ] == "loopfx" )
	{
		// new entities from copy/paste wont have a looper
		self create_looper();
	}

	if ( self.v[ "type" ] == "oneshotfx" )
	{
		// new entities from copy/paste wont have a looper
		self create_triggerfx();
	}

	if ( self.v[ "type" ] == "soundfx" )
	{
		// new entities from copy/paste wont have a looper
		self create_loopsound();
	}

	if ( self.v[ "type" ] == "soundfx_interval" )
	{
		// new entities from copy/paste wont have a looper
		self create_interval_sound();
	}
}

process_fx_rotater()
{
	if ( level.fx_rotating )
	{
		return;
	}


	set_anglemod_move_vector();

	if ( !rotation_is_occuring() )
	{
		return;
	}

	level.fx_rotating = true;

	if ( level._createfx.selected_fx_ents.size > 1 )
	{
		center = get_center_of_array( level._createfx.selected_fx_ents );
		org = spawn( "script_origin", center );
		org.v[ "angles" ] = level._createfx.selected_fx_ents[ 0 ].v[ "angles" ];
		org.v[ "origin" ] = center;
	
		rotater = [];
		for ( i = 0; i < level._createfx.selected_fx_ents.size; i++ )
		{
			rotater[ i ] = spawn( "script_origin", level._createfx.selected_fx_ents[ i ].v[ "origin" ] );
			rotater[ i ].angles = level._createfx.selected_fx_ents[ i ].v[ "angles" ];
			rotater[ i ] linkto( org );
		}
	
	//	println ("pitch " + level.selectedRotate_pitch + " yaw " + level.selectedRotate_yaw);
	
		rotate_over_time( org, rotater );
	
		org delete();
	
		for ( i = 0; i < rotater.size; i++ )
			rotater[ i ] delete();
	}
	else if ( level._createfx.selected_fx_ents.size == 1 )
	{
		ent = level._createfx.selected_fx_ents[ 0 ];
		rotater = spawn( "script_origin", ( 0, 0, 0 ) );
		rotater.angles = ent.v[ "angles" ];
		if ( level.selectedRotate_pitch != 0 )
			rotater AddPitch( level.selectedRotate_pitch );
		else
		if ( level.selectedRotate_yaw != 0 )
			rotater AddYaw( level.selectedRotate_yaw );
		else
			rotater AddRoll( level.selectedRotate_roll );
		ent.v[ "angles" ] = rotater.angles;
		rotater delete();
		wait( 0.05 );
	}

	level.fx_rotating = false;
}

//---------------------------------------------------------
// Help Section
//---------------------------------------------------------
show_help()
{
	//if help is already displayed, hide it by reselecting entitites
	if(level.createfx_help_active == true)
	{
		clear_fx_hudElements();
		//need to reset menu here
		//reselect_entitites();
		//clear_entity_selection();
		level.createfx_help_active = false;
		reselect_entitites();
		//level.fx_highLightedEnt entity_highlight_enable();

	}
   	else
   	{
		level.createfx_help_active = true;
		draw_help_list();
		thread help_navigation_buttons();
		clear_tool_hud();
   	}
   	wait 0.2;
}

//---------------------------------------------------------
// Write CreateFX Section
//---------------------------------------------------------
generate_fx_log( autosave )
{
	// first lets fix all the really small numbers so they dont cause errors because the game will print out
	// 4.2343-7e or whatever but cant accept it back in from script

	/#
	flag_waitopen( "createfx_saving" );
	flag_set( "createfx_saving" );
	autosave = IsDefined( autosave );
	tab = "\t";
	
	radiant_exploder_add_string = "";
	if( GetDvarInt( "scr_map_exploder_dump" ) )
	{
		radiant_exploder_add_string = "_radiant_exploders";
	}

	createfx_filter_types();
	createfx_adjust_array();
		
	// filename is deprecated
//	filename = "createfx/" + get_template_level() + radiant_exploder_add_string + "_fx.gsc";

//	if ( autosave )
//	{
//		filename = "createfx/backup.gsc";
//	}

//	file = openfile( filename, "write" );
//	assertex( file != -1, "File not writeable (maybe you should check it out): " + filename );
	file = -1;


//	func_cap = 700;// 700 is approximately 3500 lines in a function
//	total_functions = level.createFXEnt.size / func_cap;
//	for( i = 0; i < total_functions; i++ )
//	{
//		cfxprintln( tab + "fx_" + ( i + 1 ) + "();" );
//	}

	// creates default values. This is to stop createfx files from being filled with redundant settings.
	level._createfx.defaults = [];
	level._createfx.defaults[ "exploder/delay" ] = getExploderDelayDefault();
	level._createfx.defaults[ "oneshotfx/delay" ] = getOneshotEffectDelayDefault();
	level._createfx.defaults[ "loopfx/delay" ] = getLoopEffectDelayDefault();
	level._createfx.defaults[ "soundfx_interval/delay_min" ] = getIntervalSoundDelayMinDefault();
	level._createfx.defaults[ "soundfx_interval/delay_max" ] = getIntervalSoundDelayMaxDefault();


	if ( isSP() )
	{
		type = "fx";
		array = get_createfx_array( type );
		write_log( array, type, autosave, radiant_exploder_add_string );
	
		type = "sound";
		array = get_createfx_array( type );
		write_log( array, type, autosave, radiant_exploder_add_string );
	}
	else // MP, For now
	{
		write_log( level.createFXEnt, "fx", autosave, radiant_exploder_add_string );		
	}
	
//	saved = closefile( file );
//	assertex( saved == 1, "File not saved (see above message?): " + filename );
	flag_clear( "createfx_saving" );

//	println( "CreateFX entities placed: " + level.createFxEnt.size );
	#/
}

write_log( array, type, autosave, radiant_exploder_add_string )
{
	tab = "\t";
	cfxprintlnStart();
	cfxprintln( "//_createfx generated. Do not touch!!" );
	cfxprintln( "#include common_scripts\\utility;" );
	cfxprintln( "#include common_scripts\\_createfx;\n" );
	cfxprintln( "" );

	cfxprintln( "main()" );
	cfxprintln( "{" );
	cfxprintln( tab + "// CreateFX " + type + " entities placed: " + array.size );
	
	foreach ( e in array )
	{
		if ( level.createfx_loopcounter > 16 )
		{
			level.createfx_loopcounter = 0;
			wait .1; // give IWLauncher a chance to keep up
		}
		level.createfx_loopcounter++;

		assertEX( IsDefined( e.v[ "type" ] ), "effect at origin " + e.v[ "origin" ] + " has no type" );

		// don't post .map effects in the script.
//		if (e.v["worldfx"])
//			continue;

		// when scr_map_exploder_dump is set just output the exploders from radiant.  could output two scripts but keeping it simple.
		if( GetDvarInt("scr_map_exploder_dump") )
		{
			if ( !IsDefined( e.model ) )
				continue;
		}
		else if ( IsDefined( e.model ) )
		{
			continue; // entities with models are from radiant and don't get reported
		}
		
		if ( e.v[ "type" ] == "loopfx" )
		{
			cfxprintln( tab + "ent = createLoopEffect( \"" + e.v[ "fxid" ] + "\" );" );	
		}

		if ( e.v[ "type" ] == "oneshotfx" )
		{
			cfxprintln( tab + "ent = createOneshotEffect( \"" + e.v[ "fxid" ] + "\" );" );
		}

		if ( e.v[ "type" ] == "exploder" )
		{
			if( IsDefined( e.v[ "exploder" ] ) && !level.mp_createfx )
			{
				cfxprintln( tab + "ent = createExploderEx( \"" + e.v[ "fxid" ] + "\", \"" + e.v[ "exploder" ] + "\" );" );
			}
			else
			{
				cfxprintln( tab + "ent = createExploder( \"" + e.v[ "fxid" ] + "\" );" );
			}
		}

		if ( e.v[ "type" ] == "soundfx" )
		{
			cfxprintln( tab + "ent = createLoopSound();" );
		}

		if ( e.v[ "type" ] == "soundfx_interval" )
		{
			cfxprintln( tab + "ent = createIntervalSound();" );
		}

		cfxprintln( tab + "ent set_origin_and_angles( " + e.v[ "origin" ] + ", " + e.v[ "angles" ] + " );" );

		print_fx_options( e, tab, autosave );
		cfxprintln( "" );
	}

	cfxprintln( "}" );
	cfxprintln( " " );
	cfxprintlnEnd( autosave,  radiant_exploder_add_string, type );
}

createfx_adjust_array()
{
	limit = 0.1;
	foreach ( ent in level.createFXent )
	{
		origin = [];
		angles = [];
		for ( i = 0;i < 3;i++ )
		{
			origin[ i ] = ent.v[ "origin" ][ i ];
			angles[ i ] = ent.v[ "angles" ][ i ];

			if ( origin[ i ] < limit && origin[ i ] > limit * - 1 )
			{
				origin[ i ] = 0;
			}

			if ( angles[ i ] < limit && angles[ i ] > limit * - 1 )
			{
				angles[ i ] = 0;
			}
		}

		ent.v[ "origin" ] = ( origin[ 0 ], origin[ 1 ], origin[ 2 ] );
		ent.v[ "angles" ] = ( angles[ 0 ], angles[ 1 ], angles[ 2 ] );
	}
}

get_createfx_array( type )
{
	types = [];
	if ( type == "fx" )
	{
		types[ 0 ] = "loopfx";
		types[ 1 ] = "oneshotfx";
		types[ 2 ] = "exploder";
	}
	else // sound
	{
		types[ 0 ] = "soundfx";
		types[ 1 ] = "soundfx_interval";
	}
	
	array = [];
	foreach ( index, _ in types )
	{
		array[ index ] = [];
	}
	
	foreach ( ent in level.createFXent )
	{
		found_type = false;
		foreach ( index, type in types )
		{
			if ( ent.v[ "type" ] != type )
				continue;
				
			found_type = true;
			array[ index ][ array[ index ].size ] = ent;
			break;
		}
	}

	new_array = [];	
	for ( i = 0; i < types.size; i++ )
	{
		foreach ( ent in array[ i ] )
		{
			new_array[ new_array.size ] = ent;
		}
	}
	
	return new_array;	
}

createfx_filter_types()
{
	types = [];
	types[ 0 ] = "soundfx";
	types[ 1 ] = "loopfx";
	types[ 2 ] = "oneshotfx";
	types[ 3 ] = "exploder";
	types[ 4 ] = "soundfx_interval";
	
	array = [];
	foreach ( index, _ in types )
	{
		array[ index ] = [];
	}
	
	foreach ( ent in level.createFXent )
	{
		found_type = false;
		foreach ( index, type in types )
		{
			if ( ent.v[ "type" ] != type )
				continue;
				
			found_type = true;
			array[ index ][ array[ index ].size ] = ent;
			break;
		}
		
		assertex( found_type, "Didnt understand createfx type " + ent.v[ "type" ] );
	}

	new_array = [];	
	for ( i = 0; i < types.size; i++ )
	{
		foreach ( ent in array[ i ] )
		{
			new_array[ new_array.size ] = ent;
		}
	}
	
	level.createFXent = new_array;
}

cfxprintlnStart()
{
	fileprint_launcher_start_file();
}

cfxprintln( string )
{
	fileprint_launcher( string );
}

cfxprintlnEnd( autosave, radiant_exploder_add_string, type )
{
	bP4add = true;
	
	if( radiant_exploder_add_string != "" || autosave )
	{
		bP4add = false;
	}

	if ( isSP() )
	{
		scriptname = get_template_level() + radiant_exploder_add_string + "_" + type + ".gsc";
		if ( autosave )
		{
			scriptname = "backup" + "_" + type + ".gsc";
		}
	}
	else // MP, for now
	{
		scriptname = get_template_level() + radiant_exploder_add_string + "_" + type + ".gsc";
		if ( autosave )
		{
			scriptname = "backup.gsc";
		}
	}

	fileprint_launcher_end_file( "/share/raw/maps/createfx/" + scriptname, bP4add );
} 

//---------------------------------------------------------
// Button Section
//---------------------------------------------------------
process_button_held_and_clicked()
{
	add_button( "mouse1" );
	add_button( "BUTTON_RSHLDR" );
	add_button( "BUTTON_LSHLDR" );
	add_button( "BUTTON_RSTICK" );
	add_button( "BUTTON_LSTICK" );
	add_button( "BUTTON_A" );
	add_button( "BUTTON_B" );
	add_button( "BUTTON_X" );
	add_button( "BUTTON_Y" );
	add_button( "DPAD_UP" );
	add_button( "DPAD_LEFT" );
	add_button( "DPAD_RIGHT" );
	add_button( "DPAD_DOWN" );


	add_kb_button( "shift" );
	add_kb_button( "ctrl" );
	add_kb_button( "escape" );
	add_kb_button( "F1" );
	add_kb_button( "F5" );
	add_kb_button( "F4" );
	add_kb_button( "F2" );
	add_kb_button( "a" );
	add_kb_button( "g" );
	add_kb_button( "c" );
	add_kb_button( "h" );
	add_kb_button( "i" );
	add_kb_button( "k" );
	add_kb_button( "l" );
	add_kb_button( "m" );
	add_kb_button( "o" );
	add_kb_button( "p" );
	add_kb_button( "s" );
	add_kb_button( "u" );
	add_kb_button( "v" );
	add_kb_button( "x" );
	add_kb_button( "z" );
	add_kb_button( "del" );// DEL is allowed to be pressed while in select mode
	add_kb_button( "end" );
	add_kb_button( "tab" );
	add_kb_button( "ins" );
	add_kb_button( "add" );
	add_kb_button( "space" );
	add_kb_button( "enter" );
	add_kb_button( "1" );
	add_kb_button( "2" );
	add_kb_button( "3" );
	add_kb_button( "4" );
	add_kb_button( "5" );
	add_kb_button( "6" );
	add_kb_button( "7" );
	add_kb_button( "8" );
	add_kb_button( "9" );
	add_kb_button( "0" );
	add_kb_button( "-" );
	add_kb_button( "=" );
	add_kb_button( "," );
	add_kb_button( "." );
	add_kb_button( "leftarrow" );
	add_kb_button( "rightarrow" );
	add_kb_button( "uparrow" );
	add_kb_button( "downarrow" );
}


locked( name )
{
	if ( IsDefined( level._createfx.lockedList[ name ] ) )
		return false;

	return kb_locked( name );
}

kb_locked( name )
{
	return level.createfx_inputlocked && IsDefined( level.button_is_kb[ name ] );
}


add_button( name )
{
	if ( locked( name ) )
		return;

	if ( !IsDefined( level.buttonIsHeld[ name ] ) )
	{
		if ( level.player buttonPressed( name ) )
		{
			level.buttonIsHeld[ name ] = true;
			level.buttonClick[ name ] = true;
//			println("Button: " + name);
		}
	}
	else
	{
		if ( !level.player buttonPressed( name ) )
		{
			level.buttonIsHeld[ name ] = undefined;
		}
	}
}

add_kb_button( name )
{
	level.button_is_kb[ name ] = true;
	add_button( name );
}

buttonDown( button, button2 )
{
	return buttonPressed_internal( button ) || buttonPressed_internal( button2 );
}

buttonPressed_internal( button )
{
	if ( !IsDefined( button ) )
		return false;

	// keyboard buttons can be locked so you can type in the fx info on the keyboard without
	// accidentally activating features
	if ( kb_locked( button ) )
		return false;

	return level.player buttonPressed( button );
}

button_is_held( name, name2 )
{
	if ( IsDefined( name2 ) )
	{
		if ( IsDefined( level.buttonIsHeld[ name2 ] ) )
			return true;
	}
	return IsDefined( level.buttonIsHeld[ name ] );
}

button_is_clicked( name, name2 )
{
	if ( IsDefined( name2 ) )
	{
		if ( IsDefined( level.buttonClick[ name2 ] ) )
			return true;
	}
	return IsDefined( level.buttonClick[ name ] );
}

//---------------------------------------------------------
// HUD Section
//---------------------------------------------------------

init_huds()
{
	level._createfx.hudelems = [];
	level._createfx.hudElem_count = 30;
	// all this offset stuff lets us duplicate the text which puts an outline around
	// it and makes it more legible
	strOffsetX = [];
	strOffsetY = [];
	strOffsetX[ 0 ] = 0;
	strOffsetY[ 0 ] = 0;
	strOffsetX[ 1 ] = 1;
	strOffsetY[ 1 ] = 1;
	strOffsetX[ 2 ] = -2;
	strOffsetY[ 2 ] = 1;
	strOffsetX[ 3 ] = 1;
	strOffsetY[ 3 ] = -1;
	strOffsetX[ 4 ] = -2;
	strOffsetY[ 4 ] = -1;

	// setup the free text marker to allow some permanent strings
	level.clearTextMarker = newHudElem();
	level.clearTextMarker.alpha = 0;
	level.clearTextMarker setText( "marker" );
	
	for ( i = 0;i < level._createfx.hudelem_count;i++ )
	{
		newStrArray = [];
		for ( p = 0;p < 1;p++ )
		{
			newStr = newHudElem();
			newStr.alignX = "left";
			newStr.location = 0;
			newStr.foreground = 1;
			newStr.fontScale = 1.40;
			newStr.sort = 20 - p;
			newStr.alpha = 1;
			newStr.x = 0 + strOffsetX[ p ];
			newStr.y = 60 + strOffsetY[ p ] + i * 15;

			if ( p > 0 )
			{
				newStr.color = ( 0, 0, 0 );
			}

			newStrArray[ newStrArray.size ] = newStr;
		}

		level._createfx.hudelems[ i ] = newStrArray;
	}

	newStrArray = [];
	for ( p = 0; p < 5; p++ )
	{
		// setup instructional text
		newStr = newHudElem();
		newStr.alignX = "center";
		newStr.location = 0;
		newStr.foreground = 1;
		newStr.fontScale = 1.40;
		newStr.sort = 20 - p;
		newStr.alpha = 1;
		newStr.x = 320 + strOffsetX[ p ];
		newStr.y = 80 + strOffsetY[ p ];
		if ( p > 0 )
		{
			newStr.color = ( 0, 0, 0 );
		}

		newStrArray[ newStrArray.size ] = newStr;
	}

	level.createFX_centerPrint = newStrArray;
}

init_crosshair()
{
	// setup "crosshair"
	crossHair = newHudElem();
	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "middle";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 1;
	crossHair.x = 320;
	crossHair.y = 233;
	crossHair setText( "." );
}

clear_fx_hudElements()
{
	level.clearTextMarker ClearAllTextAfterHudElem();

	for ( i = 0;i < level._createfx.hudelem_count;i++ )
	{
		for ( p = 0; p < 1; p++ )
			level._createfx.hudelems[ i ][ p ] setText( "" );
	}

	level.fxHudElements = 0;
}

set_fx_hudElement( text )
{
	for ( p = 0;p < 1;p++ )
		level._createfx.hudelems[ level.fxHudElements ][ p ] setText( text );

	level.fxHudElements++;
	assert( level.fxHudElements < level._createfx.hudelem_count );
}

init_tool_hud()
{
	if ( !IsDefined( level._createfx.tool_hudelems ) )
	{
		level._createfx.tool_hudelems = [];
	}

	if ( !IsDefined( level._createfx.tool_hud_visible ) )
	{
		level._createfx.tool_hud_visible = true;
	}

	if ( !IsDefined( level._createfx.tool_hud ) )
	{
		level._createfx.tool_hud = "";
	}
}

toggle_tool_hud()
{	
}

new_tool_hud( name )
{
	foreach ( idx, hud in level._createfx.tool_hudelems )
	{
		if ( IsDefined( hud.value_hudelem ) )
		{
			hud.value_hudelem Destroy();
		}

		hud Destroy();

		level._createfx.tool_hudelems[ idx ] = undefined;
	}

	level._createfx.tool_hud = name;
}

current_mode_hud( name )
{
	return level._createfx.tool_hud == name;
}

clear_tool_hud()
{
	new_tool_hud( "" );
}

new_tool_hudelem( n )
{
	hud = newHudElem();
	hud.alignX = "left";
	hud.location = 0;
	hud.foreground = 1;
	hud.fontScale = 1.2;
	hud.alpha = 1;
	hud.x = 0;
	hud.y = 320 + ( n * 15 );
	return hud;
}

get_tool_hudelem( name )
{
	if ( IsDefined( level._createfx.tool_hudelems[ name ] ) )
	{
		return level._createfx.tool_hudelems[ name ];
	}

	return undefined;
}

set_tool_hudelem( var, value )
{
	hud = get_tool_hudelem( var );

	if ( !IsDefined( hud ) )
	{
		hud = new_tool_hudelem( level._createfx.tool_hudelems.size );
		level._createfx.tool_hudelems[ var ] = hud;
		hud SetText( var );
		hud.text = var;
	}

	if ( IsDefined( value ) )
	{
		if ( IsDefined( hud.value_hudelem ) )
		{
			value_hud = hud.value_hudelem;
		}
		else
		{
			value_hud = new_tool_hudelem( level._createfx.tool_hudelems.size );
			value_hud.x += 80;	
			value_hud.y = hud.y;
			hud.value_hudelem = value_hud;		
		}

		if ( IsDefined( value_hud.text ) && value_hud.text == value )
		{
			return;
		}

		value_hud SetText( value );
		value_hud.text = value;
	}
}

select_by_substring()
{
	substring = GetDvar( "select_by_substring" );
	if ( substring == "" )
	{
		return false;
	}
	
	SetDvar( "select_by_substring", "" );

	index_array = [];
	foreach ( i, ent in level.createFXent )
	{
		if ( IsSubStr( ent.v[ "fxid" ], substring ) )
		{
			index_array[ index_array.size ] = i;
		}
	}
	
	if ( index_array.size == 0 )
	{
		PrintLn( "^1select_by_substring could not find \"" + substring + "\"" );
		return false;
	}
	
	deselect_all_ents();
	select_index_array( index_array );
	
	foreach ( index in index_array )
	{
		ent = level.createFXent[ index ];
		select_entity( index, ent );
	}

	PrintLn( "select_by_substring found \"" + substring + "\" [" + index_array.size + "]" );
	return true;
}

select_index_array( index_array )
{
	foreach ( index in index_array )
	{
		ent = level.createFXent[ index ];
		select_entity( index, ent );
	}
}

deselect_all_ents()
{
	foreach ( i, ent in level._createfx.selected_fx_ents )
	{
		deselect_entity( i, ent );
	}
}

//---------------------------------------------------------
// Utility Section
//---------------------------------------------------------
get_player()
{
	return getentarray( "player", "classname" )[ 0 ];
}