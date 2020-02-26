#include animscripts\utility;
#include animscripts\weaponList;
#include common_scripts\utility;
#include animscripts\combat_Utility;
#include animscripts\anims;
#include maps\_utility;

#insert raw\animscripts\utility.gsh;

// --------------------------------------------------------------------------------
// ---- AI behavior - React ----
//	Written by Sumeet Jakatdar
//	Standing AI can react to 6 different locations.
//  Running AI can react to two locations.
//	  right [|]   left
//		  ---|--- j_neck
//			|||	  j_mainroot
//			/|\	  tag_origin
// --------------------------------------------------------------------------------


#using_animtree ("generic_human");
main()
{
	self SetFlashBanged(false);

	// Stop flamethrower from shooting.
	self flamethrower_stop_shoot();
	
	// SUMEET_TODO - Hook up react dialogue
	//self animscripts\face::SayGenericDialogue("react");
		
 	self trackScriptState( "React Main", "code" );
    self notify ("anim entered react");
	self endon("killanimscript");
	
	animscripts\utility::initialize("react");
	self AnimMode("gravity");

	// try new enemy reaction first
	if( newEnemySurprisedReaction() )
		return;

	// Decide which animation to play
	reactAnim = getReactAnim();
	
/#
	if( GetDvarint( "scr_debugAiReactFeature") == 1 )
	{
		Record3DText( "going to react", self.origin + ( 0, 0, 70 ), ( 1, 1, 1 ), "Animscript" );
	}
#/
	
	// Play the react animation.
	if( IsDefined(reactAnim) )
	{
		playReactAnim( reactAnim );
	}
		
	return;
}



// --------------------------------------------------------------------------------
// ---- Init global/individual timers and other variables for once ------
// --------------------------------------------------------------------------------
reactGlobalsInit()
{
	reactInit();
	// REACTION_AI_TODO - Commented this out for now. We will look into this system next game
	//initializeReactionEventCBs();
	initReactTimers();
}

reactInit()
{
	anim.lastReactionTime	  = 0;		  // last time any AI reacted within 
	anim.reactionCoolDownTime = 3 * 1000; // for 3 sec nobody will react again.

	anim.reactionDistanceSquaredMax  = 1000 * 1000; // The attacker should be within 500 units to be able to see react.
	anim.reactionDistanceSquaredMin  = 100 * 100;   // The attacker should be outside 100 units to be able to see react.

	anim.reactionAwarenessDist = 32;     // distance between react origin and self origin for allies

	anim.nextReactionTimeForAIMin = 5 * 1000; // min range per AI's next reaction
	anim.nextReactionTimeForAIMax = 10 * 1000; // max range per AI's next reaction

}

// REACTION_AI_TODO - Commented this out for now. We will look into this system next game
//initializeReactionEventCBs()
//{
//	level.reactionEventCallbacks = [];
//	level.reactionEventCallbacks["death"][0] = ::eventDeathReact_v1;
//	level.reactionEventCallbacks["death"][1] = ::eventDeathReact_v2;
//	level.reactionEventCallbacks["death"][2] = ::eventDeathReact_v3;
//
////	level.reactionEventCallbacks["explosion"][0] = ::eventExploReact_v1;
////	level.reactionEventCallbacks["movement"][0] = ::eventMoveReact_v1;
//
//}


initReactTimers()
{
	self.a.newEnemyReactTime     = 0;
	self.a.eventReactionTime 	 = 0;
}

// --------------------------------------------------------------------------------
// ---- Functions to play the select react animation ------
// --------------------------------------------------------------------------------

