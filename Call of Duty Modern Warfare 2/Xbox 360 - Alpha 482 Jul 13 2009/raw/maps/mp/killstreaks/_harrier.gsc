#include maps\mp\_utility;
#include common_scripts\utility;

/******************************************************************* 
//						_harrier.gsc  
//	
//	Holds all the harrier specific functions
//	
//	Jordan Hirsh	Dec. 18th 	2008
********************************************************************/

getBestLaunchPoint( startPoint, bombSite )
{
	scaler = .95;
	zAdjust = 6000;
	
	pathStart = startPoint * scaler + ( 0, 0, zAdjust );
	//self thread drawLine( pathStart, bombSite, 25, (1,0,0) );
	
	while( 1 ) 
  {	
  	planeTrace = bulletTrace( bombSite, pathStart, false, undefined ); 
	
		println(planeTrace["fraction"]);
	
		if ( planeTrace["fraction"] > .96 )
		{
			break;
		}
	
		if ( scaler < .35)
		{
			break;
		}
		
		scaler -= .05;
		zAdjust += 500;
		pathStart *= scaler;
		pathStart = pathStart + ( 0,0, zAdjust);
		
		wait( .05 );
	}
	
	return pathStart;
}

launchMissiles( plane, launchTime, owner, bombsite )
{
	los = false;
	dist = 9999;
	
	missilePosition1 = ( bombsite[0] + randomIntRange( -256, 256 ) , bombsite[1] + randomIntRange( -256, 256 ), bombsite[2] );
	missilePosition2 = ( bombsite[0] + randomIntRange( -256, 256 ) , bombsite[1] + randomIntRange( -256, 256 ), bombsite[2] );
	wait ( launchTime );
	
	//plane playSound( "veh_mig29_sonic_boom" );
	missile1 = MagicBullet( "harrier_missile_mp", plane.origin, missilePosition1, owner );
	
	wait( 0.15);
	
	//plane playSound( "veh_mig29_sonic_boom" );
	missile2 = MagicBullet( "harrier_missile_mp", plane.origin, missilePosition2, owner );
	
	//make planes fly all cool etc...
	self notify( "missilesAway" );

}

harrierMissileStrike( lifeId, startPoint, pos )
{
	
	harrier = beginHarrier( lifeId, startPoint, pos );
	harrier SetMaxPitchRoll( 90, 180 );
	
	divePoint = harrier getBestLaunchPoint(startPoint, pos);
	
	harrier setVehGoalPos( divePoint, 0 );
	harrier waittill( "goal");
	harrier thread launchMissiles( harrier, 0.1, self, pos );
	
	pathGoal = harrier.origin + ( vector_multiply( anglestoforward( (0,90,0) ), 14500 ) );
	pathGoal -= ( 0,0,3000);
	harrier setVehGoalPos( pathGoal, 0 );
	harrier thread launchMissiles( harrier, 0.15, self, pos );
	harrier waittill ( "goal" );
	
	pathGoal = harrier.origin + ( vector_multiply( anglestoforward( (0,90,0) ), -7250 ) );
	pathGoal -= ( 0,0,3000);
	harrier setVehGoalPos( pathGoal, 0 );
	harrier thread launchMissiles( harrier, 0.15, self, pos );
	harrier waittill ( "goal" );
	
	harrier setVehGoalPos( pos, 0 );
	
	harrier SetMaxPitchRoll( 35, 60 );
	self defendLocation( harrier );
}

beginHarrier( lifeId, startPoint, pos )
{

	planeFlyHeight = 850;
	if ( isdefined( level.airstrikeHeightScale ) )
	{
		planeFlyHeight *= level.airstrikeHeightScale;
	}
	
	pathGoal = pos + (0,0,planeFlyHeight);	

	harrier = spawnDefensiveHarrier( lifeId, self, startPoint, pathGoal );
	harrier.pathGoal = pathGoal;

	return harrier;
}

defendLocation( harrier )
{
	assert ( isDefined( harrier ) );
	
	harrier thread harrierTimer();
	
	if ( isDefined( level.chopper ) && level.chopper.team != self.team )
	{
		harrier setVehGoalPos( harrier.pathGoal, 1 );
		harrier thread engageVehicle( level.chopper );
	}
	else
	{ 
		harrier setVehGoalPos( harrier.pathGoal, 1 );
		// check to ensure position isnt already occupied.
		harrier thread closeToGoalCheck( harrier.pathGoal );
		
		harrier waittill ( "goal" );
		harrier stopHarrierWingFx();
		harrier engageGround();
	}
}

closeToGoalCheck( pathGoal )
{
	self endon( "goal" );
	self endon( "death" );
	
	for( ;; )
	{
		if ( distance2d( self.origin, pathGoal  ) < 768 )
		{
			self SetMaxPitchRoll( 45, 90 );	
			break;
		}
		
		wait .05;
	}
}

