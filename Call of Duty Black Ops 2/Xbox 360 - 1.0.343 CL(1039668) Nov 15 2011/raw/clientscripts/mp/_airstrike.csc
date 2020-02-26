#include clientscripts\mp\_utility;
#include clientscripts\mp\_utility_code;
#include clientscripts\mp\_vehicle;
#include clientscripts\mp\_airsupport;
#include clientscripts\mp\_rewindobjects;

init()
{
	level.airstrikeBombCount = 15;
	level.fx_airstrike_afterburner = loadfx("vehicle/exhaust/fx_exhaust_b52_bomber");
	level.fx_airstrike_bomb_run = loadfx("weapon/bombing_run/fx_mp_bombing_run_bomb");
	
	level._client_flag_callbacks["plane"][level.const_flag_bombing] = ::bombdrop;
	level._client_flag_callbacks["plane"][level.const_flag_airstrike] = ::planeAirstrikeSounds;
}

addPlaneEvent( localClientNum, eventType, data, messageGeneratedTime )
{
	planeRewindObject = clientscripts\mp\_rewindobjects::getRewindWatcher( localClientNum, eventType );
	assert( isdefined( planeRewindObject ) );
	planeRewindObject addRewindableEventToWatcher( messageGeneratedTime, data );
}

bombdrop( localClientNum, set )
{
	if ( !set )
	{
		self notify("stop_bombing");
	}
	else
	{
		owner = self GetOwner( localClientNum );
		bomberDropBombs( localClientNum, self, owner, owner.team );
	}
}

planeAirstrikeSounds( localClientNum, set )
{
	if ( !set )
	{
		self SetCompassIcon("");	
		return;
	}

	self SetCompassIcon("compass_objpoint_airstrike");
		
	self thread playPlaneFx(localClientNum);

	self thread clientscripts\mp\_airsupport::planeSounds( localClientNum, "null", "veh_b52_flyby_wash", undefined );
}

bomberDropBombs( localClientNum, plane, owner, team )
{
	plane endon( "entityshutdown" );
	plane endon( "stop_bombing" ); 
	
	showFx = true;
	sonicBoom = false;

	plane notify ( "start_bombing" );

	plane thread playBombFx( localClientNum );
	
	plane thread causeRumble(localClientNum);
	
	for ( ;; )
	{
		plane thread callStrike_bomb( localClientNum, plane.origin, owner, (0,0,0), team, showFx );
		serverwait( localClientNum, 0.05 );
	}
}

causeRumble(localClientNum)
{
	while ( isDefined(self) )
	{
		position = (self.origin[0], self.origin[1], 0);
		PlayRumbleOnPosition( localClientNum, "artillery_rumble", position );
		wait(0.1);
	}
}

playPlaneFx( localClientNum )
{
	level endon( "demo_jump" + localClientNum );
	self endon( "entityshutdown" );
	self waittill_dobj(localClientNum);
	playfxontag( localClientNum, level.fx_airstrike_afterburner, self, "tag_engine1" );
	playfxontag( localClientNum, level.fx_airstrike_afterburner, self, "tag_engine2" );
	playfxontag( localClientNum, level.fx_airstrike_afterburner, self, "tag_engine3" );
	playfxontag( localClientNum, level.fx_airstrike_afterburner, self, "tag_engine4" );
}

planeExit( localClientNum, plane, yaw, flytime, startPoint, endPoint, destratio, exitType, isFirstPlane, exitStartTime )
{
	level endon( "demo_jump" + localClientNum );
	halflife = GetDvarFloatDefault( "scr_napalmhalflife", 4.0 );

	exitType = int ( exitType );
	if ( exitType != -1 )
	{	
		if ( isFirstPlane )
			exitType = exitType % 4;
		else
			exitType = int( exitType / 2 );
	}
	switch( exitType )
	{
		case 0:
			planeGoStraight( localClientNum, plane, startPoint, endPoint, flyTime + ( 1 - destRatio ), exitStartTime );
			break;
		case 1:
			planeTurnLeft( localClientNum, plane, yaw,  halflife * 2 * ( 1 - destRatio ), exitStartTime );
			break;
		case 2:
			planeTurnRight( localClientNum, plane, yaw,  halflife * 2 * ( 1 - destRatio ), exitStartTime );
			break;
		case 3:
			doABarrelRoll( localClientNum, plane, endPoint, flyTime + 4, exitStartTime );
			break;
		default:
			planeGoStraight( localClientNum, plane, startPoint, endPoint, flyTime + ( 1 - destRatio ), exitStartTime );
			break;	
	}
}



