#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\cp\_objectives;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\ai\systems\blackboard;
#using scripts\shared\ai\blackboard_vehicle;
                                                              	   	                             	  	                                      

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;

#using scripts\cp\_oed;


	






	

 //Number of times that a player can destroy the trophy weakspot before it is permanently destroyed
	
 //Used to limit the number of spikes that can hit a QT before trophy system gets re-enabled
	



	







 //an actor target must be at least this range from the QT for the QT to use the javelin attack
	
#precache( "objective", "cp_quadtank_weakpoint" );
#precache( "objective", "cp_quadtank_trophy_disabled" );
	

#precache( "eventstring", "weakpoint_update" );
#precache( "string", "tag_target_lower" );
	
#namespace quadtank;

function autoexec __init__sytem__() {     system::register("quadtank",&__init__,undefined,undefined);    }
	
#using_animtree( "generic" );

function __init__()
{
	vehicle::add_main_callback( "quadtank", &quadtank_initialize );

	clientfield::register( "toplayer", "player_shock_fx", 1, 1, "int" );
}

function quadtank_initialize() 
{
	self useanimtree( #animtree );
	
	self flag::init( "assassination_enabled" , false );

	self EnableAimAssist();
	self SetNearGoalNotifyDist( 35 );
	
	// AI SPECIFIC INITIALIZATION
	blackboard::CreateBlackBoardForEntity( self );
	self Blackboard::RegisterVehicleBlackBoardAttributes();
	
	self.turret_state = 1;
	self.weak_spot_health = 600;
	
	self.weak_spot_objective_marker = spawn( "script_model" , self.origin );
	self.weak_spot_objective_marker linkto( self, "tag_target_lower", (0,0,0) , (0,0,0) );
	
	self.fovcosine = 0; // +/-90 degrees = 180 fov, err 0 actually means 360 degree view
	self.fovcosinebusy = 0;
	self.maxsightdistsqrd = ( (10000) * (10000) );
	
	self.weakpointobjective = 0;
	self.displayweakpoint = true;
	self.combatactive = true; //used for weakpoint marker to make sure that objective is not added if tank is off
	self.damage_during_trophy_down = 0;
	self.spike_hits_during_trophy_down = 0;
	self.trophy_disables = 0;
	
	assert( isdefined( self.scriptbundlesettings ) );
	
	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	self.variant = "cannon";
	
	if( IsSubStr( self.vehicleType, "mlrs" ) )
	{
		self.variant = "rocketpod";
	}
	
	self.goalRadius = 9999999;
	self.goalHeight = 512;
	self SetGoal( self.origin, false, self.goalRadius, self.goalHeight );

	self SetSpeed( self.settings.defaultMoveSpeed, 10, 10 );
	self SetMinDesiredTurnYaw( 45 );
	self show_weak_spots( false );
	
	turret::_init_turret( 1 );
	turret::_init_turret( 2 );
	
	turret::set_best_target_func( &_get_best_target_quadtank_side_turret, 1 );
	turret::set_best_target_func( &_get_best_target_quadtank_side_turret, 2 );
	
	self quadtank_update_difficulty();
	
	self.left_turret_health = self.settings.sideTurretHealth;
	self.right_turret_health = self.settings.sideTurretHealth;
	
	self thread quadtank_turrets_forward();	
	self.overrideVehicleDamage = &QuadtankCallback_VehicleDamage;
	
	//disable some cybercom abilities
	if( IsDefined( level.vehicle_initializer_cb ) )
	{
    	[[level.vehicle_initializer_cb]]( self );
	}

	self HidePart( "tag_defense_active" );
	
	defaultRole();
}

function quadtank_update_difficulty()
{
//	testing out changing the turret parameters based solely upon the number of players, since damage
//	is alread scaled based upon the difficulty of the individual player
//	so, saving out current method until change has been tested
//
//	value = gameskill::get_general_difficulty_level();
//	
//	scale_up = mapfloat( 0, 7, 0.8, 2.0, value );
//	scale_down = mapfloat( 0, 7, 1.0, 0.5, value );
	
	if( isDefined( level.players) )
	{
		value = level.players.size;
	}
	else
	{
		value = 1;
	}
	
	
	scale_up = mapfloat( 1, 4, 1, 1.5, value );
	scale_down = mapfloat( 1, 4, 1.0, 0.75, value );
	
	turret::set_burst_parameters( 1.5, 2.5 * scale_up, 0.5 * scale_down, 1.5 * scale_down, 1 );
	turret::set_burst_parameters( 1.5, 2.5 * scale_up, 0.5 * scale_down, 1.5 * scale_down, 2 );
	
	self.difficulty_scale_up = scale_up;
	self.difficulty_scale_down = scale_down;
}

function defaultRole()
{
	self.state_machine = self vehicle_ai::init_state_machine_for_role( "default" );
	
    self vehicle_ai::get_state_callbacks( "pain" ).update_func = &pain_update;
    self vehicle_ai::get_state_callbacks( "emped" ).update_func = &quadtank_emped;

    self vehicle_ai::get_state_callbacks( "off" ).enter_func = &state_off_enter;
    self vehicle_ai::get_state_callbacks( "off" ).exit_func = &state_off_exit;

    self vehicle_ai::get_state_callbacks( "scripted" ).update_func = &quadtank_scripted;
    self vehicle_ai::get_state_callbacks( "driving" ).update_func = &quadtank_scripted;
    
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
    self vehicle_ai::get_state_callbacks( "combat" ).exit_func = &state_combat_exit;

    self vehicle_ai::get_state_callbacks( "death" ).update_func = &quadtank_death;

	self vehicle_ai::StartInitialState();
}

// ----------------------------------------------
// State: off
// ----------------------------------------------
function quadtank_off()
{
	self vehicle_ai::set_state( "off" );
	self.combatactive = false;
	self quadtank_remove_weakpoint_marker();
}

function quadtank_on()
{
	self vehicle_ai::set_state( "combat" );
	
	self.combatactive = true;
	
	self quadtank_display_weakpoint_marker();
}
	
function state_off_enter( params )
{
	self playsound( "veh_quadtank_power_down" );
	if( isdefined( self.sndEnt ) )
	{
		self.sndEnt stoploopsound( .5 );
	}
	quadtank_scripted();
	self vehicle::lights_off();
	self LaserOff();
	self vehicle::toggle_tread_fx( 0 );
	self vehicle::toggle_sounds( 0 );
	self vehicle::toggle_exhaust_fx( 0 );
	angles = self GetTagAngles( "tag_flash" );
	target_vec = self.origin + AnglesToForward( ( 0, angles[1], 0 ) ) * 1000;
	target_vec = target_vec + ( 0, 0, -500 );
	self SetTargetOrigin( target_vec );		
	self set_side_turrets_enabled( false );
	if( !isdefined( self.emped ) )
	{
		self DisableAimAssist();
	}
}

function state_off_exit( params )
{
	self vehicle::lights_on();
	self vehicle::toggle_tread_fx( 1 );
	self vehicle::toggle_sounds( 1 );
	self thread bootup();
	self vehicle::toggle_exhaust_fx( 1 );
	self EnableAimAssist();
}

function bootup()
{
	self endon("death");
	self playsound( "veh_quadtank_power_up" );
	self vehicle_ai::blink_lights_for_time( 1.5 );
	
	angles = self GetTagAngles( "tag_flash" );
	target_vec = self.origin + AnglesToForward( ( 0, angles[1], 0 ) ) * 1000;
	self.turretRotScale = 0.3;
	
	driver = self GetSeatOccupant( 0 );
	if( !isdefined(driver) )
	{
		self SetTargetOrigin( target_vec );
	}
	wait 1;
	
	self.turretRotScale = 1 * self.difficulty_scale_up;
}
// State: off -----------------------------------

// ----------------------------------------------
// State: pain
// ----------------------------------------------
function pain_update( params )
{
	self endon( "change_state" );
	self endon( "death" );
	
	if( trophy_disabled() )
	{
		// can only take pain when trophy is down
		asmState = "pain@stationary";
	}
	else 
	{
		// trophy system must be going down now
		asmState = "trophy_disabled@stationary";
	}
	self ASMRequestSubstate( asmState );
	
	self CancelAIMove();
	self ClearVehGoalPos();	
	self ClearTurretTarget();
	self SetBrake( 1 );
	
	self vehicle_ai::waittill_asm_complete( asmState, 6 );
	
	self SetBrake( 0 );
	
	self vehicle_ai::set_state( "combat" );
}
// State: pain ----------------------------------

// ----------------------------------------------
// State: scripted
// ----------------------------------------------
function quadtank_scripted( params )
{
	self endon( "change_state" );
	
	driver = self GetSeatOccupant( 0 );
	if( isdefined(driver) )
	{
		self.turretRotScale = 1;
		self DisableAimAssist();
		self thread quadtank_set_team( driver.team );
		driver EnableInvulnerability();
		driver.ignoreme = true;
		self thread quadtank_exit_vehicle();
		self thread quadtank_player_fireupdate();
		self thread footstep_handler();
		self SetBrake( 0 );
		self ASMRequestSubstate( "locomotion@movement" );
		self quadtank_enabletrophy();
	}
	
	self set_side_turrets_enabled( false );
	self LaserOff();
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
}
// State: scripted ------------------------------

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function state_combat_update( params )
{
	self endon( "death" );
	self endon( "change_state" );

	self thread quadtank_initial_trophy();
	self thread quadtank_movementupdate();
	
	switch ( self.variant )
	{
	case "cannon":
		self thread quadtank_weapon_think_cannon();	
		break;
	case "rocketpod":
		self thread Attack_Thread_rocket();
		break;
	}
}

function state_combat_exit( params )
{
	self notify( "end_attack_thread" );
	self notify( "end_movement_thread" );
	self ClearTurretTarget();
	self ClearLookAtEnt();
}
// State: combat --------------------------------

function quadtank_turrets_forward()
{	
	self endon( "death" );
	
	time = 3.5;
	
	while( isdefined( self ) && time > 0 )
	{
		self.turretRotScale = 100;
		target_vec = self.origin + AnglesToForward( ( 0, self.angles[1], 0 ) ) * 1000;
		target_vec = target_vec + ( 0, 0, 40 );
		self SetGunnerTargetVec( target_vec, 0 );		
		self SetGunnerTargetVec( target_vec, 1 );		
		
		time -= 0.05;
		{wait(.05);};
	}
	
	self ClearGunnerTarget( 0 );
	self ClearGunnerTarget( 1 );
	
	self.turretRotScale = 1 * self.difficulty_scale_up;
}

// rotates the turret around until he can see his enemy
function quadtank_turret_scan( scan_forever )
{
	self endon( "death" );
	self endon( "change_state" );
	
	self.turretRotScale = 0.3;
	
	while( scan_forever || ( !isdefined( self.enemy ) || !(self VehCanSee( self.enemy )) ) )
	{
		if( self.turretontarget && self.turret_state != 0 )
		{
			self.turret_state++;
			if( self.turret_state >= 5 )
				self.turret_state = 1;
		}
		
		switch( self.turret_state )
		{	
			// reserved for taking damage and looking responsive
			case 0:
				if( isdefined( self.enemy ) )
				{
					self SetLookAtEnt( self.enemy );
					target_vec = self.enemy.origin + ( 0, 0, 40 );
					self SetTargetOrigin( target_vec );		
					wait 1.0;
					self ClearLookAtEnt();
					self.turret_state++;
				}	// else fall through to FORWARD
				
			case 1:
				target_vec = self.origin + AnglesToForward( ( 0, self.angles[1], 0 ) ) * 1000;
				break;
				
			case 2:
				target_vec = self.origin + AnglesToForward( ( 0, self.angles[1] + 30, 0 ) ) * 1000;
				break;
				
			case 3:
				target_vec = self.origin + AnglesToForward( ( 0, self.angles[1], 0 ) ) * 1000;
				break;
				
			case 4:
				target_vec = self.origin + AnglesToForward( ( 0, self.angles[1] - 30, 0 ) ) * 1000;
				break;
		}

		target_vec = target_vec + ( 0, 0, 40 );
		self SetTargetOrigin( target_vec );		
		
		wait 0.2;
	}
}

function side_turrets_take_it_easy_on_one_guy()
{
	self endon( "death" );
	self endon( "take_it_easy" );
	
	while( isdefined( self ) )
	{
		side_turret_enemy1 = turret::get_target( 1 );
		side_turret_enemy2 = turret::get_target( 2 );
		
		if( isdefined( side_turret_enemy1 ) && isdefined( side_turret_enemy2 ) && side_turret_enemy1 == side_turret_enemy2 )
		{
			if( RandomInt( 100 ) > 50 )
			{
				turret::disable( 1 );
				turret::enable( 2, false );
			}
			else
			{
				turret::disable( 2 );
				turret::enable( 1, false );
			}
		}
		else
		{
			turret::enable( 1, false );
			turret::enable( 2, false );
		}
		
		wait 1.5;
	}
}

function set_side_turrets_enabled( on )
{
	self notify( "take_it_easy" );
	
	if( on )
	{
		if( self.left_turret_health > 0 )
		{
			turret::enable( 1, false );
		}
		if( self.right_turret_health > 0 )
		{
			turret::enable( 2, false );
		}
		
		self thread side_turrets_take_it_easy_on_one_guy();
	}
	else
	{
		turret::disable( 1 );
		turret::disable( 2 );
	}
}

function show_weak_spots( show )	// vents on the sides that are exposed when firing the main gun
{
	if( show )
	{
		self vehicle::toggle_exhaust_fx( 1 );
	}
	else
	{
		self vehicle::toggle_exhaust_fx( 0 );
	}
}

function set_detonation_time()
{
	self endon( "change_state" );

	self playsound("veh_quadtank_cannon_charge");
	
	self waittill( "weapon_fired", proj );
	
	self thread railgun_sound(proj);
	
	if( isdefined( self.enemy ) && isdefined( proj ) )
	{	
		vel = proj GetVelocity();
		
		proj_speed = length( vel );
		
		dist = Distance( proj.origin, self.enemy.origin ) + RandomFloatRange( 0, 40 );
		
		time_to_enemy = dist / proj_speed;
		
		proj ResetMissileDetonationTime( time_to_enemy );
		
		
		
	}
}

function quadtank_weapon_think_cannon()
{
	self endon( "death" );
	self endon( "change_state" );
	
	cant_see_enemy_count = 0;
	
	self set_side_turrets_enabled( true );
	self SetOnTargetAngle( 10 );	// self.turretontarget will be true when the turret is aimed within this rage
	
	self.getreadytofire = undefined;
	
	while ( 1 )
	{
		if ( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			self.turretRotScale = 1 * self.difficulty_scale_up;
			self SetTurretTargetEnt( self.enemy );
			self SetLookAtEnt( self.enemy );
			
			if( cant_see_enemy_count >= 2 )
			{
				wait .1;	// let the self.turretontarget have time to update so we don't shoot in a bad direction
				
				// found enemy, react by changing goal positions
				self CancelAIMove();
				self ClearVehGoalPos();
				self notify( "near_goal" );
			}
			cant_see_enemy_count = 0;
			fired = false;
			
			if ( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
			{
				if( DistanceSquared( self.origin, self.enemy.origin ) > 270 * 270 && self.turretontarget )
				{
					v_my_forward = Anglestoforward( self.angles );
					v_to_enemy = self.enemy.origin - self.origin;
					v_to_enemy = VectorNormalize( v_to_enemy );
					dot = VectorDot( v_to_enemy, v_my_forward );
				
					if( dot > 0.707 ) // body is facing within 45' of enemy
					{
						//self playsound( "wpn_quadtank_missile_fire_charge" );
						self ASMRequestSubstate( "fire@stationary" );
						self SetTurretTargetEnt( self.enemy );
						self thread set_detonation_time();
						
//						if( gameskill::get_general_difficulty_level() < 4 )
//						{
//							self set_side_turrets_enabled( false );
//						}
						
						if( isDefined( level.players) && level.players.size < 3)
						{
							self set_side_turrets_enabled( false );
						}
						
						self show_weak_spots( true );
						self.getreadytofire = true;
						fired = true;
						
						self CancelAIMove();
						self ClearVehGoalPos();
						self notify( "near_goal" );
						
						wait 1;
						
						level notify( "sndStopCountdown" );
						
						self vehicle_ai::waittill_asm_complete( "fire@stationary", 6 );
						
						self set_side_turrets_enabled( true );
					}
				}
			}
			
			self.getreadytofire = undefined;
			
			if ( isdefined( self.enemy ) )
			{
				self SetTurretTargetEnt( self.enemy );
				self SetLookAtEnt( self.enemy );
			}
			
			if( fired )
			{
				self show_weak_spots( false );
				
				vehicle_ai::Cooldown( "main_cannon", RandomFloatRange( 4, 8.5 ) );

				while( !vehicle_ai::IsCooldownReady( "main_cannon" ) ) 
				{
					wait 0.5;
				}
			}
			else
			{
				wait 0.25;
			}
		}
		else
		{	
			cant_see_enemy_count++;
			
			wait 0.5;
			
			if( cant_see_enemy_count > 40 )
			{
				self quadtank_turret_scan( false );
			}
			else if( cant_see_enemy_count > 30 )
			{
				self ClearLookAtEnt();
				self ClearTargetEntity();
			}
			else
			{
				if( isdefined( self.enemy ) )
				{
					self SetTurretTargetEnt( self.enemy );
					self ClearLookAtEnt();
				}
				else
				{
					self ClearLookAtEnt();
					self quadtank_turret_scan( false );
				}
			}
		}
	}
}


function Attack_Thread_rocket()
{
	self endon( "death" );
	self endon( "end_attack_thread" );

	self vehicle::toggle_ambient_anim_group( 2, false ); // close the weapon doors

	while( true )
	{
		//useJavelin = IS_TRUE( self.useJavelin );
		
		useJavelin = false;
		
		if( isdefined( self.enemy) && vehicle_ai::IsCooldownReady( "javelin_rocket_launcher", 0.5 )  )
		{
			if( isVehicle( self.enemy) || DistanceSquared( self.origin, self.enemy.origin) >= ( (1000) * (1000) ) )
			{
				useJavelin = !self vehseenrecently( self.enemy, 4 );
			}
		}


		if ( isdefined( self.enemy ) && vehicle_ai::IsCooldownReady( "rocket_launcher", 0.5 ) )
		{
//			if( gameskill::get_general_difficulty_level() < 4 )
			if( isDefined( level.players) && level.players.size < 3)
			{
				self set_side_turrets_enabled( false );
			}
			self ClearVehGoalPos();
			self notify( "near_goal" );
			self show_weak_spots( true );
			self vehicle::toggle_ambient_anim_group( 2, true );

			if( !useJavelin )
			{
				
				self SetVehWeapon( GetWeapon( "quadtank_main_turret_rocketpods_straight" ) );
				vehicle_ai::SetTurretTarget( self.enemy, 0, (0,0,-50) );
			}
			else
			{
				
				self playsound ("veh_quadtank_mlrs_plant_start");				
				
				self SetVehWeapon( GetWeapon( "quadtank_main_turret_rocketpods_javelin" ) );
		
				vehicle_ai::SetTurretTarget( self.enemy, 0, (0,0,300) );
			}

			wait 2;
			msg = self util::waittill_any_timeout( 2, "turret_on_target" );

			if ( isdefined( self.enemy ) && Distance2DSquared( self.origin, self.enemy.origin ) > ( (350) * (350) ) )
			{	
				fired = false;
				for( i = 0; i < 4 && isdefined( self.enemy ); i++ )
				{
					if( useJavelin )
					{
						self thread vehicle_ai::Javelin_LoseTargetAtRightTime( self.enemy );
						self thread javeline_incoming(GetWeapon( "quadtank_main_turret_rocketpods_javelin" ));
					}
					self FireWeapon( 0, self.enemy );
										
					fired = true;
					wait 0.8;
				}

				if ( fired )
				{

					vehicle_ai::Cooldown( "rocket_launcher", 10 );
					
					if( useJavelin )
					{
						vehicle_ai::Cooldown( "javelin_rocket_launcher", 20 );
					}
				}
			}

			self set_side_turrets_enabled( true );
			self vehicle::toggle_ambient_anim_group( 2, false );
			
			if ( isdefined( self.enemy ) )
			{
				self SetTurretTargetEnt( self.enemy );
				self SetLookAtEnt( self.enemy );
			}
		}
		wait 1;
	}
}

function enemyIsQuadtank( entity )
{
	if ( !isdefined( entity ) )
	{
		return false;
	}
	if ( isplayer( entity ) && entity.usingvehicle && isdefined( entity.viewlockedentity ) && entity.viewlockedentity.archetype === "quadtank" )
	{
		return true;
	}
	if ( isvehicle( entity ) && entity.archetype === "quadtank" )
	{
		return true;
	}
	return false;
}

// self == player
function trigger_player_shock_fx()
{
	if ( !isdefined( self._player_shock_fx_quadtank_melee ) )
	{
		self._player_shock_fx_quadtank_melee = 0;
	}

	self._player_shock_fx_quadtank_melee = !self._player_shock_fx_quadtank_melee;
	self clientfield::set_to_player( "player_shock_fx", self._player_shock_fx_quadtank_melee );
}

function path_update_interrupt()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "near_goal" );
	self endon( "reached_end_node" );

	wait 1;
	
	cantSeeEnemyCount = 0;
	
	while( 1 )
	{
		if( isdefined( self.current_pathto_pos ) )
		{
			if( isdefined( self.enemy ) ) 
			{
				if( distance2dSquared( self.enemy.origin, self.current_pathto_pos ) < 250 * 250 )
				{
					self.move_now = true;
					self notify( "near_goal" );
				}
				
				if( !self VehCanSee( self.enemy ) )
				{
					if( !self vehicle_ai::CanSeeEnemyFromPosition( self.current_pathto_pos, self.enemy, 80 ) )
					{
						cantSeeEnemyCount++;
						if( cantSeeEnemyCount > 5 )
						{
							self.move_now = true;
							self notify( "near_goal" );
						}
					}
				}
			}
			
			if( distance2dSquared( self.current_pathto_pos, self.goalpos ) > self.goalradius * self.goalradius )
			{
				wait 1;
				
				self.move_now = true;
				self notify( "near_goal" );
			}
		}
		
		wait 0.3;
	}
}

