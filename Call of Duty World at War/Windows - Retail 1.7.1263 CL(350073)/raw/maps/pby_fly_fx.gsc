#include common_scripts\utility;

main()
{
	precacheFX();
	spawnFX();	
	thread wind_settings();
	thread water_settings();
	thread vision_settings();
	thread fog_for_merchantship();
	thread lightning_flash("merchantship");
	thread lightning_flash("rescue");
	thread scripted_lightning_flash("player_pressed_ads", "ads timed out", 0.25);
	thread scripted_lightning_flash("zero lightning go", "booooooyah", 0.25);
	//thread spawn_cloud_effects();
}

// Fog settings are set up as follows:
// setVolFog(StartDistance, Halfplane, HalfwayHeight, BaseZHeight, ColorRed, ColorGreen, ColorBlue, TransitionTime)

fog_for_merchantship()
{
	setdvar( "scr_fog_disable", "1" );
//	setVolFog(45000, 39500, 5600, 27000, 0.17, 0.17, 0.175, 0);
}

fog_for_rescue()
{
	setdvar( "scr_fog_disable", "1" );
//setVolFog( 670, 1087, 393, 30.78, 0.0813385, 0.104133, 0.108311, 20);
}

fog_for_ending()
{
	setdvar( "scr_fog_disable", "0" );
	setVolFog(3500, 11000, 2000, 0, 0.423, 0.45, 0.46, 5);
}

vision_settings()
{
	wait(1);
	
	//VisionSetNaked("fly_dark", 0);
	//VisionSetNaked("fly_light", 20);
	level thread vision_settings_dark_night();
	level thread vision_settings_light_night();
	level thread vision_settings_daylight();
	level thread vision_settings_daylight_instant();
}

vision_settings_dark_night()
{
	//-- new daylight sun values
	nighttime_red 	= 0.858824;
	nighttime_green = 0.886275;
	nighttime_blue 	= 0.886275;
	
	VisionSetNaked("fly_dark", 0);
	level.orgsundirection = GetMapSunDirection();
	//-- new sunlight direction values
	newsundirection = (235, -15, 0);
	LerpSunDirection(level.orgsundirection, newsundirection, 1);
	setSunLight(nighttime_red, nighttime_green, nighttime_blue);
//setSavedDvar("r_lightTweakSunlight", 0.65);

	SetSavedDvar("r_skyTransition", 0);
}

vision_settings_light_night()
{
	level waittill("light_night");
	VisionSetNaked("fly_mid", 60);
	
	//sun settings
	level.orgsuncolor = GetMapSunLight();
	level.orgsundirection = GetMapSunDirection();
	
	//-- new daylight sun values
	daylight_red = 0.97;
	daylight_green = 0.98;
	daylight_blue = 0.92;
	number_of_slices = 600;
	
	r_fraction = (daylight_red - level.orgsuncolor[0]) / number_of_slices;
	g_fraction = (daylight_green - level.orgsuncolor[0]) / number_of_slices;
	b_fraction = (daylight_blue - level.orgsuncolor[0]) / number_of_slices;
	current_sun_color = level.orgsuncolor;
	
	//-- new sunlight direction values
	newsundirection = (215, -35, 0);
	LerpSunDirection(level.orgsundirection, newsundirection, 60);
	
	number = 0;
	while(number < number_of_slices)
	{
		current_sun_color[0] = current_sun_color[0] + r_fraction;
		current_sun_color[1] = current_sun_color[1] + g_fraction;
		current_sun_color[2] = current_sun_color[2] + b_fraction;
		
		setSunLight(current_sun_color[0], current_sun_color[1], current_sun_color[2]);
		number++;
		wait(0.1); //-- this will make it a 10 second transition of the skybox
	}
}

