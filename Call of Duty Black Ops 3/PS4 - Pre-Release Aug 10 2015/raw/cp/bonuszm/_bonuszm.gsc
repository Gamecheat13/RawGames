#using scripts\codescripts\struct;
#using scripts\shared\archetype_shared\archetype_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai_shared;
#using scripts\shared\ammo_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientids_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\containers_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\blackboard;
#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_globallogic_player;
#using scripts\cp\cybercom\_cybercom;
#using scripts\cp\cybercom\_cybercom_gadget;
#using scripts\cp\cybercom\_cybercom_tactical_rig;
#using scripts\cp\cybercom\_cybercom_util;
#using scripts\cp\_load;
#using scripts\cp\_oed;
#using scripts\cp\_util;

// ZOMBIE
#using scripts\cp\bonuszm\_bonuszm_zombie;

// BONUSZM
#using scripts\cp\bonuszm\_bonuszm_dev;
#using scripts\cp\bonuszm\_bonuszm_sound;
#using scripts\cp\bonuszm\_bonuszm_util;
#using scripts\cp\bonuszm\_bonuszm_data;
#using scripts\cp\bonuszm\_bonuszm_drops;
#using scripts\cp\bonuszm\_bonuszm_spawner_shared;
#using scripts\cp\bonuszm\_bonuszm_magicbox;
#using scripts\cp\bonuszm\_bonuszm_weapons;

// SGEN SPECIFIC
#using scripts\cp\bonuszm\_bonuszm_sgen;
#using scripts\cp\bonuszm\_bonuszm_biodomes1;
#using scripts\cp\bonuszm\_bonuszm_prologue;
#using scripts\cp\bonuszm\_bonuszm_newworld;
#using scripts\cp\bonuszm\_bonuszm_lotus;
#using scripts\cp\bonuszm\_bonuszm_ramses;
#using scripts\cp\bonuszm\_bonuszm_infection;
#using scripts\cp\bonuszm\_bonuszm_blackstation;
#using scripts\cp\bonuszm\_bonuszm_aquifer;
#using scripts\cp\bonuszm\_bonuszm_vengeance;
#using scripts\cp\bonuszm\_bonuszm_zurich;
	
           	
           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                  	    	                                                      	   	      	                                                                                        	             	                         	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                                                                	     	    	                                                                                                                                    	                      	              	  	           
                                                                                                           	                                     	                	                       	            	                                                                                                                                                                                                                              
                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                          	                                         	   	     	    	     	   		   	                                                                       	                                                                                    	        	                                                                          	    	         	           		       	                                                                                                                                                                    	   	                 	   	                                 	          	                          	              	                        	                        	                    	                      	                                                                        	
                                                                             	     	                       	     	                                                                                	     	  	     	             	        	  	               

#namespace bonuszm;

#precache( "weapon", "launcher_standard_bonuszm" );

function autoexec __init__sytem__() {     system::register("bonuszm",&__init__,&__main__,undefined);    }
	
function __init__()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
	
	/#
	bonuszm_dev::BZM_DevInit();
	#/
		
		
	// No choose a class menu at load
	level.disableClassSelection	= true;
		
	// Cybercom tweaks
	SetDvar( "scr_firefly_swarm_attack_radius", 96 );
		
	level.zombieAnhilationEnabled = true;
	
	// Havok Pathfinding Tweaks to get better pathfinding performance
	SetDvar("hkai_navMeshUseHierarchialPathFind", true);
	SetDvar("hkai_pathfindIterationLimit", 500);
	//SetDvar("hkai_repathUsingIncompleteRepathSegments", false);
		
	// NO T-Mode for bonuszm. This gets rid of some additional sight traces and features. Possible performance gain.
	SetDvar( "player_tmodeSightEnabled", 0 );
			
	// This is throttle the position evaluation for extra zombie to only once per frame
	level.BZMLastExtraZombieSpawnEvalTime = 0;
	
	// Zigzag spreading of zombies
	level.zombie_use_zigzag_path = true;
	
	// Disable battlechatter
	level thread BZM_DisableBattleChatter();
	
	// Clientfields
	BZM_InitClientFields();
	
	// Traversals
	BZM_SetupTraversals();
				
	// Misc
	level.zombie_team = "axis"; // Required in zombies shared scripts
			
	// Callbacks
	callback::on_spawned( &BZM_OnPlayerSpawned );
	callback::on_finalize_initialization(&BZM_OnFinalizeInit);
	callback::on_loadout( &BZMOnLoadout );
	callback::on_vehicle_damage(&OnVehicleDamageCallback);
	
	// Setup Skipto Callback
	level.bzm_skipto_objective_changed_callback = &BZM_OnSkiptoOrObjectiveChanged;
	
	// Setup Zombie Target callback
	level.BZMZombieSpecificTargets = [];
	level.zombieLevelSpecificTargetCallback = &BZM_ZombieSpecificTarget;
	
	// spawner used for extra spawning of zombies
	level.bzmZombieSpawner 			= GetEntArray( "zombie_spawner", "script_noteworthy" );
	level.bzmExtraSpawnedNum 		= 0;
	level.bzmExtraSpawnedDeadNum	= 0;	
	
	level.BZMUtil_WaitForAllZombiesToDie 		= &BZMUtil_WaitForAllZombiesToDie;
	level.BZMWaitForObjectiveCompletionCallback = &BZMUtil_WaitForObjectiveCompletion;
	level.BZMStartObjectiveCallback				= &BZMUtil_StartObjective;
	
	level flag::init( "bzmObjectiveEnabled" ); 		// Set when all start objective is called
	level flag::init( "bzmExtraZombieCleared", 1 ); // Set when all zombies are spawned and dead, only extra ones, start with cleared
		
	// start with null	
	level.BZM_CurrentObjective = "";
	
	level.zombieSuicideWeapon = GetWeapon( "launcher_standard_bonuszm" );
}	

