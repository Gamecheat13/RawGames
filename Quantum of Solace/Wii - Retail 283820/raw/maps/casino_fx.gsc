#include maps\_utility;


main()
{
	initFXModelAnims();

	


	
    registerFXTargetName("fx_debug");               
    registerFXTargetName("fx_OK");

    
	registerFXTargetName("casino_sauna_steam");		
	registerFXTargetName("casino_pool_steam");		
	registerFXTargetName("ballroom_confetti1_fx"); 	
	registerFXTargetName("ballroom_confetti2_fx"); 	
	registerFXTargetName("ballroom_sparks1_fx"); 	
	registerFXTargetName("ballroom_sparks2_fx"); 	
	registerFXTargetName("casino_chandelier_fall");
	registerFXTargetName("casino_chandelier_burst");		
	registerFXTargetName("monitor_fall_fx");
	registerFXTargetName("door_fall_fx");
	registerFXTargetName("small_glass_burst_fx1"); 
	registerFXTargetName("small_glass_burst_fx2");
	registerFXTargetName("small_glass_burst_fx3");
	registerFXTargetName("small_glass_burst_fx4");
	registerFXTargetName("small_glass_burst_fx5");
	registerFXTargetName("small_glass_burst_fx6");
	registerFXTargetName("small_glass_burst_fx7");
	registerFXTargetName("small_glass_burst_fx8");
	registerFXTargetName("small_glass_burst_fx9");
	registerFXTargetName("large_glass_burst_fx1");
	registerFXTargetName("large_glass_burst_fx2");
	registerFXTargetName("large_glass_burst_fx3");
	registerFXTargetName("large_glass_burst_fx4");
	registerFXTargetName("large_glass_burst_fx5");
	registerFXTargetName("large_glass_burst_fx6");
	registerFXTargetName("ballroom_glass_burst1a");
	registerFXTargetName("ballroom_glass_burst2a");
	registerFXTargetName("ballroom_glass_burst3a");
	registerFXTargetName("ballroom_glass_burst4a");
	registerFXTargetName("ballroom_glass_burst1b");
	registerFXTargetName("ballroom_glass_burst2b");
	registerFXTargetName("ballroom_glass_burst3b");
	registerFXTargetName("ballroom_glass_burst4b");
	registerFXTargetName("ballroom_glass_burst1c");
	registerFXTargetName("ballroom_glass_burst2c");
	registerFXTargetName("ballroom_glass_burst3c");
	registerFXTargetName("ballroom_glass_burst4c");
	registerFXTargetName("ballroom_glass_burst1d");
	registerFXTargetName("ballroom_glass_burst2d");
	registerFXTargetName("ballroom_glass_burst3d");
	registerFXTargetName("ballroom_glass_burst4d");
	
	precacheFX();
	maps\createfx\casino_fx::main();
	
	

	
	
	
	
	level thread maps\_fx::quick_kill_fx_on();
	
	level thread create_boss_fight_fx();
}

animate_aircraft_effect()
{
	level waittill("fx_aircraft_flyby");
	level thread animate_effect("casino_747", (270,252.839,19.1612), (2935.42, -865.632, 1921.95), (3316.41, 7048.19, 2500), 80);
	
	level thread animate_effect("casino_747", (270,342.715,37.2851), (6803.86,3667.39,4000), (-2860.34,-650.645,4000), 80);
}

animate_effect(effect, start_angle, start_origin, end_origin, anim_time)
{
	
	
	ent_tag = undefined;
	ent_tag = Spawn("script_model", start_origin);
	ent_tag SetModel("tag_origin");
	ent_tag.angles = start_angle;
		
	PlayFxOnTag(level._effect[effect], ent_tag, "tag_origin");
	ent_tag moveto( end_origin, anim_time );
}

test_glass_fxs()
{
	wait(15);
	
	while(1)
	{
		level notify("ballroom_glass_burst1");
		wait(2.1);
		level notify("ballroom_glass_burst2");
		wait(2.1);
		level notify("ballroom_glass_burst3");
		wait(2.1);
		level notify("ballroom_glass_burst4");
		wait(2.1);
	}
}

test_fxs()
{
	wait(15);
	int_fx_count = 0;
	level notify("ballroom_sparks1_fx");
	
	while(1)
	{
		if( int_fx_count == 4 ) {
			level notify("ballroom_sparks1_fx");
			int_fx_count = 0;
		}
		level notify("ballroom_confetti1_fx");
		wait(0.5);
		level notify("ballroom_confetti2_fx");
		wait(0.5);
		level notify("ballroom_sparks2_fx");
		wait(6);
		int_fx_count++;
	}
}