engageGround()
{ 
	self notify( "engageGround" ); 
	self endon("engageGround");

	self thread harrierGetTargets();

	pathGoal = self.defendLoc;

	self Vehicle_SetSpeed( 15, 5 );
	self setVehGoalPos( pathGoal, 1 );
	self waittill ( "goal" );
}

harrierLeave()
{
	
	self SetMaxPitchRoll( 0, 0 );
	self notify( "leaving" );
	self breakTarget( true );
	self notify("stopRand");
	
	self Vehicle_SetSpeed( 35, 25 );
	pathGoal = self.origin + ( vector_multiply( anglestoforward( (0,self.angles[1],0) ), 500 ) );
	pathGoal += ( 0,0,900);
	self setVehGoalPos( pathGoal, 1 );
	self thread startHarrierWingFx();

	self playSound( "harrier_fly_away" );

	self waittill ( "goal" );
	
	pathEnd = self getPathEnd(); 
	self Vehicle_SetSpeed( 250, 75 );
	self setVehGoalPos( pathEnd, 1 );
	self waittill ( "goal" );
	
	level.airPlane[level.airPlane.size - 1] = undefined; 
	level.planes--;

	self notify ( "harrier_gone" );
	self thread harrierDelete();
}


harrierDelete()
{
	//self.mgTurret delete();
	self delete();
}

harrierTimer()
{
	self endon( "death" );
	
	wait( 45 );
	self harrierLeave();
}

randomHarrierMovement()
{
	self notify( "randomHarrierMovement" ); 
	self endon("randomHarrierMovement");
	
	self endon("stopRand");
	self endon("death");
	self endon( "acquiringTarget" );
	self endon( "leaving" );
	
	pos = self.defendloc;
	
	for ( ;; )
	{
		pointX = RandomFloatRange( pos[0]-600, pos[0]+600 );
		pointY = RandomFloatRange( pos[1]-600, pos[1]+600 );
		pointZ = RandomFloatRange( pos[2]-15, pos[2]+25 );
		println("moved random");
		
		pathGoal = ( pointX, pointY, pointZ);
		
		trc = BulletTrace( self.origin, pathGoal, false, self );
		
		if ( trc["surfacetype"] != "none" )
		{
			wait( 0.05 );
			continue;
		}
		
		self setVehGoalPos( pathGoal, 1 );
		self waittill ("goal");
		wait( randomInt(3) );
	}
}

spawnDefensiveHarrier( lifeId, owner, pathStart, pathGoal )
{
	
	forward = vectorToAngles( pathGoal - pathStart );
	harrier = spawnHelicopter( owner, pathStart, forward, "harrier_mp" , "vehicle_av8b_harrier_jet_mp" );

	if ( !isDefined( harrier ) )
		return;

	harrier addToHeliList();
	harrier thread removeFromHeliListOnDeath();
	//harrier playLoopSound( "harrier_hover" );

	harrier.speed = 250;
	harrier.accel = 175;
	harrier.health = 3000; 
	harrier.maxhealth = harrier.health;
	harrier.team = owner.team;
	harrier.owner = owner;
	harrier setCanDamage( true );
	harrier.owner = owner;
	harrier thread harrierDestroyed();
	harrier thread harrierHealthWatcher();
	harrier SetMaxPitchRoll( 0, 90 );		
	harrier Vehicle_SetSpeed( harrier.speed, harrier.accel );
	//harrier thread maps\mp\killstreaks\_airstrike::playPlaneFx();
	harrier thread playHarrierFx();
	harrier setdamagestage( 3 );
	harrier.missiles = 6;
	harrier.pers["team"] = harrier.team;
	harrier SetHoverParams( 50, 100, 50 );
	harrier setTurningAbility( 0.05 );
	harrier setYawSpeed(45,25,25,.5);
	harrier.defendLoc = pathGoal;
	
	harrier.damageCallback = ::Callback_VehicleDamage;

	level.harrier = harrier;
	/*
	mgTurret = spawnTurret( "misc_turret", harrier.origin, "harrier_minigun_mp" ); //harrier_turret_mp
	mgTurret.lifeId = lifeId;
	mgTurret linkTo( harrier, "tag_origin", ( 0,0,-25 ), ( 0,0,0) );
	mgTurret setModel( "weapon_minigun" );
	mgTurret.angles = harrier.angles; 
	mgTurret.owner = harrier.owner;
 	mgTurret.team = owner.team;
 	mgTurret makeTurretInoperable();
 	mgTurret.pers["team"] = harrier.team;
 	harrier.mgTurret = mgTurret; 
 	harrier.mgTurret SetDefaultDropPitch( 0 );
 	harrier.mgTurret.parent = "harrier";
	*/

	//if ( RandomInt( 4 ) < 2 )
	//harrier setupTargetWindows();
	
	return harrier;
}

