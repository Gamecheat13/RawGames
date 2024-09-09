#include maps\mp\_utility;
#include common_scripts\utility;


init()
{
	if ( level.onlineGame )
	{
		level thread onPlayerSpawned();
		level thread onPlayerConnect();
	}
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connecting", player );
		//this could be more efficient... check for fireTeam
		player thread initOrbital();
	}
}

onPlayerSpawned()
{
	level endon("game_ended");
	
	for(;;)
	{
		level waittill( "player_spawned", player );
		
	}
}

initOrbital()
{
	
}


/*
///ScriptDocBegin
Name: spawnOrbital( )
Summary: Spawns a player in predator view. Puts player at drop location.
Module: orbital
CallOn: player
Example: self spawnOrbital();
SPMP: MP
///ScriptDocEnd
*/
spawnOrbital()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon ( "joined_team" );
	self endon ( "joined_spectators" );

	//The player has just (re)spawned and must decide how to respawn.
	
	//If the player has a drop pod already in the field, change its headicon to a waypoint_threat_hostile.
	//We'll change it back to a waypoint_kill if the player spawns back on this drop pod.
	if (IsDefined(self.drop_pod) && self.drop_pod.destroyed == false)
	{
		self.drop_pod maps\mp\_entityheadIcons::setHeadIcon( getOtherTeam(self.team), "waypoint_threat_hostile", (0,0,24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	}
	
	if (!isdefined( self.pers[ "isBot" ] ))
	{
		if (!IsDefined(self.prematch_over))
		{
			self.prematch_over = false;
		}
		if (!IsDefined(self.respawn_mode))
		{
			self.respawn_mode = 0;
		}
		if (!IsDefined(self.mode_button_released))
		{
			self.mode_button_released = 0;
		}
		
		self.spawn_button_released = 0;
		
		if (!IsDefined(self.reset_hud_text))
		{
			self.reset_hud_text = 1;
		}
		self.reset_hud_text = 1;
		
		self.is_linked_to_pod = false;
		self.is_linked_to_ac130 = false;
		
		if(self.prematch_over == false)
		{
			//Disable the player's weapons so he/she can't shoot from AC-130 view during the prematch countdown.
			self DisableWeapons();
			
			if (!self IsLinked())
			{
				//Linking the player to the AC-130 during the prematch countdown.
				self PlayerLinkWeaponviewToDelta( level.ac130, "tag_player", 1.0, 35, 35, 35, 35 );
				self.is_linked_to_ac130 = true;
				self.is_linked_to_pod = false;
			}
		}
		
		//Waiting until after the prematch countdown.
		gameFlagWait( "prematch_done" );
		
		self.prematch_over = true;
		
		//Disable the player's weapons so he/she can't shoot after the prematch countdown (we need to call DisableWeapons() again because the end of the prematch enables weapons).
		self DisableWeapons();
		
		//Start the force respawn timer.
		self.forcerespawn_timer = 15;
		self thread dropPodForceRespawn();

		//TODO: End highlighting for player when on the ground.  Create own enemy, friendly highlighting.
		//TODO: Audio for enemy trophy, need to see the trophy fire and hit you.  FX should cover trophy radius.
		
		//If the player is not a bot, wait for the player's input to decide whether to respawn at last drop pod (if available) or relaunch drop pod.
		while (1)
		{
			//Link the player view to their drop pod.
			if (IsDefined(self.drop_pod) && self.drop_pod.destroyed == false && self.respawn_mode == 1)
			{
				if (self.is_linked_to_pod == false)
				{
					//If the player is linked to something, unlink. You have to unlink the player before linking the player to something else.
					if (self IsLinked())
					{
						self Unlink();
					}
					self PlayerLinkWeaponviewToDelta( self.drop_pod, "tag_player", 0, 360, 360, 360, 360 );
					self.is_linked_to_pod = true;
					self.is_linked_to_ac130 = false;
				}
			}
			//Link the player view to the AC-130 if they don't have a drop pod on the ground.
			if (!IsDefined(self.drop_pod) || self.drop_pod.destroyed == true || self.respawn_mode == 0)
			{
				if (self.is_linked_to_ac130 == false)
				{
					//If the player is linked to something, unlink. You have to unlink the player before linking the player to something else.
					if (self IsLinked())
					{
						self Unlink();
					}
					self PlayerLinkWeaponviewToDelta( level.ac130, "tag_player", 0, 35, 35, 35, 35 );
					self.is_linked_to_pod = false;
					self.is_linked_to_ac130 = true;
				}
			}
			
			//Creating HUD elements telling the player how to respawn.
			if (self.reset_hud_text == 1)
			{
				//The player is in AC-130 view.
				if (self.respawn_mode == 0)
				{
					if (IsDefined(self.drop_pod))
					{
						self thread displayClientString(&"MP_ORBITAL_POD_VIEW", 15, 0.75);
					}
					else
					{
						self thread displayClientString(&"MP_NO_ORBITAL_POD", 15, 0.75);
					}
					self thread displayClientString(&"MP_LAUNCH_ORBITAL", 40, 0.75);
					self thread displayClientString(&"MP_ORBITAL_WARNING", 53, 0.6);
				}
				//The player is in Drop Pod view.
				else if (self.respawn_mode == 1)
				{
					self thread displayClientString(&"MP_ORBITAL_AERIAL_VIEW", 15, 0.75);
					self thread displayClientString(&"MP_TELEPORT_ORBITAL", 40, 0.75);
				}
				self.reset_hud_text = 0;
			}
			
			//Check whether the mode-switching button has been released - we only want to register discrete button pushes when switching between Respawn Modes.
			if (!self AdsButtonPressed())
			{
				self.mode_button_released = 1;
			}
			//Check whether the drop pod launching button has been released - we only want to register discrete button pushes. We don't want players to launch by holding down the button.
			if (!self AttackButtonPressed())
			{
				self.spawn_button_released = 1;
			}
			
			//Forcing a respawn from the AC-130. Link the player view to the AC-130 and launch a new drop pod.
			if (self.forcerespawn == true)
			{
				//Link player view to AC-130.
				self.respawn_mode = 0;
				if (self.is_linked_to_ac130 == false)
				{
					//If the player is linked to something, unlink. You have to unlink the player before linking the player to something else.
					if (self IsLinked())
					{
						self Unlink();
					}
					self PlayerLinkWeaponviewToDelta( level.ac130, "tag_player", 0, 35, 35, 35, 35 );
					self.is_linked_to_pod = false;
					self.is_linked_to_ac130 = true;
				}
				
				//Wait a frame to give the player a chance to get linked to the AC-130. Without this, the below rocket would get launched into the horizon.
				wait(0.05);
				
				//Setting up some variables to use in _fire. We will use these to determine the aim for the MagicBullet.
				self.ac130_location = self GetEye();
				self.ac130_viewangles = self GetPlayerAngles();
				self.ac130_forward = AnglesToForward(self.ac130_viewangles);
				self.ac130_endpoint = self.ac130_location + self.ac130_forward * 100;
				self.ac130_location = self.ac130_location + self.ac130_forward * -12500;
				//In _ac130.gsc, the below line is used to find the actual distance to the ground the player is aiming at.
				//pos = PhysicsTrace( origin, endpoint );
				
				//Unlink from AC-130 view.
				self Unlink();
				//Destroy the player's HUD elements explaining how to respawn.
				self notify("destroy_client_strings");

				nearest_node = _fire( self.lifeId, self  );

				//turn off the enemy trophy fx
				self notify( "player_drop_pod_spawned" );
				//self CameraUnlink();
				self EnableWeapons();
				
				//Exit out of this function.
				return;
			}
			//Switch between modes of respawning.
			else if (self AdsButtonPressed() && self.mode_button_released == 1)
			{
				self.mode_button_released = 0;
				
				//HUD text will be reset in the next iteration of this loop.
				self.reset_hud_text = 1;
				self notify("destroy_client_strings");
				
				if (self.respawn_mode == 0 && IsDefined(self.drop_pod) && self.drop_pod.destroyed == false)
				{
					//Drop Pod view.
					self.respawn_mode = 1;
					if (self.is_linked_to_pod == false)
					{
						//If the player is linked to something, unlink. You have to unlink the player before linking the player to something else.
						if (self IsLinked())
						{
							self Unlink();
						}
						self PlayerLinkWeaponviewToDelta( self.drop_pod, "tag_player", 0, 360, 360, 360, 360 );
						self.is_linked_to_pod = true;
						self.is_linked_to_ac130 = false;
					}
				}
				else if (self.respawn_mode == 1)
				{
					//AC-130 view.
					self.respawn_mode = 0;
					if (self.is_linked_to_ac130 == false)
					{
						//If the player is linked to something, unlink. You have to unlink the player before linking the player to something else.
						if (self IsLinked())
						{
							self Unlink();
						}
						self PlayerLinkWeaponviewToDelta( level.ac130, "tag_player", 0, 35, 35, 35, 35 );
						self.is_linked_to_pod = false;
						self.is_linked_to_ac130 = true;
					}
				}
			}
			else if (self AttackButtonPressed() && self.spawn_button_released == 1)
			{
				self.spawn_button_released = 0;
				
				//Respawn at existing drop pod.
				if (IsDefined(self.drop_pod) && self.drop_pod.destroyed == false && self.respawn_mode == 1 && self.is_linked_to_pod == true)
				{
					player_viewangles = self GetPlayerAngles();
					//Unlink from drop pod view.
					self Unlink();
					//Destroy the player's HUD elements explaining how to respawn.
					self notify("destroy_client_strings");
					//turn off the enemy trophy fx
					self notify( "player_spawned_at_drop_pod" );
					//test_point = (-518, 181, -356);
					self SetPlayerAngles(player_viewangles);
					//Teleport player to drop pod's location.
					self SetOrigin(self.drop_pod.origin);
					//self CameraUnlink();
					self EnableWeapons();
					
					//Exit out of this function.
					return;
				}
				//Launch a new drop pod.
				else if (self.respawn_mode == 0 && self.is_linked_to_ac130 == true)
				{
					//Setting up some variables to use in _fire. We will use these to determine the aim for the MagicBullet.
					self.ac130_location = self GetEye();
					self.ac130_viewangles = self GetPlayerAngles();
					self.ac130_forward = AnglesToForward(self.ac130_viewangles);
					self.ac130_endpoint = self.ac130_location + self.ac130_forward * 100;
					self.ac130_location = self.ac130_location + self.ac130_forward * -12500;
					//In _ac130.gsc, the below line is used to find the actual distance to the ground the player is aiming at.
					//pos = PhysicsTrace( origin, endpoint );
					
					//Unlink from AC-130 view.
					self Unlink();
					//Destroy the player's HUD elements explaining how to respawn.
					self notify("destroy_client_strings");
	
					nearest_node = _fire( self.lifeId, self  );

					//turn off the enemy trophy fx
					self notify( "player_drop_pod_spawned" );
					//self CameraUnlink();
					self EnableWeapons();
					
					//Exit out of this function.
					return;
				}
			}
			wait(0.05);
		}
	}
	else
	{
		//This player is a bot, so just launch a new drop pod for him, as usual.
		nearest_node = _fire( self.lifeId, self  );
		
		if( isdefined( nearest_node ) )
		{
			//Teleporting the player to the nearest path node.
			self setOrigin( nearest_node.origin );
			
			//Create a new drop pod and placing it at the nearest path node.
			self createPlayerDropPod(nearest_node.origin);
			
			self.drop_pod thread drop_pod_handleDamage();
			self.drop_pod thread drop_pod_handleDeath();
		}
	}
}


getBestSpawnPoint( remoteMissileSpawnPoints )
{
	validEnemies = [];

	foreach ( spawnPoint in remoteMissileSpawnPoints )
	{
		spawnPoint.validPlayers = [];
		spawnPoint.spawnScore = 0;
	}
	
	foreach ( player in level.players )
	{
		if ( !isReallyAlive( player ) )
			continue;

		if ( player.team == self.team )
			continue;
		
		if ( player.team == "spectator" )
			continue;
		
		bestDistance = 999999999;
		bestSpawnPoint = undefined;
	
		foreach ( spawnPoint in remoteMissileSpawnPoints )
		{
			//could add a filtering component here but i dont know what it would be.
			spawnPoint.validPlayers[spawnPoint.validPlayers.size] = player;
		
			potentialBestDistance = Distance2D( spawnPoint.targetent.origin, player.origin );
			
			if ( potentialBestDistance <= bestDistance )
			{
				bestDistance = potentialBestDistance;
				bestSpawnpoint = spawnPoint;	
			}	
		}
		
		assertEx( isDefined( bestSpawnPoint ), "Closest remote-missile spawnpoint undefined for player: " + player.name );
		bestSpawnPoint.spawnScore += 2;
	}

	bestSpawn = remoteMissileSpawnPoints[0];
	foreach ( spawnPoint in remoteMissileSpawnPoints )
	{
		foreach ( player in spawnPoint.validPlayers )
		{
			spawnPoint.spawnScore += 1;
			
			if ( bulletTracePassed( player.origin + (0,0,32), spawnPoint.origin, false, player ) )
				spawnPoint.spawnScore += 3;
		
			if ( spawnPoint.spawnScore > bestSpawn.spawnScore )
			{
				bestSpawn = spawnPoint;
			}
			else if ( spawnPoint.spawnScore == bestSpawn.spawnScore ) // equal spawn weights so we toss a coin.
			{			
				if ( coinToss() )
					bestSpawn = spawnPoint;	
			}
		}
	}
	
	return ( bestSpawn );
}

_fire( lifeId, player )
{
	player endon( "death" );
	//player endon( "disconnect" );
	//player endon ( "joined_team" );
	//player endon ( "joined_spectators" );
	remoteMissileSpawnArray = getEntArray( "remoteMissileSpawn" , "targetname" );

	foreach ( spawn in remoteMissileSpawnArray )
	{
		if ( isDefined( spawn.target ) )
			spawn.targetEnt = getEnt( spawn.target, "targetname" );	
	}
	
	if ( remoteMissileSpawnArray.size > 0 )
		remoteMissileSpawn = player getBestSpawnPoint( remoteMissileSpawnArray );
	else
		remoteMissileSpawn = undefined;
	
	if ( isDefined( remoteMissileSpawn ) )
	{
		startPos = remoteMissileSpawn.origin;	
		targetPos = remoteMissileSpawn.targetEnt.origin;

		//thread drawLine( startPos, targetPos, 30, (0,1,0) );

		vector = vectorNormalize( startPos - targetPos );		
		startPos = ( vector * 14000 ) + targetPos;

		//thread drawLine( startPos, targetPos, 15, (1,0,0) );
		
		//Firing the MagicBullet from the AC-130.
		if (!isdefined( player.pers[ "isBot" ] ))
		{
			rocket = MagicBullet( "orbital_drop_pod_mp", self.ac130_location, self.ac130_endpoint, player );
		}
		else
		{
			rocket = MagicBullet( "orbital_drop_pod_mp", startpos, targetPos, player );
		}
	}
	else
	{
		upVector = (0, 0, level.missileRemoteLaunchVert );
		backDist = level.missileRemoteLaunchHorz;
		targetDist = level.missileRemoteLaunchTargetDist;
	
		forward = AnglesToForward( player.angles );
		startpos = player.origin + upVector + forward * backDist * -1;
		targetPos = player.origin + forward * targetDist;
		
		//Firing the MagicBullet from the AC-130.
		if (!isdefined( player.pers[ "isBot" ] ))
		{
			rocket = MagicBullet( "orbital_drop_pod_mp", self.ac130_location, self.ac130_endpoint, player );
		}
		else
		{
			rocket = MagicBullet( "orbital_drop_pod_mp", startpos, targetPos, player );
		}
	}

	if ( !IsDefined( rocket ) )
	{
		player clearUsingRemote();
		return;
	}
	
	//rocket thread maps\mp\gametypes\_weapons::AddMissileToSightTraces( player.team );
	
	rocket thread handleDamage();
	
	rocket.owner = player;
	rocket.lifeId = lifeId;
	rocket.type = "remote";
	level.remoteMissileInProgress = true;
	nearest_node = MissileEyes( player, rocket );
	
	return nearest_node;
}


MissileEyes( player, rocket )
{
	//level endon ( "game_ended" );
	player endon ( "joined_team" );
	player endon ( "joined_spectators" );
	player endon ( "death" );
	//player endon("disconnect");
	//rocket endon("deleted");

	rocket thread Rocket_CleanupOnDeath();
	player thread Player_CleanupOnGameEnded( rocket );
	player thread Player_CleanupOnTeamChange( rocket );
	
	player VisionSetMissilecamForPlayer( "mp_prison", 0 );

	player endon ( "disconnect" );

	nearest_node = undefined;
	
	
	if ( isDefined( rocket ) )
	{
		//Link players to their rockets so they aren't standing around the map while in predator missile view.
		//player PlayerLinkTo( rocket );

		////////////////////////////////////////////
		//Turning on the thermal vision and overlay
		//player thread delayedFOFOverlay();
		//player VisionSetThermalForPlayer( level.ac130.enhanced_vision, 0 );
		//player.lastVisionSetThermal = level.ac130.enhanced_vision;
		//player ThermalVisionOn();
		//player thread maps\mp\killstreaks\_helicopter::thermalVision( airShip );
		////////////////////////////////////////////

		player CameraLinkTo( rocket, "tag_origin" );
		player ControlsLinkTo( rocket );
		
		//if (!isdefined( player.pers[ "isBot" ] ))
		//	player thread dropPodBarrelRoll(rocket);
		
		player.rocket_position = (0, 0, 0);
		rocket thread trackRocket(player);

		rocket thread dropPodTrophySystem();

		if ( getDvarInt( "camera_thirdPerson" ) )
			player setThirdPersonDOF( false );
		
		//TODO: HANDLE DEATH, and ROCKET DEATH SEPERATLY, need to not check for nodes if trophy death, trophy death also kills player.
		rocket endon( "destroyed" );
		rocket waittill( "death" );
		
		//Setting the player's spawn point - drop to the ground from a point above the rocket's last living position.
		//player.precision_spawn = drop_to_ground(player.rocket_position + (0, 0, 64));
		player.precision_spawn = PlayerPhysicsTrace(player.rocket_position + (0, 0, 64), player.rocket_position - (0, 0, 256));
		
		player destroyEnemyDropPodIcons();
		player destroyFriendlyPlayerIcons();

		//If the player flies their rocket into` the horizon and blows up, an SRE is thrown when using rocket.origin in the below spawn().
		//I use player.origin for now, but this will only work if you have the player linked to the rocket (see player PlayerLinkTo( rocket ) above.
		//trigger = spawn( "trigger_radius", rocket.origin, 0, 256, 256 );
		
		//Trying to solve the above hack.
		//I am checking slightly below the player.rocket_position because player.rocket_position doesn't update when the rocket actually hits the ground.
		trigger = spawn( "trigger_radius", player.rocket_position - (0, 0, 128), 0, 128, 256 );
		
		nearest_node = trigger thread getNearestPathNode();
		
		trigger delete();
	
		//player ThermalVisionOff();
		// is defined check required because remote missile doesnt handle lifetime explosion gracefully
		// instantly deletes its self after an explode and death notify
		//if ( isDefined(rocket) )
		//	player maps\mp\_matchdata::logKillstreakEvent( "predator_missile", rocket.origin );
	
		player ControlsUnlink();
		//player freezeControlsWrapper( true );
	
		// If a player gets the final kill with a hellfire, level.gameEnded will already be true at this point
		if ( !level.gameEnded || isDefined( player.finalKill ) )
			//Shortened the staticEffect and wait time below.
			//This decreases the sense of disorientation when spawning, but also gives a slight buffer so that players do not immediately assume control.
			//Why we need the buffer: if the player is immediately given control, she will find herself spinning around because she was just steering her rocket.
			player thread staticEffect( 0.2 );

		wait ( 0.2 );
		
		////////////////////////////////////////////
		//Turning off the thermal vision and overlay
		//player ThermalVisionFOFOverlayOff();
		//self ThermalVisionOff();
		//self VisionSetThermalForPlayer( game["thermal_vision"], 0 );
		////////////////////////////////////////////
		
		player CameraUnlink();
		
		if ( getDvarInt( "camera_thirdPerson" ) )
			player setThirdPersonDOF( true );

	}
	
	//Teleporting the player to their rocket's landing position if it falls within a drop_pod_volume trigger.
	player.precision_spawn_good = false;
	player.temp_origin = Spawn("script_origin", player.precision_spawn);
	//drop_pod_volume_array = GetEntArray("drop_pod_volume", "targetname");			//see level.drop_pod_volume_array in orbital.gsc
	foreach (trigger in level.drop_pod_volume_array)
	{
		if (player.temp_origin IsTouching(trigger) && CanSpawn(player.precision_spawn))
		{
			//if (CanSpawn(player.precision_spawn))
			//{
			//}
			player SetOrigin(player.precision_spawn);
			player SetPlayerAngles((player.angles[0], player.rocket_angles[1], player.angles[2]));
			//player thread centerPlayerCamera();
			player createPlayerDropPod(player.precision_spawn);
			
			player.drop_pod thread drop_pod_handleDamage();
			player.drop_pod thread drop_pod_handleDeath();
			
			player.precision_spawn_good = true;
			//Break out of the loop, no need to check the rest.
			break;
		}
	}
	//If the drop pod rocket didn't land in a drop_pod_volume...
	if ( player.precision_spawn_good == false )
	{
		if ( isdefined( nearest_node ) )
		{
			//Teleporting the player to the nearest path node.
			player setOrigin( nearest_node.origin );
			player SetPlayerAngles((player.angles[0], player.rocket_angles[1], player.angles[2]));
			player createPlayerDropPod(nearest_node.origin);
			
			player.drop_pod thread drop_pod_handleDamage();
			player.drop_pod thread drop_pod_handleDeath();
		}
		else
		{
			//There was no nearest_node, kill the player.
			player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( rocket, player, 999999, 0, "MOD_SUICIDE", "orbital_drop_pod_mp", player.origin, player.origin, "none", 0, 0 );
		}
	}

	
	return nearest_node;
	
	//player clearUsingRemote();
}


getNearestPathNode()
{
	nodes = GetNodesInTrigger( self );
	
	if( isdefined( nodes ) && nodes.size > 0 )
	{
		closest_node = 0;
		temp_dist = DistanceSquared(self.origin, nodes[0].origin);
		for (i = 0; i < nodes.size; i++)
		{
			check_dist = DistanceSquared(self.origin, nodes[i].origin);
			if (check_dist < temp_dist)
			{
				temp_dist = check_dist;
				closest_node = i;
			}
		}
		return nodes[closest_node];
	}
	else
	{
		return undefined;
	}
}


Rocket_CleanupOnDeath()
{
	entityNumber = self getEntityNumber();
	level.rockets[ entityNumber ] = self;
	self waittill( "death" );	
	
	level.rockets[ entityNumber ] = undefined;
	
	level.remoteMissileInProgress = undefined;
}


Player_CleanupOnGameEnded( rocket )
{
	rocket endon ( "death" );
	self endon ( "death" );
	
	level waittill ( "game_ended" );
	
	//self ThermalVisionFOFOverlayOff();
	self ControlsUnlink();
	self CameraUnlink();

	if ( getDvarInt( "camera_thirdPerson" ) )
		self setThirdPersonDOF( true );
}


Player_CleanupOnTeamChange( rocket )
{
	rocket endon ( "death" );
	self endon ( "disconnect" );

	self waittill_any( "joined_team" , "joined_spectators" );

	if ( self.team != "spectator" )
	{
		//self ThermalVisionFOFOverlayOff();
		self ControlsUnlink();
		self CameraUnlink();

		if ( getDvarInt( "camera_thirdPerson" ) )
			self setThirdPersonDOF( true );
	}
	self clearUsingRemote();
	
	level.remoteMissileInProgress = undefined;
}


/*
///ScriptDocBegin
Name: dropPod_CleanupOnTeamChange()
Summary: deletes this player's drop pod when she switches teams.
Module: orbital
CallOn: a player
MandatoryArg: N/A
Example: player thread dropPod_CleanupOnTeamChange();
SPMP: MP
///ScriptDocEnd
*/
dropPod_CleanupOnTeamChange()
{
	self.drop_pod endon("death");
	self waittill_any( "joined_team" , "joined_spectators" );
	self deletePlayerDropPod();
}


/*
///ScriptDocBegin
Name: dropPod_CleanupOnDisconnect()
Summary: delete this player's drop pod when she disconnects.
Module: orbital
CallOn: a player
MandatoryArg: N/A
Example: player thread dropPod_CleanupOnDisconnect();
SPMP: MP
///ScriptDocEnd
*/
dropPod_CleanupOnDisconnect()
{
	self.drop_pod endon("death");
	self waittill( "disconnect" );
	self deletePlayerDropPod();
}


delayedFOFOverlay()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	wait ( 0.15 );

	self ThermalVisionFOFOverlayOn();
}


