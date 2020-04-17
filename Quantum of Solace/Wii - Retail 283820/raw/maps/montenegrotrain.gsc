




#include maps\_utility;

#include animscripts\Utility;
#include animscripts\shared;
#include maps\_anim;
#using_animtree("generic_human");









main()
{
				
				setDVar( "r_bx_fog_enable", 1 );
				setDVar( "r_bx_fog_start_z", 0.95 );
				setDVar( "r_bx_fog_end_z", 1 );
				setDVar( "r_bx_fog_color", "0.0 0.0 0.0 1.0" );
				
				thread maps\MontenegroTrain_fx::main();
				maps\_load::main();

				
				precacheShader( "compass_map_montenegrotrain_01" );
				precacheShader( "compass_map_montenegrotrain_02" );
				precacheShader( "compass_map_montenegrotrain_03" );
				precacheShader( "compass_map_montenegrotrain_04" );
				precacheShader( "compass_map_montenegrotrain_05" );
				precacheShader( "compass_map_montenegrotrain_06" );
				precacheShader( "compass_map_montenegrotrain_07" );
				precacheShader( "compass_map_montenegrotrain_08" );
				precacheShader( "compass_map_montenegrotrain_09" );

				precacheShader( "videocamera_hud_train1" );

				precachemodel("p_lit_ceiling_light_on");
				precachemodel("p_lit_ceiling_light_off");

				
				precacheModel( "p_igc_vesper_business_card" );
				precacheModel( "p_igc_bliss_headshot" );
				precacheModel( "w_t_baton");

				
				precacheModel( "p_igc_duffle_bag" );

				PreCacheItem("flash_grenade");
				PreCacheItem("w_t_grenade_flash");
				precacheShellshock( "default" );
				precacheshellshock ("flashbang");

				
				
				
				
				PrecacheCutScene( "Train_Bond_Jump" );
				
				
				
				PrecacheCutScene( "MT_TR_Intro" );
				
				
				
				
				
				
				
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
				
				
				

				
				thread maps\montenegrotrain_snd::main();
				thread maps\montenegrotrain_mus::main();

				
				
				

				
				
				
				SetDVar( "sm_SunSampleSizeNear", "2.0" );

				
				
				
				
				playfx ( level._effect["lightning"], level.player.origin );

				
				
				
				
				

				
				
				
				
				

				
				level.bliss_run_spawner = GetEnt( "bliss_run", "targetname" );
				level.bliss_spawner = GetEnt( "bliss", "targetname" );

				level.curr_player_pos = 0;	
				level.laptops_found = 0;
				level.train_passing_by = false;


				
				
				
				level thread add_wet_materials();

				
				
				
				
				
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
				
				
				

				
				level.standard_background = true;
				thread background_scenery_move();
				thread maps\MontenegroTrain_car8::setup_tunnel_segments();

				thread setup_passing_train();

				
				level.freight_train_active = false;
				
				
				
				

				

				
				
				thread maps\MontenegroTrain_util::setup_freight_train();
				level.door_busy = false;
				level.train_moving = false;
				level.clock_running = false;

				
				
				
				
				
				level train_flag_init();
				
				
				
				
				
				
				

				
				

				
				
				
				
				
				
				
				level thread maps\MontenegroTrain_util::outside_train_init();
				

				
				if( Getdvar( "artist" ) == "1" )
				{
								return;   
				}

				
				
				
				
				
				
				
				
				
				
				
				
				
				level thread maps\MontenegroTrain_util::train_elec_pylon_init();
				


				
				thread player_monitor();

				
				thread maps\MontenegroTrain_util::roof_hatches_setup();


				thread maps\MontenegroTrain_util::control_hud();
				thread maps\MontenegroTrain_util::setup_automatic_doors();
				thread maps\MontenegroTrain_util::setup_automatic_doors_dbl();
				thread maps\MontenegroTrain_util::setup_auto_service_doors();

				thread maps\MontenegroTrain_util::setup_environmental_trigs();

				thread MissingTrainUncouple();


				
				
				
				
				
				
				
				

				
				checkpoints();

}


MissingTrainUncouple()
{
	firstUncoupleStartTrig = getEnt( "trig_start_first_uncouple", "targetname" );
	firstUncoupleSuccessTrid = getEnt("trig_first_uncouple_success","targetname");
	firstUncoupleSuccessTrid endon("trigger");
	
	firstUncoupleStartTrig waittill("trigger");
	
	
	wait(10.0);
	
	MissionFailedWrapper();
	
}




























































				

				

				



























