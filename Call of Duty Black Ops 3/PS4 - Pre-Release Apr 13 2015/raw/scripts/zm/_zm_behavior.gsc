#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\zombie;
#using scripts\shared\ai\zombie_utility;

#using scripts\zm\_zm_behavior_utility;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                           	                                     	                                                                                                                                                                                                         
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                              	   	                             	  	                                      

                                                                                                                                  


#namespace zm_behavior;

function autoexec init()
{
	// INIT BEHAVIORS
	InitZmBehaviorsAndASM();
}

function private InitZmBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieFindFleshService",&zombieFindFlesh);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieEnteredPlayableService",&zombieEnteredPlayable);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieJukeService",&zombieJuke);;

	// functionName, functionPtr, functionParamCount // functionParam names (For documentation purposes)

	// ------- BEHAVIOR CONDITIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMove",&shouldMoveCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldTear",&zombieShouldTearCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldAttackThroughBoards",&zombieShouldAttackThroughBoardsCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldTaunt",&zombieShouldTauntCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGotToEntrance",&zombieGotToEntranceCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGotToAttackSpot",&zombieGotToAttackSpotCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieHasAttackSpotAlready",&zombieHasAttackSpotAlreadyCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldEnterPlayable",&zombieShouldEnterPlayableCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isChunkValid",&isChunkValidCondition);;
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("inPlayableArea",&inPlayableArea);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("shouldSkipTeardown",&shouldSkipTeardown);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsThinkDone",&zombieIsThinkDone);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsAtGoal",&zombieIsAtGoal);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIsAtEntrance",&zombieIsAtEntrance);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMoveAway",&zombieShouldMoveAwayCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledByTesla",&wasKilledByTeslaCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledByInterdimensionalGun",&wasKilledByInterdimensionalGunCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasCrushedByInterdimensionalGunBlackhole",&wasCrushedByInterdimensionalGunBlackholeCondition);;

	// ------- BEHAVIOR UTILITY -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("disablePowerups",&disablePowerups);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("enablePowerups",&enablePowerups);;

	// ------- ZOMBIE LOCOMOTION -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMoveAction",&zombieMoveAction,&zombieMoveActionUpdate,undefined);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMoveToEntranceAction",&zombieMoveToEntranceAction,undefined,&zombieMoveToEntranceActionTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMoveToAttackSpotAction",&zombieMoveToAttackSpotAction,undefined,&zombieMoveToAttackSpotActionTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieIdleAction",undefined,undefined,undefined);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMoveAway",&zombieMoveAway,undefined,undefined);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieTraverseAction",&zombieTraverseAction,undefined,&zombieTraverseActionTerminate);;
	
	// ------- ZOMBIE TEAR DOWN -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("holdBoardAction",&zombieHoldBoardAction,undefined,&zombieHoldBoardActionTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("grabBoardAction",&zombieGrabBoardAction,undefined,&zombieGrabBoardActionTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("pullBoardAction",&zombiePullBoardAction,undefined,&zombiePullBoardActionTerminate);;
	// ------- ZOMBIE MELEE BEHIND BOARDS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieAttackThroughBoardsAction",&zombieAttackThroughBoardsAction,undefined,&zombieAttackThroughBoardsActionTerminate);;
	// ------- ZOMBIE TAUNT -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieTauntAction",&zombieTauntAction,undefined,&zombieTauntActionTerminate);;
	// ------- ZOMBIE BOARD MANTLE -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieMantleAction",&zombieMantleAction,undefined,&zombieMantleActionTerminate);;
	
	// ------- ZOMBIE SERVICES -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("getChunkService",&getChunkService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("updateChunkService",&updateChunkService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("updateAttackSpotService",&updateAttackSpotService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("findNodesService",&findNodesService);;
	
	// ------- ZOMBIE MOCOMP -----------//
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_board_tear@zombie",&boardTearMocompStart,&boardTearMocompUpdate,undefined);;
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_barricade_enter@zombie",&barricadeEnterMocompStart,&barricadeEnterMocompUpdate,&barricadeEnterMocompTerminate);;

	// ------- ZOMBIE NOTETRACKS -----------//
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("destroy_piece",&notetrackBoardTear);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("zombie_window_melee",&notetrackBoardMelee);;
	
	// ------- ZOMBIE DEATH -----------//
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_death_idgun@zombie",&zombieIDGunDeathMocompStart,&zombieIDGunDeathMocompUpdate,undefined);;
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_death_idgun_hole@zombie",&zombieIDGunHoleDeathMocompStart,undefined,&zombieIDGunHoleDeathMocompTerminate);;
}

