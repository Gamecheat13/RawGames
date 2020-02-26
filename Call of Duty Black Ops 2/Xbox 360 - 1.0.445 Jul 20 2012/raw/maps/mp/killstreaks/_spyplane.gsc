#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
#include maps\mp\killstreaks\_airsupport;

#insert raw\maps\mp\_clientflags.gsh;

init()
{
	level.spyplanemodel = "veh_t6_drone_uav";
	level.counterUAVModel = "veh_t6_drone_cuav";
	
	level.u2_maxhealth = 700;
	
	level.spyplane = [];
	level.spyplaneEntranceTime = 5;
	level.spyplaneExitTime = 10;
	
	level.counteruavWeapon = "counteruav_mp";	
	level.counteruavLength = 25.0;
	
	precachemodel( level.spyplanemodel );
	precachemodel( level.counterUAVModel );
	level.counteruavplaneEntranceTime = 5;
	level.counteruavplaneExitTime = 10;
		
	level.fx_spyplane_afterburner = loadfx("vehicle/exhaust/fx_exhaust_u2_spyplane_afterburner");
	level.fx_spyplane_burner = loadfx("vehicle/exhaust/fx_exhaust_u2_spyplane_burner");
	
	level.fx_cuav_afterburner = loadfx("vehicle/exhaust/fx_exhaust_cuav_afterburner");
	level.fx_cuav_burner = loadfx("vehicle/exhaust/fx_exhaust_cuav_burner");
	
	level.satelliteHeight = 10000;
	level.satelliteFlyDistance = 10000;
	
	level.fx_u2_damage_trail = loadfx("trail/fx_trail_u2_plane_damage_mp");
	level.fx_u2_explode = loadfx("vehicle/vexplosion/fx_vexplode_u2_exp_mp");

	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if ( miniMapOrigins.size )
		uavOrigin = maps\mp\gametypes\_spawnlogic::findBoxCenter( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
	else
		uavOrigin = (0,0,0);

	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			level.activeUAVs[team] = 0;
			level.activeCounterUAVs[team] = 0;
			level.activeSatellites[team] = 0;
		}
	}
	else
	{	
		level.activeUAVs = [];	
		level.activeCounterUAVs = [];	
		level.activeSatellites = [];
	}

	level.UAVRig = spawn( "script_model", uavOrigin + (0,0,1100) );
	level.UAVRig setModel( "tag_origin" );
	level.UAVRig.angles = (0,115,0);
	level.UAVRig hide();

	level.UAVRig thread rotateUAVRig(true);
	
	level.CounterUAVRig = spawn( "script_model", uavOrigin + (0,0,1500) );
	level.CounterUAVRig setModel( "tag_origin" );
	level.CounterUAVRig.angles = (0,115,0);
	level.CounterUAVRig hide();

	level.CounterUAVRig thread rotateUAVRig(false);
	
	level thread UAVTracker();
	level thread onPlayerConnect();
	
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
		if ( level.teambased == false )
		{
			player thread watchFFASpawn();
		}
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
		if ( !clockwise )
		{
			self rotateyaw( turn, 40 );
			wait ( 40 );
		}
		else
		{
			self rotateyaw( turn, 60 );
			wait ( 60 );
		}
	}
}

callcounteruav( type, displayMessage, killstreak_id )
{
	timeInAir = self maps\mp\killstreaks\_radar::useRadarItem( type, self.team, displayMessage);
	isCounter = 1;

	// generate the plane for team based and FFA
	counteruavplane = generatePlane( self, timeInAir, isCounter );
	if ( !isdefined( counteruavplane ) )
	{
		return false;
	}
	counteruavplane SetClientFlag( CLIENT_FLAG_COUNTERUAV );			
	counteruavplane addActiveCounterUAV();	
	self.counterUAVTime = GetTime();
	counteruavplane thread playCounterSpyplaneFX();
	counteruavplane thread counteruavplane_death_waiter();	
	counteruavplane thread counteruavplane_timeout( timeInAir );
	counteruavplane thread plane_damage_monitor( false );
	counteruavplane thread plane_health();

	counteruavplane.killstreak_id = killstreak_id;
	counteruavplane.isCounter = true;
	
	counteruavplane PlayLoopSound ("veh_uav_engine_loop", 1);

	return true;
}