vision_settings_daylight() //-- changed to take a full minute 6/10/08
{
	level waittill("sun_rise");
	VisionSetNaked("fly_light", 60);
	
	//fog settings
	thread fog_for_ending();
	
	//sun settings
	level.orgsuncolor = GetMapSunLight();
	level.orgsundirection = GetMapSunDirection();
	
	//-- new daylight sun values
	daylight_red = 1;
	daylight_green = 0.97;
	daylight_blue = 0.85;
	number_of_slices = 600;
	
	r_fraction = (daylight_red - level.orgsuncolor[0]) / number_of_slices;
	g_fraction = (daylight_green - level.orgsuncolor[0]) / number_of_slices;
	b_fraction = (daylight_blue - level.orgsuncolor[0]) / number_of_slices;
	current_sun_color = level.orgsuncolor;
	
	//-- new sunlight direction values
	newsundirection = (200, -50, 0);
	LerpSunDirection(level.orgsundirection, newsundirection, 60);
	
	number = 0;
	while(number < number_of_slices)
	{
		SetSavedDvar("r_skyTransition", (number / number_of_slices));
		
		current_sun_color[0] = current_sun_color[0] + r_fraction;
		current_sun_color[1] = current_sun_color[1] + g_fraction;
		current_sun_color[2] = current_sun_color[2] + b_fraction;
		
		setSunLight(current_sun_color[0], current_sun_color[1], current_sun_color[2]);
		number++;
		wait(0.1); //-- this will make it a 10 second transition of the skybox
	}
}

vision_settings_daylight_instant()
{
	level waittill("instant_sun");
	VisionSetNaked("fly_light", 0);
	SetSavedDvar("r_skyTransition", 1);
}

// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "-74 400 0" ); // 406 inches per second or about 24mph with wind going NNW (if N is (0,1,0))
	SetSavedDvar( "wind_global_low_altitude", 0 );
	SetSavedDvar( "wind_global_hi_altitude", 2000 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 ); // brings ground level wind down to 12mph
}

