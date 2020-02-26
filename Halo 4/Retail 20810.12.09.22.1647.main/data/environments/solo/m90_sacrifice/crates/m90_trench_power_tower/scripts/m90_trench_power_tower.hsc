//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343





script static instanced void f_wait_destruction( object_name core )
	dprint("setting up tower core");
	sleep_until( object_valid(core) );
	sleep_until( object_get_health( core ) <= 0, 1 );
		dprint("tower destroyed");
		f_start_destruction();

end


script static instanced void f_start_destruction()

	print ("tower_destroyedsdddsds");
//	device_set_position_track(	this, 'any:idle', 1 );
	//device_animate_position (this, 1.0, 1.80, 0.1, 0.1, TRUE);
	damage_object( this, "default" , 100000);
	//thread(f_m90_power_tower_destroy());
	f_m90_power_tower_effects();

end

script static instanced void f_m90_power_tower_effects()

	sleep(20);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_01" );

	
	//sleep(random_range(2,4));
	sleep(2);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_02" );

	sleep(5);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_03" );

	sleep(5);
	effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_04" );


	sleep(15);
	
	//object_destroy( this );

	//object_set_physics ( this , false );
end

/*
script static instanced void f_m90_power_tower_destroy()

	sleep_until ( device_get_position ( this ) >= 0.80, 1 );
		//dprint("destroy stuff");
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_2" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_top_3" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_top_2" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\trans_destroyed.effect, this, "fx_top_1" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_1" );
		effect_new_on_object_marker( objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect, this, "fx_bottom_3" );
	
		//object_destroy( this );
end
*/
