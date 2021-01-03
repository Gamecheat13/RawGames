#using scripts\shared\ai_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\util_shared;
#using scripts\shared\array_shared;

#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\zombie_death;
#using scripts\shared\ai\zombie_shared;
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_mocomps_utility;

//INTERFACE
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\archetype_zombie_interface;

           

                                                                                                             	     	                                                                                                                                                                
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                                                                                                                                                       	     	                                                                                   
                                                                  	                             	  	                                      
                                                                                                           	                                     	                	                       	            	                                                                                                                                                                                                                               
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace ZombieBehavior;

function autoexec init()
{
	// INIT BEHAVIORS
	InitZombieBehaviorsAndASM();
	
	// INIT BLACKBOARD	
	spawner::add_archetype_spawn_function( "zombie", &ArchetypeZombieBlackboardInit );
	spawner::add_archetype_spawn_function( "zombie", &ArchetypeZombieDeathOverrideInit );
		
	// INIT ZOMBIE ON SPAWN
	spawner::add_archetype_spawn_function( "zombie", &zombie_utility::zombieSpawnSetup );
	
	clientfield::register(
		"actor",
		"zombie",
		1,
		1,
		"int");
	
	clientfield::register(
		"actor",
		"zombie_suicide",
		1,
		1,
		"int");
			
	ZombieInterface::RegisterZombieInterfaceAttributes();
}

function private InitZombieBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieTargetService",&zombieTargetService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieCrawlerCollisionService",&zombieCrawlerCollision);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMelee",&zombieShouldMeleeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGibLegsCondition",&zombieGibLegsCondition);; 
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldDisplayPain",&zombieShouldDisplayPain);; 
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isZombieWalking",&isZombieWalking);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMeleeSuicide",&zombieShouldMeleeSuicide);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieMeleeSuicideStart",&zombieMeleeSuicideStart);;	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieMeleeSuicideUpdate",&zombieMeleeSuicideUpdate);;	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieMeleeSuicideTerminate",&zombieMeleeSuicideTerminate);;	
		
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldJuke",&zombieShouldJukeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieJukeActionStart",&zombieJukeActionStart);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDeathAction",&zombieDeathAction);; 
	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieJukeService",&zombieJuke);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStumbleService",&zombieStumble);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStumbleCondition",&zombieShouldStumbleCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieStumbleActionStart",&zombieStumbleActionStart);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasKilledByInterdimensionalGun",&wasKilledByInterdimensionalGunCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("wasCrushedByInterdimensionalGunBlackhole",&wasCrushedByInterdimensionalGunBlackholeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieIDGunDeathUpdate",&zombieIDGunDeathUpdate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieVortexPullUpdate",&zombieIDGunDeathUpdate);; //for doa
		
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieHasLegs",&zombieHasLegs);;
	
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("zombie_melee",&zombieNotetrackMeleeFire);;
	
	// ------- ZOMBIE DEATH -----------//
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_death_idgun@zombie",&zombieIDGunDeathMocompStart,undefined,undefined);;
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_vortex_pull@zombie",&zombieIDGunDeathMocompStart,undefined,undefined);; //for doa
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_death_idgun_hole@zombie",&zombieIDGunHoleDeathMocompStart,undefined,&zombieIDGunHoleDeathMocompTerminate);;
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_turn@zombie",&zombieTurnMocompStart,&zombieTurnMocompUpdate,&zombieTurnMocompTerminate);;
}

function private ArchetypeZombieBlackboardInit()
{
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( self );
	
	// USE UTILITY BLACKBOARD
	self AiUtility::RegisterUtilityBlackboardAttributes();

	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( self );
	
	// CREATE ZOMBIE BLACKBOARD
	Blackboard::RegisterBlackBoardAttribute(self,"_arms_position","arms_up",&BB_GetArmsPosition);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_arms_position");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_speed","locomotion_speed_walk",&BB_GetLocomotionSpeedType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_speed");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_has_legs","has_legs_yes",&BB_GetHasLegsStatus);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_has_legs");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_variant_type",0,&BB_GetVariantType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_variant_type");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_which_board_pull",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_which_board_pull");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_board_attack_spot",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_board_attack_spot");#/    };	
	Blackboard::RegisterBlackBoardAttribute(self,"_grapple_direction",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_grapple_direction");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_should_turn","should_not_turn",&BB_GetShouldTurn);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_should_turn");#/    };
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeZombieOnAnimscriptedCallback;
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#self FinalizeTrackedBlackboardAttributes();#/;
	
}

function private ArchetypeZombieOnAnimscriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeZombieBlackboardInit();
}

// ------- BLACKBOARD -----------//

function BB_GetArmsPosition()
{
	if( IsDefined( self.zombie_arms_position ) )
	{
		if( self.zombie_arms_position == "up" )
			return "arms_up";
		return "arms_down";
	}
	
	return "arms_up";
}

function BB_GetLocomotionSpeedType()
{
	if ( IsDefined( self.zombie_move_speed ) )
	{
		if( self.zombie_move_speed == "walk" )
		{
			return "locomotion_speed_walk";
		}
		else if( self.zombie_move_speed == "run" )
		{
			return "locomotion_speed_run";
		}
		else if( self.zombie_move_speed == "sprint" )
		{
			return "locomotion_speed_sprint";
		}
		else if( self.zombie_move_speed == "super_sprint" )
		{
			return "locomotion_speed_super_sprint";
		}
	}
	return "locomotion_speed_walk";
}

function BB_GetVariantType()
{
	if( IsDefined( self.variant_type ) )
	{
		return self.variant_type;
	}
	return 0;
}

function BB_GetHasLegsStatus()
{
	if( self.missingLegs )
		return "has_legs_no";
	return "has_legs_yes";
}

function BB_GetShouldTurn()
{
	if( IsDefined( self.should_turn ) && self.should_turn )
	{
		return "should_turn";
	}
	return "should_not_turn";
}

// ------- BLACKBOARD -----------//

function isZombieWalking( behaviorTreeEntity )
{
	return !( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs );
}

function zombieShouldDisplayPain( behaviorTreeEntity )
{
	if( ( isdefined( behaviorTreeEntity.suicidalDeath ) && behaviorTreeEntity.suicidalDeath ) )
		return false;
	
	return !( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs );
}

function zombieShouldJukeCondition( behaviorTreeEntity )
{
	if ( IsDefined( behaviorTreeEntity.juke ) && ( behaviorTreeEntity.juke == "left" || behaviorTreeEntity.juke == "right" ) )
	{
		return true;
	}

	return false;
}

function zombieShouldStumbleCondition( behaviorTreeEntity )
{
	if ( isDefined( behaviorTreeEntity.stumble ) )
	{
		return true;
	}
	return false;
}

function private zombieJukeActionStart( behaviorTreeEntity )
{
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_juke_direction", behaviorTreeEntity.juke );
	
	if ( IsDefined( behaviorTreeEntity.jukeDistance ) )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_juke_distance", behaviorTreeEntity.jukeDistance );
	}
	else
	{
		//default to short although this should never happen
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_juke_distance", "short" ); 
	}

	behaviorTreeEntity.jukeDistance = undefined;
	behaviorTreeEntity.juke = undefined;
}

function  private zombieStumbleActionStart( behaviorTreeEntity )
{
	behaviorTreeEntity.stumble = undefined;
}

function zombieGibLegsCondition( behaviorTreeEntity)
{
	return GibServerUtils::IsGibbed( behaviorTreeEntity, 256) || GibServerUtils::IsGibbed( behaviorTreeEntity, 128);
}

function zombieNotetrackMeleeFire( entity )
{
	if ( ( isdefined( entity.aat_turned ) && entity.aat_turned ) )
	{
		if ( entity.enemy.archetype == "zombie" )
		{
			GibServerUtils::GibHead( entity.enemy );
			entity.enemy zombie_utility::gib_random_parts();
			entity.enemy Kill();
		}
	}
	else
	{
		entity Melee();
	}
}

