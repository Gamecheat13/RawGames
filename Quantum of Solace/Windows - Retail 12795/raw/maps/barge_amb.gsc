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

//*****************
//warehouse_int_pkg
//*****************   

            declareAmbientPackage( "warehouse_int_pkg" );            
                        
			//addAmbientElement( "Bay_Ext_1shot", "amb_seagull", 6, 45, 500, 1000 );
			//addAmbientElement( "Bay_Ext_1shot", "amb_ship", 6, 45, 500, 1000 );
 

 
 

//***************
//Bay_Ext_1shot
//***************   

            declareAmbientPackage( "Bay_Ext_1shot" );            
                        
			addAmbientElement( "Bay_Ext_1shot", "amb_seagull", 6, 45, 500, 1000 );
			addAmbientElement( "Bay_Ext_1shot", "amb_ship", 6, 45, 500, 1000 );
			addAmbientElement( "Bay_Ext_1shot", "amb_dogs", 6, 45, 500, 1000 );
			addAmbientElement( "Bay_Ext_1shot", "amb_owl", 6, 45, 500, 1000 );
			
			
			
			
			
			
//***************
//ship_ext_pkg
//***************   

            declareAmbientPackage( "ship_ext_pkg" );            

                        addAmbientElement( "ship_ext_pkg", "amb_seagull", 6, 45, 500, 1000 );
                        addAmbientElement( "ship_ext_pkg", "amb_ship", 6, 45, 500, 1000 );
                        addAmbientElement( "Bay_Ext_1shot", "amb_owl", 6, 45, 500, 1000 );

 
//***************
//ship_int_pkg
//***************   

            declareAmbientPackage( "ship_int_pkg" );            

                        addAmbientElement( "ship_int_pkg", "amb_creak_misc", 6, 45, 500, 1000 );
                        addAmbientElement( "ship_int_pkg", "amb_pipe_wronk_1", 6, 45, 500, 1000 );
                        addAmbientElement( "ship_int_pkg", "amb_pumpy_a", 6, 45, 500, 1000 );
                        
                        
//*********************
//ship_int_piperoom_pkg
//*********************   

            declareAmbientPackage( "ship_int_piperoom_pkg" );            

                        //addAmbientElement( "ship_int_piperoom_pkg", "amb_seagull", 6, 45, 500, 1000 );
                         
                        
			
 

           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

//*****************
//car_int_room
//*****************

            declareAmbientRoom( "car_int_room" );

                        setAmbientRoomTone( "car_int_room", "amb_car_int_room",.5, .5  );                        
                        

//*****************
//warehouse_int_room
//*****************

            declareAmbientRoom( "warehouse_int_room" );

                        setAmbientRoomTone( "warehouse_int_room", "amb_warehouse_int_room",.5, .5  );                        

                        	setAmbientRoomReverb( "warehouse_int_room", "auditorium", 1, .3 );


//***************
//Bay_Ext_Tone
//***************

            declareAmbientRoom( "Bay_Ext_Tone" );

                        setAmbientRoomTone( "Bay_Ext_Tone", "bgt_bay" );
                        
                        
 //***************
 //ship_ext_room
 //***************

             declareAmbientRoom( "ship_ext_room" );
                         setAmbientRoomTone( "ship_ext_room", "amb_bg_barge_ext" );     
                         
  //***************
  //warehouse_ext_room
  //***************
 
              declareAmbientRoom( "warehouse_ext_room" );
                         setAmbientRoomTone( "warehouse_ext_room", "amb_bg_warehouse_ext",.5, .5 ); 
 
 
 //***************
 //ship_int_boxcar
 //***************

             declareAmbientRoom( "ship_int_boxcar" );
                         setAmbientRoomTone( "ship_int_boxcar", "amb_ship_int_boxcar" );                          
                         		setAmbientRoomReverb( "ship_int_boxcar", "bathroom", 1, .3 );   
                         
 //***************
 //deck_room_int
 //***************

             declareAmbientRoom( "deck_room_int" );
                         setAmbientRoomTone( "deck_room_int", "amb_bg_deck_room_int" );  
                          		setAmbientRoomReverb( "deck_room_int", "bathroom", 1, .3 );                           
                         
 //***************
 //below_deck_room_int
 //***************

             declareAmbientRoom( "below_deck_room_int" );
                         setAmbientRoomTone( "below_deck_room_int", "amb_bg_belowdeck_room_int" );                           
                            		setAmbientRoomReverb( "below_deck_room_int", "bathroom", 1, .4 );                        
                         

                        
 //***************
 //ship_int_room
 //***************

             declareAmbientRoom( "ship_int_room" );
                         setAmbientRoomTone( "ship_int_room", "amb_bg_barge_int" );
                             		setAmbientRoomReverb( "ship_int_room", "bathroom", 1, .4 );                        
                         
                         
  //***************
 //ship_int_room_no_steam
 //***************

             declareAmbientRoom( "ship_int_room_no_steam" );
                         setAmbientRoomTone( "ship_int_room_no_steam", "amb_bg_barge_int_no_steam" ); 
                             		setAmbientRoomReverb( "ship_int_room_no_steam", "bathroom", 1, .4 );                        
                                        
                         
 //**********************
 //ship_int_piperoom_room
 //**********************
 

             declareAmbientRoom( "ship_int_piperoom_room" );
                         setAmbientRoomTone( "ship_int_piperoom_room", "amb_bg_barge_piperoom_int" );
                         
                         
                         
                         
