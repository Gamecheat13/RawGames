

#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;

 
main()

{









 






 

            declareAmbientPackage( "shantytown_ext_pkg" );            




           







 
 
 
 
             declareAmbientRoom( "shantytown_ext" );
 			setAmbientRoomTone( "shantytown_ext", "amb_bg_shantytown_ext", .5, 1 );
			setAmbientRoomReverb( "shantytown_ext", "city", 1, .9 );





            declareAmbientRoom( "amb_bg_shantytown_int" );

                        setAmbientRoomTone( "amb_bg_shantytown_int", "amb_bg_shantytown_int", .5, 1 );
			setAmbientRoomReverb( "amb_bg_shantytown_int", "room", 1, .4 );

                



 



 



 
           setBaseAmbientPackageAndRoom( "shantytown_ext_pkg", "shantytown_ext" );

 

                                    signalAmbientPackageDeclarationComplete();



 

 

 








	loopSound("cicada_loop_01", (143, 1990, 110), 7.343);
	loopSound("cicada_loop_lp_01", (143, 1990, 110), 7.343);
	loopSound("cicada_loop_02", (-2424, 1493, 170), 9.137);
	loopSound("cicada_loop_dist_02", (-2424, 1493, 170), 9.204);
	loopSound("cicada_loop_03", (-2372, -1510, 96), 63.388);
	

	loopSound("cooking_fire_01", (-1699, 936, 42), 10.944);







 
            
            array_thread(GetEntArray( "fxanim_seagull_circle", "targetname" ), ::seagull);
            array_thread(GetEntArray( "fxanim_window_flap_01", "targetname" ), ::window_flaps);
            array_thread(GetEntArray( "fxanim_window_flap_02", "targetname" ), ::window_flaps);


 

}

 






	
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

