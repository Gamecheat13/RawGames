
#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;


main()
{
	




 

 





            declareAmbientPackage( "outside_pkg" );       

                        addAmbientElement( "outside_pkg", "pkg_birds", 6, 45, 500, 1000 );
			addAmbientElement( "outside_pkg", "pkg_wind", 6, 45, 500, 1000 );
			




            declareAmbientPackage( "inside_pkg" );       

                        
			
 


           




 




            declareAmbientRoom( "desert_main" );

                        setAmbientRoomTone( "desert_main", "bg_desert_main" );
                        
                        




            declareAmbientRoom( "garage_tunnel" );

                        setAmbientRoomTone( "garage_tunnel", "bg_ext_adj" );                        
                        
                         		setAmbientRoomReverb( "garage_tunnel", "hangar", 1, .4 );         






            declareAmbientRoom( "small_echoic_room" );

                        setAmbientRoomTone( "small_echoic_room", "bg_room" );                        
                        
                         		setAmbientRoomReverb( "small_echoic_room", "bathroom", 1, .5 );    
                         		




            declareAmbientRoom( "garage" );

                        setAmbientRoomTone( "garage", "bg_garage" );                    
                    
                         		setAmbientRoomReverb( "garage", "hangar", 1, .5 ); 
                         		




            declareAmbientRoom( "basic" );

                        setAmbientRoomTone( "basic", "bg_room" );                    
                    
                         		setAmbientRoomReverb( "basic", "plain", 1, .5 );      
                         		




            declareAmbientRoom( "dome_room" );

                        setAmbientRoomTone( "dome_room", "bg_room" );                    
                    
                         		setAmbientRoomReverb( "dome_room", "stonecorridor", 1, .6 );                             		
                         		
                         		




            declareAmbientRoom( "balcony" );

                        setAmbientRoomTone( "balcony", "bg_desert_main" );                    
                    
                         		setAmbientRoomReverb( "balcony", "bathroom", 1, .3 );    
                         		
                         		




            declareAmbientRoom( "safety" );

                        setAmbientRoomTone( "safety", "bg_room" );                    
                    
                         		setAmbientRoomReverb( "safety", "bathroom", 1, .3 );                          		
                         		
                         		
                         		







            setBaseAmbientPackageAndRoom( "outside_pkg", "desert_main" );

			signalAmbientPackageDeclarationComplete();
 












	loopSound("hard_drive", (818, 546, -168), 23.327);	
	loopSound("hard_drive", (1976, 2195, -168), 23.327);	
	loopSound("hard_drive", (1952, 2317, -168) , 23.327);		
	loopSound("hard_drive", (-202, 3095, -138), 23.327);		
	loopSound("hard_drive", (-115, 3221, -138), 23.327);		
	loopSound("hard_drive", (-1284, 1723, -83), 23.327);		
	loopSound("hard_drive", (-1098, 1586, -82), 23.327);		
	loopSound("hard_drive", (2351, 6671, 298), 23.327);		
	loopSound("hard_drive", (-631, 1442, -169), 23.327);		
	
	


	loopSound("printer", (750, 478, -137), 2.694);	
	loopSound("printer", (1970, 1933, -137), 2.694);	
	loopSound("printer_noisy", (158, 3201, -107) , 15.263);		
	loopSound("printer", (-1287, 1418, -51), 2.694);		
	loopSound("printer", (-821, 1372, -139), 2.694);




	
	
	
	
	

	


	loopSound("coffee_maker", (2180, 1920, -134), 23.253);	
	loopSound("coffee_maker", (-1885, 2302, 68), 23.253);	



	loopSound("soda_machine", (16, 2818, -107), 1.385);




	




	loopSound("radio_static", (-1958, 2109, 65), 17.663);	
	
	


	loopSound("fridge", (-1910, 2215, 52), 2.428);	




	loopSound("big_vent", (-1395, 2614, 79), 28.786);		





	loopSound("big_machine", (1598, 568, -158), 7.082);	
	

	
	



	loopSound("barge_machine", (1655, 595, -148), 21.082);


	loopSound("barge_machine", (1645, 482, -100), 2.827);
	loopSound("barge_machine", (1548, 475, -102), 2.827);
	
	
		










	
	
	
	array_thread(GetEntArray("water_cooler_damage_trigger", "targetname"), ::water_cooler_loop);
	array_thread(GetEntArray("water_cooler_damage_trigger", "targetname"), ::water_cooler_damage);
	
	array_thread(GetEntArray("fence_trigger", "targetname"), ::fence);        


	level thread fire_alarm_play();
	
	level thread soda_machine_locker_play();	
	
}

 


 



 











water_cooler_loop()
{

	self playloopsound ("water_cooler");

}	

	
water_cooler_damage()
{

	self waittill ("trigger");
	
	self stoploopsound();	
}
	



fence()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("fence_bump");
				
				level notify("noise_trigger_fence");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
		}
		

	
}


fire_alarm_play()
{
	fire_alarm_trigger_var = GetEnt("fire_alarm_trigger", "targetname");
	fire_alarm_org_var = GetEnt("fire_alarm_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(fire_alarm_trigger_var) && IsDefined(fire_alarm_org_var) )
	{
		while (1)
		{
			fire_alarm_trigger_var waittill ("trigger");
			fire_alarm_org_var playloopsound ("fire_alarm_1");
		}
	}
	
}


soda_machine_locker_play()
{
	soda_machine_locker_org_var = GetEnt("soda_machine_locker_org", "targetname");
	
	if ( IsDefined(soda_machine_locker_org_var) )
	{
		level waittill ("vending_machine");
		
		soda_machine_locker_org_var playloopsound ("soda_machine");
	}
}
