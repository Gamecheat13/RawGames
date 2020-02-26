main()
{
	self endon("killanimscript");
	self endon( "stop_flashbang_effect" );

	wait randomfloatrange( 0, 0.4 );
	
	duration = self startFlashBanged() * 0.001;
	
	self setanimstate( "flashed" );
	self maps\mp\animscripts\shared::DoNoteTracks("done");
	
	self setFlashBanged( false );
	
	self.flashed = false;
	self notify( "stop_flashbang_effect" );
}

startFlashBanged()
{
	if ( isdefined( self.flashduration ) )
		duration = self.flashduration;
	else
		duration = self getFlashBangedStrength() * 1000;
	
	self.flashendtime = gettime() + duration;
	self notify("flashed");
	
	return duration;
}
