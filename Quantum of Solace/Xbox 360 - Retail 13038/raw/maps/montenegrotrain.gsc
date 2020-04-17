// Montenegro Train main
// Builder: Don Sielke
// Scripter: Don Sielke
//////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;
// trying to get teh match up to work
#include animscripts\Utility;
#include animscripts\shared;
#include maps\_anim;
#using_animtree("generic_human");




//////////////////////////////////////////////////////////////////////////////////////////
//
//	Montenegro Train
//
//////////////////////////////////////////////////////////////////////////////////////////
main()
{
				thread maps\MontenegroTrain_fx::main();//needs to be before main
				


				//setup compass maps
				//precacheShader( "compass_map_montenegrotrain_01" );
				//precacheShader( "compass_map_montenegrotrain_02" );
				//precacheShader( "compass_map_montenegrotrain_03" );
				//precacheShader( "compass_map_montenegrotrain_04" );
				//precacheShader( "compass_map_montenegrotrain_05" );
				//precacheShader( "compass_map_montenegrotrain_06" );
				//precacheShader( "compass_map_montenegrotrain_07" );
				//precacheShader( "compass_map_montenegrotrain_08" );
				//precacheShader( "compass_map_montenegrotrain_09" );

				level maps\_utility::timer_init();
				precacheShader( "videocamera_hud_train1" );

				precachemodel("p_lit_ceiling_light_on");
				precachemodel("p_lit_ceiling_light_off");

				// precaching the models for the intro
				precacheModel( "p_igc_vesper_business_card" );
				precacheModel( "p_igc_bliss_headshot" );
				precacheModel( "w_t_baton");

				// precaching bag for bag toss
				precacheModel( "p_igc_duffle_bag" );

				// models for the destroyed tables
				precacheModel( "p_lvl_train_dining_tbl_sngl_d" );
				precacheModel( "p_lvl_train_dining_tbl_d" );
				
				// DCS: precache grinder.
				Precachemodel("p_msc_grinder");

				// broken bo
				precacheModel( "d_crate_base" );

				PreCacheItem("flash_grenade");
				PreCacheItem("w_t_grenade_flash");
				PreCacheItem("p99_wet_s");
				PreCacheItem("p99_wet");
				precacheShellshock( "default" );
				precacheshellshock ("flashbang");

				/////////////////////////////////////////////////////////////////////////
				// 04-25-08
				// wwilliams
				// precaching the cutscene
				PrecacheCutScene( "Train_Bond_Jump" );
				// 05-27-08
				// wwilliams
				// precaching the new intro
				PrecacheCutScene( "MT_TR_Intro" );
				// iprintlnbold( "passed pre cache" );
				/////////////////////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 04-16-08
				// wwilliams 
				// adding level.strings info for the phones
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				level.strings["train_phone1_name"] = &"MONTENEGROTRAIN_PHONE_NAME1";
				level.strings["train_phone1_body"] = &"MONTENEGROTRAIN_PHONE_BODY1";

				level.strings["train_phone2_name"] = &"MONTENEGROTRAIN_PHONE_NAME2";
				level.strings["train_phone2_body"] = &"MONTENEGROTRAIN_PHONE_BODY2";

				level.strings["train_phone3_name"] = &"MONTENEGROTRAIN_PHONE_NAME3";
				level.strings["train_phone3_body"] = &"MONTENEGROTRAIN_PHONE_BODY3";

				level.strings["train_phone4_name"] = &"MONTENEGROTRAIN_PHONE_NAME4";
				level.strings["train_phone4_body"] = &"MONTENEGROTRAIN_PHONE_BODY4";

				level.strings["train_phone5_name"] = &"MONTENEGROTRAIN_PHONE_NAME5";
				level.strings["train_phone5_body"] = &"MONTENEGROTRAIN_PHONE_BODY5";
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// level.strings end
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


				maps\_load::main();

				//setup music
				 thread maps\montenegrotrain_snd::main();
				 thread maps\montenegrotrain_mus::main();

				//set the exponential fog - now set in _fx
				//	setExpFog(2000, 6000,3/255, 17/255, 26/255, 0);
				// Visionsetnaked( "default_glow" );

				// 05-16-08
				// wwilliams
				// setting the sun sample scale
				if(level.ps3)
				{
					SetDVar( "sm_SunSampleSizeNear", "0.5" );
				}
				else
				{
					SetDVar( "sm_SunSampleSizeNear", "2.0" );
				}
					
				// 05-16-08
				// wwilliams
				// send out the notify to start the lighting
				// level notify( "lightning" );
				playfx ( level._effect["lightning"], level.player.origin );

				// Level VARS
				level.bliss_run_spawner = GetEnt( "bliss_run", "targetname" );
				level.bliss_spawner = GetEnt( "bliss", "targetname" );

				level.curr_player_pos = 0;	// Keep track of what car the player is in
				level.laptops_found = 0;
				level.train_passing_by = false;

				// 07-28-08
				// manthony
				// ----- Add the Wet Materials -----
				level thread add_wet_materials();

				// 08-09-08
				// manthony
				// Make the game fade in at the start of the level (MikeA)
				gamefadeintime( 20.0 );


				//environmental background threads.
				level.standard_background = true;
				thread background_scenery_move();
				thread maps\MontenegroTrain_car8::setup_tunnel_segments();
				// thread maps\MontenegroTrain_util::bar_tap_dest_fx_precache();
				thread maps\MontenegroTrain_util::glass_physics_pulse_setup();


				thread setup_passing_train();

				//freight train
				level.freight_train_active = false;
				//////////////////////////////////////////////////////////////////////////
				// 05-10-08
				// wwilliams
				// new flag mimics this level var

				// this doesn't work, it can't find the flag because it has never been set

				/* if( flag( "freight_train_active" ) )
				{
				level flag_clear( "freight_train_active" );

				// debug text
				iprintlnbold( "cleared_freight_train_active" );
				} */
				//////////////////////////////////////////////////////////////////////////
				thread maps\MontenegroTrain_util::setup_freight_train();
				level.door_busy = false;
				level.train_moving = false;
				level.clock_running = false;

				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 04-17-08
				// wwilliams
				// set the flags for train
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				level train_flag_init();
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// flag init end
				//////////////////////////////////////////////////////////////////////////////////////////
				// 08-25-08 WWilliams
				// set cull distance for the level if in ps3
			
				
				if( level.ps3 )
				{
					setculldist( 10000 );
								
					// setexpfog( near_plane, half_plane, fog_red, fog_green, fog_blue, lerp_time, fog_max );
					SetExpFog( 500, 4000, 0.012, 0.022, 0.02, 1.0, 1.0 );									
				}
				else // if 360
				{
							// test on xenon
							setculldist( 17000 );
			
							// setexpfog( near_plane, half_plane, fog_red, fog_green, fog_blue, lerp_time, fog_max );
							SetExpFog( 2895, 7505, 0.012, 0.022, 0.02, 1.0, 1.0 );		
				}
				
				//////////////////////////////////////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////////////////////////////////////
				// 05-07-08
				// wwilliams
				// function sets up the blur and the wind
				level thread maps\MontenegroTrain_util::outside_train_init();
				//////////////////////////////////////////////////////////////////////////////////////////
				// 08-12-08 WWilliams
				// start conveyor ground
				level thread train_conveyor_ground();

				// 07-15-08 WWilliams
				// Change to the environment, rain will now start from the beginning 
				// of the level
				level thread train_rain();

				// Artist mode
				if( Getdvar( "artist" ) == "1" )
				{
								return;   
				}

				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// wwilliams
				// 05-07-08
				// link the script models to the freight train
				// level thread maps\montenegrotrain_util::ftrain_model_link();
				// 05-15-08
				// wwilliams
				// no longer using my own function for this, just added into don's freight train stuff
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//////////////////////////////////////////////////////////////////////////
				// 05-08-08
				// wwilliams
				// function sets up the sound effect for the electrical pylon damage
				level thread maps\MontenegroTrain_util::train_elec_pylon_init();
				//////////////////////////////////////////////////////////////////////////


				// monitor player position.
				thread player_monitor();

				// Level threads
				thread maps\MontenegroTrain_util::roof_hatches_setup();


				thread maps\MontenegroTrain_util::control_hud();
				thread maps\MontenegroTrain_util::setup_automatic_doors();
				thread maps\MontenegroTrain_util::setup_automatic_doors_dbl();
				thread maps\MontenegroTrain_util::setup_auto_service_doors();

				thread maps\MontenegroTrain_util::setup_environmental_trigs();



				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// 04-16-08
				// wwilliams
				// now using the phone system barnes made
				// not using this train_util func anymore
				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
				//thread maps\MontenegroTrain_util::setup_hidden_objects();
				//thread maps\montenegrotrain_snd::start_train_ambient();

				// Skiptos / checkpoints
				checkpoints();
				
				// DCS: balcony death devar to stop from happening as much (default 15 seconds)
				setSavedDvar("ai_balconyDeathInterval", 30);

}
//////////////////////////////////////////////////////////////////////////////////////////
// Intro IGC setup
//////////////////////////////////////////////////////////////////////////////////////////
//intro_igc()
//{
//
//				//level thread letterbox_on(true,true,0.05);
//				player_stick(true);
//
//				wait( 1.0 );
//
//				if (!IsDefined(level.hud_intro))
//				{
//								level.hud_intro = newHudElem();
//								level.hud_intro.x = -120;
//								level.hud_intro.y = 0;
//								level.hud_intro.horzAlign = "center";
//								level.hud_intro.vertAlign = "middle";
//								level.hud_intro.foreground = true;
//								level.hud_intro.fontScale = 2;
//				}
//				level.hud_intro settext("On a train to Montenegro");
//				wait( 3.0 );
//				level.hud_intro settext("");
//
//				if (isdefined(level.hud_intro))
//				{
//								level.hud_intro destroy();
//				}
//
//				// add first sceneanim here.
//				// iPrintLnBold( "Villiers: Bond");
//				// wait( 1.5 );
//				// iPrintLnBold( "The man you'll be replacing at the Casino Royale");
//				// wait( 1.5 );
//				// iPrintLnBold( "is a Mr. John Bliss,");
//				// wait( 1.5 );
//				// iPrintLnBold( "from a European heroin syndicate.");
//				// wait( 1.5 );
//				// WW - 07-01-08
//				// adding the sound calls for this conversation
//				// first line
//				level.player play_dialogue( "TANN_TraiG_009A", true );
//				// second line
//				level.player play_dialogue( "TANN_TraiG_009A", true );
//
//
//				//////////////////////////////////////////////////////////////////////////
//				// 05-08-08
//				// wwilliams
//				// removing the call that bring bliss's picture up, as listed in strike list
//				////temp test for camera to hud.
//				// wait(3);
//				// thread maps\MontenegroTrain_util::start_hud_camera();
//				//////////////////////////////////////////////////////////////////////////
//
//				// WW - 07-01-8
//				// Commenting out this old intro dialogue as I pass through to 
//				// add the real lines
//				/*iPrintLnBold( "I've just sent you his photo.");
//				wait( 1.5 );
//				iPrintLnBold( "Bliss is at the front of the train in a private car.");
//				wait( 1.5 );
//				iPrintLnBold( "He can't be allowed to reach Montenegro.");
//				wait( 1.5 );
//				iPrintLnBold( "Be careful, he never travels without bodyguards.");
//				wait(2.0);
//
//				//letterbox_off();
//				player_unstick();
//
//
//				//need to clear off text before save. This is temp as all of this will be part of igc.
//				iPrintLnBold( "  ");
//				iPrintLnBold( "  ");
//				iPrintLnBold( "  ");
//				iPrintLnBold( "  ");
//				iPrintLnBold( "  ");
//				iPrintLnBold( "  ");
//				iPrintLnBold( "  ");
//				iPrintLnBold( "  ");
//				iPrintLnBold( "  ");
//				wait(1.0);*/
//				// SaveGame( "montenegrotrain" );
//				level maps\_autosave::autosave_now( "montenegrotrain" );
//
//				// Add first objective
//				// objective_add(0, "active", &"MONTENEGROTRAIN_OBJECTIVE_FIND_BLISS", level.bliss_run_spawner.origin);
//}
//////////////////////////////////////////////////////////////////////////////////////////
// Finale IGC setup
//////////////////////////////////////////////////////////////////////////////////////////
finale_igc()
{
				level.end_trig = GetEnt( "end_level", "targetname" );
				if ( IsDefined( level.end_trig ) )
				{
								level.end_trig waittill( "trigger" );
								
								level thread maps\_autosave::autosave_now( "montenegrotrain" );
								
								materialsetwet( 1 );
								level notify( "boss_fight_start" );
								level.end_trig delete();

								// frame wait
								wait( 0.05 );

								// 05-16-08
								// wwilliams
								// changing the vision set back to normal
								VisionSetNaked( "MontenegroTrain_Boss", 0.5 );

								// frame wait for the vision set to kick in
								// wait( 0.05 );

								// thread off the function for the thing that hits bliss
								level thread bliss_fight_pole();

								//// hide hud.
								// setSavedDvar("cg_drawHUD","0");

								// move player to top of train before IGC start in one frame. Take away weapons so don't show in IGC.
								level.player freezeControls(true);
								forcephoneactive(false);
								maps\_utility::holster_weapons();
								setdvar("ui_hud_showcompass", 0);
								wait(0.05);

								// bliss lower health, take weapon away for IGC.
								level.bliss_run thread stop_magic_bullet_shield();
								//level.bliss_run SetDeathEnable(true);
								level.bliss_run SetPainEnable(true);
								level.bliss_run delete();




								level.bliss = level.bliss_spawner Stalingradspawn();
								level.bliss.health = 1000;
								level.bliss animscripts\shared::placeWeaponOn( level.bliss.weapon, "none" );

								level.bliss thread maps\_bossfight::boss_transition();
								level.bliss attach( "w_t_baton", "TAG_WEAPON_RIGHT" );
								level.player maps\_gameskill::saturateViewThread(false);


								// start cinematic brawl
								wait(0.05);
								start_interaction( level.player, level.bliss, "BossFight_Bliss");
								
								level.player waittillmatch("anim_notetrack", "fade_out");
								// wait( 9999 );
								if (level.boss_laststate == 1)
								{
									level thread end_to_black();
								}
/*
								level.player waittill("interaction_done");
								while(isalive(level.bliss))
								{
												wait(0.05);
												start_interaction( level.player, level.bliss, "BossFight_Bliss");
												level.player waittill("interaction_done");
								}	
*/

								


				}
				else
				{
								iPrintLnBold( "No end trigger found" );
								return;
				}	
}
end_to_black()
{
				//End Music For The Level - Added by crussom
				level notify( "endmusicpackage" );

				level.player freezeControls(true);
				player_final = GetEnt( "player_final", "targetname" );
				level.player setorigin( player_final.origin + ( 0, 0, 5 ) );
				level.player setplayerangles( player_final.angles );

				// objective_state(0, "done");
				// wait for a level notify to be sent out
				level notify( "bliss_defeated" );

				// wait(0.2);
				// changelevel( "casino" );
				
				// DCS: just incase needs to be reset.
				setdvar("ui_hud_showcompass", 1);
				level maps\_endmission::nextmission();
}
//////////////////////////////////////////////////////////////////////////
// 07-30-08 WWilliams
// wait for the notetracks on the player is order to display and move the 
// bliss hitter
// modified by zvulaj to help with the movement and timing
bliss_fight_pole()
{
				// endon

				// debug
				// iprintlnbold( "waiting for see_object" );

				// move the pole to the right spot for proper timing
				level.bliss_hitter moveto( level.bliss_hitter.origin + ( 0, 700, 0 ), 0.05, 0.0, 0.0 );

				// wait for the first notetrack
				level.player waittillmatch( "anim_notetrack", "see_object" );

				// unhide the bliss_hitter
				level.bliss_hitter show();

				// move the pole toward the two fighting on the roof
				level.bliss_hitter moveto( level.bliss_hitter.origin + ( 0, -3000, 0 ), 2.8, 0.0, 0.0 );

				// debug
				// iprintlnbold( "waiting for hit_bliss" );

				// wait for the move notetrack
				// level.player waittillmatch( "anim_notetrack", "hit_bliss" );

				// check to see if the player passed the mash or not
				level.player waittill( "interaction_pass" );

				// frame wait
				wait( 0.05 );

				// check the level var
				if( level.boss_laststate == 1 )
				{
								// iprintlnbold( "move hitter" );
								// move the pole into Bliss's head
								level.bliss_hitter moveto( ( level.bliss_hitter.origin[0], 7863, level.bliss_hitter.origin[2] ), 0.2, 0.0, 0.0 );
								// good y origin 7863
				}
				else
				{
								// iprintlnbold( "fail interaction" );
								level.bliss_hitter hide();
				}
}
///////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
//	Skipto setup
//////////////////////////////////////////////////////////////////////////////////////////
checkpoints()
{
				// Teleport player
				skipto = GetDVar( "skipto" );
				script_player_start = undefined;

				if ( skipto == "car3" )
				{
								skip3 = GetEnt( "skip3", "targetname" );
								if ( IsDefined(skip3) )
								{
												level.player setorigin( skip3.origin );
												level.player setplayerangles( skip3.angles );

												// give bond back weapons
												level.player giveWeapon("p99_wet_s");
												// level.player giveWeapon( "flash_grenade" );
												level.player switchtoWeapon("p99_wet_s");

												// wwilliams
												// objective thread
												level thread maps\MontenegroTrain_util::train_objectives();

												thread maps\MontenegroTrain_car3::e3_main();

												level.inside_train = false;
												thread maps\MontenegroTrain_util::train_shake_inside();
								}
				}
				else if ( skipto == "car5" )
				{
								skip5 = GetEnt( "skip5", "targetname" );
								if ( IsDefined(skip5) )
								{
												level.player setorigin( skip5.origin );
												level.player setplayerangles( skip5.angles );

												// give bond back weapons
												level.player giveWeapon("p99_wet_s");
												// level.player giveWeapon( "flash_grenade" );
												level.player switchtoWeapon("p99_wet_s");

												// wwilliams
												// objective thread
												level thread maps\MontenegroTrain_util::train_objectives();

												thread maps\MontenegroTrain_car5::e5_main();
												thread maps\MontenegroTrain_car6::e6_main();

												level.inside_train = false;
												thread maps\MontenegroTrain_util::train_shake_inside();
								}
				}
				else if ( skipto == "car8" )
				{
								skip8 = GetEnt( "skip8", "targetname" );
								if ( IsDefined(skip8) )
								{
												// 06-04-08
												// wwilliams
												// commenting this function out, will replace it inside car7
												// car7_guys = maps\MontenegroTrain_util::spawn_group( "nme_car7" );

												level.player setorigin( skip8.origin );
												level.player setplayerangles( skip8.angles );

												// give bond back weapons
												level.player giveWeapon("p99_wet_s");
												// level.player giveWeapon( "flash_grenade" );
												level.player switchtoWeapon("p99_wet_s");

												// wwilliams
												// objective thread
												level thread maps\MontenegroTrain_util::train_objectives();

												thread maps\MontenegroTrain_car7::e7_main();
												thread maps\MontenegroTrain_car8::e8_main();

												level.inside_train = true;
												thread maps\MontenegroTrain_util::train_shake_inside();
								}
				}	
				else if ( skipto == "car9" )
				{
								skip9 = GetEnt( "skip9", "targetname" );
								if ( IsDefined(skip9) )
								{
												level.player setorigin( skip9.origin );
												level.player setplayerangles( skip9.angles );

												// give bond back weapons
												level.player giveWeapon("p99_wet_s");
												// level.player giveWeapon( "flash_grenade" );
												level.player switchtoWeapon("p99_wet_s");

												// wwilliams
												// objective thread
												level thread maps\MontenegroTrain_util::train_objectives();

												thread maps\MontenegroTrain_car8::e8_main();

												level.inside_train = true;
												thread maps\MontenegroTrain_util::train_shake_inside();
								}
				}
				else // "car1" Start at the beginning
				{
								// setup the civs in car1
								thread maps\MontenegroTrain_car1::e1_main();

								// frame wait
								wait( 0.05 );

								setminimap( "compass_map_montenegrotrain", 200, -5408, -448, -10208 );
								// WW 07-02-08
								// map has changed, new call for switching cars
								setSavedDvar( "sf_compassmaplevel",  "level1" );
								level thread maps\MontenegroTrain_util::compass_map_changer();

								// WW 07-01-08
								// turn on letterbox
								level thread letterbox_on();

								// maps\_utility::holster_weapons();

								level.inside_train = true;
								thread maps\MontenegroTrain_util::train_shake_inside();

								// iprintlnbold( "about to play cutscene" );
								// 05-27-08
								// wwilliams
								// defining vesper
								// remember to clean her up

								level.vesper = getent( "vesper", "targetname" );
								// remove vesper's weapon
								level.vesper animscripts\shared::placeWeaponOn( level.vesper.primaryweapon, "none" );
								// define the card and the pic
								level.bizcard = getent( "smodel_bizcard", "targetname" );
								level.bliss_pic = getent( "smodel_bliss_pic", "targetname" );
								// hide these things
								level.bizcard hide();
								level.bliss_pic hide();

								// take away bond's weapons
								level.player takeallweapons();

								// unholster bond's weapon
								// maps\_utility::unholster_weapons();

								// setup the vision changes for the intro
								level thread train_intro_vision();

								// wait to see if the dvar will work
								// needed to wait three frames for it to work
								wait( 0.15 );

								// disable the phone
								setSavedDvar( "cg_disableBackButton", "1" ); // disable

								// play cutscene
								playcutscene( "MT_TR_Intro", "MT_TR_Intro_done" );
								
								//Start Ambient Music - Added by crussom
								level notify( "playmusicpackage_ambient" );

								// display chyron
								level thread display_chyron();

								// iprintlnbold( "" + level.player gettagorigin( "TAG_WEAPON_RIGHT" ) + "" );

								// 05-27-08
								// wwilliams
								// need to thread off the function that handles the model swaps
								level thread maps\MontenegroTrain_util::intro_card_n_pic();

								level waittill( "MT_TR_Intro_done" );
								// iprintlnbold( "finish cutscene" );

								// freeze controls
								level.player freezecontrols( true );

								// SaveGame( "montenegrotrain" );
								level thread maps\_autosave::autosave_now( "montenegrotrain" );
								
								// run a loop anim thread on vesper
								// thread off a function to make vesper loop a sitting anim
								level thread vesper_sit_loop();

								// notify the level to start the animations for the civs in car 1
								level notify( "start_anim_car1" );

								// enable the phone
								setSavedDvar( "cg_disableBackButton", "0" ); // enable

								// unfreeze controls
								level.player freezecontrols( false );


								// for loop goes through the poles in the level
								for( i=0; i<level.background_poles.size; i++ )
								{
												// show the pole
												level.background_poles[i] show();
								}

								// give bond back weapons
								level.player giveWeapon("p99_wet_s");
								// level.player giveWeapon( "flash_grenade" );
								level.player switchtoWeapon("p99_wet_s");

								// unholster bond's weapon
								// maps\_utility::holster_weapons();

								// thread off the function for bringing the gun up
								// fixes crash when hitting both L1 & R1 while gun is holstered
								level thread maps\MontenegroTrain_util::train_bring_up_gun();

								// WW 07-01-08
								// turn off letterbox
								level letterbox_off( false );

								// unholster bond's weapon
								maps\_utility::holster_weapons();

								// WWilliams 07-15-08
								// Tanner breifs Bond
								level thread tanner_briefing();

								// wwilliams
								// objective thread
								level thread maps\MontenegroTrain_util::train_objectives();




								// change the player's position out of the chair
								// level.player setorigin( ( 24, -9856, 88 ) );

								// commenting out the old igc
								// thread intro_igc();

								// debug text
								// iprintlnbold( "done with cutscene" );

								// wait a frame
								wait( 1.0 );



								// Add first objective
								// objective_add(0, "active", &"MONTENEGROTRAIN_OBJECTIVE_FIND_BLISS", level.bliss_run_spawner.origin);


				}

				if ( IsDefined( script_player_start ))
				{
								level.player setorigin( script_player_start.origin );
								level.player setplayerangles( script_player_start.angles );
				}
}
//////////////////////////////////////////////////////////////////////////
// 08-09-08 WWilliams
// function changes the vision set during the intro cutscene
train_intro_vision()
{
				// endon

				// wait for the first notetrack on the player
				// level.player waittillmatch( "anim_notetrack", "vision_outside" );

				// change to the outside visionset
				// change the vision set
				VisionSetNaked( "MontenegroTrain", 0.05 );

				// iprintlnbold( "outside" );

				// wait for the interior notetrack
				level.player waittillmatch( "anim_notetrack", "vision_inside" );

				// change the vision set
				VisionSetNaked( "MontenegroTrain_in", 0.05 );

				// iprintlnbold( "inside" );

				//// wait for the exterior notetrack
				//level.player waittillmatch( "anim_notetrack", "vision_outside" );

				//// change the vision set
				//VisionSetNaked( "MontenegroTrain", 0.05 );

				//iprintlnbold( "outside" );

				//// wait for the interior notetrack
				//level.player waittillmatch( "anim_notetrack", "vision_inside" );

				//// change the vision set
				//VisionSetNaked( "MontenegroTrain_in", 0.05 );

				//iprintlnbold( "inside" );

				//// wait for the exterior notetrack
				//level.player waittillmatch( "anim_notetrack", "vision_outside" );

				//// change the vision set
				//VisionSetNaked( "MontenegroTrain", 0.05 );

				//iprintlnbold( "outside" );

				//// wait for the interior notetrack
				//level.player waittillmatch( "anim_notetrack", "vision_inside" );

				//// change the vision set
				//VisionSetNaked( "MontenegroTrain_in", 0.05 );

				//iprintlnbold( "inside" );

				// wait for the end of the cutscene
				level waittill( "MT_TR_Intro_done" );

				// once the cutscene is over fire off the normal visionset control
				// controls the vision sets for the level
				level thread maps\MontenegroTrain_util::train_vision_sets();

}
//////////////////////////////////////////////////////////////////////////////////////////
//	Keep track of what car the player is in (or on).
////////////////////////////////////////////////////////////////////////////////////////// 

