// some common functions between all the air kill streaks
#include maps\_utility;
#include common_scripts\utility;

preload()
{
}

initAirsupport()
{	
	if ( !isdefined( level.airsupportHeightScale ) ) 
		level.airsupportHeightScale = 1;
	
	level.airsupportHeightScale = GetDvarIntDefault( "scr_airsupportHeightScale", level.airsupportHeightScale );	

	level.noFlyZones = [];
	level.noFlyZones = GetEntArray("no_fly_zone","targetname");

	airsupport_heights = getstructarray("air_support_height","targetname");
	
	if ( airsupport_heights.size > 1 )
	{
		error( "Found more then one 'air_support_height' structs in the map" );
	}
	
	airsupport_heights = GetEntArray("air_support_height","targetname");
	
	if ( airsupport_heights.size > 0 )
	{
		error( "Found an entity in the map with an 'air_support_height' targetname.  There should be only structs." );
	}

	heli_height_meshes = GetEntArray("heli_height_lock","classname");
	
	if ( heli_height_meshes.size > 1 )
	{
		error( "Found more then one 'heli_height_lock' classname in the map" );
	}
}

finishHardpointLocationUsage( location, usedCallback )
{
	self notify( "used" );
	wait ( 0.05 );
	return self [[usedCallback]]( location );
}

finishDualHardpointLocationUsage( locationStart, locationEnd, usedCallback )
{
	self notify( "used" );
	wait ( 0.05 );
	return self [[usedCallback]]( locationStart, locationEnd );
}

endSelectionOnGameEnd()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "cancel_location" );
	self endon( "used" );

	level waittill( "game_ended" );
	self notify( "game_ended" );
}

endSelectionThink()
{
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	assert( IsDefined( self.selectingLocation ) );
	assert( self.selectingLocation == true );
	
	self thread endSelectionOnGameEnd();
	
	event = self waittill_any_return( "death", "disconnect", "cancel_location", "game_ended", "used", "weapon_change" );

	if ( event != "disconnect" )
	{
		self endLocationSelection();
		self.selectingLocation = undefined;
	}

	if ( event != "used" )
	{
		// wake threads waiting for locations
		self notify( "confirm_location", undefined, undefined );
	}
}

deleteAfterTime( time )
{
	self endon ( "death" );
	wait ( time );
	
	self delete();
}

stopLoopSoundAfterTime( time )
{
	self endon ( "death" );
	wait ( time );
	
	self stoploopsound( 2 );  
}