staticEffect( duration )
{
	self endon ( "disconnect" );
	
	staticBG = newClientHudElem( self );
	staticBG.horzAlign = "fullscreen";
	staticBG.vertAlign = "fullscreen";
	staticBG setShader( "white", 640, 480 );
	staticBG.archive = true;
	staticBG.sort = 10;

	static = newClientHudElem( self );
	static.horzAlign = "fullscreen";
	static.vertAlign = "fullscreen";
	static setShader( "ac130_overlay_grain", 640, 480 );
	static.archive = true;
	static.sort = 20;
	
	wait ( duration );
	
	static destroy();
	staticBG destroy();
}


handleDamage()
{
	self endon ( "death" );
	self endon ( "deleted" );

	self setCanDamage( true );

	for ( ;; )
	{
	  self waittill( "damage" );
	  
	  println ( "projectile damaged!" );
	}
}


/*
///ScriptDocBegin
Name: createPlayerDropPod( )
Summary: Creates a drop pod for the player this function is called on.
Module: orbital
CallOn: a player
Example: player createPlayerDropPod();
SPMP: MP
///ScriptDocEnd
*/
createPlayerDropPod( coords )
{
	//self endon( "death" );
	//self endon( "disconnect" );
	//self endon ( "joined_team" );
	//self endon ( "joined_spectators" );
	
	//Delete the player's existing drop pod if he/she has one already.
	self deletePlayerDropPod();
	
	//Creates a new drop pod for the player.
	if (!IsDefined(coords))
	{
		coords = (-518, 181, -356);			//For testing.
	}
	self.drop_pod = spawn("script_model", coords);
	self.drop_pod.angles = (0, 0, 0);
	self.drop_pod SetModel( level.drop_pod.model );
	self.drop_pod Solid();
	self.drop_pod SetCanDamage( true );
	self.drop_pod SetCanRadiusDamage( true );
	self.drop_pod.hidden = false;
	self.drop_pod.owner = self;
	self.drop_pod.destroyed = false;
	self.drop_pod.health = 999999;	//keep it from dying anywhere in code (see drop_pod_handleDamage())
	self.drop_pod.maxHealth = 300;	//this is the health we'll check (see drop_pod_handleDamage())
	self.drop_pod.damageTaken = 0;	//how much damage has it taken
	//self.drop_pod maps\mp\_entityheadIcons::setHeadIcon( self.team, "waypoint_defend", (0,0,24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );		//We don't want to show icons on friendly pods anymore.
	//Showing icons on enemy drop pods.
	//self.drop_pod maps\mp\_entityheadIcons::setHeadIcon( getOtherTeam(self.team), "waypoint_threat_hostile", (0,0,24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	self.drop_pod maps\mp\_entityheadIcons::setHeadIcon( getOtherTeam(self.team), "waypoint_kill", (0,0,24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	//Showing an icon on your own drop pod.
	self.drop_pod maps\mp\_entityheadIcons::setHeadIcon( self, "waypoint_defend", (0,0,24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	
	//Spawning a flare effect for this drop_pod. See _perks.gsc
	self.drop_pod thread PodFlareTeamUpdater(level.drop_pod_glow["friendly"], level.drop_pod_glow["enemy"], self);
	
	//The Trophy System effect to show to enemy players.
	self.drop_pod thread PodSetupTrophyFX( level.drop_pod_trophyFX["friendly"], level.drop_pod_trophyFX["enemy"], self );
	
	self thread dropPod_CleanupOnDisconnect();
	self thread dropPod_CleanupOnTeamChange();

}


/*
///ScriptDocBegin
Name: deletePlayerDropPod( )
Summary: Deletes the drop pod of the player this function is called on.
Module: orbital
CallOn: a player
Example: player deletePlayerDropPod();
SPMP: MP
///ScriptDocEnd
*/
deletePlayerDropPod()
{
	//Deletes the player's drop pod if it exists. We need to do this because we call createPlayerDropPod() every time a player spawns.
	//If the player has just entered the match, they will get their first drop pod in createPlayerDropPod().
	//If the player is respawning, we handle that here, destroying the existing drop pod on player death.
	if (IsDefined(self.drop_pod))
	{
		self.drop_pod Delete();
	}
}


//Based on ims_handleDamage() in _ims.gsc
/*
///ScriptDocBegin
Name: drop_pod_handleDamage( )
Summary: Handles damage on a landed orbital drop pod.
Module: orbital
CallOn: a drop pod
Example: level.player.drop_pod drop_pod_handleDamage();
SPMP: MP
///ScriptDocEnd
*/
drop_pod_handleDamage() // self == drop pod
{
	self endon( "death" );
	level endon( "game_ended" );

	//move these variable declarations to createPlayerDropPod().
	//self.health = 999999; // keep it from dying anywhere in code
	//self.maxHealth = 300; // this is the health we'll check
	//self.damageTaken = 0; // how much damage has it taken

	while( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, modelName, tagName, partName, iDFlags, weapon );

		//If friendly fire is off or the player is attacking his/her own drop pod, continue and do no damage.
		if ( !maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker ) || self.owner == attacker )
			continue;

		if ( IsDefined( weapon ) )
		{
			switch( weapon )
			{
			case "concussion_grenade_mp":
			case "flash_grenade_mp":
			case "smoke_grenade_mp":
			//case "ims_projectile_mp": // shouldn't take damage from itself or another one // now it should!
				continue;
			}
		}

		if ( !IsDefined( self ) )
			return;
		
		// if this is hidden we don't want it to take damage
		if( self.hidden )
			continue;

		if ( meansOfDeath == "MOD_MELEE" )
			self.damageTaken += self.maxHealth;

		if( IsExplosiveDamageMOD( meansOfDeath ) )
			damage *= 1.5;

		if ( isDefined( iDFlags ) && ( iDFlags & level.iDFLAGS_PENETRATION ) )
			self.wasDamagedFromBulletPenetration = true;

		self.wasDamaged = true;

		modifiedDamage = damage;
		if ( isPlayer( attacker ) )
		{
			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "ims" );

			if ( attacker _hasPerk( "specialty_armorpiercing" ) )
			{
				modifiedDamage = damage * level.armorPiercingMod;			
			}
		}

		// in case we are shooting from a remote position, like being in the osprey gunner shooting this
		if( IsDefined( attacker.owner ) && IsPlayer( attacker.owner ) )
		{
			attacker.owner maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "ims" );
		}

		if( IsDefined( weapon ) )
		{
			switch( weapon )
			{
			case "ac130_105mm_mp":
			case "ac130_40mm_mp":
			case "stinger_mp":
			case "javelin_mp":
			case "remote_mortar_missile_mp":		
			case "remotemissile_projectile_mp":
				self.largeProjectileDamage = true;
				modifiedDamage = self.maxHealth + 1;
				break;

			case "artillery_mp":
			case "stealth_bomb_mp":
				self.largeProjectileDamage = false;
				modifiedDamage += ( damage * 4 );
				break;

			case "bomb_site_mp":
			case "emp_grenade_mp":
				self.largeProjectileDamage = false;
				modifiedDamage = self.maxHealth + 1;
				break;
			}
			
			maps\mp\killstreaks\_killstreaks::killstreakHit( attacker, weapon, self );
		}

		self.damageTaken += modifiedDamage;
		
		if ( self.damageTaken >= self.maxHealth )
		{
			thread maps\mp\gametypes\_missions::vehicleKilled( self.owner, self, undefined, attacker, damage, meansOfDeath, weapon );
			
			self.destroyed = true;
			
			//Set respawn mode to 0 - player must launch a new drop pod.
			self.owner.respawn_mode = 0;

			if ( isPlayer( attacker ) && (!isDefined(self.owner) || attacker != self.owner) )
			{
				//Using pod_destroy event type (see orbital.gsc).
				attacker thread maps\mp\gametypes\_rank::giveRankXP( "pod_destroy", 200, weapon, meansOfDeath );
				maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], 1 );
				maps\mp\gametypes\_gamescore::givePlayerScore( "pod_destroy", attacker );
				attacker notify( "destroyed_killstreak" );
				attacker notify( "destroyed_explosive" );
				thread playSoundOnPlayers( "mp_capture_flag", attacker.pers["team"] );
				//attacker thread maps\mp\gametypes\_hud_message::SplashNotify( "callout_destroyed_objective" );
				attacker thread maps\mp\gametypes\_hud_message::SplashNotify( "drop_pod_destroy", maps\mp\gametypes\_rank::getScoreInfoValue( "capture" ) );
				level thread teamPlayerCardSplash( "callout_destroyed_objective", attacker );
			}

			if ( isDefined( self.owner ) )
				self.owner thread leaderDialogOnPlayer( "ims_destroyed", undefined, undefined, self.origin );

			self notify ( "death" );
			return;
		}
	}
}


