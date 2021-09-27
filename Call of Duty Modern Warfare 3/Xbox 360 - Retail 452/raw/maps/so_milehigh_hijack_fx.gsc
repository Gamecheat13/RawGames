main()
{
	thread precache_createfx_fx();
}

precache_createfx_fx()
{
	if(IsDefined(level.no_slowmo) && level.no_slowmo)
	{
		level._effect[ "conference_room_breach_specops_slow" ]					= loadfx( "maps/hijack/conference_room_breach_specops_no_slowmo" );
	}
	else
	{
		level._effect[ "conference_room_breach_specops_slow" ]					= loadfx( "maps/hijack/conference_room_breach_specops_slow" );
	}
}