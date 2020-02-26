--// =============================================================================================================================
-- ============================================ ng101_wz_arc SCRIPTS ========================================================
-- =============================================================================================================================
--## SERVER




function cs_vtolcompstart()
	composer_play_show ("vin_warzone_arc_vtol", {vtol1 = ai_vehicle_get (ai_current_actor)});
end

function cs_loadvtolgunner()
	ai_vehicle_enter_immediate(ai_current_actor, ai_vehicle_get_from_squad(AI.hillside_boss_vtol), 'vtol_g');
end

function cs_pelican_reinforcement()
	cs_pelican_drop(nil,AI.sq_reinforcement_warthog,POINTS.ps_reinforcement_pelican, POINTS.ps_reinforcement_pelican.drop);
end

function cs_pelican_drop (ship_squad:ai, drop_squad:ai, ps:point_set, drop:point)
	ship_squad = ai_current_squad;
	
	if ship_squad == nil then
		print ("no dropship squad in function");
	end
	
	if ps == nil then
		print ("no point set specified");
		error ("you tried to call f_dropship without specifying a point set");
	end
	
	local driver:ai = ai_vehicle_get_driver(ai_vehicle_get_from_squad (ship_squad));
	local dropship:object = ai_vehicle_get_from_squad (ship_squad);
	
	--ai_place (drop_squad);
	
	--LOAD THE WARTHOG SQUAD TO THE PELICAN
	PelicanLoad (ship_squad, drop_squad);
	
	--FLY THE PELICAN TO THE POINTS
	--DROP OFF THE WARTHOG AT THE DESIGNATED SPOT
	--FLY THE REMAINDER OF THE POINTS
	--DESTROY ITSELF
	
	
	object_set_scale(dropship, 0.01, 1);
	object_cannot_die(dropship, true);
	sleep_s(1);
	object_set_scale(dropship, 1.0, seconds_to_frames (3));
	
	for i = 1, #ps do
		print ("flying to", ps[i]);
		cs_fly_by (driver, true, ps[i]);
		
		if ps[i] == drop then
			print ("unloading");
			sleep_s(0.3);
			--vehicle_hover (ai_vehicle_get_from_squad(ship_squad) , true);
	--======== DROP PASSENGERS HERE ======================
			
			PelicanDrop(ship_squad);
			
			--sleep_s(2);
			--vehicle_hover (ai_vehicle_get_from_squad(ship_squad) , false);
		end
	end
	
	object_set_scale(dropship, 0.01, (3 * n_fps()));
	sleep_s (3);
	ai_erase(ship_squad);
end

function PelicanLoad (ship_squad:ai, drop_squad:ai)
	print ("loading pelican");
	local pelican:object = ai_vehicle_get_from_squad(ship_squad);
	local warthog:object = ai_vehicle_get_from_squad(drop_squad);
	vehicle_load_magic (pelican, "pelican_lc", warthog);
end

function PelicanDrop(ship_squad:ai)
	print ("dropping pelican cargo");
	local pelican:object = ai_vehicle_get_from_squad(ship_squad);
	vehicle_unload (pelican, "pelican_lc");
end


