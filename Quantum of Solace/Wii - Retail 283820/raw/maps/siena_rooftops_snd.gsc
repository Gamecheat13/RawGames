

#include maps\_utility;

#include common_scripts\ambientpackage;

#include maps\_fx;

 

 

main()

{








			
			
 
 
 
 
 
 
  
 
             declareAmbientPackage( "siena_ext_1_pkg" );            

   			
        
 
 
 
 
 
 
  
 
             declareAmbientPackage( "siena_int_1_pkg" );            

 
 
 
 
 
 
  
 
             declareAmbientPackage( "siena_int_2_pkg" );            

        







  	             	
  	             	
 
 
 
 
 
 
  
 
             declareAmbientRoom( "siena_ext_1" );
  
 
                        setAmbientRoomTone( "siena_ext_1", "amb_bg_siena_rooftops_ext", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "siena_ext_1", "parkinglot", 1, 0.6 );

  
  
  
  
  
  
   
  
              declareAmbientRoom( "siena_int_1" );
   
  
                         setAmbientRoomTone( "siena_int_1", "amb_bg_siena_rooftops_int", 0.3, 0.5 );
   	             	setAmbientRoomReverb( "siena_int_1", "room", 1, 0.5 );


  
  
  
  
  
  
   
  
              declareAmbientRoom( "siena_int_2" );
   
  
                         setAmbientRoomTone( "siena_int_2", "amb_bg_siena_rooftops_int", 0.3, 0.5 );
   	             	setAmbientRoomReverb( "siena_int_2", "stoneroom", 1, 0.5 );


             



 



 



 
            setBaseAmbientPackageAndRoom( "siena_ext_1_pkg", "siena_ext_1" );

 

                                    signalAmbientPackageDeclarationComplete();


 


 



 




	loopSound("water_splashing_close", (-516, -496, 179), 7.808);
	loopSound("water_splashing_far", (-516, -496, 179), 6.570);
	loopSound("water_spray_close", (-471, -406, 175), 8.929);
	
	
	 



 



 



 

 

            

            

            
 	    
  	    start_static_zone_emitters();
  	    
  	    play_car_alarm_entrance();
  	    
  	    play_sportscast_01();
  	    
  	    play_verdi_radio();
  	    
  	    level thread play_sportscast_02();
  	    
 	    level thread play_finale_cheer();
 	    
 	    level thread trigger_church_bells();
 	    
 	    level thread play_palio_chant_first();
    
 	    level thread play_palio_chant_roof_01();

	    level thread play_palio_chant_final();
	    
	    level thread play_random_1shots();

	    level thread play_land_hard_grunt();

}

 


 



 



start_static_zone_emitters()
{
	car_alarm_dist_a_zone_var = getent("car_alarm_dist_a_zone", "targetname");

	if(IsDefined(car_alarm_dist_a_zone_var))
	{
		car_alarm_dist_a_zone_var playloopsound("car_alarm_dist_01");
	}
	
	car_alarm_dist_b_zone_var = getent("car_alarm_dist_b_zone", "targetname");

	if(IsDefined(car_alarm_dist_b_zone_var))
	{
		car_alarm_dist_b_zone_var playloopsound("car_alarm_dist_03");
	}	

	palio_crowd_zone_var = getent("palio_crowd_zone", "targetname");

	if(IsDefined(palio_crowd_zone_var))
	{
		palio_crowd_zone_var playloopsound("palio_crowd_01");
	}
	
	siena_rooftops_city_zone_var = getent("siena_rooftops_city_zone", "targetname");

	if(IsDefined(siena_rooftops_city_zone_var))
	{
		siena_rooftops_city_zone_var playloopsound("siena_rooftops_city");
	}
}

play_car_alarm_entrance()
{
	car_alarm_entrance_org_var = getent("car_alarm_entrance_org", "targetname");
	
	if(IsDefined(car_alarm_entrance_org_var))
	{
		car_alarm_entrance_org_var playsound("car_alarm_entrance");
	}
	
}

play_sportscast_01()
{
	sportscast_01_org = spawn("script_origin", (-1819, -2061, 587));
	sportscast_01_org playloopsound("sportscast_01", 0.3);
}	

play_sportscast_02()
{
	sportscast_02_trig_var = GetEnt("sportscast_02_trig", "targetname");
	sportscast_02_org = spawn("script_origin", (-1819, -2061, 587));
	
	level endon ("insert_notify");
	
	
	
	
	if(IsDefined(sportscast_02_trig_var))
	{
		while (1)
		{
			sportscast_02_trig_var waittill ("trigger");
			wait(2.2);
			
			
			
			sportscast_02_org playloopsound ("sportscast_02");
			wait(0.01);
		}
	}	
}

