#include maps\_utility;
#include maps\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\sp_killstreaks\_airsupport;

preload()
{
	maps\sp_killstreaks\_radar::preload();
	level.fx_sr71_trail = loadfx("misc/fx_equip_sr71_contrail");
	level.fx_sr71_glint = loadfx("misc/fx_equip_sr71_sky_glint");
	level.fx_spyplane_afterburner = loadfx("vehicle/exhaust/fx_exhaust_u2_spyplane_afterburner");
	level.fx_u2_damage_trail = loadfx("trail/fx_trail_u2_plane_damage_sp");
	level.fx_u2_explode = loadfx("vehicle/vexplosion/fx_vexplode_u2_exp_sp");

	level.spyplanemodel = "t5_veh_jet_u2";
	precachemodel( level.spyplanemodel );

}

init()
{
	maps\sp_killstreaks\_radar::init();
	
	
	level.u2_maxhealth = 700;
	
	level.spyplane = [];
	level.spyplaneEntranceTime = 5;
	level.spyplaneExitTime = 20;
	
	level.counteruavWeapon = "counteruav_sp";	
	level.counteruavLength = 25.0;
	
	level.counteruavplaneEntranceTime = 5;
	level.counteruavplaneExitTime = 20;
	
	
	level.satelliteHeight = 10000;
	level.satelliteFlyDistance = 10000;
	

	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	/*
	if ( miniMapOrigins.size )
		uavOrigin = maps\mp\gametypes\_spawnlogic::findBoxCenter( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
	else
	*/
		uavOrigin = (0,0,0);


	level.activeUAVs = [];	
	level.activeCounterUAVs = [];	
	level.activeSatellites = [];

	level.UAVRig = spawn( "script_model", uavOrigin );
	level.UAVRig setModel( "tag_origin" );
	level.UAVRig.angles = (0,115,0);
	level.UAVRig hide();

	level.UAVRig thread rotateUAVRig(true);
	
	level.CounterUAVRig = spawn( "script_model", uavOrigin );
	level.CounterUAVRig setModel( "tag_origin" );
	level.CounterUAVRig.angles = (0,115,0);
	level.CounterUAVRig hide();

	level.CounterUAVRig thread rotateUAVRig(false);
	
	level thread UAVTracker();
	level thread onPlayerConnect();
	
	players = get_players();
	for(i = 0; i < players.size; i++ )
	{
		player = players[i];
		player.entnum = player getEntityNumber();
		level.activeUAVs[ player.entnum ] = 0;
		level.activeCounterUAVs[ player.entnum ] = 0;
		level.activeSatellites[ player.entnum ] = 0;
	}
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		player.entnum = player getEntityNumber();
		level.activeUAVs[ player.entnum ] = 0;
		level.activeCounterUAVs[ player.entnum ] = 0;
		level.activeSatellites[ player.entnum ] = 0;
	}
}

watchFFASpawn()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "spawned_player" );
		level notify( "uav_update" );
	}	
}

rotateUAVRig( clockwise )
{
	turn = 360;
	if ( clockwise )
		turn = -360;
	
	for (;;)
	{
		self rotateyaw( turn, 60 );
		wait ( 60 );
	}
}

callcounteruav( type, displayMessage )
{
	timeInAir = self maps\sp_killstreaks\_radar::useRadarItem( type, self.team, displayMessage);
	isCounter = 1;

	// generate the plane for team based and FFA
	counteruavplane = generatePlane( self, timeInAir, isCounter );
	if ( !isdefined( counteruavplane ) )
	{
		return false;
	}
	counteruavplane SetClientFlag( level.const_flag_counteruav );			
	counteruavplane addActiveCounterUAV();
	counteruavplane thread counteruavplane_death_waiter();	
	counteruavplane thread counteruavplane_timeout( timeInAir );

	return true;
}


