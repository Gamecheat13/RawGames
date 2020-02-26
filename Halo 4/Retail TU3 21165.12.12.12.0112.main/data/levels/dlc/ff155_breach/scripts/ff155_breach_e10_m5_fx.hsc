//==============================================================================================================
//================================    E10M5 BREACH FX SCRIPT    ================================================
//==============================================================================================================


// ============================================	FX Functions ===================================================

// start all the falling debris for the m10_m5 skies
script static void fx_skyfall_all_on()

    // initial kickstart
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_1);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_2);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_3);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_4);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_5);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_6);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_7);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_8);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_9);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_10);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_11);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_12);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_13);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start_entrance.effect, fx_skyfall_debris_14);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start_entrance.effect, fx_skyfall_debris_entrance_1);


    // ongoing
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_1);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_2);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_3);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_4);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_5);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_6);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_7);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_8);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_9);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_10);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_11);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_12);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_13);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_14);

end

// stop all the falling debris for the m10_m5 skiesq
script static void fx_skyfall_all_off()
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_1);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_2);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_3);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_4);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_5);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_6);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_7);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_8);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_9);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_10);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_11);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_12);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_13);
end



// start the falling debris for the m10_m5_outro
script static void fx_skyfall_end_on()
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_1);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_2);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming_start.effect, fx_skyfall_debris_3);

    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_1);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_2);
    effect_new( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_3);
end

// stop the falling debris for the m10_m5_outro
script static void fx_skyfall_end_off()
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_1);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_2);
    effect_kill_from_flag( levels\dlc\ff155_breach\fx\debris\debris_skyfall_flaming.effect, fx_skyfall_debris_3);
end

// -------------------- falling dust functions ---------------------------

// trigger the ambient dust to run on global shake 
script static void fx_dust_ambient()
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_entrance_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_entrance_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_path_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_path_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_path_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_cavefront_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_cavefront_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_cavefront_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_cavefront_4 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_caveback_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_caveback_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_caveback_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_ambient.effect,  fx_dustfall_ambient_caveback_4 );

end



// trigger camera shake dust when mission starts
script static void fx_dust_mission_start()

  effect_new( levels\dlc\ff155_breach\fx\dust\fallingrocks_cave1.effect, fx_rockfall_entrance1);
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingrocks_cave2.effect, fx_rockfall_entrance2);

  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect, fx_dustfall_entrance_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect, fx_dustfall_entrance_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect, fx_dustfall_entrance_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect, fx_dustfall_entrance_4 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect, fx_dustfall_entrance_5 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect, fx_dustfall_entrance_6 );

end

// trigger camera shake dust on path from start to digger
script static void fx_dust_path_from_start()
 
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_path_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_path_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_path_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_path_4 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_path_5 );

end

// trigger camera shake dust in cave front (near entrance)
script static void fx_dust_cave_front()

  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_4 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_5 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_6 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_7 );

end

 // trigger camera shake dust in cave mid section
script static void fx_dust_cave_mid()

  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_cavemid_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_cavemid_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_cavemid_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_cavemid_4 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_cavemid_5 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_cavemid_6 );

end

// trigger camera shake dust in cave back
script static void fx_dust_cave_back()

  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_caveback_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_caveback_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_caveback_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_caveback_4 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_caveback.effect,  fx_dustfall_caveback_5 );

end

// trigger camera shake dust when exiting cave
script static void fx_dust_cave_exit()

  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_caveexit_1 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_caveexit_2 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_caveexit_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_caveexit_4 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_caveexit_5 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_caveexit_6 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_caveexit_7 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_caveexit_8 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_3 );
  effect_new( levels\dlc\ff155_breach\fx\dust\fallingdust_cave.effect,  fx_dustfall_cavefront_4 );

end


// Turn ON Digger Interior floor lens flares
script static void fx_digger_flares_on()
print ("Breach - Digger Interior Flares ON");

	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_01 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_02 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_03 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_04 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_05 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_06 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_07 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_08 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_09 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_10 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_11 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_12 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_13 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_14 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_15 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_16 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_17 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_18 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_19 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_20 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_21 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_22 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_23 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_24 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_25 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_26 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_27 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_28 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_31 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_32 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_33 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_34 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_35 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_36 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_37 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_38 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_39 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_42 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_43 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_44 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_45 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_46 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_47 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_49 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_50 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_51 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_52 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_53 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_54 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_55 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_56 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_57 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_58 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_59 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_60 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_61 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_62 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_63 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_64 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_65 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_66 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_67 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_68 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_69 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_70 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_71 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_72 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_73 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_74 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_75 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_76 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_77 );
	effect_new( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_78 );
end


// Turn OFF Digger Interior floor lens flares so Digger Beam Vignette FX play correctly
script static void fx_digger_flares_off()
print ("Breach - Digger Interior Flares OFF");

	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_01 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_02 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_03 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_04 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_05 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_06 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_07 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_08 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_09 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_10 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_11 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_12 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_13 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_14 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_15 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_16 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_17 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_18 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_19 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_20 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_21 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_22 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_23 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_24 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_25 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_26 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_27 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_28 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_31 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_32 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_33 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_34 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_35 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_36 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_37 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_38 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_39 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_42 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_43 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_44 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_46 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_47 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_49 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_50 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_51 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_52 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_53 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_54 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_55 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_56 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_57 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_58 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_59 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_60 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_61 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_62 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_63 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_64 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_65 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_66 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_67 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_68 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_69 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_70 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_71 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_72 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_73 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_74 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_75 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_76 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_77 );
	effect_kill_from_flag( levels\dlc\ff155_breach\fx\lensflares\bre_dig_int_floor_glow.effect, fx_dig_int_floor_flare_78 );
end

