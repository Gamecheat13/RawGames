
//
// Event 5
//
// cp_prologue_security_camera.gsc
//

#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\doors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\array_shared;

#using scripts\cp\cp_mi_eth_prologue;
#using scripts\cp\cp_mi_eth_prologue_fx;
#using scripts\cp\cp_mi_eth_prologue_sound;
#using scripts\cp\cp_prologue_apc;
#using scripts\cp\cp_prologue_util;
#using scripts\cp\cp_prologue_hostage_rescue;
#using scripts\cp\cp_prologue_hangars;


#precache( "lui_menu", "SecurityCamera" );
#precache( "lui_menu_data", "scanStart1" );
#precache( "lui_menu_data", "scanStart2" );
#precache( "lui_menu_data", "scanStart3" );
#precache( "lui_menu_data", "scanStart4" );

#precache( "objective", "cp_level_prologue_security_door" );
#precache( "objective", "cp_level_prologue_security_camera" );



//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// EVENT 5: Security Camera
//
// TODO
// - Kill the two guards
// - Interact with the keyboard to get the Ministers location
// - PLAYER AI PLACEMENTS
//
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

#namespace security_camera;




//*****************************************************************************
// Setup the security camera event
//*****************************************************************************

function security_camera_start( str_objective )
{
	security_camera_precache();

	if( !IsDefined(level.ai_hendricks) )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		cp_mi_eth_prologue::init_hendricks();
		skipto::teleport_ai( str_objective );
	}
	
	level flag::wait_till( "all_players_spawned" );
	array::run_all(level.players, &SetLowReady, true);
	
	level thread security_camera_main();
}


//*****************************************************************************
// DO ALL PRECACHING HERE
//*****************************************************************************

function security_camera_precache()
{
	level flag::init( "everyone_in_camera_room" );
	level flag::init( "camera_objective_marker" );
}


//*****************************************************************************
// Event Main Function
//*****************************************************************************

function security_camera_main()
{
	// Security room player clip
	level.security_control_room_blocker = GetEnt( "security_control_room_blocker", "targetname" );
	level.security_control_room_blocker NotSolid();
	
	// Hendricks path through the event
	level.ai_hendricks thread hendricks_security_camera();

	// Using the video screen console
	level thread setup_security_cameras();
	
	// Checking if all players are inside the security room
	level thread trig_security_door_check();

	// Cleanup
	level thread cleanup_thread();

	// End Event
	level waittill( "hendricks_opens_door" );
	skipto::objective_completed( "skipto_security_camera" );
}


//*****************************************************************************
// Cleanup
//*****************************************************************************

function cleanup_thread()
{
	level waittill( "hendricks_opens_door" );

	level thread scene::stop( "injured_carried1", "targetname" );
	level thread scene::stop( "injured_carried2", "targetname" );	
}


//*****************************************************************************
// Waits for players to approach the seciurity camera room door
// - Then plays the open door scene
//*****************************************************************************

function trig_security_door_check()
{
	//TODO wait til everyone is inside
	trigger::wait_till( "close_security_door_trig" );	

	// Waiting until we get new door close anim
	level.security_control_room_blocker Solid();
	
	level thread scene::play("cin_pro_05_01_securitycam_1st_stealth_kill_closedoor");
	
	level flag::set( "everyone_in_camera_room" );
}


//*****************************************************************************
//*****************************************************************************
// Handle two independent security cameras
//*****************************************************************************
//*****************************************************************************

function setup_security_cameras()
{
	// Start the animations in each of the video camera locations
	level thread start_all_prisoner_scenes();
	
	// Handles breaking out of the camera
	level.minister_located = false;
	
	// Time for the counter to be initialised
	wait( 1 );	
	
	// Turn on the active stations the players can use to search for the Minister
	level.security_cams = [];
	level thread activate_player_video_screens( "s_security_camera_use_left", "s_security_cam_station_left", 1 );
	level thread activate_player_video_screens( "s_security_camera_use_right", "s_security_cam_station_right", 2 );
	
	level waittill( "hendricks_opens_door" );

	turn_off_security_cameras();
	wait( 0.1 );
	
	// Stop the animations in each of the video camera locations
	level thread stop_all_prisoner_scenes();
}


