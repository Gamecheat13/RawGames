//_createart generated.  modify at your own risk. Changing values should be fine.
//
// This is the visionset and fog that loads with the level, Its the one that starts off
// with the player inside the tent


////////////////////////////////OPENING OF THE LEVEL INSIDE THE TENT/////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;

main()
{
 
	start_dist = 128;
	half_dist = 100;
	half_height = 147.5488;
	base_height = 0;
	fog_r = 0.992157;
	fog_g = 0.992157;
	fog_b = 0.992157;
	fog_scale = 5.83831;
	sun_col_r = 0.654902;
	sun_col_g = 0.356863;
	sun_col_b = 0.152941;
	sun_dir_x = 0.334993;
	sun_dir_y = 0.0689761;
	sun_dir_z = -0.939693;
	sun_start_ang = 70.8303;
	sun_stop_ang = 135.207;
	time = 0;
	max_fog_opacity = 0.854167;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked( "khe_sanh", 0 );
	///////////New Hero Lighting///////////////
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.25 );
	SetSavedDvar( "r_lightGridContrast", .15 );


// SUN SETTINGS  /////////////////////////////////////////////////////////////////////////////////////////////

	//Starting Sun Direction for level

	//player = GetPlayers()[0];
	//player SetClientDvar( "r_lightTweakSunDirection", (-11.0247, -7.24, 0));  

// SKY TEMPERATURE //////////////////////////////////////////////////////////////////////////////////////////
	player = GetPlayers()[0];
	SetSavedDvar( "r_skyColorTemp", (7500));  
		
/// SHADOW DISTANCE //////////////////////////////////////////////////////////////////////////////////////////
	SetSavedDvar( "sm_sunSampleSizeNear", "0.5" );
	

// THREAD SPINOFF ///////////////////////////////////////////////////////////////////////////////////////////
	// Spin off vision update threads
//	level thread event1a_flash_update_vision();
	level thread event1_dof();
	level thread event1b_update_vision();
	level thread event1c_update_vision();
	level thread event1d_update_vision();
	level thread event1e_update_vision();
	level thread event2_update_vision();
	level thread event2_bunker_update_vision();
	level thread event3_update_vision();
	level thread event3b_update_vision();
	level thread event3b2_update_vision();
	level thread event3c_update_vision();
	level thread event3d_update_vision();
	level thread event4_update_vision();
	level thread event4b_update_vision();
	level thread event4c_update_vision();
	level thread event5_update_vision();
	level thread event6_update_vision();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//set sun direction when exiting tent	
	// Leaving this here so the syntax can be referenced again easily...
	//SetSavedDvar ( "r_lightTweakSunDirection", (-28, 205.317, 0));  	
}

//set to cheaper sun after epic helicopter read which needs more expensive sun
set_level_sun_default()
{
	SetSavedDvar( "sm_sunSampleSizeNear", "0.25" );
}

// DEPTH OF FIELD SECTION 
event1_dof()
{	
	
	flag_wait("starting final intro screen fadeout");
	player = GetPlayers()[0];	
	
	// Player in Tent
	near_start = 0;
	near_end = 32;
	far_start = 200;
	far_end = 2000;
	near_blur = 4;
	far_blur = 0.5;
	
	player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);
	
	// Player exit tent DOF
	flag_wait("e1_player_exit_tent");
	
	//	level thread maps\khe_sanh_util::show_time(0.05);
	
	// Player sees Woods out of Copter
	near_start = 0;
	near_end = 60;
	far_start = 98.6;
	far_end = 1853;
	near_blur = 4;
	far_blur = 0.25;
	
	player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);

	wait(10);

	// Woods stands next to Hudson
	near_start = 0;
	near_end = 10.2;
	far_start = 117.85;
	far_end = 1841.91;
	near_blur = 5.1;
	far_blur = 0.5;
	
	player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);
	
	wait(36);

	// Player in jeep while Woods talks to us
	near_start = 0;
	near_end = 30;
	far_start = 558;
	far_end = 2575;
	near_blur = 4;
	far_blur = 0.5;
	
	player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);

	// Crash DOF
	// notify happens when player is looking at woods in the helicopter
	level waittill("set_crash_dof");
	
	// *Depth of Field section*
	near_start = 0;
	near_end = 40;
	far_start = 341;
	far_end = 2345;
	near_blur = 4;
	far_blur = 0;
	
	player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);

	//level.player SetDepthOfField( 10, 60, 341, 2345, 6, 2.16 );
	//level.player SetDepthOfField( 62.51, 85.8, 173.27, 198.9, 5.43, 9.43 );

	// Not sure how to turn off the DOF...right now we are just waiting and setting back to some
	// default values. There is no script function for turning off dof. I only found examples of 
	// setting back to defaults

	wait(8);
		
	set_default_dof(player);
	
	
