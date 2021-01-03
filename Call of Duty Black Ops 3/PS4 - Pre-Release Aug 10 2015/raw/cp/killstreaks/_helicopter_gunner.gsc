#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_spawning;

#using scripts\cp\_util;
#using scripts\cp\killstreaks\_helicopter;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;

                                             

#precache( "string", "KILLSTREAK_EARNED_HELICOPTER_GUNNER" );
#precache( "string", "KILLSTREAK_HELICOPTER_GUNNER_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_HELICOPTER_GUNNER_INBOUND" );
#precache( "eventstring", "mpl_killstreak_osprey_strt" );
#precache( "fx", "_t6/vehicle/treadfx/fx_heli_dust_default" );
#precache( "fx", "_t6/vehicle/treadfx/fx_heli_dust_concrete" );
#precache( "fx", "_t6/vehicle/treadfx/fx_heli_water_spray" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_huey_engine" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_vtol_mp" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_vtol_rt_mp" );
#precache( "fx", "_t6/light/fx_vlight_mp_vtol_grn" );
#precache( "fx", "_t6/light/fx_vlight_mp_vtol_red" );

#using_animtree ( "mp_vehicles" );

#namespace helicopter_gunner;

function init()
{
	killstreaks::register( "helicopter_player_gunner", "helicopter_player_gunner", "killstreak_helicopter_player_gunner", "helicopter_used",&heli_gunner_killstreak, true) ;
	killstreaks::register_strings( "helicopter_player_gunner", &"KILLSTREAK_EARNED_HELICOPTER_GUNNER", &"KILLSTREAK_HELICOPTER_GUNNER_NOT_AVAILABLE", &"KILLSTREAK_HELICOPTER_GUNNER_INBOUND" );
	killstreaks::register_dialog( "helicopter_player_gunner", "mpl_killstreak_osprey_strt", "kls_playerheli_used", "","kls_playerheli_enemy", "", "kls_playerheli_ready" );
	killstreaks::register_dev_dvar( "helicopter_player_gunner", "scr_givehelicopter_player_gunner" );
	killstreaks::register_alt_weapon( "helicopter_player_gunner", "cobra_minigun" );
	killstreaks::register_alt_weapon( "helicopter_player_gunner", "heli_gunner_rockets" );
	killstreaks::register_alt_weapon( "helicopter_player_gunner", "chopper_minigun" );
	killstreaks::set_team_kill_penalty_scale( "helicopter_player_gunner", level.teamKillReducedPenalty );
	killstreaks::override_entity_camera_in_demo("helicopter_player_gunner", true);
	
	level._effect["heli_gunner"]["vtol_fx"] = "_t6/vehicle/exhaust/fx_exhaust_vtol_mp";
	level._effect["heli_gunner"]["vtol_fx_rt"] = "_t6/vehicle/exhaust/fx_exhaust_vtol_rt_mp";
	
	level.chopper_defs["player_gunner"] = "heli_player_gunner_mp";
	level.chopper_models["player_gunner"]["friendly"] = "veh_t6_air_v78_vtol_killstreak";
	level.chopper_models["player_gunner"]["enemy"] = "veh_t6_air_v78_vtol_killstreak_alt";

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

	level.chopper_infrared_vision = "remote_mortar_infrared";
	level.chopper_enhanced_vision = "remote_mortar_enhanced";
		
	level._effect["heli_gunner_light"]["friendly"] = "_t6/light/fx_vlight_mp_vtol_grn";
	level._effect["heli_gunner_light"]["enemy"] = "_t6/light/fx_vlight_mp_vtol_red";


	level.heliGunnerVtolUpAnim = %veh_anim_v78_vtol_engine_left;
	level.heliGunnerVtolDownAnim = %veh_anim_v78_vtol_engine_right;
		
	level.heli_angle_offset = 90;
	level.heli_forced_wait	= 0;
}

