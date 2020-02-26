





#include maps\_utility;
#include maps\airport_util;

main()
{
				
				

				
				wait( 0.05 );

				
				
				level maps\_autosave::autosave_now( "airport" );
				level notify("checkpoint_reached"); 

				
				
				
				level thread e5_carlos_init();

				
				level thread e5_gdoors_init();

				
				
				
				
				

				
				level notify("endmusicpackage");

				
			

				
				level thread e5_tanner_speaks();

				
			

				
				

				
				

				
				

				
				


				
				level waittill( "e5_complete" );
}





e5_gdoors_init()
{
				
				

				
				
				sbrush_gdoor_1 = getent( "ent_e5_gdoor_a", "targetname" );
				sbrush_gdoor_2 = getent( "ent_e5_gdoor_b", "targetname" );
				sbrush_gdoor_3 = getent( "ent_e5_gdoor_c", "targetname" );
				
				trig = getent( "ent_trig_start_e5", "targetname" );

				
				level waittill( "str_open_gdoors" );
				
				


				
				sbrush_gdoor_1 thread e5_open_gdoors( 3.0, "gdoor_1" );
				
				sbrush_gdoor_1 playsound("garage_door_open_start");
				wait( 0.2 );
				sbrush_gdoor_3 thread e5_open_gdoors( 3.0, "gdoor_3" );
				sbrush_gdoor_3 playsound("garage_door_open_start");
				wait( 0.3 );
				sbrush_gdoor_2 thread e5_open_gdoors( 3.0, "gdoor_2" );
				sbrush_gdoor_2 playsound("garage_door_open_start");

				
				wait( 5.0 );

				
				level notify( "end_ambush_start" );


}






e5_open_gdoors( flt_time, str_notify )
{
				
				assertex( isdefined( flt_time ), "flt_time is not defined for " + self.targetname );

				
				self moveto( self.origin + ( 0, 0, 122 ), flt_time );

				
				self playsound("garage_door_open");

				
				level notify( str_notify );

				
				self waittill( "movedone" );

				
				
				

				
				

				
				
				wait( 3.0 );

				
		
				


				
				

}





e5_carlos_init()
{
				
				
				

				
				
				spwn_carlos = getent( "ent_spwn_carlos", "targetname" );

			

				
				level.carlos = undefined;


				
				if( spwn_carlos.count == 0 )
				{
								spwn_carlos.count = 5;
				}

				
				level.carlos = spwn_carlos stalingradspawn( "carlos" );

				
				if( spawn_failed( level.carlos ) )
				{
								
								

								
								wait( 1.0 );

								
								return;
				}
				else
				{
								
								level notify( "carlos_made" );

								
								level.carlos setenablesense( false );
								level.carlos lockalertstate( "alert_red" );
								level.carlos SetPainEnable( false );
								level.carlos SetFlashBangPainEnable( false );

								
								

								
								

								level waittill( "end_ambush_start" );

								
								level.carlos thread e5_carlos_last_stand();

								
								level thread e5_carlos_killed( level.carlos );	
								
				}

				
				spwn_carlos delete();
}





