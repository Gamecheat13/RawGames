#include maps\_utility;
#include maps\_bossfight;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;
#include maps\_equalizer;
#include maps\_weather;

main()
{
	level.strings["sciencecenter_b_collection0_name"] = &"SCIENCECENTER_B_DATA0_NAME";
	level.strings["sciencecenter_b_collection0_body"] = &"SCIENCECENTER_B_DATA0_BODY";

	level.strings["sciencecenter_b_collection1_name"] = &"SCIENCECENTER_B_DATA1_NAME";
	level.strings["sciencecenter_b_collection1_body"] = &"SCIENCECENTER_B_DATA1_BODY";

	level.strings["sciencecenter_b_collection2_name"] = &"SCIENCECENTER_B_DATA2_NAME";
	level.strings["sciencecenter_b_collection2_body"] = &"SCIENCECENTER_B_DATA2_BODY";

	level.strings["sciencecenter_b_collection3_name"] = &"SCIENCECENTER_B_DATA3_NAME";
	level.strings["sciencecenter_b_collection3_body"] = &"SCIENCECENTER_B_DATA3_BODY";

	level.strings["sciencecenter_b_collection4_name"] = &"SCIENCECENTER_B_DATA4_NAME";
	level.strings["sciencecenter_b_collection4_body"] = &"SCIENCECENTER_B_DATA4_BODY";

	level.strings["sciencecenter_b_collection5_name"] = &"SCIENCECENTER_B_DATA5_NAME";
	level.strings["sciencecenter_b_collection5_body"] = &"SCIENCECENTER_B_DATA5_BODY";

	// moving the phone in script to fight a bug where you can hit the lock hack and phone at the same time
	ent = getent("phone_01", "targetname");
	ent moveto((35, 431, 736), 0.05);

	//precache dimitri carlos cutscene.
	precachecutscene( "SCB_BombHandoff" );

	//precache & load FX entities (do before calling _load::main)
	//	maps\MiamiScienceCenter_fx::main();
	maps\_trap_extinguisher::init(); 
	maps\_securitycamera::init();
	maps\_playerawareness::init();
	maps\sciencecenter_b_fx::main();
	maps\_blackhawk::main( "v_heli_mdpd_low" );

	maps\_load::main();

	// set the clocks
	maps\_utility::init_level_clocks(2, 47, 5);

	// turn off sun shadows
	setdvar("sm_sunshadowenable", 0);

	//level.player thread debug_sound_test();

	maps\sciencecenter_b_snd::main();
	maps\sciencecenter_b_mus::main();

	//Enable mini-map for test level
	precacheShader( "compass_map_miamisciencecenterb" );
	setminimap( "compass_map_miamisciencecenterb", 1168, 3896, -1080, -704  );

	//avulaj
	//this fires off the catwalk script file and the basement
	level thread maps\miami_science_center_catwalk::main();
	level thread maps\miami_science_center_basement::main();

	// we need to hide the broken pillar right off the bat
	destroyed_wall = getent ("pillar_after","targetname");
	if(isdefined(destroyed_wall))
		destroyed_wall hide();

	// we also need to hide the exploding tanks
	rpg_exploders = getentarray("rpg_exploders", "script_noteworthy");
	if(isdefined(rpg_exploders))
	{
		for(i = 0; i < rpg_exploders.size; i++)
		{
			rpg_exploders[i] hide();
			rpg_exploders[i] notsolid();
		}
	}


	//artist mode
	if( Getdvar( "artist" ) == "1" )
	{
		return;   
	}           

	// made a vision set function that will change vision sets when appropriate
	thread setup_vision();

	precachevehicle("defaultvehicle");

	// Jluyties precahce knife so I can use it
	precacheModel("w_t_knife_demitrios");

	// Level VARS
	level.flick_ele_light_var = false;
	level.davinchi_crashed = false;

	// setup cutscenes
	level thread setup_cutscenes();


	//////////////////////////NOTES////////////////////////////
	//// this is the notify when lock picking a door       ////
	//// level.player waittill( "lockpick_done" );         ////
	//// if( level.player.lockSuccess == true )            ////
	///////////////////////////////////////////////////////////


	// thread maps\_weather::rainhard(1);

	level.light_flicker = 1;
	///////////// CATWALKS /////////////

	//---------- OBJECTIVES -------------
	level thread science_center_objectives();
	//-----------------------------------

	//------- GLOBAL FUNCTIONS -----------
	level thread skip_to_points();	// sets all skipto points.

	///////////// BASEMENT /////////////

	//----- STORAGE ROOM FUNCTIONS ------
	//level thread access_camera_controls();

	// jluyties
	level thread elevator_moves_up_from_security();
	//-----------------------------------

	//----- SECURITY CAMERA FUNCTIONS -----
	level thread e1_camera();
	level thread monitor_cam();
	level thread setup_security_feed();
	//-------------------------------------

	///////////// MAIN HALL /////////////
	level thread shut_elev_doors();
	level thread jl_ending();


	//-------- MAIN HALL FUNCTIONS --------

	////////level variables////////
	level.laptop = 0;        //
	level.debug_text = 0;    //
	///////////////////////////////

	//////////////////////////////////////////////////////
	// Jluyties this is my setup for mainhall moments.  //
	level thread level_setup();                       //
	//////////////////////////////////////////////////////

	//////////////////////////////////////
	//Contrast 1.96875                    //
	//Bright 0.46875                      //
	//Desatiration 0.325                  //
	//Light Tint 0.90625 0.921875 1.0625  //
	//Dark Tint 1.03125 1.04688 1.15625   //
	//////////////////////////////////////

	// just in case weapons are brought over from sca, make sure they aren't wet
	//thread add_wet_materials();
	// watch all of the checkpoints
	thread watch_checkpoints();

	// turn off dynamic lights so we can turn them on later
	level.console_light = getent("console_light", "targetname");
	if(isdefined(level.console_light))
	{
		level.console_light setlightintensity(0);
		//iprintlnbold("console light off");
	}
	level.rope_light = getent("light_dynamic_stair", "targetname");
	if(isdefined(level.rope_light))
	{
		level.rope_light setlightintensity(0);
		//iprintlnbold("rope light off");
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// New Stuff - jpark
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	flag_init("reached_basement");
	flag_init("reached_stairwell");
	flag_init("accessed_elevator");
	flag_init("dimitrios_dead");
	flag_init("killed_men");
	flag_init("success");

	level.terminate_elevator_lights = false;
	level.elevator_crashed = false;
	level.rocket_impact = false;
	level.rocket_impact2 = false;
	level.wave2_spawned = false;
	level.wave3_spawned = false;
	level.side_spawned = false;
	level.lastside_spawned = false;
	level.davinci_collapsed = false;
	level.lights_shot_down = 0;

	level notify("streamer_2_start");
	level notify("streamer_3_start");

	thread init_mainhall();

	GetEnt("player_at_catwalk1_door", "script_noteworthy") maps\miami_science_center_catwalk::start_catwalk1_patrol();	// do vo for the first catwalk when player gets to the door
}
debug_sound_test()
{
	iprintlnbold("start debug sound test");
	while(1)
	{
		if(self jumpbuttonpressed())
		{
			iprintlnbold("playing sound");
			self playsound("wpn_rpg_imp"/*"explo_grenade_frag"*/, "sound_done");
			self waittill("sound_done");
			iprintlnbold("sound done");
		}

		wait(0.05);
	}
}
//// load the wet weapons and then turn them off
//add_wet_materials()
//{
//	wait(0.01);
//	
//	// Weapon PA99
//	materialaddwet("mtl_w_p99_wet");
//	materialaddwet("mtl_w_p99_silenced_wet");
//	
//	// M14
//	materialaddwet("mtl_w_m14_wet");
//	materialaddwet("mtl_w_m14_stock_rail_wet");
//	materialaddwet("mtl_w_foregrip_wet");
//	materialaddwet("mtl_w_silencer_rifle_wet");
//	
//	// SAF9 
//	materialaddwet("mtl_w_mp05_wet"); 
//	materialaddwet("mtl_w_silencer_rifle_03_wet"); 
//	materialaddwet("mtl_w_foregrip_wet"); 
//	materialaddwet("mtl_w_mp05_plastic_wet"); 
//	materialaddwet("mtl_w_mp05_stock_sd_wet");
//
//	// Additional requested materials
//	materialaddwet("mtl_w_laser_wet");
//	materialaddwet("mtl_w_longscope_wet");
//	materialaddwet("mtl_w_m14_plastic_wet");
//
//	// 1911
//	materialaddwet("mtl_w_1911_wet");
//	
//	materialsetwet(0);
//}
setup_vision()
{
	// change vision sets appropriately
	// 01
	//iprintlnbold("vision 01");
	VisionSetNaked("sciencecenter_b_01");

	// 02
	trig = getent("trigger_reached_maincatwalk", "targetname");
	if(isdefined(trig))
	{
		trig waittill("trigger");

		//iprintlnbold("vision 02");
		VisionSetNaked("Sciencecenter_b_02", 1.0);
		setExpFog(453.908, 932.352, 0.335938, 0.304688, 0.34375, 0.625);
	}

	// 03
	trig = getent("trigger_savegame_rope", "targetname");
	if(isdefined(trig))
	{
		trig waittill("trigger");

		//iprintlnbold("vision 03");
		VisionSetNaked("sciencecenter_b_03", 2);
	}

	// 04
	trig = getent("trigger_check_alert", "targetname");
	if(isdefined(trig))
	{
		trig waittill("trigger");

		//iprintlnbold("vision 04");
		VisionSetNaked("Sciencecenter_b_04");
	}

	// 05
	level waittill("elevator_hatch_start");

	//iprintlnbold("vision 05");
	VisionSetNaked("sciencecenter_b_05", 1.0);

	// 06
	trig = getent("trigger_rpg", "targetname");
	if(isdefined(trig))
	{
		trig waittill("trigger");

		//iprintlnbold("vision 06");
		VisionSetNaked("sciencecenter_b_06", 2.3);
		setExpFog(708.895, 1277.02, 0.375, 0.398438, 0.4140063, 0.625);
	}

	// 07
	level waittill("mainhall_fire_on");

	//iprintlnbold("vision 07");
	VisionSetNaked( "Sciencecenter_b_07", 2.3);
}
// AE: have the checkpoints in a central location, so it's easier to find
watch_checkpoints()
{
	self endon("mission_success");

	// checkpoint 1
	// after the very first lock hack, in the catwalk area
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 1");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint 2
	// during the big catwalk fight, it's a trigger right before the beam
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 2");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint 3
	// after you kill all of the ai in the big catwalk battle
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 3");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint 4
	// after the rope, the first lock hack in the basement
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 4");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint 5
	// reached and entered the basement elevator
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 5");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint 6
	// inside the elevator right before the hatch drops
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 6");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint 7
	// once the davinci heli is triggered to start crashing
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 7");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint 8
	// when the left or right wave spawns
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 8");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint 9
	// when you've killed everyone in the main hall
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 9");
	level maps\_autosave::autosave_now("MiamiScienceCenter");

	// checkpoint failsafe
	while(1)
	{
		// for good measure just in case
		level waittill("checkpoint_reached");
		//iprintlnbold("checkpoint 9");
		level maps\_autosave::autosave_now("MiamiScienceCenter");

		wait(0.05);
	}
}

//////////// MAINHALL /////////////	
//----- STORAGE ROOM FUNCTIONS ------
level_setup() // jlsetup
{
	//iprintlnbold("level_setup");
	// Z I am still using your this function to call in the bad guys at the ele in the beggining
	//level thread thug_attack_elev();               //
	///////////////////////////////////////////////////

	//maps\_loadout::init_loadout();
	level.debug_text = 1;
	//level.player takeallweapons();
	//level.player GiveWeapon( "p99_silenced" );
	//level.player SwitchToWeapon( "p99_silenced" );
	maps\_phone::setup_phone();

	level waittill ( "ready_mainhall" );

	// we also need to show the exploding tanks
	rpg_exploders = getentarray("rpg_exploders", "script_noteworthy");
	if(isdefined(rpg_exploders))
	{
		for(i = 0; i < rpg_exploders.size; i++)	
		{
			rpg_exploders[i] show();
			rpg_exploders[i] solid();
		}
	}

	//iprintlnbold("level_setup ready_mainhall");
	/////////////////////////////////////////////////////////////////////////////	
	// Z this is a function to just control objectives for the first playable. //                                 //
	/////////////////////////////////////////////////////////////////////////////

	///////////////////////////////////////////////////////////////////////////////////////////
	//  Battle flow                                                                          //
	//  wave1 is one rocket guy with two attacker from second story left and right.          //
	//  wave2 is two guys on the top and four from the bottom                                //
	//  wave3 is 6 guys who come in from the very rear and take cover near the scaffolding   //
	///////////////////////////////////////////////////////////////////////////////////////////

	////// three wave controllers for battle manipulation////////////////////////////////////////////////////////////
	//level thread wave1_battle_controller(); // setup trigger to wait for bond to make it to the second floor   //
	//level thread wave2_battle_controller(); // setup trigger to wait for bond to make to the first floor       //
	//level thread wave3_battle_controller(); // setup trigger to wait for bond to make to the last area         //
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	///// fx setup for end cowbell sequence /////////////////////////////////
	//	This calls in cod 4 effects and then loops the lint effect forever //
	level thread wave3_fx_end();                                         //
	/////////////////////////////////////////////////////////////////////////

	//// This is what happens when the elevato crashes //////////////////////////////////////////////
	//	 this is trigger that don't allow to be used untill the player starts clmibg the pipe        //
	level thread elevator_shot_by_bond_and_falls(); // setup do I can watch the ele crash soon.  //
	/////////////////////////////////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// I should have setup on function that simply passes in a name for sound and guy. Yet was lazy and just setup a different function for each  //
	// Setup security vo ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	level thread main_hall_audio_earpiece();    	//
	//level thread mercs_audio();                 	//
	level thread merc_audio_lights_shot();      	//
	//level thread merc_audio_stairwell();          //
	level thread mercs_audio_he_is_the_middle();  //
	level thread merc_audio_underneath_us();      //
	level thread mercs_audio_behind_display();    //
	level thread mercs_audio_second_to_second();  //
	level thread mercs_audio_lights_shotdown();   //
	level thread mercs_audio_he_is_left();        //
	//level thread mercs_audio_by_scaf();           //
	////////////////////////////////////////////////


	////////////////////////////////////////////////
	// Controls camera as player climbs ele out.  //
	//level thread force_camera_initializer();      //
	////////////////////////////////////////////////

	////////////////////////////////////////////////////////////
	// This sets up the boss sequence and the note tracks     //
	//level thread main_hall_boss_fight();                    //
	//level thread boss_notetracks();                         //
	//////////////////////////////////////////////////////////

	level thread stairwell_lights_off();	

	//level thread bond_force_cover();

	//////////////////////////////////////////////////////////////////	
	// Simple music controller beacuse the AI are already alerted   //	
	level thread music_controller();                              //
	//////////////////////////////////////////////////////////////////

	//thread close_mainhall_gates();	// start with the gates closed
	thread activate_davinci_heli();	// get the heli crash ready to go off (when the notify is sent)
	thread spawn_in_waves();		// get the wave spawning ready (when the trigger is hit)
	thread send_the_gogogo();		// wait until we hit the wave02 trigger and send notify "gogogo"
	thread spawn_elevator_exit();	// calls the upstairs elevator guards and the rpg firing (when the trigger is hit)
	thread stair_fighters();		// spawns ai to slow down bond when dimi runs away (when the trigger is hit)
}
//-----------------------------------


//bond_force_cover()
//{
//	level.player freezecontrols(true);	// Need To Call Freeze Controls Because I Need To Unstick The Player In Order To Call Force Cover
//	wait( 1 ); 
//	level.player playersetforcecover( true, (1,0,0) );
//	wait(10);
//	player_unstick();
//	level.player freezeControls(false);
//	level.player playersetforcecover( false, false );
//}

////////////////////////////////////////////////////
///////////////// GLOBAL FUNCTIONS /////////////////
////////////////////////////////////////////////////

//avulaj
//this deletes any thug who gets to a node with pt_ongoal "global_delete_end_node"
global_delete_end_node()
{
	if((isdefined(self)) && (!level.player islookingat(self)))
	{
		wait( .5 );
		self delete();
	}
}

//avulaj
//
setup_cutscenes()
{
	level thread preview_cutscene();
}

//avulaj
//
preview_cutscene()
{
	// check for DVAR and exit out if nothingspecified
	strIGC = GetDVar( "preview");
	if(	!IsDefined(	strIGC ) )
	{
		return;
	}

	//check	to see if	DVar matches one of	the	IGCs
	if(	 strIGC	== "MM_SC_0201"	)
	{
		// play	scene		
		wait(	2	);
		//iPrintLnBold(	"Previewing	"	+	strIGC );
		PlayCutScene(	strIGC,	"scene_anim_done"	);

	}
	else if(	 strIGC	== "MM_SC_0301"	)
	{
		// play	scene	anim
		wait(	2	);
		//iPrintLnBold(	"Previewing	"	+	strIGC );
		PlayCutScene(	strIGC,	"scene_anim_done"	);

	}

	// wait	for	scene	anim to	finish,	clean	up and repeat
	level	waittill(	"scene_anim_done"	);
	preview_cutscene();

}


////avulaj
////
//catwalk_right_01()
//{
//	trigger = getent ( "catwalk_lower_thug_right_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "right_trigger_spotted" );
//
//	thug = getent ("catwalk_lower_thug_right_01", "targetname")  stalingradspawn( "thug" );
//	thug waittill( "finished spawning" );
//	wait ( 4 );
//	thug = getent ("catwalk_lower_thug_right_02", "targetname")  stalingradspawn( "thug" );
//	thug waittill( "finished spawning" );
//}

////avulaj
////
//catwalk_left_01()
//{
//	trigger = getent ( "catwalk_lower_thug_left_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "left_trigger_spotted" );
//
//	thug1 = getent ("catwalk_lower_thug_left_02", "targetname")  stalingradspawn( "thug1" );
//	thug1 waittill( "finished spawning" );
//	wait ( 4 );
//
//	catwalk_thug = getentarray ( "catwalk_lower_thug_left_01", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//		}
//	}
//}

////avulaj
////
//catwalk_middle()
//{
//	trigger = getent ( "catwalk_lower_thug_middle_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "middle_trigger_spotted" );
//
//	catwalk_thug = getentarray ( "catwalk_lower_thug_middle", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//		}
//	}
//}
//
////avulaj
////
//catwalk_middle_top()
//{
//	trigger = getent ( "catwalk_lower_thug_middle_top_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "middle_top_trigger_spotted" );
//
//	catwalk_thug = getentarray ( "catwalk_lower_thug_middle_top", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//		}
//	}
//}

////avulaj
////
//catwalk_center()
//{
//	trigger = getent ( "catwalk_lower_thug_center_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "middle_top_trigger_spotted" );
//
//	catwalk_thug = getentarray ( "catwalk_lower_thug_center_01", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//		}
//	}
//}

////avulaj
////
//catwalk_thug_who_die()
//{
//	catwalk_thug = getentarray ( "catwalk_light_fall_on_thugs", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//			thug[i] thread catwalk_death_from_above();
//			thug[i] lockalertstate( "alert_green" );
//		}
//	}
//}

////avulaj
////
//catwalk_death_from_above()
//{
//	org = getent ( "damage_point", "targetname" );
//	level waittill ( "from_above" );
//	radiusdamage ( org.origin, 150, 200, 200 );
//}


////avulaj
////this flickers a light in the stair well that takes place after the catwalks
////this also swaps a model of the light ficture being on and off
//stairs_light_flicker()
//{
//	light = getent ( "light_stair", "targetname" );
//
//	level endon ( "kill_stair_light" );
//	while ( 1 )
//	{
//		wait ( .1 );
//		//light_fix_start setmodel ( "com_lightbox" );
//		light setlightintensity ( 0 );
//		wait( .05 + randomfloat( .1 ) );
//
//		j = randomint( 20 );
//		if ( j < 1 )
//		{
//			wait( 1 );
//		}
//
//		//light_fix_start setmodel ( "com_lightbox_on" );
//		light setlightintensity ( 1 );
//		wait( .05 + randomfloat( .1) );
//	}
//}

////avulaj
////
//catwalk_new_route_01()
//{
//	wait ( 2 );
//	self stoppatrolroute();
//	wait ( 5 );
//	self startpatrolroute ( "catwalk_long_01" );
//}
//
////avulaj
////
//catwalk_new_route_02()
//{
//	wait ( 2 );
//	self stoppatrolroute();
//	wait ( 5 );
//	self startpatrolroute ( "catwalk_long_02" );
//}
////////////////////////////////////////////////////
//////////////// CATWALK FUNCTIONS /////////////////
////////////////////////////////////////////////////


////////////////////////////////////////////////////
//////////////// CAMERA FUNCTIONS //////////////////
////////////////////////////////////////////////////

//avulaj
//this activates the second set of cameras
//the first is in the hall outside the small restoration room
//the second is on a pillar between to shelves in the small storage room
//the third is above the doorway leading out of the small storage room
//basement_camera_02()
//{
//	getentarray ( "basement_camera_2", "targetname" ) thread maps\_securitycamera::camera_start();
//}

//avulaj
//this activates the third set of cameras
//basement_camera_03()
//{
//	trigger = getent ( "basement_trigger_third_set_cameras", "targetname" );
//	trigger waittill ( "trigger" );
//	getentarray ( "basement_camera_3", "targetname" ) thread maps\_securitycamera::camera_start();
//}

//avulaj
//
//basement_camera_movement()
//{
//	self endon ( "damage" );
//	while ( 1 )
//	{
//		wait ( .1 );
//		self rotateyaw( 125, 4 );
//		self waittill ( "rotatedone" );
//		self rotateyaw( -125, 4 );
//		self waittill ( "rotatedone" );
//	}
//}

//avulaj
//
//basement_camera_health()
//{
//	self waittill ( "damage" );
//	iprintlnbold ( "camera_broken" );
//	self notify ( "damage" );
//}

////////////////////////////////////////////////////
//////////////// CAMERA FUNCTIONS //////////////////
////////////////////////////////////////////////////


////////////////////////////////////////////////////
///////////// SECTION ONE FUNCTIONS ////////////////
////////////////////////////////////////////////////

////avulaj
////
//section_one_spawn_thugs()
//{
//	thug_spawn = getentarray ( "basement_section_one_spawners", "targetname" );
//
//	for ( i = 0; i < thug_spawn.size; i++ )
//	{
//		thug[i] = thug_spawn[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//		}
//	}
//}

////////////////////////////////////////////////////
///////////// SECTION ONE FUNCTIONS ////////////////
////////////////////////////////////////////////////

////avulaj
////
//basement_office_stop()
//{
//	//	wait( .5 );
//	//	if ( isdefined ( self ))
//	//	{
//	//		self stoppatrolroute();
//	//	}
//}

////avulaj
////
//basement_office_look_cameras()
//{
//	if ( isdefined ( self ))
//	{
//		pos = self.origin + ( 0, 0,64 );
//		color = ( 0, .5, 0 );            
//		scale = 1.5;       
//		Print3d( pos, "Hey Joe what'da ya know.", color, 1, scale, 120 );
//	}
//}


////////////////////////////////////////////////////
//////////////// GLOBAL FUNCTIONS //////////////////
////////////////////////////////////////////////////

//avulaj
//when ever a thug lands on a patrol node with this it will end what ever patrol he was on
global_stop_patrol()
{
	wait( .5 );
	if ( isdefined ( self ))
	{
		self stoppatrolroute();
	}
}


////////////////////////////////////////////////////
//////////////// GLOBAL FUNCTIONS //////////////////
////////////////////////////////////////////////////

//avulaj
//when Bond hits this trigger the mission will be over this is temp since the level will
//end once the big event happens in the main hall
mission_success()
{
	//	trig = getent("missionSuccessTrig","targetname");
	//	trig waittill ("trigger");

	level notify("endmusicpackage");

	//level notify("objective_5_done");

	flag_set("success");
	level notify("mission_success");

	//objective_state(5, "done");

	wait(3);
	//level notify("music_end_stinger");
	level.player play_dialogue("TANN_GlobG_019A", true);	// Excellent work 007
	
	maps\_endmission::nextmission();
}


// Jluyties
// todo
////////////////////////////////////////////////////
//////////////// MAIN HALL FUNCTIONS ///////////////
////////////////////////////////////////////////////

// Guys who attack bond on the first floor
//avulaj
//
thug_attack_elev()
{
	dimi_boss = getent("dimi_boss_fight", "script_noteworthy");
	level.dimitrios = dimi_boss stalingradspawn();
	//iprintlnbold("spawned dimi");
	level.dimitrios thread elevator_run_into_sight();

	main_shooting_thugs = getent( "main_shooting_thugs", "targetname" );

	thug = main_shooting_thugs stalingradspawn("elevator_guards");
	if( !maps\_utility::spawn_failed( thug) )
	{
		thug.accuracy = 0.5; // makes guys miss cause the level was to hard
		thug thread main_hall_attack_elevator();
	}

	// since there is only going to be 2 ai alive here, we just need to play the vo from entities in the world
	level waittill("elevator_down");
	level.dimitrios play_dialogue("SHM1_SciBG02A_045A", false); // lock the elevators
	level waittill("elevator_hatch_start");
	level.dimitrios play_dialogue("SCH3_SciBG02A_046A", false); // he's in the shaft
}

main_hall_attack_elevator()
{
	// NOTE: don't do sefl endon("death") because the explosion won't play

	// do an isalive check
	shoot_spot = (53, 3039, 176);//getent("shoot_spot", "targetname");

	target = getent("target_crate_elevator", "targetname");

	level waittill("thug_attack_elev_now");
	wait( 3.5 );
	if(isdefined(self))
	{
		self setenablesense(false);
		self CmdShootAtPos(shoot_spot);
	}

	thread explosion_outside_elevator();

	//if(isdefined(target))
	//{
	//	target delete();
	//}
	//wait(5.4);

	if(isdefined(self))
	{
		self stopallcmds();
		self lockalertstate("alert_red");
		self setenablesense(true);
	}

	//	thread delete_elevator_guards();
	//thread spawn_elevator_exit();
}
elevator_run_into_sight()
{
	if(isdefined(self))
	{
		self stopallcmds();

		// make him invincible right now, so the player doesn't kill him and ruin the moment
		self setcandamage(false);
		self setenablesense(false);

		level waittill("dimi_run_now");
		//iprintlnbold("dimi_run_now");

		self lockalertstate("alert_red"); 
		self setscriptspeed("sprint");
		node = getnode("surprise_player", "targetname");
		self setgoalnode(node);
		self thread surprise_bond();
		self thread run_and_hide();
		self thread watch_dimi_death();
	}
}
// have ai on the stairs to slow down the player from shooting at dimi
stair_fighters()
{
	// wait till Bond hits the trigger at the top of the stairs
	trigger = getent("stair_fighters_trig", "targetname");
	trigger waittill("trigger");

	spawner = getent("guard_mainhall_stairs", "targetname");
	if(isdefined(spawner))
	{
		spawner.count = 1;
		for(i = 0; i < spawner.count; i++)
		{
			guard = spawner stalingradspawn("stair_fighters");
			if(isdefined(guard))
			{
				guard setalertstatemin("alert_red");
				guard setperfectsense(true);
			}
			wait(0.05);
		}
	}
}
// have dimi run and hide at the end of the level
run_and_hide()
{
	// wait till Bond hits the trigger at the top of the stairs
	trigger = getent("dimi_run_trig", "targetname");
	trigger waittill("trigger");

	//// make his goal random
	//rand = randomint(99);
	//num = 2;
	//if(rand >= 0 && rand < 50)
	//	num = 2;
	//else if(rand >= 50 && rand < 100)
	//	num = 3;

	//goal_node = getnode("dimi_hide_node" + num, "targetname");
	goal_node = getnode("dimi_hide_node1", "targetname");
	self setgoalnode(goal_node);
	self play_dialogue("SHM5_SciBG02A_058A"); // by the stairs

	self waittill("goal");
	//self settetherradius(12); // keep him from running out from behind the desk
	thread close_mainhall_gates();	// close the gates behind dimi
	self allowedstances("crouch");	// keep him crouched, because if you have to restart from checkpoint he'll stand up
}
// have dimi jump out and surprise player
surprise_bond()
{
	self endon("death");

	// wait till Bond is close
	trigger = getent("surprise_player_now", "targetname");
	trigger waittill("trigger");

	// move the clip in the way, so dimi doesn't leave this area
	dimi_final_clip = getent("dimi_final_clip", "targetname");
	dimi_final_clip movez(120.0, 0.05);
	dimi_final_clip waittill("movedone");
	dimi_final_clip disconnectpaths();
	//// move the player clip in the way
	//player_clip = getent("main_hall_gate_clip", "targetname");
	//player_clip trigger_on();
	//// close the gates
	//close_mainhall_gates();	

	//iprintlnbold("surprise_player_now");
	self allowedstances("stand", "crouch");
	//self setcandamage(true);
	self setenablesense(true);
	//self setgoalentity(level.player);
	self setcombatrole("rusher");
	self setperfectsense(true);
	self setscriptspeed("jog");
	//self setignorethreattype("grenade", true); // this should make him ignore grenades, so he doesn't run out of the desk area
	//self cmdshootatentity(level.player, true, 2.0, 0.8);
	goal_node = getnode("dimi_rush_node", "targetname");
	self setgoalnode(goal_node, 1);
	//self setgoalentity(level.player);
	self play_dialogue("SAM_E_4_FrRs_Cmb"); // dimi screaming
	//self thread dimitrios_scream();
}
//// keep playing the scream
//dimitrios_scream()
//{
//	while(isalive(self))
//	{
//		self play_dialogue("SAM_E_4_FrRs_Cmb"); // dimi screaming
//		wait(0.05);
//	}
//}
// mission success when dimi is dead
watch_dimi_death()
{
	self waittill("death");

	level thread mission_success();
}
watch_dimi_damage()
{
	self endon("death");

	// since damage is turned on when the gates open, we need to awaken dimi if he takes damage
	self waittill("damage");

	trigger = getent("surprise_player_now", "targetname");
	if(isdefined(trigger))
		trigger notify("trigger");
}

turn_last_2_guys_into_rusher()
{
	while (1)
	{
		ai = GetAIArray("axis");
		if ( ai.size <= 3 )
		{
			for (i = 0; i < ai.size; i++)
			{
				if(	isdefined(ai[i].script_noteworthy) && 
					ai[i].script_noteworthy == "dimi_boss_fight")
				{
					continue;
				}
				//ai[i] setcombatrole("rusher");
				ai[i] setscriptspeed("sprint");
				ai[i] setgoalentity(level.player);
				ai[i] setenablesense(false);
				ai[i] thread check_within_radius();
			}
			break;
		}
		wait( 1.0 );
	}
}
check_within_radius()
{
	self endon("death");

	// when the ai get close enough to the player, turn them back on
	while(1)
	{
		distance_to_player = distance(self.origin, level.player.origin);
		if(distance_to_player < 500)
		{
			self notify("goal");
			self setenablesense(true);
			self setperfectsense(true);
			break;
		}
		wait(0.05);
	}
}

////avulaj
////
//fire_at_bond()
//{
//	trigger = getent ( "main_shooting_bond", "targetname" );
//	trigger waittill ( "trigger" );
//
//	if ( isalive ( self ) ) // added cause these guys could be dead
//	{
//		self setenablesense( true, 5 );
//		self CmdShootAtPos( level.player.origin );
//	}
//}

////avulaj
////
//go_after_bond()
//{
//	level waittill ( "thugs_run_to_second_floor" );
//	if ( isalive ( self ) ) // added cause these guys could be dead
//	{
//		self setenablesense( true );
//	}
//}


//// Controller for the whole battle
//wave1_battle_controller() // add extra stuff in here to control things...
//{
//	thread wave1_thugs();
//}
//
////jl change just putting as triggers to get a since for the level.
//wave1_thugs() // spawn second floor wave 1 enemies, after bond esapes the elevator
//{
//	getent("wave1_start_trigger", "script_noteworthy") waittill("trigger");
//	//level notify ("vo_He_is_on_the_second_floor_os2");
//	level notify ( "thugs_run_to_second_floor" );	
//	level thread wave1_thugs_spawn_move();
//}
//
//wave1_thugs_spawn_move() // send thugs into position sp they can fight bond on the second floor.
//{
//	wait( 2 );
//	// wait till the rocket hits the wall before spawning enemies////////////////////////////////////////////////////
//	// This felt really good but didn't get time to make it right, did this feel too call of duty :)               //
//	// setup a damage trigger that only detects rockes and then shake the player and blow shit up when it hits.    //
//	//	level waittill ("rocket_hit_wall");                                                                        //
//	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	wave1_shooting_thugs = getentarray ( "mainhall_thugs_1", "script_noteworthy" );
//	//attack_node 	= getnode("w1_right_side", "targetname");
//
//	for ( i = 0; i < wave1_shooting_thugs.size; i++ )
//	{
//		thug[i] = wave1_shooting_thugs[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//			thug[i] lockalertstate( "alert_red" );
//			wait( 0.5 );
//			thug[i] setscriptspeed("sprint");
//			thug[i] forceperceive( level.player );
//			// was using cover list but I don't like the lack of control after I start it.			
//			//		thug[i] setcoverlist ("wave1_forward_assault"); // a way to set up guys to run to an exact situation};
//			//		thug[i] thread clear_coverlist(5);
//		}
//	}
//	//self StopCmd();
//}

//// quick hack to get the ai to run to cover and clear this so they don't look stupid
//clear_coverlist(timer)
//{
//	wait( timer );
//	self setcoverlist ("");
//}

//wave2_battle_controller() // wave 2 controller for all things that happen in the wave 1
//{
//	// if player takes to long then start wave 2
//	getent("wave2_start_trigger", "script_noteworthy") waittill("trigger");
//	//	level notify("objective_3_done"); //talks to objective function
//	level notify ("vo_everyone_to_the_first_floor_os2"); // talks to vo function
//	//level thread roof_helo_fly_over_main_hall(); // calls heli to fly by
//	level thread wave2_thugs_spawn_move(); // spawn baddies now
//}

//wave2_thugs_spawn_move()
//{
//	wave2_shooting_thugs = getentarray ( "mainhall_thugs_2nd", "script_noteworthy" );
//	//attack_node 	= getnode("w1_right_side", "targetname");
//
//	for ( i = 0; i < wave2_shooting_thugs.size; i++ )
//	{
//		thug[i] = wave2_shooting_thugs[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//			thug[i].accuracy = 0.7;
//			thug[i] lockalertstate( "alert_red" );
//			thug[i] setperfectsense( true );
//			thug[i] setscriptspeed("sprint");
//		}
//	}
//}

//wave3_battle_controller() // wave 2 controller for all things that happen in the wave 2
//{
//	getent("wave3_start_trigger", "script_noteworthy") waittill("trigger");
//	thread wave3_thugs_spawn_move(); // spawn wave 2
//
//	wait( 20 );
//	level notify ("vo_enemy_is_trapped_hold_positions_os2");
//}	

//// this spawns in the enemies that are located at.... need more info here
//wave3_thugs_spawn_move()
//{
//	thug_spawn = getentarray ( "mainhall_thugs_3rd", "script_noteworthy" );
//
//	level notify ("davinchi_start"); // trigger and setup big objects falling to the ground.
//	level notify("end_explosion_now");	
//
//	for ( i = 0; i < thug_spawn.size; i++ )
//	{
//		thug[i] = thug_spawn[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//			thug[i] setperfectsense( true );
//			thug[i].accuracy = 0.7;
//			thug[i] lockalertstate( "alert_red" );
//			thug[i] setscriptspeed("sprint");
//		}
//	}
//	wait( 5 );
//	level notify ("vo_fallback_fallback_os2"); // talk to vo function 
//}	

//// test so I can look at crash and help get it in
//loop_davinchi()
//{
//	wait( 5 );
//	while( 1 )
//	{
//		wait( 18 );
//		//	level notify ("davinchi_start"); // trigger and setup big objects falling to the ground.
//	}
//}

// this calls in the last explosion which is a hack. I needed notetracks to call in everything to make precise. Can't wait get er done.
wave3_fx_end()
{
	// Booom (these effects are now handled in sciencecenter_b_fx.gsc)
	//level._effect["smoke_test1"]				= loadfx ("smoke/thin_light_smoke_L");
	//level._effect["smoke_test2"]				= loadfx ("dust/sand_spray_aftermath");

	// 241 998 138 view pos for effect one, far left
	// -201 787 138, far right
	// -7 860 137, middle
	//level._effect["smoke_test3"]				= loadfx ("smoke/smoke_large"); // use this across the floor as the explosion happens
	//level._effect["smoke_test4"]				= loadfx ("smoke/amb_dust");
	//level._effect["smoke_test5"]				= loadfx ("smoke/smolder_aftermath");
	//level._effect["smoke_test6"]				= loadfx ("smoke/village_ash");	

	level waittill ("end_explosion_now");
	org = spawn("script_origin",  (-1.3, 1278.3, 336) );
	org	playsound ("davinci_crash");

	// seperate function for earthquake control
	level thread wave3fx_end_quake_timing();
	wait( 5 ); 
	//	playfx ( level._effect["elev_expl"], (-201, 787, 138), (0,0,1) );
	wait( 4 );
	//	playfx ( level._effect["elev_expl"], (241, 998, 138), (0,0,1) );
	wait( 0.2 );
	//	playfx ( level._effect["elev_expl"], (-201, 787, 138), (0,0,1) );
	wait( 0.2 );
	//	playfx ( level._effect["elev_expl"], (-7, 860, 137), (0,0,1) );
	wait( 0.2 );

	level notify("fx_mainhall_smoke"); //turn on the the smoke/floating debris in the main hall
}

//// This is my crappy late hack for the clip that comes up and out of the ground as the davinchi crashes
//kill_all()
//{
//	wait( 0.5 );
//	radiusdamage ( self.origin, 350, 200, 200 );
//	wait( 0.5 );
//	radiusdamage ( self.origin, 350, 200, 200 );
//	wait( 0.5 );
//	radiusdamage ( self.origin, 350, 200, 200 );
//	wait( 0.5 );
//	radiusdamage ( self.origin, 350, 200, 200 );
//	wait( 0.5 );
//	radiusdamage ( self.origin, 350, 200, 200 );
//	wait( 0.5 );
//	radiusdamage ( self.origin, 350, 200, 200 );
//	wait( 0.5 );
//	radiusdamage ( self.origin, 350, 200, 200 );
//	wait( 0.5 );
//	radiusdamage ( self.origin, 350, 200, 200 );
//	wait( 0.5 );
//}

// jluyties quake contoller for crashing elements
wave3fx_end_quake_timing()
{
	earthquake( 0.5, 1, level.player.origin, 300 ); // catching on fire
	wait( 5 );		

	//EntityClip = getent ("clip_player_around_davinchi", "targetname");
	//EntityClip movez ( 112, 0.1 );
	//EntityClip thread kill_all();

	earthquake( 0.6, 1, level.player.origin, 300 ); // landing on the ground
	wait( 4 );
	//EntityClip disconnectpaths();
	earthquake( 0.6, 1.6, level.player.origin, 300 ); // landing on the ground
}

//// Fist pass rocket function to show fx team this is in and to get there stuff together.
//test_fx_function()
//{
//	//	getent("wave1_rail_gun", "targetname") waittill("trigger");
//	getent("wave1_start_trigger", "script_noteworthy") waittill("trigger");
//	org = spawn("script_origin",  (-201, 787, 138) );
//	org moveto ((92, 2466, 436), 1.5 , 0, 0);
//
//
//	// I turned this off once the rocket got in and worked
//	///////////////////////////////////////////////////////////////////////////////////////////////////
//	// this force hacks the smoke to loop//////////                                                //
//	org thread rocket_smoke_loops();             //                                                //
//	///////////////////////////////////////////////                                                //
//	//
//	org waittill ( "movedone" );                                                                   //
//	earthquake( 0.25, 0.4, level.player.origin, 2050 );                                            //
//	//precacheshellshock("teargas");                                                             //
//	//wait( 2 );                                                                                   //
//	//level.player ShellShock( "teargas",12); this is good to go...                                //
//	//	level.player shellshock("tankblast", 4.5);                                                   //
//	//	playfx ( level._effect["elev_expl"], org.origin + (0,0,1), (0,0,1) );                        //
//	wait( 0.4 );                                                                                   //
//	//	level notify ("rocket_hit_wall");                                                            //
//	wait( 3 );                                                                                     //
//	///////////////////////////////////////////////////////////////////////////////////////////////////	
//
//}	


//// this function calls in the rocket guy and has him fire at the player. Originally used for looping rocket effect	
//rocket_smoke_loops()
//{
//	poop = getent ("rpg_guy_for_zvulaj", "targetname")  stalingradspawn( "rpg_guy" );
//	poop lockalertstate( "alert_red" ); 
//	node = getnode ("rpg_fire", "targetname");
//	wait( 1.5);
//	poop setperfectsense( true );
//	poop CmdShootAtEntity( level.player, false, 2.5, 0 );
//	poop setperfectsense( false );
//}
////// Jluyties changes

//avulaj
//
// this moves the elevator into position after bond hacks the basement computer
access_camera_controls()
{
	//securityCameraControlAccessPanelTrig = getent ("securityCameraControlAccessPanelTrig", "targetname");
	//securityCameraControlAccessPanelTrig usetriggerrequirelookat();

	//elevator_button_up = getent("elevator_button_up", "targetname");
	//elevator_button_up show();

	level notify("move_elevator_to_position");

	wait (2.0);

	// Remove the next four lines after 1st playable
	securityElevInnerLeftDoor = GetEnt ("securityElevInnerLeftDoor", "targetname");
	securityElevInnerRightDoor = GetEnt ("securityElevInnerRightDoor", "targetname");
	securityElevOuterLefttDoorSecRoom = GetEnt ("securityElevOuterLefttDoorSecRoom", "targetname");
	securityElevOuterRightDoorSecRoom = GetEnt ("securityElevOuterRightDoorSecRoom", "targetname");

	//moving outer doors
	securityElevOuterLefttDoorSecRoom movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevOuterRightDoorSecRoom movex ( -35.0, 1.0, 0.25, 0.25);

	//moving inner doors
	securityElevInnerLeftDoor Unlink();
	securityElevInnerRightDoor Unlink();

	securityElevInnerLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor movex ( -35.0, 1.0, 0.25, 0.25);	

	securityElevInnerRightDoor playsound("Elevator_Doors_Open");

	//elevator_button_up hide();

	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
	//securityCameraControlAccessPanelTrig waittill ("trigger");

	// set cinematic  
	//SetDVar( "r_no3dincinematic", 1 );  
	//cinematicingame("MM_SC_ML");

	//level notify ("transaction_has_been_witnessed");
	//iprintlnbold("transaction_has_been_witnessed");

	//wait ( 2 );
	//level thread elevator_opens_after_transaction();
}		

//elevator_opens_after_transaction()
//{
//	// gathering all of the ents related to the elevator to get ready to move them.
//	securityElevInnerLeftDoor = GetEnt ("securityElevInnerLeftDoor", "targetname");
//	securityElevInnerRightDoor = GetEnt ("securityElevInnerRightDoor", "targetname");
//	
//	securityElevOuterLefttDoorSecRoom = GetEnt ("securityElevOuterLefttDoorSecRoom", "targetname");
//	securityElevOuterRightDoorSecRoom = GetEnt ("securityElevOuterRightDoorSecRoom", "targetname");
//	
//	if (Getdvar("cinematicText") == "on")
//	{
//		iprintlnbold("(playing elevator moving closer sound...)    DING!");	
//	}
//	
//	
//	wait (0.25);
//	
//	if (Getdvar("cinematicText") == "on")
//	{
//		iprintlnbold("play elevator doors opening sound.");	
//	}
//	
//	//moving inner doors
//	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
//	//securityElevInnerLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
//	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
//	//securityElevInnerRightDoor movex ( -35.0, 1.0, 0.25, 0.25);
//	
//	//moving outer doors
//	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
//	//securityElevOuterLefttDoorSecRoom movex ( 35.0, 1.0, 0.25, 0.25);
//	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
//	//securityElevOuterRightDoorSecRoom movex ( -35.0, 1.0, 0.25, 0.25);
//	
//	wait (0.5);
//	
//	securityElevInnerLeftDoor connectpaths();
//	securityElevInnerRightDoor connectpaths();
//	securityElevOuterLefttDoorSecRoom connectpaths();
//	securityElevOuterRightDoorSecRoom connectpaths();
//	
//	level notify( "elevator_paths_connected" );
//}

spark(origin)
{
	sound_ent = Spawn("script_origin", origin);
	//sound_ent PlaySound("GET_spark", "sounddone");
	for (i = 0; i < 7; i++)
	{
		Playfx(level._effect["science_lamp_sparks"], origin); //spark!
		waittillframeend;
	}
}

// Jluyties this is one of the main fuctions I touched for ele and boss fight.
elevator_moves_up_from_security()
{
	level waittill("move_elevator_to_position");

	// move the ladder clip out of the way because you can grab it when the elevator doors open for main hall floor 1 event
	ladder = getent("elevator_shaft_ladder", "targetname");
	if(isdefined(ladder))
		ladder trigger_off();

	// move the clip that keeps the player from sliding down the ladder until the player gets on the ladder
	ladder_player_clip = getent("ladder_player_clip", "targetname");
	if(isdefined(ladder_player_clip))
		ladder_player_clip trigger_off();

	securityElevMain = GetEnt ("securityElevMain", "targetname");

	basement_blocker = getent("ele_blocker_clean","targetname"); // blocker on first floor

	tiles = GetEntArray("elevator_tile", "targetname");
	for (i = 0; i < tiles.size; i++)
	{
		tiles[i] LinkTo(securityElevMain);
	}

	elevator_button_basement = getent("elevator_button_basement", "targetname");
	elevator_button_firstfloor = getent("elevator_button_firstfloor", "targetname");
	elevator_button_secondfloor = getent("elevator_button_secondfloor", "targetname");

	//securityElevCables = GetEnt ("securityElevCables", "targetname"); // cables that connect the ele and then are shot out later
	securityElevInnerLeftDoor = GetEnt ("securityElevInnerLeftDoor", "targetname");
	securityElevInnerRightDoor = GetEnt ("securityElevInnerRightDoor", "targetname");

	securityElevOuterLeftDoor_00 = GetEnt ("securityElevOuterLeftDoorMainHall_00", "targetname");
	securityElevOuterRightDoor_00 = GetEnt ("securityElevOuterRightDoorMainHall_00", "targetname");

	securityElevOuterLeftDoor = GetEnt ("securityElevOuterLeftDoorMainHall", "targetname");
	securityElevOuterRightDoor = GetEnt ("securityElevOuterRightDoorMainHall", "targetname");

	securityElevOuterLefttDoorSecRoom = GetEnt ("securityElevOuterLefttDoorSecRoom", "targetname");
	securityElevOuterRightDoorSecRoom = GetEnt ("securityElevOuterRightDoorSecRoom", "targetname");

	EleFloor_light = GetEnt ("EleFloor_light", "targetname"); // small light that shows us what level we are on...
	//	ele_corona_2 = ele_corona("ele_corona", "targetname");
	//	ele_corona_2 linkto( EleFloor_light H);

	// spawn model and then move it... 	
	EleLightModel = Spawn( "script_model", ( -17, 3113, 3.5 ));
	// -17.5, 3116.2, -0.2
	//EleLightModel SetModel( "p_lit_recessed_fixture" );
	EleLight = GetEnt ("EleLight", "targetname"); // d light that moves with elevator
	//EleLightCover = GetEnt ("EleLightCover", "targetname"); // light cover that gets knocked off
	//	playfx ( level._effect["science_elevator_light"], EleLightCover.origin + (0, 0, 0), (0,0,1) );
	//	playfx ( level._effect["science_elevator_shortcircuit"], EleLightCover.origin + (0, 0, 0), (0,0,1) );

	securityElevHatch = GetEnt ("fxanim_elevator_hatch", "targetname");
	securityElevReentry_clip = getent("elev_reentry_clip", "targetname");
	securityElevHatch_clip = getent("securityElevHatch_clip", "targetname");
	securityElevHatch_ladder = getent("securityElevHatch_ladder", "targetname");
	securityElevHatch_trig = getent("trigger_enter_ele_climb", "targetname");
	securityElevHatch_trig trigger_off();
	//securityElevHatch = GetEnt ("securityElevHatch", "targetname");
	securityElevLitButton = GetEnt ("EleFloor_light", "targetname");
	//securityElevHatchLadder = GetEnt ("securityElevHatchLadder", "targetname");

	level.elevator_light_floor0 LinkTo(securityElevMain);
	level.elevator_light_floor1 LinkTo(securityElevMain);
	level.elevator_light_floor2 LinkTo(securityElevMain);
	securityElevInnerLeftDoor LinkTo(securityElevMain);
	securityElevInnerRightDoor LinkTo(securityElevMain);

	//	EleLight_null ( 224, 6, 1, 1 );
	//fix the d light offset 
	og_angles = elelight.angles;
	EleLight linkLightToEntity(securityElevMain);
	EleLight.origin = (0,0,0);	//this is an offset value from the parent entity's origin 
	EleLight.angles = og_angles;

	EleFloor_light LinkTo(securityElevMain);
	EleLightModel LinkTo(securityElevMain);
	//EleLightCover LinkTo(securityElevMain);
	securityElevHatch LinkTo(securityElevMain);
	securityElevReentry_clip LinkTo(securityElevMain);
	securityElevHatch_clip LinkTo(securityElevHatch, "hatch_jnt");
	securityElevHatch_ladder LinkTo(securityElevHatch, "hatch_jnt");
	//securityElevCables movez ( 224, 6, 1, 1 );


	elevator_button_basement LinkTo(securityElevMain);
	elevator_button_firstfloor LinkTo(securityElevMain);
	elevator_button_secondfloor LinkTo(securityElevMain);

	//sparks = GetEnt("elevator_sparks", "targetname");

	//securityElevMain MoveTo((-14, 3112, 789), .05);	// this is the starting position on the basement floor, moving from (-14, 3112, 1013)
	securityElevMain movez ( -224, 0.1 );

	// fix the bug where they can run out of the elevator and break the level
	// this will open the doors back up until they stay in the trigger
	while(1)
	{
		trigger = GetEnt( "basement_start_ele", "targetname" );
		trigger waittill ( "trigger" );
		
		//securityElevInnerRightDoor playsound("Elevator_Doors_Open");
		//moving inner doors
		securityElevInnerLeftDoor movex ( -35.0, 1.0, 0.25, 0.25);
		securityElevInnerRightDoor movex ( 35.0, 1.0, 0.25, 0.25);
		securityElevInnerRightDoor playsound("Elevator_Doors_close");
		securityElevInnerRightDoor waittill("movedone");

		if(!(level.player istouching(trigger)))
		{
			// open the doors
			securityElevInnerLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
			securityElevInnerRightDoor movex ( -35.0, 1.0, 0.25, 0.25);
			securityElevInnerRightDoor playsound("Elevator_Doors_Open");
			securityElevInnerRightDoor waittill("movedone");
		}
		else
		{
			break;
		}

		wait(0.05);
	}

	// turn off the console dynamic light
	if(isdefined(level.console_light))
	{
		level.console_light setlightintensity(0);
		//iprintlnbold("console light off");
	}
	// turn off the rope dynamic light
	if(isdefined(level.rope_light))
	{
		level.rope_light setlightintensity(0);
		//iprintlnbold("rope light off");
	}

	//basement_blocker movez ( -80/*-224*/, 0.03/*, 0.1, 0.1*/); // move so player can't chees this out.

	// DCS: hack fix to keep player from leaving elevator and breaking the level.
	//level.player freezecontrols( true );
	//	player_stick( true );

	level notify ( "ready_mainhall" );

	level notify("endmusicpackage");

	//level.player freezecontrols( false );
	//player_unstick();

	securityElevInnerLeftDoor LinkTo(securityElevMain);
	securityElevInnerRightDoor LinkTo(securityElevMain);

	// clean up the basement entities
	thread delete_all_ai();
	thread delete_basement_spawners();
	thread delete_basement_triggers();
	// turn off the cutscene that's playing on the computer monitor
	level notify("cutscene_done");

	// grab damage trigger and move it along with the ele so the player can shoot it and send it crashing to the ground.
	securityElevBondAwareness = GetEnt ("securityElevHatchDamage", "script_noteworthy");
	//securityElevBondAwareness linkto("securityElevMain", "",(0,0,0), (0,0,0));

	wait( 1 );
	//securityElevHatchLadder movez ( 374, 0.6, 0.25, 0.25); // this goes down way to to far

	// gets trigger inside elev and waits for usage.
	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
	//trig = GetEnt ("securityElevTrigger", "targetname");  
	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
	//trig usetriggerrequirelookat();
	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
	//trig waittill ("trigger");
	//securityElevInnerRightDoor playsound("Elevator_Doors_Open");
	wait( 1 );
	////moving inner doors
	//securityElevInnerLeftDoor movex ( -35.0, 1.0, 0.25, 0.25);
	//securityElevInnerRightDoor movex ( 35.0, 1.0, 0.25, 0.25);
	//securityElevInnerRightDoor playsound("Elevator_Doors_close");

	level notify ("vo_going_down_ele_sec_os1"); // play sound off of player in main_hall_audio_earpiece
	wait( 0.5 );

	// Put in ele sound forSteveg sound
	level.player playsound("Elevator_To_Dimitrios");
	wait( 2.6 );

	// this makes sure that the doors are open that the player can get through here
	securityElevOuterLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevOuterRightDoor movex ( -35.0, 1.0, 0.25, 0.25);

	wait( 2 );
	//moving outer doors
	securityElevOuterLefttDoorSecRoom movex ( -35.0, 1.0, 0.25, 0.25);
	securityElevOuterRightDoorSecRoom movex ( 35.0, 1.0, 0.25, 0.25);

	wait (1.0);
	//savegame("MiamiScienceCenter");

	if (Getdvar("cinematicText") == "on")
	{
		//	iprintlnbold("playing elevator moving up sound.");	
	}

	// when triggered, this sends the elev UP to the main floor. (Doors not yet opened)
	level notify("elevator_up");
	securityElevMain movez ( 224, 6, 1, 1);

	wait ( 7 );
	//securityElevInnerRightDoor waittill ( "movedone" );

	//savegame("MiamiScienceCenter");
	//autosave_by_name("elevator");


	securityElevInnerLeftDoor Unlink();
	securityElevInnerRightDoor Unlink();

	//// DCS: Moved from end of boss fight to destroy elev. (bug 15346)
	level notify ("vo_locate_on_first_floor_os2");
	level thread thug_attack_elev();

	securityElevInnerLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor movex ( -35.0, 1.0, 0.25, 0.25);

	securityElevOuterLeftDoor_00 movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevOuterRightDoor_00 movex ( -35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor playsound("Elevator_Doors_Open");

	//// DCS: removing boss knife fight. (bug 15346)
	/*
	//avulaj this is where sciencecenter_b boss fight starts from the 1st playable settings

	trigger_boss = getent("trigger_start_boss", "targetname");
	trigger_boss waittill("trigger");
	level notify ("start_main_hall_boss_fight");// start fight	

	wait( 3.5 ); 
	securityElevInnerLeftDoor movex ( -35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor playsound("Elevator_Doors_Close");


	level waittill ("continue_elevator_sequence"); // fight over continue level



	securityElevInnerLeftDoor movex ( 35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor movex (- 35.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor playsound("Elevator_Doors_Open");
	*/	

	//// DCS: Moved from end of boss fight to destroy elev. (bug 15346)

	wait(1.0);
	level notify("thug_attack_elev_now");
	wait(0.05);
	level notify("dimi_run_now");

	wait(1.0 );

	//moving inner doors
	securityElevInnerLeftDoor movex ( -15.0, 0.7, 0.25, 0.25);
	securityElevInnerRightDoor movex ( 15.0, 0.7, 0.25, 0.25);

	//moving outer doors
	securityElevOuterLeftDoor_00 movex ( -25.0, 0.7, 0.25, 0.25);
	securityElevOuterRightDoor_00 movex ( 25.0, 0.7, 0.25, 0.25);
	securityElevInnerRightDoor playsound("Elevator_Doors_Jammed");

	wait( 0.3 );
	earthquake( 0.15, 0.4, level.player.origin, 2050 );

	wait( 0.5 );

	//moving inner doors
	securityElevInnerLeftDoor movex ( -3, 0.7, 0.01, 0.01);
	securityElevInnerRightDoor movex ( 3, 0.7, 0.01, 0.01);
	securityElevInnerRightDoor waittill ("movedone");
	wait( 0.2 );

	//moving outer doors
	securityElevOuterLeftDoor_00 movex ( -5, 0.7, 0.01, 0.01);
	securityElevOuterRightDoor_00 movex ( 5, 0.7, 0.01, 0.01);

	wait( 1.3 );
	// throw a box that is like a grenade that lands near the elevator == didn't have time for this
	// drop the elevator, first drop
//iprintlnbold("exp 1");
	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	securityElevInnerLeftDoor LinkTo(securityElevMain);
	securityElevInnerRightDoor LinkTo(securityElevMain);

//iprintlnbold("movez 1");
	securityElevMain movez ( -15, 0.4, 0.1, 0.1 );

//iprintlnbold("exp 2");
	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

//iprintlnbold("sound 1");
	securityElevMain playsound("Elevator_Wild_Ride");
	securityElevInnerLeftDoor thread sound_ele_loop_here(); // extra loop sound for steve
	securityElevMain waittill ("movedone");
//iprintlnbold("quake 1");
	earthquake( 0.15, 1, level.player.origin, 2050 );
	EleLight thread light_flicker(true, 0, 1.5);

	earthquake( 0.15, 0.4, level.player.origin, 2050 );

	wait 1;

	EleLight thread light_flicker(false, .8);

	// wait a few seconds, play a sound and then drop it again...
	wait ( 1.3 );

//iprintlnbold("exp 3");
	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	// drop 2
	securityElevMain movez ( -20, 0.5, 0.1, 0.1);
	securityElevMain waittill ("movedone");

//iprintlnbold("exp 4");
	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	EleLight thread light_flicker(true, 0, 1.5);
	earthquake( 0.20, 1, level.player.origin, 2050 );
	playfx ( level._effect["ele_dust2a"], securityElevMain.origin + (0, 0, -100));

	wait 1.4;

	EleLight thread light_flicker(false, .8);

	// drop 3
	wait( 2.0 );
	//thread elevator_tiles();

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	EleLight thread light_flicker(true, 0, 1.5);
	securityElevMain movez ( -27, 0.22, 0.1, 0.1 );

	//securityElevCables movez ( -27, 0.22, 0.1, 0.1 );
	securityElevMain waittill ("movedone");

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	earthquake( 0.5, 0.7, level.player.origin, 2050 );
	playfx ( level._effect["ele_dust2a"], securityElevMain.origin + (0, 0, -100));
	//playfx ( level._effect["science_elevator_shortcircuit"], securityElevMain.origin + (0, 0, 20));

	spark((-44.3, 3053, 125.6));
	//spark(GetEnt("elevator_sparks", "targetname").origin);
	EleLight thread light_flicker(false, .8);

	// drop 4
	wait ( 6 );

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	EleLight thread light_flicker(true, 0, 1.2);
	securityElevMain movez ( -30, 0.23, 0.1, 0.1 );
	securityElevMain waittill ("movedone");

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	earthquake( 0.3, 0.2, level.player.origin, 2050 );
	playfx ( level._effect["ele_dust2a"], securityElevMain.origin + (0, 0, -100));

	wait( 0.1 );

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	securityElevMain movez ( -5, 0.10, 0.01, 0.01 );
	securityElevMain waittill ("movedone");

	PhysicsExplosionSphere(level.player.origin, 300, 300, .1);

	playfx ( level._effect["ele_dust2a"], securityElevMain.origin + (0, 0, -100));
	earthquake( 0.8, 1, level.player.origin, 2050 );
	level notify("player_cause_ele_crash");
	level notify("elevator_down");
	
	//maps\_autosave::autosave_now("MiamiScienceCenter");
	level notify("checkpoint_reached"); // checkpoint 6

	wait(2.0);
	//////////////////////////////////////////
	// use the last earthquake so that we can move the player away from the hatch
	//	this needs to be more dramatic
	// close the elevator doors so the player can't see that we're faking the tilt
	securityElevInnerLeftDoor Unlink();
	securityElevInnerRightDoor Unlink();

	securityElevInnerLeftDoor movex(-17.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor movex(17.0, 1.0, 0.25, 0.25);
	securityElevInnerRightDoor playsound("Elevator_Doors_close");
	securityElevInnerRightDoor waittill("movedone");

	securityElevInnerLeftDoor LinkTo(securityElevMain);
	securityElevInnerRightDoor LinkTo(securityElevMain);

	player_stick(true); // use this so the player still has camera control
	//level.player freezeControls(true);

	// spawn an origin to link the player to
	mover = spawn("script_origin", level.player.origin);
	mover.angles = level.player.angles;
	level.player linkto(mover);

	// spawn a "ground"
	ground = spawn("script_origin", level.player.origin);
	level.player PlayerSetGroundReferenceEnt(ground);
	// rotate the ground to change the view (this makes it look like we've tilted)
	// drop 1
	earthquake(0.8, 1, level.player.origin, 2050);
	ground playsound("wpn_dad_impact");
	ground rotatepitch(-55.0, 0.22, 0.1, 0.1);
	//ground waittill("rotatedone");

	// move the player
	move_to_pos = (30.0, level.player.origin[1], level.player.origin[2]);
	time = 0.5;
	accel = 0.4;
	decel = 0.1;
	mover moveto(move_to_pos, time, accel, decel);
	mover waittill("movedone");
	//// rotate the player so they are looking at the hatch when it falls
	//rot_to_angles = vectortoangles(securityElevHatch.origin - level.player.origin);
	//mover rotateto((0, rot_to_angles[1], 0), time, 0.1, 0.4);
	//mover waittill("rotatedone");

	// save and drop the hatch
	//thread maps\_autosave::autosave_now("MiamiScienceCenter");
	//wait(2.0);

	securityElevMain playsound("Elevator_Hatch_Fall_Open");
	level notify("elevator_hatch_start");

	//// once the hatch starts to fall, force the player into crouch
	//level.player allowstand(false);
	//wait(1.0);
	//level.player allowstand(true);
	// move the ladder clip back to position
	if(isdefined(ladder))
		ladder trigger_on();


	wait(2.0);

	// now rotate the ground back to level
	earthquake(0.5, 1, level.player.origin, 2050);
	ground playsound("wpn_dad_impact");
	ground rotatepitch(55.0, 0.22, 0.1, 0.1);
	ground waittill("rotatedone");

	level.player unlink();
	level.player PlayerSetGroundReferenceEnt(undefined);
	
	player_unstick();
	//level.player freezeControls(false);

	// delete the spawned
	ground delete();
	mover delete();
	//////////////////////////////////////////

	wait(1.0);
	level notify ("vo_cant_lock_the_elevator_os2");
	
	//securityElevHatch Unlink();
	//securityElevHatch rotateto ( ( 0, 0 , -90), 0.3, 0.1, 0.1 );

	//VisionSetNaked( "sciencecenter_b_05", 1.0);

	//securityElevHatch waittill("rotatedone");
	//securityElevHatch LinkTo(securityElevMain);

	// DCS: timescale prep.
	level thread force_camera_initializer();

	//savegame("MiamiScienceCenter");
	//autosave_by_name("boss_fight_done");	// a save happends when dimitrios dies, so I don't think we need this one

	//		securityElevHatch waittill ("rotatedone");
	//		securityElevHatchLadder rotateto ( (0, 0 ,-45), 0.3, 0.1, 0.1 );

	//		securityElevHatch waittill ("rotatedone");
	//	Print3d( securityElevHatchLadder, "LADDER PUNK", color, 1, scale, 120 );
	//		securityElevHatch waittill ("rotatedone");
	//		securityElevHatch rotateto ( (0, 0 ,7), 0.3, 0.1, 0.1 );
	//		securityElevHatch waittill ("rotatedone");

	//		securityElevHatch rotateto ( (0, 0 ,-3), 0.3, 0.1, 0.1 );

	//		securityElevHatch rotateto ( (0, 0 ,1), 0.3, 0.1, 0.1 );
	//		securityElevHatch waittill ("rotatedone");
	//		securityElevHatch rotateto ( (0, 0 ,-1), 0.3, 0.1, 0.1 );
	//		iprintlnbold( "move ladder start" );
	// drop down ladder aftter ele moves
	//securityElevHatchLadder movez ( -247, 1.0, 0.25, 0.25); 
	//		iprintlnbold( "move ladder done" );
	//wait( 1 );
	//level notify ("vo_locate_on_first_floor_os2");
	securityElevOuterLeftDoor_00 movex ( -5, 0.7, 0.01, 0.01);
	securityElevOuterRightDoor_00 movex ( 5, 0.7, 0.01, 0.01);

	EleLight thread light_flicker(false, .5);
	wait 1.5;
	EleLight thread elevator_light_flicker();

	// Disabled for beta.  Doesn't really work for some reason and Bond was getting stuck on the tiles.	
	//tiles = array_randomize(tiles);
	//for (i = 0; i < tiles.size; i++)
	//{
	//	tiles[i] UnLink();
	//	tiles[i] PhysicsLaunch(tiles[i].origin, (0, 0, -1));
	//}

	// delete when 
	level waittill("player_cause_ele_crash");
	EleLightModel delete();

	//TEMP COMMENTED OUT UNTILL 1st PLAYABLE IS DONE
	//trig delete();
}

elevator_light_flicker()
{
	self endon("player_cause_ele_crash");
	while (true)
	{
		self thread light_flicker(true, 0, .8);
		wait RandomFloatRange(2, 3);
		self thread light_flicker(false, .5);
		wait RandomFloatRange(3, 5);
	}
}



// jluyties give the player a machine gun when he comes out of the ele sequence...
//give_player_weapons_after_ele()
//{
//	//level.player giveweapon( "scar" );
//	//level.player GiveWeapon( "p99_silenced" );
//	//level.player GiveMaxAmmo ( "p99_silenced" );
//	//level.player giveMaxAmmo( "scar" );
//	//level.player giveweapon( "mp5_foregrip" );
//	//level.player giveMaxAmmo( "mp5_foregrip" );
//	//level.player switchtoWeapon( "mp5_foregrip" );
//}

// Looping creak sound for steve here, bugs with sounds so this is in a seperate function
sound_ele_loop_here()
{
	wait( 15.1 );
	self playloopsound("Elevator_Creak_Loop");
	level waittill("stop_ele_creak_sound");
	self stoploopsound();
}

//loop_ele_doors_broken() // was going to make ele doors open and twitch.. can't till they are all linked
//{
//	securityElevInnerLeftDoor = GetEnt ("securityElevInnerLeftDoor", "targetname");
//	securityElevInnerRightDoor = GetEnt ("securityElevInnerRightDoor", "targetname");
//
//	while( 1 )
//	{
//		securityElevInnerLeftDoor movez ( -5, 2, 1, 0.1 );
//		securityElevInnerRightDoor movez ( -8, 2, 1, 0.1 );
//		wait randomfloat(0.2, 1); 
//		securityElevInnerLeftDoor movez ( 5, 2, 1, 0.1 );
//		securityElevInnerRightDoor movez ( 8, 2, 1, 0.1 );
//		wait randomfloat(0.2, 1);
//		securityElevInnerLeftDoor movez ( -7, 2, 1, 0.1 );
//		securityElevInnerRightDoor movez ( -3, 2, 1, 0.1 );
//		wait randomfloat(0.2, 1);
//		securityElevInnerLeftDoor movez ( 7, 2, 1, 0.1 );
//		securityElevInnerRightDoor movez ( 3, 2, 1, 0.1 );
//		wait randomfloat(0.2, 1);
//		securityElevInnerLeftDoor movez ( -7, 2, 1, 0.1 );
//		securityElevInnerRightDoor movez ( -3, 2, 1, 0.1 );
//	} 
//}

//// basic 3d object // test print
//print_3d_object_test()
//{
//	color = ( 0, .5, 0 );            
//	scale = 1.5;
//	while( 1 )
//	{
//		Print3d( self.origin, "LADDER PUNK", color, 1, scale, 120 );
//		wait( 1 );
//	}
//}

// jl bond can shoot this when he gets to the top of the elevator and drops it down the shaft
// you need to set this up in one location and then thread it to it's correct functions
elevator_shot_by_bond_and_falls()
{

	//these are the params for the camera detach function
	//cameraID = customCamera_push(
	//	cameraType,     //<required string, see camera types below>
	//	originEntity,      //<required only by "entity" and "entity_abs" cameras>
	//	targetEntity,     //<optional entity to look at>
	//	offset,              // <optional positional vector offset, default (0,0,0)>
	//	angles,            // <optional angle vector offset, default (0,0,0)>
	//	lerpTime,         // <optional time to 'tween/lerp' to the camera, default 0.5>
	//	lerpAccelTime, // <optional time used to accel/'ease in', default 1/2 lerpTime> 
	//	lerpDecelTime, // <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
	//	);

	//customCamera_pop(
	//cameraID,        // <required ID returned from customCameraPush>
	//lerpTime,         // <optional time to 'tween/lerp' to the previous camera, default prev camera>
	//lerpAccelTime, // <optional time used to accel/'ease in', default prev camera> 
	//lerpDecelTime, // <optional time used to decel/'ease out', default prev camera>
	//);

	//To change a camera mid-use, use the 'customCamera_change' function. 
	//
	//customCamera_change(
	//cameraID,         // <required ID returned from customCameraPush>
	//cameraType,     //<required string, see camera types below>
	//originEntity,      //<required only by "entity" and "entity_abs" cameras>
	//targetEntity,     //<optional entity to look at>
	//offset,              // <optional positional vector offset, default (0,0,0)>
	//angles,            // <optional angle vector offset, default (0,0,0)>
	//lerpTime,         // <optional time to 'tween/lerp' to the camera, default 0.5>
	//lerpAccelTime, // <optional time used to accel/'ease in', default 1/2 lerpTime> 
	//lerpDecelTime, // <optional time used to decel/'ease out', default (lerpTime - lerpAccelTime)>
	//);

	securityElevMain = GetEnt ("securityElevMain", "targetname");

	//ele_crash = getent("ElelvatorCrash", "script_noteworthy");

	// now waittill a notify occurs
	level waittill("start_elev_crashing");
	//wait( 3.5 );

	// wait till the player hits this trigger
	//ele_crash thread force_ele_crash();

	//ele_crash waittill("trigger");
	securityElevMain playsound("Elevator_Crash");
	wait( .050 );
	level notify("stop_ele_creak_sound");
	level notify("on_second_floor");
	//level notify("objective_2_done");
	//level thread ele_music_play_hack();

	thread elevator_sparks();
	//thread drop_panels();

	// changes timing of climbing up now.. the fall is longer.
	//iprintlnbold("elevator pos: " + securityElevMain.origin[2]);
	securityElevMain movez ( -700, 0.8, 0.5, 0.1 );

	securityElevMain waittill ("movedone");
	//iprintlnbold("elevator pos: " + securityElevMain.origin[2]);
	earthquake( 0.20, 1, level.player.origin, 2050 );
	//level notify ("vo_cant_lock_the_elevator_os2");

	level notify("fireball");
	level.elevator_crashed = true;

	// new fireball from eco
	wait(0.45);	// this needs to match the wait value in force_camera_initializer()
	playfx(level._effect["fireball_01"], securityElevMain.origin + (0, 0, -150));
	//// ele bloom effect
	//playfx ( level._effect["elev_expl"], securityElevMain.origin + (0, 0, 0), (0,0,2) );
	//wait( 0.3 );	
	//playfx ( level._effect["elev_expl"], securityElevMain.origin + (0, 0, 50), (0,0,2) );
	//wait( 0.3 );	
	//playfx ( level._effect["elev_expl"], securityElevMain.origin + (0, 0, 150), (0,0,2) );
	//wait( 0.3 );	
	//playfx ( level._effect["elev_expl"], securityElevMain.origin + (0, 0, 450), (0,0,2) );
	//wait( 0.3 );	
	//playfx ( level._effect["elev_expl"], securityElevMain.origin + (0, 0, 650), (0,0,2) );
	//wait( 0.3 );
	//playfx ( level._effect["elev_expl"], securityElevMain.origin + (0, 0, 800), (0,0,2) );
	//wait( 0.3 );
	//playfx ( level._effect["elev_expl"], securityElevMain.origin + (0, 0, 900), (0,0,2) );	
}

//// force elevator to fall and kill the player after a certain amount of time
//// tiggers the trigger that normally trigger the elevator to fall
//force_ele_crash()
//{
//	self endon("trigger");
//	wait 30;
//	level.player DoDamage(100000, level.player.origin);
//	self notify("trigger");
//}
//ele_music_play_hack()
//{
//	wait( 3 );
//	//		iprintlnbold(" music play completed");
//	//musicplay("mus_mia_sci_center_shootout", 0); // fing hack cause of sound bug issue
//}
force_camera_initializer()
{
	enter_trigger = getEnt("trigger_enter_ele_climb", "targetname");
	enter_trigger trigger_on();
	enter_trigger waittill("trigger");
	
	//iprintlnbold("wait till ladder");
	level.player waittill("ladder", notice);
	//iprintlnbold("ladder notice " + notice);
	if(notice == "begin")
	{
		// move the clip that keeps the player from sliding down the ladder until the player gets on the ladder
		ladder_player_clip = getent("ladder_player_clip", "targetname");
		if(isdefined(ladder_player_clip))
			ladder_player_clip trigger_on();

		level notify("start_elev_crashing");
		level.exit_trigger = getEnt("trigger_exit_ele_climb", "targetname");
		thread elevator_camera();

		thread slow_down_time();

		// wait until the fireball starts, slowly increase time to 1
		level waittill("fireball");
		wait(0.45);	// this needs to match the wait value in elevator_shot_by_bond_and_falls()
		thread speed_up_time();
	}
	//iprintlnbold("wait till ladder");
	//level.player waittill("ladder", notice);
	//iprintlnbold("ladder notice " + notice);
	//if(notice == "begin")
	//{
	//	// because we use a ladder to get on the roof of the elevator
	//	iprintlnbold("wait till ladder");
	//	level.player waittill("ladder", notice);
	//	iprintlnbold("ladder notice " + notice);
	//	if(notice == "end")
	//	{
	//		iprintlnbold("wait till ladder");
	//		level.player waittill("ladder", notice);
	//		iprintlnbold("ladder notice " + notice);
	//		if(notice == "begin")
	//		{
	//			level notify("start_elev_crashing");
	//			level.exit_trigger = getEnt("trigger_exit_ele_climb", "targetname");
	//			thread elevator_camera();

	//			thread slow_down_time();

	//			// wait until the fireball starts, slow down time and slowly increase time to 1
	//			level waittill("fireball");
	//			wait(0.2);
	//			thread speed_up_time();
	//		}
	//	}
	//}
}
slow_down_time()
{
	self endon("fireball");
	// slowly start slowing down time
	while(1)
	{
		curr_timescale = getdvarfloat("timescale");
		if(curr_timescale > 0.3)
		{
			// mathmatically it's (1.0 - 0.3) / (30 * 3) or (ending timescale - current timescale) / (30 fps * 3 seconds)
			// I want the event to last 1 second for the slow down which will happen in 30 frames, so to increase from 0.3 to 1.0 we'll divide the difference 0.7 by 30 = 0.02
			curr_timescale -= 0.04; 
			SetSavedDVar("timescale", "" + curr_timescale + "");
			//iprintlnbold(curr_timescale);
		}
		else
		{
			SetSavedDVar("timescale", "0.3");
			break;
		}
		
		wait(0.05);
	}
}
speed_up_time()
{
	// slowly start speeding up time
	incrementer = 0.007;
	while(1)
	{
		curr_timescale = getdvarfloat("timescale");
		if(curr_timescale < 1.0)
		{
			// haha, increasing by 007, get it!? actually mathmatically it's (1.0 - 0.3) / (30 * 3) or (ending timescale - current timescale) / (30 fps * 3 seconds)
			// I want the event to last 3 seconds for the speed up which will happen in 90 frames, so to increase from 0.3 to 1.0 we'll divide the difference 0.7 by 90 = 0.007
			curr_timescale += incrementer; 
			SetSavedDVar("timescale", "" + curr_timescale + "");

			//iprintlnbold(curr_timescale);
			// do certain things at certain times while the fireball comes up
			if(curr_timescale > 0.47)
			{
				// kill the player if the fire reaches them
				trigger = getent("triggerhurt_elevator", "targetname");
				trigger trigger_on();

				// if we're out of the elevator (hurt trigger missed) then speed up time quicker
				incrementer = 0.05;
			}
		}
		else
		{
			SetSavedDVar("timescale", "1.0");
			break;
		}
		
		wait(0.05);
	}
}
elevator_camera()
{
	// this happens when you reach the top of the ladder from the elevator shaft
	level.exit_trigger waittill("trigger");

	wait(0.05);
	// do an earthquake and shellshock to give effect
	earthquake(0.75, 2, level.player.origin, 300);
	level.player shellshock("default", 3);
}
//// clear triggers sp player can't activate cameras again.
//clear_triggers_so_player_cant_go_down()
//{
//	exit_trigger = getEnt( "trigger_exit_ele_climb", "targetname" );
//	enter_trigger = getEnt( "trigger_enter_ele_climb", "targetname" );
//	level waittill("clear_ele_path");
//	wait( 6 );
//	exit_trigger delete();
//	enter_trigger delete();
//}

////avulaj
//// jluyties.. might be cool to see this next to the rocket guy
//spawn_carlos_leaving()
//{
//	carlos_endnode = getnode ("Carlos_EndNode", "targetname");
//	carlos_spawner = getent ("Carlos_spawner", "targetname");
//	carlos = carlos_spawner stalingradspawn( "Carlos" );
//	carlos waittill( "finished spawning" );
//	carlos lockalertstate( "alert_green" );
//	carlos setgoalnode (carlos_endnode);
//	carlos waittill	 ("goal");
//	Carlos delete(); 	
//}

//light_traps()
//{
//	entaTemp = GetEntArray( "mousetrap_large_light_fall", "targetname" );
//	if( IsDefined( entaTemp[0] ) )
//	{
//		maps\_playerawareness::setupArrayDamageOnly(	"mousetrap_large_light_fall",
//			::fall_large_lights,
//			false,
//			maps\_playerawareness::awarenessFilter_NoMeleeDamage,
//			level.awarenessMaterialNone,
//			true,
//			true );
//	}
//
//	thug_spawn = getentarray ( "mainhall_thugs_3rd", "script_noteworthy" );
//}

//// call back function on being damaged
//fall_large_lights( strcObject )
//{
//	// get primary entity
//	entAwarenessObject = strcObject.primaryEntity;
//
//	// set up tag origin
//	entOrigin = Spawn( "script_model", entAwarenessObject.origin + ( 0, 0, -32 ));
//	entOrigin SetModel( "tag_origin" );
//	entOrigin LinkTo( entAwarenessObject );
//
//	// launch model into physics
//	entAwarenessObject PhysicsLaunch( strcObject.damagePoint, vector_multiply( strcObject.damageDirection, 1000 ) );
//
//	// call dmge function
//	entOrigin thread lights_dmg();
//}

//light_dmg_davinchi()
//{
//	lights = GetEntArray( "mousetrap_large_light_fall", "targetname" );	
//	for ( i = 0; i < lights.size; i++ )
//	{
//		if( (isdefined (lights[i].script_noteworthy)) && (lights[i].script_noteworthy == "light_start_big_cowbell") )
//		{
//			lights[i] waittill ("damage");
//			if( 	level.davinchi_crashed == false  )
//			{
//				level notify("davinchi_start");
//				level notify ("end_explosion_now");
//				level.davinchi_crashed = true;
//			}
//		}
//	}
//
//}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// need to grab the light in an array, then tell it to play a different effect and send notify for moment   //
//                                              																																 //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//lights_dmg()
//{
//	level notify("lights_shot");
//	playfx ( level._effect["science_lamp_burst"], self.origin + (0, 0,10), (0,0,2) );
//	for( i = 0; i < 2; i++ )
//	{
//		RadiusDamage( self.origin + (0, 0, -32), 64, 250, 200 ); // kill guys near this
//		physicsExplosionSphere( self.origin + (0, 0, 0), 150, 100, 1 ); //send any dudes in the area flying through the air
//	}
//	wait( 0.9 );
//	self playsound ("Light_Fixture_Crash");
//	playfx ( level._effect["elev_expl"], self.origin + (0, 0,10), (0,0,2) ); // call in effect when light is shot.
//	wait( 1 );
//	self Delete();
//}


//// lights turning on and off
//back_darkness_move()
//{
//	//	trigger = getent ( "back_darkness_move", "targetname" );
//	//	trigger waittill ( "trigger" );
//	//	iprintlnbold ( "light_flicker" );
//
//	light = getent ( "lobbyspot4", "targetname" );
//	//	light_fix_start = getent ( "back_light_model", "targetname" );
//
//	//dark = getent ( "back_the_darkness", "targetname" );
//	//org = getent ( "back_darkness_goto", "targetname" );
//	//dark movex ( -4400, 1 );
//	j = randomint( 10 );
//	level endon ( "roof_access" );
//
//	while( 1 )
//	{
//		light setlightintensity ( 0 );
//		wait( 1.5 );
//		light setlightintensity ( 3.5 );
//		wait( 1.5 );
//
//	}
//
//	//	while ( 1 )
//	//	{
//	//		wait ( .5 );
//	//		if ( level.light_flicker == 0 )
//	//		{
//	//iprintlnbold ( "light_by_door_flickered_off" );
//	//			light_fix_start setmodel ( "com_lightbox" );
//	//			light setlightintensity ( 0 );
//	//			wait( .05 + randomfloat( .1 ) );
//
//	//			light_fix_start setmodel ( "com_lightbox_on" );
//	//			light setlightintensity ( 1.5 );
//	//			wait( .05 + randomfloat( .1) );
//
//	//			light_fix_start setmodel ( "com_lightbox" );
//	//			light setlightintensity ( 0 );
//	//			wait( .05 + randomfloat( .1 ) );
//
//	//			level.light_flicker++;
//	//dark moveto ( org.origin, 1 );
//	//			wait( 10 + randomfloat( 15 ) );
//
//	//		}
//	//		else if ( level.light_fer == 1 )
//	//		{
//	//iprintlnbold ( "light_by_door_flickered_on" );
//	//			light_fix_start setmodel ( "com_lightbox_on" );
//	//			light setlightintensity ( 1.5 );
//	//			wait( .05 + randomfloat( .1 ) );
//
//	//			light_fix_start setmodel ( "com_lightbox" );
//	//			light setlightintensity ( 0 );
//	//			wait( .05 + randomfloat( .1) );
//
//	//			light_fix_start setmodel ( "com_lightbox_on" );
//	//			light setlightintensity ( 1.5 );
//	//			wait( .05 + randomfloat( .1 ) );
//
//	//			level.light_flicker--;
//	//dark movex ( -4400, 1 );
//	//			wait( 10 + randomfloat( 15 ) );
//	//		}
//	//	}
//}

//// helicopter above
//roof_helo_fly_over_main_hall()
//{
//	front_heli_spawn_point = getent( "front_heli_spawn_point_2", "targetname" );
//
//	spawnvehicle("v_heli_mdpd_low", "roof_hilo", "blackhawk", (front_heli_spawn_point.origin), (front_heli_spawn_point.angles));
//	vehicle = getent( "roof_hilo", "targetname" );
//	vehicle sethoverparams(128, 10, 3);
//	//vehicle maps\_vehicle::show_rigs( 4 ); // back
//	//vehicle maps\_vehicle::show_rigs( 5 ); // front
//
//
//	vehicle.health = 10000;
//	vehicle thread under_light();
//	//	vehicle helicopter_searchlight_on();
//
//	//vehicle playloopsound ("Police_Helicopter");
//	wait ( 0.1 );
//	level notify ("vo_police_notified_running_out_of_time_os2");
//
//	while( 1 )
//	{
//		wait( 3 );
//		//	level waittill ( "helo_fly_over_back_forth" );
//		vehicle setspeed(10, 4, 4);
//
//		org = spawn("script_origin",  (-201, 787, 138) );
//
//		//		vehicle setvehgoalpos (( 92, 2466, 436 ), 0 );
//		vehicle setvehgoalpos (( 8, 2232, 1200 ), 0 );
//		vehicle waittill ( "goal" );
//
//		vehicle setspeed(10, 4, 4);
//		//		vehicle setvehgoalpos (( -201, 787, 138 ), 0 );
//		vehicle setvehgoalpos (( 0, 560, 1200), 0 );
//		vehicle waittill ( "goal" );
//	}
//	vehicle delete();
//}

//under_light()
//{
//	//org = getent ( "front_heli_spawn_point", "targetname" );
//	entOrigin = Spawn( "script_model", self GetTagOrigin( "tag_ground" ) );
//	entOrigin SetModel( "tag_origin" );
//	entOrigin.angles = ( 0, 0, 75);
//	entOrigin LinkTo( self );
//
//	// playfx
//	playfxontag ( level._effect["science_lightbeam05"], entOrigin, "tag_origin" );
//	//	playfxontag ( level._effect["spotlight"], entOrigin, "tag_origin" );
//
//
//	// loop helicopter back and fourth with rotating effect
//	while( 1 ) // looks like I can't rotate a child
//	{
//		entOrigin RotateTo ( ( 165, 0, 0 ), 12, 2, 2 );
//		entOrigin waittill("movedone"); 
//		entOrigin RotateTo ( ( -165, 0, 0 ), 12, 2, 2 );
//		entOrigin waittill("movedone"); 
//	}
//}

//// hear speakered police speaking above, never got this argh!!!
//roof_helo_dialogue()
//{
//	level waittill("mainhall_police_copter_speak");
//	//		iprintlnbold("Attention, Attention,");
//	wait( 4 );
//	//		iprintlnbold("This is the POPO, I repeat this the ghetto bird!!!");
//	wait( 4 );
//	//		iprintlnbold("Drop all your weapons exit the building immediately!!!");
//}

/////////// new heli spotlight ////////////////////////////////////


//helicopter_searchlight_on()
//{
//	while ( distance( level.player.origin, self.origin ) > 7000 )
//	{
//		wait 0.2;
//	}
//
//	//	helicopter_searchlight_off();
//
//	//	self startIgnoringSpotLight();
//
//	//	playfxontag (level._effect["spotlight"], self, "tag_barrel");
//	self spawn_searchlight_target();
//	self helicopter_setturrettargetent( self.spotlight_default_target );
//
//	self.dlight = spawn( "script_model", self gettagorigin("tag_barrel") );
//	self.dlight setModel( "tag_origin" );
//
//
//	self thread helicopter_searchlight_effect();
//
//	level.fx_ent = spawn( "script_model", self gettagorigin("tag_barrel") );
//	level.fx_ent setModel( "tag_origin" );
//	level.fx_ent linkto( self, "tag_barrel", ( 0,0,0 ), ( 0,0,0 ) );
//
//	wait 0.5;
//	//	playfxontag (level._effect["spotlight"], self, "tag_barrel");
//	playfxontag (level._effect["spotlight"], level.fx_ent, "tag_origin");
//}


//spawn_searchlight_target()
//{
//	spawn_origin = self gettagorigin( "tag_ground" );
//
//	target_ent = spawn( "script_origin", spawn_origin );
//	target_ent linkto( self, "tag_ground", (320,0,-256), (0,0,0) );
//	self.spotlight_default_target = target_ent;
//	self thread searchlight_target_death();
//}

//helicopter_searchlight_effect()
//{
//	self endon("death");
//
//	self.dlight.spot_radius = 256;
//	self thread spotlight_interruption();
//
//	count = 0;
//	while( true )
//	{
//		targetent = self helicopter_getturrettargetent();
//
//		if ( isdefined( targetent.spot_radius ) )
//			self.dlight.spot_radius = targetent.spot_radius;
//		else
//			self.dlight.spot_radius = 256;
//
//		vector = anglestoforward( self gettagangles( "tag_barrel" ) );
//		start = self gettagorigin( "tag_barrel" );
//		end = self gettagorigin( "tag_barrel" ) + vector_multiply ( vector, 3000 );
//
//		trace = bullettrace( start, end, false, self );
//		dropspot = trace[ "position" ];
//		dropspot = dropspot + vector_multiply ( vector, -96 );
//
//		self.dlight moveto( dropspot, .5 );
//
//		wait .5;
//	}
//}

//helicopter_getturrettargetent()
//{
//	return self.current_turret_target;
//}

//spotlight_interruption()
//{
//	self endon( "death" );
//	level endon( "player_interruption" );
//
//	while ( distance( level.player.origin, self.dlight.origin ) > self.dlight.spot_radius )
//		wait 0.25;
//
//	//	iprintln ( distance( level.player.origin, self.dlight.origin ) );
//	//	iprintln ( self.dlight.spot_radius ) ;
//
//	flag_set( "player_interruption" );
//}

//searchlight_target_death()
//{
//	ent = self.spotlight_default_target;
//	self waittill( "death" );
//	ent delete();
//}

//helicopter_setturrettargetent( target_ent )
//{
//	if ( !isdefined( target_ent ) )
//		target_ent = self.spotlight_default_target;
//
//	self.current_turret_target = target_ent;
//	self setturrettargetent( target_ent );
//}

/////////////////////////////////////////////////////////////
// call all vo over headset here for bond for main hall    //
/////////////////////////////////////////////////////////////
main_hall_audio_earpiece()
{
	level waittill ("vo_going_down_ele_sec_os1");
	// Secrurity S.O, 
//iprintlnbold("main_hall_audio_earpiece 1");
	level.player play_dialogue ("SCS3_SciBG02A_037A", true); // All Teams, roof security has been compromised.

	level waittill ("vo_locate_on_first_floor_os2");
	// SC security merc o.s, call after the ele doors open and the three thugs say thier lines
	level.player play_dialogue ("SHM3_SciBG02A_042A", false); // Son of a bitch.
	
	// Dimitrious Taunt as he's running away, adding because we need some sound here - crussom
	level.dimitrios play_dialogue ("DIMI_SciBG02A_039A", false); // whoever you are, carlos is gone

	level waittill ("vo_cant_lock_the_elevator_os2");
	wait( 4 );
	// say this line after the ele crashes and the guys scream
	// SC security merc o.s
//iprintlnbold("main_hall_audio_earpiece 3");
	level.player play_dialogue ("SCS3_SciBG02A_051A", true); // We have a problem. Hall Team, I can't lock the elevator.

	level waittill ("vo_He_is_on_the_second_floor_os2");
	// second floor
	// SC security merc o.s
//iprintlnbold("main_hall_audio_earpiece 4");
	level.player play_dialogue ("SCS3_SciBG02A_052A", true); // Enemy on second floor.  Hold him there.

	// wait till rocket hits
	//level waittill ("vo_trucks_get_out_of_here_os2");
	//	level waittill ("rocket_hit_wall");
	wait( 4 ); // not being called.
	// then later
//iprintlnbold("main_hall_audio_earpiece 5");
	level.player play_dialogue ("SCS3_SciBG02A_053A", true); // All trucks, get the cargo out now, take what you've got and go.  Rendezvous is at twenty three hundred at backup location.  Repeat: fall back to secondary rendezvous.

	level waittill ("vo_everyone_to_the_first_floor_os2");
	// player gets to first floor and then is attacked
	// SC security merc o.s
//iprintlnbold("main_hall_audio_earpiece 6");
	level.player play_dialogue ("SCS3_SciBG02A_056A", true); // All remaining personel to first floor.  Enemy is in main hall.  Take him out.

	wait( 2.3 );
	//level waittill ("vo_enemy_cannot_be_allowed_to_escape_os2");
	// one second later during second wave
	// SC security merc o.s
//iprintlnbold("main_hall_audio_earpiece 7");
	level.player play_dialogue ("SCS3_SciBG02A_057A", true); // The intruder cannot be allowed to exit the building.  Contain and eliminate.

	//wait( 5 );
	//	level waittill ("vo_police_notified_running_out_of_time_os2");
	// after player has shot down heli
	// Security os
	// line All Teams: Miami Dispatch has just notified fire and police.  We are running out of time.
	//level.player playSound ("SCS3_SciBG02A_073A");

	//level waittill ("vo_bird_reports_shots_fired_os2");
	//wait( 3.2 );
	// When heli shines light into hall
	// Security os
	// line Miami Police are en route.  Their bird reports shots fired at this location.  It's now or never.  Take this guy down.
	//level.player playSound ("SCS3_SciBG02A_074A");

	level waittill ("vo_enemy_is_trapped_hold_positions_os2");
	// when second wave merc attack begins
	// secuirty os
//iprintlnbold("main_hall_audio_earpiece 8");
	level.player play_dialogue ("SCS3_SciBG02A_075A", true); // The enemy is trapped.  Hold your positions.  The front door is his only way out.  This is where you finish it.

	wait(4.0);

	//level waittill ("vo_fallback_fallback_os2");
	// later if needed
//iprintlnbold("main_hall_audio_earpiece 9");
	level.player play_dialogue ("SCS3_SciBG02A_076A", true); // After target is down, evac to fallback rendezvous by twenty three hundred hours.
}

///////////////////////////////////////////////////////////////
//// Dimi satements before the knife fight                   //
///////////////////////////////////////////////////////////////
//dimitroius_dialogue()
//{
//	// line looking for me
//	wait(1.5);
//	level.player play_dialogue ("DIMI_SciBG02A_039B", false);
//
//	wait( 3 );
//	// Whoever you are, you're too late. Carlos is gone.  The job is as good as done.
//	// 
//	//level.player playSound ("DIMI_SciBG02A_039A");
//}

//// sound mercs make aboutbond in level.
//mercs_audio() // setup each instance for each guy talking.
//{
//	getent("merc_vo_trig_up_above", "targetname") waittill("trigger");
//	//	iPrintLn( "music_back_to_medium" );		
//	talker1 = get_closest_ai( level.player.origin, "axis");			
//	if ( isalive ( talker1 ) )
//	{
//		talker1 play_dialogue("SHM5_SciBG02A_055A", false); // he is on the second floor hold him..
//		//		iPrintLn( "he is on the second floor hold him" );		
//	}
//
//
//	wait( 3 );
//
//	// line Up Above!
//	getent("merc_vo_trig_up_above", "targetname") waittill("trigger");
//	talker1 = get_closest_ai( level.player.origin, "axis");	
//	if ( isalive ( talker1 ) )
//	{
//		talker1 play_dialogue ("SHM4_SciBG02A_054A", false);
//		//		iPrintLn( "line Up Above" );		
//	}
//
//	wait( 3.5 );
//	// line Second floor
//	talker1 = get_closest_ai( level.player.origin, "axis");	
//	if ( isalive ( talker1 ) )
//	{
//		talker1 play_dialogue("SHM5_MiaG02A_019A", false); 
//		//		iPrintLn( "Second floor" );
//	}
//
//	// line By the chopper, the big one
//	// SHM5_MiaG02A_029A
//	// talker1 = get_closest_ai( level.player.origin, "axis");	
//	// talker1 playsound ("SHM5_SciBG02A_065B");
//
//	// merc second floor
//	// line I don't have a shot
//	//	talker1 = get_closest_ai( level.player.origin, "axis");	
//	//	talker1 playsound ("SSF1_SciBG02A_069A");
//
//	level waittill("davinchi_start");
//	wait( 2 );
//	// if player shoots down over head helo
//	// merc 6
//	// Line it's coming down look out
//	talker1 = get_closest_ai( level.player.origin, "axis");	
//	if ( isalive ( talker1 ) )
//	{
//		talker1 play_dialogue ("SHM6_SciBG02A_071A", false);
//	}
//
//	wait( 4 );
//	// merc 7
//	// line MOVE!
//	talker1 = get_closest_ai( level.player.origin, "axis");	
//	if ( isalive ( talker1 ) )
//	{
//		talker1 play_dialogue ("SHM7_SciBG02A_072A", false);
//	}
//}

merc_audio_lights_shot()
{
	// then later
	// line Watch your heads! Stay away from the lights!
	// SHM5_MiaG02A_031A
	level waittill("lights_shot");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_067A", false);
	}
}

merc_audio_underneath_us()
{
	// if the player is on second the floor and player is directly underneath
	// merc 1 // call this one when the guys spawn in...
	// line He's underneath us
	getent("merc_vo_trig_underneath", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SSF1_SciBG02A_068A", false);
	}
}

//merc_audio_stairwell()
//{
//	// line By the stairs!
//	getent("merc_vo_trig_by_stairs", "targetname") waittill("trigger");
//	level notify( "stair_light_off_now" );
//	talker1 = get_closest_ai( level.player.origin, "axis");	
//	if ( isalive ( talker1 ) )
//	{
//		talker1 play_dialogue ("SHM5_SciBG02A_058A", false);  
//	}
//}

mercs_audio_he_is_the_middle()
{
	// line He's in the middel! Behind the models
	// SHM5_MiaG02A_026A 
	getent("merc_vo_trig_by_models", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_062A", false);
	}
}

mercs_audio_behind_display()
{
	// merc 5
	// line Behind the display
	getent("merc_vo_trig_behind_display", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_059A", false);
	}
}

mercs_audio_second_to_second()
{
	// if the player is overhand and there are guys on the second floor who can shoot him from the balcony
	// merc 2 second floor
	// second floor!
	level waittill("2nd_floor_to_floor_vo");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_055A", false);
	}
}

mercs_audio_lights_shotdown()
{
	// call this from lights being shotdown.
	// if the player shoots down the lights 
	// merc 5
	// line watch out for the lights!
	// SHM5_MiaG02A_030A
	level waittill("lights_shot_down");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_066A", false);
	}
}