// ------- BEHAVIOR CONDITIONS -----------//
function zombieFindFlesh( behaviorTreeEntity )
{
	if( level.intermission )
	{
		return;
	}

	behaviorTreeEntity.ignoreme = false; // don't let attack dogs give chase until the zombie is in the playable area

	behaviorTreeEntity.ignore_player = [];

	behaviorTreeEntity.goalradius = 30;

	if ( zm_behavior::zombieShouldMoveAwayCondition( behaviorTreeEntity ) )
	{
		return;
	}

	zombie_poi = undefined;

	if( IsDefined( level._poi_override ) )
	{
		zombie_poi = behaviorTreeEntity [[ level._poi_override ]]();
	}

	if( !IsDefined( zombie_poi ) )
	{
		zombie_poi = behaviorTreeEntity zm_utility::get_zombie_point_of_interest( behaviorTreeEntity.origin );	
	}
	
	players = GetPlayers();
				
	// If playing single player, never ignore the player
	if( !isdefined(behaviorTreeEntity.ignore_player) || (players.size == 1) )
	{
		behaviorTreeEntity.ignore_player = [];
	}
	else if(!isDefined(level._should_skip_ignore_player_logic) || ![[level._should_skip_ignore_player_logic]]() )
	{
		i=0;
		while (i < behaviorTreeEntity.ignore_player.size)
		{
			if( IsDefined( behaviorTreeEntity.ignore_player[i] ) && IsDefined( behaviorTreeEntity.ignore_player[i].ignore_counter ) && behaviorTreeEntity.ignore_player[i].ignore_counter > 3 )
			{
				behaviorTreeEntity.ignore_player[i].ignore_counter = 0;
				behaviorTreeEntity.ignore_player = ArrayRemoveValue( behaviorTreeEntity.ignore_player, behaviorTreeEntity.ignore_player[i] );
				if (!IsDefined(behaviorTreeEntity.ignore_player))
					behaviorTreeEntity.ignore_player = [];
				i=0;
				continue;
			}
			i++;
		}
	}

	player = zm_utility::get_closest_valid_player( behaviorTreeEntity.origin, behaviorTreeEntity.ignore_player );

	if( !isDefined( player ) && !isDefined( zombie_poi ) )
	{
		//behaviorTreeEntity zm_spawner::zombie_history( "find flesh -> can't find player, continue" );
		if( IsDefined( behaviorTreeEntity.ignore_player )  )
		{
			if(isDefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]() )
			{
				return;
			}			
			behaviorTreeEntity.ignore_player = [];
		}
		
		/#
		if( ( isdefined( behaviortreeentity.isPuppet ) && behaviortreeentity.isPuppet ) )
		{
			return;
		}
		#/
		
		behaviorTreeEntity SetGoal( behaviorTreeEntity.origin );
		return;
	}
	
	//PI_CHANGE - 7/2/2009 JV Reenabling change 274916 (from DLC3)
	//behaviorTreeEntity.ignore_player = undefined;
	if ( !isDefined( level.check_for_alternate_poi ) || ![[level.check_for_alternate_poi]]() )
	{
		behaviorTreeEntity.enemyoverride = zombie_poi;
		
		behaviorTreeEntity.favoriteenemy = player;
	}
	
	if ( IsDefined( behaviorTreeEntity.enemyoverride ) && IsDefined( behaviorTreeEntity.enemyoverride[1] ) )
	{
		goalPos = behaviorTreeEntity.enemyoverride[0];
		queryResult = PositionQuery_Source_Navigation( goalPos, 0, 48, 36, 4 );
		foreach( point in queryResult.data )
		{
			goalPos = point.origin;
			break;
		}
		behaviorTreeEntity SetGoal( goalPos );
		
	}
	else if ( IsDefined( behaviorTreeEntity.favoriteenemy ) )
	{
		behaviorTreeEntity.ignoreall = false;

		if ( IsDefined( level.enemy_location_override_func ) )
		{
			goalPos = [[ level.enemy_location_override_func ]]( behaviorTreeEntity, behaviorTreeEntity.favoriteenemy );

			if ( IsDefined( goalPos ) )
			{
				behaviorTreeEntity SetGoal( goalPos );
			}
			else
			{
				behaviorTreeEntity zombieUpdateGoal();
			}
		}
		else if( ( isdefined( behaviorTreeEntity.is_rat_test ) && behaviorTreeEntity.is_rat_test ) )
		{
		}
		else if ( zm_behavior::zombieShouldMoveAwayCondition( behaviorTreeEntity ) )
		{
		}
		else if ( IsDefined( behaviorTreeEntity.favoriteenemy.last_valid_position ) )
		{
			behaviorTreeEntity zombieUpdateGoal();
		}
		else
		{
			//AssertMsg( "no last_valid_position" );
		}
	}
	
	//PI_CHANGE_BEGIN - 7/2/2009 JV Reenabling change 274916 (from DLC3)
	if( players.size > 1 )
	{
		for(i = 0; i < behaviorTreeEntity.ignore_player.size; i++)
		{
			if( IsDefined( behaviorTreeEntity.ignore_player[i] ) )
			{
				if( !IsDefined( behaviorTreeEntity.ignore_player[i].ignore_counter ) )
					behaviorTreeEntity.ignore_player[i].ignore_counter = 0;
				else
					behaviorTreeEntity.ignore_player[i].ignore_counter += 1;
			}
		}
	}
	//PI_CHANGE_END
}

