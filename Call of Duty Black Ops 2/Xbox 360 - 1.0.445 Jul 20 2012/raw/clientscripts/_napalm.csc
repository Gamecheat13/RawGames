#include clientscripts\_utility;
#include clientscripts\_utility_code;
#include clientscripts\_vehicle;
#include clientscripts\_airsupport;

startNapalm( localClientNum, pos, yaw, teamfaction, team, owner, exitType )
{
	if ( !isdefined( level.napalmstrikeinited ) || level.napalmstrikeinited != true )
		init_napalmstrike();
	
	players = level.localPlayers;
		
	for ( i=0; i < players.size; i++ )	
		callNapalmStrike( localClientNum, pos, yaw, teamfaction, team, owner, exitType );
}

// Sets up the airstrike variables.
init_napalmstrike()
{
	level.fx_jet_trail = loadfx("trail/fx_geotrail_jet_contrail");
	level.fx_airstrike_afterburner = loadfx("vehicle/exhaust/fx_exhaust_jet_afterburner");
	level.fx_napalm_marker = loadfx ("weapon/napalm/fx_napalm_marker_mp");
	//precacheModel( "t5_veh_jet_mig17" );
	level.napalmstrikeinited = true;
	
	if ( isdefined( level.airsupportHeightScale ) )
	{
		switch( level.airsupportHeightScale )
		{
			case 2:
					level.airsupportbombTimer = 2.45;
					level.airsupportfxTimer = 1.0;
				break;
			case 3:
					level.airsupportbombTimer = 2.2;
					level.airsupportFxTimer = 1.2;
				break;
		}
	}
}

playPlaneFx( localClientNum )
{
	playfxontag( localClientNum, level.fx_airstrike_afterburner, self, "tag_engine" );
	playfxontag( localClientNum, level.fx_jet_trail, self, "tag_right_wingtip" );
	playfxontag( localClientNum, level.fx_jet_trail, self, "tag_left_wingtip" );
}

callNapalmStrike( localClientNum, coord, yaw, teamfaction, team, owner, exitType )
{	
	// Get starting and ending point for the plane
	direction = ( 0, yaw, 0 );
	
	const planeHalfDistance = 24000;
	planeFlyHeight = 850;
	const planeFlySpeed = 7000;

	if ( isdefined( level.airsupportHeightScale ) )
	{
		planeFlyHeight *= level.airsupportHeightScale;
	}
	
	startPoint = coord + VectorScale( anglestoforward( direction ), -1 * planeHalfDistance );
	endPoint = coord + VectorScale( anglestoforward( direction ), planeHalfDistance );
	
	if ( isdefined( level.forceAirsupportMapHeight ) )
	{
		startPoint = ( startPoint[0], startPoint[1], level.forceAirsupportMapHeight );
		endPoint = ( endPoint[0], endPoint[1], level.forceAirsupportMapHeight );
		coord  = ( coord[0], coord[1], level.forceAirsupportMapHeight );
	}	

	startPoint += ( 0, 0, planeFlyHeight );	
	endPoint += ( 0, 0, planeFlyHeight );
	
	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );


	if ( !isDefined( localClientNum ) ) 
		return;
		
	planeModel = "t5_veh_jet_mig17";//getPlaneModel( teamFaction );	

	thread flarePlane( localClientNum, planeModel, team, owner, startPoint, endPoint, flyTime, direction );		
	const timeIncreaseBetweenPlanes = 3;
	wait ( timeIncreaseBetweenPlanes );
	thread napalmPlane( localClientNum, planeModel, team, owner, exitType, startPoint, endPoint, flyTime, direction, yaw );
}

napalmPlane( localClientNum, planeModel, team, owner, exitType, startPoint, endPoint, flyTime, direction, yaw )
{	
	// Spawn the planes
	plane = spawnPlane( localClientNum, startPoint, planeModel, team, owner, "compass_objpoint_napalmstrike" );
	
	plane.angles = direction;

	plane planeSounds( "veh_mig_flyby_2d", "evt_us_napalm_wash", undefined, 2362 ); 
	//println( "Starting plane sounds for napalm drop flyby" );

	plane thread playPlaneFx( localClientNum );
	
	destPoint = ( startPoint[0] / 2 + endPoint[0] / 2, startPoint[1] / 2 + endPoint[1] / 2, startPoint[2] / 2 + endPoint[2] / 2 ); 
	
	plane moveTo( destPoint, flyTime / 2, 0, 0 );

	waitrealtime( flyTime / 2 );
	
	halflife = GetDvarFloatDefault( "scr_napalmhalflife", 6.0 );
	
	switch( exitType )
	{
		case "left":
			thread planeTurnLeft( plane, yaw, halflife );
			waitrealtime( halflife + halflife );
			break;
		case "right":
			thread planeTurnRight( plane, yaw, halflife );
			waitrealtime( halflife + halflife );
			break;
		case "straight":
			thread planeGoStraight( plane, endPoint, flyTime / 2 - 1 );
			waitrealtime( flyTime / 2 - 1 );
			break;
		case "barrelroll":
			thread doABarrelRoll(plane, endPoint, flyTime / 2 - 1);
			waitrealtime( flyTime / 2 - 1 );
			break;
		default:
			/#println( "Warning: incorrect exit type; client napalm" + exitType + "\n" );#/
			break;
	}
	
	// Delete the plane after its flyby
	// adding buffer for sound to play out CDC
	wait ( 3 );
	plane notify( "delete" );
	plane delete();
}

