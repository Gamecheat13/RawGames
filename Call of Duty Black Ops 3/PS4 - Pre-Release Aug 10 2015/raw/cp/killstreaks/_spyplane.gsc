#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_globallogic_player;

#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_airsupport;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_radar;



#precache( "fx", "_t6/vehicle/light/fx_cuav_lights_red" );
#precache( "fx", "_t6/vehicle/light/fx_u2_lights_red" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_u2_spyplane_afterburner" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_u2_spyplane_burner" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_cuav_afterburner" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_cuav_burner" );
#precache( "fx", "_t6/trail/fx_trail_u2_plane_damage_mp" );
#precache( "fx", "_t6/vehicle/vexplosion/fx_vexplode_u2_exp_mp" );

#namespace spyplane;

function init()
{
	level.spyplanemodel = "veh_t6_drone_uav";
	level.counterUAVModel = "veh_t6_drone_cuav";
	
	level.u2_maxhealth = 700;
	
	level.spyplane = [];
	level.spyplaneEntranceTime = 5;
	level.spyplaneExitTime = 10;
	
	level.counteruavWeapon = GetWeapon( "counteruav" );	
	level.counteruavLength = 25.0;

	level.counteruavplaneEntranceTime = 5;
	level.counteruavplaneExitTime = 10;
	
	level.counterUAVLight = "_t6/vehicle/light/fx_cuav_lights_red";
	level.UAVLight = "_t6/vehicle/light/fx_u2_lights_red";
		
	level.fx_spyplane_afterburner = "_t6/vehicle/exhaust/fx_exhaust_u2_spyplane_afterburner";
	level.fx_spyplane_burner = "_t6/vehicle/exhaust/fx_exhaust_u2_spyplane_burner";
	
	level.fx_cuav_afterburner = "_t6/vehicle/exhaust/fx_exhaust_cuav_afterburner";
	level.fx_cuav_burner = "_t6/vehicle/exhaust/fx_exhaust_cuav_burner";
	
	level.satelliteHeight = 10000;
	level.satelliteFlyDistance = 10000;
	
	level.fx_u2_damage_trail = "_t6/trail/fx_trail_u2_plane_damage_mp";
	level.fx_u2_explode = "_t6/vehicle/vexplosion/fx_vexplode_u2_exp_mp";

	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if ( miniMapOrigins.size )
		uavOrigin = math::find_box_center( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
	else
		uavOrigin = (0,0,0);
	
	if( level.script == "mp_hydro" )
		uavOrigin = uavOrigin + ( 0, 1200, 0 );

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
	level.UAVRig thread swayUAVRig();
	
	level.CounterUAVRig = spawn( "script_model", uavOrigin + (0,0,1500) );
	level.CounterUAVRig setModel( "tag_origin" );
	level.CounterUAVRig.angles = (0,115,0);
	level.CounterUAVRig hide();

	level.CounterUAVRig thread rotateUAVRig(false);
	level.CounterUAVRig thread swayUAVRig();
	
	level thread UAVTracker();
	
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &watchFFAAndMultiTeamSpawn );
}

function on_player_connect()
{
	self.entnum = self getEntityNumber();
	level.activeUAVs[ self.entnum ] = 0;
	level.activeCounterUAVs[ self.entnum ] = 0;
	level.activeSatellites[ self.entnum ] = 0;
}

function watchFFAAndMultiTeamSpawn()
{
	self endon( "disconnect" );

	if ( level.teambased == false || level.multiteam == true )
	{	
		level notify( "uav_update" );
	}
}

