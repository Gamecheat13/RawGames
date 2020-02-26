#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;

#include maps\mp\zm_transit_utility;

#insert raw\common_scripts\utility.gsh;

#define STOP_CHASE_DIST		( 300 * 300 )

//*****************************************************************************
// THE BUS
//*****************************************************************************

#using_animtree( "zombie_bus" );

busSetup()
{
	self.immediateSpeed	= false;
	self.currentSpeed 	= 0;
	self.targetSpeed 	= 0;
	self.isMoving 		= false;
	self.isStopping 	= false;
	self.inChaseMode	= false;
	self.inChaseModeAttached = false;
	self.gas 			= 100;
	self.accel 			= 10;
	self.decel 			= 30;
	self.radius 		= 88;
	self.height			= 240;
	self.frontDist		= 340;
	self.backDist		= 60; 
	self.floor			= 36;
	self.frontLocal		= ((self.frontDist - (self.radius/2.0)), 0, 0);
	self.backLocal		= ((self.backDist * -1) + (self.radius/2.0), 0, 0);
	self.drivepath      = false;
	self.zone			= "zone_pri";
	self.roadZone       = self.zone;
	self.zombiesInside 	= 0;
	self.zombiesInfront = 0;
	self.zombiesNear	= 0;
	self.numPlayers		= 0;
	self.numPlayersOn	= 0;
	self.numPlayersOnRoof	= 0;
	self.numPlayersInsideBus = 0;
	self.numPlayersNear	= 0;
	self.numAlivePlayersRidingBus = 0;  // alive means not in last stand and not dead 
	self.numAlivePlayersNear = 0; 
	self.numFlatTires	= 0;
	self.doorsClosed 	= true;
	self.doorsDisabledForTime = false;
	self.stalled		= false;
	self.IsSafe			= true;
	self.waitTimeAtDestination   = 0;
	self.graceTimeAtDestination	= 10;
	
	level.zm_mantle_over_40_move_speed_override = ::zm_mantle_over_40_move_speed_override;
	
	self SetMovingPlatformEnabled( true );
	
	self.supportsAnimScripted = true;
	
	self SetVehMaxSpeed(35);

 	self UseAnimTree( #animtree );
 	
 	// Zombies On Bus Death AnimScript Callback
 	//-----------------------------------------
 	maps\mp\zombies\_zm_spawner::register_zombie_death_animscript_callback( ::zombie_in_bus_death_animscript_callback );
	
	// Automaton Driver
	//-----------------
	self maps\mp\zm_transit_automaton::main();
	
	// Bus Systems
	//------------
	maps\mp\zm_transit_cling::initializeCling();
	self maps\mp\zm_transit_openings::main();
	self maps\mp\zm_transit_upgrades::main();
	
	self busFuelTankSetup();
	self busPlowSetup();
	self busLightsSetup();
	self busDoorsSetup();
	//self busHatchSetup();
	self busRoofRailsSetup();
	self busRoofJumpOffPositionsSetup();
	//self busSideLaddersSetup();
	self busPathBlockerSetup();
	self busSetupBounds();
	
	// Bus Audio
	//----------
	self thread bus_audio_setup();
	
	// Bus AnimStates
	//---------------
	level thread init_bus_door_anims();
	
	// Setup Respawn Points
	//---------------------
	self busRespawnPointsSetup();
	
	// Bus Think
	//----------
	self thread busThink();
	
	// Opening Bus Scene
	//------------------
	self thread busOpeningScene();
	
	// Start The Bus Schedule
	//-----------------------
	busSchedule();
	self thread busScheduleThink();
	
	//Adjust speed at bride.
	self thread bus_bridge_speedcontrol();
}

zm_mantle_over_40_move_speed_override()
{
	traverseAlias = "barrier_walk";
	switch ( self.zombie_move_speed )
	{
	case "chase_bus":
		traverseAlias = "barrier_sprint";
		break;
	default:
		assertmsg( "Zombie move speed of '" + self.zombie_move_speed + "' is not supported for mantle_over_40." );
	}

	return traverseAlias;
}

busOpeningScene()
{
	// Start Around Corner Behind Welcome Center
	startNode = GetVehicleNode( "BUS_OPENING", "targetname" );
	self.currentNode = startNode;
	self thread maps\mp\_vehicles::follow_path( startNode );
	self.targetSpeed = 0;
	
	flag_wait( "start_zombie_round_logic" );

	self busStartMoving( 12 );
	self busStartWait();
	
	// Wait Till Arrive At Welcome Center Pull Up
	//self waittill( "pull_up" );
	self waittill( "opening_end_path" );
	
	self busStopMoving();
	
	// Attach On Actual Transit Path
	startNode = GetVehicleNode( "BUS_START", "targetname" );
	self.currentNode = startNode;
	self thread maps\mp\_vehicles::follow_path( startNode );
	
	// Wait For Players To Open Door And Drive Up To Pick Them Up
	flag_wait( "OnPriDoorYar" ); // Flag On Welcome Center Doors
		
	thread automatonSpeak( "scripted", "discover_bus" );
		
	// Notify Automaton He Can Start Spinning His Head
	level.automaton notify( "start_head_think" );
	
	// Kick Off The Bus Schedule
	self notify( "noteworthy", "depot", self.currentNode );
}

busSchedule()
{
	level.busSchedule = busScheduleCreate();
	
	// busScheduleAdd( <stopName>, <isAmbush>, <maxWaitTimeBeforeLeaving>, <busSpeedLeaving>, <gasUsage> )
	
	// WELCOME CENTER
	level.busSchedule busScheduleAdd( "depot",			false,	RandomIntRange( 40, 180 ),	19,	15 );
	
	// TUNNEL
	level.busSchedule busScheduleAdd( "tunnel",			true,		10,	27,	5 );
	
	// DINER
	level.busSchedule busScheduleAdd( "diner",			false,	RandomIntRange( 40, 180 ),	18,	20 );
	
	// FOREST
	level.busSchedule busScheduleAdd( "forest",			true,		10,	18,	5 );
	
	// FARM
	level.busSchedule busScheduleAdd( "farm",				false,	RandomIntRange( 40, 180 ),	26,	25 );
	
	// CORNFIELDS
	level.busSchedule busScheduleAdd( "cornfields",	true,		10,	23,	10 );
	
	// POWER FACTORY
	level.busSchedule busScheduleAdd( "power",			false,	RandomIntRange( 40, 180 ),	19,	15 );
	
	// POWER TO TOWN
	level.busSchedule busScheduleAdd( "power2town",	true,		10,	26,	5 );
	
	// TOWN
	level.busSchedule busScheduleAdd( "town",				false,	RandomIntRange( 40, 180 ),	18,	20 );
	
	// BRIDGE
	level.busSchedule busScheduleAdd( "bridge",			true,		10,	23,	10 );
}

busScheduleThink()
{
	self endon( "death" );

	while ( true )
	{
		self waittill( "noteworthy", noteworthy, noteworthyNode ); // Sent from _vehicles.gsc

		// Local Variables
		//----------------
		zoneIsEmpty = true;
		nobodyNearby = true;
		isSomeoneChasing = false;
		shouldRemoveGas = false;
		destinationIndex = level.busSchedule busScheduleGetDestinationIndex( noteworthy );

		// Check Is Valid Destination
		//---------------------------
		if ( !IsDefined( destinationIndex ) || !IsDefined( noteworthyNode ) )
		{
			/#
			if ( IsDefined( noteworthy ) )
			{
				PrintLn( "^2Bus Debug: Not A Valid Destination (" + noteworthy + ")" );
			}
			else
			{
				PrintLn( "^2Bus Debug: Not A Valid Destination" );
			}
			#/
			continue;
		}
		
		// Update Bus Attributes
		//----------------------
		self.destinationIndex = destinationIndex;
		self.waitTimeAtDestination = level.busSchedule busScheduleGetMaxWaitTimeBeforeLeaving( self.destinationIndex );
		self.currentNode = noteworthyNode;
		targetSpeed = level.busSchedule busScheduleGetBusSpeedLeaving( self.destinationIndex );
		
		// See If Anyone Is In The Zone
		//-----------------------------
		foreach ( zone in level.zones )
		{
			if ( !IsDefined( zone.volumes ) || zone.volumes.size == 0 )
			{
				continue;
			}
			
			zoneName = zone.volumes[ 0 ].targetname;
			
			if ( self maps\mp\zombies\_zm_zonemgr::entity_in_zone( zoneName ) )
			{
			/#	PrintLn( "^2Bus Debug: Bus Is Touching Zone (" + zoneName + ")" );	#/
				
				// Update Bus Attribute
				//---------------------
				self.zone = zoneName;
				
				playersInZone = maps\mp\zombies\_zm_zonemgr::get_players_in_zone( zoneName );
				
				if ( ( IsInt( playersInZone ) && playersInZone != 0 ) || playersInZone )
				{
				/#	PrintLn( "^2Bus Debug: No Player(s) Are In The Same Zone As Bus (" + zoneName + ")" );	#/
					
					zoneIsEmpty = false;
				}
				else
				{
				/#	PrintLn( "^2Bus Debug: Player(s) Are In The Same Zone As Bus (" + zoneName + ")" );	#/
				}
			}
		}
		
		// See If Anyone Is Nearby
		//------------------------
		players = GET_PLAYERS();
		foreach ( player in players )
		{
			if ( DistanceSquared( player.origin, self.origin ) < ( 2048 * 2048 ) )
			{
				nobodyNearby = false;
			}
		}
		
		// See If Anyone Is Chasing It
		//----------------------------
		players = GET_PLAYERS();
		foreach ( player in players )
		{
			if ( is_true( isSomeoneChasing ) )
			{
				continue;
			}
			
			// Can See It, Assume Chasing
			//---------------------------
			if ( SightTracePassed( player GetEye(), self.origin + ( 0, 0, 256 ), false, undefined ) )
			{
				isSomeoneChasing = true;
			}
		}
		
		// See If Anyone Is In Previous Zone, Assume Chasing
		//--------------------------------------------------
		if ( is_false( isSomeoneChasing ) )
		{
			zonesToCheck = [];
			
			switch( self.zone )
			{
				case "zone_station_ext": // Welcome Center
				{
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_1";
					zonesToCheck[ zonesToCheck.size ] = "zone_amb_bridge";
				} break;
				case "zone_gas": // Gas Station
				{
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_2";
					zonesToCheck[ zonesToCheck.size ] = "zone_amb_tunnel";
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_3";
				} break;
				case "zone_far": // Farm
				{
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_4";
					zonesToCheck[ zonesToCheck.size ] = "zone_amb_forest";
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_5";
				} break;
				case "zone_pow": // Power Station
				{
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_6";
					zonesToCheck[ zonesToCheck.size ] = "zone_amb_cornfield";
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_7";
					zonesToCheck[ zonesToCheck.size ] = "zone_pow_ext1";
				} break;
				case "zone_tow": // Town
				{
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_8";
					zonesToCheck[ zonesToCheck.size ] = "zone_amb_power2town";
					zonesToCheck[ zonesToCheck.size ] = "zone_trans_9";
				} break;
			}
			
			foreach ( zone in zonesToCheck )
			{
				if ( is_true( isSomeoneChasing ) )
				{
					continue;
				}
				
				if ( maps\mp\zombies\_zm_zonemgr::player_in_zone( zone ) )
				{
				/#	PrintLn( "^2Bus Debug: Someone Is In A Previous Nearby Zone, Assume Chasing Bus." );	#/
					
					isSomeoneChasing = true;
				}
			}
		}
		
		// Gas Usage
		//----------
		if ( is_true( shouldRemoveGas ) )
		{
			self busGasRemove( level.busSchedule busScheduleGetBusGasUsage( self.destinationIndex ) );
		}
		
		// If No One In Zone Or Nearby Don't Stop
		//---------------------------------------
		if ( is_true( zoneIsEmpty ) && is_true( nobodyNearby ) && is_false ( isSomeoneChasing ) )
		{
			/#
			if ( is_true( zoneIsEmpty ) )
			{
				PrintLn( "^2Bus Debug: Bus Won't Consider Stopping Since Zone Is Empty." );
			}
			else
			{
				PrintLn( "^2Bus Debug: Bus Won't Consider Stopping Since Nobody Is Nearby." );
			}
			#/
			
			// Update The Bus Speed From The Schedule
			self busStartMoving( targetSpeed );
			
			continue;
		}
		else
		{
			/#
			if ( is_true( isSomeoneChasing ) )
			{
				PrintLn( "^2Bus Debug: Bus Will Consider Stopping Due To Someone Chasing It." );
			}
			#/
		}

		// Ambush
		//-------
		if ( level.busSchedule busScheduleGetIsAmbushStop( self.destinationIndex ) )
		{
		/#	PrintLn( "^2Bus Debug: Arrived At Ambush Point." );	#/
			
			if ( maps\mp\zm_transit_ambush::shouldStartAmbushRound() && self.numPlayersInsideBus != 0 )
			{
			/#	PrintLn( "^2Bus Debug: Ambush Triggering" );	#/
				
				self busStopMoving( true );

				level.NML_ZONE_NAME = "zone_amb_" + noteworthy;

				thread maps\mp\zm_transit_ambush::ambushStartRound();

				thread automatonSpeak( "inform", "out_of_gas" );

				flag_waitopen( "ambush_round" );
				
				shouldRemoveGas = true;

				thread automatonSpeak( "inform", "refueled_gas" );
			}
			else
			{
				// Going Over Ambush Point But Not A Breakdown, Skip Rest Of Script Below
				//-----------------------------------------------------------------------
			/#	PrintLn( "^2Bus Debug: Over Ambush Point But No BreakDown Triggered." );	#/
				
				continue;
			}
		}
		// Main Destination
		//-----------------
		else
		{
		/#	PrintLn( "^2Bus Debug: Arrived At Destination" );	#/

			shouldRemoveGas = true;

			thread automatonSpeak( "inform", "arriving" );

			//DCS: stop bus exactly at stop position for blockers.
			if(noteworthy == "diner" || noteworthy == "town" || noteworthy == "power")
			{
				//self.currentNode
				self busStopMoving(true);
			}
			else
			{	
				self busStopMoving();
			}
			
			// Depart Early Check
			//-------------------
			self thread busScheduleDepartEarly();
			
		}

		// Wait At Destination A Bit
		//--------------------------
		waitTimeAtDestination = self.waitTimeAtDestination;
		
		/#
		if ( GetDvarInt( "zombie_bus_wait_time" ) != 0 )
		{
			PrintLn( "^2Bus Debug: Using custom wait time of: " + GetDvarInt( "zombie_bus_wait_time" ) + " seconds." );
			waitTimeAtDestination = GetDvarInt( "zombie_bus_wait_time" );
		}
		
		if ( GetDvarInt( "zombie_cheat" ) > 0 )
		{
			thread busShowLeavingHud( waitTimeAtDestination );
		}
		#/
		
		self waittill_any_timeout( waitTimeAtDestination, "depart_early" );
		
		self notify( "ready_to_depart" );
		
		self thread busLightsFlash();

		thread automatonSpeak( "inform", "leaving_warning" );

		// Grace Period To Get On Bus
		//---------------------------
		self thread play_bus_audio( "grace" );
		
		wait ( self.graceTimeAtDestination );

		thread automatonSpeak( "inform", "leaving" );

		// Update Bus Attributes
		//----------------------
		self.accel = 1;
		self busStartMoving( targetSpeed );
		
		self notify( "departing" );
		
		self clearclientflag( level._CLIENTFLAG_VEHICLE_BUS_FLASHING_LIGHTS );
	}
}

busScheduleDepartEarly()
{
	self endon( "ready_to_depart" );

	wait ( 15 ); // Enforced Wait Time

	triggerBusWait = false;

	while ( true )
	{
		players = GET_PLAYERS();

		nearbyPlayers = 0;
		readyToLeavePlayers = 0;

		foreach ( player in players )
		{
			// LastStand Players Shouldn't Hold Up Bus
			//----------------------------------------
			if ( !is_player_valid( player ) )
			{
				continue;
			}
			
			if ( DistanceSquared( self.origin, player.origin ) < ( 512 * 512 ) )
			{
				nearbyPlayers++;

				if ( player.isOnBus )
				{
					readyToLeavePlayers++;
				}
			}
		}

		if ( ( readyToLeavePlayers != 0 ) && ( readyToLeavePlayers == nearbyPlayers ) )
		{
			if ( !triggerBusWait )
			{
				wait ( 5 ); // Stay On Bus For Five Seconds
				
				// Can Trigger Bus To Leave Now, But Lets Check Again Make Sure Everyone Is Still On
				//----------------------------------------------------------------------------------
					
				triggerBusWait = true;
			}
			else
			{
				// Everyone Is Still On Board, Lets Depart
				//----------------------------------------
				
				self notify( "depart_early" );
				
				/#
				if ( IsDefined( level.bus_leave_hud ) )
				{
					level.bus_leave_hud.alpha = 0;
				}
				#/

				return;
			}
		}
		else if ( triggerBusWait )
		{
			triggerBusWait = false;
		}

		wait ( 1 );
	}
}

busScheduleCreate()
{
	schedule = SpawnStruct(); 
	schedule.destinations = []; 
	return( schedule ); 
}

busScheduleAdd( stopName, isAmbush, maxWaitTimeBeforeLeaving, busSpeedLeaving, gasUsage )
{
	Assert( IsDefined( stopName ) );
	Assert( IsDefined( isAmbush ) );
	Assert( IsDefined( maxWaitTimeBeforeLeaving ) );
	Assert( IsDefined( busSpeedLeaving ) );
		
	destinationIndex = self.destinations.size;
	
	self.destinations[ destinationIndex ] = SpawnStruct(); 
	self.destinations[ destinationIndex ].name = stopName; 
	self.destinations[ destinationIndex ].isAmbush = isAmbush; 
	self.destinations[ destinationIndex ].maxWaitTimeBeforeLeaving = maxWaitTimeBeforeLeaving; 
	self.destinations[ destinationIndex ].busSpeedLeaving = busSpeedLeaving;
	self.destinations[ destinationIndex ].gasUsage = gasUsage;
}

busScheduleGetDestinationIndex( stopName )
{
	foreach ( index, stop in self.destinations )
	{
		if ( stop.name != stopName )
		{
			continue; 
		}
			
		return( index );
	}
	
	return( undefined );
}

busScheduleGetStopName( destinationIndex )
{
	return ( self.destinations[ destinationIndex ].name );
}

busScheduleGetIsAmbushStop( destinationIndex )
{
	return ( self.destinations[ destinationIndex ].isAmbush );
}

busScheduleGetMaxWaitTimeBeforeLeaving( destinationIndex )
{
	return ( self.destinations[ destinationIndex ].maxWaitTimeBeforeLeaving );
}

busScheduleGetBusSpeedLeaving( destinationIndex )
{
	return ( self.destinations[ destinationIndex ].busSpeedLeaving );
}

busScheduleGetBusGasUsage( destinationIndex )
{
	return ( self.destinations[ destinationIndex ].gasUsage );
}

set_task_power()
{
	level.task_string = &"ZOMBIE_NEED_POWER";
	flag_wait("power_on");

	self notify("task_cleared");
	level.task_string = undefined;

}	
//*****************************************************************************

busMarkZombieNearBus(zombie)
{
	zombie.nearBus= true;
}

busMarkZombieNotNearBus(zombie)
{
	zombie.nearBus = false;
}


zombie_in_bus_death_animscript_callback()
{
	// Free Up The Opening For Any Other Zombies
	//------------------------------------------
	if ( IsDefined( self ) && IsDefined( self.opening ) )
	{
		self.opening.zombie = undefined;
	}
	
	// If On Bus, Player Gib FX To Cover Up Deleting AI
	//-------------------------------------------------
	if( IsDefined( self ) && is_true( self.isOnBus ) )
	{
		// Regster Scoring Since We Are Deleting Them Before ZM_Death.gsc AnimScript Gets Called
		//--------------------------------------------------------------------------------------
		level maps\mp\zombies\_zm_spawner::zombie_death_points( self.origin, self.damagemod, self.damagelocation, self.attacker, self );
		
		if( IsDefined( level._effect[ "zomb_gib" ] ) )
		{
			PlayFX( level._effect[ "zomb_gib" ], self GetTagOrigin( "J_SpineLower" ) );
		}
		
		self ghost();		
		self delay_thread( 1, ::self_delete );
		
		return true;
	}
	
	return false;
}

busUpdateNearZombies()
{
	zombie_front_dist		= 1200.0;
	zombie_side_dist		= self.radius + 50.0;
	zombie_inside_dist		= 240.0;
	zombie_plow_dist		= 340.0;
	
	self.zombiesNear = 0;
	self.zombiesInside = 0;
	self.zombiesInfront = 0;
	self.inChaseMode = false;
	self.inChaseModeAttached = false;
	
	zombies = GetAiSpeciesArray( "axis", "all" );
	if ( !IsDefined( zombies ) || (zombies.size==0) )
	{
		return;
	}
	
	
	forward_dir 		= AnglesToForward(self.angles);
	forward_proj		= VectorScale(forward_dir, zombie_front_dist);
	forward_pos			= self.origin + forward_proj;
	backward_proj		= VectorScale(forward_dir, zombie_inside_dist * -1.0);
	backward_pos		= self.origin + backward_proj;
	
	bus_front_dist 	= 225.0;
	bus_back_dist 	= 235.0;
	bus_width 		= 120.0;
	
	level.boss_teleport_front_pos 	= self.origin + forward_dir * bus_front_dist;
	level.boss_teleport_front_angles= self.angles;
	level.boss_teleport_back_pos 	= self.origin - forward_dir * bus_back_dist;
	level.boss_teleport_width 		= bus_width;
	level.boss_teleport_active 		= self.isMoving;
	/#
	if (GetDvarInt("zombie_bus_debug_near") > 0)
	{
		side_dir 		= AnglesToForward(self.angles + (0,90,0));
		side_proj		= VectorScale(side_dir, zombie_side_dist);

		inside_pos		= self.origin + VectorScale(forward_dir, zombie_inside_dist);
		plow_pos		= self.origin + VectorScale(forward_dir, zombie_plow_dist);
			
		line(backward_pos, 			forward_pos, 			(1,1,1), 1, 0, 2);
		line(inside_pos-side_proj, 	inside_pos+side_proj, 	(1,1,1), 1, 0, 2);
		line(plow_pos-side_proj, 	plow_pos+side_proj, 	(1,1,1), 1, 0, 2);
	}
	#/
	
	for (i = 0; i < zombies.size; i++)
	{
		if ( !IsDefined( zombies[i] ) )
		{
			continue;
		}
		
		zombie 					= zombies[i];
		zombie_origin			= zombie.origin;
		zombie_origin_proj 		= PointOnSegmentNearestToPoint( backward_pos, forward_pos, zombie_origin );
		zombie_origin_proj_dist	= Distance2D( zombie_origin_proj, zombie_origin );
		zombie_origin_self_dist	= Distance2D( zombie_origin_proj, self.origin );
		zombie_origin_dist 		= Distance2D( zombie_origin, self.origin );
		zombie_origin_dir 		= zombie_origin - zombie_origin_proj;
		zombie_origin_dir 		+= (0,0, zombie_origin_dir[2] * -1.0);	// remove z delta
		zombie_origin_dir 		= vectornormalize(zombie_origin_dir);

		
		if (Distance2D(zombie_origin, self.origin) < 4000.0)
		{
			self.zombiesNear ++;
		}
		
		// Is This Zombie Near The Bus? (within 100 units of this forward projecte line)
		//-------------------------------------------------------------------------------
		if (zombie_origin_proj_dist > zombie_side_dist)
		{
			busMarkZombieNotNearBus( zombie );
		}
		else
		{
			busMarkZombieNearBus( zombie );
		}
		
		// If So, Is The Zombie Actually Inside, Or Just Out In Front?
		//-------------------------------------------------------------
		if (IsDefined(zombie.isOnBus) && zombie.isOnBus)
		{
			self.zombiesInside ++;
		}
		else if (zombie.nearBus)
		{
			self.zombiesInfront ++;
		}
		
		
		// Begin / End Chase Mode
		//------------------------
		if (IsDefined(zombie.isBoss) && IsDefined(zombie.in_active_mode) && zombie.in_active_mode && zombie_origin_dist<3000.0 && self.isMoving && self.numPlayersOn>0)
		{
			self.inChaseMode = true;
			
			if( IsDefined( zombie.isOnBus ) && zombie.isOnBus )
			{
				self.inChaseModeAttached = true;
			}
		}
				
		// Zombie Killed By Plow
		//----------------------
		if ( self.isMoving &&
				self GetSpeedMPH() > 5 &&
				is_true( self.upgrades[ "Plow" ].installed )
				)
		{
			//* PrintLn( "^2Transit Debug: Plow is installed, checking if zombie is touching it." );
			
			if ( IsDefined( self.plowTrigger ) && zombie IsTouching( self.plowTrigger ) )
			{
			/#	PrintLn( "^2Transit Debug: Plow killing zombie." );	#/
				
				self thread busPlowKillZombie( zombie );
				
				// Zombie Is Dead, Skip Script Below
				//----------------------------------
				continue;
			}
		}

	    enemyOnBus = IsDefined(zombie.enemy) && IsDefined(zombie.enemy.isOnBus) && zombie.enemy.isOnBus;
		// if the bus is moving, make sure we are at least running
		if ( enemyOnBus && IsDefined(zombie.isOnBus) && !zombie.isOnBus && zombie.has_legs && self.isMoving && IsDefined(zombie.zombie_move_speed) && zombie.zombie_move_speed == "walk" && IsDefined(zombie.animname) )
		{
			zombie set_zombie_run_cycle( "run" );
			zombie.was_walking = true;
		}

		// return the zombies to a walk if they get onto the bus and we've forced them to run to the bus
		if ( IsDefined(zombie.isOnBus) && zombie.isOnBus && IsDefined(zombie.was_walking) && zombie.was_walking && zombie.zombie_move_speed != "walk" && IsDefined(zombie.animname) )
		{
			zombie set_zombie_run_cycle("walk");
			zombie.was_walking = false;
		}

		
		// Debug Graphics
		//----------------
		/#
		if (GetDvarInt("zombie_bus_debug_near") > 0)
		{
			if (!zombie.nearBus)
			{
				edge_pos = zombie_origin_proj + VectorScale(zombie_origin_dir, zombie_side_dist);
				line(zombie_origin_proj, edge_pos, (1,0,0), 1, 0, 2);			// RED = too far to the side
			}
			else if (IsDefined(zombie.inOnBus))
			{
				line(zombie_origin_proj, zombie_origin, (0,1,0), 1, 0, 2);		// GREEN = inside
			}
			else
			{
				line(zombie_origin_proj, zombie_origin, (0,0,1), 1, 0, 2);		// BLUE = in front
			}
		}	
		#/
	}	
}

plowHudFade(text)
{
	level endon("plowHudUpdate");
	fadeIn = .1;
	fadeOut = 3;
	level.hudBusCount FadeOverTime(fadeIn);
	level.hudBusCount.alpha = 1.0;
	level.hudBusCount SetText( text );
	wait(fadeIn);
	level.hudBusCount FadeOverTime(3.0);
	level.hudBusCount.alpha = 0.0;
}

busUpdateSpeed()
{
	// Grab Speed Bus Wants To Go
	//---------------------------
	targetSpeed = self.targetSpeed;
	
	// Cap To Zero
	//------------
	if ( is_false( self.isMoving ) )
	{
		targetSpeed = 0;
	}
	if ( is_true( self.forceStop ) )
	{
		targetSpeed = 0;
	}
	if ( is_true( self.stalled ) )
	{
		targetSpeed = 0;
	}
	if ( is_true( self.disabled_by_emp ) )
	{
		targetSpeed = 0;
	}
	if ( targetSpeed < 0 )
	{
		targetSpeed = 0;
	}

	// Set New Speed
	//--------------
	if ( self.currentSpeed != targetSpeed )
	{
		self.currentSpeed = targetSpeed;
		
		if ( is_true( self.immediateSpeed  ) )
		{
			self SetSpeedImmediate( targetSpeed, self.accel, self.decel );
			
			self.immediateSpeed = undefined; // Reset
		}
		else
		{
			// Stopping Bus
			//-------------
			if ( targetSpeed == 0 )
			{				
				self SetSpeed( 0, 30, 30 );
			}
			// Moving Bus
			//-----------
			else
			{				
				self SetSpeed( targetSpeed, self.accel, self.decel );
			}
		}
	}

	// Debug Speed Print
	//------------------
	/#
	if ( GetDvarInt( "zombie_bus_debug_speed" ) > 0 )
	{
		msgOrigin		= self localtoworldcoords( ( 0, 0, 100 ) );
		msgText			= "speed " + self GetSpeedMPH();
		Print3D( msgOrigin, msgText, ( 1, 1, 1 ), 1, 0.5, 2 );
	}
	#/
}

bus_disabled_by_emp( disable_time )
{
	// probably want some kind of intro/outro FX here
	self thread play_bus_audio( "emp" );
	self.disabled_by_emp = true;
	self busLightsDisableAll();
	wait disable_time-2;
	self busLightsEnableAll();
	wait 2;
	self thread play_bus_audio( "leaving" );
	self.disabled_by_emp = false;
}


busIsPlayerInside(player)
{
	// if the player is clinging, consider them in the bus
	if ( player maps\mp\zm_transit_cling::playerIsClingingToBus() )
	{
		return true;
	}
	
	//Is the player is on the turret
//	if( player maps\mp\zm_transit_upgrades::playerIsOnTurret() )
//	{
//		return true;
//	}

	
	playerPos 		= player.origin;
	playerPosInBus 	= PointOnSegmentNearestToPoint(self.frontWorld, self.backWorld, playerPos);
	playerPosZDelta = playerPos[2] - playerPosInBus[2];
	
	playerPosDist2 	= distance2dsquared(playerPos, playerPosInBus);
	if (playerPosDist2 > (self.radius * self.radius))
	{
		return false;
	}
	
	return true;	
}

busUpdatePlayers()
{
	self.numPlayers = 0;
	self.numPlayersOn = 0;
	self.numPlayersOnRoof = 0;
	self.numPlayersInsideBus = 0;
	self.numPlayersNear = 0;
	self.numAlivePlayersRidingBus = 0;
	self.numAlivePlayersNear = 0;

	self.frontWorld	= self localtoworldcoords(self.frontLocal);
	self.backWorld	= self localtoworldcoords(self.backLocal);
	self.forward = VectorNormalize(self.frontWorld - self.backWorld);
	self.right = VectorCross(self.forward, (0,0,1));

	//Debug Graphics - Remove Soon Please
	//------------------------------------
	/#
	if (false)
	{
		line(self.frontWorld + (0,0,self.floor), self.backWorld + (0,0,self.floor), (1,1,1), 1, 0, 4);
		line(self.frontWorld + (0,0,self.floor), self.frontWorld + (0,0,self.height), (1,1,1), 1, 0, 4);
		circle(self.backWorld + (0,0,self.floor), self.radius, (1,1,1), false, true, 4);
		circle(self.frontWorld + (0,0,self.floor), self.radius, (1,1,1), false, true, 4);
	}
	#/
	//------------------------------------
	
	players = GET_PLAYERS();
	for ( playerIndex = 0; playerIndex < players.size; playerIndex++ )
	{
		player = players[playerIndex];
		if (!IsAlive(player))
		{
			continue;
		}

		inLastStand = player maps\mp\zombies\_zm_laststand::player_is_in_laststand();

		self.numPlayers ++;
		
		if ( Distance2D(player.origin, self.origin) < 1700 )
		{
			self.numPlayersNear ++;
			if ( !inLastStand && IsAlive(player) ) 
			{
				self.numAlivePlayersNear++;
			}
		}
		
		playerIsInBus = self busIsPlayerInside(player);
		if ( playerIsInBus )
		{
			self.numPlayersOn ++;

			if ( !inLastStand && IsAlive(player) ) 
			{
				self.numAlivePlayersRidingBus++;
			}
		}
		
		
		// Did The Player Just Board The Bus?
		//------------------------------------
		if ( playerIsInBus && IsDefined( player.isOnBus ) && !player.isOnBus )
		{
			bbprint( "zombie_events", "category %s type %s round %d playername %s", "BUS", "player_enter", level.round_number, player.name );
				
			player thread bus_audio_interior_loop( self );
			player clientnotify( "OBS" );	
			
			//player AllowJump( false );
			player SetClientPlayerPushAmount( 0 );
			//player setclientplayersteponactors( 0 );
			player AllowSprint( false );
			player AllowProne( false );

			isDivingToProne = ( player getStance() == "prone" );
			if ( isDivingToProne )
			{
				player thread playerDelayTurnOffDiveToProne();
			}
			else
			{
				//player setClientDvar("dtp", false);
			}
			
			if ( RandomInt( 100 ) > 80 ) // 20% Chance
			{
				thread automatonSpeak( "convo", "player_enter" );
			}
		}

		
		// Did The Player Just Leave The Bus?
		//------------------------------------
		if ( !playerIsInBus && IsDefined( player.isOnBus ) && player.isOnBus )
		{
			bbprint( "zombie_events", "category %s type %s round %d playername %s", "BUS", "player_exit", level.round_number, player.name );
				
			//player AllowJump( true );
			player SetClientPlayerPushAmount( 1 );
			//player setclientplayersteponactors( 1 );
			player AllowSprint( true );
			player AllowProne( true );

			//player setClientDvar("dtp", true);
			player notify("left bus");
			player clientnotify( "LBS" );	

			
			if ( RandomInt( 100 ) > 80 ) // 20% Chance
			{
				thread automatonSpeak( "convo", "player_leave" );
			}
		}
		
		player.isOnBus = playerIsInBus;	
		player.isOnBusRoof = player _playerIsOnRoof();
		
		if ( player.isOnBusRoof )
		{
			self.numPlayersOnRoof ++;
		}
		else if( player.isOnBus )
		{
			self.numPlayersInsideBus ++;
		}
	}

	_updatePlayersInSafeArea();
	//_updatePlayersInHubs();
}

// returns true if the player is considered to be on the roof
_playerIsOnRoof()
{
	if ( !self.isOnBus )
	{
		return false;
	}
	
	if ( isDefined( self.onBusTurret) && self.onBusTurret )
	{
		return true;
	}
	
	return self.origin[2] > level.the_bus.origin[2] + 120.0;
}

_updatePlayersInSafeArea()
{
	players = Get_Players();

	if ( !IsDefined(level._safeAreaCacheValid) || !level._safeAreaCacheValid )
	{
		level.playable_areas	= GetEntArray("player_volume", "script_noteworthy");
		level.nogas_areas 		= GetEntArray("no_gas", "targetname");
		level.ambush_areas 		= GetEntArray("ambush_volume","script_noteworthy");
		level._safeAreaCacheVaild = true;
	}

	for ( p = 0; p < players.size; p++ )
	{
		players[p].inSafeArea = _isPlayerInSafeArea( players[p] );

		players[p] _playerCheckPoison();
	}
}

_isPlayerInSafeArea( player )
{
	// check if player is on bus first, as it's cheaper than iterating all zones
	if( IsDefined( player.isOnBus ) && player.isOnBus )
	{
		return level.the_bus.isSafe;
	}
	
	if( player _playerTouchingSafeArea(level.playable_areas) ) 
	{
		return true;
	}
	
	if( player _playerTouchingSafeArea(level.nogas_areas) ) 
	{
		return true;
	}
	
	if ( flag("ambush_safe_area_active") )
	{
		return ( player _playerTouchingSafeArea(level.ambush_areas) );
	}
	
	return false;
}

// self == player
_playerTouchingSafeArea(areas)
{
	for ( i = 0; i < areas.size; i++ )
	{
		touching = self IsTouching(areas[i]);
		if ( touching )
		{
			return true;
		}
	}

	return false;
}

//
// self == player
//
_playerCheckPoison()
{

	if (!IsAlive(self) || self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
	{
		return;
	}
	if (IsDefined(self.poisoned) && self.poisoned)
	{
		return; // already poisoned
	}
	canBePoisoned = self playerCanBePoisoned();
	if (!canBePoisoned)
	{
		return;	// in god mode or noclip or something
	}
	if (!IsDefined(self.inSafeArea) || self.inSafeArea)
	{
		return;	// in a safe area
	}
			
	self thread _playerPoison();

}

// self == player
playerCanBePoisoned()
{
	// don't let us get poisoned if we are in god, noclip, or ufo
	god_mode = IsGodMode(self);
	free_move = self isinmovemode("ufo", "noclip");
	zombie_cheat_num = GetDvarInt( "zombie_cheat" );
	is_invunerable = (zombie_cheat_num == 1 || zombie_cheat_num == 2 || zombie_cheat_num == 3);
	return !god_mode && !IsDefined(free_move) && !is_invunerable;
}

// self == player
_playerPoison()
{
	self.poisoned = true;
	self StartPoisoning();
	self playsound("evt_gas_cough");
	wait(1);
	
	damage = 15.0;
	while(1)
	{
		// End: In Last Stand
		//--------------------
		if (self maps\mp\zombies\_zm_laststand::player_is_in_laststand() || !IsAlive(self))
		{
			//self stopsound("evt_gas_cough");
			//self playsound("evt_gas_death");
			self StopPoisoning();
			self.poisoned = false;
			return;
		}		
		
		canBePoisoned = self playerCanBePoisoned();

		// End: In Safe Area
		//-------------------
		if(self.inSafeArea || !canBePoisoned)
		{
			self StopPoisoning();
			self.poisoned = false;
			return;
		}
				
		if (RandomFloat(100.0) < 60.0)
		{
			//self playsound("evt_gas_cough");
		}
		else
		{
			//self playsound("chr_breathing_heartbeat");
		}
		self dodamage(damage,self.origin);
		damage += 1;
		wait(1);
	}
}

///////////////////////////////////////////////////////////////////////////////////////

_updatePlayersInHubs()
{
	players = Get_Players();
	hubs = GetEntArray("bus_hub", "script_noteworthy");

	for ( h = 0; h < hubs.size; h++ )
	{
		hubs[h].active = false;
		for ( p = 0; p < players.size && !hubs[h].active; p++ ) 
		{
			hubs[h].active = players[p] IsTouching(hubs[h]);
		}
	}
}


// let the player finish the dive to prone before turning it off
playerDelayTurnOffDiveToProne()
{
	self endon( "left bus" );
	wait(1.5);
	//self setClientDvar("dtp", false);
}

busGivePowerup( location )
{
	currentZone = level.zones[self.zone];
	if (IsDefined(currentZone.target2))
	{
		spawnDestEnt = GetEnt(currentZone.target2, "targetname");
		if (IsDefined(spawnDestEnt))
		{
			iPrintLnBold("Max Ammo Awareded!  Find it in the level.");
			level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( "full_ammo", spawnDestEnt.origin );
			level.powerup_drop_count = 0;
		}
	}
}

busRespawnPointsSetup()
{
	//spawn_groups = GetStructArray("player_respawn_point", "targetname");
	spawn_groups = maps\mp\gametypes\_zm_gametype::get_player_spawns_for_gametype();
	
	for( i = 0; i< spawn_groups.size; i++)
	{
		if (spawn_groups[i].script_noteworthy == "zone_bus")
		{
			//spawn_groups[i].locked = true;
			spawn_groups[i].offset = self worldtolocalcoords(spawn_groups[i].origin);
					
			spawn_points = GetStructArray(spawn_groups[i].target, "targetname");
			for( j = 0; j < spawn_points.size; j++ )
			{
				spawn_points[j].offset = self worldtolocalcoords(spawn_points[j].origin);
			}	
		}
	}
}

busUpdateRespawnPoints()
{
	//spawn_groups = GetStructArray("player_respawn_point", "targetname");
	spawn_groups = maps\mp\gametypes\_zm_gametype::get_player_spawns_for_gametype();

	for( i = 0; i< spawn_groups.size; i++)
	{
		if (spawn_groups[i].script_noteworthy == "zone_bus")
		{
			spawn_groups[i].origin = self LocalToWorldCoords(spawn_groups[i].offset);
					
			spawn_points = GetStructArray(spawn_groups[i].target, "targetname");
			for( j = 0; j < spawn_points.size; j++ )
			{
				spawn_points[j].origin = self LocalToWorldCoords(spawn_points[j].offset);
				spawn_points[j].angles = self.angles;
			}	
		}
	}
}

busLightsSetup()
{
	// HeadLights
	//-----------
	self setclientflag( level._CLIENTFLAG_VEHICLE_BUS_HEAD_LIGHTS );
	
	// Turn Signals
	//-------------
	self setclientflag( level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_LEFT_LIGHTS );
	self setclientflag( level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_RIGHT_LIGHTS );

	// Interior Lights
	//----------------
	//* self.frontLight 	= SpawnAndLinkFXToOffset( level._effect[ "fx_busInsideLight" ], self, ( 130, 0, 130), ( -90, 0, 0 ) );
	//* self.centerLight 	= SpawnAndLinkFXToOffset( level._effect[ "fx_busInsideLight" ], self, (   0, 0, 130), ( -90, 0, 0 ) );
	//* self.backLight 		= SpawnAndLinkFXToOffset( level._effect[ "fx_busInsideLight" ], self, (-130, 0, 130), ( -90, 0, 0 ) );
}

busLightsFlash()
{
	self endon( "departing" );
	
	while ( true )
	{
		self busLightWaitEnabled();

		self setclientflag( level._CLIENTFLAG_VEHICLE_BUS_FLASHING_LIGHTS );
		
		wait ( 2.5 );
		
		self clearclientflag( level._CLIENTFLAG_VEHICLE_BUS_FLASHING_LIGHTS );
		
		wait ( 2.5 );
	}
}

busLightsBrake()
{
	self busLightWaitEnabled();

	self setclientflag( level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS );
	
	wait ( 5 );
	
	while ( is_false( self.isMoving ) )
	{
		self busLightWaitEnabled();
		self setclientflag( level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS );
		
		wait ( 0.8 );
		
		self clearclientflag( level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS );
		
		wait ( 0.8 );
	}
	
	self clearclientflag( level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS );
}

busLightWaitEnabled()
{
	while ( is_true(self.bus_lights_disabled) )
	{
		wait 0.2;
	}
}

busLightDisable( flag )
{
	self.oldlights[flag] = self getclientflag( flag );
	self clearclientflag( flag );
}

busLightEnable( flag )
{
	if ( self.oldlights[flag] )
		self setclientflag( flag );
}

// Called when an EMP disables the bus to suspend all the lights
busLightsDisableAll()
{
	if (!isdefined(self.oldlights))
		self.oldlights = [];

	self busLightDisable(level._CLIENTFLAG_VEHICLE_BUS_FLASHING_LIGHTS);
	self busLightDisable(level._CLIENTFLAG_VEHICLE_BUS_HEAD_LIGHTS);
	self busLightDisable(level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS);
	self busLightDisable(level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_LEFT_LIGHTS);
	self busLightDisable(level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_RIGHT_LIGHTS);

	self.bus_lights_disabled = true;
}

busLightsEnableAll()
{
	self.bus_lights_disabled = false;

	self busLightEnable(level._CLIENTFLAG_VEHICLE_BUS_FLASHING_LIGHTS);
	self busLightEnable(level._CLIENTFLAG_VEHICLE_BUS_HEAD_LIGHTS);
	self busLightEnable(level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS);
	self busLightEnable(level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_LEFT_LIGHTS);
	self busLightEnable(level._CLIENTFLAG_VEHICLE_BUS_TURN_SIGNAL_RIGHT_LIGHTS);
}


//************************************************************************************************
// Bus doors.
//************************************************************************************************
busDoorsSetup()
{
	self.doorBlockers = [];

	self.doorBlockers = getEntArray("bus_door_blocker", "targetname");
	doorsTrigger 	= getEntArray("bus_door_trigger", "targetname");

	
	for (i=0; i<self.doorBlockers.size; i++)
	{
		self.doorBlockers[i].offset = self worldToLocalCoords(self.doorBlockers[i].origin);	// need to save this off for later
		self.doorBlockers[i] linkTo(self, "", self.doorBlockers[i].offset, (0,0,0));
		self.doorBlockers[i] SetMovingPlatformEnabled( true );
	}
	for (i=0; i<doorsTrigger.size; i++)
	{
		//* doorsTrigger[i] UseTriggerRequireLookAt();
		doorsTrigger[i] enableLinkTo();
		doorsTrigger[i] linkTo(self, "", self worldToLocalCoords(doorsTrigger[i].origin /*+ (0,0,25)*/), (0,0,0));
		doorsTrigger[i] SetCursorHint( "HINT_NOICON" );
		doorsTrigger[i] SetHintString( &"ZOMBIE_TRANSIT_OPEN_BUS_DOOR");
		doorsTrigger[i] SetMovingPlatformEnabled( true );
		
		self thread busDoorThink(doorsTrigger[i]);
	}
	

	// They start closed
	self maps\mp\zm_transit_openings::busOpeningSetEnabled("door", false);	
}

busDoorsOpen()
{
	if (!self.doorsClosed || self.doorsDisabledForTime)
	{
		return;
	}
	
	self.doorsClosed = false;
	
//	level.the_bus HidePart( "doors_front_left_1_jnt" );
	level.the_bus HidePart( "doors_front_left_2_jnt" );
//	level.the_bus HidePart( "doors_front_right_1_jnt" );
	level.the_bus HidePart( "doors_front_right_2_jnt" );
//	level.the_bus HidePart( "doors_rear_left_1_jnt" );
	level.the_bus HidePart( "doors_rear_left_2_jnt" );
//	level.the_bus HidePart( "doors_rear_right_1_jnt" );
	level.the_bus HidePart( "doors_rear_right_2_jnt" );

	doorsTrigger 	= getEntArray("bus_door_trigger", "targetname");

	for (i=0; i<self.doorBlockers.size; i++)
	{
		self.doorBlockers[i] NotSolid();
	}
 	for (i=0; i<doorsTrigger.size; i++)
	{
		doorsTrigger[i] SetHintString( &"ZOMBIE_TRANSIT_CLOSE_BUS_DOOR" );
		//playsoundatposition( "evt_bus_door_close", doorsTrigger[i].origin );
	}
	
	//self UseAnimTree(#animtree);
	//todo t6:
	//self SetFlaggedAnimKnobRestart( "FOO", %vh_zombie_bus_doors_open, 1, 0.2, 1 );
	self 	BusUseAnimTree();
	self 	BusUseDoor( true );
	
	//* self thread busDoorsDisableForTime(3);
	self maps\mp\zm_transit_openings::busOpeningSetEnabled("door", true);	
}

busDoorsClose()
{
	if (self.doorsClosed || self.doorsDisabledForTime)
	{
		return;
	}	
	self.doorsClosed = true;
	
//	level.the_bus ShowPart( "doors_front_left_1_jnt" );
	level.the_bus ShowPart( "doors_front_left_2_jnt" );
//	level.the_bus ShowPart( "doors_front_right_1_jnt" );
	level.the_bus ShowPart( "doors_front_right_2_jnt" );
//	level.the_bus ShowPart( "doors_rear_left_1_jnt" );
	level.the_bus ShowPart( "doors_rear_left_2_jnt" );
//	level.the_bus ShowPart( "doors_rear_right_1_jnt" );
	level.the_bus ShowPart( "doors_rear_right_2_jnt" );
	
	doorsTrigger 	= getEntArray("bus_door_trigger", "targetname");

	for (i=0; i<self.doorBlockers.size; i++)
	{
		self.doorBlockers[i] Solid();
	}
 	for (i=0; i<doorsTrigger.size; i++)
	{
		doorsTrigger[i] SetHintString( &"ZOMBIE_TRANSIT_OPEN_BUS_DOOR" );
		//playsoundatposition( "evt_bus_door_open", doorsTrigger[i].origin );
	}
	
	//todo t6:
	//self UseAnimTree(#animtree);
	//self SetAnimKnob(%vh_zombie_bus_doors_close, 1.0, 0.2, 1.0);
	self 	BusUseAnimTree();
	self 	BusUseDoor( false );
		
	//* self thread busDoorsDisableForTime(0.5);
	self maps\mp\zm_transit_openings::busOpeningSetEnabled("door", false);	
}
busDoorsDisableForTime( time )
{
	doorsTrigger 	= getEntArray("bus_door_trigger", "targetname");
	
 	for (i=0; i<doorsTrigger.size; i++)
	{
		doorsTrigger[i]	SetInvisibleToAll();
	}
	self.doorsDisabledForTime = true;
	wait (time);
	self.doorsDisabledForTime = false;
 	for (i=0; i<doorsTrigger.size; i++)
	{
		doorsTrigger[i]	SetVisibleToAll();
	}	
}
//************************************************************************************************
// DCS: prepping the bus for anim state setup.
//************************************************************************************************
	#using_animtree ( "zombie_bus" );
	
	init_bus_door_anims()
	{
		level.bus_door_open_state = %vh_zombie_bus_doors_open;
		level.bus_door_close_state = %vh_zombie_bus_doors_close;
	}

	BusUseAnimTree()
	{
		self UseAnimTree( #animtree );
	}
	
	BusUseDoor( set )
	{
		self endon( "death" );
	
		animTime = 1.0;
		
		if ( set )
		{
			// open
			self SetAnim( level.bus_door_open_state, 1, animTime, 1 );
		}
		else
		{
			// close
			self playsound( "zmb_bus_door_close" );
			self SetAnim( level.bus_door_close_state, 1, animTime, 1 );
		}
	}
//************************************************************************************************

busDoorThink( trigger )
{
	while( true )
	{
		trigger waittill( "trigger", player );

		if ( self.doorsClosed )
		{
			if ( RandomInt( 100 ) > 75 ) // 25% Chance
			{
				thread automatonSpeak( "inform", "doors_open" );
			}

			trigger playsound( "zmb_bus_door_open" );
			self busDoorsOpen();
		}
		else
		{
			if ( RandomInt( 100 ) > 75 ) // 25% Chance
			{
				thread automatonSpeak( "inform", "doors_close" );
			}

			trigger playsound( "zmb_bus_door_close" );
			self busDoorsClose();
		}

		wait( 1 );
	}
}

//************************************************************************************************
// Bus roof hatch.
//************************************************************************************************
/*
busHatchSetup()
{
	hatchTopTrigger 	= getEntArray("bus_hatch_top_trigger", "targetname");
	hatchBottomTrigger 	= getEntArray("bus_hatch_bottom_trigger", "targetname");
	delta = 0;
	if ( hatchTopTrigger.size > 0 && hatchBottomTrigger.size )
	{
		delta = hatchTopTrigger[0].origin - hatchBottomTrigger[0].origin; 
	}

	for (i=0; i<hatchTopTrigger.size; i++)
	{
		//* hatchTopTrigger[i] UseTriggerRequireLookAt();
		hatchTopTrigger[i] enableLinkTo();
		hatchTopTrigger[i] linkTo(self, "", self worldToLocalCoords(hatchTopTrigger[i].origin), (0,0,0));
		hatchTopTrigger[i] SetCursorHint( "HINT_NOICON" );
		hatchTopTrigger[i] SetHintString( &"ZOMBIE_TRANSIT_HATCH_DOWN");
		hatchTopTrigger[i] SetMovingPlatformEnabled( true );
		
		self thread busHatchThink(hatchTopTrigger[i],-delta);
	}
	for (i=0; i<hatchBottomTrigger.size; i++)
	{
		//* hatchBottomTrigger[i] UseTriggerRequireLookAt();
		hatchBottomTrigger[i] enableLinkTo();
		hatchBottomTrigger[i] linkTo(self, "", self worldToLocalCoords(hatchBottomTrigger[i].origin), (0,0,0));
		hatchBottomTrigger[i] SetCursorHint( "HINT_NOICON" );
		hatchBottomTrigger[i] SetHintString( &"ZOMBIE_TRANSIT_HATCH_UP");
		hatchBottomTrigger[i] SetMovingPlatformEnabled( true );
		
		self thread busHatchThink(hatchBottomTrigger[i],delta);
	}
	
}

lerp_player_view_to_moving_ent( ent, delta, lerptime )
{
	if( IsPlayer( self ) )
	{
		self endon( "disconnect" );
	}

	linker = spawn( "script_origin", ( 0, 0, 0 ) );
	linker.origin = self.origin;
	linker.angles = self getplayerangles();
	//linker.origin = ent.origin;
	//linker.angles = ent.angles;
	offset = self.origin - ent.origin;

	self playerlinktodelta( linker );

	max_count=lerptime/0.0167;
	count=0;
	while (count < max_count)
	{
		origin = ent.origin + offset + delta;
		linker moveto( origin, 0.0167*(max_count-count) );
		wait( 0.0167 );
		count++;
	}
	linker delete();
}

busHatchThink( trigger, delta )
{
	while( true )
	{
		trigger waittill( "trigger", player );
		if (isdefined(player))
		{
			target = player.origin + delta;
			//player lerp_player_view_to_position_bus( target, player.angles, 1, level.the_bus );
			player lerp_player_view_to_moving_ent( trigger, delta, 1 );
			wait( 1 );
		}
	}
}

*/


//************************************************************************************************
// 
//************************************************************************************************

// links the fuel tank script_origin and trigger to the bus
busFuelTankSetup()
{
	script_origin = Spawn( "script_origin", self.origin + ( -193, 75, 48 ) );
	script_origin.angles = ( 0, 180, 0 );
	script_origin LinkTo( self );
	self.fuelTankModelPoint = script_origin;
	
	script_origin = Spawn( "script_origin", self.origin + ( -193, 128, 48 ) );
	script_origin LinkTo( self );
	self.fuelTankTriggerPoint = script_origin;
}

// links the plow script_origin and trigger to the bus
busPlowSetup()
{
	script_origin = GetEnt( "plow_attach_point", "targetname" );
	script_origin LinkTo( self );
	
	trigger = GetEnt( "trigger_plow", "targetname" );
	//* trigger EnableLinkTo();
	trigger LinkTo( self );
	trigger SetMovingPlatformEnabled( true );
	self.plowTrigger = trigger;
	
	usePlowTrigger = Spawn( "trigger_radius_use", trigger.origin, 0, 40, 40 );
	usePlowTrigger.targetname = "trigger_plow_use";
	usePlowTrigger SetCursorHint( "HINT_NOICON" );
	usePlowTrigger SetHintString( &"ZOMBIE_BUILD_PIECE_GRAB" );
	usePlowTrigger TriggerIgnoreTeam();
	usePlowTrigger EnableLinkTo();
	usePlowTrigger LinkTo( self );
	usePlowTrigger thread maps\mp\zombies\_zm_buildables::buildable_think( "cattlecatcher" );
	usePlowTrigger SetInvisibleToAll();
	usePlowTrigger SetMovingPlatformEnabled( true );
	
	self thread busPlowMovePlayer( trigger );
}

busPlowMovePlayer( trigger )
{
	self.plowOffsetPoints = [];
	self.plowOffsetPoints[ 0 ] = Spawn( "script_origin", self.origin + ( -550, 128, 8 ) );
	self.plowOffsetPoints[ 0 ] LinkTo( self );
	self.plowOffsetPoints[ 1 ] = Spawn( "script_origin", self.origin + ( -550, -128, 8 ) );
	self.plowOffsetPoints[ 1 ] LinkTo( self );
	
	level waittill( "cattlecatcher_built" );
	
	while ( true )
	{		
		if ( is_false( self.isMoving ) )
		{
			wait( 0.1 );
		
			continue;
		}
		
		players = GET_PLAYERS();
		
		foreach ( player in players )
		{
			// Can Be Moved
			//-------------
			if ( player IsTouching( trigger ) )
			{
				destinationOffsetPoint = GetClosest( player.origin, self.plowOffsetPoints );
				
				if ( IsDefined( destinationOffsetPoint) )
				{
					dir = VectorNormalize( destinationOffsetPoint.origin - player.origin );
					dir *= ( 20 * self GetSpeedMPH() );
					
					player SetOrigin( player.origin + ( 0, 0, 1 ) );
					player SetVelocity( dir );
				}
			}
		}
		
		wait( 0.05 );
	}
}

busPlowKillZombie( zombie )
{
	zombie.killedByPlow = true;
				
	if( IsDefined( level._effect[ "zomb_gib" ] ) )
	{
		PlayFxOnTag( level._effect[ "zomb_gib" ], zombie, "J_SpineLower" );
	}
	
	zombie thread busPlowKillZombieUntilDeath();
	
	wait( 1 );
	
	if( IsDefined( zombie) )
	{
		zombie Hide();
	}

	if ( !IsDefined( self.upgrades[ "Plow" ].killcount ) )
	{
		self.upgrades[ "Plow" ].killcount = 0;
	}

	self.upgrades[ "Plow" ].killcount ++;
}

busPlowKillZombieUntilDeath()
{
	self endon( "death" );
	
	while ( IsDefined( self ) && IsAlive( self ) )
	{
		if ( IsDefined( self.health ) )
		{
			self DoDamage( self.health * 2, self.origin, self, self, "none", "MOD_SUICIDE" );
		}
		
		wait ( 1 );
	}
}

// links the player clip and roof rail models to the bus
busRoofRailsSetup()
{
	roof_rails = GetEntArray("roof_rail_entity", "targetname");
	for ( i = 0; i < roof_rails.size; i++ )
	{
		roof_rails[i] LinkTo( self, "", self worldtolocalcoords(roof_rails[i].origin), roof_rails[i].angles + self.angles);
	}
}

// links the positions the zombies jump off of the roof to the bus
busRoofJumpOffPositionsSetup()
{
	jump_positions = GetEntArray("roof_jump_off_positions", "targetname");
	assert( jump_positions.size > 0 );
	for ( i = 0; i < jump_positions.size; i++ )
	{
		jump_positions[i] LinkTo( self, "", self worldtolocalcoords(jump_positions[i].origin), jump_positions[i].angles + self.angles);
	}
}

// links the outside ladders and triggers to the bus
busSideLaddersSetup()
{
	side_ladders = GetEntArray("roof_ladder_outside", "targetname");	
	for ( i = 0; i < side_ladders.size; i++ )
	{
		side_ladders[i].trigger = getEnt(side_ladders[i].target, "targetname");
		// side ladder should target it's trigger, if not delete it
		if ( !isDefined( side_ladders[i].trigger ) )
		{
			side_ladders[i] delete();
			continue;
		}
		side_ladders[i] LinkTo( self, "", self worldtolocalcoords(side_ladders[i].origin), side_ladders[i].angles + self.angles);
		side_ladders[i].trigger enableLinkTo();
		side_ladders[i].trigger LinkTo( self, "", self worldtolocalcoords(side_ladders[i].trigger.origin), side_ladders[i].trigger.angles + self.angles);
		self thread busSideLadderThink(side_ladders[i], side_ladders[i].trigger);
	}
}

// handles a player using the ladder on the side of the bus
busSideLadderThink(ladder, trigger)
{
	if ( true )
	{
		trigger Delete();
		return;
	}	

	trigger SetCursorHint( "HINT_NOICON" );
	trigger SetHintString( &"ZOMBIE_TRANSIT_BUS_CLIMB_ROOF" );
	while ( 1 )
	{
		trigger waittill("trigger", player);
		teleport_location = self localToWorldCoords( ladder.script_vector );
		player setOrigin( teleport_location );
		trigger SetInvisibleToAll();
		wait( 1.0 );
		trigger SetVisibleToAll();
	}
}

/*
// make the trigger disabled if there are tires to place since the triggers overlap
busSideLadderTriggerVisibility(trigger)
{
	while ( 1 )
	{
		if ( maps\mp\zm_transit_upgrades::getNumFlatTires() > 0 )
		{
			trigger setInvisibleToAll();
		}
		else
		{
			trigger setVisibleToAll();
		}
		wait( 0.5 );
	}
}
*/
busPathBlockerSetup()
{
	// link our path blocker to the bus
	self.path_blockers = GetEntArray("bus_path_blocker", "targetname");
	for ( i = 0; i < self.path_blockers.size; i++ )
	{
		self.path_blockers[i] LinkTo( self, "", self worldtolocalcoords(self.path_blockers[i].origin), self.path_blockers[i].angles + self.angles);
	}
	
	// DCS: throwing in buyable weapon bus attachment.
	trig = GetEnt("bus_buyable_weapon1", "script_noteworthy");
	trig enableLinkTo();
	trig linkTo(self, "", self worldToLocalCoords(trig.origin), (0,0,0));
	trig SetMovingPlatformEnabled( true );
	
	weapon_model = GetEnt(trig.target, "targetname");
	weapon_model LinkTo( self, "", self worldtolocalcoords(weapon_model.origin), weapon_model.angles + self.angles);
	weapon_model SetMovingPlatformEnabled( true );
	
	bus_chalk = GetEnt("bus_weapon_chalk", "script_noteworthy");
	bus_chalk LinkTo( self, "", self worldtolocalcoords(bus_chalk.origin), bus_chalk.angles + self.angles);
	bus_chalk SetMovingPlatformEnabled( true );
	
	weapon_chalk = spawn("script_model",bus_chalk.origin);
	weapon_chalk.angles = bus_chalk.angles;
	weapon_chalk LinkTo(bus_chalk);
	weapon_chalk SetMovingPlatformEnabled( true );	
	weapon_chalk SetModel("tag_origin");
	
	wait_network_frame();
	PlayFXOnTag( level._effect["m16_zm_fx"], weapon_chalk, "tag_origin" );
}

busPathBlockerEnable()
{
	if( !isdefined( self.path_blockers ) )
		return;

	// need to wait until the bus comes to a stop before doing this
	while ( level.the_bus GetSpeed() > 0 )
	{
		wait( 0.1 );
	}

	for ( i = 0; i < self.path_blockers.size; i++ )
	{
		self.path_blockers[i] DisconnectPaths();
	}
}

busPathBlockerDisable()
{
	if( !isdefined( self.path_blockers ) )
		return;

	for ( i = 0; i < self.path_blockers.size; i++ )
	{
		self.path_blockers[i] ConnectPaths();
	}
}

busSetupBounds()
{
	self.bounds_origins = GetEntArray("bus_bounds_origin", "targetname");
	for ( i = 0; i < self.bounds_origins.size; i++ )
	{
		self.bounds_origins[i] LinkTo(self, "", self worldtolocalcoords(self.bounds_origins[i].origin), self.angles);
	}
}

busStartWait()
{
	while( self GetSpeed() == 0 )
	{
		wait( 0.1 );
	}
}

busShowLeavingHud(time)
{
	if(!isDefined(level.bus_leave_hud))
	{
		level.bus_leave_hud = newHudElem();
		level.bus_leave_hud.color = (1, 1, 1);
		level.bus_leave_hud.fontScale = 4;
		level.bus_leave_hud.x = -300;//-295;
		level.bus_leave_hud.y = 100;//195;
		level.bus_leave_hud.alignX = "center";
		level.bus_leave_hud.alignY = "bottom";
		level.bus_leave_hud.horzAlign = "center";
		level.bus_leave_hud.vertAlign = "middle";
		level.bus_leave_hud.font = "objective";
		level.bus_leave_hud.glowColor = (0.3, 0.6, 0.3);
		level.bus_leave_hud.glowAlpha = 1;
		level.bus_leave_hud.foreground = 1;
		level.bus_leave_hud.hidewheninmenu = true;
	}
	
	level.bus_leave_hud.alpha = .3;
	level.bus_leave_hud settimer( time );
	
	wait(time);
	
	level.bus_leave_hud.alpha = 0;
}

busStartMoving( targetSpeed )
{
	if ( !self.isMoving )
	{
		//* level notify( "bus_is_leaving" );

		self.isMoving 		= true;
		self.isStopping 	= false;

		self clearclientflag( level._CLIENTFLAG_VEHICLE_BUS_BRAKE_LIGHTS );
		// self busDoorsClose();
		self busPathBlockerDisable();

		if ( !flag( "ambush_round" ) )
		{
			level.numBusStopsSinceLastAmbushRound++;
		}
	}
	
	if ( IsDefined( targetSpeed ) )
	{
		self.targetSpeed = targetSpeed;
	}
	
	self notify( "OnKeysUsed" );
	self thread play_bus_audio( "leaving" );
}

busStopWait()
{
	if ( self.isMoving && !self.isStopping )
	{
		self.isStopping = true;
		
		while( self GetSpeed() > 0 ) // in inches per second
		{
			wait( 0.1 );
		}
	}
}

busStopMoving( immediateStop )
{
	if ( self.isMoving )
	{
		if ( is_true( immediateStop ) )
		{
			self.immediateSpeed = true;
		}
		
		self thread play_bus_audio( "stopping" );
		
		self.targetSpeed = 0;
		
		self.isMoving 		= false;
		self.isStopping 	= false;

		self thread busLightsBrake();
		// self busDoorsOpen();
		// self busGivePowerup();

		self thread busPathBlockerEnable();
		// if (!flag("spawn_zombies"))
		// {
		//	level thread busRestartZombieSpawningAfterTime(12);	// zombie_between_round_time == 10 seconds, so keep this similar
		// }

	}
}

busGasAdd( percent )
{
	newGasLevel = ( level.the_bus.gas + percent );
	
/#	PrintLn( "^2Bus Debug: Old Gas Level is " + newGasLevel );	#/

	if ( newGasLevel < 0 )
	{
		newGasLevel = 0;
	}
	else if ( newGasLevel > 100 )
	{
		newGasLevel = 100;
	}

	level.the_bus.gas = newGasLevel;

/#	PrintLn( "^2Bus Debug: New Gas Level is " + newGasLevel );	#/
}

busGasRemove( percent )
{
	busGasAdd( percent * -1 );
}

busGasEmpty()
{
	if ( level.the_bus.gas <= 0 )
	{
		return true;
	}
	
	return false;
}

busRestartZombieSpawningAfterTime( seconds )
{
	wait(seconds);
	maps\mp\zm_transit_utility::try_resume_zombie_spawning();
}

busThink()
{
	// THREAD NOTES:
	// SELF == the bus
	//
	// This thread updates bus behavior that needs to be running all the time,
	// like tracking players and attaching zombies to the windows.
	//
	
	audioZomOnBus_old = 0;
	audioZomOnBus_new = 0;
	
	while ( true )
	{
		self busUpdatePlayers(); 			// Tests to see if players are on the bus
		self busUpdateNearZombies();
		self busUpdateRespawnPoints();
		self busUpdateSpeed();
		audioZomOnBus_new = self.zombiesInside;
		self zomOnBusVox( audioZomOnBus_old, audioZomOnBus_new );
		audioZomOnBus_old = audioZomOnBus_new;
		wait( 0.1 );
	}
}
zomOnBusVox( old, new )
{
	if( new == old )
		return;

	if( new < old )
		return;
	
	if( new == 1 || new == 4 || new == 8 )
		level thread automatonSpeak( "inform", "zombie_on_board" );
}

//--------------------------------------------------------------------------------------------
// used to make zombies pursue a player on the bus
//--------------------------------------------------------------------------------------------
enemy_location_override( zombie, enemy )
{
	ret = enemy.origin;

	if( is_true( zombie.isscreecher ) || is_true( zombie.is_avogadro ))
	{
		return ret;
	}

	if ( !is_true( enemy.isOnBus ) || is_true( zombie.isOnBus ) || ( enemy maps\mp\zm_transit_cling::playerIsClingingToBus() && !is_true( level.the_bus.isMoving ) ) )
	{
		self.goalradius = 32;
		ret = enemy.origin;

		if( isdefined(zombie.zombie_move_speed_pre_bus_chase) )
		{
			//If we get here then the zombie had been chasing this bus, now the enemy is not on the bus set the zomb ie back to its pre bus chase speed
			zombie stop_bus_chase();
		}
	}
	else if ( !level.the_bus.isMoving )
	{
		// the bus has stopped and zombie got close enough to stop sprinting
		if ( isdefined(zombie.zombie_move_speed_pre_bus_chase) )
		{
			dist_sq = Distance2DSquared( zombie.origin, level.the_bus.origin );
			if ( dist_sq < STOP_CHASE_DIST )
			{
				zombie stop_bus_chase();
			}
		}
		
		self.goalradius = 2;
		// find the closeset, not used entry point on the bus
		closestOpeningToZombie = undefined;
		closestDistToZombie = -1.0;
		closestOriginToZombie = undefined;
		
		closestOpeningToPlayer = undefined;
		closestDistToPlayer = -1.0;
		closestOriginToPlayer = undefined;
		
		for ( i = 0; i < level.the_bus.openings.size; i++ )
		{
			opening = level.the_bus.openings[i];

			// ignore disabled openings
			if ( !opening.enabled )
			{
				continue;
			}
			
			// get the origin the zombie will need to jump from for this opening
			jump_origin = maps\mp\zm_transit_openings::_determineJumpFromOrigin( opening );
			
			// determine the closest opening to the chosen enemy
			dist2 = DistanceSquared(enemy.origin, jump_origin);
			if ( !IsDefined(closestOpeningToPlayer) || dist2 < closestDistToPlayer )
			{
				closestOpeningToPlayer = opening;
				closestOriginToPlayer = jump_origin;
				closestDistToPlayer = dist2;
			}
			
			// don't bother with openings that already have a zombie on them
			if ( IsDefined(opening.zombie) )
			{
				continue;
			}
			
			// determine the closest opening to the zombie
			dist2 = DistanceSquared(zombie.origin, jump_origin);
			if ( !IsDefined(closestOpeningToZombie) || dist2 < closestDistToZombie )
			{
				closestOpeningToZombie = opening;
				closestOriginToZombie = jump_origin;
				closestDistToZombie = dist2;
			}
		}

		// if there is any available opening, go to it
		if ( IsDefined( closestOpeningToZombie ) )
		{
			ret = closestOriginToZombie;
			zombie.goalradius = 2;
		}
		else
		{
			// fallback case--path outside of the window where the player is
			ret = closestOriginToPlayer;
		}
	}
	// try just setting the front of the bus as the path point
	else
	{
		ret = level.the_bus.frontWorld;

		if ( !isdefined( zombie.zombie_move_speed_pre_bus_chase ) )
		{
			//Turn this zombie into a super sprinter
			zombie.zombie_move_speed_pre_bus_chase = zombie.zombie_move_speed;
			zombie set_zombie_run_cycle( "chase_bus" );
		}
	}
	/#
	if ( GetDvarInt("zombie_bus_debug_path") > 0 )
	{
		// draw a line from the zombie to the point they are going to try to path to
		line(zombie.origin, ret, (1,1,0), false, 10);
	}
	#/
	return ret;

}

stop_bus_chase()
{
	self set_zombie_run_cycle( self.zombie_move_speed_pre_bus_chase );
	self.zombie_move_speed_pre_bus_chase = undefined;
}

// this function is called when a powerup spawns; it checks if the powerup is on the bus and if so make it travel with the bus
attachPowerupToBus(powerup)
{
	if ( !IsDefined( powerup ) || !IsDefined( level.the_bus ) )
	{
		return;
	}
	
	// the acceptable distance a powerup can be outside of the bus
	distanceOutsideOfBus = 50.0;
	heightOfRoofPowerup = 60;
	heightOfFloorPowerup = 25;
	originOfBus = level.the_bus getTagOrigin( "tag_origin" );
	floorOfBus = originOfBus[2] + level.the_bus.floor;
	
	// some variables so we know how to adjust the position of the powerup
	adjustUp = false;
	adjustDown = false;
	adjustIn = false;
	
	pos 		= powerup.origin;
	posInBus 	= PointOnSegmentNearestToPoint(level.the_bus.frontWorld, level.the_bus.backWorld, pos);

	// First check if the powerup is close to the bus and needs to be pushed in a bit or if it is not even close to the bus
	// --------------------------------------------------------------------------------------------------------------------
	posDist2 = distance2dsquared(pos, posInBus);
	if ( posDist2 > (level.the_bus.radius * level.the_bus.radius) )
	{
		// check if it is just outside of the window
		radiusPlus = level.the_bus.radius + distanceOutsideOfBus;
		if ( posDist2 > ( radiusPlus * radiusPlus ) )
		{
			// it is way outside of the bus
			return;
		}
		adjustIn = true;
	}
	
	// one more check to see if it is in the unreachable part of the front of bus
	if ( !adjustIn )
	{
		bus_front_local = ( 276, 28, 0 ); // specially chosen point that combined with a radius is a cheap check to see if it is in the front of the bus		
		bus_front_local_world = level.the_bus localToWorldCoords( bus_front_local );
		bus_front_radius2 = 100 * 100;
		
		front_dist2 = distance2dsquared(powerup.origin, bus_front_local_world);	
		if ( front_dist2 < bus_front_radius2 )
		{
			adjustIn = true;
		}
	}
	
	// adjust the powerup's position if needed
	if ( adjustIn )
	{
		directionToBus = posInBus - pos;
		directionToBusN = vectorNormalize(directionToBus);
		howFarIntoBus = distanceOutsideOfBus + 10;
		powerup.origin = powerup.origin + (directionToBusN * howFarIntoBus);
	}
	
	// Second check if the powerup is too far up or down and adjust vertically
	// -----------------------------------------------------------------------
	posZDelta = powerup.origin[2] - posInBus[2];
	if ( posZDelta < level.the_bus.floor+heightOfFloorPowerup )// is below or too close to the floor of the bus
	{
		adjustUp = true;
	}
	else if ( posZDelta > level.the_bus.height-20.0 )// is above the bus or too close to the top
	{
		adjustDown = true;
	}
	
	// Last actually move it and link it to the bus
	// --------------------------------------------
	if ( adjustUp )
	{
		powerup.origin = (powerup.origin[0], powerup.origin[1], floorOfBus+heightOfFloorPowerup);
	}
	else if ( adjustDown )
	{
		powerup.origin = (powerup.origin[0], powerup.origin[1], floorOfBus+heightOfRoofPowerup);
	}
	
	powerup linkto(level.the_bus, "", level.the_bus worldtolocalcoords(powerup.origin), powerup.angles - level.the_bus.angles);
}

// this function is called before gibs spawn and returns true if the zombie is on the bus in which case don't spawn any gibs
shouldSuppressGibs(zombie)
{
	if ( !isDefined( zombie ) || !IsDefined( level.the_bus ) )
	{
		return false;
	}
	
	pos 		= zombie.origin;
	posInBus 	= PointOnSegmentNearestToPoint(level.the_bus.frontWorld, level.the_bus.backWorld, pos);
	posZDelta 	= pos[2] - posInBus[2];
	if (posZDelta < (level.the_bus.floor-10.0))// is below the bus
	{
		return false;
	}
	
	posDist2 = distance2dsquared(pos, posInBus);
	if ( posDist2 > (level.the_bus.radius * level.the_bus.radius) )
	{
		return false;
	}
	return true;
}
// -----------------------------------------------------------------------------------------------------
// DCS: slowing down the bus when entering bridge. can be used for sound crossing rickety wooden bridge.
// -----------------------------------------------------------------------------------------------------
bus_bridge_speedcontrol()
{
	while(true)
	{
		self waittill( "reached_node", nextpoint );	

		if ( IsDefined( nextpoint.script_noteworthy ) )
		{
			if(nextpoint.script_noteworthy == "bridge_decel_point")
			{
				old_speed = self.targetSpeed;
				self.targetSpeed = 4;
				self SetSpeed( self.targetSpeed, 30, 30 );
			}	
			else if(nextpoint.script_noteworthy == "bridge_accel_point")
			{
				self.targetSpeed = old_speed;
				self SetSpeed( self.targetSpeed, 30, 30 );
			}
		}
		
		waittillframeend; 
	}
}	


//************************************************************************************************
// BUS AUDIO: C. Ayers adding this in
//************************************************************************************************

bus_audio_setup()
{
	if( !isdefined( self ) )
		return;
	
	self.engine_ent_1 = spawn( "script_origin", self.origin );
	self.engine_ent_1 linkto( self, "tag_origin", (-175,0,-5) );
	self.engine_ent_2 = spawn( "script_origin", self.origin );
	self.engine_ent_2 linkto( self, "tag_origin", (-175,0,-5) );
}
play_bus_audio( type )
{
	level notify( "playing_bus_audio" );
	level endon( "playing_bus_audio" );
	
	switch(type)
	{
		case "grace":
			self.engine_ent_1 playloopsound( "zmb_bus_start_idle", .05 );
			level.automaton playsound( "zmb_bus_horn_warn" );
			break;
		
		case "leaving":
			level.automaton playsound( "zmb_bus_horn_leave" );
			self thread play_lava_audio();
			self.engine_ent_2 playloopsound( "zmb_bus_start_move", .05 );
			self.engine_ent_1 stoploopsound( 2 );
			wait(7);
			self.engine_ent_1 playloopsound( "zmb_bus_exterior_loop", 2 );
			self.engine_ent_2 stoploopsound( 3 );
			break;
			
		case "stopping":
			self notify( "stop_bus_audio" );
			level.automaton playsound( "zmb_bus_horn_leave" );
			self.engine_ent_1 stoploopsound( 3 );
			self.engine_ent_2 stoploopsound( 3 );
			self.engine_ent_2 playsound( "zmb_bus_stop_move" );
			self PlaySound("zmb_bus_car_scrape");
			break;
			
		case "emp":
			self notify( "stop_bus_audio" );
			self.engine_ent_1 stoploopsound( .5 );
			self.engine_ent_2 stoploopsound( .5 );
			self.engine_ent_2 playsound( "zmb_bus_stop_move" );
			break;	
	}
}
//SELF == player on bus
bus_audio_interior_loop( bus )
{
	self endon( "left bus" );
	           
	while( !bus.ismoving || is_true(bus.disabled_by_emp) )
	{
		wait(.1);
	}
	
	self clientnotify( "buslps" );
	
	self thread bus_audio_turnoff_interior_player( bus );
	self thread bus_audio_turnoff_interior_bus( bus );
	self thread death_shutoff( bus );
}

bus_audio_turnoff_interior_player( bus )
{
	bus endon( "stop_bus_audio" );
	self endon( "death" );
	
	self waittill( "left bus" );
	
	self clientnotify( "buslpe" );
}
bus_audio_turnoff_interior_bus( bus )
{
	self endon( "left bus" );
	self endon( "death" );
	
	bus waittill( "stop_bus_audio" );
	
	self clientnotify( "buslpe" );
}

death_shutoff( bus )
{
	self endon( "left bus" );
	bus endon( "stop_bus_audio" );
	
	self waittill( "death" );
	
	self clientnotify( "buslpe" );
}

play_lava_audio()
{
	self endon( "stop_bus_audio" );
	
	ent_back = undefined;
	ent_front = undefined;
	
	while(self.ismoving)
	{
		if( self maps\mp\zm_transit_lava::object_touching_lava() && ( self.zone != "zone_station_ext" && self.zone != "zone_pri" ) )
		{
			if( !isdefined( ent_back ) && !isdefined( ent_front ) )
			{
				ent_back = spawn( "script_origin", self getTagOrigin( "tag_wheel_back_left" ));
				ent_back linkto( self, "tag_wheel_back_left" );
				ent_front = spawn( "script_origin", self getTagOrigin( "tag_wheel_front_right" ));
				ent_front linkto( self, "tag_wheel_front_right" );
				self thread delete_lava_audio_ents( ent_back, ent_front );
			}
			
			ent_front playloopsound( "zmb_bus_lava_wheels_loop", .5 );
			ent_back playloopsound( "zmb_bus_lava_wheels_loop", .5 );
			
			while( self maps\mp\zm_transit_lava::object_touching_lava() )
			{
				wait .1;
			}
		}
		
		if( isdefined( ent_back ) && isdefined( ent_front ) )
		{
			ent_front stoploopsound( 1 );
			ent_back stoploopsound( 1 );
		}
		
		wait(.1);
	}
}
delete_lava_audio_ents( ent1, ent2 )
{
	self waittill( "stop_bus_audio" );
	ent1 delete();
	ent2 delete();
}