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
//Casino_Poison_Int_1shot
//***************   

            declareAmbientPackage( "Casino_Poison_Int_1shot" );       

                        //addAmbientElement( "Casino_Poison_Int_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Casino_Poison_Int_1shot", "amb_boats", 6, 45, 500, 1000 );
 


           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 
//***************
//Casino_Poison_Int_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Int_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Int_Tone", "bgt_casino_poison_int_default" );
                        
//***************
//Casino_Poison_Card_Room_Dry
//***************

            declareAmbientRoom( "Casino_Poison_Card_Room_Dry" );

                        setAmbientRoomTone( "Casino_Poison_Card_Room_Dry", "bgt_casino_poison_int_card_dry" );                        
                        
//***************
//Casino_Poison_Card_Room_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Card_Room_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Card_Room_Tone", "bgt_casino_poison_int_card" );  
                        
                         	setAmbientRoomReverb( "Casino_Poison_Card_Room_Tone", "dizzy", .8, .8 );                        
                        
//***************
//Casino_Poison_Dining_Room_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Dining_Room_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Dining_Room_Tone", "bgt_casino_poison_int_dr" );   
                        
                         	setAmbientRoomReverb( "Casino_Poison_Dining_Room_Tone", "dizzy", .7, .8 );                       
                        
//***************
//Casino_Poison_Ext_Adjacent_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Ext_Adjacent_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Ext_Adjacent_Tone", "bgt_casino_poison_ext_adj" );   
                        
                        	setAmbientRoomReverb( "Casino_Poison_Ext_Adjacent_Tone", "drugged", .6, .8 );                        
                        
//***************
//Casino_Poison_Courtyard_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Courtyard_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Courtyard_Tone", "bgt_casino_poison_ext_1" );  
                        
                        	setAmbientRoomReverb( "Casino_Poison_Courtyard_Tone", "drugged", .5, .9 );
                        	
//***************
//Casino_Poison_Hallway_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Hallway_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Hallway_Tone", "bgt_casino_poison_int_hall" );     
                        
                         	setAmbientRoomReverb( "Casino_Poison_Hallway_Tone", "drugged", .5, .9 );                       
        
//***************
//Casino_Poison_Lobby_Up_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Lobby_Up_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Lobby_Up_Tone", "bgt_casino_poison_int_lobby" );  
                        
                          	setAmbientRoomReverb( "Casino_Poison_Lobby_Up_Tone", "drugged", .5, .9 );                             
                        
//***************
//Casino_Poison_Foyer_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Foyer_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Foyer_Tone", "bgt_casino_poison_int_foyer" );                         
                       
                 	      	setAmbientRoomReverb( "Casino_Poison_Foyer_Tone", "dizzy", .8, .9 ); 
//***************
//Casino_Poison_Ext_Tone
//***************

            declareAmbientRoom( "Casino_Poison_Ext_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Ext_Tone", "bgt_casino_poison_ext_2" );  
                        
                         	setAmbientRoomReverb( "Casino_Poison_Ext_Tone", "drugged", .7, .6 );                       
                        
//***************
//Casino_Poison_Aston_Martin
//***************

            declareAmbientRoom( "Casino_Poison_Aston_Martin" );

                        setAmbientRoomTone( "Casino_Poison_Aston_Martin", "bgt_casino_poison_ast_mar" );                 
                    
            

//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            setBaseAmbientPackageAndRoom( "Casino_Poison_Int_1shot", "Casino_Poison_Int_Tone" );

			signalAmbientPackageDeclarationComplete();
 



//*************************************************************************************************

//                                              STATIC LOOPS

//*************************************************************************************************

//Poison Swirl - note: coordinates are bunk - these are 2d sounds
        loopSound("p_swirl_front", (2354, 5045, 365), 121.393);
        loopSound("p_swirl_rear", (2354, 5045, 365), 121.393);
	
//Metal Detector - constant sound
	loopSound("amb_wand", (3161, 6570, 310), 0.153);
	
