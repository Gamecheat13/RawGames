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
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\zombie_utility;
#using scripts\codescripts\struct;
#using scripts\shared\ai\archetype_mocomps_utility;

                                                                                                             	     	                                                                                                                                                                
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                                                                                                                                                       	     	                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                                                       
                                                                  	                             	  	                                      
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace MargwaBehavior;

function autoexec init()
{
	// INIT BEHAVIORS
	InitMargwaBehaviorsAndASM();
	
	// INIT BLACKBOARD	
	spawner::add_archetype_spawn_function( "margwa", &ArchetypeMargwaBlackboardInit );

	// INIT MARGWA ON SPAWN
	spawner::add_archetype_spawn_function( "margwa", &MargwaServerUtils::margwaSpawnSetup );

	clientfield::register( "actor", "margwa_head_left", 1, 2, "int" );
	clientfield::register( "actor", "margwa_head_mid", 1, 2, "int" );
	clientfield::register( "actor", "margwa_head_right", 1, 2, "int" );
	clientfield::register( "actor", "margwa_fx_in", 1, 1, "counter" );
	clientfield::register( "actor", "margwa_fx_out", 1, 1, "counter" );
	clientfield::register( "actor", "margwa_fx_spawn", 1, 1, "counter" );
	clientfield::register( "actor", "margwa_smash", 1, 1, "counter" );
	clientfield::register( "actor", "margwa_head_left_hit", 1, 1, "counter" );
	clientfield::register( "actor", "margwa_head_mid_hit", 1, 1, "counter" );
	clientfield::register( "actor", "margwa_head_right_hit", 1, 1, "counter" );

	clientfield::register( "actor", "margwa_head_killed", 1, 2, "int" );
	clientfield::register( "actor", "margwa_jaw", 1, 6, "int" );

	clientfield::register( "toplayer", "margwa_head_explosion", 1, 1, "counter" );
	clientfield::register( "scriptmover", "margwa_fx_travel", 1, 1, "int" );
	clientfield::register( "scriptmover", "margwa_fx_travel_tell", 1, 1, "int" );

	InitDirectHitWeapons();
}

function private InitDirectHitWeapons()
{
	level.dhWeapons = [];
	level.dhWeapons[ level.dhWeapons.size ] = "ray_gun";
	level.dhWeapons[ level.dhWeapons.size ] = "ray_gun_upgraded";
	level.dhWeapons[ level.dhWeapons.size ] = "pistol_standard_upgraded";
	level.dhWeapons[ level.dhWeapons.size ] = "launcher_standard";
	level.dhWeapons[ level.dhWeapons.size ] = "launcher_standard_upgraded";
}

function private InitMargwaBehaviorsAndASM()
{
	// SERVICES
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTargetService",&MargwaBehavior::margwaTargetService);;

	// CONDITIONS
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldSmashAttack",&MargwaBehavior::margwaShouldSmashAttack);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldSwipeAttack",&MargwaBehavior::margwaShouldSwipeAttack);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldShowPain",&MargwaBehavior::margwaShouldShowPain);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldReactStun",&MargwaBehavior::margwaShouldReactStun);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldReactIDGun",&MargwaBehavior::margwaShouldReactIDGun);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldReactSword",&MargwaBehavior::margwaShouldReactSword);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldSpawn",&MargwaBehavior::margwaShouldSpawn);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldFreeze",&MargwaBehavior::margwaShouldFreeze);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldTeleportIn",&MargwaBehavior::margwaShouldTeleportIn);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldTeleportOut",&MargwaBehavior::margwaShouldTeleportOut);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaShouldWait",&MargwaBehavior::margwaShouldWait);;

	// ACTIONS
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("margwaReactStunAction",&MargwaBehavior::margwaReactStunAction,undefined,undefined);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeAction("margwaSwipeAttackAction",&MargwaBehavior::margwaSwipeAttackAction,&MargwaBehavior::margwaSwipeAttackActionUpdate,undefined);;

	// FUNCTIONS
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaIdleStart",&MargwaBehavior::margwaIdleStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaMoveStart",&MargwaBehavior::margwaMoveStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTraverseActionStart",&MargwaBehavior::margwaTraverseActionStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTeleportInStart",&MargwaBehavior::margwaTeleportInStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTeleportInTerminate",&MargwaBehavior::margwaTeleportInTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTeleportOutStart",&MargwaBehavior::margwaTeleportOutStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaTeleportOutTerminate",&MargwaBehavior::margwaTeleportOutTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaPainStart",&MargwaBehavior::margwaPainStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaPainTerminate",&MargwaBehavior::margwaPainTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactStunStart",&MargwaBehavior::margwaReactStunStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactStunTerminate",&MargwaBehavior::margwaReactStunTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactIDGunStart",&MargwaBehavior::margwaReactIDGunStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactIDGunTerminate",&MargwaBehavior::margwaReactIDGunTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactSwordStart",&MargwaBehavior::margwaReactSwordStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaReactSwordTerminate",&MargwaBehavior::margwaReactSwordTerminate);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSpawnStart",&MargwaBehavior::margwaSpawnStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSmashAttackStart",&MargwaBehavior::margwaSmashAttackStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSmashAttackTerminate",&MargwaBehavior::margwaSmashAttackTerminate);;

	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSwipeAttackStart",&MargwaBehavior::margwaSwipeAttackStart);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("margwaSwipeAttackTerminate",&MargwaBehavior::margwaSwipeAttackTerminate);;

	// MOCOMPS
	AnimationStateNetwork::RegisterAnimationMocomp("mocomp_teleport_traversal@margwa",&mocompMargwaTeleportTraversalInit,&mocompMargwaTeleportTraversalUpdate,&mocompMargwaTeleportTraversalTerminate);;

	// NOTETRACKS
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("margwa_smash_attack",&MargwaBehavior::margwaNotetrackSmashAttack);;
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("margwa_bodyfall large",&MargwaBehavior::margwaNotetrackBodyfall);;	
	AnimationStateNetwork::RegisterNotetrackHandlerFunction("margwa_melee_fire",&MargwaBehavior::margwaNotetrackPainMelee);;	
}

