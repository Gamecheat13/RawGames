#using scripts\codescripts\struct;

#using scripts\shared\gameskill_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\math_shared;
#using scripts\shared\array_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicles\_attack_drone;
#using scripts\shared\flag_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\ai_shared;
#using scripts\shared\ai\systems\ai_interface;
//#using scripts\cp\_util; // for getOtherTeam function

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
       
                                                                                                             	     	                                                                                                                                                                

                                                                  	                             	  	                                      




// Speeds




// scanner


 // 0 as horizontal, 90 as straight down



 //90


// weapon



 // tunable length of persistent sight on target before fire rocket


// drone

 // will wait this amount of time after player run into a non-reachable space to deploy attack drones

// other





// pain
 // 0 to disable

// feature control

 // if true, side turret will not choose same target as main turret (so the player being targeted won't get cross fired by all three turrets)








#namespace hunter;

function autoexec __init__sytem__() {     system::register("hunter",&__init__,undefined,undefined);    }
	
#using_animtree( "generic" );

// ----------------------------------------------
// initialization
// ----------------------------------------------
function __init__()
{
	RegisterInterfaceAttributes( "hunter" );
	vehicle::add_main_callback( "hunter", &hunter_initialize );
}

function RegisterInterfaceAttributes( archetype )
{
	vehicle_ai::RegisterSharedInterfaceAttributes( archetype );

	// Strafe distance
	ai::RegisterNumericInterface(
		archetype,
		"strafe_speed",
		0,
		0, 100 );

	ai::RegisterNumericInterface(
		archetype,
		"strafe_distance",
		0,
		0, 10000 );
}

function hunter_initTagArrays()
{
	self.weakSpotTags = [];
	if ( false )
	{
		if ( !isdefined( self.weakSpotTags ) ) self.weakSpotTags = []; else if ( !IsArray( self.weakSpotTags ) ) self.weakSpotTags = array( self.weakSpotTags ); self.weakSpotTags[self.weakSpotTags.size]="tag_target_l";;
		if ( !isdefined( self.weakSpotTags ) ) self.weakSpotTags = []; else if ( !IsArray( self.weakSpotTags ) ) self.weakSpotTags = array( self.weakSpotTags ); self.weakSpotTags[self.weakSpotTags.size]="tag_target_r";;
	}

	self.explosiveWeakSpotTags = [];
	if ( false )
	{
		if ( !isdefined( self.explosiveWeakSpotTags ) ) self.explosiveWeakSpotTags = []; else if ( !IsArray( self.explosiveWeakSpotTags ) ) self.explosiveWeakSpotTags = array( self.explosiveWeakSpotTags ); self.explosiveWeakSpotTags[self.explosiveWeakSpotTags.size]="tag_fan_base_l";;
		if ( !isdefined( self.explosiveWeakSpotTags ) ) self.explosiveWeakSpotTags = []; else if ( !IsArray( self.explosiveWeakSpotTags ) ) self.explosiveWeakSpotTags = array( self.explosiveWeakSpotTags ); self.explosiveWeakSpotTags[self.explosiveWeakSpotTags.size]="tag_fan_base_r";;
	}

	self.missileTags = [];
	if ( !isdefined( self.missileTags ) ) self.missileTags = []; else if ( !IsArray( self.missileTags ) ) self.missileTags = array( self.missileTags ); self.missileTags[self.missileTags.size]="tag_rocket1";;
	if ( !isdefined( self.missileTags ) ) self.missileTags = []; else if ( !IsArray( self.missileTags ) ) self.missileTags = array( self.missileTags ); self.missileTags[self.missileTags.size]="tag_rocket2";;

	self.droneAttachTags = [];
	if ( false )
	{
		if ( !isdefined( self.droneAttachTags ) ) self.droneAttachTags = []; else if ( !IsArray( self.droneAttachTags ) ) self.droneAttachTags = array( self.droneAttachTags ); self.droneAttachTags[self.droneAttachTags.size]="tag_drone_attach_l";;
		if ( !isdefined( self.droneAttachTags ) ) self.droneAttachTags = []; else if ( !IsArray( self.droneAttachTags ) ) self.droneAttachTags = array( self.droneAttachTags ); self.droneAttachTags[self.droneAttachTags.size]="tag_drone_attach_r";;
	}
}

function hunter_SpawnDrones()
{
	self.dronesOwned = [];

	if ( false )
	{
		foreach( droneTag in self.droneAttachTags )
		{
			origin = self GetTagOrigin( droneTag );
			angles = self GetTagAngles( droneTag );

			drone = SpawnVehicle( "spawner_bo3_attack_drone_enemy", origin, angles );

			drone.owner = self;
			drone.attachTag = droneTag;
			drone.team = self.team;

			if ( !isdefined( self.dronesOwned ) ) self.dronesOwned = []; else if ( !IsArray( self.dronesOwned ) ) self.dronesOwned = array( self.dronesOwned ); self.dronesOwned[self.dronesOwned.size]=drone;;
		}
	}
}

