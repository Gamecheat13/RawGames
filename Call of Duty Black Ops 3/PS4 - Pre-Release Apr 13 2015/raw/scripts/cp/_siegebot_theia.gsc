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
#using scripts\shared\clientfield_shared;

#using scripts\shared\ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\blackboard_vehicle;

#using scripts\shared\turret_shared;
#using scripts\shared\weapons\_spike_charge_siegebot;

#using scripts\shared\vehicles\_siegebot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\laststand_shared;

#using scripts\cp\cybercom\_cybercom_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
       
                                                                                                            	   	

                                                              	   	                             	  	                                      

// ----------------------------------------------------------------------------
// #define
// ----------------------------------------------------------------------------





	

	
// ----------------------------------------------------------------------------
// #namespace
// ----------------------------------------------------------------------------
#namespace siegebot_theia;

function autoexec __init__sytem__() {     system::register("siegebot_theia",&__init__,undefined,undefined);    }

#using_animtree( "generic" );

function __init__()
{	
	vehicle::add_main_callback( "siegebot_theia", &siegebot_initialize );

	clientfield::register( "vehicle", "sarah_rumble_on_landing", 1, 1, "counter" );
	clientfield::register( "vehicle", "sarah_minigun_spin", 1, 1, "int" ); 
}

function siegebot_initialize()
{
	self useanimtree( #animtree );

	blackboard::CreateBlackBoardForEntity( self );
	self Blackboard::RegisterVehicleBlackBoardAttributes();
	
	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();

	self EnableAimAssist();
	self SetNearGoalNotifyDist( self.radius * 1.2 );
	
	Target_Set( self, ( 0, 0, 150 ) );
	
	self.fovcosine = 0; // +/-90 degrees = 180 fov, err 0 actually means 360 degree view
	self.fovcosinebusy = 0;
	self.maxsightdistsqrd = ( (10000) * (10000) );

	assert( isdefined( self.scriptbundlesettings ) );

	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	self.goalRadius = 9999999;
	self.goalHeight = 5000;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );
	
	self.overrideVehicleDamage = &theia_callback_damage;

	self pain_toggle( true );

	util::magic_bullet_shield( self ); // we will disable death for the entire battle, until health get below threshold and theia get to designated location, then we grant her the privilege to die

	self initJumpStruct();
	
	self SetGunnerTurretOnTargetRange( 0, self.settings.gunner_turret_on_target_range );
	
	self cybercom::cybercom_AIOptOut("cybercom_hijack");
	self cybercom::cybercom_AIOptOut("cybercom_surge");

	self locomotion_start();

	self thread init_clientfields();

	self.damageLevel = 0;
	self.newDamageLevel = self.damageLevel;

	self init_player_threat_all();
	self init_fake_targets();

	if ( isdefined( self.combat_goal_volume ) )
	{
		self SetGoal( self.combat_goal_volume );
	}

	if ( !isdefined( self.height ) )
	{
		self.height = self.radius;
	}

	defaultRole();
}

function init_clientfields()
{
	self vehicle::lights_on();
	self vehicle::toggle_lights_group( 1, true );
	self vehicle::toggle_lights_group( 2, true );
	self vehicle::toggle_lights_group( 3, true );
	self clientfield::set( "sarah_minigun_spin", 0 );
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role();

    self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &state_balconyCombat_enter;
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_balconyCombat_update;
    self vehicle_ai::get_state_callbacks( "combat" ).exit_func = &state_balconyCombat_exit;

    self vehicle_ai::get_state_callbacks( "pain" ).enter_func = &pain_enter;
    self vehicle_ai::get_state_callbacks( "pain" ).update_func = &pain_update;
    self vehicle_ai::get_state_callbacks( "pain" ).exit_func = &pain_exit;

    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;

	self vehicle_ai::add_state( "jumpUp",
		&state_jumpUp_enter,
		&state_jump_update,
		&state_jump_exit );

	self vehicle_ai::add_state( "jumpDown",
		&state_jumpDown_enter,
		&state_jump_update,
		&state_jumpDown_exit );

	self vehicle_ai::add_state( "jumpGroundToGround",
		&state_jumpDown_enter,
		&state_jump_update,
		&state_jump_exit );

	// this is the normal siegebot ground combat
	self vehicle_ai::add_state( "groundCombat",
		undefined,
		&state_groundCombat_update,
		&state_groundCombat_exit );

	self vehicle_ai::add_state( "prepareDeath",
		undefined,
		&prepare_death_update,
		undefined );

	vehicle_ai::add_interrupt_connection( "groundCombat", "pain", "pain" );

	vehicle_ai::add_utility_connection( "emped", "groundCombat" );
	vehicle_ai::add_utility_connection( "pain", "groundCombat" );

	vehicle_ai::add_utility_connection( "combat", "jumpDown", &can_jump_down );
	vehicle_ai::add_utility_connection( "jumpDown", "groundCombat" );

	vehicle_ai::add_utility_connection( "groundCombat", "jumpGroundToGround", &can_jump_ground_to_ground );
	vehicle_ai::add_utility_connection( "jumpGroundToGround", "groundCombat" );

	vehicle_ai::add_utility_connection( "groundCombat", "jumpUp", &can_jump_up );
	vehicle_ai::add_utility_connection( "jumpUp", "combat" );

	vehicle_ai::add_utility_connection( "groundCombat", "prepareDeath", &should_prepare_death );
	vehicle_ai::add_utility_connection( "jumpDown", "prepareDeath", &should_prepare_death );

	vehicle_ai::Cooldown( "jump", 11 * 2 );
	vehicle_ai::Cooldown( "jumpUp", 11 * 4 );
	vehicle_ai::StartInitialState( "groundCombat" );
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
	self SetTurretTargetRelativeAngles( (0,0,0) );	// Reset the turret angles so the animation lines up

	self vehicle::set_damage_fx_level( 0 );
	self playsound( "veh_quadtank_power_down" );
	self playsound("veh_quadtank_sparks");
	self ASMRequestSubstate( "death@stationary" );
	vehicle_ai::waittill_asm_complete( "death@stationary", 10 );

	self notify( "death_complete" );

	BadPlace_Box( "", 0, self.origin, self.radius, "neutral" );
	
	self vehicle_ai::defaultstate_death_update();
}

