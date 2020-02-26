#include common_scripts\utility;

// SP INCLUDES
#include maps\_utility;
#include maps\_createFxMenu;
// #include maps\_createfxundo;	// uncomment when working on undo feature

// MP INCLUDES
// #include maps\mp\_utility;
// #include maps\mp\_createFxMenu;

/* TODO: DLM: Doesn't seem to serve any purpose.  Remove in the future.
main()
{
	thread fx();
	thread createFxLogic();
	maps\_load::main();
}
*/

createfx()
{
	// Abstract much of the differences between MP and SP so they can use the same script file.
	// NOTE: Createfx() is only run when in CreateFX mode! Initialize functions and variables 
	// that need to be run on the client in fx_init().
	if ( isMP() )
	{
		init_mp_paths();
		SetDvar( "scr_tdm_timelimit", "0" );	// Keeps TDM timer from counting down
	}
	else
	{
		init_sp_paths();
	}

	precacheModel( "fx_axis_createfx" );
	PrecacheShader( "black" ); 

	if( GetDvar( "createfx_scaleid" ) == "" )
	{
		SetDvar( "createfx_scaleid", "0.5" );
	}
	
	if( GetDvar( "createfx_print_frames" ) == "" )
	{
		SetDvar( "createfx_print_frames", "3" );
	}
	
	if( GetDvar( "createfx_drawaxis" ) == "" )
	{
		SetDvar( "createfx_drawaxis", "1" );
	}

	if( GetDvar( "createfx_drawaxis_range" ) == "" )
	{
		SetDvar( "createfx_drawaxis_range", "2000" );
	}

	if( GetDvar( "createfx_autosave_time" ) == "" )
	{
		SetDvar( "createfx_autosave_time", "600" );
	}
	 
	flag_init( "createfx_saving" );

	// Effects placing tool
	if ( !isdefined( level.createFX ) )
	{
		level.createFX = [];
	}
	
	if ( isdefined( level.delete_when_in_createfx ) )
	{
		level [[ level.delete_when_in_createfx ]]();
	}

	triggers = get_triggers();
	for (i=0;i<triggers.size;i++)
	{
		triggers[i] delete();
	}
	
	sm = GetEntArray( "spawn_manager", "classname" );
	for( i = 0; i < sm.size; i ++)
	{
		sm[i] Delete();
	}	
	
	if ( isMP() )	// this section is compiled, but not run in SP, so paths have to be valid
	{
		//level.callbackStartGameType = ::void;
		level.callbackPlayerDisconnect = ::void;
		level.callbackPlayerDamage = ::void;
		level.callbackPlayerKilled = ::void;
		level.callbackPlayerConnect = ::Callback_PlayerConnect;
		
		while(!isdefined(level.player))
		{
			wait .05;
		}
	} else
	{
		delete_arrays_in_sp();
	}

	level thread camera_hud_toggle( "Normal Camera" );
	level.is_camera_on = false;
	thread createFxLogic();

	level waittill ("eternity");
}

fx_init()
{
	// wrapper for the exploder function so we dont have to use flags and do ifs/waittills on every exploder call
	if ( isMP() )
	{
		init_client_mp_variables();
	}
	else
	{
		init_client_sp_variables();
	}
	//level.exploderFunction = maps\_utility::exploder_before_load;	// <<------------------------ SP-specific
	level.exploderFunction = level.cfx_exploder_before;
	waittillframeend; // Wait one frame so the effects get setup by the maps fx thread
	waittillframeend; // Wait another frame so effects can be loaded based on start functions. Without this FX are initialiazed before they are defined by start functions.
	//level.exploderFunction = maps\_utility::exploder_after_load;	// <<------------------------ SP-specific
	level.exploderFunction = level.cfx_exploder_after;
	/#
	println("^2Running CreateFX 1.7.2");
	#/
	level.non_fx_ents = 0;
	
	for ( i=0; i<level.createFXent.size; i++ )
	{
		ent = level.createFXent[i];
		ent set_forward_and_up_vectors();

		// CODER_MOD
		// DSL - don't set up fx, if client scripts are running, and we're not the effects editor.

		if(level.clientscripts)
		{
			if(!level.createFX_enabled)
			{
				continue;
			}
		}
		if (isdefined(ent.model))	// Model ents are from Radiant, so they don't count
		{
			level.non_fx_ents++;
		}
		if (ent.v["type"] == "loopfx")
		{
			//ent thread maps\_fx::loopfxthread();	// <<------------------------ SP-specific
			ent thread [[level.cfx_func_loopfx]]();
		}
		if (ent.v["type"] == "oneshotfx")
		{
			//ent thread maps\_fx::oneshotfxthread();	// <<------------------------ SP-specific
			ent thread [[level.cfx_func_oneshotfx]]();
		}
		if (ent.v["type"] == "soundfx")
		{
			//ent thread maps\_fx::create_loopsound();	// <<------------------------ SP-specific
			ent thread [[level.cfx_func_soundfx]]();
		}
	}
	if ( isMP() )	// start up ambient fx animations
	{
		fxanim_init();
	}
}

add_effect(name, effect)	// Possibly MP only
{
	if (!isdefined (level._effect))
	{
		level._effect = [];
	}

	level._effect[ name ] = loadfx( effect );
}

// Adds effects as entities in level.createFXent[].
createEffect( type, fxid )	// Called by _utility.gsc
{
	ent = undefined;
	
	if(!IsDefined(level.createFX_enabled))
	{
		level.createFX_enabled = ( GetDvar( "createfx" ) != "" );
	}
	
	if(level.createFX_enabled)
	{
		ent = spawnStruct();
	}
	else if(type == "exploder")
	{
		ent = SpawnStruct();
	}
	else
	{
		if(!IsDefined(level._fake_createfx_struct))
		{
			level._fake_createfx_struct = SpawnStruct();
		}
		
		ent = level._fake_createfx_struct;
	}
	
	if (!isdefined(level.createFXent))
	{
		level.createFXent = [];
	}
	
	level.createFXent[level.createFXent.size] = ent;
	ent.v = [];
	ent.v["type"] = type;
	ent.v["fxid"] = fxid;
	ent.v["angles"] = (0,0,0);
	ent.v["origin"] = (0,0,0);
	ent.drawn = true;
	return ent;
}

createLoopSound()
{
	ent = spawnStruct();
	if (!isdefined(level.createFXent))
	{
		level.createFXent = [];
	}
	
	level.createFXent[level.createFXent.size] = ent;
	ent.v = [];
	ent.v["type"] = "soundfx";
	ent.v["fxid"] = "No FX";
	ent.v["soundalias"] = "nil";
	ent.v["angles"] = (0,0,0);
	ent.v["origin"] = (0,0,0);
	ent.drawn = true;
	return ent;
}

// DLM - 2/18/2011: No longer used
//createNewExploder( fxid )
//{
//	ent = spawnStruct();
//	if ( !isdefined( level.createFXent ) )
//	{
//		level.createFXent = [];
//	}
//	
//	level.createFXent[ level.createFXent.size ] = ent;
//	ent.v = [];
//	ent.v[ "type" ] = "exploder";
//	ent.v[ "fxid" ] = fxid;
//	//ent.v[ "soundalias" ] = "nil"; // DLM - 6/18/2010 - Sound doesn't use CreateFX anymore
//	ent.v[ "angles" ] = (0,0,0);
//	ent.v[ "origin" ] = (0,0,0);
//	ent.v[ "exploder" ] = 1;
//	ent.v[ "exploder_type" ] = "normal";
//	ent.drawn = true;
//	return ent;
//}

set_forward_and_up_vectors()
{
	self.v["up"] = anglestoup(self.v["angles"]);
	self.v["forward"] = anglestoforward(self.v["angles"]);
}


