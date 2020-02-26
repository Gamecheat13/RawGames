#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_airsupport;
#include maps\mp\gametypes\_hud_util;

init()
{
	PreCacheString( &"MP_MINIGUN" );
	PreCacheString( &"MP_ROCKETS" );
	PreCacheString( &"MP_HELI_LEAVING_BATTLEFIELD" );
	
	//PreCacheShader( "hud_hind_cannon01" );
	//PreCacheShader( "hud_hind_rocket" );
	//PreCacheShader( "hud_hind_rocket_loading" );
	//PreCacheShader( "hud_hind_rocket_loading_fill" );
	//PreCacheShader( "hud_hind_rocket_border_small" );

	//mini-gun and rockets on player hind
	//PreCacheItem( "hind_minigun_pilot_mp" );
	//PreCacheItem( "hind_minigun_pilot_2_mp" );
	//PreCacheItem( "hind_minigun_pilot_firstperson_mp" );
	//PreCacheItem( "hind_rockets_mp" );
	//PreCacheItem( "hind_rockets_firstperson_mp" );
	PreCacheItem( "cobra_minigun_mp" );
	
	level.chopper_defs["player"] = "heli_player_controlled_mp";
	level.chopper_defs["gunner"] = "heli_gunner_mp";
	level.chopper_defs["player_firstperson"] = "heli_player_controlled_firstperson_mp";
	level.chopper_defs["player_gunner"] = "heli_player_gunner_mp";
	PreCacheVehicle( level.chopper_defs["player"] );
	PreCacheVehicle( level.chopper_defs["player_firstperson"] );
	PreCacheVehicle( level.chopper_defs["player_gunner"] );

	level.chopper_models["player"]["friendly"] = "veh_iw_air_apache_killstreak";
	level.chopper_models["player"]["enemy"] = "veh_iw_air_hind";
	level.chopper_models["player_firstperson"]["friendly"] = "veh_iw_air_apache_killstreak";
	level.chopper_models["player_firstperson"]["enemy"] = "veh_iw_air_hind";
	level.chopper_models["gunner"]["friendly"] = "veh_iw_air_apache_killstreak";
	level.chopper_models["gunner"]["enemy"] = "veh_iw_air_apache_killstreak";
	level.chopper_models["player_gunner"]["friendly"] = "veh_iw_air_apache_killstreak";
	level.chopper_models["player_gunner"]["enemy"] = "veh_iw_air_apache_killstreak";
	
	
	// chaff offset for particle fx
	// these values come from moffat
	level.chaff_offset["gunner"] = ( -100, 0, -115 );
	level.chaff_offset["player"] = ( -185, 0, -85 );
	level.chaff_offset["player_firstperson"] = ( -185, 0, -85 );
	level.chaff_offset["player_gunner"] = ( -185, 0, -85 );

	PreCacheModel(level.chopper_models["player"]["friendly"]);
	PreCacheModel(level.chopper_models["player"]["enemy"]);
	PreCacheModel(level.chopper_models["player_firstperson"]["friendly"]);
	PreCacheModel(level.chopper_models["player_firstperson"]["enemy"]);
	PreCacheModel(level.chopper_models["gunner"]["friendly"]);
	PreCacheModel(level.chopper_models["gunner"]["enemy"]);
	PreCacheModel(level.chopper_models["player_gunner"]["friendly"]);
	PreCacheModel(level.chopper_models["player_gunner"]["enemy"]);

	level.chopper_death_models["player"]["allies"] = "t5_veh_helo_hind_dead";
	level.chopper_death_models["player"]["axis"] = "t5_veh_helo_hind_dead";
	level.chopper_death_models["player_firstperson"]["allies"] = "t5_veh_helo_hind_dead";
	level.chopper_death_models["player_firstperson"]["axis"] = "t5_veh_helo_hind_dead";
	level.chopper_death_models["gunner"]["allies"] = "t5_veh_helo_hind_dead";
	level.chopper_death_models["gunner"]["axis"] = "t5_veh_helo_hind_dead";
	level.chopper_death_models["player_gunner"]["allies"] = "t5_veh_helo_hind_dead";
	level.chopper_death_models["player_gunner"]["axis"] = "t5_veh_helo_hind_dead";

	level.chopper_sounds["player"]["allies"] = "mpl_kls_cobra_helicopter";
	level.chopper_sounds["player"]["axis"] = "mpl_kls_hind_helicopter";
	level.chopper_sounds["player_firstperson"]["allies"] = "mpl_kls_cobra_helicopter";
	level.chopper_sounds["player_firstperson"]["axis"] = "mpl_kls_hind_helicopter";
	level.chopper_sounds["gunner"]["allies"] = "mpl_kls_cobra_helicopter";
	level.chopper_sounds["gunner"]["axis"] = "mpl_kls_hind_helicopter";
	level.chopper_sounds["gunner"]["allies"] = "mpl_kls_cobra_helicopter";
	level.chopper_sounds["gunner"]["axis"] = "mpl_kls_hind_helicopter";
	level.chopper_sounds["player_gunner"]["allies"] = "mpl_kls_cobra_helicopter";
	level.chopper_sounds["player_gunner"]["axis"] = "mpl_kls_hind_helicopter";

	level.chopper_sounds["missile_reload"] = "wpn_rocket_reload_heli";
	
	LoadFX ("vehicle/treadfx/fx_heli_dust_default");
	LoadFX ("vehicle/treadfx/fx_heli_dust_concrete");
	LoadFX ("vehicle/treadfx/fx_heli_water_spray");
	LoadFX ("vehicle/treadfx/fx_heli_snow_spray");
	LoadFX ("vehicle/exhaust/fx_exhaust_huey_engine");
	LoadFX ("vehicle/props/fx_huey_main_blade_full");
	LoadFX ("vehicle/props/fx_huey_small_blade_full");
	LoadFX ("vehicle/props/fx_hind_main_blade_full");
	LoadFX ("vehicle/props/fx_hind_small_blade_full");

	level.fx_heli_warning = loadfx( "vehicle/light/fx_cobra_interior_blinking_light" );
	level.fx_hind_warning = loadfx( "vehicle/light/fx_heli_hind_interior_red_dlight" );
	level.fx_door_closed = loadfx( "vehicle/light/fx_heli_interior_red_dlight" );
	level.fx_door_open = loadfx( "vehicle/light/fx_heli_interior_green_dlight" );
	level.fx_door_ambient = loadfx( "vehicle/treadfx/fx_heli_clouds_chopper_gunner" );
	
	init_heli_anims();

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowhelicopter_player_firstperson" ) )
	{
		maps\mp\killstreaks\_killstreaks::registerKillstreak("helicopter_player_firstperson_mp", "helicopter_player_firstperson_mp", "killstreak_helicopter_player_firstperson", "helicopter_used", ::useKillstreakHelicopterPlayer, true);
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("helicopter_player_firstperson_mp", &"KILLSTREAK_EARNED_HELICOPTER_PLAYER", &"KILLSTREAK_HELICOPTER_PLAYER_NOT_AVAILABLE", &"KILLSTREAK_HELICOPTER_PLAYER_INBOUND");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("helicopter_player_firstperson_mp", "mpl_killstreak_heli", "kls_playerheli_used", "","kls_playerheli_enemy", "", "kls_playerheli_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("helicopter_player_firstperson_mp", "scr_givehelicopterplayerfirstperson");
		
		//TO-DO: Make sure all variants of helicopters across factions are added. - Leif
		maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon("helicopter_player_firstperson_mp", "hind_rockets_firstperson_mp" );
		maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon("helicopter_player_firstperson_mp", "hind_minigun_pilot_firstperson_mp" );
		
		// this causes the player to keep holding the weapon until the hardpoint is done
//		maps\mp\killstreaks\_killstreaks::setRemoveWeaponWhenUsed("helicopter_player_mp", false);
	}
	
	level.chopper_infrared_vision = "remote_mortar_infrared";
	level.chopper_enhanced_vision = "remote_mortar_enhanced";
}

useKillstreakHelicopterPlayer(hardpointType)
{
	if ( ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false ) || !self IsOnGround() )
		return false;
	
	if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) )
	{
		iprintlnbold("Need to add helicopter paths to the level");
		return false;
	}
	
	if ( (isDefined( self.isPlanting ) && self.isPlanting ) )
	{
//		iprintlnbold("Can't activate player helicopter while planting a bomb");
		return false;
	}
	
	if ( (isDefined( self.isDefusing ) && self.isDefusing ) )
	{
//		iprintlnbold("Can't activate player helicopter while defusing a bomb");
		return false;
	}
	
	//Check to see if we are carring an item
	if ( isDefined( self.carryIcon ) )
	{
		//Yes we are so fade it out while in the helicopter
		self.prevCarryIconAlpha = self.carryIcon.alpha;
		self.carryIcon.alpha = 0.0;
	}
	
	self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0.5, 1.0, 0.5, 0.5 );
	self.exitblackscreenTime = 0.1;

	if ( hardpointType == "helicopter_player_firstperson_mp" )
		result = self usePlayerHelicopter( "player_firstperson", hardpointType );	
	else
		result = self usePlayerHelicopter( "player", hardpointType );

	if ( !isdefined( result ) )
	{
		result = false;
	}

	if ( result == true ) 
	{
		self thread maps\mp\killstreaks\_helicopter::announceHelicopterInbound( hardpointType );
	}

	return result;
}


