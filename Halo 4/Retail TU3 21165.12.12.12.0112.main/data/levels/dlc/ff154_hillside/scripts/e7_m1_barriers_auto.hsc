// BARRIERS AUTO SCRIPT
//
script startup f_e7m1_barrier_1A_to_2A_manage()
f_e7m1_barrier_manage( scn_e7m1_barrier_1A_to_2A, cr_e7m1_power_1A_to_2A, cr_e7m1_terminal_1A_to_2A, cr_e7m1_terminal_2A_to_1A, tv_e7m1_barrier_1A_blip, DEF_E7M1_AI_OBJCON_AREA_4A, 20, 10 );
end
script startup f_e7m1_barrier_1A_to_3B_manage()
f_e7m1_barrier_manage( scn_e7m1_barrier_1A_to_3B, cr_e7m1_power_1A_to_3B, NONE, cr_e7m1_terminal_3B_to_1A, tv_e7m1_barrier_1A_blip, DEF_E7M1_AI_OBJCON_AREA_4A, 20, 10 );
end
script startup f_e7m1_barrier_2E_to_3A_manage()
f_e7m1_barrier_manage( scn_e7m1_barrier_2E_to_3A, cr_e7m1_power_2E_to_3A, cr_e7m1_terminal_2E_to_3A, cr_e7m1_terminal_3A_to_2E, tv_e7m1_barrier_2E_blip, DEF_E7M1_AI_OBJCON_AREA_4A, 20, 10 );
end
script startup f_e7m1_barrier_3B_to_4A_manage()
f_e7m1_barrier_manage( scn_e7m1_barrier_3B_to_4A, cr_e7m1_power_3B_to_4A, cr_e7m1_terminal_3B_to_4A, cr_e7m1_terminal_4A_to_3B, tv_e7m1_barrier_3B_blip, DEF_E7M1_AI_OBJCON_AREA_4C, 20, 10 );
end
script startup f_e7m1_barrier_3C_to_4B_manage()
f_e7m1_barrier_manage( scn_e7m1_barrier_3C_to_4B, cr_e7m1_power_3C_to_4B, cr_e7m1_terminal_3C_to_4B, cr_e7m1_terminal_4B_to_3C, tv_e7m1_barrier_3C_blip, DEF_E7M1_AI_OBJCON_AREA_4F, 20, 10 );
end
script startup f_e7m1_barrier_4C_to_5A_manage()
f_e7m1_barrier_manage( scn_e7m1_barrier_4C_to_5A, cr_e7m1_power_4C_to_5A, cr_e7m1_terminal_4C_to_5A, cr_e7m1_terminal_5A_to_4C, tv_e7m1_barrier_4C_blip, DEF_E7M1_AI_OBJCON_AREA_5C, 20, 10 );
end
script startup f_e7m1_barrier_5C_to_6A_manage()
f_e7m1_barrier_manage( scn_e7m1_barrier_5C_to_6A, cr_e7m1_power_5C_to_6A, cr_e7m1_terminal_5C_to_6A, cr_e7m1_terminal_6A_to_5C, tv_e7m1_barrier_5C_blip, DEF_E7M1_AI_OBJCON_AREA_6C, 20, 10 );
end
script startup f_e7m1_barrier_6C_to_7A_manage()
f_e7m1_barrier_manage( scn_e7m1_barrier_6C_to_7A, cr_e7m1_power_6C_to_7A, cr_e7m1_terminal_6C_to_7A, cr_e7m1_terminal_7A_to_6C, tv_e7m1_barrier_6C_blip, DEF_E7M1_AI_OBJCON_AREA_8A, 15, 10 );
end
//
script static boolean f_e7m1_ai_area_1A_to_2A_barrier_open_check()
( not object_valid( scn_e7m1_barrier_1A_to_2A ) ) ;
end
script static boolean f_e7m1_ai_area_2A_to_1A_barrier_open_check()
( not object_valid( scn_e7m1_barrier_1A_to_2A ) ) ;
end
script static boolean f_e7m1_ai_area_1A_to_3B_barrier_open_check()
( not object_valid( scn_e7m1_barrier_1A_to_3B ) ) ;
end
script static boolean f_e7m1_ai_area_3B_to_1A_barrier_open_check()
( not object_valid( scn_e7m1_barrier_1A_to_3B ) ) ;
end
script static boolean f_e7m1_ai_area_2E_to_3A_barrier_open_check()
( not object_valid( scn_e7m1_barrier_2E_to_3A ) ) ;
end
script static boolean f_e7m1_ai_area_3A_to_2E_barrier_open_check()
( not object_valid( scn_e7m1_barrier_2E_to_3A ) ) ;
end
script static boolean f_e7m1_ai_area_3B_to_4A_barrier_open_check()
( not object_valid( scn_e7m1_barrier_3B_to_4A ) ) ;
end
script static boolean f_e7m1_ai_area_4A_to_3B_barrier_open_check()
( not object_valid( scn_e7m1_barrier_3B_to_4A ) ) ;
end
script static boolean f_e7m1_ai_area_3C_to_4B_barrier_open_check()
( not object_valid( scn_e7m1_barrier_3C_to_4B ) ) ;
end
script static boolean f_e7m1_ai_area_4B_to_3C_barrier_open_check()
( not object_valid( scn_e7m1_barrier_3C_to_4B ) ) ;
end
script static boolean f_e7m1_ai_area_4C_to_5A_barrier_open_check()
( not object_valid( scn_e7m1_barrier_4C_to_5A ) ) ;
end
script static boolean f_e7m1_ai_area_5A_to_4C_barrier_open_check()
( not object_valid( scn_e7m1_barrier_4C_to_5A ) ) ;
end
script static boolean f_e7m1_ai_area_5C_to_6A_barrier_open_check()
( not object_valid( scn_e7m1_barrier_5C_to_6A ) ) ;
end
script static boolean f_e7m1_ai_area_6A_to_5C_barrier_open_check()
( not object_valid( scn_e7m1_barrier_5C_to_6A ) ) ;
end
script static boolean f_e7m1_ai_area_6C_to_7A_barrier_open_check()
( not object_valid( scn_e7m1_barrier_6C_to_7A ) ) ;
end
script static boolean f_e7m1_ai_area_7A_to_6C_barrier_open_check()
( not object_valid( scn_e7m1_barrier_6C_to_7A ) ) ;
end
//
script static boolean f_e7m1_ai_area_1A_to_2A_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_1A_to_2A) and (ai_task_count(objectives_e7m1_area_2A.enemy_barrier_to_1A_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_2A_to_1A_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_1A_to_2A) and (ai_task_count(objectives_e7m1_area_1A.enemy_barrier_to_2A_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_1A_to_3B_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_1A_to_3B) and (ai_task_count(objectives_e7m1_area_3B.enemy_barrier_to_1A_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_3B_to_1A_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_1A_to_3B) and (ai_task_count(objectives_e7m1_area_1A.enemy_barrier_to_3B_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_2E_to_3A_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_2E_to_3A) and (ai_task_count(objectives_e7m1_area_3A.enemy_barrier_to_2E_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_3A_to_2E_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_2E_to_3A) and (ai_task_count(objectives_e7m1_area_2E.enemy_barrier_to_3A_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_3B_to_4A_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_3B_to_4A) and (ai_task_count(objectives_e7m1_area_4A.enemy_barrier_to_3B_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_4A_to_3B_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_3B_to_4A) and (ai_task_count(objectives_e7m1_area_3B.enemy_barrier_to_4A_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_3C_to_4B_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_3C_to_4B) and (ai_task_count(objectives_e7m1_area_4B.enemy_barrier_to_3C_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_4B_to_3C_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_3C_to_4B) and (ai_task_count(objectives_e7m1_area_3C.enemy_barrier_to_4B_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_4C_to_5A_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_4C_to_5A) and (ai_task_count(objectives_e7m1_area_5A.enemy_barrier_to_4C_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_5A_to_4C_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_4C_to_5A) and (ai_task_count(objectives_e7m1_area_4C.enemy_barrier_to_5A_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_5C_to_6A_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_5C_to_6A) and (ai_task_count(objectives_e7m1_area_6A.enemy_barrier_to_5C_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_6A_to_5C_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_5C_to_6A) and (ai_task_count(objectives_e7m1_area_5C.enemy_barrier_to_6A_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_6C_to_7A_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_6C_to_7A) and (ai_task_count(objectives_e7m1_area_7A.enemy_barrier_to_6C_interact_gate) <= 0) );
end
script static boolean f_e7m1_ai_area_7A_to_6C_barrier_interact_check()
f_e7m1_barrier_terminal_interact_check( object_valid(scn_e7m1_barrier_6C_to_7A) and (ai_task_count(objectives_e7m1_area_6C.enemy_barrier_to_7A_interact_gate) <= 0) );
end
//
script command_script cs_e7m1_ai_area_1A_barrier_to_2A_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_1A_to_2A, cr_e7m1_terminal_1A_to_2A );
end
script command_script cs_e7m1_ai_area_2A_barrier_to_1A_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_1A_to_2A, cr_e7m1_terminal_2A_to_1A );
end

script command_script cs_e7m1_ai_area_1A_barrier_to_2A_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_1A_to_2A, cr_e7m1_terminal_1A_to_2A );
end
script command_script cs_e7m1_ai_area_2A_barrier_to_1A_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_1A_to_2A, cr_e7m1_terminal_2A_to_1A );
end

script command_script cs_e7m1_ai_area_1A_barrier_to_2A_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_1A_to_2A, cr_e7m1_terminal_1A_to_2A );
end
script command_script cs_e7m1_ai_area_2A_barrier_to_1A_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_1A_to_2A, cr_e7m1_terminal_2A_to_1A );
end
script command_script cs_e7m1_ai_area_1A_barrier_to_3B_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_1A_to_3B, cr_e7m1_terminal_1A_to_3B );
end
script command_script cs_e7m1_ai_area_3B_barrier_to_1A_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_1A_to_3B, cr_e7m1_terminal_3B_to_1A );
end

script command_script cs_e7m1_ai_area_1A_barrier_to_3B_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_1A_to_3B, cr_e7m1_terminal_1A_to_3B );
end
script command_script cs_e7m1_ai_area_3B_barrier_to_1A_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_1A_to_3B, cr_e7m1_terminal_3B_to_1A );
end

script command_script cs_e7m1_ai_area_1A_barrier_to_3B_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_1A_to_3B, cr_e7m1_terminal_1A_to_3B );
end
script command_script cs_e7m1_ai_area_3B_barrier_to_1A_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_1A_to_3B, cr_e7m1_terminal_3B_to_1A );
end
script command_script cs_e7m1_ai_area_2E_barrier_to_3A_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_2E_to_3A, cr_e7m1_terminal_2E_to_3A );
end
script command_script cs_e7m1_ai_area_3A_barrier_to_2E_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_2E_to_3A, cr_e7m1_terminal_3A_to_2E );
end