callspyplane( type, displayMessage, killstreak_id )
{
	timeInAir = self maps\mp\killstreaks\_radar::useRadarItem( type, self.team, displayMessage);	
 	isCounter = 0;

	spyplane = generatePlane( self, timeInAir, isCounter );
	if ( !isdefined( spyplane ) )
		return false;
	spyplane addActiveUAV();
	self.UAVTime = GetTime();
	spyplane.leaving = false;
	spyplane thread playSpyplaneFX();
	spyplane thread spyplane_timeout( timeInAir );
	spyplane thread spyplane_death_waiter();	
	spyplane thread plane_damage_monitor( true );
	spyplane thread plane_health();
	
	spyplane.killstreak_id = killstreak_id;
	spyplane.isCounter = false;
		
	spyplane PlayLoopSound ("veh_uav_engine_loop", 1);
	
	return true;
}


callsatellite( type, displayMessage, killstreak_id )
{
	timeInAir = self maps\mp\killstreaks\_radar::useRadarItem( type, self.team, displayMessage);	
	satellite = Spawn( "script_model", level.mapcenter + ( ( 0 - level.satelliteFlyDistance ), 0, level.satelliteHeight ) ); 
	satellite setModel( "tag_origin" );
	satellite moveto( level.mapcenter + ( level.satelliteFlyDistance, 0, level.satelliteHeight ), timeInAir );
	satellite.owner = self;
	satellite.team = self.team;
	satellite setTeam(self.team);
	satellite setOwner( self );
	satellite.targetname = "satellite";
	satellite addActiveSatellite();
	self.satelliteTime = GetTime();
	satellite thread satellite_timeout( timeInAir );
	satellite thread watchForEMP();
	satellite.isCounter = false;
	if ( level.teambased ) 
	{
		satellite thread updateVisibility();
	}

	satellite.killstreak_id = killstreak_id;

	return true;
}

addActiveCounterUAV()
{
	if ( level.teamBased )
	{
		self.owner.activeCounterUAVs++;
		level.activeCounterUAVs[self.team]++;	
	}
	else 
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		level.activeCounterUAVs[self.owner.entnum]++;
	}
	level notify ( "uav_update" );
}

addActiveUAV()
{
	if ( level.teamBased )
	{
		self.owner.activeUAVs++;
		level.activeUAVs[self.team]++;	
	}
	else
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		level.activeUAVs[self.owner.entnum]++;
	}

	level notify ( "uav_update" );
}

addActiveSatellite()
{
	if ( level.teamBased )
	{
		self.owner.activeSatellites++;
		level.activeSatellites[self.team]++;	
	}
	else
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		level.activeSatellites[self.owner.entnum]++;
	}

	level notify ( "uav_update" );
}

removeActiveUAV()
{
	if ( level.teamBased )
	{
		if ( self.owner.spawntime < self.birthtime )
		{
			self.owner.activeUAVs--;
			assert( self.owner.activeUAVs >= 0 );
			if ( self.owner.activeUAVs < 0 ) 
				self.owner.activeUAVs = 0;
		}

		level.activeUAVs[self.team]--;
		assert( level.activeUAVs[self.team] >= 0 );
		if ( level.activeUAVs[self.team] < 0 ) 
			level.activeUAVs[self.team] = 0;
	}
	else if ( isDefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		
		level.activeUAVs[self.owner.entnum]--;
		assert( level.activeUAVs[self.owner.entnum] >= 0 );
		if ( level.activeUAVs[self.owner.entnum] < 0 ) 
			level.activeUAVs[self.owner.entnum] = 0;
	}
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "radar_mp", self.team, self.killstreak_id );
	level notify ( "uav_update" );
}