function private ArchetypeMargwaBlackboardInit()
{
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( self );
	
	// USE UTILITY BLACKBOARD
	self AiUtility::RegisterUtilityBlackboardAttributes();
	
	// CREATE MARGWA BLACKBOARD
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_speed","locomotion_speed_walk",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_speed");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_board_attack_spot",undefined,undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_board_attack_spot");#/    };	
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_should_turn","should_not_turn",&BB_GetShouldTurn);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_should_turn");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_zombie_damageweapon_type","regular",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_zombie_damageweapon_type");#/    };
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeMargwaOnAnimscriptedCallback;
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#self FinalizeTrackedBlackboardAttributes();#/;
}

function private ArchetypeMargwaOnAnimscriptedCallback( entity )
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeMargwaBlackboardInit();
}

function private BB_GetShouldTurn()
{
	if( IsDefined( self.should_turn ) && self.should_turn )
	{
		return "should_turn";
	}
	return "should_not_turn";
}

//----------------------------------------------------------------------------------------------------------------------------
// NOTETRACK HANDLERS
//----------------------------------------------------------------------------------------------------------------------------
function private margwaNotetrackSmashAttack( entity )
{
	players = GetPlayers();
	foreach( player in players )
	{
		smashPos = entity.origin + VectorScale( AnglesToForward( self.angles ), 60 );
		distSq = DistanceSquared( smashPos, player.origin );
		if ( distSq < 144 * 144 )
		{
			if ( !IsGodMode( player ) )
			{
				// riot shield can block damage from front or back
				if ( ( isdefined( player.hasRiotShield ) && player.hasRiotShield ) )
				{
					damageShield = false;
					attackDir = player.origin - self.origin;

					if ( ( isdefined( player.hasRiotShieldEquipped ) && player.hasRiotShieldEquipped ) )
					{
						if ( player margwaServerUtils::shieldFacing( attackDir, 0.2 ) )
						{
							damageShield = true;
						}
					}
					else
					{
						if ( player margwaServerUtils::shieldFacing( attackDir, 0.2, false ) )
						{
							damageShield = true;
						}
					}

					if ( damageShield )
					{
						self clientfield::increment( "margwa_smash" );
						shield_damage = level.weaponRiotshield.weaponstarthitpoints;
						if ( IsDefined( player.weaponRiotshield ) )
							shield_damage = player.weaponRiotshield.weaponstarthitpoints;
						player [[ player.player_shield_apply_damage ]]( shield_damage, false );
						continue;
					}
				}
				
				if ( isdefined( level.margwa_smash_damage_callback ) && IsFunctionPtr( level.margwa_smash_damage_callback ) )
				{
					if ( player [[ level.margwa_smash_damage_callback ]]( self ) )
					{
						continue;
					}
				}
				
				self clientfield::increment( "margwa_smash" );
				player DoDamage( 166, self.origin, self );
			}
		}
	}

	if ( IsDefined( self.smashAttackCB ) )
	{
		self [[ self.smashAttackCB ]]();
	}
}

