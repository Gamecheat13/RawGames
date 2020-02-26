#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;

#insert raw\maps\mp\_clientflags.gsh;

init()
{
	registerKillstreak( "helicopter_player_gunner_mp", "helicopter_player_gunner_mp", "killstreak_helicopter_player_gunner", "helicopter_used", ::heli_gunner_killstreak, true) ;
	registerKillstreakStrings( "helicopter_player_gunner_mp", &"KILLSTREAK_EARNED_HELICOPTER_GUNNER", &"KILLSTREAK_HELICOPTER_GUNNER_NOT_AVAILABLE", &"KILLSTREAK_HELICOPTER_GUNNER_INBOUND" );
	registerKillstreakDialog( "helicopter_player_gunner_mp", "mpl_killstreak_osprey_strt", "kls_playerheli_used", "","kls_playerheli_enemy", "", "kls_playerheli_ready" );
	registerKillstreakDevDvar( "helicopter_player_gunner_mp", "scr_givehelicopter_player_gunner" );
	registerKillstreakAltWeapon( "helicopter_player_gunner_mp", "cobra_minigun_mp" );
	registerKillstreakAltWeapon( "helicopter_player_gunner_mp", "heli_gunner_rockets_mp" );
	registerKillstreakAltWeapon( "helicopter_player_gunner_mp", "chopper_minigun_mp" );
	overrideEntityCameraInDemo("helicopter_player_gunner_mp", true);

	LoadFX ("vehicle/treadfx/fx_heli_dust_default");
	LoadFX ("vehicle/treadfx/fx_heli_dust_concrete");
	LoadFX ("vehicle/treadfx/fx_heli_water_spray");
//	LoadFX ("vehicle/treadfx/fx_heli_snow_spray");
	LoadFX ("vehicle/exhaust/fx_exhaust_huey_engine");
	PreCacheItem( "chopper_minigun_mp" );
	PreCacheItem( "heli_gunner_rockets_mp" );
	
	level.chopper_defs["player_gunner"] = "heli_player_gunner_mp";
	level.chopper_models["player_gunner"]["friendly"] = "veh_iw_air_apache_killstreak";
	level.chopper_models["player_gunner"]["enemy"] = "veh_iw_air_apache_killstreak";

	// TODO MTEAM - figure out the chopper models for multiteam
	foreach( team in level.teams )
	{
		level.chopper_death_models["player_gunner"][team] = "t5_veh_helo_hind_dead";
		level.chopper_sounds["player_gunner"][team] = "mpl_kls_hind_helicopter";
	}
	
	level.chopper_death_models["player_gunner"]["allies"] = "t5_veh_helo_hind_dead";
	level.chopper_death_models["player_gunner"]["axis"] = "t5_veh_helo_hind_dead";
	level.chopper_sounds["player_gunner"]["allies"] = "mpl_kls_cobra_helicopter";
	level.chopper_sounds["player_gunner"]["axis"] = "mpl_kls_hind_helicopter";

	level.chaff_offset["player_gunner"] = ( -185, 0, -85 );

	PreCacheModel(level.chopper_models["player_gunner"]["friendly"]);
	PreCacheVehicle( level.chopper_defs["player_gunner"] );

	level.chopper_infrared_vision = "remote_mortar_infrared";
	level.chopper_enhanced_vision = "remote_mortar_enhanced";

	level.heli_angle_offset = 90;
	level.heli_forced_wait	= 0;
}
//register()
//{
//	RegisterClientField( "actor", "player_is_gunner", 1, "int");	
//}
heli_gunner_killstreak( hardpointType )
{
	assert( hardpointType == "helicopter_player_gunner_mp" );

	if ( !IsDefined( level.heli_paths ) || !level.heli_paths.size )
	{
/#		println( "No helicopter paths found in map" );	#/
		return false;
	}

	if ( !IsDefined( level.Heli_primary_path ) || !level.heli_primary_path.size )
	{
/#		println( "No primary helicopter path found in map" );	#/
		return false;
	}

	if ( !self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
	{
		return false;
	}
	
	if ( is_true( self.isPlanting ) )
	{
		return false;
	}
	
	if ( is_true( self.isDefusing ) )
	{
		return false;
	}

	result = self heli_gunner_spawn( hardpointType );
	
	if( !isDefined(result) )
	{
		return false;
	}

	return result;
}

heli_gunner_spawn( hardpointType )
{
	self endon("disconnect");
	level endon("game_ended");
	
	self setUsingRemote( hardpointType );
	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak( "qrdrone" );		
	
	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			self clearUsingRemote();
		}
		return false;
	}	
	if ( !self startHelicopter( "player_gunner", false, hardpointtype, level.heli_primary_path[0] ) ) 
	{
		self clearUsingRemote();
		return false;
	}

	//Check to see if we are carring an item
	if ( IsDefined( self.carryIcon ) )
	{
		//Yes we are so fade it out while in the helicopter
		self.prevCarryIconAlpha = self.carryIcon.alpha;
		self.carryIcon.alpha = 0.0;
	}

	self thread maps\mp\killstreaks\_helicopter::announceHelicopterInbound( hardpointType );

	self.heli maps\mp\killstreaks\_helicopter::heli_reset();
	self.heli UseVehicle( self, 0 );
	self setPlayerAngles( self.heli getTagAngles( "tag_player" ) );	
	self.heli.zOffset = ( 0, 0, 120 );
	self.heli.playerMovedRecently = false;
	//Eckert - Setting hit sfx for chopper_gunner
	self.heli.soundmod = "default_loud";
	
	attack_nodes = GetEntArray( "heli_attack_area", "targetname" );

	if ( attack_nodes.size )
	{
		self.heli thread heli_fly_well( level.heli_primary_path[0], attack_nodes );
		self thread change_location( attack_nodes );
	}
	else
	{
		self.heli thread maps\mp\killstreaks\_helicopter::heli_fly( level.heli_primary_path[0], 0.0, hardpointtype );
	}
	
	self.pilotVoiceNumber = self.bcVoiceNumber + 1;
	if 	(self.pilotVoiceNumber > 3) 
	{
		self.pilotVoiceNumber = 0;
	}
	
	wait ( 1.0 );
	// TODO CDC - change to new pilot dialog
	//self thread PlayPilotDialog( "attackheli_approach", 2 );
	//self PlayLocalSound( level.heli_vo[self.heli.team]["approach"] );

	self.heli thread fireHeliWeapon( self );
	self.heli thread hind_watch_rocket_fire( self );
	self.heli thread look_with_player( self );

	//Allow SAM turret to target chopper
	Target_SetTurretAquire( self.heli, true );
	self.heli.lockOnDelay = false;

	self.heli waittill_any( "death", "leaving", "abandoned" );

	return true;
}