//*****************************************************************************
//*****************************************************************************

function turn_off_security_cameras()
{
	// Turn off Multi-Extracam mode for all players
	a_players = GetPlayers();
	for( i=0; i<a_players.size; i++ )
	{
		a_players[i] clientfield::set_to_player( "turn_on_multicam", 0 );
	}
}


//*****************************************************************************
// Turn on a gameobject that allows the player to interact with a video screen
// Left screen = extra_cam_index 1,  Right screen = extra_cam_index 2
//*****************************************************************************

function activate_player_video_screens( str_interact_struct, str_player_use_struct, extra_cam_index )
{
	s_interact = struct::get( str_interact_struct, "targetname" );
	s_player_use = struct::get( str_player_use_struct, "targetname" );
	
	level flag::wait_till( "camera_objective_marker" );

	objectives::set( "cp_level_prologue_security_camera", s_interact );
	
	// Setup a USE Trigger
	trigger = spawn( "trigger_radius_use", s_interact.origin, 0, 96, 30 );
	trigger TriggerIgnoreTeam();
	trigger TriggerEnable(true);
	trigger SetTeamForTrigger( "none" );
	trigger UseTriggerRequireLookAt();
	trigger SetCursorHint( "HINT_NOICON" );
	
	gobj_visuals = [];

	gobj_team = "any";
	gobj_trigger = trigger;
	gobj_objective_name = undefined;
	gobj_offset = ( 0, 0, 0 );
	e_object = gameobjects::create_use_object( gobj_team, gobj_trigger, gobj_visuals, gobj_offset, gobj_objective_name );

	// Setup gameobject params
	e_object gameobjects::allow_use( "any" );
	e_object gameobjects::set_use_time( 0.01 );						// How long the progress bar takes to complete
	e_object gameobjects::set_use_text( "" );
	e_object gameobjects::set_use_hint_text( "Hold ^3[{+activate}]^7 to Use" );
	e_object gameobjects::set_visible_team( "any" );				// How can see the gameobject

	// Setup gameobject callbacks
	e_object.onUse = &onUse_1;

	// The position the player stands when using the Video Screen
	e_object.s_player_use = s_player_use;

	e_object.extra_cam_index = extra_cam_index;

	// Disable the game object when the minister is located
	e_object thread check_for_video_cam_disable();

	return( e_object );
}


//*****************************************************************************
//*****************************************************************************

// self = video cam gameobject
function check_for_video_cam_disable()
{
	self endon( "death" );
	level waittill( "minister_located" );
	self gameobjects::disable_object();
}


//*****************************************************************************
// Called when the player used the security camera game object
//*****************************************************************************

// self = video cam gameobject
function onUse_1( player )
{
	// Handle the player scanning the security camera feeds
	player thread player_uses_the_security_camera_station( self.s_player_use, self.extra_cam_index );

	// Face scanner 2D information screens
	level.security_camera_ui = player OpenLUIMenu( "SecurityCamera" );
	player SetLUIMenuData( level.security_camera_ui, "scanStart1", 0 );
	player SetLUIMenuData( level.security_camera_ui, "scanStart2", 0 );
	player SetLUIMenuData( level.security_camera_ui, "scanStart3", 0 );

	// Disable and remove the gameobject handle
	self gameobjects::disable_object();
}


//*****************************************************************************
// Player scans through the video feeds looking for the Minister
//*****************************************************************************

