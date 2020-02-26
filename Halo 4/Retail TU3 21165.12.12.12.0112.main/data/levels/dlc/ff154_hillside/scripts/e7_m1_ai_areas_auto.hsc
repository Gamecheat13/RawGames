// AREA AUTO SCRIPT
//
global real DEF_E7M1_AI_OBJCON_AREA_1A = 1;
global real DEF_E7M1_AI_OBJCON_AREA_2A = 2;
global real DEF_E7M1_AI_OBJCON_AREA_2B = 2.1;
global real DEF_E7M1_AI_OBJCON_AREA_2C = 2.2;
global real DEF_E7M1_AI_OBJCON_AREA_2D = 2.3;
global real DEF_E7M1_AI_OBJCON_AREA_2E = 2.4;
global real DEF_E7M1_AI_OBJCON_AREA_3A = 3;
global real DEF_E7M1_AI_OBJCON_AREA_3B = 3.1;
global real DEF_E7M1_AI_OBJCON_AREA_3C = 3.2;
global real DEF_E7M1_AI_OBJCON_AREA_4A = 4;
global real DEF_E7M1_AI_OBJCON_AREA_4B = 4.1;
global real DEF_E7M1_AI_OBJCON_AREA_4C = 4.2;
global real DEF_E7M1_AI_OBJCON_AREA_4D = 4.3;
global real DEF_E7M1_AI_OBJCON_AREA_4E = 4.4;
global real DEF_E7M1_AI_OBJCON_AREA_4F = 4.5;
global real DEF_E7M1_AI_OBJCON_AREA_5A = 5;
global real DEF_E7M1_AI_OBJCON_AREA_5B = 5.1;
global real DEF_E7M1_AI_OBJCON_AREA_5C = 5.2;
global real DEF_E7M1_AI_OBJCON_AREA_6A = 6;
global real DEF_E7M1_AI_OBJCON_AREA_6B = 6.1;
global real DEF_E7M1_AI_OBJCON_AREA_6C = 6.2;
global real DEF_E7M1_AI_OBJCON_AREA_7A = 7;
global real DEF_E7M1_AI_OBJCON_AREA_7B = 7.1;
global real DEF_E7M1_AI_OBJCON_AREA_7C = 7.2;
global real DEF_E7M1_AI_OBJCON_AREA_8A = 8;
//
global string_id DEF_E8M2_OBJECTIVE_AREA_1A = 'objectives_e7m1_area_1A';
global string_id DEF_E8M2_OBJECTIVE_AREA_2A = 'objectives_e7m1_area_2A';
global string_id DEF_E8M2_OBJECTIVE_AREA_2B = 'objectives_e7m1_area_2B';
global string_id DEF_E8M2_OBJECTIVE_AREA_2C = 'objectives_e7m1_area_2C';
global string_id DEF_E8M2_OBJECTIVE_AREA_2D = 'objectives_e7m1_area_2D';
global string_id DEF_E8M2_OBJECTIVE_AREA_2E = 'objectives_e7m1_area_2E';
global string_id DEF_E8M2_OBJECTIVE_AREA_3A = 'objectives_e7m1_area_3A';
global string_id DEF_E8M2_OBJECTIVE_AREA_3B = 'objectives_e7m1_area_3B';
global string_id DEF_E8M2_OBJECTIVE_AREA_3C = 'objectives_e7m1_area_3C';
global string_id DEF_E8M2_OBJECTIVE_AREA_4A = 'objectives_e7m1_area_4A';
global string_id DEF_E8M2_OBJECTIVE_AREA_4B = 'objectives_e7m1_area_4B';
global string_id DEF_E8M2_OBJECTIVE_AREA_4C = 'objectives_e7m1_area_4C';
global string_id DEF_E8M2_OBJECTIVE_AREA_4D = 'objectives_e7m1_area_4D';
global string_id DEF_E8M2_OBJECTIVE_AREA_4E = 'objectives_e7m1_area_4E';
global string_id DEF_E8M2_OBJECTIVE_AREA_4F = 'objectives_e7m1_area_4F';
global string_id DEF_E8M2_OBJECTIVE_AREA_5A = 'objectives_e7m1_area_5A';
global string_id DEF_E8M2_OBJECTIVE_AREA_5B = 'objectives_e7m1_area_5B';
global string_id DEF_E8M2_OBJECTIVE_AREA_5C = 'objectives_e7m1_area_5C';
global string_id DEF_E8M2_OBJECTIVE_AREA_6A = 'objectives_e7m1_area_6A';
global string_id DEF_E8M2_OBJECTIVE_AREA_6B = 'objectives_e7m1_area_6B';
global string_id DEF_E8M2_OBJECTIVE_AREA_6C = 'objectives_e7m1_area_6C';
global string_id DEF_E8M2_OBJECTIVE_AREA_7A = 'objectives_e7m1_area_7A';
global string_id DEF_E8M2_OBJECTIVE_AREA_7B = 'objectives_e7m1_area_7B';
global string_id DEF_E8M2_OBJECTIVE_AREA_7C = 'objectives_e7m1_area_7C';
global string_id DEF_E8M2_OBJECTIVE_AREA_8A = 'objectives_e7m1_area_8A';
//
global ai DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_GATE = 'objectives_e7m1_area_1A.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_GATE = 'objectives_e7m1_area_2A.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_GATE = 'objectives_e7m1_area_2B.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_GATE = 'objectives_e7m1_area_2C.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_GATE = 'objectives_e7m1_area_2D.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_GATE = 'objectives_e7m1_area_2E.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_GATE = 'objectives_e7m1_area_3A.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE = 'objectives_e7m1_area_3B.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_GATE = 'objectives_e7m1_area_3C.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_GATE = 'objectives_e7m1_area_4A.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_GATE = 'objectives_e7m1_area_4B.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE = 'objectives_e7m1_area_4C.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4D_ENEMY_GATE = 'objectives_e7m1_area_4D.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_GATE = 'objectives_e7m1_area_4E.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE = 'objectives_e7m1_area_4F.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE = 'objectives_e7m1_area_5A.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_GATE = 'objectives_e7m1_area_5B.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_GATE = 'objectives_e7m1_area_5C.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE = 'objectives_e7m1_area_6A.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_6B_ENEMY_GATE = 'objectives_e7m1_area_6B.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_GATE = 'objectives_e7m1_area_6C.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_GATE = 'objectives_e7m1_area_7A.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_GATE = 'objectives_e7m1_area_7B.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_7C_ENEMY_GATE = 'objectives_e7m1_area_7C.enemy_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE = 'objectives_e7m1_area_8A.enemy_gate';
//
global ai DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_1A.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_2A.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_2B.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_2C.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_2D.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_2E.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_3A.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_3B.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_3C.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_4A.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_4B.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_4C.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4D_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_4D.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_4E.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_4F.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_5A.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_5B.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_5C.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_6A.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_6B_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_6B.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_6C.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_7A.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_7B.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_7C_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_7C.enemy_combat_gate';
global ai DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_COMBAT_GATE = 'objectives_e7m1_area_8A.enemy_combat_gate';
//
global short S_e7m1_area_1A_advance_to_cnt = 4;
global short S_e7m1_area_3A_advance_to_cnt = 4;
global short S_e7m1_area_3B_advance_to_cnt = 6;
global short S_e7m1_area_3C_advance_to_cnt = 4;
global short S_e7m1_area_4A_advance_to_cnt = 6;
global short S_e7m1_area_5B_advance_to_cnt = 4;
global short S_e7m1_area_5C_advance_to_cnt = 10;
//
global short S_e7m1_area_3A_advance_from_cnt = 4;
global short S_e7m1_area_3B_advance_from_cnt = 3;
global short S_e7m1_area_3C_advance_from_cnt = 3;
global short S_e7m1_area_4A_advance_from_cnt = 4;
global short S_e7m1_area_4B_advance_from_cnt = 3;
global short S_e7m1_area_4C_advance_from_cnt = 6;
global short S_e7m1_area_4F_advance_from_cnt = 2;
global short S_e7m1_area_5A_advance_from_cnt = 4;
global short S_e7m1_area_5B_advance_from_cnt = 6;
global short S_e7m1_area_5C_advance_from_cnt = 4;
global short S_e7m1_area_6C_advance_from_cnt = 6;
global short S_e7m1_area_7A_advance_from_cnt = 8;
global short S_e7m1_area_8A_advance_from_cnt = 6;
//
//
global short S_e7m1_area_2E_retreat_from_cnt = 5;
//
script static boolean f_e7m1_ai_area_1A_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A );
end
script static boolean f_e7m1_ai_area_2A_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_2B_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_2C_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_2D_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_2E_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_3A_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A );
end
script static boolean f_e7m1_ai_area_3B_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A );
end
script static boolean f_e7m1_ai_area_3C_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A );
end
script static boolean f_e7m1_ai_area_4A_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C );
end
script static boolean f_e7m1_ai_area_4B_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C );
end
script static boolean f_e7m1_ai_area_4C_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4F );
end
script static boolean f_e7m1_ai_area_4D_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4F );
end
script static boolean f_e7m1_ai_area_4E_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5A );
end
script static boolean f_e7m1_ai_area_4F_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5C );
end
script static boolean f_e7m1_ai_area_5A_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5B );
end
script static boolean f_e7m1_ai_area_5B_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5C );
end
script static boolean f_e7m1_ai_area_5C_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6A );
end
script static boolean f_e7m1_ai_area_6A_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A ) and ( R_e7m1_objcon < DEF_E7M1_AI_OBJCON_AREA_8A );
end
script static boolean f_e7m1_ai_area_6B_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6C ) and ( R_e7m1_objcon < DEF_E7M1_AI_OBJCON_AREA_8A );
end
script static boolean f_e7m1_ai_area_6C_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A ) and ( R_e7m1_objcon < DEF_E7M1_AI_OBJCON_AREA_8A );
end
script static boolean f_e7m1_ai_area_7A_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7B ) and ( R_e7m1_objcon < DEF_E7M1_AI_OBJCON_AREA_8A );
end
script static boolean f_e7m1_ai_area_7B_cleanup_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7C ) and ( R_e7m1_objcon < DEF_E7M1_AI_OBJCON_AREA_8A );
end
//
//
//
//
//
//
script dormant f_e7m1_area_1A_place_trigger()

f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_1A_start', "play_mus_pve_e07m1_encounter_area_1A_start", 'play_mus_pve_e07m1_encounter_area_1A_end', "play_mus_pve_e07m1_encounter_area_1A_end", 'play_mus_pve_e07m1_encounter_level_1_start', "play_mus_pve_e07m1_encounter_level_1_start", 'play_mus_pve_e07m1_encounter_level_1_end', "play_mus_pve_e07m1_encounter_level_1_end" );
//dprint( "f_e7m1_area_1A_place_trigger: START" );
f_e7m1_area_1A_place_action( DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 2,1, DEF_E8M2_OBJECTIVE_AREA_1A, DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_GATE, 2, 7.5, 15, 20 );
//dprint( "f_e7m1_area_1A_place_trigger: STOP" );
end
script dormant f_e7m1_area_2A_place_trigger()