mercs_audio_he_is_left()
{
	// line He's on the left
	// SHM5_MiaG02A_025A
	getent("merc_vo_trig_on_the_left", "targetname") waittill("trigger");
	talker1 = get_closest_ai( level.player.origin, "axis");	
	if ( isalive ( talker1 ) )
	{
		talker1 play_dialogue ("SHM5_SciBG02A_061A", false);
	}
}

//mercs_audio_by_scaf()
//{
//	// line He's by the scaffolding!
//	// SHM5_MiaG02A_027A
//	getent("merc_vo_trig_by_the_scaf", "targetname") waittill("trigger");
//	talker1 = get_closest_ai( level.player.origin, "axis");	
//	if ( isalive ( talker1 ) )
//	{
//		talker1 play_dialogue ("SHM5_SciBG02A_063A", false);
//	}
//}


////////////////////////////////////
// fake setup for music right now //
////////////////////////////////////
music_controller()
{
	//	musicplay("mus_mia_sci_center_start", 0);

	level waittill ("music_med1_on_knife"); // turn on for knife fight
	wait( 1.5 );
	//musicplay("mus_mia_sci_center_elevator_fight", 0);
	level waittill("on_second_floor");
	level notify("clear_ele_path");
	//level thread give_player_weapons_after_ele();

	//VisionSetNaked( "sciencecenter_b_05" );

	//	wait( 3 );
	//	iprintlnbold("play action music now");
	//	musicplay("mus_mia_sci_center_shootout", 0);

	level waittill("music_end_stinger");
	//	musicstop( 0 );
	wait( 3 );
	//	musicplay("mus_mia_sci_center_end", 0);
}



