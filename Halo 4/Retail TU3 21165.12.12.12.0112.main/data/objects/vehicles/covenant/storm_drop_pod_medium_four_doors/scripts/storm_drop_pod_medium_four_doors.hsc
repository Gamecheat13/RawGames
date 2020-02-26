//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 
// script for medium four door drop pods
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

//Options -
//drop_to_point(squad,point,speed,landing surface) - Spawns squad into drop pod and launches drop pod and deploys squad
//dead_drop_to_point(point,speed,landing surface)- Spawns empty drop pod

//Landing Effects options
// DEFAULT, DIRT, SAND, WATER
global boolean b_launch = FALSE;
global real r_launch_state = 0;

script startup instanced f_init()
//Hide droppod on load
	object_hide(this,true);
end

script static instanced void drop_to_point( ai ai_squad, point_reference land_location, real dp_speed, string effect_type )
	object_hide(this,false);
	f_load_guys(ai_squad);
	sleep(5);
	f_launch_to_point(land_location, dp_speed, effect_type);
	sleep(30 * dp_speed);
	f_spawn_guys(ai_squad);

end

script static instanced void dead_drop_to_point( point_reference land_location, real dp_speed, string effect_type )
	sleep(5);
	f_launch_to_point(land_location, dp_speed, effect_type);
end

//Load AI
script static instanced void f_load_guys(ai ai_squad)
	ai_place(ai_squad);
	ai_vehicle_enter_immediate (ai_squad, this);
end

//Launch Pod to Point
script static instanced void f_launch_to_point(point_reference land_location, real dp_speed, string effect_type)
        //effect_new_on_object_marker (cinematics\070la2_carter_death\fx\explosion\covenant_explosion_huge.effect, this, fx_impact);
        effect_new_on_object_marker_loop( objects\vehicles\covenant\storm_drop_pod_medium_four_doors\fx\drop_pod_trail.effect, this, fx_contrail);
	//effect_new_on_object_marker (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, this, fx_drop_trail);
	object_hide(this, FALSE);
	object_set_scale (this, 0.01, 0);
	object_set_scale (this, 1.0, 20);
	object_move_to_point (this, dp_speed, land_location);
	sound_impulse_start ( 'sound\environments\solo\m030\amb_m30_beta\veh_drop_pod_incoming', this, 1 ); //AUDIO!
	effect_stop_object_marker( objects\vehicles\covenant\storm_drop_pod_medium_four_doors\fx\drop_pod_trail.effect, this, fx_contrail);
	//object_move_to_point <object name> <time> <target point>
	sound_impulse_start_marker( 'sound\environments\solo\m030\amb_m30_beta\drop_pod_cov_squad_impact', this, fx_impact, 1 ); //AUDIO!
	f_select_land_effect(effect_type);

end


//Open pod and unload AI
script static instanced void f_spawn_guys(ai ai_squad)
	unit_open (this);
	sound_impulse_start ( 'sound\storm\vehicles\drop_pod\vehicle_11_storm_drop_pod_medium_four_doors_open', this, 1 ); //AUDIO!
	
	sleep (2);
	inspect (unit_get_custom_animation_time (this));
	//breakpoint ("BREAK");
	
	//sleep_s (2);
	ai_vehicle_exit  (ai_squad);
end

//Select Landing Effect
script static instanced void f_select_land_effect(string effect_type)

	if (effect_type == "DEFAULT") then
		dprint ("default");
		f_land_effect_default();	
			
	elseif (effect_type == "DIRT") then
		dprint ("dirt");
		f_land_effect_dirt();
	else
		dprint ("else");
		f_land_effect_default();	
	end
		
//	if (effect_type == "SAND") then
//		dprint ("sand");
//		f_land_effect_sand();
//	end
//		
//	if (effect_type == "WATER") then
//		dprint ("water");
//		f_land_effect_water();
//	end
	
end


// Landing Effects
script static instanced void f_land_effect_default()
	//sound_impulse_start_marker( 'sound\environments\solo\m030\amb_m30_beta\drop_pod_cov_squad_impact', this, fx_impact, 1 ); //AUDIO!
	effect_new_on_object_marker( objects\vehicles\covenant\storm_drop_pod_medium_four_doors\fx\dp_squad_impact.effect, this, fx_impact);
	//effect_new_on_object_marker (fx\reach\fx_library\pod_impacts\default\pod_impact_default_large.effect, this, fx_impact);
end

script static instanced void f_land_effect_dirt()
	//sound_impulse_start_marker( 'sound\environments\solo\m030\amb_m30_beta\drop_pod_cov_squad_impact', this, fx_impact, 1 ); //AUDIO!
	effect_new_on_object_marker( objects\vehicles\covenant\storm_drop_pod_medium_four_doors\fx\dp_squad_impact.effect, this, fx_impact);
 
end

//script static instanced void f_land_effect_sand()
//	effect_new_on_object_marker (fx\reach\fx_library\pod_impacts\default\pod_impact_default_large.effect, this, fx_impact);
//end
//
//script static instanced void f_land_effect_water()
//	effect_new_on_object_marker (fx\reach\fx_library\pod_impacts\default\pod_impact_default_large.effect, this, fx_impact);
//end