// Load some basic FX to play around with.
precacheFX()
{
	//-- Fire Extinguiser FX
	level._effect["fire_extinguish"]	= loadfx("destructibles/fx_dmg_extinguisher");
	
	//-- Zero FX
	loadfx("trail/fx_trail_plane_smoke_damage");
	//loadfx("explosions/large_vehicle_explosion");
	
	//-- Cloud FX
	//level._effect["cloud_spline_layer"]    = loadfx("maps/fly/fx_cloud_spline_layer");
	//-- only using these two right now
	level._effect["ambient_clouds"] = loadfx("maps/fly/fx_pby_clouds"); // the clouds parented to the PBY
	//level._effect["cloud_layer_start"] = loadfx("maps/fly/fx_cloud_layer_start");  // This is declared below
	level._effect["cloud_zero"] = loadfx("maps/fly/fx_cloud_plane_spawner");
	
	//-- BULLET HOLES
	level._effect["spark"]			 = loadfx("maps/fly/fx_impact_pby_int_metal");
	level._effect["godray_night"]			 = loadfx("maps/fly/fx_bullethole_godray_night");
	level._effect["bighole_night"]		 = loadfx("maps/fly/fx_tailhole_godray_night");
	
	//-- Oil and flameup FX
	level._effect["oil_small"] 	= loadfx("maps/fly/fx_fire_oil_md_short");
	level._effect["oil_medium"] = loadfx("env/fire/fx_fire_oil_md");
	level._effect["oil_large"] 	= loadfx("env/fire/fx_fire_oil_lg");
	
	//level._effect["oil_spill_medium"] = loadfx("env/water/fx_water_oil_spill_md");
	level._effect["oil_spill_large"] 	= loadfx("env/water/fx_water_oil_spill_lg");
	
	level._effect["oil_medium_burn"] 	= loadfx("maps/fly/fx_fire_oil_water_flareup_md");
	level._effect["oil_large_burn"] 	= loadfx("maps/fly/fx_fire_oil_water_flareup_lg");
	
	//-- SHIP EXPLOSION FX
	level._effect["post_kami"]			= loadfx("maps/fly/fx_exp_deck_postkamikaze");
	
	//-- MERCHANT BOAT FX
	level._effect["cargo_1"] 				= loadfx("maps/fly/fx_dmg_merch_cargo1"); //1st stage
	level._effect["cargo_2"] 				= loadfx("maps/fly/fx_dmg_merch_cargo2"); //2nd stage
	level._effect["cargo_3"] 				= loadfx("maps/fly/fx_dmg_merch_cargo3"); //3rd stage (don't use with 4th)
	level._effect["cargo_4"] 				= loadfx("maps/fly/fx_dmg_merch_cargo4"); //4th stage (don't use with 3rd)
	level._effect["merchant_light"] = loadfx("env/light/fx_ray_spotlight_lg_dlight");
	level._effect["ship_wake"]			= loadfx("maps/fly/fx_wake_merch");
	level._effect["merchant_final"] = loadfx("maps/fly/fx_exp_merchantship_final");
	level._effect["merchant_sink"]	= loadfx("maps/fly/fx_sinking_merchantship");
	level._effect["merchant_sink_brkup"]	= loadfx("maps/fly/fx_sinking_merchantship_brkup");
	level._effect["merchant_sink_fire"]	= loadfx("maps/fly/fx_sinking_merchantship_brkup_fire");
	level._effect["merchant_sink_fire_2"] = loadfx("maps/fly/fx_sinking_merchantship_brkup_fire02");
	level._effect["debris_fire"]		= loadfx("env/fire/fx_fire_oil_sm");
	level._effect["sink_break"] 		= loadfx("maps/fly/fx_dest_merchantship_brk_full");
	
	
	//-- ZERO FX
	level._effect["zero_wing_dmg1"] = loadfx("maps/fly/fx_dmg_zero_wing1");
	level._effect["zero_wing_dmg2"] = loadfx("maps/fly/fx_dmg_zero_wing2");
	level._effect["zero_wing_dmg3"] = loadfx("maps/fly/fx_dmg_zero_wing3");
	level._effect["zero_kamikaze"]	= loadfx("maps/fly/fx_exp_kamikaze");
	level._effect["zero_water"]			= loadfx("maps/fly/fx_splash_zero_crash");
	level._effect["zero_kamikaze_water"] = loadfx("maps/fly/fx_splash_kamikaze_crash");
	level._effect["zero_post_kamikaze"]   = loadfx("maps/fly/fx_fire_water_postkamikaze");
	level._effect["zero_tail_light"]	= loadfx("env/light/fx_light_zero_exterior_tail");
	level._effect["zero_final_explode"] = loadfx("maps/fly/fx_exp_zero_final");
	level._effect["zero_explode"]		= loadfx("maps/fly/fx_exp_zero_fuel2");
	level._effect["zero_part_splash"] = loadfx("maps/fly/fx_splash_zero_crash_bits");
	level._effect["zero_part_splash_small"] = loadfx("impacts/fx_water_hit_md");
	
	//-- PTBOAT FX
	level._effect["pt_churn"]				= loadfx("maps/fly/fx_churn_ptboat");
	level._effect["pt_wake"]				= loadfx("maps/fly/fx_wake_ptboat");
	level._effect["pt_sink"]     		= loadfx("maps/fly/fx_sinking_ptboat");
	level._effect["pt_damage1"]			= loadfx("maps/fly/fx_exp_ptboat_main1");
	level._effect["pt_damage2"]			= loadfx("maps/fly/fx_exp_ptboat_main2");
	level._effect["pt_damage3"]			= loadfx("maps/fly/fx_exp_ptboat_main3");
	level._effect["pt_damage4"]			= loadfx("maps/fly/fx_exp_ptboat_main4");
	level._effect["pt_torpedo"]			= loadfx("maps/fly/fx_exp_ptboat_torp");
	level._effect["pt_light"]				= loadfx("env/light/fx_ray_spotlight_md_dlight");
	//level._effect["pt_star"] 				= loadfx("env/light/fx_glow_boat_green");
	//level._effect["pt_port"] 				= loadfx("env/light/fx_glow_boat_red");
	level._effect["pt_running_lights"] = loadfx("env/light/fx_light_ptboat_jap_rdgrn");
	
	//-- SHINYOU FX
	//level._effect["shinyou_water_flareup"] = loadfx("maps/fly/fx_fire_oil_water_flareup");
	//level._effect["shinyou_wake"]					 = loadfx("maps/fly/fx_wake_shinyou");
	//level._effect["shinyou_splash"]				 = loadfx("maps/fly/fx_splash_pby_shinyou");
	
	//-- PROP FX
	level._effect["corsair_prop_full"]			= loadfx("vehicle/props/fx_corsair_prop_spin");
	level._effect["zero_prop_full"]					= loadfx("vehicle/props/fx_zero_prop_spin");
	
	//-- PBY FX
	level._effect["splash_land_center"] 		= loadfx("maps/fly/fx_splash_pby_land_ctr");
	level._effect["splash_land_wing"]				= loadfx("maps/fly/fx_splash_pby_land_wng");
	level._effect["splash_takeoff_center"] 	= loadfx("maps/fly/fx_splash_pby_takeoff_ctr");
	level._effect["splash_takeoff_wing"]	 	= loadfx("maps/fly/fx_splash_pby_takeoff_wng");
	level._effect["pby_wake_wing"]					= loadfx("maps/fly/fx_wake_pby_wng");
	//level._effect["pby_wake_center"]				= loadfx("maps/fly/fx_wake_pby_ctr");
	level._effect["pby_wake_center"]				= loadfx("maps/fly/fx_spray_pby_taxi_view");
	level._effect["pby_wake"]								= loadfx("maps/fly/fx_splash_pby_land_ctr");
	level._effect["pby_spray_wing"]					= loadfx("maps/fly/fx_spray_pby_taxi_wng");
	level._effect["pby_spray_center"]				= loadfx("maps/fly/fx_spray_pby_taxi_ctr");
	level._effect["pby_window"]						  = loadfx("maps/fly/fx_smk_pby_window_mist");
	level._effect["pby_clouds"]							= loadfx("maps/fly/fx_smk_pby_window_clouds");
	level._effect["pby_running_lights"] 		= loadfx("env/light/fx_light_pby_exterior");
	level._effect["prop_full"]							= loadfx("maps/fly/fx_pby_prop_full");
	level._effect["pby_flak"]		 						= loadfx("maps/fly/fx_exp_flak_pby_int");
	level._effect["pby_spot_light"]					= loadfx("env/light/fx_light_pby_exterior_dspot");
	level._effect["pby_blister_glass"]			= loadfx("maps/fly/fx_dest_merchantship_glass");
	level._effect["pby_dmg_eng1"] 					= loadfx("maps/fly/fx_dmg_pby_eng1");	
	level._effect["pby_dmg_eng2"] 					= loadfx("maps/fly/fx_dmg_pby_eng2");	
	level._effect["pby_dmg_eng3"] 					= loadfx("maps/fly/fx_dmg_pby_eng3");	
	level._effect["pby_wng_sprk"] 					= loadfx("maps/fly/fx_dmg_pby_wing_spark");
	level._effect["pby_explosion_ai"] 			= loadfx("maps/fly/fx_exp_pby_final_ai");
	level._effect["pby_20mm_flash"]					= loadfx("weapon/muzzleflashes/fx_20mm_cannon_world");
	
	//-- FLAK FX
	//level._effect["flak_field"]							= loadfx("weapon/flak/fx_flak_field_8k_dist");
	level._effect["flak_one_shot"]					= loadfx("weapon/flak/fx_flak_single_day_dlight");
	level._effect["flak_single_ambient"]    = loadfx("weapon/flack/fx_flack_single_day_dist");
	level._effect["aaa_tracer"] 						= loadfx("weapon/tracer/fx_tracer_jap_tripple25_projectile" );
	level._effect["fletcher_5in"]						= loadfx("weapon/artillery/fx_artillery_fletcher_5in");
	
	//-- LIGHTNING
	level._effect["script_bolt"]						= loadfx("maps/fly/fx_lightning_flash_single");
	level._effect["lightning_player"]				= loadfx("maps/fly/fx_lightning_flash_single_lg");
	
	//-- DRONE FX
	level._effect["drone_burst"]						= loadfx("impacts/fx_flesh_blood_geyser");
	level._effect["drone_burst_water"]			= loadfx("impacts/fx_flesh_blood_wtr_geyser");
	level._effect["character_fire_pain_sm"] 		= LoadFx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"] 		= LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] 	= LoadFx( "env/fire/fx_fire_player_torso" );
	
	//-- SWIMMING
	level._effect["swim_splash"] 						= loadfx("maps/fly/fx_splash_swimstroke");
	
	//FX by FX Dept.-----------------------------------------------------------------//
	level._effect["cloud_layer"] = loadfx("maps/fly/fx_cloud_layer"); 							// the actual cloud layer placed along the flight path
	
	level._effect["cloud_layer_os"]       = loadfx("maps/fly/fx_cloud_layer_os");
	level._effect["cloud_layer_fill_os"]  = loadfx("maps/fly/fx_cloud_layer_fill_os");
	level._effect["cloud_layer_dist"]     = loadfx("maps/fly/fx_cloud_plane"); 
	level._effect["cloud_layer_start"]    = loadfx("maps/fly/fx_cloud_layer_start");  	
	level._effect["3dclouds_20k_runner"]  = loadfx("env/weather/fx_cloud3d_cmls_20k_runner");	
	level._effect["3dclouds_50k_runner"]  = loadfx("env/weather/fx_cloud3d_cmls_50k_runner");
  level._effect["3dclouds_cmls_lg4"]    = loadfx("env/weather/fx_cloud3d_cmls_lg4"); 	
  
  level._effect["sinking_lci_md"] = 	  loadfx("maps/fly/fx_sinking_lci_md"); //frothing water around sinking lci
	//level._effect["light_fire_oil_sm"] =	loadfx("maps/fly/fx_light_fire_oil_sm");
	level._effect["light_fire_oil_md"] =	loadfx("maps/fly/fx_light_fire_oil_md");
	//level._effect["light_oil_fire_lg"] =	loadfx("maps/fly/fx_light_fire_oil_lg");
	level._effect["fire_oil_low_lg"]	=   loadfx("env/fire/fx_fire_oil_low_lg");
	level._effect["a_fire_oil_low_sm"]	=	loadfx("maps/fly/fx_fire_oil_low_sm");
	level._effect["a_fire_oil_xlg"] =	loadfx("env/fire/fx_fire_oil_xlg_dist");
	level._effect["a_fire_oil_xlg_slow"] =	loadfx("env/fire/fx_fire_oil_xlg_dist_slow");
	level._effect["a_fletcher_fire_md"] = loadfx("maps/fly/fx_fire_deck_md");
	level._effect["a_fletcher_fire_lg"]	= loadfx("maps/fly/fx_fire_deck_lg");
	level._effect["a_fletcher_fire_xlg"]	= loadfx("maps/fly/fx_fire_deck_xlg_distant");
	level._effect["a_fire_spread_sm_600"]	= loadfx("env/fire/fx_fire_line_spread_sm_600");
	
	level._effect["cloud_lightning_lg"]     = loadfx("maps/fly/fx_lightning_cloud_plane_01");
	level._effect["lightning_burst_high"]   = loadfx("maps/fly/fx_lightning_clouds_high");
	level._effect["lightning_burst_low"]   =  loadfx("maps/fly/fx_lightning_clouds_low");
	
	level._effect["a_smokebank_rescue"]	= loadfx("maps/fly/fx_smkbank_water_lg");
	level._effect["a_light_merchantship_mast_thick"]	= loadfx("maps/fly/fx_light_merchantship_mast_thick");
	level._effect["a_light_merchantship_mast_mid"]	= loadfx("maps/fly/fx_light_merchantship_mast_mid");
	level._effect["a_light_merchantship_mast_thin"]	= loadfx("maps/fly/fx_light_merchantship_mast_thin");
	
	level._effect["large_glass"]	= loadfx("impacts/fx_large_glass_local");
		
}

