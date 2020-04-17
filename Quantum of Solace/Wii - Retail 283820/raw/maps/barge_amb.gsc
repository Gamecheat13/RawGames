
#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;


main()
{









            declareAmbientPackage( "warehouse_int_pkg" );            
                        
			
			
 

 
 





            declareAmbientPackage( "Bay_Ext_1shot" );            
                        
			addAmbientElement( "Bay_Ext_1shot", "amb_seagull", 6, 45, 500, 1000 );
			addAmbientElement( "Bay_Ext_1shot", "amb_ship", 6, 45, 500, 1000 );
			addAmbientElement( "Bay_Ext_1shot", "amb_dogs", 6, 45, 500, 1000 );
			addAmbientElement( "Bay_Ext_1shot", "amb_owl", 6, 45, 500, 1000 );
			
			
			
			
			
			




            declareAmbientPackage( "ship_ext_pkg" );            

                        addAmbientElement( "ship_ext_pkg", "amb_seagull", 6, 45, 500, 1000 );
                        addAmbientElement( "ship_ext_pkg", "amb_ship", 6, 45, 500, 1000 );
                        addAmbientElement( "Bay_Ext_1shot", "amb_owl", 6, 45, 500, 1000 );

 




            declareAmbientPackage( "ship_int_pkg" );            

                        addAmbientElement( "ship_int_pkg", "amb_creak_misc", 6, 45, 500, 1000 );
                        addAmbientElement( "ship_int_pkg", "amb_pipe_wronk_1", 6, 45, 500, 1000 );
                        addAmbientElement( "ship_int_pkg", "amb_pumpy_a", 6, 45, 500, 1000 );
                        
                        




            declareAmbientPackage( "ship_int_piperoom_pkg" );            

                        
                         
                        
			
 

           








            declareAmbientRoom( "car_int_room" );

                        setAmbientRoomTone( "car_int_room", "amb_car_int_room",.5, .5  );                        
                        





            declareAmbientRoom( "warehouse_int_room" );

                        setAmbientRoomTone( "warehouse_int_room", "amb_warehouse_int_room",.5, .5  );                        

                        	setAmbientRoomReverb( "warehouse_int_room", "auditorium", 1, .3 );






            declareAmbientRoom( "Bay_Ext_Tone" );

                        setAmbientRoomTone( "Bay_Ext_Tone", "bgt_bay" );
                        
                        
 
 
 

             declareAmbientRoom( "ship_ext_room" );
                         setAmbientRoomTone( "ship_ext_room", "amb_bg_barge_ext" );     
                         
  
  
  
 
              declareAmbientRoom( "warehouse_ext_room" );
                         setAmbientRoomTone( "warehouse_ext_room", "amb_bg_warehouse_ext",.5, .5 ); 
 
 
 
 
 

             declareAmbientRoom( "ship_int_boxcar" );
                         setAmbientRoomTone( "ship_int_boxcar", "amb_ship_int_boxcar" );                          
                         		setAmbientRoomReverb( "ship_int_boxcar", "bathroom", 1, .3 );   
                         
 
 
 

             declareAmbientRoom( "deck_room_int" );
                         setAmbientRoomTone( "deck_room_int", "amb_bg_deck_room_int" );  
                          		setAmbientRoomReverb( "deck_room_int", "bathroom", 1, .3 );                           
                         
 
 
 

             declareAmbientRoom( "below_deck_room_int" );
                         setAmbientRoomTone( "below_deck_room_int", "amb_bg_belowdeck_room_int" );                           
                            		setAmbientRoomReverb( "below_deck_room_int", "bathroom", 1, .4 );                        
                         

                        
 
 
 

             declareAmbientRoom( "ship_int_room" );
                         setAmbientRoomTone( "ship_int_room", "amb_bg_barge_int" );
                             		setAmbientRoomReverb( "ship_int_room", "bathroom", 1, .4 );                        
                         
                         
  
 
 

             declareAmbientRoom( "ship_int_room_no_steam" );
                         setAmbientRoomTone( "ship_int_room_no_steam", "amb_bg_barge_int_no_steam" ); 
                             		setAmbientRoomReverb( "ship_int_room_no_steam", "bathroom", 1, .4 );                        
                                        
                         
 
 
 
 

             declareAmbientRoom( "ship_int_piperoom_room" );
                         setAmbientRoomTone( "ship_int_piperoom_room", "amb_bg_barge_piperoom_int" );
                         
                         
                         
                         






            setBaseAmbientPackageAndRoom( "Bay_Ext_1shot", "Bay_Ext_Tone" );

			signalAmbientPackageDeclarationComplete();
 








	

	
	

	loopSound("engine_run", (1963, 3920, 119), 4.536);			
	

	loopSound("ac_unit", (2661, 3060, 115), 9.666);	




	
	

	
		


	
	
	loopSound("vent_fan_C", (2712, 3055, 142), 7.383);
	
	
	loopSound("vent_fan_B", (2841, 3056, 141), 8.617);
	
	
	loopSound("vent_fan_A", (2306, 2984, 373), 10.800);
	
	
	loopSound("vent_fan_B2", (2286, 1924, 373), 8.617);
	
	
	loopSound("vent_fan_D", (2717, 2029, 58), 9.806);
	
	
	
	
	loopSound("radio_static", (2819, 2089, 142), 17.663);
	
	
	loopSound("moth_light", (2701, 2209, 164), 8.960);
 



	
	
	loopSound("frogs_left", (3043, 3754, 28), 5.613);
	
	
	loopSound("frogs_right", (1206, 3958, 77), 5.613);




	
	
	loopSound("horn_hole", (2727, -37, 196), 28.786);
	
	
	loopSound("horn_hole", (2724, 644, 192), 28.786);
	
	
	loopSound("horn_hole", (-625, 688, 59), 28.786);
	
	
	loopSound("horn_hole", (-624, 126, 59), 28.786);
	

	loopSound("steam_hiss", (2742, 365, 5), 13.315);


	loopSound("sparky", (2695, 432, 31), 10.297);	



	
	
	loopSound("electric_box", (2928, -137, 27) , 4.853);
	
	
	loopSound("electric_box", (737, 176, 162), 4.853);
	
	
	loopSound("electric_box", (149, 717, 165), 4.853);
	
	
	loopSound("electric_box", (743, 158, 185), 4.853);
	
	
	loopSound("electric_box", (707, 717, 191), 4.853);	
	
	
	loopSound("electric_box", (680, 863, 169), 4.853);	













level thread stop_barge_ext_sounds();

level thread floor_creak_one();

level thread floor_creak_two();

array_thread(GetEntArray("grass_pass_trigger", "targetname"), ::grass_pass_one);

level thread stairs_creak_one();

array_thread(GetEntArray("fence_trigger", "targetname"), ::fence);

array_thread(GetEntArray("wood_fence_trigger", "targetname"), ::wood_fence);

array_thread(GetEntArray("barrel_trigger", "targetname"), ::barrel);

array_thread(GetEntArray("radio_damage_trigger", "targetname"), ::radio_loop);
array_thread(GetEntArray("radio_damage_trigger", "targetname"), ::radio_damage);

}




 



 