playReactAnim( reactAnim )
{
	// set the time when this AI will be allowed to react next. Code has access to this timer.
	self.nextAllowedReactTime = GetTime() + RandomIntRange( anim.nextReactionTimeForAIMin, anim.nextReactionTimeForAIMax );
	
	if( IsPlayer( self.attacker ) && self.team == "allies" )
	{
		// I may end up adding some logic here.
	}
	else
	{
		// Update the last reaction global time
		anim.lastReactionTime = getTime();
	}

	self.a.pose = "stand";	
	self SetFlaggedAnimKnobAllRestart( "reactAnim", reactAnim, %body, 1, .1, 1 );
	
	if( animHasNotetrack( reactAnim, "start_aim" ) )
	{
		self thread notifyStartAim( "reactAnim" );
		self endon("start_aim");
	}
	
	self thread doReactNotetracks( "reactAnim" );

	// Early blendout to avoid pause into run
	reaction_blendout( reactAnim );
}

reaction_blendout( reactAnim )
{
	const blendouttime = 0.2;
	
	time = GetAnimLength( reactAnim );

	wait( time - blendouttime );
	
	// blend into next possible run cycle. this is to avoid a pop before going into 
	nextAnim = animscripts\run::GetRunAnim();

	// go back to run
	self ClearAnim( %body, 0.2 );
	self SetFlaggedAnimRestart( "run_anim", nextAnim, 1, blendouttime );
}


notifyStartAim( animFlag )
{
	self endon( "killanimscript" );
	self waittillmatch( animFlag, "start_aim" );
	self notify( "start_aim" );
}


// --------------------------------------------------------------------------------
// ---- Decide if AI can/should react to this event ------
// --------------------------------------------------------------------------------
shouldReact()
{

	Assert( IsDefined( self.reactOrigin ) );

/#
	// debug data
	self thread drawEventPointAndDir( self.reactorigin, undefined, (1,0,0) );	

	if(GetDvarint( "scr_forceAiReactFeature")) // This will ensure that this will not run in test map.
		return true;	
#/


	// AI will react if attacked by another "AI",	
	// 1. allowed to react.
	// 2. if the attacker is within anim.reactionDistance min and max range. 
	// 3. nobody reacted for anim.reactionCoolDownTime since the last reaction.
	// 4. a random chance 70%. 
	// 5. is not cqb walking
	// 6. AI can see the reaction origin

	// AI will only react if attacked by "player",
	// 1. allowed to react.
	// 2. AI can see the reaction origin
	// 3. Is not cqb walking
	// 4. if player shoots within 64 units from the AI
	// 5. if individual timers dont allow to react
	
	if(self.a.disableReact)
		return false;
	
	// flamethrower will not react
	if( weaponIsGasWeapon( self.weapon ) )
		return false;

	// no support for prone reactions
	if( self.a.pose == "prone" )
		return false;
	
	// SUMEET_TODO - Turn on the cover react animations, flinching in cover behavior is enough for now.
	// Ideally AI should not get here as AI is not put into react state if at cover in code, checked in code.
	if( IsDefined(self.coverNode) )
		return false;
	
	// see if this AI is set to ignoreall, only civilians are exempt
	if( self.ignoreall && ( !IsDefined( self.specialReact ) ) )
		return false;
			
	if( IsDefined( self.attacker ) && self.attacker IsVehicle() )
		return false;
		
	// don't want to go way off path
	if( self.a.script == "move" && self.lookaheaddist < 250 )
		return false;
	
	// if set then reaction will only happen while running
	if( IsDefined( self.a.runOnlyReact ) && self.a.runOnlyReact )
	{
		if( self.a.script != "move" )
			return false;
	}
	
	// no reactions while tactical walking
	if( self animscripts\run::ShouldTacticalWalk() )
		return false;
	
	// check if there's an animation available (some may be blocked)
	reactAnim = getReactAnim();
	if( !IsDefined( reactAnim ) )
		return false;
	
	// ALLIES ONLY
	// if attacker is player then higher chance to react.
	if( self.team == "allies" && IsDefined( self.attacker ) && IsPlayer( self.attacker  ) )
	{
		dist = DistanceSquared( self.attacker.origin, self.origin );

		// dist should be less than max and greater than min range.
		if( dist < anim.reactionDistanceSquaredMax && dist > anim.reactionDistanceSquaredMin )
		{
			if( DistanceSquared( self.reactOrigin, self.origin ) < 128 * 128 ) // special distance for friendlies
			{ 
				forwardVec = AnglesToForward(self.angles);
				dirToReactOrigin = VectorNormalize( self.reactOrigin - self.origin );
				
				isReactOriginFront = VectorDot( dirToReactOrigin, forwardVec ) >= 0; 
					
				if( isReactOriginFront && sightTracePassed( self getEye(), self.reactOrigin, false, undefined ) )
					return true;	
			}
		}
	}

	// Non player attacker logic
	if( ( anim.lastReactionTime == 0 ) || ( GetTime() > anim.lastReactionTime + anim.reactionCoolDownTime && ( RandomInt(100) > 40 ) ) )
	{		
		dist = DistanceSquared( self.attacker.origin, self.origin );

		// dist should be less than max and greater than min range.
		if( dist < anim.reactionDistanceSquaredMax && dist > anim.reactionDistanceSquaredMin )
		{
			if( sightTracePassed( self getEye(), self.reactOrigin, false, undefined ) )
			{
					return true;
			}
		}
	}

			
	return false;
}

