#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

init( localClientNum )
{
	level._effect["acousticsensor_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
	level._effect["acousticsensor_friendly_light"] = loadfx( "misc/fx_equip_light_green" );

	if ( !isDefined( level.acousticSensors ) )
		level.acousticSensors = [];
	if ( !isDefined( level.acousticSensorHandle ) )
		level.acousticSensorHandle = 0;
	SetLocalRadarEnabled( localClientNum, 0 );
	if ( localClientNum == 0 )
	{
		level thread updateAcousticSensors();
	}
}

addAcousticSensor( handle, sensorEnt, owner/*, sndScramPingEnt*/ )
{
	acousticSensor = spawnstruct();
	acousticSensor.handle = handle;
	acousticSensor.sensorEnt = sensorEnt;
	acousticSensor.owner = owner;
	//acousticSensor.sndScramPingEnt = sndScramPingEnt;
	
	size = level.acousticSensors.size;
	level.acousticSensors[size] = acousticSensor;
}

removeAcousticSensor( acousticSensorHandle )
{
	for ( i = 0 ; i < level.acousticSensors.size ; i++ )
	{
		last = level.acousticSensors.size - 1;
		if ( level.acousticSensors[i].handle == acousticSensorHandle )
		{
			level.acousticSensors[i].handle = level.acousticSensors[last].handle;
			level.acousticSensors[i].sensorEnt = level.acousticSensors[last].sensorEnt;
			level.acousticSensors[i].owner = level.acousticSensors[last].owner;
			//level.acousticSensors[i].sndScramPingEnt = level.acousticSensors[last].sndScramPingEnt;
			level.acousticSensors[last] = undefined;
			return;
		}
	}
}

spawned( localClientNum )
{
	handle = level.acousticSensorHandle;	
	level.acousticSensorHandle++;
	self thread watchShutdown( handle );
	
	owner = self GetOwner( localClientNum );
	addAcousticSensor( handle, self, owner/*, sndScramPingEnt*/ );

	local_players_entity_thread( self, ::spawnedPerClient );
}

spawnedPerClient(localClientNum )
{
	self endon( "entityshutdown" );
	
	self thread clientscripts\mp\_fx::blinky_light( localClientNum, "tag_light", level._effect["acousticsensor_friendly_light"], level._effect["acousticsensor_enemy_light"] );
}

watchShutdown( handle )
{
	self waittill( "entityshutdown" );
	removeAcousticSensor( handle );
}

updateAcousticSensors()
{
	self endon( "entityshutdown" );
	localRadarEnabled = [];
	previousAcousticSensorCount = -1;
	
	WaitForClient( 0 );
	
	while ( true )
	{
		// NOTE: this functionality is reliant on the level.localPlayers[] being valid. First check this if anything
		// is reported as not working here.
		localPlayers = level.localPlayers;
		if ( previousAcousticSensorCount != 0 || level.acousticSensors.size != 0 ) 
		{
		
		    for ( i = 0 ; i < localPlayers.size ; i++ )
			    localRadarEnabled[i] = 0;
		    
		    for ( i = 0 ; i < level.acousticSensors.size ; i++ )
		    {
			    if ( isDefined( level.acousticSensors[i].sensorEnt.stunned ) && level.acousticSensors[i].sensorEnt.stunned )
				    continue;
			    
			    for ( j = 0 ; j < localPlayers.size ; j++ )
			    {
				    if ( localPlayers[j] == level.acousticSensors[i].sensorEnt GetOwner( j ) )
				    {
					    localRadarEnabled[j] = 1;
					    SetLocalRadarPosition( j, level.acousticSensors[i].sensorEnt.origin );
				    }
			    }
		    }
		    
		    for ( i = 0 ; i < localPlayers.size ; i++ )
			    SetLocalRadarEnabled( i, localRadarEnabled[i] );
		}
		previousAcousticSensorCount = level.acousticSensors.size;
		wait( 0.1 );
	}
}
