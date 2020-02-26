#include maps\_weather;
#include maps\_utility;
main()
{
	level.truecolor = getMapSunLight();
	level.orgsuncolor = [];
	level.orgsuncolor[0] = 0.0;
	level.orgsuncolor[1] = 0.0;
	level.orgsuncolor[2] = 0.0;
	
	flag_init("cargoship_lighting_off");
	//ROBOERT GAINS WORLD EFFECTS BELOW THIS
	
	//sinking sequence fx
	level._effect["sinking_explosion"]					= loadfx ("explosions/cobrapilot_vehicle_explosion"); 
	
	level._effect["sinking_leak_large"]					= loadfx ("misc/cargoship_sinking_leak_large"); 
	level._effect["event_waterleak"]					= loadfx ("misc/cargoship_sinking_leak_med"); 
	level._effect["event_steamleak"]					= loadfx ("misc/cargoship_sinking_steam_leak");
	
	level._effect["sinking_waterlevel_center"]			= loadfx ("misc/cargoship_water_noise");
	level._effect["sinking_waterlevel_edge"]			= loadfx ("misc/cargoship_water_noise"); 
	
	
	level._effect["cargo_vl_red_thin"]					= loadfx ("misc/cargo_vl_red_thin"); 
	level._effect["cargo_vl_white"]						= loadfx ("misc/cargo_vl_white"); 
	level._effect["cargo_vl_white_soft"]				= loadfx ("misc/cargo_vl_white_soft");
	level._effect["cargo_vl_white_eql"]					= loadfx ("misc/cargo_vl_white_eql");
	level._effect["cargo_vl_white_eql_flare"]			= loadfx ("misc/cargo_vl_white_eql_flare");
	level._effect["cargo_vl_white_sml"]					= loadfx ("misc/cargo_vl_white_sml");
	level._effect["cargo_vl_white_sml_a"]				= loadfx ("misc/cargo_vl_white_sml_a");
	level._effect["cargo_vl_red_lrg"]					= loadfx ("misc/cargo_vl_red_lrg");	
	level._effect["cargo_steam"]						= loadfx ("smoke/cargo_steam");
	level._effect["cargo_steam_add"]					= loadfx ("smoke/cargo_steam_add");

	//fx for helicopter
	level._effect["heli_spotlight"]						= loadfx ("misc/spotlight_medium"); 
	level._effect["spotlight_dlight"]					= loadfx ("misc/spotlight_dlight"); 
	level._effect["cigar_glow"]							= loadfx ("fire/cigar_glow");
	level._effect["cigar_glow_puff"]					= loadfx ("fire/cigar_glow_puff");	
	level._effect["cigar_exhale"]						= loadfx ("smoke/cigarsmoke_exhale");
	
	//fx for heli interior/exterior lights
	level._effect["aircraft_light_cockpit_red"]			= loadfx ("misc/aircraft_light_cockpit_red");
	level._effect["aircraft_light_cockpit_fill"]		= loadfx ("misc/aircraft_light_cockpit_fill");
	level._effect["aircraft_light_cockpit_fill_fade"]	= loadfx ("misc/aircraft_light_cockpit_fill_fade");
	level._effect["aircraft_light_cockpit_blue"]		= loadfx ("misc/aircraft_light_cockpit_blue");
	level._effect["aircraft_light_white_blink"]			= loadfx ("misc/aircraft_light_white_blink");
	level._effect["aircraft_light_wingtip_green"]		= loadfx ("misc/aircraft_light_wingtip_green");
	level._effect["aircraft_light_wingtip_red"]			= loadfx ("misc/aircraft_light_wingtip_red");
	 
	//lights
	level._effect["cgoshp_lights_cr"]			= loadfx ("misc/cgoshp_lights_cr");
	level._effect["cgoshp_lights_flr"]			= loadfx ("misc/cgoshp_lights_flr"); 
 
	//ambient fx
	level._effect["watersplash"]				= loadfx ("misc/cargoship_splash");
	level._effect["cgo_ship_puddle_small"]		= loadfx ("distortion/cgo_ship_puddle_small");
	level._effect["cgo_ship_puddle_large"]		= loadfx ("distortion/cgo_ship_puddle_large");
	level._effect["cgoshp_drips"]			 	= loadfx ("misc/cgoshp_drips");
	level._effect["cgoshp_drips_a"]			 	= loadfx ("misc/cgoshp_drips_a");
	level._effect["rain_noise"]					= loadfx ("weather/rain_noise");
	level._effect["rain_noise_ud"]				= loadfx ("weather/rain_noise_ud");
	level._effect["fire_med_nosmoke"]			= loadfx ("fire/tank_fire_engine");
//	level._effect["fire_barrel_fragm_a"]		= loadfx ("fire/fire_barrel_fragm_a");
//	level._effect["fire_barrel_fragm_b"]		= loadfx ("fire/fire_barrel_fragm_b");
//	level._effect["fire_barrel_fragm_c"]		= loadfx ("fire/fire_barrel_fragm_c");
	level._effect["watersplash_small"]			= loadfx ("misc/watersplash_small");
	level._effect["water_gush"]					= loadfx ("misc/water_gush");
	level._effect["steam"]						= loadfx ("impacts/pipe_steam");
	level._effect["cgoshp_drips_cargohold_center"]		= loadfx ("misc/cgoshp_holds_drip");
	level._effect["cgoshp_drips_cargohold_edge"]		= loadfx ("misc/cgoshp_drips_far");

	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("wood",			loadfx ("impacts/footstep_water_dark"));
	animscripts\utility::setFootstepEffect ("metal",		loadfx ("impacts/footstep_water_dark"));
	

	// Rain
	level._effect["rain_heavy_cloudtype"]	= loadfx ("weather/rain_heavy_cloudtype");
	level._effect["rain_10"]	= loadfx ("weather/rain_heavy_mist");
	level._effect["rain_9"]		= loadfx ("weather/rain_9");
	level._effect["rain_8"]		= loadfx ("weather/rain_9");
	level._effect["rain_7"]		= loadfx ("weather/rain_9");
	level._effect["rain_6"]		= loadfx ("weather/rain_9");
	level._effect["rain_5"]		= loadfx ("weather/rain_9");
	level._effect["rain_4"]		= loadfx ("weather/rain_9");
	level._effect["rain_3"]		= loadfx ("weather/rain_9");
	level._effect["rain_2"]		= loadfx ("weather/rain_9");
	level._effect["rain_1"]		= loadfx ("weather/rain_9");	
	level._effect["rain_0"]		= loadfx ("weather/rain_0");
	
	//Explosions
	level._effect["barrelExp"]	= loadfx ("props/barrelExp");

	
	thread rainControl(); // level specific rain settings.
	thread playerWeather(); // make the actual rain effect generate around the player
	
	// Thunder & Lightning
	level._effect["lightning"]				= loadfx ("weather/lightning");
	level._effect["lightning_bolt"]			= loadfx ("weather/lightning_bolt");
	level._effect["lightning_bolt_lrg"]		= loadfx ("weather/lightning_bolt_lrg");


	addLightningExploder(10); // these exploders make lightning flashes in the sky
	addLightningExploder(11);
	addLightningExploder(12);
	level.nextLightning = gettime() + 1;//10000 + randomfloat(4000); // sets when the first lightning of the level will go off
	
	//ambient fx

	thread init_exploders();
	thread rampupsun();
}

