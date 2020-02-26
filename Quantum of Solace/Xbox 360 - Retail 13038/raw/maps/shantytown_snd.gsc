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

//shantytown_ext_pkg

//***************   

 

            declareAmbientPackage( "shantytown_ext_pkg" );            




           

//************************************************************************************************

//                                              ROOMS

//************************************************************************************************

 //***************
 //shantytown_ext
 //***************
 
             declareAmbientRoom( "shantytown_ext" );
 			setAmbientRoomTone( "shantytown_ext", "amb_bg_shantytown_ext", .5, 1 );
			setAmbientRoomReverb( "shantytown_ext", "city", 1, .9 );

//***************
//amb_bg_shantytown_int
//***************

            declareAmbientRoom( "amb_bg_shantytown_int" );

                        setAmbientRoomTone( "amb_bg_shantytown_int", "amb_bg_shantytown_int", .5, 1 );
			setAmbientRoomReverb( "amb_bg_shantytown_int", "room", 1, .4 );

                

//************************************************************************************************

 

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

 

//************************************************************************************************

 
           setBaseAmbientPackageAndRoom( "shantytown_ext_pkg", "shantytown_ext" );

 

                                    signalAmbientPackageDeclarationComplete();



 

 

 

//*************************************************************************************************
//                                              Static Loops
//*************************************************************************************************



//Cicadas
	loopSound("cicada_loop_01", (143, 1990, 110), 7.343);
	loopSound("cicada_loop_lp_01", (143, 1990, 110), 7.343);
	loopSound("cicada_loop_02", (-2424, 1493, 170), 9.137);
	loopSound("cicada_loop_dist_02", (-2424, 1493, 170), 9.204);
	loopSound("cicada_loop_03", (-2372, -1510, 96), 63.388);
	
//Fires
	loopSound("cooking_fire_01", (-1699, 936, 42), 10.944);



//*************************************************************************************************
//                                              START SCRIPTS
//*************************************************************************************************

 
            
        array_thread(GetEntArray( "fxanim_seagull_circle", "targetname" ), ::seagull);
        array_thread(GetEntArray( "fxanim_window_flap_01", "targetname" ), ::window_flaps);
        array_thread(GetEntArray( "fxanim_window_flap_02", "targetname" ), ::window_flaps);
            
            //array_thread(GetEntArray( "fxanim_banana_banner", "targetname" ), ::test);
            //array_thread(GetEntArray( "fxanim_board_chuck", "targetname" ), ::test);
            //array_thread(GetEntArray( "fxanim_rope_arch", "targetname" ), ::test);
                    
	array_thread(GetEntArray("wood_trigger", "targetname"), ::wood);
	array_thread(GetEntArray("metal_trigger", "targetname"), ::metal); 
	array_thread(GetEntArray("box_trigger", "targetname"), ::box); 
	array_thread(GetEntArray("fence_trigger", "targetname"), ::fence); 
	
	level thread ocean_loop_1();
	array_thread(GetEntArray("shack_radio", "targetname"), ::clock_loop);
	array_thread(GetEntArray("shack_radio", "targetname"), ::clock_damage);

}

 
//*************************************************************************************************
//                                              Functions
//*************************************************************************************************


/************ seagulls ************/
	
seagull()

{
	
	while(1)
	{
		random_time = randomfloatrange(2,12);
		wait(random_time);
		self playsound ("shanty_town_seagull");
		
	}
}


window_flaps()

{
	
	while(1)
	{
		random_time = randomfloatrange(7,10);
		wait(random_time);
		self playsound ("window_flaps");
		
	}
}


test()

{
	
	while(1)
	{
		iprintlnbold("SOUND: something");
		
	}
}

//************ clock ************

clock_loop()
{

	self playloopsound ("amb_radio_tune");

}	

	
clock_damage()
{

	self waittill ("trigger");
	//iprintlnbold ("SOUND: stop ticking");
	self stoploopsound();	
}


ocean_loop_1()
{	
	

	ocean_zone_trigger_var = GetEnt("zone_oceanwaves", "targetname");
	
	if (isDefined(ocean_zone_trigger_var))
	ocean_zone_trigger_var playloopsound ("shanty_ocean");
}

//************ wood ************

wood()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			//{
				self playsound ("wood_bump");
				//iprintlnbold ("SOUND: wood");
				level notify("noise_trigger_wood");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
			//else
			//{
				//iprintlnbold("too soft!");
				//while ( level.player isTouching(self))
				//{
				//wait 0.1;
				//}
			//}
		}
		

	
}


//************ metal ************

metal()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			//{
				self playsound ("metal_bump");
				//iprintlnbold ("SOUND: metal");
				level notify("noise_trigger_metal");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
			//else
			//{
				//iprintlnbold("too soft!");
				//while ( level.player isTouching(self))
				//{
				//wait 0.1;
				//}
			//}
		}
		

	
}


//************ box ************

box()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			//{
				self playsound ("box_bump");
				//iprintlnbold ("SOUND: box");
				level notify("noise_trigger_box");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
			//else
			//{
				//iprintlnbold("too soft!");
				//while ( level.player isTouching(self))
				//{
				//wait 0.1;
				//}
			//}
		}
		

	
}


//************ fence ************

fence()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			//{
				self playsound ("fence_bump");
				//iprintlnbold ("SOUND: fence");
				level notify("noise_trigger_fence");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
			//else
			//{
				//iprintlnbold("too soft!");
				//while ( level.player isTouching(self))
				//{
				//wait 0.1;
				//}
			//}
		}
		

	
}