script command_script cs_e7m1_ai_area_2E_barrier_to_3A_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_2E_to_3A, cr_e7m1_terminal_2E_to_3A );
end
script command_script cs_e7m1_ai_area_3A_barrier_to_2E_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_2E_to_3A, cr_e7m1_terminal_3A_to_2E );
end

script command_script cs_e7m1_ai_area_2E_barrier_to_3A_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_2E_to_3A, cr_e7m1_terminal_2E_to_3A );
end
script command_script cs_e7m1_ai_area_3A_barrier_to_2E_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_2E_to_3A, cr_e7m1_terminal_3A_to_2E );
end
script command_script cs_e7m1_ai_area_3B_barrier_to_4A_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_3B_to_4A, cr_e7m1_terminal_3B_to_4A );
end
script command_script cs_e7m1_ai_area_4A_barrier_to_3B_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_3B_to_4A, cr_e7m1_terminal_4A_to_3B );
end

script command_script cs_e7m1_ai_area_3B_barrier_to_4A_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_3B_to_4A, cr_e7m1_terminal_3B_to_4A );
end
script command_script cs_e7m1_ai_area_4A_barrier_to_3B_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_3B_to_4A, cr_e7m1_terminal_4A_to_3B );
end

script command_script cs_e7m1_ai_area_3B_barrier_to_4A_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_3B_to_4A, cr_e7m1_terminal_3B_to_4A );
end
script command_script cs_e7m1_ai_area_4A_barrier_to_3B_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_3B_to_4A, cr_e7m1_terminal_4A_to_3B );
end
script command_script cs_e7m1_ai_area_3C_barrier_to_4B_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_3C_to_4B, cr_e7m1_terminal_3C_to_4B );
end
script command_script cs_e7m1_ai_area_4B_barrier_to_3C_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_3C_to_4B, cr_e7m1_terminal_4B_to_3C );
end