function rotateUAVRig( clockwise )
{
	level endon("unloaded");
	turn = 360;
	if ( clockwise )
		turn = -360;
	
	while( isDefined(self) )
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

function swayUAVRig()
{
	level endon("unloaded");
	centerOrigin = self.origin;
	
	while( isDefined(self) )
	{
		z = randomIntRange( -200, -100 );
		
		time = randomIntRange( 3, 6 );
		self moveto( centerOrigin + (0,0,z), time, 1, 1 );
		wait ( time );
		
		z = randomIntRange( 100, 200 );
		
		time = randomIntRange( 3, 6 );
		self moveto( centerOrigin + (0,0,z), time, 1, 1 );
		wait ( time );
	}
}

function callcounteruav( type, displayMessage, killstreak_id )
{
	timeInAir = self radar::useRadarItem( type, self.team, displayMessage);
	isCounter = 1;

	// generate the plane for team based and FFA
	counteruavplane = generatePlane( self, timeInAir, isCounter );
	if ( !isdefined( counteruavplane ) )
	{
		return false;
	}
	counteruavplane thread counteruav_watchfor_gamerules_destruction( self );
	counteruavplane clientfield::set( "counteruav", 1 );
	counteruavplane addActiveCounterUAV();	
	self.counterUAVTime = GetTime();
	counteruavplane thread playCounterSpyplaneFX();
	counteruavplane thread counteruavplane_death_waiter();	
	counteruavplane thread counteruavplane_timeout( timeInAir, self );
	counteruavplane thread plane_damage_monitor( false );
	counteruavplane thread plane_health();

	counteruavplane.killstreak_id = killstreak_id;
	counteruavplane.isCounter = true;
	
	counteruavplane PlayLoopSound ("veh_uav_engine_loop", 1);

	return true;
}


function callspyplane( type, displayMessage, killstreak_id )
{
	timeInAir = self radar::useRadarItem( type, self.team, displayMessage);	
 	isCounter = 0;

	spyplane = generatePlane( self, timeInAir, isCounter );
	if ( !isdefined( spyplane ) )
		return false;
	spyplane thread spyplane_watchfor_gamerules_destruction( self );
	spyplane addActiveUAV();
	self.UAVTime = GetTime();
	spyplane.leaving = false;
	spyplane thread playSpyplaneFX();
	spyplane thread spyplane_timeout( timeInAir, self );
	spyplane thread spyplane_death_waiter();	
	spyplane thread plane_damage_monitor( true );
	spyplane thread plane_health();
	
	spyplane.killstreak_id = killstreak_id;
	spyplane.isCounter = false;
		
	spyplane PlayLoopSound ("veh_uav_engine_loop", 1);
	
	return true;
}


function callsatellite( type, displayMessage, killstreak_id )
{
	timeInAir = self radar::useRadarItem( type, self.team, displayMessage);	
	satellite = spawn( "script_model", level.mapcenter + ( ( 0 - level.satelliteFlyDistance ), 0, level.satelliteHeight ) ); 
	satellite setModel( "tag_origin" );
	satellite moveto( level.mapcenter + ( level.satelliteFlyDistance, 0, level.satelliteHeight ), timeInAir );
	satellite.owner = self;
	satellite.team = self.team;
	satellite setTeam(self.team);
	satellite setOwner( self );
	satellite.targetname = "satellite";
	satellite addActiveSatellite();
	self.satelliteTime = GetTime();
	satellite thread satellite_timeout( timeInAir, self );
	satellite thread satellite_watchfor_gamerules_destruction( self );
	//satellite thread watchForEMP();
	satellite.isCounter = false;
	if ( level.teambased ) 
	{
		satellite thread updateVisibility();
	}

	satellite.killstreak_id = killstreak_id;

	return true;
}

function spyplane_watchfor_gamerules_destruction( player )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "delete" );

	player util::waittill_any( "joined_team", "disconnect", "joined_spectators" );

	self spyplane_death();
}

function counteruav_watchfor_gamerules_destruction( player )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "delete" );

	player util::waittill_any( "joined_team", "disconnect", "joined_spectators" );

	hostmigration::waitTillHostMigrationDone();
	
	self counteruavplane_death();
}

