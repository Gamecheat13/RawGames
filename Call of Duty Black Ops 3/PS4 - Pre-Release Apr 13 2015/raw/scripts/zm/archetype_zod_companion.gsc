#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;


#using scripts\shared\ai\archetype_cover_utility;
#using scripts\shared\ai\archetype_locomotion_utility;
#using scripts\shared\ai\archetype_mocomps_utility;
#using scripts\shared\ai\archetype_utility;

#using scripts\shared\ai\systems\ai_blackboard;
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\ai_squads;
#using scripts\shared\ai\systems\animation_state_machine_mocomp;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\systems\shared;
#using scripts\zm\archetype_zod_companion_interface;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_perks;
#using scripts\shared\ai\zombie_death;

                                                                                                            	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                              	   	                             	  	                                      
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
                                                                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   	                                                                                                                                                                                                                                                                                                                                                  	   	   	                                                                                                                                                                                             	          
                                                                                       	                                


function autoexec main()
{
	clientfield::register( "allplayers", "being_robot_revived",    1, 1, "int" );
	
	// INIT BLACKBOARD
	spawner::add_archetype_spawn_function( "zod_companion", &ZodCompanionBehavior::ArchetypezodCompanionBlackboardInit );
	
	// INIT ZOD_COMPANION ON SPAWN
	spawner::add_archetype_spawn_function( "zod_companion", &ZodCompanionServerUtils::zodCompanionSoldierSpawnSetup );
	
	zm_spawner::register_zombie_damage_callback( &ZodCompanionBehavior::companion_damage_adjustment );
	
	ZodCompanionInterface::RegisterzodCompanionInterfaceAttributes();
	ZodCompanionBehavior::RegisterBehaviorScriptFunctions();
	
}

#namespace ZodCompanionBehavior;

function RegisterBehaviorScriptFunctions()
{
	
	// ------- ZOD_COMPANION ACTION APIS ----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionTacticalWalkActionStart",&zodCompanionTacticalWalkActionStart);;
	
	// ------- ZOD_COMPANION CONDITIONS -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionAbleToShoot",&zodCompanionAbleToShootCondition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionShouldTacticalWalk",&zodCompanionShouldTacticalWalk);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionIsMarching",&zodCompanionIsMarching);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionMovement",&zodCompanionMovement);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionDelayMovement",&zodCompanionDelayMovement);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionWithinSprintRange",&zodCompanionWithinSprintRange);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionSetDesiredStanceToStand",&zodCompanionSetDesiredStanceToStand);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionFinishedSprintTransition",&zodCompanionFinishedSprintTransition);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionSprintTransitioning",&zodCompanionSprintTransitioning);;
	
	// ------- ZOD_COMPANION - JUKE BEHAVIOR -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionCanJuke",&zodCompanionCanJuke);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionCanPreemptiveJuke",&zodCompanionCanPreemptiveJuke);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionJukeInitialize",&zodCompanionJukeInitialize);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionPreemptiveJukeTerminate",&zodCompanionPreemptiveJukeTerminate);;
	
	// ------- ZOD_COMPANION SERVICES -----------//
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionTargetService",&zodCompanionTargetService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("zodCompanionTryReacquireService",&zodCompanionTryReacquireService);;
	BehaviorTreeNetworkUtility::RegisterBehaviorTreeScriptAPI("manage_companion_movement",&manage_companion_movement);;
	
}

function private mocompIgnorePainFaceEnemyInit( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity.blockingpain = true;
	entity OrientMode( "face enemy" );
	entity AnimMode( "pos deltas" );
}

function private mocompIgnorePainFaceEnemyTerminate( entity, mocompAnim, mocompAnimBlendOutTime, mocompAnimFlag, mocompDuration )
{
	entity.blockingpain = false;
}