script command_script cs_e7m1_ai_area_3C_barrier_to_4B_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_3C_to_4B, cr_e7m1_terminal_3C_to_4B );
end
script command_script cs_e7m1_ai_area_4B_barrier_to_3C_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_3C_to_4B, cr_e7m1_terminal_4B_to_3C );
end

script command_script cs_e7m1_ai_area_3C_barrier_to_4B_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_3C_to_4B, cr_e7m1_terminal_3C_to_4B );
end
script command_script cs_e7m1_ai_area_4B_barrier_to_3C_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_3C_to_4B, cr_e7m1_terminal_4B_to_3C );
end
script command_script cs_e7m1_ai_area_4C_barrier_to_5A_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_4C_to_5A, cr_e7m1_terminal_4C_to_5A );
end
script command_script cs_e7m1_ai_area_5A_barrier_to_4C_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_4C_to_5A, cr_e7m1_terminal_5A_to_4C );
end

script command_script cs_e7m1_ai_area_4C_barrier_to_5A_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_4C_to_5A, cr_e7m1_terminal_4C_to_5A );
end
script command_script cs_e7m1_ai_area_5A_barrier_to_4C_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_4C_to_5A, cr_e7m1_terminal_5A_to_4C );
end

script command_script cs_e7m1_ai_area_4C_barrier_to_5A_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_4C_to_5A, cr_e7m1_terminal_4C_to_5A );
end
script command_script cs_e7m1_ai_area_5A_barrier_to_4C_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_4C_to_5A, cr_e7m1_terminal_5A_to_4C );
end
script command_script cs_e7m1_ai_area_5C_barrier_to_6A_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_5C_to_6A, cr_e7m1_terminal_5C_to_6A );
end
script command_script cs_e7m1_ai_area_6A_barrier_to_5C_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_5C_to_6A, cr_e7m1_terminal_6A_to_5C );
end

