#include maps\mp\_utility;
#include common_scripts\utility;

//	prototype for generic zipline / rappel 
//		- player can use their weapon while travelling on line
//		- player can drop off line by jumping

//	SETUP:
//		- trigger_touch marks the area where the player will be prompted to use the zipline (suggest 32x32x32 trigger touching ground)
//		- script_origin marked as the target of the trigger_use_touch is the destination

init()
{
	visuals = [];
	triggers = getentarray("zipline", "targetname");
	
	for( i = 0; i < triggers.size; i++ )
	{
		zipline = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", triggers[i], visuals, (0,0,0) );
		zipline maps\mp\gametypes\_gameobjects::allowUse( "any" );
		zipline maps\mp\gametypes\_gameobjects::setUseTime( 0.25 );		
		zipline maps\mp\gametypes\_gameobjects::setUseText( &"MP_ZIPLINE_USE" );
		zipline maps\mp\gametypes\_gameobjects::setUseHintText( &"MP_ZIPLINE_USE" );
		zipline maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		zipline.onBeginUse = ::onBeginUse;
		zipline.onUse = ::onUse;

		targets = [];
		target = getEnt( triggers[i].target, "targetname");
		
		if ( !isDefined( target ) )
			assertmsg( "No target found for zipline trigger located at: ( " + triggers[i].origin[0] + ", " + triggers[i].origin[1] + ", " + triggers[i].origin[2] + " )" );
		
		while ( isDefined( target ) )
		{
			targets[targets.size] = target;
			if ( isDefined( target.target ) )
				target = getEnt( target.target, "targetname");
			else
				break;
		}
		
		zipline.targets = targets;		
	}

	precacheModel( "tag_player" );
	
	//	elevator test
	init_elevator();
}


onBeginUse( player )
{
	player playSound( "scrambler_pullout_lift_plr" );
}


onUse( player )
{
	player thread zip( self );
}


zip( useObj )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "zipline_drop" );
	level endon( "game_ended" );
	
	//	make the carrier
	carrier = spawn( "script_origin", useObj.trigger.origin );
	carrier.origin = useObj.trigger.origin;
	carrier.angles = self.angles;
	carrier setModel( "tag_player" );
	
	//	link the player
	self playerLinkToDelta( carrier, "tag_player", 1, 180, 180, 180, 180 );
		
	//	monitor player
	self thread watchDeath( carrier );
	self thread watchDrop( carrier );
	
	//	loop through the path of targets
	targets = useObj.targets;
	for( i=0; i < targets.size; i++ )
	{			
		//	time
		//	JDS TODO: look into LDs specifying speed, accelleration, deceleration on the nodes
		time = distance( carrier.origin, targets[i].origin ) / 600;
		
		//	send it on its way
		acceleration = 0.0;
		if ( i==0 )
			acceleration = time*0.2;
		carrier moveTo( targets[i].origin, time, acceleration );
		if ( carrier.angles != targets[i].angles )
			carrier rotateTo( targets[i].angles, time*0.8 );
		
		//	wait
		wait( time );
	}
	
	//	all done
	self notify( "destination" );	
	self unlink();	
	carrier delete();
}


watchDrop( carrier )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "destination" );
	level endon( "game_ended" );
	
	self notifyOnPlayerCommand( "zipline_drop", "+gostand" );
	
	self waittill( "zipline_drop" );
	
	self unlink();
	carrier delete();	
}


watchDeath( carrier )
{
	self endon( "disconnect" );
	self endon( "destination" );
	self endon( "zipline_drop" );
	level endon( "game_ended" );
	
	self waittill( "death" );
	
	self unlink();
	carrier delete();
}



//	ELEVATOR TEST

//	JDS TODO: make this more generic to handle multiple elevators in a level
init_elevator()
{
	visuals = [];
	triggers = getEntArray("elevator_button", "targetname");
	
	level.elevator = spawnStruct();
	level.elevator.location = "floor1";	
	level.elevator.states = [];
	level.elevator.states["elevator"] = "closed";
	level.elevator.destinations = [];
	
	for( i = 0; i < triggers.size; i++ )
	{
		button = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", triggers[i], visuals, (0,0,0) );
		button maps\mp\gametypes\_gameobjects::allowUse( "any" );
		button maps\mp\gametypes\_gameobjects::setUseTime( 0.25 );		
		button maps\mp\gametypes\_gameobjects::setUseText( &"MP_ZIPLINE_USE" );
		button maps\mp\gametypes\_gameobjects::setUseHintText( &"MP_ZIPLINE_USE" );
		button maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		button.onBeginUse = ::onBeginUse_elevator;
		button.onUse = ::onUse_elevator;	
		
		button.location = triggers[i].script_label;
		level.elevator.states[triggers[i].script_label] = "closed";
		
		if ( isDefined( triggers[i].target ) )
		{
			destination = getStruct( triggers[i].target, "targetname" );
			if ( isDefined( destination ) )
				level.elevator.destinations[triggers[i].script_label] = destination;
		}
	}		
}


onBeginUse_elevator( player )
{
	// ding!
}