function Movement_Sound()
{
	if ( !isdefined( self.sndEnt ) )
	{
		self.sndEnt = spawn( "script_origin", self.origin );
		self.sndEnt linkto( self, "tag_origin" );
	}
	self.sndEnt playloopsound( "veh_quadtank_movement_loop", 2 );
}

function Movement_Thread_Wander()
{
	self endon( "death" );
	self endon( "change_state" );
	self notify( "end_movement_thread" );
	self endon( "end_movement_thread" );

	if( self.goalforced )
	{
		return self.goalpos;
	}
	
	minSearchRadius = 0;
	maxSearchRadius = 2000;
	halfHeight = 300;
	innerSpacing = 90;
	outerSpacing = innerSpacing * 2;
	maxGoalTimeout = 15;

	self Movement_Sound();
	self ASMRequestSubstate( "locomotion@movement" );

	wait 0.5;
	self SetBrake( 0 );

	while ( true )
	{
		self SetSpeed( self.settings.defaultMoveSpeed, 5, 5 );

		queryResult = PositionQuery_Source_Navigation( self.origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing, self, outerSpacing );

		// filter
		PositionQuery_Filter_DistanceToGoal( queryResult, self );
		vehicle_ai::PositionQuery_Filter_OutOfGoalAnchor( queryResult );
		vehicle_ai::PositionQuery_Filter_Random( queryResult, 200, 250 );

		foreach ( point in queryResult.data )
		{
			if( distance2dSquared( self.origin, point.origin ) < 170 * 170 )
			{
				point vehicle_ai::AddScore( "tooCloseToSelf", -100 );
			}
		}
		self vehicle_ai::PositionQuery_DebugScores( queryResult );

		vehicle_ai::PositionQuery_PostProcess_SortScore( queryResult );

		foundpath = false;
		goalPos = self.origin;
		count = queryResult.data.size;
		if( count > 3 )
			count = 3;
		
		for ( i = 0; i < count && !foundpath; i++ )
		{
			goalPos = queryResult.data[i].origin;
			foundpath = self SetVehGoalPos( goalPos, false, true );
		}

		if( foundpath )
		{
			self.sndEnt playloopsound( "veh_quadtank_movement_loop", 2 );
			
			self.current_pathto_pos = goalpos;
			self thread path_update_interrupt();
			self ASMRequestSubstate( "locomotion@movement" );
			
			msg = self util::waittill_any_timeout( maxGoalTimeout, "near_goal", "force_goal", "reached_end_node", "goal" );
			self CancelAIMove();
			self ClearVehGoalPos();
			
			if( isdefined( self.move_now ) )
			{
				self.move_now = undefined;
				
				wait 0.1;
			}
			else
			{
				self.sndEnt stoploopsound( .5 );
				wait 0.5;
			}
		}
		else
		{
			self.current_pathto_pos = undefined;
			
			goalYaw = self GetGoalYaw();
			
			wait 1;
		}
	}
}