function __main__()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;	
}

// ----------------------
// Traversals
// Disable all stairs traversals as there is no animation support for them for zombies
//-----------------------
function BZM_SetupTraversals()
{
	nodes = GetAllNodes();
		
	foreach( node in nodes )
	{
		if( IsDefined( node.animscript ) && ( node.type == "Begin" || node.type == "End" ) )
		{
			if( node.animscript == "stairs8x12" || node.animscript == "stairs8x8" || node.animscript == "stairs8x16" )
			{
				SetEnableNode( node, false );
			}
		}
	}
}

// ----------------------
// Battlechatter
//-----------------------
function private BZM_DisableBattleChatter()
{
	while(1)
	{
		battlechatter::bc_allow( false );
		wait 0.2;
	}
}

// ----------------------
// Clientfields
//-----------------------
function private BZM_InitClientFields()
{
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int" );
	clientfield::register("actor", "bonus_zombie_eye_color", 1, 3, "int" );
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int" );
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int" );
	clientfield::register("actor", "zombie_instakill_fx", 1, 2, "int" );
	clientfield::register("actor", "zombie_appear_vanish_fx", 1, 3, "int" );
		
	clientfield::register("scriptmover", "powerup_on_fx", 1, 2, "int" );	
	clientfield::register("scriptmover", "powerup_grabbed_fx", 1, 1, "int" );
		
	clientfield::register( "toplayer", "instakill_upgraded_fx", 1, 1, "int" );
	clientfield::register( "toplayer", "bonuszm_post_fx", 1, 2, "int" );
}

// ----------------------
// On player spawned
//-----------------------
function BZM_OnPlayerSpawned()
{
	self thread BZM_CyberComThink();
	
	self thread BZM_PostFx();
	
	self thread BZM_sndBehindVox();
}

// ----------------------
// on_finalize_initialization
//-----------------------
function BZM_OnFinalizeInit()
{
	
}

// ----------------------
// On level objective changed
//-----------------------
function BZM_OnSkiptoOrObjectiveChanged(nextObjective)
{
	level.BZM_CurrentObjective = nextObjective;
}

// ----------------------
// Zombie Spawning
//-----------------------
function BZM_SetupZombieCustomSpawnFunction()
{
	if( level.bonusZMSkiptoData["zombifyenabled"] )
	{
		level.run_custom_function_on_ai = &BZM_ZombieOnSpawn;
	}
	else
	{
		level.run_custom_function_on_ai = undefined;
	}
}

function BZM_ZombieOnSpawn( spawnerEntity, str_targetname, force_spawn ) //self = AI/Zombie
{		
	assert( level.bonusZMSkiptoData["zombifyenabled"] );
		
	if ( !IsActor(self) )
		return;
	
	if( ( self.team == "allies" || self.archetype != "zombie" ) && !( isdefined( self.BZMMiniBoss ) && self.BZMMiniBoss ) )
		return;
	
	// To handle custom and un-supported traversals
	self.manualTraverseMode = true;
	
	// No sight update
	self.updateSight = false;
	
	// No badplace awareness
	self.badplaceawareness = 0;
	
	// Disable repair paths
	self SetRepairPaths( false );
		
	// No firing, performance gain
	self.holdFire = true;
	
	// No aim assist
	//self DisableAimAssist();
	AiUtility::AddAIOverrideDamageCallback( self, &BZM_ZombieOnActorDamageCallback );	
		
	// Avoidance and collision against other actors
	self PushActors( true );
	self SetAvoidanceMask( "avoid all" );
	
	// Start state
	flag::init( "bzm_zombie_attack" );
	
	// Closest player override	
	self.closest_player_override = &BZM_ClosestPlayerOverride;
	
	// Setup death and damage
	self thread zombie_utility::zombie_gib_on_damage();
	self thread BZM_SpawnFailSafe();
	self thread zombie_death_event( self );	
		
	// Should this zombie be a suicidal?
	if( RandomInt( 100 ) < level.bonusZMSkiptoData["suicidalzombiechance"] )
	{
		self ai::set_behavior_attribute( "suicidal_behavior", true );		
		self clientfield::set("arch_actor_fire_fx", 1);
		self.forceAnhilateOnDeath = true;		
	}
	
	// Overrides
	self thread BZM_ForceFlagOverride();
	
	// Vocals
	self thread bonuszmsound::BZM_AIVoxThink();
	
	// Setup Zombie speed
	self thread BZM_SelectZombieSpeedAndHealth();	
	
	// Zombie Think
	self thread BZM_ZombieThink();
	
	// Extra Zombie Think
	self thread BZM_SpawnExtraZombieIfNeeded();
	
	// Track the animscripted changes
	self thread BZM_TrackAIAnimscripted();
}


