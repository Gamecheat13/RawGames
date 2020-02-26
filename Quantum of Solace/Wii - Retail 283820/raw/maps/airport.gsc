









main()
{		
				
	
	
	

				
				
				
				

				
				level maps\_playerawareness::init();

				
				level airport_precache();

				
				level maps\airport_anim::main();

				
				level maps\airport_fx::main();
				
				
				gamefadeintime( 30.0 );
				
				
				
				
				
				
			 
				
				
				
				

				
				
				
				
				
				
				
				
				
				character\character_tourist_1::precache();
				level.drone_spawnFunction["civilian"][0] = character\character_tourist_1::main;

				
				maps\_drones::init();

				
				level maps\_load::main();

				
				maps\_utility::init_level_clocks(7, 3, 41);
 
				
				

				level.introblack = NewHudElem();
				level.introblack.x = 0;
				level.introblack.y = 0;
				level.introblack.horzAlign = "fullscreen";
				level.introblack.vertAlign = "fullscreen";
				level.introblack.foreground = true;
				level.introblack.alpha = 1;
				level.introblack SetShader( "black", 640, 480 );

				
				
				

				
				level.catwalk_invalid = false;


				
				
				
				

				
				level maps\_trap_extinguisher::init();

				
				

				
				Visionsetnaked( "airport_01" );

				
				level maps\_securitycamera::init();

				
				setDVar( "cg_laserAiOn", 1 );

				
				
				level maps\airport_amb::main();

				
				level maps\airport_mus::main();

				
				

				
				
				
	
	
	
	

				
				SetMiniMap( "compass_map_airport", 600, 14104, -6864, -1048 );

				
				level.awareness_obj = 0;
				
				
				
				
				level thread add_wet_materials();
				
	
				
				
				
				
				
				
				
				

				
				
				

				
				level airport_flags();
				
				
				setDVar( "r_bx_airport_laptop_enable", 1 );
				
				
				

				
				if( Getdvar( "artist" ) == "1" )
				{
								return;   
				}

				
				

				
				level thread maps\airport_util::airport_vision_set_init();

				
				
				

				
				

				
	

				
				str_skipto = getdvar( "skipto" );
				
				
				
	
	

				
				
				
				switch( str_skipto )
				{

								
								
								
				case "E2":

								
								level.player freezecontrols( true );
								
								
								setDVar( "r_bx_airport_laptop_enable", 0 );

								
								air_e2_start = getnode( "nod_e2_player_start", "targetname" );

								
								SetExpFog( 323, 651, 0.5, 0.5, 0.5, 1.0, 0.9 );
								
								
								
								Visionsetnaked( "airport_02" );

								
								
								
								spwn_e2_btm_ptl = getent( "nod_e2_bottom_patrol", "targetname" );
								ent_guy = undefined;
								
								ent_guy = spwn_e2_btm_ptl stalingradspawn( "e2_patroller" );
								if( !maps\_utility::spawn_failed( ent_guy ) )
								{
												
												ent_guy setalertstatemin( "alert_yellow"  );

												
												ent_guy setscriptspeed( "default" );

												
												ent_guy thread maps\airport_two::e2_bottom_hallway_patrol();
								}

								
								
								
								level.player setorigin( air_e2_start.origin + ( 0, 0, 5 ) );
								level.player setplayerangles( air_e2_start.angles );

								
								setdvar( "skipto", "" );

								
								level maps\_utility::flag_set( "objective_1" );

									
								merc_1 = getent( "Merc1", "targetname" );
								merc_2 = getent( "Merc2", "targetname" );

								
								wait( 0.05 );

								
								merc_1 delete();
								merc_2 delete();
								
								
								
								level thread maps\airport_util::airport_objectives();

								
								wait( 1.0 );

								
								
								
								level thread maps\airport_util::airport_plane_flyby();

								
								level.introblack fadeOverTime( 3.0 );
								
								level.introblack.alpha = 0;
								
								wait( 3 );

								
								level.player freezecontrols( false );

								level maps\airport_two::main();
								level maps\airport_three::main();
								level maps\airport_four::main();
								
								
								
								
								
								level maps\airport_five::main();	
								
								break;

								
								
				case "E3":

								
								level.player freezecontrols( true );

								
								setDVar( "r_bx_airport_laptop_enable", 0 );
								
								
								air_e3_start = getnode( "nod_e3_player_start", "targetname" );

								
								level.player setorigin( air_e3_start.origin + ( 0, 0, 5 ) );
								level.player setplayerangles( air_e3_start.angles );

								
								setdvar( "skipto", "" );

								
								level maps\_utility::flag_set( "objective_1" );
								level maps\_utility::flag_set( "objective_2" );

								
								merc_1 = getent( "Merc1", "targetname" );
								merc_2 = getent( "Merc2", "targetname" );

								
								wait( 0.05 );

								
								merc_1 delete();
								merc_2 delete();

								
								level thread maps\airport_util::airport_objectives();

								
								SetExpFog( 323, 651, 0.5, 0.5, 0.5, 1.0, 0.9 );
								
								
								
								Visionsetnaked( "airport_03" );

								
								wait( 1.0 );

								
								
								
			

								
								
								
								
								level thread maps\airport_two::air_setup_zone3();

								
								level.introblack fadeOverTime( 2.0 );
								
								level.introblack.alpha = 0;
								
								wait( 3 );

								
								level.player freezecontrols( false );

								level maps\airport_three::main();
								level maps\airport_four::main();
								
								
								
								
								
								level maps\airport_five::main();
								
								break;

								
								
								
				case "E4":

								
								level.player freezecontrols( true );

								
								setDVar( "r_bx_airport_laptop_enable", 0 );
								
								
								air_e4_start = getnode( "nod_e4_player_start", "targetname" );

								
								
								
								level.player setorigin( air_e4_start.origin );
								level.player setplayerangles( air_e4_start.angles );

								
								setdvar( "skipto", "" );

								
								level maps\_utility::flag_set( "objective_1" );
								level maps\_utility::flag_set( "objective_2" );
								level maps\_utility::flag_set( "objective_3" );

								
								merc_1 = getent( "Merc1", "targetname" );
								merc_2 = getent( "Merc2", "targetname" );

								
								wait( 0.05 );

								
								merc_1 delete();
								merc_2 delete();

								
								
								
								
			
								
			


								
								level thread maps\airport_util::airport_objectives();

								
								SetExpFog( 323, 651, 0.5, 0.5, 0.5, 1.0, 0.9 );
								
								
								
								Visionsetnaked( "airport_04" );

								
								wait( 1.0 );

								
								
								
			

								
								level.player giveweapon( "TND16_AIR_s" );

								
								level.introblack fadeOverTime( 2.0 );
								
								level.introblack.alpha = 0;
								
								wait( 3 );

								
								level.player freezecontrols( false );

								level maps\airport_four::main();
								level maps\airport_five::main();

								
								break;


								
								
								
				case "E5":

								
								level.player freezecontrols( true );
								
								
								setDVar( "r_bx_airport_laptop_enable", 0 );
								
								
								
								
								
								air_e5_start = getnode( "nod_e5_player_start", "targetname" );

								
								
								
								level.player setorigin( air_e5_start.origin );
								
								if( isdefined( air_e5_start ) )
								{
												level.player setplayerangles( air_e5_start.angles );
								}

								
								
								
								level maps\_utility::flag_set( "objective_1" );
								level maps\_utility::flag_set( "objective_2" );
								level maps\_utility::flag_set( "objective_3" );
								level maps\_utility::flag_set( "objective_4" );
								level maps\_utility::flag_set( "objective_5" );

			
								
			
								
								merc_1 = getent( "Merc1", "targetname" );
								merc_2 = getent( "Merc2", "targetname" );

								
								wait( 0.05 );

								
								merc_1 delete();
								merc_2 delete();

								
								SetExpFog( 500, 600, 0.27, 0.28, 0.32, 1.0 );
								
								setDVar( "scr_fog_max", "0.87" );
								
								Visionsetnaked( "airport_04" );

								
								
								
								
								
								level thread maps\airport_five::e5_button_open_gdoors();

								
								
								
								
								level thread maps\airport_four::forklift_explo_setup();

								
								
								
			

								
								level.player giveweapon( "TND16_AIR_s" );

								
								level.introblack fadeOverTime( 2.0 );
								
								level.introblack.alpha = 0;
								
								wait( 3 );

								
								level.player freezecontrols( false );

								
								
								
								
								
								
								
								level maps\airport_five::main();

								
								break;

								
								
				default:

								
								level.player freezecontrols( true );

								
								
								level thread maps\airport_util::airport_objectives();

								
								

								
								SetExpFog( 323, 651, 0.5, 0.5, 0.5, 1.0, 0.9 );
								
								

								
								
								
								
								

								
								level maps\airport_one::main();
								level maps\airport_two::main();
								level maps\airport_three::main();
								level maps\airport_four::main();
								level maps\airport_five::main();

								
								break;
				}

				
				
				
				
				
				
				wait( 3 );
				
				
				
				
					
				
				
				
				
				level maps\_endmission::nextmission();

}