createFxLogic()
{
	waittillframeend; // let _load run first

	//setMapCenter( (0,0,0) );	// May not be necessary for MP anymore

	menu_init();
	
	if ( !isMP() )
	{
		// copied from _utility.gsc::wait_for_first_player() because mp\_utility.gsc doesn't have this function
		players = get_players("all");
		if( !IsDefined( players ) || players.size == 0 )
		{
			level waittill( "first_player_ready" );
		}
	}

	/#
	Adddebugcommand( "noclip" );
	#/
	
	if ( !isdefined( level._effect ) )
	{
		level._effect = [];
	}

	if (GetDvar( "createfx_map") == "")
	{
		SetDvar("createfx_map", level.script);
	}
	else if (GetDvar( "createfx_map") == level.script)
	{
		if ( !isMP() )
		{
			// if we're still on the same map then..
			// set the player's position so map restart doesn't move your origin in createfx
			playerPos = [];
			playerPos[0] = GetDvarint( "createfx_playerpos_x");
			playerPos[1] = GetDvarint( "createfx_playerpos_y");
			playerPos[2] = GetDvarint( "createfx_playerpos_z");
			
			player = get_players()[0];
			player setOrigin((playerPos[0], playerPos[1], playerPos[2]));
		}
	}
	
	// ARTIST_MOD: DLM - 5/23/2010 - Test if the createfx script file is writeable.
	// If it is, log the error for a later warning.
	/#
	//filename = "createfx/" + level.script + "_fx.gsc";
	filename = level.cfx_server_scriptdata + level.script + "_fx.gsc";
	file = openfile(filename, "append");
	level.write_error = "";
	if (file == -1)
	{
		level.write_error = filename;
	}
	else
	{
		closefile(file); // in case the file is kept "open" after a read error
	}
	#/
	
	level.createFxHudElements = [];
	level.createFx_hudElements = 30;
	// all this offset stuff lets us duplicate the text which puts an outline around
	// it and makes it more legible
	strOffsetX = [];
	strOffsetY = [];
	strOffsetX[0] = 0;
	strOffsetY[0] = 0;
	strOffsetX[1] = 1;
	strOffsetY[1] = 1;
	strOffsetX[2] = -2;
	strOffsetY[2] = 1;
//	strOffsetX[3] = 1;
//	strOffsetY[3] = -1;
//	strOffsetX[4] = -2;
//	strOffsetY[4] = -1;
	
	SetDvar("fx", "nil");
	
	// setup "crosshair"
	crossHair = newDebugHudElem();
	crossHair.location = 0;
	crossHair.alignX = "center";
	crossHair.alignY = "middle";
	crossHair.foreground = 1;
	crossHair.fontScale = 2;
	crossHair.sort = 20;
	crossHair.alpha = 1;
	crossHair.x = 320;
	crossHair.y = 233;
	crossHair setText(".");
	
	// Initialize the HUD element used for warnings and such.

	
	center_text_init();
	
	// setup the free text marker to allow some permanent strings
	level.clearTextMarker = newDebugHudElem();
	level.clearTextMarker.alpha = 0;
	level.clearTextMarker setText( "marker" );

	for (i=0;i<level.createFx_hudElements;i++)
	{
		newStrArray = [];
		// MikeD (8/8/2007): Reduced p<5 to p<2 to save on hudelems.
		for (p=0;p<2;p++)
		{
			newStr = newHudElem();
			newStr.alignX = "left";
			newStr.location = 0;
			newStr.foreground = 1;
			newStr.fontScale = 1.10;
			newStr.sort = 20 - p;
			newStr.alpha = 1;
			newStr.x = 0 + strOffsetX[p];
			newStr.y = 60 + strOffsetY[p] + i * 15;
			
			if (p > 0)
			{
				newStr.color = (0,0,0);
			}
			newStrArray[newStrArray.size] = newStr;
		}
		level.createFxHudElements[i] = newStrArray;
	}

	// gets cumulatively added to to create digital acceleration
	level.selectedMove_up = 0;
	level.selectedMove_forward = 0;
	level.selectedMove_right = 0;
	level.selectedRotate_pitch = 0;
	level.selectedRotate_roll = 0;
	level.selectedRotate_yaw = 0;
	level.selected_fx = [];	// holds the indices of selected ents from level.createFXents
	level.selected_fx_ents = [];	// holds the ent info for selected ents
	
	level.createfx_lockedList = [];
	level.createfx_lockedList["escape"] = true;
	level.createfx_lockedList["BUTTON_LSHLDR"] = true;
	level.createfx_lockedList["BUTTON_RSHLDR"] = true;
	level.createfx_lockedList["mouse1"] = true;
	level.createfx_lockedList["ctrl"] = true;
	
	level.createfx_draw_enabled = true;
	
	level.buttonIsHeld = [];
	axisMode = false;
	
	colors = [];
	colors["loopfx"]["selected"] 		= (1.0, 1.0, 0.2);
	colors["loopfx"]["highlighted"] 	= (0.4, 0.95, 1.0);
	colors["loopfx"]["default"]		 	= (0.3, 0.8, 1.0);

	colors["oneshotfx"]["selected"] 	= (1.0, 1.0, 0.2);
	colors["oneshotfx"]["highlighted"] 	= (0.4, 0.95, 1.0);
	colors["oneshotfx"]["default"]		= (0.3, 0.8, 1.0);

	colors["exploder"]["selected"] 		= (1.0, 1.0, 0.2);
	colors["exploder"]["highlighted"] 	= (1.0, 0.2, 0.2);
	colors["exploder"]["default"]		= (1.0, 0.1, 0.1);

	colors["rainfx"]["selected"] 		= (1.0, 1.0, 0.2);
	colors["rainfx"]["highlighted"] 	= (.95, 0.4, 0.95);
	colors["rainfx"]["default"]			= (.78, 0.0, 0.73);

	colors["soundfx"]["selected"]	 	= (1.0, 1.0, 0.2);
	colors["soundfx"]["highlighted"] 	= (.5, 1.0, 0.75);
	colors["soundfx"]["default"]		= (.2, 0.9, 0.2);
	
	lastHighlightedEnt = undefined;
	level.fx_rotating = false;
	setMenu("none");
	level.createfx_selecting = false;

	level.createfx_last_player_origin = (0,0,0);
	level.createfx_last_player_forward = (0,0,0);
	level.createfx_last_view_change_test = 0;
	
	player = get_players()[0];
	lastPlayerOrigin = player.origin;

	// black background for text
	// MikeD (3/3/2008): Using debug hud elems since we're running out of regular ones.
	black = newDebugHudElem();
	black.x = -120;
	black.y = 200;
//			black[i].alignX = "center";
//			black[i].alignY = "middle";
	black.foreground = 0;
	black setShader("black", 250, 160);
	black.alpha = 0; // 0.6;
	
	level.createfx_inputlocked = false;
	
	// ARTIST_MOD: DaleM - 10/05/2009 - Keep track of help menu so it doesn't stay on screen all the time
	help_on_last_frame = 0;
	
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		ent = level.createFXent[i];
		ent post_entity_creation_function();
	}

	thread draw_distance();	
	lastSelectEntity = undefined;
	thread createfx_autosave();
	
	if ( !isMP() )
	{
		make_sp_player_invulnerable(player);
	}
		
	for (;;)
	{
		player = get_players()[0];
		
		changedSelectedEnts = false;

		// calculate the "cursor"
		right = anglestoright (player getplayerangles());
		forward = anglestoforward (player getplayerangles());
		up = anglestoup (player getplayerangles());
		dot = 0.85;

		placeEnt_vector = VectorScale(forward, 750);
		level.createfxCursor = bullettrace(player geteye(), player geteye() + placeEnt_vector, false, undefined);
		highlightedEnt = undefined;



		// ************************************************************
		//
		// 				General input
		//
		// ************************************************************
		
		level.buttonClick = [];
		level.button_is_kb = [];
		process_button_held_and_clicked();
		ctrlHeld = button_is_held("ctrl", "BUTTON_LSHLDR" );
		shiftHeld = button_is_held("shift");
		functionHeld = button_is_held("f"); // function shift for message pad
		leftClick = button_is_clicked("mouse1", "BUTTON_A" );
		leftHeld = button_is_held("mouse1", "BUTTON_A" );
		//consoleOn = false; // assume it's off on startup

		create_fx_menu();
		
		// ARTIST_MOD: DLM - 4/8/2010 - added check for if console is open. If it is, lock key input.
		// TODO: Make the console check work.  It doesn't STOP locking the input until an ent is selected.
		// Also, if alternate text entry is introduced, this is pointless.
//		if ( button_is_clicked("~") )
//		{
//			consoleOn = !consoleOn;
//			if ( consoleOn)
//			{
//				level.createfx_inputlocked = true;
//			}
//			else
//			{
//				level.createfx_inputlocked = false;
//			}
//		}

		// ARTIST_MOD: DM: 9/29/2009 - added chatpad-compatible keys to console actions
		// Changed keyboard shortcut for axis mode
		// Rotation mode
		
		

		if ( button_is_clicked("BUTTON_X") || (shiftHeld && button_is_clicked("x")))
		{
			axisMode = !axisMode;
		}

		// Hide CreateFX elements
		if ( button_is_clicked( "F2" ) || ( functionHeld && button_is_clicked("2") ) )
		{
			toggle_createfx_drawing();
		}
		
		// Print how often ambient effects are placed
		if ( button_is_clicked( "F3" ) || ( functionHeld && button_is_clicked("3") ) )
		{
			print_ambient_fx_inventory();
		}
		
		// Save changes
		if ( button_is_clicked( "F5" ) || ( functionHeld && button_is_clicked("5") ) )
		{
			createfx_save();
		}
				
		// Add a new effect
		if (button_is_clicked("ins","i"))
		{
			insert_effect();
		}

		// toggle between orbit camera and normal camera
		if (button_is_clicked( "c") )
		{

			if(level.is_camera_on == false)
			{

			//	if( GetDvarint( "noclip") == 1 )
			//	{
					Adddebugcommand( "noclip" );
			//	}
				
				level thread handle_camera();
				level.is_camera_on = true;
				level.camera_hud SetText( "Orbit Camera" );

			}
			else if(level.is_camera_on == true)
			{

			//	if( GetDvarint( "noclip") == 0 )
			//	{
					Adddebugcommand( "noclip" );
			//	}
				level notify("new_camera");
				level.is_camera_on = false;
				axismode = false;
				level.camera_hud SetText( "Normal Camera" );
			}

	
		}

		if(button_is_held("BUTTON_RTRIG") && level.is_camera_on)
		{
			axisMode = true;
		}
		else if( !button_is_held("BUTTON_RTRIG") && level.is_camera_on )
		{
			axisMode = false;

		}


		// Delete selected effect
		if (button_is_clicked("del", "d"))
		{
			delete_pressed();
		}
		
		// Move effect to ground
		if (button_is_clicked("end", "l"))
		{
			drop_selection_to_ground();
			changedSelectedEnts = true;
		}
		
		// Select all effects with the chosen property as the first selected ent
		if ( button_is_clicked("s") )
		{
			setmenu("select_by_property");
			wait 0.05;
		}
		if ( isdefined( level.cfx_selected_prop ) ) // This only has a value after the user chooses a property to select by.
		{
			if (ctrlHeld)
			{
				select_ents_by_property(level.cfx_selected_prop, true);
			}
			else
			{
				select_ents_by_property(level.cfx_selected_prop);
			}
			level.cfx_selected_prop = undefined;
		}
		
		// Select an effect from the list and move player to it
		if (button_is_clicked("j"))
		{
			setmenu("jump_to_effect");
			draw_effects_list( "Select effect to jump to:" );
		}
		
		// Deselect everything and hide menus (at the moment, it seems to pause the game)
		if (button_is_clicked("escape"))
		{
			clear_settable_fx();
		}

		// Set off exploders and turn off exploders (self explanatory, I know)
		if ( button_is_clicked("space") && !shiftHeld )
		{
			set_off_exploders();
		}
		if (button_is_clicked("space") && shiftHeld )
		{
			turn_off_exploders();
		}

		// Move effect(s) to where the reticule is now
		if (button_is_clicked("tab", "BUTTON_RSHLDR"))
		{
			move_selection_to_cursor();
			changedSelectedEnts = true;
		}
		
		// Help menu
		if ( button_is_held( "q", "F1" ) )
		{
			help_on_last_frame = 1;
			show_help();
			wait (0.05);
			continue;
		}
		else if (help_on_last_frame == 1)
		{
			clear_fx_hudElements();
			help_on_last_frame = 0;
		}

		// Copy and paste selected effect(s) for 360
		if ( button_is_clicked( "BUTTON_LSTICK" ) && !ctrlHeld )
		{
			copy_ents();
		}
		if ( button_is_clicked( "BUTTON_RSTICK" ) && !ctrlHeld )
		{
			paste_ents();
		}

		// Copy and paste selected effect(s) for PC
		if (ctrlHeld)
		{
			if (button_is_clicked("c") && !ctrlHeld )
			{
				copy_ents();
			}

			if (button_is_clicked("v") && !ctrlHeld )
			{
				paste_ents();
			}
		}

		if (isdefined(level.selected_fx_option_index))
		{
			menu_fx_option_set();
		}

		if ( button_is_held( "BUTTON_RTRIG" ) && button_is_held( "BUTTON_LTRIG" ))
		{
			move_player_around_map_fast();
			wait (0.25);
			continue;
		}

		// If one effect is selected, player is moved to next instance of it.  If more than one is selected,
		// player is moved to the next selected effect.
		if ( menu("none") && button_is_clicked( "rightarrow" ) )
		{
			// menu() is a function in _createfxMenu.gsc.  "none" is when there are no active menus.
			move_player_to_next_same_effect(lastSelectEntity);
		}
		
		// File write error detected
		if ( level.write_error != "" )
		{
			level notify("write_error");
			thread write_error_msg(level.write_error);
			level.write_error = "";
		}

		// ************************************************************
		//
		// 				Highlighted Entity Handling
		//
		// ************************************************************

		highLightedEnt = level.fx_highLightedEnt;
		
		if ( leftClick || GetTime() - level.createfx_last_view_change_test > 250 )
		{
			if ( leftClick || vector_changed( level.createfx_last_player_origin, player.origin ) || dot_changed( level.createfx_last_player_forward, forward ) )
			{
				for ( i = 0; i < level.createFXent.size; i++ )
				{
					ent = level.createFXent[i];
					
					difference = vectornormalize(ent.v["origin"] - (player.origin + (0,0,55)));
					newdot = vectordot(forward, difference);
					
					if (newdot < dot)
					{
						continue;
					}
		
					dot = newdot;
					highlightedEnt = ent;
							highlightedEnt.last_fx_index = i;
				}
						
				level.fx_highLightedEnt = highLightedEnt;
				
				level.createfx_last_player_origin = player.origin;
				level.createfx_last_player_forward = forward;
			}
			level.createfx_last_view_change_test = GetTime();
		}
		
		if (isdefined(highLightedEnt))
		{
			if (isdefined(lastHighlightedEnt))
			{
				if (lastHighlightedEnt != highlightedEnt)
				{
					// a highlighted ent is no longer highlighted
					if (!ent_is_selected(lastHighlightedEnt))
					{
						lastHighlightedEnt thread entity_highlight_disable();
					}
					// an ent became highlighted for the first time
					if (!ent_is_selected(highlightedEnt))
					{
						highlightedEnt thread entity_highlight_enable();
					}
				}
			}
			else
			{
				// an ent became highlighted for the first time
				if (!ent_is_selected(highlightedEnt))
				{
					highlightedEnt thread entity_highlight_enable();
				}
			}
		}

		manipulate_createfx_ents( highlightedEnt, leftClick, leftHeld, ctrlHeld, colors, right );
		
		// ************************************************************
		//
		// 				Rotation and Movement
		//
		// ************************************************************
		
		if (axisMode && level.selected_fx_ents.size > 0)
		{
			// draw axis and do rotation if shift is held
			// DaleM: 9/29/2009 - Changed rotation mode hot key from p to r
			thread process_fx_rotater();
			if ( button_is_clicked( "enter", "r" ) )
			{
				reset_axis_of_selected_ents();
			}

			if ( button_is_clicked( "v" ) )
			{
				copy_angles_of_selected_ents();
			}
			
			if( GetDvarint( "createfx_drawaxis" ) == 1 )
			{
				for ( i=0; i < level.selected_fx_ents.size; i++)
				{
					level.selected_fx_ents[i] draw_axis();
				}
			}

			if ( level.selectedRotate_pitch != 0 || level.selectedRotate_yaw != 0  || level.selectedRotate_roll != 0 )
			{
				changedSelectedEnts = true;
			}
			wait (0.05);
/*
			for ( i=0; i < level.selected_fx_ents.size; i++)
			{
				ent = level.selected_fx_ents[i];
				ent.angles = ent.angles + (level.selectedRotate_pitch, level.selectedRotate_yaw, 0);
				ent set_forward_and_up_vectors();
			}
			
			if (level.selectedRotate_pitch != 0 || level.selectedRotate_yaw != 0)
				changedSelectedEnts = true;
*/
		}
		else
		{
			stop_drawing_axis_models();
			selectedMove_vector = get_selected_move_vector();
			
			for ( i=0; i < level.selected_fx_ents.size; i++)
			{
				ent = level.selected_fx_ents[i];
				
				if (isdefined(ent.model)) // ents with brushmodels are from radiant and dont get moved
				{
					continue;
				}
					
				ent.v["origin"] = ent.v["origin"] + selectedMove_vector;
			}

			if ( distancesquared( (0,0,0), selectedMove_vector) > 0 )
			{
				changedSelectedEnts = true;
			}
			wait(0.05);
		}
		
		if ( changedSelectedEnts )
		{
			update_selected_entities();
		}

		if (distance(lastPlayerOrigin, player.origin) > 64)
		{
			// save the player's position so we can go back here on a map restart
			SetDvar("createfx_playerpos_x", player.origin[0]);
			SetDvar("createfx_playerpos_y", player.origin[1]);
			SetDvar("createfx_playerpos_z", player.origin[2]);
			lastPlayerOrigin = player.origin;
		}

		lastHighlightedEnt = highlightedEnt;
		
		// if the last selected entity changes then reset the options offset
		if ( last_selected_entity_has_changed ( lastSelectEntity ))
		{
			level.effect_list_offset = 0;
			clear_settable_fx();
			setmenu("none");
		}
		
		if (level.selected_fx_ents.size)
		{
			lastSelectEntity = level.selected_fx_ents[level.selected_fx_ents.size-1];
		}
		else
		{
			lastSelectEntity = undefined;
		}
	}
}

