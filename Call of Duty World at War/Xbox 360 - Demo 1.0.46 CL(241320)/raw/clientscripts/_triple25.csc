// _triple25.csc
// Sets up clientside behavior for the triple25

#include clientscripts\_vehicle;
#include clientscripts\_music;

main(model,type)
{
	
	//build_exhaust( model, "vehicle/exhaust/fx_exhaust_t97" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "triple25" );
	
}

triple25_shoot()
{
	notifystring = "25s"+self getentitynumber();
	level endon(notifystring);
	self endon( "entityshutdown" ); 
	level endon( "save_restore" ); 
	
	while (1)
	{
		num_shots = randomintrange(5, 15);
		waittime = randomfloatrange(0.5, 2);

		for (i = 0; i < num_shots; i++)
		{
			self fireweapon();
			realwait(0.1);
		}
		
		realwait(waittime);
	}
	
}