//Based on ims_handleDeath() in _ims.gsc
/*
///ScriptDocBegin
Name: drop_pod_handleDeath( )
Summary: Handles death for a landed orbital drop pod.
Module: orbital
CallOn: a drop pod
Example: level.player.drop_pod drop_pod_handleDeath();
SPMP: MP
///ScriptDocEnd
*/
drop_pod_handleDeath()
{
	entNum = self GetEntityNumber();

	//self addToIMSList( entNum );

	self waittill ( "death" );

	//self removeFromIMSList( entNum );

	// this handles cases of deletion
	if ( !isDefined( self ) )
		return;

	//self setModel( level.imsSettings[ self.imsType ].modelDestroyed );

	//self ims_setInactive();

	// TODO: get sound for this
	self playSound( "ims_destroyed" );

	/*if ( isDefined( self.inUseBy ) )
	{
		PlayFX( getfx( "ims_explode_mp" ), self.origin + ( 0, 0, 10 ) );
		PlayFX( getfx( "ims_smoke_mp" ), self.origin );
		//playFxOnTag( getFx( "ims_explode_mp" ), self, "tag_origin" );
		//playFxOnTag( getFx( "ims_smoke_mp" ), self, "tag_origin" );

		self.inUseBy restorePerks();
		self.inUseBy restoreWeapons();				

		self notify( "deleting" );
		wait ( 1.0 );
		//StopFXOnTag( getFx( "ims_explode_mp" ), self, "tag_origin" );
		//StopFXOnTag( getFx( "ims_smoke_mp" ), self, "tag_origin" );
	}	
	else
	{*/
	PlayFX( getfx( "ims_explode_mp" ), self.origin + ( 0, 0, 10 ) );
	//playFxOnTag( getFx( "ims_explode_mp" ), self, "tag_origin" );
	wait ( 0.5 );
	
	// this handles cases of deletion again, after the above wait().
	//We have to make multiple checks after waits because this pod may have been deleted during the wait (when the player respawns).
	if ( !isDefined( self ) )
		return;
	
	// TODO: get sound for this
	self playSound( "ims_fire" );
	for ( smokeTime = 4; smokeTime > 0; smokeTime -= 0.4 )
	{
		// this handles cases of deletion again, after the wait() in this for-loop.
		//We have to make multiple checks after waits because this pod may have been deleted during the wait (when the player respawns).
		if ( !isDefined( self ) )
			return;
	
		PlayFX( getfx( "ims_smoke_mp" ), self.origin );
		//playFxOnTag( getFx( "ims_smoke_mp" ), self, "tag_origin" );
		wait ( 0.4 );
	}
	self notify( "deleting" );
	//}

	/*
	if ( isDefined( self.objIdFriendly ) )
		_objective_delete( self.objIdFriendly );

	if ( isDefined( self.objIdEnemy ) )
		_objective_delete( self.objIdEnemy );

	if( IsDefined( self.lid1 ) )
		self.lid1 delete();
	if( IsDefined( self.lid2 ) )
		self.lid2 delete();
	if( IsDefined( self.lid3 ) )
		self.lid3 delete();
	if( IsDefined( self.lid4 ) )
		self.lid4 delete();

	if( IsDefined( self.explosive1 ) )
	{
		if( IsDefined( self.explosive1.killCamEnt ) )
			self.explosive1.killCamEnt delete();
		self.explosive1 delete();
	}
	if( IsDefined( self.explosive2 ) )
	{
		if( IsDefined( self.explosive2.killCamEnt ) )
			self.explosive2.killCamEnt delete();
		self.explosive2 delete();
	}
	if( IsDefined( self.explosive3 ) )
	{
		if( IsDefined( self.explosive3.killCamEnt ) )
			self.explosive3.killCamEnt delete();
		self.explosive3 delete();
	}
	if( IsDefined( self.explosive4 ) )
	{
		if( IsDefined( self.explosive4.killCamEnt ) )
			self.explosive4.killCamEnt delete();
		self.explosive4 delete();
	}
	*/

	if (IsDefined(self))
	{
		self delete();
	}
}


