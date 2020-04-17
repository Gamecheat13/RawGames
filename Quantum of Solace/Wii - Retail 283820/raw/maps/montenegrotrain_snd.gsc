

#include maps\_utility;

#include common_scripts\ambientpackage;

#include maps\_fx;

 

 

main()

{









 






 

            declareAmbientPackage( "train_ext_pkg" );            

 

 






 

            declareAmbientPackage( "train_ext_low_pkg" );            


  






 

            declareAmbientPackage( "train_ext_low_2_pkg" );            


  






 

            declareAmbientPackage( "train_passenger_int_pkg" );            

 






 

            declareAmbientPackage( "train_passenger_int_2_pkg" ); 
            
            






 

            declareAmbientPackage( "train_baggage_int_pkg" );            







 

            declareAmbientPackage( "train_baggage_int_2_pkg" );           
            






 

            declareAmbientPackage( "train_container_car_int_pkg" );            


   





 

            declareAmbientPackage( "freight_train_ext_pkg" );     
            







 

            declareAmbientPackage( "freight_train_int_pkg" );            
                       







 

            declareAmbientPackage( "train_tunnel_pkg" );            
                       






 

            declareAmbientPackage( "train_tunnel_low_2_pkg" );            
 
 

 

           







 

 







 

            declareAmbientRoom( "train_ext" );
 

                        setAmbientRoomTone( "train_ext", "amb_bg_train_ext", 0.3, 0.5 );
 	             	setAmbientRoomReverb( "train_ext", "forest", 1, 0.3 );

                        






 

            declareAmbientRoom( "train_ext_low" );

 

                        setAmbientRoomTone( "train_ext_low", "amb_bg_train_ext_low", 0.5, 0.5 );
	             	setAmbientRoomReverb( "train_ext_low", "forest", 1, 0.3 );








 

            declareAmbientRoom( "train_ext_low_2" );

 

                        setAmbientRoomTone( "train_ext_low_2", "amb_bg_train_ext_low_2", 0.3, 0.5 );
	             	setAmbientRoomReverb( "train_ext_low_2", "forest", 1, 0.3 );


                          


 

 

 

             declareAmbientRoom( "train_passenger_int" );

                         setAmbientRoomTone( "train_passenger_int", "amb_bg_train_passenger_int", 0.3, 0.3  );
                     	 setAmbientRoomReverb( "train_passenger_int", "room", 1, 0.4 );

                         


 

 

 

             declareAmbientRoom( "train_passenger_int_2" );

                         setAmbientRoomTone( "train_passenger_int_2", "amb_bg_train_passenger_int_2", 0.3, 0.6  );
                     	 setAmbientRoomReverb( "train_passenger_int_2", "room", 1, 0.4 );




 

 

 

             declareAmbientRoom( "train_baggage_int" );

                         setAmbientRoomTone( "train_baggage_int", "amb_bg_train_baggage_int", 0.3, 0.3  );
                     	 setAmbientRoomReverb( "train_baggage_int", "room", 1, 0.4 );

 


 

 

 

             declareAmbientRoom( "train_baggage_int_2" );

                         setAmbientRoomTone( "train_baggage_int_2", "amb_bg_train_baggage_int_2", 0.3, 0.3  );
                     	 setAmbientRoomReverb( "train_baggage_int_2", "room", 1, 0.4 );
                     	 
 

 

 

 

             declareAmbientRoom( "train_container_car_int" );

                         setAmbientRoomTone( "train_container_car_int", "amb_bg_container_car", 0.3, 0.3 );
                      	 setAmbientRoomReverb( "train_container_car_int", "sewerpipe", 1, 0.3 );

                         


 

 

 

             declareAmbientRoom( "freight_train_ext" );

                         setAmbientRoomTone( "freight_train_ext", "amb_bg_freight_train_ext", 0.3, 0.5  );
                     	 setAmbientRoomReverb( "freight_train_ext", "forest", 1, 0.3 );

 

 

 

 

             declareAmbientRoom( "freight_train_int" );

                         setAmbientRoomTone( "freight_train_int", "amb_bg_freight_train_int", 0.3, 0.3  );
                     	 setAmbientRoomReverb( "freight_train_int", "hallway", 1, 0.3 );

 

 

 

 

             declareAmbientRoom( "train_tunnel" );

                         setAmbientRoomTone( "train_tunnel", "amb_bg_train_tunnel", 0.3, 0.3  );
                     	 setAmbientRoomReverb( "train_tunnel", "hangar", 1, 0.6 );

 

 

 

 

             declareAmbientRoom( "train_tunnel_low_2" );

                         setAmbientRoomTone( "train_tunnel_low_2", "amb_bg_train_tunnel_low_2", 0.3, 0.3  );
                     	 setAmbientRoomReverb( "train_tunnel_low_2", "hangar", 1, 0.3 );
                        
                        



 



 



 

            setBaseAmbientPackageAndRoom( "train_passenger_int_pkg", "train_passenger_int" );

 

                                    signalAmbientPackageDeclarationComplete();

 

 

 


 



 



	
	loopSound("Train_Track_3d_low_ext", (-123, -8819, 138), 9.685);
	loopSound("utility_room_buzz", (-36, -8837, 139), 8.983);
	loopSound("squeaky_rattle", (-69, -8820, 141), 8.154);
	
	
	loopSound("utility_room_buzz_3", (-51, 5569, 147), 8.983);
	loopSound("Train_Track_3d_low_ext", (-142, 5599, 142), 9.685);
	loopSound("squeaky_rattle", (-79, 5580, 141), 8.154);
	
	
	loopSound("flo_light_hum", (13, -9407, 181), 5.099);
	loopSound("vibrating_rattle", (-72, -9167, 140), 5.461);
	
	
	loopsound("plate_rattle_01", (65, -5934, 130), 30.528);
	
	
	loopsound("plate_rattle_02", (63, 5062, 124), 30.528);
	
	
	loopsound("utility_room_buzz_2", (67, -408, 147), 8.983);
	loopsound("utility_room_buzz_2", (-67, 797, 147), 8.983);
	loopsound("chain_link_rattle", (16, 648, 147), 12.528);
	
	
	loopsound("utility_room_buzz_2", (68, 1190, 147), 8.983);
	loopsound("utility_room_buzz_2", (-67, 2396, 147), 8.983);
	
	
	
	loopsound("utility_room_buzz_2", (67, 2788, 147), 8.983);
	loopsound("c02_tank_rattle_2", (-44, 3031, 119), 10.364);
	
	
	loopsound("utility_room_buzz_2", (-69, 3996, 147), 8.983);
	
	
	 



 



 



 

 

            

            

            signalAmbientPackageDeclarationComplete();
 	    
		
  	    
  	    
		
	    
	    level thread play_misc_walla();
  	    level thread play_rattle_loops_01();
  	    level thread play_rattle_loops_02();
  	    level thread stop_rattle_loops();
  	    level thread start_freight_train_loops();
  	    level thread oncoming_train_thread();


}

 


 



 



