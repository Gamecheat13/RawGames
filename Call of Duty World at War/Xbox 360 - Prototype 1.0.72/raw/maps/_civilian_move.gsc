#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_civilian;
#include maps\_civilian_idle;

waittillSpeedSet()
{
	self endon ( "civilian_death" );
	while( !isdefined( self.speed ) )
		wait 0.05;
}

#using_animtree( "civilian" );
civilian_loop_moveAnims( anime )
{
	self civilian_prepare_for_animation();
	assert( isdefined( level.scr_anim[self.animname][anime] ) );
	assert( level.scr_anim[self.animname][anime].size > 0 );
	
	if ( isdefined( self.current_move_anim ) )
		self clearanim( self.current_move_anim, 0 );
	
	self endon ( "stop_civilian_move_anim" );
	self endon ( "civilian_death" );
	
	blendTime = 1.0;
	for (;;)
	{
		loopanime = undefined;
		if (0 == 1)
			loopanime = anime + "_react";
		else
			loopanime = anime;
		assert( isdefined( loopanime ) );
		rand = randomint( level.scr_anim[self.animname][loopanime].size );
		self.current_move_anim = level.scr_anim[self.animname][loopanime][rand]["anim"];
		assert( isdefined( level.scr_anim[self.animname][loopanime][rand]["speed"] ) );
		self.speed = level.scr_anim[self.animname][loopanime][rand]["speed"];
		animTime = self getAnimTime( self.current_move_anim );
		if ( animTime < blendTime )
			blendTime = (animTime / 2);
		self SetFlaggedAnimKnobAllRestart( "loop_anim_done", self.current_move_anim, %root, 1.0, blendTime, 1.0 );
		self waittillmatch ( "loop_anim_done", "end" );
		self clearanim( self.current_move_anim, 0 );
	}
}