function satellite_watchfor_gamerules_destruction( player )
{
	self endon( "death" );
	self endon( "delete" );

	player util::waittill_any( "joined_team", "disconnect", "joined_spectators" );

	hostmigration::waitTillHostMigrationDone();

	self removeActiveSatellite();
	self delete();
}

function addActiveCounterUAV()
{
	if ( level.teamBased )
	{
		self.owner.activeCounterUAVs++;
		level.activeCounterUAVs[self.team]++;	
		foreach( team in level.teams )
		{
			if ( team == self.team )
				continue;
			if ( level.activeSatellites[team] > 0 )
			{
				self.owner challenges::blockedSatellite();
			}
		}
	}
	else 
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		level.activeCounterUAVs[self.owner.entnum]++;

		keys = getarraykeys(level.activeCounterUAVs);
		for ( i = 0; i < keys.size; i++ )
		{
			if ( keys[i] == self.owner.entnum ) 
				continue;

			if ( level.activeCounterUAVs[ keys[i] ] )
			{
				self.owner challenges::blockedSatellite();
				break;
			}
		}

	}

	
	level notify ( "uav_update" );
}

function addActiveUAV()
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

function addActiveSatellite()
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

function removeActiveUAV()
{
	if ( level.teamBased )
	{
		if ( isdefined( self.owner ) && self.owner.spawntime < self.birthtime )
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
	else if ( isdefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		
		level.activeUAVs[self.owner.entnum]--;
		assert( level.activeUAVs[self.owner.entnum] >= 0 );
		if ( level.activeUAVs[self.owner.entnum] < 0 ) 
			level.activeUAVs[self.owner.entnum] = 0;
	}
	
	killstreakrules::killstreakStop( "radar", self.team, self.killstreak_id );
	level notify ( "uav_update" );
}

function removeActiveCounterUAV()
{
	if ( level.teamBased )
	{
		if ( isdefined( self.owner ) && self.owner.spawntime < self.birthtime )
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
	else if ( isdefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		
		level.activeCounterUAVs[self.owner.entnum]--;
		assert( level.activeCounterUAVs[self.owner.entnum] >= 0 );
		if ( level.activeCounterUAVs[self.owner.entnum] < 0 ) 
			level.activeCounterUAVs[self.owner.entnum] = 0;
	}

	killstreakrules::killstreakStop( "counteruav", self.team, self.killstreak_id );
	level notify ( "uav_update" );

}

function removeActiveSatellite()
{
	if ( level.teamBased )
	{
		if ( self.owner.spawntime < self.birthtime && isdefined( self.owner ) )
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
	else if ( isdefined( self.owner ) )
	{
		assert( isdefined( self.owner.entnum ) );
		if ( !isdefined( self.owner.entnum ) )
			self.owner.entnum = self.owner getEntityNumber();
		level.activeSatellites[self.owner.entnum]--;
		assert( level.activeSatellites[self.owner.entnum] >= 0 );
		if ( level.activeSatellites[self.owner.entnum] < 0 ) 
			level.activeSatellites[self.owner.entnum] = 0;
	}
	killstreakrules::killstreakStop( "radardirection", self.team, self.killstreak_id );
	level notify ( "uav_update" );
}


function playSpyplaneFX()
{
	wait( 0.1 );
	PlayFXOnTag( level.fx_spyplane_burner, self, "tag_origin" );
}

function playSpyplaneAfterburnerFX()
{
	self endon( "death" );
	wait( 0.1 );
	PlayFXOnTag( level.fx_spyplane_afterburner, self, "tag_origin" );
}

function playCounterSpyplaneFX()
{
	wait( 0.1 );

	if ( isdefined( self ) )
	{
		PlayFXOnTag( level.fx_cuav_burner, self, "tag_origin" );
	}
}

function playCounterSpyplaneAfterburnerFX()
{
	self endon( "death" );
	wait( 0.1 );
	PlayFXOnTag( level.fx_cuav_afterburner, self, "tag_origin" );	
}
function PlayUavPilotDialog( dialog, owner, delaytime )
{

	if ( isdefined( delaytime ) )
	{
		wait delaytime;
	}
	
	self.pilotVoiceNumber = owner.bcVoiceNumber + 1;
	
	soundAlias = level.teamPrefix[owner.team] + self.pilotVoiceNumber + "_" + dialog;
	
	if ( isdefined( owner.pilotisSpeaking ) )
	{
		if (owner.pilotisSpeaking)
		{
			while (owner.pilotisSpeaking)
			{
				wait (.2);
			}
		}
	}
	if ( isdefined( owner ) )
	{
		owner playLocalSound(soundAlias);
		owner.pilotisSpeaking = true;
		owner thread battlechatter::wait_playback_time( soundAlias ); 
		owner util::waittill_any( soundAlias, "death", "disconnect" );
		owner.pilotisSpeaking = false;
	}
	
	
}
	
function generatePlane( owner, timeInAir, isCounter )
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
	
	//self thread PlayUavPilotDialog( "uav_used", owner, 2 );
	
	Target_Set( plane );

	plane thread play_light_fx( isCounter );
	
	plane.owner = owner;
	plane.team = owner.team;
	
	plane thread updateVisibility( );
	plane thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing" );
	
	level.plane[self.team] = plane;
	plane.health_low = level.u2_maxhealth*0.4;		// when damage taken is above this value, spyplane catchs on fire
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

function play_light_fx( isCounter )
{
	self endon( "death" );
	
	wait ( 0.1 );
	
	if ( isCounter )
	{
		PlayFXOnTag( level.counterUAVLight, self, "tag_origin" );
	}
	else
	{
		PlayFXOnTag( level.UAVLight, self, "tag_origin" );
	}
	
}

function updateVisibility()
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
function debugLine(fromPoint, toPoint, color, durationFrames)
{
	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		{wait(.05);};
	}
}
#/

// accumulate damage and react
function plane_damage_monitor( isSpyPlane )
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
		
		friendlyfire = weaponobjects::friendlyFireCheck( self.owner, attacker );
		// skip damage if friendlyfire is disabled
		if( !friendlyfire )
			continue;			
			
		if(	isdefined( self.owner ) && attacker == self.owner )
			continue;
		
		isValidAttacker = true;
		if( level.teambased )
			isValidAttacker = (isdefined( attacker.team ) && attacker.team != self.team);

		if ( !isValidAttacker )
			continue;

		if( damagefeedback::doDamageFeedback( weapon, attacker ) )
			attacker thread damagefeedback::update( type );
		
		self.attacker = attacker;
		
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
			killstreakReference = "radar";
			if( !isSpyPlane )
				killstreakReference = "counteruav";
			
			attacker notify( "destroyed_spyplane" );
				
			// do give stats to killstreak weapons
			// we need the kill stat so that we know how many kills the weapon has gotten (even on spy planes and counter spy planes) for challenges
			// we need the destroyed stat for the same reason as the kill stat and these have different challenges associated
			//attacker _properks::destroyedKillstreak();

			weaponStatName = "destroyed";
			switch( weapon.name )
			{
			// SAM Turrets keep the kills stat for shooting things down because we used destroyed for when you destroy a SAM Turret
			case "auto_tow":
			case "tow_turret":
			case "tow_turret_drop":
				weaponStatName = "kills";
				break;
			}
			attacker AddWeaponStat( weapon, weaponStatName, 1 );
			level.globalKillstreaksDestroyed++;
			// increment the destroyed stat for this, we aren't using the weaponStatName variable from above because it could be "kills" and we don't want that
			attacker AddWeaponStat( killstreakReference, "destroyed", 1 );
			

			challenges::destroyedAircraft( attacker, weapon );

			if ( isSpyPlane )
			{
				level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_DESTROYED_UAV", attacker ); 

				if ( !isdefined( self.owner ) || self.owner util::IsEnemyPlayer( attacker ) )
				{
					thread scoreevents::processScoreEvent( "destroyed_uav", attacker, self.owner, weapon );
					attacker challenges::addFlySwatterStat( weapon, self );
				}
				else
				{
					//Destroyed Friendly Killstreak 
				}
				spyplane_death();
			}
			else 
			{
				level thread popups::DisplayTeamMessageToAll( &"KILLSTREAK_DESTROYED_COUNTERUAV", attacker ); 				

				if ( !isdefined( self.owner ) || self.owner util::IsEnemyPlayer( attacker ) )
				{
					thread scoreevents::processScoreEvent( "destroyed_counter_uav", attacker, self.owner, weapon );
					attacker challenges::addFlySwatterStat( weapon, self );
				}
				else
				{
					//Destroyed Friendly Killstreak 
				}
				counteruavplane_death();
			}

			return;
		}
	}
}


