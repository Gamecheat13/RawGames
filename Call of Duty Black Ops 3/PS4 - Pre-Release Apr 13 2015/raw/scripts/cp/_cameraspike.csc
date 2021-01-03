#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "_t6/misc/fx_equip_light_red" );
#precache( "client_fx", "_t6/misc/fx_equip_light_green" );

function init()
{
	level._effect["cameraspike_enemy_light"] = "_t6/misc/fx_equip_light_red";
	level._effect["cameraspike_friendly_light"] = "_t6/misc/fx_equip_light_green";

	clientfield::register( "scriptmover", "cameraspike", 1, 1, "int", &spawned, true, !true );
	if ( !isdefined( level.cameraSpikes ) )
		level.cameraSpikes = [];
	if ( !isdefined( level.cameraSpikeActive ) )
		level.cameraSpikeActive = [];
	if ( !isdefined( level.cameraSpikeHandle ) )
		level.cameraSpikeHandle = 0;
	level thread updateCameraSpikes();
}

function resetCameraSpikeState( localClientNum )
{
	// Deactivate any active camera spikes
	setCameraSpikeActive( localClientNum, 0 );
			
	// Cancel any active static
	level notify( "activateCameraStatic" );
	SetExtraCamStatic( localClientNum, 0 );
}

function playerSpawned()
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
function setCameraSpikeActive( localClientNum, active )
{	
	if ( !isdefined( level.cameraSpikeActive[localClientNum] ) )
		level.cameraSpikeActive[localClientNum] = 0;
	wasActive = level.cameraSpikeActive[localClientNum];
	level.cameraSpikeActive[localClientNum] = active;
	
	// Active camera static when camera status changes
	staticSeconds = 0.25;
	if ( active != wasActive )
	{
		if (active)
		{
			PlaySound (0, "fly_camera_on", (0, 0, 0) );
		}
		else
		{
			Playsound (0, "fly_camera_off", (0, 0, 0) );
		}
		activateCameraStatic( localClientNum, staticSeconds );
	}
		
	SetExtraCamActive( localClientNum, ( active > 0 ) );
}

// Add camera spike to global list
function addCameraSpike( handle, cameraEnt )
{
	cameraSpike = spawnstruct();
	cameraSpike.handle = handle;
	cameraSpike.cameraEnt = cameraEnt;
	
	size = level.cameraSpikes.size;
	level.cameraSpikes[size] = cameraSpike;
}

// Remove camera spike from global list
function removeCameraSpike( cameraSpikeHandle )
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
function spawned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !newVal )
		return;
		
	handle = level.cameraSpikeHandle;
	level.cameraSpikeHandle++;
	self thread watchShutdown( handle );
	self endon( "entityshutdown" );
	
	addCameraSpike( handle, self );
	self thread fx::blinky_light( localClientNum, "tag_light", level._effect["cameraspike_friendly_light"], level._effect["cameraspike_enemy_light"] );
}

// Removes camera from global list once it is deleted
function watchShutdown( handle )
{
	self waittill( "entityshutdown" );
	removeCameraSpike( handle );
}

function updateCameraSpikes()
{
	self endon( "entityshutdown" );
	cameraSpikeEnabled = [];
	cameraSpikeCountPrevious = -1;
	util::waitforclient( 0 );
	
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
							if ( isdefined( level.cameraSpikes[i].cameraEnt.stunned ) && level.cameraSpikes[i].cameraEnt.stunned )
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

function activateCameraStatic( localClientNum, seconds )
{
	SetExtraCamStatic( localClientNum, 1 );
	level thread activateCameraStaticWaiter( localClientNum, seconds );
}

function activateCameraStaticWaiter( localClientNum, seconds )
{
	self endon( "entityshutdown" );
	self notify( "activateCameraStatic" );
	self endon( "activateCameraStatic" );
	waitrealtime( seconds );
	SetExtraCamStatic( localClientNum, 0 );
}