setup_zone_emitters()
{
	
	
	zone_emitter = spawn("zone_emitter", (10,0,0));
	zone_emitter.targetname = "passenger_walla_1_zone";
	coords = [];
	coord_structs = getstructarray("passenger_walla_1_node", "targetname");
	
	if (isdefined(coord_structs))
	{
		for (j = 0; j < coord_structs.size; j++)
		{
			coords[j] = coord_structs[j].origin;
		}
	}	

	ents = [];
	zone_emitter setupzoneemitter( 6, coords, ents );
	
	wait(2.0);
	
	zone_emitter = spawn("zone_emitter", (0,0,0));
	zone_emitter.targetname = "container_car_rattle_by_mz_zone";
	coords = [];
	ents = [];
	ents = getentarray("container_car_rattle_by_mz_node", "targetname");
	
	zone_emitter setupzoneemitter( 4, coords, ents );

	
	zone_emitter = spawn("zone_emitter", (0,0,0));
	zone_emitter.targetname = "freight_wood_metal_rattle_by_mz_zone";
	coords = [];
	ents = [];
	ents = getentarray("freight_wood_metal_rattle_by_mz_node", "targetname");
	
	zone_emitter setupzoneemitter( 3, coords, ents );
	
	wait(2.0);
	
	zone_emitter = spawn("zone_emitter", (0,0,0));
	zone_emitter.targetname = "rain_metal_ext_b_zone";
	coords = [];
	coord_structs = getstructarray("rain_metal_ext_b_node", "targetname");
	
	if (isdefined(coord_structs))
	{
		for (j = 0; j < coord_structs.size; j++)
		{
			coords[j] = coord_structs[j].origin;
		}
	}	

	ents = [];
	zone_emitter setupzoneemitter( 6, coords, ents );
	
	wait(2.0);
	
	zone_emitter = spawn("zone_emitter", (10,0,0));
	zone_emitter.targetname = "rain_metal_ext_2b_zone";
	coords = [];
	coord_structs = getstructarray("rain_metal_ext_2b_node", "targetname");
	
	if (isdefined(coord_structs))
	{
		for (j = 0; j < coord_structs.size; j++)
		{
			coords[j] = coord_structs[j].origin;
		}
	}	

	ents = [];
	zone_emitter setupzoneemitter( 6, coords, ents );
	
	wait(2.0);
	
	zone_emitter = spawn("zone_emitter", (0,0,0));
	zone_emitter.targetname = "rain_wind_stbd_b_zone";
	coords = [];
	coord_structs = getstructarray("rain_wind_stbd_b_node", "targetname");
	
	if (isdefined(coord_structs))
	{
		for (j = 0; j < coord_structs.size; j++)
		{
			coords[j] = coord_structs[j].origin;
		}
	}	

	ents = [];
	zone_emitter setupzoneemitter( 6, coords, ents );
	
	wait(2.0);
	
	zone_emitter = spawn("zone_emitter", (10,0,0));
	zone_emitter.targetname = "rain_wind_port_b_zone";
	coords = [];
	coord_structs = getstructarray("rain_wind_port_b_node", "targetname");
	
	if (isdefined(coord_structs))
	{
		for (j = 0; j < coord_structs.size; j++)
		{
			coords[j] = coord_structs[j].origin;
		}
	}	

	ents = [];
	zone_emitter setupzoneemitter( 6, coords, ents );
	
}

play_misc_walla()
{

	misc_walla_trig_var = getent( "misc_walla_trig" , "targetname" );
	misc_walla_org_var = getent( "misc_walla_org" , "targetname" );
	level endon ("train_stop");	
	while (1)
	{
           
	    misc_walla_trig_var waittill ("trigger");
	    misc_walla_org_var playsound("mr_b");
	    
	    wait(0.2);	  
	}
}	

crate_fall_sounds()
{
	freight_crate_fall_org_var = Getent("freight_crate_fall_org", "targetname");
	freight_crate_fall_org_var playsound("freight_crate_fall");
	
	wait(0.4);
	
	freight_crate_fall_org_var playloopsound("freight_metal_drag", 0.3);
}	

start_passenger_walla()
{
	wait(1.0);
	
	passenger_walla_1_var = GetEnt("passenger_walla_1_zone", "targetname");
	
	passenger_walla_1_var playloopsound("passenger_walla_01", 1.0);
}	



start_rain_sounds()
{
	wait(0.6);
	
	rain_metal_ext_var = GetEnt("rain_metal_ext_zone", "targetname");
	rain_metal_ext_2_var = GetEnt("rain_metal_ext_2_zone", "targetname");
	rain_metal_ext_a_var = GetEnt("rain_metal_ext_a_zone", "targetname");
	rain_metal_ext_2a_var = GetEnt("rain_metal_ext_2a_zone", "targetname");
	rain_metal_ext_b_var = GetEnt("rain_metal_ext_b_zone", "targetname");
	rain_metal_ext_2b_var = GetEnt("rain_metal_ext_2b_zone", "targetname");
	rain_wind_port_var = GetEnt("rain_wind_port_zone", "targetname");
	rain_wind_stbd_var = GetEnt("rain_wind_stbd_zone", "targetname");
	rain_wind_port_a_var = GetEnt("rain_wind_port_a_zone", "targetname");
	rain_wind_stbd_a_var = GetEnt("rain_wind_stbd_a_zone", "targetname");
	rain_wind_port_b_var = GetEnt("rain_wind_port_b_zone", "targetname");
	rain_wind_stbd_b_var = GetEnt("rain_wind_stbd_b_zone", "targetname");
	
	
	rain_metal_int_1_var = GetEnt("rain_metal_int_1_zone", "targetname");
	rain_metal_int_2_var = GetEnt("rain_metal_int_2_zone", "targetname");
	rain_window_int_var = GetEnt("rain_window_int_zone", "targetname");
	
	rain_metal_ext_var playloopsound("rain_metal_01", 0.7);
	rain_metal_ext_2_var playloopsound("rain_metal_02", 0.7);
	rain_metal_ext_a_var playloopsound("rain_metal_01a", 0.7);
	rain_metal_ext_2a_var playloopsound("rain_metal_02a", 0.7);
	rain_metal_ext_b_var playloopsound("rain_metal_01a", 0.7);
	rain_metal_ext_2b_var playloopsound("rain_metal_02a", 0.7);
	rain_wind_port_var playloopsound("rain_wind_port", 0.7);
	rain_wind_stbd_var playloopsound("rain_wind_stbd", 0.7);
	rain_wind_port_a_var playloopsound("rain_wind_port_a", 0.7);
	rain_wind_stbd_a_var playloopsound("rain_wind_stbd_a", 0.7);
	rain_wind_port_b_var playloopsound("rain_wind_port_a", 0.7);
	rain_wind_stbd_b_var playloopsound("rain_wind_stbd_a", 0.7);
	
	
	rain_metal_int_1_var playloopsound("rain_metal_int_01", 0.7);
	rain_metal_int_2_var playloopsound("rain_metal_int_02", 0.7);
	rain_window_int_var playloopsound("rain_window_int", 0.7);
}	


