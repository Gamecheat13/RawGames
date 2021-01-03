#using scripts\shared\ai\archetype_human_cover;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\animation_state_machine_notetracks;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                 	              
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	

#namespace AnimationStateNetwork;

function autoexec RegisterDefaultNotetrackHandlerFunctions()
{
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("fire",&notetrackFireBullet);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("gib_disable",&notetrackGibDisable);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("gib = \"head\"",&GibServerUtils::GibHead);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("gib = \"arm_left\"",&GibServerUtils::GibLeftArm);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("gib = \"arm_right\"",&GibServerUtils::GibRightArm);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("gib = \"leg_left\"",&GibServerUtils::GibLeftLeg);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("gib = \"leg_right\"",&GibServerUtils::GibRightLeg);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("dropgun",&notetrackDropGun);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("gun drop",&notetrackDropGun);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("drop_shield",&notetrackDropShield);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("hide_weapon",&notetrackHideWeapon);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("show_weapon",&notetrackShowWeapon);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("attach_knife",&notetrackAttachKnife);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("detach_knife",&notetrackDetachKnife);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("grenade_throw",&notetrackGrenadeThrow);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("start_ragdoll",&notetrackStartRagdoll);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("ragdoll_nodeath",&notetrackStartRagdollNoDeath);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("unsync",&notetrackMeleeUnsync);;
	
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("step1",&notetrackStaircaseStep1);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("step2",&notetrackStaircaseStep2);;
	
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("anim_movement = \"stop\"",&notetrackAnimMovementStop);;
	
	AnimationStateNetwork::RegisterBlackboardNotetrackHandler("anim_pose = \"stand\"","_stance","stand");;
	AnimationStateNetwork::RegisterBlackboardNotetrackHandler("anim_pose = \"crouch\"","_stance","crouch");;
	AnimationStateNetwork::RegisterBlackboardNotetrackHandler("anim_pose = \"prone_front\"","_stance","prone_front");;
	AnimationStateNetwork::RegisterBlackboardNotetrackHandler("anim_pose = \"prone_back\"","_stance","prone_back");;
}

function private notetrackAnimMovementStop( entity )
{
	if( entity HasPath() )
	{
		entity PathMode( "move delayed", true, RandomFloatRange( 2, 4 ) );
	}
}

function private notetrackStaircaseStep1( entity )
{
	numSteps = Blackboard::GetBlackBoardAttribute( entity, "_staircase_num_steps" );
	numSteps++;
	
	Blackboard::SetBlackBoardAttribute( entity, "_staircase_num_steps", numSteps );
}

function private notetrackStaircaseStep2( entity )
{
	numSteps = Blackboard::GetBlackBoardAttribute( entity, "_staircase_num_steps" );
	numSteps += 2;
	
	Blackboard::SetBlackBoardAttribute( entity, "_staircase_num_steps", numSteps );
}

function private notetrackDropGunInternal( entity )
{	
	if( entity.weapon == level.weaponNone )
		return;
	
	entity.lastWeapon	= entity.weapon;
	primaryweapon		= entity.primaryweapon;
	secondaryweapon		= entity.secondaryweapon;
	
	entity thread shared::DropAIWeapon();
}

// necessary for AI vs AI melees where soldiers need to stab each other
function private notetrackAttachKnife( entity )
{
	if( !( isdefined( entity._ai_melee_attachedKnife ) && entity._ai_melee_attachedKnife ) )
	{
		entity Attach( "t6_wpn_knife_melee", "TAG_WEAPON_LEFT" );
		entity._ai_melee_attachedKnife = true;
	}
}

function private notetrackDetachKnife( entity )
{
	if( ( isdefined( entity._ai_melee_attachedKnife ) && entity._ai_melee_attachedKnife ) )
	{
		entity Detach( "t6_wpn_knife_melee", "TAG_WEAPON_LEFT" );
		entity._ai_melee_attachedKnife = false;
	}
}

function private notetrackHideWeapon( entity )
{
	entity ai::gun_remove();
}

function private notetrackShowWeapon( entity )
{
	entity ai::gun_recall();
}

function private notetrackStartRagdoll( entity )
{
    if( IsActor( entity ) && entity IsInScriptedState() )
    {
    	entity.overrideActorDamage = undefined;
    	entity.allowdeath = true;//This ignores/overrides the scene setting if set
    	entity.skipdeath = true;
        entity Kill();
    }
	
	// SUMEET HACK - drop gun, if its not dropped already
	notetrackDropGunInternal( entity );
	entity StartRagdoll();
}

function notetrackStartRagdollNoDeath( entity )
{
	if( IsDefined( entity._ai_melee_opponent ) )
	{
		entity._ai_melee_opponent Unlink();
	}
	
	entity StartRagdoll();
}

function private notetrackFireBullet( animationEntity )
{
	// Fire a MagicBullet in scripted animations
	if ( IsActor( animationEntity ) && animationEntity IsInScriptedState() )
	{
		if( animationEntity.weapon != level.weaponNone )
		{
			animationEntity notify("about_to_shoot");
			
			startPos	= animationEntity GetTagOrigin( "tag_flash" );
			endPos 		= startPos + VectorScale( animationEntity GetWeaponForwardDir(), 100 );
			MagicBullet( animationEntity.weapon, startPos, endPos, animationEntity );
			
			animationEntity notify("shoot");
			animationEntity.bulletsInClip--;
		}
	}
}

function private notetrackDropGun( animationEntity )
{
	notetrackDropGunInternal( animationEntity );
}

function private notetrackDropShield( animationEntity )
{
	AiUtility::dropRiotshield( animationEntity );
}

function private notetrackGrenadeThrow( animationEntity )
{
	if ( archetype_human_cover::shouldThrowGrenadeAtCoverCondition( animationEntity, true ) )
	{
		animationEntity GrenadeThrow();
	}
}

function private notetrackMeleeUnsync( animationEntity )
{
	if( IsDefined( animationEntity ) && IsDefined( animationEntity.enemy ) )
	{
		if( ( isdefined( animationEntity.enemy._ai_melee_markedDead ) && animationEntity.enemy._ai_melee_markedDead ) )
		{
			animationEntity unlink();
		}
	}
}

function private notetrackGibDisable( animationEntity )
{
	if ( animationEntity ai::has_behavior_attribute( "can_gib" ) )
	{
		animationEntity ai::set_behavior_attribute( "can_gib", false );
	}
}