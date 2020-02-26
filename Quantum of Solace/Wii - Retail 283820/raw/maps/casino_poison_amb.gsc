
#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;


main()
{
	






 

 





            declareAmbientPackage( "Casino_Poison_Int_1shot" );       

                        
			
 


           




 




            declareAmbientRoom( "Casino_Poison_Int_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Int_Tone", "bgt_casino_poison_int_default" );
                        




            declareAmbientRoom( "Casino_Poison_Card_Room_Dry" );

                        setAmbientRoomTone( "Casino_Poison_Card_Room_Dry", "bgt_casino_poison_int_card_dry" );                        
                        




            declareAmbientRoom( "Casino_Poison_Card_Room_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Card_Room_Tone", "bgt_casino_poison_int_card" );                           
                        




            declareAmbientRoom( "Casino_Poison_Dining_Room_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Dining_Room_Tone", "bgt_casino_poison_int_dr" );   
                        
                         	setAmbientRoomReverb( "Casino_Poison_Dining_Room_Tone", "dizzy", .7, .8 );                       
                        




            declareAmbientRoom( "Casino_Poison_Ext_Adjacent_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Ext_Adjacent_Tone", "bgt_casino_poison_ext_adj" );   
                        
                        	setAmbientRoomReverb( "Casino_Poison_Ext_Adjacent_Tone", "drugged", .6, .8 );                        
                        




            declareAmbientRoom( "Casino_Poison_Courtyard_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Courtyard_Tone", "bgt_casino_poison_ext_1" );  
                        
                        	setAmbientRoomReverb( "Casino_Poison_Courtyard_Tone", "drugged", .5, .9 );
                        	




            declareAmbientRoom( "Casino_Poison_Hallway_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Hallway_Tone", "bgt_casino_poison_int_hall" );         
        




            declareAmbientRoom( "Casino_Poison_Lobby_Up_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Lobby_Up_Tone", "bgt_casino_poison_int_lobby" );  
                        




            declareAmbientRoom( "Casino_Poison_Foyer_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Foyer_Tone", "bgt_casino_poison_int_foyer" );                         
                       
                 	      	setAmbientRoomReverb( "Casino_Poison_Foyer_Tone", "dizzy", 1, .9 ); 




            declareAmbientRoom( "Casino_Poison_Ext_Tone" );

                        setAmbientRoomTone( "Casino_Poison_Ext_Tone", "bgt_casino_poison_ext_2" );  
                        
                         	setAmbientRoomReverb( "Casino_Poison_Ext_Tone", "drugged", 1, .6 );                       
                        




            declareAmbientRoom( "Casino_Poison_Aston_Martin" );

                        setAmbientRoomTone( "Casino_Poison_Aston_Martin", "bgt_casino_poison_ast_mar" );                 
                    
            







            setBaseAmbientPackageAndRoom( "Casino_Poison_Int_1shot", "Casino_Poison_Int_Tone" );

			signalAmbientPackageDeclarationComplete();
 










        loopSound("p_swirl_front", (2354, 5045, 365), 121.393);
        loopSound("p_swirl_rear", (2354, 5045, 365), 121.393);
	

	loopSound("amb_wand", (3161, 6570, 310), 0.153);
	

	


	


	
	
	


	
	loopSound("Waterfall_A", (1867, 6008, 294) , 11.484);	

	
	loopSound("Waterfall_B", (1864, 6185, 284), 9.672);
	
	
	loopSound("Waterfall_A", (2834, 6185, 290), 11.484);	
	
	
	loopSound("Waterfall_B", (2838, 6007, 294), 9.672);	
	
	
	loopSound("Watertrough_L", (2634, 5905, 266), 16.720);	
	
	
	loopSound("Watertrough_R", (2032, 5908, 266) , 13.445);
	
		

	loopSound("fountain", (2354, 5045, 365), 11.632);	

	

	


	


	
	


	
	 
	

	loopSound("tucci", (2249, 2793, 372), 57.745);

	


	
	loopSound("Waterfall_A", (2698, 3532, 226), 11.484);	

	
	loopSound("Waterfall_B", (2839, 3551, 255), 9.672);
	
	
	loopSound("Waterfall_A", (3019, 3618, 278), 11.484);	
	
	
	loopSound("Waterfall_B", (3182, 3630, 269), 9.672);
	


	
	loopSound("Cricket_A", (2361, 5300, 336), 1.977);		
	
	loopSound("Cricket_B", (2076, 5054, 330), 7.378);

	loopSound("Cricket_C", (2452, 4642, 334), 1.286);
	
	
	loopSound("Cricket_A", (2288, 109, -41) , 1.977);		

	loopSound("Cricket_B", (2638, 1250, -17), 7.378);
	
	loopSound("Cricket_C", (1329, 538, -18) , 1.286);	









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
	    
	    level thread conv_11_play();

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
			conv_01_org_var playsound ("PB01_CaPoG_10A");
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
			conv_02_org_var playsound ("RB08_CaPoG_37A");
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
			fowd_org_var playsound ("fowd");
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
			conv_03_org_var playsound ("RA03_CaPoG_42A");
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
			conv_03B_org_var playsound ("PB10_CaPoG_19A");
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
			conv_04_org_var playsound ("CA10_CaPoG_70A");
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
			conv_05_org_var playsound ("CA04_CaPoG_64A");
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
			conv_05B_org_var playsound ("LB01_CaPoG_92A");
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
			conv_06_org_var playsound ("CB03_CaPoG_53A");
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
			conv_07_org_var playsound ("CB06_CaPoG_56A");
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
			conv_08_org_var playsound ("window_seq");
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
			conv_09_org_var playsound ("LB01_CaPoG_94A");
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
			conv_09B_org_var playsound ("LA03_CaPoG_107A");
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
			conv_10_org_var playsound ("LB05_CaPoG_100A");
		}
	}
	
}	