function zombieUpdateGoal()
{
	shouldRepath = false;
	
	if ( !shouldRepath && IsDefined( self.favoriteenemy ) )
	{
		if ( !IsDefined( self.nextGoalUpdate ) || self.nextGoalUpdate <= GetTime() )
		{
			// It's been a while, repath!
			shouldRepath = true;
		}
		else if ( DistanceSquared( self.origin, self.favoriteenemy.origin ) <= ( (60) * (60) ) )
		{
			// Repath if close to the enemy.
			shouldRepath = true;
		}
		else if ( IsDefined( self.pathGoalPos ) )
		{
			// Repath if close to the current goal position.
			distanceToGoalSqr = DistanceSquared( self.origin, self.pathGoalPos );
			
			shouldRepath = distanceToGoalSqr < ( (72) * (72) );
		}
	}

	if ( ( isdefined( self.keep_moving ) && self.keep_moving ) )
	{
		if ( GetTime() > self.keep_moving_time )
		{
			self.keep_moving = false;
		}
	}

	if ( shouldRepath )
	{
		goalPos = self.favoriteenemy.origin;
		if ( IsDefined( self.favoriteenemy.last_valid_position ) )
		{
			goalPos = self.favoriteenemy.last_valid_position;
		}
		self SetGoal( goalPos );
		
		// Randomized zig-zag path following if 20+ feet away from the enemy.
		if ( DistanceSquared( self.origin, self.favoriteenemy.last_valid_position ) > ( (240) * (240) ) )
		{
			self.keep_moving = true;
			self.keep_moving_time = GetTime() + 250;
			path = self CalcApproximatePathToPosition( self.favoriteenemy.last_valid_position,false );
			
			/#
			if ( GetDvarInt( "ai_debugZigZag" ) )
			{
				for ( index = 1; index < path.size; index++ )
				{
					RecordLine( path[index - 1], path[index], ( 1, .5, 0 ), "Animscript", self );
				}
			}
			#/
		
			deviationDistance = RandomIntRange( 240, 480 );  // 20 to 40 feet
		
			segmentLength = 0;
		
			// Walks the current path to find the point where the AI should deviate from their normal path.
			for ( index = 1; index < path.size; index++ )
			{
				currentSegLength = Distance( path[index - 1], path[index] );
				
				if ( ( segmentLength + currentSegLength ) > deviationDistance )
				{
					remainingLength = deviationDistance - segmentLength;
				
					seedPosition = path[index - 1] + ( VectorNormalize( path[index] - path[index - 1] ) * remainingLength );
				
					/# RecordCircle( seedPosition, 2, ( 1, .5, 0 ), "Animscript", self ); #/
		
					innerZigZagRadius = 0;
					outerZigZagRadius = 96;
					
					// Find a point offset from the deviation point along the path.
					queryResult = PositionQuery_Source_Navigation(
						seedPosition,
						innerZigZagRadius,
						outerZigZagRadius,
						0.5 * 72,
						16,
						self,
						16 );
					
					PositionQuery_Filter_InClaimedLocation( queryResult, self );
		
					if ( queryResult.data.size > 0 )
					{
						point = queryResult.data[ RandomInt( queryResult.data.size ) ];
						
						// Use the deviated point as the path instead.
						self SetGoal( point.origin );
					}
				
					break;
				}
				
				segmentLength += currentSegLength;
			}
		}

		// Force repathing after a certain amount of time to smooth out movement.
		self.nextGoalUpdate = GetTime() + RandomIntRange(250, 500);
	}
}

function zombieEnteredPlayable( behaviorTreeEntity )
{
	if ( !IsDefined( level.playable_areas ) )
	{
		level.playable_areas = GetEntArray("player_volume", "script_noteworthy" );
	}

	foreach(area in level.playable_areas)
	{
		if(behaviorTreeEntity IsTouching(area))
		{
			behaviorTreeEntity zm_spawner::zombie_complete_emerging_into_playable_area();
			return true;
		}
	}

	return false;
}	