player_monitor()
{
				// startup the monitor threads
				for ( i=2; i<9; i++)
				{
								// each car has a trig
								trig = GetEnt( "player_at_car_"+i, "targetname" );
								// if there is a trig defined
								if ( IsDefined(trig) )
								{
												// set off this function that waits for the trig to be hit
												trig thread player_pos_monitor( i );
								}
				}
}
// 04-15-08
// wwilliams
// trig reports which car the player is in
// saving the game at certain cars dictated by the stich
player_pos_monitor( car_num )
{
				self waittill( "trigger" );

				level.curr_player_pos = car_num;
				level notify( "in_car_"+(car_num) );

				// iprintlnbold( "car spot notify fire" );

				//	iprintlnbold ( "In Car ", car_num );

				switch ( car_num )
				{
				case 1:
								//	case 4:
				case 6:
				case 8:
								// SaveGame( "montenegrotrain" );
								// level maps\_autosave::autosave_now( "montenegrotrain" );
								break;
				}
}
//////////////////////////////////////////////////////////////////////////////////////////
// Move background brushmodels.
//////////////////////////////////////////////////////////////////////////////////////////
background_scenery_move()
{
				// 04-15-08
				// wwilliams
				// defining the ten pieces of the world that goes by
				level.background_scene[0]		= GetEnt( "background_00",			"targetname" );
				level.background_scene[1]		= GetEnt( "background_01",			"targetname" );
				level.background_scene[2]		= GetEnt( "background_02",			"targetname" );
				level.background_scene[3]		= GetEnt( "background_03",			"targetname" );
				level.background_scene[4]		= GetEnt( "background_04",			"targetname" );
				level.background_scene[5]		= GetEnt( "background_05",			"targetname" );
				level.background_scene[6]		= GetEnt( "background_06",			"targetname" );
				level.background_scene[7]		= GetEnt( "background_07",			"targetname" );
				level.background_scene[8]		= GetEnt( "background_08",			"targetname" );
				level.background_scene[9]		= GetEnt( "background_09",			"targetname" );
				level.background_scene[10]		= GetEnt( "background_10",			"targetname" );

				// bliss hitter
				level.bliss_hitter = getent( "bliss_hitter", "targetname" );
				ent_temp = undefined;

				// thread off the function that controls the poles
				level thread train_background_poles();

				// hide the bliss hitter
				level.bliss_hitter hide();

				//////////////////////////////////
				//Added by Steve G
				Maps\MontenegroTrain_snd::audio_scenery_linkage(level.background_scene);
				//////////////////////////////////	

				// 04-15-08
				// wwilliams
				// define the time for the movement
				// not sure why i is being defined
				i = 0;
				travel_time = 3.0;		// seconds
				// 04-15-08
				// wwilliams
				// background runs the train at about eighty miles an hour

				///////////////////////////////////////////////////////////////////////
				// 07-21-08 WWilliams
				// for loop to setup the hide/show function
				for( i=0; i<level.background_scene.size; i++ )
				{
								// thread off the hide function
								level.background_scene[i] thread train_scenery_hide();

								// turn off shadows for the pieces
								level.background_scene[i] disableshadowon();
				}
				///////////////////////////////////////////////////////////////////////

				// move scenery brushmodels
				while (true)
				{

								//		if ((i >= 0) && (i < 10)) //start all background pieces
								//		{

								// 04-15-08
								// wwilliams
								// just lining these up	
								// move each piece of the world past the train in order
								//iprintlnbold ( "Moving all background pieces 1-7" );
								for ( i = 0; i < 10; i++ )
								{
												// 04-15-08
												// wwilliams
												// moves the sbrush world to each origin for a section
												// movetos automatically give a accel and decel time, should add 0.0 to this?
												level.background_scene[i] moveto( level.background_scene[i+1].origin, travel_time );
								}

								//		}
								// 04-15-08
								// wwilliams
								// if i is ten or greater enter the brackets
								if (i >=10)
								{
												// 04-15-08
												// wwilliams
												// when the sbrush sections hit this point the are underground and move forward.
												// movetos automatically give a accel and decel time, should add 0.0 to this?
												level.background_scene[i] moveto( level.background_scene[i-i].origin, travel_time );
												i = 0;

								}

								//		iprintlnbold ( "starting next move" );
								// 04-15-08
								// wait for the piece to finish moving
								level.background_scene[i] waittill( "movedone" );

				}
}
///////////////////////////////////////////////////////////////////////////
// 07-21-08 WWilliams
// PS3 doesn't like the moving pieces, need to hide them while out of site
// runs on the sbrush/self
train_scenery_hide()
{
				// endon
				// level.player endon( "death" );
				self endon( "stop_delete" );

				// while loop keeps checking the situation
				while( 1 )
				{
								// while loop checks to see if self's z origin is less than
								while( self.origin[2] < -2000 )
								{
												// hide the sbrush
												self hide();

												// wait a half second
												wait( 0.5 );
								}

								// while loop checks that the geo is high enough to be displayed
								while( self.origin[2] > -2000 )
								{
												// show the sbrush
												self show();

												// wait half a second
												wait( 0.5 );
								}
				}
}
//////////////////////////////////////////////////////////////////////////////////////////
//  train to pass by randomly or while on roof.
//////////////////////////////////////////////////////////////////////////////////////////
setup_passing_train()
{
				level.passing_train = [];
				passing = GetEnt( "passing_engine", "targetname" );

				//// trigger to kill player for jumping into passing train.
				passing_dmg = GetEnt( "passing_train_dmg", "targetname" );
				passing_dmg enablelinkto();
				passing_dmg linkto(passing);	

				//////////////////////////////////
				//Added by Steve G
				//Maps\MontenegroTrain_snd::oncoming_train_thread();
				//////////////////////////////////	

				i = 0;
				// 04-15-08
				// wwilliams
				// if passing is not defined the while loop will end
				while ( IsDefined( passing ) )
				{
								// 04-15-08
								// wwilliams
								// make passing part of the level array
								level.passing_train[i] = passing;

								//hide until time to pass by.
								passing hide();

								// if there is a target,
								// give the target the passing def
								// 04-15-08
								// wwilliams
								if ( IsDefined( passing.target ) )
								{
												// 04-15-08
												// wwilliams
												// define passing as the target of current passing
												passing = GetEnt( passing.target, "targetname" );
								}
								else
								{
												// 04-15-08
												// wwilliams
												// if there is no target, leave the while loop
												break;
								}
								// 04-15-08
								// wwilliams
								// increment the i in order to place train parts in the correct
								// array slots
								i++;
				}

				//// Linking pieces so all move together
				for ( i = 1; i < level.passing_train.size; i++ )
				{
								level.passing_train[i] linkto(level.passing_train[i-1]);
				}	
				thread train_passes_by();
}	