function BZM_TrackAIAnimscripted()
{
	self endon("death");
	
	while(1)
	{
		if( self IsInScriptedstate() && IsDefined( self.bzmPreviousArchetype ) )
		{
			if( self.archetype == "zombie" && ( self.bzmPreviousArchetype != "human" && self.bzmPreviousArchetype != "zombie" ) )
			{
				util::wait_network_frame();
				self Ghost();
				self NotSolid();
				self.ignoreme = true;
				self.BZMHidden = true;
			}
		}
		else
		{
			if( ( isdefined( self.BZMHidden ) && self.BZMHidden ) )
			{
				self clientfield::set("zombie_appear_vanish_fx", 3);
				self Show();
				self Solid();
				self.ignoreme = false;
				self.BZMHidden = false;
			}
		}
		
		wait 0.05;
	}
}


function BZM_SelectZombieSpeedAndHealth()
{
	self endon("death");

	// Locomotion Speed when AI does not have enemy, defaults to walk
	self.zombie_move_speed = "walk";
	
	rand_num =  RandomInt( 100 );
	
	if( rand_num > level.bonusZMSkiptoData["levelonezombies"] + level.bonusZMSkiptoData["leveltwozombies"] )
	{	
		self.bonuszmlevel = 2;
		newHealth = level.bonusZMSkiptoData["levelthreehealth"];
	}
	else if( rand_num > level.bonusZMSkiptoData["levelonezombies"])
	{	
		self.bonuszmlevel = 1;
		newHealth = level.bonusZMSkiptoData["leveltwohealth"];
	}
	else
	{	self.bonuszmlevel = 0;
		newHealth = level.bonusZMSkiptoData["levelonehealth"];
	}
	
	if( !( isdefined( self.BZMDoNotOverrideHealth ) && self.BZMDoNotOverrideHealth ) )
	{
		// modify the newHealth based on the current difficulty setting
		newHealth = bonuszmutil::BZM_GetModifiedHealthForDifficulty( newHealth );
		
		self.health = newHealth;
	}	   

	// Eyes based on health
	self clientfield::set("bonus_zombie_eye_color", self.bonuszmlevel);
	self thread zombie_utility::delayed_zombie_eye_glow();		
	
	// Put everything that needs to happen after zombie starts attacking down here
	self flag::wait_till( "bzm_zombie_attack" );
		
	// Locomotion Speed
	rand_num =  RandomInt( 100 );
	
	if( rand_num > level.bonusZMSkiptoData["walkpercent"] + level.bonusZMSkiptoData["runpercent"] )
	{
		self.zombie_move_speed = "sprint";
	}
	else if( rand_num > level.bonusZMSkiptoData["walkpercent"] )
	{
		self.zombie_move_speed = "run"; 
	}
	else
	{
		self.zombie_move_speed = "walk";
	}
	
	if( self ai::get_behavior_attribute( "suicidal_behavior" ) )
	{
		self.zombie_move_speed = "sprint";
	}
	
	oldSpeed = self.zombie_move_speed;
	
	while(1)
	{
		if( IsDefined(self.favoriteenemy) && IsVehicle(self.favoriteenemy) )
		{
			self.zombie_move_speed = "sprint";						
		}
		else
		{
			self.zombie_move_speed = oldSpeed;			
		}
		
		wait 0.1;
	}
}

// ----------------------
// On Actor Damage Callback - Only for zombies
//-----------------------
function private BZM_ZombieOnActorDamageCallback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	assert( self.archetype == "zombie" );
	
	if( IsPlayer( eAttacker ) && ( isdefined( eAttacker.forceAnhilateOnDeath ) && eAttacker.forceAnhilateOnDeath ) )
	{
		if( ( isdefined( eAttacker.bzm_forceKeepAIAlive ) && eAttacker.bzm_forceKeepAIAlive ) )
		{
			self.health = self.health + iDamage + 1;			
			
			assert( IsDefined( eAttacker.bzm_instakillAIBucket ) );
			       
			if( !IsInArray( eAttacker.bzm_instakillAIBucket, self ) )
			{
				eAttacker.bzm_instakillAIBucket[eAttacker.bzm_instakillAIBucket.size] = self;
			}
		}
		else 
		{
			self clientfield::set("zombie_instakill_fx", 1);
			return (self.health + 1);
		}
	}
	
	return iDamage;
}

function private OnVehicleDamageCallback( params ) // self = zombiefied vehicle
{
	if( IsDefined(self.archetype) && self.archetype == "parasite" && IsPlayer( params.eAttacker ) )
	{
		self DoDamage( self.health + 100, params.eAttacker.origin );
	}
}

