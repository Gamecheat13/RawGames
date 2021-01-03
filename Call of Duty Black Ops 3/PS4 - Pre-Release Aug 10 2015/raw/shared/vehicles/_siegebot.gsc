// ----------------------------------------------------------------------------
// #using
// ----------------------------------------------------------------------------
#using scripts\codescripts\struct;

#using scripts\shared\gameskill_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\blackboard_vehicle;

#using scripts\shared\turret_shared;
#using scripts\shared\weapons\_spike_charge_siegebot;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
       
                                                                                                             	     	                                                                                                                                                                

                                                                  	                             	  	                                      




#namespace siegebot;

function autoexec __init__sytem__() {     system::register("siegebot",&__init__,undefined,undefined);    }

#using_animtree( "generic" );

function __init__()
{	
	vehicle::add_main_callback( "siegebot", &siegebot_initialize );
}

function siegebot_initialize()
{
	self useanimtree( #animtree );
	
	blackboard::CreateBlackBoardForEntity( self );
	self Blackboard::RegisterVehicleBlackBoardAttributes();

	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();
	
	Target_Set( self, ( 0, 0, 84 ) );

	self EnableAimAssist();
	self SetNearGoalNotifyDist( 40 );
	
	self.fovcosine = 0.5; // +/-60 degrees = 120 fov
	self.fovcosinebusy = 0.5;
	self.maxsightdistsqrd = ( (10000) * (10000) );

	assert( isdefined( self.scriptbundlesettings ) );

	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	self.goalRadius = 9999999;
	self.goalHeight = 5000;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );
	
	self.overrideVehicleDamage = &siegebot_callback_damage;
	
	self siegebot_update_difficulty();
	
	self SetGunnerTurretOnTargetRange( 0, self.settings.gunner_turret_on_target_range );
	
	self ASMRequestSubstate( "locomotion@movement" );
	
	if( self.vehicletype === "spawner_enemy_boss_siegebot_zombietron" )
	{
		self ASMSetAnimationRate( 0.5 );
		self HidePart( "tag_turret_canopy_animate" );
		self HidePart( "tag_turret_panel_01_d0" );
		self HidePart( "tag_turret_panel_02_d0" );
		self HidePart( "tag_turret_panel_03_d0" );
		self HidePart( "tag_turret_panel_04_d0" );
		self HidePart( "tag_turret_panel_05_d0" );
	}
	else if( self.vehicletype == "zombietron_veh_siegebot" )
	{
		self ASMSetAnimationRate( 1.429 );
	}

	self initJumpStruct();

	//disable some cybercom abilities
	if( IsDefined( level.vehicle_initializer_cb ) )
	{
    	[[level.vehicle_initializer_cb]]( self );
	}
	
	defaultRole();
}


function siegebot_update_difficulty()
{
	value = gameskill::get_general_difficulty_level();
	
	scale_up = mapfloat( 0, 9, 0.8, 2.0, value );
	scale_down = mapfloat( 0, 9, 1.0, 0.5, value );
	
	self.difficulty_scale_up = scale_up;
	self.difficulty_scale_down = scale_down;
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role( "default" );

    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
    self vehicle_ai::get_state_callbacks( "combat" ).exit_func = &state_combat_exit;
    
    self vehicle_ai::get_state_callbacks( "driving" ).update_func = &siegebot_driving;

    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;

    self vehicle_ai::get_state_callbacks( "pain" ).update_func = &pain_update;

	self vehicle_ai::add_state( "jump",
		&state_jump_enter,
		&state_jump_update,
		&state_jump_exit );

	vehicle_ai::add_utility_connection( "combat", "jump", &state_jump_can_enter );
	vehicle_ai::add_utility_connection( "jump", "combat" );

	self vehicle_ai::add_state( "unaware",
		undefined,
		&state_unaware_update,
		undefined );
	// don't use this for now unless we really need it

	vehicle_ai::StartInitialState( "combat" );
}

// ----------------------------------------------
// State: death
// ----------------------------------------------
function state_death_update( params )
{
	self endon( "death" );	
	self endon( "nodeath_thread" );

	self clean_up_spawned();

	self stopMovementAndSetBrake();

	self vehicle::set_damage_fx_level( 0 );
	self playsound("veh_quadtank_sparks");

	if ( self.vehicletype === "spawner_enemy_boss_siegebot_zombietron" )
	{
		self ASMSetAnimationRate( 1.0 );
	}

	self ASMRequestSubstate( "death@stationary" );
	self NotSolid();

	vehicle_ai::waittill_asm_complete( "death@stationary", 10 );

	self vehicle_ai::defaultstate_death_update( params );
}