//	trigger = GetEnt("trig_set_sundir_exit_tent", "script_noteworthy");
//	trigger waittill("trigger");
// 
//	trigger_wait("value", "key");
}

set_default_dof(player)
{
	near_start = 0;
	near_end = 1;
	far_start = 8000;
	far_end = 10000;
	near_blur = 6;
	far_blur = 0;
	
	player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);		
}

// FOG AND VISION TRIGGER EVENTS

// maps/createart/khe_sanh_art.gsc::attacking_vietnamese_dof();
//self is player
attacking_vietnamese_dof()
{
	// Player attacked by vietnamese beginning of event 3
	near_start = 0;
	near_end = 25;
	far_start = 558;
	far_end = 2575;
	near_blur = 4;
	far_blur = 0.5;
	
	self SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);
}

woods_jam_dof()
{
	// Player attacked by vietnamese beginning of event 3
	near_start = 0;
	near_end = 220;
	far_start = 365;
	far_end = 530;
	near_blur = 4;
	far_blur = 1.0;

	self SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);
}

event1b_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e1b_set_fog_vision_exit_tent", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event1b_vision_settings();
}

event1c_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e1b_set_fog_vision_exit_tent_2", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event1c_vision_settings();
}

event1d_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e1b_set_fog_vision_exit_tent_3", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event1d_vision_settings();
}

event1e_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e1b_set_fog_vision_exit_tent_4", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event1e_vision_settings();
}

event2_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e2_trenchbattle_script", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event2_vision_settings();
}

event2_bunker_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e2_trenchbattle_bunker_script", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event2_bunker_vision_settings();
}

event3_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e3_trenchdefense_script", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event3_vision_settings();
}

event3b_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e3_trenchdefense_script_1b", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event3b_vision_settings();
}

event3b2_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e3_trenchdefense_script_1b2", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event3b2_vision_settings();
}

event3c_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e3_trenchdefense_script_2", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event3c_vision_settings();
}

event3d_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e3_trenchdefense_script_3", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event3d_vision_settings();
}

event4_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e4_hillbattle_script", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event4_vision_settings();
}

event4b_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e4_hillbattle_script_2", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event4b_vision_settings();
}

event4c_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e4_hillbattle_script_3", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event4c_vision_settings();
}



event5_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e5_airfieldbattle_script", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event5_vision_settings();
}

event6_update_vision()
{
	self endon("death");

	trig = GetEnt("khe_sanh_e6_siegeofkhesanh_script", "script_noteworthy");
	trig waittill("trigger");

	// update vision settings
	event6_vision_settings();
}

///EVENT 1 
//EXITING THE TENT 
//ACB used for jumpto only (this is is after the tent intro a.k.a. "tent 1_flash")
//
// This is the visionset that Event 1, from the time we meet Woods to the jeep ride sequence. It transitions from
// the opening tent visionset and timed to match the glow fading into the look for the level. The only difference 
// between this target and the next three i fog adjustment so that when we drive past the helicopter, 
// it temporarily fills up then goes down again. This trigger is located just outside the tent.

