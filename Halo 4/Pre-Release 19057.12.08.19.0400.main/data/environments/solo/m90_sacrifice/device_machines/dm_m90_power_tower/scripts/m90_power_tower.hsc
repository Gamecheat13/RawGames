//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343



script startup instanced f_init()
 	//print ("tower is set up...");
  device_set_position_track(this, 'any:idle', 0);
  
end

script static instanced void f_wait_destruction( object core )
	//dprint("setting up tower core");
	sleep_until( object_get_health( core ) <= 0, 1 );
		//dprint("tower destroyed");
		f_animate_destruction();

end


script static instanced void f_animate_destruction()

	//print ("tower_destroyed");
//	device_set_position_track(	this, 'any:idle', 1 );
	device_animate_position (this, 1.0, 1.80, 0.1, 0.1, TRUE);
	thread(f_m90_power_tower_destroy());
	f_m90_power_tower_effects();

end

script static instanced void f_m90_power_tower_effects()

	//objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect
	sleep(20);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_top_1" );
	//effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\trans_destroyed.effect, this, "fx_top_1" );
	
	//sleep(random_range(2,4));
	sleep(2);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_1" );
	//effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\trans_destroyed.effect, this, "fx_bottom_1" );
	sleep(5);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_top_2" );
	//effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\trans_destroyed.effect, this, "fx_top_2" );
	sleep(5);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_2" );
	//effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\trans_destroyed.effect, this, "fx_bottom_2" );
	sleep(5);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_top_3" );
	//effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\trans_destroyed.effect, this, "fx_top_3" );
	sleep(5);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_3" );
	//effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\trans_destroyed.effect, this, "fx_bottom_3" );
	sleep(5);
	
	

	
end

script static instanced void f_m90_power_tower_destroy()

	sleep_until ( device_get_position ( this ) >= 0.80, 1 );
		//dprint("destroy stuff");
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_2" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_top_3" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_top_2" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\trans_destroyed.effect, this, "fx_top_1" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_1" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_3" );
	
		object_destroy( this );
end

