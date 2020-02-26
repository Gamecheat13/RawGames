#include clientscripts\_utility; 

#using_animtree("player");

init()
{
	clientscripts\_driving_fx::add_vehicletype_callback( "apc_cougar_player", ::cougar_setup );
}

//SELF = cougar
cougar_setup( localClientNum )
{
	self thread driving_anims();
	self thread clientscripts\_driving_fx::collision_thread( localClientNum );	
}

driving_anims()
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		//self waittill( "enter_vehicle", player );
		level waittill( "enter_cougar" );
		player = level.localplayers[0];
		
		viewarms = player spawn_player_arms();

		self thread steering_loop( viewarms );
		
		self waittill( "exit_vehicle" );
		
		viewarms delete();
	}
	
}
	
steering_loop( viewarms )
{
	self endon( "entityshutdown" );
	self endon( "exit_vehicle" );
	viewarms endon( "entityshutdown" );
	level endon( "save_restore" );

	cougar_anim = %vehicles::v_la_04_01_drive_leftturn_cougar;
	viewarms_anim = %player::ch_la_04_01_drive_leftturn_player;
	
	self SetAnim( cougar_anim, 1, 0, 0 );
	
	// magic wait before setting the anim tree otherwise code thinks the viewarms don't have a model
	wait .05;
	
	viewarms UseAnimTree( #animtree );
	viewarms SetAnim( viewarms_anim, 1, 0, 0 );
	viewarms Linkto( self, "tag_arms" );
	
	time = 0.5;
	max_delta_t = 0.03;
	
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
		
		self SetAnimTime( cougar_anim, time );
		viewarms SetAnimTime( viewarms_anim, time );
		
		wait 0.01;
	}
}