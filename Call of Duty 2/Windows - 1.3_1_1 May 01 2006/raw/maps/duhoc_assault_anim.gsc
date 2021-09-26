main()
{	
	dialogue();
	higgins_animations();
	higgins_animations_driver();
	higgins_animations_boat();
	higgins_animations_rope();
	mainCharacter_Animations_Randall();
	mainCharacter_Animations_Braeburn();
	mainCharacter_Animations_Wells();
	mainCharacter_Animations_McCloskey();
	mainCharacter_Animations_Coffey();
	mainCharacter_Animations_Coxswain();
	cliffclimbers_animations_climb();
	player_animations();
	higgins_dronerig_animations();
	higgins_drone_animations();
	AI_animations();
	wounded_animations();
	radioman_animations();
	ropefall_animations();
	flakpanzer_animations();
}

#using_animtree("duhoc_higginsriders");
higgins_animations()
{
	level.scr_animtree["higginsriders"] = #animtree;
	
	// Idle, stand up/down, and special animations for guys riding in the higgins boat with you
	//(not character specific guys)	
	
	level.scr_anim["tag_randall"]["idle"][0]		= %higginsboat_ranger1_idle;
	level.scr_anim["tag_randall"]["idle"][1]		= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_randall"]["idle"][2]		= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_randall"]["idle"][3]		= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_randall"]["idle"][4]		= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_randall"]["idle"][5]		= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_randall"]["duck_down"]		= %higginsboat_ranger1_duckdown_down;
	level.scr_anim["tag_randall"]["duck_idle"][0]	= %higginsboat_ranger1_duckdown_idle;
	level.scr_anim["tag_randall"]["duck_up"]		= %higginsboat_ranger1_duckdown_up;
	/*
	level.scr_anim["tag_medic"]["idle"][0]			= %higginsboat_medic_idle;
	level.scr_anim["tag_medic"]["idle"][1]			= %higginsboat_medic_lookingaroundLt;
	level.scr_anim["tag_medic"]["idle"][2]			= %higginsboat_medic_lookingaroundRt;
	level.scr_anim["tag_medic"]["duck_down"]		= %higginsboat_medic_duckdown_down;
	level.scr_anim["tag_medic"]["duck_idle"][0]		= %higginsboat_medic_duckdown_idle;
	level.scr_anim["tag_medic"]["duck_up"]			= %higginsboat_medic_duckdown_up;
	*/
	level.scr_anim["tag_braeburn"]["idle"][0]		= %higginsboat_rangerL_idle;
	level.scr_anim["tag_braeburn"]["idle"][1]		= %higginsboat_rangerL_lookback;
	level.scr_anim["tag_braeburn"]["duck_down"]		= %higginsboat_rangerL_duckdown;
	level.scr_anim["tag_braeburn"]["duck_idle"][0]	= %higginsboat_rangerL_duckidle;
	level.scr_anim["tag_braeburn"]["duck_up"]		= %higginsboat_rangerL_duckup;
	
	level.scr_anim["tag_mccloskey"]["idle"][0]		= %higginsboat_ranger1_idle;
	level.scr_anim["tag_mccloskey"]["idle"][1]		= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_mccloskey"]["idle"][2]		= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_mccloskey"]["idle"][3]		= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_mccloskey"]["idle"][4]		= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_mccloskey"]["idle"][5]		= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_mccloskey"]["duck_down"]	= %higginsboat_ranger1_headdown_down;
	level.scr_anim["tag_mccloskey"]["duck_idle"][0]	= %higginsboat_ranger1_headdown_idle;
	level.scr_anim["tag_mccloskey"]["duck_up"]		= %higginsboat_ranger1_headdown_up;
	
	level.scr_anim["tag_coffey"]["idle"][0]			= %higginsboat_rangerL_idle;
	level.scr_anim["tag_coffey"]["idle"][1]			= %higginsboat_rangerL_lookback;
	level.scr_anim["tag_coffey"]["duck_down"]		= %higginsboat_rangerL_duckdown;
	level.scr_anim["tag_coffey"]["duck_idle"][0]	= %higginsboat_rangerL_duckidle;
	level.scr_anim["tag_coffey"]["duck_up"]			= %higginsboat_rangerL_duckup;
	
	level.scr_anim["tag_guy1"]["idle"][0]			= %higginsboat_rangerR_idle;
	level.scr_anim["tag_guy1"]["idle"][1]			= %higginsboat_rangerR_lookback;
	level.scr_anim["tag_guy1"]["duck_down"]			= %higginsboat_rangerR_duckdown;
	level.scr_anim["tag_guy1"]["duck_idle"][0]		= %higginsboat_rangerR_duckidle;
	level.scr_anim["tag_guy1"]["duck_up"]			= %higginsboat_rangerR_duckup;
	
	level.scr_anim["tag_guy2"]["idle"][0]			= %higginsboat_rangerR_idle;
	level.scr_anim["tag_guy2"]["idle"][1]			= %higginsboat_rangerR_lookback;
	level.scr_anim["tag_guy2"]["duck_down"]			= %higginsboat_rangerR_duckdown;
	level.scr_anim["tag_guy2"]["duck_idle"][0]		= %higginsboat_rangerR_duckidle;
	level.scr_anim["tag_guy2"]["duck_up"]			= %higginsboat_rangerR_duckup;
	
	level.scr_anim["tag_guy3"]["idle"][0]			= %higginsboat_ranger1_idle;
	level.scr_anim["tag_guy3"]["idle"][1]			= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_guy3"]["idle"][2]			= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_guy3"]["idle"][3]			= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_guy3"]["idle"][4]			= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_guy3"]["idle"][5]			= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_guy3"]["prey"]				= %higginsboat_ranger1_praying;
	level.scr_anim["tag_guy3"]["duck_down"]			= %higginsboat_ranger1_duckdown_down;
	level.scr_anim["tag_guy3"]["duck_idle"][0]		= %higginsboat_ranger1_duckdown_idle;
	level.scr_anim["tag_guy3"]["duck_up"]			= %higginsboat_ranger1_duckdown_up;
	
	level.scr_anim["tag_guy4"]["idle"][0]			= %higginsboat_rangerL_idle;
	level.scr_anim["tag_guy4"]["idle"][1]			= %higginsboat_rangerL_lookback;
	level.scr_anim["tag_guy4"]["duck_down"]			= %higginsboat_rangerL_duckdown;
	level.scr_anim["tag_guy4"]["duck_idle"][0]		= %higginsboat_rangerL_duckidle;
	level.scr_anim["tag_guy4"]["duck_up"]			= %higginsboat_rangerL_duckup;
	
	level.scr_anim["tag_guy5"]["idle"][0]			= %higginsboat_ranger1_idle;
	level.scr_anim["tag_guy5"]["idle"][1]			= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_guy5"]["idle"][2]			= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_guy5"]["idle"][3]			= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_guy5"]["idle"][4]			= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_guy5"]["idle"][5]			= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_guy5"]["duck_down"]			= %higginsboat_ranger1_headdown_down;
	level.scr_anim["tag_guy5"]["duck_idle"][0]		= %higginsboat_ranger1_headdown_idle;
	level.scr_anim["tag_guy5"]["duck_up"]			= %higginsboat_ranger1_headdown_up;
	
	level.scr_anim["tag_guy6"]["idle"][0]			= %higginsboat_rangerR_idle;
	level.scr_anim["tag_guy6"]["idle"][1]			= %higginsboat_rangerR_lookback;
	level.scr_anim["tag_guy6"]["duck_down"]			= %higginsboat_rangerR_duckdown;
	level.scr_anim["tag_guy6"]["duck_idle"][0]		= %higginsboat_rangerR_duckidle;
	level.scr_anim["tag_guy6"]["duck_up"]			= %higginsboat_rangerR_duckup;
	
	level.scr_anim["tag_guy7"]["idle"][0]			= %higginsboat_rangerR_idle;
	level.scr_anim["tag_guy7"]["idle"][1]			= %higginsboat_rangerR_lookback;
	level.scr_anim["tag_guy7"]["duck_down"]			= %higginsboat_rangerR_duckdown;
	level.scr_anim["tag_guy7"]["duck_idle"][0]		= %higginsboat_rangerR_duckidle;
	level.scr_anim["tag_guy7"]["duck_up"]			= %higginsboat_rangerR_duckup;
	
	level.scr_anim["tag_guy8"]["idle"][0]			= %higginsboat_ranger1_idle;
	level.scr_anim["tag_guy8"]["idle"][1]			= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_guy8"]["idle"][2]			= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_guy8"]["idle"][3]			= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_guy8"]["idle"][4]			= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_guy8"]["idle"][5]			= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_guy8"]["duck_down"]			= %higginsboat_ranger1_headdown_down;
	level.scr_anim["tag_guy8"]["duck_idle"][0]		= %higginsboat_ranger1_headdown_idle;
	level.scr_anim["tag_guy8"]["duck_up"]			= %higginsboat_ranger1_headdown_up;
	
	level.scr_anim["tag_guy9"]["idle"][0]			= %higginsboat_ranger1_idle;
	level.scr_anim["tag_guy9"]["idle"][1]			= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_guy9"]["idle"][2]			= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_guy9"]["idle"][3]			= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_guy9"]["idle"][4]			= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_guy9"]["idle"][5]			= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_guy9"]["duck_down"]			= %higginsboat_ranger1_duckdown_down;
	level.scr_anim["tag_guy9"]["duck_idle"][0]		= %higginsboat_ranger1_duckdown_idle;
	level.scr_anim["tag_guy9"]["duck_up"]			= %higginsboat_ranger1_duckdown_up;
	
	level.scr_anim["tag_guy10"]["idle"][0]			= %higginsboat_ranger1_idle;
	level.scr_anim["tag_guy10"]["idle"][1]			= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_guy10"]["idle"][2]			= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_guy10"]["idle"][3]			= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_guy10"]["idle"][4]			= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_guy10"]["idle"][5]			= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_guy10"]["duck_down"]		= %higginsboat_ranger1_headdown_down;
	level.scr_anim["tag_guy10"]["duck_idle"][0]		= %higginsboat_ranger1_headdown_idle;
	level.scr_anim["tag_guy10"]["duck_up"]			= %higginsboat_ranger1_headdown_up;
	
	level.scr_anim["tag_guy11"]["idle"][0]			= %higginsboat_ranger1_idle;
	level.scr_anim["tag_guy11"]["idle"][1]			= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_guy11"]["idle"][2]			= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_guy11"]["idle"][3]			= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_guy11"]["idle"][4]			= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_guy11"]["idle"][5]			= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_guy11"]["duck_down"]		= %higginsboat_ranger1_headdown_down;
	level.scr_anim["tag_guy11"]["duck_idle"][0]		= %higginsboat_ranger1_headdown_idle;
	level.scr_anim["tag_guy11"]["duck_up"]			= %higginsboat_ranger1_headdown_up;
	
	level.scr_anim["tag_guy12"]["idle"][0]			= %higginsboat_rangerR_idle;
	level.scr_anim["tag_guy12"]["idle"][1]			= %higginsboat_rangerR_lookback;
	level.scr_anim["tag_guy12"]["duck_down"]		= %higginsboat_rangerR_duckdown;
	level.scr_anim["tag_guy12"]["duck_idle"][0]		= %higginsboat_rangerR_duckidle;
	level.scr_anim["tag_guy12"]["duck_up"]			= %higginsboat_rangerR_duckup;
	
	level.scr_anim["tag_guy13"]["idle"][0]			= %higginsboat_ranger1_idle;
	level.scr_anim["tag_guy13"]["idle"][1]			= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["tag_guy13"]["idle"][2]			= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["tag_guy13"]["idle"][3]			= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["tag_guy13"]["idle"][4]			= %higginsboat_ranger1_turnleft;
	level.scr_anim["tag_guy13"]["idle"][5]			= %higginsboat_ranger1_turnright;
	level.scr_anim["tag_guy13"]["duck_down"]		= %higginsboat_ranger1_headdown_down;
	level.scr_anim["tag_guy13"]["duck_idle"][0]		= %higginsboat_ranger1_headdown_idle;
	level.scr_anim["tag_guy13"]["duck_up"]			= %higginsboat_ranger1_headdown_up;
	
	level.scr_anim["tag_guy9"]["shot"]				= %higginsboat_1stguyshot;
	level.scr_anim["tag_randall"]["shot"]			= %higginsboat_3rdguyshot;
	level.scr_anim["tag_guy8"]["shot"]				= %higginsboat_2ndguyshot;
}