// Fx takes over after margwa hits the ground
function private margwaNotetrackBodyfall( entity )
{
	if( self.archetype == "margwa" )
	{
		entity Ghost();

		if ( IsDefined( self.bodyfallCB ) )
		{
			self [[ self.bodyfallCB ]]();
		}
	}
}

function private margwaNotetrackPainMelee( entity )
{
	entity Melee();
}

//----------------------------------------------------------------------------------------------------------------------------
// BEHAVIOR TREE
//----------------------------------------------------------------------------------------------------------------------------
function private margwaTargetService( entity )
{
	if ( ( isdefined( entity.ignoreall ) && entity.ignoreall ) )
	{
		return false;
	}

	player = zombie_utility::get_closest_valid_player( self.origin, self.ignore_player );

	if( !IsDefined( player ) )
	{
		if( IsDefined( self.ignore_player ) )
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
		targetPos = GetClosestPointOnNavMesh( player.origin, 64, 30 );
		if ( IsDefined( targetPos ) )
		{
			entity SetGoal( targetPos );		
			return true;
		}
		else
		{
			entity SetGoal( entity.origin );
			return false;
		}
	}
}

function margwaShouldSmashAttack( entity )
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

	if ( entity MargwaServerUtils::inSmashAttackRange( entity.enemy ) )
	{
		return true;
	}

	return false;
}

function margwaShouldSwipeAttack( entity )
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

function private margwaShouldShowPain( entity )
{
	if ( IsDefined( entity.headDestroyed ) )
	{
		switch( entity.headDestroyed )
		{
		case "c_zom_margwa_chunks_le":
			Blackboard::SetBlackBoardAttribute( self, "_margwa_head", "left" );
			break;

		case "c_zom_margwa_chunks_mid":
			Blackboard::SetBlackBoardAttribute( self, "_margwa_head", "middle" );
			break;

		case "c_zom_margwa_chunks_ri":
			Blackboard::SetBlackBoardAttribute( self, "_margwa_head", "right" );
			break;
		}

		return true;

	}

	return false;
}

function private margwaShouldReactStun( entity )
{
	if ( ( isdefined( entity.reactStun ) && entity.reactStun ) )
	{
		return true;
	}

	return false;
}

function private margwaShouldReactIDGun( entity )
{
	if ( ( isdefined( entity.reactIDGun ) && entity.reactIDGun ) )
	{
		return true;
	}

	return false;
}

function private margwaShouldReactSword( entity )
{
	if ( ( isdefined( entity.reactSword ) && entity.reactSword ) )
	{
		return true;
	}

	return false;
}

function private margwaShouldSpawn( entity )
{
	if ( ( isdefined( entity.needSpawn ) && entity.needSpawn ) )
	{
		return true;
	}

	return false;
}

function private margwaShouldFreeze( entity )
{
	if ( ( isdefined( entity.isFrozen ) && entity.isFrozen ) )
	{
		return true;
	}

	return false;
}

function private margwaShouldTeleportIn( entity )
{
	if ( ( isdefined( entity.needTeleportIn ) && entity.needTeleportIn ) )
	{
		return true;
	}

	return false;
}

function private margwaShouldTeleportOut( entity )
{
	if ( ( isdefined( entity.needTeleportOut ) && entity.needTeleportOut ) )
	{
		return true;
	}

	return false;
}

function private margwaShouldWait( entity )
{
	if ( ( isdefined( entity.waiting ) && entity.waiting ) )
	{
		return true;
	}

	return false;
}

//----------------------------------------------------------------------------------------------------------------------------------
// ACTIONS
//----------------------------------------------------------------------------------------------------------------------------------
function private margwaReactStunAction( entity, asmStateName )
{
	AnimationStateNetworkUtility::RequestState( entity, asmStateName );

	stunActionAST = entity ASTSearch( IString( asmStateName ) );
	stunActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap( entity, stunActionAST[ "animation" ] );

	closeTime = GetAnimLength( stunActionAnimation ) * 1000;

	entity MargwaServerUtils::margwaCloseAllHeads( closeTime );

	MargwaBehavior::margwaReactStunStart( entity );

	return 5;
}