playHarrierFx()
{
	self endon ( "death" );

	wait( 0.2 );
	playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );	
	playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
	wait( 0.2 );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_right" );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_left" );
	wait( 0.2 );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_right2" );
	playfxontag( level.harrier_afterburnerfx, self, "tag_engine_left2" );
	wait( 0.2 );
	playFXOnTag( level.chopper_fx["light"]["left"], self, "tag_light_L_wing" );
	wait ( 0.2 );
	playFXOnTag( level.chopper_fx["light"]["right"], self, "tag_light_R_wing" );
	wait ( 0.2 );
	playFXOnTag( level.chopper_fx["light"]["belly"], self, "tag_light_belly" );
	wait ( 0.2 );
	playFXOnTag( level.chopper_fx["light"]["tail"], self, "tag_light_tail" );
	
}

stopHarrierWingFx()
{
	stopfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
	stopfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
}

startHarrierWingFx()
{
	wait ( 3.0);
	playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
	playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
}


setupTargetWindows( harrier )
{
	windowTargets = [];
	allowedTargets = [];
	
	windowTargets = getEntArray( "windowtarget" , "targetname" );
	
	if( !isDefined( windowTargets ) )
	{
		return;
	}
	
	foreach ( targ in windowTargets )
	{
		if ( distance2D( targ.origin, self.defendLoc ) < 2048 )
		{
			allowedTargets[ allowedTargets.size ] = targ;				
		}
	}
	
	if ( allowedTargets.size > 0 )
	{
		self thread watchForWindowTarget( windowTargets );	
	}	
}

watchForWindowTarget( windowTargets )
{
	self endon( "death" );
	
	enemyTargets = getWindowTargets( self );
	
	for( ;; )
	{
		bestDistFromSensor = 9999;
		bestTarget = undefined;
		bestWindowTarg = undefined;
		
		foreach ( windowTarg in windowTargets )
		{
			foreach (enemyTarg in enemyTargets)
			{
				if ( windowTarg.origin[2] > enemyTarg.origin[2] + 128 )
					continue;
				
				if ( windowTarg.origin[2] < enemyTarg.origin[2] - 128 )
					continue;
				
				distFromSensor = distance2D( enemyTarg.origin, windowTarg.origin );
				
				if ( distFromSensor < 512 )
				{
					if ( distFromSensor < bestDistFromSensor )
					{	
						//self thread drawLine( enemyTarg.origin, windowTarg.origin, 10, (1,0,0) );
						
						bestTarget = enemyTarg;
						bestDistFromSensor = distFromSensor;
						bestWindowTarg = windowTarg;
					}
				}
			}	
			
			wait( 0.10 );	
		}
		
		if ( isDefined( bestTarget ) )
		{
			//self thread drawLine( bestTarget.origin, bestWindowTarg.origin, 10, (0,1,0) );
			
			self attackWindowTarget( bestTarget, bestWindowTarg );	
		}
			
		wait( 0.25 );	
	}
}

getWindowTargets( harrier )
{
	self endon( "death" );
	self endon( "leaving" );
	
	targets = [];
	players = level.players;
	
	foreach ( player in players )
	{
		if ( !isalive( player ) || player.sessionstate != "playing" )
			continue;
			
		if ( isDefined( harrier.owner ) && player == harrier.owner )
			continue;
		
		if ( !isdefined( player.pers["team"] ) )
			continue;
		
		if ( level.teamBased && player.pers["team"] == self.team )
			continue;
		
		if ( player.pers["team"] == "spectator" )
			continue;
		
		targets[ targets.size ] = player;
	}
	
	return targets;
}

keepWindowLOS( sO )
{
	self endon( "death" );
	self endon( "leaving" );
	self endon( "stopfiring" );
	
	dist = ( distance2d( self.windowNode, sO.origin ) );
	windowNodeForwardVec = vectorNormalize( anglesToForward( sO.angles ) );

	for( ;; )
	{
		
		prof_begin( "harrier_profile" );

		enemDist = distance2D( self.bestTarget.origin, sO.origin );
	
		if ( enemDist > 64 && enemDist < 150)
		{
			vec = vectorNormalize( sO.origin - self.bestTarget.origin ) * dist + sO.origin;
			vec *= ( 1,1,0 );
			vec += ( 0, 0, sO.origin[2]);
			
			aDot = vectorDot( vectorNormalize( vec ), windowNodeForwardVec );
			
			//ugly hardcoded values to keep the plane in LOS
			if ( aDot < -.87 && aDot > -.953 )
			{
				//self thread drawLine ( self.origin, vec, 1, (1,0,1) );
				self setVehGoalPos( vec, 1 );
			} 
			else
			{
				self setVehGoalPos( self.windowNode, 1 );
			}
		}
		else if ( enemDist >= 150 || abs( self.bestTarget.origin[2] - sO.origin[2] ) > 128) 
		{
			self breakTarget();
			return;
		}
		else
		{
			self setVehGoalPos( self.windowNode, 1 );
		}
		
		prof_end( "harrier_profile" );
		
		wait( 1 );
	}
		
}