//main_hall_boss_fight() // gun_remove is what used to work in the cod... what are we using to do this....
//{
//	level waittill ("start_main_hall_boss_fight");
//
//	thread dimitroius_dialogue();
//
//	//level notify("objective_1_done");
//	// spawn guy
//	//level.player thread boss_hack_wait_system();
//	// setup, guy with spawner 
//	level.dimitrios = getent( "dimi_boss_fight", "script_noteworthy" );
//	level.dimitrios stalingradspawn();
//	setqkvisionset("dimitrios_ibf");
//	wait( 0.1 );
//	//level.dimitrios waittill( "finished spawning" );	
//	//level.dimitrios thread wait_for_boss_death();
//	ai = getaiarray();
//	dimi_boss_fight_index = -1;
//	for(i=0;i<ai.size;i++)
//	{
//		if( (isdefined (ai[i].script_noteworthy)) && (ai[i].script_noteworthy == "dimi_boss_fight") )
//			dimi_boss_fight_index = i;
//		ai[i] gun_remove(); // take,  need to get michelle to get this to work
//		ai[i] thread move_with_ele_after_death();
//		//		cigar = spawn("script_model", ai[i] gettagorigin("right") );
//		// bond_miami_body
//		//cigar = spawn("script_model", ai[i], gettagorigin("TAG_WEAPON_RIGHT") );
//		//knife = spawn("script_model", ai[i] gettagorigin("TAG_WEAPON_RIGHT") );
//		//		knife thread knife_falls_out_of_hand();
//		//		cigar.angles = ai[i] gettagangles("TAG_WEAPON_RIGHT");
//		//		knife linkto(ai[i], "TAG_WEAPON_RIGHT");
//		//knife setmodel("w_t_knife_demitrios");
//
//		ai[i] attach( "w_t_knife_demitrios", "TAG_WEAPON_RIGHT" );
//
//		//temp check to see new boss fight stuff
//		/*if (!(level.boss_fight_2))
//		{
//		start_interaction(level.player, ai[i], "InteractElevator_Fight"); // bossfightwork	
//		}
//		else
//		{*/
//		setqkvisionset("dimitrios_ibf");
//		ai[i] thread maps\_bossfight::boss_transition();
//
//		start_interaction(level.player, ai[i], "BossFight_Sequential"); // new boss fight
//		//iprintlnbold("New Boss Fight");			
//		//}
//
//
//		level notify("music_med1_on_knife");
//
//		// count up to three wattill if failure happens restart map
//		// Scripters can now have a waittill(“interaction_done”) on Bond.
//		level.player thread boss_success_fail();
//		//		level.player waittill("interaction_done"); // success one
//		//		playfxontag (level._effect["blood"], knife, "TAG_BLADE");
//	}
//
//	// bossfightwork
//	wait(1.8); 
//	level notify("playmusicpackage_boss_start");
//	wait( 5.2 ); // totall 33
//	wait( 4 ); // totall 33
//	wait( 4 ); // totall 33
//	wait( 4 ); // totall 33
//	wait( 6 ); // totall 33
//	level notify ("music_med2_off_knife"); // turn off for fight
//
//	ai[dimi_boss_fight_index] linkTo( GetEnt ("securityElevMain", "targetname") );
//
//	flag_wait("dimitrios_dead");
//
//	level.dimi = ai[dimi_boss_fight_index];
//	level.dimi DoDamage( ai[dimi_boss_fight_index].health + 1, ai[dimi_boss_fight_index].origin);
//	level.dimi StartRagDoll();
//
//	level notify ("vo_locate_on_first_floor_os2");
//
//	wait(2.0);
//
//	level thread thug_attack_elev();
//	wait( 1.5 );
//	level notify ("thug_attack_elev_now");
//	wait( 1 );
//	//	wait( 3 ); //remove this back in when done doing timing with steve g test elevator
//
//	level notify ("continue_elevator_sequence");
//
//	level notify("endmusicpackage");
//}