function hunter_initialize()
{
	self endon( "death" );
	
	self UseAnimTree( #animtree );
	
	Target_Set( self, ( 0, 0, 90 ) );

	ai::CreateInterfaceForEntity( self );

	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();

	//self EnableAimAssist();
	self SetNearGoalNotifyDist( 50 );

	self SetHoverParams( 15, 100, 40 );
	self.flyheight = GetDvarFloat( "g_quadrotorFlyHeight" );

	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0.574;	//+/- 55 degrees = 110 fov

	self.vehAirCraftCollisionEnabled = true;

	self.original_vehicle_type = self.vehicletype;

	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	self.goalRadius = 999999;
	self.goalHeight = 999999;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );

	self hunter_initTagArrays();

	self.overrideVehicleDamage = &HunterCallback_VehicleDamage;

	self thread vehicle_ai::nudge_collision();
	
	//disable some cybercom abilities
	if( IsDefined( level.vehicle_initializer_cb ) )
	{
    	[[level.vehicle_initializer_cb]]( self );
	}	

//	self thread hunter_frontScanning();

//	self hunter_SpawnDrones();
//
//	wait 0.5;
//
//	foreach ( drone in self.dronesOwned )
//	{
//		if ( isalive( drone ) )
//		{
//			drone vehicle_ai::set_state( "attached" );
//		}
//	}
	self turret::_init_turret( 1 );
	self turret::_init_turret( 2 );

	self turret::set_best_target_func( &side_turret_get_best_target, 1 );
	self turret::set_best_target_func( &side_turret_get_best_target, 2 );

	self turret::set_burst_parameters( 1, 2, 1, 2, 1 );
	self turret::set_burst_parameters( 1, 2, 1, 2, 2 );

	self turret::set_target_flags( 1 | 2, 1 );
	self turret::set_target_flags( 1 | 2, 2 );

	self PathVariableOffset( (10, 10, -30), 1 );

	defaultRole();
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role();

	self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &state_combat_enter;
	self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
	self vehicle_ai::get_state_callbacks( "combat" ).exit_func = &state_combat_exit;
	
	self vehicle_ai::get_state_callbacks( "driving" ).enter_func = &hunter_scripted;
	self vehicle_ai::get_state_callbacks( "scripted" ).enter_func = &hunter_scripted;

	self vehicle_ai::get_state_callbacks( "death" ).enter_func = &state_death_enter;
	self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;

	self vehicle_ai::get_state_callbacks( "emped" ).update_func = &hunter_emped;

	self vehicle_ai::add_state( "unaware",
		undefined,
		&state_unaware_update,
		&state_unaware_exit );

	vehicle_ai::add_interrupt_connection( "unaware",	"scripted",	"enter_scripted" );
	vehicle_ai::add_interrupt_connection( "unaware",	"emped",	"emped" );
	vehicle_ai::add_interrupt_connection( "unaware",	"off",		"shut_off" );
	vehicle_ai::add_interrupt_connection( "unaware",	"driving",	"enter_vehicle" );
	vehicle_ai::add_interrupt_connection( "unaware",	"pain",		"pain" );

	self vehicle_ai::add_state( "strafe",
		&state_strafe_enter,
		&state_strafe_update,
		&state_strafe_exit );

	vehicle_ai::add_interrupt_connection( "strafe",	"scripted",	"enter_scripted" );
	vehicle_ai::add_interrupt_connection( "strafe",	"emped",	"emped" );
	vehicle_ai::add_interrupt_connection( "strafe",	"off",		"shut_off" );
	vehicle_ai::add_interrupt_connection( "strafe",	"driving",	"enter_vehicle" );
	vehicle_ai::add_interrupt_connection( "strafe",	"pain",		"pain" );
	vehicle_ai::add_utility_connection( "strafe",	"combat" );

	vehicle_ai::add_utility_connection( "emped",	"strafe" );
	vehicle_ai::add_utility_connection( "pain",	"strafe" );

	vehicle_ai::StartInitialState();
}

// ----------------------------------------------
// State: death
// ----------------------------------------------
function shut_off_fx()
{
	self endon( "death" );

	self notify( "death_shut_off" );

	if ( isdefined( self.frontScanner ) )
	{
		self.frontScanner.sndScanningEnt delete();
		self.frontScanner delete();
	}
}

function kill_drones()
{
	self endon( "death" );

	foreach ( drone in self.dronesOwned )
	{
		if ( isalive( drone ) && Distance2DSquared( self.origin, drone.origin ) < ( (80) * (80) ) )
		{
			damageOrigin = self.origin + (0,0,1);
			drone finishVehicleRadiusDamage(self.death_info.attacker, self.death_info.attacker, 32000, 32000, 10, 0, "MOD_EXPLOSIVE", level.weaponNone,  damageOrigin, 400, -1, (0,0,1), 0);
		}
	}
}

function state_death_enter( params )
{
	self endon( "death" );

	if ( isdefined( self.fakeTargetEnt ) )
	{
		self.fakeTargetEnt Delete();
	}

	vehicle_ai::defaultstate_death_enter();

	self.inpain = true;

	self thread shut_off_fx();
	//self thread kill_drones();
}

function state_death_update( params )
{
	self endon( "death" );

	if ( !isdefined( params.dir ) )
	{
		params.dir = (0,0,0);
	}
	
	self NotSolid();
	self thread vehicle_death::helicopter_crash( self.origin, params.dir );

	self waittill( "crash_done" );

	self thread wait_and_do_death( self.modelswapdelay );

	self.delete_on_death = true;
	self.waittime_before_delete = 5;
	vehicle_ai::defaultstate_death_update();
}

function wait_and_do_death( time )
{
	self endon( "death" );	

	if ( isdefined( time ) && time > 0 )
	{
		wait time;
	}
	self ghost();
	self vehicle::do_death_dynents();
}

// ----------------------------------------------

// ----------------------------------------------
// State: unaware
// ----------------------------------------------
function state_unaware_enter( params )
{
	ratio = 0.5;
	accel = self GetDefaultAcceleration();
	self SetSpeed( ratio * self.settings.defaultmovespeed, ratio * accel, ratio * accel );
}

function state_unaware_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	if ( isdefined( self.enemy ) )
	{
		self vehicle_ai::set_state( "combat" );
	}

	self ClearLookAtEnt();
	self disable_turrets();
	self thread Movement_Thread_Wander();

	while ( 1 )
	{
		self waittill( "enemy" );
		self vehicle_ai::set_state( "combat" );
	}
}

function state_unaware_exit( params )
{
	self notify( "end_movement_thread" );
}