useKillstreakHelicopterGunner(hardpointType)
{
	if ( ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false ) || !self IsOnGround() )
		return false;
	
	if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) )
	{
		iprintlnbold("Need to add helicopter paths to the level");
		return false;
	}
	
	if ( (isDefined( self.isPlanting ) && self.isPlanting ) )
	{
//		iprintlnbold("Can't activate player helicopter turret while planting a bomb");
		return false;
	}
	
	if ( (isDefined( self.isDefusing ) && self.isDefusing ) )
	{
//		iprintlnbold("Can't activate player helicopter turret while defusing a bomb");
		return false;
	}
	
	//Check to see if we are carring an item
	if ( isDefined( self.carryIcon ) )
	{
		//Yes we are so fade it out while in the helicopter
		self.prevCarryIconAlpha = self.carryIcon.alpha;
		self.carryIcon.alpha = 0.0;
	}
	
	self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0.5, 1.0, 0.5, 0.5 );
	self.exitblackscreenTime = 0.5;
	
	if( hardpointType == "helicopter_gunner_mp" )
		result = self useGunnerHelicopter( hardpointType );
	else
		result = self usePlayerGunnerHelicopter( hardpointType );

	if ( !isdefined( result ) )
	{
		result = false;
	}

	if ( result == true ) 
	{
		self thread maps\mp\killstreaks\_helicopter::announceHelicopterInbound( hardpointType );
	}
	
	return result;
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

	heli SetClientFlag( level.const_flag_player_helicopter );
	
	return heli;
}

