
// script startup m10_crash_elevator_fx()


// 08 Elevator ICS - Shaft and Lens Flare FX
script static void fx_08_elevator()
	print ("::: M10 - Elevator - FX :::");
// sleep (150);
	
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator_slow.effect, fx_elev_depressure_01 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator_slow.effect, fx_elev_depressure_02 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator_slow.effect, fx_elev_depressure_04 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator_slow.effect, fx_elev_depressure_10 );

	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator.effect, fx_elev_depressure_03 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator.effect, fx_elev_depressure_05 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator.effect, fx_elev_depressure_06 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator.effect, fx_elev_depressure_07 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator.effect, fx_elev_depressure_08 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_elevator.effect, fx_elev_depressure_09 );

//	Commented out as these are now hooked up to the new looping FX Markers
//	effect_new (environments\solo\m10_crash\fx\lens_flare\elv_lensflare_yellow_lt.effect, fx_elev_light_01 );
//	effect_new (environments\solo\m10_crash\fx\lens_flare\elv_lensflare_yellow_lt.effect, fx_elev_light_02 );

end


// 08 Elevator ICS - Door Open FX
script static void fx_08_elevator_door()
	print ("::: M10 - Elevator Door Open - FX :::");
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_door_steam.effect, fx_elev_depressure_door );
end


// 08 Elevator ICS - Depressurize Steam Exit FX
script static void fx_08_elev_exit()
	print ("::: M10 - Elevator Depressurize Exit - FX :::");
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_exit_01.effect, fx_elev_depressurize_01 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_exit_02.effect, fx_elev_depressurize_02 );
	effect_new (environments\solo\m10_crash\fx\atmosphere\elv_depressurize_exit_02.effect, fx_elev_depressurize_03 );
end


// 08 Elevator ICS - Debris Explosion 01 FX
script static void fx_08_elev_explo_01()
	print ("::: M10 - Elevator Debris Explosion 01 - FX :::");
	effect_new (environments\solo\m10_crash\fx\explosions\explosion_elv_med.effect, fx_elev_explo_01 );
end


// 08 Elevator ICS - Debris Explosion 02 FX
script static void fx_08_elev_explo_02()
	print ("::: M10 - Elevator Debris Explosion 02 - FX :::");
	effect_new (environments\solo\m10_crash\fx\explosions\explosion_elv_med_02.effect, fx_elev_explo_02 );
end


// 08 Elevator ICS - Debris Explosion 03 FX
script static void fx_08_elev_explo_03()
	print ("::: M10 - Elevator Debris Explosion 03 - FX :::");
	effect_new (environments\solo\m10_crash\fx\explosions\explosion_elv_med_03.effect, fx_elev_explo_03 );
end