function Movement_Thread_Wander()
{
	self endon( "death" );
	self notify( "end_movement_thread" );
	self endon( "end_movement_thread" );

	constMinSearchRadius = 120;
	constMaxSearchRadius = 800;

	minSearchRadius = math::clamp( constMinSearchRadius, 0, self.goalRadius );
	maxSearchRadius = math::clamp( constMaxSearchRadius, constMinSearchRadius, self.goalRadius );
	halfHeight = 400;
	innerSpacing = 80;
	outerSpacing = 50;
	maxGoalTimeout = 15;
	timeAtSamePosition = 2.5 + randomfloat( 1 );

	while ( true )
	{
		queryResult = PositionQuery_Source_Navigation( self.origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing );
		PositionQuery_Filter_DistanceToGoal( queryResult, self );
		vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );
		vehicle_ai::PositionQuery_Filter_Random( queryResult, 0, 10 );
		vehicle_ai::PositionQuery_PostProcess_SortScore( queryResult );

		stayAtGoal = timeAtSamePosition > 0.2;

		foundpath = false;
		for ( i = 0; i < queryResult.data.size && !foundpath; i++ )
		{
			goalPos = queryResult.data[i].origin;
			foundpath = self SetVehGoalPos( goalPos, stayAtGoal, true );
		}

		if ( foundPath )
		{
			msg = self util::waittill_any_timeout( maxGoalTimeout, "near_goal", "force_goal", "reached_end_node", "goal" );

			if ( stayAtGoal )
			{
				wait randomFloatRange( 0.5 * timeAtSamePosition, timeAtSamePosition );
			}
		}
		else
		{
			wait 1;
		}
	}
}
// ----------------------------------------------

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function enable_turrets()
{
	//self turret::enable( 0, false );
	self turret::enable( 1, false );
	self turret::enable( 2, false );
}

function disable_turrets()
{
	//self turret::disable( 0 );
	self turret::disable( 1 );
	self turret::disable( 2 );
}

function state_combat_enter( params )
{
	ratio = 1.0;
	accel = self GetDefaultAcceleration();
	self SetSpeed( ratio * self.settings.defaultmovespeed, ratio * accel, ratio * accel );
	self thread hunter_blink_lights();

	self hunter_lockon_fx();

	self enable_turrets();
}

function state_combat_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	if ( !isdefined( self.enemy ) )
	{
		self vehicle_ai::set_state( "unaware" );
	}

	self thread Movement_Thread_StayInDistance();
	self thread Attack_Thread_MainTurret();
	self thread Attack_Thread_rocket();

	while ( 1 )
	{
		self waittill( "no_enemy" );
		self vehicle_ai::set_state( "unaware" );
	}
}

function state_combat_exit( params )
{
	self notify( "end_attack_thread" );
	self notify( "end_movement_thread" );
	self ClearTurretTarget();
}
// ----------------------------------------------

// ----------------------------------------------
// State: strafe
// ----------------------------------------------
function state_strafe_enter( params )
{
	ratio = 2.0;
	accel = ratio * self GetDefaultAcceleration();
	speed = ratio * self.settings.defaultmovespeed;
	strafe_speed_attribute = ai::get_behavior_attribute("strafe_speed");
	if ( strafe_speed_attribute > 0 )
	{
		speed = strafe_speed_attribute;
	}
	self SetSpeed( speed , accel, accel );
}

function state_strafe_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	self ClearVehGoalPos();

	distanceToTarget = 0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax );

	target = self.origin + AnglesToForward( self.angles ) * distanceToTarget;
	if ( isdefined( self.enemy ) )
	{
		distanceToTarget = Distance( self.origin, self.enemy.origin );
	}
	
	distanceThreshold = 500 + distanceToTarget * 0.08;
	strafe_distance_attribute = ai::get_behavior_attribute("strafe_distance");
	if ( strafe_distance_attribute > 0 )
	{
		distanceThreshold = strafe_distance_attribute;
	}

	maxSearchRadius = distanceThreshold * 1.5;
	halfHeight = 300;
	outerSpacing = maxSearchRadius * 0.05;
	innerSpacing = outerSpacing * 2;
	
	queryResult = PositionQuery_Source_Navigation( self.origin, 0, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing );
	PositionQuery_Filter_Directness( queryResult, self.origin, target );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	PositionQuery_Filter_InClaimedLocation( queryResult, self );
	self vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult, 200 );

	foreach ( point in queryResult.data )
	{
		distanceToPointSqr = distanceSquared( point.origin, self.origin );
		if( distanceToPointSqr < distanceThreshold * 0.5 )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "distAway" ] = -distanceThreshold;    #/    point.score += -distanceThreshold;;
		}
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "distAway" ] = sqrt( distanceToPointSqr );    #/    point.score += sqrt( distanceToPointSqr );;

		diffToPreferedDirectness = abs( point.directness - 0 );
		directnessScore = MapFloat( 0, 1, 1000, 0, diffToPreferedDirectness );
		if ( diffToPreferedDirectness > 0.1 )
		{
			directnessScore -= 500;
		}
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "directnessRaw" ] = point.directness;    #/    point.score += point.directness;;
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "directness" ] = directnessScore;    #/    point.score += directnessScore;;

		if ( point.directionChange < 0.6 )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "directionChange" ] = -2000;    #/    point.score += -2000;;
		}
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "directionChangeRaw" ] = point.directionChange;    #/    point.score += point.directionChange;;
	}

	vehicle_ai::PositionQuery_PostProcess_SortScore( queryResult );
	self vehicle_ai::PositionQuery_DebugScores( queryResult );
	
	foreach ( point in queryResult.data )
	{
		self.current_pathto_pos = point.origin;

		foundpath = self SetVehGoalPos( self.current_pathto_pos, true, true );

		if ( foundPath )
		{
			msg = self util::waittill_any_timeout( 5, "near_goal", "force_goal", "goal", "enemy_visible" );
			break;
		}
	}

	previous_state = self vehicle_ai::get_previous_state();

	if ( !isdefined( previous_state ) || previous_state == "strafe" )
	{
		previous_state = "combat";
	}

	self vehicle_ai::set_state( previous_state );
}

function state_strafe_exit( params )
{
	vehicle_ai::Cooldown( "strafe_again", 2.0 );
}

// ----------------------------------------------