// ----------------------------------------------
// State: scripted
// ----------------------------------------------
function siegebot_driving( params )
{
	self thread siegebot_player_fireupdate();

	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();	
}

function siegebot_player_fireupdate()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	weapon = self SeatGetWeapon( 2 );
	fireTime = weapon.fireTime;
	driver = self GetSeatOccupant( 0 );
	
	while( 1 )
	{
		self SetGunnerTargetVec( self GetGunnerTargetVec( 0 ), 1 );
		if( driver attackButtonPressed() )
		{
			self FireWeapon( 2 );
			wait fireTime;
		}
		wait 0.05;
	}
}
// State: death ----------------------------------

// ----------------------------------------------
// State: pain
// ----------------------------------------------
function pain_toggle( enabled )
{
	self._enablePain = enabled;
}

function pain_update( params )
{
	self endon( "death" );

	self stopMovementAndSetBrake();
	
	if ( isdefined( self.damagelevel ) && 1 <= self.damagelevel && self.damagelevel <= 4 )
	{
		asmState = "damage_" + self.damageLevel + "@pain";
	}
	else
	{
		asmState = "normal@pain";
	}

	if ( self.vehicletype === "spawner_enemy_boss_siegebot_zombietron" )
	{
		self ASMSetAnimationRate( 1.0 );
	}

	self ASMRequestSubstate( asmState );	
	self vehicle_ai::waittill_asm_complete( asmState, 5 );
	
	self SetBrake( 0 );
	
	self vehicle_ai::evaluate_connections();
}
// State: pain ----------------------------------

// ----------------------------------------------
// State: unaware
// ----------------------------------------------
function state_unaware_update( params )
{
	self endon( "death" );
	self endon( "change_state" );

	self SetTurretTargetRelativeAngles( (0,90,0), 1 );
	self SetTurretTargetRelativeAngles( (0,90,0), 2 );

	self thread Movement_Thread_Unaware();

	while ( true ) 
	{
		self vehicle_ai::evaluate_connections();
		wait 1;
	}
}

function Movement_Thread_Unaware()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "end_movement_thread" );
	self endon( "end_movement_thread" );

	while( true )
	{
		self.current_pathto_pos = self GetNextMovePosition_unaware();

		foundpath = self SetVehGoalPos( self.current_pathto_pos, false, true );
		
		if ( foundPath )
		{
			locomotion_start();
			self thread path_update_interrupt();
			self vehicle_ai::waittill_pathing_done();
			locomotion_stop();
			self notify( "near_goal" );		// kill path_update_interrupt thread
			self CancelAIMove();
			self ClearVehGoalPos();

			Scan();
		}
		else
		{
			wait 1;
		}

		{wait(.05);};
	}
}

function GetNextMovePosition_unaware()
{
	if( self.goalforced )
	{
		return self.goalpos;
	}

	minSearchRadius = 500;
	maxSearchRadius = 1500;
	halfHeight = 400;
	spacing = 80;

	queryResult = PositionQuery_Source_Navigation( self.origin, minSearchRadius, maxSearchRadius, halfHeight, spacing, self, spacing );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );

	forward = AnglesToForward( self.angles );
	foreach ( point in queryResult.data )
	{
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "random" ] = randomFloatRange( 0, 30 );    #/    point.score += randomFloatRange( 0, 30 );;

		pointDirection = VectorNormalize( point.origin - self.origin );
		factor = VectorDot( pointDirection, forward );
		if ( factor > 0.7 )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "directionDiff" ] = 600;    #/    point.score += 600;;
		}
		else if ( factor > 0 )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "directionDiff" ] = 0;    #/    point.score += 0;;
		}
		else if ( factor > -0.5 )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "directionDiff" ] = -600;    #/    point.score += -600;;
		}
		else
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "directionDiff" ] = -1200;    #/    point.score += -1200;;
		}
	}

	vehicle_ai::PositionQuery_PostProcess_SortScore( queryResult );
	self vehicle_ai::PositionQuery_DebugScores( queryResult );

	if( queryResult.data.size == 0 )
		return self.origin;

	return queryResult.data[0].origin;
}