// ----------------------
// Extra Zombie
//-----------------------
function BZM_SpawnExtraZombieIfNeeded()
{	
	assert( level.bonusZMSkiptoData["zombifyenabled"] );
			
	myRegion = GetNavFaceRegion( self.origin, 64 );
	
	self waittill("death");

	if( !IsDefined( self ) )
	{
		return;
	}
	
	if( level flag::get( "bzmExtraZombieCleared" ) )
	{
		return;
	}
	
	if( bonuszmutil::BZM_GetModifiedMaxExtraZombies() <= 0 )
	{		
		return;
	}
	
	if( ( isdefined( self._bzmKilledByFailSafe ) && self._bzmKilledByFailSafe ) )
	{
	   	return;
  	}
				
	extraZombieOrigin = self.origin;
	extraZombieAngles = self.angles;
		
	// No more than 
	while( GetAITeamArray("axis").size >= 24 )
	{
		wait RandomIntRange( 2, 4 );
	}
	
	while( level.BZMLastExtraZombieSpawnEvalTime == GetTime() )
	{	
		wait 0.05;
	}
	
	level.BZMLastExtraZombieSpawnEvalTime = GetTime();
	
	possibleLocationsToSpawn = [];
						
	// Find random node that can be used to spawn
	goToNode = bonuszmutil::BZM_FindClosestNodeWithinRegion( extraZombieOrigin, myRegion, 100, RandomIntRange( 600, 1000 ) );
	
	if( IsDefined( goToNode ) )
	{
		array::add( possibleLocationsToSpawn, goToNode.origin );
	}	

	closestPlayer = ArrayGetClosest( extraZombieOrigin, level.players );
	playerForward = AnglesToForward( closestPlayer.angles );
	locationInFrontOfPlayer = closestPlayer.origin + VectorScale( playerForward, RandomIntRange( 1200, 1500 ) );
	
	locationInFrontOfPlayer = GetClosestPointOnNavMesh( locationInFrontOfPlayer, 300 );
	
	// Find a random Point in front of the closest player 
	if( IsDefined( locationInFrontOfPlayer ) )
	{
		queryResult = PositionQuery_Source_Navigation(
		locationInFrontOfPlayer,
		100,
		500,
		70,
		100,
		self );
	}
	
	// Try one more time, if we could not find anything that far
	if( !IsDefined( queryResult ) )
	{
		locationInFrontOfPlayer = closestPlayer.origin + VectorScale( playerForward, RandomIntRange( 900, 1100 ) );
			
		if( IsDefined( locationInFrontOfPlayer ) )
		{
			queryResult = PositionQuery_Source_Navigation(
			locationInFrontOfPlayer,
			300,
			100,
			70,
			100,
			self );
		}
	
	}		
	
	if( IsDefined( queryResult ) && queryResult.data.size > 0 )
	{
		foreach( data in queryResult.data )
		{
			array::add( possibleLocationsToSpawn, data.origin );
		}
	}
	
	if( !possibleLocationsToSpawn.size )
	{
		array::add( possibleLocationsToSpawn, extraZombieOrigin );
	}			
				
	level thread BZM_SpawnExtraZombie( level.bonusZMSkiptoData["extraspawngapmin"], possibleLocationsToSpawn, extraZombieOrigin );
}

function BZM_SpawnExtraZombie(delay, possibleLocationsToSpawn, extraZombieAngles)
{
	wait delay;
		
	if( level.bzmExtraSpawnedNum >= bonuszmutil::BZM_GetModifiedMaxExtraZombies() )
	{
		return;
	}
	
	zombies = GetAITeamArray( "axis" );
	if( zombies.size >= 24 )
	{			
		while( GetAITeamArray( "axis" ).size >= 24 )
		{
			wait 1;			
		}
	}
		
	extraZombie = level.bzmZombieSpawner[0] spawner::spawn( true );
	if( IsDefined( extraZombie ) )
	{
		extraZombie thread BZM_TrackExtraZombieDeath();
		
		level.bzmExtraSpawnedNum++;		

		extraZombie.BZMExtraZombie = true;
		extraZombie BZM_SpawnZombieRise( array::random(possibleLocationsToSpawn), extraZombieAngles );		
	}
}

function BZM_TrackExtraZombieDeath()
{
	self waittill("death");
	
	level.bzmExtraSpawnedDeadNum++;
	//assert( level.bzmExtraSpawnedDeadNum <= level.bonusZMSkiptoData[BZM_DATA_EXTRA_SPAWNS] );
	//assert( level.bzmExtraSpawnedDeadNum <= level.bzmExtraSpawnedNum );
	
	if( level.bzmExtraSpawnedDeadNum >= bonuszmutil::BZM_GetModifiedMaxExtraZombies() )
	{
		level flag::set( "bzmExtraZombieCleared" );
	}		
}

function BZM_SpawnZombieRise(origin, angles)
{	
	self endon("death");

	self.in_the_ground = true;
		
	self thread zombie_utility::hide_pop();	// hack to hide the pop when the zombie gets to the start position before the anim starts

	level thread zombie_utility::zombie_rise_death(self);

	self OrientMode( "face default" );
	self clientfield::set("zombie_riser_fx", 1);
		
	newAngles = ( 0, angles[1], 0 );
	newOrigin = BZMUtil_GetGroundPos( origin, 72, self );
	
	self Ghost();
	self ForceTeleport( newOrigin, newAngles );
	wait 0.05;
	self Show();
	
	self scene::play( "scene_zombie_rise", self );

	self.in_the_ground = false;	
}

// ----------------------
// Zombie Specific Targets
//-----------------------
function BZM_ZombieSpecificTarget()
{
	level.BZMZombieSpecificTargets = array::remove_undefined(level.BZMZombieSpecificTargets);
	level.BZMZombieSpecificTargets = array::remove_dead(level.BZMZombieSpecificTargets);
		
	// if this zombie already has a specific target and its still valid, then just use that
	if( IsDefined( self.bzmSpecificTarget ) && IsInArray( level.BZMZombieSpecificTargets, self.bzmSpecificTarget ) )
	{
	   return self.bzmSpecificTarget;
	}	
	
	possibleTargets = [];
	
	foreach( target in level.BZMZombieSpecificTargets )
	{
		if( !IsDefined( target.bzmAttackers ) )
		{
			target.bzmAttackers = [];
		}
		else
		{
			if( target.bzmAttackers.size < 4 && !IsInArray( possibleTargets, target ) )
			{
				array::add(possibleTargets, target);
			}
		}			
	}
	
	if( possibleTargets.size )
	{
		chosenTarget = ArrayGetClosest( self.origin, possibleTargets, 512 );
		
		if( IsDefined( chosenTarget ) )
		{
			array::add(chosenTarget.bzmAttackers, chosenTarget);			
			self.bzmSpecificTarget = chosenTarget;
			
			return chosenTarget;
		}
	}
	
	return undefined;
}