function zombieTargetService( behaviorTreeEntity)
{
	if( ( isdefined( behaviorTreeEntity.disableTargetService ) && behaviorTreeEntity.disableTargetService ) )
	{
		return false;
	}
	
	if ( ( isdefined( behaviorTreeEntity.ignoreall ) && behaviorTreeEntity.ignoreall ) )
	{
		return false;
	}
	
	specificTarget = undefined;
	
	// Check if there is a point of interest
	if( IsDefined( level.zombieLevelSpecificTargetCallback ) )
	{
		specificTarget = [[level.zombieLevelSpecificTargetCallback]]();
	}	

	if( IsDefined( specificTarget ) )
	{
		behaviorTreeEntity SetGoal( specificTarget.origin );
	}
	else
	{	   
		player = zombie_utility::get_closest_valid_player( self.origin, self.ignore_player );
			
		if( !IsDefined( player ) )
		{
			if( IsDefined( self.ignore_player )  )
			{
				if(isDefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]() )
				{
					return false;
				}
				
				self.ignore_player = [];
			}
	
			self SetGoal( self.origin );		
			return false;
		}
		else
		{
			if ( IsDefined( player.last_valid_position ) )
			{
				if( !( isdefined( self.zombie_do_not_update_goal ) && self.zombie_do_not_update_goal ) )
				{
					if( ( isdefined( level.zombie_use_zigzag_path ) && level.zombie_use_zigzag_path ) )
					{
						behaviorTreeEntity zombieUpdateZigZagGoal();
					}
					else
					{
						behaviorTreeEntity SetGoal( player.last_valid_position );
					}
				}				
				
				return true;
			}
			else
			{
				if( !( isdefined( self.zombie_do_not_update_goal ) && self.zombie_do_not_update_goal ) )
				{
					behaviorTreeEntity SetGoal( behaviorTreeEntity.origin );
				}
				
				return false;
			}
		}
	}
}