look_with_player( player )
{
	
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	self endon ( "crashing" );
	self endon ( "leaving" );
	
	while ( true )
	{
		self setgoalyaw( (player GetPlayerAngles())[1] );
		wait (0.05);
	}
}

change_location( destNodes )
{
	self.heli endon ( "death" );
	self.heli endon ( "crashing" );
	self.heli endon ( "leaving" );
	
	self.moves = 0;
	self.heli waittill ( "near_goal" );
	self.heli waittill ( "goal" );
	self.heli.numFlares = 3;
	self.move_hud SetText("[{+smoke}]" + "Move to New Location");
	
	for (;;)
	{
		if ( self SecondaryOffhandButtonPressed() )
		{
			self.moves++;
			self thread player_moved_recently_think();
			currentNode = self get_best_area_attack_node( destNodes, true );
			
			//Want Dialog here "Moving to better location"
			//self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "helicopter_player_gunner_mp_start" );
			self playsoundtoplayer ( "mpl_cgunner_nav", self );
			self.heli travelToNode( currentNode );
			
			// motion change via node
			if( isdefined( currentNode.script_airspeed ) && isdefined( currentNode.script_accel ) )
			{
				heli_speed = currentNode.script_airspeed;
				heli_accel = currentNode.script_accel;
			}
			else
			{
				heli_speed = 50+randomInt(20);
				heli_accel = 30+randomInt(10);
			}
			
			self.heli SetSpeed( heli_speed, heli_accel );	
			self.heli setvehgoalpos( currentNode.origin + self.heli.zOffset, 1 );
			self.heli setgoalyaw( currentNode.angles[ 1 ] + level.heli_angle_offset );	
	
			self.move_hud SetText("");
			self.heli waittill ( "goal" );
			self.move_hud SetText("[{+smoke}]" + "Move to New Location");
						
			// wait for the button to release:
			while ( self SecondaryOffhandButtonPressed() )
				wait( 0.05 );
		}
		wait( 0.05 );
	}
}

player_moved_recently_think()
{
	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "leaving" );
	
	myMove = self.moves;
	self.heli.playerMovedRecently = true;
	wait ( 15 );
	//only remove the flag if I am still the most recent move
	if (myMove == self.moves && isDefined(self.heli))
		self.heli.playerMovedRecently = false;
}

heli_fly_well( startNode, destNodes )
{
	self notify( "flying");
	self endon( "flying" );

	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "leaving" );

	nextnode = getent( startNode.target, "targetname" );
	assert( isdefined( nextnode ), "Next node in path is undefined, but has targetname" );
	self SetSpeed( 70, 40 );	
	self setvehgoalpos( nextnode.origin + self.zOffset, 1 );
	self waittill( "near_goal" );
	
	for ( ;; )	
	{
		if ( !self.playerMovedRecently )
		{
			currentNode = self get_best_area_attack_node( destNodes, false );
		
			travelToNode( currentNode );
			
			// motion change via node
			if( isdefined( currentNode.script_airspeed ) && isdefined( currentNode.script_accel ) )
			{
				heli_speed = currentNode.script_airspeed;
				heli_accel = currentNode.script_accel;
			}
			else
			{
				heli_speed = 50+randomInt(20);
				heli_accel = 30+randomInt(10);
			}
			
			self SetSpeed( heli_speed, heli_accel );	
			self setvehgoalpos( currentNode.origin + self.zOffset, 1 );
			self setgoalyaw( currentNode.angles[ 1 ] + level.heli_angle_offset );	
		}

		if ( level.heli_forced_wait != 0 )
		{
			self waittill( "near_goal" ); //self waittillmatch( "goal" );
			wait ( level.heli_forced_wait );			
		}
		else if ( !isdefined( currentNode.script_delay ) )
		{
			self waittill( "near_goal" ); //self waittillmatch( "goal" );

			wait ( 5 + randomInt( 5 ) );
		}
		else
		{				
			self waittillmatch( "goal" );				
			wait ( currentNode.script_delay );
		}
	}
}


get_best_area_attack_node( destNodes, forceMove )
{
	return updateAreaNodes( destNodes, forceMove );
}

updateAreaNodes( areaNodes, forceMove )
{
	validEnemies = [];

	foreach ( node in areaNodes )
	{
		node.validPlayers = [];
		node.nodeScore = 0;
	}
	
	foreach ( player in level.players )
	{
		if ( !isAlive( player ) )
			continue;

		if ( player.team == self.team )
			continue;

		foreach ( node in areaNodes )
		{
			if ( distanceSquared( player.origin, node.origin ) > 1048576 )
				continue;
								
			node.validPlayers[node.validPlayers.size] = player;
		}
	}
	
	bestNode = areaNodes[0];
	foreach ( node in areaNodes )
	{
		heliNode = getEnt( node.target, "targetname" );
		foreach ( player in node.validPlayers )
		{
			node.nodeScore += 1;
			
			if ( bulletTracePassed( player.origin + (0,0,32), heliNode.origin, false, player ) )
				node.nodeScore += 3;
		}
				
		if ( forceMove && (distance( self.heli.origin, heliNode.origin ) < 200) )
			node.nodeScore = -1;
		
		if ( node.nodeScore > bestNode.nodeScore )
			bestNode = node;
	}
	
	return ( getEnt( bestNode.target, "targetname" ) );
}

travelToNode( goalNode )
{
	originOffets = getOriginOffsets( goalNode );
	
	if ( originOffets["start"] != self.origin )
	{
		// motion change via node
		if( isdefined( goalNode.script_airspeed ) && isdefined( goalNode.script_accel ) )
		{
			heli_speed = goalNode.script_airspeed;
			heli_accel = goalNode.script_accel;
		}
		else
		{
			heli_speed = 30+randomInt(20);
			heli_accel = 15+randomInt(15);
		}
		
		self SetSpeed( heli_speed, heli_accel );
		self setvehgoalpos( originOffets["start"] + (0,0,30), 0 );
		// calculate ideal yaw
		self setgoalyaw( goalNode.angles[ 1 ] + level.heli_angle_offset );
		
		//println( "setting goal to startOrigin" );
		
		self waittill ( "goal" );
	}
	
	if ( originOffets["end"] != goalNode.origin )
	{
		// motion change via node
		if( isdefined( goalNode.script_airspeed ) && isdefined( goalNode.script_accel ) )
		{
			heli_speed = goalNode.script_airspeed;
			heli_accel = goalNode.script_accel;
		}
		else
		{
			heli_speed = 30+randomInt(20);
			heli_accel = 15+randomInt(15);
		}
		
		self SetSpeed( heli_speed, heli_accel );
		self setvehgoalpos( originOffets["end"] + (0,0,30), 0 );
		// calculate ideal yaw
		self setgoalyaw( goalNode.angles[ 1 ] + level.heli_angle_offset );

		//println( "setting goal to endOrigin" );
		
		self waittill ( "goal" );
	}
}

