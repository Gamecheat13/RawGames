#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_audio;
#include maps\_shg_fx;
#include maps\_gameevents;
#include maps\_shg_common;

main()
{
	//LittleBird DeathFX override		
	//maps\_vehicle::build_deathfx_override( undefined, "littlebird", "vehicle_little_bird_armed", "explosions/helicopter_explosion_secondary_small", 	"tag_engine", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.0, 		true );
	//maps\_vehicle::build_deathfx_override( undefined, "littlebird", "vehicle_little_bird_armed", "fire/fire_smoke_trail_L", 							"tag_engine", 	"littlebird_helicopter_dying_loop", 	true, 				0.05, 			true, 			0.5, 		true );
	//maps\_vehicle::build_deathfx_override( undefined, "littlebird", "vehicle_little_bird_armed", "explosions/helicopter_explosion_secondary_small",	"tag_engine", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
	//maps\_vehicle::build_deathfx_override( undefined, "littlebird", "vehicle_little_bird_armed", "explosions/mortarExp_water", 						undefined, 		"littlebird_helicopter_crash", 			undefined, 			undefined,		undefined, 		- 1, 		undefined, 	"stop_crash_loop_sound" );


	//exploder number codes:
	// 850s = giant water splashes near ship
	// 600-610 = wave splashes near sub
	// 700 = land explosions on harbor shore
	// 900 = initial building exlosion 
	// 556 = the anti-air runners and the random giant water splashes
	// 555 = activate the giant smoke columns in the harbor
	// 500-505 = activate water draining from sub missile hatches
	// 200-220 = sub breach moment
	// 246-250 = sub hatch moment
	// 240-245 = building hit fx

	flag_init("start_sinking");
	flag_init("russian_sub_spawned");
	flag_init("fx_player_surfaced");
	flag_init("detonate_torpedo"); 
	flag_init("fx_chinook_screen_watersplash");
	flag_init( "sub_surface_rumble" );
	
	//pipe burst VFX
	flag_init("trigger_vfx_pipe_burst");
	flag_init("trigger_vfx_pipe_burst_cr");
	flag_init("trigger_vfx_pipe_burst_mr");
	
	
	//ship destruction createFX fx
	flag_init("flag_ship_splode_1_fx");
	flag_init("flag_ship_splode_2_fx");
	flag_init("flag_ship_splode_3_fx");
	flag_init("flag_ship_splode_4_fx");
	flag_init("flag_ship_splode_5_fx");
	flag_init("flag_ship_splode_6_fx");
	flag_init("flag_destroyer_fx");
	
	flag_init("msg_fx_under_docks");
	
	init_smVals();

	thread precacheFX();


	//Global threads
	thread treadfx_override();
	maps\createfx\ny_harbor_fx::main();
	setup_shg_fx();
	thread convertoneshot();
	//thread get_exploder_pos(701,701);
	//thread get_exploder_pos(5100,5100,"lights_godray_beam_harbor");
	
	//sub threads
	//footStepEffects();
	thread vfx_pipe_burst();
	thread vfx_pipe_burst_cr();
	thread vfx_pipe_burst_mr();
	thread setup_poison_wake_volumes();
	thread kickoff_godrays_1();
	
	//underwater threads
	thread bubble_wash_player_exiting_gate();
	thread tunnel_vent_bubbles_wide();
	thread tunnel_vent_bubbles();
	thread sinking_ship_vfx_sequence();
	thread minisub_dust_kick_player();
	thread kill_distance_depth_charges();
	thread torpedo_explosion_distance_vfx();
	thread cine_sub_surfacing_explosions();
	thread oscar02_propwash_vfx();
	thread oscar02_body_water_displacement_vfx();
	thread cine_sub_surfacing_env_vfx();
	thread oscar_cine_water_displacement_vfx();
	thread bubble_transition_entering_mine_plant();
	//thread bubble_transition_starting_mine_plant();
	thread bubble_on_player_mine_plant();
	thread player_surfacing_vfx();
	thread sandman_surfacing_vfx();
	
	//Harbor surface threads
	thread surface_dvora_hideparts();
	thread surface_sub_breach_moment();
	thread surface_start_smoke_column();
	thread surface_building_hit_moment();
	thread surface_building_hit_moment2();
	thread surface_sub_ambient_fx();
	thread starthindDust();
	thread trigger_harbor_fx();
	thread trigger_surface_vision_set();
	thread sub_breach_vision_change();
	thread zodiac_escape_vision_change();
	level thread near_water_hits_watcherA();
	level thread near_water_hits_watcherB();
	level thread near_water_hits_watcherC();
	thread calc_fire_reflections();
	thread surface_sub_tail_foam();
	thread loop_skybox_hinds();
	thread loop_skybox_migs();
	thread start_waves_hidden();
	thread play_slava_missiles();
	thread chinook_extraction_fx();
	thread chinook_screen_watersplash();
	thread sub_breached_drainage_fx();
	thread chinook_interiorfx();
	thread sub_volumetric_lightbeam();
	thread disable_ambient_under_docks();
	//level thread player_bubble_watcher();//may use later


	//Final vista threads
	//thread fireCollapseFX();//keeping around - may use later
		
	

	//all exploder numbers for any underwater vfx start at 1000, and everything above the water vfx would start at 20000
	/*--------------------------------------------------------
	zone watcher for underwater scenes
	--------------------------------------------------------*/
	thread fx_zone_watcher(1000,"msg_vfx_tunnel_a","msg_vfx_tunnel_b");  //intro underwater tunnel entirely
	thread fx_zone_watcher(1500,"msg_vfx_tunnel_b");  //intro underwater tunnel first half til the first car headlights
	thread fx_zone_watcher(1600,"msg_vfx_tunnel_a");  //intro underwater tunnel first half til the first car headlights
	thread fx_zone_watcher(2000,"msg_vfx_udrwtr_a");  //underwater from tunnel to the rolling ship
	thread fx_zone_watcher(3000,"msg_vfx_udrwtr_b");  //underwater from rolling ship to submarine reveal spot
	thread fx_zone_watcher(4000,"msg_vfx_udrwtr_c");  //underwater from near where player approaches the sub to the end
	thread fx_zone_watcher(5000,"msg_vfx_sub_interior_a");  //first half of sub interior
	thread fx_zone_watcher(5100,"msg_vfx_sub_interior_a1");  //sub interior first room
	thread fx_zone_watcher(5200,"msg_vfx_sub_interior_a2");  //sub interior hallways part one
	thread fx_zone_watcher(5300,"msg_vfx_sub_interior_a3");  //sub interior hallways part two
	thread fx_zone_watcher(260,"msg_vfx_sub_interior_red_light_pulse");  //sub interior red area pulsing light
	thread fx_zone_watcher(5400,"msg_vfx_sub_interior_a4");  //sub interior second room floor 1
	thread fx_zone_watcher(5500,"msg_vfx_sub_interior_a5");  //sub interior second room floor 2
	thread fx_zone_watcher(6000,"msg_vfx_sub_interior_b");  //second half of sub interior
	thread fx_zone_watcher(6050,"msg_vfx_sub_interior_b0");  //second half of sub interior first room
	thread fx_zone_watcher(6100,"msg_vfx_sub_interior_b1");  //second half of sub interior bottom floor
	thread fx_zone_watcher(6200,"msg_vfx_sub_interior_b2");  //second half of sub interior top floor
	thread fx_zone_watcher(6500,"msg_vfx_sub_interior_c");  //sub interior control room
	
	
	
	//Zone threads
	thread fx_zone_watcher(20000,"msg_vfx_surface_zone_20000","msg_vfx_surface_zone_20000","msg_vfx_sub_interior_minus_25000");//docks area
	thread fx_zone_watcher(21000,"msg_vfx_surface_zone_21000","msg_vfx_surface_zone_21000","msg_vfx_sub_interior_minus_25000");//between the carrier and the docks
	thread fx_zone_watcher(22000,"msg_vfx_surface_zone_22000","msg_vfx_surface_zone_22000","msg_vfx_sub_interior_minus_25000");//on the carrier
	thread fx_zone_watcher(23000,"msg_vfx_surface_zone_23000","msg_vfx_surface_zone_23000","msg_vfx_sub_interior_minus_25000");//starting the escape
	thread fx_zone_watcher(25000,"msg_vfx_surface_zone_25000","msg_vfx_surface_zone_25000","msg_vfx_sub_interior_minus_25000");//ambient above the surface
	thread fx_zone_watcher_both(25001,"msg_vfx_surface_zone_25000", "sub_breach_finished");//ambient above the surface after the sub has breached
	thread fx_zone_watcher(26000,"msg_vfx_surface_zone_26000");//ambient on the deck of the sub
	

	
}

init_smVals()
{
	//Set the initial shadow values
	setsaveddvar("sm_spotlimit",1);
	setsaveddvar("sm_sunshadowscale",.85);
	setsaveddvar("sm_sunsamplesizenear",.25);
	setsaveddvar("fx_alphathreshold",11);
//	setsaveddvar("r_specularcolorscale",.25);
}

//Ambient fx threads


/*
start_exp_room()
{
	wait(1);
	fxent = getfx("fxid");
	missile_launchers = [(-51563.8, -26501.1, -52.3435)
				,(-18204.7, -13514.1, -127.875)];
	expAng = [(-51563.8, -26501.1, -52.3435)
				,(-18204.7, -13514.1, -127.875)];
	ents = [];
	for(;;)
	{
	flag_wait("fx_zone_" + num + "_active");
	for(i=0;i<missile_launchers.size;i++)
	{
		ents[i]=playfx(fxent,missile_launchers[i],expAng[i]);
	}
	flag_waitopen("fx_zone_" + num + "_inactive");
	for(i=0;i<ents.size;i++)
	{
		ents[i] delete();
	}
	
	
	}
}
*/

start_harbor_landexplosions()
{
	level endon("msg_nyharbor_stoplandexplosions");
	wait(10.0);
	missile_launchers = [(-23478, -7706, 2923),
						(-22185, -8779, 2180),
						(-23378, -6212, 5748),
						(-23424, -6366, 7314),
						(-19972, -9802, 5410),
						(-20379, -10371, 4822),
						(-20035, -10621, 5546),
						(-15733, -13971, 3326),
						(-15685, -14066, 4087),
						(-14732, -11701, 5727),
						(-15379, -14279, 4894),
						(-15221, -14225, 6551),
						(-15507, -13927, 7272),
						(-15628, -13548, 7604),
						(-15548, -14034, 8099),
						(-14356, -14567, 4206),
						(-14039, -14379, 3792),
						(-10906, -12809, 1927),
						(-25745, -10676, 1154),
						(-11855, -17013, 87),
						(-17644, -14389, 59),
						(-40405, -20724, 47),
						(-39551, -14037, 1154),
						(3869, -55407, 2641),
						(-591, -58842, 2617),
						(-14109, -27253, 727),
						(-16280, -26991, 559),
						(-12941, -60922, 1411),
						(-17831, -11150, 5230),
						(-37800, -14379, 749),
						(-36001, -14058, 1100),
						(-28545, -9132, 767),
						(6874, -30979, 1168),
						(-11626, -27742, 750)];
	thread shg_spawn_tendrils(700,"smoke_geotrail_genericexplosion",7,500,2000,10,30,200,75,1200);

	to1 = spawn_tag_origin();
	to1.origin = level.player getorigin();
	to1.angles = ( 270, 0, -45);

	fxEnts = [];
	ent = get_exploder_ent(700);
	
	wait(1.0);
	for(;;)
	{
		
		//Find the explosions the player is looking at
		flag_waitopen("msg_vfx_sub_interior_minus_25000");
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		found_exp = -1;
		final_exp_pos = [];
		for ( i = 0;i < missile_launchers.size;i++ )
		{
			if ( !isdefined( ent ) )
				continue;
			toFX = vectornormalize(missile_launchers[i]-level.player.origin);
			if(vectordot(eye,toFX)>.45) 
			{
				found_exp = 1;
				final_exp_pos[final_exp_pos.size] = missile_launchers[i];
			}
		}
		
		//to1.origin = self.player getorigin();
		if(found_exp >0)
		{
			curr_exp_num = randomInt((final_exp_pos.size+1));
			if(isdefined(curr_exp_num))
			{
				origin = final_exp_pos[curr_exp_num];
				if(isdefined(ent) && isdefined(origin) ) 
				{
					ent.v["origin"] = origin;
//					event = ge_AddFxNotifyWait( "activate", "cancel", "kill", [19, 0] /* cost[fxelem,trailelem] */, 20 /*priority*/, "ambientsurface", "splash" );
					exploder(700);
					aud_send_msg("land_explosion", origin);
//					thread ge_EventFinished(event, 2);
				}
			}
		}
		wait(2.0);


	}
}


start_harbor_waterexplosions()
{
	level endon("msg_nyharbor_stopwaterexplosions");
	level endon("switch_chinook");
	wait(1.0);
	missile_launchers = [(-16078.9, -21985.4, -200)
		,(-16816.5, -20880.9, -200)
		,(-18183.6, -18682.9, -200)
		,(-18336.6, -22499, -200)
		,(-19216.4, -24298.5, -200)
		,(-20321.3, -23572.2, -200)
		,(-20265.5, -25595.6, -200)
		,(-20735.7, -27581.2, -200)
		,(-22218.2, -27296.4, -200)
		,(-19044.7, -27895.1, -200)
		,(-18075.8, -29197.2, -200)
		,(-17744, -30302.6, -200)
		,(-17999.4, -28065.1, -200)
		,(-16754.2, -24812.2, -200)
		,(-15567.5, -21403.1, -200)
		,(-20567.9, -22634.9, -200)
		,(-22419.9, -22541.9, -200)
		,(-23146.1, -22028.9, -200)
		,(-25366.4, -21724.8, -200)
		,(-25043.7, -17634.6, -200)
		,(-25993.9, -18138.5, -200)
		,(-26250.4, -15147.6, -200)
		,(-25659.9, -14375.8, -200)
		,(-23713.3, -13311.5, -200)
		,(-22780.3, -13618.7, -200)
		,(-21478, -14437.1, -200)
		,(-22617.4, -14448.8, -200)
		,(-23806.5, -14948.8, -200)
		,(-23644.5, -15660.2, -200)
		,(-28572.1, -13679.3, -200)
		,(-28228.2, -12692.6, -200)
		,(-27916.6, -12271.2, -200)
		,(-29142.7, -12614.8, -200)
		,(-28393.1, -13857.3, -200)
		,(-31218.2, -10518.2, -200)
		,(-32947.7, -9691.9, -200)
		,(-33643.6, -8825.27, -200)
		,(-33621, -7460.5, -200)
		,(-32622.4, -7111.54, -200)
		,(-35627.4, -7209.94, -200)
		,(-35884.1, -6679.09, -200)
		,(-36072.6, -5718.29, -200)
		,(-35921.5, -4673.62, -200)
		,(-35050.2, -4831.81, -200)
		,(-35889.1, -5455.13, -200)
		,(-38852.8, -5039.36, -200)
		,(-40430.3, -4731.15, -200)
		,(-40006.1, -5136.87, -200)
		,(-41720, -6428.87, -200)
		,(-42289.9, -6732.02, -200)
		,(-42919, -7569.04, -200)
		,(-43737.6, -7743.24, -200)
		,(-44748.6, -7912.62, -200)
		,(-45201.1, -8196.11, -200)
		,(-43944.9, -9585.19, -200)
		,(-45505.2, -10311.4, -200)
		,(-45846.5, -10420.5, -200)
		,(-46029.4, -10493.4, -200)
		,(-47543.1, -11105.5, -200)
		,(-47441.8, -11546.2, -200)
		,(-47907.2, -13315.8, -200)
		,(-49340.5, -13184.8, -200)
		,(-49846.9, -13546.4, -200)
		,(-49886.7, -13569.9, -200)
		,(-50055.7, -13249.7, -200)
		,(-50757.5, -11968.9, -200)
		,(-51311.7, -11834.3, -200)
		,(-52190.5, -12655.5, -200)
		,(-52377.9, -13990.1, -200)
		,(-51499.3, -14423, -200)
		,(-51421, -14657.3, -200)
		,(-52251.8, -16500.2, -200)
		,(-52368.3, -16925.9, -200)
		,(-52242.7, -16851.7, -200)
		,(-51244.4, -17150.9, -200)
		,(-50379.3, -17859.9, -200)
		,(-50120.7, -18476.7, -200)
		,(-44681.9, -17448.3, -200)
		,(-43879.6, -17154.6, -200)
		,(-43479.3, -16726, -200)
		,(-43063.4, -15127.9, -200)
		,(-42987.8, -15359.1, -200)
		,(-42286.2, -16393.4, -200)
		,(-41453.7, -17380.7, -200)
		,(-41378.6, -17010.7, -200)
		,(-41172.4, -15877.7, -200)
		,(-40568, -16025.7, -200)
		,(-40032.1, -17036.5, -200)
		,(-40066.7, -17954.3, -200)
		,(-41229.4, -18365.4, -200)
		,(-42487, -18963, -200)
		,(-33784.9, -22706.5, -200)
		,(-32928.3, -24092.6, -200)
		,(-32805.7, -25060.2, -200)
		,(-32799.6, -25218.4, -200)
		,(-32935.9, -25547.7, -200)
		,(-33131.7, -26361, -200)
		,(-33144.1, -26924.8, -200)
		,(-32960.4, -27469.7, -200)
		,(-32737.9, -28466.1, -200)
		,(-32683.1, -28446, -200)
		,(-32341.5, -28929.9, -200)
		,(-31640.9, -30358.7, -200)
		,(-31188.3, -31317.3, -200)
		,(-31032.7, -31237.5, -200)
		,(-29785.7, -30629.1, -200)
		,(-28250.7, -31535.6, -200)
		,(-28246.9, -31948.5, -200)
		,(-28254.1, -31957, -200)
		,(-28467.5, -32222.5, -200)
		,(-28823.8, -32628.9, -200)
		,(-29495.3, -33378.9, -200)
		,(-29826.3, -33751.8, -200)
		,(-29825.5, -33746.4, -200)
		,(-29844.5, -33592, -200)
		,(-30582.3, -32543.2, -200)
		,(-31548.1, -32468, -200)
		,(-32419.6, -32942.7, -200)
		,(-32867, -33544.2, -200)
		,(-33027.8, -34026.5, -200)
		,(-32915.2, -34432, -200)
		,(-32707.8, -34600.1, -200)
		,(-32052.9, -34652.6, -200)
		,(-31514.5, -34655.9, -200)
		,(-30548.6, -34693.2, -200)
		,(-29892.7, -34738.4, -200)
		,(-28809.5, -34828.7, -200)
		,(-26584.5, -34816.2, -200)
		,(-25628.3, -34667.6, -200)
		,(-25157.4, -34594, -200)
		,(-24945.2, -34813.7, -200)
		,(-24756, -35644.5, -200)
		,(-24775, -37517, -200)
		,(-25791.8, -38224.2, -200)
		,(-28097.7, -38460.5, -200)
		,(-29101.6, -38226.6, -200)
		,(-29863.8, -37763.9, -200)
		,(-30215.2, -37246.5, -200)
		,(-30520.7, -36707.9, -200)
		,(-31239.8, -35961.7, -200)
		,(-31839.2, -35612.7, -200)
		,(-32567.1, -35535.9, -200)
		,(-33042.2, -35873.3, -200)
		,(-33576.7, -36402.1, -200)
		,(-34468, -37275.5, -200)
		,(-35055.7, -38052.1, -200)
		,(-35065.8, -38466.1, -200)
		,(-34695.2, -38761.9, -200)
		,(-34282.6, -38943.2, -200)
		,(-34316.1, -39559.9, -200)
		,(-36498.1, -41442.5, -200)
		,(-36734.7, -41555.1, -200)
		,(-36808.4, -41017.6, -200)
		,(-36901.2, -40131.5, -200)
		,(-37105.7, -38808.8, -200)
		,(-37242.5, -38294.2, -200)
		,(-37652.6, -37773.5, -200)
		,(-38465, -37260.7, -200)
		,(-39435.1, -36868.1, -200)
		,(-40792.8, -36680.6, -200)
		,(-41798.2, -36391.3, -200)
		,(-41591.9, -37534.7, -200)
		,(-41837, -38447.7, -200)
		,(-42499.8, -39271.8, -200)
		,(-43396.9, -39836.7, -200)
		,(-44616.3, -39742.9, -200)
		,(-45983.7, -39432, -200)
		,(-47076.6, -39397, -200)
		,(-47583.7, -39841.6, -200)
		,(-47899.1, -40521.4, -200)
		,(-48520, -41278.8, -200)
		,(-50112.7, -40881.5, -200)
		,(-50971.5, -40474.9, -200)
		,(-50986.2, -40432.4, -200)
		,(-51301.8, -39502.8, -200)];

	to1 = spawn_tag_origin();
	to1.origin = level.player getorigin();
	to1.angles = ( 270, 0, -45);

	fxEnts = [];
	ent = get_exploder_ent(701);
	wait(1.0);
	for(;;)
	{


		
		//Find the explosions the player is looking at
		flag_waitopen("msg_vfx_sub_interior_minus_25000");
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		found_exp = -1;
		final_exp_pos = [];
		for ( i = 0;i < missile_launchers.size;i++ )
		{
			if ( !isdefined( ent ) )
				continue;
			toFX = vectornormalize(missile_launchers[i]-level.player.origin);
			if(vectordot(eye,toFX)>.45) 
			{
				found_exp = 1;
				final_exp_pos[final_exp_pos.size] = missile_launchers[i];
			}
		}
		
		//to1.origin = self.player getorigin();
		if(found_exp >0)
		{
			curr_exp_num = randomInt((final_exp_pos.size+1));
			if(isdefined(curr_exp_num))
			{
				origin = final_exp_pos[curr_exp_num];
				if(isdefined(ent) && isdefined(origin) ) 
				{
					ent.v["origin"] = origin;
//					event = ge_AddFxNotifyWait( "activate", "cancel", "kill", [19, 0] /* cost[fxelem,trailelem] */, 20 /*priority*/, "ambientsurface", "splash" );
					exploder(701);
//					thread ge_EventFinished(event, 2);
				}
			}
		}
		wait(2.0);


	}
}



//Threads for some canned fx on the surface of the sub


near_water_hits_watcherA()
{
	level waittill("msg_fx_trigger_waterHitA");
//	event = ge_AddFxNotifyWait( "activate", "cancel", "kill", [114, 0] /* cost[fxelem,trailelem] */, 20 /*priority*/, "ambientsurface", "waterHitA" );
	exploder(850);
	wait(.25);
	to1 = spawn_tag_origin();
	to1.origin = self.player getorigin();
	to1.angles = ( 270, 0, 0);
	playfxontag(getfx("large_water_impact_close_rain"),to1,"tag_origin");
	wait(10.0);
	to1 delete();
//	ge_EventFinished(event);
}
near_water_hits_watcherB()
{
	level waittill("msg_fx_trigger_waterHitB");
//	event = ge_AddFxNotifyWait( "activate", "cancel", "kill", [114, 0] /* cost[fxelem,trailelem] */, 20 /*priority*/, "ambientsurface", "waterHitB" );
	exploder(851);
	wait(.25);
	to1 = spawn_tag_origin();
	to1.origin = self.player getorigin();
	to1.angles = ( 270, 0, 0);
	playfxontag(getfx("large_water_impact_close_rain"),to1,"tag_origin");
	wait(10.0);
	to1 delete();
//	ge_EventFinished(event);
}
near_water_hits_watcherC()
{
	level waittill("msg_fx_trigger_waterHitC");
//	event = ge_AddFxNotifyWait( "activate", "cancel", "kill", [114, 0] /* cost[fxelem,trailelem] */, 20 /*priority*/, "ambientsurface", "waterHitC" );
	exploder(852);
	wait(.25);
	to1 = spawn_tag_origin();
	to1.origin = self.player getorigin();
	to1.angles = ( 270, 0, 0);
	playfxontag(getfx("large_water_impact_close_rain"),to1,"tag_origin");
	wait(10.0);
	to1 delete();
//	ge_EventFinished(event);
}

/*

*/


