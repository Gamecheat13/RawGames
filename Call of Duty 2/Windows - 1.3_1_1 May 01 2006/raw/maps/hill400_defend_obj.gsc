#include maps\_utility;

/****************************************************************************
Objectives:
		1. Destroy the advancing enemy vehicles.
		2. Seek shelter from the artillery barrage. // compass shows all shelter points
		2. Defend the northwest side of the hill.
		3. Seek shelter from the artillery barrage.
		3. Defend the northeast side of the hill.
		4. Seek shelter from the artillery barrage.
		4. Defend the north side of the hill.
		5. Seek shelter from the artillery barrage.
		5. Hold hill 400 until relieved. [n minutes]

*****************************************************************************/

Objectives()
{
	curObjective = 1;
	coverPoints = getEntArray( "cover_point", "targetname" );

	objective_add( curObjective, "active", "Use artillery to destroy the advancing enemy vehicles.", (0,0,0) );
	objective_current( curObjective );
	thread Objective_Vehicles( curObjective );
	while ( !flag( "completed artillery" ) )
	{
		objective_position( curObjective, level.braeburn.origin );
		wait ( 0.05 );
	}
	objective_state( curObjective, "done" );
	
	curObjective++;	
	objective_add( curObjective, "active", "Seek shelter from the artillery barrage.", (0,0,0) );
	for ( index = 0; index < coverPoints.size; index++ )
		objective_additionalposition( curObjective, index, coverPoints[index].origin );
	objective_current( curObjective );
	flag_wait( "survived barrage" );
	for ( index = 0; index < coverPoints.size; index++ )
		objective_additionalposition( curObjective, index, (0,0,0) );
	objective_string( curObjective, "Defend the northwest side of the hill." );
	objective_position( curObjective, (488,1696,12712) );
	flag_wait( "defended northwest" );
	objective_state( curObjective, "done" );

	curObjective++;	
	objective_add( curObjective, "active", "Seek shelter from the artillery barrage.", (0,0,0) );
	for ( index = 0; index < coverPoints.size; index++ )
		objective_additionalposition( curObjective, index, coverPoints[index].origin );
	objective_current( curObjective );
	flag_wait( "survived barrage" );
	for ( index = 0; index < coverPoints.size; index++ )
		objective_additionalposition( curObjective, index, (0,0,0) );
	objective_string( curObjective, "Defend the northeast side of the hill." );
	objective_position( curObjective, (808,-2512,12712) );
	flag_wait( "defended northeast" );
	objective_state( curObjective, "done" );

	curObjective++;	
	objective_add( curObjective, "active", "Seek shelter from the artillery barrage.", (0,0,0) );
	for ( index = 0; index < coverPoints.size; index++ )
		objective_additionalposition( curObjective, index, coverPoints[index].origin );
	objective_current( curObjective );
	flag_wait( "survived barrage" );
	for ( index = 0; index < coverPoints.size; index++ )
		objective_additionalposition( curObjective, index, (0,0,0) );
	objective_string( curObjective, "Defend the north side of the hill." );
	objective_position( curObjective, (1544,-272,12712) );
	flag_wait( "defended north" );
	objective_state( curObjective, "done" );

	curObjective++;	
	objective_add( curObjective, "active", "Seek shelter from the artillery barrage.", (0,0,0) );
	for ( index = 0; index < coverPoints.size; index++ )
		objective_additionalposition( curObjective, index, coverPoints[index].origin );
	objective_current( curObjective );
	flag_wait( "survived barrage" );
	for ( index = 0; index < coverPoints.size; index++ )
		objective_additionalposition( curObjective, index, (0,0,0) );
	objective_string( curObjective, "Hold hill 400 until reinforcements arrive." );
	flag_wait( "defended hill400" );
	objective_state( curObjective, "done" );
}


Objective_Vehicles( objectiveIndex )
{
	while ( true )
	{
		level waittill ( "objective vehicles", vehicles );
		
		for ( index = 0; index < vehicles.size; index++ )
			vehicles[index] thread Objective_Vehicle( objectiveIndex, index + 1 );
	}
}


Objective_Vehicle( objectiveIndex, vehicleIndex )
{
	while ( self.health )
	{
		objective_additionalposition( objectiveIndex, vehicleIndex, self.origin );
		wait ( 0.05 );
	}

	objective_additionalposition( objectiveIndex, vehicleIndex, (0,0,0) );	
}