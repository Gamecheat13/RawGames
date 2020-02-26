#include clientscripts\_utility; 

#using_animtree("player");

init()
{
	clientscripts\_driving_fx::add_vehicletype_callback( "boat_soct_player", ::soct_setup );
	
	clientscripts\_driving_fx::add_vehicletype_callback( "boat_soct_allies", ::update_wheels_animation );
	clientscripts\_driving_fx::add_vehicletype_callback( "boat_soct_axis", ::update_wheels_animation );
}

//SELF = soct
soct_setup( localClientNum )
{
	self thread driving_anims();
//	self thread update_rumble();
	self thread clientscripts\_driving_fx::collision_thread( localClientNum );
	self thread update_wheels_animation( localClientNum );	
}

soct_save_restore()
{
	if ( IsDefined( level.vh_player_soct ) )
	{
		player = level.localplayers[0];	
		
		level notify( "soct_restore" );
		
		if ( IsDefined( level.vh_player_soct.steering_wheel ) )
		{
			level.vh_player_soct.steering_wheel Unlink();
			level.vh_player_soct.steering_wheel Delete();			
		}
		
		if ( IsDefined(	level.vh_player_soct.viewarms ) )
		{
			level.vh_player_soct.viewarms delete();	
		}
		
		level.vh_player_soct thread driving_anims();
		level.vh_player_soct thread clientscripts\_driving_fx::collision_thread( player GetLocalClientNumber() );
		level.vh_player_soct thread update_wheels_animation( player GetLocalClientNumber() );				
	}
}

driving_anims()
{
	self endon( "entityshutdown" );
	level endon( "save_restore" );
	level endon( "soct_restore" );
	
	while( 1 )
	{
		//self waittill( "enter_vehicle", player );
		level waittill( "enter_soct" );
		
		player = level.localplayers[0];
		
		level.vh_player_soct = self;
		
		// spawn the arms
		if ( !IsDefined( level.vh_player_soct.viewarms ) )
			level.vh_player_soct.viewarms = player spawn_player_arms();
		
		// Spawn the steering wheel
		if ( !IsDefined( level.vh_player_soct.steering_wheel ) )
		{
			level.vh_player_soct.steering_wheel = Spawn( player GetLocalClientNumber(), player GetOrigin() + ( 0, 0, -1000 ), "script_model" );
			level.vh_player_soct.steering_wheel SetModel( "veh_t6_mil_soc_t_steeringwheel" );
			level.vh_player_soct.steering_wheel LinkTo( level.vh_player_soct.viewarms, "tag_weapon" );
		}

		self thread steering_loop( level.vh_player_soct.viewarms );
		
		self waittill( "exit_vehicle" );
		
		if ( IsDefined( level.vh_player_soct ) )
		{
			level.vh_player_soct.steering_wheel Unlink();
			level.vh_player_soct.steering_wheel Delete();
		
			level.vh_player_soct.viewarms delete();	
			level.vh_player_soct = undefined;		
		}
	}
	
}
	