// self = player
function player_uses_the_security_camera_station( s_player_use, extra_cam_index )
{
	snd_key = spawn( "script_origin", (s_player_use.origin));
	snd_key playsound ( "evt_typing" );

	self DisableWeapons( true );
	
	self.press_dpad_left_right = apc_shared::CreateClientHudText( self, "Press DPAD LEFT/RIGHT to cycle camera feed", 0, 400, 1.5 );
	
	str_anim_comfirm = "p_security_cam_interface_point";
	str_anim_outro = "p_security_cam_interface_exit";
	
	// Which station the player is at?
	switch( s_player_use.targetname )
	{	
		case "s_security_cam_station_left":		
			str_anim_idle = "p_security_cam_interface_idle";
			s_align_struct = struct::get( "s_security_cam_station_left", "targetname" );
		break;

		default:
		case "s_security_cam_station_right":		
			str_anim_idle = "p_security_cam_interface_idle_v2";
			s_align_struct = struct::get( "s_security_cam_station_right", "targetname" );
		break;		
	}
	
	// Play the Use Animation
	s_align_struct scene::play("p_security_cam_interface_intro", self);
	
	// Turns on the video
	level thread turn_on_security_camera( extra_cam_index );
	
	s_align_struct thread scene::play( str_anim_idle, self );
	
	wait( 0.5 );
	
	level.needed_index = level.security_cams[extra_cam_index].torture_room_index;
	
	while( 1 )
	{
		// Cycle feed backwards (left)
		if( self ActionSlotThreeButtonPressed() )
		{						
			// Cycle backwards through the objects
			level.security_cams[ extra_cam_index ].index--;
						
			if( level.security_cams[ extra_cam_index ].index <= 0 )
			{
				level.security_cams[ extra_cam_index ].index = level.security_cams[ extra_cam_index ].max_index;
			}
				
			// Set the extra cam we are using to look at the new object
			level clientfield::set( "set_active_cam_index", extra_cam_index );
			wait( 0.05 );
			level thread clientfield::set( "set_cam_lookat_object", level.security_cams[ extra_cam_index ].index );
			
			self thread scan_handler(extra_cam_index, str_anim_idle, str_anim_comfirm, s_align_struct);
			
			// Wait for button release
			while( self ActionSlotThreeButtonPressed() )
			{
				if( level.minister_located )
				{	
					break;
				}
				wait( 0.05 );
			}
		}
	
		// Cycle feed forwards (right)
		else if( self ActionSlotFourButtonPressed() )
		{
			// Cycle forwards through the objects
			level.security_cams[ extra_cam_index ].index++;
			if( level.security_cams[ extra_cam_index ].index > level.security_cams[ extra_cam_index ].max_index )
			{
				level.security_cams[ extra_cam_index ].index = 1;
			}
				
			// Set the extra cam we are using to look at the new object
			level clientfield::set( "set_active_cam_index", extra_cam_index );
			wait( 0.05 );
			level thread clientfield::set( "set_cam_lookat_object", level.security_cams[ extra_cam_index ].index );
			
			self thread scan_handler(extra_cam_index, str_anim_idle, str_anim_comfirm, s_align_struct);
			
			// Wait for button release
			while( self ActionSlotFourButtonPressed() )
			{
				if( level.minister_located )
				{	
					break;
				}
				wait( 0.05 );
			}
		}

		// The Minister may have been found by another player
		if( level.minister_located )
		{	
			break;
		}
		wait( 0.05 );
	}

	// Cleanup - For this player only
	self.press_dpad_left_right Destroy();

	// Restore player
	self EnableWeapons();

	self thread close_security_camera_menu();
	
	//turn off any anims, unlocking the player
	self StopAnimScripted( 0.5 );

	// Cleanup Security cam
	level.minister_located = true;

	level notify( "minister_located" );
	
	// Use video camera objective compete
	objectives::complete( "cp_level_prologue_security_camera" );
	objectives::complete( "cp_level_prologue_locate_the_minister" );
}


//*****************************************************************************
//*****************************************************************************