finale_igc()
{
				level.end_trig = GetEnt( "end_level", "targetname" );
				if ( IsDefined( level.end_trig ) )
				{
								level.end_trig waittill( "trigger" );
								level notify( "boss_fight_start" );
								level.end_trig delete();

								
								
								
								VisionSetNaked( "MontenegroTrain_Boss", 0.5 );

								
								level thread bliss_fight_pole();

								
								

								
								level.player freezeControls(true);
								maps\_utility::holster_weapons();
								wait(0.05);

								
								level.bliss_run thread stop_magic_bullet_shield();
								
								level.bliss_run SetPainEnable(true);
								level.bliss_run delete();

								level.bliss = level.bliss_spawner Stalingradspawn();
								level.bliss.health = 1000;
								level.bliss animscripts\shared::placeWeaponOn( level.bliss.weapon, "none" );

								level.bliss thread maps\_bossfight::boss_transition();
								level.bliss attach( "w_t_baton", "TAG_WEAPON_RIGHT" );

								
								wait(0.05);
								
								
								level.player freezeControls(false);
								start_interaction( level.player, level.bliss, "BossFight_Bliss");
								level.player waittillmatch("anim_notetrack", "fade_out");
								if (level.boss_laststate == 1)
								{
									level thread end_to_black();
								}





				}
				else
				{
								iPrintLnBold( "No end trigger found" );
								return;
				}	
}
end_to_black()
{
				
				level notify( "endmusicpackage" );

				level.player freezeControls(true);
				player_final = GetEnt( "player_final", "targetname" );
				level.player setorigin( player_final.origin + ( 0, 0, 5 ) );
				level.player setplayerangles( player_final.angles );

				
				
				level notify( "bliss_defeated" );

				
				
				level maps\_endmission::nextmission();
}




bliss_fight_pole()
{
				

				
				

				
				level.bliss_hitter moveto( level.bliss_hitter.origin + ( 0, 700, 0 ), 0.05, 0.0, 0.0 );

				
				level.player waittillmatch( "anim_notetrack", "see_object" );

				
				level.bliss_hitter show();

				
				level.bliss_hitter moveto( level.bliss_hitter.origin + ( 0, -3000, 0 ), 2.8, 0.0, 0.0 );

				
				

				
				

				
				level.player waittill( "interaction_pass" );

				
				wait( 0.05 );

				
				if( level.boss_laststate == 1 )
				{
								
								
								level.bliss_hitter moveto( ( level.bliss_hitter.origin[0], 7863, level.bliss_hitter.origin[2] ), 0.2, 0.0, 0.0 );
								
				}
				else
				{
								
								level.bliss_hitter hide();
				}
}



