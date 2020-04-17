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
//Casino_Int_1shot
//***************   

            declareAmbientPackage( "Casino_Int_1shot" );       

                        //addAmbientElement( "Casino_Int_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Casino_Int_1shot", "amb_boats", 6, 45, 500, 1000 );
 


           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 
//***************
//Casino_Int_Tone
//***************

            declareAmbientRoom( "Casino_Int_Tone" );

                        setAmbientRoomTone( "Casino_Int_Tone", "bgt_casino_int_1",.5, .5 );
                        setAmbientRoomReverb( "Casino_Int_Tone", "carpetedhallway", 1, .3 );
  
  
//***************
//Casino_Ballroom_Tone
//***************

            declareAmbientRoom( "Casino_Ballroom_Tone" );

                        setAmbientRoomTone( "Casino_Ballroom_Tone", "bgt_casino_int_2",.5, .5  );
                        setAmbientRoomReverb( "Casino_Ballroom_Tone", "auditorium", 1, .1 );	
  
  
//***************
//Casino_Small_Room_Tone
//***************

            declareAmbientRoom( "Casino_Small_Room_Tone");

                        setAmbientRoomTone( "Casino_Small_Room_Tone", "bgt_casino_int_3",.5, .5  );
                        setAmbientRoomReverb( "Casino_Small_Room_Tone", "room", 1, .1 );

//***************
//Casino_Small_Room_Tone_Glitch
//***************

            declareAmbientRoom( "Casino_Small_Room_Tone_Glitch");

                        setAmbientRoomTone( "Casino_Small_Room_Tone_Glitch", "bgt_casino_int_3g",.5, .5  );
                        setAmbientRoomReverb( "Casino_Small_Room_Tone_Glitch", "room", 1, .1 );
                        
//***************
//Bathroom_Tone
//***************

            declareAmbientRoom( "Bathroom_Tone" );

                        setAmbientRoomTone( "Bathroom_Tone", "bgt_casino_int_3",.5, .5  );                         
    
                        	setAmbientRoomReverb( "Bathroom_Tone", "bathroom", 1, .1 );   
    
//***************
//Casino_Spa_Room_Tone
//***************

            declareAmbientRoom( "Casino_Spa_Room_Tone" );

                        setAmbientRoomTone( "Casino_Spa_Room_Tone", "bgt_casino_int_4",.5, .5  );  
                        
                        	setAmbientRoomReverb( "Casino_Spa_Room_Tone", "stoneroom", 1, .7 );
                        
                        
//************************************
//Casino_Sauna_Room_Tone
//***************

            declareAmbientRoom( "Casino_Sauna_Room_Tone" );

                        setAmbientRoomTone( "Casino_Sauna_Room_Tone", "bgt_casino_int_5", .4, 1 ); 
                        
                        	setAmbientRoomReverb( "Casino_Sauna_Room_Tone", "stoneroom", 1, .6 );
                        	
//***************
//Casino_Sauna_Small_Room_Tone
//***************

            declareAmbientRoom( "Casino_Sauna_Small_Room_Tone" );

                        setAmbientRoomTone( "Casino_Sauna_Small_Room_Tone", "bgt_casino_int_5" ,.5, .5  ); 
                        
                 		setAmbientRoomReverb( "Casino_Sauna_Small_Room_Tone", "bathroom", 1, .1 );   
                        
    
//***************
//Casino_Ext_Adj_Room_Tone
//***************

            declareAmbientRoom( "Casino_Ext_Adj_Room_Tone" );

                        setAmbientRoomTone( "Casino_Ext_Adj_Room_Tone", "bgt_casino_int_6" ,.5, .5 ); 
                        setAmbientRoomReverb( "Casino_Ext_Adj_Room_Tone", "room", 1, .1 );

//***************
//Casino_Ext_Adj_Verb_Room_Tone
//***************

            declareAmbientRoom( "Casino_Ext_Adj_Verb_Room_Tone" );

                        setAmbientRoomTone( "Casino_Ext_Adj_Verb_Room_Tone", "bgt_casino_int_7",.5, .5  );       
 
                          	setAmbientRoomReverb( "Casino_Ext_Adj_Verb_Room_Tone", "stonecorridor", 1, .2 );    
      