spawnFX()
{
	maps\createfx\pby_fly_fx::main();	// Calls in ambient effects created with CreateFX
}    

water_settings()
{
	//-- All of these values were borrowed from Pel1
	/* Water Dvars							Default Values	What They Do
	========================		==============	================================
	r_watersim_enabled					default=true		Enables dynamic water simulation
	r_watersim_debug						default=false		Enables bullet debug markers
  r_watersim_flatten					default=false		Flattens the water surface out
  r_watersim_waveSeedDelay		default=500.0		Time between seeding a new wave (ms)
  r_watersim_curlAmount				default=0.5			Amount of curl applied
  r_watersim_curlMax					default=0.4			Maximum curl limit
  r_watersim_curlReduce				default=0.95		Amount curl gets reduced by when over limit
  r_watersim_minShoreHeight		default=0.04		Allows water to lap over the shoreline edge
  r_watersim_foamAppear				default=20.0		Rate foam appears at
  r_watersim_foamDisappear		default=0.78		Rate foam disappears at
  r_watersim_windAmount				default=0.02		Amount of wind applied
  r_watersim_windDir					default=45.0		Wind direction (degrees)
  r_watersim_windMax					default=0.4			Maximum wind limit
  r_watersim_particleGravity	default=0.03		Particle gravity
  r_watersim_particleLimit		default=2.5			Limit at which particles get spawned
  r_watersim_particleLength		default=0.03		Length of each particle
  r_watersim_particleWidth		default=2.0			Width of each particle
	*/
	
	SetDvar( "r_watersim_waveSeedDelay", 100.0 );
	SetDvar( "r_watersim_curlAmount", 0.18 );
	SetDvar( "r_watersim_curlMax", 0.2 );
	SetDvar( "r_watersim_curlReduce", 0.95 );
	SetDvar( "r_watersim_minShoreHeight", 0.04 );
	SetDvar( "r_watersim_foamAppear", 17.0 );
	SetDvar( "r_watersim_foamDisappear", 0.45 );
	SetDvar( "r_watersim_windAmount", 0.026 );
	SetDvar( "r_watersim_windDir", 45 );
	SetDvar( "r_watersim_windMax", 1.96 );
	SetDvar( "r_watersim_particleGravity", 0.03 );
	SetDvar( "r_watersim_particleLimit", 2.5 );
	SetDvar( "r_watersim_particleLength", 0.03 );
	SetDvar( "r_watersim_particleWidth", 2.0 );	
}