/*
///ScriptDocBegin
Name: dropPodBarrelRoll( <rocket> )
Summary: Allows the player to bank while in their drop pod.
Module: orbital
CallOn: a player
MandatoryArg: <rocket> The object that this function banks. The player is linked to this object.
Example: level.player thread dropPodBarrelRoll();
SPMP: MP
///ScriptDocEnd
*/
dropPodBarrelRoll(rocket)
{
	//Attempting a really roundabout way of changing the values in rocket.angles to achieve banking.
	temp0 = 0;
	temp1 = 0;
	temp2 = 0;
	temp_vec = (0, 0, 0);
	
	self endon("death");
	while ( 1 )
	{
		if (!IsDefined(rocket))
		{
			break;
		}
		if (self FragButtonPressed())
		{
			//Hacky
			temp0 = rocket.angles[0];
			temp1 = rocket.angles[1];
			temp2 = rocket.angles[2];
			//temp0 += 40;
			temp1 += 40;
			//temp2 += 20;
			temp_vec = (temp0, temp1, temp2);
			
			rocket.angles = temp_vec;
		}
		if (self SecondaryOffhandButtonPressed())
		{
			//Hacky
			temp0 = rocket.angles[0];
			temp1 = rocket.angles[1];
			temp2 = rocket.angles[2];
			//temp0 -= 40;
			temp1 -= 40;
			//temp2 -= 20;
			temp_vec = (temp0, temp1, temp2);
			
			rocket.angles = temp_vec;
		}
		wait(0.05);
	}
}