//***************
//Casino_Locker_Room_Tone
//***************

            declareAmbientRoom( "Casino_Locker_Room_Tone" );

                        setAmbientRoomTone( "Casino_Locker_Room_Tone", "bgt_casino_int_3" ,.5, .5 );                          
 

 //***************
 //Casino_Vent_Tone
 //***************
 
             declareAmbientRoom( "Casino_Vent_Tone" );
 
                        setAmbientRoomTone( "Casino_Vent_Tone", "bgt_casino_vent_1" ,.5, .5 );  
                        
                        	setAmbientRoomReverb( "Casino_Vent_Tone", "sewerpipe", 1, .3 );                        
    
 
//***************
//Casino_Ext_Tone
//***************

            declareAmbientRoom( "Casino_Ext_Tone" );

                        setAmbientRoomTone( "Casino_Ext_Tone", "bgt_casino_ext_1" ,.5, .5 );
                        setAmbientRoomReverb( "Casino_Ext_Tone", "parkinglot", 1, .1 );
        
        
//***************
//Casino_Courtyard_Tone
//***************

            declareAmbientRoom( "Casino_Courtyard_Tone" );

                        setAmbientRoomTone( "Casino_Courtyard_Tone", "bgt_casino_ext_2" ,.5, .5 );  
                        
                        	setAmbientRoomReverb( "Casino_Courtyard_Tone", "stonecorridor", 1, .2 );
                        	
 //***************
 //Casino_Stairs_Tone
 //***************
 
             declareAmbientRoom( "Casino_Stairs_Tone" );
 
                        setAmbientRoomTone( "Casino_Stairs_Tone", "bgt_casino_vent_1" ,.5, .5 );  
                        
                        	setAmbientRoomReverb( "Casino_Stairs_Tone", "sewerpipe", 1, .25 );                           	
                        
                    
            

//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            setBaseAmbientPackageAndRoom( "Casino_Int_1shot", "Casino_Int_Tone" );

			signalAmbientPackageDeclarationComplete();
 



//*************************************************************************************************

//                                              STATIC LOOPS

//*************************************************************************************************

	//Elevator music
	loopSound("elevator_music", (-974, 893, 803), 41.072);
	
	//Soda machines
	loopSound("soda_machines", (-3101, 3007, 787), 1.385);	
	
	loopsound("bgt_casino_ext_1_transition", (380, 887, 772), 20.00);
	loopsound("bgt_casino_ext_1_transition", (380, 1659, 772), 20.00);
	
	//Ice Machine
	loopSound("ice_machine", (-3159, 2884, 797), 2.422);
	
	//Grandfather Clock
	loopSound("grandfather_clock", (-513, 953, 748), 4.797);
	
	//Radiator A1
	loopSound("radiator", (312, 1850, 733), 13.784);	
	
	//Radiator A2
	loopSound("radiator", (231, 1162, 733), 13.784);

	//Radiator B
	loopSound("radiator", (-2776, 2328, 757), 13.784);
	
	//Water Cooler A
	//loopSound("water_coolers", (175, 750, 731), 3.862);	
	
	//Water Cooler B
	loopSound("water_coolers", (-3329, 2932, 763), 3.862);	
	
	//Sauna_Occluded Hallway
	loopSound("sauna_occluded", (-417, 1657, 771), 7.146);

	//Sauna_Occluded Locker room
	loopSound("sauna_occluded", (-837, 2187, 771), 7.146);	
		
	//Wind A
	loopSound("wind_A", (739, 890, 769), 52.163);	
	
	//Wind B
	loopSound("wind_B", (796, 1627, 770) , 59.621);	
	
	//Toilet Running
	loopSound("toilet_run", (166, 2067, 730), 4.914);	
	
	//Fluorescent Lights A
	//loopSound("fluorescent_lights", (-193, 2226, 830), 6.841);
	
	//Fluorescent Lights Faulty
	loopSound("fluorescent_lights_faulty", (-155, 2043, 808), 6.834);	
	
	//Fluorescent Lights B
	loopSound("fluorescent_lights", (-3506, 2898, 860), 6.841);	

	//Curtain suite A
	loopSound("curtain", (305, 1655, 809), 27.678);	
	
	//Curtain suite B
	loopSound("curtain", (-2898, 2327, 831) , 27.678);		
			
	//Vent A Air
	loopSound("vent_air", (-663, 2278, 872), 2.827);	
	
	//Vent B Air
	loopSound("vent_air", (-633, 1659, 888), 2.827);
	
	//Vent A Rattle
	//loopSound("vent_rattle", (-663, 2278, 872), 12.076);	
	
	//Vent B Rattle
	//loopSound("vent_rattle", (-633, 1659, 888), 12.076);	
	
	//Crickets 1
	//loopSound("crickets_01", (1277, 1008, 16), 1.977);
	//Crickets 2
	//loopSound("crickets_02", (1348, 1257, 25), 3.496);
	//Crickets 3
	//loopSound("crickets_03", (1361, 1694, 12), 7.378); 
	
	//Fountain
	//loopSound("fountain", (-2887, 1637, 122), 11.632);	
	
	//Ballroom Fridge
	loopSound("ice_machine", (-5209, 1206, 673), 2.422);
	
	//Ball Door lockpick hum
	//loopSound("ball_door_hum", (-3663, 1802, 805), 1.409);	
	

	