function GetNextMovePosition_tactical( enemy )
{
	if( self.goalforced )
	{
		return self.goalpos;
	}
	
	selfDistToEnemy = Distance2D( self.origin, enemy.origin );

	// distance based multipliers
	goodDist = 0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax );

	tooCloseDist = 0.8 * goodDist;
	closeDist = 1.2 * goodDist;
	farDist = 3 * goodDist;

	queryMultiplier = MapFloat( closeDist, farDist, 1, 3, selfDistToEnemy );

	preferedDistAwayFromOrigin = 150;

	maxSearchRadius = 1000 * queryMultiplier;
	halfHeight = 300 * queryMultiplier;
	innerSpacing = 80 * queryMultiplier;
	outerSpacing = 80 * queryMultiplier;
	
	queryResult = PositionQuery_Source_Navigation( self.origin, 0, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	PositionQuery_Filter_InClaimedLocation( queryResult, self );
	PositionQuery_Filter_Sight( queryResult, enemy.origin, self GetEye() - self.origin, self, 0, enemy );
	self vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult, 200 );
	self vehicle_ai::PositionQuery_Filter_EngagementDist( queryResult, enemy, self.settings.engagementDistMin, self.settings.engagementDistMax );
	self vehicle_ai::PositionQuery_Filter_Random( queryResult, 0, 30 );

	goalHeight = enemy.origin[2] + 0.5 * ( self.settings.engagementHeightMin + self.settings.engagementHeightMax );
			
	foreach ( point in queryResult.data )
	{
		if ( !point.visibility )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "no visibility" ] = -600;    #/    point.score += -600;;
		}

		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "engagementDist" ] = -point.distAwayFromEngagementArea;    #/    point.score += -point.distAwayFromEngagementArea;;
		
		// distance from origin
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "distToOrigin" ] = MapFloat( 0, preferedDistAwayFromOrigin, 0, 600, point.distToOrigin2D );    #/    point.score += MapFloat( 0, preferedDistAwayFromOrigin, 0, 600, point.distToOrigin2D );;
		
		if( point.inClaimedLocation )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "inClaimedLocation" ] = -500;    #/    point.score += -500;;
		}
		
		// height
		preferedHeightRange = 75;
		distFromPreferredHeight = abs( point.origin[2] - goalHeight );
		if ( distFromPreferredHeight > preferedHeightRange )
		{
			heightScore = -MapFloat( preferedHeightRange, 5000, 0, 9000, distFromPreferredHeight );
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "height" ] = heightScore;    #/    point.score += heightScore;;
		}
	}
	self vehicle_ai::PositionQuery_DebugScores( queryResult );

	vehicle_ai::PositionQuery_PostProcess_SortScore( queryResult );
	
	if( queryResult.data.size )
	{
		return queryResult.data[0].origin;
	}
	
	return self.origin;
}

function Movement_Thread_StayInDistance()
{
	self endon( "death" );
	self notify( "end_movement_thread" );
	self endon( "end_movement_thread" );

	maxGoalTimeout = 10;
	
	while ( true )
	{
		enemy = self.enemy;
		if ( !isdefined( enemy ) )
		{
			wait 1;
			continue;
		}

		self.current_pathto_pos = GetNextMovePosition_tactical( enemy );

		distanceToGoalSq = DistanceSquared( self.current_pathto_pos, self.origin );
		if ( distanceToGoalSq > ( (0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax )) * (0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax )) ) )
		{
			self SetSpeed( self.settings.defaultMoveSpeed * 2 );
		}
		else
		{
			self SetSpeed( self.settings.defaultMoveSpeed );
		}
				
		foundpath = self SetVehGoalPos( self.current_pathto_pos, true, true );
		/#
		if ( foundpath && ( isdefined( GetDvarInt("hkai_debugPositionQuery") ) && GetDvarInt("hkai_debugPositionQuery") ) )
		{
			recordLine( self.origin, self.current_pathto_pos, (0.3,1,0) );
			recordLine( self.origin, enemy.origin, (1,0,0.4) );
		}
		#/

		if ( foundPath )
		{
			msg = self util::waittill_any_timeout( maxGoalTimeout, "near_goal", "force_goal", "goal", "enemy_visible" );

			if ( msg == "enemy_visible" )
			{
				self ClearVehGoalPos();
				wait 1;
			}
			
			wait 0.25;
		}
		else
		{
			wait 1;
		}

		enemy = self.enemy;
		if ( !isdefined( enemy ) )
		{
			wait 1;
			continue;
		}
		
		goalHeight = enemy.origin[2] + 0.5 * ( self.settings.engagementHeightMin + self.settings.engagementHeightMax );
		distFromPreferredHeight = abs( self.origin[2] - goalHeight );
		
		farDist = self.settings.engagementDistMax;
		nearDist = self.settings.engagementDistMin;
		
		selfDistToEnemy = Distance2D( self.origin, enemy.origin );
		
		if ( self VehCanSee( enemy ) && selfDistToEnemy < farDist && selfDistToEnemy > nearDist && distFromPreferredHeight < 230 )
		{
			msg = self util::waittill_any_timeout( RandomFloatRange( 2, 4 ), "enemy_not_visible" );
			if ( msg == "enemy_not_visible" )
			{
				msg = self util::waittill_any_timeout( 1.0, "enemy_visible" );
				if ( msg != "timeout" )
				{
					wait 1;
				}
			}
		}
	}
}

function Delay_Target_ToEnemy_Thread( point, enemy, timeToHit )
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "end_attack_thread" );
	self endon( "faketarget_stop_moving" );
	enemy endon( "death" );

	if ( !isdefined( self.fakeTargetEnt ) )
	{
		self.fakeTargetEnt = Spawn( "script_origin", point );
	}
	
	self.fakeTargetEnt Unlink();

	self.fakeTargetEnt.origin = point;
	self SetTurretTargetEnt( self.fakeTargetEnt );
	self waittill( "turret_on_target" );

	timeStart = GetTime();
	offset = (0, 0, 0);
	if( IsSentient( enemy ) )
	{
		offset = enemy GetEye() - enemy.origin;
	}

	while( GetTime() < timeStart + timeToHit * 1000 )
	{
		self.fakeTargetEnt.origin = LerpVector( point, enemy.origin + offset, ( GetTime() - timeStart ) / ( timeToHit * 1000 ) );
		///#debugstar( self.fakeTargetEnt.origin, 1000, (0,1,0) ); #/
		{wait(.05);};
	}

	self.fakeTargetEnt.origin = enemy.origin + offset;
	{wait(.05);};
	self.fakeTargetEnt LinkTo( enemy );
}