// ----------------------
// Closest player override
//-----------------------
function BZM_ClosestPlayerOverride( origin, players )
{
	PixBeginEvent( "BZM_ClosestPlayerOverride" );
	
	if( IsDefined( self.BZMNextTargetUpdateTime ) && GetTime() < self.BZMNextTargetUpdateTime )
	{
		if( IsDefined( self.bzmFavEnemy ) && self.bzmFavEnemy != self )
		{
			PixEndEvent();
			
			self.favoriteenemy	= self.bzmFavEnemy;
			self SetEntityTarget( self.bzmFavEnemy );	
			return self.bzmFavEnemy;
		}
	}
			
	goodTargets = [];
				
	validPlayers = [];
	
	foreach( player in players )
	{
		if( !( isdefined( player.ignoreme ) && player.ignoreme ) )
		{
			validPlayers[validPlayers.size] = player;			
		}
	}
	
	if( validPlayers.size )
	{
		
		closestPlayer = ArrayGetClosest( origin, validPlayers );
		goodTargets[goodTargets.size] = closestPlayer;
		
		target = closestPlayer; // start with closest player
		dist2player = DistanceSquared( origin, closestPlayer.origin );	
	}
		
	if( !( isdefined( self.bzm_attackOnlyPlayers ) && self.bzm_attackOnlyPlayers ) )
	{
		potentialAITargets = GetActorTeamArray( "allies", "team3" );
		
		zombies = GetAIArchetypeArray( "zombie", "axis" );		
		
		foreach( potentialAITarget in potentialAITargets )
		{
			if( ( isdefined( potentialAITarget.ignoreme ) && potentialAITarget.ignoreme ) )
				continue;
			
			if( ( isdefined( potentialAITarget.ignoreall ) && potentialAITarget.ignoreall ) )
				continue;
							
			if( potentialAITarget IsInScriptedState() )
				continue;
			
			if( potentialAITarget == self )
				continue;
						
			attackerCount = 0;

			if( IsDefined( potentialAITarget.attackerCount ) )
			{
				attackerCount = potentialAITarget.attackerCount;	
			}
			
			if( attackerCount < 2 ) // only 4 AI's can attack at a time
			{
				goodTargets[goodTargets.size] = potentialAITarget;
			}		
		}
		
		if( goodTargets.size )
		{
			aiTarget = ArrayGetClosest( origin, goodTargets ); 
			dist2AITarget = DistanceSquared( origin, aiTarget.origin );
		}
		
		// If the closest AI target is closer than player, then go to that target instead
		if( IsDefined( dist2player ) && IsDefined( dist2AITarget ) )
		{
			if( dist2AITarget < dist2player )
			{
				target = aiTarget;
			}
		}
		else
		{
			target = aiTarget;
		}
	}
	
	self.BZMNextTargetUpdateTime = GetTime() + RandomIntRange( 2000, 3500 );
	self.zombie_do_not_update_goal = false;	
		
	if( IsDefined( target ) && !IsPlayer( target ) && IsPointOnNavMesh( target.origin ) )
	{
		target.last_valid_position = target.origin;
	}
	
	self.favoriteenemy	= target;
	self.bzmFavEnemy = target;
	
	if( IsDefined(target) )
	{
		self SetEntityTarget( target );	
	}
			
	PixEndEvent();	
	return target;		
}

// ----------------------
// Zombie Think
//-----------------------
function BZM_ZombieThink()
{
	self endon("death");
		
	if( level.bonusZMSkiptoData["startunaware"] )	
	{		
		self flag::clear("bzm_zombie_attack");
		self.disableTargetService = true;
		self.ignoreme = true; 
		self.updateSight = true;
		self.maxsightdistsqrd = 400 * 400;
		self.fovcosine = 0.574;
			
		self thread BZM_ZombieThink_Wander();
		
		self thread BZM_ZombieThink_WaitForDamage();
		self thread BZM_ZombieThink_WaitForEnemy();
		
		self waittill("stop_inert");
		
		self flag::set("bzm_zombie_attack");
		self.disableTargetService = false;
		self.ignoreme = false; 
		self.updateSight = false;
		self.maxsightdistsqrd = 1500 * 1500;
		self.fovcosine = 0;		
	}
	else
	{
		self flag::set("bzm_zombie_attack");
	}
}

function BZM_NotifyNearbyAlertZombieFriends(origin)
{
	// notify other zombies nearby
	nearbyZombieFriends = array::get_all_closest( origin, GetActorTeamArray("axis"), array(self), 30,  400 );
		
	foreach( nearbyZombieFriend in nearbyZombieFriends )
	{
		if( IsDefined( nearbyZombieFriend ) && IsAlive( nearbyZombieFriend ) )
		{
			wait( level.bonusZMSkiptoData["alertnessspreaddelay"] );
			
			if( IsDefined( nearbyZombieFriend ) )
			{
				nearbyZombieFriend notify("stop_inert"); 
			}
		}
	}
}

function BZM_ZombieThink_WaitForEnemy()
{
	self endon("death");
	self endon("stop_inert"); 
	
	self waittill("enemy");	
	
	level thread BZM_NotifyNearbyAlertZombieFriends(self.origin);
	
	self notify("stop_inert"); 
}