// VENT FANS
	
	//Vent Fan 1 (up)
	loopSound("vent_fan_A", (-679, 2261, 983), 10.800);
	
	//Vent Fan 2
	loopSound("vent_air", (-573, 2374, 920), 2.827);
	
	//Vent Fan 3
	loopSound("vent_fan_D", (-669, 2482, 931), 9.806);
	
	//Vent Fan 4 (up)
	loopSound("vent_fan_B", (-866, 2374, 996), 8.617);
	
	//Vent Fan 5
	loopSound("vent_fan_C", (-1016, 2617, 856), 7.383);
	
	//Vent Fan 6
	loopSound("vent_fan_D", (-1371, 2624, 886), 9.806);
	
	//Vent Fan 7 (up)
	loopSound("vent_fan_D", (-1357, 2538, 966), 9.806);
	
	//Vent Fan 8 (far)
	loopSound("vent_fan_A", (-1573, 2542, 884), 10.800);
	
	//Vent Fan 9
	loopSound("vent_fan_B", (-743, 2069, 923), 8.617);
	
	//Vent Fan 10 (up)
	loopSound("vent_fan_A", (-591, 1840, 964), 10.800);
	
	//Vent Fan 11
	loopSound("vent_fan_B", (-578, 1593, 927), 8.617);
	
	
// VENT OPENINGS

// Steam
	//Vent Opening 1
	loopSound("vent_opening_steam", (-939, 2340, 848), 130.568);
	
	//Vent Opening 2
	loopSound("vent_opening_steam", (-1197, 2502, 846) , 130.568);
	
	//Vent Opening 3 (down)
	loopSound("vent_opening_steam", (-1374, 2276, 887), 130.568);
	
	
// Pools

	//Vent Opening 4
	loopSound("vent_opening_pool", (-1370, 2031, 912), 41.770);
	
	//Vent Opening 5
	loopSound("vent_opening_pool", (-941, 2031, 915), 41.770);
	
	//Vent Opening 6
	loopSound("vent_opening_pool", (-848, 1944, 914), 41.770);
	


	
// STEAM ROOM - Openings to Pool

	//Room Opening 1
	loopSound("sauna_opening_steam", (-939, 2045, 735) , 130.568); 
	
	//Room Opening 2
	loopSound("sauna_opening_steam", (-1369, 2045, 735) , 130.568);
	
	//Room Opening 3
	loopSound("sauna_opening_steam", (-1801, 2045, 735), 130.568); 
	
	
	
