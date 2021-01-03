#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\math_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_util;

#namespace airsupport;

// some common functions between all the air kill streaks

function init()
{	
	if ( !isdefined( level.airsupportHeightScale ) ) 
		level.airsupportHeightScale = 1;
	
	level.airsupportHeightScale = GetDvarInt( "scr_airsupportHeightScale", level.airsupportHeightScale );	

	level.noFlyZones = [];
	level.noFlyZones = GetEntArray("no_fly_zone","targetname");

	airsupport_heights = struct::get_array("air_support_height","targetname");
	
	/#
	if ( airsupport_heights.size > 1 )
	{
		util::error( "Found more then one 'air_support_height' structs in the map" );
	}
	#/
	
	airsupport_heights = GetEntArray("air_support_height","targetname");
	
	/#
	if ( airsupport_heights.size > 0 )
	{
		util::error( "Found an entity in the map with an 'air_support_height' targetname.  There should be only structs." );
	}
	#/

	heli_height_meshes = GetEntArray("heli_height_lock","classname");	

	/#
	if ( heli_height_meshes.size > 1 )
	{
		util::error( "Found more then one 'heli_height_lock' classname in the map" );
	}
	#/
		
	InitRotatingRig();
}

function finishHardpointLocationUsage( location, usedCallback )
{
	self notify( "used" );
	{wait(.05);};
	
	if( isdefined( usedCallback ) )
	{
		return self [[usedCallback]]( location );
	}
	
	return true;
}

function finishDualHardpointLocationUsage( locationStart, locationEnd, usedCallback )
{
	self notify( "used" );
	{wait(.05);};
	return self [[usedCallback]]( locationStart, locationEnd );
}

function endSelectionOnGameEnd()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "cancel_location" );
	self endon( "used" );
	self endon( "host_migration_begin" );

	level waittill( "game_ended" );
	self notify( "game_ended" );
}

function endSelectionOnHostMigration()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "cancel_location" );
	self endon( "used" );
	self endon( "game_ended" );

	level waittill( "host_migration_begin" );
	self notify( "cancel_location" );
}

function endSelectionThink()
{
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	assert( isdefined( self.selectingLocation ) );
	assert( self.selectingLocation == true );
	
	self thread endSelectionOnGameEnd();
	self thread endSelectionOnHostMigration();
	
	event = self util::waittill_any_return( "death", "disconnect", "cancel_location", "game_ended", "used", "weapon_change", "emp_jammed" );

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

function stopLoopSoundAfterTime( time )
{
	self endon ( "death" );
	wait ( time );
	
	self stoploopsound( 2 );  
}

function calculateFallTime( flyHeight )
{
	// this is the value that code uses	
	gravity = GetDvarint( "bg_gravity" );

	time = sqrt( (2 * flyHeight) / gravity );
	
	return time;
}

function calculateReleaseTime( flyTime, flyHeight, flySpeed, bombSpeedScale )
{
	falltime = calculateFallTime( flyHeight );

	// bomb horizontal velocity is not the same as the plane speed so we need to take this
	// into account when calculating the bomb time
	bomb_x = (flySpeed * bombSpeedScale) * falltime;
	release_time = bomb_x / flySpeed;
	
	return ( (flyTime * 0.5) - release_time);
}

function getMinimumFlyHeight()
{	
	airsupport_height = struct::get( "air_support_height", "targetname");
	if ( isdefined(airsupport_height) )
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
			level.airsupportHeightScale = GetDvarInt( "scr_airsupportHeightScale", level.airsupportHeightScale );	
			planeFlyHeight *= GetDvarInt( "scr_airsupportHeightScale", level.airsupportHeightScale );	
		}
		
		if ( isdefined( level.forceAirsupportMapHeight ) )
		{
			planeFlyHeight += level.forceAirsupportMapHeight;
		}	
	}
	
	return planeFlyHeight;
}

