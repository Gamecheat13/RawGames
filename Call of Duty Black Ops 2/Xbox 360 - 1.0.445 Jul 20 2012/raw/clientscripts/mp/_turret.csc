#include clientscripts\mp\_utility;

#insert raw\maps\mp\_clientflags.gsh;

#using_animtree ( "mp_microwaveturret" );

init()
{
	level._client_flag_callbacks["turret"][CLIENT_FLAG_MICROWAVE] = ::turret_microwave;
	level._client_flag_callbacks["turret"][CLIENT_FLAG_MICROWAVE_OPEN] = ::microwave_open_anim;
	level._client_flag_callbacks["turret"][CLIENT_FLAG_MICROWAVE_CLOSE] = ::microwave_close_anim;
	level._client_flag_callbacks["turret"][CLIENT_FLAG_MICROWAVE_DESTROY] = ::microwave_destroy_anim;
}

turret_microwave( localClientNum, set )
{
	if ( !set )
	{
		//println( "+++ stopping microwave line emitter" );
		self notify( "sound_stop" );
	}
	else 
	{
		self thread turret_microwave_sound( localClientNum );
	}
}

turret_microwave_sound( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "sound_stop" );

	//println( "+++ starting microwave line emitter" );

	origin = self GetTagOrigin( "tag_flash" );
	angles = self GetTagAngles( "tag_flash" );

	forward = AnglesToForward( angles );
	forward = VectorScale( forward, 750 );

	trace = BulletTrace( origin, origin + forward, false, self );

	start = origin;
	end = trace[ "position" ];
	
	self thread turret_microwave_sound_off( localClientNum, start, end );

	//Line( start, end, (1,0,0), 1, false, 10000 );

	self playsound ( 0, "wpn_micro_turret_start");
	soundLineEmitter( "wpn_micro_turret_loop", start, end );
	//iprintlnbold ("micro_on");
}


turret_microwave_sound_off( localClientNum, start, end )
{

	self waittill_any( "sound_stop", "entityshutdown" );
	playsound (0, "wpn_micro_turret_stop", start);
	soundStopLineEmitter ( "wpn_micro_turret_loop", start, end );
	//iprintlnbold ("micro_off");

}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
microwave_open_anim( localClientNum, set )
{
	self endon("entityshutdown");

	if ( !set )
		return;
	
	self UseAnimTree( #animtree );
	self SetAnim( %o_hpm_open, 1.0, 0.0, 1.0 );

}
//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
microwave_close_anim( localClientNum, set )
{	
	if ( !set )
		return;
	
	self UseAnimTree( #animtree );
	self SetAnim( %o_hpm_close, 1.0, 0.0, 1.0 );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
microwave_destroy_anim( localClientNum, set )
{

	self UseAnimTree( #animtree );
	self SetAnim( %o_hpm_destroyed, 1.0, 0.0, 1.0 );
}
