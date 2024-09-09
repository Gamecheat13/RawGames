#include maps\_utility;
#include maps\_shg_utility;


PM_ProjectVelocity( wishvel, normal )
{
	lenSq2d = LengthSquared( (wishvel[0], wishvel[1], 0) );
	if ( ( abs(normal[2]) < 0.001 ) || (lenSq2d <= 0.0001))
	{	// leave vel alone
	}
	else
	{
		newZ = -1*( wishvel[0]*normal[0] + wishvel[1]*normal[1] )/normal[2];
		adjusted = ( wishvel[0], wishvel[1], newZ);
		orgLenSq = lenSq2d + wishvel[2]*wishvel[2];
		adjLenSq = lenSq2d + newZ*newZ;
		lenScale = sqrt( orgLenSq/adjLenSq );
		if ( (lenScale < 1) || (newZ < 0) || (wishvel[2] > 0) )
			wishvel = lenScale*wishvel;
	}
	return wishvel;
}

PM_ClipVelocity( vel, normal )
{
	parallel = VectorDot( vel, normal );
	parallel -= (0.001)*abs(parallel); // keep 'out' just barely in the direction of 'normal'
	vel = vel - parallel*normal;
	return vel;
}

PM_PermuteRestrictiveClipPlanes( vel, planes, permutation )
{
	parallel = [];
	for (i=0; i<planes.size; i++)
	{
		parallel[i] = VectorDot( vel, planes[i] );
		for (permi = i; permi > 0; permi--)
		{
			if ( parallel[permutation[permi-1]] < parallel[i] )
				break;
			permutation[permi] = permutation[permi-1];
		}
		permutation[permi] = i;
	}
	ret["parallel"] = parallel[permutation[0]];
	ret["permutation"] = permutation;
	return ret;
}

PM_SlideMove( player, normal, gravity )
{
	numbumps = 4;
	primal_vel = player.vel;
	endVelocity = player.vel;
	time_left = 0.05;	// frametime
	planes[0] = normal;
	planes[1] = VectorNormalize(player.vel);
	permutation=[];
	for (bumpcount=0; bumpcount<numbumps; bumpcount++)
	{
		end = player.origin + time_left*player.vel;
		trace = PlayerPhysicsTraceInfo( player.origin, end );
		tend = trace["position"];
		normal = trace["normal"];
		fraction = trace["fraction"];
		if (fraction > 0)
			player.origin = tend;
		time_left -= time_left * fraction;
		if (planes.size >= 8)
		{
			player.vel = (0,0,0);
			return true;
		}
		//
		// if this is the same plane we hit before, nudge velocity
		// out along it, which fixes some epsilon issues with
		// non-axial planes
		//
		for ( i = 0; i < planes.size; i++ )
		{
			if ( VectorDot( normal, planes[i] ) > 0.999 )
			{
				player.vel = PM_ClipVelocity( player.vel, normal );
				player.vel = player.vel + trace["normal"];	// nudge away from the plane
				break;
			}
		}
		if (i < planes.size)
			continue;
		
		planes[planes.size] = normal;
		
		//
		// modify velocity so it parallels all of the clip planes
		//
		ret = PM_PermuteRestrictiveClipPlanes( player.vel, planes, permutation );
		into = ret["parallel"];
		permutation = ret["permutation"];
		if (into >= 0.1)
			continue;
		
		// slide along the plane
		clipVelocity = PM_ClipVelocity( player.vel, planes[permutation[0]] );
		
		// slide along the plane
		endClipVelocity = PM_ClipVelocity( endVelocity, planes[permutation[0]] );

		// see if there is a second plane that the new move enters
		for ( j = 1; j < planes.size; j++ )
		{
			if ( VectorDot( clipVelocity, planes[permutation[j]] ) >= 0.1 )
				continue; // move doesn't interact with the plane

			// try clipping the move to the plane
			clipVelocity = PM_ClipVelocity( clipVelocity, planes[permutation[j]] );
			endClipVelocity = PM_ClipVelocity( endClipVelocity, planes[permutation[j]] );

			// see if it goes back into the first clip plane
			if ( VectorDot( clipVelocity, planes[permutation[0]] ) >= 0 )
				continue;

			// slide the original velocity along the crease
			dir = VectorCross( planes[permutation[0]], planes[permutation[j]] );
			dir = VectorNormalize( dir );
			d = VectorDot( dir, player.vel );
			clipVelocity = d*dir;

			d = VectorDot( dir, endVelocity );
			endVelocity = d*dir;

			// see if there is a third plane the new move enters
			for ( k = 1; k < planes.size; k++ )
			{
				if ( k == j )
					continue;

				if ( VectorDot( clipVelocity, planes[permutation[k]] ) >= 0.1 )
					continue; // move doesn't interact with the plane

				// stop dead at a triple plane interaction
				player.vel = (0,0,0);
				return true;
			}
		}
		// if we have fixed all interactions, try another move
		player.velocity = clipVelocity;
		endVelocity = endClipVelocity;
	}
	if ( gravity )
		player.vel = endVelocity;

	return (bumpcount != 0);
}