function heli_gunner_killstreak( hardpointType )
{
	assert( hardpointType == "helicopter_player_gunner" );

	if ( !isdefined( level.heli_paths ) || !level.heli_paths.size )
	{
/#		println( "No helicopter paths found in map" );	#/
		return false;
	}

	if ( !isdefined( level.Heli_primary_path ) || !level.heli_primary_path.size )
	{
/#		println( "No primary helicopter path found in map" );	#/
		return false;
	}

	if ( !self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
	{
		return false;
	}
	
	if ( ( isdefined( self.isPlanting ) && self.isPlanting ) )
	{
		return false;
	}
	
	if ( ( isdefined( self.isDefusing ) && self.isDefusing ) )
	{
		return false;
	}

	if (!self IsOnGround() || self util::isUsingRemote() )
	{
		self iPrintLnBold( &"KILLSTREAK_CHOPPER_GUNNER_NOT_USABLE" );
		return false;
	}

	result = self heli_gunner_spawn( hardpointType );
	
	if ( level.gameEnded )
	{
		return true;	
	}
	
	if( !isdefined(result) )
	{
		return false;
	}

	return result;
}

function heli_gunner_spawn( hardpointType )
{
	self endon("disconnect");
	level endon("game_ended");
	
	self util::setUsingRemote( hardpointType );
	result = self killstreaks::init_ride_killstreak( "qrdrone" );	
	
	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			self killstreaks::clear_using_remote();
		}
		return false;
	}	
	if ( !self startHelicopter( "player_gunner", false, hardpointtype, level.heli_primary_path[0] ) ) 
	{
		self killstreaks::clear_using_remote();
		return false;
	}

	//Check to see if we are carring an item
	if ( isdefined( self.carryIcon ) )
	{
		//Yes we are so fade it out while in the helicopter
		self.prevCarryIconAlpha = self.carryIcon.alpha;
		self.carryIcon.alpha = 0.0;
	}

	self thread helicopter::announceHelicopterInbound( hardpointType );

	self.heli helicopter::heli_reset();
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
		self.heli thread helicopter::heli_fly( level.heli_primary_path[0], 0.0, hardpointtype );
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
	
	//It is possible for the helicopter ent to get removed if the player changes teams during the wait.
	if( !isdefined( self.heli ) )
	{
		return false;
	}

	self.heli thread fireHeliWeapon( self );
	self.heli thread hind_watch_rocket_fire( self );
	self.heli thread look_with_player( self );
	self.heli thread play_lockon_sounds( self );

	//Allow SAM turret to target chopper
	Target_SetTurretAquire( self.heli, true );
	self.heli.lockOnDelay = false;

	self.heli util::waittill_any( "death", "leaving", "abandoned" );

	if ( isdefined( self.heli ) && isdefined( self.heli.targetEnt ) )
	{
		self.heli.targetEnt delete();
	}
	return true;
}

function play_lockon_sounds( player )
{
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	self endon ( "crashing" );
	self endon ( "leaving" );
	
	self.lockSounds = spawn( "script_model", self.origin);
	wait ( 0.1 );
	self.lockSounds LinkTo( self, "tag_player" );
	
	while ( true )
	{
		self waittill( "locking on" );
		
		while ( true )
		{
			if ( enemy_locking() )
			{
				//self.lockSounds PlaySoundToPlayer( "uin_alert_lockon_start", player );				
				//wait ( 0.3 );
				// locking on sounds are too quiet to hear so we will just play the locked on
				self.lockSounds PlaySoundToPlayer( "uin_alert_lockon", player );
				wait ( 0.125 );
			}
			
			if ( enemy_locked() )
			{
				self.lockSounds PlaySoundToPlayer( "uin_alert_lockon", player );
				wait ( 0.125 );
			}
			
			if ( !enemy_locking() && !enemy_locked() )
			{
				self.lockSounds StopSounds();
				break;
			}			
		}
	}
}

function enemy_locking()
{
	if ( isdefined(self.locking_on) && self.locking_on )
		return true;
	
	return false;
}

function enemy_locked()
{
	if ( isdefined(self.locked_on) && self.locked_on )
		return true;
			
	return false;
}

function look_with_player( player )
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
		{wait(.05);};
	}
}