removeActiveCounterUAV()
{
	if ( level.teamBased )
	{
		if ( self.owner.spawntime < self.birthtime )
		{
			self.owner.activeCounterUAVs--;
			assert( self.owner.activeCounterUAVs >= 0 );
			if ( self.owner.activeCounterUAVs < 0 ) 
				self.owner.activeCounterUAVs = 0;
		}

		level.activeCounterUAVs[self.team]--;
		assert( level.activeCounterUAVs[self.team] >= 0 );
		if ( level.activeCounterUAVs[self.team] < 0 ) 
			level.activeCounterUAVs[self.team] = 0;
	}
	else if ( isDefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		
		level.activeCounterUAVs[self.owner.entnum]--;
		assert( level.activeCounterUAVs[self.owner.entnum] >= 0 );
		if ( level.activeCounterUAVs[self.owner.entnum] < 0 ) 
			level.activeCounterUAVs[self.owner.entnum] = 0;
	}

	maps\mp\killstreaks\_killstreakrules::killstreakStop( "counteruav_mp", self.team, self.killstreak_id );
	level notify ( "uav_update" );

}

removeActiveSatellite()
{
	if ( level.teamBased )
	{
		if ( self.owner.spawntime < self.birthtime )
		{
			self.owner.activeSatellites--;
			assert( self.owner.activeSatellites >= 0 );
			if ( self.owner.activeSatellites < 0 ) 
				self.owner.activeSatellites = 0;
		}

		level.activeSatellites[self.team]--;
		assert( level.activeSatellites[self.team] >= 0 );
		if ( level.activeSatellites[self.team] < 0 ) 
			level.activeSatellites[self.team] = 0;
	}
	else if ( isDefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		level.activeSatellites[self.owner.entnum]--;
		assert( level.activeSatellites[self.owner.entnum] >= 0 );
		if ( level.activeSatellites[self.owner.entnum] < 0 ) 
			level.activeSatellites[self.owner.entnum] = 0;
	}
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "radardirection_mp", self.team, self.killstreak_id );
	level notify ( "uav_update" );
}


playSpyplaneFX()
{
	wait( 0.1 );
	PlayFXOnTag( level.fx_spyplane_burner, self, "tag_origin" );
}

playSpyplaneAfterburnerFX()
{
	wait( 0.1 );
	PlayFXOnTag( level.fx_spyplane_afterburner, self, "tag_origin" );
}

playCounterSpyplaneFX()
{
	wait( 0.1 );
	PlayFXOnTag( level.fx_cuav_burner, self, "tag_origin" );	
}

playCounterSpyplaneAfterburnerFX()
{
	wait( 0.1 );
	PlayFXOnTag( level.fx_cuav_afterburner, self, "tag_origin" );	
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
	
	if ( isCounter )
	{
		plane setModel( level.counterUAVModel );
		plane.targetname = "counteruav";
	}
	else
	{
		plane setModel( level.spyplanemodel );
		plane.targetname = "uav";
	}
	plane SetTeam( owner.team );
	plane SetOwner( owner );
	Target_Set( plane );

	plane.owner = owner;
	plane.team = owner.team;
	
	plane thread updateVisibility( );
	plane thread maps\mp\_heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing" );
	
	level.plane[self.team] = plane;
	plane.health_low = level.u2_maxhealth*0.5;		// when damage taken is above this value, spyplane catchs on fire
	plane.maxhealth = level.u2_maxhealth;
	plane.health = 99999;
	plane.rocketDamageOneShot = level.u2_maxhealth + 1;			// Make it so the heatseeker blows it up in one hit
	plane.rocketDamageTwoShot = (level.u2_maxhealth / 2) + 1;	// Make it so the heatseeker blows it up in two hit
	plane SetDrawInfrared( true );
	
	zOffset = randomIntRange( 4000, 5000 );

	angle = randomInt( 360 );
	
	if ( isCounter )
	{
		radiusOffset = randomInt( 1000 ) + 3000;		
	}
	else
	{
		radiusOffset = randomInt( 1000 ) + 4000;
	}

	xOffset = cos( angle ) * radiusOffset;
	yOffset = sin( angle ) * radiusOffset;

	angleVector = vectorNormalize( (xOffset,yOffset,zOffset) );
	angleVector = ( angleVector * randomIntRange( 4000, 5000 ) );

	if ( isCounter )
	{
		plane linkTo( UAVRig, "tag_origin", angleVector, (0,angle + attach_angle,-10) );
	}
	else
	{
		plane linkTo( UAVRig, "tag_origin", angleVector, (0,angle + attach_angle,0) );
	}
	
	return plane;
}