callspyplane( type, displayMessage )
{
	timeInAir = self maps\sp_killstreaks\_radar::useRadarItem( type, self.team, displayMessage);	
 	isCounter = 0;

	spyplane = generatePlane( self, timeInAir, isCounter );
	if ( !isdefined( spyplane ) )
		return false;
	spyplane addActiveUAV();
	spyplane thread spyplane_timeout( timeInAir );
	spyplane thread spyplane_death_waiter();	

	return true;
}


callsatellite( type, displayMessage )
{
	timeInAir = self maps\sp_killstreaks\_radar::useRadarItem( type, self.team, displayMessage);	
	satellite = Spawn( "script_model", level.mapcenter + ( ( 0 - level.satelliteFlyDistance ), 0, level.satelliteHeight ) ); 
	satellite setModel( "tag_origin" );
	satellite moveto( level.mapcenter + ( level.satelliteFlyDistance, 0, level.satelliteHeight ), timeInAir );
	satellite.owner = self;
	satellite.team = self.team;
	satellite.otherteam = "axis";
	if (satellite.team == "axis")
		satellite.otherteam = "allies";
	satellite setTeam(self.team);
	satellite setOwner( self );
	satellite.targetname = "satellite";
	satellite addActiveSatellite();
	satellite thread satellite_timeout( timeInAir );

	return true;
}

addActiveCounterUAV()
{
	assert( isdefined( self.owner.entnum ) );
	if ( !isdefined( self.owner.entnum ) )
		self.owner.entnum = self.owner getEntityNumber();
	level.activeCounterUAVs[self.owner.entnum]++;
	level notify ( "uav_update" );
}

addActiveUAV()
{
	assert( isdefined( self.owner.entnum ) );
	if ( !isdefined( self.owner.entnum ) )
		self.owner.entnum = self.owner getEntityNumber();
	level.activeUAVs[self.owner.entnum]++;

	level notify ( "uav_update" );
}

addActiveSatellite()
{
	assert( isdefined( self.owner.entnum ) );
	if ( !isdefined( self.owner.entnum ) )
		self.owner.entnum = self.owner getEntityNumber();
	level.activeSatellites[self.owner.entnum]++;

	level notify ( "uav_update" );
}

removeActiveUAV()
{
	if ( isDefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		
		level.activeUAVs[self.owner.entnum]--;
		assert( level.activeUAVs[self.owner.entnum] >= 0 );
		if ( level.activeUAVs[self.owner.entnum] < 0 ) 
			level.activeUAVs[self.owner.entnum] = 0;
	}
	
	maps\sp_killstreaks\_killstreakrules::killstreakStop( "radar_sp", self.team );
	level notify ( "uav_update" );
}

removeActiveCounterUAV()
{
	if ( isDefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		
		level.activeCounterUAVs[self.owner.entnum]--;
		assert( level.activeCounterUAVs[self.owner.entnum] >= 0 );
		if ( level.activeCounterUAVs[self.owner.entnum] < 0 ) 
			level.activeCounterUAVs[self.owner.entnum] = 0;
	}

	maps\sp_killstreaks\_killstreakrules::killstreakStop( "counteruav_sp", self.team );
	level notify ( "uav_update" );

}

removeActiveSatellite()
{
	if ( isDefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		level.activeSatellites[self.owner.entnum]--;
		assert( level.activeSatellites[self.owner.entnum] >= 0 );
		if ( level.activeSatellites[self.owner.entnum] < 0 ) 
			level.activeSatellites[self.owner.entnum] = 0;
	}
	maps\sp_killstreaks\_killstreakrules::killstreakStop( "radardirection_sp", self.team );
	level notify ( "uav_update" );
}


playSpyplaneFX()
{
	wait( 0.1 );
	PlayFXOnTag( level.fx_spyplane_afterburner, self, "tag_origin" );
}


playSatelliteFX()
{
	wait( 0.1 );
	PlayFXOnTag( level.fx_sr71_trail, self, "tag_origin" );
	PlayFXOnTag( level.fx_sr71_glint, self, "tag_origin" );
}