function startup.audio_warzone_pa()

	repeat
		sleep_s(60);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00100.sound'), OBJECTS.audio_warzone_pa_crate_red_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00100.sound'), OBJECTS.audio_warzone_pa_crate_red_02, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00100.sound'), OBJECTS.audio_warzone_pa_crate_blue_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00100.sound'), OBJECTS.audio_warzone_pa_crate_blue_02, 1);
		--print ("pa announcement");
		sleep_s(60);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00200.sound'), OBJECTS.audio_warzone_pa_crate_red_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00200.sound'), OBJECTS.audio_warzone_pa_crate_red_02, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00200.sound'), OBJECTS.audio_warzone_pa_crate_blue_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00200.sound'), OBJECTS.audio_warzone_pa_crate_blue_02, 1);
		--print ("pa announcement");
		sleep_s(60);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00300.sound'), OBJECTS.audio_warzone_pa_crate_red_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00300.sound'), OBJECTS.audio_warzone_pa_crate_red_02, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00300.sound'), OBJECTS.audio_warzone_pa_crate_blue_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00300.sound'), OBJECTS.audio_warzone_pa_crate_blue_02, 1);
		--print ("pa announcement");
		sleep_s(60);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00400.sound'), OBJECTS.audio_warzone_pa_crate_red_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00400.sound'), OBJECTS.audio_warzone_pa_crate_red_02, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00400.sound'), OBJECTS.audio_warzone_pa_crate_blue_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00400.sound'), OBJECTS.audio_warzone_pa_crate_blue_02, 1);
		--print ("pa announcement");
		sleep_s(60);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00500.sound'), OBJECTS.audio_warzone_pa_crate_red_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00500.sound'), OBJECTS.audio_warzone_pa_crate_red_02, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00500.sound'), OBJECTS.audio_warzone_pa_crate_blue_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00500.sound'), OBJECTS.audio_warzone_pa_crate_blue_02, 1);
		--print ("pa announcement");
		sleep_s(60);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00600.sound'), OBJECTS.audio_warzone_pa_crate_red_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00600.sound'), OBJECTS.audio_warzone_pa_crate_red_02, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00600.sound'), OBJECTS.audio_warzone_pa_crate_blue_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00600.sound'), OBJECTS.audio_warzone_pa_crate_blue_02, 1);
		--print ("pa announcement");
		sleep_s(60);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00700.sound'), OBJECTS.audio_warzone_pa_crate_red_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00700.sound'), OBJECTS.audio_warzone_pa_crate_red_02, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00700.sound'), OBJECTS.audio_warzone_pa_crate_blue_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00700.sound'), OBJECTS.audio_warzone_pa_crate_blue_02, 1);
		--print ("pa announcement");
		sleep_s(60);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00800.sound'), OBJECTS.audio_warzone_pa_crate_red_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00800.sound'), OBJECTS.audio_warzone_pa_crate_red_02, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00800.sound'), OBJECTS.audio_warzone_pa_crate_blue_01, 1);
		SoundImpulseStartServer(TAG('sound\001_vo\001_vo_multiplayer\001_vo_mul_elevatorpa\001_vo_mul_un_elevatorpa_warzone_paannouncement_00800.sound'), OBJECTS.audio_warzone_pa_crate_blue_02, 1);
		--print ("pa announcement");
	until false;
		
end

-- PVE Scripts

function cs_cloak_up()
	Sleep(1);
	ai_set_active_camo(ai_current_actor, true);
end

function cs_cloak_down()
	sleep_s (random_range(.5, 1.5));
	ai_set_active_camo(ai_current_actor, false);
end

function cs_r5cloak_up()
	ai_set_active_camo(ai_current_actor, true);
	cs_jump (ai_current_actor, true, 45, 5);
	sleep_s (random_range(2, 4));
	ai_set_active_camo(ai_current_actor, false);
end

function f_ghost_boss_stay_in_vehicle()
	vehicle_set_unit_interaction(ai_vehicle_get(ai_current_actor), "", false, false);
end

function cs_bashee_entrance()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
end


function cs_bashee_boss_entrance_01()
	CreateThread (f_spawn_r4_banshee_trash_mob);
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_spawn_paths.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_spawn_paths.p02, 1);
end

function cs_bashee_boss_entrance_02()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_spawn_paths01.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_spawn_paths01.p02, 1);
end

function cs_bashee_boss_entrance_03()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_spawn_paths02.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_spawn_paths02.p02, 1);
end

function cs_bashee_boss_entrance_04()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_spawn_paths03.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_spawn_paths03.p02, 1);
end

function cs_wraith_boss_banshee_entrance_01()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	cs_fly_to(ai_current_actor, true, POINTS.wraith_boss_banshee_spawn_01.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.wraith_boss_banshee_spawn_01.p02, 1);
end

function cs_wraith_boss_banshee_entrance_02()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	cs_fly_to(ai_current_actor, true, POINTS.wraith_boss_banshee_spawn_02.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.wraith_boss_banshee_spawn_02.p02, 1);
end

function cs_loadr3wraith()
	ai_vehicle_enter_immediate(ai_current_actor, ai_vehicle_get_from_squad(AI.sq_pve_r3_wraith_boss), '');
end

function f_spawn_r2_watcher()
	CreateThread (f_create_r2_watcher);
end

function f_create_r2_watcher()
	SleepUntil([|ai_living_count( AI.pve_boss_sold_off_boss) <= 1], 6);
	SlipSpaceSpawn (AI.pve_boss_sold_off_watcher);
end

function f_r3_hunter_banshees()
	SleepUntil([|ai_living_count( AI.boss_loading_dock_boss) >= 4], 6);
	sleep_s (.5);
	SleepUntil([|ai_living_count( AI.boss_loading_dock_boss) <= 3], 6);
	if ai_living_count( AI.boss_loading_dock_boss) <= 3 then
		ai_place (AI.boss_loading_dock_trash_04);
	end
end

function cs_bashee_hunter_entrance_01()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
end

