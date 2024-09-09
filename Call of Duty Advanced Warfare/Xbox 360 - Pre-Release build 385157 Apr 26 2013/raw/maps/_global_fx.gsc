#include maps\_global_fx_code;

	// This script automaticly plays a users specified oneshot effect on all prefabs that have the 
	// specified "script_struct" and "targetname" It also excepts angles from the "script_struct" 
	// but will set a default angle of ( 0, 0, 0 ) if none is defined.

main()
{
		   //   targetname 							    fxFile 									    
	global_FX( "ch_streetlight_02_FX_origin"		 , "fx/misc/lighthaze" );
	global_FX( "me_streetlight_01_FX_origin"		 , "fx/misc/lighthaze_bog_a" );
	global_FX( "ch_street_light_01_on"				 , "fx/misc/lighthaze" );
	global_FX( "com_wall_streetlamp_on"				 , "fx/misc/light_glow_white_dim" );
	global_FX( "lamp_post_globe_on"					 , "fx/misc/light_glow_white" );
	global_FX( "highway_lamp_post"					 , "fx/misc/lighthaze_villassault" );
	global_FX( "cs_cargoship_spotlight_on_FX_origin" , "fx/misc/lighthaze" );
	global_FX( "com_tires_burning01_FX_origin"		 , "fx/fire/tire_fire_med" );
	global_FX( "icbm_powerlinetower_FX_origin"		 , "fx/misc/power_tower_light_red_blink" );
	global_FX( "icbm_mainframe_FX_origin"			 , "fx/props/icbm_mainframe_lightblink" );
	global_FX( "lighthaze_oilrig_FX_origin"			 , "fx/misc/lighthaze_oilrig" );
	global_FX( "lighthaze_white_FX_origin"			 , "fx/misc/lighthaze_white" );
	global_FX( "light_glow_walllight_white_FX_origin", "fx/misc/light_glow_walllight_white" );
	global_FX( "fluorescent_glow_FX_origin"			 , "fx/misc/fluorescent_glow" );
	global_FX( "light_glow_industrial_FX_origin"	 , "fx/misc/light_glow_industrial" );
	global_FX( "light_glow_white_bulb_FX_origin"	 , "fx/misc/light_glow_white_bulb" );
	global_FX( "light_glow_white_lamp_FX_origin"	 , "fx/misc/light_glow_white_lamp" );
	global_FX( "highrise_blinky_tower"				 , "fx/misc/power_tower_light_red_blink_large" );
	
		   //   targetname 					     fxFile 								    delay   
	global_FX( "light_red_steady_FX_origin"	  , "fx/misc/tower_light_red_steady"		 , -2 );
	global_FX( "light_blue_steady_FX_origin"  , "fx/misc/tower_light_blue_steady"		 , -2 );
	global_FX( "light_orange_steady_FX_origin", "fx/misc/tower_light_orange_steady"		 , -2 );
	global_FX( "glow_stick_pile_FX_origin"	  , "fx/misc/glow_stick_glow_pile"			 , -2 );
	global_FX( "light_pulse_red_FX_origin"	  , "fx/misc/light_glow_red_generic_pulse"	 , -2 );
	global_FX( "light_pulse_red_FX_origin"	  , "fx/misc/light_glow_red_generic_pulse"	 , -2 );
	global_FX( "light_pulse_orange_FX_origin" , "fx/misc/light_glow_orange_generic_pulse", -2 );
	global_FX( "light_red_blink_FX_origin"	  , "fx/misc/power_tower_light_red_blink"	 , -2 );
	
		   //   targetname 				      fxFile 				      delay      fxName 			    
	global_FX( "flare_ambient_FX_origin"   , "fx/misc/flare_ambient"   , undefined, "emt_road_flare_burn" );
	global_FX( "me_dumpster_fire_FX_origin", "fx/fire/firelp_med_pm"   , undefined, "fire_dumpster_medium" );
	global_FX( "barrel_fireFX_origin"	   , "fx/fire/firelp_barrel_pm", undefined, "fire_barrel_small" );
	
	
	// CORNERED START
	//   targetname 							    	fxFile 			
	global_FX( "cnd_laptop_001_open_on_FX_origin", 		"vfx/ambient/props/laptop_dust");
	global_FX( "cnd_glowstick_FX_origin", 				"fx/misc/glow_stick_glow_orange");
	// END CORNERED
}
