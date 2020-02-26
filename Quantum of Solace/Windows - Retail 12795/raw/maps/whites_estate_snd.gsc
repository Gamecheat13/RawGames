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
//whites_estate_ext_pkg
//***************   

            declareAmbientPackage( "whites_estate_ext_pkg" );    
          

           

//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 //***************
 //whites_estate_ext
 //***************
 
             declareAmbientRoom( "whites_estate_ext" );
 
                         setAmbientRoomTone( "whites_estate_ext", "amb_bg_whites_estate_ext" );
                         setAmbientRoomReverb( "whites_estate_ext", "city", 1, .1 );
                         
                         
 //***************
 //AMB_WhitesEstate_Cave_Corridor
 //***************
 
             declareAmbientRoom( "AMB_WhitesEstate_Cave_Corridor" );
 
                         setAmbientRoomTone( "AMB_WhitesEstate_Cave_Corridor", "AMB_WhitesEstate_Cave_Corridor", 1, .5 );                                           
			 setAmbientRoomReverb( "AMB_WhitesEstate_Cave_Corridor", "stoneroom", 1, .5 );

 //***************
 //AMB_WhitesEstate_House
 //***************
 
             declareAmbientRoom( "AMB_WhitesEstate_House" );
 
                         setAmbientRoomTone( "AMB_WhitesEstate_House", "AMB_WhitesEstate_House", 1, .2 );        


 //***************
 //amb_whitesestate_computer_room
 //***************
 
             declareAmbientRoom( "amb_whitesestate_computer_room" );
 
                         setAmbientRoomTone( "amb_whitesestate_computer_room", "amb_whitesestate_computer_room", 1, 2 );       
                         
  //***************
 //amb_whitesestate_boat_house
 //***************
 
             declareAmbientRoom( "amb_whitesestate_boat_house" );
 
                         setAmbientRoomTone( "amb_whitesestate_boat_house", "amb_whitesestate_boat_house", 1, 2 );  
                          setAmbientRoomReverb( "amb_whitesestate_boat_house", "stoneroom", 1, .5 );
                      


//************************************************************************************************
//                                              ACTIVATE DEFAULT AMBIENT SETTINGS
//************************************************************************************************

 
           setBaseAmbientPackageAndRoom( "whites_estate_ext_pkg", "whites_estate_ext" );

 

                                    signalAmbientPackageDeclarationComplete();



 

//*************************************************************************************************
//                                              Static Loops
//*************************************************************************************************

 	//fridge
	loopSound("whites_estate_refrigerator", (-155, -471, 73), 24.000);




