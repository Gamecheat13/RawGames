#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\laststand_shared;

#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\archetype_warlord_interface;


                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                  	                             	  	                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  	   	   	   	   	   	   	    	    	                                                                                                                                                                                                           	      	                        	   	   	   	   	   	  /#         #/	  	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  	    	                                                                                                                                                                                                         

#precache( "fx", "vehicle/fx_quadtank_airburst" );
#precache( "fx", "vehicle/fx_quadtank_airburst_ground" );

///***********************************WARLORD BEHAVIOR SUMMERY*******************************************//
//
//Fire Behavior
//-Threat (2 or more attackers)
//-Angry (2 or more attackers)
//-Exposed pain cooldown and pain don't interrupt shooting

//Move Behavior
//-Move from dangerous place (2 or more attackers)
//-Hunt Enemy
//-Prefered Locations
//-Juke
//*********************************************************************************************************//


function autoexec main()
{		
	// INIT BLACKBOARD	
	spawner::add_archetype_spawn_function( "warlord", &WarlordBehavior::ArchetypeWarlordBlackboardInit );
	
	// INIT WARLORD ON SPAWN
	spawner::add_archetype_spawn_function( "warlord", &WarlordServerUtils::warlordSpawnSetup );
	
	clientfield::register("actor", "warlord_damage_state", 1, 2, "int");
	clientfield::register("actor", "warlord_thruster_direction", 1, 3, "int");
	clientfield::register("actor", "warlord_type", 1, 2, "int");
	
		
	//REGISTER INTERFACE ATTRIBUTES
	WarlordInterface::RegisterWarlordInterfaceAttributes();
}

#namespace WarlordBehavior;

function autoexec RegisterBehaviorScriptFunctions()
{	
	// ------- WARLORD CONDITIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordCanJukeCondition",&canJukeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordCanTacticalJukeCondition",&canTacticalJukeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordShouldBeAngryCondition",&shouldBeAngryCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordShouldNormalMelee",&warlordShouldNormalMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordCanTakePainCondition",&canTakePainCondition);;
	
	// ------- WARLORD FUNCTIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordExposedPainActionStart",&exposedPainActionStart);;
	
	// ------- WARLORD ACTIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("warlordDeathAction",&deathAction,undefined,undefined);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("warlordJukeAction",&jukeAction,undefined,&jukeActionTerminate);;

	// ------- WARLORD SERVICES -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseBetterPositionService",&chooseBetterPositionService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("WarlordAngryAttack",&WarlordAngryAttack);;
}


function private ArchetypeWarlordBlackboardInit()
{
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( self );
	
	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( self );

	
	// USE UTILITY BLACKBOARD
	self AiUtility::RegisterUtilityBlackboardAttributes();
	
	// CREATE WARLORD BLACKBOARD - NOT NEEDED
	
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeWarlordOnAnimscriptedCallback;
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#self FinalizeTrackedBlackboardAttributes();#/;
}

function private ArchetypeWarlordOnAnimscriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeWarlordBlackboardInit();
}

function private shouldHuntEnemyPlayer( entity )
{
	if(isdefined(entity.enemy) && isdefined(entity.HuntEnemyTime) && (GetTime() < entity.HuntEnemyTime))
	{
		return true;
	}
	
	return false;
}

function private _warlordHuntEnemy( entity )
{	
	/#
	WarlordDebugHelpers::TryState( entity, 3, true);
	#/
	
	if ( Distance2DSquared( entity.origin, self LastKnownPos(self.enemy) ) <= ( (250) * (250) ) )
	{
		return false;
	}
	
	if ( isdefined( entity.huntUpdateNextTime ) && GetTime() < entity.huntUpdateNextTime )
	{
		return false;
	}
	
	if(entity.isAngryAttack)
	{
		/#
		WarlordDebugHelpers::PrintState(3, (1, 0, 1), "Suspended by Angery Attack");
		#/
			
		return false;
	}
	
	positionOnNavMesh = GetClosestPointOnNavMesh( self LastKnownPos(self.enemy), 200 );
	
	if ( !isdefined( positionOnNavMesh ) )
	{
		positionOnNavMesh = self LastKnownPos(self.enemy);
	}
	
	queryResult = PositionQuery_Source_Navigation(
		positionOnNavMesh,
		150,
		250,
		0.5 * 90,
		36,
		entity,
		36 );
	
	PositionQuery_Filter_InClaimedLocation( queryResult, entity );
	PositionQuery_Filter_DistanceToGoal(queryResult, entity);
	
	if ( queryResult.data.size > 0 )
	{
		closestPoint = undefined;
		closestDistance = undefined;
	
		foreach ( point in queryResult.data )
		{
			if ( !point.inclaimedlocation && point.distToGoal == 0)
			{
				newClosestDistance = Distance2DSquared( entity.origin, point.origin );
			
				if ( !isdefined( closestPoint ) ||
					newClosestDistance < closestDistance )
				{
					closestPoint = point.origin;
					closestDistance = newClosestDistance;
				}
			}
		}
		
		if ( isdefined( closestPoint ) )
		{
			/#
			WarlordDebugHelpers::SetCurrentState(entity, 3, true);
			#/
			
			entity UsePosition( closestPoint );
			entity.huntUpdateNextTime = GetTime() + RandomIntRange( 500, 1500 );
			return true;
		}
	}
	
	/#
	WarlordDebugHelpers::SetStateFailed(entity, 3);
	#/
		
	entity.HuntEnemyTime = undefined;	
	return false;
}


