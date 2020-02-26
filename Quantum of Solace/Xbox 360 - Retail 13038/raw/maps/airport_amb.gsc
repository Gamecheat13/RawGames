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
//Airport_Int_1shot
//***************   

            declareAmbientPackage( "Airport_Int_1shot" );       

                        //addAmbientElement( "Airport_Int_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Airport_Int_1shot", "amb_boats", 6, 45, 500, 1000 );
 
//***************
//airport_int_pkg
//***************   

            declareAmbientPackage( "airport_int_pkg" );       

                        //addAmbientElement( "Airport_Int_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Airport_Int_1shot", "amb_boats", 6, 45, 500, 1000 );
			
//***************
//airport_ext_atrium_pkg
//***************   

            declareAmbientPackage( "airport_ext_atrium_pkg" );       

                        //addAmbientElement( "Airport_Int_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Airport_Int_1shot", "amb_boats", 6, 45, 500, 1000 );			


           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 
//***************
//Airport_Int_Tone
//***************

            declareAmbientRoom( "Airport_Int_Tone" );

                        setAmbientRoomTone( "Airport_Int_Tone", "bgt_airport_int_1",.2, .2  );                
                        setAmbientRoomReverb( "Airport_Int_Tone", "hallway", 1, .1 );
                        
                        
//***************
//airport_int_room
//***************

            declareAmbientRoom( "airport_int_room");

                        setAmbientRoomTone( "airport_int_room", "bgt_airport_int_officeSmall",.2, .2 );
                        setAmbientRoomReverb( "airport_int_room", "room", 1, .1 );
                        
                        
                        
//***************************
//airport_int_download_room_1
//***************************

            declareAmbientRoom( "airport_int_download_room_1" );

                        setAmbientRoomTone( "airport_int_download_room_1", "bgt_airport_int_download_1",.2, .2 ); 
                        setAmbientRoomReverb( "airport_int_download_room_1", "room", 1, .1 );
                        

 //***************
 //airport_ext_atrium_room
 //***************
 
             declareAmbientRoom( "airport_ext_atrium_room" );
 
                           setAmbientRoomTone( "airport_ext_atrium_room", "bgt_airport_ext_atrium",.2, .2  );
                           setAmbientRoomReverb( "airport_ext_atrium_room", "forest", 1, .1 );

 //***************
 //airport_int_server_room
 //***************
 
             declareAmbientRoom( "airport_int_server_room" );
 
                     
                        setAmbientRoomTone( "airport_int_server_room", "bgt_airport_int_server",.2, .2  );
                        setAmbientRoomReverb( "airport_int_server_room", "stoneroom", 1, .1 );


            
 //***************
 //airport_int_baggage_room
 //***************
 
             declareAmbientRoom( "airport_int_baggage_room" );
 
                        setAmbientRoomTone( "airport_int_baggage_room", "bgt_airport_baggage_1",.2, .2  );
                        setAmbientRoomReverb( "airport_int_baggage_room", "hangar", 1, .3 );
                        
  //***************
//airport_int_van_room
//***************

            declareAmbientRoom( "airport_int_van_room");

                        setAmbientRoomTone( "airport_int_van_room", "bgt_airport_int_officeSmall",.1, .1 );
                        setAmbientRoomReverb( "airport_int_van_room", "stonecorridor", 1, .2 );                      
                        
                        
                        

//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            setBaseAmbientPackageAndRoom( "Airport_Int_1shot", "Airport_Int_Tone" );

			signalAmbientPackageDeclarationComplete();
 
//*************************************************************************************************
//                                              Static Loops
//*************************************************************************************************

 	//monitor static
	loopSound("amb_static", (-750.5, -57, 260),.945);
	loopSound("amb_static", (-870.5, -39, 260),.945);
	
	//fridge
	loopSound("amb_fridge", (-242, 671, 188),2.428);
	
	//lightbuzz
	loopSound("amb_light_buzz", (-693.5, 1014.5, 181),.008);
	
	loopSound("amb_light_buzz", (-2498.5, 2684, 181),.008);
	loopSound("amb_light_buzz", (-2499, 2743.5, 181),.008);
	
	//panel buzz
	loopSound("amb_panel_buzz", (-633, 935.5, 181),.005);
	
	//after_server to garage
	loopSound("amb_panel_buzz", (-2504, 2638, 83),.005);
	loopSound("amb_panel_buzz", (-2379, 2738.5, 83),.005);
	loopSound("amb_panel_buzz", (-2379.5, 2761, 83),.005);
	
	//baggage room
	loopSound("amb_panel_buzz", (-1020, 5753, 47),.005);
	
	//drinking fountain
	loopSound("amb_drinking_fountain", (-545, 2090.5, 90),46.890);
	
	//fans
	//loopSound("amb_fan_1", (-545, 2090.5, 90),46.890);
	
	//van idle
	loopSound("amb_vanIdle", (-2546, 3119, 76),2.028);
	
	
	
	
	
	
 

