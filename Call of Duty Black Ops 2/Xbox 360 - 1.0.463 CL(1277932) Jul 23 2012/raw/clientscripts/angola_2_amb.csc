//
// file: angola_2_amb.csc
// description: clientside ambient script for angola_2: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_audio;

main()
{
	declareAmbientRoom( "outdoor" );
		setAmbientRoomTone ("outdoor","blk_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("outdoor","angola_outside", 1, 1);
		setAmbientRoomContext( "outdoor", "ringoff_plr", "outdoor" );
		setAmbientRoomContext( "outdoor", "grass", "no_grass" );
		declareAmbientPackage( "outdoor" );
		
	declareAmbientRoom( "grass_short" );
		setAmbientRoomTone ("grass_short","blk_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("grass_short","angola_outside", 1, 1);
		setAmbientRoomContext( "grass_short", "ringoff_plr", "outdoor" );
		setAmbientRoomContext( "grass_short", "grass", "in_grass" );
		declareAmbientPackage( "grass_short" );
		
	declareAmbientRoom( "riverbed" );
		setAmbientRoomReverb ("riverbed","angola_riverbed", 1, 1);
		setAmbientRoomContext( "riverbed", "grass", "no_grass" );
		setAmbientRoomContext( "riverbed", "ringoff_plr", "outdoor" );
		declareAmbientPackage( "riverbed" );
		
	declareAmbientRoom( "rock_passage" );
		setAmbientRoomTone ("outdoor","blk_outdoor_bg", .5, .5);
		setAmbientRoomReverb ("rock_passage","angola_rockwall", 1, 1);
		setAmbientRoomContext( "rock_passage", "ringoff_plr", "outdoor" );
		setAmbientRoomContext( "rock_passage", "grass", "no_grass" );
		declareAmbientPackage( "rock_passage" );
		
	declareAmbientRoom( "boat_int" );
		setAmbientRoomReverb ("boat_int","angola_boat_cabin", 1, 1);
		setAmbientRoomContext( "boat_int", "ringoff_plr", "outdoor" );
		setAmbientRoomContext( "boat_int", "grass", "no_grass" );
		declareAmbientPackage( "boat_int" );

	declareAmbientRoom( "small_room" );
		setAmbientRoomReverb ("small_room","angola_smallroom", 1, 1);
		setAmbientRoomContext( "small_room", "ringoff_plr", "indoor" );
		setAmbientRoomContext( "small_room", "grass", "no_grass" );
		declareAmbientPackage( "small_room" );		
		
	declareAmbientRoom( "forest" );
		setAmbientRoomReverb ("forest","angola_forest", 1, 1);
		setAmbientRoomContext( "forest", "ringoff_plr", "outdoor" );
		setAmbientRoomContext( "forest", "grass", "no_grass" );
		declareAmbientPackage( "forest" );	
		
	declareAmbientRoom( "village" );
		setAmbientRoomReverb ("village","angola_village", 1, 1);
		setAmbientRoomContext( "village", "ringoff_plr", "outdoor" );
		setAmbientRoomContext( "village", "grass", "no_grass" );
		declareAmbientPackage( "village" );	
		
	declareAmbientRoom( "open_hut" );
		setAmbientRoomReverb ("open_hut","angola_open_hut", 1, 1);
		setAmbientRoomContext( "open_hut", "ringoff_plr", "outdoor" );
		setAmbientRoomContext( "open_hut", "grass", "no_grass" );
		declareAmbientPackage( "open_hut" );	
		
	declareAmbientRoom( "open_hut_med" );
		setAmbientRoomReverb ("open_hut_med","angola_open_hut_med", 1, 1);
		setAmbientRoomContext( "open_hut_med", "ringoff_plr", "outdoor" );
		setAmbientRoomContext( "open_hut_med", "grass", "no_grass" );
		declareAmbientPackage( "open_hut_med" );	
		
	declareAmbientRoom( "woods_container" );
		setAmbientRoomReverb ("woods_container","angola_container", 1, 1);
		setAmbientRoomContext( "woods_container", "ringoff_plr", "indoor" );
		setAmbientRoomContext( "woods_container", "grass", "no_grass" );
		declareAmbientPackage( "woods_container" );		
		

	
	activateAmbientPackage( 0, "outdoor", 0 );
	activateAmbientRoom( 0, "outdoor", 0 );

	//TUEY set up music
	declaremusicState ("ANGOLA_JUNGLE_ESCAPE");
		musicAlias ("mus_angola_escape", 0);
		musicAliasloop ("NULL", 0, 0);	
	
	level thread waterfalls();			
	level thread escape_alarm();
	level thread escape_dogs();
	level thread truck_loops();
	level thread child_soldiers();
	thread snd_start_autofx_audio();
	level thread heli_fire();
	level thread set_alouette_context_int();
	level thread set_alouette_context_ext();
	level thread reset_alouette_context_ext();
	level thread chasers();
	level thread sinking_barge();
	level thread notetracked_clientnotifies();
	level thread heli_jump_snapshot();
}
//Play looping sound on looping effects using createfx ents: (effect name, alias name, coord, snap to ground T/F)
snd_start_autofx_audio()
{

	snd_play_auto_fx ( "fx_insects_fly_swarm", "amb_insects", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_ango_fire_sm", "amb_fire_sml", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_ango_heli_fire", "amb_fire_lrg", 0, 0, 0, false );
	snd_play_auto_fx ( "fx_angO-waterfall_bottom", "amb_waterfall_splash", 0, 0, 0, false );	
	
}

waterfalls()
{
	//soundloopemitter ("amb_waterfall_sml", (-25447, 662, 187) );
	//soundloopemitter ("amb_waterfall_sml", (-25589, 683, 54) );
	
	playloopat ("amb_waterfall_lg", (-20398, -865, 362) );
	playloopat ("amb_waterfall_splash", (-20349, -851, 476) );
	
	playloopat ("amb_waterfall_lg", (-22158, 299, 276) );
	playloopat ("amb_waterfall_splash", (-22158, 256, 273) );
	
	playloopat ("amb_waterfall_lg", (-25447, 670, 217) );
	playloopat ("amb_waterfall_lg", (-25579, 666, 94) );	
	playloopat ("amb_waterfall_splash", (-25608, 569, 50)  );	
	
	//Water splash loops in creek
	playloopat ("amb_creek_rock_lp", (-23494, -384, 276) );
	playloopat ("amb_creek_rock_lp", (-24141, 274, 270) );
	playloopat ("amb_creek_rock_lp", (-25878, 595, 48) );
	
	//Generic jungle amb loops
	playloopat ("amb_jungle_gen_a", (-24687, 3224, 842) );
	playloopat ("amb_jungle_gen_b", (-25950, 726, 1101) );
	playloopat ("amb_jungle_gen_c", (-24441, 225, 843) );
	
	playloopat ("amb_shore_water", (-27357, -2444, -6) );
	
	
}

escape_alarm()
{
	
	level waittill ( "esc_alrm" );
	
	wait (5);
	
	soundloopemitter ("evt_escape_alarm", (-18480, -3024, 728));
	wait(.1);
	soundloopemitter ("evt_escape_alarm", (-18547, -2057, 768));
	soundloopemitter ("evt_escape_alarm", (-19070, -4033, 992));
	soundloopemitter ("evt_escape_walla", (-18857, -2943, 742));	
	wait(.15);
	soundloopemitter ("evt_escape_alarm", (-17712, -3812, 992));
	soundloopemitter ("evt_escape_alarm", (-22900, -3591, 911));
}

escape_dogs()
{
	
	level waittill ( "grn_dgs" );
	
	while (1)
	{
		PlaySound (0, "evt_escape_dogs", (-18953, -3434, 649));
		wait (RandomInt (2) );
		PlaySound (0, "evt_escape_dogs", (-19051, -2422, 638));
		wait (RandomInt (2) );
	}
}

truck_loops()
{

	truck_ent_1 = spawn(0, (-17780, -1539, 571), "script_origin" );
	truck_ent_2 = spawn(0, (-17770, -3391, 556), "script_origin" );
	truck_ent_1 playloopsound( "amb_truck_loop_1", .1 );
	truck_ent_2 playloopsound( "amb_truck_loop_2", .1 );
	
}

child_soldiers()
{
	//right of house	
	cs_emit_1 = spawn(0, (-23207, -4260, 516), "script_origin" );
	//left of cover log	
	cs_emit_2 = spawn(0, (-23191, -2383, 494), "script_origin" );
	//behind grass cover	
	cs_emit_3 = spawn(0, (-21466, -3545, 587), "script_origin" );
	//across from grass cover	
	cs_emit_4 = spawn(0, (-21953, -2064, 476), "script_origin" );
	//left of path behind interact shed	
	cs_emit_5 = spawn(0, (-17780, -1539, 571), "script_origin" );		
	
	//right of house	
	cs_emit_1 playloopsound( "amb_child_soldiers_1", .1 );
	//left of cover log	
	cs_emit_2 playloopsound( "amb_child_soldiers_2", .1 );
	//behind grass cover	
	cs_emit_3 playloopsound( "amb_child_soldiers_3", .1 );
	//across from grass cover	
	cs_emit_4 playloopsound( "amb_child_soldiers_4", .1 );
	//left of path behind interact shed	
	cs_emit_5 playloopsound( "amb_child_soldiers_5", .1 );	
	
	level waittill ( "esc_alrm" );
	
	cs_emit_1 stoploopsound( 1 );
	cs_emit_2 stoploopsound( 1 );
	cs_emit_3 stoploopsound( 1 );
	cs_emit_4 stoploopsound( 1 );
	cs_emit_5 stoploopsound( 1 );
}

heli_fire()
{
	soundloopemitter ("amb_heli_fire", (-26711, -2143, 44));
}


set_alouette_context_int()
{
	level waittill( "f35_interior" );
	waitforclient(0);
	setsoundcontext( "f35", "interior" );
}


set_alouette_context_ext()
{
	level waittill ("alouette_jumped");
	wait (1.5);	
	setsoundcontext ( "f35", "exterior" );
}

reset_alouette_context_ext()
{
	while(1)
	{
		level waittill ("heli_context_switch");
		setsoundcontext ( "f35", "exterior" );
	}
}


chasers()
{
	//level waittill ( "chsr" );
	//wait (5);
		//while(1)
		//{
			//playsound( 0, "vox_amb_soldiers", (-25689, -2661, 289) );	
			//wait (RandomInt (8));
		//}
}
sinking_barge()
{
	level waittill ( "barge_sink" );
	soundloopemitter ( "evt_barge_overflow", (-28502, -3770, 41) );
	soundloopemitter ( "evt_barge_overflow", (-28287, -3317, 41) );
		
}

notetracked_clientnotifies()
{
	level thread boatRamSnapshots();
	level thread findWoodsSequence();
}
boatRamSnapshots()
{
	level thread boatRamSnapshotOn();
	level thread boatRamSnapshotOff();
}
boatRamSnapshotOn()
{
	level waittill( "boatram_on" );
	snd_set_snapshot( "spl_angola_evt06_boatram" );
}
boatRamSnapshotOff()
{
	level waittill( "boatram_off" );
	snd_set_snapshot( "default" );
}
findWoodsSequence()
{
	level thread findWoodsSnapshot();
	level thread findWoodsRoom();
}
findWoodsSnapshot()
{
	level waittill( "woods_snp_on" );
	snd_set_snapshot( "spl_angola_evt06_findwoods" );
	
	level waittill( "woods_snp_off" );
	snd_set_snapshot( "default" );
}
findWoodsRoom()
{
	level waittill( "woods_room_on" );
	activateAmbientPackage( 0, "woods_container", 80 );
	activateAmbientRoom( 0, "woods_container", 80 );
	
	level waittill( "woods_room_off" );
	deactivateAmbientPackage( 0, "woods_container", 80 );
	deactivateAmbientRoom( 0, "woods_container", 80 );
}

heli_jump_snapshot()
{
	level waittill ("alouette_jumped");
	snd_set_snapshot ("spl_angola_barge_fight");
	
	wait (12);
	snd_set_snapshot ("default");
}