f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_2A_start', "play_mus_pve_e07m1_encounter_area_2A_start", 'play_mus_pve_e07m1_encounter_area_2A_end', "play_mus_pve_e07m1_encounter_area_2A_end", 'play_mus_pve_e07m1_encounter_level_2_start', "play_mus_pve_e07m1_encounter_level_2_start", 'play_mus_pve_e07m1_encounter_level_2_end', "play_mus_pve_e07m1_encounter_level_2_end" );
//dprint( "f_e7m1_area_2A_place_trigger: START" );
f_e7m1_area_2A_place_action( DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 5,2, DEF_E8M2_OBJECTIVE_AREA_2A, DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_GATE, 5, 7.5, 15, 20 );
//dprint( "f_e7m1_area_2A_place_trigger: STOP" );
end
script dormant f_e7m1_area_2B_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_2B_start', "play_mus_pve_e07m1_encounter_area_2B_start", 'play_mus_pve_e07m1_encounter_area_2B_end', "play_mus_pve_e07m1_encounter_area_2B_end", 'play_mus_pve_e07m1_encounter_level_2_start', "play_mus_pve_e07m1_encounter_level_2_start", 'play_mus_pve_e07m1_encounter_level_2_end', "play_mus_pve_e07m1_encounter_level_2_end" );
//dprint( "f_e7m1_area_2B_place_trigger: START" );
f_e7m1_area_2B_place_action( DEF_E7M1_AI_OBJCON_AREA_2A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 6,2, DEF_E8M2_OBJECTIVE_AREA_2B, DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_GATE, 6, 8, 15, 20 );
//dprint( "f_e7m1_area_2B_place_trigger: STOP" );
end
script dormant f_e7m1_area_2C_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_2C_start', "play_mus_pve_e07m1_encounter_area_2C_start", 'play_mus_pve_e07m1_encounter_area_2C_end', "play_mus_pve_e07m1_encounter_area_2C_end", 'play_mus_pve_e07m1_encounter_level_2_start', "play_mus_pve_e07m1_encounter_level_2_start", 'play_mus_pve_e07m1_encounter_level_2_end', "play_mus_pve_e07m1_encounter_level_2_end" );
//dprint( "f_e7m1_area_2C_place_trigger: START" );
f_e7m1_area_2C_place_action( DEF_E7M1_AI_OBJCON_AREA_2B, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,2, DEF_E8M2_OBJECTIVE_AREA_2C, DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_GATE, 10, 7.5, 15, 20 );
//dprint( "f_e7m1_area_2C_place_trigger: STOP" );
end
script dormant f_e7m1_area_2D_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_2D_start', "play_mus_pve_e07m1_encounter_area_2D_start", 'play_mus_pve_e07m1_encounter_area_2D_end', "play_mus_pve_e07m1_encounter_area_2D_end", 'play_mus_pve_e07m1_encounter_level_2_start', "play_mus_pve_e07m1_encounter_level_2_start", 'play_mus_pve_e07m1_encounter_level_2_end', "play_mus_pve_e07m1_encounter_level_2_end" );
//dprint( "f_e7m1_area_2D_place_trigger: START" );
f_e7m1_area_2D_place_action( DEF_E7M1_AI_OBJCON_AREA_2C, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 7,2, DEF_E8M2_OBJECTIVE_AREA_2D, DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_GATE, 6, 8, 15, 20 );
//dprint( "f_e7m1_area_2D_place_trigger: STOP" );
end
script dormant f_e7m1_area_2E_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_2E_start', "play_mus_pve_e07m1_encounter_area_2E_start", 'play_mus_pve_e07m1_encounter_area_2E_end', "play_mus_pve_e07m1_encounter_area_2E_end", 'play_mus_pve_e07m1_encounter_level_2_start', "play_mus_pve_e07m1_encounter_level_2_start", 'play_mus_pve_e07m1_encounter_level_2_end', "play_mus_pve_e07m1_encounter_level_2_end" );
//dprint( "f_e7m1_area_2E_place_trigger: START" );
f_e7m1_area_2E_place_action( DEF_E7M1_AI_OBJCON_AREA_2A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,2, DEF_E8M2_OBJECTIVE_AREA_2E, DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_GATE, 4, 7.75, 15, 20 );
//dprint( "f_e7m1_area_2E_place_trigger: STOP" );
end
script dormant f_e7m1_area_3A_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_3A_start', "play_mus_pve_e07m1_encounter_area_3A_start", 'play_mus_pve_e07m1_encounter_area_3A_end', "play_mus_pve_e07m1_encounter_area_3A_end", 'play_mus_pve_e07m1_encounter_level_3_start', "play_mus_pve_e07m1_encounter_level_3_start", 'play_mus_pve_e07m1_encounter_level_3_end', "play_mus_pve_e07m1_encounter_level_3_end" );
//dprint( "f_e7m1_area_3A_place_trigger: START" );
f_e7m1_area_3A_place_action( DEF_E7M1_AI_OBJCON_AREA_2D, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,3, DEF_E8M2_OBJECTIVE_AREA_3A, DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_GATE, 6, 8, 15, 20 );
//dprint( "f_e7m1_area_3A_place_trigger: STOP" );
end
script dormant f_e7m1_area_3B_place_trigger()