/*
///ScriptDocBegin
Name: dropPodProxyMultiplier( )
Summary: Checks all landed drop pods and their proximity to other landed drop pods. When close to other drop pods, a drop pod ticks more team score.
Module: orbital
CallOn: N/A
MandatoryArg: N/A
Example: thread dropPodProxyMultiplier();
SPMP: MP
///ScriptDocEnd
*/
dropPodProxyMultiplier()
{
	while (1)
	{
		foreach (player1 in level.players)
		{
			if (IsDefined(player1.drop_pod))
			{
				foreach (player2 in level.players)
				{
					if (player1.drop_pod != player2.drop_pod)
					{
						if (Distance(player1.drop_pod.origin, player2.drop_pod.origin) < 128)
						{
							//These two landed drop pods are close and should give each other a multiplier.
							return;
						}
					}
				}
			}
		}
		wait(0.05);
	}
}


/*
///ScriptDocBegin
Name: dropPodTrophySystem( )
Summary: Destroys incoming drop pods (rockets) that are flying too close to landed enemy drop pods. Checks landed enemy drop pods. If this drop pod (rocket) is within a given distance, destroy it.
Module: orbital
CallOn: a flying rocket
MandatoryArg: N/A
Example: self thread dropPodTrophySystem();
SPMP: MP
///ScriptDocEnd
*/
dropPodTrophySystem()
{
	self endon("death");
	self.owner endon( "disconnect" );
	self.owner endon ( "joined_team" );
	self.owner endon ( "joined_spectators" );
	
	while ( IsDefined( self ) )
	{
		//print( "\n============\n dropPodTrophySystem:loop players \n" );
		foreach (player in level.players)
		{
			if ( player.team != self.owner.team )
			{
				//print( "\n============\n dropPodTrophySystem: player = " + player.name + "\n" );
				if ( IsDefined( player.drop_pod ) )
				{
					//print( "\n============\n dropPodTrophySystem: begin\n" );
					if ( DistanceSquared( self.origin, player.drop_pod.origin ) < 200000 )
					{
						player.drop_pod thread dropPodTrophyKill( self, player );
						//TODO: NEED VISUALS AND AUDIO FOR THE TROPHY ON THE ENEMY DROP POD GOING OFF
						//This drop pod is close to a landed enemy drop pod; destroy it.
						//self notify("death");
						//Delete the rocket in mid-air.
						//self Delete();
						//Kill the player.
						//player maps\mp\gametypes\_damage::finishPlayerDamageWrapper( self, player, 999999, 0, "MOD_SUICIDE", "orbital_drop_pod_mp", player.origin, player.origin, "none", 0, 0 );
					}
				}
			}
		}
		wait(0.05);
	}
}