function Attack_Thread_MainTurret()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "end_attack_thread" );
	
	while( 1 )
	{
		enemy = self.enemy;
		if( isdefined( enemy ) )
		{
			self SetLookAtEnt( enemy );
			
			if( self VehCanSee( enemy ) )
			{
				vectorFromEnemy = VectorNormalize( ( (self.origin - enemy.origin)[0], (self.origin - enemy.origin)[1], 0 ) );

				self thread Delay_Target_ToEnemy_Thread( enemy.origin + vectorFromEnemy * 200, enemy, 1.0 );

				self waittill( "turret_on_target" );
				self vehicle_ai::fire_for_time( 1.5 + RandomFloat( 0.5 ) );
				
				if( isdefined( enemy ) && IsAI( enemy ) )
				{
					wait( 2.5 + RandomFloat( 0.5 ) );
				}
				else
				{
					wait( 2.0 + RandomFloat( 0.4 ) );
				}
			}
			else
			{
				wait 0.4;
			}
		}
		else
		{
			self ClearTurretTarget();
			self ClearLookAtEnt();
			wait 0.4;
		}
	}
}

function Attack_Thread_rocket()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "end_attack_thread" );

	while( true )
	{
		enemy = self.enemy;
		if ( !isdefined( enemy ) )
		{
			wait 1;
			continue;
		}

		if ( isdefined( enemy ) && self VehCanSee( enemy ) && vehicle_ai::IsCooldownReady( "rocket_launcher" ) )
		{
			self notify( "end_movement_thread" );
			self ClearVehGoalPos();
			self SetVehGoalPos( self.origin, true, false );

			target = enemy.origin;
			self SetLookAtEnt( enemy );
			self hunter_lockon_fx();
			wait 1.0;

			randomRange = 20;
			offset = [];
			for ( i = 0; i < 2; i++ )
			{
				offset[i] = ( RandomFloatRange( -randomRange, randomRange ), RandomFloatRange( -randomRange, randomRange ), RandomFloatRange( -randomRange, randomRange ) );
			}

			self hunter_fire_one_missile( 0, target, offset[0], true, 0.8 );
			wait 0.25;
			self hunter_fire_one_missile( 1, target, offset[1] );

			wait 1;
			vehicle_ai::Cooldown( "rocket_launcher", 4 );
			self thread Movement_Thread_StayInDistance();
		}
		wait 0.5;
	}
}
// ----------------------------------------------

// best target of side turrets: closest, can hit, and not target of main turret
function side_turret_get_best_target( a_potential_targets, n_index )
{
	if ( self.ignoreall === true )
	{
		return undefined;
	}

	main_turret_target = self.enemy;
	shouldYield = true && isdefined( main_turret_target );

	e_best_target = undefined;

	while ( !isdefined( e_best_target ) && ( a_potential_targets.size > 0 ) )
	{
		e_closest_target = ArrayGetClosest( self.origin, a_potential_targets );

		if ( self turret::can_hit_target( e_closest_target, n_index ) && 
			( !shouldYield || main_turret_target != e_closest_target ) )
		{
			e_best_target = e_closest_target;
		}
		else
		{
			ArrayRemoveValue( a_potential_targets, e_closest_target );
		}
	}

	return e_best_target;
}

// ----------------------------------------------
// missile
// ----------------------------------------------
function hunter_fire_one_missile( launcher_index, target, offset, blinkLights, waittimeAfterBlinkLights )
{
	self endon( "death" );

	if ( ( isdefined( blinkLights ) && blinkLights ) )
	{
		self vehicle_ai::blink_lights_for_time( 1 );

		if ( isdefined( waittimeAfterBlinkLights ) && waittimeAfterBlinkLights > 0 )
		{
			wait waittimeAfterBlinkLights;
		}
	}

	if ( !isdefined( offset ) )
	{
		offset = ( 0, 0, 0 );
	}

	spawnTag = self.missileTags[ launcher_index ];
	origin = self GetTagOrigin( spawnTag );
	angles = self GetTagAngles( spawnTag );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );

	if ( isdefined( spawnTag ) && isdefined( target ) )
	{
		weapon = GetWeapon( "hunter_rocket_turret" );
		
		//only do the full MagicBullet parameter list if target is a real entity, and not a script_struct
		if ( IsEntity( target ) )
		{
			missile = MagicBullet( weapon, origin, target.origin, self, target, offset );
			//missile thread remote_missile_life();
		}
		else if ( IsVec( target ) )
		{
			missile = MagicBullet( weapon, origin, target, self );
		}
		else
		{
			missile = MagicBullet( weapon, origin, target.origin, self );
		}
	}
}

function remote_missile_life()
{
	self endon( "death" );

	hostmigration::waitLongDurationWithHostMigrationPause( 10 );

	playFX( level.remote_mortar_fx["missileExplode"], self.origin );
	self playlocalsound( "mpl_ks_reaper_explosion" );
	self delete();
}

function hunter_lockon_fx()
{
	self thread vehicle_ai::blink_lights_for_time( 1 );
	self playsound( "veh_hunter_alarm_target" );
}

//self == hunter
function getEnemyArray( include_ai, include_player )
{
	enemyArray = [];

	enemy_team = "allies";//util::getOtherTeam( self.team );

	if ( ( isdefined( include_ai ) && include_ai ) )
	{
		aiArray = GetAITeamArray( enemy_team );
		enemyArray = ArrayCombine( enemyArray, aiArray, false, false );
	}

	if ( ( isdefined( include_player ) && include_player ) )
	{
		playerArray = GetPlayers( enemy_team );
		enemyArray = ArrayCombine( enemyArray, playerArray, false, false );
	}

	return enemyArray;
}

// ----------------------------------------------
// scanner
// ----------------------------------------------

//self == hunter
function is_point_in_view( point, do_trace )
{
	if ( !isdefined( point ) )
	{
		return false;
	}

	scanner = self.frontScanner;
	vector_to_point = point - scanner.origin;
	in_view = ( LengthSquared( vector_to_point ) <= ( (10000) * (10000) ) );

	if ( in_view )
	{
		in_view = util::within_fov( scanner.origin, scanner.angles, point, Cos( 190 ) );
	}

	if ( in_view && ( isdefined( do_trace ) && do_trace ) && isdefined( self.enemy ) )
	{
		in_view = SightTracePassed( scanner.origin, point, false, self.enemy );
	}

	return in_view;
}