function change_location( destNodes )
{
	self.heli endon ( "death" );
	self.heli endon ( "crashing" );
	self.heli endon ( "leaving" );
	
	self.moves = 0;
	self.heli waittill ( "near_goal" );
	self.heli waittill ( "goal" );
	//self.move_hud SetText(&"MP_HELI_NEW_LOCATION");
	
	for (;;)
	{
		if ( self SecondaryOffhandButtonPressed() )
		{
			self.moves++;
			self thread player_moved_recently_think();
			currentNode = self get_best_area_attack_node( destNodes, true );
			
			//Want Dialog here "Moving to better location"
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
				heli_speed = 80+randomInt(20);
				heli_accel = 40+randomInt(10);
			}
			
			self.heli SetSpeed( heli_speed, heli_accel );	
			self.heli setvehgoalpos( currentNode.origin + self.heli.zOffset, 1 );
			self.heli setgoalyaw( currentNode.angles[ 1 ] + level.heli_angle_offset );	
	
			//self.move_hud SetText("");
			self.heli waittill ( "goal" );
			//self.move_hud SetText(&"MP_HELI_NEW_LOCATION");
						
			// wait for the button to release:
			while ( self SecondaryOffhandButtonPressed() )
				{wait(.05);};
		}
		{wait(.05);};
	}
}

function player_moved_recently_think()
{
	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "leaving" );
	
	myMove = self.moves;
	self.heli.playerMovedRecently = true;
	wait ( 15 );
	//only remove the flag if I am still the most recent move
	if (myMove == self.moves && isdefined(self.heli))
		self.heli.playerMovedRecently = false;
}

function heli_fly_well( startNode, destNodes )
{
	self notify( "flying");
	self endon( "flying" );

	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "leaving" );

	nextnode = getent( startNode.target, "targetname" );
	assert( isdefined( nextnode ), "Next node in path is undefined, but has targetname" );
	self SetSpeed( 150, 80 );	
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
				heli_speed = 80+randomInt(20);
				heli_accel = 40+randomInt(10);
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

			wait ( 10 + randomInt( 5 ) );
		}
		else
		{				
			self waittillmatch( "goal" );				
			wait ( currentNode.script_delay );
		}
	}
}

function get_best_area_attack_node( destNodes, forceMove )
{
	return updateAreaNodes( destNodes, forceMove );
}

function updateAreaNodes( areaNodes, forceMove )
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

function travelToNode( goalNode )
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

function getOriginOffsets( goalNode )
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

function startHelicopter( type, player_driven, hardpointtype, startnode )
{
	self endon("disconnect"); 
	self endon("game_ended"); 
	team = self.team;

	killstreak_id = self killstreakrules::killstreakStart( hardpointtype, team, undefined, false );
	if ( killstreak_id == -1 )
		return false;

	self.enteringVehicle = true;
	self util::freeze_player_controls( true );
	
	if ( team != self.team )
	{
		self killstreakrules::killstreakStop( hardpointtype, team, killstreak_id );
		return false;
	}
	
	if ( !isdefined( self.heli ) )
	{
		heli = spawnPlayerHelicopter( self, type, startnode.origin, startnode.angles, hardpointtype );
		
		if ( !isdefined( heli ) )
		{
			self util::freeze_player_controls( false );
			killstreakrules::killstreakStop( hardpointtype, team, killstreak_id );
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
			self killstreakrules::killstreakStop( hardpointtype, team, killstreak_id );
		}
		debug_print_heli( ">>>>>>>startHelicopter: player dead while starting" );
		self notify( "heli_timeup" );

		self util::freeze_player_controls( false );
		self.enteringVehicle = false;
		return false;
	}
	
	if ( level.gameEnded )
	{
		killstreakrules::killstreakStop( hardpointtype, team, killstreak_id );
		self.enteringVehicle = false;
		return false;
	}
	
	self thread initHelicopter( player_driven, hardpointtype );

	self util::freeze_player_controls( false );
	self.enteringVehicle = false;
	self StopShellshock();

	if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].inboundtext ) )
		level thread popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
		
	self thread visionSwitch( 0.0 );

	return true;
}

function fireHeliWeapon( player )
{
	while ( true )
	{
		self waittill( "turret_fire" );			
		self fireWeapon( 0 );	
		earthquake (0.05, .05, self.origin, 1000);
	}
}