toggle_createfx_drawing()
{
	level.createfx_draw_enabled = !level.createfx_draw_enabled;
}

manipulate_createfx_ents( highlightedEnt, leftClick, leftHeld, ctrlHeld, colors, right )
{
	if ( !level.createfx_draw_enabled )
	{
		return;
	}
	
	scale = GetDvarfloat( "createfx_scaleid" );
	print_frames = GetDvarint( "createfx_print_frames" );
	
	if ( !IsDefined(level.createfx_manipulate_offset) )
	{
		level.createfx_manipulate_offset = 0;
	}
	offset = level.createfx_manipulate_offset;
	
	level.createfx_manipulate_offset = ( level.createfx_manipulate_offset + 1 ) % print_frames;
	
	// TODO - DLM: Make this go through all non-selected ents only
	// TODO - DLM: When an ent is deleted, it's 3D Hudelem tag needs to go away too.  Currently, 
	// 	it sticks around until the user puts a cursor over it.
	for ( i = offset; i < level.createFXent.size; i += print_frames )
	{
		ent = level.createFXent[i];
		if ( !ent.drawn )
		{
			continue;
		}

		if ( isdefined( highlightedEnt ) && (ent == highlightedEnt) )
		{ 
			// highlighted entity gets taken care of below now
			continue;
		}
		else
		{
			colorIndex = "default";
			
			if ( index_is_selected( i ) )
			{
				colorIndex = "selected";
			}
			print3d( ent.v[ "origin" ], ".", colors[ ent.v[ "type" ] ][ colorIndex ], 1, scale, print_frames );
			
			if ( ent.textalpha > 0 )
			{
				printRight = VectorScale(right, ent.v["fxid"].size * -2.93 );
				print3d( ent.v[ "origin" ] + printRight + (0,0,15), ent.v[ "fxid" ], colors[ ent.v[ "type" ] ][ colorIndex ], ent.textalpha, scale, print_frames );
			}

		}
	}
		
	// TODO - DLM: Make this part handle all selected ents
	if ( isdefined( highlightedEnt ) )	// highlightedEnt is whichever entity is nearest to the cursor
	{
		if ( !entities_are_selected() )
		{
			display_fx_info( highlightedEnt );
		}
			
		if ( leftClick )
		{
			entWasSelected = index_is_selected( highlightedEnt.last_fx_index );
			level.createfx_selecting = !entWasSelected; // used for drag select/deselect
			if ( !ctrlHeld )
			{
				selectedSize = level.selected_fx_ents.size;
				clear_entity_selection();
				if ( entWasSelected && selectedSize == 1 )
				{
					select_entity( highlightedEnt.last_fx_index, highlightedEnt );
				}
			}
			toggle_entity_selection( highlightedEnt.last_fx_index, highlightedEnt );
		}
		else if ( leftHeld )
		{
			if ( ctrlHeld )
			{
				if ( level.createfx_selecting )
				{
					select_entity( highlightedEnt.last_fx_index, highlightedEnt);
				}

				if ( !level.createfx_selecting )
				{
					deselect_entity( highlightedEnt.last_fx_index, highlightedEnt);
				}
			}
		}

		colorIndex = "highlighted";
		
		if ( index_is_selected( highlightedEnt.last_fx_index ) )
		{
			colorIndex = "selected";
		}
		print3d( highlightedEnt.v["origin"], ".", colors[ highlightedEnt.v[ "type" ] ][ colorIndex ], 1, scale, 1 );
		
		if ( highlightedEnt.textalpha > 0 )
		{
			printRight = VectorScale( right, highlightedEnt.v[ "fxid" ].size * -2.93 * scale );
			print3d( highlightedEnt.v[ "origin" ] + printRight + (0,0,15), highlightedEnt.v[ "fxid" ], colors[ highlightedEnt.v[ "type" ] ][ colorIndex ], highlightedEnt.textalpha, scale, 1 );
		}
	}
}

clear_settable_fx()
{
	level.createfx_inputlocked = false;
	SetDvar("fx", "nil");
	// in case we were modifying an option
	level.selected_fx_option_index = undefined;
	reset_fx_hud_colors();
}

reset_fx_hud_colors()
{
	for ( i=0;i<level.createFx_hudElements; i++)
	{
		level.createFxHudElements[ i ][0].color = (1,1,1);
	}
}


button_is_held( name, name2 )
{
	if (isdefined( name2 ))
	{
		if ( isdefined (level.buttonIsHeld[name2]) )
		{
			return true;
		}
	}
	return isdefined(level.buttonIsHeld[name]);
}

button_is_clicked( name, name2 )
{
	if (isdefined(name2))
	{
		if (isdefined(level.buttonClick[name2]))
		{
			return true;
		}
	}
	return isdefined(level.buttonClick[name]);
}

toggle_entity_selection( index, ent )
{
	if (isdefined(level.selected_fx[index]))
	{
		deselect_entity(index, ent);
	}
	else
	{
		select_entity(index, ent);
	}
}

select_entity( index, ent )
{
	// index is index of level.createFXent[]
	if (isdefined(level.selected_fx[index]))
	{
		return;
	}
	clear_settable_fx();
	level notify ("new_ent_selection");
		
	ent thread entity_highlight_enable();

	level.current_select_ent = ent;
	

	level.selected_fx[index] = true;
	level.selected_fx_ents[level.selected_fx_ents.size] = ent;
}

ent_is_highlighted ( ent )
{
	if (!isdefined( level.fx_highLightedEnt ))
	{
		return false;
	}
	return ent == level.fx_highLightedEnt;
}


deselect_entity( index, ent )
{
	if (!isdefined(level.selected_fx[index]))
	{
		return;
	}

	clear_settable_fx();
	level notify ("new_ent_selection");
		
	level.selected_fx[index] = undefined;

	if (!ent_is_highlighted(ent))
	{
		ent thread entity_highlight_disable();
	}
	
	// remove the entity from the array of selected entities
	newArray = [];
	for (i=0; i<level.selected_fx_ents.size; i++)
	{
		if (level.selected_fx_ents[i] != ent)
		{
			newArray[newArray.size] = level.selected_fx_ents[i];
		}
	}
	level.selected_fx_ents = newArray;
}

index_is_selected( index )
{
	return isdefined(level.selected_fx[index]);
}

ent_is_selected ( ent )
{
	for (i=0; i<level.selected_fx_ents.size; i++)
	{
		if (level.selected_fx_ents[i] == ent)
		{
			return true;
		}
	}
	return false;
}
	
clear_entity_selection()
{
	for (i=0; i<level.selected_fx_ents.size; i++)
	{
		if (!ent_is_highlighted( level.selected_fx_ents[i] ))
		{
			level.selected_fx_ents[i] thread entity_highlight_disable();
		}
	}
	level.selected_fx = [];
	level.selected_fx_ents = [];
}

draw_axis()
{
	
	if( IsDefined( self.draw_axis_model ) )
	{
		return;
	}
	
	// MikeD: (8/14/2007): line() for some reason takes up to memory, so we made a AXIS model.
	self.draw_axis_model = spawn_axis_model( self.v["origin"], self.v["angles"] );
	
	level thread draw_axis_think( self );
	
	if( !IsDefined( level.draw_axis_models ) )
	{
		level.draw_axis_models = [];
	}
	level.draw_axis_models[level.draw_axis_models.size] = self.draw_axis_model;
}

// ARTIST_MOD: DaleM - 10/05/2009 - Adding SP method of spawning axis
spawn_axis_model( origin, angles )
{
	model = Spawn( "script_model", origin );
	model SetModel( "fx_axis_createfx" );
	model.angles = angles;
	return model;
}

draw_axis_think( axis_parent )
{
	axis_model = axis_parent.draw_axis_model;
	axis_model endon( "death" );

	player = get_players()[0];

	while( 1 )
	{
		// Check to make sure the axis_parent is available.
		if( !IsDefined( axis_parent ) )
		{
			break;
		}

		range = GetDvarint( "createfx_drawaxis_range" );
		//if( DistanceSquared( axis_model.origin, level.player.origin ) > range * range )	// <<------------------------ MP-specific
		if( DistanceSquared( axis_model.origin, player.origin ) > range * range )
		{
			if( IsDefined( axis_model ) )
			{
				axis_model Delete();
				level.draw_axis_models = array_removeUndefined( level.draw_axis_models );
			}
		}
		else
		{
			if( !IsDefined( axis_model ) )
			{
				axis_model = spawn_axis_model( axis_parent.v["origin"], axis_parent.v["angles"] );
				axis_parent.draw_axis_model = axis_model;
				level.draw_axis_models[level.draw_axis_models.size] = axis_model;
			}
		}
	
		axis_model.origin = axis_parent.v["origin"];
		axis_model.angles = axis_parent.v["angles"];

		wait( 0.25 );
	}

	if( IsDefined( axis_model ) )
	{
		axis_model Delete();
	}	
}

//draw_axis_think( axis_parent )
//{
//	axis_model = axis_parent.draw_axis_model;
//	
//	while( 1 )
//	{
//		// Check to make sure the axis_parent is available.
//		if( !IsDefined( axis_parent ) )
//		{
//			break;
//		}
//		
//		if( !IsDefined( axis_model ) )
//		{
//			break;
//		}
//		
//		axis_parent.draw_axis_model.origin = axis_parent.v["origin"];
//		axis_parent.draw_axis_model.angles = axis_parent.v["angles"];
//
//		wait( 0.05 );
//}
//
//	if( IsDefined( axis_model ) )
//	{
//			axis_model Delete();
//	}	
//}

stop_drawing_axis_models()
{
	if( IsDefined( level.draw_axis_models ) )
	{
		// MikeD: Remove the draw_axis model
		for( i = 0; i < level.draw_axis_models.size; i++ )
		{
			if( IsDefined( level.draw_axis_models[i] ) )
			{
				level.draw_axis_models[i] Delete();
			}
		}
		level.draw_axis_models = array_removeUndefined( level.draw_axis_models );
	}
}

clear_fx_hudElements()
{
	// This is necessary to prevent a G_FindConfigstringIndex overflow.
	//level.clearTextMarker clearAllTextAfterHudElem();
	// DLM - 2/14/2011: Moved point of text clearing to after center text since it was getting clobbered.
	level.cfx_center_text[level.cfx_center_text_max-1] clearAllTextAfterHudElem();
	
	for (i=0;i<level.createFx_hudElements;i++)
	{
		// MikeD (8/8/2007): Reduced p<5 to p<2 to save on hudelems.
		for (p=0;p<2;p++)
		{
			level.createFxHudElements[i][p] setText("");
		}
	}
	level.fxHudElements = 0;
}

set_fx_hudElement( text )
{
	// MikeD (8/8/2007): Reduced p<5 to p<2 to save on hudelems.
	if ( level.fxHudElements < level.createfx_hudElements )
	{
		for (p=0;p<2;p++)
		{
			level.createFxHudElements[level.fxHudElements][p] setText( text );
		}
		level.fxHudElements++;
	}
	//assert (level.fxHudElements < level.createFx_hudElements);
}