//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************


	// airplane_flyover_play(); 
	level thread door_knock();
	level thread door_knock_damage();
	
	//level thread catwalk_fires();
	
	array_thread(GetEntArray("fire_alarm", "targetname"), ::fire_alarm_loop);
	
	array_thread(GetEntArray("wand_woob_damage_trigger", "targetname"), ::wand_woob);
	array_thread(GetEntArray("wand_woob_damage_trigger", "targetname"), ::wand_woob_loop);
	array_thread(GetEntArray("wand_woob_damage_trigger", "targetname"), ::wand_woob_damage);
	
	array_thread(GetEntArray("flyover_trigger", "targetname"), ::flyovers);
	
	array_thread(GetEntArray("airport_pa_trigger", "targetname"), ::airport_pa);
	array_thread(GetEntArray("crowd_trigger", "targetname"), ::crowd);
	
	array_thread(GetEntArray("sound_sprinkler_drip", "targetname"), ::sprinkler_drip);
	array_thread(GetEntArray("sound_sprinkler_drop", "targetname"), ::sprinkler_drop);
	array_thread(GetEntArray("sound_sprinkler_drop", "targetname"), ::step_puddle);
	array_thread(GetEntArray("sound_sprinkler", "targetname"), ::sprinkler);
	
	array_thread(GetEntArray("water_tank", "targetname"), ::water_tank);
	array_thread(GetEntArray("water_tank", "targetname"), ::water_tank_loop);
	array_thread(GetEntArray("water_tank", "targetname"), ::water_tank_bump);
	
	array_thread(GetEntArray("sound_copier", "targetname"), ::copier_loop);
	
	array_thread(GetEntArray("clock_damage_trigger", "targetname"), ::clock_loop);
	array_thread(GetEntArray("clock_damage_trigger", "targetname"), ::clock_damage);
	
	array_thread(GetEntArray("pc_damage_trigger", "targetname"), ::pc_loop);
	array_thread(GetEntArray("pc_damage_trigger", "targetname"), ::pc_damage);
	
	array_thread(GetEntArray("phone_damage_trigger", "targetname"), ::phone_ring);
	array_thread(GetEntArray("phone_damage_trigger", "targetname"), ::phone_ring_damage);
	
	array_thread(GetEntArray("printer_trigger", "targetname"), ::printer_loop);
	array_thread(GetEntArray("printer_trigger", "targetname"), ::printer_damage);
	
	array_thread(GetEntArray("helicopter_wind", "targetname"), ::helicopter_wind);
	
	array_thread(GetEntArray("soda_trigger", "targetname"), ::soda_loop);
	array_thread(GetEntArray("soda_trigger", "targetname"), ::soda_damage);
	
	array_thread(GetEntArray("puddle_trigger", "targetname"), ::step_puddle);
	
	array_thread(GetEntArray("plant_trigger", "targetname"), ::plant);
	
	array_thread(GetEntArray("blind_trigger", "targetname"), ::blind);
	
	array_thread(GetEntArray("computer_cart_trigger", "targetname"), ::computer_cart);
	
	array_thread(GetEntArray("fan1_damage_trigger", "targetname"), ::fan1_loop);
	array_thread(GetEntArray("fan1_damage_trigger", "targetname"), ::fan1_damage);
	array_thread(GetEntArray("fan2_damage_trigger", "targetname"), ::fan2_loop);
	array_thread(GetEntArray("fan2_damage_trigger", "targetname"), ::fan2_damage);

	array_thread(GetEntArray("fence_trigger", "targetname"), ::fence);
	array_thread(GetEntArray("fence_top_trigger", "targetname"), ::fence_top);
	
	array_thread(GetEntArray("air_chatter", "targetname"), ::chatter);
	
	array_thread(GetEntArray("servers", "targetname"), ::pc_loop);
	array_thread(GetEntArray("servers_2", "targetname"), ::server);
	
	
	
	
	
}

//*************************************************************************************************

 

//                                              Functions

 

//*************************************************************************************************

//************ door knock ************

door_knock()

{
	door_knock_org_var = GetEnt("door_knock_org", "targetname");
	level endon ("knock_stop");
	
	wait(25);
	
	while(1)
	{
		
		random_time = randomintrange(2,4);
		door_knock_org_var playsound ("door_knock");
		wait(random_time);

	}
}


door_knock_damage()
{
	door_knock_damage_var = GetEnt("door_knock_damage", "targetname");
	door_knock_org_var = GetEnt("door_knock_org", "targetname");
			
		while (1)
		{
			door_knock_damage_var waittill ("trigger");
			//iprintlnbold ("SOUND: stop knocking");
			level notify( "knock_stop" );
			wait (1.5);
			door_knock_damage_var playsound ("fall_body");		
		}	
}


//************ wand woob ************



wand_woob_loop()
{
	wait(25);
	self playloopsound ("amb_wand");	
}


wand_woob()
{

	self endon("stop_woobing");
	
	wait(25);

	while(1)
	{
		
		random_time = randomfloatrange(1,1.5);
		self playsound ("Amb_Wand_Woob");
		wait(random_time);
	}
}