attackWindowTarget( bestTarget, windowSO )
{
	self endon( "death" );
	self endon( "leaving" );
	
	vehNodes = getVehicleNodeArray( "windowNode", "targetname" );
	
	vehNodes = ( sortByDistance( vehNodes, windowSO.origin  ) );
	
	
	//self thread drawLine ( vehNodes[0].origin, vehNodes[1].origin, 10, (1,0,1) );
	//self thread drawLine( vehNodes[0].origin, windowSO.origin, 10, (0,0,1) );
	
	finalPathGoal = vehNodes[0].origin;
	
	tempPathGoalX = finalPathGoal[0];
	tempPathGoalY = finalPathGoal[1];
	tempPathGoalZ = self.origin[2];
	
	tempPathGoal = ( tempPathGoalX, tempPathGoalY, tempPathGoalZ );
	
	/#
	if( !BulletTracePassed( self.origin, tempPathGoal, true, self ) )
	{
		drawLine( self.origin, tempPathGoal, 10, (1,0,0) );
		println( "COULD NOT REACH ABOVE TARGET WITHOUT COLLISION" );
		return;
	}
	
	if( !BulletTracePassed( tempPathGoal, finalPathGoal, true, self ) )
	{
		drawLine( tempPathGoal, finalPathGoal, 10, (1,0,0) );
		println( "COULD NOT REACH GOAL WITHOUT VERTICAL COLLISION" );
		return;
	}
	#/
	
	self setVehGoalPos( tempPathGoal, 1 );
	self waittill ( "goal" );
	
	self setVehGoalPos( finalPathGoal, 1 );
	self.windowNode = finalPathGoal;
	self acquireWindowTarget( bestTarget, windowSO );
	
}

getPathStart( coord )
{
	pathRandomness = 100;
	harrierHalfDistance = 15000;
	harrierFlyHeight = 850;

	yaw = randomFloat( 360 );	
	direction = (0,yaw,0);

	startPoint = coord + vector_multiply( anglestoforward( direction ), -1 * harrierHalfDistance );
	startPoint += ( (randomfloat(2) - 1)*pathRandomness, (randomfloat(2) - 1)*pathRandomness, 0 );
	
	return startPoint;
}

getPathEnd()
{
	pathRandomness = 150;
	harrierHalfDistance = 15000;
	harrierFlyHeight = 850;

	yaw = self.angles[1];	
	direction = (0,yaw,0);

	endPoint = self.origin + vector_multiply( anglestoforward( direction ), harrierHalfDistance );
	return endPoint;
}

fireOnTarget( facingTolerance, zOffset )
{
	self endon("leaving");
	self endon("stopfiring");
	self endon("explode");
	self endon("death");
	self.bestTarget endon( "death" );
	
	acquiredTime = getTime();
	missileTime = getTime();
	missileReady = false;
	
	self setVehWeapon( "harrier_20mm_mp" );
	
	if ( !isDefined( zOffset ) )
		zOffset = 50;

	for ( ;; )
	{
		if ( self isReadyToFire( facingTolerance ) )
			break;
		else
			wait ( .25 );
	} 
	self SetTurretTargetEnt( self.bestTarget, ( 0,0,50 ) );
	
	numShots = 25;
	for ( ;; )
	{
	/*	offsetTime = getTime() - acquiredTime;
		
		if (  offsetTime > 2500 && offsetTime < 3500 )
		{
			self SetTurretTargetEnt( self.bestTarget, ( 0,0,RandomIntRange(-64,64) ) );
			println( "stage 2" );
		}
		else if ( offsetTime <= 2500 )
		{
			offsetAmount = -250 + (offsetTime/10);
			self SetTurretTargetEnt( self.bestTarget, (0,0, offsetAmount ) );
			println( "stage 1" );
			println( offsetAmount ); 
		}
		else if (  offsetTime >= 3500 )
		{
			self SetTurretTargetEnt( self.bestTarget, ( 0,0,50 ) );
			println( "stage 3" );
		} */
		numShots--;
		self FireWeapon( "tag_flash", self.bestTarget, (0,0,0), .05 );
		self playSound( "weap_harrier_turret" );
		wait ( .10);
		
		if ( numShots <= 0 )
		{
			wait (1);
			numShots = 25;
		}
	}
}

isReadyToFire( tolerance )
{
	self endon( "death" );
	self endon( "leaving" );
	
	if (! isdefined(tolerance) )
		tolerance = 10;
	
	harrierForwardVector = anglesToForward( self.angles );
	harrierToTarget = self.bestTarget.origin - self.origin;
	harrierForwardVector *= (1,1,0);
	harrierToTarget *= (1,1,0 );
	
	harrierToTarget = VectorNormalize( harrierToTarget );
	harrierForwardVector = VectorNormalize( harrierForwardVector );
	
	targetCosine = VectorDot( harrierToTarget, harrierForwardVector );
	facingCosine = Cos( tolerance );

	if ( targetCosine >= facingCosine )
		return true;
	else
		return false;
}