buttonDown( button, button2 )
{
	return buttonPressed_internal( button ) || buttonPressed_internal( button2 );
}

buttonPressed_internal( button )
{
	if ( !isdefined( button ) )
	{
		return false;
	}
		
	// keyboard buttons can be locked so you can type in the fx info on the keyboard without
	// accidentally activating features
	if ( kb_locked( button ) )
	{
		return false;
	}

	player = get_players()[0];
	return player buttonPressed( button );
}

get_selected_move_vector()
{
	player = get_players()[0];
		
	yaw = player getplayerangles()[1];
	angles = (0, yaw, 0);
	right = anglestoright (angles);
	forward = anglestoforward (angles);
	up = anglestoup (angles);

	const rate = 1;

	if (buttonDown("kp_uparrow", "DPAD_UP"))
	{
		if (level.selectedMove_forward < 0)
		{
			level.selectedMove_forward = 0;
		}
		level.selectedMove_forward = level.selectedMove_forward + rate;
	}
	else if (buttonDown("kp_downarrow", "DPAD_DOWN"))
	{
		if (level.selectedMove_forward > 0)
		{
			level.selectedMove_forward = 0;
		}
		level.selectedMove_forward = level.selectedMove_forward - rate;
	}
	else
	{
		level.selectedMove_forward = 0;
	}

	if (buttonDown("kp_rightarrow", "DPAD_RIGHT"))
	{
		if (level.selectedMove_right < 0)
		{
			level.selectedMove_right = 0;
		}
		level.selectedMove_right = level.selectedMove_right + rate;
	}
	else if (buttonDown("kp_leftarrow", "DPAD_LEFT"))
	{
		if (level.selectedMove_right > 0)
		{
			level.selectedMove_right = 0;
		}
		level.selectedMove_right = level.selectedMove_right - rate;
	}
	else
	{
		level.selectedMove_right = 0;
	}

	if (buttonDown("BUTTON_Y"))
	{
		if (level.selectedMove_up < 0)
		{
			level.selectedMove_up = 0;
		}
		level.selectedMove_up = level.selectedMove_up + rate;
	}
	else if (buttonDown("BUTTON_B"))
	{
		if (level.selectedMove_up > 0)
		{
			level.selectedMove_up = 0;
		}
		level.selectedMove_up = level.selectedMove_up - rate;
	}
	else
	{
		level.selectedMove_up = 0;
	}
	
//	vector = (level.selectedMove_right, level.selectedMove_forward, level.selectedMove_up);
	vector = (0,0,0);
	vector += VectorScale(forward, level.selectedMove_forward);
	vector += VectorScale(right, level.selectedMove_right);
	vector += VectorScale(up, level.selectedMove_up);

	return vector;
}

process_button_held_and_clicked()
{
	add_button("mouse1");
	add_kb_button("shift");
	add_kb_button("ctrl");
	add_button("BUTTON_RSHLDR");
	add_button("BUTTON_LSHLDR");
	add_button("BUTTON_RSTICK");
	add_button("BUTTON_LSTICK");
	add_button("BUTTON_A");
	add_button("BUTTON_B");
	add_button("BUTTON_X");
	add_button("BUTTON_Y");
	add_button("DPAD_UP");
	add_button("DPAD_LEFT");
	add_button("DPAD_RIGHT");
	add_button("DPAD_DOWN");
	add_kb_button("escape");
	add_button("BUTTON_RTRIG");
	add_button("BUTTON_LTRIG");
	
	add_kb_button("a");
	add_button("F1");
	add_button("F5");
	add_button("F2");
	add_kb_button("c");
	add_kb_button("d");
	add_kb_button("f");
	add_kb_button("h");
	add_kb_button("i");
	add_kb_button("j");
	add_kb_button("k");
	add_kb_button("l");
	add_kb_button("m");
	add_kb_button("p");
	add_kb_button("q");
	add_kb_button("r");
	add_kb_button("s");
	add_kb_button("x");
	add_button("del"); // DEL is allowed to be pressed while in select mode
	add_kb_button("end");
	add_kb_button("tab");
	add_kb_button("ins");
	add_kb_button("add");
	add_kb_button("space");
	add_kb_button("enter");
	add_kb_button("leftarrow");
	add_kb_button("rightarrow");
	add_kb_button("v");
	add_kb_button("1");
	add_kb_button("2");
	add_kb_button("3");
	add_kb_button("4");
	add_kb_button("5");
	add_kb_button("6");
	add_kb_button("7");
	add_kb_button("8");
	add_kb_button("9");
	add_kb_button("0");
	add_kb_button("~");
}

locked( name )
{		
	if ( isdefined(level.createfx_lockedList[name]) )
	{
		return false;
	}
		
	return kb_locked( name );
}

kb_locked( name )
{
	return level.createfx_inputlocked && isdefined( level.button_is_kb[ name ] );
}

add_button( name )
{
	player = get_players()[0];
		
	if ( locked( name ) )
	{
		return;
	}

	if (!isdefined(level.buttonIsHeld[name]))
	{
		if (player buttonPressed(name))
		{
			level.buttonIsHeld[ name ] = true;
			level.buttonClick[ name ] = true;
		}
	}
	else
	{
		if (!player buttonPressed(name))
		{
			level.buttonIsHeld[name] = undefined;
		}
	}
}

add_kb_button( name )
{
	level.button_is_kb[ name ] = true;
	add_button( name );
}

set_anglemod_move_vector()
{
	const rate= 1;		// DLM - 12/16/2010 - Changed rotational rate from 2 to 1 for more fine tuned control
	const small_rate = 0.1;

	players = get_players();

	if(level.is_camera_on == true)
	{
		newmovement = players[0] GetNormalizedMovement();
		dolly_movement = players[0] GetNormalizedCameraMovement();
		if(newmovement[1] <= -0.3)
		{
			level.selectedRotate_yaw -= rate;
		}
		else if(newmovement[1] >= 0.3)
		{
			level.selectedRotate_yaw += rate;
		}
		else if (buttonDown("kp_leftarrow", "DPAD_LEFT"))
		{
			if (level.selectedRotate_yaw < 0)
			{
				level.selectedRotate_yaw = 0;
			}
			level.selectedRotate_yaw += small_rate;
		}
		else if (buttonDown("kp_rightarrow", "DPAD_RIGHT"))
		{
			if (level.selectedRotate_yaw > 0)
			{
				level.selectedRotate_yaw = 0;
			}
			level.selectedRotate_yaw -= small_rate;
		}
		else
		{
			level.selectedRotate_yaw = 0;
		}

		if(dolly_movement[0] <= -0.2)
		{

			level.selectedRotate_pitch += rate;
		}
		else if(dolly_movement[0] >= 0.2)
		{
			level.selectedRotate_pitch -= rate;
		}
		else if (buttonDown("kp_uparrow", "DPAD_UP"))
		{
			if (level.selectedRotate_pitch < 0)
			{
				level.selectedRotate_pitch = 0;
			}
			level.selectedRotate_pitch += small_rate;
		}
		else if (buttonDown("kp_downarrow", "DPAD_DOWN"))
		{
			if (level.selectedRotate_pitch > 0)
			{
				level.selectedRotate_pitch = 0;
			}
			level.selectedRotate_pitch -= small_rate;
		}
		else
		{
			level.selectedRotate_pitch = 0;
		}

	

		if (buttonDown("BUTTON_Y"))
		{
			if (level.selectedRotate_roll < 0)
			{
				level.selectedRotate_roll = 0;
			}
			level.selectedRotate_roll += small_rate;
		}
		else if (buttonDown("BUTTON_B"))
		{
			if (level.selectedRotate_roll > 0)
			{
				level.selectedRotate_roll = 0;
			}
			level.selectedRotate_roll -= small_rate;
		}
		else
		{
			level.selectedRotate_roll = 0;
		}

	}
	else
	{

		if (buttonDown("kp_uparrow", "DPAD_UP"))
		{
			if (level.selectedRotate_pitch < 0)
			{
				level.selectedRotate_pitch = 0;
			}
			level.selectedRotate_pitch = level.selectedRotate_pitch + rate;
		}
		else if (buttonDown("kp_downarrow", "DPAD_DOWN"))
		{
			if (level.selectedRotate_pitch > 0)
			{
				level.selectedRotate_pitch = 0;
			}
			level.selectedRotate_pitch = level.selectedRotate_pitch - rate;
		}
		else
		{
			level.selectedRotate_pitch = 0;
		}

		if (buttonDown("kp_leftarrow", "DPAD_LEFT"))
		{
			if (level.selectedRotate_yaw < 0)
			{
				level.selectedRotate_yaw = 0;
			}
			level.selectedRotate_yaw = level.selectedRotate_yaw + rate;
		}
		else if (buttonDown("kp_rightarrow", "DPAD_RIGHT"))
		{
			if (level.selectedRotate_yaw > 0)
			{
				level.selectedRotate_yaw = 0;
			}
			level.selectedRotate_yaw = level.selectedRotate_yaw - rate;
		}
		else
		{
			level.selectedRotate_yaw = 0;
		}

		if (buttonDown("BUTTON_Y"))
		{
			if (level.selectedRotate_roll < 0)
			{
				level.selectedRotate_roll = 0;
			}
			level.selectedRotate_roll = level.selectedRotate_roll + rate;
		}
		else if (buttonDown("BUTTON_B"))
		{
			if (level.selectedRotate_roll > 0)
			{
				level.selectedRotate_roll = 0;
			}
			level.selectedRotate_roll = level.selectedRotate_roll - rate;
		}
		else
		{
			level.selectedRotate_roll = 0;
		}
	}
		
}

cfxprintln(file,string)
{
	// printing to file is optional now
	if(file == -1)
	{
		return;
	}
	fprintln(file,string);
}

generate_client_fx_log()	// DLM - 2/16/2011: Autosave doesn't generate a client script, so removed references to it.
{
/#	
	tab = "     ";
	//filename = "clientcreatefx/"+level.script+"_fx.csc";	// <<------------------------ SP-specific
	filename = level.cfx_client_scriptdata + level.script + "_fx.csc";
	
	file = openfile(filename,"write");

	// ARTIST_MOD: DLM - 02/15/2010 - Keep CreateFX from crashing if file is not writeable.
	if (file == -1)
	{
		level.write_error = filename;
		return 2;
	}
	else
	{
		cfxprintln (file,"//_createfx generated. Do not touch!!");
		cfxprintln (file,"main()");
		cfxprintln (file,"{");
		println (" *** CREATING EFFECT, COPY THESE LINES TO ", level.script, "_fx.csc *** ");
		
		cfxprintln (file, "// CreateFX entities placed: " + (level.createFxEnt.size - level.non_fx_ents) );
		
		breather = 0;

		//level thread update_save_bar(level.createfxent.size);	// This is causing a UI buffer overflow. Also, this doesn't run when saving the GSC.

		for ( i = 0; i < level.createFXent.size; i++ )
		{
			
			
			
			if (file != -1)
			{
				wait .05; //loop protection fails on writing the file
			}
			e = level.createFXent[i];
			assert(isdefined(e.v["type"]), "effect at origin " + e.v["origin"] + " has no type");
			
			//don't post .map effects in the script.
			//if (e.v["worldfx"])
				//continue;
				
			level.current_saving_number = i + 1;
				
			if (isdefined(e.model))
			{
				continue;  // entities with models are from radiant and don't get reported
			}
			
			if (e.v["type"] == "loopfx")
			{
				println ("	ent = " + level.cfx_client_loop + "( \"" + e.v["fxid"] + "\" );");
				cfxprintln (file, tab + "	ent = " + level.cfx_client_loop + "( \"" + e.v["fxid"] + "\" );");
			}
			
			if (e.v["type"] == "oneshotfx")
			{
				println ("	ent = " + level.cfx_client_oneshot + "( \"" + e.v["fxid"] + "\" );");
				cfxprintln (file, tab + "	ent = " + level.cfx_client_oneshot + "( \"" + e.v["fxid"] + "\" );");
			}
			
			if (e.v["type"] == "exploder")	// exploders are staying on the server side....
			{
				println ("	ent = " + level.cfx_client_exploder + "( \"" + e.v["fxid"] + "\" );");
				cfxprintln (file, tab + "	ent = " + level.cfx_client_exploder + "( \"" + e.v["fxid"] + "\" );");
			} 
			
			if ( e.v[ "type" ] == "soundfx" )
			{
				println( "	ent = " + level.cfx_client_loopsound + "();" );
				cfxprintln( file, tab + "	ent = " + level.cfx_client_loopsound + "();" );
			}
			
			// CODER_MOD
			// Make sure that this isn't output on the client for exploders.
			
	//		if(e.v["type"] != "exploder")
	//		{
			println ("	ent.v[ \"origin\" ] = ( " + e.v["origin"][0] + ", " + e.v["origin"][1] + ", " + e.v["origin"][2] + " );");
			cfxprintln (file, tab + "	ent.v[ \"origin\" ] = ( " + e.v["origin"][0] + ", " + e.v["origin"][1] + ", " + e.v["origin"][2] + " );");

			println ("	ent.v[ \"angles\" ] = ( " + e.v["angles"][0] + ", " + e.v["angles"][1] + ", " + e.v["angles"][2] + " );");
			cfxprintln (file, tab + "	ent.v[ \"angles\" ] = ( " + e.v["angles"][0] + ", " + e.v["angles"][1] + ", " + e.v["angles"][2] + " );");
			
			print_fx_options( e, tab , file );
	//		}
			
			println (" ");
			cfxprintln (file," ");
			
			

			breather++;
			if ( breather >= 100 )
			{
				wait(0.05);
				breather = 0;
			}
		}
		if(level.bScriptgened)
		{
			//script_gen_dump_addline("clientscripts\\createfx\\" + level.script + "_fx::main();", level.script + "_fx");  // adds to scriptgendump
			script_gen_dump_addline(level.cfx_client_scriptgendump, level.script + "_fx");
			//maps\_load_common::script_gen_dump();  //dump scriptgen link
			[[level.cfx_func_script_gen_dump]]();
		}
		cfxprintln (file,"}");
		saved = closefile(file);
		assert(saved == 1,"File not saved (see above message?): " + filename);
	
		//flag_clear( "createfx_saving" ); // DLM - 6/16/2010 - No longer necessary since flag checks were moved to createfx_save()
		
		println( "CreateFX entities placed: " + (level.createFxEnt.size - level.non_fx_ents) );
		
		return 0;
	}
	#/
}

