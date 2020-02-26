#include maps\_utility;
#include common_scripts\utility;
#include maps\_ac130;
#include maps\ac130_code;

//ac130_vehicle

main()
{
	if ( getdvar( "ac130_gameplay_enabled") == "" )
		setdvar( "ac130_gameplay_enabled", "1" );
	
	setExpFog( 1000, 17300, 0/255, 0/255, 0/255, 0 );
	setdvar( "scr_dof_enable", "0" );
	precacheLevelStuff();
	flag_init( "mission_failed" );
	
	level.hintPrintDuration = 5.0;
	level.minimumFriendlyCount = 3;
	
	add_start( "church", 	::start_church );
	add_start( "field1", 	::start_field1 );
	add_start( "hijack", 	::start_hijack );
	add_start( "junkyard",	::start_junkyard );
	
	default_start( ::start_start );
	
	scriptCalls();
}

start_start()
{
	spawn_friendlies( "friends_start" );
	thread dialog_opening();
	thread gameplay_start();
}

start_church()
{
	spawn_friendlies( "friends_church" );
	level.ac130.origin = getent( "ac130_waypoint_fight1", "targetname" ).origin;
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
	thread dialog_cleared_to_engage();
	thread gameplay_chuch();
}

start_field1()
{
	spawn_friendlies( "friends_field1" );
	level.ac130.origin = getent( "ac130_waypoint_field1", "targetname" ).origin;
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
	thread gameplay_fields();
}

start_hijack()
{
	spawn_friendlies( "friends_hijack" );
	level.ac130.origin = getent( "ac130_waypoint_hijack", "targetname" ).origin;
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
	wait 0.05;
	thread gameplay_hijack();
}

start_junkyard()
{
	spawn_friendlies( "friends_junkyard" );
	level.ac130.origin = getent( "ac130_waypoint_junkyard1", "targetname" ).origin;
	flag_set( "clear_to_engage" );
	flag_set( "allow_context_sensative_dialog" );
	wait 0.05;
	thread gameplay_junkyard1();
}

gameplay_start()
{
	move_friendlies( "friendly_location_01" );
	thread movePlaneToWaypoint( "ac130_waypoint_fight1" );
	wait 27;
	thread gameplay_chuch();
}

gameplay_chuch()
{
	spawn_vehicle( "first_truck_spawn_trigger" );
	wait 5;
	spawn_enemies( "first_truck_reinforcement_spawn_trigger" );
	wait 5;
	spawn_enemies( "first_shack_spawner_trigger" );
	spawn_enemies( "church_spawner_trigger" );
	spawn_enemies( "church_spawner_trigger2" );
	spawn_enemies( "house1_spawner_trigger" );
	wait 45;
	move_friendlies( "friendly_location_02" );
	wait 15;
	
	thread movePlaneToWaypoint( "ac130_waypoint_fight2" );
	
	stop_enemies( "first_shack_spawner_trigger" );
	spawn_enemies( "house2_spawner_trigger" );
	
	wait 20;
	
	stop_enemies( "church_spawner_trigger2" );
	move_friendlies( "friendly_location_03" );

	wait 20;
	
	stop_enemies( "church_spawner_trigger" );
	move_friendlies( "friendly_location_04" );
	spawn_vehicle( "long_road_truck_spawn_trigger" );
	
	wait 20;
	
	stop_enemies( "house1_spawner_trigger" );
	stop_enemies( "house2_spawner_trigger" );
	
	thread gameplay_fields();
}

gameplay_fields()
{
	thread movePlaneToWaypoint( "ac130_waypoint_field1" );
	
	move_friendlies( "friendly_location_05" );
	wait 10;
	spawn_enemies( "field1_spawner_trigger" );
	wait 10;
	spawn_vehicle( "field1_truck_spawn_trigger" );
	wait 30;
	stop_enemies( "field1_spawner_trigger" );
	waittill_dead( getEnemiesInZone( "volume_field1" ), undefined, 30 );
	
	thread gameplay_hijack();
}