kickoff_godrays_1()
{
        wait(1);
      fxent = getfx("lights_godray_beam_harbor");
      missile_launchers = [(-39249, -23793.9, -309.083)
,(-39238.2, -23802.1, -302.346)
,(-39239.3, -23842.4, -305.435)
,(-39231.2, -23833.4, -298.456)
,(-39242.1, -23825.2, -305.193)
,(-39410.9, -23784.6, -315.104)
,(-39400.1, -23792.8, -308.367)
,(-39408.2, -23801.8, -315.346)
,(-39404, -23815.9, -311.214)
,(-39401.2, -23833.1, -311.456)
,(-39393.1, -23824.1, -304.477)
,(-38982.4, -23731.1, -300.505)
,(-38971.6, -23739.3, -293.768)
,(-38975.5, -23762.4, -296.615)
,(-38972.7, -23779.6, -296.857)
,(-38964.6, -23770.6, -289.878)
,(-38805.2, -23733.9, -302.235)
,(-38794.4, -23742.1, -295.498)
,(-38798.3, -23765.2, -298.345)
,(-38795.5, -23782.4, -298.587)
,(-38787.4, -23773.4, -291.608)];
      expAng = [(41.9076, 9.07033, -152.016)
,(47.1022, 350.779, -162.906)
,(47.8449, 314.967, 168.305)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(41.9076, 9.07033, -152.016)
,(47.1022, 350.779, -162.906)
,(47.8449, 314.967, 168.305)
,(41.9076, 9.07033, -152.016)
,(47.8449, 314.967, 168.305)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(47.8449, 314.967, 168.305)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(47.1022, 350.779, -162.906)
,(41.9076, 9.07033, -152.016)
,(47.8449, 314.967, 168.305)
,(47.1022, 350.779, -162.906)];
      ents = [];
      for(;;)
      {
		      flag_wait("fx_zone_5100_active");
		      for(i=0;i<missile_launchers.size;i++)
		      {
		                      ents[i]=spawnfx(fxent,missile_launchers[i],anglestoforward(expAng[i]),anglestoup(expAng[i]));
		                      triggerfx(ents[i]);
		      }
		      flag_waitopen("fx_zone_5100_active");
		      for(i=0;i<ents.size;i++)
		      {
		                    ents[i] delete();
		      }
		      
		      
      }

}

trigger_surface_vision_set()
{
	level waittill("msg_fx_set_surface_visionset");
	//thread vision_set_fog_changes( "ny_harbor_surfacing", 3 );


}


surface_building_hit_moment()
{
	flag_init("msg_fx_set_buildinghit2");

	wait(1.0);
	node = getent( "sub_board_anim_node", "targetname" );
	exp = get_exploder_ent(248);
	exp.v["origin"]= node.origin + (-5035,-4309,380);
	//print((-21856,-7672,5208)-node.origin);
	des_anim = getent("ny_manhattan_building_exchange_01_facade_des","targetname");
	des_anim2 = getent("ny_manhattan_building_exchange_01_facade_des2","targetname");
	des_anim3 = getent("ny_manhattan_building_exchange_01_facade_des3","targetname");
	des_anim.animname = "building_des";
	des_anim2.animname = "building_des";
	des_anim3.animname = "building_des";
	des_anim  setAnimTree();
	des_anim2  setAnimTree();
	des_anim3  setAnimTree();
	des_anim  hide();
	des_anim2  hide();
	des_anim3  hide();
	
	hide_ent = getent("surface_building_hit_undamaged","targetname");
	//hide_ent hide();
	flag_wait("msg_fx_set_buildinghit2");//Use this flag first because its been inited then wait for the next flag
	//flag_wait("sub_breach_finished");//wait til the player has boarded the sub
	//level waittill("start_surface_missile_fx");
	
	level notify("msg_nyharbor_stoplandexplosions");
	level notify("msg_nyharbor_stopwaterexplosions");
	//level notify("msg_fx_stop_slava_missiles");
	
	exploder(248);//The missile animation
	aud_send_msg("harbor_missile_03");
	wait(4.20);
	des_anim show();
	des_anim2  show();
	des_anim3  show();
	exploder(240);//main explosion
	aud_send_msg("building_missile_explosion_02");
	exploder(241);//cover dust
	wait(.25);
	des_anim SetAnim( level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]);
	des_anim2 SetAnim( level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]);
	des_anim3 SetAnim( level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]);
	hide_ent hide();
	wait(.75);
	exploder(245);//first chunk dust hit
	wait(.25);
	exploder(242);//fires inside
	wait(.5);
	exploder(243);//chunk dust hit
	wait(.25);
	exploder(244);//chunk dust hit
	wait(.50);
	exploder(246);//final chunk hit
	wait(360);
	des_anim  hide();
	des_anim2  hide();
	des_anim3  hide();
	
	thread start_harbor_landexplosions();
	thread start_harbor_waterexplosions();

}

sub_interior_extinguisherfx( extinguisher )
{
	self endon("death");
		//iprintlnbold("working");
	for(;;)
	{
		self waittillmatch("looping anim","start_fire");
		aud_send_msg("aud_fire_extinguisher_spray", extinguisher);
		for(i=0;i<5;i++)
		{
			playfxontag(getfx("fire_extinguisher_spray"),extinguisher,"tag_fx");		
			wait(.1);
		}
		
	}
}

sub_breach_vision_change()
{
	flag_wait("sub_breach_started");
	wait(24);//wait until surfacing so it enables breach visionset at the right time.
	vision_set_fog_changes("ny_harbor_sub_breach", 2);
}
	
zodiac_escape_vision_change()
{
	flag_wait("player_on_boat");
	vision_set_fog_changes("ny_harbor_zodiac", 3);
}
	
surface_building_hit_moment2()
{
	wait(1.0);
	node = getent( "sub_breach_anim_node", "targetname" );
	exp = get_exploder_ent(249);
	exp.v["origin"]= (-37920.948,-22439.869,-335);//node.origin + ((6307+1952.482)*-1,(3336.92-10)*-1,(422-437) );
	exp1 = get_exploder_ent(250);
	exp1.v["origin"]= (-39290.909,-23624.614,-276.368);//node.origin + ((6307+1952.482)*-1,(3336.92-10)*-1,(422-437) );
	desb_anim = getent("ny_manhattan_building_exchange_01_facade_des4","targetname");
	desb_anim.animname = "building_des";
	desb_anim  setAnimTree();
	hide_entb = getent("surface_building_hit_undamaged2","targetname");
	//hide_entb hide();
	desb_anim hide();
	flag_wait("sub_breach_started");//Use this flag first because its been inited then wait for the next flag
	wait(15.66);
	level notify("msg_fx_player_surfaced");
	wait(4.0);
	exploder(249);//The missile animation
	exploder(250);//The missile animation
	aud_send_msg("harbor_missile_03");
	desb_anim show();
	wait(.7);
	level thread screenshake(.25,.5,.2,.25);
	wait(2.4);
	desb_anim SetAnim( level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]);
	aud_send_msg("building_missile_explosion_01");
	//exploder(240);//main explosion
	exploder(251);//cover dust
	wait(.25);
	exploder(252);//after fires
	hide_entb hide();
	wait(200);
	desb_anim hide();
}
	

surface_col_thread(ent)
{
	wait(.1);
	rot_anim_set = randomfloat(1);
	ent setanim(level.scr_anim[ "smoke_column" ][ "rot" ],1.0,1.0,0.0);
	ent setanim(level.scr_anim[ "smoke_column" ][ "fire" ],1.0,1.0,0.0);
	wait(.1);

	for(;;)
	{
		v_toplayer = level.player.origin-ent.origin;
		new_angles = vectortoangles(vectornormalize(v_toplayer));
		//set the animation based on the y angle
		f_ang_t = (new_angles[1]-90.00);
		if(f_ang_t<0) f_ang_t  = 360+f_ang_t;
		rot_anim_set += .125/600.000;
		if(rot_anim_set<0) rot_anim_set =  1.0 + rot_anim_set;
		else if(rot_anim_set>1) rot_anim_set =  rot_anim_set - 1.0;
		ent setanimtime(level.scr_anim[ "smoke_column" ][ "fire" ],clamp(f_ang_t/360.00,0.0,1.0));
		ent setanimtime(level.scr_anim[ "smoke_column" ][ "rot" ],rot_anim_set);
		wait(.05);
	}
}

surface_start_smoke_column()
{
	smoke_col_a = getentarray("fx_ny_smoke_column","targetname");
	//identify ny_column_base & place geo smoke cols there
	smoke_org = [];
	fxid = "ny_column_base";
	exploders = level.createFXbyFXID[ fxid ];
	
	if (isdefined(exploders))
	{
		foreach (ent in exploders)
		{
		if ( ent.v[ "type" ] != "exploder" )
			continue;
		if ( !isdefined( ent.v[ "exploder" ] ) )
			continue;
			smoke_org[smoke_org.size] = ent.v["origin"];
	}
	}
	/*smoke_org = [
	( -42064, -11873.3, -386.014 ),
	( -28593.4, 73.2523, -274.486 ),
	( -23604.2, -5992.17, 2433.72 ),
	( -42991, -32616.8, -450.824 ),
	( -10754, -17284.5, -240 ),
	( -9403.79, -22387.4, -325.197 ),
	( -20193.3, -9961.22, 5553.89 ),
	( -14379.2, -15098.9, 3189.78 ),
	( -9966.12, -11536, 771.327 ),
	( -10885.7, -14867.9, -240 )
	];
	ent = createExploder( "ny_column_base" );
	ent.v[ "origin" ] = ( -10754.3, -17283.5, -240 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "ny_column_base";
	ent.v[ "delay" ] = 0;
	ent.v[ "exploder" ] = "25000";

	ent = createExploder( "ny_column_base" );
	ent.v[ "origin" ] = ( -10891.1, -14865.2, -240 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "ny_column_base";
	ent.v[ "delay" ] = 0;
	ent.v[ "exploder" ] = "25000";


	ent = createExploder( "ny_column_base" );
	ent.v[ "origin" ] = ( -28590.8, 71.8475, -274.486 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "ny_column_base";
	ent.v[ "delay" ] = 0;
	ent.v[ "exploder" ] = "25000";

	ent = createExploder( "ny_column_base" );
	ent.v[ "origin" ] = ( -23339, -5804.85, 2839.72 );
	ent.v[ "angles" ] = ( 270, 0, 0 );
	ent.v[ "fxid" ] = "ny_column_base";
	ent.v[ "delay" ] = 0;
	ent.v[ "exploder" ] = "25000";

	*/
	for(i=0;i<smoke_org.size;i++)
	{
		if(isdefined(smoke_col_a[i]))
		{
			smoke_col = smoke_col_a[i];
			smoke_col.animname = "smoke_column";
			smoke_col.origin = smoke_org[i];
			smoke_col  setAnimTree();
			thread surface_col_thread(smoke_col);
		}
	}
	//delete any smoke column entities not used
	starting_num = smoke_org.size;
	total_bases = smoke_col_a.size+1;
	for(i=starting_num;i<total_bases;i++)
	{
		if(isdefined(smoke_col_a[i]))
		{
			smoke_col_a[i] delete();
		}
	}
	
}

surface_player_water_sheeting()
{
	level.player SetWaterSheeting( 2, 7.0 );
}

surface_player_water_sheeting_timed(time)
{
	level.player SetWaterSheeting( 2, time );
}

surface_sub_breach_lerpsunlight(currlight,targetlight,time)
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
	}
	setsunlight(targetlight[0],targetlight[1],targetlight[2]);
}

surface_sub_breach_sunanim(target_sun_dir)
{
	sub = level.russian_cine_sub;
		
	old_sun_dir = vectornormalize((.88,.5,.82));//heading at 30
	mid_sun_dir = vectornormalize((.34,.939,.82));//heading at 70
	final_sun_dir = vectornormalize((-.34,.939,.62));//heading at 110
	
	//set temporary visionset & lerp back to the normal one
	map_sunlight = getmapsunlight();	
	amp_sunlight = vectornormalize((map_sunlight[0],map_sunlight[1],map_sunlight[2]))*2.25;
	setsundirection(target_sun_dir);
	
	//set the glow and amped light
	level.sdv_player_arms waittillmatch( "single anim", "waterout" );
	thread vision_set_fog_changes( "ny_harbor_surfacing", 0 );
	level waitframe();
	thread surface_player_water_sheeting_timed(2.0);
	
	wait(2.05);
	//thread vision_set_fog_changes( "ny_harbor_surfacing", .5 );
	map_sunlight = getmapsunlight();	
	amp_sunlight = vectornormalize((map_sunlight[0],map_sunlight[1],map_sunlight[2]))*2.25;
	//setsunlight(amp_sunlight[0],amp_sunlight[1],amp_sunlight[2]);
	
	sub waittillmatch("single anim","breach_impact");
	//thread surface_sub_breach_lerpsunlight(amp_sunlight,(map_sunlight[0],map_sunlight[1],map_sunlight[2]),6.0);
	lerpSunDirection(old_sun_dir,mid_sun_dir,6.3);
	wait(6.3);
	lerpSunDirection(mid_sun_dir,final_sun_dir,2);
	level.player waittill( "stop_breathing" ); 
	resetsundirection();	
	
	}

surface_sub_breach_moment()
{

	//Setup the different water patches for the breach
	hires_nonfoamy_water = getent("dyn_water_breachpatch_high","script_noteworthy");
	hires_nonfoamy_waterbak = getent("dyn_water_breachpatch2_high","targetname");
	hires_foamy_water = getent("dyn_water_breachpatchfoamy_high","script_noteworthy");
	hires_foamy_waterbak = getent("dyn_water_breachpatchfoamy2_high","targetname");
	lores_nonfoamy_water = getent("dyn_water_breachpatch_low","script_noteworthy");
	hires_nonfoamy_water hide();
	hires_foamy_water show();
	hires_nonfoamy_waterbak hide();
	hires_foamy_waterbak delete();
	lores_nonfoamy_water show();

	//setup the hires script models
	//hires_nonfoamy_water_maya = getent("dyn_water_breachpatch_bighigh","targetname");
	//hires_foamy_water_maya = getent("dyn_water_breachpatchfoamy_bighigh","targetname");
	//hires_nonfoamy_water_maya hide();
	//hires_foamy_water_maya hide();
	
	hires_foamy_water.origin = (-35356, -20967, -240);

	wait(1.0);


	//Setup the different animated waves
	
	
	wave_front_ent = getent("fx_nyharbor_wave_front","targetname");
	wave_side_ent = getent("fx_nyharbor_wave_side","targetname");
	wave_disp_ent = getent("fx_nyharbor_wave_displace","targetname");
	wave_crashing_ent = getent("fx_nyharbor_wave_crashing","targetname");
	wave_front_ent hide();
	wave_side_ent hide();
	wave_disp_ent hide();
	wave_crashing_ent hide();
	
	
	//Set up the wave patch animation
	node = getent("sub_breach_anim_node", "targetname" );
	scriptnode = spawn( "script_origin", node.origin + (0,0,-96) );
	scriptnode.angles = node.angles;
	
	scriptnode2 = spawn( "script_origin", node.origin + (0,0,-96) );
	scriptnode2.angles = node.angles;
	wave_side_ent.animname = "wave_side";
	wave_side_ent  setAnimTree();
	wave_front_ent.animname = "wave_front";
	wave_front_ent  setAnimTree();
	wave_disp_ent.animname = "wave_displace";
	wave_disp_ent  setAnimTree();
	wave_crashing_ent.animname = "wave_crashing";
	wave_crashing_ent  setAnimTree();
	
	ents = [wave_side_ent,wave_front_ent, wave_crashing_ent];//, wave_disp_ent ];
	ents2 = [ wave_disp_ent ];
	scriptnode thread anim_first_frame(ents,"wave");
	scriptnode2 thread anim_first_frame(ents2,"wave");
	
	wave_front_ent hide();
	wave_side_ent hide();
	wave_disp_ent hide();
	wave_crashing_ent hide();


	//Set up the fx whitewater fx
	chainoverride =  spawnstruct();
	chainoverride.v["name"] = "sub_override";
	chainoverride.v["wake"] = ["tag_fx_wake","tag_fx_wake1","tag_fx_wake2","tag_fx_wake3","tag_fx_wake4","tag_fx_wake5","tag_fx_wake6"];
	args = spawnstruct();
	args.v["ent"]=wave_side_ent;
	args.v["fx"]=getfx("ny_harbor_wavech");
	args.v["chain"]="wake";//valid chains are head, r_arm, l_arm, torso, r_leg, l_leg, and all
	args.v["looptime"]=.04;//how often to loop this fx along the length of the bone
	args.v["chainset_name"]="sub_override";//defaults to "default" - specify a custom boneset (skeleton) if necessary
	args.v["chainset_override"]=chainoverride;//defaults to undefined - define a custom boneset (skeleton) if necessary
											// chainset_name must be "override" if defining a override here



	
	flag_wait( "sub_breach_started" ); //wait until the cine sub is spawned to avoid errors

	/*
	FRAMERATE MEASURES - bringing in shadows
	stoping ambient fx - everything is reset in surface_dvora_destroyfx
	*/
	//stop the land and water explosions
	level notify("msg_nyharbor_stoplandexplosions");
	level notify("msg_nyharbor_stopwaterexplosions");
	level notify("msg_fx_stop_slava_missiles");



	
	//Have to animate the sun to get specular on the water
	curr_sun_dir = getMapSunDirection();
	new_sun_dir = vectornormalize((.88,.5,.82));//(-39,36,0);
	thread surface_sub_breach_sunanim(new_sun_dir);
	
	
	
	level.sdv_player_arms waittillmatch( "single anim", "waterout" );
	ripple_tag = spawn_tag_origin();
	ripple_tag.origin = level.sdv_player_arms.origin + (0,0,40);
	ripple_tag.angles = (270,0,0);
	ripple_tag linkto(level.sdv_player_arms);
	playfxontag(getfx("ny_sub_playerwaterripple"),ripple_tag,"tag_origin");

	//Move foamy water back to the original position
	//hires_foamy_water.origin -= bake_vector;
	hires_nonfoamy_water show();
	hires_foamy_water hide();
	lores_nonfoamy_water hide();
	hires_nonfoamy_waterbak show();
	//hires_nonfoamy_water_maya show();
	//hires_foamy_water_maya hide();


	
	
	
	sub = level.russian_cine_sub;
	
	sub waittillmatch("single anim","start_pre_displace");
	
	//start the displace wave
	flag_set( "sub_surface_rumble" );
	wave_disp_ent show();
	displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], (-35271, -21133, -224) );
	scriptnode2.origin = (node.origin + (0,0,displacement-118));
	scriptnode2 thread anim_single(ents2,"wave");
	
	
	
	
	//Wait for sub wave anim message and launch anim
	sub waittillmatch("single anim","start_wave_anim");

	level notify("msg_breach_fx_started");
	
	//Start the animated waves
	wave_side_ent show();
	wave_front_ent show();
	wave_disp_ent show();
	//wave_crashing_ent show();
	scriptnode thread anim_single(ents,"wave");
	
	
	//ramp down our lighting to get framerate
	level.old_shadow_scale = getdvarfloat("sm_sunshadowscale");
	setsaveddvar("sm_sunshadowscale",.4);

	
	
	//start the giant splash fx
	exploder(222);//initial main breach fx
	xupbowtag = spawn_tag_origin();
	xupbowtag.angles = (270,0,0);
	xupbowtag.origin = sub gettagorigin("tag_fx_bow2");
	xupbowtag linkto(sub,"tag_fx_bow2");
	playfxontag(getfx("ny_sub_breachMainBow"),xupbowtag,"tag_origin");
	gush_tagA = spawn_tag_origin();
	gush_tagA.origin = sub gettagorigin("body");
	gush_tagA.angles = sub gettagangles("body");
	gush_tagA linkto(sub,"body",(2226,-216,221),(0,0,0));
	playfxontag(getfx("ny_sub_breachmainBow_gush"),gush_tagA,"tag_origin");
	
	
	//Start playing fx on the wave that washes over the player (the side)
	kill_notify = play_fx_on_actor(args);//this will return the level notify to kill the fx
	wait(.1);
	level thread screenshake(.25,1,.5,.3);
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
	}

	//Play the fx along the side of the sub - basically the wake as it moves
	sub waittillmatch("single anim","breach_water");
	chainoverride.v["wake"] = ["tag_fx_wave","tag_fx_wave1","tag_fx_wave2","tag_fx_wave3","tag_fx_wave4","tag_fx_wave5"];
	args.v["ent"]=wave_front_ent;
	args.v["fx"]=getfx("ny_harbor_wavelargech");
	args.v["chainset_override"]=chainoverride;
	args.v["looptime"]=.08;
	kill_notify2 = play_fx_on_actor(args);//this will return the level notify to kill the fx
	exploder(220);//initial breach fx
	playfxontag(getfx("ny_sub_fingush"),sub,"tag_fx_elevator");
	playfxontag(getfx("ny_sub_towerbase"),sub,"tag_fx_towerbase");
	
	//Add additional flowing water
	gush_tagB = spawn_tag_origin();
	gush_tagB.origin =  sub gettagorigin("tag_origin");
	gush_tagB.angles =  sub gettagangles("tag_origin");
	gush_tagB linkto(sub,"body",(-1130,0,233),(0,0,0));
	gush_tagC = spawn_tag_origin();
	gush_tagC.origin = gush_tagB.origin;
	gush_tagC.angles = gush_tagB.angles;
	gush_tagC linkto(sub,"body",(-708,0,233),(0,0,0));
	gush_tagD = spawn_tag_origin();
	gush_tagD.origin = gush_tagB.origin;
	gush_tagD.angles = gush_tagB.angles;
	gush_tagD linkto(sub,"body",(0,0,280),(0,0,0));
	
	playfxontag(getfx("ny_sub_directionalgushes"),gush_tagA,"tag_origin");

	//Start playing the displacement fx & whitewater that washes down it
	wave_disp_ent waittillmatch("single anim","breach_displace_fx");
	chainoverride.v["wake"] = ["tag_fx_wake_","tag_fx_wake_1","tag_fx_wake_2","tag_fx_wake_3","tag_fx_wake_4"];
	args.v["ent"]=wave_disp_ent;
	args.v["fx"]=getfx("ny_harbor_wavelargech2");
	args.v["chainset_override"]=chainoverride;
	args.v["looptime"]=.04;
	wait(.5);
	//kill_notify3 = play_fx_on_actor(args);//this will return the level notify to kill the fx
	wait(.5);
	level thread screenshake(.25,1,.3,.53);
	wait(.25);
	
	
	//The froth on the side of the sub to hide the intersection of the water
	//	and the sub
	playfx(getfx("ny_sub_sidefroth_before"),(-34172,-20987,-260),anglestoforward((0,0,0)));
	playfx(getfx("ny_sub_sidefroth_before"),(-34372,-20987,-260),anglestoforward((0,0,0)));
	playfx(getfx("ny_sub_sidefroth_before"),(-34572,-20987,-260),anglestoforward((0,0,0)));
	playfx(getfx("ny_sub_sidefroth_before"),(-34772,-20987,-260),anglestoforward((0,0,0)));
	playfx(getfx("ny_sub_sidefroth_before"),(-34972,-20987,-260),anglestoforward((0,0,0)));
	playfx(getfx("ny_sub_sidefroth_before"),(-35172,-20987,-260),anglestoforward((0,0,0)));
	
	level waitframe();
		
	playfx(getfx("ny_sub_sidefroth_before"),(-35272,-20987,-260),anglestoforward((0,0,0)));
	playfx(getfx("ny_sub_sidefroth_before"),(-35372,-20987,-260),anglestoforward((0,0,0)));

	playfxontag(getfx("ny_sub_fin_wisp"),gush_tagB,"tag_origin");
	playfxontag(getfx("ny_sub_fin_wisp"),gush_tagC,"tag_origin");
	playfxontag(getfx("ny_sub_fin_wisp"),gush_tagD,"tag_origin");
	
	


	//Swap out the clear water for the foamy water
	hires_nonfoamy_water hide();
	hires_nonfoamy_waterbak show();
	hires_foamy_water show();
	lores_nonfoamy_water hide();
	//hires_nonfoamy_water_maya hide();
	//hires_foamy_water_maya show();
	//hires_foamy_waterbak show();

	//Reset sun direction
	//lerpSunDirection(new_sun_dir,curr_sun_dir,3.0);


	
	//play blur when the player is hit with the wave
	thread surface_player_water_sheeting_timed(3.75);
	//kill the displacement fx
	//level notify(kill_notify3);
	
	//Play the breach impact fx
	sub waittillmatch("single anim","breach_impact");

	//start animating the sun back to normal

	level notify("msg_breach_fx_ended");

	level notify(kill_notify);
	scriptnode Delete();
	level notify(kill_notify2);
	wait(.5);
	exploder(221);//final breach impact
	level thread screenshake(.35,1.5,.3,.53);
	wait(.5);

	playfxontag(getfx("ny_sub_sideport_4"),sub,"tag_fx_ventback_single7");
	//play fx on tail to cover intersection of waves
	//tail_dummy = spawn_tag_origin();
	//tail_dummy linkto(sub,"tag_origin",(-2406.3, -180.7, -20.535), ( 288.103, 186.437, -6.33035 ));
	//playfxontag(getfx("sub_foam_lapping_waves"),tail_dummy, "tag_origin");

	wait(.5);
	thread surface_player_water_sheeting_timed(4.75);//using a custom one with more blur


	playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear2");
	playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear3");
	playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear4");
	playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear5");

	
	//cleanup	
	wave_front_ent delete();
	wave_side_ent delete();
	wave_disp_ent delete();
	wait 2;
	playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear6");
	playfxontag(getfx("ny_sub_damage_smoke"),sub,"tag_fx_damage_smoke");
	wait 1;


	
	//Reset the shadow values
	setsaveddvar("sm_sunshadowscale",level.old_shadow_scale);


	
	
	wait 2.5;

	playfxontag(getfx("ny_sub_sidefroth"),sub,"tag_fx_foamrear1");


	//play tail foam fx
	exploder(26011);
	wait 1;
	playfxontag(getfx("sub_foam_lapping_waves"),sub, "tag_fx_tail_foam");
	playfxontag(getfx("sub_breaching_tail_steam"),sub, "tag_fx_tail_foam");
	wait 5.35;
	thread surface_player_water_sheeting_timed(3.75);
	//Start the building hit sequence
	//sub waittillmatch("single anim","breach_rebound");
	//message sent while mask is removed
	level.player waittill( "stop_breathing" ); 
	stopfxontag(getfx("ny_sub_damage_smoke"),sub,"tag_fx_damage_smoke");
	
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( false );
	}


	//start the land and water explosions up again
	level thread start_harbor_landexplosions();
	level thread start_harbor_waterexplosions();
	level thread play_slava_missiles();




	
	hires_nonfoamy_water hide();
	hires_foamy_water hide();