function turn_on_security_camera( cam_index )
{
	// Turn on Multi-Extracam mode for all players
	a_players = GetPlayers();
	for( i=0; i<a_players.size; i++ )
	{
		a_players[i] clientfield::set_to_player( "turn_on_multicam", cam_index );
	}

	// Create a security cam structure
	level.security_cams[ cam_index ] = SpawnStruct();

	level.security_cams[cam_index].index = cam_index;
	level.security_cams[cam_index].max_index = 6;
	level.security_cams[cam_index].minister_index = 3;
	level.security_cams[cam_index].torture_room_index = 2;
	level.security_cams[cam_index].hallway_index = 1;
	level.security_cams[cam_index].interrogation_room_index = 3;

	wait( 0.05 );
	level clientfield::set( "set_cam_lookat_object", level.security_cams[cam_index].index );
}


//*****************************************************************************
//*****************************************************************************

function scan_handler(extra_cam_index, str_anim_idle, str_anim_comfirm, s_align_struct)
{
	//run the scanner
	scanner_result = self start_face_scanner( extra_cam_index, level.needed_index);
		
	//progress between different correct scanner goals
	if( scanner_result )
	{
		self thread scene::stop( str_anim_idle, self );
   		s_align_struct scene::play( str_anim_comfirm, self );
   		
   		s_align_struct thread scene::play( str_anim_idle, self );
   		
   		//set needed scene from torture room to hallway
   		if (level.needed_index == level.security_cams[extra_cam_index].torture_room_index)
   		{
			level.needed_index = level.security_cams[extra_cam_index].hallway_index;
			
			//play hallways scene here, advances needed index when done 
			level thread security_camera_hallway_scene(extra_cam_index);
   		}
   		else if (level.needed_index == level.security_cams[extra_cam_index].hallway_index)
   		{
   			//do nothing
   		}
   		//end sequence
   		else 
   		{
   			//progresses sequence elsewhere
   			level.minister_located = true;
   		}
	}
}

//*****************************************************************************
//*****************************************************************************

// self = player
function close_security_camera_menu()
{
	wait( 2 );
	self CloseLUIMenu( level.security_camera_ui );
}


//*****************************************************************************
//*****************************************************************************
// self = player
function start_face_scanner( extra_cam_index, needed_index )
{
	start_time = GetTime();
	total_time = .5;

	self.progressBar = self hud::createPrimaryProgressBar();
	self.progressBar hud::updateBar( 0.01, 1 / total_time );
	snd_scan = spawn( "script_origin", (self.origin));
	snd_scan playloopsound ( "evt_scanning" );
	
	//start ui scan (need to know how many people are in the room, example is 2)
	self face_scanner_mode( extra_cam_index, 1 );
		
	found_minister = 0;
	aborted_scan = 0;
	while( 1 )
	{
		time = gettime();
		dt = ( time - start_time ) / 1000 ;

		// scan finished?
		if( dt > total_time )
		{
			// Were we looking at the correct Cell?
			if(  level.security_cams[ extra_cam_index ].index == needed_index )
			{
				found_minister = 1;
			}
			break;
		}
		//end scan if player changes cams
		if ( self ActionSlotFourButtonPressed() || self ActionSlotThreeButtonPressed() )
		{
			aborted_scan = 1;
			break;
		}
		wait( 0.05 );
	}

	if( IsDefined(self.progressBar) )
	{
		self.progressBar hud::destroyElem();
		self.progressBar = undefined;
	}

	snd_scan stoploopsound (.1);

	// Did we find the Minister
	if( found_minister )
	{
		self thread text_message( 0, 320, 1.5 , "Face Recognition: Minister Located", 4 );
		
		//call 'found' on the same number of people in the room
		self face_scanner_mode( extra_cam_index, 3 );
		return( 1 );
	}
	else if (aborted_scan)
	{
		//do nothing
	}
	else
	{
		self thread text_message( 0, 340, 1.5 , "Minister Not Found", 2 );
		
		//call 'not found' on the same number of people in the room
		self face_scanner_mode( extra_cam_index, 2 );
	}
	return( 0 );
}