updateVisibility()
{
	self endon ( "death" );
	
	for ( ;; )
	{
		if( level.teambased )
		{
			self SetVisibleToAllExceptTeam( self.team );
		}
		else
		{
			self SetVisibleToAll();
			self SetInvisibleToPlayer( self.owner );
		}

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

// accumulate damage and react
plane_damage_monitor( isSpyPlane )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "delete" );
	
	self SetCanDamage( true );
	
	self.damageTaken = 0;
	
	for( ;; )
	{
		// this damage is done to self.health which isnt used to determine the helicopter's health, damageTaken is.
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon );		

//		iprintlnBold("damageDone");
		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;
		
		friendlyfire = maps\mp\gametypes\_weaponobjects::friendlyFireCheck( self.owner, attacker );
		// skip damage if friendlyfire is disabled
		if( !friendlyfire )
			continue;			
			
		if(	isDefined( self.owner ) && attacker == self.owner )
			continue;
		
		isValidAttacker = true;
		if( level.teambased )
			isValidAttacker = (isdefined( attacker.team ) && attacker.team != self.team);

		if ( !isValidAttacker )
			continue;

		if( maps\mp\gametypes\_globallogic_player::doDamageFeedback( weapon, attacker ) )
			attacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( type );
		
		self.attacker = attacker;
		
		//attacker thread maps\mp\_properks::shotAirplane( self.owner, weapon, type );
		
		//////////////////////////////////////////////
		// when missile to take down recon is made
		// edit here
		//////////////////////////////////////////////
		//if ( type == "MOD_XXXX" 

		switch( type )
		{
		case "MOD_RIFLE_BULLET":
		case "MOD_PISTOL_BULLET":
			{
				if ( attacker HasPerk( "specialty_armorpiercing" ) )
				{
					self.damageTaken += int( damage * level.cac_armorpiercing_data );
				}
				else
				{
					self.damageTaken += damage;
				}
			}
			break;

		case "MOD_PROJECTILE":
			// 1 shot kill
			self.damageTaken += self.rocketDamageOneShot;
			break;

		default:
			self.damageTaken += damage;
			break;
		}

		// add the damage back onto the health so the health never drops too low, we handle the death with max_health
		self.health += damage;
		
		if( self.damageTaken > self.maxhealth )
		{
			killstreakReference = "radar_mp";
			if( !isSpyPlane )
				killstreakReference = "counteruav_mp";
			
			attacker notify( "destroyed_spyplane" );
				
			// do give stats to killstreak weapons
			// we need the kill stat so that we know how many kills the weapon has gotten (even on spy planes and counter spy planes) for challenges
			// we need the destroyed stat for the same reason as the kill stat and these have different challenges associated
			//attacker maps\mp\_properks::destroyedKillstreak();

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
			attacker AddWeaponStat( killstreakReference, "destroyed", 1 );
			


			if ( isSpyPlane )
			{
				level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_DESTROYED_UAV", attacker ); 
				thread maps\mp\_scoreevents::processScoreEvent( "destroyed_uav", attacker, self.owner, weapon );
				spyplane_death();
			}
			else 
			{
				level thread maps\mp\_popups::DisplayTeamMessageToAll( &"KILLSTREAK_DESTROYED_COUNTERUAV", attacker ); 
				thread maps\mp\_scoreevents::processScoreEvent( "destroyed_counter_uav", attacker, self.owner, weapon );
				counteruavplane_death();
			}
		}
	}
}