f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_3B_start', "play_mus_pve_e07m1_encounter_area_3B_start", 'play_mus_pve_e07m1_encounter_area_3B_end', "play_mus_pve_e07m1_encounter_area_3B_end", 'play_mus_pve_e07m1_encounter_level_3_start', "play_mus_pve_e07m1_encounter_level_3_start", 'play_mus_pve_e07m1_encounter_level_3_end', "play_mus_pve_e07m1_encounter_level_3_end" );
//dprint( "f_e7m1_area_3B_place_trigger: START" );
f_e7m1_area_3B_place_action( DEF_E7M1_AI_OBJCON_AREA_3A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,3, DEF_E8M2_OBJECTIVE_AREA_3B, DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE, 6, 7.5, 15, 20 );
//dprint( "f_e7m1_area_3B_place_trigger: STOP" );
end
script dormant f_e7m1_area_3C_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2E, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_3C_start', "play_mus_pve_e07m1_encounter_area_3C_start", 'play_mus_pve_e07m1_encounter_area_3C_end', "play_mus_pve_e07m1_encounter_area_3C_end", 'play_mus_pve_e07m1_encounter_level_3_start', "play_mus_pve_e07m1_encounter_level_3_start", 'play_mus_pve_e07m1_encounter_level_3_end', "play_mus_pve_e07m1_encounter_level_3_end" );
//dprint( "f_e7m1_area_3C_place_trigger: START" );
f_e7m1_area_3C_place_action( DEF_E7M1_AI_OBJCON_AREA_3B, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,3, DEF_E8M2_OBJECTIVE_AREA_3C, DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_GATE, 4, 8, 15, 20 );
//dprint( "f_e7m1_area_3C_place_trigger: STOP" );
end
script dormant f_e7m1_area_4A_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3B, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_4A_start', "play_mus_pve_e07m1_encounter_area_4A_start", 'play_mus_pve_e07m1_encounter_area_4A_end', "play_mus_pve_e07m1_encounter_area_4A_end", 'play_mus_pve_e07m1_encounter_level_4_start', "play_mus_pve_e07m1_encounter_level_4_start", 'play_mus_pve_e07m1_encounter_level_4_end', "play_mus_pve_e07m1_encounter_level_4_end" );
//dprint( "f_e7m1_area_4A_place_trigger: START" );
f_e7m1_area_4A_place_action( DEF_E7M1_AI_OBJCON_AREA_4A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,4, DEF_E8M2_OBJECTIVE_AREA_4A, DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_GATE, 5, 8, 15, 20 );
//dprint( "f_e7m1_area_4A_place_trigger: STOP" );
end
script dormant f_e7m1_area_4B_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_4B_start', "play_mus_pve_e07m1_encounter_area_4B_start", 'play_mus_pve_e07m1_encounter_area_4B_end', "play_mus_pve_e07m1_encounter_area_4B_end", 'play_mus_pve_e07m1_encounter_level_4_start', "play_mus_pve_e07m1_encounter_level_4_start", 'play_mus_pve_e07m1_encounter_level_4_end', "play_mus_pve_e07m1_encounter_level_4_end" );
//dprint( "f_e7m1_area_4B_place_trigger: START" );
f_e7m1_area_4B_place_action( DEF_E7M1_AI_OBJCON_AREA_4A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,4, DEF_E8M2_OBJECTIVE_AREA_4B, DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_GATE, 6, 8, 15, 20 );
//dprint( "f_e7m1_area_4B_place_trigger: STOP" );
end
script dormant f_e7m1_area_4C_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3B, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_4C_start', "play_mus_pve_e07m1_encounter_area_4C_start", 'play_mus_pve_e07m1_encounter_area_4C_end', "play_mus_pve_e07m1_encounter_area_4C_end", 'play_mus_pve_e07m1_encounter_level_4_start', "play_mus_pve_e07m1_encounter_level_4_start", 'play_mus_pve_e07m1_encounter_level_4_end', "play_mus_pve_e07m1_encounter_level_4_end" );
//dprint( "f_e7m1_area_4C_place_trigger: START" );
f_e7m1_area_4C_place_action( DEF_E7M1_AI_OBJCON_AREA_4A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,4, DEF_E8M2_OBJECTIVE_AREA_4C, DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE, 8, 8, 15, 20 );
//dprint( "f_e7m1_area_4C_place_trigger: STOP" );
end
script dormant f_e7m1_area_4D_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_4D_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_4D_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_4D_start', "play_mus_pve_e07m1_encounter_area_4D_start", 'play_mus_pve_e07m1_encounter_area_4D_end', "play_mus_pve_e07m1_encounter_area_4D_end", 'play_mus_pve_e07m1_encounter_level_4_start', "play_mus_pve_e07m1_encounter_level_4_start", 'play_mus_pve_e07m1_encounter_level_4_end', "play_mus_pve_e07m1_encounter_level_4_end" );
//dprint( "f_e7m1_area_4D_place_trigger: START" );
f_e7m1_area_4D_place_action( DEF_E7M1_AI_OBJCON_AREA_4B, DEF_E7M1_AI_OBJCON_AREA_4B, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,4, DEF_E8M2_OBJECTIVE_AREA_4D, DEF_E8M2_OBJECTIVE_AREA_4D_ENEMY_GATE, 10, 8, 15, 20 );
//dprint( "f_e7m1_area_4D_place_trigger: STOP" );
end
script dormant f_e7m1_area_4E_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_4E_start', "play_mus_pve_e07m1_encounter_area_4E_start", 'play_mus_pve_e07m1_encounter_area_4E_end', "play_mus_pve_e07m1_encounter_area_4E_end", 'play_mus_pve_e07m1_encounter_level_4_start', "play_mus_pve_e07m1_encounter_level_4_start", 'play_mus_pve_e07m1_encounter_level_4_end', "play_mus_pve_e07m1_encounter_level_4_end" );
//dprint( "f_e7m1_area_4E_place_trigger: START" );
f_e7m1_area_4E_place_action( DEF_E7M1_AI_OBJCON_AREA_4C, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 10,4, DEF_E8M2_OBJECTIVE_AREA_4E, DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_GATE, 5, 8, 20, 30 );
//dprint( "f_e7m1_area_4E_place_trigger: STOP" );
end
script dormant f_e7m1_area_4F_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3C, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_4F_start', "play_mus_pve_e07m1_encounter_area_4F_start", 'play_mus_pve_e07m1_encounter_area_4F_end', "play_mus_pve_e07m1_encounter_area_4F_end", 'play_mus_pve_e07m1_encounter_level_4_start', "play_mus_pve_e07m1_encounter_level_4_start", 'play_mus_pve_e07m1_encounter_level_4_end', "play_mus_pve_e07m1_encounter_level_4_end" );
//dprint( "f_e7m1_area_4F_place_trigger: START" );
f_e7m1_area_4F_place_action( DEF_E7M1_AI_OBJCON_AREA_4E, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_1A, S_e7m1_ai_body_cnt + 20,4, DEF_E8M2_OBJECTIVE_AREA_4F, DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE, 10, 8, 15, 20 );
//dprint( "f_e7m1_area_4F_place_trigger: STOP" );
end
script dormant f_e7m1_area_5A_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_5A_start', "play_mus_pve_e07m1_encounter_area_5A_start", 'play_mus_pve_e07m1_encounter_area_5A_end', "play_mus_pve_e07m1_encounter_area_5A_end", 'play_mus_pve_e07m1_encounter_level_5_start', "play_mus_pve_e07m1_encounter_level_5_start", 'play_mus_pve_e07m1_encounter_level_5_end', "play_mus_pve_e07m1_encounter_level_5_end" );
//dprint( "f_e7m1_area_5A_place_trigger: START" );
f_e7m1_area_5A_place_action( DEF_E7M1_AI_OBJCON_AREA_4C, DEF_E7M1_AI_OBJCON_AREA_5A, DEF_E7M1_AI_OBJCON_AREA_5A, S_e7m1_ai_body_cnt + 10,5, DEF_E8M2_OBJECTIVE_AREA_5A, DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE, 8, 8, 15, 20 );
//dprint( "f_e7m1_area_5A_place_trigger: STOP" );
end
script dormant f_e7m1_area_5B_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4F, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_5B_start', "play_mus_pve_e07m1_encounter_area_5B_start", 'play_mus_pve_e07m1_encounter_area_5B_end', "play_mus_pve_e07m1_encounter_area_5B_end", 'play_mus_pve_e07m1_encounter_level_5_start', "play_mus_pve_e07m1_encounter_level_5_start", 'play_mus_pve_e07m1_encounter_level_5_end', "play_mus_pve_e07m1_encounter_level_5_end" );
//dprint( "f_e7m1_area_5B_place_trigger: START" );
f_e7m1_area_5B_place_action( DEF_E7M1_AI_OBJCON_AREA_5A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_5B, S_e7m1_ai_body_cnt + 10,5, DEF_E8M2_OBJECTIVE_AREA_5B, DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_GATE, 6, 8, 20, 30 );
//dprint( "f_e7m1_area_5B_place_trigger: STOP" );
end
script dormant f_e7m1_area_5C_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4B, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_5C_start', "play_mus_pve_e07m1_encounter_area_5C_start", 'play_mus_pve_e07m1_encounter_area_5C_end', "play_mus_pve_e07m1_encounter_area_5C_end", 'play_mus_pve_e07m1_encounter_level_5_start', "play_mus_pve_e07m1_encounter_level_5_start", 'play_mus_pve_e07m1_encounter_level_5_end', "play_mus_pve_e07m1_encounter_level_5_end" );
//dprint( "f_e7m1_area_5C_place_trigger: START" );
f_e7m1_area_5C_place_action( DEF_E7M1_AI_OBJCON_AREA_4E, DEF_E7M1_AI_OBJCON_AREA_4F, DEF_E7M1_AI_OBJCON_AREA_5C, S_e7m1_ai_body_cnt + 10,5, DEF_E8M2_OBJECTIVE_AREA_5C, DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_GATE, 10, 8, 15, 20 );
//dprint( "f_e7m1_area_5C_place_trigger: STOP" );
end
script dormant f_e7m1_area_6A_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_6A_start', "play_mus_pve_e07m1_encounter_area_6A_start", 'play_mus_pve_e07m1_encounter_area_6A_end', "play_mus_pve_e07m1_encounter_area_6A_end", 'play_mus_pve_e07m1_encounter_level_6_start', "play_mus_pve_e07m1_encounter_level_6_start", 'play_mus_pve_e07m1_encounter_level_6_end', "play_mus_pve_e07m1_encounter_level_6_end" );
//dprint( "f_e7m1_area_6A_place_trigger: START" );
f_e7m1_area_6A_place_action( DEF_E7M1_AI_OBJCON_AREA_6A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_6A, S_e7m1_ai_body_cnt + 10,6, DEF_E8M2_OBJECTIVE_AREA_6A, DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE, 10, 8, 15, 20 );
//dprint( "f_e7m1_area_6A_place_trigger: STOP" );
end
script dormant f_e7m1_area_6B_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5B, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_6B_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_6B_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_6B_start', "play_mus_pve_e07m1_encounter_area_6B_start", 'play_mus_pve_e07m1_encounter_area_6B_end', "play_mus_pve_e07m1_encounter_area_6B_end", 'play_mus_pve_e07m1_encounter_level_6_start', "play_mus_pve_e07m1_encounter_level_6_start", 'play_mus_pve_e07m1_encounter_level_6_end', "play_mus_pve_e07m1_encounter_level_6_end" );
//dprint( "f_e7m1_area_6B_place_trigger: START" );
f_e7m1_area_6B_place_action( DEF_E7M1_AI_OBJCON_AREA_6B, DEF_E7M1_AI_OBJCON_AREA_6A, DEF_E7M1_AI_OBJCON_AREA_6B, S_e7m1_ai_body_cnt + 10,6, DEF_E8M2_OBJECTIVE_AREA_6B, DEF_E8M2_OBJECTIVE_AREA_6B_ENEMY_GATE, 10, 8, 15, 20 );
//dprint( "f_e7m1_area_6B_place_trigger: STOP" );
end
script dormant f_e7m1_area_6C_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5C, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_6C_start', "play_mus_pve_e07m1_encounter_area_6C_start", 'play_mus_pve_e07m1_encounter_area_6C_end', "play_mus_pve_e07m1_encounter_area_6C_end", 'play_mus_pve_e07m1_encounter_level_6_start', "play_mus_pve_e07m1_encounter_level_6_start", 'play_mus_pve_e07m1_encounter_level_6_end', "play_mus_pve_e07m1_encounter_level_6_end" );
//dprint( "f_e7m1_area_6C_place_trigger: START" );
f_e7m1_area_6C_place_action( DEF_E7M1_AI_OBJCON_AREA_6C, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_6C, S_e7m1_ai_body_cnt + 20,6, DEF_E8M2_OBJECTIVE_AREA_6C, DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_GATE, 8, 8, 15, 20 );
//dprint( "f_e7m1_area_6C_place_trigger: STOP" );
end
script dormant f_e7m1_area_7A_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_7A_start', "play_mus_pve_e07m1_encounter_area_7A_start", 'play_mus_pve_e07m1_encounter_area_7A_end', "play_mus_pve_e07m1_encounter_area_7A_end", 'play_mus_pve_e07m1_encounter_level_7_start', "play_mus_pve_e07m1_encounter_level_7_start", 'play_mus_pve_e07m1_encounter_level_7_end', "play_mus_pve_e07m1_encounter_level_7_end" );
//dprint( "f_e7m1_area_7A_place_trigger: START" );
f_e7m1_area_7A_place_action( DEF_E7M1_AI_OBJCON_AREA_6C, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_7A, S_e7m1_ai_body_cnt + 10,7, DEF_E8M2_OBJECTIVE_AREA_7A, DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_GATE, 6, 8, 15, 20 );
//dprint( "f_e7m1_area_7A_place_trigger: STOP" );
end
script dormant f_e7m1_area_7B_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_7B_start', "play_mus_pve_e07m1_encounter_area_7B_start", 'play_mus_pve_e07m1_encounter_area_7B_end', "play_mus_pve_e07m1_encounter_area_7B_end", 'play_mus_pve_e07m1_encounter_level_7_start', "play_mus_pve_e07m1_encounter_level_7_start", 'play_mus_pve_e07m1_encounter_level_7_end', "play_mus_pve_e07m1_encounter_level_7_end" );
//dprint( "f_e7m1_area_7B_place_trigger: START" );
f_e7m1_area_7B_place_action( DEF_E7M1_AI_OBJCON_AREA_7A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_7B, S_e7m1_ai_body_cnt + 10,7, DEF_E8M2_OBJECTIVE_AREA_7B, DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_GATE, 4, 8, 15, 20 );
//dprint( "f_e7m1_area_7B_place_trigger: STOP" );
end
script dormant f_e7m1_area_7C_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_7C_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_7C_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_7C_start', "play_mus_pve_e07m1_encounter_area_7C_start", 'play_mus_pve_e07m1_encounter_area_7C_end', "play_mus_pve_e07m1_encounter_area_7C_end", 'play_mus_pve_e07m1_encounter_level_7_start', "play_mus_pve_e07m1_encounter_level_7_start", 'play_mus_pve_e07m1_encounter_level_7_end', "play_mus_pve_e07m1_encounter_level_7_end" );
//dprint( "f_e7m1_area_7C_place_trigger: START" );
f_e7m1_area_7C_place_action( DEF_E7M1_AI_OBJCON_AREA_7B, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_7C, S_e7m1_ai_body_cnt + 10,7, DEF_E8M2_OBJECTIVE_AREA_7C, DEF_E8M2_OBJECTIVE_AREA_7C_ENEMY_GATE, 6, 8, 20, 25 );
//dprint( "f_e7m1_area_7C_place_trigger: STOP" );
end
script dormant f_e7m1_area_8A_place_trigger()
sleep_until( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A, 1 );
f_e7m1_audio_music_area_encounter( DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_COMBAT_GATE, 'play_mus_pve_e07m1_encounter_area_8A_start', "play_mus_pve_e07m1_encounter_area_8A_start", 'play_mus_pve_e07m1_encounter_area_8A_end', "play_mus_pve_e07m1_encounter_area_8A_end", 'play_mus_pve_e07m1_encounter_level_8_start', "play_mus_pve_e07m1_encounter_level_8_start", 'play_mus_pve_e07m1_encounter_level_8_end', "play_mus_pve_e07m1_encounter_level_8_end" );
//dprint( "f_e7m1_area_8A_place_trigger: START" );
f_e7m1_area_8A_place_action( DEF_E7M1_AI_OBJCON_AREA_7B, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_8A, S_e7m1_ai_body_cnt + 10,8, DEF_E8M2_OBJECTIVE_AREA_8A, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, 15, 8, 15, 20 );
//dprint( "f_e7m1_area_8A_place_trigger: STOP" );
end
//
script static boolean f_e7m1_ai_area_1A_advance_to_check()
( S_e7m1_area_1A_advance_to_cnt != 0 ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_1A ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_GATE) < 2 ) and ( volume_test_players(tv_e7m1_area_1A) );
end
script static boolean f_e7m1_ai_area_2A_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_2E ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_GATE) < 5 );
end
script static boolean f_e7m1_ai_area_2B_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3A ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_2C_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3A ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_GATE) < 10 );
end
script static boolean f_e7m1_ai_area_2D_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_2E ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_2E_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_2E ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_GATE) < 4 );
end
script static boolean f_e7m1_ai_area_3A_advance_to_check()
( S_e7m1_area_3A_advance_to_cnt != 0 ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3A ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_GATE) < 6 ) and ( volume_test_players(tv_e7m1_area_3A) );
end
script static boolean f_e7m1_ai_area_3B_advance_to_check()
( S_e7m1_area_3B_advance_to_cnt != 0 ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3C ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE) < 6 ) and ( volume_test_players(tv_e7m1_area_3B) );
end
script static boolean f_e7m1_ai_area_3C_advance_to_check()
( S_e7m1_area_3C_advance_to_cnt != 0 ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3C ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_GATE) < 4 ) and ( volume_test_players(tv_e7m1_area_3C) );
end
script static boolean f_e7m1_ai_area_4A_advance_to_check()
( S_e7m1_area_4A_advance_to_cnt != 0 ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4B ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_GATE) < 5 );
end
script static boolean f_e7m1_ai_area_4B_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4B ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_4C_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4E ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE) < 8 );
end
script static boolean f_e7m1_ai_area_4E_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4F ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_GATE) < 5 );
end
script static boolean f_e7m1_ai_area_4F_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4F ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE) < 10 );
end
script static boolean f_e7m1_ai_area_5A_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4F ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE) < 8 );
end
script static boolean f_e7m1_ai_area_5B_advance_to_check()
( S_e7m1_area_5B_advance_to_cnt != 0 ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_5B ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_5C_advance_to_check()
( S_e7m1_area_5C_advance_to_cnt != 0 ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_5C ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_GATE) < 10 ) and ( volume_test_players(tv_e7m1_area_5C) );
end
script static boolean f_e7m1_ai_area_6A_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_6A ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE) < 10 );
end
script static boolean f_e7m1_ai_area_6C_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_6C ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_GATE) < 8 ) and ( volume_test_players(tv_e7m1_area_6C) );
end
script static boolean f_e7m1_ai_area_7A_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_7A ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_7B_advance_to_check()
( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_7C ) and ( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_GATE) < 4 );
end
//
script static void f_e7m1_ai_area_1A_advance_to_action( ai ai_move )
S_e7m1_area_1A_advance_to_cnt = f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_1A, S_e7m1_area_1A_advance_to_cnt );
end
script static void f_e7m1_ai_area_2A_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_2A );
end
script static void f_e7m1_ai_area_2B_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_2B );
end
script static void f_e7m1_ai_area_2D_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_2D );
end
script static void f_e7m1_ai_area_2E_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_2E );
end
script static void f_e7m1_ai_area_3A_advance_to_action( ai ai_move )
S_e7m1_area_3A_advance_to_cnt = f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_3A, S_e7m1_area_3A_advance_to_cnt );
end
script static void f_e7m1_ai_area_3B_advance_to_action( ai ai_move )
S_e7m1_area_3B_advance_to_cnt = f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_3B, S_e7m1_area_3B_advance_to_cnt );
end
script static void f_e7m1_ai_area_3C_advance_to_action( ai ai_move )
S_e7m1_area_3C_advance_to_cnt = f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_3C, S_e7m1_area_3C_advance_to_cnt );
end
script static void f_e7m1_ai_area_4A_advance_to_action( ai ai_move )
S_e7m1_area_4A_advance_to_cnt = f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4A, S_e7m1_area_4A_advance_to_cnt );
end
script static void f_e7m1_ai_area_4B_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4B );
end
script static void f_e7m1_ai_area_4C_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4C );
end
script static void f_e7m1_ai_area_4E_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4E );
end
script static void f_e7m1_ai_area_4F_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4F );
end
script static void f_e7m1_ai_area_5A_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_5A );
end
script static void f_e7m1_ai_area_5B_advance_to_action( ai ai_move )
S_e7m1_area_5B_advance_to_cnt = f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_5B, S_e7m1_area_5B_advance_to_cnt );
end
script static void f_e7m1_ai_area_5C_advance_to_action( ai ai_move )
S_e7m1_area_5C_advance_to_cnt = f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_5C, S_e7m1_area_5C_advance_to_cnt );
end
script static void f_e7m1_ai_area_6A_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_6A );
end
script static void f_e7m1_ai_area_6C_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_6C );
end
script static void f_e7m1_ai_area_7A_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_7A );
end
script static void f_e7m1_ai_area_7B_advance_to_action( ai ai_move )
f_e7m1_ai_area_advance_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_7B );
end
//
script static boolean f_e7m1_ai_area_2A_advance_to_1A_check()
f_e7m1_ai_area_1A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_2B_advance_to_2A_check()
f_e7m1_ai_area_2A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_2C_advance_to_2B_check()
f_e7m1_ai_area_2B_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_2D_advance_to_2E_check()
f_e7m1_ai_area_2E_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_2E_advance_to_2A_check()
f_e7m1_ai_area_2A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_3A_advance_to_2E_check()
f_e7m1_ai_area_2E_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_3B_advance_to_1A_check()
f_e7m1_ai_area_1A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_3C_advance_to_3A_check()
f_e7m1_ai_area_3A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_4A_advance_to_3B_check()
f_e7m1_ai_area_3B_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_4B_advance_to_3C_check()
f_e7m1_ai_area_3C_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_4C_advance_to_4A_check()
f_e7m1_ai_area_4A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_4D_advance_to_4C_check()
f_e7m1_ai_area_4C_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4D_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_4E_advance_to_4C_check()
f_e7m1_ai_area_4C_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_4F_advance_to_4B_check()
f_e7m1_ai_area_4B_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_5A_advance_to_4C_check()
f_e7m1_ai_area_4C_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_5B_advance_to_5A_check()
f_e7m1_ai_area_5A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_5C_advance_to_5B_check()
f_e7m1_ai_area_5B_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_6A_advance_to_5C_check()
f_e7m1_ai_area_5C_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_6B_advance_to_6A_check()
f_e7m1_ai_area_6A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_6B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_6C_advance_to_6A_check()
f_e7m1_ai_area_6A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_7A_advance_to_6C_check()
f_e7m1_ai_area_6C_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_7B_advance_to_7A_check()
f_e7m1_ai_area_7A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_7C_advance_to_7B_check()
f_e7m1_ai_area_7B_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_7C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_8A_advance_to_7B_check()
f_e7m1_ai_area_7B_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
//
script static boolean f_e7m1_ai_area_2C_advance_to_2D_check()
f_e7m1_ai_area_2D_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2C_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_3B_advance_to_3A_check()
f_e7m1_ai_area_3A_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_4E_advance_to_4F_check()
f_e7m1_ai_area_4F_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
script static boolean f_e7m1_ai_area_4F_advance_to_4E_check()
f_e7m1_ai_area_4E_advance_to_check() and ( (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) or (ai_task_status(DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_COMBAT_GATE) >= ai_task_status_occupied) );
end
//
script command_script cs_e7m1_ai_area_2A_advance_to_1A_action()
f_e7m1_ai_area_2A_advance_from_action( ai_current_actor );
f_e7m1_ai_area_1A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2B_advance_to_2A_action()
f_e7m1_ai_area_2B_advance_from_action( ai_current_actor );
f_e7m1_ai_area_2A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2C_advance_to_2B_action()
f_e7m1_ai_area_2C_advance_from_action( ai_current_actor );
f_e7m1_ai_area_2B_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2D_advance_to_2E_action()
f_e7m1_ai_area_2D_advance_from_action( ai_current_actor );
f_e7m1_ai_area_2E_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2E_advance_to_2A_action()
f_e7m1_ai_area_2E_advance_from_action( ai_current_actor );
f_e7m1_ai_area_2A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_3A_advance_to_2E_action()
f_e7m1_ai_area_3A_advance_from_action( ai_current_actor );
f_e7m1_ai_area_2E_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_3B_advance_to_1A_action()
f_e7m1_ai_area_3B_advance_from_action( ai_current_actor );
f_e7m1_ai_area_1A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_3C_advance_to_3A_action()
f_e7m1_ai_area_3C_advance_from_action( ai_current_actor );
f_e7m1_ai_area_3A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4A_advance_to_3B_action()
f_e7m1_ai_area_4A_advance_from_action( ai_current_actor );
f_e7m1_ai_area_3B_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4B_advance_to_3C_action()
f_e7m1_ai_area_4B_advance_from_action( ai_current_actor );
f_e7m1_ai_area_3C_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4C_advance_to_4A_action()
f_e7m1_ai_area_4C_advance_from_action( ai_current_actor );
f_e7m1_ai_area_4A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4D_advance_to_4C_action()
f_e7m1_ai_area_4D_advance_from_action( ai_current_actor );
f_e7m1_ai_area_4C_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4E_advance_to_4C_action()
f_e7m1_ai_area_4E_advance_from_action( ai_current_actor );
f_e7m1_ai_area_4C_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4F_advance_to_4B_action()
f_e7m1_ai_area_4F_advance_from_action( ai_current_actor );
f_e7m1_ai_area_4B_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_5A_advance_to_4C_action()
f_e7m1_ai_area_5A_advance_from_action( ai_current_actor );
f_e7m1_ai_area_4C_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_5B_advance_to_5A_action()
f_e7m1_ai_area_5B_advance_from_action( ai_current_actor );
f_e7m1_ai_area_5A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_5C_advance_to_5B_action()
f_e7m1_ai_area_5C_advance_from_action( ai_current_actor );
f_e7m1_ai_area_5B_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_6A_advance_to_5C_action()
f_e7m1_ai_area_6A_advance_from_action( ai_current_actor );
f_e7m1_ai_area_5C_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_6B_advance_to_6A_action()
f_e7m1_ai_area_6B_advance_from_action( ai_current_actor );
f_e7m1_ai_area_6A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_6C_advance_to_6A_action()
f_e7m1_ai_area_6C_advance_from_action( ai_current_actor );
f_e7m1_ai_area_6A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_7A_advance_to_6C_action()
f_e7m1_ai_area_7A_advance_from_action( ai_current_actor );
f_e7m1_ai_area_6C_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_7B_advance_to_7A_action()
f_e7m1_ai_area_7B_advance_from_action( ai_current_actor );
f_e7m1_ai_area_7A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_7C_advance_to_7B_action()
f_e7m1_ai_area_7C_advance_from_action( ai_current_actor );
f_e7m1_ai_area_7B_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_8A_advance_to_7B_action()
f_e7m1_ai_area_8A_advance_from_action( ai_current_actor );
f_e7m1_ai_area_7B_advance_to_action( ai_current_actor );
end
//
script command_script cs_e7m1_ai_area_2C_advance_to_2D_action()
f_e7m1_ai_area_2C_advance_from_action( ai_current_actor );
f_e7m1_ai_area_2D_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_3B_advance_to_3A_action()
f_e7m1_ai_area_3B_advance_from_action( ai_current_actor );
f_e7m1_ai_area_3A_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4E_advance_to_4F_action()
f_e7m1_ai_area_4E_advance_from_action( ai_current_actor );
f_e7m1_ai_area_4F_advance_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4F_advance_to_4E_action()
f_e7m1_ai_area_4F_advance_from_action( ai_current_actor );
f_e7m1_ai_area_4E_advance_to_action( ai_current_actor );
end
//
script static boolean f_e7m1_ai_area_2A_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_1A );
end
script static boolean f_e7m1_ai_area_2B_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_2E );
end
script static boolean f_e7m1_ai_area_2C_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_2E );
end
script static boolean f_e7m1_ai_area_2D_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_2C );
end
script static boolean f_e7m1_ai_area_2E_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_2B );
end
script static boolean f_e7m1_ai_area_3A_advance_from_check()
( S_e7m1_area_3A_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2E ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_2E );
end
script static boolean f_e7m1_ai_area_3B_advance_from_check()
( S_e7m1_area_3B_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_3C_advance_from_check()
( S_e7m1_area_3C_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2E ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_4A_advance_from_check()
( S_e7m1_area_4A_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3B ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3B );
end
script static boolean f_e7m1_ai_area_4B_advance_from_check()
( S_e7m1_area_4B_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3C ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_3C );
end
script static boolean f_e7m1_ai_area_4C_advance_from_check()
( S_e7m1_area_4C_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4A );
end
script static boolean f_e7m1_ai_area_4D_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4C );
end
script static boolean f_e7m1_ai_area_4E_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4F );
end
script static boolean f_e7m1_ai_area_4F_advance_from_check()
( S_e7m1_area_4F_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4B ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4B );
end
script static boolean f_e7m1_ai_area_5A_advance_from_check()
( S_e7m1_area_5A_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_4D );
end
script static boolean f_e7m1_ai_area_5B_advance_from_check()
( S_e7m1_area_5B_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_5A );
end
script static boolean f_e7m1_ai_area_5C_advance_from_check()
( S_e7m1_area_5C_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5B ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_5B );
end
script static boolean f_e7m1_ai_area_6A_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5C ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_6A );
end
script static boolean f_e7m1_ai_area_6B_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5C ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_6C );
end
script static boolean f_e7m1_ai_area_6C_advance_from_check()
( S_e7m1_area_6C_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_6B );
end
script static boolean f_e7m1_ai_area_7A_advance_from_check()
( S_e7m1_area_7A_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6C ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_6C );
end
script static boolean f_e7m1_ai_area_7B_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_7A );
end
script static boolean f_e7m1_ai_area_7C_advance_from_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A );
end
script static boolean f_e7m1_ai_area_8A_advance_from_check()
( S_e7m1_area_8A_advance_from_cnt != 0 ) and ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7B ) and ( R_e7m1_objcon <= DEF_E7M1_AI_OBJCON_AREA_7B );
end
//
script static void f_e7m1_ai_area_2A_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2A, 'play_mus_pve_e07m1_encounter_area_2A_advance', "play_mus_pve_e07m1_encounter_area_2A_advance", 'play_mus_pve_e07m1_encounter_level_2_advance', "play_mus_pve_e07m1_encounter_level_2_advance" );
end
script static void f_e7m1_ai_area_2B_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2B, 'play_mus_pve_e07m1_encounter_area_2B_advance', "play_mus_pve_e07m1_encounter_area_2B_advance", 'play_mus_pve_e07m1_encounter_level_2_advance', "play_mus_pve_e07m1_encounter_level_2_advance" );
end
script static void f_e7m1_ai_area_2C_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2C, 'play_mus_pve_e07m1_encounter_area_2C_advance', "play_mus_pve_e07m1_encounter_area_2C_advance", 'play_mus_pve_e07m1_encounter_level_2_advance', "play_mus_pve_e07m1_encounter_level_2_advance" );
end
script static void f_e7m1_ai_area_2D_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2D, 'play_mus_pve_e07m1_encounter_area_2D_advance', "play_mus_pve_e07m1_encounter_area_2D_advance", 'play_mus_pve_e07m1_encounter_level_2_advance', "play_mus_pve_e07m1_encounter_level_2_advance" );
end
script static void f_e7m1_ai_area_2E_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2E, 'play_mus_pve_e07m1_encounter_area_2E_advance', "play_mus_pve_e07m1_encounter_area_2E_advance", 'play_mus_pve_e07m1_encounter_level_2_advance', "play_mus_pve_e07m1_encounter_level_2_advance" );
end
script static void f_e7m1_ai_area_3A_advance_from_action( ai ai_move )
S_e7m1_area_3A_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_3A, 'play_mus_pve_e07m1_encounter_area_3A_advance', "play_mus_pve_e07m1_encounter_area_3A_advance", 'play_mus_pve_e07m1_encounter_level_3_advance', "play_mus_pve_e07m1_encounter_level_3_advance", S_e7m1_area_3A_advance_from_cnt );
end
script static void f_e7m1_ai_area_3B_advance_from_action( ai ai_move )
S_e7m1_area_3B_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_3B, 'play_mus_pve_e07m1_encounter_area_3B_advance', "play_mus_pve_e07m1_encounter_area_3B_advance", 'play_mus_pve_e07m1_encounter_level_3_advance', "play_mus_pve_e07m1_encounter_level_3_advance", S_e7m1_area_3B_advance_from_cnt );
end
script static void f_e7m1_ai_area_3C_advance_from_action( ai ai_move )
S_e7m1_area_3C_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_3C, 'play_mus_pve_e07m1_encounter_area_3C_advance', "play_mus_pve_e07m1_encounter_area_3C_advance", 'play_mus_pve_e07m1_encounter_level_3_advance', "play_mus_pve_e07m1_encounter_level_3_advance", S_e7m1_area_3C_advance_from_cnt );
end
script static void f_e7m1_ai_area_4A_advance_from_action( ai ai_move )
S_e7m1_area_4A_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4A, 'play_mus_pve_e07m1_encounter_area_4A_advance', "play_mus_pve_e07m1_encounter_area_4A_advance", 'play_mus_pve_e07m1_encounter_level_4_advance', "play_mus_pve_e07m1_encounter_level_4_advance", S_e7m1_area_4A_advance_from_cnt );
end
script static void f_e7m1_ai_area_4B_advance_from_action( ai ai_move )
S_e7m1_area_4B_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4B, 'play_mus_pve_e07m1_encounter_area_4B_advance', "play_mus_pve_e07m1_encounter_area_4B_advance", 'play_mus_pve_e07m1_encounter_level_4_advance', "play_mus_pve_e07m1_encounter_level_4_advance", S_e7m1_area_4B_advance_from_cnt );
end
script static void f_e7m1_ai_area_4C_advance_from_action( ai ai_move )
S_e7m1_area_4C_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4C, 'play_mus_pve_e07m1_encounter_area_4C_advance', "play_mus_pve_e07m1_encounter_area_4C_advance", 'play_mus_pve_e07m1_encounter_level_4_advance', "play_mus_pve_e07m1_encounter_level_4_advance", S_e7m1_area_4C_advance_from_cnt );
end
script static void f_e7m1_ai_area_4D_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4D, 'play_mus_pve_e07m1_encounter_area_4D_advance', "play_mus_pve_e07m1_encounter_area_4D_advance", 'play_mus_pve_e07m1_encounter_level_4_advance', "play_mus_pve_e07m1_encounter_level_4_advance" );
end
script static void f_e7m1_ai_area_4E_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4E, 'play_mus_pve_e07m1_encounter_area_4E_advance', "play_mus_pve_e07m1_encounter_area_4E_advance", 'play_mus_pve_e07m1_encounter_level_4_advance', "play_mus_pve_e07m1_encounter_level_4_advance" );
end
script static void f_e7m1_ai_area_4F_advance_from_action( ai ai_move )
S_e7m1_area_4F_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4F, 'play_mus_pve_e07m1_encounter_area_4F_advance', "play_mus_pve_e07m1_encounter_area_4F_advance", 'play_mus_pve_e07m1_encounter_level_4_advance', "play_mus_pve_e07m1_encounter_level_4_advance", S_e7m1_area_4F_advance_from_cnt );
end
script static void f_e7m1_ai_area_5A_advance_from_action( ai ai_move )
S_e7m1_area_5A_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_5A, 'play_mus_pve_e07m1_encounter_area_5A_advance', "play_mus_pve_e07m1_encounter_area_5A_advance", 'play_mus_pve_e07m1_encounter_level_5_advance', "play_mus_pve_e07m1_encounter_level_5_advance", S_e7m1_area_5A_advance_from_cnt );
end
script static void f_e7m1_ai_area_5B_advance_from_action( ai ai_move )
S_e7m1_area_5B_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_5B, 'play_mus_pve_e07m1_encounter_area_5B_advance', "play_mus_pve_e07m1_encounter_area_5B_advance", 'play_mus_pve_e07m1_encounter_level_5_advance', "play_mus_pve_e07m1_encounter_level_5_advance", S_e7m1_area_5B_advance_from_cnt );
end
script static void f_e7m1_ai_area_5C_advance_from_action( ai ai_move )
S_e7m1_area_5C_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_5C, 'play_mus_pve_e07m1_encounter_area_5C_advance', "play_mus_pve_e07m1_encounter_area_5C_advance", 'play_mus_pve_e07m1_encounter_level_5_advance', "play_mus_pve_e07m1_encounter_level_5_advance", S_e7m1_area_5C_advance_from_cnt );
end
script static void f_e7m1_ai_area_6A_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_6A, 'play_mus_pve_e07m1_encounter_area_6A_advance', "play_mus_pve_e07m1_encounter_area_6A_advance", 'play_mus_pve_e07m1_encounter_level_6_advance', "play_mus_pve_e07m1_encounter_level_6_advance" );
end
script static void f_e7m1_ai_area_6B_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_6B, 'play_mus_pve_e07m1_encounter_area_6B_advance', "play_mus_pve_e07m1_encounter_area_6B_advance", 'play_mus_pve_e07m1_encounter_level_6_advance', "play_mus_pve_e07m1_encounter_level_6_advance" );
end
script static void f_e7m1_ai_area_6C_advance_from_action( ai ai_move )
S_e7m1_area_6C_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_6C, 'play_mus_pve_e07m1_encounter_area_6C_advance', "play_mus_pve_e07m1_encounter_area_6C_advance", 'play_mus_pve_e07m1_encounter_level_6_advance', "play_mus_pve_e07m1_encounter_level_6_advance", S_e7m1_area_6C_advance_from_cnt );
end
script static void f_e7m1_ai_area_7A_advance_from_action( ai ai_move )
S_e7m1_area_7A_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_7A, 'play_mus_pve_e07m1_encounter_area_7A_advance', "play_mus_pve_e07m1_encounter_area_7A_advance", 'play_mus_pve_e07m1_encounter_level_7_advance', "play_mus_pve_e07m1_encounter_level_7_advance", S_e7m1_area_7A_advance_from_cnt );
end
script static void f_e7m1_ai_area_7B_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_7B, 'play_mus_pve_e07m1_encounter_area_7B_advance', "play_mus_pve_e07m1_encounter_area_7B_advance", 'play_mus_pve_e07m1_encounter_level_7_advance', "play_mus_pve_e07m1_encounter_level_7_advance" );
end
script static void f_e7m1_ai_area_7C_advance_from_action( ai ai_move )
f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_7C, 'play_mus_pve_e07m1_encounter_area_7C_advance', "play_mus_pve_e07m1_encounter_area_7C_advance", 'play_mus_pve_e07m1_encounter_level_7_advance', "play_mus_pve_e07m1_encounter_level_7_advance" );
end
script static void f_e7m1_ai_area_8A_advance_from_action( ai ai_move )
S_e7m1_area_8A_advance_from_cnt = f_e7m1_ai_area_advance_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_8A, 'play_mus_pve_e07m1_encounter_area_8A_advance', "play_mus_pve_e07m1_encounter_area_8A_advance", 'play_mus_pve_e07m1_encounter_level_8_advance', "play_mus_pve_e07m1_encounter_level_8_advance", S_e7m1_area_8A_advance_from_cnt );
end
//
script static boolean f_e7m1_ai_area_1A_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_GATE) >= 3 );
end
script static boolean f_e7m1_ai_area_2A_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2E ) );
end
script static boolean f_e7m1_ai_area_2B_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2C ) );
end
script static boolean f_e7m1_ai_area_2C_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A ) );
end
script static boolean f_e7m1_ai_area_2D_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A ) );
end
script static boolean f_e7m1_ai_area_2E_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A ) );
end
script static boolean f_e7m1_ai_area_3A_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3B ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_GATE) >= 7 );
end
script static boolean f_e7m1_ai_area_3B_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE) >= 7 );
end
script static boolean f_e7m1_ai_area_3C_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_GATE) >= 5 );
end
script static boolean f_e7m1_ai_area_4A_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4B ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_GATE) >= 6 );
end
script static boolean f_e7m1_ai_area_4B_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C ) );
end
script static boolean f_e7m1_ai_area_4C_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4E ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE) >= 10 );
end
script static boolean f_e7m1_ai_area_4D_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4E ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_4D_ENEMY_GATE) >= 10 );
end
script static boolean f_e7m1_ai_area_4E_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4F ) );
end
script static boolean f_e7m1_ai_area_4F_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5B ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE) >= 12 );
end
script static boolean f_e7m1_ai_area_5A_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5B ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE) >= 12 );
end
script static boolean f_e7m1_ai_area_5B_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5C ) );
end
script static boolean f_e7m1_ai_area_5C_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6A ) ) or ( ai_body_count(DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_GATE) >= 10 );
end
script static boolean f_e7m1_ai_area_6A_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6C ) );
end
script static boolean f_e7m1_ai_area_6B_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6C ) );
end
script static boolean f_e7m1_ai_area_6C_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A ) );
end
script static boolean f_e7m1_ai_area_7A_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7B ) );
end
script static boolean f_e7m1_ai_area_7B_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_8A ) );
end
script static boolean f_e7m1_ai_area_7C_retreat_check()
( ( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_8A ) );
end
//
script static boolean f_e7m1_ai_area_2A_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A );
end
script static boolean f_e7m1_ai_area_2B_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2A );
end
script static boolean f_e7m1_ai_area_2D_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2C );
end
script static boolean f_e7m1_ai_area_2E_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_1A );
end
script static boolean f_e7m1_ai_area_3A_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_2D );
end
script static boolean f_e7m1_ai_area_3B_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_3C_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3A );
end
script static boolean f_e7m1_ai_area_4A_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3B );
end
script static boolean f_e7m1_ai_area_4B_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_3C );
end
script static boolean f_e7m1_ai_area_4C_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4A );
end
script static boolean f_e7m1_ai_area_4E_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C );
end
script static boolean f_e7m1_ai_area_4F_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4B );
end
script static boolean f_e7m1_ai_area_5A_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_4C );
end
script static boolean f_e7m1_ai_area_5B_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5A );
end
script static boolean f_e7m1_ai_area_5C_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5A );
end
script static boolean f_e7m1_ai_area_6A_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_5C );
end
script static boolean f_e7m1_ai_area_6C_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6A );
end
script static boolean f_e7m1_ai_area_7A_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_6C );
end
script static boolean f_e7m1_ai_area_7B_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7A );
end
script static boolean f_e7m1_ai_area_8A_retreat_to_check()
( R_e7m1_objcon >= DEF_E7M1_AI_OBJCON_AREA_7B );
end
//
script static boolean f_e7m1_ai_area_1A_retreat_to_2A_unit_check()
f_e7m1_ai_area_2A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_2A_retreat_to_2E_unit_check()
f_e7m1_ai_area_2E_retreat_to_check();
end
script static boolean f_e7m1_ai_area_2B_retreat_to_2A_unit_check()
f_e7m1_ai_area_2A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_2C_retreat_to_2B_unit_check()
f_e7m1_ai_area_2B_retreat_to_check();
end
script static boolean f_e7m1_ai_area_2D_retreat_to_2E_unit_check()
f_e7m1_ai_area_2E_retreat_to_check();
end
script static boolean f_e7m1_ai_area_2E_retreat_to_3A_unit_check()
( ( S_e7m1_area_2E_retreat_from_cnt != 0 ) ) and f_e7m1_ai_area_3A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_3A_retreat_to_3B_unit_check()
f_e7m1_ai_area_3B_retreat_to_check();
end
script static boolean f_e7m1_ai_area_3B_retreat_to_4A_unit_check()
f_e7m1_ai_area_4A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_3C_retreat_to_4B_unit_check()
f_e7m1_ai_area_4B_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4A_retreat_to_4C_unit_check()
f_e7m1_ai_area_4C_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4B_retreat_to_4F_unit_check()
f_e7m1_ai_area_4F_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4C_retreat_to_5A_unit_check()
f_e7m1_ai_area_5A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4D_retreat_to_4C_unit_check()
f_e7m1_ai_area_4C_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4E_retreat_to_4F_unit_check()
f_e7m1_ai_area_4F_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4F_retreat_to_4E_unit_check()
f_e7m1_ai_area_4E_retreat_to_check();
end
script static boolean f_e7m1_ai_area_5A_retreat_to_5B_unit_check()
f_e7m1_ai_area_5B_retreat_to_check();
end
script static boolean f_e7m1_ai_area_5B_retreat_to_5C_unit_check()
f_e7m1_ai_area_5C_retreat_to_check();
end
script static boolean f_e7m1_ai_area_5C_retreat_to_6A_unit_check()
f_e7m1_ai_area_6A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_6A_retreat_to_6C_unit_check()
f_e7m1_ai_area_6C_retreat_to_check();
end
script static boolean f_e7m1_ai_area_6B_retreat_to_6A_unit_check()
f_e7m1_ai_area_6A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_6C_retreat_to_7A_unit_check()
f_e7m1_ai_area_7A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_7A_retreat_to_7B_unit_check()
f_e7m1_ai_area_7B_retreat_to_check();
end
script static boolean f_e7m1_ai_area_7B_retreat_to_8A_unit_check()
f_e7m1_ai_area_8A_retreat_to_check();
end
script static boolean f_e7m1_ai_area_7C_retreat_to_7B_unit_check()
f_e7m1_ai_area_7B_retreat_to_check();
end
//
script static boolean f_e7m1_ai_area_1A_retreat_to_3B_unit_check()
f_e7m1_ai_area_3B_retreat_to_check();
end
script static boolean f_e7m1_ai_area_2C_retreat_to_2D_unit_check()
f_e7m1_ai_area_2D_retreat_to_check();
end
script static boolean f_e7m1_ai_area_3A_retreat_to_3C_unit_check()
f_e7m1_ai_area_3C_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4C_retreat_to_4E_unit_check()
f_e7m1_ai_area_4E_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4E_retreat_to_4C_unit_check()
f_e7m1_ai_area_4C_retreat_to_check();
end
script static boolean f_e7m1_ai_area_4F_retreat_to_5C_unit_check()
f_e7m1_ai_area_5C_retreat_to_check();
end
//
script static boolean f_e7m1_ai_area_1A_retreat_to_unit_check()
TRUE;
end
script static boolean f_e7m1_ai_area_2A_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_GATE) < 5 );
end
script static boolean f_e7m1_ai_area_2B_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2B_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_2C_retreat_to_unit_check()
TRUE;
end
script static boolean f_e7m1_ai_area_2D_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2D_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_2E_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_GATE) < 4 );
end
script static boolean f_e7m1_ai_area_3A_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_3B_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_3C_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_GATE) < 4 );
end
script static boolean f_e7m1_ai_area_4A_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_GATE) < 5 );
end
script static boolean f_e7m1_ai_area_4B_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_4C_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE) < 8 );
end
script static boolean f_e7m1_ai_area_4D_retreat_to_unit_check()
TRUE;
end
script static boolean f_e7m1_ai_area_4E_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4E_ENEMY_GATE) < 5 );
end
script static boolean f_e7m1_ai_area_4F_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE) < 10 );
end
script static boolean f_e7m1_ai_area_5A_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE) < 8 );
end
script static boolean f_e7m1_ai_area_5B_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_5B_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_5C_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_GATE) < 10 );
end
script static boolean f_e7m1_ai_area_6A_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE) < 10 );
end
script static boolean f_e7m1_ai_area_6B_retreat_to_unit_check()
TRUE;
end
script static boolean f_e7m1_ai_area_6C_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_GATE) < 8 );
end
script static boolean f_e7m1_ai_area_7A_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_GATE) < 6 );
end
script static boolean f_e7m1_ai_area_7B_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_GATE) < 4 );
end
script static boolean f_e7m1_ai_area_7C_retreat_to_unit_check()
TRUE;
end
script static boolean f_e7m1_ai_area_8A_retreat_to_unit_check()
( ai_task_count(DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE) < 15 );
end
//
script static void f_e7m1_ai_area_2A_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_2A );
end
script static void f_e7m1_ai_area_2B_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_2B );
end
script static void f_e7m1_ai_area_2D_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_2D );
end
script static void f_e7m1_ai_area_2E_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_2E );
end
script static void f_e7m1_ai_area_3A_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_3A );
end
script static void f_e7m1_ai_area_3B_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_3B );
end
script static void f_e7m1_ai_area_3C_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_3C );
end
script static void f_e7m1_ai_area_4A_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4A );
end
script static void f_e7m1_ai_area_4B_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4B );
end
script static void f_e7m1_ai_area_4C_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4C );
end
script static void f_e7m1_ai_area_4E_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4E );
end
script static void f_e7m1_ai_area_4F_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_4F );
end
script static void f_e7m1_ai_area_5A_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_5A );
end
script static void f_e7m1_ai_area_5B_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_5B );
end
script static void f_e7m1_ai_area_5C_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_5C );
end
script static void f_e7m1_ai_area_6A_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_6A );
end
script static void f_e7m1_ai_area_6C_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_6C );
end
script static void f_e7m1_ai_area_7A_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_7A );
end
script static void f_e7m1_ai_area_7B_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_7B );
end
script static void f_e7m1_ai_area_8A_retreat_to_action( ai ai_move )
f_e7m1_ai_area_retreat_to( ai_move, DEF_E8M2_OBJECTIVE_AREA_8A );
end
//
script static void f_e7m1_ai_area_1A_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_1A, 'play_mus_pve_e07m1_encounter_area_1A_retreat', "play_mus_pve_e07m1_encounter_area_1A_retreat", 'play_mus_pve_e07m1_encounter_level_1_retreat', "play_mus_pve_e07m1_encounter_level_1_retreat" );
end
script static void f_e7m1_ai_area_2A_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2A, 'play_mus_pve_e07m1_encounter_area_2A_retreat', "play_mus_pve_e07m1_encounter_area_2A_retreat", 'play_mus_pve_e07m1_encounter_level_2_retreat', "play_mus_pve_e07m1_encounter_level_2_retreat" );
end
script static void f_e7m1_ai_area_2B_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2B, 'play_mus_pve_e07m1_encounter_area_2B_retreat', "play_mus_pve_e07m1_encounter_area_2B_retreat", 'play_mus_pve_e07m1_encounter_level_2_retreat', "play_mus_pve_e07m1_encounter_level_2_retreat" );
end
script static void f_e7m1_ai_area_2C_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2C, 'play_mus_pve_e07m1_encounter_area_2C_retreat', "play_mus_pve_e07m1_encounter_area_2C_retreat", 'play_mus_pve_e07m1_encounter_level_2_retreat', "play_mus_pve_e07m1_encounter_level_2_retreat" );
end
script static void f_e7m1_ai_area_2D_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2D, 'play_mus_pve_e07m1_encounter_area_2D_retreat', "play_mus_pve_e07m1_encounter_area_2D_retreat", 'play_mus_pve_e07m1_encounter_level_2_retreat', "play_mus_pve_e07m1_encounter_level_2_retreat" );
end
script static void f_e7m1_ai_area_2E_retreat_from_action( ai ai_move )
S_e7m1_area_2E_retreat_from_cnt = f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_2E, 'play_mus_pve_e07m1_encounter_area_2E_retreat', "play_mus_pve_e07m1_encounter_area_2E_retreat", 'play_mus_pve_e07m1_encounter_level_2_retreat', "play_mus_pve_e07m1_encounter_level_2_retreat", S_e7m1_area_2E_retreat_from_cnt );
end
script static void f_e7m1_ai_area_3A_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_3A, 'play_mus_pve_e07m1_encounter_area_3A_retreat', "play_mus_pve_e07m1_encounter_area_3A_retreat", 'play_mus_pve_e07m1_encounter_level_3_retreat', "play_mus_pve_e07m1_encounter_level_3_retreat" );
end
script static void f_e7m1_ai_area_3B_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_3B, 'play_mus_pve_e07m1_encounter_area_3B_retreat', "play_mus_pve_e07m1_encounter_area_3B_retreat", 'play_mus_pve_e07m1_encounter_level_3_retreat', "play_mus_pve_e07m1_encounter_level_3_retreat" );
end
script static void f_e7m1_ai_area_3C_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_3C, 'play_mus_pve_e07m1_encounter_area_3C_retreat', "play_mus_pve_e07m1_encounter_area_3C_retreat", 'play_mus_pve_e07m1_encounter_level_3_retreat', "play_mus_pve_e07m1_encounter_level_3_retreat" );
end
script static void f_e7m1_ai_area_4A_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4A, 'play_mus_pve_e07m1_encounter_area_4A_retreat', "play_mus_pve_e07m1_encounter_area_4A_retreat", 'play_mus_pve_e07m1_encounter_level_4_retreat', "play_mus_pve_e07m1_encounter_level_4_retreat" );
end
script static void f_e7m1_ai_area_4B_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4B, 'play_mus_pve_e07m1_encounter_area_4B_retreat', "play_mus_pve_e07m1_encounter_area_4B_retreat", 'play_mus_pve_e07m1_encounter_level_4_retreat', "play_mus_pve_e07m1_encounter_level_4_retreat" );
end
script static void f_e7m1_ai_area_4C_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4C, 'play_mus_pve_e07m1_encounter_area_4C_retreat', "play_mus_pve_e07m1_encounter_area_4C_retreat", 'play_mus_pve_e07m1_encounter_level_4_retreat', "play_mus_pve_e07m1_encounter_level_4_retreat" );
end
script static void f_e7m1_ai_area_4D_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4D, 'play_mus_pve_e07m1_encounter_area_4D_retreat', "play_mus_pve_e07m1_encounter_area_4D_retreat", 'play_mus_pve_e07m1_encounter_level_4_retreat', "play_mus_pve_e07m1_encounter_level_4_retreat" );
end
script static void f_e7m1_ai_area_4E_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4E, 'play_mus_pve_e07m1_encounter_area_4E_retreat', "play_mus_pve_e07m1_encounter_area_4E_retreat", 'play_mus_pve_e07m1_encounter_level_4_retreat', "play_mus_pve_e07m1_encounter_level_4_retreat" );
end
script static void f_e7m1_ai_area_4F_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_4F, 'play_mus_pve_e07m1_encounter_area_4F_retreat', "play_mus_pve_e07m1_encounter_area_4F_retreat", 'play_mus_pve_e07m1_encounter_level_4_retreat', "play_mus_pve_e07m1_encounter_level_4_retreat" );
end
script static void f_e7m1_ai_area_5A_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_5A, 'play_mus_pve_e07m1_encounter_area_5A_retreat', "play_mus_pve_e07m1_encounter_area_5A_retreat", 'play_mus_pve_e07m1_encounter_level_5_retreat', "play_mus_pve_e07m1_encounter_level_5_retreat" );
end
script static void f_e7m1_ai_area_5B_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_5B, 'play_mus_pve_e07m1_encounter_area_5B_retreat', "play_mus_pve_e07m1_encounter_area_5B_retreat", 'play_mus_pve_e07m1_encounter_level_5_retreat', "play_mus_pve_e07m1_encounter_level_5_retreat" );
end
script static void f_e7m1_ai_area_5C_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_5C, 'play_mus_pve_e07m1_encounter_area_5C_retreat', "play_mus_pve_e07m1_encounter_area_5C_retreat", 'play_mus_pve_e07m1_encounter_level_5_retreat', "play_mus_pve_e07m1_encounter_level_5_retreat" );
end
script static void f_e7m1_ai_area_6A_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_6A, 'play_mus_pve_e07m1_encounter_area_6A_retreat', "play_mus_pve_e07m1_encounter_area_6A_retreat", 'play_mus_pve_e07m1_encounter_level_6_retreat', "play_mus_pve_e07m1_encounter_level_6_retreat" );
end
script static void f_e7m1_ai_area_6B_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_6B, 'play_mus_pve_e07m1_encounter_area_6B_retreat', "play_mus_pve_e07m1_encounter_area_6B_retreat", 'play_mus_pve_e07m1_encounter_level_6_retreat', "play_mus_pve_e07m1_encounter_level_6_retreat" );
end
script static void f_e7m1_ai_area_6C_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_6C, 'play_mus_pve_e07m1_encounter_area_6C_retreat', "play_mus_pve_e07m1_encounter_area_6C_retreat", 'play_mus_pve_e07m1_encounter_level_6_retreat', "play_mus_pve_e07m1_encounter_level_6_retreat" );
end
script static void f_e7m1_ai_area_7A_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_7A, 'play_mus_pve_e07m1_encounter_area_7A_retreat', "play_mus_pve_e07m1_encounter_area_7A_retreat", 'play_mus_pve_e07m1_encounter_level_7_retreat', "play_mus_pve_e07m1_encounter_level_7_retreat" );
end
script static void f_e7m1_ai_area_7B_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_7B, 'play_mus_pve_e07m1_encounter_area_7B_retreat', "play_mus_pve_e07m1_encounter_area_7B_retreat", 'play_mus_pve_e07m1_encounter_level_7_retreat', "play_mus_pve_e07m1_encounter_level_7_retreat" );
end
script static void f_e7m1_ai_area_7C_retreat_from_action( ai ai_move )
f_e7m1_ai_area_retreat_from( ai_move, DEF_E8M2_OBJECTIVE_AREA_7C, 'play_mus_pve_e07m1_encounter_area_7C_retreat', "play_mus_pve_e07m1_encounter_area_7C_retreat", 'play_mus_pve_e07m1_encounter_level_7_retreat', "play_mus_pve_e07m1_encounter_level_7_retreat" );
end
//
script command_script cs_e7m1_ai_area_1A_retreat_to_2A_action()
f_e7m1_ai_area_1A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_2A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2A_retreat_to_2E_action()
f_e7m1_ai_area_2A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_2E_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2B_retreat_to_2A_action()
f_e7m1_ai_area_2B_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_2A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2C_retreat_to_2B_action()
f_e7m1_ai_area_2C_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_2B_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2D_retreat_to_2E_action()
f_e7m1_ai_area_2D_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_2E_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2E_retreat_to_3A_action()
f_e7m1_ai_area_2E_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_3A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_3A_retreat_to_3B_action()
f_e7m1_ai_area_3A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_3B_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_3B_retreat_to_4A_action()
f_e7m1_ai_area_3B_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_3C_retreat_to_4B_action()
f_e7m1_ai_area_3C_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4B_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4A_retreat_to_4C_action()
f_e7m1_ai_area_4A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4C_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4B_retreat_to_4F_action()
f_e7m1_ai_area_4B_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4F_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4C_retreat_to_5A_action()
f_e7m1_ai_area_4C_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_5A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4D_retreat_to_4C_action()
f_e7m1_ai_area_4D_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4C_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4E_retreat_to_4F_action()
f_e7m1_ai_area_4E_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4F_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4F_retreat_to_4E_action()
f_e7m1_ai_area_4F_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4E_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_5A_retreat_to_5B_action()
f_e7m1_ai_area_5A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_5B_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_5B_retreat_to_5C_action()
f_e7m1_ai_area_5B_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_5C_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_5C_retreat_to_6A_action()
f_e7m1_ai_area_5C_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_6A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_6A_retreat_to_6C_action()
f_e7m1_ai_area_6A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_6C_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_6B_retreat_to_6A_action()
f_e7m1_ai_area_6B_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_6A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_6C_retreat_to_7A_action()
f_e7m1_ai_area_6C_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_7A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_7A_retreat_to_7B_action()
f_e7m1_ai_area_7A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_7B_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_7B_retreat_to_8A_action()
f_e7m1_ai_area_7B_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_8A_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_7C_retreat_to_7B_action()
f_e7m1_ai_area_7C_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_7B_retreat_to_action( ai_current_actor );
end
//
script command_script cs_e7m1_ai_area_1A_retreat_to_3B_action()
f_e7m1_ai_area_1A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_3B_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_2C_retreat_to_2D_action()
f_e7m1_ai_area_2C_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_2D_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_3A_retreat_to_3C_action()
f_e7m1_ai_area_3A_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_3C_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4C_retreat_to_4E_action()
f_e7m1_ai_area_4C_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4E_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4E_retreat_to_4C_action()
f_e7m1_ai_area_4E_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_4C_retreat_to_action( ai_current_actor );
end
script command_script cs_e7m1_ai_area_4F_retreat_to_5C_action()
f_e7m1_ai_area_4F_retreat_from_action( ai_current_actor );
f_e7m1_ai_area_5C_retreat_to_action( ai_current_actor );
end
//
//
script startup f_e7m1_respawn_area_1A()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_1A, tv_e7m1_area_1A, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_2A, scn_e7m1_respawn_area_1A, 1, DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_1A_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_2A()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_2A, tv_e7m1_area_2A, DEF_E7M1_AI_OBJCON_AREA_2A, DEF_E7M1_AI_OBJCON_AREA_3A, scn_e7m1_respawn_area_2A, 2, DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_2A_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_2E()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_2E, tv_e7m1_area_2E, DEF_E7M1_AI_OBJCON_AREA_2E, DEF_E7M1_AI_OBJCON_AREA_3A, scn_e7m1_respawn_area_2E, 2, DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_2E_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_3A()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_3A, tv_e7m1_area_3A, DEF_E7M1_AI_OBJCON_AREA_3A, DEF_E7M1_AI_OBJCON_AREA_4A, scn_e7m1_respawn_area_3A, 2, DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_3A_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_3B()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_3B, tv_e7m1_area_3B, DEF_E7M1_AI_OBJCON_AREA_3B, DEF_E7M1_AI_OBJCON_AREA_4A, scn_e7m1_respawn_area_3B, 2, DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_3C()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_3C, tv_e7m1_area_3C, DEF_E7M1_AI_OBJCON_AREA_3C, DEF_E7M1_AI_OBJCON_AREA_4A, scn_e7m1_respawn_area_3C, 2, DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_3C_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_4A()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_4A, tv_e7m1_area_4A, DEF_E7M1_AI_OBJCON_AREA_4A, DEF_E7M1_AI_OBJCON_AREA_5A, scn_e7m1_respawn_area_4A, 3, DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_4A_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_4B()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_4B, tv_e7m1_area_4B, DEF_E7M1_AI_OBJCON_AREA_4B, DEF_E7M1_AI_OBJCON_AREA_5A, scn_e7m1_respawn_area_4B, 3, DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_4B_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_4C()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_4C, tv_e7m1_area_4C, DEF_E7M1_AI_OBJCON_AREA_4C, DEF_E7M1_AI_OBJCON_AREA_5A, scn_e7m1_respawn_area_4C, 3, DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_4F()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_4F, tv_e7m1_area_4F, DEF_E7M1_AI_OBJCON_AREA_4F, DEF_E7M1_AI_OBJCON_AREA_5A, scn_e7m1_respawn_area_4F, 3, DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_5A()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_5A, tv_e7m1_area_5A, DEF_E7M1_AI_OBJCON_AREA_5A, DEF_E7M1_AI_OBJCON_AREA_6A, scn_e7m1_respawn_area_5A, 2, DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_5C()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_5C, tv_e7m1_area_5C, DEF_E7M1_AI_OBJCON_AREA_5C, DEF_E7M1_AI_OBJCON_AREA_6A, scn_e7m1_respawn_area_5C, 2, DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_5C_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_6A()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_6A, tv_e7m1_area_6A, DEF_E7M1_AI_OBJCON_AREA_6A, DEF_E7M1_AI_OBJCON_AREA_7A, scn_e7m1_respawn_area_6A, 2, DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE, TRUE, DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_6C()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_6C, tv_e7m1_area_6C, DEF_E7M1_AI_OBJCON_AREA_6C, DEF_E7M1_AI_OBJCON_AREA_7A, scn_e7m1_respawn_area_6C, 2, DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_6C_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_7A()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_7A, tv_e7m1_area_7A, DEF_E7M1_AI_OBJCON_AREA_7A, DEF_E7M1_AI_OBJCON_AREA_8A, scn_e7m1_respawn_area_7A, 2, DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_7A_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_7B()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_7B, tv_e7m1_area_7B, DEF_E7M1_AI_OBJCON_AREA_7B, DEF_E7M1_AI_OBJCON_AREA_8A, scn_e7m1_respawn_area_7B, 2, DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_GATE, FALSE, DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_COMBAT_GATE, TRUE );
end
script startup f_e7m1_respawn_area_8A()
 f_e7m1_respawn_manage( fld_e7m1_respawn_area_8A, tv_e7m1_area_8A, DEF_E7M1_AI_OBJCON_AREA_8A, DEF_E7M1_AI_OBJCON_AREA_NONE, scn_e7m1_respawn_area_8A, 2, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, TRUE, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_COMBAT_GATE, TRUE );