//	self = elevator button
onUse_elevator( player )
{
	switch( self.location )
	{
		case "floor1":
		{
			if ( level.elevator.states["floor1"] == "closed" )
			{
				if ( level.elevator.location == "floor1" )
				{		
					if ( level.elevator.states["elevator"] == "closed" )
					{
						level thread open( "floor1" );
						level thread open( "elevator" );
					}
				}
				else if ( level.elevator.location == "floor2" )
				{
					if ( level.elevator.states["elevator"] == "opened" )
					{
						level notify( "stop_autoClose" );
						
						level thread close( "floor2" );
						level close( "elevator" );					
					}
					if ( level.elevator.states["elevator"] == "closed" )
					{
						level move();
					
						level thread open( "floor1" );
						level thread open( "elevator" );						
					}
				}
			}
			break;
		}
		case "floor2":
		{
			if ( level.elevator.states["floor2"] == "closed" )
			{
				if ( level.elevator.location == "floor2" )
				{
					if ( level.elevator.states["elevator"] == "closed" )
					{
						level thread open( "floor2" );
						level thread open( "elevator" );
					}
				}
				else if ( level.elevator.location == "floor1" )
				{
					if ( level.elevator.states["elevator"] == "opened" )
					{
						level notify( "stop_autoClose" );
						
						level thread close( "floor1" );
						level close( "elevator" );					
					}
					if ( level.elevator.states["elevator"] == "closed" )
					{
						level move();
						
						level thread open( "floor2" );
						level thread open( "elevator" );						
					}
				}
			}				
			break;
		}
		case "elevator":
		{
			if ( level.elevator.states["elevator"] == "opened" )
			{
				level notify( "stop_autoClose" );
				
				level thread close( level.elevator.location );
				level close( "elevator" );	
			}
			if ( level.elevator.states["elevator"] == "closed" )
			{
				level move();
				
				level thread open( level.elevator.location );
				level thread open( "elevator" );				
			}
			break;
		}
	}
}


open( label )
{
	level.elevator.states[label] = "opening";
	
	doorL = getEnt( "e_door_" + label + "_left", "targetname" );
	doorR = getEnt( "e_door_" + label + "_right", "targetname" );
	
	//Changing script to accommodate both mp_fahrenheit and mp_vault - Mary
	
	if ( isDefined ( doorL.script_noteworthy ) && doorL.script_noteworthy == "fahrenheit" )
	{
		//Mary door move
		doorL moveTo( doorL.origin - anglesToForward( doorL.angles ) * 35, 2 );
		doorR moveTo( doorR.origin + anglesToForward( doorR.angles ) * 35, 2 );
		
		doorL PlaySound( "elev_door_open" );
		
	}
	else
	{
		//Sahas door move
		doorL moveTo( doorL.origin - anglesToRight( doorL.angles ) * 35, 2 );
		doorR moveTo( doorR.origin + anglesToRight( doorR.angles ) * 35, 2 );	
	}
	
		wait( 2 );
	
	level.elevator.states[label] = "opened";
	
	if ( label == "elevator" )
		level thread autoClose();
}


close( label )
{
	level.elevator.states[label] = "closing";
	
	doorL = getEnt( "e_door_" + label + "_left", "targetname" );
	doorR = getEnt( "e_door_" + label + "_right", "targetname" );
	
	if ( isDefined ( doorL.script_noteworthy ) && doorL.script_noteworthy == "fahrenheit" )
	{
		//Mary door move
		doorL moveTo( doorL.origin + anglesToForward( doorL.angles ) * 35, 2 );
		doorR moveTo( doorR.origin - anglesToForward( doorR.angles ) * 35, 2 );	
		
		doorL PlaySound ( "elev_door_close" );
		
	}
	
	else
	{
		//Sahas door move
		doorL moveTo( doorL.origin + anglesToRight( doorL.angles ) * 35, 2 );
		doorR moveTo( doorR.origin - anglesToRight( doorR.angles ) * 35, 2 );	
	}
		
	wait( 2 );
	
	level.elevator.states[label] = "closed";
}


autoClose()
{
	level endon( "stop_autoClose" );
	
	wait( 10 );
	
	level thread close( level.elevator.location );
	level thread close( "elevator" );	
}


//	JDS TODO: get nodes for doors or link them (get rid of delta calcs)
move()
{
	level.elevator.states["elevator"] = "moving";
	
	doorL = getEnt( "e_door_elevator_left", "targetname" );
	doorR = getEnt( "e_door_elevator_right", "targetname" );
	elevator = getEnt( "elevator", "targetname" );
	
	if ( level.elevator.location == "floor1" )
	{	
		level.elevator.location = "floor2";
		
		delta = doorL.origin[2] - level.elevator.destinations["floor1"].origin[2];		
		doorL moveTo( (doorL.origin[0], doorL.origin[1], level.elevator.destinations["floor2"].origin[2]+delta), 5 );	
		
		delta = doorR.origin[2] - level.elevator.destinations["floor1"].origin[2];
		doorR moveTo( (doorR.origin[0], doorR.origin[1], level.elevator.destinations["floor2"].origin[2]+delta), 5 );		
				
		elevator moveTo( level.elevator.destinations["floor2"].origin, 5 );
	}
	else
	{
		level.elevator.location = "floor1";	
		
		delta = doorL.origin[2] - level.elevator.destinations["floor2"].origin[2];
		doorL moveTo( (doorL.origin[0], doorL.origin[1], level.elevator.destinations["floor1"].origin[2]+delta), 5 );
		
		delta = doorR.origin[2] - level.elevator.destinations["floor2"].origin[2];
		doorR moveTo( (doorR.origin[0], doorR.origin[1], level.elevator.destinations["floor1"].origin[2]+delta), 5 );
		
		elevator moveTo( level.elevator.destinations["floor1"].origin, 5 );
	}
	
	wait( 5 );
	
	//Added elevator bell ding (doesn't work correctly with onBeginUse_elevator) - Mary
	elevator PlaySound ( "elev_bell_ding" );
	
	level.elevator.states["elevator"] = "closed";	
}