flyAirstrikePlane( localClientNum, planeStartTime, timeOffset, data )
{
	level endon( "demo_jump" + localClientNum );
	
	planeModel 		= data.planeModel;
	team 			= data.team;
	exitType 		= data.exitType;	
	owner 			= data.owner;
	startPoint 		= data.startPoint;
	endPoint 		= data.endPoint;
	flyTime 		= data.flyTime;
	direction 		= data.direction;
	yaw 			= data.yaw;
	flyBySound	 	= data.flyBySound;
	washSound 		= data.washSound;
	apexTime		= data.apexTime;
	bombsite		= data.bombsite;
	planeFlySpeed	= data.flySpeed;
	planeFlyHeight	= data.flyHeight;
	
	if ( timeOffset > 0 )
		isFirstPlane	= true;
	else
		isFirstPlane	= false;

	if ( level.serverTime > planeStartTime + ( flyTime * 1000 ) )
	{
		return;
	}
		
	// Spawn the planes
	plane = spawnPlane( localClientNum, startPoint, planeModel, team, owner, "compass_objpoint_airstrike" );
	level thread removeClientEntOnJump( plane, localClientNum );
	plane.angles = direction;

	plane planeSounds( flyBySound, washSound, undefined, apexTime ); 

	thread callStrike_bombEffect( localClientNum, plane, bombsite, endPoint, flyTime, owner, team, planeFlySpeed, planeFlyHeight, planeStartTime );

	offset = endPoint - startPoint;
	vanishingPoint = endPoint + offset;
	// the plane does not exist on the server after endPoint
	// vanishing point is twice as far
	// its just so that the plane is out of sight before it gets removed.  
	
	plane thread playPlaneFx( localClientNum );
	if ( plane serverTimedMoveTo( localClientNum, startPoint, vanishingPoint, planeStartTime, flyTime * 2 ) )
		plane waittill( "movedone" );
		
	plane notify( "delete" );
	plane notify( "complete" );
	plane delete();
}

callStrike_bombEffect( localClientNum, plane, bombsite, pathEnd, flyTime, owner, team, planeFlySpeed, planeFlyHeight, planeStartTime )
{
	bombSpeedScale = 1;
	
	bombWait = calculateReleaseTime( flyTime, planeFlyHeight, planeflyspeed, bombSpeedScale );
	bombWait = GetDvarIntDefault( "scr_bombTimer", bombWait );
	bombReleaseWait = GetDvarIntDefault( "scr_bombReleaseWait", 0.2 );

	waitForServerTime( 0, planeStartTime + bombWait - ( level.airstrikeBombCount/2 * bombReleaseWait ) );
	
	planedir = anglesToForward( plane.angles );
	scaledBy = GetDvarIntDefault( "scr_airstrikeSpeedScale", planeFlySpeed*bombSpeedScale );
	velocity = VectorScale( anglestoforward( plane.angles ), scaledBy );
		
//	thread bomberDropBombs( localClientNum, plane, bombsite, owner, team );
}

calculateReleaseTime( flyTime, flyHeight, flySpeed, bombSpeedScale )
{
	falltime = calculateFallTime( flyHeight );

	// bomb horizontal velocity is not the same as the plane speed so we need to take this
	// into account when calculating the bomb time
	bomb_x = (flySpeed * bombSpeedScale) * falltime;
	release_time = bomb_x / flySpeed;
	
	return ( (flyTime * 0.5) - release_time);
}