function BZM_ZombieThink_WaitForDamage()
{
	self endon("death");
	self endon("stop_inert"); 
	
	self waittill("damage");
	
	BZM_NotifyNearbyAlertZombieFriends(self.origin);
	
	self notify("stop_inert"); 
}

function BZM_ZombieThink_Wander()
{
	self endon("death");
	self endon("stop_inert");
	
	while(1)
	{
		if( self.ignoreall && !self HasPath() )
		{
			myRegion = GetNavFaceRegion( self.origin, 16 );
			
			if( !IsDefined( myRegion ) )
			{
				wait RandomIntRange( 2, 3 );
				continue;
			}
	
			goToNode = bonuszmutil::BZM_FindClosestNodeWithinRegion( self.origin, myRegion, 64, 1024 );
			
			if( IsDefined( goToNode ) )
		   	{
				self SetGoal( goToNode );
			}		
		}
		
		wait RandomIntRange( 4, 5 );
	}
}

// ----------------------
// Bunch of hacks
//-----------------------
function BZM_ForceFlagOverride() // self = AI
{
	self endon("death");
	
	archetype = self.archetype;
	
	while(1)
	{
		if( !IsDefined( self ) )
			break;
		
		self.goalradius = 8;
		self.ignoreall = false;
		self.ignoreme = false;
		
		if( self.team === "allies" )
		{
			self.script_accuracy = 0.5; // allies are 50% less accurate in this mode
		}
		
		wait 1;
	}
}


// ----------------------
// Zombie Spawning failsafe
//-----------------------
function BZM_SpawnFailSafe()
{
	self endon("death");
	prevorigin = self.origin;

	level flag::wait_till( "all_players_connected" );
	self thread BZM_SpawnFailSafeTrackFailedPathFind();
	
	// Certain skipto's do not need failsafe logic to run
	if( ( isdefined( level.bonusZMSkiptoData["disablefailsafelogic"] ) && level.bonusZMSkiptoData["disablefailsafelogic"] ) )
	{
		return;
	}
	
	while(1)
	{
		level.failsafe_waittime = 30;	
		
		wait( level.failsafe_waittime );

		if( self.missingLegs )
		{
			wait( 10.0 );
		}

		//inert zombies can ignore this
		if( !self flag::get("bzm_zombie_attack") )
		{
			wait 1;
			continue;
		}
		
		if( self IsInScriptedState() )
		{
			wait 1;
			continue;
		}

		//fell out of world
		if ( self.origin[2] < -3000 )
		{
			self._bzmKilledByFailSafe = true;
			self dodamage( self.health + 100, (0,0,0) );				
			break;
		}

		//hasnt moved 24 inches in 30 seconds?	
		if( DistanceSquared( self.origin, prevorigin ) < 256*256 ) 
		{		
			// Close to player so don't timeout
			if( IsDefined( self.enemy ) )
			{
				if( DistanceSquared( self.origin, self.enemy.origin ) < 256*256 )
				{
					wait 1;
					continue;	
				}
			}
			
			self._bzmKilledByFailSafe = true;
			self dodamage( self.health + 100, (0,0,0) );
			break;
		}
		
		prevorigin = self.origin;
	}	
}

function private BZM_SpawnFailSafeTrackFailedPathFind()
{
	self endon("death");
	
	self.BZMFailedPathFindAttempts = 0;
	
	while(1)
	{
		self waittill("bad_path");
		
		// delay next pathfind for sometime, as we just failed
		self PathMode( "move delayed", false, RandomFloatRange( 2, 4 ) );						
	}
}

// ----------------------
// Zombie Death
//-----------------------
function zombie_death_event( zombie )
{
	zombie waittill( "death", attacker);
	
	time_of_death = GetTime();
	
	if(IsDefined(zombie))
	{
		zombie StopSounds();
	}

	if ( !IsDefined( zombie.damagehit_origin ) && IsDefined( attacker ) && IsAlive( attacker ) && IsActor( attacker ) )
	{
		zombie.damagehit_origin = attacker GetWeaponMuzzlePoint();
	}

	// Need to check in case he got deleted earlier
	if ( !IsDefined( zombie ) )
	{
		return;
	}
		
	name = zombie.animname;
	
	if( IsDefined( zombie.sndname ) )
	{
		name = zombie.sndname;
	}
	
	zombie thread zombie_utility::zombie_eye_glow_stop();

	if( IsActor( zombie ) )
	{
		if( IsDefined(zombie.damagemod) && zombie.damagemod == "MOD_CRUSH" )
		{
			if( IsDefined( attacker ) && IsDefined( attacker.archetype ) && attacker.archetype == "raps" )
			{
				// zombie was killed by raps 
				launchDir = VectorNormalize( zombie.origin - attacker.origin );
				zombie StartRagdoll();
				zombie LaunchRagdoll( ( launchDir[0] * 70, launchDir[1] * 70, 70 ) );
			}
		}
		
		if( (zombie.damagemod == "MOD_GRENADE") || (zombie.damagemod == "MOD_GRENADE_SPLASH") || (zombie.damagemod == "MOD_EXPLOSIVE") )
		{
			splode_dist = 12 * 15;
			
			if ( IsDefined(zombie.damagehit_origin) && distancesquared(zombie.origin,zombie.damagehit_origin) < splode_dist * splode_dist )
			{
				if (!( isdefined( zombie.is_on_fire ) && zombie.is_on_fire ) && !( isdefined( zombie.guts_explosion ) && zombie.guts_explosion ))
				{
					zombie thread zombie_utility::zombie_gut_explosion();
				}
			}
		}
	}
	
	if( zombie ai::get_behavior_attribute( "suicidal_behavior" ) )
	{			
//		rocketStart = zombie GetTagOrigin( "j_spinelower" );
//		
//		if( IsDefined( zombie.enemy ) && IsPlayer( zombie.enemy ) && IsDefined( attacker ) && attacker == zombie.enemy )
//		{
//			if( DistanceSquared( zombie.enemy.origin, zombie.origin ) > 300 * 300 )
//			{
//				rocketEnd = zombie.enemy.origin + ( 0, 0, 35 );
//				MagicBullet( level.zombieSuicideWeapon, rocketStart, rocketEnd, zombie );
//			}
//		}
		
		RadiusDamage(
				zombie.origin + (0, 0, 35),
				200 * 1.5,
				70,
				20,
				undefined,
				"MOD_EXPLOSIVE" );
		
		zombie clientfield::set("zombie_instakill_fx", 2);		
		PhysicsExplosionSphere( zombie.origin, 200, 32, 2 );
		
		zombie clientfield::set("arch_actor_fire_fx", 3);
	}
	
	zombie thread bonuszmdrops::BZM_ZombieDropItemsOnDeath();
	
	if(IsDefined (zombie.attacker) && IsPlayer(zombie.attacker) )
	{
		zombie.attacker notify( "zom_kill", zombie );
	}
		
	level notify( "zom_kill" );	
}