dropPodTrophyKill( grenade, owner )
{
	//self endon( "death" );
	//owner endon( "disconnect" );
	//owner endon( "joined_team" );
	//owner endon( "joined_spectators" );
	//print( "\n\n============\n dropPodTrophyKill: begin\n\n" );

	grenade notify( "destroyed" );
	//print( "\n\n============\n dropPodTrophyKill: bullet trace pased\n\n" );
	playFX( level.sentry_fire, self.origin + (0,0,32) , ( grenade.origin - self.origin ), AnglesToUp( self.angles ) );
	self playSound( "trophy_detect_projectile" );
	
	//MagicBullet( "ims_projectile_mp", self.origin + (0, 0, 32), grenade.origin, owner );
	
	// do a little extra if this was a predator missile or reaper missile
	if( ( IsDefined( grenade.classname ) && grenade.classname == "rocket" ) &&
		( IsDefined( grenade.type ) && ( grenade.type == "remote" || grenade.type == "remote_mortar" ) ) )
	{
		if( IsDefined( grenade.type ) && grenade.type == "remote" )
		{
			// show that you destroyed a killstreak and give the streak point
			level thread maps\mp\gametypes\_missions::vehicleKilled( grenade.owner, owner, undefined, owner, undefined, "MOD_EXPLOSIVE", "trophy_mp" );
			level thread teamPlayerCardSplash( "callout_destroyed_predator_missile", owner );
			owner thread maps\mp\gametypes\_rank::giveRankXP( "kill", 100, "trophy_mp", "MOD_EXPLOSIVE" );				
			owner notify( "destroyed_killstreak", "trophy_mp" );
		}

		// play fx and a sound
		if( IsDefined( level.chopper_fx["explode"]["medium"] ) )
			PlayFX( level.chopper_fx["explode"]["medium"], grenade.origin );
		if( IsDefined( level.barrelExpSound ) )
			grenade PlaySound( level.barrelExpSound );
	}

	owner thread projectileExplode( grenade, self );
	//owner maps\mp\gametypes\_missions::processChallenge( "ch_noboomforyou" );

}

projectileExplode( projectile, trophy )
{
	//self endon( "death" );
	//self endon( "disconnect" );
	//self endon( "joined_team" );
	//self endon( "joined_spectators" );
	
	projPosition = projectile.origin;
	projType = projectile.model;
	projAngles = projectile.angles;
	
	if ( projType == "weapon_light_marker" )
	{
		playFX( level.empGrenadeExplode, projPosition, AnglesToForward( projAngles ), AnglesToUp( projAngles ) );
		
		//trophy thread trophyBreak();
		
		projectile delete();
		return;
	}
	//print( "\n\n============\n projectile explode: notifying projectile death\n\n" );
	
	projectile.owner thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( trophy, trophy, 999999, 0, "MOD_SUICIDE", "orbital_drop_pod_mp", projectile.owner.origin, projectile.owner.origin, "none", 0, 0 );
	projectile delete();
	trophy playSound( "trophy_fire" );
	playFX( level.mine_explode, projPosition, AnglesToForward( projAngles ), AnglesToUp( projAngles ) );
	RadiusDamage( projPosition, 128, 105, 10, self, "MOD_EXPLOSIVE", "trophy_mp" );
}


/*
///ScriptDocBegin
Name: trackRocket( <player> )
Summary: while a rocket is alive, update placeholder vectors with the rocket's origin and angles. Use the placeholder vectors as the rocket's last position and orientation.
Module: orbital
CallOn: a flying rocket
MandatoryArg: <player> a player
Example: self thread trackRocket( player );
SPMP: MP
///ScriptDocEnd
*/
trackRocket( player )
{
	//Endon the rocket's death.
	self endon("death");
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );
	while (1)
	{
		player.rocket_position = self.origin;
		player.rocket_angles = self.angles;
		wait(0.05);
	}
}