airport_precache()
{
				
				precacheShader( "compass_map_airport" );

				
				

				
				precacheitem( "v_jet_jumbo" );

				
				precachevehicle( "defaultvehicle" );
				

				
	
				precachemodel( "v_van_white_radiant" );
				precachemodel( "p_frn_chair_metal" );
				precachemodel( "p_dec_laptop_blck" );
				precachemodel( "p_dec_monitor_modern" );
				precachemodel( "p_dec_tv_plasma" );
				precachemodel( "p_lvl_garage_control_button_off" );
				precachemodel( "p_lvl_garage_control_button_on" );

				
	
	

				
				precachecutscene( "Airport_Intro" );
				
				
				PreCacheItem("flash_grenade");

				
				
				
				
				
				
				
				level.strings["airport_phone1_name"] = &"AIRPORT_PHONE_NAME1";
				level.strings["airport_phone1_body"] = &"AIRPORT_PHONE_BODY1";

				level.strings["airport_phone2_name"] = &"AIRPORT_PHONE_NAME2";
				level.strings["airport_phone2_body"] = &"AIRPORT_PHONE_BODY2";

				level.strings["airport_phone3_name"] = &"AIRPORT_PHONE_NAME3";
				level.strings["airport_phone3_body"] = &"AIRPORT_PHONE_BODY3";

				level.strings["airport_phone4_name"] = &"AIRPORT_PHONE_NAME4";
				level.strings["airport_phone4_body"] = &"AIRPORT_PHONE_BODY4";
				
				level.strings["airport_phone5_name"] = &"AIRPORT_PHONE_NAME5";
				level.strings["airport_phone5_body"] = &"AIRPORT_PHONE_BODY5";
}