start_freight_train_loops()
{
	freight_engine_var = GetEnt("freight_engine", "targetname");
	
	freight_train_ext_trig_var	= GetEnt("freight_train_ext_trig", "script_noteworthy");
	container_car_1_trig_var  = GetEnt("container_car_1_trig", "script_noteworthy");
	container_car_2_trig_var  = GetEnt("container_car_2_trig", "script_noteworthy");
	freight_boxcar_1_trig_var = GetEnt("freight_boxcar_1_trig", "script_noteworthy");
	freight_boxcar_2_trig_var = GetEnt("freight_boxcar_2_trig", "script_noteworthy");
	freight_boxcar_org_01_var[1] = GetEnt("freight_boxcar_org_01", "targetname");
	freight_wind_org_var[1]  = GetEnt("freight_wind_org_01", "targetname");
	freight_wind_org_var[2]  = GetEnt("freight_wind_org_02", "targetname");
	freight_metal_org_var[1]  = GetEnt("freight_metal_org_01", "targetname");
	freight_metal_org_var[2]  = GetEnt("freight_metal_org_02", "targetname");
	freight_metal_org_var[3]  = GetEnt("freight_metal_org_03", "targetname");
	freight_metal_cyl_org_var[1]  = GetEnt("freight_metal_cyl_org_01", "targetname");
	freight_wheels_org_var[1] = GetEnt("freight_wheels_org_01", "targetname");
	freight_wheels_org_var[2] = GetEnt("freight_wheels_org_02", "targetname");
	freight_wheels_org_var[3] = GetEnt("freight_wheels_org_03", "targetname");
	freight_wheels_org_var[4] = GetEnt("freight_wheels_org_04", "targetname");
	freight_wheels_org_var[5] = GetEnt("freight_wheels_org_05", "targetname");
	freight_wheels_org_var[6] = GetEnt("freight_wheels_org_06", "targetname");
	freight_wheels_org_var[11] = GetEnt("freight_wheels_org_06a", "targetname");
	freight_wheels_org_var[7] = GetEnt("freight_wheels_org_07", "targetname");
	freight_wheels_org_var[8] = GetEnt("freight_wheels_org_08", "targetname");
	freight_wheels_org_var[9] = GetEnt("freight_wheels_org_09", "targetname");
	freight_wheels_org_var[10] = GetEnt("freight_wheels_org_10", "targetname");
	
	freight_train_ext_trig_var	enablelinkto();
	container_car_1_trig_var	enablelinkto();
	container_car_2_trig_var	enablelinkto();
	freight_boxcar_1_trig_var	enablelinkto();
	freight_boxcar_2_trig_var	enablelinkto();
	freight_train_ext_trig_var	linkto (freight_engine_var);
	container_car_1_trig_var	linkto (freight_engine_var);
	container_car_2_trig_var	linkto (freight_engine_var);
	freight_boxcar_1_trig_var 	linkto (freight_engine_var);
	freight_boxcar_2_trig_var 	linkto (freight_engine_var);
	freight_boxcar_org_01_var[1] 	linkto (freight_engine_var);
	freight_wind_org_var[1]		linkto (freight_engine_var);
	freight_wind_org_var[2]		linkto (freight_engine_var);
	freight_metal_org_var[1]	linkto (freight_engine_var);
	freight_metal_org_var[2]	linkto (freight_engine_var);
	freight_metal_org_var[3]	linkto (freight_engine_var);
	freight_metal_cyl_org_var[1]	linkto (freight_engine_var);
	freight_wheels_org_var[1]	linkto (freight_engine_var);
	freight_wheels_org_var[2]	linkto (freight_engine_var);
	freight_wheels_org_var[3]	linkto (freight_engine_var);
	freight_wheels_org_var[4]	linkto (freight_engine_var);
	freight_wheels_org_var[5]	linkto (freight_engine_var);
	freight_wheels_org_var[6]	linkto (freight_engine_var);
	freight_wheels_org_var[7]	linkto (freight_engine_var);
	freight_wheels_org_var[8]	linkto (freight_engine_var);
	freight_wheels_org_var[9]	linkto (freight_engine_var);
	freight_wheels_org_var[10]	linkto (freight_engine_var);
	freight_wheels_org_var[11]	linkto (freight_engine_var);
	
	
	shake_debris_org_var[1] = GetEnt("metal_debris_org_01", "targetname");
	shake_debris_org_var[2] = GetEnt("metal_debris_org_02", "targetname");
	shake_metal_org_var[2] = GetEnt("freight_metal_org_02", "targetname");
	shake_crate_org_var[1] = GetEnt("freight_crate_org_01", "targetname");
	shake_crate_org_var[2] = GetEnt("freight_crate_org_02", "targetname");
	shake_debris_org_var[1] 	linkto (freight_engine_var);
	shake_debris_org_var[2] 	linkto (freight_engine_var);
	shake_metal_org_var[2] 		linkto (freight_engine_var);
	shake_crate_org_var[1] 		linkto (freight_engine_var);
	shake_crate_org_var[2] 		linkto (freight_engine_var);
	
	
	freight_mz_node_var[1] = GetEnt("freight_mz_node_01", "script_noteworthy");
	freight_mz_node_var[2] = GetEnt("freight_mz_node_02", "script_noteworthy");
	freight_mz_node_var[3] = GetEnt("freight_mz_node_03", "script_noteworthy");
	freight_mz_node_var[4] = GetEnt("freight_mz_node_04", "script_noteworthy");
	freight_mz_node_var[5] = GetEnt("freight_mz_node_05", "script_noteworthy");
	freight_mz_node_var[6] = GetEnt("freight_mz_node_06", "script_noteworthy");
	freight_mz_node_var[7] = GetEnt("freight_mz_node_07", "script_noteworthy");
	freight_mz_node_var[1]  	linkto (freight_engine_var);
	freight_mz_node_var[2]  	linkto (freight_engine_var);
	freight_mz_node_var[3]  	linkto (freight_engine_var);
	freight_mz_node_var[4]  	linkto (freight_engine_var);
	freight_mz_node_var[5]  	linkto (freight_engine_var);
	freight_mz_node_var[6]  	linkto (freight_engine_var);
	freight_mz_node_var[7]  	linkto (freight_engine_var);
	
	
	freight_coupling_1_org_var[1] = GetEnt("freight_coupling_1_org", "targetname");
	freight_coupling_2_org_var[2] = GetEnt("freight_coupling_2_org", "targetname");
	freight_coupling_1_org_var[1]  	linkto (freight_engine_var);
	freight_coupling_2_org_var[2]  	linkto (freight_engine_var);
	
	
	freight_crate_fall_org_var[1] = Getent("freight_crate_fall_org", "targetname");
	freight_crate_fall_org_var[1]  	linkto (freight_engine_var);
	
	
	freight_boxcar_org_01_var[1] playloopsound("boxcar_rattle");
	freight_wind_org_var[1]  playloopsound ("Freight_Train_Track_3d_Small_Ext");
	freight_wind_org_var[2]  playloopsound ("Freight_Train_Track_3d_Small_Ext");
	freight_metal_org_var[1]  playloopsound ("container_car_rattle_02");
	freight_metal_org_var[2]  playloopsound ("freight_metal_rattle_02b");
	shake_debris_org_var[1]	playloopsound ("container_car_rattle");
	freight_metal_org_var[3]  playloopsound ("freight_metal_rattle_02");
	freight_metal_cyl_org_var[1]  playloopsound ("c02_tank_rattle");
	freight_wheels_org_var[1] playloopsound ("freight_train_01a");
	freight_wheels_org_var[2] playloopsound ("freight_train_01a");
	freight_wheels_org_var[3] playloopsound ("freight_train_02a");
	freight_wheels_org_var[4] playloopsound ("freight_train_01a");
	freight_wheels_org_var[5] playloopsound ("freight_train_01a");
	freight_wheels_org_var[6] playloopsound ("freight_train_03a");
	freight_wheels_org_var[7] playloopsound ("freight_train_01a");
	freight_wheels_org_var[8] playloopsound ("freight_train_01a");
	freight_wheels_org_var[9] playloopsound ("freight_train_01a");
	freight_wheels_org_var[10] playloopsound ("freight_train_01a");
	
	
}	