// ----------------------------------------------
// State: jump
// ----------------------------------------------
function clean_up_spawned()
{
	if ( isdefined( self.jump ) )
	{
		self.jump.linkEnt Delete();
	}
}

function initJumpStruct()
{
	if ( isdefined( self.jump ) )
	{
		self Unlink();
		self.jump.linkEnt Delete();
		self.jump Delete();
	}

	self.jump = spawnstruct();
	self.jump.linkEnt = Spawn( "script_origin", self.origin );
	self.jump.in_air = false;
	self.jump.highgrounds = struct::get_array( "balcony_point" );
	self.jump.groundpoints = struct::get_array( "ground_point" );

	//assert( self.jump.highgrounds.size > 0 );
	//assert( self.jump.groundpoints.size > 0 );
}

function state_jump_can_enter( from_state, to_state, connection )
{
	return ( self.vehicletype === "spawner_enemy_boss_siegebot_zombietron" );
}

function state_jump_enter( params )
{
	goal = params.jumpgoal;

	trace = PhysicsTrace( goal + ( 0, 0, 500 ), goal - ( 0, 0, 10000 ), ( -10, -10, -10 ), ( 10, 10, 10 ), self, (1 << 1) );
	if ( false )
	{
	/#debugstar( goal, 60000, (0,1,0) ); #/
	/#debugstar( trace[ "position" ], 60000, (0,1,0) ); #/
	/#line(goal, trace[ "position" ], (0,1,0), 1, false, 60000 ); #/
	}
	if ( trace[ "fraction" ] < 1 )
	{
		goal = trace[ "position" ];
	}

	self.jump.goal = goal;

	params.scaleForward = 40;
	params.gravityForce = (0, 0, -6);
	params.upByHeight = 50;
	params.landingState = "land@jump";

	self pain_toggle( false );

	self stopMovementAndSetBrake();
}