acquireWindowTarget( targ, sO )
{
	self endon( "death" );
	self endon( "leaving" );
	
	self.bestTarget = targ;
	self notify( "acquiringTarget" );
	
	self SetLookAtEnt( self.bestTarget );
	
	self thread watchTargetDeath();
	
	//self.mgTurret SetTargetEntity( self.bestTarget );	
	
	self waittill( "goal" );
	self thread keepWindowLOS( sO );
	self fireOnTarget( 5, 0 ); 
	
	//go back up... 	
	goalX = self.origin[0];
	goalY = self.origin[1];
	goalZ = self.defendLoc[2];
	
	goal = ( goalX, goalY, goalZ );
	
	self setVehGoalPos( goal, 1 );
	self waittill ( "goal" );
	
	self thread breakTarget();
}

acquireGroundTarget( targets )
{
	self endon( "death" );
	self endon( "leaving" );
	
	if ( targets.size == 1 )
		self.bestTarget = targets[0];
	else
		self.bestTarget = self getBestTarget( targets );
	
	self backToDefendLocation( false );
	
	self notify( "acquiringTarget" );
	
	self SetTurretTargetEnt( self.bestTarget );
	self SetLookAtEnt( self.bestTarget );
	
	
	if( coinToss() )
		self moveToFireAction1();
	else
		self moveToFireAction2();
	
	self thread watchTargetDeath();
	self thread watchTargetLOS();
	
	self setVehWeapon( "harrier_20mm_mp" );
	self thread fireOnTarget(); // fires on current target.
}

backToDefendLocation( forced )
{
	self setVehGoalPos( self.defendloc, 1 );
	
	if ( isDefined( forced ) && forced )
		self waittill ( "goal" );
}

moveToFireAction1()
{
	directVector = self.origin - self.bestTarget.origin;
	dvX = directVector[0];
	dvY = directVector[1] * -1;
	dvZ = self.origin[2];
	perpendicularVector = ( dvY,dvX,dvZ );
	
	if ( distance2D( self.origin, perpendicularVector ) > 500 )
	{
		dvY *= .5;
		dvX *= .5;	
		perpendicularVector = ( dvY,dvX,dvZ );
		
	}
	
	//targetPoint = (self.bestTarget.origin[0], self.bestTarget.origin[1], self.origin[2]); 
	//self thread drawLine( self.origin, targetPoint, 4);
	//self thread drawLine( self.origin, perpendicularVector, 4 );
	
	if ( wouldCollide( perpendicularVector ) || distance2D( self.origin, perpendicularVector ) > 768 )
		return;
	else
		self setVehGoalPos( perpendicularVector, 1 );
}

moveToFireAction2()
{
	if ( distance2D( self.origin, self.bestTarget.origin ) < 200 )
		return;
		
	yaw = self.angles[1];	
	direction = (0,yaw,0);
	moveToPoint = self.origin + vector_multiply( anglestoforward( direction ), randomIntRange( 100, 200 ) );
	
	if ( wouldCollide( moveToPoint ) || distance2D( self.origin, moveToPoint ) > 768 )
		return;
	else
		self setVehGoalPos( moveToPoint );
}

wouldCollide( destination )
{
	trace = BulletTrace( self.origin, destination, true, self );
	
	if ( trace["position"] == destination )
		return false;
	else
		return true;
}

watchTargetDeath()
{
	self notify( "watchTargetDeath" );
	self endon( "watchTargetDeath" );
	
	self endon( "death" );
	self endon( "leaving" );

	self.bestTarget waittill( "death" );
	breakTarget();
}

//currently unused
heliEngageHeight()
{
	self endon( "death" );
	self endon( "leaving" );
		
	if ( !isDefined(level.chopper.origin) )
			return;
		
	heliHeight = level.chopper.origin[2];
	heightDifference = heliHeight - self.origin[2];
	
	// trace make sure no collision if there is offset x/y randomly then try again
	pathGoal = self.origin + ( 0, 0, heightDifference );
	self Vehicle_SetSpeed( 15, 5 );
	self setVehGoalPos( pathGoal, 1 );
	
	self waittill ( "goal" );
	self.clearedForMissile = true;
}

watchTargetLOS( tolerance )
{
	self endon( "death" );
	self.bestTarget endon( "death" );
	self endon( "leaving" );
	self endon( "newTarget" );
	lostTime = undefined;
	
	if ( !isDefined( tolerance ) )
		tolerance = 1000;
	
	
	for ( ;; )
	{
		if ( self.bestTarget sightConeTrace( self.origin, self ) < 1 )
		{		
			if ( !isDefined(lostTime) )
				lostTime = getTime();
			
			if ( getTime() - lostTime > tolerance )
			{
				self thread breakTarget();
				return;
			}
		}	
		else
		{
			lostTime = undefined;
		}
		
		wait( .25 );
	}
}