deletePlayerHeli()
{
	self.heli ClearClientFlag( level.const_flag_player_helicopter );
	
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

debugtag(tagName)
{
	start_origin = self GetTagOrigin( tagName );
	if ( IsDefined( start_origin ) )
	{
		sphere( start_origin, 5, (1,0,0), 1, true, 10, 1 );
	}
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

startHelicopter( type, player_driven, hardpointtype, startnode )
{
	self endon("disconnect"); 
	self endon("game_ended"); 
	team = self.team;

	if ( self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointtype, team, undefined, false ) == false )
		return false;

	self.enteringVehicle = true;
	self freeze_player_controls( true );
	
	wait(1.0);
	
	if ( team != self.team )
	{
		self maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointtype, team );
		return false;
	}
	
	if ( !IsDefined( self.heli ) )
	{
		heli = spawnPlayerHelicopter( self, type, startnode.origin, startnode.angles, hardpointtype );
		
		if ( !IsDefined( heli ) )
		{
			self freeze_player_controls( false );
			maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointtype, team );
			self.enteringVehicle = false;
			return false;
		}
		
		self.heli = heli;
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
			self maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointtype, team );
		}
		debug_print_heli( ">>>>>>>startHelicopter: player dead while starting" );
		self notify( "heli_timeup" );

		self freeze_player_controls( false );
		self.enteringVehicle = false;
		return false;
	}
	
	if ( level.gameEnded )
	{
		maps\mp\killstreaks\_killstreakrules::killstreakStop( hardpointtype, team );
		self.enteringVehicle = false;
		return false;
	}
	
	self thread initHelicopter( player_driven, hardpointtype );

	self freeze_player_controls( false );
	self.enteringVehicle = false;
	self StopShellshock();

	if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].inboundtext ) )
		level thread maps\mp\_popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
		
	self thread visionSwitch( 1.0 );

	return true;
}

gunnerStartPath( startnode )
{
	self.heli thread maps\mp\_vehicles::follow_path( startnode );

	self thread watchForOpenDoor();
	
	wait (1.0);
	self PlayLocalSound(level.heli_vo[self.team]["approach"]);
}

