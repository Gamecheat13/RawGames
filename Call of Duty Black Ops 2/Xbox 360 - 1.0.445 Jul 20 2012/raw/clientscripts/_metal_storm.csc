#include clientscripts\_utility; 

#using_animtree("vehicles");

autoexec init()
{
	println("*** Client : _metalstorm running...");
	
	clientscripts\_driving_fx::add_vehicletype_callback( "drone_metalstorm", ::metalstorm_setup );
	clientscripts\_driving_fx::add_vehicletype_callback( "drone_metalstorm_rts", ::metalstorm_setup );
}

metalstorm_setup( localClientNum )
{
	self thread clientscripts\_driving_fx::collision_thread( localClientNum );
		
	self thread metalstorm_player_enter();
}

metalstorm_player_enter( localClientNum )
{
	self endon( "death" );
	self endon( "entityshutdown" );

	while ( 1 )
	{
		self waittill( "enter_vehicle", user );

		if ( user isplayer() )
		{
			level.player_metalstorm = self;
			wait( 0.1 );	// to prevent getting an early exit notify
			
			// Update feedback
			self thread metalstorm_update_rumble();									

			self waittill( "exit_vehicle" );

			level.player_metalstorm = undefined;
		}
	}
}

// Lots of gross hardcoded values! :( 
metalstorm_update_rumble()
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

