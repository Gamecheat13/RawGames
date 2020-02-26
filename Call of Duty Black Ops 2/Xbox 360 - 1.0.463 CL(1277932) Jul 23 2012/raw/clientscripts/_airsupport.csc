#include clientscripts\_utility;
#include clientscripts\_utility_code; 
#include clientscripts\_vehicle;


planeSounds(  spawnSound, flybySound, flybySoundLoop, lengthOfFlyby )
{
	self endon("delete");

	fake_ent_plane = spawnfakeent( 0 );
	//println("playing spawn sound");
	playsound (0, spawnSound, (0,0,0));
	
	thread plane_position_updater (fake_ent_plane, self, flybySound, flybySoundLoop, lengthOfFlyBy);
	
}

plane_position_updater ( fake_ent, plane, flybySound, flybySoundLoop, lengthOfFlyby )
{	
	soundid = -1;
	dx = undefined;
	lastTime = undefined;
	lastPos = undefined;
	startTime = 0;
	
	while(IsDefined(plane))
	{
		//println(".");
		setfakeentorg(0, fake_ent, plane.origin);
			
		if((soundid < 0) && isdefined(lastPos))
		{
			dx = plane.origin - lastPos;
			
			if(length(dx) > .01)
			{
			
				velocity = dx / (getrealtime()-lastTime);
				assert(isdefined(velocity));
				players = level.localPlayers;
				assert(isdefined(players));
				other_point = plane.origin + (velocity * 100000);
				point = closest_point_on_line_to_point(players[0].origin, plane.origin, other_point );
				assert(isdefined(point));
				dist = Distance( point, plane.origin );	
				assert(isdefined(dist));
				time = dist / length(velocity);
				assert(isdefined(time));
				
				if( time < lengthOfFlyby )
				{
					if ( isdefined ( flybysoundloop ) )
						soundid = playloopsound(0, fake_ent, flybySoundLoop, 0 );	
							
					//changed to attach to plane, CDC							
					if ( isdefined ( flybySound ) )
 						plane playsound (0, flybySound);
						
					startTime = getRealTime();
				}	
				
				//println( "vel:"+velocity+" pnt:"+point+" dst:"+dist+" t:"+time+"\n" );
			}
		}
			
		lastPos = plane.origin;
		lastTime = getrealtime();
						
		waitrealtime(0.1);		
		
	}
	wait (5);
	deletefakeent(0, fake_ent);

}


closest_point_on_line_to_point( Point, LineStart, LineEnd )
{
	
	LineMagSqrd = lengthsquared(LineEnd - LineStart);
 
    t =	( ( ( Point[0] - LineStart[0] ) * ( LineEnd[0] - LineStart[0] ) ) +
				( ( Point[1] - LineStart[1] ) * ( LineEnd[1] - LineStart[1] ) ) +
				( ( Point[2] - LineStart[2] ) * ( LineEnd[2] - LineStart[2] ) ) ) /
				( LineMagSqrd );
 
 	if( t < 0.0  )
	{
		return LineStart;
	}
	else if( t > 1.0 )
	{
		return LineEnd;
	}
	else
	{
		start_x = LineStart[0] + t * ( LineEnd[0] - LineStart[0] );
		start_y = LineStart[1] + t * ( LineEnd[1] - LineStart[1] );
		start_z = LineStart[2] + t * ( LineEnd[2] - LineStart[2] );
		
		return (start_x,start_y,start_z);
	}
}

getPlaneModel( teamFaction )
{
	switch ( teamFaction ) 
	{
		case "vietcong":
			planemodel = "t5_veh_air_mig_21_nva_flying";
			break;
		case "nva":
			planemodel = "t5_veh_air_mig_21_nva_flying";
			break;
		case "japanese":
			planemodel = "t5_veh_air_mig_21_ussr_flying";
			break;
		case "russian":
			planemodel = "t5_veh_air_mig_21_ussr_flying";
			break;
		case "marines":
			planemodel = "t5_veh_jet_f4_gearup";
			break;
		case "specops":
			planemodel = "t5_veh_jet_f4_gearup";
			break;

		default:
			/#println( "invalid faction, defaulting to marines" );#/
			planemodel = "t5_veh_jet_f4_gearup";
			break;
	}
	
	return planeModel;
}