// self = player
function text_message( xoff, yoff, scale, str_text, time )
{
	message = apc_shared::CreateClientHudText( self, str_text, xoff, yoff, scale );
	wait( time );
	message Destroy();
}

function security_camera_hallway_scene(extra_cam_index)
{
	//wait for torture scene to finish
	//TODO: Get cin for here
	
	wait 1;
	level thread scene::stop( "cin_pro_05_02_securitycam_pip_prisoner02" );//TEMP Hiding minister
	//play hallway cin
	/#IPrintLn( "Minister is being moved" );#/
	//wait until cin is done
	//TODO set up cameras in hallway
	level thread scene::play( "cin_pro_05_02_securitycam_vign_waterboard" ); 
	level waittill("minister_move_done");
	level thread scene::stop( "cin_pro_05_02_securitycam_vign_waterboard", true );
	level thread scene::play( "cin_pro_05_02_securitycam_pip_minister" ); 
	//level thread scene::play( "cin_pro_06_03_hostage_vign_interview" ); 
		
	//wait 10;
	/#IPrintLn( "Minister has arrived in interrogation room" );#/
	level.needed_index = level.security_cams[extra_cam_index].interrogation_room_index;
}


//*****************************************************************************
//*****************************************************************************

// self = player
function face_scanner_mode( extra_cam_index, mode )
{
	switch( level.security_cams[extra_cam_index].index )
	{	
		case 4:
			str_scan = "scanStart3";
		break;

		default:
			str_scan = "scanStart1";
		break;
	}

	self SetLUIMenuData( level.security_camera_ui, str_scan, mode );
}


//*****************************************************************************
//*****************************************************************************
// Prisoner scenes
//*****************************************************************************
//*****************************************************************************

function start_all_prisoner_scenes()
{
	level thread scene::play( "cin_pro_05_02_securitycam_pip_khalil" );
	level thread scene::play( "cin_pro_05_02_securitycam_pip_prisoner02" );
	//level thread scene::play( "cin_pro_05_02_securitycam_pip_minister" );
	level thread scene::play( "cin_pro_05_02_securitycam_pip_prisoner03" );
	level thread scene::play( "cin_pro_05_02_securitycam_pip_prisoner04" );
	level thread scene::play( "cin_pro_05_02_securitycam_pip_prisoner05" );
}

function stop_all_prisoner_scenes()
{
	level thread scene::stop( "cin_pro_05_02_securitycam_pip_khalil" );
	//level thread scene::stop( "cin_pro_05_02_securitycam_pip_minister" );
	//level thread scene::stop( "cin_pro_05_02_securitycam_pip_prisoner02" ); - temporarily stopped during minister move
	level thread scene::stop( "cin_pro_05_02_securitycam_pip_prisoner03" );
	level thread scene::stop( "cin_pro_05_02_securitycam_pip_prisoner04" );
	level thread scene::stop( "cin_pro_05_02_securitycam_pip_prisoner05" );
}


//*****************************************************************************
//*****************************************************************************
// Handles Hendricks in the security camera event
//*****************************************************************************
//*****************************************************************************