function clean_up_spawned()
{
	if ( isdefined( self.jump ) )
	{
		self.jump.linkEnt Delete();
	}

	if ( isdefined( self.fakeTargetEnt ) )
	{
		self.fakeTargetEnt Delete();
	}

	if ( isdefined( self.spikeFakeTargets ) )
	{
		foreach( target in self.spikeFakeTargets )
		{
			target Delete();
		}
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

function pain_canenter()
{
	state = vehicle_ai::get_current_state();
	return isdefined( state ) && state != "pain" && self._enablePain;
}

function pain_enter( params )
{
	self stopMovementAndSetBrake();
}

function pain_exit( params )
{
	self SetBrake( 0 );
}

function pain_update( params )
{
	self endon( "death" );

	if ( 1 <= self.damagelevel && self.damagelevel <= 4 )
	{
		asmState = "damage_" + self.damageLevel + "@pain";
	}
	else
	{
		asmState = "normal@pain";
	}

	self ASMRequestSubstate( asmState );	
	self vehicle_ai::waittill_asm_complete( asmState, 5 );

	vehicle_ai::AddCooldownTime( "jump", -11 * 0.4 );
	vehicle_ai::AddCooldownTime( "jumpUp", -11 );
	
	previous_state = vehicle_ai::get_previous_state();
	self vehicle_ai::set_state( previous_state );
	self vehicle_ai::evaluate_connections();
}
// State: pain ----------------------------------

// ----------------------------------------------
// State: prepare_death
// ----------------------------------------------
function should_prepare_death( from_state, to_state, connection )
{
	prepare_death_threshold = self.healthdefault * 0.1;
	if ( self.health < prepare_death_threshold )
	{
		return 99999999; // big number so we are guarenteed to take this state
	}

	return 0;
}

function prepare_death_update( params )
{
	self endon ( "death" );
	self endon( "change_state" );

	if ( isdefined( self.death_goal_volume ) )
	{
		self SetGoal( self.death_goal_volume );
	}

	// don't shoot spike immediately
	if( vehicle_ai::get_previous_state() === "jump" )
	{
		vehicle_ai::Cooldown( "spike_on_ground", 2 );
	}

	self thread Attack_Thread_Gun();
	self thread Attack_Thread_Rocket();
	self thread Movement_Thread();

	if ( !self.isatanchor )
	{
		self waittill( "at_anchor" );

		if ( self.health < 500 )
		{
			self.health = 500;
		}
	}

	// now she is allowed to die
	util::stop_magic_bullet_shield( self );
}
// State: prepare_death -------------------------

// ----------------------------------------------
// State: jump
// ----------------------------------------------
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
	self.arena_center = struct::get( "arena_center" ).origin;
	self.death_goal_volume = GetEnt( "death_goal_volume", "targetname" );
	self.combat_goal_volume = GetEnt( "theia_combat_region", "targetname" );

	assert( self.jump.highgrounds.size > 0 );
	assert( self.jump.groundpoints.size > 0 );
	assert( isdefined( self.arena_center ) );
}

function can_jump_up( from_state, to_state, connection )
{
	if ( !vehicle_ai::IsCooldownReady( "jump" ) || !vehicle_ai::IsCooldownReady( "jumpUp" ) )
	{
		return 0;
	}

	target = highGroundPoint( 800, 2000, self.jump.highgrounds, 1200 );

	if ( isdefined( target ) )
	{
		self.jump.highground_history = target;
		return 500;
	}

	return 0;
}

function state_jumpUp_enter( params )
{
	goal = self.jump.highground_history.origin;

	trace = bullettrace( goal + (0,0, 500), goal - ( 0, 0, 10000 ), false, self );
	if ( false )
	{
	/#debugstar( goal, 60000, (0,1,0) ); #/
	/#debugstar( trace[ "position" ], 60000, (0,1,0) ); #/
	/#line(goal, trace[ "position" ], (0,1,0), 1, false, 60000 ); #/
	}
	goal = trace[ "position" ];

	self.jump.highground_history = goal;
	self.jump.goal = goal;

	params.scaleForward = 70;
	params.gravityForce = (0, 0, -5);
	params.upByHeight = 10;
	params.landingState = "land_turn@jump";

	self pain_toggle( false );

	self stopMovementAndSetBrake();
}

function can_jump_down( from_state, to_state, connection )
{
	if ( !vehicle_ai::IsCooldownReady( "jump" ) || self.dontchangestate === true )
	{
		return 0;
	}

	target = get_jumpon_target( 800, 2000, 1300 );

	if ( isdefined( target ) )
	{
		self.jump.lowground_history = target;
		return 500;
	}

	return 0;
}

function state_jumpDown_enter( params )
{
	goal = self.jump.lowground_history;

	trace = bullettrace( goal + (0,0, 500), goal - ( 0, 0, 10000 ), false, self );
	if ( false )
	{
	/#debugstar( goal, 60000, (0,1,0) ); #/
	/#debugstar( trace[ "position" ], 60000, (0,1,0) ); #/
	/#line(goal, trace[ "position" ], (0,1,0), 1, false, 60000 ); #/
	}
	goal = trace[ "position" ];

	self.jump.lowground_history = goal;
	self.jump.goal = goal;

	params.scaleForward = 70;
	params.gravityForce = (0, 0, -5);
	params.upByHeight = -5;
	params.landingState = "land@jump";

	self pain_toggle( false );

	self stopMovementAndSetBrake();
}

function can_jump_ground_to_ground( from_state, to_state, connection )
{
	if ( !vehicle_ai::IsCooldownReady( "jump" ) )
	{
		return 0;
	}

	target = get_jumpon_target( 800, 1800, 1300, false, 0, false );

	if ( isdefined( target ) )
	{
		self.jump.lowground_history = target;
		return 400;
	}

	return 0;
}

function state_jump_exit( params )
{
	self pain_toggle( true );
}

function state_jumpDown_exit( params )
{
	self pain_toggle( true );
	self vehicle_ai::Cooldown( "jumpUp", 11 + randomFloatRange( -1, 3 ) );
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
	antiGravityByDistance = MapFloat( 500, 2000, 0, 0.5, totalDistance );

	initVelocityUp = (0,0,1) * ( upByDistance + params.upByHeight );
	initVelocityForward = forward * params.scaleForward * MapFloat( 500, 2000, 0.8, 1, totalDistance );
	velocity = initVelocityUp + initVelocityForward;

	// start jumping
	self ASMRequestSubstate( "inair@jump" );
	self waittill( "engine_startup" );
	self vehicle::impact_fx( self.settings.startupfx1 );
	self waittill( "leave_ground" );
	self vehicle::impact_fx( self.settings.takeofffx1 );

	while( true )
	{
		distanceToGoal = Distance2D(self.jump.linkEnt.origin, goal);

		antiGravityScaleUp = MapFloat( 0, 0.5, 0.6, 0, abs( 0.5 - distanceToGoal / totalDistance ) );
		antiGravityScale = MapFloat( (self.radius * 1.0), (self.radius * 3), 0, 1, distanceToGoal );
		antiGravity = antiGravityScale * antiGravityScaleUp * (-params.gravityForce) + (0,0,antiGravityByDistance);
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
	self clientfield::increment( "sarah_rumble_on_landing" );

	wait 0.3;

	self Unlink();
	
	{wait(.05);};

	self.jump.in_air = false;

	self notify ( "jump_finished" );

	vehicle_ai::Cooldown( "jump", 11 );

	self vehicle_ai::waittill_asm_complete( params.landingState, 3 );

	self vehicle_ai::evaluate_connections();
}
// State: jump ----------------------------------

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function state_balconyCombat_enter( params )
{
	self vehicle_ai::ClearAllLookingAndTargeting();
	self SetTurretTargetRelativeAngles( (0,0,0), 0 );
	self SetTurretTargetRelativeAngles( (0,0,0), 1 );
	self SetTurretTargetRelativeAngles( (0,0,0), 2 );
	self SetTurretTargetRelativeAngles( (0,0,0), 3 );
	self SetTurretTargetRelativeAngles( (0,0,0), 4 );
}

function state_balconyCombat_update( params )
{
	self endon( "change_state" );
	self endon( "death" );

	// face the correct direction
	currentHighGround = undefined;
	foreach( highGround in self.jump.highgrounds )
	{
		if ( distance2DSquared( highGround.origin, self.origin ) < ( (self.radius * 6) * (self.radius * 6) ) )
		{
			currentHighGround = highGround;
			break;
		}
	}

	if ( !isdefined( currentHighGround ) )
	{
		self vehicle_ai::ClearCooldown( "jump" );
		self vehicle_ai::evaluate_connections();
	}

	forward = anglesToForward( currentHighGround.angles );

	while ( true )
	{		
		while ( !isdefined(self.enemy) )
		{
			wait 1;
		}

		self face_target( self.origin + forward * 10000 );

		javelinChance = self.damageLevel * 0.15;
		if ( randomFloat( 1.0 ) < javelinChance )
		{
			attack_javelin();
		}
		else
		{
			attack_spike_minefield();
		}
		level notify( "theia_finished_platform_attack" );
		self vehicle_ai::evaluate_connections();

		if ( RandomFloat( 1 ) > 0.4 )
		{
			wait 0.2;
			self side_step();
		}
		wait 0.8;

		attack_minigun_sweep();
		//attack_javelin();
		level notify( "theia_finished_platform_attack" );

		self vehicle_ai::evaluate_connections();
		wait 1;
	}
}

function side_step()
{
	step_size = 180; // trace length, not the actual move length. need to match with animation

	right_dir = AnglesToRight( self.angles );
	start = self.origin + (0,0,10);

	traceDir = right_dir;
	jukeState = "juke_r@movement";
	oppositeJukeState = "juke_l@movement";

	if ( math::cointoss() )
	{
		traceDir = -traceDir;
		jukeState = "juke_l@movement";
		oppositeJukeState = "juke_r@movement";
	}

	trace = PhysicsTrace( start, start + traceDir * step_size, ( -self.radius * 0.8, -self.radius * 0.8, 0 ), ( self.radius, self.radius, self.height * 0.8 ), self, (1 << 1) );

	if ( false )
	{
		/#line(start, start + traceDir * step_size, (1,0,0), 1, false, 100 ); #/
	}

	if ( trace["fraction"] < 1 )
	{
		traceDir = -traceDir;
		trace = PhysicsTrace( start, start + traceDir * step_size, ( -self.radius * 0.8, -self.radius * 0.8, 0 ), ( self.radius, self.radius, self.height * 0.8 ), self, (1 << 1) );
		jukeState = oppositeJukeState;
		if ( false )
		{
			/#line(start, start + traceDir * step_size, (1,0,0), 1, false, 100 ); #/
		}
	}

	if ( trace["fraction"] >= 1 )
	{
		self ASMRequestSubstate( jukeState );
		self vehicle_ai::waittill_asm_complete( jukeState, 3 );
		self locomotion_start();
		return true;
	}

	return false;
}

function state_balconyCombat_exit( params )
{
	self vehicle_ai::ClearAllLookingAndTargeting();
	self SetTurretTargetRelativeAngles( (0,0,0), 0 );
	self SetTurretTargetRelativeAngles( (0,0,0), 1 );
	self SetTurretTargetRelativeAngles( (0,0,0), 2 );
	self SetTurretTargetRelativeAngles( (0,0,0), 3 );
	self SetTurretTargetRelativeAngles( (0,0,0), 4 );
}
// State: combat ----------------------------------

// ----------------------------------------------
// State: groundCombat
// ----------------------------------------------
function state_groundCombat_update( params )
{
	self endon( "death" );
	self endon( "change_state" );

	// don't shoot spike immediately
	if( vehicle_ai::get_previous_state() === "jump" )
	{
		vehicle_ai::Cooldown( "spike_on_ground", 2 );
	}

	self thread Attack_Thread_Gun();
	self thread Attack_Thread_Rocket();
	self thread Movement_Thread();

	while ( true ) 
	{
		self vehicle_ai::evaluate_connections();
		wait 1;
	}
}

function highGroundPoint( distanceLimitMin, distanceLimitMax, pointsArray, idealDist )
{
	/# Record3DText( "range: [" + distanceLimitMin + "," + distanceLimitMax + "]", self.origin, (1,0.5,0), "Script", self ); #/

	bestScore = 1000000; // lower the better
	result = undefined;
	foreach( point in pointsArray )
	{
		distanceToTarget = Distance2D( point.origin, self.origin );
		if ( distanceToTarget < distanceLimitMin || distanceLimitMax < distanceToTarget )
		{
			/# RecordStar( point.origin, (1,0.5,0) ); #/
			/# Record3DText( "out of range: " + distanceToTarget, point.origin, (1,0.5,0), "Script", self ); #/
			continue;
		}

		score = Abs( distanceToTarget - idealDist );
		if ( score < 200 )
		{
			score = randomFloat( 200 );
		}

		if ( point === self.jump.highground_history )
		{
			score += 1000;
		}

		/# RecordStar( point.origin, (1,0.5,0) ); #/
		/# Record3DText( "dist: " + distanceToTarget + " score: " + score, point.origin, (1,0.5,0), "Script", self ); #/

		if ( score < bestScore )
		{
			bestScore = score;
			result = point;
		}
	}

	if ( isdefined( result ) )
	{
		return result;
	}

	return undefined;
}

function state_groundCombat_exit( params )
{
	self notify( "end_attack_thread" );
	self notify( "end_movement_thread" );
	self ClearTurretTarget();
}

function get_player_vehicle( player )
{
	if ( isPlayer( player ) )
	{
		if ( player.usingvehicle && isdefined( player.viewlockedentity ) && isVehicle( player.viewlockedentity ) )
		{
			return player.viewlockedentity;
		}
	}

	return undefined;
}

function get_player_and_vehicle_array()
{
	targets = level.players;

	vehicles = [];
	foreach ( player in level.players )
	{
		vehicle = get_player_vehicle( player );
		if ( isdefined( vehicle ) )
		{
			if ( !isdefined( vehicles ) ) vehicles = []; else if ( !IsArray( vehicles ) ) vehicles = array( vehicles ); vehicles[vehicles.size]=vehicle;;
		}
	}

	targets = ArrayCombine( targets, vehicles, false, false );
	return targets;
}

function init_player_threat( player )
{
	index = player GetEntityNumber();

	if ( !isdefined( self.player_threat ) )
	{
		self.player_threat = [];

		for( i = 0; i < 4; i++ )
		{
			self.player_threat[self.player_threat.size] = SpawnStruct();
		}
	}

	if ( !isdefined( self.player_threat[index].damage ) ||
		!isdefined( self.player_threat[index].tempBoost ) ||
		!isdefined( self.player_threat[index].tempBoostTimeout ) )
	{
		reset_player_threat( player );
	}
}

// self == vehicle
function init_player_threat_all()
{
	callback::on_spawned( &init_player_threat, self );
	callback::on_player_killed( &init_player_threat, self );
	callback::on_laststand( &init_player_threat, self );

	foreach( player in level.players )
	{
		self init_player_threat( player );
	}
}

// self == vehicle
function reset_player_threat( player )
{
	index = player GetEntityNumber();

	// find out other player's minDamage. this is to prevent hot join player never getting picked as target because damage factor is 0.
	minDamage = self.player_threat[index].damage;
	if ( !isdefined( minDamage ) )
	{
		minDamage = 1000000;
	}

	if ( self.player_threat.size > 0 )
	{
		foreach( threat in self.player_threat )
		{
			if ( isdefined( threat.damage ) )
			{
				minDamage = min( minDamage, threat.damage );
			}
		}
	}
	else
	{
		minDamage = 0;
	}

	self.player_threat[index].damage = minDamage;
	self.player_threat[index].tempBoost = 0;
	self.player_threat[index].tempBoostTimeout = 0;
}

// self == vehicle
function add_player_threat_damage( player, damage )
{
	index = player GetEntityNumber();
	self.player_threat[index].damage += damage;
}

// self == vehicle
function add_player_threat_boost( player, boost, timeSeconds )
{
	index = player GetEntityNumber();

	if ( self.player_threat[index].tempBoostTimeout <= GetTime() )
	{
		self.player_threat[index].tempBoost = 0;
	}

	self.player_threat[index].tempBoost += boost;
	self.player_threat[index].tempBoostTimeout = GetTime() + timeSeconds * 1000;
}

// self == vehicle
function get_player_threat( player )
{
	if ( !is_valid_target( player ) )
	{
		return undefined;
	}

	timeIgnoreOnSpawn = 7; //seconds
	if ( isdefined( player._spawn_time ) && player._spawn_time + timeIgnoreOnSpawn * 1000 < GetTime() )
	{
		return undefined;
	}

	index = player GetEntityNumber();

	threat = self.player_threat[index].damage;
	
	if ( self.player_threat[index].tempBoostTimeout > GetTime() )
	{
		threat += self.player_threat[index].tempBoost;
	}

	if ( self.main_target === player )
	{
		threat += 1000;
	}

	if( self VehSeenRecently( player, 3 ) )
	{
		threat += 1000;
	}

	if ( player.health < 50 )
	{
		threat -= 800;
	}

	distanceSqr = Distance2DSquared( self.origin, player.origin );
	if ( distanceSqr < ( (800) * (800) ) )
	{
		threat += 800;
	}
	else if ( distanceSqr < ( (1500) * (1500) ) )
	{
		threat += 400;
	}

	return threat;
}

// self == vehicle
function update_target_player()
{
	best_threat = -1000000;
	self.main_target = undefined;
	foreach( player in level.players )
	{
		threat = get_player_threat( player );
		if ( isdefined( threat ) && threat > best_threat )
		{
			best_threat = threat;
			self.main_target = player;
		}
	}
}

function shoulder_light_focus( target )
{
	if ( !isdefined( target ) )
	{
		self SetTurretTargetRelativeAngles( (0,0,0), 3 );
		self SetTurretTargetRelativeAngles( (0,0,0), 4 );
	}
	else
	{
		self vehicle_ai::SetTurretTarget( target, 3 );
		self vehicle_ai::SetTurretTarget( target, 4 );
	}
}

function Debug_line_to_target( target, time, color )
{
	self endon( "death" );
	point1 = self.origin;
	point2 = target.origin;
	if ( false ) 
	{
		stopTime = GetTime() + time * 1000;
		while ( GetTime() <= stopTime )
		{
			/#line(point1, point2, color, 1, false, 3 ); #/
			{wait(.05);};
		}
	}
}

function Pin_first_three_spikes_to_ground( delay )
{
	self endon( "death" );

	wait delay;
	for( i = 0; i < 3 && i < self.spikeFakeTargets.size; i++ )
	{
		spike = self.spikeFakeTargets[ i ];
		spike pin_to_ground();
		wait 0.15;
	}
}

function Attack_Thread_Gun()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "end_attack_thread" );
	self notify( "end_attack_thread_gun" );
	self endon( "end_attack_thread_gun" );

	while( 1 )
	{
		enemy = self.enemy;
		if( !isdefined( enemy ) )
		{
			self SetTurretTargetRelativeAngles( (0,0,0) );
			wait 0.4;
			continue;
		}

		if( !enemy.allowdeath && !IsPlayer(enemy) )
		{
			self SetPersonalThreatBias( enemy, -2000, 8.0 );
			wait 0.4;
			continue;
		}

		self vehicle_ai::SetTurretTarget( enemy, 0 );
		self vehicle_ai::SetTurretTarget( enemy, 1 );
		self shoulder_light_focus( enemy );

		gun_on_target = GetTime();
		while( isdefined( enemy ) && !self.gunner1ontarget && vehicle_ai::TimeSince( gun_on_target ) < 2 )
		{
			wait 0.4;
		}

		if( !isdefined( enemy ) )
		{
			wait 0.4;
			continue;
		}

		attack_start = GetTime();
		while ( isdefined( enemy ) && enemy === self.enemy && self VehSeenRecently( enemy, 1.0 ) && vehicle_ai::TimeSince( attack_start ) < 5 )
		{
			self vehicle_ai::fire_for_time( 1.0 + RandomFloat( 0.4 ), 1 );

			if ( isdefined( enemy ) && isPlayer( enemy ) )
			{
				wait( 0.6 + RandomFloat( 0.2 ) );
			}
			wait 0.1;
		}

		wait 0.1; // avoid infinite loop
	}
}

