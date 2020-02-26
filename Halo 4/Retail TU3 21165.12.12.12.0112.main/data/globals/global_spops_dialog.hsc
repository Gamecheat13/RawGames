//=======================================================================================================================
//====================================   SPARTAN OPS GENERAL REUSABLE  VO   =============================================
//=======================================================================================================================

//==Ordnance

script static void vo_glo_ordnance_01()

	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Dalton, send Crimson supplies.
	dprint ("Palmer: Dalton, send Crimson supplies.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : You got it, Commander.
	dprint ("Dalton: You got it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_ridehome_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_ridehome_00200'));
	
	end_radio_transmission();
	
end

script static void vo_glo_ordnance_02()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Dalton, Crimson could use some new toys.
	dprint ("Palmer: Dalton, Crimson could use some new toys.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_2_00100'));
	
	end_radio_transmission();
	sleep(10);
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : I can arrange that, Commander.
	dprint ("Dalton: I can arrange that, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_02\e1m2_securearea_00400'));
	
	end_radio_transmission();
end

script static void vo_glo_ordnance_03()


	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><>  vo_glo_ordnance_03 does not exist, <><><><><><>><><><><><>");
	print("<><><><><><>< change to 01, 02, 04 or 05 please <><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");

	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Plamer : Dalton? What have you got for Crimson today?
	dprint ("Dalton? What have you got for Crimson today?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_03_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_03_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : There's ordnance inbound on their position now, Commander.
	dprint ("There's ordnance inbound on their position now, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_03_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_03_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_ordnance_04()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Send Crimson some resupply, Dalton.
	dprint ("Palmer: Send Crimson some resupply, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_4_00100'));
	
	end_radio_transmission();
	sleep(10);	
	start_radio_transmission( "dalton_transmission_name" );

	// Dalton : Already on its way, Commander. 
	dprint ("Dalton: Already on its way, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_03_mission_05\e3m5_bombingrun_00400'));
	
	end_radio_transmission();
	
end

script static void vo_glo_ordnance_05()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Dalton, Crimson could use some resupply.
	dprint ("Palmer: Dalton, Crimson could use some resupply.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_ordinance_5_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : You got it, Commander.
	dprint ("Dalton: You got it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_ridehome_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_01\e2m1_ridehome_00200'));
	
	end_radio_transmission();
	
end

script static void vo_glo_ordnance_06()
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><>  vo_glo_ordnance_06 does not exist, change line please <><><><><><>");
	print("<><><><><><>< change to 01, 02, 04 or 05 please <><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : I've got odrnance for Crimson, Commander.
	dprint ("I've got odrnance for Crimson, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_06_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_06_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Send it any time, Dalton.
	dprint ("Send it any time, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_06_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_06_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_ordnance_07()

	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><>  vo_glo_ordnance_07 does not exist, change line please <><><><><><>");
	print("<><><><><><>< change to 01, 02, 04 or 05 please <><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Commander, ordnance is ready whenever Crimson wants it.
	dprint ("Commander, ordnance is ready whenever Crimson wants it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_07_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_07_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Don't hold back, Dalton. Send away.
	dprint ("Don't hold back, Dalton. Send away.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_07_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_07_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_ordnance_08()
	
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><>  vo_glo_ordnance_08 does not exist, change line please <><><><><><>");
	print("<><><><><><>< change to 01, 02, 04 or 05 please <><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Commander Palmer, I've got I've got ordnance at the ready.
	dprint ("Commander Palmer, I've got I've got ordnance at the ready.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_08_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_08_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Fire when ready, Dalton.
	dprint ("Fire when ready, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_08_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_08_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_ordnance_09()

	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><>  vo_glo_ordnance_09 does not exist, change line please <><><><><><>");
	print("<><><><><><>< change to 01, 02, 04 or 05 please <><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Ordnance is prepped and ready, Commander.
	dprint ("Ordnance is prepped and ready, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_09_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_09_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Fire when ready, Dalton.
	dprint ("Fire when ready, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_09_00200', NONE, 1);			// not yet ready - tjp
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_09_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_ordnance_10()

	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><>  vo_glo_ordnance_10 does not exist, change line please <><><><><><>");
	print("<><><><><><>< change to 01, 02, 04 or 05 please <><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");
	print("<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>");

	start_radio_transmission( "dalton_transmission_name" );

	// Dalton : I've got ordnance whenever you want it, Commander.
	dprint ("I've got ordnance whenever you want it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_10_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Ship it, Dalton.
	dprint ("Ship it, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_10_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\ordnance_10_00200'));
	
	end_radio_transmission();
end

//==Mop up
script static void vo_glo_lasttargets_01()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Painting the last targets for you now.
	dprint ("Miller: Painting the last targets for you now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lasttargets_02()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Just a few stragglers, Crimson.
	dprint ("Miller: Just a few stragglers, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lasttargets_03()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson, got a few left.
	dprint ("Miller: Crimson, got a few left.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lasttargets_04()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Here's the last of them.
	dprint ("Miller: Here's the last of them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lasttargets_05()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller, light up the last few targets.
	dprint ("Palmer: Miller, light up the last few targets.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lasttargets_06()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Show us the bad guys, Miller.
	dprint ("Palmer: Show us the bad guys, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lasttargets_07()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller, light up the freaks, please.
	dprint ("Palmer: Miller, light up the freaks, please.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lasttargets_08()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller, light up the leftovers.
	dprint ("Palmer: Miller, light up the leftovers.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lasttargets_09()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Where's the cannon fodder, Miller?
	dprint ("Palmer: Where's the cannon fodder, Miller?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_9_00100'));
	
	end_radio_transmission();	
end

script static void vo_glo_lasttargets_10()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller, show Crimson their cleanup detail.
	dprint ("Palmer: Miller, show Crimson their cleanup detail.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_last_target_10_00100'));
	
	end_radio_transmission();
end

//==Drop Pod Incoming

script static void vo_glo_droppod_01()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Drop pod incoming!
	dprint ("Miller: Drop pod incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_droppod_02()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson, drop pods in the sky!
	dprint ("Miller: Crimson, drop pods in the sky!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_droppod_03()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Covenant drop pods inbound!
	dprint ("Miller: Covenant drop pods inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_droppod_04()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Heads up, drop pods incoming!
	dprint ("Miller: Heads up, drop pods incoming!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_4_00100'));
	
	end_radio_transmission();
end
	
script static void vo_glo_droppod_05()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Drop pods coming down near your position, Crimson!
	dprint ("Miller: Drop pods coming down near your position, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_droppod_06()
	// DALTON : Commander Palmer, there's drop pods inbound.
	dprint ("Commander Palmer, there's drop pods inbound.");
	// PALMER : Got it, Dalton. Thanks.
	dprint ("Got it, Dalton. Thanks.");
end

script static void vo_glo_droppod_07()
	// DALTON : Commander, you've got drop pods headed Crimson's way.
	dprint ("Commander, you've got drop pods headed Crimson's way.");
	// PALMER : Thanks Dalton. (to team) Eyes to the sky, Spartans.
	dprint ("Thanks Dalton. (to team) Eyes to the sky, Spartans.");
end

script static void vo_glo_droppod_08()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Looks like you've got drop pods headed your way.
	dprint ("Palmer: Looks like you've got drop pods headed your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_8_00100'));
	
	end_radio_transmission();
end
	
script static void vo_glo_droppod_09()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Get ready. Covenant drop pods inbound.
	dprint ("Palmer: Get ready. Covenant drop pods inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_9_00100'));
	
	end_radio_transmission();
end
		
script static void vo_glo_droppod_10()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Drop pods coming your way.
	dprint ("Palmer: Drop pods coming your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_10_0100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_drop_pod_10_0100'));
	
	end_radio_transmission();
end

//== Incoming
//SPOPS_global_incoming_1_00100

script static void vo_glo_incoming_01()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : More bad guys!
	dprint ("Miller: More bad guys!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_incoming_02()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Hostiles inbound, Crimson!
	dprint ("Miller: Hostiles inbound, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_incoming_03()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Don't relax yet. You've got more hostiles headed your way.
	dprint ("Miller: Don't relax yet. You've got more hostiles headed your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_3_00100'));
	
	end_radio_transmission();
end
	
script static void vo_glo_incoming_04()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watch out! Hostiles inbound!
	dprint ("Miller: Watch out! Hostiles inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_incoming_05()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Get ready, more bad guys headed your way.
	dprint ("Miller: Get ready, more bad guys headed your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_incoming_06()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Hostiles inbound, Crimson. Give them a proper welcome, yeah?
	dprint ("Palmer: Hostiles inbound, Crimson. Give them a proper welcome, yeah?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_incoming_07()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Look sharp. Cannon fodder headed your way.
	dprint ("Palmer: Look sharp. Cannon fodder headed your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_incoming_08()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : More target practice coming your way.
	dprint ("Palmer: More target practice coming your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_incoming_09()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Reload and ready up, Crimson. Target practice inbound.
	dprint ("Palmer: Reload and ready up, Crimson. Target practice inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_9_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_incoming_10()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : There you go, Crimson. Something to shoot! Enjoy.
	dprint ("Palmer: There you go, Crimson. Something to shoot! Enjoy.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_10_0100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_10_0100'));
	
	end_radio_transmission();
end

//==Phantom Incoming

script static void vo_glo_phantom_01()
	// DALTON : Miller, you've got a Phantom near your op.
	dprint ("Miller, you've got a Phantom near your op.");
	// MILLER : I see it. Thanks, Dalton. Crimson, heads up.
	dprint ("I see it. Thanks, Dalton. Crimson, heads up.");
end

script static void vo_glo_phantom_02()
	// DALTON : Commander Palmer, Phantom inbound on Crimson's position.
	dprint ("Commander Palmer, Phantom inbound on Crimson's position.");
	// PALMER : Understood, Dalton. We'll handle it.
	dprint ("Understood, Dalton. We'll handle it.");
end

script static void vo_glo_phantom_03()
	// DALTON :	Phantom inbound on Crimson's position, Commander Palmer.
	dprint ("Phantom inbound on Crimson's position, Commander Palmer.");
	// PALMER : I see it, Dalton. Thanks.
	dprint ("I see it, Dalton. Thanks.");
end

script static void vo_glo_phantom_04()

	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Crimson, Phantom inbound.
	dprint ("Palmer: Crimson, Phantom inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_4_00100'));
	
	end_radio_transmission();
end	

script static void vo_glo_phantom_05()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Phantom headed your way, Spartans.
	dprint ("Palmer: Phantom headed your way, Spartans.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_phantom_06()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Eyes up. You've got a Phantom coming your way.
	dprint ("Palmer: Eyes up. You've got a Phantom coming your way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_phantom_07()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Look out, there's a Phantom headed your way!
	dprint ("Miller: Look out, there's a Phantom headed your way!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_phantom_08()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Phantom!
	dprint ("Miller: Phantom!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_phantom_09()		
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Uh oh. Phantom inbound!
	dprint ("Miller: Uh oh. Phantom inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_9_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_phantom_10()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Oh boy... Crimson, Phantom inbound.
	dprint ("Miller: Oh boy... Crimson, Phantom inbound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_10_0100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_incoming_phant_10_0100'));
	
	end_radio_transmission();
end

//==Watch Out
script static void vo_glo_watchout_01()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Heads up!
	dprint ("Palmer: Heads up!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_02()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Look out!
	dprint ("Palmer: Look out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_03()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson! Look out!
	dprint ("Palmer: Crimson! Look out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_04()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Watch out!
	dprint ("Palmer: Watch out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_05()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson! Watch out!
	dprint ("Palmer: Crimson! Watch out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_06()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Oh no!
	dprint ("Miller: Oh no!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_07()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson! Look out!
	dprint ("Miller: Crimson! Look out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_08()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson! Watch out!
	dprint ("Miller: Crimson! Watch out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_09()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson! Oh no!
	dprint ("Miller: Crimson! Oh no!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out_9_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchout_10()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson!
	dprint ("Miller: Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out10_01000', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watch_out10_01000'));
	
	end_radio_transmission();
end

//==Watchers
script static void vo_glo_watchers_01()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watchers nearby.
	dprint ("Miller: Watchers nearby.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchers_02()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : You've got Watchers in the area, Crimson.
	dprint ("Miller: You've got Watchers in the area, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchers_03()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watchers!
	dprint ("Miller: Watchers!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_3_00100'));
	
	end_radio_transmission();
end
	
script static void vo_glo_watchers_04()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watchers nearby.
	dprint ("Miller: Watchers nearby.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchers_05()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Spartans, be aware that there are Watchers in the area.
	dprint ("Miller: Spartans, be aware that there are Watchers in the area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchers_06()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watch out for--um, the Watchers, actually.
	dprint ("Miller: Watch out for--um, the Watchers, actually.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchers_07()		
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Take out the Watchers, Crimson.
	dprint ("Palmer: Take out the Watchers, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchers_08()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Watchers are nothing but trouble. Put 'em down.
	dprint ("Palmer: Watchers are nothing but trouble. Put 'em down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchers_09()		
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : You've got Watchers.
	dprint ("Palmer: You've got Watchers.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_9_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_watchers_10()		
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson, do something about those Watchers.
	dprint ("Palmer: Crimson, do something about those Watchers.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_watchers_10_00100'));
	
	end_radio_transmission();
end

//==Crawlers
script static void vo_glo_crawlers_01()		
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crawlers!
	dprint ("Miller: Crawlers!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_02()		
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crawlers inbound!
	dprint ("Miller: Crawlers inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_03()		
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crawlers in your vicinity.
	dprint ("Miller: Crawlers in your vicinity.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_04()			
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Watch out for the Crawlers. They're everywhere.
	dprint ("Miller: Watch out for the Crawlers. They're everywhere.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_05()		
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : There's Crawlers all over the place!
	dprint ("Miller: There's Crawlers all over the place!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_06()			
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crawlers are nothing to be scared of. Deal with them.
	dprint ("Palmer: Crawlers are nothing to be scared of. Deal with them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_07()			
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crawlers make for good target practice.
	dprint ("Palmer: Crawlers make for good target practice.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_08()			
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crawlers? When are they going to give you something good to fight?
	dprint ("Palmer: Crawlers? When are they going to give you something good to fight?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_09()		
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crawlers? It's like the Prometheans aren't taking you seriously.
	dprint ("Palmer: Crawlers? It's like the Prometheans aren't taking you seriously.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_9_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_crawlers_10()			
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crawlers headed your way. You know what to do.
	dprint ("Palmer: Crawlers headed your way. You know what to do.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_crawlers_10_00100'));
	
	end_radio_transmission();
end

//==Knights
script static void vo_glo_knights_01()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Knights!
	dprint ("Miller: Knights!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_knights_02()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Oh, man! Knights!
	dprint ("Miller: Oh, man! Knights!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_2_00100'));
	
	end_radio_transmission();
end
	
script static void vo_glo_knights_03()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Look out! Knights!
	dprint ("Miller: Look out! Knights!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_knights_04()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Knights! Watch out!
	dprint ("Miller: Knights! Watch out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_knights_05()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Knights! Crimson! Be careful!
	dprint ("Miller: Knights! Crimson! Be careful!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_knights_06()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Knights -- stay sharp, Crimson.
	dprint ("Palmer: Knights -- stay sharp, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_knights_07()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Watch out for the Knights.
	dprint ("Palmer: Watch out for the Knights.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_knights_08()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Be careful with those Knights.
	dprint ("Palmer: Be careful with those Knights.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_knights_09()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Knights! Take them down.
	dprint ("Palmer: Knights! Take them down.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_9_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_knights_10()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Knights! Be careful.
	dprint ("Palmer: Knights! Be careful.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_knights_10_00100'));
	
	end_radio_transmission();
end

//==Heavy Forces
script static void vo_glo_heavyforces_01()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Crimson, there's heavy enemy movement nearby. Get ready.
	dprint ("Miller: Crimson, there's heavy enemy movement nearby. Get ready.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_heavyforces_02()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, there's heavy enemy movement near Crimson's position.
	dprint ("Miller: Commander, there's heavy enemy movement near Crimson's position.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_2_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	
	// Palmer : Get ready, Spartans.
	dprint ("Palmer: Get ready, Spartans.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_2_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_2_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_heavyforces_03()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Lots of activity nearby. Be ready for anything, Crimson.
	dprint ("Miller: Lots of activity nearby. Be ready for anything, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_heavyforces_04()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Lots of movement nearby, Commander.
	dprint ("Miller: Lots of movement nearby, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_4_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Be ready, Crimson.
	dprint ("Palmer: Be ready, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_4_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_4_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_heavyforces_05()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander --
	dprint ("Miller: Commander --");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_5_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I see it too. Crimson, heavy enemy movement, coming your way. Ready up.
	dprint ("Palmer: I see it too. Crimson, heavy enemy movement, coming your way. Ready up.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_5_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_heavy_forces_5_00200'));
	
	end_radio_transmission();
end

//==Snipers
script static void vo_glo_snipers_01()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Sniper!
	dprint ("Miller: Sniper!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_snipers_02()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Sniper fire!
	dprint ("Miller: Sniper fire!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_2_00100'));
	
	end_radio_transmission();
end
	
script static void vo_glo_snipers_03()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander! Snipers!
	dprint ("Miller: Commander! Snipers!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_3_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	

	// Palmer : I think Crimson has noticed, Miller.
	dprint ("Palmer: I think Crimson has noticed, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_3_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_3_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_snipers_04()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Sniper. Keep your heads down, Crimson.
	dprint ("Palmer: Sniper. Keep your heads down, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_snipers_05()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Sniper fire. Freaking campers--
	dprint ("Palmer: Sniper fire. Freaking campers--");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_snipers_5_00100'));
	
	end_radio_transmission();
end

//==Power Source Waypoint
script static void vo_glo_powersource_01()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, there's a power source nearby. Might want to have Crimson take a look.
	dprint ("Miller: Commander, there's a power source nearby. Might want to have Crimson take a look.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Give them a waypoint, Miller.
	dprint ("Palmer: Give them a waypoint, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_1_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_powersource_02()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : There's a weird power reading nearby...
	dprint ("Miller: There's a weird power reading nearby...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_2_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, go have a look.
	dprint ("Palmer: Crimson, go have a look.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_2_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_2_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_powersource_03()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, do you see this?
	dprint ("Miller: Commander, do you see this?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_3_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : That's weird. Crimson, go get eyes on this point.
	dprint ("Palmer: That's weird. Crimson, go get eyes on this point.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_3_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_3_00200'));
	
	end_radio_transmission();
end
	
script static void vo_glo_powersource_04()	
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : There's a power source over here. Likely Promethean.
	dprint ("Miller: There's a power source over here. Likely Promethean.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_4_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_4_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Give Crimson a waypoint so they can go have a look.
	dprint ("Palmer: Give Crimson a waypoint so they can go have a look.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_4_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_4_00300'));
	
	end_radio_transmission();
end

script static void vo_glo_powersource_05()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Power source nearby. Might be worth getting a look at it?
	dprint ("Miller: Power source nearby. Might be worth getting a look at it?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_5_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Agreed. Paint a waypoint.
	dprint ("Palmer: Agreed. Paint a waypoint.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_5_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_power_source_5_00200'));
	
	end_radio_transmission();
end

//==Clear the LZ
script static void vo_glo_lz_01()
	// DALTON : Commander, the LZ's too hot. Gotta clear some hostiles before my people can get in there.
	dprint ("Commander, the LZ's too hot. Gotta clear some hostiles before my people can get in there.");
	// PALMER : You heard the man, Crimson. Clear the LZ.
	dprint ("You heard the man, Crimson. Clear the LZ.");
end

script static void vo_glo_lz_02()	
	// DALTON : My pilots can't land in that mess, Commander.
	dprint ("My pilots can't land in that mess, Commander.");
	// PALMER : Understood, Dalton. New priority is to clear the LZ.
	dprint ("Understood, Dalton. New priority is to clear the LZ.");
end

script static void vo_glo_lz_03()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Where's that bird, Dalton?
	dprint ("Palmer: Where's that bird, Dalton?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_lz_hot_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_lz_hot_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_lz_04()
	// DALTON : Commander, my pilot needs space to land.
	dprint ("Commander, my pilot needs space to land.");
	// PALMER : Working on it, Dalton.
	dprint ("Working on it, Dalton.");
end

script static void vo_glo_lz_05()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Just a minute more, Dalton. Crimson's on the job.
	dprint ("Palmer: Just a minute more, Dalton. Crimson's on the job.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_lz_hot_5_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_lz_hot_5_00200'));
	
	end_radio_transmission();
end

//==Nice Work
script static void vo_glo_nicework_01()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Nice work.
	dprint ("Palmer: Nice work.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_02()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Nice work, Crimson.
	dprint ("Palmer: Nice work, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_03()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Great job, Crimson.
	dprint ("Palmer: Great job, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_04()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Excellent work.
	dprint ("Palmer: Excellent work.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_05()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Fantastic job.
	dprint ("Palmer: Fantastic job.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_5_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_06()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Well done.
	dprint ("Palmer: Well done.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_07()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Well played, Crimson.
	dprint ("Palmer: Well played, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_08()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Beautiful, Crimson.
	dprint ("Palmer: Beautiful, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_09()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Well done, Crimson.
	dprint ("Palmer: Well done, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_9_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_nicework_10()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Textbook example of kicking ass. Well done, Crimson.
	dprint ("Palmer: Textbook example of kicking ass. Well done, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_nicework_10_00100'));
	
	end_radio_transmission();
end

//==Remaining Cov
script static void vo_glo_remainingcov_01()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Just a few Covies left. I'll get markers on them.
	dprint ("Miller: Just a few Covies left. I'll get markers on them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_remainingcov_02()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Just a few Covenant remaining. Marking them for you.
	dprint ("Miller: Just a few Covenant remaining. Marking them for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_remainingcov_03()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Still have a few Covies to clear out, Crimson.
	dprint ("Miller: Still have a few Covies to clear out, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_remainingcov_04()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Still a few Covenant in your area, Crimson. Marking them for you now.
	dprint ("Miller: Still a few Covenant in your area, Crimson. Marking them for you now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_cov_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_remainingcov_05()
	// PALMER : Couple Covies still knocking about. Take 'em down.
	dprint ("Couple Covies still knocking about. Take 'em down.");
end

//==Remaining Prometheans
script static void vo_glo_remainingproms_01()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Still a few Prometheans to clear out. Setting markers now.
	dprint ("Miller: Still a few Prometheans to clear out. Setting markers now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_remainingproms_02()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Take care of those last few Prometheans, Crimson.
	dprint ("Miller: Take care of those last few Prometheans, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_remainingproms_03()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Handful of Prometheans left. Marking them for you.
	dprint ("Miller: Handful of Prometheans left. Marking them for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_remainingproms_04()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Marking the last few Prometheans for you now.
	dprint ("Miller: Marking the last few Prometheans for you now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_remainingproms_05()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : There's still some Prometheans left to clear out. Marking them now.
	dprint ("Miller: There's still some Prometheans left to clear out. Marking them now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_remaining_pro_5_00100'));
	
	end_radio_transmission();
end

//==Clear Area (similar to mop up)
script static void vo_glo_cleararea_01()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Area's not secure yet. Marking your last few targets.
	dprint ("Miller: Area's not secure yet. Marking your last few targets.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_cleararea_02()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Still some stragglers. Marking them for you.
	dprint ("Miller: Still some stragglers. Marking them for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_2_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_cleararea_03()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Need to finish securing the area. I'll mark the last few hostiles.
	dprint ("Miller: Need to finish securing the area. I'll mark the last few hostiles.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_cleararea_04()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : You're not alone down there, Crimson. Here's the last few bad guys.
	dprint ("Palmer: You're not alone down there, Crimson. Here's the last few bad guys.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_cleararea_05()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Almost clear, Crimson. Marking the final bad guys for you now.
	dprint ("Palmer: Almost clear, Crimson. Marking the final bad guys for you now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_clear_area_5_00100'));
	
	end_radio_transmission();
end	

//==Stalling (Infinity is working on something)
script static void vo_glo_stalling_01()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller! What's taking so long?
	dprint ("Palmer: Miller! What's taking so long?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_1_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Um... hang on. Almost got it.
	dprint ("Miller: Um... hang on. Almost got it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_1_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_1_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_02()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller? Status?
	dprint ("Palmer: Miller? Status?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Working on it, Commander.
	dprint ("Miller: Working on it, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_03()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : I need fast. Not perfect.
	dprint ("Palmer: I need fast. Not perfect.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_3_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : This is taking longer than I thought.
	dprint ("Miller: This is taking longer than I thought.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_3_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_3_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_04()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller!
	dprint ("Palmer: Miller!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_4_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : I'm trying! Hang on!
	dprint ("Miller: I'm trying! Hang on!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_4_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_4_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_05()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Just a moment, Crimson. Let me see what I can do.
	dprint ("Miller: Just a moment, Crimson. Let me see what I can do.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_5_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Whatever you come up with, think of it fast.
	dprint ("Palmer: Whatever you come up with, think of it fast.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_5_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_5_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_06()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : I've almost got it.
	dprint ("Miller: I've almost got it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_6_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Get it faster, Miller!
	dprint ("Palmer: Get it faster, Miller!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_6_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_6_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_07()	
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Miller?
	dprint ("Palmer: Miller?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_7_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Almost there...
	dprint ("Miller: Almost there...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_7_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_7_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_08()
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : How much longer?
	dprint ("Palmer: How much longer?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_8_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Just a second more...
	dprint ("Miller: Just a second more...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_8_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_8_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_09()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Almost got it.
	dprint ("Miller: Almost got it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_9_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Hang on just a little longer, Crimson
	dprint ("Palmer: Hang on just a little longer, Crimson");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_9_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_9_00200'));
	
	end_radio_transmission();
end

script static void vo_glo_stalling_10()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Ah! Here we go, Crimson-- No. Wait.That's not right.
	dprint ("Miller: Ah! Here we go, Crimson-- No. Wait.That's not right.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_10_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : What are you even doing?
	dprint ("Palmer: What are you even doing?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_10_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_10_00200'));
	
	end_radio_transmission();
end
	
//==Got it! There we go! Aha! Finally!
script static void vo_glo_gotit_01()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Got it!
	dprint ("Miller: Got it!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_1_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_1_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_gotit_02()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : There we go!
	dprint ("Miller: There we go!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_2_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_2_00100'));
	
	end_radio_transmission();
end
	
script static void vo_glo_gotit_03()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Ah! There it is!
	dprint ("Miller: Ah! There it is!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_3_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_3_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_gotit_04()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Finally!
	dprint ("Miller: Finally!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_4_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_4_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_gotit_05()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Ah-ha!
	dprint ("Miller: Ah-ha!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_5_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_5_00100'));
	
	end_radio_transmission();
end
	
script static void vo_glo_gotit_06()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : It worked!
	dprint ("Miller: It worked!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_6_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_6_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_gotit_07()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : That did it!
	dprint ("Miller: That did it!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_7_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_7_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_gotit_08()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : I figured it out!
	dprint ("Miller: I figured it out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_8_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_8_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_gotit_09()	
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Hey! I figured it out!
	dprint ("Miller: Hey! I figured it out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_9_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_9_00100'));
	
	end_radio_transmission();
end

script static void vo_glo_gotit_10()
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : That's it! I got it!
	dprint ("Miller: That's it! I got it!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_10_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_got_it_10_00100'));
	
	end_radio_transmission();
end

//=================================
// SAMPLE SCRIPTS FOR CALLING RANDOM VO CALLOUTS
//=================================


//script static void f_callouts
//	repeat
//		sleep_until (LevelEventStatus("more_enemies1"), 1);
//		print ("more enemies event");
//		
//		sleep_until (b_dialog_playing == false, 1);
//		b_dialog_playing = true;
//		
//		if editor_mode() then
//			cinematic_set_title (title_more_enemies);
//		end
//		begin_random_count (1)
//			vo_glo_incoming_01();
//			vo_glo_incoming_02();
//			vo_glo_incoming_03();
//			vo_glo_incoming_04();
//			vo_glo_incoming_05();
//			vo_glo_incoming_06();
//			vo_glo_incoming_07();
//			vo_glo_incoming_08();
//			vo_glo_incoming_09();
//			vo_glo_incoming_10();
//		
//		end
//		
//		b_dialog_playing = false;
//		
//	until (b_game_ended == true);
//end
//
//script static void f_phantom_callouts
//	repeat
//		sleep_until (LevelEventStatus("more_phantoms"), 1);
//		print ("more enemies event");
//		
//		ai_place (sq_e5_m4_phantom_3);
//		
//		sleep_until (b_dialog_playing == false, 1);
//		b_dialog_playing = true;
//		
//		if editor_mode() then
//			cinematic_set_title (title_more_enemies);
//		end
//		begin_random_count (1)
//			vo_glo_phantom_01();
//			vo_glo_phantom_02();
//			vo_glo_phantom_03();
//			vo_glo_phantom_04();
//			vo_glo_phantom_05();
//			vo_glo_phantom_06();
//			vo_glo_phantom_07();
//			vo_glo_phantom_08();
//			vo_glo_phantom_09();
//			vo_glo_phantom_10();
//		
//		end
//		
//		b_dialog_playing = false;
//		
//	until (b_game_ended == true);
//end
//
//script static void f_heavy_callouts
//	repeat
//		sleep_until (LevelEventStatus("more_heavy"), 1);
//		print ("more enemies event");
//		
//		//ai_place (sq_e5_m4_phantom_3);
//		
//		sleep_until (b_dialog_playing == false, 1);
//		b_dialog_playing = true;
//		
//		if editor_mode() then
//			cinematic_set_title (title_more_enemies);
//		end
//		begin_random_count (1)
//			vo_glo_heavyforces_01();
//			vo_glo_heavyforces_02();
//			vo_glo_heavyforces_03();
//			vo_glo_heavyforces_04();
//			vo_glo_heavyforces_05();
//
//		
//		end
//		
//		b_dialog_playing = false;
//		
//	until (b_game_ended == true);
//end