play_finale_cheer()
{
	finale_cheer_trig_var = GetEnt("finale_cheer_trig", "targetname");
	
	level endon ("insert_notify");
	
	if(IsDefined(finale_cheer_trig_var))
	{
		while (1)
		{
			finale_cheer_trig_var waittill ("trigger");
			
			palio_crowd_zone_var2 = getent("palio_crowd_zone", "targetname");
	
			if(IsDefined(palio_crowd_zone_var2))
			{
				wait(3.5);
				palio_crowd_zone_var2 playsound("finale_cheer");
			}
			
			wait(0.01);
		}
	}	
}

play_door_slam_open()
{
	
	double_door_org = spawn("script_origin",(-4255, -3362, 593));
	double_door_org playsound("door_slam_open");
	wait(3.0);
	double_door_org delete();
}

play_door_rattle()
{
	
	wait(5.0);
	rattle_door_org = spawn("script_origin",(-4255, -3362, 593));
	rattle_door_org playsound("door_rattle");
	wait(4.0);
	rattle_door_org delete();
}

play_church_bells()
{
	church_bells_org = spawn("script_origin",(-6452, -2149, 843));
	church_bells_org playsound("church_bells");
	wait(50.0);
	church_bells_org delete();
}	

trigger_church_bells()
{
	church_bells_trig_var = GetEnt("church_bells_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(church_bells_trig_var))
	{
		while (1)
		{
			church_bells_trig_var waittill ("trigger");
			wait(2.2);
			play_church_bells();
			wait(0.01);
		}
	}	
}

play_palio_chant_roof_01()
{
	palio_chant_roof_01_trig_var = GetEnt("palio_chant_roof_01_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(palio_chant_roof_01_trig_var))
	{
		while (1)
		{
			palio_chant_roof_01_trig_var waittill ("trigger");
			
			palio_crowd_zone_var3 = getent("palio_crowd_zone", "targetname");
	
			if(IsDefined(palio_crowd_zone_var3))
			{
				palio_crowd_zone_var3 playsound("palio_chant_roof_01");
			}
			
			wait(0.01);
		}
	}	
}

play_palio_chant_first()
{
	palio_chant_first_trig_var = GetEnt("palio_chant_first_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(palio_chant_first_trig_var))
	{
		while (1)
		{
			palio_chant_first_trig_var waittill ("trigger");
			
			palio_crowd_zone_var4 = getent("palio_crowd_zone", "targetname");
	
			if(IsDefined(palio_crowd_zone_var4))
			{
				wait(4.5);
				palio_crowd_zone_var4 playsound("palio_chant_first");
			}
			
			wait(0.01);
		}
	}	
}

play_palio_chant_final()
{
	palio_chant_final_trig_var = GetEnt("palio_chant_final_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(palio_chant_final_trig_var))
	{
		while (1)
		{
			palio_chant_final_trig_var waittill ("trigger");
			
			palio_crowd_zone_var5 = getent("palio_crowd_zone", "targetname");
	
			if(IsDefined(palio_crowd_zone_var5))
			{
				wait(2.5);
				palio_crowd_zone_var5 playsound("palio_chant_final");
			}
			
			wait(0.01);
		}
	}	
}

play_verdi_radio()
{
	verdi_radio_org = spawn("script_origin",(-6584, -2511, 736));
	verdi_radio_org playloopsound("verdi_radio");
}

play_random_1shots()
{
	level endon ("insert_notify");
	while (1)
	{
		palio_crowd_zone_var6 = getent("palio_crowd_zone", "targetname");
		if(IsDefined(palio_crowd_zone_var6))
		{
			wait( RandomFloatRange( 17.5, 88.2 ) );
			palio_crowd_zone_var6 playsound("amb_palio_random");
		}
		
		wait(0.01);
	}
}

play_land_hard_grunt()
{
	land_hard_trig_var = GetEnt("land_hard_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(land_hard_trig_var))
	{
		while (1)
		{
			land_hard_trig_var waittill ("trigger");
			wait(0.15);
			level.player playsound("jump_hurt_one");
			
			
			wait(0.01);
		}
	}	
}

play_ledge_fall()
{
	ledge_var = GetEnt("collapse_ledge","targetname");

	
	if(IsDefined(ledge_var))
	{
		
		ledge_var playsound("ledge_fall");
		wait(1.4);
		ledge_crash_org = spawn("script_origin",(-6234, -2656, 311));
		ledge_crash_org playsound("ledge_crash");
		wait(7.0);
		ledge_crash_org delete();
	}
	
}