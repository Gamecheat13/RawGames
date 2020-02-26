#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	PreCacheModel("t5_veh_rcbomb_allies");
	PreCacheModel("t5_veh_rcbomb_axis");
	PrecacheVehicle("rc_car_medium_mp");
	PreCacheRumble( "rcbomb_engine_stutter" );
	PreCacheRumble( "rcbomb_slide" );
	
	loadTreadFx( "dust" );
	loadTreadFx( "concrete" );
	loadTreadFx( "snow" );

	loadfx( "weapon/grenade/fx_spark_disabled_rc_car" );
	loadfx( "vehicle/light/fx_rcbomb_blinky_light" );
	loadfx( "vehicle/light/fx_rcbomb_solid_light" );
	loadfx( "vehicle/light/fx_rcbomb_light_green_os" );
	loadfx( "vehicle/light/fx_rcbomb_light_red_os" );

	maps\mp\_treadfx::preloadtreadfx("rc_car_medium_mp");
	
	level._effect["rcbombexplosion"] = loadfx("maps/mp_maps/fx_mp_exp_rc_bomb");

	car_size = GetDvar( "scr_rcbomb_car_size");
	if ( car_size == "" )
	{
		SetDvar("scr_rcbomb_car_size","1");
	}
	
	if ( GetDvar( "scr_rcbomb_notimeout" ) == "" )
		SetDvar( "scr_rcbomb_notimeout", "0" );

	// register the rcbomb hardpoint
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowrcbomb" ) )
	{
		maps\mp\killstreaks\_killstreaks::registerKillstreak("rcbomb_mp", "rcbomb_mp", "killstreak_rcbomb", "rcbomb_used", ::useKillstreakRCBomb );
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("rcbomb_mp", &"KILLSTREAK_EARNED_RCBOMB", &"KILLSTREAK_RCBOMB_NOT_AVAILABLE", &"KILLSTREAK_RCBOMB_INBOUND");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("rcbomb_mp", "mpl_killstreak_rcbomb", "kls_rcbomb_used", "","kls_rcbomb_enemy", "", "kls_rcbomb_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("rcbomb_mp", "scr_givercbomb");
		maps\mp\killstreaks\_killstreaks::allowKillstreakAssists("rcbomb_mp", true);
	
		// this causes the player to keep holding the weapon until the hardpoint is done
//		maps\mp\killstreaks\_killstreaks::setRemoveWeaponWhenUsed("rcbomb_mp", true);
	}
	
	//Sets up RC bomb to die from trigger_hurt's. Threaded because there is a 'spread_array_thread()' within it.
	level thread trigger_monitor_init();

// Uncomment next line to override the default visionset when using the rc car	
//	level.rcbomb_vision = "remote_mortar_enhanced";
}

loadTreadFx( type )
{
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_drift" );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_peel" );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_first_person" );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_reverse" );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_trail" );
	loadfx( "vehicle/treadfx/fx_treadfx_rcbomb_" + type + "_slow" );
}

useKillstreakRCBomb(hardpointType)
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;
	
	if (!self IsOnGround())
	{
		self iPrintLnBold( &"KILLSTREAK_RCBOMB_NOT_PLACEABLE" );
		return false;
	}
		
	placement = self.rcbombPlacement;
	if ( !isDefined( placement ) )
		placement = getRCBombPlacement();
	if ( !IsDefined( placement ) )
	{
		self iPrintLnBold( &"KILLSTREAK_RCBOMB_NOT_PLACEABLE" );
		return false;
	}
	
	self setUsingRemote( "rcbomb" );
	self freezeControlsWrapper( true );

	result = self maps\mp\killstreaks\_killstreaks::initRideKillstreak( "rcbomb" );		
	if ( result != "success" )
	{
		if ( result != "disconnect" )
			self clearUsingRemote();

		return false;
	}	

	ret = self useRCBomb(placement);
	
	if ( !IsDefined(ret) && level.gameEnded )
		ret = true;
	else if( !IsDefined(ret) )
		ret = false;
		
	self clearUsingRemote();

	return ret;
}

