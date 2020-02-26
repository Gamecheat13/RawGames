#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#include maps\mp\zombies\_zm_audio;

#insert raw\common_scripts\utility.gsh;

//*****************************************************************************
// THE AUTOMATON
//*****************************************************************************

initAudioAliases()
{
	level.vox zmbVoxAdd( "automaton", 	"scripted", "discover_bus", 		"discover_bus",			undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"leaving_warning", 		"warning_out",			undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"leaving", 				"warning_leaving",		undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"arriving", 			"stop_generic",			undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"arriving_farm", 		"stop_farm",			undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"out_of_gas", 			"gas_out",				undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"refueled_gas", 		"gas_full",				undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"doors_open", 			"doors_open",			undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"doors_close", 			"doors_close",			undefined);
	level.vox zmbVoxAdd( "automaton", 	"convo", 	"player_enter", 		"player_enter",			undefined);
	level.vox zmbVoxAdd( "automaton", 	"convo", 	"player_leave", 		"player_leave",			undefined);
	level.vox zmbVoxAdd( "automaton", 	"inform", 	"zombie_on_board", 		"zombie_enter", 		undefined );
}

main()
{
	level.automaton = GetEnt( "bus_driver_head", "targetname" );
	level.automaton.body = GetEntArray( "bus_driver_body", "targetname" );

	level.automaton thread automatonSetup();
	array_thread( level.automaton.body, ::LinkToThread, level.the_bus );
}

automatonSetup()
{
	self addAsSpeakerNPC();
	
	level.vox zmbVoxInitSpeaker( "automaton", "vox_bus_", self );
	
	self thread headThink();
}

headThink()
{
	self LinkTo( level.the_bus );

	self waittill( "start_head_think" );

	while ( true )
	{
		level.the_bus maps\mp\zm_transit_bus::busStopWait();
		wait ( 1.0 );
		// Wait For Bus To Stop, Then Do Actions Below

		self thread headLookAround();

		level.the_bus maps\mp\zm_transit_bus::busStartWait();
		// Wait For Bus To Go, Then Do Actions Below

		self headReset();

		// Wait For Bus To Accelerate
		while ( level.the_bus GetSpeed() < 1 )
		{
			wait ( 0.1 );
		}
	}
}

headLookAround()
{
	self endon( "stop_looking_around" );

	self UnLink();

	while ( true )
	{
		rotateTime = RandomFloatRange( 0.5, 8.0 );
		yaw = RandomIntRange( -360, 360 );

		if ( RandomInt( 100 ) > 50 )
		{
			yaw *= -1;
		}

		self RotateYaw( yaw, rotateTime, rotateTime / 2, rotateTime / 2 );
		self waittill( "rotatedone" );

		wait ( RandomIntRange( 3, 10 ) );
	}
}

headReset()
{
	self notify( "stop_looking_around" );
	self RotateTo( level.the_bus.angles, 0.1 );
	self waittill( "rotatedone" );
	self LinkTo( level.the_bus );
}

LinkToThread( ent )
{
	if ( IsDefined( ent.classname ) && ent.classname == "script_brushmodel" )
	{
		ent SetMovingPlatformEnabled( true );
	}
	
	self LinkTo( ent );
}