function zombieUpdateZigZagGoal()
{
	AIProfile_BeginEntry( "zombieUpdateZigZagGoal" );
	
	const ZM_ZOMBIE_HEIGHT						= 72;
	const ZM_ZOMBIE_ZIGZAG_GOAL_TOLERENCE_DIST 	= 72;
	const ZM_ZOMBIE_ZIGZAZ_ACTIVATION_DIST		= 250;
	shouldRepath = false;
	
	if ( !shouldRepath && IsDefined( self.favoriteenemy ) )
	{
		if ( !IsDefined( self.nextGoalUpdate ) || self.nextGoalUpdate <= GetTime() )
		{
			// It's been a while, repath!
			shouldRepath = true;
		}
		else if ( DistanceSquared( self.origin, self.favoriteenemy.origin ) <= ( (ZM_ZOMBIE_ZIGZAZ_ACTIVATION_DIST) * (ZM_ZOMBIE_ZIGZAZ_ACTIVATION_DIST) ) )
		{
			// Repath if close to the enemy.
			shouldRepath = true;
		}
		else if ( IsDefined( self.pathGoalPos ) )
		{
			// Repath if close to the current goal position.
			distanceToGoalSqr = DistanceSquared( self.origin, self.pathGoalPos );
			
			shouldRepath = distanceToGoalSqr < ( (ZM_ZOMBIE_ZIGZAG_GOAL_TOLERENCE_DIST) * (ZM_ZOMBIE_ZIGZAG_GOAL_TOLERENCE_DIST) );
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
		
		// Fist set the position directly to the current goal position
		self SetGoal( goalPos );
		
		// Randomize zig-zag path following if 20+ feet away from the enemy. This will override the goal position set earlier if needed.
		if ( DistanceSquared( self.origin, goalPos ) > ( (ZM_ZOMBIE_ZIGZAZ_ACTIVATION_DIST) * (ZM_ZOMBIE_ZIGZAZ_ACTIVATION_DIST) ) )
		{
			self.keep_moving = true;
			self.keep_moving_time = GetTime() + 250;
			path = self CalcApproximatePathToPosition( goalPos,false );
			
			/#
			if ( GetDvarInt( "ai_debugZigZag" ) )
			{
				for ( index = 1; index < path.size; index++ )
				{
					RecordLine( path[index - 1], path[index], ( 1, .5, 0 ), "Animscript", self );
				}
			}
			#/
		
			if( IsDefined( level._zombieZigZagDistanceMin ) && IsDefined( level._zombieZigZagDistanceMax ) )
			{
				min = level._zombieZigZagDistanceMin;
				max = level._zombieZigZagDistanceMax;
			}
			else
			{
				min = 240;
				max = 600;
			}
				
			deviationDistance = RandomIntRange( min, max );  // 20 to 50 feet
		
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
						0.5 * ZM_ZOMBIE_HEIGHT,
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

		if( IsDefined( level._zombieZigZagTimeMin ) && IsDefined( level._zombieZigZagTimeMax ) )
		{
			minTime = level._zombieZigZagTimeMin;
			maxTime = level._zombieZigZagTimeMax;
		}
		else
		{
			minTime = 2500;
			maxTime = 3500;
		}
		
		// Force repathing after a certain amount of time to smooth out movement.
		self.nextGoalUpdate = GetTime() + RandomIntRange(minTime, maxTime);
	}
	
	AIProfile_EndEntry();
}

// turn off actor pushing if a regular zombie is too close
function zombieCrawlerCollision( behaviorTreeEntity )
{
	if ( !( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) )
	{
		return false;
	}

	if ( IsDefined( behaviorTreeEntity.dontPushTime ) )
	{
		if ( GetTime() < behaviorTreeEntity.dontPushTime )
		{
			return true;
		}
	}

	zombies = GetAITeamArray( level.zombie_team );
	foreach( zombie in zombies )
	{
		if ( zombie == behaviorTreeEntity )
		{
			continue;
		}

		if ( ( isdefined( zombie.missingLegs ) && zombie.missingLegs ) )
		{
			continue;
		}

		dist_sq = DistanceSquared( behaviorTreeEntity.origin, zombie.origin );
		if ( dist_sq < 120 * 120 )
		{
			behaviorTreeEntity PushActors( false );
			behaviorTreeEntity.dontPushTime = GetTime() + 2000;
			return true;
		}
	}

	behaviorTreeEntity PushActors( true );
	return false;
}

function zombieShouldMeleeCondition( behaviorTreeEntity )
{
	if( !IsDefined( behaviortreeentity.enemy ) )
    {
		return false;
	}

	if( IsDefined( behaviorTreeEntity.marked_for_death ) )
	{
		return false;
	}
	
	if( ( isdefined( behaviorTreeEntity.stunned ) && behaviorTreeEntity.stunned ) )
	{
		return false;
	}
	
	if( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin ) < 64 * 64 )
	{
		return true;
	}
	
	yaw = abs( zombie_utility::getYawToEnemy() );
	if( ( yaw > 45 ) )
	{
		return false;
	}
	
	return false;
}

function zombieStumble( behaviorTreeEntity )
{
	if ( ( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) )
	{
		return false;
	}
	if ( !( isdefined( behaviorTreeEntity.canStumble ) && behaviorTreeEntity.canStumble ) )
	{
		return false;
	}
	if ( !IsDefined( behaviorTreeEntity.zombie_move_speed ) || behaviorTreeEntity.zombie_move_speed != "sprint" )
	{
		return false;
	}
	if ( IsDefined( behaviorTreeEntity.stumble ) )
	{
		return false;
	}
	if (!IsDefined( behaviorTreeEntity.next_stumble_time ) )
	{
		behaviorTreeEntity.next_stumble_time = GetTime() + RandomIntRange( 9000, 12000 );
	}
	if ( GetTime() > behaviorTreeEntity.next_stumble_time ) 
	{
		behaviorTreeEntity.next_stumble_time = undefined;
		
		if ( RandomInt( 100 ) < 5 )
		{
			closestPlayer = ArrayGetClosest( behaviorTreeEntity.origin, level.players );
			if( DistanceSquared( closestPlayer.origin, behaviorTreeEntity.origin ) > 50000 )
			{
				if ( IsDefined( behaviorTreeEntity.next_juke_time ) )
				{
					behaviorTreeEntity.next_juke_time = undefined;
				}
				
				behaviorTreeEntity.stumble = true;
				return true;
			}
		}
	}
	return false;
}

function zombieJuke( behaviorTreeEntity )
{
	if ( self ai::has_behavior_attribute( "can_juke" ) && !self ai::get_behavior_attribute( "can_juke" ) )
	{
		return false;
	}
	if ( ( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) )
	{
		return false;
	}

	if ( behaviorTreeEntity ZombieBehavior::bb_getlocomotionspeedtype() != "locomotion_speed_walk" )
	{
		return false;
	}

	if ( IsDefined( behaviorTreeEntity.juke ) )
	{
		return false;
	}

	if ( !IsDefined( behaviorTreeEntity.next_juke_time ) )
	{
		behaviorTreeEntity.next_juke_time = GetTime() + RandomIntRange( 7500, 9500 );
	}

	if ( GetTime() > behaviorTreeEntity.next_juke_time )
	{
		behaviorTreeEntity.next_juke_time = undefined;
		
		if ( RandomInt( 100 ) < 25 )
		{			
			
			if ( IsDefined( behaviorTreeEntity.next_stumble_time ) )
			{
				behaviorTreeEntity.next_stumble_time = undefined;
			}
			
			forwardOffset = 15;
			behaviorTreeEntity.ignoreBackwardPosition = true; //TODO remove this temp var
			
			if( math::cointoss() ) //decide if going to be short or long juke
			{
				//try long juke
				jukeDistance = 101;
				behaviorTreeEntity.jukeDistance = "long";
							
				switch( behaviorTreeEntity ZombieBehavior::bb_getlocomotionspeedtype() )
				{
					case "locomotion_speed_walk":
					case "locomotion_speed_run":
						forwardOffset = 122;
						break;
					case "locomotion_speed_sprint":
						forwardOffset = 129;
						break;
				}
				
				behaviorTreeEntity.juke = AiUtility::calculateJukeDirection( behaviorTreeEntity, forwardOffset, jukeDistance );
				//juke == forward -> can't juke left or right
			}
			
			if ( !IsDefined( behaviorTreeEntity.juke ) || behaviorTreeEntity.juke == "forward" ) // could not long juke
			{
				//long juke didn't work out, so try short juke
				jukeDistance = 69;
				behaviorTreeEntity.jukeDistance = "short";
				
				switch( behaviorTreeEntity ZombieBehavior::bb_getlocomotionspeedtype() )
				{
					case "locomotion_speed_walk":
					case "locomotion_speed_run":
						forwardOffset = 127;
						break;
					case "locomotion_speed_sprint":
						forwardOffset = 148;
						break;
				}
				
				behaviorTreeEntity.juke = AiUtility::calculateJukeDirection( behaviorTreeEntity, forwardOffset, jukeDistance );
				if( behaviorTreeEntity.juke == "forward" )
				{
					//both juke checks failed, so don't juke at all
					behaviorTreeEntity.juke = undefined;
					behaviorTreeEntity.jukeDistance = undefined;
					return false;
				}
			}
			
		}
		

	}
}

function zombieDeathAction( behaviorTreeEntity )
{
	//insert anything that needs to be done right before zombie death
}

function wasKilledByInterdimensionalGunCondition( behaviorTreeEntity )
{
	if( IsAlive( behaviorTreeEntity ) &&
		isdefined( behaviorTreeEntity.interdimensional_gun_kill ) &&
		!isdefined( behaviorTreeEntity.killby_interdimensional_gun_hole ) )
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

function zombieIDGunDeathMocompStart( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity OrientMode( "face angle", entity.angles[1] );
	entity AnimMode("noclip");
	entity.pushable = false;
	entity.blockingPain = true;
	entity PathMode( "dont move" );
	
	entity.hole_pull_speed = 0;
}

// Offset also defined in _zm_weap_idgun.gsc


function zombieIDGunDeathUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	if(!isdefined(entity.killby_interdimensional_gun_hole))
	{
		entity_eye = entity GetEye();
		
		if ( entity.b_vortex_repositioned !== true )
		{
			entity.b_vortex_repositioned = true;
			v_nearest_navmesh_point = GetClosestPointOnNavMesh( entity.damageOrigin, 36, 15 );
			if ( isdefined(v_nearest_navmesh_point) )
			{
				f_distance = Distance( entity.damageOrigin, v_nearest_navmesh_point);
				
				// Added 5 units to offset to capture a larger set of points
				if ( f_distance < 36 + 5 )
			    {
					entity.damageOrigin = entity.damageOrigin + ( 0, 0, 36);
				}
			}
		}
		
		entity_center = entity.origin + ( ( entity_eye - entity.origin ) / 2 );
		flyingDir = entity.damageOrigin - entity_center;
		lengthFromHole = Length(flyingDir);
	
		if(lengthFromHole < entity.hole_pull_speed)
		{
			entity.killby_interdimensional_gun_hole = true;
			entity.allowdeath = true;
			entity.magic_bullet_shield = false;
			level notify("interdimensional_kill",entity);
			if( IsDefined( entity.interdimensional_gun_weapon ) && IsDefined( entity.interdimensional_gun_attacker ) )
			{
				entity kill(entity.origin, entity.interdimensional_gun_attacker, entity.interdimensional_gun_attacker, entity.interdimensional_gun_weapon);
			}
			else
			{
				entity kill( entity.origin );
			}
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
	entity OrientMode( "face angle", entity.angles[1] );
	entity AnimMode("noclip");
	entity.pushable = false;
}

function zombieIDGunHoleDeathMocompTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	if( !( isdefined( entity.interdimensional_gun_kill_vortex_explosion ) && entity.interdimensional_gun_kill_vortex_explosion ) )
	{
		entity hide();
	}
}

function private zombieTurnMocompStart( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity OrientMode( "face angle", entity.angles[1] );
	entity AnimMode( "angle deltas", false );
}

function private zombieTurnMocompUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	normalizedTime = ( entity GetAnimTime( mocompAnim ) + mocompAnimBlendOutTime ) / mocompDuration;

	if ( normalizedTime > 0.25 )
	{
		entity OrientMode( "face motion" );
		entity AnimMode( "normal", false );
	}
}

function private zombieTurnMocompTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity OrientMode( "face motion" );
	entity AnimMode( "normal", false );
}