function quadtank_movementupdate()
{
	self endon( "death" );
	self endon( "change_state" );
	
	//if( distance2dSquared( self.origin, self.goalpos ) > 20 * 20 )
	//	self SetVehGoalPos( self.goalpos, true, 2 );
	
	self Movement_Sound();
	self ASMRequestSubstate( "locomotion@movement" );
	wait 0.5;
	
	goalfailures = 0;
	badgoalpos = undefined;
	
	self SetBrake( 0 );
	
	while( 1 )
	{
		if ( self.getreadytofire !== true )
		{
		goalpos = vehicle_ai::FindNewPosition( 80 );
		
		self SetSpeed( self.settings.defaultMoveSpeed, 5, 5 );
		
		if( self SetVehGoalPos( goalpos, false, true ) )
		{
			badgoalpos = undefined;
			
			self.sndEnt playloopsound( "veh_quadtank_movement_loop", 2 );
			
			self.current_pathto_pos = goalpos;
			self thread path_update_interrupt();
			self ASMRequestSubstate( "locomotion@movement" );
			
			goalfailures = 0;
			self util::waittill_any( "near_goal", "reached_end_node", "force_goal" );
			self CancelAIMove();
			self ClearVehGoalPos();
			
			if( isdefined( self.move_now ) )
			{
				self.move_now = undefined;
				
				wait 0.1;
			}
			else
			{
				self.sndEnt stoploopsound( .5 );
				
				wait 0.5;
			}
		}
		else
		{
			badgoalpos = goalPos;
			
			goalfailures++;
			
			self.current_pathto_pos = undefined;
			self LaunchVehicle( (0,0,100) );
			
			goalYaw = self GetGoalYaw();
			
			self thread vehicle_ai::blink_lights_for_time( 0.5 );
			wait 0.5;
		}
		}
		else
		{
			self.sndEnt stoploopsound( .5 );
			
			while( isdefined( self.getreadytofire ) )
			{
				wait 0.2;
			}
		}
		
	}
}

