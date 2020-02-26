// _meatshield.csc

#include clientscripts\_utility;
#include clientscripts\_clientfaceanim;

main()
{
	init_flags();
	_meatshield_flag_funcs();
}

init_flags()
{
	// Client Flags -- Match these in _meatshield.gsc
	level.CLIENT_ENABLE_EAR_BLOOD			= 0;
}

_meatshield_flag_funcs()
{
	register_clientflag_callback("actor", level.CLIENT_ENABLE_EAR_BLOOD, ::actor_flag_meatshield_earblood_handler);
}

actor_flag_meatshield_earblood_handler(localClientNum, set, newEnt)
{
	
	init_shaderconstants(localClientNum);
	
	println("client flag callback good");
	self _meatshield_enable_ear_blood(localClientNum, set);
}

init_shaderconstants(localClientNum)
{
	self mapshaderconstant( localClientNum, 0, "scriptVector0" ); // x = dimSpecular and y = wetness 0 to 0.83
}

_meatshield_enable_ear_blood(localClientNum, set)
{	
	dimSpecular = 0;
	println("in set of meatshield_enable_ear_blood");
	
	if(set)
	{
		wetness = 0;
		while(wetness < 0.83)
		{
			wetness += 0.01;
			self setshaderconstant( localClientNum, 0, dimSpecular, wetness, 0, 0 ); // dimSpecular should be 0 always for now
			wait(0.1);
		}			
	}
}