e5_carlos_last_stand()
{
				
				self endon( "death" );

				
				
				
				nod_carlos_one = getnode( "nod_carlos_one", "targetname" );
				nod_carlos_two = getnode( "nod_carlos_two", "targetname" );
				nod_carlos_three = getnode( "nod_carlos_three", "targetname" );
				nod_carlos_four = getnode( "nod_carlos_four", "targetname" );
				nod_carlos_five = getnode( "nod_carlos_five", "targetname" );
				nod_carlos_six = getnode( "nod_carlos_six", "targetname" );
				nod_carlos_seven = getnode( "nod_carlos_seven", "targetname" );
				nod_carlos_eight = getnode( "nod_carlos_eight", "targetname" );
				nod_carlos_nine = getnode( "nod_carlos_nine", "targetname" );
				nod_carlos_ten = getnode( "nod_carlos_ten", "targetname" );
				nod_carlos_eleven = getnode( "nod_carlos_eleven", "targetname" );
				nod_carlos_at_truck = GetNode( "nod_carlos_wins", "targetname" );
				
				noda_carlos_last = getnodearray( "nod_carlos_last_stop", "targetname" );
				
				int_random = undefined;

				
				
				
				

				
				self setperfectsense( true );

				
				self setscriptspeed( "sprint" );

				
				self setgoalnode( nod_carlos_one );

				
				self waittill( "goal" );

				
				self setscriptspeed( "default" );

				
				self cmdshootatentity( level.player, true, randomintrange( 2, 5 ), 0.8, true );

				
				self waittill( "cmd_done" );

				
				wait( 1.0 );

				
				self setgoalnode( nod_carlos_two );

				
				
				level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_031B", true );

				
				self waittill( "goal" );

				
				self cmdshootatentity( level.player, true, 3, 0.8, true );

				
				self waittill( "cmd_done" );

				
				int_random = randomint( 12 );

				
				if( int_random <= 6 )
				{
								
								self setgoalnode( nod_carlos_three, 1 );

								
								
								level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_032C", true );

								
								self waittill( "goal" );

								
								self cmdshootatentity( level.player, true, randomintrange( 3, 7 ), 0.8, true );

								
								self waittill( "cmd_done" );								
				}
				else
				{
								
								self setgoalnode( nod_carlos_four );

								
								
								level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_032C", true );

								
								self waittill( "goal" );

								
								self cmdshootatentity( level.player, true, randomintrange( 3, 7 ), 0.8, true );

								
								self waittill( "cmd_done" );

				}
				
				
				int_random = randomint( 20 );

				
				if( int_random > 10 )
				{
								
								self setgoalnode( nod_carlos_six, 1 );

								
								self waittill( "goal" );

								
								self cmdshootatentity( level.player, true, randomintrange( 3, 7 ), 0.8, true );
								
								
								self waittill( "cmd_done" );
				}
				else
				{
								
								self setgoalnode( nod_carlos_five, 1 );

								
								self waittill( "goal" );

								
								self cmdshootatentity( level.player, true, randomintrange( 3, 7 ), 0.8, true );

								
								self waittill( "cmd_done" );
				}

				
				self setgoalnode( nod_carlos_seven, 1 );

				
				self waittill( "goal" );

				
				self allowedstances( "crouch" );

				
				self setgoalnode( nod_carlos_eight );

				
				
				level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_033D", true );

				
				self waittill( "goal" );				

				
				self magicgrenade( self.origin, level.player.origin, 3.0 );

				
				wait( 2.0 );

				
				self allowedstances( "stand" );

				
				self setscriptspeed( "sprint" );

				
				self setgoalnode( nod_carlos_nine, 1 );

				
				self waittill( "goal" );

				
				self cmdshootatentity( level.player, true, randomintrange( 3, 7 ), 0.8, true );

				
				self waittill( "cmd_done" );

				
				self setgoalnode( nod_carlos_ten, 1 );

				
				
				level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_034E", true );

				
				self waittill( "goal" );
				
				
				self setscriptspeed( "default" );

				
				wait( 1.0 );

				
				self setgoalnode( nod_carlos_eleven, 1 );

				
				self waittill( "goal" );

				
				self setgoalnode( noda_carlos_last[randomint(noda_carlos_last.size)] );

				
				self waittill( "goal" );

				
				wait( 1.2 );

				
				self cmdshootatentity( level.player, true, 2.0, 0.7, true );

				
				self waittill( "cmd_done" );

				
				wait( 1.0 );

				
				self setgoalnode( nod_carlos_at_truck, 1 );

				
				
				level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_035F", true );

				
				self waittill( "goal" );

				
				level thread hangar_plane_explodes();

}