callStrike_bomb( localClientNum, coord, owner, offset, team, showFx )
{
	self endon ( "entityshutdown" );

	if ( !isDefined( owner ) )
	{
		self notify( "stop_bombing" );
		return;
	}
	
	accuracyRadius = 512;
	
	randVec = ( 0, randomint( 360 ), 0 );
	bombPoint = coord + ( anglestoforward( randVec ) * randomFloat( accuracyRadius ) );
	trace = bulletTrace( bombPoint, bombPoint + (0,0,-10000), false, undefined );
	
	bombPoint = trace["position"];
	
	if ( !isdefined( bombPoint ) )
		return;

	bombHeight = distance( coord, bombPoint );

	if ( bombHeight > 5000 )
		return;

	waitrealtime ( 0.85 * (bombHeight / 2000) );

	if ( !isDefined( owner ) )
	{
		self notify( "stop_bombing" );
		return;
	}
	
	if ( showFx )
	{
		PlayRumbleOnPosition( localClientNum, "grenade_rumble", bombPoint );
		localPlayer = GetLocalPlayer( localClientNum );
		localPlayer earthquake( 0.4, 0.6, bombPoint, 2000 );
	}

	playsound( localClientNum, "mpl_kls_bomb_impact", bombPoint );
	radiusArtilleryShellshock( localClientNum, bombPoint, 512, 8, 4, team );
}

playBombFx( localClientNum )
{
	self endon ( "stop_bombing" );
	self endon ( "entityshutdown" );
	self waittill_dobj(localClientNum);

	for ( ;; )
	{
		playFxOnTag( localClientNum, level.fx_airstrike_bomb_run, self, "tag_bomb1" );
		serverwait( localClientNum, RandomFloatRange(0.05,0.15) ); 	
		playFxOnTag( localClientNum, level.fx_airstrike_bomb_run, self, "tag_bomb2" );
		serverwait( localClientNum, RandomFloatRange(0.15,0.25) ); 	
	}
}

radiusArtilleryShellshock( localClientNum, pos, radius, maxduration, minduration, team )
{
	localPlayer = GetLocalPlayer( localClientNum );

	if ( localPlayer.team == team || localPlayer.team == "spectator" )
		return;
		
	if ( localPlayer IsPlayer() == false )
		return;

	if ( !isAlive( localPlayer ) )
		return;
		
	playerPos = localPlayer.origin + (0,0,32);
	dist = distance( pos, playerPos );
	
	if ( dist > radius )
		return;
	
	duration = int(maxduration + (minduration-maxduration)*dist/radius);		
	localPlayer thread artilleryShellshock( localClientNum, "default", duration );
}


artilleryShellshock( localClientNum, type, duration )
{
	self endon ( "entityshutdown" );
	if ( isdefined( self.beingArtilleryShellshocked ) && self.beingArtilleryShellshocked )
		return;
	self.beingArtilleryShellshocked = true;
	
	self shellshock( localClientNum, type, duration );
	wait( duration + 1 );
	
	if ( !isdefined ( self ) )
		return;
		
	self.beingArtilleryShellshocked = false;
}


targetisclose(other, target, closeDist)
{
	if ( !isDefined( closeDist ) )
		closeDist = 3000;
		
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+(anglestoforward(flat_angle(other.angles)) * (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < closeDist)
		return true;
	else
		return false;
}


flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}

flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;

}


targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}

targetGetDist( other, target )
{
	infront = targetisinfront( other, target );
	if( infront )
		dir = 1;
	else
		dir = -1;
	a = flat_origin( other.origin );
	b = a+( anglestoforward(flat_angle(other.angles)) * (dir*100000) );
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);

	return dist;
}



calculateFallTime( flyHeight )
{
	gravity = GetDvarfloat("bg_gravity");

	time = sqrt( (2 * flyHeight) / gravity );
	
	return time;
}