event1b_vision_settings()
{

	// *Fog section* 
	start_dist = 512;
	half_dist = 602;
	half_height = 570;
	base_height = -1024;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 1;
	sun_col_g = 0.592157;
	sun_col_b = 0.298039;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 0;
	sun_stop_ang = 79.9103;
	//time = 0.5;
	time = 3;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


	//VisionSetNaked("khe_sanh_e1_intro", 0.5);
	VisionSetNaked("khe_sanh_e1_intro", 3);	
	
  SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1 );
	SetSavedDvar( "r_lightGridContrast", -0.25 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);

}

// The heavy fog, after we exit the tent, slowly clears (5 seconds) to reveal more of the vista as we get in the jeep and drive with woods through the
// camp. Located just next to the jeep. Notice the time for this is 5 seconds so the toning down of the fog seems natural.
// khe_sanh_e1b_set_fog_vision_Jeep_sequence 2

event1c_vision_settings()
{

start_dist = 105.87;
	half_dist = 1455.29;
	half_height = 756.153;
	base_height = -3.86499;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 1;
	sun_col_g = 0.592157;
	sun_col_b = 0.298039;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 0;
	sun_stop_ang = 79.9103;
	time = 10;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	

	VisionSetNaked("khe_sanh_e1_intro", 0);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", .0 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
}

//////// COPTER PASSING BY 
// This trigger is somwhere just before the helicopter as we are in teh jeep ride sequence with Woods. It raises the fog for 2 seconds, makes it dense.
// khe_sanh_e1b_set_fog_vision_Jeep_Sequence 3

event1d_vision_settings()
{

start_dist = 105.87;
	half_dist = 1455.29;
	half_height = 756.153;
	base_height = -3.86499;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 1;
	sun_col_g = 0.592157;
	sun_col_b = 0.298039;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 0;
	sun_stop_ang = 79.9103;
	time = 0;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
	VisionSetNaked("khe_sanh_e1_intro", 0);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", .0 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
}

//This trigger (5 seconds) slowly fades the fog to a version that is pushed all the way back far into the vista so we can see alot of the plane
//explosion during thie plane exposion sequence. This one is located just after the helicopter.
// khe_sanh_e1b_set_fog_Jeep Sequence 4
event1e_vision_settings()
{

	// *Fog section* 
	start_dist = 850;
	half_dist = 7957;
	half_height = 2656;
	base_height = 170;
	fog_r = 0.819608;
	fog_g = 0.921569;
	fog_b = 0.960784;
	fog_scale = 3.78;
	sun_col_r = 1;
	sun_col_g = 0.57;
	sun_col_b = 0.32;
	sun_dir_x = 0;
	sun_dir_y = 0;
	sun_dir_z = -1;
	sun_start_ang = 80;
	sun_stop_ang = 102;
	time = 5;
	max_fog_opacity = 0.9;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	

VisionSetNaked("khe_sanh_e1_intro", 0);

	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", .0 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
	
}
////////////////////////////////////////////////////////////// ///EVENT 2 ///////////////////////////////////
//ACB used for jumpto only ////////////////////////////////////TRENCHBATTLE//////////////////////////////////
// This trigger is the first use of E2 visionset. It is located at the head of the first trench after teh jeep expolosion when Woods tells
// you to carry Hudson across during the attack. 
event2_vision_settings()
{

		start_dist = 512;
      half_dist = 1124;
      half_height = 418.058;
      base_height = 0;
      fog_r = 0.819608;
      fog_g = 0.921569;
      fog_b = 0.960784;
      fog_scale = 3.78;
      sun_col_r = 1;
      sun_col_g = 0.635294;
      sun_col_b = 0.384314;
      sun_dir_x = 0;
      sun_dir_y = 0;
      sun_dir_z = -1;
      sun_start_ang = 86.6712;
      sun_stop_ang = 126.271;
      time = 10;
      max_fog_opacity = 0.8;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked("khe_sanh_e2_trenchbattle", 5);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", 0.2 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
	SetSavedDvar( "r_skyColorTemp", (7000));  
	
}
// This triggerst the visionset for the bunker interioir located just ouside the bunker, perpenticular to the entrances wooden pillars
// with a 5 second transitions so that if you wanted to hae dramatic contrast from the last one, it appears slowly and naturally. Although,
// the explosions during this sequence hides the transition well so you may not even have to worry about the timing as much.
event2_bunker_vision_settings()
{

	start_dist = 287.102;
	half_dist = 747.573;
	half_height = 398.212;
	base_height = -77.2579;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 1;
	sun_col_g = 0.592157;
	sun_col_b = 0.298039;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 0;
	sun_stop_ang = 79.9103;
	time = 3;
	max_fog_opacity = 0.854167;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	

	VisionSetNaked("khe_sanh_e2_trenchbattle_bunker", 3);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.5 );
	SetSavedDvar( "r_lightGridContrast", .35 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
	SetSavedDvar( "r_skyColorTemp", (7000));  

	
}