function chooseBetterPositionService( entity )
{
	if ( entity ASMIsTransitionRunning() ||
		( entity GetBehaviortreeStatus() != 5 ) ||
		entity ASMIsSubStatePending() ||
		entity AsmIsTransDecRunning() ||
		entity ShouldHoldGroundAgainstEnemy() )
	{
		return false;
	}

	
	searchOrigin = undefined;
	bApproachingGoal = entity IsApproachingGoal();
	
	if( !bApproachingGoal)  //1- Go to goal if we are ouside it or changed
	{
		WarlordServerUtils::ClearPreferedPoint( entity );
		
		/#
		WarlordDebugHelpers::SetCurrentState( entity, 6);
		#/
		
		//if we are following an entity or goalradius is too small, just go to it directly
		if( isdefined(entity.goalent) || (entity.goalradius < (36 * 2)) )
		{
			goalPosOnMesh = GetClosestPointOnNavMesh( self.GoalPos, 200 );
			
			if(!isdefined(goalPosOnMesh))
			{
				goalPosOnMesh = self.GoalPos;
			}
			
			entity UsePosition( goalPosOnMesh );
			return true;
		}
	}
	
	if(bApproachingGoal && shouldHuntEnemyPlayer(entity)) 					//2- Should hunt enemy
	{
		return _warlordHuntEnemy(entity);
	}
	else if(bApproachingGoal && warlordserverutils::UpdatePreferedPoint(entity)) //3- Go to prefered point location
	{
		return true;
	}
	else if( isdefined( entity.lastenemysightpos ) )							 //4- Should investigate enemy last position if any
	{
		searchOrigin = entity.lastenemysightpos;
	}
	else
	{
		/#
		entity WarlordDebugHelpers::PrintState(undefined, (1, 0, 0), "searchOrigin = self.GoalPos");
		#/
		
		searchOrigin = entity.GoalPos;
	}


	// Clamp enemy's position to the navmesh.
	if ( isdefined( searchOrigin ) )
	{
		searchOrigin = GetClosestPointOnNavMesh( searchOrigin, 200 );
	}

	if ( !isdefined( searchOrigin ) )
	{
		return false;
	}
	
	shouldRepath = false;
	isTrackingEnemyLastPos = false;
	
	if (!bApproachingGoal || !isdefined( entity.nextFindBetterPositionTime ) ||	GetTime() > entity.nextFindBetterPositionTime) //ShouldRepath if we are outside the goal or we are bored
	{
		shouldRepath = true;
	}
	
	if ( isdefined( entity.enemy ) && !entity SeeRecently( entity.enemy, 2 ) && isdefined( entity.lastenemysightpos )) //ShouldRepath if we lost the enemy
	{
		/#
		entity WarlordDebugHelpers::PrintState(undefined, (1, 1, 1), "TrackingEnemyLastPos");
		#/
			
	 	isTrackingEnemyLastPos = true;
	 	
		//if the warlord is moving near the lastKnowEnemyPos give it a chance to reach there
		if(isdefined(entity.pathGoalPos))
		{
			distanceToGoalSqr = DistanceSquared(searchOrigin, entity.pathGoalPos);
			
			if( distanceToGoalSqr < ( (200) * (200) ) )
			{
				shouldRepath = false;
			}
		}
		else
		{
			shouldRepath = true;
		}
	}
	
	if (shouldRepath)
	{
/////////// Find points around the enemy.
		queryResult = PositionQuery_Source_Navigation( searchOrigin, 0, entity.engagemaxdist, 0.5 * 90, 36 * 2, entity, 36 * 2 );
			
		PositionQuery_Filter_InClaimedLocation( queryResult, entity );
		PositionQuery_Filter_DistanceToGoal(queryResult, entity);
	
	//ToDo - mali 3/12/2015: limit the number of Sight checks		
		
		//if there is an enemy try to pick the points that sees it, early out after 20 successful checks
		if(isdefined( entity.enemy ) && isTrackingEnemyLastPos && ( isdefined( entity.WarlordAggressiveMode ) && entity.WarlordAggressiveMode ))
		{
			PositionQuery_Filter_Sight(queryResult, self LastKnownPos(self.enemy), self GetEye() - self.origin, self, 20);
		}
	
		// Throw away points close to the current position or outside the goalradius.
		preferedPoints = [];
		randomPoints = [];
		bPointsAvailable = 0;
		bPointsInGoal = 0;
		bPointsVisible = 0;
		
		closePointDistance = 36;
		
		foreach ( point in queryResult.data )
		{
			if (point.inClaimedLocation)
				continue;
			
			bPointsAvailable++;
			
			if (point.distToGoal > 0) //outside goal radius
				continue;
			
			bPointsInGoal++;
			
			if (isdefined(point.visibility) && !point.visibility)
				continue;
			
			bPointsVisible++;
		
			if(point.distToOrigin2D < closePointDistance)
				continue;
			
			randomPoints[randomPoints.size] = point.origin;
		}
		
		//Get Valid Preferred Points as long as we are not forced to track the player
		if( !(isdefined( entity.enemy ) && isTrackingEnemyLastPos && ( isdefined( entity.WarlordAggressiveMode ) && entity.WarlordAggressiveMode )) )
		{
			preferedPoints = WarlordServerUtils::GetPreferedValidPoints(entity);
		}
		
/////////no perfect points found...fallback to less than perfect ones
		if ( randomPoints.size == 0 && preferedPoints.size == 0 )
		{
			if(bPointsAvailable == 0) //all available points are claimed by other actors!
			{
				return false;
			}
			else if(bPointsInGoal == 0) //if no points from the current searchOrigin, find one near the goal
			{
				// Find points on the edge of the goal radius
				searchOriginOnGoalRadius = entity.GoalPos + VectorNormalize(searchOrigin - entity.GoalPos) * entity.GoalRadius;
				
				queryResult = PositionQuery_Source_Navigation( searchOriginOnGoalRadius, 0,	entity.engagemaxdist, 0.5 * 90,	36 * 2, entity, 36 * 3 );
									
				PositionQuery_Filter_InClaimedLocation( queryResult, entity );
				PositionQuery_Filter_DistanceToGoal(queryResult, entity);
				
				//ToDo - mali 3/12/2015: limit the number of Sight checks
				/*
				if(isdefined( entity.enemy ) && isTrackingEnemyLastPos && entity.WarlordAggressiveMode === true)
				{
					PositionQuery_Filter_Sight(queryResult, self LastKnownPos(self.enemy), self GetEye() - self.origin, self, 20);
				}
				*/
				
				//try to find prefect nodes in the new search
				bPointsAvailable = 0;
				bPointsInGoal = 0;
				bPointsVisible = 0;
									
				foreach ( point in queryResult.data )
				{		
					if (point.inClaimedLocation)
						continue;
					
					bPointsAvailable++;
					
					if (point.distToGoal > 0) //outside goal radius
						continue;
					
					bPointsInGoal++;
					
					if (isdefined(point.visibility) && !point.visibility)
						continue;
					
					bPointsVisible++;
				
					if(point.distToOrigin2D < closePointDistance)
						continue;
					
					randomPoints[randomPoints.size] = point.origin;
				}
				
				//ok let's settle for less perfect nodes if still nothing found
				if ( randomPoints.size == 0 )
				{
					foreach ( point in queryResult.data )
					{
						if (point.inClaimedLocation)
							continue;
						
						if (point.distToGoal > 0) //still outside goal radius
							continue;
						
						if (bPointsVisible > 0 && isdefined(point.visibility) && !point.visibility)
							continue;
						
						randomPoints[randomPoints.size] = point.origin;
					}
				}
			}
			else //There are points inside the goal but not visible
			{
				foreach ( point in queryResult.data )
				{
					if (point.inClaimedLocation)
						continue;
					
					if (point.distToGoal > 0) //outside goal radius
						continue;
					
					if (bPointsVisible > 0 && isdefined(point.visibility) && !point.visibility)
						continue;
					
					randomPoints[randomPoints.size] = point.origin;
				}
			}
			
			if ( randomPoints.size == 0 )
			{
				if(!bApproachingGoal)
				{
					if ( !isdefined( randomPoints ) ) randomPoints = []; else if ( !IsArray( randomPoints ) ) randomPoints = array( randomPoints ); randomPoints[randomPoints.size]=entity.GoalPos;;
				}
				else
				{
					/#
					WarlordDebugHelpers::SetStateFailed(entity, 5);
					#/
					
					return false;
				}
			}
		}
		
		
/////////////Calculate final weights and goal

		goalWeight = -10000;
		
		engageMinFalloffDistSqrd = entity.engageMinFalloffDist * entity.engageMinFalloffDist;
		engageMinDistSqrd = entity.engageMinDist * entity.engageMinDist;
		engageMaxDistSqrd = entity.engageMaxDist * entity.engageMaxDist;
		engageMaxFalloffDistSqrd = entity.engageMaxFalloffDist * entity.engageMaxFalloffDist;
		
		if( isdefined( entity.enemy ) && IsSentient( entity.enemy ) )
		{
			enemyForward = VectorNormalize( AnglesToForward( entity.enemy.angles ) );
		}
		
		
		for ( index = 0; index < randomPoints.size; index++ )
		{
			// Rate the available positions.
			distanceSqrdToEnemy = Distance2DSquared( randomPoints[index], searchOrigin );
			
			//Warlord prefers far locations unless it is tracking the player or he is ina Aggressive mode
			bWeightSign = 1;
			if(isdefined(isTrackingEnemyLastPos) || ( isdefined( entity.WarlordAggressiveMode ) && entity.WarlordAggressiveMode ))
			{
				bWeightSign = -1;
			}
			
			pointWeight = 0;
			
			if ( distanceSqrdToEnemy < engageMinFalloffDistSqrd )
			{
				pointWeight = -1.0 * bWeightSign;
			}
			else if ( distanceSqrdToEnemy < engageMinDistSqrd )
			{
				pointWeight = -0.5 * bWeightSign;
			}
			else if ( distanceSqrdToEnemy > engageMaxFalloffDistSqrd )
			{
				pointWeight = 1.0 * bWeightSign;
			}
			else if ( distanceSqrdToEnemy > engageMaxDistSqrd )
			{
				pointWeight = 1.0 * bWeightSign;
			}
			
			// Lower the pointWeights of points directly behind the enemy.
			if(isdefined(enemyForward))
			{
				// TODO(David Young 3-25-14): Simplify the calculations after finding a good heuristic.
				// TODO(David Young 4-16-14): Clamping is unnecessary but there is a weird SRE that occurred because of the dot product returning a value lower than -1.
				angleFromForward = acos( math::clamp( VectorDot( VectorNormalize( pointWeight - entity.enemy.origin ), enemyForward ), -1, 1 ) );
				
				if ( angleFromForward > 80.0 )
				{
					pointWeight += -0.5;
				}
			}
			
			//Slightly random the points
			pointWeight += RandomFloatRange(-0.25, 0.25);
			
			// Set the best goal position.
			if ( goalWeight < pointWeight )
			{
				goalWeight = pointWeight;
				goalPosition = randomPoints[index];
			}
			
			
			// Draw debug info
			/#
			if ( GetDvarInt("ai_debugPositionService") > 0 && isdefined( GetEntByNum( GetDvarInt("ai_debugPositionService") ) ) && entity == GetEntByNum( GetDvarInt("ai_debugPositionService") ) )
			{
				as_debug::debugDrawWeightedPoint( entity, randomPoints[index], pointWeight, -1.25, 1.75 );
			}
			#/
			// End of debug
		}
		
		//preferedPoints have higher weight
		normalPointsMaxGoalWeight = goalWeight;
		foreach(point in preferedPoints)
		{
			if(point === entity.previous_prefered_point)
				continue;
			
			pointWeight = RandomFloatRange(normalPointsMaxGoalWeight - 0.25, normalPointsMaxGoalWeight + 0.5);
			
			// Set the best goal position.
			if ( goalWeight < pointWeight )
			{
				goalWeight = pointWeight;
				goalPosition = point.origin;
				preferedPoint = point;
			}
			
			// Draw debug info
			/#
			if ( GetDvarInt("ai_debugPositionService") > 0 && isdefined( GetEntByNum( GetDvarInt("ai_debugPositionService") ) ) && entity == GetEntByNum( GetDvarInt("ai_debugPositionService") ) )
			{
				as_debug::debugDrawWeightedPoint( entity, point.origin, pointWeight, -1.25, 1.75 );
			}
			#/
			// End of debug
		}
		
		// End of calculations
		
		if ( isdefined( goalPosition ) )
		{
			if ( entity FindPath( entity.origin, goalPosition, true, false ) )
			{
				entity UsePosition( goalPosition );
				entity.nextFindBetterPositionTime = GetTime() + entity.coversearchinterval;
				
				if(isdefined(preferedPoint))
				{
					/#
					WarlordDebugHelpers::SetCurrentState(entity, 4);
					#/
						
					WarlordServerUtils::SetPreferedPoint( entity, preferedPoint );
				}
				
				/#
				if(!isdefined(preferedPoint))
				{
					WarlordDebugHelpers::SetCurrentState(entity, 5);
				}
				#/
				
				return true;
			}
			
		}
		// End of setting the best goal position.
	}
	
	return false;
}