// self is vehicle
function quadtank_exit_vehicle()
{
	self endon( "death" );
	self waittill( "exit_vehicle", player );
	
	player.ignoreme = false;
	player DisableInvulnerability();
	
	self SetGoal( self.origin );
}

function quadtank_player_fireupdate()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	weapon = self SeatGetWeapon( 1 );
	fireTime = weapon.fireTime;
	
	while( 1 )
	{
		self SetGunnerTargetVec( self GetGunnerTargetVec( 0 ), 1 );
		if( self IsGunnerFiring( 0 ) )
		{
			self FireWeapon( 2 );
		}
		wait fireTime;
	}
}

function do_melee( shouldDoDamage, enemy )
{
	if ( enemyIsQuadtank( enemy ) )
	{
		return;
	}
	
	if ( !isAlive( enemy ) || ( isPlayer( enemy ) && enemy laststand::player_is_in_laststand() ) )
	{
		return;
	}

	self notify ( "play_meleefx" );

	if ( shouldDoDamage )
	{
		RadiusDamage( self.origin + (0,0,40), 270, 200, 150, self );
	}

	if ( isdefined( enemy ) && isPlayer( enemy ) )
	{
		direction = VectorNormalize( ( ( enemy.origin - self.origin )[0], ( enemy.origin - self.origin )[1], 0 ) );
		strength = 1000;
		enemy SetVelocity( enemy GetVelocity() + direction * 1000 );
		enemy trigger_player_shock_fx();
		
		LUINotifyEvent( &"weakpoint_update", 3, 3, self getEntityNumber(), &"tag_target_lower" );

	}

	self playsound( "veh_quadtank_emp" );
}

