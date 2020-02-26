#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_airsupport;

#define PLANE_MORTAR_MODEL "veh_t6_air_f35"
#define PLANE_MORTAR_LOCATION_SELECTOR "map_mortar_selector"
#define PLANE_MORTAR_SELECTION_RADIUS 800
#define PLANE_MORTAR_SELECTION_COUNT 3
#define PLANE_MORTAR_DELAY 1.5
#define PLANE_MORTAR_FLIGHT_RADIUS 12000
#define PLANE_MORTAR_FLIGHT_SPEED 12000
#define PLANE_MORTAR_FLIGHT_TIME ( PLANE_MORTAR_FLIGHT_RADIUS * 2 / PLANE_MORTAR_FLIGHT_SPEED )

init()
{
	PrecacheModel( PLANE_MORTAR_MODEL );
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
		return false;
	
	result = self selectPlaneMortarLocation( hardpointType );
	
	if ( !isDefined( result ) || !result )
		return false;
	
	return true;
}

selectPlaneMortarLocation( hardpointType )
{
	self beginLocationMortarSelection( "map_mortar_selector", PLANE_MORTAR_SELECTION_RADIUS );
	self.selectingLocation = true;

	self thread endSelectionThink();

	locations = [];
	for ( i = 0 ; i < PLANE_MORTAR_SELECTION_COUNT ; i++ )
	{
		self waittill( "confirm_location", location );

		if ( !IsDefined( location ) )
		{
			// selection was canceled
			return false;
		}

		locations[i] = location;
	}

	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false)
	{
		return false;
	}

	return self finishHardpointLocationUsage( locations, ::usePlaneMortar );
}

usePlaneMortar( positions )
{
	team = self.team;
	if ( !self maps\mp\killstreaks\_killstreakrules::killstreakStart( "planemortar_mp", team, false, true ) )
	{
		return false;
	}
	
	self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "planemortar_mp", team, true );
	self thread doPlaneMortar( positions, team );
	
	return true;
}

doPlaneMortar( positions, team )
{
	yaw = RandomIntRange( 0,360 );
	foreach( position in positions )
	{
		self thread doBombRun( position, yaw );
		yaw = ( yaw + 135 ) % 360;
		wait PLANE_MORTAR_DELAY;
	}
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "planemortar_mp", team );
}

doBombRun( position, yaw )
{
	angles = (0,yaw,0);
	direction = AnglesToForward( angles );
	
	height = maps\mp\killstreaks\_airsupport::getMinimumFlyHeight();
	position = ( position[0], position[1], height );
	startPoint = position + VectorScale( direction, -1 * PLANE_MORTAR_FLIGHT_RADIUS );
	endPoint = position + VectorScale( direction, PLANE_MORTAR_FLIGHT_RADIUS );
//	height = getNoFlyZoneHeightCrossed( startPoint, endPoint, height );
	startPoint = ( startPoint[0], startPoint[1], height );
	position = ( position[0], position[1], height );
	endPoint = ( endPoint[0], endPoint[1], height );
	
	plane = SpawnPlane( self, "script_model", startPoint );
	plane.angles = angles;
	plane SetModel( PLANE_MORTAR_MODEL );
	plane thread playPlaneFX();
	plane playsound( "mpl_lightning_flyover_boom" );
	
	plane.killcamEnt = spawn( "script_model", startPoint+(0,0,1000)+VectorScale( direction, -1 * 1000 ) );
	plane.killcamEnt.angles = (45,yaw,0);
	plane.killcamEnt.startTime = gettime();
	plane.killcamEnt LinkTo( plane );
	
	plane MoveTo( position, PLANE_MORTAR_FLIGHT_TIME / 2, 0, 0 );
	wait PLANE_MORTAR_FLIGHT_TIME / 2;
	
	plane.killcamEnt Unlink();
	plane.killcamEnt.origin = position+(0,0,1000)+VectorScale( direction, -1 * 1500 );
	self dropBomb( plane, position );
	
	plane MoveTo( endPoint, PLANE_MORTAR_FLIGHT_TIME / 2, 0, 0 );
	wait PLANE_MORTAR_FLIGHT_TIME / 2;
	
	plane.killcamEnt Delete();
	plane Delete();
}

playPlaneFX()
{
	self endon( "death" );
	
	wait( 0.1 );
	PlayFXOnTag( level.planeMortarExhaustFX, self, "tag_origin" );	
}

dropBomb( plane, bombPosition )
{
	bombPosition = (bombPosition[0],bombPosition[1],plane.origin[2]);
	bomb = self LaunchBomb( "planemortar_mp", bombPosition, (0,0,-10000) );
	bomb playsound( "mpl_lightning_bomb_incoming" );
	bomb.killcamEnt = plane.killcamEnt;
}