generatePlane( owner, timeInAir, isCounter )
{
	UAVRig = level.UAVRig;
	attach_angle = -90;
	
	if ( isCounter )
	{
		UAVRig = level.CounterUAVRig;
		attach_angle = 90;
	}
		
	plane = spawn( "script_model", UAVRig getTagOrigin( "tag_origin" ) );
	
	plane setModel( level.spyplanemodel );
	plane SetTeam( owner.team );
	plane SetOwner( owner );
	Target_Set( plane );

	plane.owner = owner;
	plane.team = owner.team;
	plane.otherteam = "axis";
	if (plane.team == "axis")
		plane.otherteam = "allies";
	
	plane thread updateVisibility( );
	plane thread handleIncomingMissile();
	
	level.plane[self.team] = plane;
	plane.health_low = level.u2_maxhealth*0.5;		// when damage taken is above this value, spyplane catchs on fire
	plane.maxhealth = level.u2_maxhealth;
	plane.health = 99999;
	plane.rocketDamageOneShot = level.u2_maxhealth + 1;			// Make it so the heatseeker blows it up in one hit
	plane.rocketDamageTwoShot = (level.u2_maxhealth / 2) + 1;	// Make it so the heatseeker blows it up in two hit

	zOffset = randomIntRange( 3000, 5000 );

	angle = randomInt( 360 );
	radiusOffset = randomInt( 2000 ) + 5000;

	xOffset = cos( angle ) * radiusOffset;
	yOffset = sin( angle ) * radiusOffset;

	angleVector = vectorNormalize( (xOffset,yOffset,zOffset) );
	angleVector = ( angleVector * randomIntRange( 6000, 7000 ) );

	plane linkTo( UAVRig, "tag_origin", angleVector, (0,angle + attach_angle,0) );
	
	return plane;
}

updateVisibility()
{
	self endon ( "death" );
	
	for ( ;; )
	{
		self SetVisibleToAll();
		//self SetInvisibleToPlayer( self.owner );

		level waittill( "joined_team" );
	}	
}

/#
debugLine(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		wait (0.05);
	}
}
#/

playDamageFX()
{
	self endon( "death" );
	self endon( "crashing" );
	while (1)
	{
		playfxontag( level.fx_u2_damage_trail, self, "tag_origin" );
		wait (10);
	}
	
}

u2_crash()
{
	self notify( "crashing" );
	playfxontag( level.fx_u2_explode, self, "tag_origin" );
	wait (0.1);
	self setModel( "tag_origin" );
	wait(0.2);
	self notify( "delete" );
	self delete();
}

counteruavplane_death_waiter()
{
	self endon( "delete" );
	self endon ( "leaving");
	
	self waittill( "death" );
	
	counteruavplane_death();
}

spyplane_death_waiter()
{
	self endon( "delete" );
	self endon ( "leaving");
	
	self waittill( "death" );
	
	spyplane_death();
}

counteruavplane_death()
{
	self ClearClientFlag( level.const_flag_counteruav );
	self removeActiveCounterUAV();
	Target_Remove( self );
	self thread u2_crash();	
}


spyplane_death()
{
	self removeActiveUAV();
	Target_Remove( self );
	self thread u2_crash();	
}

counteruavplane_timeout( timeInAir )
{
	self endon ( "death" );
	self endon ( "delete" );
	
	endTime = gettime() + timeInAir * 1000 ;
	
	self.endTime = endTime;

	wait( timeInAir );

	self ClearClientFlag( level.const_flag_counteruav );
	self plane_leave();
	wait (level.counteruavplaneExitTime);
	self removeActiveCounterUAV();
	Target_Remove( self );
	self delete();
}


satellite_timeout( timeInAir )
{
	self endon ( "death" );
	self endon ( "delete" );
	
	endTime = gettime() + timeInAir * 1000 ;
	self.endTime = endTime;
	
	self wait_endon( timeInAir, "emp_deployed" );
	
	self removeActiveSatellite();
	self delete();
}

