#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_shg_fx;
#include maps\_shg_common;



main()
{
	
	//--------- EXPLODER INDEX -------//
	/*
	10-20, 30,31  = building slide moment.
	21-25 = heli crash into wall moment.
	100-105 = Escort sequence breach fx.
	110 = helicopter smoke swirl.
	115-117 = street rolling door fx.
	200 = Regroup gate breach fx.
	600 = street fires.
	700 = Slide sequence fires.
	701 - 710 = Slide sequence window explosions.
	711-720 = Tree Fall Fx (Slide sequence).
	900-950 = Building Slide Water Impact Dressings.
	950-970 = Building Slide Water Impact Offsets.
	1000's = MAARS Shed scripted fx.
	1500's = MAARS Shed breach fx.
	2000's = MAARS Shed scripted fx.
	3000's = MAARS Shed scripted fx.
	3101 & 3102 = MAARS Shed bombshake fx.
	5000 = GAMEPLAY - street ambient fx.
	5001 = GURNEY SCENE - street ambient fx.
	5002 = GAMEPLAY - street ambient fx after turn.
	5005 = disabled number for street fires.
	6000 = GAMEPLAY - MAARS Shed, MAARS Control, Slide sequences ambient fx.
	6001 = GURNEY SCENE - MAARS Shed, MAARS Control, Slide sequences ambient fx.
	7000 = GAMEPLAY - Courtyard, Escort sequences ambient fx.
	7001 = GURNEY SCENE - Courtyard, Escort sequences ambient fx.
	8000's = Courtyard scripted smoke/fires.
	9010 = river splashes
	9011 = player impact dust during slide sequence.
	9015 = second group of river splashes
	*/
	
	
	thread precacheFX();
	
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
	{
		maps\createfx\intro_fx::main();
		setup_shg_fx();
	}
		
	//gurney scene zones
	thread maps\_shg_fx::fx_zone_watcher(5001,"msg_fx_zone5_intro","msg_fx_zone5_1_intro");//street battle
	thread maps\_shg_fx::fx_zone_watcher(6001,"msg_fx_zone6_intro","msg_fx_zone6_1_intro");//street to shack and rover sequence
	thread maps\_shg_fx::fx_zone_watcher(7001,"msg_fx_zone7_intro","msg_fx_zone7_1_intro");//Compound sequence
	
	//gameplay zones
	thread maps\_shg_fx::fx_zone_watcher(5000,"msg_fx_zone5","msg_fx_zone5_1");//street battle
	thread maps\_shg_fx::fx_zone_watcher(5002,"msg_fx_zone5_2");//street battle 2nd street fx
	thread maps\_shg_fx::fx_zone_watcher(6000,"msg_fx_zone6","msg_fx_zone6_1");//street to shack and rover sequence
	thread maps\_shg_fx::fx_zone_watcher(7000,"msg_fx_zone7");//Compound sequence
	thread maps\_shg_fx::fx_zone_watcher(7050,"msg_fx_zone7_5");//Compound sequence, only shows up when you leave heli crash room

	//commented this out as it was beig called after waitframe, thus turning all the triggers off.
	//thread setup_intro_fxzones();
		
	thread maars_hide_building();
	thread init_smVals();
	thread treadfx_override();
	thread maars_shed_bombshake1();
	thread maars_shed_bombshake2();
	thread escort_turnoff_dlights();
	flag_init("fx_maars_hud_up");
		
}

escort_turnoff_dlights()
{
	for(;;)
	{
		level waittill( "fx_zone_5000_activating" );
		if ( level.Console )
		{
			setsaveddvar("r_dlightlimit",1);
		}

		level waittill( "fx_zone_5000_deactivating" );
		if ( level.Console )
		{
			setsaveddvar("r_dlightlimit",4);
		}
	}
	
}


init_smVals()
{
	//Set the initial shadow values
	//setsaveddvar("sm_spotlimit",1);
	//setsaveddvar("sm_sunshadowscale",.85);
	//setsaveddvar("sm_sunsamplesizenear",.25);
	setsaveddvar("fx_alphathreshold",11);
//	setsaveddvar("r_specularcolorscale",.25);
}

setup_intro_fxzones()
{
	waitframe();
	
	triggers = ["msg_fx_zone5", "msg_fx_zone5_1", "msg_fx_zone6", "msg_fx_zone6_1", "msg_fx_zone7"];
	foreach (trigger in triggers)
	{
		introTriggers = GetEntArray( (trigger + "_intro"), "targetname" );
		foreach(zone_trigger in introTriggers)
		{
			if (IsDefined(zone_trigger))
				zone_trigger trigger_off();
		}
	}
}	

enable_gurney_fxzones()
{
	gameplay_triggers = ["msg_fx_zone5", "msg_fx_zone5_1", "msg_fx_zone6", "msg_fx_zone6_1", "msg_fx_zone7"];
	foreach (trigger in gameplay_triggers)
	{
		gpTriggers = GetEntArray( trigger, "targetname" );
		introTriggers = GetEntArray( (trigger + "_intro"), "targetname" );
		//iprintlnbold (trigger + "_intro");
		foreach(zone_trigger in introTriggers)
		{
			if (IsDefined(zone_trigger))
				zone_trigger trigger_on();
		}
		foreach(zone_trigger in gpTriggers)
		{
			if (IsDefined(zone_trigger))
				zone_trigger trigger_off();
	}
}	
}	
		
enable_gameplay_fxzones()
{
	gameplay_triggers = ["msg_fx_zone5", "msg_fx_zone5_1", "msg_fx_zone6", "msg_fx_zone6_1", "msg_fx_zone7"] ;
	foreach (trigger in gameplay_triggers)
	{
		gpTriggers = GetEntArray( trigger, "targetname" );
		introTriggers = GetEntArray( (trigger + "_intro"), "targetname" );
		foreach(zone_trigger in introTriggers)
		{
			if (IsDefined(zone_trigger))
				zone_trigger trigger_off();
}
		foreach(zone_trigger in gpTriggers)
		{
			if (IsDefined(zone_trigger))
				zone_trigger trigger_on();
		}
}	
}	

treadfx_override()
{
	wait(0.025);
	//fx = "treadfx/pb_jeep_trail_road_skid_long";
	fx = "treadfx/tread_dust_default_small";
	water_fx = "treadfx/tread_water_small";
	vehicletype_fx[0] = "script_vehicle_ugv_robot";
	vehicletype_fx[1] = "script_vehicle_80s_sedan1_brn";
	vehicletype_fx[2] = "script_vehicle_80s_hatch1_brn_destructible_mp";
	
	foreach(vehicletype in vehicletype_fx)
	{
		maps\_treadfx::setvehiclefx( vehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paper", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plaster", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "water", water_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( vehicletype, "none" );
	}
	//helicopter tread fx
	/*helivehicletypefx[0] = "script_vehicle_littlebird_bench";
	helivehicletypefx[1] = "script_vehicle_mi17_woodland_fly";
	fx = "treadfx/heli_dust_paris";
	
	foreach(helivehicletype in helivehicletypefx)
	{
		maps\_treadfx::setvehiclefx( helivehicletype, "brick", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "bark", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "carpet", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "cloth", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "concrete", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "dirt", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "flesh", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "foliage", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "glass", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "grass", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "gravel", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "ice", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "metal", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "mud", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "paper", fx );
	  maps\_treadfx::setvehiclefx( helivehicletype, "plaster", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "rock", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "sand", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "snow", fx );
	 //	maps\_treadfx::setvehiclefx( helivehicletype, "water", water_fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "wood", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "asphalt", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "ceramic", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "plastic", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "rubber", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "cushion", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "fruit", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "paintedmetal", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "riotshield", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "slush", fx );
	 	maps\_treadfx::setvehiclefx( helivehicletype, "default", fx );
		maps\_treadfx::setvehiclefx( helivehicletype, "none" );
	}*/
	
}

play_soap_blood_fx()
{
	org1 = spawn_tag_origin();
	org1 linkto(level.soap, "J_Collar", (0,0,0), (0, 270, 0));
	playfxontag(getfx("blood_drip_table_soap"), org1, "tag_origin");
	
	/*org2 = spawn_tag_origin();
	org2 linkto(level.soap, "J_Spine4", (1.5,5,-2.5), (0, 90, 0));
	playfxontag(getfx("blood_chest_wound"), org2, "tag_origin");*/
	playfxontag(getfx("blood_cough"), level.soap, "J_Jaw");
	
	level waittill("msg_soap_stop_bleeding");
	stopfxontag(getfx("blood_drip_table_soap"), org1, "tag_origin");
	//stopfxontag(getfx("blood_chest_wound"), org2, "tag_origin");
	org1 delete();
	//org2 delete();
}


run_tree_fall_fx(tree)
{
	exploder(711);
	level waitframe();
	exploder(716);
	level waitframe();
	exploder(718);
	playfxontag(getfx("intro_slide_trail_parent"),tree,"destroyed_top_branch5A");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),tree,"middle_branch3A");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),tree,"destroyed_top_branch8B");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),tree,"destroyed_top_branch1B");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),tree,"destroyed_top_branch9A");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),tree,"destroyed_top_branch21B");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),tree,"destroyed_top_branch11A");
	wait(.85);
	exploder(713);
	wait(.1);
	exploder(714);
	wait(.7);
	exploder(712);
	wait(.0);
	exploder(715);
	wait(0.0);
	exploder(717);
}

intro_regroup_doorfx()
{
	wait(.85);
	exploder(115);
	wait(.9);
	exploder(117);
	wait(.18);
	exploder(116);
}

intro_heliswirl()
{
	wait(8.0);
	exploder(110);
	wait(.85);
	exploder(110);
	wait(.65);
	exploder(110);
	wait(1.5);
	exploder(110);
	wait(1.0);
	exploder(110);
	wait(.65);
	exploder(110);
	wait(.85);
	exploder(110);
	wait(1.0);
	exploder(110);
	wait(.5);
	exploder(110);
	wait(1.8);
	exploder(110);
	wait(.7);
	exploder(110);
	wait(.65);
	exploder(110);
	wait(.85);
	exploder(110);
	wait(1.0);
	exploder(110);
	wait(0.5);
	exploder(110);
	wait(1.0);
	exploder(110);
	wait(.8);
	exploder(110);
	wait(.65);
	exploder(110);
	wait(.85);
	exploder(110);
}

price_pistolfire(guy)
{
	breacher1_spawn = getent( "escort_help_soap_breacher1", "targetname" );
	
	playfxontag(getfx("pistolflash"), guy, "tag_flash");
	playfxontag(getfx("headshot"), guy, "tag_flash");

	//blood smear fx
	exploder(106);
}

maars_control_smk_grenade()
{
	wait(0.0);
	exploder(9000);
	wait(0.1);
	exploder(9001);
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
	}
	wait 20;
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( false );
	}
}

courtyard_heli_smoke()
{
	//stage_1
	wait(.1);
	exploder(8001);
	//stage_2
	wait(1.0);
	exploder(8000);
}

courtyard_heli_impacts()
{
	wait(2.58);
	exploder(8018);
	wait(.1);
	exploder(8019);
	wait(.1);
	exploder(8020);
	wait(.1);
	exploder(8021);
	wait(.1);
	exploder(8022);
	wait(.1);
	exploder(8023);
	wait(.1);
	exploder(8024);
	wait(.1);
	exploder(8025);
	wait(.1);
	exploder(8026);
	wait(.1);
	exploder(8027);
	wait(.1);
	exploder(8028);
}

courtyard_heli_explode()
{
	wait(0.0);
	exploder(8011);
	wait(4.0);
	exploder(8010);
	wait(1.0);
	exploder(8012);
	wait(1.0);
	exploder(8013);
}

courtyard_brick_impacts(cover_object)
{
	wait(0.0);
	exploder(8030);
}

enemies_compound_door_breach()
{
	exploder(105);
}

regroup_price_gate_breach()
{
	wait(0.1);
	exploder(200);
}

regroup_car_skid(car)
{
	
	
	left_wheel_tag_ent = spawn_tag_origin();
	left_wheel_tag_ent.origin = car gettagorigin("tag_wheel_back_left");
	left_wheel_tag_ent.angles = vectortoangles((0,0,1));
	left_wheel_tag_ent linkto(car, "tag_wheel_back_left");
	
	right_wheel_tag_ent = spawn_tag_origin();
	right_wheel_tag_ent.origin = car gettagorigin("tag_wheel_back_right");
	right_wheel_tag_ent.angles = vectortoangles((0,0,1));
	right_wheel_tag_ent linkto(car, "tag_wheel_back_right");
	
	//wait(2.0);
	playfxontag(getfx("pb_jeep_trail_road_skid_long"),left_wheel_tag_ent,"tag_origin");
	playfxontag(getfx("pb_jeep_trail_road_skid_long"),right_wheel_tag_ent,"tag_origin");
}

/*maars_ugv_dust(price)
{
	exploder(3002);
}

maars_crate_door_openfx(crate_door)
{
	exploder(3000);
	
}

maars_crate_door_impactfx(crate_door)
{
	exploder(3001);
}*/

regroup_end_door_01_breachfx()
{
	wait(0.45);
	exploder(1500);
}

regroup_end_door_02_breachfx()
{
	wait(1.75);
	exploder(1501);
	wait(0.2);
	exploder(1502);
}


maars_shed_bombshake1()
{
	level waitframe();
	if(!flag_exist("fx_shed_bombshake1")) flag_init("fx_shed_bombshake1");
	for(;;)
	{
		flag_wait("fx_shed_bombshake1");
		wait(3);
		exploder(3101);
		flag_waitopen("fx_maars_hud_up");
		aud_send_msg("intro_shed_bombshake_01");
		level.player playrumbleonentity( "artillery_rumble" );
		screenshake(.55,.75,.21,.21);
		//iprintlnbold("bomb1");
		waittime = randomint(7);
		wait(waittime);
	}
}


maars_shed_bombshake2()
{
	level waitframe();
	if(!flag_exist("fx_shed_bombshake2")) flag_init("fx_shed_bombshake2");
	for(;;)
	{
		flag_wait("fx_shed_bombshake2");
		wait(5);
		//iprintlnbold("bomb2");
		flag_waitopen("fx_maars_hud_up");
		exploder(3102);
		aud_send_msg("intro_shed_bombshake_02");
		level.player playrumbleonentity( "artillery_rumble" );
		screenshake(.55,.75,.21,.21);
		waittime = randomint(7);
		wait(waittime);
	}
}

maars_trap_door_openfx(trap_door)
{
	wait(.05);
	exploder(2000);
	kill_exploder(600);
	kill_exploder(666);  //fire on building hit by UAV missile
	kill_exploder(5000);
	kill_exploder(8000);
}