rainControl()
{
	// controls the temperment of the weather
	rainInit("hard"); // "none" "light" or "hard"

	wait 40;
	thread lightning(::normal, ::flash); // starts up a lightning process with the level specific fog settings

/* This allows you to control the rain amount over time
	wait (15);
	rainLight(15);
	wait (30);
	rainHard(15);
	wait (20);
	rainLight(10);
	wait (15);
	rainHard(10);
	wait (60);
	for (;;)
	{	
		rainLight(15);
		wait (60);
		rainNone(10);
		wait (25 + randomint(15));
		rainLight(15);
		wait (25 + randomint(15));
		rainHard(15);
		wait (60);
		rainLight(10);
		wait (25 + randomint(15));
		rainHard(10);
		wait (25 + randomint(15));
	}
	*/
}

rampupsun()
{
	color = level.truecolor;

	time = 15;
	
	range = [];
	range[0] = color[0] - level.orgsuncolor[0];
	range[1] = color[1] - level.orgsuncolor[1];
	range[2] = color[2] - level.orgsuncolor[2];
	
	passes = time * 5;
	
	interval = [];
	interval[0] = range[0] / (passes);
	interval[1] = range[1] / (passes);
	interval[2] = range[2] / (passes);
	
	wait 15;

	while(passes)
	{
		setsunlight( level.orgsuncolor[0], level.orgsuncolor[1], level.orgsuncolor[2] );
		level.orgsuncolor[0] += interval[0];
		level.orgsuncolor[1] += interval[1];
		level.orgsuncolor[2] += interval[2];
		wait .2;
		passes--;
	}
}

