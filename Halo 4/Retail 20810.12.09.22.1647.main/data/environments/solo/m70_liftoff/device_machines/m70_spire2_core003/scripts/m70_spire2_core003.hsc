//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70_LIFTOFF_FLIGHT
// script for the device machine: M70_SPIRE_01_EXTERIOR_DOOR_02
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//FUNCTION INDEX

// === f_init: init function
script startup instanced init()
	device_set_position_track( this, 'any:idle', 0 );
	device_animate_position(this, 1, 0, 0.1, 0.1, TRUE);
end

//MAIN FUNCTIONS
//xxx finish 2
//device_animate_position(m70_spire2_core004, 1, 3, 0.1, 0.1, TRUE);
//xxx finish 1
//device_animate_position(m70_spire2_core004, 0.336, 5, 0.1, 0.1, TRUE);
//xxx open
//device_animate_position(m70_spire2_core004, 0, 3, 0.1, 0.1, TRUE);
//xxx start
//device_animate_position(m70_spire2_core004, 0, 10, 0.1, 0.1, TRUE);
//device_animate_position(m70_spire2_core004, 0.2, 10, 0.1, 0.1, TRUE);
//xxx close
//device_animate_position(m70_spire2_core004, 0.2, 3, 0.1, 0.1, TRUE);

//	m70_spire2_core004->f_sp02_core_activate( 10, cr_sp02_core_02, flg_sp02_core_02_up, flg_sp02_core_02_down);
script static instanced void f_sp02_cores_create(object_name core, cutscene_flag flg_core)
	object_create_anew(core);
	object_cannot_take_damage(core);
	object_set_scale(core, 0.1, 0);
	object_teleport (core, flg_core);
	object_set_scale(core, 1.25, 120);
end

script static instanced void f_sp02_cores_activate(object_name core, cutscene_flag flg_core)
	dprint("CORE IS ACTIVE");
	device_animate_position(this, 0.2, 10, 0.1, 0.1, TRUE);
	thread(f_sp02_cores_activate_sound());
	sleep_until(device_get_position(this) == 0.2, 1);
	f_sp02_cores_create( core, flg_core);
end

script static instanced void f_sp02_cores_activate_sound()
	sleep_s(2);
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire2_core003_transform_1', this, audio_core_02, 1 ); //AUDIO!
end

script static instanced void f_sp02_cores_open(object_name core)
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire2_core003_transform_2_reveal', this, audio_core_01, 1 ); //AUDIO!
	device_animate_position(this, 0, 4, 0.1, 0.1, TRUE);
	sleep(5);
	object_can_take_damage(core);
end

script static instanced void f_sp02_cores_close()
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire2_core003_transform_4_unreveal', this, audio_core_01, 1 ); //AUDIO!
	device_animate_position(this, 0.2, 3, 0.1, 0.1, TRUE);
end

script static instanced void f_sp02_cores_reopen()
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire2_core003_transform_1', this, audio_core_02, 1 ); //AUDIO!
	//sound_impulse_start ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire2_core003_transform_2_reveal', this, 1 ); //AUDIO!
	device_animate_position(this, 0, 3, 0.1, 0.1, TRUE);
end

script static instanced void f_sp02_cores_deactivate()
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire2_core003_transform_3_disappear', this, audio_core_02, 1 ); //AUDIO!
	//sound_impulse_start ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire2_core003_transform_3_disappear', this, 1 ); //AUDIO!
	device_animate_position(this, 0.336, 3, 0.1, 0.1, TRUE);
	sleep_until(device_get_position(this) == 0.336, 1);
	sleep(40);
	device_animate_position(this, 1, 3, 0.1, 0.1, TRUE);
end


script static instanced boolean f_sp02_core_check_open()
	device_get_position(this) == 0;
end

script static instanced boolean f_sp02_core_check_close()
	device_get_position(this) == 0.2;
end

script static instanced boolean f_sp02_core_check_destroyed()
	device_get_position(this) == 1;
end









/*


script static instanced boolean f_sp02_core_check_closing()
	device_get_position(this) >= 0.08;
end


script static instanced void f_sp02_core_activate( real move_time, object_name core, cutscene_flag core_up, cutscene_flag core_down)
	device_animate_position(this, 0, 15, 0.1, 0.1, TRUE);
	sleep_until(device_get_position(this) == 0, 1);
	f_sp02_core_spawn(core, core_up);
	sleep_s(3);
	f_sp02_core_close(move_time, core, core_down);
end

script static instanced void f_sp02_destroy( real animation_time)
	device_animate_position(this, 1, animation_time, 0.1, 0.1, TRUE);
end

//CORE_UTILITY
script static instanced void f_sp02_core_open( real move_time, object_name core, cutscene_flag core_up)
	device_animate_position(this, 0, move_time, 0.1, 0.1, TRUE);

	if object_valid(core) then
		thread(f_core_move_up(core, core_up));
	end
	
	sleep_until(device_get_position(this) == 0 or not object_valid(core), 1);
	
end

script static instanced void f_sp02_core_close( real move_time, object_name core, cutscene_flag core_down)
	device_animate_position(this, 0.39, move_time, 0.1, 0.1, TRUE);

	if object_valid(core) then	
		sleep_until(device_get_position(this) >= 0.24, 1);
		thread(f_core_move_down(core, core_down));
	end
	
	sleep_until(device_get_position(this) == 0.39 or not object_valid(core), 1);
end




script static instanced void f_sp02_core_reset()
	device_animate_position(this, 0, 0, 0.1, 0.1, TRUE);
end

//CORE_OBJECT

script static instanced void f_sp02_core_spawn(object_name core, cutscene_flag core_up)
	object_create_anew(core);
	object_cannot_take_damage(core);
	object_set_scale(core, 0.1, 0);
	object_teleport (core, core_up);
	object_set_scale(core, 1.25, 120);
	object_can_take_damage(core);
end

script static instanced void f_core_move_up(object_name core, cutscene_flag core_up)
object_move_to_flag(core, 4, core_up);
object_can_take_damage(core);
end

script static instanced void f_core_move_down(object_name core, cutscene_flag core_down)
object_move_to_flag(core, 4, core_down);
object_cannot_take_damage(core);
end

*/