function BZMUtil_GetGroundPos(vStart,dist,ignore)
{
	start = vStart + (0,0,dist);
	end   = vStart - (0,0,dist);
	a_trace = BulletTrace( start, end, false, ignore, true );
	return a_trace[ "position" ];
}

function private BZM_ManageStranglersOnObjectiveCompletion()
{
	level notify("BZMUtil_WaitForObjectiveCompletion");
	
	level endon("BZMUtil_WaitForObjectiveCompletion");
	
	while(1)
	{
		if( IsDefined(level.bonusZMSkiptoData) && level.bonusZMSkiptoData["zombifyenabled"] )
		{
			if( !level.bzmExtraSpawnedNum && bonuszmutil::BZM_GetModifiedMaxExtraZombies() || !level flag::get( "bzmExtraZombieCleared" ) )
			{					
				zombies = GetAITeamArray("axis");
						
				// show last 3 zombies remaining
				if( zombies.size < 3 )
				{
					foreach( zombie in zombies )
					{
						zombie oed::enable_keyline();		
						zombie.bzm_attackOnlyPlayers = true;
						zombie.zombie_move_speed = "sprint";						
					}
					
					break;
				}		
			}
		}
		
		wait 0.5;
	}
}

function BZMUtil_WaitForAllZombiesToDie()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
		
	if( IsDefined(level.bonusZMSkiptoData) && level.bonusZMSkiptoData["forcecleanuponcompletion"] )
	{
		level.bzmExtraSpawnedNum = 0;	
		level.bzmExtraSpawnedDeadNum = 0;
				
		zombies = GetAITeamArray("axis");		
		
		foreach( zombie in zombies )
		{
			if( ( isdefined( zombie.BZMExtraZombie ) && zombie.BZMExtraZombie ) )
			{
				zombie Kill();
				wait 0.05;			
			}
		}
	}
	else
	{
		level thread BZM_ManageStranglersOnObjectiveCompletion();
		
		while(1)
		{
			if( IsDefined(level.bonusZMSkiptoData) && level.bonusZMSkiptoData["zombifyenabled"] )
			{
				if( !level.bzmExtraSpawnedNum && bonuszmutil::BZM_GetModifiedMaxExtraZombies() || !level flag::get( "bzmExtraZombieCleared" ) )
				{
					wait 1;
					continue;
				}				
			}			
			
			break;
		}		
	}	
}

function BZMUtil_WaitForObjectiveCompletion()
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
		
	if( IsDefined(level.bonusZMSkiptoData) && level.bonusZMSkiptoData["forcecleanuponcompletion"] )
	{
		level.bzmExtraSpawnedNum = 0;	
		level.bzmExtraSpawnedDeadNum = 0;
		level flag::clear( "bzmExtraZombieCleared" );
		level flag::clear( "bzmObjectiveEnabled" );
		
		zombies = GetAITeamArray("axis");		
		
		foreach( zombie in zombies )
		{
			if( ( isdefined( zombie.BZMExtraZombie ) && zombie.BZMExtraZombie ) )
			{
				zombie Kill();
				wait 0.05;			
			}
		}
	}
	else
	{
		level thread BZM_ManageStranglersOnObjectiveCompletion();
		
		while(1)
		{
			if( IsDefined(level.bonusZMSkiptoData) && level.bonusZMSkiptoData["zombifyenabled"] )
			{
				if( !level.bzmExtraSpawnedNum && bonuszmutil::BZM_GetModifiedMaxExtraZombies() || !level flag::get( "bzmExtraZombieCleared" ) )
				{
					wait 1;
					continue;
				}				
			}			
			
			break;
		}
				
		level.bzmExtraSpawnedNum = 0;	
		level.bzmExtraSpawnedDeadNum = 0;
		level flag::clear( "bzmExtraZombieCleared" );
		level flag::clear( "bzmObjectiveEnabled" );
		
		level notify("BZMUtil_WaitForObjectiveCompletion");
	}	
}