play_rattle_loops_01()
{
	rattles_loop_org_var[1] = GetEnt("powerline_rattle_loop_org_01", "targetname");
	rattles_loop_org_var[2] = GetEnt("powerline_rattle_loop_org_02", "targetname");
	rattles_loop_org_var[3] = GetEnt("powerline_rattle_loop_org_03", "targetname");
	rattles_loop_org_var[4] = GetEnt("powerline_rattle_loop_org_04", "targetname");
	rattles_loop_org_var[5] = GetEnt("powerline_rattle_loop_org_05", "targetname");
	rattles_loop_org_var[6] = GetEnt("powerline_rattle_loop_org_06", "targetname");
	rattles_loop_org_var[7] = GetEnt("powerline_rattle_loop_org_07", "targetname");
	
	ext_rattle_loops_01_var = GetEnt("ext_rattle_loops_01", "targetname");
	
	level endon ("train_stop");
	while (1)
	{
		ext_rattle_loops_01_var waittill ("trigger");
		rattles_loop_org_var[1] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[2] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[3] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[4] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[5] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[6] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[7] playloopsound ("powerline_rattle_loop", 0.3);
	}
	
}	

play_rattle_loops_02()
{
	rattles_loop_org_var[1] = GetEnt("powerline_rattle_loop_org_01", "targetname");
	rattles_loop_org_var[2] = GetEnt("powerline_rattle_loop_org_02", "targetname");
	rattles_loop_org_var[3] = GetEnt("powerline_rattle_loop_org_03", "targetname");
	rattles_loop_org_var[4] = GetEnt("powerline_rattle_loop_org_04", "targetname");
	rattles_loop_org_var[5] = GetEnt("powerline_rattle_loop_org_05", "targetname");
	rattles_loop_org_var[6] = GetEnt("powerline_rattle_loop_org_06", "targetname");
	rattles_loop_org_var[7] = GetEnt("powerline_rattle_loop_org_07", "targetname");
	
	ext_rattle_loops_02_var = GetEnt("ext_rattle_loops_02", "targetname");
	
	level endon ("train_stop");
	while (1)
	{
		ext_rattle_loops_02_var waittill ("trigger");
		rattles_loop_org_var[1] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[2] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[3] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[4] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[5] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[6] playloopsound ("powerline_rattle_loop", 0.3);
		rattles_loop_org_var[7] playloopsound ("powerline_rattle_loop", 0.3);
	}
	
}	
		
stop_rattle_loops()
{
	rattles_loop_org_var[1] = GetEnt("powerline_rattle_loop_org_01", "targetname");
	rattles_loop_org_var[2] = GetEnt("powerline_rattle_loop_org_02", "targetname");
	rattles_loop_org_var[3] = GetEnt("powerline_rattle_loop_org_03", "targetname");
	rattles_loop_org_var[4] = GetEnt("powerline_rattle_loop_org_04", "targetname");
	rattles_loop_org_var[5] = GetEnt("powerline_rattle_loop_org_05", "targetname");
	rattles_loop_org_var[6] = GetEnt("powerline_rattle_loop_org_06", "targetname");
	rattles_loop_org_var[7] = GetEnt("powerline_rattle_loop_org_07", "targetname");
	
	ext_rattle_loops_off_var = GetEnt("ext_rattle_loops_off", "targetname");
	
	level endon ("train_stop");
	while (1)
	{
		ext_rattle_loops_off_var waittill ("trigger");
		rattles_loop_org_var[1] stoploopsound (0.3);
		rattles_loop_org_var[2] stoploopsound (0.3);
		rattles_loop_org_var[3] stoploopsound (0.3);
		rattles_loop_org_var[4] stoploopsound (0.3);
		rattles_loop_org_var[5] stoploopsound (0.3);
		rattles_loop_org_var[6] stoploopsound (0.3);
		rattles_loop_org_var[7] stoploopsound (0.3);
	}
	
}	




play_shake_ext(shake_amount)
{
	rattles_org_var[1] = GetEnt("powerline_rattle_org_01", "targetname");
	rattles_org_var[2] = GetEnt("powerline_rattle_org_02", "targetname");
	rattles_org_var[3] = GetEnt("powerline_rattle_org_03", "targetname");
	rattles_org_var[4] = GetEnt("powerline_rattle_org_04", "targetname");
	rattles_org_var[5] = GetEnt("powerline_rattle_org_05", "targetname");
	rattles_org_var[6] = GetEnt("powerline_rattle_org_06", "targetname");
	rattles_org_var[7] = GetEnt("powerline_rattle_org_07", "targetname");
	metal_debris_org_var[1] = GetEnt("metal_debris_org_01", "targetname");
	metal_debris_org_var[2] = GetEnt("metal_debris_org_02", "targetname");
	freight_metal_org_var[2] = GetEnt("freight_metal_org_02", "targetname");
	freight_crate_org_var[1] = GetEnt("freight_crate_org_01", "targetname");
	freight_crate_org_var[2] = GetEnt("freight_crate_org_02", "targetname");

	
	
	if (shake_amount > 0.1)
	{
		level.player playlocalsound ("train_ext_1shot");
		rattles_org_var[1] playsound ("powerline_rattle");
		rattles_org_var[2] playsound ("powerline_rattle");
		rattles_org_var[3] playsound ("powerline_rattle");
		rattles_org_var[4] playsound ("powerline_rattle");
		rattles_org_var[5] playsound ("powerline_rattle");
		rattles_org_var[6] playsound ("powerline_rattle");
		rattles_org_var[7] playsound ("powerline_rattle");
		metal_debris_org_var[2] playsound ("train_metal_debris");
		freight_metal_org_var[2] playsound ("freight_metal_bounce");
		freight_crate_org_var[1] playsound ("crate_rattle");
		freight_crate_org_var[2] playsound ("crate_rattle");
	}
	
	
	
		
	
		
}

play_shake_int(shake_amount)
{
	martini_org_var = GetEnt("martini_org", "targetname");
	
	if (shake_amount > 0.035)
	{
		if (shake_amount > 0.05)
		{
			level.player playlocalsound ("train_int_1shot");
		}
		
		else
		{
			level.player playlocalsound ("train_int_1shot_soft");
		}	
			
	}
	
	if (shake_Amount > 0.029)
	{
		martini_org_var playsound("martini_glass");
	}	
	
	
	
}


oncoming_train_thread()
{

	oncoming_engine 	= GetEnt( "passing_engine", "targetname" );
	engine_trigger_var	= GetEnt( "oncoming_approach_trigger", "targetname" );
	engine_org_var		= GetEnt( "oncoming_approach_org", "targetname" );
	
	train_cars_org_var[0]	= GetEnt( "oncoming_car01_org", "targetname" );
	train_cars_org_var[1]	= GetEnt( "oncoming_car02_org", "targetname" );
	train_cars_org_var[2]	= GetEnt( "oncoming_car03_org", "targetname" );
	train_cars_org_var[3]	= GetEnt( "oncoming_car04_org", "targetname" );
	train_cars_org_var[4]	= GetEnt( "oncoming_car05_org", "targetname" );
	train_cars_org_var[5]	= GetEnt( "oncoming_car06_org", "targetname" );
	train_cars_org_var[6]	= GetEnt( "oncoming_car07_org", "targetname" );
	train_cars_org_var[7]	= GetEnt( "oncoming_car08_org", "targetname" );
	train_cars_org_var[8]	= GetEnt( "oncoming_car09_org", "targetname" );
	

	
	engine_trigger_var 	enablelinkto();
	engine_trigger_var 	linkto (oncoming_engine);
	engine_org_var 		linkto (oncoming_engine);
	
	train_cars_org_var[0] 	linkto (oncoming_engine);
	train_cars_org_var[1] 	linkto (oncoming_engine);
	train_cars_org_var[2] 	linkto (oncoming_engine);
	train_cars_org_var[3] 	linkto (oncoming_engine);
	train_cars_org_var[4] 	linkto (oncoming_engine);
	train_cars_org_var[5] 	linkto (oncoming_engine);
	train_cars_org_var[6] 	linkto (oncoming_engine);
	train_cars_org_var[7] 	linkto (oncoming_engine);
	train_cars_org_var[8] 	linkto (oncoming_engine);
	

	
	level thread one_off_engine_org();
}	