function state_jump_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	goal = self.jump.goal;

	self face_target( goal );

	self.jump.linkEnt.origin = self.origin;
	self.jump.linkEnt.angles = self.angles;

	{wait(.05);};

	self LinkTo( self.jump.linkEnt );

	self.jump.in_air = true;

	if ( false ) 
	{
	/#debugstar( goal, 60000, (0,1,0) ); #/
	/#debugstar( goal + (0,0,100), 60000, (0,1,0) ); #/
	/#line(goal, goal + (0,0,100), (0,1,0), 1, false, 60000 ); #/
	}

	// calculate distance and forces
	totalDistance = Distance2D(goal, self.jump.linkEnt.origin);
	forward = ( ((goal - self.jump.linkEnt.origin) / totalDistance)[0], ((goal - self.jump.linkEnt.origin) / totalDistance)[1], 0 );
	upByDistance = MapFloat( 500, 2000, 46, 52, totalDistance );
	antiGravityByDistance = 0;//MapFloat( 500, 2000, 0, 0.5, totalDistance );

	initVelocityUp = (0,0,1) * ( upByDistance + params.upByHeight );
	initVelocityForward = forward * params.scaleForward * MapFloat( 500, 2000, 0.8, 1, totalDistance );
	velocity = initVelocityUp + initVelocityForward;

	// start jumping
	if ( self.vehicletype === "spawner_enemy_boss_siegebot_zombietron" )
	{
		self ASMSetAnimationRate( 1.0 );
	}

	self ASMRequestSubstate( "inair@jump" );
	self waittill( "engine_startup" );
	self vehicle::impact_fx( self.settings.startupfx1 );
	self waittill( "leave_ground" );
	self vehicle::impact_fx( self.settings.takeofffx1 );

	while( true )
	{
		distanceToGoal = Distance2D(self.jump.linkEnt.origin, goal);

		antiGravityScaleUp = 1.0;//MapFloat( 0, 0.5, 0.6, 0, abs( 0.5 - distanceToGoal / totalDistance ) );
		antiGravityScale = 1.0;//MapFloat( (self.radius * 1.0), (self.radius * 3), 0, 1, distanceToGoal );
		antiGravity = (0,0,0);//antiGravityScale * antiGravityScaleUp * (-params.gravityForce) + (0,0,antiGravityByDistance);
		if ( false ) /#line(self.jump.linkEnt.origin, self.jump.linkEnt.origin + antiGravity, (0,1,0), 1, false, 60000 ); #/

		velocityForwardScale = MapFloat( (self.radius * 1), (self.radius * 4), 0.2, 1, distanceToGoal );
		velocityForward = initVelocityForward * velocityForwardScale;
		if ( false ) /#line(self.jump.linkEnt.origin, self.jump.linkEnt.origin + velocityForward, (0,1,0), 1, false, 60000 ); #/

		oldVerticleSpeed = velocity[2];
		velocity = (0,0, velocity[2]);
		velocity += velocityForward + params.gravityForce + antiGravity;

		if ( oldVerticleSpeed > 0 && velocity[2] < 0 )
		{
			self ASMRequestSubstate( "fall@jump" );
		}

		if ( velocity[2] < 0 && self.jump.linkEnt.origin[2] + velocity[2] < goal[2] )
		{
			break;
		}

		heightThreshold = goal[2] + 110;
		oldHeight = self.jump.linkEnt.origin[2];
		self.jump.linkEnt.origin += velocity;

		if ( self.jump.linkEnt.origin[2] < heightThreshold && ( oldHeight > heightThreshold || ( oldVerticleSpeed > 0 && velocity[2] < 0 ) ) )
		{
			self notify( "start_landing" );
			self ASMRequestSubstate( params.landingState );
		}

		if ( false ) /#debugstar( self.jump.linkEnt.origin, 60000, (1,0,0) ); #/
		{wait(.05);};
	}

	// landed
	self.jump.linkEnt.origin = ( self.jump.linkEnt.origin[0], self.jump.linkEnt.origin[1], 0 ) + ( 0, 0, goal[2] );
	self notify( "land_crush" );

	// don't damage player, but crush player vehicle
	foreach( player in level.players )
	{
		player._takedamage_old = player.takedamage;
		player.takedamage = false;
	}
	self RadiusDamage( self.origin + ( 0,0,15 ), self.radiusdamageradius, self.radiusdamagemax, self.radiusdamagemin, self, "MOD_EXPLOSIVE" );

	foreach( player in level.players )
	{
		player.takedamage = player._takedamage_old;
		player._takedamage_old = undefined;

		if ( Distance2DSquared( self.origin, player.origin ) < ( (200) * (200) ) )
		{
			direction = ( ( player.origin - self.origin )[0], ( player.origin - self.origin )[1], 0 );
			if ( Abs( direction[0] ) < 0.01 && Abs( direction[1] ) < 0.01 )
			{
				direction = ( RandomFloatRange( 1, 2 ), RandomFloatRange( 1, 2 ), 0 );
			}
			direction = VectorNormalize( direction );
			strength = 700;
			player SetVelocity( player GetVelocity() + direction * strength );

			if ( player.health > 80 )
			{
				player DoDamage( player.health - 70, self.origin, self );
			}
		}
	}

	self vehicle::impact_fx( self.settings.landingfx1 );
	self stopMovementAndSetBrake();

	//rumble for landing from jump
	//self clientfield::increment( "sarah_rumble_on_landing" );

	wait 0.3;

	self Unlink();
	
	{wait(.05);};

	self.jump.in_air = false;

	self notify ( "jump_finished" );

	vehicle_ai::Cooldown( "jump", 7 );

	self vehicle_ai::waittill_asm_complete( params.landingState, 3 );

	self vehicle_ai::evaluate_connections();
}

function state_jump_exit( params )
{
}

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function state_combat_update( params )
{
	self endon( "death" );
	self endon( "change_state" );

	self thread Movement_Thread();
	self thread Attack_Thread_machinegun();
}

function state_combat_exit( params )
{
	self ClearTurretTarget();
}

function locomotion_start()
{
	self thread locomotion_thread();
}

function locomotion_stop()
{
	self notify( "kill_locomotion" );
}

function locomotion_thread()
{
	self endon( "change_state" );
	self endon( "death" );
	self notify( "kill_locomotion" );
	self endon( "kill_locomotion" );
	
	if( self.vehicletype === "spawner_enemy_boss_siegebot_zombietron" )
	{
		self ASMSetAnimationRate( 0.5 );
	}

	while( 1 )
	{
		self ASMRequestSubstate( "locomotion@movement" );
		self waittill( "asm_complete", substate );
	}
}