// ------- BEHAVIOR CONDITIONS -----------//
function canJukeCondition( behaviorTreeEntity )
{
	if ( isdefined( behaviorTreeEntity.nextJukeTime ) && GetTime() < behaviorTreeEntity.nextJukeTime )
	{
		return false;
	}
	
	return WarlordServerUtils::warlordCanJuke( behaviorTreeEntity );
}

function canTacticalJukeCondition( behaviorTreeEntity )
{
	if ( isdefined( behaviorTreeEntity.nextJukeTime ) && GetTime() < behaviorTreeEntity.nextJukeTime )
	{
		return false;
	}
	
	return WarlordServerUtils::warlordCanTacticalJuke( behaviorTreeEntity );
}

function warlordShouldNormalMelee( behaviorTreeEntity)
{
	if ( isdefined( behaviorTreeEntity.enemy ) && !( ( isdefined( behaviorTreeEntity.enemy.allowDeath ) && behaviorTreeEntity.enemy.allowDeath ) ) )
		return false;
	
	if ( AiUtility::hasEnemy( behaviorTreeEntity ) && !IsAlive( behaviorTreeEntity.enemy ) )
		return false;
	
	if( !IsSentient( behaviorTreeEntity.enemy ) )
		return false;
	
	if( IsVehicle( behaviorTreeEntity.enemy ) && !( isdefined( behaviorTreeEntity.enemy.good_melee_target ) && behaviorTreeEntity.enemy.good_melee_target ) )
		return false;
	
	if( !AiUtility::shouldMutexMelee( behaviorTreeEntity ) )
		return false;
	
	if( behaviorTreeEntity ai::has_behavior_attribute( "can_melee" ) && !behaviorTreeEntity ai::get_behavior_attribute( "can_melee" ) )
		return false;
		
	if(	behaviorTreeEntity.enemy ai::has_behavior_attribute( "can_be_meleed" ) && !behaviorTreeEntity.enemy ai::get_behavior_attribute( "can_be_meleed" ) )
		return false;
	
	if( !IsPlayer(behaviorTreeEntity.enemy) && !( isdefined( behaviorTreeEntity.enemy.magic_bullet_shield ) && behaviorTreeEntity.enemy.magic_bullet_shield ) ) //we don't want the warlord to keep punching an enemy who can't die
		return false;
	
	if(	AiUtility::hasCloseEnemyToMeleeWithRange( behaviorTreeEntity, ( (128) * (128) )) )
		return true;

	return false;
}