function f_spawn_r4_homebase_trash_mob()
	CreateThread (f_r4_homebase_trash_mob);
end



function f_r4_homebase_trash_mob()
	SleepUntil([|ai_living_count( AI.pve_r4_promethan_minions) >= 1], 6);
	SleepUntil([|ai_living_count( AI.pve_r4_promethan_minions) <= 15], 6);
	if ai_living_count( AI.pve_r4_promethan_boss) >= 1 then
		CreateThread (SlipSpaceSpawn, AI.sq_r4_w1_pro_left3);
		CreateThread (SlipSpaceSpawn, AI.sq_w1_3_mixed_right);
	end
end

function f_spawn_r4_banshee_trash_mob()
	CreateThread (f_spawn_r4_banshee_trash_mob_left);	
	CreateThread (f_spawn_r4_banshee_trash_mob_right);
end


function cs_bashee_boss_phantom_right_01()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	ai_place (AI.sg_generic_wz_minions_right);
	vehicle_load_magic (ai_vehicle_get(ai_current_actor), "phantom_p_", AI.sg_generic_wz_minions_right);
	ai_migrate(AI.sg_generic_wz_min_right_backup, AI.sg_generic_wz_minions_right);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.p02, 1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.drop, 1);
	vehicle_unload (ai_vehicle_get(ai_current_actor), "phantom_p_");
	sleep_s (5);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.p03, 1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.p04, 1);
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, 120);
	sleep_s (2);
	ai_erase(ai_vehicle_get_driver(ai_vehicle_get(ai_current_actor)));
end

function cs_bashee_boss_phantom_left_01()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	sleep_s (.5);
	ai_place (AI.sg_generic_wz_minions_left);
	vehicle_load_magic (ai_vehicle_get(ai_current_actor), "phantom_p_", AI.sg_generic_wz_minions_left);
	ai_migrate(AI.sg_generic_wz_min_left_backup, AI.sg_generic_wz_minions_left);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.p02, 1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.drop, 1);
	vehicle_unload (ai_vehicle_get(ai_current_actor), "phantom_p_");
	sleep_s (5);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.p03, 1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.p04, 1);
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, 120);
	sleep_s (2);
	ai_erase(ai_vehicle_get_driver(ai_vehicle_get(ai_current_actor)));
end

function cs_bashee_boss_phantom_right_02()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	ai_place (AI.sg_generic_wz_min_right_backup);
	vehicle_load_magic (ai_vehicle_get(ai_current_actor), "phantom_p_", AI.sg_generic_wz_min_right_backup);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.p02, 1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.drop, 1);
	vehicle_unload (ai_vehicle_get(ai_current_actor), "phantom_p_");
	sleep_s (5);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.p03, 1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_right.p04, 1);
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, 120);
	sleep_s (2);
	ai_erase(ai_vehicle_get_driver(ai_vehicle_get(ai_current_actor)));
end

function cs_bashee_boss_phantom_left_02()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	sleep_s (.5);
	ai_place (AI.sg_generic_wz_min_left_backup);
	vehicle_load_magic (ai_vehicle_get(ai_current_actor), "phantom_p_", AI.sg_generic_wz_min_left_backup);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.p02, 1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.drop, 1);
	vehicle_unload (ai_vehicle_get(ai_current_actor), "phantom_p_");
	sleep_s (5);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.p03, 1);
	cs_fly_to(ai_current_actor, true, POINTS.banshee_boss_phantom_left.p04, 1);
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, 120);
	sleep_s (2);
	ai_erase(ai_vehicle_get_driver(ai_vehicle_get(ai_current_actor)));
end

function f_spawn_r4_banshee_trash_mob_right()
	sleep_s (10);
	ai_place (AI.sq_phantom_right_01);
	SleepUntil([|ai_living_count( AI.sg_generic_wz_minions_right) >= 1], 6);
	SleepUntil([|ai_living_count( AI.sg_generic_wz_minions_right) <= 4], 6);
		if ai_living_count( AI.sg_r4_banshee_wz_boss_right) >= 1 then
			ai_place (AI.sq_phantom_right_02);
		end
end

function f_spawn_r4_banshee_trash_mob_left()
	sleep_s (10);
	ai_place (AI.sq_phantom_left_01);
	sleep_s (1)
	SleepUntil([|ai_living_count( AI.sg_generic_wz_minions_left) >= 1], 6);
	SleepUntil([|ai_living_count( AI.sg_generic_wz_minions_left) <= 4], 6);
		if ai_living_count( AI.sg_r4_banshee_wz_boss_left) >= 1 then
			ai_place (AI.sq_phantom_left_02);
		end