function private margwaSwipeAttackAction( entity, asmStateName )
{
	AnimationStateNetworkUtility::RequestState( entity, asmStateName );

	if ( !isdefined( entity.swipe_end_time ) )
	{
		swipeActionAST = entity ASTSearch( IString( asmStateName ) );
		swipeActionAnimation = AnimationStateNetworkUtility::SearchAnimationMap( entity, swipeActionAST[ "animation" ] );
		swipeActionTime = GetAnimLength( swipeActionAnimation ) * 1000;

		entity.swipe_end_time = GetTime() + swipeActionTime;
	}

	return 5;
}

function private margwaSwipeAttackActionUpdate( entity, asmStateName )
{
	if ( isdefined( entity.swipe_end_time ) && GetTime() > entity.swipe_end_time )
	{
		return 4;
	}

	return 5;
}

function private margwaIdleStart( entity )
{
	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		entity clientfield::set( "margwa_jaw", 1 );
	}
}

function private margwaMoveStart( entity )
{
	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		if ( entity.zombie_move_speed == "run" )
		{
			entity clientfield::set( "margwa_jaw", 13 );
		}
		else
		{
			entity clientfield::set( "margwa_jaw", 7 );
		}
	}
}

function private margwaDeathAction( entity )
{
	//insert anything that needs to be done right before zombie death
}

function private margwaTraverseActionStart( entity )
{
	Blackboard::SetBlackBoardAttribute( entity, "_traversal_type", entity.traverseStartNode.animscript );

	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		switch ( entity.traverseStartNode.animscript )
		{
		case "jump_down_36":
			entity clientfield::set( "margwa_jaw", 21 );
			break;

		case "jump_down_96":
			entity clientfield::set( "margwa_jaw", 22 );
			break;

		case "jump_up_36":
			entity clientfield::set( "margwa_jaw", 24 );
			break;

		case "jump_up_96":
			entity clientfield::set( "margwa_jaw", 25 );
			break;
		}
	}
}

function private margwaTeleportInStart( entity )
{
	entity Unlink();
	if ( IsDefined( entity.teleportPos ) )
	{
		entity ForceTeleport( entity.teleportPos );
	}
	entity Show();
	entity PathMode( "move allowed" );
	entity.needTeleportIn = false;
	Blackboard::SetBlackBoardAttribute( self, "_margwa_teleport", "in" );
	self.traveler clientfield::set( "margwa_fx_travel", 0 );
	self clientfield::increment( "margwa_fx_in", 1 );

	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		entity clientfield::set( "margwa_jaw", 17 );
	}
}

function margwaTeleportInTerminate( entity )
{
	if ( isdefined( self.traveler ) )
	{
		self.traveler clientfield::set( "margwa_fx_travel", 0 );
	}
	entity.isTeleporting = false;
}

function private margwaTeleportOutStart( entity )
{
	entity.needTeleportOut = false;
	entity.isTeleporting = true;
	entity.teleportStart = entity.origin;

	Blackboard::SetBlackBoardAttribute( self, "_margwa_teleport", "out" );
	self clientfield::increment( "margwa_fx_out", 1 );

	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		entity clientfield::set( "margwa_jaw", 18 );
	}
}

function private margwaTeleportOutTerminate( entity )
{
	if ( isdefined( entity.traveler ) )
	{
		entity.traveler.origin = entity GetTagOrigin( "j_spine_1" );
		entity.traveler clientfield::set( "margwa_fx_travel", 1 );
	}

	entity Ghost();
	entity PathMode( "dont move" );

	if ( isdefined( entity.traveler ) )
	{
		entity LinkTo( entity.traveler );
	}

	entity thread MargwaServerUtils::margwaWait();
}

function private margwaPainStart( entity )
{
	entity notify( "stop_head_update" );
	entity.headDestroyed = undefined;
	entity.canStun = false;
	entity.canDamage = false;

	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		head = Blackboard::GetBlackBoardAttribute( self, "_margwa_head" );
		switch ( head )
		{
		case "left":
			entity clientfield::set( "margwa_jaw", 3 );
			break;

		case "middle":
			entity clientfield::set( "margwa_jaw", 4 );
			break;

		case "right":
			entity clientfield::set( "margwa_jaw", 5 );
			break;

		}
	}
}

function private margwaPainTerminate( entity )
{
	entity.headDestroyed = undefined;
	entity.canStun = true;
	entity.canDamage = true;

	entity MargwaServerUtils::margwaCloseAllHeads( 5000 );

	entity ClearPath();
}