function spawnPlayerHelicopter( owner, type, origin, angles, hardpointtype )
{
	debug_print_heli( ">>>>>>>spawnHelicopter " + type );
	
	heli = helicopter::spawn_helicopter( self, origin, angles, level.chopper_defs[type], level.chopper_models[type]["friendly"], (0,0,-100), hardpointtype );
	
	if (!isdefined(heli))
		return undefined;

	//Delay SAM turret targeting until the player has a chance to use the chopper
	Target_SetTurretAquire( heli, false );
	//Delay shoulder launchers for player controlled choppers
	heli.lockOnDelay = true;
		
	heli setenemymodel( level.chopper_models[type]["enemy"] );
	heli.chaff_offset = level.chaff_offset[type];
	heli.death_model = level.chopper_death_models[type][owner.team];
	heli playLoopSound( level.chopper_sounds[type][owner.team] );	
	heli.defaultWeapon = GetWeapon( "cobra_20mm" );
	heli.owner = owner;
	heli.team = owner.team;
	heli setowner(owner);
	heli setteam(owner.team);
	heli.destroyFunc =&destroyPlayerHelicopter;	
	
	snd_ent = spawn( "script_origin", heli GetTagOrigin( "snd_cockpit" ) );
	snd_ent LinkTo( heli, "snd_cockpit", (0,0,0), (0,0,0) );
	heli.snd_ent = snd_ent;

	if ( isdefined( level.chopper_interior_models ) && isdefined(level.chopper_interior_models[type]) && isdefined( level.chopper_interior_models[type][owner.team] ) )
	{
		heli.interior_model = spawn("script_model", heli.origin);
		heli.interior_model setmodel(level.chopper_interior_models[type][owner.team]);
		heli.interior_model linkto(heli, "tag_origin", (0,0,0), (0,0,0) );
	}

  heli.killcament = owner;
	
	heli MakeVehicleUnusable();
	
	return heli;
}


function deletePlayerHeli()
{
	self notify( "heli_timeup" );
	debug_print_heli( ">>>>>>>Unlink and delete (deletePlayerHeli)" );
	if ( isdefined( self.viewlockedentity ) )
		self Unlink();

	self.heli helicopter::destroyHelicopter();
	
	self.heli = undefined;
}

function destroyPlayerHelicopter()
{
	if ( isdefined( self.owner ) && isdefined( self.owner.heli ) )
		self.owner deletePlayerHeli();
	else
		self helicopter::destroyHelicopter();
}

