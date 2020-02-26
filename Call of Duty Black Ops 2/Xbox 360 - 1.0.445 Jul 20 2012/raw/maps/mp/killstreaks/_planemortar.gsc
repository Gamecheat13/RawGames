#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_airsupport;

#define PLANE_MORTAR_MODEL "veh_t6_air_fa38_killstreak"
#define PLANE_MORTAR_MODEL_ENEMY "veh_t6_air_fa38_killstreak_alt"
#define PLANE_MORTAR_LOCATION_SELECTOR "map_mortar_selector"
#define PLANE_MORTAR_SELECTION_RADIUS 800
#define PLANE_MORTAR_AIM_ASSIST_RADIUS_SQ 250000
#define PLANE_MORTAR_SELECTION_COUNT 3
#define PLANE_MORTAR_DELAY 1
#define PLANE_WINGMAN_DELAY 0.15
#define PLANE_WINGMAN_OFFSET 500
#define PLANE_MORTAR_FLIGHT_RADIUS 12000
#define PLANE_MORTAR_FLIGHT_SPEED 12000
#define PLANE_MORTAR_FLIGHT_TIME ( PLANE_MORTAR_FLIGHT_RADIUS * 2 / PLANE_MORTAR_FLIGHT_SPEED )

init()
{
	PrecacheModel( PLANE_MORTAR_MODEL );
	PrecacheModel( PLANE_MORTAR_MODEL_ENEMY );
	precacheLocationSelector( PLANE_MORTAR_LOCATION_SELECTOR );
	level.planeMortarExhaustFX = LoadFX( "vehicle/exhaust/fx_exhaust_f35_afterburner" );
	maps\mp\killstreaks\_killstreaks::registerKillstreak( "planemortar_mp", "planemortar_mp", "killstreak_planemortar", "planemortar_used", ::useKillstreakPlaneMortar, true );
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings( "planemortar_mp", &"MP_EARNED_PLANEMORTAR", &"KILLSTREAK_PLANEMORTAR_NOT_AVAILABLE", &"MP_WAR_PLANEMORTAR_INBOUND", &"MP_WAR_PLANEMORTAR_INBOUND_NEAR_YOUR_POSITION" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog( "planemortar_mp", "mpl_killstreak_planemortar", "kls_planemortar_used", "","kls_planemortar_enemy", "", "kls_planemortar_ready");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar( "planemortar_mp", "scr_giveplanemortar" );
}

useKillstreakPlaneMortar( hardpointType )
{	
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		return false;
	}
	
	result = self selectPlaneMortarLocation( hardpointType );
	
	if ( !isDefined( result ) || !result )
	{
		return false;
	}
	
	return true;
}

waittill_confirm_location()
{
	self endon( "emp_jammed" );
	self endon( "emp_grenaded" );

	self waittill( "confirm_location", location );
	
	return location;
}

selectPlaneMortarLocation( hardpointType )
{
	self beginLocationMortarSelection( "map_mortar_selector", PLANE_MORTAR_SELECTION_RADIUS );
	self.selectingLocation = true;

	self thread endSelectionThink();

	locations = [];
	if (!isDefined(self.mortarRadarUsed) || !self.mortarRadarUsed)
	{
		self thread singleRadarSweep();
	}
	
	for ( i = 0 ; i < PLANE_MORTAR_SELECTION_COUNT ; i++ )
	{
		location = self waittill_confirm_location();

		if ( !IsDefined( location ) )
		{
			self.mortarRadarUsed = true;
			self notify("cancel_selection");
			// selection was canceled		
			return false;
		}

		locations[i] = location;
	}

	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false)
	{
		self.mortarRadarUsed = true;
		self notify("cancel_selection");
		return false;
	}

	self.mortarRadarUsed = false;
	
	return self finishHardpointLocationUsage( locations, ::usePlaneMortar );
}

singleRadarSweep()
{
	self endon( "disconnect" );
	self endon("cancel_selection");

	// give a bit for the map to come up
	wait(0.5);
	
	self PlayLocalSound("mpl_killstreak_satellite");
	
	if ( level.teamBased )
	{
		has_satellite = ( level.activeSatellites[ self.team ] > 0 );
	}
	else
	{
		has_satellite = ( level.activeSatellites[ self.entnum ] > 0 );
	}

	if (self.hasSpyplane == 0 && !has_satellite)
	{
		self thread doRadarSweep();
	}
}

doRadarSweep()
{
	self setClientUIVisibilityFlag( "g_compassShowEnemies", 1 );
	
	wait ( 0.2 );		
	
	self setClientUIVisibilityFlag( "g_compassShowEnemies", 0 );
}

usePlaneMortar( positions )
{
	team = self.team;
	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( "planemortar_mp", team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}
	
	self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "planemortar_mp", team, true );
	self thread planeMortar_watchForEndNotify( team, killstreak_id );
	self thread doPlaneMortar( positions, team, killstreak_id );
	
	return true;
}

doPlaneMortar( positions, team, killstreak_id )
{
	self endon( "emp_jammed" );
	self endon( "disconnect" );
	
	yaw = RandomIntRange( 0,360 );
	odd = 0;
	foreach( position in positions )
	{
		maps\mp\gametypes\_spawning::create_artillery_influencers( position, -1 );
		self thread doBombRun( position, yaw, team );

		if (odd == 0)
		{
			yaw = ( yaw + 35 ) % 360;
		}
		else
		{
			yaw = ( yaw + 290 ) % 360;			
		}
		odd = ( odd + 1 ) % 2;
		
		wait PLANE_MORTAR_DELAY;
	}
	
	self notify( "planemortarcomplete" );
}