function private margwaReactStunStart( entity )
{
	entity.reactStun = undefined;
	entity.canStun = false;

	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		entity clientfield::set( "margwa_jaw", 6 );
	}
}

function private margwaReactStunTerminate( entity )
{
	entity.canStun = true;
}

function private margwaReactIDGunStart( entity )
{
	entity.reactIDGun = undefined;
	entity.canStun = false;
	
	if( BlackBoard::GetBlackBoardAttribute( entity, "_zombie_damageweapon_type" ) == "regular" )
	{
		if ( entity MargwaServerUtils::shouldUpdateJaw() )
		{
			entity clientfield::set( "margwa_jaw", 8 );
		}
		entity MargwaServerUtils::margwaCloseAllHeads( 5000 );
	}
	else
	{
		if ( entity MargwaServerUtils::shouldUpdateJaw() )
		{
			entity clientfield::set( "margwa_jaw", 9 );
		}
		entity MargwaServerUtils::margwaCloseAllHeads( 2 * 5000 );
	}
}

function private margwaReactIDGunTerminate( entity )
{
	entity.canStun = true;
	Blackboard::SetBlackBoardAttribute( entity, "_zombie_damageweapon_type", "regular" );
}

function private margwaReactSwordStart( entity )
{
	entity.reactSword = undefined;
	entity.canStun = false;

	if ( IsDefined( entity.head_chopper ) )
	{
		entity.head_chopper notify( "react_sword" );
	}
}

function private margwaReactSwordTerminate( entity )
{
	entity.canStun = true;
}

function private margwaSpawnStart( entity )
{
	entity.needSpawn = false;
}

function private margwaSmashAttackStart( entity )
{
	entity MargwaServerUtils::margwaHeadSmash();

	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		entity clientfield::set( "margwa_jaw", 14 );
	}
}

function margwaSmashAttackTerminate( entity )
{
	entity MargwaServerUtils::margwaCloseAllHeads();
}

function margwaSwipeAttackStart( entity )
{
	if ( entity MargwaServerUtils::shouldUpdateJaw() )
	{
		entity clientfield::set( "margwa_jaw", 16 );
	}
}

function private margwaSwipeattackTerminate( entity )
{
	entity MargwaServerUtils::margwaCloseAllHeads();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// MOCOMPS
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function private mocompMargwaTeleportTraversalInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity OrientMode( "face angle", entity.angles[1] );
	entity AnimMode( "normal" );

	if ( isdefined( entity.traverseEndNode ) )
	{
		entity.teleportStart = entity.origin;
		entity.teleportPos = entity.traverseEndNode.origin;
		self clientfield::increment( "margwa_fx_out", 1 );
	}
}

function private mocompMargwaTeleportTraversalUpdate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
}

function private mocompMargwaTeleportTraversalTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	margwaTeleportOutTerminate( entity );
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#namespace MargwaServerUtils;

function private margwaSpawnSetup()
{
	self DisableAimAssist();

	self.disableAmmoDrop = true;
	self.no_gib = true;
	self.ignore_nuke = true;
	self.ignore_enemy_count = true;

	self.zombie_move_speed = "walk";

	self.overrideActorDamage = &margwaDamage;
	self.canDamage = true;

	self.headAttached = 3;
	self.headOpen = 0;

	self margwaInitHead( "c_zom_margwa_chunks_le", "j_chunk_head_bone_le" );
	self margwaInitHead( "c_zom_margwa_chunks_mid", "j_chunk_head_bone" );
	self margwaInitHead( "c_zom_margwa_chunks_ri", "j_chunk_head_bone_ri" );

	self margwaEnableStun();

	self.traveler = Spawn( "script_model", self.origin );
	self.traveler SetModel( "tag_origin" );
	self.traveler NotSolid();

	self.travelerTell = Spawn( "script_model", self.origin );
	self.travelerTell SetModel( "tag_origin" );
	self.travelerTell NotSolid();

	self thread margwaDeath();
}

function private margwaDeath()
{
	self waittill( "death" );

	if ( IsDefined( self.traveler ) )
	{
		self.traveler Delete();
	}

	if ( IsDefined( self.travelerTell ) )
	{
		self.travelerTell Delete();
	}
}

function private margwaEnableStun()
{
	self.canStun = true;
}

function private margwaDisableStun()
{
	self.canStun = false;
}