function quadtank_automelee_update()
{
	self endon( "death" );

	assert( isdefined( self.team ) );

	while( !trophy_disabled() )
	{
		enemyteam = gameobjects::get_enemy_team( self.team );
		enemies = GetAITeamArray( enemyteam );
		foreach ( player in level.players )
		{
			if ( player.team === enemyteam )
			{
				if ( !isdefined( enemies ) ) enemies = []; else if ( !IsArray( enemies ) ) enemies = array( enemies ); enemies[enemies.size]=player;;
			}
		}

		meleed = false;
		foreach( enemy in enemies )
		{
			if( enemy IsNoTarget() )
			{
				continue;
			}

			if( distanceSquared( enemy.origin, self.origin ) < 270 * 270 )
			{
				self do_melee( !meleed, enemy );
				meleed = true;
				break;
			}
		}
		
		wait 0.3;
	}
}

// Death 
function quadtank_death( params )
{
	self endon( "death" );	
	self endon( "nodeath_thread" );

	self quadtank_disable_assassination();
	
	self quadtank_remove_weakpoint_marker();
	self vehicle::toggle_lights_group( 1, false );
	self vehicle::toggle_ambient_anim_group( 1, false );
	self remove_repulsor();

	if ( !isdefined( self.custom_death_sequence ) )
	{
		self playsound( "veh_quadtank_power_down" );
		self playsound("veh_quadtank_sparks");
		self ASMRequestSubstate( "death@stationary" );
		self vehicle_ai::waittill_asm_complete( "death@stationary", 6 );
	}
	else
	{
		self [[self.custom_death_sequence]]();
	}

	BadPlace_Box( "", 0, self.origin, 110, "neutral" );
	
	if( isdefined( self.sndEnt ) )
	{
		self.sndEnt stoploopsound( .5 );
	}
	
	if( isdefined( self.stun_fx ) )
	{
		self.stun_fx delete();
	}
	
	self vehicle_ai::defaultstate_death_update();
}

function quadtank_emped( params )
{
	self endon ("death");
	self endon( "change_state" );
	self endon( "emped" );
	
	if( isdefined( self.emped ) )
	{
		// already emped, just return for now.
		return;
	}
	
	self.emped = true;
	PlaySoundAtPosition( "veh_quadtankemp_down", self.origin );
	self.turretRotScale = 0.2;
	if( !isdefined( self.stun_fx) )
	{
		self.stun_fx = Spawn( "script_model", self.origin );
		self.stun_fx SetModel( "tag_origin" );
		self.stun_fx LinkTo( self, "tag_turret", (0,0,0), (0,0,0) );
		//PlayFXOnTag( level._effect[ "quadtank_stun" ], self.stun_fx, "tag_origin" );
	}
	
	time = params.notify_param[0];
	assert( isdefined( time ) );
	vehicle_ai::Cooldown( "emped_timer", time );

	while( !vehicle_ai::IsCooldownReady( "emped_timer" ) )
	{
		timeLeft = max( vehicle_ai::GetCooldownLeft( "emped_timer" ), 0.5 );
		wait timeLeft;
	}
	
	self.stun_fx delete();
	self.emped = undefined;
	self.weak_spot_health = 600;
	self playsound ("veh_boot_quadtank");

	self vehicle_ai::evaluate_connections();
}