stop_train_sounds()
{

	triggerstop = getent("stop_oncoming_sounds_trigger", "targetname");
	triggerstop waittill ("trigger");
	level notify("oncoming_train_stop");

}

one_off_engine_org()
{
	
	freight_train_ext_trig_var2	= GetEnt("freight_train_ext_trig", "script_noteworthy");
	
	one_off_eng_trigger	 = getent( "oncoming_approach_trigger", "targetname" );
	one_off_eng_org		 = getent( "oncoming_approach_org", "targetname" );
	
	one_off_car_org[0]	 = getent( "oncoming_car01_org", "targetname" );
	one_off_car_org[1]	 = getent( "oncoming_car02_org", "targetname" );
	one_off_car_org[2]	 = getent( "oncoming_car03_org", "targetname" );
	one_off_car_org[3]	 = getent( "oncoming_car04_org", "targetname" );
	one_off_car_org[4]	 = getent( "oncoming_car05_org", "targetname" );
	one_off_car_org[5]	 = getent( "oncoming_car06_org", "targetname" );
	one_off_car_org[6]	 = getent( "oncoming_car07_org", "targetname" );
	one_off_car_org[7]	 = getent( "oncoming_car08_org", "targetname" );
	one_off_car_org[8]	 = getent( "oncoming_car09_org", "targetname" );
	
	
	
	
	
		      
	level endon ("oncoming_train_stop");
	level thread stop_train_sounds();
	while (1)
	{
           
	    one_off_eng_trigger	 waittill ("trigger");
	    one_off_eng_org	 playloopsound("oncoming_train_approach");
	    one_off_car_org[0]	 playloopsound( "oncoming_train_wheel_clatter_02" );
	    one_off_car_org[1]	 playloopsound( "oncoming_train_wheel_clatter" );
	    one_off_car_org[2]	 playloopsound( "oncoming_train_wheel_clatter_02" );
	    one_off_car_org[3]	 playloopsound( "oncoming_train_wheel_clatter" );
	    one_off_car_org[4]	 playloopsound( "oncoming_train_wheel_clatter_02" );
	    one_off_car_org[5]	 playloopsound( "oncoming_train_wheel_clatter" );
	    one_off_car_org[6]	 playloopsound( "oncoming_train_wheel_clatter_02" );
	    one_off_car_org[7]	 playloopsound( "oncoming_train_wheel_clatter" );
	    one_off_car_org[8]	 playloopsound( "oncoming_train_wheel_clatter_02" );
	    
	    if( level.player istouching( freight_train_ext_trig_var2 ) )
	    {
	    	level.player playsound( "oncoming_train_rumble_by" );
			
	    	
	    	
	    }    	
	    
		
	    wait(7.0);
	    one_off_eng_org	 stoploopsound(4.0);
	    one_off_car_org[0]	 stoploopsound(2.0);
	    one_off_car_org[1]	 stoploopsound(2.0);
	    one_off_car_org[2]	 stoploopsound(2.0);
	    one_off_car_org[3]	 stoploopsound(2.0);
	    one_off_car_org[4]	 stoploopsound(2.0);
	    one_off_car_org[5]	 stoploopsound(2.0);
	    one_off_car_org[6]	 stoploopsound(2.0);
	    one_off_car_org[7]	 stoploopsound(2.0);
	    one_off_car_org[8]	 stoploopsound(2.0);
	    wait(6.5);
	    
	}
	    

}




