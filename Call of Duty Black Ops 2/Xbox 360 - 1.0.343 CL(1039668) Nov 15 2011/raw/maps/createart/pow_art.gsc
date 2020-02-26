
// Alter at own risk

main()
{
 
////////////////////////////////////////////////// BOOT UP SETTINGS /////////////////////////////////////////////////

	///////////New Hero Lighting///////////////
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.25 );
	SetSavedDvar( "r_lightGridContrast", .45 );
	
	setdvar("scr_fog_exp_halfplane", "4000");
	setdvar("scr_fog_exp_halfheight", "300");
	setdvar("scr_fog_nearplane", "2000");
	setdvar("scr_fog_red", "0.05");
	setdvar("scr_fog_green", "0.05");
	setdvar("scr_fog_blue", "0.05");
	setdvar("scr_fog_baseheight", "50");
	
	SetSavedDvar( "r_skyColorTemp", (7000));  

	start_dist = 204.917;
	half_dist = 108.45;
	half_height = 1050;
	base_height = -409.029;
	fog_r = 0.0901961;
	fog_g = 0.14902;
	fog_b = 0.14902;
	fog_scale = 1.625;
	sun_col_r = 1;
	sun_col_g = 1;
	sun_col_b = 1;
	sun_dir_x = -0.135149;
	sun_dir_y = 0.314185;
	sun_dir_z = 0.939693;
	sun_start_ang = 0;
	sun_stop_ang = 0;
	time = 0;
	max_fog_opacity = 0.909892;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

//  level.dof["nearStart"], 
//  level.dof["nearEnd"],
//  level.dof["farStart"],
//  level.dof["farEnd"],
//  level.dof["nearBlur"],
//  level.dof["farBlur"]

//  self SetDepthofField (558, 503, 2539, 11471, 6, 1.8) 
 
	VisionSetNaked( "pow", 0 );
	
	level.dofDefault["nearStart"] = 0; 
	level.dofDefault["nearEnd"] = 32; 
	level.dofDefault["farStart"] = 125; 
	level.dofDefault["farEnd"] = 400; 
	level.dofDefault["nearBlur"] = 4; 
	level.dofDefault["farBlur"] = 2.5; 
			
// Threads for Fog


	level thread set_roulettefogenter_trigger();
	level thread set_roulettefogexit_trigger();
	level thread set_midcavefogenter_trigger();
	level thread set_caveexit_trigger();

	
	
	// level thread set_clearingfog_trigger();
	level thread set_tunnelexit_trigger();
	level thread set_copterexit_trigger();
	level thread set_basefog_trigger();
  level thread set_officefog_trigger();
  level thread set_endfightfog_trigger();
  
  
	
// Threads for DOF	
	
	level thread set_flying_dof();
	level thread set_after_meatshield_dof();
	level thread clear_dof();

	
// Threads for Visionsets		
				
	level thread set_vision_cage();
	//level thread set_vision_clearing(); //-- transition to this one after the bloom
	level thread set_vision_cave();
	level thread set_vision_bloom();
	level thread set_vision_endtable();
}


////////////////////////////////////////////////// TRIGGERS /////////////////////////////////////////////////


// Fog Triggers


set_roulettefogenter_trigger()
{
	
	self endon("death");

	trig = GetEnt("roulettefog_enter", "script_noteworthy");
	trig waittill("trigger");

	// update fog settings
	
	roulettefog_enter_settings();
	
}

set_roulettefogexit_trigger()
{
	
	self endon("death");

	trig = GetEnt("roulettefog_exit", "script_noteworthy");
	trig waittill("trigger");

	// update fog settings
	roulettefog_exit_settings();
	
}


set_midcavefogenter_trigger()
{
	
	self endon("death");

	trig = GetEnt("midcavefog_enter", "script_noteworthy");
	trig waittill("trigger");

	// update fog settings
	midcavefog_enter_settings();
	
}

set_caveexit_trigger()
{
	
	self endon("death");

	trig = GetEnt("caveexit", "script_noteworthy");
	trig waittill("trigger");

	// update fog settings
	
	cave_exit_settings();
	
}



set_tunnelexit_trigger()
{
	
	self endon("death");

	trig = GetEnt("tunnel_exit", "script_noteworthy");
	trig waittill("trigger");

	// update fog settings
	tunnel_exit_fog_settings();
	//set_default_dof();
	set_flying_dof_instant();
	
		SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.3 );
	SetSavedDvar( "r_lightGridContrast", .0 );
}