planeTurnLeft( plane, yaw, halflife )
{
	// X(0) is Pitch
	// Y(1) is Yaw
	// Z(2) is Roll!
	
	plane endon("delete");
	
	yawY = GetDvarFloatDefault( "scr_planeyaw", 0.6 );
	rollZ = GetDvarFloatDefault( "scr_planeroll", -1.5 );

	maxYaw = GetDvarFloatDefault( "scr_max_planeyaw", 45.0 );
	minRoll = GetDvarFloatDefault( "scr_min_planeroll", -60.0 );
	
	ox = GetDvarFloatDefault( "scr_planeox", 30000.0 );
	oy = GetDvarFloatDefault( "scr_planeoy", 30000.0 );
	maxoX = GetDvarFloatDefault( "scr_maxo_planex", -1.0 );
	maxoY = GetDvarFloatDefault( "scr_maxo_planey", -1.0 );
	
	if (plane.angles[1] == 360)
		plane.angles = ( plane.angles[0], 0, plane.angles[2] );
				
	origX = plane.origin[0];
	origY = plane.origin[1];
	
	accumTurn = 0;
	looptime = 0.1;
	while( loopTime <= halflife )	
	{
		if (plane.angles[1] == 360)
			plane.angles = ( plane.angles[0], 0, plane.angles[2] );

		if ( minRoll != -1 && plane.angles[2] <= minRoll )	
			rollZ = 0.0;
			
		accumTurn += yawY;
		
		if ( accumTurn >= maxYaw )
		{
			yawY = 0.0;
		}
		plane.angles = ( plane.angles[0], plane.angles[1] + yawY, plane.angles[2] + rollZ);
		
			
		mathX = ( sin ( 45 * looptime / halflife ) ) * ox ;
		mathY = ( cos ( 45 * looptime / halflife ) ) * oy ;
		
		oldX = mathX;
		oldY = oy - mathY;

		rotatedX = Cos(yaw) * oldX - Sin(yaw) * oldY;
		rotatedY = Sin(yaw) * oldX + Cos(yaw) * oldY;
		
		//println( rotatedX + " " + rotatedY + "\n" );
		
		endPoint = ( origX + rotatedX, origY + rotatedY, plane.origin[2]);
		
		plane moveTo( endPoint, 0.1, 0, 0 );
		
		waitrealtime (0.1);	
		loopTime += 0.1;
	}
	
	yawY = GetDvarFloatDefault( "scr_planeyaw2", 0.6 );
	rollZ = GetDvarFloatDefault( "scr_planeroll2", -0.9 );
	
	ox = GetDvarFloatDefault( "scr_planeox", 30000.0 );
	oy = GetDvarFloatDefault( "scr_planeoy", 30000.0 );
	maxoX = GetDvarFloatDefault( "scr_maxo_planex", -1.0 );
	maxoY = GetDvarFloatDefault( "scr_maxo_planey", -1.0 );
	
	y = GetDvarFloatDefault( "scr_planey2", 0.6 );
	z = GetDvarFloatDefault( "scr_planez2", -1.5 );
	maxy = GetDvarFloatDefault( "scr_max_planey2", 90);
	
	accumTurn = 0;
	
	while( loopTime < halflife + halflife )	
	{
		if (plane.angles[1] == 360)
			plane.angles = ( plane.angles[0], 0, plane.angles[2] );

		if ( minRoll != -1 && plane.angles[2] >= 0 )	
			rollZ = 0.0;
			
		accumTurn += yawY;
		
		if ( accumTurn >= maxYaw )
		{
			yawY = 0.0;
		}
		
		plane.angles = ( plane.angles[0], plane.angles[1] + yawY, plane.angles[2] - rollZ);
		
			
		mathX = ( sin ( 45 * looptime / halflife ) ) * ox ;
		mathY = ( cos ( 45 * looptime / halflife ) ) * oy ;
		
		oldX = mathX;
		oldY = oy - mathY;

		rotatedX = Cos(yaw) * oldX - Sin(yaw) * oldY;
		rotatedY = Sin(yaw) * oldX + Cos(yaw) * oldY;
		
		endPoint = ( origX + rotatedX, origY + rotatedY, plane.origin[2]);
		
		plane moveTo( endPoint, 0.1, 0, 0 );
		
		waitrealtime (0.1);	
		loopTime += 0.1;
	}
	
	
}