// --------------------------------------------------------------------------------
// ---- Functions to select a react animation based on the current situation ------
// --------------------------------------------------------------------------------
getReactAnim() // self = AI
{

	reactAnim = undefined;
	location  = getEventLocationInfo();

/#
	// debug data
	self thread drawEventPointAndDir( self.reactorigin, location, (0,1,0) );	
#/
		
	friendlyReaction = ( self.team == "allies" && IsDefined( self.attacker ) && IsPlayer( self.attacker  ) );
	
	// running animation
	if( self.a.pose == "stand" && self.a.movement == "run" && (self getMotionAngle()<60) && (self getMotionAngle()>-60) )
	{
		reactAnim = getRunningForwardReactAnim( location, friendlyReaction );
		
		if( IsDefined( reactAnim ) )
			return reactAnim;	
	}
	
// SUMEET_TODO - removing stand reacts as it breaks AI shooting loop when it should not.	
// standing animation
//	if( !IsDefined( self.a.runOnlyReact ) || !self.a.runOnlyReact )
//	{
//		if( self.a.pose == "stand" || self.a.pose == "crouch" )
//		{
//			reactAnim = getReactAnimInternal( location );
//			
//			// explicitely set the movement of AI to Stop
//			self.a.movement = "stop";
//
//			if( IsDefined( reactAnim ) )
//				return reactAnim;	
//		}
//	}

	return reactAnim;
}

// --------------------------------------------------------------------------------
// ---- Exposed Reactions ------
// --------------------------------------------------------------------------------
getReactAnimInternal( location )
{

	// create a set of animation that AI can play in this case.
	reactArray = [];
	type = "exposed";

	reactArray[ reactArray.size ] = animArray( type + "_" + location, "react" );
			
	assert( reactArray.size > 0, reactArray.size );
	return reactArray[ RandomInt( reactArray.size ) ];
}

// --------------------------------------------------------------------------------
// ---- Running Reactions ------
// --------------------------------------------------------------------------------
getRunningForwardReactAnim( location, friendlyReaction )
{
	// create a set of animation that AI can play in this case.
	reactArray = [];
	type = "run";
	
	if( self.sprint )
		type = "sprint";
	
	if( IS_TRUE( friendlyReaction ) )
	{
		reactArray[ reactArray.size ] = animArray( type + "_lower_torso_stop", "react" );
	}
	else
	{
		if( IsSubStr( location, "upper" ) || IsSubStr( location, "head" ) )
		{
			reactArray[ reactArray.size ] = animArray( type + "_head", "react" );
		}
		else 
		{
			if( coinToss() )
				reactArray[ reactArray.size ] = animArray( type + "_lower_torso_fast", "react" );
			else
				reactArray[ reactArray.size ] = animArray( type + "_lower_torso_stop", "react" );
		}
	}
	
	// remove any animation that cant be played because of geo
	reactArray = removeBlockedAnims( reactArray );
	
	if( reactArray.size > 0 )
		return reactArray[ RandomInt( reactArray.size ) ];
	else
		return undefined;
}

