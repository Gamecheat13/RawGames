#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

// sm related includes
#using scripts\cp\sm\_sm_round_beacon;
#using scripts\cp\sm\_sm_round_manager;
#using scripts\cp\sm\_sm_round_objective;
#using scripts\cp\sm\_sm_round_objective_secure_goods;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                            	   	
                                                                   	       	     	          	      	                                                                                            	                                                           	                                  
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    	                                                              	                                                          	                                   	                                   	                                                    	                                       

// Role defines







// role think functions are stored in this order in the array	



	
// utility defines


	









	








	//	How far forward from the bomber's origin to start the explosion




		






// Temp FX for now
#precache( "fx", "light/fx_glow_drone_suicide_energy" );
#precache( "fx", "explosions/fx_exp_drone_suicide_charge" );
	
#namespace SMAIManager;	

// SUMEET SM_AI_MANAGER TODO
// Add support for vehicles 
// Add support for defend role for objective rounds
// Add support for threat bias for objective rounds
// Remove the need of SM_AI_SPAWN_COMPLETE_FLAG

// AIM MANAGER --------------------------------------------------------------------------------
class SMAIManager
{	
	var supportedRoles; 	  // roles supported by the AI manager
		
	constructor()
	{
		supportedRoles = array( "role_track_enemy", "role_defend_objective", "role_melee_beacon", "role_bomb_beacon", "role_shoot_beacon" );
		currentObjectiveIndex = 0;
	}
	
	function GetObjectiveToDefend( entity )
	{
		currentRoundType = side_mission::get_round_type();
		
		if( currentRoundType == "objective" )
		{
			// get all the active objectives
			defendObjectives = sm_round_objective::defend_object_get_array();
		
			// sort array based on distance
			defendObjectivesSorted = ArraySort( defendObjectives, entity.origin, true );
			
			foreach( defendObjective in defendObjectivesSorted )
			{
				if( !IsDefined( defendObjective.assignedDefenders ) )
				{
					defendObjective.assignedDefenders = [];
				}
				
				if( defendObjective.assignedDefenders.size < 3 )
				{
					return defendObjective;
				}
			}			
		}
		
		return undefined;
	}
	
	function AssignDefendObjectiveToAI( defendObjective, entity )
	{
		currentRoundType = side_mission::get_round_type();
		
		if( currentRoundType == "objective" )
		{
			if ( !isdefined( defendObjective.assignedDefenders ) ) defendObjective.assignedDefenders = []; else if ( !IsArray( defendObjective.assignedDefenders ) ) defendObjective.assignedDefenders = array( defendObjective.assignedDefenders ); defendObjective.assignedDefenders[defendObjective.assignedDefenders.size]=entity;;
			entity.assignedDefendObjective = defendObjective;			
		}
	}
	
	function RemoveDefendObjectiveAssignment( entity )
	{
		currentRoundType = side_mission::get_round_type();
		
		if( currentRoundType == "objective" )
		{
			defendObjective = entity.assignedDefendObjective;
			
			if( IsDefined( defendObjective.assignedDefenders ) )
			{
				foreach( assignedDefender in defendObjective.assignedDefenders )
				{
					if( assignedDefender == entity )
					{
						ArrayRemoveValue( defendObjective.assignedDefenders, assignedDefender );
						return;
					}
				}
			}
			
			entity.assignedDefendObjective = undefined;
		}
	}
	
	function AIM_GenerateRoleAssignmentForAI( entity )
	{
		Assert( IsAI( entity ), "SM_AI_MANAGER AIM_GenerateRoleAssignmentForAI() - Only Actors and vehicles are supported." );
	}
	
	function OnRoundStart()
	{
		
	}
	
	function OnRoundComplete()
	{
		
	}

	function OnAIDeath( entity )
	{
		RemoveDefendObjectiveAssignment( entity );
	}
}

function AIM_SetupBeaconAttackLocations( beaconEnt )
{
	beaconAttackNodes = GetNodesInRadius( beaconEnt.origin, 512, 0, 64, "Guard" );
	
	beaconEnt.meleeAttackNodes = [];
	beaconEnt.shootAttackNodes = [];
	
	foreach( beaconAttackNode in beaconAttackNodes )
	{
		if( IsDefined( beaconAttackNode.targetname ) )
		{
			if( beaconAttackNode.targetname == "beacon_melee_attack_loc" )
			{
				beaconEnt.meleeAttackNodes[beaconEnt.meleeAttackNodes.size] = beaconAttackNode;
			}
			
			if( beaconAttackNode.targetname == "beacon_shoot_attack_loc" )
			{
				beaconEnt.shootAttackNodes[beaconEnt.shootAttackNodes.size] = beaconAttackNode;
			}
		}
	}
		
	Assert( beaconEnt.meleeAttackNodes.size >= 8 );
	Assert( beaconEnt.shootAttackNodes.size >= 8 );	
}