//-- Flak FX over the US Fleet
play_flak_field()
{
	/*
	fx_structs = [];
	fx_structs = GetStructArray("flak_field_ref", "targetname");
		
	for(i=0; i < fx_structs.size; i++)
	{
		PlayFx(level._effect["flak_field"], fx_structs[i].origin);
	}
	*/
}

play_looping_fx_on_tag( _fx, tag, offset_org, offset_ang, z_value)
{
	//maps\_utility::ok_to_spawn(60);
	fx_marker = Spawn("script_model", self GetTagOrigin(tag));
	fx_marker SetModel("tag_origin");
	fx_marker.angles = self GetTagAngles(tag);
	
	if(!IsDefined(offset_ang))
	{
		offset_ang = (0,0,0);
	}
	
	if(!IsDefined(offset_org))
	{
		offset_org = (0,0,0);
	}
	
	fx_marker LinkTo(self, tag, offset_org, offset_ang); //TODO: figure out if this is a bug
	fx_marker.parent = self;
		
	PlayFXOnTag( _fx, fx_marker, "tag_origin" );
	
	if(IsDefined(z_value))
	{
		fx_marker thread fx_watch_z_value(z_value, tag);
	}
	
	return fx_marker;
}

fx_watch_z_value(z_value, tag)
{
	self endon("death");
	
	height_delta = 0;
	ref_point = (0,0,0);
	
	while(1)
	{
		ref_point = self.parent GetTagOrigin(tag);
		if(ref_point[2] < z_value)
		{
			//move the fx_marker up to the z_value, this is primarily used with the water effects
			self Unlink();
			
			height_delta = z_value - ref_point[2];
			wait(0.05);
			self LinkTo( self.parent, tag, (0,0,height_delta), (0,0,0));
		}
		
		wait(0.05);
	}
}