calculateFallTime( flyHeight )
{
	// this is the value that code uses	
	gravity = GetDvarint( "bg_gravity" );

	time = sqrt( (2 * flyHeight) / gravity );
	
	return time;
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

getMinimumFlyHeight()
{	
	airsupport_height = getstruct( "air_support_height", "targetname");
	if ( IsDefined(airsupport_height) )
	{
		planeFlyHeight = airsupport_height.origin[2];
	}
	else
	{
/#
		PrintLn("WARNING:  Missing air_support_height entity in the map.  Using default height.");
#/
		// original system
		planeFlyHeight = 850;
	
		if ( isdefined( level.airsupportHeightScale ) )
		{
			level.airsupportHeightScale = GetDvarIntDefault( "scr_airsupportHeightScale", level.airsupportHeightScale );	
			planeFlyHeight *= GetDvarIntDefault( "scr_airsupportHeightScale", level.airsupportHeightScale );	
		}
		
		if ( isdefined( level.forceAirsupportMapHeight ) )
		{
			planeFlyHeight += level.forceAirsupportMapHeight;
		}	
	}
	
	return planeFlyHeight;
}

callStrike( flightPlan )
{	
	level.bomberDamagedEnts = [];
	level.bomberDamagedEntsCount = 0;
	level.bomberDamagedEntsIndex = 0;
	
	assert( flightPlan.distance != 0, "callStrike can not be passed a zero fly distance");
	
	planeHalfDistance = flightPlan.distance / 2;

	path = getStrikePath( flightPlan.target, flightPlan.height, planeHalfDistance );
	startPoint = path["start"];
	endPoint = path["end"];
	flightPlan.height = path["height"];
	direction = path["direction"];

	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / flightPlan.speed );
	
	bombTime = calculateReleaseTime( flyTime, flightPlan.height, flightPlan.speed, flightPlan.bombSpeedScale);
	
	if (bombTime < 0)
	{
		bombTime = 0;
	}

	assert( flyTime > bombTime );
	
	flightPlan.owner endon("disconnect");
	
	requiredDeathCount = flightPlan.owner.deathCount;
	
	side = vectorcross( anglestoforward( direction ), (0,0,1) );
	plane_seperation = 25;
	side_offset = VectorScale( side, plane_seperation );

	level thread planeStrike( flightPlan.owner, requiredDeathCount, startPoint, endPoint, bombTime, flyTime, flightPlan.speed, flightPlan.bombSpeedScale, direction, flightPlan.planeSpawnCallback );
	wait( flightPlan.planeSpacing );
	level thread planeStrike( flightPlan.owner, requiredDeathCount, startPoint+side_offset, endPoint+side_offset, bombTime, flyTime, flightPlan.speed, flightPlan.bombSpeedScale, direction, flightPlan.planeSpawnCallback );
	wait( flightPlan.planeSpacing );
	
	side_offset = VectorScale( side, -1 * plane_seperation );

	level thread planeStrike( flightPlan.owner, requiredDeathCount, startPoint+side_offset, endPoint+side_offset, bombTime, flyTime, flightPlan.speed, flightPlan.bombSpeedScale, direction, flightPlan.planeSpawnCallback );
}


planeStrike( owner, requiredDeathCount, pathStart, pathEnd, bombTime, flyTime, flyspeed, bombSpeedScale, direction, planeSpawnedFunction )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512

	if ( !isDefined( owner ) ) 
		return;
	
//	bomb_x = (flySpeed * bombSpeedScale) * bombTime;
//	origin = VectorScale(pathEnd - pathStart, 0.5) + pathStart;
//	plane = spawnplane( owner, "script_model", origin );

	// Spawn the planes
	plane = spawnplane( owner, "script_model", pathStart );
	plane.angles = direction;

	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	thread debug_plane_line( flyTime, flyspeed, pathStart, pathEnd );
	
	if ( IsDefined(planeSpawnedFunction) )
	{
		plane [[planeSpawnedFunction]]( owner, requiredDeathCount, pathStart, pathEnd, bombTime, bombSpeedScale, flyTime, flyspeed );
	}
	
	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

/////////////////////////////////////////////////////////////////////////////
// TARGETING 

determineGroundPoint( player, position )
{
	ground = (position[0], position[1], player.origin[2]);
	
	trace = bullettrace(ground  + (0,0,10000), ground, false, undefined );
	return trace["position"];
}

determineTargetPoint( player, position )
{
	point = determineGroundPoint( player, position );
	
	return clampTarget( point );
}

getMinTargetHeight()
{
	return level.spawnMins[2] - 500;
}

getMaxTargetHeight()
{
	return level.spawnMaxs[2] + 500;
}

clampTarget( target )
{
	min = getMinTargetHeight();
	max = getMaxTargetHeight();
	
	if ( target[2] < min )
		target[2] = min;

	if ( target[2] > max )
		target[2] = max;
		
	return target;
}


/////////////////////////////////////////////////////////////////////////////
// NO FLY ZONE 

_insideCylinder( point, base, radius, height )
{
	// only going to test if the point is above the height
	// if the point is below the cylinder going to treat it
	// as being inside
	if ( IsDefined( height ) )
	{
		if ( point[2] > base[2] + height )
			return false;
	}
		
	dist = Distance2D( point,	base );
	
	if ( dist < radius )
		return true;
		
	return false;
}