//avulaj
//testing why dimitrios is dieing early
//wait_for_boss_death()
//{
//	self waittill ( "death" );
//	iPrintLnBold( "THE_BOSS_IS_DEAD" );
//}

/////////////////////////////////////////////////////////////////////////////////////////
// ceiling tiles and phys object fall during boss fight in elevator
/////////////////////////////////////////////////////////////////////////////////////////
//elevator_ambient_objects()
//{
//	wait(3.2);
//
//	tile01 = getent("securityElevMain_tile01", "targetname");
//	tile01 moveGravity(vectornormalize((0,0,-9.8)), 2.0);
//
//	wait(9.0);
//
//	tile02 = getent("securityElevMain_tile02", "targetname");
//	tile02 moveGravity(vectornormalize((0,0,-9.8)), 2.0);
//
//	wait(0.5);
//
//	tile03 = getent("securityElevMain_tile03", "targetname");
//	tile03 moveGravity(vectornormalize((0,0,-9.8)), 2.0);
//}


//elevator_tiles()
//{
//	wait(0.8);
//	tile04 = getent("securityElevMain_tile04", "targetname");
//	tile04 moveGravity(vectornormalize((0,0,-9.8)), 2.0);
//
//	wait(7.3);
//	tile05 = getent("securityElevMain_tile05", "targetname");
//	tile05 moveGravity(vectornormalize((0,0,-9.8)), 2.0);
//
//	wait(0.5);
//	tile06 = getent("securityElevMain_tile06", "targetname");
//	tile06 moveGravity(vectornormalize((0,0,-9.8)), 2.0);
//}