update_save_bar( number )
{

	level notify("saving_start");
	level endon("saving_start");
	
	level.current_saving_number = 0;

	while( level.current_saving_number < level.createfxent.size )
	{
		center_text_clear();
		center_text_add( "Saving Createfx to File" );
		center_text_add( "Saving effect " + level.current_saving_number + "/" + level.createfxent.size);
		center_text_add( "Do not reset Xenon until saving is complete." );
		wait(0.05);
		center_text_clear();
	}


	center_text_add( "Saving Complete." );
	center_text_add( level.createfxent.size + " effects saved to files." );


}

generate_fx_log( autosave )
{
	// first lets fix all the really small numbers so they dont cause errors because the game will print out
	// 4.2343-7e or whatever but cant accept it back in from script
	
/#	
	//flag_waitopen( "createfx_saving" ); // DLM - 6/16/2010 - No longer necessary since flag checks were moved to createfx_save()
	//flag_set( "createfx_saving" );
	autosave = isdefined( autosave );
	tab = "     ";
	filename = level.cfx_server_scriptdata + level.script + "_fx.gsc";
	
	if ( autosave )
	{
		filename = level.cfx_server_scriptdata + "backup.gsc";
	}
	
	file = openfile(filename, "write");
	
	// ARTIST_MOD: DLM - 02/15/2010 - Keep CreateFX from crashing if file is not writeable.
	if (file == -1)
	{
		//flag_clear( "createfx_saving" );
		level.write_error = filename;
		return 1;
	}
	else
	{
		cfxprintln (file,"//_createfx generated. Do not touch!!");
		cfxprintln (file,"main()");
		cfxprintln (file,"{");
		
		const limit = 0.1;
		for ( p = 0; p < level.createFXent.size; p++ )
		{
			ent = level.createFXent[p];
			origin = [];
			angles = [];
			
			for (i=0;i<3;i++)
			{
				origin[i] = ent.v["origin"][i];
				angles[i] = ent.v["angles"][i];
				
				if (origin[i] < limit && origin[i] > limit*-1)
				{
					origin[i] = 0;
				}
				if (angles[i] < limit && angles[i] > limit*-1)
				{
					angles[i] = 0;
				}
			}
			
			ent.v["origin"] = (origin[0], origin[1], origin[2]);
			ent.v["angles"] = (angles[0], angles[1], angles[2]);
		}
	
		if ( !autosave )
		{
			println (" *** CREATING EFFECT, COPY THESE LINES TO ", level.script, "_fx.gsc *** ");
		}
		cfxprintln (file, "// CreateFX entities placed: " + (level.createFxEnt.size - level.non_fx_ents) );
		
		breather = 0; // wait every 100 iterations to hopefully keep the game from thinking this is an infinite loop.
		
		for ( i = 0; i < level.createFXent.size; i++ )
		{
			if (file != -1)
			{
				wait(0.05); //loop protection fails on writing the file
			}
			e = level.createFXent[i];
			assert(isdefined(e.v["type"]), "effect at origin " + e.v["origin"] + " has no type");
			
			//don't post .map effects in the script.
			//	if (e.v["worldfx"])
			//		continue;
	
			if (isdefined(e.model))
			{
				continue;  // entities with models are from radiant and don't get reported
			}
			
			if (e.v["type"] == "loopfx")
			{
				if ( !autosave )
				{
					println ("	ent = " + level.cfx_server_loop + "( \"" + e.v["fxid"] + "\" );");
				}
				cfxprintln (file, tab + "	ent = " + level.cfx_server_loop + "( \"" + e.v["fxid"] + "\" );");
			
			}
	
			if (e.v["type"] == "oneshotfx")
			{
				if ( !autosave )
				{
					println ("	ent = " + level.cfx_server_oneshot + "( \"" + e.v["fxid"] + "\" );");
				}
				cfxprintln (file, tab + "	ent = " + level.cfx_server_oneshot + "( \"" + e.v["fxid"] + "\" );");
			}
	
			if (e.v["type"] == "exploder")
			{
				if ( !autosave )
				{
					println ("	ent = " + level.cfx_server_exploder + "( \"" + e.v["fxid"] + "\" );");
				}
				cfxprintln (file, tab + "	ent = " + level.cfx_server_exploder + "( \"" + e.v["fxid"] + "\" );");
			}
	
			if ( e.v[ "type" ] == "soundfx" )
			{
				if ( !autosave )
				{
					println( "	ent = " + level.cfx_server_loopsound + "();" );
				}
				cfxprintln( file, tab + "	ent = " + level.cfx_server_loopsound + "();" );
			}
			
			if ( !autosave )
			{
				println ("	ent.v[ \"origin\" ] = ( " + e.v["origin"][0] + ", " + e.v["origin"][1] + ", " + e.v["origin"][2] + " );");
			}
			cfxprintln (file,tab+ "	ent.v[ \"origin\" ] = ( " + e.v["origin"][0] + ", " + e.v["origin"][1] + ", " + e.v["origin"][2] + " );");
			
			if ( !autosave )
			{
				println ("	ent.v[ \"angles\" ] = ( " + e.v["angles"][0] + ", " + e.v["angles"][1] + ", " + e.v["angles"][2] + " );");
			}
			cfxprintln (file,tab+ "	ent.v[ \"angles\" ] = ( " + e.v["angles"][0] + ", " + e.v["angles"][1] + ", " + e.v["angles"][2] + " );");
			
			print_fx_options( e, tab , file, autosave );
			
			if ( !autosave )
			{
				println (" ");
			}
			cfxprintln (file," ");
			
			breather++;
			if ( breather >= 100 )
			{
				wait(0.05);
				breather = 0;
			}
			if ( autosave )
			{
				wait (0.1);
			}
		}
		if (level.bScriptgened)
		{
			//script_gen_dump_addline("maps\\createfx\\"+level.script+"_fx::main();",level.script+"_fx");  // adds to scriptgendump
			script_gen_dump_addline(level.cfx_server_scriptgendump, level.script + "_fx");
			//maps\_load_common::script_gen_dump();  //dump scriptgen link
			[[level.cfx_func_script_gen_dump]]();	// dump scriptgen link
		}
		cfxprintln (file,"}");
		saved = closefile(file);
		assert(saved == 1,"File not saved (see above message?): " + filename);
		
		// DLM - moved clientscript generation call to createfx_save()
		
		//flag_clear( "createfx_saving" ); // DLM - 6/16/2010 - No longer necessary since flag checks were moved to createfx_save()
		
		println( "CreateFX entities placed: " + (level.createFxEnt.size - level.non_fx_ents) );
		
		return 0;
	}
#/
}

// TODO - DLM: Move this to _createfxMenu.gsc
print_fx_options( ent, tab, file, autosave )
{
	if ( !isdefined(autosave) )
	{
		autosave = false;
	}
	for ( i=0; i<level.createFX_options.size; i++ )
	{
		option = level.createFX_options[i];
		if ( !isdefined(ent.v[option["name"]]) )
		{
			continue;
		}
		if (!mask ( option["mask"], ent.v["type"] ) )
		{
			continue;
		}
		
		if ( option["type"] == "string" )
		{
			if ( !autosave )
			{
				println ("	ent.v[ \"" + option["name"] + "\" ] = \"" + ent.v[ option["name"] ] + "\";");
			}
			cfxprintln (file, tab + "	ent.v[ \"" + option["name"] + "\" ] = \"" + ent.v[ option["name"] ] + "\";");
			continue;
		}

		// int or float
		if ( !autosave )
		{
			println ("	ent.v[ \"" + option["name"] + "\" ] = " + ent.v[ option["name"] ] + ";");
		}
		cfxprintln (file, tab + "	ent.v[ \"" + option["name"] + "\" ] = " + ent.v[ option["name"] ] + ";");
	}	
}

entity_highlight_disable()
{
	self notify ("highlight change");
	self endon ("highlight change");
	
	for (;;)
	{
		self.textalpha = self.textalpha * 0.85;
		self.textalpha = self.textalpha - 0.05;
		if (self.textalpha < 0)
		{
			break;
		}
		wait (0.05);
	}
	
	self.textalpha = 0;
}

entity_highlight_enable()
{
	self notify ("highlight change");
	self endon ("highlight change");

	for (;;)
	{
//		self.textalpha = sin(gettime()) * 0.5 + 0.5;
		self.textalpha = self.textalpha + 0.05;
		self.textalpha = self.textalpha * 1.25;
		if (self.textalpha > 1)
		{
			break;
		}
		wait (0.05);
	}

	self.textalpha = 1;
	
	/*
	for (;;)
	{
		self.textalpha = self.textalpha + 0.05;
		self.textalpha = self.textalpha * 1.25;
		if (self.textalpha > 1)
			break;
		wait (0.05);
	}
	
	*/
}


get_center_of_array( array )
{
	center = (0,0,0);
	for ( i=0; i < array.size; i++)
	{
		center = (center[0] + array[i].v["origin"][0], center[1] + array[i].v["origin"][1], center[2] + array[i].v["origin"][2]);
	}

	return (center[0] / array.size, center[1] / array.size, center[2] / array.size);
}

/* ARTIST_MOD: DLM - 4/22/2010 - Doesn't seem to be used anywhere
ent_draw_axis()
{
	self endon ("death");
	for (;;)
	{
		draw_axis();
		wait (0.05);
	}
}
*/

