
#using scripts\cp\_dialog;

function init_voice()
{

    dialog::add("com1_warning_dead_system_0","vox_lot2_7_01_000_com1");//Warning: DEAD system overheating. Critical mass approaching.
    dialog::add("com1_critical_failure_of_0","vox_lot2_7_01_001_com1");//Critical failure of DEAD network imminent. If able, please cancel previous request.
    dialog::add("com1_contact_dead_personn_0","vox_lot2_7_01_002_com1");//Contact DEAD personnel for mandatory evacuation.
    dialog::add("com1_warning_complete_de_0","vox_lot2_7_01_003_com1");//Warning: complete DEAD structural collapse imminent. Please cancel previous request.
    dialog::add("com1_dead_failure_contac_0","vox_lot2_7_01_004_com1");//DEAD failure. Contact systems for mandatory evacuation.
    dialog::add("hend_incoming_smoke_0","vox_lot2_7_01_005_hend");//Incoming smoke!!
    dialog::add("hend_hostiles_coming_thro_0","vox_lot2_7_01_006_hend");//Hostiles coming through!!
    dialog::add("plrf_taylor_1","vox_lot2_8_01_000_plrf");//TAYLOR!
    dialog::add("plyr_taylor_1","vox_lot2_8_01_000_plyr");//TAYLOR!
    dialog::add("plrf_kane_find_us_a_way_0","vox_lot2_8_01_001_plrf");//Kane, find us a way through.
    dialog::add("plyr_kane_find_us_a_way_0","vox_lot2_8_01_001_plyr");//Kane, find us a way through.
    dialog::add("kane_on_it_0","vox_lot2_8_01_002_kane");//On it.
    dialog::add("plrf_taylor_stand_down_0","vox_lot2_8_01_003_plrf");//Taylor, stand down.
    dialog::add("plyr_taylor_stand_down_0","vox_lot2_8_01_003_plyr");//Taylor, stand down.
    dialog::add("hend_it_s_over_john_giv_0","vox_lot2_8_01_004_hend");//Give it up, John.  It's over
    dialog::add("hend_come_on_john_you_k_0","vox_lot2_8_01_005_hend");//Come on, Man. You know me.
    dialog::add("tayr_hendricks_0","vox_lot2_8_01_006_tayr");//Hendricks...
    dialog::add("hend_that_s_right_you_0","vox_lot2_8_01_007_hend");//...that's right. You still in there, John? (beat) Do you hear me?
    dialog::add("tayr_you_don_t_understand_0","vox_lot2_8_01_008_tayr");//You don't understand. (beat) I'm taking us home. We'll be safe. We'll all be safe.
    dialog::add("hend_safe_safe_what_th_0","vox_lot2_8_01_009_hend");//SAFE?? What, what the, what the fuck is SAFE?!
    dialog::add("hend_what_the_fuck_is_saf_0","vox_lot2_8_01_010_hend");//What do you mean safe. John, John don't go.
    dialog::add("hend_what_is_the_frozen_f_1","vox_lot2_8_01_011_hend");//What is a FROZEN FOREST?!!!
    dialog::add("hend_shit_0","vox_lot2_8_01_012_hend");//SHIT.
    dialog::add("hend_kane_we_need_an_exi_0","vox_lot2_9_01_000_hend");//Kane! We need an EXIT!
    dialog::add("kane_robots_compromised_0","vox_lot2_9_01_000_kane");//Robots compromised, Taylor's controlling them!
    dialog::add("hend_they_re_gonna_detona_0","vox_lot2_9_01_001_hend");//They're gonna detonate, get back!!
    dialog::add("kane_give_me_a_minute_0","vox_lot2_9_01_001_kane");//Give me a minute.
    dialog::add("hend_we_don_t_gotta_fucki_0","vox_lot2_9_01_002_hend");//We don't gotta fucking minute!!
    dialog::add("kane_nrc_robotics_have_go_0","vox_lot2_9_01_002_kane");//NRC Robotics have gone Rogue -- Taylor has connected to their collective hive and taken control.
    dialog::add("hend_holy_shit_he_s_turn_0","vox_lot2_9_01_003_hend");//Holy shit. He's turning the NRC's Grunts against them.
    dialog::add("kane_right_beat_now_0","vox_lot2_9_01_003_kane");//Right.  (beat) NOW.
    dialog::add("hend_what_the_he_s_tur_0","vox_lot2_9_01_004_hend");//What the... He's turning the NRC's Grunts against them
    dialog::add("kane_he_s_using_anything_0","vox_lot2_9_01_005_kane");//He's using anything and everything to stop you. We have to assume if it's robotic it's been compromised by Taylor -- ally or otherwise.
    dialog::add("kane_should_be_access_to_0","vox_lot2_10_01_000_kane");//Should be access to the Skybridge beyond that wreckage.
    dialog::add("hend_gimme_a_hand_0","vox_lot2_10_01_001_hend");//Gimme a hand.
    dialog::add("kane_you_better_hustle_0","vox_lot2_10_01_002_kane");//You better hustle - we're tracking a storm front moving in - Sandstorm's likely to hit in less than ten minutes.
    dialog::add("kane_that_door_should_get_0","vox_lot2_10_01_003_kane");//That door should get you up.
    dialog::add("hend_that_ll_work_too_l_0","vox_lot2_10_01_004_hend");//That'll work, too. Let's move!
    dialog::add("kane_lieutenant_khalil_d_0","vox_lot2_7_02_000_kane");//Lieutenant Khalil! DEAD Network has been destroyed. You are a go.
    dialog::add("khal_confirmed_air_suppo_0","vox_lot2_7_02_001_khal");//Confirmed, Air support moving in.
    dialog::add("hend_friendlys_repelling_0","vox_lot2_7_02_002_hend");//Friendlys repelling in, check your fire!!
    dialog::add("hend_reinforcements_ahead_0","vox_lot2_7_02_003_hend");//Reinforcements ahead, keep moving!!
    dialog::add("kane_target_spotted_cro_0","vox_lot2_9_02_000_kane");//Target spotted - Crossing the skybridge to Tower Two.
    dialog::add("hend_where_the_hell_does_0","vox_lot2_9_02_001_hend");//Where the Hell does he think he's going??
    dialog::add("kane_brace_yourselves_2","vox_lot2_9_02_002_kane");//Brace yourselves!
    dialog::add("tayr_do_you_hear_me_0","vox_lot2_9_02_003_tayr");//Do you hear me?
    dialog::add("plrf_kane_taylor_s_talk_0","vox_lot2_9_02_004_plrf");//Kane - Taylor's talking to me on a closed channel!
    dialog::add("plyr_kane_taylor_s_talk_0","vox_lot2_9_02_004_plyr");//Kane - Taylor's talking to me on a closed channel!
    dialog::add("plrf_kane_0","vox_lot2_9_02_005_plrf");//KANE?!!!
    dialog::add("plyr_kane_0","vox_lot2_9_02_005_plyr");//KANE?!!!
    dialog::add("tayr_you_know_what_you_sa_0","vox_lot2_9_02_006_tayr");//You were with Sarah Hall when she died.  I know what yo usaw because I was there too. (beat) You have to know where we're going.
    dialog::add("hend_incoming_0","vox_lot2_9_02_007_hend");//INCOMING!
    dialog::add("plrf_where_where_are_we_0","vox_lot2_9_02_008_plrf");//Where? Where are we going??
    dialog::add("plyr_where_where_are_we_0","vox_lot2_9_02_008_plyr");//Where? Where are we going??
    dialog::add("tayr_imagine_yourself_in_0","vox_lot2_9_02_009_tayr");//Imagine yourself in a frozen forest...
    dialog::add("kane_taylor_just_entered_0","vox_lot2_10_02_000_kane");//Taylor just entered Tower Two.
    dialog::add("plrf_kane_what_s_in_towe_0","vox_lot2_10_02_001_plrf");//Kane, what's in Tower Two?
    dialog::add("plyr_kane_what_s_in_towe_0","vox_lot2_10_02_001_plyr");//Kane, what's in Tower Two?
    dialog::add("kane_nrc_use_it_primarily_0","vox_lot2_10_02_002_kane");//NRC use it primarily as a Robot Depot... looks like the top floors are converted to VTOL hangers.
    dialog::add("plrf_he_s_headed_to_the_r_0","vox_lot2_10_02_003_plrf");//He's headed to the roof - he's getting out of here.  (beat) Warn Khalil.
    dialog::add("plyr_he_s_headed_to_the_r_0","vox_lot2_10_02_003_plyr");//He's headed to the roof - he's getting out of here.  (beat) Warn Khalil.
    dialog::add("kane_prometheus_is_using_0","vox_lot2_111_02_001_kane");//Prometheus is using that mobile shop to head up the atrium. He's making his way to the top of the tower!
    dialog::add("kane_the_gunship_is_about_0","vox_lot2_116_02_001_kane");//The Gunship is about attack!
    dialog::add("kane_i_have_control_of_th_0","vox_lot2_116_02_002_kane");//I have control of the armored mobile shops. I'll send them up to you.
    dialog::add("kane_use_the_miniguns_and_0","vox_lot2_116_02_003_kane");//Use the Miniguns and other weapons on the Armored Mobile Shops against the Gunship.
    dialog::add("hend_okay_kane_enough_0","vox_lot2_7_03_000_hend");//Okay, Kane.  Enough fucking around with the locals.  What's our quickest route to Taylor.
    dialog::add("kane_take_that_shop_up_to_0","vox_lot2_7_03_001_kane");//Take that shop up to the 90th floor.
    dialog::add("hend_out_of_my_fucking_wa_0","vox_lot2_7_03_002_hend");//Out of my fucking way.
    dialog::add("kane_watch_hendricks_he_0","vox_lot2_7_03_003_kane");//Watch Hendricks - he's way over the line.
    dialog::add("plrf_copy_that_0","vox_lot2_7_03_004_plrf");//Copy that.
    dialog::add("plyr_copy_that_0","vox_lot2_7_03_004_plyr");//Copy that.
    dialog::add("kane_it_s_routed_to_the_d_0","vox_lot2_7_03_005_kane");//It's routed to the detention center.
    dialog::add("hend_we_need_to_move_on_0","vox_lot2_9_03_000_hend");//Hey, we need to move on...
    dialog::add("plrf_holy_shit_0","vox_lot2_9_03_001_plrf");//Holy shit.
    dialog::add("plyr_holy_shit_0","vox_lot2_9_03_001_plyr");//Holy shit.
    dialog::add("hend_he_s_turned_the_enti_0","vox_lot2_9_03_002_hend");//He's turned the entire robotic force against them. How?
    dialog::add("plrf_how_can_he_be_doing_0","vox_lot2_9_03_003_plrf");//His brain must be doing shitloads of calculations per second.  That thing inside his head -- It's gotta be burning out his brain.
    dialog::add("plyr_how_can_he_be_doing_0","vox_lot2_9_03_003_plyr");//His brain must be doing shitloads of calculations per second.  That thing inside his head -- It's gotta be burning out his brain.
    dialog::add("hend_kane_we_need_a_way_0","vox_lot2_9_03_005_hend");//Hey Kane, any bright ideas?
    dialog::add("plrf_oh_wow_0","vox_lot2_9_03_006_plrf");//Oh... wow.
    dialog::add("plyr_oh_wow_0","vox_lot2_9_03_006_plyr");//Oh... wow.
    dialog::add("khal_reinforcements_inbou_0","vox_lot2_10_03_000_khal");//Reinforcements inbound. Thirty seconds out.
    dialog::add("hend_where_s_that_assist_0","vox_lot2_10_03_001_hend");//Where's that assist, Khalil?
    dialog::add("vtlp_air_support_coming_i_0","vox_lot2_10_03_002_vtlp");//Air support coming into position.
    dialog::add("vtlp_shit_we_gotta_pull_0","vox_lot2_10_03_003_vtlp");//SHIT. We gotta pull back!
    dialog::add("hend_move_1","vox_lot2_10_03_004_hend");//MOVE!
    dialog::add("hend_let_the_vtol_take_ca_0","vox_lot2_10_03_005_hend");//Let the VTOL take care of them, we gotta get after Taylor!
    dialog::add("hend_path_s_block_ahead_0","vox_lot2_10_03_006_hend");//Path's block ahead, we gotta cross back over!
    dialog::add("hend_these_people_it_s_0","vox_lot2_7_04_000_hend");//It's like they  really think they have a chance.
    dialog::add("plrf_there_s_always_a_cha_0","vox_lot2_7_04_001_plrf");//There's always a chance, Hendricks.
    dialog::add("plyr_there_s_always_a_cha_0","vox_lot2_7_04_001_plyr");//There's always a chance, Hendricks.
    dialog::add("hend_these_people_up_a_0","vox_lot2_7_04_002_hend");//"These poor bastards... Up against the whole fucking NRC? (beat) It's like they really think they have a chance or something."
    dialog::add("hend_six_months_from_now_0","vox_lot2_7_04_003_hend");//Six months from now, they'll be under a whole new wave of oppression - Mark my words.
    dialog::add("hend_taylor_it_s_just_yo_0","vox_lot2_10_04_000_hend");//TAYLOR! It's just you and me now - you hear me?
    dialog::add("hend_this_isn_t_you_it_0","vox_lot2_10_04_001_hend");//This isn't you - It's the thing in your head -  Something in your DNI is fucking with your mind!
    dialog::add("hend_you_talk_about_safe_0","vox_lot2_10_04_002_hend");//You talk about “safe”? Does any of this LOOK SAFE TO YOU?? Who is telling you THIS?
    dialog::add("hend_what_is_it_john_wh_0","vox_lot2_10_04_003_hend");//What IS it, John? What is the Frozen Forest?  (beat) What the FUCK is it??
    dialog::add("wepv_need_a_faster_gun_a_0","vox_lot2_10_04_004_wepv");//Need a faster gun? A more steady hand? We have it all at affordable prices.
    dialog::add("wepv_buy_a_weapon_today_f_0","vox_lot2_10_04_005_wepv");//Buy a weapon today for safety tomorrow.
    dialog::add("wepv_you_can_t_protect_yo_0","vox_lot2_10_04_006_wepv");//You can't protect your children with words. Let your gun do the talking -- so you don't have to!
    dialog::add("watv_quenched_for_thirst_0","vox_lot2_10_04_007_watv");//Quenched for Thirst? Fill a glass -- new low price 215 pounds!
    dialog::add("watv_dying_of_thirst_com_0","vox_lot2_10_04_008_watv");//Dying of Thirst? Come see the liquid leaders.
    dialog::add("watv_weapons_for_water_t_0","vox_lot2_10_04_009_watv");//Weapons for water. Trade in your weapon and instantly get a bottle of water -- half off towards your next glass!
    dialog::add("plrf_hendricks_you_need_1","vox_lot2_10_04_010_plrf");//Hendricks! You need to calm down. He's not listening.
    dialog::add("plyr_hendricks_you_need_1","vox_lot2_10_04_010_plyr");//Hendricks! You need to calm down. He's not listening.
    dialog::add("hend_i_m_too_hurt_you_ll_0","vox_lot2_114_04_001_hend");//I'm too hurt, you'll have to go on without me.
    dialog::add("kane_prometheus_is_on_the_0","vox_lot2_114_04_002_kane");//Prometheus is on the tarmac.
    dialog::add("hend_rpg_0","vox_lot2_7_05_000_hend");//RPG!
    dialog::add("hend_kane_where_we_goin_0","vox_lot2_7_05_003_hend");//Kane! Got more NRC you wanna lead us into?
    dialog::add("hend_we_got_company_acr_0","vox_lot2_7_05_004_hend");//We got company!! Across the atrium!!
    dialog::add("hend_focus_fire_inside_th_0","vox_lot2_7_05_005_hend");//Focus fire inside the shop! Bring it down!
    dialog::add("egys_friendlies_hold_fir_0","vox_lot2_10_05_000_egys");//Friendlies! Hold fire!
    dialog::add("kane_follow_the_marker_0","vox_lot2_7_06_000_kane");//Follow the marker - it'll lead you right to the Detention Block. -- Taylor should be there
    dialog::add("plyr_copy_that_kane_0","vox_lot2_7_06_001_hend");//ABOUT TIME!
    dialog::add("plrf_looks_like_this_is_o_0","vox_lot2_7_06_002_plrf");//Looks like this is our stop. Where are we?
    dialog::add("plyr_looks_like_this_is_o_0","vox_lot2_7_06_002_plyr");//Looks like this is our stop. Where are we?
    dialog::add("kane_you_re_just_shy_of_t_0","vox_lot2_7_06_003_kane");//You're just shy of the 88th floor. Use that roof access to get outta there.
    dialog::add("hend_on_me_0","vox_lot2_7_07_000_hend");//ON ME!
    dialog::add("hend_nrc_wasps_joining_th_0","vox_lot2_7_07_001_hend");//NRC Wasps joining the party!!
    dialog::add("hend_more_incoming_0","vox_lot2_7_07_002_hend");//More incoming!!
    dialog::add("hend_sniper_on_the_89th_f_0","vox_lot2_7_07_003_hend");//Sniper on the 89th floor!
    dialog::add("hend_raps_comin_in_hot_0","vox_lot2_7_07_004_hend");//RAPS comin' in hot!!
    dialog::add("hend_sniper_90th_floor_0","vox_lot2_7_07_005_hend");//Sniper -- 90th Floor!
    dialog::add("kane_spread_out_you_got_0","vox_lot2_7_07_006_kane");//Spread out, you got options for approach.
    dialog::add("hend_reinforcements_on_th_0","vox_lot2_7_07_007_hend");//Reinforcements on the upper level!
    dialog::add("hend_nrc_coming_down_the_0","vox_lot2_7_07_008_hend");//NRC coming down the stairs!
    dialog::add("kane_eyes_open_guys_got_0","vox_lot2_7_08_000_kane");//Eyes open, guys. Gotta lot of activity up there.
    dialog::add("plrf_patch_us_through_0","vox_lot2_7_08_001_plrf");//Patch us through.
    dialog::add("plyr_patch_us_through_0","vox_lot2_7_08_001_plyr");//Patch us through.
    dialog::add("plrf_we_need_to_get_in_th_0","vox_lot2_7_08_003_plrf");//We need to get up there.
    dialog::add("plyr_we_need_to_get_in_th_0","vox_lot2_7_08_003_plyr");//We need to get up there.
    dialog::add("kane_he_s_barricaded_hims_0","vox_lot2_7_09_001_kane");//He's barricaded himself inside a holding room.  (beat) Right now, you've got other problems.
    dialog::add("kane_entrance_is_ahead_on_0","vox_lot2_7_09_002_kane");//Entrance is ahead on your right.
    dialog::add("kane_he_s_barricaded_hims_1","vox_lot2_7_10_000_kane");//He's barricaded himself inside a holding room.  (beat) Right now, you've got other problems.
    dialog::add("kane_reinforcements_have_0","vox_lot2_7_10_001_kane");//Reinforcements have already moved in.
    dialog::add("hend_tell_us_something_we_0","vox_lot2_7_10_002_hend");//Tell us something we don't fuckin' know! (to us) Riot Shields ahead, look out!
    dialog::add("hend_tell_us_something_we_1","vox_lot2_7_10_003_hend");//Tell us something we don't already know! (to us) Riot Shields ahead, look out!
    dialog::add("hend_nrc_hounds_rollin_i_0","vox_lot2_7_10_004_hend");//NRC Hounds rollin' in!
    dialog::add("kane_taylor_s_through_tha_0","vox_lot2_7_10_005_kane");//Taylor's through that door! Go!
    dialog::add("hend_c_mon_post_on_me_l_0","vox_lot2_7_10_006_hend");//C'mon! Post on me, let's move!
    dialog::add("rach_prometheus_is_moving_0","vox_lot2_progression_temp_001_kane");//Prometheus is moving to Tower 1.
    dialog::add("hend_i_can_re_wire_this_t_0","vox_lot2_progression_temp_002_hend");//I can re-wire this thing to shoot us up onto Tower 1.
    dialog::add("hend_i_need_30_more_secon_0","vox_lot2_progression_temp_003_hend");//I need 30 more seconds!
    dialog::add("rach_prometheus_is_on_the_0","vox_lot2_progression_temp_004_kane");//Prometheus is on the tarmac.
    dialog::add("hend_get_on_the_hunter_0","vox_lot2_progression_temp_005_hend");//Get on the Hunter!
}