steering_loop( viewarms )
{
	self endon( "entityshutdown" );
	self endon( "exit_vehicle" );
	viewarms endon( "entityshutdown" );
	level endon( "save_restore" );
	level endon( "soct_restore" );

	//soct_anim = %vehicles::v_la_04_01_drive_leftturn_cougar;
	//viewarms_anim = %player::int_boat_turn_right;
	viewarms_anim = %player::int_boat_handover_turn_left;	
	
	//self SetAnim( soct_anim, 1, 0, 0 );
	
	// magic wait before setting the anim tree otherwise code thinks the viewarms don't have a model
	wait .05;
	
	viewarms UseAnimTree( #animtree );
	viewarms SetAnim( viewarms_anim, 1, 0, 0 );
		
	viewarms Linkto( self, "tag_driver", ( -20, -15, -13 ) );
	
	time = 0.5;
	max_delta_t = 0.0045;
	
	while( IsDefined(self) )
	{
		target_time = self GetSteering() + 1;
		target_time *= 0.5;
		
		delta_change = target_time - time;
		if( delta_change > max_delta_t )
		{
			delta_change = max_delta_t;
		}
		else if( delta_change < -max_delta_t )
		{
			delta_change = -max_delta_t;
		}
		
		time += delta_change;
		
		if( time > 1 )
		{
			time = 1;
		}
		else if( time < 0 )
		{
			time = 0;
		}	
		
		//self SetAnimTime( soct_anim, time );
		viewarms SetAnimTime( viewarms_anim, time );
		
		wait 0.01;
	}
}

set_soct_boost( enable )
{
	if ( !IsDefined( level.vh_player_soct ) || !IsDefined( level.vh_player_soct.viewarms) )
		return;
	
	if ( enable == 1 )
	{
		level.vh_player_soct.viewarms SetAnim( %player::int_boat_boost_press, 1, 0.1, 3 );
	}
	else
	{
		level.vh_player_soct.viewarms ClearAnim( %player::int_boat_boost_press, 0.1 );			
	}	
}
	
#define WHEELS_DOWN 0
#define WHEELS_UP 1

// Self should be the SOC-T
update_wheels_animation( localClientNum )
{
	self endon( "death" );
	self endon( "entityshutdown" );	
	level endon( "save_restore" );	
	
	self.wheels_state = WHEELS_DOWN;
	
	wait .05;	
	
	while ( 1 )
	{
		if ( !IsDefined( self ) )
			return;
		
		if ( self IsVehicleInWater() )
		{
			if ( self.wheels_state == WHEELS_DOWN )
			{
				//self ClearAnim( %vehicles::v_soct_wheels_down, 0.2 );				
				self SetAnim( %vehicles::v_soct_wheels_up, 1, 0.2, 1 );
				self.wheels_state = WHEELS_UP;
				
				if ( IsDefined(	level._effect[ "soct_water_splash" ] ) )
					PlayFxOnTag( localClientNum, level._effect[ "soct_water_splash" ], self, "tag_body" );
				
				if ( IsDefined( level.vh_player_soct ) && self == level.vh_player_soct )
				{
					//level.localplayers[0] Earthquake( 0.5, 2.0, self.origin, 200 );
					//level.localplayers[0] PlayRumbleOnEntity( 0, "damage_heavy" );
				}
			}
		}
		else
		{
			if ( self.wheels_state == WHEELS_UP )
			{
				self ClearAnim( %vehicles::v_soct_wheels_up, 0.5 );					
				//self SetAnim( %vehicles::v_soct_wheels_down, 1, 0.2, 1 );
				self.wheels_state = WHEELS_DOWN;
			}			
		}
		
		wait( 0.05 );
	}
}

// Lots of gross hardcoded values! :( 
update_rumble()
{
	self endon( "death" );
	self endon( "entityshutdown" );	
	self endon( "exit_vehicle" );
	level endon( "save_restore" );

	while ( 1 )
	{
		vr = Abs( self GetSpeed() / self GetMaxSpeed() );
		
		if ( vr < 0.1 )
		{
			level.localplayers[0] PlayRumbleOnEntity( 0, "pullout_small" );		
			wait( 0.3 );						
		}
		else if ( vr > 0.01 && vr < 0.8 || Abs( self GetSteering() ) > 0.5 )
		{
			level.localplayers[0] Earthquake( 0.1, 0.1, self.origin, 200 );			
			level.localplayers[0] PlayRumbleOnEntity( 0, "pullout_small" );		
			wait( 0.1 );			
		}
		else if ( vr > 0.8 )
		{
			time = RandomFloatRange( 0.15, 0.2 );
			level.localplayers[0] Earthquake( RandomFloatRange( 0.1, 0.15 ), time, self.origin, 200 );
			level.localplayers[0] PlayRumbleOnEntity( 0, "pullout_small" );		
			wait( time );							
		}
		else
		{
			wait( 0.1 );
		}
	}
}