function Attack_Thread_Rocket()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "end_attack_thread" );
	self notify( "end_attack_thread_rocket" );
	self endon( "end_attack_thread_rocket" );

	while( 1 )
	{
		enemy = self.enemy;
		if( !isdefined( enemy ) )
		{
			wait 0.4;
			continue;
		}

		if ( vehicle_ai::IsCooldownReady( "spike_on_ground", 2 ) && self.rocketaim !== true )
		{
			self toggle_rocketaim( true );
		}

		if ( !vehicle_ai::IsCooldownReady( "spike_on_ground" ) )
		{
			wait 0.4;
			continue;
		}

		// select a secondary enemy
		primaryEnemy = enemy;

		targets = GetAITeamArray( "allies" );
		targets = ArrayCombine( targets, level.players, false, false );

		dirToPrimaryEnemy = VectorNormalize( ( (primaryEnemy.origin - self.origin)[0], (primaryEnemy.origin - self.origin)[1], 0 ) );

		bestCloseScore = 0.0;
		bestTarget = undefined;
		foreach( target in targets )
		{
			if ( target IsNoTarget() || target == primaryEnemy )
			{
				continue;
			}

			dirToTarget = VectorNormalize( ( (target.origin - self.origin)[0], (target.origin - self.origin)[1], 0 ) );
			angleDot = VectorDot( dirToTarget, dirToPrimaryEnemy );
			if ( angleDot < 0.2 )
			{
				continue;
			}

			distanceSelfToTargetSqr = Distance2DSquared( target.origin, self.origin );
			if ( distanceSelfToTargetSqr < ( (400) * (400) ) || distanceSelfToTargetSqr > ( (700) * (700) ) )
			{
				continue;
			}

			closeTargetScore = spike_score( target );

			closeTargetScore += 1 - angleDot;

			if ( isPlayer( target ) )
			{
				closeTargetScore += 0.5;
			}

			distancePrimaryEnemyToTargetSqr = Distance2DSquared( target.origin, primaryEnemy.origin );
			if ( distancePrimaryEnemyToTargetSqr < ( (200) * (200) ) )
			{
				closeTargetScore -= 0.3;
			}

			if ( bestCloseScore <= closeTargetScore )
			{
				bestCloseScore = closeTargetScore;
				bestTarget = target;
			}
		}

		enemy = bestTarget;

		if ( isAlive( enemy ) )
		{
			if ( false ) 
			{
				self thread Debug_line_to_target( enemy, 5, (1,0,0) );
			}

			turretOrigin = self GetTagOrigin( "tag_gunner_flash2" );
			distToEnemy = Distance2D( self.origin, enemy.origin );
			shootHeight = math::clamp( distToEnemy * 0.35, 100, 350 );
			points = GeneratePointsAroundCenter( enemy.origin + (0,0,shootHeight), 300, 80, 50 );
			pinDelay = Mapfloat( 300, 700, 0.1, 1.0, distToEnemy );

			// get the turret angle looking correct
			spike = self.spikeFakeTargets[ 0 ];
			spike.origin = points[ 0 ];
			self SetGunnerTargetEnt( spike, (0,0,0), 1 );

			rocket_on_target = GetTime();
			while( !self.gunner2ontarget && vehicle_ai::TimeSince( rocket_on_target ) < 2 )
			{
				wait 0.4;
			}

			self thread Pin_first_three_spikes_to_ground( pinDelay );

			for( i = 0; i < 3 && i < self.spikeFakeTargets.size && i < points.size; i++ )
			{
				spike = self.spikeFakeTargets[ i ];
				spike.origin = points[ i ];
				self SetGunnerTargetEnt( spike, (0,0,0), 1 );
				self FireWeapon( 2, enemy );
				vehicle_ai::Cooldown( "spike_on_ground", randomFloatRange( 6, 10 ) );

				if ( false ) 
				{
					/#debugstar( spike.origin, 200, (1,0,0) ); #/
						/#Circle( spike.origin, 150, (1,0,0), false, true, 200 ); #/
				}

				wait 0.15;
			}
		}

		wait 0.5;
		self SetTurretTargetRelativeAngles( (0,0,0), 2 );
		self toggle_rocketaim( false );

		wait 0.1; // avoid infinite loop
	}
}

