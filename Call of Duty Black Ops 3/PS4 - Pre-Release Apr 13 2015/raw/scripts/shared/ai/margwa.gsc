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
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_mocomps_utility;

                                                                                                             	   	
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
                                                              	   	                             	  	                                      
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "model", "c_zom_margwa_fb" );

#namespace ZombieBehavior;

function autoexec init()
{
	// INIT BEHAVIORS
	InitMargwaBehaviorsAndASM();
	
	// INIT BLACKBOARD	
	spawner::add_archetype_spawn_function( "margwa", &ArchetypeMargwaBlackboardInit );

	// INIT MARGWA ON SPAWN
	spawner::add_archetype_spawn_function( "margwa", &margwaSpawnSetup );
}

function private InitMargwaBehaviorsAndASM()
{
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTargetService",&margwaTargetService);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldSmashAttack",&margwaShouldSmashAttack);;

	AnimationStateNetwork::RegisterNotetrackHandlerFunction("smash_attack",&margwaNotetrackSmashAttack);;
}

function private ArchetypeMargwaBlackboardInit()
{
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( self );
	
	// USE UTILITY BLACKBOARD
	self AiUtility::RegisterUtilityBlackboardAttributes();
	
	// CREATE MARGWA BLACKBOARD
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeMargwaOnAnimscriptedCallback;
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#self FinalizeTrackedBlackboardAttributes();#/;
}

function private margwaSpawnSetup()
{
	self DisableAimAssist();

	self.disableAmmoDrop = true;

	self Attach( "c_zom_margwa_chunks_le", "j_neck_over" );
	self Attach( "c_zom_margwa_chunks_mid", "j_neck_over" );
	self Attach( "c_zom_margwa_chunks_ri", "j_neck_over" );
	//self Attach( MARGWA_HEAD_LEFT, MARGWA_HEAD_LEFT_TAG );
	//self Attach( MARGWA_HEAD_MID, MARGWA_HEAD_TAG );
	//self Attach( MARGWA_HEAD_RIGHT, MARGWA_HEAD_RIGHT_TAG );

	self.overrideActorDamage = &margwaDamage;
}

function private margwaDamage( inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex )
{
	if ( modelIndex )
	{
		modelName = self GetAttachModelName( modelIndex - 1 );

		/#
		iprintln( "modelName " + modelName );
		#/
	}

	return 0;
}

function private ArchetypeMargwaOnAnimscriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeMargwaBlackboardInit();
}

// ------- BLACKBOARD -----------//
// ------- BLACKBOARD -----------//


function private margwaNotetrackSmashAttack( entity )
{
	//entity Melee();
	players = GetPlayers();
	foreach( player in players )
	{
		distSq = DistanceSquared( entity.origin, player.origin );
		if ( distSq < 128 * 128 )
		{
			if ( !IsGodMode( player ) )
			{
				player Kill();
			}
		}
	}
}

function private margwaTargetService( entity )
{
	if ( ( isdefined( entity.ignoreall ) && entity.ignoreall ) )
	{
		return false;
	}

	player = zombie_utility::get_closest_valid_player( self.origin, self.ignore_player );

	if( !IsDefined( player ) )
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
			entity SetGoal( player.last_valid_position );		
			return true;
		}
		else
		{
			entity SetGoal( entity.origin );
			return false;
		}
	}
}

function private margwaShouldSmashAttack( entity )
{
	if( !IsDefined( entity.enemy ) )
    {
		return false;
	}

	yaw = abs( zombie_utility::getYawToEnemy() );
	if( ( yaw > 45 ) )
	{
		return false;
	}
	if( DistanceSquared( entity.origin, entity.enemy.origin ) < 128 * 128 )
	{
		return true;
	}
	
	return false;
}

function private margwaDeathAction( behaviorTreeEntity )
{
	//insert anything that needs to be done right before zombie death
}
