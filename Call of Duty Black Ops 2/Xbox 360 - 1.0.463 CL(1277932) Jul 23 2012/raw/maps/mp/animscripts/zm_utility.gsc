#include maps\mp\animscripts\shared;
#include maps\mp\animscripts\utility;



append_missing_legs_suffix( animstate )
{
	if ( isdefined( self.has_legs ) && !self.has_legs && self HasAnimStateFromASD( animstate + "_crawl" ) )
	{
		return animstate + "_crawl";
	}

	return animstate;
}


// Every script calls initAnimTree to ensure a clean, fresh, known animtree state.  
// ClearAnim should never be called directly, and this should never occur other than
// at the start of an animscript
// This function now also does any initialization for the scripts that needs to happen 
// at the beginning of every main script.
initAnimTree(animscript)
{
//t6todo2 	self ClearAnim( %body, 0.2 );
	//self SetAnim( %body, 1, 0 );	// The %body node should always have weight 1.
	
	if ( animscript != "pain" && animscript != "death" )
	{
		self.a.special = "none";
	}
	
	self.missedSightChecks = 0;
	
	IsInCombat();
	
	assert( IsDefined( animscript ), "Animscript not specified in initAnimTree" );
	self.a.script = animscript;
	
	// Call the handler to get out of Cowering pose.
	[[self.a.StopCowering]]();
}

// UpdateAnimPose does housekeeping at the start of every script's main function. 
UpdateAnimPose()
{
	assert( self.a.movement=="stop" || self.a.movement=="walk" || self.a.movement=="run", "UpdateAnimPose "+self.a.pose+" "+self.a.movement );
	
	self.desired_anim_pose = undefined;
}

initialize( animscript )
{
	if ( IsDefined( self.longDeathStarting ) )
	{
		if ( animscript != "pain" && animscript != "death" )
		{
			// we probably just came out of an animcustom.
			// just die, it's not safe to do anything else
			self DoDamage( self.health + 100, self.origin );
		}
		if ( animscript != "pain" )
		{
			self.longDeathStarting = undefined;
			self notify( "kill_long_death" );
		}
	}
	if ( IsDefined( self.a.mayOnlyDie ) && animscript != "death" )
	{
		// we probably just came out of an animcustom.
		// just die, it's not safe to do anything else
		self DoDamage( self.health + 100, self.origin );
	}

	// scripts can define this to allow cleanup before moving on
	if ( IsDefined( self.a.postScriptFunc ) )
	{
		scriptFunc = self.a.postScriptFunc;
		self.a.postScriptFunc = undefined;

		[[scriptFunc]]( animscript );
	}

	if ( animscript != "death" )
	{
		self.a.nodeath = false;
	}
	
	self.isHoldingGrenade = undefined;

	self.coverNode = undefined;
	self.changingCoverPos = false;
	self.a.scriptStartTime = GetTime();
	
	self.a.atConcealmentNode = false;
	if ( IsDefined( self.node ) && (self.node.type == "Conceal Crouch" || self.node.type == "Conceal Stand") )
	{
		self.a.atConcealmentNode = true;
	}
	
	initAnimTree( animscript );

	UpdateAnimPose();
}

// Returns whether or not the character should be acting like he's under fire or expecting an enemy to appear 
// any second.
IsInCombat()
{
	if ( isValidEnemy( self.enemy ) )
	{
		self.a.combatEndTime = GetTime() + anim.combatMemoryTimeConst + RandomInt(anim.combatMemoryTimeRand);
		return true;
	}

	return ( self.a.combatEndTime > GetTime() );
}