//self == hunter
function is_valid_target( target, do_trace )
{
	target_is_valid = true;

	// check script properties
	if ( ( isdefined( target.ignoreme ) && target.ignoreme ) || ( target.health <= 0 ) )
	{
		target_is_valid = false;
	}
	// check sentient properties
	else if ( IsSentient( target ) && ( ( target IsNoTarget() ) || ( target ai::is_dead_sentient() ) ) )
	{
		target_is_valid = false;
	}
	// check fov
	else if ( isdefined( target.origin ) && !is_point_in_view( target.origin, do_trace ) )
	{
		target_is_valid = false;
	}

	return target_is_valid;
}

//self == hunter
function get_enemies_in_view( do_trace )
{
	validEnemyArray = [];
	enemyArray = getEnemyArray( true, true );

	foreach( enemy in enemyArray )
	{
		if ( is_valid_target( enemy, do_trace ) )
		{
			if ( !isdefined( validEnemyArray ) ) validEnemyArray = []; else if ( !IsArray( validEnemyArray ) ) validEnemyArray = array( validEnemyArray ); validEnemyArray[validEnemyArray.size]=enemy;;
		}
	}

	return validEnemyArray;
}

// self == hunter
function hunter_scanner_init()
{
	self.frontScanner = Spawn( "script_model", self GetTagOrigin( "tag_gunner_flash3" ) );
	self.frontScanner SetModel( "tag_origin" );

	self.frontScanner.angles = self GetTagAngles( "tag_gunner_flash3" );
	self.frontScanner LinkTo( self, "tag_gunner_flash3" );

	self.frontScanner.owner = self;
	self.frontScanner.hasTargetEnt = false;

	self.frontScanner.sndScanningEnt = spawn( "script_origin", self.frontScanner.origin + anglesToForward( self.angles ) * 1000 );
	self.frontScanner.sndScanningEnt linkto( self.frontScanner );

	wait 0.25;

	//self.frontScanner thread hunter_scanner_lookTarget( self );

	if ( false )
	{
		PlayFxOnTag( self.settings.spotlightfx, self.frontScanner, "tag_origin" );
	}
}

// self == hunter
function hunter_scanner_SetTargetEntity( targetEnt, offset )
{
	if ( !isdefined( offset ) )
	{
		offset = ( 0, 0, 0 );
	}

	if( IsDefined( targetEnt ) )
	{
		self.frontScanner.targetEnt = targetEnt;
		self.frontScanner.hasTargetEnt = true;
		self SetGunnerTargetEnt( self.frontScanner.targetEnt, offset, 2 );
	}
}

// self == hunter
function hunter_scanner_ClearLookTarget()
{
	self.frontScanner.hasTargetEnt = false;
	self ClearGunnerTarget( 2 );
}

// self == hunter
function hunter_scanner_SetTargetPosition( targetPos )
{
	if( IsDefined( targetPos ) )
	{
		self.frontScanner.targetPos = targetPos;
		self SetGunnerTargetVec( self.frontScanner.targetPos, 2 );
	}
}

function hunter_frontScanning()
{
	self endon( "death_shut_off" );
	self endon( "crash_done" );
	self endon( "death" );

	hunter_scanner_init();

	offsetFactorPitch = 0;
	offsetFactorYaw = 0;

	// use 2 different irrational numbers here to help avoiding repetitive patterns
	pitchStep = 1 * 2.23606797749978969640; // irrational number sqrt(5)
	yawStep = 1 * 3.14159265358979323846; // irrational number PI

	pitchRange = 20;
	yawRange = 45;

	scannerDirection = undefined;

	while ( 1 )
	{
		scannerOrigin = self.frontScanner.origin;

		if ( ( isdefined( self.inpain ) && self.inpain ) )
		{
			wait 0.3;
			offset = ( 50, 0, 0 ) + ( math::randomSign() * RandomFloatRange( 1, 2 ) * pitchRange, math::randomSign() * RandomFloatRange( 1, 2 ) * yawRange, 0 );
			scannerDirection = anglesToForward( self.angles + offset );
		}
		else if ( !IsDefined( self.enemy ) )
		{
			if ( false )
			{
				self.frontScanner.sndScanningEnt playloopsound( "veh_hunter_scanner_loop", 1 );
			}

			offsetFactorPitch = offsetFactorPitch + pitchStep;
			offsetFactorYaw = offsetFactorYaw + yawStep;

			offset = ( 50, 0, 0 ) + ( Sin( offsetFactorPitch ) * pitchRange, Cos( offsetFactorYaw ) * yawRange, 0 );
			scannerDirection = anglesToForward( self.angles + offset );

			enemies = get_enemies_in_view( true );

			if ( enemies.size > 0 )
			{
				closest_enemy = ArrayGetClosest( self.origin, enemies );
				
				self.favoriteEnemy = closest_enemy;
				/# line( scannerOrigin, closest_enemy.origin, ( 0, 1, 0 ), 1, 3 ); #/
			}
		}
		else
		{
			if ( self is_point_in_view( self.enemy.origin, true ) )
			{
				self notify ( "hunter_lockOnTargetInSight" );
			}
			else
			{
				self notify ( "hunter_lockOnTargetOutSight" );
			}

			scannerDirection = VectorNormalize( self.enemy.origin - scannerOrigin );

			if ( false )
			{
				self.frontScanner.sndScanningEnt stoploopsound( 1 );
			}
		}

		targetLocation = scannerOrigin + scannerDirection * 1000; // any big value will do
		self hunter_scanner_SetTargetPosition( targetLocation );

		/# line( scannerOrigin, self.frontScanner.targetPos, ( 0, 1, 0 ), 1, 1000 ); #/
		wait 0.1;
	}
}

function hunter_exit_vehicle()
{
	self waittill( "exit_vehicle", player );

	player.ignoreme = false;
	player DisableInvulnerability();

	self SetHeliHeightLock( false );
	self EnableAimAssist();
	self SetVehicleType( self.original_vehicle_type );
	self SetViewModelRenderFlag( false );
	self.attachedpath = undefined;
	self SetGoal( self.origin, false, 4096, 512 );
}