hangar_plane_explodes()
{
				

				
				
				truck_explode = GetNode( "nod_carlos_wins", "targetname" );
				plane_fuselage_explode = getent( "so_fuse_exp", "targetname" );
				plane_wing_explode = getent( "so_wing_exp", "targetname" );
				engine_explore = getent( "so_engine_exp", "targetname");
				tugger_explode = getent( "so_engine_exp", "targetname" );
				close_to_bond_explode = getent( "so_close_bond_exp", "targetname" );

				
				end_explosion_a = playfx( level._effect[ "end_explosion" ], truck_explode.origin );
				
				level.player playsound( "airplane_explo" );
				
				earthquake( 0.7, 2.0, truck_explode.origin, 2700 );

				
				setblur( 0.5, 0.25 );

				
				wait( 0.35 );

				
				end_explosion_b = playfx( level._effect[ "end_explosion" ], plane_fuselage_explode.origin );
				
				level.player playsound( "airplane_explo" );
				
				earthquake( 0.75, 2.0, plane_fuselage_explode.origin, 2700 );

				
				setblur( 1.0, 0.25 );

				
				wait( 0.5 ); 

				
				end_explosion_c = playfx( level._effect[ "end_explosion" ], engine_explore.origin );
				
				level.player playsound( "airplane_explo" );
				
				earthquake( 0.8, 2.0, engine_explore.origin, 2700 );

				
				setblur( 1.5, 0.25 );

				
				wait( 0.35 ); 

				
				end_explosion_d = playfx( level._effect[ "end_explosion" ], tugger_explode.origin );
				
				
				end_explosion_ba = playfx( level._effect[ "end_explosion" ], level.player.origin +(700,700,0) );
				level.player playsound( "airplane_explo" );
				
				earthquake( 0.85, 2.0, tugger_explode.origin, 2700 );

				
				setblur( 2.0, 0.25 );

				
				wait( 0.35 ); 

				
				end_explosion_ba = playfx( level._effect[ "end_explosion" ], level.player.origin +(300,300,0) );


				
				end_explosion_e = playfx( level._effect[ "end_explosion" ], close_to_bond_explode.origin );
				
				level.player playsound( "airplane_explo" );
				earthquake( 2.0, 1, level.player.origin, 4000 );
				


				
				wait(0.3);
				
				
				missionfailed();
				level.player shellshock( "flashbang", 6 );
	
}




































































































































































































e5_button_open_gdoors()
{
				

				
				
				
				
				electrical_box = getent( "ent_e5_gdoor_button", "targetname" );
				
				use_touch_trig = getent( electrical_box.target, "targetname" );
				use_touch_trig sethintstring(&"HINT_OPEN_GARAGE_DOORS");
				
				
				top_button_tag = electrical_box gettagorigin( "tag_top_button" );
				bottom_button_tag = electrical_box gettagorigin( "tag_bottom_button" );
				
				level.gdoors_open = false;

				
				use_touch_trig maps\_utility::trigger_off();

				
				top_button = spawn( "script_model", top_button_tag );
				
				wait( 0.05 );
				
				top_button linkto( electrical_box );
				
				top_button setmodel( "p_lvl_garage_control_button_off" );
				
				bottom_button = spawn( "script_model", bottom_button_tag );
				
				wait( 0.05 );
				
				bottom_button linkto( electrical_box );
				
				bottom_button setmodel( "p_lvl_garage_control_button_off" );
				
				bottom_button.angles = ( -0, 180, 180 );

				
				
				level waittill( "str_tanner_done" );
				

				
				
				level thread e5_garage_button_blink( top_button );

				
				
				
				

				
				wait( 0.05 );

				
				use_touch_trig maps\_utility::trigger_on();

				
				use_touch_trig waittill( "trigger" );

				
				top_button playsound( "door_switch" );

				
				
				SetExpFog( 0, 3961, 0.27, 0.28, 0.32, 0.05, 1 );
				Visionsetnaked( "airport_05" );

				
				
				
				wait( 0.05 );

				
				level thread split_screen();

				
				use_touch_trig maps\_utility::trigger_off();
				

				
				level notify( "str_open_gdoors" );

				
				level.gdoors_open = true;

				
				

				
				wait( 3.0 );

				
				level notify("playmusicpackage_tarmac");

				
				


}


blink_yellow_light()
{
	light = getent ("e5_yellow_light","targetname");
	
	
	while ( 1 )
	{
		light setlightintensity ( 3.4 );
		wait( 1.5 );
		





		light setlightintensity ( 0 );
		wait(1.5);
	}
}








e5_garage_button_blink( button )
{
				
				level.player endon( "death" );

				
				
				fx = undefined;
				fx2 = undefined;
				
			
				
				

				
				while(  level.gdoors_open == false )
				{
								
								button setmodel( "p_lvl_garage_control_button_on" );
								
								
								fx = spawnfx( level._effect["garage_yellow"], button.origin + (0, 0,0) );
								triggerFx( fx );
								


								
								wait( 1.8 );

								
								button setmodel( "p_lvl_garage_control_button_off" );
								
								fx delete();
								

								
								wait( 1.8 );

				}

				
				button setmodel( "p_lvl_garage_control_button_on" );
				
				fx = playfx( level._effect["garage_yellow"], button.origin );

}