//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            setBaseAmbientPackageAndRoom( "Bay_Ext_1shot", "Bay_Ext_Tone" );

			signalAmbientPackageDeclarationComplete();
 


//*************************************************************************************************

//                                              STATIC LOOPS

//*************************************************************************************************

	
//Car Engine Cool Down
	//loopSound("engine_cool", (2028, 3622, 130), 23.974);	
	
//Car Engine Running
	loopSound("engine_run", (1963, 3920, 119), 4.536);
	
//Car Tune
	loopSound("car_tune", (1932, 3981, 125), 281.824);	
	
//AC Unit
	loopSound("ac_unit", (2661, 3060, 115), 9.666);	
	
// TV   (trailer)
	loopSound("tv_static", (1757, 3290, 174), 22.324);
	
//radio (trailer)
	//loopSound("radio", (2605, 3386, 169), 17.663);
		

// VENT FANS
	
	//Vent Fan 1 (unit)
	loopSound("vent_fan_C", (2712, 3055, 142), 7.383);
	
	//Vent Fan 2 (unit)
	loopSound("vent_fan_B", (2841, 3056, 141), 8.617);
	
	//Vent Fan 3 (up)
	loopSound("vent_fan_A", (2306, 2984, 373), 10.800);
	
	//Vent Fan 4 (up)
	loopSound("vent_fan_B2", (2286, 1924, 373), 8.617);
	
	//Vent Fan 5 (downstairs)
	loopSound("vent_fan_D", (2717, 2029, 58), 9.806);
	
	
	
	//radio (warehouse - upstairs)
	loopSound("radio_static", (2819, 2089, 142), 17.663);
	
	//Moth Lantern (warehouse - upstairs)
	loopSound("moth_light", (2701, 2209, 164), 8.960);
 


// FROGS
	
	//Frogs Left
	loopSound("frogs_left", (3043, 3754, 28), 5.613);
	
	//Frogs Right
	loopSound("frogs_right", (1206, 3958, 77), 5.613);



// HORN HOLES
	
	//Horn Hole 1 
	loopSound("horn_hole", (2727, -37, 196), 28.786);
	
	//Horn Hole 2
	loopSound("horn_hole", (2724, 644, 192), 28.786);
	
	//Horn Hole 3
	loopSound("horn_hole", (-625, 688, 59), 28.786);
	
	//Horn Hole 4
	loopSound("horn_hole", (-624, 126, 59), 28.786);
	
// STEAM LEAK HISS
	loopSound("steam_hiss", (2742, 365, 5), 13.315);
	
// SPARKY
	loopSound("sparky", (2695, 432, 31), 10.297);	


// ELECTRIC BOXES
	
	//Electric Box 1 
	loopSound("electric_box", (2928, -137, 27) , 4.853);
	
	//Electric Box 2
	loopSound("electric_box", (737, 176, 162), 4.853);
	
	//Electric Box 3
	loopSound("electric_box", (149, 717, 165), 4.853);
	
	//Electric Box 4
	loopSound("electric_box", (743, 158, 185), 4.853);
	
	//Electric Box 5
	loopSound("electric_box", (707, 717, 191), 4.853);	
	
	//Electric Box 6
	loopSound("electric_box", (680, 863, 169), 4.853);	






//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************


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


//*************************************************************************************************

 

//                                              Functions

 

//*************************************************************************************************




stop_barge_ext_sounds()
{

	triggerstop = getent("barge_ext_off", "targetname");
	triggerstop waittill ("trigger");
	//level notify("stop_barge_ext");
	//iprintlnbold ( "trigger to shut off ext loops" );
	
		
		loops = getentarray( "barge_audio_trigger", "targetname" );
		for ( i = 0; i < loops.size; i++ )
		{
		loops[i] stoploopsound(); // put a fade time in seconds here if you want
		//iprintlnbold ( "loops stopping" );
		}


	
}