getOriginOffsets( goalNode )
{
	startOrigin = self.origin;
	endOrigin = goalNode.origin;
	
	numTraces = 0;
	maxTraces = 40;
	
	traceOffset = (0,0,-196);
	
	traceOrigin = BulletTrace( startOrigin+traceOffset, endOrigin+traceOffset, false, self );

	while ( DistanceSquared( traceOrigin[ "position" ], endOrigin+traceOffset ) > 10 && numTraces < maxTraces )
	{	
/#		println( "trace failed: " + DistanceSquared( traceOrigin[ "position" ], endOrigin+traceOffset ) );	#/
			
		if ( startOrigin[2] < endOrigin[2] )
		{
			startOrigin += (0,0,128);
		}
		else if ( startOrigin[2] > endOrigin[2] )
		{
			endOrigin += (0,0,128);
		}
		else
		{	
			startOrigin += (0,0,128);
			endOrigin += (0,0,128);
		}

/#
		//thread draw_line( startOrigin+traceOffset, endOrigin+traceOffset, (0,1,9), 200 );
#/
		numTraces++;

		traceOrigin = BulletTrace( startOrigin+traceOffset, endOrigin+traceOffset, false, self );
	}
	
	offsets = [];
	offsets["start"] = startOrigin;
	offsets["end"] = endOrigin;
	return offsets;
}

startHelicopter( type, player_driven, hardpointtype, startnode )
{
	self endon("disconnect"); 
	self endon("game_ended"); 
	team = self.team;

	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointtype, team, undefined, false );
	if ( killstreak_id == -1 )
		return false;

	self.enteringVehicle = true;
	self freeze_player_controls( true );
	
	if ( team != self.team )
	{
		self maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointtype, team, killstreak_id );
		return false;
	}
	
	if ( !IsDefined( self.heli ) )
	{
		heli = spawnPlayerHelicopter( self, type, startnode.origin, startnode.angles, hardpointtype );
		
		if ( !IsDefined( heli ) )
		{
			self freeze_player_controls( false );
			maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointtype, team, killstreak_id );
			self.enteringVehicle = false;
			return false;
		}
		
		self.heli = heli;
		self.heli.killstreak_id = killstreak_id;
	}
	
	//Check the player is still alive before we start
	if( !isalive( self ) )
	{
		// deletePlayerHeli will eventually call killstreak stop
		if( isdefined( self.heli ) )
		{
			self deletePlayerHeli();
		}
		else
		{
			self maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointtype, team, killstreak_id );
		}
		debug_print_heli( ">>>>>>>startHelicopter: player dead while starting" );
		self notify( "heli_timeup" );

		self freeze_player_controls( false );
		self.enteringVehicle = false;
		return false;
	}
	
	if ( level.gameEnded )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointtype, team, killstreak_id );
		self.enteringVehicle = false;
		return false;
	}
	
	self thread initHelicopter( player_driven, hardpointtype );

	self freeze_player_controls( false );
	self.enteringVehicle = false;
	self StopShellshock();

	if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].inboundtext ) )
		level thread maps\mp\_popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
		
	self thread visionSwitch( 0.0 );

	return true;
}

fireHeliWeapon( player )
{
	while ( true )
	{
		self waittill( "turret_fire" );			
		self fireWeapon( "tag_flash" );	
		player PlayRumbleOnEntity( "heavygun_fire" );
		earthquake (0.05, .05, self.origin, 1000);
	}
}

spawnPlayerHelicopter( owner, type, origin, angles, hardpointtype )
{
	debug_print_heli( ">>>>>>>spawnHelicopter " + type );
	
	heli = maps\mp\killstreaks\_helicopter::spawn_helicopter( self, origin, angles, level.chopper_defs[type], level.chopper_models[type]["friendly"], (0,0,-100), hardpointtype );
	
	if (!IsDefined(heli))
		return undefined;

	//Delay SAM turret targeting until the player has a chance to use the chopper
	Target_SetTurretAquire( heli, false );
	//Delay shoulder launchers for player controlled choppers
	heli.lockOnDelay = true;
		
	heli setenemymodel( level.chopper_models[type]["enemy"] );
	heli.chaff_offset = level.chaff_offset[type];
	heli.death_model = level.chopper_death_models[type][owner.team];
	heli playLoopSound( level.chopper_sounds[type][owner.team] );	
	heli.defaultWeapon = "cobra_20mm_mp";
	heli.owner = owner;
	heli.team = owner.team;
	heli setowner(owner);
	heli setteam(owner.team);
	heli.destroyFunc = ::destroyPlayerHelicopter;	
	
	snd_ent = Spawn( "script_origin", heli GetTagOrigin( "snd_cockpit" ) );
	snd_ent LinkTo( heli, "snd_cockpit", (0,0,0), (0,0,0) );
	heli.snd_ent = snd_ent;

	if ( IsDefined( level.chopper_interior_models ) && IsDefined(level.chopper_interior_models[type]) && IsDefined( level.chopper_interior_models[type][owner.team] ) )
	{
		heli.interior_model = spawn("script_model", heli.origin);
		heli.interior_model setmodel(level.chopper_interior_models[type][owner.team]);
		heli.interior_model linkto(heli, "tag_origin", (0,0,0), (0,0,0) );
	}

  heli.killcament = owner;
	
	heli MakeVehicleUnusable();
	
	maps\mp\_treadfx::loadtreadfx(heli);

	return heli;
}


deletePlayerHeli()
{
	self notify( "heli_timeup" );
	debug_print_heli( ">>>>>>>Unlink and delete (deletePlayerHeli)" );
	if ( IsDefined( self.viewlockedentity ) )
		self Unlink();

	self.heli maps\mp\killstreaks\_helicopter::destroyHelicopter();
	
	self.heli = undefined;
}

destroyPlayerHelicopter()
{
	if ( IsDefined( self.owner ) && IsDefined( self.owner.heli ) )
		self.owner deletePlayerHeli();
	else
		self maps\mp\killstreaks\_helicopter::destroyHelicopter();
}

debug_print_heli( msg )
{
/#
	if( GetDvar( "scr_debugheli" ) == "" )
	{
		SetDvar( "scr_debugheli", "0" );
	}

	if ( GetDvarint( "scr_debugheli") == 1 )
	{
		PrintLn( msg );
	} 
#/
}