function zombieHasLegs( behaviorTreeEntity )
{
	if( behaviorTreeEntity.missingLegs === true )
	{
		return false;
	}
	
	return true;
}

function zombieShouldMeleeSuicide( behaviorTreeEntity )
{
	if( !behaviorTreeEntity ai::get_behavior_attribute( "suicidal_behavior" ) )
	{
		return false;
	}
	
	if( ( isdefined( behaviorTreeEntity.magic_bullet_shield ) && behaviorTreeEntity.magic_bullet_shield ) )
	{
		return false;
	}
	
	if( !IsDefined( behaviortreeentity.enemy ) )
    {
		return false;
	}

	if( IsDefined( behaviorTreeEntity.marked_for_death ) )
	{
		return false;
	}
	
	if( ( isdefined( behaviorTreeEntity.stunned ) && behaviorTreeEntity.stunned ) )
	{
		return false;
	}
	
	if( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin ) > ( 200 * 200 ) )
	{
		return false;
	}
	
	return true;
}

function zombieMeleeSuicideStart( behaviorTreeEntity )
{
	behaviorTreeEntity.blockingPain = true;
	behaviorTreeEntity ASMSetAnimationRate( 1.2 );
}

function zombieMeleeSuicideUpdate( behaviorTreeEntity )
{

}
	