spawnRCBomb(placement, team)
{
	car_size = GetDvar( "scr_rcbomb_car_size");
	
	model = "t5_veh_rcbomb_allies";
	enemymodel = "t5_veh_rcbomb_axis";
	death_model = "t5_veh_rcbomb_allies";
	car = "rc_car_medium_mp";
	
	vehicle = SpawnVehicle(
	model,
	"rcbomb",
	car,
	placement.origin,
	placement.angles );
	
	vehicle MakeVehicleUnusable();
	vehicle.death_model = death_model;
	vehicle.allowFriendlyFireDamageOverride = ::RCCarAllowFriendlyFireDamage;
	vehicle setEnemyModel(enemymodel);

	vehicle SetOwner( self );
	vehicle SetVehicleTeam( team );
	vehicle.team = team;

	maps\mp\_treadfx::loadtreadfx(vehicle);
	
	// create the influencers
	vehicle maps\mp\gametypes\_spawning::create_rcbomb_influencers(team);

	return vehicle;
}

getRCBombPlacement()
{
	return calculateSpawnOrigin( self.origin, self.angles );
}

givePlayerControlOfRCBomb()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );
	
	self thread maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "rcbomb_mp", self.team );
	self AddPlayerStat( "RCBOMB_USED", 1 );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( "rcbomb_mp" , "used", 1 );
	
	xpAmount = maps\mp\killstreaks\_killstreaks::getXPAmountForKillstreak( "rcbomb_mp" );
	self AddRankXPValue( "medal", xpAmount );
	
	self freeze_player_controls( false );

	self.rcbomb usevehicle( self, 0 );
	
	self thread playerDisconnectWaiter( self.rcbomb );
	self thread carDetonateWaiter( self.rcbomb );
	//self thread carDeathWaiter( self.rcbomb );
	self thread exitCarWaiter( self.rcbomb );
	self thread GameEndWatcher( self.rcbomb );
	self thread changeTeamWaiter( self.rcbomb );
	self.rcbomb thread maps\mp\_flashgrenades::monitorRCBombFlash();
	self thread carTimer( self.rcbomb );
	
	self waittill( "rcbomb_done" );
}

useRCBomb( placement )
{
	self endon("disconnect");
	level endon ( "game_ended" );
	
	hardpointtype = "rcbomb_mp";
	
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	if ( !isDefined( self ) || !isAlive( self ) ||  ( self IsRemoteControlling() ) )
	{
		IPrintLnBold( "EXITING" );
		return false;
	}
	
	if ( !IsDefined( self.rcbomb ) )
	{
		self.rcbomb = self spawnRCBomb(placement, self.team );
		self.rcbomb thread carCleanupWaiter( self.rcbomb );
		self.rcbomb.team = self.team;
		if ( !IsDefined( self.rcbomb ) )
		{
			return false;
		}
	
		self maps\mp\gametypes\_weaponobjects::addWeaponObjectToWatcher( "rcbomb", self.rcbomb );
	}

	if ( self maps\mp\killstreaks\_killstreakrules::killstreakStart( hardpointtype, self.team, undefined, false ) == false )
		return false;

	self.enteringVehicle = true;

	self thread updateKillstreakOnDisconnect();
	self thread updateKillstreakOnDeletion( self.team );

	self freeze_player_controls( true );
	
	if ( !IsDefined( self ) || !IsAlive( self ) || !IsDefined( self.rcbomb ) )
	{
		if( IsDefined( self ) )
		{
			self.enteringVehicle = false;
			self notify("weapon_object_destroyed");
		}
		return false;
	}
	
	self thread givePlayerControlOfRCBomb();
	self.rcbomb thread watchForScramblers();
	self.killstreak_waitamount = 30000;
	self.enteringVehicle = false;
	self StopShellshock();
	
	if ( isdefined( level.killstreaks[hardpointType] ) && isdefined( level.killstreaks[hardpointType].inboundtext ) )
		level thread maps\mp\_popups::DisplayKillstreakTeamMessageToAll( hardpointType, self );
	
	if ( IsDefined( level.rcbomb_vision ) )
		self thread setVisionsetWaiter();
	
	self updateRulesOnEnd();
	
	return true;
}


