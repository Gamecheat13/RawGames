/*-----------------------------------------------------

Ambient stuff

-----------------------------------------------------*/

#include maps\_utility;

#include common_scripts\ambientpackage;

#include maps\_fx;

 

 

main()

{


//************************************************************************************************

//                                              Ambient Packages

//************************************************************************************************

 //***************
 
 //siena_cistern_1_pkg
 
 //***************   
 
  
 
             declareAmbientPackage( "siena_cistern_1_pkg" ); 
             
 			addAmbientElement( "siena_cistern_1_pkg", "cistern_1shot", 6, 27, 3000, 5000 );
            
             
 //***************
 
 //siena_cistern_2_pkg
 
 //***************   
 
  
 
             declareAmbientPackage( "siena_cistern_2_pkg" );   
             
			addAmbientElement( "siena_cistern_2_pkg", "cistern_1shot", 6, 27, 2000, 2000 );
			addAmbientElement( "siena_cistern_2_pkg", "cistern_1shot_c", 6, 17, 2000, 2000 );


 //***************
 
 //siena_cistern_stairway_pkg
 
 //***************   
 
  
 
             declareAmbientPackage( "siena_cistern_stairway_pkg" );   
             
			addAmbientElement( "siena_cistern_stairway_pkg", "cistern_1shot", 6, 27, 2000, 2000 );
  			addAmbientElement( "siena_cistern_stairway_pkg", "cistern_1shot_b", 6, 17, 2000, 2000 );
           
             
 //***************
 
 //siena_cistern_corridor_pkg
 
 //***************   
 
  
 
             declareAmbientPackage( "siena_cistern_corridor_pkg" ); 
             
 			addAmbientElement( "siena_cistern_corridor_pkg", "cistern_1shot", 6, 27, 2600, 3000 );
  			addAmbientElement( "siena_cistern_corridor_pkg", "cistern_1shot_b", 6, 11, 3000, 6000 );
			
 //***************
 
 //siena_cistern_corridor_2_pkg
 
 //***************   
 
  
 
             declareAmbientPackage( "siena_cistern_corridor_2_pkg" ); 
             
 			addAmbientElement( "siena_cistern_corridor_2_pkg", "cistern_1shot", 6, 27, 2000, 2000 );
  			addAmbientElement( "siena_cistern_corridor_2_pkg", "cistern_1shot_b", 6, 13, 2000, 2000 );
  			
			
 //***************
 
 //siena_cistern_cave_pkg
 
 //***************   
 
  
 
             declareAmbientPackage( "siena_cistern_cave_pkg" ); 
             
 			addAmbientElement( "siena_cistern_cave_pkg", "cistern_1shot", 6, 27, 2500, 3500 );
			
			
 //***************
 
 //siena_ext_1_pkg
 
 //***************   
 
  
 
             declareAmbientPackage( "siena_ext_1_pkg" );            

   			//addAmbientElement( "siena_ext_1_pkg", "cistern_1shot", 6, 45, 2000, 2000 );
        

//************************************************************************************************

//                                              ROOMS

//************************************************************************************************

 //***************
 
 //siena_cistern_1
 
 //***************
 
  
 
             declareAmbientRoom( "siena_cistern_1" );
  
 
                        //setAmbientRoomTone( "siena_cistern_1", "amb_bg_siena_cistern_1", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "siena_cistern_1", "stoneroom", 1, 0.8 );

 //***************
 
 //siena_cistern_2
 
 //***************
 
  
 
             declareAmbientRoom( "siena_cistern_2" );
  
 
                        //setAmbientRoomTone( "siena_cistern_2", "amb_bg_siena_cistern_2", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "siena_cistern_2", "hangar", 1, 0.5 );
 //***************
 
 //siena_cistern_stairway
 
 //***************
 
  
 
             declareAmbientRoom( "siena_cistern_stairway" );
  
 
                        //setAmbientRoomTone( "siena_cistern_stairway", "amb_bg_siena_cistern_stairway", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "siena_cistern_stairway", "hangar", 1, 0.3 );


 //***************
 
 //siena_cistern_corridor
 
 //***************
 
  
 
             declareAmbientRoom( "siena_cistern_corridor" );
  
 
                        //setAmbientRoomTone( "siena_cistern_corridor", "amb_bg_siena_cistern_corridor", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "siena_cistern_corridor", "cave", 1, 0.5 );
  	             	
  	             	
 //***************
 
 //siena_cistern_corridor_2
 
 //***************
 
  
 
             declareAmbientRoom( "siena_cistern_corridor_2" );
  
 
                        //setAmbientRoomTone( "siena_cistern_corridor_2", "amb_bg_siena_cistern_corridor_2", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "siena_cistern_corridor_2", "hangar", 1, 0.4  );
  	             	
  	             	
 //***************
 
 //siena_cistern_cave
 
 //***************
 
  
 
             declareAmbientRoom( "siena_cistern_cave" );
  
 
                        //setAmbientRoomTone( "siena_cistern_cave", "amb_bg_siena_cistern_cave", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "siena_cistern_cave", "cave", 1, 0.7 );
  	             	
  	             	
 //***************
 
 //siena_ext_1
 
 //***************
 
  
 
             declareAmbientRoom( "siena_ext_1" );
  
 
                        //setAmbientRoomTone( "siena_ext_1", "amb_bg_siena_ext_1", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "siena_ext_1", "city", 1, 0.9 );
	             	//setAmbientRoomReverb( "siena_ext_1", "stoneroom", 1, 0.5 );

 

             

//************************************************************************************************

 

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

 

//************************************************************************************************

 
            setBaseAmbientPackageAndRoom( "siena_cistern_1_pkg", "siena_cistern_1" );

 

                                    signalAmbientPackageDeclarationComplete();


 
//*************************************************************************************************

 

//                                              Static Loops

 

//*************************************************************************************************


	//1st cistern room
	loopsound("electric_hum", (-5056, 906, 381), 1.499);
	//loopsound("amb_cistern_01", (-5056, 906, 381), 20.139);
	loopsound("cistern_drips_b", (-6327, 505, 443), 6.741);
	loopsound("amb_pipe", (-6327, 505, 443), 0.649);
	loopsound("fan", (-6346, 505, 487), 8.747);
	
	//cistern stairway
	loopsound("slow_drain", (-4825, 1054, 34), 8.857);
	loopsound("cistern_water_trickle", (-4694, 1085, 191), 5.237);
	loopsound("cistern_drips_a", (-4837, 1176, 66), 10.893);
	
	//cistern corridor
	loopsound("cistern_drips_b", (-4510, 1582, 135), 6.741);
	loopsound("cistern_drips_a", (-4197, 1177, 47), 10.893);
	loopsound("cistern_drips_a", (-4050, 946, 53), 10.893);
	loopsound("cistern_drips_a", (-3876, 677, 52), 10.893);
	loopsound("cistern_drips_a", (-3737, 472, 48), 10.893);
	loopsound("cistern_drips_b", (-3048, -67, -79), 6.741);
	loopsound("cistern_drips_b", (-3004, -372, -90), 6.741);
	loopsound("small_drain", (-4526, 1584, 129), 6.326);
	loopsound("small_drain_2", (-3362, -0, 136), 7.381);
	//loopsound("water_flow_light", (-4520, 1620, 140), 9.555);
	//loopsound("water_flow_light_2", (-4528, 1537, 151), 7.35);
	
	//2nd cistern room
	//loopsound("cistern_fountain_dist", (-2551, -734, -161), 6.457);
	//loopsound("cistern_fountain_dist", (-2002, -737, -161), 6.457);
	//loopsound("cistern_fountain_dist", (-1498, -743, -157), 6.457);
	//loopsound("cistern_fountain_dist", (-1473, -28, -157), 6.457);
	//loopsound("cistern_fountain_dist", (-2005, -45, -161), 6.457);
	//loopsound("cistern_fountain_close", (-2551, -734, -161), 6.614);
	//loopsound("cistern_fountain_close", (-2002, -737, -161), 6.614);
	//loopsound("cistern_fountain_close", (-1498, -743, -157), 6.614);
	//loopsound("cistern_fountain_close", (-1473, -28, -157), 6.614);
	//loopsound("cistern_fountain_close", (-2005, -45, -161), 6.614);
	loopsound("big_room_trickle", (-2546, -748, -161), 7.500);
	loopsound("big_room_trickle", (-2001, -743, -161), 7.500);
	loopsound("big_room_trickle", (-1730, -744, -161), 7.500);
	loopsound("big_room_trickle", (-911, -747, -161), 7.500);
	loopsound("big_room_trickle", (-654, -863, -157), 7.500);
	loopsound("big_room_trickle", (-653, -865, -157), 7.500);
	loopsound("big_room_trickle", (-383, -627, -157), 7.500);
	loopsound("big_room_trickle", (-387, -153, -157), 7.500);
	loopsound("big_room_trickle", (-652, 109, -173), 7.500);
	loopsound("big_room_trickle", (-1468, 88, -170), 7.500);
	loopsound("big_room_trickle", (-2010, 85, -169), 7.500);
	loopsound("big_room_trickle", (-2284, 103, -159), 7.500);
	
	
	 

//*************************************************************************************************

 

//                                              START SCRIPTS

 

//*************************************************************************************************

 

 

            // finally, call this to allow the trigger initialization to complete, since it was waiting for all declarations

            // so that it could perform error checking

            // signalAmbientPackageDeclarationComplete();
            
 	    
 	    start_static_zone_emitters();
 	    


}

 
//*************************************************************************************************

 