///////////////////////////////////////////////////////////////////////////////////////
//	Player Helicopter
///////////////////////////////////////////////////////////////////////////////////////
initHelicopter( isDriver, hardpointtype )
{
	//Setup helicopter
	// TO DO: convert all helicopter attributes into dvars
	self.heli.reached_dest = false;							// has helicopter reached destination
	switch( hardpointtype )
	{
	case "helicopter_gunner_mp":
		self.heli.maxhealth = level.heli_amored_maxhealth;				// max health
		break;
	case "helicopter_player_firstperson_mp":
		self.heli.maxhealth = level.heli_amored_maxhealth;				// max health
		break;
	case "helicopter_player_gunner_mp":
		self.heli.maxhealth = level.heli_amored_maxhealth;				// max health
		break;
	default:
		self.heli.maxhealth = level.heli_amored_maxhealth;				// max health
		break;
	}
	self.heli.rocketDamageOneShot = self.heli.maxhealth + 1;		// Make it so the heatseeker blows it up in one hit
	self.heli.rocketDamageTwoShot = (self.heli.maxhealth / 2) + 1;	// Make it so the heatseeker blows it up in two hit
	self.heli.numFlares = 3;										// put to 1 for all helicopters, 2 was too much
	self.heli.nflareOffset = (0,0,-256);								// offset from vehicle to start the flares
	self.heli.waittime = 0;									// the time helicopter will stay stationary at destination
	self.heli.loopcount = 0; 								// how many times helicopter circled the map
	self.heli.evasive = false;								// evasive manuvering
	self.heli.health_bulletdamageble = level.heli_armor;	// when damage taken is above this value, helicopter can be damage by bullets to its full amount
	self.heli.health_evasive = level.heli_armor;			// when damage taken is above this value, helicopter performs evasive manuvering
	self.heli.health_low = self.heli.maxhealth*0.8;			// when damage taken is above this value, helicopter catchs on fire
	self.heli.targeting_delay = level.heli_targeting_delay;	// delay between per targeting scan - in seconds
	self.heli.primaryTarget = undefined;					// primary target ( player )
	self.heli.secondaryTarget = undefined;					// secondary target ( player )
	self.heli.attacker = undefined;							// last player that shot the helicopter
	self.heli.missile_ammo = level.heli_missile_max;		// initial missile ammo
	self.heli.currentstate = "ok";							// health state
	self.heli.lastRocketFireTime = -1;
	self.heli.maxlifetime = 60*1000;						// 60 secs
	self.heli.doNotStop = 1;								// Do not stop at nodes with a script_delay

	self.heli.health = 99999999;
	self.heli setturningability( 1 );
	self.heli.starttime = gettime();
	
	self.heli.startingteam = self.team;
	self.heli.startinggametype = level.gameType;

	//Setup weapons
	if( isDriver )
	{
		self.heli thread hind_setup_rocket_attack( hardpointtype, self );
		self.heli thread hind_watch_rocket_fire( self );
		self.heli.current_weapon = "mini_gun";
		if ( hardpointtype == "helicopter_player_firstperson_mp" )
			self.heli SetVehWeapon( "hind_minigun_pilot_firstperson_mp" );
		else
			self.heli SetVehWeapon( "hind_minigun_pilot_2_mp" );
		self.heli.numberRockets = 2;
		self.heli.numberMiniGun = 999;
	
		//Set helicopter jitter parameters
		self.heli setjitterparams( (3,3,3), 0.5, 1.5 );
	}
	else
	{
		self.heli.numberRockets = 4;
		self.heli.rocketRegenTime = 3;
		self.heli.rocketReloadTime = 6;
		self.heli.rocketRefireTime = .15;
		//self.heli thread rocket_ammo_think( self );
	}
	
	//Create HUD
	self create_hud( isDriver );
	if (!isDriver)
	{
		self create_gunner_hud();
	}

	self thread watchForEarlyLeave(hardpointtype);
	self thread waitForTimeOut(hardpointtype);
	self thread exitHeliWaiter();
	self thread gameEndHeliWaiter(hardpointtype);

	self.heli thread maps\mp\killstreaks\_helicopter::heli_damage_monitor( hardpointtype );		// monitors damage
	self.heli thread maps\mp\killstreaks\_helicopter::heli_kill_monitor( hardpointtype );		// monitors damage
	self.heli thread maps\mp\_heatseekingmissile::MissileTarget_LockOnMonitor( self, "crashing", "leaving" );				// monitors missle lock-ons
	self.heli thread maps\mp\_heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing", "leaving");			// fires chaff if needed
	self.heli maps\mp\gametypes\_spawning::create_helicopter_influencers( self.team );
	self.heli thread heli_player_damage_monitor( self );
	self.heli thread heli_health_player( self, hardpointtype );							// display helicopter's health through smoke/fire	

	self.heli thread debugTags();
}

player_heli_reset()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self setspeed( 45, 25 );	
	self setyawspeed( 75, 45, 45 );
	self setmaxpitchroll( 30, 40 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.3);
}

visionSwitch( delay )
{
	self endon( "disconnect" );
	self.heli endon("crashing");
	self.heli endon("leaving");
	self.heli endon("death");
	
	wait( delay	);

	inverted = false;
	
	self SetInfraredVision( false );
	self UseServerVisionset( true );
	self SetVisionSetForPlayer( level.chopper_enhanced_vision, 1 );
	self SetClientFlag( CLIENT_FLAG_OPERATING_CHOPPER_GUNNER );
	self ClientNotify( "cgfutz" );

	for (;;)
	{
		if ( self UseButtonPressed() )
		{
			if ( !inverted )
			{
				self SetInfraredVision( true );
				self SetVisionSetForPlayer( level.chopper_infrared_vision, 0.5 );
				self playsoundtoplayer ( "mpl_cgunner_flir_on", self );
				//self SetClientField("player_is_gunner", 1);				
				
			}
			else
			{
				self SetInfraredVision( false );
				self SetVisionSetForPlayer( level.chopper_enhanced_vision, 0.5 );
				self playsoundtoplayer ( "mpl_cgunner_flir_off", self );
				//self SetClientField("player_is_gunner", 0);		
			}

			inverted = !inverted;
			
			// wait for the button to release:
			while ( self UseButtonPressed() )
				wait( 0.05 );
		}
		wait( 0.05 );
	}
}