maars_trap_door_impactfx(trap_door)
{
	exploder(2001);
	wait(0.025);
	exploder(2004);
	wait(0.025);
	//screenshake(.05,.3,.1,.1);
	wait(0.1);
	exploder(2002);
	wait(0.125);
	exploder(2003);
	
	wait(13.1);
	
	//crate door fx + ugv dust fx
	exploder(3000);
	wait(1.05);
	exploder(3001);
	wait(2.1);
	exploder(3002);
}

maars_rolling_door_openfx(rolling_door)
{
	intro_rollingdoor_card_ent = spawn_tag_origin();
	intro_rollingdoor_card_ent.origin = rolling_door gettagorigin("doorsegment1");
	intro_rollingdoor_card_ent.angles = vectortoangles((1,0,.8));
	intro_rollingdoor_card_ent linkto(rolling_door, "doorsegment1");
	playfxontag(getfx("lights_reveal_intro_oriented"),intro_rollingdoor_card_ent,"tag_origin");
	exploder(1000);
	wait(.05);
	exploder(1001);
	wait(0.0);
	//exploder(1004);
	wait(.7);
	exploder(1005);
	wait(.87);
	exploder(1002);
	wait(.18);
	exploder(1003);
	//exploder(1006);
	//wait(10);
	//card_ent delete();
	//turning off all the dlights in this section
	if ( level.Console )
	{
		setsaveddvar("r_dlightlimit",0);
	}
	
}

price_compound_door_breach()
{
	wait(0.55);
	exploder(100);
}

slide_window_explosions()
{
	wait(1.1);
	//exploder(710);
	wait(.1);
	//exploder(702);
	wait(.2);
	exploder(709);
	wait(.08);
	exploder(709);
	wait(.5);
	exploder(703);
	wait(.15);
	//exploder(701);
	wait(2.0);
	exploder(705);
	wait(.30);
	exploder(706);
	thread maps\intro_fx::maars_do_hit_contrast();
}

slide_window_fires_explosions()
{
	/*wait(6.0);
  exploder(707);
	wait(.1);
	exploder(708);
	wait(.05);
	wait(1.0);
	exploder(707);
	wait(.1);
	exploder(708);
	wait(.05);
	wait(3.3);
	exploder(707);
	wait(.1);
	exploder(708);
	wait(.05);
	wait(1.1);
	exploder(707);
	wait(.1);
	exploder(708);
	wait(.05);
	wait(1.0);
	exploder(707);
	wait(.1);
	exploder(708);
	wait(.05);
	wait(5.0);
	exploder(707);
	wait(.1);
	exploder(708);
	wait(.05);
	wait(1.0);
	exploder(707);
	wait(.1);
	exploder(708);
	wait(.05);
	wait(1.3);
	exploder(707);
	wait(.1);
	exploder(708);
	wait(4.0);*/
}

pine_impacts()
{
	wait(7.4);
  //exploder(800);
  exploder(804);
  wait(.3);
  exploder(801);
  //exploder(805);
  wait(.3);
  exploder(815);
  //exploder(802);
  //exploder(805);
  wait(.5);
  exploder(803);
  //exploder(800);
  wait(.4);
  //exploder(815);
  //exploder(804);
  //exploder(802);
  wait(.3);
  //exploder(805);
  //exploder(801);
  exploder(800);
  wait(2.5);
  exploder(815);
  wait(.65);
  exploder(800);
  exploder(804);
  //exploder(802);
  wait(.2);
  exploder(805);
}

street_fires_vfx()
{
	exploder(600);
}

slide_fires()
{
  exploder(700);
}

slide_fires_kill()
{
	kill_exploder(700);
}

slide_player_dust_hands(player_rig)
{
	slide_hand_dust_l_ent = spawn_tag_origin();
	slide_hand_dust_l_ent.origin = player_rig gettagorigin("J_WristTwist_LE");
	slide_hand_dust_l_ent.angles = vectortoangles((0,0,0));
	slide_hand_dust_l_ent linkto(player_rig, "J_WristTwist_LE");
	
	slide_hand_dust_r_ent = spawn_tag_origin();
	slide_hand_dust_r_ent.origin = player_rig gettagorigin("J_WristTwist_RI");
	slide_hand_dust_r_ent.angles = vectortoangles((0,0,0));
	slide_hand_dust_r_ent linkto(player_rig, "J_WristTwist_RI");
	
	wait(2.90);
	
	playfxontag(getfx("intro_slide_trail_parent_small_2"),slide_hand_dust_r_ent,"tag_origin");
	level waitframe();
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent_small"),slide_hand_dust_l_ent,"tag_origin");
	
	wait(2.923);
	exploder(9011);
	wait(5.0);
	exploder(9010);
	wait(6.5);
	kill_exploder(9010);
	exploder(9015);
}

slide_player_dust(player_legs)
{
	/*slide_kick_dust_l_ent = spawn_tag_origin();
	slide_kick_dust_l_ent.origin = player_legs gettagorigin("J_ToeEND_LE");
	slide_kick_dust_l_ent.angles = vectortoangles((1,1,1));
	slide_kick_dust_l_ent linkto(player_legs, "J_ToeEND_LE");
	//playfxontag(getfx("dust_boot_scrape_intro"),slide_kick_dust_l_ent,"tag_origin");
	
	slide_kick_dust_r_ent = spawn_tag_origin();
	slide_kick_dust_r_ent.origin = player_legs gettagorigin("J_ToeEND_RI");
	slide_kick_dust_r_ent.angles = vectortoangles((1,1,1));
	slide_kick_dust_r_ent linkto(player_legs, "J_ToeEND_RI");
	//playfxontag(getfx("dust_boot_scrape_intro"),slide_kick_dust_r_ent,"tag_origin");
	
	//wait(0.0);
	//stopfxontag(getfx("dust_boot_scrape_intro"),slide_kick_dust_l_ent,"tag_origin");
	//stopfxontag(getfx("dust_boot_scrape_intro"),slide_kick_dust_r_ent,"tag_origin");*/
	
	/*wait(3.15);
	playfxontag(getfx("dust_boot_scrape_intro"),slide_kick_dust_l_ent,"tag_origin");
	playfxontag(getfx("dust_boot_scrape_intro"),slide_kick_dust_r_ent,"tag_origin");
	
	wait(2.35);
	stopfxontag(getfx("dust_boot_scrape_intro"),slide_kick_dust_l_ent,"tag_origin");
	stopfxontag(getfx("dust_boot_scrape_intro"),slide_kick_dust_r_ent,"tag_origin");*/
}

slide_tree_rotates()
{
	slide_tree_rotate01 = getent("landslide_tree01", "targetname");
	slide_tree_rotate02 = getent("landslide_tree02", "targetname");
	slide_tree_rotate03 = getent("landslide_tree03", "targetname");
	slide_tree_rotate07 = getent("landslide_tree07", "targetname");
	slide_tree_origin02 = getent("landslide_tree02_origin", "targetname");
	slide_tree_origin03 = getent("landslide_tree03_origin", "targetname");
	slide_tree_origin07 = getent("landslide_tree07_origin", "targetname");
	slide_tree_rotate02 linkto(slide_tree_origin02);
	slide_tree_rotate03 linkto(slide_tree_origin03);
	slide_tree_rotate07 linkto(slide_tree_origin07);
	
	wait(8.0);
	slide_tree_origin07 RotateTo( slide_tree_origin07.angles + ( -80, 0, 0 ), 2.2, .5, 0 );
	wait(0.6);
	exploder(853);
	wait(0.1);
	exploder(854);
	
	
	wait(0.5);
	slide_tree_rotate01 RotateTo( slide_tree_rotate01.angles + ( .5, 0, -.5 ), .2, .1, .1 );
	wait(.22);
	slide_tree_rotate01 RotateTo( slide_tree_rotate01.angles + ( -.5, 0, .5 ), .1, .05, .05 );
	wait(1.8);
	slide_tree_rotate01 RotateTo( slide_tree_rotate01.angles + ( .5, 0, -.5 ), .2, .1, .1 );
	wait(.2);
	slide_tree_rotate01 RotateTo( slide_tree_rotate01.angles + ( -120, 0, 15 ), 3.2, .5, 0 );
	wait(0.6);
	exploder(852);
	wait(0.1);
	exploder(851);
	
	wait(0.9);
	slide_tree_origin03 RotateTo( slide_tree_origin03.angles + ( 0, 0, -80 ), 1.5, .5, 0 );
	wait(0.40);
	slide_tree_origin02 RotateTo( slide_tree_origin02.angles + ( 100, 0, 45 ), 1.0, .65, 0 );
	wait(1.0);
	slide_tree_origin02 RotateTo( slide_tree_origin02.angles + ( -20.0, 0, 0 ), .3, 0, .15 );
	wait(0.31);
	slide_tree_origin02 RotateTo( slide_tree_origin02.angles + ( 20, 0, 0 ), .7, .7, .0 );
	wait(0.1);
	exploder(850);
}

slide_splashes(water_heater)
{
	/*water_heater_fx_ent = spawn_tag_origin();
	water_heater_fx_ent.origin = water_heater gettagorigin("TAG_ORIGIN");
	water_heater_fx_ent.angles = vectortoangles((1,1,1));
	water_heater_fx_ent linkto(water_heater, "TAG_ORIGIN");*/
	
	wait(18.585);
	exploder(953);
	
}
	
slide_splashes_dressings()
{
	//THE ROILS
	wait(16.80);
	exploder(901);
	wait(.4);
	wait(.1);
	exploder(902);
	wait(.4);
	//exploder(900);
	wait(.1);
	exploder(904);
	wait(.2);
	exploder(905);
}

slide_splashes_initial(roof_shards1_ent, roof_shards2_ent, roof_subfloor_ent)
{
	//THE OFFSET SPLASHES
	
	/*splash_ring_94_ent = spawn_tag_origin();
	splash_ring_94_ent.origin = roof_shards1_ent gettagorigin("tag_fx_94");
	splash_ring_94_ent.angles = (0,0,180);
	splash_ring_94_ent linkto(roof_shards1_ent, "tag_fx_94");
	
	splash_ring_125_ent = spawn_tag_origin();
	splash_ring_125_ent.origin = roof_shards1_ent gettagorigin("tag_fx_95");
	splash_ring_125_ent linkto(roof_shards1_ent, "tag_fx_95");
	
	splash_ring_125_ent = spawn_tag_origin();
	splash_ring_125_ent.origin = roof_shards1_ent gettagorigin("tag_fx_68");
	splash_ring_125_ent linkto(roof_shards1_ent, "tag_fx_68");
	
	splash_ring_125_ent = spawn_tag_origin();
	splash_ring_125_ent.origin = roof_shards1_ent gettagorigin("tag_fx_118");
	splash_ring_125_ent linkto(roof_shards1_ent, "tag_fx_118");
	
	splash_ring_125_ent = spawn_tag_origin();
	splash_ring_125_ent.origin = roof_shards2_ent gettagorigin("tag_fx_174");
	splash_ring_125_ent linkto(roof_shards2_ent, "tag_fx_174");

	splash_ring_125_ent = spawn_tag_origin();
	splash_ring_125_ent.origin = roof_shards1_ent gettagorigin("tag_fx_134");
	splash_ring_125_ent linkto(roof_shards1_ent, "tag_fx_134");*/
	
	
	
	wait(13.55);
	
	wait(3.00);
	
	exploder(950);
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_94");
	level waitframe();
	level waitframe();
	
	
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_56");
	level waitframe();
	level waitframe();
	wait(0.0);
	wait(0.05);
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_95");
	level waitframe();
	level waitframe();
	wait(0.47);
	exploder(956);
	wait(0.00);
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_91");
	level waitframe();
	//exploder(956);
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_143");
	level waitframe();
	//wait(0.25);
	exploder(951);
	//playfxontag(getfx("splash_intro_initial"),roof_subfloor_ent,"tag_fx_10");
	level waitframe();
	level waitframe();
	wait(0.05);
	exploder(955);
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_97");
	level waitframe();
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_72");
	level waitframe();
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_71");
	level waitframe();
	//playfxontag(getfx("splash_intro_initial"),roof_shards1_ent,"tag_fx_57");
	level waitframe();
	
	wait(0.67);
	
	//wait(0.12);
	exploder(952);
	//playfxontag(getfx("body_splash_intro"),roof_shards2_ent,"tag_fx_174");
	level waitframe();
	level waitframe();
	wait(0.118);
	exploder(954);
	//playfxontag(getfx("body_splash_intro"),roof_shards2_ent,"tag_fx_154");
	level waitframe();
	wait(0.02);
	//playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_78");
	level waitframe();
	//playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_118");
	
	wait(0.00);
	level waitframe();
	//playfxontag(getfx("body_splash_intro_delay"),roof_shards1_ent,"tag_fx_134");
	level waitframe();
	//playfxontag(getfx("body_splash_intro_delay"),roof_shards1_ent,"tag_fx_125");
	level waitframe();
	
	wait(0.05);
	//playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_68");
	level waitframe();
	
	wait(0.1);
	//playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_88");
	level waitframe();
}

slide_splashes_chunks_trails(roof_shards1_ent, roof_shards2_ent, roof_subfloor_ent, roof_replaceshards_ent)
{
	//THE TRAILS
	chunk_trail_125_ent = spawn_tag_origin();
	chunk_trail_125_ent.origin = roof_replaceshards_ent gettagorigin("tag_replaceProp_4");
	chunk_trail_125_ent linkto(roof_replaceshards_ent, "tag_replaceProp_4");
	
	chunk_trail_95_ent = spawn_tag_origin();
	chunk_trail_95_ent.origin = roof_shards1_ent gettagorigin("tag_fx_95");
	chunk_trail_95_ent linkto(roof_shards1_ent, "tag_fx_95");
	
	chunk_trail_68_ent = spawn_tag_origin();
	chunk_trail_68_ent.origin = roof_shards1_ent gettagorigin("tag_fx_68");
	chunk_trail_68_ent linkto(roof_shards1_ent, "tag_fx_68");
	
	chunk_trail_118_ent = spawn_tag_origin();
	chunk_trail_118_ent.origin = roof_replaceshards_ent gettagorigin("tag_replaceProp_9");
	chunk_trail_118_ent linkto(roof_replaceshards_ent, "tag_replaceProp_9");
	
	chunk_trail_174_ent = spawn_tag_origin();
	chunk_trail_174_ent.origin = roof_shards2_ent gettagorigin("tag_fx_174");
	chunk_trail_174_ent linkto(roof_shards2_ent, "tag_fx_174");

	chunk_trail_134_ent = spawn_tag_origin();
	chunk_trail_134_ent.origin = roof_shards1_ent gettagorigin("tag_fx_134");
	chunk_trail_134_ent linkto(roof_shards1_ent, "tag_fx_134");
	
	
	wait(15.60);
	playfxontag(getfx("intro_slide_trail_parent"),chunk_trail_125_ent,"tag_origin");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),chunk_trail_95_ent,"tag_origin");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),chunk_trail_68_ent,"tag_origin");
	level waitframe();
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),chunk_trail_118_ent,"tag_origin");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),chunk_trail_174_ent,"tag_origin");
	level waitframe();
	playfxontag(getfx("intro_slide_trail_parent"),chunk_trail_134_ent,"tag_origin");
}


