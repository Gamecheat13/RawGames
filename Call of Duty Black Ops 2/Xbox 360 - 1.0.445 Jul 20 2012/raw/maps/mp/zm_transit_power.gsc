#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#include maps\mp\zm_transit_utility;

initializePower()
{
	level thread electricSwitch();
	level thread powerEvent();
}

precache_models()
{
	// for the power switch light models
	//PreCacheModel("zombie_zapper_cagelight_red");
	//PreCacheModel("zombie_zapper_cagelight_green");
	//PreCacheModel("zombie_zapper_cagelight_on");
}


//*****************************************************************************
// ELECTRIC SWITCH
// once this is used, it activates other objects in the map
// and makes them available to use
//*****************************************************************************
elecSwitchBuildable()
{	
	GetEnt( "powerswitch_p_zom_pack_a_punch_battery", "targetname" ) Hide();
	GetEnt( "powerswitch_p_zom_moon_power_lever_short", "targetname" ) Hide();
	GetEnt( "powerswitch_p6_power_lever", "targetname" ) Hide();
	
	GetEnt( "powerswitch_buildable_trigger", "targetname" ) maps\mp\zombies\_zm_buildables::buildable_think( "powerswitch" ); // Wait For Buildable To Be Built
	GetEnt( "powerswitch_buildable_trigger", "targetname" ) Delete();
}


electricSwitch()
{
	flag_init("switches_on");

	level thread wait_for_power();
	
	trig = getent( "powerswitch_buildable_trigger_power", "targetname" );
	trig SetInvisibleToAll();
	
	// Buildable
	//----------
	elecSwitchBuildable();
	
	master_switch = GetEnt( "powerswitch_p6_power_lever", "targetname" );
	
	while ( true )
	{
		// Power On
		//---------
		trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH");
	
		trig SetVisibleToAll();
		trig waittill("trigger",user);
		trig SetInvisibleToAll();
		
		master_switch rotateroll(-90,.3);
		master_switch playsound("zmb_switch_flip");
	
		master_switch waittill("rotatedone");
		playfx(level._effect["switch_sparks"] ,getstruct("elec_switch_fx","targetname").origin);
		master_switch playsound("zmb_turn_on");
		
		iprintlnbold( "The reactor core is raising. Power will turn on when it is complete." );
		flag_set( "switches_on" );
		clientnotify( "pwr" );
		level waittill( "power_event_complete" );
		clientnotify( "pwr" );
		flag_set( "power_on" );
		if ( isdefined( user ) )
		{
			user thread delayed_poweron_vox();
		}
		
		// Power Off
		//----------		
		trig sethintstring(&"ZOMBIE_ELECTRIC_SWITCH_OFF");
		trig SetVisibleToAll();
	
		trig waittill("trigger",user);
		trig SetInvisibleToAll();
		
		master_switch rotateroll(90,.3);
		master_switch playsound("zmb_switch_flip");
	
		master_switch waittill("rotatedone");
		//* master_switch playsound("zmb_turn_off");
		
		iprintlnbold( "The reactor core is lowering. Power will turn off when it is complete." );
		flag_clear( "switches_on" );
		//* clientnotify( "pwr" );
		level waittill( "power_event_complete" );
		//* clientnotify( "pwr" );
		flag_clear( "power_on" );
		//* user thread delayed_poweron_vox();
	}
}

delayed_poweron_vox()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	wait(11.5);
	if( isdefined( self ) )
	{
		self thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "poweron" );
	}
}

wait_for_power()
{
	while( true )
	{
		// Power On
		//---------
		flag_wait("power_on");
	
		maps\mp\zombies\_zm_perks::perk_unpause_all_perks();
		wait_network_frame();
	
		// Set Perk Machine Notifys
		level notify("revive_on");
		wait_network_frame();
		level notify("doubletap_on");
		wait_network_frame();
	//	level notify("divetonuke_on");
	//	wait_network_frame();
		level notify("marathon_on");
		wait_network_frame();
	//	level notify("deadshot_on");
	//	wait_network_frame();
	//	level notify("additionalprimaryweapon_on");
	//	wait_network_frame();
		level notify("juggernog_on");
		wait_network_frame();
		level notify("sleight_on");
		wait_network_frame();
		level notify("Pack_A_Punch_on" );
	
		if ( !flag( "solo_game" ) )
		{
			wait_network_frame();
			level notify("tombstone_on");
		}
	
		//clientnotify( "power_on" );	// DSL - Redundant - the client sends this level notify when it recieves ZPO.  Also 'power_on' is too long a string to be sending over the network.
		//clientnotify("ZPO");	 // Zombie Power On.
		
		level SetClientField("zombie_power_on", 1);
	
		raisePowerPlantGates();
		
		// Power Off
		//----------
		flag_waitopen( "power_on" );
		
		maps\mp\zombies\_zm_perks::perk_pause_all_perks();
		wait_network_frame();
		
		// Set Perk Machine Notifys
		level notify("revive_off");
		wait_network_frame();
		level notify("doubletap_off");
		wait_network_frame();
	//	level notify("divetonuke_off");
	//	wait_network_frame();
		level notify("marathon_off");
		wait_network_frame();
	//	level notify("deadshot_off");
	//	wait_network_frame();
	//	level notify("additionalprimaryweapon_off");
	//	wait_network_frame();
		level notify("juggernog_off");
		wait_network_frame();
		level notify("sleight_off");
		wait_network_frame();
		level notify("Pack_A_Punch_off" );
		
		level SetClientField("zombie_power_on", 0);
	}
}
// ------------------------------------------------------------------------------------------------