//                                              Functions

 

//*************************************************************************************************

play_big_flood_drain()
{
	drain_org = spawn("script_origin", (-918, -361, -10));
	drain_org playloopsound("big_flood_drain", 1.1);
	wait(27.0);
	drain_org playsound("big_flood_drain_end");
	drain_org stoploopsound(2.5);
	wait(5.6);
	drain_org delete();
}	

play_flood_rumble()
{
	level.player playloopsound("flood_rumble", 0.3);
	wait (4.8);
	north = GetEnt("tunnel_north","targetname");
	north playloopsound("flood_rumble_2", 1.0);
	level.player stoploopsound(1.2);
	wait (20.0);
	north stoploopsound(4.5);
}	






play_flood_stream_01()
{
	flood_stream_01_org_var = getent("flood_stream_01_org", "targetname");
	flood_stream_01_splash_org_var = getent("flood_stream_01_splash_org", "targetname");
	
	if(IsDefined(flood_stream_01_org_var))
	{
		flood_stream_01_org_var playsound("flood_stream_01_burst");
		wait(0.4);
		flood_stream_01_org_var playloopsound("flood_stream_01_a", 0.2);
		wait(1.6);
		flood_stream_01_splash_org_var playloopsound("flood_stream_01", 0.1);
		wait(20);
		flood_stream_01_org_var stoploopsound(2.5);
		flood_stream_01_splash_org_var stoploopsound(2);
	}
}	