function callStrike( flightPlan )
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
	
	side = weaponobjects::vectorcross( anglestoforward( direction ), (0,0,1) );
	plane_seperation = 25;
	side_offset = VectorScale( side, plane_seperation );

	level thread planeStrike( flightPlan.owner, requiredDeathCount, startPoint, endPoint, bombTime, flyTime, flightPlan.speed, flightPlan.bombSpeedScale, direction, flightPlan.planeSpawnCallback );
	wait( flightPlan.planeSpacing );
	level thread planeStrike( flightPlan.owner, requiredDeathCount, startPoint+side_offset, endPoint+side_offset, bombTime, flyTime, flightPlan.speed, flightPlan.bombSpeedScale, direction, flightPlan.planeSpawnCallback );
	wait( flightPlan.planeSpacing );
	
	side_offset = VectorScale( side, -1 * plane_seperation );

	level thread planeStrike( flightPlan.owner, requiredDeathCount, startPoint+side_offset, endPoint+side_offset, bombTime, flyTime, flightPlan.speed, flightPlan.bombSpeedScale, direction, flightPlan.planeSpawnCallback );
}


function planeStrike( owner, requiredDeathCount, pathStart, pathEnd, bombTime, flyTime, flyspeed, bombSpeedScale, direction, planeSpawnedFunction )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512

	if ( !isdefined( owner ) ) 
		return;
	
//	bomb_x = (flySpeed * bombSpeedScale) * bombTime;
//	origin = VectorScale(pathEnd - pathStart, 0.5) + pathStart;
//	plane = spawnplane( owner, "script_model", origin );

	// Spawn the planes
	plane = spawnplane( owner, "script_model", pathStart );
	plane.angles = direction;

	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	thread debug_plane_line( flyTime, flyspeed, pathStart, pathEnd );
	
	if ( isdefined(planeSpawnedFunction) )
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

function determineGroundPoint( player, position )
{
	ground = (position[0], position[1], player.origin[2]);
	
	trace = bullettrace(ground  + (0,0,10000), ground, false, undefined );
	return trace["position"];
}

function determineTargetPoint( player, position )
{
	point = determineGroundPoint( player, position );
	
	return clampTarget( point );
}

function getMinTargetHeight()
{
	return level.spawnMins[2] - 500;
}

function getMaxTargetHeight()
{
	return level.spawnMaxs[2] + 500;
}

function clampTarget( target )
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

function _insideCylinder( point, base, radius, height )
{
	// only going to test if the point is above the height
	// if the point is below the cylinder going to treat it
	// as being inside
	if ( isdefined( height ) )
	{
		if ( point[2] > base[2] + height )
			return false;
	}
		
	dist = Distance2D( point,	base );
	
	if ( dist < radius )
		return true;
		
	return false;
}

function _insideNoFlyZoneByIndex( point, index, disregardHeight )
{
	height = level.noFlyZones[index].height;
	
	if ( isdefined(disregardHeight ) )
		height = undefined;
		
	return _insideCylinder( point, level.noFLyZones[index].origin, level.noFlyZones[index].radius, height );
}

// if not in a no fly zone then it just returns the height of the point passed in
function getNoFlyZoneHeight( point )
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
	
	if ( !isdefined( origin ) )
		return point[2];
		 
	return origin[2] + height;
}

function insideNoFlyZones( point, disregardHeight )
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


function crossesNoFlyZone( start, end )
{
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		point = math::closest_point_on_line( level.noFlyZones[i].origin + (0,0,(0.5 * level.noFlyZones[i].height)), start, end );
		dist = Distance2D( point, level.noFlyZones[i].origin );
	
		if ( point[2] > ( level.noFlyZones[i].origin[2] + level.noFlyZones[i].height ) )
			continue;
			
		if ( dist  < level.noFlyZones[i].radius )
		{
			return i;
		}
	}
	
	return undefined;
}

function crossesNoFlyZones( start, end )
{
	zones = [];
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		point = math::closest_point_on_line( level.noFlyZones[i].origin, start, end );
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

function getNoFlyZoneHeightCrossed( start, end, minHeight )
{
	height = minHeight;
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		point = math::closest_point_on_line( level.noFlyZones[i].origin, start, end );
		dist = Distance2D( point, level.noFlyZones[i].origin );
	
		if ( dist < level.noFlyZones[i].radius )
		{
			if ( height < level.noFlyZones[i].height )
				height = level.noFlyZones[i].height;
		}
	}
	
	return height;
}