_insideNoFlyZoneByIndex( point, index, disregardHeight )
{
	height = level.noFlyZones[index].height;
	
	if ( IsDefined(disregardHeight ) )
		height = undefined;
		
	return _insideCylinder( point, level.noFLyZones[index].origin, level.noFlyZones[index].radius, height );
}

// if not in a no fly zone then it just returns the height of the point passed in
getNoFlyZoneHeight( point )
{
	height = point[2];
	origin = undefined;
	
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		if ( _insideNoFlyZoneByIndex( point, i ) )
		{
			if ( height < level.noFlyZones[i].height )
			{
				height = level.noFlyZones[i].height;
				origin = level.noFlyZones[i].origin;
			}
		}
	}
	
	if ( !IsDefined( origin ) )
		return point[2];
		 
	return origin[2] + height;
}

insideNoFlyZones( point, disregardHeight )
{
	noFlyZones = [];
	
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		if ( _insideNoFlyZoneByIndex( point, i, disregardHeight ) )
		{
			noFlyZones[noFlyZones.size] = i;
		}
	}
	
	return noFlyZones;
}


crossesNoFlyZone( start, end )
{
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		point = closestPointOnLine( level.noFlyZones[i].origin, start, end );
		dist = Distance2D( point,	level.noFlyZones[i].origin );
	
		if ( point[2] > ( level.noFlyZones[i].origin[2] + level.noFlyZones[i].height ) )
			continue;
			
		if ( dist  < level.noFlyZones[i].radius )
		{
			return i;
		}
	}
	
	return undefined;
}

crossesNoFlyZones( start, end )
{
	zones = [];
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		point = closestPointOnLine( level.noFlyZones[i].origin, start, end );
		dist = Distance2D( point,	level.noFlyZones[i].origin );
	
		if ( point[2] > ( level.noFlyZones[i].origin[2] + level.noFlyZones[i].height ) )
			continue;
			
		if ( dist < level.noFlyZones[i].radius )
		{
			zones[zones.size] = i;
		}
	}
	
	return zones;
}

getNoFlyZoneHeightCrossed( start, end, minHeight )
{
	height = minHeight;
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		point = closestPointOnLine( level.noFlyZones[i].origin, start, end );
		dist = Distance2D( point,	level.noFlyZones[i].origin );
	
		if ( dist < level.noFlyZones[i].radius )
		{
			if ( height < level.noFlyZones[i].height )
				height = level.noFlyZones[i].height;
		}
	}
	
	return height;
}

_shouldIgnoreNoFlyZone( noFlyZone, noFlyZones )
{
	if ( !IsDefined( noFlyZone ) )
		return true;
		
	for ( i = 0; i < noFlyZones.size; i ++ )
	{
		if ( IsDefined( noFlyZones[i] ) && noFlyZones[i] == noFlyZone )
			return true;
	}
		
	return false;
}

_shouldIgnoreStartGoalNoFlyZone( noFlyZone, startNoFlyZones, goalNoFlyZones )
{
	if ( !IsDefined( noFlyZone ) )
		return true;
		
	if ( _shouldIgnoreNoFlyZone( noFlyZone, startNoFlyZones ) )
		return true;
		
	if ( _shouldIgnoreNoFlyZone( noFlyZone, goalNoFlyZones ) )
		return true;
		
	return false;
}


getHeliPath( start, goal )
{
	startNoFlyZones = insideNoFlyZones( start, true );
	
	thread debug_line( start, goal, (1,1,1) );

	goalNoFlyZones = insideNoFlyZones( goal );
	
	// if the end point is in a no fly zone then raise the height to the top of the zone
	if ( goalNoFlyZones.size )
	{
		goal = ( goal[0], goal[1], getNoFlyZoneHeight( goal ) );
	}
	
	goal_points = calculatePath(start, goal, startNoFlyZones, goalNoFlyZones );
	
	if ( !IsDefined( goal_points ) )
		return undefined;
		
	Assert(goal_points.size >= 1 );
	
	return goal_points;
}

