//_createart generated.  modify at your own risk. Changing values should be fine.
#include common_scripts\utility;
#include maps\_utility;

main()
{


	//flag_wait( "la_1_sky_transition" );
	
	VisionSetNaked( "la1_2", 5 );
	
	//fog settings to blend into when skybox changes (driving section)
	start_dist = 351.441;
	half_dist = 5000.76;
	half_height = 700.87;
	base_height = 118.875;
	fog_r = 0.290196;
  fog_g = 0.317647;
  fog_b = 0.333333;
	fog_scale = 17.3861;
	sun_col_r = 1;
	sun_col_g = 0.501961;
	sun_col_b = 0.121569;
	sun_dir_x = 0.476913;
	sun_dir_y = 0.645584;
	sun_dir_z = 0.596469;
	sun_start_ang = 0;
	sun_stop_ang = 56.8708;
	time = 0;
	max_fog_opacity = 1;

	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
}
	
	
	
	
	
//	flag_wait( "entering_arena" );
	
	//VisionSetNaked( "la1_staple_center", 5 );

//	start_dist = 407.599;
//	half_dist = 6863.42;
//	half_height = 2000.28;
//	base_height = 118.875;
//	fog_r = 0.42;
//	fog_g = 0.5;
//	fog_b = 0.5;
//	fog_scale = 13.3861;
//	sun_col_r = 0.917647;
//	sun_col_g = 0.733333;
//	sun_col_b = 0.423529;
//	sun_dir_x = 0.476913;
//	sun_dir_y = 0.645584;
//	sun_dir_z = 0.596469;
//	sun_start_ang = 0;
//	sun_stop_ang = 68.812;
//	time = 0;
//	max_fog_opacity = 1;
	
//	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
//	sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
//	sun_stop_ang, time, max_fog_opacity);
	
//	flag_wait( "exiting_arena" );
	
//	VisionSetNaked( "la1_2", 5 );
	
	//fog settings to blend into when skybox changes (driving section)
//	start_dist = 407.599;
//	half_dist = 6863.42;
//	half_height = 2000.28;
//	base_height = 118.875;
	//fog_r = 0.42;
//	fog_g = 0.5;
//	fog_b = 0.5;
//	fog_scale = 13.3861;
//	sun_col_r = 0.917647;
//	sun_col_g = 0.733333;
//	sun_col_b = 0.423529;
//	sun_dir_x = 0.476913;
//	sun_dir_z = 0.596469;
//	sun_start_ang = 0;
//	sun_stop_ang = 68.812;
//	time = 0;
//	max_fog_opacity = 1;

//	SetVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
//		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
//		sun_stop_ang, time, max_fog_opacity);




///////////Sonar Hero Lighting///////////////
  //  SetSavedDvar( "r_lightGridEnableTweaks", 1 );
   // SetSavedDvar( "r_lightGridIntensity", 2 );
   // SetSavedDvar( "r_lightGridContrast", 1 );


//staple_center fog and vision set, should be turned on only for indoor section, after staple center go back to the post-driving settings
//use la1_staple_center.vision

//VisionSetNaked( "la1_staple_center", 5 );

//start_dist = 407.599;
//	half_dist = 6863.42;
	//half_height = 2000.28;
	//base_height = 118.875;
	//fog_r = 0.42;
	//fog_g = 0.5;
	//fog_b = 0.5;
	//fog_scale = 13.3861;
	//sun_col_r = 0.917647;
	//sun_col_g = 0.733333;
	//sun_col_b = 0.423529;
	//sun_dir_x = 0.476913;
	//sun_dir_y = 0.645584;
	//sun_dir_z = 0.596469;
	//sun_start_ang = 0;
	//sun_stop_ang = 68.812;
	//time = 0;
//	max_fog_opacity = 1;