//	hires_foamy_waterbak hide();
	hires_nonfoamy_waterbak hide();
	lores_nonfoamy_water show();
	
	stopfxontag(getfx("sub_foam_lapping_waves"),sub, "tag_fx_tail_foam");
	stopfxontag(getfx("sub_breaching_tail_steam"),sub, "tag_fx_tail_foam");
	
	
	
	wait(27.8);
	level notify("start_surface_missile_fx");
}
	
surface_sub_hatch_moment()
{
	//called from ny_harbor_code_sub::sub_entrance()
	//seting the guy on fire
	ent = undefined;
	wait(.1);
	trigger = getent("fx_id_smokeguy","targetname");
	get_guys = getentarray("actor_enemy_opforce_navy_short_P90","classname");
	foreach( curr in get_guys)
	{
		if(isdefined(curr) && isdefined(trigger))
		{
			if(curr istouching(trigger)) 
				ent = curr;
		}
	}
	//ent = e695;
	if(isdefined(ent))
	{
		args = spawnstruct();
		args.v["ent"]=ent;
		args.v["fx"]=getfx("ny_harbor_actor_smoke");
		args.v["chain"]="all";
		args.v["looptime"]=.16;
		notify1 = play_fx_on_actor(args);
		args.v["ent"]=ent;
		wait(2.0);
		level notify(notify1);
	}
	
	level.sandman waittillmatch("single anim","show");//wait 99 frames after this
	wait(3.3);
	level thread screenshake(.25,1,.3,.53);
	exploder(247);
	
	
	
}


surface_sub_ambient_fx()
{
	to1 = spawn_tag_origin();
	to1.origin = self.player getorigin();
	to1.angles = ( 270, 0, -45);
	wait(1);
	for(;;)
	{
		flag_wait("fx_zone_26000_active");
		flag_waitopen_both("fx_zone_5000_active","fx_zone_6000_active");
		level.sandman waittillmatch("single anim","show");//wait 99 frames after this
		wait(5.0);
		randomInc = randomfloatrange(-1.5,1.5)+2.0;
		wait(randomInc);
		splashes = get_exploder_entarray(600);
		choosesplash = splashes[randomint((splashes.size+1))];
		if(isdefined(choosesplash))
		{
//			event = ge_AddFxNotifyWait( "activate", "cancel", "kill", [114, 0] /* cost[fxelem,trailelem] */, 20 /*priority*/, "ambientsurface", "seaMist" );
			big_splash = choosesplash activate_individual_exploder();
			aud_send_msg("big_splash", big_splash);
//			thread ge_EventFinished(event, 2);
		}
	}
}


surface_waterexp_res(exp_pos)
{
	//lo-res particles on the ps3 for 3 seconds - while the explosion is in view
	if(!isdefined(level.halfresfxon)) level.halfresfxon = 0;
	new_target = exp_pos + (0,0,48);//
	to_target = (new_target-level.player.origin);
	to_target_l = length(to_target);
	to_target_n = vectornormalize(to_target);
	eye = vectornormalize(anglestoforward(level.player.angles));
	ratio = vectordot(to_target_n,eye);
	if(ratio>.3 && to_target_l<1000)
	{
		if ( ( level.Console && level.ps3 ) || !level.Console )
		{
			SetHalfResParticles( true );
			level.halfresfxon ++;
		}
		wait 2.0;
		if ( ( level.Console && level.ps3 ) || !level.Console )
		{
			if(level.halfresfxon<2) SetHalfResParticles( false );
			level.halfresfxon --;
		}
	}
	
	
}

surface_dvora_carrier_fx()
{
	//start the wake from the carrier slide dvora
	chainoverride =  spawnstruct();
	chainoverride.v["name"] = "dvora_wake";
	chainoverride.v["wake"] = ["tag_wave_r1","tag_wave_r2","tag_wave_r3"];
	args = spawnstruct();
	args.v["ent"]=self;
	args.v["fx"]=getfx("ny_harbor_wavech");
	args.v["chain"]="wake";//valid chains are head, r_arm, l_arm, torso, r_leg, l_leg, and all
	args.v["looptime"]=.04;//how often to loop this fx along the length of the bone
	args.v["chainset_name"]="dvora_wake";//defaults to "default" - specify a custom boneset (skeleton) if necessary
	args.v["chainset_override"]=chainoverride;//defaults to undefined - define a custom boneset (skeleton) if necessary
		// chainset_name must be "override" if defining a override here
		
	//kill_notify = play_fx_on_actor(args);
	
	//Tag used for wake spray
	fx_tag = spawn_tag_origin();
	fx_tag.origin = self gettagorigin("tag_body");
	fx_tag.angles = self gettagangles("tag_body");
	//temp_angles = vectortoangles((-38135,-11469,-188)-(-40283,-13055,-188));
	//fx_tag linkto(self,"tag_body",(249,-70,-33),(0,0,0));
	fx_tag thread updatepos(self,5,0);
	
	//Tag used for foam trail - zup space - no displacement
	fx_tag2 = spawn_tag_origin();
	fx_tag2.origin = fx_tag.origin;
	fx_tag2.angles = fx_tag.angles;
	fx_tag2 thread updatepos(self,5,0);

	//Tag used for foam trail - xup space - no displacement
	fx_tag3 = spawn_tag_origin();
	fx_tag3.origin = fx_tag.origin;
	temp_angles = vectortoangles((-38135,-11469,-188)-(-40283,-13055,-188));
	fx_tag3.angles = combineangles((temp_angles),(270,0,0));
	//fx_tag3 linkto(self,"tag_origin");
	fx_tag3 thread updatepos(self,5,0);
	
	level waitframe();
	

	level waittill("msg_fx_start_carrierfx");//wait til the bump fx have finished to start

	//
	PauseFXID( "burning_oil_slick_1" );

	//first setup a wakefx in back
	playfxontag(getfx("ny_dvora_wakestern_trail"),self,"tag_propeller_fx");
	
	
	//kill_notify = play_fx_on_actor(args);
	//first setup a wakefx in back
	playfxontag(getfx("ny_dvora_wakebow"),fx_tag,"tag_origin");
	playfxontag(getfx("ny_dvora_wakebow_trail"),fx_tag2,"tag_origin");
	playfxontag(getfx("ny_dvora_wakebow_trailxup"),fx_tag3,"tag_origin");
	self waittill( "dvora_destroyed" );
	stopfxontag(getfx("ny_dvora_wakebow"),fx_tag,"tag_origin");
	stopfxontag(getfx("ny_dvora_wakestern_trail"),self,"tag_propeller_fx");
	level waitframe();	
	playfxontag(getfx("ny_dvora_wakebow2"),fx_tag,"tag_origin");
	level waitframe();
	playfxontag(getfx("ny_dvora_wakestern_trail2"),self,"tag_propeller_fx");
	level waittill("msg_fx_stop_cin_dvorafx");
	fx_tag2 notify("fx_stop_updatepos");
	fx_tag3 notify("fx_stop_updatepos");
	//level notify(kill_notify);
	stopfxontag(getfx("ny_dvora_wakebow2"),fx_tag,"tag_origin");
	stopfxontag(getfx("ny_dvora_wakebow_trail"),fx_tag2,"tag_origin");
	stopfxontag(getfx("ny_dvora_wakebow_trailxup"),fx_tag3,"tag_origin");
	stopfxontag(getfx("ny_dvora_wakestern_trail2"),fx_tag,"tag_origin");
	fx_tag delete();
	fx_tag2 delete();
	fx_tag3 delete();


}

updatepos(parent, f_zoffset, i_usedisplacement)
{
	self endon("fx_stop_updatepos");
	dis_on = 0;
	zoffset = 0;
	if(isdefined(i_usedisplacement)) dis_on = i_usedisplacement;
	if(isdefined(f_zoffset)) zoffset = f_zoffset;
	for(;;)
	{
	origin = parent gettagorigin("tag_body");
	angles = parent gettagangles("tag_body");
	origin += anglestoforward(angles) * 250;
	displacement = 0;
	if(dis_on)
	{
		displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], origin );
	}
	if(isdefined(self))
	{
	self moveto((origin[0],origin[1],displacement + zoffset),.12);
	}
	wait(.12);
	}
}


surface_escape_zodiac_bumbfx()
{
	/*
	FRAMERATE MEASURES - bringing in shadows
	stoping ambient fx - everything is reset in surface_dvora_destroyfx
	*/
	//stop the land and water explosions
	level notify("msg_nyharbor_stoplandexplosions");
	level notify("msg_nyharbor_stopwaterexplosions");
	level notify("msg_fx_stop_slava_missiles");
	
	//stop fires on the buildings to get particle count back
	kill_exploder(242);
	kill_exploder(252);
	
	//ramp down our lighting to get framerate
	level.old_shadow_scale = getdvarfloat("sm_sunshadowscale");
	setsaveddvar("sm_sunshadowscale",.35);



	//Need to play a crash splash when the dvora hits the zodiac
	//Also need to play it twice because the player teleports from one
	//zodiac to another
	bump_fx_tag = spawn_tag_origin();
	bump_fx_tag.origin = self gettagorigin("tag_wheel_front_left");
	bump_fx_tag.angles = combineangles(self gettagangles("tag_origin"),(270,0,0));
	bump_fx_tag linkto(self,"tag_wheel_front_left");
	
	playfxontag(getfx("ny_dvora_zodiac_bump"),bump_fx_tag,"tag_origin");
	wait(.25);
	bump_fx_tag2 = spawn_tag_origin();
	bump_fx_tag2.origin = level.escape_zodiac_fx gettagorigin("tag_wheel_front_left");
	bump_fx_tag2.angles = combineangles(level.escape_zodiac_fx gettagangles("tag_wheel_front_left"),(270,0,0));
	bump_fx_tag2 linkto(level.escape_zodiac_fx,"tag_wheel_front_left",(0,0,0),(0,0,0));
	level thread screenshake(.35,1,.3,.53);
	//thread surface_player_water_sheeting();//using a custom one with more blur
	playfxontag(getfx("ny_dvora_zodiac_bump"),bump_fx_tag2,"tag_origin");
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
		level.halfresfxon ++;
	}
	wait(1.3);
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		if(level.halfresfxon<2) SetHalfResParticles( false );
		level.halfresfxon --;
	}	
	
	//Send message to start the carrier fx
	level notify("msg_fx_start_carrierfx");
	
	//clean up
	bump_fx_tag delete();
	bump_fx_tag2 delete();
}

surface_zbur_treadfx()
{
	//first setup a wakefx in back
	playfxontag(getfx("zubr_wake_nyharbor"),self,"tag_wake");
	fxtagright = spawn_tag_origin();
	fxtagright.origin = self gettagorigin("tag_wheel_back_right");
	fxtagright.angles = self gettagangles("tag_wheel_back_right");
	fxtagright linkto(self,"tag_wheel_back_right",(0,0,50), (0,0,0) );
	fxtagleft = spawn_tag_origin();
	fxtagleft.origin = self gettagorigin("tag_wheel_back_right");
	fxtagleft.angles = self gettagangles("tag_wheel_back_right");
	fxtagleft linkto(self,"tag_wheel_back_left",(0,0,-50),(0,0,0) );
	playfxontag(getfx("zubr_wakeside_nyharbor"),fxtagright,"tag_origin");
	playfxontag(getfx("zubr_wakeside_nyharbor"),fxtagleft,"tag_origin");
	//do cleanup after death
	self waittill_either ("death", "stop_fx" );
	//stopfxontag(getfx("zubr_wake_nyharbor"),self,"tag_wake");
	stopfxontag(getfx("zubr_wakeside_nyharbor"),fxtagright,"tag_origin");
	stopfxontag(getfx("zubr_wakeside_nyharbor"),fxtagleft,"tag_origin");
	fxtagright delete();
	fxtagleft delete();
}

surface_dvora_displace_wake(dvora)
{
	dvora endon("death");
	for(;;)
	{
		if(isdefined(self))
		{
			curr_origin = dvora gettagorigin("tag_propeller_fx");
			displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], curr_origin );
			origin = (curr_origin[0], curr_origin[1], -225);
			angles = dvora gettagangles("tag_propeller_fx");
			self.angles = angles;
			origin += anglestoforward(angles) * -150;
			self moveto((origin[0],origin[1],displacement-300),.2);
			wait(.2);
		}
	}
}
surface_dvora_treadfx()
{
	fxtag = spawn_tag_origin();
	fxtag.origin = self gettagorigin("tag_propeller_fx");
	fxtag.angles = self gettagangles("tag_propeller_fx");
	fxtag thread surface_dvora_displace_wake(self);
	
	//first setup a wakefx in back
	//playfxontag(getfx("dvora_wakeside_nyharbor"),self,"tag_wheel_front_right");
	//playfxontag(getfx("dvora_wakeside_nyharbor"),self,"tag_wheel_front_left");
	playfxontag(getfx("dvora_wake_nyharbor"),fxtag,"tag_origin");
	
	level endon("msg_fx_stop_cin_dvorafx");
	
	//do cleanup after death
	self waittill("death");
	//stopfxontag(getfx("dvora_wakeside_nyharbor"),self,"tag_wheel_front_right");
	//stopfxontag(getfx("dvora_wakeside_nyharbor"),self,"tag_wheel_front_left");
	stopfxontag(getfx("dvora_wake_nyharbor"),fxtag,"tag_origin");
	fxtag delete();
	
}

surface_sub_tail_foam()
{
	waitframe();
	if(level.createfx_enabled) return 0;
	foam_origin = ( -40344.3, -23924.7, -235.465 );
	foam_angles = ( 288.103, 186.437, -6.33035 );
	thread surface_sub_tail_foam_slide(foam_origin, foam_angles);
	}

surface_sub_tail_foam_slide(foam_origin, foam_angles)
{
	flag_wait("msg_vfx_surface_zone_26000");
	fxtag = spawn_tag_origin();
	fxtag.origin = foam_origin;
	fxtag.angles = foam_angles;
	playfxontag(getfx("sub_foam_lapping_waves"), fxtag, "tag_origin");
	flag_waitopen("msg_vfx_surface_zone_26000");
	stopfxontag(getfx("sub_foam_lapping_waves"), fxtag, "tag_origin");
	fxtag delete();
	
}
surface_sub_tail_foam_slide_update(fxtag)
{
	foam_origin = fxtag.origin;
	for(;;)
	{
		if(isdefined(fxtag))
		{
			flag_wait("msg_vfx_surface_zone_26000");
			displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], foam_origin );
			origin = foam_origin;
			//self.angles = angles;
			//origin += anglestoforward(angles) * -150;
			origin += anglestoup(fxtag.angles) * (displacement * 2);
			fxtag moveto((origin),.1);
			//print("***********************displacement amount is " + displacement + "\n");
			wait(.1);
		}
	}
}

surface_dvora_npc_hit(dvora,num)
{
	damage = undefined;
	attacker = undefined;
	direction_vec = undefined;
	point = undefined;
	type = undefined;
	modelName = undefined;
	tagName = undefined;
	partName = undefined;
	dflags = undefined;
	self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	blood_tag = spawn_tag_origin();
	blood_tag.origin = self gettagorigin("j_spine4");
	blood_tag.angles = vectortoangles(direction_vec);
	blood_tag linkto(self,tagName);
	playfxontag(getfx("ny_harbor_dvora_bloodhit"),blood_tag,"tag_origin");
	if(num==3)
	{
		playfxontag(getfx("ny_harbor_dvora_bloodsplat"),dvora,"tag_guy3");
	}
	wait(2);
	blood_tag delete();
	

}

surface_dvora_npc_hit_thread()
{
	i = 0;
	foreach(rider in self.riders)
	{
		rider thread surface_dvora_npc_hit(self,i); 
		i++;
	}
}


surface_dvora_flash()
{
	currVis = getdvar("vision_set_current");
	visionsetnaked("generic_flash",.08);
	wait(.17);
	visionsetnaked(currVis,.08);
}

surface_dvora_post_carrier_coverpop()
{

	level waittill("msg_fx_play_lastsplash");
	wait(2.0);
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		SetHalfResParticles( true );
		level.halfresfxon ++;
	}
	wait(2.0);
	if ( ( level.Console && level.ps3 ) || !level.Console )
	{
		if(level.halfresfxon<2) SetHalfResParticles( false );
		level.halfresfxon --;
	}	wait(2.0);
	vel_mult = 20;
	for_mult = 600;
	curr_pos = level.player.origin;
	curr_forward = anglestoforward(level.player.angles);
	vel = ((level.player getvelocity())/20.00)+(1,0,0);
	vel_vect = vectornormalize(vel);
	//side_offset = vectorcross(curr_forward,(0,0,1));
	for_mult = 1000;
	target_pos = curr_pos + curr_forward * for_mult + vel * vel_mult;// + random
	displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], target_pos );
	target_pos1 = (target_pos[0],target_pos[1],displacement-260);// + random
	playfx(getfx("ny_harbor_dvora_fallingchunks"),target_pos1,(0,0,1),vel_vect);
	playfxontag(getfx("ny_dvora_finalexplosion_splash"),level.z_rail_1,"tag_origin");



}

chinook_board_coverpop()
{
	level waittill("msg_fx_play_chinook_board_coverpop");

	wait 1.1;
	if (isdefined(level.escape_zodiac))
		playfxontag(getfx("ny_dvora_finalexplosion_splash"),level.escape_zodiac,"tag_origin");
	thread surface_player_water_sheeting_timed(2.0);
}

surface_dvora_post_carrier_waterhits()
{
	for(i=0;i<8;i++)
	{
		vel_mult = 20;
		for_mult = 600;
		curr_pos = level.player.origin;
		curr_forward = anglestoforward(level.player.angles);
		vel = ((level.player getvelocity())/20.00)+(1,0,0);
		vel_vect = vectornormalize(vel);
		side_offset = vectorcross(curr_forward,(0,0,1));
		if(i<5) for_mult = 1000;
		target_pos = curr_pos + curr_forward * for_mult + vel * vel_mult + side_offset * (-250 + 500 * randomfloat(1.0));// + random
		displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], target_pos );
		target_pos1 = (target_pos[0],target_pos[1],displacement-260);// + random
		aud_send_msg("dvora_post_carrier_splashes", target_pos1);
		playfx(getfx("ny_harbor_dvora_fallingchunks"),target_pos1,(0,0,1),vel_vect);
		thread surface_waterexp_res(target_pos1);
		wait(1);
	}
}


surface_dvora_debris_atplayer()
{
	vfx_vel = 4000.0;
	target = level.escape_zodiac gettagorigin("tag_origin");
	source = self gettagorigin("tag_origin");
	init_distance = distance(target , source);
	init_time = init_distance / vfx_vel;
	target += ((level.player getvelocity())/20.0) * init_time;
	l_vector = target-source;
	nl_vector = vectornormalize(l_vector);
	playfx(getfx("ny_harbor_dvora_debrisatplayer"),source,nl_vector,(0,0,1));
}

surface_dvora_chunk_splash(ent,tag,frame)
{
	waittime = (frame - 8  - 450.00) / 30.0;
	wait(waittime);
	lastpos = ent gettagorigin(tag);
	level waitframe();
	org = ent gettagorigin(tag);
	xydiff = (org - lastpos);
	org += (xydiff[0],xydiff[1],0)*7;
	playfx(getfx("ny_dvora_debris_splash"),(org[0],org[1],-252),(0,0,1),(1,0,0));
}
surface_dvora_chunk_splash_watcher(A,B)
{
	//start animating the secondary splashes
	//starts at 450
	thread surface_dvora_chunk_splash(B,"chunk3_11",497);//chunk3_10 -frame 525
	thread surface_dvora_chunk_splash(A,"chunk2_6",501);//chunk 2_6 -frame 501
	thread surface_dvora_chunk_splash(A,"chunk2_17",506);//cunnk2_17 - frame 506
	thread surface_dvora_chunk_splash(A,"chunk2_14",514);//chunk2_14 - frame514
	thread surface_dvora_chunk_splash(B,"chunk3_1",521);//chunk3_1 - frame 521
	thread surface_dvora_chunk_splash(A,"chunk2_11",522);//chunk2_11 - frame 522
	thread surface_dvora_chunk_splash(B,"chunk3_8",524);//chunk3_8 - frame 524
	//thread surface_dvora_chunk_splash(B,"chunk3_6",524);//chunk3_6 - frame 524
	thread surface_dvora_chunk_splash(B,"chunk3_10",525);//chunk3_10 -frame 525
	thread surface_dvora_chunk_splash(B,"chunk3_9",527);//chunk3_9 - frame 527
	thread surface_dvora_chunk_splash(B,"chunk3_4",530);//chunk3_4 - frame 530
}

surface_dvora_chunk_firetrail(ent,tag,frame)
{
	waittime = (frame  - 450.00) / 30.0;
	wait(waittime);
	playfxontag(getfx("ny_harbor_dvora_chunkemitter"),ent,tag);
}

surface_dvora_chunk_firetrail_watcher(A,B)
{
	thread surface_dvora_chunk_firetrail(A,"chunk2_3",455);//"chunk2_12" 451
	thread surface_dvora_chunk_firetrail(A,"chunk2_14",461);//"chunk2_12" 451
	thread surface_dvora_chunk_firetrail(A,"chunk2_17",463);//"chunk2_12" 451
	thread surface_dvora_chunk_firetrail(A,"chunk2_6",458);//"chunk2_12" 451
	
	thread surface_dvora_chunk_firetrail(A,"chunk2_12",451);//"chunk2_12" 451
	thread surface_dvora_chunk_firetrail(A,"chunk2_11",468);//"chunk2_12" 468
	thread surface_dvora_chunk_firetrail(B,"chunk3_4",470);//"chunk3_4" 470
	thread surface_dvora_chunk_firetrail(B,"chunk3_9",470);//"chunk3_9" 470 
	thread surface_dvora_chunk_firetrail(B,"chunk3_8",470);//"chunk3_8" 470
	thread surface_dvora_chunk_firetrail(B,"chunk3_5",478);//"chunk3_5" 478
	thread surface_dvora_chunk_firetrail(B,"chunk3_6",478);//"chunk3_6" 478 
	thread surface_dvora_chunk_firetrail(B,"chunk3_10",478);//"chunk3_10" 478
}

surface_dvora_hideparts()
{
	level waitframe();
	level waitframe();
	chunkA_ent = getent("vehicle_russian_super_dvora_mark2_destroyA","targetname");
	chunkB_ent = getent("vehicle_russian_super_dvora_mark2_destroyB","targetname");
	chunkA_ent hide();
	chunkB_ent hide();
}