slide_splashes_chunks(roof_shards1_ent, roof_shards2_ent, roof_subfloor_ent, roof_replaceshards_ent)
{
	//THE BASE SPLASHES
	wait(13.60);
	
	wait(3.00);
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_94");
	level waitframe();
	level waitframe();
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_56");
	level waitframe();
	level waitframe();
	wait(0.0);
	wait(0.05);
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_95");
	level waitframe();
	level waitframe();
	wait(0.47);
	wait(0.00);
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_91");
	level waitframe();
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_143");
	level waitframe();
	
	playfxontag(getfx("body_splash_intro"),roof_subfloor_ent,"tag_fx_10");
	level waitframe();
	level waitframe();
	wait(0.05);
	playfxontag(getfx("body_splash_intro"),roof_replaceshards_ent,"tag_replaceProp_7");
	level waitframe();
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_72");
	level waitframe();
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_71");
	level waitframe();
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_57");
	level waitframe();
	
	wait(0.70);
	
	//wait(0.12);
	playfxontag(getfx("body_splash_intro_delay"),roof_shards2_ent,"tag_fx_174");
	level waitframe();
	level waitframe();
	wait(0.115);
	playfxontag(getfx("body_splash_intro"),roof_shards2_ent,"tag_fx_154");
	level waitframe();
	playfxontag(getfx("body_splash_intro"),roof_shards2_ent,"tag_fx_154");
	level waitframe();
	playfxontag(getfx("body_splash_intro"),roof_shards2_ent,"tag_fx_154");
	level waitframe();
	wait(0.01);
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_78");
	level waitframe();
	playfxontag(getfx("body_splash_intro"),roof_replaceshards_ent,"tag_replaceProp_9");
	
	wait(0.00);
	level waitframe();
	playfxontag(getfx("body_splash_intro_delay"),roof_shards1_ent,"tag_fx_134");
	level waitframe();
	playfxontag(getfx("body_splash_intro_delay"),roof_replaceshards_ent,"tag_replaceProp_4");
	level waitframe();
	
	wait(0.05);
	playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_68");
	level waitframe();
	
	wait(0.1);
	//playfxontag(getfx("body_splash_intro"),roof_shards1_ent,"tag_fx_88");
	level waitframe();
	
}
	
slide_splashes_chunks_small(roof_small1_ent)
{
	wait(16.035);
	//playfxontag(getfx("body_splash_intro"),roof_small1_ent,"jo_go_6");
	level waitframe();
	level waitframe();
	wait(0.00);
	//playfxontag(getfx("body_splash_intro"),roof_small1_ent,"jo_go_30");
	level waitframe();
	level waitframe();
	wait(0.00);
	//playfxontag(getfx("body_splash_intro"),roof_small1_ent,"jo_go_15");
	level waitframe();
	level waitframe();
	wait(0.00);
	//playfxontag(getfx("body_splash_intro"),roof_small1_ent,"jo_go_17");
	level waitframe();
	level waitframe();
	wait(.55);
	//playfxontag(getfx("body_splash_intro"),roof_small1_ent,"jo_go_18");
	level waitframe();
	level waitframe();
}


maars_ugv_damage_state1(ugv)
{
	level waitframe();
	state1_tag = spawn_tag_origin();
	state1_tag.origin = ugv gettagorigin("tag_player");
	state1_tag.angles = ugv gettagangles("tag_player");
	level endon( "dismount_maars" );
	for(;;)
	{
		flag_wait("ugv_fxstate1");
		playfxontag(getfx("intro_ugv_state1"),ugv,"tag_player");
		flag_waitopen("ugv_fxstate1");
		stopfxontag(getfx("intro_ugv_state1"),ugv,"tag_player");
	}
}
maars_ugv_damage_state2(ugv)
{
	level waitframe();
	state2_tag = spawn_tag_origin();
	state2_tag.origin = ugv gettagorigin("tag_player");
	state2_tag.angles = ugv gettagangles("tag_player");
	level endon( "dismount_maars" );
	for(;;)
	{
		flag_wait("ugv_fxstate2");
		stopfxontag(getfx("intro_ugv_state2smoke"),ugv,"tag_player");
		playfxontag(getfx("intro_ugv_state2"),ugv,"tag_player");
		level waitframe();
		level waitframe();
		playfxontag(getfx("intro_ugv_state2smoke"),ugv,"tag_player");
		flag_waitopen("ugv_fxstate2");
		stopfxontag(getfx("intro_ugv_state2"),ugv,"tag_player");
		stopfxontag(getfx("intro_ugv_state2smoke"),ugv,"tag_player");
		level waitframe();
		level waitframe();
		playfxontag(getfx("intro_ugv_state2smoke"),ugv,"tag_player");
	}
}

maars_ugv_damage_death()
{
	thread maars_do_hit_contrast();
	//setblur(2, 0.325);
	wait .5;
	//setblur(0, 0.2);	
	playfxontag(getfx("intro_ugv_death"),self[2],"tag_weapon");

	if ( level.Console )
	{
		setsaveddvar("r_dlightlimit",4);
	}


}
maars_ugv_damagefx(ugv)
{
	level endon( "dismount_maars" );
	state_ratio = level.player.health/level.player.maxhealth;
	damage_amt = 0.0;
	flag_init("ugv_fxstate1");
	flag_init("ugv_fxstate2");
	thread maars_ugv_damage_state1(ugv);
	thread maars_ugv_damage_state2(ugv);
	for(;;)
	{
		current_dmg_alpha = level.player.maars_huds[ "damage_overlay" ].alpha;
		if(isalive(level.player) && damage_amt<current_dmg_alpha) damage_amt = current_dmg_alpha;
		else if(!isalive(level.player)) damage_amt = 1.0;
		if(damage_amt>.4) flag_set("ugv_fxstate2");
		else flag_clear("ugv_fxstate2");
		if(damage_amt>.05) flag_set("ugv_fxstate1");
		else flag_clear("ugv_fxstate1");
		wait(1.0);
		if(damage_amt>.4) damage_amt -= .0125;
		else damage_amt -= .025;
		damage_amt = clamp(damage_amt,0,1);

		//level waitframe();
	}
}