/#
gunnerStartPathDebug( )
{
	self endon("heli_timeup");
	self.heli SetHoverParams(0,0,0);
	pos = (0,0,300);	
	self.heli setvehgoalpos( (pos), true );

	self thread watchForOpenDoor();

	wait (10.0);
	self.heli notify( "open_door" );
}
#/

useGunnerHelicopter( hardpointtype )
{
	self endon("disconnect"); 
	self endon("game_ended"); 

	startnode = GetVehicleNode( "chopper_gunner_start", "targetname" );
	if ( !isDefined( startnode ) )
	{
		println( "ERROR: Chopper gunner vehicle spline not found!" );
		return false;
	}
	
	if (!(self startHelicopter("gunner", false, hardpointtype, startnode )))
		return false;

	self.heli chopperUseAnimTree();
	self.heli chopperGunnerOpenDoor( false );
	self.heli usevehicle( self, 2 );
	self.heli SetClientFlag( level.const_flag_choppergunner );
	
	gunnerStartPath( startnode );
	//gunnerStartPathDebug();

	return true;
}

usePlayerHelicopter( type, hardpointtype )
{
	self endon("disconnect"); 
	self endon("game_ended"); 

	assert( isdefined( level.Heli_primary_path ) && ( level.heli_primary_path.size > 0 ), "No primary helicopter path found in map" );

	if (!(self startHelicopter(type, true, hardpointtype, level.heli_primary_path[0] )))
		return false;

	self.heli setviewclamp( self, 15, 15 );

	self thread watchLeavingBattlefield( hardpointtype );
	self thread waitAndActivatePlayerControl();

	self.heli thread maps\mp\killstreaks\_helicopter::heli_fly( level.heli_primary_path[0], 0.0, hardpointtype );
	self.heli setyawspeed( 15, 15 );

	self thread playApproachSound();

	return true;
}

playApproachSound()
{
	self.heli endon("crashing");
	self.heli endon("leaving");
	self.heli endon("death");
	
	wait (1.0);
	self PlayLocalSound(level.heli_vo[self.team]["approach"]);
}

usePlayerGunnerHelicopter( hardpointtype )
{
	self endon("disconnect"); 
	self endon("game_ended"); 

	assert( isdefined( level.Heli_primary_path ) && ( level.heli_primary_path.size > 0 ), "No primary helicopter path found in map" );

	if (!(self startHelicopter("player_gunner", false, hardpointtype, level.heli_primary_path[0] )))
		return false;

	self.heli endon("crashing");
	self.heli endon("leaving");
	self.heli endon("death");

	self.heli usevehicle( self, 0 );
	
	self.heli thread maps\mp\killstreaks\_helicopter::heli_fly( level.heli_primary_path[0], 0.0, hardpointtype );
	
	wait (1.0);
	self PlayLocalSound(level.heli_vo[self.heli.team]["approach"]);

	self.heli thread fireHeliWeapon();

	//Allow SAM turret to target chopper
	Target_SetTurretAquire( self.heli, true );
	self.heli.lockOnDelay = false;

	return true;
}

fireHeliWeapon()
{
	while ( true )
	{
		self waittill( "turret_fire" );			
		self fireWeapon( "tag_flash" );	
		earthquake (0.2, 1, self.origin, 1000);
	}
}


watchForOpenDoor()
{
	self endon("disconnect");
	self.heli endon("heli_timeup");
	self.heli endon("death");
	
	// notify triggered by the vehicle path
	self.heli waittill( "open_door" );
	
	if ( !IsDefined( self.heli ) )
		return;
		
	self PlayLocalSound(level.heli_vo[self.team]["door"]);
	wait(1);
	
	if ( !IsDefined( self.heli ) )
		return;

	self.heli SetClientFlag( level.const_flag_opendoor );
	self.heli chopperGunnerOpenDoor( true );
	
	self PlayLocalSound(level.heli_vo[self.team]["ready"]);
	
	lengthOfClientAnimation = 2.25;
	wait(lengthOfClientAnimation);

	if ( !IsDefined( self.heli ) )
		return;

	self.heli usevehicle( self, 1 );

	wait(0.25);

	if ( !IsDefined( self.heli ) )
		return;

	self PlayLocalSound(level.heli_vo[self.team]["shoot"]);

	//Allow SAM turret to target chopper
	Target_SetTurretAquire( self.heli, true );
	self.heli.lockOnDelay = false;
}