conv_11_play()
{
	conv_11_trigger_var = GetEnt("conv_11_trigger", "targetname");
	conv_11_org_var = GetEnt("conv_11_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(conv_11_trigger_var) && IsDefined(conv_11_org_var) )
	{
		while (1)
		{
			conv_11_trigger_var waittill ("trigger");
			conv_11_org_var playsound ("CB07_CaPoG_57A");
		}
	}
	
}	


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
			conv_11B_org_var playsound ("CR01_CaPoG_75A");
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
			conv_12_org_var playsound ("EB08_CaPoG_138A");
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
			conv_13_org_var playsound ("CM02_CaPoG_77A");
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
			conv_14_org_var playsound ("LB03_CaPoG_97A");
		}
	}
	
}	


metal_detector()

{

            metal_detector_trigger_var = GetEnt("metal_detector_trigger", "targetname");
            metal_detector_org_var = GetEnt("metal_detector_org", "targetname");

            

            

            

            if ( IsDefined(metal_detector_trigger_var) && IsDefined(metal_detector_org_var) )

                                    

            

                        while (1)

                        {

                                    metal_detector_trigger_var waittill ("trigger");

                                    

                                    

                                    

 

                                                metal_detector_org_var playsound ("amb_wand_woob");

                                                

                                                level notify( "sound alert" );

                                                

 

                                                while ( level.player isTouching(metal_detector_trigger_var))

                                                {

                                                wait 0.1;

                                                }

                                                metal_detector_org_var playsound ("amb_wand_woob");        

                                                

                                   
                                    

                                   

                                    {

                                                

                                                while ( level.player isTouching(metal_detector_trigger_var))

                                                {

                                                wait 0.1;

                                                }

                                    }
                                              

                        }

                        

 

            

}









plant()
{
	
	plant_org_var = GetEnt(self.target, "targetname");
	
	
	
	if ( IsDefined(plant_org_var) )
			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				plant_org_var playsound ("plant_shake");
				
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






service_cart()
{

	service_cart_org_var = GetEnt(self.target, "targetname");

	
	
	if ( IsDefined(service_cart_org_var) )
			
	
		while (1)
		{
			self waittill ("trigger");
			
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				service_cart_org_var playsound ("plate_rattle");
				
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





luggage_cart()
{
	
	luggage_cart_org_var = GetEnt(self.target, "targetname");
	
	
	
	if ( IsDefined(luggage_cart_org_var) )
			
	
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				luggage_cart_org_var playsound ("luggage_cart_bump");
				
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





cabinet()
{
	
	cabinet_org_var = GetEnt(self.target, "targetname");

	
	
	
	if ( IsDefined(cabinet_org_var) )
			
	
		while (1)
		{
			self waittill ("trigger");
			
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				cabinet_org_var playsound ("cabinet_bump");
				
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