rotation_is_occuring()
{
	if ( level.selectedRotate_roll != 0 )
	{
		return true;
	}
	if ( level.selectedRotate_pitch != 0 )
	{
		return true;
	}
	return level.selectedRotate_yaw != 0;
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
	
	if ( level.selected_fx_ents.size > 1 )
	{
		center = get_center_of_array(level.selected_fx_ents);
		org = spawn("script_origin", center);
		org.v["angles"] = level.selected_fx_ents[0].v["angles"];
		org.v["origin"] = center;
			
		rotater = [];
		for ( i=0; i < level.selected_fx_ents.size; i++)
		{
			rotater[i] = spawn("script_origin", level.selected_fx_ents[i].v["origin"]);
			rotater[i].angles = level.selected_fx_ents[i].v["angles"];
			rotater[i] linkto (org);
		}
	
	//	println ("pitch " + level.selectedRotate_pitch + " yaw " + level.selectedRotate_yaw);
	
		rotate_over_time(org, rotater);
			
		org delete();
	
		for ( i=0; i < rotater.size; i++)
		{
			rotater[i] delete();
		}
	}
	else if ( level.selected_fx_ents.size == 1 )
	{
		ent = level.selected_fx_ents[ 0 ];
		rotater = spawn( "script_origin", (0,0,0) );
		rotater.angles = ent.v[ "angles" ];
		if (level.selectedRotate_pitch != 0)
		{
			rotater devAddPitch(level.selectedRotate_pitch);
		}
		else if (level.selectedRotate_yaw != 0)
		{
			rotater devAddYaw(level.selectedRotate_yaw);
		}
		else
		{
			rotater devAddRoll(level.selectedRotate_roll);
		}
		ent.v[ "angles" ] = rotater.angles;
		rotater delete();
		wait( 0.05 );
	}
		
	level.fx_rotating = false;
}

