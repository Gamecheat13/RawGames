//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash
// script for drop pods
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

//Options -
//drop_to_point(squad,point,speed,landing surface) - Spawns squad into drop pod and launches drop pod and deploys squad
//dead_drop_to_point(point,speed,landing surface)- Spawns empty drop pod

//Landing Effects options
// DEFUALT, DIRT, SAND, WATER
global boolean b_launch = FALSE;
global real r_launch_state = 0;

script startup instanced f_init()
//Hide droppod on load
object_hide(this,FALSE);
end

script static instanced void drop_to_point( ai ai_squad, point_reference land_location, real dp_speed, string effect_type )
f_load_guys(ai_squad);
sleep(5);
f_launch_to_point(land_location, dp_speed, effect_type);
sleep(30 * 1);
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

effect_new_on_object_marker_loop (objects\props\covenant\drop_pod_elite_cheap\fx\contrail\drop_pod_trail_atmospheric.effect, this, fx_drop_trail);
//effect_new_on_object_marker (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, this, fx_drop_trail);
object_hide(this, FALSE);
object_set_scale (this, 0.01, 0);
object_set_scale (this, 1.0, 20);
object_move_to_point (this, dp_speed, land_location);
effect_stop_object_marker (objects\props\covenant\drop_pod_elite_cheap\fx\contrail\drop_pod_trail_atmospheric.effect, this, fx_drop_trail);
//object_move_to_point <object name> <time> <target point>
f_select_land_effect(effect_type);

end


//Open pod and unload AI
script static instanced void f_spawn_guys(ai ai_squad)
unit_open (this);
ai_vehicle_exit  (ai_squad);
end

//Select Landing Effect
script static instanced void f_select_land_effect(string effect_type)

if (effect_type == "DEFUALT") then
	dprint ("defualt");
	f_land_effect_default();	
	end
	
if (effect_type == "DIRT") then
	dprint ("dirt");
	f_land_effect_dirt();
	end
	
if (effect_type == "SAND") then
	dprint ("sand");
	f_land_effect_sand();
	end
	
if (effect_type == "WATER") then
	dprint ("water");
	f_land_effect_water();
	end

end


// Landing Effects
script static instanced void f_land_effect_default()
effect_new_on_object_marker(fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, this, fx_impact);
effect_new_on_object_marker (fx\reach\fx_library\pod_impacts\default\pod_impact_default_large.effect, this, fx_impact);
end

script static instanced void f_land_effect_dirt()
effect_new_on_object_marker (fx\reach\fx_library\pod_impacts\default\pod_impact_default_large.effect, this, fx_impact);
end

script static instanced void f_land_effect_sand()
effect_new_on_object_marker (fx\reach\fx_library\pod_impacts\default\pod_impact_default_large.effect, this, fx_impact);
end

script static instanced void f_land_effect_water()
effect_new_on_object_marker (fx\reach\fx_library\pod_impacts\default\pod_impact_default_large.effect, this, fx_impact);
end

