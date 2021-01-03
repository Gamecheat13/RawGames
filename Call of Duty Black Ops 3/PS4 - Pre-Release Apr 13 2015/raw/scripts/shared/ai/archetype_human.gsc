#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\gameskill_shared;

// COMMON AI SYSTEMS INCLUDES
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\archetype_mocomps_utility;

// BLACKBOARD
#using scripts\shared\ai\archetype_human_blackboard;

// NOTETRACKS
#using scripts\shared\ai\archetype_notetracks;

// BEHAVIORS
#using scripts\shared\ai\archetype_human_exposed;
#using scripts\shared\ai\archetype_human_cover;
#using scripts\shared\ai\archetype_human_locomotion;

// INTERFACE
#using scripts\shared\ai\archetype_human_interface;

#using scripts\shared\ai\archetype_utility;

                                                                                                             	   	
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
                                                                                                                                                                                                                                                                                                                                                                   

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

function autoexec init()
{
	// INIT BLACKBOARD
	spawner::add_archetype_spawn_function( "human", &ArchetypeHumanBlackboardInit );
	spawner::add_archetype_spawn_function( "human", &ArchetypeHumanInit );
	
	HumanInterface::RegisterHumanInterfaceAttributes();
	
	/#
	level.__ai_forceGibs = GetDvarInt( "ai_forceGibs" );
	#/
}

function private ArchetypeHumanInit()
{
	entity = self;
	
	AiUtility::AddAIOverrideDamageCallback( entity, &DestructServerUtils::HandleDamage );
	AiUtility::AddAIOverrideKilledCallback( entity, &humanGibKilledOverride );
}

function private ArchetypeHumanBlackboardInit() // self = AI
{
	// CREATE BLACKBOARD
	Blackboard::CreateBlackBoardForEntity( self );
	
	// CREATE INTERFACE
	ai::CreateInterfaceForEntity( self );
		
	// USE UTILITY BLACKBOARD
	self AiUtility::RegisterUtilityBlackboardAttributes();
		
	// CREATE HUMAN BLACKBOARD
	self Blackboard::RegisterActorBlackBoardAttributes();
	
	// REGISTER ANIMSCRIPTED CALLBACK
	self.___ArchetypeOnAnimscriptedCallback = &ArchetypeHumanOnAnimscriptedCallback;
			
	// ENABLE DEBUGGING IN ODYSSEY
	/#self FinalizeTrackedBlackboardAttributes();#/;
	
	// THREAD PRE BULLET FIRE CALLBACK
	self thread gameskill::accuracy_buildup_before_fire( self );
	
	// RUN SNIPER GLINT AND LASER IF ACCURATE FIRE IS ON
	if( self.accurateFire )
	{
		self thread AiUtility::preShootLaserAndGlintOn( self );
		self thread AiUtility::postShootLaserAndGlintOff( self );
	}
}

function private ArchetypeHumanOnAnimscriptedCallback( entity ) // self/entity = AI
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeHumanBlackboardInit();
}

function private humanGibKilledOverride(
	inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime )
{
	entity = self;
	
	attackerDistance = 0;
	
	if ( IsDefined( attacker ) )
	{
		attackerDistance = DistanceSquared( attacker.origin, entity.origin );
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
	}
	
	if ( forceGibbing || isExplosive ||
		( IsDefined( level.__ai_forceGibs ) && level.__ai_forceGibs ) || 
		( weapon.doGibbing && ( attackerDistance <= ( (weapon.maxGibDistance) * (weapon.maxGibDistance) ) ) ) )
	{
		// Enable spawning gib pieces.
		GibServerUtils::ToggleSpawnGibs( entity, true );
		
		// TODO(David Young 2-15-15): Currently humans don't support head gibbing.
		// TryGibbingHead( entity, damage, hitLoc, isExplosive );
		TryGibbingLimb( entity, damage, hitLoc, isExplosive || forceGibbing );
		TryGibbingLegs( entity, damage, hitLoc, isExplosive );
	}

	return damage;
}

function private TryGibbingHead( entity, damage, hitLoc, isExplosive )
{
	if ( isExplosive )
	{
		GibServerUtils::GibHead( entity );
	}
	else if ( IsInArray( array( "head", "neck", "helmet" ), hitLoc ) )
	{
		GibServerUtils::GibHead( entity );
	}
}

function private TryGibbingLimb( entity, damage, hitLoc, isExplosive )
{
	if ( isExplosive )
	{
		randomChance = RandomFloatRange( 0, 1 );
	
		if ( randomChance < 0.5 )
		{
			// 50% chance
			GibServerUtils::GibRightArm( entity );
		}
		else
		{
			// 50% chance
			GibServerUtils::GibLeftArm( entity );
		}
	}
	else if ( IsInArray( array( "left_hand", "left_arm_lower", "left_arm_upper" ), hitLoc ) )
	{
		GibServerUtils::GibLeftArm( entity );
	}
	else if ( IsInArray( array( "right_hand", "right_arm_lower", "right_arm_upper" ), hitLoc ) )
	{
		GibServerUtils::GibRightArm( entity );
	}
	else if ( IsInArray( array( "torso_upper" ), hitLoc ) && math::cointoss() )
	{
		// Award a random gib.
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

function private TryGibbingLegs( entity, damage, hitLoc, isExplosive, attacker )
{
	if ( isExplosive )
	{
		randomChance = RandomFloatRange( 0, 1 );
	
		if ( randomChance < 0.33 )
		{
			// 33% chance
			GibServerUtils::GibRightLeg( entity );
		}
		else if ( randomChance < 0.66 )
		{
			// 33% chance
			GibServerUtils::GibLeftLeg( entity );
		}
		else
		{
			// 34% chance
			GibServerUtils::GibLegs( entity );
		}
	}
	else if ( IsInArray( array( "left_leg_upper", "left_leg_lower", "left_foot" ), hitLoc ) )
	{
		GibServerUtils::GibLeftLeg( entity );
	}
	else if ( IsInArray( array( "right_leg_upper", "right_leg_lower", "right_foot" ), hitLoc ) )
	{
		GibServerUtils::GibRightLeg( entity );
	}
	else if ( IsInArray( array( "torso_lower" ), hitLoc ) && math::cointoss() )
	{
		// Award a random gib.
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

#namespace HumanSoldierServerUtils;

function cqbAttributeCallback( entity, attribute, oldValue, value )
{
	if ( value )
	{		
		entity AsmChangeAnimMappingTable( 2 );
	}
	else
	{	
		if( entity ai::get_behavior_attribute( "useAnimationOverride" ) )
			entity AsmChangeAnimMappingTable( 1 );
		else
			entity AsmChangeAnimMappingTable( 0 );
	}
}

function UseAnimationOverrideCallback( entity, attribute, oldValue, value )
{
	if ( value )
	{
		entity AsmChangeAnimMappingTable( 1 );
	}
	else
	{
		entity AsmChangeAnimMappingTable( 0 );
	}
}

// end #namespace HumanSoldierServerUtils;