rotate_over_time ( org, rotater )
{
	level endon ("new_ent_selection");
	const timer = 0.1;
	for (p=0;p<timer*20;p++)
	{
		if (level.selectedRotate_pitch != 0)
		{
			org devAddPitch(level.selectedRotate_pitch);
		}
		else if (level.selectedRotate_yaw != 0)
		{
			org devAddYaw(level.selectedRotate_yaw);
		}
		else
		{
			org devAddRoll(level.selectedRotate_roll);
		}

		wait (0.05);
		//org draw_axis();

		for ( i=0; i < level.selected_fx_ents.size; i++)
		{
			ent = level.selected_fx_ents[i];
			if (isdefined(ent.model)) // ents with brushmodels are from radiant and don't get moved
			{
				continue;
			}
			
			ent.v["origin"] = rotater[i].origin;
			ent.v["angles"] = rotater[i].angles;
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
	if ( !isdefined( level.selected_fx_option_index ) )
	{
		return;
	}

	name = level.createFX_options[ level.selected_fx_option_index ][ "name" ];
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		ent = level.createFXent[i];
		if ( !ent_is_selected( ent ) )
		{
			continue;
		}

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
		ent = level.createFXent[i];
		if (ent_is_selected(ent))
		{
			if (isdefined(ent.looper))
			{
				ent.looper delete();
			}

			ent notify( "stop_loop" );
		}
		else
		{
			newArray[newArray.size] = ent;
		}
	}
	
	level.createFXent = newArray;
	
	level.selected_fx = [];
	level.selected_fx_ents = [];
	clear_fx_hudElements();
}

move_selection_to_cursor( )
{
	origin = level.createfxCursor["position"];
	if (level.selected_fx_ents.size <= 0)
	{
		return;
	}
		
	center = get_center_of_array(level.selected_fx_ents);
	difference = center - origin;
	for ( i=0; i < level.selected_fx_ents.size; i++ )
	{
		ent = level.selected_fx_ents[i];
		if (isdefined(ent.model)) // ents with brushmodels are from radiant and dont get moved
		{
			continue;
		}

		ent.v["origin"] -= difference;
	}
}

insert_effect()	// TODO: DLM - 4/22/2010 - Shouldn't this be in _createfxMenu?
{
	setMenu("creation");
	level.effect_list_offset = 0;
	clear_fx_hudElements();
	set_fx_hudElement("Pick effect type to create:");
	set_fx_hudElement("1. One Shot fx");
	set_fx_hudElement("2. Looping fx");
	set_fx_hudElement("3. Exploder");
	set_fx_hudElement("4. Looping sound");
	set_fx_hudElement("(c) Cancel");
	set_fx_hudElement("(x) Exit");
	/*
	set_fx_hudElement("Pick an effect:");
	set_fx_hudElement("In the console, type");
	set_fx_hudElement("/fx name");
	set_fx_hudElement("Where name is the name of the sound alias");
	*/
}

show_help()
{
	clear_fx_hudElements();
	set_fx_hudElement("Help:");
	set_fx_hudElement("I                Insert effect");
	set_fx_hudElement("D                Delete selected effects");
	set_fx_hudElement("F + 5            Save");
	set_fx_hudElement("A button         Toggle the selection of the current effect");
	set_fx_hudElement("X button         Toggle effect rotation mode");
	set_fx_hudElement("Y button         Move selected effects up or rotate X axis");
	set_fx_hudElement("B button         Move selected effects down or rotate X axis");
	set_fx_hudElement("D-pad Up/Down    Move selected effects Forward/Backward or rotate Y axis");
	set_fx_hudElement("D-pad Left/Right Move selected effects Left/Right or rotate Z axis");
	set_fx_hudElement("R Shoulder       Move selected effects to the cursor");
	set_fx_hudElement("L Shoulder       Hold to select multiple effects");
	set_fx_hudElement("A                Add option to the selected effects");
	set_fx_hudElement("X                Exit effect options menu");
	set_fx_hudElement("Right Arrow      Next page in options menu");
	// TODO: DLM - 4/22/2010 - Figure out why help menu in MP stops drawing here.  Fewer HUD elements?
	set_fx_hudElement("L                Drop selected effects to the ground");
	set_fx_hudElement("R                Reset the rotation of the selected effects");
	set_fx_hudElement("L Stick          Copy effects");
	set_fx_hudElement("R Stick          Paste effects");
	set_fx_hudElement("V                Copy the angles from the most recently selected fx onto all selected fx.");
	set_fx_hudElement("F + 2            Toggle CreateFX dot and menu drawing");
	set_fx_hudElement("U                UFO");
	set_fx_hudElement("N                Noclip");
	set_fx_hudElement("R Trig + L Trig  Jump forward 8000 units");
	set_fx_hudElement("T                Toggle Timescale FAST");
	set_fx_hudElement("Y                Toggle Timescale SLOW");
	set_fx_hudElement("H                Toggle FX Visibility");
	set_fx_hudElement("W                Toggle effect wireframe");
	set_fx_hudElement("P                Toggle FX Profile");
	// This is as many hud elements as can be used without crashing. Below are hotkeys that don't fit.
	//set_fx_hudElement("ESCAPE           Cancel out of option-modify-mode, must have console open");
}

// DLM - 6/16/2010
// Initializes large, centered screen text for notifications, errors, etc.
// TODO: DLM - Figure out what is overwriting this text with entity info on cursor-over.
center_text_init()
{
	level.cfx_center_text = [];
	level.cfx_center_text_index = 0;
	level.cfx_center_text_max = 3;
	new_array = [];
	
	for (p=0; p < level.cfx_center_text_max; p++)
	{
		center_hud = newDebugHudElem();
		center_hud SetText(" ");
		center_hud.horzAlign = "center";
		center_hud.vertAlign = "middle";
		center_hud.alignX = "center";
		center_hud.alignY = "middle";
		center_hud.foreground = 1;
		center_hud.fontScale = 1.1;
		center_hud.sort = 21;
		center_hud.alpha = 1;
		center_hud.color = (1,0,0);
		center_hud.y = p * 25;
		new_array[p] = center_hud;
	}
	level.cfx_center_text = new_array;
}

// Adds a line of center text.  There's a max of 3 lines, so new requests will write over the last line.
// TODO: Make this scroll the text up to the next lowest index if all indices are full.
center_text_add( text )
{
	if ( isDefined(text) && isDefined(level.cfx_center_text) )
	{
		println("^3Adding to center text hud element: " + text);
		level.cfx_center_text[level.cfx_center_text_index] setText(text);
		level.cfx_center_text_index++;
		
		if ( level.cfx_center_text_index >= level.cfx_center_text_max )
		{
			level.cfx_center_text_index = level.cfx_center_text_max - 1;
		}
	}
}

// Clears out the text of the center_text
center_text_clear()
{
	for (p=0; p < level.cfx_center_text_max; p++)
	{
		level.cfx_center_text[p] setText(" ");
	}
	level.cfx_center_text_index = 0;
}

// Clears the screen for a message that doesn't go away until the user presses the A button.  Should be threaded.
write_error_msg(filename)
{
	level notify("write_error");
	level endon("write_error");
	
	if ( isDefined( filename ) )
	{
		center_text_clear();
		center_text_add( "File " + filename + " is not writeable." );
		center_text_add( "If it's checked out, restart your computer!" );
		center_text_add( "Press the A Button to dismiss." );
		
		for (;;)
		{
			player = get_players()[0];
			if ( player buttonPressed("BUTTON_A") )
			{
				center_text_clear();
				level.write_error = "";
				break;
			}
			//println("write_error_msg thread still open.");
			wait(0.1);
		}
	}
}

select_last_entity()
{
	select_entity(level.createFXent.size-1, level.createFXent[level.createFXent.size-1]);
}

copy_ents()
{
	if (level.selected_fx_ents.size <= 0)
	{
		return;
	}
	
	array = [];
	for ( i=0; i < level.selected_fx_ents.size; i++)
	{
		ent = level.selected_fx_ents[i];
		newent = spawnstruct();
		
		newent.v = ent.v;
		newent post_entity_creation_function();
		array[array.size] = newent;
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
	if (!isdefined(level.stored_ents))
	{
		return;
	}
	
	clear_entity_selection();
	
	for (i=0;i<level.stored_ents.size;i++)
	{
		add_and_select_entity(level.stored_ents[i]);
	}
	
	move_selection_to_cursor( );
	update_selected_entities();
	level.stored_ents = [];
	copy_ents(); // roundabout way to put new entities in the copy queue
}

add_and_select_entity( ent )
{
	level.createFXent[level.createFXent.size] = ent;
	select_last_entity();
}

stop_fx_looper()
{
	if (isdefined(self.looper))
	{
		self.looper delete();
	}
	//self maps\_fx::stop_loopsound();	// <<------------------------ SP-specific
	self [[level.cfx_func_stop_loopsound]]();
}

restart_fx_looper()
{
	stop_fx_looper();

	// MikeD (8/8/2007): Delay actually updating the entities until the ent has "sat" in it's orientation/position for 1 second.
	// MikeD (12/14/2007): Do we still need this? Removed until we need it back.
	//self notify( "stop_updating_looper" );
	//self endon( "stop_updating_looper" );
	//wait( 1 );
		
	self set_forward_and_up_vectors();
	
	if (self.v["type"] == "loopfx")
	{
		// new entities from copy/paste wont have a looper
		//self maps\_fx::create_looper();	// <<------------------------ SP-specific
		self [[level.cfx_func_create_looper]]();
	}

	if (self.v["type"] == "oneshotfx")
	{
		// new entities from copy/paste wont have a looper
		//self maps\_fx::create_triggerfx();	// <<------------------------ SP-specific
		self [[level.cfx_func_create_triggerfx]]();
	}

	if (self.v["type"] == "soundfx")
	{
		// new entities from copy/paste wont have a looper
		//self maps\_fx::create_loopsound();	// <<------------------------ SP-specific
		self [[level.cfx_func_create_loopsound]]();
	}
}

update_selected_entities()
{
	for ( i=0; i < level.selected_fx_ents.size; i++)
	{
		ent = level.selected_fx_ents[i];
		ent restart_fx_looper();
	}
}

copy_angles_of_selected_ents()
{
	// so it stops rotating them over time
	level notify( "new_ent_selection" );
	
	for ( i=0; i < level.selected_fx_ents.size; i++ )
	{
		ent = level.selected_fx_ents[ i ];
		ent.v[ "angles" ] = level.selected_fx_ents[ level.selected_fx_ents.size - 1 ].v[ "angles" ];
		ent set_forward_and_up_vectors();
	}
	
	update_selected_entities();
}

reset_axis_of_selected_ents()
{
	// so it stops rotating them over time
	level notify ("new_ent_selection");
	
	for ( i=0; i < level.selected_fx_ents.size; i++)
	{
		ent = level.selected_fx_ents[i];
		ent.v["angles"] = (0,0,0);
		ent set_forward_and_up_vectors();
	}
	
	update_selected_entities();
}

last_selected_entity_has_changed( lastSelectEntity )
{
	if ( isdefined( lastSelectEntity ) )
	{
		if ( !entities_are_selected() )
		{
			return true;
		}
	}
	else
	{
		return entities_are_selected();
	}
	
	return ( lastSelectEntity != level.selected_fx_ents[level.selected_fx_ents.size-1]);
}

// DLM - 4/20/2010 - I don't think this is being used...
createfx_showOrigin (id, org, delay, org2, type, exploder, id2, fireFx, fireFxDelay, fireFxSound, fxSound, fxQuake, fxDamage, soundalias, repeat, delay_min, delay_max, damage_radius, fireFxTimeout)
{
}

drop_selection_to_ground()
{
	for ( i=0; i < level.selected_fx_ents.size; i++)
	{
		ent = level.selected_fx_ents[i];
		trace = bullettrace(ent.v["origin"], ent.v["origin"] + (0,0,-2048), false, undefined);
		ent.v["origin"] = trace["position"];
	}
}

set_off_exploders()
{
	level notify ("createfx_exploder_reset");
	exploders = [];
	for ( i=0; i < level.selected_fx_ents.size; i++)
	{
		ent = level.selected_fx_ents[i];
		if ( isdefined( ent.v["exploder"] ))
		{
			exploders[ ent.v["exploder"] ] = true;
		}
	}
	
	keys = getarraykeys( exploders );
	for ( i=0; i<keys.size; i++ )
	{
		exploder( keys[i] );
	}
}

turn_off_exploders()
{
	level notify ("createfx_exploder_reset");
	exploders = [];
	for ( i=0; i < level.selected_fx_ents.size; i++)
	{
		ent = level.selected_fx_ents[i];
		if ( isdefined( ent.v["exploder"] ))
		{
			exploders[ ent.v["exploder"] ] = true;
		}
	}
	
	keys = getarraykeys( exploders );
	for ( i=0; i<keys.size; i++ )
	{
		stop_exploder( keys[i] );
	}
}

draw_distance()
{
	count = 0;
	last_pos = (0,0,0);
	if ( GetDvarint( "createfx_drawdist" ) == 0 )
	{
		SetDvar( "createfx_drawdist", "1500" );
	}
	player = get_players()[0];
	
	for (;;)
	{
		maxDist = GetDvarint( "createfx_drawdist" );
		maxDistSqr = maxDist * maxDist;
		
		for ( i = 0; i < level.createFXent.size; i++ )
		{
			ent = level.createFXent[ i ];
			ent.drawn = DistanceSquared( player.origin, ent.v["origin"] ) <= maxDistSqr ;
			
			count++;
			if ( count > 100 )
			{
				count = 0;
				wait (0.05);
			}
		}
			wait (0.1);
		
		// ARTIST_MOD - DLM: Added wait so the entity draw state changes only after player moves 50 units.
		while ( distance(player.origin, last_pos) < 50 )
		{
			wait (0.1);
		}
		last_pos = player.origin;
	}
}

// ARTIST_MOD: DLM - 9/29/2009
// Does a few things before and after generating a log file
createfx_save(autosave)
{
	// These flags are necessary to keep CreateFX from trying to write to more than one file at a time.
	flag_waitopen( "createfx_saving" );
	flag_set( "createfx_saving" );
	
	resettimeout();	// This is supposed to prevent an incorrect infinite loop error.
	
	if ( isdefined( autosave ) )
	{
		savemode = "AUTOSAVE";
	} else
	{
		savemode = "USER SAVE";
		//player.myProgressBar = player createPrimaryProgressBar();	// TODO: Set up this progress bar.
	}
	old_time = GetTime();
	println( "\n^3#### CREATEFX " + savemode + " BEGIN ####" );
	file_error = generate_fx_log(autosave);
	
	if ( file_error )	// Try for a backup
	{
		//IPrintLn(level.script + " is not writeable! Aborting save.");
		println( "^3#### CREATEFX " + savemode + " CANCELLED ####" );
		thread createfx_emergency_backup();	// "createfx_saving" flag is cleared in this function.
	} else
	{
		if (level.clientscripts && !isdefined( autosave )) // MikeD (6/20/2008): Let's not autosave the clientside scripting, takes too much time.
		{
			file_error = generate_client_fx_log();
			
			if ( file_error )
			{
				IPrintLn("CreateFX clientscript file is not writeable! Aborting save.");
				println( "^3#### CREATEFX " + savemode + " CANCELLED ####" );
				return;
			}
		}
		println( "^3#### CREATEFX " + savemode + " END (Time: " + ( GetTime() - old_time ) * 0.001 + " seconds)####" );
		flag_clear( "createfx_saving" );
	}
}

createfx_autosave()
{
	for ( ;; )
	{
		//flag_waitopen( "createfx_saving" ); // This is now in createfx_save()

		wait_time = GetDvarint( "createfx_autosave_time" );

		if( wait_time < 120 || IsString( wait_time ) )
		{
			wait_time = 120;
		}
		wait( wait_time );

		// If user save is not in progress, then autosave.  Otherwise, wait another wait_time seconds.
		if( !flag( "createfx_saving" ) )
		{
			createfx_save(true);
		}
	}
}

createfx_emergency_backup()
{
	// "createfx_saving" flag should already be set
	println( "^5#### CREATEFX EMERGENCY BACKUP BEGIN ####" );
	file_error = generate_fx_log(true);
	
	if ( file_error )
	{
		IPrintLn("Error saving to backup.gsc.  All is lost!");
	} else
	{
		println( "^5#### CREATEFX EMERGENCY BACKUP END ####" );
	}
	flag_clear( "createfx_saving" );
}

// Moves player around the map on press of triggers
move_player_around_map_fast()
{	
	player = get_players()[0];
		
	// Trace to where the player is looking
	direction = player getPlayerAngles();
	direction_vec = anglesToForward( direction );
	eye = player getEye();
			
	// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
	trace = bullettrace( eye, eye + VectorScale( direction_vec , 8000 ), 0, undefined );
	//trace2 = bullettrace(  trace["position"]+(0,0,2),  trace["position"] - (0,0,100000), 0, undefined );
	
	dist = distance (eye, trace["position"]);		
	position = eye + VectorScale( direction_vec , (dist - 64) );
	// debug		
	//thread draw_line_for_time( eye, trace["position"], 1, 0, 0, 0.05 );
		
	player setorigin(position);
		
}

// TODO: Does this work in MP?

// Selects the next effect with the same fxid as the currently selected one in level.createFXent[]
// and moves player there.  If multiple effects are selected, it will move the player to the next 
// selected effect without changing selection.
move_player_to_next_same_effect( lastSelectEntity )
{
	player = get_players()[0];
	direction = player getPlayerAngles();
	direction_vec = anglesToForward( direction );
	
	ent = level.selected_fx_ents[level.selected_fx_ents.size - 1];
	start_index = 0;
	
	// Check how many ents are selected
	if ( level.selected_fx_ents.size <= 0 )
	{
		if ( isdefined( level.cfx_next_ent ) )	// select and move to prefetched effect
		{
			ent = level.cfx_next_ent;
			index = get_ent_index( ent );
			if ( index >= 0 )	// prefetched effect exists
			{
				select_entity( index, ent );
				
				position = ent.v["origin"] - VectorScale( direction_vec, 175 );
				player setorigin(position);
				
				level.cfx_next_ent = get_next_ent_with_same_id( index, ent.v["fxid"] );
			} else	// prefetched effect changed or was deleted
			{
				level.cfx_next_ent = undefined;
			}
		}
		return;
	}
	
	if ( level.selected_fx_ents.size == 1 )	// select next effect with the same fxid and move player there.
	{
		
		
		// find selected effect in main effect array
		for (i=0; i < level.createFXent.size; i++)
		{
			if ( isdefined( level.selected_fx[i] ) )
			{
				start_index = i + 1;
				deselect_entity( i, ent );
				//println("move_player_to_next_same_effect: Selected ent found.");
				break;
			}
		}
		// begin searching for next same ent until end of array
		for (i = start_index; i < level.createFXent.size; i++)
		{
			if ( ent.v["fxid"] == level.createFXent[i].v["fxid"] )
			{
				ent = level.createFXent[i];
				select_entity( i, ent );
				
				position = ent.v["origin"] - VectorScale( direction_vec, 175 );
				player setorigin(position);
				
				level.cfx_next_ent = get_next_ent_with_same_id( i, ent.v["fxid"] );
				return;
			}
		}
		// finish looping through array from beginning
		for (i = 0; i < start_index; i++)
		{
			if ( ent.v["fxid"] == level.createFXent[i].v["fxid"] )
			{
				ent = level.createFXent[i];
				select_entity( i, ent );
				
				position = ent.v["origin"] - VectorScale( direction_vec, 175 );
				player setorigin(position);
				
				level.cfx_next_ent = get_next_ent_with_same_id( i, ent.v["fxid"] );
				return;
			}
		}
	}
	else	// go to next selected effect
	{
		if ( isdefined(level.last_ent_moved_to) && !last_selected_entity_has_changed( lastSelectEntity ) )
		{
			ent = level.last_ent_moved_to;
		}
		
		for (i=0; i < level.selected_fx_ents.size; i++)
		{
			if ( ent == level.selected_fx_ents[i] )
			{
				break;
			}
		}
		if ( i < level.selected_fx_ents.size - 1 )
		{
			i++;
			ent = level.selected_fx_ents[i];
		}
		else
		{
			ent = level.selected_fx_ents[0];
		}
		
		level.last_ent_moved_to = ent;
		
		position = ent.v["origin"] - VectorScale( direction_vec, 175 );
		player setorigin(position);
	}
}

// Get ent info of next effect with the same name.
// index is the effect index in level.createFXent to match. ent_id is its fxid.
// Returns the ent if it finds a matching id.  Returns undefined if there are no other matches.
get_next_ent_with_same_id( index, ent_id )
{
	// begin searching for next same ent until end of array
	for (i = index + 1; i < level.createFXent.size; i++)
	{
		if ( ent_id == level.createFXent[i].v["fxid"] )
		{
			return level.createFXent[i];
		}
	}
	// finish looping through array from beginning
	for (i = 0; i < index; i++)
	{
		if ( ent_id == level.createFXent[i].v["fxid"] )
		{
			return level.createFXent[i];
		}
	}
	return undefined;
}

// Returns the index of entity ent in level.createFXent[].  If it can't be found, it returns -1;
get_ent_index( ent )
{
	for ( i=0; i < level.createFXent.size; i++ )
	{
		if ( ent == level.createFXent[i] )
		{
			return i;
		}
	}
	return -1;
}

// DLM - 8/15/2010 - Selects all ents with the same specified property as the currently selected entity.
// "property" is the string for the option name of the entity.
// If add_to_selection is defined, the selection made will be added to the existing selection.
select_ents_by_property( property, add_to_selection )
{
	/* List of ent properties supported by this function
	addOption("string",	"type",					"Type", "oneshotfx", "fx");
	addOption("string",	"fxid",					"Name", "nil", "fx");
	addOption("float",	"delay",				"Repeat rate/start delay", 0.5, "fx");
	addOption("int",		"repeat",				"Number of times to repeat", 5, "exploder");
	addOption("float",	"delay_min",		"Minimum time between repeats", 1, "exploder");
	addOption("float",	"delay_max",		"Maximum time between repeats", 2, "exploder");
	addOption("int",		"exploder",			"Exploder", 1, "exploder");
	*/
	
	ent = level.selected_fx_ents[level.selected_fx_ents.size - 1];
	prop_to_match = ent.v[property];
	
	if ( !isdefined(add_to_selection) )
	{
		clear_entity_selection();
	}
	
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		if ( isdefined( level.createFXent[i].v[property] ) )
		{
			if ( level.createFXent[i].v[property] == prop_to_match )
			{
				select_entity( i, level.createFXent[i] );
			}
		}
	}
}

// Prints a list of how often each effect is placed via CreateFX
// TODO: Also print out relative effect file path.
print_ambient_fx_inventory()
{
	fx_list = get_level_ambient_fx();	// function is in _createfxMenu.gsc
	ent_list = [];
	fx_list_count = [];
	
	println("\n\n^2INVENTORY OF AMBIENT EFFECTS: ");
	
	for (i=0; i < level.createFXent.size; i++)
	{
		ent_list[i] = level.createFXent[i].v["fxid"];
		//println("" + ent_list[i]);
	}
	
	for (i=0; i < fx_list.size; i++)
	{
		count = 0;
		for (j=0; j < ent_list.size; j++)
		{
			if ( fx_list[i] == ent_list[j] )
			{
				count++;
				ent_list[j] = "";
			}
		}
		fx_list_count[i] = count;
	}
	// sort lists by number of ents placed
	for ( i = 0; i < fx_list_count.size-1; i++ )
	{
		for ( j = i+1; j < fx_list_count.size; j++ )
		{
			if ( fx_list_count[j] < fx_list_count[i] )
			{
				temp_count = fx_list_count[i];
				temp_id = fx_list[i];
				fx_list_count[i] = fx_list_count[j];
				fx_list[i] = fx_list[j];
				fx_list_count[j] = temp_count;
				fx_list[j] = temp_id;
			}
		}
	}
	for ( i = 0; i < fx_list_count.size; i++ )
	{
		switch (fx_list_count[i])
		{
			case 0:	print("^1"); break;
			case 1:	print("^3"); break;
			default: break;
		}
		print(fx_list_count[i] + "\t" + fx_list[i] + "\n");
	}
	print("\n");
}

vector_changed( old, new )
{
	if ( DistanceSquared( old, new ) >= 1 )
		return true;
		
	return false;
}

dot_changed( old, new )
{
	dot = vectordot( old, new );
	if ( dot < 1 )
		return true;

	return false;
}

void()
{
}


// *****************************SP ONLY SECTION**********************************
// SP-specific functions - comment out only the interiors for MP CreateFX
init_sp_paths()
{
	level.cfx_server_scriptdata = "createfx/";
	level.cfx_client_scriptdata = "clientcreatefx/";
	
	level.cfx_server_loop = 					"maps\\_utility::createLoopEffect";
	level.cfx_server_oneshot = 				"maps\\_utility::createOneshotEffect";
	level.cfx_server_exploder = 			"maps\\_utility::createExploder";
	level.cfx_server_loopsound = 			"maps\\_createfx::createLoopSound";
	level.cfx_server_scriptgendump = 	"maps\\createfx\\" + level.script + "_fx::main();";
	
	level.cfx_client_loop = 					"clientscripts\\_fx::createLoopEffect";
	level.cfx_client_oneshot = 				"clientscripts\\_fx::createOneshotEffect";
	level.cfx_client_exploder = 			"clientscripts\\_fx::createExploder";
	level.cfx_client_loopsound = 			"clientscripts\\_fx::createLoopSound";
	level.cfx_client_scriptgendump = 	"clientscripts\\_createfx\\" + level.script + "_fx::main();";
	
	// Function pointers (in the order they appear in the script)
	// Only function pointers that run in CreateFX mode should be placed here.
	level.cfx_func_loopfx = maps\_fx::loopfxthread;
	level.cfx_func_oneshotfx = maps\_fx::oneshotfxthread;
	level.cfx_func_soundfx = maps\_fx::create_loopsound;
	
	level.cfx_func_script_gen_dump = maps\_load_common::script_gen_dump;
	level.cfx_func_stop_loopsound = maps\_fx::stop_loopsound;
	
	level.cfx_func_create_looper = maps\_fx::create_looper;
	level.cfx_func_create_triggerfx = maps\_fx::create_triggerfx;
	level.cfx_func_create_loopsound = maps\_fx::create_loopsound;
}

init_client_sp_variables()
{
	level.cfx_exploder_before = maps\_utility::exploder_before_load;
	level.cfx_exploder_after = maps\_utility::exploder_after_load;
}

make_sp_player_invulnerable(player)
{
	player thread magic_bullet_shield();
}

delete_arrays_in_sp()
{
	ai = getaiarray();
	
	for (i=0;i<ai.size;i++)
	{
		ai[i] delete();
	}
	spawners = GetSpawnerArray();
	
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[i] Delete();
	}
	orgs = GetEntArray("script_origin", "classname");
	
	for(i = 0; i < orgs.size; i ++)
	{
		orgs[i] Delete();
	}
}