function debug_print_heli( msg )
{
/#
	if( GetDvarString( "scr_debugheli" ) == "" )
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
function initHelicopter( isDriver, hardpointtype )
{
	//Setup helicopter
	// TO DO: convert all helicopter attributes into dvars
	self.heli.reached_dest = false;							// has helicopter reached destination
	switch( hardpointtype )
	{
	case "helicopter_gunner":
		self.heli.maxhealth = level.heli_amored_maxhealth;				// max health
		break;
	case "helicopter_player_firstperson":
		self.heli.maxhealth = level.heli_amored_maxhealth;				// max health
		break;
	case "helicopter_player_gunner":
		self.heli.maxhealth = level.heli_amored_maxhealth;				// max health
		break;
	default:
		self.heli.maxhealth = level.heli_amored_maxhealth;				// max health
		break;
	}
	self.heli.rocketDamageOneShot = self.heli.maxhealth + 1;		// Make it so the heatseeker blows it up in one hit
	self.heli.rocketDamageTwoShot = (self.heli.maxhealth / 2) + 1;	// Make it so the heatseeker blows it up in two hit
	self.heli.numFlares = 2;										// put to 3 for all helicopters, 4 was too much
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
	self.heli.maxlifetime = 55*1000;						// 55 secs
	self.heli.doNotStop = 1;								// Do not stop at nodes with a script_delay
	self.heli.targetEnt = spawn("script_model", (0,0,0));
	self.heli.targetEnt SetModel( "tag_origin" );
	
	self.heli.health = 99999999;
	self.heli setturningability( 1 );
	self.heli.starttime = gettime();
	
	self.heli.team = self.team;
	self.heli.startingteam = self.team;
	self.heli.startinggametype = level.gameType;

	//Setup weapons
	if( isDriver )
	{
		self.heli thread hind_setup_rocket_attack( hardpointtype, self );
		self.heli thread hind_watch_rocket_fire( self );
		self.heli.current_weapon = "mini_gun";
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
	}
	
	//Create HUD
	self create_hud( isDriver );
//	if (!isDriver)
//	{
//		self create_gunner_hud();
//	}

	self thread helicopter::watchForEarlyLeave(hardpointtype);
	self thread waitForTimeOut(hardpointtype);
	self thread exitHeliWaiter();
	self thread gameEndHeliWaiter(hardpointtype);
	self thread heli_owner_exit(hardpointtype);
	self thread heli_owner_teamKillKicked(hardpointtype);

	self.heli thread helicopter::heli_damage_monitor( hardpointtype );		// monitors damage
	self.heli thread helicopter::heli_kill_monitor( hardpointtype );		// monitors damage
	self.heli thread heatseekingmissile::MissileTarget_LockOnMonitor( self, "crashing", "leaving" );				// monitors missle lock-ons
	self.heli thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing", "leaving");			// fires chaff if needed
	self.heli thread helicopter::create_flare_ent( (0,0,-100) );
	self.heli spawning::create_entity_enemy_influencer( "helicopter" );
	self.heli thread heli_player_damage_monitor( self );
	self.heli thread heli_health_player( self, hardpointtype );							// display helicopter's health through smoke/fire	

	self.heli thread debugTags();
}

function player_heli_reset()
{
	self clearTargetYaw();
	self clearGoalYaw();
	self setspeed( 45, 25 );	
	self setyawspeed( 75, 45, 45 );
	self setmaxpitchroll( 30, 40 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.3);
}

function visionSwitch( delay )
{
	self endon( "disconnect" );
	self.heli endon("crashing");
	self.heli endon("leaving");
	self.heli endon("death");
	
	wait( delay	);

	inverted = false;
	
	self SetInfraredVision( false );
	self UseServerVisionset( true );
	self SetVisionSetForPlayer( level.chopper_enhanced_vision, 1.0 );
	self clientfield::set( "operating_chopper_gunner", 1 );
	self util::clientNotify( "cgfutz" );

	for (;;)
	{
		if ( self ChangeSeatButtonPressed() )
		{
			if ( !inverted )
			{
				self SetInfraredVision( true );
				self SetVisionSetForPlayer( level.chopper_infrared_vision, 0.5 );
				self playsoundtoplayer ( "mpl_cgunner_flir_on", self );
				
			}
			else
			{
				self SetInfraredVision( false );
				self SetVisionSetForPlayer( level.chopper_enhanced_vision, 0.5 );
				self playsoundtoplayer ( "mpl_cgunner_flir_off", self );
			}

			inverted = !inverted;
			
			// wait for the button to release:
			while ( self ChangeSeatButtonPressed() )
				{wait(.05);};
		}
		{wait(.05);};
	}
}

function hind_setup_rocket_attack( hardpointtype, player )
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
			//If we have ammo in the mingun then switch to it and fire
			self.current_weapon = "mini_gun";
			self fireWeapon();
			self.numberMiniGun = self.numberMiniGun - 1;
			if ( isdefined( player.ammo_hud ) )
				player.ammo_hud SetValue(self.numberMiniGun);


 			wait 0.3;
		}
	}
}

function rocket_ammo_think( player )
{
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	
	while ( true )
	{
		while (self.numberRockets == 4)
			{wait(.05);};
		wait ( self.rocketRegenTime );
		self.numberRockets++;
	}
}

function hind_watch_rocket_fire( player )
{
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	self endon ( "crashing" );
	self endon ( "leaving" );
	
	self thread watchForOverHeat( player );

	while( isdefined(self) && (self.health > 0) && isdefined( self.targetEnt ) )
	{
		player waittill( "missile_fire", missile );
		missile.killCamEnt = player;
		origin = player GetEye();
		forward = AnglesToForward( player GetPlayerAngles() );
		endpoint = origin + forward * 15000;
		trace = BulletTrace( origin, endpoint, false, self );

		missile Missile_SetTarget( self.targetEnt, trace[ "position" ] ); // offset goes here
	}
	self notify ( "endWatchForOverheat" );
}