audio_scenery_linkage(background_scene)
{

	
	poll_trigger_a[0]	= GetEnt( "poll_00_a",			"targetname" );
	poll_trigger_a[1]	= GetEnt( "poll_01_a",			"targetname" );
	poll_trigger_a[2]	= GetEnt( "poll_02_a",			"targetname" );
	poll_trigger_a[3]	= GetEnt( "poll_03_a",			"targetname" );
	poll_trigger_a[4]	= GetEnt( "poll_04_a",			"targetname" );
	poll_trigger_a[5]	= GetEnt( "poll_05_a",			"targetname" );
	poll_trigger_a[6]	= GetEnt( "poll_06_a",			"targetname" );
	poll_trigger_a[7]	= GetEnt( "poll_07_a",			"targetname" );
	poll_trigger_a[8]	= GetEnt( "poll_08_a",			"targetname" );
	poll_trigger_a[9]	= GetEnt( "poll_09_a",			"targetname" );
	poll_trigger_a[10]	= GetEnt( "poll_10_a",			"targetname" );
	
	poll_trigger_b[0]	= GetEnt( "poll_00_b",			"targetname" );
	poll_trigger_b[1]	= GetEnt( "poll_01_b",			"targetname" );
	poll_trigger_b[2]	= GetEnt( "poll_02_b",			"targetname" );
	poll_trigger_b[3]	= GetEnt( "poll_03_b",			"targetname" );
	poll_trigger_b[4]	= GetEnt( "poll_04_b",			"targetname" );
	poll_trigger_b[5]	= GetEnt( "poll_05_b",			"targetname" );
	poll_trigger_b[6]	= GetEnt( "poll_06_b",			"targetname" );
	poll_trigger_b[7]	= GetEnt( "poll_07_b",			"targetname" );
	poll_trigger_b[8]	= GetEnt( "poll_08_b",			"targetname" );
	poll_trigger_b[9]	= GetEnt( "poll_09_b",			"targetname" );
	poll_trigger_b[10]	= GetEnt( "poll_10_b",			"targetname" );
	
	poll_trigger_org_a_L[0]		= GetEnt( "poll_org_00_a_L",			"targetname" );
	poll_trigger_org_a_L[1]		= GetEnt( "poll_org_01_a_L",			"targetname" );
	poll_trigger_org_a_L[2]		= GetEnt( "poll_org_02_a_L",			"targetname" );
	poll_trigger_org_a_L[3]		= GetEnt( "poll_org_03_a_L",			"targetname" );
	poll_trigger_org_a_L[4]		= GetEnt( "poll_org_04_a_L",			"targetname" );
	poll_trigger_org_a_L[5]		= GetEnt( "poll_org_05_a_L",			"targetname" );
	poll_trigger_org_a_L[6]		= GetEnt( "poll_org_06_a_L",			"targetname" );
	poll_trigger_org_a_L[7]		= GetEnt( "poll_org_07_a_L",			"targetname" );
	poll_trigger_org_a_L[8]		= GetEnt( "poll_org_08_a_L",			"targetname" );
	poll_trigger_org_a_L[9]		= GetEnt( "poll_org_09_a_L",			"targetname" );
	poll_trigger_org_a_L[10]	= GetEnt( "poll_org_10_a_L",			"targetname" );
	
	poll_trigger_org_a_R[0]		= GetEnt( "poll_org_00_a_R",			"targetname" );
	poll_trigger_org_a_R[1]		= GetEnt( "poll_org_01_a_R",			"targetname" );
	poll_trigger_org_a_R[2]		= GetEnt( "poll_org_02_a_R",			"targetname" );
	poll_trigger_org_a_R[3]		= GetEnt( "poll_org_03_a_R",			"targetname" );
	poll_trigger_org_a_R[4]		= GetEnt( "poll_org_04_a_R",			"targetname" );
	poll_trigger_org_a_R[5]		= GetEnt( "poll_org_05_a_R",			"targetname" );
	poll_trigger_org_a_R[6]		= GetEnt( "poll_org_06_a_R",			"targetname" );
	poll_trigger_org_a_R[7]		= GetEnt( "poll_org_07_a_R",			"targetname" );
	poll_trigger_org_a_R[8]		= GetEnt( "poll_org_08_a_R",			"targetname" );
	poll_trigger_org_a_R[9]		= GetEnt( "poll_org_09_a_R",			"targetname" );
	poll_trigger_org_a_R[10]	= GetEnt( "poll_org_10_a_R",			"targetname" );
	
	poll_trigger_org_b_L[0]		= GetEnt( "poll_org_00_b_L",			"targetname" );
	poll_trigger_org_b_L[1]		= GetEnt( "poll_org_01_b_L",			"targetname" );
	poll_trigger_org_b_L[2]		= GetEnt( "poll_org_02_b_L",			"targetname" );
	poll_trigger_org_b_L[3]		= GetEnt( "poll_org_03_b_L",			"targetname" );
	poll_trigger_org_b_L[4]		= GetEnt( "poll_org_04_b_L",			"targetname" );
	poll_trigger_org_b_L[5]		= GetEnt( "poll_org_05_b_L",			"targetname" );
	poll_trigger_org_b_L[6]		= GetEnt( "poll_org_06_b_L",			"targetname" );
	poll_trigger_org_b_L[7]		= GetEnt( "poll_org_07_b_L",			"targetname" );
	poll_trigger_org_b_L[8]		= GetEnt( "poll_org_08_b_L",			"targetname" );
	poll_trigger_org_b_L[9]		= GetEnt( "poll_org_09_b_L",			"targetname" );
	poll_trigger_org_b_L[10]	= GetEnt( "poll_org_10_b_L",			"targetname" );
	
	poll_trigger_org_b_R[0]		= GetEnt( "poll_org_00_b_R",			"targetname" );
	poll_trigger_org_b_R[1]		= GetEnt( "poll_org_01_b_R",			"targetname" );
	poll_trigger_org_b_R[2]		= GetEnt( "poll_org_02_b_R",			"targetname" );
	poll_trigger_org_b_R[3]		= GetEnt( "poll_org_03_b_R",			"targetname" );
	poll_trigger_org_b_R[4]		= GetEnt( "poll_org_04_b_R",			"targetname" );
	poll_trigger_org_b_R[5]		= GetEnt( "poll_org_05_b_R",			"targetname" );
	poll_trigger_org_b_R[6]		= GetEnt( "poll_org_06_b_R",			"targetname" );
	poll_trigger_org_b_R[7]		= GetEnt( "poll_org_07_b_R",			"targetname" );
	poll_trigger_org_b_R[8]		= GetEnt( "poll_org_08_b_R",			"targetname" );
	poll_trigger_org_b_R[9]		= GetEnt( "poll_org_09_b_R",			"targetname" );
	poll_trigger_org_b_R[10]	= GetEnt( "poll_org_10_b_R",			"targetname" );
	
	
	
	poll_trigger_org_a_L[0] 	linkto (background_scene[0]);
	poll_trigger_org_a_L[1] 	linkto (background_scene[1]);
	poll_trigger_org_a_L[2] 	linkto (background_scene[2]);
	poll_trigger_org_a_L[3] 	linkto (background_scene[3]);
	poll_trigger_org_a_L[4] 	linkto (background_scene[4]);
	poll_trigger_org_a_L[5] 	linkto (background_scene[5]);
	poll_trigger_org_a_L[6] 	linkto (background_scene[6]);
	poll_trigger_org_a_L[7] 	linkto (background_scene[7]);
	poll_trigger_org_a_L[8] 	linkto (background_scene[8]);
	poll_trigger_org_a_L[9] 	linkto (background_scene[9]);
	poll_trigger_org_a_L[10] 	linkto (background_scene[10]);
	
	poll_trigger_org_a_R[0] 	linkto (background_scene[0]);
	poll_trigger_org_a_R[1] 	linkto (background_scene[1]);
	poll_trigger_org_a_R[2] 	linkto (background_scene[2]);
	poll_trigger_org_a_R[3] 	linkto (background_scene[3]);
	poll_trigger_org_a_R[4] 	linkto (background_scene[4]);
	poll_trigger_org_a_R[5] 	linkto (background_scene[5]);
	poll_trigger_org_a_R[6] 	linkto (background_scene[6]);
	poll_trigger_org_a_R[7] 	linkto (background_scene[7]);
	poll_trigger_org_a_R[8] 	linkto (background_scene[8]);
	poll_trigger_org_a_R[9] 	linkto (background_scene[9]);
	poll_trigger_org_a_R[10] 	linkto (background_scene[10]);
	
	poll_trigger_org_b_L[0] 	linkto (background_scene[0]);
	poll_trigger_org_b_L[1] 	linkto (background_scene[1]);
	poll_trigger_org_b_L[2] 	linkto (background_scene[2]);
	poll_trigger_org_b_L[3] 	linkto (background_scene[3]);
	poll_trigger_org_b_L[4] 	linkto (background_scene[4]);
	poll_trigger_org_b_L[5] 	linkto (background_scene[5]);
	poll_trigger_org_b_L[6] 	linkto (background_scene[6]);
	poll_trigger_org_b_L[7] 	linkto (background_scene[7]);
	poll_trigger_org_b_L[8] 	linkto (background_scene[8]);
	poll_trigger_org_b_L[9] 	linkto (background_scene[9]);
	poll_trigger_org_b_L[10] 	linkto (background_scene[10]);
	
	poll_trigger_org_b_R[0] 	linkto (background_scene[0]);	
	poll_trigger_org_b_R[0] 	linkto (background_scene[0]);
	poll_trigger_org_b_R[1] 	linkto (background_scene[1]);
	poll_trigger_org_b_R[2] 	linkto (background_scene[2]);
	poll_trigger_org_b_R[3] 	linkto (background_scene[3]);
	poll_trigger_org_b_R[4] 	linkto (background_scene[4]);
	poll_trigger_org_b_R[5] 	linkto (background_scene[5]);
	poll_trigger_org_b_R[6] 	linkto (background_scene[6]);
	poll_trigger_org_b_R[7] 	linkto (background_scene[7]);
	poll_trigger_org_b_R[8] 	linkto (background_scene[8]);
	poll_trigger_org_b_R[9] 	linkto (background_scene[9]);
	poll_trigger_org_b_R[10] 	linkto (background_scene[10]);
	
	poll_trigger_a[0] enablelinkto();
	poll_trigger_a[0]	linkto (background_scene[0]);
	poll_trigger_a[1] enablelinkto();
	poll_trigger_a[1]	linkto (background_scene[1]);
	poll_trigger_a[2] enablelinkto();
	poll_trigger_a[2]	linkto (background_scene[2]);
	poll_trigger_a[3] enablelinkto();
	poll_trigger_a[3]	linkto (background_scene[3]);
	poll_trigger_a[4] enablelinkto();
	poll_trigger_a[4]	linkto (background_scene[4]);
	poll_trigger_a[5] enablelinkto();
	poll_trigger_a[5]	linkto (background_scene[5]);
	poll_trigger_a[6] enablelinkto();
	poll_trigger_a[6]	linkto (background_scene[6]);
	poll_trigger_a[7] enablelinkto();
	poll_trigger_a[7]	linkto (background_scene[7]);
	poll_trigger_a[8] enablelinkto();
	poll_trigger_a[8]	linkto (background_scene[8]);
	poll_trigger_a[9] enablelinkto();
	poll_trigger_a[9]	linkto (background_scene[9]);
	poll_trigger_a[10] enablelinkto();
	poll_trigger_a[10]	linkto (background_scene[10]);
	
	poll_trigger_b[0] enablelinkto();
	poll_trigger_b[0] 	linkto (background_scene[0]);
	poll_trigger_b[1] enablelinkto();
	poll_trigger_b[1]	linkto (background_scene[1]);
	poll_trigger_b[2] enablelinkto();
	poll_trigger_b[2]	linkto (background_scene[2]);
	poll_trigger_b[3] enablelinkto();
	poll_trigger_b[3]	linkto (background_scene[3]);
	poll_trigger_b[4] enablelinkto();
	poll_trigger_b[4]	linkto (background_scene[4]);
	poll_trigger_b[5] enablelinkto();
	poll_trigger_b[5]	linkto (background_scene[5]);
	poll_trigger_b[6] enablelinkto();
	poll_trigger_b[6]	linkto (background_scene[6]);
	poll_trigger_b[7] enablelinkto();
	poll_trigger_b[7]	linkto (background_scene[7]);
	poll_trigger_b[8] enablelinkto();
	poll_trigger_b[8]	linkto (background_scene[8]);
	poll_trigger_b[9] enablelinkto();
	poll_trigger_b[9]	linkto (background_scene[9]);
	poll_trigger_b[10] enablelinkto();
	poll_trigger_b[10]	linkto (background_scene[10]);
	
	level thread one_off_a0();
	level thread one_off_b0();
	level thread one_off_a1();
	level thread one_off_b1();
	level thread one_off_a2();
	level thread one_off_b2();
	level thread one_off_a3();
	level thread one_off_b3();
	level thread one_off_a4();
	level thread one_off_b4();
	level thread one_off_a5();
	level thread one_off_b5();
	level thread one_off_a6();
	level thread one_off_b6();
	level thread one_off_a7();
	level thread one_off_b7();
	level thread one_off_a8();
	level thread one_off_b8();
	level thread one_off_a9();
	level thread one_off_b9();
	level thread one_off_a10();
	level thread one_off_b10();

}