function zombieMeleeSuicideTerminate( behaviorTreeEntity )
{		
	clientfield::set( "zombie_suicide", 1 );
				
	if( IsAlive( behaviorTreeEntity ) )
	{
		behaviorTreeEntity.takedamage = true;
		behaviorTreeEntity.allowDeath = true;
		behaviorTreeEntity Kill();
	}		
}

// ------- ZOMBIE DEATH GIB OVERRIDE -----------//
function private ArchetypeZombieDeathOverrideInit() // Self = AI
{
	AiUtility::AddAIOverrideKilledCallback( self, &ZombieGibKilledAnhilateOverride );
}


function private ZombieGibKilledAnhilateOverride( inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime ) // self = AI
{	
	// Level must opt-in to anhilation	
	if( !( isdefined( level.zombieAnhilationEnabled ) && level.zombieAnhilationEnabled ) )
		return damage;
	
	if( !util::is_mature() || util::is_german_build()  )
		return damage;
	
	if( ( isdefined( self.forceAnhilateOnDeath ) && self.forceAnhilateOnDeath ) )
	{
		GibServerUtils::Annihilate( self );
		return damage;
	}
	
	// Forced anhilation for players
	if( IsDefined( attacker ) && IsPlayer( attacker ) && ( ( isdefined( attacker.forceAnhilateOnDeath ) && attacker.forceAnhilateOnDeath ) || ( isdefined( level.forceAnhilateOnDeath ) && level.forceAnhilateOnDeath ) ) )
	{
		GibServerUtils::Annihilate( self );
		return damage;
	}
	 
	// Generic anhilation
	attackerDistance = 0;
	
	if ( IsDefined( attacker ) )
	{
		attackerDistance = DistanceSquared( attacker.origin, self.origin );
	}
	
	isExplosive = IsInArray(
		array(
			"MOD_CRUSH",
			"MOD_GRENADE",
			"MOD_GRENADE_SPLASH",
			"MOD_PROJECTILE",
			"MOD_PROJECTILE_SPLASH",
			"MOD_EXPLOSIVE" ),
		meansOfDeath );
		
	forceGibbing = false;
	
	if ( IsDefined( weapon.weapclass ) && weapon.weapclass == "turret" )
	{
		forceGibbing = true;
		
		// Annihilate AI's from turrent explosives that are inflicted at a close distance.
		if ( IsDefined( inflictor ) )
		{
			isDirectExplosive = IsInArray(
				array(
					"MOD_GRENADE",
					"MOD_GRENADE_SPLASH",
					"MOD_PROJECTILE",
					"MOD_PROJECTILE_SPLASH",
					"MOD_EXPLOSIVE" ),
				meansOfDeath );
			
			isCloseExplosive = DistanceSquared( inflictor.origin, self.origin ) <= ( (60) * (60) );
			
			if ( isDirectExplosive && isCloseExplosive )
			{
				GibServerUtils::Annihilate( self );
			}
		}
	}	

	return damage;
}