gameplay_hijack()
{
	thread ac130_move_in();
	thread movePlaneToWaypoint( "ac130_waypoint_hijack" );
	
	move_friendlies( "friendly_location_06" );
	
	wait 10;
	
	vehGroup1 = [];
	vehGroup2 = [];
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 5 );
		
		level.getaway_vehicle_1 = getent( "getaway_vehicle_1", "targetname" );
		if ( !isdefined( level.getaway_vehicle_1 ) )
			level.getaway_vehicle_1 = maps\_vehicle::waittill_vehiclespawn( "getaway_vehicle_1" );
		
		level.getaway_vehicle_2 = getent( "getaway_vehicle_2", "targetname" );
		if ( !isdefined( level.getaway_vehicle_2 ) )
			level.getaway_vehicle_2 = maps\_vehicle::waittill_vehiclespawn( "getaway_vehicle_2" );
		
		//-------------------------------------------
		// stop the vehicles at the hijack roadbloack
		//-------------------------------------------
		getVehicleNode( "vehicle_hijack_start_stop", "script_noteworthy" ) waittill( "trigger" );
		level.getaway_vehicle_1 setSpeed( 0, 10 );
		level.getaway_vehicle_2 setSpeed( 0, 10 );
		wait 3;
		level.getaway_vehicle_1 notify( "unload" );
		level.getaway_vehicle_2 notify( "unload" );
		
		level waittill_multiple_ents( level.getaway_vehicle_1, "unloaded", level.getaway_vehicle_2, "unloaded" );
		
		//----------------------------------------------------------------
		// cars are stopped and unloaded - make friendlies get in them now
		//----------------------------------------------------------------
		wait 2;
		for( i = 0 ; i < level.friendlies.size ; i++ )
		{
			if ( !isdefined( level.friendlies[ i ] ) )
				continue;
			if ( !isalive( level.friendlies[ i ] ) )
				continue;
			if ( vehGroup1.size < 4 )
				vehGroup1[ vehGroup1.size ] = level.friendlies[ i ];
			else if ( vehGroup2.size < 4 )
				vehGroup2[ vehGroup2.size ] = level.friendlies[ i ];
			else
				assertMsg( "Tried to load more than 8 friendlies into two vehicles." );
		}
		// there should at least be one vehicle since mission is failed if there is less than 3 AI alive
		assert( vehGroup1.size > 0 );
		
		// first group get into vehicle 1
		level.getaway_vehicle_1 notify( "load", vehGroup1 );
		
		// second group get into vehicle 2
		if ( vehGroup2.size > 0 )
			level.getaway_vehicle_2 notify( "load", vehGroup2 );
	}
	
	thread gameplay_ambush();
	thread ac130_move_out();
	
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		if ( vehGroup2.size > 0 )
			waittill_multiple_ents( level.getaway_vehicle_1, "loaded", level.getaway_vehicle_2, "loaded" );
		else
			waittill_multiple_ents( level.getaway_vehicle_1, "loaded" );
	}
	
	//-------------------------------------------
	// Cars continue path with friendlies in them
	//-------------------------------------------
	if ( getdvar( "ac130_gameplay_enabled") == "1" )
	{
		level.getaway_vehicle_1 resumeSpeed( 10 );
		wait 1.3;
		level.getaway_vehicle_2 resumeSpeed( 10 );
	}
}

gameplay_ambush()
{
	thread movePlaneToWaypoint( "ac130_waypoint_ambush" );
	wait 5;
	spawn_vehicle( "ambush_truck1_spawn_trigger" );
	spawn_enemies( "ambush_rooftop_spawn_trigger" );
	wait 5;
	spawn_enemies( "ambush_rpg_spawn_trigger1" );
	spawn_enemies( "ambush_rpg_spawn_trigger4" );
	wait 5;
	thread ac130_move_in();
	spawn_enemies( "ambush_rpg_spawn_trigger3" );
	wait 5;
	spawn_enemies( "ambush_rpg_spawn_trigger2" );
	wait 10;
	spawn_vehicle( "ambush_bmp_spawn_trigger" );
	wait 55;
	
	//-------------------------------------------
	// stop the vehicles at the hijack roadbloack
	//-------------------------------------------
	getVehicleNode( "stop_at_junkyard", "script_noteworthy" ) waittill( "trigger" );
	level.getaway_vehicle_2 setSpeed( 0, 10 );
	wait 1;
	level.getaway_vehicle_1 setSpeed( 0, 10 );
	wait 3;
	level.getaway_vehicle_1 notify( "unload" );
	level.getaway_vehicle_2 notify( "unload" );
	
	thread gameplay_junkyard1();
}