MoveChain( destinationPoint, vecArray )
{
	usingNodes = true;
	if ( !isdefined( destinationPoint ) )
		usingNodes = false;
	
	self notify ( "moving_civilian" );
	self endon ( "moving_civilian" );
	self endon ( "civilian_death" );
	
	//stop the character from doing his idle
	self notify ( "civilian_stop_idle" );
	self stopAnimScripted();
	
	//ToDo: Make it support a script_struct targeting multiple script_structs so it can randomly use one
	
	
	//Create the lookahead point that the character will face and move towards
	//------------------------------------------------------------------------
	lookaheadPoint = setInitialLookaheadPoint();
	
	if ( usingNodes )
	{
		//Get array of chained nodes - starting with the characters current location
		//--------------------------------------------------------------------------
		nodes = getPathArray( destinationPoint, undefined, self.origin );
	}
	else
	{
		assert( isdefined( vecArray ) );
		assert( isdefined( vecArray[0] ) );
		
		//Get array of nodes from the vectors - starting with the characters current location
		//-----------------------------------------------------------------------------------
		nodes = getPathArray( undefined, vecArray, self.origin );
	}
	
	assert( isdefined( nodes ) );
	assert( isdefined( nodes[0] ) );
	
	prof_begin( "civilian_math" );
	
	loopTime = 0.5;
	
	currentNode_LookAhead = 0;
	for (;;)
	{
		if ( !isdefined( nodes[currentNode_LookAhead] ) )
			break;
		
		
		//Calculate how far and what direction the lookahead path point should move
		//-------------------------------------------------------------------------
		//find point on real path where character is
		vec1 = nodes[currentNode_LookAhead]["vec"];
		vec2 = ( self.origin - nodes[currentNode_LookAhead]["origin"] );
		distanceFromPoint1 = vectorDot( vectorNormalize( vec1 ), vec2 );
		
		//check if this is the last node (wont have a distance value)
		if ( !isdefined( nodes[currentNode_LookAhead]["dist"] ) )
			break;
		
		lookaheadDistanceFromNode = ( distanceFromPoint1 + level.civilian_lookAhead_value );
		assert( isdefined( lookaheadDistanceFromNode ) );
		
		assert( isdefined( currentNode_LookAhead ) );
		assert( isdefined( nodes[currentNode_LookAhead] ) );
		assert( isdefined( nodes[currentNode_LookAhead]["dist"] ) );
		
		while ( lookaheadDistanceFromNode > nodes[currentNode_LookAhead]["dist"] )
		{
			//moving the lookahead would pass the node, so move it the remaining distance on the vector of the next node
			lookaheadDistanceFromNode = lookaheadDistanceFromNode - nodes[currentNode_LookAhead]["dist"];
			currentNode_LookAhead++;
			
			if( !isdefined( nodes[currentNode_LookAhead]["dist"] ) )
			{
				//last node on the chain
				self rotateTo( vectorToAngles( nodes[nodes.size -1]["vec"] ), loopTime );
				d = distance( self.origin, nodes[nodes.size -1]["origin"] );
				timeOfMove = (d / self.speed);
				moveToDest = physicstrace( nodes[nodes.size -1]["origin"] + ( 0, 0, level.traceHeight ), nodes[nodes.size -1]["origin"] - ( 0, 0, level.traceHeight ) );
				self moveTo( moveToDest, timeOfMove );
				wait timeOfMove;
				self notify ( "goal" );
				self notify ( "civilian_idle" );
				prof_end( "civilian_math" );
				return;
			}
			
			if ( !isdefined( nodes[currentNode_LookAhead] ) )
			{
				prof_end( "civilian_math" );
				self notify ( "goal" );
				self notify ( "civilian_idle" );
				return;
			}
			
			assert( isdefined( nodes[currentNode_LookAhead] ) );
		}
		//-------------------------------------------------------------------------
		
		
		//Move the lookahead point down along it's path
		//---------------------------------------------
		assert( isdefined( nodes[currentNode_LookAhead]["vec"] ) );
		assert( isdefined( nodes[currentNode_LookAhead]["vec"][0] ) );
		assert( isdefined( nodes[currentNode_LookAhead]["vec"][1] ) );
		assert( isdefined( nodes[currentNode_LookAhead]["vec"][2] ) );
		desiredPosition = vectorScale ( nodes[currentNode_LookAhead]["vec"], lookaheadDistanceFromNode);
		desiredPosition = desiredPosition + nodes[currentNode_LookAhead]["origin"];
		lookaheadPoint = desiredPosition;
		//trace the lookahead point to the ground
		lookaheadPoint = physicstrace( lookaheadPoint + ( 0, 0, level.traceHeight ), lookaheadPoint - ( 0, 0, level.traceHeight ) );
		if ( getdvar( "debug_civilians" ) == "1" )
		{
			thread debug_line( undefined, lookaheadPoint, 10, (1,0,0) );
			iprintln ( lookaheadDistanceFromNode + "/" + nodes[currentNode_LookAhead]["dist"] + " units forward from node[" + currentNode_LookAhead + "]" );
		}
		//---------------------------------------------
		
		
		//Rotate character to face the lookahead point
		//--------------------------------------------
		assert( isdefined ( lookaheadPoint ) );
		characterFaceDirection = VectorToAngles( lookaheadPoint - self.origin );
		assert( isdefined( characterFaceDirection ) );
		assert( isdefined( characterFaceDirection[0] ) );
		assert( isdefined( characterFaceDirection[1] ) );
		assert( isdefined( characterFaceDirection[2] ) );
		self rotateTo( ( 0, characterFaceDirection[1], 0 ), loopTime );
		//--------------------------------------------
		
		
		//Move the character in the direction of the lookahead point
		//----------------------------------------------------------
		characterDistanceToMove = (self.speed * loopTime);
		moveVec = vectorNormalize( lookaheadPoint - self.origin );
		desiredPosition = vectorScale ( moveVec, characterDistanceToMove );
		desiredPosition = desiredPosition + self.origin;
		if ( getdvar( "debug_civilians" ) == "1" )
			thread debug_line( undefined, desiredPosition, 10, (0,0,1) );
		self moveTo( desiredPosition, loopTime );
		//----------------------------------------------------------
		
		
		wait loopTime;
	}
	
	prof_end( "civilian_math" );
	self notify ( "goal" );
	self notify ( "civilian_idle" );
}