function plane_health()
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
			airsupport::debug_print3d_simple( "Health: " + ( self.maxhealth - self.damagetaken ), self, ( 0,0,100 ), 20 );
		#/	
		
		wait 1;
	}
}

function playDamageFX()
{
	self endon( "death" );
	self endon( "crashing" );
		
	playfxontag( level.fx_u2_damage_trail, self, "tag_body" );
	
}

function u2_crash()
{
	self notify( "crashing" );
	playfxontag( level.fx_u2_explode, self, "tag_origin" );
	wait (0.1);
	self setModel( "tag_origin" );
	wait(0.2);
	self notify( "delete" );
	self delete();
}

function counteruavplane_death_waiter()
{
	self endon( "delete" );
	self endon ( "leaving");
	
	self waittill( "death" );
	
	counteruavplane_death();
}

function spyplane_death_waiter()
{
	self endon( "delete" );
	self endon ( "leaving");
	
	self waittill( "death" );
	
	spyplane_death();
}

function counteruavplane_death()
{
	self clientfield::set( "counteruav", 0 );
	self playsound ( "evt_helicopter_midair_exp" );
	self removeActiveCounterUAV();
	Target_Remove( self );
	self thread u2_crash();	
}


function spyplane_death()
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

function counteruavplane_timeout( timeInAir, owner )
{
	self endon ( "death" );
	self endon ( "delete" );

	hostmigration::waitTillHostMigrationDone();

	timeRemaining = timeInAir * 1000;

	self waittillTimeOutMigrationAware( timeRemaining, owner );
	
	self clientfield::set( "counteruav", 0 );
	self plane_leave();
	wait (level.counteruavplaneExitTime);
	self removeActiveCounterUAV();
	Target_Remove( self );
	self delete();
}