//*************************************************************************************************
//                                              START SCRIPTS
//*************************************************************************************************

            
 	    
 	    
 	    array_thread(GetEntArray("sound_fountain_trigger", "targetname"), ::fountain);
 	    
 	    array_thread(GetEntArray("sound_frogs_trigger", "targetname"), ::frogs);
 	    
 	    array_thread(GetEntArray( "fxanim_seagull_circle", "targetname" ), ::seagull);
 	    
 	    array_thread(GetEntArray( "birds_1_zone", "targetname" ), ::birds_random);
 	    array_thread(GetEntArray( "birds_2_zone", "targetname" ), ::birds_random);
 	    array_thread(GetEntArray( "birds_3_zone", "targetname" ), ::birds_random);
 	    array_thread(GetEntArray( "birds_1_zone", "targetname" ), ::wind);
 	    array_thread(GetEntArray( "birds_2_zone", "targetname" ), ::wind);
 	    array_thread(GetEntArray( "birds_3_zone", "targetname" ), ::wind);
 	    
 	    array_thread(GetEntArray("sound_hedge_trigger", "targetname"), ::hedge);
 	    array_thread(GetEntArray("sound_hedge_trigger", "targetname"), ::crickets);
 	    array_thread(GetEntArray("sound_hedge_trigger", "targetname"), ::flies);
 	    
 	    array_thread(GetEntArray("sound_flower_trigger", "targetname"), ::hedge);
 	    
 	    array_thread(GetEntArray("sound_waterfall_trickle_trigger", "targetname"), ::waterfall_trickle);
 	    array_thread(GetEntArray("sound_waterfall_med_trigger", "targetname"), ::waterfall_med);
 	    array_thread(GetEntArray("sound_waterfall_under_trigger", "targetname"), ::waterfall_under);
 	    
 	    array_thread(GetEntArray("sound_rowboat_trigger", "targetname"), ::rowboat);
 	    array_thread(GetEntArray("sound_metal_drum_trigger", "targetname"), ::metal_drum);
 	    array_thread(GetEntArray("sound_dockplank_trigger", "targetname"), ::dock_plank);
 	    array_thread(GetEntArray("sound_docksplash_trigger", "targetname"), ::dock_splash);  
 	    array_thread(GetEntArray("sound_bottles_trigger", "targetname"), ::bottles);
 	    array_thread(GetEntArray("sound_metal_chair_trigger", "targetname"), ::metal_drum);
 	    
 	    array_thread(GetEntArray("water_tank", "targetname"), ::water_tank);
 	    array_thread(GetEntArray("sound_panel_buzz", "targetname"), ::panel_buzz);
 	    //array_thread(GetEntArray("sound_fridge", "targetname"), ::fridge);
 	    array_thread(GetEntArray("sound_solo_cricket", "targetname"), ::solo_cricket);
 	    
 	    array_thread(GetEntArray("whites_estate_monitor_high_freq", "targetname"), ::monitor_high_freq);
 	    array_thread(GetEntArray("whites_estate_monitor_noise", "targetname"), ::monitor_noise);
 	    array_thread(GetEntArray("whites_estate_computer_loop", "targetname"), ::computer_loop);
 	    array_thread(GetEntArray("whites_estate_server_hum", "targetname"), ::server_hum);
 	    
 	    array_thread(GetEntArray("sound_bookcase_trigger", "targetname"), ::bookcase);
 	    
 	    level thread lakeshore_loop_1();
 	    level thread boat_bells();
 	    level thread waterbirds();
 	    level thread celler_entrance();
 	    level thread light_buzz();
 	    //level thread birds_1_zone();
 	    //level thread birds_2_zone();
 	    //level thread birds_3_zone();



}


 
//*************************************************************************************************
//                                              Functions
//*************************************************************************************************



fountain()
{	
	self playloopsound ("fountain");
}


waterfall_trickle()
{	
	self playloopsound ("waterfall_trickle");
}

waterfall_med()
{	
	self playloopsound ("waterfall_med");
}

waterfall_under()
{	
	self playloopsound ("waterfall_under");
}

celler_entrance()
{	
	celler_entrance_trigger_var = GetEnt("sound_cellar_entrance", "targetname");
		
	if (isDefined(celler_entrance_trigger_var))
	//celler_entrance_trigger_var playloopsound ("AMB_WhitesEstate_Cave_Corridor_m");
	celler_entrance_trigger_var playloopsound ("amb_bg_whites_estate_ext_m");
}

lakeshore_loop_1()
{	
	

	lakeshore_zone_trigger_var = GetEnt("sound_lakeshore_zone_trigger", "targetname");
	
	if (isDefined(lakeshore_zone_trigger_var))
	lakeshore_zone_trigger_var playloopsound ("lakeshore");
}

/********** light_buzz **********/

light_buzz()
{	
	

	light_buzz_trigger_var = GetEnt("sound_lightbuzz_zone", "targetname");
	
	if (isDefined(light_buzz_trigger_var))
	light_buzz_trigger_var playloopsound ("light_buzz");
}


/********** light_buzz **********/

panel_buzz()
{
	
	self playloopsound ("panel_buzz");
	
}



/********** wind **********/

wind()
{
	
		while (1)
		{
			random_time = randomintrange(20,120);
			wait(random_time);
			self playsound ("rustle");
		}
	
}

/************ seagulls ************/
	
seagull()

{
	
	while(1)
	{
		random_time = randomfloatrange(.4,25);
		wait(random_time);
		self playsound ("whites_estate_seagulls");
		
	}
}


/************ waterbirds ************/
	
waterbirds()

{
	lakeshore_zone_trigger_var = GetEnt("sound_lakeshore_zone_trigger", "targetname");
	if (isDefined(lakeshore_zone_trigger_var))
	
	while(1)
	{
		random_time = randomintrange(10,60);
		wait(random_time);
		lakeshore_zone_trigger_var playsound ("WhitesEstate_WaterBirds_Random");
		
	}
}




/************ boat_bells ************/
	
boat_bells()