function canTakePainCondition( behaviorTreeEntity )
{
	return (GetTime() >= behaviorTreeEntity.nextExposedPain);
}


// ------- COMBAT LOCOMOTION ACTIONS -----------//

function jukeAction( behaviorTreeEntity, asmStateName )
{
	behaviorTreeEntity.nextJukeTime = GetTime() + 3000;
	
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	jukeDirection = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_juke_direction");
	
	switch ( jukeDirection )
	{
	case "left":
		clientfield::set( "warlord_thruster_direction", 4 );
		break;
	case "right":
		clientfield::set( "warlord_thruster_direction", 3 );
		break;
	}
	
	behaviorTreeEntity ClearPath();

	//Notify other actors that the warlord just did a juke
	jukeInfo = SpawnStruct();
	jukeInfo.origin = behaviorTreeEntity.origin;
	jukeInfo.entity = behaviorTreeEntity;

	Blackboard::AddBlackboardEvent( "actor_juke", jukeInfo, 2000 );

	jukeInfo.entity playsound("fly_jetpack_juke_warlord");
	
	
	return 5;
}

function jukeActionTerminate( behaviorTreeEntity, asmStateName )
{
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_juke_direction", undefined );
	
	clientfield::set( "warlord_thruster_direction", 0 );
	
	//use the new Juke landing position
	positionOnNavMesh = GetClosestPointOnNavMesh( behaviorTreeEntity.origin, 200 );
	
	if ( !isdefined( positionOnNavMesh ) )
	{
		positionOnNavMesh = behaviorTreeEntity.origin;
	}
	
	behaviorTreeEntity UsePosition( positionOnNavMesh );
	
	return 4;
}

// ------- RECHARGE ACTIONS -----------//	
function deathAction( behaviorTreeEntity, asmStateName )
{
	clientfield::set( "warlord_damage_state", 3 );

	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	return 5;
}

function exposedPainActionStart( behaviorTreeEntity )
{
	behaviorTreeEntity.nextExposedPain = GetTime() + RandomIntRange(500, 2500);
	
	AiUtility::keepClaimNode( behaviorTreeEntity );
}

// ------- Angry -----------//	
function shouldBeAngryCondition( behaviorTreeEntity )
{
	if( isdefined(behaviorTreeEntity.nextAngryTime) && (GetTime() < behaviorTreeEntity.nextAngryTime) )
		return false;
	
	if( !isDefined( behaviorTreeEntity.knownAttackers) || behaviorTreeEntity.knownAttackers.size == 0)
	{
		return false;
	}
	else if(behaviorTreeEntity.knownAttackers.size == 1 && isdefined(behaviorTreeEntity.enemy) && behaviorTreeEntity.knownAttackers[0].attacker == behaviorTreeEntity.enemy) //if attacker is enemy and we only have one attacker no need to do something extra
	{
		return false;
	}
	
	
	if(isdefined(behaviorTreeEntity.AccumilatedDamage) && behaviorTreeEntity.AccumilatedDamage > WarlordServerUtils::GetScaledForPlayers(200, 1.5, 2, 2.5) )
		return true;
	
	return behaviorTreeEntity.isAngryAttack;
}