// --------------------------------------------------------------------------------
// ---- Functions to calculate the react event location info ----
// --------------------------------------------------------------------------------
getEventLocationInfo()
{
	Assert( IsDefined( self.reactorigin ) );
	
	// Decide the area to react to based on the event origin.
	position_info = calculateLocationInfo( self.reactorigin );
	
	return position_info;
}


calculateLocationInfo( point )
{
	// try to find if bullet is on left or right
	direction = getPointDirection( point );

	// distance from neck to ground
	pos = self GetTagOrigin("j_neck");
	tag_neck_dist = distanceFromTagOrigin( pos );

	// distance from pelvis to ground
	pos = self GetTagOrigin("j_mainroot");
	tag_main_root_dist = distanceFromTagOrigin( pos );

	// calculate vertical distance of point from ground.
	point_dist = distanceFromTagOrigin( ( self.origin[0], self.origin[1], point[2] ) );

	// three regions, each region divided into two, either left or right
	if( point_dist < tag_main_root_dist )
	{
		// lower torso
		location = direction + "_lower_torso";
	}
	else if( point_dist < tag_neck_dist )
	{
		// upper torso and below neck
		location = direction + "_upper_torso";
	}
	else
	{
		// above nect near head
		location = direction + "_head";
	}

	return location;
}

// decide point location, left or right
getPointDirection( point )
{
	closestPointDir = ( point - self.origin );
	forwardDir = AnglesToRight( self.angles );

	dotProduct = VectorDot( forwardDir, closestPointDir );

	if( dotProduct > 0 )
	{
		side = "right";
	}
	else
	{
		side = "left";	
	}

	return side;
}

distanceFromTagOrigin( org )
{
	return DistanceSquared( self.origin, org );
}


// --------------------------------------------------------------------------------
// ---- Animations utility functions ----
// --------------------------------------------------------------------------------
removeBlockedAnims( array )
{
	newArray = [];
	for ( index = 0; index < array.size; index++ )
	{
		localDeltaVector = getMoveDelta( array[index], 0, 1 );
		endPoint = self localToWorldCoords( localDeltaVector );

		if ( self mayMoveToPoint( endPoint ) )
		{
			newArray[newArray.size] = array[index];
		}
	}

	return newArray;
}

doReactNotetracks( flagName )
{
	self notify("stop_DoNotetracks");

	self endon("killanimscript");
	self endon("death");
	self endon("stop_DoNotetracks");

	self animscripts\shared::DoNoteTracks( flagName );
}


// --------------------------------------------------------------------------------
// ---- New enemy reactions ------
// --------------------------------------------------------------------------------

canReactToNewEnemyAgain()
{	
	if( !IsDefined( self.a.newEnemyReactTime ) )
		return true;

	return ( !self.a.newEnemyReactTime || GetTime() - self.a.newEnemyReactTime > 2000 );
}

newEnemyReactionAnim()
{
	self endon( "death" );
	self endon( "endNewEnemyReactionAnim" );

	self.a.newEnemyReactTime = GetTime();

	reactAnim = self getNewEnemyReactionAnim();

	// failsafe
	if( !IsDefined( reactAnim ) )
		return false;

	self clearanim( %root, 0.2 );
	self setFlaggedAnimKnobRestart( "reactanim", reactAnim, 1, 0.2, 1 );
	self animscripts\shared::DoNoteTracks( "reactanim" );

	self notify( "newEnemyReactionDone" );

	return true;
}