getPathArray( firstTargetName, vecArray, initialPoint )
{
	//#########################################################################################################
	//make an array of all the points along the spline
	//starting with the characters current position, then starting with the point with the passed in targetname
	//
	//	information stored in array:
	//
	//	origin - origin of the node
	//	dist - distance to the next node (will be undefined if there is not a next node)
	//	vec	- vector to the next node (if there is not a next node, the vector will be the same as the previous node)
	//
	//#########################################################################################################
	
	usingNodes = true;
	if ( !isdefined( firstTargetName ) )
	{
		usingNodes = false;
		assert( isdefined( vecArray ) );
		assert( isdefined( vecArray[0] ) );
	}
	
	prof_begin("civilian_math");
	
	assert(isdefined(initialPoint));
	
	nodes = [];
	nodes[0]["origin"] = initialPoint;
	nodes[0]["dist"] = 0;
	
	nextNodeName = undefined;
	vecArrayIndex = undefined;
	if ( usingNodes )
		nextNodeName = firstTargetName;
	else
		vecArrayIndex = 0;
	
	for (;;)
	{
		index = nodes.size;
		
		//get the next node in the chain
		node = undefined;
		if ( usingNodes )
		{
			node = getstruct( nextNodeName, "targetname" );
			
			//no script_struct was found
			if (!isdefined(node))
			{
				if (index == 0)
					assertMsg( "Civilian was told to walk to a node with a targetname that doesnt match a script_struct targetname" );
				break;
			}
		}
		
		//add this node information to the chain data array
		if ( usingNodes )
			nodes[index]["origin"] = node.origin;
		else
		{
			if (!isdefined(vecArray[vecArrayIndex]))
			{
				if ( vecArrayIndex == 0 )
					assertMsg( "Civilian was told to walk to an undefined vecArray" );
				break;
			}
			nodes[index]["origin"] = vecArray[vecArrayIndex];
		}
		
		//find the distance from the previous node to this node, and the vector of of the previous node to this node
		//then add the info to the previous nodes data
		nodes[index - 1]["dist"] = distance( nodes[index]["origin"], nodes[index - 1]["origin"] );
		nodes[index - 1]["vec"] = vectorNormalize( nodes[index]["origin"] - nodes[index - 1]["origin"] );
		
		if ( usingNodes )
		{
			//if the node doesn't target another node then it's the last of the chain
			if (!isdefined(node.target))
				break;
			//it targets something
			nextNodeName = node.target;
		}
		else
		{
			//last vector in array, we're all done adding the points
			if ( vecArrayIndex >= vecArray.size - 1 )
				break;
			vecArrayIndex++;
		}
		
	}
	
	nodes[index]["vec"] = nodes[index - 1]["vec"];
	
	node = undefined;
	
	prof_end("civilian_math");
	
	return nodes;
}

setInitialLookaheadPoint()
{
	prof_begin("civilian_math");
	
	//set the initial lookaheadPoint value
	//initial value is 'level.civilian_lookAhead_value' units straight ahead of the character
	forward = anglestoforward( self.angles );
	lookaheadPoint = vectorScale ( forward, level.civilian_lookAhead_value );
	lookaheadPoint = lookaheadPoint + self.origin;
	if ( getdvar( "debug_civilians" ) == "1" )
		thread debug_line( undefined, lookaheadPoint, 10 );
	
	prof_end("civilian_math");
	
	return lookaheadPoint;
}

Vec3Mad( character_origin, speed, lookDir )
{
	prof_begin("civilian_math");
	
	result = [];
	result[0] = character_origin[0] + speed * lookDir[0];
	result[1] = character_origin[1] + speed * lookDir[1];
	result[2] = character_origin[2] + speed * lookDir[2];
	
	prof_end("civilian_math");
	
	return result;
}

debug_line( pointA, pointB, duration, color )
{
	if (!isdefined(color))
		color = (0,0,0);
	
	usePlayerOrigin = false;
	if (!isdefined(pointA))
		usePlayerOrigin = true;
	
	for ( i = 0; i < (duration * 20) ; i++ )
	{
		if (usePlayerOrigin)
			pointA = level.player.origin;
		line ( pointA, pointB, color );
		if ( getdvar( "debug_civilians" ) == "2" )
			iprintln ( distance ( level.player.origin, pointB ) );
		wait 0.05;
	}
}