spyplane_timeout( timeInAir )
{
	self endon ( "death" );
	self endon ( "delete" );
	
	endTime = gettime() + timeInAir * 1000 ;
	self.endTime = endTime;

	self thread completeTimeInAir( timeInAir );

	self waittill( "spyplaneShouldLeave" );

	self plane_leave();
	wait (level.spyplaneExitTime);	
	self removeActiveUAV();	
	Target_Remove( self );
	self delete();
}

completeTimeInAir( duration )
{
	self endon( "spyplaneShouldLeave" );
	wait( duration );
	self notify( "spyplaneShouldLeave" );
}


plane_leave()
{	
	self unlink();
	self thread playSpyplaneFX();
	self.currentstate = "leaving";
	
	mult = GetDvarIntDefault( "scr_spymult", 20000 );
	
	exitVector = ( anglestoforward( self.angles ) * 20000 );
	
	exitPoint = ( self.origin[0] + exitVector[0], self.origin[1] + exitVector[1], self.origin[2] - 2500);
	exitPoint = self.origin + exitVector;

	self.angles = (self.angles[0], self.angles[1], 0);
	self moveto( exitPoint, level.spyplaneExitTime, 0, 0 );
	self notify ( "leaving");
}


handleIncomingMissile()
{
	level endon ( "game_ended" );
	self endon ( "death" );
	
	for ( ;; )
	{
		level waittill ( "missile_fired", player, missile, lockTarget, fullyAquired );
		
		if ( !IsDefined( lockTarget ) || (lockTarget != self) || !fullyAquired )
			continue;
			
		missile thread missileProximityDetonate( lockTarget, player );
	}
}

missileDetonate( player )
{
	self endon ( "death" );
	radiusDamage( self.origin, 1536, 600, 600, player );
	wait( 0.05 );
	self detonate();
	wait( 0.05 );
	self delete();
}

missileProximityDetonate( targetEnt, player )
{
	self endon ( "death" );
	targetEnt endon( "crashing" );

	minDist = distance( self.origin, targetEnt.origin );
	lastCenter = targetEnt.origin;

	for ( ;; )
	{
		// UAV already destroyed
		if ( !isDefined( targetEnt ) )
			center = lastCenter;
		else
			center = targetEnt.origin;
			
		lastCenter = center;		
		
		curDist = distance( self.origin, center );
		
		if ( curDist < minDist )
			minDist = curDist;
		
		if ( curDist > minDist )
		{
			if ( curDist > 1536 )
				return;
				
			self thread missileDetonate( player );
		}
		
		wait ( 0.05 );
	}	
}


UAVTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level waittill ( "uav_update" );
		
		updatePlayersUAVStatus();
	}
}


updateTeamUAVStatus( team )
{
	activeUAVs = level.activeUAVs[team];
	activeSatellites = level.activeSatellites[team];
	radarMode = 1;
	
	if ( activeUAVs > 1 )
		radarMode = 2;
}

updatePlayersUAVStatus()
{
	flag_wait( "all_players_connected" );
	
	players = get_players();
	for(i = 0; i < players.size; i++ )
	{
		player = players[i];
		assert( isdefined( player.entnum ) );
		if ( !isdefined( player.entnum ) )
			player.entnum = player getEntityNumber();
		activeUAVs = level.activeUAVs[ player.entnum ];
		activeSatellites = level.activeSatellites[ player.entnum ];
		
		if ( activeSatellites > 0 )
		{
			player.hasSatellite = true;
			player.hasSpyplane = 0;
			//player setClientUIVisibilityFlag( "radar_client", 1 );
			continue;
		}
		
		player.hasSatellite = false;
		
		if ( ( activeUAVs == 0 ) && !( isDefined( player.pers["hasRadar"] ) && player.pers["hasRadar"] ) )
		{
			player.hasSpyplane = 0;
			//player setClientUIVisibilityFlag( "radar_client", 0 );
			continue;
		}
		
		if ( activeUAVs > 1 )
			spyplaneUpdateSpeed = 2;
		else
			spyplaneUpdateSpeed = 1;
						
		//player setClientUIVisibilityFlag( "radar_client", 1 );
		player.hasSpyplane = spyplaneUpdateSpeed;
	}
}