normal()
{
	if( flag("cargohold_fx") )
		return;
	flag_set("cargoship_lighting_off");
	//setCullFog (level.fogvalue["min"], level.fogvalue["max"], level.fogvalue["r"], level.fogvalue["g"], level.fogvalue["b"], 0.1);
    resetSunLight();
  //  level.orgsuncolor
   // setSunLight( .1, .1, .1);
    setsunlight( level.orgsuncolor[0], level.orgsuncolor[1], level.orgsuncolor[2] );
}

init_exploders()
{
	waittillframeend;
	/********************************************************************************/
	/*              			 HEY ROBERT AND JAVIER		  						*/
	/*																				*/
	/*	You're wondering wtf this is...by putting the exploder into this array, 	*/
	/*	we can call it dynamically based on the boat tilt and player position		*/
	/*																				*/
	/********************************************************************************/
	level._waves_exploders = getfxarraybyID( "watersplash" );

	// various lightning sky effects around the level
	/********************************************************************************/
	/*              			 HEY ROBERT AND JAVIER		  						*/
	/*																				*/
	/*	You're wondering wtf this is...by putting the exploder into this array, 	*/
	/*	we can change it's origin relative to the world position					*/
	/*																				*/
	/********************************************************************************/
	level._lighting_exploders = getfxarraybyID( "lightning" );
	
	for(i=0; i< level._lighting_exploders.size; i++)
		level._lighting_exploders[i].v["cargoship_origin"] = level._lighting_exploders[i].v["origin"]; 
	
}

update_exploders()
{
	for(i=0; i< level._lighting_exploders.size; i++)
		level._lighting_exploders[i].v["origin"] = level._sea_org localtoworldcoords(level._lighting_exploders[i].v["cargoship_origin"]);
}

flash(flshmin, flshmax, strmin, strmax, dir)
{
	level notify("CS_lighting_flash");
	level endon("CS_lighting_flash");
	if(level.createFX_enabled)
		return;
	
	if( flag("cargohold_fx") )
		return;
	
	add = undefined;
	
	if(isdefined(dir))
		add = dir;
	else
		add = ( (randomfloatrange(20, 30) * -1), (randomfloatrange(20, 25)), 0 );
   
		min = 1;
		max = 4;
		
		if(isdefined(flshmin))
    		min = flshmin;
    	if(isdefined(flshmax) && flshmax < max)
    		max = flshmax;
		
   	num = randomintrange(min, max);
   
  		min = 0;
    	max = 3;
 
    	if(isdefined(strmin))
    		min = strmin;
    	if(isdefined(strmax) && strmax < max)
    		max = strmax;
    		
    for(i=0; i<num; i++)
    { 
    	type = randomintrange(min, max);
	    switch(type)
	    {
	    	case 0:{
	    		wait (0.05);
			    flag_clear("cargoship_lighting_off");
			    
			    update_exploders();
			    setSunLight( 1, 1, 1.2 );
			    angle = level.new_lite_settings + add;
			    setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));
			    wait (0.05);
			    
			    update_exploders();
			    setSunLight( 2, 2, 2.5 );
			    angle = level.new_lite_settings + add;
			    setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));
			 
	    		}break;  	
	    		
	    	case 1:{
	    		wait (0.05);
			    flag_clear("cargoship_lighting_off");
	    		
	    		update_exploders();
	    		setSunLight( 1, 1, 1.2 );
	    		angle = level.new_lite_settings + add;
				setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));	
			    wait (0.05);
			  
			  	update_exploders();
			    setSunLight( 2, 2, 2.5 );
			    angle = level.new_lite_settings + add;
			    setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));
			   	wait (0.05);
			    
			    update_exploders();
			    setSunLight( 3, 3, 3.7 );
			    angle = level.new_lite_settings + add;
			    setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));
			  
	    		}break;
	    	
	    	case 2:{
	    		wait (0.05);
			    flag_clear("cargoship_lighting_off");
	    		
	    		update_exploders();
	    		setSunLight( 1, 1, 1.2 );
	    		angle = level.new_lite_settings + add;
				setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));	
			    wait (0.05);
			  
			  	update_exploders();
			    setSunLight( 2, 2, 2.5 );
			    angle = level.new_lite_settings + add;
			    setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));
			   	wait (0.05);
			    
			    update_exploders();
			    setSunLight( 3, 3, 3.7 );
			    angle = level.new_lite_settings + add;
			    setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));
			    wait (0.05);
			    
			    update_exploders();
			    setSunLight( 4, 4, 5 );
			    angle = level.new_lite_settings + add;
			    setsaveddvar("r_lightTweakSunDirection", (angle[0] + " " +  angle[1] + " " +  angle[2]));
			  
	    		}break;
	    }
	    wait randomfloatrange(0.05, 0.1);
   		normal();
    }
    normal();
}