function zombieJuke( behaviorTreeEntity )
{
	if ( ( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) )
	{
		return false;
	}

	if ( IsDefined( behaviorTreeEntity.juke ) )
	{
		return false;
	}

	if ( !IsDefined( behaviorTreeEntity.next_juke_time ) )
	{
		behaviorTreeEntity.next_juke_time = GetTime() + RandomIntRange( 2500, 5000 );
	}

	if ( GetTime() > behaviorTreeEntity.next_juke_time )
	{
		if ( RandomInt( 100 ) < 50 )
		{
			if ( math::cointoss() )
			{
				behaviorTreeEntity.juke = "left";
			}
			else
			{
				behaviorTreeEntity.juke = "right";
			}
		}

		behaviorTreeEntity.next_juke_time = undefined;
	}
}

function shouldMoveCondition( behaviorTreeEntity )
{
	if ( behaviorTreeEntity HasPath() )
	{
		return true;
	}

	if ( ( isdefined( behaviorTreeEntity.keep_moving ) && behaviorTreeEntity.keep_moving ) )
	{
		return true;
	}

	return false;
}

function zombieShouldMoveAwayCondition( behaviorTreeEntity )
{
	return level flag::get( "wait_and_revive" );
}

function wasKilledByTeslaCondition( behaviorTreeEntity )
{
	if ( ( isdefined( behaviorTreeEntity.tesla_death ) && behaviorTreeEntity.tesla_death ) )
	{
		return true;
	}

	return false;
}

function wasKilledByInterdimensionalGunCondition( behaviorTreeEntity )
{
	if(isdefined(behaviorTreeEntity.interdimensional_gun_kill) && !isdefined(behaviorTreeEntity.killby_interdimensional_gun_hole))
	{
		return true;
	}

	return false;
}

function wasCrushedByInterdimensionalGunBlackholeCondition( behaviorTreeEntity )
{
	if(isdefined(behaviorTreeEntity.killby_interdimensional_gun_hole))
	{
		return true;
	}

	return false;
}

function disablePowerups( behaviorTreeEntity )
{
	behaviorTreeEntity.no_powerups = true;
}

function enablePowerups( behaviorTreeEntity )
{
	behaviorTreeEntity.no_powerups = false;
}

function zombieMoveAway( behaviorTreeEntity, asmStateName)
{
	player = util::GetHostPlayer();
	queryResult = level.move_away_points;
	
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	for(i = 0; i < queryResult.data.size; i++)
	{
		isBehind = vectordot( player.origin - behaviorTreeEntity.origin, queryResult.data[i].origin - behaviorTreeEntity.origin );
		if(isBehind < 0 )
		{
			behaviorTreeEntity SetGoal( queryResult.data[i].origin );
			ArrayRemoveIndex(level.move_away_points.data, i, false);
			i--;
			return 5;
		}
	}
	
	for(i = 0; i < queryResult.data.size; i++)
	{
		dist_zombie = DistanceSquared( queryResult.data[i].origin, behaviorTreeEntity.origin );
		dist_player = DistanceSquared( queryResult.data[i].origin, player.origin );

		if ( dist_zombie < dist_player )
		{
			behaviorTreeEntity SetGoal( queryResult.data[i].origin );
			ArrayRemoveIndex(level.move_away_points.data, i, false);
			i--;
			return 5;
		}
	}
	return 5;
}

function zombieTraverseAction( behaviorTreeEntity, asmStateName )
{
	AiUtility::traverseActionStart( behaviorTreeEntity, asmStateName );

	disablePowerups( behaviorTreeEntity );

	return 5;
}

function zombieTraverseActionTerminate( behaviorTreeEntity, asmStateName )
{
	if ( behaviorTreeEntity ASMGetStatus() == "asm_status_complete" )
	{
		enablePowerups( behaviorTreeEntity );
	}

	return 4;	
}

function zombieGotToEntranceCondition( behaviorTreeEntity )
{
	if( ( isdefined( behaviorTreeEntity.got_to_entrance ) && behaviorTreeEntity.got_to_entrance ) )
	{
		return true;
	}

	return false;
}

function zombieGotToAttackSpotCondition( behaviorTreeEntity )
{
	if( ( isdefined( behaviorTreeEntity.at_entrance_tear_spot ) && behaviorTreeEntity.at_entrance_tear_spot ) )
	{
		return true;
	}

	return false;
}

function zombieHasAttackSpotAlreadyCondition( behaviorTreeEntity )
{
	if( IsDefined( behaviorTreeEntity.attacking_spot_index ) && behaviorTreeEntity.attacking_spot_index >= 0 )
	{
		return true;
	}

	return false;
}

