#include clientscripts\mp\_utility;
#include clientscripts\mp\_rewindobjects;

#insert raw\maps\mp\_clientflags.gsh;

init()
{
	level._effect["cameraspike_enemy_light"] = loadfx( "misc/fx_equip_light_red" );
	level._effect["cameraspike_friendly_light"] = loadfx( "misc/fx_equip_light_green" );

	level._client_flag_callbacks["scriptmover"][CLIENT_FLAG_CAMERA_SPIKE] = ::spawned;
	if ( !isDefined( level.cameraSpikes ) )
		level.cameraSpikes = [];
	if ( !isDefined( level.cameraSpikeActive ) )
		level.cameraSpikeActive = [];
	if ( !isDefined( level.cameraSpikeHandle ) )
		level.cameraSpikeHandle = 0;
	level thread updateCameraSpikes();
}

resetCameraSpikeState( localClientNum )
{
	// Deactivate any active camera spikes
	setCameraSpikeActive( localClientNum, 0 );
	animateCameraMenus( localClientNum, "Default", 0 );
			
	// Cancel any active static
	level notify( "activateCameraStatic" );
	SetExtraCamStatic( localClientNum, 0 );
}

playerSpawned()
{
	self endon( "entityshutdown" );
	
	while ( true )
	{
		localPlayers = level.localPlayers;
		
		for ( i = 0 ; i < localPlayers.size ; i++ )
		{
			if ( localPlayers[i] == self )
				self resetCameraSpikeState( i );
		}
		
		self waittill( "respawn" );
	}
}

// Set whether or not the camera spike is active
setCameraSpikeActive( localClientNum, active )
{	
	if ( !isDefined( level.cameraSpikeActive[localClientNum] ) )
		level.cameraSpikeActive[localClientNum] = 0;
	wasActive = level.cameraSpikeActive[localClientNum];
	level.cameraSpikeActive[localClientNum] = active;
	
	// Active camera static when camera status changes
	staticSeconds = 0.25;
	if ( active != wasActive )
	{
		if (active)
		{
			animateCameraMenus( localClientNum, "spike_cam_on", int( staticSeconds * 1000 ) );
			PlaySound (0, "fly_camera_on", (0, 0, 0) );
		}
		else
		{
			animateCameraMenus( localClientNum, "Default", int( staticSeconds * 1000 ) );
			Playsound (0, "fly_camera_off", (0, 0, 0) );
		}
		activateCameraStatic( localClientNum, staticSeconds );
	}
		
	SetExtraCamActive( localClientNum, ( active > 0 ) );
}

animateCameraMenus( localClientNum, stateName, duration )
{
	if ( IsSplitscreen() )
		return;
		
	AnimateUI( localClientNum, "spike_cam", "*", stateName, duration );
	AnimateUI( localClientNum, "class", "*", stateName, duration );
	AnimateUI( localClientNum, "talkers", "*", stateName, duration );
	/*AnimateUI( localClientNum, "hud_bomb_timer_a", "*", stateName, duration );
	AnimateUI( localClientNum, "hud_bomb_timer_b", "*", stateName, duration );
	AnimateUI( localClientNum, "hud_ctf_icons", "*", stateName, duration );
	AnimateUI( localClientNum, "DPad", "*", stateName, duration );*/
}

// Add camera spike to global list
addCameraSpike( handle, cameraEnt )
{
	cameraSpike = spawnstruct();
	cameraSpike.handle = handle;
	cameraSpike.cameraEnt = cameraEnt;
	
	size = level.cameraSpikes.size;
	level.cameraSpikes[size] = cameraSpike;
}

// Remove camera spike from global list
removeCameraSpike( cameraSpikeHandle )
{
	for ( i = 0 ; i < level.cameraSpikes.size ; i++ )
	{
		last = level.cameraSpikes.size - 1;
		if ( level.cameraSpikes[i].handle == cameraSpikeHandle )
		{
			level.cameraSpikes[i].handle = level.cameraSpikes[last].handle;
			level.cameraSpikes[i].cameraEnt = level.cameraSpikes[last].cameraEnt;
			level.cameraSpikes[last] = undefined;
		}
	}
}

// Callback when a camera spike spawns
spawned( localClientNum, set )
{
	if ( !set || !IsSplitScreenHost( localClientNum ) )
		return;
		
	handle = level.cameraSpikeHandle;
	level.cameraSpikeHandle++;
	self thread watchShutdown( handle );
	self endon( "entityshutdown" );
	
	addCameraSpike( handle, self );
	self thread clientscripts\mp\_fx::blinky_light( localClientNum, "tag_light", level._effect["cameraspike_friendly_light"], level._effect["cameraspike_enemy_light"] );
}

// Removes camera from global list once it is deleted
watchShutdown( handle )
{
	self waittill( "entityshutdown" );
	removeCameraSpike( handle );
}

updateCameraSpikes()
{
	self endon( "entityshutdown" );
	cameraSpikeEnabled = [];
	cameraSpikeCountPrevious = -1;
	WaitForClient( 0 );
	
	while ( true )
	{
		localPlayers = level.localPlayers;

		if ( level.cameraSpikes.size != 0 || cameraSpikeCountPrevious != 0 )
		{
			for ( i = 0 ; i < localPlayers.size ; i++ )
			{
				cameraSpikeEnabled[i] = 0;
				SetExtraCamEntity( i, undefined );
			}

			for ( i = 0 ; i < level.cameraSpikes.size ; i++ )
			{
				for ( j = 0 ; j < localPlayers.size ; j++ )
				{
					if ( localPlayers[j] == level.cameraSpikes[i].cameraEnt GetOwner( j ) )
					{
						SetExtraCamEntity( j, level.cameraSpikes[i].cameraEnt );
						if ( IsCameraSpikeToggled( j ) )
						{
							cameraSpikeEnabled[j] = 1;
							SetExtraCamOrigin( j, level.cameraSpikes[i].cameraEnt GetTagOrigin( "tag_cam" ) );
							SetExtraCamAngles( j, level.cameraSpikes[i].cameraEnt.angles );
							if ( isDefined( level.cameraSpikes[i].cameraEnt.stunned ) && level.cameraSpikes[i].cameraEnt.stunned )
								activateCameraStatic( j, 0.25 );
						}
					}
				}
			}
			
			for ( i = 0 ; i < localPlayers.size ; i++ )
				setCameraSpikeActive( i, cameraSpikeEnabled[i] );
		}

		cameraSpikeCountPrevious = level.cameraSpikes.size;
		wait( 0.01 );
	}
}

activateCameraStatic( localClientNum, seconds )
{
	SetExtraCamStatic( localClientNum, 1 );
	level thread activateCameraStaticWaiter( localClientNum, seconds );
}

activateCameraStaticWaiter( localClientNum, seconds )
{
	self endon( "entityshutdown" );
	self notify( "activateCameraStatic" );
	self endon( "activateCameraStatic" );
	waitrealtime( seconds );
	SetExtraCamStatic( localClientNum, 0 );
}