function private margwaInitHead( headModel, headTag )
{
	self Attach( headModel );

	if ( !IsDefined( self.head ) )
	{
		self.head = [];
	}

	self.head[ headModel ] = SpawnStruct();
	self.head[ headModel ].model = headModel;
	self.head[ headModel ].tag = headTag;
	self.head[ headModel ].health = 600;
	self.head[ headModel ].canDamage = false;

	self.head[ headModel ].open = 1;
	self.head[ headModel ].closed = 2;
	self.head[ headModel ].smash = 3;

	switch ( headModel )
	{
	case "c_zom_margwa_chunks_le":
		self.head[ headModel ].cf = "margwa_head_left";
		self.head[ headModel ].impactCF = "margwa_head_left_hit";
		self.head[ headModel ].gore = "c_zom_margwa_gore_le";
		self.head[ headModel ].killIndex = 1;
		break;

	case "c_zom_margwa_chunks_mid":
		self.head[ headModel ].cf = "margwa_head_mid";
		self.head[ headModel ].impactCF = "margwa_head_mid_hit";
		self.head[ headModel ].gore = "c_zom_margwa_gore_mid";
		self.head[ headModel ].killIndex = 2;
		break;

	case "c_zom_margwa_chunks_ri":
		self.head[ headModel ].cf = "margwa_head_right";
		self.head[ headModel ].impactCF = "margwa_head_right_hit";
		self.head[ headModel ].gore = "c_zom_margwa_gore_ri";
		self.head[ headModel ].killIndex = 3;
		break;
	}

	self thread margwaHeadUpdate( self.head[ headModel ] );
}

function margwaSetHeadHealth( health )
{
	foreach( head in self.head )
	{
		head.health = health;
	}
}

function private margwaResetHeadTime( min, max )
{
	time = GetTime() + RandomIntRange( min, max );
	return time;
}

function private margwaHeadCanOpen()
{
	if ( self.headAttached > 1 )
	{
		if ( self.headOpen < (self.headAttached - 1) )
		{
			return true;
		}
	}
	else
	{
		return true;
	}

	return false;
}

function private margwaHeadUpdate( headInfo )
{
	self endon( "death" );
	self endon( "stop_head_update" );
	headInfo endon( "stop_head_update" );

	while ( 1 )
	{
		if ( !IsDefined( headInfo.closeTime ) )
		{
			if ( self.headAttached == 1 )
			{
				headInfo.closeTime = margwaResetHeadTime( 500, 1000 );
			}
			else
			{
				headInfo.closeTime = margwaResetHeadTime( 1500, 3500 );
			}
		}

		if ( GetTime() > headInfo.closeTime && self margwaHeadCanOpen() )
		{
			self.headOpen++;
			headInfo.closeTime = undefined;
		}
		else
		{
			util::wait_network_frame();
			continue;
		}

		self margwaHeadDamageDelay( headInfo, true );
		self clientfield::set( headInfo.cf, headInfo.open );
		self playsoundontag( "zmb_vocals_margwa_ambient", headInfo.tag );

		while ( 1 )
		{
			if ( !IsDefined( headInfo.openTime ) )
			{
				headInfo.openTime = margwaResetHeadTime( 3000, 5000 );
			}

			if ( GetTime() > headInfo.openTime )
			{
				self.headOpen--;
				headInfo.openTime = undefined;
				break;
			}
			else
			{
				util::wait_network_frame();
				continue;
			}
		}

		self margwaHeadDamageDelay( headInfo, false );
		self clientfield::set( headInfo.cf, headInfo.closed );
	}
}

function private margwaHeadDamageDelay( headInfo, canDamage )
{
	self endon( "death" );

	wait( 0.1 );

	headInfo.canDamage = canDamage;
}

function private margwaHeadSmash()
{
	self notify( "stop_head_update" );

	headAlive = [];
	foreach( head in self.head )
	{
		if ( head.health > 0 )
		{
			headAlive[ headAlive.size ] = head;
		}
	}

	headAlive = array::randomize( headAlive );
	open = false;

	foreach( head in headAlive )
	{
		if ( !open )
		{
			head.canDamage = true;
			self clientfield::set( head.cf, head.smash );
			open = true;
		}
		else
		{
			self margwaCloseHead( head );
		}
	}
}

function private margwaCloseHead( headInfo )
{
	headInfo.canDamage = false;
	self clientfield::set( headInfo.cf, headInfo.closed );
}