function toggle_rocketaim( is_aiming )
{
	self.rocketaim = is_aiming;
	self locomotion_start();
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
	self endon( "death" );
	self endon( "change_state" );

	self notify( "kill_locomotion" );
	self endon( "kill_locomotion" );

	if ( self.rocketaim === true )
	{
		locomotion = "locomotion@movement";
	}
	else
	{
		locomotion = "locomotion_rocketup@movement";
	}
	
	self ASMRequestSubstate( locomotion );
}

function Get_Strong_Target()
{
	minDist = 400;

	ai_array = GetAITeamArray( "allies" );
	ai_array = array::randomize( ai_array );
	foreach( ai in ai_array )
	{
		awayFromPlayer = true;
		foreach( player in level.players )
		{
			if ( is_valid_target( player ) && Distance2DSquared( ai.origin, player.origin ) < ( (minDist) * (minDist) ) )
			{
				awayFromPlayer = false;
				break;
			}
		}

		if ( !awayFromPlayer )
		{
			continue;
		}
	}

	return undefined;
}

function Movement_Thread()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "end_movement_thread" );
	self endon( "end_movement_thread" );

	while( true )
	{
		// try to get player as target
		self update_target_player();
		enemy = self.main_target;

		// if there is only one player, ignore player once every 6 seconds
		if ( level.players.size <= 1 && vehicle_ai::IsCooldownReady( "ignore_player" ) )
		{
			vehicle_ai::Cooldown( "ignore_player", 6 );
			enemy = Get_Strong_Target();
			foreach( player in level.players )
			{
				self SetPersonalThreatBias( player, -1000, 2.0 );
			}
		}

		// fallback to general enemy
		if ( !isdefined(enemy) )
		{
			enemy = self.enemy;
		}

		// no enemy, just don't move
		if ( !isdefined(enemy) )
		{
			{wait(.05);};
			continue;
		}

		self.current_pathto_pos = self GetNextMovePosition( enemy );
		self.current_enemy_pos = enemy.origin;

		self SetSpeed( self.settings.defaultMoveSpeed );
		
		foundpath = self SetVehGoalPos( self.current_pathto_pos, false, true );
		if ( foundPath )
		{
			self SetLookAtEnt( enemy );
			self SetBrake( 0 );
			locomotion_start();
			self thread path_update_interrupt();
			self vehicle_ai::waittill_pathing_done();
			self notify( "end_path_interrupt" );
			self CancelAIMove();
			self ClearVehGoalPos();
			self SetBrake( 1 );
			locomotion_stop();
		}

		{wait(.05);};
	}
}