function autoexec __init__sytem__() {     system::register("SMAIManager",&__init__,undefined,undefined);    }

// SYSTEM INIT --------------------------------------------------------------------------------
function __init__()
{
	level.SMAIManager = new SMAIManager();

	AIM_SetupAISpawnFuncs();	
	
	level.SMAIManager thread AIM_Main_Think();
	
	// Temp FX for Demo
	level._effect[ "demo_charge_up" ]	= "light/fx_glow_drone_suicide_energy";
	level._effect[ "demo_explosion" ]	= "explosions/fx_exp_drone_suicide_charge";
	
	// Clientfields
	clientfield::register( "actor", "demo_state", 1, GetMinBitCountForNum(2), "int" );
}	

// SM_AI_ROLE_BASE
class SMAIRoleBase
{
	var roleName;
	
	constructor()
	{
		
	}
	
	function GetRoleName()
	{
		return roleName;
	}
	
	function ThinkStart( entity )
	{
		
	}
	
	function Think( entity )
	{
		
	}
	
	function ThinkFinish( entity )
	{
		
	}	
	
	function OnDeath( entity )
	{
		
	}
}

// SM_AI_ROLE_TRACK_ENEMY --------------------------------------------------------------------------------
class SMAIRoleTrackEnemy : SMAIRoleBase
{	
	var trackingEntity; // should be the player
	var trackingRadius; // currently un-used
			
	constructor()
	{
		roleName = "role_track_enemy";					
	}
		
	function Think( entity )
	{
		if( IsDefined( entity.enemy ) )
		{			
			if( IsDefined( trackingEntity ) && trackingEntity == entity.enemy )
				return;
				
			if( ( IsPlayer( entity.enemy ) && entity.enemy.sessionstate == "playing" )
			   || IsVehicle( entity.enemy )
			  )
			{
				trackingEntity = entity.enemy;
				
				if ( IsPlayer( entity.enemy ) || IsAI( entity.enemy ) )
				{
					entity SetGoal( entity.enemy, false, entity.engageMaxFallOffDist, entity.goalHeight );
				}
				else
				{
					entity SetGoal( entity.enemy.origin );
				}
			}			
		}		
	}	
}

// SM_AI_ROLE_DEFEND_OBJECTIVE --------------------------------------------------------------------------------
class SMAIRoleDefendObjective : SMAIRoleBase
{
	var defendLocation; // should be the location of the objective
	var defendRadius; 	// radius around the defend location that AI should try to stay within 
			
	constructor()
	{
		roleName = "role_defend_objective";					
	}
		
	function ThinkStart( entity )
	{
		Assert( IsDefined( entity.assignedDefendObjective ) );
			
		entity SetGoal( entity.assignedDefendObjective, false, 400 );
	}
	
	function Think( entity )
	{	
		objectiveCarrier = entity.assignedDefendObjective gameobjects::get_carrier();
		
		if( IsDefined( objectiveCarrier ) )
		{
			entity SetGoal( objectiveCarrier, false, 400 );
			/# recordLine( entity.origin, objectiveCarrier.origin, ( 1, .5, 0 ), "Script", entity ); #/
		}
		else
		{
			entity SetGoal( entity.assignedDefendObjective, false, 400 );
			/# recordLine( entity.origin, entity.assignedDefendObjective.origin, ( 1, .5, 0 ), "Script", entity ); #/
		}		
	}
}

// SM_AI_ROLE_MELEE_BEACON --------------------------------------------------------------------------------
class SMAIRoleMeleeBeacon : SMAIRoleBase
{
	var beaconEnt; 			  // should be the beacon entity
	var inMeleeSceneAttack;   // set to true, if AI is playing a melee scene
	var nextMeleeDamageTime;  // set to true, if AI is playing a melee scene
	var currentAttackNode;	  // melee attack node
		
	constructor()
	{
		roleName = "role_melee_beacon";							
		
		inMeleeSceneAttack = false;
		nextMeleeDamageTime = GetTime() + 3000;
	}
	
	function AssignAttackNode( entity )
	{
		// Get ative beacon
		beaconEnt = sm_round_beacon::get_active_beacon();
		Assert( IsDefined( beaconEnt ) );
		Assert( IsDefined( beaconEnt.meleeAttackNodes ) );
		
		// ignore everyone and just conventrate on the beacon
		entity.ignoreall = true;
		
		// find a open melee attack location
		meleeAttackNodes = array::randomize( beaconEnt.meleeAttackNodes );
		
		foreach( meleeAttackNode in meleeAttackNodes )
		{
			if( !( isdefined( meleeAttackNode.attackerAssigned ) && meleeAttackNode.attackerAssigned ) )
			{
				currentAttackNode = meleeAttackNode;
				currentAttackNode.attackerAssigned = true;
								
				entity SetGoal( currentAttackNode.origin, true );
				return;
			}
		}
	}
		
