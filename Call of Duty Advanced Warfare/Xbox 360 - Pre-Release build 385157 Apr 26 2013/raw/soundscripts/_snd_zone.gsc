
/* 
 * _snd_zone.gsc
 * 
 * This scriptfile is for handling sound zones.
 * 
 */ 
 
 #include soundscripts\_audio_zone_manager;

snd_trigger_zone()
{
	assert( IsDefined( self.script_zones ) );
	
	// get array of sound zones
	self.zones = strtok( self.script_zones );
	
	// if only one zone is defined, then this is a single zone trigger
	if ( self.zones.size == 1 )
	{
		thread snd_trigger_single_zone_monitor();
		return;
	}
	
	assertEx( self.zones.size == 2, "snd_trigger_zone(): can only have 1 or 2 sound zones defined." );

	
	
}

snd_trigger_single_zone_monitor()
{
	while ( true )
	{
		self waittill( "trigger", other );
		AZM_start_zone( self.zones[0], self.script_duration );
	}	
}