start_fxfunc( targetname, func, param )
{
	ent = getent( targetname, "targetname" );
	if ( IsDefined( ent ) )
	{
		if ( IsDefined( param ) )
		{
			ent thread [[func]]( param );
		}
		else
		{
			ent thread [[func]]();
		}
	}
}


initFXModelAnims()
{
	ent1 = getent( "fxanim_piano_chandelier", "targetname" );
	ent2 = getent( "fxanim_vent_1", "targetname" );
	ent3 = getent( "fxanim_vent_2", "targetname" );
	ent4 = getent( "fxanim_drapes_1", "targetname" );
	ent5 = getent( "fxanim_drapes_2", "targetname" );
	ent6 = getent( "fxanim_spa_wall", "targetname" );
	ent7 = getent( "fxanim_piano_chandelier_d", "targetname" );
	ent8 = getent( "fxanim_weapon_case_lrg", "targetname" );
	
	if (IsDefined(ent1)) { ent1 thread piano_chandelier(); println("************* FX: piano_chandelier *************"); }
	if (IsDefined(ent2)) { ent2 thread vent_animation_1(); println("************* FX: vent_1 *************"); }
	if (IsDefined(ent3)) { ent3 thread vent_animation_2(); }
	if (IsDefined(ent4)) { ent4 thread drapes_animation_1();   println("************* FX: drapes_1 *************"); }
	if (IsDefined(ent5)) { ent5 thread drapes_animation_2(); }
	if (IsDefined(ent6)) { ent6 thread spa_wall();   println("************* FX: spa_wall *************"); }
	if (IsDefined(ent7)) { ent7 thread piano_chandelier_d();   println("************* FX: piano_chandelier_d *************"); }
	if (IsDefined(ent8)) { ent8 thread weapon_case_lrg();   println("************* FX: weapon_case_lrg *************"); }


	start_fxfunc( "fxanim_sm_banner_red_1",		::sm_banner_red_animation,		"sm_banner_red_1_start" );		println("************* FX: sm_banner_red *************");
	start_fxfunc( "fxanim_sm_banner_red_2",		::sm_banner_red_animation,		"sm_banner_red_2_start" );
	start_fxfunc( "fxanim_sm_banner_purple_1",	::sm_banner_purple_animation,	"sm_banner_purple_1_start" );   println("************* FX: sm_banner_purple *************");
	start_fxfunc( "fxanim_sm_banner_purple_2",	::sm_banner_purple_animation,	"sm_banner_purple_2_start" );
	start_fxfunc( "fxanim_sm_banner_purple_3",	::sm_banner_purple_animation,	"sm_banner_purple_3_start" );
	start_fxfunc( "fxanim_sm_banner_purple_4",	::sm_banner_purple_animation,	"sm_banner_purple_4_start" );
	start_fxfunc( "fxanim_sm_banner_purple_5",	::sm_banner_purple_animation,	"sm_banner_purple_5_start" );
	start_fxfunc( "fxanim_sm_banner_purple_6",	::sm_banner_purple_animation,	"sm_banner_purple_6_start" );
	start_fxfunc( "fxanim_sm_banner_purple_7",	::sm_banner_purple_animation,	"sm_banner_purple_7_start" );
	start_fxfunc( "fxanim_sm_banner_purple_8",	::sm_banner_purple_animation,	"sm_banner_purple_8_start" );
	start_fxfunc( "fxanim_sm_banner_purple_10",	::sm_banner_purple_animation,	"sm_banner_purple_10_start" );
	start_fxfunc( "fxanim_sm_banner_purple_11",	::sm_banner_purple_animation,	"sm_banner_purple_11_start" );
	start_fxfunc( "fxanim_sm_banner_purple_12",	::sm_banner_purple_animation,	"sm_banner_purple_12_start" );
	start_fxfunc( "fxanim_sm_banner_purple_13",	::sm_banner_purple_animation,	"sm_banner_purple_13_start" );
	start_fxfunc( "fxanim_sm_banner_purple_14",	::sm_banner_purple_animation,	"sm_banner_purple_14_start" );
	start_fxfunc( "fxanim_sm_banner_purple_15",	::sm_banner_purple_animation,	"sm_banner_purple_15_start" );
	start_fxfunc( "fxanim_sm_banner_blue_1",	::sm_banner_blue_animation,		"sm_banner_blue_1_start" );   println("************* FX: sm_banner_blue *************");
	start_fxfunc( "fxanim_sm_banner_blue_2",	::sm_banner_blue_animation,		"sm_banner_blue_2_start" );
	start_fxfunc( "fxanim_sm_banner_blue_3",	::sm_banner_blue_animation,		"sm_banner_blue_3_start" );
	start_fxfunc( "fxanim_sm_banner_blue_4",	::sm_banner_blue_animation,		"sm_banner_blue_4_start" );
	start_fxfunc( "fxanim_sm_banner_blue_5",	::sm_banner_blue_animation,		"sm_banner_blue_5_start" );
	start_fxfunc( "fxanim_sm_banner_blue_6",	::sm_banner_blue_animation,		"sm_banner_blue_6_start" );
	start_fxfunc( "fxanim_sm_banner_blue_7",	::sm_banner_blue_animation,		"sm_banner_blue_7_start" );
	start_fxfunc( "fxanim_sm_banner_blue_8",	::sm_banner_blue_animation,		"sm_banner_blue_8_start" );
	start_fxfunc( "fxanim_big_banner_1",		::big_banner_animation,			"big_banner_1_start" );   println("************* FX: big_banner_1 *************");
	start_fxfunc( "fxanim_big_banner_2",		::big_banner_animation,			"big_banner_2_start" );
	start_fxfunc( "fxanim_big_banner_3",		::big_banner_animation,			"big_banner_3_start" );
	start_fxfunc( "fxanim_big_banner_4",		::big_banner_animation,			"big_banner_4_start" );
	start_fxfunc( "fxanim_big_banner_5",		::big_banner_animation,			"big_banner_5_start" );
	start_fxfunc( "fxanim_big_banner_6",		::big_banner_animation,			"big_banner_6_start" );
	start_fxfunc( "fxanim_big_banner_7",		::big_banner_animation,			"big_banner_7_start" );
	start_fxfunc( "fxanim_big_banner_8",		::big_banner_animation,			"big_banner_8_start" );
	start_fxfunc( "fxanim_big_banner_9",		::big_banner_animation,			"big_banner_9_start" );
	start_fxfunc( "fxanim_big_banner_10",		::big_banner_animation,			"big_banner_10_start" );
	start_fxfunc( "fxanim_big_banner_11",		::big_banner_animation,			"big_banner_11_start" );
	start_fxfunc( "fxanim_big_banner_12",		::big_banner_animation,			"big_banner_12_start" );
}