end


function f_spawn_r4_vtol_trashmob()
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobcrawlers);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobcrawlers01);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobcrawlers02);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobcrawlers03);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobcrawlers04);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobcrawlers05);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobcrawlers06);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmob);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmob01);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmob02);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobofficer);
	sleep_s (.2);
	CreateThread (SlipSpaceSpawn, AI.pve_r4_vtol_trashmobofficer01);
	sleep_s (.2);	
end

function cs_r5_cov_boss_entrance_01()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	cs_fly_to(ai_current_actor, true, POINTS.r5_cov_boss_banshee_spawn_01.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.r5_cov_boss_banshee_spawn_01.p02, 1);
end

function cs_r5_cov_boss_entrance_02()
	object_set_scale (ai_vehicle_get(ai_current_actor), .1, .1);
	cs_fly_to(ai_current_actor, true, POINTS.r5_cov_boss_banshee_spawn_02.p01, 1);
	object_set_scale(ai_vehicle_get(ai_current_actor), 1, 120);
	cs_fly_to(ai_current_actor, true, POINTS.r5_cov_boss_banshee_spawn_02.p02, 1);
end



function f_spawn_r5_altpro_w2_trashmob()
	if ai_living_count( AI.pve_r5_alt_promethean_w2_boss) >= 1 or 
		ai_living_count( AI.pve_r5_alt_promethean_w2_boss01) >= 1 then
		CreateThread (f_r5_altpro_w2_trashmob);
	end
end

function f_r5_altpro_w2_trashmob()
	SleepUntil([|ai_living_count( AI.pve_r5_alt_promethean_w2_minion) <= 6], 6);
	if ai_living_count( AI.pve_r5_alt_promethean_w2_boss) >= 1 or 
		ai_living_count( AI.pve_r5_alt_promethean_w2_boss01) >= 1 then
			CreateThread (SlipSpaceSpawn, AI.pve_r5_alt_promethean_w2_minion);
	end
end

function f_spawn_r5_w2_cov_backup_right_jackals()
	sleep_s (random_range(.5, 1.5));
	cs_jump (ai_current_actor, true, 45, 5);

end

function f_spawn_extra_banshees()
	CreateThread (respawn_r5_cov_w2_trash_left);
	CreateThread (respawn_r5_cov_w2_trash_right);
end

function respawn_r5_cov_w2_trash_left()
	ai_place (AI.round_5_cov_wave_2_backup_left);
	SleepUntil([|ai_living_count( AI.round_5_cov_wave_2_backup_left) <= 3], 6);
	if ai_living_count( AI.round_5_cov_wave_2_bosses) >= 1 then
		ai_place (AI.round_5_cov_wave_2_backup_left);
		sleep_s (1);
	end
	SleepUntil([|ai_living_count( AI.round_5_cov_wave_2_backup_left) <= 3], 6);
	if ai_living_count( AI.round_5_cov_wave_2_bosses) >= 1 then
		ai_place (AI.round_5_cov_wave_2_backup_left);
	end
	SleepUntil([|ai_living_count( AI.round_5_cov_wave_2_backup_left) <= 3], 6);
	if ai_living_count( AI.round_5_cov_wave_2_bosses) >= 1 then
		ai_place (AI.round_5_cov_wave_2_backup_left);
	end
end

function respawn_r5_cov_w2_trash_right()
	ai_place (AI.round_5_cov_wave_2_backup_right);
	SleepUntil([|ai_living_count( AI.round_5_cov_wave_2_backup_right) <= 3], 6);
	if ai_living_count( AI.round_5_cov_wave_2_bosses) >= 1 then
		ai_place (AI.round_5_cov_wave_2_backup_right);
		sleep_s (1);
	end
	SleepUntil([|ai_living_count( AI.round_5_cov_wave_2_backup_right) <= 3], 6);
	if ai_living_count( AI.round_5_cov_wave_2_bosses) >= 1 then
		ai_place (AI.round_5_cov_wave_2_backup_left);
	end
	SleepUntil([|ai_living_count( AI.round_5_cov_wave_2_backup_right) <= 3], 6);
	if ai_living_count( AI.round_5_cov_wave_2_bosses) >= 1 then
		ai_place (AI.round_5_cov_wave_2_backup_left);
	end
end

function f_wraith_boss_stay_in_vehicle()
	ai_place (AI.sq_pve_r3_wraith_boss_gunner);
	vehicle_set_unit_interaction(ai_vehicle_get(AI.sq_pve_r3_wraith_boss), "", false, false);