set_basefog_trigger()
{
	self endon("death");

	trig = GetEnt("basefog", "script_noteworthy");
	trig waittill("trigger");

// update fog settings
	
	base_fog_settings();

}	
	

set_officefog_trigger()
{
	
	self endon("death");

	trig = GetEnt("office_fog", "script_noteworthy");
	trig waittill("trigger");

// update fog settings
	
	office_fog_settings();


}


set_endfightfog_trigger()
{
	
	self endon("death");

	trig = GetEnt("endfightfog", "script_noteworthy");
	trig waittill("trigger");

// update fog settings
	
	endfight_fog_settings();


}

set_copterexit_trigger()
{
	self endon("death");

	trig = GetEnt("copterexit", "script_noteworthy");
	trig waittill("trigger");

// update fog settings
	
	copter_exit_settings();

}	

////////////////////////////////////////////////// DEPTH OF FIELD SETTINGS /////////////////////////////////////////////////


set_default_dof()
{
	player = maps\_utility::get_players()[0];
	
	player SetDepthOfField( level.Default_Near_Start, level.Default_Near_End, level.Default_Far_Start, level.Default_Far_End, level.Default_Near_Blur, level.Default_Far_Blur );
}

set_flying_dof()
{
	level waittill( "set_flying_dof" );
	set_flying_dof_instant();
}

set_flying_dof_instant() //-- This disables depth of field
{
	player = maps\_utility::get_players()[0];
		
	Default_Near_Start = 10;
	Default_Near_End = 0;
	Default_Far_Start = 10;
	Default_Far_End = 0;
	Default_Near_Blur = 4;
	Default_Far_Blur = 0.1875;
	
	player SetDepthOfField( Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur );
}

set_opening_dof()
{
	maps\_utility::wait_for_first_player();
	player = maps\_utility::get_players()[0];
	
	level.Default_Near_Start = player GetDepthOfField_NearStart();
	level.Default_Near_End = player GetDepthOfField_NearEnd();
	level.Default_Far_Start = player GetDepthOfField_FarStart();
	level.Default_Far_End = player GetDepthOfField_FarEnd();
	level.Default_Near_Blur = player GetDepthOfField_NearBlur();
	level.Default_Far_Blur = player GetDepthOfField_FarBlur();
	
	/*
	Default_Near_Start = 0;
	Default_Near_End = 35;
	Default_Far_Start = 92;
	Default_Far_End = 256;
	Default_Near_Blur = 6.3;
	Default_Far_Blur = 0.84;
	*/
	
	//for rouellet
		Default_Near_Start = 0;
	Default_Near_End = 32;
	Default_Far_Start = 125;
	Default_Far_End = 400;
	Default_Near_Blur = 4;
	Default_Far_Blur = 2.4;

	player SetDepthOfField( Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur );
}

set_after_meatshield_dof()
{
	while(1)
	{
		level waittill("after_meatshield_dof_change");
		set_after_meatshield_dof_instant();
	}
}

set_after_meatshield_dof_instant() 
{
	player = maps\_utility::get_players()[0];
		/*
	Default_Near_Start = 0;
	Default_Near_End = 0;
	Default_Far_Start = 1100;
	Default_Far_End = 2000;
	Default_Near_Blur = 6.3;
	Default_Far_Blur = 0.84;
	*/
	
	//Disabaling
		Default_Near_Start = 0;
		Default_Near_End = 0;
		Default_Far_Start = 0;
		Default_Far_End = 0;
		Default_Near_Blur = 6.3;
		Default_Far_Blur = 0.84;
	
	player SetDepthOfField( Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur );
}

clear_dof()
{
	while(1)
	{
		level waittill("clear_dof");
		player = maps\_utility::get_players()[0];
		
		Default_Near_Start = 0;
		Default_Near_End = 0;
		Default_Far_Start = 0;
		Default_Far_End = 0;
		Default_Near_Blur = 6.3;
		Default_Far_Blur = 0.84;
		
		player SetDepthOfField( Default_Near_Start, Default_Near_End, Default_Far_Start, Default_Far_End, Default_Near_Blur, Default_Far_Blur );
	}
}


////////////////////////////////////////////////// VISIONSET SETTINGS /////////////////////////////////////////////////


set_vision_cage()
{
		VisionSetNaked( "pow_cage", 0 );
}