surface_dvora_destroy_fx(org)
{
	//self should be the dvora
	//Play add on animation here
	boats = [];
	boats[0] = self;
	self.animname = "dvora";
	//self setAnimTree();
	

	death2_tag = spawn_tag_origin();

	
	//***************************************
	//	Set up the dvora damage states
	//
	//***************************************
	//Hide all the damage states & chunks
	//self hidepart("tag_body_state2");
	//self hidepart("tag_body_state3");
	state2_chunks = [];//bone names for the state2 chunks
	state3_chunks = [];//bone names for the state3 chunks
	for(i=1;i<18;i++)
	{
		curr_chunk_name = ("chunk2_"+i);
		state2_chunks[state2_chunks.size] = curr_chunk_name;
	}
	for(i=1;i<10;i++)
	{
		curr_chunk_name = ("chunk3_"+i);
		state3_chunks[state3_chunks.size] = curr_chunk_name;
	}

	chunkA_ent = getent("vehicle_russian_super_dvora_mark2_destroyA","targetname");
	chunkB_ent = getent("vehicle_russian_super_dvora_mark2_destroyB","targetname");
	death2_tag.origin = chunkA_ent gettagorigin("tag_body_state2");
	death2_tag.angles = chunkA_ent gettagangles("tag_body_state2");
	death2_tag linkto(chunkA_ent,"tag_body_state2");
	chunkA_ent hide();
	chunkB_ent hide();
	






	
	//********** First explosion	
	self waittill( "dvora_destroyed" );
	aud_send_msg("slowmo_dvora_destroyed");
	
	
	chunkA_ent show();
	chunkA_ent.origin = self gettagorigin("tag_origin");
	chunkA_ent.angles = self gettagangles("tag_origin");
	chunkA_ent linkto(self,"tag_origin");
	chunkA_ent.animname =  "dvora";
	chunkA_ent setAnimTree();
	chunkB_ent.origin = self gettagorigin("tag_origin");
	chunkB_ent.angles = self gettagangles("tag_origin");
	chunkB_ent linkto(self,"tag_origin");
	chunkB_ent.animname =  "dvora";
	chunkB_ent setAnimTree();
	//chunkB_ent hide();
	chunkA_ent setanim( level.scr_anim[ "dvora" ][ "destorychunk" ] );	
	chunkB_ent setanim( level.scr_anim[ "dvora" ][ "destorychunk" ] );	
	
	//Start the animation here
	thread surface_dvora_post_carrier_coverpop();
	surface_dvora_chunk_splash_watcher(chunkA_ent,chunkB_ent);
	surface_dvora_chunk_firetrail_watcher(chunkA_ent,chunkB_ent);
	chunkA_ent surface_dvora_debris_atplayer();
	
	
	playfxontag(getfx("ny_harbor_dvora_death_exp"),chunkA_ent,"tag_deathfx1");//first explosion
	fire_wave_pos = chunkA_ent gettagorigin("tag_deathfx");
	//displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], fire_wave_pos );
	fire_wave_pos = (fire_wave_pos[0],fire_wave_pos[1],-183);
	playfx(getfx("ny_harbor_dvora_death_firewave"),fire_wave_pos,anglestoforward((270,0,0)));//play fire wave
	wait(.05);//wait a frame - 451
	playfxontag(getfx("ny_harbor_dvora_death_expinit"),chunkA_ent,"tag_deathfx1");//first explosion
	self hide();
	

	wait(.067);//wait til frame 453
	playfxontag(getfx("ny_harbor_dvora_death_exp"),chunkA_ent,"tag_deathfx2");//first explosion
	playfxontag(getfx("ny_harbor_dvora_death"),chunkA_ent,"tag_deathfx");//first explosion
	
	wait(.5);//wait til frame 468
	playfxontag(getfx("ny_harbor_dvora_death_exp2"),chunkA_ent,"tag_deathfx3");//first explosion

	//*********** Water hit distergration
	wait(.06);//wait til frame 470
	chunkA_ent hidepart("tag_body_state2");
	chunkB_ent show();
	wait(.27);//wait tile frame 478
	playfxontag(getfx("ny_harbor_dvora_death_exp3"),self,"tag_deathfx4");//first explosion
	chunkB_ent hidepart("chunk3_9");
	
	wait(1.63);//527
	curr_boat_pos = self gettagorigin("tag_origin")+(0,00,0);
	//play giant side splash
	//cutting this to save frame rate
	//playfx(getfx("ny_dvora_sideSplash"),curr_boat_pos,anglestoforward((0,-90,0)));
	level notify("msg_fx_stop_cin_dvorafx");
	curr_boat_pos = self gettagorigin("tag_origin")+(0,00,0);
	playfx(getfx("ny_harbor_dvora_death_splah"),curr_boat_pos,anglestoforward((0,-90,0)));
	stopfxontag(getfx("ny_harbor_dvora_death"),self,"tag_deathfx");//first explosion
	aud_send_msg("boat_slowmo_final_splash");

	//play giant splash at 533
	wait(.2);
	wait(.25);
	level thread screenshake(.3,1,.3,.53);
	wait(.25);
	curr_boat_pos = chunkA_ent gettagorigin("tag_deathfx")+(150,-50,0);
	playfx(getfx("ny_dvora_finalexplosion"),curr_boat_pos,anglestoforward((270,0,0)));
	chunkA_ent hide();
	chunkB_ent hide();

	//play the surface water hits
	thread surface_dvora_post_carrier_waterhits();

	wait(1.75);
	//final splash hits the player
	
	bump_fx_tag = spawn_tag_origin();
	//thread surface_player_water_sheeting_timed(4.0);
	//Kill this because of framerate
	//playfxontag(getfx("ny_dvora_finalexplosion_splash"),level.z_rail_1,"tag_origin");

	//clean up
	chunkB_ent delete();
	chunkA_ent delete();
	death2_tag delete();
	bump_fx_tag delete();
	
	//set sun shadow back to normal
	//These were originally changed in surface_escape_zodiac_bumpfx
	wait(2.0);
	setsaveddvar("sm_sunshadowscale",level.old_shadow_scale);
	//start up building fires again
	exploder(242);
	exploder(252);
	
	wait(2.0);
	//start up the oil slick fx again
	RestartFXID( "burning_oil_slick_1", "exploder" );

	wait(3.0);
	//start the land and water explosions up again, but only if we're not under the docks already
	if (!flag("msg_fx_under_docks"))
	{
		level thread start_harbor_landexplosions();
		wait(1.0);
		level thread start_harbor_waterexplosions();
		wait(1.0);
		level thread play_slava_missiles();
	}
	
	
	thread chinook_board_coverpop();
}