followPath( path,  doneNotify, stopAtGoal )
{
	for ( i = 0; i < (path.size - 1); i++ )
	{
		self SetVehGoalPos( path[i], false );
		
		thread debug_line( self.origin, path[i], (1,1,0) );
		self waittill("goal" );		
	}
		
	self SetVehGoalPos( path[path.size - 1], stopAtGoal );
	thread debug_line( self.origin, path[i], (1,1,0) );
	
	self waittill("goal" );
	
	if ( IsDefined( doneNotify ) )
	{
		self notify(doneNotify);
	}
}

setGoalPosition( goal, doneNotify, stopAtGoal ) 
{
	if ( !IsDefined( stopAtGoal ) )
		stopAtGoal = true;
		
	// should test the start to see if it is inside of a no fly zone
	// and try and make the vehicle leave the no fly zone in as short of
	// a path possible while still moving intelligently
	start = self.origin;
	
	goal_points = getHeliPath(start, goal );
	
	if ( !IsDefined(goal_points) )
	{
		goal_points = [];
		goal_points[0] = goal;
	}
	
	followPath( goal_points, doneNotify, stopAtGoal );
}

clearPath( start, end, startNoFlyZone, goalNoFlyZone )
{
	noFlyZones = crossesNoFlyZones( start, end );
	
	for ( i = 0 ; i < noFlyZones.size; i++ )
	{
		if ( !_shouldIgnoreStartGoalNoFlyZone( noFlyZones[i], startNoFlyZone, goalNoFlyZone) )
		{
			return false;
		}
	}
	
	return true;
}

append_array( dst, src )
{
	for ( i= 0; i < src.size; i++ )
	{
		dst[ dst.size ]= src[ i ];
	}
}

calculatePath_r( start, end, points, startNoFlyZones, goalNoFlyZones, depth )
{
	depth--;
	
	if ( depth <= 0 )
	{
		points[points.size] = end;
		return points;
	}
	
	noFlyZones = crossesNoFlyZones( start, end );
	
	for ( i = 0; i < noFlyZones.size; i++ )
	{
		noFlyZone = noFlyZones[i];
		
		// simple path right now
		// probably need to modify this so it tests the new lines found
		if ( !_shouldIgnoreStartGoalNoFlyZone( noFlyZone, startNoFlyZones, goalNoFlyZones) )
		{
			return undefined;
		}
	}
	
	points[points.size] = end;

	return points;
}

calculatePath( start, end, startNoFlyZones, goalNoFlyZones )
{
	points = [];
	
//	PrintLn( "starting path calc: " + start + " " + end );
//	points[0] = start;
	
	points = calculatePath_r( start, end, points, startNoFlyZones, goalNoFlyZones, 3 );
	
	if ( !IsDefined(points) )
		return undefined;
	
	Assert( points.size >= 1 );
	
	
	debug_sphere( points[points.size - 1], 10, (1,0,0), 1, 1000 );
	
	point = start;
	
//	PrintLn( "Path Calculated: " + points.size );
	for ( i = 0 ; i < points.size; i++ )
	{
		thread debug_line( point, points[i], (0,1,0) );
		debug_sphere( points[i], 10, (0,0,1), 1, 1000 );
		point = points[i];
	}
	return points;
}