function satellite_timeout( timeInAir, owner )  
{
	self endon ( "death" );
	self endon ( "delete" );
	
	hostmigration::waitTillHostMigrationDone();

	timeRemaining = timeInAir * 1000;

	self waittillTimeOutMigrationAware( timeRemaining, owner );

	self removeActiveSatellite();
	self delete();
}

function watchForEmp()
{
	self endon ( "death" );
	self endon ( "delete" );
	
	self waittill( "emp_deployed", attacker );

	weapon = GetWeapon( "emp" );

	challenges::destroyedAircraft( attacker, weapon );

	//thread scoreevents::processScoreEvent( "destroyed_satellite", attacker, self.owner, weapon );
	attacker challenges::addFlySwatterStat( weapon, self );
	
	self removeActiveSatellite();
	self delete();
}

function spyplane_timeout( timeInAir, owner )
{
	self endon ( "death" );
	self endon ( "delete" );
	self endon ( "crashing" );
	
	hostmigration::waitTillHostMigrationDone();

	timeRemaining = timeInAir * 1000;

	self waittillTimeOutMigrationAware( timeRemaining, owner );

	self plane_leave();
	self.leaving = true;
	self removeActiveUAV();	
	wait (level.spyplaneExitTime);	
	Target_Remove( self );
	self delete();
}