function zombieShouldTearCondition( behaviorTreeEntity )
{
	if( IsDefined( behaviorTreeEntity.first_node ) && IsDefined( behaviorTreeEntity.first_node.barrier_chunks ) )
	{
		if( !zm_utility::all_chunks_destroyed( behaviorTreeEntity.first_node, behaviorTreeEntity.first_node.barrier_chunks ) )
		{
			return true;
		}
	}
		
	return false;
}

function zombieShouldAttackThroughBoardsCondition( behaviorTreeEntity )
{
	if ( ( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) )
		return false;
	
	if( isdefined( behaviorTreeEntity.first_node.zbarrier ) )
	{
		if( !behaviorTreeEntity.first_node.zbarrier ZBarrierSupportsZombieReachThroughAttacks() )
		{
			return false;
		}
	}
	
	if(GetDvarString( "zombie_reachin_freq") == "")
	{
		SetDvar("zombie_reachin_freq","50");
	}
	freq = GetDvarInt( "zombie_reachin_freq");
	
	players = GetPlayers();
	attack = false;

    behaviorTreeEntity.player_targets = [];
    for(i=0;i<players.size;i++)
    {
    	if ( isAlive( players[i] ) && !isDefined( players[i].revivetrigger ) && distance2d( behaviorTreeEntity.origin, players[i].origin ) <= 109.8 && !( isdefined( players[i].zombie_vars[ "zombie_powerup_zombie_blood_on" ] ) && players[i].zombie_vars[ "zombie_powerup_zombie_blood_on" ] ) )
        {
            behaviorTreeEntity.player_targets[behaviorTreeEntity.player_targets.size] = players[i];
            attack = true;
        }
    }

    if ( !attack || freq < randomint(100) )
	{
		return false;	
	}

	return true;
}

function zombieShouldTauntCondition( behaviorTreeEntity )
{
	if( ( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) )
		return false;
	
	if( !behaviorTreeEntity.first_node.zbarrier ZBarrierSupportsZombieTaunts() )
	{
		return false;
	}
	
	if(GetDvarString( "zombie_taunt_freq") == "")
	{
		SetDvar("zombie_taunt_freq","5"); 
	}
	freq = GetDvarInt( "zombie_taunt_freq");

	if( freq >= randomint(100) )
	{
		return true;
	}
	return false;
}

function zombieShouldEnterPlayableCondition( behaviorTreeEntity )
{
	if( IsDefined( behaviorTreeEntity.first_node ) && IsDefined( behaviorTreeEntity.first_node.barrier_chunks ) )
	{
		if( zm_utility::all_chunks_destroyed( behaviorTreeEntity.first_node, behaviorTreeEntity.first_node.barrier_chunks ) )
		{
			if( ( isdefined( behaviorTreeEntity.at_entrance_tear_spot ) && behaviorTreeEntity.at_entrance_tear_spot ) && !( isdefined( behaviorTreeEntity.completed_emerging_into_playable_area ) && behaviorTreeEntity.completed_emerging_into_playable_area ) )
			{
				return true;
			}
		}
	}

	return false;
}

function isChunkValidCondition( behaviorTreeEntity )
{
	if( IsDefined( behaviorTreeEntity.chunk ) )
	{
		return true;
	}

	return false;
}

function inPlayableArea( behaviorTreeEntity )
{
	if ( ( isdefined( behaviorTreeEntity.completed_emerging_into_playable_area ) && behaviorTreeEntity.completed_emerging_into_playable_area ) )
	{
		return true;
	}

	return false;
}

function shouldSkipTeardown( behaviorTreeEntity )
{
	if ( behaviorTreeEntity zm_spawner::should_skip_teardown( behaviorTreeEntity.find_flesh_struct_string ) )
	{
		return true;
	}

	return false;
}

function zombieIsThinkDone( behaviorTreeEntity )
{
	/#
		if( ( isdefined( behaviorTreeEntity.is_rat_test ) && behaviorTreeEntity.is_rat_test ) )
			return false;
	#/
		
		
	if ( ( isdefined( behaviorTreeEntity.zombie_think_done ) && behaviorTreeEntity.zombie_think_done ) )
	{
		return true;
	}

	return false;
}

function zombieIsAtGoal( behaviorTreeEntity )
{
	isAtScriptGoal = behaviorTreeEntity IsAtGoal();

	return isAtScriptGoal;
}

function zombieIsAtEntrance( behaviorTreeEntity )
{
	isAtScriptGoal = behaviorTreeEntity IsAtGoal();
	isAtEntrance = IsDefined( behaviorTreeEntity.first_node ) && isAtScriptGoal;

	return isAtEntrance;
}

