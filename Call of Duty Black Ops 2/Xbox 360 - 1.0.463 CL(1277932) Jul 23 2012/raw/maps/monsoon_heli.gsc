#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_dialog;

//self is the main helicopter the player fights through the ruins
heli_main_think()
{
	level.vh_heli = self;
	
	self SetSpeed( 5 );
	self SetForceNoCull();
	self thread heli_spotlight();
	self thread heli_monitor_health();
	Target_Set( self, (0, 0, -60 ) );
	self heli_weapons_bay_close();
		
	flag_wait( "squad_reached_helipad" );
	
	wait 6;
	
	self thread heli_adjust_pitch_down( 0, 20 );
	self vehicle_liftoff();
	
	wait 2;
	self heli_weapons_bay_open();
	wait 2;
	
	tracker = magic_heli_missile( 1, getstruct( "helipad_missile_target_1", "targetname" ).origin );
	tracker waittill( "death" );
	level notify( "fxanim_lion_statue_01_start" );
	wait 0.5;
	magic_heli_missile( 2, getstruct( "helipad_missile_target_2", "targetname" ).origin );
	
	wait 1;
	
	self maps\_turret::enable_turret( 0 );
	self thread heli_turn_think();
	self thread heli_move_think();

	wait 10;
	
	flag_set( "heli_retreat_to_ruins" );
}

magic_heli_missile( n_turret, v_end )
{
	if( n_turret == 1 )
	{
		v_start = self GetTagOrigin( "tag_flash_gunner1" );
	}
	else
	{
		v_start = self GetTagOrigin( "tag_flash_gunner2" );
	}
	return MagicBullet( "future_rockets", v_start, v_end, self );
}

heli_spotlight()
{
	self ent_flag_init( "spotlight_destroyed" );
	self play_fx( "heli_spotlight", self GetTagOrigin( "barrel_animate_jnt" ), self GetTagAngles( "barrel_animate_jnt" ), "stop_light", true, "barrel_animate_jnt" );

	self ent_flag_wait( "spotlight_destroyed" );
	
	self.v_gun_offset = ( 0, 0, 0 );
	self play_fx( "titus_detonate", self GetTagOrigin( "tag_barrel" ), self GetTagAngles( "tag_barrel" ), undefined, true, "tag_barrel" );
	self notify( "stop_light" );
}

heli_landing_gear_down()
{
	self SetAnim( %vehicles::veh_anim_future_heli_geardown, 1.0, 0.0, 1.0 );	
}

heli_weapons_bay_close()
{
	self SetAnim( %vehicles::veh_anim_future_heli_bay_closed, 1.0, 0.0, 1.0 );	
}

heli_weapons_bay_open()
{
	self SetAnimKnob( %vehicles::veh_anim_future_heli_bay_open, 1.0, 0.0, 1.0 );	
}

//self is the helicopter, keeps track of it's health and progress it along events
#define DAMAGE_TO_RETREAT 3000
#define HELICOPTER_HEALTH 30000
heli_monitor_health()
{
	self.health = HELICOPTER_HEALTH;
	n_damage = HELICOPTER_HEALTH - DAMAGE_TO_RETREAT;

	//helicopter takes enough damage or the player is close to the outer ruins
	while( ( self.health > n_damage ) && !flag( "heli_retreat_to_ruins" ) )
	{
		wait 0.5;
	}
	
	//set this flag in case it was done through damage to the helicopter
	flag_set( "heli_retreat_to_ruins" );
	
	//helicopter retreats to the outer ruins
	self veh_magic_bullet_shield( true );
	self SetSpeed( 20 );
	self maps\_turret::disable_turret( 0 );
	self ClearLookAtEnt();
		
	s_path = getstruct( "heli_retreat_path", "targetname" );
	while( IsDefined( s_path.target ) )
	{
		self SetVehGoalPos( s_path.origin );
		self waittill_any( "goal", "near_goal" );
		s_path = getstruct( s_path.target, "targetname" );
	}	
	
	self thread heli_monitor_health_ruins();
}