#using_animtree("fxanim_piano_chandelier");
piano_chandelier()
{
	level waittill("piano_chandelier_start");
	self UseAnimTree(#animtree);
	self animscripted("a_piano_chandelier", self.origin, self.angles, %fxanim_piano_chandelier);
	
	level notify("casino_chandelier_fall");
	
	
	if (animhasnotetrack(%fxanim_piano_chandelier, "gems_explode"))
	{
		
		self waittillmatch("a_piano_chandelier", "gems_explode");
		level notify("casino_chandelier_burst");		
	}
}

#using_animtree("fxanim_piano_chandelier_d");
piano_chandelier_d()
{
	level waittill("piano_chandelier_d_start");
	self UseAnimTree(#animtree);
	self animscripted("a_piano_chandelier_d", self.origin, self.angles, %fxanim_piano_chandelier_d);
}

#using_animtree("fxanim_vent_rattle");
vent_animation_1()
{
	level waittill("vent_rattle_1_start");
	self UseAnimTree(#animtree);
	self animscripted("a_vent_rattle_1", self.origin, self.angles, %fxanim_vent_rattle);
	
	level waittill("vent_open_1_start");
	self stopanimscripted();
	self stopuseanimtree();
	vent_open_animation_1();
}

#using_animtree("fxanim_vent_rattle");
vent_animation_2()
{
	level waittill("vent_rattle_2_start");
	self UseAnimTree(#animtree);
	self animscripted("a_vent_rattle_2", self.origin, self.angles, %fxanim_vent_rattle);
	
	level waittill("vent_open_2_start");
	self stopanimscripted();
	self stopuseanimtree();
	vent_open_animation_2();
}

#using_animtree("fxanim_vent_open");
vent_open_animation_1()
{
	self UseAnimTree(#animtree);
	self animscripted("a_vent_open_1", self.origin, self.angles, %fxanim_vent_open);
}

#using_animtree("fxanim_vent_open");
vent_open_animation_2()
{
	self UseAnimTree(#animtree);
	self animscripted("a_vent_open_2", self.origin, self.angles, %fxanim_vent_open);
}

#using_animtree("fxanim_drapes");
drapes_animation_1()
{
	level waittill("drapes_1_start");
	self UseAnimTree(#animtree);
	self animscripted("a_drapes", self.origin, self.angles, %fxanim_drapes);
}

#using_animtree("fxanim_drapes");
drapes_animation_2()
{
	level waittill("drapes_2_start");
	self UseAnimTree(#animtree);
	self animscripted("a_drapes", self.origin, self.angles, %fxanim_drapes);
}

#using_animtree("fxanim_spa_wall");
spa_wall()
{
	level waittill("spa_wall_start");
	self UseAnimTree(#animtree);
	self animscripted("a_spa_wall", self.origin, self.angles, %fxanim_spa_wall);
	
	
	if (animhasnotetrack(%fxanim_spa_wall, "sm_spa_glass"))
	{
		thread multi_sm_glass_fx(9);
	}	
	if (animhasnotetrack(%fxanim_spa_wall, "lrg_spa_glass"))
	{
		thread multi_lrg_glass_fx(6);
	}
	
	if (animhasnotetrack(%fxanim_spa_wall, "monitor_fall"))
	{
		self waittillmatch("a_spa_wall", "monitor_fall");
		level notify("monitor_fall_fx");		
	}	
	if (animhasnotetrack(%fxanim_spa_wall, "spa_door_fall"))
	{
		self waittillmatch("a_spa_wall", "spa_door_fall");
		level notify("door_fall_fx");		
	}
}

multi_sm_glass_fx(xcount)
{
	int_fx_count = 0;
	
	while( int_fx_count < xcount )
	{
		self waittillmatch("a_spa_wall", "sm_spa_glass");
		
		switch( int_fx_count )
		{
		case 0:
			level notify("small_glass_burst_fx1");
			break;
		case 1:
			level notify("small_glass_burst_fx2");
			break;
		case 2:
			level notify("small_glass_burst_fx3");
			break;
		case 3:
			level notify("small_glass_burst_fx4");
			break;
		case 4:
			level notify("small_glass_burst_fx5");
			break;
		case 5:
			level notify("small_glass_burst_fx6");
			break;
		case 6:
			level notify("small_glass_burst_fx7");
			break;
		case 7:
			level notify("small_glass_burst_fx8");
			break;
		case 8:
			level notify("small_glass_burst_fx9");
			break;		
		}
		int_fx_count++;
	}
}

multi_lrg_glass_fx(xcount)
{
	int_fx_count = 0;
	
	while( int_fx_count < xcount )
	{
		self waittillmatch("a_spa_wall", "lrg_spa_glass");
		
		switch( int_fx_count )
		{
		case 0:
			level notify("large_glass_burst_fx1");
			break;
		case 1:
			level notify("large_glass_burst_fx2");
			break;
		case 2:
			level notify("large_glass_burst_fx3");
			break;
		case 3:
			level notify("large_glass_burst_fx4");
			break;
		case 4:
			level notify("large_glass_burst_fx5");
			break;
		case 5:
			level notify("large_glass_burst_fx6");
			break;	
		}
		int_fx_count++;
	}
}

#using_animtree("fxanim_sm_banner_red");
sm_banner_red_animation( msg )
{
	level waittill( msg );
	self UseAnimTree(#animtree);
	self animscripted("a_sm_banner_red", self.origin, self.angles, %fxanim_sm_banner_red);
}

#using_animtree("fxanim_sm_banner_purple");
sm_banner_purple_animation( msg )
{
	level waittill( msg );
	self UseAnimTree(#animtree);
	self animscripted("a_sm_banner_purple", self.origin, self.angles, %fxanim_sm_banner_purple);
}

#using_animtree("fxanim_sm_banner_blue");
sm_banner_blue_animation( msg )
{
	level waittill( msg );
	self UseAnimTree(#animtree);
	self animscripted("a_sm_banner_blue", self.origin, self.angles, %fxanim_sm_banner_blue);
}
#using_animtree("fxanim_big_banner");
big_banner_animation( msg )
{
	level waittill( msg );
	self UseAnimTree(#animtree);
	self animscripted("a_big_banner", self.origin, self.angles, %fxanim_big_banner);
}

#using_animtree("fxanim_weapon_case_lrg");
weapon_case_lrg()
{
	level waittill("weapon_case_lrg_start");
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case_lrg", self.origin, self.angles, %fxanim_weapon_case_lrg);
}

create_boss_fight_fx()
{
	level waittill("e7_start"); 
	
	while(!IsDefined(level.obanno))
		wait(0.2);
		
	
	level thread maps\_fx::play_igcEffect(level.obanno, level.obanno, "sword_hit_wall", "casino_knife_sparks", "TAG_WEAPON_RIGHT", 1);
	level thread maps\_fx::play_igcEffect(level.obanno, level.obanno, "sword_hit_rail", "casino_knife_sparks", "TAG_WEAPON_RIGHT", 1);	
	level thread maps\_fx::play_igcEffect(level.obanno, level.obanno, "fx_l_foot_dust", "qkill_dust", "L_Foot", 1);
	level thread maps\_fx::play_igcEffect(level.obanno, level.obanno, "fx_r_foot_dust", "qkill_dust2", "R_Foot", 1);
	level thread maps\_fx::play_igcEffect(level.obanno, level.obanno, "fx_head_end_sweat", "qkill_hit_sweat1", "Head", 1);
	level thread maps\_fx::play_igcEffect(level.obanno, level.obanno, "fx_spineupper_impact", "qkill_dust", "SpineUpper", 3);
	level thread maps\_fx::play_igcEffect(level.obanno, level.obanno, "fx_l_knee_dust", "qkill_dust", "L_Knee_Bulge", 1);
	
	
	level thread maps\_fx::play_igcEffect(level.player, level.obanno, "knife_hit_small", "casino_knife_sparks2", "TAG_WEAPON_RIGHT", 2);
	level thread maps\_fx::play_igcEffect(level.player, level.obanno, "fx_l_elbow_blood", "qkill_hit_sweat1", "Head", 1);
	level thread maps\_fx::play_igcEffect(level.player, level.obanno, "fx_r_elbow_dust", "qkill_dust2", "SpineUpper", 1);
	level thread maps\_fx::play_igcEffect(level.player, level.player, "fx_r_wrist_dust", "qkill_dust2", "R_Wrist", 1);
	
	level thread wait_for_notify_note(level.obanno, "sword_hit_wall", "fx_box_spark" );
	level thread wait_for_notify_note(level.obanno, "glass_break", "fx_glass_break" );	
	wait_for_notify_note(level.obanno, "fx_spinemid_big_impact", "fx_big_impact" );
}	


wait_for_notify_note( note_ent, note_name, notify_name )
{	
	note_ent waittillmatch( "anim_notetrack", note_name );
	level notify(notify_name);
}

precacheFX()
{
	level._effect["casino_stairway_dust"]	 	= loadfx ("maps/Casino/casino_stairway_dust");
	level._effect["casino_vent_bullet_vol"]	 	= loadfx ("maps/casino/casino_vent_bullet_vol");
	level._effect["casino_halos_chandelier01"] 	= loadfx ("maps/casino/casino_halos_chandelier01");
	level._effect["casino_halos_chandelier02"] 	= loadfx ("maps/casino/casino_halos_chandelier02");
	level._effect["casino_interior_halo01"] 	= loadfx ("maps/casino/casino_interior_halo01");
	level._effect["casino_interior_halo02"] 	= loadfx ("maps/casino/casino_interior_halo02");
	level._effect["casino_interior_halo03"] 	= loadfx ("maps/casino/casino_interior_halo03");
	level._effect["casino_interior_halo04"] 	= loadfx ("maps/casino/casino_interior_halo04");
	level._effect["casino_interior_halo05"] 	= loadfx ("maps/casino/casino_interior_halo05");
	level._effect["casino_sauna_steam"] 		= loadfx ("maps/casino/casino_sauna_steam");
	level._effect["casino_sauna_steam2"] 		= loadfx ("maps/casino/casino_sauna_steam2"); 
	level._effect["casino_pool_steam"] 			= loadfx ("maps/casino/casino_pool_steam");
	level._effect["casino_halo_shootable"] 		= loadfx ("maps/casino/casino_halo_shootable");
	level._effect["casino_4halos_courtyard01"] 	= loadfx ("maps/casino/casino_4halos_courtyard01");
	level._effect["casino_4halos_courtyard02"] 	= loadfx ("maps/casino/casino_4halos_courtyard02");
	level._effect["casino_4halos_courtyard03"] 	= loadfx ("maps/casino/casino_4halos_courtyard03");
	
	level._effect["casino_air_duct_slat_beams01"] = loadfx ("maps/casino/casino_air_duct_slat_beams01");
	level._effect["casino_air_duct_slat_beams02"] = loadfx ("maps/casino/casino_air_duct_slat_beams02");
	
	
	
	
	
	
	level._effect["casino_spa_splash2"] 		= loadfx ("maps/casino/casino_spa_splash2");
	
	level._effect["casino_chandelier_burst"] 	= loadfx ("maps/casino/casino_chandelier_burst");
	level._effect["casino_chandelier_fall"] 	= loadfx ("maps/casino/casino_chandelier_fall");
	level._effect["casino_sm_glass_burst"] 		= loadfx ("maps/casino/casino_lrg_glass_burst");
	level._effect["casino_lrg_glass_burst"] 	= loadfx ("maps/casino/casino_lrg_glass_burst");
	level._effect["casino_monitor_sparks"] 		= loadfx ("maps/casino/casino_monitor_sparks");
	level._effect["casino_door_fall"] 			= loadfx ("maps/casino/casino_door_fall");
	level._effect["casino_exterior_halo1"] 		= loadfx ("maps/casino/casino_exterior_halo1");
	level._effect["casino_exterior_halo2"] 		= loadfx ("maps/casino/casino_exterior_halo2");
	level._effect["casino_chimney1"]	 		= loadfx ("maps/casino/casino_chimney1");
	level._effect["casino_lamp4_glow"]	 		= loadfx ("maps/casino/casino_lamp4_glow");
	level._effect["casino_lamp4_glow_far"]	 	= loadfx ("maps/casino/casino_lamp4_glow_far");
	level._effect["casino_lamp2_glow_far"]	 	= loadfx ("maps/casino/casino_lamp2_glow_far");
	level._effect["casino_lamp3_glow_far"] 		= loadfx ("maps/casino/casino_lamp3_glow_far");
	level._effect["casino_lamp1_glow"]	 		= loadfx ("maps/casino/casino_lamp1_glow");
	level._effect["casino_parking_light_vol"]	= loadfx ("maps/casino/casino_parking_light_vol");	
	level._effect["casino_spa_waterfall"]	 	= loadfx ("maps/casino/casino_spa_waterfall");
	level._effect["casino_ballroom_glass"]	 	= loadfx ("maps/casino/casino_ballroom_glass");
	level._effect["casino_lcd_vol"]	 			= loadfx ("maps/casino/casino_lcd_vol");
	level._effect["casino_vent_dust1"]	 		= loadfx ("maps/casino/casino_vent_dust1");
	level._effect["casino_vent_dust2"]	 		= loadfx ("maps/casino/casino_vent_dust2");	
	

	
	level._effect["casino_spa_wading_idle"]	 	= loadfx ("maps/casino/casino_spa_wading_idle");
	level._effect["casino_spa_wading"]	 		= loadfx ("maps/casino/casino_spa_wading");
	level._effect["casino_spa_foot_splash"]	 	= loadfx ("maps/casino/casino_spa_foot_splash");
	level._effect["casino_ballroom_panel"]	 	= loadfx ("maps/casino/ballroom_dest_panel");
	level._effect["casino_tank_explosion"]		= loadfx ("explosions/small_vehicle_explosion");
	
	level._effect["vehicle_night_headlight02"]	 	= loadfx ("vehicles/night/vehicle_night_headlight02");
	level._effect["vehicle_night_taillight"]	 	= loadfx ("vehicles/night/vehicle_night_taillight");
	
	
	level._effect["casino_glass_crack"]	 		= loadfx ("maps/casino/casino_glass_crack");
	level._effect["casino_electric_sparks"]	 	= loadfx ("maps/casino/casino_electric_sparks");
	level._effect["casino_knife_sparks"]	 	= loadfx ("maps/casino/casino_knife_sparks");
	level._effect["casino_knife_sparks2"]	 	= loadfx ("maps/casino/casino_knife_sparks2");
	
	level._effect["qkill_dust"] 				= loadfx("impacts/qkill_hit_dust");
	level._effect["qkill_dust2"] 				= loadfx("impacts/qkill_hit_dust2");
}