planeMortar_watchForEndNotify( team, killstreak_id )
{
	self waittill_any( "disconnect", "joined_team", "joined_spectators", "planemortarcomplete" );

	planeMortar_killstreakStop( team, killstreak_id );
}

planeMortar_killstreakStop( team, killstreak_id )
{
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "planemortar_mp", team, killstreak_id );	
}
	

doBombRun( position, yaw, team )
{
	self endon( "emp_jammed" );
	player = self;

	angles = (0,yaw,0);
	direction = AnglesToForward( angles );
	
	height = maps\mp\killstreaks\_airsupport::getMinimumFlyHeight() + 2000;
	position = ( position[0], position[1], height );
	startPoint = position + VectorScale( direction, -1 * PLANE_MORTAR_FLIGHT_RADIUS );
	endPoint = position + VectorScale( direction, PLANE_MORTAR_FLIGHT_RADIUS * 1.5 );
	height = getNoFlyZoneHeightCrossed( startPoint, endPoint, height );
	startPoint = ( startPoint[0], startPoint[1], height );
	position = ( position[0], position[1], height );
	endPoint = ( endPoint[0], endPoint[1], height );
	
	plane = SpawnPlane( self, "script_model", startPoint );
	plane.team = team;
	plane.targetname = "plane_mortar";
	plane.owner = self;
	
	plane endon( "delete" );
	plane endon( "death" );
	
	plane thread planeWatchForEmp( self );
	
	plane.angles = angles;
	plane SetModel( PLANE_MORTAR_MODEL );
	plane SetEnemyModel( PLANE_MORTAR_MODEL_ENEMY );
	plane thread playPlaneFX();
	plane playsound( "mpl_lightning_flyover_boom" );
	plane SetDrawInfrared( true );
	
	plane.killcamEnt = spawn( "script_model", plane.origin+(0,0,700)+VectorScale( direction, -1 * 1100 ) );
	plane.killcamEnt.angles = (25,yaw,0);
	plane.killcamEnt.startTime = gettime();
	plane.killcamEnt LinkTo( plane );
	start = (position[0], position[1], plane.origin[2]);
	impact = BulletTrace( start, start + (0,0,-100000), true, plane);
	plane.killcamEnt thread lookAtExplosion(impact);
	
	plane MoveTo( endpoint, PLANE_MORTAR_FLIGHT_TIME * 5/4, 0, 0 );				
	
	plane.killcamEnt thread followBomb( plane, position, direction, impact, player );
	
	wait ( PLANE_MORTAR_FLIGHT_TIME /2 );
	if ( isdefined ( self  ) ) 
	{
		self thread dropBomb( plane, position );
	}

	wait ( PLANE_MORTAR_FLIGHT_TIME * 3/4 );	
	plane Plane_CleanUpOnDeath();
}

followBomb( plane, position, direction, impact, player )
{
	player endon( "emp_jammed" );
	
	wait ( PLANE_MORTAR_FLIGHT_TIME / 3 );
	plane.killcamEnt Unlink();
	plane.killcamEnt MoveTo( impact["position"] + (0,0,1000) + VectorScale( direction, -1 * 600 ), 1.0, 0, 0.3);
}

lookAtExplosion(impact)
{
	offset = self.origin[2] - 932;  //point being looked at before we unlink
	increment = offset / 20;
	while (isDefined(self))
	{
		self.angles = vectorToAngles((impact["position"] + (0,0,offset - impact["position"][2])) - self.origin);
		offset = max(0, offset - increment );
		wait(0.05);
	}
}

planeWatchForEmp( owner )
{
	self endon( "delete" );
	self endon( "death" );
	
	self waittill( "emp_deployed", attacker );

	thread planeAwardScoreEvent( attacker, self );

	// possibly play destroyed effect
	self Plane_CleanUpOnDeath();
}


planeAwardScoreEvent( attacker, victim )
{
	attacker endon( "disconnect" );
	attacker notify( "planeAwardScoreEvent_singleton" );
	attacker endon( "planeAwardScoreEvent_singleton" );
	waittillframeend;
	
	maps\mp\_scoreevents::processScoreEvent( "destroyed_plane_mortar", attacker, victim, "emp_mp" );
}

Plane_CleanUpOnDeath()
{
	if ( isdefined ( self.killcamEnt ) )
	{
		self.killcamEnt Delete();
		self.killcamEnt = undefined;
	}
	self Delete();
}

playPlaneFX()
{
	self endon( "death" );
	
	wait( 0.1 );
	
	PlayFXOnTag( level.planeMortarExhaustFX, self, "tag_origin" );	
}

dropBomb( plane, bombPosition )
{
	targets = getplayers();
	foreach( target in targets )
	{
		if( plane.owner isenemyplayer(target) && Distance2DSquared( target.origin, bombPosition ) < PLANE_MORTAR_AIM_ASSIST_RADIUS_SQ )
		{
			if( BulletTracePassed( (target.origin[0], target.origin[1], plane.origin[2]), target.origin, false, plane) )
			{
				bombPosition = target.origin;
				break;
			}
		}
	}
	
	bombPosition = (bombPosition[0],bombPosition[1],plane.origin[2]);
	bomb = self LaunchBomb( "planemortar_mp", bombPosition, (0,0,-10000) );
	bomb playsound( "mpl_lightning_bomb_incoming" );
	bomb.killcamEnt = plane.killcamEnt;
}