function watchForOverHeat( player )
{
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	self endon ( "crashing" );
	self endon ( "leaving" );
	self endon ( "endWatchForOverheat" );

	while( 1 )
	{
		//player.missile_hud SetText(&"MP_HELI_FIRE_MISSILES");
		self waittill( "gunner_turret_overheat" );
		
		//play missile reload evenly spaced until firing is available again
		self thread reload_rocket_audio( player );

		//player.missile_hud SetText("");
		self waittill( "gunner_turret_stop_overheat" );
	}
}

function reload_rocket_audio( player )
{
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	self endon ( "crashing" );
	self endon ( "leaving" );
	self endon ( "endWatchForOverheat" );
	self endon( "gunner_turret_stop_overheat" );
	
	for ( i = 0; i < 5; i++ )
	{
		wait 1;//putting the wait first so it pauses after the last shot
		player PlayLocalSound( "wpn_gunner_rocket_fire_reload_plr" );
	}
	
}

function hind_out_of_rockets(player)
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

function fire_rocket( tagName, player )
{
	start_origin = self GetTagOrigin( tagName );
	trace_angles = self GetTagAngles( "tag_flash" );
	forward = AnglesToForward( trace_angles );
	
	trace_origin = self GetTagOrigin( "tag_flash" );
	trace_direction = self GetTagAngles( "tag_barrel" );
	trace_direction = AnglesToForward( trace_direction ) * 5000;
	trace = BulletTrace( trace_origin, trace_origin + trace_direction, false, self );
	end_origin = trace["position"];
	
	
	MagicBullet( GetWeapon( "heli_gunner_rockets" ), start_origin, end_origin, self );
	player playlocalsound("wpn_gunner_rocket_fire_plr");
	self playsound("wpn_rpg_fire_npc");
	player PlayRumbleOnEntity( "damage_heavy" );
	Earthquake( 0.35, 0.5, start_origin, 1000, self );
}

function create_gunner_hud()
{
	self.minigun_hud = newclienthudelem( self );
	self.minigun_hud.alignX = "left";
	self.minigun_hud.alignY = "bottom";
	self.minigun_hud.horzAlign = "user_left";
	self.minigun_hud.vertAlign = "user_bottom";
	self.minigun_hud.font = "small";
	self.minigun_hud SetText(&"MP_HELI_FIRE_MINIGUN");
	self.minigun_hud.hidewheninmenu = true;
	self.minigun_hud.hideWhenInDemo = true;
	self.minigun_hud.x = 30;
	self.minigun_hud.y = -70;
	self.minigun_hud.fontscale = 1.25;
	
	self.zoom_hud = newclienthudelem( self );
	self.zoom_hud.alignX = "left";
	self.zoom_hud.alignY = "bottom";
	self.zoom_hud.horzAlign = "user_left";
	self.zoom_hud.vertAlign = "user_bottom";
	self.zoom_hud.font = "small";
	self.zoom_hud SetText(&"KILLSTREAK_INCREASE_ZOOM");
	self.zoom_hud.hidewheninmenu = true;
	self.zoom_hud.hideWhenInDemo = true;
	self.zoom_hud.x = 30;
	self.zoom_hud.y = -55;
	self.zoom_hud.fontscale = 1.25;
	
	self.missile_hud = newclienthudelem( self );
	self.missile_hud.alignX = "left";
	self.missile_hud.alignY = "bottom";
	self.missile_hud.horzAlign = "user_left";
	self.missile_hud.vertAlign = "user_bottom";
	self.missile_hud.font = "small";
	self.missile_hud SetText(&"MP_HELI_FIRE_MISSILES");
	self.missile_hud.hidewheninmenu = true;
	self.missile_hud.hideWhenInDemo = true;
	self.missile_hud.x = 30;
	self.missile_hud.y = -40;
	self.missile_hud.fontscale = 1.25;
	
	self.move_hud = newclienthudelem( self );
	self.move_hud.alignX = "left";
	self.move_hud.alignY = "bottom";
	self.move_hud.horzAlign = "user_left";
	self.move_hud.vertAlign = "user_bottom";
	self.move_hud.font = "small";
	self.move_hud SetText(&"MP_HELI_NEW_LOCATION");
	self.move_hud.hidewheninmenu = true;
	self.move_hud.hideWhenInDemo = true;
	self.move_hud.x = 30;
	self.move_hud.y = -25;
	self.move_hud.fontscale = 1.25;
		
	self.hud_prompt_exit = newclienthudelem( self );
	self.hud_prompt_exit.alignX = "left";
	self.hud_prompt_exit.alignY = "bottom";
	self.hud_prompt_exit.horzAlign = "user_left";
	self.hud_prompt_exit.vertAlign = "user_bottom";
	self.hud_prompt_exit.font = "small";
	self.hud_prompt_exit.fontScale = 1.25;
	self.hud_prompt_exit.hidewheninmenu = true;
	self.hud_prompt_exit.hideWhenInDemo = true;
	self.hud_prompt_exit.archived = false;
	self.hud_prompt_exit.x = 30;
	self.hud_prompt_exit.y = -10;
	self.hud_prompt_exit SetText(level.remoteExitHint);	
	
	self thread fade_out_hint_hud();
}