elevator_button_hide()
{
	elevator_button_basement = getent("elevator_button_basement", "targetname");
	//elevator_button_firstfloor = getent("elevator_button_firstfloor", "targetname");
	//elevator_button_secondfloor = getent("elevator_button_secondfloor", "targetname");
	//elevator_button_up = getent("elevator_button_up", "targetname");

	level.elevator_light_floor0 = getent("elevator_light_0", "targetname");
	level.elevator_light_floor1 = getent("elevator_light_1", "targetname");
	level.elevator_light_floor2 = getent("elevator_light_2", "targetname");

	level.elevator_light_floor1 hide();
	level.elevator_light_floor2 hide();

	elevator_button_basement hide();
	//elevator_button_firstfloor hide();
	//elevator_button_up hide();

	//thread elevator_buttons();
	thread elevator_light_floor();
}


elevator_light_floor()
{
	level waittill("elevator_up");

	wait(3.0);

	level.elevator_light_floor0 hide();
	level.elevator_light_floor1 show();

	wait(4.0);

	//level.elevator_light_floor1 hide();
	//level.elevator_light_floor2 show();

	level waittill("elevator_down");

	wait(0.3);

	//level.elevator_light_floor2 hide();

	while(!(level.terminate_elevator_lights))
	{
		level.elevator_light_floor0 show();
		wait(0.1);
		level.elevator_light_floor0 hide();
		level.elevator_light_floor1 show();
		wait(0.1);
		level.elevator_light_floor1 hide();
	}
}


//elevator_buttons()
//{
//	level waittill("elevator_up");
//
//	//elevator_button_basement = getent("elevator_button_basement", "targetname");
//	//elevator_button_firstfloor = getent("elevator_button_firstfloor", "targetname");
//	//elevator_button_secondfloor = getent("elevator_button_secondfloor", "targetname");
//
//	wait(7.0);
//	//elevator_button_secondfloor hide();
//
//	level waittill("elevator_down");
//
//	wait(0.2);
//	//elevator_button_firstfloor show();
//}


//boss_notetracks() // lead
//{
//	EleLight = GetEnt ("EleLight", "targetname"); // d light that moves with elevator
//
//
//	level.player waittillmatch( "anim_notetrack", "note_sound_1_bond_knifefight_lead_1");
//
//	//thread elevator_ambient_objects();  //ceiling tiles and phys object fall during boss fight
//
//	level.player playsound("Bond_KnifeFight_Lead_1");
//	level.player waittillmatch( "anim_notetrack", "note_sound_2_bond_knifefight_input_1");
//	level.player playsound("Bond_KnifeFight_input_1");
//	level.player waittillmatch( "anim_notetrack", "note_sound_3_bond_knifefight_success_1");
//	level.player playsound("Bond_KnifeFight_success_1");
//	level.player PlayRumbleOnEntity( "grenade_rumble" );
//
//	EleLight thread light_flicker(true, 0, 1.5);
//
//	level.player PlayRumbleOnEntity( "grenade_rumble" );      
//	level.player waittillmatch( "anim_notetrack", "note_sound_4_bond_knifefight_input_2");
//
//	EleLight thread light_flicker(false, .8);
//
//	level.player playsound("bond_knifefight_input_2");
//	level.player waittillmatch( "anim_notetrack", "note_sound_5_bond_knifefight_success_2");
//	level.player playsound("Bond_KnifeFight_success_2");            
//	level.player PlayRumbleOnEntity( "grenade_rumble" );
//
//	EleLight thread light_flicker(true, 0, 1.5);
//
//	level.player PlayRumbleOnEntity( "grenade_rumble" );
//	level.player waittillmatch( "anim_notetrack", "note_sound_6_bond_knifefight_input_3");
//
//	//EleLight thread light_flicker(false, .8);
//
//	level.player playsound("Bond_KnifeFight_input_3");
//	level.player waittillmatch( "anim_notetrack", "note_sound_7_bond_knifefight_success_3");
//	level.player playsound("Bond_KnifeFight_success_3");
//	level.player PlayRumbleOnEntity( "grenade_rumble" );
//
//	//EleLight thread light_flicker(true, 0, 1.5);
//
//	level.player waittill("interaction_done");
//
//	//currentweapon = level.player getCurrentWeapon();
//	//level.player takeweapon( currentweapon ); // remove bonds gun
//
//	flag_set( "dimitrios_dead" );
//
//	wait(2.0);
//
//	EleLight thread light_flicker(false, 1);
//	//savegame("MiamiScienceCenter");
//	//autosave_by_name("dimitrios_dead");
//
//	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
//}