hind_setup_rocket_attack( hardpointtype, player )
{
	wait 1;
	
	self endon( "death" );
	self endon("heli_timeup");
	self notify( "stop_turret_shoot" );
	self endon( "stop_turret_shoot" );
	
	index = 0;
	while( isdefined(self) && (self.health > 0) )
	{
		self waittill( "turret_fire" );
		if( self.current_weapon == "rockets" )
		{
			if( self.numberRockets>0 )
			{
				self fireWeapon( "tag_flash" );
				self.numberRockets = self.numberRockets - 1;
				if ( isdefined( player.alt_ammo_hud ) )
					player.alt_ammo_hud SetValue(self.numberRockets);
			}
			else if( self.numberMiniGun>0 )
			{
				//If we have ammo in the mingun then switch to it and fire
				if ( hardpointtype == "helicopter_player_firstperson_mp" )
					self.heli SetVehWeapon( "hind_minigun_pilot_firstperson_mp" );
				else
					self.heli SetVehWeapon( "hind_minigun_pilot_2_mp" );
				self.current_weapon = "mini_gun";
				self fireWeapon();
				self.numberMiniGun = self.numberMiniGun - 1;
				if ( isdefined( player.ammo_hud ) )
					player.ammo_hud SetValue(self.numberMiniGun);
			}

 			wait 0.3;
		}
		else
		{
			if(self.numberMiniGun>0 )
			{
				self SetVehWeapon( "hind_minigun_pilot_firstperson_mp" );
				self fireWeapon( "tag_flash" );
				self.numberMiniGun = self.numberMiniGun - 1;
				if ( isdefined( player.ammo_hud ) )
					player.ammo_hud SetValue(self.numberMiniGun);
			}
		}
	}
}

rocket_ammo_think( player )
{
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	
	while ( true )
	{
		while (self.numberRockets == 4)
			wait (0.05);
		wait ( self.rocketRegenTime );
		self.numberRockets++;
	}
}

hind_watch_rocket_fire( player )
{
	wait 1;
	
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	self endon ( "crashing" );
	self endon ( "leaving" );
	
	rocketTags = [];
	rocketTags[0] = "tag_rocket1";
	rocketTags[1] = "tag_rocket3";
	rocketTags[2] = "tag_rocket2";
	rocketTags[3] = "tag_rocket4";
	
	rocketTag = 0;
	while( isdefined(self) && (self.health > 0) )
	{
		player.missile_hud SetText("[{+frag}]" + "Fire Missiles");
		
		while ( !player FragButtonPressed() )
			wait 0.05;
		
		player.missile_hud SetText("");
		while ( self.numberRockets > 0 )
		{
			self fire_rocket( rocketTags[rocketTag], player );
			self.numberRockets--;
			if ( isdefined( player.alt_ammo_hud ) )
				player.alt_ammo_hud SetValue(self.numberRockets);
			
			rocketTag = ( rocketTag + 1 ) % rocketTags.size;
			wait self.rocketRefireTime;
		}
		
		wait self.rocketReloadTime;
		self.numberRockets = 4;
	}
}

hind_out_of_rockets(player)
{
	player endon( "disconnect" );
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	
	if ( isdefined( player.alt_title ) )
		player.alt_title.alpha = 0.0;
	if ( isdefined( player.alt_ammo_hud ) )
		player.alt_ammo_hud.alpha = 0.0;
	
	wait( max( 0, level.heli_missile_reload_time - 0.5 ) );
	
	// kick of reload sound here
	self.snd_ent PlaySound(level.chopper_sounds["missile_reload"]);

	wait( 0.5 );

	if ( isdefined( player.alt_title ) )
		player.alt_title.alpha = 1.0;
	if ( isdefined( player.alt_ammo_hud ) )
		player.alt_ammo_hud.alpha = 1.0;
	self.numberRockets = 2;
	if ( isdefined( player.alt_ammo_hud ) )
		player.alt_ammo_hud SetValue(2);
}

fire_rocket( tagName, player )
{
	start_origin = self GetTagOrigin( tagName );
	trace_angles = self GetTagAngles( "tag_flash" );
	forward = AnglesToForward( trace_angles );
	
	trace_origin = self GetTagOrigin( "tag_flash" );
	trace_direction = self GetTagAngles( "tag_barrel" );
	trace_direction = AnglesToForward( trace_direction ) * 5000;
	trace = BulletTrace( trace_origin, trace_origin + trace_direction, false, self );
	end_origin = trace["position"];
	
	
	MagicBullet( "heli_gunner_rockets_mp", start_origin, end_origin, self );
	player playlocalsound("wpn_gunner_rocket_fire_plr");
//	player playlocalsound("wpn_rpg_fire_plr");
	self playsound("wpn_rpg_fire_npc");
	player PlayRumbleOnEntity( "damage_heavy" );
	Earthquake( 0.35, 0.5, start_origin, 1000, self );
}

create_gunner_hud()
{
	self.minigun_hud = newclienthudelem( self );
	self.minigun_hud.alignX = "left";
	self.minigun_hud.alignY = "bottom";
	self.minigun_hud.horzAlign = "user_left";
	self.minigun_hud.vertAlign = "user_bottom";
	self.minigun_hud.foreground = true;
	self.minigun_hud.font = "small";
	self.minigun_hud SetText("[{+attack}]" + "Fire Minigun");
	self.minigun_hud.hidewheninmenu = true;
	
	if (level.ps3)
	{
		self.minigun_hud.x = 30;
		self.minigun_hud.y = -55;
		self.minigun_hud.fontscale = 1.25;
	}
	else
	{
		self.minigun_hud.x = 28;
		self.minigun_hud.y = -55;
		self.minigun_hud.fontscale = 1.25;
	}
	
	self.missile_hud = newclienthudelem( self );
	self.missile_hud.alignX = "left";
	self.missile_hud.alignY = "bottom";
	self.missile_hud.horzAlign = "user_left";
	self.missile_hud.vertAlign = "user_bottom";
	self.missile_hud.foreground = true;
	self.missile_hud.font = "small";
	self.missile_hud SetText("");
	self.missile_hud.hidewheninmenu = true;
	
	if (level.ps3)
	{
		self.missile_hud.x = 30;
		self.missile_hud.y = -25;
		self.missile_hud.fontscale = 1.25;
	}
	else
	{
		self.missile_hud.x = 28;
		self.missile_hud.y = -25;
		self.missile_hud.fontscale = 1.25;
	}
	
	self.zoom_hud = newclienthudelem( self );
	self.zoom_hud.alignX = "left";
	self.zoom_hud.alignY = "bottom";
	self.zoom_hud.horzAlign = "user_left";
	self.zoom_hud.vertAlign = "user_bottom";
	self.zoom_hud.foreground = true;
	self.zoom_hud.font = "small";
	self.zoom_hud SetText(&"KILLSTREAK_INCREASE_ZOOM");
	self.zoom_hud.hidewheninmenu = true;
	
	if (level.ps3)
	{
		self.zoom_hud.x = 30;
		self.zoom_hud.y = -40;
		self.zoom_hud.fontscale = 1.25;
	}
	else
	{
		self.zoom_hud.x = 28;
		self.zoom_hud.y = -40;
		self.zoom_hud.fontscale = 1.25;
	}
	
	self.move_hud = newclienthudelem( self );
	self.move_hud.alignX = "left";
	self.move_hud.alignY = "bottom";
	self.move_hud.horzAlign = "user_left";
	self.move_hud.vertAlign = "user_bottom";
	self.move_hud.foreground = true;
	self.move_hud.font = "small";
	self.move_hud SetText("");
	self.move_hud.hidewheninmenu = true;
	
	if (level.ps3)
	{
		self.move_hud.x = 30;
		self.move_hud.y = -10;
		self.move_hud.fontscale = 1.25;
	}
	else
	{
		self.move_hud.x = 28;
		self.move_hud.y = -10;
		self.move_hud.fontscale = 1.25;
	}
	
	self thread fade_out_hint_hud();
}

