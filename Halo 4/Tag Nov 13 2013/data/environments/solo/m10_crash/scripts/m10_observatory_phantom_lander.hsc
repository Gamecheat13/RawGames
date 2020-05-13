

global boolean lander_01_wave_spawn = FALSE;
global boolean lander_02_wave_spawn = FALSE;

script static void phantom_lander(device phantom_lander)
/*
thread(spawn_lander(phantom_lander));
sleep_s(2);
//dprint("more enemies incoming");
	if phantom_lander == phantom_lander_01 then
		phantom_lander_01->launch();
		sleep_until(device_get_position(phantom_lander_01) >= 0.945, 1);
		f_break(obs_window_side_right, obs_window_side_right_shield, obs_vortex_right_1, obs_vortex_right_2, obs_vortex_right_3, obs_vortex_right_4 );
		f_lander_eject_door(lander_01_tube_01, lander_01_tube_01_cover);
	elseif phantom_lander == phantom_lander_02 then
		phantom_lander_02->launch();
		sleep_until(device_get_position(phantom_lander_02) >= 0.88, 1);
		f_break(obs_window_side_left, obs_window_side_left_shield, obs_vortex_left_1, obs_vortex_left_2, obs_vortex_left_3, obs_vortex_left_4 );
		f_lander_eject_door(lander_02_tube_02, lander_02_tube_02_cover);
	else
		dprint("::::INVALID DEVICE MACHINE SELECTION CHANGE NAME OR USE PHANTOM LANDER 01 OR PHANTOM LANDER 02:::");
	end
sleep_s(0.25);
f_spawn_lander_squad(phantom_lander);
//dprint("more enemies incoming");
//sleep_until(phantom_lander->check_open(), 1);
//spawn_lander_units(phantom_lander);
*/

dprint("nop");
end

script static void f_lander_eject_door(object_name lander_tube, object_name lander_door)

	objects_detach(lander_tube, lander_door);
	//dprint(":::OBJECT DETACH:::");
	object_set_physics(lander_door ,true);
	object_wake_physics(lander_door);
	if lander_door == lander_01_tube_01_cover then
		object_set_velocity ( lander_door, 1, random_range (-20, -30), 1);
	elseif lander_door == lander_02_tube_02_cover then
		object_set_velocity ( lander_door, 1, random_range (-20, -30), 1);
	else 
		dprint(":::: DOOR IS INVALID:::");
	end
	
	// Play detach sound
	sound_impulse_start("sound\environments\solo\m010\scripted\events\m10_phantom_lander_tube_cover_eject", lander_door, 1.0);
end

script static void prepare_lander1()
	object_cannot_take_damage(phantom_lander_01);
	//create crate
	object_create(lander_01_tube_01_cover);
	object_create(lander_01_tube_02_cover);
	//create scenery
	object_create(lander_01_tube_01);
	object_create(lander_01_tube_02);
	object_create(obs_lander_01);
	//attach
	objects_attach(phantom_lander_01, "m_attach_phantom", obs_lander_01, "");
	objects_attach(phantom_lander_01, "m_arm_attach_01", lander_01_tube_01, "lander_tube");
	objects_attach(phantom_lander_01, "m_arm_attach_02", lander_01_tube_02, "lander_tube");
	objects_attach(lander_01_tube_01, "lander_tube_door", lander_01_tube_01_cover, "m_attach" );
	objects_attach(lander_01_tube_02, "lander_tube_door", lander_01_tube_02_cover, "m_attach");
end
	
script static void prepare_lander2()
	object_cannot_take_damage(phantom_lander_02);
	//create crate
	object_create(lander_02_tube_01_cover);
	object_create(lander_02_tube_02_cover);
	//create scenery
	object_create(lander_02_tube_01);
	object_create(lander_02_tube_02);
	object_create(obs_lander_02);
	//attach
	objects_attach(phantom_lander_02, "m_attach_phantom", obs_lander_02, "");
	objects_attach(phantom_lander_02, "m_arm_attach_01", lander_02_tube_01, "lander_tube");
	objects_attach(phantom_lander_02, "m_arm_attach_02", lander_02_tube_02, "lander_tube");
	objects_attach(lander_02_tube_01, "lander_tube_door", lander_02_tube_01_cover, "m_attach" );
	objects_attach(lander_02_tube_02, "lander_tube_door", lander_02_tube_02_cover, "m_attach");
end