gameplay_junkyard1()
{	
	thread movePlaneToWaypoint( "ac130_waypoint_junkyard1" );
	
	//----------------------------------
	// move friendlies to their position
	//----------------------------------
	move_friendlies( "friendly_location_07" );
	wait 5;
	
	//--------------------------------
	// Spawn groups of enemies to kill
	//--------------------------------
	spawn_enemies( "junkyard_spawn_trigger1" );
	wait 3;
	spawn_enemies( "junkyard_spawn_trigger4" );
	wait 5;
	spawn_enemies( "junkyard_spawn_trigger2" );
	wait 10;
	spawn_enemies( "junkyard_spawn_trigger5" );
	wait 15;
	spawn_enemies( "junkyard_spawn_trigger3" );
	wait 45;
	
	//------------------
	// Temp end of level
	//------------------
	missionEnd();
}

friendly_health_init()
{
	assert( isdefined( self ) );
	assert( isalive( self ) );
	assert( isAI( self ) );
	
	skill = getdifficulty();
	switch( skill )
	{
		case "gimp":
		case "easy":
			self.health = 3000;
			//self thread magic_bullet_shield();
			break;
		case "medium":
			self.health = 2500;
			break;
		case "hard":
		case "difficult":
			self.health = 1500;
			break;
		case "fu":
			self.health = 1000;
			break;
	}
}

dialog_opening()
{
	if (getdvar("ac130_enabled") == "0")
		return;
	
	array_thread( level.friendlies, ::ignoreAllEnemies, true );
	
	wait 2;
	
	//Wildfire, we are moving up the road towards a town to the east. Confirm you have a visual on us.
	playSoundOverRadio( level.scr_sound["price"]["ac130_pri_towntoeast"], true );
	wait 1;
	
	//Got eyes on friendlies!
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_eyesonfriendlies"], true );
	wait 1;
	
	//Crew, do not fire on any target marked by a strobe, those are friendlies.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_nofirestrobe"], true );
	wait 0.5;
	
	hintPrint( &"AC130_HINT_TOGGLE_THERMAL" );
	hintPrint( &"AC130_HINT_CYCLE_WEAPONS" );
	
	thread dialog_church_spotted();
}

dialog_church_spotted()
{
	//Uh, TV, confirm you see the church in the town.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_confirmchurch"], true );
	wait 1;
	
	//We see it, start the clock.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_weseeit"], true );
	wait 1;
	
	//Roger that we're there, start talking.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_rogerwerethere"], true );
	wait 0.5;
	
	//You are not authorized to level the church. Do not fire directly on the church.
	playSoundOverRadio( level.scr_sound["nav"]["ac130_nav_notauthorizedchurch"], true );
	
	flag_set( "clear_to_engage" );
	array_thread( level.friendlies, ::ignoreAllEnemies, false );
	
	thread dialog_cleared_to_engage();
}

dialog_cleared_to_engage()
{
	if ( getdvar( "ac130_alternate_controls" ) == "1" )
		hintPrint( &"AC130_HINT_ZOOM_AND_FIRE" );
	
	//Got a vehicle moving now!
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_vehiclemovingnow"], true );
	wait 1;
	
	//thread church_encounter();
	
	//One of the vehicles is moving right now.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_onevehiclemoving"], true );
	wait 1;
	
	//Personnel coming out of the church.
	playSoundOverRadio( level.scr_sound["tvo"]["ac130_tvo_personnelchurch"], true );
	wait 1;
	
	//We have armed personnel approaching from the church, request permission to engage.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_armedpersonnelchurch"], true );
	wait 1;
	
	//Copy. You are cleared to engage the moving vehicle, and any personnel around you see.
	playSoundOverRadio( level.scr_sound["pilot"]["ac130_plt_cleartoengage"], true );
	wait 1;
	
	flag_set( "allow_context_sensative_dialog" );
	
	//Affirmative. Crew you are cleared to engage but do not fire on the church.
	playSoundOverRadio( level.scr_sound["fco"]["ac130_fco_cleartoengage"], true );
}