fade_out_hint_hud()
{
	wait( 8 );
	time = 0;
	while (time < 2)
	{
		if ( !isDefined(self.minigun_hud))
		{
			return;	
		}
		self.minigun_hud.alpha -= 0.025;
		self.zoom_hud.alpha -= 0.025;
		time += 0.05;
		wait (0.05);
	}
	
	if ( !isDefined(self.minigun_hud) )
	{
		return;
	}
	self.minigun_hud.alpha = 0;
	self.zoom_hud.alpha = 0;
}

create_hud( isDriver )
{
	debug_print_heli( ">>>>>>>create_hud" );
	if( isDriver )
	{		
		hud_minigun_create();
		hud_rocket_create();
	
		self.leaving_play_area = newclienthudelem( self );
		self.leaving_play_area.fontScale = 1.25;
		self.leaving_play_area.x = 0;
		self.leaving_play_area.y = 50; 
		self.leaving_play_area.alignX = "center";
		self.leaving_play_area.alignY = "top";
		self.leaving_play_area.horzAlign = "user_center";
		self.leaving_play_area.vertAlign = "user_top";
		self.leaving_play_area.foreground = true;
		self.leaving_play_area.hidewhendead = false;
		self.leaving_play_area.hidewheninmenu = true;
		self.leaving_play_area.archived = false;
		self.leaving_play_area.alpha = 0.0;
		self.leaving_play_area SetText( &"MP_HELI_LEAVING_BATTLEFIELD" );
	}
}

remove_hud()
{
	debug_print_heli( ">>>>>>>remove_hud" );
	if ( isdefined( self.ammo_hud ) )
		self.ammo_hud destroy();
	if( isdefined(self.title) )				
		self.title destroy();
	if ( isdefined( self.alt_ammo_hud ) )
		self.alt_ammo_hud destroy();
	if ( isdefined( self.alt_title ) )
		self.alt_title destroy();
	if( isdefined(self.leaving_play_area) )
		self.leaving_play_area destroy();
	if ( isdefined(self.minigun_hud) )
		self.minigun_hud destroy();
	if ( isdefined(self.missile_hud) )
		self.missile_hud destroy();
	if ( isdefined(self.zoom_hud) )
		self.zoom_hud destroy();
	if ( isdefined(self.move_hud) )
		self.move_hud destroy();
			
	self.ammo_hud = undefined;
	self.alt_ammo_hud = undefined;
	self.alt_title = undefined;
	self.leaving_play_area = undefined;
	
	self ClearClientFlag( CLIENT_FLAG_OPERATING_CHOPPER_GUNNER );
	self ClientNotify( "nofutz" );
	
	self notify("hind weapons disabled");
}


gameEndHeliWaiter( hardpointtype )
{
	self endon("disconnect"); 
	self endon("heli_timeup");
	level waittill("game_ended");
	
	debug_print_heli( ">>>>>>>gameEndHeliWaiter" );
	self thread player_heli_leave( hardpointtype );
}

exitHeliWaiter()
{ 
	self endon("disconnect");
	
	self waittill("heli_timeup");
	debug_print_heli( ">>>>>>>exitHeliWaiter" );
	self remove_hud();
	if( isdefined( self.heli ) )
	{
		debug_print_heli( ">>>>>>>Unlink and delete (exitHeliWaiter)" );
		if ( IsDefined( self.viewlockedentity ) )
		{
			self Unlink();
			if ( isdefined(level.gameEnded) && level.gameEnded )
			{
				self freezecontrolswrapper( true );
			}
		}
		self.heli = undefined;
	}
	self SetInfraredVision( false );
	self UseServerVisionset( false );
	self.killstreak_waitamount = undefined;
	
	//Check to see if we are carring an item
	if ( isDefined( self.carryIcon ) )
	{
		self.carryIcon.alpha = self.prevCarryIconAlpha;
	}
	
	if ( isdefined( self ) )
		self clearUsingRemote();
}

heli_player_damage_monitor( player )
{
	player endon( "disconnect" );
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
	
	for( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, type );
		
		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;
			
		heli_friendlyfire = maps\mp\gametypes\_weaponobjects::friendlyFireCheck( self.owner, attacker );
		
		// skip damage if friendlyfire is disabled
		if( !heli_friendlyfire )
			continue;
			
		if ( !level.hardcoreMode )
		{
			if(	isDefined( self.owner ) && attacker == self.owner )
				continue;
			
			if ( level.teamBased )
				isValidAttacker = (isdefined( attacker.team ) && attacker.team != self.team);
			else
				isValidAttacker = true;
	
			if ( !isValidAttacker )
				continue;
		}
		
		if ( type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET" )
		{
			earthquake( 0.1, 0.5, point, 1000, player );
		}
		
		if( type == "MOD_PROJECTILE" )
		{
			earthquake( 0.7, 1.5, point, 1000, player );
		}
	}
}

heli_health_player( player, hardpointtype )
{
	//Check the player is still alive before we start
	if( !isalive( player ) )
	{
		if( isdefined( self.heli ) )
		{
			self deletePlayerHeli();
		}
	
		debug_print_heli( ">>>>>>>send notify [dead before starting]" );
		player notify( "heli_timeup" );
	}
	
	self thread maps\mp\killstreaks\_helicopter::heli_health(hardpointtype, player, "heli_timeup");			
}



debugtag(tagName)
{
	/#
	start_origin = self GetTagOrigin( tagName );
	if ( IsDefined( start_origin ) )
	{
		sphere( start_origin, 5, (1,0,0), 1, true, 10, 1 );
	}
	#/
}

