#include clientscripts\_utility; 

#using_animtree("player");


//SELF = cougar
init()
{
	clientscripts\_driving_fx::add_vehicletype_callback( "spiderbot", ::drive_spiderbot );
	clientscripts\_driving_fx::add_vehicletype_callback( "spiderbot_large", ::drive_spiderbot );
}


//
//
drive_spiderbot( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "enter_vehicle", player );
		
		//TODO: Get this to work in the vehicle GDT, somehow overcoming the lack of wheels
		if( isdefined( level._audio_spiderbot_override ) )
		{
			self thread [[level._audio_spiderbot_override]](player);
		}

		// This compass isn't working they way it needs to.		
		// Create the compass
//		spider_compass = Spawn( player GetLocalClientNumber(), player GetOrigin(), "script_model" );
//		spider_compass SetModel( "veh_t6_spider_large" );
//		spider_compass LinkToCamera( 5, (15, -11, -7) );

		self thread spiderbot_light( player );
		
		self waittill( "exit_vehicle" );

		if ( IsDefined( self.m_light_fx ) )
		{
			self.m_light_fx Delete();
		}
//		spider_compass delete();
	}
}


//
//	Control the spiderbot's light turning on and off
//	"spiderbot_light" is set and cleared in radiant.
//	self is the spiderbot
spiderbot_light( player )
{
	level endon( "exit_vehicle" );
	level endon( "spiderbot_end" );

	n_client = player GetLocalClientNumber();
	
	while (1)
	{
		level waittill( "spiderbot_light_on" );

		v_camerapos = self get_eye();
		self.m_light_fx = Spawn( n_client, v_camerapos, "script_model" );
		self.m_light_fx SetModel( "tag_origin" );
		self.m_light_fx.angles = player GetPlayerAngles();
		self.m_light_fx LinkToCamera();
		PlayFXOnTag( n_client, level._effect["spiderbot_light"], self.m_light_fx, "tag_flash" );

		level waittill( "spiderbot_light_off" );
		
		// Flag has been cleared
		if ( IsDefined( self.m_light_fx ) )
		{
			self.m_light_fx Delete();
		}
	}
}