plane_health()
{
	self endon( "death" );
	self endon( "crashing" );
	
	self.currentstate = "ok";
	self.laststate = "ok";
	
	while ( self.currentstate != "leaving" )
	{
		if ( self.damageTaken >= self.health_low )
			self.currentstate = "damaged";

		if ( self.currentstate == "damaged" && self.laststate != "damaged" )
		{
			self.laststate = self.currentstate;
			self thread playDamageFX();
		}
			
		// debug =================================
		/#
			debug_print3d_simple( "Health: " + ( self.maxhealth - self.damagetaken ), self, ( 0,0,100 ), 20 );
		#/	
		
		wait 1;
	}
}

playDamageFX()
{
	self endon( "death" );
	self endon( "crashing" );
	
	self.damage_fx = Spawn("script_model", self.origin);
	self.damage_fx SetModel( "tag_origin" );
	self.damage_fx LinkTo( self, "tag_origin" );
	wait (0.1);
	
	while (1)
	{
		playfxontag( level.fx_u2_damage_trail, self.damage_fx, "tag_origin" );
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
	self ClearClientFlag( CLIENT_FLAG_COUNTERUAV );
	self playsound ( "evt_helicopter_midair_exp" );
	self removeActiveCounterUAV();
	Target_Remove( self );
	self thread u2_crash();	
}


spyplane_death()
{
	self playsound ( "evt_helicopter_midair_exp" );
	//Eckert - in progress
	//self.owner playlocalsound ( "dst_disable_spark" );
	if ( !self.leaving )
	{
		self removeActiveUAV();
	}
	Target_Remove( self );
	self thread u2_crash();	
}

counteruavplane_timeout( timeInAir )
{
	self endon ( "death" );
	self endon ( "delete" );
	
	endTime = gettime() + timeInAir * 1000 ;
	
	self.endTime = endTime;

	level waittill_any_timeout( timeInAir, "game_ended" );

	self ClearClientFlag( CLIENT_FLAG_COUNTERUAV );
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
	
	level waittill_any_timeout( timeInAir, "game_ended" );
	
	self removeActiveSatellite();
	self delete();
}

watchForEmp()
{
	self endon ( "death" );
	self endon ( "delete" );
	
	self waittill( "emp_deployed", attacker );

	thread maps\mp\_scoreevents::processScoreEvent( "destroyed_satellite", attacker, self.owner, "emp_mp" );
	
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
	self.leaving = true;
	self removeActiveUAV();	
	wait (level.spyplaneExitTime);	
	Target_Remove( self );
	self delete();
}

completeTimeInAir( duration )
{
	self endon( "spyplaneShouldLeave" );
	level waittill_any_timeout( duration, "game_ended" );
	self notify( "spyplaneShouldLeave" );
}


plane_leave()
{	
	self unlink();
	if ( isDefined(self.isCounter) && self.isCounter )
	{
		self thread playCounterSpyplaneAfterburnerFX();
	}
	else
	{
		self thread playSpyplaneAfterburnerFX();
	}
	self.currentstate = "leaving";
	
	mult = GetDvarIntDefault( "scr_spymult", 20000 );
	
	tries = 10;
	yaw = 0;
	while (tries > 0)
	{
		exitVector = ( anglestoforward( self.angles + (0, yaw, 0)) * 20000 );
		
		if ( isDefined(self.isCounter) && self.isCounter )
		{
			self thread playCounterSpyplaneFX();
			exitVector = exitVector * 1.0;
		}
			
		exitPoint = ( self.origin[0] + exitVector[0], self.origin[1] + exitVector[1], self.origin[2] - 2500);
		exitPoint = self.origin + exitVector;
		
		nfz = crossesNoFlyZone (self.origin, exitPoint);
		if( isDefined(nfz))
		{
			if ( tries % 2 == 1)
			{
				yaw = yaw * -1;
			}
			else
			{
				yaw = yaw + 10;
				yaw = yaw * -1;
			}
			tries--;
		}
		else
		{
			tries = 0;	
		}
	}

	self thread flattenYaw( self.angles[1] + yaw );
	if (self.angles[2] != 0)
	{
		self thread flattenRoll();
	}
	self moveto( exitPoint, level.spyplaneExitTime, 0, 0 );
	self notify ( "leaving");
}

flattenRoll()
{
	self endon( "death" );
	
	while (self.angles[2] < 0)
	{
		self.angles = (self.angles[0], self.angles[1], self.angles[2] + 2.5 );
		wait( 0.05 );
	}
}

flattenYaw( goal )
{
	self endon( "death" );
	
	increment = 3;
	if ( self.angles[1] > goal )
		increment = increment * -1;
	while  (abs( self.angles[1] - goal ) > 3)
	{
		self.angles = (self.angles[0], self.angles[1] + increment, self.angles[2] );
		wait( 0.05 );
	}
}

UAVTracker()
{
	level endon ( "game_ended" );
	
	for ( ;; )
	{
		level waittill ( "uav_update" );
		
		if ( level.teamBased )
		{
			foreach( team in level.teams )
			{
				updateTeamUAVStatus( team );
			}
		}
		else
		{
			updatePlayersUAVStatus();
		}
	}
}


updateTeamUAVStatus( team )
{
	activeUAVs = level.activeUAVs[team];
	activeSatellites = level.activeSatellites[team];
	radarMode = 1;
	
	if ( activeSatellites > 0 ) 
	{
		maps\mp\killstreaks\_radar::setTeamSpyplaneWrapper( team, 0 );
		maps\mp\killstreaks\_radar::setTeamSatelliteWrapper( team, 1 );
		return;
	}
	
	maps\mp\killstreaks\_radar::setTeamSatelliteWrapper( team, 0 );
	
	if ( !activeUAVs )
	{
		maps\mp\killstreaks\_radar::setTeamSpyplaneWrapper( team, 0 );
		return;
	}
	
	if ( activeUAVs > 1 )
		radarMode = 2;

	maps\mp\killstreaks\_radar::setTeamSpyplaneWrapper( team, radarMode );	
}

updatePlayersUAVStatus()
{
	for(i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		assert( isdefined( player.entnum ) );
		if ( !isdefined( player.entnum ) )
			player.entnum = player getEntityNumber();
		activeUAVs = level.activeUAVs[ player.entnum ];
		activeSatellites = level.activeSatellites[ player.entnum ];
		
		if ( activeSatellites > 0 )
		{
			player.hasSatellite = true;
			player.hasSpyplane = 0;
			player setClientUIVisibilityFlag( "radar_client", 1 );
			continue;
		}
		
		player.hasSatellite = false;
		
		if ( ( activeUAVs == 0 ) && !( isDefined( player.pers["hasRadar"] ) && player.pers["hasRadar"] ) )
		{
			player.hasSpyplane = 0;
			player setClientUIVisibilityFlag( "radar_client", 0 );
			continue;
		}
		
		if ( activeUAVs > 1 )
			spyplaneUpdateSpeed = 2;
		else
			spyplaneUpdateSpeed = 1;
						
		player setClientUIVisibilityFlag( "radar_client", 1 );
		player.hasSpyplane = spyplaneUpdateSpeed;
	}
}



