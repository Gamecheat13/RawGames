#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;

// INTERFACE
#using scripts\shared\ai\archetype_human_riotshield_interface;

#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;

                                                                                                             	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                      
                                                              	   	                             	  	                                      
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                                                                                                                                                                                                                                                                                                                                   

function autoexec main()
{
	// INIT BLACKBOARD	
	spawner::add_archetype_spawn_function( "human_riotshield", &HumanRiotshieldBehavior::ArchetypeHumanRiotshieldBlackboardInit );
	
	// INIT RIOTSHIELD ON SPAWN
	spawner::add_archetype_spawn_function( "human_riotshield", &HumanRiotshieldServerUtils::humanRiotshieldSpawnSetup );

	HumanRiotshieldBehavior::RegisterBehaviorScriptFunctions();

	HumanRiotshieldInterface::RegisterHumanRiotshieldInterfaceAttributes();
}

#namespace HumanRiotshieldBehavior;

function RegisterBehaviorScriptFunctions()
{
	// ------- TACTICAL WALK -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldShouldTacticalWalk",&riotshieldShouldTacticalWalk);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldNonCombatLocomotionCondition",&riotshieldNonCombatLocomotionCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("unarmedWalkAction",&unarmedWalkActionStart);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldAdvanceOnEnemyService",&riotshieldAdvanceOnEnemyService);;

	// ------- UNARMED -----------//	
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldUnarmedTargetService",&riotshieldUnarmedTargetService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("riotshieldUnarmedAdvanceOnEnemyService",&riotshieldUnarmedAdvanceOnEnemyService);;
}

function private ArchetypeHumanRiotshieldBlackboardInit()
{
	entity = self;
	
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( entity );
	
	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( entity );
	
	// USE UTILITY BLACKBOARD
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeHumanRiotshieldOnAnimscriptedCallback;
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#entity FinalizeTrackedBlackboardAttributes();#/;
}

function private ArchetypeHumanRiotshieldOnAnimscriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeHumanRiotshieldBlackboardInit();
}

function private riotshieldShouldTacticalWalk( behaviorTreeEntity )
{
	// always tactical walk
	return true;
}

function private riotshieldNonCombatLocomotionCondition( behaviorTreeEntity )
{
	if ( IsDefined( behaviorTreeEntity.enemy ) )
	{
		if ( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity LastKnownPos( behaviorTreeEntity.enemy ) ) > 700 * 700 )
		{
			return true;
		}
	}

	return false;
}

function private riotshieldAdvanceOnEnemyService( behaviorTreeEntity )
{
	itsBeenAWhile  	   = ( GetTime() > behaviorTreeEntity.nextFindBestCoverTime );
	isAtScriptGoal 	   = behaviorTreeEntity IsAtGoal();	
	tooLongAtNode	   = false;

	if ( IsDefined( behaviorTreeEntity.chosenNode ) )
	{
		dist_sq = DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.chosenNode.origin );
		if ( dist_sq < 16 * 16 )
		{
			if ( !IsDefined( behaviorTreeEntity.timeAtChosenNode ) )
			{
				behaviorTreeEntity.timeAtChosenNode = GetTime();
			}
		}
	}

	if ( IsDefined( behaviorTreeEntity.timeAtChosenNode ) )
	{
		if ( GetTime() - behaviorTreeEntity.timeAtChosenNode > behaviorTreeEntity.timeAtNodeMax )
		{
			tooLongAtNode = true;
			behaviorTreeEntity.timeAtChosenNode = undefined;
		}
	}

	shouldLookForBetterCover = itsBeenAWhile || !isAtScriptGoal || tooLongAtNode;

	if ( shouldLookForBetterCover && IsDefined( behaviorTreeEntity.enemy ) )	 
	{
		closestRandomNode = undefined;
		closestRandomNodes = behaviorTreeEntity FindBestCoverNodes( behaviorTreeEntity.goalradius, behaviorTreeEntity.goalpos );

		foreach( node in closestRandomNodes )
		{
			if ( IsDefined( behaviorTreeEntity.chosenNode ) && behaviorTreeEntity.chosenNode == node )
			{
				continue;
			}

			if ( AiUtility::getCoverType( node ) == "cover_exposed" )
			{
				closestRandomNode = node;
				break;
			}
		}

		if ( !IsDefined( closestRandomNode ) )
		{
			closestRandomNode = closestRandomNodes[0];
		}
		
		if( IsDefined( closestRandomNode ) 
			&& behaviorTreeEntity FindPath( behaviorTreeEntity.origin, closestRandomNode.origin, true, false ) 
			)
		{
			AiUtility::ReleaseClaimNode( behaviorTreeEntity );
			AiUtility::useCoverNodeWrapper( behaviorTreeEntity, closestRandomNode );

			behaviorTreeEntity.chosenNode = closestRandomNode;
			behaviorTreeEntity.timeAtNodeMax = RandomIntRange( behaviorTreeEntity.moveDelayMin, behaviorTreeEntity.moveDelayMax );
			behaviorTreeEntity.timeAtChosenNode = undefined;

			return true;				
		}
	}		

	return false;
}