_getStrikePathStartAndEnd( goal, yaw, halfDistance )
{
	direction = (0,yaw,0);
	
	startPoint = goal + VectorScale( anglestoforward( direction ), -1 * halfDistance );
	endPoint = goal + VectorScale( anglestoforward( direction ), halfDistance );
	
	noFlyZone = crossesNoFlyZone( startPoint, endPoint );
	
	path = [];
	
	if ( IsDefined( noFlyZone ) )
	{
		path["noFlyZone"] = noFlyZone;
		
		startPoint = ( startPoint[0], startPoint[1], level.noFlyZones[noFlyZone].origin[2] + level.noFlyZones[noFlyZone].height ); 
		endPoint = ( endPoint[0], endPoint[1], startPoint[2] );
	}
	else
	{
		path["noFlyZone"] = undefined;
	}
	
	path["start"] = startPoint;
	path["end"] = endPoint;
	path["direction"] = direction;
	
	return path;
}

getStrikePath( target, height, halfDistance, yaw )
{
	noFlyZoneHeight = getNoFlyZoneHeight( target );
	
	worldHeight = target[2] + height;
	
	if ( noFlyZoneHeight > worldHeight )
	{
		worldHeight = noFlyZoneHeight;
	}
	
	goal = ( target[0], target[1], worldHeight );

	path = [];
	
	if ( !IsDefined( yaw ) || yaw != "random" )
	{
		// try a few times to find a path that is not through a no fly zone
		for ( i = 0; i < 3; i++ )
		{
			path = _getStrikePathStartAndEnd( goal, randomint( 360 ), halfDistance );
	
			if ( !IsDefined( path["noFlyZone"] ) )
			{
				break;
			}
		}
	}
	else
	{
			path = _getStrikePathStartAndEnd( goal, yaw, halfDistance );
	}
	
	path["height"] = worldHeight - target[2];
	return path;
}

doGlassDamage(pos, radius, max, min, mod)
{
	wait(RandomFloatRange(0.05, 0.15));
	//glassRadiusDamage( pos, radius, max, min, mod );
}

entLOSRadiusDamage( ent, pos, radius, max, min, owner, eInflictor )
{
	dist = distance(pos, ent.damageCenter);
	
	if ( ent.isPlayer || ent.isActor )
	{
		assumed_ceiling_height = 800;  // check for very high ceilings
		eye_position = ent.entity GetEye();
		head_height = eye_position[2];
		debug_display_time = 40 * 100;

		// check if there is a path to this entity above his feet. if not, they're probably indoors
		trace = weaponDamageTrace( ent.entity.origin, ent.entity.origin + (0,0,assumed_ceiling_height), 0, undefined );
		indoors = (trace["fraction"] != 1);
			
		if ( indoors )
		{
			// the follow check will still fail indoors if the bomb is detonated above the player
			// and the ceiling is under 130 units.  This second check will have line of site to 
			// the "ceiling height" point.  I dont want to change it at this point.
			
			test_point = trace["position"];
			debug_star(test_point, (0,1,0), debug_display_time);
			
			trace = weaponDamageTrace( (test_point[0],test_point[1],head_height) , (pos[0],pos[1], head_height), 0, undefined );
			indoors = (trace["fraction"] != 1);
			
			if ( indoors )
			{
				debug_star((pos[0],pos[1], head_height), (0,1,0), debug_display_time);
				// give them a distance advantage for being indoors.
				dist *= 4;
				if ( dist > radius )
					return false;
			}
			else
			{
				debug_star((pos[0],pos[1], head_height), (1,0,0), debug_display_time);
				trace = weaponDamageTrace( (pos[0],pos[1], head_height), pos, 0, undefined );
				indoors = (trace["fraction"] != 1);
				if ( indoors )
				{
					debug_star(pos, (0,1,0), debug_display_time);
					// give them a distance advantage for being indoors.
					dist *= 4;
					if ( dist > radius )
						return false;
				}
				else
				{
					debug_star(pos, (1,0,0), debug_display_time);
				}
			}
		}
		else
		{
			debug_star(ent.entity.origin + (0,0,assumed_ceiling_height), (1,0,0), debug_display_time );
		}
	}

	ent.damage = int(max + (min-max)*dist/radius);
	ent.pos = pos;
	ent.damageOwner = owner;
	ent.eInflictor = eInflictor;
	
	return true;
}
////////////////////////////////////////////////////////////////////////////
// debug