//Piano
	loopSound("piano_man", (2351, 6671, 298), 66.003);	

//Curtain Left
	loopSound("Curtain_L", (2404, 6326, 317) , 8.242);		

//Curtain Right
	loopSound("Curtain_R", (2294, 6341, 319), 9.772);	
	
	
//COURTYARD WATERFALLS

	//Waterfeature 1
	loopSound("Waterfall_A", (1867, 6008, 294) , 11.484);	

	//Waterfeature 2
	loopSound("Waterfall_B", (1864, 6185, 284), 9.672);
	
	//Waterfeature 3
	loopSound("Waterfall_A", (2834, 6185, 290), 11.484);	
	
	//Waterfeature 4
	loopSound("Waterfall_B", (2838, 6007, 294), 9.672);	
	
	//Watertrough L
	loopSound("Watertrough_L", (2634, 5905, 266), 16.720);	
	
	//Watertrough R
	loopSound("Watertrough_R", (2032, 5908, 266) , 13.445);
	
		
//Fountain
	loopSound("fountain", (2354, 5045, 365), 11.632);	

	
//Grandfather Clock
	loopSound("G_Clock",  (1967, 3417, 399), 4.797);		

//Gambling Room Door A
	loopSound("Gamb_Walla_A", (1952, 3654, 394) , 58.089);		

//Gambling Room Door B
	loopSound("Gamb_Walla_B", (1920, 3211, 423), 28.042);		
	

//Open Window
	//loopSound("open_window", (2065, 2573, 404), 12.120);
	 
	
//Laptop
	loopSound("tucci", (2249, 2793, 372), 57.745);

	
//STAIRS WATERFALLS

	//Waterfeature 1
	loopSound("Waterfall_A", (2698, 3532, 226), 11.484);	

	//Waterfeature 2
	loopSound("Waterfall_B", (2839, 3551, 255), 9.672);
	
	//Waterfeature 3
	loopSound("Waterfall_A", (3019, 3618, 278), 11.484);	
	
	//Waterfeature 4
	loopSound("Waterfall_B", (3182, 3630, 269), 9.672);
	
//Crickets

	//Courtyard
	loopSound("Cricket_A", (2361, 5300, 336), 1.977);		
	
	loopSound("Cricket_B", (2076, 5054, 330), 7.378);

	loopSound("Cricket_C", (2452, 4642, 334), 1.286);
	
	//Car Lot
	loopSound("Cricket_A", (2288, 109, -41) , 1.977);		

	loopSound("Cricket_B", (2638, 1250, -17), 7.378);
	
	loopSound("Cricket_C", (1329, 538, -18) , 1.286);	



//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************

	    level thread conv_01_play();

	    level thread conv_02_play();
	    
	    level thread fowd_play();
	    
	    level thread conv_03_play();
	    
	    level thread conv_03B_play();
	    
	    level thread conv_04_play();
	    
	    level thread conv_05_play();

	    level thread conv_05B_play();
	    
	    level thread conv_06_play();
	    
	    level thread conv_07_play();
	    
	    level thread conv_08_play();
	    
	    level thread conv_09_play();

	    level thread conv_09B_play();
	    
	    level thread conv_10_play();
	    
	    //level thread conv_11_play();

	    level thread conv_11B_play();
	    
	    level thread conv_12_play();
	    
	    level thread conv_13_play();
	    
	    level thread conv_14_play();
	    
	    level thread metal_detector();	 
	    
  	    array_thread(GetEntArray("luggage_cart_trigger", "targetname"), ::luggage_cart);
  	    array_thread(GetEntArray("service_cart_trigger", "targetname"), ::service_cart);
  	    array_thread(GetEntArray("plant_trigger", "targetname"), ::plant);
  	    array_thread(GetEntArray("cabinet_trigger", "targetname"), ::cabinet);    
	    

	
}

 
//*************************************************************************************************

 