airport_flags()
{
				
				level maps\_utility::flag_init( "objective_1" );
				level maps\_utility::flag_init( "objective_2" );
				level maps\_utility::flag_init( "objective_3" );
				level maps\_utility::flag_init( "objective_4" );
				level maps\_utility::flag_init( "objective_5" );
				level maps\_utility::flag_init( "objective_6" );

				level maps\_utility::flag_clear( "objective_1" );
				level maps\_utility::flag_clear( "objective_2" );
				level maps\_utility::flag_clear( "objective_3" );
				level maps\_utility::flag_clear( "objective_4" );
				level maps\_utility::flag_clear( "objective_5" );
				level maps\_utility::flag_clear( "objective_6" );

				
	

				
				
				level maps\_utility::flag_init( "e1_stealth_broken" );
				level maps\_utility::flag_init( "e1_virus_started" );
				level maps\_utility::flag_init( "e1_suspense_broken" );

				
				level maps\_utility::flag_clear( "e1_stealth_broken" );
				level maps\_utility::flag_clear( "e1_virus_started" );
				level maps\_utility::flag_clear( "e1_suspense_broken" );

				
				level maps\_utility::flag_init( "event_two_start" );
				level maps\_utility::flag_init( "e2_stealth_broken" );
				level maps\_utility::flag_init( "e2_virus_started" );

				level maps\_utility::flag_clear( "event_two_start" );
				level maps\_utility::flag_clear( "e2_stealth_broken" );
				level maps\_utility::flag_clear( "e2_virus_started" );

				
				level maps\_utility::flag_init( "e3_stealth_broken" );
				level maps\_utility::flag_init( "e3_antivirus_started" );
				

				level maps\_utility::flag_clear( "e3_stealth_broken" );
				level maps\_utility::flag_clear( "e3_antivirus_started" );
				
				

				
				

				

}




airport_move_player( destin )
{
				level.player freezecontrols( true );

				so_move = spawn( "script_origin", level.player.origin );

				so_move.angles = level.player.angles;

				level.player linkto( so_move );

				so_move moveto( destin.origin + ( 0, 0, 8 ), 0.1 );

				so_move waittill( "movedone" );

				so_move rotateto( destin.angles, 0.1 );

				so_move waittill( "rotatedone" );

				level.player unlink();

				level.player freezecontrols( false );

				wait( 0.5 );
				so_move delete();


}





airport_backup_door_linker()
{
				
				

				
				enta_doors = getentarray( "backup_doors", "script_noteworthy" );
				
				
				locks = undefined;

				
				for( i=0; i<enta_doors.size; i++ )
				{

								
								
								
								locks = getentarray( enta_doors[i].target, "targetname" );

								
								
								for( j=0; j<locks.size; j++ )
								{
												
												locks[j] linkto( enta_doors[i] );
								}

								
								

								
								locks = undefined;

				}
}




add_wet_materials()
{
	wait( 0.01 );

	materialaddwet( "mtl_w_mp05_plastic_wet" );
	materialaddwet( "mtl_w_mp05_stock_sd_wet" );
	materialaddwet( "mtl_w_mp05_scope_mount_wet" );
	materialaddwet( "mtl_w_scope_red_dot_wet" );
	materialaddwet( "mtl_w_m4_wet" );
	materialaddwet( "mtl_w_m4_mag_wet" );
	materialaddwet( "mtl_w_scope_holo_wet" );
	materialaddwet( "mtl_w_scope_holo_switch_wet" );
	materialaddwet( "mtl_w_stock_wet" );
	materialaddwet( "mtl_w_front_sight_post_wet" );
	materialaddwet( "mtl_w_m32_wet" );
	materialaddwet( "mtl_w_m32_metal_wet" );
	materialaddwet( "mtl_w_m32_ammo_wet" );
	materialaddwet( "mtl_w_1911_wet" );

}






laptop_renderer()
{
	
	level endon ("objective_1");
	starttrig = getent("start_laptop_renderer","targetname");
	
	while ( !maps\_utility::flag( "objective_1" ) )
	{
		
		starttrig waittill ("trigger");
		
		if (Getdvar ("r_bx_airport_laptop_enable") == true)
		{	
			setdvar ("r_bx_airport_laptop_enable", 0); 
		}
		else
		{
			setdvar ("r_bx_airport_laptop_enable", 1); 
		}
	
	}
}