play_flood_stream_02()
{
	flood_stream_02_org_var = getent("flood_stream_02_org", "targetname");
	flood_stream_02_splash_org_var = getent("flood_stream_02_splash_org", "targetname");
	
	if(IsDefined(flood_stream_02_org_var))
	{
		flood_stream_02_org_var playsound("flood_stream_01_burst");
		wait(0.4);
		flood_stream_02_org_var playloopsound("flood_stream_01_a", 0.2);
		wait(1.6);
		flood_stream_02_splash_org_var playloopsound("flood_stream_01", 0.1);
		wait(20);
		flood_stream_02_org_var stoploopsound(2.5);
		flood_stream_02_splash_org_var stoploopsound(2);
	}
}

play_flood_stream_03()
{
	flood_stream_03_org_var = getent("flood_stream_03_org", "targetname");
	flood_stream_03_splash_org_var = getent("flood_stream_03_splash_org", "targetname");
	
	if(IsDefined(flood_stream_03_org_var))
	{
		flood_stream_03_org_var playsound("flood_stream_01_burst");
		flood_stream_03_org_var playsound("cistern_metal_debris");
		flood_stream_03_org_var playsound("big_flood_creak");
		wait(0.4);
		flood_stream_03_org_var playloopsound("flood_stream_01_a", 0.2);
		wait(1.6);
		flood_stream_03_splash_org_var playloopsound("flood_stream_01", 0.1);
		wait(20);
		flood_stream_03_org_var stoploopsound(2.5);
		flood_stream_03_splash_org_var stoploopsound(2);
	}
}

play_flood_stream_04()
{
	flood_stream_04_org_var = getent("flood_stream_04_org", "targetname");
	flood_stream_04_splash_org_var = getent("flood_stream_04_splash_org", "targetname");
	
	if(IsDefined(flood_stream_04_org_var))
	{
		flood_stream_04_org_var playsound("flood_stream_01_burst");
		wait(0.4);
		flood_stream_04_org_var playloopsound("flood_stream_01_a", 0.2);
		wait(1.6);
		flood_stream_04_splash_org_var playloopsound("flood_stream_01", 0.1);
		wait(20);
		flood_stream_04_org_var stoploopsound(2.5);
		flood_stream_04_splash_org_var stoploopsound(2);
	}
}

