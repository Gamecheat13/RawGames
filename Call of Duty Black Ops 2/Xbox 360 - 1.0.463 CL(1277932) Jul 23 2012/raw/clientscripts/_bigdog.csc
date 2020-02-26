#include clientscripts\_utility; 
#include clientscripts\_audio;

#using_animtree("vehicles");

autoexec init()
{
	/#
	println("*** Client : _bigdog running...");
	#/
	
	clientscripts\_driving_fx::add_vehicletype_callback( "drone_claw", ::bigdog_setup );
	clientscripts\_driving_fx::add_vehicletype_callback( "drone_claw_wflamethrower", ::bigdog_setup );
	clientscripts\_driving_fx::add_vehicletype_callback( "drone_claw_rts", ::bigdog_setup );
	
	clientscripts\_footsteps::registerVehicleFootStepCallback( "drone_claw", ::bigdog_feet );
	clientscripts\_footsteps::registerVehicleFootStepCallback( "drone_claw_wflamethrower", ::bigdog_feet );
	clientscripts\_footsteps::registerVehicleFootStepCallback( "drone_claw_rts", ::bigdog_feet );
}

bigdog_setup( localClientNum )
{
	self thread clientscripts\_driving_fx::collision_thread( localClientNum );
	//self thread clientscripts\_driving_fx::jump_landing_thread( localClientNum );
		
	self thread bigdog_mount();	
}

bigdog_feet( localClientNum, note, ground_type )
{
	origin = self.origin;
	
	sound_alias = "fly_step_run_bigdog"; //+ note; //+ "_" + ground_type;
	
	/*	
	if ( self IsLocalClientDriver( localClientNum ) )
	{
		sound_alias += "_plr";
	}
	
	else
	{
		sound_alias += "_npc";
	}	
	*/
	sound_alias = sound_alias + "_" + ground_type;	
		
	PlaySound( localClientNum, sound_alias, origin );
	
	if ( IsDefined( level.player_bigdog ) && self == level.player_bigdog )
	{
		//if ( note == "footstep_front_left" || note == "footstep_rear_left" || 
		//    note == "footstep_front_right" || note == "footstep_rear_right" )
		{
			player = getlocalplayer( localClientNum );	
			player PlayRumbleOnEntity( localClientNum, "pullout_small" );
			
			speed = self GetSpeed() / 17.6;
			speed = Abs( speed ) / 9.0;
			
			intensity = 0.065 + ( 0.065 * speed );
			if( intensity > 0.001 )
			{
				player Earthquake(intensity, 0.3, self.origin, 200);
			}
		}
	}
}

bigdog_mount( localClientNum )
{
	self endon( "death" );
	self endon( "entityshutdown" );
	
	while ( 1 )
	{
		self waittill( "enter_vehicle", user );
		//SOUND - Shawn J
		playsound(0, "veh_claw_plr_enter");	
		soundloopemitter( "veh_claw_plr_loop", (0,0,0) );		
		if ( user isplayer() )
		{
			level.player_bigdog = self;
			wait( 0.5 );	// to prevent getting an early exit notify

			self waittill( "exit_vehicle" );
			//SOUND - Shawn J
			playsound(0, "veh_claw_plr_exit");	
			soundstoploopemitter( "veh_claw_plr_loop", (0,0,0) );
			level.player_bigdog = undefined;
		}
	}
}