///////////////////////////////////////////////////////////////////EVENT 3 //////////////////////////////////
//ACB used for jumpto only  /////////////////////////////////////  TRENCHDEFENSE/////////////////////////////
// This one loads as you exit the first bunker, located just outside of it. First time the new E3 Visionset loads.

event3_vision_settings() //// just as youre exiting the bunker
{

		// *Fog section* 
	start_dist = 370;
	half_dist = 841.999;
	half_height = 446;
	base_height = 128;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 1;
	sun_col_g = 0.592157;
	sun_col_b = 0.298039;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 0;
	sun_stop_ang = 79.9103;
	time = 3;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
		
	VisionSetNaked("khe_sanh_e3_trenchdefense", 5);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.15 );
	SetSavedDvar( "r_lightGridContrast", .0 );
	
	//deep orange dust filtered sun
	SetSunLight(0.992, 0.7634, 0.49);
	SetSavedDvar( "r_skyColorTemp", (8500));  

}

//ACB used for jumpto /////////////////big read over the hill top
// this one is just a couple feet in front of the last one, its fog thickens for 2 seconds so that you have a good setting for the hill top read
// this one gives you the fog for the big reveal in essence.
event3b_vision_settings()
{

	start_dist = 834.492;
	half_dist = 157.811;
	half_height = 535.71;
	base_height = 177.831;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 1;
	sun_col_g = 0.592157;
	sun_col_b = 0.298039;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 0;
	//sun_stop_ang = 56.2103;   too wide
	sun_stop_ang = 46.2103;
	time = 3;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked("khe_sanh_e3_trenchdefense", 0);
	
  SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.15 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
	
	//deep orange dust filtered sun
	SetSunLight(0.992, 0.7634, 0.49);
	SetSavedDvar( "r_skyColorTemp", (8500));

}

//ACB used for jumpto only //////////////under the little bridge for the trenchbattle
// This one sets the fog down to the setting youll want for the remainder of the trench gameplay, 
// it comes into place after you pass its location just under the little bridge. 
event3b2_vision_settings()
{

		start_dist = 168;
	half_dist = 950.656;
	half_height = 661.605;
	base_height = 180.218;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 1;
	sun_col_g = 0.592157;
	sun_col_b = 0.298039;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 0;
	sun_stop_ang = 37.0068;
	time = 5;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);



	VisionSetNaked("khe_sanh_e3_trenchdefense", 0);
	
  SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.15 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
	
	//deep orange dust filtered sun
	SetSunLight(0.992, 0.7634, 0.49);
	SetSavedDvar( "r_skyColorTemp", (8500));

}