function fade_out_hint_hud()
{
	wait( 8 );
	time = 0;
	while (time < 2)
	{
		if ( !isdefined(self.minigun_hud))
		{
			return;	
		}
		self.minigun_hud.alpha -= 0.025;
		self.zoom_hud.alpha -= 0.025;
		time += 0.05;
		{wait(.05);};
	}
	
	if ( !isdefined(self.minigun_hud) )
	{
		return;
	}
	self.minigun_hud.alpha = 0;
	self.zoom_hud.alpha = 0;
}

function create_hud( isDriver )
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
		self.leaving_play_area.hidewhendead = false;
		self.leaving_play_area.hidewheninmenu = true;
		self.leaving_play_area.archived = false;
		self.leaving_play_area.alpha = 0.0;
		self.leaving_play_area SetText( &"MP_HELI_LEAVING_BATTLEFIELD" );
	}
}

function remove_hud()
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
	if ( isdefined(self.hud_prompt_exit) )
		self.hud_prompt_exit destroy();
			
	self.ammo_hud = undefined;
	self.alt_ammo_hud = undefined;
	self.alt_title = undefined;
	self.leaving_play_area = undefined;
	
	self clientfield::set( "operating_chopper_gunner", 0 );
	self util::clientNotify( "nofutz" );
	
	self notify("hind weapons disabled");
}


function gameEndHeliWaiter( hardpointtype )
{
	self endon("disconnect"); 
	self endon("heli_timeup");
	level waittill("game_ended");
	
	debug_print_heli( ">>>>>>>gameEndHeliWaiter" );
	self thread player_heli_leave( hardpointtype );
}

function heli_owner_teamKillKicked( hardpointtype )
{
	self endon("disconnect"); 
	self endon("heli_timeup");
	
	self waittill( "teamKillKicked" );
	self thread player_heli_leave( hardpointtype );
}
	
function heli_owner_exit( hardpointtype )
{
	self endon("disconnect"); 
	self endon("heli_timeup");
	
	wait( 1 );
	
	while( true )
	{
		timeUsed = 0;
		while( self UseButtonPressed() )
		{
			timeUsed += 0.05;
			if ( timeUsed > 0.25 )
			{
				self thread player_heli_leave( hardpointtype );
				return;
			}
			{wait(.05);};
		}
		{wait(.05);};
	}	
}

function exitHeliWaiter()
{ 
	self endon("disconnect");
	
	self waittill("heli_timeup");
	debug_print_heli( ">>>>>>>exitHeliWaiter" );
	self remove_hud();
	if( isdefined( self.heli ) )
	{
		debug_print_heli( ">>>>>>>Unlink and delete (exitHeliWaiter)" );
		if ( isdefined( self.viewlockedentity ) )
		{
			self Unlink();
			if ( isdefined(level.gameEnded) && level.gameEnded )
			{
				self util::freeze_player_controls( true );
			}
		}
		self.heli = undefined;
	}
	self SetInfraredVision( false );
	self UseServerVisionset( false );
	self.killstreak_waitamount = undefined;
	
	//Check to see if we are carring an item
	if ( isdefined( self.carryIcon ) )
	{
		self.carryIcon.alpha = self.prevCarryIconAlpha;
	}
	
	if ( isdefined( self ) )
		self killstreaks::clear_using_remote();
}