function hunter_scripted( params )
{
	// do nothing state
	params.driver = self GetSeatOccupant( 0 );
	if ( isdefined( params.driver ) )
	{
		self DisableAimAssist();

		self thread vehicle_death::vehicle_damage_filter( "firestorm_turret" );
		//self thread hunter_set_team( driver.team );
		params.driver.ignoreme = true;
		params.driver EnableInvulnerability();

		if ( isdefined( self.vehicle_weapon_override ) )
		{
			self SetVehWeapon( self.vehicle_weapon_override );
		}

		self SetViewModelRenderFlag( true );
		self thread hunter_exit_vehicle();
		//self thread hunter_update_rumble();
		self thread hunter_collision_player();
		//self thread hunter_self_destruct();
		self thread player_fire_update_side_turret_1();
		self thread player_fire_update_side_turret_2();
		self thread player_fire_update_rocket();
	}

	if ( isdefined( self.goal_node ) && isdefined( self.goal_node.hunter_claimed ) )
	{
		self.goal_node.hunter_claimed = undefined;
	}

	self ClearTargetEntity();
	self ClearVehGoalPos();
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
	self ClearLookAtEnt();
	self ResumeSpeed();
}

function player_fire_update_side_turret_1()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	weapon = self SeatGetWeapon( 1 );
	fireTime = weapon.fireTime;
	
	while( 1 )
	{
		self SetGunnerTargetVec( self GetTurretTargetVec( 0 ), 0 );
		if( self IsDriverFiring( ) )
		{
			self FireWeapon( 1 );
		}
		wait fireTime;
	}
}

function player_fire_update_side_turret_2()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	weapon = self SeatGetWeapon( 2 );
	fireTime = weapon.fireTime;
	
	while( 1 )
	{
		self SetGunnerTargetVec( self GetTurretTargetVec( 0 ), 1 );
		if( self IsDriverFiring( ) )
		{
			self FireWeapon( 2 );
		}
		wait fireTime;
	}
}

function player_fire_update_rocket()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	weapon = GetWeapon( "hunter_rocket_turret_player" );
	fireTime = weapon.fireTime;
	driver = self GetSeatOccupant( 0 );
	
	while( 1 )
	{

		if( driver ButtonPressed( "BUTTON_A" ) )
		{
			spawnTag0 = self.missileTags[ 0 ];
			spawnTag1 = self.missileTags[ 1 ];
			origin0 = self GetTagOrigin( spawnTag0 );
			origin1 = self GetTagOrigin( spawnTag1 );
			target = self GetTurretTargetVec( 0 );
			
			MagicBullet( weapon, origin0, target );
			MagicBullet( weapon, origin1, target );
			
			wait fireTime;
		}
		
		Wait 0.05;
	}
}

function hunter_collision_player()
{
	self endon( "change_state" );
	self endon( "crash_done" );
	self endon( "death" );

	while ( 1 )
	{
		self waittill( "veh_collision", velocity, normal );
		driver = self GetSeatOccupant( 0 );
		if ( isdefined( driver ) && LengthSquared( velocity ) > 70 * 70 )
		{
			Earthquake( 0.25, 0.25, driver.origin, 50 );
			driver PlayRumbleOnEntity( "damage_heavy" );
		}
	}
}

function hunter_blink_lights()
{
	self endon( "death" );

	self vehicle::lights_off();
	wait 0.1;
	self vehicle::lights_on();
}

// Lots of gross hardcoded values! :(
function hunter_update_rumble()
{
	self endon( "death" );
	self endon( "exit_vehicle" );

	while ( 1 )
	{
		vr = Abs( self GetSpeed() / self GetMaxSpeed() );

		if ( vr < 0.1 )
		{
			level.player PlayRumbleOnEntity( "hunter_fly" );
			wait 0.35;
		}
		else
		{
			time = RandomFloatRange( 0.1, 0.2 );
			Earthquake( RandomFloatRange( 0.1, 0.15 ), time, self.origin, 200 );
			level.player PlayRumbleOnEntity( "hunter_fly" );
			wait time;
		}
	}
}

function hunter_self_destruct()
{
	self endon( "death" );
	self endon( "exit_vehicle" );

	const max_self_destruct_time = 5;

	self_destruct = false;
	self_destruct_time = 0;

	while ( 1 )
	{
		if ( !self_destruct )
		{
			if ( level.player MeleeButtonPressed() )
			{
				self_destruct = true;
				self_destruct_time = max_self_destruct_time;
			}

			{wait(.05);};
			continue;
		}
		else
		{
			IPrintLnBold( self_destruct_time );

			wait 1;

			self_destruct_time -= 1;
			if ( self_destruct_time == 0 )
			{
				driver = self GetSeatOccupant( 0 );
				if ( isdefined( driver ) )
				{
					driver DisableInvulnerability();
				}

				Earthquake( 3, 1, self.origin, 256 );
				RadiusDamage( self.origin, 1000, 15000, 15000, level.player, "MOD_EXPLOSIVE" );
				self DoDamage( self.health + 1000, self.origin );
			}

			continue;
		}
	}
}

function hunter_level_out_for_landing()
{
	self endon( "death" );
	self endon( "emped" );
	self endon( "landed" );

	while ( isdefined( self.emped ) )
	{
		velocity = self.velocity;	// setting the angles clears the velocity so we save it off and set it back
		self.angles = ( self.angles[0] * 0.85, self.angles[1], self.angles[2] * 0.85 );
		ang_vel = self GetAngularVelocity() * 0.85;
		self SetAngularVelocity( ang_vel );
		self SetVehVelocity( velocity );
		{wait(.05);};
	}
}

function hunter_emped( params )
{
	self endon( "death" );
	self endon( "emped" );

	self.emped = true;

	wait RandomFloatRange( 4, 7 );

	self vehicle_ai::evaluate_connections();

/*
	PlaySoundAtPosition( "veh_qrdrone_emp_down", self.origin );

	if ( !isdefined( self.stun_fx ) )
	{
		self.stun_fx = Spawn( "script_model", self.origin );
		self.stun_fx SetModel( "tag_origin" );
		self.stun_fx LinkTo( self, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
		PlayFXOnTag( level._effect[ "hunter_stun" ], self.stun_fx, "tag_origin" );
	}

	wait RandomFloatRange( 4, 7 );

	self.stun_fx delete();

	self playsound ( "veh_qrdrone_boot_qr" );
*/
}