function _shouldIgnoreNoFlyZone( noFlyZone, noFlyZones )
{
	if ( !isdefined( noFlyZone ) )
		return true;
		
	for ( i = 0; i < noFlyZones.size; i ++ )
	{
		if ( isdefined( noFlyZones[i] ) && noFlyZones[i] == noFlyZone )
			return true;
	}
		
	return false;
}

function _shouldIgnoreStartGoalNoFlyZone( noFlyZone, startNoFlyZones, goalNoFlyZones )
{
	if ( !isdefined( noFlyZone ) )
		return true;
		
	if ( _shouldIgnoreNoFlyZone( noFlyZone, startNoFlyZones ) )
		return true;
		
	if ( _shouldIgnoreNoFlyZone( noFlyZone, goalNoFlyZones ) )
		return true;
		
	return false;
}


function getHeliPath( start, goal )
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
	
	if ( !isdefined( goal_points ) )
		return undefined;
		
	Assert(goal_points.size >= 1 );
	
	return goal_points;
}

function followPath( path,  doneNotify, stopAtGoal )
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
	
	if ( isdefined( doneNotify ) )
	{
		self notify(doneNotify);
	}
}

function setGoalPosition( goal, doneNotify, stopAtGoal ) 
{
	if ( !isdefined( stopAtGoal ) )
		stopAtGoal = true;
		
	// should test the start to see if it is inside of a no fly zone
	// and try and make the vehicle leave the no fly zone in as short of
	// a path possible while still moving intelligently
	start = self.origin;
	
	goal_points = getHeliPath(start, goal );
	
	if ( !isdefined(goal_points) )
	{
		goal_points = [];
		goal_points[0] = goal;
	}
	
	followPath( goal_points, doneNotify, stopAtGoal );
}

function clearPath( start, end, startNoFlyZone, goalNoFlyZone )
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

function append_array( dst, src )
{
	for ( i= 0; i < src.size; i++ )
	{
		dst[ dst.size ]= src[ i ];
	}
}

function calculatePath_r( start, end, points, startNoFlyZones, goalNoFlyZones, depth )
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