// *****************************MP ONLY SECTION**********************************
// MP-specific functions - comment out only the interiors for SP CreateFX
init_mp_paths()
{
//	level.cfx_server_scriptdata = "mpcreatefx/";
//	level.cfx_client_scriptdata = "mpclientcreatefx/";
//	
//	level.cfx_server_loop = 					"maps\\mp\\_utility::createLoopEffect";
//	level.cfx_server_oneshot = 				"maps\\mp\\_utility::createOneshotEffect";
//	level.cfx_server_exploder = 			"maps\\mp\\_utility::createExploder";
//	level.cfx_server_loopsound = 			"maps\\mp\\_createfx::createLoopSound";
//	level.cfx_server_scriptgendump = 	"maps\\mp\\createfx\\" + level.script + "_fx::main();";
//	
//	level.cfx_client_loop = 					"clientscripts\\mp\\_fx::createLoopEffect";
//	level.cfx_client_oneshot = 				"clientscripts\\mp\\_fx::createOneshotEffect";
//	level.cfx_client_exploder = 			"clientscripts\\mp\\_fx::createExploder";
//	level.cfx_client_loopsound = 			"clientscripts\\mp\\_fx::createLoopSound";
//	level.cfx_client_scriptgendump = 	"clientscripts\\mp\\_createfx\\" + level.script + "_fx::main();";
//	
//	// Function pointers (in the order they appear in the script)
//	// Only function pointers that run in CreateFX mode should be placed here.
//	level.cfx_func_loopfx = maps\mp\_fx::loopfxthread;
//	level.cfx_func_oneshotfx = maps\mp\_fx::oneshotfxthread;
//	level.cfx_func_soundfx = maps\mp\_fx::create_loopsound;
//	
//	level.cfx_func_script_gen_dump = maps\mp\_load::script_gen_dump;
//	level.cfx_func_stop_loopsound = maps\mp\_fx::stop_loopsound;
//	
//	level.cfx_func_create_looper = maps\mp\_fx::create_looper;
//	level.cfx_func_create_triggerfx = maps\mp\_fx::create_triggerfx;
//	level.cfx_func_create_loopsound = maps\mp\_fx::create_loopsound;
}

init_client_mp_variables()
{
//	level.cfx_exploder_before = maps\mp\_utility::exploder_before_load;
//	level.cfx_exploder_after = maps\mp\_utility::exploder_after_load;
}

#using_animtree ( "fxanim_props" );
fxanim_init()
{
//	level.fxanims = [];
//	level.fxanims["fxanim_gp_windsock_anim"]		= %fxanim_gp_windsock_anim;
//	level.fxanims["fxanim_gp_tarp1_anim"]			= %fxanim_gp_tarp1_anim;
//	level.fxanims["fxanim_gp_tarp2_anim"]			= %fxanim_gp_tarp2_anim;
//	level.fxanims["fxanim_gp_cloth01_anim"]			= %fxanim_gp_cloth01_anim;
//	level.fxanims["fxanim_gp_streamer01_anim"]		= %fxanim_gp_streamer01_anim;
//	level.fxanims["fxanim_gp_streamer02_anim"]		= %fxanim_gp_streamer02_anim;
//	level.fxanims["fxanim_gp_fence_tarp_01_anim"]	= %fxanim_gp_fence_tarp_01_anim;
//
//	level.fxanims["fxanim_gp_ceiling_fan_old_slow_anim"]	= %fxanim_gp_ceiling_fan_old_slow_anim;
//	level.fxanims["fxanim_gp_ceiling_fan_old_dest_anim"]	= %fxanim_gp_ceiling_fan_old_dest_anim;
}

Callback_PlayerConnect()
{
//	self waittill( "begin" );
//
//	if( !isdefined( level.hasSpawned ) )
//	{
//		//spawnpoints = getentarray("info_player_start", "classname");
//		spawnpoints = getentarray("mp_global_intermission", "classname");
//		assert( spawnpoints.size );
//		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
//
//		self.sessionteam = "none";
//		self.sessionstate = "playing"; 
//		if ( !level.teamBased ) 
//			self.ffateam = "none";
//
//		self spawn(spawnpoint.origin, spawnpoint.angles);
//
//		//player = get_players()[0];
//		
//		//player = self;
//		level.player = self;
//		level.hasSpawned = true;
//	}
//	else
//	{
//		kick(self.name);
//	}
}


handle_camera()
{

	level notify("new_camera");
	level endon("new_camera");
	
	movement = (0,0,0);	// recording the previous movement of the joystick, used for blending later
	const factor = 0.8;	

	if( !isdefined( level.camera ))
	{
		level.camera = Spawn( "script_origin", (0, 0, 0) );
		level.camera setmodel("tag_origin");
	}
	//level.camera = getent( "snapcamera", "targetname" );

	players = get_players();		
	players[0] PlayerLinkToDelta(level.camera, "tag_origin", 1, 0,0,0,0,true);
	players[0] DisableWeapons();	

	level.camera_snapTo = 1;
	level.stick_camera = 1;
	level.camera_prev_snapTo = 0;

	level.cameraVec = ( 90, 150, 20 );


	model = undefined;

	n_y_vector = 0;
	n_x_vector = 0;
	zoom_level = 300;

	b_changes_x = false;
	b_changes_z = false;
	b_changes_y = false;

	test_string = "";
	
	while( 1 )
	{		
		if( level.camera_snapTo > 0 )
		{	
	
			if( level.stick_camera )
			{
				
			originOffset =  VectorScale(level.cameraVec, -1);
			temp_offset = originoffset + (0, 0, -60);
			anglesOffset = VectorToAngles( temp_offset ); 


				if( level.camera_prev_snapTo == level.camera_snapTo )
				{	
					// right joystick movement
					players = get_players();	

					//capturing player inputing
					newmovement = players[0] GetNormalizedMovement();
					dolly_movement = players[0] GetNormalizedCameraMovement();

					if(button_is_held("BUTTON_LTRIG") || button_is_held("BUTTON_RTRIG") )
					{
						//do nothing here for now.
					}
					else
					{

						// updating camera angle base on player control
						if(newmovement[1] <= -0.4)
						{
							n_y_vector += -0.2;
							b_changes_y = true;
						}
						else if(newmovement[1] >= 0.4)
						{
							n_y_vector += 0.2;
							b_changes_y = true;
						}
						else
						{
							b_changes_y = false;
						}
						
						if(newmovement[0] <= -0.4)
						{
							n_x_vector += -0.4;
							b_changes_x = true;
						}
						else if(newmovement[0] >= 0.4)
						{
							n_x_vector += 0.4;
							b_changes_x = true;
						}
						else
						{
							b_changes_x = false;
						}
		
						if(dolly_movement[0] <= -0.4)
						{

							zoom_level += 30;
							b_changes_z = true;
						}
						else if(dolly_movement[0] >= 0.4)
						{
							zoom_level += -30;
							b_changes_z = true;
						}
						else
						{
							b_changes_z = false;
						}

						if( b_changes_z || b_changes_x || b_changes_y)
						{
							newmovement = ( n_x_vector, n_y_vector, newmovement[2]);
							movement = (0,0,0);	
							movement = VectorScale( movement, factor ) + VectorScale( newmovement, (1-factor) );
							tilt = max( 0, 10 + movement[0] * 160 );	
							level.cameraVec = ( cos(movement[1]*180)*zoom_level, sin(movement[1]*180)*zoom_level, tilt );
							iprintln(level.cameraVec[0] + " " + level.cameraVec[1] + " " + level.cameraVec[2]);
							
						}
					}
				}
				else
				{
				
					level.camera_prev_snapTo = level.camera_snapTo;
				}

				if( isdefined( level.current_select_ent ) )
				{
					
					originOffset =  VectorScale(level.cameraVec, -1);
					temp_offset = originoffset + (0, 0, -60);
					anglesOffset = VectorToAngles( temp_offset ); 

					
					if(!isdefined( model ) )
					{
						model = Spawn( "script_origin", level.current_select_ent.v["origin"] );
						model setmodel("tag_origin");

					}

					if( model.origin != level.current_select_ent.v["origin"] )
					{
						model.origin = level.current_select_ent.v["origin"];
					}
					
					level.camera linkTo( model, "tag_origin", level.cameraVec, anglesOffset );
				}
				else
				{
					wait(0.05);
					continue;
						
				}
			
				
			}
			else
			{
				level.camera Unlink();
			}
		}

		wait( 0.05 );
	}
}

camera_hud_toggle( text )
{
	if( isdefined( level.camera_hud ) ) 
	{
		level.camera_hud destroy();
	}

	level.camera_hud = newDebugHudElem();
	level.camera_hud SetText( text );
	level.camera_hud.horzAlign = "left";
	level.camera_hud.vertAlign = "bottom";
	level.camera_hud.alignX = "left";
	level.camera_hud.alignY = "bottom";
	level.camera_hud.foreground = 1;
	level.camera_hud.fontScale = 1.1;
	level.camera_hud.sort = 21;
	level.camera_hud.alpha = 1;
	level.camera_hud.color = (1,1,1);

}