script command_script cs_e7m1_ai_area_5C_barrier_to_6A_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_5C_to_6A, cr_e7m1_terminal_5C_to_6A );
end
script command_script cs_e7m1_ai_area_6A_barrier_to_5C_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_5C_to_6A, cr_e7m1_terminal_6A_to_5C );
end

script command_script cs_e7m1_ai_area_5C_barrier_to_6A_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_5C_to_6A, cr_e7m1_terminal_5C_to_6A );
end
script command_script cs_e7m1_ai_area_6A_barrier_to_5C_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_5C_to_6A, cr_e7m1_terminal_6A_to_5C );
end
script command_script cs_e7m1_ai_area_6C_barrier_to_7A_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_6C_to_7A, cr_e7m1_terminal_6C_to_7A );
end
script command_script cs_e7m1_ai_area_7A_barrier_to_6C_action_grunt()
 f_e7m1_barrier_terminal_interact_grunt( ai_current_actor, scn_e7m1_barrier_6C_to_7A, cr_e7m1_terminal_7A_to_6C );
end

script command_script cs_e7m1_ai_area_6C_barrier_to_7A_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_6C_to_7A, cr_e7m1_terminal_6C_to_7A );
end
script command_script cs_e7m1_ai_area_7A_barrier_to_6C_action_jackal()
 f_e7m1_barrier_terminal_interact_jackal( ai_current_actor, scn_e7m1_barrier_6C_to_7A, cr_e7m1_terminal_7A_to_6C );
end

script command_script cs_e7m1_ai_area_6C_barrier_to_7A_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_6C_to_7A, cr_e7m1_terminal_6C_to_7A );
end
script command_script cs_e7m1_ai_area_7A_barrier_to_6C_action_elite()
 f_e7m1_barrier_terminal_interact_elite( ai_current_actor, scn_e7m1_barrier_6C_to_7A, cr_e7m1_terminal_7A_to_6C );
end