debugTags()
{
	self endon("death");
	while(1)
	{
		wait(0.05);
		tagName = GetDvar( "tagname" );
		if ( !IsDefined(tagName) || tagname == "" )
			continue;
		self debugTag(tagName);
	}
}


hud_minigun_create()
{
	
	if(!IsDefined(self.minigun_hud))
	{
		self.minigun_hud = [];
	}
	
	self.minigun_hud["gun"] = newclienthudelem( self );
	self.minigun_hud["gun"].alignX = "right";
	self.minigun_hud["gun"].alignY = "bottom";
	self.minigun_hud["gun"].horzAlign = "user_right";
	self.minigun_hud["gun"].vertAlign = "user_bottom";
	self.minigun_hud["gun"].alpha = 0.55;
	self.minigun_hud["gun"] fadeOverTime( 0.05 );
	self.minigun_hud["gun"].y = 0;
	self.minigun_hud["gun"].x = 23;
	self.minigun_hud["gun"] SetShader( "hud_hind_cannon01", 64, 64 );
	self.minigun_hud["gun"].hidewheninmenu = true;
	
	self.minigun_hud["button"] = newclienthudelem( self );
	self.minigun_hud["button"].alignX = "right";
	self.minigun_hud["button"].alignY = "bottom";
	self.minigun_hud["button"].horzAlign = "user_right";
	self.minigun_hud["button"].vertAlign = "user_bottom";
	self.minigun_hud["button"].foreground = true;
	self.minigun_hud["button"].font = "small";
	self.minigun_hud["button"] SetText("[{+attack}]");
	self.minigun_hud["button"].hidewheninmenu = true;
	
	if (level.ps3)
	{
		self.minigun_hud["button"].x = -30;
		self.minigun_hud["button"].y = -4;
		self.minigun_hud["button"].fontscale = 1.25;
	}
	else
	{
		self.minigun_hud["button"].x = -28;
		self.minigun_hud["button"].y = -6;
		self.minigun_hud["button"].fontscale = 1.0;
	}

//	self thread hud_minigun_think();	
	self thread hud_minigun_destroy();
}

hud_minigun_destroy()
{
	self waittill("hind weapons disabled");
	
	self.minigun_hud["gun"] Destroy();
	self.minigun_hud["button"] Destroy();
}

hud_minigun_think()
{
	self endon("hind weapons disabled");
	self endon("disconnect");
	
	player = GET_PLAYERS()[0];
	
	while(1)
	{
		while(!player AttackButtonPressed())
		{
			wait(0.05);
		}
			
		swap_counter = 1;
		self.minigun_hud["gun"] fadeOverTime( 0.05 );
		self.minigun_hud["gun"].alpha = 0.65;
	
		while(player AttackButtonPressed())
		{
			wait(0.05);
			player playloopsound( "wpn_hind_minigun_fire_plr_loop" );
			
			self.minigun_hud["gun"] SetShader( "hud_hind_cannon0" + swap_counter, 64, 64 );
			
			if(swap_counter == 5)
			{
				swap_counter = 1;
			}
			else
			{
				swap_counter++;	
			}
		}
		
		self.minigun_hud["gun"] SetShader( "hud_hind_cannon01", 64, 64 );
		self.minigun_hud["gun"] fadeOverTime( 0.05 );
		self.minigun_hud["gun"].alpha = 0.55;
		player stoploopsound(.048);
		//player playsound( "wpn_huey_toda_minigun_fire_npc_end" );
	}
}