{

	whites_estate_boat_bells_var = GetEnt("sound_boat_bells_trigger", "targetname");
	if (isDefined(whites_estate_boat_bells_var))
	
	while(1)
	{
		random_time = randomintrange(5,12);
		wait(random_time);
		whites_estate_boat_bells_var playsound ("whites_estate_boat_bells");
		
	}
}


/************ bugs and misc wildlife ************/

frogs()
{
		
		while (1)
		{	
			random_time = randomintrange(1,5);
			wait(random_time);
			self playsound ("frogs");
			
			
			while ( level.player isTouching(self))
				
			{
			wait 0.1;
			}
		}
		

}


crickets()
{
	

	
		while (1)
		{	
			random_time = randomintrange(1,10);
			wait(random_time);
			self playsound ("crickets");
			
			
			while ( level.player isTouching(self))
				
			{
			wait 0.1;
			}
		}
		

}

flies()
{
	

	
		while (1)
		{	
			random_time = randomintrange(3,20);
			wait(random_time);
			self playsound ("flies");
			
			
			while ( level.player isTouching(self))
				
			{
			wait 0.1;
			}
		}
		

}
/************ birds ************/

birds_random()

{
	

	
		while(1)
		{

			random_time = randomfloatrange(2,20);
			wait(random_time);
			self playsound ("birds_random");
			
		}
}

/*

birds_1_zone()

{
	birds_1_zone_trigger_var = GetEnt("birds_1_zone", "targetname");
	if (isDefined(birds_1_zone_trigger_var))
	
		while(1)
		{

			random_time = randomfloatrange(2,20);
			wait(random_time);
			birds_1_zone_trigger_var playsound ("birds_random");
			
		}
}

birds_2_zone()

{
	birds_2_zone_trigger_var = GetEnt("birds_2_zone", "targetname");
	if (isDefined(birds_2_zone_trigger_var))
	
		while(1)
		{

			random_time = randomfloatrange(2,20);
			wait(random_time);
			birds_2_zone_trigger_var playsound ("birds_random");
			
		}
}

birds_3_zone()

{
	birds_3_zone_trigger_var = GetEnt("birds_3_zone", "targetname");
	if (isDefined(birds_3_zone_trigger_var))
	
		while(1)
		{

			random_time = randomfloatrange(2,20);
			wait(random_time);
			birds_3_zone_trigger_var playsound ("birds_random");
			
		}
}
*/

/************ hedge ************/

hedge()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("plant_shake");
				//iprintlnbold ("SOUND: hedge rustle");
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



/************ rowboat ************/

rowboat()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("rowboat");
				//iprintlnbold ("SOUND: hedge rustle");
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


/************ metal_drum ************/

metal_drum()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			//{
				self playsound ("metal_drum");
				//iprintlnbold ("SOUND: metal_drum");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
/*
			
			else
			{
				//iprintlnbold("too soft!");
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
*/
		}
		

	
}

/************ dock_plank ************/

dock_plank()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("dockwood");
				//iprintlnbold ("SOUND: dock wood");
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


dock_splash()
{
		
		while (1)
		{	
			random_time = randomintrange(10,20);
			wait(random_time);
			self playsound ("dock_splash");	
		}
		

}

/************ water tank ************/

water_tank()
{

			
		while (1)
		{
			self waittill ("trigger");
			//iprintlnbold ("SOUND: big tank ring");
			self playsound ("water_tank");		
		}	
}


/************ bottles ************/

bottles()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("plate_rattle");
				//iprintlnbold ("SOUND: hedge rustle");
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

/************ solo_cricket ************/

solo_cricket()
{
	

			
		while (1)
		{	
			random_time = randomfloatrange(.4,2);
			wait(random_time);
			self playsound ("solo_cricket");
			
			
			while ( level.player isTouching(self))
				
			{
			wait 0.1;
			}
		}
		

	
}


/********** monitor_high_freq **********/

monitor_high_freq()
{
	
	self playloopsound ("whites_estate_monitor_high_freq");
	
}


/********** monitor_noise **********/

monitor_noise()
{
	
	self playloopsound ("whites_estate_monitor_noise");
	
}

/********** computer_loop **********/

computer_loop()
{
	
	self playloopsound ("whites_estate_computer_loop");
	
}

/********** server_hum **********/

server_hum()
{
	
	self playloopsound ("whites_estate_server_hum");
	
}


//************ bookcase ************

bookcase()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("cabinet_bump");
				//iprintlnbold ("SOUND: bookcase");
				//level notify("noise_trigger_fence");
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

