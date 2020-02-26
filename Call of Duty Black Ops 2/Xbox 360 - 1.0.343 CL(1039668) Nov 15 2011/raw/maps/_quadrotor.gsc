#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_statemachine;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_statemachine.gsh;

init()
{
	vehicle_add_main_callback( "heli_quadrotor", ::quadrotor_think );
}

quadrotor_think()
{
	self EnableAimAssist();
	self SetHoverParams( 15.0, 60.0, 40 );
	self SetVehGoalPos( self.origin, true );

	self.state_machine = create_state_machine( "brain", self );
	state_fixed_fire = self.state_machine add_state( "fixed_fire", undefined, undefined, ::quadrotor_fixed_fire, undefined, undefined );
	
	// Set the first state
	self.state_machine set_state( "fixed_fire" );
	
	// start the update
	self.state_machine update_state_machine();
}

quadrotor_fixed_fire()
{
	self endon( "death" );
	self endon( "change_state" );
	
	while( 1 )
	{
		if( IsDefined( self.enemy ) )
		{
			if( self VehCanSee( self.enemy ) )
			{
				self SetTurretTargetEnt( self.enemy, ( 0, 0, RandomIntRange( 10, 60) ) );
				self thread maps\_turret::fire_turret_for_time( 0.5, 0 );
				wait( 0.5 );
			}
			else
			{
				wait 2;
			}
		}
		
		wait 0.5;
	}
}