function private ArchetypeZodCompanionBlackboardInit()
{
	entity = self;

	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( entity );
	
	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( entity );
	
	// USE UTILITY BLACKBOARD
	entity AiUtility::RegisterUtilityBlackboardAttributes();
	
	// CREATE ZOD_COMPANION BLACKBOARD
	Blackboard::RegisterBlackBoardAttribute(self,"_locomotion_speed","locomotion_speed_sprint",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_locomotion_speed");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_move_mode","normal",undefined);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_move_mode");#/    };
	Blackboard::RegisterBlackBoardAttribute(self,"_gibbed_limbs",undefined,&zodCompanionGetGibbedLimbs);   if( IsActor(self) )    {    /#self TrackBlackBoardAttribute("_gibbed_limbs");#/    };
	
	// ENABLE DEBUGGING IN ODYSSEY
	/#entity FinalizeTrackedBlackboardAttributes();#/;	
	
//	entity AsmSetAnimationRate( 1.4 );
}



function private zodCompanionGetGibbedLimbs()
{
	entity = self;

	rightArmGibbed = GibServerUtils::IsGibbed( entity, 8 );
	leftArmGibbed = GibServerUtils::IsGibbed( entity, 16 );
	
	if ( rightArmGibbed && leftArmGibbed )
	{
		return "both_arms";
	}
	else if ( rightArmGibbed )
	{
		return "right_arm";
	}
	else if ( leftArmGibbed )
	{
		return "left_arm";
	}
	
	return "none";
}

function private zodCompanionDelayMovement( entity )
{
	entity PathMode( "move delayed", false, RandomFloatRange( 1, 2 ) );
}

function private zodCompanionMovement( entity )
{
	if( Blackboard::GetBlackBoardAttribute( entity, "_stance" ) != "stand" )
	{
		Blackboard::SetBlackBoardAttribute( entity, "_desired_stance", "stand" );
	}
}

function zodCompanionCanJuke( entity )
{	
	if ( !( isdefined( entity.steppedOutOfCover ) && entity.steppedOutOfCover ) && AiUtility::canJuke( entity ) )
	{
		jukeEvents = Blackboard::GetBlackboardEvents( "robot_juke" );
		tooCloseJukeDistanceSqr = 240 * 240;
	
		foreach ( event in jukeEvents )
	{
			if ( event.data.entity != entity &&
				Distance2DSquared( entity.origin, event.data.origin ) <= tooCloseJukeDistanceSqr )
			{
				return false;
			}
		}
		
		return true;
	}
	
	return false;
}

function zodCompanionCanPreemptiveJuke( entity )
{
	if ( !IsDefined( entity.enemy ) || !IsPlayer( entity.enemy ) )
	{
		return false;
	}
	
	if ( Blackboard::GetBlackBoardAttribute( entity, "_stance" ) == "crouch" )
	{
		return false;
	}
	
	if ( !entity.shouldPreemptiveJuke )
	{
		return false;
	}
	
	if ( IsDefined( entity.nextPreemptiveJuke ) && entity.nextPreemptiveJuke > GetTime() )
	{
		return false;
	}
	
	if ( entity.enemy PlayerADS() < entity.nextPreemptiveJukeAds )
	{
		return false;
	}
	
	// Only juke if the zodCompanion is close enough to their enemy.
	if ( DistanceSquared( entity.origin, entity.enemy.origin ) < ( 600 * 600 ) )
	{
		angleDifference = AbsAngleClamp180( entity.angles[1] - entity.enemy.angles[1] );
	
		/#
		record3DText( angleDifference, entity.origin + (0, 0, 5), ( 0, 1, 0 ), "Animscript" );
		#/
	
		// Make sure the zodCompanion could actually see their enemy.
		if ( angleDifference > 135 )
		{
			enemyAngles = entity.enemy GetGunAngles();
			toEnemy = entity.enemy.origin - entity.origin;
			forward = AnglesToForward( enemyAngles );
			dotProduct = Abs( VectorDot( VectorNormalize( toEnemy ), forward ) );
			
			/#
			record3DText( ACos( dotProduct ), entity.origin + (0, 0, 10), ( 0, 1, 0 ), "Animscript" );
			#/
			
			// Make sure the player is aiming close to the zodCompanion.
			if ( dotProduct > 0.9848 )
			{
				// Less than cos(10 degrees) between forard vector and vector to enemy.
				return zodCompanionCanJuke( entity );
			}
		}
	}
	
	return false;
}



function private zodCompanionIsMarching( entity )
{
	return Blackboard::GetBlackBoardAttribute( entity, "_move_mode" ) == "marching";
}

function private zodCompanionLocomotionSpeed()
{
	entity = self;
	
	if ( ai::GetAiAttribute( entity, "sprint" ) )
	{
		return "locomotion_speed_sprint";
	}
	
	return "locomotion_speed_walk";
}


function private _IsValidPlayer( player )
{
	if( !IsDefined( player ) ||
		!IsAlive( player ) ||
		!IsPlayer( player ) ||
		player.sessionstate == "spectator" ||
		player.sessionstate == "intermission" ||
		player laststand::player_is_in_laststand() ||
		player.ignoreme ) 
	{
		return false;
	}
	
	return true;
}


function private _FindClosest( entity, entities )
{
	closest = SpawnStruct();

	if ( entities.size > 0 )
	{
		closest.entity = entities[0];
		closest.distanceSquared = DistanceSquared( entity.origin, closest.entity.origin );
		
		for ( index = 1; index < entities.size; index++ )
		{
			distanceSquared = DistanceSquared( entity.origin, entities[index].origin );
			
			if ( distanceSquared < closest.distanceSquared )
			{
				closest.distanceSquared = distanceSquared;
				closest.entity = entities[index];
			}
		}
	}
	
	return closest;
}

function private zodCompanionTargetService( entity )
{
	if ( zodCompanionAbleToShootCondition( entity ) )
	{
		return false;
	}
	
	if ( ( isdefined( entity.ignoreall ) && entity.ignoreall ) )
	{
		return false;
	}
	
	aiEnemies = [];
	playerEnemies = [];
	ai = GetAiArray();
	players = GetPlayers();
	
	positionOnNavMesh = GetClosestPointOnNavMesh( entity.origin, 200 );
	
	if ( !IsDefined( positionOnNavMesh ) )
	{
		return;
	}
	
	
	// Add AI's that are on different teams.
	foreach( index, value in ai )
	{
		// Throw out other AI's that are outside the entity's goalheight.
		// This prevents considering enemies on other floors.
		if ( value.team != entity.team && IsActor( value ) && !IsDefined( entity.favoriteenemy ) )
		{
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh( value.origin, 200 );
		
			if ( IsDefined( enemyPositionOnNavMesh ) &&
				entity FindPath( positionOnNavMesh, enemyPositionOnNavMesh, true, false ) )
		{
				aiEnemies[aiEnemies.size] = value;
			}
		}
	}
	
	// Add valid players
	foreach( index, value in players )
	{
		if ( _IsValidPlayer( value ) )
		{
			enemyPositionOnNavMesh = GetClosestPointOnNavMesh( value.origin, 200 );
		
			if ( IsDefined( enemyPositionOnNavMesh ) &&
				entity FindPath( positionOnNavMesh, enemyPositionOnNavMesh, true, false ) )
			{
				playerEnemies[playerEnemies.size] = value;
			}
		}
	}
	
	closestPlayer = _FindClosest( entity, playerEnemies );
	closestAI = _FindClosest( entity, aiEnemies );
	
	if ( !IsDefined( closestPlayer.entity ) && !IsDefined( closestAI.entity ) )
	{
		// No player or actor to choose, bail out.
		return;
	}
	else if ( !IsDefined( closestAI.entity ) )
		{
		// Only has a player to choose.
		entity.favoriteenemy = closestPlayer.entity;
	}
	else if ( !IsDefined( closestPlayer.entity ) )
			{
		// Only has an AI to choose.
		entity.favoriteenemy = closestAI.entity;
			}
	else if ( closestAI.distanceSquared < closestPlayer.distanceSquared )
	{
		// AI is closer than a player, time for additional checks.
		entity.favoriteenemy = closestAI.entity;
		}
	else
	{
		// Player is closer, choose them.
		entity.favoriteenemy = closestPlayer.entity;
	}
}


function private zodCompanionTacticalWalkActionStart( entity )
{	
//	AiUtility::resetCoverParameters( entity );
//	AiUtility::setCanBeFlanked( entity, false );
//	
//	Blackboard::SetBlackBoardAttribute( entity, LOCOMOTION_SPEED_TYPE, LOCOMOTION_SPEED_WALK );
//	Blackboard::SetBlackBoardAttribute( entity, STANCE, DEFAULT_MOVEMENT_STANCE );		
	entity OrientMode( "face enemy" );	
}


function private zodCompanionWithinSprintRange( entity )
{
	if( !IsDefined( entity.enemy ) || !IsDefined( entity.runAndGunDist ) )
	{
		return false;
	}
	
	if ( DistanceSquared( entity.origin, entity.goalPos ) < (240 * 240) )
	{
		return false;
	}
	
	if ( DistanceSquared( entity.origin, entity LastKnownPos( entity.enemy ) ) <=
		( entity.runAndGunDist * entity.runAndGunDist ) )
	{
		return false;
	}
	
	return true;
}


function private zodCompanionAbleToShootCondition( entity )
{
	// TODO(David Young 7-30-14): Temporary work around since comparing weapon directly doesn't return correct results.
	// return entity.weapon != level.weaponNone &&
	return entity.weapon.name != level.weaponNone.name &&
		!GibServerUtils::IsGibbed( entity, 8 );
}

function private zodCompanionShouldTacticalWalk( entity )
{
	if ( !entity HasPath() )
	{
		return false;
	}

	return !zodCompanionIsMarching( entity );
}


function private zodCompanionJukeInitialize( entity )
{
	AiUtility::chooseJukeDirection( entity );
	entity ClearPath();
	
	jukeInfo = SpawnStruct();
	jukeInfo.origin = entity.origin;
	jukeInfo.entity = entity;

	Blackboard::AddBlackboardEvent( "robot_juke", jukeInfo, 2000 );
}

function private zodCompanionPreemptiveJukeTerminate( entity )
{
	entity.nextPreemptiveJuke = GetTime() + RandomIntRange( 4000, 6000 );
	entity.nextPreemptiveJukeAds = RandomFloatRange( 0.5, 0.95 );
}

function private zodCompanionTryReacquireService( entity )
{
	if ( !IsDefined( entity.reacquire_state ) )
	{
		entity.reacquire_state = 0;
	}

	if ( !IsDefined( entity.enemy ) )
	{
		entity.reacquire_state = 0;
		return false;
	}

	if ( entity HasPath() )
	{
		return false;
	}
	
	if ( !zodCompanionAbleToShootCondition( entity ) )
	{
		return false;
	}

	if ( entity CanSee( entity.enemy ) && entity CanShootEnemy() )
	{
		entity.reacquire_state = 0;
		return false;
	}

	// don't do reacquire unless facing enemy 
	dirToEnemy = VectorNormalize( entity.enemy.origin - entity.origin );
	forward = AnglesToForward( entity.angles );

	if ( VectorDot( dirToEnemy, forward ) < 0.5 )	
	{
		entity.reacquire_state = 0;
		return false;
	}

	switch ( entity.reacquire_state )
	{
	case 0:
	case 1:
	case 2:
		step_size = 32 + entity.reacquire_state * 32;
		reacquirePos = entity ReacquireStep( step_size );
		break;

	case 4:
		if ( !( entity CanSee( entity.enemy ) ) || !( entity CanShootEnemy() ) )
		{
			entity FlagEnemyUnattackable();
		}
		break;

	default:
		if ( entity.reacquire_state > 15 )
		{
			entity.reacquire_state = 0;
			return false;
		}
		break;
	}

	if ( IsVec( reacquirePos ) )
	{
		entity UsePosition( reacquirePos );
		return true;
	}

	entity.reacquire_state++;
	return false;
}


function private manage_companion_movement( entity )
{
	self endon( "death" );
	
	if( entity.reviving_a_player === true )
	{
		return;
	}
	
	if( entity.time_expired === true )
	{
		return;
	}
	
	foreach( player in level.players )
	{
		if( player laststand::player_is_in_laststand() && entity.reviving_a_player === false && player.revivetrigger.beingRevived !== 1 )
		{
			dist = PathDistance( entity.origin , player.origin );
			if( isDefined( dist) && dist <= 1024 )
			{
				entity.reviving_a_player = true;
				entity zod_companion_revive_player( player );
				return;
			}
		}
	}
	
	follow_radius_squared = ( (256) * (256) );

	if( isDefined( entity.leader) )
	{
		entity.companion_anchor_point = entity.leader.origin;
	}
	
	if( isDefined( entity.pathGoalPos) )
	{
		dist_check_start_point = entity.pathGoalPos;
	}
	else
	{
		dist_check_start_point = entity.origin;
	}
	
	//pick a new point if goal is too far from anchor point
	if( distanceSquared( dist_check_start_point , entity.companion_anchor_point) > follow_radius_squared )
	{
		entity pick_new_movement_point();
	}
		
	//move if you haven't moved in a bit
	if( GetTime() >= entity.next_move_time )
	{
		entity pick_new_movement_point();
	}

}


function private pick_new_movement_point()
{
	queryResult = PositionQuery_Source_Navigation( self.companion_anchor_point, 64, 256, 256, 20, self );
	
	if( queryResult.data.size )
	{
		point = queryResult.data[ randomint( queryResult.data.size ) ];
		pathSuccess = self FindPath( self.origin, point.origin, true, false );
		
		if ( pathSuccess )
		{
			self.companion_destination = point.origin;
		}
		else
		{
			self.next_move_time = GetTime() + RandomIntRange(500, 1500);
			return;
		}
	}
	
	self SetGoal( self.companion_destination, true );
	
	self.next_move_time = GetTime() + RandomIntRange(20000, 30000);
}

function companion_damage_adjustment( mod, hit_location, hit_origin, player, amount, weapon )
{
	
	//self is the zombie getting attacked
	//player is the robot companion
	
	if( !isDefined (player.enemy))
		return false;


	gib_chance = randomint( 100 );	
	if( gib_chance < 50 )
	{
		self.a.gib_ref = array::random( array( "right_arm", "left_arm", "head" ) );
		self thread zombie_death::do_gib();
	}
	
	damage_threshold = 840;
	
	if( amount < damage_threshold )
	{
		self doDamage( damage_threshold - amount, player.origin );
		return true;
	}
	
	return false;
}


function private zodCompanionSetDesiredStanceToStand( behaviorTreeEntity )
{
	currentStance = Blackboard::GetBlackBoardAttribute( behaviorTreeEntity, "_stance" );
	
	if( currentStance == "crouch" )
	{
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_desired_stance", "stand" );
	}	
}


function zod_companion_revive_player( player )
{
	//self is the robot companion
	
	self endon( "revive_terminated" );
	
	if( !( isdefined( self.reviving_a_player ) && self.reviving_a_player ) )
	{
		self.reviving_a_player = true;
	}
	
	player.being_revived_by_robot = 0; //will get set once the robot starts the actual revive, initializing variable here
	
	self thread zod_companion_monitor_revive_attempt( player );
	
	self.ignoreall = true;
	
	//TODO play VO that player is downed
	Blackboard::SetBlackBoardAttribute( self, "_locomotion_speed", "locomotion_speed_sprint" );
	
	queryResult = PositionQuery_Source_Navigation( player.origin, 64, 96, 48, 18, self );
	
	if( queryResult.data.size )
	{
		point = queryResult.data[ randomint( queryResult.data.size ) ];
		self.companion_destination = point.origin;
	}
	
	self SetGoal( self.companion_destination, true );
	
	self waittill( "goal" );
	
	Blackboard::SetBlackBoardAttribute( self, "_locomotion_speed", "locomotion_speed_walk" );
	player.revivetrigger.beingRevived = 1; //disables revive for other players in _zm_laststand.gsc
	player.being_revived_by_robot = 1;
	
	vector = VectorNormalize( player.origin - self.origin);
	angles = VectorToAngles( vector );
	
	self teleport( self.origin, angles );
	self thread animation::play( "ai_robot_base_stn_exposed_revive", self, angles, 1.5 );
	
	wait 0.67;
	                            
	player clientfield::set( "being_robot_revived", 1 );
	
	self waittill( "robot_revive_complete" );
	player notify( "remote_revive", self );
	
	players = GetPlayers();
	if( players.size == 1 && level flag::get( "solo_game" ) && ( isdefined( player.waiting_to_revive ) && player.waiting_to_revive ) )
	{
		player thread zm_perks::give_perk( "specialty_quickrevive", false );
	}
		
	self zod_companion_revive_cleanup( player );
	
}

function zod_companion_monitor_revive_attempt( player )
{
	//self is the robot companion
	
	self endon( "revive_terminated" );
	
	While( 1 )
	{
		if( player.revivetrigger.beingRevived === 1 && player.being_revived_by_robot !== 1 ) //checks propery in last stand set when a player starts reviving, but excludes the case where the robot is reviving
		{
			self zod_companion_revive_cleanup( player );
		}
		
		if( !( isdefined( player laststand::player_is_in_laststand() ) && player laststand::player_is_in_laststand() ) )
		{
			self zod_companion_revive_cleanup( player );
		}
		
		wait 0.05;
	}
	
}

function zod_companion_revive_cleanup( player )
{
	//self is the robot companion
	self.ignoreall = false;
	self.reviving_a_player = false;
	if( player.being_revived_by_robot == 1 )
	{
		player.revivetrigger.beingRevived = 0; //frees up player to be revived by other players
		player.being_revived_by_robot = 0;
	}
	player clientfield::set( "being_robot_revived", 0 );
	self notify( "revive_terminated" );
}

function private zodCompanionFinishedSprintTransition( behaviorTreeEntity )
{
	behaviorTreeEntity.sprint_transition_happening = false;
	
	if( !behaviorTreeEntity ai::get_behavior_attribute( "sprint" )  )
	{
		behaviorTreeEntity ai::set_behavior_attribute( "sprint", true );
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_locomotion_speed", "locomotion_speed_sprint" );
	}
	else
	{
		behaviorTreeEntity ai::set_behavior_attribute( "sprint", false );
		Blackboard::SetBlackBoardAttribute( behaviorTreeEntity, "_locomotion_speed", "locomotion_speed_walk" );
	}
	
	behaviorTreeEntity thread zodcompanionutility::sprint_if_too_far_from_goal();
}

function private zodCompanionSprintTransitioning( behaviorTreeEntity)
{
	if( behaviorTreeEntity.sprint_transition_happening === true )
	{
		return true;
	}
	
	return false;
}

// end #namespace ZodCompanionBehavior;

#namespace ZodCompanionServerUtils;

function private _tryGibbingHead( entity, damage, hitLoc, isExplosive )
{
	if ( isExplosive &&
		RandomFloatRange( 0, 1 ) <= 0.5 )
	{
		GibServerUtils::GibHead( entity );
	}
	else if ( IsInArray( array( "head", "neck", "helmet" ), hitLoc ) &&
		RandomFloatRange( 0, 1 ) <= 1 )
	{
		GibServerUtils::GibHead( entity );
	}
	else if ( ( entity.health - damage ) <= 0 &&
		RandomFloatRange( 0, 1 ) <= 0.25 )
	{
		GibServerUtils::GibHead( entity );
	}
}

function private _tryGibbingLimb( entity, damage, hitLoc, isExplosive )
{
	// Early out if one arm is already gibbed.
	if ( GibServerUtils::IsGibbed( entity, 16 ) ||
		GibServerUtils::IsGibbed( entity, 8) )
	{
		return;
	}

	if ( isExplosive &&
		RandomFloatRange( 0, 1 ) <= 0.25 )
	{
		if ( ( entity.health - damage ) <= 0 && entity.allowdeath && math::cointoss() )
		{
			// Only gib the right arm if the zodCompanion died.
			GibServerUtils::GibRightArm( entity );
		}
		else
		{
			GibServerUtils::GibLeftArm( entity );
		}
	}
	else if ( IsInArray( array( "left_hand", "left_arm_lower", "left_arm_upper" ), hitLoc ) )
	{
		GibServerUtils::GibLeftArm( entity );
	}
	else if ( ( entity.health - damage ) <= 0 &&
		entity.allowdeath &&
		IsInArray( array( "right_hand", "right_arm_lower", "right_arm_upper" ), hitLoc ) )
	{
		GibServerUtils::GibRightArm( entity );
	}
	else if ( ( entity.health - damage ) <= 0 &&
		entity.allowdeath &&
		RandomFloatRange( 0, 1 ) <= 0.25 )
	{
		if ( math::cointoss() )
		{
			GibServerUtils::GibLeftArm( entity );
		}
		else
		{
			GibServerUtils::GibRightArm( entity );
		}
	}
}

function private _tryGibbingLegs( entity, damage, hitLoc, isExplosive, attacker )
{
	if ( !IsDefined( attacker ) )
	{
		attacker = entity;
	}

	// Gib on death.
	canGibLegs = ( entity.health - damage ) <= 0 && entity.allowdeath;
	
	// Gib based on damage.
	canGibLegs = canGibLegs ||
		( ( ( entity.health - damage ) / entity.maxHealth ) <= 0.25 &&
		DistanceSquared( entity.origin, attacker.origin ) <= (600 * 600) &&
		entity.allowdeath );
	
	if ( ( entity.health - damage ) <= 0 &&
		entity.allowdeath &&
		isExplosive &&
		RandomFloatRange( 0, 1 ) <= 0.5 )
	{
		GibServerUtils::GibLegs( entity );
		entity StartRagdoll();
	}
	else if ( canGibLegs &&
		IsInArray( array( "left_leg_upper", "left_leg_lower", "left_foot" ), hitLoc ) &&
		RandomFloatRange( 0, 1 ) <= 1 )
	{
		if ( ( entity.health - damage ) > 0 )
		{
			entity.becomeCrawler = true;
		}
		
		GibServerUtils::GibLeftLeg( entity );
	}
	else if ( canGibLegs &&
		IsInArray( array( "right_leg_upper", "right_leg_lower", "right_foot" ), hitLoc ) &&
		RandomFloatRange( 0, 1 ) <= 1 )
	{
		if ( ( entity.health - damage ) > 0 )
		{
			entity.becomeCrawler = true;
		}
		
		GibServerUtils::GibRightLeg( entity );
	}
	else if ( ( entity.health - damage ) <= 0 &&
		entity.allowdeath &&
		RandomFloatRange( 0, 1 ) <= 0.25 )
	{
		// Randomly gib a leg when dead.
		if ( math::cointoss() )
		{
			GibServerUtils::GibLeftLeg( entity );
		}
		else
		{
			GibServerUtils::GibRightLeg( entity );
		}
	}
}

function private zodCompanionGibDamageOverride(
	inflictor, attacker, damage, flags, meansOfDeath, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex )
{
	entity = self;
	
	// Check if any gibbing is allowed.
	if ( ( ( entity.health - damage ) / entity.maxHealth ) > 0.75 )
	{
		return damage;
	}
	
	// Enable spawning gib pieces.
	GibServerUtils::ToggleSpawnGibs( entity, true );

	isExplosive = IsInArray(
		array(
			"MOD_GRENADE",
			"MOD_GRENADE_SPLASH",
			"MOD_PROJECTILE",
			"MOD_PROJECTIVLE_SPLASH",
			"MOD_EXPLOSIVE" ),
		meansOfDeath );
	
	_tryGibbingHead( entity, damage, hitLoc, isExplosive );
	_tryGibbingLimb( entity, damage, hitLoc, isExplosive );
	_tryGibbingLegs( entity, damage, hitLoc, isExplosive, attacker );

	return damage;
}

function private zodCompanionDestructDeathOverride(
	inflictor, attacker, damage, flags, meansOfDeath, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex )
{
	entity = self;
	
	if ( ( entity.health - damage ) <= 0 )
	{
		DestructServerUtils::ToggleSpawnGibs( entity, true );
		
		pieceCount = DestructServerUtils::GetPieceCount( entity );
		possiblePieces = [];
		
		// Find all pieces that haven't been destroyed yet.
		for ( index = 1; index <= pieceCount; index++ )
		{
			if ( !DestructServerUtils::IsDestructed( entity, index ) &&
				RandomFloatRange( 0, 1 ) <= 0.2 )
			{
				possiblePieces[ possiblePieces.size ] = index;
			}
		}
		
		gibbedPieces = 0;
		
		// Destroy up to the maximum number of pieces.
		for ( index = 0; index < possiblePieces.size && possiblePieces.size > 1 && gibbedPieces < 2; index++ )
		{
			randomPiece = RandomIntRange( 0, possiblePieces.size - 1 );
			
			if ( !DestructServerUtils::IsDestructed( entity, possiblePieces[ randomPiece ] ) )
			{
				DestructServerUtils::DestructPiece( entity, possiblePieces[ randomPiece ] );
				gibbedPieces++;
			}
		}
	}
	
	return damage;
}

function private zodCompanionDamageOverride( inflictor, attacker, damage, flags, meansOfDeath, weapon, point, dir, hitLoc, offsetTime, boneIndex, modelIndex )
{
	entity = self;
	
	// Reduce headshot damage to zodCompanions in script, since this is hardcoded elsewhere for AI's.
	if ( hitLoc == "helmet" || hitLoc == "head" || hitLoc == "neck" )
	{
		damage = int( damage * 0.5 );
	}
	
	return damage;
}

function private findClosestNavMeshPositionToEnemy( enemy )
{
	enemyPositionOnNavMesh = undefined;

	for ( toleranceLevel = 1; toleranceLevel <= 4; toleranceLevel++ )
	{
		enemyPositionOnNavMesh = GetClosestPointOnNavMesh(
			enemy.origin,
			200 * toleranceLevel );
			
		if ( IsDefined( enemyPositionOnNavMesh ) )
		{
			break;
		}
	}
	
	return enemyPositionOnNavMesh;
}


function private zodCompanionSoldierSpawnSetup()
{
	entity = self;
	entity.combatmode = "cover";
	entity.fullHealth = entity.health;
	entity.controlLevel = 0;
	entity.steppedOutOfCover = false;
	entity.startingWeapon = entity.weapon;
	entity.jukeDistance = 90;
	entity.jukeMaxDistance = 600;
	entity.entityRadius = 30 / 2;
	entity.base_accuracy = entity.accuracy;
	entity.highlyAwareRadius = 128;
	
	entity.treatAllCoversAsGeneric = true;
	entity.onlyCrouchArrivals = true;
	
	entity.nextPreemptiveJukeAds = RandomFloatRange( 0.5, 0.95 );
	entity.shouldPreemptiveJuke = math::cointoss();
	entity.reviving_a_player = false;
	
	AiUtility::AddAIOverrideDamageCallback( entity, &DestructServerUtils::HandleDamage );
	AiUtility::AddAIOverrideDamageCallback( entity, &zodCompanionDamageOverride );
	AiUtility::AddAiOverrideDamageCallback( entity, &zodCompanionGibDamageOverride );
			
	entity.companion_anchor_point = entity.origin;
	
	entity.next_move_time = GetTime();
	
	entity.allow_zombie_to_target_ai = true;
	
	entity.ignoreme = true;
	
	entity thread ZodCompanionUtility::manage_companion();

}
	
// end #namespace ZodCompanionServerUtils;


#namespace ZodCompanionUtility;

function manage_companion()
{
	self endon( "death" );
	self thread sprint_if_too_far_from_goal();
	
	//check against conditions where we want to assign a new leader and do so	
	While (1)
	{	
		if( !self.reviving_a_player )
		{
			if( !isDefined( self.leader ) || !self.leader.eligible_leader )
			{
				self define_new_leader();
			}
		}
		
		wait 0.5;
	}

}


function define_new_leader()
{
	a_potential_leaders = get_potential_leaders( self );
	closest_leader = undefined;
	closest_distance = 1000000;
	
	if( a_potential_leaders.size == 0 )
	{
		self.leader = undefined;
	}
	else
	{
		// 	get nearest eligible player and assign him as the companion's leader
		foreach( potential_leader in a_potential_leaders )
		{
			dist = PathDistance( self.origin , potential_leader.origin );
			
			if( isDefined( dist) && dist < closest_distance )
			{
				closest_distance = dist;
				self.leader = potential_leader;
			}
		}
	}
}


function get_potential_leaders( companion )
{
	a_potential_leaders = [];
	
	foreach( player in level.players )
	{
		if( !isDefined( player.eligible_leader ) )
		{
			player.eligible_leader = true;
		}
		
		if( ( isdefined( player.eligible_leader ) && player.eligible_leader ) &&  companion FindPath( companion.origin , player.origin ) )
		{
			a_potential_leaders[a_potential_leaders.size] = player;
		}
	}
	
	return a_potential_leaders;
}


function sprint_if_too_far_from_goal()
{
	self endon( "death" );
	self endon( "sprint_transition_happening" );
	
	While( 1 )
	{
		if( distanceSquared( self.origin, self.companion_anchor_point ) > ( (1.5 * 256) * (1.5 * 256) ) && !self ai::get_behavior_attribute( "sprint" )  )
		{
			self.sprint_transition_happening = true;
			self notify( "sprint_transition_happening" );
		}

		if( distanceSquared( self.origin, self.companion_anchor_point ) < ( (256) * (256) ) && self ai::get_behavior_attribute( "sprint" ) )
		{
			self.sprint_transition_happening = true;
			self notify( "sprint_transition_happening" );
		}
		
		wait 0.05;
	}
	
}