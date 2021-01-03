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


                                                                                                             	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                              	   	                             	  	                                      
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  	   	   	   	   	   	                  	                                                                                                                                                                                                           	      	                        	   	   	   	   	   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  	    	                                                                                                                                                                                                         

#precache( "fx", "vehicle/fx_quadtank_airburst" );
#precache( "fx", "vehicle/fx_quadtank_airburst_ground" );
#precache( "fx", "light/fx_light_eye_glow_warlord" );



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
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("swarm",&WarlordAngryAttack);;
	
	// ------- WARLORD CONDITIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordCanJukeCondition",&canJukeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordCanTacticalJukeCondition",&canTacticalJukeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordShouldBeAngryCondition",&shouldBeAngryCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("warlordShouldNormalMelee",&warlordShouldNormalMelee);;
	
	
	// ------- WARLORD ACTIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("warlordDeathAction",&deathAction,undefined,undefined);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("warlordJukeAction",&jukeAction,undefined,&jukeActionTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("warlordAngryAction",&angryAction,undefined,&angryActionTerminate);;
	
	// ------- WARLORD SERVICES -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("chooseBetterPositionService",&chooseBetterPositionService);;
}


function private          ArchetypeWarlordBlackboardInit()
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
	if ( Distance2DSquared( entity.origin, self LastKnownPos(self.enemy) ) <= ( (250) * (250) ) )
	{
		return false;
	}
	
	if ( isdefined( entity.huntUpdateNextTime ) && GetTime() < entity.huntUpdateNextTime )
	{
		return false;
	}
	
	if( entity.PreferedPosition_priority === 2 ) //must priority..we have to respect that
	{
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
			entity UsePosition( closestPoint );
			entity.huntUpdateNextTime = GetTime() + RandomIntRange( 500, 1500 );
			return true;
		}
		else
		{
			entity.HuntEnemyTime = undefined;
		}
	}
	
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
	
	//ToDo - mali 3/12/2015: limit the number of Sight checks
	if( (self.GoalRadius < 36 * 2) || self.forcedGoal === true)  //1- Should go to goal directly if forced
	{
		if(!bApproachingGoal)
		{
			entity UsePosition( self.GoalPos );
		}
		
		return true;
	}
	else if(entity.isAngryAttack === true && GetDVarFloat("warlordangryattackstand", 0) >= 2)
	{
		return true;
	}
	else if(bApproachingGoal && shouldHuntEnemyPlayer(entity)) 					//2- Should hunt enemy
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
	else if(!bApproachingGoal)													 //4- Should go to goal if outside it
	{
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
	
	if (!bApproachingGoal || !isdefined( entity.nextFindBetterPositionTime ) ||	GetTime() > entity.nextFindBetterPositionTime) //ShouldRepath if we are outside the goal or we are bored
	{
		shouldRepath = true;
	}
	
	if ( !shouldRepath && isdefined( entity.enemy ) && !entity SeeRecently( entity.enemy, 2 ) ) //ShouldRepath if we lost the enemy
	{
		isTrackingEnemyLastPos = true;
		
		//if the warlord is moving near the lastKnowEnemyPos give it a chance to reach there
		if(isdefined(entity.pathGoalPos))
		{
			distanceToGoalSqr = DistanceSquared(searchOrigin, entity.pathGoalPos);
			shouldRepath = distanceToGoalSqr < ( (200) * (200) );
		}
		else
		{
			shouldRepath = true;
		}
	}
	
	if (shouldRepath)
	{
/////////// Find points around the enemy.
		queryResult = PositionQuery_Source_Navigation( searchOrigin, 0, entity.engagemaxdist, 0.5 * 90, 36 * 2, entity, 36 * 3 );
			
		PositionQuery_Filter_InClaimedLocation( queryResult, entity );
		PositionQuery_Filter_DistanceToGoal(queryResult, entity);
	
	//ToDo - mali 3/12/2015: limit the number of Sight checks		
	/*	
		//if there is an enemy try to pick the points that sees it, early out after 20 successful checks
		if(isdefined( entity.enemy ))
		{
			PositionQuery_Filter_Sight(queryResult, self LastKnownPos(self.enemy), self GetEye() - self.origin, self, 20);
		}
	*/
		// Throw away points close to the current position or outside the goalradius.
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
		
		//Get Valid Prefered Points
		preferedPoints = WarlordServerUtils::GetPreferedValidPoints(entity);
		
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
				if(isdefined( entity.enemy ))
				{
					PositionQuery_Filter_Sight(queryResult, self LastKnownPos(self.enemy), self GetEye() - self.origin, self, 20);
				}*/
				
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
			
			//Warlord prefers far locations unless it is tracking the player
			bWeightSign = 1;
			if(isdefined(isTrackingEnemyLastPos))
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
		
		foreach(point in preferedPoints)
		{
			pointWeight = RandomFloatRange(-1.25, 1.25);
			
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
					WarlordServerUtils::SetPreferedPoint( entity, preferedPoint );
				}
				
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
	
	if(	AiUtility::hasCloseEnemyToMeleeWithRange( behaviorTreeEntity, ( (94) * (94) )) )
		return true;

	return false;
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


// ------- Angry -----------//	
function shouldBeAngryCondition( behaviorTreeEntity )
{
	if(isdefined(behaviorTreeEntity.nextAngryTime) && (GetTime() < behaviorTreeEntity.nextAngryTime) )
		return false;
	
	if(behaviorTreeEntity.knownAttackers.size == 0)
	{
		return false;
	}
	else if(behaviorTreeEntity.knownAttackers.size == 1 && isdefined(behaviorTreeEntity.enemy) && behaviorTreeEntity.knownAttackers[0].attacker == behaviorTreeEntity.enemy) //if attacker is enemy and we only have one attacker
	{
		if(WarlordServerUtils::GetAlivePlayersCount(behaviorTreeEntity) > 1)
		{
			return false;
		}
		else if( !IsPlayer(behaviorTreeEntity.enemy) )
		{
			return false;
		}
	}
	
	
	if(isdefined(behaviorTreeEntity.AccumilatedDamage) && behaviorTreeEntity.AccumilatedDamage > WarlordServerUtils::GetScaledForPlayers(200, 1.5, 2, 2.5) )
		return true;
	
	return behaviorTreeEntity.isAngry;
}

function angryAction( behaviorTreeEntity, asmStateName )
{
	WarlordServerUtils::UpdateAttackersList( behaviorTreeEntity );
		
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	if(GetDVarFloat("warlordangryattackstand", 0) >= 1)
	{
		positionOnNavMesh = GetClosestPointOnNavMesh( behaviorTreeEntity.origin, 200 );
		
		if ( !isdefined( positionOnNavMesh ) )
		{
			positionOnNavMesh = behaviorTreeEntity.origin;
		}
		
		behaviorTreeEntity UsePosition( positionOnNavMesh );
	}
	
	return 5;
}


function angryActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviorTreeEntity.nextAngryTime = GetTime() + 13000;
	behaviorTreeEntity.AccumilatedDamage = 0;
	
	return 4;
}

function WarlordAngryAttack( entity )
{
	entity.isAngryAttack = true;
	entity.forceFire = true;
	
	attackersArray = [];
	
	foreach(data in entity.knownAttackers)
	{
		if ( !isdefined( attackersArray ) ) attackersArray = []; else if ( !IsArray( attackersArray ) ) attackersArray = array( attackersArray ); attackersArray[attackersArray.size]=data.attacker;;
	}
	
	thread WarlordAngryAttack_ShootThemAll(entity, attackersArray);
}

function WarlordAngryAttack_ShootThemAll( entity, attackersArray )
{
	entity endon("disconnect");
	entity endon("death");
	
	shootTime = GetDVarFloat("warlordangryattack", 3);
	
	foreach(attacker in attackersArray)
	{
		if(isdefined(attacker))
		{
			/#
				//RecordLine( entity.origin, attacker.origin, (1,0,0), "Script", self );
				//sphere( attacker.origin, 15, (0,1,0), 1, false, 8, 100 );
				//line (entity.origin, attacker.origin, (1,0,0), false, 100);
			#/
				
			entity ai::shoot_at_target("normal", attacker, undefined, shootTime, undefined, true);
		}
	}
	
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


function AddPreferedPoint(entity, position, min_duration, max_duration, name)
{
	position = GetClosestPointOnNavMesh( position, 200, 25 );
	
	if(!isdefined(position))
	{
		/#	println( "^3Warning: Passing Warlord prefered point that is not on the NavMesh or is in invalid location: " + position ); 	#/
		return;
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
	entity.current_prefered_point = point;
}

function private ClearPreferedPoint( entity)
{
	entity.current_prefered_point_expiration = undefined;
	entity.current_prefered_point = undefined;
}

function private AtPreferedPoint(entity)
{
	if(isdefined(entity.current_prefered_point) && ( (Distance2DSquared(entity.current_prefered_point.origin, entity.origin) < ( (36) * (36) )) && (abs(self.current_prefered_point.origin[2] - entity.origin[2]) < (90 / 2)) ) )
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
					time = GetTime();
					ClearPreferedPoint(entity);
					return false;
				}
			}
			else
			{
				if(isdefined(entity.current_prefered_point.min_duration))
				{
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
			}
			
			return false;
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

function UpdateAttackersList( entity, newAttacker)
{
	if(!isdefined(entity.knownAttackers))
	{
		entity.knownAttackers = [];
	}
	
	for(i = 0; i < entity.knownAttackers.size; i++)
	{
		attacker = entity.knownAttackers[i].attacker;
		
		if(!isdefined(attacker) || !IsEntity(attacker) || (GetTime() - entity.knownAttackers[i].lastAttackTime) > 5000)
		{
			ArrayRemoveIndex(entity.knownAttackers, i);
			
			i--;
			continue;
		}
	}
	
	if(isdefined(newAttacker))
	{
		bExist = false;

		for(i = 0; i < entity.knownAttackers.size; i++)
		{
			if(entity.knownAttackers[i].attacker == newAttacker)
			{
				bExist = true;
				entity.knownAttackers[i].lastAttackTime = GetTime();
				
				break;
			}
		}
		
		if(!bExist)
		{
			attackData = SpawnStruct();
			attackData.attacker = newAttacker;
			attackData.lastAttackTime = GetTime();
			
			if ( !isdefined( entity.knownAttackers ) ) entity.knownAttackers = []; else if ( !IsArray( entity.knownAttackers ) ) entity.knownAttackers = array( entity.knownAttackers ); entity.knownAttackers[entity.knownAttackers.size]=attackData;;
		}
	}
}

function warlordDamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, timeOffset, boneIndex, modelIndex, surfaceType, surfaceNormal )
{
	entity = self;

	//Non-player enemies should be very ineffective on the warlord
	if(!IsPlayer(eAttacker))
	{
		iDamage = int(iDamage / 20);
	}
	
	//maintain attackers list
	UpdateAttackersList( entity, eAttacker);
	
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
	
	if(entity.AccumilatedDamage > WarlordServerUtils::GetScaledForPlayers(150, 1.5, 2, 2.5) )
	{
		self.HuntEnemyTime = GetTime() + 15000;
	}
	
	entity.LastDamageTime = GetTime();
	
	return iDamage;
}

function warlordSpawnSetup()
{
	entity = self;
	
	entity.isAngry = false;
	
	entity.combatmode = "no_cover";
	
	entity.overrideActorDamage = &warlordDamageOverride;
	
	entity.health = int(GetScaledForPlayers(entity.health, 2, 2.5, 3));
	
	entity.fullHealth = entity.health;
	entity.damageStateHealth = Int( entity.fullHealth * 0.5 );
	entity.damageHeavyStateHealth = Int( entity.fullHealth * 0.25 );
	
	playFXOnTag( "light/fx_light_eye_glow_warlord" , entity , "tag_eyeglow_left" );
	playFXOnTag( "light/fx_light_eye_glow_warlord" , entity , "tag_eyeglow_right" );
	playFXOnTag( "light/fx_light_eye_glow_warlord" , entity , "tag_jets_right_front" );
	playFXOnTag( "light/fx_light_eye_glow_warlord" , entity , "tag_jets_left_front" );
	
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
	if( isdefined( self.missile_repulsor ) ) 
	{
		missile_deleteattractor( self.missile_repulsor );
		self.missile_repulsor = undefined;
	}
	
	wait 0.5;
	
	self warlord_projectile_watcher();
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