set_vision_clearing()
{
	while(1)
	{
		level waittill("vs_clearing");
		VisionSetNaked( "pow_mountain", 3 );
	}
}

set_vision_tunnels()
{
	level waittill("vs_tunnels");
	VisionSetNaked( "pow_cave", 0 );
}

set_vision_cave()
{
	while(1)
	{
		common_scripts\utility::trigger_wait("trig_cave_vs");
		VisionSetNaked( "pow_cave", 3 );
		//set_after_meatshield_dof_instant();
		
		common_scripts\utility::trigger_wait("trig_mountain_vs");
		VisionSetNaked( "pow_mountain", 3 );
	}
}

set_vision_endtable( guy ) //-- called as notetrack
{
		VisionSetNaked( "pow_endtable", 3 );
		
		Default_Near_Start = 0;
		Default_Near_End = 15;
		Default_Far_Start = 30;
		Default_Far_End = 40;
		Default_Near_Blur = 4;
		Default_Far_Blur = 4.5;
		
}

set_vision_bloom() //-- find out if i need to set this up so you can set off the bloom multiple times
{
	trigger = GetEnt("trig_activate_bloom", "targetname");
	trigger waittill("trigger");
	
	trigger = GetEnt("trig_actually_bloom", "targetname");
	trigger waittill("trigger");
	VisionSetNaked( "pow_bloom", 2 );
	wait(3.0);
	VisionSetNaked( "pow_mountain", 3 );
}



////////////////////////////////////////////////// FOG SETTINGS /////////////////////////////////////////////////


roulettefog_enter_settings()
{

	start_dist = 204.917;
	half_dist = 108.45;
	half_height = 1050;
	base_height = -409.029;
	fog_r = 0.0901961;
	fog_g = 0.14902;
	fog_b = 0.14902;
	fog_scale = 1.625;
	sun_col_r = 1;
	sun_col_g = 1;
	sun_col_b = 1;
	sun_dir_x = -0.135149;
	sun_dir_y = 0.314185;
	sun_dir_z = 0.939693;
	sun_start_ang = 0;
	sun_stop_ang = 0;
	time = 0;
	max_fog_opacity = 0.909892;


	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
		VisionSetNaked( "pow_roulette", 0 );
		
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", .1 );
		
}

roulettefog_exit_settings()
{

	start_dist = 170.832;
	half_dist = 325.336;
	half_height = 1050;
	base_height = -409.029;
	fog_r = 0.12412;
	fog_g = 0.14902;
	fog_b = 0.14902;
	fog_scale = 1.625;
	sun_col_r = 1;
	sun_col_g = 1;
	sun_col_b = 1;
	sun_dir_x = -0.135149;
	sun_dir_y = 0.314185;
	sun_dir_z = 0.939693;
	sun_start_ang = 0;
	sun_stop_ang = 35;
	time = 5;
	max_fog_opacity = 0.909892;


	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

		
		VisionSetNaked( "pow_cave", 5 );
		
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.4 );
	SetSavedDvar( "r_lightGridContrast", .2 );
}


midcavefog_enter_settings()
{

	start_dist = 201.619;
	half_dist = 265.159;
	half_height = 1050;
	base_height = -409.029;
	fog_r = 0.129412;
	fog_g = 0.14902;
	fog_b = 0.14902;
	fog_scale = 1.89763;
	sun_col_r = 1;
	sun_col_g = 1;
	sun_col_b = 1;
	sun_dir_x = -0.135149;
	sun_dir_y = 0.314185;
	sun_dir_z = 0.939693;
	sun_start_ang = 0;
	sun_stop_ang = 56.5244;
	time = 5;
	max_fog_opacity = 0.909892;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


		
		VisionSetNaked( "pow_midcave", 5 );
		
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.4 );
	SetSavedDvar( "r_lightGridContrast", .2 );
	
		
}
cave_exit_settings()
{

	start_dist = 0;
	half_dist = 9032.07;
	half_height = 1181.34;
	base_height = 550.76;
	fog_r = 0.160784;
	fog_g = 0.207843;
	fog_b = 0.258824;
	fog_scale = 9.99111;
	sun_col_r = 1;
	sun_col_g = 0.968628;
	sun_col_b = 0.847059;
	sun_dir_x = 0.302892;
	sun_dir_y = 0.800725;
	sun_dir_z = 0.516814;
	sun_start_ang = 0;
	sun_stop_ang = 24.5172;
	time = 5;
	max_fog_opacity = 1;


	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);



		
	VisionSetNaked( "pow_face_up", 3 );
		
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.1 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
		
}