	function ThinkStart( entity )
	{
		// SUMEET TODO - check GDT support for not having a weapon, is it giving script errors?
		entity HidePart( "tag_weapon" );
		
		AssignAttackNode( entity );
	}
		
	function Think( entity )
	{
		if( !IsDefined( currentAttackNode ) )
		{
			AssignAttackNode( entity );
		}
		else if( entity IsAtGoal() && IsDefined( currentAttackNode ) && !inMeleeSceneAttack )
		{	
			Assert( IsDefined( currentAttackNode ) );
			
			//  looping scene for melee
			currentAttackNode scene::play( "beacon_melee_attack", entity );
			
			inMeleeSceneAttack = true;
		}
		
		if( inMeleeSceneAttack && GetTime() >= nextMeleeDamageTime )
		{
			nextMeleeDamageTime = GetTime() + 3000;
			beaconEnt DoDamage( 50, entity.origin, entity );
		}
	}
	
	function OnDeath( entity )
	{
		if( IsDefined( currentAttackNode ) )
		{
			currentAttackNode.attackerAssigned = false;
		}
	}
}

// SM_AI_ROLE_BOMB_BEACON --------------------------------------------------------------------------------
class SMAIRoleBombBeacon : SMAIRoleBase
{
	var beaconEnt; 				// should be the beacon entity
	var inBombScene;   			// set to true, if AI is playing a detonation sequence
	var currentAttackNode;		// melee attack node
	var	detonationTime;			// Time to explode

	constructor()
	{
		roleName = "role_bomb_beacon";							
		
		inBombScene = false;
	}
	
	function AssignAttackNode( entity )
	{
		// Get ative beacon
		beaconEnt = sm_round_beacon::get_active_beacon();
		Assert( IsDefined( beaconEnt ) );
		Assert( IsDefined( beaconEnt.meleeAttackNodes ) );
		
		// ignore everyone and just conventrate on the beacon
		entity.ignoreall = true;
		
		// find a open melee attack location
		meleeAttackNodes = array::randomize( beaconEnt.meleeAttackNodes );
		
		foreach( meleeAttackNode in meleeAttackNodes )
		{
			if( !( isdefined( meleeAttackNode.attackerAssigned ) && meleeAttackNode.attackerAssigned ) )
			{
				currentAttackNode = meleeAttackNode;
				currentAttackNode.attackerAssigned = true;
								
				entity SetGoal( currentAttackNode.origin, true );
				return;
			}
		}
	}
		
	function ThinkStart( entity )
	{
		// SUMEET TODO - check GDT support for not having a weapon, is it giving script errors?
		entity HidePart( "tag_weapon" );
		
		AssignAttackNode( entity );
	}
		
	function Think( entity )
	{
		if( !IsDefined( currentAttackNode ) )
		{
			AssignAttackNode( entity );
		}
		else if( !inBombScene && entity IsAtGoal() && IsDefined( currentAttackNode ) )
		{	
			//TODO somehow we can get here before the AI is even at the attack node
			thread detonate_bomb( entity );
		}
	}
	
	function detonate_bomb( entity )
	{
		entity endon( "death" );

		// Get readyt to blow up
		inBombScene = true;
		
		currentAttackNode thread scene::play( "robot_demo_charge_up", entity );
		entity waittill( "goal" );	// wait for the AI to be at the location.  
		
		entity clientfield::set( "demo_state", 1 );
		
		wait( 5 );

		//  Project an explosion in front of the bomber
		entity clientfield::set( "demo_state", 2 );

		// Damage the beacon ent specifically
		beaconEnt DoDamage( 500, entity.origin );
		//	And collateral damage
		RadiusDamage( entity.origin, 64, 200, 50, entity, "MOD_EXPLOSIVE" );
		util::wait_network_frame();	// ensure the explosion has been sent to the client.

		// And kill self
		entity DoDamage( entity.health, entity.origin );
	}

	function OnDeath( entity )
	{
		if( IsDefined( currentAttackNode ) )
		{
			currentAttackNode.attackerAssigned = false;
		}
	}
}


// SM_AI_ROLE_SHOOT_BEACON --------------------------------------------------------------------------------
class SMAIRoleShootBeacon : SMAIRoleBase
{
	var beaconEnt; 			  // should be the beacon entity
	var currentAttackNode;    // shoot attack node
	
