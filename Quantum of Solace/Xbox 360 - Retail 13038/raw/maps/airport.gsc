// Airpot Main
// Builder: Brian Glines
// Scripter: Walter Williams
// Date: 10-08-2007

// 02-27-08
// wwilliams
// have to include the call for the _usableobjects system in my main
// #include maps\_useableobjects;

main()
{		
	// vehicle inits, must be before _load
	maps\_blackhawk::main( "v_heli_mdpd_low" );
	// maps\_vsedan::main( "v_sedan_silver_radiant" );
	maps\_vsedan::main( "v_van_white_radiant" );

	// 02-27-08
	// wwilliams
	// call the _useableobjects main
	// level maps\_useableobjects::main();

	// setup player awareness
	level maps\_playerawareness::init();

	// precache
	level airport_precache();

	// the utility files for airport
	level maps\airport_anim::main();

	// precache the fxs
	level maps\airport_fx::main();

	// Make the game fade in at the start of the level (MikeA)
	gamefadeintime( 30.0 );

	// 08/12/08 jeremyl level var
	level.carlos_run_support_wave_on = false;									// Play or skip cutscenes

	// 02-26-08
	// wwilliams
	// set up drones
	// call the precache function for the drone
	//character\character_tourist_1_airport::precache();
	//character\character_tourist_2_airport::precache();
	//character\character_tourist_3_airport::precache();
	//character\character_tourist_1::precache();
	//character\character_tourist_2::precache();
	//character\character_tourist_3::precache();

	// set up the drones that can be used
	//level.drone_spawnFunction["civilian"][0] = character\character_tourist_1_airport::main;
	//level.drone_spawnFunction["civilian"][1] = character\character_tourist_2_airport::main;
	//level.drone_spawnFunction["civilian"][2] = character\character_tourist_3_airport::main;
	//level.drone_spawnFunction["civilian"][3] = character\character_tourist_1::main;
	//level.drone_spawnFunction["civilian"][4] = character\character_tourist_2::main;
	//level.drone_spawnFunction["civilian"][5] = character\character_tourist_3::main;

	// initilize the _drones file	
	maps\_drones::init();

	// load library
	level maps\_load::main();

	// set the clocks
	maps\_utility::init_level_clocks(7, 3, 41);
	// rocket jump fix
	level thread maps\airport_util::dad_rocket_jump_fix();
	// set cull distances for ps3
	level thread maps\airport_util::watch_cull_distance_E4();
	level thread maps\airport_util::watch_cull_distance_E5();

	///////////////////////////////////////////////////////////////////////////
	// make ther screen black as the level sets up

	level.introblack = NewHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;
	level.introblack.alpha = 1;
	level.introblack SetShader( "black", 640, 480 );

	// how to get rid of the black
	/* level.introblack fadeOverTime( 2.0 );
	level.introblack.alpha = 1;
	wait( 3 ); */
	///////////////////////////////////////////////////////////////////////////

	// DCS: setup level variable.
	level.catwalk_invalid = false;


	// define the ent_array of destructible vehicles
	// need to find these before _load in order to precache what is needed
	// for the destructible vehicles
	// ent_a_destruct_vehic = getentarray( "e4_lugg_3_destruct", "targetname" );

	// setup traps
	level maps\_trap_extinguisher::init();

	// set up the destructible vehicles for the airport
	/* for( i=0; i<ent_a_destruct_vehic.size; i++ )
	{
	ent_a_destruct_vehic[i]thread maps\_vehicle::bond_veh_death();
	ent_a_destruct_vehic[i]thread maps\_vehicle::bond_veh_flat_tire();
	} */

	// vision set
	Visionsetnaked( "airport_01" );

	// setup cameras
	level maps\_securitycamera::init();

	// turn on the lasers
	setDVar( "cg_laserAiOn", 1 );

	// wwilliams 11-15-07
	// moved this line past the _load call because _load inits this _ambientpackage needed for the airport_amb
	level maps\airport_amb::main();

	// this is the music script - chuck russom
	level maps\airport_mus::main();

	// setup the interactions
	// level maps\_gameobjects::init();

	// 03-11-08
	// wwilliams
	// attach the deadbolts to the backup doors
	level thread airport_backup_door_linker();

	// makes the map show up on the phone
	SetMiniMap( "compass_map_airport", 600, 14104, -6864, -1048 );

	// int for amount of laptops found and hacked
	level.awareness_obj = 0;

	// 07-24-08
	// manthony
	// ----- Add the Wet Materials -----
	level thread add_wet_materials();


	// setups the hidden laptops for the player
	// level thread maps\airport_util::config_playerawareness_objects();
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// 04-22-08
	// wwilliams
	// removing the old way for collectibles
	// airport is set up to use barnes's setup
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// flip tables function
	// 12-10-07 commenting it out until tables are ready
	//level thread maps\airport_util::setup_flip_table();

	// flag setup
	level airport_flags();

	// artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}

	// start up the plane fly overs
	level maps\_utility::flag_set( "airplane_fly_over_01" );

	// thread off the function that controls the changes to the visionset
	level thread maps\airport_util::airport_vision_set_init();

	// 03-11-08
	// wwilliams
	// starts up the function that will change the flags which allows the right area of the airport to have planes flying overhead

	// setup the objectives
	//level maps\airport_util::airport_objectives();

	// set up the fans for the luggage area 
	level thread maps\airport_util::airport_fans_init();

	// get the dvar as the case check
	str_skipto = getdvar( "skipto" );

	// 07-01-08
	// start funcs for all teh radios
	level thread maps\airport_util::airport_news_radio_one();
	level thread maps\airport_util::airport_news_radio_two();
	level thread maps\airport_util::airport_news_radio_three();

	// setup the checkpoints
	level thread maps\airport_util::watch_checkpoints();

	// check the value in the switch statement
	// default is the beginning of the level
	// starts with checkpoint 2
	switch( str_skipto )
	{

		// checkpoint two of airport
		// places the player near the top of the raised area in the second
		// virus event
	case "E2":

		// freeze the player's controls
		level.player freezecontrols( true );

		// get teh start node
		air_e2_start = getnode( "nod_e2_player_start", "targetname" );

		// set the correct fog for the area
		SetExpFog( 323, 651, 0.5, 0.5, 0.5, 1.0, 0.9 );
		// this is the max, whatever that is: 0.616471
		// setDVar( "scr_fog_max", "0.616471" );
		// vision set
		Visionsetnaked( "airport_02" );

		// wwilliams 03-03-08
		// spawn out the guy that talks at the beginning of event 2
		// define objects needed in this function
		spwn_e2_btm_ptl = getent( "nod_e2_bottom_patrol", "targetname" );
		ent_guy = undefined;
		// spawn the guy out
		ent_guy = spwn_e2_btm_ptl stalingradspawn( "e2_patroller" );
		if( !maps\_utility::spawn_failed( ent_guy ) )
		{
			// set the correct state 
			ent_guy setalertstatemin( "alert_yellow"  );

			// change his speed
			ent_guy setscriptspeed( "default" );

			// apply the function to this guy
			ent_guy thread maps\airport_two::e2_bottom_hallway_patrol();
		}

		// wwilliams 11-26-07
		// changed to using the script calls for moving the player
		//level airport_move_player( air_e2_start );
		level.player setorigin( air_e2_start.origin + ( 0, 0, 5 ) );
		level.player setplayerangles( air_e2_start.angles );

		// reset the dvar
		setdvar( "skipto", "" );

		// set flags for objectives
		level maps\_utility::flag_set( "objective_1" );

		// clean out the two guys at the beginning of the level
		merc_1 = getent( "Merc1", "targetname" );
		merc_2 = getent( "Merc2", "targetname" );

		// frame wait
		wait( 0.05 );

		// delete these two guys
		merc_1 delete();
		merc_2 delete();

		// setup the objectives
		// removing the thread to see if the funciton finishes quickly
		level thread maps\airport_util::airport_objectives();

		// quick wait
		wait( 1.0 );

		// 03-11-08
		// wwilliams
		// testing the plane fly over
		level thread maps\airport_util::airport_plane_flyby();

		// make the hud element on the screen fade away
		level.introblack fadeOverTime( 3.0 );
		// not sure why this is set
		level.introblack.alpha = 0;
		// wait
		wait( 3 );

		// freeze the player's controls
		level.player freezecontrols( false );

		level maps\airport_two::main();
		level maps\airport_three::main();
		level maps\airport_four::main();
		// 03-03-08
		// wwilliams
		// there is no event five
		// 04-05-08
		// five is back
		level maps\airport_five::main();	
		// kick out
		break;

		// checkpoint three of airport
		// drops the player in the area before the server antivirus upload
	case "E3":

		// lock the player's controls
		level.player freezecontrols( true );

		// get teh start node
		air_e3_start = getnode( "nod_e3_player_start", "targetname" );

		//level airport_move_player( air_e3_start );
		level.player setorigin( air_e3_start.origin + ( 0, 0, 5 ) );
		level.player setplayerangles( air_e3_start.angles );

		// reset the dvar
		setdvar( "skipto", "" );

		// set flags for objectives
		level maps\_utility::flag_set( "objective_1" );
		level maps\_utility::flag_set( "objective_2" );

		// clean out the two guys at the beginning of the level
		merc_1 = getent( "Merc1", "targetname" );
		merc_2 = getent( "Merc2", "targetname" );

		// frame wait
		wait( 0.05 );

		// delete these two guys
		merc_1 delete();
		merc_2 delete();

		// setup the objectives
		level thread maps\airport_util::airport_objectives();

		// set the correct fog for the area
		SetExpFog( 323, 651, 0.5, 0.5, 0.5, 1.0, 0.9 );
		// this is the max, whatever that is: 0.616471
		// setDVar( "scr_fog_max", "0.616471" );
		// vision set
		Visionsetnaked( "airport_03" );

		// quick wait
		wait( 1.0 );

		// 03-11-08
		// wwilliams
		// testing the plane fly over
		level thread maps\airport_util::airport_plane_flyby();

		// 05-21-08
		// wwilliams
		// new function sets up event three cameras and enemies when the player enters the
		// second virus download room
		level thread maps\airport_two::air_setup_zone3();

		// make the hud element on the screen fade away
		level.introblack fadeOverTime( 2.0 );
		// not sure why this is set
		level.introblack.alpha = 0;
		// wait
		wait( 3 );

		// freeze the player's controls
		level.player freezecontrols( false );

		level maps\airport_three::main();
		level maps\airport_four::main();
		// 03-03-08
		// wwilliams
		// there is no event five
		// 04-05-08
		// five if back
		level maps\airport_five::main();
		// get out of the switch
		break;

		// checkpoint four of airport
		// starts the player looking at the white van after the
		// server fight
	case "E4":

		// freeze the player controls
		level.player freezecontrols( true );

		// get teh start node
		air_e4_start = getnode( "nod_e4_player_start", "targetname" );

		// wwilliams 11-26-07
		// changed to using the script calls for moving the player
		//level airport_move_player( air_e4_start );
		level.player setorigin( air_e4_start.origin );
		level.player setplayerangles( air_e4_start.angles );

		// reset the dvar
		setdvar( "skipto", "" );

		// set flags for objectives
		level maps\_utility::flag_set( "objective_1" );
		level maps\_utility::flag_set( "objective_2" );
		level maps\_utility::flag_set( "objective_3" );

		// clean out the two guys at the beginning of the level
		merc_1 = getent( "Merc1", "targetname" );
		merc_2 = getent( "Merc2", "targetname" );

		// frame wait
		wait( 0.05 );

		// delete these two guys
		merc_1 delete();
		merc_2 delete();

		// 03-11-08
		// wwilliams
		// change the flag from the first airplane flyover route to the second
		// first clear the old flag
		level maps\_utility::flag_clear( "airplane_fly_over_01" );
		// set the second flag
		level maps\_utility::flag_set( "airplane_fly_over_02" );


		// setup the objectives
		level thread maps\airport_util::airport_objectives();

		// set the correct fog for the area
		SetExpFog( 323, 651, 0.5, 0.5, 0.5, 1.0, 0.9 );
		// this is the max, whatever that is:  0.87,
		// setDVar( "scr_fog_max", "0.87" );
		// vision set
		Visionsetnaked( "airport_04" );

		// quick wait
		wait( 1.0 );

		// 03-11-08
		// wwilliams
		// testing the plane fly over
		level thread maps\airport_util::airport_plane_flyby();

		// give the player another weapon
		level.player giveweapon( "TND16_AIR_s" );

		// make the hud element on the screen fade away
		level.introblack fadeOverTime( 2.0 );
		// not sure why this is set
		level.introblack.alpha = 0;
		// wait
		wait( 3 );

		// freeze the player's controls
		level.player freezecontrols( false );

		level maps\airport_four::main();
		level maps\airport_five::main();

		// exit switch
		break;


		// event five of airport
		// places the player at the garage doors exiting to the hanger
		// right before the doors open
	case "E5":

		// freeze player controls
		level.player freezecontrols( true );

		// 04-06-08
		// wwilliams
		// grab the correct area node
		// get teh start node
		air_e5_start = getnode( "nod_e5_player_start", "targetname" );

		// wwilliams 11-26-07
		// changed to using the script calls for moving the player
		//level airport_move_player( air_e4_start );
		level.player setorigin( air_e5_start.origin );
		// make sure there are angles on the node
		if( isdefined( air_e5_start ) )
		{
			level.player setplayerangles( air_e5_start.angles );
		}

		// 04-06-08
		// wwilliams
		// set flags for objectives
		level maps\_utility::flag_set( "objective_1" );
		level maps\_utility::flag_set( "objective_2" );
		level maps\_utility::flag_set( "objective_3" );
		level maps\_utility::flag_set( "objective_4" );
		level maps\_utility::flag_set( "objective_5" );

		level maps\_utility::flag_clear( "airplane_fly_over_01" );
		// set the second flag
		level maps\_utility::flag_clear( "airplane_fly_over_02" );

		// clean out the two guys at the beginning of the level
		merc_1 = getent( "Merc1", "targetname" );
		merc_2 = getent( "Merc2", "targetname" );

		// frame wait
		wait( 0.05 );

		// delete these two guys
		merc_1 delete();
		merc_2 delete();

		// set the correct fog for the area
		SetExpFog( 500, 600, 0.27, 0.28, 0.32, 1.0 );
		// this is the max, whatever that is:  0.87,
		setDVar( "scr_fog_max", "0.87" );
		// vision set
		Visionsetnaked( "airport_04" );

		// 06-19-08
		// wwilliams
		// function to control the garage door opening
		// need to start it here so the model is set up without the player seeing
		// it
		level thread maps\airport_five::e5_button_open_gdoors();

		// forklift explosion
		// 11-26-07 wwilliams
		// changing this call to the setup func
		//level thread e4_forklift_explosion();
		level thread maps\airport_four::forklift_explo_setup();

		// 03-11-08
		// wwilliams
		// testing the plane fly over
		level thread maps\airport_util::airport_plane_flyby();

		// give the player another weapon
		level.player giveweapon( "TND16_AIR_s" );

		// make the hud element on the screen fade away
		level.introblack fadeOverTime( 2.0 );
		// not sure why this is set
		level.introblack.alpha = 0;
		// wait
		wait( 3 );

		// freeze the player's controls
		level.player freezecontrols( false );

		// 03-03-08
		// wwilliams
		// there is no event five
		// 04-05-08
		// wwilliams
		// airport five has returned,
		// event consists of the carlos boss fight
		level maps\airport_five::main();

		// exit switch
		break;

		// default case of airport
		// starts the player at the beginning of the level
	default:

		// freeze player controls
		level.player freezecontrols( true );

		// setup the objectives
		// removing thread to see if we can get rid of that hitch
		level thread maps\airport_util::airport_objectives();

		// quick wait
		//wait( 1.0 );

		// set the correct fog for the area
		SetExpFog( 323, 651, 0.5, 0.5, 0.5, 1.0, 0.9 );
		// this is the max, whatever that is:  0.999,
		// setDVar( "scr_fog_max", "0.999" );

		// 03-11-08
		// wwilliams
		// testing the plane fly over
		level thread maps\airport_util::airport_plane_flyby();

		// event files for airport
		level maps\airport_one::main();
		level maps\airport_two::main();
		level maps\airport_three::main();
		level maps\airport_four::main();
		level maps\airport_five::main();

		// leave the switch
		break;
	}

	// 04-06-08
	// wwilliams
	// end the level after all the other events are done
	// no longer mission success, now called changelevel
	// changelevel( "casino" );
	// changelevel( "montenegrotrain" );
	wait( 3 );

	// chuck russom add atta boy bond line here.
	//				iprintlnbold (" chuck russom add atta boy bond line here and music stinger for mission completion maybe it goes back to smooth music"); 
	// place holder line
	level.player maps\_utility::play_dialogue("TANN_GlobG_020A", true);
	// what else could happen here that is cool 
	// end explosion
	//wait(3.4);
	level maps\_endmission::nextmission();

}
// ---------------------//
airport_precache()
{
				// precache phone map
				precacheShader( "compass_map_airport" );

				// precahce phone
				// precacheitem( "phone" );

				// weapons
				precacheitem( "v_jet_jumbo" );

				// vehicles
				precachevehicle( "defaultvehicle" );
				// precachevehicle( "v_heli_mdpd_low" );

				// precache model
				precachemodel( "v_heli_mdpd_low" );
				precachemodel( "v_van_white_radiant" );
				precachemodel( "p_frn_chair_metal" );
				precachemodel( "p_dec_laptop_blck" );
				precachemodel( "p_dec_monitor_modern" );
				precachemodel( "p_dec_tv_plasma" );
				precachemodel( "p_lvl_garage_control_button_off" );
				precachemodel( "p_lvl_garage_control_button_on" );

				// planes
				precachemodel( "v_jumbo_jet_v1" );
				precachemodel( "v_jet_737_stationary_v1" );

				// intro cutscene
				precachecutscene( "Airport_Intro" );
				
				// 08/10/08 jeremyl added this for cooler effect when the playe fails the mission.
				PreCacheItem("flash_grenade");

				// lines needed for the phone pickup
				// 04-22-08
				// wwilliams
				// 05-22-08
				// wwilliams
				// fixing these for alpha
				// also moving the string calls into the airport.st file and out of the data collection
				level.strings["airport_phone1_name"] = &"AIRPORT_PHONE_NAME1";
				level.strings["airport_phone1_body"] = &"AIRPORT_PHONE_BODY1";

				level.strings["airport_phone2_name"] = &"AIRPORT_PHONE_NAME2";
				level.strings["airport_phone2_body"] = &"AIRPORT_PHONE_BODY2";

				level.strings["airport_phone3_name"] = &"AIRPORT_PHONE_NAME3";
				level.strings["airport_phone3_body"] = &"AIRPORT_PHONE_BODY3";

				level.strings["airport_phone4_name"] = &"AIRPORT_PHONE_NAME4";
				level.strings["airport_phone4_body"] = &"AIRPORT_PHONE_BODY4";
				
				level.strings["airport_phone5_name"] = &"AIRPORT_PHONE_NAME5";
				level.strings["airport_phone5_body"] = &"AIRPORT_PHONE_BODY5";

				data_phone1 = getent("airport_phone1", "targetname");
				data_phone1.script_image = "data_collection_image_airport_1";

				// NOTE: this is actually the 5th phone
				data_phone4 = getent("airport_phone4", "targetname");
				data_phone4.script_image = "data_collection_image_airport_5";
}
// ---------------------//
// flag control for all the events, except the waits on the tanker rail
// EXAMPLE
//maps\_utility::flag_init( "flag" ); // Initialize the flag
//maps\_utility::flag_clear( "flag" ); // Set the flag to false
//maps\_utility::flag_set( "flag" ); // Sets the flag to true and sends out a notify
//maps\_utility::flag_wait( "flag" ); // Wait until the flag is set
airport_flags()
{
				// objective flags
				level maps\_utility::flag_init( "objective_1" );
				level maps\_utility::flag_init( "objective_2" );
				level maps\_utility::flag_init( "objective_3" );
				level maps\_utility::flag_init( "objective_4" );
				level maps\_utility::flag_init( "objective_5" );
				level maps\_utility::flag_init( "objective_6" );

				level maps\_utility::flag_clear( "objective_1" );
				level maps\_utility::flag_clear( "objective_2" );
				level maps\_utility::flag_clear( "objective_3" );
				level maps\_utility::flag_clear( "objective_4" );
				level maps\_utility::flag_clear( "objective_5" );
				level maps\_utility::flag_clear( "objective_6" );

				// global flags
				level maps\_utility::flag_init( "airplane_fly_over_01" );
				level maps\_utility::flag_init( "airplane_fly_over_02" );
				level maps\_utility::flag_init( "airplane_fly_over_03" );

				level maps\_utility::flag_clear( "airplane_fly_over_01" );
				level maps\_utility::flag_clear( "airplane_fly_over_02" );
				level maps\_utility::flag_clear( "airplane_fly_over_03" );

				// event one flags
				// level maps\_utility::flag_init( "start_e1_patrols" );
				level maps\_utility::flag_init( "e1_stealth_broken" );
				level maps\_utility::flag_init( "e1_virus_started" );
				level maps\_utility::flag_init( "e1_suspense_broken" );

				// level maps\_utility::flag_clear( "start_e1_patrols" );
				level maps\_utility::flag_clear( "e1_stealth_broken" );
				level maps\_utility::flag_clear( "e1_virus_started" );
				level maps\_utility::flag_clear( "e1_suspense_broken" );

				// event two flags
				level maps\_utility::flag_init( "event_two_start" );
				level maps\_utility::flag_init( "e2_stealth_broken" );
				level maps\_utility::flag_init( "e2_virus_started" );

				level maps\_utility::flag_clear( "event_two_start" );
				level maps\_utility::flag_clear( "e2_stealth_broken" );
				level maps\_utility::flag_clear( "e2_virus_started" );

				// event three flags
				level maps\_utility::flag_init( "e3_stealth_broken" );
				level maps\_utility::flag_init( "e3_antivirus_started" );
				// level maps\_utility::flag_init( "e3_door_kick" );

				level maps\_utility::flag_clear( "e3_stealth_broken" );
				level maps\_utility::flag_clear( "e3_antivirus_started" );
				// level maps\_utility::flag_clear( "e3_door_kick" );
				

				// event four flags
				//level maps\_utility::flag_init( "e4_warn" );

				//level maps\_utility::flag_clear( "e4_warn" );

}
// ---------------------//
// mover for the skiptos
// runs on level
// destin is a node
airport_move_player( destin )
{
				level.player freezecontrols( true );

				so_move = spawn( "script_origin", level.player.origin );

				so_move.angles = level.player.angles;

				level.player linkto( so_move );

				so_move moveto( destin.origin + ( 0, 0, 8 ), 0.1 );

				so_move waittill( "movedone" );

				so_move rotateto( destin.angles, 0.1 );

				so_move waittill( "rotatedone" );

				level.player unlink();

				level.player freezecontrols( false );

				wait( 0.5 );
				so_move delete();


}
// ---------------------//
// 03-11-08
// wwilliams
// function fixes all the moving doors with deadbolts on them
// this way when the door moves the deadbolts move with them
airport_backup_door_linker()
{
				// endon
				// not needed for this single fire function

				// objects to be defined for this function
				enta_doors = getentarray( "backup_doors", "script_noteworthy" );
				// enta_temp_deadbolt = undefined;
				// changing this to use two objects
				locks = undefined;

				// now go through each door in a for loop
				for( i=0; i<enta_doors.size; i++ )
				{

								// grab the door's targets
								// enta_temp_deadbolt = getentarray( enta_doors[i].target, "targetname" );
								// sequential through both locks
								locks = getentarray( enta_doors[i].target, "targetname" );

								// wait a frame
								//wait( 0.05 );
								for( j=0; j<locks.size; j++ )
								{
												// link lock_1
												locks[j] linkto( enta_doors[i] );
								}

								// debug text
								//iprintlnbold( "linked models to " + enta_doors[i].targetname + "" );

								// undefine
								locks = undefined;

				}
}
// ---------------------//
// 07-24-08
// manthony
// Add the Wet materials to the game
add_wet_materials()
{
//iprintlnbold("add_wet_materials");
	wait( 0.01 );

	materialaddwet( "mtl_w_mp05_plastic_wet" );
	materialaddwet( "mtl_w_mp05_stock_sd_wet" );
	materialaddwet( "mtl_w_mp05_scope_mount_wet" );
	materialaddwet( "mtl_w_scope_red_dot_wet" );
	materialaddwet( "mtl_w_m4_wet" );
	materialaddwet( "mtl_w_m4_mag_wet" );
	materialaddwet( "mtl_w_scope_holo_wet" );
	materialaddwet( "mtl_w_scope_holo_switch_wet" );
	materialaddwet( "mtl_w_stock_wet" );
	materialaddwet( "mtl_w_front_sight_post_wet" );
	materialaddwet( "mtl_w_m32_wet" );
	materialaddwet( "mtl_w_m32_metal_wet" );
	materialaddwet( "mtl_w_m32_ammo_wet" );
	materialaddwet( "mtl_w_1911_wet" );
	materialaddwet( "mtl_w_foregrip_wet" );
	
	// Weapon PA99
	materialaddwet( "mtl_w_p99_wet" );
	materialaddwet( "mtl_w_p99_silenced_wet" );
	
	// SAF9
	materialaddwet( "mtl_w_mp05_wet" );
	materialaddwet( "mtl_w_silencer_rifle_03_wet" );
	materialaddwet( "mtl_w_silencer_rifle_wet" );
		
	wait(0.05);
	// DCS: Making weapons materials start out not wet.
	materialsetwet( 0 );

}
// ---------------------//

