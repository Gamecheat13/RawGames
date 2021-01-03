#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\zombie;
#using scripts\shared\spawner_shared;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\math_shared;

   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                              	   	                             	  	                                      
                                                                                                           	                                     	                                                                                                                                                                                                          

                                                                                                             	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace ZombieDogBehavior;

function autoexec RegisterBehaviorScriptFunctions()
{
	// INIT BLACKBOARD
	spawner::add_archetype_spawn_function( "zombie_dog", &ArchetypeZombieDogBlackboardInit );
	
	// ------- ZOMBIE DOG - SERVICES ----------- //
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDogTargetService",&zombieDogTargetService);;

	// ------- ZOMBIE DOG - CONDITIONS --------- //
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDogShouldMelee",&zombieDogShouldMelee);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDogShouldWalk",&zombieDogShouldWalk);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zombieDogShouldRun",&zombieDogShouldRun);;

	// ------- ZOMBIE DOG - ACTIONS ------------ //
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("zombieDogMeleeAction",&zombieDogMeleeAction,undefined,&zombieDogMeleeActionTerminate);;

	AnimationStateNetwork::RegisterNotetrackHandlerFunction("dog_melee",&ZombieBehavior::zombieNotetrackMeleeFire);;
}

function ArchetypeZombieDogBlackboardInit() // self = AI
{
		// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( self );
		
	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( self );

	// USE UTILITY BLACKBOARD
	self AiUtility::RegisterUtilityBlackboardAttributes();
	
	// CREATE ZOMBIE DOG BLACKBOARD
	Blackboard::RegisterBlackBoardAttribute(self,"_should_run","walk",&BB_GetShouldRunStatus);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_should_run");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_should_howl","dont_howl",&BB_GetShouldHowlStatus);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_should_howl");#/    };
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeZombieDogOnAnimscriptedCallback;
		
	// ENABLE DEBUGGING IN ODYSSEY
	/#self FinalizeTrackedBlackboardAttributes();#/;
}

function private ArchetypeZombieDogOnAnimscriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeZombieDogBlackboardInit();
}

function BB_GetShouldRunStatus()
{
	if ( ( isdefined( self.hasSeenFavoriteEnemy ) && self.hasSeenFavoriteEnemy ) || ( ai::HasAiAttribute( self, "sprint" ) && ( isdefined( ai::GetAiAttribute( self, "sprint" ) ) && ai::GetAiAttribute( self, "sprint" ) ) ) )
		return "run";
	return "walk";
}

function BB_GetShouldHowlStatus()
{
	if ( self ai::has_behavior_attribute( "howl_chance" ) && ( isdefined( self.hasSeenFavoriteEnemy ) && self.hasSeenFavoriteEnemy ) )
	{
		if ( !isdefined( self.shouldHowl ) )
		{
			chance = self ai::get_behavior_attribute( "howl_chance" );
			self.shouldHowl = RandomFloat( 1 ) <= chance;
		}
		if ( self.shouldHowl )
		{
			return "howl";
		}
		else
		{
			return "dont_howl";
		}
	}

	return "dont_howl";
}

function GetYaw(org)
{
	angles = VectorToAngles(org-self.origin);
	return angles[1];
}

// 0 if I'm facing my enemy, 90 if I'm side on, 180 if I'm facing away.
function AbsYawToEnemy()
{
	assert( IsDefined(self.enemy) );
	
	yaw = self.angles[1] - GetYaw(self.enemy.origin);
	yaw = AngleClamp180( yaw );
	
	if (yaw < 0)
	{
		yaw = -1 * yaw;
	}

	return yaw;
}

function need_to_run()
{
	run_dist_squared = ( (500) * (500) );
	run_yaw = 20;
	run_pitch = 30;
	run_height = 64;

	if ( self.health < self.maxhealth )
	{
		// dog took damage
		return true;
	}

	if ( !IsDefined( self.enemy ) || !IsAlive( self.enemy ) )
	{
		return false;
	}

	if ( !self CanSee( self.enemy ) )
	{
		return false;
	}

	dist = DistanceSquared( self.origin, self.enemy.origin ); 
	if ( dist > run_dist_squared )
	{
		return false;
	}

	height = self.origin[2] - self.enemy.origin[2];
	if ( abs( height ) > run_height )
	{
		return false;
	}

	yaw = self AbsYawToEnemy();
	if ( yaw > run_yaw )
	{
		return false;
	}

	pitch = AngleClamp180( VectorToAngles( self.origin - self.enemy.origin )[0] );
	if ( abs( pitch ) > run_pitch )
	{
		return false;
	}

	return true;
}