	constructor()
	{
		roleName = "role_shoot_beacon";							
	}
	
	function AssignAttackNode( entity )
	{
		// Get ative beacon
		beaconEnt = sm_round_beacon::get_active_beacon();
		Assert( IsDefined( beaconEnt ) );
		Assert( IsDefined( beaconEnt.shootAttackNodes ) );
		
		// find a open shoot attack location
		shootAttackNodes = array::randomize( beaconEnt.shootAttackNodes );
		
		foreach( shootAttackNode in shootAttackNodes )
		{
			if( !( isdefined( shootAttackNode.attackerAssigned ) && shootAttackNode.attackerAssigned ) )
			{
				currentAttackNode = shootAttackNode;
				currentAttackNode.attackerAssigned = true;
				
				entity SetGoal( shootAttackNode.origin, true );
				return;
			}
		}
	}
		
	function ThinkStart( entity )
	{
		AssignAttackNode( entity );
	}
		
	function Think( entity )
	{		
		if( !IsDefined( currentAttackNode ) )
		{
			AssignAttackNode( entity );
		}
		
		if( entity IsAtGoal() && IsDefined( currentAttackNode ) )
		{
			entity SetEntityTarget( beaconEnt );
		}
	}
	
	function OnDeath( entity )
	{
		if( IsDefined( currentAttackNode ) )
		{
			currentAttackNode.attackerAssigned = false;
		}
	}
}

// AI ROLES ASSIGNMENT ------------------------------------------------------------------------------------
function AIM_SetupAISpawnFuncs()
{
	// setup spawn callback functions to process AI when they are spawned
	actorSpawnerArray = GetActorSpawnerTeamArray( "axis" );
	util::array_func( actorSpawnerArray, &spawner::add_spawn_function, &AI_InitSetup );		
	
	callback::on_actor_killed( &AI_Death_Think );	
}

function AI_InitSetup()
{
}

function Sapper_Demo_DamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex )
{
	ignoreDamage = false;

	foreach( ignoredWeapon in self.damageIgnoreWeaponList )
	{
		if ( ignoredWeapon == sWeapon )
		{
			ignoreDamage = true;
			break;
		}
	}

	if ( ignoreDamage )
	{
		iDamage = 0;
	}

	return iDamage;
}

function AIM_Main_Think() // self = AI Manager 
{	
	while( !level flag::exists( "sm_beacon_activated" ) )
	{
		{wait(.05);};
	}
	
	level flag::wait_till( "sm_beacon_activated" );	
}

function AI_Think( entity )
{
	entity endon("death");
	entity endon("role_switched");
	
	// ThinkStart		
	[[entity.SMAIRole]]->ThinkStart(entity);		
		
	// Think
	while(1)
	{
		/#recordEntText( [[entity.SMAIRole]]->GetRoleName(), entity, ( 1, .5, 0 ), "Script" );#/
		
		[[entity.SMAIRole]]->Think(entity);		
		wait 1;
	}
}

function AI_Death_Think()
{
	if( IsDefined( self.SMAIRole ) )
	{
		[[self.SMAIRole]]->OnDeath(self);
	}
}

function AIM_AssignRoleToAI( entity, aiRole ) 
{
	entity endon("death");
	entity endon("role_switched");
	
	Assert( IsDefined( aiRole ), "SM_AI_MANAGER - Un-defined role." );
			
	// PREVIOUS ROLE 
	if( IsDefined( entity.SMAIRole ) )
	{
		// end all previous role thinks
		entity notify("role_switched");
		
		// ThinkFinish
		[[entity.SMAIRole]]->ThinkFinish(entity);
	}
	
	// NEW ROLE
	switch( aiRole )
	{
		case "role_melee_beacon": 	
			entity.SMAIRole = new SMAIRoleMeleeBeacon();
			break;

		case "role_shoot_beacon": 	
			entity.SMAIRole = new SMAIRoleShootBeacon();
			break;

		case "role_bomb_beacon":
			entity.SMAIRole = new SMAIRoleBombBeacon();
			break;

		case "role_defend_objective":
			entity.SMAIRole = new SMAIRoleDefendObjective();			
			break;

		case "role_track_enemy":
		default:		
			entity.SMAIRole = new SMAIRoleTrackEnemy();
			break;
	}
		
	entity thread AI_Think( entity );
}

// SPAWNED AI INIT --------------------------------------------------------------------------------
function AI_Main_Think() // self = AI
{		
	// Get a role for this AI
	aiRole = [[level.SMAIManager]]->AIM_GenerateRoleAssignmentForAI( self );
	
	// assign the new role
	self thread AIM_AssignRoleToAI( self, aiRole );
}