flarePlane( localClientNum, planeModel, team, owner, startPoint, endPoint, flyTime, direction )
{
	// Spawn the planes
	plane = spawnPlane( localClientNum, startPoint, planeModel, team, owner, "compass_objpoint_napalmstrike" );

	plane.angles = direction;

	plane planeSounds( "evt_us_napalm_flare_flyby_2d", "evt_us_napalm_flare_wash", undefined, 2362 ); 
	//println( "Starting plane sounds for flare drop flyby" );
	
	plane thread playPlaneFx( localClientNum );
	
	//thread releaseFlare( localClientNum, owner, plane, startPoint, endPoint, direction );
	
	plane moveTo( endPoint, flyTime, 0, 0 );

	waitrealtime( flyTime + 3); 
	
	// Delete the plane after its flyby
	// adding buffer for sound to play out CDC
	plane notify( "delete" );
	plane delete();
}



releaseFlare( localClientNum, owner, plane, startPoint, endPoint, direction )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512

	if ( !isDefined( owner ) ) 
		return;
	
	//startPathRandomness = 100;
	//endPathRandomness = 150;
	
	pathStart = startPoint;// + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint;//   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	

	forward = anglesToForward( direction );
	
	thread debug_line( pathStart, pathEnd, (1,1,1), 10 );
	
	thread callStrike_flareEffect( localClientNum, plane, pathEnd, owner );
}


callStrike_flareEffect( localClientNum, plane, pathEnd, owner )
{	
	fxTimer = 0.15;
	// Can be defined in the level script 
	if ( isdefined ( level.airsupportFxTimer ) )
		fxTimer = level.airsupportFxTimer;
	fxtimer = GetDvarFloatDefault( "scr_fxTimer", fxTimer );
	
	bombWait = 2.35;
	// Can be defined in the level script 
	if ( isdefined ( level.airsupportbombTimer ) )
		bombWait = level.airsupportbombTimer;
	bombWait = GetDvarFloatDefault( "scr_napalmflareTimer", bombWait );
	
	wait ( bombWait );
	
	planedir = anglesToForward( plane.angles );

	flare = spawnflare( localClientNum, plane.origin, plane.angles );
	flare moveGravity( VectorScale( anglestoforward( plane.angles ), 7000/3 ), fxtimer + 3.95 ); 
	
	flare thread debug_draw_bomb_path();
		 
	wait 1.0;
	
	wait( fxTimer );
			
	flareOrigin = flare.origin;
	flareAngles = flare.angles;

	minAngle = 5;
	maxAngle = 45;
	
	
	if ( isdefined( level.napalmFlameMinAngle ) )
		minAngle = level.napalmFlameMinAngle;
	if ( isdefined( level.napalmFlameMaxAngle ) )
		maxAngle = level.napalmFlameMaxAngle;
	
	maxAngle = GetDvarFloatDefault( "scr_napalm_maxAngles", maxAngle );
	
	hitpos = (0,0,0);
	
	traceDir = anglesToForward( flareAngles + (maxAngle,0,0) );
	traceEnd = flareOrigin + VectorScale( traceDir, 10000 );
	trace = bulletTrace( flareOrigin, traceEnd, false, undefined );
	
	traceHit = trace["position"];
	hitpos += traceHit;
	
	playfx(localClientNum, level.fx_napalm_marker, hitpos );
	
	debug_line( flareOrigin, traceHit, (1,0,0), 20 );
	debug_star(hitpos, (1,0,0), 20 * 1000);
	
	wait (4.0);
	flare delete();

}

spawnFlare( localClientNum, origin, angles )
{
	flare = spawn( localClientNum, origin, "script_origin" );
	flare.angles = angles;
	flare setModel( "projectile_cbu97_clusterbomb" ); 

	return flare;
}


debug_draw_bomb_path( projectile )
{
/#
// 	self endon("death");
// 	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 1 );				// debug mode, draws debugging info on screen
// 	
// 	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
// 	{
// 		prevpos = self.origin;
// 		while(1)
// 		{		
// 			thread debug_line( prevpos, self.origin, (.5,1,0) );
// 			debug_star(self.origin, (1,1,0), 20 * 1000);
// 			prevpos = self.origin;
// 			println( self.origin[0] + " " + self.origin[0] + " " + self.origin[0] + "\n" );
// 			
// 			wait .2;
// 		}
// 	}
#/
}