function private riotshieldUnarmedTargetService( behaviorTreeEntity )
{
	// Don't change targets during melee
	if ( !AiUtility::shouldMutexMelee( behaviorTreeEntity ) )
	{
		return false;
	}

	enemies = [];
	ai = GetAiArray();

	// Add AI's that are on different teams.
	foreach( index, value in ai )
	{
		if ( value.team != behaviorTreeEntity.team && IsActor( value ) )
		{
			enemies[enemies.size] = value;
		}
	}

	// Find the closest enemy based on distance.
	if ( enemies.size > 0 )
	{
		closestEnemy = undefined;
		closestEnemyDistance = 0;
		
		for ( index = 0; index < enemies.size; index++ )
		{
			enemy = enemies[index];
			enemyDistance = DistanceSquared( behaviorTreeEntity.origin, enemy.origin );
			checkEnemy = false;

			if ( enemyDistance > behaviorTreeEntity.goalradius * behaviorTreeEntity.goalradius )
			{
				continue;
			}

			if ( !IsDefined( enemy.targeted_by ) || enemy.targeted_by == behaviorTreeEntity )
			{
				checkEnemy = true;
			}
			else
			{
				targetDistance = DistanceSquared( enemy.targeted_by.origin, enemy.origin );
				if ( enemyDistance < targetDistance )
				{
					checkEnemy = true;
				}
			}

			if ( checkEnemy )
			{
				if ( !IsDefined( closestEnemy ) || enemyDistance < closestEnemyDistance )
				{
					closestEnemyDistance = enemyDistance;
					closestEnemy = enemy;
				}
			}
		}

		if ( IsDefined( behaviorTreeEntity.favoriteenemy ) )
		{
			behaviorTreeEntity.favoriteenemy.targeted_by = undefined;
		}

		behaviorTreeEntity.favoriteenemy = closestEnemy;

		if ( IsDefined( behaviorTreeEntity.favoriteenemy ) )
		{
			behaviorTreeEntity.favoriteenemy.targeted_by = behaviorTreeEntity;
		}

		return true;
	}

	return false;
}

function private riotshieldUnarmedAdvanceOnEnemyService( behaviorTreeEntity )
{
	if ( GetTime() < behaviorTreeEntity.nextFindBestCoverTime )
	{
		return false;
	}

	if( IsDefined( behaviorTreeEntity.favoriteenemy ) )	 
	{
		/#
		RecordLine( behaviorTreeEntity.favoriteenemy.origin, behaviorTreeEntity.origin, ( 1, .5, 0 ), "Animscript", behaviorTreeEntity );
		#/	

		enemyDistance = DistanceSquared( behaviorTreeEntity.favoriteenemy.origin, behaviorTreeEntity.origin );
		if ( enemyDistance < behaviorTreeEntity.goalradius * behaviorTreeEntity.goalradius )
		{
			behaviorTreeEntity UsePosition( behaviorTreeEntity.favoriteenemy.origin );
			return true;
		}
	}

	behaviorTreeEntity ClearUsePosition();
	return false;
}

function private unarmedWalkActionStart( behaviorTreeEntity )
{	
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_stance", "stand" );		
	behaviorTreeEntity OrientMode( "face enemy" );	
}


#namespace HumanRiotshieldServerUtils;

function humanRiotshieldSpawnSetup()
{
	entity = self;
	entity Attach( "wpn_t7_shield_riot_world_lh", "tag_weapon_left" );

	entity.moveDelayMin = 2500;
	entity.moveDelayMax = 5000;
}

// end #namespace HumanRiotshieldServerUtils;