play_looping_fx_on_ent( _fx, ent)
{
	maps\_utility::ok_to_spawn(60.0);
	fx_marker = Spawn("script_model", ent.origin);
	fx_marker SetModel("tag_origin");
	fx_marker.angles = ent.angles;
	
	//fx_marker LinkTo(self, tag, (0,0,0), (0,0,0));
		
	PlayFXOnTag( _fx, fx_marker, "tag_origin" );
	
	return fx_marker;
}

lightning_flash(event)
{
	level endon("stop lightning");
	
	//-- HACKED TOGETHER BY ME FROM OTHER SOURCES
	level.orgsuncolor = getMapSunLight();
	
	add = ( (randomfloatrange(20, 30) * -1), (randomfloatrange(20, 25)), 0 );
	
	string = getdvar("r_lightTweakSunDirection");
	token = strtok(string, " ");
	level.lite_settings = (int(token[0]), int(token[1]), int(token[2]));
	level.new_lite_settings = level.lite_settings;
	
	//-- play the lightning_effect
	
	lightning_pos = 0;
	if(event == "merchantship")
	{
		fx_light = level._effect["lightning_burst_high"];
		//lightning_pos = (-41390.7, 10853.1, 6949.13);
		lightning_pos = (-41390.7, 30853.1, 6949.13);
	}
	else
	{
		fx_light = level._effect["lightning_burst_low"];
		lightning_pos = (12326.2, 50384.5, 3727.78);
	}
	
	while(1)
	{
		wait (0.05);
		
		PlayFX(fx_light, lightning_pos, (270,0,0));
		sound_ent = Spawn("script_origin", lightning_pos);
		sound_ent PlaySound("pby_thunder");
	  		
		setSunLight( 1, 1, 1.2 );
		angle = level.new_lite_settings + add;
		vec = anglestoforward( angle );
	  setSunDirection( vec );
	  wait (0.05);
	
		
	  setSunLight( 2, 2, 2.5 );
	  angle = level.new_lite_settings + add;
	  vec = anglestoforward( angle );
	  setSunDirection( vec );
	 	wait (0.05);
	  
	  setSunLight( 3, 3, 3.7 );
	  angle = level.new_lite_settings + add;
	  vec = anglestoforward( angle );
	  setSunDirection( vec );
	  wait (0.05);
	  
	  /*
	  setSunLight( 4, 4, 5 );
	  angle = level.new_lite_settings + add;
		vec = anglestoforward( angle );
		setSunDirection( vec );
		
		wait(0.05);
		*/
		normal();
		
		random_wait = RandomIntRange(25, 55);
		
		if(event == "merchantship")
		{
			random_wait = RandomIntRange(10, 15);
		}
		
		//random_wait = RandomIntRange(5, 10);
		wait(random_wait);
		sound_ent Delete();
	}
}