//                                              Functions

 

//*************************************************************************************************

play_drone_sound(alias, ent)
{
	drone = maps\_utility::find_closest_drone(ent.origin);
	//print3d( ent.origin, "-", (1,1,1), 1, 1, 60 );
	if( isdefined(drone) )
	{
		drone.doFacialAnim = true;

		//print3d( drone.origin, "!", (1,1,1), 1, 1, 60 );
	}

	ent playsound(alias, alias);
	ent waittill( alias );

	if( isdefined(drone) )
	{
		drone.doFacialAnim = false;
	}
}


conv_01_play()
{
	conv_01_trigger_var = GetEnt("conv_01_trigger", "targetname");
	conv_01_org_var = GetEnt("conv_01_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_01_trigger_var) && IsDefined(conv_01_org_var) )
	{
		while (1)
		{
			conv_01_trigger_var waittill ("trigger");
			play_drone_sound("PB01_CaPoG_10A", conv_01_org_var);
		}
	}
	
}	


conv_02_play()
{
	conv_02_trigger_var = GetEnt("conv_02_trigger", "targetname");
	conv_02_org_var = GetEnt("conv_02_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_02_trigger_var) && IsDefined(conv_02_org_var) )
	{
		while (1)
		{
			conv_02_trigger_var waittill ("trigger");
			play_drone_sound("RB08_CaPoG_37A", conv_02_org_var);
		}
	}
	
}	


fowd_play()
{
	fowd_trigger_var = GetEnt("fowd_trigger", "targetname");
	fowd_org_var = GetEnt("fowd_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(fowd_trigger_var) && IsDefined(fowd_org_var) )
	{
		while (1)
		{
			fowd_trigger_var waittill ("trigger");
			play_drone_sound("fowd", fowd_org_var);
		}
	}
	
}


conv_03_play()
{
	conv_03_trigger_var = GetEnt("conv_03_trigger", "targetname");
	conv_03_org_var = GetEnt("conv_03_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_03_trigger_var) && IsDefined(conv_03_org_var) )
	{
		while (1)
		{
			conv_03_trigger_var waittill ("trigger");
			play_drone_sound("RA03_CaPoG_42A", conv_03_org_var);
		}
	}
	
}	


conv_03B_play()
{
	conv_03B_trigger_var = GetEnt("conv_03B_trigger", "targetname");
	conv_03B_org_var = GetEnt("conv_03B_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_03B_trigger_var) && IsDefined(conv_03B_org_var) )
	{
		while (1)
		{
			conv_03B_trigger_var waittill ("trigger");
			play_drone_sound("PB10_CaPoG_19A", conv_03B_org_var);
		}
	}
	
}	


conv_04_play()
{
	conv_04_trigger_var = GetEnt("conv_04_trigger", "targetname");
	conv_04_org_var = GetEnt("conv_04_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_04_trigger_var) && IsDefined(conv_04_org_var) )
	{
		while (1)
		{
			conv_04_trigger_var waittill ("trigger");
			play_drone_sound("CA10_CaPoG_70A", conv_04_org_var);
		}
	}
	
}	


conv_05_play()
{
	conv_05_trigger_var = GetEnt("conv_05_trigger", "targetname");
	conv_05_org_var = GetEnt("conv_05_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_05_trigger_var) && IsDefined(conv_05_org_var) )
	{
		while (1)
		{
			conv_05_trigger_var waittill ("trigger");
			play_drone_sound("CA04_CaPoG_64A", conv_05_org_var);
		}
	}
	
}	


conv_05B_play()
{
	conv_05B_trigger_var = GetEnt("conv_05B_trigger", "targetname");
	conv_05B_org_var = GetEnt("conv_05B_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_05B_trigger_var) && IsDefined(conv_05B_org_var) )
	{
		while (1)
		{
			conv_05B_trigger_var waittill ("trigger");
			play_drone_sound("LB01_CaPoG_92A", conv_05B_org_var);
		}
	}
	
}


conv_06_play()
{
	conv_06_trigger_var = GetEnt("conv_06_trigger", "targetname");
	conv_06_org_var = GetEnt("conv_06_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_06_trigger_var) && IsDefined(conv_06_org_var) )
	{
		while (1)
		{
			conv_06_trigger_var waittill ("trigger");
			play_drone_sound("CB04_CaPoG_54A", conv_06_org_var);
		}
	}
	
}	


conv_07_play()
{
	conv_07_trigger_var = GetEnt("conv_07_trigger", "targetname");
	conv_07_org_var = GetEnt("conv_07_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_07_trigger_var) && IsDefined(conv_07_org_var) )
	{
		while (1)
		{
			conv_07_trigger_var waittill ("trigger");
			play_drone_sound("CB06_CaPoG_56A", conv_07_org_var);
		}
	}
	
}	


conv_08_play()
{
	conv_08_trigger_var = GetEnt("conv_08_trigger", "targetname");
	conv_08_org_var = GetEnt("conv_08_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_08_trigger_var) && IsDefined(conv_08_org_var) )
	{
		while (1)
		{
			conv_08_trigger_var waittill ("trigger");
			play_drone_sound("window_seq", conv_08_org_var);
		}
	}
	
}	


conv_09_play()
{
	conv_09_trigger_var = GetEnt("conv_09_trigger", "targetname");
	conv_09_org_var = GetEnt("conv_09_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_09_trigger_var) && IsDefined(conv_09_org_var) )
	{
		while (1)
		{
			conv_09_trigger_var waittill ("trigger");
			play_drone_sound("LB01_CaPoG_94A", conv_09_org_var);
		}
	}
	
}	


conv_09B_play()
{
	conv_09B_trigger_var = GetEnt("conv_09B_trigger", "targetname");
	conv_09B_org_var = GetEnt("conv_09_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_09B_trigger_var) && IsDefined(conv_09B_org_var) )
	{
		while (1)
		{
			conv_09B_trigger_var waittill ("trigger");
			play_drone_sound("LA03_CaPoG_107A", conv_09B_org_var);
		}
	}
	
}


conv_10_play()
{
	conv_10_trigger_var = GetEnt("conv_10_trigger", "targetname");
	conv_10_org_var = GetEnt("conv_10_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_10_trigger_var) && IsDefined(conv_10_org_var) )
	{
		while (1)
		{
			conv_10_trigger_var waittill ("trigger");
			play_drone_sound("LB05_CaPoG_100A", conv_10_org_var);
		}
	}
	
}	


//conv_11_play()
//{
	//conv_11_trigger_var = GetEnt("conv_11_trigger", "targetname");
	//conv_11_org_var = GetEnt("conv_11_org", "targetname");
	
	//level endon ("insert_notify");
	//if ( IsDefined(conv_11_trigger_var) && IsDefined(conv_11_org_var) )
	//{
		//while (1)
		//{
			//conv_11_trigger_var waittill ("trigger");
			//play_drone_sound("CB07_CaPoG_57A", conv_11_org_var);
		//}
	//}
	
//}	


conv_11B_play()
{
	conv_11B_trigger_var = GetEnt("conv_11B_trigger", "targetname");
	conv_11B_org_var = GetEnt("conv_11B_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_11B_trigger_var) && IsDefined(conv_11B_org_var) )
	{
		while (1)
		{
			conv_11B_trigger_var waittill ("trigger");
			play_drone_sound("CR01_CaPoG_75A", conv_11B_org_var);
		}
	}
	
}	


conv_12_play()
{
	conv_12_trigger_var = GetEnt("conv_12_trigger", "targetname");
	conv_12_org_var = GetEnt("conv_12_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_12_trigger_var) && IsDefined(conv_12_org_var) )
	{
		while (1)
		{
			conv_12_trigger_var waittill ("trigger");
			play_drone_sound("EB08_CaPoG_138A", conv_12_org_var);
		}
	}
	
}	


conv_13_play()
{
	conv_13_trigger_var = GetEnt("conv_13_trigger", "targetname");
	conv_13_org_var = GetEnt("conv_13_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_13_trigger_var) && IsDefined(conv_13_org_var) )
	{
		while (1)
		{
			conv_13_trigger_var waittill ("trigger");
			play_drone_sound("CM02_CaPoG_77A", conv_13_org_var);
		}
	}
	
}	


conv_14_play()
{
	conv_14_trigger_var = GetEnt("conv_14_trigger", "targetname");
	conv_14_org_var = GetEnt("conv_14_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_14_trigger_var) && IsDefined(conv_14_org_var) )
	{
		while (1)
		{
			conv_14_trigger_var waittill ("trigger");
			play_drone_sound("LB03_CaPoG_97A", conv_14_org_var);
		}
	}
	
}	


metal_detector()

{

            metal_detector_trigger_var = GetEnt("metal_detector_trigger", "targetname");
            metal_detector_org_var = GetEnt("metal_detector_org", "targetname");

            

            //level endon ("insert_notify");

            

            if ( IsDefined(metal_detector_trigger_var) && IsDefined(metal_detector_org_var) )

                                    

            

                        while (1)

                        {

                                    metal_detector_trigger_var waittill ("trigger");

                                    //if ( 2000 < lengthsquared( level.player getplayervelocity() ) )         // won’t play if player is moving really slowly.  

                                    

                                    //{

 

                                                metal_detector_org_var playsound ("amb_wand_woob");

                                                //iprintlnbold ("SOUND: amb_wand_woob");

                                                level notify( "sound alert" );

                                                //thug_ears_1();

 

                                                while ( level.player isTouching(metal_detector_trigger_var))

                                                {

                                                wait 0.1;

                                                }

                                                metal_detector_org_var playsound ("amb_wand_woob");        // use this if you want a key-off

                                                //iprintlnbold ("SOUND: amb_wand_woob");

                                   // }
                                    

                                   // else

                                    {

                                                //iprintlnbold("too soft!");

                                                while ( level.player isTouching(metal_detector_trigger_var))

                                                {

                                                wait 0.1;

                                                }

                                    }
                                              

                        }

                        

 

            

}


//***************************************************************************************************************
//
// JRB plant rustle 
//
//***************************************************************************************************************


plant()
{
	
	plant_org_var = GetEnt(self.target, "targetname");
	
	//level endon ("insert_notify");
	
	if ( IsDefined(plant_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				plant_org_var playsound ("plant_shake");
				//iprintlnbold ("SOUND: plant rustle");
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



//************************************* JRB service cart dish rattles ***************************************


service_cart()
{

	service_cart_org_var = GetEnt(self.target, "targetname");

	//level endon ("insert_notify");
	
	if ( IsDefined(service_cart_org_var) )
			
	
		while (1)
		{
			self waittill ("trigger");
			
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				service_cart_org_var playsound ("plate_rattle");
				//iprintlnbold ("SOUND: service cart noise");
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



//************************************** JRB luggage carts *******************************************

luggage_cart()
{
	
	luggage_cart_org_var = GetEnt(self.target, "targetname");
	
	//level endon ("insert_notify");
	
	if ( IsDefined(luggage_cart_org_var) )
			
	
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				luggage_cart_org_var playsound ("luggage_cart_bump");
				//iprintlnbold ("SOUND: luggage cart noise");
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


//************************************** JRB Cabinets and large Wooden *******************************************


cabinet()
{
	
	cabinet_org_var = GetEnt(self.target, "targetname");

	
	//level endon ("insert_notify");
	
	if ( IsDefined(cabinet_org_var) )
			
	
		while (1)
		{
			self waittill ("trigger");
			
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				cabinet_org_var playsound ("cabinet_bump");
				//iprintlnbold ("SOUND: cabinet noise");
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