function path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "end_movement_thread" );
	self notify( "end_path_interrupt" );
	self endon( "end_path_interrupt" );

	while( true )
	{
		if ( isdefined( self.current_enemy_pos ) && isdefined( self.main_target ) )
		{
			if ( Distance2DSquared( self.current_enemy_pos, self.main_target.origin ) > ( (200) * (200) ) )
			{
				self notify( "near_goal" );
			}
		}
		wait 0.8;
	}
}

function GetNextMovePosition( enemy )
{
	if( self.goalforced )
	{
		return self.goalpos;
	}

	halfHeight = 400;
	spacing = 80;
	queryOrigin = self.origin;

	if ( isdefined( enemy ) && self CanPath( self.origin, enemy.origin ) )
	{
		queryOrigin = enemy.origin;
	}

	queryResult = PositionQuery_Source_Navigation( queryOrigin, 0, self.settings.engagementDistMax + 200, halfHeight, spacing, self );

	if ( isdefined( enemy ) )
	{
		PositionQuery_Filter_Sight( queryResult, enemy.origin, self GetEye() - self.origin, self, 0, enemy );
		vehicle_ai::PositionQuery_Filter_EngagementDist( queryResult, enemy, self.settings.engagementDistMin, self.settings.engagementDistMax );
	}
	PositionQuery_Filter_DistanceToGoal( queryResult, self );
	vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );

	forward = AnglesToForward( self.angles );
	if ( isdefined( enemy ) )
	{	
		enemyDir = VectorNormalize( enemy.origin - self.origin );
		forward = VectorNormalize( forward + 5 * enemyDir );
	}

	foreach ( point in queryResult.data )
	{
		if( Distance2DSquared( self.origin, point.origin ) < ( (300) * (300) ) )
		{
			point vehicle_ai::AddScore( "tooCloseToSelf", -700 );
		}

		if( isdefined( enemy ) )
		{
			point vehicle_ai::AddScore( "engagementDist", -point.distAwayFromEngagementArea );

			if ( !point.visibility )
			{
				point vehicle_ai::AddScore( "visibility", -600 );
			}
		}

		pointDirection = VectorNormalize( point.origin - self.origin );
		factor = VectorDot( pointDirection, forward );
		if ( factor > 0.7 )
		{
			point vehicle_ai::AddScore( "directionDiff", 600 );
		}
		else if ( factor > 0 )
		{
			point vehicle_ai::AddScore( "directionDiff", 0 );
		}
		else if ( factor > -0.5 )
		{
			point vehicle_ai::AddScore( "directionDiff", -600 );
		}
		else
		{
			point vehicle_ai::AddScore( "directionDiff", -1200 );
		}
	}

	vehicle_ai::PositionQuery_PostProcess_SortScore( queryResult );
	self vehicle_ai::PositionQuery_DebugScores( queryResult );

	if( queryResult.data.size == 0 )
		return self.origin;

	return queryResult.data[0].origin;
}
// State: groundCombat ----------------------------------