breakTarget( noNewTarget )
{
	self ClearLookAtEnt();
	self notify("stopfiring");
	
	if ( isDefined(noNewTarget) && noNewTarget )
 		return;
 	
 	//self thread randomHarrierMovement();
 	self notify( "newTarget" );
 	self thread harrierGetTargets();
	
}

harrierGetTargets()
{
	self notify( "harrierGetTargets" ); 
	self endon("harrierGetTargets");
	
	self endon( "death" );
	self endon( "leaving" );
	targets = [];
	
	for ( ;; )
	{
		targets = [];
		players = level.players;
		
		if ( isDefined( level.chopper ) && level.chopper.team != self.team && isAlive( level.chopper ) )
		{	
			if ( !isDefined( level.chopper.nonTarget ) || ( isDefined( level.chopper.nonTarget ) && !level.chopper.nonTarget )  )
			{
					self thread engageVehicle( level.chopper );
					return;
			}
			else
			{
				backToDefendLocation( true );		
			}
		}
		else if ( isDefined( level.tank ) && level.tank.team != self.team && isAlive( level.tank ) )
		{
			self thread engageVehicle( level.tank );
			return;
		}
			
		for (i = 0; i < players.size; i++)
		{
			potentialTarget = players[i];
			if ( isTarget( potentialTarget ) )
			{
				if( isdefined( players[i] ) )
					targets[targets.size] = players[i];
			}
			else
				continue;
			
			wait( .05 );
		}
		if ( targets.size > 0 )
		{
			self acquireGroundTarget( targets );
			return;
		}
		else if ( isDefined( level.littlebird ) && level.littlebird.size > 0 )
		{
			foreach ( lb in level.littlebird )
			{
				if ( !isDefined(lb) )
					continue;
				
				if ( lb.team != self.team && !isDefined( lb.nonTarget ) || isDefined( lb.nonTarget ) && lb.nonTarget )
			 	{	
			 		self thread engageVehicle( lb );
			 		return;
				}
			}
		}	
		wait( 1 );
	}
}

isTarget( potentialTarget )
{
	self endon( "death" );
	
	if ( !isalive( potentialTarget ) || potentialTarget.sessionstate != "playing" )
		return false;
		
	if ( isDefined( self.owner ) && potentialTarget == self.owner )
		return false;
	
	if ( distance( potentialTarget.origin, self.origin ) > 8192 )
		return false;
	
	if ( Distance2D( potentialTarget.origin , self.origin ) < 384 )
		return false;
	
	if ( !isdefined( potentialTarget.pers["team"] ) )
		return false;
	
	if ( level.teamBased && potentialTarget.pers["team"] == self.team )
		return false;
	
	if ( potentialTarget.pers["team"] == "spectator" )
		return false;
	
	if ( isdefined( potentialTarget.spawntime ) && ( gettime() - potentialTarget.spawntime )/1000 <= 5 )
		return false;

	if ( potentialTarget _hasPerk( "specialty_coldblooded" ) )
		return false;
	
	harrier_centroid = self.origin + ( 0, 0, -160 );
	harrier_forward_norm = anglestoforward( self.angles );
	harrier_turret_point = harrier_centroid + 144 * harrier_forward_norm;
	harrier_canSeeTarget = potentialTarget sightConeTrace( self.origin, self );
	
	if ( harrier_canSeeTarget < 1 )
		return false;	
	
	return true;
}

getBestTarget( targets )
{
	self endon( "death" );
	mainGunPointOrigin = self getTagOrigin( "tag_flash" );
	harrierOrigin = self.origin;
	harrier_forward_norm = anglestoforward( self.angles );
	
	bestYaw = undefined;
	bestTarget = undefined;
	targetHasRocket = false;
	
	foreach ( targ in targets )
	{
		angle = abs ( vectorToAngles ( ( targ.origin - self.origin ) )[1] );
		noseAngle = abs( self getTagAngles( "tag_flash" )[1] );
		angle = abs ( angle - noseAngle );			
		
		// in this calculation having a rocket removes 40d of rotation cost from best target calculation
		// to prioritize targeting dangerous targets.
		weaponsArray = targ GetWeaponsListItems();
		foreach ( weapon in weaponsArray )
		{
			if ( isSubStr( weapon, "at4" ) || isSubStr( weapon, "stinger" ) || isSubStr( weapon, "jav" ) )
				angle -= 40;
		}
		
		if ( Distance( self.origin, targ.origin ) > 2000 )
			angle += 40;
				
		if ( !isDefined( bestYaw ) )
		{				
			bestYaw = angle;
			bestTarget = targ;
		} 
		else if ( bestYaw > angle )
		{
			bestYaw = angle;
			bestTarget = targ;			
		}
	}
	
	return ( bestTarget );
}