function private margwaCloseAllHeads( closeTime )
{
	foreach ( head in self.head )
	{
		if ( head.health > 0 )
		{
			head.closeTime = undefined;
			head.openTime = undefined;

			if ( IsDefined( closeTime ) )
			{
				head.closeTime = GetTime() + closeTime;
			}

			self.headOpen = 0;

			self margwaCloseHead( head );
			self thread margwaHeadUpdate( head );
		}
	}
}

function margwaKillHead( modelHit, attacker )
{
	headInfo = self.head[ modelHit ];

	headInfo.health = 0;
	headInfo notify( "stop_head_update" );

	if ( ( isdefined( headInfo.canDamage ) && headInfo.canDamage ) )
	{
		self margwaCloseHead( headInfo );
		self.headOpen--;
	}

	self margwaUpdateMoveSpeed();

	if ( IsDefined( self.destroyHeadCB ) )
	{
		self thread [[ self.destroyHeadCB ]]( modelHit, attacker );
	}

	self clientfield::set( "margwa_head_killed", headInfo.killIndex );

	self Detach( modelHit );
	self Attach( headInfo.gore );
	self.headAttached--;
	if ( self.headAttached <= 0 )
	{
		return true;
	}
	else
	{
		self.headDestroyed = modelHit;
	}

	return false;
}

function margwaCanDamageAnyHead()
{
	foreach( head in self.head )
	{
		if ( IsDefined( head ) && head.health > 0 && ( isdefined( head.canDamage ) && head.canDamage ) )
		{
			return true;
		}
	}
	
	return false;
}

function margwaCanDamageHead()
{
	if ( IsDefined( self ) && self.health > 0 && ( isdefined( self.canDamage ) && self.canDamage ) )
	{
		return true;
	}

	return false;
}


function show_hit_marker()  // self = player
{
	if ( IsDefined( self ) && IsDefined( self.hud_damagefeedback ) )
	{
		self.hud_damagefeedback SetShader( "damage_feedback", 24, 48 );
		self.hud_damagefeedback.alpha = 1;
		self.hud_damagefeedback FadeOverTime(1);
		self.hud_damagefeedback.alpha = 0;
	}	
}

function private isDirectHitWeapon( weapon )
{
	foreach( dhWeapon in level.dhWeapons )
	{
		if ( weapon.name == dhWeapon )
		{
			return true;
		}
	}

	return false;
}


// uses the bone name to figure out which head was hit
function margwaDamage( inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex )
{
	if( isdefined( level._margwa_damage_cb ) )
	{
		n_result = [[ level._margwa_damage_cb ]]( inflictor, attacker, damage, dFlags, mod, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex );
		
		if( isdefined( n_result ) )
		{
			return n_result;
		}
	}
	
	damageOpen = false;		// mouth was open during damage
	
	if ( !( isdefined( self.canDamage ) && self.canDamage ) )
	{
		self.health += 1;	// impact fx only work when damage is applied
		return 1;
	}

	if ( isDirectHitWeapon( weapon ) )
	{
		headAlive = [];
		foreach ( head in self.head )
		{
			if ( head margwaCanDamageHead() )
			{
				headAlive[ headAlive.size ] = head;
			}
		}

		if ( headAlive.size > 0 )
		{
			max = 100000;
			headClosest = undefined;
			foreach ( head in headAlive )
			{
				distSq = DistanceSquared( point, self GetTagOrigin( head.tag ) );
				if ( distSq < max )
				{
					max = distSq;
					headClosest = head;
				}
			}
			if ( IsDefined( headClosest ) )
			{
				if ( max < 24 * 24 )
				{
					if ( isdefined( level.margwa_damage_override_callback ) && IsFunctionPtr( level.margwa_damage_override_callback ) )
					{
						damage = attacker [[ level.margwa_damage_override_callback ]]( damage );
					}
					
					headClosest.health -= damage;
					damageOpen = true;
					self clientfield::increment( headClosest.impactCF );
					attacker show_hit_marker();

					if ( headClosest.health <= 0 )
					{
						if ( self margwaKillHead( headClosest.model, attacker ) )
						{
							return self.health;
						}
					}
				}
			}
		}
	}

	partName = GetPartName( "c_zom_margwa_body_jaw", boneIndex );
	if ( IsDefined( partName ) )
	{
		/#
			if ( ( isdefined( self.debugHitLoc ) && self.debugHitLoc ) )
			{
				PrintTopRightLn( partName + " damage: " + damage );
			}
		#/
		modelHit = self margwaHeadHit( partName );
		if ( IsDefined( modelHit ) )
		{
			headInfo = self.head[ modelHit ];
			if ( headInfo margwaCanDamageHead() )
			{
				if ( isdefined( level.margwa_damage_override_callback ) && IsFunctionPtr( level.margwa_damage_override_callback ) )
				{
					damage = attacker [[ level.margwa_damage_override_callback ]]( damage );
				}
				
				headInfo.health -= damage;
				damageOpen = true;
				self clientfield::increment( headInfo.impactCF );
				attacker show_hit_marker();

				if ( headInfo.health <= 0 )
				{
					if ( self margwaKillHead( modelHit, attacker ) )
					{
						return self.health;
					}
				}
			}
		}
	}

	if ( damageOpen )
	{
		return 0;		// custom fx when damaging head
	}

	self.health += 1;	// impact fx only work when damage is applied to ent
	return 1;
}