function _sort_by_distance2d( left, right, point )
{
	distanceSqrToLeft = distance2DSquared( left.origin, point );
	distanceSqrToRight = distance2DSquared( right.origin, point );
	return distanceSqrToLeft > distanceSqrToRight;
}

function too_close_to_high_ground( point, minDistance )
{
	foreach( highGround in self.jump.highgrounds )
	{
		if ( Distance2DSquared( point, highGround.origin ) < ( (minDistance) * (minDistance) ) )
		{
			return true;
			break;
		}
	}

	return false;
}

function get_jumpon_target( distanceLimitMin, distanceLimitMax, idealDist, includingAI, minAngleDiffCos, mustJump )
{
	targets = level.players;

	if ( includingAI === true )
	{
		targets = ArrayCombine( targets, GetAITeamArray( "allies" ), false, false );
		targets = array::merge_sort( targets, &_sort_by_distance2d, self.origin );
	}
	
	angles = ( 0, self.angles[1], 0 );
	
	forward = AnglesToForward( angles );
	
	bestTarget = undefined;
	bestScore = 1000000; // lower the better

	minDistAwayFromHighGround = 300;
	maxDistAwayFromArenaCenter = 1800;

	/# RecordStar( self.origin, (1,0.5,0) ); #/
	/# Record3DText( "JUMP TO GROUND", self.origin, (1,0.5,0), "Script", self ); #/
	
	foreach( target in targets )
	{
		if ( !is_valid_target( target ) || !target.allowdeath || IsAirBorne( target ) )
		{
			continue;
		}

		if ( Distance2DSquared( self.arena_center, target.origin ) > ( (maxDistAwayFromArenaCenter) * (maxDistAwayFromArenaCenter) ) )
		{
			/# RecordStar( target.origin, (0,0.5,1) ); #/
			/# Record3DText( "too far from center: " + distance2d( self.arena_center, target.origin ), target.origin, (0,0.5,1), "Script", self ); #/
			continue;
		}

		if ( too_close_to_high_ground( target.origin, minDistAwayFromHighGround ) )
		{
			/# RecordStar( target.origin, (0,0.5,1) ); #/
			/# Record3DText( "too close to platform", target.origin, (0,0.5,1), "Script", self ); #/
			continue;
		}

		distanceToTarget = Distance2D( target.origin, self.origin );
		if ( distanceToTarget < distanceLimitMin || distanceLimitMax < distanceToTarget )
		{
			/# RecordStar( target.origin, (1,0.5,0) ); #/
			/# Record3DText( "out of range: " + distanceToTarget, target.origin, (1,0.5,0), "Script", self ); #/
			continue;
		}

		vectorToTarget = ( ( target.origin - self.origin )[0], ( target.origin - self.origin )[1], 0 );
		vectorToTarget = vectorToTarget / distanceToTarget;
		if ( isdefined( minAngleDiffCos ) && VectorDot( forward, vectorToTarget ) < minAngleDiffCos )
		{
			continue;
		}

		score = Abs( distanceToTarget - idealDist );
		if ( score < 200 )
		{
			score = randomFloat( 200 );
		}

		/# RecordStar( target.origin, (1,0.5,0) ); #/
		/# Record3DText( "dist: " + distanceToTarget + " score: " + score, target.origin, (1,0.5,0), "Script", self ); #/

		if ( isPlayer( target ) && !isVehicle( target ) )
		{
			minRadius = 0;
			maxRadius = 300;
		}
		else
		{
			minRadius = 200;
			maxRadius = 400;
		}
		queryResult = PositionQuery_Source_Navigation( target.origin, minRadius, maxRadius, 500, self.radius * 0.5, self.radius * 1.4 );
		if ( queryResult.data.size > 0 )
		{
			element = queryResult.data[0];
			if ( score < bestScore )
			{
				bestScore = score;
				bestTarget = element;
			}
		}
	}
	
	if ( isdefined( bestTarget ) )
	{
		return bestTarget.origin;
	}

	if ( mustJump === false )
	{
		return undefined;
	}

	// pick random point using arena_center
	queryResult = PositionQuery_Source_Navigation( self.arena_center, 100, 1300, 500, self.radius, self.radius * 1.3 );

	assert ( queryResult.data.size > 0 );
	pointList = array::randomize( queryResult.data );
	foreach ( point in pointList )
	{
		distanceToTargetSqr = Distance2DSquared( point.origin, self.origin );
		if ( ( (distanceLimitMin) * (distanceLimitMin) ) < distanceToTargetSqr && distanceToTargetSqr < ( (distanceLimitMax) * (distanceLimitMax) ) && !too_close_to_high_ground( point.origin, minDistAwayFromHighGround ) )
		{
			return point.origin;
		}
	}

	return self.arena_center;
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
		if ( false ) /#line(self.origin, position, (1,0,1), 1, false, 5 ); #/
		angleDiff = AbsAngleClamp180( self.angles[1] - goalAngles[1] );
		{wait(.05);};
	}

	self ClearVehGoalPos();
	self ClearLookAtEnt();
	self ClearTurretTarget();
	self CancelAIMove();
	self locomotion_stop();
}