function waittillTimeOutMigrationAware( timeRemaining, owner )
{
	owner endon( "disconnect" );
	for ( ;; )
	{
		self.endTime = gettime() + timeRemaining;

		event = level util::waittill_any_timeout( timeRemaining / 1000, "game_ended", "host_migration_begin" );
		if ( event != "host_migration_begin" )
		{
			break;
		}

		timeRemaining = self.endTime - gettime();
		if ( timeRemaining <= 0 )
		{
			break;
		}

		hostmigration::waitTillHostMigrationDone();

///#
//		iprintlnbold( "timeRemaining: " + timeRemaining );
//#/
	}
}

function planestoploop(time)
{
	self endon("death");
	wait (time);
	self StopLoopSound();
}

function plane_leave()
{	
	self unlink();
	if ( isdefined(self.isCounter) && self.isCounter )
	{
		self thread playCounterSpyplaneAfterburnerFX();
		self playsound ("veh_kls_uav_afterburner");
		self thread play_light_fx( true );
		self thread planestoploop(1);
	}
	else
	{
		self thread playSpyplaneAfterburnerFX();
		self playsound ("veh_kls_spy_afterburner");		
		self thread play_light_fx( false );
		self thread planestoploop(1);
	}
	self.currentstate = "leaving";
	
	//self thread PlayUavPilotDialog( "uav_leave", self.owner );	
	
	if ( self.laststate == "damaged" )
	{
		playfxontag( level.fx_u2_damage_trail, self, "tag_body" );
	}
	
	mult = GetDvarInt( "scr_spymult", 20000 );
	
	tries = 10;
	yaw = 0;
	while (tries > 0)
	{
		exitVector = ( anglestoforward( self.angles + (0, yaw, 0)) * 20000 );
		
		if ( isdefined(self.isCounter) && self.isCounter )
		{
			self thread playCounterSpyplaneFX();
			exitVector = exitVector * 1.0;
		}
			
		exitPoint = ( self.origin[0] + exitVector[0], self.origin[1] + exitVector[1], self.origin[2] - 2500);
		exitPoint = self.origin + exitVector;
		
		nfz = airsupport::crossesNoFlyZone (self.origin, exitPoint);
		if( isdefined(nfz))
		{
			if ( tries != 1 )
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

function flattenRoll()
{
	self endon( "death" );
	
	while (self.angles[2] < 0)
	{
		self.angles = (self.angles[0], self.angles[1], self.angles[2] + 2.5 );
		{wait(.05);};
	}
}

function flattenYaw( goal )
{
	self endon( "death" );
	
	increment = 3;
	if ( self.angles[1] > goal )
		increment = increment * -1;
	while  (abs( self.angles[1] - goal ) > 3)
	{
		self.angles = (self.angles[0], self.angles[1] + increment, self.angles[2] );
		{wait(.05);};
	}
}

function UAVTracker()
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


function updateTeamUAVStatus( team )
{
	activeUAVs = level.activeUAVs[team];
	activeSatellites = level.activeSatellites[team];
	radarMode = 1;
	
	if ( activeSatellites > 0 ) 
	{
		radar::setTeamSpyplaneWrapper( team, 0 );
		radar::setTeamSatelliteWrapper( team, 1 );
		return;
	}
	
	radar::setTeamSatelliteWrapper( team, 0 );
	
	if ( !activeUAVs )
	{
		radar::setTeamSpyplaneWrapper( team, 0 );
		return;
	}
	
	if ( activeUAVs > 1 )
		radarMode = 2;

	radar::setTeamSpyplaneWrapper( team, radarMode );	
}

function updatePlayersUAVStatus()
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
		
		if ( ( activeUAVs == 0 ) && !( isdefined( player.pers["hasRadar"] ) && player.pers["hasRadar"] ) )
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