watchForEarlyLeave(hardpointtype)
{
	self endon("heli_timeup");
	
	self waittill_any( "joined_team", "disconnect", "joined_spectators" );
	
	player_heli_leave(hardpointtype);
	
	debug_print_heli( ">>>>>>>send notify [team_change***heli_timeup] TIMEUP!!!!!!!!!!!!!!" );
}

player_heli_leave(hardpointtype)
{
	self endon( "heli_timeup" );
	self.heli thread maps\mp\killstreaks\_helicopter::heli_leave( hardpointtype );
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
		self.heli.maxhealth = 1500;								// max health
		break;
	case "helicopter_player_firstperson_mp":
		self.heli.maxhealth = 3000;								// max health
		break;
	case "helicopter_player_gunner_mp":
		self.heli.maxhealth = 3000;								// max health
		break;
	default:
		self.heli.maxhealth = 1500;								// max health
		break;
	}
	self.heli.rocketDamageOneShot = self.heli.maxhealth + 1;		// Make it so the heatseeker blows it up in one hit
	self.heli.rocketDamageTwoShot = (self.heli.maxhealth / 2) + 1;	// Make it so the heatseeker blows it up in two hit
	self.heli.chaffcount = 1;										// put to 1 for all helicopters, 2 was too much
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
//	self.heli.maxlifetime = 240*1000;						// 60 secs
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
	
	//Create HUD
	self create_hud( isDriver );

	self thread watchForEarlyLeave(hardpointtype);
//	self thread debugCheckForExit(hardpointtype);
	self thread waitForTimeOut(hardpointtype);
	self thread exitHeliWaiter();
	self thread gameEndHeliWaiter(hardpointtype);

	self.heli thread maps\mp\killstreaks\_helicopter::heli_damage_monitor( hardpointtype );		// monitors damage
	self.heli thread maps\mp\killstreaks\_helicopter::heli_kill_monitor( hardpointtype );		// monitors damage
	self.heli thread heli_lock_monitor( self );				// monitors missle lock-ons
	self.heli thread maps\mp\killstreaks\_helicopter::heli_missile_incoming();			// fires chaff if needed
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
	//self setjitterparams( (30, 30, 30), 4, 6 );
	self setmaxpitchroll( 30, 40 );
	self setneargoalnotifydist( 256 );
	self setturningability(0.3);
}

waitAndActivatePlayerControl()
{
	self endon( "disconnect" );
	self.heli endon( "death" );
	self endon( "heli_timeup" );
	
	wait( 1.0 ); // Allow at least one second of entry path if starting already inside the heli height lock
	
	for ( ;; )
	{
		if ( !isDefined( self.heli ) )
			return;
			
		distance_in = self.heli IsInsideHeliHeightLock();
		if ( distance_in > level.heli_warning_distance )
		{
			self.heli usevehicle( self, 0 );
			self.heli SetHeliHeightLock( true );
			self.heli resetviewclamp( self );
			self.heli player_heli_reset();
			self.heli ReturnPlayerControl();
			self.heli notify( "flying" );
			self.heli notify( "player_controls_activated" );
			self.heli.starttime = gettime();
			
			self PlayLocalSound(level.heli_vo[self.team]["ready"]);

		//Allow SAM turret to target chopper
			Target_SetTurretAquire( self.heli, true );
			self.heli.lockOnDelay = false;

			return;
		}
		wait 0.05;
	}
}

watchLeavingBattlefield( hardpointtype )
{
	self endon( "disconnect" );
	self endon( "heli_timeup" );
	self.heli endon( "death" );
	
	self.heli waittill( "player_controls_activated" );
	
	for ( ;; )
	{
		distance_in = self.heli IsInsideHeliHeightLock();
		if ( distance_in > 0 && distance_in < level.heli_warning_distance )
		{
			if ( !isDefined( self.heli.beingWarnedAboutLeaving ) || self.heli.beingWarnedAboutLeaving > 1)
			{
				if ( IsDefined( self.heli.beingWarnedAboutLeaving ) )
				{
					self.heli notify( "reentered_battlefield" );
				}
				
				self.heli.beingWarnedAboutLeaving = 1;
				self.heli SetClientFlag( level.const_flag_outofbounds );
				if ( isDefined( self.leaving_play_area.alpha ) )
					self.leaving_play_area.alpha = 1.0;
			}
		}
		else if ( distance_in == 0 )
		{
			if ( !isDefined( self.heli.beingWarnedAboutLeaving ) || self.heli.beingWarnedAboutLeaving < 2 )
			{ 
				self.heli.beingWarnedAboutLeaving = 2;
				self.heli SetClientFlag( level.const_flag_outofbounds );
				self thread warnLeavingBattlefield( hardpointtype );
			}
		}
		else if ( isDefined( self.heli.beingWarnedAboutLeaving ) )
		{
			self.heli notify( "reentered_battlefield" );
			if ( isDefined( self.leaving_play_area.alpha ) )
				self.leaving_play_area.alpha = 0.0;
			self.heli.beingWarnedAboutLeaving = undefined;
			self.heli ClearClientFlag( level.const_flag_outofbounds );
		}
		wait 0.05;
	}
}

