
#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;


main()
{


//*****Zone Emitter******

level.charger_zone_emitter = getent( "charger_zone_emitter", "targetname" ); 
	
	if ( IsDefined(level.dump_rain_zone_emitter) )
	{
		level.charger_zone_emitter playloopsound("charger_ok");
	}

//************************************************************************************************
//                                              Ambient Packages
//************************************************************************************************

 

 

//***************
//Outside Package
//***************   

            declareAmbientPackage( "outside_pkg" );       

                        addAmbientElement( "outside_pkg", "pkg_birds", 6, 30, 500, 1000 );
			addAmbientElement( "outside_pkg", "pkg_wind", 6, 45, 500, 1000 );
			
//***************
//Interior Package
//***************   

            declareAmbientPackage( "inside_pkg" );       

                        //addAmbientElement( "inside_pkg", "pkg_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "inside_pkg", "pkg_wind", 6, 45, 500, 1000 );			
 


           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 
//***************
//Desert Main
//***************

            declareAmbientRoom( "desert_main" );

                        setAmbientRoomTone( "desert_main", "bg_desert_main" );
                        
                        
//****************
//Garage Tunnel
//****************

            declareAmbientRoom( "garage_tunnel" );

                        setAmbientRoomTone( "garage_tunnel", "bg_ext_adj" );                        
                        
                         		setAmbientRoomReverb( "garage_tunnel", "hangar", 1, .2 );         


//**************************************
//Small Echoic Room
//**************************************

            declareAmbientRoom( "small_echoic_room" );

                        setAmbientRoomTone( "small_echoic_room", "bg_room" );                        
                        
                         		setAmbientRoomReverb( "small_echoic_room", "bathroom", 1, .3 );    
                         		
//***************
//Parking Garage
//***************

            declareAmbientRoom( "garage" );

                        setAmbientRoomTone( "garage", "bg_garage" );                    
                    
                         		setAmbientRoomReverb( "garage", "hangar", 1, .3 ); 
                         		
//***************
//Basic Eco Hotel Rooms
//***************

            declareAmbientRoom( "basic" );

                        setAmbientRoomTone( "basic", "bg_room" );                    
                    
                         		setAmbientRoomReverb( "basic", "plain", 1, .3 );      
                         		
//***************
//Dome Room
//***************

            declareAmbientRoom( "dome_room" );

                        setAmbientRoomTone( "dome_room", "bg_room" );                    
                    
                         		setAmbientRoomReverb( "dome_room", "stonecorridor", 1, .3 );                             		
                         		
                         		
//***************
//Balconies
//***************

            declareAmbientRoom( "balcony" );

                        setAmbientRoomTone( "balcony", "bg_desert_main" );                    
                    
                         		setAmbientRoomReverb( "balcony", "bathroom", 1, .3 );    
                         		
                         		
//***************
//Safety (covers the entire hotel interior but with lower priority - avoids accidental outdoor sound while indoors)
//***************

            declareAmbientRoom( "safety" );

                        setAmbientRoomTone( "safety", "bg_room" );                    
                    
                         		setAmbientRoomReverb( "safety", "bathroom", 1, .3 );                          		
                         		
                         		
                         		

//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            setBaseAmbientPackageAndRoom( "outside_pkg", "desert_main" );

			signalAmbientPackageDeclarationComplete();
 



//*************************************************************************************************

//                                              STATIC LOOPS

//*************************************************************************************************


//Computers

	loopSound("hard_drive", (818, 546, -168), 23.327);	
	loopSound("hard_drive", (1976, 2195, -168), 23.327);	
	loopSound("hard_drive", (1952, 2317, -168) , 23.327);		
	loopSound("hard_drive", (-202, 3095, -138), 23.327);		
	loopSound("hard_drive", (-115, 3221, -138), 23.327);		
	loopSound("hard_drive", (-1284, 1723, -83), 23.327);		
	loopSound("hard_drive", (-1098, 1586, -82), 23.327);		
	loopSound("hard_drive", (2351, 6671, 298), 23.327);		
	loopSound("hard_drive", (-631, 1442, -169), 23.327);		
	
	
//Printers

	loopSound("printer", (750, 478, -137), 2.694);	
	loopSound("printer", (1970, 1933, -137), 2.694);	
	loopSound("printer_noisy", (158, 3201, -107) , 15.263);		
	loopSound("printer", (-1287, 1418, -51), 2.694);		
	loopSound("printer", (-821, 1372, -139), 2.694);


//Water Coolers - now destructable

	//loopSound("water_cooler", (916, 457, -155), 2.422);	
	//loopSound("water_cooler", (1813, 2261, -151), 2.422);	
	//loopSound("water_cooler", (-41, 3043, -121) , 2.422);	
	//loopSound("water_cooler", (-1194, 1795, -69), 2.422);	
	//loopSound("water_cooler", (-690, 1527, -153), 2.422);

	
//Coffee Makers

	loopSound("coffee_maker", (2180, 1920, -134), 23.253);	
	//loopSound("coffee_maker", (-1885, 2302, 68), 23.253);	

//Soda Machines

	loopSound("soda_machine", (16, 2818, -107), 1.385);


//Copy Machine

	//loopSound("copier", (-559, 1332, -161), 31.758);


//Radio

	//loopSound("radio_static", (-1958, 2109, 65), 17.663);	
	
	
//Drinking Fountain

	loopSound("fridge", (-1910, 2215, 52), 2.428);	


//Big Vent

	loopSound("big_vent", (-1395, 2614, 79), 28.786);		


//MACHINE ROOM

//Big Machines
	loopSound("big_machine", (1598, 568, -158), 7.082);	
	
//Electric Wall Box
	//loopSound("electric_box", (1717, 546, -112), 4.853);
	//loopSound("electric_box", (1507, 660, -111), 4.853);	


//Barge Style Console
	loopSound("barge_machine", (1655, 595, -148), 21.082);

//Pump Machines
	loopSound("barge_machine", (1645, 482, -100), 2.827);
	loopSound("barge_machine", (1548, 475, -102), 2.827);
	
	
		



//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************


	//array_thread(GetEntArray("charger_damage_trigger", "targetname"), ::charger_loop);
	//array_thread(GetEntArray("charger_damage_trigger", "targetname"), ::charger_damage);
	
	array_thread(GetEntArray("water_cooler_damage_trigger", "targetname"), ::water_cooler_loop);
	array_thread(GetEntArray("water_cooler_damage_trigger", "targetname"), ::water_cooler_damage);
	
	array_thread(GetEntArray("fence_trigger", "targetname"), ::fence);        


	level thread fire_alarm_play();
	
	level thread soda_machine_locker_play();	
	
	level thread coffee_maker_locker_play();
	
}

 
//*************************************************************************************************

 

//                                              Functions

 

//*************************************************************************************************


//************ chargers ************

/*charger_loop()
{

	self playloopsound ("charger");

}	

	
charger_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: stop charge");
	self stoploopsound();	
}*/


//************ water_coolers ************

water_cooler_loop()
{

	self playloopsound ("water_cooler");

}	

	
water_cooler_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: water_cooler thru");
	self stoploopsound();	
}
	

//************ fence ************

fence()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("fence_bump");
				//iprintlnbold ("SOUND: fence rustle");
				level notify("noise_trigger_fence");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
			else
			{
				//iprintlnbold("too soft!");
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
		//iprintlnbold("SOUND: soda_machine");
		soda_machine_locker_org_var playloopsound ("soda_machine");
	}
}


coffee_maker_locker_play()
{
	coffee_maker_locker_org_var = GetEnt("coffee_maker_locker_org", "targetname");
	
	if ( IsDefined(coffee_maker_locker_org_var) )
	{
		level waittill ("vending_machine");
		//iprintlnbold("SOUND: coffee_maker");
		coffee_maker_locker_org_var playloopsound ("coffee_maker");
	}
}