checkpoints()
{
				
				skipto = GetDVar( "skipto" );
				script_player_start = undefined;

				if ( skipto == "car3" )
				{
								skip3 = GetEnt( "skip3", "targetname" );
								if ( IsDefined(skip3) )
								{
												level.player setorigin( skip3.origin );
												level.player setplayerangles( skip3.angles );

												
												
												level thread maps\MontenegroTrain_util::train_objectives();

												thread maps\MontenegroTrain_car3::e3_main();
												
												level.player freezecontrols (false);

												level.inside_train = false;
			
			
								}
				}
				else if ( skipto == "car5" )
				{
								skip5 = GetEnt( "skip5", "targetname" );
								if ( IsDefined(skip5) )
								{
												level.player setorigin( skip5.origin );
												level.player setplayerangles( skip5.angles );

												
												
												level thread maps\MontenegroTrain_util::train_objectives();

												thread maps\MontenegroTrain_car5::e5_main();
												thread maps\MontenegroTrain_car6::e6_main();
												
												level.player freezecontrols (false);

												level.inside_train = false;
			
			
								}
				}
				else if ( skipto == "car8" )
				{
								skip8 = GetEnt( "skip8", "targetname" );
								if ( IsDefined(skip8) )
								{
												
												
												
												

												level.player setorigin( skip8.origin );
												level.player setplayerangles( skip8.angles );

												
												
												level thread maps\MontenegroTrain_util::train_objectives();

												thread maps\MontenegroTrain_car7::e7_main();
												thread maps\MontenegroTrain_car8::e8_main();
												
												level.player freezecontrols (false);

												level.inside_train = true;
			
			
								}
				}	
				else if ( skipto == "car9" )
				{
								skip9 = GetEnt( "skip9", "targetname" );
								if ( IsDefined(skip9) )
								{
												level.player setorigin( skip9.origin );
												level.player setplayerangles( skip9.angles );

												
												
												level thread maps\MontenegroTrain_util::train_objectives();

												thread maps\MontenegroTrain_car8::e8_main();
												
												level.player freezecontrols (false);

												level.inside_train = true;
			
			
								}
				}
				else 
				{
								
								thread maps\MontenegroTrain_car1::e1_main();

								
								wait( 0.05 );

								setminimap( "compass_map_montenegrotrain", 200, -5408, -448, -10208 );
								
								
								setSavedDvar( "sf_compassmaplevel",  "level1" );
								level thread maps\MontenegroTrain_util::compass_map_changer();

								
								
								level thread letterbox_on();

								

								level.inside_train = true;
		
 		

								
								
								
								
								

								level.vesper = getent( "vesper", "targetname" );
								
								level.vesper animscripts\shared::placeWeaponOn( level.vesper.primaryweapon, "none" );
								
								
								level.bizcard = getent( "smodel_bizcard", "targetname" );
								level.bliss_pic = getent( "smodel_bliss_pic", "targetname" );
								
								level.bizcard hide();
								level.bliss_pic hide();

								
								level.player takeallweapons();

								
								

								
								
								wait( 0.15 );

								
								setSavedDvar( "cg_disableBackButton", "1" ); 

								
		                        playcutscene( "MT_TR_Intro", "MT_TR_Intro_done" );

								
								level notify( "playmusicpackage_ambient" );

								
								level thread display_chyron();

								

								
								
								
								level thread maps\MontenegroTrain_util::intro_card_n_pic();

								level waittill( "MT_TR_Intro_done" );
								
								level.player setorigin( ( 24, -9856, 88 ) );
								
								
								level.player freezecontrols(false);
				
								

								
								level maps\_autosave::autosave_now( "montenegrotrain" );
								
								
								
								level thread vesper_sit_loop();


								
								level notify( "start_anim_car1" );

								
								setSavedDvar( "cg_disableBackButton", "0" ); 

								
								for( i=0; i<level.background_poles.size; i++ )
								{
												
												level.background_poles[i] show();
								}

		                                                

								
								

								
								
								level thread maps\MontenegroTrain_util::train_bring_up_gun();

								
								
								level letterbox_off( false );

								
								maps\_utility::holster_weapons();

								
								
								level thread tanner_briefing();

								
								
								level thread maps\MontenegroTrain_util::train_objectives();

								
								

								
								

								
								

								
								wait( 1.0 );



								
								
				}

				if ( IsDefined( script_player_start ))
				{
								level.player setorigin( script_player_start.origin );
								level.player setplayerangles( script_player_start.angles );
				}
}





player_monitor()
{
				
				for ( i=2; i<9; i++)
				{
								
								trig = GetEnt( "player_at_car_"+i, "targetname" );
								
								if ( IsDefined(trig) )
								{
												
												trig thread player_pos_monitor( i );
								}
				}
}




player_pos_monitor( car_num )
{
				self waittill( "trigger" );

				level.curr_player_pos = car_num;
				level notify( "in_car_"+(car_num) );

				

				

				switch ( car_num )
				{
				case 1:
								
				case 6:
				case 8:
								
								level maps\_autosave::autosave_now( "montenegrotrain" );
								break;
				}
}



background_scenery_move()
{
				
				
				
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

				
				level.bliss_hitter = getent( "bliss_hitter", "targetname" );
				ent_temp = undefined;

				
				level thread train_background_poles();

				
				level.bliss_hitter hide();


				
				
				Maps\MontenegroTrain_snd::audio_scenery_linkage(level.background_scene);
				

				
				
				
				
				i = 0;
				travel_time = 3.0;		
				
				
				

				
				
				
				for( i=0; i<level.background_scene.size; i++ )
				{
								
								level.background_scene[i] thread train_scenery_hide();
				}
				

				
				while (true)
				{

								
								

								
								
								
								
								
								for ( i = 0; i < 10; i++ )
								{
												
												
												
												
												level.background_scene[i] moveto( level.background_scene[i+1].origin, travel_time );
								}

								
								
								
								
								if (i >=10)
								{
												
												
												
												
												level.background_scene[i] moveto( level.background_scene[i-i].origin, travel_time );
												i = 0;

								}

								
								
								
								level.background_scene[i] waittill( "movedone" );

				}
}




train_scenery_hide()
{
				
				
				self endon( "stop_delete" );

				
				while( 1 )
				{
								
								while( self.origin[2] < -2000 )
								{
												
												self hide();

												
												wait( 0.5 );
								}

								
								while( self.origin[2] > -2000 )
								{
												
												self show();

												
												wait( 0.5 );
								}
				}
}



