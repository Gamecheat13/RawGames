#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\util_shared;

// COMMON AI SYSTEMS INCLUDES
#using scripts\shared\ai\systems\ai_interface;
#using scripts\shared\ai\systems\animation_state_machine_utility;
#using scripts\shared\ai\systems\behavior_tree_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\systems\destructible_character;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\ai\archetype_cover_utility;
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

                                                                                                             	     	                                                                                                                                                                
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                              	         	    	                                                                                                   
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
        	                                                                                                                                                	                                                                                                                      	                                                                                     	                                                                                     	                                                               	                                                   	                                                                           	                                                                                 	                                       	                             	                                             	                                  	                                                                                 	                                                                                                                                                	      
                                                                                                                                               	
                                                                                                                                                                                                       	     	                                                                                   

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "fx", "weapon/fx_hero_annhilatr_death_blood" );

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
	
	AiUtility::AddAIOverrideDamageCallback( entity, &DamageOverride );
	AiUtility::AddAIOverrideKilledCallback( entity, &humanGibKilledOverride );
	
	locomotionTypes = array( "alt1", "alt2", "alt3", "alt4" );
	altIndex = entity GetEntityNumber() % locomotionTypes.size;
	
	Blackboard::SetBlackBoardAttribute( entity, "_human_locomotion_variation", locomotionTypes[ altIndex ] );
	
	if ( ( isdefined( entity.hero ) && entity.hero ) )
	{
		Blackboard::SetBlackBoardAttribute( entity, "_human_locomotion_variation", "alt1" );
	}
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
	self.___ArchetypeOnBehaveCallback = &ArchetypeHumanOnBehaveCallback;
			
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
	
	DestructServerUtils::ToggleSpawnGibs( self, true );
	GibServerUtils::ToggleSpawnGibs( self, true );
}

function private ArchetypeHumanOnBehaveCallback( entity )
{
	// Animscripted left the AI at cover.
	if ( AiUtility::isAtCoverCondition( entity ) )
	{
		Blackboard::SetBlackBoardAttribute( entity, "_previous_cover_mode", "cover_alert" );
		Blackboard::SetBlackBoardAttribute( entity, "_cover_mode", "cover_mode_none" );
	}
}

function private ArchetypeHumanOnAnimscriptedCallback( entity ) // self/entity = AI
{
	// UNREGISTER THE BLACKBOARD
	entity.__blackboard = undefined;
	
	// REREGISTER BLACKBOARD
	entity ArchetypeHumanBlackboardInit();
	
	// Reapply the current vignette_mode
	vignetteMode = ai::GetAiAttribute( entity, "vignette_mode" );
	HumanSoldierServerUtils::VignetteModeCallback( entity, "vignette_mode", vignetteMode, vignetteMode );
}


function private humanGibKilledOverride(
	inflictor, attacker, damage, meansOfDeath, weapon, dir, hitLoc, offsetTime )
{
	entity = self;
	
	// Only allow human gibbing at a 50% rate.
	if ( math::cointoss() )
	{
		return damage;
	}
	
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
			
			isCloseExplosive = DistanceSquared( inflictor.origin, entity.origin ) <= ( (60) * (60) );
			
			if ( isDirectExplosive && isCloseExplosive )
			{
				GibServerUtils::Annihilate( entity );
			}
		}
	}
	
	if ( forceGibbing || isExplosive ||
		( IsDefined( level.__ai_forceGibs ) && level.__ai_forceGibs ) || 
		( weapon.doGibbing && ( attackerDistance <= ( (weapon.maxGibDistance) * (weapon.maxGibDistance) ) ) ) )
	{
		// Enable spawning gib pieces.
		GibServerUtils::ToggleSpawnGibs( entity, true );
		DestructServerUtils::ToggleSpawnGibs( entity, true );
		
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

function DamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex )
{
	entity = self;
	
	entity DestructServerUtils::HandleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex );
	
	if( isDefined( eAttacker) && !isPlayer( eAttacker ) && !isVehicle( eAttacker ) )
	{
		dist = DistanceSquared( entity.origin, eAttacker.origin );
		
		if( dist < 256*256 )
		{
			iDamage = Int( iDamage * 10 );
		}
		else
		{
			iDamage = Int( iDamage * 1.5 );
		}
	}
	
	if ( sWeapon.name == "incendiary_grenade" )
	{
		iDamage = entity.health;
	}
	
	return iDamage;
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

function moveModeAttributeCallback( entity, attribute, oldValue, value )
{
	entity.ignorepathenemyfightdist = false;

	switch ( value )
	{
		case "normal":
			break;
		case "rambo":
			entity.ignorepathenemyfightdist = true;
			break;
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

function VignetteModeCallback( entity, attribute, oldValue, value )
{
	switch ( value )
	{
		case "off":
			entity.pushable = true;
			entity PushActors( false );
			entity PushPlayer( false );
			entity SetAvoidanceMask( "avoid all" );
			entity SetSteeringMode( "normal steering" );
			break;
		case "slow":
			entity.pushable = false;
			entity PushActors( false );
			entity PushPlayer( true );
			entity SetAvoidanceMask( "avoid ai" );
			entity SetSteeringMode( "vignette steering" );
			break;
		case "fast":
			entity.pushable = false;
			entity PushActors( true );
			entity PushPlayer( true );
			entity SetAvoidanceMask( "avoid none" );
			entity SetSteeringMode( "vignette steering" );
			break;
		default:
			break;
	}
}

// end #namespace HumanSoldierServerUtils;