function calculatePath( start, end, startNoFlyZones, goalNoFlyZones )
{
	points = [];
	
//	PrintLn( "starting path calc: " + start + " " + end );
//	points[0] = start;
	
	points = calculatePath_r( start, end, points, startNoFlyZones, goalNoFlyZones, 3 );
	
	if ( !isdefined(points) )
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

function _getStrikePathStartAndEnd( goal, yaw, halfDistance )
{
	direction = (0,yaw,0);
	
	startPoint = goal + VectorScale( anglestoforward( direction ), -1 * halfDistance );
	endPoint = goal + VectorScale( anglestoforward( direction ), halfDistance );
	
	noFlyZone = crossesNoFlyZone( startPoint, endPoint );
	
	path = [];
	
	if ( isdefined( noFlyZone ) )
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

function getStrikePath( target, height, halfDistance, yaw )
{
	noFlyZoneHeight = getNoFlyZoneHeight( target );
	
	worldHeight = target[2] + height;
	
	if ( noFlyZoneHeight > worldHeight )
	{
		worldHeight = noFlyZoneHeight;
	}
	
	goal = ( target[0], target[1], worldHeight );

	path = [];
	
	if ( !isdefined( yaw ) || yaw != "random" )
	{
		// try a few times to find a path that is not through a no fly zone
		for ( i = 0; i < 3; i++ )
		{
			path = _getStrikePathStartAndEnd( goal, randomint( 360 ), halfDistance );
	
			if ( !isdefined( path["noFlyZone"] ) )
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

function doGlassDamage(pos, radius, max, min, mod)
{
	wait(RandomFloatRange(0.05, 0.15));
	glassRadiusDamage( pos, radius, max, min, mod );
}

function entLOSRadiusDamage( ent, pos, radius, max, min, owner, eInflictor )
{
	dist = distance(pos, ent.damageCenter);
	
	if ( ent.isPlayer || ent.isActor )
	{
		assumed_ceiling_height = 800;  // check for very high ceilings
		eye_position = ent.entity GetEye();
		head_height = eye_position[2];
		debug_display_time = 40 * 100;

		// check if there is a path to this entity above his feet. if not, they're probably indoors
		trace = weapons::damage_trace( ent.entity.origin, ent.entity.origin + (0,0,assumed_ceiling_height), 0, undefined );
		indoors = (trace["fraction"] != 1);
			
		if ( indoors )
		{
			// the follow check will still fail indoors if the bomb is detonated above the player
			// and the ceiling is under 130 units.  This second check will have line of site to 
			// the "ceiling height" point.  I dont want to change it at this point.
			
			test_point = trace["position"];
			debug_star(test_point, (0,1,0), debug_display_time);
			
			trace = weapons::damage_trace( (test_point[0],test_point[1],head_height) , (pos[0],pos[1], head_height), 0, undefined );
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
				trace = weapons::damage_trace( (pos[0],pos[1], head_height), pos, 0, undefined );
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
function GetMapCenter()
{
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if( miniMapOrigins.size )
	{
		return math::find_box_center( miniMapOrigins[0].origin, miniMapOrigins[1].origin );
	}
	
	return ( 0, 0, 0 );
}

function GetRandomMapPoint( map_percentage )
{
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if( miniMapOrigins.size )
	{
		rand_x = 0;
		rand_y = 0;
		
		if( miniMapOrigins[0].origin[0] < miniMapOrigins[1].origin[0] )
		{
			rand_x = RandomFloatRange( miniMapOrigins[0].origin[0] * map_percentage, miniMapOrigins[1].origin[0] * map_percentage );
			rand_y = RandomFloatRange( miniMapOrigins[0].origin[1] * map_percentage, miniMapOrigins[1].origin[1] * map_percentage );
		}
		else
		{
			rand_x = RandomFloatRange( miniMapOrigins[1].origin[0] * map_percentage, miniMapOrigins[0].origin[0] * map_percentage );
			rand_y = RandomFloatRange( miniMapOrigins[1].origin[1] * map_percentage, miniMapOrigins[0].origin[1] * map_percentage );
		}

		return ( rand_x, rand_y, 0 );
	}
	
	return ( 0, 0, 0 );
}

function GetMaxMapWidth()
{
	minimapOrigins = getEntArray( "minimap_corner", "targetname" );
	if( miniMapOrigins.size )
	{
		x = abs( miniMapOrigins[0].origin[0] - miniMapOrigins[1].origin[0] );
		y = abs( miniMapOrigins[0].origin[1] - miniMapOrigins[1].origin[1] );
		
		return max( x, y );
	}
	
	return 0;
}

function InitRotatingRig()
{
	level.airsupport_rotator = spawn( "script_model", GetMapCenter() +  ( 0, 0, 1200 ) ); 
	level.airsupport_rotator setModel( "tag_origin" );
	level.airsupport_rotator.angles = ( 0, 115, 0 );
	level.airsupport_rotator hide();
	level.airsupport_rotator thread RotateRig();
	level.airsupport_rotator thread SwayRig();
}

function RotateRig()
{
	for (;;)
	{
		self rotateyaw( -360, 60 );
		wait ( 60 );
	}
}

function SwayRig()
{
	centerOrigin = self.origin;
	
	for (;;)
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

function StopRotation( time )
{
	self endon( "death" );
	wait( time );
	self StopLoopSound();
}

function FlattenYaw( goal )
{
	self endon( "death" );
	
	increment = 3;
	if ( self.angles[1] > goal )
	{
		increment = increment * -1;
	}
	while( abs( self.angles[1] - goal ) > 3 )
	{
		self.angles = (self.angles[0], self.angles[1] + increment, self.angles[2] );
		{wait(.05);};
	}
}

function FlattenRoll()
{
	self endon( "death" );
	
	while (self.angles[2] < 0)
	{
		self.angles = (self.angles[0], self.angles[1], self.angles[2] + 2.5 );
		{wait(.05);};
	}
}

function Leave( duration )
{	
	self unlink();

	self thread StopRotation( 1 );
	
	tries = 10;
	yaw = 0;
	while( tries > 0 )
	{
		exitVector = ( anglestoforward( self.angles + ( 0, yaw, 0 ) ) * 20000 );
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

	self thread FlattenYaw( self.angles[1] + yaw );
	if (self.angles[2] != 0)
	{
		self thread FlattenRoll();
	}
	
	self moveto( exitPoint, duration, 0, 0 );
	self notify ( "leaving");
}


function GetRandomHelicopterStartOrigin()
{
	dist = -1 * GetDvarInt( "scr_supplydropIncomingDistance", 10000 );
	pathRandomness = 100;
	direction = ( 0, RandomIntRange( -2, 3 ), 0 );
	
	start_origin = ( AnglesToForward( direction ) * dist );
	start_origin += ( ( randomfloat( 2 ) - 1 ) * pathRandomness, ( randomfloat( 2 ) - 1 ) * pathRandomness, 0 );

/#
	if ( GetDvarInt( "scr_noflyzones_debug", 0 ) ) 
	{
		if ( level.noFlyZones.size )
		{
			index = RandomIntRange( 0, level.noFlyZones.size );
			delta = level.noFlyZones[ index ].origin;
			delta = ( delta[0] + RandomInt( 10 ), delta[ 1 ] + RandomInt( 10 ), 0 );
			delta = VectorNormalize( delta );
			start_origin = ( delta * dist );
		}
	}
#/
	return start_origin;
}


////////////////////////////////////////////////////////////////////////////
// debug

function debug_no_fly_zones()
{
	/#
	for ( i = 0; i < level.noFlyZones.size; i++ )
	{
		debug_airsupport_cylinder( level.noFlyZones[i].origin, level.noFlyZones[i].radius, level.noFlyZones[i].height, (1,1,1), undefined, 5000 );
	}
	#/
}

function debug_plane_line( flyTime, flyspeed,pathStart, pathEnd )
{
	thread debug_line( pathStart, pathEnd, (1,1,1) );
	
	delta = VectorNormalize(pathEnd - pathStart);
	
	for ( i = 0; i < flyTime; i++ )
	{
		thread debug_star( pathStart + VectorScale(delta, i * flyspeed), (1,0,0) );
	}
}

function debug_draw_bomb_explosion(prevpos)
{
	self notify("draw_explosion");
	{wait(.05);};
	self endon("draw_explosion");
	
	self waittill("projectile_impact", weapon, position );
	
	thread debug_line( prevpos, position, (.5,1,0) );
	thread debug_star( position, (1,0,0) );
}

function debug_draw_bomb_path( projectile, color, time )
{
/#
	self endon("death");
	level.airsupport_debug = GetDvarInt( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( !isdefined( color ) )
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
			
			if ( isdefined(projectile) && projectile )
			{
				thread debug_draw_bomb_explosion( prevpos );
			}
			
			wait .2;
		}
	}
#/
}

function debug_print3d_simple( message, ent, offset, frames )
{
	/#
	level.airsupport_debug = GetDvarInt( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
	{
		if( isdefined( frames ) )
			thread draw_text( message, ( 0.8, 0.8, 0.8 ), ent, offset, frames );
		else
			thread draw_text( message, ( 0.8, 0.8, 0.8 ), ent, offset, 0 );
	}
	#/
}

function draw_text( msg, color, ent, offset, frames )
{
	/#
	if( frames == 0 )
	{
		while ( isdefined( ent ) && isdefined( ent.origin ) )
		{
			print3d( ent.origin+offset, msg , color, 0.5, 4 );
			{wait(.05);};
		}
	}
	else
	{
		for( i=0; i < frames; i++ )
		{
			if( !isdefined( ent ) )
				break;
			print3d( ent.origin+offset, msg , color, 0.5, 4 );
			{wait(.05);};
		}
	}
	#/
}


function debug_print3d( message, color, ent, origin_offset, frames )
{
/#
	level.airsupport_debug = GetDvarInt( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
		self thread draw_text( message, color, ent, origin_offset, frames );
#/
}


function debug_line( from, to, color, time, depthTest )
{
/#
	level.airsupport_debug = GetDvarInt( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
	{
		if ( DistanceSquared( from, to )  < 0.01 )
			return;
		
		if ( !isdefined(time) )
		{
			time = 1000;
		}
		if ( !isdefined(depthTest) )
		{
			depthTest = true;
		}
		Line( from, to, color, 1, depthTest, time);
	}
#/

}

function debug_star( origin, color, time )
{
/#
	level.airsupport_debug = GetDvarInt( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1.0 )
	{
		if ( !isdefined(time) )
		{
			time = 1000;
		}
		if ( !isdefined(color) )
		{
			color = (1,1,1);
		}
		debugstar(  origin, time, color );
	}
#/
}

function debug_circle( origin, radius, color, time )
{
/#
	level.airsupport_debug = GetDvarInt( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1 )
	{
		if ( !isdefined(time) )
		{
			time = 1000;
		}
		if ( !isdefined(color) )
		{
			color = (1,1,1);
		}
		circle( origin, radius, color, true, true, time );
	}
#/
}

function debug_sphere( origin, radius, color, alpha, time )
{
/#
	level.airsupport_debug = GetDvarInt( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1 )
	{
		if ( !isdefined(time) )
		{
			time = 1000;
		}
		if ( !isdefined(color) )
		{
			color = (1,1,1);
		}
		
		sides = Int(10 * ( 1 + Int(radius / 100) ));
		sphere( origin, radius, color, alpha, true, sides, time );
	}
#/
}

function debug_airsupport_cylinder( origin, radius, height, color, mustRenderHeight, time )
{
/#
	level.airsupport_debug = GetDvarInt( "scr_airsupport_debug", 0 );				// debug mode, draws debugging info on screen
	
	if ( isdefined( level.airsupport_debug ) && level.airsupport_debug == 1 )
	{
		debug_cylinder( origin, radius, height, color, mustRenderHeight, time );
	}
#/
}

function debug_cylinder( origin, radius, height, color, mustRenderHeight, time )
{
/#
	
	subdivision = 600;
	
	{
		if ( !isdefined(time) )
		{
			time = 1000;
		}
		if ( !isdefined(color) )
		{
			color = (1,1,1);
		}
		
		count = (height/subdivision);
		
		for ( i = 0; i < count; i++ )
		{
			point = origin + ( 0, 0, i * subdivision );
			circle( point, radius, color, true, true, time );
		}
		
		if( isdefined( mustRenderHeight ) )
		{
			point = origin + ( 0, 0, mustRenderHeight );
			circle( point, radius, color, true, true, time );
		}
	}
#/
}
function getPointOnLine( startPoint, endPoint, ratio )
{
	nextPoint = ( startPoint[0] + ( ( endPoint[0] - startPoint[0] ) * ratio ) , 
				  startPoint[1] + ( ( endPoint[1] - startPoint[1] ) * ratio ) ,
				  startPoint[2] + ( ( endPoint[2] - startPoint[2] ) * ratio ) );

	return nextPoint;
}

function canTargetPlayerWithSpecialty()
{
	if ( self HasPerk( "specialty_nottargetedbyairsupport" ) || 
	(	isdefined( self.specialty_nottargetedbyairsupport ) && self.specialty_nottargetedbyairsupport ) )
	{
		if ( !isdefined( self.notTargettedAI_underMinSpeedTimer ) || self.notTargettedAI_underMinSpeedTimer < GetDvarInt( "perk_nottargetedbyai_graceperiod" ) )
			return false;
	}
	return true;
}


function monitorSpeed( spawnProtectionTime )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	if ( self HasPerk( "specialty_nottargetedbyairsupport" ) == false )
	{
		return;
	}

	GetDvarString( "perk_nottargetted_graceperiod" );
	gracePeriod = GetDvarInt( "perk_nottargetedbyai_graceperiod" );
	minspeed = GetDvarInt( "perk_nottargetedbyai_min_speed" );
	minspeedSq = minspeed * minspeed;
	waitPeriod = 0.25;
	waitPeriodMilliseconds = waitPeriod * 1000;
	if ( minspeedSq == 0 ) // will never fail min speed check below so early out.  
		return;
	
	self.notTargettedAI_underMinSpeedTimer = 0;
	
	if ( isdefined ( spawnProtectionTime ) )
	{
		wait( spawnProtectionTime );
	}
	
	while(1)
	{
		velocity = self GetVelocity();
		
		speedsq = lengthsquared( velocity );
		
		if ( speedSq < minspeedSq )
		{
			self.notTargettedAI_underMinSpeedTimer += waitPeriodMilliseconds;
		}
		else
		{
			self.notTargettedAI_underMinSpeedTimer = 0;
		}
		
		wait( waitPeriod );
	}
}

function clearmonitoredspeed()
{
	if ( isdefined ( self.notTargettedAI_underMinSpeedTimer ) ) 
		self.notTargettedAI_underMinSpeedTimer = 0;
}