function quadtank_destroyturret( index )
{
	turret::disable( index );
	
	if( index == 1 )
	{
		self HidePart( "tag_gunner_barrel1" );
		self HidePart( "tag_gunner_turret1" );
	}
	else if( index == 2 )
	{
		self HidePart( "tag_gunner_barrel2" );
		self HidePart( "tag_gunner_turret2" );
	}
}

function quadtank_initial_trophy()
{
	self endon( "death" );
	//wait 0.5;
	if ( isalive( self ) && !trophy_disabled() )
	{
		self quadtank_enabletrophy();
	}
}

function trophy_disabled()
{
	if( !self vehicle_ai::IsCooldownReady("trophy_down") || self.trophy_disables >= 4 || self.being_assassinated === true )
	{
		return true;
	}
	else
	{
		return false;
	}
	
}

function quadtank_disabletrophy()
{
	self endon( "death" );
	
	if( trophy_disabled() )
		return;
	
	driver = self GetSeatOccupant( 0 );
	if( !isdefined( driver ) )
	{
		self notify( "pain" );	// Play a trophy system down animation using the pain state
		waittillframeend;		// Let the pain start before we mark trophy_disabled so it knows it should play a trophy down anim
	}
	
	Target_Set( self , (0,0,120) );
	
	self HidePart( "tag_defense_active" );
	//self HidePart( "tag_target_upper" );
	self.attackerAccuracy = 0.5;
	self.damage_during_trophy_down = 0;
	self.spike_hits_during_trophy_down = 0;
	self.trophy_disables += 1;
	
	self quadtank_remove_weakpoint_marker();
	self vehicle::toggle_lights_group( 1, false );
	self vehicle::toggle_ambient_anim_group( 1, false );
	self remove_repulsor();
	
//	healthPct = self.health / self.healthdefault;
//	if( healthPct < 0.5 )
//	{
//		self thread quadtank_enable_assassination();
//	}
	
	self set_side_turrets_enabled( false );
	
	if( IsDefined( level.vehicle_defense_cb ) )
	{
    	[[level.vehicle_defense_cb]]( self, false );
	}

	self notify("trophy_system_disabled");
	level notify("trophy_system_disabled",self);
	self playsound ("wpn_trophy_disable");
	
	self vehicle_ai::Cooldown( "trophy_down", self.settings.trophySystemDownTime );
	while( trophy_disabled() )
	{
		if ( self.damage_during_trophy_down >= self.settings.trophysystemdisablethreshold ||
			self.spike_hits_during_trophy_down >= 5 )
		{
			self vehicle_ai::ClearCooldown( "trophy_down" );
		}

		PlayFxOnTag( self.settings.trophydestroyfx, self, "tag_target_lower" );
		//PlayFxOnTag( self.settings.trophydestroyfx, self, "tag_target_upper" );
		wait 1;
	}
	
	if( self.trophy_disables < 4)
	{	
		quadtank_enabletrophy();
	}
	else
	{
		self notify("trophy_system_destroyed");
		level notify("trophy_system_destroyed",self);
	}
}