audio_tunnel_linkage()
{
	train_tunnel_trig_var[0]	= GetEnt( "train_tunnel_00_trig",			"script_noteworthy" );
	train_tunnel_trig_var[1]	= GetEnt( "train_tunnel_01_trig",			"script_noteworthy" );
	train_tunnel_trig_var[2]	= GetEnt( "train_tunnel_02_trig",			"script_noteworthy" );
	train_tunnel_trig_var[3]	= GetEnt( "train_tunnel_03_trig",			"script_noteworthy" );
	train_tunnel_trig_var[4]	= GetEnt( "train_tunnel_04_trig",			"script_noteworthy" );
	train_tunnel_trig_var[5]	= GetEnt( "train_tunnel_05_trig",			"script_noteworthy" );
	train_tunnel_trig_var[6]	= GetEnt( "train_tunnel_06_trig",			"script_noteworthy" );
	train_tunnel_trig_var[7]	= GetEnt( "train_tunnel_07_trig",			"script_noteworthy" );

	train_tunnel_trig_var[0] enablelinkto();	
	train_tunnel_trig_var[1] enablelinkto();	
	train_tunnel_trig_var[2] enablelinkto();	
	train_tunnel_trig_var[3] enablelinkto();	
	train_tunnel_trig_var[4] enablelinkto();	
	train_tunnel_trig_var[5] enablelinkto();	
	train_tunnel_trig_var[6] enablelinkto();	
	train_tunnel_trig_var[7] enablelinkto();	

	train_tunnel_trig_var[0] linkto (level.background_tunnel[0]);
	train_tunnel_trig_var[1] linkto (level.background_tunnel[1]);	
	train_tunnel_trig_var[2] linkto (level.background_tunnel[2]);	
	train_tunnel_trig_var[3] linkto (level.background_tunnel[3]);	
	train_tunnel_trig_var[4] linkto (level.background_tunnel[4]);	
	train_tunnel_trig_var[5] linkto (level.background_tunnel[5]);	
	train_tunnel_trig_var[6] linkto (level.background_tunnel[6]);	
	train_tunnel_trig_var[7] linkto (level.background_tunnel[7]);

}

one_off_a0()
{

	one_off_trigger_a[0] = getent( "poll_00_a" , "targetname" );
	one_off_origin_a_L[0]  = getent( "poll_org_00_a_L" , "targetname" );
	one_off_origin_a_R[0]  = getent( "poll_org_00_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[0] waittill ("trigger");
	    one_off_origin_a_L[0] playsound("poll_whoosh_left");
	    one_off_origin_a_R[0] playsound("poll_whoosh_right");            

	    wait(1);	  
	}
	    

}
one_off_b0()
{
	one_off_trigger_b[0] = getent( "poll_00_b" , "targetname" );
	one_off_origin_b_L[0]  = getent( "poll_org_00_b_L" , "targetname" );
	one_off_origin_b_R[0]  = getent( "poll_org_00_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[0] waittill ("trigger");
		one_off_origin_b_L[0] playsound("poll_whoosh_left");
		one_off_origin_b_R[0] playsound("poll_whoosh_right");

	        wait(1);	  
	}
}

one_off_a1()
{

	one_off_trigger_a[1] = getent( "poll_01_a" , "targetname" );
	one_off_origin_a_L[1]  = getent( "poll_org_01_a_L" , "targetname" );
	one_off_origin_a_R[1]  = getent( "poll_org_01_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[1] waittill ("trigger");
	    one_off_origin_a_L[1] playsound("poll_whoosh_left");
	    one_off_origin_a_R[1] playsound("poll_whoosh_right");            

	    wait(1);	  

	}
	    

}
one_off_b1()
{
	one_off_trigger_b[1] = getent( "poll_01_b" , "targetname" );
	one_off_origin_b_L[1]  = getent( "poll_org_01_b_L" , "targetname" );
	one_off_origin_b_R[1]  = getent( "poll_org_01_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[1] waittill ("trigger");
		one_off_origin_b_L[1] playsound("poll_whoosh_left");
		one_off_origin_b_R[1] playsound("poll_whoosh_right");

	        wait(1);	  
	}
}

one_off_a2()
{

	one_off_trigger_a[2] = getent( "poll_02_a" , "targetname" );
	one_off_origin_a_L[2]  = getent( "poll_org_02_a_L" , "targetname" );
	one_off_origin_a_R[2]  = getent( "poll_org_02_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[2] waittill ("trigger");
	    one_off_origin_a_L[2] playsound("poll_whoosh_left");
	    one_off_origin_a_R[2] playsound("poll_whoosh_right");            

	    wait(1);	  

	}
	    

}
one_off_b2()
{
	one_off_trigger_b[2] = getent( "poll_02_b" , "targetname" );
	one_off_origin_b_L[2]  = getent( "poll_org_02_b_L" , "targetname" );
	one_off_origin_b_R[2]  = getent( "poll_org_02_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[2] waittill ("trigger");
		one_off_origin_b_L[2] playsound("poll_whoosh_left");
		one_off_origin_b_R[2] playsound("poll_whoosh_right");

		wait(1);	  

	}
}

one_off_a3()
{

	one_off_trigger_a[3] = getent( "poll_03_a" , "targetname" );
	one_off_origin_a_L[3]  = getent( "poll_org_03_a_L" , "targetname" );
	one_off_origin_a_R[3]  = getent( "poll_org_03_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[3] waittill ("trigger");
	    one_off_origin_a_L[3] playsound("poll_whoosh_left");
	    one_off_origin_a_R[3] playsound("poll_whoosh_right");            

	    wait(1);	  

	}
	    

}
one_off_b3()
{
	one_off_trigger_b[3] = getent( "poll_03_b" , "targetname" );
	one_off_origin_b_L[3]  = getent( "poll_org_03_b_L" , "targetname" );
	one_off_origin_b_R[3]  = getent( "poll_org_03_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[3] waittill ("trigger");
		one_off_origin_b_L[3] playsound("poll_whoosh_left");
		one_off_origin_b_R[3] playsound("poll_whoosh_right");

	    	wait(1);	  

	}
}