//boss_notetrracks_2() // success 1
//{
//	level.player waittillmatch( "anim_notetrack", "note_sound_5_bond_knifefight_success_2");
//	level.player playsound("Bond_KnifeFight_success_2");
//}
//
//boss_notetrracks_3() // success 2
//{
//	level.player waittillmatch( "anim_notetrack", "note_sound_5_bond_knifefight_success_2");
//	level.player playsound("Bond_KnifeFight_input_3");
//	level.player waittillmatch( "anim_notetrack", "note_sound_6_bond_knifefight_input_3");
//	level.player playsound("Bond_KnifeFight_success_3");
//}
//
//boss_notetrracks_4() // success 3
//{
//	level.player waittillmatch( "anim_notetrack", "note_sound_7_bond_knifefight_success_3");
//	level.player playsound("Bond_KnifeFight_success_3");
//}


/*
// call back function on being damaged
fall_large_lights( strcObject )
{
// get primary entity
entAwarenessObject = strcObject.primaryEntity;

// set up tag origin
entOrigin = Spawn( "script_model", entAwarenessObject.origin + ( 0, 0, -32 ));
entOrigin SetModel( "tag_origin" );
entOrigin LinkTo( entAwarenessObject );

// launch model into physics
entAwarenessObject PhysicsLaunch( strcObject.damagePoint, vector_multiply( strcObject.damageDirection, 1000 ) );

// call dmge function
entOrigin thread lights_dmg();
}
*/

//// detach knife and make it fall on the ground in physics
//knife_falls_out_of_hand()
//{
//	wait( 1 );
//	//	self detach(weaponmodel, "tag_weapon_right");
//	//	self = Spawn( "script_model", self.origin + ( 0, 0, 0 ));
//	entOrigin = Spawn( "script_model", self.origin + ( 0, 0, 0 ));
//	entOrigin SetModel( "tag_origin" );
//	entOrigin LinkTo( self );
//
//	// launch model into physics
//	//self PhysicsLaunch( self.damagePoint, vector_multiply( self.damageDirection, 1 ) );
//	self PhysicsLaunch();
//}
//
//// map restart when you fail the bossfight
//boss_success_fail()
//{
//	self waittill("failure");
//	//	iprintlnbold("FAILED!");
//	//self dodamage( 10000, (0,0,0) );
//}

//move_with_ele_after_death()
//{
//	level waittill("continue_elevator_sequence");
//	securityElevMain = GetEnt ("securityElevMain", "targetname");	
//	//		wait( 1 );
//	//commented out due to script error caused by conflict with boss failure code
//	if (IsDefined(self))
//	{
//		self dodamage( 10000, (0,0,0) );
//	}
//	//		org = spawn( "script_origin", securityElevMain.origin );
//	//		self movez ( 500, 10 );
//	//		self attach("org", "",(0,0,0), (0,0,0)); 
//}


stairwell_lights_off() // tell jean about changing lights on it..
{
	//		iprintln( " waiting light control" );		
	getent("stairwell_light_off", "targetname") waittill("trigger");
	//iprintlnbold("stairwell_lights_off");

	stairlights = getEntArray( "stairwell_light", "targetname" );

	// let guys run wild if player bypasses rocket moment.
	level notify ( "thugs_run_to_second_floor" );	

	for( i = 0; i < stairlights.size; i++ )
	{		
		//				iprintln(" stair lights array count up");
		stairlights[i] thread stairwell_lights_off_action();	
		if( (isdefined (stairlights[i].script_noteworthy)) && (stairlights[i].script_noteworthy == "stairwell_light_end") )
		{
			//			stairlights[i] thread stairwell_lights_loop();
			//							iprintln(" Light should loop now1");		
		}
		//				if( (isdefined (stairlights[i].script_noteworthy)) && (stairlights[i].script_noteworthy == "stairwell_light_end2") )
		//				{
		//			
		//				}
	}
}

//stairwell_lights_loop()
//{
//	while( 1 )
//	{
//		//iprintln(" Light should loop now2");
//		wait( 1 + randomfloat( .1 ) );
//		self setlightintensity ( 0 );
//		wait( .05 + randomfloat( .1 ) );
//		self setlightintensity ( 1 );
//		wait( 2 + randomfloat( 4 ) );
//		self setlightintensity ( .2 );
//		wait( .05 + randomfloat( .1 ) );
//		self setlightintensity ( 0 );
//	}
//}

stairwell_lights_off_action()
{
	//	while( 1 )
	//	{
	//				wait( 3 + randomfloat( 7 ) );

	//				iprintln(" Light stairwell_lights_off_action");
	wait( .03 + randomfloat( .1 ) );
	self setlightintensity ( .5 );
	wait( .05 + randomfloat( .1 ) );
	self setlightintensity ( .2 );
	wait( .05 + randomfloat( .1 ) );
	self setlightintensity ( 0 );
	wait( .05 + randomfloat( .1 ) );
	self setlightintensity ( .3 );
	wait( .03 + randomfloat( .1 ) );
	self setlightintensity ( 0 );
	wait( .05 + randomfloat( .1 ) );
	self setlightintensity ( .07 );
	wait( .05 + randomfloat( .1 ) );
	self setlightintensity ( .2 );
	wait( .05 + randomfloat( .03 ) );
	self setlightintensity ( 0 );
	//		}
}

// jluytied for first playable
science_center_objectives()
{
	objective_00 = GetEnt( "objective_catwalk", "targetname" );
	objective_01 = GetEnt( "objective_clear", "targetname" );
	objective_02 = GetEnt( "objective_basement", "targetname" );
	objective_03 = GetEnt( "objective4_marker", "targetname" );
	objective_04 = GetEnt( "objective_mainhall", "targetname" );

	level waittill("introscreen_complete");

	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 1, "active", &"SCIENCECENTER_B_OBJECTIVE_CATWALK_HEADER", ( objective_00.origin ), &"SCIENCECENTER_B_OBJECTIVE_CATWALK_BODY" );

	trigger_obj_01 = getent("trigger_reached_maincatwalk", "targetname");
	trigger_obj_01 waittill("trigger");

	//VisionSetNaked("Sciencecenter_b_02", 1.0);
	//setExpFog(453.908,932.352,0.335938,0.304688,0.34375, 1.0);


	objective_state(1, "done");

	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 2, "active", &"SCIENCECENTER_B_OBJECTIVE_CLEAR_HEADER", ( objective_01.origin ), &"SCIENCECENTER_B_OBJECTIVE_CLEAR_BODY" );

	flag_wait("reached_stairwell");

	objective_state(2, "done");

	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 3, "active", &"SCIENCECENTER_B_OBJECTIVE_BASEMENT_HEADER", ( objective_02.origin ), &"SCIENCECENTER_B_OBJECTIVE_BASEMENT_BODY" );

	flag_wait("reached_basement");

	objective_state(3, "done");

	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 4, "active", &"SCIENCECENTER_B_OBJECTIVE_DIMITRIOS_HEADER", ( objective_03.origin ), &"SCIENCECENTER_B_OBJECTIVE_DIMITRIOS_BODY" );

	flag_wait("accessed_elevator");

	objective_state(4, "done");

	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 5, "active", &"SCIENCECENTER_B_OBJECTIVE_CARLOS_HEADER", ( objective_04.origin ), &"SCIENCECENTER_B_OBJECTIVE_CARLOS_BODY" );

	flag_wait("killed_men");

	objective_state(5, "done");

	//******************************************************************************************************************************************************************************************************************************************

	objective_add( 6, "active", &"SCIENCECENTER_B_OBJECTIVE_CARLOS_HEADER", ( objective_04.origin ), &"SCIENCECENTER_B_OBJECTIVE_CARLOS_BODY" );

	flag_wait("success");

	objective_state(6, "done");
}

/////////////////////////////////////////////////////////////
//      CAMERA STUFF FOR ELEVATOR                          //
/////////////////////////////////////////////////////////////   



///////////////////////////////////////////////////////////////////////////////////////
//	New Stuff - jpark
///////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////
//	Setup
///////////////////////////////////////////////////////////////////////////////////////
init_mainhall()
{
	//iprintlnbold("init_mainhall");
	//level.crate_destroyed = getent("target_crate_destroyed", "targetname");
	//level.crate_destroyed hide();

	level.triggerhurt = getent("trigger_hurt_davinci", "targetname");
	level.triggerhurt trigger_off();

	level.rpg_proj = getent("rpg_projectile", "targetname");
	if (isdefined(level.rpg_proj))
	{
		level.rpg_proj hide();
	}

	level.rpg_proj2 = getent("rpg_projectile2", "targetname");
	if (isdefined(level.rpg_proj2))
	{
		level.rpg_proj2 hide();
	}

	thread spawn_mainhall_lower();
	//thread savegame_mainhall();

	thread steam_fx();
	thread elevator_explosion_kill();
	thread elevator_button_hide();
	
	// condensed these 6 functions into 1 function
	thread banner_wave("trigger_banner_01", "sc_banner_01_start");
	thread banner_wave("trigger_banner_02", "sc_banner_02_start");
	thread banner_wave("trigger_banner_03", "sc_banner_03_start");
	thread banner_wave("trigger_banner_04", "sc_banner_04_start");
	thread banner_wave("trigger_banner_05", "sc_banner_05_start");
	thread banner_wave("trigger_banner_06", "sc_banner_06_start");
	//thread banner_01();
	//thread banner_02();
	//thread banner_03();
	//thread banner_04();
	//thread banner_05();
	//thread banner_06();
}




/////////////////////////////////////////////////////////////////////////////////////////
////	Delete guards who fired at elevator
/////////////////////////////////////////////////////////////////////////////////////////
//delete_elevator_guards()
//{
//	guardarray = getentarray("elevator_guards", "targetname");
//
//	wait(5.0);
//
//	for (i=0; i<guardarray.size; i++)
//	{
//		if (isalive(guardarray[i]))
//		{
//			guardarray[i] delete();
//		}
//	}
//
//	thread spawn_elevator_exit();
//}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards outside elevator shaft
///////////////////////////////////////////////////////////////////////////////////////
spawn_elevator_exit()
{
	trigger = getent("trigger_rpg", "targetname");
	trigger waittill("trigger");
	//VisionSetNaked( "sciencecenter_b_06", 2.3 );
	spawnerarray = getentarray("guard_elevator_exit", "targetname");

	// NOTE: this spawns 2
	for(i = 0; i < spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_elevator");
	}

	guardarray = getentarray("guard_elevator", "targetname");

	for(i = 0; i < guardarray.size; i++)
	{
		guardarray[i] settetherradius(4);
	}

	wait(1.0);

	thread fire_rocket();
}