//ACB used for jumpto only ////////mid-point of the trench battle
// Since the levels overall scale seemed to change, and the fog settings up to this point was not as dramatic as it could be,
// I added this one as an extra option. You can easily copy+paste the settings for fog above and get a consistent
// value until the end of the level.
event3c_vision_settings()
{

		start_dist = 479.436;
	half_dist = 1253.33;
	half_height = 356.517;
	base_height = 364.595;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 0.278431;
	sun_col_g = 0.352941;
	sun_col_b = 0.431373;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 5;
	sun_stop_ang = 28;
	time = 10;
	max_fog_opacity = 0.928614;


	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


	VisionSetNaked("khe_sanh_e3_trenchdefense", 0);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.15 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
	
	//deep orange dust filtered sun
	SetSunLight(0.992, 0.7634, 0.49);
	SetSavedDvar( "r_skyColorTemp", (8000));


}
// The last trigger for E3, its located over the hole that goes underground for event 4. The fog
//was toned down so when you entered this area it would be appropraite for interiors. It can use the same
//settings as the one before or be given its own. The flexibility is there.
//ACB used for jumpto only 

event3d_vision_settings()
{

		start_dist = 128;
	half_dist = 2660;
	half_height = 1349.76;
	base_height = 128;
	fog_r = 0.533333;
	fog_g = 0.282353;
	fog_b = 0.113725;
	fog_scale = 7.02838;
	sun_col_r = 0.28;
	sun_col_g = 0.352;
	sun_col_b = 0.431;
	sun_dir_x = -0.780608;
	sun_dir_y = -0.397819;
	sun_dir_z = 0.482069;
	sun_start_ang = 5;
	sun_stop_ang = 110;
	time = 5;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


	VisionSetNaked("khe_sanh_e3_trenchdefense", 2);	
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.25 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
	SetSavedDvar( "r_skyColorTemp", (8500));


}


//////////////////////////////////////////////////////////////////////////////EVENT 4 ///////////////////////
//ACB used for jumpto only  //////////////////////////////////////////////  HILLBATTLE //////////////////////
event4_vision_settings()
{
	start_dist = 56.3533;
	half_dist = 630.176;
	half_height = 432.032;
	base_height = -969.977;
	fog_r = 0.318;
	fog_g = 0.384314;
	fog_b = 0.403922;
	fog_scale = 5;
	sun_col_r = 0.968;
	sun_col_g = 0.698;
	sun_col_b = 0.482;
	sun_dir_x = -0.789495;
	sun_dir_y = -0.383851;
	sun_dir_z = 0.478912;
	sun_start_ang = 0;
	sun_stop_ang = 53.3014;
	time = 2;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);



	VisionSetNaked("khe_sanh_e4_hillbattle", 5);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.25 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
	SetSavedDvar( "r_skyColorTemp", (6500));  

}
	
event4b_vision_settings()
{

	start_dist = 126.59;
	half_dist = 366.796;
	half_height = 495.022;
	base_height = -766.087;
	fog_r = 0.318;
	fog_g = 0.384314;
	fog_b = 0.403922;
	fog_scale = 2.7;
	sun_col_r = 0.968;
	sun_col_g = 0.698;
	sun_col_b = 0.482;
	sun_dir_x = -0.789495;
	sun_dir_y = -0.383851;
	sun_dir_z = 0.478912;
	sun_start_ang = 0;
	sun_stop_ang = 63.3475;
	time = 5;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked("khe_sanh_e4_hillbattle2", 10);
	
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.25 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
	SetSavedDvar( "r_skyColorTemp", (6500));  

}

event4c_vision_settings()
{

	start_dist = 138.59;
	half_dist = 446.796;
	half_height = 343.122;
	base_height = -7.40508;
	fog_r = 0.318;
	fog_g = 0.384314;
	fog_b = 0.403922;
	fog_scale = 5;
	sun_col_r = 1;
	sun_col_g = 0.94;
	sun_col_b = 0.81;
	sun_dir_x = -0.789495;
	sun_dir_y = -0.383851;
	sun_dir_z = 0.478912;
	sun_start_ang = 0;
	sun_stop_ang = 63.3475;
	time = 5;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);

	VisionSetNaked("khe_sanh_e4_hillbattle3", 5);

	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.25 );
	SetSavedDvar( "r_lightGridContrast", 0.0 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
	SetSavedDvar( "r_skyColorTemp", (6500));  

}