function theia_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	// Don't allow friendlies to kill sarah
	if( !IsPlayer(eAttacker) )
	{
		iDamage = 0;
		return iDamage;
	}
	
	//Adjust damage done by players according to how many players there are
	num_players = GetPlayers().size;
	num_players_damage_modifier = 1 / num_players;
	
	iDamage = iDamage * num_players_damage_modifier;

	newDamageLevel = vehicle::should_update_damage_fx_level( self.health, iDamage, self.healthdefault );
	if ( newDamageLevel > self.damageLevel )
	{
		self.newDamageLevel = newDamageLevel;
	}

	if ( self.newDamageLevel > self.damageLevel && pain_canenter() )
	{
		self.damageLevel = self.newDamageLevel;
		self notify( "pain" );
		vehicle::set_damage_fx_level( self.damageLevel );

		if ( self.damageLevel >= 2 )
		{
			self vehicle::toggle_lights_group( 1, false );
		}
	}

	if ( isdefined( eAttacker ) && isplayer( eAttacker ) )
	{
		add_player_threat_damage( eAttacker, iDamage );
		if ( iDamage > 500 )
		{
			add_player_threat_boost( eAttacker, 1000, 4 );
		}
	}

	return iDamage;
}

// ----------------------------------------------------------------------------
// attack_javelin
// ----------------------------------------------------------------------------
function attack_javelin()
{
	if( level.players.size < 1 )
	{
		return;
	}

	enemy = array::random( level.players );

	if ( !isdefined( enemy ) )
	{
		return;
	}

	// aim up and fire
	forward = AnglesToForward( self.angles );
	shootpos = self.origin + forward * 200 + (0,0,500);
	//self SetTurretTargetVec( shootpos );
	//self util::waittill_any_timeout( 0.5, "turret_on_target" );

	self ASMRequestSubstate( "javelin@stationary" );
	self waittill( "fire_javelin" );
	level notify( "theia_preparing_javelin_attack", enemy );
	
	current_weapon = self SeatGetWeapon( 0 );
	weapon = GetWeapon( "siegebot_javelin_turret" );
	self SetVehWeapon( weapon );
	self thread vehicle_ai::Javelin_LoseTargetAtRightTime( enemy );
	self FireWeapon( 0, enemy );
	
	self vehicle_ai::waittill_asm_complete( "javelin@stationary", 3 );

	self SetVehWeapon( current_weapon );
	
	// aim back down
	shootpos = self.origin + forward * 500;
	self SetTurretTargetVec( shootpos );
	self util::waittill_any_timeout( 2, "turret_on_target" );
	
	self ClearTurretTarget();
	
	wait RandomFloatRange( 1, 2 );
	
	if( isdefined( enemy ) && !self VehCanSee( enemy ) )	// use VehCanSee, if recently attacked this will return true and not use FOV check
	{
		forward = AnglesToForward( self.angles );
	
		aimpos = self.origin + forward * 1000;
		self SetTurretTargetVec( aimpos );
		msg = self util::waittill_any_timeout( 3.0, "turret_on_target" );
		self ClearTurretTarget();
	}

	self locomotion_start();
}

// ----------------------------------------------------------------------------
// attack_spike_minefield
// ----------------------------------------------------------------------------	
function init_fake_targets()
{
	count = 6;

	if( !isdefined( self.spikeFakeTargets ) || self.spikeFakeTargets.size < 1 )
	{
		self.spikeFakeTargets = [];
		for ( i = 0; i < count; i++ )
		{
			newFakeTarget = Spawn( "script_origin", self.origin );
			if ( !isdefined( self.spikeFakeTargets ) ) self.spikeFakeTargets = []; else if ( !IsArray( self.spikeFakeTargets ) ) self.spikeFakeTargets = array( self.spikeFakeTargets ); self.spikeFakeTargets[self.spikeFakeTargets.size]=newFakeTarget;;
		}
	}

	if( !isdefined( self.fakeTargetEnt ) )
	{
		self.fakeTargetEnt = Spawn( "script_origin", self.origin );
	}
}

// self == spike
function pin_to_ground()
{
	trace = BulletTrace( self.origin, self.origin + (0,0,-800), false, self );

	if( trace["fraction"] < 1.0 )
	{
		self.origin = trace["position"] + (0,0,-20);
	}
	else
	{
		self.origin = self.origin + (0,0,-500);
	}
}

function pin_spike_to_ground()
{
	self endon("death");

	wait 0.1;

	spikeTargets = array::randomize( self.spikeFakeTargets );
	foreach ( target in spikeTargets )
	{
		target pin_to_ground();
		wait randomFloatRange(0.05, 0.1);
	}

	if ( false ) 
	{
		foreach ( spike in spikeTargets )
		{
			/#debugstar( spike.origin, 200, (1,0,0) ); #/
			/#Circle( spike.origin, 150, (1,0,0), false, true, 200 ); #/
		}
	}
}

function spike_score( target )
{
	score = 1.0;
	if ( target IsNoTarget() )
	{
		score = 0.2;
	}
	else if ( !target.allowdeath )
	{
		score = 0.4;
	}
	else if ( IsAirBorne( target ) )
	{
		score = 0.2;
	}
	/*
	else if ( !self VehCanSee( target ) )
	{
		score = 0.6;
	}
	*/

	return score;
}

function spike_group_score( target, targetList, radius )
{
	closeTargetScore = spike_score( target );
	foreach ( otherTarget in targetList )
	{
		closeEnough = ( Distance2DSquared( target.origin, otherTarget.origin ) < ( (radius) * (radius) ) );
		if ( closeEnough )
		{
			closeTargetScore = closeTargetScore + spike_score( otherTarget );
		}
	}

	return closeTargetScore;
}

