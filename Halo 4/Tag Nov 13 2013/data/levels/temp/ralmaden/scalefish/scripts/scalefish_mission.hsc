
script startup scalefish()
 print ("Phantom");

 
end
 
script command_script cs_phantom()

	cs_ignore_obstacles( ai_current_actor, TRUE );	
	
	f_load_phantom( sq_phantom, "right", sq_grunts, sq_elite, sq_jackals, none );
	
	sleep( 30 * 2.0 );	

	cs_fly_to( ps_phantom.p0 );
	
	f_unload_phantom( sq_phantom, "right" );
	
	cs_fly_to( ps_phantom.p1 );
	//object_erase( ai_vehicle_get( ai_current_actor ) );
	ai_erase (sq_phantom);
	
end