planeTurnRight( plane, yaw, halflife )
{
	// X(0) is Pitch
	// Y(1) is Yaw
	// Z(2) is Roll!
	
	plane endon("delete");
	
	
	yawY = GetDvarFloatDefault( "scr_planeyaw", -0.6 );
	rollZ = GetDvarFloatDefault( "scr_planeroll", 1.5 );

	maxYaw = GetDvarFloatDefault( "scr_max_planeyaw", -45.0 );
	minRoll = GetDvarFloatDefault( "scr_min_planeroll", 60.0 );
	
	ox = GetDvarFloatDefault( "scr_planeox", 30000.0 );
	oy = GetDvarFloatDefault( "scr_planeoy", -30000.0 );
	maxoX = GetDvarFloatDefault( "scr_maxo_planex", -1.0 );
	maxoY = GetDvarFloatDefault( "scr_maxo_planey", -1.0 );
	
	if (plane.angles[1] == 360)
		plane.angles = ( plane.angles[0], 0, plane.angles[2] );
				
	origX = plane.origin[0];
	origY = plane.origin[1];
	
	accumTurn = 0;
	looptime = 0.1;
	while( loopTime <= halflife )	
	{
		if (plane.angles[1] == 360)
			plane.angles = ( plane.angles[0], 0, plane.angles[2] );

		if ( minRoll != -1 && plane.angles[2] >= minRoll )	
			rollZ = 0.0;
			
		accumTurn += yawY;
		
		if ( accumTurn <= maxYaw )
		{
			yawY = 0.0;
		}
		plane.angles = ( plane.angles[0], plane.angles[1] + yawY, plane.angles[2] + rollZ);
		
			
		mathX = ( sin ( 45 * looptime / halflife ) ) * ox ;
		mathY = ( cos ( 45 * looptime / halflife ) ) * oy ;
		
		oldX = mathX;
		oldY = oy - mathY;

		rotatedX = Cos(yaw) * oldX - Sin(yaw) * oldY;
		rotatedY = Sin(yaw) * oldX + Cos(yaw) * oldY;
		
		//println( rotatedX + " " + rotatedY + "\n" )
		
		/#println( rotatedX + " " + rotatedY + "\n" );#/
		
		endPoint = ( origX + rotatedX, origY + rotatedY, plane.origin[2]);
		
		plane moveTo( endPoint, 0.1, 0, 0 );
		
		waitrealtime (0.1);	
		loopTime += 0.1;
	}
	
	
	yawY = GetDvarFloatDefault( "scr_planeyaw2", 0.6 );
	rollZ = GetDvarFloatDefault( "scr_planeroll2", -0.9 );
	
	ox = GetDvarFloatDefault( "scr_planeox", 30000.0 );
	oy = GetDvarFloatDefault( "scr_planeoy", -30000.0 );
	maxoX = GetDvarFloatDefault( "scr_maxo_planex", -1.0 );
	maxoY = GetDvarFloatDefault( "scr_maxo_planey", -1.0 );
	
	y = GetDvarFloatDefault( "scr_planey2", 0.6 );
	z = GetDvarFloatDefault( "scr_planez2", -1.5 );
	maxy = GetDvarFloatDefault( "scr_max_planey2", 90);
	
	accumTurn = 0;
	
	while( loopTime < halflife + halflife )	
	{
		if (plane.angles[1] == 360)
			plane.angles = ( plane.angles[0], 0, plane.angles[2] );

		if ( minRoll != -1 && plane.angles[2] >= 0 )	
			rollZ = 0.0;
			
		accumTurn += yawY;
		
		if ( accumTurn >= maxYaw )
		{
			yawY = 0.0;
		}
		
		plane.angles = ( plane.angles[0], plane.angles[1] + yawY, plane.angles[2] - rollZ);
		
			
		mathX = ( sin ( 45 * looptime / halflife ) ) * ox ;
		mathY = ( cos ( 45 * looptime / halflife ) ) * oy ;
		
		oldX = mathX;
		oldY = oy - mathY;

		rotatedX = Cos(yaw) * oldX - Sin(yaw) * oldY;
		rotatedY = Sin(yaw) * oldX + Cos(yaw) * oldY;
		
		endPoint = ( origX + rotatedX, origY + rotatedY, plane.origin[2]);
		
		plane moveTo( endPoint, 0.1, 0, 0 );
		
		waitrealtime (0.1);	
		loopTime += 0.1;
	}
	
	
}

doABarrelRoll( plane, endPoint, time )
{
	plane endon("delete");
	
	plane moveTo( endPoint, time, 0, 0 );

	rollZ = GetDvarFloatDefault( "scr_barrelroll", 10 );
	degreesToRoll = GetDvarFloatDefault( "scr_degreesToRoll", 720 );
	
	degreesRolled = 0;
	while ( degreesRolled < degreesToRoll )
	{
		plane.angles = ( plane.angles[0], plane.angles[1], plane.angles[2] + rollZ);
		degreesRolled += rollZ;
		waitrealtime (0.01);
	}
}


planeGoStraight( plane, endPoint, time )
{
	plane endon("delete");
	plane moveTo( endPoint, time, 0, 0 );
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
		debugstar( origin, time, color );
	}
#/
}