//DCS:  Slam Doors shut to keep player out of the shaft.
shut_elev_doors()
{
	trigger = getent("mainhall_objective_final", "targetname");
	trigger waittill("trigger");

	securityElevOuterLeftDoor = GetEnt ("securityElevOuterLeftDoorMainHall", "targetname");
	securityElevOuterRightDoor = GetEnt ("securityElevOuterRightDoorMainHall", "targetname");

	securityElevOuterLeftDoor movex ( -30.0, 1.0, 0.25, 0.2);
	securityElevOuterRightDoor movex ( 35.0, 1.0, 0.25, 0.2);
	securityElevOuterRightDoor playsound("Elevator_Doors_Open");

}
/////////////////////////////////////////////////////////////////////////////////////////
////	Savegame after exiting elevator
/////////////////////////////////////////////////////////////////////////////////////////
//savegame_mainhall()
//{
//	trigger = getent("trigger_savegame_mainhall", "targetname");
//	trigger waittill("trigger");
//
//
//
//
//	//savegame("MiamiScienceCenter");
//	//autosave_by_name("main_hall");
//	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
//}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards on right balcony
///////////////////////////////////////////////////////////////////////////////////////
spawn_right_balcony()
{
	guardarray = getentarray("guard_right_balcony", "targetname");

	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_right");
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards on left balcony
///////////////////////////////////////////////////////////////////////////////////////
spawn_left_balcony()
{
	guardarray = getentarray("guard_left_balcony", "targetname");

	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_left");
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn guards on 1st floor while Bond is on 2nd
///////////////////////////////////////////////////////////////////////////////////////
spawn_mainhall_lower()
{
	trigger = getent("trigger_mainhall_lower", "targetname");
	trigger waittill("trigger");

	//iprintlnbold("spawn_mainhall_lower");

	//DCS: setting fog for main hall. (bug 10937)
	//setExpFog(0,1527.26,0.263,0.259,0.252, 2.0);


	level notify ("vo_He_is_on_the_second_floor_os2");

	// NOTE: this spawns 3
	guardarray = getentarray("guard_mainhall_lower", "targetname");
	for(i = 0; i < guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_lower");
	}

	//thread spawn_wave_01();
	//wait(0.5);
	thread spawn_right_balcony();
	wait(0.3);
	thread spawn_left_balcony();	

	// condensed the 6 functions into 1
	thread falling_light("trigger_lightfall_01", "mainhall_lights_small_01", (-230, 1800, 88));
	thread falling_light("trigger_lightfall_02", "mainhall_lights_small_02", (244, 1800, 88));
	//thread falling_light("trigger_lightfall_03", "mainhall_lights_small_03", (-230, 1800, 88));
	thread falling_light("trigger_lightfall_04", "mainhall_lights_small_04", (244, 1496, 88));
	thread falling_light("trigger_lightfall_05", "mainhall_lights_small_05", (-229, 1192, 88));
	//thread falling_light("trigger_lightfall_06", "mainhall_lights_small_06", (244, 1192, 88));
	//thread falling_light_01();
	//thread falling_light_02();
	//thread falling_light_03();
	//thread falling_light_04();
	//thread falling_light_05();
	//thread falling_light_06();

	//temp
	//thread fire_rocket();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Guard fires a rpg which sets the DaVinci on fire
///////////////////////////////////////////////////////////////////////////////////////
fire_rocket()
{
	destroyed_wall1 = getent ("pillar_before","targetname");
	destroyed_wall2 = getent ("pillar_after","targetname");

	destroyed_wall2 hide();

	rpg = getent("guard_rpg", "targetname");
	rpg stalingradspawn( "rpg_guard" );
	guard = getent("rpg_guard", "targetname");
	guard thread rpg_guard();

	wait(1.5);

	level.tag = getent("tag_rocket", "targetname");

	thread rpg_projectile();
	thread loop_smoke_trail();
	thread rpg_davinci_fire();

	level.tag movey(1886, 2.0);

	wait(2.0);

	level.rocket_impact = true;

	//tag_impact = getent("tag_rocket_impact", "targetname");
	tag_impact = spawn("script_model", (-152, 2408, 400));
	tag_impact setmodel("tag_origin");

	//playfxontag( level._effect[ "elev_expl" ], tag_impact, "tag_origin" ); commented out. there is enough of an explosion with the propane tanks. -DO
	origin_explosion = (-118, 2486, 400);//getent("rpg_explosion", "targetname");
	radiusdamage(origin_explosion, 250, 200, 200, undefined );



	destroyed_wall1 hide();
	destroyed_wall2 show();


	tag_impact playsound("wpn_rpg_imp");
	wait(0.2);
	earthquake( 0.6, 1, level.player.origin, 300 );

	//level.player play_dialogue_nowait("SCH1_SciBG02A_049A", false); // man screaming

	tag_impact delete();
	/////////////////////////////////////////////////////////////////////////////////////////////////

	wait(2.0);

	level.tag2 = getent("tag_rocket2", "targetname");
	thread rpg_projectile2();
	thread loop_smoke_trail2();
	level.tag2 moveto((-5, 3030, 470), 2.3);

	wait(2.3);

	level.rocket_impact2 = true;

	//tag_impact2 = getent("tag_rocket_impact2", "targetname");
	tag_impact2 = spawn("script_model", (-5, 3030, 470));
	tag_impact2 setmodel("tag_origin");
	level.player PlayRumbleOnEntity( "grenade_rumble" );

	//playfxontag( level._effect[ "elev_expl" ], tag_impact2, "tag_origin" );
	playfx(level._effect["elev_expl"], (-5, 3030, 470));
	wait(0.05);
	tag_impact2 playsound("wpn_rpg_imp");
	wait(0.2);
	earthquake( 0.6, 1, level.player.origin, 300 );

	tag_impact2 delete();
	/////////////////////////////////////////////////////////////////////////////////////////////////
}

rpg_guard()
{
	self endon("death");

	wait(1.5);

	self setperfectsense( true );
	self CmdShootAtEntity( level.player, false, 2.5, 0 );
	self playsound("wpn_rpg_fire_plr");

	wait 4.2;

	self CmdShootAtEntity( level.player, false, 2.5, 0 );
	self playsound("wpn_rpg_fire_plr");
	self setperfectsense( false );

	wait 2.5;

	node = getnode ("node_rpg", "targetname");
	self setgoalnode(node);
	self waittill("goal");
	self delete();
}

rpg_projectile()
{
	if (isdefined(level.rpg_proj))
	{
		//iprintlnbold("first rocket shoots");
		level.rpg_proj show();
		level.rpg_proj movey(1886, 2.0);

		wait(2.0);

		//level.rpg_proj delete();
	}
}


loop_smoke_trail()
{
	while(!(level.rocket_impact))
	{
		playfxontag( level._effect[ "rpg_trail" ], level.tag, "tag_origin" );

		wait(0.05);
	}
}


rpg_davinci_fire()
{
	//tag = getent("tag_rpg_fire", "targetname");
	wait(1.5);
	playfx(level._effect[ "rpg_fire" ], (-155, 1501, 388));	
	//level.rpg_davinci_fire_fx = spawnfx(level._effect[ "rpg_fire" ], (-155, 1501, 388));	

	level waittill("gogogo");

	//// delete the fire fx
	//if(isdefined(level.rpg_davinci_fire_fx))
	//	level.rpg_davinci_fire_fx delete();
}


rpg_projectile2()
{
	if (isdefined(level.rpg_proj2))
	{
		//iprintlnbold("second rocket shoots");
		level.rpg_proj2 show();
		level.rpg_proj2 moveto((-5, 3197, 470), 2.3);
	}
}


loop_smoke_trail2()
{
	while(!(level.rocket_impact2))
	{
		playfxontag( level._effect[ "rpg_trail" ], level.tag2, "tag_origin" );

		wait(0.05);
	}
}


///////////////////////////////////////////////////////////////////////////////////////
//	Spawning in waves
///////////////////////////////////////////////////////////////////////////////////////
spawn_in_waves()
{
	// first wait for the trigger to spawn the first wave
	trig = getent("trigger_mainhall_wave01", "targetname");
	if(isdefined(trig))
		trig waittill("trigger");

	// save
	//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	// spawn the first wave
	//iprintlnbold("wave01");
	thread spawn_wave("guard_mainhall_wave01", "guard_wave01", false);
	level notify("vo_everyone_to_the_first_floor_os2"); // tell the level to play some vo

	// the level will play differently depending on which side the user goes on
	thread spawn_left();
	thread spawn_right();

	//// spawn the second wave
	////iprintlnbold("wave02");
	//thread spawn_wave("guard_mainhall_wave02", "guard_wave02", true);

	//level waittill("wave_spawn_done");
	//// spawn the third wave
	////iprintlnbold("wave03");
	//thread spawn_wave("guard_mainhall_wave03", "guard_wave03", true);

	//level waittill("wave_spawn_done");
	//thread spawn_lobby_guards();
	//// save
	//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	//// lobby guards
	////iprintlnbold("lobby guards");
	//thread spawn_lobby_guards();
}
spawn_left()
{
	// if the player goes left, spawn the guys on the left
	self endon("spawn_right");

	trig = getent("merc_vo_trig_underneath", "targetname");
	if(isdefined(trig))
	{
		trig waittill("trigger");
		level notify("spawn_left");
	
		thread spawn_wave("guard_mainhall_wave02", "guard_wave02", true);

		// spawn the last wave
		level waittill("wave_spawn_done");
		thread spawn_wave("guard_mainhall_wave03", "guard_wave03", true);
		level waittill("wave_spawn_done");
		thread spawn_lobby_guards();
		
		// save
		//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
		level notify("checkpoint_reached"); // checkpoint 8
	}
}
spawn_right()
{
	// if the player goes right, spawn the guys on the right
	self endon("spawn_left");

	trig = getent("merc_vo_trig_on_the_left", "targetname");
	if(isdefined(trig))
	{
		trig waittill("trigger");
		level notify("spawn_right");
	
		thread spawn_wave("guard_mainhall_wave03", "guard_wave03", true);

		// spawn the last wave
		level waittill("wave_spawn_done");
		thread spawn_wave("guard_mainhall_wave02", "guard_wave02", true);
		level waittill("wave_spawn_done");
		thread spawn_lobby_guards();
		
		// save
		//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
		level notify("checkpoint_reached"); // checkpoint 8
	}
}
spawn_wave(targetname, spawnname, waiting)
{
	// see if we want to wait to spawn
	if(waiting)
	{
		// to control the number of total spawned AI at once, we are going to only spawn if the AI number gets low
		while(1)
		{
			// get the total number of guards spawned right now
			guardarray = getaiarray("axis");
			if(guardarray.size <= 2)
			{
				//iprintlnbold("spawn_wave " + targetname + " " + spawnname);
				wait(1.0);

				// spawn the wave
				spawnerarray = getentarray(targetname, "targetname");
				for(i = 0; i < spawnerarray.size; i++)
				{
					spawnerarray[i].count = 1;
					spawnerarray[i] = spawnerarray[i] stalingradspawn(spawnname);

					node_name = undefined;
					if(spawnname == "guard_wave02")
					{
						// NOTE: give them a goal node, so they will just run to the goal and ignore everything else
						node_name = "wave02_out_node" + (i + 1);
						//iprintlnbold(node_name);
					}
					else if(spawnname == "guard_wave03")
					{
						// NOTE: give them a goal node, so they will just run to the goal and ignore everything else
						node_name = "wave03_out_node" + (i + 1);
						//iprintlnbold(node_name);					
					}
					goal_node = getnode(node_name, "targetname");
					if(isdefined(goal_node))
					{
						wait(0.05); // we must wait so that we can setgoalnode after the spawner set's goal
						//iprintlnbold(node_name);
						spawnerarray[i] setgoalnode(goal_node);
						// turn off sense so they'll run out to the goal
						spawnerarray[i] setenablesense(false);
						// this will check when they hit their goal and turn sense back on
						spawnerarray[i] thread check_goal();
					}
				}

				// open the door if necessary
				if(spawnname == "guard_wave02")
				{
					//iprintlnbold("open door");
					door = getent("wave02_door", "targetname");
					if(isdefined(door))
					{
						door rotateyaw(-110, 0.5);
						door waittill("rotatedone");
						door connectpaths();
					}
				}
				else if(spawnname == "guard_wave03")
				{
					//iprintlnbold("open door");
					door = getent("wave03_door", "targetname");
					if(isdefined(door))
					{
						door rotateyaw(-110, 0.5);
						door waittill("rotatedone");
						door connectpaths();
					}
				}

				level notify("wave_spawn_done");
				break;
			}

			wait(0.05);	
		}
	}
	// don't wait, just spawn
	else
	{
		guardarray = getentarray(targetname, "targetname");
		if(isdefined(guardarray))
		{
			for(i = 0; i < guardarray.size; i++)
			{
				guardarray[i].count = 1;
				guardarray[i] = guardarray[i] stalingradspawn(spawnname);
			}
		}
	}
}
send_the_gogogo()
{
	trigger = getent("trigger_check_wave02", "targetname");
	trigger waittill("trigger");

	level notify("gogogo");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Spawn lobby guards in mainhall
///////////////////////////////////////////////////////////////////////////////////////
spawn_lobby_guards()
{
	//trigger = getent("trigger_spawn_lobby", "targetname");
	//trigger waittill("trigger");
	//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	//thread spawn_bridge_guards();
	thread open_mainhall_gates();
	thread mainhall_guards_dead();
	thread turn_last_2_guys_into_rusher();

	//// NOTE: adding a save in the middle of the main hall, per bug 11579
	//thread midpoint_save();

	spawnerarray = getentarray("guard_lobby", "targetname");

	for (i=0; i<spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_lobby_exit");
		spawnerarray[i]thread TetherWatcher( 12*0, 12*3, 12*15 );
	}

	guardarray = getentarray("guard_lobby_exit", "targetname");

	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] setscriptspeed("sprint");

		// NOTE: give them a goal node, so they will just run to the goal and ignore everything else
		node_name = "thru_door_node" + (i + 1);
		//iprintlnbold(node_name);
		goal_node = getnode(node_name, "targetname");
		if(isdefined(goal_node))
		{
			wait(0.05); // we must wait so that we can setgoalnode after the spawner set's goal
			//iprintlnbold(node_name);
			guardarray[i] setgoalnode(goal_node);
			// turn off sense so they'll run out to the goal
			guardarray[i] setenablesense(false);
			// this will check when they hit their goal and turn sense back on
			guardarray[i] thread check_goal();
		}
	}

	wait(5);
	thread close_mainhall_gates();
}
check_goal()
{
	self endon("death");

	self waittill("goal");

	// once we spawn a wave of guys we want to get them out of the doors completely, then once they reach that goal
	//	we want to send them to a more tactical goal, at the same time have them paying attention to bond while running
	if(isdefined(self.target))
	{
		goal_node = getnode(self.target, "targetname");
		if(isdefined(goal_node))
		{
			self setgoalnode(goal_node, 1);
		}
	}

	self setenablesense(true);
	self setperfectsense(true);
}

//midpoint_save()
//{
//	trig = getent("midpoint_save_trig", "targetname");
//	if(isdefined(trig))
//	{
//		trig waittill("trigger");
//		maps\_autosave::autosave_now("MiamiScienceCenter");
//	}
//}


///////////////////////////////////////////////////////////////////////////////////////
//	Open mainhall gates
///////////////////////////////////////////////////////////////////////////////////////
open_mainhall_gates()
{
	right = getent("mainhall_gate_right", "targetname");
	left = getent("mainhall_gate_left", "targetname");
	//iprintlnbold("open gates, right: " + right.origin[0]);
	//iprintlnbold("open gates, left: " + left.origin[0]);

	right movex (-84, 3.0);
	left movex (84, 3.0);
}



///////////////////////////////////////////////////////////////////////////////////////
// End battle music when all ai in mainhall are dead
///////////////////////////////////////////////////////////////////////////////////////
mainhall_guards_dead()
{
	alldead = false;

	while(!(alldead))
	{
		guards = getaiarray("axis", "neutral");
		if(guards.size == 1)
		//if(!(guards.size))
		{
			if(isdefined(guards[0].script_noteworthy) && guards[0].script_noteworthy == "dimi_boss_fight")
			{
				flag_set("killed_men");
				
				//level notify("endmusicpackage");
				// soft music with stinger here please
				alldead = true;
				//savegame("MiamiScienceCenter");
				//autosave_by_name("main_hall_done");
				//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
				level maps\_autosave::autosave_now("MiamiScienceCenter"); // just to make sure we save here, there was an instance where it didn't save
				//level notify("checkpoint_reached"); // checkpoint 9
				thread open_mainhall_gates(); // open the gates for the dimi kill
				// move the player clip out of the way
				player_clip = getent("main_hall_gate_clip", "targetname");
				player_clip trigger_off();
				level.dimitrios setcandamage(true);
				level.dimitrios thread watch_dimi_damage();
				//level thread mission_success();
			}
		}
		wait(0.5);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Close mainhall gates
///////////////////////////////////////////////////////////////////////////////////////
close_mainhall_gates()
{
	right = getent("mainhall_gate_right", "targetname");
	left = getent("mainhall_gate_left", "targetname");
	//iprintlnbold("close gates, right: " + right.origin[0]);
	//iprintlnbold("close gates, left: " + left.origin[0]);

	right movex (84, 3.0);
	left movex (-84, 3.0);
}


///////////////////////////////////////////////////////////////////////////////////////
//	Jeremyl new ending
// teather bad guys so no one flanks u in end battle
// kill guys on second floor when davinci crashes
// close gates after last wave comes and then open gates when the player cleans the area
///////////////////////////////////////////////////////////////////////////////////////
jl_ending()
{
	// grab everyone in an array and make them teather to the back end
	trigger = getent("trigger_check_wave03", "targetname");
	trigger waittill("trigger");

	// I need to do this a few times to make sure everyone is running it.
	wait( 5 );
	tetherPt1 = GetEnt( "auto2489", "targetname" );
	lower_guys = getaiarray("axis");
	for (i=0; i<lower_guys.size; i++)
	{
		lower_guys[i]thread TetherWatcher( 12*0, 12*3, 12*15 );
	}
}

jl_ending_kill_floor2()
{
	lower_guys = getaiarray("axis");


	for (i=0; i<lower_guys.size; i++)
	{
		if (IsDefined(lower_guys[i].script_string) && (lower_guys[i].script_string == "top_floor"))
		{
			lower_guys[i] dodamage( 10000, (0,0,0) );
		}
	}
}

//**************************************************************************
//**************************************************************************

TetherWatcher( tetherDelta0, tetherDelta1, minTether )
{
	self endon( "death" );

	level.tetherPt = GetEnt( "origin_heli_damage", "targetname" );

	if( IsDefined(level.tetherPt) )
	{		
		self.tetherpt			= level.tetherPt.origin;	
		self.tetherradius	= 10000000000;

		tetherDelta 			= randomfloatrange(tetherDelta0, tetherDelta1);

		while( isdefined(level.tetherPt) )
		{						
			wait( randomfloat(2.0,4.0) );			

			newRad = Distance(level.player.origin, self.tetherpt) - tetherDelta;

			//To avoid increasing
			if( newRad < self.tetherradius )
			{	
				//Make sure we respect the minimal tether Radius
				if( newRad < minTether )
				{
					self.tetherradius = minTether;
				}
				else
				{
					self.tetherradius = newRad;

					tetherDelta = randomfloatrange(tetherDelta0, tetherDelta1);
				}
			}
		}
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Activate the davinci/heli collapse
///////////////////////////////////////////////////////////////////////////////////////
activate_davinci_heli()
{
	level waittill("gogogo");

	//savegame("MiamiScienceCenter");
	//autosave_by_name("helicopter_crash");
	//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	level notify("checkpoint_reached"); // checkpoint 7

	if (!(level.davinci_collapsed))
	{
		level notify("heli_start");

		wait(3);
		level notify("end_explosion_now");	
		level notify ("davinchi_start");
		level notify ("truss_fall_start");
		level notify ("rotor_fall_start");
		level.davinci_collapsed = true;
		thread damage_explosions();
	}

	//VisionSetNaked( "Sciencecenter_b_07", 2.3);
	//thread falling_light_large();
	thread collision_davinci();
	wait(5.0);
	level thread jl_ending_kill_floor2(); // jeremyl kill second floor when this crashes.
	thread fire_barrier_mainhall();

	//Steve G
	heli_fire_org_var = getentarray("heli_fire_org", "targetname");
	if(isdefined(heli_fire_org_var))
	{
		for(i = 0; i < heli_fire_org_var.size; i++)	
			heli_fire_org_var[i] playloopsound("heli_fire_low", 0.7);
	}
	//iprintlnbold("KABLAAAAM!!!");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Move collision for DaVinci pieces into place
///////////////////////////////////////////////////////////////////////////////////////
collision_davinci()
{
	collision = getentarray("collision_davinci", "targetname");

	for (i=0; i<collision.size; i++)
	{
		collision[i] movez(377, 0.1);
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	New skip to points
///////////////////////////////////////////////////////////////////////////////////////
skip_to_points()
{

	if(Getdvar( "skipto" ) == "0" )
	{
		return;
	}     
	else if(Getdvar( "skipto" ) == "RopeSlide" )
	{
		level thread maps\miami_science_center_catwalk::vent_access_door();
		level thread maps\miami_science_center_catwalk::initiate_rope_slide();
		level notify ( "end_rain" );

		setdvar("skipto", "0");

		start_org = getent( "skip_to_rope", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));
	}

	else if(Getdvar( "skipto" ) == "Elevator" )
	{
		level notify ( "basement" );
		level notify ( "end_rain" );

		setdvar("skipto", "0");

		start_org = getent( "skip_to_elevator", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin( start_org.origin);
		level.player setplayerangles((start_org_angles));

		wait(0.5);

		//level thread maps\miami_science_center_basement::security_access_computer();
		level thread maps\sciencecenter_b::access_camera_controls();
	}

	else if(Getdvar( "skipto" ) == "Mainhall" )
	{
		setdvar("skipto", "0");

		level notify ( "end_rain" );

		start_org = getent( "skip_to_mainhall", "targetname" );
		start_org_angles = start_org.angles;

		level.player setorigin(start_org.origin);
		level.player setplayerangles((start_org_angles));

		wait(0.05);
		level notify("ready_mainhall");

		// we need dimi
		dimi_boss = getent("dimi_boss_fight", "script_noteworthy");
		level.dimitrios = dimi_boss stalingradspawn();
		level.dimitrios thread elevator_run_into_sight();
		level notify("dimi_run_now");

		// kill fuentes because he's not spawned and he's at the beginning of the level
		fuentes = getent("thug_overrail", "targetname");
		if(isdefined(fuentes))
			fuentes delete();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Steam FX
///////////////////////////////////////////////////////////////////////////////////////
steam_fx()
{
	// condensed these 9 functions into 1 function
	thread steam_fx_on_trigger("trigger_steam_01", (318, 585, 995));
	thread steam_fx_on_trigger("trigger_steam_02", (318, 532, 995));
	thread steam_fx_on_trigger("trigger_steam_03", (310, 376, 979));
	thread steam_fx_on_trigger("trigger_steam_04", (158, 561, 998));
	thread steam_fx_on_trigger("trigger_steam_05", (158, 396, 978));
	thread steam_fx_on_trigger("trigger_steam_06", (158, 384, 978));
	thread steam_fx_on_trigger("trigger_steam_07", (158, 372, 978));
	thread steam_fx_on_trigger("trigger_steam_08", (158, 360, 978));
	thread steam_fx_on_trigger("trigger_steam_09", (612, -98, 965));
	//thread steam_fx_01();
	//thread steam_fx_02();
	//thread steam_fx_03();
	//thread steam_fx_04();
	//thread steam_fx_05();
	//thread steam_fx_06();
	//thread steam_fx_07();
	//thread steam_fx_08();
	//thread steam_fx_09();

	level notify("playmusicpackage_start");
}
steam_fx_on_trigger(triggername, origin)
{
	trigger = getent(triggername, "targetname");
	trigger waittill("trigger");

	playfx(level._effect["steam_large"], origin);	
}

//steam_fx_01()
//{
//	trigger = getent("trigger_steam_01", "targetname");
//	trigger waittill("trigger");
//
//	steam01_tag = getent("tag_steam_01", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam01_tag, "tag_origin" );	
//}
//
//steam_fx_02()
//{
//	trigger = getent("trigger_steam_02", "targetname");
//	trigger waittill("trigger");
//
//	steam02_tag = getent("tag_steam_02", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam02_tag, "tag_origin" );	
//}
//
//steam_fx_03()
//{
//	trigger = getent("trigger_steam_03", "targetname");
//	trigger waittill("trigger");
//
//	steam03_tag = getent("tag_steam_03", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam03_tag, "tag_origin" );	
//}
//
//steam_fx_04()
//{
//	trigger = getent("trigger_steam_04", "targetname");
//	trigger waittill("trigger");
//
//	steam04_tag = getent("tag_steam_04", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam04_tag, "tag_origin" );	
//}
//
//steam_fx_05()
//{
//	trigger = getent("trigger_steam_05", "targetname");
//	trigger waittill("trigger");
//
//	steam05_tag = getent("tag_steam_05", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam05_tag, "tag_origin" );	
//}
//
//steam_fx_06()
//{
//	trigger = getent("trigger_steam_06", "targetname");
//	trigger waittill("trigger");
//
//	steam06_tag = getent("tag_steam_06", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam06_tag, "tag_origin" );	
//}
//
//steam_fx_07()
//{
//	trigger = getent("trigger_steam_07", "targetname");
//	trigger waittill("trigger");
//
//	steam07_tag = getent("tag_steam_07", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam07_tag, "tag_origin" );	
//}
//
//steam_fx_08()
//{
//	trigger = getent("trigger_steam_08", "targetname");
//	trigger waittill("trigger");
//
//	steam08_tag = getent("tag_steam_08", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam08_tag, "tag_origin" );	
//}
//
//steam_fx_09()
//{
//	trigger = getent("trigger_steam_09", "targetname");
//	trigger waittill("trigger");
//
//	steam09_tag = getent("tag_steam_09", "targetname");
//
//	playfxontag( level._effect[ "steam_large" ], steam09_tag, "tag_origin" );
//}



///////////////////////////////////////////////////////////////////////////////////////
//	Fire barrier when DaVinci falls
///////////////////////////////////////////////////////////////////////////////////////
fire_barrier_mainhall()
{
	//fire_tag = getentarray("tag_fire_davinci", "targetname");
	fire_tag = [];
	fire_tag[0] = spawn("script_model", (-230, 1520, 110));
	fire_tag[0] setmodel("tag_origin");
	fire_tag[1] = spawn("script_model", (-120.5, 1474.5, 74));
	fire_tag[1] setmodel("tag_origin");
	fire_tag[2] = spawn("script_model", (-2.5, 1449.5, 108));
	fire_tag[2] setmodel("tag_origin");
	fire_tag[3] = spawn("script_model", (148.5, 1472, 74));
	fire_tag[3] setmodel("tag_origin");
	fire_tag[4] = spawn("script_model", (246, 1520, 110));
	fire_tag[4] setmodel("tag_origin");

	wait(2.0);
	for(i = 0; i < fire_tag.size; i++)
	{
		playfxontag( level._effect[ "floor_fire" ], fire_tag[i], "tag_origin" );

		//Steve G
		fire_tag[i] Playloopsound ("sci_b_small_fire");
	}

	//for(i = 0; i < fire_tag.size; i++)
	//{
	//	if(isdefined(fire_tag[i]))
	//		fire_tag[i] delete();
	//}

	level.triggerhurt trigger_on();

	// send this so we know when the fire starts
	//iprintlnbold("fire notify");
	level notify("mainhall_fire_on");
}



///////////////////////////////////////////////////////////////////////////////////////
//	Kill trigger for elevator explosion
///////////////////////////////////////////////////////////////////////////////////////
Elevator_explosion_kill()
{
	trigger = getent("triggerhurt_elevator", "targetname");

	trigger trigger_off();

	level waittill("fireball");

	wait(1.0);
	
	level notify("playmusicpackage_hall");

	//trigger trigger_on();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Explosion outside of elevator
///////////////////////////////////////////////////////////////////////////////////////
explosion_outside_elevator()
{
	elev_exp_org = (5.5, 2976, 172);//getent("elevator_explosion_org", "targetname");
	elev_exp_glass_org = (-116.5, 2784, 172);//getent("elevator_explosion_glass_org", "targetname");
	elev_exp_desk_org = (113.5, 2784.5, 172);//getent("elevator_explosion_desk_org", "targetname");

	//tag = getent("tag_elevator_explosion", "targetname");
	tag = spawn("script_model", (8, 3001, 152));
	tag setmodel("tag_origin");

	playfxontag( level._effect[ "outside_elevator_exp" ], tag, "tag_origin" );

	wait(0.1);

	tag playsound("wpn_dad_impact");	
	earthquake( 0.3, 1, level.player.origin, 300 );

	wait(0.1);

	radiusdamage(elev_exp_org, 100, 75, 50);
	radiusdamage(elev_exp_glass_org, 50, 200, 200);
	radiusdamage(elev_exp_desk_org, 50, 75, 50);

	//level.player play_dialogue("SCH1_SciBG02A_049A", false); // man screaming

	//tag delete();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Banners wave when shot
///////////////////////////////////////////////////////////////////////////////////////
banner_wave(triggername, notifyname)
{
	trigger = getent(triggername, "targetname");

	while(1)
	{
		trigger waittill("trigger");

		level notify(notifyname);

		wait(2.0);  
	}
}
//banner_01()
//{
//	trigger = getent("trigger_banner_01", "targetname");
//
//	while(1)
//	{
//		trigger waittill("trigger");
//
//		level notify("sc_banner_01_start");
//
//		wait(2.0);  
//	}
//}
//
//banner_02()
//{
//	trigger = getent("trigger_banner_02", "targetname");
//
//	while(1)
//	{
//		trigger waittill("trigger");
//
//		level notify("sc_banner_02_start");
//
//		wait(2.0);  
//	}
//}
//
//banner_03()
//{
//	trigger = getent("trigger_banner_03", "targetname");
//
//	while(1)
//	{
//		trigger waittill("trigger");
//
//		level notify("sc_banner_03_start");
//
//		wait(2.0);  
//	}
//}
//
//banner_04()
//{
//	trigger = getent("trigger_banner_04", "targetname");
//
//	while(1)
//	{
//		trigger waittill("trigger");
//
//		level notify("sc_banner_04_start");
//
//		wait(2.0);  
//	}
//}
//
//banner_05()
//{
//	trigger = getent("trigger_banner_05", "targetname");
//
//	while(1)
//	{
//		trigger waittill("trigger");
//
//		level notify("sc_banner_05_start");
//
//		wait(2.0);  
//	}
//}
//
//banner_06()
//{
//	trigger = getent("trigger_banner_06", "targetname");
//
//	while(1)
//	{
//		trigger waittill("trigger");
//
//		level notify("sc_banner_06_start");
//
//		wait(2.0);  
//	}
//}



///////////////////////////////////////////////////////////////////////////////////////
//	Challenge achievement - shoot down the lights
///////////////////////////////////////////////////////////////////////////////////////
challenge_shoot_lights()
{
	level.lights_shot_down++;

	if (level.lights_shot_down > 3)
	{
		GiveAchievement("Challenge_ScienceInt");
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Mainhall falling lights
///////////////////////////////////////////////////////////////////////////////////////
falling_light(triggername, lightarrayname, origin)
{
	trigger = getent(triggername, "targetname");
	trigger waittill("trigger");

	lightarray = getentarray(lightarrayname, "targetname");
	lightarray[0] playsound ("Light_Fixture_Crash");
	
	for(i = 0; i < lightarray.size; i++)
	{
		playfx(level._effect["science_lamp_burst"], lightarray[i].origin);
		wait(0.1);
	}

	for(i = 0; i < lightarray.size; i++)
	{
		lightarray[i] movez(-400, 0.75);
	}

	wait(0.8);

	playfx(level._effect["science_lamp_truss_hit"], origin);
	radiusdamage(origin, 125, 200, 200);

	wait(0.1);

	//lightarray[0] playsound ("Light_Fixture_Crash");
	level.player playsound ("Light_Fixture_Crash");
	for(i = 0; i < lightarray.size; i++)
	{
		if(isdefined(lightarray[i]))
		{
			lightarray[i] delete();
		}
	}
	earthquake(0.3, 1, level.player.origin, 300);

	level thread challenge_shoot_lights();
}

//falling_light_01()
//{
//	trigger = getent("trigger_lightfall_01", "targetname");
//	trigger waittill("trigger");
//
//	light_01 = getentarray("mainhall_lights_small_01", "targetname");
//	origin_explosion = getent("origin_light01_explosion", "targetname");
//
//	light_01[0] playsound ("Light_Fixture_Crash");
//
//	for (k=0; k<light_01.size; k++)
//	{
//		playfx( level._effect[ "science_lamp_burst" ], light_01[k].origin );
//		wait(0.1);
//	}
//
//	for (i=0; i<light_01.size; i++)
//	{
//		light_01[i] movez(-400, 0.75);
//	}
//
//	wait(0.8);
//
//	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
//	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
//
//	wait(0.1);
//
//	for (j=0; j<light_01.size; j++)
//	{
//		if (isdefined(light_01[j]))
//		{
//			light_01[j] delete();
//		}
//	}
//
//	origin_explosion playsound ("Light_Fixture_Crash");
//	earthquake( 0.3, 1, level.player.origin, 300 );
//
//	level thread challenge_shoot_lights();
//}
//
//
//falling_light_02()
//{
//	trigger = getent("trigger_lightfall_02", "targetname");
//	trigger waittill("trigger");
//
//	light_02 = getentarray("mainhall_lights_small_02", "targetname");
//	origin_explosion = getent("origin_light02_explosion", "targetname");
//
//	light_02[0] playsound ("Light_Fixture_Crash");
//
//	for (k=0; k<light_02.size; k++)
//	{
//		playfx( level._effect[ "science_lamp_burst" ], light_02[k].origin );
//		wait(0.1);
//	}
//
//	for (i=0; i<light_02.size; i++)
//	{
//		light_02[i] movez(-400, 0.75);
//	}
//
//	wait(0.8);
//
//	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
//	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
//
//	wait(0.1);
//
//	for (j=0; j<light_02.size; j++)
//	{
//		if (isdefined(light_02[j]))
//		{
//			light_02[j] delete();
//		}
//	}
//
//	origin_explosion playsound ("Light_Fixture_Crash");
//	earthquake( 0.3, 1, level.player.origin, 300 );
//
//	level thread challenge_shoot_lights();
//}
//
//
//falling_light_03()
//{
//	trigger = getent("trigger_lightfall_03", "targetname");
//	trigger waittill("trigger");
//
//	light_03 = getentarray("mainhall_lights_small_03", "targetname");
//	origin_explosion = getent("origin_light03_explosion", "targetname");
//
//	light_03[0] playsound ("Light_Fixture_Crash");
//
//	for (k=0; k<light_03.size; k++)
//	{
//		playfx( level._effect[ "science_lamp_burst" ], light_03[k].origin );
//		wait(0.1);
//	}
//
//	for (i=0; i<light_03.size; i++)
//	{
//		light_03[i] movez(-400, 0.75);
//	}
//
//	wait(0.8);
//
//	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
//	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
//
//	wait(0.1);
//
//	for (j=0; j<light_03.size; j++)
//	{
//		if (isdefined(light_03[j]))
//		{
//			light_03[j] delete();
//		}
//	}
//
//	origin_explosion playsound ("Light_Fixture_Crash");
//	earthquake( 0.3, 1, level.player.origin, 300 );
//
//	level thread challenge_shoot_lights();
//}
//
//
//falling_light_04()
//{
//	trigger = getent("trigger_lightfall_04", "targetname");
//	trigger waittill("trigger");
//
//	light_04 = getentarray("mainhall_lights_small_04", "targetname");
//	origin_explosion = spawn("script_origin", (244, 1496, 88));
//	//origin_explosion = getent("origin_light04_explosion", "targetname");
//
//	light_04[0] playsound ("Light_Fixture_Crash");
//
//	for (k=0; k<light_04.size; k++)
//	{
//		playfx( level._effect[ "science_lamp_burst" ], light_04[k].origin );
//		wait(0.1);
//	}
//
//	for (i=0; i<light_04.size; i++)
//	{
//		light_04[i] movez(-400, 0.75);
//	}
//
//	wait(0.8);
//
//	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
//	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
//
//	wait(0.1);
//
//	for (j=0; j<light_04.size; j++)
//	{
//		if (isdefined(light_04[j]))
//		{
//			light_04[j] delete();
//		}
//	}
//
//	origin_explosion playsound ("Light_Fixture_Crash");
//	earthquake( 0.3, 1, level.player.origin, 300 );
//
//	level thread challenge_shoot_lights();
//	
//	origin_explosion delete();
//}
//
//
//falling_light_05()
//{
//	trigger = getent("trigger_lightfall_05", "targetname");
//	trigger waittill("trigger");
//
//	light_05 = getentarray("mainhall_lights_small_05", "targetname");
//	origin_explosion = spawn("script_origin", (-229, 1192, 88));
//	//origin_explosion = getent("origin_light05_explosion", "targetname");
//
//	light_05[0] playsound ("Light_Fixture_Crash");
//
//	for (k=0; k<light_05.size; k++)
//	{
//		playfx( level._effect[ "science_lamp_burst" ], light_05[k].origin );
//		wait(0.1);
//	}
//
//	for (i=0; i<light_05.size; i++)
//	{
//		light_05[i] movez(-400, 0.75);
//	}
//
//	wait(0.8);
//
//	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion );
//	radiusdamage ( origin_explosion, 125, 200, 200 );
//
//	wait(0.1);
//
//	for (j=0; j<light_05.size; j++)
//	{
//		if (isdefined(light_05[j]))
//		{
//			light_05[j] delete();
//		}
//	}
//
//	origin_explosion playsound ("Light_Fixture_Crash");
//	earthquake( 0.3, 1, level.player.origin, 300 );
//
//	level thread challenge_shoot_lights();
//
//	origin_explosion delete();
//}
//
//
//falling_light_06()
//{
//	trigger = getent("trigger_lightfall_06", "targetname");
//	trigger waittill("trigger");
//
//	light_06 = getentarray("mainhall_lights_small_06", "targetname");
//	origin_explosion = spawn("script_origin", (244, 1192, 88));
//	//origin_explosion = getent("origin_light06_explosion", "targetname");
//
//	if(isdefined(light_06))
//	{
//		light_06[0] playsound ("Light_Fixture_Crash");
//	}
//
//	for (k=0; k<light_06.size; k++)
//	{
//		playfx( level._effect[ "science_lamp_burst" ], light_06[k].origin );
//		wait(0.1);
//	}
//
//	for (i=0; i<light_06.size; i++)
//	{
//		light_06[i] movez(-400, 0.75);
//	}
//
//	wait(0.8);
//
//	playfx( level._effect[ "science_lamp_truss_hit" ], origin_explosion.origin );
//	radiusdamage ( origin_explosion.origin, 125, 200, 200 );
//
//	wait(0.1);
//
//	for (j=0; j<light_06.size; j++)
//	{
//		if (isdefined(light_06[j]))
//		{
//			light_06[j] delete();
//		}
//	}
//
//	origin_explosion playsound ("Light_Fixture_Crash");
//	earthquake( 0.3, 1, level.player.origin, 300 );
//
//	level thread challenge_shoot_lights();
//	
//	origin_explosion delete();
//}


falling_light_large()
{
	light = getentarray("mainhall_lights_large", "targetname");
	origin_explosion = getent("origin_light_explosion", "targetname");
	
	wait(2.0);

	for (k=0; k<light.size; k++)
	{
		playfx( level._effect[ "science_lamp_burst" ], light[k].origin );
		wait(0.1);
	}

	for (i=0; i<light.size; i++)
	{
		light[i] movez(-356, 0.75);
	}

	wait(0.8);

	//	playfx( level._effect[ "science_exhibit_exp03" ], origin_explosion.origin );
	//radiusdamage ( origin_explosion.origin, 200, 200, 200 );

	wait(0.1);

	origin_explosion playsound ("Light_Fixture_Crash");
	//earthquake( 0.3, 1, level.player.origin, 300 );

	//fire_tag = getentarray("tag_fire_light", "targetname");
	fire_tag = [];
	fire_tag[0] = spawn("script_model", (61.5, 1367, 74));
	fire_tag[0] setmodel("tag_origin");
	fire_tag[1] = spawn("script_model", (138.5, 1362, 74));
	fire_tag[1] setmodel("tag_origin");
	for (j=0; j<fire_tag.size; j++)
	{
		playfxontag( level._effect[ "rpg_fire" ], fire_tag[j], "tag_origin" );
	}
	for(i = 0; i < fire_tag.size; i++)
	{
		if(isdefined(fire_tag[i]))
			fire_tag[i] delete();
	}
}



///////////////////////////////////////////////////////////////////////////////////////
//	Radius damage caused by falling davinci/heli pieces
///////////////////////////////////////////////////////////////////////////////////////
damage_explosions()
{
	origin_davinci = getent("origin_davinci_damage", "targetname");
	origin_heli = getent("origin_heli_damage", "targetname");
	origin_wing = getent("origin_wing_damage", "targetname");
	//tag_davinci = getent("tag_davinci_explosion", "targetname");
	//tag_davinci = spawn("script_model", (-125, 1217, 84));
	//tag_davinci setmodel("tag_origin");

	wait(0.5);

	//thread spawn_redshirts();

	wait(4.5);

	playfx(level._effect[ "science_gas_exp" ], (-125, 1217, 84));
	crates = getentarray("crate_weapons", "targetname");

	for (i=0; i<crates.size; i++)
	{
		if (isdefined(crates[i]))
		{
			crates[i] delete();
		}
	}

	wait(0.5);

	radiusdamage ( origin_davinci.origin, 50, 240, 240 );

	wait(1.2);

	radiusdamage ( origin_heli.origin, 250, 200, 200 );

	wait(1.5);

	//	playfx( level._effect[ "science_exhibit_exp03" ], origin_wing.origin );
	earthquake( 0.3, 1, level.player.origin, 300 );

	radiusdamage ( origin_wing.origin, 200, 200, 200 );

	//tag_davinci delete();
}



/////////////////////////////////////////////////////////////////////////////////////////
////	Spawn guards to be killed by DaVinci/Heli fall
/////////////////////////////////////////////////////////////////////////////////////////
//spawn_redshirts()
//{
//	spawnerarray = getentarray("guard_davinci", "targetname");
//
//	for (i=0; i<spawnerarray.size; i++)
//	{
//		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_davinci");
//	}
//}



///////////////////////////////////////////////////////////////////////////////////////
//	Sparks when elevator falls
///////////////////////////////////////////////////////////////////////////////////////
elevator_sparks()
{
	//tag_sparks = getentarray("tag_elevator_sparks", "targetname");
	tag_sparks = [];
	tag_sparks[0] = spawn("script_model", (-74, 3182, 132));
	tag_sparks[0] setmodel("tag_origin");
	tag_sparks[1] = spawn("script_model", (61, 3181, 132));
	tag_sparks[1] setmodel("tag_origin");
	tag_sparks[2] = spawn("script_model", (-74, 3047, 132));
	tag_sparks[2] setmodel("tag_origin");
	tag_sparks[3] = spawn("script_model", (62, 3047, 132));
	tag_sparks[3] setmodel("tag_origin");

	elevator = getent("securityElevMain", "targetname");

	while(!(level.elevator_crashed))
	{
		for (i=0; i<tag_sparks.size; i++)
		{
			playfxontag( level._effect[ "elevator_sparks" ], tag_sparks[i], "tag_origin" );
			tag_sparks[i] linkto(elevator);
		}
		wait(0.1);
	}

	for(i = 0; i < tag_sparks.size; i++)
	{
		if(isdefined(tag_sparks[i]))
			tag_sparks[i] delete();
	}
}
//drop_panels()
//{
//	panel = getent("falling_panel1", "targetname");
//	if(isdefined(panel))
//	{
//		panel physicslaunch(panel.origin, (0, -5, 0));
//		wait(2.0);
//	}
//
//	// now drop the other and make it rotate
//	panel = getent("falling_panel2", "targetname");
//	if(isdefined(panel))
//	{
//		panel physicslaunch(panel.origin, (0, -5, 0));
//		count = 0;
//		while(count < 3)
//		{
//			panel rotateroll(360.0, 2.0);		
//			wait(2.0);
//			count++;
//		}
//	}
//}

// SECURITY CAMERA ADDED TO BEGINING OF LEVEL //

e1_camera()
{
	e1_camera_1 = GetEnt("ent_e1_camera_1", "targetname");

	ent_e1_hack_cam1 = GetEnt("ent_e1_cam_hack", "targetname");

	e1_camera_1 thread maps\_securitycamera::camera_start(ent_e1_hack_cam1, true, false, false);
	// NOTE: need to know when we spawn elites, so we can make them move per bug 17038
	e1_camera_1 thread camera_watch();

	enta_e1_cams = [];
	enta_e1_cams = add_to_array(enta_e1_cams, e1_camera_1);

	//	feed_box = GetEnt("ent_e1_feed_box", "targetname");
	//	level thread maps\_securitycamera::camera_tap_start(feed_box, enta_e1_cams);
	//	
	//	feed_box waittill("tapped");
	//	maps\miami_science_center_catwalk::start_catwalk1_patrol();
}
camera_watch()
{
	self endon("disable");
	self endon("damage");

	//iprintlnbold("camera_watch");

	self waittill("spotted");
	//iprintlnbold("seen by camera");

	// if the alert has already happened get out
	if(level.catwalk1_red_alert)
	{
		return;
	}

	// alert the guards
	guard = getent("guard_01", "targetname");
	if(isdefined(guard))
	{
		guard setalertstatemin("alert_red");
		guard setperfectsense(true);
	}
	guard = getent("guard_02", "targetname");
	if(isdefined(guard))
	{
		guard setalertstatemin("alert_red");
		guard setperfectsense(true);
	}
	// give the elites perfect sense
	elites = getentarray("catwalk1_elites", "targetname");
	if(isdefined(elites))
	{
		for(i = 0; i < elites.size; i++)
		{
			guard = elites[i] stalingradspawn();
			if(isdefined(guard))
			{
				//iprintlnbold("set perfect sense");
				guard setperfectsense(true);
				//iprintlnbold("set to rusher");
				guard setcombatrole("rusher");
			}
		}
	}
}

// ---------------------//
//views of level

monitor_cam()
{

	cam_pos = [];
	cam_pos[0] = ( -262, -257, 832 );			// first catwalk
	cam_pos[1] = ( -49.26, 2611.13, 9.23 );		// basement
	cam_pos[2] = ( -282, 646, 620 );			// main hall


	monitor_cameras = [];

	// setup a faux camera that looks like it's the monitor cam
	monitor_cameras[0] = getent("monitor_cam1", "targetname");
	if(isdefined(monitor_cameras[0]))
	{
		monitor_cameras[0].script_float = 30;
		monitor_cameras[0].script_int = 5;
		monitor_cameras[0] thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);
	}

	// setup a faux camera that looks like it's the monitor cam
	monitor_cameras[1] = getent("monitor_cam2", "targetname");
	if(isdefined(monitor_cameras[1]))
	{
		monitor_cameras[1].script_float = 30;
		monitor_cameras[1].script_int = 5;
		monitor_cameras[1] thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);
	}

	// spawn an origin if there is no camera there
	monitor_cameras[2] = spawn("script_origin", cam_pos[2]);
	monitor_cameras[2].script_float = 30;
	monitor_cameras[2].script_int = 5;
	monitor_cameras[2].angles = (30, 63, 0);
	// setup cameras	
	monitor_cameras[2] thread maps\_securitycamera::camera_start(undefined, false, undefined, undefined);

	// feed boxes
	feed_box = GetEnt("ent_e1_feed_box", "targetname");	//nr start, could use another
	level thread maps\_securitycamera::camera_tap_start(feed_box, monitor_cameras);

	feed_box = GetEnt("feed_box2", "targetname");	//in basement
	level thread maps\_securitycamera::camera_tap_start(feed_box, monitor_cameras);


	//spawn guys - maybe spawn right away so this won't be necessary?
	feed_box waittill("tapped");
	maps\miami_science_center_catwalk::start_catwalk1_patrol();

}
////////////////////////////////////////////////////////////////////////////////////
//                    CARLOS DIMITRI CUTSCENE                
////////////////////////////////////////////////////////////////////////////////////
setup_security_feed()
{
	security_screen = GetEnt("security_screen", "targetname");
	security_screen hide();
	/*	
	monitor_camera = spawn( "script_origin", ( -282, 646, 620 ));
	monitor_camera.angles = ( 30, 63, 0 );
	monitor_camera.script_float = 30;

	monitor_camera thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );

	monitor_camera.destroyed = false;
	monitor_camera.disabled = false;
	monitor_camera thread maps\_securitycamera::camera_phone_track( true, true );
	*/
}	

start_dimitri_carlos_cutscene()
{
	security_screen = GetEnt("security_screen", "targetname");
	//security_screen hide();

	//level.player customcamera_checkcollisions( 0 );

	monitor_camera = spawn( "script_origin", (100.03, 1278.38, 243.35));
	monitor_camera.angles = (27.78, 159.10, 0);


	monitor_camera.destroyed = false;
	monitor_camera.disabled = false;
	monitor_camera thread maps\_securitycamera::camera_phone_track( true, true );
	wait(0.5);
	security_screen show();
	//iprintlnbold("SOUND: screen on");
	security_screen playsound ("monitor_on");


	/*	
	// save player position.
	playerpos = level.player.origin;
	playerangles = level.player.angles;
	wait(0.05);

	// temporary custom camera for testing. Needs to be through security cam.
	cameraID = level.player CustomCamera_Push("world", (172.29, 1251.64, 402.81), (39.20, 162.46, 0), 0.0);
	level.player customcamera_setFov( cameraID, 40.0, 3.0, 0.0, 0.0 );
	*/
	playcutscene("SCB_BombHandoff","cutscene_done");

	thread delete_cutscene_stuff(security_screen, monitor_camera);	// I created this thread so that we can delete the monitor camera stuff once the player enters the elevator
	level.computer play_dialogue("DIMI_SciBG02A_034A"); // miami airport, terminal C gate 4
}
delete_cutscene_stuff(screen, camera)
{
	level waittill("cutscene_done");

	screen delete();
	wait(0.5);
	level.player enablevideocamera( false );
	camera delete();
}




///////////////////////////////////////////////////////////
//						DELETING ENTITIES
///////////////////////////////////////////////////////////
//avulaj
//
delete_all_ai()
{
	count = 0;
	guys = getaiarray("axis", "neutral");

	for (i=0; i<guys.size; i++)
	{
		guys[i] delete();
		count++;
	}

	//iprintlnbold("ai deleted: " + count);
}
delete_catwalk_spawners()
{
	ent_count = 0;
	// spawners
	ent = getent("spawner_thug_overrail", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("guard_01_spawner", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("guard_02_spawner", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("catwalk1_elites", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	//ent = getent("catwalk_thug_02", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	ent = getentarray("catwalk2_thug", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getent("catwalk2_thug_05", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("catwalk2_thug_06", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("catwalk2_thug_09", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("final_catwalk_guards", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}

	//iprintlnbold("spawner's deleted: " + ent_count);
}
delete_catwalk_triggers()
{
	ent_count = 0;
	// triggers
	//ent = getent("trigger_open_door", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	//ent = getent("trigger_thug_overrail", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	ent = getent("trigger_map_2to1", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_1to2", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("player_in_catwalk1a", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_catwalk2_reached", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("player_in_catwalk1b", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("catwalk_longway", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	//ent = getent("trigger_savegame_catwalk1", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	ent = getent("trigger_reached_maincatwalk", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_spawn_backup", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("catwalk2_guard_final", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_savegame_catwalk2", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("catwalk_no_spawn_trigger", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getent("trigger_balance_mainhall", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_spawn_balance", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}

	//iprintlnbold("trig's deleted: " + ent_count);
}
delete_basement_spawners()
{
	ent_count = 0;
	// spawners
	ent = getent("guard_art_room", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("guard_security_01", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getentarray("guard_reinforce_artroom", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getentarray("guard_basement_reinforce", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getentarray("elite_basement_reinforce", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}
	ent = getentarray("guard_security_conversation", "targetname");
	if(isdefined(ent))
	{
		for(i = 0; i < ent.size; i++)	
		{
			ent[i] delete();
			ent_count++;
		}
	}

	//iprintlnbold("spawner's deleted: " + ent_count);
}
delete_basement_triggers()
{
	ent_count = 0;
	// triggers
	//ent = getent("stair_center_lock_player", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	ent = getent("stairs_end", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_3to2", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("section_one_thug_trigger", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_2to3", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	//ent = getent("trigger_spawn_artroom", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	ent = getent("trigger_resume_patrol", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_spawn_officeguard", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	//ent = getent("trigger_release_artroom", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	ent = getent("trigger_check_alert", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	//ent = getent("trigger_spawn_office", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	//ent = getent("trigger_office_reinforce", "targetname");
	//if(isdefined(ent))
	//{
	//	ent delete();
	//	ent_count++;
	//}
	ent = getent("trigger_monitor_guards", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_security_reached", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("basement_elevator_save_trig", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("trigger_map_3to4", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}
	ent = getent("basement_start_ele", "targetname");
	if(isdefined(ent))
	{
		ent delete();
		ent_count++;
	}

	//iprintlnbold("trig's deleted: " + ent_count);
}
///////////////////////////////////////////////////////////