/*
///ScriptDocBegin
Name: PodFlareTeamUpdater( showEffectFriend, showEffectEnemy, owner )
Summary: determine which flare to show to a player (based on team) and show it to player.
Module: orbital
CallOn: a landed drop pod
MandatoryArg: <showEffectFriend> the effect to show to friendlies.
MandatoryArg: <showEffectEnemy> the effect to show to enemies.
MandatoryArg: <owner> the owner of the drop pod.
Example: player.drop_pod thread PodFlareTeamUpdater(level.spawnGlow["friendly"], level.spawnGlow["enemy"], player);
SPMP: MP
///ScriptDocEnd
*/
PodFlareTeamUpdater( showEffectFriend, showEffectEnemy, owner )
{
	self endon ( "death" );
	owner endon( "disconnect" );
	//owner endon ( "joined_team" );
	//owner endon ( "joined_spectators" );
	
	// PlayFXOnTag fails if run on the same frame the parent entity was created
	//wait ( 0.05 );
	
	//PlayFXOnTag( showEffect, self, "TAG_FX" );
	//angles = self getTagAngles( "tag_fire_fx" );
	
	//The effect to show to friendly players.
	self.fxEntFriendly = SpawnFx( showEffectFriend, self.origin );
	//The effect to show to enemy players.
	self.fxEntEnemy = SpawnFx( showEffectEnemy, self.origin );
	TriggerFx( self.fxEntFriendly );
	TriggerFx( self.fxEntEnemy );

	self thread deletePodFlareFxOnDeath( owner );
	self thread deletePodFlareFxOnDisconnect( owner );
	self thread deletePodFlareFxOnTeamChange( owner );
	
	//drop pod shows it's trophy fx's to players who are dropping in.
	while( 1 )
	{
		//self hide();		//Don't want to hide the drop pod itself.
		self showfxToTeam( self.fxEntFriendly, self.fxEntEnemy, owner, true );
		wait .05;
		//level waittill_either ( "joined_team", "player_spawned" );
	}
}


PodSetupTrophyFX( friendlyFX, enemyFX, owner )
{
	self endon( "death" );
	owner endon( "disconnect" );
	//owner endon ( "joined_team" );
	//owner endon ( "joined_spectators" );
	
	self.trophyFX_friendly = SpawnFx( friendlyFX, self.origin );
	TriggerFx( self.trophyFX_friendly );
	
	self.trophyFX_enemy = SpawnFx( enemyFX, self.origin );
	TriggerFx( self.trophyFX_enemy );
	
	self thread deletePodTrophyFxOnDeath( owner );
	self thread deletePodTrophyFxOnDisconnect( owner );
	self thread deletePodTrophyFXOnTeamChange( owner );
	
	//drop pod shows its trophy fx to players who are dropping in.
	while( 1 )
	{
		self showfxToTeam( self.trophyFX_friendly, self.trophyFx_enemy, owner );
		wait .05;
	}
}


showfxToTeam( friendlyFX, enemyFX, owner, not_on_drop )
{
	friendlyFX Hide();
	enemyFX Hide();
	foreach ( player in level.players )
	{
		if( isDefined( player.isdropping ) || isDefined( not_on_drop ) )
		{	
			if (level.teamBased)
			{
				if ( player.team == owner.team )
				{
					friendlyFX showToPlayer( player );
				}
				else
				{
					enemyFX ShowToPlayer( player );
				}
			}
			else
			{
				if ( player == owner )
				{
					friendlyFX showToPlayer( player );
				}
				else
				{
					enemyFX showToPlayer( player );
				}
			}
		}
	}
}


/*
///ScriptDocBegin
Name: deletePodFlareFxOnDeath()
Summary: wait until the drop pod this function is called on is dead. Then delete its fx entities, fxEntFriendly and fxEntEnemy.
Module: orbital
CallOn: a landed drop pod
MandatoryArg: None
Example: player.drop_pod thread deletePodFlareFxOnDeath();
SPMP: MP
///ScriptDocEnd
*/
deletePodFlareFxOnDeath( owner )
{
	owner endon( "disconnect" );
	//Wait until the drop pod that this function was called on is dead.
	self waittill( "death" );
	
	self deletePodFlare();
}


deletePodFlareFxOnDisconnect( owner )
{
	//Wait until the owner of this drop pod disconnects.
	self endon( "death" );
	owner waittill( "disconnect" );
	
	self deletePodFlare();
}


deletePodFlareFxOnTeamChange( owner )
{
	//Wait until the owner of this drop pod switches teams.
	self endon( "death" );
	owner waittill_any( "joined_team" , "joined_spectators" );
	
	self deletePodFlare();
}


deletePodFlare()
{
	if ( isdefined( self.fxEntFriendly ) )
		self.fxEntFriendly delete();
	
	if ( isdefined( self.fxEntEnemy ) )
		self.fxEntEnemy delete();
}