function private is_target_valid( dog, target )
{
	if( !IsDefined( target ) ) 
	{
		return false; 
	}

	if( !IsAlive( target ) )
	{
		return false; 
	} 

	if( !IsPlayer( target ) && SessionModeIsZombiesGame() )
	{
		return false;
	}

	if( IsDefined(target.is_zombie) && target.is_zombie == true )
	{
		return false; 
	}

	if( IsPlayer( target ) && target.sessionstate == "spectator" )
	{
		return false; 
	}

	if( IsPlayer( target ) && target.sessionstate == "intermission" )
	{
		return false; 
	}
	
	if( ( isdefined( self.intermission ) && self.intermission ) )
	{
		return false;
	}
	
	if( ( isdefined( target.ignoreme ) && target.ignoreme ) )
	{
		return false;
	}

	if( target IsNoTarget() )
	{
		return false;
	}

	if( dog.team == target.team )
	{
		return false;
	}
	
	//for additional level specific checks
	if( IsPlayer( target ) && IsDefined( level.is_player_valid_override ) )
	{
		return [[ level.is_player_valid_override ]]( target );
	}
	
	return true; 
}

function private get_favorite_enemy( dog )
{
	dog_targets = [];
	if ( SessionModeIsZombiesGame() )
	{
		dog_targets = getplayers();
	}
	else
	{
		dog_targets = ArrayCombine( getplayers(), GetAIArray(), false, false );
	}
	least_hunted = dog_targets[0];
	closest_target_dist_squared = undefined;
	for( i = 0; i < dog_targets.size; i++ )
	{
		if ( !isdefined( dog_targets[i].hunted_by ) )
		{
			dog_targets[i].hunted_by = 0;
		}

		if( !is_target_valid( dog, dog_targets[i] ) )
		{
			continue;
		}

		if( !is_target_valid( dog, least_hunted ) )
		{
			least_hunted = dog_targets[i];
		}

		dist_squared = DistanceSquared( dog.origin, dog_targets[i].origin );			
		if( dog_targets[i].hunted_by <= least_hunted.hunted_by && ( !IsDefined( closest_target_dist_squared ) || dist_squared < closest_target_dist_squared ) )
		{
			least_hunted = dog_targets[i];
			closest_target_dist_squared = dist_squared;
		}
	}
	// do not return the default first player if he is invalid
	if( !is_target_valid( dog, least_hunted ) )
	{
		return undefined;
	}
	else
	{
		least_hunted.hunted_by += 1;

		return least_hunted;
	}

}

function get_last_valid_position()
{
	if ( IsPlayer( self ) )
		return self.last_valid_position;
	return self.origin;
}

function get_locomotion_target( behaviorTreeEntity )
{
	last_valid_position = behaviorTreeEntity.favoriteenemy get_last_valid_position();
	if ( !IsDefined( last_valid_position ) )
		return undefined;

	locomotion_target = last_valid_position;
	if ( ai::has_behavior_attribute( "spacing_value" ) )
	{
		// calculate the point based on the spacing values
		spacing_near_dist = ai::get_behavior_attribute( "spacing_near_dist" );
		spacing_far_dist = ai::get_behavior_attribute( "spacing_far_dist" );
		spacing_horz_dist = ai::get_behavior_attribute( "spacing_horz_dist" );
		spacing_value = ai::get_behavior_attribute( "spacing_value" );

		// get the offset from our target and get a vector perpendicular to it
		to_enemy = behaviorTreeEntity.favoriteenemy.origin - behaviorTreeEntity.origin;
		perp = VectorNormalize( ( -to_enemy[1], to_enemy[0], 0 ) );

		// calculate the offset from the target
		offset = perp * spacing_horz_dist * spacing_value;

		// lerp to actual target position based on distance
		spacing_dist = math::clamp( Length( to_enemy ), spacing_near_dist, spacing_far_dist );
		lerp_amount = math::clamp( ( spacing_dist - spacing_near_dist ) / ( spacing_far_dist - spacing_near_dist ), 0.0, 1.0 );
		desired_point = last_valid_position + ( offset * lerp_amount );

		// get the closest pathable point
		desired_point = GetClosestPointOnNavMesh( desired_point, spacing_horz_dist * 1.2, 16 );
		if ( IsDefined( desired_point ) )
		{
			///#
			//line( behaviorTreeEntity.origin, desired_point, ( 1.0, 1.0, 0.0 ), 0.9, 1 );
			//#/
			locomotion_target = desired_point;
		}
	}

	return locomotion_target;
}