watchForScramblers() // self == scrambler
{
	self endon( "death" );

	// If we enter the effect radius of the scrambler then stun
	while( true )
	{
		scrambled = self GetClientFlag( level.const_flag_stunned );
		
		shouldScramble = false;
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i] ) || !isDefined( players[i].scrambler ) )
			{
				continue;
			}

			player = players[i];
			scrambler = player.scrambler;
			
			// for teambased modes don't stun if the scrambler and rc are on the same team
			if( level.teambased && self.team == player.team )
			{
				continue;
			}
			
			// for non-teambased modes don't stun the rc if the owner's are the same player
			if( !level.teambased && self.owner == player )
			{
				continue;
			}

			if( DistanceSquared( scrambler.origin, self.origin ) < level.scramblerInnerRadiusSq )
			{
				shouldScramble = true;
				break;
			}
		}

		if ( shouldScramble == true && scrambled == false ) 
		{
			self SetClientFlag( level.const_flag_stunned );
		}
		else if ( shouldScramble == false && scrambled == true ) 
		{
			self ClearClientFlag( level.const_flag_stunned );
		}

		wait_delay = RandomFloatRange( 0.25, 0.5 );
		wait( wait_delay );
	}
}
	
updateRulesOnEnd()
{
	team = self.rcbomb.team;
	//self endon("death"); 
	self endon("disconnect"); 
	
	self waittill( "rcbomb_done" );
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "rcbomb_mp", team );		
}

updateKillstreakOnDisconnect()
{
	team = self.rcbomb.team;
	self endon("rcbomb_done");
	self waittill("disconnect"); 
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "rcbomb_mp", team );
}

//Protection on the edge case you are killed right as you drop the rc bomb but before you can link to it.
//The rc bomb will be deleted on respawn so ensure that the killstreak rules are updated.
updateKillstreakOnDeletion( team )
{
	self endon("disconnect");
	self endon("rcbomb_done");

	self waittill( "weapon_object_destroyed" );
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "rcbomb_mp", team );
	
	if( isDefined( self.rcbomb ) )
		self.rcbomb delete();
}

carDetonateWaiter( vehicle )
{
	//self endon("death"); 
	self endon("disconnect"); 
	vehicle endon("death"); 
	
	watcher = maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "rcbomb" );
		
	while( !self attackbuttonpressed() ) 
		wait 0.05;
		
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(vehicle,0);
	
	self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( GetDvarfloat( "scr_rcbomb_fadeOut_delay" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeIn" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeBlack" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeOut" ) );
}

playerDisconnectWaiter( vehicle )
{
	vehicle endon("death"); 
	self endon("rcbomb_done"); 

	self waittill( "disconnect" );
		
	vehicle Delete();
}

GameEndWatcher( vehicle )
{
	vehicle endon("death"); 
	self endon("rcbomb_done"); 

	level waittill( "game_ended" );
		
	watcher = maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "rcbomb" );
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(vehicle,0);
	
	self thread maps\mp\gametypes\_hud::fadeToBlackForXSec( GetDvarfloat( "scr_rcbomb_fadeOut_delay" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeIn" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeBlack" ), GetDvarfloat( "scr_rcbomb_fadeOut_timeOut" ) );

}

exitCarWaiter( vehicle )
{
	//self endon("death"); 
	self endon("disconnect"); 

	self waittill( "unlink" );
	
	self notify("rcbomb_done");
}

changeTeamWaiter( vehicle )
{
	self endon("disconnect"); 
	self endon("rcbomb_done"); 
	vehicle endon("death");
	
	self waittill_either( "joined_team", "joined_spectators" );
	
	vehicle.owner Unlink();
	self.killstreak_waitamount = undefined;
	vehicle Delete();
}

carDeathWaiter( vehicle )
{
	self endon("disconnect"); 
	self endon("rcbomb_done"); 

	self waittill( "death" );
	
	maps\mp\killstreaks\_killstreaks::removeUsedKillstreak("rcbomb_mp");	
	self notify("rcbomb_done");
}