// self = Hendricks
function hendricks_security_camera()
{
	// Goto open door node
	nd_node1 = GetNode( "node_hendricks_security_camera", "targetname" );
	self.goalradius = 16;
	self SetGoal( nd_node1, true );
	self waittill( "goal" );
	
	s_pos = struct::get( "temp_security_door_obj", "targetname" );
	objectives::set( "cp_level_prologue_security_door", s_pos );
	
	trigger = getent( "temp_security_door_trig", "targetname" );
	trigger SetHintString( "Press and Hold ^3[{+activate}]^7 to Use door" );
	trigger SetCursorHint( "HINT_NOICON");
	trigger waittill( "trigger", player);
	
	// player and hendrick open the door and stealth kill the guards anim	
	level thread scene::play( "cin_pro_05_01_securitycam_1st_stealth_kill", player );

	objectives::complete( "cp_level_prologue_security_door" );
	
	level waittill ( "stealth_kill_done" );
	
	level thread hend_security_cam_dialog();
	
	level flag::wait_till( "everyone_in_camera_room" );
	
	level flag::set( "camera_objective_marker" );
	
	// Wait to open
	level waittill( "minister_located" );
	
	level.b_loadout_silenced = false;
	
	array::thread_all(level.players, &cp_prologue_util::give_player_weapons);
	
	
	level thread hend_security_cam_dialog_OTR();

	// Kill the looping scene
	level thread scene::stop( "cin_pro_05_01_securitycam_1st_stealth_kill" );
	level thread scene::skipto_end("cin_pro_05_01_securitycam_1st_stealth_kill_closedoor", undefined, undefined, .99);
	
	level thread scene::play("cin_pro_05_01_securitycam_1st_stealth_kill_exit");
	
	// Hack to stop Hendricks running into a wall
	wait( 0.1 );
	
	level notify( "hendricks_opens_door" );
}


//*****************************************************************************
//*****************************************************************************

function hend_security_cam_dialog()
{
	level.ai_hendricks dialog::say( "hend_i_ll_kill_the_alarms_0" ); // I’ll kill the alarms on this floor... Get plugged in and find the Minister.	
	wait 1;//pacing
	level.ai_hendricks dialog::say( "hend_taylor_scanning_fo_0" ); // Taylor - Scanning for package. Waiting for a hit on facial recognition.
	wait 1; 	
	
	level.ai_hendricks dialog::say( "hend_did_you_know_there_w_0" ); // Did you know there were other prisoners?
	level.ai_hendricks dialog::say( "tayr_the_minister_is_the_0" ); // The minister is the only priority.
	level.ai_hendricks dialog::say( "hend_understood_0" ); // Understood
}

function hend_security_cam_dialog_OTR()
{
	level.ai_hendricks dialog::say( "hend_match_confirmed_ce_0" ); //Match confirmed - Cell No. TBD. Moving to secure.
	level.ai_hendricks dialog::say( "tayr_eta_0" ); //ETA?
	level.ai_hendricks dialog::say( "hend_two_minutes_0" ); //Two minutes
	level.ai_hendricks dialog::say( "tayr_two_minutes_smart_0" ); //Two minutes. I’ll be timing you.
	level.ai_hendricks dialog::say( "hend_son_of_a_bitch_was_n_0" ); //Son of a bitch was never funny.	
}


//*****************************************************************************
//*****************************************************************************
// Legacy script
//*****************************************************************************
//*****************************************************************************

//#if 0
//
//function setup_camera_guards()
//{
//	sp_guard_left = GetEnt( "security_camera_guard_left", "targetname" );
//	sp_guard_right = GetEnt( "security_camera_guard_right", "targetname" );
//
//	ai_guard_left = sp_guard_left spawner::spawn();
//	ai_guard_right = sp_guard_right spawner::spawn();
//
//	level.ai_death_counter = 0;
//	ai_guard_left thread prologue_util::ai_death_count();
//	ai_guard_right thread prologue_util::ai_death_count();
//
//	level thread scene::play( "cin_pro_05_01_securitycam_vign_sitting" );
//	wait( 0.1 );
//	
//}
//
//function animate_guard_slumped_in_chair()
//{
//	scene::play( "cin_pro_05_02_securitycam_1st_interact_sit_group01" );
//}
//
//// self = ent
//function prisoner_on_cam_feed()
//{
//	self.goalradius = 48;
//	self.ignoreall = true;
//	level waittill( "hendricks_opens_door" );
//	self delete();
//}
//
//#endif