precacheFX()
{
	level._effect[ "ny_sub_damage_smoke" ] 	= LoadFX( "maps/ny_harbor/ny_sub_damage_smoke" );//placed by fxman
	level._effect[ "fire_extinguisher_spray" ] 	= LoadFX( "props/fire_extinguisher_spray" );//placed by fxman
	level._effect[ "fire_extinguisher_exp" ] 	= LoadFX( "props/fire_extinguisher_exp" );//placed by fxman
	level._effect[ "ny_sub_sidefroth_normal" ] 	= LoadFX( "maps/ny_harbor/ny_sub_sidefroth_normal" );//placed by fxman
	level._effect[ "ny_dvora_wakestern_trail2" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_wakestern_trail2" );//placed by fxman
	level._effect[ "ny_harbor_dvora_death_expinit" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_expinit" );//placed by fxman
	level._effect[ "ny_harbor_dvora_bloodsplat" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_bloodsplat" );//placed by fxman
	level._effect[ "ny_harbor_dvora_bloodhit" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_bloodhit" );//placed by fxman
	level._effect[ "ny_harbor_dvora_fallingchunks" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_fallingchunks" );//placed by fxman
	level._effect[ "ny_harbor_dvora_debrisatplayer" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_debrisatplayer" );//placed by fxman
	level._effect[ "ny_dvora_wakebow2" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_wakebow2" );//placed by fxman
	level._effect[ "ny_harbor_dvora_death_exp3" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_exp3" );//placed by fxman
	level._effect[ "ny_harbor_dvora_death_exp2" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_exp2" );//placed by fxman
	level._effect[ "ny_sub_playerwaterripple" ] 	= LoadFX( "maps/ny_harbor/ny_sub_playerwaterripple" );//placed by fxman
	level._effect[ "parabolic_water_stand" ] 	= LoadFX( "misc/parabolic_water_stand" );//placed by fxman
	level._effect[ "ny_dvora_finalexplosion_splash" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_finalexplosion_splash" );//placed by fxman
	level._effect[ "ny_dvora_debris_splash" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_debris_splash" );//placed by fxman
	level._effect[ "ny_dvora_sideSplash" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_sideSplash" );//placed by fxman
	level._effect[ "ny_dvora_finalexplosion" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_finalexplosion" );//placed by fxman
	level._effect[ "ny_harbor_dvora_death_firewave" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_firewave" );//placed by fxman
	level._effect[ "ny_harbor_dvora_death_splah" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_splah" );//placed by fxman
	level._effect[ "ny_harbor_dvora_chunkemitter" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_chunkemitter" );//placed by fxman
	level._effect[ "ny_harbor_dvora_death_exp" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_death_exp" );//placed by fxman
	level._effect[ "ny_dvora_wakestern_trail" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_wakestern_trail" );//placed by fxman
	level._effect[ "ny_dvora_wakebow_trailxup" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_wakebow_trailxup" );//placed by fxman
	level._effect[ "ny_dvora_wakebow_trail" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_wakebow_trail" );//placed by fxman
	level._effect[ "ny_dvora_wakebow" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_wakebow" );//placed by fxman
	level._effect[ "ny_sub_fin_wisp" ] 	= LoadFX( "maps/ny_harbor/ny_sub_fin_wisp" );//placed by fxman
	level._effect[ "ny_sub_sidefroth_before" ] 	= LoadFX( "maps/ny_harbor/ny_sub_sidefroth_before" );//placed by fxman
	level._effect[ "ny_sub_breachmainBow_gush" ] 	= LoadFX( "maps/ny_harbor/ny_sub_breachmainBow_gush" );//placed by fxman
	level._effect[ "ny_sub_directionalgushes" ] 	= LoadFX( "maps/ny_harbor/ny_sub_directionalgushes" );//placed by fxman
	level._effect[ "ny_sub_sidefroth" ] 	= LoadFX( "maps/ny_harbor/ny_sub_sidefroth" );//placed by fxman
	level._effect[ "ny_dvora_zodiac_bump2" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_zodiac_bump2" );//placed by fxman
	level._effect[ "ny_sub_sideport_4" ] 	= LoadFX( "maps/ny_harbor/ny_sub_sideport_4" );//placed by fxman
	level._effect[ "ny_sub_hatch_grenade" ] 	= LoadFX( "maps/ny_harbor/ny_sub_hatch_grenade" );//placed by fxman
	level._effect[ "dvora_wakeside_nyharbor" ] 	= LoadFX( "treadfx/dvora_wakeside_nyharbor" );//placed by fxman
	level._effect[ "dvora_wake_nyharbor" ] 	= LoadFX( "treadfx/dvora_wake_nyharbor" );//placed by fxman
	level._effect[ "zubr_wakeside_nyharbor" ] 	= LoadFX( "treadfx/zubr_wakeside_nyharbor" );//placed by fxman
	level._effect[ "zubr_wake_nyharbor" ] 	= LoadFX( "treadfx/zubr_wake_nyharbor" );//placed by fxman
	level._effect[ "ny_dvora_zodiac_bump" ] 	= LoadFX( "maps/ny_harbor/ny_dvora_zodiac_bump" );//placed by fxman
	level._effect[ "mortarExp_water" ] 	= LoadFX( "explosions/mortarExp_water" );//placed by fxman
	level._effect[ "ny_harbor_dvora_death2" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_death2" );//placed by fxman
	level._effect[ "ny_harbor_dvora_death" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_dvora_death" );//placed by fxman
	level._effect[ "ny_harbor_actor_smoke" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_actor_smoke" );//placed by fxman
	level._effect[ "ny_sub_hatch_smoke" ] 	= LoadFX( "maps/ny_harbor/ny_sub_hatch_smoke" );//placed by fxman
	level._effect[ "ny_sub_hatch_smoke_2" ] 	= LoadFX( "maps/ny_harbor/ny_sub_hatch_smoke_2" );//placed by fxman
	level._effect[ "nyharbor_sub_impact2" ] 	= LoadFX( "maps/ny_harbor/nyharbor_sub_impact2" );//placed by fxman
	level._effect[ "ny_sub_breachMainBow" ] 	= LoadFX( "maps/ny_harbor/ny_sub_breachMainBow" );//placed by fxman
	level._effect[ "ny_harbor_buildinghit2" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_buildinghit2" );//placed by fxman
	level._effect[ "ny_harbor_building_missile3" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_building_missile3" );//placed by fxman
	level._effect[ "ny_harbor_building_missile2" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_building_missile2" );//placed by fxman
	level._effect[ "ny_harbor_building_missile" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_building_missile" );//placed by fxman
	level._effect[ "ny_harbor_buildingchunkfall" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_buildingchunkfall" );//placed by fxman
	level._effect[ "ny_harbor_buildinghit_edge" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_buildinghit_edge" );//placed by fxman
	level._effect[ "ny_harbor_buildinghit" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_buildinghit" );//placed by fxman
	level._effect[ "ny_sub_breachMain" ] 	= LoadFX( "maps/ny_harbor/ny_sub_breachMain" );//placed by fxman
	level._effect[ "ny_sub_towerbase" ] 	= LoadFX( "maps/ny_harbor/ny_sub_towerbase" );//placed by fxman
	level._effect[ "ny_sub_fingush" ] 	= LoadFX( "maps/ny_harbor/ny_sub_fingush" );//placed by fxman
	level._effect[ "nyharbor_sub_impact" ] 	= LoadFX( "maps/ny_harbor/nyharbor_sub_impact" );//placed by fxman
	level._effect[ "ny_column_base" ] 	= LoadFX( "maps/ny_harbor/ny_column_base" );//placed by fxman
	level._effect[ "fire_ceiling_lg_slow" ] 	= LoadFX( "fire/fire_ceiling_lg_slow" );//placed by fxman
	level._effect[ "fire_falling_runner_consistent" ] 	= LoadFX( "fire/fire_falling_runner_consistent_harbor" );//placed by fxman
	level._effect[ "firelp_large_med_pm_nolight_cheap" ] 	= LoadFX( "fire/firelp_large_med_pm_nolight_cheap" );//placed by fxman
	level._effect[ "firelp_large_pm_nolight" ] 	= LoadFX( "fire/firelp_large_pm_nolight" );
	level._effect[ "firelp_large_pm_nolight_cheap" ] 	= LoadFX( "fire/firelp_large_pm_nolight_cheap" );
	level._effect[ "firelp_large_pm_nolight_r" ] 	= LoadFX( "fire/firelp_large_pm_nolight" );//placed by fxman
	level._effect[ "firelp_large_pm_nolight_r_reflect" ] 	= LoadFX( "fire/firelp_large_pm_reflect" );
	level._effect[ "fire_ceiling_md_slow" ] 	= LoadFX( "fire/fire_ceiling_md_slow" );//placed by fxman
	level._effect[ "fire_falling_runner" ] 	= LoadFX( "fire/fire_falling_runner_harbor" );//placed by fxman
	level._effect[ "fire_embers_directional" ] 	= LoadFX( "fire/fire_embers_directional" );//placed by fxman
	level._effect[ "ny_harbor_wavelargech2" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_wavelargech2" );//placed by fxman
	level._effect[ "fire_ceiling_sm_slow" ] 	= LoadFX( "fire/fire_ceiling_sm_slow" );//placed by fxman
	level._effect[ "fire_line_sm_cheap" ] 	= LoadFX( "fire/fire_line_sm_cheap" );//placed by fxman
	level._effect[ "fire_line_sm" ] 	= LoadFX( "fire/fire_line_sm" );//placed by fxman
	level._effect[ "ny_harbor_wavelargech" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_wavelargech" );//placed by fxman
	level._effect[ "ny_harbor_wavech" ] 	= LoadFX( "maps/ny_harbor/ny_harbor_wavech" );//placed by fxman
	level._effect[ "nyharbor_sub_breach" ] 	= LoadFX( "maps/ny_harbor/nyharbor_sub_breach" );//placed by fxman
	level._effect[ "ny_column_top" ] 	= LoadFX( "maps/ny_harbor/ny_column_top" );//placed by fxman
	
	/*-----------------------
	UNDERWATER FX
	-------------------------*/	
	level._effect[ "player_enter_water"]						= loadfx( "water/player_submerge" );
	level._effect[ "sdv_prop_wash_2"]							= loadfx( "water/sdv_prop_wash_2" );
	level._effect[ "nyharbor_propwash_surfacing_player"]		= loadfx( "maps/ny_harbor/nyharbor_propwash_surfacing_player" );
	level._effect[ "nyharbor_propwash_surfacing_npc"]			= loadfx( "maps/ny_harbor/nyharbor_propwash_surfacing_npc" );
		
	level._effect[ "car_breaklights"]							= loadfx( "misc/car_brakelight_bm21" );
	level._effect[ "water_bubbles_longlife_lp" ]			 	= loadfx( "water/water_bubbles_longlife_lp" );
	level._effect[ "water_bubbles_longlife_sm_lp" ]			 	= loadfx( "water/water_bubbles_longlife_sm_lp" );
	level._effect[ "water_bubbles_wide_sm_lp" ]					= loadfx( "water/water_bubbles_wide_sm_lp" );
	level._effect[ "water_bubbles_wide_sm" ]					= loadfx( "water/water_bubbles_wide_sm" );
	level._effect[ "water_bubbles_random_runner_lp" ]			= loadfx( "water/water_bubbles_random_runner_lp" );
	level._effect[ "water_bubbles_lg_lp" ]						= loadfx( "water/water_bubbles_lg_lp" );
	level._effect[ "ny_harbor_submine_bubble_tiny" ]			= loadfx( "maps/ny_harbor/ny_harbor_submine_bubble_tiny" );
	level._effect[ "water_bubbles_tiny_cylind50" ]				= loadfx( "water/water_bubbles_tiny_cylind50" );
	level._effect[ "water_bubbles_trail_emit" ]					= loadfx( "water/water_bubbles_trail_emit" );
	level._effect[ "water_bubbles_trail_big_emit" ]				= loadfx( "water/water_bubbles_trail_big_emit" );
	
	level._effect[ "sub_waterdisp_tail" ]			 			= loadfx( "water/sub_waterdisp_tail" );
	level._effect[ "sub_waterdisp_fin_f" ]						= loadfx( "water/sub_waterdisp_fin_f" );
	level._effect[ "sub_waterdisp_head" ]						= loadfx( "water/sub_waterdisp_head" );
	level._effect[ "sub_waterdisp_midbody_offset" ]				= loadfx( "water/sub_waterdisp_midbody_offset" );
			
	level._effect[ "harbor_distort_cam" ]			 			= loadfx( "maps/ny_harbor/harbor_distort_cam" );
	
	level._effect[ "nyharbor_sdv_bubble_transition1" ]			= loadfx( "maps/ny_harbor/nyharbor_sdv_bubble_transition1" );
	level._effect[ "nyharbor_sdv_bubble_transition2" ]			= loadfx( "maps/ny_harbor/nyharbor_sdv_bubble_transition2" );
	
	level._effect[ "intro_player_scuba_bubble" ]			 	= loadfx( "maps/ny_harbor/harbor_intro_player_scuba_bubble" );
	level._effect[ "intro_npc_scuba_bubble" ]			 		= loadfx( "maps/ny_harbor/harbor_intro_npc_scuba_bubble" );
	level._effect[ "scuba_bubbles_breath_player" ]				= loadfx( "water/scuba_bubbles_breath_player" );
	level._effect[ "scuba_bubbles_NPC" ]			 			= loadfx( "water/scuba_bubbles_breath_longlife" );
	
	level._effect[ "underwater_particulates_player" ]			= loadfx( "maps/ny_harbor/harbor_undrwtr_particulates_player" );
	level._effect[ "underwater_particulates" ]					= loadfx( "water/ny_harbor_underwater_particulates" );
	
	level._effect[ "torch_flare" ]			 					= loadfx( "misc/torch_cutting_fire_underwater" );
	level._effect[ "torch_fire_gun" ]			 				= loadfx( "misc/torch_cutting_fire_gun_underwater" );
	level._effect[ "torch_metal_glow_underwater" ]				= loadfx( "misc/torch_metal_glow_underwater" );
	level._effect[ "torch_metal_glow_underwater_fade" ]			= loadfx( "misc/torch_metal_glow_underwater_fade" );
		
	level._effect[ "underwater_particulates_lit" ]				= loadfx( "dust/light_shaft_dust_large" );
	level._effect[ "underwater_particulates_glitter" ]			= loadfx( "water/underwater_particulates_glitter" );
	level._effect[ "ny_harbor_undrwtr_particulate_intro" ]		= loadfx( "maps/ny_harbor/ny_harbor_undrwtr_particulate_intro" );
	level._effect[ "ny_harbor_underwater_dust_bright" ]			= loadfx( "water/ny_harbor_underwater_dust_bright" );
	level._effect[ "ny_harbor_underwater_dust_narrow" ]			= loadfx( "water/ny_harbor_underwater_dust_narrow" );
	level._effect[ "ny_harbor_underwater_dust_tumble_wide" ]	= loadfx( "water/ny_harbor_underwater_dust_tumble_wide" );
	level._effect[ "ny_harbor_underwater_dust_swirl" ]			= loadfx( "water/ny_harbor_underwater_dust_swirl" );
	level._effect[ "underwater_dust_kick_minisub" ]				= loadfx( "water/underwater_dust_kick_minisub" );
	
	level._effect[ "fish_school_top_oilrig_base" ]	 			= loadfx( "animals/fish_school_top_oilrig_base" );
	level._effect[ "fish_school_side_large" ]	 				= loadfx( "animals/fish_school_side_large" );
	level._effect[ "ny_harbor_underwater_caustic" ]	 			= loadfx( "water/ny_harbor_underwater_caustic" );
	level._effect[ "ny_harbor_underwater_caustic_ray_long" ]	= loadfx( "water/ny_harbor_underwater_caustic_ray_long" );
		
	level._effect[ "light_strobe_undrwtr_mine" ]	 			= loadfx( "lights/light_strobe_undrwtr_mine" );

	level._effect[ "underwater_murk" ]	 						= loadfx( "water/ny_harbor_underwater_murk" );
	level._effect[ "underwater_murk_xlg" ]	 					= loadfx( "water/ny_harbor_underwater_murk_xlg" );
	
 	level._effect[ "lights_underwater_godray" ]					= loadfx( "lights/lights_underwater_godray" );
 	level._effect[ "lights_underwater_shadowLarge" ]			= loadfx( "lights/lights_underwater_shadowLarge" );
 	
	level._effect[ "depth_charge_distance_ambient" ]			= loadfx( "explosions/depth_charge_distance_ambient" );
	level._effect[ "depth_charge_distance_ambient_sm" ]			= loadfx( "explosions/depth_charge_distance_ambient_sm" );
	level._effect[ "depth_charge_distance_amb_runr" ]			= loadfx( "explosions/depth_charge_distance_amb_runr" );
	level._effect[ "depth_charge_explosion" ]					= loadfx( "explosions/depth_charge" );
	level._effect[ "sub_surfacing_explosion1" ]					= loadfx( "maps/ny_harbor/ny_sub_surfacing_explosion1" );
	level._effect[ "sub_surfacing_explosion2" ]					= loadfx( "maps/ny_harbor/ny_sub_surfacing_explosion2" );
	level._effect[ "sub_surfacing_explosion3" ]					= loadfx( "maps/ny_harbor/ny_sub_surfacing_explosion3" );
	level._effect[ "ny_harbor_ship_sink_explo" ]				= loadfx( "maps/ny_harbor/ny_harbor_ship_sink_explo" );
	level._effect[ "ny_harbor_ship_sink_explo_post" ]			= loadfx( "maps/ny_harbor/ny_harbor_ship_sink_explo_post" );
	level._effect[ "ny_harbor_ship_sink_post_smk" ]				= loadfx( "maps/ny_harbor/ny_harbor_ship_sink_post_smk" );
	level._effect[ "ny_harbor_ship_sink_oil" ]					= loadfx( "maps/ny_harbor/ny_harbor_ship_sink_oil" );
	level._effect[ "ny_harbor_ship_sink_oil_l" ]				= loadfx( "maps/ny_harbor/ny_harbor_ship_sink_oil_l" );
	level._effect[ "floating_debris_xlg_underwater" ]			= loadfx( "misc/floating_debris_xlg_underwater" );
	level._effect[ "floating_obj_trash_underwater" ]			= loadfx( "misc/floating_obj_trash_underwater" );
	level._effect[ "floating_obj_sunglasses_undrwtr" ]			= loadfx( "misc/floating_obj_sunglasses_undrwtr" );
	level._effect[ "floating_obj_bottles_underwater" ]			= loadfx( "misc/floating_obj_bottles_underwater" );
	level._effect[ "floating_obj_boot_underwater" ]				= loadfx( "misc/floating_obj_boot_underwater" );
	level._effect[ "floating_obj_mug_underwater" ]				= loadfx( "misc/floating_obj_mug_underwater" );
	level._effect[ "floating_obj_soccerball_undrwtr" ]			= loadfx( "misc/floating_obj_soccerball_undrwtr" );
	
	level._effect[ "ny_carrier_crack" ]							= loadfx( "maps/ny_harbor/ny_carrier_crack" );
	level._effect[ "panel_flash_left" ] 						= loadfx( "maps/ny_harbor/sdv_panel_left" );
	level._effect[ "panel_flash_right" ] 						= loadfx( "maps/ny_harbor/sdv_panel_right" );
	level._effect[ "lead_sdv_beacon" ] 							= loadfx( "maps/ny_harbor/sdv_beacon" );

 	level._effect[ "light_glow_red_generic_pulse_harbor" ] 		= loadfx( "misc/light_glow_red_generic_pulse_harbor" );
	level._effect[ "lighthaze_skylight" ]						= loadfx( "misc/lighthaze_skylight" );
	level._effect[ "lights_green_blinking" ]					= loadfx( "lights/lights_green_blinking" );
	level._effect[ "light_headlight" ]							= loadfx( "lights/lights_headlight_harbor" );
	level._effect[ "flashlight_spotlight" ]	 					= loadfx( "misc/flashlight_spotlight_harbor" );
	level._effect[ "lights_torch_cutting" ]	 					= loadfx( "lights/lights_torch_cutting" );
	level._effect[ "lights_grating_rays" ]	 					= loadfx( "lights/lights_grating_rays" );
	level._effect[ "godray_underwater" ]	 					= loadfx( "misc/godray_underwater" );
	
	level._effect[ "sub_propeller_propwash" ]	 				= loadfx( "water/sub_propeller_propwash" );
	level._effect[ "sub_volumetric_lightbeam2" ]	 				= loadfx( "maps/ny_harbor/sub_volumetric_lightbeam2" );
	level._effect[ "sub_volumetric_lightbeam2_static" ]	 				= loadfx( "maps/ny_harbor/sub_volumetric_lightbeam2_static" );
	level._effect[ "sub_volumetric_shadow_fin_front" ]	 				= loadfx( "maps/ny_harbor/sub_volumetric_shadow_fin_front" );
	level._effect[ "sub_volumetric_shadow_fin_rear" ]	 				= loadfx( "maps/ny_harbor/sub_volumetric_shadow_fin_rear" );
	
	// sonar UI display effects for SDV
	level._effect[ "sub_ping" ] 								= loadfx( "misc/sonar_sub_ping" );
	level._effect[ "mine_ping" ] 								= loadfx( "misc/sonar_mine_ping_scale1" );
	
	level._effect[ "mine_ping_scale1" ] 						= loadfx( "misc/sonar_mine_ping_scale1" );
	level._effect[ "mine_ping_scale2" ] 						= loadfx( "misc/sonar_mine_ping_scale2" );
	level._effect[ "mine_ping_scale3" ] 						= loadfx( "misc/sonar_mine_ping_scale3" );
	level._effect[ "mine_ping_scale4" ] 						= loadfx( "misc/sonar_mine_ping_scale4" );
	level._effect[ "sonar_mine_ping_scrn_right" ] 				= loadfx( "misc/sonar_mine_ping_scrn_right" );
	level._effect[ "sonar_mine_ping_scrn_left" ] 				= loadfx( "misc/sonar_mine_ping_scrn_left" );
	level._effect[ "friend_ping" ] 								= loadfx( "misc/sonar_friend_ping" );
	

	/*-----------------------
	SUB INTERIOR FX
	-------------------------*/	
	level._effect[ "flesh_hit" ] 								= LoadFX( "impacts/flesh_hit_body_fatal_exit" );
	level._effect["steam_room_ceiling"]							= loadfx ("smoke/steam_room_ceiling");	
	level._effect[ "drips_slow" ]								= loadfx( "misc/drips_slow" );
	level._effect[ "drips_slow_sub_sfx" ]								= loadfx( "misc/drips_slow_sub_sfx" );
	level._effect[ "drips_fast" ]								= loadfx( "misc/drips_fast" );
	level._effect[ "drips_fast_sub_sfx" ]								= loadfx( "misc/drips_fast_sub_sfx" );
	level._effect[ "drips_fast_sub_2_sfx" ]								= loadfx( "misc/drips_fast_sub_2_sfx" );
	level._effect[ "waterfall_drainage_short_dcemp" ]			= loadfx( "water/waterfall_drainage_short_dcemp" );
	level._effect[ "waterfall_drainage_splash_dcemp" ]			= loadfx( "water/waterfall_drainage_splash_dcemp" );
	level._effect[ "falling_water_trickle" ]					= loadfx( "water/falling_water_trickle" );
	level._effect[ "ny_sub_heat_distortion" ]								= loadfx( "maps/ny_harbor/ny_sub_heat_distortion" );
	level._effect[ "sub_int_water_splash" ]								= loadfx( "maps/ny_harbor/sub_int_water_splash" );
	level._effect[ "sub_int_water_splash2" ]								= loadfx( "maps/ny_harbor/sub_int_water_splash2" );

	level._effect["powerline_runner"]							= loadfx ("explosions/powerline_runner");	
	level._effect["powerline_runner_blue"]							= loadfx ("explosions/powerline_runner_blue");	
	level._effect["powerline_runner_s_blue"]							= loadfx ("explosions/powerline_runner_s_blue");	
	level._effect["powerline_runner_red"]							= loadfx ("explosions/powerline_runner_red");	
	level._effect["powerline_runner_s_red"]							= loadfx ("explosions/powerline_runner_s_red");
	level._effect["powerline_runner_red_nolight"]							= loadfx ("explosions/powerline_runner_red_nolight");
	level._effect[ "hallway_smoke_dark" ]						= loadfx( "smoke/hallway_smoke_dark" );
	level._effect[ "ground_smoke_dcburning1200x1200" ]			= loadfx( "smoke/ground_smoke1200x1200_dcburning" );
 	level._effect[ "steam_manhole" ]							= loadfx( "smoke/steam_manhole" );
 	level._effect[ "red_steady_light" ]							= loadfx( "misc/tower_light_red_sort_harbor" );
 	level._effect[ "steam_room_100" ]							= loadfx( "smoke/steam_room_100" );
 	level._effect[ "steam_jet" ]							= loadfx( "smoke/steam_jet_med_harbor" );
 	level._effect[ "steam_jet_loop" ]							= loadfx( "smoke/steam_jet_med_loop_harbor" );
 	level._effect[ "steam_jet_loop_cheap" ]							= loadfx( "smoke/steam_jet_loop_cheap" );
 	level._effect[ "steam_jet_loop_valve" ]							= loadfx( "smoke/steam_jet_loop_valve" );
 	level._effect[ "lights_smokey_grating_sm" ]							= loadfx( "lights/lights_smokey_grating_sm" );
 	level._effect[ "submarine_red_light" ]							= loadfx( "misc/submarine_red_light" );
 	level._effect[ "chinook_red_light" ]							= loadfx( "misc/chinook_red_light" );
 	level._effect[ "drips_fast" ]							= loadfx( "misc/drips_fast" );
 	level._effect[ "drips_slow" ]							= loadfx( "misc/drips_slow" );
 	level._effect[ "steam_vent_large_slow" ]							= loadfx( "smoke/steam_vent_large_slow" );
 	level._effect[ "steam_vent_large_bright" ]							= loadfx( "smoke/steam_vent_large_bright" );
 	level._effect[ "head_smash" ]							= loadfx( "misc/blood_head_smash" );
 	level._effect[ "head_kick" ]							= loadfx( "misc/blood_head_kick" );
  level._effect[ "florescent_glow_blue" ]							= loadfx( "misc/florescent_glow_blue" );
  level._effect[ "breach_door_metal" ]							= loadfx( "explosions/breach_door_metal" );
  level._effect[ "breach_door_flash" ]							= loadfx( "maps/ny_harbor/breach_door_flash" );
   level._effect[ "sub_breach_door_seat_destroy" ]							= loadfx( "maps/ny_harbor/sub_breach_door_seat_destroy" );
  level._effect[ "steam_jet_s_loop" ]							= loadfx( "smoke/steam_jet_s_loop" );
  level._effect[ "steam_jet_s_loop_2" ]							= loadfx( "smoke/steam_jet_s_loop_2" );
  level._effect["light_glow_white_harbor"] 						= loadfx( "misc/light_glow_white_harbor" );
  level._effect["smoke_rolling_small"] 						= loadfx( "smoke/smoke_rolling_small" );
  level._effect["smoke_rolling_medium"] 						= loadfx( "smoke/smoke_rolling_medium" );
  level._effect["smoke_rolling_medium_cheap"] 						= loadfx( "smoke/smoke_rolling_medium_cheap" );
  level._effect["steam_vent_skinny_slow"] 						= loadfx( "smoke/steam_vent_skinny_slow" );
  level._effect["door_open_smokeout"]							= loadfx ("maps/ny_harbor/door_open_smokeout");	
  level._effect["sub_grenade_decal"]							= loadfx ("maps/ny_harbor/sub_grenade_decal");	
  level._effect["sub_missile_room_fire"]							= loadfx ("maps/ny_harbor/sub_missile_room_fire");	
  level._effect["water_pipe_spray_2"] 						= loadfx( "water/water_pipe_spray_2" );
  level._effect["water_pipe_spray_3"] 						= loadfx( "water/water_pipe_spray_3" );
  level._effect["water_pipe_spray_4"] 						= loadfx( "water/water_pipe_spray_4" );
  level._effect["water_pipe_spray_5"] 						= loadfx( "water/water_pipe_spray_5" );
  level._effect["water_pipe_spray_6"] 						= loadfx( "water/water_pipe_spray_6" );
  level._effect["water_pipe_mist"] 						= loadfx( "water/water_pipe_mist" );
  level._effect["water_pipe_burst"] 						= loadfx( "water/water_pipe_burst" );
  level._effect["water_pipe_burst_2"] 						= loadfx( "water/water_pipe_burst_2" );
  level._effect["water_pipe_burst_3"] 						= loadfx( "water/water_pipe_burst_3" );
  level._effect["water_pipe_burst_4"] 						= loadfx( "water/water_pipe_burst_4" );
  level._effect["cpu_fire"] 						= loadfx( "fire/cpu_fire" );
 	level._effect["lights_sub_alarm_strobe"] 						= loadfx( "lights/lights_sub_alarm_strobe" );
  level._effect["sub_engine_sparks"]							= loadfx ("maps/ny_harbor/sub_engine_sparks");
  level._effect["sub_water_floating_junk"]							= loadfx ("maps/ny_harbor/sub_water_floating_junk");	
  level._effect["sub_water_floating_junk_2"]							= loadfx ("maps/ny_harbor/sub_water_floating_junk_2");	
  level._effect["light_red_pinlight_sort"]							= loadfx ("lights/light_red_pinlight_sort");	
  level._effect["light_green_pinlight"]							= loadfx ("lights/light_green_pinlight");	
  level._effect["footstep_water"]							= loadfx ("maps/ny_harbor/footstep_water");	
  level._effect["footstep_water_slow"]							= loadfx ("maps/ny_harbor/footstep_water_slow");
  level._effect["death_water"]							= loadfx ("maps/ny_harbor/death_water");
  level._effect["lights_godray_beam_harbor"]							= loadfx ("maps/ny_harbor/lights_godray_beam_harbor");
  level._effect["lighthaze_sub_ladder_distant"]							= loadfx ("maps/ny_harbor/lighthaze_sub_ladder_distant");
  level._effect["lighthaze_sub_ladder_bottom"]							= loadfx ("maps/ny_harbor/lighthaze_sub_ladder_bottom");
  level._effect["lighthaze_sub_ladder_bottom_fade"]							= loadfx ("maps/ny_harbor/lighthaze_sub_ladder_bottom_fade");
  level._effect[ "sub_monitor_explosion" ]	 				= loadfx( "maps/ny_harbor/sub_monitor_explosion" );
  level._effect[ "sub_monitor_explosion_m" ]	 				= loadfx( "maps/ny_harbor/sub_monitor_explosion_m" );
  level._effect[ "sub_monitor_explosion_m2" ]	 				= loadfx( "maps/ny_harbor/sub_monitor_explosion_m2" );
  level._effect[ "sub_monitor_explosion_r" ]	 				= loadfx( "maps/ny_harbor/sub_monitor_explosion_r" );
  level._effect[ "sub_monitor_explosion_s" ]	 				= loadfx( "maps/ny_harbor/sub_monitor_explosion_s" );
  level._effect[ "sub_control_room_smk" ]	 				= loadfx( "maps/ny_harbor/sub_control_room_smk" );
  level._effect[ "headshot" ]								= loadfx( "impacts/flesh_hit_head_fatal_exit" );
  
//enemy flashligt
	level._effect[ "flashlight_ai" ]												= loadfx( "misc/flashlight" );
 	level._effect[ "monitor_glow" ]							= loadfx( "props/monitor_glow" );
 	level._effect[ "monitor_glow_point" ]							= loadfx( "props/monitor_glow_point" );
	level._effect[ "lights_point_white" ]							= loadfx( "lights/lights_point_white" );

 	//ally flashlight (spotlight)
	//level._effect["flashlight"] 														= loadfx( "misc/flashlight_spotlight_paris" );
	//level._effect["flashlight_bounce"] 											= loadfx( "misc/flashlight_pointlight_paris" );



	/*-----------------------
	HARBOR FX
	-------------------------*/	

	level._effect[ "ny_harbor_navalgunfirerunner" ]				= loadfx( "misc/ny_harbor_navalgunfirerunner" );
	level._effect[ "battleship_flash_large_withmissile" ]					= loadfx( "maps/ny_harbor/battleship_flash_large_withmissile" );
	level._effect[ "thick_dark_smoke_giant" ]					= loadfx( "smoke/thick_dark_smoke_giant_nyharbor" );
	level._effect[ "thick_dark_smoke_giant2" ]					= loadfx( "smoke/thick_dark_smoke_giant_nyharbor" );
	level._effect[ "ny_clouds" ]					= loadfx( "weather/ny_clouds" );
	level._effect[ "field_fire_distant" ]							= LoadFX( "fire/field_fire_distant" );
	level._effect["ny_harbor_waterbarrage"]		= LoadFX("water/ny_harbor_waterbarrage");
	level._effect["ny_harbor_waterbarrage2"]		= LoadFX("water/ny_harbor_waterbarrage2");
	level._effect["ny_harbor_waterbarrageSlow"]		= LoadFX("water/ny_harbor_waterbarrageSlow");
	level._effect["ny_harbor_explosionVerticalbarrage"]		= LoadFX("explosions/fireball_nyharbor_verticalbarrage");
	level._effect[ "antiair_runner" ]							= loadfx( "misc/antiair_runner_flak" );
	level._effect[ "battlefield_smokebank_large" ]							= loadfx( "smoke/battlefield_smokebank_large" );
	level._effect[ "mist_sea"]							= loadfx("weather/mist_sea" );
	level._effect[ "slava_splash"]							= loadfx("misc/slava_splash" );
	level._effect[ "slava_water_floor_rush"]							= loadfx("maps/ny_harbor/slava_water_floor_rush" );
	level._effect["generic_explosions"]	= loadfx("explosions/generic_explosion" );
	level._effect["ny_battleship_sirench2"]	= loadfx("maps/ny_harbor/ny_battleship_sirench2" );
	level._effect["ny_battleship_sirenchlight2"]	= loadfx("maps/ny_harbor/ny_battleship_sirenchlight2" );
	level._effect["large_water_impact"]	= loadfx("maps/ny_harbor/large_water_impact" );
	level._effect["large_water_impact_close"]	= loadfx("maps/ny_harbor/large_water_impact_close" );
	level._effect["large_water_impact_close_rain"]	= loadfx("maps/ny_harbor/large_water_impact_close_rain" );
	level._effect["large_water_impact_close_wave"]	= loadfx("maps/ny_harbor/large_water_impact_close_wave" );
	level._effect["large_water_impact_close_rush"]	= loadfx("maps/ny_harbor/large_water_impact_close_rush" );
	level._effect["smoke_geotrail_genericexplosion"]	= loadfx("smoke/smoke_geotrail_genericexplosion" );
	level._effect["fireball_lp_smk_l"]							= loadfx ("fire/fireball_lp_smk_l");	
	level._effect["fireball_lp_blue_smk_l"]							= loadfx ("fire/fireball_lp_blue_smk_l");
	level._effect["ny_blue_smk"]							= loadfx ("maps/ny_harbor/ny_blue_smk");
	level._effect["drifting_gray_smk_L"]							= loadfx ("smoke/drifting_gray_smk_L");	
	level._effect["generic_explosion_debris"]							= loadfx ("explosions/generic_explosion_debris");	
	level._effect["window_explosion_glass_only"]							= loadfx ("explosions/window_explosion_glass_only");	
	level._effect[ "burning_oil_slick_1" ]										 = loadfx( "fire/burning_oil_slick_1" );
	level._effect[ "burning_oil_slick_no_smk" ]										 = loadfx( "fire/burning_oil_slick_no_smk" );
	level._effect[ "burning_oil_slick_1_reflect" ]										 = loadfx( "fire/burning_oil_slick_1_reflect" );
	level._effect[ "sub_tail_foam" ]										 = loadfx( "maps/ny_harbor/sub_tail_foam" );
	level._effect[ "hot_tub_bubbles" ]										 = loadfx( "maps/ny_harbor/hot_tub_bubbles" );
	level._effect[ "sub_breaching_tail_steam" ]										 = loadfx( "maps/ny_harbor/sub_breaching_tail_steam" );
	level._effect[ "sub_breaching_tail_steam_child" ]										 = loadfx( "maps/ny_harbor/sub_breaching_tail_steam_child" );
	level._effect[ "sub_foam_lapping_waves" ]										 = loadfx( "maps/ny_harbor/sub_foam_lapping_waves" );
	level._effect[ "sub_foam_lapping_waves" ]										 = loadfx( "maps/ny_harbor/sub_foam_lapping_waves" );
	level._effect[ "sub_water_drainage" ]										 = loadfx( "maps/ny_harbor/sub_water_drainage" );
	level._effect[ "carrier_foam_lapping_waves" ]										 = loadfx( "maps/ny_harbor/carrier_foam_lapping_waves" );
	level._effect[ "carrier_deck_water_flow" ]										 = loadfx( "maps/ny_harbor/carrier_deck_water_flow" );
	level._effect[ "waterfall_drainage_carrier" ]										 = loadfx( "water/waterfall_drainage_carrier" );
	level._effect[ "waterfall_drainage_carrier_splash" ]										 = loadfx( "water/waterfall_drainage_carrier_splash" );
	level._effect[ "carrier_underside_drips" ]										 = loadfx( "maps/ny_harbor/carrier_underside_drips" );
	level._effect[ "wave_crest_spray" ]										 = loadfx( "maps/ny_harbor/wave_crest_spray" );
	level._effect[ "wave_crest_spray_explosion" ]										 = loadfx( "maps/ny_harbor/wave_crest_spray_explosion" );
	level._effect[ "fluorescent_glow" ]							= LoadFX( "misc/fluorescent_glow" );
	level._effect[ "heli_water_harbor_cinematic" ]							= LoadFX( "treadfx/heli_water_harbor_cinematic" );
	level._effect[ "lights_godray_beam" ]							= LoadFX( "lights/lights_godray_beam_bright" );


	/*-------------------------------
	SHIP BATTLE FX
	--------------------------------*/
	level._effect[ "smoke_geotrail_missile_large" ]		 					= loadfx( "smoke/smoke_geotrail_missile_large" );
	level._effect[ "missile_launch_large" ]				 					= loadfx( "smoke/smoke_geotrail_missile_large" );
	level._effect[ "smoke_geotrail_ssnMissile" ]		 					= loadfx( "smoke/smoke_geotrail_ssnMissile");
		level._effect[ "ny_battleship_siren" ]								= loadfx( "maps/ny_harbor/ny_battleship_siren" );
	level._effect[ "ny_battleship_sirench" ]								= loadfx( "maps/ny_harbor/ny_battleship_sirench" );
	level._effect[ "cloud_bank_gulag_z_feather" ]	 			= loadfx( "weather/cloud_bank_gulag_z_feather" );
	level._effect[ "ny_battleship_sirenchlight" ]	 			= loadfx( "maps/ny_harbor/ny_battleship_sirenchlight" );
	level._effect["lights_strobe_red"]													= loadfx ("lights/lights_strobe_red");
	level._effect["ship_edge_foam_oriented"]													= loadfx ("water/ship_edge_foam_oriented");
	level._effect["ship_edge_foam_oriented_small"]													= loadfx ("water/ship_edge_foam_oriented_small");
	level._effect["ship_edge_foam_oriented_tiny"]													= loadfx ("water/ship_edge_foam_oriented_tiny");
	level._effect["ship_edge_foam_oriented_sm_shrt"]													= loadfx ("water/ship_edge_foam_oriented_sm_shrt");
	level._effect[ "corvette_explosion_front" ]								= loadfx( "maps/ny_harbor/corvette_explosion_front" );
	level._effect[ "corvette_explosion_front_reflect" ]								= loadfx( "maps/ny_harbor/corvette_explosion_front_reflect" );
	level._effect[ "burya_explosion_splash" ]								= loadfx( "maps/ny_harbor/burya_explosion_splash" );
	level._effect[ "destroyer_impact_splash" ]								= loadfx( "maps/ny_harbor/destroyer_impact_splash" );
	level._effect[ "destroyer_missile_impact" ]								= loadfx( "maps/ny_harbor/destroyer_missile_impact" );
	// harbor missiles
	level._effect[ "ssn12_launch_smoke" ]					= loadfx( "smoke/smoke_geotrail_ssnMissile" );	
	level._effect[ "ssn12_launch_smoke12" ]					= loadfx( "maps/ny_harbor/smoke_ssnmissile12_launch" );	
	//level._effect[ "sub_missile_launch_reflect" ]					= loadfx( "maps/ny_harbor/sub_missile_launch_reflect" );	
	level._effect[ "ssn12_launch_smoke_trail" ]					= loadfx( "smoke/smoke_geotrail_ssnMissile_trail" );	
	level._effect[ "ssn12_enhaust"]					= loadfx( "maps/ny_harbor/ny_ssn12_exhaust" );	
	level._effect[ "ssn12_init"]					= loadfx( "maps/ny_harbor/ny_ssn12_init" );	
	level._effect[ "ssn12_flash"]					= loadfx( "maps/ny_harbor/ny_ssn12_flash" );	
	level._effect[ "smoke_geotrail_ssnMissile12_trail" ]					= loadfx( "smoke/smoke_geotrail_ssnMissile12_trail" );
	level._effect[ "contrail12" ]					= loadfx( "maps/ny_harbor/smoke_geo_ssnm12_cheap" );
	level._effect[ "slava_missile_bg" ]					= loadfx( "maps/ny_harbor/smoke_geo_ssnm12_cheap_background" );
	level._effect[ "horizon_flash_runner" ]					= loadfx( "weather/horizon_flash_runner_harbor" );
	level._effect[ "steam_missile_tube"]					= loadfx( "maps/ny_harbor/steam_missile_tube" );	


	/*-----------------------
	MANHATTAN BATTLE FX / AMBIENT
	-------------------------*/	
	level._effect["heli_takeoff_swirl"]							= loadfx ("dust/heli_takeoff_swirl");	
	
	level._effect["falling_dirt_light_runner"]				= loadfx ("dust/falling_dirt_light_runner");	
	level._effect["cloud_ash_nyHarborm"]				= loadfx ("weather/cloud_ash_nyHarbor");
	level._effect["cloud_ash_lite_nyHarbor"]				= loadfx ("weather/cloud_ash_lite_nyHarbor");
	//level._effect["electrical_transformer_spark_runner"]				= loadfx ("explosions/electrical_transformer_spark_runner");	
 	//level._effect[ "bigcity_streetsmoke_obscure" ]					= loadfx( "smoke/bigcity_streetsmoke_obscure" );
 	//level._effect[ "bigcity_streetsmoke_obscure_onfire" ]					= loadfx( "smoke/bigcity_streetsmoke_obscure_onfire" );
	level._effect[ "firelp_med_pm_nolight_atlas" ]							= LoadFX( "fire/fire_med_pm_nolight_atlas" );
	level._effect[ "building_collapse_nyharbor" ]						= loadfx( "dust/building_collapse_nyharbor" );


	
	/*-----------------------
	AMBIENT FX
	-------------------------*/	
	level._effect["lights_godray_default"]			= loadfx("lights/lights_conelight_default");
 	//level._effect[ "steam_large_vent_rooftop" ]					= loadfx( "smoke/steam_large_vent_rooftop" );

	

	//various fires
	level._effect[ "firelp_med_pm" ]							= LoadFX( "fire/firelp_med_pm" );
	
	level._effect[ "firelp_small_pm" ]							= LoadFX( "fire/firelp_small_pm" );
	level._effect[ "firelp_small_pm_a" ]						= LoadFX( "fire/firelp_small_pm_a" );
	level._effect[ "firelp_large_pm" ]							= LoadFX( "fire/firelp_large_pm" );
	level._effect[ "firelp_large_pm_r" ]							= LoadFX( "fire/firelp_large_pm" );
	level._effect[ "firelp_large_pm_r_reflect" ]							= LoadFX( "fire/firelp_large_pm_reflect" );
	level._effect[ "gazfire" ]											= loadfx( "fire/firelp_small_pm" );	

	//columns
	level._effect[ "large_column" ]			 = loadfx( "props/dcburning_pillars" );

	level._effect[ "pipe_steam" ]		 = LoadFX( "impacts/pipe_steam" );
	level._effect[ "firelp_small_pm_nolight" ]					= loadfx( "fire/firelp_small_pm_nolight" );
	level._effect[ "minigun_shell_eject" ] 								= loadfx( "shellejects/20mm_mp" );
	level._effect[ "player_death_explosion" ]				 = loadfx( "explosions/player_death_explosion" );
	level._effect[ "bloodspurt_underwater" ]	 			= loadfx( "water/blood_spurt_underwater" );
	level._effect[ "drips_player_hand" ]	 				= loadfx( "water/drips_player_hand" );
	level._effect[ "wavebreak_oilrig_runner" ]			 = loadfx( "misc/wavebreak_oilrig_runner" );
	level._effect[ "water_froth_oilrig" ]				 = loadfx( "misc/water_froth_oilrig" );
	level._effect[ "water_froth_oilrig_leg_runner" ]	 = loadfx( "misc/water_froth_oilrig_leg_runner" );
	level._effect[ "skybox_mig29_flyby_manual_loop" ]			 = loadfx( "misc/skybox_mig29_flyby_manual_loop" );
	level._effect[ "skybox_hind_flyby" ]			 = loadfx( "misc/skybox_hind_flyby" );
	level._effect[ "bird_seagull_flock_harbor" ]			 = loadfx( "misc/bird_seagull_flock_harbor" );
	level._effect[ "body_splash_railing" ]			 	= loadfx( "impacts/water_splash_bodydump" );	
	level._effect[ "sub_surface_runner" ]			 	 = loadfx( "water/sub_surface_runner" );	
	
	
	level._effect[ "thin_black_smoke_L" ]						= loadfx( "smoke/thin_black_smoke_L" );
	//level._effect[ "cold_breath" ]					= loadfx( "misc/cold_breath" );
	//level._effect[ "smokescreen" ]	 				= loadfx( "smoke/smoke_screen" );
	//level._effect[ "deathfx_bloodpool_underwater" ]	= loadfx( "impacts/deathfx_bloodpool_underwater" );
	//level._effect[ "splash_underwater_stealthkill" ]	= loadfx( "water/splash_underwater_stealthkill" );
 	//level._effect[ "oilrig_drips_riser" ]				= loadfx( "water/oilrig_drips_riser" );
 	//level._effect[ "splash_ring_32_oilrig" ]			= loadfx( "water/splash_ring_32_oilrig" );
 	//level._effect[ "steam_vent_small" ]				= loadfx( "smoke/steam_vent_small" );
 	//level._effect[ "steam_room_100" ]					= loadfx( "smoke/steam_room_100" );
 	//level._effect[ "steam_hall_200" ]					= loadfx( "smoke/steam_hall_200" );
 	//level._effect[ "steam_room_100_orange" ]			= loadfx( "smoke/steam_room_100_orange" );
 	//level._effect[ "steam_hall_200_orange" ]			= loadfx( "smoke/steam_hall_200_orange" );
	//level._effect[ "light_glow_grating_yellow" ]		= loadfx( "misc/light_glow_grating_yellow" );
	//level._effect[ "oilrig_debri_large" ]		 		= loadfx( "misc/oilrig_debri_large" );
 	//level._effect[ "ground_fog_oilrig" ]				= loadfx( "smoke/ground_fog_oilrig" );
 	//level._effect[ "ground_fog_oilrig_far" ]			= loadfx( "smoke/ground_fog_oilrig_far" );
	//level._effect[ "thin_black_smoke_M" ]				= loadfx( "smoke/thin_black_smoke_M_nofog" );
	//level._effect[ "thin_black_smoke_L" ]				= loadfx( "smoke/thin_black_smoke_L_nofog" );
	//level._effect[ "thin_black_smoke_S" ]				= loadfx( "smoke/thin_black_smoke_S_nofog" );
	//level._effect[ "ambush_explosion_03" ]			= loadfx( "explosions/window_explosion_1_oilrig" );
	//level._effect[ "ambush_explosion_room" ]			= loadfx( "explosions/room_explosion_oilrig" );
	level._effect[ "light_c4_blink" ] 		= loadfx( "misc/light_c4_blink" );





	// "hunted light" required zfeather == 1 and r_zfeather is undefined on console.  So, test for != "0".
	if ( getdvarint( "sm_enable" ) && getdvar( "r_zfeather" ) != "0" )
		level._effect[ "spotlight" ]						 = loadfx( "misc/hunted_spotlight_model" );
	else
		level._effect[ "spotlight" ]						 = loadfx( "misc/spotlight_large" );

	level._effect[ "heli_dlight_blue" ]					 = loadfx( "misc/aircraft_light_cockpit_blue" );

	level._effect[ "ship_explosion" ]						= loadfx( "explosions/tanker_explosion" );

	level._effect[ "small_splash_constant" ]	            = LoadFX( "water/small_splash_constant" );
	level._effect[ "ocean_ripple" ] 			            = LoadFX( "misc/ny_harbor_ripple" );



	//----------------  Zodiac FX ---------------------------------------------------------------------
	//Zodiac Wake
	if (!isdefined(level.so_zodiac2_ny_harbor))
		level._effect[ "zodiac_wake_geotrail" ]		 = LoadFX( "treadfx/zodiac_wake_geotrail_harbor" );

	// only ever see the front of the players boat plays on tag_origin	
	level._effect[ "zodiac_leftground" ]		 = LoadFX( "misc/watersplash_large" );

	//Zodiac bigbump
	level._effect[ "player_zodiac_bumpbig" ]	 = LoadFX( "misc/watersplash_large" );
	level._effect[ "zodiac_bumpbig" ]			 = LoadFX( "misc/watersplash_large" );
	level._effect_tag[ "zodiac_bumpbig" ] 		 = "tag_guy2";// pushing this farther forward so the player sees it better.

	//Zodiac bump
	level._effect[ "player_zodiac_bump" ] 		 = LoadFX( "impacts/large_waterhit" );
	level._effect[ "zodiac_bump" ] 				 = LoadFX( "impacts/large_waterhit" );

	//zodiac collision
	level._effect[ "zodiac_collision" ] 		 = LoadFX( "misc/watersplash_large" );
	level._effect_tag[ "zodiac_collision" ] 	 = "TAG_DEATH_FX";// pushing this farther forward so the player sees it better.

/*-----------------------------------------------------------------------------------------------------*/

	//Zodiac Bounce Small Left
	if (!isdefined(level.so_zodiac2_ny_harbor))
	{
		level._effect[ "zodiac_bounce_small_left" ]  		 = LoadFX( "water/zodiac_splash_bounce_small" );
		level._effect_tag[ "zodiac_bounce_small_left" ] 	 = "TAG_FX_LF";
	
		//Zodiac Bounce Small Right
		level._effect[ "zodiac_bounce_small_right" ]  		 = LoadFX( "water/zodiac_splash_bounce_small" );
		level._effect_tag[ "zodiac_bounce_small_right" ] 	 = "TAG_FX_RF";

		//Zodiac Bounce Large Left
		level._effect[ "zodiac_bounce_large_left" ]  		 = LoadFX( "water/zodiac_splash_bounce_large" );
		level._effect_tag[ "zodiac_bounce_large_left" ] 	 = "TAG_FX_LF";
	
		//Zodiac Bounce Large Right
		level._effect[ "zodiac_bounce_large_right" ]  		 = LoadFX( "water/zodiac_splash_bounce_large" );
		level._effect_tag[ "zodiac_bounce_large_right" ] 	 = "TAG_FX_RF";

/*-----------------------------------------------------------------------------------------------------*/

		//Zodiac Turn Hard Left /Hit left
		level._effect[ "zodiac_sway_left" ] 		 = LoadFX( "water/zodiac_splash_turn_hard" );
		level._effect_tag[ "zodiac_sway_left" ] 	 = "TAG_FX_LF";
	
		//Zodiac Turn Hard Right /Hit right
		level._effect[ "zodiac_sway_right" ] 		 = LoadFX( "water/zodiac_splash_turn_hard" );
		level._effect_tag[ "zodiac_sway_right" ] 	 = "TAG_FX_RF";

		//Zodiac Turn Light Left 
		level._effect[ "zodiac_sway_left_light" ] 		 = LoadFX( "water/zodiac_splash_turn_light" );
		level._effect_tag[ "zodiac_sway_left_light" ] 	 = "TAG_FX_LF";
	
		//Zodiac Turn Light Right 
		level._effect[ "zodiac_sway_right_light" ] 		 = LoadFX( "water/zodiac_splash_turn_light" );
		level._effect_tag[ "zodiac_sway_right_light" ] 	 = "TAG_FX_RF";
	}

/*-----------------------------------------------------------------------------------------------------*/

	//sound
	/*
	level.zodiac_fx_sound[ "zodiac_bump" ]		 = "water_boat_splash_small";
	level.zodiac_fx_sound[ "zodiac_bumpbig" ]	 = "water_boat_splash";

	level.zodiac_fx_sound[ "player_zodiac_bump" ]		 = "water_boat_splash_small_plr";
	level.zodiac_fx_sound[ "player_zodiac_bumpbig" ]	 = "water_boat_splash_plr";
	*/

	//two bumps small and big. change them at points in the level to allow more or less visibility. 
	level.water_sheating_time[ "bump_big_start" ] = 2;
	level.water_sheating_time[ "bump_small_start" ] = 1;

	// sheeting time smaller just so action can be more visible.  I'm just trying this I suppose
	level.water_sheating_time[ "bump_big_after_rapids" ] = 4;
	level.water_sheating_time[ "bump_small_after_rapids" ] = 2;

	// water sheating time when the player dies. meant to be really long to cover up some nasty.
	level.water_sheating_time[ "bump_big_player_dies" ] = 7;
	level.water_sheating_time[ "bump_small_player_dies" ] = 3;


	
	// This is the temp effect used for the depth charges

}

tunnel_vent_bubbles_wide()
{
	///level waittill("msg_fx_intro_end");
	wait(2.0);
	fxent = getfx("water_bubbles_wide_sm_lp");
	missile_launchers = [( -16310.6, -24354.9, -1660.94 ),
	( -16400.8, -24309.7, -1662.02 ),
	( -16497.9, -24267.3, -1664.36 ),
	( -16689, -24187.2, -1671.44 ),
	( -16783.8, -24151.6, -1675.71 ),
	( -17898, -23897.2, -1706.4 ),
	( -17587.8, -23942.8, -1699.35 ),
	( -17183.5, -24031.1, -1684.73 ),
	( -17383.1, -23981.5, -1691.34 ),
	( -17690.4, -23924.1, -1700.39 ),
	( -17997.1, -23893.5, -1710.37 ),
	( -18209.7, -23879.2, -1717.74 ),
	( -18417.6, -23876.2, -1725.78 ),
	( -18518.1, -23878.1, -1729.52 ),
	( -15934.2, -24096.8, -1654.38 ),
	( -16135.8, -23991.6, -1662.13 ),
	( -16340.3, -23893.1, -1667.33 ),
	( -16442.7, -23853.6, -1669.35 ),
	( -16653.4, -23773.4, -1673.12 ),
	( -16866, -23704.7, -1678.58 ),
	( -16758.7, -23736, -1675.3 ),
	( -17083.3, -23642.4, -1684.83 ),
	( -18426.4, -23476.4, -1726.16 ),
	( -18765.5, -23491.6, -1736.59 ),
	( -18308, -23478.5, -1720.63 ),
	( -16589.9, -24224.3, -1664.82 ),
	( -16217.1, -24399.8, -1658.26 )];
	
	expAng = [( 270.001, 359.927, -119.927 ),
	( 270.001, 359.653, -113.653 ),
	( 270.001, 359.788, -107.788 ),
	( 270.001, 359.788, -107.788 ),
	( 270.001, 359.788, -107.788 ),
	( 270.002, 359.876, -97.8751 ),
	( 270.001, 359.931, -99.931 ),
	( 270.001, 359.861, -107.86 ),
	( 270.001, 359.861, -107.86 ),
	( 270.001, 359.861, -107.86 ),
	( 270.002, 359.938, -99.9375 ),
	( 270.002, 359.939, -89.9384 ),
	( 270.002, 359.939, -89.9384 ),
	( 270.002, 359.94, -87.9397 ),
	( 270.002, 359.888, 62.1124 ),
	( 270.002, 359.787, 68.2136 ),
	( 270.002, 359.79, 70.2103),
	 ( 270.002, 359.736, 68.2638 ),
	 ( 270.002, 359.736, 68.2638 ),
	 ( 270.002, 359.736, 68.2638 ),
	 ( 270.002, 359.736, 68.2638 ),
	 ( 270.002, 359.736, 68.2638 ),
	 ( 270.002, 359.641, 92.3588 ),
	 ( 270.002, 359.949, 94.0513 ),
	 ( 270.002, 359.948, 94.0518 ),
	( 270.001, 359.788, -107.788 ),
	( 270.001, 359.927, -119.927 )];
    
    ents = [];
	
	for(;;)
	{
		flag_wait("fx_zone_1000_active");
		for(i=0;i<missile_launchers.size;i++)
		{
        	ents[i]=spawnfx(fxent,missile_launchers[i],anglestoforward(expAng[i]),anglestoup(expAng[i]));
        	triggerfx(ents[i]);
		}
        flag_waitopen("fx_zone_1000_active");
		for(i=0;i<ents.size;i++)
		{
			ents[i] delete();
		}
	}
}

tunnel_vent_bubbles()
{
	//level waittill("msg_fx_intro_end");
	wait(2.0);
	fxent = getfx("water_bubbles_longlife_sm_lp");
	missile_launchers = [( -19169.2, -23550.2, -1620.38 ),
	( -17729.9, -23753.6, -1691.15 ),
	( -16714.1, -23923.9, -1686.64 ),
	( -17500.4, -23808.9, -1711.69 ),
	( -18807.6, -23672.9, -1725.55 ),
	( -18674.8, -23735.8, -1742.5 ),
	( -18236.5, -23736.7, -1710.42 ),
	( -16923.1, -23960.2, -1651.07 ),
	( -16422.9, -24120.7, -1676.75 ),
	( -17101.3, -24057.6, -1605.14 ),
	( -17102.5, -24057.6, -1663.11 ),
	( -17568.7, -23952.2, -1619.49 ),
	( -17568.7, -23952.2, -1676.49 ),
	( -18042.9, -23895.6, -1635.93 ),
	( -18043, -23896.5, -1693.51 ),
	( -18517.3, -23887.7, -1652.97 ),
	( -18983.3, -23927.8, -1669.41 ),
	( -19051.3, -23460, -1642.84 ),
	( -18537.1, -23415.3, -1627.26 ),
	( -18013.9, -23423.6, -1611.15 ),
	( -17491.6, -23485.4, -1594.57 ),
	( -16221.2, -24407.5, -1581.35 ),
	( -16651.4, -24209.9, -1648.76 )];
	
    ents = [];
	
	for(;;)
	{
		flag_wait("fx_zone_1000_active");
		for(i=0;i<missile_launchers.size;i++)
		{
        	ents[i]=spawnfx(fxent,missile_launchers[i]);
        	triggerfx(ents[i]);
		}
        flag_waitopen("fx_zone_1000_active");
		for(i=0;i<ents.size;i++)
		{
			ents[i] delete();
		}
	}
}

underwater_particulate_fx()
{
	level endon( "msg_fx_player_surfaced" );
	while(true)
	{
		playfxontag( getfx( "underwater_particulates_player" ), self, "TAG_PROPELLER" );
		wait(.25);
	}
}

underwater_cam_distortion_fx()
{
	level endon( "msg_fx_intro_end" );
	level endon( "msg_fx_player_surfaced" );
	while(true)
	{
		playfxontag( getfx( "harbor_distort_cam" ), self, "TAG_PROPELLER" );
		wait(1);
	}
}

ny_harbor_tunnel_sign_blinky()
{
	self endon( "death" );
	while ( 1 )
	{
		self SetModel( "ny_harbor_tunnel_evacuation_sign_01_alt" );
		wait( randomfloatrange( .001, .15 ) );
		self SetModel( "ny_harbor_tunnel_evacuation_sign_01" );
		wait( randomfloatrange( .001, .25 ) );
	}
}

ny_harbor_tunnel_taxi_rooftop_ad_blinky_base()
{
	self endon( "death" );
	while ( 1 )
	{
		self SetModel( "vehicle_taxi_rooftop_ad_base_on" );
		wait( .5 );
		self SetModel( "vehicle_taxi_rooftop_ad_base_off" );
		wait( .15 );
		self SetModel( "vehicle_taxi_rooftop_ad_base_on" );
		wait( .3 );
		self SetModel( "vehicle_taxi_rooftop_ad_base_off" );
		wait( .65 );
	}
}

ny_harbor_tunnel_taxi_rooftop_ad_blinky()
{
	self endon( "death" );
	while ( 1 )
	{
		self SetModel( "vehicle_taxi_rooftop_ad_2_on" );
		wait( .5 );
		self SetModel( "vehicle_taxi_rooftop_ad_2" );
		wait( .15 );
		self SetModel( "vehicle_taxi_rooftop_ad_2_on" );
		wait( .3 );
		self SetModel( "vehicle_taxi_rooftop_ad_2" );
		wait( .65 );
	}
}


/*****************************************************************
	INTRO FX SEQUENCE START
******************************************************************/
intro_player_bubble_fx()
{
	level endon("msg_fx_intro_end");
	while(true)
	{
		aud_send_msg("player_scuba_bubbles");
		playfxOnTag( getfx( "intro_player_scuba_bubble" ), self, "TAG_PLAYER" );
		wait( 6.0 + randomfloat( 1 ) );
	}
}

intro_npc_bubble_fx()
{
	level endon("msg_fx_intro_end");
	while(true)
	{
		playfxOnTag( getfx( "intro_npc_scuba_bubble" ), self, "TAG_EYE" );
		wait( 2.5 + randomfloat( 2 ) );
	}
}

torch_flare_fx()
{
	exploder(1010);  
	wait(9);//duration of welding animation
	pauseexploder (1010);
	
	level notify("msg_torch_flare_fx_end");
}

intro_vision_reveal()
{
	vision_set_fog_changes("ny_harbor_intro_dark",0);
	setblur(5, 0);
	wait(4);//stay in dark blurry state during wait
	//blend back to normal settings
	vision_set_fog_changes("ny_harbor_intro", 1);
	setblur(0, .75);
}

torch_contrast()
{
	//over ride vision set during torching
	wait(5);//wait x seconds so it doesn't step on intro_vision_reveal
	for(i=0;i<2;i++)
	{
		//iprintlnbold( "vision");
		currVis = getdvar("vision_set_current");
		visionsetnaked("ny_harbor_torch_contrast",.1);//do high contrast
		wait(.1 + randomfloat (.2));
		
		
		visionsetnaked("generic_flash",0);//white out the entire screen
		aud_send_msg("torch_screen_flash");
		setblur(8,0);//make everything blurry
		level.player SetHUDDynLight( 1, ( 1.0, 1.0, 1.0 ) );
		wait(.01 + randomfloat (.02));

		visionsetnaked(currVis,.4);//back to original visionset
		setblur(0,.6);//back to no blur with slight delay
		level.player SetHUDDynLight( 300, ( 0.0, 0.0, 0.0 ) );
		wait( 1.5 + randomfloat( .5 ) );
	}
}

ny_harbor_intro_dof()
{
	wait(5);//wait x seconds so it doesn't step on intro_vision_reveal
	start = level.dofDefault;	

	ny_harbor_dof_intro = [];
	ny_harbor_dof_intro[ "nearStart" ] = 1;
	ny_harbor_dof_intro[ "nearEnd" ] = 2;
	ny_harbor_dof_intro[ "nearBlur" ] = 8;
	ny_harbor_dof_intro[ "farStart" ] = 30;
	ny_harbor_dof_intro[ "farEnd" ] = 420;
	ny_harbor_dof_intro[ "farBlur" ] = 7;	
	
	blend_dof( start, ny_harbor_dof_intro, .2 );
	
	wait(10);
	
	blend_dof ( ny_harbor_dof_intro, start, 1 );
}

ny_harbor_intro_specular()
{
	//tweak specular during intro to address commments
//	wait(1);
	setsaveddvar("r_specularcolorscale", 3.25);
	wait(15);
	{		
		delta = ( 10 - 2.5 ) / 40;
		val = 3.25;
		while( val > 2.5 )
			{
			val = ( val - delta );
			setsaveddvar("r_specularcolorscale", val);
			wait(.05);
			}	
	}	
	setsaveddvar("r_specularcolorscale", 2.5);
}

ny_harbor_enter_sub_shadowfix()
{
	//add fix for sun shadow when player enters sub.
	flag_wait("hatch_player_using_ladder");
	wait(.05);
	{
		delta = ( 5 - 2.5 ) / 60;
		val = .25;
		while( val > .075 )
			{
			val = ( val - delta );
			setsaveddvar("sm_sunsamplesizenear", val);
			wait(.05);
			}	
	}	
	setsaveddvar("sm_sunsamplesizenear", .075);
  wait(5);
  //set sun shadow back to normal
	setsaveddvar("sm_sunsamplesizenear", .25);
}

ny_harbor_enter_zodiac_shadowfix()
{
	//add fix for sun shadow when player enters zodiac.
	flag_wait("get_on_zodiac");
	wait(1);
	{
		delta = ( 5 - 2.5 ) / 60;
		val = .25;
		while( val > .075 )
			{
			val = ( val - delta );
			setsaveddvar("sm_sunsamplesizenear", val);
			wait(.05);
			}	
	}
  wait(1.5);
  //set sun shadow back to normal. Don't notice a pop so not worrying about ramping values.
	setsaveddvar("sm_sunsamplesizenear", .25);
}

torch_grating_rays()
{
	exploder(1020);
	wait(15);
	kill_exploder(1020);//turn off rays.. currently I don't see a pop, might have to revisit.
}

ny_harbor_intro_metal_glow()
{
	//ends of metal after welding go from hot to cool
	wait(0);
	exploder(50000);
	exploder(50001);
	exploder(50002);
	exploder(50003);
	exploder(50004);
	exploder(50005);
	exploder(50006);
	exploder(50007);
	exploder(50008);
	exploder(50009);
	exploder(50010);
	exploder(50011);
	exploder(50012);
	
	//middle ends that stay on longest
	delaythread(10.03, ::kill_exploder, 50000 );
	delaythread(10, ::exploder, 51000 );
	
	delaythread(6.53, ::kill_exploder, 50001);
	delaythread(6.5, ::exploder, 51001);
	
	delaythread(7.03, ::kill_exploder, 50002);
	delaythread(7, ::exploder, 51002);

	delaythread(7.13, ::kill_exploder, 50003);
	delaythread(7.1, ::exploder, 51003);

	delaythread(8.03, ::kill_exploder, 50004);
	delaythread(8, ::exploder, 51004);

	delaythread(7.53, ::kill_exploder, 50005);
	delaythread(7.5, ::exploder, 51005);
	
	//middle ends that stay on longest
	delaythread(11.03, ::kill_exploder, 50006);
	delaythread(11, ::exploder, 51006);
	
	//middle ends that stay on longest
	delaythread(10.23, ::kill_exploder, 50007);
	delaythread(10.2, ::exploder, 51007);
	
	delaythread(8.23, ::kill_exploder, 50008);
	delaythread(8.2, ::exploder, 51008);
	
	delaythread(7.23, ::kill_exploder, 50009);
	delaythread(7.2, ::exploder, 51009);
	
	delaythread(7.03, ::kill_exploder, 50010);
	delaythread(7, ::exploder, 51010);
	
	delaythread(6.83, ::kill_exploder, 50011);
	delaythread(6.8, ::exploder, 51011);
	
	delaythread(6.23, ::kill_exploder, 50012);
	delaythread(6.2, ::exploder, 51012);
}


bubble_on_falling_grate()
{
	wait(15.1);//wait til animation plays til when the grate is being moved
	PlayFxOnTag( getfx( "water_bubbles_tiny_cylind50" ), self, "grate" );
	wait(.1);	
	exploder(1030); //turn on bubbles triggered in env during the grate being moved...
	wait(5);
	StopFxOnTag( getfx( "water_bubbles_tiny_cylind50" ), self, "grate" );
}

bubble_wash_player_exiting_gate()
{
	//play player scuba bubble breath to cover the slight anim pop
	level waittill ("bubble_wash_player_out_gate");	
	wait(5.5);
	playfxOnTag( getfx( "scuba_bubbles_breath_player" ), level.sdv_player_arms, "TAG_PLAYER" );
	//aud_send_msg ("player_scuba_bubbles");
	wait(1.5);
	playfxOnTag( getfx( "scuba_bubbles_breath_player" ), level.sdv_player_arms, "TAG_PLAYER" );
	//aud_send_msg ("player_scuba_bubbles");
	wait(1.0);
	playfxOnTag( getfx( "scuba_bubbles_breath_player" ), level.sdv_player_arms, "TAG_PLAYER" );
}	
/******************************************************************
	INTRO FX SEQUENCE END
*******************************************************************/


/*****************************************************************
	SINKING SHIP FX SEQUENCE START
******************************************************************/
sinking_ship_vfx_sequence()
{
	flag_wait ("start_sinking");
	thread sinking_ship_post_expl_env_vfx();
	thread sinking_ship_elec_shortening_vfx();
	thread sinking_ship_bubbles_vfx();
	thread sinking_ship_post_smk_vfx();
	thread sinking_ship_explosion();
	
	//wait (7.0); //needs to change to a script_flag
	flag_wait( "sinking_ship_fx" );
	thread sinking_ship_flash_vision(); //vision set overwrites
}

sinking_ship_explosion()
{
	data = spawnStruct();
	get_sinking_ship_fx("2900",data);
	flash_locs = data.v["origins"];
	flash_angs = data.v["angles"];
	ents = data.v["ents"];
	flash_playing = [];
	
	for(i=0; i<flash_locs.size;i++)
	{
		flash_playing[i] = 0;
	}
	
	flash_origins = [];
	
	for (i=0; i<flash_locs.size;i++)
	{
		flash_origins[i] = spawn_tag_origin();
		flash_origins[i].origin = flash_locs[i];
		flash_origins[i].angles = flash_angs[i];
		flash_origins[i] linkto(level.fx_dummy,"tag_origin");
	}
	
	for(i=0; i<flash_locs.size;i++)
	{
		//wait (7.0);  //needs to change to a script_flag
		flag_wait( "sinking_ship_fx" );
		PlayFxOnTag( getfx( "ny_harbor_ship_sink_explo" ), flash_origins[i], "tag_origin" );
		aud_send_msg("ship_sink_flash_explosion", flash_origins[i]);
		flash_playing[i] =1;
	}
	
	flag_wait( "russian_sub_spawned" );
	for(i=0; i<flash_locs.size;i++)
	{
		StopFxOnTag( getfx( "ny_harbor_ship_sink_explo" ), flash_origins[i], "tag_origin" );
		flash_origins[i] Delete();
	}
	//wait(8.0);
	//exploder(2900);
	
}

sinking_ship_elec_shortening_vfx()
{
	//level.fx_dummy.origin += (800, 480, -850); //offset to right, further from player, to down
	
	data = spawnStruct();
	get_sinking_ship_fx("2905",data);
	flash_locs = data.v["origins"];
	flash_angs = data.v["angles"];
	ents = data.v["ents"];
	flash_origins = [];
	
	for (i=0; i<flash_locs.size;i++)
	{
		flash_origins[i] = spawn_tag_origin();
		flash_origins[i].origin = flash_locs[i];
		flash_origins[i].angles = flash_angs[i];
		flash_origins[i] linkto(level.fx_dummy,"tag_origin");
	}
	
	for(i=0; i<flash_locs.size;i++)
	{
		PlayFxOnTag( getfx( "ny_harbor_ship_sink_explo_post" ), flash_origins[i], "tag_origin" );
	}
	flag_wait( "russian_sub_spawned" );
	for(i=0; i<flash_locs.size;i++)
	{
		StopFxOnTag( getfx( "ny_harbor_ship_sink_explo_post" ), flash_origins[i], "tag_origin" );
		flash_origins[i] Delete();
	}

}

sinking_ship_bubbles_vfx()
{
	//level.fx_dummy.origin += (800, 480, -850); //offset to right, further from player, to down
	
	data = spawnStruct();
	get_sinking_ship_fx("2910",data);
	flash_locs = data.v["origins"];
	flash_angs = data.v["angles"];
	ents = data.v["ents"];
	
	flash_origins = [];
	
	for (i=0; i<flash_locs.size;i++)
	{
		flash_origins[i] = spawn_tag_origin();
		flash_origins[i].origin = flash_locs[i];
		flash_origins[i].angles = flash_angs[i];
		flash_origins[i] linkto(level.fx_dummy,"tag_origin");
	}
	
	for(i=0; i<flash_locs.size;i++)
	{
		PlayFxOnTag( getfx( "water_bubbles_lg_lp" ), flash_origins[i], "tag_origin" );
		//aud_send_msg("ship_bubble_loops", flash_origins[i]);
	}
	flag_wait( "russian_sub_spawned" );
	for(i=0; i<flash_locs.size;i++)
	{
		StopFxOnTag( getfx( "water_bubbles_lg_lp" ), flash_origins[i], "tag_origin" );
		flash_origins[i] Delete();
	}

}

sinking_ship_post_smk_vfx()
{
	//level.fx_dummy.origin += (800, 480, -850); //offset to right, further from player, to down
	
	data = spawnStruct();
	get_sinking_ship_fx("2915",data);
	flash_locs = data.v["origins"];
	flash_angs = data.v["angles"];
	ents = data.v["ents"];
	
	flash_origins = [];
	
	for (i=0; i<flash_locs.size;i++)
	{
		flash_origins[i] = spawn_tag_origin();
		flash_origins[i].origin = flash_locs[i];
		flash_origins[i].angles = flash_angs[i];
		flash_origins[i] linkto(level.fx_dummy,"tag_origin");
	}
	
	for(i=0; i<flash_locs.size;i++)
	{
		PlayFxOnTag( getfx( "ny_harbor_ship_sink_post_smk" ), flash_origins[i], "tag_origin" );
	}
	flag_wait( "russian_sub_spawned" );
	for(i=0; i<flash_locs.size;i++)
	{
		StopFxOnTag( getfx( "ny_harbor_ship_sink_post_smk" ), flash_origins[i], "tag_origin" );
		flash_origins[i] Delete();
	}

}

get_sinking_ship_fx(num, data)
{
	org = [];
	ang = [];
	ents = [];
	id = string(num);
	exploders = GetExploders( id );
	
	if (isdefined(exploders))
		{
		foreach (ent in exploders)
			{
				org[(org.size)]=ent.v["origin"];
				ang[(ang.size)]=ent.v["angles"];
				ents[(ents.size)]=ent;
			}
		}	
	data.v["origins"] =  org;
	data.v["angles"] = ang;
	data.v["ents"] = ents;
}

sinking_ship_flash_vision()
{
	level.player viewdependent_vision_enable(false);
	//level.player viewdependent_fog_enable(false);
	currVis = getdvar("vision_set_current");
	visionsetnaked("ny_harbor_undrwtr_explo_flash_strong",.1);
	wait(.1);
	visionsetnaked(currVis,.15);
	level.player viewdependent_vision_enable(true);
	//level.player viewdependent_fog_enable(true);
}

sinking_ship_post_expl_env_vfx()
{
	aud_send_msg("sinking_ship_debris_splash");
	exploder(2920);
	flag_wait( "russian_sub_spawned" );
	kill_exploder (2920);
}

/******************************************************************
	SINKING SHIP FX SEQUENCE END
*******************************************************************/


/******************************************************************
	SUB SURFACING UP UNDERWATER EXPLOSION FX SEQUENCE START
*******************************************************************/
minisub_dust_kick_player()
{
	level waittill("start_submarine02");
	wait(1.65);
	playfxOnTag( getfx( "underwater_dust_kick_minisub" ), level.player_sdv, "TAG_PLAYER" );
}

kill_distance_depth_charges()
{
	flag_wait("detonate_torpedo");
	wait(2.3);
	PauseFXID("depth_charge_distance_amb_runr");
}

torpedo_explosion_distance_vfx()
{
	flag_wait( "detonate_torpedo" );
	wait(2.5);
	exploder(4011);//torpedo explosion 1
	wait(0.45);
	exploder(4012);//torpedo explosion 2
}

oscar02_propwash_vfx()
{
	flag_wait( "russian_sub_spawned" );
	playfxontag(getfx("sub_propeller_propwash"),level.russian_sub_02,"tag_left_porpeller");
	playfxontag(getfx("sub_propeller_propwash"),level.russian_sub_02,"tag_right_propeller");
		
	level waittill("submine_planted");
	
	stopfxontag(getfx("sub_propeller_propwash"),level.russian_sub_02,"tag_left_porpeller");
	stopfxontag(getfx("sub_propeller_propwash"),level.russian_sub_02,"tag_right_propeller");
}

oscar02_body_water_displacement_vfx()
{
	flag_wait( "detonate_torpedo" );
	//bubbles only
	playfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_ventback_single4");
	playfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_ventback_single5");
	playfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_fin_b_right");
		
	//waterdisplacement	+ bubbles
	playfxontag(getfx("sub_waterdisp_fin_f"),level.russian_sub_02,"tag_fx_fin_f_right");//front fin right
	playfxontag(getfx("sub_waterdisp_tail"),level.russian_sub_02,"tag_fx_fin_b");//tail
	playfxontag(getfx("sub_waterdisp_head"),level.russian_sub_02,"tag_fx_wake");//head
	playfxontag(getfx("sub_waterdisp_midbody_offset"),level.russian_sub_02,"tag_origin");//mid body
	
	level waittill("entering_mine_plant");
	
	//bubbles only
	stopfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_ventback_single4");
	stopfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_ventback_single5");
	stopfxontag(getfx("water_bubbles_trail_emit"),level.russian_sub_02,"tag_fx_fin_b_right");
	
	//waterdisplacement	+ bubbles
	stopfxontag(getfx("sub_waterdisp_fin_f"),level.russian_sub_02,"tag_fx_fin_f_right");//front fin right
	stopfxontag(getfx("sub_waterdisp_tail"),level.russian_sub_02,"tag_fx_fin_b");//tail
	stopfxontag(getfx("sub_waterdisp_head"),level.russian_sub_02,"tag_fx_wake");//head
	stopfxontag(getfx("sub_waterdisp_midbody_offset"),level.russian_sub_02,"tag_origin");//mid body
}

bubble_transition_entering_mine_plant()
{
	level waittill("entering_mine_plant");
	playfxOnTag( getfx( "nyharbor_sdv_bubble_transition1" ), level.player_sdv.sdv_model, "TAG_PLAYER" );
}

bubble_transition_starting_mine_plant()
{
	level waittill("starting_mine_plant"); 
	//playfxOnTag( getfx( "nyharbor_sdv_bubble_transition2" ), level.player_sdv.sdv_model, "TAG_PLAYER" );
}

bubble_on_player_mine_plant()
{
	level waittill("starting_mine_plant"); 
	wait(2.7);
	playfxOnTag( getfx( "nyharbor_sdv_bubble_transition2" ), level.sdv_player_arms, "TAG_PLAYER" );
}

submine_bubbles_vfx()
{
	playfxontag(getfx("ny_harbor_submine_bubble_tiny"),self,"TAG_FX");
	wait(5.0);
	stopfxontag(getfx("ny_harbor_submine_bubble_tiny"),self,"TAG_FX");
}

cine_sub_surfacing_env_vfx()
{
	level waittill("entering_mine_plant");
	//pause some vfx
	fxid = "ny_harbor_underwater_caustic_ray_long";
	exploders = level.createFXbyFXID[ fxid ];
	
	if (isdefined(exploders))
	{
		foreach (ent in exploders)
		{
			if (ent.v[ "exploder" ] == "3000")
				ent pauseEffect();
		}
	}
	
	exploder(4001);
	level waittill ("msg_fx_player_surfaced");
	kill_exploder (4001);
}

cine_sub_surfacing_explosions()
{
	//sub mine explosion, originally set up in ny_harbor_code_sdv, moving the fx call here
	flag_wait( "detonate_sub" );
	thread sub_mine_explosion_flash();
	wait(0.05);
	playfxontag(getfx("sub_surfacing_explosion1"),level.mine_sub_model,"tag_weapon");
	level.player thread sub_explosion_rumble();
	earthquake ( 0.3, 1.7, level.player.origin, 1024 );	
	flag_wait( "submine_detonated" );//wait for the mine explosion to go off
	
	//trigger 2nd explosion
	wait(.7);
	thread sub_mine_explosion_flash();
	wait(0.05);
	fx_dummy1 = spawn_tag_origin();
	fx_dummy1 linkto(level.russian_cine_sub, "tag_fx_fin_b_left", (175, 0, 450), (0, 0, 0));
	playfxontag(getfx("sub_surfacing_explosion2"),fx_dummy1,"tag_origin");
	level.player thread sub_explosion_rumble();
	earthquake ( 0.25, 1.7, level.player.origin, 1024 );
		
	//trigger 3rd explosion
	wait(1.85);	
	thread sub_mine_explosion_flash();
	wait(0.05);
	fx_dummy2 = spawn_tag_origin();
	fx_dummy2 linkto(level.russian_cine_sub, "tag_fx_ventback_single7", (-200, -100, -100), (0, 0, 0));
	playfxontag(getfx("sub_surfacing_explosion3"),fx_dummy2,"tag_origin");
	level.player thread sub_explosion_rumble();
	earthquake ( 0.4, 1.7, level.player.origin, 1024 );
	
	level notify("sub_surfacing_explosion_vfx_end");
	
	//doing one more long lasting camera shake as the player detaches from sdv
	wait(1.0);
	earthquake ( 0.25, 5, level.player.origin, 2048 ); 
			
	/*
	//trigger 4th explosion
	wait(1.6);	
	thread sub_mine_explosion_flash();
	wait(0.05);
	fx_dummy3 = spawn_tag_origin();
	fx_dummy3 linkto(level.russian_cine_sub, "tag_origin", (0, -450, -50), (0, 0, 0));
	playfxontag(getfx("sub_surfacing_explosion4"),fx_dummy3,"tag_origin");
	thread sub_mine_explosion_flash();
	*/
}

sub_mine_explosion_flash()
{
	level.player viewdependent_vision_enable(false);
	level.player viewdependent_fog_enable(false);
	currVis = getdvar("vision_set_current");
	setblur(10, .5);
	visionsetnaked("ny_harbor_torch_contrast",.05);
	wait(.06);
	visionsetnaked("ny_harbor_undrwtr_explo_flash_light",.05);
	level.player SetHUDDynLight( 1, ( 1.0, 1.0, 1.0 ) );
	wait(.1);
	visionsetnaked(currVis,.1);
	setblur(0, .5);
	level.player SetHUDDynLight( 100, ( 0.0, 0.0, 0.0 ) );
	level.player viewdependent_vision_enable(true);
	level.player viewdependent_fog_enable(true);
}

oscar_cine_water_displacement_vfx()
{
	flag_wait( "submine_planted" );
	
	wait(4.0);
	playfxontag(getfx("sub_waterdisp_midbody_offset"),level.russian_cine_sub,"tag_origin");//mid body
	
	wait(0.2);	//doing more wait because playfxontag can only have 5 tags at any given frame
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_four1");
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single1");
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single3");
	wait(0.2);
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single5");
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single7");
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent8");
	wait(0.2);
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent7");
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent6");
	playfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_tower_back");
	
	flag_wait( "submine_detonated" );
	
	stopfxontag(getfx("sub_waterdisp_midbody_offset"),level.russian_cine_sub,"tag_origin");//mid body
	
	level waittill ("sub_surfacing_explosion_vfx_end");
	
	wait(2.0);
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_four1");
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single1");
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single3");
	wait(0.1);
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single5");
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_ventback_single7");
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent8");
	wait(0.1);
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent7");
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_vent6");
	stopfxontag(getfx("water_bubbles_trail_big_emit"),level.russian_cine_sub,"tag_fx_tower_back");
}

sandman_surfacing_vfx()
{
	//threaded from ny_harbor_code_sub sub_breach_ally()
	level waittill("sub_surfacing_explosion_vfx_end");
	
	playfxontag(getfx("nyharbor_propwash_surfacing_npc"),level.sdv_sandman,"J_Ball_LE");
	playfxontag(getfx("nyharbor_propwash_surfacing_npc"),level.sdv_sandman,"J_Ball_RI");
	
	wait(2.0);
	playfxontag(getfx("scuba_bubbles_NPC"),level.sdv_sandman,"TAG_EYE");
	
	level waittill ("msg_fx_player_surfaced");
	
	wait(2.0);
	stopfxontag(getfx("nyharbor_propwash_surfacing_npc"),level.sdv_sandman,"J_Ball_LE");
	stopfxontag(getfx("nyharbor_propwash_surfacing_npc"),level.sdv_sandman,"J_Ball_RI");
	stopfxontag(getfx("scuba_bubbles_NPC"),level.sdv_sandman,"TAG_EYE");
	
}

player_surfacing_vfx()
{
	level waittill("sub_surfacing_explosion_vfx_end");
	wait(1.85);
	playfxontag(getfx("nyharbor_propwash_surfacing_player"),level.sdv_player_arms,"tag_camera");
	wait(1.4);
	thread player_surfacing_postfx();
}

player_surfacing_postfx()
{
	setblur(4, .5);
	wait(0.2);
	
	level.player viewdependent_vision_enable(false);
	level.player viewdependent_fog_enable(false);
	currVis = getdvar("vision_set_current");
	wait(0.5);
	visionsetnaked("ny_harbor_player_surfacing",.75);
	level.player SetHUDDynLight( 500, ( 1.0, 1.0, 1.0 ) );
	wait(0.35);
	thread hide_underwater_surface_geo();
	wait(0.65);
	visionsetnaked(currVis,.35);
	level.player SetHUDDynLight( 100, ( 0.0, 0.0, 0.0 ) );
	level.player viewdependent_vision_enable(true);
	level.player viewdependent_fog_enable(true);
	wait(.5);
	
	setblur(0, .5);
}

hide_underwater_surface_geo()
{
	underwater_surface_geo = getent("harbor_underwater_geo","script_noteworthy");
	underwater_surface_geo hide();
}

/******************************************************************
	SUB SURFACING UP UNDERWATER EXPLOSION FX SEQUENCE END
*******************************************************************/



starthindDust()
{
	self waittill("msg_fx_start_hindDust");
	playfx(getfx("heli_takeoff_swirl"),(-671,598,16),anglestoforward((0,318,0)),(1,0,0));
}

player_sdv_fx()
{
	while (true)
	{
		//for engine exhaust, sounds, etc.
		self waittill( "moving" );
		if (self ent_flag( "moving" ))
		{	// we are moving
			self thread play_sound_on_tag( "veh_blackshadow_startup", "TAG_PROPELLER" );
			self delaythread( 1,::play_loop_sound_on_tag, "veh_blackshadow_bubble_trail_01", "TAG_PROPELLER", true );
			self delaythread( 1,::play_loop_sound_on_tag, "veh_blackshadow_loop", "TAG_PROPELLER", true );
			
			//PLACE FX HERE
			//playfxontag( getfx( "oilrig_underwater_ambient_emitter" ), self, "TAG_PROPELLER" );
		}
		else
		{	/*-----------------------
			SDV STOPPING
			-------------------------*/		
			self notify( "stop sound" + "veh_blackshadow_loop" );
			self notify( "stop sound" + "veh_blackshadow_bubble_trail_01" );
			self thread play_sound_on_tag( "veh_blackshadow_stop", "TAG_PROPELLER" );
		}
	}
	
}

npc_sdv_fx()
{
	while (true)
	{
		//for engine exhaust, sounds, etc.
		self waittill( "moving" );
		if (self ent_flag( "moving" ))
		{	// we are moving
			self delaythread( 1,::play_loop_sound_on_tag, "veh_blackshadow_bubble_trail_02", "TAG_PROPELLER", true );
			self delaythread( 1,::play_loop_sound_on_tag, "veh_blackshadow_loop_npc", "TAG_PROPELLER", true );
			
			//PLACE FX HERE
			//playfxontag( getfx( "oilrig_underwater_ambient_emitter" ), self, "TAG_PROPELLER" );
		}
		else
		{	/*-----------------------
			SDV STOPPING
			-------------------------*/		
			self notify( "stop sound" + "veh_blackshadow_loop_npc" );
			self notify( "stop sound" + "veh_blackshadow_bubble_trail_02" );
		}
	}	
}

//			displacement = maps\_ocean::GetDisplacementForVertex( level.oceantextures["water_patch"], position );


trigger_harbor_fx()//to be replaced by zone watchers
{
	wait(.6);
	if(flag("entering_water"))
	{
		PauseFXID( "thick_dark_smoke_giant" );
		PauseFXID( "battlefield_smokebank_large" );
		level notify("msg_nyharbor_stoplandexplosions");//kill the land explosions if underwater
		level notify("msg_nyharbor_stopwaterexplosions");//kill the land explosions if underwater
	
		//restart the surface fx once at the slava
		wait(1.0);
		level waittill("msg_breach_fx_ended");//wait til the breach moment is over
		level thread start_harbor_landexplosions();
		level thread start_harbor_waterexplosions();
		exploder(556);//reactivate the antiair runners and the slow water barrage
		RestartFXID( "battlefield_smokebank_large" );
		RestartFXID( "thick_dark_smoke_giant", "oneshotfx" );
		}
	else
	{
		level thread start_harbor_waterexplosions();
		level thread start_harbor_landexplosions();
		exploder(556);//reactivate the antiair runners and the slow water barrage
	}
}


underwater_bleedout( guy )
{
//	iprintlnbold( "Blood" );
	playfxontag( getfx( "deathfx_bloodpool_underwater" ), guy, "J_NECK");


}

knife_blood( playerRig )
{
//	iprintlnbold( "Throat" );
	playfxontag( getfx( "bloodspurt_underwater" ), playerRig, "TAG_KNIFE_FX");

}


underwater_struggle( guy )
{
//	iprintlnbold( "Splash" );
	playfxontag( getfx( "splash_underwater_stealthkill" ), guy, "J_SpineUpper");
}


playerDrips_left( model )
{
	tags_in_arm = [];
	tags_in_arm[ tags_in_arm.size ] = "J_Wrist_LE";
	tags_in_arm[ tags_in_arm.size ] = "J_Thumb_LE_1";
	tags_in_arm[ tags_in_arm.size ] = "J_Thumb_LE_2";

    num = 10;
    for( i = 0 ; i < num ; i++ )
    {
		//iprintlnbold( "left" );
        thread play_drip_fx( tags_in_arm, model );
        wait randomfloatrange( 0.05, 0.3 );
    }
}

playerDrips_right( model )
{
	tags_in_arm = [];
	tags_in_arm[ tags_in_arm.size ] = "J_Wrist_RI";
	tags_in_arm[ tags_in_arm.size ] = "J_Thumb_RI_1";
	tags_in_arm[ tags_in_arm.size ] = "J_Webbing_RI";
	tags_in_arm[ tags_in_arm.size ] = "J_Elbow_RI";

    num = 10;
    for( i = 0 ; i < num ; i++ )
    {
		//iprintlnbold( "right" );
        thread play_drip_fx( tags_in_arm, model );
        wait randomfloatrange( 0.05, 0.3 );
    }
}

play_drip_fx( tags_in_arm, model )
{
    foreach( bone in tags_in_arm )
    {
		playfxontag( getfx( "drips_player_hand" ), model, bone );
    }
}

treadfx_override()
{
	level.treadfx_maxheight = 2000;//
	//tread_effects = "treadfx/tread_snow_slush";
	flying_tread_fx = "treadfx/heli_water_harbor";
	flying_tread_fx_water = "treadfx/heli_water_harbor";
	vehicletype_fx[0] = "script_vehicle_ny_blackhawk";
	vehicletype_fx[1] = "script_vehicle_ch46e_ny_harbor";
	vehicletype_fx[2] = "script_vehicle_mi24p_hind_woodland";
	

	foreach(vehicletype in vehicletype_fx)
	{
	
		maps\_treadfx::setvehiclefx( vehicletype, "brick", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "bark", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "carpet", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cloth", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "concrete", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "dirt", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "flesh", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "foliage", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "glass", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "grass", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "gravel", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ice", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "metal", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "mud", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "paper", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plaster", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rock", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "sand", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "snow", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "water", flying_tread_fx_water );
	 	maps\_treadfx::setvehiclefx( vehicletype, "wood", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "asphalt", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "ceramic", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "plastic", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "rubber", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "cushion", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "fruit", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "painted metal", flying_tread_fx );
	 	maps\_treadfx::setvehiclefx( vehicletype, "default", flying_tread_fx );
		maps\_treadfx::setvehiclefx( vehicletype, "none", flying_tread_fx );
	}



}



//smoke when first door is opened

door_open_smokeout_vfx()
{
	wait(5.7);
	exploder(254);
	//iprintlnbold( "smokeout" );
}

//meet sandman downstairs
head_smash_vfx()
{
	//now using notetrack
	//headkick
	//wait(.78);
	exploder(256);

}

//door breach to control room

door_breach_vision_change()
{
	thread vision_set_fog_changes( "ny_harbor_sub_4_breach", 0 );
}

door_breach_blur()
{
	setblur(6, 0);
	wait(1.0);
	setblur(0, .4);
}

door_breach_flash_vfx()
{
	wait(5.95);
	exploder(261);
}
//door breach to control room
door_breach_vfx(guy)
{
	exploder(257);
	thread vision_set_fog_changes( "ny_harbor_sub_5", 0 );
	wait(1.0);
	exploder(264);
	wait(0.05);
	control_room_seat = getent("control_room_seat", "script_noteworthy");
  	if( isDefined( control_room_seat ) )
  	{
  		control_room_seat hide();
  	}
}

vfx_pipe_burst()
{
	flag_wait("trigger_vfx_pipe_burst");
	aud_send_msg("aud_flooded_room_pipe_burst");
	wait(0.2);
	earthquake ( 0.3, 1.7, level.player.origin, 1024 );
}

vfx_pipe_burst_mr()
{
	flag_wait("trigger_vfx_pipe_burst_mr");
	aud_send_msg("aud_missile_room_pipe_burst");
	wait(0.3);
	earthquake ( 0.4, 1.7, level.player.origin, 1024 );
}

vfx_pipe_burst_cr()
{
	flag_wait("trigger_vfx_pipe_burst_cr");
	aud_send_msg("aud_control_room_pipe_burst");
	wait(0.0);
	earthquake ( 0.4, 1.7, level.player.origin, 1024 );
}

//called from notetrack, notetracks always send guy to the function
greenlighton_vfx( guy )
{
	level.missile_key_panel_box showpart( "tag_lighton" );
	playfxontag(getfx("light_green_pinlight"),level.missile_key_panel_box,"tag_lighton");
	wait(1);
	thread redlighton_vfx();
	exploder(265);
}

redlighton_vfx( guy )
{
	playfxontag(getfx("light_red_pinlight_sort"),level.missile_key_panel,"tag_lighton");
}

//called from notetrack, notetracks always send guy to the function
redlightoff_vfx( guy )
{
	exploder(263);
	level.missile_key_panel hidepart( "tag_lighton" );
	stopfxontag(getfx("light_red_pinlight_sort"),level.missile_key_panel,"tag_lighton");
	thread sub_exit_hatch_light();
}

/*sub_exit_hatch_light()
{
	//light on hatch
	lighthatch = getent("hatch_light", "targetname");
wait(4.2);
	lighthatch setLightIntensity( 4 );
	}	
	*/
	
sub_exit_hatch_light()
{
	light = GetEnt( "hatch_light", "targetname" );
		if( !isdefined( light ) )
		return;
	{  
		wait(3.8); 
		//iprintlnbold( "start fade" );
    delta = .16;
		val = 0.001;
		while( val < 1.75 )
			{
			val = ( val + delta );
      light SetLightIntensity( ( val ) );
   		//iprintlnbold( val );
			wait(.05);
			}		
	}      
	//iprintlnbold( "end fade" );  
	light SetLightIntensity( 1.75 );
}


//water tread fx for sub int
footStepEffects()
{
	animscripts\utility::setFootstepEffect( "water",				loadfx ( "maps/ny_harbor/footstep_water" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"water",		loadfx ( "maps/ny_harbor/footstep_water" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"water",		loadfx ( "maps/ny_harbor/footstep_water" ) );
	animscripts\utility::setFootstepEffectSmall( "water",			loadfx ( "maps/ny_harbor/footstep_water" ) );
}


/*
sub_waterfx( endflag )
{
// currently using these devraw fx:
//	level._effect[ "water_stop" ]						= LoadFX( "misc/parabolic_water_stand" );
//	level._effect[ "water_movement" ]					= LoadFX( "misc/parabolic_water_movement" );

	self endon( "death" );

	if ( IsDefined( endflag ) )
	{
		flag_assert( endflag );
		level endon( endflag );
	}
	for ( ;; )
	{
		wait( RandomFloatRange( 0.15, 0.3 ) );
		start = self.origin + ( 0, 0, 150 );
		end = self.origin - ( 0, 0, 150 );
		trace = BulletTrace( start, end, false, undefined );
		if ( trace[ "surfacetype" ] != "water" )
			continue;

		fx = "nyharbor_water_movement";
		if ( IsPlayer( self ) )
		{
			if ( Distance( self GetVelocity(), ( 0, 0, 0 ) ) < 5 )
			{
				fx = "water_stop";
			}
		}
		else
		if ( IsDefined( level._effect[ "water_" + self.a.movement ] ) )
		{
			fx = "water_" + self.a.movement;
		}

		water_fx = getfx( fx );
		start = trace[ "position" ];
		//angles = vectortoangles( trace[ "normal" ] );
		angles = (0,self.angles[1],0);
		forward = anglestoforward( angles );
		up = anglestoup( angles );
		PlayFX( water_fx, start, up, forward );
	}
}
*/

calc_fire_reflections()
{
//	if(level.createfx_enabled) return 0;
	
	foreach ( fx in level.createFXent )
	{
		if ( !isdefined( fx ) )
			continue;

		if ( fx.v[ "type" ] != "exploder" )
			continue;

		// make the exploder actually removed the array instead?
		if ( !isdefined( fx.v[ "exploder" ] ) )
			continue;

		if ( isdefined( fx.v[ "flag" ] ) )
		{
				if ( fx.v[ "flag" ]=="fire_reflect"  	)		
			{
					fx_origin = fx.v[ "origin" ];
					//water_height = -230;
					//fx_water_origin = (fx_origin[0], fx_origin[1], water_height);
					fx_type = fx.v[ "fxid" ];
					fx thread update_fire_reflections_manager(fx_type,fx_origin);
			}
		}
	}
}

update_fire_reflections_manager(fx_type,fx_origin)
{
	//check distance, if we are close enough run expensive update function
	fx_distance = Distance(fx_origin, level.player.origin);
	while (fx_distance >= 6500)
	{
		fx_distance = Distance(fx_origin, level.player.origin);
		wait 0.25;
	}
	thread update_fire_reflections(fx_type,fx_origin);
}

update_fire_reflections(fx_type,fx_origin)
{
	//spawn reflect fx and update them every frame
	my_tag = spawn_tag_origin();
	my_tag.origin = fx_origin;
	reflectfx = getFx(fx_type + "_reflect");
	if (isDefined(reflectfx))
		playfxontag(reflectfx, my_tag, "tag_origin");
	fx_distance = 1;
	while (fx_distance < 6500)
	{
		fx_distance = Distance(my_tag.origin, level.player.origin);
		angle_vector = my_tag.origin - (level.player geteye());
		constrained_angle = VectorToAngles(angle_vector);
		my_tag.angles = (-90,constrained_angle[1],0);
		wait 0.05;
	}	
	//if we are too far away, remove fx and go back to manager function that runs less frequently
	stopfxontag(reflectfx, my_tag, "tag_origin");
	my_tag delete();
	thread update_fire_reflections_manager(fx_type,fx_origin);
}

play_missile_hit_screenfx(pos)
{
	impactDistance = Distance(pos, level.player.origin);
	if (impactDistance < 7000)
	{
		intensity = 1 - (impactDistance / 7000);
		Earthquake( 0.4, 2, pos, 5500 );
		//screen blur
		setblur(2.0 * intensity, 0.1);
		wait .5;
		setblur(0, 0.4);	
	}
}

loop_skybox_hinds()
{
	waitframe();
	data = spawnStruct();
	get_createfx(999, data);
	ents = data.v["ents"];
	for (i=0; i<ents.size; i++)
	{
		thread loop_skybox_hinds_update(ents[i], "msg_vfx_surface_zone_25000");
	}
}

loop_skybox_hinds_update(fx_ent,fx_flag)
{
	flag_wait(fx_flag);
	wait randomfloat(4);
	endLoc = (anglestoright(fx_ent.v["angles"]) * -50000) + fx_ent.v["origin"];
	/*print("*****************origin is  " + fx_ent.v["origin"] + "\n");
	print("*****************angles are  " + fx_ent.v["angles"] + "\n");
	print("*****************vector is  " + anglestoright(fx_ent.v["angles"]) + "\n");
	print("*****************offset is  " + (anglestoright(fx_ent.v["angles"]) * -50000) + "\n");
	print("*****************endLoc is  " + endLoc + "\n");*/
	aud_data[0] = fx_ent.v["origin"];
	aud_data[1] = endLoc;
	aud_data[2] = 25;
	aud_send_msg("fx_skybox_hind", aud_data);
	fx_ent activate_individual_exploder();
	for(;;)
	{
		flag_wait(fx_flag);
		flag_waitopen("msg_vfx_sub_interior_minus_25000");
	  wait(randomfloat(6) + 10);
		fx_ent activate_individual_exploder();
		aud_send_msg("fx_skybox_hind", aud_data);
	}
}

loop_skybox_migs()
{
	waitframe();
	data = spawnStruct();
	get_createfx(998, data);
	ents = data.v["ents"];
	for (i=0; i<ents.size; i++)
	{
		thread loop_skybox_migs_update(ents[i], "msg_vfx_surface_zone_25000");
	}
}

loop_skybox_migs_update(fx_ent,fx_flag)
{
	flag_wait(fx_flag);
	wait randomfloat(4);
	endLoc = anglestoright(fx_ent.v["angles"]) * -140000 + fx_ent.v["origin"] + (0,0,7000);
	aud_data[0] = fx_ent.v["origin"];
	aud_data[1] = endLoc;
	aud_data[2] = 10;
	aud_send_msg("fx_skybox_mig", aud_data);
	fx_ent activate_individual_exploder();
	for(;;)
	{
		flag_wait(fx_flag);
		flag_waitopen("msg_vfx_sub_interior_minus_25000");
		wait(randomfloat(12) + 4);
		wait 2;
		fx_ent activate_individual_exploder();
		aud_send_msg("fx_skybox_mig", aud_data);
	}
}

play_explode_wave_anim(fire)
{
	wait 0.15;
	self show();
	//attach collision
	collision = getent((self.script_noteworthy + "_col"), "script_noteworthy");
	if(isdefined(collision))
			collision linkto(self, "tag_collision", (0,0,0), (0,-90,0));
	aud_send_msg("explode_wave", collision);		
	self.animname = "explosion_wave";
  self SetAnimTree();
	if (isDefined(fire))
		thread play_wave_fire_fx();
	else
		thread play_wave_fx();
	self anim_single_solo(self, "wave");
	self hide();
}

play_wave_fx()
{
	playfxontag(getfx("wave_crest_spray"), self, "tag_sprayfx");
	wait(1.5);
	stopfxontag(getfx("wave_crest_spray"), self, "tag_sprayfx");
}

play_wave_fire_fx()
{
	playfxontag(getfx("wave_crest_spray_explosion"), self, "tag_sprayfx");
	wait(1.5);
	stopfxontag(getfx("wave_crest_spray_explosion"), self, "tag_sprayfx");
}

start_waves_hidden()
{
	wait 1.0;
	destroyer_wave = getent("destroyer_wave", "script_noteworthy");
	destroyer_wave hide();
	
	ship_splode_1_wave = getent("ship_splode_1_wave", "script_noteworthy");
	ship_splode_1_wave hide();
	
	ship_splode_2_wave = getent("ship_splode_2_wave", "script_noteworthy");
	ship_splode_2_wave hide();
	
	ship_splode_3_wave = getent("ship_splode_3_wave", "script_noteworthy");
	ship_splode_3_wave hide();
	
	ship_splode_4_wave = getent("ship_splode_4_wave", "script_noteworthy");
	ship_splode_4_wave hide();
	
	ship_splode_6_wave = getent("ship_splode_6_wave", "script_noteworthy");
	ship_splode_6_wave hide();
}

get_createfx(num, data)
{
	org = [];
	ang = [];
	ents = [];
	exploders = GetExploders( num );
	foreach (ent in exploders)
		{
				org[(org.size)]=ent.v["origin"];
				ang[(ang.size)]=ent.v["angles"];
				ents[(ents.size)]=ent;
			}
	data.v["origins"] =  org;
	data.v["angles"] = ang;
	data.v["ents"] = ents;
}

setup_poison_wake_volumes()
{
		poison_wake_triggers = getentarray( "poison_wake_volume", "targetname" );
		array_thread( poison_wake_triggers, ::poison_wake_trigger_think);
}

poison_wake_trigger_think()
{
	for( ;; )
	{
		self waittill( "trigger", other );
		if (other ent_flag_exist("in_poison_volume"))
			{}
		else
			other ent_flag_init("in_poison_volume");
		
		if (isDefined (other) && DistanceSquared( other.origin, level.player.origin ) < 9250000)
		{	
			if (other ent_flag("in_poison_volume"))
			{}
			else
			{
				other thread poison_wakefx(self);
				other ent_flag_set ("in_poison_volume");
				/*if(isDefined (other.ainame))
					print(other.ainame + "has entered the poison volume\n");
				else
					print("player has entered the poison volume\n");*/
			}
		}
	}
}


poison_wakefx( parentTrigger )
{
	self endon( "death" );
	thread poison_wake_deathfx();
	speed = 200;
	for ( ;; )
	{
		if (self IsTouching(parentTrigger))
		{
			//loop fx based off of player speed
			if (speed > 5)
				wait(max(( 1 - (speed / 120)),0.1) );
			else
				wait (0.15);
			//if ( trace[ "surfacetype" ] != "wood" )
				//continue;
	
			fx = parentTrigger.script_fxid;
			if ( IsPlayer( self ) )
			{
				speed = Distance( self GetVelocity(), ( 0, 0, 0 ) );
				if ( speed < 5 )
				{
					fx = "footstep_water_slow";
				}
			}
			if ( IsAI( self ) )
			{
				speed = Distance( self.velocity, ( 0, 0, 0 ) );
				if ( speed < 5 )
				{
					fx = "footstep_water_slow";
				}
			}
		
			start = self.origin + ( 0, 0, 64 );
			end = self.origin - ( 0, 0, 150 );
			trace = BulletTrace( start, end, false, undefined );
			water_fx = getfx( fx );
			start = trace[ "position" ];
			//angles = vectortoangles( trace[ "normal" ] );
			angles = (0,self.angles[1],0);
			forward = anglestoforward( angles );
			up = anglestoup( angles );
			PlayFX( water_fx, start, up, forward );
			

		}
		else
		{	
			self ent_flag_clear("in_poison_volume");
				/*if(isDefined (self.ainame))
					print(self.ainame + "has exited the poison volume\n");
				else
					print("player has exited the poison volume\n");*/
			return;
		}
	}
}

poison_wake_deathfx( parentTrigger )
{
	self waittill( "death" );
	if (self ent_flag_exist("in_poison_volume") && self ent_flag("in_poison_volume") && isdefined(self.origin))
		playfx(getfx("death_water"),self.origin, ((270,0,0)));
}

play_slava_missiles()
{
	waitframe();
	level endon("msg_fx_stop_slava_missiles");
	missile_launchers = getentarray("missile_launcher", "targetname");
	lastPlayedExplosion = -1;
	num = 0;
	for(;;)
	{
		flag_wait("msg_vfx_surface_zone_25000");
		flag_waitopen("msg_vfx_sub_interior_minus_25000");
		
		//Find the explosions the player is looking at
		playerAng = level.player getplayerangles();
		eye = vectornormalize(anglestoforward(playerAng));
		found_exp = -1;
		facing_launchers = [];
		for ( i = 0;i < missile_launchers.size;i++ )
		{
			toFX = vectornormalize(missile_launchers[i].origin - level.player.origin);
			facingamount = vectordot(eye,toFX);
			if(vectordot(eye,toFX)>.75) 
			{
				//only add it to list if it wasn't played last time
				if (i != lastPlayedExplosion)
				{
					facing_launchers[facing_launchers.size] = i;
					found_exp = 1;
			}
		}
		}
		//select a random one from the explosions player is looking at and play it
		if ( (found_exp > 0) && (facing_launchers.size > 0) )
		{
			facing_launcher_num = randomInt((facing_launchers.size));
			explosionToPlay = facing_launchers[facing_launcher_num];
			thread slava_missile_trail(missile_launchers[explosionToPlay]);
			lastPlayedExplosion = explosionToPlay;
		}
		//if we can't find a new effect we are looking at, play a random one
		//make sure it wasn't played last time
		else
		{
			while(num == lastPlayedExplosion)
		{
				num = randomint(missile_launchers.size);
					explosionToPlay = missile_launchers[num];
		}
			lastPlayedExplosion = num;
		thread slava_missile_trail(missile_launchers[num]);
		}
		randomwait = randomfloat(2) + 1;
		wait (randomwait);
	}
}
	
slava_missile_trail(ent)
{
	mis = spawn("script_model", ent.origin);
	mis SetModel("vehicle_s300_pmu2");
	mis.angles = ent.angles;
	aud_data[0] = mis;
	aud_send_msg("slava_missile_launch", aud_data);
	PlayFXOnTag( getfx( "slava_missile_bg" ), mis, "tag_fx" );
	impulse = 12000;
	lifetime = 130;
	vectorUp = vectornormalize(anglestoforward(mis.angles));
	finalVector = vectorUp;
	currVel = finalVector * impulse * .05;
	gravity = (0,0,(1600) * -1) * .05 * .05; //squaring the acceleration abount
	explode = 0;
	while(explode == 0)
	{
		mis.origin += currVel;
		currVel += gravity;
		v_orient = vectornormalize(currVel);
		n_angles = vectortoangles(v_orient);
		mis.angles = n_angles;
		level waitframe();
		//once it hits the groudn plane, kill it
		if(mis.origin[2] <= 0)
			explode = 1;
	}
	stopfxontag( getfx( "slava_missile_bg" ), mis, "tag_fx" );
	playfx(getfx("horizon_flash_runner"), mis.origin);
	aud_data[0] = mis.origin;
	aud_send_msg("slava_missile_explode", aud_data);
	mis delete();
}

chinook_extraction_fx()
{
	waitframe();
	if(flag_exist("switch_chinook") == 0)
		flag_init("switch_chinook");
	flag_wait("switch_chinook");
	//play treadfx manually when chinook animation starts
	takeoff = 0;
	while(takeoff == 0)
	{
		fxorigin = level.exit_chinook gettagorigin("tail_rotor_jnt");
		currOrigin = (fxorigin[0], fxorigin[1], -290);
		fxangles = level.exit_chinook.angles;
		currAngles = (270,fxangles[1], 0);
		currVector = anglestoforward(currAngles);
		playfx(getfx("heli_water_harbor_cinematic"), currOrigin, currVector);
		//if(flag("exit_missile_trigger"))
			//takeoff = 1;
		wait 0.1;
	}
}

chinook_screen_watersplash()
{
	//play screen splash fx when zodiac enters chinook
	waitframe();
	flag_wait("fx_chinook_screen_watersplash");
	thread surface_player_water_sheeting_timed(3.0);
}
	
sub_breached_drainage_fx()
{
	//play streaming water when player takes mask off at breached sub, turn it off after a few seconds
	level.player waittill( "stop_breathing" ); 
	exploder(26111);
	wait 3;
	PauseExploders(26111);
}
	
	
	//Effects for the inside of the chinook
chinook_interiorfx()
{
	waitframe();
	if(flag_exist("switch_chinook") == 0)
		flag_init("switch_chinook");
	flag_wait("switch_chinook");
	setsaveddvar("sm_spotlimit",1);
	
	playfxontag(getfx("lights_godray_beam"), level.exit_chinook, "tag_window_light1");	
	playfxontag(getfx("lighthaze_sub_ladder_bottom"), level.exit_chinook, "tag_window_light2");
	//playfxontag(getfx("monitor_glow"), level.exit_chinook, "tag_window_light3");

	playfxontag(getfx("chinook_red_light"), level.exit_chinook, "tag_light_cargo02");

	//playfxontag(getfx("light_c4_blink"), level.exit_chinook, "tag_light_cockpit01");
	playfxontag(getfx("light_c4_blink"), level.exit_chinook, "tag_nearwall");
	playfxontag(getfx("light_c4_blink"), level.exit_chinook, "tag_nearwall2");

	//wait (20);
}

sub_volumetric_lightbeam()
{
	waitframe();
	flag_wait("russian_sub_spawned");
	wait 7.5;
	volumetric_beam = GetEntsByFXID( "sub_volumetric_lightbeam2_static" );
	origin = volumetric_beam[0].v["origin"];
	angles = volumetric_beam[0].v["angles"];
	anim_beam = spawnfx(getfx("sub_volumetric_lightbeam2"), origin, AnglesToForward(angles), AnglesToUp(angles));
	triggerfx(anim_beam);
	wait(0.01);
	volumetric_beam[0] pauseEffect();
	//play fake shadow off front right fin
	playfxontag(getfx("sub_volumetric_shadow_fin_front"),level.russian_sub_02,"tag_fx_fin_f_right");
	//play fake shadow off rear fins
	wait(21.5);
	playfxOnTag(getfx("sub_volumetric_shadow_fin_rear"),level.russian_sub_02,"tag_fx_fin_b_right");
	leftFin = spawn_tag_origin();
	leftFin linkto(level.russian_sub_02, "tag_fx_fin_b_left", (0, -365, -0), (0,0,0));
	playfxOnTag(getfx("sub_volumetric_shadow_fin_rear"),leftFin,"tag_origin");
	flag_waitopen("msg_vfx_udrwtr_b");
	anim_beam delete();
	leftFin delete();
}

disable_ambient_fx()
{
	//stop the land and water explosions
	level notify("msg_nyharbor_stoplandexplosions");
	level notify("msg_nyharbor_stopwaterexplosions");
	level notify("msg_fx_stop_slava_missiles");
	
	//stop fires on the buildings to get particle count back
	kill_exploder(242);
	kill_exploder(252);
}

reenable_ambient_fx()
{
	level thread start_harbor_waterexplosions();
	level thread start_harbor_landexplosions();
	level thread play_slava_missiles();
	exploder(242);
	exploder(252);
}

disable_ambient_under_docks()
{
	wait 3.0;
	flag_wait("msg_fx_under_docks");
	disable_ambient_fx();
	flag_waitopen("msg_fx_under_docks");
	reenable_ambient_fx();
}

sub_explosion_rumble()
{
	time = 0.25;
	counter = 0;
	while( counter < time )
	{
		level.player PlayRumbleOnEntity( "falling_land" );
		wait( 0.05 );
		counter += 0.05;
	}
	StopAllRumbles();
}

// Expects self to be a player
viewdependent_vision_enable( bEnable )
{
	assert( isplayer( self ) );
	self.viewdependent_vision_enabled = bEnable;
}

// Expects self to be a player
viewdependent_fog_enable( bEnable )
{
	assert( isplayer( self ) );
	self.viewdependent_fog_enabled = bEnable;
}