one_off_a4()
{

	one_off_trigger_a[4] = getent( "poll_04_a" , "targetname" );
	one_off_origin_a_L[4]  = getent( "poll_org_04_a_L" , "targetname" );
	one_off_origin_a_R[4]  = getent( "poll_org_04_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[4] waittill ("trigger");
	    one_off_origin_a_L[4] playsound("poll_whoosh_left");
	    one_off_origin_a_R[4] playsound("poll_whoosh_right");            

	    wait(1);	  
  
	}
	    

}
one_off_b4()
{
	one_off_trigger_b[4] = getent( "poll_04_b" , "targetname" );
	one_off_origin_b_L[4]  = getent( "poll_org_04_b_L" , "targetname" );
	one_off_origin_b_R[4]  = getent( "poll_org_04_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[4] waittill ("trigger");
		one_off_origin_b_L[4] playsound("poll_whoosh_left");
		one_off_origin_b_R[4] playsound("poll_whoosh_right");

		wait(1);	  
	}
}

one_off_a5()
{

	one_off_trigger_a[5] = getent( "poll_05_a" , "targetname" );
	one_off_origin_a_L[5]  = getent( "poll_org_05_a_L" , "targetname" );
	one_off_origin_a_R[5]  = getent( "poll_org_05_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[5] waittill ("trigger");
	    one_off_origin_a_L[5] playsound("poll_whoosh_left");
	    one_off_origin_a_R[5] playsound("poll_whoosh_right");            

	    wait(1);	  
	  
	}
	    

}
one_off_b5()
{
	one_off_trigger_b[5] = getent( "poll_05_b" , "targetname" );
	one_off_origin_b_L[5]  = getent( "poll_org_05_b_L" , "targetname" );
	one_off_origin_b_R[5]  = getent( "poll_org_05_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[5] waittill ("trigger");
		one_off_origin_b_L[5] playsound("poll_whoosh_left");
		one_off_origin_b_R[5] playsound("poll_whoosh_right");

		wait(1);	  
	}
}

one_off_a6()
{

	one_off_trigger_a[6] = getent( "poll_06_a" , "targetname" );
	one_off_origin_a_L[6]  = getent( "poll_org_06_a_L" , "targetname" );
	one_off_origin_a_R[6]  = getent( "poll_org_06_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[6] waittill ("trigger");
	    one_off_origin_a_L[6] playsound("poll_whoosh_left");
	    one_off_origin_a_R[6] playsound("poll_whoosh_right");            

	    wait(1);	  
	  
	}
	    

}
one_off_b6()
{
	one_off_trigger_b[6] = getent( "poll_06_b" , "targetname" );
	one_off_origin_b_L[6]  = getent( "poll_org_06_b_L" , "targetname" );
	one_off_origin_b_R[6]  = getent( "poll_org_06_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[6] waittill ("trigger");
		one_off_origin_b_L[6] playsound("poll_whoosh_left");
		one_off_origin_b_R[6] playsound("poll_whoosh_right");

	        wait(1);	  
	}
}

one_off_a7()
{

	one_off_trigger_a[7] = getent( "poll_07_a" , "targetname" );
	one_off_origin_a_L[7]  = getent( "poll_org_07_a_L" , "targetname" );
	one_off_origin_a_R[7]  = getent( "poll_org_07_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[7] waittill ("trigger");
	    one_off_origin_a_L[7] playsound("poll_whoosh_left");
	    one_off_origin_a_R[7] playsound("poll_whoosh_right");            

	    wait(1);	  
	  
	}
	    

}
one_off_b7()
{
	one_off_trigger_b[7] = getent( "poll_07_b" , "targetname" );
	one_off_origin_b_L[7]  = getent( "poll_org_07_b_L" , "targetname" );
	one_off_origin_b_R[7]  = getent( "poll_org_07_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[7] waittill ("trigger");
		one_off_origin_b_L[7] playsound("poll_whoosh_left");
		one_off_origin_b_R[7] playsound("poll_whoosh_right");

		wait(1);	  
		
	}
}

one_off_a8()
{

	one_off_trigger_a[8] = getent( "poll_08_a" , "targetname" );
	one_off_origin_a_L[8]  = getent( "poll_org_08_a_L" , "targetname" );
	one_off_origin_a_R[8]  = getent( "poll_org_08_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[8] waittill ("trigger");
	    one_off_origin_a_L[8] playsound("poll_whoosh_left");
	    one_off_origin_a_R[8] playsound("poll_whoosh_right");            

	    wait(1);	  
	  
	}
	    

}
one_off_b8()
{
	one_off_trigger_b[8] = getent( "poll_08_b" , "targetname" );
	one_off_origin_b_L[8]  = getent( "poll_org_08_b_L" , "targetname" );
	one_off_origin_b_R[8]  = getent( "poll_org_08_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[8] waittill ("trigger");
		one_off_origin_b_L[8] playsound("poll_whoosh_left");
		one_off_origin_b_R[8] playsound("poll_whoosh_right");

		wait(1);	  

	}
}

one_off_a9()
{

	one_off_trigger_a[9] = getent( "poll_09_a" , "targetname" );
	one_off_origin_a_L[9]  = getent( "poll_org_09_a_L" , "targetname" );
	one_off_origin_a_R[9]  = getent( "poll_org_09_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[9] waittill ("trigger");
	    one_off_origin_a_L[9] playsound("poll_whoosh_left");
	    one_off_origin_a_R[9] playsound("poll_whoosh_right");            

	    wait(1);	  
	  
	}
	    

}
one_off_b9()
{
	one_off_trigger_b[9] = getent( "poll_09_b" , "targetname" );
	one_off_origin_b_L[9]  = getent( "poll_org_09_b_L" , "targetname" );
	one_off_origin_b_R[9]  = getent( "poll_org_09_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[9] waittill ("trigger");
		one_off_origin_b_L[9] playsound("poll_whoosh_left");
		one_off_origin_b_R[9] playsound("poll_whoosh_right");

		wait(1);	  

	}
}

one_off_a10()
{

	one_off_trigger_a[10] = getent( "poll_10_a" , "targetname" );
	one_off_origin_a_L[10]  = getent( "poll_org_10_a_L" , "targetname" );
	one_off_origin_a_R[10]  = getent( "poll_org_10_a_R" , "targetname" );	
	level endon ("train_stop");	
	while (1)
	{
           
	    one_off_trigger_a[10] waittill ("trigger");
	    one_off_origin_a_L[10] playsound("poll_whoosh_left");
	    one_off_origin_a_R[10] playsound("poll_whoosh_right");            

	    wait(1);	  
	  
	}
	    

}
one_off_b10()
{
	one_off_trigger_b[10] = getent( "poll_10_b" , "targetname" );
	one_off_origin_b_L[10]  = getent( "poll_org_10_b_L" , "targetname" );
	one_off_origin_b_R[10]  = getent( "poll_org_10_b_R" , "targetname" );
	level endon ("train_stop");
	while (1)
	{

		one_off_trigger_b[10] waittill ("trigger");
		one_off_origin_b_L[10] playsound("poll_whoosh_left");
		one_off_origin_b_R[10] playsound("poll_whoosh_right");

	   	wait(1);	  
		
	}
}