end


function r2_def_core()
	set_object_campaign_and_mp_team (OBJECTS.cr_r2_defend_fo_core, TEAM.player, MP_TEAM.mp_team_red, true);
	object_set_maximum_vitality (OBJECTS.cr_r2_defend_fo_core, 1250, 100);
	print (object_get_maximum_vitality (OBJECTS.cr_r2_defend_fo_core, true));
	
	object_immune_to_friendly_damage(OBJECTS.cr_r2_defend_fo_core, true );
	CreateThread (r2_core_target_delay);
end

function r2_core_target_delay()
	sleep_s (15);
	print ("now target the core");
	ai_object_set_targeting_bias(OBJECTS.cr_r2_defend_fo_core, 0.75);
end

function r2_unsee_core()
	print ("don't do anything");
end

function r4_def_core_01()
	set_object_campaign_and_mp_team (OBJECTS.cr_r4_defend_fo_core01, TEAM.player, MP_TEAM.mp_team_red, true);
	object_set_maximum_vitality (OBJECTS.cr_r4_defend_fo_core01, 1250, 100);
	print (object_get_maximum_vitality (OBJECTS.cr_r4_defend_fo_core01, true));
	ai_object_set_targeting_bias(OBJECTS.cr_r4_defend_fo_core01, 0.85);
	object_immune_to_friendly_damage(OBJECTS.cr_r4_defend_fo_core01, true );
	CreateThread (r4_stop_spinning_core_01);
end

function r4_stop_spinning_core_01()
	print ("core 1 alive, spinning");
	SleepUntil([|object_get_health (OBJECTS.cr_r4_defend_fo_core01) > 0], 3);
	sleep_s (.5);
	print ("core 1 alive, spinning");
	SleepUntil([|object_get_health (OBJECTS.cr_r4_defend_fo_core01) <= 0], 3);
	print ("core 1 dead, stop spinning");
	device_set_power (OBJECTS.r4_defend_fo_core01, 0);
end

function r4_def_core_02()
	set_object_campaign_and_mp_team (OBJECTS.cr_r4_defend_fo_core02, TEAM.player, MP_TEAM.mp_team_red, true);
	object_set_maximum_vitality (OBJECTS.cr_r4_defend_fo_core02, 1250, 100);
	print (object_get_maximum_vitality (OBJECTS.cr_r4_defend_fo_core02, true));
	ai_object_set_targeting_bias(OBJECTS.cr_r4_defend_fo_core02, 0.85);
	object_immune_to_friendly_damage(OBJECTS.cr_r4_defend_fo_core02, true );
	CreateThread (r4_stop_spinning_core_02);
end

function r4_stop_spinning_core_02()
	SleepUntil([|object_get_health (OBJECTS.cr_r4_defend_fo_core02) > 0], 3);
	sleep_s (.5);
	print ("core 2 alive, spinning");
	SleepUntil([|object_get_health (OBJECTS.cr_r4_defend_fo_core02) <= 0], 3);
	print ("core 2 dead, stop spinning");
	device_set_power (OBJECTS.r4_defend_fo_core02, 0);
end

function r5_def_core()
	--set_object_campaign_and_mp_team (OBJECTS.att_powercore01, TEAM.player, MP_TEAM.mp_team_red, true);
	--ai_object_set_targeting_bias(OBJECTS.att_powercore01, 0.9);
	object_create_anew  ("test_core");
	sleep_s (.1);
	object_override_physics_motion_type(OBJECTS.test_core, 1)
	set_object_campaign_and_mp_team (OBJECTS.test_core, TEAM.player, MP_TEAM.mp_team_red, true);
	ai_object_set_targeting_bias(OBJECTS.test_core, 0.9);
	object_cannot_die(OBJECTS.test_core, true);
	object_hide (OBJECTS.test_core, true);
end

function test_core()
	object_create_anew ("test_core");
	sleep_s (.1);
	object_override_physics_motion_type(OBJECTS.test_core, 1)
	set_object_campaign_and_mp_team (OBJECTS.test_core, TEAM.player, MP_TEAM.mp_team_red, true);
	ai_object_set_targeting_bias(OBJECTS.test_core, 0.9);
	object_cannot_die(OBJECTS.test_core, true);
	object_hide (OBJECTS.test_core, true);
end

--## CLIENT

function startupClient.ArcMixState():void
	sound_impulse_start(TAG('sound\031_states\031_st_osiris_global\031_st_osiris_global_levelloaded\031_st_osiris_global_levelloaded_wz_arc.sound'), nil, 1)
end