stop_barge_ext_sounds()
{

	triggerstop = getent("barge_ext_off", "targetname");
	triggerstop waittill ("trigger");
	
	iprintlnbold ( "trigger to shut off ext loops" );
	
		
		loops = getentarray( "barge_audio_trigger", "targetname" );
		for ( i = 0; i < loops.size; i++ )
		{
		loops[i] stoploopsound(); 
		iprintlnbold ( "loops stopping" );
		}


	
}



grass_pass_one()

{

            

            grass_pass_org_var = GetEnt(self.target, "targetname");

            

            

            

            if ( IsDefined(grass_pass_org_var) )

                                    

            

                        while (1)

                        {

                                    self waittill ("trigger");

                                    

                                    if ( 1000 < lengthsquared( level.player getplayervelocity() ) )

                                    

                                    {

 

                                                grass_pass_org_var playsound ("folaige_passthru");

                                                

                                                level notify( "sound alert" );

 

                                                while ( level.player isTouching(self))

                                                {

                                                wait 0.1;

                                                }

                                                grass_pass_org_var playsound ("folaige_passthru");

                                                

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


floor_creak_one()

{

            floor_creak_trigger_1_var = GetEnt("floor_creak_trigger", "targetname");
            floor_creak_org_1_var = GetEnt("floor_creak_org", "targetname");

            

            

            

            if ( IsDefined(floor_creak_trigger_1_var) && IsDefined(floor_creak_org_1_var) )

                                    

            

                        while (1)

                        {

                                    floor_creak_trigger_1_var waittill ("trigger");

                                    if ( 2000 < lengthsquared( level.player getplayervelocity() ) )         

                                    

                                    {

 

                                                floor_creak_org_1_var playsound ("wood_creak_floor");

                                                

                                                level notify( "sound alert" );

                                                

 

                                                while ( level.player isTouching(floor_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                                floor_creak_org_1_var playsound ("wood_creak_floor");        

                                                

                                    }
                                    

                                    else

                                    {

                                                

                                                while ( level.player isTouching(floor_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                    }
                                              

                        }

                        

 

            

}


floor_creak_two()

{

            floor_creak_trigger_1_var = GetEnt("floor_creak_02_trigger", "targetname");
            floor_creak_org_1_var = GetEnt("floor_creak_02_org", "targetname");

            

            

            

            if ( IsDefined(floor_creak_trigger_1_var) && IsDefined(floor_creak_org_1_var) )

                                    

            

                        while (1)

                        {

                                    floor_creak_trigger_1_var waittill ("trigger");

                                    if ( 2000 < lengthsquared( level.player getplayervelocity() ) )         

                                    

                                    {

 

                                                floor_creak_org_1_var playsound ("wood_creak_floor");

                                                

                                                level notify( "sound alert" );

                                                

 

                                                while ( level.player isTouching(floor_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                                floor_creak_org_1_var playsound ("wood_creak_floor");        

                                                

                                    }
                                    

                                    else

                                    {

                                                

                                                while ( level.player isTouching(floor_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                    }
                                              

                        }

                        

 

            

}



stairs_creak_one()

{

            stairs_creak_trigger_1_var = GetEnt("stairs_creak_trigger", "targetname");
            stairs_creak_org_1_var = GetEnt("stairs_creak_org", "targetname");

            

            

            

            if ( IsDefined(stairs_creak_trigger_1_var) && IsDefined(stairs_creak_org_1_var) )

                                    

            

                        while (1)

                        {

                                    stairs_creak_trigger_1_var waittill ("trigger");

                                    if ( 2000 < lengthsquared( level.player getplayervelocity() ) )         

                                    

                                    {

 

                                                stairs_creak_org_1_var playsound ("wood_creak_stairs");

                                                

                                                level notify( "sound alert" );

                                                

 

                                                while ( level.player isTouching(stairs_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                                stairs_creak_org_1_var playsound ("wood_creak_stairs");        

                                                

                                    }
                                    

                                    else

                                    {

                                                

                                                while ( level.player isTouching(stairs_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                    }
                                              

                        }

                        

 

            

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





wood_fence()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("wood_fence_bump");
				
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




barrel()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("barrel_bump");
				
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




radio_loop()
{

	self playloopsound ("radio");

}	

	
radio_damage()
{

	self waittill ("trigger");
	
	self stoploopsound();	
}



	
	





