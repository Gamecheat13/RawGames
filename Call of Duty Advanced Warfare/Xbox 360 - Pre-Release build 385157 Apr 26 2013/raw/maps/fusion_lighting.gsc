/*
	[mapname]_lighting.gsc
	File used for level-specific lighting scripting.
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_lighting;
#include maps\_shg_fx;

main()
{
	waittillframeend;
	
	//mist effect on fly-in
	PreCacheShader( "overlay_rain_blur" );
	PreCacheShader( "overlay_film_grain" );
	
	//////////////////////////////
	// SETUP FUNCTIONS
	thread set_level_lighting_values();
	thread setup_dof_presets();
	thread setup_dof_viewmodel_presets();
	thread setup_flickerLight_presets();
	//Commenting out. It's been veto'd.
	//thread setup_film_grain();
	
	//////////////////////////////
	// EVENT FUNCTIONS
	//set shadow distances, vision sets, exposures, etc
	thread fusion_intro_dof();
	//disable the ar moment vision set
	//thread ar_moment();
	thread sun_shad_vision_fly_in();
	thread lighting_setup_off_zip();
	if(level.currentgen)
	{
		SetSavedDvar("r_specularColorScale", 3);
		SetSavedDvar("r_tonemapExposureMultiplier", 2);
	}
	thread exposure_adjust_courtyard_room();
	thread sun_shad_exposure_control_room();
	thread sun_shad_cooling_tower_area();
	thread sun_shad_cooling_tower_start();
	thread tonemapkey_call();
	thread tonemapkey_call_control_room();
	thread setup_fusion_finale_arm_rimlight();
	thread setup_fusion_finale_light_flicker();
	thread setup_fusion_finale_lightgrid();
	thread setup_fusion_finale_light_rim();
	thread setup_fusion_finale_light_secondary_rim();
	thread setup_fusion_finale_arm_fx();
	thread setup_fusion_light_model_flicker();
	thread setup_fusion_light_model_flicker2();
	thread setup_fusion_light_model_flicker3();
	//thread hide_fusion_street_lights_off();
	
	//interior
	thread setup_dof_security();
	thread elevator_fall_dof_tweaks();
	thread setup_lighting_lab_start();
	thread setup_lab_script_volume();
	thread setup_lighting_reactor_start();
	thread setup_lighting_reactor_exit_start();
	thread lighting_setup_turbine_elevator();
	thread setup_lighting_turbine_start();
	thread setup_lighting_control_room_start();
	thread setup_control_room_door_explosion_light();
	thread setup_control_room_screen_light();
	thread setup_control_room_scene_DOF();
	thread reactor_reveal_lighting();
	thread lighting_setup_reactor_door();

	light = GetEnt( "cooling_towers_fire_light", "targetname" );
	if ( IsDefined( light ) )
		light SetLightIntensity( 0 );
	
	level.player thread fusion_zip_dof();
}

LinearLerp(curVal, newVAl, alphaVal)
{
	return abs((curVal * (1-alphaVal) + newVAl * alphaVal));
}

SimCurrentGenDynamicExpossure()
{
	while(true)
	{
		prof_begin("fake hdr");
		traceMaxDist = 5000;
		playerAngles = level.player GetPlayerAngles();
		
		playerForwardA = AnglesToForward(playerAngles);
		playerForwardB = AnglesToForward(playerAngles + (-15, 0, 0));
		playerForwardC = AnglesToForward(playerAngles + (15, 45, 0));
		playerForwardD = AnglesToForward(playerAngles + (15, 45, 0));
		
		playerPos = level.player.origin + (0,0,64);
		
		traceEndA = playerPos + (playerForwardA * traceMaxDist);
		traceEndB = playerPos + (playerForwardB * traceMaxDist);
		traceEndC = playerPos + (playerForwardC * traceMaxDist);
		traceEndD = playerPos + (playerForwardD * traceMaxDist);
		
		sunDir = GetMapSunDirection();
		
		trace1 = BulletTrace(playerPos + (playerForwardA * 3), traceEndA, false, undefined);
		trace2 = BulletTrace(playerPos + (playerForwardB * 3), traceEndB, false, undefined);
		trace3 = BulletTrace(playerPos + (playerForwardC * 3), traceEndC, false, undefined);
		trace4 = BulletTrace(playerPos + (playerForwardD * 3), traceEndD, false, undefined);
		
		//Line( start, trace[ "position" ], ( 0.9, 0.5, 0.8 ), 0.5 );
		
		hitdist1 = Distance( playerPos, trace1[ "position" ] );
		hitdist2 = Distance( playerPos, trace2[ "position" ] );
		hitdist3 = Distance( playerPos, trace3[ "position" ] );
		hitdist4 = distance( playerPos,	trace4[ "position" ] );
		
		averageDist = (hitdist1 + hitdist2 + hitdist3 + hitdist4)/4;
		
		vdot = max( vectordot(sunDir, playerForwardA), 0);
		
		alphaVal = (averageDist/traceMaxDist) * vdot;
		
		newExp = LinearLerp(9.5, 11, alphaVal);
		SetSavedDvar("r_tonemapexposure", newExp);
		prof_end("fake hdr");
		wait .55;
	}
	
}

set_level_lighting_values()
{
	
	// Can ovverride level hdr values if needed
	if ( IsUsingHDR() )
	{
		if ( is_gen4() )
		{
			//SetSavedDvar( "r_subdiv", 0 );
			SetSavedDvar( "r_sssssskin", 1 );
			SetSavedDvar( "r_sssssstrength", 1.5 );
			SetSavedDvar( "r_sssssfollowsurface", 0.4 );
		}
		
		//setSavedDvar("r_tonemap", 1);
		//setSavedDvar("r_tonemapadaptspeed", .02 );
		//setsaveddvar("r_veil", 1);
		//setsaveddvar("r_veilstrength", .087);
		//setSavedDvar("r_tonemapkey", 0.0);
		//setSavedDvar("r_tonemapexposure", -10.0);
		//setSavedDvar("r_tonemapmaxexposure", 8.25);
		//setsaveddvar( "r_particleHdr", 1);		
		

		setsaveddvar("r_disableLightSets", 0 );
		setsaveddvar("r_tonemapCrossover", 2 );
		setsaveddvar("r_tonemapShoulder", .95 );
		setsaveddvar("r_tonemapToe", .2 );
		//setsaveddvar("Sm_spotlightscoreradiuspower", .6 );
		
		
		//set env ssao settings for fusion
		if ( IsUsingSSAO() )
		{
			//setSavedDvar("r_ssaoPower", 12.0);
			//setSavedDvar("r_ssaoStrength", 0.45);
			//setsavedDvar("r_ssaominstrengthdepth", 25.0);
			//("r_ssaomaxstrengthdepth", 40.0);
		}
	}
	
}

setup_dof_presets()
{
	//							name			nStart	nEnd	nBlur	fStart	fEnd	fBlur	fBias
	create_dof_preset("fusion_intro", 		10,		18, 	10, 	25, 	150, 	4.5,	0.5);
	create_dof_preset("fusion_pre_zip",		 0,		0,		4.5, 	0, 		140, 	3, 		0.5);
	create_dof_preset("fusion_fly",		 		10,		50,		4, 		3500, 	9000, 	1.5,	0.5);
	create_dof_preset("fusion_fly_rack_nblur",	1,		310,	4, 		3500, 	9000, 	1.5,	0.5);	
	create_dof_preset("fusion_ready_zip",		1,		2,		4, 		300, 	9000, 	2.0, 	2.75);
	create_dof_preset("fusion_zip",		 		100,	585,	4.5, 	810, 	16000, 	4.5, 	0.5);

	//2nd half of level
	create_dof_preset("fusion_security",	    2,	   	50,	    4, 	    400, 	5000, 	2.0, 	0.5);
	create_dof_preset("fusion_elevator_fall",	2,	   	750,	4, 	    1000, 	7000, 	1.8, 	0.5);
	create_dof_preset("fusion_interior",	    10,	   	40,	    6, 	    400, 	1300, 	0.5, 	0.5);
	create_dof_preset("fusion_reactor_reveal",	0,	   	60,		5, 		350, 	1400, 	1.6, 	0.5);
	create_dof_preset("fusion_ctrl_room_scene",	0,	   	90,		5, 		500, 	1500, 	2.5, 	0.5);
	create_dof_preset("fusion_control_room",	0,	   	60,		5, 		1000, 	8000, 	2.5, 	0.5);
	create_dof_preset("fusion_finale_collapse",	0,	   	100,	5, 		1300, 	16000, 	4.0, 	0.5);
	create_dof_preset("fusion_finale_arm",		8,		30,		6.5, 	300, 	3200, 	5.0, 	0.5);
	create_dof_preset("fusion_finale_closeup",	2,		5,		4, 		300, 	3200, 	2.0, 	0.5);
}

setup_dof_viewmodel_presets()
{
	//							name			  start     end
	create_dof_viewmodel_preset("fusion_vm_fly_rack_nblur",	2,		10);
	create_dof_viewmodel_preset("fusion_vm_off",			0,		0);
}


setup_flickerLight_presets()
{		
	//name												color0								color1										minDelay		maxDelay	intensity
	create_flickerLight_preset("fusion_fire", 			( 0.972549, 0.624510, 1 ),			 ( .2, 0.1462746, 1 ), 						.005, 			.2,			5 );
}

setup_film_grain()
{
	start_jitter_grain_effect();
}

///////////////////////// LIGHTING WARBIRD ///////////////////////////////
fusion_intro_dof()
{
	flag_wait( "sun_shad_fly_in" );
	if(level.nextgen)
	{
		blend_dof_presets( "default", "fusion_intro", .1);
	}
	else
	{
		// dof looks very low res in current gen so we are just using the default values
		blend_dof_presets( "default", "default", .1 );
	}

	level waittill( "hatch_door_open" );
	
	//blinking interior light red when door opens
	//just temp comment this out for now while trying to debug door light issue
	PlayFxOnTag(getfx("light_point_heli_interior_blink"), level.warbird_a, "TAG_burke_key_light");
	
	if(level.currentgen == true)
	{
		SetSavedDvar("r_tonemapExposureMultiplier", 4);
	}
	
	thread screenshake( .15, 20, 1, 5);
	thread hill_sunflare();
	
	wait(2.5);
	
	//kill interior monitor lights and burke key light
	StopFxOnTag(getfx("light_point_blue_mon_left"), level.warbird_a, "TAG_monitor_left_light");
	StopFxOnTag(getfx("light_point_blue_mon_right"), level.warbird_a, "TAG_monitor_right_light");
	StopFxOnTag(getfx("light_spot_key_burke"), level.warbird_a, "TAG_burke_key_light");
	
	if(level.nextgen)
	{
		blend_dof_presets( "fusion_intro", "fusion_fly", 2);
	}
	else
	{
		blend_dof_presets( "default", "default", .1 );
	}
	thread script_probe_heli_open();
	
	//tune shadows to help frame rate. Not a very elegant solution, but using wait's works.
	thread frame_rate_tune_shadows_up_over_cliff();
	thread frame_rate_tune_shadows_heli_crash();
	thread frame_rate_tune_shadows_turn_to_right();
	thread frame_rate_tune_shadows_roof_top();
	
	//start the rack focus effect to blur the foreground and viewmodel
	wait(45);
	if(level.nextgen)
	{
		blend_dof_presets( "fusion_fly", "fusion_fly_rack_nblur", 1);
		blend_dof_viewmodel_presets( "default", "fusion_vm_fly_rack_nblur", 1);
	}
	else
	{
		blend_dof_presets( "default", "default", .1 );
	}
	
	//set light grid colors back to normal or else all enemies and guys zipping off are very dark.
	wait(3);
	lerp_savedDvar("r_lightgridintensity", 1.0, 5);
	
	//ready zip is when you have killed all enemies
	flag_wait("ready_zip");
	
	if(level.nextgen)
	{
		blend_dof_presets( "fusion_fly_rack_nblur", "fusion_ready_zip", .75);
	}
	else
	{
		blend_dof_presets( "default", "default", .1 );
	}
	
	//wait until you get harpoon gun before using default probe behavior on heli
	flag_wait("flag_player_zip_started");
	thread script_probe_heli_default();
	
	//kill all vfx lights on heli
	StopFxOnTag(getfx("light_point_open_door"), level.warbird_a, "TAG_open_door");
	StopFxOnTag(getfx("light_point_heli_interior_blink"), level.warbird_a, "TAG_burke_key_light");
}

frame_rate_tune_shadows_up_over_cliff()
{
	wait(22);
	//as heli comes up over cliff
	setsaveddvar("r_disablelightsets", 1 );
	lerp_savedDvar( "sm_sunsamplesizenear", 0.25, 1.0 );
}

frame_rate_tune_shadows_heli_crash()
{
	wait(33);
	//just prior to heli impact and crash
	lerp_savedDvar( "sm_sunsamplesizenear", 0.22, 1.0 );
}

frame_rate_tune_shadows_turn_to_right()
{
	wait(39);
	//just prior to heli impact and crash
	lerp_savedDvar( "sm_sunsamplesizenear", 0.15, 1.0 );
}

frame_rate_tune_shadows_roof_top()
{
	wait(55);
	//just before rooftop moment
	lerp_savedDvar( "sm_sunsamplesizenear", 0.074, 1.0 );
}

ar_moment()
{
	flag_wait("fx_ar_start");
	//start_jitter_grain_effect();
	vision_set_fog_changes("fusion_helicopter_ar", 1);
	flag_wait("fx_ar_stop");
	//stop_jitter_grain_effect();
	vision_set_fog_changes("fusion_helicopter", 1);
}

start_jitter_grain_effect()
{
	level._light.jitter_grain_effect_active = true;
	thread jitter_grain_effect_loop();
}
		
stop_jitter_grain_effect()
{
	level._light.jitter_grain_effect_active = false;
}
		
jitter_grain_effect_loop()
{
	assert( IsDefined( level._light.jitter_grain_effect_active ) );
	effect_duration = 	0.05;
	fadein 			= 	0.0;
	fadeout 		= 	0.0;
	max_alpha 		= 	1.0;
	
	while (level._light.jitter_grain_effect_active)
	{	
				rand_x = RandomFloatRange( -60, 0);
				rand_y = RandomFloatRange( -60, 0);
	
		// play_fullscreen_film_grain pauses the thread for "effect_duration"
		level.player play_fullscreen_film_grain( effect_duration, fadein, fadeout, max_alpha, rand_x, rand_y );
	}
}
	
fusion_zip_dof()
{
	level.player waittill( "using_zip" );
	
	//cheat to get harpoon moment dark
	SetSavedDvar("r_lightgridenabletweaks", 1);
	if(level.nextgen == true)
	{
		lerp_SavedDvar("r_lightgridintensity", .05, .5 );
	}
	else
	{
		lerp_SavedDvar("r_lightgridintensity", .05*7, .5 );
	}
	
	
	//set ssao to get better contact between hands and harpoon
	if ( IsUsingSSAO() )
	{
		SetSavedDvar("r_ssaoMinStrengthDepth", 0);
		SetSavedDvar("r_ssaoMaxStrengthDepth", 1);
		SetSavedDvar("r_ssaoStrength", .8);
	}
	
	if(level.nextgen)
	{
		blend_dof_presets( "fusion_ready_zip", "fusion_pre_zip", .5);
		wait(1.5);
		blend_dof_presets( "fusion_pre_zip", "fusion_ready_zip", .5 );
		wait(1);
	}
	else
	{
		blend_dof_presets( "default", "default", .1 );
		wait(2.5);
	}
	
	//set it back after harpoon grab
	if(level.nextgen == true)
	{
		lerp_SavedDvar("r_lightgridintensity", 1, .5 );
	}
	else
	{
		lerp_SavedDvar("r_lightgridintensity", 1, .5 );
	}
	SetSavedDvar("r_lightgridenabletweaks", 0);
	
	//set ssao back to original settings after harpoon grab
	if ( IsUsingSSAO() )
	{
		SetSavedDvar("r_ssaoMinStrengthDepth", 25);
		SetSavedDvar("r_ssaoMaxStrengthDepth", 40);
		SetSavedDvar("r_ssaoStrength", .45);
	}
	
	
	self waittill( "fastzip_start" );

	if(level.nextgen)
	{
		wait(2);
		blend_dof_presets( "fusion_ready_zip", "fusion_zip", .2 );
		wait(2);
		blend_dof_presets( "fusion_zip", "default", 1 );
	}
	else
	{
		blend_dof_presets( "default", "default", .1 );
		wait(4);
	}
	
	//turn viewmodel dof off
	blend_dof_viewmodel_presets( "fusion_vm_fly_rack_nblur", "fusion_vm_off", 2);
}

sun_shad_vision_fly_in()
{
	flag_wait( "sun_shad_fly_in" );

  	setsaveddvar("sm_sunsamplesizenear", .15 );
  	
  	//set light grid color dark
  	thread set_grid_color_dark();
  	
  	//set reflection probe manually
  	thread script_probe_heli_closed();
  	
  	//Set exposure manually for door closed heli.
  	//calling lightset for dark heli intro
  	level.player lightsetforplayer("fusion_helicopter_intro");
  	//vfx lighting inside heli
  	thread setup_vfx_lighting();
 	
	vision_set_fog_changes( "fusion_helicopter", 0.0 );
}

setup_vfx_lighting()
{
		
	//center console light
	//PlayFxOnTag(getfx("light_point_cockpit"), level.warbird_a, "TAG_monitor_top_light");
	
	//smoke rays in cockpit
	if(level.currentgen)
	{
		PlayFxOnTag(getfx("light_godray_02_warbird"), level.warbird_a, "TAG_godray_cg");
	}

	
	PlayFxOnTag(getfx("light_godray_02"), level.warbird_a, "TAG_godray");
	
	
	//monitor on the left side
	PlayFxOnTag(getfx("light_point_blue_mon_left"), level.warbird_a, "TAG_monitor_left_light");
	
	//monitor on the right side
	PlayFxOnTag(getfx("light_point_blue_mon_right"), level.warbird_a, "TAG_monitor_right_light");
	
	thread burke_spot_lighting();
	
	if ( level.currentgen )
	{
		level waittill( "hatch_door_open" );
		StopFxOnTag(getfx("light_godray_02_warbird"), level.warbird_a, "TAG_godray_cg");
	}
}
	
burke_spot_lighting()
{
	//rim light setup wait during black fadeup of level
	wait(11);
	PlayFxOnTag(getfx("light_spot_rim_burke_fadeout"), level.warbird_a, "TAG_burke_rim_light");
	//kill rim light after it fades out. Duration is part of effect file.
	wait(10.05);
	StopFxOnTag(getfx("light_spot_rim_burke_fadeout"), level.warbird_a, "TAG_burke_rim_light");
	//wait and then play key light. Can't have these overlap due to 1 primary spot limit.
	wait(.1);
	//PlayFxOnTag(getfx("light_spot_key_burke"), level.warbird_a, "TAG_burke_key_light");
	//need local control for effect placement since the warbird is not exporting correctly right now.
	origin_key_burke = spawn_tag_origin();
    origin_key_burke linkto(level.warbird_a,"TAG_burke_key_light", (-8,-35,5), (0,40,0));
    PlayFxOnTag(getfx("light_spot_key_burke"), origin_key_burke, "TAG_ORIGIN");
}

fusion_fly_player_mist()
{
	rand_wait_0 = RandomFloatRange(.2, 3);
	level.player delaythread(rand_wait_0, ::play_fullscreen_mist, 3, .1, 1.5, .6, 0, 0);
	rand_wait_1 = RandomFloatRange(.2, 3);
	level.player delaythread(rand_wait_1, ::play_fullscreen_mist, 3.5, .1, 1.5, .6, 50, -50);
	rand_wait_2 = RandomFloatRange(.2, 3);
	level.player delaythread(rand_wait_2, ::play_fullscreen_mist, 4, .1, 1.5, .6, -50, 50);
	rand_wait_3 = RandomFloatRange(.2, 3);
	level.player delaythread(rand_wait_3, ::play_fullscreen_mist, 4.5, .1, 1.5, .6, 20, 20);
}

lighting_setup_off_zip()
{
	flag_wait( "sun_shad_off_zip" );
	SetSavedDvar( "sm_usedsuncascadecount", 3 );
  	setsaveddvar("sm_sunsamplesizenear", .11 );
	
	if ( IsUsingHDR() )
	{
		setsaveddvar("r_veilstrength", .15);
	
		//Set exposure manually. Key defaults to .393 so making it darker
		setsaveddvar("r_tonemapmaxexposure", -10);
   		setsaveddvar("r_tonemapkey", .25);
	}
  		
	if(level.currentgen == true)
	{
		SetSavedDvar("r_tonemapExposureMultiplier", 2);
	}
	
	vision_set_fog_changes( "fusion_battle_exterior", 10.0 );
	thread battle_exterior_sunflare();
	thread fusion_fastzip_quake();
	//turning lightsets back on after getting off zipline...
	setsaveddvar("r_disablelightsets", 0 );
}

fusion_fastzip_quake()
{
	// waittill("fastzip_arrived");
	//iprintlnbold("end!!!");
	Earthquake( 0.2, 1, level.player.origin, 1600 );
	//setblur(4, .1);
	//wait(.3);
	//setblur(0, 1);	
}

set_grid_color_dark()
{
	//must run before the reflection probe assignment or else it breaks.
	wait(4);
	
	level.warbird_a StartUsingHeroOnlyLighting();
	
    foreach(prop in level.warbird_a.zipline_gun_model)
    	{
    		prop StartUsingHeroOnlyLighting();
   	 	}
	
	SetSavedDvar("r_lightgridenabletweaks", "1");
	if(level.nextgen == true)
	{
		SetSavedDvar("r_lightgridintensity", ".03");
	}
	else
	{
		SetSavedDvar("r_lightgridintensity", ".35");
	}
}

script_probe_heli_closed()
{	
	//must run after the light grid assignment (above) or else it breaks.
	//this used to be 10 but it broke the second check point so i reduced it to 5
	wait(5);
		
	refl_closed = GetEnt( "refl_probe_heli_closed", "targetname" );
	//refl_closed = GetEnt( "refl_probe_heli_gray", "targetname" );
	

	level.warbird_a OverrideReflectionProbe(refl_closed.origin);
	level.burke OverrideReflectionProbe(refl_closed.origin);
	level.joker OverrideReflectionProbe(refl_closed.origin);
	level.guy_facing_player_intro OverrideReflectionProbe(refl_closed.origin);
	level.copilot_intro OverrideReflectionProbe(refl_closed.origin);
	level.pilot_intro OverrideReflectionProbe(refl_closed.origin);
		
	foreach(prop_closed in level.warbird_a.zipline_gun_model)
    {
       	 prop_closed OverrideReflectionProbe(refl_closed.origin);
	}
}

script_probe_heli_open()
{
	refl_open = GetEnt( "refl_probe_heli_open", "targetname" );
	
	level.warbird_a OverrideReflectionProbe(refl_open.origin);
	level.burke OverrideReflectionProbe(refl_open.origin);
	level.joker OverrideReflectionProbe(refl_open.origin);
	level.copilot_intro OverrideReflectionProbe(refl_open.origin);
	level.pilot_intro OverrideReflectionProbe(refl_open.origin);

	foreach(prop_open in level.warbird_a.zipline_gun_model)
    {
		prop_open OverrideReflectionProbe(refl_open.origin);
    }
	if(level.currentgen)
	{
		wait(2.0);
		vision_set_changes("fusion_zipline", 1.0);
	}
}

script_probe_heli_default()
{
	//just set warbird back to default players and harpoon are already removed	
	level.warbird_a DefaultReflectionProbe();
	level.burke DefaultReflectionProbe();
	level.joker DefaultReflectionProbe();
}


hatch_door_veil(heli)
{
	level notify("hatch_door_open");
	//turning on fx wave sequences
	wait 5;
	exploder(1020);
	wait 4;
	exploder(1021);
	wait 8;
	exploder(1022);
}


hatch_door_vision(heli)
{			
	//try increasing the shadow cascade count
	SetSavedDvar( "sm_usedsuncascadecount", 3 );
	
  	setsaveddvar("sm_sunsamplesizenear", .3 );
	
	SetSavedDvar( "sm_sunshadowscale", 1.0 );
	
	//light turns on when door is opened for more burke fill
	wait(.5);
	PlayFxOnTag(getfx("light_point_open_door"), level.warbird_a, "TAG_open_door");
	
	wait(2.5);
	
	thread fusion_fly_player_mist();
	
	//control the duration of overexposed look here. Currently cut down to 1 second.
	//calling lightset for door open
	level.player lightsetforplayer("fusion_helicopter_door");
	vision_set_fog_changes( "fusion_helicopter_open", 1.5 );
	
	//disabling lightsets here so sunsample tuning during heli flight is not disturbed
	level.player lightsetforplayer("fusion_default_exterior_lightset");
	
	
	wait(12);
	
	//spray when destroyed heli comes close
	delaythread(21.8, ::fusion_fly_player_mist);
}

hatch_door_lightgrid_off(heli)
{
	//level waittill( "hatch_door_open" );
	wait(4.5);
	
	//bump up light grid intensity when door opens 
	if(level.nextgen == true)
	{
		lerp_SavedDvar("r_lightgridintensity", .1, 2 );
	}
	else
	{
		lerp_SavedDvar("r_lightgridintensity", .1*7, 2 );
	}
	
}

hatch_door_push_fog_out(heli)
{
	wait(24);
	vision_set_fog_changes("fusion_helicopter_closeup", 3);
	//SetSavedDvar( "r_sunflare_max_alpha", 1 );
	//SetSavedDvar( "r_sunflare_min_size", 400 );
	//SetSavedDvar( "r_sunflare_max_size", 1000 );
	//SetSavedDvar( "r_sunsprite_size", 300 );
	//thread hill_sunflare();
	wait(14);
	vision_set_fog_changes( "fusion_zipline", 3 );
}

hill_sunflare()
{
	thread maps\_shg_fx::fx_spot_lens_flare_dir("light_sunflare",(-20, 110, 0),8000);
	//SetSunFlarePosition(( -25, 105, 0 ));
	//have to wait here as the flare does some strange stuff if turned on earlier.
	//wait(35.5);
	//flag_set("fx_spot_flare_kill");
	//wait(.1);
	//flag_clear("fx_spot_flare_kill");
}

battle_exterior_sunflare()
{
	thread maps\_shg_fx::fx_spot_lens_flare_dir("light_sunflare",(-20, 110, 0),8000);
}

//Add screen effect for mist on player during fly-in
play_fullscreen_mist(time, fadein, fadeout, max_alpha, xpos, ypos)
{
	assertEx(  time - (fadein + fadeout) > 0, "Time must be greater than sum of fadein and fadeout" );

	overlay = NewClientHudElem( self );
	overlay.x = xpos;
	overlay.y = ypos;

	overlay SetShader( "overlay_rain_blur", 640, 480 );
	
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	
	fade_counter = 0;
	if (!IsDefined(fadein))
		fadein = 1;
	if (!IsDefined(fadeout))
		fadeout = 1;
	if (!IsDefined(max_alpha))
		max_alpha = 1;
	
	//fade up
	step_time = 0.05;
	
	if ( fadein > 0 )
	{
		current_alpha = 0;
		increment_alpha = max_alpha / (fadein/step_time); 
		AssertEx( increment_alpha > 0, "alpha not increasing; infinite loop" );
		while ( current_alpha < max_alpha )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha + increment_alpha;
			wait step_time;
		}
	}
	
	overlay.alpha = max_alpha;
	
	// time must be greater than sum of fadein and fadeout
	wait(time - (fadein + fadeout));

	//fade down
	if ( fadeout > 0 )
	{
		current_alpha = max_alpha;
		decrement_alpha = max_alpha / (fadeout/step_time);
		AssertEx( decrement_alpha > 0, "alpha not decreasing; infinite loop" );
		while ( current_alpha > 0 )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha - decrement_alpha;
			wait step_time;
		}
	}
	
	overlay.alpha = 0;
	overlay destroy();
}

//Add screen effect for film grain effect vs. using night vision shader stuff.
play_fullscreen_film_grain(time, fadein, fadeout, max_alpha, xpos, ypos)
{
	assertEx(  time - (fadein + fadeout) > 0, "Time must be greater than sum of fadein and fadeout" );
	
	overlay = NewClientHudElem( self );
	overlay.x = xpos;
	overlay.y = ypos;
	
	overlay SetShader( "overlay_film_grain", 700, 540 );
	
	overlay.splatter = true;
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.foreground = 0;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = 0;
	
	fade_counter = 0;
	if (!IsDefined(fadein))
		fadein = 1;
	if (!IsDefined(fadeout))
		fadeout = 1;
	if (!IsDefined(max_alpha))
		max_alpha = 1;
	
	//fade up
	step_time = 0.05;
	
	if ( fadein > 0 )
	{
		current_alpha = 0;
		increment_alpha = max_alpha / (fadein/step_time); 
		AssertEx( increment_alpha > 0, "alpha not increasing; infinite loop" );
		while ( current_alpha < max_alpha )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha + increment_alpha;
			wait step_time;
	}
	}
	
	overlay.alpha = max_alpha;
	
	// time must be greater than sum of fadein and fadeout	
	wait(time - (fadein + fadeout));

	//fade down
	if ( fadeout > 0 )
	{
		current_alpha = max_alpha;
		decrement_alpha = max_alpha / (fadeout/step_time);
		AssertEx( decrement_alpha > 0, "alpha not decreasing; infinite loop" );
		while ( current_alpha > 0 )
		{
			overlay.alpha = current_alpha;
			current_alpha = current_alpha - decrement_alpha;
			wait step_time;
		}
	}
	
	overlay.alpha = 0;
	overlay destroy();
}


///////////////////////// 		END LIGHTING WARBIRD 		///////////////////////// 
///////////////////////// 		START LIGHTING STREET      	///////////////////////// 


exposure_adjust_courtyard_room()
{
	//Adjusting courtyard room exposure settings
    tonemapkey_call = GetEntArray( "exposure_adjust_courtyard_room_volume", "targetname" );
    foreach ( tonemapkeycall in tonemapkey_call )
    {
        tonemapkeycall thread exposure_adjust_courtyard_room_volume();
    }
}

exposure_adjust_courtyard_room_volume()
{
	while ( true )
    {
        self waittill( "trigger" );
        if ( IsUsingHDR() )
        	lerp_savedDvar("r_tonemapkey", .13, 0.05 );
	
		while ( level.player IsTouching( self ))
        {
            wait 0.1;
        }
		if ( IsUsingHDR() )
        	lerp_savedDvar("r_tonemapkey", 0.25, 0.35 );
	}
}

///////////////////////// 		END LIGHTING STREET      		///////////////////////// 
///////////////////////// 		START LIGHTING INTERIOR      	///////////////////////// 

//lighting for security start
setup_lighting_security_start()
{
	flag_wait( "security_room_player_start" );
	wait 0.1;
	setsaveddvar("r_disablelightsets", 0 );
	level.player lightsetforplayer("fusion_security_lightset");
	vision_set_fog_changes( "fusion_security", .05 );
}

//dof setup for security area
setup_dof_security()
{
    tonemapkey_call = GetEntArray( "security_area_volume", "targetname" );
    foreach ( tonemapkeycall in tonemapkey_call )
    {
        tonemapkeycall thread setup_dof_security_volume();
    }
}

setup_dof_security_volume()
{
    while ( true )
    {
        self waittill( "trigger" );
        blend_dof_presets( "default", "fusion_security", 2.0);
        fusion_interior_elevator_door_light = GetEntArray( "fusion_interior_elevator_light", "script_noteworthy" );
		foreach (light in fusion_interior_elevator_door_light)
			{
			light SetLightIntensity(150000.0);
    		}
                
        while ( level.player IsTouching( self ))
        {
            wait 0.1;
        }
       
        blend_dof_presets( "fusion_security", "default", 2.0);
        fusion_interior_elevator_door_light = GetEntArray( "fusion_interior_elevator_light", "script_noteworthy" );
		foreach (light in fusion_interior_elevator_door_light)
			{
			light SetLightIntensity(150000.0);
    		}
    }
}

//dof adjustments for elevator fall
elevator_fall_dof_tweaks()
{
	flag_wait( "elevator_descent_player" );
	blend_dof_presets( "default", "fusion_elevator_fall", 3.0);
	wait 2.5;
	blend_dof_presets( "fusion_elevator_fall", "default", 3.0);
}

//lighting for lab start
setup_lighting_lab_start()
{
	flag_wait( "lab_player_start" );
	wait 0.5;
	setsaveddvar("r_disablelightsets", 0 );
	level.player lightsetforplayer("fusion_lab_lightset");
	vision_set_fog_changes( "fusion_lab", .05 );	
}

//setup primary spot priority and DOF for lab area
setup_lab_script_volume()
{
    tonemapkey_calla = GetEntArray( "lab_lighting_script_volume", "targetname" );
    foreach ( tonemapkeycalla in tonemapkey_calla )
    {
        tonemapkeycalla thread lab_script_volume();
    }
}

lab_script_volume()
{
    while ( true )
    {
        self waittill( "trigger" );
        
		setSavedDvar("Sm_spotlightscoreradiuspower", 0.8);        
        blend_dof_presets( "default", "fusion_interior", 1.0);
                       
        while ( level.player IsTouching( self ))
        {
            wait 0.1;
        }
        
        setSavedDvar("Sm_spotlightscoreradiuspower", 0.6); 
        blend_dof_presets( "fusion_interior", "default", 5.0);
       
    }
}

///////////////////////////////      REACTOR START     //////////////////////////////////////////////
//lighting for reactor start
setup_lighting_reactor_start()
{
	flag_wait( "reactor_player_start" );
	wait 0.1;
	setsaveddvar("r_disablelightsets", 0 );
	level.player lightsetforplayer("fusion_locker_room_lightset"); 
	vision_set_fog_changes( "fusion_locker_room", .05 );	
}

//lighting setup for scriptable primary light that shoots in as reactor door opens
lighting_setup_reactor_door()
{
    tonemapkey_call = GetEntArray( "reactor_door_volume", "targetname" );
    foreach ( tonemapkeycall in tonemapkey_call )
    {
        tonemapkeycall thread lighting_setup_reactor_door_volume();
    }
}

lighting_setup_reactor_door_volume()
{
	while ( true )
    {
        self waittill( "trigger" );
        fusion_light_reactor_door = GetEntArray( "fusion_light_reactor_door", "script_noteworthy" );
		foreach (light in fusion_light_reactor_door)
			{
			light SetLightIntensity(45000.0);
			}
		setsaveddvar("sm_spotlightscoremodelscale", 1);
   	}
}

//lighting setup for reactor reveal moment
reactor_reveal_lighting()
{
	flag_wait( "reactor_room_reveal_scene" );
	wait(8.0);	
	level.player lightsetforplayer("fusion_reactor_door_lightset");
	blend_dof_presets( "default", "fusion_reactor_reveal", 3.0);
	wait 8;
	level.player lightsetforplayer("fusion_reactor_lightset");
	vision_set_fog_changes( "fusion_reactor", 8 );
	blend_dof_presets( "fusion_reactor_reveal", "default", 10.0);
}

/////////////////////////       END REACTOR        //////////////////////////////////////////////

//reactor exit start
setup_lighting_reactor_exit_start()
{
	flag_wait( "reactor_exit_player_start" );
	wait 0.5;
	setsaveddvar("r_disablelightsets", 0 );
	level.player lightsetforplayer("fusion_pre_elevator_lightset");
	vision_set_fog_changes( "fusion_loading_area", .5 );
}

//setting up volume for scripted light and FX for elevator shaft prior to turbine...shuts off as elevator ascends
lighting_setup_turbine_elevator()
{
    tonemapkey_call = GetEntArray( "turbine_elevator_volume", "targetname" );
    foreach ( tonemapkeycall in tonemapkey_call )
    	{
        tonemapkeycall thread lighting_setup_turbine_elevator_volume();
   		}
}

lighting_setup_turbine_elevator_volume()
{
	while ( true )
    {
        self waittill( "trigger" );
        //setting primary light inside elevator intensity
        fusion_turbine_elevator_light = GetEntArray( "fusion_interior_turbine_elevator_light", "script_noteworthy" );
		foreach (light in fusion_turbine_elevator_light)
			{
			light SetLightIntensity(50000.0);
			}
		
		elevator_control = getent( "elevator_control", "targetname" );
	
		//scripted fx that get animated up with the elevator
		thread scripted_fx_on_struct( "turbine_room_elevator_monitor_02_fx", "fus_light_elevator_monitor", elevator_control );
		thread scripted_fx_on_struct( "turbine_room_elevator_monitor_01_fx", "fus_light_elevator_monitor", elevator_control );
	
		//scripted fx that get turned off when the elevator ascention starts
		//thread scripted_fx_on_struct( "turbine_room_elevator_test_fx_scripted", "link_light", elevator_control, "elevator_ascend" );
		//thread scripted_fx_on_struct( "turbine_room_elevator_monitor_01_fx", "fus_light_elevator_monitor", elevator_control, "turbine_room_combat_start" );
	
		flag_wait( "elevator_ascend" );
		if(level.nextgen == true)
		{
			lerp_savedDvar("r_specularColorScale", 0.35, 1.0 );
		}
		else
		{
			lerp_savedDvar("r_specularColorScale", 1.05, 1.0 );
		}
	
		//turning off primary light
		foreach (light in fusion_turbine_elevator_light)
			{
			light SetLightIntensity(0.0);
			}
	
		//darkening tonemap settings
		level.player lightsetforplayer("fusion_elevator_dark_lightset");
	
		//flashing orange emergency lights
		exploder ( 3466 );
		flag_wait( "turbine_room_combat_start" );
		//turning off orange light when elevator stops at top
		kill_exploder ( 3466 );
		wait 5.0;
		//turning on flashing white lights near door in turbine room after door opens
		exploder ( 3588 );
		//tuning spec back to normal
		if(level.nextgen == true)
		{
			lerp_savedDvar("r_specularColorScale", 1.0, 3.0 );
		}
		else
		{
			lerp_savedDvar("r_specularColorScale", 3.0, 3.0 );
		}
		//killing scripted fx lights once player moves into control room
		flag_wait ( "update_obj_pos_control_room_door" );
		kill_exploder ( 3588 );
   	}
}

//turbine start
setup_lighting_turbine_start()
{
	flag_wait( "turbine_room_player_start" );
	wait 0.5;
	setsaveddvar("r_disablelightsets", 0 );
	level.player lightsetforplayer("fusion_elevator_to_turbine_lightset");
	vision_set_fog_changes( "fusion_turbines_reveal", 3 );	
}

//first control room ENTRANCE start
setup_lighting_control_room_start()
{
	flag_wait( "control_room_entrance_player_start" );
	wait 1.0;
	setsaveddvar("r_disablelightsets", 0 );
	vision_set_fog_changes( "fusion_offices", .5 );	
	level.player lightsetforplayer("fusion_default_interior_lightset");
}

//setup scriptable light for script brush doors at control room start
setup_control_room_door_explosion_light()
{
	flag_wait ( "control_room_explosion" );
	control_room_door_explosion = GetEntArray( "control_room_door_explosion_light", "script_noteworthy" );
	foreach (light in control_room_door_explosion)
			{
			light SetLightIntensity(40000.0);
    		}
}

//flickering light for control room screens
setup_control_room_screen_light()
{
	self endon( "death" );
	
	flag_wait ( "control_room_explosion" );
	play_flickerLight_preset("static_screen", "control_room_static_screen", 300000);
 	//flag_wait ( "control_room_explosion" );
    //stop_flickerLight("fire", "fire_outside", 0); 
}

//setting up DOF settings for when player uses control panel
setup_control_room_scene_DOF()
{
	flag_wait( "control_room_console_used" );
	blend_dof_presets( "default", "fusion_ctrl_room_scene", 1.0);
	flag_wait( "flag_shut_down_reactor_failed" );
	blend_dof_presets( "fusion_ctrl_room_scene", "default", 1.0);
}

///////////////////////// 		END LIGHTING INTERIOR      	            ///////////////////////// 
///////////////////////// 		LIGHTING CONTROL ROOM THROUGH FINALE 	///////////////////////// 

//setting up lighting upon player start...artificially darkening the scene a bit for mood purposes
sun_shad_exposure_control_room()
{
	flag_wait( "start_control_room_exit_lighting" );
  	setsaveddvar("sm_sunsamplesizenear", .1 );
	if(level.nextgen == true)
	{
		setsaveddvar("r_specularColorScale", 1.75 );
	}
	else
	{
		setsaveddvar("r_specularColorScale", 5.25 );
	}
	SetSunLight(32, 24, 16);
	level.player lightsetforplayer("fusion_control_room_exit_lightset");
	vision_set_fog_changes( "fusion_control_room", .5 );
	thread setup_fusion_finale_light_flicker();
}

//setup triggers to change spec intensity and DOF upon control room exit
tonemapkey_call_control_room()
{
    tonemapkey_calla = GetEntArray( "tonemapkey_control_room_volume", "targetname" );
    foreach ( tonemapkeycalla in tonemapkey_calla )
    {
        tonemapkeycalla thread tonemapkey_control_room_volume();
    }
}

tonemapkey_control_room_volume()
{
    while ( true )
    {
        self waittill( "trigger" );
        if(level.nextgen == true)
        {
        	lerp_savedDvar("r_specularColorScale", 1.75, 1.0 );
        }
        else
        {
        	lerp_savedDvar("r_specularColorScale", 5.25, 1.0 );
        }
        blend_dof_presets( "default", "fusion_control_room", 0.05);
                
        while ( level.player IsTouching( self ))
        {
            wait 0.1;
        }
        if(level.nextgen == true)
        {
        	lerp_savedDvar("r_specularColorScale", 1.5, 1.0 );
        }
        else
        {
        	lerp_savedDvar("r_specularColorScale", 4.5, 1.0 );
        }
        blend_dof_presets( "fusion_control_room", "default", 5.0);
    }
}

//setup triggers to change spec and sun intensity upon hangar exit
tonemapkey_call()
{
    tonemapkey_call = GetEntArray( "tonemapkey_cooling_towers_volume", "targetname" );
    foreach ( tonemapkeycall in tonemapkey_call )
    {
        tonemapkeycall thread tonemapkey_cooling_towers_volume();
    }
}

tonemapkey_cooling_towers_volume()
{
    while ( true )
    {
        self waittill( "trigger" );
        if(level.nextgen == true)
        {
        	lerp_savedDvar("r_specularColorScale", 1.0, 1.0 );
        }
        else
        {
        	lerp_savedDvar("r_specularColorScale", 3.0, 1.0 );
        }
        sun_light_fade((32, 24, 16), (20.1, 18.81, 15.51), 3);
       
        while ( level.player IsTouching( self ))
        {
            wait 0.1;
        }
        if(level.nextgen == true)
        {
        	lerp_savedDvar("r_specularColorScale", 1.5, 1.0 );
        }
        else
        {
        	lerp_savedDvar("r_specularColorScale", 4.5, 1.0 );
        }
        sun_light_fade((20.1, 18.81, 15.51), (32, 24, 16), 3);
    }
}

//need to check the following flag_wait to see if it's actually still used...I may have added this, but it's not used anymore...
//flag_wait( "hangar_exit_explosion" );

//setting sun shadow distance for cooling towers area
sun_shad_cooling_tower_area()
{
	flag_wait( "reaction_explo01" );
	wait 1.25;
	level.player lightsetforplayer("fusion_cooling_towers_post_lightset");
}

//setting lighting settings for player start at cooling towers
sun_shad_cooling_tower_start()
{
	flag_wait( "player_start_cooling_tower" );
	if(level.currentgen ==  false)
	{
		level.player lightsetforplayer("fusion_cooling_towers_start_lightset");
	}
	else
	{
		setsaveddvar("sm_sunsamplesizenear", .38 );
	}
	thread setup_fusion_finale_light_secondary_rim();
	thread setup_fusion_finale_light_flicker();
}

//lighting, fog and DOF setup for finale 
setup_fusion_finale_arm_rimlight()
{
	flag_wait( "collapse_start" );
	level.player lightsetforplayer("fusion_cooling_towers_collapse_lightset");
	setsaveddvar("sm_spotlightscoremodelscale", 1);
	vision_set_fog_changes( "fusion_cooling_towers_collapse", 5.0 );
	
	flag_wait( "tower_knockback");
	//disabling lightsets to allow for veil tweak
	setsaveddvar( "r_disablelightsets", 1 );
	if ( IsUsingHDR() )
	{
		lerp_savedDvar("r_veilstrength", 0.0, 1.0 );
		setsaveddvar( "r_veil", 0 );
	}
	
	//DOF blur during first knockback
	blend_dof_presets( "default", "fusion_finale_collapse", 1);
	wait(2.0);
	blend_dof_presets( "fusion_finale_collapse", "default", 1);
	wait(12.0);
	vision_set_fog_changes( "fusion_cooling_towers_collapse_after", 5.0 );
	
	//setsaveddvar( "sm_sunenable", 0 );
	//DOF blur during knockdown
	blend_dof_presets( "default", "fusion_finale_collapse", 1);
	wait(5.0);
	blend_dof_presets( "fusion_finale_collapse", "fusion_finale_arm", 1);
	
	//DOF blending during rescue sequence
	wait(16.5);
	blend_dof_presets( "fusion_finale_arm", "fusion_finale_closeup", .25);
	if ( IsUsingHDR() )
	{
		setsaveddvar( "r_veil", 1 );
		lerp_savedDvar("r_veilstrength", 0.25, 3.0 );
	}
	wait(1);
	blend_dof_presets( "fusion_finale_closeup", "fusion_finale_arm", .25);
	wait(1);
	blend_dof_presets( "fusion_finale_arm", "fusion_finale_closeup", .25);
	wait(14);
	if ( IsUsingHDR() )
	{
		lerp_savedDvar("r_veilstrength", 0.0, 1.0 );
		setsaveddvar( "r_veil", 0 );
	}
	blend_dof_presets( "fusion_finale_closeup", "fusion_finale_arm", .25);
}

//rim and fill fx lights for finale arm scene
setup_fusion_finale_arm_fx()
{
	flag_wait( "tower_knockback");
	wait(34.0);
	exploder ( 6036 );
	wait(23);
	kill_exploder ( 6036 );
}

firelight_volume()
{
	play_flickerLight_preset("fire", "fire_flicker");
}

firelight_volume2()
{
	play_flickerLight_preset("fire", "fire_flicker");
}

hide_fusion_street_lights_off()
{
	self endon( "death" );
		
	flag_wait( "evacuation_started" );
	
    fusion_light_flicker_off = GetEntArray( "fusion_light_flicker_off", "script_noteworthy" );
    fusion_light_flicker_off1 = GetEntArray( "fusion_light_flicker_off1", "script_noteworthy" );
    fusion_light_flicker_off2 = GetEntArray( "fusion_light_flicker_off2", "script_noteworthy" );    
    
    fusion_light_flicker_off Hide();
    fusion_light_flicker_off1 Hide();
    fusion_light_flicker_off2 Hide();
}

//setup for main finale area key light to flicker "off" when explosion occurs and tower collapse begins...
setup_fusion_finale_light_flicker()
{
	self endon( "death" );
			
	fusion_light_flicker = GetEntArray( "fusion_finale_light_flicker", "script_noteworthy" );
	foreach (light in fusion_light_flicker)
			{
			light SetLightIntensity(200000.0);
			}
	
	flag_wait ( "collapse_start" );
	
    number_of_flickers = 5;
    flicker_count = 0;
    time_between_flicker = RandomFloatRange( .05, .1 );
        
    while (flicker_count < number_of_flickers)
    {
    	exploder(6026);
    	foreach (light in fusion_light_flicker)
			{
    		light SetLightIntensity(200000.0);
 	 		}		
		wait time_between_flicker;
		foreach (light in fusion_light_flicker)
			{
 	 		light SetLightIntensity(0.5);
			}
		flicker_count++;
		wait time_between_flicker;
    }
    kill_exploder(6026);
}

setup_fusion_finale_lightgrid()
{
	flag_wait ( "tower_knockback" );
	wait(30);
	SetSavedDvar("r_lightgridenabletweaks", "1");
	if(level.nextgen == true)
	{
		lerp_savedDvar("r_lightgridintensity", 0.15, 4);
	}
	else
	{
		lerp_savedDvar("r_lightgridintensity", 0.15*7, 4);
	}
}

//fov setup and animation for finale key light on burke
setup_fusion_finale_light_rim_fov()
{
	flag_wait ( "tower_knockback" );
	
	fusion_light_rim_fov = GetEntArray( "fusion_finale_light_rim", "script_noteworthy" );
	foreach (light in fusion_light_rim_fov)
			{
			light SetLightFovRange (45,25);
			wait(36);
			light SetLightFovRange (30,20);
			wait(18);
    		light SetLightFovRange (65,55);
    		}
}

//main character key light for finale arm scene
setup_fusion_finale_light_rim()
{
	self endon( "death" );
	
	thread setup_fusion_finale_light_rim_fov();
	flag_wait ( "tower_knockback" );
	
	fusion_light_rim = GetEntArray( "fusion_finale_light_rim", "script_noteworthy" );
	foreach (light in fusion_light_rim)
			{
    		wait(18);
    		light SetLightIntensity(300000.0);
    		}
	
	number_of_flickers = 999;
    flicker_count = 0;
    time_between_flicker = RandomFloatRange( 0.05, 1.5 );
        
	 while (flicker_count < number_of_flickers)
    {
    	foreach (light in fusion_light_rim)
			{
    		light thread maps\_lights::changeLightColorTo( ( 30.1, 28.81, 25.51 ), .5, .05, .35 );
 	 		}		
		wait time_between_flicker;
		foreach (light in fusion_light_rim)
			{
			light thread maps\_lights::changeLightColorTo( ( 0.5, 0.5, 0.5 ), 0.65, .45, .05 );
			}
		wait time_between_flicker;
		foreach (light in fusion_light_rim)
			{
    		light thread maps\_lights::changeLightColorTo( ( 0.75, 0.75, 0.75 ), .5, .05, .35 );
 	 		}		
		flicker_count++;
		wait time_between_flicker;
			}
}

//burke's key light as he stumbles into frame
setup_fusion_finale_light_secondary_rim()
{
	
	fusion_light_secondary_rim = GetEntArray( "fusion_finale_light_secondary_rim", "script_noteworthy" );
	foreach (light in fusion_light_secondary_rim)
			{
			light SetLightIntensity(0.0);
    		}
	
	flag_wait ( "tower_knockback" );
	
	foreach (light in fusion_light_secondary_rim)
			{
			light SetLightIntensity(0.0);
    		wait(17);
    		light SetLightIntensity(100000.0);
    		wait(17);
    		light thread maps\_lights::changeLightColorTo( ( 0.0, 0.0, 0.0 ), 5, .005, .15 );
			}
}

////////////// FLICKERING LIGHTS PRIOR TO COLLAPSE ///////////////
setup_fusion_light_model_flicker()
{
	self endon( "death" );
	level endon( "collapse_animation_started" );
	flag_wait( "evacuation_started" );
    
	fusion_light_flicker_off = GetEntArray( "fusion_light_flicker_off", "script_noteworthy" );
      	foreach (light in fusion_light_flicker_off)
		{
 			light Hide();
 		}	
	
	exploder(1666);
	exploder(1668);
	exploder(1669);
	
	flag_wait ( "collapse_start" );
	//thread blend_dof_viewmodel_presets( "default", "viewmodel_blur", 1);

    fusion_light_flicker = GetEntArray( "fusion_light_flicker_on", "script_noteworthy" );

    
    number_of_flickers = 3;
    flicker_count = 0;
    time_between_flicker = RandomFloatRange( .1, .25 );
    exploder(1667);
    
    while (flicker_count < number_of_flickers)
    {
    	exploder(1666);
 	  	foreach (light in fusion_light_flicker)
			{
 	 			light Show();
 	 		}	
 	  	foreach (lightoff in fusion_light_flicker_off)
			{
 	 			lightoff Hide();
 	 		}	 	  	
		wait time_between_flicker;
		stop_exploder(1666);
		foreach (light in fusion_light_flicker)
			{
 	 			light Hide();
 	 		}
		foreach (lightoff in fusion_light_flicker_off)
			{
 	 			lightoff Show();
 	 		}	
		flicker_count++;
		wait time_between_flicker;
    }
}
setup_fusion_light_model_flicker2()
{
	self endon( "death" );
	level endon( "collapse_animation_started" );
	flag_wait( "evacuation_started" );
	
	fusion_light_flicker_off2 = GetEntArray( "fusion_light_flicker_off2", "script_noteworthy" );
    foreach (light in fusion_light_flicker_off2)
	{
 		light Hide();
 	}	
	
	flag_wait ( "collapse_start" );

    fusion_light_flicker = GetEntArray( "fusion_light_flicker_on2", "script_noteworthy" );

    
    number_of_flickers = 5;
    flicker_count = 0;
    time_between_flicker = RandomFloatRange( .1, .25 );
    exploder(1667);
    
    while (flicker_count < number_of_flickers)
    {
    	exploder(1668);
 	  	foreach (light in fusion_light_flicker)
			{
 	 			light Show();
			}
 	  	foreach (lightoff in fusion_light_flicker_off2)
			{
 	 			lightoff Hide();
 	 		}	 	  	
		wait time_between_flicker;
		stop_exploder(1668);
		foreach (light in fusion_light_flicker)
			{
 	 			light Hide();
			}
 	  	foreach (lightoff in fusion_light_flicker_off2)
			{
 	 			lightoff Show();
 	 		}		
		flicker_count++;
		wait time_between_flicker;
    }
}
setup_fusion_light_model_flicker3()
{
	self endon( "death" );
	level endon( "collapse_animation_started" );
	flag_wait( "evacuation_started" );
	
	fusion_light_flicker_off3 = GetEntArray( "fusion_light_flicker_off3", "script_noteworthy" );
    foreach (light in fusion_light_flicker_off3)
		{
 			light Hide();
 		}	
	
	flag_wait ( "collapse_start" );

    fusion_light_flicker = GetEntArray( "fusion_light_flicker_on3", "script_noteworthy" );

    
    number_of_flickers = 4;
    flicker_count = 0;
    time_between_flicker = RandomFloatRange( .1, .25 );
    exploder(1667);
    
    while (flicker_count < number_of_flickers)
    {
    	exploder(1669);
 	  	foreach (light in fusion_light_flicker)
			{
 	 			light Show();
			}
 	  	foreach (lightoff in fusion_light_flicker_off3)
			{
 	 			lightoff Hide();
 	 		}	 	  	
		wait time_between_flicker;
		stop_exploder(1669);
		foreach (light in fusion_light_flicker)
			{
 	 			light Hide();
			}
 	  	foreach (lightoff in fusion_light_flicker_off3)
			{
 	 			lightoff Show();
 	 		}	
		flicker_count++;
		wait time_between_flicker;
    }
}

scripted_fx_on_struct( targetname, fx_name, linkto_ent, killflag )
{
	struct = getstruct( targetname, "targetname" );
	
	if( !IsDefined( killflag ) && !IsDefined( linkto_ent ) )
	{
		if( IsDefined( struct.angles ) )
			PlayFX( getfx( fx_name ), struct.origin, AnglesToForward( struct.angles ), AnglesToUp( struct.angles ) );
		else
			PlayFX( getfx( fx_name ), struct.origin );
	}
	else
	{
		org = spawn_tag_origin();
		org.origin = struct.origin;
		if( IsDefined( struct.angles ) )
			org.angles = struct.angles;
		if( IsDefined( linkto_ent ) )
			org linkto( linkto_ent );
		
		playfxontag( getfx( fx_name ), org, "tag_origin" );
		
		if( IsDefined( killflag ) )
		{
			flag_wait( killflag );
			stopfxontag( getfx( fx_name ), org, "tag_origin" );
			org delete();
		}
	}
}

debug_show_org()
{
	self endon("death");
	while(true)
	{
		Print3d(self.origin, "org");
		waitframe();
	}
}