#using_animtree("duhoc_higginsdriver");
higgins_animations_driver()
{
	level.scr_animtree["higginsdriver"] = #animtree;
	
	//higgins driver animations
	level.scr_anim["higgins_driver"]["idle"][0]		= %higginsboat_driver_idle;
	level.scr_anim["higgins_driver"]["idle"][1]		= %higginsboat_driver_lookleft;
	level.scr_anim["higgins_driver"]["idle"][2]		= %higginsboat_driver_lookright;
	
	level.scr_anim["tag_driver"]["idle"][0]			= %higginsboat_driver_idle;
	level.scr_anim["tag_driver"]["idle"][1]			= %higginsboat_driver_lookleft;
	level.scr_anim["tag_driver"]["idle"][2]			= %higginsboat_driver_lookright;
	
	level.scr_anim["tag_driver"]["duck_down"]		= %higginsboat_driver_duckdown;
	level.scr_anim["tag_driver"]["duck_idle"][0]	= %higginsboat_driver_duckdown_idle;
	level.scr_anim["tag_driver"]["duck_cover"]		= %higginsboat_driver_duckdown_cover;
}

#using_animtree("duhoc_boat");
higgins_animations_boat()
{
	level.scr_animtree["boat"] = #animtree;
	
	//animations for the boat itself
	level.scr_anim["higginsboat"]["dooropen"]		= %higginsboat_door_open;
	level.scr_anim["higginsboat"]["doorclose"]		= %higginsboat_door_close;
	
	level.scr_anim["higginsboat"]["sway"][0]		= %higginsboat_cycle1;
	level.scr_anim["higginsboat"]["sway"][1]		= %higginsboat_cycle2;
	level.scr_anim["higginsboat"]["sway"][2]		= %higginsboat_cycle3;
}

