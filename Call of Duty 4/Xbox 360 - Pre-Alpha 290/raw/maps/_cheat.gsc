#include common_scripts\utility;
#include maps\_utility;

slowmo_main()
{
	level.slowmo = spawnstruct();
	//if you want to change the global slowmo speed - change it here.
	flag_init( "global_slowmo_button_released" );
	flag_set( "global_slowmo_button_released" );
	
	// this can never be lower the level.slowmo.lerp_time_out or level.slowmo.lerp_time_in
	// this is the time between button presses that we take action
	level.slowmo.buffer_time_between_button_press = .1; 
	level.slowmo.lerp_time_in = 0.0;
	level.slowmo.lerp_time_out = .75;
	level.slowmo.speed_slow = 0.4;
	
	
	level.slowmo.speed_norm = 1.0;
	level.slowmo.speed_current = level.slowmo.speed_norm;	
	level.slowmo.lerp_time_curr = level.slowmo.lerp_time_in;
	level.slowmo.lerp_interval = .05;//server frame
	level.slowmo.lerping = 0;
	
	level.slowmo thread gamespeed_proc();
}

gamespeed_proc()
{
	while(1)
	{
		flag_wait( "global_slowmo_button_released" );
		
		while ( !level.player buttonPressed( "BUTTON_RSTICK" ) )
			wait ( 0.05 );
		
		flag_clear( "global_slowmo_button_released" );
		self thread gamespeed_release_button();
					
		if( self.speed_current < level.slowmo.speed_norm )
			self thread gamespeed_reset();
		
		else
			self thread gamespeed_slowmo();
		
		waittillframeend;
		
		//now wait for the right amount of time before even checking again for a button press
	//	while( self.lerping > ( level.slowmo.lerp_time_curr - self.buffer_time_between_button_press ) )
	//		wait self.lerp_interval;
	}
}

gamespeed_release_button()
{
	while ( level.player buttonPressed( "BUTTON_RSTICK" ) )
		wait ( 0.05 );
	
	flag_set( "global_slowmo_button_released" );
}

gamespeed_set( speed, refspeed, lerp_time )
{
	self notify("gamespeed_set");
	self endon("gamespeed_set");
	
	//we're going to calculate the time to lerp to the new speed
	//if we dont define a time then we want to know how long it should
	//take from our current speed to lerp to the default normal or slowmo
	//this way if the player wants to come out of slowmo before he's finishing
	//going in, it only takes a fraction of time to come out instead taking
	//the same ammount as if he was all the way into slow mo.
	
	default_range 	= ( speed - refspeed );
	actual_range 	= ( speed - self.speed_current );
	actual_rangebytime = actual_range * lerp_time;
	
	time 			= ( actual_rangebytime / default_range ); 
	
	interval 		= self.lerp_interval; // serverframe
	cycles 			= int( time / interval );
	if(!cycles)
		cycles = 1;
	increment 		= ( actual_range / cycles );
	self.lerping 	= time;
	
	while(cycles)
	{
		self.speed_current += increment;
		settimescale( self.speed_current );
		cycles--;	
		self.lerping -= interval;

		wait interval;
	}		
	
	self.speed_current = speed;
	settimescale( self.speed_current );
	
	self.lerping = 0;
	
}

gamespeed_slowmo()
{
	self.lerp_time_curr = self.lerp_time_in;
	gamespeed_set( self.speed_slow, self.speed_norm, self.lerp_time_in );
}

gamespeed_reset()
{	
	self.lerp_time_curr = self.lerp_time_out;
	gamespeed_set( self.speed_norm, self.speed_slow, self.lerp_time_out );
}