// ------- ZOMBIE SERVICES -----------//
function getChunkService( behaviorTreeEntity )
{
	behaviorTreeEntity.chunk = zm_utility::get_closest_non_destroyed_chunk( behaviorTreeEntity.origin, behaviorTreeEntity.first_node, behaviorTreeEntity.first_node.barrier_chunks );
	if( IsDefined( behaviorTreeEntity.chunk ) )
	{
		behaviorTreeEntity.first_node.zbarrier SetZBarrierPieceState(behaviorTreeEntity.chunk, "targetted_by_zombie");
		behaviorTreeEntity.first_node thread zm_spawner::check_zbarrier_piece_for_zombie_death( behaviorTreeEntity.chunk, behaviorTreeEntity.first_node.zbarrier, behaviorTreeEntity );
	}
}

function updateChunkService( behaviorTreeEntity )
{
	while( 0 < behaviorTreeEntity.first_node.zbarrier.chunk_health[behaviorTreeEntity.chunk] )
	{
		behaviorTreeEntity.first_node.zbarrier.chunk_health[behaviorTreeEntity.chunk]--;
	}
	behaviorTreeEntity.lastchunk_destroy_time = GetTime();
}

function updateAttackSpotService( behaviorTreeEntity )
{
	if ( ( isdefined( behaviorTreeEntity.marked_for_death ) && behaviorTreeEntity.marked_for_death ) || behaviorTreeEntity.health < 0 )
	{
		return false;
	}

	if( !IsDefined( behaviorTreeEntity.attacking_spot ) )
	{
		if ( !behaviorTreeEntity zm_spawner::get_attack_spot( behaviorTreeEntity.first_node ) )
		{
			return false;
		}
	}

	if( IsDefined( behaviorTreeEntity.attacking_spot ) )
	{
		behaviorTreeEntity.goalradius = 8;
		behaviorTreeEntity SetGoal( behaviorTreeEntity.attacking_spot );

		if ( behaviorTreeEntity IsAtGoal() )
		{
			behaviorTreeEntity.at_entrance_tear_spot = true;
		}

		return true;
	}

	return false;
}

function findNodesService( behaviorTreeEntity )
{
	node = undefined;

	behaviorTreeEntity.entrance_nodes = [];

	if( IsDefined( behaviorTreeEntity.find_flesh_struct_string ) )
	{
		if ( behaviorTreeEntity.find_flesh_struct_string == "find_flesh" )
		{
			return false;
		}

		for( i=0; i<level.exterior_goals.size; i++ )
		{
			if( IsDefined(level.exterior_goals[i].script_string) && level.exterior_goals[i].script_string == behaviorTreeEntity.find_flesh_struct_string )
			{
				node = level.exterior_goals[i];
				break;
			}
		}

		behaviorTreeEntity.entrance_nodes[behaviorTreeEntity.entrance_nodes.size] = node;

		assert( IsDefined( node ), "Did not find an entrance node with .script_string:" + behaviorTreeEntity.find_flesh_struct_string+ "!!! [Fix this!]" );

		behaviorTreeEntity.first_node = node;
		//behaviorTreeEntity.pushable = false; //turn off pushable
		behaviorTreeEntity.goalradius = 128; 
		behaviorTreeEntity SetGoal( node.origin );

		// zombie spawned within the entrance
		if ( zombieIsAtEntrance( behaviorTreeEntity ) )
		{
			behaviorTreeEntity.got_to_entrance = true;
		}

		return true;
	}
}

// ------- ZOMBIE LOCOMOTION -----------//
function zombieMoveAction( behaviorTreeEntity, asmStateName )
{	
	behaviorTreeEntity.moveTime = GetTime();
	behaviorTreeEntity.moveOrigin = behaviorTreeEntity.origin;

	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	return 5;
}

// Looping Action will always return BHTN_RUNNING and request the state again when the ASM_STATE_COMPLETE
function zombieMoveActionUpdate( behaviorTreeEntity, asmStateName )
{
	if ( !( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) && ( GetTime() - behaviorTreeEntity.moveTime > 500 ) )
	{
		distSq = Distance2DSquared( behaviorTreeEntity.origin, behaviorTreeEntity.moveOrigin );
		if ( distSq < 12 * 12 )
		{
			behaviorTreeEntity SetAvoidanceMask( "avoid all" );
		}
		else
		{
			behaviorTreeEntity SetAvoidanceMask( "avoid none" );
		}

		behaviorTreeEntity.moveTime = GetTime();
		behaviorTreeEntity.moveOrigin = behaviorTreeEntity.origin;
	}

	if( behaviorTreeEntity ASMGetStatus() == "asm_status_complete" )
	{
		if( behaviorTreeEntity IsCurrentBTActionLooping() )
			zombieMoveAction( behaviorTreeEntity, asmStateName );
		else 
			return 4;
	}	
	
	return 5;
}

