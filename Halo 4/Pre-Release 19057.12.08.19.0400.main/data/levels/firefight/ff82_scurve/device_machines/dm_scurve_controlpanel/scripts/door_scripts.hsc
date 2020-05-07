instanced sound derez_sound = 'sound\storm\objects\spartan_ops_shared\machine_19_spire_base_terminal_derez.sound';
instanced real device_direction = 1;
script static instanced void SetCustomDerezActivationSound(sound newSound)
	derez_sound = newSound;
	SetDerezWhenActivated();
end

script static instanced void SetDerezWhenActivated()
	device_direction = 1;
	thread(DerezControl());
end

script static instanced void SetDerezWhenActivatedBackwards()
	device_direction = 0;
	thread(DerezControl());
end


script static instanced void  DerezControl()
	sleep_until (device_get_position(this) == device_direction, 1);
	
	dprint("De-rezzing control");
	object_dissolve_from_marker(this, phase_out, panel);
	sleep(2);
	sound_impulse_start ( derez_sound, this, 1 );
end