GetNodeYawToOrigin(pos)
{
	if (IsDefined (self.node))
	{
		yaw = self.node.angles[1] - GetYaw(pos);
	}
	else
	{
		yaw = self.angles[1] - GetYaw(pos);
	}
	
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetNodeYawToEnemy()
{
	pos = undefined;
	if ( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		if (IsDefined (self.node))
		{
			forward = AnglesToForward(self.node.angles);
		}
		else
		{
			forward = AnglesToForward(self.angles);
		}

		forward = VectorScale (forward, 150);
		pos = self.origin + forward;
	}
	
	if (IsDefined (self.node))
	{
		yaw = self.node.angles[1] - GetYaw(pos);
	}
	else
	{
		yaw = self.angles[1] - GetYaw(pos);
	}

	yaw = AngleClamp180( yaw );
	return yaw;
}

GetCoverNodeYawToEnemy()
{
	pos = undefined;
	if ( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = AnglesToForward(self.coverNode.angles + self.animarray["angle_step_out"][self.a.cornerMode]);
		forward = VectorScale (forward, 150);
		pos = self.origin + forward;
	}
	
	yaw = self.CoverNode.angles[1] + self.animarray["angle_step_out"][self.a.cornerMode] - GetYaw(pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetYawToSpot(spot)
{
	pos = spot;
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}
// warning! returns (my yaw - yaw to enemy) instead of (yaw to enemy - my yaw)
GetYawToEnemy()
{
	pos = undefined;
	if ( isValidEnemy( self.enemy ) )
	{
		pos = self.enemy.origin;
	}
	else
	{
		forward = AnglesToForward(self.angles);
		forward = VectorScale (forward, 150);
		pos = self.origin + forward;
	}
	
	yaw = self.angles[1] - GetYaw(pos);
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}

GetYaw2d(org)
{
	angles = VectorToAngles((org[0], org[1], 0)-(self.origin[0], self.origin[1], 0));
	return angles[1];
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy()
{
	assert( isValidEnemy( self.enemy ) );
	
	yaw = self.angles[1] - GetYaw(self.enemy.origin);
	yaw = AngleClamp180( yaw );
	
	if (yaw < 0)
	{
		yaw = -1 * yaw;
	}

	return yaw;
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToEnemy2d()
{
	assert( isValidEnemy( self.enemy ) );

	yaw = self.angles[1] - GetYaw2d(self.enemy.origin);
	yaw = AngleClamp180( yaw );

	if (yaw < 0)
	{
		yaw = -1 * yaw;
	}

	return yaw;
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
AbsYawToOrigin(org)
{
	yaw = self.angles[1] - GetYaw(org);
	yaw = AngleClamp180( yaw );

	if (yaw < 0)
	{
		yaw = -1 * yaw;
	}

	return yaw;
}

AbsYawToAngles(angles)
{
	yaw = self.angles[1] - angles;
	yaw = AngleClamp180( yaw );

	if (yaw < 0)
	{
		yaw = -1 * yaw;
	}

	return yaw;
}

GetYawFromOrigin(org, start)
{
	angles = VectorToAngles(org-start);
	return angles[1];
}

GetYawToTag(tag, org)
{
	yaw = self GetTagAngles( tag )[1] - GetYawFromOrigin(org, self GetTagOrigin(tag));
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetYawToOrigin(org)
{
	yaw = self.angles[1] - GetYaw(org);
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetEyeYawToOrigin(org)
{
	yaw = self GetTagAngles("TAG_EYE")[1] - GetYaw(org);
	yaw = AngleClamp180( yaw );
	return yaw;
}

GetCoverNodeYawToOrigin(org)
{
	yaw = self.coverNode.angles[1] + self.animarray["angle_step_out"][self.a.cornerMode] - GetYaw(org);
	yaw = AngleClamp180( yaw );
	return yaw;
}


isStanceAllowedWrapper( stance )
{
	if ( IsDefined( self.coverNode ) )
	{
		return self.coverNode doesNodeAllowStance( stance );
	}

	return self IsStanceAllowed( stance );
}


GetClaimedNode()
{
	myNode = self.node;
	if ( IsDefined(myNode) && (self nearNode(myNode) || (IsDefined( self.coverNode ) && myNode == self.coverNode)) )
	{
		return myNode;
	}

	return undefined;
}

GetNodeType()
{
	myNode = GetClaimedNode();
	if (IsDefined(myNode))
	{
		return myNode.type;
	}

	return "none";
}

GetNodeDirection()
{
	myNode = GetClaimedNode();
	if (IsDefined(myNode))
	{
		//thread [[anim.println]]("GetNodeDirection found node, returned: "+myNode.angles[1]);#/
		return myNode.angles[1];
	}
	//thread [[anim.println]]("GetNodeDirection didn't find node, returned: "+self.desiredAngle);#/
	return self.desiredAngle;
}

GetNodeForward()
{
	myNode = GetClaimedNode();
	if (IsDefined(myNode))
	{
		return AnglesToForward ( myNode.angles );
	}

	return AnglesToForward( self.angles );
}

GetNodeOrigin()
{
	myNode = GetClaimedNode();
	if (IsDefined(myNode))
	{
		return myNode.origin;
	}

	return self.origin;
}

safemod(a,b)
{
	/*
	Here are some modulus results from in-game:
	10 % 3 = 1
	10 % -3 = 1
	-10 % 3 = -1
	-10 % -3 = -1
	however, we never want a negative result.
	*/
	result = int(a) % b;
	result += b;
	return result % b;
}

// Gives the result as an angle between 0 and 360
AngleClamp( angle )
{
	angleFrac = angle / 360.0;
	angle = (angleFrac - floor( angleFrac )) * 360.0;
	return angle;
}

// Returns an array of 4 weights (2 of which are guaranteed to be 0), which should be applied to forward, 
// right, back and left animations to get the angle specified.
//           front
//        /----|----\
//       /    180    \
//      /\     |     /\
//     / -135  |  135  \
//     |     \ | /     |
// left|-90----+----90-|right
//     |     / | \     |
//     \  -45  |  45   /
//      \/     |     \/
//       \     0     / 
//        \----|----/
//           back

QuadrantAnimWeights( yaw )
{
	// ALEXP 6/26/09: I don't understand why they'd want trig interpolation between angles instead of linear
	//forwardWeight = cos( yaw );
	//leftWeight    = sin( yaw );

	forwardWeight	= (90 - abs(yaw)) / 90;
	leftWeight		= (90 - AbsAngleClamp180(abs(yaw-90))) / 90;

	result["front"]	= 0;
	result["right"]	= 0;
	result["back"]	= 0;
	result["left"]	= 0;
	
	if ( IsDefined( self.alwaysRunForward ) )
	{
		assert( self.alwaysRunForward ); // always set alwaysRunForward to either true or undefined.
		
		result["front"] = 1;
		return result;
	}

	useLeans = GetDvarInt( "ai_useLeanRunAnimations");

	if (forwardWeight > 0)
	{
		result["front"] = forwardWeight;
		
		if (leftWeight > 0)
		{
			result["left"] = leftWeight;
		}
		else
		{
			result["right"] = -1 * leftWeight;
		}
	}
	else if( useLeans )
	{
		result["back"] = -1 * forwardWeight;
		if (leftWeight > 0)
		{
			result["left"] = leftWeight;
		}
		else
		{
			result["right"] = -1 * leftWeight;
		}
	}
	else //cod4 back strafe
	{
		// if moving backwards, don't blend.
		// it looks horrible because the feet cycle in the opposite direction.
		// either way, feet slide, but this looks better.
		backWeight = -1 * forwardWeight;
		if ( leftWeight > backWeight )
		{
			result["left"] = 1;
		}
		else if ( leftWeight < forwardWeight )
		{
			result["right"] = 1;
		}
		else
		{
			result["back"] = 1;
		}
	}


	return result;
}

getQuadrant(angle)
{
	angle = AngleClamp(angle);

	if (angle<45 || angle>315)
	{
		quadrant = "front";
	}
	else if (angle<135)
	{
		quadrant = "left";
	}
	else if (angle<225)
	{
		quadrant = "back";
	}
	else
	{
		quadrant = "right";
	}
	return quadrant;
}


// Checks to see if the input is equal to any of up to ten other inputs.
IsInSet(input, set)
{
	for (i = set.size - 1; i >= 0; i--)
	{
		if (input == set[i])
		{
			return true;
		}
	}

	return false;
}

playAnim(animation)
{
	if (IsDefined(animation))
	{
		//self thread drawString(animation);	// Doesn't work for animations, only strings.
	/#	println ("NOW PLAYING: ",animation);	#/
//t6todo2		self SetFlaggedAnimKnobAllRestart("playAnim", animation, %root, 1, .2, 1);
		timeToWait = getanimlength(animation);
		timeToWait = ( 3 * timeToWait ) + 1;	// So looping animations play through 3 times.
		self thread NotifyAfterTime("time is up", "time is up", timeToWait);
		self waittill ("time is up");
		self notify("enddrawstring");
	}
}

NotifyAfterTime(notifyString, killmestring, time)
{
	self endon("death");
	self endon(killmestring);
	wait time;
	self notify (notifyString);
}

// Utility function, made for MilestoneAnims(), which displays a string until killed.
drawString(stringtodraw)
{
	/* t6todo
	self endon("killanimscript");
	self endon("enddrawstring");
	for (;;)
	{
		wait .05;
		Print3d ((self GetDebugEye()) + (0,0,8), stringtodraw, (1, 1, 1), 1, 0.2);
	}
	*/
}

drawStringTime(msg, org, color, timer)
{
	/#
	maxtime = timer*20;
	for (i=0;i<maxtime;i++)
	{
		Print3d (org, msg, color, 1, 1);
		wait .05;
	}
	#/
}

showLastEnemySightPos(string)
{
	/#
	self notify ("got known enemy2");
	self endon ("got known enemy2");
	self endon ("death");

	if ( !isValidEnemy( self.enemy ) )
	{
		return;
	}
		
	if (self.enemy.team == "allies")
	{
		color = (0.4, 0.7, 1);
	}
	else
	{
		color = (1, 0.7, 0.4);
	}
		
	while (1)
	{
		wait (0.05);
		
		if (!IsDefined (self.lastEnemySightPos))
		{
			continue;
		}
			
		Print3d (self.lastEnemySightPos, string, color, 1, 2.15);	// origin, text, RGB, alpha, scale
	}
	#/
}

debugTimeout()
{
	wait(5);
	self notify ("timeout");
}

debugPosInternal( org, string, size )
{
	/#
	self endon ("death");
	self notify ("stop debug " + org);
	self endon ("stop debug " + org);
	
	ent = SpawnStruct();
	ent thread debugTimeout();
	ent endon ("timeout");
	
	if (self.enemy.team == "allies")
	{
		color = (0.4, 0.7, 1);
	}
	else
	{
		color = (1, 0.7, 0.4);
	}
		
	while (1)
	{
		wait (0.05);
		Print3d (org, string, color, 1, size);	// origin, text, RGB, alpha, scale
	}
	#/
}

debugPos( org, string )
{
	thread debugPosInternal( org, string, 2.15 );
}

debugPosSize( org, string, size )
{
	thread debugPosInternal( org, string, size );
}

showDebugProc(fromPoint, toPoint, color, printTime)
{
	/#
	self endon ("death");
//	self notify ("stop debugline " + self.export);
//	self endon ("stop debugline " + self.export);

	timer = printTime*20;
	for (i=0;i<timer;i+=1)
	{
		wait (0.05);
		line (fromPoint, toPoint, color);
	}
	#/
}

showDebugLine( fromPoint, toPoint, color, printTime )
{
	self thread showDebugProc( fromPoint, toPoint +( 0, 0, -5 ), color, printTime );
}

getNodeOffset(node)
{
	if ( IsDefined( node.offset ) )
	{
		return node.offset;
	}

	//(right offset, forward offset, vertical offset)
	// you can get an actor's current eye offset by setting scr_eyeoffset to his entnum.
	// this should be redone whenever animations change significantly.
	cover_left_crouch_offset = 	(-26, .4, 36);
	cover_left_stand_offset = 	(-32, 7, 63);
	cover_right_crouch_offset = (43.5, 11, 36);
	cover_right_stand_offset = 	(36, 8.3, 63);
	cover_crouch_offset = 		(3.5, -12.5, 45); // maybe we could account for the fact that in cover crouch he can stand if he needs to?
	cover_stand_offset = 		(-3.7, -22, 63);

	cornernode = false;
	nodeOffset = (0,0,0);
	
	right = AnglesToRight(node.angles);
	forward = AnglesToForward(node.angles);

	switch(node.type)
	{
	case "Cover Left":
	case "Cover Left Wide":
		if ( node isNodeDontStand() && !node isNodeDontCrouch() )
		{
			nodeOffset = calculateNodeOffset( right, forward, cover_left_crouch_offset );
		}
		else
		{
			nodeOffset = calculateNodeOffset( right, forward, cover_left_stand_offset );
		}
		break;

	case "Cover Right":
	case "Cover Right Wide":
		if ( node isNodeDontStand() && !node isNodeDontCrouch() )
		{
			nodeOffset = calculateNodeOffset( right, forward, cover_right_crouch_offset );
		}
		else
		{
			nodeOffset = calculateNodeOffset( right, forward, cover_right_stand_offset );
		}
		break;

	case "Cover Stand":
	case "Conceal Stand":
	case "Turret":
		nodeOffset = calculateNodeOffset( right, forward, cover_stand_offset );
		break;

	case "Cover Crouch":
	case "Cover Crouch Window":
	case "Conceal Crouch":
		nodeOffset = calculateNodeOffset( right, forward, cover_crouch_offset );
		break;
	}

	node.offset = nodeOffset;
	return node.offset;
}

calculateNodeOffset( right, forward, baseoffset )
{
	return VectorScale( right, baseoffset[0] ) + VectorScale( forward, baseoffset[1] ) + (0, 0, baseoffset[2]);
}

checkPitchVisibility( fromPoint, toPoint, atNode )
{
	// check vertical angle is within our aiming abilities
	
	pitch = AngleClamp180( VectorToAngles( toPoint - fromPoint )[0] );
	if ( abs( pitch ) > 45 )
	{
		if ( IsDefined( atNode ) && atNode.type != "Cover Crouch" && atNode.type != "Conceal Crouch" )
		{
			return false;
		}

		if ( pitch > 45 || pitch < anim.coverCrouchLeanPitch - 45 )
		{
			return false;
		}
	}
	return true;
}

showLines(start, end, end2)
{
	/#
	for (;;)
	{
		line(start, end, (1,0,0), 1);
		wait (0.05);
		line(start, end2, (0,0,1), 1);
		wait (0.05);
	}
	#/
}

// Returns an animation from an array of animations with a corresponding array of weights.
anim_array(animArray, animWeights)
{
	total_anims = animArray.size;
	idleanim = RandomInt(total_anims);
	
	assert (total_anims);
	assert (animArray.size == animWeights.size);
	
	if (total_anims == 1)
	{
		return animArray[0];
	}
		
	weights = 0;
	total_weight = 0;
	
	for (i = 0; i < total_anims; i++)
	{
		total_weight += animWeights[i];
	}
	
	anim_play = RandomFloat(total_weight);
	current_weight	= 0;
	
	for (i = 0; i < total_anims; i++)
	{
		current_weight += animWeights[i];
		if (anim_play >= current_weight)
		{
			continue;
		}

		idleanim = i;
		break;
	}
	
	return animArray[idleanim];
}		

notForcedCover()
{
	return ((self.a.forced_cover == "none") || (self.a.forced_cover == "Show"));
} 

forcedCover(msg)
{
	return IsDefined(self.a.forced_cover) && (self.a.forced_cover == msg);
} 

print3dtime(timer, org, msg, color, alpha, scale)
{
	/#
	newtime = timer / 0.05;
	for (i=0;i<newtime;i++)
	{
		Print3d (org, msg, color, alpha, scale);
		wait (0.05);
	}
	#/
}

print3drise (org, msg, color, alpha, scale)
{
	/#
	newtime = 5 / 0.05;
	up = 0;
	org = org;

	for (i=0;i<newtime;i++)
	{
		up+=0.5;
		Print3d (org + (0,0,up), msg, color, alpha, scale);
		wait (0.05);
	}
	#/
}

crossproduct (vec1, vec2)
{
	return (vec1[0]*vec2[1] - vec1[1]*vec2[0] > 0);
}

scriptChange()
{
	self.a.current_script = "none";
	self notify (anim.scriptChange);
}

delayedScriptChange()
{
	wait (0.05);
	scriptChange();
}

getGrenadeModel()
{
	return getWeaponModel(self.grenadeweapon);
}

sawEnemyMove(timer)
{
	if (!IsDefined(timer))
	{
		timer = 500;
	}

	return (GetTime() - self.personalSightTime < timer);
}

canThrowGrenade()
{
	if (!self.grenadeAmmo)
	{
		return false;
	}
	
	if (self.script_forceGrenade)
	{
		return true;
	}
		
	return (IsPlayer(self.enemy));
}

random_weight (array)
{
	idleanim = RandomInt (array.size);
	if (array.size > 1)
	{
		anim_weight = 0;
		for (i=0;i<array.size;i++)
		{
			anim_weight += array[i];
		}
		
		anim_play = RandomFloat (anim_weight);
		
		anim_weight = 0;
		for (i=0;i<array.size;i++)
		{
			anim_weight += array[i];
			if (anim_play < anim_weight)
			{
				idleanim = i;
				break;
			}
		}
	}
	
	return idleanim;
}		

setFootstepEffect(name, fx)
{
	assert(IsDefined(name), "Need to define the footstep surface type.");
	assert(IsDefined(fx), "Need to define the mud footstep effect.");

	if (!IsDefined(anim.optionalStepEffects))
	{
		anim.optionalStepEffects = [];
	}

	anim.optionalStepEffects[anim.optionalStepEffects.size] = name;
	level._effect["step_" + name] = fx;
	anim.optionalStepEffectFunction = maps\mp\animscripts\zm_shared::playFootStepEffect;
}

persistentDebugLine(start, end)
{
	/#
	self endon ("death");
	level notify ("newdebugline");
	level endon ("newdebugline");
	
	for (;;)
	{
		line (start,end, (0.3,1,0), 1);
		wait (0.05);
	}
	#/
}

isNodeDontStand()
{
	return (self.spawnflags & 4) == 4;
}
isNodeDontCrouch()
{
	return (self.spawnflags & 8) == 8;
}

doesNodeAllowStance( stance )
{
	if ( stance == "stand" )
	{
		return !self isNodeDontStand();
	}
	else
	{
		Assert( stance == "crouch" );
		return !self isNodeDontCrouch();
	}
}

animArray( animname ) /* string */ 
{
	//println( "playing anim: ", animname );

	assert( IsDefined(self.a.array) );

	/#
	if ( !IsDefined(self.a.array[animname]) )
	{
		dumpAnimArray();
		assert( IsDefined(self.a.array[animname]), "self.a.array[ \"" + animname + "\" ] is undefined" );
	}
	#/

	return self.a.array[animname];
}

animArrayAnyExist( animname )
{
	assert( IsDefined( self.a.array ) );

	/#
	if ( !IsDefined(self.a.array[animname]) )
	{
		dumpAnimArray();
		assert( IsDefined(self.a.array[animname]), "self.a.array[ \"" + animname + "\" ] is undefined"  );
	}
	#/
	
	return self.a.array[animname].size > 0;
}

animArrayPickRandom( animname )
{
	assert( IsDefined( self.a.array ) );

	/#
	if ( !IsDefined(self.a.array[animname]) )
	{
		dumpAnimArray();
		assert( IsDefined(self.a.array[animname]), "self.a.array[ \"" + animname + "\" ] is undefined"  );
	}
	#/

	assert( self.a.array[animname].size > 0 );
	
	if ( self.a.array[animname].size > 1 )
	{
		index = RandomInt( self.a.array[animname].size );
	}
	else
	{
		index = 0;
	}

	return self.a.array[animname][index];
}

/#
dumpAnimArray()
{
	println("self.a.array:");
	keys = getArrayKeys( self.a.array );

	for ( i=0; i < keys.size; i++ )
	{
		if ( isarray( self.a.array[ keys[i] ] ) )
		{
			println( " array[ \"" + keys[i] + "\" ] = {array of size " + self.a.array[ keys[i] ].size + "}" );
		}
		else
		{
			println( " array[ \"" + keys[i] + "\" ] = ", self.a.array[ keys[i] ] );
		}
	}
}
#/

getAnimEndPos( theanim )
{
	moveDelta = getMoveDelta( theanim, 0, 1 );
	return self localToWorldCoords( moveDelta );
}

isValidEnemy( enemy )
{
	if ( !IsDefined( enemy ) )
	{
		return false;
	}
	
	return true;
}


damageLocationIsAny( a, b, c, d, e, f, g, h, i, j, k, ovr )
{
	/* possibile self.damageLocation's:
		"torso_upper"
		"torso_lower"
		"helmet"
		"head"
		"neck"
		"left_arm_upper"
		"left_arm_lower"
		"left_hand"
		"right_arm_upper"
		"right_arm_lower"
		"right_hand"
		"gun"
		"none"
		"left_leg_upper"
		"left_leg_lower"
		"left_foot"
		"right_leg_upper"
		"right_leg_lower"
		"right_foot"
	*/

	if ( !IsDefined( a ) ) return false; if ( self.damageLocation == a ) return true;
	if ( !IsDefined( b ) ) return false; if ( self.damageLocation == b ) return true;
	if ( !IsDefined( c ) ) return false; if ( self.damageLocation == c ) return true;
	if ( !IsDefined( d ) ) return false; if ( self.damageLocation == d ) return true;
	if ( !IsDefined( e ) ) return false; if ( self.damageLocation == e ) return true;
	if ( !IsDefined( f ) ) return false; if ( self.damageLocation == f ) return true;
	if ( !IsDefined( g ) ) return false; if ( self.damageLocation == g ) return true;
	if( !IsDefined( h ) ) return false; if( self.damageLocation == h ) return true;
	if( !IsDefined( i ) ) return false; if( self.damageLocation == i ) return true;
	if( !IsDefined( j ) ) return false; if( self.damageLocation == j ) return true;
	if( !IsDefined( k ) ) return false; if( self.damageLocation == k ) return true;
	assert(!IsDefined(ovr));
	return false;
}

ragdollDeath( moveAnim )
{
	self endon ( "killanimscript" );
	
	lastOrg = self.origin;
	moveVec = (0,0,0);

	for ( ;; )
	{
		wait ( 0.05 );
		force = distance( self.origin, lastOrg );
		lastOrg = self.origin;

		if ( self.health == 1 )
		{
			self.a.nodeath = true;
			self startRagdoll();
//t6todo2			self ClearAnim( moveAnim, 0.1 );
			wait ( 0.05 );
			physicsExplosionSphere( lastOrg, 600, 0, force * 0.1 );
			self notify ( "killanimscript" );
			return;
		}
		
	}
}

isCQBWalking()
{
	return IsDefined( self.cqbwalking ) && self.cqbwalking;
}

squared( value )
{
	return value * value;
}

randomizeIdleSet()
{
	self.a.idleSet = RandomInt( 2 );
}

// meant to be used with any integer seed, for a small integer maximum (ideally one that divides anim.randomIntTableSize)
getRandomIntFromSeed( intSeed, intMax )
{
	assert( intMax > 0 );

	index = intSeed % anim.randomIntTableSize;
	return anim.randomIntTable[ index ] % intMax;
}

// MikeD (1/24/2008): Added Banzai Feature.
is_banzai()
{
	return IsDefined( self.banzai ) && self.banzai;
}

// SCRIPTER_MOD: JesseS (4/16/2008): HMG guys have their own anims
is_heavy_machine_gun()
{
	return IsDefined( self.heavy_machine_gunner ) && self.heavy_machine_gunner;
}

is_zombie()
{
	if (IsDefined(self.is_zombie) && self.is_zombie)
	{
		return true;
	}

	return false;
}


is_civilian()
{
	if (IsDefined(self.is_civilian) && self.is_civilian)
	{
		return true;
	}

	return false;
}

// CODER_MOD: Austin (7/21/08): added to prevent zombies from gibbing more than once
is_zombie_gibbed()
{
	return ( self is_zombie() && self.gibbed );
}

// CODER_MOD: Austin (7/21/08): added to prevent zombies from gibbing more than once
set_zombie_gibbed()
{
	if ( self is_zombie() )
	{
		self.gibbed = true;
	}
}

is_skeleton(skeleton)
{
	if ((skeleton == "base") && IsSubStr(get_skeleton(), "scaled"))
	{
		// Scaled skeletons should identify as "base" as well
		return true;
	}

	return (get_skeleton() == skeleton);
}

get_skeleton()
{
	if (IsDefined(self.skeleton))
	{
		return self.skeleton;
	}
	else
	{
		return "base";
	}
}

debug_anim_print( text )
{
/#		
	if ( IsDefined( level.dog_debug_anims ) && level.dog_debug_anims  )
		println( text+ " " + getTime() );

	if ( IsDefined( level.dog_debug_anims_ent ) && level.dog_debug_anims_ent == self getentnum() )
		println( text+ " " + getTime() );
#/
}

debug_turn_print( text, line )
{
/#		
	if ( IsDefined( level.dog_debug_turns ) && level.dog_debug_turns == self getentnum() )
	{
		duration = 200;
		currentYawColor = (1,1,1);
		lookaheadYawColor = (1,0,0);
		desiredYawColor = (1,1,0);
	
		currentYaw = AngleClamp180(self.angles[1]);
		desiredYaw = AngleClamp180(self.desiredangle);
		lookaheadDir = self.lookaheaddir;
		lookaheadAngles = vectortoangles(lookaheadDir);
		lookaheadYaw = AngleClamp180(lookaheadAngles[1]);
			println( text+ " " + getTime() + " cur: " + currentYaw + " look: " + lookaheadYaw + " desired: " + desiredYaw );
	}
#/
}



/@
"Name: wait_network_frame()"
"Summary: Wait until a snapshot is acknowledged.  Can help control having too many spawns in one frame."
"Module: Utility"
"Example: wait_network_frame();"
"SPMP: singleplayer"
@/ 
wait_network_frame()
{
	if ( NumRemoteClients() )
	{
		snapshot_ids = getsnapshotindexarray();

		acked = undefined;
		while ( !IsDefined( acked ) )
		{
			level waittill( "snapacknowledged" );
			acked = snapshotacknowledged( snapshot_ids );
		} 
	}
	else
	{
		wait(0.1);
	}
}