setup_passing_train()
{
				level.passing_train = [];
				passing = GetEnt( "passing_engine", "targetname" );

				
				passing_dmg = GetEnt( "passing_train_dmg", "targetname" );
				passing_dmg enablelinkto();
				passing_dmg linkto(passing);	

				
				
				
				

				i = 0;
				
				
				
				while ( IsDefined( passing ) )
				{
								
								
								
								level.passing_train[i] = passing;

								
								passing hide();

								
								
								
								
								if ( IsDefined( passing.target ) )
								{
												
												
												
												passing = GetEnt( passing.target, "targetname" );
								}
								else
								{
												
												
												
												break;
								}
								
								
								
								
								i++;
				}

				
				for ( i = 1; i < level.passing_train.size; i++ )
				{
								level.passing_train[i] linkto(level.passing_train[i-1]);
				}	
				thread train_passes_by();
}	

train_passes_by()
{

				
				start_trig = GetEnt("roof_start", "targetname");
				if ( IsDefined( start_trig ) )
				{
								start_trig waittill("trigger");

								maps\_utility::unholster_weapons();

								

								

								
								level.train_passing_by = true;
								level.inside_train = false;

								
								
								
								wait( 1.5 );

								
								level maps\_autosave::autosave_now( "montenegrotrain" );
				}
				else
				{
								iPrintLnBold( "Missing Rooftop start trigger!" );
								return;
				}
				
				
				

				
				level notify( "endmusicpackage" );

				
				level thread random_passing_train();

				
				level thread train_ledge_passing_train();
}

stop_train_passing()
{
				end_trig = GetEnt("roof_end", "targetname");
				if ( IsDefined( end_trig ) )
				{
								end_trig waittill("trigger");

								
								
								
				}
				else
				{
								iPrintLnBold( "Missing Rooftop end trigger!" );
								return;
				}	
}	



random_passing_train()
{
				
				level endon( "stop_passing_train" );

				
				
				x = 0;

				
				while( 1 )
				{
								
								level train_pass();

								
								x = randomfloatrange(30.0, 120.0);

								
								wait(x);
				}
}



train_pass()
{
				
				
				passing_train_start = GetEnt( "passing_train_start", "targetname" );
				passing_train_end = GetEnt( "passing_train_end", "targetname" );

				
				assertex( isdefined( passing_train_start ), "passing_train_start not defined" );
				assertex( isdefined( passing_train_end ), "passing_train_end not defined" );

				
				level flag_set( "passing_train" );

								
								for ( i = 0; i < level.passing_train.size; i++ )
								{
												level.passing_train[i] show();
								}	

				
								level.passing_train[0] moveto( passing_train_end.origin, 12.0 );

				
								level.passing_train[0] waittill( "movedone" );
								

								
								for ( i = 0; i < level.passing_train.size; i++ )
								{
												level.passing_train[i] hide();
								}	

								
								
								

				
								level.passing_train[0] moveto( passing_train_start.origin, 0.5 );

				
								level.passing_train[0] waittill( "movedone" );

				
				level flag_clear( "passing_train" );
				}





train_ledge_passing_train()
{
				
				

				
				
				trig_stop_random_pass = getent( "trig_first_uncouple_success", "targetname" );
				trig_ledge_passing_train = getent( "trig_ledge_pass", "targetname" );

				
				trig_stop_random_pass waittill( "trigger" );

				
				level.player maps\_utility::play_dialogue( "TANN_TraiG_804A", true );


				
				while( flag( "passing_train" ) == 1 )
				{
								wait( 0.05 );
				}

				
				level notify( "stop_passing_train" );

				
				trig_ledge_passing_train waittill( "trigger" );

				
				level train_pass();

				
				while( flag( "passing_train" ) == 1 )
				{
								wait( 0.05 );
				}

				
				wait( 30.0 );

				
				level thread random_passing_train();

}	