function GetNextMovePosition_tactical()
{
	if( self.goalforced )
	{
		return self.goalpos;
	}

	maxSearchRadius = 800;
	halfHeight = 400;
	innerSpacing = 50;
	outerSpacing = 60;

	queryResult = PositionQuery_Source_Navigation( self.origin, 0, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing );
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );

	if( isdefined( self.enemy ) )
	{
		PositionQuery_Filter_Sight( queryResult, self.enemy.origin, self GetEye() - self.origin, self, 0, self.enemy );
		self vehicle_ai::PositionQuery_Filter_EngagementDist( queryResult, self.enemy, self.settings.engagementDistMin, self.settings.engagementDistMax );
	}

	foreach ( point in queryResult.data )
	{
		/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "random" ] = randomFloatRange( 0, 30 );    #/    point.score += randomFloatRange( 0, 30 );;

		if( point.disttoorigin2d < 120 )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "tooCloseToSelf" ] = (120 - point.disttoorigin2d) * -1.5;    #/    point.score += (120 - point.disttoorigin2d) * -1.5;;
		}

		if( isdefined( self.enemy ) )
		{
			/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "engagementDist" ] = -point.distAwayFromEngagementArea;    #/    point.score += -point.distAwayFromEngagementArea;;

			if ( !point.visibility )
			{
				/#    if ( !isdefined( point._scoreDebug ) )    {     point._scoreDebug = [];    }    point._scoreDebug[ "visibility" ] = -600;    #/    point.score += -600;;
			}
		}
	}

	vehicle_ai::PositionQuery_PostProcess_SortScore( queryResult );
	self vehicle_ai::PositionQuery_DebugScores( queryResult );

	if( queryResult.data.size == 0 )
		return self.origin;

	return queryResult.data[0].origin;
}

function waittill_something_happens_stopped( timeout )
{
	// reset rotate rate just to be safe
	self.turretrotscale = 1 * self.difficulty_scale_up;
	
	// first do my attack move if I can
	action = self Attack_Decision();
	
	wait 0.2;
	
	// respawn mg thread since Attack_Decision killed it
	self thread Attack_Thread_machinegun();
	
	cant_see_count = 0;
	
	// now wait for something to cause me to move
	while( timeout > 0 )
	{
		if( isdefined( self.enemy ) )
		{
			if ( self VehCanSee( self.enemy ) )
			{
				self SetLookAtEnt( self.enemy );
				self SetTurretTargetEnt( self.enemy );
				cant_see_count = 0;
			}
			else
			{
				cant_see_count++;
				if( cant_see_count > 2 )
				{
					return "cantsee";
				}
			}
			
			selfDistToTarget = Distance2D( self.origin, self.enemy.origin );
		
			closeEngagementDist = self.settings.engagementDistMin - 50;
			farEngagementDist = self.settings.engagementDistMax + 50;
		
			if ( selfDistToTarget > farEngagementDist )
			{
				return "toofarfromenemy";
			}
			else if( selfDistToTarget < closeEngagementDist )
			{
				return "tooclosetooenemy";
			}
		}
		
		wait 0.3;
		timeout -= 0.3;
	}
	
	return "timeout";
}

function path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );
	
	canSeeEnemyCount = 0;
	
	old_enemy = self.enemy;
	
	startPath = GetTime(); // assume we just started a new path
	old_origin = self.origin;
	move_dist = 300;

	wait 1.5;
	
	while( 1 )
	{
		self SetSpeed( self.settings.defaultMoveSpeed );
		
		if ( isdefined( self.enemy ) )
		{
			selfDistToTarget = Distance2D( self.origin, self.enemy.origin );
		
			farEngagementDist = self.settings.engagementDistMax + 150;
			closeEngagementDist = self.settings.engagementDistMin - 150;
		
			if( self VehCanSee( self.enemy ) )
			{
				self SetLookAtEnt( self.enemy );	// try to keep the basic orientation towards the enemy
				self SetTurretTargetEnt( self.enemy );
			
				// check the distance so we don't trigger a new path when we are already moving
				if( selfDistToTarget < farEngagementDist && selfDistToTarget > closeEngagementDist )
				{	
					canSeeEnemyCount++;

					// Stop if we can see our enemy	for a bit
					if( canSeeEnemyCount > 3 && ( vehicle_ai::TimeSince( startPath ) > 5 || Distance2DSquared( old_origin, self.origin ) > ( (move_dist) * (move_dist) ) ) )
					{
						self notify( "near_goal" );
					}
				}
				else
				{
					// too far go fast
					self SetSpeed( self.settings.defaultMoveSpeed * 2 );
				}
			}
			else if( (!self VehSeenRecently( self.enemy, 1.5 ) && self VehSeenRecently( self.enemy, 15 )) || selfDistToTarget > farEngagementDist ) // move fast if we just lost sight of our target or we are too far
			{
				self SetSpeed( self.settings.defaultMoveSpeed * 2 );
			}
		}
		else
		{
			canSeeEnemyCount = 0;
		}

		if ( isdefined( self.enemy ) )
		{
			if( !isdefined( old_enemy ) )
			{
				self notify( "near_goal" );		// new enemy
			}
			else if( self.enemy != old_enemy )
			{
				self notify( "near_goal" );		// new enemy
			}

			if( self VehCanSee( self.enemy ) && distance2dSquared( self.origin, self.enemy.origin ) < ( (150) * (150) ) && Distance2DSquared( old_origin, self.enemy.origin ) > ( (151) * (151) ) ) // don't walk pass the player
			{
				self notify( "near_goal" );
			}
		}
		
		wait 0.2;
	}
}