hud_rocket_create()
{
	if(!IsDefined(self.rocket_hud))
	{
		self.rocket_hud = [];
	}
	
	self.rocket_hud["border"] = newclienthudelem( self );
	self.rocket_hud["border"].alignX = "left";
	self.rocket_hud["border"].alignY = "bottom";
	self.rocket_hud["border"].horzAlign = "user_left";
	self.rocket_hud["border"].vertAlign = "user_bottom";
	self.rocket_hud["border"].y = -6;
	self.rocket_hud["border"].x = 2;
	self.rocket_hud["border"].alpha = 0.55;
	self.rocket_hud["border"] fadeOverTime( 0.05 );
	self.rocket_hud["border"] SetShader( "hud_hind_rocket_border_small", 20, 5 );
	self.rocket_hud["border"].hidewheninmenu = true;
		
	self.rocket_hud["loading_border"] = newclienthudelem( self );
	self.rocket_hud["loading_border"].alignX = "left";
	self.rocket_hud["loading_border"].alignY = "bottom";
	self.rocket_hud["loading_border"].horzAlign = "user_left";
	self.rocket_hud["loading_border"].vertAlign = "user_bottom";
	self.rocket_hud["loading_border"].y = -2;
	self.rocket_hud["loading_border"].x = 2;
	self.rocket_hud["loading_border"].alpha = 0.55;
	self.rocket_hud["loading_border"] fadeOverTime( 0.05 );
	self.rocket_hud["loading_border"] SetShader( "hud_hind_rocket_loading", 20, 5 );
	self.rocket_hud["loading_border"].hidewheninmenu = true;

	self.rocket_hud["loading_bar"] = newclienthudelem( self );
	self.rocket_hud["loading_bar"].alignX = "left";
	self.rocket_hud["loading_bar"].alignY = "bottom";
	self.rocket_hud["loading_bar"].horzAlign = "user_left";
	self.rocket_hud["loading_bar"].vertAlign = "user_bottom";
	self.rocket_hud["loading_bar"].y = -2;
	self.rocket_hud["loading_bar"].x = 2;
	self.rocket_hud["loading_bar"].alpha = 0.55;
	self.rocket_hud["loading_bar"] fadeOverTime( 0.05 );
	self.rocket_hud["loading_bar"].width = 20;
	self.rocket_hud["loading_bar"].height = 5;
	self.rocket_hud["loading_bar"].shader = "hud_hind_rocket_loading_fill";
	self.rocket_hud["loading_bar"] SetShader( "hud_hind_rocket_loading_fill", 20, 5 );
	self.rocket_hud["loading_bar"].hidewheninmenu = true;

 	// fake hud element so we can call updatebar()
	self.rocket_hud["loading_bar_bg"] = SpawnStruct();
	self.rocket_hud["loading_bar_bg"].elemType = "bar";
	self.rocket_hud["loading_bar_bg"].bar = self.rocket_hud["loading_bar"];
	self.rocket_hud["loading_bar_bg"].width = 20;
	self.rocket_hud["loading_bar_bg"].height = 5;

	self.rocket_hud["ammo1"] = newclienthudelem( self );
	self.rocket_hud["ammo1"].alignX = "left";
	self.rocket_hud["ammo1"].alignY = "bottom";
	self.rocket_hud["ammo1"].horzAlign = "user_left";
	self.rocket_hud["ammo1"].vertAlign = "user_bottom";
	self.rocket_hud["ammo1"].alpha = 0.55;
	self.rocket_hud["ammo1"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo1"].y = -10;
	self.rocket_hud["ammo1"].x = -7;
	self.rocket_hud["ammo1"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo1"].hidewheninmenu = true;
	
	self.rocket_hud["ammo2"] = newclienthudelem( self );
	self.rocket_hud["ammo2"].alignX = "left";
	self.rocket_hud["ammo2"].alignY = "bottom";
	self.rocket_hud["ammo2"].horzAlign = "user_left";
	self.rocket_hud["ammo2"].vertAlign = "user_bottom";
	self.rocket_hud["ammo2"].alpha = 0.55;
	self.rocket_hud["ammo2"] fadeOverTime( 0.05 );
	self.rocket_hud["ammo2"].y = -10;
	self.rocket_hud["ammo2"].x = -18;
	self.rocket_hud["ammo2"] SetShader( "hud_hind_rocket", 48, 48 );
	self.rocket_hud["ammo2"].hidewheninmenu = true;

	self.rocket_hud["button"] = newclienthudelem( self );
	self.rocket_hud["button"].alignX = "left";
	self.rocket_hud["button"].alignY = "bottom";
	self.rocket_hud["button"].horzAlign = "user_left";
	self.rocket_hud["button"].vertAlign = "user_bottom";
	self.rocket_hud["button"].foreground = true;
	self.rocket_hud["button"].font = "small";
	self.rocket_hud["button"] SetText("[{+speed_throw}]");
	self.rocket_hud["button"].hidewheninmenu = true;

	if (level.ps3)
	{
		self.rocket_hud["button"].x = 25;
		self.rocket_hud["button"].y = -4;
		self.rocket_hud["button"].fontscale = 1.25;
	}
	else
	{
		self.rocket_hud["button"].x = 23;
		self.rocket_hud["button"].y = -6;
		self.rocket_hud["button"].fontscale = 1;
	}
	
	self thread hud_rocket_think();
	self thread hud_rocket_destroy();
}

hud_rocket_destroy()
{
	self waittill("hind weapons disabled");

	self.rocket_hud["border"] Destroy();
	self.rocket_hud["loading_border"] Destroy();
	self.rocket_hud["loading_bar"] Destroy();
	self.rocket_hud["ammo1"] Destroy();
	self.rocket_hud["button"] Destroy();
	self.rocket_hud["ammo2"] Destroy();
}

hud_rocket_think()
{
	self endon("hind weapons disabled");
	self endon("disconnect");
	
	last_rocket_count = self.heli.numberRockets;
	while(1)
	{
		for(i = 1; i < 3; i++ )
		{
			if( i - 1 <  self.heli.numberRockets )
			{
				//-- rocket exists, but not armed
				self.rocket_hud["ammo" + i] SetShader( "hud_hind_rocket", 48, 48 );
				self.rocket_hud["ammo" + i].alpha = 0.55;
				self.rocket_hud["ammo" + i] fadeOverTime( 0.05 );
			}
			else
			{
				//-- no rocket
				self.rocket_hud["ammo" + i] SetShader( "hud_hind_rocket", 48, 48 );
				self.rocket_hud["ammo" + i].alpha = 0;
				self.rocket_hud["ammo" + i] fadeOverTime( 0.05 );					
			}			
		}
		
		if ( last_rocket_count != self.heli.numberRockets )
		{
			if ( self.heli.numberRockets == 0 )
				rateOfChange = level.heli_missile_reload_time;
			
			last_rocket_count = self.heli.numberRockets;
			self.rocket_hud["loading_bar_bg"] updateAmmoBarScale( self.heli.numberRockets * 0.5 );

			if ( self.heli.numberRockets == 0 )
			{
				rateOfChange = level.heli_missile_reload_time;
				self.rocket_hud["loading_bar_bg"] updateAmmoBarScale( 1, rateOfChange );
			}
		}
		wait(0.05);
	}
}

updateAmmoBarScale( barFrac, rateOfChange ) 
{
	barWidth = int(self.width * barFrac + 0.5); // (+ 0.5 rounds)
	
	if ( !barWidth )
		barWidth = 1;
	
	//if barWidth is bigger than self.width then we are drawing more than 100%
	if ( isDefined( rateOfChange ) && barWidth <= self.width ) 
	{
			self.bar scaleOverTime( rateOfChange, barWidth, self.height );
	}
	else
	{
			self.bar setShader( self.bar.shader, barWidth, self.height );
	}
}


player_heli_leave(hardpointtype)
{
	self endon( "heli_timeup" );
	self.heli thread maps\mp\killstreaks\_helicopter::heli_leave( hardpointtype );
	//play some leave dialog
	//self thread PlayPilotDialog( "attackheli_leave", .5 );
	wait(0.1);
	debug_print_heli( ">>>>>>>player_heli_leave" );
	self notify( "heli_timeup" );
}

waitForTimeOut(hardpointtype)
{ 
	self endon("disconnect"); 
	self endon("heli_timeup");
	self.heli endon("death");
	
	self.killstreak_waitamount = self.heli.maxlifetime;
	//Check for helicopter exit
	while(1)
	{
		//Calculate time left in helicopter
		timeleft = ( self.heli.maxlifetime - (gettime()-self.heli.starttime) );
		
		//Check for timeout or to see if owner has switched teams
		if( timeleft <= 0 )
		{
			player_heli_leave(hardpointtype);
			
			debug_print_heli( ">>>>>>>send notify [exit_vehicle***heli_timeup] TIMEUP!!!!!!!!!!!!!!" );
		}
		
		wait(0.1);
	}
}

debugCheckForExit(hardpointtype)
{
	/#
	self endon("disconnect"); 
	self endon("heli_timeup");
	
	if( IsDefined( self.pers["isBot"] ) && self.pers["isBot"] )	
		return;

	//Check for helicopter exit
	while(1)
	{
		if( self UseButtonPressed() )
		{
			player_heli_leave(hardpointtype);

			debug_print_heli( ">>>>>>>send notify [exit_vehicle***heli_timeup]" );
			return;
		}
		wait(0.1);
	}
	#/
}
PlayPilotDialog( dialog, time )
{

	if (IsDefined(time))
	{
		wait time;
	}
	if (!IsDefined(self.pilotVoiceNumber))
	{
	  self.pilotVoiceNumber = 0;  	
	}
	soundAlias = level.teamPrefix[self.team] + self.pilotVoiceNumber + "_" + dialog;
	self playLocalSound(soundAlias);
}