debug_plane_line( flyTime, flyspeed,pathStart, pathEnd )
{
	thread debug_line( pathStart, pathEnd, (1,1,1) );
	
	delta = VectorNormalize(pathEnd - pathStart);
	
	for ( i = 0; i < flyTime; i++ )
	{
		thread debug_star( pathStart + VectorScale(delta, i * flyspeed), (1,0,0) );
	}
}

debug_draw_bomb_explosion(prevpos)
{
	self notify("draw_explosion");
	wait(0.05);
	self endon("draw_explosion");
	
	self waittill("projectile_impact", weapon, position );
	
	thread debug_line( prevpos, position, (.5,1,0) );
	thread debug_star( position, (1,0,0) );
}

debug_draw_bomb_path( projectile, color, time )
{
/#
	self endon("death");
	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( !IsDefined( color ) )
	{
		color = (.5,1,0);
	}
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
	{
		prevpos = self.origin;
		while(isdefined ( self.origin ) )
		{		
			thread debug_line( prevpos, self.origin, color, time );
			prevpos = self.origin;
			
			if ( IsDefined(projectile) && projectile )
			{
				thread debug_draw_bomb_explosion( prevpos );
			}
			
			wait .2;
		}
	}
#/
}

debug_print3d_simple( message, ent, offset, frames )
{
	/#
	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
	{
		if( isdefined( frames ) )
			thread draw_text( message, ( 0.8, 0.8, 0.8 ), ent, offset, frames );
		else
			thread draw_text( message, ( 0.8, 0.8, 0.8 ), ent, offset, 0 );
	}
	#/
}

draw_text( msg, color, ent, offset, frames )
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


debug_print3d( message, color, ent, origin_offset, frames )
{
/#
	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
		self thread draw_text( message, color, ent, origin_offset, frames );
#/
}


debug_line( from, to, color, time )
{
/#
	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		Line( from, to, color, 1, 1, time);
	}
#/

}

debug_star( origin, color, time )
{
/#
	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		if ( !IsDefined(color) )
		{
			color = (1,1,1);
		}
		debugstar(  origin, time, color );
	}
#/
}

debug_circle( origin, radius, color, time )
{
/#
	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		if ( !IsDefined(color) )
		{
			color = (1,1,1);
		}
		circle( origin, radius, color, true, true, time );
	}
#/
}

debug_sphere( origin, radius, color, alpha, time )
{
/#
	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		if ( !IsDefined(color) )
		{
			color = (1,1,1);
		}
		
		sides = Int(10 * ( 1 + Int(radius) % 100 ));
		sphere( origin, radius, color, alpha, true, sides, time );
	}
#/
}

debug_cylinder( origin, radius, height, color, mustRenderHeight, time  )
{
/#
	level.airsupport_debug = GetDvarIntDefault( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	subdivision = 50;
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1 )
	{
		if ( !IsDefined(time) )
		{
			time = 1000;
		}
		if ( !IsDefined(color) )
		{
			color = (1,1,1);
		}
		
		count = (height/subdivision);
		
		for ( i = 0; i < count; i++ )
		{
			point = origin + ( 0, 0, i * subdivision );
//			circle( point, radius, color, true, true, time );
		}
		
		if( IsDefined( mustRenderHeight ) )
		{
			point = origin + ( 0, 0, mustRenderHeight );
//			circle( point, radius, color, true, true, time );
		}
	}
#/
}

getPointOnLine( startPoint, endPoint, ratio )
{
	nextPoint = ( startPoint[0] + ( ( endPoint[0] - startPoint[0] ) * ratio ) , 
				  startPoint[1] + ( ( endPoint[1] - startPoint[1] ) * ratio ) ,
				  startPoint[2] + ( ( endPoint[2] - startPoint[2] ) * ratio ) );

	return nextPoint;
}