//POOL WATERFALLS

	//Waterfall L1
	//loopSound("Waterfall_A", (-1151, 1471, 731), 11.484);	

	//Waterfall R1
	//loopSound("Waterfall_B", (-1150, 1842, 727), 9.672);
	
	//Waterfall L2
	//loopSound("Waterfall_B", (-1588, 1465, 726), 9.672);
	
	//Waterfall R2
	//loopSound("Waterfall_A", (-1583, 1841, 725), 11.484);	
	
//SPARKING MONITOR

	loopSound("sparky", (-698, 1601, 708), 11.051);		



//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************

  	    elevator_moving_play(); 
  	    

  	    level thread elevator_counter_reset();
  	    
  	    level thread elevator_emergency_button(); 
  	    level thread elevator_alarm(); 
  	   
  	    array_thread(GetEntArray("luggage_cart_trigger", "targetname"), ::luggage_cart);
  	    array_thread(GetEntArray("service_cart_trigger", "targetname"), ::service_cart);
  	    array_thread(GetEntArray("plant_trigger", "targetname"), ::plant);
  	    array_thread(GetEntArray("cabinet_trigger", "targetname"), ::cabinet);
  	    array_thread(GetEntArray("floor_creak_trigger", "targetname"), ::floor_creak);
  	    array_thread(GetEntArray("elevator_wall_trigger", "targetname"), ::elevator_wall);


	    level thread cathedral_bells_play();
	    
	    level thread parked_car_damage();
	    level thread parked_car_damage_2();
	    level thread parked_car_damage_3();
	    level thread parked_car_damage_4();
	    level thread parked_car_damage_5();
	    
	    level thread piano_damage();
	    
	    level thread bed_jump();
	    
	    level thread ice_machine_play();
	    
	    level thread vent_climb_play();	    
	    
 	    ballroom_lockpick_play();	 
	    
	    //Level thread ext_transition_play();
	    
	    level thread phone_play();
 
 	    vent_rattle_locker_play();
 	    
  	    vent_rattle_spa_play();  
  	    
  	    tv_static_play(); 
  	    
   	    radio_play();  
   	    
   	    level thread radio_damage(); 
   	    
   	    level thread waterfall_play();
   	    
   	    //radio_room_play(); 
	
}

 
//*************************************************************************************************

 

//                                              Functions

 

//*************************************************************************************************



cathedral_bells_play()
{
	cathedral_bells_trigger_var = GetEnt("cathedral_bells_trigger", "targetname");
	cathedral_bells_org_var = GetEnt("cathedral_bells_org", "targetname");
	
	//level endon ("insert_notify");
	if ( IsDefined(cathedral_bells_trigger_var) && IsDefined(cathedral_bells_org_var) )
	{
		while (1)
		{
			cathedral_bells_trigger_var waittill ("trigger");
			cathedral_bells_org_var playsound ("cath_bells");
			//iprintlnbold ("bells trigger");
			
			
		}
	}
	
}