warnLeavingBattlefield( hardpointtype )
{
	self endon( "disconnect" );
	self endon( "heli_timeup" );
	self.heli endon( "death" );
	self.heli endon( "reentered_battlefield" );
	
	if ( isDefined( self.leaving_play_area.alpha ) )
		self.leaving_play_area.alpha = 1.0;
		
	self thread crashLeavingBattlefield( hardpointtype );
	
	for ( ;; )
	{
		wait 1.0;
		earthquake( 0.7, 1.5, self.heli.origin, 1000, self );
		self.heli.snd_ent PlaySound ( "evt_helicopter_rumble" );
	}
}


crashLeavingBattlefield( hardpointtype )
{
	self endon( "disconnect" );
	self endon( "heli_timeup" );
	self.heli endon( "death" );
	self.heli endon( "reentered_battlefield" );
	
	wait 1.0;
	debug_print_heli( ">>>>>>>crashLeavingBattlefield" );
	self.heli setviewclamp( self, 15, 15 );
	self.heli thread maps\mp\killstreaks\_helicopter::heli_crash( hardpointtype, self, "heli_timeup" );
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

hind_watch_rocket_fire( player )
{
	wait 1;
	
	player endon("disconnect");
	self endon( "death" );
	self endon("exit_vehicle");
	self endon("heli_timeup");
	
	rocketTags = [];
	rocketTags[0] = "tag_flash_gunner1";
	rocketTags[1] = "tag_rocket2";
	
	rocketTag = 0;
	while( isdefined(self) && (self.health > 0) )
	{
		while ( !player ThrowButtonPressed() )
			wait 0.05;
		
		if ( self.numberRockets > 0 )
		{
			self fire_rocket( rocketTags[rocketTag] );
			self.numberRockets--;
			if ( isdefined( player.alt_ammo_hud ) )
				player.alt_ammo_hud SetValue(self.numberRockets);
			
			rocketTag = ( rocketTag + 1 ) % rocketTags.size;
			
			if ( self.numberRockets == 0 )
			{
				self thread hind_out_of_rockets(player);
			}
		}
		
		while ( player ThrowButtonPressed() )
			wait 0.05;
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

fire_rocket( tagName )
{
	start_origin = self GetTagOrigin( tagName );
	trace_angles = self GetTagAngles( "tag_flash" );
	forward = AnglesToForward( trace_angles );
	
	trace_origin = self GetTagOrigin( "tag_flash" );
	trace_direction = self GetTagAngles( "tag_barrel" );
	trace_direction = AnglesToForward( trace_direction ) * 5000;
	trace = BulletTrace( trace_origin, trace_origin + trace_direction, false, self );
	end_origin = trace["position"];
	
	MagicBullet( "hind_rockets_firstperson_mp", start_origin, end_origin, self );
	Earthquake( 0.35, 0.5, start_origin, 1000, self );
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
	self SetInfraredVision( false );
	self UseServerVisionset( false );
	if( isdefined( self.heli ) )
	{
		self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0.0, 0.5, 0.5, 0.5 );
		wait(0.7);
//		self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( 0.0, self.exitblackscreenTime, 0.0, 0.3 );
		debug_print_heli( ">>>>>>>Unlink and delete (exitHeliWaiter)" );
		if ( IsDefined( self.viewlockedentity ) )
			self Unlink();
		self.heli = undefined;
	}
	self.killstreak_waitamount = undefined;
	
	//Check to see if we are carring an item
	if ( isDefined( self.carryIcon ) )
	{
		self.carryIcon.alpha = self.prevCarryIconAlpha;
	}
}

heli_lock_monitor( player )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );

	for( ;; )
	{

		if( target_isTarget( self ) )
		{	
			if ( self maps\mp\killstreaks\_helicopter::isMissileIncoming() )
			{
				self SetClientFlag( level.const_flag_warn_fired );
				self ClearClientFlag( level.const_flag_warn_locked );
				self ClearClientFlag( level.const_flag_warn_targeted );
			}	
			else if( IsDefined(self.locked_on) && self.locked_on )
			{
				self SetClientFlag( level.const_flag_warn_locked );
				self ClearClientFlag( level.const_flag_warn_fired );
				self ClearClientFlag( level.const_flag_warn_targeted );
			}
			else if( IsDefined(self.locking_on) && self.locking_on )
			{
				self SetClientFlag( level.const_flag_warn_targeted );
				self ClearClientFlag( level.const_flag_warn_fired );
				self ClearClientFlag( level.const_flag_warn_locked );
			}
			else
			{
				self ClearClientFlag( level.const_flag_warn_fired );
				self ClearClientFlag( level.const_flag_warn_targeted );
				self ClearClientFlag( level.const_flag_warn_locked );
			}
		}
		
		wait( 0.1 );
	}
}

