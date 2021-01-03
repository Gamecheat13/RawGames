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
	
	self seigebot_update_difficulty();
	
	self SetGunnerTurretOnTargetRange( 0, self.settings.gunner_turret_on_target_range );
	
	self ASMRequestSubstate( "locomotion@movement" );

	defaultRole();
}


function seigebot_update_difficulty()
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

    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;

    self vehicle_ai::get_state_callbacks( "pain" ).update_func = &pain_update;

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

	self stopMovementAndSetBrake();

	self vehicle::set_damage_fx_level( 0 );
	self playsound( "veh_quadtank_power_down" );
	self playsound("veh_quadtank_sparks");
	self ASMRequestSubstate( "death@stationary" );
	self NotSolid();

	vehicle_ai::waittill_asm_complete( "death@stationary", 10 );

	self vehicle_ai::defaultstate_death_update();
}
// State: death ----------------------------------

// ----------------------------------------------
// State: pain
// ----------------------------------------------
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
		point vehicle_ai::AddScore( "random", randomFloatRange( 0, 30 ) );

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
		point vehicle_ai::AddScore( "random", randomFloatRange( 0, 30 ) );

		if( point.disttoorigin2d < 120 )
		{
			point vehicle_ai::AddScore( "tooCloseToSelf", (120 - point.disttoorigin2d) * -1.5 );
		}

		if( isdefined( self.enemy ) )
		{
			point vehicle_ai::AddScore( "engagementDist", -point.distAwayFromEngagementArea );

			if ( !point.visibility )
			{
				point vehicle_ai::AddScore( "visibility", -600 );
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
				vehicle::set_alert_fx_level( 3 );
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
				vehicle::set_alert_fx_level( 3 );
				self SetLookAtEnt( self.enemy );	// try to keep the basic orientation towards the enemy
				self SetTurretTargetEnt( self.enemy );
			
				// check the distance so we don't trigger a new path when we are already moving
				if( selfDistToTarget < farEngagementDist && selfDistToTarget > closeEngagementDist )
				{	
					canSeeEnemyCount++;

					// Stop if we can see our enemy	for a bit
					if( canSeeEnemyCount > 3 )
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

			if( self VehCanSee( self.enemy ) && distance2dSquared( self.origin, self.enemy.origin ) < ( (150) * (150) ) )
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

			if ( isdefined( self.enemy ) )
			{
				enemyOrigin = self.enemy.origin;
				self face_target( enemyOrigin );
			}
			wait 1;

			if ( isdefined( enemyOrigin ) )
			{
				Attack_Rocket( enemyOrigin );
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
				Attack_Rocket( self.enemy.origin );
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
	vehicle::set_alert_fx_level( 2 );
	
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
	spreadDist = self.settings.rocketspread;
	fireCount = 0;

	if ( isdefined( target ) )
	{
		vecToTarget = target - self.origin;

		if ( ( (vecToTarget[0]) * (vecToTarget[0]) ) + ( (vecToTarget[1]) * (vecToTarget[1]) ) > 0.01 )
		{
			vecToLeft = VectorNormalize( VectorCross( vecToTarget, (0,0,1) ) );
			
			shootpos = target - vecToLeft * spreadDist;
			self SetTurretTargetVec( shootpos );
			self SetGunnerTargetVec( shootpos, 1 );
			wait 0.3;
			msg = self util::waittill_any_timeout( 0.2, "turret_on_target" );
			self FireWeapon( 2 );
			fireCount++;
			/# recordLine( self.origin, shootpos, (1,0,0) );
			recordLine( self.origin, target, (1,0,1) ); #/

			shootpos = target;
			self SetTurretTargetVec( shootpos );
			self SetGunnerTargetVec( shootpos, 1 );
			msg = self util::waittill_any_timeout( 0.2, "turret_on_target" );
			self FireWeapon( 2 );
			fireCount++;
			/# recordLine( self.origin, shootpos, (1,0,0) );
			recordLine( self.origin, target, (1,0,1) ); #/
			
			shootpos = target + vecToLeft * spreadDist;
			self SetTurretTargetVec( shootpos );
			self SetGunnerTargetVec( shootpos, 1 );
			msg = self util::waittill_any_timeout( 0.2, "turret_on_target" );
			self FireWeapon( 2 );
			fireCount++;
			/# recordLine( self.origin, shootpos, (1,0,0) );
			recordLine( self.origin, target, (1,0,1) ); #/
		}
	}

	self ClearGunnerTarget( 1 );
	
	if( isdefined( self.enemy ) )
	{
		self SetTurretTargetEnt( self.enemy );
	}
	
	return fireCount;
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
	
			if( DistanceSquared( self.enemy.origin, self.origin ) < ( (0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax ) * 3) * (0.5 * ( self.settings.engagementDistMin + self.settings.engagementDistMax ) * 3) ) ) 
			{
				wait 0.2;	// give the turret a sec to get on target
				
				if( self.gunner1ontarget )
				{
					self vehicle_ai::fire_for_time( RandomFloatRange( 0.75, 1.5 ) * self.difficulty_scale_up, 1 );
				}
			}
			
			if( isdefined( self.enemy ) && IsAI( self.enemy ) )
			{
				wait( RandomFloatRange( 2, 3 ) );
			}
			else
			{
				wait( RandomFloatRange( 1.0, 2.0 ) ) * self.difficulty_scale_down;
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
	damageLevelChanged = vehicle::update_damage_fx_level( self.health, iDamage, self.healthdefault );

	if ( damageLevelChanged )
	{
		self vehicle_ai::set_state( "pain" );
	}

	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );

	return iDamage;
}


