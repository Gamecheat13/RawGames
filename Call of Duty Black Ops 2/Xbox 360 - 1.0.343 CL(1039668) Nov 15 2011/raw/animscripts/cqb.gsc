#include animscripts\utility;
#include animscripts\combat_utility;
#include animscripts\shared;
#include common_scripts\utility;

#using_animtree ("generic_human");
shouldCQB()
{
	return self isCQB() && !IsDefined( self.grenade ) && !usingPistol();
}

//--------------------------------------------------------------------------------
// CQB Points of interest functionality
//--------------------------------------------------------------------------------
setupCQBPointsOfInterest()
{
	level.cqbPointsOfInterest = [];
	level.cqbSetupComplete = false;
	
	while( !IsDefined(level.struct_class_names) )
	{
		wait( 0.05 );
	}
	
	level.cqbSetupComplete = true;
	
	pointents = getEntArray( "cqb_point_of_interest", "targetname" );
	pointstructs = getstructarray( "cqb_point_of_interest", "targetname" );
	points = array_combine( pointents, pointstructs );
	for ( i = 0; i < points.size; i++ )
	{
		level.cqbPointsOfInterest[i] = points[i].origin;
		
				// TFLAME 4/30/10 - recent support for structs didn't account for not being able to delete a struct
		if (IsDefined (points[i].classname) && (points[i].classname == "script_origin" || points[i].classname == "script_model") )
		{
			points[i] delete();
		}
		
	}
}

findCQBPointsOfInterest()
{
	if ( IsDefined( anim.findingCQBPointsOfInterest ) )
	{
		return;
	}

	anim.findingCQBPointsOfInterest = true;
	
	while( !IsDefined( level.cqbSetupComplete ) || !level.cqbSetupComplete )
	{
		wait( 0.05 );
	}
	
	// one AI per frame, find best point of interest.
	if ( !level.cqbPointsOfInterest.size )
	{
		return;
	}
	
	while(1)
	{
		ai = GetAIArray();
		waited = false;

		for ( i = 0; i < ai.size; i++ )
		{
			if ( IsAlive( ai[i] ) && ai[i] isCQB() )
			{
				if( IsDefined( ai[i].avoidCQBPointsOfInterests ) &&  ai[i].avoidCQBPointsOfInterests )
				{
					continue;					
				}

				moving = ( ai[i].a.movement != "stop" );

				// if you change this, change the debug function below too
				shootAtPos = ai[i] GetShootAtPos();
				lookAheadPoint = shootAtPos;
				forward = AnglesToForward( ai[i].angles );
				if ( moving )
				{
					trace = bulletTrace( lookAheadPoint, lookAheadPoint + forward * 128, false, undefined );
					lookAheadPoint = trace["position"];
				}

				best = -1;
				bestdist = 1024*1024;
				for ( j = 0; j < level.cqbPointsOfInterest.size; j++ )
				{
					point = level.cqbPointsOfInterest[j];

					dist = DistanceSquared( point, lookAheadPoint );
					if ( dist < bestdist )
					{
						if ( moving )
						{
							if ( DistanceSquared( point, shootAtPos ) < 64 * 64 )
							{
								continue;
							}

							dot = vectorDot( VectorNormalize(point - shootAtPos), forward );
							if ( dot < 0.643 || dot > 0.966 ) // 0.643 = cos(50), 0.966 = cos(15)
							{
								continue;
							}
						}
						else
						{
							if ( dist < 50 * 50 )
							{
								continue;
							}
						}

						if ( !sightTracePassed( lookAheadPoint, point, false, undefined ) )
						{
							continue;
						}

						bestdist = dist;
						best = j;
					}
				}

				if ( best < 0 )
				{
					ai[i].cqb_point_of_interest = undefined;
				}
				else
				{
					ai[i].cqb_point_of_interest = level.cqbPointsOfInterest[best];
				}

				wait .05;
				waited = true;
			}
		}

		if ( !waited )
		{
			wait .25;
		}
	}
}

//--------------------------------------------------------------------------------
// CQB Debug
//--------------------------------------------------------------------------------
/#
CQBDebug()
{
	self notify("end_cqb_debug");
	self endon("end_cqb_debug");
	self endon("death");

	if ( GetDvar( "scr_cqbdebug") == "" )
	{
		SetDvar("scr_cqbdebug", "off");
	}

	level thread CQBDebugGlobal();

	while(1)
	{
		if ( GetDebugDvar("scr_cqbdebug") == "on" || getdebugdvarint("scr_cqbdebug") == self getentnum() )
		{
			if ( IsDefined( self.shootPos ) )
			{
				line( self GetShootAtPos(), self.shootPos, (1,1,1) );
				Print3d( self.shootPos, "shootPos", (1,1,1), 1, 0.5 );
				Record3DText( "cqb_target", self.shootPos + ( 0, 0, 20 ), (.5,1,.5), "Animscript" );		
			}
			else if ( IsDefined( self.cqb_target ) )
			{
				line( self GetShootAtPos(), self.cqb_target.origin, (.5,1,.5) );
				Print3d( self.cqb_target.origin, "cqb_target", (.5,1,.5), 1, 0.5 );
				Record3DText( "cqb_target", self.cqb_target.origin + ( 0, 0, 70 ), (.5,1,.5), "Animscript" );		
				
			}
			else
			{
				moving = ( self.a.movement != "stop" );

				forward = AnglesToForward( self.angles );
				shootAtPos = self GetShootAtPos();
				lookAheadPoint = shootAtPos;

				if ( moving )
				{
					lookAheadPoint += forward * 128;
					line( shootAtPos, lookAheadPoint, (0.7,.5,.5) );

					right = AnglesToRight( self.angles );
					leftScanArea  = shootAtPos + (forward * 0.643 - right) * 64;
					rightScanArea = shootAtPos + (forward * 0.643 + right) * 64;

					line( shootAtPos, leftScanArea, (0.5,0.5,0.5), 0.7 );
					recordLine( shootAtPos, leftScanArea, (0.5,0.5,0.5), "Animscript", self );

					line( shootAtPos, rightScanArea, (0.5,0.5,0.5), 0.7 );
					recordLine( shootAtPos, rightScanArea, (0.5,0.5,0.5), "Animscript", self );	
				}

				if ( IsDefined( self.cqb_point_of_interest ) )
				{
					line( lookAheadPoint, self.cqb_point_of_interest, (1,.5,.5) );
					Print3d( self.cqb_point_of_interest, "cqb_point_of_interest", (1,.5,.5), 1, 0.5 );
					Record3DText( "cqb_point_of_interest", self.cqb_point_of_interest, (1,.5,.5), "Animscript" );		
				}
			}

			wait .05;
			continue;
		}

		wait 1;
	}
}

CQBDebugGlobal()
{
	if ( IsDefined( level.cqbdebugglobal ) )
	{
		return;
	}

	level.cqbdebugglobal = true;
	
	while(1)
	{
		if ( GetDebugDvar("scr_cqbdebug") != "on" )
		{
			wait 1;
			continue;
		}
		
		for ( i = 0; i < level.cqbPointsOfInterest.size; i++ )
		{
			Print3d( level.cqbPointsOfInterest[i], ".", (.7,.7,1), .7, 3 );
		}
		
		wait .05;
	}
}
#/