create_hud( isDriver )
{
	debug_print_heli( ">>>>>>>create_hud" );
	if( isDriver )
	{		
		hud_minigun_create();
		hud_rocket_create();
		
//		//displays current weapon's ammo
//		self.ammo_hud = newclienthudelem( self );
//		self.ammo_hud.fontScale = 1.5;
//		self.ammo_hud.x = 0;
//		self.ammo_hud.y = 0;
//		self.ammo_hud.alignX = "right";
//		self.ammo_hud.alignY = "bottom";
//		self.ammo_hud.horzAlign = "right";
//		self.ammo_hud.vertAlign = "bottom";
//		self.ammo_hud.hidewhendead = false;
//		self.ammo_hud.hidewheninmenu = true;
//		self.ammo_hud.archived = false;
//		self.ammo_hud.foreground = true;
//		self.ammo_hud SetValue(self.heli.numberMiniGun);
//		
//		//displays title for weapon
//		self.title = newclienthudelem( self );
//		self.title.fontScale = 1.5;
//		self.title.x = 0;
//		self.title.y = -20;
//		self.title.alignX = "right";
//		self.title.alignY = "bottom";
//		self.title.horzAlign = "right";
//		self.title.vertAlign = "bottom";
//		self.title.foreground = true;
//		self.title.color = (237, 0, 0);	
//		self.title.hidewhendead = false;
//		self.title.hidewheninmenu = true;
//		self.title.archived = false;
//		self.title SetText( &"MP_MINIGUN" );
//		
//		//displays alt weapon ammo
//		self.alt_ammo_hud = newclienthudelem( self );
//		self.alt_ammo_hud.fontScale = 1.5;
//		self.alt_ammo_hud.x = 0;
//		self.alt_ammo_hud.y = 0;
//		self.alt_ammo_hud.alignX = "left";
//		self.alt_ammo_hud.alignY = "bottom";
//		self.alt_ammo_hud.horzAlign = "left";
//		self.alt_ammo_hud.vertAlign = "bottom";
//		self.alt_ammo_hud.hidewhendead = false;
//		self.alt_ammo_hud.hidewheninmenu = true;
//		self.alt_ammo_hud.archived = false;
//		self.alt_ammo_hud.foreground = true;
//		self.alt_ammo_hud SetValue(self.heli.numberRockets);
//		
//		//displays alt weapon title
//		self.alt_title = newclienthudelem( self );
//		self.alt_title.fontScale = 1.5;
//		self.alt_title.x = 0;
//		self.alt_title.y = -20;
//		self.alt_title.alignX = "left";
//		self.alt_title.alignY = "bottom";
//		self.alt_title.horzAlign = "left";
//		self.alt_title.vertAlign = "bottom";
//		self.alt_title.foreground = true;
//		self.alt_title.color = (237, 0, 0);	
//		self.alt_title.hidewhendead = false;
//		self.alt_title.hidewheninmenu = true;
//		self.alt_title.archived = false;
//		self.alt_title SetText( &"MP_ROCKETS" );
//		
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
		
	self.ammo_hud = undefined;
	self.alt_ammo_hud = undefined;
	self.alt_title = undefined;
	self.leaving_play_area = undefined;
	
	self ClearClientFlag( level.const_flag_operatingchoppergunner );
	
	self notify("hind weapons disabled");
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

#using_animtree ( "mp_vehicles" );

init_heli_anims()
{
	level.chopper_player_get_on_gun = %int_huey_gunner_on;
	level.chopper_door_open = %v_huey_door_open;
	level.chopper_door_open_state = %v_huey_door_open_state;
	level.chopper_door_closed_state = %v_huey_door_close_state;
}

chopperUseAnimTree()
{
	self UseAnimTree( #animtree );
}

chopperGunnerOpenDoor( set )
{
	self endon( "death" );

	animTime = 0.2;
	
	if ( set )
	{
		self SetAnim( level.chopper_door_closed_state, 0, animTime, 1 );
		self SetAnim( level.chopper_door_open_state, 1, animTime, 1 );
		self SetAnim(level.chopper_player_get_on_gun, 1, animTime, 1 );
	}
	else
	{
		// immediate close
		self SetAnim( level.chopper_door_open_state, 0, 0, 1 );
		self SetAnim( level.chopper_door_closed_state, 1, 0, 1 );
	}
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

debug_print3d_simple_heli( message, ent, offset, frames )
{
/#
	if( GetDvar( "scr_debugheli" ) == "" )
	{
		SetDvar( "scr_debugheli", "0" );
	}

	if ( GetDvarint( "scr_debugheli") == 1 )
	{
		if( IsDefined( frames ) )
			thread draw_text_heli( message, ( 0.8, 0.8, 0.8 ), ent, offset, frames );
		else
			thread draw_text_heli( message, ( 0.8, 0.8, 0.8 ), ent, offset, 0 );
	}
#/
}

/#
draw_text_heli( msg, color, ent, offset, frames )
{
	if( frames == 0 )
	{
		while ( isdefined( ent ) )
		{
			print3d( ent.origin+offset, msg , color, 0.5, 4 );
			wait 0.05;
		}
	}
	else
	{
		for( i=0; i < frames; i++ )
		{
			if( !isdefined( ent ) )
				break;
			print3d( ent.origin+offset, msg , color, 0.5, 4 );
			wait 0.05;
		}
	}
}
#/

drawBounds()
{
/#
	red = ( 0.9, 0.2, 0.2 );
	if( isdefined(level.bounds_min) && isdefined(level.bounds_max) )
	{
		start = ( level.bounds_min.origin[0], level.bounds_min.origin[1], level.bounds_min.origin[2] );
		end = ( level.bounds_min.origin[0], level.bounds_max.origin[1], level.bounds_min.origin[2] );
		line( start, end, red, 0.9 );
		
		start = ( level.bounds_min.origin[0], level.bounds_max.origin[1], level.bounds_min.origin[2] );
		end = ( level.bounds_max.origin[0], level.bounds_max.origin[1], level.bounds_min.origin[2] );
		line( start, end, red, 0.9 );
		
		start = ( level.bounds_max.origin[0], level.bounds_max.origin[1], level.bounds_min.origin[2] );
		end = ( level.bounds_max.origin[0], level.bounds_min.origin[1], level.bounds_min.origin[2] );
		line( start, end, red, 0.9 );
		
		start = ( level.bounds_max.origin[0], level.bounds_min.origin[1], level.bounds_min.origin[2] );
		end = ( level.bounds_min.origin[0], level.bounds_min.origin[1], level.bounds_min.origin[2] );
		line( start, end, red, 0.9 );
	}
	else
	{
		line( (-1000, -1000, 500), (-1000,  1000, 500), red, 0.9 );
		line( (-1000,  1000, 500), ( 1000,  1000, 500), red, 0.9 );
		line( ( 1000,  1000, 500), ( 1000, -1000, 500), red, 0.9 );
		line( ( 1000, -1000, 500), (-1000, -1000, 500), red, 0.9 );
	}
#/
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
	self SetClientFlag( level.const_flag_operatingchoppergunner );

	for (;;)
	{
		if ( self UseButtonPressed() )
		{
			if ( !inverted )
			{
				self SetInfraredVision( true );
				self SetVisionSetForPlayer( level.chopper_infrared_vision, 0.5 );
			}
			else
			{
				self SetInfraredVision( false );
				self SetVisionSetForPlayer( level.chopper_enhanced_vision, 0.5 );
			}

			inverted = !inverted;
			
			// wait for the button to release:
			while ( self UseButtonPressed() )
				wait( 0.05 );
		}
		wait( 0.05 );
	}
}