e5_tanner_speaks()
{
				
				level notify("endmusicpackage");

				

				

				
				
				level maps\_utility::flag_set( "objective_4" );

				
				
				level.player maps\_utility::play_dialogue("TANN_AirpG_030A", true );
				wait(0.05);

				
				level notify( "str_tanner_done" );

				
				

				
				

				
				

				
				
				
				level.player maps\_utility::play_dialogue("M_AirpG_047A", true ); 
				level.player maps\_utility::play_dialogue("M_AirpG_048A", true ); 

				
				

}






e5_carlos_killed( carlos )
{

				
				blop = spawn( "script_origin", carlos.origin );	
				blop linkto(carlos, "tag_origin", (0,0,0), (0,0,0));
				
				
				carlos waittill( "death" );
													
				blop unlink();


				wait(2);
				end_explosion_a = playfx( level._effect[ "f_explosion" ], blop.origin );
				
				earthquake( 1, 1.0, level.player.origin, 2700 );
				wait(1.3);
				earthquake( 0.6, 0.5, level.player.origin, 2700 );
				
				end_explosion_a = playfx( level._effect[ "f_explosion" ], blop.origin );
				wait(0.5);
				earthquake( 0.3, 0.2, level.player.origin, 2700 );
				
				end_explosion_a = playfx( level._effect[ "f_explosion" ], blop.origin );
							
				
				objective_state( 5, "done" );
			
				
				level notify ( "endmusicpackage" );
			
				
				giveachievement( "Progression_Airport" );
			
				
				wait( 1.5 ); 
						
				
				level notify( "e5_complete" );
}























































































































































































































split_screen()
{
	level notify("checkpoint_reached"); 
	wait(1.0);

	thread letterbox_on();
	
	main_camera();
	letterbox_off();
}

main_camera()
{
	
				hangar_cam = getent( "cam_hangar", "targetname" );
				
				
	level.player customcamera_checkcollisions( 0 );
	level.player freezecontrols( true );
	bondAngle = level.player getplayerangles();
	server_cam = level.player customCamera_Push( "entity", hangar_cam, level.carlos, ( 8.43, 2.71, 28.11 ), ( -3.13, -1.30, 0 ), 0.0 );
	
	level notify("end_ambush_start");
	
	wait(5);
		
	
	level.player setplayerangles( bondAngle );
	level.player customCamera_pop( server_cam, 0 );
	level.player freezecontrols( false );
		
	
	level.player customcamera_checkcollisions( 1 );

}


main_crop()
{

	
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 3);		

	
	
	level.player animatepip( 500, 1, -1, -1, .75, .75, 0.75, .75);
	wait(0.6);	
		
	level notify( "window_crop" );
		
	level waittill( "off_screen" );
	

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 1, 1, 1);
	wait(0.5);
	level notify( "window_uncrop" );
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
	setSavedDvar("cg_drawHUD","1");

}


second_move()
{
	
	
	level.player setsecuritycameraparams( 65, 3/4 );
	wait(0.05);	
	cameraID_hack = level.player securityCustomCamera_Push( "entity", level.player, level.player, ( -50, -40, 77), ( -32, -7, 0), 0.1);

	
	
	
	SetDVar("r_pipSecondaryAnchor", 4);						
	
	

	
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");
		
	
	
	
	level.player animatepip( 10, 0, 0.6, -0.5, .36, .5, .35, .5);

	level waittill( "window_crop" );
	

	SetDVar("r_pipSecondaryMode", 5);		
	
	
	level.player animatepip( 500, 0, 0.6, .15);
	wait(0.5);
	
	

	
	
	level waittill( "open_server_room_doors" );

	
	level.player animatepip( 500, 0, .6, 1 );
	wait(0.6);
		
	level notify( "off_screen" );
	
	
	SetDVar("r_pipSecondaryMode", 0);
	level.player securitycustomcamera_pop( cameraID_hack );
	level.player PlayerAnimScriptEvent("");

						
}


second_anim()
{
	level endon("off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("phonehacklock");
		wait .05;
	}
	
}