floor_creak()
{
	
	floor_creak_org_var = GetEnt(self.target, "targetname");
	
	//level endon ("insert_notify");
	
	if ( IsDefined(floor_creak_org_var) )
			
	
		while (1)
		{
			self waittill ("trigger");
			
			if ( 1000 < lengthsquared( level.player getplayervelocity() ) )
			
			{

				floor_creak_org_var playsound ("floor_creak_down");
				//iprintlnbold ("SOUND: floor creak down");
				level notify( "sound alert" );

				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
				floor_creak_org_var playsound ("floor_creak_up");
				//iprintlnbold ("SOUND: floor creak up");
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

thug_ears()
{
	
	level.patroller_ears endon ("damage");
	level.patroller_ears endon ("death");
	level.patroller_ears endon ("alert_yellow");
	

//	removed 7/29/08 AlexP
//
//
//	if (IsDefined(level.patroller_ears))
//	
//	while(1)
//	{
//			level waittill("sound alert");
//			wait 1.0;
//			level.patroller_ears cmdaction( "scratch" );
//			level.patroller_ears setalertstatemin("alert_green");
//			level.patroller_ears notify( "event_threat", "NoticeBond", 1000, -1 );
//			
//			wait 10.0;
//			level.patroller_ears notify( "event_threat", "InvalidateBond", 1000, -1 );
//			level.patroller_ears cmdaction( "scratch" );
//			level.patroller_ears StartPatrolRoute("cpat_e1_start2");
//	}
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


//*************************************** bed spring *********************************************************

bed_jump()
{
	sound_bed_spring_trigger_var = GetEnt("sound_bed_spring_trigger", "targetname");
	sound_bed_spring_org_var = GetEnt("sound_bed_spring_org", "targetname");
	

	
	//level endon ("insert_notify");
	
	if ( IsDefined(sound_bed_spring_trigger_var) && IsDefined(sound_bed_spring_org_var) )
			

		while (1)
		{
			sound_bed_spring_trigger_var waittill ("trigger");
			
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				sound_bed_spring_org_var playsound ("bed_jump");
				//iprintlnbold ("SOUND: Bed Jump");
				while ( level.player isTouching(sound_bed_spring_trigger_var))
				{
				wait 0.1;
				}
			}
			
			else
			{
				//iprintlnbold("too soft!");
				while ( level.player isTouching(sound_bed_spring_trigger_var))
				{
				wait 0.1;
				}
			}

				
		}


				
}

//***************************************************************************************************************
//
// JRB Elevator Sounds
//
//***************************************************************************************************************

elevator_moving_play()
{
	elevator_moving_org_var = GetEnt("elevator_moving_org", "targetname");
	if ( IsDefined(elevator_moving_org_var))
	{
		elevator_moving_org_var playloopsound ("CAS_elevator_moving");
	}
}	


elevator_moving_stop()
{
	elevator_moving_org_var = GetEnt("elevator_moving_org", "targetname");
	
	elevator_moving_org_var stoploopsound();	
}






elevator_wall()
{
	
	elevator_wall_org_var = GetEnt(self.target, "targetname");
	elevator_floor_org_var = GetEnt("elevator_wall_org_4", "targetname");
	elejump_count = 1;
	
	//level endon ("insert_notify");
	
	if ( IsDefined(elevator_wall_org_var) )
			
	
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
					if (elevator_wall_org_var == elevator_floor_org_var)
					{

						if (elejump_count == 10)
						{
							//iprintlnbold ("ele_jump ALARM ", elejump_count);
							level notify( "elevator alarm" );
							level notify( "sound alert" );
							elejump_count = 1;
						}

						else
						{		
							elevator_wall_org_var playsound ("elevator_shake");
							//iprintlnbold ("SOUND: Floor Shake, jump number: ", elejump_count);
							elejump_count = elejump_count + 1;

								while ( level.player isTouching(self))
								{
								wait 0.1;
								}
						}
					}

					else
					{			
						elevator_wall_org_var playsound ("elevator_shake");
						//iprintlnbold ("SOUND: wall shake");
							while ( level.player isTouching(self))
							{
								wait 0.1;
							}
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


elevator_alarm()
{

	audio_elevator_alarm_var = GetEnt("elevator_moving_org", "targetname");
	
	
		while(1)
		{
			level waittill("elevator alarm");
			level notify( "noise_trigger_alarm" );	
			audio_elevator_alarm_var playloopsound ("elevator_alarm",.5);
			wait 15.1;
			audio_elevator_alarm_var stoploopsound();
		}
	
	
}



elevator_counter_reset()
{

	audio_elevator_trigger_var = GetEnt("audio_elevator_trigger", "targetname");

	if (IsDefined(audio_elevator_trigger_var))
	
		while (1)
		{
			audio_elevator_trigger_var waittill ("trigger");
			elejump_count = 1;
			//iprintlnbold ("ele_jump RESET ", elejump_count);
				while ( level.player isTouching(audio_elevator_trigger_var))
				{
				wait 0.1;
				}
		}
			
}


elevator_emergency_button()
{
	elevator_emergency_button_var = GetEnt("elevator_emergency_button", "targetname");
	audio_elevator_alarm_var = GetEnt("elevator_moving_org", "targetname");
	
	//level endon ("insert_notify");
	
	if ( IsDefined(elevator_emergency_button_var) && IsDefined(audio_elevator_alarm_var) )
			
	
		while (1)
		{
			elevator_emergency_button_var waittill ("trigger");
			level notify( "noise_trigger_alarm" );	
			audio_elevator_alarm_var playloopsound ("elevator_alarm",.5);
			wait 15.1;
			audio_elevator_alarm_var stoploopsound();
		}
		


	
}



//***********************************************************************************************
//
//  Jerry's Parked Car Alarm homage to Casino Royale
//
//***********************************************************************************************

parked_car_damage()
{
	parked_car_trigger_1_var = GetEnt("parked_car_trigger_1", "targetname");
	parked_car_org_1_var = GetEnt("parked_car_org_1", "targetname");
	

	
	//level endon ("insert_notify");
	
	if ( IsDefined(parked_car_trigger_1_var) && IsDefined(parked_car_org_1_var) )
			
	
		while (1)
		{
			parked_car_trigger_1_var waittill ("trigger");
			parked_car_org_1_var playloopsound ("car_alarm_1");
			//iprintlnbold ("parked car alarm 1");
			wait 15.0;
			parked_car_org_1_var stoploopsound();
			//iprintlnbold ("Stopped parked car alarm 1");
			
		}
				
}

parked_car_damage_2()
{
	parked_car_trigger_2_var = GetEnt("parked_car_trigger_2", "targetname");
	parked_car_org_2_var = GetEnt("parked_car_org_2", "targetname");
	
	
	if ( IsDefined(parked_car_trigger_2_var) && IsDefined(parked_car_org_2_var))
			
	
		while (1)
		{
			parked_car_trigger_2_var waittill ("trigger");
			parked_car_org_2_var playloopsound ("car_alarm_2");
			//iprintlnbold ("parked car alarm 2");
			wait 15.0;
			parked_car_org_2_var stoploopsound();
			//iprintlnbold ("Stopped parked car alarm 2");
			
		}
			
}

parked_car_damage_3()
{
	parked_car_trigger_3_var = GetEnt("parked_car_trigger_3", "targetname");
	parked_car_org_3_var = GetEnt("parked_car_org_3", "targetname");
	
	
	if ( IsDefined(parked_car_trigger_3_var) && IsDefined(parked_car_org_3_var) )
			
	
		while (1)
		{
			parked_car_trigger_3_var waittill ("trigger");
			parked_car_org_3_var playloopsound ("car_alarm_3");
			level.thug_tv_ears setalertstatemin("alert_yellow");
			//iprintlnbold ("parked car alarm 3");
			wait 15.0;
			parked_car_org_3_var stoploopsound();
			//iprintlnbold ("Stopped parked car alarm 3");
			
		}
	
}


parked_car_damage_4()
{
	parked_car_trigger_4_var = GetEnt("parked_car_trigger_4", "targetname");
	parked_car_org_4_var = GetEnt("parked_car_org_4", "targetname");
	
	
	if ( IsDefined(parked_car_trigger_4_var) && IsDefined(parked_car_org_4_var) )
			
	
		while (1)
		{
			parked_car_trigger_4_var waittill ("trigger");
			parked_car_org_4_var playloopsound ("car_alarm_4");
			//iprintlnbold ("parked car alarm 4");
			wait 15.0;
			parked_car_org_4_var stoploopsound();
			//iprintlnbold ("Stopped parked car alarm 4");
			
		}

	
}

parked_car_damage_5()
{
	parked_car_trigger_5_var = GetEnt("parked_car_trigger_5", "targetname");
	parked_car_org_5_var = GetEnt("parked_car_org_5", "targetname");
	
	
	if ( IsDefined(parked_car_trigger_5_var) && IsDefined(parked_car_org_5_var) )
			
	
		while (1)
		{
			parked_car_trigger_5_var waittill ("trigger");
			parked_car_org_5_var playloopsound ("car_alarm_5");
			//iprintlnbold ("parked car alarm 5");
			wait 15.0;
			parked_car_org_5_var stoploopsound();
			//iprintlnbold ("Stopped parked car alarm 5");
			
		}

	
}


chand_damage()
{
	chand_trigger_1_var = GetEnt("chand_trigger_1", "targetname");
	chand_org_1_var = GetEnt("chand_org_1", "targetname");

	
	//level endon ("insert_notify");
	
	if ( IsDefined(chand_trigger_1_var) && IsDefined(chand_org_1_var) )
			
	
		while (1)
		{
			chand_trigger_1_var waittill ("trigger");
			
			
			chand_org_1_var playsound ("ice_machine_settle");
			//iprintlnbold ("chand swing 1");				
		}
		


	
}	


piano_damage()
{
	piano_damage_trigger_var = GetEnt("piano_damage_trigger", "targetname");
	piano_damage_org_var = GetEnt("piano_damage_org", "targetname");


	if ( IsDefined(piano_damage_trigger_var) && IsDefined(piano_damage_org_var) )
	
		while (1)
		{
			piano_damage_trigger_var waittill ("trigger");
			piano_damage_org_var playsound ("piano_damage");
		}
	
	
}


	
ice_machine_play()
{
	ice_machine_trigger_var = GetEnt("ice_machine_trigger", "targetname");
	ice_machine_org_var = GetEnt("ice_machine_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(ice_machine_trigger_var) && IsDefined(ice_machine_org_var) )
	{
		while (1)
		{
			ice_machine_trigger_var waittill ("trigger");
			ice_machine_org_var playsound ("ice_machine_settle");
		}
	}
	
}


vent_climb_play()
{
	vent_climb_trigger_var = GetEnt("vent_climb_trigger", "targetname");
	vent_climb_org_var = GetEnt("vent_climb_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(vent_climb_trigger_var) && IsDefined(vent_climb_org_var) )
	{
		while (1)
		{
			vent_climb_trigger_var waittill ("trigger");
			vent_climb_org_var playsound ("vent_climb");
		}
	}
	
}


phone_play()
{
	phone_trigger_var = GetEnt("phone_trigger", "targetname");
	phone_org_var = GetEnt("phone_org", "targetname");
	
	level endon ("insert_notify");
	if ( IsDefined(phone_trigger_var) && IsDefined(phone_org_var) )
	{
		while (1)
		{
			phone_trigger_var waittill ("trigger");
			phone_org_var playsound ("phone");
		}
	}
	
}


vent_rattle_locker_play()
{
	vent_rattle_locker_org_var = GetEnt("vent_rattle_locker_org", "targetname");
	if ( IsDefined(vent_rattle_locker_org_var))
	{
		vent_rattle_locker_org_var playloopsound ("vent_rattle_locker");
	}
}	


vent_rattle_locker_stop()
{
	vent_rattle_locker_org_var = GetEnt("vent_rattle_locker_org", "targetname");
	
	vent_rattle_locker_org_var stoploopsound();	
}


vent_rattle_spa_play()
{
	vent_rattle_spa_org_var = GetEnt("vent_rattle_spa_org", "targetname");
	if ( IsDefined(vent_rattle_spa_org_var))
	{
		vent_rattle_spa_org_var playloopsound ("vent_rattle_spa");
	}
}	


vent_rattle_spa_stop()
{
	vent_rattle_spa_org_var = GetEnt("vent_rattle_spa_org", "targetname");
	
	vent_rattle_spa_org_var stoploopsound();	
}

tv_static_play()
{
	tv_static_org_var = GetEnt("tv_static_org", "targetname");
	if ( IsDefined(tv_static_org_var))
	{
		tv_static_org_var playloopsound ("tv_static");
	}
}	


tv_static_stop()
{
	tv_static_org_var = GetEnt("tv_static_org", "targetname");
	
	tv_static_org_var stoploopsound();	
}


radio_play()
{
	radio_org_var = GetEnt("radio_org", "targetname");
	if ( IsDefined(radio_org_var))
	{
		radio_org_var playloopsound ("radio");
	}
}	


radio_stop()
{
	radio_org_var = GetEnt("radio_org", "targetname");
	
	radio_org_var stoploopsound();	
}



radio_damage()
{
	radio_damage_trigger_var = GetEnt("radio_damage_trigger", "targetname");
	radio_damage_org_var = GetEnt("radio_damage_org", "targetname");
	radio_org_var = GetEnt("radio_org", "targetname");

	
	//level endon ("insert_notify");
	
	if ( IsDefined(radio_damage_trigger_var) && IsDefined(radio_damage_org_var) )
			
	
		while (1)
		{
			radio_damage_trigger_var waittill ("trigger");
			radio_damage_org_var playsound ("ui_pause_on");
			//iprintlnbold ("radio damage");	
			radio_org_var stoploopsound();
			
		}	
}	





radio_room_play()
{
	radio_room_org_var = GetEnt("radio_room_org", "targetname");
	if ( IsDefined(radio_room_org_var))
	{
		radio_room_org_var playloopsound ("radio_room");
	}
}	


radio_room_stop()
{
	radio_room_org_var = GetEnt("radio_room_org", "targetname");
	
	radio_room_org_var stoploopsound();	
}


waterfall_play()
{
	sound_waterfall_zone_var = GetEnt("sound_waterfall_zone", "targetname");
	sound_spa_trigger_var = GetEnt("sound_spa_trigger", "targetname");
	
	//if ( IsDefined(sound_waterfall_zone_var) && IsDefined(sound_spa_trigger_var) ) 
	
	while (1)
	{
		sound_spa_trigger_var waittill ("trigger");
		sound_waterfall_zone_var playloopsound ("Waterfall_A");
	}
}


ballroom_lockpick_play()
{
	ballroom_lockpick_org_var = GetEnt("ballroom_lockpick_org", "targetname");
	if ( IsDefined(ballroom_lockpick_org_var))
	{
		ballroom_lockpick_org_var playloopsound ("ball_door_hum");
	}
}	


ballroom_lockpick_stop()
{	

	//flag_wait( "obj_unlock_entrance_end" );	
	ballroom_lockpick_org_var = GetEnt("ballroom_lockpick_org", "targetname");
	ballroom_lockpick_org_var stoploopsound();	
}



thug_ears_1()
{
	level.player endon("death");
	
	{
		while(true)
			{
			level waittill( "noise_trigger_alarm" );
			
			guard1_target = spawn( "script_origin", level.player.origin);
			
	
			if(IsDefined(level.patroller_ears))
			{	
				level.patroller_ears animscripts\shared::placeWeaponOn( level.patroller_ears.weapon, "right" );
				level.patroller_ears stoppatrolroute();
				level.patroller_ears CmdAction ( "scan");
			}			
			wait(1.5);
			if(IsDefined(level.patroller_ears))
			{			
				level.patroller_ears stopallcmds();
	
				level.patroller_ears setscriptspeed( "jog" );
				level.patroller_ears addengagerule( "tgtPerceive" );
				level.patroller_ears setgoalpos( guard1_target.origin );
	
				level.patroller_ears waittill( "goal" );
				level.patroller_ears CmdAction ( "scan");
				level.patroller_ears setscriptspeed( "walk" );
			}			
			wait(5.0);
			if(IsDefined(level.patroller_ears))
			{
				level.patroller_ears stopallcmds();
				level.patroller_ears animscripts\shared::placeWeaponOn( level.patroller_ears.weapon, "right" );
				level.patroller_ears startpatrolroute("cpat_e1_start2");
			}
			
			//wait to reset trigger.
			wait(10);
		}	
	}
}