normal()
{
	resetSunLight();
	resetSunDirection();
	setsunlight( level.orgsuncolor[0], level.orgsuncolor[1], level.orgsuncolor[2] );
}

scripted_lightning_flash(start_notify, end_notify, wait_flash, direction)
{
	//-- tied directly to the ADS
	//-- this could also be a lot cleaner, but it works
	
	if(IsDefined(start_notify))
	{
		level endon(end_notify);
		level waittill(start_notify);
	}
	
	if(IsDefined(wait_flash))
	{
		wait(wait_flash);
	}
	
	if(IsDefined(direction))
	{
		//-- play FX behind something about 13000 units from the player
		
		fx_light = level._effect["lightning_player"];
		
		lightning_pos = maps\_utility::get_players()[0].origin + (direction * 13000);
		lightning_pos = (lightning_pos[0], lightning_pos[1], 1400);
		PlayFX(fx_light, lightning_pos);
	}
	
	//-- HACKED TOGETHER BY ME FROM OTHER SOURCES
	level.orgsuncolor = getMapSunLight();
	add = ( (randomfloatrange(20, 30) * -1), (randomfloatrange(20, 25)), 0 );
		
	//-- play the lightning_effect
	wait (0.05);
		
	setSunLight( 1, 1, 1.2 );
	angle = level.new_lite_settings + add;
	vec = anglestoforward( angle );
	setSunDirection( vec );
	wait (0.05);
			
	setSunLight( 2, 2, 2.5 );
	angle = level.new_lite_settings + add;
	vec = anglestoforward( angle );
	setSunDirection( vec );
	wait (0.05);
	  
	setSunLight( 3, 3, 3.7 );
	angle = level.new_lite_settings + add;
	vec = anglestoforward( angle );
	setSunDirection( vec );
	wait (0.05);
	  
	normal();
}

sink_big_fx( ship )
{
	PlayFXOnTag( level._effect["sink_break"], ship, "tag_origin" );
}