#using_animtree("duhoc_rope");
higgins_animations_rope()
{
	level.scr_animtree["rope"] = #animtree;
	
	level.scr_anim["rope"]["launch"]["player"]		= %duhoc_rope_mortar_launch_player_ri;
	level.scr_anim["rope"]["launch"]["1"]			= %duhoc_rope_mortar_launch_01_le;
	level.scr_anim["rope"]["launch"]["2"]			= %duhoc_rope_mortar_launch_02_le;
	level.scr_anim["rope"]["launch"]["3"]			= %duhoc_rope_mortar_launch_03_ri;
	level.scr_anim["rope"]["launch"]["4"]			= %duhoc_rope_mortar_launch_04_le;
	level.scr_anim["rope"]["launch"]["5"]			= %duhoc_rope_mortar_launch_05_le;
	level.scr_anim["rope"]["launch"]["6"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["7"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["8"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["9"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["10"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["11"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["12"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["13"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["14"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["15"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["16"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["17"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["18"]			= %duhoc_rope_mortar_launch_miss1_le;
	level.scr_anim["rope"]["launch"]["19"]			= %duhoc_rope_mortar_launch_miss1_le;
	
	level.scr_anim["rope"]["pose"]["1"]				= %duhoc_rope_climb_cliff_pose_01;
	level.scr_anim["rope"]["pose"]["2"]				= %duhoc_rope_climb_cliff_pose_02;
	level.scr_anim["rope"]["pose"]["3"]				= %duhoc_rope_climb_cliff_pose_03;
	level.scr_anim["rope"]["pose"]["4"]				= %duhoc_rope_climb_cliff_pose_04;
	level.scr_anim["rope"]["pose"]["5"]				= %duhoc_rope_climb_cliff_pose_05;
	level.scr_anim["rope"]["pose"]["player"]		= %duhoc_rope_climb_cliff_pose_player;
	
	level.scr_anim["rope"]["climb"]["1"]			= %duhoc_rope_climb_cliff_01;
	level.scr_anim["rope"]["climb"]["2"]			= %duhoc_rope_climb_cliff_02;
	level.scr_anim["rope"]["climb"]["3"]			= %duhoc_rope_climb_cliff_03;
	level.scr_anim["rope"]["climb"]["4"]			= %duhoc_rope_climb_cliff_04;
	level.scr_anim["rope"]["climb"]["5"]			= %duhoc_rope_climb_cliff_05;
	level.scr_anim["rope"]["climb"]["player"]		= %duhoc_rope_climb_cliff_player;
	
	level.scr_anim["rope"]["cycle"]["1"]			= %duhoc_rope_climb_cliff_01_cycle;
	level.scr_anim["rope"]["cycle"]["2"]			= %duhoc_rope_climb_cliff_02_cycle;
	level.scr_anim["rope"]["cycle"]["3"]			= %duhoc_rope_climb_cliff_03_cycle;
	level.scr_anim["rope"]["cycle"]["4"]			= %duhoc_rope_climb_cliff_04_cycle;
	level.scr_anim["rope"]["cycle"]["5"]			= %duhoc_rope_climb_cliff_05_cycle;
	
	level.scr_anim["rope"]["sway"]["player"]		= %duhoc_rope_climb_cliff_player_cycle;
	
	level.scr_anim["rope"]["fall"]["5"]				= %duhoc_rope_rangerfall;
	
}

#using_animtree("duhoc_randall");
mainCharacter_Animations_Randall()
{
	level.scr_animtree["randall"] = #animtree;
	
	level.scr_anim["randall"]["idle"][0]			= %higginsboat_randall_idle;
	level.scr_anim["randall"]["firerockets"]		= %higginsboat_randall_idle;
	level.scr_anim["randall"]["duck_down"]			= %higginsboat_ranger1_headdown_down;
	level.scr_anim["randall"]["duck_idle"][0]		= %higginsboat_ranger1_headdown_idle;
	level.scr_anim["randall"]["duck_up"]			= %higginsboat_ranger1_headdown_up;
	level.scr_anim["randall"]["lean_in"]			= %higginsboat_ranger1_leanin;
	level.scr_anim["randall"]["lean_idle"][0]		= %higginsboat_ranger1_leanidle;
	level.scr_anim["randall"]["lean_out"]			= %higginsboat_ranger1_leanout;
	level.scr_anim["randall"]["shot"]				= %higginsboat_3rdguyshot;
	
	//bottom of rope
	level.scr_anim["randall"]["cliffidle"][0]		= %duhoc__cliffidle_idle;
	level.scr_anim["randall"]["cliffidle"][1]		= %duhoc__cliffidle_idle;
	level.scr_anim["randall"]["cliffidle"][2]		= %duhoc__cliffidle_idle;
	level.scr_anim["randall"]["cliffidle"][3]		= %duhoc__cliffidle_twitch1;
	level.scr_anim["randall"]["cliffidle"][4]		= %duhoc__cliffidle_twitch2;
	level.scr_anim["randall"]["getuprope"]			= %duhoc_assault_randall_getuprope;
	level.scr_anim["randall"]["getuprope2"]			= %duhoc_assault_randall_getuprope2;
	level.scr_anim["randall"]["gocorporal"]			= %duhoc_assault_randall_gocorporal;
}

#using_animtree("duhoc_braeburn");
mainCharacter_Animations_Braeburn()
{
	level.scr_animtree["braeburn"] = #animtree;
	
	level.scr_anim["braeburn"]["idle"][0]			= %higginsboat_ranger1_idle;
	level.scr_anim["braeburn"]["idle"][1]			= %higginsboat_ranger1_lookingaroundRt;
	level.scr_anim["braeburn"]["idle"][2]			= %higginsboat_ranger1_lookingaroundLt;
	level.scr_anim["braeburn"]["idle"][3]			= %higginsboat_ranger1_lookingaroundDn;
	level.scr_anim["braeburn"]["idle"][4]			= %higginsboat_ranger1_turnleft;
	level.scr_anim["braeburn"]["idle"][5]			= %higginsboat_ranger1_turnright;
	
	level.scr_anim["braeburn"]["duck_down"]			= %higginsboat_ranger1_headdown_down;
	level.scr_anim["braeburn"]["duck_idle"][0]		= %higginsboat_ranger1_headdown_idle;
	level.scr_anim["braeburn"]["duck_up"]			= %higginsboat_ranger1_headdown_up;
	
	level.scr_anim["braeburn"]["ontheboat"]			= %higginsboat_braeburn_scn7to10;
}

#using_animtree("duhoc_wells");
mainCharacter_Animations_Wells()
{
	level.scr_animtree["wells"] = #animtree;
	
	level.scr_anim["wells"]["ontheboat"]			= %higginsboat_medic_scn7to10;
	level.scr_anim["wells"]["idle"][0]				= %higginsboat_medic_idle;
	level.scr_anim["wells"]["idle"][1]				= %higginsboat_medic_lookingaroundRt;
	level.scr_anim["wells"]["idle"][2]				= %higginsboat_medic_lookingaroundLt;
	level.scr_anim["wells"]["pray"]					= %higginsboat_medic_praying;
	
	level.scr_anim["wells"]["duck_down"]			= %higginsboat_medic_duckdown_down;
	level.scr_anim["wells"]["duck_idle"][0]			= %higginsboat_medic_duckdown_idle;
	level.scr_anim["wells"]["duck_up"]				= %higginsboat_medic_duckdown_up;
}

#using_animtree("duhoc_mccloskey");
mainCharacter_Animations_McCloskey()
{
	level.scr_animtree["mccloskey"] = #animtree;
	
	level.scr_anim["mccloskey"]["idle"][0]			= %higginsboat_mccloskey_idle;
	level.scr_anim["mccloskey"]["ontheboat"]		= %higginsboat_mccloskey_scn7to10;
	
	level.scr_anim["mccloskey"]["duck_down"]		= %higginsboat_ranger1_duckdown_down;
	level.scr_anim["mccloskey"]["duck_idle"][0]		= %higginsboat_ranger1_duckdown_idle;
	level.scr_anim["mccloskey"]["duck_up"]			= %higginsboat_ranger1_duckdown_up;
}

#using_animtree("duhoc_coffey");
mainCharacter_Animations_Coffey()
{
	level.scr_animtree["coffey"] = #animtree;
	
	level.scr_anim["coffey"]["idle"][0]				= %higginsboat_coffey_idle_scn7to10;
	level.scr_anim["coffey"]["ontheboat"]			= %higginsboat_coffey_scn7to10;
	
	level.scr_anim["coffey"]["duck_down"]			= %higginsboat_ranger1_duckdown_down;
	level.scr_anim["coffey"]["duck_idle"][0]		= %higginsboat_ranger1_duckdown_idle;
	level.scr_anim["coffey"]["duck_up"]				= %higginsboat_ranger1_duckdown_up;
}

#using_animtree("duhoc_higginsdriver");
mainCharacter_Animations_Coxswain()
{
	level.scr_animtree["coxswain"] = #animtree;
	
	level.scr_anim["coxswain"]["idle"][0]			= %higginsboat_driver_idle;
	level.scr_anim["coxswain"]["idle"][1]			= %higginsboat_driver_lookleft;
	level.scr_anim["coxswain"]["idle"][2]			= %higginsboat_driver_lookright;
	level.scr_anim["coxswain"]["ontheboat"]			= %higginsboat_driver_scn7to10;
	level.scr_anim["coxswain"]["firerockets"]		= %higginsboat_driver_scn11to16;
	
	level.scr_anim["coxswain"]["duck_down"]			= %higginsboat_driver_duckdown;
	level.scr_anim["coxswain"]["duck_idle"][0]		= %higginsboat_driver_duckdown_idle;
	level.scr_anim["coxswain"]["duck_cover"]		= %higginsboat_driver_duckdown_cover;
}

#using_animtree("duhoc_cliffclimbers");
cliffclimbers_animations_climb()
{
	level.scr_animtree["cliffclimber"] = #animtree;
	level.scr_anim["cliffclimber"]["climb_cycle"][0]		= %duhoc_climber_cycle1;
	level.scr_anim["cliffclimber"]["climb_cycle"][1]		= %duhoc_climber_cycle2;
	level.scr_anim["cliffclimber"]["mount"]					= %duhoc_climber_mount_ai;
	level.scr_anim["cliffclimber"]["dismount"]				= %duhoc_climber_dismount;
	level.scr_anim["cliffclimber"]["slip"]					= %duhoc_climber_slip;
	
	//stop and idle set
	level.scr_anim["cliffclimber"]["stop_stop"]				= %duhoc_climber_stop;
	level.scr_anim["cliffclimber"]["stop_idle"][0]			= %duhoc_climber_idle;
	level.scr_anim["cliffclimber"]["stop_idle"][1]			= %duhoc_climber_idle;
	level.scr_anim["cliffclimber"]["stop_idle"][2]			= %duhoc_climber_idle;
	level.scr_anim["cliffclimber"]["stop_idle"][3]			= %duhoc_climber_wave_01;
	level.scr_anim["cliffclimber"]["stop_idle"][4]			= %duhoc_climber_wave_02;
	
	level.scr_anim["cliffclimber"]["stop_idle2"][0]			= %duhoc_climber_idle;
	
	level.scr_anim["cliffclimber_player"]["climb_cycle"][0]	= %duhoc_climber_cycle_player;
	level.scr_anim["cliffclimber_player"]["mount"]			= %duhoc_climber_mount_player;
	level.scr_anim["cliffclimber_player"]["dismount"]		= %duhoc_climber_dismount;
	level.scr_anim["cliffclimber_player"]["slip"]			= %duhoc_climber_slip_player;
	
	//stop and idle set
	level.scr_anim["cliffclimber_player"]["stop_stop"]		= %duhoc_climber_stop_player;
	level.scr_anim["cliffclimber_player"]["stop_idle"][0]	= %duhoc_climber_idle_player;
	level.scr_anim["cliffclimber_player"]["stop_idle"][1]	= %duhoc_climber_wave_01_player;
	level.scr_anim["cliffclimber_player"]["stop_idle"][2]	= %duhoc_climber_wave_02_player;
	
	level.scr_anim["cliffclimber_player"]["stop_idle2"][0]	= %duhoc_climber_idle_player;
	level.scr_anim["cliffclimber_player"]["stop_idle2"][1]	= %duhoc_climber_idle_player;
	level.scr_anim["cliffclimber_player"]["stop_idle2"][2]	= %duhoc_climber_wave_02_player;
}

#using_animtree("duhoc_player");
player_animations()
{
	level.scr_animtree["player"] = #animtree;
	level.scr_anim["player"]["flip"]				= %duhoc_player_flip;
	level.scr_anim["player"]["drag"]				= %duhoc_player_drag;
}

#using_animtree("generic_human");
AI_animations()
{
	level.scr_animtree["generic_human"] = #animtree;
	level.scr_anim["drag_guy"]["drag"]				= %duhoc_ranger_drag;
	
	//Germans who throw grenades down the cliffs
	level.scr_anim["cliff_grenade_toss"][0]			= %stand_grenade_throw;
	
	//Germans fall off the cliff muhahaha
	level.scr_anim["cliff_death_01"]				= %duhoc_cliff_german_death_b_01;
	level.scr_anim["cliff_death_02"]				= %duhoc_cliff_german_death_02;
	level.scr_anim["cliff_death_03"]				= %duhoc_cliff_german_death_03;
	
	level.scr_anim["cliff_death_pose"]				= %duhoc_cliff_german_death_pose;
	level.scr_anim["cliff_death_root"]				= %root;
	level.scr_anim["cliff_shots_01"]				= %duhoc_cliff_german_shots_01;
	level.scr_anim["cliff_shots_02"]				= %duhoc_cliff_german_shots_02;
	
	//animations for the medic dragging the wounded guy then dying
	level.scr_anim["dragger"]["cycle"]				= %wounded_dragger_cycle;
	level.scr_anim["dragger"]["death"]				= %wounded_dragger_death;
	level.scr_anim["dragged"]["cycle"]				= %wounded_dragged_cycle;
	level.scr_anim["dragged"]["death"]				= %wounded_dragged_death;
	
	//top of cliff scene
	level.scr_anim["randall"]["guns_not_here"]		= %duhoc_topofcliff_randall;
	level.scr_anim["braeburn"]["guns_not_here"]		= %duhoc_topofcliff_braeburn;
	
	//Mortar team animations
	level.scr_anim["mortar_loader"]["waitidle"]		= %mortar_loadguy_waitidle;
	level.scr_anim["mortar_loader"]["waittwitch"]	= %mortar_loadguy_waittwitch;
	level.scr_anim["mortar_loader"]["fire"]			= %mortar_loadguy_fire;
	level.scr_anim["mortar_loader"]["pickup"]		= %mortar_loadguy_pickup;
	level.scr_anim["mortar_shooter"]["waitidle"]	= %mortar_aimguy_waitidle;
	level.scr_anim["mortar_shooter"]["waittwitch"]	= %mortar_aimguy_waittwitch;
	level.scr_anim["mortar_shooter"]["fire"]		= %mortar_aimguy_fire;
	level.scr_anim["mortar_shooter"]["pickup"]		= %mortar_aimguy_pickup;
	
	//grenade death guy
	level.scr_anim["grenadedeath"]["death"]			= %death_explosion_up10;
	
	//grenade guys
	level.scr_anim["grenader"]["grenade_throw_stand"]	= %stand_grenade_throw;
	level.scr_anim["grenader"]["grenade_throw_crouch"]	= %crouch_grenade_throw;
	level.scr_anim["grenader"]["grenade_crouch"][0]		= %grenader_idle;
	level.scr_anim["grenader"]["grenade_throw"]			= %grenader_throw;
	
	//destroying guns with thermites
	level.scr_anim["randall"]["plant_thermite"]		= %duhoc_155gpf_plant_explosive;
	level.scr_anim["randall"]["thermites_planted"]	= %duhoc_assault_randall_hurryup;
	
	level.scr_anim["braeburn"]["secure_remaining_bunkers"]	= %duhoc_assault_braeburn_radio;
	level.scrsound["braeburn"]["secure_remaining_bunkers"] = "duhocassault_braeburn_gettingreports";
	
	level.scr_anim["gateguy"]["idle"][0]			= %duhoc_gate_ranger1idle;
	level.scrsound["gateguy"]["run"]				= "duhocassault_gr1_chargesset";
	
	level.scr_anim["randall"]["finalspeach"]		= %duhoc_endlevel_randallonradio;
	level.scrsound["randall"]["finalspeach"]		= "duhocassault_randall_bakeronesix";
	level.scrsound["randall"]["finalspeach2"]		= "duhocassault_randall_wilcoout";
}

#using_animtree("duhoc_dronerigs");
higgins_dronerig_animations()
{
	//rig
	level.scr_animtree["higgins_dronerig"] = #animtree;
	level.scr_anim["higgins_dronerig"]["0"]			= %duhoc_drones_boat0;
	level.scr_anim["higgins_dronerig"]["1"]			= %duhoc_drones_boat1;
	level.scr_anim["higgins_dronerig"]["2"]			= %duhoc_drones_boat2;
	level.scr_anim["higgins_dronerig"]["3"]			= %duhoc_drones_boat3;
	level.scr_anim["higgins_dronerig"]["4"]			= %duhoc_drones_boat4;
	level.scr_anim["higgins_dronerig"]["5"]			= %duhoc_drones_boat5;
	level.scr_anim["higgins_dronerig"]["6"]			= %duhoc_drones_boat6;
	level.scr_anim["higgins_dronerig"]["7"]			= %duhoc_drones_boat7;
	level.scr_anim["higgins_dronerig"]["8"]			= %duhoc_drones_boat8;
	level.scr_anim["higgins_dronerig"]["9"]			= %duhoc_drones_boat9;
	
	level.scr_anim["higgins_drone_animrate"]["0"] 	= 1.0;
	level.scr_anim["higgins_drone_animrate"]["1"] 	= 1.0;
	level.scr_anim["higgins_drone_animrate"]["2"] 	= 1.0;
	level.scr_anim["higgins_drone_animrate"]["3"] 	= 2.0;
	level.scr_anim["higgins_drone_animrate"]["4"] 	= 1.0;
	level.scr_anim["higgins_drone_animrate"]["5"] 	= 1.0;
	level.scr_anim["higgins_drone_animrate"]["6"] 	= 1.0;
	level.scr_anim["higgins_drone_animrate"]["7"] 	= 1.0;
	level.scr_anim["higgins_drone_animrate"]["8"] 	= 1.0;
	level.scr_anim["higgins_drone_animrate"]["9"] 	= 1.0;
	
	level.scr_anim["higgins_drone_anim_delay"]["0"] = 0.0;
	level.scr_anim["higgins_drone_anim_delay"]["1"] = 0.0;
	level.scr_anim["higgins_drone_anim_delay"]["2"] = 0.0;
	level.scr_anim["higgins_drone_anim_delay"]["3"] = 0.3;
	level.scr_anim["higgins_drone_anim_delay"]["4"] = 0.0;
	level.scr_anim["higgins_drone_anim_delay"]["5"] = 0.0;
	level.scr_anim["higgins_drone_anim_delay"]["6"] = 0.0;
	level.scr_anim["higgins_drone_anim_delay"]["7"] = 0.0;
	level.scr_anim["higgins_drone_anim_delay"]["8"] = 0.0;
	level.scr_anim["higgins_drone_anim_delay"]["9"] = 0.0;
}

#using_animtree("duhoc_drones");
higgins_drone_animations()
{
	level.scr_animtree["higgins_drone"] = #animtree;
	
	//run
	level.scr_anim["higgins_drone"]["stand2run1"]	= %drone_stand_to_run;
	level.scr_anim["higgins_drone"]["stand2run2"]	= %drone_stand_to_run;
	level.scr_anim["higgins_drone"]["stand2run3"]	= %drone_stand_to_run;
	
	level.scr_anim["higgins_drone"]["idle2run"]		= %higginsboat_ranger_transitiontorun1;
	
	level.scr_anim["higgins_drone"]["run1"][0]		= %drone_run_forward_1;
	level.scr_anim["higgins_drone"]["run2"][0]		= %drone_run_forward_2;
	level.scr_anim["higgins_drone"]["run3"][0]		= %drone_run_forward_3;
	
	//medic run
	level.scr_anim["higgins_drone"]["run_medic"][0]	= %drone_medic_run;
	
	//death
	level.scr_anim["higgins_drone"]["bulletdeath_dropinplace"]	= %death_stand_dropinplace;
	level.scr_anim["higgins_drone"]["bulletdeath_stumble"]		= %death_run_stumble;
	level.scr_anim["higgins_drone"]["bulletdeath_onfront"]		= %death_run_onfront;
	level.scr_anim["higgins_drone"]["bulletdeath_onleft"]		= %death_run_onleft;
	level.scr_anim["higgins_drone"]["bulletdeath_crumple"]		= %death_run_forward_crumple;
	
	level.scr_anim["higgins_drone"]["mortardeath_up"]		= %death_explosion_up10;
	level.scr_anim["higgins_drone"]["mortardeath_back"]		= %death_explosion_back13;
	level.scr_anim["higgins_drone"]["mortardeath_forward"]	= %death_explosion_forward13;
	level.scr_anim["higgins_drone"]["mortardeath_left"]		= %death_explosion_left11;
	level.scr_anim["higgins_drone"]["mortardeath_right"]	= %death_explosion_right13;
	
	//cover
	level.scr_anim["higgins_drone"]["stand2crouch"]		= %stand2crouch_attack;
	level.scr_anim["higgins_drone"]["cliffidle"][0]		= %duhoc__cliffidle_idle;
	level.scr_anim["higgins_drone"]["cliffidle"][1]		= %duhoc__cliffidle_idle;
	level.scr_anim["higgins_drone"]["cliffidle"][2]		= %duhoc__cliffidle_idle;
	level.scr_anim["higgins_drone"]["cliffidle"][3]		= %duhoc__cliffidle_twitch1;
	level.scr_anim["higgins_drone"]["cliffidle"][4]		= %duhoc__cliffidle_twitch2;
	level.scr_anim["higgins_drone"]["cliffidle"][5]		= %duhoc__cliffidle_point;
	
	level.scr_anim["higgins_drone"]["idle"][0]			= %stand2crouch_attack;
	level.scr_anim["higgins_drone"]["idle"][1]			= %stand2crouch_attack;
	level.scr_anim["higgins_drone"]["idle"][2]			= %stand2crouch_attack;
	level.scr_anim["higgins_drone"]["idle"][3]			= %stand2crouch_attack;
}

#using_animtree("generic_human");
flakpanzer_animations()
{	
	level.scr_anim["driver_flak"]["fire"][0]		= %flakpanzer_gunner_fire_a;
	level.scr_anim["driver_flak"]["dismount"] 		= %flakpanzer_gunner_dismount;
	level.scr_anim["driver_flak"]["death"] 			= %flakpanzer_gunner_deathfall;
	
	level.scr_anim["loaderL_flak"]["fire"][0]		= %flakpanzer_leftloader_fire_a;
	level.scr_anim["loaderL_flak"]["dismount"] 		= %flakpanzer_leftloader_dismount;
	level.scr_anim["loaderL_flak"]["death"] 		= %flakpanzer_gunner_deathfall;
	
	level.scr_anim["loaderR_flak"]["fire"][0]		= %flakpanzer_rightloader_fire_a;
	level.scr_anim["loaderR_flak"]["dismount"] 		= %flakpanzer_rightloader_dismount;
	level.scr_anim["loaderR_flak"]["death"] 		= %flakpanzer_gunner_deathfall;
}

#using_animtree("duhoc_wounded");
wounded_animations()
{
	level.scr_animtree["wounded"] = #animtree;
	
	//laying down, arm on chest (head pointed direction of node)
	level.scr_anim["wounded"]["chest"][0]			= %wounded_chestguy_idle;
	level.scr_anim["wounded"]["chest"][1]			= %wounded_chestguy_twitch;
	level.scr_anim["wounded"]["chest"][2]			= %wounded_chestguy_twitch;
	
	//laying down, knees bent, holding groin (feet pointed direction of node)
	level.scr_anim["wounded"]["groin"][0]			= %wounded_groinguy_idle;
	level.scr_anim["wounded"]["groin"][1]			= %wounded_groinguy_twitch;
	level.scr_anim["wounded"]["groin"][2]			= %wounded_groinguy_twitch;
	
	//laying down, grasping neck (head pointed direction of node)
	level.scr_anim["wounded"]["neck"][0]			= %wounded_neckguy_idle;
	level.scr_anim["wounded"]["neck"][1]			= %wounded_neckguy_twitch;
	
	//laying down on side almost fetal position (head pointed direction of node)
	level.scr_anim["wounded"]["side"][0]			= %wounded_sideguy_idle;
	level.scr_anim["wounded"]["side"][1]			= %wounded_sideguy_twitch;
	
	//sitting upright, hand on chest (facing 10:30)
	level.scr_anim["wounded"]["sitting"][0]			= %brecourt_woundedman_idle;
	
	//standing up, holding stomach (facing direction of node)
	level.scr_anim["wounded"]["standing"][0]		= %woundedidle_unarmed;
	
	//dead body floating in water (version 1)
	level.scr_anim["wounded"]["floater_a"][0]		= %deadguys_floaterA_idle;
	
	//dead body floating in water (version 1)
	level.scr_anim["wounded"]["floater_b"][0]		= %deadguys_floaterB_idle;
	
	//wounded guy gets carried by a medic
	level.scr_anim["medicCarry_wounded"]["walk"]		= %duhoc_wounded_carried_walk;
	level.scr_anim["medicCarry_wounded"]["death"]		= %duhoc_wounded_carried_death;
	level.scr_anim["medicCarry"]["walk"]				= %duhoc_wounded_carrier_walk;
	level.scr_anim["medicCarry"]["death"]				= %duhoc_wounded_carrier_death;
	
	//guys burning come out of boats
	level.scr_anim["wounded"]["drone_burner1"]			= %duhoc_drone_onfire_01;
	level.scr_anim["wounded"]["drone_burner2"]			= %duhoc_drone_onfire_02;
	level.scr_anim["wounded"]["drone_burner3"]			= %duhoc_drone_onfire_03;
}

#using_animtree("duhoc_radioman");
radioman_animations()
{
	level.scr_animtree["radioman"] = #animtree;
	
	//this one has a “dialogue” notetrack to play this sound file...  duhocassault_cof_sc14_03_t3
	level.scr_anim["radioman"]["talk"]				= %duhoc_radioman_talk;
	
	//this is the main idle
	level.scr_anim["radioman"]["idle"][0]			= %duhoc_radioman_listen;
	level.scr_anim["radioman"]["idle"][1]			= %duhoc_radioman_listen;
	level.scr_anim["radioman"]["idle"][2]			= %duhoc_radioman_listen;
	
	//this is a twitch and can also be used with other generic radio talking dialogue
	level.scr_anim["radioman"]["idle"][3]			= %duhoc_radioman_nod;
}

#using_animtree("duhoc_ropefall");
ropefall_animations()
{
	level.scr_animtree["ropefall"] = #animtree;
	
	//player rope climber falls
	level.scr_anim["ropefall"]["climber_fall"]		= %ropefall_climber;
	level.scr_anim["ropefall"]["german_fall"]		= %ropefall_german;
	
	//ranger rope falls
	level.scr_anim["ropefall"]["climber02"]			= %duhoc_rangerfall_climber2;
	level.scr_anim["ropefall"]["climber03"]			= %duhoc_rangerfall_climber3;
	level.scr_anim["ropefall"]["climber04"]			= %duhoc_rangerfall_climber4;	
	level.scr_anim["ropefall"]["climber05"]			= %duhoc_rangerfall_climber5;
}

dialogue()
{
	//###########
	//ON THE BOAT
	//###########
		//Rangers! Prepare for landing! 30 seconds! May God be with you!
		level.scrsound["coxswain"]["duhocassault_coxswain_landing"]		= "duhocassault_coxswain_landing";
		
		//Alright, Dog Company, listen up! We've done this a hundred times in England on terrain a lot worse than this!
		//We got a lot of guys on Omaha and Utah beaches counting on us to get to the top of those cliffs and take out those guns! 
		level.scrsound["coffey"]["duhocassault_coffey_listenup"]		= "duhocassault_coffey_dogcompany";
		
		//You okay, Corporal? Don’t worry - you’ll do fine.
		//level.scrsound["wells"]["duhocassault_wells_youokay"]			= "duhocassault_wells_youokay";
		
		//Hey Braeburn, you look like you're gonna puke.
		level.scrsound["mccloskey"]["duhocassault_mccloskey_gonnapuke"]	= "duhocassault_mccloskey_gonnapuke";
		
		//Y'know what, Donnie…why don't you just… - (vomits)
		level.scrsound["braeburn"]["duhocassault_braeburn_vomits"]		= "duhocassault_braeburn_vomits";
		
		//Firing rockets!!!
		level.scrsound["coxswain"]["duhocassault_coxswain_firerockets"]	= "duhocassault_coxswain_firerockets";
		
		//Firing rockets!!! Cover!!!
		level.scrsound["randall"]["duhocassault_randall_firingrockets"]	= "duhocassault_randall_firingrockets";
		
		//All right, everybody out!
		level.scrsound["coxswain"]["duhocassault_coxswain_everybodyout"]= "duhocassault_coxswain_everybodyout";
		
		//Lets go! Move it! Follow me!
		//level.scrsound["coffey"]["duhocassault_coffey_followme"]		= "duhocassault_coffey_followme";
	//###########
	//###########
	//###########
	
	//---------------------------------
	
	//################
	//WOUNDED ON BEACH
	//################
	
		level.scrsound["wounded"]["medic1"][0]				= "duhocassault_grh_aughmama";
		level.scrsound["wounded"]["medic1"][1]				= "duhocassault_gr8_aaagh";
		level.scrsound["wounded"]["medic1"][2]				= "duhocassault_gr8_bleedingrealbad";
		
		level.scrsound["wounded"]["medic2"][0]				= "duhocassault_gr7_getmeamedic";
		
	//################
	//################
	//################
	
	//---------------------------------
	
	//############
	//ON THE BEACH
	//############
		//I gotcha Taylor! You’ll be all right! You’re gonna be just fine!
		level.scrsound["medic"]["duhocassault_wells_igotcha"]			= "duhocassault_wells_igotcha";
		
		//"You’re a lucky man, Taylor. Looks like you just got the wind knocked outta ya.
		//You’d better find a weapon quick and hook up with the Sarge. Good luck."
		level.scrsound["medic"]["duhocassault_wells_luckyman"]			= "duhocassault_wells_luckyman";
		
		
		//Where's your weapon? Go find a replacement and meet me back here!
		//level.scrsound["randall"]["duhocassault_randall_yourweapon"]	= "duhocassault_randall_yourweapon";
		
		//Taylor! Get up this rope to the top of the cliff! We gotta get up there and take out those coastal guns!
		level.scrsound["randall"]["duhocassault_randall_allgetuprope"]	= "duhocassault_randall_takeoutguns";
		
		//Get up that rope soldier!
		level.scrsound["randall"]["duhocassault_randall_ropesoldier"]	= "duhocassault_randall_thatropesoldier";
		
		//Get going Corporal!
		level.scrsound["randall"]["duhocassault_randall_getgoing"]		= "duhocassault_randall_getgoingcorporal";
		
		level.scrsound["radioman"]["duhocassault_coffey_tarefoxabel"]	= "duhocassault_coffey_tarefoxabel";
		
	//############
	//############
	//############	
	
	//---------------------------------
	
	//#############
	//TOP OF CLIFFS
	//#############
		
		level.scrsound["clifftop"]["getthebastards"]					= "hill400_assault_gr5_letsgoget";
		level.scrsound["clifftop"]["gogogo"]							= "duhoc_assault_rnd_gogogo";
		level.scrsound["clifftop"]["cutemdown"]							= "duhoc_assault_gr2_cutemdown";
		
		//Sergeant Randall! The guns are gone! They're not here!
		level.scrsound["braeburn"]["duhocassault_braeburn_gunsgone"]	= "duhocassault_braeburn_gunsaregone";
		
		//What???
		level.scrsound["randall"]["duhocassault_randall_what"]			= "duhocassault_randall_what";
		
		//THE - GUNS - AREN'T - HERE! The Krauts must've moved them someplace else!
		level.scrsound["braeburn"]["duhocassault_braeburn_gunsmoved"]	= "duhocassault_braeburn_gunsarenthere";
		
		//Well, hell, keep movin'! We're sittin' ducks out here! Head for rally point Baker and set
		//up that roadblock! Taylor and I will look for the guns from there!
		level.scrsound["randall"]["duhocassault_randall_sittingducks"]	= "duhocassault_randall_sittingducks";
		
		//Right, Sarge! Come on Donnie!
		level.scrsound["braeburn"]["duhocassault_braeburn_rightsarge"]	= "duhocassault_braeburn_rightsarge";
	
	//#############
	//#############
	//#############
	
	//---------------------------------
	
	//#############
	//BEACH CHATTER
	//#############
		
		index = 0;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_machinegun";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_dontbunchup";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_watchforgrenades";	index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_cutchatter";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_sonofa";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_get60up";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_silhouettesonedge";	index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_mortarrounds";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_getgoing";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_waitingfor";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_upthosecliffs";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_holdingupline";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_tidesmovingin";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_stayincover";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_getupthere";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_tiredofstarin";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_toggleropes";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_moremenuptop";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_hitthecliffs";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_halftheropes";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_movemove";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_staydown";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_hustleup";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_imhitimhit";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_getupropes";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_letsgetammo";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_offbeach";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_keepitmoving";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_moveout";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_letsgoletsgo";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_go";				index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_letsgetmoving";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_getleadout";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr6_losingmen";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_findarope";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_getonropes";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_gatherweapons";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_getupthere";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_moveupcliffs";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr1_cmonclimb";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_defiladecliff";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_letsgo";			index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr5_whatthehell";		index++;
		level.scrsound["beach_chatter"][index]	= "duhocassault_gr4_letsgolets";		index++;
		
	//#############
	//#############
	//#############
	
	//---------------------------------
	
	//####
	//MISC
	//####
	
		level.scrsound["german_cliff_dive"]			= "germansoldier_fall";
		
		level.scrsound["radioman"]["duhocassault_coffey_tarefoxabel"]		= "duhocassault_coffey_tarefoxabel";
		level.scrsound["radioman"]["duhocassault_bra_radioslugger"]			= "duhocassault_bra_radioslugger";
	
	//####
	//####
	//####
	
	//---------------------------------
	
	//###############
	//DESTROYING GUNS
	//###############
		
		level.scrsound["randall"]["duhocassault_randall_onesoverhere"]			= "duhocassault_randall_onesoverhere";
		level.scrsound["randall"]["duhocassault_randall_outtathermite"]			= "duhocassault_randall_outtathermite";
		level.scrsound["randall"]["duhocassault_randall_getthehellout"]			= "duhocassault_randall_getthehellout";
		level.scrsound["randall"]["duhocassault_randall_gomopup"]				= "duhocassault_randall_gomopup";
		
		level.scrsound["mccloskey"]["duhocassault_mcc_findthoseguns"]			= "duhocassault_mcc_findthoseguns";
		level.scrsound["randall"]["duhocassault_randall_damnright"]				= "duhocassault_randall_damnright";
		
	//###############
	//###############
	//###############
}