fireMissile( missileTarget )
{
	self endon( "death" );
	self endon( "leaving" );
	
	assert( self.health > 0 );
	
	if ( self.missiles <= 0 )
		return;
	
	friendlyInRadius = self checkForFriendlies( missileTarget, 256 );
	
	if ( !isdefined( missileTarget ) )
		return;
		
	if ( Distance2D(self.origin, missileTarget.origin ) < 512 )
		return;
	
	if ( isDefined ( friendlyInRadius ) && friendlyInRadius )
		return;

	self.missiles--;
	self setVehWeapon( "harrier_FFAR_mp" );
	
	if ( isDefined( missileTarget.targetEnt ) )
		missile = self fireWeapon( "tag_flash", missileTarget.targetEnt, (0,0,-250) );
	else
		missile = self fireWeapon( "tag_flash", missileTarget, (0,0,-250) );
		
	missile Missile_SetFlightmodeDirect();
	missile Missile_SetTargetEnt( missileTarget );
}

checkForFriendlies( missileTarget, radiusSize )
{
	self endon( "death" );
	self endon( "leaving" );
	
	targets = [];
	players = level.players;
	strikePosition = missileTarget.origin;
	
	for (i = 0; i < players.size; i++)
	{
		potentialCollateral = players[i];
	
		if ( potentialCollateral.team != self.team )
			continue;
		
		potentialPosition = potentialCollateral.origin;
		
		if ( distance2D( potentialPosition, strikePosition ) < 512 )
			return true;
	}
	return false;
}

///-------------------------------------------------------
//
//		Health Functions
//
///------------------------------------------------------


Callback_VehicleDamage( inflictor, attacker, damage, dFlags, meansOfDeath, weapon, point, dir, hitLoc, timeOffset, modelIndex, partName )
{
	if ( ( attacker == self || ( isDefined( attacker.pers ) && attacker.pers["team"] == self.team ) ) && ( attacker != self.owner || meansOfDeath == "MOD_MELEE" ) )
		return;
	

	self Vehicle_FinishDamage( inflictor, attacker, damage, dFlags, meansOfDeath, weapon, point, dir, hitLoc, timeOffset, modelIndex, partName );
}

harrierHealthWatcher()
{
	self endon( "helicopter_gone" );
	self endon( "death" );
	
	for ( ;; )
	{	
		self waittill( "damage", amount, attacker, direction_vec, point, damageType );
		if ( attacker == self )
		{
				self.health += amount;
				continue;
		}
		
		if ( isDefined( self.owner ) && isDefined( attacker.team ) && attacker.team == self.team && attacker != self.owner)
		{
			self.health += amount;
		}
		else if ( isPlayer( attacker ) )
		{
			if ( amount >= 999 ) 
			{
				harrierExplode();
			}	
			else if ( damageType == "MOD_GRENADE" )
			{
				amount = int( self.maxHealth/2 );
			}
			
			self.health -= amount;
			
			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "" );

			if ( attacker _hasPerk( "specialty_armorpiercing" ) && isBulletDamage( damageType ) )
			{
				damageAdd = amount*level.bulletDamageMod;
				self.health -= int(damageAdd);
			}
		}
		
		if ( self.health <= 0 )
		{
			if ( isPlayer( attacker ) )
				thread teamPlayerCardSplash( "callout_destroyed_harrier", attacker );

			thread maps\mp\gametypes\_missions::vehicleKilled( self.owner, self, undefined, attacker, amount, damageType );

			self notify("death"); 
			attacker notify( "destroyed_killstreak" );
		}
	}
}

harrierDestroyed()
{
	self endon( "harrier_gone" );
	
	self waittill( "death" );
	
	if (! isDefined(self) )
		return;
		
	self Vehicle_SetSpeed( 25, 5 );
	self thread harrierSpin( RandomIntRange(180, 220) );
	
	wait( RandomFloatRange( .5, 1.5 ) );
	harrierExplode();
}

// crash explosion
harrierExplode()
{
	self playSound( "harrier_jet_crash" );
	level.airPlane[level.airPlane.size - 1] = undefined; 
	level.planes--;
	playfxontag( level.harrier_deathfx, self, "tag_deathfx" ); //this effect should play but doesn't...don't know why
	self notify ( "explode" );

	self thread harrierDelete();
}


harrierSpin( speed )
{
	self endon( "explode" );
	
	playfxontag( level.chopper_fx["explode"]["medium"], self, "tag_origin" );
	
	self setyawspeed( speed, speed, speed );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}

engageVehicle( vehTarget )
{
	vehTarget endon("death");
	vehTarget endon("leaving");
	vehTarget endon("crashing");
	self endon("death");
	
		self acquireVehicleTarget( vehTarget );

	//	self thread followVehicleTarget( vehTarget );
		self thread fireOnVehicleTarget();
}