function WarlordAngryAttack( entity )
{	
	/#
	WarlordDebugHelpers::PrintState(1, (0, 1, 0), " STARTED");
	#/
		
	entity.isAngryAttack = true;
	entity.forceFire = true;
	entity.AccumilatedDamage = 0;
	entity.nextAngryTime = GetTime() + 13000;
	
	WarlordServerUtils::UpdateAttackersList( entity );
	
	attackersArray = [];
	
	//Sort known Attackers based on threat
	for(i = 0;i < entity.knownAttackers.size; i++)
	{
		for( j = i + 1; j < entity.knownAttackers.size; j++)
		{
			if(entity.knownAttackers[i].threat < entity.knownAttackers[j].threat)
			{
				tmp = entity.knownAttackers[j].threat;
				entity.knownAttackers[j].threat = entity.knownAttackers[i].threat;
				entity.knownAttackers[i].threat = tmp;
			}
		}
	}
	
	foreach(data in entity.knownAttackers)
	{
		if ( !isdefined( attackersArray ) ) attackersArray = []; else if ( !IsArray( attackersArray ) ) attackersArray = array( attackersArray ); attackersArray[attackersArray.size]=data.attacker;;
	}
	
	thread WarlordAngryAttack_ShootThemAll(entity, attackersArray);
	
	return true;
}

function WarlordAngryAttack_ShootThemAll( entity, attackersArray )
{
	entity endon("disconnect");
	entity endon("death");
	
	entity notify("angry_attack");
	
	shootTime = GetDVarFloat("warlordangryattack", 3);
	
	foreach(attacker in attackersArray)
	{
		if(isdefined(attacker))
		{
			entity ai::shoot_at_target("normal", attacker, undefined, shootTime, undefined, true);
		}
	}
	
	/#
	WarlordDebugHelpers::PrintState(1, (0, 0, 1), " ENDED");
	#/
		
	entity.forceFire = false;
	entity.isAngryAttack = false;;
}

// end of #namespace WarlordBehavior

#namespace WarlordServerUtils;

function GetAlivePlayersCount(entity)
{
	if(entity.team == "allies")
	{
		return level.aliveCount["axis"];
	}
	else
	{
		return level.aliveCount["allies"];
	}	
}

function SetWarlordAggressiveMode( entity, b_aggressive_mode )
{
	entity.WarlordAggressiveMode = b_aggressive_mode;
}

function AddPreferedPoint(entity, position, min_duration, max_duration, name)
{
	positionOnNavMesh = GetClosestPointOnNavMesh( position, 200, 25 );
	
	if(!isdefined(positionOnNavMesh))
	{
		/#	println( "^3Warning: Passing Warlord prefered point that is not on the NavMesh or is in invalid location: " + position ); 	#/
		return;
	}
	else
	{
		position = positionOnNavMesh;
	}
	
	if(!(entity IsPosAtGoal(position)))
	{
		/#	println( "^3Warning: Passing Warlord prefered point that it not inside the Goal: " + position ); 	#/
	}

	point = SpawnStruct();
	point.origin = position;
	point.min_duration = min_duration;
	point.max_duration = max_duration;
	point.name = name;

	if ( !isdefined( entity.prefered_points ) ) entity.prefered_points = []; else if ( !IsArray( entity.prefered_points ) ) entity.prefered_points = array( entity.prefered_points ); entity.prefered_points[entity.prefered_points.size]=point;;
}

function DeletePreferedPoint( entity, name )
{
	if(isdefined(entity.prefered_points))
	{
		points_to_remove = [];
		
		foreach(point in entity.prefered_points)
		{
			if( point.name === name )
			{
				if ( !isdefined( points_to_remove ) ) points_to_remove = []; else if ( !IsArray( points_to_remove ) ) points_to_remove = array( points_to_remove ); points_to_remove[points_to_remove.size]=point;;
			}
		}
		
		if(points_to_remove.size > 0)
		{
			foreach(point in points_to_remove)
			{
				ArrayRemoveValue( entity.prefered_points, point );
			}
			
			return true;
		}
	}
	
	return false;
}

function ClearAllPreferedPoints(entity)
{
	ClearPreferedPoint(entity);
	
	entity.prefered_points = [];
}

function ClearPreferedPointsOutsideGoal(entity)
{
	points_to_remove = [];
	
	foreach(point in entity.prefered_points)
	{
		if(!(entity IsPosAtGoal(point.origin)))
		{
			if ( !isdefined( points_to_remove ) ) points_to_remove = []; else if ( !IsArray( points_to_remove ) ) points_to_remove = array( points_to_remove ); points_to_remove[points_to_remove.size]=point;;
		}
	}
	
	foreach(point in points_to_remove)
	{
		ArrayRemoveValue( entity.prefered_points, point );
	}
}

function private SetPreferedPoint( entity, point)
{
	entity.previous_prefered_point = entity.current_prefered_point;
	entity.current_prefered_point = point;
}

function private ClearPreferedPoint( entity)
{
	/#
	WarlordDebugHelpers::SetCurrentState(entity, undefined);
	#/
	
	entity.current_prefered_point_start_time = undefined;
	entity.current_prefered_point_expiration = undefined;
	entity.current_prefered_point = undefined;
}

function private AtPreferedPoint(entity)
{
	if(isdefined(entity.current_prefered_point) && ( (DistanceSquared(entity.current_prefered_point.origin, entity.origin) < ( (36) * (36) )) && (abs(self.current_prefered_point.origin[2] - entity.origin[2]) < (90 / 2)) ) )
	{
		return true;
	}
	
	return false;
}

function private ReachingPreferedPoint(entity)
{
	if(!isdefined(entity.current_prefered_point))
		return false;
	
	if(AtPreferedPoint(entity))
	{
		return true;
	}
	
	if(isdefined(entity.pathGoalPos) && entity.pathGoalPos == entity.current_prefered_point.origin)
	{
		return true;
	}
	
	return false;
}