carCleanupWaiter( vehicle )
{
	self endon("disconnect"); 

	self waittill( "death" );
	
	self.rcbomb = undefined;
}

setVisionsetWaiter()
{
	self endon("disconnect"); 
	
	self UseServerVisionset( true );
	self SetVisionSetForPlayer( level.rcbomb_vision, 1 );

	self waittill("rcbomb_done"); 
	
	self UseServerVisionset( false );
}

carTimer( vehicle )
{
	self endon("disconnect"); 
	vehicle endon("death"); 
	
	if ( GetDvarIntDefault( "scr_rcbomb_notimeout", 0 ) ) 
		return;

	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 20 );
	vehicle SetClientFlag( level.const_flag_countdown );
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 6 );
	// this second state is needed for killcam
	vehicle SetClientFlag( level.const_flag_timeout );
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 4 );
	
	watcher = maps\mp\gametypes\_weaponobjects::getWeaponObjectWatcher( "rcbomb" );
	watcher thread maps\mp\gametypes\_weaponobjects::waitAndDetonate(vehicle,0);
}

detonateIfTouchingSphere( origin, radius )
{
	if ( DistanceSquared( self.origin, origin ) < radius * radius )
	{
		self rcbomb_force_explode();
	}
}

detonateAllIfTouchingSphere( origin, radius )
{
	rcbombs = GetEntArray( "rcbomb","targetname" );
	for ( index = 0; index < rcbombs.size; index ++ )
	{
		rcbombs[index] detonateIfTouchingSphere(origin, radius);
	}
}

blowup(attacker)
{
	self.owner endon("disconnect");
	self endon ("death");
	 
	explosionOrigin = self.origin;
	explosionAngles = self.angles;
	
	if ( !IsDefined( attacker ) )
	{
		attacker = self.owner;
	}
	
	origin = self.origin + (0,0,10);
	radius = 256;
	min_damage = 25;
	max_damage = 350;
	self radiusDamage( origin, radius, max_damage, min_damage, attacker,"MOD_EXPLOSIVE", "rcbomb_mp");
	PhysicsExplosionSphere( origin, radius, radius, 1, max_damage, min_damage );
	maps\mp\gametypes\_shellshock::rcbomb_earthquake( origin );

	// CDC - play rc car exlposion sound TO DO replace with final explo sound after effects are in 
	playsoundatposition("mpl_sab_exp_suitcase_bomb_main", self.origin);

	PlayFX(level._effect["rcbombexplosion"] , explosionOrigin, (0, randomfloat(360), 0 ));

	self SetModel( self.death_model );
	self Hide();

	if ( attacker != self.owner )
	{	
		thread maps\mp\gametypes\_globallogic_score::givePlayerScore( "rcbombdestroy", attacker );
		attacker maps\mp\_medals::destroyerRCBomb();
		attacker maps\mp\_properks::destroyedKillstreak();

		if( IsDefined( attacker.weaponUsedToDamage ) )
		{
			weapon = attacker.weaponUsedToDamage;
			weaponStatName = "destroyed";
			switch( weapon )
			{
				// SAM Turrets keep the kills stat for shooting things down because we used destroyed for when you destroy a SAM Turret
			case "auto_tow_mp":
			case "tow_turret_mp":
			case "tow_turret_drop_mp":
				weaponStatName = "kills";
				break;
			}
			attacker AddWeaponStat( weapon, weaponStatName, 1 );
			level.globalKillstreaksDestroyed++;
			// increment the destroyed stat for this, we aren't using the weaponStatName variable from above because it could be "kills" and we don't want that
			attacker AddWeaponStat( "rcbomb_mp", "destroyed", 1 );
		}
	}

	//self.owner endon("death");
	wait(1);
	if ( isDefined( self.neverDelete ) && self.neverDelete )
	{
		return;
	}
	
	
	self.owner Unlink();
	self.owner.killstreak_waitamount = undefined;
	self Delete();
	
//	damageOrigin = self.origin + (0,0,1);
//	self finishVehicleRadiusDamage(attacker, attacker, 32000, 32000, 10, 0, "MOD_EXPLOSIVE", "defaultweapon_mp",  damageOrigin, 400, -1, (0,0,1), 0);
//	self finishVehicleDamage(attacker, attacker, 32000, 0, "MOD_EXPLOSIVE", "defaultweapon_mp", damageOrigin, (0,0,1), 0, 0, false, 0, 0, false);
}

RCCarAllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, sWeapon )
{
	if ( IsDefined( eAttacker ) && eAttacker == self.owner )
		return true;
		
	if ( IsDefined( eInflictor ) && eInflictor islinkedto( self ) )
		return true;
	
	return false;
}

getPlacementStartHeight()
{
	startheight = 50;
	
	switch( self GetStance() )
	{
		case "crouch":
			startheight = 30;
			break;
		case "prone":
			startheight = 15;
			break;
	}
	return startheight;
}

calculateSpawnOrigin( origin, angles )
{

	distance_from_player = 70;

	startheight = getPlacementStartHeight();
	
	mins = (-5,-5,0); // keep the min z 0 so the return point is the exact height of the collision
	maxs = (5,5,10);

	//trace = bulletTrace( startPoint, endPoint, false, self );
	
	startPoints = [];
	startAngles = [];
	wheelCounts = [];
	testCheck = [];
	largestCount = 0;
	largestCountIndex = 0;
	
	testangles = [];
	testangles[0] = (0,0,0);
	testangles[1] = (0,20,0);
	testangles[2] = (0,-20,0);
	testangles[3] = (0,45,0);
	testangles[4] = (0,-45,0);
	
	heightoffset = 5;
	
	for (i = 0; i < testangles.size; i++ )
	{
		testCheck[i] = false;

		startAngles[i] = ( 0, angles[1], 0 );
		startPoint = origin + VectorScale( anglestoforward( startAngles[i] + testangles[i]), distance_from_player );
		endPoint = startPoint - (0,0,100);
		startPoint = startPoint + (0,0,startheight);

		// ignore water on this one
		mask =  level.PhysicsTraceMaskPhysics | level.PhysicsTraceMaskVehicle;
			
		// using physicstrace so we dont slip through small cracks
		trace = physicstrace( startPoint, endPoint, mins, maxs, self, mask);
			
		// if any player intersection then skip
		if ( IsDefined(trace["entity"]) && IsPlayer(trace["entity"]))
			continue;
			 
		startPoints[i] = trace["position"] + (0,0,heightoffset);
		wheelCounts[i] = testWheelLocations(startPoints[i],startAngles[i],heightoffset);
		
		if ( positionWouldTelefrag( startPoints[i] ) )
			continue;
	
		if ( largestCount < wheelCounts[i] )
		{
			largestCount = wheelCounts[i];
			largestCountIndex = i;
		}
		
		// going to early out on the first I find with valid tire positions
		if ( wheelCounts[i] >=  3 )
		{
			testCheck[i] = true;

			if ( testSpawnOrigin( startPoints[i], startAngles[i] ) )
			{
				placement = SpawnStruct();
				placement.origin = startPoints[i];
				placement.angles = startAngles[i];
				return placement;
			}
		}
	}
	
	for (i = 0; i < testangles.size; i++ )
	{
		if ( !testCheck[i] )
		{
			if ( wheelCounts[i] >=  2 )
			{
				if ( testSpawnOrigin( startPoints[i], startAngles[i] ) )
					{
						placement = SpawnStruct();
						placement.origin = startPoints[i];
						placement.angles = startAngles[i];
						return placement;
					}
				}
		}
	}
	
	return undefined;
}

