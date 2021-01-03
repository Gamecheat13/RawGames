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
	assert( IsActor( entity ) );	
	
	localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
	endPoint = entity LocalToWorldCoords( localDeltaVector );
	
	if( entity MayMoveToPoint( endPoint, true, true ) )
		return true;
	
	return false;
}

function private Evaluator_CheckAnimationEndPointAgainstGeo( entity, animation )
{
	assert( IsActor( entity ) );	
	
	localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
	endPoint = entity LocalToWorldCoords( localDeltaVector );
	
	if( entity MayMoveToPoint( endPoint, false, false ) )
		return true;
	
	return false;
}

function private Evaluator_CheckAnimationForOverShootingGoal( entity, animation )
{	
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
			return true;
	}
	
	return false;
}

function private Evaluator_CheckAnimationAgainstNavmesh( entity, animation )
{
	assert( IsActor( entity ) );
	
	localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
	endPoint 		 = entity LocalToWorldCoords( localDeltaVector );

	// make sure that the point is on the navmesh and away from boundary
	if( IsPointOnMesh( endPoint, entity ) && IsAwayFromBoundary( endPoint, entity ) )
		return true;
	
	return false;
}

// ------- EVALUATOR BLOCKED BY GEO ANIMATIONS -----------//
function private evaluateBlockedAnimations( entity, animations )
{		
	if( animations.size > 0 )
	{
		validAnimations = undefined;
		
		foreach( animation in animations )
		{
			if( Evaluator_CheckAnimationAgainstGeo( entity, animation ) 
			   && Evaluator_CheckAnimationForOverShootingGoal( entity, animation ) 
			  )
			{
				if( !IsDefined( validAnimations ) )
					validAnimations = [];
				
				validAnimations[validAnimations.size] = animation;		
			}
		}
		
		if( IsDefined( validAnimations ) )
			return array::random( validAnimations );
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
	
	if( animations.size > 0 )
	{
		validAnimations = undefined;
		
		foreach( animation in animations )
		{
			if( Evaluator_CheckAnimationForOverShootingGoal( entity, animation ) 
			   	&& Evaluator_CheckAnimationEndPointAgainstGeo( entity, animation ) 
			  	&& Evaluator_CheckAnimationAgainstNavmesh( entity, animation ) 
			  )
			{
				if( !IsDefined( validAnimations ) )
					validAnimations = [];
				
				validAnimations[validAnimations.size] = animation;		
			}
		}
		
		if( IsDefined( validAnimations ) )
			return array::random( validAnimations );
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
		validAnimations = undefined;
		
		foreach( animation in animations )
		{
			localDeltaVector = GetMoveDelta( animation, 0, 1, entity );
			endPoint 		 = entity LocalToWorldCoords( localDeltaVector );
			animDistSq 		 = LengthSquared( localDeltaVector );
			
			startPos = entity.origin;	
			goalPos  = entity.pathGoalPos;
						
			distToGoalSq = DistanceSquared( startPos, goalPos );
						
			if( distToGoalSq < animDistSq )
			{
				if( !IsDefined( validAnimations ) )
					validAnimations = [];
				
				validAnimations[validAnimations.size] = animation;		
			}
		}
		
		if( IsDefined( validAnimations ) )
			return array::random( validAnimations );
	}	
	
	return undefined;
}