function private UpdatePreferedPoint(entity)
{
	if(isdefined(entity.current_prefered_point))
	{
		if(AtPreferedPoint(entity))
		{
			if(isdefined(entity.current_prefered_point_expiration))
			{
				if(GetTime() > entity.current_prefered_point_expiration)
				{
					ClearPreferedPoint(entity);
					return false;
				}
				
				return true;
			}
			else
			{
				if(isdefined(entity.current_prefered_point.min_duration))
				{
					entity.current_prefered_point_start_time = GetTime();
						
					if(!isdefined(entity.current_prefered_point.max_duration) || entity.current_prefered_point.max_duration == entity.current_prefered_point.min_duration)
					{
						entity.current_prefered_point_expiration = GetTime() + entity.current_prefered_point.min_duration;
					}
					else
					{
						duration = RandomIntRange(entity.current_prefered_point.min_duration, entity.current_prefered_point.max_duration);
						entity.current_prefered_point_expiration = GetTime() + duration;
					}
					
					return true;
				}
				else
				{
					ClearPreferedPoint(entity);
					return false;
				}
			}
			
			return true;
		}
		else if(!ReachingPreferedPoint(entity))
		{
			entity UsePosition( entity.current_prefered_point.origin );
		}
		
		return true;
	}
	
	return false;
}


function private GetPreferedValidPoints( entity )
{
	validPoints = [];
	
	if(isdefined(entity.prefered_points))
	{
		foreach(point in entity.prefered_points)
		{
			if(!(entity IsPosAtGoal(point.origin)))
			{
				distance = Distance2DSquared(entity.origin, point.origin);
				distance = sqrt(distance);
				continue;
			}
			
			if((entity IsPosInClaimedLocation(point.origin)))
				continue;
			
			if(isdefined( entity.enemy ) && ( isdefined( entity.WarlordAggressiveMode ) && entity.WarlordAggressiveMode ))
			{
				if( !BulletTracePassed( entity GetEye(), entity.enemy.origin + (0, 0, 50), false, entity, entity.enemy ) )
				   continue;
			}
 
			if ( !isdefined( validPoints ) ) validPoints = []; else if ( !IsArray( validPoints ) ) validPoints = array( validPoints ); validPoints[validPoints.size]=point;;
		}
	}
	
	return validPoints;
}

function GetScaledForPlayers(val, scale2, scale3, scale4)
{
	if(!isdefined( level.players))
	{
		return val;
	}

	if( level.players.size == 2 )
	{
		return val * scale2;
	}
	else if( level.players.size == 3 )
	{
		return val * scale3;
	}
	else if( level.players.size == 4 )
	{
		return val * scale4;
	}
	else
	{
		return val;
	}
}

function warlordCanJuke( entity )
{

	if (!isdefined( entity.enemy ) )
	{
		return false;
	}
	
	distanceSqr = DistanceSquared(entity.enemy.origin, entity.origin);
	
	if(distanceSqr < ( (300) * (300) ))
	{
		jukeDistance = 145 / 2;
	}
	else
	{
		jukeDistance = 145;
	}
	
	jukeDirection = AiUtility::calculateJukeDirection( entity, 18, jukeDistance );

	if(jukeDirection != "forward")
	{
		Blackboard::SetBlackBoardAttribute( entity, "_juke_direction", jukeDirection );
		
		if(jukeDistance == 145)
		{
			Blackboard::SetBlackBoardAttribute( entity, "_juke_distance", "long" );
		}
		else
		{
			Blackboard::SetBlackBoardAttribute( entity, "_juke_distance", "short" );
		}
		
		return true;
	}
	
	return false;
}

function warlordCanTacticalJuke( entity )
{
	if ( entity HasPath () )
	{
		locomotionDirection = AiUtility::BB_GetLocomotionFaceEnemyQuadrant();

		if( locomotionDirection == "locomotion_face_enemy_front" || locomotionDirection == "locomotion_face_enemy_back")
		{
			jukeDirection = AiUtility::calculateJukeDirection( entity, 50, 145 ) ;
			
			if(jukeDirection != "forward" )
			{
				Blackboard::SetBlackBoardAttribute( entity, "_juke_direction", jukeDirection );
				Blackboard::SetBlackBoardAttribute( entity, "_juke_distance", "long" );
				
				return true;
			}
		}
	}
	
	return false;
}

function ComputeAttackerThreat( entity, attackerInfo)
{
	if(attackerInfo.damage < 250)
	   return 0;

   threat = 1;
   isAttackerPlayer = IsPlayer(attackerInfo.attacker);

	if(isAttackerPlayer)
	{
		threat *= 10;
	}
	
	distanceFromAttackerSqr = Distance2DSquared( entity.origin, attackerInfo.attacker.origin );
	normalizedDistanceFromAttacker = 0; 
	
	if(isAttackerPlayer)
	{
		if(distanceFromAttackerSqr <= ( (128) * (128) ))
		{
			threat *= 1000;
		}
		else
		{
			normalizedDistanceFromAttacker = distanceFromAttackerSqr / ( (entity.engageMaxFalloffDist) * (entity.engageMaxFalloffDist) );
			
			if(normalizedDistanceFromAttacker > 1)
				normalizedDistanceFromAttacker = 1;
			
			normalizedDistanceFromAttacker = 1 - normalizedDistanceFromAttacker;
		}
	}
	
	normalizedDamageFromAttacker = attackerInfo.damage / 1000;
	
	if(normalizedDamageFromAttacker > 1)
		normalizedDamageFromAttacker = 1;
	
	threat *= (normalizedDistanceFromAttacker * 0.65 + normalizedDamageFromAttacker * ( 1 - 0.65)) * 100;
	
	return threat;
}

function ShouldSwitchToNewThreat( entity, attacker, threat)
{	
	if(entity.enemy === attacker)
		return false;
	
	if(!isdefined(entity.currentDangerousAttacker))
		return true;
	
	if(entity.currentDangerousAttacker.Health <= 0)
		return true;
	
	if(entity.currentDangerousAttacker == attacker)
		return false;

	if(GetTime() - entity.lastDangerousAttackerTime < 1)
		return false;
	
	return true;
}

