#include maps\_utility;

Objectives()
{
	precacheShader( "objectiveA" );
	precacheShader( "objectiveB" );
	precacheShader( "objectiveC" );
	
	precacheString( &"TRAINYARD_OBJ_REGROUP" );
	precacheString( &"TRAINYARD_OBJ_CAPTUREHQ" );
	precacheString( &"TRAINYARD_OBJ_DEFENDHQ" );
	precacheString( &"TRAINYARD_OBJ_DESTROYTANK" );
	precacheString( &"TRAINYARD_OBJ_HARDPOINT1" );
	precacheString( &"TRAINYARD_OBJ_HARDPOINT2" );
	precacheString( &"TRAINYARD_OBJ_HARDPOINT3" );
	precacheString( &"TRAINYARD_OBJ_RENDEZVOUS" );

	curObjective = 1;

	objective_add( curObjective, "active", &"TRAINYARD_OBJ_REGROUP", (2812,1148,20) );
	objective_current( curObjective );
	flag_wait( "entered trench" );
	objective_state( curObjective, "done" );

	curObjective++;	
	objective_add( curObjective, "active", &"TRAINYARD_OBJ_CAPTUREHQ", (877,1301,358) );
	objective_current( curObjective );
	flag_wait( "captured stationhouse" );
	objective_state( curObjective, "done" );

	curObjective++;
	objective_add( curObjective, "active", &"TRAINYARD_OBJ_DEFENDHQ", (877,1301,358) );
	objective_current( curObjective );
	flag_wait( "defended stationhouse" );
	wait ( 10.0 );
	objective_state( curObjective, "done" );

	curObjective++;
	thread Objective_Tank( curObjective );
	
	flag_wait( "hardpoint1 dialog finished" );
	curObjective++;
	thread Objective_Hardpoint1( curObjective );

	flag_wait( "hardpoint2 dialog finished" );
	curObjective++;
	thread Objective_Hardpoint2( curObjective );

	flag_wait( "hardpoint3 dialog finished" );
	curObjective++;
	thread Objective_Hardpoint3( curObjective );
	
	flag_wait( "absolute victory" );
	cjPoints = getEntArray( "cj_origin", "targetname" );	
	cjPoint = getClosest( level.player.origin, cjPoints );
	
	curObjective++;
	objective_add( curObjective, "active", &"TRAINYARD_OBJ_RENDEZVOUS", cjPoint.origin );
	objective_current( curObjective );
	
	flag_wait( "rendezvous" );
	objective_state( curObjective, "done" );
}


Objective_Tank( objectiveIndex )
{
	objective_add( objectiveIndex, "active", &"TRAINYARD_OBJ_DESTROYTANK", (-608,234,168) );
	objective_current( objectiveIndex );
	flag_wait( "destroyed tank" );
	objective_state( objectiveIndex, "done" );
}


Objective_Hardpoint1( objectiveIndex )
{
	objective_add( objectiveIndex, "active", &"TRAINYARD_OBJ_HARDPOINT1", (-479,-784,28) );
	objective_additionalcurrent( objectiveIndex );
	thread Objective_Hardpoint1Icon( objectiveIndex );
	waittill_aigroupcleared( "supplydepot" );
	objective_position( objectiveIndex, (2740, -3724, 117));
	waittill_aigroupcleared( "hardpoint1" );
	objective_state( objectiveIndex, "done" );
	
	flag_set( "hardpoint 1 cleared" );
	autoSaveByName( "hardpoint1cleared" );
}


Objective_Hardpoint1Icon( objectiveIndex )
{
	flag_wait( "hardpoint2 dialog finished" );
	objective_icon( objectiveIndex, "objectiveA" );
}


Objective_Hardpoint2( objectiveIndex )
{
	objective_add( objectiveIndex, "active", &"TRAINYARD_OBJ_HARDPOINT2", (1019, -2725, 201), "objectiveB" );
	objective_additionalcurrent( objectiveIndex );
	waittill_aigroupcleared( "hardpoint2" );
	objective_state( objectiveIndex, "done" );
	
	flag_set( "hardpoint 2 cleared" );
	autoSaveByName( "hardpoint2cleared" );
}


Objective_Hardpoint3( objectiveIndex )
{
	objective_add( objectiveIndex, "active", &"TRAINYARD_OBJ_HARDPOINT3", (-712, -4632, 16), "objectiveC" );
	objective_additionalcurrent( objectiveIndex );
	waittill_aigroupcleared( "hardpoint3" );
	objective_state( objectiveIndex, "done" );
	
	flag_set( "hardpoint 3 cleared" );
	autoSaveByName( "hardpoint3cleared" );
}