//-- Note Track FX for PTBoat dying in the water
play_waterfx_ptboat_vent2_jnt( boat )
{
	fx_origin = boat GetTagOrigin("vent2_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	PlayFX(level._effect["zero_part_splash_small"], fx_origin );
}

play_waterfx_ptboat_vent1_jnt( boat )
{
	fx_origin = boat GetTagOrigin("vent1_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	PlayFX(level._effect["zero_part_splash_small"], fx_origin );
}
play_waterfx_ptboat_vent3_jnt( boat )
{
	fx_origin = boat GetTagOrigin("vent3_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	PlayFX(level._effect["zero_part_splash_small"], fx_origin );
}
play_waterfx_ptboat_box2_jnt( boat )
{
	fx_origin = boat GetTagOrigin("box2_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	PlayFX(level._effect["zero_part_splash"], fx_origin );
}
play_waterfx_ptboat_tower_jnt( boat )
{
	fx_origin = boat GetTagOrigin("tower_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	PlayFX(level._effect["zero_part_splash"], fx_origin );
}
play_waterfx_ptboat_radar_jnt( boat )
{
	fx_origin = boat GetTagOrigin("radar_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	PlayFX(level._effect["zero_part_splash"], fx_origin );
}
play_waterfx_ptboat_box1_jnt( boat )
{
	fx_origin = boat GetTagOrigin("box1_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	PlayFX(level._effect["zero_part_splash"], fx_origin );
}

//-- Note Track FX for Zero hitting the water
play_fuselage_water_hit_0( plane )
{
	fx_origin = plane GetTagOrigin("origin_animate_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	fx_forward = AnglesToForward((0, 181.14, 0));
	PlayFX(level._effect["zero_part_splash"], fx_origin, fx_forward, (0,0,1));
}

play_rwing_water_hit_0( plane )
{
	fx_origin = plane GetTagOrigin("tag_wing_right_fx4");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	fx_forward = AnglesToForward((0, 181.14, 0));
	PlayFX(level._effect["zero_part_splash"], fx_origin, fx_forward, (0,0,1));
}

play_lwing_water_hit_0( plane )
{
	fx_origin = plane GetTagOrigin("tag_wing_left_fx4");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	fx_forward = AnglesToForward((0, 181.14, 0));
	PlayFX(level._effect["zero_part_splash"], fx_origin, fx_forward, (0,0,1));
}

play_lwing_water_hit_1( plane )
{
	fx_origin = plane GetTagOrigin("tag_wing_left_fx4");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	fx_forward = AnglesToForward((0, 181.14, 0));
	PlayFX(level._effect["zero_part_splash"], fx_origin, fx_forward, (0,0,1));
}

play_tail_water_hit_0( plane )
{
	fx_origin = plane GetTagOrigin("tag_attach_tail");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	fx_forward = AnglesToForward((0, 181.14, 0));
	PlayFX(level._effect["zero_part_splash"], fx_origin, fx_forward, (0,0,1));
}

play_fuselage_water_hit_1( plane )
{
	fx_origin = plane GetTagOrigin("origin_animate_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	fx_forward = AnglesToForward((0, 181.14, 0));
	PlayFX(level._effect["zero_part_splash"], fx_origin, fx_forward, (0,0,1));
}

play_lwing_water_hit_2( plane )
{
	fx_origin = plane GetTagOrigin("tag_wing_left_fx4");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	fx_forward = AnglesToForward((0, 181.14, 0));
	PlayFX(level._effect["zero_part_splash"], fx_origin, fx_forward, (0,0,1));
}

play_fuselage_water_hit_2( plane )
{
	fx_origin = plane GetTagOrigin("origin_animate_jnt");
	fx_origin = (fx_origin[0], fx_origin[1], 63); //-- height of the water
	fx_forward = AnglesToForward((0, 181.14, 0));
	PlayFX(level._effect["zero_part_splash"], fx_origin, fx_forward, (0,0,1));
}

swim_splash_right()
{
	while(1)
	{
		self waittill( "runanim", note );
		
		//if(note == "splash_r")
		if(note == "end")
		{
			new_origin = self GetTagOrigin("j_wrist_ri");
			new_origin = ( new_origin[0], new_origin[1], 63 );
			PlayFX( level._effect["swim_splash"], new_origin);
			//iprintlnbold("splash_right");
		}
	}
}

swim_splash_left()
{
	while(1)
	{
		self waittill( "runanim", note );
		
		if(note == "splash_l")
		{
			new_origin = self GetTagOrigin("j_wrist_le");
			new_origin = ( new_origin[0], new_origin[1], 63 );
			PlayFX( level._effect["swim_splash"], new_origin);
			//iprintlnbold("splash_left");
		}
	}
}

zero_cloud()
{
	self waittill("cloud_spawn");
	
	_struct = maps\_utility::GetStruct("cloud_spawn_struct", "targetname");
	PlayFX(level._effect["cloud_zero"], _struct.origin);
}