function UpdateAttackersList( entity, newAttacker, damage)
{
	if(!isdefined(entity.knownAttackers))
	{
		entity.knownAttackers = [];
	}
	
	maxThreat = 0;
	threatCount = 0;
	
	for(i = 0; i < entity.knownAttackers.size; i++)
	{
		attacker = entity.knownAttackers[i].attacker;
		
		if(!isdefined(attacker) || !IsEntity(attacker) || attacker.health <= 0 || (GetTime() - entity.knownAttackers[i].lastAttackTime) > 5000)
		{
			ArrayRemoveIndex(entity.knownAttackers, i);
			
			i--;
			continue;
		}
		
		//Check to see if this is a high immediate threat 
		entity.knownAttackers[i].threat = ComputeAttackerThreat(entity, entity.knownAttackers[i]);
		
		if(entity.knownAttackers[i].threat > maxThreat)
		{
			maxThreat = entity.knownAttackers[i].threat;
			dangerousAttackerInfo = entity.knownAttackers[i];
		}
	}
	
	if(isdefined(newAttacker))
	{
		for(i = 0; i < entity.knownAttackers.size; i++)
		{
			if(entity.knownAttackers[i].attacker == newAttacker)
			{
				attackData = entity.knownAttackers[i];
				attackData.lastAttackTime = GetTime();
				attackData.damage += damage;
				
				break;
			}
		}
		
		if(!isdefined(attackData))
		{
			attackData = SpawnStruct();
			attackData.attacker = newAttacker;
			attackData.lastAttackTime = GetTime();
			attackData.damage = damage;
			attackData.threat = 0;
			
			if ( !isdefined( entity.knownAttackers ) ) entity.knownAttackers = []; else if ( !IsArray( entity.knownAttackers ) ) entity.knownAttackers = array( entity.knownAttackers ); entity.knownAttackers[entity.knownAttackers.size]=attackData;;
		}
		
		//Check to see if this new attacker is a high immediate threat 
		attackData.threat = ComputeAttackerThreat(entity, attackData);
		
		if(attackData.threat > maxThreat)
		{
			maxThreat = attackData.threat;
			dangerousAttackerInfo = attackData;
		}
	}
	
	if(isdefined(dangerousAttackerInfo) && maxThreat > 0)
	{
		if(ShouldSwitchToNewThreat( entity, dangerousAttackerInfo.attacker, maxThreat))
		{
			thread WarlordDangerousEnemyAttack( entity, dangerousAttackerInfo.attacker, maxThreat);
		}
	}
	
	//if we are not moving then move if we are getting multiple damage
	CheckifWeShouldMove(entity);
}

function CheckifWeShouldMove( entity )
{
	if(!isdefined(entity.knownAttackers) || entity.knownAttackers.size <= 1)
		return;
	
	isStandStill = false;
	if(AtPreferedPoint(entity))
	{
		//at least allow a second for the warlord to stand on the prefered point before moving him
		if(!isdefined(entity.current_prefered_point_start_time) || GetTime() - entity.current_prefered_point_start_time < 1)
		{
			return;
		}

		isStandStill = true;
	}
	
	if(!isStandStill)
	{
		if(isdefined(entity.pathGoalPos))
		{
			if( (Distance2DSquared(entity.pathGoalPos, entity.origin) < ( (36) * (36) )) && (abs(entity.pathGoalPos[2] - entity.origin[2]) < (90 / 2)) )
			{
				isStandStill = true;
			}
		}
	}
	
	if(isStandStill)
	{
		dangerousAttackersCount = 0;
		
		foreach(attackerInfo in entity.knownAttackers)
		{
			if(attackerInfo.damage > 200)
			{
				dangerousAttackersCount++;
			}
		}
		
		//if we are taking fire from many attackers start moving
		if(dangerousAttackersCount > 1)
		{	
			ClearPreferedPoint( entity );
			entity.nextFindBetterPositionTime = 0;
		}
	}
}

function WarlordDangerousEnemyAttack( entity, attacker, threat)
{
	entity endon("disconnect");
	entity endon("death");
	attacker endon("death");
	
	entity endon("angry_attack");
	
	entity notify("dangerous_attack");
	entity endon("dangerous_attack");
	
	entity.lastDangerousAttackerTime = GetTime();
	entity.currentDangerousAttacker = attacker;
	entity.currentMaxThreat = threat;
	
	/#
	WarlordDebugHelpers::PrintState(0, (0, 1, 0), " STARTED");
	#/
	
	shootTime = GetDVarFloat("warlordangryattack", 3);
	entity ai::shoot_at_target("normal", attacker, undefined, shootTime, undefined, true);
	
	entity.currentDangerousAttacker = undefined;
	
	/#
	WarlordDebugHelpers::PrintState(0, (0, 0, 1), " ENDED");
	#/
}

function warlordDamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal )
{
	entity = self;

	//Non-player enemies should be very ineffective on the warlord
	if(!IsPlayer(eAttacker))
	{
		iDamage = int(iDamage * 0.05);
	}
	
	if ( isdefined(sMeansOfDeath) && ( sMeansOfDeath == "MOD_PROJECTILE" || sMeansOfDeath == "MOD_PROJECTILE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSIVE" || sMeansOfDeath == "MOD_GRENADE" ) )
	{
		iDamage = int(iDamage * 0.25);
	}
	
	//maintain attackers list
	UpdateAttackersList( entity, eAttacker, iDamage);
	
	if ( entity.health <= entity.damageHeavyStateHealth )
	{
		clientfield::set( "warlord_damage_state", 2 );
	}
	else if ( entity.health <= entity.damageStateHealth )
	{
		clientfield::set( "warlord_damage_state", 1 );
	}
	else
	{
		clientfield::set( "warlord_damage_state", 0 );
	}
	
	if(!isdefined(entity.LastDamageTime))
	{
		entity.LastDamageTime = 0;
	}
	
	if((GetTime() - entity.LastDamageTime) > 1500)
	{
		entity.AccumilatedDamage = iDamage;
	}
	else
	{
		entity.AccumilatedDamage += iDamage;
	}

	WARLORD_HUNT_MAX_ACCUMILATED_DAMAGE_VAR = GetDVarInt("warlordhuntdamage", 350);

	if(entity.AccumilatedDamage > WarlordServerUtils::GetScaledForPlayers(WARLORD_HUNT_MAX_ACCUMILATED_DAMAGE_VAR, 1.5, 2, 2.5) )
	{		
		self.HuntEnemyTime = GetTime() + 15000;
	}
	
	entity.LastDamageTime = GetTime();
	
	return iDamage;
}