/*
///ScriptDocBegin
Name: showEnemyDropPods(droppingplayer)
Summary: show headicons on landed enemy drop pods. We only want droppingplayer to see enemy drop pods while he/she is dropping in.
Module: orbital
CallOn: a rocket that is dropping in
MandatoryArg: <droppingplayer> the player who is "riding" the rocket down
Example: rocket thread showEnemyDropPods(player);
SPMP: MP
///ScriptDocEnd
*/
showEnemyDropPodIcons( droppingplayer )
{
	//End when the rocket crashes down and dies.
	self endon("death");
	
	
	foreach (player in level.players)
	{
		//Set head icons for landed enemy drop pods.
		//See _threatdetection.gsc for waypoint_threat_hostile
		if (IsDefined(player.drop_pod) && player.team != droppingplayer.team)
		{
			player.drop_pod maps\mp\_entityheadIcons::setHeadIcon( droppingplayer, "waypoint_threat_hostile", (0, 0, 24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
		}
	}
}


/*
///ScriptDocBegin
Name: destroyEnemyDropPodIcons()
Summary: remove headicons from landed enemy drop pods. We only want droppedplayer to see enemy drop pods while he/she is dropping in.
Module: orbital
CallOn: a player who has just spawned on the ground and shouldn't see anymore enemy headIcons.
MandatoryArg: N/A
Example: player destroyEnemyDropPodIcons();
SPMP: MP
///ScriptDocEnd
*/
destroyEnemyDropPodIcons()		//Borrowed some of this script from _entityheadicons.gsc::setHeadIcon()
{
	foreach (player in level.players)
	{
		if ( IsDefined( player.drop_pod ) )
		{
			if ( IsDefined (player.drop_pod.entityHeadIcons) )
			{
				if ( isDefined( player.drop_pod.entityHeadIcons[ self.guid ] ) )
				{
					player.drop_pod.entityHeadIcons[ self.guid ] destroy();
					player.drop_pod.entityHeadIcons[ self.guid ] = undefined;
				}

				//if ( icon == "" )
				//	return;
		
				// remove from team or we'd have two icons
				//if ( isDefined( player.drop_pod.entityHeadIcons[ self.team ] ) )
				//{
				//	player.drop_pod.entityHeadIcons[ self.team ] destroy();
				//	player.drop_pod.entityHeadIcons[ self.team ] = undefined;
				//}
				
				//Creates the headIcon for a specific player.
				//headIcon = newClientHudElem( self );
				//player.drop_pod.entityHeadIcons[ self.guid ] = headIcon;
			}
		}
	}
}


/*
///ScriptDocBegin
Name: showFriendlyPlayerIcons(droppingplayer)
Summary: show headicons friendly players. We only want droppingplayer to see friendly icons while he/she is dropping in.
Module: orbital
CallOn: a rocket that is dropping in
MandatoryArg: <droppingplayer> the player who is "riding" the rocket down
Example: rocket thread showFriendlyPlayerIcons(player);
SPMP: MP
///ScriptDocEnd
*/
showFriendlyPlayerIcons( droppingplayer )
{
	//End when the rocket crashes down and dies.
	self endon("death");
	
	
	foreach (player in level.players)
	{
		if( player == droppingplayer || IsDefined( player.isdropping ) )
			continue;
		
		//Set head icons for friendly players.
		if (player.team == droppingplayer.team)
		{
			player maps\mp\_entityheadIcons::setHeadIcon( droppingplayer, "ac130_hud_friendly_vehicle_target", (0, 0, 0), 4, 4, undefined, undefined, undefined, undefined, undefined, false );
		}
		else
		{
			player maps\mp\_entityheadIcons::setHeadIcon( droppingplayer, "hud_fofbox_hostile", (0, 0, 0), 4, 4, undefined, undefined, undefined, undefined, undefined, false );
		}
	}
}


/*
///ScriptDocBegin
Name: destroyFriendlyPlayerIcons()
Summary: remove headicons from friendly players. We only want droppedplayer to see enemy drop pods while he/she is dropping in.
Module: orbital
CallOn: a player who has just spawned on the ground and shouldn't see anymore enemy headIcons.
MandatoryArg: N/A
Example: player destroyFriendlyPlayerIcons();
SPMP: MP
///ScriptDocEnd
*/
destroyFriendlyPlayerIcons()		//Borrowed some of this script from _entityheadicons.gsc::setHeadIcon()
{
	foreach (player in level.players)
	{
		if ( IsDefined (player.entityHeadIcons) )
		{
			if ( isDefined( player.entityHeadIcons[ self.guid ] ) )
			{
				player.entityHeadIcons[ self.guid ] destroy();
				player.entityHeadIcons[ self.guid ] = undefined;
			}
		}
	}
}


/*
///ScriptDocBegin
Name: showEnemyDropPodTrophyFx( droppingplayer )
Summary: show trophy system danger zones on landed enemy drop pods. We only want droppingplayer to see enemy drop pod trophy areas while he/she is dropping in.
Module: orbital
CallOn: a rocket that is dropping in
MandatoryArg: <droppingplayer> the player who is "riding" the rocket down
Example: rocket thread showEnemyDropPodTrophyFx(player);
SPMP: MP
///ScriptDocEnd
*/
showDropPodTrophyFx( droppingplayer )
{
	//End when the rocket crashes down and dies.
	self endon("death");
	self endon( "player_drop_pod_spawned" );
	self endon( "player_spawned_at_drop_pod" );

	for ( ;; )
	{
		foreach ( player in level.players )
		{
			if ( IsDefined( player.drop_pod ) )
			{
				if ( IsDefined( player.drop_pod.trophyFX ) )
				{
					//Hide this player's drop pod's trophyFX for everyone.
					player.drop_pod.trophyFX Hide();
				
					//Show Trophy System vfx for landed enemy drop pods to droppingplayer.
					//See _remotemortar.gsc's remoteTargeting( remote ).
					if (level.teamBased)
					{
						if ( player.team != droppingplayer.team )
						{
							player.drop_pod.trophyFX ShowToPlayer( droppingplayer );
						}
					}
					else
					{
						if ( player != droppingplayer )
						{
							player.drop_pod.trophyFX ShowToPlayer( droppingplayer );
						}
					}
				}
			}
			wait(0.05);
		}
	}
}


/*
///ScriptDocBegin
Name: deletePodTrophyFxOnDeath()
Summary: wait until the drop pod this function is called on is dead. Then delete its trophy fx entity, trophyFX.
Module: orbital
CallOn: a landed drop pod
MandatoryArg: None
Example: player.drop_pod thread deletePodTrophyFxOnDeath();
SPMP: MP
///ScriptDocEnd
*/
deletePodTrophyFxOnDeath( owner )
{
	owner endon( "disconnect" );
	//Wait until the drop pod that this function was called on is dead.
	self waittill( "death" );
	
	self deletePodTrophyFX();
}


deletePodTrophyFXOnDisconnect( owner )
{
	self endon( "death" );
	owner waittill( "disconnect" );
	
	self deletePodTrophyFX();
}


deletePodTrophyFXOnTeamChange( owner )
{
	self endon( "death" );
	//owner endon( "disconnect" );
	owner waittill_any( "joined_team" , "joined_spectators" );
	
	self deletePodTrophyFX();
}


deletePodTrophyFX()
{
	if( isdefined( self.trophyFX_friendly ) )
		self.trophyFX_friendly delete();
	
	if( isdefined( self.trophyFx_enemy ) )
		self.trophyFx_enemy delete();
}


/*
///ScriptDocBegin
Name: displayClientString( <text>, <offset> )
Summary: display a string for a specific player
Module: orbital
CallOn: a player
MandatoryArg: <text> the text to display.
MandatoryArg: <offset> the screen offset for the string.
MandatoryArg: <offset> the scale of the text.
Example: player thread displayClientString();
SPMP: MP
///ScriptDocEnd
*/
displayClientString( text, offset, scale )
{
	display = maps\mp\gametypes\_hud_util::createFontString("hudbig", scale);
	display maps\mp\gametypes\_hud_util::setPoint("CENTER", "CENTER", 0, offset);
	display.sort = 1001;
	display.color = (1,1,1);
	display.foreground = false;
	display.hidewheninmenu = true;
	display settext(text);
	
	self waittill("destroy_client_strings");
	display maps\mp\gametypes\_hud_util::destroyElem();
}


/*
///ScriptDocBegin
Name: centerPlayerCamera()
Summary: rotate the player's X viewangle to 0.
Module: orbital
CallOn: a player
MandatoryArg: N/A
Example: player thread centerPlayerCamera();
SPMP: MP
///ScriptDocEnd
*/
centerPlayerCamera()
{
	self endon("death");

	self.angle_diff = self.angles[0] - self.rocket_angles[0];
	if (self.angle_diff == 0)
	{
		//No need to rotate the camera.
		return;
	}
	else if (self.angle_diff > 0)
	{
		while (self.angles[0] > self.rocket_angles[0])
		{
			temp_vec = self GetPlayerAngles();
			angle0 = temp_vec[0] + 1;
			angle1 = temp_vec[1];
			angle2 = temp_vec[2];
			new_temp_vec = (angle0, angle1, angle2);
			self SetPlayerAngles(new_temp_vec);
			wait(0.01);
		}
	}
	else
	{
		while (self.angles[0] < self.rocket_angles[0])
		{
			temp_vec = self GetPlayerAngles();
			angle0 = temp_vec[0] - 1;
			angle1 = temp_vec[1];
			angle2 = temp_vec[2];
			new_temp_vec = (angle0, angle1, angle2);
			self SetPlayerAngles(new_temp_vec);
			wait(0.01);
		}
	}
	return;
}


/*
///ScriptDocBegin
Name: dropPodForceRespawn()
Summary: after a certain amount of time, the player is automatically launched in a new drop pod. This function keeps time.
Module: orbital
CallOn: a player
MandatoryArg: N/A
Example: player thread dropPodForceRespawn();
SPMP: MP
///ScriptDocEnd
*/
dropPodForceRespawn()
{
	self endon("death");
	self endon( "disconnect" );
	self endon ( "joined_team" );
	self endon ( "joined_spectators" );
	self endon( "player_drop_pod_spawned" );
	self endon( "player_spawned_at_drop_pod" );
	self.forcerespawn = false;
	
	if (!IsDefined(self.forcerespawn_timer))
	{
		self.forcerespawn_timer = 15;
	}
	
	while (self.forcerespawn_timer > 0)
	{
		self.forcerespawn_timer--;
		wait(1);
	}
	self.forcerespawn = true;
}