getNewEnemyReactionAnim()
{
	reactAnim = undefined;

	// cover new enemy
	if ( self NearClaimNodeAndAngle() )
	{
		if( !animArrayAnyExist( self.a.prevScript + "_ne" ) )
			return reactAnim;
			
		nodeForward = AnglesToForward( self.node.angles );
		dirToReactionTarget = VectorNormalize( self.newEnemyReactionPos - self.origin );

		if ( vectorDot( nodeForward, dirToReactionTarget ) < -0.5 )
		{
			self orientmode( "face current" );
			reactAnim = AnimArrayPickRandom( self.a.prevScript + "_ne" );
		}
	}

	// exposed new enemy
	if ( !IsDefined( reactAnim ) )
	{
		reactAnimArray =  animArray( "combat_ne" );

		if ( isdefined( self.enemy ) && distanceSquared( self.enemy.origin, self.newEnemyReactionPos ) < 256 * 256 )
			self orientmode( "face enemy" );
		else
			self orientmode( "face point", self.newEnemyReactionPos );

		if ( self.a.pose == "crouch" )
		{
			dirToReactionTarget = vectorNormalize( self.newEnemyReactionPos - self.origin );
			forward = anglesToForward( self.angles );
			if ( vectorDot( forward, dirToReactionTarget ) < -0.5 )
			{
				self orientmode( "face current" );
				reactAnimArray = animArray( "cover_crouch_ne" );
			}
		}

		reactAnim = reactAnimArray[ randomint( reactAnimArray.size ) ];
	}

	return reactAnim;
}


newEnemySurprisedReaction()
{
	self endon( "death" );

	if ( isdefined( self.a.disableReact ) && self.a.disableReact )
		return false;		

	if ( self weaponAnims() == "pistol" )
		return false;
		
	if( !self.newenemyreaction )
		return false;

	if ( !canReactToNewEnemyAgain() )
		return false;

	if ( self.a.pose == "prone" || self.a.pose == "back" )
		return false;

	self animmode( "gravity" );

	if ( isdefined( self.enemy ) )
		return newEnemyReactionAnim();
}


//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}

// --------------------------------------------------------------------------------
// ---- Debug functions ----
// --------------------------------------------------------------------------------

/#

drawEventPointAndDir( position, location, color )
{
	self endon("death");

	current_time = GetTime();


	if(!GetDvarint( "scr_debugAiReactFeature")) // This will ensure that this will not run in test map.
		return;	

	if( IsDefined( location ) )
	{		
		recordEntText( "Location - " + location, self, level.color_debug["white"], "Animscript" );
	}
	
	while(1)
	{
		drawDebugCross( position, 1, color, .05 );
	
		if( GetTime() - current_time > 2 * 1000 )
		{
			break;
		}
	
		wait(0.05);
	}
}


debugLine( fromPoint, toPoint, color, durationFrames )
{
	self endon("death");

	for (i=0;i<durationFrames*20;i++)
	{
		line (fromPoint, toPoint, color);
		recordLine( fromPoint, toPoint, color, "Animscript", self );
		wait (0.05);
	}
}


drawDebugCross(atPoint, radius, color, durationFrames)
{
	self endon("death");

	atPoint_high =		atPoint + (		0,			0,		   radius	);
	atPoint_low =		atPoint + (		0,			0,		-1*radius	);
	atPoint_left =		atPoint + (		0,		   radius,		0		);
	atPoint_right =		atPoint + (		0,		-1*radius,		0		);
	atPoint_forward =	atPoint + (   radius,		0,			0		);
	atPoint_back =		atPoint + (-1*radius,		0,			0		);
	thread debugLine(atPoint_high,	atPoint_low,	color, durationFrames);
	thread debugLine(atPoint_left,	atPoint_right,	color, durationFrames);
	thread debugLine(atPoint_forward,	atPoint_back,	color, durationFrames);
}

#/

