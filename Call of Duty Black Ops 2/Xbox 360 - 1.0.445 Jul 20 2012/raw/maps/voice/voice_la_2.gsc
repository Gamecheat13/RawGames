
#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;

init_voice()
{
    add_dialog("you_okay_brother_003","vox_la2_8_01_002a_harp");//You okay, brother?
    add_dialog("holy_shit_004","vox_la2_8_02_001a_harp");//Holy Shit...
    add_dialog("you_okay_005","vox_la2_8_02_002a_harp");//You okay?
    add_dialog("yeah_006","vox_la2_8_02_003a_sect");//Yeah...
    add_dialog("andersons_f/a38_007","vox_la2_8_02_004a_harp");//Anderson's F/A38. May still be viable...
    add_dialog("anderson_008","vox_la2_8_02_005a_sect");//Anderson!
    add_dialog("anderson_ander_009","vox_la2_8_02_006a_harp");//Anderson?... Anderson?
    add_dialog("get_her_to_safety_010","vox_la2_8_02_007a_sect");//Get her to safety.
    add_dialog("no___012","vox_la2_8_02_009a_sect");//No.
    add_dialog("the_flight_compute_013","vox_la2_9_01_002a_harp");//The Flight computer should handle most of the work.
    add_dialog("are_we_sure_its_n_014","vox_la2_9_01_003a_sect");//Are we sure it's not compromised?
    add_dialog("identify_h_mason_016","vox_la2_9_01_005a_f38c");//Identify - Mason, David. Priority override - ALPHA DELTA ECHO X-RAY.
    add_dialog("authorization_acce_017","vox_la2_9_01_006a_f38c");//Authorization accepted - Start up  sequence initiated.
    add_dialog("ill_requisition_a_018","vox_la2_9_01_007a_harp");//I'll requisition a vehicle and regroup with the presidential convoy.
    add_dialog("controls_navigati_019","vox_la2_9_01_008a_f38c");//Controls, Navigation, communication and telemetry systems now online.
    add_dialog("do_what_you_can_to_020","vox_la2_9_01_009a_harp");//Do what you can to provide cover from the air.
    add_dialog("good_luck_harper_021","vox_la2_9_01_010a_sect");//Good luck, Harper. See you at Prom Night.
    add_dialog("weapons_systems_di_022","vox_la2_9_01_011a_f38c");//Weapons systems diagnostics initiated.
    add_dialog("25mm_cannon_h_onli_023","vox_la2_9_01_012a_f38c");//25mm Cannon - Online.
    add_dialog("guided_missile_sys_024","vox_la2_9_01_013a_f38c");//Guided missile system - Online.
    add_dialog("missile_barrage_sy_025","vox_la2_9_01_014a_f38c");//Missile barrage system - Online.
    add_dialog("missile_barrage_sy_026","vox_la2_9_01_015a_f38c");//Missile barrage system - Offline.
    add_dialog("engines_on_027","vox_la2_9_01_016a_sect");//Engines on...
    add_dialog("warning_structura_028","vox_la2_9_01_017a_f38c");//Warning... Structural damage to fuselage and landing gear detected.
    add_dialog("engines_operating_029","vox_la2_9_01_018a_f38c");//Engines operating at 60% capacity.
    add_dialog("vtol_mode_enabled_030","vox_la2_9_01_019a_f38c");//VTOL Mode enabled.  Fixed wing flight unavailable, thruster repair in progress.
    add_dialog("diagnostics_comple_031","vox_la2_9_01_020a_f38c");//Diagnostics complete. Auto pilot disengaged.  You have the stick.
    add_dialog("weapons_systems_on_032","vox_la2_9_01_021a_f38c");//Weapons systems online.
    add_dialog("vtol_flight_mode_e_033","vox_la2_9_01_022a_f38c");//VTOL flight mode engaged.
    add_dialog("conventional_fligh_034","vox_la2_9_01_023a_f38c");//Conventional flight mode engaged.
    add_dialog("death_blossom_offl_035","vox_la2_9_01_024a_f38c");//Death Blossom offline.
    add_dialog("death_blossom_onli_036","vox_la2_9_01_025a_f38c");//Death Blossom online.
    add_dialog("missiles_offline_037","vox_la2_9_01_026a_f38c");//Missiles offline.
    add_dialog("nose_cannons_offli_038","vox_la2_9_01_027a_f38c");//Nose cannons offline.
    add_dialog("missile_warning_028","vox_la2_9_01_028a_f38c");//Missile warning!
    add_dialog("incoming_missile_029","vox_la2_9_01_029a_f38c");//Incoming missile.
    add_dialog("get_some_fire_on_t_040","vox_la2_9_02_002a_harp");//Get some fire on the warehouse rooftops!
    add_dialog("tear_‘em_up_042","vox_la2_9_02_004a_harp");//Tear ‘em up!!!
    add_dialog("holy_shit_043","vox_la2_9_02_005a_sect");//Holy shit!!!
    add_dialog("harper__roads_cl_044","vox_la2_9_02_006a_sect");//Harper!  Road's clear - Move up!
    add_dialog("hows_anderson_046","vox_la2_9_02_008a_sect");//How's Anderson?
    add_dialog("shell_make_it_047","vox_la2_9_02_009a_harp");//She'll make it... She's one tough lady.
    add_dialog("glad_to_hear_it_h_048","vox_la2_9_02_010a_sect");//Glad to hear it, Harper.  Keep her safe.
    add_dialog("damn_050","vox_la2_9_02_012a_sect");//Damn.
    add_dialog("agent_mason_h_what_012","vox_la2_9_02_013a_pres");//Agent Mason - What's the plan?
    add_dialog("the_lapd_will_try_013","vox_la2_9_02_014a_sect");//The LAPD will try to keep the roads clear, but with so many insurgents we'll be under constant attack.
    add_dialog("flight_computer_wi_015","vox_la2_9_02_015a_sect");//Flight computer will track the convoy's location - I'll provide overwatch and draw attacks away from you.
    add_dialog("good_luck_mason_015","vox_la2_9_02_016a_pres");//Good Luck, Mason.
    add_dialog("harper_h_make_a_le_016","vox_la2_9_02_017a_sect");//Harper - make a left on 9th.
    add_dialog("got_it_017","vox_la2_9_02_018a_harp");//Got it...
    add_dialog("shit_its_a_fuc_018","vox_la2_9_02_019a_harp");//Shit... It's a fucking mess... they really hit us hard.
    add_dialog("wait_019","vox_la2_9_02_020a_sect");//Wait...
    add_dialog("shit_enemy_trucks_020","vox_la2_9_02_021a_sect");//Shit! Enemy trucks crashing the Hope St blockade!
    add_dialog("keep_moving_go_021","vox_la2_9_02_022a_sect");//Keep moving! Go!
    add_dialog("which_way__which_052","vox_la2_9_03_002a_harp");//Which way?  Which way?!!
    add_dialog("left__go_left_053","vox_la2_9_03_003a_sect");//Left!  Go left!!
    add_dialog("enemy_trucks_004","vox_la2_9_03_004a_harp");//Enemy trucks!
    add_dialog("we_got_more_trucks_005","vox_la2_9_03_005a_harp");//We got more trucks headed right for us!
    add_dialog("armed_gangs_moving_006","vox_la2_9_03_006a_harp");//Armed gangs moving in!
    add_dialog("the_gangs_are_tear_007","vox_la2_9_03_007a_harp");//The gangs are tearing into the cops!
    add_dialog("those_fucking_gang_008","vox_la2_9_03_008a_harp");//Those fucking gangbangers are all over the streets!
    add_dialog("bastards_are_every_009","vox_la2_9_03_009a_harp");//Bastards are everywhere!
    add_dialog("the_cops_are_getti_010","vox_la2_9_03_010a_harp");//The cops are getting hammered!
    add_dialog("take_‘em_out_011","vox_la2_9_03_011a_harp");//Take ‘em out!
    add_dialog("hope_you_know_what_054","vox_la2_9_04_001a_harp");//Hope you know what you're doing!
    add_dialog("we_got_more_rpgs_i_055","vox_la2_9_04_002a_sect");//We got more RPGs in the parking structure!
    add_dialog("brace_yourselves_h_056","vox_la2_9_04_003a_sect");//Brace yourselves - I'll try to clear them out!!
    add_dialog("were_taking_fire_058","vox_la2_9_04_005a_harp");//We're taking fire from all sides!
    add_dialog("shit_theyve_go_006","vox_la2_9_04_006a_sect");//Shit!!! They've got more claws!
    add_dialog("get_off_8th_h_turn_007","vox_la2_9_04_007a_sect");//Get off 9th - turn north onto Flower!
    add_dialog("dammit__008","vox_la2_9_04_008a_harp");//Dammit!
    add_dialog("helicopter_above_t_009","vox_la2_9_04_009a_harp");//Helicopter above the parking structure!
    add_dialog("fuck__those_big_r_011","vox_la2_9_04_011a_harp");//Fuck!  Those big rigs are blocking out path!
    add_dialog("jones_h_everyone_o_009","vox_la2_9_04_012a_sect");//Jones - Everyone okay?
    add_dialog("youre_doing_a_hel_010","vox_la2_9_04_013a_pres");//You're doing a hell of a job, Agent Mason.
    add_dialog("we_aint_out_the_w_011","vox_la2_9_04_014a_sect");//We ain't out the woods yet...
    add_dialog("we_got_enemy_gunsh_012","vox_la2_9_04_015a_sect");//We got enemy gunships!
    add_dialog("keep_moving_013","vox_la2_9_04_016a_sect");//Keep moving!
    add_dialog("its_too_hot_h_tur_017","vox_la2_9_04_017a_sect");//It's too hot - Turn right on 5th!
    add_dialog("holy_fuck__look_o_018","vox_la2_9_04_018a_harp");//Holy fuck!  Look out!!!
    add_dialog("convoy_tracking_si_019","vox_la2_9_04_019a_f38c");//Convoy tracking signals lost.
    add_dialog("harper__harper_020","vox_la2_9_04_020a_sect");//Harper!  Harper?!
    add_dialog("we_cant_see_shit_021","vox_la2_9_04_021a_harp");//We can't see shit down here!
    add_dialog("bastards_tried_to_006","vox_la2_9_04_022a_harp");//Bastards tried to drop a fucking building on us!
    add_dialog("i_know_059","vox_la2_9_04_023a_sect");//I know!
    add_dialog("the_convoy_vehicle_024","vox_la2_9_04_024a_harp");//The convoy vehicles are still operational, but we need some time to clear the debris.
    add_dialog("you_gotta_keep_tho_025","vox_la2_9_04_025a_harp");//You gotta keep those drones off our backs!
    add_dialog("thruster_repair_co_061","vox_la2_9_05_001a_f38c");//Thruster repair complete.  Fixed wing flight mode restored.
    add_dialog("air_to_air_missile_062","vox_la2_9_05_002a_f38c");//Air to Air missiles online.
    add_dialog("shit__harper__go_063","vox_la2_9_05_003a_sect");//Shit!  Harper.  Got multiple drones incoming!
    add_dialog("come_on_you_basta_004","vox_la2_9_05_004a_sect");//Come on, you bastards!
    add_dialog("just_worry_about_y_065","vox_la2_9_05_005a_harp");//Just worry about yourself right now!
    add_dialog("moving_north_on_gr_008","vox_la2_9_05_008a_harp");//Moving North on Grand.
    add_dialog("i_got_you_009","vox_la2_9_05_009a_harp");//I got you.
    add_dialog("take_the_heat_off_009","vox_la2_9_05_011a_harp");//Take the heat off the convoy!
    add_dialog("we_just_lost_an_ia_013","vox_la2_9_05_013a_harp");//We just lost an IAV!!
    add_dialog("dammit_were_taki_014","vox_la2_9_05_014a_harp");//Dammit! We're taking fire!!!
    add_dialog("keep_them_off_us_015","vox_la2_9_05_015a_harp");//Keep them off us!
    add_dialog("we_need_you_with_t_017","vox_la2_9_05_017a_harp");//We need you with the convoy!
    add_dialog("the_drones_are_eve_018","vox_la2_9_05_018a_sect");//The drones are everywhere!
    add_dialog("shit__theyre_all_019","vox_la2_9_05_019a_sect");//Shit!  They're all over me!
    add_dialog("damn_i_cant_shak_020","vox_la2_9_05_020a_sect");//Damn! I can't shake ‘em!
    add_dialog("moving_to_intercep_021","vox_la2_9_05_021a_sect");//Moving to intercept.
    add_dialog("come_on_you_basta_022","vox_la2_9_05_022a_sect");//Come on, you bastard!
    add_dialog("ive_got_you_now_023","vox_la2_9_05_023a_sect");//I've got you now!
    add_dialog("got_him_024","vox_la2_9_05_024a_sect");//Got him!
    add_dialog("thats_a_hit_025","vox_la2_9_05_025a_sect");//That's a hit.
    add_dialog("warning_h_incoming_026","vox_la2_9_05_026a_f38c");//Warning - incoming.
    add_dialog("warning_h_enemy_mi_027","vox_la2_9_05_027a_f38c");//Warning - Enemy missile detected.
    add_dialog("warning_h_missile_028","vox_la2_9_05_028a_f38c");//Warning - Missile impact imminent.
    add_dialog("warning_h_enemy_lo_029","vox_la2_9_05_029a_f38c");//Warning - Enemy lock on detected.
    add_dialog("warning_h_enemy_ai_030","vox_la2_9_05_030a_f38c");//Warning - enemy aircraft on collision vector.
    add_dialog("impact_imminent_031","vox_la2_9_05_031a_f38c");//Impact imminent.
    add_dialog("collision_imminent_032","vox_la2_9_05_032a_f38c");//Collision imminent.
    add_dialog("evasive_action_req_033","vox_la2_9_05_033a_f38c");//Evasive action required.
    add_dialog("target_locked_034","vox_la2_9_05_034a_f38c");//Target locked.
    add_dialog("missile_launched_035","vox_la2_9_05_035a_f38c");//Missile launched.
    add_dialog("target_lock_h_lost_036","vox_la2_9_05_036a_f38c");//Target lock - lost.
    add_dialog("target_destroyed_037","vox_la2_9_05_037a_f38c");//Target destroyed.
    add_dialog("enemy_neutralized_038","vox_la2_9_05_038a_f38c");//Enemy neutralized.
    add_dialog("tracking_target_h_039","vox_la2_9_05_039a_f38c");//Tracking target - Calibrating velocity.
    add_dialog("target_lock_veloci_040","vox_la2_9_05_040a_f38c");//Target lock velocity compensation initiated.
    add_dialog("maintaining_curren_041","vox_la2_9_05_041a_f38c");//Maintaining current speed.
    add_dialog("altitude_locked_042","vox_la2_9_05_042a_f38c");//Altitude locked.
    add_dialog("damage_warning__043","vox_la2_9_05_043a_f38c");//Damage Warning!
    add_dialog("warning__structur_044","vox_la2_9_05_044a_f38c");//Warning!  Structural integrity compromised.
    add_dialog("fly_low__you_can_012","vox_la2_9_05_046a_harp");//Fly low!
    add_dialog("missiles_on_your_013","vox_la2_9_05_047a_harp");//Those missile's are right on your ass!
    add_dialog("use_evasive_maneuv_014","vox_la2_9_05_048a_harp");//Use evasive maneuver! Shake them off!
    add_dialog("a_drone_is_lining_049","vox_la2_9_05_049a_rich");//A drone is lining up for an attack run on the President's convoy!
    add_dialog("youve_got_to_shoo_050","vox_la2_9_05_050a_rich");//You've got to shoot it down!
    add_dialog("the_drones_are_tar_051","vox_la2_9_05_051a_rich");//The drones are targeting the convoy!  You've gotta take them out!
    add_dialog("we_just_took_a_dir_052","vox_la2_9_05_052a_rich");//We just took a direct hit!
    add_dialog("one_more_of_those_053","vox_la2_9_05_053a_rich");//One more of those and we're done for!
    add_dialog("a_drone_has_locked_054","vox_la2_9_05_054a_rich");//A drone has locked on to you - take it out!
    add_dialog("fuck_yeah_055","vox_la2_9_05_055a_harp");//Fuck, yeah!
    add_dialog("were_not_out_of_t_068","vox_la2_9_06_001a_sect");//We have more incoming!
    add_dialog("why_are_they_comin_069","vox_la2_9_06_002a_harp");//Why are they coming in so low?
    add_dialog("fuck_theyre_th_070","vox_la2_9_06_003a_sect");//Fuck!!! They're through being subtle - bastards are flying straight for you!
    add_dialog("switching_to_vtol_071","vox_la2_9_06_004a_f38c");//Switching to VTOL force protection mode.
    add_dialog("shit_theyre_fast_072","vox_la2_9_06_005a_sect");//Shit they're fast!
    add_dialog("damn_that_was_to_073","vox_la2_9_06_006a_sect");//Damn!! That was too close!
    add_dialog("keep_them_off_us_074","vox_la2_9_06_007a_harp");//Keep them off us!  We can't take much more!
    add_dialog("ammunition_supplie_075","vox_la2_10_00_001a_f38c");//Ammunition supplies exhausted.  All weapons are offline.
    add_dialog("shit_076","vox_la2_10_00_002a_sect");//Shit!!
    add_dialog("the_only_thing_i_c_078","vox_la2_10_00_004a_sect");//The only thing I can.
    add_dialog("lock_acquired_plo_079","vox_la2_10_00_005a_f38c");//Lock acquired. Plotting collision course.
    add_dialog("eject__eject__ej_080","vox_la2_10_00_006a_f38c");//Eject.  Eject.  Eject.
    add_dialog("shiiiiiiiit_082","vox_la2_10_01_001a_sect");//SHIIIIIIIIT!!
    add_dialog("mason_001","vox_la2_10_02_001a_harp");//Mason...?
    add_dialog("youre_a_crazy_bas_002","vox_la2_10_02_002a_harp");//You're a crazy bastard... You know that, right?
    add_dialog("i_told_you_h_im_o_003","vox_la2_10_02_003a_pres");//I told you... I'm okay...
    add_dialog("madam_president_h_004","vox_la2_10_02_004a_john");//Madam President - More attacks may be imminent - We have to get you into the bunker.
    add_dialog("that_can_wait_age_005","vox_la2_10_02_005a_pres");//That can wait, Agent Jones.  First, I need to speak to that man...
    add_dialog("agent_mason_006","vox_la2_10_02_006a_pres");//Agent Mason?
    add_dialog("madam_president_007","vox_la2_10_02_007a_sect");//Madam President?
    add_dialog("hell_of_job_today_008","vox_la2_10_02_008a_pres");//Hell of job today, soldier.  Hell of a job...
    add_dialog("now_find_the_ma_009","vox_la2_10_02_009a_pres");//Now... Find the man responsible for all this.
    add_dialog("yes_maam_010","vox_la2_10_02_010a_sect");//Yes, Maam.
    add_dialog("oh_agent_mason_011","vox_la2_10_02_011a_pres");//Oh, Agent Mason...?
    add_dialog("make_sure_you_kill_012","vox_la2_10_02_012a_pres");//Make sure you kill the son of a bitch.
    add_dialog("harp_section_0","vox_la2_11_04_069a_harp");//Section!
    add_dialog("sect_shit_anderson_s_0","vox_la2_11_04_070a_sect");//Shit... Anderson.  She took a hit before - Don't know how bad.
    add_dialog("harp_least_she_s_still_in_0","vox_la2_11_04_071a_harp");//Least she's still in one piece.
    add_dialog("poli_her_vitals_are_weak_0","vox_la2_11_04_072a_poli");//Her vitals are weak...
    add_dialog("sect_get_her_to_safety_0","vox_la2_11_04_073a_sect");//Get her to safety...  Make sure she lives.
    add_dialog("harp_ever_fly_one_of_thes_0","vox_la2_11_04_074a_harp");//Ever fly one of these, Section?
    add_dialog("harp_well_you_re_gonna_fl_0","vox_la2_11_04_075a_harp");//Well you're gonna fly one now, Section...
    add_dialog("harp_don_t_sweat_it_sect_0","vox_la2_11_04_076a_harp");//Don't sweat it, Section.  It's independent of our defense network. Menendez can't touch you.
    add_dialog("harp_i_ll_take_the_ambula_0","vox_la2_11_04_077a_harp");//I'll take the ambulance with Anderson.
    add_dialog("harp_stay_on_me_and_we_ll_0","vox_la2_11_04_078a_harp");//Stay on me and we'll try to regroup with the presidential convoy.
    add_dialog("f38c_sky_buster_offline_0","vox_la2_11_04_079a_f38c");//Sky Buster offline.
    add_dialog("f38c_sky_buster_online_0","vox_la2_11_04_080a_f38c");//Sky Buster online.
    add_dialog("samu_the_pmcs_are_floodin_0","vox_la2_11_04_081a_samu");//The PMCs are flooding every damn intersection!  The LAPD are overwhelmed.  We're not gonna make it!
    add_dialog("sect_samuels_i_ve_secur_0","vox_la2_11_04_082a_sect");//Samuels.  I've secured an FA/38 to provide air support.
    add_dialog("sect_i_m_tracking_your_lo_0","vox_la2_11_04_083a_sect");//I'm tracking your location now.  Just hang in there.
    add_dialog("pres_good_luck_mason_0","vox_la2_11_04_084a_pres");//Good Luck, Mason.
    add_dialog("samu_roger_that_0","vox_la2_11_04_085a_samu");//Roger that.
    add_dialog("samu_the_attack_devastate_0","vox_la2_11_04_086a_samu");//The attack devastated much of the area.  Dammit.
    add_dialog("harp_looks_like_more_trou_0","vox_la2_11_04_087a_harp");//Looks like more trouble up ahead, Section.
    add_dialog("samu_we_got_enemies_dead_0","vox_la2_11_04_088a_samu");//We got enemies dead ahead, Section.
    add_dialog("samu_which_way_section_0","vox_la2_11_04_089a_samu");//Which way, Section?
    add_dialog("samu_enemy_trucks_0","vox_la2_11_04_090a_samu");//Enemy trucks!
    add_dialog("harp_mercs_moving_in_0","vox_la2_11_04_091a_harp");//Mercs moving in!
    add_dialog("samu_we_ve_got_groundtroo_0","vox_la2_11_04_092a_samu");//We've got groundtroops all around!
    add_dialog("harp_they_re_tearing_into_0","vox_la2_11_04_093a_harp");//They're tearing into the cops!
    add_dialog("harp_those_fucking_bastar_0","vox_la2_11_04_094a_harp");//Those fucking bastards are all over the streets!
    add_dialog("samu_you_gotta_keep_them_0","vox_la2_11_04_095a_samu");//You gotta keep them off us!
    add_dialog("harp_hit_em_section_0","vox_la2_11_04_096a_harp");//Hit ‘em, Section!
    add_dialog("samu_section_the_presid_0","vox_la2_11_04_097a_samu");//Section - The presidential convoy is pinned down by infantry fire.
    add_dialog("harp_come_on_section_1","vox_la2_11_04_098a_harp");//Come, on Section!!
    add_dialog("samu_you_gotta_clear_us_a_0","vox_la2_11_04_099a_samu");//You gotta clear us a path!
    add_dialog("harp_nice_work_section_0","vox_la2_11_05_001a_harp");//Nice work. Section.
    add_dialog("harp_dammit_section_it_0","vox_la2_11_05_002a_harp");//Dammit Section!  It's ambush fucking alley down here!
    add_dialog("samu_we_re_taking_fire_fr_0","vox_la2_11_05_003a_samu");//We're taking fire from all sides!
    add_dialog("harp_the_helicopter_sect_0","vox_la2_11_05_004a_harp");//The helicopter, Section!  Take him out!
    add_dialog("samu_we_got_gunships_over_0","vox_la2_11_05_005a_samu");//We got gunships overhead!
    add_dialog("samu_enemy_big_rigs_end_0","vox_la2_11_05_006a_samu");//Enemy big rigs - End of the street!
    add_dialog("sect_samuels_everyone_0","vox_la2_11_05_007a_sect");//Samuels! - Everyone okay?
    add_dialog("samu_section_we_re_trac_0","vox_la2_11_05_008a_samu");//Section - We're tracking another wave of Drones advancing on our position!
    add_dialog("samu_norad_s_fa_38_s_are_0","vox_la2_11_05_009a_samu");//Norad's FA/38's are still three minutes out!
    add_dialog("sect_i_ll_handle_the_dron_0","vox_la2_11_05_010a_sect");//I'll handle the drones.  Just get the President to Prom Night!
    add_dialog("samu_the_drones_are_targe_0","vox_la2_11_05_011a_samu");//The drones are targeting the convoy!  You've gotta keep them off us, Section!
    add_dialog("samu_dammit_section_w_0","vox_la2_11_05_012a_samu");//Dammit, Section!!! We just took a direct hit!
    add_dialog("samu_dammit_section_on_0","vox_la2_11_05_013a_samu");//Dammit, Section!  One more of those and we're dead meat!
    add_dialog("sect_samuels_do_you_cop_0","vox_la2_11_05_014a_sect");//Samuels!  Do you copy?
    add_dialog("samu_building_collapse_ne_0","vox_la2_11_05_015a_samu");//Building collapse nearly took us out!
    add_dialog("samu_we_need_you_keep_the_0","vox_la2_11_05_016a_samu");//We need you keep the drones off our backs - until we get moving again.
    add_dialog("sect_put_anderson_on_comm_0","vox_la2_11_05_017a_sect");//Put Anderson on comms!
    add_dialog("sect_anderson_i_need_to_0","vox_la2_11_05_018a_sect");//Anderson.  I need to unlock the sky buster missiles.
    add_dialog("ande_section_sky_buste_0","vox_la2_11_05_019a_ande");//Section... Sky buster's a last resort response.  Are you sure?
    add_dialog("ande_okay_uploading_th_0","vox_la2_11_05_086a_ande");//Okay... Uploading the skybuster codes to you.
    add_dialog("f38c_identify_captain_a_0","vox_la2_11_05_020a_f38c");//Identify - Captain Anderson. Authorize Weapons system override nine one one.
    add_dialog("samu_i_m_sorry_section_0","vox_la2_11_05_021a_samu");//I'm sorry, Section. She didn't make it...
    add_dialog("harp_good_luck_section_0","vox_la2_11_05_022a_harp");//Good luck, Section!
    add_dialog("harp_nice_work_section_1","vox_la2_11_05_023a_harp");//Nice work, Section.
    add_dialog("samu_good_work_section_0","vox_la2_11_05_024a_samu");//Good work, Section.
    add_dialog("samu_we_re_moving_north_o_0","vox_la2_11_05_025a_samu");//We're moving north on Grand.
    add_dialog("harp_section_those_dron_0","vox_la2_11_05_026a_harp");//Section!  Those drones are all over us!
    add_dialog("harp_where_are_you_secti_0","vox_la2_11_05_027a_harp");//Where are you, Section?!  We're taking damage here!
    add_dialog("harp_where_the_hell_are_y_0","vox_la2_11_05_028a_harp");//Where the Hell are you, Section?!!!
    add_dialog("samu_the_drones_are_all_o_0","vox_la2_11_05_029a_samu");//The drones are all over us!
    add_dialog("samu_you_have_to_defend_t_0","vox_la2_11_05_030a_samu");//You have to defend the convoy!
    add_dialog("samu_we_re_taking_damage_0","vox_la2_11_05_031a_samu");//We're taking damage here!
    add_dialog("samu_we_just_lost_an_iav_0","vox_la2_11_05_032a_samu");//We just lost an IAV!!
    add_dialog("samu_dammit_we_re_under_0","vox_la2_11_05_033a_samu");//Dammit! We're under fire!!!
    add_dialog("samu_keep_them_off_us_0","vox_la2_11_05_034a_samu");//Keep them off us!
    add_dialog("samu_where_are_you_secti_0","vox_la2_11_05_035a_samu");//Where are you, Section?!!!
    add_dialog("samu_we_need_you_with_the_0","vox_la2_11_05_036a_samu");//We need you with the convoy!
    add_dialog("samu_a_drone_is_lining_up_0","vox_la2_11_05_037a_samu");//A drone is lining up for an attack run on the President's convoy!
    add_dialog("samu_you_ve_got_to_shoot_0","vox_la2_11_05_038a_samu");//You've got to shoot it down!
    add_dialog("samu_another_one_of_those_0","vox_la2_11_05_039a_samu");//Another one of those and we're done for!
    add_dialog("samu_a_drone_has_locked_o_0","vox_la2_11_05_040a_samu");//A drone has locked on to you - take it out!
    add_dialog("sect_you_re_clear_0","vox_la2_11_05_041a_sect");//You're clear!
    add_dialog("f38c_sky_buster_missiles_0","vox_la2_11_05_042a_f38c");//Sky Buster missiles fired.
    add_dialog("harp_dammit_section_the_0","vox_la2_11_05_043a_harp");//Dammit Section!  They've got a lock on you!
    add_dialog("harp_go_between_the_build_0","vox_la2_11_05_044a_harp");//Go between the buildings - you gotta lose those damn missiles!
    add_dialog("harp_evasive_manoeuvres_0","vox_la2_11_05_045a_harp");//Evasive Manoeuvres, Section!
    add_dialog("samu_we_re_not_gonna_surv_0","vox_la2_11_05_046a_samu");//We're not gonna survive much more of this, Section!
    add_dialog("sect_stay_with_me_0","vox_la2_11_05_047a_sect");//Stay with me!
    add_dialog("sect_keep_moving_0","vox_la2_11_05_048a_sect");//Keep moving!
    add_dialog("sect_shake_em_off_0","vox_la2_11_05_049a_sect");//Shake ‘em off!
    add_dialog("sect_dropping_chaff_0","vox_la2_11_05_050a_sect");//Dropping chaff!
    add_dialog("air1_break_right_0","vox_la2_11_05_051a_air1");//Break right!
    add_dialog("air1_break_left_0","vox_la2_11_05_052a_air1");//Break left!
    add_dialog("air2_i_m_going_right_you_0","vox_la2_11_05_053a_air2");//I'm going right, you go left.
    add_dialog("air2_i_m_going_left_you_0","vox_la2_11_05_054a_air2");//I'm going left, you go right.
    add_dialog("air1_i_have_lock_0","vox_la2_11_05_055a_air1");//I have lock.
    add_dialog("air1_engaging_0","vox_la2_11_05_056a_air1");//Engaging!
    add_dialog("air1_firing_missiles_0","vox_la2_11_05_057a_air1");//Firing missiles!
    add_dialog("air1_nose_cannon_firing_0","vox_la2_11_05_058a_air1");//Nose cannon - firing.
    add_dialog("air1_come_on_you_son_of_a_0","vox_la2_11_05_059a_air1");//Come on you son of a bitch.
    add_dialog("air1_got_him_0","vox_la2_11_05_060a_air1");//Got him!
    add_dialog("air2_target_eliminated_0","vox_la2_11_05_061a_air2");//Target eliminated.
    add_dialog("air2_there_s_too_many_of_0","vox_la2_11_05_062a_air2");//There's too many of them!
    add_dialog("air2_got_drones_buzzing_a_0","vox_la2_11_05_063a_air2");//Got drones buzzing all around!
    add_dialog("air2_dammit_i_got_a_dro_0","vox_la2_11_05_064a_air2");//Dammit.  I got a drone on my six!
    add_dialog("air2_get_him_off_me_0","vox_la2_11_05_065a_air2");//Get him off me!
    add_dialog("air2_he_s_on_me_tight_0","vox_la2_11_05_066a_air2");//He's on me tight!
    add_dialog("air2_i_can_t_shake_him_0","vox_la2_11_05_067a_air2");//I can't shake him!
    add_dialog("air2_got_drones_on_your_t_0","vox_la2_11_05_068a_air2");//Got drones on your tail!
    add_dialog("air2_i_m_hit_0","vox_la2_11_05_069a_air2");//I'm hit!
    add_dialog("air2_i_m_gonna_have_to_ej_0","vox_la2_11_05_070a_air2");//I'm gonna have to eject!
    add_dialog("air2_eject_eject_eject_0","vox_la2_11_05_071a_air2");//Eject. Eject. Eject!
    add_dialog("air2_ejecting_now_0","vox_la2_11_05_072a_air2");//Ejecting, now!
    add_dialog("air2_i_am_going_down_i_0","vox_la2_11_05_073a_air2");//I am going down.  I repeat - I am going down.
    add_dialog("harp_what_are_you_doing_0","vox_la2_11_05_074a_harp");//What are you doing, Section?
    add_dialog("samu_section_what_are_y_0","vox_la2_11_05_075a_samu");//Section!  What are you doing?
    add_dialog("sect_i_m_gonna_hit_him_he_0","vox_la2_11_05_076a_sect");//I'm gonna hit him head on.
    add_dialog("harp_you_re_on_a_collisio_0","vox_la2_11_05_077a_harp");//You're on a collision course!
    add_dialog("harp_it_s_suicide_0","vox_la2_11_05_078a_harp");//It's suicide!!
    add_dialog("samu_i_hope_you_re_sure_a_0","vox_la2_11_05_079a_samu");//I hope you're sure about this...
    add_dialog("samu_damn_0","vox_la2_11_05_080a_samu");//Damn...
    add_dialog("samu_that_was_pretty_ball_0","vox_la2_11_05_081a_samu");//That was pretty ballsy moves up there soldier.
    add_dialog("pres_you_did_a_great_serv_0","vox_la2_11_05_082a_pres");//You did a great service to your country today, Agent Mason.  I sincerely hope that one day we will find a way express our gratitude.
    add_dialog("pres_in_the_meantime_0","vox_la2_11_05_083a_pres");//In the meantime... Find the man responsible for all this...
    add_dialog("pres_and_make_sure_ju_0","vox_la2_11_05_084a_pres");//... And make sure justice is served.
    add_dialog("samu_section_the_lapd_ve_0","vox_la2_11_05_087a_samu");//Section, the LAPD vehicles will guide you right to us – stay with them
    add_dialog("samu_section_stay_with_t_0","vox_la2_11_05_088a_samu");//Section, stay with the LAPD vehicles – they'll guide you right to our location
    add_dialog("ande_section_i_m_remotel_0","vox_la2_11_05_089a_ande");//Section, I'm remotely activating your F38's Sky Buster Missiles. Use them to take outmultiple targets with each shot.
    add_dialog("ande_section_thanks_for_0","vox_la2_11_05_090a_ande");//Section, thanks for saving my life. I'm remotely activating your F38's Sky Buster Missiles now. Sky Buster missiles can destroy multiple aircraft each time you fire them.
}