// ------- ZOMBIE DOG - TARGET SERVICE -----------//
function zombieDogTargetService( behaviorTreeEntity )
{
	// don't target if the round is over
	if ( ( isdefined( level.intermission ) && level.intermission ) )
	{
		behaviorTreeEntity ClearPath();
		return;
	}

	// don't move if we don't have a target
	if ( behaviorTreeEntity.ignoreall || behaviorTreeEntity.pacifist || ( isdefined( behaviorTreeEntity.favoriteenemy ) && !is_target_valid( behaviorTreeEntity, behaviorTreeEntity.favoriteenemy ) ) )
	{
		behaviorTreeEntity.favoriteenemy = undefined;
		behaviorTreeEntity.hasSeenFavoriteEnemy = false;

		//if enemies are not valid, stay at the spot
		if ( !behaviorTreeEntity.ignoreall )
		{
			behaviorTreeEntity SetGoal( behaviorTreeEntity.origin );
		}

		return;
	}

	// dog isn't in playable area yet
	if ( ( isdefined( behaviorTreeEntity.ignoreme ) && behaviorTreeEntity.ignoreme ) )
	{
		return;
	}

	// calculate a favorite enemy if we don't have one (zombie mode does this in another script)
	if( !SessionModeIsZombiesGame() && !is_target_valid(behaviorTreeEntity, behaviorTreeEntity.favoriteenemy) )
	{
		behaviorTreeEntity.favoriteenemy = get_favorite_enemy( behaviorTreeEntity );
	}

	// have we seen our target yet?
	if ( !( isdefined( behaviorTreeEntity.hasSeenFavoriteEnemy ) && behaviorTreeEntity.hasSeenFavoriteEnemy ) )
	{
		if ( IsDefined( behaviorTreeEntity.favoriteenemy ) && behaviorTreeEntity need_to_run() )
		{
			behaviorTreeEntity.hasSeenFavoriteEnemy = true;
		}
	}

	// always move towards enemy
	if ( IsDefined( behaviorTreeEntity.favoriteenemy ) )
	{
		locomotion_target = get_locomotion_target( behaviorTreeEntity );
		if ( IsDefined( locomotion_target ) )
		{
			repathDist = 16;
			if ( !IsDefined( behaviorTreeEntity.lastTargetPosition ) || DistanceSquared( behaviorTreeEntity.lastTargetPosition, locomotion_target ) > ( (repathDist) * (repathDist) ) || !behaviorTreeEntity HasPath() )
			{
				behaviorTreeEntity UsePosition( locomotion_target );
				behaviorTreeEntity.lastTargetPosition = locomotion_target;
			}
		}
	}
}

// ------- ZOMBIE DOG - SHOULD MELEE CONDITION -----------//
function zombieDogShouldMelee( behaviorTreeEntity )
{
	// don't melee if we don't have a target
	if ( behaviorTreeEntity.ignoreall || !is_target_valid( behaviorTreeEntity, behaviorTreeEntity.favoriteenemy ) )
	{
		return false;
	}

	if ( !( isdefined( level.intermission ) && level.intermission ) )
	{
		meleeDist = 6 * 12;	// 6 ft
		if ( DistanceSquared( behaviorTreeEntity.origin, behaviorTreeEntity.favoriteenemy.origin ) < ( (meleeDist) * (meleeDist) ) && behaviorTreeEntity CanSee( behaviorTreeEntity.favoriteenemy ) )
		{
			return true;
		}
	}

	return false;
}

// ------- ZOMBIE DOG - SHOULD WALK CONDITION -----------//
function zombieDogShouldWalk( behaviorTreeEntity )
{
	return BB_GetShouldRunStatus() == "walk";
}

// ------- ZOMBIE DOG - SHOULD RUN CONDITION -----------//
function zombieDogShouldRun( behaviorTreeEntity )
{
	return BB_GetShouldRunStatus() == "run";
}

// ------- ZOMBIE DOG - MELEE ACTION -----------//
function use_low_attack()
{
	if ( !IsDefined( self.enemy ) || !IsPlayer( self.enemy ) )
		return false;

	height_diff = self.enemy.origin[2] - self.origin[2];
	
	low_enough = 30.0;

 	if ( height_diff < low_enough && self.enemy GetStance() == "prone" )
 	{
 		return true;
 	}

	// check if the jumping melee attack origin would be in a solid
	melee_origin = ( self.origin[0], self.origin[1], self.origin[2] + 65 );
	enemy_origin = ( self.enemy.origin[0], self.enemy.origin[1], self.enemy.origin[2] + 32 );

	if ( !BulletTracePassed( melee_origin, enemy_origin, false, self ) )
	{
		return true;
	}
 	
 	return false;
}

function zombieDogMeleeAction( behaviorTreeEntity, asmStateName )
{
	behaviorTreeEntity ClearPath();

	context = "high";
	if ( behaviorTreeEntity use_low_attack() )
		context = "low";
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_context", context );

	AnimationStateNetworkUtility::RequestState( behaviorTreeEntity, asmStateName );
	return 5;
}

function zombieDogMeleeActionTerminate( behaviorTreeEntity, asmStateName )
{
	Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_context", undefined );

	return 4;
}
