//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70_liftoff
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
//FUNCTION INDEX
	//f_set power( real power) :: sets device machine on/off
	//f_activate( short start_pos) :: activate device machine, start_pos sets device position 0 is closed 1 is open
	//f_loop(real transition_delay) :: if power is 1 will loop f_open or f_close after waiting the delay time in seconds
	//f_open() :: opens device, checks open and then starts loop function again
	//f_close() :: closes device, checks close and then starts loop function again
	//f_check_open() :: boolean returns true if device position is 1
	//f_check_close() :: boolean returns true if device position is 0
	//f_power_on() :: bolean that returns true if device  power is 1


// === f_init: init function
script startup instanced init()
	//dprint_door( "init" );
	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0 );
	f_set_power(1);
end

//TURN ANIMATIONS ON OR OFF
script static instanced void f_set_power( real power)
	device_set_power(this, power);
end

//MAIN ACTIVATION FUNCTION
script static instanced void f_activate( short start_pos, real transition_delay, real anim_time_open, real anim_time_close)
	//dprint("f_activate");
	if start_pos == 0 then
	//dprint("device_set_position");
		device_set_position(this, 0); 
		thread(f_loop(transition_delay, anim_time_open, anim_time_close));
	elseif start_pos >= 1 then
		device_set_position(this, 1);
		thread(f_loop(transition_delay, anim_time_open, anim_time_close));
	end
end

//LOOP OPEN AND CLOSE
script static instanced void f_loop(real transition_delay, real anim_time_open, real anim_time_close)
//dprint("f_loop");
	sleep_s(transition_delay);
//	dprint("transition_delay over");
	if f_power_on() then
		if f_check_open() then
			f_close(transition_delay, anim_time_open, anim_time_close);
			//sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_middle_up', this, bridge_center, 1 ); //AUDIO!
			//sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_outside_down', this, audio_bridge, 1 ); //AUDI
		elseif f_check_close() then
			f_open(transition_delay, anim_time_open, anim_time_close);
			//sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_middle_down', this, bridge_center, 1 ); //AUDIO!
			//sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_outside_up', this, audio_bridge, 1 ); //AUDIO!
		end
	end
end


// OPEN THE DOORS
script static instanced void f_open(real transition_delay, real anim_time_open, real anim_time_close)
//dprint("f_open");
	//sound_impulse_start ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_middle_up', this, 1 ); //AUDIO!
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_middle_up', this, bridge_center, 1 ); //AUDIO!
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_outside_down', this, audio_bridge, 1 ); //AUDIO!
	device_animate_position(this, 1, anim_time_open, 0.1, 0.1, true);
	sleep_until(f_check_open(), 1);
	thread(f_loop(transition_delay, anim_time_open, anim_time_close));
end

// CLOSE THE DOORS
script static instanced void f_close(real transition_delay, real anim_time_open, real anim_time_close)
//	dprint("f_close");
	
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_middle_down', this, bridge_center, 1 ); //AUDIO!
	sound_impulse_start_marker ( 'sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_spire01_tower_bridge_outside_up', this, audio_bridge, 1 ); //AUDIO!
	device_animate_position(this, 0, anim_time_close, 0.1, 0.1, true);
	sleep_until(f_check_close(), 1);
	thread(f_loop(transition_delay, anim_time_open, anim_time_close));
end

//CHECK IF OPEN
script static instanced boolean f_check_open()
	device_get_position(this) == 1;
end

//CHECK IF CLOSE
script static instanced boolean f_check_close()
	device_get_position(this) == 0;
end

script static instanced boolean f_power_on()
	device_get_power(this) == 1;
end