// called when the power is turned on so the bus can proceed
raisePowerPlantGates()
{
	gate1 = [];
	gate2 = [];
	gate1 = GetEntArray("security_booth_gate", "targetname");
	gate2 = GetEntArray("security_booth_gate_2", "targetname");
	if ( IsDefined( gate1 ) )
	{
		for ( i = 0; i < gate1.size; i++ )
		{
			gate1[i] thread raiseGate(-90);
		}
	}
	if ( IsDefined( gate2 ) )
	{
		for ( i = 0; i < gate2.size; i++ )
		{
			gate2[i] thread raiseGate(90);
		}
	}
	iPrintLnBold("The reactor is online, and it's probably not going to explode.");
	level.the_bus notify("OnPowerOn");
}

// function to rotate the gates in their own thread so they all go up at the same time
raiseGate(degrees)
{
	self RotatePitch( degrees, 4 );
}

// handles the reactor core event that occurs when the power is turned on
powerEvent()
{
	reactor_core_mover = getEnt( "core_mover", "targetname" );
	reactor_core_audio = spawn( "script_origin", reactor_core_mover.origin );
	
	if ( !isDefined( reactor_core_mover ) )
	{
		return;
	}
	
	thread blockStairs();
	
	thread linkEntitiesToCoreMover(reactor_core_mover);
	

	while ( true )
	{
		// Power On
		//---------
		flag_wait("switches_on");
		
		thread dropReactorDoors();
		thread raiseReactorDoors();
		
		power_event_time = 30; //seconds
		//reactor_core thread coreRotate(power_event_time);
		
		reactor_core_mover playsound( "zmb_power_rise_start" );
		reactor_core_mover playloopsound( "zmb_power_rise_loop", .75 );
		reactor_core_mover thread coreMove(power_event_time);
		
		wait( power_event_time );
		
		reactor_core_mover stoploopsound( .5 );
		reactor_core_audio playloopsound( "zmb_power_on_loop", 2 );
		reactor_core_mover playsound( "zmb_power_rise_stop" );
		
		level notify( "power_event_complete" );
		
		// Power Off
		//----------
		flag_waitopen("switches_on");
		
		thread dropReactorDoors();
		thread raiseReactorDoors();
		
		playsoundatposition( "zmb_power_off_quad", (0,0,0) );
		reactor_core_mover playsound( "zmb_power_rise_start" );
		reactor_core_mover playloopsound( "zmb_power_rise_loop", .75 );
		reactor_core_mover thread coreMove(power_event_time, true);
		
		wait( power_event_time );
		
		reactor_core_mover stoploopsound( .5 );
		reactor_core_audio stoploopsound( .5 );
		reactor_core_mover playsound( "zmb_power_rise_stop" );
		
		level notify( "power_event_complete" );
	}
}

// handles rotating the core to the proper position
coreRotate(time)
{
	self rotateYaw( 180, time );
}

// handles moving the core up or down
coreMove(time,down)
{
	if ( is_true( down ) )
	{
		self moveZ( -160, time );
	}
	else
	{
		self moveZ( 160, time );
	}
}

// block the stairs
blockStairs()
{
	stairs_blocker = getEnt( "reactor_core_stairs_blocker", "targetname" );
	if ( !isDefined( stairs_blocker ) )
	{
		return;
	}
	stairs_blocker moveZ( -128, 1.0 );
}

// links all of the entities inside of the reactor core to the reactor core
linkEntitiesToCoreMover(reactor_core_mover)
{
	core_entities = getEntArray( "core_entity", "script_noteworthy" );

	for ( i = 0; i < core_entities.size; i++ )
	{
		next_ent = core_entities[i];
		if ( next_ent.classname == "trigger_use_touch" )
		{
			next_ent enableLinkTo();
		}
		next_ent linkTo( reactor_core_mover, "tag_origin" );
	}
}

// drop some doors that keep players in the control/power rooms
dropReactorDoors()
{
	doors = getEntArray( "reactor_core_door", "targetname" );
	if ( doors.size == 0 )
	{
		return;
	}
	for ( i = 0; i < doors.size; i++ )
	{
		next_door = doors[i];
		next_door moveZ( -128, 1.0 );
		next_door DisconnectPaths();
	}
}

// bring up the doors when the power event is complete
raiseReactorDoors()
{
	level waittill( "power_event_complete" );
	
	doors = getEntArray( "reactor_core_door", "targetname" );
	if ( doors.size == 0 )
	{
		return;
	}
	for ( i = 0; i < doors.size; i++ )
	{
		next_door = doors[i];
		next_door moveZ( 128, 1.0 );
		next_door ConnectPaths();
	}
	stairs_blocker = getEnt( "reactor_core_stairs_blocker", "targetname" );
	if ( IsDefined( stairs_blocker ) )
	{
		stairs_blocker delete();
	}
	core_door = getEnt( "core_door", "targetname" );
	if ( IsDefined( core_door ) )
	{
		core_door delete();
	}
}