end
//
script startup f_e7m1_changer_3B_manage()
f_e7m1_changers_manage( dm_08_m2_changer_area_03B, DEF_E8M2_OBJECTIVE_AREA_3B_ENEMY_GATE, 18.75, 15, DEF_E7M1_AI_OBJCON_AREA_1A, DEF_E7M1_AI_OBJCON_AREA_4C );
end
script startup f_e7m1_changer_4C_manage()
f_e7m1_changers_manage( dm_08_m2_changer_area_04C, DEF_E8M2_OBJECTIVE_AREA_4C_ENEMY_GATE, 25, 20, DEF_E7M1_AI_OBJCON_AREA_4A, DEF_E7M1_AI_OBJCON_AREA_6A );
end
script startup f_e7m1_changer_4F_manage()
f_e7m1_changers_manage( dm_08_m2_changer_area_04F, DEF_E8M2_OBJECTIVE_AREA_4F_ENEMY_GATE, 25, 20, DEF_E7M1_AI_OBJCON_AREA_4B, DEF_E7M1_AI_OBJCON_AREA_6A );
end
script startup f_e7m1_changer_5A_manage()
f_e7m1_changers_manage( dm_08_m2_changer_area_05A, DEF_E8M2_OBJECTIVE_AREA_5A_ENEMY_GATE, 25, 20, DEF_E7M1_AI_OBJCON_AREA_4C, DEF_E7M1_AI_OBJCON_AREA_6A );
end
script startup f_e7m1_changer_6A_manage()
f_e7m1_changers_manage( dm_08_m2_changer_area_06A, DEF_E8M2_OBJECTIVE_AREA_6A_ENEMY_GATE, 25, 20, DEF_E7M1_AI_OBJCON_AREA_5C, DEF_E7M1_AI_OBJCON_AREA_7A );
end
script startup f_e7m1_changer_7B_manage()
f_e7m1_changers_manage( dm_08_m2_changer_area_07B, DEF_E8M2_OBJECTIVE_AREA_7B_ENEMY_GATE, 25, 20, DEF_E7M1_AI_OBJCON_AREA_7A );
end
script startup f_e7m1_changer_8A_manage()
f_e7m1_changers_manage( dm_08_m2_changer_area_08A, DEF_E8M2_OBJECTIVE_AREA_8A_ENEMY_GATE, 25, 20, DEF_E7M1_AI_OBJCON_AREA_7B );
end
//
script static boolean f_e7m1_changer_3B_use_check()
( object_valid( dm_08_m2_changer_area_03B ) ) and dm_08_m2_changer_area_03B-> use_check_enemy( 2.5 ) and ( f_e7m1_barriers_deactivated_cnt() > 0);
end
script static boolean f_e7m1_changer_4C_use_check()
( object_valid( dm_08_m2_changer_area_04C ) ) and dm_08_m2_changer_area_04C-> use_check_enemy( 2.5 ) and ( f_e7m1_barriers_deactivated_cnt() > 0);
end
script static boolean f_e7m1_changer_4F_use_check()
( object_valid( dm_08_m2_changer_area_04F ) ) and dm_08_m2_changer_area_04F-> use_check_enemy( 2.5 ) and ( f_e7m1_barriers_deactivated_cnt() > 0);
end
script static boolean f_e7m1_changer_5A_use_check()
( object_valid( dm_08_m2_changer_area_05A ) ) and dm_08_m2_changer_area_05A-> use_check_enemy( 2.5 ) and ( f_e7m1_barriers_deactivated_cnt() > 0);
end
script static boolean f_e7m1_changer_6A_use_check()
( object_valid( dm_08_m2_changer_area_06A ) ) and dm_08_m2_changer_area_06A-> use_check_enemy( 2.5 ) and ( f_e7m1_barriers_deactivated_cnt() > 0);
end
script static boolean f_e7m1_changer_7B_use_check()
( object_valid( dm_08_m2_changer_area_07B ) ) and dm_08_m2_changer_area_07B-> use_check_enemy( 2.5 ) and ( f_e7m1_barriers_deactivated_cnt() > 0);
end
script static boolean f_e7m1_changer_8A_use_check()
( object_valid( dm_08_m2_changer_area_08A ) ) and dm_08_m2_changer_area_08A-> use_check_enemy( 2.5 ) and ( f_e7m1_barriers_deactivated_cnt() > 0);
end
//
script command_script cs_e7m1_changer_3B_interact_grunt()
dm_08_m2_changer_area_03B->user_ai( ai_current_actor );
f_e7m1_changer_interact_grunt( ai_current_actor, dm_08_m2_changer_area_03B );
end
script command_script cs_e7m1_changer_4C_interact_grunt()
dm_08_m2_changer_area_04C->user_ai( ai_current_actor );
f_e7m1_changer_interact_grunt( ai_current_actor, dm_08_m2_changer_area_04C );
end
script command_script cs_e7m1_changer_4F_interact_grunt()
dm_08_m2_changer_area_04F->user_ai( ai_current_actor );
f_e7m1_changer_interact_grunt( ai_current_actor, dm_08_m2_changer_area_04F );
end
script command_script cs_e7m1_changer_5A_interact_grunt()
dm_08_m2_changer_area_05A->user_ai( ai_current_actor );
f_e7m1_changer_interact_grunt( ai_current_actor, dm_08_m2_changer_area_05A );
end
script command_script cs_e7m1_changer_6A_interact_grunt()
dm_08_m2_changer_area_06A->user_ai( ai_current_actor );
f_e7m1_changer_interact_grunt( ai_current_actor, dm_08_m2_changer_area_06A );
end
script command_script cs_e7m1_changer_7B_interact_grunt()
dm_08_m2_changer_area_07B->user_ai( ai_current_actor );
f_e7m1_changer_interact_grunt( ai_current_actor, dm_08_m2_changer_area_07B );
end
script command_script cs_e7m1_changer_8A_interact_grunt()
dm_08_m2_changer_area_08A->user_ai( ai_current_actor );
f_e7m1_changer_interact_grunt( ai_current_actor, dm_08_m2_changer_area_08A );
end
//
script command_script cs_e7m1_changer_3B_interact_jackal()
dm_08_m2_changer_area_03B->user_ai( ai_current_actor );
f_e7m1_changer_interact_jackal( ai_current_actor, dm_08_m2_changer_area_03B );
end
script command_script cs_e7m1_changer_4C_interact_jackal()
dm_08_m2_changer_area_04C->user_ai( ai_current_actor );
f_e7m1_changer_interact_jackal( ai_current_actor, dm_08_m2_changer_area_04C );
end
script command_script cs_e7m1_changer_4F_interact_jackal()
dm_08_m2_changer_area_04F->user_ai( ai_current_actor );
f_e7m1_changer_interact_jackal( ai_current_actor, dm_08_m2_changer_area_04F );
end
script command_script cs_e7m1_changer_5A_interact_jackal()
dm_08_m2_changer_area_05A->user_ai( ai_current_actor );
f_e7m1_changer_interact_jackal( ai_current_actor, dm_08_m2_changer_area_05A );
end
script command_script cs_e7m1_changer_6A_interact_jackal()
dm_08_m2_changer_area_06A->user_ai( ai_current_actor );
f_e7m1_changer_interact_jackal( ai_current_actor, dm_08_m2_changer_area_06A );
end
script command_script cs_e7m1_changer_7B_interact_jackal()
dm_08_m2_changer_area_07B->user_ai( ai_current_actor );
f_e7m1_changer_interact_jackal( ai_current_actor, dm_08_m2_changer_area_07B );
end
script command_script cs_e7m1_changer_8A_interact_jackal()
dm_08_m2_changer_area_08A->user_ai( ai_current_actor );
f_e7m1_changer_interact_jackal( ai_current_actor, dm_08_m2_changer_area_08A );
end
//
script command_script cs_e7m1_changer_3B_interact_elite()
dm_08_m2_changer_area_03B->user_ai( ai_current_actor );
f_e7m1_changer_interact_elite( ai_current_actor, dm_08_m2_changer_area_03B );
end
script command_script cs_e7m1_changer_4C_interact_elite()
dm_08_m2_changer_area_04C->user_ai( ai_current_actor );
f_e7m1_changer_interact_elite( ai_current_actor, dm_08_m2_changer_area_04C );
end
script command_script cs_e7m1_changer_4F_interact_elite()
dm_08_m2_changer_area_04F->user_ai( ai_current_actor );
f_e7m1_changer_interact_elite( ai_current_actor, dm_08_m2_changer_area_04F );
end
script command_script cs_e7m1_changer_5A_interact_elite()
dm_08_m2_changer_area_05A->user_ai( ai_current_actor );
f_e7m1_changer_interact_elite( ai_current_actor, dm_08_m2_changer_area_05A );
end
script command_script cs_e7m1_changer_6A_interact_elite()
dm_08_m2_changer_area_06A->user_ai( ai_current_actor );
f_e7m1_changer_interact_elite( ai_current_actor, dm_08_m2_changer_area_06A );
end
script command_script cs_e7m1_changer_7B_interact_elite()
dm_08_m2_changer_area_07B->user_ai( ai_current_actor );
f_e7m1_changer_interact_elite( ai_current_actor, dm_08_m2_changer_area_07B );
end
script command_script cs_e7m1_changer_8A_interact_elite()
dm_08_m2_changer_area_08A->user_ai( ai_current_actor );
f_e7m1_changer_interact_elite( ai_current_actor, dm_08_m2_changer_area_08A );
end
//
