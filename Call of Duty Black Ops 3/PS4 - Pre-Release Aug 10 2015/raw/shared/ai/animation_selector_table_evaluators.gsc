#using scripts\shared\ai\systems\animation_selector_table;
#using scripts\shared\array_shared;

           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

function autoexec RegisterASTScriptFunctions()
{
	AnimationSelectorTable::RegisterAnimationSelectorTableEvaluator("testFunction",&testFunction);;
	
	// ------- EVALUATOR BLOCKED BY GEO ANIMATIONS -----------//
	AnimationSelectorTable::RegisterAnimationSelectorTableEvaluator("evaluateBlockedAnimations",&evaluateBlockedAnimations);;
	
	// ------- EVALUATOR HUMAN LOCOMOTION TURNS -----------//
	AnimationSelectorTable::RegisterAnimationSelectorTableEvaluator("evaluateHumanTurnAnimations",&evaluateHumanTurnAnimations);;
	
	// ------- EVALUATOR HUMAN EXPOSED ARRIVALS -----------//
	AnimationSelectorTable::RegisterAnimationSelectorTableEvaluator("evaluateHumanExposedArrivalAnimations",&evaluateHumanExposedArrivalAnimations);;
}

function testFunction( entity, animations )
{
	if ( IsArray( animations ) && animations.size > 0 )
	{
		return animations[0];
	}
}

function private Evaluator_CheckAnimationAgainstGeo( entity, animation )
{
	PixBeginEvent( "Evaluator_CheckAnimationAgainstGeo" );

	assert( IsActor( entity ) );	
	
	// Since this check is mostly used for turn animations, a better approximation
	// of movement is to use the midpoint position of the animation and the end
	// point of the animation.
	localDeltaHalfVector = GetMoveDelta( animation, 0, 0.5, entity );
	midPoint = entity LocalToWorldCoords( localDeltaHalfVector );
	// ignore any Z translation.
	midPoint = ( midPoint[0], midPoint[1], entity.origin[2] );
	
	/#
	RecordLine( entity.origin, midPoint, ( 1, .5, 0 ), "Animscript", entity );
	#/
	
	if( entity MayMoveToPoint( midPoint, true, true ) )
	{
		localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
		endPoint = entity LocalToWorldCoords( localDeltaVector );
		endPoint = ( endPoint[0], endPoint[1], entity.origin[2] );
		
		/#
		RecordLine( midPoint, endPoint, ( 1, .5, 0 ), "Animscript", entity );
		#/
		
		if ( entity MayMoveFromPointToPoint( midPoint, endPoint, true, true ) )
		{
			PixEndEvent();
			return true;
		}
	}
	
	PixEndEvent();
	return false;
}

function private Evaluator_CheckAnimationEndPointAgainstGeo( entity, animation )
{
	PixBeginEvent( "Evaluator_CheckAnimationEndPointAgainstGeo" );

	assert( IsActor( entity ) );	
	
	localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
	endPoint = entity LocalToWorldCoords( localDeltaVector );
	endPoint = ( endPoint[0], endPoint[1], entity.origin[2] );
	
	if( entity MayMoveToPoint( endPoint, false, false ) )
	{
		PixEndEvent();
		return true;
	}
	
	PixEndEvent();
	return false;
}

function private Evaluator_CheckAnimationForOverShootingGoal( entity, animation )
{	
	PixBeginEvent( "Evaluator_CheckAnimationForOverShootingGoal" );

	assert( IsActor( entity ) );		
		
	localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
	endPoint 		 = entity LocalToWorldCoords( localDeltaVector );
	animDistSq 		 = LengthSquared( localDeltaVector );
	
	if( entity HasPath() )
	{
		startPos = entity.origin;	
		goalPos  = entity.pathGoalPos;
		
		assert( IsDefined( goalPos ) );
		distToGoalSq = DistanceSquared( startPos, goalPos );
					
		// goal is straight in front of the AI, just make sure that the endpoint is not beyond the goal position
		if( animDistSq < distToGoalSq )
		{
			PixEndEvent();
			return true;
		}
	}
	
	PixEndEvent();
	return false;
}

function private Evaluator_CheckAnimationAgainstNavmesh( entity, animation )
{
	assert( IsActor( entity ) );
	
	localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
	endPoint 		 = entity LocalToWorldCoords( localDeltaVector );

	// make sure that the point is on the navmesh and away from boundary
	if( IsPointOnNavMesh( endPoint, entity ) )
		return true;
	
	return false;
}

function private Evaluator_CheckAnimationArrivalPosition( entity, animation )
{
	localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
	endPoint 		 = entity LocalToWorldCoords( localDeltaVector );
	animDistSq 		 = LengthSquared( localDeltaVector );
	
	startPos = entity.origin;	
	goalPos  = entity.pathGoalPos;
				
	distToGoalSq = DistanceSquared( startPos, goalPos );
				
	return distToGoalSq < animDistSq;
}

function private Evaluator_FindFirstValidAnimation( entity, animations, tests )
{
	assert( IsArray( animations ), "An array of animations must be passed in to validate against." );
	assert( IsArray( tests ), "An array of test functions must be passed in to validate an animation." );

	// Only check the first animation within the group of animations, since each animation is synonymous with each other.
	foreach ( aliasAnimations in animations )
	{
		if ( aliasAnimations.size > 0 )
		{
			valid = true;
			animation = aliasAnimations[0];
		
			foreach ( test in tests )
			{
				if ( ![[test]]( entity, animation ) )
				{
					valid = false;
					break;
				}
			}
		
			if ( valid )
			{
				return animation;
			}
		}
	}
}

// ------- EVALUATOR BLOCKED BY GEO ANIMATIONS -----------//
function private evaluateBlockedAnimations( entity, animations )
{		
	if( animations.size > 0 )
	{
		return Evaluator_FindFirstValidAnimation(
			entity,
			animations,
			array(
				&Evaluator_CheckAnimationAgainstGeo,
				&Evaluator_CheckAnimationForOverShootingGoal ) );
	}
	
	return undefined;
	
}


function private evaluateHumanTurnAnimations( entity, animations )
{
	/#
	// SUMEET - Added this check just for testing.
	if( ( isdefined( level.ai_dontTurn ) && level.ai_dontTurn ) )
		return undefined;
	#/
	
	/#
	Record3DText( "" + GetTime() + ": Turn Evaluator", entity.origin, ( 1, .5, 0 ), "Animscript", entity );
	#/
	
	if( animations.size > 0 )
	{
		return Evaluator_FindFirstValidAnimation(
			entity,
			animations,
			array(
				&Evaluator_CheckAnimationForOverShootingGoal,
				&Evaluator_CheckAnimationAgainstGeo,
				&Evaluator_CheckAnimationAgainstNavmesh ) );
	}	
	
	return undefined;
}


function private evaluateHumanExposedArrivalAnimations( entity, animations )
{
	const ARRIVAL_DIST_ALLOWED_ERROR = 32;
	
	if( !IsDefined( entity.pathGoalPos ) )
		return undefined;
	
	if( animations.size > 0 )
	{
		return Evaluator_FindFirstValidAnimation(
			entity,
			animations,
			array( &Evaluator_CheckAnimationArrivalPosition ) );
	}	
	
	return undefined;
}