maars_hide_building()
{
	level waitframe();
	roof_shards1_ent = getent("intro_landslide_building_shards","targetname");
	roof_shards2_ent = getent("intro_landslide_building_shards2","targetname");
	roof_subfloor_ent = getent("intro_landslide_building_subfloor","targetname");
	roof_handkey_ent = getent("intro_landslide_building_handkey","targetname");
	anim_pos = GetStruct( "slide_roof_collapse", "targetname" );


	//scriptnode.angles = node.angles;
	roof_shards1_ent.animname = "landslide_building_roof";
	roof_shards1_ent setAnimTree();
	roof_shards2_ent.animname = "landslide_building_roof2";
	roof_shards2_ent setAnimTree();
	roof_subfloor_ent.animname = "landslide_building_subfloor";
	roof_subfloor_ent setAnimTree();
	roof_handkey_ent.animname = "landslide_building_handkey";
	roof_handkey_ent setAnimTree();
	ents = [roof_shards1_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_first_frame(ents,"intro_rooftop_collapse_sim_roof");
	ents2 = [roof_shards2_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_first_frame(ents2,"intro_rooftop_collapse_sim_roof2");
	ents3 = [roof_subfloor_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_first_frame(ents3,"intro_rooftop_collapse_sim_subfloor");
	ents4 = [roof_handkey_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_first_frame(ents4,"intro_rooftop_collapse_handkey");



	roof_shards1_ent hide();
	roof_shards2_ent  hide();
	roof_subfloor_ent  hide();
	roof_handkey_ent  hide();

	wait(.5);
	roof_small1_ents = getentarray("intro_landslide_small_01","targetname");
	roof_small2_ents = getentarray("intro_landslide_small_02","targetname");
	roof_small1_ent = roof_small1_ents[0];
	roof_small2_ent = roof_small2_ents[0];
	for(i=1;i<roof_small1_ents.size;i++)
	{
		if(isdefined(roof_small1_ents[i])) roof_small1_ents[i] delete();
		if(isdefined(roof_small2_ents[i])) roof_small2_ents[i] delete();
	}
	anim_pos = GetStruct( "slide_roof_collapse", "targetname" );
	roof_small1_ent.animname = "landslide_building_small_01";
	roof_small1_ent setAnimTree();
	roof_small2_ent.animname = "landslide_building_small_02";
	roof_small2_ent setAnimTree();

	ents5 = [roof_small1_ent,roof_small2_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos anim_first_frame(ents5,"intro_landslide_small");
	roof_small1_ent hide();
	roof_small2_ent hide();
	//brush_buildings = getentarray("slide_small_building_hide","targetname");
	//for(i=1;i<brush_buildings.size;i++)
	//{
	//	if(isdefined(brush_buildings[i])) brush_buildings[i] delete();
	//}

	//thread slide_splashes_chunks(roof_shards1_ent);
	//thread slide_splashes_chunks_small(roof_shards2_ent);


}


maars_do_hit_contrast()
{
	//Adding this wait in order to better synchronize flash with audio.
	//level thread screenshake(.4,.52,.13,.153);
	currVis = getdvar("vision_set_current");
	visionsetnaked("generic_flash",.2);
	wait(.1);
	visionsetnaked(currVis,.2);
}
maars_pointconstraint(ent,bone)
{
	//self should be the item being constrained
	while( isDefined( ent ) )
	{
		self.origin = ent gettagorigin(bone);
		level waitframe();
	}
}


/*maars_lerpsunlight(currlight,targetlight,time)
{
	currframe = 0;
	numframes = time*20;
	numframes_less = numframes - 1;
	while(currframe<(numframes))//since the server runs at 20fps
	{
		lerpsun = (targetlight-currlight)*(currframe/numframes_less);
		lerpsun += currlight;
		setsunlight(lerpsun[0],lerpsun[1],lerpsun[2]);
		currframe++;
		level waitframe();
	}
	setsunlight(targetlight[0],targetlight[1],targetlight[2]);
}



maars_buildingslide_moment_lighting()
{
	map_sunlight = getmapsunlight();	
	target_sunlight = vectornormalize((map_sunlight[0],map_sunlight[1],map_sunlight[2]))*3.25;
	curr_sunlight = (map_sunlight[0],map_sunlight[1],map_sunlight[2]);
	wait(4.0);
	//thread maars_lerpsunlight(curr_sunlight,target_sunlight,2.0);
	vision_set_fog_changes("intro_slide2",2);
	wait(2.0);
	vision_set_fog_changes("intro_slide3",2);
	//thread maars_lerpsunlight(target_sunlight,curr_sunlight,2.0);
	//wait(2.0);
	//resetsunlight();
	
	
}*/

maars_buildingslide_moment_killquake()
{
	self waittillmatch("single anim","slide_shake_end" );
	level.killslidequake = 1000;
	level notify("killslidequake");
	//print("killing quake");
}

maars_buildingslide_moment_quake()
{
	
	self waittillmatch("single anim","slide_shake_start" );
	self thread maars_buildingslide_moment_killquake();
	level.killslidequake = 0.0;
	pos = level.player.origin;
	rampup = 0.01;
	i = 0;
	duration = 3.5;
	elapsed_time = 0;
	ramp_time = 2.0;
	while(elapsed_time<duration && level.killslidequake==0)
	{
	mag = 0.0;//distance2d(pos,level.player.origin);
	scale = .35 * clamp(1.0-(mag/3000.00),0.01,1.0) * (rampup/ramp_time);
	waittime = randomfloat(1.0) * 8.0+ 1.0;
	earthquake( scale, waittime * .5, level.player.origin, 3000 );
	rampup = clamp(rampup + (waittime /  20),0.01,ramp_time);
	s_waittime = waittime / 20.00;
	wait(s_waittime);
	elapsed_time += s_waittime;
	}	
}
maars_buildingslide_heaterfx()
{
	self waittillmatch("single anim","heater_impact_1" );
	heaterpos =  level.fxwaterheater gettagorigin("tag_origin");
	playfx(getfx("intro_slide_heaterhit_dirt"),heaterpos-(0,0,30),(0,0,1),(-1,0,0));
	self waittillmatch("single anim","heater_impact_2" );
	heaterpos = level.fxwaterheater gettagorigin("tag_origin");
	playfx(getfx("intro_slide_heaterhit_dirt"),heaterpos-(0,0,30),(0,0,1),(-1,0,0));
	
}

maars_buildingslide_secondaryexp()
{
	self waittillmatch("single anim","chunk_impact" );//wait til frame 251
	exploder(17);//start gas fire
	wait(2.00);
	exploder(18);//secondary explosion	
	wait(1);
	exploder(19);//secondary explosion 2 : )
}


maars_buildingslide_launchbuildingprops()
{
	//identify the table & chairs & trashcan - and toss them
	props = getentarray( "small_building_toss", "targetname" );
	foreach( curr in props )
	{
		
		throw_vec = 750 * vectornormalize( curr.origin - ( -10230, 2276, -2000 ) );
		curr movegravity( throw_vec, 1.0 );
		curr rotatevelocity( (randomfloat(360), randomfloat(360), randomfloat(360) ), 2.0 );
		//curr physicslaunchclient( curr.origin, throw_vec );
	}
}

maars_buildingslide_herochunkfx()
{
	//self is the small building ent
	self waittillmatch("single anim","chunk_trail_start" );//wait til frame 251
	playfxontag(getfx("intro_slide_chunkTrail2"),self,"jo_go_52");	
	self waittillmatch("single anim","chunk_impact" );//wait til frame 251
	wait(.1);//wait 2 frames
	hit_pos = self gettagorigin("jo_go_52");
	playfx(getfx("intro_slide_chunkhit_dirt"),hit_pos,(0,0,1),(-1,1,0));
	//playfxontag(getfx("intro_slide_chunkTrail"),self,"jo_go_52");
	wait(1);
	stopfxontag(getfx("intro_slide_chunkTrail2"),self,"jo_go_52");
	
	thread maars_buildingslide_launchbuildingprops();
	
}
	
	
maars_buildingslide_dirtchunkfx()
{
	//wait til frame 314
	wait(10.47);
	hit_pos = self gettagorigin("tag_fx_80");
	playfx(getfx("intro_slide_chunkhit_dirt2"),hit_pos-(0,0,30),(0,0,1),(-1,1,0));
	//frame 328
	wait(.46);
	hit_pos = self gettagorigin("tag_fx_99");
	playfx(getfx("intro_slide_chunkhit_dirt"),hit_pos-(0,0,30),(0,0,1),(-1,1,0));
	
}

maars_buildingslide_moment_windows(ent2)
{
	//spawn the windowfx on the various joints
	//looking for these two break messages:
	//window_break_lrg1
	//window_break_lrg2
	//tag_fx_windowsm1-3 -break on the initial hit
	playfxontag(getfx("intro_slide_housewindowlrg"),self,"tag_fx_windowlg1");
	level waitframe();
	playfxontag(getfx("intro_slide_housewindowlrg"),self,"tag_fx_windowlg2");
	playfxontag(getfx("intro_slide_housewindowlrg"),self,"tag_fx_windowlg3");
	level waitframe();
	playfxontag(getfx("intro_slide_housewindowsm"),self,"tag_fx_windowsm");
	playfxontag(getfx("intro_slide_housewindowsm"),self,"tag_fx_windowsm1");
	playfxontag(getfx("intro_slide_housewindowsm"),self,"tag_fx_windowsm2");
	playfxontag(getfx("intro_slide_housewindowsm"),self,"tag_fx_windowsm3");
	level waitframe();
	playfxontag(getfx("intro_slide_housewindowlrg"),self,"tag_fx_windowlg");
	level waitframe();
	
	//break the small windows on the initial impact
	self waittillmatch("single anim","small_building_impact" );
	stopfxontag(getfx("intro_slide_housewindowsm"),self,"tag_fx_windowsm");
	stopfxontag(getfx("intro_slide_housewindowsm"),self,"tag_fx_windowsm1");
	stopfxontag(getfx("intro_slide_housewindowsm"),self,"tag_fx_windowsm2");
	stopfxontag(getfx("intro_slide_housewindowsm"),self,"tag_fx_windowsm3");
	
	
	//tag_fx_windowlg breaks first
	self waittillmatch("single anim","window_break_lrg1" );
	playfxontag(getfx("intro_slide_housewindowlrg_exp"),self,"tag_fx_windowlg");
	level waitframe();
	stopfxontag(getfx("intro_slide_housewindowlrg"),self,"tag_fx_windowlg");
	//tag_fx_windowlg1-3 break second
	//self waittillmatch("single anim","window_break_lrg2" );
	wait(.4);
	playfxontag(getfx("intro_slide_housewindowlrg_exp"),self,"tag_fx_windowlg2");
	stopfxontag(getfx("intro_slide_housewindowlrg"),self,"tag_fx_windowlg2");
	wait(.35);
	playfxontag(getfx("intro_slide_housewindowlrg_exp"),self,"tag_fx_windowlg1");
	playfxontag(getfx("intro_slide_housewindowlrg_exp"),self,"tag_fx_windowlg3");
	level waitframe();
	stopfxontag(getfx("intro_slide_housewindowlrg"),self,"tag_fx_windowlg1");
	stopfxontag(getfx("intro_slide_housewindowlrg"),self,"tag_fx_windowlg3");
	
	
}

maars_buildingslide_smallhouse_crackdust()
{

	wait(9.3);
	//joint jo_go_42
	playfxontag(getfx("intro_slide_crackdust_smallhouse"),self,"jo_go_23");
	wait(.1);
	//joint jo_go_42
	playfxontag(getfx("intro_slide_crackdust_smallhouse"),self,"jo_go_73");
	exploder(30);
	wait(1);
	//joint jo_go_42
	playfxontag(getfx("intro_slide_crackdust_smallhouse"),self,"jo_go_42");
	playfxontag(getfx("intro_slide_crackdust_smallhouse"),self,"jo_go_23");
	
	wait(.6);
	//joint jo_go_33 -frame 330
	playfxontag(getfx("intro_slide_crackdust_smallhouse"),self,"jo_go_33");
	level waitframe();
	//joint jo_go_66 -frame 331
	playfxontag(getfx("intro_slide_crackdust_smallhouse"),self,"jo_go_66");
	level waitframe();
	//joint jo_go_86 -frame 332
	playfxontag(getfx("intro_slide_crackdust_smallhouse"),self,"jo_go_86");
	
}


maars_buildingslide_moment_househit()
{
	self waittillmatch("single anim", "small_building_impact");//wait(9.2);//frame 276
	exploder(15);//the initial house hit
	exploder(31);//crack dust from the top of the house
	//wait();//frame 
	playfxontag(getfx("intro_slide_housefall"),self,"jo_go_10");
	wait(1.5);
	exploder(16);//the debris shooting out after it falls
	
}

maars_crack_dust(ent1,ent2)
{
	//get tag origin
	tumble_tag = spawn_tag_origin();
	tumble_tag.origin = ent1 gettagorigin("tag_origin");
	tumble_tag.angles = ent1 gettagangles("tag_origin");
	//get ents to play crack dust on
	//joint tag_fx_103 & 104 -frame 0
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_103");
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_104");
	wait(.1);
	//joint tag_fx_101 & 97 -frame 3
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_101");
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_97");
	wait(.07);
	//joint tag_fx_86 -frame 7
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_86");
	//joint tag_fx_95 -frame 7
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_95");
	level waitframe();
	//joint tag_fx_90 -frame 8
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_90");
	level waitframe();
	level waitframe();
	level waitframe();
	//joint tag_fx_85 -frame 11
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_85");
	//joint tag_fx_91 -frame 11
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_91");
	//joint tag_fx_84 -frame 11
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_84");
	level waitframe();
	level waitframe();
	level waitframe();
	//joint tag_fx_90 -frame 14
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_84");
	wait(.2);
	//joint tag_fx_89 -frame 22
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_89");
	wait(2.4);//frame 94
	playfxontag(getfx("intro_slide_tumblerocks"),tumble_tag,"tag_origin");
	wait(1.86);//frame 150
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_104");
	wait(.56);//frame 167
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_86");
	wait(1.0);//frame 197
	playfxontag(getfx("intro_slide_crackdust"),ent1,"tag_fx_116");
	wait 10;
	tumble_tag delete();
}

maars_buildingslide_launchdynents()
{
	launch_org = self gettagorigin("tag_fx_83");
	launch_org += (0,0,-100);
	physicsexplosionsphere(launch_org,1000,100,3.0);
	//launch_ents = getentarray("intro_misc_launch","targetname");
	//foreach(curr in launch_ents)
	//{
	//	currpos = curr.origin;
	//	launch_vect = vectornormalize(currpos - launch_org);
	//	curr MoveGravity(launch_vect*300.5,.3);
	//}
}

maars_buildingslide_uavshadowsthread(ent,start_frame)
{
	waittime = start_frame/30.0;
	wait(waittime);
	//spwn_tag = spawn_tag_origin();
	spwn_tag1 = spawn_tag_origin();
	spwn_tag2 = spawn_tag_origin();
	f_vector = vectornormalize(anglestoforward(ent.angles));
	r_vector = vectornormalize(anglestoright(ent.angles));
	//spwn_tag.origin = ent gettagorigin("tag_origin")+f_vector*100;
	spwn_tag1.origin = ent gettagorigin("tag_origin")+r_vector*150+f_vector*50;
	spwn_tag2.origin = ent gettagorigin("tag_origin")+r_vector*-150+f_vector*50;
	//playfxontag(getfx("intro_slide_uavshadow"),spwn_tag,"tag_origin");
	playfxontag(getfx("intro_slide_uavshadow"),spwn_tag1,"tag_origin");
	playfxontag(getfx("intro_slide_uavshadow"),spwn_tag2,"tag_origin");
	for(i=0;i<50;i++)
	{
		f_vector = vectornormalize(anglestoforward(ent.angles));
		r_vector = vectornormalize(anglestoright(ent.angles));
		//spwn_tag.origin = ent gettagorigin("tag_origin")+f_vector*100;
		spwn_tag1.origin = ent gettagorigin("tag_origin")+r_vector*150+f_vector*50;
		spwn_tag2.origin = ent gettagorigin("tag_origin")+r_vector*-150+f_vector*50;
		level waitframe();
	}
	//stopfxontag(getfx("intro_slide_uavshadow"),spwn_tag,"tag_origin");
	//spwn_tag delete();
	stopfxontag(getfx("intro_slide_uavshadow"),spwn_tag1,"tag_origin");
	spwn_tag1 delete();
	stopfxontag(getfx("intro_slide_uavshadow"),spwn_tag2,"tag_origin");
	spwn_tag2 delete();

}

maars_buildingslide_chunkshadowsthread(ent,tag_name,start_frame)
{
	waittime = start_frame/30.0;
	wait(waittime);
	spwn_tag = spawn_tag_origin();
	spwn_tag.origin = ent gettagorigin(tag_name);
	playfxontag(getfx("intro_slide_chunkshadow"),spwn_tag,"tag_origin");
	for(i=0;i<50;i++)
	{
		spwn_tag.origin = ent gettagorigin(tag_name);
		level waitframe();
	}
	stopfxontag(getfx("intro_slide_chunkshadow"),spwn_tag,"tag_origin");
	spwn_tag delete();
	
}
maars_buildingslide_chunkshadows(replace_ent,shards2_ent)
{
	//start at frame 60
	//end at frame 95
	//tag_fx_85 - now "tag_replaceProp_15"
	//tag_fx_88
	//tag_fx_129
	//tag_fx_96 - now "tag_replaceProp_5"
	ents = [
	replace_ent,
	self,
	self,
	replace_ent,
	self,
	shards2_ent
	];
	tag_names = [
	"tag_replaceProp_15",
	"tag_fx_88",
	"tag_fx_129",
	"tag_replaceProp_5",
	"tag_fx_119",
	"tag_fx_160"
	];
	start_frames = [
	60,
	60,
	60,
	60,
	41,
	35
	];
	for(i=0;i<start_frames.size;i++)
	{
		thread maars_buildingslide_chunkshadowsthread(ents[i],tag_names[i],start_frames[i]);
	}
	
}

maars_buildingslide_missiletrail()
{
	//start at frame 7
	wait(.23);
	start_pos = (-11263,393,-0);
	end_pos = (-8452,2075,-784);
	trail_tag = spawn_tag_origin();
	trail_tag.origin = start_pos;
	playfxontag(getfx("intro_slide_missile_fakeTrail"),trail_tag,"tag_origin");
	trail_tag moveto(end_pos,.17);
}

maars_buildingslide_moment_propreplace(sub)
{
	parts = [
	"bc_military_tire05_big_fx_01",//1               
	"bc_military_tire05_big_fx_02", //2              
	"bc_military_tire05_big_fx_03",    //3           
	"machinery_cable_spool3_fx_01",     //4          
	"com_barrel_blue_rust_fx_01",            //5     
	"com_barrel_blue_rust_fx_02",               //6  
	"com_wagon_donkey_nohandle_fx_01",//7
	"com_pallet_destroyed_fx_01",        //8         
	"com_pallet_destroyed_fx_02",           //9      
	"ch_dinerboothchair_fx_01",                //10   
	"com_wheelbarrow_fx_01",                      //11
	//"com_wheelbarrow_fx_02",//12 - failed                      
	"com_junktire_fx_01",          //13               
	"com_junktire_fx_02",              //14           
	"junk_wheel_02_fx_01",                 //15       
	"junk_wheel_02_fx_02",                   //16     
	"intro_construction_pallet_bag_01_fx_01",//17
	//"intro_construction_pallet_bag_01_fx_02",//18 - failed
	"intro_construction_pallet_bag_01_fx_03",     //19
	"intro_construction_pallet_bag_01_fx_04",     //20
	"pb_lawnchair_red_fx_01",//21-failed                     
	"pb_lawnchair_red_fx_02",     //22                
	"pb_lawnchair_red_fx_03",         //23            
	"com_restaurantchair_2_fx_01"         //24       
	];
	//subfloor 0-55
	//roof1 56-149
	//roof2 154-221
	//handkey 
	bone_names = [
	"tag_fx_114",//1
	"tag_fx_86",//2
	"tag_fx_143",//3
	//"tag_fx_121",//4
	"tag_fx_125",//5
	"tag_fx_96",//6-60
	"tag_fx_127",//7-60
	"tag_fx_97",//8-90
	"jo_handkey_roofChunk_14",//9-160
	"tag_fx_118",//10-170
	"tag_fx_60",//11-200
	//"jo_handkey_roofChunk_12",//12-170
	"tag_fx_9",//13-6
	"tag_fx_98",//14-80
	"tag_fx_101",//15-90
	"tag_fx_85",//16-60
	"tag_fx_124",//17-65
	//"tag_fx_11",//18-30
	"tag_fx_180",//19-10
	"tag_fx_182",//20-100
	//"tag_fx_102",//21-110
	"tag_fx_179",//22-160
	"tag_fx_181",//23-100
	"tag_fx_137"//24-70
	];
	bone_names2 = [
		"tag_replaceProp_",//1
		"tag_replaceProp_1",//2
		"tag_replaceProp_2",//3
		"tag_replaceProp_3",//4
		"tag_replaceProp_4",//5
		"tag_replaceProp_5",//6
		"tag_replaceProp_6",//7
		"tag_replaceProp_7",//8
		"tag_replaceProp_8",//9
		"tag_replaceProp_9",//10
		"tag_replaceProp_10",//11
		//"tag_replaceProp_11",//12
		"tag_replaceProp_12",//13
		"tag_replaceProp_13",//14
		"tag_replaceProp_14",//15
		"tag_replaceProp_15",//16
		"tag_replaceProp_16",//17
		//"tag_replaceProp_17",//18
		"tag_replaceProp_18",//19
		"tag_replaceProp_19",//20
		"tag_replaceProp_20",//21
		"tag_replaceProp_21",//22
		"tag_replaceProp_22",//23
		"tag_replaceProp_23"//24
	];
	start_frames = [
	160,//1
	65,//2-used to be 65
	65,//3-used to be 65
	70,//4
	80,//5
	60,//6-used to be 60 - 104
	60,//7-used to be 60
	90,//8
	160,//9
	170,//10
	200,//11
	//170,//12
	6,//13
	80,//14
	90,//15
	60,//16
	65,//17
	//30,//18
	10,//19
	70,//20
	110,//21
	160,//22
	100,//23
	70//24
	];
	/*ents = [
	roof1,//1
	roof1,//2
	roof1,//3
	//roof1,//4
	roof1,//5
	roof1,//6
	roof1,//7
	roof1,//8
	handkey,//9
	roof1,//10
	roof1,//11
	//handkey,//12
	sub,//13
	roof1,//14
	roof1,//15
	roof1,//16
	roof1,//17
	//sub,//18
	roof2,//19
	roof2,//20
	//roof1,//21
	roof2,//22
	roof2,//23
	roof1//24
	];*/
	for(i=0;i<start_frames.size;i++)
	{
		thread replace_slide_part(parts[i],bone_names2[i],start_frames[i],sub);
	}
	wait((217.00/30.00));
	for(i=0;i<start_frames.size;i++)
	{
		part_ent = getent(parts[i],"targetname");
		if(isdefined(part_ent)) part_ent hide();
	}
	wait((140.00/30.00));
	for(i=0;i<start_frames.size;i++)
	{
		part_ent = getent(parts[i],"targetname");
		if(isdefined(part_ent)&&(i==0||i==1||i==7||i==13||i==16)) part_ent show();
	}
	
}

replace_slide_part(parts,bone_names,start_frames,sub)
{
	if(isdefined(sub)&&isdefined(bone_names))
	{
		
		part_ent = getent(parts,"targetname");
		if(isdefined(part_ent))
		{
			part_ent hide();
			part_ent.origin = sub gettagorigin(bone_names);
			part_ent linkto(sub,bone_names);
			wait(start_frames/30.00);
			//print("hiding "+bone_names+""+ents.targetname+"\n");
			sub hidepart(bone_names);
			part_ent show();
		}
		//else print("part_fail: "+parts);
	}
	//else print("ent_fail: "+parts);
}

maars_buildingslide_moment(hide_me, roof_brushes)
{
	
	foreach(roof in roof_brushes)
	{
		roof hide();
	}


	
	hide_bamboo = getentarray("intro_construction_support_poles01_hide","targetname");
	hide_brace = getentarray("intro_construction_ceiling_brace01_hide","targetname");
	hide_rails = getentarray("intro_railing_hide","targetname");
	hide_2x4 = getentarray("intro_landslide_2x4_hide","targetname");
	window_frame1 = getentarray("intro_window_frame_wide_construction_01_hide","targetname");
	window_frame2 = getentarray("intro_window_frame_wide_construction_02_hide","targetname");
	scaffold = getentarray("intro_construction_scaffold_top_hide","targetname");
	rebar = getentarray("intro_construction_rebar_row_01_hide","targetname");
	plywood = getentarray("intro_plywood_hide","targetname");
	misc = getentarray("intro_misc_hide","targetname");

	foreach(curr in hide_bamboo)
	{
		curr hide_notsolid();
	}
	foreach(curr in hide_brace)
	{
		curr hide_notsolid();
	}
	foreach(curr in hide_rails)
	{
		curr hide_notsolid();
	}
	foreach(curr in hide_2x4)
	{
		curr hide_notsolid();
	}
	foreach(curr in window_frame2)
	{
		curr hide_notsolid();
	}
	foreach(curr in window_frame1)
	{
		curr hide_notsolid();
	}
	foreach(curr in scaffold)
	{
		curr hide_notsolid();
	}

	foreach(curr in rebar)
	{
		curr hide_notsolid();
	}

	foreach(curr in plywood)
	{
		curr hide_notsolid();
	}

	foreach(curr in misc)
	{
		curr hide_notsolid();
	}

	//do the initial hit fx
	exploder(10);//The initial missile hit
	
	if ( !level.ps3 )
	{
		exploder(20);
	}

	


	//Start the chunk animation
	roof_shards1_ent = getent("intro_landslide_building_shards","targetname");
	roof_shards2_ent = getent("intro_landslide_building_shards2","targetname");
	roof_subfloor_ent = getent("intro_landslide_building_subfloor","targetname");
	roof_handkey_ent = getent("intro_landslide_building_handkey","targetname");
	roof_small1_ent = getent("intro_landslide_small_01","targetname");
	roof_small2_ent = getent("intro_landslide_small_02","targetname");
	roof_replaceshards_ent = getent("intro_landslide_building_replaceshards","targetname");
	anim_pos = GetStruct( "slide_roof_collapse", "targetname" );

	roof_shards1_ent show();
	roof_shards2_ent  show();
	roof_subfloor_ent show();
	roof_handkey_ent  show();

	//scriptnode.angles = node.angles;
	roof_shards1_ent.animname = "landslide_building_roof";
	roof_shards1_ent setAnimTree();
	roof_shards2_ent.animname = "landslide_building_roof2";
	roof_shards2_ent setAnimTree();
	roof_subfloor_ent.animname = "landslide_building_subfloor";
	roof_subfloor_ent setAnimTree();
	roof_handkey_ent.animname = "landslide_building_handkey";
	roof_handkey_ent setAnimTree();
	roof_small1_ent.animname = "landslide_building_small_01";
	roof_small1_ent setAnimTree();
	roof_small2_ent.animname = "landslide_building_small_02";
	roof_small2_ent setAnimTree();
	roof_replaceshards_ent.animname = "intro_landslide_building_replaceshards";
	roof_replaceshards_ent setAnimTree();
	
	ents = [roof_shards1_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_single(ents,"intro_rooftop_collapse_sim_roof");
	roof_shards1_ent delaycall( 8, ::hide );
	roof_shards1_ent delaycall( 12.4, ::show );
	
	ents2 = [roof_shards2_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_single(ents2,"intro_rooftop_collapse_sim_roof2");
	
	
	ents3 = [roof_subfloor_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_single(ents3,"intro_rooftop_collapse_sim_subfloor");
	
	ents4 = [roof_handkey_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_single(ents4,"intro_rooftop_collapse_handkey");
	
	ents5 = [roof_replaceshards_ent];
	anim_pos thread anim_single(ents5,"intro_rooftop_collapse_replaceshards");
	
	roof_small1_ent = getentarray("intro_landslide_small_01","targetname")[0];
	roof_small2_ent = getentarray("intro_landslide_small_02","targetname")[0];
	roof_small1_ent show();
	roof_small2_ent show();
	
	
	
	small_building_ents_tohide = getentarray("slide_small_building_hide","targetname");
	foreach(curr_ent in small_building_ents_tohide)
	{
		curr_ent hide();
	}
	
	ents5 = [roof_small1_ent,roof_small2_ent];//,roof_shards2_ent];//, roof_subfloor_ent, roof_handkey_ent];//, wave_disp_ent ];
	anim_pos thread anim_single(ents5,"intro_landslide_small");
	//roof_small1_ent delaycall( 11, ::hide );

	//Intial slide lighting
	thread maars_crack_dust(roof_shards1_ent,roof_shards2_ent);
	roof_shards1_ent thread maars_buildingslide_launchdynents();
	thread maars_do_hit_contrast();
	
	////thread maars_buildingslide_moment_lighting();
	thread maars_buildingslide_moment_propreplace(roof_replaceshards_ent);
	roof_shards1_ent thread maars_buildingslide_chunkshadows(roof_replaceshards_ent,roof_shards2_ent);
	roof_shards1_ent thread maars_buildingslide_dirtchunkfx();
	
	
	////roof_small2_ent thread maars_buildingslide_moment_quake();
	roof_small1_ent thread maars_buildingslide_moment_househit();
	roof_small2_ent thread maars_buildingslide_moment_windows(roof_small1_ent);
	roof_small2_ent thread maars_buildingslide_heaterfx();
	
	
	//Initiate hero chunk fx
	roof_small2_ent thread maars_buildingslide_herochunkfx();
	roof_small2_ent thread maars_buildingslide_secondaryexp();
	roof_small2_ent thread maars_buildingslide_smallhouse_crackdust();

	thread slide_splashes_chunks(roof_shards1_ent, roof_shards2_ent, roof_subfloor_ent, roof_replaceshards_ent);
	thread slide_splashes_chunks_trails(roof_shards1_ent, roof_shards2_ent, roof_subfloor_ent, roof_replaceshards_ent);
	thread slide_splashes_initial(roof_shards1_ent, roof_shards2_ent, roof_subfloor_ent);
	thread slide_splashes_chunks_small(roof_small1_ent);
	thread slide_splashes_dressings();
	
	//Initiate pine needle impacts
	thread pine_impacts();
	
	//setblur(2, 0.325);
	wait .5;
	//setblur(0, 0.2);	
	
	
	
	wait(1.7);
	exploder(12);//collapse dust
	exploder(13);//collapse dust left
	exploder(11);//Additional particle debris
	
	
	wait(3);

	if ( level.Console && level.ps3 )
	{
		SetHalfResParticles( true );
		setsaveddvar("r_triangleCull",0);
	}


	avalanche_tag = spawn_tag_origin();
	avalanche_tag.origin = level.player_rig gettagorigin("tag_origin");
	avalanche_tag.angles = (0,90,0)+vectortoangles(vectornormalize((-9667,1840,1330)-(-9528,1840,-1581)));
	//avalanche_tag linkto(level.player_rig,"tag_origin");
	avalanche_tag thread maars_pointconstraint(level.player_rig,"tag_origin");
	exploder(19);//fallingdebris_side
	wait(1.0);
	kill_exploder(13);
	wait(1.0);
	playfxontag(getfx("intro_slide_avalanche"),avalanche_tag,"tag_origin");
	
	//setblur(2, 0.325);
	wait 1;
	setblur(0, 0.2);	
	
	wait(.7);
	setblur(1, .325);
	wait .1;
	setblur(0, 0.2);
	
	wait(1.7);
	//wait(2.0);
	stopfxontag(getfx("intro_slide_avalanche"),avalanche_tag,"tag_origin");
	wait(1.0);

	if ( level.Console && level.ps3 )
	{
		SetHalfResParticles( false );
		setsaveddvar("r_triangleCull",1);
	}

	
	wait(3.0);
	//setblur(2, 0.325);
	if(isalive(level.player)) exploder(14);
	wait 3;
	setblur(0, 0.2);	
	
}

water_impact(guy)
{
	thread vision_set_fog_changes("intro_slide_water",0);
	//level.player thread waterfx();
	
	/*setblur(4, 0.325);
	wait 5;
	setblur(0, 0.2);*/
	
	PlayFxOnTag( getfx( "splash_underwater" ), level.player_rig, "tag_camera" );
	//PlayFxOnTag( getfx( "player_submerge" ), guy, "tag_origin" );
	level.player setwatersheeting( 1, 4 );
	
	//movement bubbles
	level endon( "msg_fx_player_surfaced" );
	PlayFxOnTag( getfx( "bubbles_player_hand" ), level.player_rig, "J_Wrist_LE" );
	PlayFxOnTag( getfx( "bubbles_player_hand" ), level.player_rig, "J_Wrist_RI" );
	while(true)
	{
		PlayFxOnTag( getfx( "underwater_player_bubbles" ), level.player_rig, "tag_camera" );
		wait 0.075;
	}
}

water_submerge(guy)
{
	wait 0.2;
	setsaveddvar("r_specularcolorscale", 2.5);
	PlayFxOnTag( getfx( "underwater_submerge_whiteout" ), level.player_rig, "tag_camera" );
	
	StopFxOnTag( getfx( "splash_player_hand" ), level.player_rig, "J_Wrist_LE" );
	StopFxOnTag( getfx( "splash_player_hand_R" ), level.player_rig, "J_Wrist_RI" );
	
	thread vision_set_fog_changes("intro_slide_water",0);
	//level.player thread waterfx();
	
	level.player setwatersheeting( 1, 4 );
	
	//movement bubbles
	level endon( "msg_fx_player_surfaced" );
	level notify("msg_fx_player_submerged");

	
	waitframe();
	PlayFxOnTag( getfx( "bubbles_player_hand" ), level.player_rig, "J_Wrist_LE" );
	PlayFxOnTag( getfx( "bubbles_player_hand" ), level.player_rig, "J_Wrist_RI" );
	while(true)
	{
		PlayFxOnTag( getfx( "underwater_player_bubbles" ), level.player_rig, "tag_camera" );
		wait 0.075;
	}
}

water_emerge(guy)
{
	thread vision_set_fog_changes("intro_slide_water_above",0);
	setsaveddvar("r_specularcolorscale", 4);
	//level.player thread waterfx();
	level notify("msg_fx_player_surfaced");
	//changed sheeting to 5 seconds so it doesn't overwrite vision set glow.
	level.player setwatersheeting( 1, 5 );
	level endon( "msg_fx_player_submerged" );
	StopFxOnTag( getfx( "bubbles_player_hand" ), level.player_rig, "J_Wrist_LE" );
	StopFxOnTag( getfx( "bubbles_player_hand" ), level.player_rig, "J_Wrist_RI" );
	
	PlayFxOnTag( getfx( "splash_player_hand" ), level.player_rig, "J_Wrist_LE" );
	PlayFxOnTag( getfx( "splash_player_hand_R" ), level.player_rig, "J_Wrist_RI" );
	
	level.player thread water_surface_wake("water_surface_wake");
}

water_emerge2(guy)
{
	thread vision_set_fog_changes("intro_slide_water_above",0);
	setsaveddvar("sm_spotlimit",0);
	setsaveddvar("sm_sunsamplesizenear", .05);
	setsaveddvar("sm_sunshadowscale", 1);
		
	setsaveddvar("r_specularcolorscale", 2.5);
	//level.player thread waterfx();
	level notify("msg_fx_player_surfaced");
	level.player setwatersheeting( 1, 6 );
	level endon( "msg_fx_player_submerged" );
	StopFxOnTag( getfx( "bubbles_player_hand" ), level.player_rig, "J_Wrist_LE" );
	StopFxOnTag( getfx( "bubbles_player_hand" ), level.player_rig, "J_Wrist_RI" );
	
	PlayFxOnTag( getfx( "splash_player_hand" ), level.player_rig, "J_Wrist_LE" );
	PlayFxOnTag( getfx( "splash_player_hand_R" ), level.player_rig, "J_Wrist_RI" );
	
	wait(1.0);
	
	StopFxOnTag( getfx( "splash_player_hand" ), level.player_rig, "J_Wrist_LE" );
	StopFxOnTag( getfx( "splash_player_hand_R" ), level.player_rig, "J_Wrist_RI" );
	//level.player thread water_surface_wake("water_surface_wake_calm");
}

stop_bubbles(guy)
{
	level notify("msg_fx_player_surfaced");
}

water_surface_wake(fx)
{
	level endon( "msg_fx_player_submerged" );
	speed = 200;
	tag_origin = spawn_tag_origin();
	for ( ;; )
	{
		/*//loop fx based off of player speed
		if (speed > 10)
			wait(max(( 1 - (speed / 120)),0.1) );
		else
			wait (0.15);
		//if ( trace[ "surfacetype" ] != "water" )
		//	continue;*/

		//fx = "water_surface_wake";
		/*
		if ( IsPlayer( self ) )
		{
			speed = Distance( self GetVelocity(), ( 0, 0, 0 ) );
			if ( speed < 10 )
			{
				fx = "";
			}
		}
		if ( IsAI( self ) )
		{
			speed = Distance( self.velocity, ( 0, 0, 0 ) );
			/*(if ( speed < 10 )
			{
				fx = "";
			}(
		}
	
		start = self.origin + ( 0, 0, 64 );
		end = self.origin - ( 0, 0, 150 );
		trace = BulletTrace( start, end, false, undefined );
		start = trace[ "position" ];
		angles = vectortoangles( trace[ "normal" ] );
		angles = (0,self.angles[1],0);
		forward = anglestoforward( angles );
		up = anglestoup( angles );*/
		cameraPos = level.player_rig GetTagOrigin("tag_camera");
		newPos = (cameraPos[0], cameraPos[1], -3688);
		if (fx != "")
		{
			water_fx = getfx( fx );
			//PlayFX( water_fx, start, up, forward );
			
			//PlayFX( water_fx, newPos, up, forward );
			tag_origin.origin = newPos;
			tag_origin.angles = (270,self.angles[1],0);
			playFXOnTag(water_fx, tag_origin, "tag_origin");
		}
		waitframe();
	}
}

exit_river_water(guy)
{
	//wait(2.0);
	//StopFxOnTag( getfx( "splash_player_hand" ), level.player_rig, "J_Wrist_LE" );
	//StopFxOnTag( getfx( "splash_player_hand_R" ), level.player_rig, "J_Wrist_RI" );
	level notify("msg_fx_player_submerged");
}

hand_surface_splash(guy)
{
	//play exploder for hand splash fx on river surface
	exploder(9090);
	
	handdrip_ent_l = spawn_tag_origin();
	handdrip_ent_l.origin = level.player_rig gettagorigin("J_Wrist_LE");
	handdrip_ent_l.angles = vectortoangles((0,0,1));
	handdrip_ent_l linkto(level.player_rig, "J_Wrist_LE");
	
	handdrip_ent_r = spawn_tag_origin();
	handdrip_ent_r.origin = level.player_rig gettagorigin("J_Wrist_RI");
	handdrip_ent_r.angles = vectortoangles((0,0,1));
	handdrip_ent_r linkto(level.player_rig, "J_Wrist_RI");
	
	wait(.5);
	playfxontag( getfx( "splash_player_hand_r_strong" ), handdrip_ent_l, "tag_origin" );
	playfxontag( getfx( "splash_player_hand_l_strong" ), handdrip_ent_r, "tag_origin" );
	wait(1.5);
	StopFxOnTag( getfx( "splash_player_hand_r_strong" ), handdrip_ent_l, "tag_origin" );
	wait(.2);
	StopFxOnTag( getfx( "splash_player_hand_l_strong" ), handdrip_ent_r, "tag_origin" );
	
	wait(1.1);
	playfxontag( getfx( "splash_player_hand_r_light" ), handdrip_ent_l, "tag_origin" );
	playfxontag( getfx( "splash_player_hand_r_light" ), handdrip_ent_r, "tag_origin" );
	level waitframe();
	playfxontag( getfx( "splash_player_hand_right_hand" ), handdrip_ent_r, "tag_origin" );
	wait(1.7);
	StopFxOnTag( getfx( "splash_player_hand_r_light" ), handdrip_ent_l, "tag_origin" );
	StopFxOnTag( getfx( "splash_player_hand_r_light" ), handdrip_ent_r, "tag_origin" );
	StopFxOnTag( getfx( "splash_player_hand_right_hand" ), handdrip_ent_r, "tag_origin" );
	wait(2.5);
	playfxontag( getfx( "splash_player_hand_left_hand" ), handdrip_ent_l, "tag_origin" );
	wait(.55);
	StopFxOnTag( getfx( "splash_player_hand_left_hand" ), handdrip_ent_l, "tag_origin" );
}



precacheFX()
{
	level._effect[ "intro_ceilingdust_shack_small" ] 	= LoadFX( "maps/intro/intro_ceilingdust_shack_small" );//placed by fxman
	level._effect[ "intro_slide_cracktop" ] 	= LoadFX( "maps/intro/intro_slide_cracktop" );//placed by fxman
	level._effect[ "intro_slide_crackside" ] 	= LoadFX( "maps/intro/intro_slide_crackside" );//placed by fxman
	level._effect[ "intro_sliderun_windowexp1" ] 	= LoadFX( "maps/intro/intro_sliderun_windowexp1" );//placed by fxman
	level._effect[ "intro_sliderun_windowexp" ] 	= LoadFX( "maps/intro/intro_sliderun_windowexp" );//placed by fxman
	level._effect[ "intro_ceilingdust_shack" ] 	= LoadFX( "maps/intro/intro_ceilingdust_shack" );//placed by fxman
	level._effect[ "intro_slide_uavshadow" ] 	= LoadFX( "maps/intro/intro_slide_uavshadow" );//placed by fxman
	level._effect[ "intro_slide_missilehit_dist" ] 	= LoadFX( "maps/intro/intro_slide_missilehit_dist" );//placed by fxman
	level._effect[ "intro_slide_chunkshadow" ] 	= LoadFX( "maps/intro/intro_slide_chunkshadow" );//placed by fxman
	level._effect[ "intro_slide_missile_fakeTrail" ] 	= LoadFX( "maps/intro/intro_slide_missile_fakeTrail" );//placed by fxman
	level._effect[ "intro_slide_crackdust_smallhouse" ] 	= LoadFX( "maps/intro/intro_slide_crackdust_smallhouse" );//placed by fxman
	level._effect[ "intro_slide_housefall_exp2" ] 	= LoadFX( "maps/intro/intro_slide_housefall_exp2" );//placed by fxman
	level._effect[ "intro_ugv_death" ] 	= LoadFX( "maps/intro/intro_ugv_death" );//placed by fxman
	level._effect[ "intro_ugv_state2" ] 	= LoadFX( "maps/intro/intro_ugv_state2" );//placed by fxman
	level._effect[ "intro_ugv_state1" ] 	= LoadFX( "maps/intro/intro_ugv_state1" );//placed by fxman
	level._effect[ "intro_ugv_state2smoke" ] 	= LoadFX( "maps/intro/intro_ugv_state2smoke" );//placed by fxman
	level._effect[ "intro_slide_chunkhit_dirt2" ] 	= LoadFX( "maps/intro/intro_slide_chunkhit_dirt2" );//placed by fxman
	level._effect[ "intro_slide_missilehit_fallingdebris_side" ] 	= LoadFX( "maps/intro/intro_slide_missilehit_fallingdebris_side" );//placed by fxman
	level._effect[ "electrical_transformer_explosion" ] 	= LoadFX( "explosions/electrical_transformer_explosion" );//placed by fxman
	level._effect[ "propane_valvefire_looper" ] 	= LoadFX( "fire/propane_valvefire_looper" );//placed by fxman
	level._effect[ "intro_slide_tumblerocks" ] 	= LoadFX( "maps/intro/intro_slide_tumblerocks" );//placed by fxman
	level._effect[ "intro_slide_crackdust" ] 	= LoadFX( "maps/intro/intro_slide_crackdust" );//placed by fxman
	level._effect[ "intro_slide_househitbillowdust" ] 	= LoadFX( "maps/intro/intro_slide_househitbillowdust" );//placed by fxman
	level._effect[ "intro_slide_househit2" ] 	= LoadFX( "maps/intro/intro_slide_househit2" );//placed by fxman
	level._effect[ "intro_slide_heaterhit_dirt" ] 	= LoadFX( "maps/intro/intro_slide_heaterhit_dirt" );//placed by fxman
	level._effect[ "intro_slide_chunkTrail2" ] 	= LoadFX( "maps/intro/intro_slide_chunkTrail2" );//placed by fxman
	level._effect[ "intro_slide_housewindowlrg_exp" ] 	= LoadFX( "maps/intro/intro_slide_housewindowlrg_exp" );//placed by fxman
	level._effect[ "intro_slide_housewindowsm" ] 	= LoadFX( "maps/intro/intro_slide_housewindowsm" );//placed by fxman
	level._effect[ "intro_slide_housewindowlrg" ] 	= LoadFX( "maps/intro/intro_slide_housewindowlrg" );//placed by fxman
	level._effect[ "intro_slide_househit" ] 	= LoadFX( "maps/intro/intro_slide_househit" );//placed by fxman
	level._effect[ "intro_slide_housefall" ] 	= LoadFX( "maps/intro/intro_slide_housefall" );//placed by fxman
	level._effect[ "intro_slide_chunkTrail" ] 	= LoadFX( "maps/intro/intro_slide_chunkTrail" );//placed by fxman
	level._effect[ "intro_slide_chunkhit_dirt" ] 	= LoadFX( "maps/intro/intro_slide_chunkhit_dirt" );//placed by fxman
	level._effect[ "intro_slide_missilehit_fallingdebris2" ] 	= LoadFX( "maps/intro/intro_slide_missilehit_fallingdebris2" );//placed by fxman
	level._effect[ "intro_slide_avalanche" ] 	= LoadFX( "maps/intro/intro_slide_avalanche" );//placed by fxman
	level._effect[ "intro_slide_collapsedust" ] 	= LoadFX( "maps/intro/intro_slide_collapsedust" );//placed by fxman
	level._effect[ "intro_slide_missilehit_exp" ] 	= LoadFX( "maps/intro/intro_slide_missilehit_exp" );//placed by fxman
	level._effect[ "intro_slide_missilehit_fallingdebris" ] 	= LoadFX( "maps/intro/intro_slide_missilehit_fallingdebris" );//placed by fxman

	//---- GURNEY ----//
	level._effect[ "heli_dust_intro_looping" ]									= loadfx( "treadfx/heli_dust_intro_looping" );
	level._effect[ "lights_uplight_haze_lantern" ]							= loadfx( "lights/lights_uplight_haze_lantern" );
	level._effect[ "lights_uplight_haze" ]											= loadfx( "lights/lights_uplight_haze" );
	level._effect[ "lights_conelight_smokey" ]									= loadfx( "lights/lights_conelight_smokey" );
	level._effect[ "lights_conelight_smokey_opaque" ]									= loadfx( "lights/lights_conelight_smokey_opaque" );
	level._effect[ "godray_intro_window" ]											= loadfx( "misc/godray_intro_window" );
	level._effect[ "godray_intro_window_opaque" ]								= loadfx( "misc/godray_intro_window_opaque" );
	level._effect[ "blood_drip_table_soap" ]										= loadfx( "misc/blood_drip_table_soap" );
	level._effect[ "blood_chest_wound" ]										= loadfx( "misc/blood_chest_wound" );
	level._effect[ "blood_cough" ]										= loadfx( "maps/intro/intro_soap_blood_cough" );
	level._effect[ "light_gurney_bloom_out" ]										= loadfx( "maps/intro/light_gurney_bloom_out" );
	level._effect[ "light_gurney_bloom" ]										= loadfx( "maps/intro/light_gurney_bloom" );
	level._effect[ "intro_helicopter_blade_shadow" ]										= loadfx( "maps/intro/intro_helicopter_blade_shadow" );
	
	//---- COURTYARD ----//
	//smoke columns after helicopters
	level._effect[ "smoke_large" ]									= loadfx( "smoke/smoke_large_cheap" );
	
	//slamraam explosion
	level._effect[ "slamraam_explosion" ]		        			= loadfx( "explosions/aa_explosion_super" );
	
	//helicopter crash through wall
	level._effect[ "intro_helicrash_wall" ]		        			= loadfx( "maps/intro/intro_helicrash_wall" );
	level._effect[ "intro_helicrash_impact_sparks" ]		    = loadfx( "maps/intro/intro_helicrash_impact_sparks" );
	level._effect[ "intro_heli_approach_room_dust" ]		    = loadfx( "maps/intro/intro_heli_approach_room_dust" );
	level._effect[ "embers_spurt" ]		        							= loadfx( "fire/embers_spurt" );
	level._effect[ "heli_crashed_tail_smoke" ]		        	= loadfx( "smoke/heli_crashed_tail_smoke" );
	level._effect[ "oil_drip_small" ]		        	= loadfx( "misc/oil_drip_small" );
	level._effect[ "falling_dirt_light_2_runner" ]		        	= loadfx( "dust/falling_dirt_light_2_runner" );
	level._effect[ "fire_mi_28" ]		    = loadfx( "maps/intro/fire_mi_28" );
	level._effect[ "intro_helicrash_godray_smokey" ]		        			= loadfx( "maps/intro/intro_helicrash_godray_smokey" );	
	level._effect[ "godray_intro_window_opaque_shortlife" ]		        			= loadfx( "maps/intro/godray_intro_window_opaque_shortlife" );	
	
	//Breach Fx
	level._effect[ "glow_white" ]									= LoadFX( "misc/light_glow_white_intro" );
	level._effect[ "point_white" ]									= LoadFX( "lights/lights_point_white_intro" );
	level._effect[ "point_white_bg" ]										= LoadFX( "lights/lights_point_white_intro_bg" );
	level._effect[ "spot_white" ]									= LoadFX( "lights/lights_spot_white" );
	level._effect[ "breach_door" ]									= LoadFX( "explosions/breach_door5" );
	level._effect[ "breach_room" ]					 				= LoadFX( "explosions/breach_room" );
	level._effect[ "breach_room_residual" ]							= LoadFX( "explosions/breach_room_residual" );
	level._effect[ "c4_explosion" ]									= loadfx( "explosions/grenadeExp_metal" );
	level._effect[ "large_ac130_concrete_1" ]									= loadfx( "impacts/large_ac130_concrete_1" );
	level._effect[ "pistolflash" ]									= loadfx( "muzzleflashes/pistolflash_wv_b" );
	level._effect[ "headshot" ]									= loadfx( "maps/intro/headshot_closerange" );
	level._effect[ "blood_smear" ]									= loadfx( "impacts/blood_smear_decal_heavy_rotated" );
	level._effect[ "breach_door_intro" ]							= LoadFX( "explosions/breach_door_intro" );
	level._effect[ "intro_lattice_exp" ]							= LoadFX( "props/intro_lattice_exp" );
	
	
	//Escort Fx
	level._effect[ "door_wood_breach_intro" ]									= loadfx( "impacts/door_wood_breach_intro" );
	level._effect[ "door_gate_breach_intro_line" ]									= loadfx( "dust/door_gate_breach_intro_line" );
	level._effect[ "door_gate_breach_intro_line_short" ]									= loadfx( "dust/door_gate_breach_intro_line_short" );
	level._effect[ "door_gate_breach_intro_out" ]									= loadfx( "dust/door_gate_breach_intro_out" );
	level._effect[ "door_gate_breach_intro_line_out" ]									= loadfx( "dust/door_gate_breach_intro_line_out" );
	level._effect[ "lights_godray_beam_intro_small" ]									= loadfx( "lights/lights_godray_beam_intro_small" );

  //Regroup Fx
  	level._effect[ "door_gate_breach_intro" ] 	= LoadFX( "dust/door_gate_breach_intro" );
  	level._effect[ "vehicle_explosion" ] 	= LoadFX( "explosions/small_vehicle_explosion" );
  

	//---- STREET
	level._effect[ "ceiling_smoke_undulating" ] 	= LoadFX( "smoke/ceiling_smoke_undulating" );//placed by fxman
	level._effect[ "ceiling_smoke_generic" ] 	= LoadFX( "smoke/ceiling_smoke_generic" );//placed by fxman
	level._effect[ "embers_smokecolumn" ] 	= LoadFX( "fire/embers_smokecolumn" );//placed by fxman
	level._effect[ "fire_flash_small" ] 	= LoadFX( "fire/fire_flash_small" );//placed by fxman
	level._effect[ "fire_falling_localized_runner_paris" ] 	= LoadFX( "fire/fire_falling_localized_runner_paris" );//placed by fxman
	level._effect[ "fire_line_sm_cheap" ] 	= LoadFX( "fire/fire_line_sm_cheap" );//placed by fxman
	level._effect[ "fire_line_sm" ] 	= LoadFX( "fire/fire_line_sm" );//placed by fxman
	level._effect[ "firelp_med_pm" ] 	= LoadFX( "fire/firelp_med_pm_cheap" );
	level._effect[ "firelp_med_pm_noglow" ] 	= LoadFX( "fire/firelp_med_pm_noglow" );
	level._effect[ "firelp_med_pm_nolight" ] 	= LoadFX( "fire/firelp_med_pm_cheap_nolight" );
	level._effect[ "firelp_small" ] 	= LoadFX( "fire/firelp_small" );
	level._effect[ "firelp_small_pm_nolight" ] 	= LoadFX( "fire/firelp_small_pm_cheap_nolight" );
	level._effect[ "firelp_tiny" ] 	= LoadFX( "fire/firelp_small_pm_a" );
	level._effect[ "fire_ceiling_md_slow" ] 	= LoadFX( "fire/fire_ceiling_md_slow" );//placed by fxman
	level._effect[ "fireball_lp_smk_L_quickfalloff" ] 	= LoadFX( "fire/fireball_lp_smk_L_quickfalloff" );//placed by fxman
	level._effect[ "embers_paris_alley_intro" ] 	= LoadFX( "fire/embers_paris_alley_intro" );
	level._effect[ "cloud_ash_intro" ] 	= LoadFX( "weather/cloud_ash_intro" );
	level._effect[ "thick_building_smoke_white_intro" ] 	= LoadFX( "fire/thick_building_smoke_white_intro" );
	level._effect[ "amb_dust_veryLight_intro" ] 	= LoadFX( "dust/amb_dust_veryLight_intro" );
	level._effect[ "dust_wind_canyon_intro" ] 	= LoadFX( "dust/dust_wind_canyon_intro" );
	level._effect[ "fire_generic_atlas" ] 	= LoadFX( "fire/fire_generic_atlas" );
	level._effect[ "fire_generic_atlas_small" ] 	= LoadFX( "fire/fire_generic_atlas_small" );
	level._effect[ "fire_generic_atlas_small_nosmoke" ] 	= LoadFX( "fire/fire_generic_atlas_small_nosmoke" );
	level._effect[ "birds_takeof_runner" ] 	= LoadFX( "misc/birds_takeof_runner" );
	level._effect[ "insects_carcass_flies_dark" ] 	= LoadFX( "misc/insects_carcass_flies_dark" );
	level._effect[ "insects_light_flies_b_complex" ] 	= LoadFX( "misc/insects_light_flies_b_complex" );
	level._effect[ "trash_spiral_runner" ] 	= LoadFX( "misc/trash_spiral_runner" );
	level._effect[ "trash_spirallo_runner" ] 	= LoadFX( "misc/trash_spirallo_runner" );
	level._effect[ "clouds_cumulus_far" ] 	= LoadFX( "misc/clouds_cumulus_far" );
	level._effect[ "leaves_fall_gentlewind_paris" ] 	= LoadFX( "misc/leaves_fall_gentlewind_intro" );
	level._effect[ "leaves_fall_gentlewind_intro" ] 	= LoadFX( "misc/leaves_fall_gentlewind_intro" );
	level._effect[ "leaves_ground_gentlewind_dust" ] 	= LoadFX( "misc/leaves_ground_gentlewind_dust" );
	level._effect[ "waterfall_drainage_splash" ] 	= LoadFX( "water/waterfall_drainage_splash" );
	level._effect[ "paper_blowing_trash_fast" ] 	= LoadFX( "misc/paper_blowing_trash_fast" );
	level._effect[ "paper_falling_burning" ] 	= LoadFX( "misc/paper_falling_burning" );
	level._effect[ "paper_falling_burning2" ] 	= LoadFX( "misc/paper_falling_burning2" );
	level._effect[ "leaves_runner_pine" ] 	= LoadFX( "misc/leaves_runner_pine" );
	level._effect[ "spark_fountain" ] 	= LoadFX( "misc/spark_fountain" );
	level._effect[ "car_headlight_truck_L" ] 	= LoadFX( "misc/car_headlight_truck_L" );
	level._effect[ "dust_ground_gust_runner" ] 	= LoadFX( "dust/dust_ground_gust_runner" );
	level._effect[ "insects_light_hunted" ] 	= LoadFX( "misc/insects_light_hunted" );
	level._effect[ "electrical_transformer_spark_runner_loop" ] 	= LoadFX( "explosions/electrical_transformer_spark_runner_loop" );
	level._effect[ "fireball_lp_smk_L_quickfalloff_intro" ] 	= LoadFX( "fire/fireball_lp_smk_L_quickfalloff_intro" );
	level._effect[ "trash_spiral_runner_intro" ] 	= LoadFX( "misc/trash_spiral_runner_intro" );
	level._effect[ "paper_blowing_burnt_intro_runner" ] 	= LoadFX( "misc/paper_blowing_burnt_intro_runner" );
	level._effect[ "dust_ground_gust_runner_intro" ] 	= LoadFX( "dust/dust_ground_gust_runner_intro" );
	level._effect[ "sewer_stream_village_muted" ] 	= LoadFX( "distortion/sewer_stream_village_muted" );
	level._effect[ "sewer_stream_village_muted_cull" ] 	= LoadFX( "distortion/sewer_stream_village_muted_cull" );
	level._effect[ "battlefield_smokebank_Large" ] 	= LoadFX( "smoke/battlefield_smokebank_Large" );
	level._effect[ "cloud_bank_gulag_z_feather" ] 	= LoadFX( "weather/cloud_bank_gulag_z_feather" );
	level._effect[ "birds_village_runner" ] 	= LoadFX( "misc/birds_village_runner" );
	level._effect[ "bird_seagull_flock_intro" ] 	= LoadFX( "misc/bird_seagull_flock_intro" );
	level._effect[ "birds_village_runner_intro" ] 	= LoadFX( "misc/birds_village_runner_intro" );
	level._effect[ "paper_blowing_burnt_loop_intro" ] 	= LoadFX( "misc/paper_blowing_burnt_loop_intro" );
	level._effect[ "battlefield_smokebank_large_intro" ] 	= LoadFX( "smoke/battlefield_smokebank_large_intro" );
	level._effect[ "sunflare_intro" ] 	= LoadFX( "lights/sunflare_intro" );
	level._effect[ "amb_dust_veryLight_intro_hills" ] 	= LoadFX( "dust/amb_dust_veryLight_intro_hills" );
	level._effect[ "amb_dust_veryLight_intro_hills_massive" ] 	= LoadFX( "dust/amb_dust_veryLight_intro_hills_massive" );
	level._effect[ "amb_dust_veryLight_intro_hills_massive_bank" ] 	= LoadFX( "dust/amb_dust_veryLight_intro_hills_massive_bank" );
	level._effect[ "amb_dust_veryLight_intro_hills_massive_blue" ] 	= LoadFX( "dust/amb_dust_veryLight_intro_hills_massive_blue" );
	level._effect[ "shadow_intro" ] 	= LoadFX( "misc/shadow_intro" );
	level._effect[ "amb_dust_veryLight_intro_house" ] 	= LoadFX( "dust/amb_dust_veryLight_intro_house" );
	level._effect[ "amb_dust_veryLight_intro_shack" ] 	= LoadFX( "dust/amb_dust_veryLight_intro_shack" );
	level._effect[ "fire_generic_ball_burst" ] 	= LoadFX( "fire/fire_generic_ball_burst" );
	level._effect[ "fire_generic_atlas_curl" ] 	= LoadFX( "fire/fire_generic_atlas_curl" );
	level._effect[ "fire_generic_atlas_smoke" ] 	= LoadFX( "fire/fire_generic_atlas_smoke" );
	level._effect[ "amb_dust_veryLight_intro_hills_massive_oriented" ] 	= LoadFX( "dust/amb_dust_veryLight_intro_hills_massive_oriented" );
	level._effect[ "amb_dust_verylight_intro_hills_massive_shadow" ] 	= LoadFX( "dust/amb_dust_verylight_intro_hills_massive_shadow" );
	level._effect[ "amb_dust_verylight_intro_hills_massive_orie_small" ] 	= LoadFX( "dust/amb_dust_verylight_intro_hills_massive_orie_small" );
	level._effect[ "fire_generic_ball_burst_large" ] 	= LoadFX( "fire/fire_generic_ball_burst_large" );
	level._effect[ "fire_ceiling_med_slow_intro" ] 	= LoadFX( "fire/fire_ceiling_med_slow_intro" );
	level._effect[ "fire_ceiling_med_slow_intro_cheap" ] 	= LoadFX( "fire/fire_ceiling_med_slow_intro_cheap" );
	level._effect[ "fire_generic_atlas_nosmoke" ] 	= LoadFX( "fire/fire_generic_atlas_nosmoke" );
	level._effect[ "fire_generic_atlas_curl_nosmoke" ] 	= LoadFX( "fire/fire_generic_atlas_curl_nosmoke" );
	level._effect[ "fire_generic_ball_thick" ] 	= LoadFX( "fire/fire_generic_ball_thick" );
	level._effect[ "fire_generic_ball_thick_far" ] 	= LoadFX( "fire/fire_generic_ball_thick_far" );
	level._effect[ "door_gate_breach_intro_ugv" ] 	= LoadFX( "dust/door_gate_breach_intro_ugv" );
	level._effect[ "fire_intro_heliswirl" ] 	= LoadFX( "fire/fire_intro_heliswirl" );
	level._effect[ "smoke_large_hot" ] 	= LoadFX( "smoke/smoke_large_hot" );
	level._effect[ "heli_take_off_swirl_intro" ] 	= LoadFX( "dust/heli_take_off_swirl_intro" );
	level._effect[ "embers_plates" ] 	= LoadFX( "fire/embers_plates" );
	level._effect[ "embers_whitehouse" ] 	= LoadFX( "fire/embers_whitehouse" );
	level._effect[ "fire_line_sm_cheap_intro" ] 	= LoadFX( "fire/fire_line_sm_cheap_intro" );
	level._effect[ "tank_shell_impact" ] 	= LoadFX( "explosions/tank_shell_impact_intro" );
	level._effect[ "fireball_smk_S" ] 	= LoadFX( "fire/fireball_lp_smk_S" );
	level._effect[ "drips_faucet_slow_intro" ] 	= LoadFX( "water/drips_faucet_slow_intro" );
	level._effect[ "smoke_large_intro" ] 	= LoadFX( "smoke/smoke_large_intro" );
	level._effect[ "amb_dust_verylight_intro_windy_mist" ] 	= LoadFX( "dust/amb_dust_verylight_intro_windy_mist" );
	level._effect[ "amb_dust_verylight_intro_windy_mist_fast" ] 	= LoadFX( "dust/amb_dust_verylight_intro_windy_mist_fast" );
	level._effect[ "amb_dust_verylight_intro_hills_mist_patch" ] 	= LoadFX( "dust/amb_dust_verylight_intro_hills_mist_patch" );
	level._effect[ "fire_generic_atlas_small_nocull" ] 	= LoadFX( "fire/fire_generic_atlas_small_nocull" );
	level._effect[ "fire_generic_glow" ] 	= LoadFX( "fire/fire_generic_glow" );
	level._effect[ "fire_generic_atlas_small_decal" ] 	= LoadFX( "fire/fire_generic_atlas_small_decal" );
	level._effect[ "fire_generic_glow_small" ] 	= LoadFX( "fire/fire_generic_glow_small" );
	level._effect[ "fire_generic_atlas_ropeburn" ] 	= LoadFX( "fire/fire_generic_atlas_ropeburn" );
	level._effect[ "fire_generic_curl_line" ] 	= LoadFX( "fire/fire_generic_curl_line" );
	level._effect[ "fire_embers_slowfall" ] 	= LoadFX( "fire/fire_embers_slowfall" );
	level._effect[ "light_glow_yellow" ] 	= LoadFX( "misc/light_glow_yellow_bulb" );

	//----Regroup Treadfx----//
	level._effect[ "decal_skid" ] 	= LoadFX( "treadfx/decal_skid" );
	level._effect[ "pb_jeep_trail_road_skid" ] 	= LoadFX( "treadfx/pb_jeep_trail_road_skid" );
	level._effect[ "decal_skid_long" ] 	= LoadFX( "treadfx/decal_skid_long" );
	level._effect[ "pb_jeep_trail_road_skid_long" ] 	= LoadFX( "treadfx/pb_jeep_trail_road_skid_long" );


	
	//---- ESCORT ----//
	
	//---- MAARS INTRO ----//
	level._effect[ "mortar" ][ "dirt" ] 								= loadfx( "explosions/mortarExp_default" );
	level._effect[ "smokescreen" ]     									= LoadFX( "smoke/smoke_grenade_low_invasion" );
	level._effect[ "door_drop_dust_intro" ] 	= LoadFX( "dust/door_drop_dust_intro" );
	level._effect[ "door_crack_open_intro" ] 	= LoadFX( "dust/door_crack_open_intro" );
	level._effect[ "door_crack_open_intro_crate" ] 	= LoadFX( "dust/door_crack_open_intro_crate" );
	level._effect[ "door_crack_open_intro_rolling" ] 	= LoadFX( "dust/door_crack_open_intro_rolling" );
	level._effect[ "door_drop_dust_light_intro" ] 	= LoadFX( "dust/door_drop_dust_light_intro" );
	level._effect[ "door_drop_dust_light_intro_rolling" ] 	= LoadFX( "dust/door_drop_dust_light_intro_rolling" );
	level._effect[ "lights_reveal_intro" ] 	= LoadFX( "lights/lights_reveal_intro" );
	level._effect[ "lights_reveal_intro_persist" ] 	= LoadFX( "lights/lights_reveal_intro_persist" );
	level._effect[ "lights_godray_beam_bright_intro" ] 	= LoadFX( "lights/lights_godray_beam_bright_intro" );
	level._effect[ "door_crack_open_intro_crate_slow" ] 	= LoadFX( "dust/door_crack_open_intro_crate_slow" );
	level._effect[ "lights_reveal_intro_oriented" ] 	= LoadFX( "lights/lights_reveal_intro_oriented" );
	level._effect[ "light_hdr_maars_intro" ] 	= LoadFX( "lights/light_hdr_maars_intro" );
	level._effect[ "light_hdr_maars_intro_hud" ] 	= LoadFX( "lights/light_hdr_maars_intro_hud" );
	level._effect[ "light_hdr_maars_intro_hud_endlines" ] 	= LoadFX( "lights/light_hdr_maars_intro_hud_endlines" );
	level._effect[ "grenade_green_gas_intro" ] 	= LoadFX( "smoke/grenade_green_gas_intro" );
	//prices flashlight
	level._effect["flashlight"] 										= loadfx( "misc/flashlight_spotlight_intro" );
	//MAARs m203 muzzle flash
	level._effect[ "maars_grenade_muzzleflash" ] 								= loadfx( "muzzleflashes/maars_grenade_flash_view" );
	//MAARs treadfx
	level._effect[ "tread_dust_small" ] 								= loadfx( "treadfx/tread_dust_default_small" );
	level._effect[ "tread_water_small" ] 								= loadfx( "treadfx/tread_water_small" );
	
	
	
	//---- REGROUP ----//
	
	//---- UAV ATTACK ----//
	level._effect[ "uav_attack_tree_missile_impact" ]				= loadfx( "explosions/tree_trunk_explosion" );
//	level._effect[ "wood_explosion_1" ]										= loadfx( "explosions/wood_explosion_1" );
	level._effect[ "lighthaze_distant" ]										= loadfx( "maps/intro/lighthaze_distant" );
	level._effect[ "lighthaze_distant_alt" ]								= loadfx( "maps/intro/lighthaze_distant_alt" );
	level._effect[ "intro_sliderun_debrisexp2" ]						= LoadFX( "maps/intro/intro_sliderun_debrisexp2" );//placed by fxman
	level._effect[ "intro_sliderun_debrisexp1" ] 						= LoadFX( "maps/intro/intro_sliderun_debrisexp1" );//placed by fxman
	level._effect[ "intro_sliderun_wallexp2" ] 							= LoadFX( "maps/intro/intro_sliderun_wallexp2" );//placed by fxman
	level._effect[ "intro_sliderun_wallexp1" ] 							= LoadFX( "maps/intro/intro_sliderun_wallexp1" );//placed by fxman
	level._effect[ "intro_sliderun_buildingexp" ] 					= LoadFX( "maps/intro/intro_sliderun_buildingexp" );//placed by fxman



	
	//---- BUILDING SLIDE ----//
	//building slide vfx
	level._effect[ "hallway_collapse_smoke_swirl_runner" ] 				= LoadFX( "smoke/hallway_collapse_smoke_swirl_runner" );
	level._effect[ "hallway_collapse_ceiling_smoke" ] 					= LoadFX( "smoke/hallway_collapse_ceiling_smoke" );
	level._effect[ "falling_debris_large" ] 					 		= LoadFX( "misc/falling_debris_large" );
	level._effect[ "pine_impact_intro" ] 					 		= LoadFX( "misc/pine_impact_intro" );
	level._effect[ "car_glass_large" ] 					 		= LoadFX( "props/car_glass_large" );
	level._effect[ "car_glass_med" ] 					 		= LoadFX( "props/car_glass_med" );
	level._effect[ "car_glass_headlight" ] 					 		= LoadFX( "props/car_glass_headlight" );
	level._effect[ "car_glass_brakelight" ] 					 		= LoadFX( "props/car_glass_brakelight" );
	level._effect[ "window_explosion_glassy_less_fiery" ] 					 		= LoadFX( "explosions/window_explosion_glassy_less_fiery" );
	level._effect[ "debris_window_blowout" ] 					 		= LoadFX( "misc/debris_window_blowout" );
	level._effect[ "generic_fallingdebris" ] 					 		= LoadFX( "misc/generic_fallingdebris" );
	level._effect[ "missile_impact_intro" ] 					 		= LoadFX( "explosions/missile_impact_intro" );
	level._effect[ "dust_boot_scrape_intro" ] 					 		= LoadFX( "dust/dust_boot_scrape_intro" );
	level._effect[ "door_drop_dust_intro_impact" ] 					 		= LoadFX( "dust/door_drop_dust_intro_impact" );
	level._effect[ "pine_explosion_intro" ] 					 		= LoadFX( "misc/pine_explosion_intro" );
	level._effect[ "body_splash_intro" ] 					 		= LoadFX( "water/body_splash_intro" );
	level._effect[ "intro_slide_missilehit_fallingdebris2_splash" ] 					 		= LoadFX( "maps/intro/intro_slide_missilehit_fallingdebris2_splash" );
	level._effect[ "splash_intro_roil" ] 					 		= LoadFX( "water/splash_intro_roil" );
	level._effect[ "body_splash_intro_delay" ] 					 		= LoadFX( "water/body_splash_intro_delay" );
	level._effect[ "intro_slide_trail_parent" ] 					 		= LoadFX( "dust/intro_slide_trail_parent" );
	level._effect[ "glass_dust_trail_child_intro" ] 					 		= LoadFX( "dust/glass_dust_trail_child_intro" );
	level._effect[ "dust_hand_scrape_intro" ] 					 		= LoadFX( "dust/dust_hand_scrape_intro" );
	level._effect[ "tree_drop_dust" ] 					 		= LoadFX( "dust/tree_drop_dust" );
	level._effect[ "wood_explosion_intro" ] 					 		= LoadFX( "impacts/wood_explosion_intro" );
	level._effect[ "splash_intro_roil_violent" ] 					 		= LoadFX( "water/splash_intro_roil_violent" );
	level._effect[ "intro_slide_trail_parent_small" ] 					 		= LoadFX( "dust/intro_slide_trail_parent_small" );
	level._effect[ "intro_slide_trail_parent_small_2" ] 					 		= LoadFX( "dust/intro_slide_trail_parent_small_2" );
	level._effect[ "glass_dust_trail_child_small" ] 					 		= LoadFX( "dust/glass_dust_trail_child_small" );
	level._effect[ "glass_dust_trail_child_small_2" ] 					 		= LoadFX( "dust/glass_dust_trail_child_small_2" );
	level._effect[ "splash_intro_initial" ] 					 		= LoadFX( "water/splash_intro_initial" );
	level._effect[ "water_intro_river_wake01" ] 					 		= LoadFX( "water/water_intro_river_wake01" );
	level._effect[ "water_intro_river_eddy" ] 					 		= LoadFX( "water/water_intro_river_eddy" );
	level._effect[ "water_intro_river_dressing" ] 					 		= LoadFX( "water/water_intro_river_dressing" );
	level._effect[ "water_intro_river_dressing_shadow" ] 					 		= LoadFX( "water/water_intro_river_dressing_shadow" );
	level._effect[ "water_intro_river_dressing_shadow_surface" ] 					 		= LoadFX( "water/water_intro_river_dressing_shadow_surface" );
	level._effect[ "water_intro_river_dressing_small" ] 					 		= LoadFX( "water/water_intro_river_dressing_small" );
	level._effect[ "water_intro_river_dressing_small_shadow" ] 					 		= LoadFX( "water/water_intro_river_dressing_small_shadow" );
	level._effect[ "water_intro_river_dressing_large" ] 					 		= LoadFX( "water/water_intro_river_dressing_large" );
	level._effect[ "water_intro_river_dressing_large_2" ] 					 		= LoadFX( "water/water_intro_river_dressing_large_2" );
	level._effect[ "water_mist_ground_intro" ] 					 		= LoadFX( "water/water_mist_ground_intro" );
	level._effect[ "sea_mist_intro" ] 					 		= LoadFX( "water/sea_mist_intro" );
	level._effect[ "water_intro_distortion" ] 					 		= LoadFX( "distortion/water_intro_distortion" );
	level._effect[ "water_intro_river_wake02" ] 					 		= LoadFX( "water/water_intro_river_wake02" );
	level._effect[ "water_intro_river_wake02_blue" ] 					 		= LoadFX( "water/water_intro_river_wake02_blue" );
	level._effect[ "water_intro_river_wake02_shadow" ] 					 		= LoadFX( "water/water_intro_river_wake02_shadow" );
	level._effect[ "body_splash_intro_expensive" ] 					 		= LoadFX( "water/body_splash_intro_expensive" );
	level._effect[ "body_splash_intro_expensive_heater" ] 					 		= LoadFX( "water/body_splash_intro_expensive_heater" );
	level._effect[ "water_intro_river_splash_wake" ] 					 		= LoadFX( "water/water_intro_river_splash_wake" );
	level._effect[ "water_river_hue_shift" ] 					 		= LoadFX( "water/water_river_hue_shift" );
	level._effect[ "water_intro_river_wake_field" ] 					 		= LoadFX( "water/water_intro_river_wake_field" );
	level._effect[ "water_intro_river_wake_field_blue" ] 					 		= LoadFX( "water/water_intro_river_wake_field_blue" );
	level._effect[ "water_intro_river_wake_field_shadow" ] 					 		= LoadFX( "water/water_intro_river_wake_field_shadow" );
	level._effect[ "water_intro_river_wake02_large" ] 					 		= LoadFX( "water/water_intro_river_wake02_large" );
	level._effect[ "water_intro_river_dressing_large_v" ] 					 		= LoadFX( "water/water_intro_river_dressing_large_v" );
	level._effect[ "water_intro_river_dressing_fast" ] 					 		= LoadFX( "water/water_intro_river_dressing_fast" );	
	level._effect[ "sea_mist_intro_light" ] 					 		= LoadFX( "water/sea_mist_intro_light" );
	level._effect[ "water_intro_river_dressing_large_shadow" ] 					 		= LoadFX( "water/water_intro_river_dressing_large_shadow" );
	level._effect[ "water_intro_river_dressing_large_shadow_surface" ] 					 		= LoadFX( "water/water_intro_river_dressing_large_shadow_surface" );
	level._effect[ "lights_intro_sunflare" ] 					 									= LoadFX( "lights/lights_intro_sunflare" );
	level._effect[ "water_intro_emerge_player_hand" ] 					 		= LoadFX( "water/water_intro_emerge_player_hand" );



	
	//splash down in the water
	level._effect[ "splash_underwater" ]	 		 					= loadfx( "water/splash_underwater_intro" );
	level._effect[ "underwater_submerge_whiteout" ]	 		 						= loadfx( "maps/intro/intro_underwater_submerge_whiteout" );
	level._effect[ "water_stop" ]				 						= LoadFX( "misc/parabolic_water_stand" );
	level._effect[ "water_movement" ]									= LoadFX( "misc/parabolic_water_movement" );
	level._effect[ "underwater_player_bubbles" ]	 		 					= loadfx( "maps/intro/intro_underwater_player_bubbles" );
	level._effect[ "splash_player_hand" ]	 				= loadfx( "water/splash_player_hand" );
	level._effect[ "splash_player_hand_R" ]	 				= loadfx( "water/splash_player_hand_R" );
	level._effect[ "splash_player_hand_r_light" ]	 				= loadfx( "water/splash_player_hand_r_light" );
	level._effect[ "splash_player_hand_r_strong" ]	 				= loadfx( "water/splash_player_hand_r_strong" );
	level._effect[ "splash_player_hand_l_strong" ]	 				= loadfx( "water/splash_player_hand_l_strong" );
	level._effect[ "splash_player_hand_right_hand" ]	 				= loadfx( "water/splash_player_hand_right_hand" );
	level._effect[ "splash_player_hand_left_hand" ]	 				= loadfx( "water/splash_player_hand_left_hand" );
	level._effect[ "bubbles_player_hand" ]	 				= loadfx( "water/bubbles_player_hand" );
	level._effect[ "water_surface_wake" ]	 				= loadfx( "maps/intro/intro_player_water_wake" );
	level._effect[ "water_surface_wake_calm" ]	 				= loadfx( "maps/intro/intro_player_water_wake_calm" );
	level._effect[ "underwater_object_bubbles" ]	 		 					= loadfx( "maps/intro/intro_underwater_object_bubbles" );
	level._effect[ "underwater_silt" ]	 		 					= loadfx( "maps/intro/intro_underwater_silt" );
	level._effect[ "underwater_current" ]	 		 					= loadfx( "maps/intro/intro_underwater_current" );
	level._effect[ "underwater_bank_foam" ]	 		 					= loadfx( "maps/intro/intro_underwater_bank_foam" );
	level._effect[ "surface_hand_splash" ]	 		 					= loadfx( "maps/intro/intro_surface_hand_splash" );
	level._effect[ "intro_underwater_fog" ]	 		 					= loadfx( "maps/intro/intro_underwater_fog" );
	
	
	
	//---- DRONES ----//
	level._effect[ "bodyshot1" ] 										= loadfx( "impacts/flesh_hit" );
	level._effect[ "bodyshot2" ] 										= loadfx( "impacts/flesh_hit_body_fatal_exit" );
	level._effect[ "headshot1" ] 										= loadfx( "impacts/flesh_hit_head_fatal_exit" );
	level._effect[ "headshot2" ] 										= loadfx( "impacts/flesh_hit_head_fatal_exit_exaggerated" );
		
	//---- SCRIPT DESTRUCTIBLES ----//
	level._effect[ "intro_scaffolding_1" ] 										= loadfx( "props/intro_scaffolding_1" );	
	level._effect[ "intro_balcony_woodrailing_des01" ] 										= loadfx( "props/intro_balcony_woodrailing_des01" );	
}