train_flag_init()
{

				
				level flag_init( "outside_train" );
				level flag_init( "on_freight_train" );
				level flag_init( "passing_train" ); 
				level flag_init( "freight_train_active" ); 	
				level flag_init( "freight_train_moving" ); 	
				
				
				level flag_init( "freight_door_busy" ); 
				level flag_init( "freight_to_node2" ); 
				level flag_init( "freight_to_node3" ); 
				level flag_init( "train_obj_1" ); 				
				level flag_init( "train_obj_2" ); 				
				level flag_init( "train_obj_3" ); 				
				level flag_init( "train_obj_4" ); 				
				level flag_init( "train_obj_5" );				
				level flag_init( "train_obj_6" ); 				

				
				level flag_clear( "outside_train" );
				level flag_clear( "on_freight_train" );
				level flag_clear( "passing_train" ); 
				level flag_clear( "freight_train_active" ); 
				level flag_clear( "freight_train_moving" ); 
				level flag_clear( "freight_door_busy" ); 
				level flag_clear( "freight_to_node2" ); 
				level flag_clear( "freight_to_node3" ); 
				level flag_clear( "train_obj_1" ); 				
				level flag_clear( "train_obj_2" ); 
				level flag_clear( "train_obj_3" ); 
				level flag_clear( "train_obj_4" ); 
				level flag_clear( "train_obj_5" ); 
				level flag_clear( "train_obj_6" ); 
				
				
				
				
				level flag_init( "clean_car_1" );
				
				level flag_clear( "clean_car_1" );
				
				
				
				
				
				
				
				
				
				
				
				level flag_init( "car4_populate" );
				level flag_init( "car4_boxcar_surprise" );
				level flag_init( "car4_container_shoot" );
				level flag_init( "car4_top_spawner" );
				level flag_init( "car4_bottom_spawner" );
				
				level flag_clear( "car4_populate" );
				level flag_clear( "car4_boxcar_surprise" );
				level flag_clear( "car4_container_shoot" );
				level flag_clear( "car4_top_spawner" );
				level flag_clear( "car4_bottom_spawner" );
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				

}










train_rain()
{
				
				
				

				
				wait( 5.0 );

				
				forwardrain = level.player.origin ;

				
				

				
				while( 1 )
				{
								while( level.standard_background == true )
								{
								wait ( 0.5 );
								forwardrain = level.player.origin ;	                        
								playfx ( level._effect["rain_bg"], forwardrain ,(0,1,.25));
								playfx ( level._effect["rain9"], forwardrain ,(0,1,.25));
								}

								
								wait( 0.05 );
				}

}




vesper_sit_loop()
{
				
				
				
				
				
				
				
				

				
				level.vesper cmdplayanim( "Gen_Civs_SitConversation_Listen_Female", true );

				
				
				
				

				
				
				
				

				
				level flag_wait( "on_freight_train" );

				
				level.vesper delete();

}




tanner_briefing()
{
				
				

				
				
				level.player play_dialogue( "TANN_TraiG_009A", true );

				
				level.player play_dialogue( "TANN_TraiG_010A", true );
}

display_chyron()
{
	maps\_introscreen::introscreen_chyron(&"MONTENEGROTRAIN_INTRO_01", &"MONTENEGROTRAIN_INTRO_02", &"MONTENEGROTRAIN_INTRO_03");
}





add_wet_materials()
{
	wait( 0.01 );
	
	
    materialaddwet( "mtl_w_sw500_wet" );
    materialaddwet( "mtl_w_sw500_plastic_wet" );
    materialaddwet( "mtl_w_sw500_ammo_wet" );


 	
    materialaddwet( "mtl_w_ump_wet" );

 
	
    materialaddwet( "mtl_w_1300_receiver_rail_wet" );
    materialaddwet( "mtl_w_1300_attach_wet" );
    materialaddwet( "mtl_w_1300_attach_rubber_wet" );
    materialaddwet( "mtl_w_1300_shell_wet" );


	
    materialaddwet( "mtl_w_glock_wet" );
    materialaddwet( "mtl_w_glock_plastic_wet" );
    materialaddwet( "mtl_w_glock_18_wet" );
}





train_background_poles()
{
				

				
				
				level.background_poles = getentarray( "background_poles", "targetname" );
				ent_temp = undefined;
				
				for( i=0; i<level.background_poles.size; i++ )
				{
								
								if( isdefined( level.background_poles[i].target ) )
								{
												
												ent_temp = getent( level.background_poles[i].target, "targetname" );

												
												level.background_poles[i] linkto( ent_temp );

												
												ent_temp = undefined;
								}
								else
								{
												
								}
				}

				
				level.player waittillmatch( "anim_notetrack", "vision_inside" );

				
				for( i=0; i<level.background_poles.size; i++ )
				{
								
								level.background_poles[i] hide();
				}

				
				level waittill( "MT_TR_Intro_done" );

				
				for( i=0; i<level.background_poles.size; i++ )
				{
								
								level.background_poles[i] show();
				}

				
				while( level.standard_background == true )
				{
								
								wait( 0.1 );
				}

				
				
				for( i=0; i<level.background_poles.size; i++ )
				{
								
								level.background_poles[i] hide();
				}

				level waittill( "boss_fight_start" );

				
				for( i=0; i<level.background_poles.size; i++ )
				{
								
								level.background_poles[i] show();
				}
}