Vec2Dot( a, b)
{
	return a[0]*b[0] + a[1]*b[1];
}

PM_StepSlideMove(player, normal, gravity)
{
	start_o = player.origin;
	start_v = player.vel;
	iBumps = PM_SlideMove( player, normal, gravity );
	stepsize = 18;	// use standing step
	_STEPSIZE = 18;	// this is a constant in the code
	bHadGround = true;	// force this for now
	
	down_o = player.origin;
	down_v = player.vel;
	flatDelta = down_o - start_o;
	fStepAmount = 0;
	
	if (iBumps || (normal[2] < 0.9))
	{
		up = start_o + (0,0,stepsize+1);	// 1 from STEPCLEARANCE
		trace = PlayerPhysicsTraceInfo( start_o, up );
		// figure out how far up we can go, and reduce it by 1 for better clearance
		fStepAmount = (trace["fraction"] * (stepSize+1)) - 1;
		// don't step if it'd be less than a 1 unit step
		if ( fStepAmount < 1.0 )
		{
			fStepAmount = 0;
		}
		else
		{
			// try slidemove from this position
			player.origin = (up[0], up[1], start_o[2] + fStepAmount);
			player.vel = start_v;

			// move along at the step height
			PM_SlideMove( player, normal, gravity );
		}
	}
	// if neither bHadGround or fStepAmount is set, the trace wouldn't go anywhere
	if ( bHadGround || fStepAmount )
	{
		// check for doing a step down
		down = player.origin - (0,0,fStepAmount);
		if ( bHadGround ) // allow additional step down if we were on the ground before
			down = down -(0,0, _STEPSIZE * 0.5);
		trace = PlayerPhysicsTraceInfo( player.origin, down );
		// usually a test for hitting other players here, that stops us
		if (trace["fraction"] < 1)
		{
			// usually a test for not walkable that also stops us and returns
			player.origin = trace["position"];
			if ( fStepAmount && (player.origin[2] - max( down_o[2], start_o[2] ) > 2.0 * stepsize * trace["normal"][2]) )
			{	// we tried to step but couldn't make it so stop where we are
				player.origin = down_o;
				player.vel = down_v;
				return;
			}
			player.vel = PM_ProjectVelocity( player.vel, trace["normal"] );
		}
		else if ( fStepAmount )
		{
			// move the player fStepAmount units back down
			player.origin = player.origin - (0,0,fStepAmount);
		}
	}
	stepDelta = player.origin - start_o;
	stepDelta = (stepDelta[0], stepDelta[1], 0);

	// if the step didn't move more than the straight dist, don't keep the step results
	// Don't use the step results if jumping and we'd go higher than our jump height allows

	stepMovedLess = (Vec2Dot( stepDelta, start_v ) <= Vec2Dot( flatDelta, start_v ) + 0.001);
	if ( stepMovedLess )
	{
		down_o = player.origin;
		down_v = player.vel;
		fStepAmount = 0;
		if ( bHadGround )
		{
			down = player.origin - (0,0,_STEPSIZE*0.5);
			trace = PlayerPhysicsTraceInfo( player.origin, down );

			// don't move the player down unless there's ground there
			if ( trace["fraction"] < 1.0 )
			{
				fStepAmount = trace["position"][2] - player.origin[2];
				player.origin = trace["position"];
				player.vel = PM_ClipVelocity( player.vel, trace["normal"] );
			}
		}
	}
	
}