function Movement_Thread()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "end_movement_thread" );
	self endon( "end_movement_thread" );

	while ( 1 )
	{
		//reason = self waittill_something_happens_stopped( RandomFloatRange( 3, 6 ) );
		
		self.current_pathto_pos = self GetNextMovePosition_tactical();

		if( self.vehicletype === "spawner_enemy_boss_siegebot_zombietron" )
		{
			if ( vehicle_ai::IsCooldownReady( "jump" ) )
			{
				params = SpawnStruct();
				params.jumpgoal = self.current_pathto_pos;
				locomotion_start();
				wait 0.5;
				self vehicle_ai::evaluate_connections( undefined, params );
				wait 0.5;
			}
		}

		foundpath = self SetVehGoalPos( self.current_pathto_pos, false, true );
		
		if ( foundPath )
		{
			locomotion_start();
			self thread path_update_interrupt();
			self vehicle_ai::waittill_pathing_done();
			locomotion_stop();
			self notify( "near_goal" );		// kill path_update_interrupt thread
			self CancelAIMove();
			self ClearVehGoalPos();

			if ( isdefined( self.enemy ) && self VehSeenRecently( self.enemy, 2 ) )
			{
				self face_target( self.enemy.origin );
				wait 0.4;
				Attack_Rocket( self.enemy );
			}
			wait 1;
		}
		else
		{
			wait 1;
		}
	}
}

function stopMovementAndSetBrake()
{
	self notify( "end_movement_thread" );
	self notify( "near_goal" );
	self CancelAIMove();
	self ClearVehGoalPos();	
	self ClearTurretTarget();
	self ClearLookAtEnt();
	self SetBrake( 1 );
}

function face_target( position, targetAngleDiff )
{
	if ( !isdefined( targetAngleDiff ) )
	{
		targetAngleDiff = 30;
	}

	v_to_enemy = ( (position - self.origin)[0], (position - self.origin)[1], 0 );
	v_to_enemy = VectorNormalize( v_to_enemy );
	goalAngles = VectortoAngles( v_to_enemy );

	angleDiff = AbsAngleClamp180( self.angles[1] - goalAngles[1] );
	if ( angleDiff <= targetAngleDiff )
	{
		return;
	}

	self SetLookAtOrigin( position );
	self SetTurretTargetVec( position );
	self locomotion_start();

	angleAdjustingStart = GetTime();
	while( angleDiff > targetAngleDiff && vehicle_ai::TimeSince( angleAdjustingStart ) < 4 )
	{
		angleDiff = AbsAngleClamp180( self.angles[1] - goalAngles[1] );
		{wait(.05);};
	}

	self ClearVehGoalPos();
	self ClearLookAtEnt();
	self ClearTurretTarget();
	self CancelAIMove();
	self locomotion_stop();
}