function BZMUtil_StartObjective( skiptoname, levelstart ) // levelstart will be true, if the level is staring on this checkpoint
{
	if( !( SessionModeIsCampaignZombiesGame() ) )
		return;
		
	assert(IsDefined(skiptoname));
	
	bonuszmdata::BZM_FillDataFromForSkipto( GetDvarString( "mapname" ), skiptoname );
	
	if( !levelstart && level.bonusZMSkiptoData["onlyuseonstart"] )
	{			
		// Dont spawn extra zombies in this case			
		level.bonusZMSkiptoData["extraspawns"] = 0;		
	}
	
	if( !bonuszmutil::BZM_GetModifiedMaxExtraZombies() )
		level flag::set( "bzmExtraZombieCleared" );
	else
		level flag::clear( "bzmExtraZombieCleared" );	
	
	level flag::set( "bzmObjectiveEnabled" );
	
	
	level.bzmExtraSpawnedNum = 0;	
	level.bzmExtraSpawnedDeadNum = 0;
		
	BonusZMSpawner::BZM_SpawnerSetupSkipto();
	BZM_SetupZombieCustomSpawnFunction();	
	
	level notify("bzm_checkpoint_changed");
}

// ----------------------
// Post Fx
//-----------------------
function BZM_PostFx()
{
	self endon("disconnect");
	self endon("death");
	
	while(1)
	{
		forcePostFx 	= GetDvarString("bzm_forcePostFx");
		currentPostFx 	= 0;
		
		if( forcePostFx == "bblend" )
			currentPostFx = 1;
		else if( forcePostFx == "multiply" )
			currentPostFx = 2;
		
		self clientfield::set_to_player("bonuszm_post_fx", currentPostFx);
		
		wait 0.5;
	}
}

// ----------------------
// Track Player Cybercom usage
//-----------------------
function BZM_CyberComThink()
{
	level notify("BZM_CyberComThink");
	level endon("BZM_CyberComThink");
		
	waittillframeend;
		
	self thread BZM_WatchPlayerCyberComMisDirection();	
	
	// constant changes to the cybercom, so that level script can not override it
	while(1)
	{
		level clientfield::set( "cybercom_disabled", 1 );
		self cybercom_tacrig::giveRigAbility( "cybercom_playermovement" , true );
		wait 0.1;
	}	
}

function BZM_WatchPlayerCyberComMisDirection()
{
	self endon("disconnect");
	self endon("death");
	
	while(1)
	{
		self waittill("cybercom_decoy_released", misDirectionObject);
		
		array::add(level.BZMZombieSpecificTargets,misDirectionObject);
	}
}

// ----------------------
// On loadout
//-----------------------
function private BZMOnLoadout()
{
	assert(IsPlayer(self));
		
	// Take away all primary weapons from the player
	loadedPrimaryWeapons = self GetWeaponsListPrimaries();
		
	foreach( weapon in loadedPrimaryWeapons )
	{
		self TakeWeapon( weapon );
		self SortHeldWeapons();
	}
	
	// Give a pistol to start with
	pistolWeapon = GetWeapon("pistol_standard");
	self GiveWeapon( pistolWeapon );
	self SwitchToWeapon( pistolWeapon );
	self GiveMaxAmmo( pistolWeapon );
	
	weaponList = self GetWeaponsList();
	
	// Take away all cybercore abilities
	foreach(ability in level.cybercom.abilities)
	{	
		self ClearCyberComAbility(ability.name);
		self cybercom_gadget::abilityTaken(ability);
	}
}

//Sound function for tracking when zombies are behind the player
function BZM_sndBehindVox()
{
	level endon("unloaded");
	self endon("death_or_disconnect");
	
	if(!IsDefined(level._zbv_vox_last_update_time))
	{
		level._zbv_vox_last_update_time = 0;	
		level._audio_zbv_shared_ent_list = GetAITeamArray( "axis" );
	}
	
	while(1)
	{
		wait(1);		
		
		t = GetTime();
		
		if(t > level._zbv_vox_last_update_time + 1000)
		{
			level._zbv_vox_last_update_time = t;
			level._audio_zbv_shared_ent_list = GetAITeamArray( "axis" );
		}
		
		zombs = level._audio_zbv_shared_ent_list;
		
		played_sound = false;
		
		for(i=0;i<zombs.size;i++)
		{
			if(!isDefined(zombs[i]))
			{
				continue;
			}
			
			if( isdefined(self.archetype) && ( self.archetype != "zombie" ))
			{
				level._audio_zbv_shared_ent_list = array::remove_index( level._audio_zbv_shared_ent_list, i );
				continue;
			}
				
			dist = 250;	
			z_dist = 50;	
		
			if(DistanceSquared(zombs[i].origin,self.origin) < dist * dist )
			{				
				
				zombAngles = VectorToAngles(zombs[i].origin-self.origin);
				yaw = self.angles[1] - zombAngles[1];
				yaw = AngleClamp180( yaw );

				z_diff = self.origin[2] - zombs[i].origin[2];
				if( (yaw < -95 || yaw > 95) && abs( z_diff ) < 50 )
				{
					zombs[i] notify( "bhtn_action_notify", "behind" );
					played_sound = true;
					break;
				}			
			}
		}
		
		if(played_sound)
		{
			wait(5);		// Each player can only play one instance of this sound every 5 seconds - instead of the previous network storm.
		}
	}
}