function zombieMoveActionTerminate( behaviorTreeEntity, asmStateName )
{
	if ( !( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) )
	{
		behaviorTreeEntity SetAvoidanceMask( "avoid none" );
	}

	return 4;	
}


function zombieMoveToEntranceAction( behaviorTreeEntity, asmStateName )
{	
	behaviorTreeEntity.got_to_entrance = false;
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );

	return 5;
}

function zombieMoveToEntranceActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviorTreeEntity.got_to_entrance = true;

	return 4;	
}

function zombieMoveToAttackSpotAction( behaviorTreeEntity, asmStateName )
{	
	behaviorTreeEntity.at_entrance_tear_spot = false;
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );

	return 5;
}

function zombieMoveToAttackSpotActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviorTreeEntity.at_entrance_tear_spot = true;

	return 4;	
}

// ------- ZOMBIE TEAR DOWN -----------//
function zombieHoldBoardAction( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = true;
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_which_board_pull", int( behaviorTreeEntity.chunk ) );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_board_attack_spot", float( behaviorTreeEntity.attacking_spot_index ) );
	
	boardActionAST = behaviorTreeEntity ASTSearch(  IString( asmStateName ) );
	boardActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap( behaviorTreeEntity, boardActionAST[ "animation" ] );
	//behaviorTreeEntity AnimScripted( "grab_anim", behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	
	//origin = GetStartOrigin( behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	//angles = GetStartAngles( behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	//
	//behaviorTreeEntity ForceTeleport( origin, angles, true );
	
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	return 5;
}
	
function zombieHoldBoardActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = false;
	return 4;	
}

function zombieGrabBoardAction( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = true;
	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_which_board_pull", int( behaviorTreeEntity.chunk ) );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_board_attack_spot", float( behaviorTreeEntity.attacking_spot_index ) );
	
	boardActionAST = behaviorTreeEntity ASTSearch(  IString( asmStateName ) );
	boardActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap( behaviorTreeEntity, boardActionAST[ "animation" ] );
	//behaviorTreeEntity AnimScripted( "grab_anim", behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	
	//origin = GetStartOrigin( behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	//angles = GetStartAngles( behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	//
	//behaviorTreeEntity ForceTeleport( origin, angles, true );
	
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	return 5;
}
	
function zombieGrabBoardActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = false;
	return 4;	
}

function zombiePullBoardAction( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = true;
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_which_board_pull", int( behaviorTreeEntity.chunk ) );
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_board_attack_spot", float( behaviorTreeEntity.attacking_spot_index ) );
	
	boardActionAST = behaviorTreeEntity ASTSearch(  IString( asmStateName ) );
	boardActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap( behaviorTreeEntity, boardActionAST[ "animation" ] );
	//behaviorTreeEntity AnimScripted( "grab_anim", behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	
	//origin = GetStartOrigin( behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	//angles = GetStartAngles( behaviorTreeEntity.first_node.zbarrier.origin, behaviorTreeEntity.first_node.zbarrier.angles, boardActionAnimation );
	//
	//behaviorTreeEntity ForceTeleport( origin, angles, true );
	
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	return 5;
}
	
function zombiePullBoardActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = false;

    //to prevent the zombie from being deleted by the failsafe system
    self.lastchunk_destroy_time = GetTime();

	return 4;	
}

// ------- ZOMBIE MELEE BEHIND BOARDS -----------//

function zombieAttackThroughBoardsAction( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = true;
	behaviortreeentity.boardAttack = true;
	
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	return 5;
}
	
function zombieAttackThroughBoardsActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = false;
	behaviortreeentity.boardAttack = false;

	
	return 4;	
}

// ------- ZOMBIE TAUNT -----------//

function zombieTauntAction( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = true;
	
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	return 5;
}
	
function zombieTauntActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviortreeentity.keepClaimedNode = false;

	return 4;	
}

function zombieMantleAction( behaviorTreeEntity, asmStateName )
{
	if( IsDefined( behaviorTreeEntity.attacking_spot_index ) )
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_board_attack_spot", float( behaviorTreeEntity.attacking_spot_index ) );

	// the attack spot needs to be cleared when a zombie enters playable area
	behaviorTreeEntity zombie_utility::reset_attack_spot();
	
	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	
	return 5;
}
	
function zombieMantleActionTerminate( behaviorTreeEntity, asmStateName )
{
	behaviorTreeEntity zm_behavior_utility::enteredPlayableArea();

	return 4;	
}