//--------------------------------------------------------------------------------
// event reactions "Dynamic Vignette System"
// REACTION_AI_TODO - Commented this out for now. We will look into this system next game
//--------------------------------------------------------------------------------
//getAvailableNearbyAI(fromOrigin, maxDistSq, maxTeamMembers, team, ignore )
//{
//	members = [];
//	
//	ai = GetAIArray(team);
//	for (i=0; i<ai.size; i++)
//	{
//		if (members.size >= maxTeamMembers )
//		{
//			break;
//		}
//		if ( ai[i] == ignore )
//		{
//			continue;
//		}
//		if( !(ai[i] animscripts\react::canReactToNewEventAgain()) ) 
//		{
//			continue;
//		}
//		distSq = lengthsquared( fromOrigin - ai[i].origin );
//		if ( distSq < maxDistSq )
//		{
//			members[members.size] = ai[i];
//		}
//	}
//	
//	return members;
//}
//
//getNearbyPerformanceAI(type)
//{
//	ai = [];
//	switch(type)
//	{
//		case "death":
//			ai = getAvailableNearbyAI(self.a.eventReactionSpot, 256*256, 3, self.team, self );
//		break;
//	}
//	for (i=0;i<ai.size;i++)
//	{
//		ai[i].a.eventReactionParticipant = GetTime();  //this timer will temporarily block others from reacting on this frame as they're being considered for "support performance" (i.e. in another AI's eventReactionNearbyAI list)
//	}
//	
//	return ai;
//}
//
////PARAMETER CLEANUP
//eventDeathReact_v1_AI2(/*dyingEnt*/)
//{
//	//do something cool
//	self.a.eventReactionTime = GetTime();
//	self.a.reactionEventInProgress = true;
//	wait 5;	
//	self eventReactionEnd();
//}
////PARAMETER CLEANUP
//eventDeathReact_v1_AI1(/*dyingEnt*/)
//{
//	//do something cool
//	self.a.eventReactionTime = GetTime();
//	self.a.reactionEventInProgress = true;
//	wait 5;	
//	self eventReactionEnd();
//}
////PARAMETER CLEANUP
//eventDeathReact_v1_AI0(/*dyingEnt*/)
//{
//	//do something cool
//	self.a.eventReactionTime = GetTime();
//	self.a.reactionEventInProgress = true;
//	wait 5;	
//	self eventReactionEnd();
//}
//eventDeathReact_v1_SELF()
//{
//	self notify("eventReaction");
//	self endon("eventReaction");
//	self endon("death");
//	
//	self.a.eventReactionTime = GetTime();
//	self.a.reactionEventInProgress = true;
//
//	nodeForward = anglesToForward( self.coverNode.angles );
//	dirToReactionTarget = vectorNormalize( self.a.eventReactionSpot - self.origin );
//
//	// IK
//	if( GetDvar( "reaction_influence_ik" ) == "1" )
//	{
//		reactAnim = animArrayPickRandom( "death_react_ik" );
//		relax_ik_headtracking_limits();
//		self LookAtPos( self.a.eventReactionSpot );
//	}
//	else // NON-IK
//	{
//		// orient towards the dead teammate if not in general front direction
//		if ( vectorDot( nodeForward, dirToReactionTarget ) > -0.5 )
//			self orientmode( "face point", self.a.eventReactionSpot );
//
//		reactAnim = animArrayPickRandom( "death_react" );
//	}
//	
//	self SetFlaggedAnimKnobAllRestart( "deathreactanim", reactAnim, %body, 1, 0.2, 1 );
//	self animscripts\shared::DoNoteTracks( "deathreactanim" );
//}
//
//eventDeathReact_v1()
//{
//	//PARAMETER CLEANUP
////	dyingEnt = self.a.eventReactionEnt;
//
//	switch (self.a.eventReactionNearbyAI.size)
//	{	//no breaks
//		case 3: 
//			//do something with self.a.eventReactionNearbyAI[2]
//			self.a.eventReactionNearbyAI[2] thread eventDeathReact_v1_AI2(/*dyingEnt*/);
//		case 2:
//			//do something with self.a.eventReactionNearbyAI[1]
//			self.a.eventReactionNearbyAI[1] thread eventDeathReact_v1_AI1(/*dyingEnt*/);
//		case 1: 
//			//do something with self.a.eventReactionNearbyAI[0]
//			//Perform Rambo manuever on dyningEnt's enemy;
//			self.a.eventReactionNearbyAI[0] thread eventDeathReact_v1_AI0(/*dyingEnt*/);
//		default:
//			//default reaction
//			//do something with self
//			self thread eventDeathReact_v1_SELF();
//		break;
//	}
//}
//eventDeathReact_v2()
//{
//	eventDeathReact_v1();
///*	
//	switch (self.a.eventReactionNearbyAI.size)
//	{	//no breaks
//		case 3: 
//			//do something with self.a.eventReactionNearbyAI[2]
//			self.a.eventReactionNearbyAI[2] thread eventDeathReact_v2_AI2(dyingEnt);
//		case 2:
//			//do something with self.a.eventReactionNearbyAI[1]
//			self.a.eventReactionNearbyAI[1] thread eventDeathReact_v2_AI1(dyingEnt);
//		case 1: 
//			//do something with self.a.eventReactionNearbyAI[0]
//			//Perform Rambo manuever on dyningEnt's enemy;
//			self.a.eventReactionNearbyAI[0] thread eventDeathReact_v2_AI0(dyingEnt);
//		default:
//			//default reaction
//			//do something with self
//			self thread eventDeathReact_v2_SELF();
//		break;
//	}
//*/	
//}
//eventDeathReact_v3()
//{
//	eventDeathReact_v1();
///*	
//	switch (self.a.eventReactionNearbyAI.size)
//	{	//no breaks
//		case 3: 
//			//do something with self.a.eventReactionNearbyAI[2]
//			self.a.eventReactionNearbyAI[2] thread eventDeathReact_v3_AI2(dyingEnt);
//		case 2:
//			//do something with self.a.eventReactionNearbyAI[1]
//			self.a.eventReactionNearbyAI[1] thread eventDeathReact_v3_AI1(dyingEnt);
//		case 1: 
//			//do something with self.a.eventReactionNearbyAI[0]
//			//Perform Rambo manuever on dyningEnt's enemy;
//			self.a.eventReactionNearbyAI[0] thread eventDeathReact_v3_AI0(dyingEnt);
//		default:
//			//default reaction
//			//do something with self
//			self thread eventDeathReact_v3_SELF();
//		break;
//	}
//*/	
//}
//canReactToNewEventAgain()
//{	
//	if( IsDefined( self.a.reactionEventInProgress ) && self.a.reactionEventInProgress )
//		return false;
//
//	if ( isDefined( self.a.eventReactionParticipant ) )//This guy is being considered for participation in larger Dynamic Vignette.  We will return false for 1 tick to allow the selection process to fully complete.
//	{
//		if ( self.a.eventReactionParticipant == GetTime() )
//		{
//			return false;
//		}
//		else
//		{
//			self.a.eventReactionParticipant = undefined;
//		}	
//	}
//
//	if ( Isdefined( self.enemy ) && DistanceSquared( self.enemy.origin, self.origin ) < 64 * 64 )
//		return false;
//
//	if( !IsDefined( self.coverNode ) )
//		return false;
//
//	if( self.coverNode.type != "Cover Left" && self.coverNode.type != "Cover Right" && self.coverNode.type != "Cover Crouch" )
//		return false;
//
//	if( self.a.pose == "prone" )
//		return false;
//
//	if( !IsDefined( self.a.eventReactionTime ) )
//		return true;
//
//	return ( GetTime() - self.a.eventReactionTime > anim.reactionCoolDownTime );
//}
//
//eventReactionEnd()
//{
//	restore_ik_headtracking_limits();
//	self LookAtPos();
//	self.a.eventReactionSpot	   = undefined;
//	self.a.eventReactionEnt		   = undefined;
//	self.a.eventReactionTarget	   = undefined;
//	self.a.eventReactionParticipant= undefined;
//	self.a.reactionEventInProgress = false;	
//}