function hunter_temp_bullet_shield( invulnerable_time )
{
	self notify( "bullet_shield" );
	self endon( "bullet_shield" );

	self.bullet_shield = true;

	wait invulnerable_time;

	if ( isdefined( self ) )
	{
		self.bullet_shield = undefined;
		wait 3;
		if ( isdefined( self ) && self.health < 40 )
		{
			self.health = 40;
		}
	}
}

// ----------------------------------------------
// pain/hit reaction
// ----------------------------------------------
function hunter_pain_for_time( time, velocityStablizeParam, rotationStablizeParam, restoreLookPoint )
{
	self endon( "death" );
	self.painStartTime = GetTime();

	if ( !( isdefined( self.inpain ) && self.inpain ) )
	{
		self.inpain = true;

		while ( GetTime() < self.painStartTime + time * 1000 )
		{
			self SetVehVelocity( self.velocity * velocityStablizeParam );
			self SetAngularVelocity( self GetAngularVelocity() * rotationStablizeParam );
			wait 0.1;
		}

		if ( isdefined( restoreLookPoint ) )
		{
			restoreLookEnt = Spawn( "script_model", restoreLookPoint );
			restoreLookEnt SetModel( "tag_origin" );

			self ClearLookAtEnt();
			self SetLookAtEnt( restoreLookEnt );
			self setTurretTargetEnt( restoreLookEnt );
			wait 1.5;

			self ClearLookAtEnt();
			self ClearTurretTarget();
			restoreLookEnt delete();
		}

		self.inpain = false;
	}
}

function hunter_pain_small( eAttacker, damageType, hitPoint, hitDirection, hitLocationInfo, partName )
{
	if( !isdefined( hitPoint ) || !isdefined( hitDirection ) )
	{
		return;
	}
	
	self SetVehVelocity( self.velocity + VectorNormalize( hitDirection ) * 20 );

	if ( !( isdefined( self.inpain ) && self.inpain ) )
	{
		vecRight = anglesToRight( self.angles );
		sign = math::sign( vectorDot( vecRight, hitDirection ) );
		yaw_vel =  sign * RandomFloatRange( 100, 140 );

		ang_vel = self GetAngularVelocity();
		ang_vel += ( RandomFloatRange( -120, -100 ), yaw_vel, RandomFloatRange( -100, 100 ) );
		self SetAngularVelocity( ang_vel );

		self thread hunter_pain_for_time( 1.5, 1.0, 0.8 );
	}

	self vehicle_ai::set_state( "strafe" );
}

function hunter_pain_weakspot( eAttacker, damageType, hitPoint, hitDirection, hitLocationInfo, partName )
{
	hitWeakSpotID = -1;

	for ( i = 0; i < self.weakSpotTags.size && hitWeakSpotID < 0; i++ )
	{
		if ( partName == self.weakSpotTags[i] )
		{
			hitWeakSpotID = i;
			break;
		}
	}

	if ( hitWeakSpotID >= 0 )
	{
		PlayFXOnTag( self.settings.weakSpotFx, self, self.weakSpotTags[ hitWeakSpotID ] );

		self SetVehVelocity( self.velocity + VectorNormalize( hitDirection ) * 20 );

		if ( !( isdefined( self.inpain ) && self.inpain ) )
		{
			vecRight = anglesToRight( self.angles );
			sign = math::sign( vectorDot( vecRight, hitDirection ) );
			yaw_vel =  sign * RandomFloatRange( 100, 140 );

			ang_vel = self GetAngularVelocity();
			ang_vel += ( RandomFloatRange( -120, -100 ), yaw_vel, RandomFloatRange( -100, 100 ) );
			self SetAngularVelocity( ang_vel );

			self thread hunter_pain_for_time( 1.5, 1.0, 0.8 );
		}

		self vehicle_ai::set_state( "strafe" );
	}

	return hitWeakSpotID >= 0;
}

function hunter_pain_explosive_weakspot ( eAttacker, damageType, hitPoint, hitDirection, hitLocationInfo, partName )
{
	hitWeakSpotID = -1;

	if ( damageType == "MOD_EXPLOSIVE" || damageType == "MOD_GRENADE_SPLASH" || damageType == "MOD_PROJECTILE_SPLASH" || damageType == "MOD_PROJECTILE" )
	{
		for ( i = 0; i < self.explosiveWeakSpotTags.size && hitWeakSpotID < 0; i++ )
		{
			if ( partName == self.explosiveWeakSpotTags[i] )
			{
				hitWeakSpotID = i;
				break;
			}
		}

		if ( hitWeakSpotID >= 0 )
		{
			self SetVehVelocity( self.velocity + VectorNormalize( hitDirection ) * 150 );

			ang_vel = self GetAngularVelocity();
			ang_vel += ( RandomFloatRange( -200, -120 ), math::randomSign() * RandomFloatRange( 280, 320 ), RandomFloatRange( -250, 250 ) );
			self SetAngularVelocity( ang_vel );

			self ClearLookAtEnt();

			self thread hunter_pain_for_time( 1.8, 1.0, 0.8, eAttacker.origin );
		}

		self vehicle_ai::set_state( "strafe" );
	}

	return hitWeakSpotID >= 0;
}

function HunterCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	driver = self GetSeatOccupant( 0 );

	// no friendly fire
	if ( isdefined( eAttacker ) && eAttacker.team == self.team )
	{
		return 0;
	}

	hunter_pain_weakspot( eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName );

	hunter_pain_explosive_weakspot( eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName );

	iDamage = int( iDamage );

	if ( isdefined( driver ) )
	{
		if ( sMeansOfDeath == "MOD_BULLET" )
		{
			if ( isdefined( self.bullet_shield ) )
			{
				iDamage = 3;
			}
		}

		if ( !isdefined( self.bullet_shield ) )
		{
			// Try not to let the play die suddenly
			self thread hunter_temp_bullet_shield( 0.35 );
		}

		// Lets get some hit indicators
		driver FinishPlayerDamage( eInflictor, eAttacker, 1, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, "none", vDamageOrigin, psOffsetTime, 0, vSurfaceNormal );
	}

	damageLevelChanged = vehicle::update_damage_fx_level( self.health, iDamage, self.healthdefault );
	
	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );

	if( damageLevelChanged && iDamage < self.health )
	{
		hunter_pain_small( eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName );
	}

	return iDamage;
}