function attack_spike_minefield()
{
	spikeCoverRadius = 600;
	randomScale = 40;

	init_fake_targets();
	
	forward = AnglesToForward( self.angles );
	self SetTurretTargetVec( self.origin + forward * 1000 );
	self util::waittill_any_timeout( 2, "turret_on_target" );

	forward = AnglesToForward( self.angles );

	targets = GetAITeamArray( "allies" );
	targets = ArrayCombine( targets, level.players, false, false );

	bestCloseScore = 0.0;
	bestTarget = undefined;
	foreach( target in targets )
	{
		if ( target IsNoTarget() || IsAirBorne( target ) )
		{
			continue;
		}

		distanceSelfToTargetSqr = Distance2DSquared( target.origin, self.origin );
		if ( distanceSelfToTargetSqr < ( (500) * (500) ) || distanceSelfToTargetSqr > ( (2100) * (2100) ) )
		{
			continue;
		}

		dirToTarget = ( (target.origin - self.origin)[0], (target.origin - self.origin)[1], 0 );
		if ( VectorDot( dirToTarget, forward ) < 0.1 )
		{
			continue;
		}

		closeTargetScore = spike_group_score( target, targets, spikeCoverRadius );

		if ( bestCloseScore <= closeTargetScore )
		{
			bestCloseScore = closeTargetScore;
			bestTarget = target;
		}
	}

	if ( !isdefined( bestTarget ) )
	{
		bestTarget = array::random( GeneratePointsAroundCenter( self.arena_center, 2000, 200 ) );
	}
	else
	{
		bestTarget = bestTarget.origin;
	}

	if ( false ) 
	{
		/#debugstar( bestTarget, 200, (1,0,0) ); #/
		/#Circle( bestTarget, spikeCoverRadius, (1,0,0), false, true, 200 ); #/
	}
	
	//tell the level theia is about to fire spikes
	level notify( "theia_preparing_spike_attack", bestTarget );
	
	targetOrigin = ( bestTarget[0], bestTarget[1], 0 ) + (0,0,self.origin[2]);
	targetPoints = GeneratePointsAroundCenter( targetOrigin, 1200, 120 ); 

	numOfSpikeAssigned = 0;
	for( i = 0; i < self.spikeFakeTargets.size && i < targetPoints.size; i++ )
	{
		spike = self.spikeFakeTargets[ i ];
		spike.origin = targetPoints[i];
		numOfSpikeAssigned++;
	}

	self ASMRequestSubstate( "arm_rocket@stationary" );
	self waittill( "fire_spikes" );
	
	for ( i = 0; i < numOfSpikeAssigned; i++ )
	{
		spike = self.spikeFakeTargets[ i ];
		self SetGunnerTargetEnt( spike, (0,0,0), 1 );
		self FireWeapon( 2 );
	}
	
	self thread pin_spike_to_ground();
	
	self ClearGunnerTarget( 1 );
	self ClearTurretTarget();

	self vehicle_ai::waittill_asm_complete( "arm_rocket@stationary", 3 );
	self locomotion_start();
}

// ----------------------------------------------------------------------------
// attack_minigun_sweep
// ----------------------------------------------------------------------------	                    
function Delay_Target_ToEnemy_Thread( point, enemy, timeToHit )
{
	offset = (0, 0, 10);

	self.fakeTargetEnt Unlink();

	if ( DistanceSquared( self.fakeTargetEnt.origin, enemy.origin ) > ( (20) * (20) ) )
	{
		self.fakeTargetEnt.origin = point;
		self vehicle_ai::SetTurretTarget( self.fakeTargetEnt, 1 );
		self waittill( "turret_on_target" );

		timeStart = GetTime();

		while( GetTime() < timeStart + timeToHit * 1000 )
		{
			self.fakeTargetEnt.origin = LerpVector( point, enemy.origin + offset, ( GetTime() - timeStart ) / ( timeToHit * 1000 ) );
			if ( false ) /#debugstar( self.fakeTargetEnt.origin, 100, (0,1,0) ); #/
			{wait(.05);};
		}
	}

	self.fakeTargetEnt.origin = enemy.origin + offset;
	{wait(.05);};
	self.fakeTargetEnt LinkTo( enemy );
}

function is_valid_target( target )
{
	if ( ( isdefined( target.ignoreme ) && target.ignoreme ) || ( target.health <= 0 ) )
	{
		return false;
	}
	else if ( isPlayer( target ) && target laststand::player_is_in_laststand() )
	{
		return false;
	}
	else if ( IsSentient( target ) && ( target IsNoTarget() || !IsAlive( target ) ) )
	{
		return false;
	}

	return true;
}

function get_enemy()
{
	if ( isdefined( self.enemy ) && is_valid_target( self.enemy ) )
	{
		return self.enemy;
	}

	targets = GetAITeamArray( "allies" );
	targets = ArrayCombine( targets, level.players, false, false );

	validTargets = [];
	foreach( target in targets )
	{
		if ( is_valid_target( target ) )
		{
			if ( !isdefined( validTargets ) ) validTargets = []; else if ( !IsArray( validTargets ) ) validTargets = array( validTargets ); validTargets[validTargets.size]=target;;
		}
	}

	targets = array::merge_sort( validTargets, &_sort_by_distance2d, self.origin );
	return targets[0];
}

function attack_minigun_sweep()
{
	duration = 4;
	interval = 1;
	self.turretrotscale = 0.4;	// how fast to rotate the upper body turret

	self ClearTurretTarget();
	self ClearGunnerTarget( 1 );
	self SetTurretTargetRelativeAngles( (0,0,0), 0 );
	self SetTurretTargetRelativeAngles( (0,0,0), 1 );
	self ASMRequestSubstate( "sweep@gun" );
	self waittill( "barrelspin_start" );
	self clientfield::set( "sarah_minigun_spin", 1 );

	self waittill( "barrelspin_loop" );

	enemy = get_enemy();
	vectorFromEnemy = VectorNormalize( ( (self.origin - enemy.origin)[0], (self.origin - enemy.origin)[1], 0 ) );
	position = enemy.origin + vectorFromEnemy * 500;
	stopTime = GetTime() + duration * 1000;
	self thread vehicle_ai::fire_for_time( duration * 2, 1 );

	while ( GetTime() < stopTime )
	{
		enemy = get_enemy();

		v_gunner_barrel1 = self GetTagOrigin( "tag_gunner_flash1" );
		v_bullet_trace_end = enemy.origin + ( 0, 0, 30 );
		trace = BulletTrace( v_gunner_barrel1, v_bullet_trace_end, true, enemy );
		if( trace["fraction"] == 1 )
		{
			self GetPerfectInfo( enemy, true );
		}
		else if ( !IsPlayer(enemy) )
		{
			self SetPersonalThreatBias( enemy, -2000, 3.0 );
		}

		if( !enemy.allowdeath && !IsPlayer(enemy) )
		{
			self SetPersonalThreatBias( enemy, -900, 8.0 );
		}

		self vehicle_ai::SetTurretTarget( enemy, 0 );

		if ( IsPlayer( enemy ) )
		{
			vectorFromEnemy = VectorNormalize( ( (self.origin - enemy.origin)[0], (self.origin - enemy.origin)[1], 0 ) );
			self Delay_Target_ToEnemy_Thread( enemy.origin + vectorFromEnemy * 500, enemy, 0.7 );
		}
		else
		{
			self vehicle_ai::SetTurretTarget( enemy, 1 );
		}

		self util::waittill_any_timeout( interval, "enemy" );
	}

	self notify( "fire_stop" );

	self locomotion_start();

	self waittill( "barrelspin_end" );
	self clientfield::set( "sarah_minigun_spin", 0 );

	self.turretrotscale = 1.0;

	wait 0.2;
}