function heli_player_damage_monitor( player )
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
			
		heli_friendlyfire = weaponobjects::friendlyFireCheck( self.owner, attacker );
		
		// skip damage if friendlyfire is disabled
		if( !heli_friendlyfire )
			continue;
			
		if ( !level.hardcoreMode )
		{
			if(	isdefined( self.owner ) && attacker == self.owner )
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
		
		player SendKillstreakDamageEvent( int(damage) );
	}
}

function heli_health_player( player, hardpointtype )
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
	
	self thread helicopter::heli_health(hardpointtype, player, "heli_timeup");			
}



function debugtag(tagName)
{
	/#
	start_origin = self GetTagOrigin( tagName );
	if ( isdefined( start_origin ) )
	{
		sphere( start_origin, 5, (1,0,0), 1, true, 10, 1 );
	}
	#/
}

function debugTags()
{
	self endon("death");
	while(1)
	{
		{wait(.05);};
		tagName = GetDvarString( "tagname" );
		if ( !isdefined(tagName) || tagname == "" )
			continue;
		self debugTag(tagName);
	}
}


function hud_minigun_create()
{
	
	if(!isdefined(self.minigun_hud))
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

	self thread hud_minigun_destroy();
}

function hud_minigun_destroy()
{
	self waittill("hind weapons disabled");
	
	self.minigun_hud["gun"] Destroy();
	self.minigun_hud["button"] Destroy();
}

function hud_minigun_think()
{
	self endon("hind weapons disabled");
	self endon("disconnect");
	
	player = GetPlayers()[0];
	
	while(1)
	{
		while(!player AttackButtonPressed())
		{
			{wait(.05);};
		}
			
		swap_counter = 1;
		self.minigun_hud["gun"] fadeOverTime( 0.05 );
		self.minigun_hud["gun"].alpha = 0.65;
	
		while(player AttackButtonPressed())
		{
			{wait(.05);};
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

function hud_rocket_create()
{
	if(!isdefined(self.rocket_hud))
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

 	// fake hud element so we can call _hud_util::updateBar()
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

function hud_rocket_destroy()
{
	self waittill("hind weapons disabled");

	self.rocket_hud["border"] Destroy();
	self.rocket_hud["loading_border"] Destroy();
	self.rocket_hud["loading_bar"] Destroy();
	self.rocket_hud["ammo1"] Destroy();
	self.rocket_hud["button"] Destroy();
	self.rocket_hud["ammo2"] Destroy();
}

function hud_rocket_think()
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
		{wait(.05);};
	}
}

function updateAmmoBarScale( barFrac, rateOfChange ) 
{
	barWidth = int(self.width * barFrac + 0.5); // (+ 0.5 rounds)
	
	if ( !barWidth )
		barWidth = 1;
	
	//if barWidth is bigger than self.width then we are drawing more than 100%
	if ( isdefined( rateOfChange ) && barWidth <= self.width ) 
	{
			self.bar scaleOverTime( rateOfChange, barWidth, self.height );
	}
	else
	{
			self.bar setShader( self.bar.shader, barWidth, self.height );
	}
}


function player_heli_leave(hardpointtype)
{
	self endon( "heli_timeup" );
	self.heli thread helicopter::heli_leave( hardpointtype );
	wait(0.1);
	debug_print_heli( ">>>>>>>player_heli_leave" );
	self notify( "heli_timeup" );
}

function waitForTimeOut(hardpointtype)
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

function debugCheckForExit(hardpointtype)
{
	/#
	self endon("disconnect"); 
	self endon("heli_timeup");
	
	if( isdefined( self.pers["isBot"] ) && self.pers["isBot"] )	
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
function PlayPilotDialog( dialog, time )
{

	if (isdefined(time))
	{
		wait time;
	}
	if (!isdefined(self.pilotVoiceNumber))
	{
	  self.pilotVoiceNumber = 0;  	
	}
	soundAlias = level.teamPrefix[self.team] + self.pilotVoiceNumber + "_" + dialog;
	self playLocalSound(soundAlias);
}