// ----------------------------------------------
function Attack_Decision()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "end_attack_thread" );
	self endon( "end_attack_thread" );
	
	if( isdefined( self.enemy ) )
	{
		actions = [];
		
		if( self VehCanSee( self.enemy ) )
		{
			if ( vehicle_ai::IsCooldownReady( "minigun" ) && DistanceSquared( self.enemy.origin, self.origin ) < ( (self.settings.minigunmaxdist) * (self.settings.minigunmaxdist) ) )
			{
				actions[actions.size] = "mg_barrage";
			}
			
			if ( vehicle_ai::IsCooldownReady( "rocket" ) && DistanceSquared( self.enemy.origin, self.origin ) > ( (self.settings.rocketmindist) * (self.settings.rocketmindist) ) )
			{					
				actions[actions.size] = "rocket";
			}
		}
		else if( self VehSeenRecently( self.enemy, 7.0 ) )
		{
			if( vehicle_ai::IsCooldownReady( "javelin" ) )
			{
				actions[actions.size] = "javelin";
			}
			// add 50/50 chance to scane instead of javelin right away
			actions[actions.size] = "none";
		}
		else if( self VehSeenRecently( self.enemy, 16.0 ) )
		{
			// do nothing, just move again
			actions[actions.size] = "none";
		}
		else
		{
			actions[actions.size] = "scan";
			actions[actions.size] = "none";
		}
		
		if( actions.size > 0 )
		{
			wait 1 * self.difficulty_scale_down;
			action = actions[ RandomInt( actions.size ) ];
			
			switch( action )
			{
			case "mg_barrage":
				Attack_MachinegunBarrage();
				//Attack_MachinegunSweep();
				vehicle_ai::Cooldown( "minigun", self.settings.miniguncooldown );
				wait RandomFloatRange( 1, 3 ) * self.difficulty_scale_down;
				break;
			case "rocket":
				Attack_Rocket( self.enemy );
				vehicle_ai::Cooldown( "rocket", self.settings.rocketcooldown );
				wait RandomFloatRange( 1, 3 ) * self.difficulty_scale_down;
				break;
			case "javelin":
				Attack_Javelin();
				vehicle_ai::Cooldown( "javelin", self.settings.javelincooldown );
				break;
			case "scan":
				Scan();
				break;
			}
			
			return action;
		}
	}

	return "none";
}

function Scan()
{
	angles = self GetTagAngles( "tag_barrel" );
	angles = (0,angles[1],0);	// get rid of pitch
	
	rotate = 360;
	
	while( rotate > 0 )
	{
		angles += (0,30,0);
		rotate -= 30;
		forward = AnglesToForward( angles );
		
		aimpos = self.origin + forward * 1000;
		self SetTurretTargetVec( aimpos );
		msg = self util::waittill_any_timeout( 0.5, "turret_on_target" );
		wait 0.1;
		
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )	// use VehCanSee, if recently attacked this will return true and not use FOV check
		{
			self SetTurretTargetEnt( self.enemy );
			self SetLookAtEnt( self.enemy );
			self face_target( self.enemy );
			return;
		}
	}
	
	// return the turret to forward
	forward = AnglesToForward( self.angles );
		
	aimpos = self.origin + forward * 1000;
	self SetTurretTargetVec( aimpos );
	msg = self util::waittill_any_timeout( 3.0, "turret_on_target" );
	self ClearTurretTarget();
}

function MissileCleanup( proj )
{
	proj waittill( "death" );
	self Delete();
}

function Javelin_LoseTargetAtRightTime( target, proj )
{
	self endon( "death" );
	target endon( "death" );
	
	if( !isdefined( proj ) )
	{
		return;
	}
	
	proj endon( "death" );
	
	wait 1;
	
	model = Spawn( "script_model", target.origin );
	proj Missile_SetTarget( model );
	model thread MissileCleanup( proj );
	
	//wait 1;
	
	//while( isdefined( target ) )
	//{
	//	if( proj GetVelocity()[2] < -70 && DistanceSquared( proj.origin, target.origin ) < SQR(1500) )
	//	{
	//		proj Missile_SetTarget( undefined );
	//		break;
	//	}
	//	wait 0.05;
	//}
}