function warlordSpawnSetup()
{
	entity = self;
	
	entity.WarlordAggressiveMode = false;
	entity.isAngryAttack = false;
	entity.nextExposedPain = 0;
	entity.lastDangerousAttackerTime = 0;
	entity.currentMaxThreat = 0;
	
	entity.combatmode = "no_cover";
	
	AiUtility::AddAIOverrideDamageCallback( entity, &WarlordServerUtils::warlordDamageOverride );
	
	entity.health = int(GetScaledForPlayers(entity.health, 2, 2.5, 3));
	
	entity.fullHealth = entity.health;
	entity.damageStateHealth = Int( entity.fullHealth * 0.5 );
	entity.damageHeavyStateHealth = Int( entity.fullHealth * 0.25 );
	
	entity warlord_projectile_watcher();
	
	clientfield::set( "warlord_damage_state", 0 );
	
	switch (entity.classname)
	{
	case "actor_spawner_bo3_warlord_enemy_hvt":
		clientfield::set( "warlord_type", 2 );
		break;
	default:
		clientfield::set( "warlord_type", 1 );
		break;
	}
}

function warlord_projectile_watcher()
{
	if( !isdefined( self.missile_repulsor ) ) 
	{
		self.missile_repulsor = missile_createrepulsorent( self, 40000, 256, true );
	}
	self thread repulsor_fx();
}


function remove_repulsor()
{
	self endon( "death" );
	
	if( isdefined( self.missile_repulsor ) ) 
	{
		missile_deleteattractor( self.missile_repulsor );
		self.missile_repulsor = undefined;
	}

	wait 0.5;
	
	if(isdefined(self))
	{
		self warlord_projectile_watcher();
	}
}

function repulsor_fx()
{
	self endon( "death" );
	self endon( "killing_repulsor" );
	
	while( 1 )
	{	
		self util::waittill_any( "projectile_applyattractor", "play_meleefx" );

		PlayFxOnTag( "vehicle/fx_quadtank_airburst", self, "tag_origin" );
		PlayFxOnTag( "vehicle/fx_quadtank_airburst_ground", self, "tag_origin" );

		self PlaySound( "wpn_trophy_alert" );
		
		self thread remove_repulsor();
		self notify( "killing_repulsor" );

	}
}

function trigger_player_shock_fx()
{
	if ( !isdefined( self._player_shock_fx_quadtank_melee ) )
	{
		self._player_shock_fx_quadtank_melee = 0;
	}

	self._player_shock_fx_quadtank_melee = !self._player_shock_fx_quadtank_melee;
	self clientfield::set_to_player( "player_shock_fx", self._player_shock_fx_quadtank_melee );
}

// end #namespace WarlordServerUtils;

#namespace WarlordDebugHelpers;

function PrintState(state, color, string)
{
	
/#
	if(GetDvarInt("ai_debugWarlord") > 0)
	{
		if(!isdefined(string))
		{
			string = "";
		}
		
		
		if(!isdefined(state))
		{
			if(!isdefined(self) || !isdefined(self.lastMessage) || self.lastMessage != string)
			{
				self.lastMessage = string;
				PrintTopRightln(string + GetTime(), color, -1 );
			}
			return;
		}
		
		if(state == 0)
		{
			PrintTopRightln("WARLORD_STATE_THREAT " + string + GetTime(), color, -1 );
		}
		else if(state == 1)
		{
			PrintTopRightln("WARLORD_STATE_ANGRY " + string + GetTime(), color, -1 );	
		}
		else if(state == 2)
		{
			PrintTopRightln("WARLORD_STATE_MOVE_FROM_DANGER " + string + GetTime(), color, -1 );	
		}
		else if(state == 3)
		{
			PrintTopRightln("WARLORD_STATE_HUNT " + string + GetTime(), color, -1 );	
		}
		else if(state == 4)
		{
			PrintTopRightln("WARLORD_STATE_PREFERED_POINT " + string + GetTime(), color, -1 );	
		}
		else if(state == 5)
		{
			PrintTopRightln("WARLORD_STATE_NORMAL_POINT " + string + GetTime(), color, -1 );	
		}
		else if(state == 6)
		{
			PrintTopRightln("WARLORD_STATE_GOAL " + string + GetTime(), color, -1 );	
		}
	}
#/	

}

function TryState(entity, state, bCheckNew)
{
	/#
	if(GetDvarInt("ai_debugWarlord") > 0)
	{
		if( !(isdefined(bCheckNew) && IsNewState( entity, state)) )
		{
			color = (1, 1, 1);
		
			entity PrintState( state, color );
		}
	}
	#/
}

function SetCurrentState( entity, state, bCanUpdate = false )
{
	/#
	if(GetDvarInt("ai_debugWarlord") > 0)
	{
		if(!isdefined(bCanUpdate) || IsNewState( entity, state))
		{
			color = (0, 1, 0);
		}
		else
		{
			color = (0, 1, 1);
		}
		
		if(!isdefined(state))
		{
			color = (0, 0, 1);
			entity PrintState( entity.currentState, color, " ENDED" );
		}
		
		entity PrintState( state, color );
	}
	#/
		
	entity.currentState = state;	
}

function SetStateFailed( entity, state )
{
	/#
	if(GetDvarInt("ai_debugWarlord") > 0)
	{
		color = (1, 1, 0);
		
		entity PrintState( state, color );
	}
	#/
}

function IsNewState( entity, state )
{
	bNewState = false;
	
	if(!isdefined(entity.currentState))
	{
		bNewState = true;
	}
	else if(!isdefined(state))
	{
		return false;
	}
	else if(entity.currentState != state)
	{
		bNewState = true;
	}
	
	return bNewState;
}

// end #namespace WarlordDebugHelpers;