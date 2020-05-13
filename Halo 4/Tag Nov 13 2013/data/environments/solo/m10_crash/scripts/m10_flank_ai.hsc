//HALLWAYS COMMAND SCRIPTS

//BEACON PHANTOMS
script command_script cs_lookout_phantom_01()
	kill_volume_disable(kill_observatory);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 );      //scale to a tiny point instantly
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	f_load_phantom (ai_current_actor, "dual", sq_lookout_beac_01, sq_lookout_beac_02, sq_lookout_beac_03, NONE );
	sleep(10);
	cs_fly_to(ps_lookout_phantom.p0);
	cs_fly_to(ps_lookout_phantom.p1);
	cs_stationary_face(true, ps_lookout_phantom.p2);
	sleep_s(1);
	sleep_until(volume_test_players(tv_lookout_vo));
	f_unload_phantom (ai_current_squad, "dual");
	cs_stationary_face(FALSE, ps_lookout_phantom.p2);
	sleep_s(3);
	cs_fly_to(ps_lookout_phantom.p6);
	cs_fly_to(ps_lookout_phantom.p7);
end

script command_script cs_lookout_phantom_02()
kill_volume_disable(kill_observatory);
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 );      //scale to a tiny point instantly
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 120 );    //scale up to full size over time
	f_load_phantom (sq_phantom_lookout_02, "left", sq_lookout_beac_04, sq_lookout_beac_05, none, NONE );
	sleep(10);
	cs_fly_to(ps_lookout_phantom.p3);
	cs_fly_to(ps_lookout_phantom.p4);
	cs_stationary_face(true, ps_lookout_phantom.p5);
	sleep_s(1);
	sleep_until(volume_test_players(tv_lookout_vo));
	dprint("unload");
	f_unload_phantom (ai_current_squad, "left");
	cs_stationary_face(FALSE, ps_lookout_phantom.p5);
	sleep_s(6);
	cs_fly_to(ps_lookout_phantom.p8);
	cs_fly_to(ps_lookout_phantom.p9);
	cs_fly_to(ps_lookout_phantom.p10);
	cs_fly_to(ps_lookout_phantom.p6);
	cs_fly_to(ps_lookout_phantom.p11);
end


//CORNER HALL 
script command_script cs_grunt_patrol_01()
cs_abort_on_damage(TRUE);
cs_abort_on_combat_status(8);
dprint("cs_grunt_patrol");
cs_walk(TRUE);
cs_go_to(ps_ch_patrol_01.p0);
cs_go_to(ps_ch_patrol_01.p1);
cs_go_to(ps_ch_patrol_01.p2);
end

script command_script cs_grunt_patrol_02()
cs_abort_on_damage(TRUE);
cs_abort_on_combat_status(8);
cs_walk(TRUE);
dprint("cs_grunt_patrol");
cs_go_to(ps_ch_patrol_01.p0);
cs_go_to(ps_ch_patrol_01.p1);
end

script command_script cs_grunt_patrol_retreat_01()
dprint("cs_grunt_patrol_retreat");
cs_abort_on_damage(TRUE);
cs_push_stance("flee");
cs_walk(FALSE);
cs_go_to(ps_ch_patrol_fallback_01.p0);
cs_go_to(ps_ch_patrol_fallback_01.p1);
cs_go_to(ps_ch_patrol_fallback_01.p2);
end

script command_script cs_grunt_patrol_retreat_02()
cs_push_stance("flee");
cs_walk(FALSE);
cs_abort_on_damage(TRUE);
cs_go_to(ps_ch_patrol_fallback_02.p0);
cs_go_to(ps_ch_patrol_fallback_02.p1);
cs_go_to(ps_ch_patrol_fallback_02.p2);
end

script command_script cs_clear()
	cs_abort_on_damage(TRUE);
	cs_abort_on_alert(TRUE);
	cs_walk(FALSE);
	cs_push_stance("");
end

script command_script cs_kamikazee()
dprint("cs_kamikazee");
cs_face_player(TRUE);
ai_grunt_kamikaze(ai_current_actor);
end