function quadtank_enabletrophy()
{
	if ( self.being_assassinated === true )
	{
		return;
	}

	driver = self GetSeatOccupant( 0 );
	
	self quadtank_disable_assassination();
	self quadtank_projectile_watcher();
	self thread quadtank_automelee_update();

	if( !isdefined( driver ) )
	{
		self quadtank_display_weakpoint_marker();
	}
	else
	{
		self quadtank_remove_weakpoint_marker();
	}
	
	if ( Target_IsTarget(self) )
	{
		Target_remove( self ); 
	}
	
	self.attackerAccuracy = 1;
	self ShowPart( "tag_defense_active" );
	//self ShowPart( "tag_target_upper" );
	if( !isdefined( driver ) )
	{
		self set_side_turrets_enabled( true );
	}
	self vehicle::toggle_lights_group( 1, true );
	self vehicle::toggle_ambient_anim_group( 1, true );
	self.trophy_system_health = self.settings.trophySystemHealth;
	
	if( isDefined( level.players) && level.players.size > 0 )
	{
		num_players_trophy_health_modifier = 0.5;
		
		if( level.players.size == 2) 
		{
			num_players_trophy_health_modifier = 1;	
		}
		if( level.players.size == 3) 
		{
			num_players_trophy_health_modifier = 1.25;	
		}
		if( level.players.size >= 4) 
		{
			num_players_trophy_health_modifier = 1.5;	
		}
		self.trophy_system_health = self.trophy_system_health * num_players_trophy_health_modifier;
	}
	
	if( IsDefined( level.vehicle_defense_cb ) )
	{
    	[[level.vehicle_defense_cb]]( self, true );
	}
	self notify("trophy_system_enabled");
	level notify("trophy_system_enabled",self);
	self thread spawn_trophy_sound();
	self thread quad_tank_death_audio_cleanup();
}
function spawn_trophy_sound()
{
	if(!IsDefined (self.spnsndEnt))
	{
   		self.spnsndEnt = spawn( "script_origin", self.origin );
   		self.spnsndEnt linkto( self, "tag_origin" );
   		self.spnsndEnt thread play_trophy_sounds();
	}	
}
function play_trophy_sounds()
{
	self endon ("death");
	
	while(1)
	{
		self playloopsound ("wpn_trophy_spin_loop", .1);	
		level util::waittill_any ("trophy_system_disabled","trophy_system_destroyed");
		self stoploopsound (.1);
		level waittill ("trophy_system_enabled");
		
	}	
}
function quad_tank_death_audio_cleanup()
{
	self waittill ("death");
	
	if(IsDefined (self.spnsndEnt))
	{
		  self.spnsndEnt delete();
	}
}
function QuadtankCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	is_damaged_by_grenade = weapon.weapClass == "grenade";
	
	if( IsSubstr( weapon.name , "spike")  && eAttacker.team != self.team )
	{
		self.spike_hits_during_trophy_down += 1;
		is_damaged_by_grenade = false;
	}
	
	if( isdefined(eAttacker) && eAttacker == self )
	{
		return 0;
	}
	
	if( partName == "tag_target_turret_right" || partName == "tag_target_turret_left" || 
	   partName == "tag_target_left" || partName == "tag_target_right" || partName == "tag_target_left1" || partName == "tag_target_right1" )
	{
		self.weak_spot_health -= iDamage;
		if( self.weak_spot_health <= 0 )
		{
			self notify ("emped", 3);
		}
		
		iDamage = Int( iDamage * 3 );
		
		self playsound( "veh_quadtank_panel_hit" );
		//PlayFxOnTag( self.settings.weakSpotFx, self, partName );
	}
	else if( partName == "tag_target_lower" || partName == "tag_target_upper" || partName == "tag_defense_active" )	
	{
		if( isdefined( eAttacker) && IsPlayer( eAttacker ) && eAttacker.team != self.team )
		{
			if ( !isDefined( self.trophy_system_health ) )
			{
				self.trophy_system_health = self.settings.trophySystemHealth;
			}

			self.trophy_system_health -= iDamage;
			PlayFxOnTag( self.settings.weakSpotFx, self, partName );
			eAttacker LUINotifyEvent( &"weakpoint_update", 3, 2, self getEntityNumber(), &"tag_target_lower" );
			
			if( self.trophy_system_health <= 0 )
			{
				self thread quadtank_disabletrophy();
			}
			
			if( !trophy_disabled() )
			{
				if( IsPlayer( eAttacker ) && damagefeedback::doDamageFeedback( weapon, eInflictor ) )
				{
					if ( iDamage > 0 )
						eAttacker thread damagefeedback::update( sMeansOfDeath, eInflictor );
				}
			}
		}
	}
	else if( partName == "tag_gunner_barrel1" || partName == "tag_gunner_turret1" )
	{
		//PlayFxOnTag( self.settings.weakSpotFx, self, partName );
		
		self.left_turret_health -= iDamage;
		if( self.left_turret_health <= 0 )
		{
			//quadtank_destroyturret( 1 );
		}
	}
	else if( partName == "tag_gunner_barrel2" || partName == "tag_gunner_turret2" )
	{
		//PlayFxOnTag( self.settings.weakSpotFx, self, partName );
		
		self.right_turret_health -= iDamage;
		if( self.right_turret_health <= 0 )
		{
			//quadtank_destroyturret( 2 );
		}
	}
	else if ( is_damaged_by_grenade /*|| sMeansOfDeath == "MOD_EXPLOSIVE" */ )
	{
		iDamage = Int( iDamage * 3 );
	}
	
	// when taking damage let the turret know if it is scanning to look at our enemy
	// hopefully code will update our enemy
	self.turret_state = 0;
	self.turretRotScale = 1.0 * self.difficulty_scale_up;
	self.turret_on_target = true;
		
	driver = self GetSeatOccupant( 0 );
	
	if( isdefined( driver ) )
	{
		// Lets get some hit indicators
		//driver.health += 1;
		//driver FinishPlayerDamage( eInflictor, eAttacker, 1, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, "none", 0, psOffsetTime );
	}

	if( sMeansOfDeath == "MOD_RIFLE_BULLET" || sMeansOfDeath == "MOD_PISTOL_BULLET" )	// Quadtank is immune to bullets but that filtering happens later
	{
		return iDamage;
	}
	
	// cap the damage actors can do
	if( IsActor( eAttacker ) && iDamage > 250 )
	{
		iDamage = 250;
	}
	
	damageLevelChanged = vehicle::update_damage_fx_level( self.health, iDamage, self.healthdefault );
	
	if ( sMeansOfDeath != "MOD_MELEE_ASSASSINATE" && sMeansOfDeath != "MOD_UNKNOWN" && !enemyIsQuadtank( eAttacker ) )
	{	
//		healthPct = (self.health - iDamage) / self.healthdefault;
//		if( healthPct < 0.5 )
//		{
//			self thread quadtank_enable_assassination();
//		}
		
		if( self.damage_during_trophy_down + iDamage > self.settings.trophysystemdisablethreshold && self.trophy_disables < 4 && !isdefined(driver) )
		{
			iDamage = self.settings.trophysystemdisablethreshold - self.damage_during_trophy_down;
		}
		
		self.damage_during_trophy_down += iDamage;
	}
	else
	{
		//iDamage = 0;
	}
	
	if( damageLevelChanged && sMeansOfDeath != "MOD_MELEE_ASSASSINATE" )
	{
		self notify( "pain" );
	}

	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );
	
	return iDamage;
}

function quadtank_set_team( team )
{
	self.team = team;
	
	if( !self vehicle_ai::is_instate( "off" ) )
	{
		self vehicle_ai::blink_lights_for_time( 0.5 );
	}
}

function remove_repulsor()
{
	if( isdefined( self.missile_repulsor ) ) 
	{
		missile_deleteattractor( self.missile_repulsor );
		self.missile_repulsor = undefined;
	}
	self notify( "end_repulsor_fx" );
}

function repulsor_fx()
{
	self notify( "end_repulsor_fx" );
	self endon( "end_repulsor_fx" );
	self endon( "death" );
	self endon( "change_state" );
	
	while( 1 )
	{	
		self util::waittill_any( "projectile_applyattractor", "play_meleefx" );
		if ( vehicle_ai::IsCooldownReady("repulsorfx_interval") )
		{
			PlayFxOnTag( self.settings.trophyrepulsefx, self, "tag_body" );

			self vehicle::impact_fx( self.settings.trophyrepulsefx_ground );
			
			vehicle_ai::Cooldown( "repulsorfx_interval", 0.5 );

			self PlaySound( "wpn_trophy_alert" );

			LUINotifyEvent( &"weakpoint_update", 3, 3, self getEntityNumber(), &"tag_target_lower" );
		}
	}
}
		
function quadtank_projectile_watcher()
{
	if( !isdefined( self.missile_repulsor ) ) 
	{
		self.missile_repulsor = missile_createrepulsorent( self, 40000, self.settings.trophysystemrange, true );
	}
	self thread repulsor_fx();
}

function turn_off_laser_after( time )
{
	self notify( "turn_off_laser_thread" );
	self endon( "turn_off_laser_thread" );
	self endon( "death" );
	
	wait time;
	
	self LaserOff();
}



//self = turret/vehicle
function side_turret_is_target_in_view_score( v_target, n_index )
{
	s_turret = turret::_get_turret_data( n_index );
	
	v_pivot_pos = self GetTagOrigin( s_turret.str_tag_pivot );
	v_angles_to_target = VectorToAngles( v_target - v_pivot_pos );
	
	n_rest_angle_pitch = s_turret.n_rest_angle_pitch + self.angles[0];
	n_rest_angle_yaw = s_turret.n_rest_angle_yaw + self.angles[1];
	
	n_ang_pitch = AngleClamp180( v_angles_to_target[0] - n_rest_angle_pitch );
	n_ang_yaw = AngleClamp180( v_angles_to_target[1] - n_rest_angle_yaw );
	
	b_out_of_range = false;

	if ( n_ang_pitch > 0 )
	{
		if ( n_ang_pitch > s_turret.bottomarc )
		{
			b_out_of_range =  true;
		}
	}
	else
	{
		if ( Abs( n_ang_pitch ) > s_turret.toparc )
		{
			b_out_of_range =  true;
		}
	}
	
	if ( n_ang_yaw > 0 )
	{
		if ( n_ang_yaw > s_turret.leftarc )
		{
			b_out_of_range =  true;
		}
	}
	else
	{
		if ( Abs( n_ang_yaw ) > s_turret.rightarc )
		{
			b_out_of_range =  true;
		}
	}

	if( b_out_of_range )
	{
		return 0.0;
	}
	
	return ( Abs( n_ang_yaw ) / 90 * 800 );
}