function private margwaHeadHit( partName )
{
	switch ( partName )
	{
	case "j_chunk_head_bone_le":
	case "j_jaw_lower_1_le":
		return "c_zom_margwa_chunks_le";

	case "j_chunk_head_bone":
	case "j_jaw_lower_1":
		return "c_zom_margwa_chunks_mid";

	case "j_chunk_head_bone_ri":
	case "j_jaw_lower_1_ri":
		return "c_zom_margwa_chunks_ri";
	}

	return undefined;
}

function private margwaUpdateMoveSpeed()
{
	if ( self.zombie_move_speed == "walk" )
	{
		self.zombie_move_speed = "run";
		//self ASMSetAnimationRate( 0.8 );
		Blackboard::SetBlackBoardAttribute( self, "_locomotion_speed", "locomotion_speed_run" );
	}
	else if ( self.zombie_move_speed == "run" )
	{
		self.zombie_move_speed = "sprint";
		//self ASMSetAnimationRate( 1.0 );
		Blackboard::SetBlackBoardAttribute( self, "_locomotion_speed", "locomotion_speed_sprint" );
	}
}

function private margwaDestroyHead( modelHit )
{
}

function shouldUpdateJaw()
{
	if ( !( isdefined( self.jawAnimEnabled ) && self.jawAnimEnabled ) )
	{
		return false;
	}

	if ( self.headAttached < 3 )
	{
		return true;
	}

	return false;
}

function margwaSetGoal( origin, radius, boundaryDist )
{
	pos = GetClosestPointOnNavMesh( origin, 64, 30 );
	if ( IsDefined( pos ) )
	{
		self SetGoal( pos );
		return true;
	}

	self SetGoal( self.origin );
	return false;
}

function private margwaWait()
{
	self endon( "death" );

	self.waiting = true;
	self.needTeleportIn = true;

	destPos = self.teleportPos + ( 0, 0, 60 );
	dist = Distance( self.teleportStart, destPos );
	time = dist / 600;

	if ( isdefined( self.traveler ) )
	{
		self thread margwaTell();

		self.traveler MoveTo( destPos, time );
		self.traveler util::waittill_any_timeout( ( time + 0.1 ), "movedone" );

		self.travelerTell clientfield::set( "margwa_fx_travel_tell", 0 );
	}

	self.waiting = false;
	self.needTeleportOut = false;
}

function private margwaTell()
{
	self endon( "death" );

	self.travelerTell.origin = self.teleportPos;

	util::wait_network_frame();

	self.travelerTell clientfield::set( "margwa_fx_travel_tell", 1 );
}

function private shieldFacing( vDir, limit, front = true )
{
	orientation = self getPlayerAngles();
	forwardVec = anglesToForward( orientation );
	if ( !front )
	{
		forwardVec = -forwardVec;
	}
	forwardVec2D = ( forwardVec[0], forwardVec[1], 0 );
	unitForwardVec2D = VectorNormalize( forwardVec2D );

	toFaceeVec = -vDir;
	toFaceeVec2D = ( toFaceeVec[0], toFaceeVec[1], 0 );
	unitToFaceeVec2D = VectorNormalize( toFaceeVec2D );
	
	dotProduct = VectorDot( unitForwardVec2D, unitToFaceeVec2D );
	return ( dotProduct > limit ); // more or less in front
}

function private inSmashAttackRange( enemy )
{
	smashPos = self.origin;
	distSq = DistanceSquared( smashPos, enemy.origin );
	range = 160 * 160;

	if ( distSq < range )
	{
		return true;
	}

	return false;
}