function Attack_Javelin()
{
	// aim up and fire
	v_to_enemy = self.enemy.origin - self.origin;
	v_to_enemy = VectorNormalize( v_to_enemy );
	shootpos = self.origin + v_to_enemy * 500 + (0,0,200);
	self SetTurretTargetVec( shootpos );
	
	shootpos = shootpos + (0,0,4000);
	self SetGunnerTargetVec( shootpos, 1 );
	
	wait 2 * self.difficulty_scale_down;
	self util::waittill_any_timeout( 2, "turret_on_target" );
	
	weapon = GetWeapon( "siegebot_javelin_turret" );
	
	start = self GetTagOrigin( "tag_gunner_flash2" );
	angles = self GetTagAngles( "tag_gunner_flash2" );
	end = start + AnglesToForward( angles ) * 1000;
	proj = MagicBullet( weapon, start, end, self, self.enemy );
	
	self thread Javelin_LoseTargetAtRightTime( self.enemy, proj );
	
	wait 0.5;
	
	// aim back down
	shootpos = self.origin + v_to_enemy * 5000;
	self SetTurretTargetVec( shootpos );
	self SetGunnerTargetVec( shootpos, 1 );
	wait 2 * self.difficulty_scale_down;
	self util::waittill_any_timeout( 2, "turret_on_target" );
	
	self ClearTurretTarget();
	self ClearGunnerTarget( 1 );
	
	wait RandomFloatRange( 0.5, 1 ) * self.difficulty_scale_down;
	
	if( isdefined( self.enemy ) && !self VehCanSee( self.enemy ) )	// use VehCanSee, if recently attacked this will return true and not use FOV check
	{
		forward = AnglesToForward( self.angles );
	
		aimpos = self.origin + forward * 5000;
		self SetTurretTargetVec( aimpos );
		msg = self util::waittill_any_timeout( 3.0, "turret_on_target" );
		self ClearTurretTarget();
	}
}

function Attack_MachinegunBarrage()
{
	aim_center = self.enemy.origin + (0,0,30);
	self SetTurretTargetVec( aim_center );
	self SetGunnerTargetVec( aim_center, 0 );
		
	wait 0.2;
	
	right = AnglesToRight( self GetTagAngles( "tag_turret" ) );
	aim_center_main_turret = aim_center - right * 60;
	
	self.turretrotscale = 0.2;
	
	timer = self.settings.minigunduration;
	
	//weapon = self SeatGetWeapon( 1 );
	self ClearGunnerTarget( 0 );
	//fireTime = weapon.fireTime;
	
	left_side = true;
	
	while( timer > 0 )
	{
		self FireWeapon( 1 );
	
		//wait fireTime;
		//timer -= fireTime;
		
		wait 0.05;
		timer -= 0.05;
			
		if( self.turretontarget )
		{
			random_offset = RandomFloatRange( -0.2, 0.2 );
			
			if( left_side )
			{
				offset = right * ( self.settings.minigunattackspread * ( 0.8 + random_offset ) );
				left_side = false;
			}
			else
			{
				offset = right * -( self.settings.minigunattackspread * ( 0.8 + random_offset ) );
				left_side = true;
			}
			
			offset += (0,0, RandomFloatRange( -20, 20 ) );
			
			new_aim_pos = aim_center + offset;
			self SetTurretTargetVec( new_aim_pos );
		}
	}
	
	self.turretrotscale = 1 * self.difficulty_scale_up;
	
	if( isdefined( self.enemy ) )
	{
		self SetTurretTargetEnt( self.enemy );
	}
}

function Attack_Rocket( target )
{		
	if ( isdefined( target ) )
	{
		self SetTurretTargetEnt( target );
		self SetGunnerTargetEnt( target, (0,0,0), 1 );
		msg = self util::waittill_any_timeout( 0.2, "turret_on_target" );
		self FireWeapon( 2 );
		self ClearGunnerTarget( 1 );
	}
}

function Attack_Thread_machinegun()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "end_attack_thread" );
	self endon( "end_attack_thread" );

	self.turretrotscale = 1 * self.difficulty_scale_up;
	
	while( 1 )
	{
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			self SetGunnerTargetEnt( self.enemy, (0,0,0), 0 );
			self SetGunnerTargetEnt( self.enemy, (0,0,0), 1 );
	
			self vehicle_ai::fire_for_time( RandomFloatRange( 0.75, 1.5 ) * self.difficulty_scale_up, 1 );
			
			if( isdefined( self.enemy ) && IsAI( self.enemy ) )
			{
				wait( RandomFloatRange( 0.1, 0.2 ) );
			}
			else
			{
				wait( RandomFloatRange( 0.2, 0.3 ) ) * self.difficulty_scale_down;
			}
		}
		else
		{
			self ClearGunnerTarget( 0 );
			wait 0.4;
		}
	}
}

function siegebot_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );

	return iDamage;
}