// ------- ZOMBIE MOCOMP -----------//
function boardTearMocompStart( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	origin = GetStartOrigin( entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompAnim );
	angles = GetStartAngles( entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompAnim );
	
	entity ForceTeleport( origin, angles, true );

	entity.pushable = false;
	entity.blockingPain = true;

	entity AnimMode( "noclip", true );
	entity OrientMode( "face angle", angles[1] );
}

function boardTearMocompUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity AnimMode( "noclip", false );
	entity.pushable = false;
	entity.blockingPain = true;
}

function barricadeEnterMocompStart( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	origin = GetStartOrigin( entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompAnim );
	angles = GetStartAngles( entity.first_node.zbarrier.origin, entity.first_node.zbarrier.angles, mocompAnim );
	
	entity ForceTeleport( origin, angles, true );

	entity AnimMode( "noclip", false );
	entity OrientMode( "face angle", angles[1] );

	entity.pushable = false;
	entity.blockingPain = true;
	entity PathMode( "dont move" );
	entity.useGoalAnimWeight = true;
}

function barricadeEnterMocompUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity AnimMode( "noclip", false );

	entity.pushable = false;
}

function barricadeEnterMocompTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity.pushable = true;
	entity.blockingPain = false;
	entity PathMode( "move allowed" );
	entity.useGoalAnimWeight = false;

	entity AnimMode( "normal", false );
	entity OrientMode( "face motion" );
}

// ------- ZM NOTETRACK HANDLERS -----------//
function notetrackBoardTear( animationEntity )
{
	if( IsDefined( animationEntity.chunk ) )
	{
		animationEntity.first_node.zbarrier SetZBarrierPieceState( animationEntity.chunk, "opening" );
	}
}

function notetrackBoardMelee( animationEntity )
{
	assert( animationEntity.meleeWeapon != level.weaponnone, "Actor does not have a melee weapon" );
	// just hit a player
	if ( IsDefined( animationEntity.first_node ) )
	{
		meleeDistSq = 90 * 90;
				
		if ( IsDefined( level.attack_player_thru_boards_range ) )
 		{
 			meleeDistSq = level.attack_player_thru_boards_range * level.attack_player_thru_boards_range;
		}
				
		triggerDistSq = 51 * 51;

		for ( i = 0; i < animationEntity.player_targets.size; i++ )
		{
			playerDistSq = Distance2DSquared( animationEntity.player_targets[i].origin, animationEntity.origin );
			heightDiff = abs( animationEntity.player_targets[i].origin[2] - animationEntity.origin[2] ); // be sure we're on the same floor
			if ( playerDistSq < meleeDistSq && (heightDiff * heightDiff) < meleeDistSq )
			{
				playerTriggerDistSq = Distance2DSquared( animationEntity.player_targets[i].origin, animationEntity.first_node.trigger_location.origin );
				heightDiff = abs( animationEntity.player_targets[i].origin[2] - animationEntity.first_node.trigger_location.origin[2] ); // be sure we're on the same floor
				if ( playerTriggerDistSq < triggerDistSq && (heightDiff * heightDiff) < triggerDistSq )
				{
					animationEntity.player_targets[i] DoDamage( animationEntity.meleeWeapon.meleeDamage, animationEntity.origin, self, self, "none", "MOD_MELEE" );
					break;
				}
			}
		}
	}
	else
	{
		animationentity Melee();
	}
}



function zombieIDGunDeathMocompStart( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity AnimMode("noclip");
	entity.pushable = false;
	entity.blockingPain = true;
	entity PathMode( "dont move" );
	
	entity.hole_pull_speed = 0;
}

function zombieIDGunDeathMocompUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	if(!isdefined(entity.killby_interdimensional_gun_hole))
	{
		flyingDir = entity.damageOrigin - entity.origin;
		lengthFromHole = Length(flyingDir);
	
		if(lengthFromHole < entity.hole_pull_speed)
		{
			entity ForceTeleport(entity.damageOrigin);
			
			entity.killby_interdimensional_gun_hole = true;
			entity.allowdeath = true;
			entity.magic_bullet_shield = false;
			
			entity kill(entity.origin, entity.interdimensional_gun_attacker, entity.interdimensional_gun_attacker, entity.interdimensional_gun_weapon);
		}
		else
		{
			if(entity.hole_pull_speed < 12)
			{
				entity.hole_pull_speed += 0.5;
				
				if(entity.hole_pull_speed > 12)
					entity.hole_pull_speed = 12;
			}
			
			flyingDir = VectorNormalize(flyingDir);
			entity ForceTeleport(entity.origin + flyingDir * entity.hole_pull_speed);
		}
	}	
}

function zombieIDGunHoleDeathMocompStart( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity AnimMode("noclip");
	entity.pushable = false;
}

function zombieIDGunHoleDeathMocompTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity hide();
}
