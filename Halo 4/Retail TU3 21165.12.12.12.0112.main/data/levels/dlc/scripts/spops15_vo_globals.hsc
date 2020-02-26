// =============================================================================================================================
//============================================ E6M5 BREACH NARRATIVE SCRIPT ================================================
// =============================================================================================================================

// ============================================	GLOBALS	========================================================

global boolean global_narrative_is_on = FALSE;

// ============================================	PUP SCRIPT	========================================================



// ============================================	VO SCRIPT	========================================================

//===========DALTON===========================

/*script static void vo_glo15_dalton_confirm_01()
global_narrative_is_on = TRUE;

// Dalton : Can do.
dprint ("Dalton: Can do.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_confirm_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_confirm_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end*/

//==ORDNANCE ON ITS WAY SCRIPTS========================

script static void vo_glo15_dalton_ordnance_onway_01()
global_narrative_is_on = TRUE;

// Dalton : Ordinance inbound on Crimson's position now.
dprint ("Dalton: Ordinance inbound on Crimson's position now.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_onway_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_onway_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


/*script static void vo_glo15_dalton_ordnance_onway_02()
global_narrative_is_on = TRUE;

// Dalton : Headed their way now.
dprint ("Dalton: Headed their way now.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_onway_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_onway_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_dalton_ordnance_onway_03()
global_narrative_is_on = TRUE;

// Dalton : I've got ordinance for Crimson.
dprint ("Dalton: I've got ordinance for Crimson.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_onway_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_onway_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end*/

//==ORDNANCE READY SCRIPTS========================

/*script static void vo_glo15_dalton_ordnance_ready_01()
global_narrative_is_on = TRUE;

// Dalton : Ordinance is ready whenever Crimson wants it.
dprint ("Dalton: Ordinance is ready whenever Crimson wants it.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_ready_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_ready_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_dalton_ordnance_ready_02()
global_narrative_is_on = TRUE;

// Dalton : I've got ordinance at the ready.
dprint ("Dalton: I've got ordinance at the ready.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_ready_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_ready_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_dalton_ordnance_ready_03()
global_narrative_is_on = TRUE;

// Dalton : Ordinance prepped and ready.
dprint ("Dalton: Ordinance prepped and ready.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_ready_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_ordnance_ready_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/
//==DROP POD INCOMING SCRIPTS========================

script static void vo_glo15_dalton_droppods_01()
global_narrative_is_on = TRUE;

// Dalton : This is Dalton, drop pods inbound.
dprint ("Dalton: This is Dalton, drop pods inbound.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_droppods_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_droppods_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end



script static void vo_glo15_dalton_droppods_02()
global_narrative_is_on = TRUE;

// Dalton : You've got drop pods headed Crimson's way.
dprint ("Dalton: You've got drop pods headed Crimson's way.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_droppods_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_droppods_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

//==PHANTOM INCOMING SCRIPTS========================

script static void vo_glo15_dalton_phantom_01()
global_narrative_is_on = TRUE;

// Dalton : Dalton to Crimson. Phantom coming your way.
dprint ("Dalton: Dalton to Crimson. Phantom coming your way.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_phantom_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_phantom_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_dalton_phantom_02()
global_narrative_is_on = TRUE;

// Dalton : Phantom inbound on Crimson's position.
dprint ("Dalton: Phantom inbound on Crimson's position.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_phantom_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_phantom_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==MULTIPLE INCOMING SCRIPTS========================

/*script static void vo_glo15_dalton_multiple_incoming_01()
global_narrative_is_on = TRUE;

// Dalton : Multiple elements inbound.
dprint ("Dalton: Multiple elements inbound.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_multiple_incoming_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_multiple_incoming_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end*/


//==CLEAR LZ SCRIPTS========================


/*script static void vo_glo15_dalton_clear_lz_01()
global_narrative_is_on = TRUE;

// Dalton : Our bird's going to need some space to land.
dprint ("Dalton: Our bird's going to need some space to land.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_clear_lz_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_clear_lz_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end



script static void vo_glo15_dalton_clear_lz_02()
global_narrative_is_on = TRUE;

// Dalton : Pelican's on station but that LZ's too hot.
dprint ("Dalton: Pelican's on station but that LZ's too hot.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_clear_lz_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_clear_lz_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_dalton_clear_lz_03()
global_narrative_is_on = TRUE;

// Dalton : Clear the area.
dprint ("Dalton: Clear the area.");
start_radio_transmission("dalton_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_clear_lz_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_dalton_clear_lz_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

//===========PALMER===========================

//==GOOD WORK SCRIPTS========================

script static void vo_glo15_palmer_attaboy_01()
global_narrative_is_on = TRUE;

// Palmer : Good work, Crimson.
dprint ("Palmer: Good work, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_attaboy_02()
global_narrative_is_on = TRUE;

// Palmer : Nice work, Crimson.
dprint ("Palmer: Nice work, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
/*

script static void vo_glo15_palmer_attaboy_03()
global_narrative_is_on = TRUE;

// Palmer : Good job.
dprint ("Palmer: Good job.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/


script static void vo_glo15_palmer_attaboy_04()
global_narrative_is_on = TRUE;

// Palmer : Nicely done.
dprint ("Palmer: Nicely done.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*

script static void vo_glo15_palmer_attaboy_05()
global_narrative_is_on = TRUE;

// Palmer : Nice shooting, Crimson.
dprint ("Palmer: Nice shooting, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

script static void vo_glo15_palmer_attaboy_06()
global_narrative_is_on = TRUE;

// Palmer : That's what I like to see.
dprint ("Palmer: That's what I like to see.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_06'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_attaboy_07()
global_narrative_is_on = TRUE;

// Palmer : Excellent work.
dprint ("Palmer: Excellent work.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_07'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_attaboy_08()
global_narrative_is_on = TRUE;

// Palmer : Impressive, Crimson.
dprint ("Palmer: Impressive, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_attaboy_08'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==ALL CLEAR SCRIPTS========================

/*script static void vo_glo15_palmer_all_clear_01()
global_narrative_is_on = TRUE;

// Palmer : All clear.
dprint ("Palmer: All clear.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_all_clear_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_all_clear_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/

script static void vo_glo15_palmer_all_clear_02()
global_narrative_is_on = TRUE;

// Palmer : That's all of them.
dprint ("Palmer: That's all of them.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_all_clear_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_all_clear_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_palmer_all_clear_03()
global_narrative_is_on = TRUE;

// Palmer : You're clear, Crimson.
dprint ("Palmer: You're clear, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_all_clear_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_all_clear_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

/*script static void vo_glo15_palmer_go_red_01()
global_narrative_is_on = TRUE;

// Palmer : Go red, Spartans.
dprint ("Palmer: Go red, Spartans.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_go_red_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_go_red_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end*/


//== PALMER CONTACTS SCRIPTS========================
/*
script static void vo_glo15_palmer_contacts_01()
global_narrative_is_on = TRUE;

// Palmer : Multiple contacts.
dprint ("Palmer: Multiple contacts.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_contacts_02()
global_narrative_is_on = TRUE;

// Palmer : Contacts.
dprint ("Palmer: Contacts.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_contacts_03()
global_narrative_is_on = TRUE;

// Palmer : Hostiles.
dprint ("Palmer: Hostiles.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/
script static void vo_glo15_palmer_contacts_04()
global_narrative_is_on = TRUE;

// Palmer : Here they come.
dprint ("Palmer: Here they come.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*

script static void vo_glo15_palmer_contacts_05()
global_narrative_is_on = TRUE;

// Palmer : Covenant inbound!
dprint ("Palmer: Covenant inbound!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/

script static void vo_glo15_palmer_contacts_06()
global_narrative_is_on = TRUE;

// Palmer : Heads up!
dprint ("Palmer: Heads up!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_06'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_glo15_palmer_contacts_07()
global_narrative_is_on = TRUE;

// Palmer : Inbound!
dprint ("Palmer: Inbound!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_07'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*

script static void vo_glo15_palmer_contacts_08()
global_narrative_is_on = TRUE;

// Palmer : Heading your way!
dprint ("Palmer: Heading your way!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_08'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_contacts_09()
global_narrative_is_on = TRUE;

// Palmer : Eyes up!
dprint ("Palmer: Eyes up!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_09', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_contacts_09'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

//==PHANTOM SHOOT SCRIPTS========================

/*
script static void vo_glo15_palmer_shoot_01()
global_narrative_is_on = TRUE;

// Palmer : Suppressing fire!
dprint ("Palmer: Suppressing fire!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_shoot_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_shoot_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

script static void vo_glo15_palmer_shoot_02()
global_narrative_is_on = TRUE;

// Palmer : Weapons hot.
dprint ("Palmer: Weapons hot.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_shoot_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_shoot_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_shoot_03()
global_narrative_is_on = TRUE;

// Palmer : Light 'em up.
dprint ("Palmer: Light 'em up.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_shoot_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_shoot_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//== KEEP IT UP SCRIPTS========================

script static void vo_glo15_palmer_keepitup_01()
global_narrative_is_on = TRUE;

// Palmer : Roll on, Crimson.
dprint ("Palmer: Roll on, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_keepitup_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_keepitup_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_keepitup_02()
global_narrative_is_on = TRUE;

// Palmer : Keep it up.
dprint ("Palmer: Keep it up.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_keepitup_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_keepitup_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==JUST A FEW MORE SCRIPTS========================

script static void vo_glo15_palmer_fewmore_01()
global_narrative_is_on = TRUE;

// Palmer : You've still got some stragglers out there.
dprint ("Palmer: You've still got some stragglers out there.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end



script static void vo_glo15_palmer_fewmore_02()
global_narrative_is_on = TRUE;

// Palmer : Clean 'em up.
dprint ("Palmer: Clean 'em up.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end



script static void vo_glo15_palmer_fewmore_03()
global_narrative_is_on = TRUE;

// Palmer : Few more to go.
dprint ("Palmer: Few more to go.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end



script static void vo_glo15_palmer_fewmore_04()
global_narrative_is_on = TRUE;

// Palmer : Neutralize all targets.
dprint ("Palmer: Neutralize all targets.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


/*script static void vo_glo15_palmer_fewmore_05()
global_narrative_is_on = TRUE;

// Palmer : That's not quite all of them.
dprint ("Palmer: That's not quite all of them.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/



script static void vo_glo15_palmer_fewmore_06()
global_narrative_is_on = TRUE;

// Palmer : Take them out.
dprint ("Palmer: Take them out.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_06'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_fewmore_07()
global_narrative_is_on = TRUE;

// Palmer : Mop up the last of them.
dprint ("Palmer: Mop up the last of them.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_07'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_fewmore_08()
global_narrative_is_on = TRUE;

// Palmer : I'm still seeing targets down there.
dprint ("Palmer: I'm still seeing targets down there.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_08'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_fewmore_09()
global_narrative_is_on = TRUE;

// Palmer : Check your corners, folks.
dprint ("Palmer: Check your corners, folks.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_09', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_few_more_09'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==ONE MORE ENEMY LEFT SCRIPTS========================

/*script static void vo_glo15_palmer_one_more_01()
global_narrative_is_on = TRUE;

// Palmer : One left.
dprint ("Palmer: One left.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_one_more_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_one_more_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_one_more_02()
global_narrative_is_on = TRUE;

// Palmer : One to go.
dprint ("Palmer: One to go.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_one_more_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_one_more_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_one_more_03()
global_narrative_is_on = TRUE;

// Palmer : Only one more to go.
dprint ("Palmer: Only one more to go.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_one_more_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_one_more_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/


script static void vo_glo15_palmer_one_more_04()
global_narrative_is_on = TRUE;

// Palmer : Get that last one, Crimson.
dprint ("Palmer: Get that last one, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_one_more_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_one_more_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==ALMOST THERE SCRIPTS========================

/*script static void vo_glo15_palmer_not_done_01()
global_narrative_is_on = TRUE;

// Palmer : Not done yet, Crimson.
dprint ("Palmer: Not done yet, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_not_done_02()
global_narrative_is_on = TRUE;

// Palmer : Almost there.
dprint ("Palmer: Almost there.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_not_done_03()
global_narrative_is_on = TRUE;

// Palmer : Let's wrap it up, people.
dprint ("Palmer: Let's wrap it up, people.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_not_done_04()
global_narrative_is_on = TRUE;

// Palmer : Almost done.
dprint ("Palmer: Almost done.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

script static void vo_glo15_palmer_not_done_05()
global_narrative_is_on = TRUE;

// Palmer : Let's go, Crimson.
dprint ("Palmer: Let's go, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_not_done_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==PALMER MOVE SCRIPTS========================

/*script static void vo_glo15_palmer_move_01()
global_narrative_is_on = TRUE;

// Palmer : Pick it up, Crimson.
dprint ("Palmer: Pick it up, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_move_02()
global_narrative_is_on = TRUE;

// Palmer : Just a little further.
dprint ("Palmer: Just a little further.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_move_03()
global_narrative_is_on = TRUE;

// Palmer : Keep moving, Spartans.
dprint ("Palmer: Keep moving, Spartans.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


*/
script static void vo_glo15_palmer_move_04()
global_narrative_is_on = TRUE;

// Palmer : Let's move.
dprint ("Palmer: Let's move.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_glo15_palmer_move_05()
global_narrative_is_on = TRUE;

// Palmer : Get moving.
dprint ("Palmer: Get moving.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_move_06()
global_narrative_is_on = TRUE;

// Palmer : Get a move on.
dprint ("Palmer: Get a move on.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_06'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_move_07()
global_narrative_is_on = TRUE;

// Palmer : Crimson, what's the hold up?
dprint ("Palmer: Crimson, what's the hold up?");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_07'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_move_08()
global_narrative_is_on = TRUE;

// Palmer : We're on a clock here, folks.
dprint ("Palmer: We're on a clock here, folks.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_08'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
/*

script static void vo_glo15_palmer_move_09()
global_narrative_is_on = TRUE;

// Palmer : Move!
dprint ("Palmer: Move!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_09', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_move_09'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==PALMER HOLD ON SCRIPTS========================

script static void vo_glo15_palmer_hold_01()
global_narrative_is_on = TRUE;

// Palmer : Hold firm, Crimson.
dprint ("Palmer: Hold firm, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_hold_02()
global_narrative_is_on = TRUE;

// Palmer : Hold up.
dprint ("Palmer: Hold up.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_hold_03()
global_narrative_is_on = TRUE;

// Palmer : Hold on.
dprint ("Palmer: Hold on.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

script static void vo_glo15_palmer_hold_04()
global_narrative_is_on = TRUE;

// Palmer : Careful, Crimson.
dprint ("Palmer: Careful, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hold_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==PHANTOM INCOMING SCRIPTS========================

script static void vo_glo15_palmer_phantom_01()
global_narrative_is_on = TRUE;

// Palmer : Phantom on approach.
dprint ("Palmer: Phantom on approach.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_phantom_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_phantom_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

//==SCOUTS SCRIPTS========================

/*script static void vo_glo15_palmer_scouts_01()
global_narrative_is_on = TRUE;

// Palmer : Covenant scouts!
dprint ("Palmer: Covenant scouts!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_scouts_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_scouts_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

//==REINFORCEMENTS SCRIPTS========================

*/
script static void vo_glo15_palmer_reinforcements_01()
global_narrative_is_on = TRUE;

// Palmer : Reinforcements!
dprint ("Palmer: Reinforcements!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_reinforcements_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_reinforcements_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_palmer_reinforcements_02()
global_narrative_is_on = TRUE;

// Palmer : They're moving to fortify!
dprint ("Palmer: They're moving to fortify!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_reinforcements_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_reinforcements_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/


script static void vo_glo15_palmer_reinforcements_03()
global_narrative_is_on = TRUE;

// Palmer : Additional targets inbound!
dprint ("Palmer: Additional targets inbound!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_reinforcements_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_reinforcements_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==WAYPOINT SCRIPTS========================

script static void vo_glo15_palmer_waypoint_01()
global_narrative_is_on = TRUE;

// Palmer : Setting a waypoint.
dprint ("Palmer: Setting a waypoint.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_waypoint_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_waypoint_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
/*

script static void vo_glo15_palmer_waypoint_02()
global_narrative_is_on = TRUE;

// Palmer : Marking your target now.
dprint ("Palmer: Marking your target now.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_waypoint_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_waypoint_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==ENEMIES===========================

script static void vo_glo15_palmer_turret_01()
global_narrative_is_on = TRUE;

// Palmer : Turrets!
dprint ("Palmer: Turrets!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_turrets_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_turrets_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_covenant_01()
global_narrative_is_on = TRUE;

// Palmer : Covenant!
dprint ("Palmer: Covenant!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_covenant_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_covenant_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_covenant_02()
global_narrative_is_on = TRUE;

// Palmer : More Covenant!
dprint ("Palmer: More Covenant!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_covenant_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_covenant_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_grunts_01()
global_narrative_is_on = TRUE;

// Palmer : Grunts!
dprint ("Palmer: Grunts!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_grunts_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_grunts_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_grunts_02()
global_narrative_is_on = TRUE;

// Palmer : More grunts!
dprint ("Palmer: More grunts!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_grunts_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_grunts_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_elites_01()
global_narrative_is_on = TRUE;

// Palmer : Elites!
dprint ("Palmer: Elites!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_elites_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_elites_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_elites_02()
global_narrative_is_on = TRUE;

// Palmer : More elites!
dprint ("Palmer: More elites!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_elites_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_elites_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

script static void vo_glo15_palmer_hunters_01()
global_narrative_is_on = TRUE;

// Palmer : Hunters!
dprint ("Palmer: Hunters!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hunters_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_hunters_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
/*

script static void vo_glo15_palmer_jackals_01()
global_narrative_is_on = TRUE;

// Palmer : Jackals!
dprint ("Palmer: Jackals!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_jackals_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_jackals_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_jackals_02()
global_narrative_is_on = TRUE;

// Palmer : More jackals!
dprint ("Palmer: More jackals!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_jackals_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_jackals_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_prometheans_01()
global_narrative_is_on = TRUE;

// Palmer : Prometheans!
dprint ("Palmer: Prometheans!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_prometheans_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_prometheans_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_prometheans_02()
global_narrative_is_on = TRUE;

// Palmer : More Prometheans!
dprint ("Palmer: More Prometheans!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_prometheans_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_prometheans_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_knights_01()
global_narrative_is_on = TRUE;

// Palmer : Knights!
dprint ("Palmer: Knights!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_knights_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_knights_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_knights_02()
global_narrative_is_on = TRUE;

// Palmer : More Knights!
dprint ("Palmer: More Knights!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_knights_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_knights_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_watchers_01()
global_narrative_is_on = TRUE;

// Palmer : Watchers!
dprint ("Palmer: Watchers!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_watchers_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_watchers_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_watchers_02()
global_narrative_is_on = TRUE;

// Palmer : More Watchers!
dprint ("Palmer: More Watchers!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_watchers_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_watchers_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_crawlers_01()
global_narrative_is_on = TRUE;

// Palmer : Crawlers!
dprint ("Palmer: Crawlers!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_crawlers_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_crawlers_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_crawlers_02()
global_narrative_is_on = TRUE;

// Palmer : More Crawlers!
dprint ("Palmer: More Crawlers!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_crawlers_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_crawlers_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_banshees_01()
global_narrative_is_on = TRUE;

// Palmer : Banshees!
dprint ("Palmer: Banshees!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_banshees_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_banshees_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/


script static void vo_glo15_palmer_ghosts_01()
global_narrative_is_on = TRUE;

// Palmer : Ghosts!
dprint ("Palmer: Ghosts!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_ghosts_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_ghosts_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_wraiths_01()
global_narrative_is_on = TRUE;

// Palmer : Wraith!
dprint ("Palmer: Wraith!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_wraith_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_wraith_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_cover_01()
global_narrative_is_on = TRUE;

// Palmer : Find some cover!
dprint ("Palmer: Find some cover!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_cover_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_cover_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


/*script static void vo_glo15_palmer_holdoff_01()
global_narrative_is_on = TRUE;

// Palmer : Hold them off!
dprint ("Palmer: Hold them off!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_holdoff_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_holdoff_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_almost_01()
global_narrative_is_on = TRUE;

// Palmer : Almost there.
dprint ("Palmer: Almost there.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_almost_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_almost_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/

script static void vo_glo15_palmer_walls_01()
global_narrative_is_on = TRUE;

// Palmer : On the walls!
dprint ("Palmer: On the walls!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_walls_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_walls_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_palmer_walls_02()
global_narrative_is_on = TRUE;

// Palmer : Coming down the walls!
dprint ("Palmer: Coming down the walls!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_walls_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_walls_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_done_01()
global_narrative_is_on = TRUE;

// Palmer : There.
dprint ("Palmer: There.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_done_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_done_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_done_02()
global_narrative_is_on = TRUE;

// Palmer : Done.
dprint ("Palmer: Done.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_done_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_done_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_done_03()
global_narrative_is_on = TRUE;

// Palmer : That should do it.
dprint ("Palmer: That should do it.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_done_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_done_03'));

end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_snipers_01()
global_narrative_is_on = TRUE;

// Palmer : Snipers!
dprint ("Palmer: Snipers!");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_snipers_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_snipers_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_heavy_01()
global_narrative_is_on = TRUE;

// Palmer : They're wheeling in the big guns, Crimson.
dprint ("Palmer: They're wheeling in the big guns, Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_heavy_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_heavy_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

//==MISC===========================

script static void vo_glo15_palmer_roger_01()
global_narrative_is_on = TRUE;

// Palmer : Roger that.
dprint ("Palmer: Roger that.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


/*script static void vo_glo15_palmer_roger_02()
global_narrative_is_on = TRUE;

// Palmer : Acknowledged.
dprint ("Palmer: Acknowledged.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_roger_03()
global_narrative_is_on = TRUE;

// Palmer : Affirmative.
dprint ("Palmer: Affirmative.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roger_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_crimson_01()
global_narrative_is_on = TRUE;

// Palmer : Crimson.
dprint ("Palmer: Crimson.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_crimson_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_crimson_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_palmer_miller_01()
global_narrative_is_on = TRUE;

// Palmer : Miller.
dprint ("Palmer: Miller.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_miller_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_miller_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

script static void vo_glo15_palmer_dalton_01()
global_narrative_is_on = TRUE;

// Palmer : Dalton.
dprint ("Palmer: Dalton.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_dalton_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_dalton_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


/*script static void vo_glo15_palmer_roland_01()
global_narrative_is_on = TRUE;

// Palmer : Roland.
dprint ("Palmer: Roland.");
start_radio_transmission("palmer_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roland_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_palmer_roland_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end*/


//===========MILLER===========================

//==GOOD WORK===========================

script static void vo_glo15_miller_attaboy_01()
global_narrative_is_on = TRUE;

// Miller : Good work, Crimson.
dprint ("Miller: Good work, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_attaboy_02()
global_narrative_is_on = TRUE;

// Miller : Nice work, Crimson.
dprint ("Miller: Nice work, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_attaboy_03()
global_narrative_is_on = TRUE;

// Miller : Good job.
dprint ("Miller: Good job.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_attaboy_04()
global_narrative_is_on = TRUE;

// Miller : Nicely done.
dprint ("Miller: Nicely done.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_attaboy_05()
global_narrative_is_on = TRUE;

// Miller : Nice shooting, Crimson.
dprint ("Miller: Nice shooting, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_attaboy_06()
global_narrative_is_on = TRUE;

// Miller : That's what I like to see.
dprint ("Miller: That's what I like to see.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_06'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_attaboy_07()
global_narrative_is_on = TRUE;

// Miller : Excellent work.
dprint ("Miller: Excellent work.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_07'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_attaboy_08()
global_narrative_is_on = TRUE;

// Miller : Impressive, Crimson.
dprint ("Miller: Impressive, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_attaboy_08'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

//==ALL CLEAR===========================

script static void vo_glo15_miller_allclear_01()
global_narrative_is_on = TRUE;

// Miller : All clear.
dprint ("Miller: All clear.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_all_clear_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_all_clear_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_allclear_02()
global_narrative_is_on = TRUE;

// Miller : That's all of them.
dprint ("Miller: That's all of them.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_all_clear_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_all_clear_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_allclear_03()
global_narrative_is_on = TRUE;

// Miller : You're clear, Crimson.
dprint ("Miller: You're clear, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_all_clear_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_all_clear_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_go_red_01()
global_narrative_is_on = TRUE;

// Miller : Go red, Spartans.
dprint ("Miller: Go red, Spartans.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_go_red_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_go_red_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

//==MULTIPLE CONTACTS===========================
*/

script static void vo_glo15_miller_contacts_01()
global_narrative_is_on = TRUE;

// Miller : Multiple contacts.
dprint ("Miller: Multiple contacts.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_contacts_02()
global_narrative_is_on = TRUE;

// Miller : Contacts.
dprint ("Miller: Contacts.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_contacts_03()
global_narrative_is_on = TRUE;

// Miller : Hostiles.
dprint ("Miller: Hostiles.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/



script static void vo_glo15_miller_contacts_04()
global_narrative_is_on = TRUE;

// Miller : Here they come.
dprint ("Miller: Here they come.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_contacts_05()
global_narrative_is_on = TRUE;

// Miller : Covenant inbound!
dprint ("Miller: Covenant inbound!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/
script static void vo_glo15_miller_contacts_06()
global_narrative_is_on = TRUE;



// Miller : Heads up!
dprint ("Miller: Heads up!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_06'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_contacts_07()
global_narrative_is_on = TRUE;

// Miller : Inbound!
dprint ("Miller: Inbound!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_07'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_contacts_08()
global_narrative_is_on = TRUE;

// Miller : Heading your way!
dprint ("Miller: Heading your way!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_08'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
/*

script static void vo_glo15_miller_contacts_09()
global_narrative_is_on = TRUE;

// Miller : Eyes up!
dprint ("Miller: Eyes up!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_09', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_contacts_09'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

//==SHOOT!===========================

script static void vo_glo15_miller_shoot_01()
global_narrative_is_on = TRUE;

// Miller : Suppressing fire!
dprint ("Miller: Suppressing fire!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_shoot_02()
global_narrative_is_on = TRUE;

// Miller : Weapons hot.
dprint ("Miller: Weapons hot.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_shoot_03()
global_narrative_is_on = TRUE;

// Miller : Light 'em up.
dprint ("Miller: Light 'em up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_shoot_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==KEEP IT UP===========================

*/
script static void vo_glo15_miller_keepitup_01()
global_narrative_is_on = TRUE;



// Miller : Roll on, Crimson.
dprint ("Miller: Roll on, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_keepitup_02()
global_narrative_is_on = TRUE;

// Miller : Keep it up.
dprint ("Miller: Keep it up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_keepitup_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==FEW MORE===========================

*/

script static void vo_glo15_miller_few_more_01()
global_narrative_is_on = TRUE;

// Miller : You've still got some stragglers out there.
dprint ("Miller: You've still got some stragglers out there.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end



script static void vo_glo15_miller_few_more_02()
global_narrative_is_on = TRUE;

// Miller : Clean 'em up.
dprint ("Miller: Clean 'em up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_few_more_03()
global_narrative_is_on = TRUE;

// Miller : Few more to go.
dprint ("Miller: Few more to go.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_few_more_04()
global_narrative_is_on = TRUE;

// Miller : Neutralize all targets.
dprint ("Miller: Neutralize all targets.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end



script static void vo_glo15_miller_few_more_05()
global_narrative_is_on = TRUE;

// Miller : That's not quite all of them.
dprint ("Miller: That's not quite all of them.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

script static void vo_glo15_miller_few_more_06()
global_narrative_is_on = TRUE;

// Miller : Take them out.
dprint ("Miller: Take them out.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_06'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end



script static void vo_glo15_miller_few_more_07()
global_narrative_is_on = TRUE;

// Miller : Mop up the last of them.
dprint ("Miller: Mop up the last of them.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_07'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_few_more_08()
global_narrative_is_on = TRUE;

// Miller : I'm still seeing targets down there.
dprint ("Miller: I'm still seeing targets down there.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_08'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_few_more_09()
global_narrative_is_on = TRUE;

// Miller : Check your corners, folks.
dprint ("Miller: Check your corners, folks.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_09', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_few_more_09'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
/*

//==ONE MORE===========================

script static void vo_glo15_miller_one_more_01()
global_narrative_is_on = TRUE;

// Miller : One left.
dprint ("Miller: One left.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/

script static void vo_glo15_miller_one_more_02()
global_narrative_is_on = TRUE;

// Miller : One to go.
dprint ("Miller: One to go.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_one_more_03()
global_narrative_is_on = TRUE;

// Miller : Only one more to go.
dprint ("Miller: Only one more to go.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/

script static void vo_glo15_miller_one_more_04()
global_narrative_is_on = TRUE;

// Miller : Get that last one, Crimson.
dprint ("Miller: Get that last one, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_one_more_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
//==NOT DONE===========================

script static void vo_glo15_miller_not_done_01()
global_narrative_is_on = TRUE;

// Miller : Not done yet, Crimson.
dprint ("Miller: Not done yet, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_not_done_02()
global_narrative_is_on = TRUE;

// Miller : Almost there.
dprint ("Miller: Almost there.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_not_done_03()
global_narrative_is_on = TRUE;

// Miller : Let's wrap it up, people.
dprint ("Miller: Let's wrap it up, people.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_not_done_04()
global_narrative_is_on = TRUE;

// Miller : Almost done.
dprint ("Miller: Almost done.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/

script static void vo_glo15_miller_not_done_05()
global_narrative_is_on = TRUE;

// Miller : Let's go, Crimson.
dprint ("Miller: Let's go, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_not_done_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==MOVE===========================

script static void vo_glo15_miller_move_01()
global_narrative_is_on = TRUE;

// Miller : Pick it up, Crimson.
dprint ("Miller: Pick it up, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_move_02()
global_narrative_is_on = TRUE;

// Miller : Just a little further.
dprint ("Miller: Just a little further.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end





script static void vo_glo15_miller_move_03()
global_narrative_is_on = TRUE;

// Miller : Keep moving, Spartans.
dprint ("Miller: Keep moving, Spartans.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_move_04()
global_narrative_is_on = TRUE;

// Miller : Let's move.
dprint ("Miller: Let's move.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_move_05()
global_narrative_is_on = TRUE;

// Miller : Get moving.
dprint ("Miller: Get moving.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_05', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_05'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_move_06()
global_narrative_is_on = TRUE;

// Miller : Get a move on.
dprint ("Miller: Get a move on.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_06', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_06'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_move_07()
global_narrative_is_on = TRUE;

// Miller : Crimson, what's the hold up?
dprint ("Miller: Crimson, what's the hold up?");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_07', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_07'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_move_08()
global_narrative_is_on = TRUE;

// Miller : We're on a clock here, folks.
dprint ("Miller: We're on a clock here, folks.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_08', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_08'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_move_09()
global_narrative_is_on = TRUE;

// Miller : Move!
dprint ("Miller: Move!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_09', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_move_09'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_hold_01()
global_narrative_is_on = TRUE;

// Miller : Hold firm, Crimson.
dprint ("Miller: Hold firm, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hold_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hold_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_hold_02()
global_narrative_is_on = TRUE;

// Miller : Hold up.
dprint ("Miller: Hold up.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hold_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hold_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_hold_03()
global_narrative_is_on = TRUE;

// Miller : Hold on.
dprint ("Miller: Hold on.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hold_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hold_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_hold_04()
global_narrative_is_on = TRUE;

// Miller : Careful, Crimson.
dprint ("Miller: Careful, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hold_04', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hold_04'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end*/


script static void vo_glo15_miller_phantom_01()
global_narrative_is_on = TRUE;

// Miller : Phantom on approach.
dprint ("Miller: Phantom on approach.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_phantom_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_phantom_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_scouts_01()
global_narrative_is_on = TRUE;

// Miller : Covenant scouts!
dprint ("Miller: Covenant scouts!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_scouts_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_scouts_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end*/

//==REINFORCEMENTS===========================

script static void vo_glo15_miller_reinforcements_01()
global_narrative_is_on = TRUE;

// Miller : Reinforcements!
dprint ("Miller: Reinforcements!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_reinforcements_02()
global_narrative_is_on = TRUE;

// Miller : They're moving to fortify!
dprint ("Miller: They're moving to fortify!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_reinforcements_03()
global_narrative_is_on = TRUE;

// Miller : Additional targets inbound!
dprint ("Miller: Additional targets inbound!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_reinforcements_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

//==WAYPOINTS===========================

script static void vo_glo15_miller_waypoint_01()
global_narrative_is_on = TRUE;

// Miller : Setting a waypoint.
dprint ("Miller: Setting a waypoint.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_waypoint_02()
global_narrative_is_on = TRUE;

// Miller : Marking your target now.
dprint ("Miller: Marking your target now.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_waypoint_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==ENEMIES===========================

/*script static void vo_glo15_miller_turrets_01()
global_narrative_is_on = TRUE;

// Miller : Turrets!
dprint ("Miller: Turrets!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_turrets_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_turrets_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_covenant_01()
global_narrative_is_on = TRUE;

// Miller : Covenant!
dprint ("Miller: Covenant!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_covenant_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_covenant_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/


script static void vo_glo15_miller_covenant_02()
global_narrative_is_on = TRUE;

// Miller : More Covenant!
dprint ("Miller: More Covenant!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_covenant_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_covenant_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*

script static void vo_glo15_miller_grunts_01()
global_narrative_is_on = TRUE;

// Miller : Grunts!
dprint ("Miller: Grunts!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_grunts_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_grunts_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_grunts_02()
global_narrative_is_on = TRUE;

// Miller : More grunts!
dprint ("Miller: More grunts!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_grunts_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_grunts_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_elites_01()
global_narrative_is_on = TRUE;

// Miller : Elites!
dprint ("Miller: Elites!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_elites_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_elites_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_elites_02()
global_narrative_is_on = TRUE;

// Miller : More elites!
dprint ("Miller: More elites!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_elites_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_elites_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end*/


script static void vo_glo15_miller_hunters_01()
global_narrative_is_on = TRUE;

// Miller : Hunters!
dprint ("Miller: Hunters!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hunters_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_hunters_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_jackals_01()
global_narrative_is_on = TRUE;

// Miller : Jackals!
dprint ("Miller: Jackals!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_jackals_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_jackals_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_jackals_02()
global_narrative_is_on = TRUE;

// Miller : More jackals!
dprint ("Miller: More jackals!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_jackals_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_jackals_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/


script static void vo_glo15_miller_prometheans_01()
global_narrative_is_on = TRUE;

// Miller : Prometheans!
dprint ("Miller: Prometheans!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_prometheans_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_prometheans_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*


script static void vo_glo15_miller_prometheans_02()
global_narrative_is_on = TRUE;

// Miller : More Prometheans!
dprint ("Miller: More Prometheans!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_prometheans_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_prometheans_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_knights_01()
global_narrative_is_on = TRUE;

// Miller : Knights!
dprint ("Miller: Knights!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_knights_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_knights_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_knights_02()
global_narrative_is_on = TRUE;

// Miller : More Knights!
dprint ("Miller: More Knights!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_knights_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_knights_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/

script static void vo_glo15_miller_watchers_01()
global_narrative_is_on = TRUE;

// Miller : Watchers!
dprint ("Miller: Watchers!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_watchers_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_watchers_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_watchers_02()
global_narrative_is_on = TRUE;

// Miller : More Watchers!
dprint ("Miller: More Watchers!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_watchers_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_watchers_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_crawlers_01()
global_narrative_is_on = TRUE;

// Miller : Crawlers!
dprint ("Miller: Crawlers!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crawlers_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crawlers_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_crawlers_02()
global_narrative_is_on = TRUE;

// Miller : More Crawlers!
dprint ("Miller: More Crawlers!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crawlers_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crawlers_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_banshees_01()
global_narrative_is_on = TRUE;

// Miller : Banshees!
dprint ("Miller: Banshees!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_banshees_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_banshees_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

*/
script static void vo_glo15_miller_ghosts_01()
global_narrative_is_on = TRUE;

// Miller : Ghosts!
dprint ("Miller: Ghosts!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_ghosts_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_ghosts_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end




script static void vo_glo15_miller_wraith_01()
global_narrative_is_on = TRUE;

// Miller : Wraith!
dprint ("Miller: Wraith!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_wraith_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_wraith_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*

script static void vo_glo15_miller_cover_01()
global_narrative_is_on = TRUE;

// Miller : Find some cover!
dprint ("Miller: Find some cover!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_cover_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_cover_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_holdoff_01()
global_narrative_is_on = TRUE;

// Miller : Hold them off!
dprint ("Miller: Hold them off!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_holdoff_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_holdoff_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_almost_01()
global_narrative_is_on = TRUE;

// Miller : Almost there.
dprint ("Miller: Almost there.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_almost_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_almost_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_walls_01()
global_narrative_is_on = TRUE;

// Miller : On the walls!
dprint ("Miller: On the walls!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_walls_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_walls_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_walls_02()
global_narrative_is_on = TRUE;

// Miller : Coming down the walls!
dprint ("Miller: Coming down the walls!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_walls_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_walls_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_done_01()
global_narrative_is_on = TRUE;

// Miller : There.
dprint ("Miller: There.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_done_02()
global_narrative_is_on = TRUE;

// Miller : Done.
dprint ("Miller: Done.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_done_03()
global_narrative_is_on = TRUE;

// Miller : That should do it.
dprint ("Miller: That should do it.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_done_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end
*/

script static void vo_glo15_miller_snipers_01()
global_narrative_is_on = TRUE;

// Miller : Snipers!
dprint ("Miller: Snipers!");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_snipers_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_snipers_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end

/*
script static void vo_glo15_miller_heavy_01()
global_narrative_is_on = TRUE;

// Miller : They're wheeling in the big guns, Crimson.
dprint ("Miller: They're wheeling in the big guns, Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_heavy_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_heavy_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


//==MISC===========================

script static void vo_glo15_miller_roger_01()
global_narrative_is_on = TRUE;

// Miller : Roger that.
dprint ("Miller: Roger that.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_roger_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_roger_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_roger_02()
global_narrative_is_on = TRUE;

// Miller : Acknowledged.
dprint ("Miller: Acknowledged.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_roger_02', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_roger_02'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_roger_03()
global_narrative_is_on = TRUE;

// Miller : Affirmative.
dprint ("Miller: Affirmative.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_roger_03', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_roger_03'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_crimson_01()
global_narrative_is_on = TRUE;

// Miller : Crimson.
dprint ("Miller: Crimson.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crimson_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_crimson_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_palmer_01()
global_narrative_is_on = TRUE;

// Miller : Palmer
dprint ("Miller: Palmer");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_palmer_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_palmer_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_dalton_01()
global_narrative_is_on = TRUE;

// Miller : Dalton.
dprint ("Miller: Dalton.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_dalton_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_dalton_01'));
	
end_radio_transmission();
global_narrative_is_on = FALSE;
end


script static void vo_glo15_miller_roland_01()
global_narrative_is_on = TRUE;

// Miller : Roland.
dprint ("Miller: Roland.");
start_radio_transmission("miller_transmission_name");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_roland_01', NONE, 1);
sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\global_dialog_15\glo_miller_roland_01'));

global_narrative_is_on = FALSE;

end
*/

// ============================================	MISC SCRIPT	========================================================