followVehicleTarget( vehTarget )// not in use currently...
{
	assert ( isDefined( vehTarget ) );
	vehTarget endon("leaving");
	vehTarget endon("death");
	
	pos = undefined;
	
	for ( ;; )
	{
		if (! isDefined( vehTarget ) )
			return;
		
		if ( isDefined( pos ) && Distance2D( pos, vehTarget.origin ) < 1000 )
		{
			wait( 1 );
			continue;
		}
		
		pos = vehTarget.origin;
			
		wait (1);
		pointX = RandomFloatRange( pos[0]-600, pos[0]+600 );
		pointY = RandomFloatRange( pos[1]-600, pos[1]+600 );
		pointZ = RandomFloatRange( pos[2]-1, pos[2]+1 );
		
		pathGoal = ( pointX, pointY, pointZ);
		
		trc = BulletTrace( self.origin, pathGoal, false, self );
		
		if ( trc["surfacetype"] != "none" )
			continue;
		
		self setVehGoalPos( pathGoal, 1 );
		self waittill ("goal");
		self Vehicle_SetSpeed( 25, 15 );
		wait (0.05);
	}
}


fireOnVehicleTarget()
{
	self endon("leaving");
	self endon("stopfiring");
	self endon("explode");
	self.bestTarget endon ("crashing");
	self.bestTarget endon ("leaving");
	self.bestTarget endon ("death");
	
	acquiredTime = getTime();
	
	if ( isDefined( self.bestTarget ) && self.bestTarget.classname == "script_vehicle" )
	{
		self SetTurretTargetEnt( self.bestTarget );
	
		for ( ;; )
		{
			curDist = distance2D( self.origin, self.bestTarget.origin );
			
			if ( getTime() - acquiredTime >  2500 && curDist > 1000 )
			{
				self fireMissile( self.bestTarget );
				acquiredTime = getTime();
			}
			
			//if ( curDist < 3000 ) 
			//	self FireWeapon( "tag_flash", self.bestTarget, (0,0,0), .1 );
			
			wait ( .10);
		}
	}
}

acquireVehicleTarget( vehTarget )
{
	self endon( "death" );
	self endon( "leaving" );
		
	self.bestTarget = vehTarget;
	self notify( "acquiringVehTarget" );
	self SetLookAtEnt( self.bestTarget );
	self thread watchVehTargetDeath();
	self thread watchVehTargetCrash();
	
	//make sure this is a littlebird first
	self thread watchLittleBirdLeave();
	
	self SetTurretTargetEnt( self.bestTarget );
}

watchVehTargetCrash()
{
	self endon( "death" );
	self endon( "leaving" );
	self.bestTarget endon ( "death" );
	self.bestTarget endon ( "drop_crate" );
	
	self.bestTarget waittill( "crashing" );
		self breakVehTarget();
}

watchLittleBirdLeave()
{
	self endon( "death" );
	self endon( "leaving" );
	self.bestTarget endon ( "death" );
	self.bestTarget endon ( "leaving" );
	
	self.bestTarget waittill( "drop_crate" );
	wait( 1 );
	breakVehTarget();
}

watchVehTargetDeath()
{
	self endon( "death" );
	self endon( "leaving" );
	self.bestTarget endon ( "crashing" );
	self.bestTarget endon ( "drop_crate" );
	
	self.bestTarget waittill( "death" );
		breakVehTarget();

}

breakVehTarget()
{
	self ClearLookAtEnt();
	
	if ( isDefined( self.bestTarget ) && !isDefined( self.bestTarget.nonTarget ) )
		self.bestTarget.nonTarget = true;
	
	self notify("stopfiring");
 	self notify( "newTarget" );
 	self thread stopHarrierWingFx();
 	self thread engageGround();
}

evasiveManuverOne()
{
	self SetMaxPitchRoll( 15, 80);		
	self Vehicle_SetSpeed( 50, 100 );
	self setYawSpeed(90,30,30,.5);
	
	curOrg = self.origin;
		
	yaw = self.angles[1];	
	if( cointoss() )
		direction = (0,yaw+90,0);
	else
		direction = (0,yaw-90,0);
		
	moveToPoint = self.origin + vector_multiply( anglestoforward( direction ), 500 );
	
	self setVehGoalPos( moveToPoint, 1 );
	println( "evasive manuver one" );
	self waittill ("goal");
}

drawLine( start, end, timeSlice, color )
{
	if( !isdefined( color ) )
		color = ( 1,1,1 );
	
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, color,false, 1 );
		wait ( 0.05 );
	}
}

addToHeliList()
{
	level.helis[self getEntityNumber()] = self;	
}

removeFromHeliListOnDeath()
{
	entityNumber = self getEntityNumber();

	self waittill ( "death" );

	level.helis[entityNumber] = undefined;
}