train_passes_by()
{

				// objects to define for the function
				start_trig = GetEnt("roof_start", "targetname");
				if ( IsDefined( start_trig ) )
				{
								start_trig waittill("trigger");

								maps\_utility::unholster_weapons();

								// wait( 0.05 );

								// level.player switchtoWeapon("p99_wet_s");

								//iPrintLnBold( "Player On Car2 Roof!" );
								level.train_passing_by = true;
								level.inside_train = false;

								// 06-05-08
								// wwilliams
								// wait a little longer before saving, that way the player saves off the ladder brush
								wait( 1.5 );

								// SaveGame( "montenegrotrain" );
								level thread maps\_autosave::autosave_now( "montenegrotrain" );
				}
				else
				{
								/*iPrintLnBold( "Missing Rooftop start trigger!" );*/
								return;
				}
				// 07-18-08 WWilliams
				// need to comment out Don's old stop
				// thread stop_train_passing();

				//End Ambient Music - Added by crussom
				level notify( "endmusicpackage" );

				// start the random passing train movement
				level thread random_passing_train();

				// special function for the ledge pass
				level thread train_ledge_passing_train();
}
///////////////////////////////////////////////////////////////////////////
stop_train_passing()
{
				end_trig = GetEnt("roof_end", "targetname");
				if ( IsDefined( end_trig ) )
				{
								end_trig waittill("trigger");

								//// not stopping passing by any longer, adding save.
								//level.train_passing_by = false;
								//level.inside_train = true;
				}
				else
				{
								/*iPrintLnBold( "Missing Rooftop end trigger!" );*/
								return;
				}	
}	
///////////////////////////////////////////////////////////////////////////
// 07-18-08 WWilliams
// Random passing train
random_passing_train()
{
				// endon
				level endon( "stop_passing_train" );

				// objects to define for this function
				// int
				x = 0;

				// while loop
				while( 1 )
				{
								// fire off the movement function
								level train_pass();

								// random x
								x = randomfloatrange(30.0, 120.0);

								// wait
								wait(x);
				}
}
///////////////////////////////////////////////////////////////////////////
// 07-18-08 WWilliams
// function causes the opposite direction train to go by
train_pass()
{
				// objects to defined for the function
				// script orgs
				passing_train_start = GetEnt( "passing_train_start", "targetname" );
				passing_train_end = GetEnt( "passing_train_end", "targetname" );

				// double check defines
				//assertex( isdefined( passing_train_start ), "passing_train_start not defined" );
				//assertex( isdefined( passing_train_end ), "passing_train_end not defined" );

				// set the flag that the train is going to pass
				level flag_set( "passing_train" );

				//iPrintLnBold( "Train is passing by!!!" );
				for ( i = 0; i < level.passing_train.size; i++ )
				{
								level.passing_train[i] show();
				}	

				// move the train down to the end
				level.passing_train[0] moveto( passing_train_end.origin, 12.0 );

				// wait for the train to finish
				level.passing_train[0] waittill( "movedone" );
				//iPrintLnBold( "Train reached end" );

				//reset train for next pass.
				for ( i = 0; i < level.passing_train.size; i++ )
				{
								level.passing_train[i] hide();
				}	

				///// need to drop train out of site for sound.
				//passing_train_return1
				//passing_train_return2

				// move it back to the start point
				level.passing_train[0] moveto( passing_train_start.origin, 0.5 );

				// wait for the move to finish
				level.passing_train[0] waittill( "movedone" );

				// clear the flag
				level flag_clear( "passing_train" );
}
///////////////////////////////////////////////////////////////////////////
// 07-21-08 WWilliams
// function stop the random train to make sure one is sent by
// during the ledge crawl
// runs on level
train_ledge_passing_train()
{
				// endon
				// single shot function 

				// objects to define for the function
				// trig
				trig_stop_random_pass = getent( "show_train_special", "targetname" );
				trig_ledge_passing_train = getent( "trig_ledge_pass", "targetname" );

				// wait for the stop trig
				trig_stop_random_pass waittill( "trigger" );

				// play line from tanner
				level.player maps\_utility::play_dialogue( "TANN_TraiG_804A", true );


				// wait for the flag to be set to off
				while( flag( "passing_train" ) == 1 )
				{
								wait( 0.05 );
				}

				// notify the random movement to end
				level notify( "stop_passing_train" );

				// wait for the next trigger
				trig_ledge_passing_train waittill( "trigger" );

				// fire off the single shot pass
				level train_pass();

				// wait for the flag to be set to off
				while( flag( "passing_train" ) == 1 )
				{
								wait( 0.05 );
				}

				// wait, makes sure no comet sound of the passing train going back up
				wait( 30.0 );

				// turn back on random movement
				level thread random_passing_train();

}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
// adding flags in train
//////////////////////////////////////////////////////////////////////////////////////////
train_flag_init()
{

				// global
				level flag_init( "outside_train" );
				level flag_init( "on_freight_train" );
				level flag_init( "passing_train" ); // 07-18-08 WWilliams // flag to know when the passing train is active
				level flag_init( "freight_train_active" ); 	// 05-10-08 WWilliams // new flags to mimic the level cars don set up
				level flag_init( "freight_train_moving" ); 	// 05-10-08 WWilliams // new flags to mimic the level cars don set up
				// level.freight_train_active = true;
				// level.on_freight_train = false;
				level flag_init( "freight_door_busy" ); // 05-20-08 WWilliams // new flag for the door busy level var
				level flag_init( "freight_to_node2" ); // need new flags for moving the freight into positions
				level flag_init( "freight_to_node3" ); // need new flags for moving the freight into positions
				level flag_init( "train_obj_1" ); 				// objectives (six of 'em)
				level flag_init( "train_obj_2" ); 				// objectives (six of 'em)
				level flag_init( "train_obj_3" ); 				// objectives (six of 'em)
				level flag_init( "train_obj_4" ); 				// objectives (six of 'em)
				level flag_init( "train_obj_5" );				// objectives (six of 'em)
				level flag_init( "train_obj_6" ); 				// objectives (six of 'em)

				//////////////////////////////////////////////////////////////////////////
				level flag_clear( "outside_train" );
				level flag_clear( "on_freight_train" );
				level flag_clear( "passing_train" ); // 07-18-08 WWilliams // flag to know when the passing train is active
				level flag_clear( "freight_train_active" ); // 05-10-08 WWilliams // clearing those mimic flags
				level flag_clear( "freight_train_moving" ); // 05-10-08 WWilliams // clearing those mimic flags
				level flag_clear( "freight_door_busy" ); // 05-20-08 WWilliams // new flag for the door busy level var
				level flag_clear( "freight_to_node2" ); // 05-20-08 WWilliams // need new flags for moving the freight into positions
				level flag_clear( "freight_to_node3" ); // 05-20-08 WWilliams // need new flags for moving the freight into positions
				level flag_clear( "train_obj_1" ); 				// objectives (six of 'em)
				level flag_clear( "train_obj_2" ); // objectives (six of 'em)
				level flag_clear( "train_obj_3" ); // objectives (six of 'em)
				level flag_clear( "train_obj_4" ); // objectives (six of 'em)
				level flag_clear( "train_obj_5" ); // objectives (six of 'em)
				level flag_clear( "train_obj_6" ); // objectives (six of 'em)
				//////////////////////////////////////////////////////////////////////////
				// end global
				//////////////////////////////////////////////////////////////////////////
				// car 1
				level flag_init( "clean_car_1" );
				//////////////////////////////////////////////////////////////////////////
				level flag_clear( "clean_car_1" );
				// end car 1
				//////////////////////////////////////////////////////////////////////////
				// car 2
				//////////////////////////////////////////////////////////////////////////
				// end car 2
				//////////////////////////////////////////////////////////////////////////
				// car 3
				//////////////////////////////////////////////////////////////////////////
				// end car 3
				//////////////////////////////////////////////////////////////////////////
				// car 4
				level flag_init( "car4_populate" );
				level flag_init( "car4_boxcar_surprise" );
				level flag_init( "car4_container_shoot" );
				level flag_init( "car4_top_spawner" );
				level flag_init( "car4_bottom_spawner" );
				level flag_init( "start_boxcar_camera" ); 
				level flag_init( "player_locked_in_trap" );
				//////////////////////////////////////////////////////////////////////////
				level flag_clear( "car4_populate" );
				level flag_clear( "car4_boxcar_surprise" );
				level flag_clear( "car4_container_shoot" );
				level flag_clear( "car4_top_spawner" );
				level flag_clear( "car4_bottom_spawner" );
				level flag_clear( "start_boxcar_camera" );
				level flag_clear( "player_locked_in_trap" );
				// end car 4
				//////////////////////////////////////////////////////////////////////////
				// car 5
				//////////////////////////////////////////////////////////////////////////
				// end car 5
				//////////////////////////////////////////////////////////////////////////
				// car 6
				// end car 6
				//////////////////////////////////////////////////////////////////////////
				// car 7
				//////////////////////////////////////////////////////////////////////////
				// end car 7
				//////////////////////////////////////////////////////////////////////////
				// car 8
				level flag_init( "bliss_run_started" );
				///////////////////////////////////////////////////////////////////////
				level flag_clear( "bliss_run_started" );
				//////////////////////////////////////////////////////////////////////////
				// end car 8
				//////////////////////////////////////////////////////////////////////////

}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-17-08
// wwilliams
//////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////
// 05-13-08
// wwilliams
// rain function to have the rain continue on
/////////////////////////////////////////////////////////////////////////////////////////
train_rain()
{
				// endon
				// level.player endon( "death" );
				// place an extra call here later for level cmp

				// wait for now
				wait( 0.1 );

				if( GetDVar( "skipto" ) == "" )
				{
								level train_intro_rain();
				}


				//rain
				forwardrain = level.player.origin;

				// thread off the check to see if the player is 
				// level thread train_rain_close();

				//Steve G
				// level thread Maps\montenegrotrain_snd::start_rain_sounds();

				// while loop always
				while( 1 )
				{
								while( level.standard_background == true )
								{
												wait( 0.5 );
												forwardrain = level.player.origin;	                        
												playfx( level._effect["rain_bg"], forwardrain, ( 0, 1, .25 ) );
												playfx( level._effect["rain_far"], forwardrain, ( 0, 1, .25 ) );

												// close rain, if inside don't play this
												if( flag( "outside_train" ) )
												{
																playfx( level._effect["rain_9"], forwardrain, ( 0, 1, .25 ) );
																playfx( level._effect["rain_mid"], forwardrain, ( 0, 1, .25 ) );
												}
												
								}

								// wait to avoid infinite script loop
								wait( 0.05 );
				}

}
///////////////////////////////////////////////////////////////////////////
// 08-13-08 WWilliams
// special rain for the beginning intro
train_intro_rain()
{			
				// wait a sec
				// wait( 0.05 );
				level thread train_distant_rain_intro();

				//// wait for the interior notetrack
				level.player waittillmatch( "anim_notetrack", "vision_inside" );

				// iprintlnbold( "vision_inside" );

				level thread train_intro_rain_fx();

				// 
				// window rain
				// level thread train_rain_intro_window();

				// wait for the intro to finish
				level waittill( "MT_TR_Intro_done" );

}
///////////////////////////////////////////////////////////////////////////
// 08-13-08 WWilliams
// play the rain on a level var
train_intro_rain_fx()
{
				// endon
				level endon( "MT_TR_Intro_done" );

				// make sure the level var is defined
				// assertex( isdefined( level.rain_org ), "level.rain_org not defined" );

				// forwardrain = level.player.origin;	

				// while loop
				while( 1 )
				{ 
								playfxontag( level._effect["rain_9_cutscene"], level.player, "TAG_WEAPON_LEFT" );
								wait( 0.2 );
								playfxontag( level._effect["rain_9_cutscene"], level.player, "TAG_WEAPON_LEFT" );
								wait( 0.2 );
								playfxontag( level._effect["rain_9_cutscene"], level.player, "TAG_WEAPON_LEFT" );
								wait( 0.2 );
								playfxontag( level._effect["rain_9_cutscene"], level.player, "TAG_WEAPON_LEFT" );
								//wait( 0.2 );
								//playfxontag( level._effect["rain_9_cutscene"], level.player, "TAG_WEAPON_LEFT" );
								
								// wait
								wait( 0.4 );
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-13-08 WWilliams
// background rain for intro
train_distant_rain_intro()
{
				// endon
				level endon( "MT_TR_Intro_done" );

				// forwardrain = level.player.origin;	

				// while loop
				while( 1 )
				{ 
								 playfxontag( level._effect["rain_bg"], level.player, "TAG_WEAPON_LEFT" );
								 playfxontag( level._effect["rain_far"], level.player, "TAG_WEAPON_LEFT" );
								//playfx( level._effect["rain_bg"], forwardrain, ( 0, 1, .25 ) );
								//playfx( level._effect["rain_far"], forwardrain, ( 0, 1, .25 ) );

								// wait
								wait( 0.5 );
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-12-08 WWilliams
// plays the rain fx right next to the window where bond and vesper talk
train_rain_intro_window()
{
				// endon
				level endon( "MT_TR_Intro_done" );

				// objects to define for this function
				window_1_source = getent( "intro_rain_window_1", "targetname" );
				window_2_source = getent( "intro_rain_window_2", "targetname" );

				rainsource1 = window_1_source.origin;
				rainsource2 = window_2_source.origin;

				// frame wait
				wait( 0.05 );

				// while loop
				while( 1 )
				{
								// play the close fx
								playfx( level._effect["rain_9_cutscene"], rainsource1, ( 0, 1, .25 ) );
								playfx( level._effect["rain_9_cutscene"], rainsource2, ( 0, 1, .25 ) );

								// wait
								wait( 0.5 );
				}

}
///////////////////////////////////////////////////////////////////////////
// 08-07-08 WWilliams
// check to see if the player is on the freight and inside to turn off certain
// rain fx
train_rain_close()
{
				// objects to be defined for this function
				where_trigs = getentarray( "trig_player_inside", "targetname" );
				// freight inside trigs
				trigs_freight_inside = [];

				// go through the array and pick out the ones needed for checking
				for( i=0; i<where_trigs.size; i++ )
				{
								// check each of these trigs for a script_string
								if( isdefined( where_trigs[i].script_string ) )
								{
												// add this trigger to the array
												where_trigs[i] = add_to_array( trigs_freight_inside, where_trigs[i] );
								}
				}

				//rain
				forwardrain = level.player.origin;

				// while loop always
				while( 1 )
				{
								for( i=0; i<trigs_freight_inside.size; i++ )
								{
												if( level.player istouching( trigs_freight_inside[i] ) )
												{
																while( level.player istouching( trigs_freight_inside[i] ) )
																{
																				// wait
																				wait( 0.05 );
																}
												}

												// wait( 0.5 );
												forwardrain = level.player.origin;	                        

								}

								// wait to avoid infinite script loop
								wait( 0.05 );
				}


}
///////////////////////////////////////////////////////////////////////////
// 05-27-08
// wwilliams
// loop anim on vesper until time to clean her
vesper_sit_loop()
{
				// endon
				// level.player endon( "death" );
				
				// define objects for the function
				// trig
				// 07-16-08 WWilliams
				// they say this in the cuscene now
				// trig_say_goodnight = GetEnt( "car1_passenger1_trig", "targetname" );

				// vesper should have already been defined as a level car
				level.vesper cmdplayanim( "Gen_Civs_SitConversation_Listen_Female", true );

				// wait for the player to hit the trigger
				// 07-16-08 WWilliams
				// they say this in the cuscene now
				// trig_say_goodnight waittill( "trigger" );

				// vesper says goodnight
				// 07-16-08 WWilliams
				// they say this in the cuscene now
				// level.vesper play_dialogue( "VESP_TraiG_011A" );

				// wait for the player to switch trains
				level flag_wait( "on_freight_train" );

				// remove vesper
				level.vesper delete();

}
///////////////////////////////////////////////////////////////////////////
// 07-15-08 WWilliams
// Tanner breifing Bond after Vesper Cutscene
// runs on level
tanner_briefing()
{
				// endon
				// level.player endon( "death" );

				// Tanner now talks to Bond
				// line 1
				level.player play_dialogue( "TANN_TraiG_009A", true );

				// line 2
				level.player play_dialogue( "TANN_TraiG_010A", true );
}

display_chyron()
{
	maps\_introscreen::introscreen_chyron(&"MONTENEGROTRAIN_INTRO_01", &"MONTENEGROTRAIN_INTRO_02", &"MONTENEGROTRAIN_INTRO_03");
}

// ---------------------//
// 07-24-08
// manthony
// Add the Wet materials to the game
add_wet_materials()
{
	wait( 0.01 );
	
				// Magnum
    materialaddwet( "mtl_w_sw500_wet" );
    materialaddwet( "mtl_w_sw500_plastic_wet" );
    materialaddwet( "mtl_w_sw500_ammo_wet" );

				// Weapon PA99
				materialaddwet( "mtl_w_p99_wet" );
				materialaddwet( "mtl_w_p99_silenced_wet" );


 			// SAF45F
    materialaddwet( "mtl_w_ump_wet" );

 
				//Hutchinson A3
    materialaddwet( "mtl_w_1300_receiver_rail_wet" );
    materialaddwet( "mtl_w_1300_attach_wet" );
    materialaddwet( "mtl_w_1300_attach_rubber_wet" );
    materialaddwet( "mtl_w_1300_shell_wet" );


				//GF18 (Bug 16044)
    materialaddwet( "mtl_w_glock_wet" );
    materialaddwet( "mtl_w_glock_plastic_wet" );
    materialaddwet( "mtl_w_glock_18_wet" );
    
    // WET HANDS
    materialaddwethands( "mtl_bond_hand_left_trainrain" );
    
    // WET HEAD
    materialaddwethead( "mtl_bond_head_trainrain" );
    materialaddwethead( "mtl_hairshell_bond_trainrain" ); 
 
    // WET SUIT
    materialaddwetsuit( "mtl_suit_bond_train" );
    materialaddwetsuit( "mtl_shirt_bond_train" );
   
    // Set Wet Materials to Dry, we wnat Bond to be dry at the start of the level
 	wait(1);
	materialsetwet( 0 );
}
// ---------------------//
///////////////////////////////////////////////////////////////////////////
// 08-12-08 WWilliams
// conveyor belt for the ground, hopefully moves dead bodies
// runs on level
train_conveyor_ground()
{
				// endon

				// objects to define for this function
				sbrush_ground = getent( "train_conveyor_ground", "targetname" );

				// wait
				wait ( 0.05 );

				//assertex( isdefined( sbrush_ground ), "sbrush_ground not defined" );

				// set the right angle for the conveyor
				vec_direction = anglestoforward( ( 0, 270, 0 ) ) * 1200;

				// start the conveyor with the proper direction
				sbrush_ground setconveyor( vec_direction );
}
///////////////////////////////////////////////////////////////////////////
// 08-15-08 WWilliams
// background poles function, hides them for the intro
train_background_poles()
{
				// endon

				// objects to defined for this function				
				// define a level array for the poles on the terrain
				level.background_poles = getentarray( "background_poles", "targetname" );
				ent_temp = undefined;
				// for loop goes through the poles in the level
				for( i=0; i<level.background_poles.size; i++ )
				{
								// make sure the pole has a target
								if( isdefined( level.background_poles[i].target ) )
								{
												// define the temp link ent
												ent_temp = getent( level.background_poles[i].target, "targetname" );

												// link the pole
												level.background_poles[i] linkto( ent_temp );

												// undefined ent_temp
												ent_temp = undefined;
								}
								else
								{
												/*iprintlnbold( "pole missing a target!" );*/
								}
				}

				// wait for the first interior notetrack
				level.player waittillmatch( "anim_notetrack", "vision_inside" );

				// for loop hides all teh poles
				for( i=0; i<level.background_poles.size; i++ )
				{
								// hide the pole
								level.background_poles[i] hide();
				}

				// wait for the end of the cutscene
				level waittill( "MT_TR_Intro_done" );

				// for loop shows all teh poles
				for( i=0; i<level.background_poles.size; i++ )
				{
								// hide the pole
								level.background_poles[i] show();
				}

				// wait for the tunnel to start
				while( level.standard_background == true )
				{
								// wait
								wait( 0.1 );
				}

				// now that the tunnel is running
				// for loop hides all teh poles
				for( i=0; i<level.background_poles.size; i++ )
				{
								// hide the pole
								level.background_poles[i] hide();
				}

				level waittill( "boss_fight_start" );

				// for loop shows all teh poles
				for( i=0; i<level.background_poles.size; i++ )
				{
								// show the pole
								level.background_poles[i] show();
				}
}