//self is the helicopter, lerps the pitch of self to the new value
heli_adjust_pitch_down( n_start_pitch, n_end_pitch )
{
	self endon( "death" );
	self endon( "delete" );
	
	//set pitch down when we fire
	assert( n_end_pitch > 0, "mod pitch must be > 0" );
	assert( n_end_pitch > n_start_pitch, "mod pitch must be > default" );
	
	n_cur_pitch = n_start_pitch;
	
	while( n_end_pitch > n_cur_pitch )
	{
		self SetDefaultPitch( n_cur_pitch );
		wait 0.05;
		n_cur_pitch += 0.15;
	}	
}

//self is the helicopter, handles it's movement until it retreats to the outer ruins
heli_move_think()
{
	self SetSpeed( 20, 8, 8 );
	self SetNearGoalNotifyDist( 400 );
	self SetHoverParams( 50 );
	
	a_s_positions = getstructarray( "heli_pos_helipad", "targetname" );
	s_goal_prev = a_s_positions[0];
	s_goal_curr = a_s_positions[0];
	
	while( !flag( "heli_retreat_to_ruins" ) )
	{
		//find a new goal that is not the last one
		while( s_goal_prev == s_goal_curr )
		{
			s_goal_curr = a_s_positions[ RandomInt( a_s_positions.size ) ];
		}
		
		//record the new goal as the last one
		s_goal_prev = s_goal_curr;
		
		self SetVehGoalPos( s_goal_curr.origin );
		self waittill_any( "goal", "near_goal" );
		
		wait RandomFloatRange( 5.0, 10.0 );
		
	}
}

//self is the helicopter, makes it turn towards what it is shooting at
heli_turn_think()
{
	while( !flag( "heli_retreat_to_ruins" ) )
	{
		if( self does_turret_have_target( 0 ) )
		{
			e_target = self get_turret_target( 0 );
			self SetLookAtEnt( e_target );
		}
		
		wait 5.0;
	}
}

//self is the helicopter
heli_monitor_health_ruins()
{
	self thread heli_move_think_ruins();
	self.overrideVehicleDamage = ::HeliRuinsCallback_VehicleDamage;
	
	flag_wait( "player_has_emp" );
	
	//move the helicopter to the start of it's death spline/animation clearing it's current goal
	s_pos = getstruct( "heli_pos_final", "targetname" );
	self.origin = s_pos.origin + ( 80, 80, 80 );
	self SetVehGoalPos( s_pos.origin );
	
	//have Salazar and Crosby take cover in the right direction
	trigger_use( "heli_color_east", "script_noteworthy" );
	
	//wait for the emp blast
	level waittill( "emp" );

	self ent_flag_set( "spotlight_destroyed" );
	set_objective( level.OBJ_DESTROY_HELI, undefined, "done" );
	flag_set( "helicopter_destroyed" );
		
	self maps\_turret::disable_turret( 0 );
	self.drivepath = false;
	self ClearLookAtEnt();
	self SetPathTransitionTime( 5 );
	self thread go_path( GetVehicleNode( "heli_crash_path", "targetname" ) );
	
	self waittill( "fire_missile_1" );
	self thread heli_ruins_left();
	
	self waittill( "fire_missile_2" );
	self thread heli_ruins_right();
	
	self waittill( "reached_end_node" );
	
	self vehicle_toggle_sounds (0);
	
	self.script_nocorpse = true;
	self veh_magic_bullet_shield( false );
	self notify( "death" );
	self SetRotorSpeed( 0 );
	self veh_toggle_tread_fx( false );
	
	//swap models of the gate
	m_destroyed = GetEnt( "ruins_gate_destroyed", "targetname" );
	m_pristine = GetEnt( "ruins_gate_pristine", "targetname" );
	//m_destroyed Show();
	m_pristine Delete();
	
	level notify( "fxanim_helo_arch_start" );
	
	//rumble and shake!
	Earthquake( 0.8, 0.5, level.player.origin, 500 );
	level.player PlayRumbleOnEntity( "artillery_rumble" );	
	
	wait 0.5;
	flag_set( "helicopter_crash_done" );
	//SOUND - Shawn J
	//iprintlnbold ("heli_destroyed");
	//self ClearClientFlag(2);
	self vehicle_toggle_sounds (0);
}