grass_pass_one()

{

            

            grass_pass_org_var = GetEnt(self.target, "targetname");

            

            //level endon ("insert_notify");

            

            if ( IsDefined(grass_pass_org_var) )

                                    

            

                        while (1)

                        {

                                    self waittill ("trigger");

                                    

                                    if ( 1000 < lengthsquared( level.player getplayervelocity() ) )

                                    

                                    {

 

                                                grass_pass_org_var playsound ("folaige_passthru");

                                                //iprintlnbold ("SOUND: grass_pass down");

                                                level notify( "sound alert" );

 

                                                while ( level.player isTouching(self))

                                                {

                                                wait 0.1;

                                                }

                                                grass_pass_org_var playsound ("folaige_passthru");

                                                //iprintlnbold ("SOUND: grass_pass up");

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


floor_creak_one()

{

            floor_creak_trigger_1_var = GetEnt("floor_creak_trigger", "targetname");
            floor_creak_org_1_var = GetEnt("floor_creak_org", "targetname");

            

            //level endon ("insert_notify");

            

            if ( IsDefined(floor_creak_trigger_1_var) && IsDefined(floor_creak_org_1_var) )

                                    

            

                        while (1)

                        {

                                    floor_creak_trigger_1_var waittill ("trigger");

                                    if ( 2000 < lengthsquared( level.player getplayervelocity() ) )         // won’t play if player is moving really slowly.  

                                    

                                    {

 

                                                floor_creak_org_1_var playsound ("wood_creak_floor");

                                                //iprintlnbold ("SOUND: floor creak down");

                                                level notify( "sound alert" );

                                                //thug_ears_1();

 

                                                while ( level.player isTouching(floor_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                                floor_creak_org_1_var playsound ("wood_creak_floor");        // use this if you want a key-off

                                                //iprintlnbold ("SOUND: floor creak up");

                                    }
                                    

                                    else

                                    {

                                                //iprintlnbold("too soft!");

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

            

            //level endon ("insert_notify");

            

            if ( IsDefined(floor_creak_trigger_1_var) && IsDefined(floor_creak_org_1_var) )

                                    

            

                        while (1)

                        {

                                    floor_creak_trigger_1_var waittill ("trigger");

                                    if ( 2000 < lengthsquared( level.player getplayervelocity() ) )         // won’t play if player is moving really slowly.  

                                    

                                    {

 

                                                floor_creak_org_1_var playsound ("wood_creak_floor");

                                                //iprintlnbold ("SOUND: floor creak down");

                                                level notify( "sound alert" );

                                                //thug_ears_1();

 

                                                while ( level.player isTouching(floor_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                                floor_creak_org_1_var playsound ("wood_creak_floor");        // use this if you want a key-off

                                                //iprintlnbold ("SOUND: floor creak up");

                                    }
                                    

                                    else

                                    {

                                                //iprintlnbold("too soft!");

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

            

            //level endon ("insert_notify");

            

            if ( IsDefined(stairs_creak_trigger_1_var) && IsDefined(stairs_creak_org_1_var) )

                                    

            

                        while (1)

                        {

                                    stairs_creak_trigger_1_var waittill ("trigger");

                                    if ( 2000 < lengthsquared( level.player getplayervelocity() ) )         // won’t play if player is moving really slowly.  

                                    

                                    {

 

                                                stairs_creak_org_1_var playsound ("wood_creak_stairs");

                                                //iprintlnbold ("SOUND: stairs creak down");

                                                level notify( "sound alert" );

                                                //thug_ears_1();

 

                                                while ( level.player isTouching(stairs_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                                stairs_creak_org_1_var playsound ("wood_creak_stairs");        // use this if you want a key-off

                                                //iprintlnbold ("SOUND: floor creak up");

                                    }
                                    

                                    else

                                    {

                                                //iprintlnbold("too soft!");

                                                while ( level.player isTouching(stairs_creak_trigger_1_var))

                                                {

                                                wait 0.1;

                                                }

                                    }
                                              

                        }

                        

 

            

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



//************ wood fence ************

wood_fence()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("wood_fence_bump");
				//iprintlnbold ("SOUND: wood_fence rustle");
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


//************ barrel ************

barrel()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("barrel_bump");
				//iprintlnbold ("SOUND: barrel");
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


//************ radio ************

radio_loop()
{

	self playloopsound ("radio");

}	

	
radio_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: stop ticking");
	self stoploopsound();	
}



/*

//	level endon ("stop_barge_ext");
//	level thread stop_barge_ext_sounds();
		
	
*/	
	





