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

                                                                                                             	   	
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                                                                                                                                                                                                                                                                                                                                   
                                                              	   	                             	  	                                      
                                                                                                           	                                     	                                                                                                                                                                                                          
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace ZombieBehavior;

function autoexec init()
{
	// INIT BEHAVIORS
	InitZombieBehaviorsAndASM();
	
	// INIT BLACKBOARD	
	spawner::add_archetype_spawn_function( "zombie", &ArchetypeZombieBlackboardInit );
	
	// INIT ZOMBIE ON SPAWN
	spawner::add_archetype_spawn_function( "zombie", &zombie_utility::zombieSpawnSetup );

	clientfield::register(
		"actor",
		"zombie",
		1,
		1,
		"int");
}

function private InitZombieBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieTargetService",&zombieTargetService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieCrawlerCollisionService",&zombieCrawlerCollision);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldMelee",&zombieShouldMeleeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieGibLegsCondition",&zombieGibLegsCondition);; 
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("isZombieWalking",&isZombieWalking);; 

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieShouldJuke",&zombieShouldJukeCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieJukeActionStart",&zombieJukeActionStart);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDeathAction",&zombieDeathAction);; 
		
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("zombie_melee",&zombieNotetrackMeleeFire);;
}

function private ArchetypeZombieBlackboardInit()
{
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( self );
	
	// USE UTILITY BLACKBOARD
	self AiUtility::RegisterUtilityBlackboardAttributes();
	
	// CREATE ZOMBIE BLACKBOARD
	Blackboard::RegisterBlackBoardAttribute(self,"_arms_position","arms_up",&BB_GetArmsPosition);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_arms_position");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_speed","locomotion_speed_walk",&BB_GetLocomotionSpeedType);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_speed");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_has_legs","has_legs_yes",&BB_GetHasLegsStatus);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_has_legs");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_which_board_pull",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_which_board_pull");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_board_attack_spot",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_board_attack_spot");#/    };	
	
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

function BB_GetHasLegsStatus()
{
	if( self.missingLegs )
		return "has_legs_no";
	return "has_legs_yes";
}

// ------- BLACKBOARD -----------//



function isZombieWalking( behaviorTreeEntity )
{
	if( !isdefined(behaviorTreeEntity.zombie_move_speed))
		return true;
	return behaviorTreeEntity.zombie_move_speed == "walk" && !( isdefined( behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.missingLegs ) && behaviorTreeEntity.zombie_arms_position == "up";
}

function zombieShouldJukeCondition( behaviorTreeEntity )
{
	if ( IsDefined( behaviorTreeEntity.juke ) && ( behaviorTreeEntity.juke == "left" || behaviorTreeEntity.juke == "right" ) )
	{
		return true;
	}

	return false;
}

function private zombieJukeActionStart( behaviorTreeEntity )
{
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_juke_direction", behaviorTreeEntity.juke );

	behaviorTreeEntity.juke = undefined;
}

function zombieGibLegsCondition( behaviorTreeEntity)
{
	return GibServerUtils::IsGibbed( behaviorTreeEntity, 128) || GibServerUtils::IsGibbed( behaviorTreeEntity, 64);
}

function zombieNotetrackMeleeFire( animationEntity )
{
	animationentity Melee();
}

function zombieTargetService( behaviorTreeEntity)
{
	if ( ( isdefined( behaviorTreeEntity.ignoreall ) && behaviorTreeEntity.ignoreall ) )
	{
		return false;
	}

	player = zombie_utility::get_closest_valid_player( self.origin, self.ignore_player );

	if( !isDefined( player ) )
	{
		if( IsDefined( self.ignore_player )  )
		{
			if(isDefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]() )
			{
				return;
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
			behaviorTreeEntity SetGoal( player.last_valid_position );		
			return true;
		}
		else
		{
			behaviorTreeEntity SetGoal( behaviorTreeEntity.origin );
			return false;
		}
	}
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
	
	yaw = abs( zombie_utility::getYawToEnemy() );
	if( ( yaw > 45 ) )
	{
		return false;
	}
	if( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.enemy.origin ) < 64 * 64 )
	{
		return true;
	}
	
	return false;
}

function zombieDeathAction( behaviorTreeEntity )
{
	//insert anything that needs to be done right before zombie death
}