testWheelLocations( origin, angles, heightoffset )
{
	forward = 13;
	side = 10;
	
	wheels = [];
	wheels[0] = ( forward, side, 0 );
	wheels[1] = ( forward, -1 * side, 0 );
	wheels[2] = ( -1 * forward, -1 * side, 0 );
	wheels[3] = ( -1 * forward, side, 0 );

	height = 5;
	touchCount = 0;
	
	yawangles = (0,angles[1],0);
	
	for (i = 0; i < 4; i++ )
	{
		wheel = RotatePoint( wheels[i], yawangles  );
		startPoint = origin + wheel;
		endPoint = startPoint + (0,0,(-1 * height) - heightoffset);
		startPoint = startPoint + (0,0,height - heightoffset) ;
	
		trace = bulletTrace( startPoint, endPoint, false, self );
		if ( trace["fraction"] < 1 )
		{
			touchCount++;
			rcbomb_debug_line( startPoint, endPoint,(1,0,0) );
		}
		else
		{
			rcbomb_debug_line( startPoint, endPoint,(0,0,1) );
		}
	}
	
	return touchCount;
}

testSpawnOrigin( origin, angles )
{
	liftedorigin = origin + (0,0,5);
	size = 12;
	height = 15;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	absmins = liftedorigin + mins;
	absmaxs = liftedorigin + maxs;
	
	// check to see if we would telefrag any players
	if ( BoundsWouldTelefrag( absmins, absmaxs ) )
	{
		rcbomb_debug_box( liftedorigin, mins, maxs,(1,0,0) );
		return false;
	}
	else
	{
		rcbomb_debug_box( liftedorigin, mins, maxs,(0,0,1) );
	}
	
	startheight = getPlacementStartHeight();
	
	mask =  level.PhysicsTraceMaskPhysics | level.PhysicsTraceMaskVehicle | level.PhysicsTraceMaskWater;
	// test the volume where we are going to place the car
	// note that this physics trace is not an  oriented box.
	trace = physicstrace( liftedorigin, (origin +(0,0,1)), mins, maxs, self, mask);

	if ( trace["fraction"] < 1 )
	{
		rcbomb_debug_box( trace["position"], mins, maxs, (1,0,0) );
		return false;
	}
	else
	{
		rcbomb_debug_box( (origin +(0,0,1)), mins, maxs, (0,1,0) );
	}

	// swept trace of a small bounding box from head height to where we are placing the car
	// to make sure there is no wall between us and the car
	size = 2.5;
	height = size * 2;
	mins = (-1 * size,-1 * size,0 );
	maxs = ( size,size,height );
	
	sweeptrace = physicstrace( (self.origin + (0,0,startheight)), liftedorigin, mins, maxs, self, mask);

	if ( sweeptrace["fraction"] < 1 )
	{
		rcbomb_debug_box( sweeptrace["position"], mins, maxs, (1,0,0) );
		return false;
	}
	
	return true;
}

//Starts a thread on my trigger_hurt's to check for rc_bombs. Self is the trigger.
trigger_monitor_init()
{
	hurt_triggers = GetEntArray( "trigger_hurt","classname" );
	
	//this function acts as an array_thread, but it has a small 'wait' between each thread
	spread_array_thread( hurt_triggers, ::trigger_monitor );
	
}

//Destroy any rc_bomb that touches it. Self is the trigger.
trigger_monitor()
{
	while(1)
	{
		self waittill ( "trigger", ent );
		
		if ( IsDefined( ent.targetname ) && ent.targetname == "rcbomb" )
		{
			//Kill my rc bomb
			ent rcbomb_force_explode();
		}	
		
		//Slow down my loop, as it doesn't need to go every frame. 
		wait .1;
	}
}

rcbomb_force_explode()
{
	self endon("death");
  assert( self.targetname == "rcbomb" );

	while ( !IsDefined( self getseatoccupant(0) ) )
	{
		wait(0.1);
	}
	self DoDamage( 10,self.origin + (0, 0, 10), self.owner, self.owner, "none", "MOD_EXPLOSIVE" ); 
}


rcbomb_debug_box( origin, mins, maxs, color )
{
/#
	debug_rcbomb = GetDvar( "debug_rcbomb" );
	if ( debug_rcbomb == "1" )
	{
		box( origin, mins, maxs, 0, color, 1, 1, 300 );
	}
#/
}

rcbomb_debug_line( start, end, color )
{
/#
	debug_rcbomb = GetDvar( "debug_rcbomb" );
	if ( debug_rcbomb == "1" )
	{
			line(start, end, color, 1, 1, 300);
	}
#/
}