/*
clearingfog_settings()
{

	start_dist = 684.679;
	half_dist = 1075.6;
	half_height = 1050;
	base_height = 857.621;
	fog_r = 0.47451;
	fog_g = 0.458824;
	fog_b = 0.352941;
	fog_scale = 2.14065;
	sun_col_r = 0.639216;
	sun_col_g = 0.870588;
	sun_col_b = 0.921569;
	sun_dir_x = 0.22;
	sun_dir_y = 0.84;
	sun_dir_z = 0.48;
	sun_start_ang = 0;
	sun_stop_ang = 20;
	time = 5;
	max_fog_opacity = 0.544176;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
		VisionSetNaked( "pow_mountain", 0 );
		
}
*/
tunnel_exit_fog_settings()
{

start_dist = 1209.62;
	half_dist = 3702.99;
	half_height = 1181.34;
	base_height = 550.76;
	fog_r = 0.160784;
	fog_g = 0.207843;
	fog_b = 0.258824;
	fog_scale = 9.99111;
	sun_col_r = 1;
	sun_col_g = 0.968628;
	sun_col_b = 0.847059;
	sun_dir_x = 0.302892;
	sun_dir_y = 0.800725;
	sun_dir_z = 0.516814;
	sun_start_ang = 0;
	sun_stop_ang = 29.9779;
	time = 5;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", 0.2 );
	
}


base_fog_settings()
{
	
 	start_dist = 196.668;
	half_dist = 457.652;
	half_height = 1050;
	base_height = 859.181;
	fog_r = 0.109804;
	fog_g = 0.145098;
	fog_b = 0.14902;
	fog_scale = 3.72185;
	sun_col_r = 0.639216;
	sun_col_g = 0.870588;
	sun_col_b = 0.921569;
	sun_dir_x = 0.22;
	sun_dir_y = 0.84;
	sun_dir_z = 0.48;
	sun_start_ang = 0;
	sun_stop_ang = 20;
	time = 10;
	max_fog_opacity = 0.544176;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

		
		VisionSetNaked( "pow_base", 10 );
		
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", 0.2 );
		
}

office_fog_settings()
{
	
start_dist = 196.668;
	half_dist = 457.652;
	half_height = 1050;
	base_height = 859.181;
	fog_r = 0.12549;
	fog_g = 0.145098;
	fog_b = 0.14902;
	fog_scale = 3.72185;
	sun_col_r = 0.639216;
	sun_col_g = 0.870588;
	sun_col_b = 0.921569;
	sun_dir_x = 0.22;
	sun_dir_y = 0.84;
	sun_dir_z = 0.48;
	sun_start_ang = 0;
	sun_stop_ang = 20;
	time = 5;
	max_fog_opacity = 0.544176;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


		
		VisionSetNaked( "pow_office", 4 );
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", 0.2 );
		
}

endfight_fog_settings()
{
	
start_dist = 136.508;
	half_dist = 435.255;
	half_height = 1050;
	base_height = 859.181;
	fog_r = 0.12549;
	fog_g = 0.145098;
	fog_b = 0.14902;
	fog_scale = 7.91565;
	sun_col_r = 0.639216;
	sun_col_g = 0.870588;
	sun_col_b = 0.921569;
	sun_dir_x = 0.22;
	sun_dir_y = 0.84;
	sun_dir_z = 0.48;
	sun_start_ang = 0;
	sun_stop_ang = 20;
	time = 5;
	max_fog_opacity = 0.544176;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


		
		VisionSetNaked( "pow_endfight", 2 );


		
}

copter_exit_settings()
{
  start_dist = 509.62;
	half_dist = 2528.24;
	half_height = 555.778;
	base_height = 550.76;
	fog_r = 0.172549;
	fog_g = 0.207843;
	fog_b = 0.258824;
	fog_scale = 9.99111;
	sun_col_r = 1;
	sun_col_g = 0.968628;
	sun_col_b = 0.847059;
	sun_dir_x = 0.295884;
	sun_dir_y = 0.820734;
	sun_dir_z = 0.488722;
	sun_start_ang = 0;
	sun_stop_ang = 61.91;
	time = 4;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
		VisionSetNaked( "pow_landing", 3 );

}