play_flood_stream_05()
{
	flood_stream_05_org_var = getent("flood_stream_05_org", "targetname");
	flood_stream_05_splash_org_var = getent("flood_stream_05_splash_org", "targetname");
	
	if(IsDefined(flood_stream_05_org_var))
	{
		flood_stream_05_org_var playsound("flood_stream_01_burst");
		wait(0.4);
		flood_stream_05_org_var playloopsound("flood_stream_01_a", 0.2);
		wait(1.6);
		flood_stream_05_splash_org_var playloopsound("flood_stream_01", 0.1);
		wait(20);
		flood_stream_05_org_var stoploopsound(2.5);
		flood_stream_05_splash_org_var stoploopsound(2);
	}
}

play_flood_stream_06()
{
	flood_stream_06_org_var = getent("flood_stream_06_org", "targetname");
	flood_stream_06_splash_org_var = getent("flood_stream_06_splash_org", "targetname");
	
	if(IsDefined(flood_stream_06_org_var))
	{
		flood_stream_06_org_var playsound("flood_stream_01_burst");
		flood_stream_06_org_var playsound("cistern_clay_debris");
		wait(0.4);
		flood_stream_06_org_var playloopsound("flood_stream_01_a", 0.2);
		wait(1.6);
		flood_stream_06_splash_org_var playloopsound("flood_stream_01", 0.1);
		wait(20);
		flood_stream_06_org_var stoploopsound(2.5);
		flood_stream_06_splash_org_var stoploopsound(2);
	}
}

start_static_zone_emitters()
{
	amb_cistern_01_zone_var = getent("amb_cistern_01_zone", "targetname");

	if(IsDefined(amb_cistern_01_zone_var))
	{
		amb_cistern_01_zone_var playloopsound("amb_cistern_01");
	}	

	amb_cistern_02_zone_var = getent("amb_cistern_02_zone", "targetname");
	
	if(IsDefined(amb_cistern_02_zone_var))
	{
		amb_cistern_02_zone_var playloopsound("amb_cistern_02");
	}	

	amb_cistern_01b_zone_var = getent("amb_cistern_01b_zone", "targetname");

	if(IsDefined(amb_cistern_01b_zone_var))
	{
		amb_cistern_01b_zone_var playloopsound("amb_cistern_01b");
	}	

	amb_cistern_02b_zone_var = getent("amb_cistern_02b_zone", "targetname");
	
	if(IsDefined(amb_cistern_02b_zone_var))
	{
		amb_cistern_02b_zone_var playloopsound("amb_cistern_02b");
	}
	
	amb_cistern_01c_zone_var = getent("amb_cistern_01c_zone", "targetname");

	if(IsDefined(amb_cistern_01c_zone_var))
	{
		amb_cistern_01c_zone_var playloopsound("amb_cistern_01c");
	}	

	amb_cistern_02c_zone_var = getent("amb_cistern_02c_zone", "targetname");
	
	if(IsDefined(amb_cistern_02c_zone_var))
	{
		amb_cistern_02c_zone_var playloopsound("amb_cistern_02c");
	}	
	
	cistern_drips_c_zone_var = getent("cistern_drips_c_zone", "targetname");
	
	if(IsDefined(cistern_drips_c_zone_var))
	{
		cistern_drips_c_zone_var playloopsound("cistern_drips_c");
	}
	
	tunnel_water_lapping_zone_var = getent("tunnel_water_lapping_zone", "targetname");
	
	if(IsDefined(tunnel_water_lapping_zone_var))
	{
		tunnel_water_lapping_zone_var playloopsound("tunnel_water_lapping");
	}
	
	water_flow_soft_zone_var = getent("water_flow_soft_zone", "targetname");
	
	if(IsDefined(water_flow_soft_zone_var))
	{
		water_flow_soft_zone_var playloopsound("water_flow_soft");
	}	
	
	water_flow_soft_2_zone_var = getent("water_flow_soft_2_zone", "targetname");
	
	if(IsDefined(water_flow_soft_2_zone_var))
	{
		water_flow_soft_2_zone_var playloopsound("water_flow_soft_2");
	}	
}

play_stone_column_fall()
{
	scaf_var = GetEnt("cistern_scaf_01","targetname");
	gate_var = GetEnt("gate_main01","targetname");
	crash_org = spawn("script_origin", gate_var getorigin());
	scaf_var playsound("stone_column_fall");
	scaf_var playloopsound("sci_b_small_fire", 1.5);
	wait(1.5);
	crash_org playsound("stone_column_crash_01");
}	

play_car_alarm()
{
	car_alarm_org = spawn("script_origin", (686, -957, 246));
	car_alarm_org playloopsound("car_alarm_exit", 3.0);
}	
	