wand_woob_damage()
{
	
	self waittill ("trigger");
	//iprintlnbold ("SOUND: stop woobing");
	//wand_woob_random_var delete();
	self notify("stop_woobing");
	self stoploopsound();
	self delete();
}


//************ airport pa ************

airport_pa()
{
	self playloopsound ("Airport_PA_Dialog");	
}


crowd()
{
	self playloopsound ("amb_crowd",5);	
	wait(120);
	self stoploopsound();
}

//************ flyovers ************

flyovers()
{

	self endon("stop_flyovers");

	while(1)
	{
		random_time = randomintrange(30,120);
		wait(random_time);
		self playsound ("amb_flyover");
		//iprintlnbold ("SOUND: flyover");
	
	}
}

//************ chatter ************

chatter()
{

	//self endon("stop_chatter");

	while(1)
	{
		random_time = randomintrange(3,10);
		wait(random_time);
		self playsound ("amb_airChatter");
		//iprintlnbold ("SOUND: amb_airChatter");
	
	}
}



//************ sprinkler ************

sprinkler_drip()
{
	self playloopsound ("amb_sprinkler_drip");	

}


sprinkler_drop()
{
	self playloopsound ("amb_sprinkler_drop");	

}

sprinkler()
{
	self playloopsound ("amb_sprinkler");	

}
//************ water tank************

water_tank()
{

	//self endon("stop_tank");

	while(1)
	{
		random_time = randomintrange(5,15);
		wait(random_time);
		self playsound ("AMB_Water_Tank");
		//iprintlnbold ("SOUND: tank gurgle");
	
	}
}

water_tank_loop()
{
	self playloopsound ("amb_water_tank_loop");	

}




water_tank_bump()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			self playsound ("metal_drum");
			//iprintlnbold ("SOUND: metal_drum");
			while ( level.player isTouching(self))
				
			{
			wait 0.1;
			}
	

		}
}

//************ fire alarm ************

fire_alarm_loop()
{
	self playloopsound ("AIR_fire_alarm_1");	
}




//************ copier ************

copier_loop()
{
	self playloopsound ("amb_copier");	
}

//************ computer_cart ************

computer_cart()
{
		
		while (1)
		{
			self waittill ("trigger");
			

			self playsound ("luggage_cart_bump");
			//iprintlnbold ("SOUND: cart noise");
			while ( level.player isTouching(self))
			{
			wait 0.1;
			}
				
		}
		
}

//************ fan1 ************

fan1_loop()
{

	self playloopsound ("amb_fan_1");

}	

	
fan1_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: fan1 damage");
	//self stoploopsound();	
}


//************ printer ************

printer_loop()
{

	self playloopsound ("amb_printer");

}	

	
printer_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: printer damage");
	self stoploopsound();	
}


//************ soda ************

soda_loop()
{

	self playloopsound ("amb_sodaMachine");

}	

	
soda_damage()
{

	self waittill ("trigger");
	self playsound ("soda_machine_dispense");
	//iprintlnbold ("SOUND: soda damage");
	self stoploopsound();	
}




//************ fan2 ************

fan2_loop()
{

	self playloopsound ("amb_fan_2");

}	

	
fan2_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: fan2 damage");
	//self stoploopsound();	
}





//************ pc ************

pc_loop()
{

	self playloopsound ("amb_hardDrive");

}	

	
pc_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: stop ticking");
	self stoploopsound();	
}


server()
{

	self playloopsound ("server");

}




//************ clock ************

clock_loop()
{

	self playloopsound ("amb_clocktick");

}	

	
clock_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: stop ticking");
	self stoploopsound();	
}


//************ phone_ring ************

phone_ring()
{

	self endon("stop_ringing");

	while(1)
	{
		random_time = randomintrange(30,120);
		wait(random_time);
		self playloopsound ("amb_phone");
		//iprintlnbold ("SOUND: phone ringing");
		wait (8.7);
		self stoploopsound();	
	}
}	

	
phone_ring_damage()
{
		
	self waittill ("trigger");
	//iprintlnbold ("SOUND: stop ringing");
	self notify("stop_ringing");
	self stoploopsound();
	self delete();
}

//************ step_puddle ************

step_puddle()
{
	
		while (1)
		{
			self waittill ("trigger");
			
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("step_puddle");
				//iprintlnbold ("SOUND: puddle splash");
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

//************ plant ************

plant()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("plant_shake");
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


//************ blinds ************

blind()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("bump_blind");
				//iprintlnbold ("SOUND: blind rustle");
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

fence_top()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("fence_top_bump");
				//iprintlnbold ("SOUND: fence top");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			}
			
		}
		

	
}

//************ wind ************

helicopter_wind()
{
	self playloopsound ("amb_helicopter_wind");	

}

//*********** catwalk fires ************

/*

catwalk_fires()
{


	fire_one_org = ( -782, 4964, -36 );
	fire_two_org = ( -457, 4905, -38 );
	fire_three_org = ( -333, 4966, -38 );
	fire_four_org = ( -350, 5045, -38 );
	
	while (1)
	{
		level waittill( "str_open_gdoors" );
		playsound("garagedoor");

	}

}	

*/