heli_ruins_left()
{
	e_missile = magic_heli_missile( 2, getstruct( "heli_death_missile_1", "targetname" ).origin );
	e_missile waittill( "death" );
	m_ruins = GetEnt( "rocket_ruin_left", "targetname" );
	m_ruins Delete();
}

heli_ruins_right()
{
	e_missile = magic_heli_missile( 1, getstruct( "heli_death_missile_2", "targetname" ).origin );
	e_missile waittill( "death" );
	m_ruins = GetEnt( "rocket_ruin_right", "targetname" );
	m_ruins Delete();
}

//self is the helicopter, handles it's movement until death
heli_move_think_ruins()
{
	e_look = GetEnt( "heli_ruins_target", "targetname" );
	str_prev_color = "heli_color_east";
	
	self SetSpeed( 15, 8, 8 );
	self SetNearGoalNotifyDist( 300 );
	self SetHoverParams( 50 );
	
	self SetLookAtEnt( e_look );
	
	flag_wait( "player_reached_outer_ruins" );
	
	//shoot missiles at the archway
	magic_heli_missile( 1, getstruct( "outer_ruins_missile_target_1", "targetname" ).origin );
	wait 0.5;
	magic_heli_missile( 2, getstruct( "outer_ruins_missile_target_2", "targetname" ).origin );
	level thread heli_destroy_archway();
	
	self thread heli_shoot_think_ruins();
	
	a_s_positions = getstructarray( "heli_pos_ruins", "targetname" );
	s_goal_curr = a_s_positions[0];
	
	while( !flag( "player_has_emp" ) )
	{
		a_goals = get_array_of_closest( s_goal_curr.origin, a_s_positions, array( s_goal_curr ), 2 );

		if( cointoss() )
			s_goal_curr = a_goals[0];
		else
			s_goal_curr = a_goals[1];
		
		self SetVehGoalPos( s_goal_curr.origin );
		self waittill_any( "goal", "near_goal" );
		
		if( IsDefined( s_goal_curr.script_noteworthy ) && s_goal_curr.script_noteworthy != str_prev_color )
		{
			trigger_use( s_goal_curr.script_noteworthy, "script_noteworthy" );
			str_prev_color = s_goal_curr.script_noteworthy;
		}
		
		wait RandomFloatRange( 1.0, 2.0 );
	}
	
	flag_wait( "helicopter_destroyed" );
	
	self ClearLookAtEnt();
	e_look Delete();
}

heli_destroy_archway()
{
	e_volume = GetEnt( "volume_heli_boss", "targetname" );
	
	while( 1 )
	{
		if( level.player IsTouching( e_volume ) &&
		   level.harper IsTouching( e_volume ) &&
		   level.salazar IsTouching( e_volume ) &&
		   level.crosby IsTouching( e_volume ) )
		{
			//time to allow last person to make it through
			wait 2;
			
			m_archway = GetEnt( "heli_rocket_gate_collapse", "targetname" );
			m_archway trigger_on();
			m_archway DisconnectPaths();

			level thread heli_fail_check();			
			return;
		}
		wait 0.05;
	}
}

//self is the helicopter
heli_shoot_think_ruins()
{	
	level endon( "helicopter_destroyed" );
	
	self.v_gun_offset = undefined;

	while( 1 )
	{
		self maps\_turret::enable_turret( 0, undefined, self.v_gun_offset );
	
		wait RandomFloatRange( 5.0, 8.0 );
		
		self maps\_turret::disable_turret( 0 );
				
		self FireGunnerWeapon(0);
		wait 0.5;
		self FireGunnerWeapon(1);	
	}
}

heli_fail_check()
{
	e_volume = GetEnt( "volume_heli_boss", "targetname" );
	
	while( !flag( "helicopter_destroyed" ) )
	{
		if( !level.player IsTouching( e_volume ) )
		{
			MissionFailed();
		}
		wait 1;
	}
}

//overrides the damage on the helicopter once the player is in the ruins
HeliRuinsCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if( eAttacker == level.player )
	{
		if( partName == "barrel_animate_jnt" && !self ent_flag( "spotlight_destroyed" ) )
		{
			self ent_flag_set( "spotlight_destroyed" );
		}
	
		if( partName == "tag_cockpit" )
		{
			iDamage = 0;
		}
	}
	
	iDamage = 0;
	return iDamage;
}