script command_script cs_grunt_retreat()
dprint("cs_grunt_retreat");
cs_push_stance("flee");
cs_walk(FALSE);
cs_abort_on_damage(TRUE);
cs_go_to(ps_ch_fallback_01.p0);
cs_go_to(ps_ch_fallback_01.p1);
cs_abort_on_combat_status(8);
cs_go_to(ps_ch_fallback_01.p2);
cs_go_to(ps_ch_fallback_01.p3);
sleep_until(volume_test_players(tv_corner_hall_spawn), 1);
cs_go_to(ps_ch_fallback_01.p4);
cs_go_to(ps_ch_fallback_01.p5);
end

script command_script cs_grunt_retreat_02()
dprint("cs_grunt_retreat");
cs_push_stance("flee");
cs_walk(FALSE);
cs_abort_on_damage(TRUE);
cs_go_to(ps_ch_fallback_02.p0);
cs_go_to(ps_ch_fallback_02.p1);
cs_abort_on_combat_status(8);
cs_go_to(ps_ch_fallback_02.p2);
sleep_until(volume_test_players(tv_corner_hall_spawn), 1);
cs_go_to(ps_ch_fallback_02.p3);
cs_go_to(ps_ch_fallback_02.p4);
cs_go_to(ps_ch_fallback_02.p5);

end

script command_script cs_grunt_door_pound()
dprint("cs_grunt_door_pound");
cs_push_stance("flee");
cs_walk(FALSE);
cs_abort_on_damage(TRUE);
cs_go_to(ps_ch_fallback_door.p0);
cs_go_to(ps_ch_fallback_door.p1);
cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"vin:global:solo:door_pound" , TRUE);
end

script command_script cs_grunt_panic()
cs_abort_on_damage(TRUE);
cs_abort_on_alert(TRUE);
cs_push_stance("flee");
dprint("panic");
cs_walk(TRUE);
cs_go_to(ps_ch_fallback_02.p4);
cs_go_to(ps_ch_fallback_02.p5);
end

script command_script cs_grunt_work()
dprint("cs_grunt_work");
end

script command_script cs_grunt_work_02()
dprint("cs_grunt_work_02");
end


script command_script cs_jackal_advance_01()
cs_teleport(ps_ch_jackal_reinforce.p0, ps_ch_jackal_reinforce.p2);
cs_pause(2.25);
cs_move_towards_point(ps_ch_jackal_reinforce.p2, 0.5);
end

script command_script cs_jackal_advance_02()
cs_teleport(ps_ch_jackal_reinforce.p1, ps_ch_jackal_reinforce.p3);
cs_pause(1);
cs_move_towards_point(ps_ch_jackal_reinforce.p3, 0.5);
end



script command_script cs_grunt_panel()
cs_abort_on_damage(TRUE);
cs_abort_on_combat_status(9);
repeat
dprint("panel");
sleep(10);
cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"vin:global:solo:door_panel_fiddle" , TRUE);
sleep(unit_get_custom_animation_time(ai_current_squad));
until(ai_combat_status(ai_current_squad) > 7);
end

script command_script cs_surprise_01()
sleep(random_range(0,15));
cs_face_player(TRUE);
cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"combat:pistol:surprise_front" , TRUE);
sleep(unit_get_custom_animation_time(ai_current_squad));
end

script command_script cs_surprise_02()
cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"combat:pistol:surprise_front" , TRUE);
sleep(unit_get_custom_animation_time(ai_current_squad));
cs_abort_on_damage(TRUE);
cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"combat:pistol:warn" , TRUE);
sleep(unit_get_custom_animation_time(ai_current_squad));

end


script command_script cs_grunt_examine()
cs_abort_on_damage(TRUE);
cs_abort_on_alert(TRUE);
cs_abort_on_combat_status(8);
cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"act_examine_1:enter" , TRUE);
repeat
sleep(unit_get_custom_animation_time(ai_current_squad));
cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"act_examine_1:idle" , TRUE);
sleep(unit_get_custom_animation_time(ai_current_squad));
//cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"act_examine_1:look" , TRUE);
sleep(unit_get_custom_animation_time(ai_current_squad));
//cs_custom_animation(objects\characters\storm_grunt\storm_grunt.model_animation_graph,"act_examine_1:exit" , TRUE);
sleep(unit_get_custom_animation_time(ai_current_squad));
until(ai_combat_status(ai_current_squad) > 8);
end
//vin:global:solo:grunt_injured