function _get_best_target_quadtank_side_turret( a_potential_targets, n_index )
{
	e_best_target = undefined;
	f_best_score = 100000;		// lower is better
	
	s_turret = turret::_get_turret_data( n_index );

	foreach( e_target in a_potential_targets )
	{
		f_score = Distance( self.origin, e_target.origin );
		
		b_current_target = turret::is_target( e_target, n_index );
		
		if( b_current_target )
		{
			f_score -= 100;
		}
		
		if( isdefined( self.enemy ) && e_target == self.enemy )
		{
			f_score += 300;
		}
		
		if( IsSentient( e_target ) && e_target AttackedRecently( self, 2 ) )
		{
			f_score -= 200;
		}

		v_offset = turret::_get_default_target_offset( e_target, n_index );
			
		view_score = side_turret_is_target_in_view_score( e_target.origin + v_offset, n_index );
		
		if( view_score != 0.0 )
		{
			f_score += view_score;
			
			b_trace_passed = turret::trace_test( e_target, v_offset, n_index );
						
			if ( b_current_target && !b_trace_passed && !isdefined( s_turret.n_time_lose_sight ) )
			{
				s_turret.n_time_lose_sight = GetTime();
			}
			
			if( b_trace_passed )
			{
				f_score -= 500;
			}
		}
		else if ( b_current_target )
		{	
			s_turret.b_target_out_of_range = true;
			f_score += 5000;
		}
	
		if( f_score < f_best_score )
		{
			f_best_score = f_score;
			e_best_target = e_target;
		}
	}
	
	return e_best_target;
}

function quadtank_enable_assassination()
{
	self notify( "assassdisabled" );
	self endon( "assassdisabled" );
	
	self SetAssassinationEnabled( true );
	//self EnableAimAssist();
	self oed::enable_keyline( true );
	
	self waittill( "being_assassinate_start", attacker );

	self.being_assassinated = true;
	self SetTurretTargetRelativeAngles( (0,0,0) );	// Reset the turret angles so the animation lines up

	self waittill( "killme" );	// notetrack
	
	if( !isdefined( attacker ) )
		attacker = self.enemy;
	if( !isdefined( attacker ) )
		attacker = level.players[0];
	
	self DoDamage( self.health * 2, self.origin + (0,0,10), attacker, attacker, "", "MOD_MELEE_ASSASSINATE" );
}

function quadtank_disable_assassination()
{
	self notify( "assassdisabled" );
	self SetAssassinationEnabled( false );
	//self DisableAimAssist();
	self oed::disable_keyline();
}

function quadtank_weakpoint_display( state )
{
	If (!isdefined (self.spnsndEnt))
	{
		self.spnsndEnt = spawn( "script_origin", self.origin );
		self.spnsndEnt linkto( self, "tag_origin" );
	}

	if( self.displayweakpoint != state )
	{
		self.displayweakpoint = state;
		
		if( !self.displayweakpoint )
		{
			self.spnsndEnt stoploopsound (.1);
			self quadtank_remove_weakpoint_marker();
		}
		
		if( self.displayweakpoint )
		{
			self.spnsndEnt playloopsound ("wpn_trophy_spin_loop", .1);
			self quadtank_display_weakpoint_marker();
		}
	}
}


function quadtank_display_weakpoint_marker()
{
	if( self.displayweakpoint && self.combatactive && self.weakpointobjective !== 1 )
	{
		self.weakpointobjective = 1;
		LUINotifyEvent( &"weakpoint_update", 3, 1, self getEntityNumber(), &"tag_target_lower" );
	}
}


function quadtank_remove_weakpoint_marker()
{
	if( self.weakpointobjective === 1 )
	{
		self.weakpointobjective = 0;
		LUINotifyEvent( &"weakpoint_update", 3, 0, self getEntityNumber(), &"tag_target_lower" );
	}
}

function footstep_handler()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	while( 1 )
	{
		note = self util::waittill_any_return( "footstep_front_left", "footstep_front_right", "footstep_rear_left", "footstep_rear_right" );
		
		switch( note )
		{
			case "footstep_front_left":
			{
				bone = "tag_foot_fx_left_front";
				break;
			}
			case "footstep_front_right":
			{
				bone = "tag_foot_fx_right_front";
				break;
			}
			case "footstep_rear_left":
			{
				bone = "tag_foot_fx_left_back";
				break;
			}
			case "footstep_rear_right":
			{
				bone = "tag_foot_fx_right_back";
				break;
			}
		}
		
		position = self GetTagOrigin( bone ) + (0,0,15);
		
		self RadiusDamage( position, 60, 50, 50, self, "MOD_CRUSH" );
	}
}

function javeline_incoming(projectile)
{
	self endon( "entityshutdown" );
	self endon ("death");
	
		self waittill( "weapon_fired", projectile );
		
			distance = 1200;
			alais = "prj_quadtank_rocket_inc";
			players = level.players;
							
			while(isdefined(projectile) && isdefined( projectile.origin ))
			{
				if ( isdefined( players[0] ) && isdefined( players[0].origin ))
				{
					projectileDistance = DistanceSquared( projectile.origin, players[0].origin);
					
					if( projectileDistance <= distance * distance )
					{
						projectile playsound (alais);
						return;
					}
				}
				
				wait (.2);	
			}
	
}

function railgun_sound(projectile)
{
	self endon( "entityshutdown" );
	self endon ("death");
	
		self waittill( "weapon_fired", projectile );
		
			distance = 900;
			alais = "wpn_quadtank_railgun_fire_rocket_flux";
			players = level.players;
							
			while(isdefined(projectile) && isdefined( projectile.origin ))
			{
				if ( isdefined( players[0] ) && isdefined( players[0].origin ))
				{
					projectileDistance = DistanceSquared( projectile.origin, players[0].origin);
					
					if( projectileDistance <= distance * distance )
					{
						projectile playsound (alais);
						return;
					}
				}
				
				wait (.2);	
			}	
	
}


