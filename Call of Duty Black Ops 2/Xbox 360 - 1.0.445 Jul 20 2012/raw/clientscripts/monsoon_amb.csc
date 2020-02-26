//
// file: monsoon_amb.csc
// description: clientside ambient script for monsoon: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_audio;

main()
{
	snd_set_snapshot("spl_monsoon_fade_in");	
	
	declareAmbientRoom( "monsoon_outdoor" );
	setAmbientRoomTone ("monsoon_outdoor","blk_monsoon_wind_2D", .5, .5);
	setAmbientRoomReverb ("monsoon_outdoor","monsoon_outdoor", 1, 1);
	setAmbientRoomContext( "monsoon_outdoor", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "monsoon_outdoor" );
	
	declareAmbientRoom( "mon_outside_elevator" );
	setAmbientRoomReverb ("mon_outside_elevator","monsoon_vader_lobby", 1, 1);
	setAmbientRoomContext( "mon_outside_elevator", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_outside_elevator" );
	
	declareAmbientRoom( "mon_gaurd_booth" );
	setAmbientRoomReverb ("mon_gaurd_booth","monsoon_booth", 1, 1);
	setAmbientRoomContext( "mon_gaurd_booth", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_gaurd_booth" );
		
	declareAmbientRoom( "mon_temple_arch_lrg" );
	setAmbientRoomTone ("mon_temple_arch_lrg","blk_monsoon_wind_2D", .5, .5);
	setAmbientRoomReverb ("mon_temple_arch_lrg","monsoon_arch_lg", 1, 1);
	setAmbientRoomContext( "mon_temple_arch_lrg", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "mon_temple_arch_lrg" );
	
	declareAmbientRoom( "mon_temple_arch_sml" );
	setAmbientRoomTone ("mon_temple_arch_sml","blk_monsoon_wind_2D", .5, .5);
	setAmbientRoomReverb ("mon_temple_arch_sml","monsoon_arch_sml", 1, 1);
	setAmbientRoomContext( "mon_temple_arch_sml", "ringoff_plr", "outdoor" );
	declareAmbientPackage( "mon_temple_arch_sml" );
	
	declareAmbientRoom( "mon_temple_hallway" );
	setAmbientRoomReverb ("mon_temple_hallway","monsoon_arch_hall", 1, 1);
	setAmbientRoomContext( "mon_temple_hallway", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_temple_hallway" );
	
	declareAmbientRoom( "mon_lab_hallway" );
	setAmbientRoomTone ("mon_lab_hallway","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_lab_hallway","monsoon_lab_hall", 1, 1);
	setAmbientRoomContext( "mon_lab_hallway", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_lab_hallway" );
		
	declareAmbientRoom( "mon_lab_room_sml" );
	setAmbientRoomTone ("mon_lab_room_sml","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_lab_room_sml","monsoon_lab_sml", 1, 1);
	setAmbientRoomContext( "mon_lab_room_sml", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_lab_room_sml" );
		
	declareAmbientRoom( "mon_lab_entr_room" );
	setAmbientRoomTone ("mon_lab_entr_room","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_lab_entr_room","monsoon_lab_lg", 1, 1);
	setAmbientRoomContext( "mon_lab_entr_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_lab_entr_room" );
	
	declareAmbientRoom( "mon_rock_hallway" );
	setAmbientRoomReverb ("mon_rock_hallway","monsoon_stone_hall", 1, 1);
	setAmbientRoomContext( "mon_rock_hallway", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_rock_hallway" );
	
	declareAmbientRoom( "mon_server_room_bot" );
	setAmbientRoomTone ("mon_server_room_bot","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_server_room_bot","monsoon_server_sml", 1, 1);
	setAmbientRoomContext( "mon_server_room_bot", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_server_room_bot" );
	
	declareAmbientRoom( "mon_server_room_cntr" );
	setAmbientRoomTone ("mon_server_room_cntr","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_server_room_cntr","monsoon_server_lg", 1, 1);
	setAmbientRoomContext( "mon_server_room_cntr", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_server_room_cntr" );
	
	declareAmbientRoom( "mon_server_room_top" );
	setAmbientRoomTone ("mon_server_room_top","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_server_room_top","monsoon_server_top", 1, 1);
	setAmbientRoomContext( "mon_server_room_top", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_server_room_top" );
	
	//declareAmbientRoom( "mon_elev_rooms_sml" );
	//setAmbientRoomReverb ("mon_elev_rooms_sml","monsoon_server_sml", 1, 1);
	//setAmbientRoomContext( "mon_elev_rooms_sml", "ringoff_plr", "indoor" );
	//declareAmbientPackage( "mon_elev_rooms_sml" );
	
	declareAmbientRoom( "mon_elev_room" );
	setAmbientRoomTone ("mon_elev_room","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_elev_room","monsoon_vader_room", 1, 1);
	setAmbientRoomContext( "mon_elev_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_elev_room" );
	
	declareAmbientRoom( "mon_inside_elev" );
	setAmbientRoomReverb ("mon_inside_elev","monsoon_vader_int", 1, 1);
	setAmbientRoomContext( "mon_inside_elev", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_inside_elev" );
	
	declareAmbientRoom( "mon_lower_lab_sml" );
	setAmbientRoomTone ("mon_lower_lab_sml","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_lower_lab_sml","monsoon_lab_sml", 1, 1);
	setAmbientRoomContext( "mon_lower_lab_sml", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_lower_lab_sml" );
	
	
	declareAmbientRoom( "mon_lower_lab_med_room" );
	setAmbientRoomTone ("mon_lower_lab_med_room","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_lower_lab_med_room","monsoon_lab_lg", 1, 1);
	setAmbientRoomContext( "mon_lower_lab_med_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_lower_lab_med_room" );
	
	declareAmbientRoom( "mon_lower_lab_sml_room" );
	setAmbientRoomTone ("mon_lower_lab_sml_room","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mon_lower_lab_sml_room","monsoon_lab_sml", 1, 1);
	setAmbientRoomContext( "mon_lower_lab_sml_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_lower_lab_sml_room" );
	
	declareAmbientRoom( "mom_main_lab_cntr_bot" );
	setAmbientRoomTone ("mom_main_lab_cntr_bot","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mom_main_lab_cntr_bot","monsoon_lab_lg", 1, 1);
	setAmbientRoomContext( "mom_main_lab_cntr_bot", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mom_main_lab_cntr_bot" );
	
	declareAmbientRoom( "mom_main_lab" );
	setAmbientRoomTone ("mom_main_lab","amb_comp_room_2d", .5, .5);
	setAmbientRoomReverb ("mom_main_lab","monsoon_lab_lg", 1, 1);
	setAmbientRoomContext( "mom_main_lab", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mom_main_lab" );
	
	declareAmbientRoom( "mon_gen_corridor" );
	setAmbientRoomReverb ("mon_gen_corridor","monsoon_corridor", 1, 1);
	setAmbientRoomContext( "mon_gen_corridor", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_gen_corridor" );
	
	declareAmbientRoom( "mon_main_gen_room" );
	setAmbientRoomReverb ("mon_main_gen_room","monsoon_main_room", 1, 1);
	setAmbientRoomContext( "mon_main_gen_room", "ringoff_plr", "indoor" );
	declareAmbientPackage( "mon_main_gen_room" );
	
	//declareAmbientRoom( "mon_gen_center" );
	//setAmbientRoomReverb ("mon_gen_center","monsoon_main_room", 1, 1);
	//setAmbientRoomContext( "mon_gen_center", "ringoff_plr", "indoor" );
	//declareAmbientPackage( "mon_gen_center" );
		
		
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "monsoon_outdoor", 0 );
	activateAmbientRoom( 0, "monsoon_outdoor", 0 );	
	
	//thread snd_play_loopers();
	thread snd_start_autofx_audio();
	level thread wingsuit();
	level thread snd_start_add_exploder_alias();
	level thread snapshot_check();
	level thread heliWatcher();
	
}

heliWatcher()
{
	level waittill ("stpheli");
	
	self.should_not_play_sounds = true;
}
snapshot_check()
{
	level endon ("intr_on");
	wait (2);
	//iprintlnbold ("snp_default");
	snd_set_snapshot("default");	
}
snd_play_loopers()
{
	//playloopat( "amb_water_int_trans_rumb", (2518, 4050, 373) );	
}
	
snd_start_add_exploder_alias()
{
	wait (1);
	//snd_add_exploder_alias( 88, "amb_thunder_clap" );
	snd_add_exploder_alias( 1000, "evt_ruins_doors_explode" );//inner temple doors
}
	
snd_start_autofx_audio()
{
	//snd_play_auto_fx ( "fx_fireplace01", "amb_fireplace", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_mon_vent_roof_steam_lg", "amb_steam_lrg", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_water_spill_splash_wide", "amb_water_drip", 0, 0, 0, true );
	snd_play_auto_fx ( "fx_water_roof_spill_lg_hvy", "amb_water_splash_2", 0, 0, 0, true );
}
wingsuit()
{
	ent1 = spawn( 0, (0,0,0), "script_origin");
	level waittill ( "wng_st" );
	ent1 playloopsound ("evt_wingsuit_wind_fnt", 2.5 );
	level waittill ( "wg_st_dn" );
	ent1 stoploopsound (7);
	ent1 delete();
}