/////////////////////////////////////////////////////////////////////////////EVENT 5 ////////////////////////
//ACB used for jumpto only   /////////////////////////////////////////////// AIRFIELD BATTLE ////////////////
event5_vision_settings()
{

	// *Fog section* 
	start_dist = 106.784;
	half_dist = 1935.61;
	half_height = 354.612;
	base_height = 21.2706;
	fog_r = 0.333;
	fog_g = 0.423;
	fog_b = 0.443;
	fog_scale = 5.30055;
	sun_col_r = 1;
	sun_col_g = 0.8;
	sun_col_b = 0.55;
	sun_dir_x = -0.789495;
	sun_dir_y = -0.383851;
	sun_dir_z = 0.478912;
	sun_start_ang = 0;
	sun_stop_ang = 63.3475;
	time = 5;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);


	VisionSetNaked("khe_sanh_e5_airfieldbattle", 5);

	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.2 );
	SetSavedDvar( "r_lightGridContrast", .1 );
	
	//warm dust filtered sun
	SetSunLight(0.992, 0.88, 0.65);
	SetSavedDvar( "r_skyColorTemp", (6500));  

}

/////////////////////////////////////////////////////////////////////////////////EVENT 6/////////////////////
//ACB used for jumpto only ///////////////////////////////////////////////////////  SEIGE  //////////////////
event6_vision_settings()
{

	// *Fog section* 
	start_dist = 106.784;
	half_dist = 1935.61;
	half_height = 354.612;
	base_height = 21.2706;
	fog_r = 0.294118;
	fog_g = 0.384314;
	fog_b = 0.403922;
	fog_scale = 5.30055;
	sun_col_r = 1;
	sun_col_g = 0.8;
	sun_col_b = 0.55;
	sun_dir_x = -0.789495;
	sun_dir_y = -0.383851;
	sun_dir_z = 0.478912;
	sun_start_ang = 0;
	sun_stop_ang = 63.3475;
	time = 5;
	max_fog_opacity = 1;

	setVolFog(start_dist, half_dist, half_height, base_height, fog_r, fog_g, fog_b, fog_scale,
		sun_col_r, sun_col_g, sun_col_b, sun_dir_x, sun_dir_y, sun_dir_z, sun_start_ang, 
		sun_stop_ang, time, max_fog_opacity);
	

	VisionSetNaked("khe_sanh_e6_siegeofkhesanh", 1);
}
////////// DEPTH OF FIELD FOR PLANE CRASH ///////////////////////////////////////////////////////////////////
set_crash_dof()
{
	// notify happens when player is looking at woods in the helicopter
	level waittill("set_crash_dof");
	
	// *Depth of Field section*
	near_start = 4.13;
	near_end = 304.7;
	far_start = 1190;
	far_end = 41909;
	near_blur = 4.8;
	far_blur = 0.25;
	
	level.player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);

	//level.player SetDepthOfField( 10, 60, 341, 2345, 6, 2.16 );
	//level.player SetDepthOfField( 62.51, 85.8, 173.27, 198.9, 5.43, 9.43 );

	// Not sure how to turn off the DOF...right now we are just waiting and setting back to some
	// default values. There is no script function for turning off dof. I only found examples of 
	// setting back to defaults

	wait(8);
	near_start = 0;
	near_end = 1;
	far_start = 8000;
	far_end = 10000;
	near_blur = 6;
	far_blur = 0;
	
	level.player SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);	


	//level.player SetDepthOfField(0, 1, 8000, 10000, 6, 0);
	//SetDepthOfField( <near start>, <near end>, <far start>, <far end>, <near blur>, <far blur> )
}



